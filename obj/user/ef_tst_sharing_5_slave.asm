
obj/user/ef_tst_sharing_5_slave:     file format elf32-i386


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
  800031:	e8 e9 00 00 00       	call   80011f <libmain>
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
  800098:	e8 be 01 00 00       	call   80025b <_panic>
	}

	uint32 *x;
	x = sget(sys_getparentenvid(),"x");
  80009d:	e8 c0 1a 00 00       	call   801b62 <sys_getparentenvid>
  8000a2:	83 ec 08             	sub    $0x8,%esp
  8000a5:	68 1a 32 80 00       	push   $0x80321a
  8000aa:	50                   	push   %eax
  8000ab:	e8 83 15 00 00       	call   801633 <sget>
  8000b0:	83 c4 10             	add    $0x10,%esp
  8000b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int freeFrames = sys_calculate_free_frames() ;
  8000b6:	e8 ae 17 00 00       	call   801869 <sys_calculate_free_frames>
  8000bb:	89 45 e8             	mov    %eax,-0x18(%ebp)

	cprintf("Slave env used x (getSharedObject)\n");
  8000be:	83 ec 0c             	sub    $0xc,%esp
  8000c1:	68 1c 32 80 00       	push   $0x80321c
  8000c6:	e8 44 04 00 00       	call   80050f <cprintf>
  8000cb:	83 c4 10             	add    $0x10,%esp

	sfree(x);
  8000ce:	83 ec 0c             	sub    $0xc,%esp
  8000d1:	ff 75 ec             	pushl  -0x14(%ebp)
  8000d4:	e8 30 16 00 00       	call   801709 <sfree>
  8000d9:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave env removed x\n");
  8000dc:	83 ec 0c             	sub    $0xc,%esp
  8000df:	68 40 32 80 00       	push   $0x803240
  8000e4:	e8 26 04 00 00       	call   80050f <cprintf>
  8000e9:	83 c4 10             	add    $0x10,%esp

	int diff = (sys_calculate_free_frames() - freeFrames);
  8000ec:	e8 78 17 00 00       	call   801869 <sys_calculate_free_frames>
  8000f1:	89 c2                	mov    %eax,%edx
  8000f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000f6:	29 c2                	sub    %eax,%edx
  8000f8:	89 d0                	mov    %edx,%eax
  8000fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (diff != 1) panic("wrong free: frames removed not equal 1 !, correct frames to be removed is 1:\nfrom the env: 1 table for x\nframes_storage: not cleared yet\n");
  8000fd:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  800101:	74 14                	je     800117 <_main+0xdf>
  800103:	83 ec 04             	sub    $0x4,%esp
  800106:	68 58 32 80 00       	push   $0x803258
  80010b:	6a 1f                	push   $0x1f
  80010d:	68 fc 31 80 00       	push   $0x8031fc
  800112:	e8 44 01 00 00       	call   80025b <_panic>

	//to ensure that this environment is completed successfully
	inctst();
  800117:	e8 6b 1b 00 00       	call   801c87 <inctst>

	return;
  80011c:	90                   	nop
}
  80011d:	c9                   	leave  
  80011e:	c3                   	ret    

0080011f <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80011f:	55                   	push   %ebp
  800120:	89 e5                	mov    %esp,%ebp
  800122:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800125:	e8 1f 1a 00 00       	call   801b49 <sys_getenvindex>
  80012a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80012d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800130:	89 d0                	mov    %edx,%eax
  800132:	c1 e0 03             	shl    $0x3,%eax
  800135:	01 d0                	add    %edx,%eax
  800137:	01 c0                	add    %eax,%eax
  800139:	01 d0                	add    %edx,%eax
  80013b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800142:	01 d0                	add    %edx,%eax
  800144:	c1 e0 04             	shl    $0x4,%eax
  800147:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80014c:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800151:	a1 20 40 80 00       	mov    0x804020,%eax
  800156:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80015c:	84 c0                	test   %al,%al
  80015e:	74 0f                	je     80016f <libmain+0x50>
		binaryname = myEnv->prog_name;
  800160:	a1 20 40 80 00       	mov    0x804020,%eax
  800165:	05 5c 05 00 00       	add    $0x55c,%eax
  80016a:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80016f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800173:	7e 0a                	jle    80017f <libmain+0x60>
		binaryname = argv[0];
  800175:	8b 45 0c             	mov    0xc(%ebp),%eax
  800178:	8b 00                	mov    (%eax),%eax
  80017a:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  80017f:	83 ec 08             	sub    $0x8,%esp
  800182:	ff 75 0c             	pushl  0xc(%ebp)
  800185:	ff 75 08             	pushl  0x8(%ebp)
  800188:	e8 ab fe ff ff       	call   800038 <_main>
  80018d:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800190:	e8 c1 17 00 00       	call   801956 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800195:	83 ec 0c             	sub    $0xc,%esp
  800198:	68 fc 32 80 00       	push   $0x8032fc
  80019d:	e8 6d 03 00 00       	call   80050f <cprintf>
  8001a2:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001a5:	a1 20 40 80 00       	mov    0x804020,%eax
  8001aa:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8001b0:	a1 20 40 80 00       	mov    0x804020,%eax
  8001b5:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8001bb:	83 ec 04             	sub    $0x4,%esp
  8001be:	52                   	push   %edx
  8001bf:	50                   	push   %eax
  8001c0:	68 24 33 80 00       	push   $0x803324
  8001c5:	e8 45 03 00 00       	call   80050f <cprintf>
  8001ca:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001cd:	a1 20 40 80 00       	mov    0x804020,%eax
  8001d2:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8001d8:	a1 20 40 80 00       	mov    0x804020,%eax
  8001dd:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8001e3:	a1 20 40 80 00       	mov    0x804020,%eax
  8001e8:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8001ee:	51                   	push   %ecx
  8001ef:	52                   	push   %edx
  8001f0:	50                   	push   %eax
  8001f1:	68 4c 33 80 00       	push   $0x80334c
  8001f6:	e8 14 03 00 00       	call   80050f <cprintf>
  8001fb:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001fe:	a1 20 40 80 00       	mov    0x804020,%eax
  800203:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800209:	83 ec 08             	sub    $0x8,%esp
  80020c:	50                   	push   %eax
  80020d:	68 a4 33 80 00       	push   $0x8033a4
  800212:	e8 f8 02 00 00       	call   80050f <cprintf>
  800217:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80021a:	83 ec 0c             	sub    $0xc,%esp
  80021d:	68 fc 32 80 00       	push   $0x8032fc
  800222:	e8 e8 02 00 00       	call   80050f <cprintf>
  800227:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80022a:	e8 41 17 00 00       	call   801970 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80022f:	e8 19 00 00 00       	call   80024d <exit>
}
  800234:	90                   	nop
  800235:	c9                   	leave  
  800236:	c3                   	ret    

00800237 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800237:	55                   	push   %ebp
  800238:	89 e5                	mov    %esp,%ebp
  80023a:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80023d:	83 ec 0c             	sub    $0xc,%esp
  800240:	6a 00                	push   $0x0
  800242:	e8 ce 18 00 00       	call   801b15 <sys_destroy_env>
  800247:	83 c4 10             	add    $0x10,%esp
}
  80024a:	90                   	nop
  80024b:	c9                   	leave  
  80024c:	c3                   	ret    

0080024d <exit>:

void
exit(void)
{
  80024d:	55                   	push   %ebp
  80024e:	89 e5                	mov    %esp,%ebp
  800250:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800253:	e8 23 19 00 00       	call   801b7b <sys_exit_env>
}
  800258:	90                   	nop
  800259:	c9                   	leave  
  80025a:	c3                   	ret    

0080025b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80025b:	55                   	push   %ebp
  80025c:	89 e5                	mov    %esp,%ebp
  80025e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800261:	8d 45 10             	lea    0x10(%ebp),%eax
  800264:	83 c0 04             	add    $0x4,%eax
  800267:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80026a:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80026f:	85 c0                	test   %eax,%eax
  800271:	74 16                	je     800289 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800273:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800278:	83 ec 08             	sub    $0x8,%esp
  80027b:	50                   	push   %eax
  80027c:	68 b8 33 80 00       	push   $0x8033b8
  800281:	e8 89 02 00 00       	call   80050f <cprintf>
  800286:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800289:	a1 00 40 80 00       	mov    0x804000,%eax
  80028e:	ff 75 0c             	pushl  0xc(%ebp)
  800291:	ff 75 08             	pushl  0x8(%ebp)
  800294:	50                   	push   %eax
  800295:	68 bd 33 80 00       	push   $0x8033bd
  80029a:	e8 70 02 00 00       	call   80050f <cprintf>
  80029f:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8002a5:	83 ec 08             	sub    $0x8,%esp
  8002a8:	ff 75 f4             	pushl  -0xc(%ebp)
  8002ab:	50                   	push   %eax
  8002ac:	e8 f3 01 00 00       	call   8004a4 <vcprintf>
  8002b1:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002b4:	83 ec 08             	sub    $0x8,%esp
  8002b7:	6a 00                	push   $0x0
  8002b9:	68 d9 33 80 00       	push   $0x8033d9
  8002be:	e8 e1 01 00 00       	call   8004a4 <vcprintf>
  8002c3:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002c6:	e8 82 ff ff ff       	call   80024d <exit>

	// should not return here
	while (1) ;
  8002cb:	eb fe                	jmp    8002cb <_panic+0x70>

008002cd <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002cd:	55                   	push   %ebp
  8002ce:	89 e5                	mov    %esp,%ebp
  8002d0:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002d3:	a1 20 40 80 00       	mov    0x804020,%eax
  8002d8:	8b 50 74             	mov    0x74(%eax),%edx
  8002db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002de:	39 c2                	cmp    %eax,%edx
  8002e0:	74 14                	je     8002f6 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8002e2:	83 ec 04             	sub    $0x4,%esp
  8002e5:	68 dc 33 80 00       	push   $0x8033dc
  8002ea:	6a 26                	push   $0x26
  8002ec:	68 28 34 80 00       	push   $0x803428
  8002f1:	e8 65 ff ff ff       	call   80025b <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8002f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8002fd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800304:	e9 c2 00 00 00       	jmp    8003cb <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800309:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80030c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800313:	8b 45 08             	mov    0x8(%ebp),%eax
  800316:	01 d0                	add    %edx,%eax
  800318:	8b 00                	mov    (%eax),%eax
  80031a:	85 c0                	test   %eax,%eax
  80031c:	75 08                	jne    800326 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80031e:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800321:	e9 a2 00 00 00       	jmp    8003c8 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800326:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80032d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800334:	eb 69                	jmp    80039f <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800336:	a1 20 40 80 00       	mov    0x804020,%eax
  80033b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800341:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800344:	89 d0                	mov    %edx,%eax
  800346:	01 c0                	add    %eax,%eax
  800348:	01 d0                	add    %edx,%eax
  80034a:	c1 e0 03             	shl    $0x3,%eax
  80034d:	01 c8                	add    %ecx,%eax
  80034f:	8a 40 04             	mov    0x4(%eax),%al
  800352:	84 c0                	test   %al,%al
  800354:	75 46                	jne    80039c <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800356:	a1 20 40 80 00       	mov    0x804020,%eax
  80035b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800361:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800364:	89 d0                	mov    %edx,%eax
  800366:	01 c0                	add    %eax,%eax
  800368:	01 d0                	add    %edx,%eax
  80036a:	c1 e0 03             	shl    $0x3,%eax
  80036d:	01 c8                	add    %ecx,%eax
  80036f:	8b 00                	mov    (%eax),%eax
  800371:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800374:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800377:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80037c:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80037e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800381:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800388:	8b 45 08             	mov    0x8(%ebp),%eax
  80038b:	01 c8                	add    %ecx,%eax
  80038d:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80038f:	39 c2                	cmp    %eax,%edx
  800391:	75 09                	jne    80039c <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800393:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80039a:	eb 12                	jmp    8003ae <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80039c:	ff 45 e8             	incl   -0x18(%ebp)
  80039f:	a1 20 40 80 00       	mov    0x804020,%eax
  8003a4:	8b 50 74             	mov    0x74(%eax),%edx
  8003a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003aa:	39 c2                	cmp    %eax,%edx
  8003ac:	77 88                	ja     800336 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003ae:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003b2:	75 14                	jne    8003c8 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8003b4:	83 ec 04             	sub    $0x4,%esp
  8003b7:	68 34 34 80 00       	push   $0x803434
  8003bc:	6a 3a                	push   $0x3a
  8003be:	68 28 34 80 00       	push   $0x803428
  8003c3:	e8 93 fe ff ff       	call   80025b <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003c8:	ff 45 f0             	incl   -0x10(%ebp)
  8003cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003ce:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003d1:	0f 8c 32 ff ff ff    	jl     800309 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003d7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003de:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8003e5:	eb 26                	jmp    80040d <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8003e7:	a1 20 40 80 00       	mov    0x804020,%eax
  8003ec:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003f2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003f5:	89 d0                	mov    %edx,%eax
  8003f7:	01 c0                	add    %eax,%eax
  8003f9:	01 d0                	add    %edx,%eax
  8003fb:	c1 e0 03             	shl    $0x3,%eax
  8003fe:	01 c8                	add    %ecx,%eax
  800400:	8a 40 04             	mov    0x4(%eax),%al
  800403:	3c 01                	cmp    $0x1,%al
  800405:	75 03                	jne    80040a <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800407:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80040a:	ff 45 e0             	incl   -0x20(%ebp)
  80040d:	a1 20 40 80 00       	mov    0x804020,%eax
  800412:	8b 50 74             	mov    0x74(%eax),%edx
  800415:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800418:	39 c2                	cmp    %eax,%edx
  80041a:	77 cb                	ja     8003e7 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80041c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80041f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800422:	74 14                	je     800438 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800424:	83 ec 04             	sub    $0x4,%esp
  800427:	68 88 34 80 00       	push   $0x803488
  80042c:	6a 44                	push   $0x44
  80042e:	68 28 34 80 00       	push   $0x803428
  800433:	e8 23 fe ff ff       	call   80025b <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800438:	90                   	nop
  800439:	c9                   	leave  
  80043a:	c3                   	ret    

0080043b <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80043b:	55                   	push   %ebp
  80043c:	89 e5                	mov    %esp,%ebp
  80043e:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800441:	8b 45 0c             	mov    0xc(%ebp),%eax
  800444:	8b 00                	mov    (%eax),%eax
  800446:	8d 48 01             	lea    0x1(%eax),%ecx
  800449:	8b 55 0c             	mov    0xc(%ebp),%edx
  80044c:	89 0a                	mov    %ecx,(%edx)
  80044e:	8b 55 08             	mov    0x8(%ebp),%edx
  800451:	88 d1                	mov    %dl,%cl
  800453:	8b 55 0c             	mov    0xc(%ebp),%edx
  800456:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80045a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80045d:	8b 00                	mov    (%eax),%eax
  80045f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800464:	75 2c                	jne    800492 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800466:	a0 24 40 80 00       	mov    0x804024,%al
  80046b:	0f b6 c0             	movzbl %al,%eax
  80046e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800471:	8b 12                	mov    (%edx),%edx
  800473:	89 d1                	mov    %edx,%ecx
  800475:	8b 55 0c             	mov    0xc(%ebp),%edx
  800478:	83 c2 08             	add    $0x8,%edx
  80047b:	83 ec 04             	sub    $0x4,%esp
  80047e:	50                   	push   %eax
  80047f:	51                   	push   %ecx
  800480:	52                   	push   %edx
  800481:	e8 22 13 00 00       	call   8017a8 <sys_cputs>
  800486:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800489:	8b 45 0c             	mov    0xc(%ebp),%eax
  80048c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800492:	8b 45 0c             	mov    0xc(%ebp),%eax
  800495:	8b 40 04             	mov    0x4(%eax),%eax
  800498:	8d 50 01             	lea    0x1(%eax),%edx
  80049b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80049e:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004a1:	90                   	nop
  8004a2:	c9                   	leave  
  8004a3:	c3                   	ret    

008004a4 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004a4:	55                   	push   %ebp
  8004a5:	89 e5                	mov    %esp,%ebp
  8004a7:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004ad:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004b4:	00 00 00 
	b.cnt = 0;
  8004b7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004be:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004c1:	ff 75 0c             	pushl  0xc(%ebp)
  8004c4:	ff 75 08             	pushl  0x8(%ebp)
  8004c7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004cd:	50                   	push   %eax
  8004ce:	68 3b 04 80 00       	push   $0x80043b
  8004d3:	e8 11 02 00 00       	call   8006e9 <vprintfmt>
  8004d8:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8004db:	a0 24 40 80 00       	mov    0x804024,%al
  8004e0:	0f b6 c0             	movzbl %al,%eax
  8004e3:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8004e9:	83 ec 04             	sub    $0x4,%esp
  8004ec:	50                   	push   %eax
  8004ed:	52                   	push   %edx
  8004ee:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004f4:	83 c0 08             	add    $0x8,%eax
  8004f7:	50                   	push   %eax
  8004f8:	e8 ab 12 00 00       	call   8017a8 <sys_cputs>
  8004fd:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800500:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800507:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80050d:	c9                   	leave  
  80050e:	c3                   	ret    

0080050f <cprintf>:

int cprintf(const char *fmt, ...) {
  80050f:	55                   	push   %ebp
  800510:	89 e5                	mov    %esp,%ebp
  800512:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800515:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  80051c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80051f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800522:	8b 45 08             	mov    0x8(%ebp),%eax
  800525:	83 ec 08             	sub    $0x8,%esp
  800528:	ff 75 f4             	pushl  -0xc(%ebp)
  80052b:	50                   	push   %eax
  80052c:	e8 73 ff ff ff       	call   8004a4 <vcprintf>
  800531:	83 c4 10             	add    $0x10,%esp
  800534:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800537:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80053a:	c9                   	leave  
  80053b:	c3                   	ret    

0080053c <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80053c:	55                   	push   %ebp
  80053d:	89 e5                	mov    %esp,%ebp
  80053f:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800542:	e8 0f 14 00 00       	call   801956 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800547:	8d 45 0c             	lea    0xc(%ebp),%eax
  80054a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80054d:	8b 45 08             	mov    0x8(%ebp),%eax
  800550:	83 ec 08             	sub    $0x8,%esp
  800553:	ff 75 f4             	pushl  -0xc(%ebp)
  800556:	50                   	push   %eax
  800557:	e8 48 ff ff ff       	call   8004a4 <vcprintf>
  80055c:	83 c4 10             	add    $0x10,%esp
  80055f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800562:	e8 09 14 00 00       	call   801970 <sys_enable_interrupt>
	return cnt;
  800567:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80056a:	c9                   	leave  
  80056b:	c3                   	ret    

0080056c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80056c:	55                   	push   %ebp
  80056d:	89 e5                	mov    %esp,%ebp
  80056f:	53                   	push   %ebx
  800570:	83 ec 14             	sub    $0x14,%esp
  800573:	8b 45 10             	mov    0x10(%ebp),%eax
  800576:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800579:	8b 45 14             	mov    0x14(%ebp),%eax
  80057c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80057f:	8b 45 18             	mov    0x18(%ebp),%eax
  800582:	ba 00 00 00 00       	mov    $0x0,%edx
  800587:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80058a:	77 55                	ja     8005e1 <printnum+0x75>
  80058c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80058f:	72 05                	jb     800596 <printnum+0x2a>
  800591:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800594:	77 4b                	ja     8005e1 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800596:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800599:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80059c:	8b 45 18             	mov    0x18(%ebp),%eax
  80059f:	ba 00 00 00 00       	mov    $0x0,%edx
  8005a4:	52                   	push   %edx
  8005a5:	50                   	push   %eax
  8005a6:	ff 75 f4             	pushl  -0xc(%ebp)
  8005a9:	ff 75 f0             	pushl  -0x10(%ebp)
  8005ac:	e8 b3 29 00 00       	call   802f64 <__udivdi3>
  8005b1:	83 c4 10             	add    $0x10,%esp
  8005b4:	83 ec 04             	sub    $0x4,%esp
  8005b7:	ff 75 20             	pushl  0x20(%ebp)
  8005ba:	53                   	push   %ebx
  8005bb:	ff 75 18             	pushl  0x18(%ebp)
  8005be:	52                   	push   %edx
  8005bf:	50                   	push   %eax
  8005c0:	ff 75 0c             	pushl  0xc(%ebp)
  8005c3:	ff 75 08             	pushl  0x8(%ebp)
  8005c6:	e8 a1 ff ff ff       	call   80056c <printnum>
  8005cb:	83 c4 20             	add    $0x20,%esp
  8005ce:	eb 1a                	jmp    8005ea <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005d0:	83 ec 08             	sub    $0x8,%esp
  8005d3:	ff 75 0c             	pushl  0xc(%ebp)
  8005d6:	ff 75 20             	pushl  0x20(%ebp)
  8005d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8005dc:	ff d0                	call   *%eax
  8005de:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005e1:	ff 4d 1c             	decl   0x1c(%ebp)
  8005e4:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8005e8:	7f e6                	jg     8005d0 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005ea:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8005ed:	bb 00 00 00 00       	mov    $0x0,%ebx
  8005f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005f8:	53                   	push   %ebx
  8005f9:	51                   	push   %ecx
  8005fa:	52                   	push   %edx
  8005fb:	50                   	push   %eax
  8005fc:	e8 73 2a 00 00       	call   803074 <__umoddi3>
  800601:	83 c4 10             	add    $0x10,%esp
  800604:	05 f4 36 80 00       	add    $0x8036f4,%eax
  800609:	8a 00                	mov    (%eax),%al
  80060b:	0f be c0             	movsbl %al,%eax
  80060e:	83 ec 08             	sub    $0x8,%esp
  800611:	ff 75 0c             	pushl  0xc(%ebp)
  800614:	50                   	push   %eax
  800615:	8b 45 08             	mov    0x8(%ebp),%eax
  800618:	ff d0                	call   *%eax
  80061a:	83 c4 10             	add    $0x10,%esp
}
  80061d:	90                   	nop
  80061e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800621:	c9                   	leave  
  800622:	c3                   	ret    

00800623 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800623:	55                   	push   %ebp
  800624:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800626:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80062a:	7e 1c                	jle    800648 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80062c:	8b 45 08             	mov    0x8(%ebp),%eax
  80062f:	8b 00                	mov    (%eax),%eax
  800631:	8d 50 08             	lea    0x8(%eax),%edx
  800634:	8b 45 08             	mov    0x8(%ebp),%eax
  800637:	89 10                	mov    %edx,(%eax)
  800639:	8b 45 08             	mov    0x8(%ebp),%eax
  80063c:	8b 00                	mov    (%eax),%eax
  80063e:	83 e8 08             	sub    $0x8,%eax
  800641:	8b 50 04             	mov    0x4(%eax),%edx
  800644:	8b 00                	mov    (%eax),%eax
  800646:	eb 40                	jmp    800688 <getuint+0x65>
	else if (lflag)
  800648:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80064c:	74 1e                	je     80066c <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80064e:	8b 45 08             	mov    0x8(%ebp),%eax
  800651:	8b 00                	mov    (%eax),%eax
  800653:	8d 50 04             	lea    0x4(%eax),%edx
  800656:	8b 45 08             	mov    0x8(%ebp),%eax
  800659:	89 10                	mov    %edx,(%eax)
  80065b:	8b 45 08             	mov    0x8(%ebp),%eax
  80065e:	8b 00                	mov    (%eax),%eax
  800660:	83 e8 04             	sub    $0x4,%eax
  800663:	8b 00                	mov    (%eax),%eax
  800665:	ba 00 00 00 00       	mov    $0x0,%edx
  80066a:	eb 1c                	jmp    800688 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80066c:	8b 45 08             	mov    0x8(%ebp),%eax
  80066f:	8b 00                	mov    (%eax),%eax
  800671:	8d 50 04             	lea    0x4(%eax),%edx
  800674:	8b 45 08             	mov    0x8(%ebp),%eax
  800677:	89 10                	mov    %edx,(%eax)
  800679:	8b 45 08             	mov    0x8(%ebp),%eax
  80067c:	8b 00                	mov    (%eax),%eax
  80067e:	83 e8 04             	sub    $0x4,%eax
  800681:	8b 00                	mov    (%eax),%eax
  800683:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800688:	5d                   	pop    %ebp
  800689:	c3                   	ret    

0080068a <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80068a:	55                   	push   %ebp
  80068b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80068d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800691:	7e 1c                	jle    8006af <getint+0x25>
		return va_arg(*ap, long long);
  800693:	8b 45 08             	mov    0x8(%ebp),%eax
  800696:	8b 00                	mov    (%eax),%eax
  800698:	8d 50 08             	lea    0x8(%eax),%edx
  80069b:	8b 45 08             	mov    0x8(%ebp),%eax
  80069e:	89 10                	mov    %edx,(%eax)
  8006a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a3:	8b 00                	mov    (%eax),%eax
  8006a5:	83 e8 08             	sub    $0x8,%eax
  8006a8:	8b 50 04             	mov    0x4(%eax),%edx
  8006ab:	8b 00                	mov    (%eax),%eax
  8006ad:	eb 38                	jmp    8006e7 <getint+0x5d>
	else if (lflag)
  8006af:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006b3:	74 1a                	je     8006cf <getint+0x45>
		return va_arg(*ap, long);
  8006b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b8:	8b 00                	mov    (%eax),%eax
  8006ba:	8d 50 04             	lea    0x4(%eax),%edx
  8006bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c0:	89 10                	mov    %edx,(%eax)
  8006c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c5:	8b 00                	mov    (%eax),%eax
  8006c7:	83 e8 04             	sub    $0x4,%eax
  8006ca:	8b 00                	mov    (%eax),%eax
  8006cc:	99                   	cltd   
  8006cd:	eb 18                	jmp    8006e7 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d2:	8b 00                	mov    (%eax),%eax
  8006d4:	8d 50 04             	lea    0x4(%eax),%edx
  8006d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006da:	89 10                	mov    %edx,(%eax)
  8006dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006df:	8b 00                	mov    (%eax),%eax
  8006e1:	83 e8 04             	sub    $0x4,%eax
  8006e4:	8b 00                	mov    (%eax),%eax
  8006e6:	99                   	cltd   
}
  8006e7:	5d                   	pop    %ebp
  8006e8:	c3                   	ret    

008006e9 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006e9:	55                   	push   %ebp
  8006ea:	89 e5                	mov    %esp,%ebp
  8006ec:	56                   	push   %esi
  8006ed:	53                   	push   %ebx
  8006ee:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006f1:	eb 17                	jmp    80070a <vprintfmt+0x21>
			if (ch == '\0')
  8006f3:	85 db                	test   %ebx,%ebx
  8006f5:	0f 84 af 03 00 00    	je     800aaa <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8006fb:	83 ec 08             	sub    $0x8,%esp
  8006fe:	ff 75 0c             	pushl  0xc(%ebp)
  800701:	53                   	push   %ebx
  800702:	8b 45 08             	mov    0x8(%ebp),%eax
  800705:	ff d0                	call   *%eax
  800707:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80070a:	8b 45 10             	mov    0x10(%ebp),%eax
  80070d:	8d 50 01             	lea    0x1(%eax),%edx
  800710:	89 55 10             	mov    %edx,0x10(%ebp)
  800713:	8a 00                	mov    (%eax),%al
  800715:	0f b6 d8             	movzbl %al,%ebx
  800718:	83 fb 25             	cmp    $0x25,%ebx
  80071b:	75 d6                	jne    8006f3 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80071d:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800721:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800728:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80072f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800736:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80073d:	8b 45 10             	mov    0x10(%ebp),%eax
  800740:	8d 50 01             	lea    0x1(%eax),%edx
  800743:	89 55 10             	mov    %edx,0x10(%ebp)
  800746:	8a 00                	mov    (%eax),%al
  800748:	0f b6 d8             	movzbl %al,%ebx
  80074b:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80074e:	83 f8 55             	cmp    $0x55,%eax
  800751:	0f 87 2b 03 00 00    	ja     800a82 <vprintfmt+0x399>
  800757:	8b 04 85 18 37 80 00 	mov    0x803718(,%eax,4),%eax
  80075e:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800760:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800764:	eb d7                	jmp    80073d <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800766:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80076a:	eb d1                	jmp    80073d <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80076c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800773:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800776:	89 d0                	mov    %edx,%eax
  800778:	c1 e0 02             	shl    $0x2,%eax
  80077b:	01 d0                	add    %edx,%eax
  80077d:	01 c0                	add    %eax,%eax
  80077f:	01 d8                	add    %ebx,%eax
  800781:	83 e8 30             	sub    $0x30,%eax
  800784:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800787:	8b 45 10             	mov    0x10(%ebp),%eax
  80078a:	8a 00                	mov    (%eax),%al
  80078c:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80078f:	83 fb 2f             	cmp    $0x2f,%ebx
  800792:	7e 3e                	jle    8007d2 <vprintfmt+0xe9>
  800794:	83 fb 39             	cmp    $0x39,%ebx
  800797:	7f 39                	jg     8007d2 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800799:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80079c:	eb d5                	jmp    800773 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80079e:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a1:	83 c0 04             	add    $0x4,%eax
  8007a4:	89 45 14             	mov    %eax,0x14(%ebp)
  8007a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007aa:	83 e8 04             	sub    $0x4,%eax
  8007ad:	8b 00                	mov    (%eax),%eax
  8007af:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007b2:	eb 1f                	jmp    8007d3 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007b4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007b8:	79 83                	jns    80073d <vprintfmt+0x54>
				width = 0;
  8007ba:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007c1:	e9 77 ff ff ff       	jmp    80073d <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007c6:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007cd:	e9 6b ff ff ff       	jmp    80073d <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007d2:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007d3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007d7:	0f 89 60 ff ff ff    	jns    80073d <vprintfmt+0x54>
				width = precision, precision = -1;
  8007dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007e3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8007ea:	e9 4e ff ff ff       	jmp    80073d <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8007ef:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8007f2:	e9 46 ff ff ff       	jmp    80073d <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8007f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fa:	83 c0 04             	add    $0x4,%eax
  8007fd:	89 45 14             	mov    %eax,0x14(%ebp)
  800800:	8b 45 14             	mov    0x14(%ebp),%eax
  800803:	83 e8 04             	sub    $0x4,%eax
  800806:	8b 00                	mov    (%eax),%eax
  800808:	83 ec 08             	sub    $0x8,%esp
  80080b:	ff 75 0c             	pushl  0xc(%ebp)
  80080e:	50                   	push   %eax
  80080f:	8b 45 08             	mov    0x8(%ebp),%eax
  800812:	ff d0                	call   *%eax
  800814:	83 c4 10             	add    $0x10,%esp
			break;
  800817:	e9 89 02 00 00       	jmp    800aa5 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80081c:	8b 45 14             	mov    0x14(%ebp),%eax
  80081f:	83 c0 04             	add    $0x4,%eax
  800822:	89 45 14             	mov    %eax,0x14(%ebp)
  800825:	8b 45 14             	mov    0x14(%ebp),%eax
  800828:	83 e8 04             	sub    $0x4,%eax
  80082b:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80082d:	85 db                	test   %ebx,%ebx
  80082f:	79 02                	jns    800833 <vprintfmt+0x14a>
				err = -err;
  800831:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800833:	83 fb 64             	cmp    $0x64,%ebx
  800836:	7f 0b                	jg     800843 <vprintfmt+0x15a>
  800838:	8b 34 9d 60 35 80 00 	mov    0x803560(,%ebx,4),%esi
  80083f:	85 f6                	test   %esi,%esi
  800841:	75 19                	jne    80085c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800843:	53                   	push   %ebx
  800844:	68 05 37 80 00       	push   $0x803705
  800849:	ff 75 0c             	pushl  0xc(%ebp)
  80084c:	ff 75 08             	pushl  0x8(%ebp)
  80084f:	e8 5e 02 00 00       	call   800ab2 <printfmt>
  800854:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800857:	e9 49 02 00 00       	jmp    800aa5 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80085c:	56                   	push   %esi
  80085d:	68 0e 37 80 00       	push   $0x80370e
  800862:	ff 75 0c             	pushl  0xc(%ebp)
  800865:	ff 75 08             	pushl  0x8(%ebp)
  800868:	e8 45 02 00 00       	call   800ab2 <printfmt>
  80086d:	83 c4 10             	add    $0x10,%esp
			break;
  800870:	e9 30 02 00 00       	jmp    800aa5 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800875:	8b 45 14             	mov    0x14(%ebp),%eax
  800878:	83 c0 04             	add    $0x4,%eax
  80087b:	89 45 14             	mov    %eax,0x14(%ebp)
  80087e:	8b 45 14             	mov    0x14(%ebp),%eax
  800881:	83 e8 04             	sub    $0x4,%eax
  800884:	8b 30                	mov    (%eax),%esi
  800886:	85 f6                	test   %esi,%esi
  800888:	75 05                	jne    80088f <vprintfmt+0x1a6>
				p = "(null)";
  80088a:	be 11 37 80 00       	mov    $0x803711,%esi
			if (width > 0 && padc != '-')
  80088f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800893:	7e 6d                	jle    800902 <vprintfmt+0x219>
  800895:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800899:	74 67                	je     800902 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80089b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80089e:	83 ec 08             	sub    $0x8,%esp
  8008a1:	50                   	push   %eax
  8008a2:	56                   	push   %esi
  8008a3:	e8 0c 03 00 00       	call   800bb4 <strnlen>
  8008a8:	83 c4 10             	add    $0x10,%esp
  8008ab:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008ae:	eb 16                	jmp    8008c6 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008b0:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008b4:	83 ec 08             	sub    $0x8,%esp
  8008b7:	ff 75 0c             	pushl  0xc(%ebp)
  8008ba:	50                   	push   %eax
  8008bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008be:	ff d0                	call   *%eax
  8008c0:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008c3:	ff 4d e4             	decl   -0x1c(%ebp)
  8008c6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ca:	7f e4                	jg     8008b0 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008cc:	eb 34                	jmp    800902 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008ce:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008d2:	74 1c                	je     8008f0 <vprintfmt+0x207>
  8008d4:	83 fb 1f             	cmp    $0x1f,%ebx
  8008d7:	7e 05                	jle    8008de <vprintfmt+0x1f5>
  8008d9:	83 fb 7e             	cmp    $0x7e,%ebx
  8008dc:	7e 12                	jle    8008f0 <vprintfmt+0x207>
					putch('?', putdat);
  8008de:	83 ec 08             	sub    $0x8,%esp
  8008e1:	ff 75 0c             	pushl  0xc(%ebp)
  8008e4:	6a 3f                	push   $0x3f
  8008e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e9:	ff d0                	call   *%eax
  8008eb:	83 c4 10             	add    $0x10,%esp
  8008ee:	eb 0f                	jmp    8008ff <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8008f0:	83 ec 08             	sub    $0x8,%esp
  8008f3:	ff 75 0c             	pushl  0xc(%ebp)
  8008f6:	53                   	push   %ebx
  8008f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fa:	ff d0                	call   *%eax
  8008fc:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008ff:	ff 4d e4             	decl   -0x1c(%ebp)
  800902:	89 f0                	mov    %esi,%eax
  800904:	8d 70 01             	lea    0x1(%eax),%esi
  800907:	8a 00                	mov    (%eax),%al
  800909:	0f be d8             	movsbl %al,%ebx
  80090c:	85 db                	test   %ebx,%ebx
  80090e:	74 24                	je     800934 <vprintfmt+0x24b>
  800910:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800914:	78 b8                	js     8008ce <vprintfmt+0x1e5>
  800916:	ff 4d e0             	decl   -0x20(%ebp)
  800919:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80091d:	79 af                	jns    8008ce <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80091f:	eb 13                	jmp    800934 <vprintfmt+0x24b>
				putch(' ', putdat);
  800921:	83 ec 08             	sub    $0x8,%esp
  800924:	ff 75 0c             	pushl  0xc(%ebp)
  800927:	6a 20                	push   $0x20
  800929:	8b 45 08             	mov    0x8(%ebp),%eax
  80092c:	ff d0                	call   *%eax
  80092e:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800931:	ff 4d e4             	decl   -0x1c(%ebp)
  800934:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800938:	7f e7                	jg     800921 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80093a:	e9 66 01 00 00       	jmp    800aa5 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80093f:	83 ec 08             	sub    $0x8,%esp
  800942:	ff 75 e8             	pushl  -0x18(%ebp)
  800945:	8d 45 14             	lea    0x14(%ebp),%eax
  800948:	50                   	push   %eax
  800949:	e8 3c fd ff ff       	call   80068a <getint>
  80094e:	83 c4 10             	add    $0x10,%esp
  800951:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800954:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800957:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80095a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80095d:	85 d2                	test   %edx,%edx
  80095f:	79 23                	jns    800984 <vprintfmt+0x29b>
				putch('-', putdat);
  800961:	83 ec 08             	sub    $0x8,%esp
  800964:	ff 75 0c             	pushl  0xc(%ebp)
  800967:	6a 2d                	push   $0x2d
  800969:	8b 45 08             	mov    0x8(%ebp),%eax
  80096c:	ff d0                	call   *%eax
  80096e:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800971:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800974:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800977:	f7 d8                	neg    %eax
  800979:	83 d2 00             	adc    $0x0,%edx
  80097c:	f7 da                	neg    %edx
  80097e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800981:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800984:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80098b:	e9 bc 00 00 00       	jmp    800a4c <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800990:	83 ec 08             	sub    $0x8,%esp
  800993:	ff 75 e8             	pushl  -0x18(%ebp)
  800996:	8d 45 14             	lea    0x14(%ebp),%eax
  800999:	50                   	push   %eax
  80099a:	e8 84 fc ff ff       	call   800623 <getuint>
  80099f:	83 c4 10             	add    $0x10,%esp
  8009a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009a5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009a8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009af:	e9 98 00 00 00       	jmp    800a4c <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009b4:	83 ec 08             	sub    $0x8,%esp
  8009b7:	ff 75 0c             	pushl  0xc(%ebp)
  8009ba:	6a 58                	push   $0x58
  8009bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bf:	ff d0                	call   *%eax
  8009c1:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009c4:	83 ec 08             	sub    $0x8,%esp
  8009c7:	ff 75 0c             	pushl  0xc(%ebp)
  8009ca:	6a 58                	push   $0x58
  8009cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cf:	ff d0                	call   *%eax
  8009d1:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009d4:	83 ec 08             	sub    $0x8,%esp
  8009d7:	ff 75 0c             	pushl  0xc(%ebp)
  8009da:	6a 58                	push   $0x58
  8009dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009df:	ff d0                	call   *%eax
  8009e1:	83 c4 10             	add    $0x10,%esp
			break;
  8009e4:	e9 bc 00 00 00       	jmp    800aa5 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8009e9:	83 ec 08             	sub    $0x8,%esp
  8009ec:	ff 75 0c             	pushl  0xc(%ebp)
  8009ef:	6a 30                	push   $0x30
  8009f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f4:	ff d0                	call   *%eax
  8009f6:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8009f9:	83 ec 08             	sub    $0x8,%esp
  8009fc:	ff 75 0c             	pushl  0xc(%ebp)
  8009ff:	6a 78                	push   $0x78
  800a01:	8b 45 08             	mov    0x8(%ebp),%eax
  800a04:	ff d0                	call   *%eax
  800a06:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a09:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0c:	83 c0 04             	add    $0x4,%eax
  800a0f:	89 45 14             	mov    %eax,0x14(%ebp)
  800a12:	8b 45 14             	mov    0x14(%ebp),%eax
  800a15:	83 e8 04             	sub    $0x4,%eax
  800a18:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a1d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a24:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a2b:	eb 1f                	jmp    800a4c <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a2d:	83 ec 08             	sub    $0x8,%esp
  800a30:	ff 75 e8             	pushl  -0x18(%ebp)
  800a33:	8d 45 14             	lea    0x14(%ebp),%eax
  800a36:	50                   	push   %eax
  800a37:	e8 e7 fb ff ff       	call   800623 <getuint>
  800a3c:	83 c4 10             	add    $0x10,%esp
  800a3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a42:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a45:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a4c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a50:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a53:	83 ec 04             	sub    $0x4,%esp
  800a56:	52                   	push   %edx
  800a57:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a5a:	50                   	push   %eax
  800a5b:	ff 75 f4             	pushl  -0xc(%ebp)
  800a5e:	ff 75 f0             	pushl  -0x10(%ebp)
  800a61:	ff 75 0c             	pushl  0xc(%ebp)
  800a64:	ff 75 08             	pushl  0x8(%ebp)
  800a67:	e8 00 fb ff ff       	call   80056c <printnum>
  800a6c:	83 c4 20             	add    $0x20,%esp
			break;
  800a6f:	eb 34                	jmp    800aa5 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a71:	83 ec 08             	sub    $0x8,%esp
  800a74:	ff 75 0c             	pushl  0xc(%ebp)
  800a77:	53                   	push   %ebx
  800a78:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7b:	ff d0                	call   *%eax
  800a7d:	83 c4 10             	add    $0x10,%esp
			break;
  800a80:	eb 23                	jmp    800aa5 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a82:	83 ec 08             	sub    $0x8,%esp
  800a85:	ff 75 0c             	pushl  0xc(%ebp)
  800a88:	6a 25                	push   $0x25
  800a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8d:	ff d0                	call   *%eax
  800a8f:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a92:	ff 4d 10             	decl   0x10(%ebp)
  800a95:	eb 03                	jmp    800a9a <vprintfmt+0x3b1>
  800a97:	ff 4d 10             	decl   0x10(%ebp)
  800a9a:	8b 45 10             	mov    0x10(%ebp),%eax
  800a9d:	48                   	dec    %eax
  800a9e:	8a 00                	mov    (%eax),%al
  800aa0:	3c 25                	cmp    $0x25,%al
  800aa2:	75 f3                	jne    800a97 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800aa4:	90                   	nop
		}
	}
  800aa5:	e9 47 fc ff ff       	jmp    8006f1 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800aaa:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800aab:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800aae:	5b                   	pop    %ebx
  800aaf:	5e                   	pop    %esi
  800ab0:	5d                   	pop    %ebp
  800ab1:	c3                   	ret    

00800ab2 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ab2:	55                   	push   %ebp
  800ab3:	89 e5                	mov    %esp,%ebp
  800ab5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ab8:	8d 45 10             	lea    0x10(%ebp),%eax
  800abb:	83 c0 04             	add    $0x4,%eax
  800abe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ac1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ac4:	ff 75 f4             	pushl  -0xc(%ebp)
  800ac7:	50                   	push   %eax
  800ac8:	ff 75 0c             	pushl  0xc(%ebp)
  800acb:	ff 75 08             	pushl  0x8(%ebp)
  800ace:	e8 16 fc ff ff       	call   8006e9 <vprintfmt>
  800ad3:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800ad6:	90                   	nop
  800ad7:	c9                   	leave  
  800ad8:	c3                   	ret    

00800ad9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ad9:	55                   	push   %ebp
  800ada:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800adc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800adf:	8b 40 08             	mov    0x8(%eax),%eax
  800ae2:	8d 50 01             	lea    0x1(%eax),%edx
  800ae5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae8:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800aeb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aee:	8b 10                	mov    (%eax),%edx
  800af0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af3:	8b 40 04             	mov    0x4(%eax),%eax
  800af6:	39 c2                	cmp    %eax,%edx
  800af8:	73 12                	jae    800b0c <sprintputch+0x33>
		*b->buf++ = ch;
  800afa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afd:	8b 00                	mov    (%eax),%eax
  800aff:	8d 48 01             	lea    0x1(%eax),%ecx
  800b02:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b05:	89 0a                	mov    %ecx,(%edx)
  800b07:	8b 55 08             	mov    0x8(%ebp),%edx
  800b0a:	88 10                	mov    %dl,(%eax)
}
  800b0c:	90                   	nop
  800b0d:	5d                   	pop    %ebp
  800b0e:	c3                   	ret    

00800b0f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b0f:	55                   	push   %ebp
  800b10:	89 e5                	mov    %esp,%ebp
  800b12:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b15:	8b 45 08             	mov    0x8(%ebp),%eax
  800b18:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b21:	8b 45 08             	mov    0x8(%ebp),%eax
  800b24:	01 d0                	add    %edx,%eax
  800b26:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b29:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b30:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b34:	74 06                	je     800b3c <vsnprintf+0x2d>
  800b36:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b3a:	7f 07                	jg     800b43 <vsnprintf+0x34>
		return -E_INVAL;
  800b3c:	b8 03 00 00 00       	mov    $0x3,%eax
  800b41:	eb 20                	jmp    800b63 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b43:	ff 75 14             	pushl  0x14(%ebp)
  800b46:	ff 75 10             	pushl  0x10(%ebp)
  800b49:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b4c:	50                   	push   %eax
  800b4d:	68 d9 0a 80 00       	push   $0x800ad9
  800b52:	e8 92 fb ff ff       	call   8006e9 <vprintfmt>
  800b57:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b5d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b60:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b63:	c9                   	leave  
  800b64:	c3                   	ret    

00800b65 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b65:	55                   	push   %ebp
  800b66:	89 e5                	mov    %esp,%ebp
  800b68:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b6b:	8d 45 10             	lea    0x10(%ebp),%eax
  800b6e:	83 c0 04             	add    $0x4,%eax
  800b71:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b74:	8b 45 10             	mov    0x10(%ebp),%eax
  800b77:	ff 75 f4             	pushl  -0xc(%ebp)
  800b7a:	50                   	push   %eax
  800b7b:	ff 75 0c             	pushl  0xc(%ebp)
  800b7e:	ff 75 08             	pushl  0x8(%ebp)
  800b81:	e8 89 ff ff ff       	call   800b0f <vsnprintf>
  800b86:	83 c4 10             	add    $0x10,%esp
  800b89:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800b8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b8f:	c9                   	leave  
  800b90:	c3                   	ret    

00800b91 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800b91:	55                   	push   %ebp
  800b92:	89 e5                	mov    %esp,%ebp
  800b94:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800b97:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b9e:	eb 06                	jmp    800ba6 <strlen+0x15>
		n++;
  800ba0:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ba3:	ff 45 08             	incl   0x8(%ebp)
  800ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba9:	8a 00                	mov    (%eax),%al
  800bab:	84 c0                	test   %al,%al
  800bad:	75 f1                	jne    800ba0 <strlen+0xf>
		n++;
	return n;
  800baf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bb2:	c9                   	leave  
  800bb3:	c3                   	ret    

00800bb4 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bb4:	55                   	push   %ebp
  800bb5:	89 e5                	mov    %esp,%ebp
  800bb7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bc1:	eb 09                	jmp    800bcc <strnlen+0x18>
		n++;
  800bc3:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bc6:	ff 45 08             	incl   0x8(%ebp)
  800bc9:	ff 4d 0c             	decl   0xc(%ebp)
  800bcc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bd0:	74 09                	je     800bdb <strnlen+0x27>
  800bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd5:	8a 00                	mov    (%eax),%al
  800bd7:	84 c0                	test   %al,%al
  800bd9:	75 e8                	jne    800bc3 <strnlen+0xf>
		n++;
	return n;
  800bdb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bde:	c9                   	leave  
  800bdf:	c3                   	ret    

00800be0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800be0:	55                   	push   %ebp
  800be1:	89 e5                	mov    %esp,%ebp
  800be3:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800be6:	8b 45 08             	mov    0x8(%ebp),%eax
  800be9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800bec:	90                   	nop
  800bed:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf0:	8d 50 01             	lea    0x1(%eax),%edx
  800bf3:	89 55 08             	mov    %edx,0x8(%ebp)
  800bf6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bf9:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bfc:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bff:	8a 12                	mov    (%edx),%dl
  800c01:	88 10                	mov    %dl,(%eax)
  800c03:	8a 00                	mov    (%eax),%al
  800c05:	84 c0                	test   %al,%al
  800c07:	75 e4                	jne    800bed <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c09:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c0c:	c9                   	leave  
  800c0d:	c3                   	ret    

00800c0e <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c0e:	55                   	push   %ebp
  800c0f:	89 e5                	mov    %esp,%ebp
  800c11:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c14:	8b 45 08             	mov    0x8(%ebp),%eax
  800c17:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c1a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c21:	eb 1f                	jmp    800c42 <strncpy+0x34>
		*dst++ = *src;
  800c23:	8b 45 08             	mov    0x8(%ebp),%eax
  800c26:	8d 50 01             	lea    0x1(%eax),%edx
  800c29:	89 55 08             	mov    %edx,0x8(%ebp)
  800c2c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c2f:	8a 12                	mov    (%edx),%dl
  800c31:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c36:	8a 00                	mov    (%eax),%al
  800c38:	84 c0                	test   %al,%al
  800c3a:	74 03                	je     800c3f <strncpy+0x31>
			src++;
  800c3c:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c3f:	ff 45 fc             	incl   -0x4(%ebp)
  800c42:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c45:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c48:	72 d9                	jb     800c23 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c4a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c4d:	c9                   	leave  
  800c4e:	c3                   	ret    

00800c4f <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c4f:	55                   	push   %ebp
  800c50:	89 e5                	mov    %esp,%ebp
  800c52:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c55:	8b 45 08             	mov    0x8(%ebp),%eax
  800c58:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c5b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c5f:	74 30                	je     800c91 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c61:	eb 16                	jmp    800c79 <strlcpy+0x2a>
			*dst++ = *src++;
  800c63:	8b 45 08             	mov    0x8(%ebp),%eax
  800c66:	8d 50 01             	lea    0x1(%eax),%edx
  800c69:	89 55 08             	mov    %edx,0x8(%ebp)
  800c6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c6f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c72:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c75:	8a 12                	mov    (%edx),%dl
  800c77:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c79:	ff 4d 10             	decl   0x10(%ebp)
  800c7c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c80:	74 09                	je     800c8b <strlcpy+0x3c>
  800c82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c85:	8a 00                	mov    (%eax),%al
  800c87:	84 c0                	test   %al,%al
  800c89:	75 d8                	jne    800c63 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c91:	8b 55 08             	mov    0x8(%ebp),%edx
  800c94:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c97:	29 c2                	sub    %eax,%edx
  800c99:	89 d0                	mov    %edx,%eax
}
  800c9b:	c9                   	leave  
  800c9c:	c3                   	ret    

00800c9d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c9d:	55                   	push   %ebp
  800c9e:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ca0:	eb 06                	jmp    800ca8 <strcmp+0xb>
		p++, q++;
  800ca2:	ff 45 08             	incl   0x8(%ebp)
  800ca5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cab:	8a 00                	mov    (%eax),%al
  800cad:	84 c0                	test   %al,%al
  800caf:	74 0e                	je     800cbf <strcmp+0x22>
  800cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb4:	8a 10                	mov    (%eax),%dl
  800cb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb9:	8a 00                	mov    (%eax),%al
  800cbb:	38 c2                	cmp    %al,%dl
  800cbd:	74 e3                	je     800ca2 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc2:	8a 00                	mov    (%eax),%al
  800cc4:	0f b6 d0             	movzbl %al,%edx
  800cc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cca:	8a 00                	mov    (%eax),%al
  800ccc:	0f b6 c0             	movzbl %al,%eax
  800ccf:	29 c2                	sub    %eax,%edx
  800cd1:	89 d0                	mov    %edx,%eax
}
  800cd3:	5d                   	pop    %ebp
  800cd4:	c3                   	ret    

00800cd5 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800cd5:	55                   	push   %ebp
  800cd6:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cd8:	eb 09                	jmp    800ce3 <strncmp+0xe>
		n--, p++, q++;
  800cda:	ff 4d 10             	decl   0x10(%ebp)
  800cdd:	ff 45 08             	incl   0x8(%ebp)
  800ce0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800ce3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ce7:	74 17                	je     800d00 <strncmp+0x2b>
  800ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cec:	8a 00                	mov    (%eax),%al
  800cee:	84 c0                	test   %al,%al
  800cf0:	74 0e                	je     800d00 <strncmp+0x2b>
  800cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf5:	8a 10                	mov    (%eax),%dl
  800cf7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cfa:	8a 00                	mov    (%eax),%al
  800cfc:	38 c2                	cmp    %al,%dl
  800cfe:	74 da                	je     800cda <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d00:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d04:	75 07                	jne    800d0d <strncmp+0x38>
		return 0;
  800d06:	b8 00 00 00 00       	mov    $0x0,%eax
  800d0b:	eb 14                	jmp    800d21 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d10:	8a 00                	mov    (%eax),%al
  800d12:	0f b6 d0             	movzbl %al,%edx
  800d15:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d18:	8a 00                	mov    (%eax),%al
  800d1a:	0f b6 c0             	movzbl %al,%eax
  800d1d:	29 c2                	sub    %eax,%edx
  800d1f:	89 d0                	mov    %edx,%eax
}
  800d21:	5d                   	pop    %ebp
  800d22:	c3                   	ret    

00800d23 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d23:	55                   	push   %ebp
  800d24:	89 e5                	mov    %esp,%ebp
  800d26:	83 ec 04             	sub    $0x4,%esp
  800d29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d2f:	eb 12                	jmp    800d43 <strchr+0x20>
		if (*s == c)
  800d31:	8b 45 08             	mov    0x8(%ebp),%eax
  800d34:	8a 00                	mov    (%eax),%al
  800d36:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d39:	75 05                	jne    800d40 <strchr+0x1d>
			return (char *) s;
  800d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3e:	eb 11                	jmp    800d51 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d40:	ff 45 08             	incl   0x8(%ebp)
  800d43:	8b 45 08             	mov    0x8(%ebp),%eax
  800d46:	8a 00                	mov    (%eax),%al
  800d48:	84 c0                	test   %al,%al
  800d4a:	75 e5                	jne    800d31 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d4c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d51:	c9                   	leave  
  800d52:	c3                   	ret    

00800d53 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d53:	55                   	push   %ebp
  800d54:	89 e5                	mov    %esp,%ebp
  800d56:	83 ec 04             	sub    $0x4,%esp
  800d59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d5f:	eb 0d                	jmp    800d6e <strfind+0x1b>
		if (*s == c)
  800d61:	8b 45 08             	mov    0x8(%ebp),%eax
  800d64:	8a 00                	mov    (%eax),%al
  800d66:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d69:	74 0e                	je     800d79 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d6b:	ff 45 08             	incl   0x8(%ebp)
  800d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d71:	8a 00                	mov    (%eax),%al
  800d73:	84 c0                	test   %al,%al
  800d75:	75 ea                	jne    800d61 <strfind+0xe>
  800d77:	eb 01                	jmp    800d7a <strfind+0x27>
		if (*s == c)
			break;
  800d79:	90                   	nop
	return (char *) s;
  800d7a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d7d:	c9                   	leave  
  800d7e:	c3                   	ret    

00800d7f <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d7f:	55                   	push   %ebp
  800d80:	89 e5                	mov    %esp,%ebp
  800d82:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800d85:	8b 45 08             	mov    0x8(%ebp),%eax
  800d88:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800d8b:	8b 45 10             	mov    0x10(%ebp),%eax
  800d8e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800d91:	eb 0e                	jmp    800da1 <memset+0x22>
		*p++ = c;
  800d93:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d96:	8d 50 01             	lea    0x1(%eax),%edx
  800d99:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800d9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d9f:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800da1:	ff 4d f8             	decl   -0x8(%ebp)
  800da4:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800da8:	79 e9                	jns    800d93 <memset+0x14>
		*p++ = c;

	return v;
  800daa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dad:	c9                   	leave  
  800dae:	c3                   	ret    

00800daf <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800daf:	55                   	push   %ebp
  800db0:	89 e5                	mov    %esp,%ebp
  800db2:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800db5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbe:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800dc1:	eb 16                	jmp    800dd9 <memcpy+0x2a>
		*d++ = *s++;
  800dc3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dc6:	8d 50 01             	lea    0x1(%eax),%edx
  800dc9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800dcc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800dcf:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dd2:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800dd5:	8a 12                	mov    (%edx),%dl
  800dd7:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800dd9:	8b 45 10             	mov    0x10(%ebp),%eax
  800ddc:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ddf:	89 55 10             	mov    %edx,0x10(%ebp)
  800de2:	85 c0                	test   %eax,%eax
  800de4:	75 dd                	jne    800dc3 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800de6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800de9:	c9                   	leave  
  800dea:	c3                   	ret    

00800deb <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800deb:	55                   	push   %ebp
  800dec:	89 e5                	mov    %esp,%ebp
  800dee:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800df1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800df7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800dfd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e00:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e03:	73 50                	jae    800e55 <memmove+0x6a>
  800e05:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e08:	8b 45 10             	mov    0x10(%ebp),%eax
  800e0b:	01 d0                	add    %edx,%eax
  800e0d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e10:	76 43                	jbe    800e55 <memmove+0x6a>
		s += n;
  800e12:	8b 45 10             	mov    0x10(%ebp),%eax
  800e15:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e18:	8b 45 10             	mov    0x10(%ebp),%eax
  800e1b:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e1e:	eb 10                	jmp    800e30 <memmove+0x45>
			*--d = *--s;
  800e20:	ff 4d f8             	decl   -0x8(%ebp)
  800e23:	ff 4d fc             	decl   -0x4(%ebp)
  800e26:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e29:	8a 10                	mov    (%eax),%dl
  800e2b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e2e:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e30:	8b 45 10             	mov    0x10(%ebp),%eax
  800e33:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e36:	89 55 10             	mov    %edx,0x10(%ebp)
  800e39:	85 c0                	test   %eax,%eax
  800e3b:	75 e3                	jne    800e20 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e3d:	eb 23                	jmp    800e62 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e3f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e42:	8d 50 01             	lea    0x1(%eax),%edx
  800e45:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e48:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e4b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e4e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e51:	8a 12                	mov    (%edx),%dl
  800e53:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e55:	8b 45 10             	mov    0x10(%ebp),%eax
  800e58:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e5b:	89 55 10             	mov    %edx,0x10(%ebp)
  800e5e:	85 c0                	test   %eax,%eax
  800e60:	75 dd                	jne    800e3f <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e62:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e65:	c9                   	leave  
  800e66:	c3                   	ret    

00800e67 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e67:	55                   	push   %ebp
  800e68:	89 e5                	mov    %esp,%ebp
  800e6a:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e70:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e76:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e79:	eb 2a                	jmp    800ea5 <memcmp+0x3e>
		if (*s1 != *s2)
  800e7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e7e:	8a 10                	mov    (%eax),%dl
  800e80:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e83:	8a 00                	mov    (%eax),%al
  800e85:	38 c2                	cmp    %al,%dl
  800e87:	74 16                	je     800e9f <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e89:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e8c:	8a 00                	mov    (%eax),%al
  800e8e:	0f b6 d0             	movzbl %al,%edx
  800e91:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e94:	8a 00                	mov    (%eax),%al
  800e96:	0f b6 c0             	movzbl %al,%eax
  800e99:	29 c2                	sub    %eax,%edx
  800e9b:	89 d0                	mov    %edx,%eax
  800e9d:	eb 18                	jmp    800eb7 <memcmp+0x50>
		s1++, s2++;
  800e9f:	ff 45 fc             	incl   -0x4(%ebp)
  800ea2:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ea5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eab:	89 55 10             	mov    %edx,0x10(%ebp)
  800eae:	85 c0                	test   %eax,%eax
  800eb0:	75 c9                	jne    800e7b <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800eb2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800eb7:	c9                   	leave  
  800eb8:	c3                   	ret    

00800eb9 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800eb9:	55                   	push   %ebp
  800eba:	89 e5                	mov    %esp,%ebp
  800ebc:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ebf:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec5:	01 d0                	add    %edx,%eax
  800ec7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800eca:	eb 15                	jmp    800ee1 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecf:	8a 00                	mov    (%eax),%al
  800ed1:	0f b6 d0             	movzbl %al,%edx
  800ed4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed7:	0f b6 c0             	movzbl %al,%eax
  800eda:	39 c2                	cmp    %eax,%edx
  800edc:	74 0d                	je     800eeb <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ede:	ff 45 08             	incl   0x8(%ebp)
  800ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ee7:	72 e3                	jb     800ecc <memfind+0x13>
  800ee9:	eb 01                	jmp    800eec <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800eeb:	90                   	nop
	return (void *) s;
  800eec:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eef:	c9                   	leave  
  800ef0:	c3                   	ret    

00800ef1 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ef1:	55                   	push   %ebp
  800ef2:	89 e5                	mov    %esp,%ebp
  800ef4:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800ef7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800efe:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f05:	eb 03                	jmp    800f0a <strtol+0x19>
		s++;
  800f07:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0d:	8a 00                	mov    (%eax),%al
  800f0f:	3c 20                	cmp    $0x20,%al
  800f11:	74 f4                	je     800f07 <strtol+0x16>
  800f13:	8b 45 08             	mov    0x8(%ebp),%eax
  800f16:	8a 00                	mov    (%eax),%al
  800f18:	3c 09                	cmp    $0x9,%al
  800f1a:	74 eb                	je     800f07 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1f:	8a 00                	mov    (%eax),%al
  800f21:	3c 2b                	cmp    $0x2b,%al
  800f23:	75 05                	jne    800f2a <strtol+0x39>
		s++;
  800f25:	ff 45 08             	incl   0x8(%ebp)
  800f28:	eb 13                	jmp    800f3d <strtol+0x4c>
	else if (*s == '-')
  800f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2d:	8a 00                	mov    (%eax),%al
  800f2f:	3c 2d                	cmp    $0x2d,%al
  800f31:	75 0a                	jne    800f3d <strtol+0x4c>
		s++, neg = 1;
  800f33:	ff 45 08             	incl   0x8(%ebp)
  800f36:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f3d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f41:	74 06                	je     800f49 <strtol+0x58>
  800f43:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f47:	75 20                	jne    800f69 <strtol+0x78>
  800f49:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4c:	8a 00                	mov    (%eax),%al
  800f4e:	3c 30                	cmp    $0x30,%al
  800f50:	75 17                	jne    800f69 <strtol+0x78>
  800f52:	8b 45 08             	mov    0x8(%ebp),%eax
  800f55:	40                   	inc    %eax
  800f56:	8a 00                	mov    (%eax),%al
  800f58:	3c 78                	cmp    $0x78,%al
  800f5a:	75 0d                	jne    800f69 <strtol+0x78>
		s += 2, base = 16;
  800f5c:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f60:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f67:	eb 28                	jmp    800f91 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f69:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f6d:	75 15                	jne    800f84 <strtol+0x93>
  800f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f72:	8a 00                	mov    (%eax),%al
  800f74:	3c 30                	cmp    $0x30,%al
  800f76:	75 0c                	jne    800f84 <strtol+0x93>
		s++, base = 8;
  800f78:	ff 45 08             	incl   0x8(%ebp)
  800f7b:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f82:	eb 0d                	jmp    800f91 <strtol+0xa0>
	else if (base == 0)
  800f84:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f88:	75 07                	jne    800f91 <strtol+0xa0>
		base = 10;
  800f8a:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f91:	8b 45 08             	mov    0x8(%ebp),%eax
  800f94:	8a 00                	mov    (%eax),%al
  800f96:	3c 2f                	cmp    $0x2f,%al
  800f98:	7e 19                	jle    800fb3 <strtol+0xc2>
  800f9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9d:	8a 00                	mov    (%eax),%al
  800f9f:	3c 39                	cmp    $0x39,%al
  800fa1:	7f 10                	jg     800fb3 <strtol+0xc2>
			dig = *s - '0';
  800fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa6:	8a 00                	mov    (%eax),%al
  800fa8:	0f be c0             	movsbl %al,%eax
  800fab:	83 e8 30             	sub    $0x30,%eax
  800fae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fb1:	eb 42                	jmp    800ff5 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb6:	8a 00                	mov    (%eax),%al
  800fb8:	3c 60                	cmp    $0x60,%al
  800fba:	7e 19                	jle    800fd5 <strtol+0xe4>
  800fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbf:	8a 00                	mov    (%eax),%al
  800fc1:	3c 7a                	cmp    $0x7a,%al
  800fc3:	7f 10                	jg     800fd5 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc8:	8a 00                	mov    (%eax),%al
  800fca:	0f be c0             	movsbl %al,%eax
  800fcd:	83 e8 57             	sub    $0x57,%eax
  800fd0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fd3:	eb 20                	jmp    800ff5 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd8:	8a 00                	mov    (%eax),%al
  800fda:	3c 40                	cmp    $0x40,%al
  800fdc:	7e 39                	jle    801017 <strtol+0x126>
  800fde:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe1:	8a 00                	mov    (%eax),%al
  800fe3:	3c 5a                	cmp    $0x5a,%al
  800fe5:	7f 30                	jg     801017 <strtol+0x126>
			dig = *s - 'A' + 10;
  800fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fea:	8a 00                	mov    (%eax),%al
  800fec:	0f be c0             	movsbl %al,%eax
  800fef:	83 e8 37             	sub    $0x37,%eax
  800ff2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800ff5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ff8:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ffb:	7d 19                	jge    801016 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800ffd:	ff 45 08             	incl   0x8(%ebp)
  801000:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801003:	0f af 45 10          	imul   0x10(%ebp),%eax
  801007:	89 c2                	mov    %eax,%edx
  801009:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80100c:	01 d0                	add    %edx,%eax
  80100e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801011:	e9 7b ff ff ff       	jmp    800f91 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801016:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801017:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80101b:	74 08                	je     801025 <strtol+0x134>
		*endptr = (char *) s;
  80101d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801020:	8b 55 08             	mov    0x8(%ebp),%edx
  801023:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801025:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801029:	74 07                	je     801032 <strtol+0x141>
  80102b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80102e:	f7 d8                	neg    %eax
  801030:	eb 03                	jmp    801035 <strtol+0x144>
  801032:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801035:	c9                   	leave  
  801036:	c3                   	ret    

00801037 <ltostr>:

void
ltostr(long value, char *str)
{
  801037:	55                   	push   %ebp
  801038:	89 e5                	mov    %esp,%ebp
  80103a:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80103d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801044:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80104b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80104f:	79 13                	jns    801064 <ltostr+0x2d>
	{
		neg = 1;
  801051:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801058:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105b:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80105e:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801061:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801064:	8b 45 08             	mov    0x8(%ebp),%eax
  801067:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80106c:	99                   	cltd   
  80106d:	f7 f9                	idiv   %ecx
  80106f:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801072:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801075:	8d 50 01             	lea    0x1(%eax),%edx
  801078:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80107b:	89 c2                	mov    %eax,%edx
  80107d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801080:	01 d0                	add    %edx,%eax
  801082:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801085:	83 c2 30             	add    $0x30,%edx
  801088:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80108a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80108d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801092:	f7 e9                	imul   %ecx
  801094:	c1 fa 02             	sar    $0x2,%edx
  801097:	89 c8                	mov    %ecx,%eax
  801099:	c1 f8 1f             	sar    $0x1f,%eax
  80109c:	29 c2                	sub    %eax,%edx
  80109e:	89 d0                	mov    %edx,%eax
  8010a0:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010a6:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010ab:	f7 e9                	imul   %ecx
  8010ad:	c1 fa 02             	sar    $0x2,%edx
  8010b0:	89 c8                	mov    %ecx,%eax
  8010b2:	c1 f8 1f             	sar    $0x1f,%eax
  8010b5:	29 c2                	sub    %eax,%edx
  8010b7:	89 d0                	mov    %edx,%eax
  8010b9:	c1 e0 02             	shl    $0x2,%eax
  8010bc:	01 d0                	add    %edx,%eax
  8010be:	01 c0                	add    %eax,%eax
  8010c0:	29 c1                	sub    %eax,%ecx
  8010c2:	89 ca                	mov    %ecx,%edx
  8010c4:	85 d2                	test   %edx,%edx
  8010c6:	75 9c                	jne    801064 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d2:	48                   	dec    %eax
  8010d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010da:	74 3d                	je     801119 <ltostr+0xe2>
		start = 1 ;
  8010dc:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010e3:	eb 34                	jmp    801119 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8010e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010eb:	01 d0                	add    %edx,%eax
  8010ed:	8a 00                	mov    (%eax),%al
  8010ef:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8010f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f8:	01 c2                	add    %eax,%edx
  8010fa:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8010fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801100:	01 c8                	add    %ecx,%eax
  801102:	8a 00                	mov    (%eax),%al
  801104:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801106:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801109:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110c:	01 c2                	add    %eax,%edx
  80110e:	8a 45 eb             	mov    -0x15(%ebp),%al
  801111:	88 02                	mov    %al,(%edx)
		start++ ;
  801113:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801116:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801119:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80111c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80111f:	7c c4                	jl     8010e5 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801121:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801124:	8b 45 0c             	mov    0xc(%ebp),%eax
  801127:	01 d0                	add    %edx,%eax
  801129:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80112c:	90                   	nop
  80112d:	c9                   	leave  
  80112e:	c3                   	ret    

0080112f <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80112f:	55                   	push   %ebp
  801130:	89 e5                	mov    %esp,%ebp
  801132:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801135:	ff 75 08             	pushl  0x8(%ebp)
  801138:	e8 54 fa ff ff       	call   800b91 <strlen>
  80113d:	83 c4 04             	add    $0x4,%esp
  801140:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801143:	ff 75 0c             	pushl  0xc(%ebp)
  801146:	e8 46 fa ff ff       	call   800b91 <strlen>
  80114b:	83 c4 04             	add    $0x4,%esp
  80114e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801151:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801158:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80115f:	eb 17                	jmp    801178 <strcconcat+0x49>
		final[s] = str1[s] ;
  801161:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801164:	8b 45 10             	mov    0x10(%ebp),%eax
  801167:	01 c2                	add    %eax,%edx
  801169:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80116c:	8b 45 08             	mov    0x8(%ebp),%eax
  80116f:	01 c8                	add    %ecx,%eax
  801171:	8a 00                	mov    (%eax),%al
  801173:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801175:	ff 45 fc             	incl   -0x4(%ebp)
  801178:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80117b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80117e:	7c e1                	jl     801161 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801180:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801187:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80118e:	eb 1f                	jmp    8011af <strcconcat+0x80>
		final[s++] = str2[i] ;
  801190:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801193:	8d 50 01             	lea    0x1(%eax),%edx
  801196:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801199:	89 c2                	mov    %eax,%edx
  80119b:	8b 45 10             	mov    0x10(%ebp),%eax
  80119e:	01 c2                	add    %eax,%edx
  8011a0:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a6:	01 c8                	add    %ecx,%eax
  8011a8:	8a 00                	mov    (%eax),%al
  8011aa:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011ac:	ff 45 f8             	incl   -0x8(%ebp)
  8011af:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011b2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011b5:	7c d9                	jl     801190 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011b7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8011bd:	01 d0                	add    %edx,%eax
  8011bf:	c6 00 00             	movb   $0x0,(%eax)
}
  8011c2:	90                   	nop
  8011c3:	c9                   	leave  
  8011c4:	c3                   	ret    

008011c5 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011c5:	55                   	push   %ebp
  8011c6:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8011cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8011d4:	8b 00                	mov    (%eax),%eax
  8011d6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e0:	01 d0                	add    %edx,%eax
  8011e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011e8:	eb 0c                	jmp    8011f6 <strsplit+0x31>
			*string++ = 0;
  8011ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ed:	8d 50 01             	lea    0x1(%eax),%edx
  8011f0:	89 55 08             	mov    %edx,0x8(%ebp)
  8011f3:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f9:	8a 00                	mov    (%eax),%al
  8011fb:	84 c0                	test   %al,%al
  8011fd:	74 18                	je     801217 <strsplit+0x52>
  8011ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801202:	8a 00                	mov    (%eax),%al
  801204:	0f be c0             	movsbl %al,%eax
  801207:	50                   	push   %eax
  801208:	ff 75 0c             	pushl  0xc(%ebp)
  80120b:	e8 13 fb ff ff       	call   800d23 <strchr>
  801210:	83 c4 08             	add    $0x8,%esp
  801213:	85 c0                	test   %eax,%eax
  801215:	75 d3                	jne    8011ea <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801217:	8b 45 08             	mov    0x8(%ebp),%eax
  80121a:	8a 00                	mov    (%eax),%al
  80121c:	84 c0                	test   %al,%al
  80121e:	74 5a                	je     80127a <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801220:	8b 45 14             	mov    0x14(%ebp),%eax
  801223:	8b 00                	mov    (%eax),%eax
  801225:	83 f8 0f             	cmp    $0xf,%eax
  801228:	75 07                	jne    801231 <strsplit+0x6c>
		{
			return 0;
  80122a:	b8 00 00 00 00       	mov    $0x0,%eax
  80122f:	eb 66                	jmp    801297 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801231:	8b 45 14             	mov    0x14(%ebp),%eax
  801234:	8b 00                	mov    (%eax),%eax
  801236:	8d 48 01             	lea    0x1(%eax),%ecx
  801239:	8b 55 14             	mov    0x14(%ebp),%edx
  80123c:	89 0a                	mov    %ecx,(%edx)
  80123e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801245:	8b 45 10             	mov    0x10(%ebp),%eax
  801248:	01 c2                	add    %eax,%edx
  80124a:	8b 45 08             	mov    0x8(%ebp),%eax
  80124d:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80124f:	eb 03                	jmp    801254 <strsplit+0x8f>
			string++;
  801251:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801254:	8b 45 08             	mov    0x8(%ebp),%eax
  801257:	8a 00                	mov    (%eax),%al
  801259:	84 c0                	test   %al,%al
  80125b:	74 8b                	je     8011e8 <strsplit+0x23>
  80125d:	8b 45 08             	mov    0x8(%ebp),%eax
  801260:	8a 00                	mov    (%eax),%al
  801262:	0f be c0             	movsbl %al,%eax
  801265:	50                   	push   %eax
  801266:	ff 75 0c             	pushl  0xc(%ebp)
  801269:	e8 b5 fa ff ff       	call   800d23 <strchr>
  80126e:	83 c4 08             	add    $0x8,%esp
  801271:	85 c0                	test   %eax,%eax
  801273:	74 dc                	je     801251 <strsplit+0x8c>
			string++;
	}
  801275:	e9 6e ff ff ff       	jmp    8011e8 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80127a:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80127b:	8b 45 14             	mov    0x14(%ebp),%eax
  80127e:	8b 00                	mov    (%eax),%eax
  801280:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801287:	8b 45 10             	mov    0x10(%ebp),%eax
  80128a:	01 d0                	add    %edx,%eax
  80128c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801292:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801297:	c9                   	leave  
  801298:	c3                   	ret    

00801299 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801299:	55                   	push   %ebp
  80129a:	89 e5                	mov    %esp,%ebp
  80129c:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  80129f:	a1 04 40 80 00       	mov    0x804004,%eax
  8012a4:	85 c0                	test   %eax,%eax
  8012a6:	74 1f                	je     8012c7 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8012a8:	e8 1d 00 00 00       	call   8012ca <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8012ad:	83 ec 0c             	sub    $0xc,%esp
  8012b0:	68 70 38 80 00       	push   $0x803870
  8012b5:	e8 55 f2 ff ff       	call   80050f <cprintf>
  8012ba:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8012bd:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8012c4:	00 00 00 
	}
}
  8012c7:	90                   	nop
  8012c8:	c9                   	leave  
  8012c9:	c3                   	ret    

008012ca <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8012ca:	55                   	push   %ebp
  8012cb:	89 e5                	mov    %esp,%ebp
  8012cd:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  8012d0:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  8012d7:	00 00 00 
  8012da:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  8012e1:	00 00 00 
  8012e4:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  8012eb:	00 00 00 
		LIST_INIT(&AllocMemBlocksList);
  8012ee:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  8012f5:	00 00 00 
  8012f8:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  8012ff:	00 00 00 
  801302:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801309:	00 00 00 

		MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES ;
  80130c:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801313:	00 02 00 
		MemBlockNodes =(struct MemBlock*)USER_DYN_BLKS_ARRAY ;
  801316:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  80131d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801320:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801325:	2d 00 10 00 00       	sub    $0x1000,%eax
  80132a:	a3 50 40 80 00       	mov    %eax,0x804050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock),PAGE_SIZE),PERM_USER|PERM_WRITEABLE);
  80132f:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801336:	a1 20 41 80 00       	mov    0x804120,%eax
  80133b:	c1 e0 04             	shl    $0x4,%eax
  80133e:	89 c2                	mov    %eax,%edx
  801340:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801343:	01 d0                	add    %edx,%eax
  801345:	48                   	dec    %eax
  801346:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801349:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80134c:	ba 00 00 00 00       	mov    $0x0,%edx
  801351:	f7 75 f0             	divl   -0x10(%ebp)
  801354:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801357:	29 d0                	sub    %edx,%eax
  801359:	89 c2                	mov    %eax,%edx
  80135b:	c7 45 e8 00 00 e0 7f 	movl   $0x7fe00000,-0x18(%ebp)
  801362:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801365:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80136a:	2d 00 10 00 00       	sub    $0x1000,%eax
  80136f:	83 ec 04             	sub    $0x4,%esp
  801372:	6a 06                	push   $0x6
  801374:	52                   	push   %edx
  801375:	50                   	push   %eax
  801376:	e8 71 05 00 00       	call   8018ec <sys_allocate_chunk>
  80137b:	83 c4 10             	add    $0x10,%esp
		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80137e:	a1 20 41 80 00       	mov    0x804120,%eax
  801383:	83 ec 0c             	sub    $0xc,%esp
  801386:	50                   	push   %eax
  801387:	e8 e6 0b 00 00       	call   801f72 <initialize_MemBlocksList>
  80138c:	83 c4 10             	add    $0x10,%esp

		struct MemBlock  *block_node;
		block_node = AvailableMemBlocksList.lh_first;
  80138f:	a1 48 41 80 00       	mov    0x804148,%eax
  801394:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&(AvailableMemBlocksList),block_node);
  801397:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80139b:	75 14                	jne    8013b1 <initialize_dyn_block_system+0xe7>
  80139d:	83 ec 04             	sub    $0x4,%esp
  8013a0:	68 95 38 80 00       	push   $0x803895
  8013a5:	6a 2b                	push   $0x2b
  8013a7:	68 b3 38 80 00       	push   $0x8038b3
  8013ac:	e8 aa ee ff ff       	call   80025b <_panic>
  8013b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013b4:	8b 00                	mov    (%eax),%eax
  8013b6:	85 c0                	test   %eax,%eax
  8013b8:	74 10                	je     8013ca <initialize_dyn_block_system+0x100>
  8013ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013bd:	8b 00                	mov    (%eax),%eax
  8013bf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013c2:	8b 52 04             	mov    0x4(%edx),%edx
  8013c5:	89 50 04             	mov    %edx,0x4(%eax)
  8013c8:	eb 0b                	jmp    8013d5 <initialize_dyn_block_system+0x10b>
  8013ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013cd:	8b 40 04             	mov    0x4(%eax),%eax
  8013d0:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8013d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013d8:	8b 40 04             	mov    0x4(%eax),%eax
  8013db:	85 c0                	test   %eax,%eax
  8013dd:	74 0f                	je     8013ee <initialize_dyn_block_system+0x124>
  8013df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013e2:	8b 40 04             	mov    0x4(%eax),%eax
  8013e5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013e8:	8b 12                	mov    (%edx),%edx
  8013ea:	89 10                	mov    %edx,(%eax)
  8013ec:	eb 0a                	jmp    8013f8 <initialize_dyn_block_system+0x12e>
  8013ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013f1:	8b 00                	mov    (%eax),%eax
  8013f3:	a3 48 41 80 00       	mov    %eax,0x804148
  8013f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013fb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801401:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801404:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80140b:	a1 54 41 80 00       	mov    0x804154,%eax
  801410:	48                   	dec    %eax
  801411:	a3 54 41 80 00       	mov    %eax,0x804154
		block_node->sva = USER_HEAP_START ;
  801416:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801419:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
		block_node->size = ((USER_HEAP_MAX - USER_HEAP_START));
  801420:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801423:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		insert_sorted_with_merge_freeList(block_node);
  80142a:	83 ec 0c             	sub    $0xc,%esp
  80142d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801430:	e8 d2 13 00 00       	call   802807 <insert_sorted_with_merge_freeList>
  801435:	83 c4 10             	add    $0x10,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801438:	90                   	nop
  801439:	c9                   	leave  
  80143a:	c3                   	ret    

0080143b <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  80143b:	55                   	push   %ebp
  80143c:	89 e5                	mov    %esp,%ebp
  80143e:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801441:	e8 53 fe ff ff       	call   801299 <InitializeUHeap>
	if (size == 0) return NULL ;
  801446:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80144a:	75 07                	jne    801453 <malloc+0x18>
  80144c:	b8 00 00 00 00       	mov    $0x0,%eax
  801451:	eb 61                	jmp    8014b4 <malloc+0x79>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	size= ROUNDUP(size,PAGE_SIZE);
  801453:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80145a:	8b 55 08             	mov    0x8(%ebp),%edx
  80145d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801460:	01 d0                	add    %edx,%eax
  801462:	48                   	dec    %eax
  801463:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801466:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801469:	ba 00 00 00 00       	mov    $0x0,%edx
  80146e:	f7 75 f4             	divl   -0xc(%ebp)
  801471:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801474:	29 d0                	sub    %edx,%eax
  801476:	89 45 08             	mov    %eax,0x8(%ebp)
	    			if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801479:	e8 3c 08 00 00       	call   801cba <sys_isUHeapPlacementStrategyFIRSTFIT>
  80147e:	85 c0                	test   %eax,%eax
  801480:	74 2d                	je     8014af <malloc+0x74>
	    			{
	    				struct MemBlock * ff_block = alloc_block_FF(size);
  801482:	83 ec 0c             	sub    $0xc,%esp
  801485:	ff 75 08             	pushl  0x8(%ebp)
  801488:	e8 3e 0f 00 00       	call   8023cb <alloc_block_FF>
  80148d:	83 c4 10             	add    $0x10,%esp
  801490:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    				if(ff_block!=NULL)
  801493:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801497:	74 16                	je     8014af <malloc+0x74>
	    				{

	    					insert_sorted_allocList(ff_block);
  801499:	83 ec 0c             	sub    $0xc,%esp
  80149c:	ff 75 ec             	pushl  -0x14(%ebp)
  80149f:	e8 48 0c 00 00       	call   8020ec <insert_sorted_allocList>
  8014a4:	83 c4 10             	add    $0x10,%esp
	    					return (void*) ff_block->sva ;
  8014a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014aa:	8b 40 08             	mov    0x8(%eax),%eax
  8014ad:	eb 05                	jmp    8014b4 <malloc+0x79>

	    				}
	}
	    			return (void*) NULL ;
  8014af:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  8014b4:	c9                   	leave  
  8014b5:	c3                   	ret    

008014b6 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8014b6:	55                   	push   %ebp
  8014b7:	89 e5                	mov    %esp,%ebp
  8014b9:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock *elementForEach;
		virtual_address = ROUNDDOWN(virtual_address, PAGE_SIZE);
  8014bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014c5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014ca:	89 45 08             	mov    %eax,0x8(%ebp)
	//	if (is_mallocPages[indexindex((uint32) virtual_address)] == 1) {
		elementForEach = find_block(&AllocMemBlocksList,(uint32)virtual_address);
  8014cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d0:	83 ec 08             	sub    $0x8,%esp
  8014d3:	50                   	push   %eax
  8014d4:	68 40 40 80 00       	push   $0x804040
  8014d9:	e8 71 0b 00 00       	call   80204f <find_block>
  8014de:	83 c4 10             	add    $0x10,%esp
  8014e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		sys_free_user_mem((uint32) virtual_address, elementForEach->size);
  8014e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014e7:	8b 50 0c             	mov    0xc(%eax),%edx
  8014ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ed:	83 ec 08             	sub    $0x8,%esp
  8014f0:	52                   	push   %edx
  8014f1:	50                   	push   %eax
  8014f2:	e8 bd 03 00 00       	call   8018b4 <sys_free_user_mem>
  8014f7:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,elementForEach);
  8014fa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8014fe:	75 14                	jne    801514 <free+0x5e>
  801500:	83 ec 04             	sub    $0x4,%esp
  801503:	68 95 38 80 00       	push   $0x803895
  801508:	6a 71                	push   $0x71
  80150a:	68 b3 38 80 00       	push   $0x8038b3
  80150f:	e8 47 ed ff ff       	call   80025b <_panic>
  801514:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801517:	8b 00                	mov    (%eax),%eax
  801519:	85 c0                	test   %eax,%eax
  80151b:	74 10                	je     80152d <free+0x77>
  80151d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801520:	8b 00                	mov    (%eax),%eax
  801522:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801525:	8b 52 04             	mov    0x4(%edx),%edx
  801528:	89 50 04             	mov    %edx,0x4(%eax)
  80152b:	eb 0b                	jmp    801538 <free+0x82>
  80152d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801530:	8b 40 04             	mov    0x4(%eax),%eax
  801533:	a3 44 40 80 00       	mov    %eax,0x804044
  801538:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80153b:	8b 40 04             	mov    0x4(%eax),%eax
  80153e:	85 c0                	test   %eax,%eax
  801540:	74 0f                	je     801551 <free+0x9b>
  801542:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801545:	8b 40 04             	mov    0x4(%eax),%eax
  801548:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80154b:	8b 12                	mov    (%edx),%edx
  80154d:	89 10                	mov    %edx,(%eax)
  80154f:	eb 0a                	jmp    80155b <free+0xa5>
  801551:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801554:	8b 00                	mov    (%eax),%eax
  801556:	a3 40 40 80 00       	mov    %eax,0x804040
  80155b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80155e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801564:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801567:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80156e:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801573:	48                   	dec    %eax
  801574:	a3 4c 40 80 00       	mov    %eax,0x80404c
		insert_sorted_with_merge_freeList(elementForEach);
  801579:	83 ec 0c             	sub    $0xc,%esp
  80157c:	ff 75 f0             	pushl  -0x10(%ebp)
  80157f:	e8 83 12 00 00       	call   802807 <insert_sorted_with_merge_freeList>
  801584:	83 c4 10             	add    $0x10,%esp
	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801587:	90                   	nop
  801588:	c9                   	leave  
  801589:	c3                   	ret    

0080158a <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80158a:	55                   	push   %ebp
  80158b:	89 e5                	mov    %esp,%ebp
  80158d:	83 ec 28             	sub    $0x28,%esp
  801590:	8b 45 10             	mov    0x10(%ebp),%eax
  801593:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801596:	e8 fe fc ff ff       	call   801299 <InitializeUHeap>
	if (size == 0) return NULL ;
  80159b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80159f:	75 0a                	jne    8015ab <smalloc+0x21>
  8015a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8015a6:	e9 86 00 00 00       	jmp    801631 <smalloc+0xa7>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code

	size=ROUNDUP(size,PAGE_SIZE);
  8015ab:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8015b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015b8:	01 d0                	add    %edx,%eax
  8015ba:	48                   	dec    %eax
  8015bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015c1:	ba 00 00 00 00       	mov    $0x0,%edx
  8015c6:	f7 75 f4             	divl   -0xc(%ebp)
  8015c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015cc:	29 d0                	sub    %edx,%eax
  8015ce:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8015d1:	e8 e4 06 00 00       	call   801cba <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015d6:	85 c0                	test   %eax,%eax
  8015d8:	74 52                	je     80162c <smalloc+0xa2>
		{
		struct MemBlock * ff_block ;
		ff_block = alloc_block_FF(size);
  8015da:	83 ec 0c             	sub    $0xc,%esp
  8015dd:	ff 75 0c             	pushl  0xc(%ebp)
  8015e0:	e8 e6 0d 00 00       	call   8023cb <alloc_block_FF>
  8015e5:	83 c4 10             	add    $0x10,%esp
  8015e8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(ff_block==NULL)
  8015eb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8015ef:	75 07                	jne    8015f8 <smalloc+0x6e>
			return NULL ;
  8015f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8015f6:	eb 39                	jmp    801631 <smalloc+0xa7>

		int obj_id =sys_createSharedObject(sharedVarName,size,isWritable,(void*)ff_block->sva);
  8015f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015fb:	8b 40 08             	mov    0x8(%eax),%eax
  8015fe:	89 c2                	mov    %eax,%edx
  801600:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801604:	52                   	push   %edx
  801605:	50                   	push   %eax
  801606:	ff 75 0c             	pushl  0xc(%ebp)
  801609:	ff 75 08             	pushl  0x8(%ebp)
  80160c:	e8 2e 04 00 00       	call   801a3f <sys_createSharedObject>
  801611:	83 c4 10             	add    $0x10,%esp
  801614:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(obj_id < 0)
  801617:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80161b:	79 07                	jns    801624 <smalloc+0x9a>
			return (void*)NULL ;
  80161d:	b8 00 00 00 00       	mov    $0x0,%eax
  801622:	eb 0d                	jmp    801631 <smalloc+0xa7>
		else
		    return (void*)ff_block->sva ;
  801624:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801627:	8b 40 08             	mov    0x8(%eax),%eax
  80162a:	eb 05                	jmp    801631 <smalloc+0xa7>
		}
		return (void*)NULL ;
  80162c:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801631:	c9                   	leave  
  801632:	c3                   	ret    

00801633 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801633:	55                   	push   %ebp
  801634:	89 e5                	mov    %esp,%ebp
  801636:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801639:	e8 5b fc ff ff       	call   801299 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80163e:	83 ec 08             	sub    $0x8,%esp
  801641:	ff 75 0c             	pushl  0xc(%ebp)
  801644:	ff 75 08             	pushl  0x8(%ebp)
  801647:	e8 1d 04 00 00       	call   801a69 <sys_getSizeOfSharedObject>
  80164c:	83 c4 10             	add    $0x10,%esp
  80164f:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(size == 0)
  801652:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801656:	75 0a                	jne    801662 <sget+0x2f>
			return NULL ;
  801658:	b8 00 00 00 00       	mov    $0x0,%eax
  80165d:	e9 83 00 00 00       	jmp    8016e5 <sget+0xb2>
		size=ROUNDUP(size,PAGE_SIZE);
  801662:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801669:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80166c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80166f:	01 d0                	add    %edx,%eax
  801671:	48                   	dec    %eax
  801672:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801675:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801678:	ba 00 00 00 00       	mov    $0x0,%edx
  80167d:	f7 75 f0             	divl   -0x10(%ebp)
  801680:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801683:	29 d0                	sub    %edx,%eax
  801685:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801688:	e8 2d 06 00 00       	call   801cba <sys_isUHeapPlacementStrategyFIRSTFIT>
  80168d:	85 c0                	test   %eax,%eax
  80168f:	74 4f                	je     8016e0 <sget+0xad>
		{
			struct MemBlock * ff_block ;
				ff_block = alloc_block_FF(size);
  801691:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801694:	83 ec 0c             	sub    $0xc,%esp
  801697:	50                   	push   %eax
  801698:	e8 2e 0d 00 00       	call   8023cb <alloc_block_FF>
  80169d:	83 c4 10             	add    $0x10,%esp
  8016a0:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ff_block==NULL)
  8016a3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8016a7:	75 07                	jne    8016b0 <sget+0x7d>
					return (void*)NULL ;
  8016a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ae:	eb 35                	jmp    8016e5 <sget+0xb2>

		int obj_id =sys_getSharedObject((int)ownerEnvID,sharedVarName,(void*)ff_block->sva);
  8016b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016b3:	8b 40 08             	mov    0x8(%eax),%eax
  8016b6:	83 ec 04             	sub    $0x4,%esp
  8016b9:	50                   	push   %eax
  8016ba:	ff 75 0c             	pushl  0xc(%ebp)
  8016bd:	ff 75 08             	pushl  0x8(%ebp)
  8016c0:	e8 c1 03 00 00       	call   801a86 <sys_getSharedObject>
  8016c5:	83 c4 10             	add    $0x10,%esp
  8016c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if(obj_id<0)
  8016cb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8016cf:	79 07                	jns    8016d8 <sget+0xa5>
				return (void*)NULL ;
  8016d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8016d6:	eb 0d                	jmp    8016e5 <sget+0xb2>
			else
				return (void*)ff_block->sva ;
  8016d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016db:	8b 40 08             	mov    0x8(%eax),%eax
  8016de:	eb 05                	jmp    8016e5 <sget+0xb2>


		}
	return (void*)NULL ;
  8016e0:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8016e5:	c9                   	leave  
  8016e6:	c3                   	ret    

008016e7 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8016e7:	55                   	push   %ebp
  8016e8:	89 e5                	mov    %esp,%ebp
  8016ea:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016ed:	e8 a7 fb ff ff       	call   801299 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8016f2:	83 ec 04             	sub    $0x4,%esp
  8016f5:	68 c0 38 80 00       	push   $0x8038c0
  8016fa:	68 f9 00 00 00       	push   $0xf9
  8016ff:	68 b3 38 80 00       	push   $0x8038b3
  801704:	e8 52 eb ff ff       	call   80025b <_panic>

00801709 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801709:	55                   	push   %ebp
  80170a:	89 e5                	mov    %esp,%ebp
  80170c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80170f:	83 ec 04             	sub    $0x4,%esp
  801712:	68 e8 38 80 00       	push   $0x8038e8
  801717:	68 0d 01 00 00       	push   $0x10d
  80171c:	68 b3 38 80 00       	push   $0x8038b3
  801721:	e8 35 eb ff ff       	call   80025b <_panic>

00801726 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801726:	55                   	push   %ebp
  801727:	89 e5                	mov    %esp,%ebp
  801729:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80172c:	83 ec 04             	sub    $0x4,%esp
  80172f:	68 0c 39 80 00       	push   $0x80390c
  801734:	68 18 01 00 00       	push   $0x118
  801739:	68 b3 38 80 00       	push   $0x8038b3
  80173e:	e8 18 eb ff ff       	call   80025b <_panic>

00801743 <shrink>:

}
void shrink(uint32 newSize)
{
  801743:	55                   	push   %ebp
  801744:	89 e5                	mov    %esp,%ebp
  801746:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801749:	83 ec 04             	sub    $0x4,%esp
  80174c:	68 0c 39 80 00       	push   $0x80390c
  801751:	68 1d 01 00 00       	push   $0x11d
  801756:	68 b3 38 80 00       	push   $0x8038b3
  80175b:	e8 fb ea ff ff       	call   80025b <_panic>

00801760 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801760:	55                   	push   %ebp
  801761:	89 e5                	mov    %esp,%ebp
  801763:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801766:	83 ec 04             	sub    $0x4,%esp
  801769:	68 0c 39 80 00       	push   $0x80390c
  80176e:	68 22 01 00 00       	push   $0x122
  801773:	68 b3 38 80 00       	push   $0x8038b3
  801778:	e8 de ea ff ff       	call   80025b <_panic>

0080177d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80177d:	55                   	push   %ebp
  80177e:	89 e5                	mov    %esp,%ebp
  801780:	57                   	push   %edi
  801781:	56                   	push   %esi
  801782:	53                   	push   %ebx
  801783:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801786:	8b 45 08             	mov    0x8(%ebp),%eax
  801789:	8b 55 0c             	mov    0xc(%ebp),%edx
  80178c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80178f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801792:	8b 7d 18             	mov    0x18(%ebp),%edi
  801795:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801798:	cd 30                	int    $0x30
  80179a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80179d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8017a0:	83 c4 10             	add    $0x10,%esp
  8017a3:	5b                   	pop    %ebx
  8017a4:	5e                   	pop    %esi
  8017a5:	5f                   	pop    %edi
  8017a6:	5d                   	pop    %ebp
  8017a7:	c3                   	ret    

008017a8 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8017a8:	55                   	push   %ebp
  8017a9:	89 e5                	mov    %esp,%ebp
  8017ab:	83 ec 04             	sub    $0x4,%esp
  8017ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8017b1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8017b4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bb:	6a 00                	push   $0x0
  8017bd:	6a 00                	push   $0x0
  8017bf:	52                   	push   %edx
  8017c0:	ff 75 0c             	pushl  0xc(%ebp)
  8017c3:	50                   	push   %eax
  8017c4:	6a 00                	push   $0x0
  8017c6:	e8 b2 ff ff ff       	call   80177d <syscall>
  8017cb:	83 c4 18             	add    $0x18,%esp
}
  8017ce:	90                   	nop
  8017cf:	c9                   	leave  
  8017d0:	c3                   	ret    

008017d1 <sys_cgetc>:

int
sys_cgetc(void)
{
  8017d1:	55                   	push   %ebp
  8017d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8017d4:	6a 00                	push   $0x0
  8017d6:	6a 00                	push   $0x0
  8017d8:	6a 00                	push   $0x0
  8017da:	6a 00                	push   $0x0
  8017dc:	6a 00                	push   $0x0
  8017de:	6a 01                	push   $0x1
  8017e0:	e8 98 ff ff ff       	call   80177d <syscall>
  8017e5:	83 c4 18             	add    $0x18,%esp
}
  8017e8:	c9                   	leave  
  8017e9:	c3                   	ret    

008017ea <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8017ea:	55                   	push   %ebp
  8017eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8017ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f3:	6a 00                	push   $0x0
  8017f5:	6a 00                	push   $0x0
  8017f7:	6a 00                	push   $0x0
  8017f9:	52                   	push   %edx
  8017fa:	50                   	push   %eax
  8017fb:	6a 05                	push   $0x5
  8017fd:	e8 7b ff ff ff       	call   80177d <syscall>
  801802:	83 c4 18             	add    $0x18,%esp
}
  801805:	c9                   	leave  
  801806:	c3                   	ret    

00801807 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801807:	55                   	push   %ebp
  801808:	89 e5                	mov    %esp,%ebp
  80180a:	56                   	push   %esi
  80180b:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80180c:	8b 75 18             	mov    0x18(%ebp),%esi
  80180f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801812:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801815:	8b 55 0c             	mov    0xc(%ebp),%edx
  801818:	8b 45 08             	mov    0x8(%ebp),%eax
  80181b:	56                   	push   %esi
  80181c:	53                   	push   %ebx
  80181d:	51                   	push   %ecx
  80181e:	52                   	push   %edx
  80181f:	50                   	push   %eax
  801820:	6a 06                	push   $0x6
  801822:	e8 56 ff ff ff       	call   80177d <syscall>
  801827:	83 c4 18             	add    $0x18,%esp
}
  80182a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80182d:	5b                   	pop    %ebx
  80182e:	5e                   	pop    %esi
  80182f:	5d                   	pop    %ebp
  801830:	c3                   	ret    

00801831 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801831:	55                   	push   %ebp
  801832:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801834:	8b 55 0c             	mov    0xc(%ebp),%edx
  801837:	8b 45 08             	mov    0x8(%ebp),%eax
  80183a:	6a 00                	push   $0x0
  80183c:	6a 00                	push   $0x0
  80183e:	6a 00                	push   $0x0
  801840:	52                   	push   %edx
  801841:	50                   	push   %eax
  801842:	6a 07                	push   $0x7
  801844:	e8 34 ff ff ff       	call   80177d <syscall>
  801849:	83 c4 18             	add    $0x18,%esp
}
  80184c:	c9                   	leave  
  80184d:	c3                   	ret    

0080184e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80184e:	55                   	push   %ebp
  80184f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801851:	6a 00                	push   $0x0
  801853:	6a 00                	push   $0x0
  801855:	6a 00                	push   $0x0
  801857:	ff 75 0c             	pushl  0xc(%ebp)
  80185a:	ff 75 08             	pushl  0x8(%ebp)
  80185d:	6a 08                	push   $0x8
  80185f:	e8 19 ff ff ff       	call   80177d <syscall>
  801864:	83 c4 18             	add    $0x18,%esp
}
  801867:	c9                   	leave  
  801868:	c3                   	ret    

00801869 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801869:	55                   	push   %ebp
  80186a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80186c:	6a 00                	push   $0x0
  80186e:	6a 00                	push   $0x0
  801870:	6a 00                	push   $0x0
  801872:	6a 00                	push   $0x0
  801874:	6a 00                	push   $0x0
  801876:	6a 09                	push   $0x9
  801878:	e8 00 ff ff ff       	call   80177d <syscall>
  80187d:	83 c4 18             	add    $0x18,%esp
}
  801880:	c9                   	leave  
  801881:	c3                   	ret    

00801882 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801882:	55                   	push   %ebp
  801883:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801885:	6a 00                	push   $0x0
  801887:	6a 00                	push   $0x0
  801889:	6a 00                	push   $0x0
  80188b:	6a 00                	push   $0x0
  80188d:	6a 00                	push   $0x0
  80188f:	6a 0a                	push   $0xa
  801891:	e8 e7 fe ff ff       	call   80177d <syscall>
  801896:	83 c4 18             	add    $0x18,%esp
}
  801899:	c9                   	leave  
  80189a:	c3                   	ret    

0080189b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80189b:	55                   	push   %ebp
  80189c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80189e:	6a 00                	push   $0x0
  8018a0:	6a 00                	push   $0x0
  8018a2:	6a 00                	push   $0x0
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 0b                	push   $0xb
  8018aa:	e8 ce fe ff ff       	call   80177d <syscall>
  8018af:	83 c4 18             	add    $0x18,%esp
}
  8018b2:	c9                   	leave  
  8018b3:	c3                   	ret    

008018b4 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8018b4:	55                   	push   %ebp
  8018b5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8018b7:	6a 00                	push   $0x0
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 00                	push   $0x0
  8018bd:	ff 75 0c             	pushl  0xc(%ebp)
  8018c0:	ff 75 08             	pushl  0x8(%ebp)
  8018c3:	6a 0f                	push   $0xf
  8018c5:	e8 b3 fe ff ff       	call   80177d <syscall>
  8018ca:	83 c4 18             	add    $0x18,%esp
	return;
  8018cd:	90                   	nop
}
  8018ce:	c9                   	leave  
  8018cf:	c3                   	ret    

008018d0 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8018d0:	55                   	push   %ebp
  8018d1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8018d3:	6a 00                	push   $0x0
  8018d5:	6a 00                	push   $0x0
  8018d7:	6a 00                	push   $0x0
  8018d9:	ff 75 0c             	pushl  0xc(%ebp)
  8018dc:	ff 75 08             	pushl  0x8(%ebp)
  8018df:	6a 10                	push   $0x10
  8018e1:	e8 97 fe ff ff       	call   80177d <syscall>
  8018e6:	83 c4 18             	add    $0x18,%esp
	return ;
  8018e9:	90                   	nop
}
  8018ea:	c9                   	leave  
  8018eb:	c3                   	ret    

008018ec <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8018ec:	55                   	push   %ebp
  8018ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8018ef:	6a 00                	push   $0x0
  8018f1:	6a 00                	push   $0x0
  8018f3:	ff 75 10             	pushl  0x10(%ebp)
  8018f6:	ff 75 0c             	pushl  0xc(%ebp)
  8018f9:	ff 75 08             	pushl  0x8(%ebp)
  8018fc:	6a 11                	push   $0x11
  8018fe:	e8 7a fe ff ff       	call   80177d <syscall>
  801903:	83 c4 18             	add    $0x18,%esp
	return ;
  801906:	90                   	nop
}
  801907:	c9                   	leave  
  801908:	c3                   	ret    

00801909 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801909:	55                   	push   %ebp
  80190a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80190c:	6a 00                	push   $0x0
  80190e:	6a 00                	push   $0x0
  801910:	6a 00                	push   $0x0
  801912:	6a 00                	push   $0x0
  801914:	6a 00                	push   $0x0
  801916:	6a 0c                	push   $0xc
  801918:	e8 60 fe ff ff       	call   80177d <syscall>
  80191d:	83 c4 18             	add    $0x18,%esp
}
  801920:	c9                   	leave  
  801921:	c3                   	ret    

00801922 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801922:	55                   	push   %ebp
  801923:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801925:	6a 00                	push   $0x0
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	ff 75 08             	pushl  0x8(%ebp)
  801930:	6a 0d                	push   $0xd
  801932:	e8 46 fe ff ff       	call   80177d <syscall>
  801937:	83 c4 18             	add    $0x18,%esp
}
  80193a:	c9                   	leave  
  80193b:	c3                   	ret    

0080193c <sys_scarce_memory>:

void sys_scarce_memory()
{
  80193c:	55                   	push   %ebp
  80193d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80193f:	6a 00                	push   $0x0
  801941:	6a 00                	push   $0x0
  801943:	6a 00                	push   $0x0
  801945:	6a 00                	push   $0x0
  801947:	6a 00                	push   $0x0
  801949:	6a 0e                	push   $0xe
  80194b:	e8 2d fe ff ff       	call   80177d <syscall>
  801950:	83 c4 18             	add    $0x18,%esp
}
  801953:	90                   	nop
  801954:	c9                   	leave  
  801955:	c3                   	ret    

00801956 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801956:	55                   	push   %ebp
  801957:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801959:	6a 00                	push   $0x0
  80195b:	6a 00                	push   $0x0
  80195d:	6a 00                	push   $0x0
  80195f:	6a 00                	push   $0x0
  801961:	6a 00                	push   $0x0
  801963:	6a 13                	push   $0x13
  801965:	e8 13 fe ff ff       	call   80177d <syscall>
  80196a:	83 c4 18             	add    $0x18,%esp
}
  80196d:	90                   	nop
  80196e:	c9                   	leave  
  80196f:	c3                   	ret    

00801970 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801970:	55                   	push   %ebp
  801971:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801973:	6a 00                	push   $0x0
  801975:	6a 00                	push   $0x0
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	6a 14                	push   $0x14
  80197f:	e8 f9 fd ff ff       	call   80177d <syscall>
  801984:	83 c4 18             	add    $0x18,%esp
}
  801987:	90                   	nop
  801988:	c9                   	leave  
  801989:	c3                   	ret    

0080198a <sys_cputc>:


void
sys_cputc(const char c)
{
  80198a:	55                   	push   %ebp
  80198b:	89 e5                	mov    %esp,%ebp
  80198d:	83 ec 04             	sub    $0x4,%esp
  801990:	8b 45 08             	mov    0x8(%ebp),%eax
  801993:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801996:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80199a:	6a 00                	push   $0x0
  80199c:	6a 00                	push   $0x0
  80199e:	6a 00                	push   $0x0
  8019a0:	6a 00                	push   $0x0
  8019a2:	50                   	push   %eax
  8019a3:	6a 15                	push   $0x15
  8019a5:	e8 d3 fd ff ff       	call   80177d <syscall>
  8019aa:	83 c4 18             	add    $0x18,%esp
}
  8019ad:	90                   	nop
  8019ae:	c9                   	leave  
  8019af:	c3                   	ret    

008019b0 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8019b0:	55                   	push   %ebp
  8019b1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 16                	push   $0x16
  8019bf:	e8 b9 fd ff ff       	call   80177d <syscall>
  8019c4:	83 c4 18             	add    $0x18,%esp
}
  8019c7:	90                   	nop
  8019c8:	c9                   	leave  
  8019c9:	c3                   	ret    

008019ca <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8019ca:	55                   	push   %ebp
  8019cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8019cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 00                	push   $0x0
  8019d6:	ff 75 0c             	pushl  0xc(%ebp)
  8019d9:	50                   	push   %eax
  8019da:	6a 17                	push   $0x17
  8019dc:	e8 9c fd ff ff       	call   80177d <syscall>
  8019e1:	83 c4 18             	add    $0x18,%esp
}
  8019e4:	c9                   	leave  
  8019e5:	c3                   	ret    

008019e6 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8019e6:	55                   	push   %ebp
  8019e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 00                	push   $0x0
  8019f5:	52                   	push   %edx
  8019f6:	50                   	push   %eax
  8019f7:	6a 1a                	push   $0x1a
  8019f9:	e8 7f fd ff ff       	call   80177d <syscall>
  8019fe:	83 c4 18             	add    $0x18,%esp
}
  801a01:	c9                   	leave  
  801a02:	c3                   	ret    

00801a03 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a03:	55                   	push   %ebp
  801a04:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a06:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a09:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 00                	push   $0x0
  801a12:	52                   	push   %edx
  801a13:	50                   	push   %eax
  801a14:	6a 18                	push   $0x18
  801a16:	e8 62 fd ff ff       	call   80177d <syscall>
  801a1b:	83 c4 18             	add    $0x18,%esp
}
  801a1e:	90                   	nop
  801a1f:	c9                   	leave  
  801a20:	c3                   	ret    

00801a21 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a21:	55                   	push   %ebp
  801a22:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a24:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a27:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	52                   	push   %edx
  801a31:	50                   	push   %eax
  801a32:	6a 19                	push   $0x19
  801a34:	e8 44 fd ff ff       	call   80177d <syscall>
  801a39:	83 c4 18             	add    $0x18,%esp
}
  801a3c:	90                   	nop
  801a3d:	c9                   	leave  
  801a3e:	c3                   	ret    

00801a3f <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a3f:	55                   	push   %ebp
  801a40:	89 e5                	mov    %esp,%ebp
  801a42:	83 ec 04             	sub    $0x4,%esp
  801a45:	8b 45 10             	mov    0x10(%ebp),%eax
  801a48:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a4b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a4e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a52:	8b 45 08             	mov    0x8(%ebp),%eax
  801a55:	6a 00                	push   $0x0
  801a57:	51                   	push   %ecx
  801a58:	52                   	push   %edx
  801a59:	ff 75 0c             	pushl  0xc(%ebp)
  801a5c:	50                   	push   %eax
  801a5d:	6a 1b                	push   $0x1b
  801a5f:	e8 19 fd ff ff       	call   80177d <syscall>
  801a64:	83 c4 18             	add    $0x18,%esp
}
  801a67:	c9                   	leave  
  801a68:	c3                   	ret    

00801a69 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a69:	55                   	push   %ebp
  801a6a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a72:	6a 00                	push   $0x0
  801a74:	6a 00                	push   $0x0
  801a76:	6a 00                	push   $0x0
  801a78:	52                   	push   %edx
  801a79:	50                   	push   %eax
  801a7a:	6a 1c                	push   $0x1c
  801a7c:	e8 fc fc ff ff       	call   80177d <syscall>
  801a81:	83 c4 18             	add    $0x18,%esp
}
  801a84:	c9                   	leave  
  801a85:	c3                   	ret    

00801a86 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a86:	55                   	push   %ebp
  801a87:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a89:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	51                   	push   %ecx
  801a97:	52                   	push   %edx
  801a98:	50                   	push   %eax
  801a99:	6a 1d                	push   $0x1d
  801a9b:	e8 dd fc ff ff       	call   80177d <syscall>
  801aa0:	83 c4 18             	add    $0x18,%esp
}
  801aa3:	c9                   	leave  
  801aa4:	c3                   	ret    

00801aa5 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801aa5:	55                   	push   %ebp
  801aa6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801aa8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aab:	8b 45 08             	mov    0x8(%ebp),%eax
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	52                   	push   %edx
  801ab5:	50                   	push   %eax
  801ab6:	6a 1e                	push   $0x1e
  801ab8:	e8 c0 fc ff ff       	call   80177d <syscall>
  801abd:	83 c4 18             	add    $0x18,%esp
}
  801ac0:	c9                   	leave  
  801ac1:	c3                   	ret    

00801ac2 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801ac2:	55                   	push   %ebp
  801ac3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	6a 1f                	push   $0x1f
  801ad1:	e8 a7 fc ff ff       	call   80177d <syscall>
  801ad6:	83 c4 18             	add    $0x18,%esp
}
  801ad9:	c9                   	leave  
  801ada:	c3                   	ret    

00801adb <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801adb:	55                   	push   %ebp
  801adc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801ade:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae1:	6a 00                	push   $0x0
  801ae3:	ff 75 14             	pushl  0x14(%ebp)
  801ae6:	ff 75 10             	pushl  0x10(%ebp)
  801ae9:	ff 75 0c             	pushl  0xc(%ebp)
  801aec:	50                   	push   %eax
  801aed:	6a 20                	push   $0x20
  801aef:	e8 89 fc ff ff       	call   80177d <syscall>
  801af4:	83 c4 18             	add    $0x18,%esp
}
  801af7:	c9                   	leave  
  801af8:	c3                   	ret    

00801af9 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801af9:	55                   	push   %ebp
  801afa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801afc:	8b 45 08             	mov    0x8(%ebp),%eax
  801aff:	6a 00                	push   $0x0
  801b01:	6a 00                	push   $0x0
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	50                   	push   %eax
  801b08:	6a 21                	push   $0x21
  801b0a:	e8 6e fc ff ff       	call   80177d <syscall>
  801b0f:	83 c4 18             	add    $0x18,%esp
}
  801b12:	90                   	nop
  801b13:	c9                   	leave  
  801b14:	c3                   	ret    

00801b15 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b15:	55                   	push   %ebp
  801b16:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b18:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1b:	6a 00                	push   $0x0
  801b1d:	6a 00                	push   $0x0
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 00                	push   $0x0
  801b23:	50                   	push   %eax
  801b24:	6a 22                	push   $0x22
  801b26:	e8 52 fc ff ff       	call   80177d <syscall>
  801b2b:	83 c4 18             	add    $0x18,%esp
}
  801b2e:	c9                   	leave  
  801b2f:	c3                   	ret    

00801b30 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b30:	55                   	push   %ebp
  801b31:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b33:	6a 00                	push   $0x0
  801b35:	6a 00                	push   $0x0
  801b37:	6a 00                	push   $0x0
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 02                	push   $0x2
  801b3f:	e8 39 fc ff ff       	call   80177d <syscall>
  801b44:	83 c4 18             	add    $0x18,%esp
}
  801b47:	c9                   	leave  
  801b48:	c3                   	ret    

00801b49 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b49:	55                   	push   %ebp
  801b4a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 00                	push   $0x0
  801b50:	6a 00                	push   $0x0
  801b52:	6a 00                	push   $0x0
  801b54:	6a 00                	push   $0x0
  801b56:	6a 03                	push   $0x3
  801b58:	e8 20 fc ff ff       	call   80177d <syscall>
  801b5d:	83 c4 18             	add    $0x18,%esp
}
  801b60:	c9                   	leave  
  801b61:	c3                   	ret    

00801b62 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b62:	55                   	push   %ebp
  801b63:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b65:	6a 00                	push   $0x0
  801b67:	6a 00                	push   $0x0
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 04                	push   $0x4
  801b71:	e8 07 fc ff ff       	call   80177d <syscall>
  801b76:	83 c4 18             	add    $0x18,%esp
}
  801b79:	c9                   	leave  
  801b7a:	c3                   	ret    

00801b7b <sys_exit_env>:


void sys_exit_env(void)
{
  801b7b:	55                   	push   %ebp
  801b7c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 00                	push   $0x0
  801b82:	6a 00                	push   $0x0
  801b84:	6a 00                	push   $0x0
  801b86:	6a 00                	push   $0x0
  801b88:	6a 23                	push   $0x23
  801b8a:	e8 ee fb ff ff       	call   80177d <syscall>
  801b8f:	83 c4 18             	add    $0x18,%esp
}
  801b92:	90                   	nop
  801b93:	c9                   	leave  
  801b94:	c3                   	ret    

00801b95 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801b95:	55                   	push   %ebp
  801b96:	89 e5                	mov    %esp,%ebp
  801b98:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b9b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b9e:	8d 50 04             	lea    0x4(%eax),%edx
  801ba1:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 00                	push   $0x0
  801baa:	52                   	push   %edx
  801bab:	50                   	push   %eax
  801bac:	6a 24                	push   $0x24
  801bae:	e8 ca fb ff ff       	call   80177d <syscall>
  801bb3:	83 c4 18             	add    $0x18,%esp
	return result;
  801bb6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801bb9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bbc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801bbf:	89 01                	mov    %eax,(%ecx)
  801bc1:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc7:	c9                   	leave  
  801bc8:	c2 04 00             	ret    $0x4

00801bcb <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801bcb:	55                   	push   %ebp
  801bcc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 00                	push   $0x0
  801bd2:	ff 75 10             	pushl  0x10(%ebp)
  801bd5:	ff 75 0c             	pushl  0xc(%ebp)
  801bd8:	ff 75 08             	pushl  0x8(%ebp)
  801bdb:	6a 12                	push   $0x12
  801bdd:	e8 9b fb ff ff       	call   80177d <syscall>
  801be2:	83 c4 18             	add    $0x18,%esp
	return ;
  801be5:	90                   	nop
}
  801be6:	c9                   	leave  
  801be7:	c3                   	ret    

00801be8 <sys_rcr2>:
uint32 sys_rcr2()
{
  801be8:	55                   	push   %ebp
  801be9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 25                	push   $0x25
  801bf7:	e8 81 fb ff ff       	call   80177d <syscall>
  801bfc:	83 c4 18             	add    $0x18,%esp
}
  801bff:	c9                   	leave  
  801c00:	c3                   	ret    

00801c01 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c01:	55                   	push   %ebp
  801c02:	89 e5                	mov    %esp,%ebp
  801c04:	83 ec 04             	sub    $0x4,%esp
  801c07:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c0d:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c11:	6a 00                	push   $0x0
  801c13:	6a 00                	push   $0x0
  801c15:	6a 00                	push   $0x0
  801c17:	6a 00                	push   $0x0
  801c19:	50                   	push   %eax
  801c1a:	6a 26                	push   $0x26
  801c1c:	e8 5c fb ff ff       	call   80177d <syscall>
  801c21:	83 c4 18             	add    $0x18,%esp
	return ;
  801c24:	90                   	nop
}
  801c25:	c9                   	leave  
  801c26:	c3                   	ret    

00801c27 <rsttst>:
void rsttst()
{
  801c27:	55                   	push   %ebp
  801c28:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c2a:	6a 00                	push   $0x0
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	6a 28                	push   $0x28
  801c36:	e8 42 fb ff ff       	call   80177d <syscall>
  801c3b:	83 c4 18             	add    $0x18,%esp
	return ;
  801c3e:	90                   	nop
}
  801c3f:	c9                   	leave  
  801c40:	c3                   	ret    

00801c41 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c41:	55                   	push   %ebp
  801c42:	89 e5                	mov    %esp,%ebp
  801c44:	83 ec 04             	sub    $0x4,%esp
  801c47:	8b 45 14             	mov    0x14(%ebp),%eax
  801c4a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c4d:	8b 55 18             	mov    0x18(%ebp),%edx
  801c50:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c54:	52                   	push   %edx
  801c55:	50                   	push   %eax
  801c56:	ff 75 10             	pushl  0x10(%ebp)
  801c59:	ff 75 0c             	pushl  0xc(%ebp)
  801c5c:	ff 75 08             	pushl  0x8(%ebp)
  801c5f:	6a 27                	push   $0x27
  801c61:	e8 17 fb ff ff       	call   80177d <syscall>
  801c66:	83 c4 18             	add    $0x18,%esp
	return ;
  801c69:	90                   	nop
}
  801c6a:	c9                   	leave  
  801c6b:	c3                   	ret    

00801c6c <chktst>:
void chktst(uint32 n)
{
  801c6c:	55                   	push   %ebp
  801c6d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 00                	push   $0x0
  801c73:	6a 00                	push   $0x0
  801c75:	6a 00                	push   $0x0
  801c77:	ff 75 08             	pushl  0x8(%ebp)
  801c7a:	6a 29                	push   $0x29
  801c7c:	e8 fc fa ff ff       	call   80177d <syscall>
  801c81:	83 c4 18             	add    $0x18,%esp
	return ;
  801c84:	90                   	nop
}
  801c85:	c9                   	leave  
  801c86:	c3                   	ret    

00801c87 <inctst>:

void inctst()
{
  801c87:	55                   	push   %ebp
  801c88:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	6a 00                	push   $0x0
  801c94:	6a 2a                	push   $0x2a
  801c96:	e8 e2 fa ff ff       	call   80177d <syscall>
  801c9b:	83 c4 18             	add    $0x18,%esp
	return ;
  801c9e:	90                   	nop
}
  801c9f:	c9                   	leave  
  801ca0:	c3                   	ret    

00801ca1 <gettst>:
uint32 gettst()
{
  801ca1:	55                   	push   %ebp
  801ca2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 00                	push   $0x0
  801cac:	6a 00                	push   $0x0
  801cae:	6a 2b                	push   $0x2b
  801cb0:	e8 c8 fa ff ff       	call   80177d <syscall>
  801cb5:	83 c4 18             	add    $0x18,%esp
}
  801cb8:	c9                   	leave  
  801cb9:	c3                   	ret    

00801cba <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801cba:	55                   	push   %ebp
  801cbb:	89 e5                	mov    %esp,%ebp
  801cbd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 00                	push   $0x0
  801cc6:	6a 00                	push   $0x0
  801cc8:	6a 00                	push   $0x0
  801cca:	6a 2c                	push   $0x2c
  801ccc:	e8 ac fa ff ff       	call   80177d <syscall>
  801cd1:	83 c4 18             	add    $0x18,%esp
  801cd4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801cd7:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801cdb:	75 07                	jne    801ce4 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801cdd:	b8 01 00 00 00       	mov    $0x1,%eax
  801ce2:	eb 05                	jmp    801ce9 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801ce4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ce9:	c9                   	leave  
  801cea:	c3                   	ret    

00801ceb <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801ceb:	55                   	push   %ebp
  801cec:	89 e5                	mov    %esp,%ebp
  801cee:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cf1:	6a 00                	push   $0x0
  801cf3:	6a 00                	push   $0x0
  801cf5:	6a 00                	push   $0x0
  801cf7:	6a 00                	push   $0x0
  801cf9:	6a 00                	push   $0x0
  801cfb:	6a 2c                	push   $0x2c
  801cfd:	e8 7b fa ff ff       	call   80177d <syscall>
  801d02:	83 c4 18             	add    $0x18,%esp
  801d05:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d08:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d0c:	75 07                	jne    801d15 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d0e:	b8 01 00 00 00       	mov    $0x1,%eax
  801d13:	eb 05                	jmp    801d1a <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d15:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d1a:	c9                   	leave  
  801d1b:	c3                   	ret    

00801d1c <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
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
  801d2e:	e8 4a fa ff ff       	call   80177d <syscall>
  801d33:	83 c4 18             	add    $0x18,%esp
  801d36:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d39:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d3d:	75 07                	jne    801d46 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d3f:	b8 01 00 00 00       	mov    $0x1,%eax
  801d44:	eb 05                	jmp    801d4b <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d46:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d4b:	c9                   	leave  
  801d4c:	c3                   	ret    

00801d4d <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
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
  801d5f:	e8 19 fa ff ff       	call   80177d <syscall>
  801d64:	83 c4 18             	add    $0x18,%esp
  801d67:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d6a:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d6e:	75 07                	jne    801d77 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d70:	b8 01 00 00 00       	mov    $0x1,%eax
  801d75:	eb 05                	jmp    801d7c <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d77:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d7c:	c9                   	leave  
  801d7d:	c3                   	ret    

00801d7e <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d7e:	55                   	push   %ebp
  801d7f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d81:	6a 00                	push   $0x0
  801d83:	6a 00                	push   $0x0
  801d85:	6a 00                	push   $0x0
  801d87:	6a 00                	push   $0x0
  801d89:	ff 75 08             	pushl  0x8(%ebp)
  801d8c:	6a 2d                	push   $0x2d
  801d8e:	e8 ea f9 ff ff       	call   80177d <syscall>
  801d93:	83 c4 18             	add    $0x18,%esp
	return ;
  801d96:	90                   	nop
}
  801d97:	c9                   	leave  
  801d98:	c3                   	ret    

00801d99 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d99:	55                   	push   %ebp
  801d9a:	89 e5                	mov    %esp,%ebp
  801d9c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d9d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801da0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801da3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801da6:	8b 45 08             	mov    0x8(%ebp),%eax
  801da9:	6a 00                	push   $0x0
  801dab:	53                   	push   %ebx
  801dac:	51                   	push   %ecx
  801dad:	52                   	push   %edx
  801dae:	50                   	push   %eax
  801daf:	6a 2e                	push   $0x2e
  801db1:	e8 c7 f9 ff ff       	call   80177d <syscall>
  801db6:	83 c4 18             	add    $0x18,%esp
}
  801db9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dbc:	c9                   	leave  
  801dbd:	c3                   	ret    

00801dbe <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801dbe:	55                   	push   %ebp
  801dbf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801dc1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc7:	6a 00                	push   $0x0
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 00                	push   $0x0
  801dcd:	52                   	push   %edx
  801dce:	50                   	push   %eax
  801dcf:	6a 2f                	push   $0x2f
  801dd1:	e8 a7 f9 ff ff       	call   80177d <syscall>
  801dd6:	83 c4 18             	add    $0x18,%esp
}
  801dd9:	c9                   	leave  
  801dda:	c3                   	ret    

00801ddb <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801ddb:	55                   	push   %ebp
  801ddc:	89 e5                	mov    %esp,%ebp
  801dde:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801de1:	83 ec 0c             	sub    $0xc,%esp
  801de4:	68 1c 39 80 00       	push   $0x80391c
  801de9:	e8 21 e7 ff ff       	call   80050f <cprintf>
  801dee:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801df1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801df8:	83 ec 0c             	sub    $0xc,%esp
  801dfb:	68 48 39 80 00       	push   $0x803948
  801e00:	e8 0a e7 ff ff       	call   80050f <cprintf>
  801e05:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801e08:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e0c:	a1 38 41 80 00       	mov    0x804138,%eax
  801e11:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e14:	eb 56                	jmp    801e6c <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e16:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e1a:	74 1c                	je     801e38 <print_mem_block_lists+0x5d>
  801e1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e1f:	8b 50 08             	mov    0x8(%eax),%edx
  801e22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e25:	8b 48 08             	mov    0x8(%eax),%ecx
  801e28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e2b:	8b 40 0c             	mov    0xc(%eax),%eax
  801e2e:	01 c8                	add    %ecx,%eax
  801e30:	39 c2                	cmp    %eax,%edx
  801e32:	73 04                	jae    801e38 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801e34:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e3b:	8b 50 08             	mov    0x8(%eax),%edx
  801e3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e41:	8b 40 0c             	mov    0xc(%eax),%eax
  801e44:	01 c2                	add    %eax,%edx
  801e46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e49:	8b 40 08             	mov    0x8(%eax),%eax
  801e4c:	83 ec 04             	sub    $0x4,%esp
  801e4f:	52                   	push   %edx
  801e50:	50                   	push   %eax
  801e51:	68 5d 39 80 00       	push   $0x80395d
  801e56:	e8 b4 e6 ff ff       	call   80050f <cprintf>
  801e5b:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e61:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e64:	a1 40 41 80 00       	mov    0x804140,%eax
  801e69:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e6c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e70:	74 07                	je     801e79 <print_mem_block_lists+0x9e>
  801e72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e75:	8b 00                	mov    (%eax),%eax
  801e77:	eb 05                	jmp    801e7e <print_mem_block_lists+0xa3>
  801e79:	b8 00 00 00 00       	mov    $0x0,%eax
  801e7e:	a3 40 41 80 00       	mov    %eax,0x804140
  801e83:	a1 40 41 80 00       	mov    0x804140,%eax
  801e88:	85 c0                	test   %eax,%eax
  801e8a:	75 8a                	jne    801e16 <print_mem_block_lists+0x3b>
  801e8c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e90:	75 84                	jne    801e16 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801e92:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e96:	75 10                	jne    801ea8 <print_mem_block_lists+0xcd>
  801e98:	83 ec 0c             	sub    $0xc,%esp
  801e9b:	68 6c 39 80 00       	push   $0x80396c
  801ea0:	e8 6a e6 ff ff       	call   80050f <cprintf>
  801ea5:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801ea8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801eaf:	83 ec 0c             	sub    $0xc,%esp
  801eb2:	68 90 39 80 00       	push   $0x803990
  801eb7:	e8 53 e6 ff ff       	call   80050f <cprintf>
  801ebc:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801ebf:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801ec3:	a1 40 40 80 00       	mov    0x804040,%eax
  801ec8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ecb:	eb 56                	jmp    801f23 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ecd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ed1:	74 1c                	je     801eef <print_mem_block_lists+0x114>
  801ed3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed6:	8b 50 08             	mov    0x8(%eax),%edx
  801ed9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801edc:	8b 48 08             	mov    0x8(%eax),%ecx
  801edf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ee2:	8b 40 0c             	mov    0xc(%eax),%eax
  801ee5:	01 c8                	add    %ecx,%eax
  801ee7:	39 c2                	cmp    %eax,%edx
  801ee9:	73 04                	jae    801eef <print_mem_block_lists+0x114>
			sorted = 0 ;
  801eeb:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801eef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef2:	8b 50 08             	mov    0x8(%eax),%edx
  801ef5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef8:	8b 40 0c             	mov    0xc(%eax),%eax
  801efb:	01 c2                	add    %eax,%edx
  801efd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f00:	8b 40 08             	mov    0x8(%eax),%eax
  801f03:	83 ec 04             	sub    $0x4,%esp
  801f06:	52                   	push   %edx
  801f07:	50                   	push   %eax
  801f08:	68 5d 39 80 00       	push   $0x80395d
  801f0d:	e8 fd e5 ff ff       	call   80050f <cprintf>
  801f12:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f18:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f1b:	a1 48 40 80 00       	mov    0x804048,%eax
  801f20:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f23:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f27:	74 07                	je     801f30 <print_mem_block_lists+0x155>
  801f29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f2c:	8b 00                	mov    (%eax),%eax
  801f2e:	eb 05                	jmp    801f35 <print_mem_block_lists+0x15a>
  801f30:	b8 00 00 00 00       	mov    $0x0,%eax
  801f35:	a3 48 40 80 00       	mov    %eax,0x804048
  801f3a:	a1 48 40 80 00       	mov    0x804048,%eax
  801f3f:	85 c0                	test   %eax,%eax
  801f41:	75 8a                	jne    801ecd <print_mem_block_lists+0xf2>
  801f43:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f47:	75 84                	jne    801ecd <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801f49:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f4d:	75 10                	jne    801f5f <print_mem_block_lists+0x184>
  801f4f:	83 ec 0c             	sub    $0xc,%esp
  801f52:	68 a8 39 80 00       	push   $0x8039a8
  801f57:	e8 b3 e5 ff ff       	call   80050f <cprintf>
  801f5c:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801f5f:	83 ec 0c             	sub    $0xc,%esp
  801f62:	68 1c 39 80 00       	push   $0x80391c
  801f67:	e8 a3 e5 ff ff       	call   80050f <cprintf>
  801f6c:	83 c4 10             	add    $0x10,%esp

}
  801f6f:	90                   	nop
  801f70:	c9                   	leave  
  801f71:	c3                   	ret    

00801f72 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801f72:	55                   	push   %ebp
  801f73:	89 e5                	mov    %esp,%ebp
  801f75:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  801f78:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801f7f:	00 00 00 
  801f82:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801f89:	00 00 00 
  801f8c:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801f93:	00 00 00 
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  801f96:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801f9d:	e9 9e 00 00 00       	jmp    802040 <initialize_MemBlocksList+0xce>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
  801fa2:	a1 50 40 80 00       	mov    0x804050,%eax
  801fa7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801faa:	c1 e2 04             	shl    $0x4,%edx
  801fad:	01 d0                	add    %edx,%eax
  801faf:	85 c0                	test   %eax,%eax
  801fb1:	75 14                	jne    801fc7 <initialize_MemBlocksList+0x55>
  801fb3:	83 ec 04             	sub    $0x4,%esp
  801fb6:	68 d0 39 80 00       	push   $0x8039d0
  801fbb:	6a 43                	push   $0x43
  801fbd:	68 f3 39 80 00       	push   $0x8039f3
  801fc2:	e8 94 e2 ff ff       	call   80025b <_panic>
  801fc7:	a1 50 40 80 00       	mov    0x804050,%eax
  801fcc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fcf:	c1 e2 04             	shl    $0x4,%edx
  801fd2:	01 d0                	add    %edx,%eax
  801fd4:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801fda:	89 10                	mov    %edx,(%eax)
  801fdc:	8b 00                	mov    (%eax),%eax
  801fde:	85 c0                	test   %eax,%eax
  801fe0:	74 18                	je     801ffa <initialize_MemBlocksList+0x88>
  801fe2:	a1 48 41 80 00       	mov    0x804148,%eax
  801fe7:	8b 15 50 40 80 00    	mov    0x804050,%edx
  801fed:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801ff0:	c1 e1 04             	shl    $0x4,%ecx
  801ff3:	01 ca                	add    %ecx,%edx
  801ff5:	89 50 04             	mov    %edx,0x4(%eax)
  801ff8:	eb 12                	jmp    80200c <initialize_MemBlocksList+0x9a>
  801ffa:	a1 50 40 80 00       	mov    0x804050,%eax
  801fff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802002:	c1 e2 04             	shl    $0x4,%edx
  802005:	01 d0                	add    %edx,%eax
  802007:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80200c:	a1 50 40 80 00       	mov    0x804050,%eax
  802011:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802014:	c1 e2 04             	shl    $0x4,%edx
  802017:	01 d0                	add    %edx,%eax
  802019:	a3 48 41 80 00       	mov    %eax,0x804148
  80201e:	a1 50 40 80 00       	mov    0x804050,%eax
  802023:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802026:	c1 e2 04             	shl    $0x4,%edx
  802029:	01 d0                	add    %edx,%eax
  80202b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802032:	a1 54 41 80 00       	mov    0x804154,%eax
  802037:	40                   	inc    %eax
  802038:	a3 54 41 80 00       	mov    %eax,0x804154
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  80203d:	ff 45 f4             	incl   -0xc(%ebp)
  802040:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802043:	3b 45 08             	cmp    0x8(%ebp),%eax
  802046:	0f 82 56 ff ff ff    	jb     801fa2 <initialize_MemBlocksList+0x30>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
		}
}
  80204c:	90                   	nop
  80204d:	c9                   	leave  
  80204e:	c3                   	ret    

0080204f <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80204f:	55                   	push   %ebp
  802050:	89 e5                	mov    %esp,%ebp
  802052:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  802055:	a1 38 41 80 00       	mov    0x804138,%eax
  80205a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80205d:	eb 18                	jmp    802077 <find_block+0x28>
	{
		if (ele->sva==va)
  80205f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802062:	8b 40 08             	mov    0x8(%eax),%eax
  802065:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802068:	75 05                	jne    80206f <find_block+0x20>
			return ele;
  80206a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80206d:	eb 7b                	jmp    8020ea <find_block+0x9b>
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  80206f:	a1 40 41 80 00       	mov    0x804140,%eax
  802074:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802077:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80207b:	74 07                	je     802084 <find_block+0x35>
  80207d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802080:	8b 00                	mov    (%eax),%eax
  802082:	eb 05                	jmp    802089 <find_block+0x3a>
  802084:	b8 00 00 00 00       	mov    $0x0,%eax
  802089:	a3 40 41 80 00       	mov    %eax,0x804140
  80208e:	a1 40 41 80 00       	mov    0x804140,%eax
  802093:	85 c0                	test   %eax,%eax
  802095:	75 c8                	jne    80205f <find_block+0x10>
  802097:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80209b:	75 c2                	jne    80205f <find_block+0x10>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  80209d:	a1 40 40 80 00       	mov    0x804040,%eax
  8020a2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020a5:	eb 18                	jmp    8020bf <find_block+0x70>
	{
		if (ele->sva==va)
  8020a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020aa:	8b 40 08             	mov    0x8(%eax),%eax
  8020ad:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8020b0:	75 05                	jne    8020b7 <find_block+0x68>
					return ele;
  8020b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020b5:	eb 33                	jmp    8020ea <find_block+0x9b>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  8020b7:	a1 48 40 80 00       	mov    0x804048,%eax
  8020bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020bf:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020c3:	74 07                	je     8020cc <find_block+0x7d>
  8020c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020c8:	8b 00                	mov    (%eax),%eax
  8020ca:	eb 05                	jmp    8020d1 <find_block+0x82>
  8020cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8020d1:	a3 48 40 80 00       	mov    %eax,0x804048
  8020d6:	a1 48 40 80 00       	mov    0x804048,%eax
  8020db:	85 c0                	test   %eax,%eax
  8020dd:	75 c8                	jne    8020a7 <find_block+0x58>
  8020df:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020e3:	75 c2                	jne    8020a7 <find_block+0x58>
	{
		if (ele->sva==va)
					return ele;
	}
return NULL;
  8020e5:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  8020ea:	c9                   	leave  
  8020eb:	c3                   	ret    

008020ec <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8020ec:	55                   	push   %ebp
  8020ed:	89 e5                	mov    %esp,%ebp
  8020ef:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;

int x =LIST_SIZE(&AllocMemBlocksList);
  8020f2:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8020f7:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((x==0))
  8020fa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020fe:	75 62                	jne    802162 <insert_sorted_allocList+0x76>
	{
	//	blockToInsert=AllocMemBlocksList.lh_first;
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  802100:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802104:	75 14                	jne    80211a <insert_sorted_allocList+0x2e>
  802106:	83 ec 04             	sub    $0x4,%esp
  802109:	68 d0 39 80 00       	push   $0x8039d0
  80210e:	6a 69                	push   $0x69
  802110:	68 f3 39 80 00       	push   $0x8039f3
  802115:	e8 41 e1 ff ff       	call   80025b <_panic>
  80211a:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802120:	8b 45 08             	mov    0x8(%ebp),%eax
  802123:	89 10                	mov    %edx,(%eax)
  802125:	8b 45 08             	mov    0x8(%ebp),%eax
  802128:	8b 00                	mov    (%eax),%eax
  80212a:	85 c0                	test   %eax,%eax
  80212c:	74 0d                	je     80213b <insert_sorted_allocList+0x4f>
  80212e:	a1 40 40 80 00       	mov    0x804040,%eax
  802133:	8b 55 08             	mov    0x8(%ebp),%edx
  802136:	89 50 04             	mov    %edx,0x4(%eax)
  802139:	eb 08                	jmp    802143 <insert_sorted_allocList+0x57>
  80213b:	8b 45 08             	mov    0x8(%ebp),%eax
  80213e:	a3 44 40 80 00       	mov    %eax,0x804044
  802143:	8b 45 08             	mov    0x8(%ebp),%eax
  802146:	a3 40 40 80 00       	mov    %eax,0x804040
  80214b:	8b 45 08             	mov    0x8(%ebp),%eax
  80214e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802155:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80215a:	40                   	inc    %eax
  80215b:	a3 4c 40 80 00       	mov    %eax,0x80404c
  802160:	eb 72                	jmp    8021d4 <insert_sorted_allocList+0xe8>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
  802162:	a1 40 40 80 00       	mov    0x804040,%eax
  802167:	8b 50 08             	mov    0x8(%eax),%edx
  80216a:	8b 45 08             	mov    0x8(%ebp),%eax
  80216d:	8b 40 08             	mov    0x8(%eax),%eax
  802170:	39 c2                	cmp    %eax,%edx
  802172:	76 60                	jbe    8021d4 <insert_sorted_allocList+0xe8>
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  802174:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802178:	75 14                	jne    80218e <insert_sorted_allocList+0xa2>
  80217a:	83 ec 04             	sub    $0x4,%esp
  80217d:	68 d0 39 80 00       	push   $0x8039d0
  802182:	6a 6d                	push   $0x6d
  802184:	68 f3 39 80 00       	push   $0x8039f3
  802189:	e8 cd e0 ff ff       	call   80025b <_panic>
  80218e:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802194:	8b 45 08             	mov    0x8(%ebp),%eax
  802197:	89 10                	mov    %edx,(%eax)
  802199:	8b 45 08             	mov    0x8(%ebp),%eax
  80219c:	8b 00                	mov    (%eax),%eax
  80219e:	85 c0                	test   %eax,%eax
  8021a0:	74 0d                	je     8021af <insert_sorted_allocList+0xc3>
  8021a2:	a1 40 40 80 00       	mov    0x804040,%eax
  8021a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8021aa:	89 50 04             	mov    %edx,0x4(%eax)
  8021ad:	eb 08                	jmp    8021b7 <insert_sorted_allocList+0xcb>
  8021af:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b2:	a3 44 40 80 00       	mov    %eax,0x804044
  8021b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ba:	a3 40 40 80 00       	mov    %eax,0x804040
  8021bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021c9:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021ce:	40                   	inc    %eax
  8021cf:	a3 4c 40 80 00       	mov    %eax,0x80404c
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  8021d4:	a1 40 40 80 00       	mov    0x804040,%eax
  8021d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021dc:	e9 b9 01 00 00       	jmp    80239a <insert_sorted_allocList+0x2ae>
	{


		if ((blockToInsert->sva>AllocMemBlocksList.lh_first->sva)&&blockToInsert->sva<element->sva)
  8021e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e4:	8b 50 08             	mov    0x8(%eax),%edx
  8021e7:	a1 40 40 80 00       	mov    0x804040,%eax
  8021ec:	8b 40 08             	mov    0x8(%eax),%eax
  8021ef:	39 c2                	cmp    %eax,%edx
  8021f1:	76 7c                	jbe    80226f <insert_sorted_allocList+0x183>
  8021f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f6:	8b 50 08             	mov    0x8(%eax),%edx
  8021f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021fc:	8b 40 08             	mov    0x8(%eax),%eax
  8021ff:	39 c2                	cmp    %eax,%edx
  802201:	73 6c                	jae    80226f <insert_sorted_allocList+0x183>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,element,blockToInsert);
  802203:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802207:	74 06                	je     80220f <insert_sorted_allocList+0x123>
  802209:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80220d:	75 14                	jne    802223 <insert_sorted_allocList+0x137>
  80220f:	83 ec 04             	sub    $0x4,%esp
  802212:	68 0c 3a 80 00       	push   $0x803a0c
  802217:	6a 75                	push   $0x75
  802219:	68 f3 39 80 00       	push   $0x8039f3
  80221e:	e8 38 e0 ff ff       	call   80025b <_panic>
  802223:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802226:	8b 50 04             	mov    0x4(%eax),%edx
  802229:	8b 45 08             	mov    0x8(%ebp),%eax
  80222c:	89 50 04             	mov    %edx,0x4(%eax)
  80222f:	8b 45 08             	mov    0x8(%ebp),%eax
  802232:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802235:	89 10                	mov    %edx,(%eax)
  802237:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223a:	8b 40 04             	mov    0x4(%eax),%eax
  80223d:	85 c0                	test   %eax,%eax
  80223f:	74 0d                	je     80224e <insert_sorted_allocList+0x162>
  802241:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802244:	8b 40 04             	mov    0x4(%eax),%eax
  802247:	8b 55 08             	mov    0x8(%ebp),%edx
  80224a:	89 10                	mov    %edx,(%eax)
  80224c:	eb 08                	jmp    802256 <insert_sorted_allocList+0x16a>
  80224e:	8b 45 08             	mov    0x8(%ebp),%eax
  802251:	a3 40 40 80 00       	mov    %eax,0x804040
  802256:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802259:	8b 55 08             	mov    0x8(%ebp),%edx
  80225c:	89 50 04             	mov    %edx,0x4(%eax)
  80225f:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802264:	40                   	inc    %eax
  802265:	a3 4c 40 80 00       	mov    %eax,0x80404c

		break;}
  80226a:	e9 59 01 00 00       	jmp    8023c8 <insert_sorted_allocList+0x2dc>

	else if ((blockToInsert->sva>element->sva)&&(blockToInsert->sva<AllocMemBlocksList.lh_last->sva)&&blockToInsert->sva<LIST_NEXT(element)->sva)
  80226f:	8b 45 08             	mov    0x8(%ebp),%eax
  802272:	8b 50 08             	mov    0x8(%eax),%edx
  802275:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802278:	8b 40 08             	mov    0x8(%eax),%eax
  80227b:	39 c2                	cmp    %eax,%edx
  80227d:	0f 86 98 00 00 00    	jbe    80231b <insert_sorted_allocList+0x22f>
  802283:	8b 45 08             	mov    0x8(%ebp),%eax
  802286:	8b 50 08             	mov    0x8(%eax),%edx
  802289:	a1 44 40 80 00       	mov    0x804044,%eax
  80228e:	8b 40 08             	mov    0x8(%eax),%eax
  802291:	39 c2                	cmp    %eax,%edx
  802293:	0f 83 82 00 00 00    	jae    80231b <insert_sorted_allocList+0x22f>
  802299:	8b 45 08             	mov    0x8(%ebp),%eax
  80229c:	8b 50 08             	mov    0x8(%eax),%edx
  80229f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a2:	8b 00                	mov    (%eax),%eax
  8022a4:	8b 40 08             	mov    0x8(%eax),%eax
  8022a7:	39 c2                	cmp    %eax,%edx
  8022a9:	73 70                	jae    80231b <insert_sorted_allocList+0x22f>
	{

	LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  8022ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022af:	74 06                	je     8022b7 <insert_sorted_allocList+0x1cb>
  8022b1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022b5:	75 14                	jne    8022cb <insert_sorted_allocList+0x1df>
  8022b7:	83 ec 04             	sub    $0x4,%esp
  8022ba:	68 44 3a 80 00       	push   $0x803a44
  8022bf:	6a 7c                	push   $0x7c
  8022c1:	68 f3 39 80 00       	push   $0x8039f3
  8022c6:	e8 90 df ff ff       	call   80025b <_panic>
  8022cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ce:	8b 10                	mov    (%eax),%edx
  8022d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d3:	89 10                	mov    %edx,(%eax)
  8022d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d8:	8b 00                	mov    (%eax),%eax
  8022da:	85 c0                	test   %eax,%eax
  8022dc:	74 0b                	je     8022e9 <insert_sorted_allocList+0x1fd>
  8022de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e1:	8b 00                	mov    (%eax),%eax
  8022e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8022e6:	89 50 04             	mov    %edx,0x4(%eax)
  8022e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8022ef:	89 10                	mov    %edx,(%eax)
  8022f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022f7:	89 50 04             	mov    %edx,0x4(%eax)
  8022fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fd:	8b 00                	mov    (%eax),%eax
  8022ff:	85 c0                	test   %eax,%eax
  802301:	75 08                	jne    80230b <insert_sorted_allocList+0x21f>
  802303:	8b 45 08             	mov    0x8(%ebp),%eax
  802306:	a3 44 40 80 00       	mov    %eax,0x804044
  80230b:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802310:	40                   	inc    %eax
  802311:	a3 4c 40 80 00       	mov    %eax,0x80404c
		break;
  802316:	e9 ad 00 00 00       	jmp    8023c8 <insert_sorted_allocList+0x2dc>
	}else if (blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  80231b:	8b 45 08             	mov    0x8(%ebp),%eax
  80231e:	8b 50 08             	mov    0x8(%eax),%edx
  802321:	a1 44 40 80 00       	mov    0x804044,%eax
  802326:	8b 40 08             	mov    0x8(%eax),%eax
  802329:	39 c2                	cmp    %eax,%edx
  80232b:	76 65                	jbe    802392 <insert_sorted_allocList+0x2a6>
	{
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
  80232d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802331:	75 17                	jne    80234a <insert_sorted_allocList+0x25e>
  802333:	83 ec 04             	sub    $0x4,%esp
  802336:	68 78 3a 80 00       	push   $0x803a78
  80233b:	68 80 00 00 00       	push   $0x80
  802340:	68 f3 39 80 00       	push   $0x8039f3
  802345:	e8 11 df ff ff       	call   80025b <_panic>
  80234a:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802350:	8b 45 08             	mov    0x8(%ebp),%eax
  802353:	89 50 04             	mov    %edx,0x4(%eax)
  802356:	8b 45 08             	mov    0x8(%ebp),%eax
  802359:	8b 40 04             	mov    0x4(%eax),%eax
  80235c:	85 c0                	test   %eax,%eax
  80235e:	74 0c                	je     80236c <insert_sorted_allocList+0x280>
  802360:	a1 44 40 80 00       	mov    0x804044,%eax
  802365:	8b 55 08             	mov    0x8(%ebp),%edx
  802368:	89 10                	mov    %edx,(%eax)
  80236a:	eb 08                	jmp    802374 <insert_sorted_allocList+0x288>
  80236c:	8b 45 08             	mov    0x8(%ebp),%eax
  80236f:	a3 40 40 80 00       	mov    %eax,0x804040
  802374:	8b 45 08             	mov    0x8(%ebp),%eax
  802377:	a3 44 40 80 00       	mov    %eax,0x804044
  80237c:	8b 45 08             	mov    0x8(%ebp),%eax
  80237f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802385:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80238a:	40                   	inc    %eax
  80238b:	a3 4c 40 80 00       	mov    %eax,0x80404c
		break;
  802390:	eb 36                	jmp    8023c8 <insert_sorted_allocList+0x2dc>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  802392:	a1 48 40 80 00       	mov    0x804048,%eax
  802397:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80239a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80239e:	74 07                	je     8023a7 <insert_sorted_allocList+0x2bb>
  8023a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a3:	8b 00                	mov    (%eax),%eax
  8023a5:	eb 05                	jmp    8023ac <insert_sorted_allocList+0x2c0>
  8023a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8023ac:	a3 48 40 80 00       	mov    %eax,0x804048
  8023b1:	a1 48 40 80 00       	mov    0x804048,%eax
  8023b6:	85 c0                	test   %eax,%eax
  8023b8:	0f 85 23 fe ff ff    	jne    8021e1 <insert_sorted_allocList+0xf5>
  8023be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023c2:	0f 85 19 fe ff ff    	jne    8021e1 <insert_sorted_allocList+0xf5>
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
		break;

	}
	}
}
  8023c8:	90                   	nop
  8023c9:	c9                   	leave  
  8023ca:	c3                   	ret    

008023cb <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8023cb:	55                   	push   %ebp
  8023cc:	89 e5                	mov    %esp,%ebp
  8023ce:	83 ec 18             	sub    $0x18,%esp
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  8023d1:	a1 38 41 80 00       	mov    0x804138,%eax
  8023d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023d9:	e9 7c 01 00 00       	jmp    80255a <alloc_block_FF+0x18f>
		{
			// case 2
				if(element->size == size)
  8023de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8023e4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023e7:	0f 85 90 00 00 00    	jne    80247d <alloc_block_FF+0xb2>
				{
					tmp_block=element;
  8023ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,element);
  8023f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023f7:	75 17                	jne    802410 <alloc_block_FF+0x45>
  8023f9:	83 ec 04             	sub    $0x4,%esp
  8023fc:	68 9b 3a 80 00       	push   $0x803a9b
  802401:	68 ba 00 00 00       	push   $0xba
  802406:	68 f3 39 80 00       	push   $0x8039f3
  80240b:	e8 4b de ff ff       	call   80025b <_panic>
  802410:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802413:	8b 00                	mov    (%eax),%eax
  802415:	85 c0                	test   %eax,%eax
  802417:	74 10                	je     802429 <alloc_block_FF+0x5e>
  802419:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241c:	8b 00                	mov    (%eax),%eax
  80241e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802421:	8b 52 04             	mov    0x4(%edx),%edx
  802424:	89 50 04             	mov    %edx,0x4(%eax)
  802427:	eb 0b                	jmp    802434 <alloc_block_FF+0x69>
  802429:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242c:	8b 40 04             	mov    0x4(%eax),%eax
  80242f:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802434:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802437:	8b 40 04             	mov    0x4(%eax),%eax
  80243a:	85 c0                	test   %eax,%eax
  80243c:	74 0f                	je     80244d <alloc_block_FF+0x82>
  80243e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802441:	8b 40 04             	mov    0x4(%eax),%eax
  802444:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802447:	8b 12                	mov    (%edx),%edx
  802449:	89 10                	mov    %edx,(%eax)
  80244b:	eb 0a                	jmp    802457 <alloc_block_FF+0x8c>
  80244d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802450:	8b 00                	mov    (%eax),%eax
  802452:	a3 38 41 80 00       	mov    %eax,0x804138
  802457:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802460:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802463:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80246a:	a1 44 41 80 00       	mov    0x804144,%eax
  80246f:	48                   	dec    %eax
  802470:	a3 44 41 80 00       	mov    %eax,0x804144
					return tmp_block;
  802475:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802478:	e9 10 01 00 00       	jmp    80258d <alloc_block_FF+0x1c2>
				}
				 // case 3
				else if(element->size > size)
  80247d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802480:	8b 40 0c             	mov    0xc(%eax),%eax
  802483:	3b 45 08             	cmp    0x8(%ebp),%eax
  802486:	0f 86 c6 00 00 00    	jbe    802552 <alloc_block_FF+0x187>
				{
					// the new block are created
					tmp_block = AvailableMemBlocksList.lh_first ;
  80248c:	a1 48 41 80 00       	mov    0x804148,%eax
  802491:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  802494:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802498:	75 17                	jne    8024b1 <alloc_block_FF+0xe6>
  80249a:	83 ec 04             	sub    $0x4,%esp
  80249d:	68 9b 3a 80 00       	push   $0x803a9b
  8024a2:	68 c2 00 00 00       	push   $0xc2
  8024a7:	68 f3 39 80 00       	push   $0x8039f3
  8024ac:	e8 aa dd ff ff       	call   80025b <_panic>
  8024b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024b4:	8b 00                	mov    (%eax),%eax
  8024b6:	85 c0                	test   %eax,%eax
  8024b8:	74 10                	je     8024ca <alloc_block_FF+0xff>
  8024ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024bd:	8b 00                	mov    (%eax),%eax
  8024bf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024c2:	8b 52 04             	mov    0x4(%edx),%edx
  8024c5:	89 50 04             	mov    %edx,0x4(%eax)
  8024c8:	eb 0b                	jmp    8024d5 <alloc_block_FF+0x10a>
  8024ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024cd:	8b 40 04             	mov    0x4(%eax),%eax
  8024d0:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8024d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024d8:	8b 40 04             	mov    0x4(%eax),%eax
  8024db:	85 c0                	test   %eax,%eax
  8024dd:	74 0f                	je     8024ee <alloc_block_FF+0x123>
  8024df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024e2:	8b 40 04             	mov    0x4(%eax),%eax
  8024e5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024e8:	8b 12                	mov    (%edx),%edx
  8024ea:	89 10                	mov    %edx,(%eax)
  8024ec:	eb 0a                	jmp    8024f8 <alloc_block_FF+0x12d>
  8024ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024f1:	8b 00                	mov    (%eax),%eax
  8024f3:	a3 48 41 80 00       	mov    %eax,0x804148
  8024f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024fb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802501:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802504:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80250b:	a1 54 41 80 00       	mov    0x804154,%eax
  802510:	48                   	dec    %eax
  802511:	a3 54 41 80 00       	mov    %eax,0x804154
					tmp_block->sva=element->sva;
  802516:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802519:	8b 50 08             	mov    0x8(%eax),%edx
  80251c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80251f:	89 50 08             	mov    %edx,0x8(%eax)
					tmp_block->size=size;
  802522:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802525:	8b 55 08             	mov    0x8(%ebp),%edx
  802528:	89 50 0c             	mov    %edx,0xc(%eax)
					//update block with remaining space
					element->size-=size;
  80252b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252e:	8b 40 0c             	mov    0xc(%eax),%eax
  802531:	2b 45 08             	sub    0x8(%ebp),%eax
  802534:	89 c2                	mov    %eax,%edx
  802536:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802539:	89 50 0c             	mov    %edx,0xc(%eax)
					element->sva = element->sva + size;
  80253c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253f:	8b 50 08             	mov    0x8(%eax),%edx
  802542:	8b 45 08             	mov    0x8(%ebp),%eax
  802545:	01 c2                	add    %eax,%edx
  802547:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254a:	89 50 08             	mov    %edx,0x8(%eax)
					// return back the new block
					return tmp_block ;
  80254d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802550:	eb 3b                	jmp    80258d <alloc_block_FF+0x1c2>
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802552:	a1 40 41 80 00       	mov    0x804140,%eax
  802557:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80255a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80255e:	74 07                	je     802567 <alloc_block_FF+0x19c>
  802560:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802563:	8b 00                	mov    (%eax),%eax
  802565:	eb 05                	jmp    80256c <alloc_block_FF+0x1a1>
  802567:	b8 00 00 00 00       	mov    $0x0,%eax
  80256c:	a3 40 41 80 00       	mov    %eax,0x804140
  802571:	a1 40 41 80 00       	mov    0x804140,%eax
  802576:	85 c0                	test   %eax,%eax
  802578:	0f 85 60 fe ff ff    	jne    8023de <alloc_block_FF+0x13>
  80257e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802582:	0f 85 56 fe ff ff    	jne    8023de <alloc_block_FF+0x13>
					// return back the new block
					return tmp_block ;
				}
		}
		// case 1
	  return NULL ;}
  802588:	b8 00 00 00 00       	mov    $0x0,%eax
  80258d:	c9                   	leave  
  80258e:	c3                   	ret    

0080258f <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================

struct MemBlock *alloc_block_BF(uint32 size)
{
  80258f:	55                   	push   %ebp
  802590:	89 e5                	mov    %esp,%ebp
  802592:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
  802595:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		LIST_FOREACH(element, &(FreeMemBlocksList))
  80259c:	a1 38 41 80 00       	mov    0x804138,%eax
  8025a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025a4:	eb 3a                	jmp    8025e0 <alloc_block_BF+0x51>
		{
			if(element->size >= size)
  8025a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8025ac:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025af:	72 27                	jb     8025d8 <alloc_block_BF+0x49>
			{
				if(best_size==-1)
  8025b1:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8025b5:	75 0b                	jne    8025c2 <alloc_block_BF+0x33>
					best_size= element->size;
  8025b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8025bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8025c0:	eb 16                	jmp    8025d8 <alloc_block_BF+0x49>
				else if(best_size >= element->size)
  8025c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c5:	8b 50 0c             	mov    0xc(%eax),%edx
  8025c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025cb:	39 c2                	cmp    %eax,%edx
  8025cd:	77 09                	ja     8025d8 <alloc_block_BF+0x49>
					best_size=element->size;
  8025cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8025d5:	89 45 f0             	mov    %eax,-0x10(%ebp)

struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  8025d8:	a1 40 41 80 00       	mov    0x804140,%eax
  8025dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025e4:	74 07                	je     8025ed <alloc_block_BF+0x5e>
  8025e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e9:	8b 00                	mov    (%eax),%eax
  8025eb:	eb 05                	jmp    8025f2 <alloc_block_BF+0x63>
  8025ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8025f2:	a3 40 41 80 00       	mov    %eax,0x804140
  8025f7:	a1 40 41 80 00       	mov    0x804140,%eax
  8025fc:	85 c0                	test   %eax,%eax
  8025fe:	75 a6                	jne    8025a6 <alloc_block_BF+0x17>
  802600:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802604:	75 a0                	jne    8025a6 <alloc_block_BF+0x17>
					best_size= element->size;
				else if(best_size >= element->size)
					best_size=element->size;
			}
		}
		if(best_size != -1)
  802606:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80260a:	0f 84 d3 01 00 00    	je     8027e3 <alloc_block_BF+0x254>
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  802610:	a1 38 41 80 00       	mov    0x804138,%eax
  802615:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802618:	e9 98 01 00 00       	jmp    8027b5 <alloc_block_BF+0x226>
			{
			 if((best_size > size) && (best_size == element->size))
  80261d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802620:	3b 45 08             	cmp    0x8(%ebp),%eax
  802623:	0f 86 da 00 00 00    	jbe    802703 <alloc_block_BF+0x174>
  802629:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262c:	8b 50 0c             	mov    0xc(%eax),%edx
  80262f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802632:	39 c2                	cmp    %eax,%edx
  802634:	0f 85 c9 00 00 00    	jne    802703 <alloc_block_BF+0x174>
			  {
				// the new block are created
			    tmp_block = AvailableMemBlocksList.lh_first ;
  80263a:	a1 48 41 80 00       	mov    0x804148,%eax
  80263f:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  802642:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802646:	75 17                	jne    80265f <alloc_block_BF+0xd0>
  802648:	83 ec 04             	sub    $0x4,%esp
  80264b:	68 9b 3a 80 00       	push   $0x803a9b
  802650:	68 ea 00 00 00       	push   $0xea
  802655:	68 f3 39 80 00       	push   $0x8039f3
  80265a:	e8 fc db ff ff       	call   80025b <_panic>
  80265f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802662:	8b 00                	mov    (%eax),%eax
  802664:	85 c0                	test   %eax,%eax
  802666:	74 10                	je     802678 <alloc_block_BF+0xe9>
  802668:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80266b:	8b 00                	mov    (%eax),%eax
  80266d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802670:	8b 52 04             	mov    0x4(%edx),%edx
  802673:	89 50 04             	mov    %edx,0x4(%eax)
  802676:	eb 0b                	jmp    802683 <alloc_block_BF+0xf4>
  802678:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80267b:	8b 40 04             	mov    0x4(%eax),%eax
  80267e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802683:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802686:	8b 40 04             	mov    0x4(%eax),%eax
  802689:	85 c0                	test   %eax,%eax
  80268b:	74 0f                	je     80269c <alloc_block_BF+0x10d>
  80268d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802690:	8b 40 04             	mov    0x4(%eax),%eax
  802693:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802696:	8b 12                	mov    (%edx),%edx
  802698:	89 10                	mov    %edx,(%eax)
  80269a:	eb 0a                	jmp    8026a6 <alloc_block_BF+0x117>
  80269c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80269f:	8b 00                	mov    (%eax),%eax
  8026a1:	a3 48 41 80 00       	mov    %eax,0x804148
  8026a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026b2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026b9:	a1 54 41 80 00       	mov    0x804154,%eax
  8026be:	48                   	dec    %eax
  8026bf:	a3 54 41 80 00       	mov    %eax,0x804154
				tmp_block->sva=element->sva;
  8026c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c7:	8b 50 08             	mov    0x8(%eax),%edx
  8026ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026cd:	89 50 08             	mov    %edx,0x8(%eax)
				tmp_block->size=size;
  8026d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8026d6:	89 50 0c             	mov    %edx,0xc(%eax)
				//update block with remaining space
				element->size-=size;
  8026d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8026df:	2b 45 08             	sub    0x8(%ebp),%eax
  8026e2:	89 c2                	mov    %eax,%edx
  8026e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e7:	89 50 0c             	mov    %edx,0xc(%eax)
				element->sva = element->sva + size;
  8026ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ed:	8b 50 08             	mov    0x8(%eax),%edx
  8026f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f3:	01 c2                	add    %eax,%edx
  8026f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f8:	89 50 08             	mov    %edx,0x8(%eax)
				// return back the new block
				return tmp_block ;
  8026fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026fe:	e9 e5 00 00 00       	jmp    8027e8 <alloc_block_BF+0x259>

			  }
			else if((element->size == best_size)&&(best_size == size))
  802703:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802706:	8b 50 0c             	mov    0xc(%eax),%edx
  802709:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80270c:	39 c2                	cmp    %eax,%edx
  80270e:	0f 85 99 00 00 00    	jne    8027ad <alloc_block_BF+0x21e>
  802714:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802717:	3b 45 08             	cmp    0x8(%ebp),%eax
  80271a:	0f 85 8d 00 00 00    	jne    8027ad <alloc_block_BF+0x21e>
			  {
				tmp_block=element;
  802720:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802723:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&FreeMemBlocksList,element);
  802726:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80272a:	75 17                	jne    802743 <alloc_block_BF+0x1b4>
  80272c:	83 ec 04             	sub    $0x4,%esp
  80272f:	68 9b 3a 80 00       	push   $0x803a9b
  802734:	68 f7 00 00 00       	push   $0xf7
  802739:	68 f3 39 80 00       	push   $0x8039f3
  80273e:	e8 18 db ff ff       	call   80025b <_panic>
  802743:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802746:	8b 00                	mov    (%eax),%eax
  802748:	85 c0                	test   %eax,%eax
  80274a:	74 10                	je     80275c <alloc_block_BF+0x1cd>
  80274c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274f:	8b 00                	mov    (%eax),%eax
  802751:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802754:	8b 52 04             	mov    0x4(%edx),%edx
  802757:	89 50 04             	mov    %edx,0x4(%eax)
  80275a:	eb 0b                	jmp    802767 <alloc_block_BF+0x1d8>
  80275c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275f:	8b 40 04             	mov    0x4(%eax),%eax
  802762:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802767:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276a:	8b 40 04             	mov    0x4(%eax),%eax
  80276d:	85 c0                	test   %eax,%eax
  80276f:	74 0f                	je     802780 <alloc_block_BF+0x1f1>
  802771:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802774:	8b 40 04             	mov    0x4(%eax),%eax
  802777:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80277a:	8b 12                	mov    (%edx),%edx
  80277c:	89 10                	mov    %edx,(%eax)
  80277e:	eb 0a                	jmp    80278a <alloc_block_BF+0x1fb>
  802780:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802783:	8b 00                	mov    (%eax),%eax
  802785:	a3 38 41 80 00       	mov    %eax,0x804138
  80278a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802793:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802796:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80279d:	a1 44 41 80 00       	mov    0x804144,%eax
  8027a2:	48                   	dec    %eax
  8027a3:	a3 44 41 80 00       	mov    %eax,0x804144
				return tmp_block;
  8027a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027ab:	eb 3b                	jmp    8027e8 <alloc_block_BF+0x259>
					best_size=element->size;
			}
		}
		if(best_size != -1)
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  8027ad:	a1 40 41 80 00       	mov    0x804140,%eax
  8027b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027b9:	74 07                	je     8027c2 <alloc_block_BF+0x233>
  8027bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027be:	8b 00                	mov    (%eax),%eax
  8027c0:	eb 05                	jmp    8027c7 <alloc_block_BF+0x238>
  8027c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8027c7:	a3 40 41 80 00       	mov    %eax,0x804140
  8027cc:	a1 40 41 80 00       	mov    0x804140,%eax
  8027d1:	85 c0                	test   %eax,%eax
  8027d3:	0f 85 44 fe ff ff    	jne    80261d <alloc_block_BF+0x8e>
  8027d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027dd:	0f 85 3a fe ff ff    	jne    80261d <alloc_block_BF+0x8e>
				LIST_REMOVE(&FreeMemBlocksList,element);
				return tmp_block;
			 }
			}
		}
		return NULL ;}
  8027e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8027e8:	c9                   	leave  
  8027e9:	c3                   	ret    

008027ea <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8027ea:	55                   	push   %ebp
  8027eb:	89 e5                	mov    %esp,%ebp
  8027ed:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  8027f0:	83 ec 04             	sub    $0x4,%esp
  8027f3:	68 bc 3a 80 00       	push   $0x803abc
  8027f8:	68 04 01 00 00       	push   $0x104
  8027fd:	68 f3 39 80 00       	push   $0x8039f3
  802802:	e8 54 da ff ff       	call   80025b <_panic>

00802807 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{struct MemBlock * blk_itr;
  802807:	55                   	push   %ebp
  802808:	89 e5                	mov    %esp,%ebp
  80280a:	83 ec 18             	sub    $0x18,%esp
struct MemBlock * next;
struct MemBlock * first = LIST_FIRST(&(FreeMemBlocksList));
  80280d:	a1 38 41 80 00       	mov    0x804138,%eax
  802812:	89 45 f0             	mov    %eax,-0x10(%ebp)
struct MemBlock * last = LIST_LAST(&(FreeMemBlocksList));
  802815:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80281a:	89 45 ec             	mov    %eax,-0x14(%ebp)

if(LIST_EMPTY(&(FreeMemBlocksList)))
  80281d:	a1 38 41 80 00       	mov    0x804138,%eax
  802822:	85 c0                	test   %eax,%eax
  802824:	75 68                	jne    80288e <insert_sorted_with_merge_freeList+0x87>
			{

				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  802826:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80282a:	75 17                	jne    802843 <insert_sorted_with_merge_freeList+0x3c>
  80282c:	83 ec 04             	sub    $0x4,%esp
  80282f:	68 d0 39 80 00       	push   $0x8039d0
  802834:	68 14 01 00 00       	push   $0x114
  802839:	68 f3 39 80 00       	push   $0x8039f3
  80283e:	e8 18 da ff ff       	call   80025b <_panic>
  802843:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802849:	8b 45 08             	mov    0x8(%ebp),%eax
  80284c:	89 10                	mov    %edx,(%eax)
  80284e:	8b 45 08             	mov    0x8(%ebp),%eax
  802851:	8b 00                	mov    (%eax),%eax
  802853:	85 c0                	test   %eax,%eax
  802855:	74 0d                	je     802864 <insert_sorted_with_merge_freeList+0x5d>
  802857:	a1 38 41 80 00       	mov    0x804138,%eax
  80285c:	8b 55 08             	mov    0x8(%ebp),%edx
  80285f:	89 50 04             	mov    %edx,0x4(%eax)
  802862:	eb 08                	jmp    80286c <insert_sorted_with_merge_freeList+0x65>
  802864:	8b 45 08             	mov    0x8(%ebp),%eax
  802867:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80286c:	8b 45 08             	mov    0x8(%ebp),%eax
  80286f:	a3 38 41 80 00       	mov    %eax,0x804138
  802874:	8b 45 08             	mov    0x8(%ebp),%eax
  802877:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80287e:	a1 44 41 80 00       	mov    0x804144,%eax
  802883:	40                   	inc    %eax
  802884:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  802889:	e9 d2 06 00 00       	jmp    802f60 <insert_sorted_with_merge_freeList+0x759>
				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);

			}
else
{
	if( blockToInsert->sva  < first->sva )
  80288e:	8b 45 08             	mov    0x8(%ebp),%eax
  802891:	8b 50 08             	mov    0x8(%eax),%edx
  802894:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802897:	8b 40 08             	mov    0x8(%eax),%eax
  80289a:	39 c2                	cmp    %eax,%edx
  80289c:	0f 83 22 01 00 00    	jae    8029c4 <insert_sorted_with_merge_freeList+0x1bd>
	{
                if( blockToInsert->sva + blockToInsert->size == first->sva)
  8028a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a5:	8b 50 08             	mov    0x8(%eax),%edx
  8028a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ab:	8b 40 0c             	mov    0xc(%eax),%eax
  8028ae:	01 c2                	add    %eax,%edx
  8028b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b3:	8b 40 08             	mov    0x8(%eax),%eax
  8028b6:	39 c2                	cmp    %eax,%edx
  8028b8:	0f 85 9e 00 00 00    	jne    80295c <insert_sorted_with_merge_freeList+0x155>
                {

                	first->sva = blockToInsert->sva;
  8028be:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c1:	8b 50 08             	mov    0x8(%eax),%edx
  8028c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c7:	89 50 08             	mov    %edx,0x8(%eax)
                	first->size = first->size + blockToInsert->size;
  8028ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028cd:	8b 50 0c             	mov    0xc(%eax),%edx
  8028d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8028d6:	01 c2                	add    %eax,%edx
  8028d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028db:	89 50 0c             	mov    %edx,0xc(%eax)
                	blockToInsert->size = blockToInsert->sva = 0;
  8028de:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8028e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8028eb:	8b 50 08             	mov    0x8(%eax),%edx
  8028ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f1:	89 50 0c             	mov    %edx,0xc(%eax)
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  8028f4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028f8:	75 17                	jne    802911 <insert_sorted_with_merge_freeList+0x10a>
  8028fa:	83 ec 04             	sub    $0x4,%esp
  8028fd:	68 d0 39 80 00       	push   $0x8039d0
  802902:	68 21 01 00 00       	push   $0x121
  802907:	68 f3 39 80 00       	push   $0x8039f3
  80290c:	e8 4a d9 ff ff       	call   80025b <_panic>
  802911:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802917:	8b 45 08             	mov    0x8(%ebp),%eax
  80291a:	89 10                	mov    %edx,(%eax)
  80291c:	8b 45 08             	mov    0x8(%ebp),%eax
  80291f:	8b 00                	mov    (%eax),%eax
  802921:	85 c0                	test   %eax,%eax
  802923:	74 0d                	je     802932 <insert_sorted_with_merge_freeList+0x12b>
  802925:	a1 48 41 80 00       	mov    0x804148,%eax
  80292a:	8b 55 08             	mov    0x8(%ebp),%edx
  80292d:	89 50 04             	mov    %edx,0x4(%eax)
  802930:	eb 08                	jmp    80293a <insert_sorted_with_merge_freeList+0x133>
  802932:	8b 45 08             	mov    0x8(%ebp),%eax
  802935:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80293a:	8b 45 08             	mov    0x8(%ebp),%eax
  80293d:	a3 48 41 80 00       	mov    %eax,0x804148
  802942:	8b 45 08             	mov    0x8(%ebp),%eax
  802945:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80294c:	a1 54 41 80 00       	mov    0x804154,%eax
  802951:	40                   	inc    %eax
  802952:	a3 54 41 80 00       	mov    %eax,0x804154
						}
				}
        }

}
}
  802957:	e9 04 06 00 00       	jmp    802f60 <insert_sorted_with_merge_freeList+0x759>
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
                }

                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  80295c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802960:	75 17                	jne    802979 <insert_sorted_with_merge_freeList+0x172>
  802962:	83 ec 04             	sub    $0x4,%esp
  802965:	68 d0 39 80 00       	push   $0x8039d0
  80296a:	68 26 01 00 00       	push   $0x126
  80296f:	68 f3 39 80 00       	push   $0x8039f3
  802974:	e8 e2 d8 ff ff       	call   80025b <_panic>
  802979:	8b 15 38 41 80 00    	mov    0x804138,%edx
  80297f:	8b 45 08             	mov    0x8(%ebp),%eax
  802982:	89 10                	mov    %edx,(%eax)
  802984:	8b 45 08             	mov    0x8(%ebp),%eax
  802987:	8b 00                	mov    (%eax),%eax
  802989:	85 c0                	test   %eax,%eax
  80298b:	74 0d                	je     80299a <insert_sorted_with_merge_freeList+0x193>
  80298d:	a1 38 41 80 00       	mov    0x804138,%eax
  802992:	8b 55 08             	mov    0x8(%ebp),%edx
  802995:	89 50 04             	mov    %edx,0x4(%eax)
  802998:	eb 08                	jmp    8029a2 <insert_sorted_with_merge_freeList+0x19b>
  80299a:	8b 45 08             	mov    0x8(%ebp),%eax
  80299d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a5:	a3 38 41 80 00       	mov    %eax,0x804138
  8029aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029b4:	a1 44 41 80 00       	mov    0x804144,%eax
  8029b9:	40                   	inc    %eax
  8029ba:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  8029bf:	e9 9c 05 00 00       	jmp    802f60 <insert_sorted_with_merge_freeList+0x759>
                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
                }
	}
    else if(blockToInsert->sva > last->sva)
  8029c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c7:	8b 50 08             	mov    0x8(%eax),%edx
  8029ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029cd:	8b 40 08             	mov    0x8(%eax),%eax
  8029d0:	39 c2                	cmp    %eax,%edx
  8029d2:	0f 86 16 01 00 00    	jbe    802aee <insert_sorted_with_merge_freeList+0x2e7>
 	{

				if(last->sva + last->size == blockToInsert->sva)
  8029d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029db:	8b 50 08             	mov    0x8(%eax),%edx
  8029de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8029e4:	01 c2                	add    %eax,%edx
  8029e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e9:	8b 40 08             	mov    0x8(%eax),%eax
  8029ec:	39 c2                	cmp    %eax,%edx
  8029ee:	0f 85 92 00 00 00    	jne    802a86 <insert_sorted_with_merge_freeList+0x27f>
				{

					last->size = last->size + blockToInsert->size;
  8029f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029f7:	8b 50 0c             	mov    0xc(%eax),%edx
  8029fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8029fd:	8b 40 0c             	mov    0xc(%eax),%eax
  802a00:	01 c2                	add    %eax,%edx
  802a02:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a05:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->size = blockToInsert->sva = 0;
  802a08:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802a12:	8b 45 08             	mov    0x8(%ebp),%eax
  802a15:	8b 50 08             	mov    0x8(%eax),%edx
  802a18:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1b:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802a1e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a22:	75 17                	jne    802a3b <insert_sorted_with_merge_freeList+0x234>
  802a24:	83 ec 04             	sub    $0x4,%esp
  802a27:	68 d0 39 80 00       	push   $0x8039d0
  802a2c:	68 31 01 00 00       	push   $0x131
  802a31:	68 f3 39 80 00       	push   $0x8039f3
  802a36:	e8 20 d8 ff ff       	call   80025b <_panic>
  802a3b:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802a41:	8b 45 08             	mov    0x8(%ebp),%eax
  802a44:	89 10                	mov    %edx,(%eax)
  802a46:	8b 45 08             	mov    0x8(%ebp),%eax
  802a49:	8b 00                	mov    (%eax),%eax
  802a4b:	85 c0                	test   %eax,%eax
  802a4d:	74 0d                	je     802a5c <insert_sorted_with_merge_freeList+0x255>
  802a4f:	a1 48 41 80 00       	mov    0x804148,%eax
  802a54:	8b 55 08             	mov    0x8(%ebp),%edx
  802a57:	89 50 04             	mov    %edx,0x4(%eax)
  802a5a:	eb 08                	jmp    802a64 <insert_sorted_with_merge_freeList+0x25d>
  802a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a64:	8b 45 08             	mov    0x8(%ebp),%eax
  802a67:	a3 48 41 80 00       	mov    %eax,0x804148
  802a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a76:	a1 54 41 80 00       	mov    0x804154,%eax
  802a7b:	40                   	inc    %eax
  802a7c:	a3 54 41 80 00       	mov    %eax,0x804154
						}
				}
        }

}
}
  802a81:	e9 da 04 00 00       	jmp    802f60 <insert_sorted_with_merge_freeList+0x759>

				}

				else
				{
					LIST_INSERT_TAIL(&(FreeMemBlocksList),  blockToInsert);
  802a86:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a8a:	75 17                	jne    802aa3 <insert_sorted_with_merge_freeList+0x29c>
  802a8c:	83 ec 04             	sub    $0x4,%esp
  802a8f:	68 78 3a 80 00       	push   $0x803a78
  802a94:	68 37 01 00 00       	push   $0x137
  802a99:	68 f3 39 80 00       	push   $0x8039f3
  802a9e:	e8 b8 d7 ff ff       	call   80025b <_panic>
  802aa3:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  802aac:	89 50 04             	mov    %edx,0x4(%eax)
  802aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab2:	8b 40 04             	mov    0x4(%eax),%eax
  802ab5:	85 c0                	test   %eax,%eax
  802ab7:	74 0c                	je     802ac5 <insert_sorted_with_merge_freeList+0x2be>
  802ab9:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802abe:	8b 55 08             	mov    0x8(%ebp),%edx
  802ac1:	89 10                	mov    %edx,(%eax)
  802ac3:	eb 08                	jmp    802acd <insert_sorted_with_merge_freeList+0x2c6>
  802ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac8:	a3 38 41 80 00       	mov    %eax,0x804138
  802acd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad0:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ade:	a1 44 41 80 00       	mov    0x804144,%eax
  802ae3:	40                   	inc    %eax
  802ae4:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  802ae9:	e9 72 04 00 00       	jmp    802f60 <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  802aee:	a1 38 41 80 00       	mov    0x804138,%eax
  802af3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802af6:	e9 35 04 00 00       	jmp    802f30 <insert_sorted_with_merge_freeList+0x729>
				{
				     next=LIST_NEXT(blk_itr);
  802afb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afe:	8b 00                	mov    (%eax),%eax
  802b00:	89 45 e8             	mov    %eax,-0x18(%ebp)


					if( (blockToInsert->sva > blk_itr->sva) )
  802b03:	8b 45 08             	mov    0x8(%ebp),%eax
  802b06:	8b 50 08             	mov    0x8(%eax),%edx
  802b09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0c:	8b 40 08             	mov    0x8(%eax),%eax
  802b0f:	39 c2                	cmp    %eax,%edx
  802b11:	0f 86 11 04 00 00    	jbe    802f28 <insert_sorted_with_merge_freeList+0x721>
						{
							if(((blk_itr->sva) + (blk_itr->size) < blockToInsert->sva && (blockToInsert->sva) + (blockToInsert->size) < next->sva))
  802b17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1a:	8b 50 08             	mov    0x8(%eax),%edx
  802b1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b20:	8b 40 0c             	mov    0xc(%eax),%eax
  802b23:	01 c2                	add    %eax,%edx
  802b25:	8b 45 08             	mov    0x8(%ebp),%eax
  802b28:	8b 40 08             	mov    0x8(%eax),%eax
  802b2b:	39 c2                	cmp    %eax,%edx
  802b2d:	0f 83 8b 00 00 00    	jae    802bbe <insert_sorted_with_merge_freeList+0x3b7>
  802b33:	8b 45 08             	mov    0x8(%ebp),%eax
  802b36:	8b 50 08             	mov    0x8(%eax),%edx
  802b39:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3c:	8b 40 0c             	mov    0xc(%eax),%eax
  802b3f:	01 c2                	add    %eax,%edx
  802b41:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b44:	8b 40 08             	mov    0x8(%eax),%eax
  802b47:	39 c2                	cmp    %eax,%edx
  802b49:	73 73                	jae    802bbe <insert_sorted_with_merge_freeList+0x3b7>
							{
								LIST_INSERT_AFTER(&(FreeMemBlocksList), blk_itr, blockToInsert);
  802b4b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b4f:	74 06                	je     802b57 <insert_sorted_with_merge_freeList+0x350>
  802b51:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b55:	75 17                	jne    802b6e <insert_sorted_with_merge_freeList+0x367>
  802b57:	83 ec 04             	sub    $0x4,%esp
  802b5a:	68 44 3a 80 00       	push   $0x803a44
  802b5f:	68 48 01 00 00       	push   $0x148
  802b64:	68 f3 39 80 00       	push   $0x8039f3
  802b69:	e8 ed d6 ff ff       	call   80025b <_panic>
  802b6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b71:	8b 10                	mov    (%eax),%edx
  802b73:	8b 45 08             	mov    0x8(%ebp),%eax
  802b76:	89 10                	mov    %edx,(%eax)
  802b78:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7b:	8b 00                	mov    (%eax),%eax
  802b7d:	85 c0                	test   %eax,%eax
  802b7f:	74 0b                	je     802b8c <insert_sorted_with_merge_freeList+0x385>
  802b81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b84:	8b 00                	mov    (%eax),%eax
  802b86:	8b 55 08             	mov    0x8(%ebp),%edx
  802b89:	89 50 04             	mov    %edx,0x4(%eax)
  802b8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8f:	8b 55 08             	mov    0x8(%ebp),%edx
  802b92:	89 10                	mov    %edx,(%eax)
  802b94:	8b 45 08             	mov    0x8(%ebp),%eax
  802b97:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b9a:	89 50 04             	mov    %edx,0x4(%eax)
  802b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba0:	8b 00                	mov    (%eax),%eax
  802ba2:	85 c0                	test   %eax,%eax
  802ba4:	75 08                	jne    802bae <insert_sorted_with_merge_freeList+0x3a7>
  802ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba9:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802bae:	a1 44 41 80 00       	mov    0x804144,%eax
  802bb3:	40                   	inc    %eax
  802bb4:	a3 44 41 80 00       	mov    %eax,0x804144
								break;
  802bb9:	e9 a2 03 00 00       	jmp    802f60 <insert_sorted_with_merge_freeList+0x759>

							}
							else if((blockToInsert->sva + blockToInsert->size) < next->sva  && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  802bbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc1:	8b 50 08             	mov    0x8(%eax),%edx
  802bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc7:	8b 40 0c             	mov    0xc(%eax),%eax
  802bca:	01 c2                	add    %eax,%edx
  802bcc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bcf:	8b 40 08             	mov    0x8(%eax),%eax
  802bd2:	39 c2                	cmp    %eax,%edx
  802bd4:	0f 83 ae 00 00 00    	jae    802c88 <insert_sorted_with_merge_freeList+0x481>
  802bda:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdd:	8b 50 08             	mov    0x8(%eax),%edx
  802be0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be3:	8b 48 08             	mov    0x8(%eax),%ecx
  802be6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be9:	8b 40 0c             	mov    0xc(%eax),%eax
  802bec:	01 c8                	add    %ecx,%eax
  802bee:	39 c2                	cmp    %eax,%edx
  802bf0:	0f 85 92 00 00 00    	jne    802c88 <insert_sorted_with_merge_freeList+0x481>
							{

								blk_itr->size=blk_itr->size+blockToInsert->size;
  802bf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf9:	8b 50 0c             	mov    0xc(%eax),%edx
  802bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  802bff:	8b 40 0c             	mov    0xc(%eax),%eax
  802c02:	01 c2                	add    %eax,%edx
  802c04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c07:	89 50 0c             	mov    %edx,0xc(%eax)
								 blockToInsert->size=blockToInsert->sva=0;
  802c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802c14:	8b 45 08             	mov    0x8(%ebp),%eax
  802c17:	8b 50 08             	mov    0x8(%eax),%edx
  802c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1d:	89 50 0c             	mov    %edx,0xc(%eax)
								 LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802c20:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c24:	75 17                	jne    802c3d <insert_sorted_with_merge_freeList+0x436>
  802c26:	83 ec 04             	sub    $0x4,%esp
  802c29:	68 d0 39 80 00       	push   $0x8039d0
  802c2e:	68 51 01 00 00       	push   $0x151
  802c33:	68 f3 39 80 00       	push   $0x8039f3
  802c38:	e8 1e d6 ff ff       	call   80025b <_panic>
  802c3d:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c43:	8b 45 08             	mov    0x8(%ebp),%eax
  802c46:	89 10                	mov    %edx,(%eax)
  802c48:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4b:	8b 00                	mov    (%eax),%eax
  802c4d:	85 c0                	test   %eax,%eax
  802c4f:	74 0d                	je     802c5e <insert_sorted_with_merge_freeList+0x457>
  802c51:	a1 48 41 80 00       	mov    0x804148,%eax
  802c56:	8b 55 08             	mov    0x8(%ebp),%edx
  802c59:	89 50 04             	mov    %edx,0x4(%eax)
  802c5c:	eb 08                	jmp    802c66 <insert_sorted_with_merge_freeList+0x45f>
  802c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c61:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c66:	8b 45 08             	mov    0x8(%ebp),%eax
  802c69:	a3 48 41 80 00       	mov    %eax,0x804148
  802c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c71:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c78:	a1 54 41 80 00       	mov    0x804154,%eax
  802c7d:	40                   	inc    %eax
  802c7e:	a3 54 41 80 00       	mov    %eax,0x804154
								 break;
  802c83:	e9 d8 02 00 00       	jmp    802f60 <insert_sorted_with_merge_freeList+0x759>

							}
							else if( (blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva > (blk_itr->sva + blk_itr->size))
  802c88:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8b:	8b 50 08             	mov    0x8(%eax),%edx
  802c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c91:	8b 40 0c             	mov    0xc(%eax),%eax
  802c94:	01 c2                	add    %eax,%edx
  802c96:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c99:	8b 40 08             	mov    0x8(%eax),%eax
  802c9c:	39 c2                	cmp    %eax,%edx
  802c9e:	0f 85 ba 00 00 00    	jne    802d5e <insert_sorted_with_merge_freeList+0x557>
  802ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca7:	8b 50 08             	mov    0x8(%eax),%edx
  802caa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cad:	8b 48 08             	mov    0x8(%eax),%ecx
  802cb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb3:	8b 40 0c             	mov    0xc(%eax),%eax
  802cb6:	01 c8                	add    %ecx,%eax
  802cb8:	39 c2                	cmp    %eax,%edx
  802cba:	0f 86 9e 00 00 00    	jbe    802d5e <insert_sorted_with_merge_freeList+0x557>
							{
								next->size = next->size + blockToInsert->size;
  802cc0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cc3:	8b 50 0c             	mov    0xc(%eax),%edx
  802cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc9:	8b 40 0c             	mov    0xc(%eax),%eax
  802ccc:	01 c2                	add    %eax,%edx
  802cce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cd1:	89 50 0c             	mov    %edx,0xc(%eax)
								next->sva = blockToInsert->sva;
  802cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd7:	8b 50 08             	mov    0x8(%eax),%edx
  802cda:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cdd:	89 50 08             	mov    %edx,0x8(%eax)

								blockToInsert->size = blockToInsert->sva = 0;
  802ce0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802cea:	8b 45 08             	mov    0x8(%ebp),%eax
  802ced:	8b 50 08             	mov    0x8(%eax),%edx
  802cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf3:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802cf6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cfa:	75 17                	jne    802d13 <insert_sorted_with_merge_freeList+0x50c>
  802cfc:	83 ec 04             	sub    $0x4,%esp
  802cff:	68 d0 39 80 00       	push   $0x8039d0
  802d04:	68 5b 01 00 00       	push   $0x15b
  802d09:	68 f3 39 80 00       	push   $0x8039f3
  802d0e:	e8 48 d5 ff ff       	call   80025b <_panic>
  802d13:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d19:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1c:	89 10                	mov    %edx,(%eax)
  802d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d21:	8b 00                	mov    (%eax),%eax
  802d23:	85 c0                	test   %eax,%eax
  802d25:	74 0d                	je     802d34 <insert_sorted_with_merge_freeList+0x52d>
  802d27:	a1 48 41 80 00       	mov    0x804148,%eax
  802d2c:	8b 55 08             	mov    0x8(%ebp),%edx
  802d2f:	89 50 04             	mov    %edx,0x4(%eax)
  802d32:	eb 08                	jmp    802d3c <insert_sorted_with_merge_freeList+0x535>
  802d34:	8b 45 08             	mov    0x8(%ebp),%eax
  802d37:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3f:	a3 48 41 80 00       	mov    %eax,0x804148
  802d44:	8b 45 08             	mov    0x8(%ebp),%eax
  802d47:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d4e:	a1 54 41 80 00       	mov    0x804154,%eax
  802d53:	40                   	inc    %eax
  802d54:	a3 54 41 80 00       	mov    %eax,0x804154
								break;
  802d59:	e9 02 02 00 00       	jmp    802f60 <insert_sorted_with_merge_freeList+0x759>
							}
							else if ((blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  802d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d61:	8b 50 08             	mov    0x8(%eax),%edx
  802d64:	8b 45 08             	mov    0x8(%ebp),%eax
  802d67:	8b 40 0c             	mov    0xc(%eax),%eax
  802d6a:	01 c2                	add    %eax,%edx
  802d6c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d6f:	8b 40 08             	mov    0x8(%eax),%eax
  802d72:	39 c2                	cmp    %eax,%edx
  802d74:	0f 85 ae 01 00 00    	jne    802f28 <insert_sorted_with_merge_freeList+0x721>
  802d7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7d:	8b 50 08             	mov    0x8(%eax),%edx
  802d80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d83:	8b 48 08             	mov    0x8(%eax),%ecx
  802d86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d89:	8b 40 0c             	mov    0xc(%eax),%eax
  802d8c:	01 c8                	add    %ecx,%eax
  802d8e:	39 c2                	cmp    %eax,%edx
  802d90:	0f 85 92 01 00 00    	jne    802f28 <insert_sorted_with_merge_freeList+0x721>
							{
								blk_itr->size = blk_itr->size + blockToInsert->size + next->size;
  802d96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d99:	8b 50 0c             	mov    0xc(%eax),%edx
  802d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9f:	8b 40 0c             	mov    0xc(%eax),%eax
  802da2:	01 c2                	add    %eax,%edx
  802da4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802da7:	8b 40 0c             	mov    0xc(%eax),%eax
  802daa:	01 c2                	add    %eax,%edx
  802dac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802daf:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size = blockToInsert->sva=0;
  802db2:	8b 45 08             	mov    0x8(%ebp),%eax
  802db5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbf:	8b 50 08             	mov    0x8(%eax),%edx
  802dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc5:	89 50 0c             	mov    %edx,0xc(%eax)
								next->size = next->sva = 0;
  802dc8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dcb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802dd2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dd5:	8b 50 08             	mov    0x8(%eax),%edx
  802dd8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ddb:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_REMOVE(&FreeMemBlocksList, next);
  802dde:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802de2:	75 17                	jne    802dfb <insert_sorted_with_merge_freeList+0x5f4>
  802de4:	83 ec 04             	sub    $0x4,%esp
  802de7:	68 9b 3a 80 00       	push   $0x803a9b
  802dec:	68 63 01 00 00       	push   $0x163
  802df1:	68 f3 39 80 00       	push   $0x8039f3
  802df6:	e8 60 d4 ff ff       	call   80025b <_panic>
  802dfb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dfe:	8b 00                	mov    (%eax),%eax
  802e00:	85 c0                	test   %eax,%eax
  802e02:	74 10                	je     802e14 <insert_sorted_with_merge_freeList+0x60d>
  802e04:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e07:	8b 00                	mov    (%eax),%eax
  802e09:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e0c:	8b 52 04             	mov    0x4(%edx),%edx
  802e0f:	89 50 04             	mov    %edx,0x4(%eax)
  802e12:	eb 0b                	jmp    802e1f <insert_sorted_with_merge_freeList+0x618>
  802e14:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e17:	8b 40 04             	mov    0x4(%eax),%eax
  802e1a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802e1f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e22:	8b 40 04             	mov    0x4(%eax),%eax
  802e25:	85 c0                	test   %eax,%eax
  802e27:	74 0f                	je     802e38 <insert_sorted_with_merge_freeList+0x631>
  802e29:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e2c:	8b 40 04             	mov    0x4(%eax),%eax
  802e2f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e32:	8b 12                	mov    (%edx),%edx
  802e34:	89 10                	mov    %edx,(%eax)
  802e36:	eb 0a                	jmp    802e42 <insert_sorted_with_merge_freeList+0x63b>
  802e38:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e3b:	8b 00                	mov    (%eax),%eax
  802e3d:	a3 38 41 80 00       	mov    %eax,0x804138
  802e42:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e45:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e4b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e4e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e55:	a1 44 41 80 00       	mov    0x804144,%eax
  802e5a:	48                   	dec    %eax
  802e5b:	a3 44 41 80 00       	mov    %eax,0x804144
								LIST_INSERT_HEAD(&AvailableMemBlocksList, next );
  802e60:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e64:	75 17                	jne    802e7d <insert_sorted_with_merge_freeList+0x676>
  802e66:	83 ec 04             	sub    $0x4,%esp
  802e69:	68 d0 39 80 00       	push   $0x8039d0
  802e6e:	68 64 01 00 00       	push   $0x164
  802e73:	68 f3 39 80 00       	push   $0x8039f3
  802e78:	e8 de d3 ff ff       	call   80025b <_panic>
  802e7d:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e83:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e86:	89 10                	mov    %edx,(%eax)
  802e88:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e8b:	8b 00                	mov    (%eax),%eax
  802e8d:	85 c0                	test   %eax,%eax
  802e8f:	74 0d                	je     802e9e <insert_sorted_with_merge_freeList+0x697>
  802e91:	a1 48 41 80 00       	mov    0x804148,%eax
  802e96:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e99:	89 50 04             	mov    %edx,0x4(%eax)
  802e9c:	eb 08                	jmp    802ea6 <insert_sorted_with_merge_freeList+0x69f>
  802e9e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ea1:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ea6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ea9:	a3 48 41 80 00       	mov    %eax,0x804148
  802eae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eb1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eb8:	a1 54 41 80 00       	mov    0x804154,%eax
  802ebd:	40                   	inc    %eax
  802ebe:	a3 54 41 80 00       	mov    %eax,0x804154
							    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802ec3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ec7:	75 17                	jne    802ee0 <insert_sorted_with_merge_freeList+0x6d9>
  802ec9:	83 ec 04             	sub    $0x4,%esp
  802ecc:	68 d0 39 80 00       	push   $0x8039d0
  802ed1:	68 65 01 00 00       	push   $0x165
  802ed6:	68 f3 39 80 00       	push   $0x8039f3
  802edb:	e8 7b d3 ff ff       	call   80025b <_panic>
  802ee0:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ee6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee9:	89 10                	mov    %edx,(%eax)
  802eeb:	8b 45 08             	mov    0x8(%ebp),%eax
  802eee:	8b 00                	mov    (%eax),%eax
  802ef0:	85 c0                	test   %eax,%eax
  802ef2:	74 0d                	je     802f01 <insert_sorted_with_merge_freeList+0x6fa>
  802ef4:	a1 48 41 80 00       	mov    0x804148,%eax
  802ef9:	8b 55 08             	mov    0x8(%ebp),%edx
  802efc:	89 50 04             	mov    %edx,0x4(%eax)
  802eff:	eb 08                	jmp    802f09 <insert_sorted_with_merge_freeList+0x702>
  802f01:	8b 45 08             	mov    0x8(%ebp),%eax
  802f04:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f09:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0c:	a3 48 41 80 00       	mov    %eax,0x804148
  802f11:	8b 45 08             	mov    0x8(%ebp),%eax
  802f14:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f1b:	a1 54 41 80 00       	mov    0x804154,%eax
  802f20:	40                   	inc    %eax
  802f21:	a3 54 41 80 00       	mov    %eax,0x804154
								break;
  802f26:	eb 38                	jmp    802f60 <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  802f28:	a1 40 41 80 00       	mov    0x804140,%eax
  802f2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f30:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f34:	74 07                	je     802f3d <insert_sorted_with_merge_freeList+0x736>
  802f36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f39:	8b 00                	mov    (%eax),%eax
  802f3b:	eb 05                	jmp    802f42 <insert_sorted_with_merge_freeList+0x73b>
  802f3d:	b8 00 00 00 00       	mov    $0x0,%eax
  802f42:	a3 40 41 80 00       	mov    %eax,0x804140
  802f47:	a1 40 41 80 00       	mov    0x804140,%eax
  802f4c:	85 c0                	test   %eax,%eax
  802f4e:	0f 85 a7 fb ff ff    	jne    802afb <insert_sorted_with_merge_freeList+0x2f4>
  802f54:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f58:	0f 85 9d fb ff ff    	jne    802afb <insert_sorted_with_merge_freeList+0x2f4>
						}
				}
        }

}
}
  802f5e:	eb 00                	jmp    802f60 <insert_sorted_with_merge_freeList+0x759>
  802f60:	90                   	nop
  802f61:	c9                   	leave  
  802f62:	c3                   	ret    
  802f63:	90                   	nop

00802f64 <__udivdi3>:
  802f64:	55                   	push   %ebp
  802f65:	57                   	push   %edi
  802f66:	56                   	push   %esi
  802f67:	53                   	push   %ebx
  802f68:	83 ec 1c             	sub    $0x1c,%esp
  802f6b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802f6f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802f73:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802f77:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802f7b:	89 ca                	mov    %ecx,%edx
  802f7d:	89 f8                	mov    %edi,%eax
  802f7f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802f83:	85 f6                	test   %esi,%esi
  802f85:	75 2d                	jne    802fb4 <__udivdi3+0x50>
  802f87:	39 cf                	cmp    %ecx,%edi
  802f89:	77 65                	ja     802ff0 <__udivdi3+0x8c>
  802f8b:	89 fd                	mov    %edi,%ebp
  802f8d:	85 ff                	test   %edi,%edi
  802f8f:	75 0b                	jne    802f9c <__udivdi3+0x38>
  802f91:	b8 01 00 00 00       	mov    $0x1,%eax
  802f96:	31 d2                	xor    %edx,%edx
  802f98:	f7 f7                	div    %edi
  802f9a:	89 c5                	mov    %eax,%ebp
  802f9c:	31 d2                	xor    %edx,%edx
  802f9e:	89 c8                	mov    %ecx,%eax
  802fa0:	f7 f5                	div    %ebp
  802fa2:	89 c1                	mov    %eax,%ecx
  802fa4:	89 d8                	mov    %ebx,%eax
  802fa6:	f7 f5                	div    %ebp
  802fa8:	89 cf                	mov    %ecx,%edi
  802faa:	89 fa                	mov    %edi,%edx
  802fac:	83 c4 1c             	add    $0x1c,%esp
  802faf:	5b                   	pop    %ebx
  802fb0:	5e                   	pop    %esi
  802fb1:	5f                   	pop    %edi
  802fb2:	5d                   	pop    %ebp
  802fb3:	c3                   	ret    
  802fb4:	39 ce                	cmp    %ecx,%esi
  802fb6:	77 28                	ja     802fe0 <__udivdi3+0x7c>
  802fb8:	0f bd fe             	bsr    %esi,%edi
  802fbb:	83 f7 1f             	xor    $0x1f,%edi
  802fbe:	75 40                	jne    803000 <__udivdi3+0x9c>
  802fc0:	39 ce                	cmp    %ecx,%esi
  802fc2:	72 0a                	jb     802fce <__udivdi3+0x6a>
  802fc4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802fc8:	0f 87 9e 00 00 00    	ja     80306c <__udivdi3+0x108>
  802fce:	b8 01 00 00 00       	mov    $0x1,%eax
  802fd3:	89 fa                	mov    %edi,%edx
  802fd5:	83 c4 1c             	add    $0x1c,%esp
  802fd8:	5b                   	pop    %ebx
  802fd9:	5e                   	pop    %esi
  802fda:	5f                   	pop    %edi
  802fdb:	5d                   	pop    %ebp
  802fdc:	c3                   	ret    
  802fdd:	8d 76 00             	lea    0x0(%esi),%esi
  802fe0:	31 ff                	xor    %edi,%edi
  802fe2:	31 c0                	xor    %eax,%eax
  802fe4:	89 fa                	mov    %edi,%edx
  802fe6:	83 c4 1c             	add    $0x1c,%esp
  802fe9:	5b                   	pop    %ebx
  802fea:	5e                   	pop    %esi
  802feb:	5f                   	pop    %edi
  802fec:	5d                   	pop    %ebp
  802fed:	c3                   	ret    
  802fee:	66 90                	xchg   %ax,%ax
  802ff0:	89 d8                	mov    %ebx,%eax
  802ff2:	f7 f7                	div    %edi
  802ff4:	31 ff                	xor    %edi,%edi
  802ff6:	89 fa                	mov    %edi,%edx
  802ff8:	83 c4 1c             	add    $0x1c,%esp
  802ffb:	5b                   	pop    %ebx
  802ffc:	5e                   	pop    %esi
  802ffd:	5f                   	pop    %edi
  802ffe:	5d                   	pop    %ebp
  802fff:	c3                   	ret    
  803000:	bd 20 00 00 00       	mov    $0x20,%ebp
  803005:	89 eb                	mov    %ebp,%ebx
  803007:	29 fb                	sub    %edi,%ebx
  803009:	89 f9                	mov    %edi,%ecx
  80300b:	d3 e6                	shl    %cl,%esi
  80300d:	89 c5                	mov    %eax,%ebp
  80300f:	88 d9                	mov    %bl,%cl
  803011:	d3 ed                	shr    %cl,%ebp
  803013:	89 e9                	mov    %ebp,%ecx
  803015:	09 f1                	or     %esi,%ecx
  803017:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80301b:	89 f9                	mov    %edi,%ecx
  80301d:	d3 e0                	shl    %cl,%eax
  80301f:	89 c5                	mov    %eax,%ebp
  803021:	89 d6                	mov    %edx,%esi
  803023:	88 d9                	mov    %bl,%cl
  803025:	d3 ee                	shr    %cl,%esi
  803027:	89 f9                	mov    %edi,%ecx
  803029:	d3 e2                	shl    %cl,%edx
  80302b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80302f:	88 d9                	mov    %bl,%cl
  803031:	d3 e8                	shr    %cl,%eax
  803033:	09 c2                	or     %eax,%edx
  803035:	89 d0                	mov    %edx,%eax
  803037:	89 f2                	mov    %esi,%edx
  803039:	f7 74 24 0c          	divl   0xc(%esp)
  80303d:	89 d6                	mov    %edx,%esi
  80303f:	89 c3                	mov    %eax,%ebx
  803041:	f7 e5                	mul    %ebp
  803043:	39 d6                	cmp    %edx,%esi
  803045:	72 19                	jb     803060 <__udivdi3+0xfc>
  803047:	74 0b                	je     803054 <__udivdi3+0xf0>
  803049:	89 d8                	mov    %ebx,%eax
  80304b:	31 ff                	xor    %edi,%edi
  80304d:	e9 58 ff ff ff       	jmp    802faa <__udivdi3+0x46>
  803052:	66 90                	xchg   %ax,%ax
  803054:	8b 54 24 08          	mov    0x8(%esp),%edx
  803058:	89 f9                	mov    %edi,%ecx
  80305a:	d3 e2                	shl    %cl,%edx
  80305c:	39 c2                	cmp    %eax,%edx
  80305e:	73 e9                	jae    803049 <__udivdi3+0xe5>
  803060:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803063:	31 ff                	xor    %edi,%edi
  803065:	e9 40 ff ff ff       	jmp    802faa <__udivdi3+0x46>
  80306a:	66 90                	xchg   %ax,%ax
  80306c:	31 c0                	xor    %eax,%eax
  80306e:	e9 37 ff ff ff       	jmp    802faa <__udivdi3+0x46>
  803073:	90                   	nop

00803074 <__umoddi3>:
  803074:	55                   	push   %ebp
  803075:	57                   	push   %edi
  803076:	56                   	push   %esi
  803077:	53                   	push   %ebx
  803078:	83 ec 1c             	sub    $0x1c,%esp
  80307b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80307f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803083:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803087:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80308b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80308f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803093:	89 f3                	mov    %esi,%ebx
  803095:	89 fa                	mov    %edi,%edx
  803097:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80309b:	89 34 24             	mov    %esi,(%esp)
  80309e:	85 c0                	test   %eax,%eax
  8030a0:	75 1a                	jne    8030bc <__umoddi3+0x48>
  8030a2:	39 f7                	cmp    %esi,%edi
  8030a4:	0f 86 a2 00 00 00    	jbe    80314c <__umoddi3+0xd8>
  8030aa:	89 c8                	mov    %ecx,%eax
  8030ac:	89 f2                	mov    %esi,%edx
  8030ae:	f7 f7                	div    %edi
  8030b0:	89 d0                	mov    %edx,%eax
  8030b2:	31 d2                	xor    %edx,%edx
  8030b4:	83 c4 1c             	add    $0x1c,%esp
  8030b7:	5b                   	pop    %ebx
  8030b8:	5e                   	pop    %esi
  8030b9:	5f                   	pop    %edi
  8030ba:	5d                   	pop    %ebp
  8030bb:	c3                   	ret    
  8030bc:	39 f0                	cmp    %esi,%eax
  8030be:	0f 87 ac 00 00 00    	ja     803170 <__umoddi3+0xfc>
  8030c4:	0f bd e8             	bsr    %eax,%ebp
  8030c7:	83 f5 1f             	xor    $0x1f,%ebp
  8030ca:	0f 84 ac 00 00 00    	je     80317c <__umoddi3+0x108>
  8030d0:	bf 20 00 00 00       	mov    $0x20,%edi
  8030d5:	29 ef                	sub    %ebp,%edi
  8030d7:	89 fe                	mov    %edi,%esi
  8030d9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8030dd:	89 e9                	mov    %ebp,%ecx
  8030df:	d3 e0                	shl    %cl,%eax
  8030e1:	89 d7                	mov    %edx,%edi
  8030e3:	89 f1                	mov    %esi,%ecx
  8030e5:	d3 ef                	shr    %cl,%edi
  8030e7:	09 c7                	or     %eax,%edi
  8030e9:	89 e9                	mov    %ebp,%ecx
  8030eb:	d3 e2                	shl    %cl,%edx
  8030ed:	89 14 24             	mov    %edx,(%esp)
  8030f0:	89 d8                	mov    %ebx,%eax
  8030f2:	d3 e0                	shl    %cl,%eax
  8030f4:	89 c2                	mov    %eax,%edx
  8030f6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8030fa:	d3 e0                	shl    %cl,%eax
  8030fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  803100:	8b 44 24 08          	mov    0x8(%esp),%eax
  803104:	89 f1                	mov    %esi,%ecx
  803106:	d3 e8                	shr    %cl,%eax
  803108:	09 d0                	or     %edx,%eax
  80310a:	d3 eb                	shr    %cl,%ebx
  80310c:	89 da                	mov    %ebx,%edx
  80310e:	f7 f7                	div    %edi
  803110:	89 d3                	mov    %edx,%ebx
  803112:	f7 24 24             	mull   (%esp)
  803115:	89 c6                	mov    %eax,%esi
  803117:	89 d1                	mov    %edx,%ecx
  803119:	39 d3                	cmp    %edx,%ebx
  80311b:	0f 82 87 00 00 00    	jb     8031a8 <__umoddi3+0x134>
  803121:	0f 84 91 00 00 00    	je     8031b8 <__umoddi3+0x144>
  803127:	8b 54 24 04          	mov    0x4(%esp),%edx
  80312b:	29 f2                	sub    %esi,%edx
  80312d:	19 cb                	sbb    %ecx,%ebx
  80312f:	89 d8                	mov    %ebx,%eax
  803131:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803135:	d3 e0                	shl    %cl,%eax
  803137:	89 e9                	mov    %ebp,%ecx
  803139:	d3 ea                	shr    %cl,%edx
  80313b:	09 d0                	or     %edx,%eax
  80313d:	89 e9                	mov    %ebp,%ecx
  80313f:	d3 eb                	shr    %cl,%ebx
  803141:	89 da                	mov    %ebx,%edx
  803143:	83 c4 1c             	add    $0x1c,%esp
  803146:	5b                   	pop    %ebx
  803147:	5e                   	pop    %esi
  803148:	5f                   	pop    %edi
  803149:	5d                   	pop    %ebp
  80314a:	c3                   	ret    
  80314b:	90                   	nop
  80314c:	89 fd                	mov    %edi,%ebp
  80314e:	85 ff                	test   %edi,%edi
  803150:	75 0b                	jne    80315d <__umoddi3+0xe9>
  803152:	b8 01 00 00 00       	mov    $0x1,%eax
  803157:	31 d2                	xor    %edx,%edx
  803159:	f7 f7                	div    %edi
  80315b:	89 c5                	mov    %eax,%ebp
  80315d:	89 f0                	mov    %esi,%eax
  80315f:	31 d2                	xor    %edx,%edx
  803161:	f7 f5                	div    %ebp
  803163:	89 c8                	mov    %ecx,%eax
  803165:	f7 f5                	div    %ebp
  803167:	89 d0                	mov    %edx,%eax
  803169:	e9 44 ff ff ff       	jmp    8030b2 <__umoddi3+0x3e>
  80316e:	66 90                	xchg   %ax,%ax
  803170:	89 c8                	mov    %ecx,%eax
  803172:	89 f2                	mov    %esi,%edx
  803174:	83 c4 1c             	add    $0x1c,%esp
  803177:	5b                   	pop    %ebx
  803178:	5e                   	pop    %esi
  803179:	5f                   	pop    %edi
  80317a:	5d                   	pop    %ebp
  80317b:	c3                   	ret    
  80317c:	3b 04 24             	cmp    (%esp),%eax
  80317f:	72 06                	jb     803187 <__umoddi3+0x113>
  803181:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803185:	77 0f                	ja     803196 <__umoddi3+0x122>
  803187:	89 f2                	mov    %esi,%edx
  803189:	29 f9                	sub    %edi,%ecx
  80318b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80318f:	89 14 24             	mov    %edx,(%esp)
  803192:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803196:	8b 44 24 04          	mov    0x4(%esp),%eax
  80319a:	8b 14 24             	mov    (%esp),%edx
  80319d:	83 c4 1c             	add    $0x1c,%esp
  8031a0:	5b                   	pop    %ebx
  8031a1:	5e                   	pop    %esi
  8031a2:	5f                   	pop    %edi
  8031a3:	5d                   	pop    %ebp
  8031a4:	c3                   	ret    
  8031a5:	8d 76 00             	lea    0x0(%esi),%esi
  8031a8:	2b 04 24             	sub    (%esp),%eax
  8031ab:	19 fa                	sbb    %edi,%edx
  8031ad:	89 d1                	mov    %edx,%ecx
  8031af:	89 c6                	mov    %eax,%esi
  8031b1:	e9 71 ff ff ff       	jmp    803127 <__umoddi3+0xb3>
  8031b6:	66 90                	xchg   %ax,%ax
  8031b8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8031bc:	72 ea                	jb     8031a8 <__umoddi3+0x134>
  8031be:	89 d9                	mov    %ebx,%ecx
  8031c0:	e9 62 ff ff ff       	jmp    803127 <__umoddi3+0xb3>
