
obj/user/tst_sharing_2slave2:     file format elf32-i386


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
  800031:	e8 c3 01 00 00       	call   8001f9 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Slave program2: Get 2 shared variables, edit the writable one, and attempt to edit the readOnly one
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 24             	sub    $0x24,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80003f:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800043:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004a:	eb 29                	jmp    800075 <_main+0x3d>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004c:	a1 20 40 80 00       	mov    0x804020,%eax
  800051:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800057:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80005a:	89 d0                	mov    %edx,%eax
  80005c:	01 c0                	add    %eax,%eax
  80005e:	01 d0                	add    %edx,%eax
  800060:	c1 e0 03             	shl    $0x3,%eax
  800063:	01 c8                	add    %ecx,%eax
  800065:	8a 40 04             	mov    0x4(%eax),%al
  800068:	84 c0                	test   %al,%al
  80006a:	74 06                	je     800072 <_main+0x3a>
			{
				fullWS = 0;
  80006c:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  800070:	eb 12                	jmp    800084 <_main+0x4c>
_main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800072:	ff 45 f0             	incl   -0x10(%ebp)
  800075:	a1 20 40 80 00       	mov    0x804020,%eax
  80007a:	8b 50 74             	mov    0x74(%eax),%edx
  80007d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800080:	39 c2                	cmp    %eax,%edx
  800082:	77 c8                	ja     80004c <_main+0x14>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800084:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800088:	74 14                	je     80009e <_main+0x66>
  80008a:	83 ec 04             	sub    $0x4,%esp
  80008d:	68 c0 32 80 00       	push   $0x8032c0
  800092:	6a 13                	push   $0x13
  800094:	68 dc 32 80 00       	push   $0x8032dc
  800099:	e8 97 02 00 00       	call   800335 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	6a 00                	push   $0x0
  8000a3:	e8 6d 14 00 00       	call   801515 <malloc>
  8000a8:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	int32 parentenvID = sys_getparentenvid();
  8000ab:	e8 8c 1b 00 00       	call   801c3c <sys_getparentenvid>
  8000b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 *x, *z;

	//GET: z then x, opposite to creation order (x then y then z)
	//So, addresses here will be different from the OWNER addresses
	sys_disable_interrupt();
  8000b3:	e8 78 19 00 00       	call   801a30 <sys_disable_interrupt>
	int freeFrames = sys_calculate_free_frames() ;
  8000b8:	e8 86 18 00 00       	call   801943 <sys_calculate_free_frames>
  8000bd:	89 45 e8             	mov    %eax,-0x18(%ebp)
	z = sget(parentenvID,"z");
  8000c0:	83 ec 08             	sub    $0x8,%esp
  8000c3:	68 f7 32 80 00       	push   $0x8032f7
  8000c8:	ff 75 ec             	pushl  -0x14(%ebp)
  8000cb:	e8 3d 16 00 00       	call   80170d <sget>
  8000d0:	83 c4 10             	add    $0x10,%esp
  8000d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (z != (uint32*)(USER_HEAP_START + 0 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8000d6:	81 7d e4 00 00 00 80 	cmpl   $0x80000000,-0x1c(%ebp)
  8000dd:	74 14                	je     8000f3 <_main+0xbb>
  8000df:	83 ec 04             	sub    $0x4,%esp
  8000e2:	68 fc 32 80 00       	push   $0x8032fc
  8000e7:	6a 21                	push   $0x21
  8000e9:	68 dc 32 80 00       	push   $0x8032dc
  8000ee:	e8 42 02 00 00       	call   800335 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  8000f3:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000f6:	e8 48 18 00 00       	call   801943 <sys_calculate_free_frames>
  8000fb:	29 c3                	sub    %eax,%ebx
  8000fd:	89 d8                	mov    %ebx,%eax
  8000ff:	83 f8 01             	cmp    $0x1,%eax
  800102:	74 14                	je     800118 <_main+0xe0>
  800104:	83 ec 04             	sub    $0x4,%esp
  800107:	68 5c 33 80 00       	push   $0x80335c
  80010c:	6a 22                	push   $0x22
  80010e:	68 dc 32 80 00       	push   $0x8032dc
  800113:	e8 1d 02 00 00       	call   800335 <_panic>
	sys_enable_interrupt();
  800118:	e8 2d 19 00 00       	call   801a4a <sys_enable_interrupt>

	sys_disable_interrupt();
  80011d:	e8 0e 19 00 00       	call   801a30 <sys_disable_interrupt>
	freeFrames = sys_calculate_free_frames() ;
  800122:	e8 1c 18 00 00       	call   801943 <sys_calculate_free_frames>
  800127:	89 45 e8             	mov    %eax,-0x18(%ebp)
	x = sget(parentenvID,"x");
  80012a:	83 ec 08             	sub    $0x8,%esp
  80012d:	68 ed 33 80 00       	push   $0x8033ed
  800132:	ff 75 ec             	pushl  -0x14(%ebp)
  800135:	e8 d3 15 00 00       	call   80170d <sget>
  80013a:	83 c4 10             	add    $0x10,%esp
  80013d:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (x != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  800140:	81 7d e0 00 10 00 80 	cmpl   $0x80001000,-0x20(%ebp)
  800147:	74 14                	je     80015d <_main+0x125>
  800149:	83 ec 04             	sub    $0x4,%esp
  80014c:	68 fc 32 80 00       	push   $0x8032fc
  800151:	6a 28                	push   $0x28
  800153:	68 dc 32 80 00       	push   $0x8032dc
  800158:	e8 d8 01 00 00       	call   800335 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  80015d:	e8 e1 17 00 00       	call   801943 <sys_calculate_free_frames>
  800162:	89 c2                	mov    %eax,%edx
  800164:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800167:	39 c2                	cmp    %eax,%edx
  800169:	74 14                	je     80017f <_main+0x147>
  80016b:	83 ec 04             	sub    $0x4,%esp
  80016e:	68 5c 33 80 00       	push   $0x80335c
  800173:	6a 29                	push   $0x29
  800175:	68 dc 32 80 00       	push   $0x8032dc
  80017a:	e8 b6 01 00 00       	call   800335 <_panic>
	sys_enable_interrupt();
  80017f:	e8 c6 18 00 00       	call   801a4a <sys_enable_interrupt>

	if (*x != 10) panic("Get(): Shared Variable is not created or got correctly") ;
  800184:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800187:	8b 00                	mov    (%eax),%eax
  800189:	83 f8 0a             	cmp    $0xa,%eax
  80018c:	74 14                	je     8001a2 <_main+0x16a>
  80018e:	83 ec 04             	sub    $0x4,%esp
  800191:	68 f0 33 80 00       	push   $0x8033f0
  800196:	6a 2c                	push   $0x2c
  800198:	68 dc 32 80 00       	push   $0x8032dc
  80019d:	e8 93 01 00 00       	call   800335 <_panic>

	//Edit the writable object
	*z = 30;
  8001a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001a5:	c7 00 1e 00 00 00    	movl   $0x1e,(%eax)
	if (*z != 30) panic("Get(): Shared Variable is not created or got correctly") ;
  8001ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001ae:	8b 00                	mov    (%eax),%eax
  8001b0:	83 f8 1e             	cmp    $0x1e,%eax
  8001b3:	74 14                	je     8001c9 <_main+0x191>
  8001b5:	83 ec 04             	sub    $0x4,%esp
  8001b8:	68 f0 33 80 00       	push   $0x8033f0
  8001bd:	6a 30                	push   $0x30
  8001bf:	68 dc 32 80 00       	push   $0x8032dc
  8001c4:	e8 6c 01 00 00       	call   800335 <_panic>

	//Attempt to edit the ReadOnly object, it should panic
	cprintf("Attempt to edit the ReadOnly object @ va = %x\n", x);
  8001c9:	83 ec 08             	sub    $0x8,%esp
  8001cc:	ff 75 e0             	pushl  -0x20(%ebp)
  8001cf:	68 28 34 80 00       	push   $0x803428
  8001d4:	e8 10 04 00 00       	call   8005e9 <cprintf>
  8001d9:	83 c4 10             	add    $0x10,%esp
	*x = 100;
  8001dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001df:	c7 00 64 00 00 00    	movl   $0x64,(%eax)

	panic("Test FAILED! it should panic early and not reach this line of code") ;
  8001e5:	83 ec 04             	sub    $0x4,%esp
  8001e8:	68 58 34 80 00       	push   $0x803458
  8001ed:	6a 36                	push   $0x36
  8001ef:	68 dc 32 80 00       	push   $0x8032dc
  8001f4:	e8 3c 01 00 00       	call   800335 <_panic>

008001f9 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8001f9:	55                   	push   %ebp
  8001fa:	89 e5                	mov    %esp,%ebp
  8001fc:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8001ff:	e8 1f 1a 00 00       	call   801c23 <sys_getenvindex>
  800204:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800207:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80020a:	89 d0                	mov    %edx,%eax
  80020c:	c1 e0 03             	shl    $0x3,%eax
  80020f:	01 d0                	add    %edx,%eax
  800211:	01 c0                	add    %eax,%eax
  800213:	01 d0                	add    %edx,%eax
  800215:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80021c:	01 d0                	add    %edx,%eax
  80021e:	c1 e0 04             	shl    $0x4,%eax
  800221:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800226:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80022b:	a1 20 40 80 00       	mov    0x804020,%eax
  800230:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800236:	84 c0                	test   %al,%al
  800238:	74 0f                	je     800249 <libmain+0x50>
		binaryname = myEnv->prog_name;
  80023a:	a1 20 40 80 00       	mov    0x804020,%eax
  80023f:	05 5c 05 00 00       	add    $0x55c,%eax
  800244:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800249:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80024d:	7e 0a                	jle    800259 <libmain+0x60>
		binaryname = argv[0];
  80024f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800252:	8b 00                	mov    (%eax),%eax
  800254:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800259:	83 ec 08             	sub    $0x8,%esp
  80025c:	ff 75 0c             	pushl  0xc(%ebp)
  80025f:	ff 75 08             	pushl  0x8(%ebp)
  800262:	e8 d1 fd ff ff       	call   800038 <_main>
  800267:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80026a:	e8 c1 17 00 00       	call   801a30 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80026f:	83 ec 0c             	sub    $0xc,%esp
  800272:	68 b4 34 80 00       	push   $0x8034b4
  800277:	e8 6d 03 00 00       	call   8005e9 <cprintf>
  80027c:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80027f:	a1 20 40 80 00       	mov    0x804020,%eax
  800284:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80028a:	a1 20 40 80 00       	mov    0x804020,%eax
  80028f:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800295:	83 ec 04             	sub    $0x4,%esp
  800298:	52                   	push   %edx
  800299:	50                   	push   %eax
  80029a:	68 dc 34 80 00       	push   $0x8034dc
  80029f:	e8 45 03 00 00       	call   8005e9 <cprintf>
  8002a4:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8002a7:	a1 20 40 80 00       	mov    0x804020,%eax
  8002ac:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8002b2:	a1 20 40 80 00       	mov    0x804020,%eax
  8002b7:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8002bd:	a1 20 40 80 00       	mov    0x804020,%eax
  8002c2:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8002c8:	51                   	push   %ecx
  8002c9:	52                   	push   %edx
  8002ca:	50                   	push   %eax
  8002cb:	68 04 35 80 00       	push   $0x803504
  8002d0:	e8 14 03 00 00       	call   8005e9 <cprintf>
  8002d5:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002d8:	a1 20 40 80 00       	mov    0x804020,%eax
  8002dd:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8002e3:	83 ec 08             	sub    $0x8,%esp
  8002e6:	50                   	push   %eax
  8002e7:	68 5c 35 80 00       	push   $0x80355c
  8002ec:	e8 f8 02 00 00       	call   8005e9 <cprintf>
  8002f1:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8002f4:	83 ec 0c             	sub    $0xc,%esp
  8002f7:	68 b4 34 80 00       	push   $0x8034b4
  8002fc:	e8 e8 02 00 00       	call   8005e9 <cprintf>
  800301:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800304:	e8 41 17 00 00       	call   801a4a <sys_enable_interrupt>

	// exit gracefully
	exit();
  800309:	e8 19 00 00 00       	call   800327 <exit>
}
  80030e:	90                   	nop
  80030f:	c9                   	leave  
  800310:	c3                   	ret    

00800311 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800311:	55                   	push   %ebp
  800312:	89 e5                	mov    %esp,%ebp
  800314:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800317:	83 ec 0c             	sub    $0xc,%esp
  80031a:	6a 00                	push   $0x0
  80031c:	e8 ce 18 00 00       	call   801bef <sys_destroy_env>
  800321:	83 c4 10             	add    $0x10,%esp
}
  800324:	90                   	nop
  800325:	c9                   	leave  
  800326:	c3                   	ret    

00800327 <exit>:

void
exit(void)
{
  800327:	55                   	push   %ebp
  800328:	89 e5                	mov    %esp,%ebp
  80032a:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80032d:	e8 23 19 00 00       	call   801c55 <sys_exit_env>
}
  800332:	90                   	nop
  800333:	c9                   	leave  
  800334:	c3                   	ret    

00800335 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800335:	55                   	push   %ebp
  800336:	89 e5                	mov    %esp,%ebp
  800338:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80033b:	8d 45 10             	lea    0x10(%ebp),%eax
  80033e:	83 c0 04             	add    $0x4,%eax
  800341:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800344:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800349:	85 c0                	test   %eax,%eax
  80034b:	74 16                	je     800363 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80034d:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800352:	83 ec 08             	sub    $0x8,%esp
  800355:	50                   	push   %eax
  800356:	68 70 35 80 00       	push   $0x803570
  80035b:	e8 89 02 00 00       	call   8005e9 <cprintf>
  800360:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800363:	a1 00 40 80 00       	mov    0x804000,%eax
  800368:	ff 75 0c             	pushl  0xc(%ebp)
  80036b:	ff 75 08             	pushl  0x8(%ebp)
  80036e:	50                   	push   %eax
  80036f:	68 75 35 80 00       	push   $0x803575
  800374:	e8 70 02 00 00       	call   8005e9 <cprintf>
  800379:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80037c:	8b 45 10             	mov    0x10(%ebp),%eax
  80037f:	83 ec 08             	sub    $0x8,%esp
  800382:	ff 75 f4             	pushl  -0xc(%ebp)
  800385:	50                   	push   %eax
  800386:	e8 f3 01 00 00       	call   80057e <vcprintf>
  80038b:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80038e:	83 ec 08             	sub    $0x8,%esp
  800391:	6a 00                	push   $0x0
  800393:	68 91 35 80 00       	push   $0x803591
  800398:	e8 e1 01 00 00       	call   80057e <vcprintf>
  80039d:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8003a0:	e8 82 ff ff ff       	call   800327 <exit>

	// should not return here
	while (1) ;
  8003a5:	eb fe                	jmp    8003a5 <_panic+0x70>

008003a7 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8003a7:	55                   	push   %ebp
  8003a8:	89 e5                	mov    %esp,%ebp
  8003aa:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8003ad:	a1 20 40 80 00       	mov    0x804020,%eax
  8003b2:	8b 50 74             	mov    0x74(%eax),%edx
  8003b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003b8:	39 c2                	cmp    %eax,%edx
  8003ba:	74 14                	je     8003d0 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8003bc:	83 ec 04             	sub    $0x4,%esp
  8003bf:	68 94 35 80 00       	push   $0x803594
  8003c4:	6a 26                	push   $0x26
  8003c6:	68 e0 35 80 00       	push   $0x8035e0
  8003cb:	e8 65 ff ff ff       	call   800335 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8003d0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8003d7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003de:	e9 c2 00 00 00       	jmp    8004a5 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8003e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003e6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f0:	01 d0                	add    %edx,%eax
  8003f2:	8b 00                	mov    (%eax),%eax
  8003f4:	85 c0                	test   %eax,%eax
  8003f6:	75 08                	jne    800400 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8003f8:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003fb:	e9 a2 00 00 00       	jmp    8004a2 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800400:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800407:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80040e:	eb 69                	jmp    800479 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800410:	a1 20 40 80 00       	mov    0x804020,%eax
  800415:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80041b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80041e:	89 d0                	mov    %edx,%eax
  800420:	01 c0                	add    %eax,%eax
  800422:	01 d0                	add    %edx,%eax
  800424:	c1 e0 03             	shl    $0x3,%eax
  800427:	01 c8                	add    %ecx,%eax
  800429:	8a 40 04             	mov    0x4(%eax),%al
  80042c:	84 c0                	test   %al,%al
  80042e:	75 46                	jne    800476 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800430:	a1 20 40 80 00       	mov    0x804020,%eax
  800435:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80043b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80043e:	89 d0                	mov    %edx,%eax
  800440:	01 c0                	add    %eax,%eax
  800442:	01 d0                	add    %edx,%eax
  800444:	c1 e0 03             	shl    $0x3,%eax
  800447:	01 c8                	add    %ecx,%eax
  800449:	8b 00                	mov    (%eax),%eax
  80044b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80044e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800451:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800456:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800458:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80045b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800462:	8b 45 08             	mov    0x8(%ebp),%eax
  800465:	01 c8                	add    %ecx,%eax
  800467:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800469:	39 c2                	cmp    %eax,%edx
  80046b:	75 09                	jne    800476 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80046d:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800474:	eb 12                	jmp    800488 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800476:	ff 45 e8             	incl   -0x18(%ebp)
  800479:	a1 20 40 80 00       	mov    0x804020,%eax
  80047e:	8b 50 74             	mov    0x74(%eax),%edx
  800481:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800484:	39 c2                	cmp    %eax,%edx
  800486:	77 88                	ja     800410 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800488:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80048c:	75 14                	jne    8004a2 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80048e:	83 ec 04             	sub    $0x4,%esp
  800491:	68 ec 35 80 00       	push   $0x8035ec
  800496:	6a 3a                	push   $0x3a
  800498:	68 e0 35 80 00       	push   $0x8035e0
  80049d:	e8 93 fe ff ff       	call   800335 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8004a2:	ff 45 f0             	incl   -0x10(%ebp)
  8004a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004a8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004ab:	0f 8c 32 ff ff ff    	jl     8003e3 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8004b1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004b8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8004bf:	eb 26                	jmp    8004e7 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8004c1:	a1 20 40 80 00       	mov    0x804020,%eax
  8004c6:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8004cc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004cf:	89 d0                	mov    %edx,%eax
  8004d1:	01 c0                	add    %eax,%eax
  8004d3:	01 d0                	add    %edx,%eax
  8004d5:	c1 e0 03             	shl    $0x3,%eax
  8004d8:	01 c8                	add    %ecx,%eax
  8004da:	8a 40 04             	mov    0x4(%eax),%al
  8004dd:	3c 01                	cmp    $0x1,%al
  8004df:	75 03                	jne    8004e4 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8004e1:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004e4:	ff 45 e0             	incl   -0x20(%ebp)
  8004e7:	a1 20 40 80 00       	mov    0x804020,%eax
  8004ec:	8b 50 74             	mov    0x74(%eax),%edx
  8004ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004f2:	39 c2                	cmp    %eax,%edx
  8004f4:	77 cb                	ja     8004c1 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004f9:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004fc:	74 14                	je     800512 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8004fe:	83 ec 04             	sub    $0x4,%esp
  800501:	68 40 36 80 00       	push   $0x803640
  800506:	6a 44                	push   $0x44
  800508:	68 e0 35 80 00       	push   $0x8035e0
  80050d:	e8 23 fe ff ff       	call   800335 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800512:	90                   	nop
  800513:	c9                   	leave  
  800514:	c3                   	ret    

00800515 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800515:	55                   	push   %ebp
  800516:	89 e5                	mov    %esp,%ebp
  800518:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80051b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80051e:	8b 00                	mov    (%eax),%eax
  800520:	8d 48 01             	lea    0x1(%eax),%ecx
  800523:	8b 55 0c             	mov    0xc(%ebp),%edx
  800526:	89 0a                	mov    %ecx,(%edx)
  800528:	8b 55 08             	mov    0x8(%ebp),%edx
  80052b:	88 d1                	mov    %dl,%cl
  80052d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800530:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800534:	8b 45 0c             	mov    0xc(%ebp),%eax
  800537:	8b 00                	mov    (%eax),%eax
  800539:	3d ff 00 00 00       	cmp    $0xff,%eax
  80053e:	75 2c                	jne    80056c <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800540:	a0 24 40 80 00       	mov    0x804024,%al
  800545:	0f b6 c0             	movzbl %al,%eax
  800548:	8b 55 0c             	mov    0xc(%ebp),%edx
  80054b:	8b 12                	mov    (%edx),%edx
  80054d:	89 d1                	mov    %edx,%ecx
  80054f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800552:	83 c2 08             	add    $0x8,%edx
  800555:	83 ec 04             	sub    $0x4,%esp
  800558:	50                   	push   %eax
  800559:	51                   	push   %ecx
  80055a:	52                   	push   %edx
  80055b:	e8 22 13 00 00       	call   801882 <sys_cputs>
  800560:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800563:	8b 45 0c             	mov    0xc(%ebp),%eax
  800566:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80056c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80056f:	8b 40 04             	mov    0x4(%eax),%eax
  800572:	8d 50 01             	lea    0x1(%eax),%edx
  800575:	8b 45 0c             	mov    0xc(%ebp),%eax
  800578:	89 50 04             	mov    %edx,0x4(%eax)
}
  80057b:	90                   	nop
  80057c:	c9                   	leave  
  80057d:	c3                   	ret    

0080057e <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80057e:	55                   	push   %ebp
  80057f:	89 e5                	mov    %esp,%ebp
  800581:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800587:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80058e:	00 00 00 
	b.cnt = 0;
  800591:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800598:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80059b:	ff 75 0c             	pushl  0xc(%ebp)
  80059e:	ff 75 08             	pushl  0x8(%ebp)
  8005a1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005a7:	50                   	push   %eax
  8005a8:	68 15 05 80 00       	push   $0x800515
  8005ad:	e8 11 02 00 00       	call   8007c3 <vprintfmt>
  8005b2:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8005b5:	a0 24 40 80 00       	mov    0x804024,%al
  8005ba:	0f b6 c0             	movzbl %al,%eax
  8005bd:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8005c3:	83 ec 04             	sub    $0x4,%esp
  8005c6:	50                   	push   %eax
  8005c7:	52                   	push   %edx
  8005c8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005ce:	83 c0 08             	add    $0x8,%eax
  8005d1:	50                   	push   %eax
  8005d2:	e8 ab 12 00 00       	call   801882 <sys_cputs>
  8005d7:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005da:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  8005e1:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005e7:	c9                   	leave  
  8005e8:	c3                   	ret    

008005e9 <cprintf>:

int cprintf(const char *fmt, ...) {
  8005e9:	55                   	push   %ebp
  8005ea:	89 e5                	mov    %esp,%ebp
  8005ec:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005ef:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  8005f6:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ff:	83 ec 08             	sub    $0x8,%esp
  800602:	ff 75 f4             	pushl  -0xc(%ebp)
  800605:	50                   	push   %eax
  800606:	e8 73 ff ff ff       	call   80057e <vcprintf>
  80060b:	83 c4 10             	add    $0x10,%esp
  80060e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800611:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800614:	c9                   	leave  
  800615:	c3                   	ret    

00800616 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800616:	55                   	push   %ebp
  800617:	89 e5                	mov    %esp,%ebp
  800619:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80061c:	e8 0f 14 00 00       	call   801a30 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800621:	8d 45 0c             	lea    0xc(%ebp),%eax
  800624:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800627:	8b 45 08             	mov    0x8(%ebp),%eax
  80062a:	83 ec 08             	sub    $0x8,%esp
  80062d:	ff 75 f4             	pushl  -0xc(%ebp)
  800630:	50                   	push   %eax
  800631:	e8 48 ff ff ff       	call   80057e <vcprintf>
  800636:	83 c4 10             	add    $0x10,%esp
  800639:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80063c:	e8 09 14 00 00       	call   801a4a <sys_enable_interrupt>
	return cnt;
  800641:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800644:	c9                   	leave  
  800645:	c3                   	ret    

00800646 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800646:	55                   	push   %ebp
  800647:	89 e5                	mov    %esp,%ebp
  800649:	53                   	push   %ebx
  80064a:	83 ec 14             	sub    $0x14,%esp
  80064d:	8b 45 10             	mov    0x10(%ebp),%eax
  800650:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800653:	8b 45 14             	mov    0x14(%ebp),%eax
  800656:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800659:	8b 45 18             	mov    0x18(%ebp),%eax
  80065c:	ba 00 00 00 00       	mov    $0x0,%edx
  800661:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800664:	77 55                	ja     8006bb <printnum+0x75>
  800666:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800669:	72 05                	jb     800670 <printnum+0x2a>
  80066b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80066e:	77 4b                	ja     8006bb <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800670:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800673:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800676:	8b 45 18             	mov    0x18(%ebp),%eax
  800679:	ba 00 00 00 00       	mov    $0x0,%edx
  80067e:	52                   	push   %edx
  80067f:	50                   	push   %eax
  800680:	ff 75 f4             	pushl  -0xc(%ebp)
  800683:	ff 75 f0             	pushl  -0x10(%ebp)
  800686:	e8 b5 29 00 00       	call   803040 <__udivdi3>
  80068b:	83 c4 10             	add    $0x10,%esp
  80068e:	83 ec 04             	sub    $0x4,%esp
  800691:	ff 75 20             	pushl  0x20(%ebp)
  800694:	53                   	push   %ebx
  800695:	ff 75 18             	pushl  0x18(%ebp)
  800698:	52                   	push   %edx
  800699:	50                   	push   %eax
  80069a:	ff 75 0c             	pushl  0xc(%ebp)
  80069d:	ff 75 08             	pushl  0x8(%ebp)
  8006a0:	e8 a1 ff ff ff       	call   800646 <printnum>
  8006a5:	83 c4 20             	add    $0x20,%esp
  8006a8:	eb 1a                	jmp    8006c4 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006aa:	83 ec 08             	sub    $0x8,%esp
  8006ad:	ff 75 0c             	pushl  0xc(%ebp)
  8006b0:	ff 75 20             	pushl  0x20(%ebp)
  8006b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b6:	ff d0                	call   *%eax
  8006b8:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006bb:	ff 4d 1c             	decl   0x1c(%ebp)
  8006be:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006c2:	7f e6                	jg     8006aa <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006c4:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006c7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006d2:	53                   	push   %ebx
  8006d3:	51                   	push   %ecx
  8006d4:	52                   	push   %edx
  8006d5:	50                   	push   %eax
  8006d6:	e8 75 2a 00 00       	call   803150 <__umoddi3>
  8006db:	83 c4 10             	add    $0x10,%esp
  8006de:	05 b4 38 80 00       	add    $0x8038b4,%eax
  8006e3:	8a 00                	mov    (%eax),%al
  8006e5:	0f be c0             	movsbl %al,%eax
  8006e8:	83 ec 08             	sub    $0x8,%esp
  8006eb:	ff 75 0c             	pushl  0xc(%ebp)
  8006ee:	50                   	push   %eax
  8006ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f2:	ff d0                	call   *%eax
  8006f4:	83 c4 10             	add    $0x10,%esp
}
  8006f7:	90                   	nop
  8006f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006fb:	c9                   	leave  
  8006fc:	c3                   	ret    

008006fd <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006fd:	55                   	push   %ebp
  8006fe:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800700:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800704:	7e 1c                	jle    800722 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
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
  800720:	eb 40                	jmp    800762 <getuint+0x65>
	else if (lflag)
  800722:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800726:	74 1e                	je     800746 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800728:	8b 45 08             	mov    0x8(%ebp),%eax
  80072b:	8b 00                	mov    (%eax),%eax
  80072d:	8d 50 04             	lea    0x4(%eax),%edx
  800730:	8b 45 08             	mov    0x8(%ebp),%eax
  800733:	89 10                	mov    %edx,(%eax)
  800735:	8b 45 08             	mov    0x8(%ebp),%eax
  800738:	8b 00                	mov    (%eax),%eax
  80073a:	83 e8 04             	sub    $0x4,%eax
  80073d:	8b 00                	mov    (%eax),%eax
  80073f:	ba 00 00 00 00       	mov    $0x0,%edx
  800744:	eb 1c                	jmp    800762 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800746:	8b 45 08             	mov    0x8(%ebp),%eax
  800749:	8b 00                	mov    (%eax),%eax
  80074b:	8d 50 04             	lea    0x4(%eax),%edx
  80074e:	8b 45 08             	mov    0x8(%ebp),%eax
  800751:	89 10                	mov    %edx,(%eax)
  800753:	8b 45 08             	mov    0x8(%ebp),%eax
  800756:	8b 00                	mov    (%eax),%eax
  800758:	83 e8 04             	sub    $0x4,%eax
  80075b:	8b 00                	mov    (%eax),%eax
  80075d:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800762:	5d                   	pop    %ebp
  800763:	c3                   	ret    

00800764 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800764:	55                   	push   %ebp
  800765:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800767:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80076b:	7e 1c                	jle    800789 <getint+0x25>
		return va_arg(*ap, long long);
  80076d:	8b 45 08             	mov    0x8(%ebp),%eax
  800770:	8b 00                	mov    (%eax),%eax
  800772:	8d 50 08             	lea    0x8(%eax),%edx
  800775:	8b 45 08             	mov    0x8(%ebp),%eax
  800778:	89 10                	mov    %edx,(%eax)
  80077a:	8b 45 08             	mov    0x8(%ebp),%eax
  80077d:	8b 00                	mov    (%eax),%eax
  80077f:	83 e8 08             	sub    $0x8,%eax
  800782:	8b 50 04             	mov    0x4(%eax),%edx
  800785:	8b 00                	mov    (%eax),%eax
  800787:	eb 38                	jmp    8007c1 <getint+0x5d>
	else if (lflag)
  800789:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80078d:	74 1a                	je     8007a9 <getint+0x45>
		return va_arg(*ap, long);
  80078f:	8b 45 08             	mov    0x8(%ebp),%eax
  800792:	8b 00                	mov    (%eax),%eax
  800794:	8d 50 04             	lea    0x4(%eax),%edx
  800797:	8b 45 08             	mov    0x8(%ebp),%eax
  80079a:	89 10                	mov    %edx,(%eax)
  80079c:	8b 45 08             	mov    0x8(%ebp),%eax
  80079f:	8b 00                	mov    (%eax),%eax
  8007a1:	83 e8 04             	sub    $0x4,%eax
  8007a4:	8b 00                	mov    (%eax),%eax
  8007a6:	99                   	cltd   
  8007a7:	eb 18                	jmp    8007c1 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ac:	8b 00                	mov    (%eax),%eax
  8007ae:	8d 50 04             	lea    0x4(%eax),%edx
  8007b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b4:	89 10                	mov    %edx,(%eax)
  8007b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b9:	8b 00                	mov    (%eax),%eax
  8007bb:	83 e8 04             	sub    $0x4,%eax
  8007be:	8b 00                	mov    (%eax),%eax
  8007c0:	99                   	cltd   
}
  8007c1:	5d                   	pop    %ebp
  8007c2:	c3                   	ret    

008007c3 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007c3:	55                   	push   %ebp
  8007c4:	89 e5                	mov    %esp,%ebp
  8007c6:	56                   	push   %esi
  8007c7:	53                   	push   %ebx
  8007c8:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007cb:	eb 17                	jmp    8007e4 <vprintfmt+0x21>
			if (ch == '\0')
  8007cd:	85 db                	test   %ebx,%ebx
  8007cf:	0f 84 af 03 00 00    	je     800b84 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8007d5:	83 ec 08             	sub    $0x8,%esp
  8007d8:	ff 75 0c             	pushl  0xc(%ebp)
  8007db:	53                   	push   %ebx
  8007dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007df:	ff d0                	call   *%eax
  8007e1:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8007e7:	8d 50 01             	lea    0x1(%eax),%edx
  8007ea:	89 55 10             	mov    %edx,0x10(%ebp)
  8007ed:	8a 00                	mov    (%eax),%al
  8007ef:	0f b6 d8             	movzbl %al,%ebx
  8007f2:	83 fb 25             	cmp    $0x25,%ebx
  8007f5:	75 d6                	jne    8007cd <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007f7:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007fb:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800802:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800809:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800810:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800817:	8b 45 10             	mov    0x10(%ebp),%eax
  80081a:	8d 50 01             	lea    0x1(%eax),%edx
  80081d:	89 55 10             	mov    %edx,0x10(%ebp)
  800820:	8a 00                	mov    (%eax),%al
  800822:	0f b6 d8             	movzbl %al,%ebx
  800825:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800828:	83 f8 55             	cmp    $0x55,%eax
  80082b:	0f 87 2b 03 00 00    	ja     800b5c <vprintfmt+0x399>
  800831:	8b 04 85 d8 38 80 00 	mov    0x8038d8(,%eax,4),%eax
  800838:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80083a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80083e:	eb d7                	jmp    800817 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800840:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800844:	eb d1                	jmp    800817 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800846:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80084d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800850:	89 d0                	mov    %edx,%eax
  800852:	c1 e0 02             	shl    $0x2,%eax
  800855:	01 d0                	add    %edx,%eax
  800857:	01 c0                	add    %eax,%eax
  800859:	01 d8                	add    %ebx,%eax
  80085b:	83 e8 30             	sub    $0x30,%eax
  80085e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800861:	8b 45 10             	mov    0x10(%ebp),%eax
  800864:	8a 00                	mov    (%eax),%al
  800866:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800869:	83 fb 2f             	cmp    $0x2f,%ebx
  80086c:	7e 3e                	jle    8008ac <vprintfmt+0xe9>
  80086e:	83 fb 39             	cmp    $0x39,%ebx
  800871:	7f 39                	jg     8008ac <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800873:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800876:	eb d5                	jmp    80084d <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800878:	8b 45 14             	mov    0x14(%ebp),%eax
  80087b:	83 c0 04             	add    $0x4,%eax
  80087e:	89 45 14             	mov    %eax,0x14(%ebp)
  800881:	8b 45 14             	mov    0x14(%ebp),%eax
  800884:	83 e8 04             	sub    $0x4,%eax
  800887:	8b 00                	mov    (%eax),%eax
  800889:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80088c:	eb 1f                	jmp    8008ad <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80088e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800892:	79 83                	jns    800817 <vprintfmt+0x54>
				width = 0;
  800894:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80089b:	e9 77 ff ff ff       	jmp    800817 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008a0:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008a7:	e9 6b ff ff ff       	jmp    800817 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008ac:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008ad:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008b1:	0f 89 60 ff ff ff    	jns    800817 <vprintfmt+0x54>
				width = precision, precision = -1;
  8008b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008bd:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008c4:	e9 4e ff ff ff       	jmp    800817 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008c9:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008cc:	e9 46 ff ff ff       	jmp    800817 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d4:	83 c0 04             	add    $0x4,%eax
  8008d7:	89 45 14             	mov    %eax,0x14(%ebp)
  8008da:	8b 45 14             	mov    0x14(%ebp),%eax
  8008dd:	83 e8 04             	sub    $0x4,%eax
  8008e0:	8b 00                	mov    (%eax),%eax
  8008e2:	83 ec 08             	sub    $0x8,%esp
  8008e5:	ff 75 0c             	pushl  0xc(%ebp)
  8008e8:	50                   	push   %eax
  8008e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ec:	ff d0                	call   *%eax
  8008ee:	83 c4 10             	add    $0x10,%esp
			break;
  8008f1:	e9 89 02 00 00       	jmp    800b7f <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f9:	83 c0 04             	add    $0x4,%eax
  8008fc:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800902:	83 e8 04             	sub    $0x4,%eax
  800905:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800907:	85 db                	test   %ebx,%ebx
  800909:	79 02                	jns    80090d <vprintfmt+0x14a>
				err = -err;
  80090b:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80090d:	83 fb 64             	cmp    $0x64,%ebx
  800910:	7f 0b                	jg     80091d <vprintfmt+0x15a>
  800912:	8b 34 9d 20 37 80 00 	mov    0x803720(,%ebx,4),%esi
  800919:	85 f6                	test   %esi,%esi
  80091b:	75 19                	jne    800936 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80091d:	53                   	push   %ebx
  80091e:	68 c5 38 80 00       	push   $0x8038c5
  800923:	ff 75 0c             	pushl  0xc(%ebp)
  800926:	ff 75 08             	pushl  0x8(%ebp)
  800929:	e8 5e 02 00 00       	call   800b8c <printfmt>
  80092e:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800931:	e9 49 02 00 00       	jmp    800b7f <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800936:	56                   	push   %esi
  800937:	68 ce 38 80 00       	push   $0x8038ce
  80093c:	ff 75 0c             	pushl  0xc(%ebp)
  80093f:	ff 75 08             	pushl  0x8(%ebp)
  800942:	e8 45 02 00 00       	call   800b8c <printfmt>
  800947:	83 c4 10             	add    $0x10,%esp
			break;
  80094a:	e9 30 02 00 00       	jmp    800b7f <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80094f:	8b 45 14             	mov    0x14(%ebp),%eax
  800952:	83 c0 04             	add    $0x4,%eax
  800955:	89 45 14             	mov    %eax,0x14(%ebp)
  800958:	8b 45 14             	mov    0x14(%ebp),%eax
  80095b:	83 e8 04             	sub    $0x4,%eax
  80095e:	8b 30                	mov    (%eax),%esi
  800960:	85 f6                	test   %esi,%esi
  800962:	75 05                	jne    800969 <vprintfmt+0x1a6>
				p = "(null)";
  800964:	be d1 38 80 00       	mov    $0x8038d1,%esi
			if (width > 0 && padc != '-')
  800969:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80096d:	7e 6d                	jle    8009dc <vprintfmt+0x219>
  80096f:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800973:	74 67                	je     8009dc <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800975:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800978:	83 ec 08             	sub    $0x8,%esp
  80097b:	50                   	push   %eax
  80097c:	56                   	push   %esi
  80097d:	e8 0c 03 00 00       	call   800c8e <strnlen>
  800982:	83 c4 10             	add    $0x10,%esp
  800985:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800988:	eb 16                	jmp    8009a0 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80098a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80098e:	83 ec 08             	sub    $0x8,%esp
  800991:	ff 75 0c             	pushl  0xc(%ebp)
  800994:	50                   	push   %eax
  800995:	8b 45 08             	mov    0x8(%ebp),%eax
  800998:	ff d0                	call   *%eax
  80099a:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80099d:	ff 4d e4             	decl   -0x1c(%ebp)
  8009a0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009a4:	7f e4                	jg     80098a <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009a6:	eb 34                	jmp    8009dc <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009a8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009ac:	74 1c                	je     8009ca <vprintfmt+0x207>
  8009ae:	83 fb 1f             	cmp    $0x1f,%ebx
  8009b1:	7e 05                	jle    8009b8 <vprintfmt+0x1f5>
  8009b3:	83 fb 7e             	cmp    $0x7e,%ebx
  8009b6:	7e 12                	jle    8009ca <vprintfmt+0x207>
					putch('?', putdat);
  8009b8:	83 ec 08             	sub    $0x8,%esp
  8009bb:	ff 75 0c             	pushl  0xc(%ebp)
  8009be:	6a 3f                	push   $0x3f
  8009c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c3:	ff d0                	call   *%eax
  8009c5:	83 c4 10             	add    $0x10,%esp
  8009c8:	eb 0f                	jmp    8009d9 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009ca:	83 ec 08             	sub    $0x8,%esp
  8009cd:	ff 75 0c             	pushl  0xc(%ebp)
  8009d0:	53                   	push   %ebx
  8009d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d4:	ff d0                	call   *%eax
  8009d6:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009d9:	ff 4d e4             	decl   -0x1c(%ebp)
  8009dc:	89 f0                	mov    %esi,%eax
  8009de:	8d 70 01             	lea    0x1(%eax),%esi
  8009e1:	8a 00                	mov    (%eax),%al
  8009e3:	0f be d8             	movsbl %al,%ebx
  8009e6:	85 db                	test   %ebx,%ebx
  8009e8:	74 24                	je     800a0e <vprintfmt+0x24b>
  8009ea:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009ee:	78 b8                	js     8009a8 <vprintfmt+0x1e5>
  8009f0:	ff 4d e0             	decl   -0x20(%ebp)
  8009f3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009f7:	79 af                	jns    8009a8 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009f9:	eb 13                	jmp    800a0e <vprintfmt+0x24b>
				putch(' ', putdat);
  8009fb:	83 ec 08             	sub    $0x8,%esp
  8009fe:	ff 75 0c             	pushl  0xc(%ebp)
  800a01:	6a 20                	push   $0x20
  800a03:	8b 45 08             	mov    0x8(%ebp),%eax
  800a06:	ff d0                	call   *%eax
  800a08:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a0b:	ff 4d e4             	decl   -0x1c(%ebp)
  800a0e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a12:	7f e7                	jg     8009fb <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a14:	e9 66 01 00 00       	jmp    800b7f <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a19:	83 ec 08             	sub    $0x8,%esp
  800a1c:	ff 75 e8             	pushl  -0x18(%ebp)
  800a1f:	8d 45 14             	lea    0x14(%ebp),%eax
  800a22:	50                   	push   %eax
  800a23:	e8 3c fd ff ff       	call   800764 <getint>
  800a28:	83 c4 10             	add    $0x10,%esp
  800a2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a2e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a34:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a37:	85 d2                	test   %edx,%edx
  800a39:	79 23                	jns    800a5e <vprintfmt+0x29b>
				putch('-', putdat);
  800a3b:	83 ec 08             	sub    $0x8,%esp
  800a3e:	ff 75 0c             	pushl  0xc(%ebp)
  800a41:	6a 2d                	push   $0x2d
  800a43:	8b 45 08             	mov    0x8(%ebp),%eax
  800a46:	ff d0                	call   *%eax
  800a48:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a51:	f7 d8                	neg    %eax
  800a53:	83 d2 00             	adc    $0x0,%edx
  800a56:	f7 da                	neg    %edx
  800a58:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a5b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a5e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a65:	e9 bc 00 00 00       	jmp    800b26 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a6a:	83 ec 08             	sub    $0x8,%esp
  800a6d:	ff 75 e8             	pushl  -0x18(%ebp)
  800a70:	8d 45 14             	lea    0x14(%ebp),%eax
  800a73:	50                   	push   %eax
  800a74:	e8 84 fc ff ff       	call   8006fd <getuint>
  800a79:	83 c4 10             	add    $0x10,%esp
  800a7c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a7f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a82:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a89:	e9 98 00 00 00       	jmp    800b26 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a8e:	83 ec 08             	sub    $0x8,%esp
  800a91:	ff 75 0c             	pushl  0xc(%ebp)
  800a94:	6a 58                	push   $0x58
  800a96:	8b 45 08             	mov    0x8(%ebp),%eax
  800a99:	ff d0                	call   *%eax
  800a9b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a9e:	83 ec 08             	sub    $0x8,%esp
  800aa1:	ff 75 0c             	pushl  0xc(%ebp)
  800aa4:	6a 58                	push   $0x58
  800aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa9:	ff d0                	call   *%eax
  800aab:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800aae:	83 ec 08             	sub    $0x8,%esp
  800ab1:	ff 75 0c             	pushl  0xc(%ebp)
  800ab4:	6a 58                	push   $0x58
  800ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab9:	ff d0                	call   *%eax
  800abb:	83 c4 10             	add    $0x10,%esp
			break;
  800abe:	e9 bc 00 00 00       	jmp    800b7f <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800ac3:	83 ec 08             	sub    $0x8,%esp
  800ac6:	ff 75 0c             	pushl  0xc(%ebp)
  800ac9:	6a 30                	push   $0x30
  800acb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ace:	ff d0                	call   *%eax
  800ad0:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ad3:	83 ec 08             	sub    $0x8,%esp
  800ad6:	ff 75 0c             	pushl  0xc(%ebp)
  800ad9:	6a 78                	push   $0x78
  800adb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ade:	ff d0                	call   *%eax
  800ae0:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ae3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae6:	83 c0 04             	add    $0x4,%eax
  800ae9:	89 45 14             	mov    %eax,0x14(%ebp)
  800aec:	8b 45 14             	mov    0x14(%ebp),%eax
  800aef:	83 e8 04             	sub    $0x4,%eax
  800af2:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800af4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800af7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800afe:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b05:	eb 1f                	jmp    800b26 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b07:	83 ec 08             	sub    $0x8,%esp
  800b0a:	ff 75 e8             	pushl  -0x18(%ebp)
  800b0d:	8d 45 14             	lea    0x14(%ebp),%eax
  800b10:	50                   	push   %eax
  800b11:	e8 e7 fb ff ff       	call   8006fd <getuint>
  800b16:	83 c4 10             	add    $0x10,%esp
  800b19:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b1c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b1f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b26:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b2d:	83 ec 04             	sub    $0x4,%esp
  800b30:	52                   	push   %edx
  800b31:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b34:	50                   	push   %eax
  800b35:	ff 75 f4             	pushl  -0xc(%ebp)
  800b38:	ff 75 f0             	pushl  -0x10(%ebp)
  800b3b:	ff 75 0c             	pushl  0xc(%ebp)
  800b3e:	ff 75 08             	pushl  0x8(%ebp)
  800b41:	e8 00 fb ff ff       	call   800646 <printnum>
  800b46:	83 c4 20             	add    $0x20,%esp
			break;
  800b49:	eb 34                	jmp    800b7f <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b4b:	83 ec 08             	sub    $0x8,%esp
  800b4e:	ff 75 0c             	pushl  0xc(%ebp)
  800b51:	53                   	push   %ebx
  800b52:	8b 45 08             	mov    0x8(%ebp),%eax
  800b55:	ff d0                	call   *%eax
  800b57:	83 c4 10             	add    $0x10,%esp
			break;
  800b5a:	eb 23                	jmp    800b7f <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b5c:	83 ec 08             	sub    $0x8,%esp
  800b5f:	ff 75 0c             	pushl  0xc(%ebp)
  800b62:	6a 25                	push   $0x25
  800b64:	8b 45 08             	mov    0x8(%ebp),%eax
  800b67:	ff d0                	call   *%eax
  800b69:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b6c:	ff 4d 10             	decl   0x10(%ebp)
  800b6f:	eb 03                	jmp    800b74 <vprintfmt+0x3b1>
  800b71:	ff 4d 10             	decl   0x10(%ebp)
  800b74:	8b 45 10             	mov    0x10(%ebp),%eax
  800b77:	48                   	dec    %eax
  800b78:	8a 00                	mov    (%eax),%al
  800b7a:	3c 25                	cmp    $0x25,%al
  800b7c:	75 f3                	jne    800b71 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b7e:	90                   	nop
		}
	}
  800b7f:	e9 47 fc ff ff       	jmp    8007cb <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b84:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b85:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b88:	5b                   	pop    %ebx
  800b89:	5e                   	pop    %esi
  800b8a:	5d                   	pop    %ebp
  800b8b:	c3                   	ret    

00800b8c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b8c:	55                   	push   %ebp
  800b8d:	89 e5                	mov    %esp,%ebp
  800b8f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b92:	8d 45 10             	lea    0x10(%ebp),%eax
  800b95:	83 c0 04             	add    $0x4,%eax
  800b98:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b9b:	8b 45 10             	mov    0x10(%ebp),%eax
  800b9e:	ff 75 f4             	pushl  -0xc(%ebp)
  800ba1:	50                   	push   %eax
  800ba2:	ff 75 0c             	pushl  0xc(%ebp)
  800ba5:	ff 75 08             	pushl  0x8(%ebp)
  800ba8:	e8 16 fc ff ff       	call   8007c3 <vprintfmt>
  800bad:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800bb0:	90                   	nop
  800bb1:	c9                   	leave  
  800bb2:	c3                   	ret    

00800bb3 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bb3:	55                   	push   %ebp
  800bb4:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800bb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb9:	8b 40 08             	mov    0x8(%eax),%eax
  800bbc:	8d 50 01             	lea    0x1(%eax),%edx
  800bbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc2:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800bc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc8:	8b 10                	mov    (%eax),%edx
  800bca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bcd:	8b 40 04             	mov    0x4(%eax),%eax
  800bd0:	39 c2                	cmp    %eax,%edx
  800bd2:	73 12                	jae    800be6 <sprintputch+0x33>
		*b->buf++ = ch;
  800bd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd7:	8b 00                	mov    (%eax),%eax
  800bd9:	8d 48 01             	lea    0x1(%eax),%ecx
  800bdc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bdf:	89 0a                	mov    %ecx,(%edx)
  800be1:	8b 55 08             	mov    0x8(%ebp),%edx
  800be4:	88 10                	mov    %dl,(%eax)
}
  800be6:	90                   	nop
  800be7:	5d                   	pop    %ebp
  800be8:	c3                   	ret    

00800be9 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800be9:	55                   	push   %ebp
  800bea:	89 e5                	mov    %esp,%ebp
  800bec:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800bef:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800bf5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfe:	01 d0                	add    %edx,%eax
  800c00:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c03:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c0a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c0e:	74 06                	je     800c16 <vsnprintf+0x2d>
  800c10:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c14:	7f 07                	jg     800c1d <vsnprintf+0x34>
		return -E_INVAL;
  800c16:	b8 03 00 00 00       	mov    $0x3,%eax
  800c1b:	eb 20                	jmp    800c3d <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c1d:	ff 75 14             	pushl  0x14(%ebp)
  800c20:	ff 75 10             	pushl  0x10(%ebp)
  800c23:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c26:	50                   	push   %eax
  800c27:	68 b3 0b 80 00       	push   $0x800bb3
  800c2c:	e8 92 fb ff ff       	call   8007c3 <vprintfmt>
  800c31:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c37:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c3d:	c9                   	leave  
  800c3e:	c3                   	ret    

00800c3f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c3f:	55                   	push   %ebp
  800c40:	89 e5                	mov    %esp,%ebp
  800c42:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c45:	8d 45 10             	lea    0x10(%ebp),%eax
  800c48:	83 c0 04             	add    $0x4,%eax
  800c4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c4e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c51:	ff 75 f4             	pushl  -0xc(%ebp)
  800c54:	50                   	push   %eax
  800c55:	ff 75 0c             	pushl  0xc(%ebp)
  800c58:	ff 75 08             	pushl  0x8(%ebp)
  800c5b:	e8 89 ff ff ff       	call   800be9 <vsnprintf>
  800c60:	83 c4 10             	add    $0x10,%esp
  800c63:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c66:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c69:	c9                   	leave  
  800c6a:	c3                   	ret    

00800c6b <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c6b:	55                   	push   %ebp
  800c6c:	89 e5                	mov    %esp,%ebp
  800c6e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c71:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c78:	eb 06                	jmp    800c80 <strlen+0x15>
		n++;
  800c7a:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c7d:	ff 45 08             	incl   0x8(%ebp)
  800c80:	8b 45 08             	mov    0x8(%ebp),%eax
  800c83:	8a 00                	mov    (%eax),%al
  800c85:	84 c0                	test   %al,%al
  800c87:	75 f1                	jne    800c7a <strlen+0xf>
		n++;
	return n;
  800c89:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c8c:	c9                   	leave  
  800c8d:	c3                   	ret    

00800c8e <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c8e:	55                   	push   %ebp
  800c8f:	89 e5                	mov    %esp,%ebp
  800c91:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c94:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c9b:	eb 09                	jmp    800ca6 <strnlen+0x18>
		n++;
  800c9d:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ca0:	ff 45 08             	incl   0x8(%ebp)
  800ca3:	ff 4d 0c             	decl   0xc(%ebp)
  800ca6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800caa:	74 09                	je     800cb5 <strnlen+0x27>
  800cac:	8b 45 08             	mov    0x8(%ebp),%eax
  800caf:	8a 00                	mov    (%eax),%al
  800cb1:	84 c0                	test   %al,%al
  800cb3:	75 e8                	jne    800c9d <strnlen+0xf>
		n++;
	return n;
  800cb5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cb8:	c9                   	leave  
  800cb9:	c3                   	ret    

00800cba <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cba:	55                   	push   %ebp
  800cbb:	89 e5                	mov    %esp,%ebp
  800cbd:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cc6:	90                   	nop
  800cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cca:	8d 50 01             	lea    0x1(%eax),%edx
  800ccd:	89 55 08             	mov    %edx,0x8(%ebp)
  800cd0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cd3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cd6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cd9:	8a 12                	mov    (%edx),%dl
  800cdb:	88 10                	mov    %dl,(%eax)
  800cdd:	8a 00                	mov    (%eax),%al
  800cdf:	84 c0                	test   %al,%al
  800ce1:	75 e4                	jne    800cc7 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ce3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ce6:	c9                   	leave  
  800ce7:	c3                   	ret    

00800ce8 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ce8:	55                   	push   %ebp
  800ce9:	89 e5                	mov    %esp,%ebp
  800ceb:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800cee:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800cf4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cfb:	eb 1f                	jmp    800d1c <strncpy+0x34>
		*dst++ = *src;
  800cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800d00:	8d 50 01             	lea    0x1(%eax),%edx
  800d03:	89 55 08             	mov    %edx,0x8(%ebp)
  800d06:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d09:	8a 12                	mov    (%edx),%dl
  800d0b:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d10:	8a 00                	mov    (%eax),%al
  800d12:	84 c0                	test   %al,%al
  800d14:	74 03                	je     800d19 <strncpy+0x31>
			src++;
  800d16:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d19:	ff 45 fc             	incl   -0x4(%ebp)
  800d1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d1f:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d22:	72 d9                	jb     800cfd <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d24:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d27:	c9                   	leave  
  800d28:	c3                   	ret    

00800d29 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d29:	55                   	push   %ebp
  800d2a:	89 e5                	mov    %esp,%ebp
  800d2c:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d32:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d35:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d39:	74 30                	je     800d6b <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d3b:	eb 16                	jmp    800d53 <strlcpy+0x2a>
			*dst++ = *src++;
  800d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d40:	8d 50 01             	lea    0x1(%eax),%edx
  800d43:	89 55 08             	mov    %edx,0x8(%ebp)
  800d46:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d49:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d4c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d4f:	8a 12                	mov    (%edx),%dl
  800d51:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d53:	ff 4d 10             	decl   0x10(%ebp)
  800d56:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d5a:	74 09                	je     800d65 <strlcpy+0x3c>
  800d5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5f:	8a 00                	mov    (%eax),%al
  800d61:	84 c0                	test   %al,%al
  800d63:	75 d8                	jne    800d3d <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d65:	8b 45 08             	mov    0x8(%ebp),%eax
  800d68:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d6b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d71:	29 c2                	sub    %eax,%edx
  800d73:	89 d0                	mov    %edx,%eax
}
  800d75:	c9                   	leave  
  800d76:	c3                   	ret    

00800d77 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d77:	55                   	push   %ebp
  800d78:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d7a:	eb 06                	jmp    800d82 <strcmp+0xb>
		p++, q++;
  800d7c:	ff 45 08             	incl   0x8(%ebp)
  800d7f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d82:	8b 45 08             	mov    0x8(%ebp),%eax
  800d85:	8a 00                	mov    (%eax),%al
  800d87:	84 c0                	test   %al,%al
  800d89:	74 0e                	je     800d99 <strcmp+0x22>
  800d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8e:	8a 10                	mov    (%eax),%dl
  800d90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d93:	8a 00                	mov    (%eax),%al
  800d95:	38 c2                	cmp    %al,%dl
  800d97:	74 e3                	je     800d7c <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d99:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9c:	8a 00                	mov    (%eax),%al
  800d9e:	0f b6 d0             	movzbl %al,%edx
  800da1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da4:	8a 00                	mov    (%eax),%al
  800da6:	0f b6 c0             	movzbl %al,%eax
  800da9:	29 c2                	sub    %eax,%edx
  800dab:	89 d0                	mov    %edx,%eax
}
  800dad:	5d                   	pop    %ebp
  800dae:	c3                   	ret    

00800daf <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800daf:	55                   	push   %ebp
  800db0:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800db2:	eb 09                	jmp    800dbd <strncmp+0xe>
		n--, p++, q++;
  800db4:	ff 4d 10             	decl   0x10(%ebp)
  800db7:	ff 45 08             	incl   0x8(%ebp)
  800dba:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800dbd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dc1:	74 17                	je     800dda <strncmp+0x2b>
  800dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc6:	8a 00                	mov    (%eax),%al
  800dc8:	84 c0                	test   %al,%al
  800dca:	74 0e                	je     800dda <strncmp+0x2b>
  800dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcf:	8a 10                	mov    (%eax),%dl
  800dd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd4:	8a 00                	mov    (%eax),%al
  800dd6:	38 c2                	cmp    %al,%dl
  800dd8:	74 da                	je     800db4 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800dda:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dde:	75 07                	jne    800de7 <strncmp+0x38>
		return 0;
  800de0:	b8 00 00 00 00       	mov    $0x0,%eax
  800de5:	eb 14                	jmp    800dfb <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800de7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dea:	8a 00                	mov    (%eax),%al
  800dec:	0f b6 d0             	movzbl %al,%edx
  800def:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df2:	8a 00                	mov    (%eax),%al
  800df4:	0f b6 c0             	movzbl %al,%eax
  800df7:	29 c2                	sub    %eax,%edx
  800df9:	89 d0                	mov    %edx,%eax
}
  800dfb:	5d                   	pop    %ebp
  800dfc:	c3                   	ret    

00800dfd <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800dfd:	55                   	push   %ebp
  800dfe:	89 e5                	mov    %esp,%ebp
  800e00:	83 ec 04             	sub    $0x4,%esp
  800e03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e06:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e09:	eb 12                	jmp    800e1d <strchr+0x20>
		if (*s == c)
  800e0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0e:	8a 00                	mov    (%eax),%al
  800e10:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e13:	75 05                	jne    800e1a <strchr+0x1d>
			return (char *) s;
  800e15:	8b 45 08             	mov    0x8(%ebp),%eax
  800e18:	eb 11                	jmp    800e2b <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e1a:	ff 45 08             	incl   0x8(%ebp)
  800e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e20:	8a 00                	mov    (%eax),%al
  800e22:	84 c0                	test   %al,%al
  800e24:	75 e5                	jne    800e0b <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e26:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e2b:	c9                   	leave  
  800e2c:	c3                   	ret    

00800e2d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e2d:	55                   	push   %ebp
  800e2e:	89 e5                	mov    %esp,%ebp
  800e30:	83 ec 04             	sub    $0x4,%esp
  800e33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e36:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e39:	eb 0d                	jmp    800e48 <strfind+0x1b>
		if (*s == c)
  800e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3e:	8a 00                	mov    (%eax),%al
  800e40:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e43:	74 0e                	je     800e53 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e45:	ff 45 08             	incl   0x8(%ebp)
  800e48:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4b:	8a 00                	mov    (%eax),%al
  800e4d:	84 c0                	test   %al,%al
  800e4f:	75 ea                	jne    800e3b <strfind+0xe>
  800e51:	eb 01                	jmp    800e54 <strfind+0x27>
		if (*s == c)
			break;
  800e53:	90                   	nop
	return (char *) s;
  800e54:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e57:	c9                   	leave  
  800e58:	c3                   	ret    

00800e59 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e59:	55                   	push   %ebp
  800e5a:	89 e5                	mov    %esp,%ebp
  800e5c:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e62:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e65:	8b 45 10             	mov    0x10(%ebp),%eax
  800e68:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e6b:	eb 0e                	jmp    800e7b <memset+0x22>
		*p++ = c;
  800e6d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e70:	8d 50 01             	lea    0x1(%eax),%edx
  800e73:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e76:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e79:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e7b:	ff 4d f8             	decl   -0x8(%ebp)
  800e7e:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e82:	79 e9                	jns    800e6d <memset+0x14>
		*p++ = c;

	return v;
  800e84:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e87:	c9                   	leave  
  800e88:	c3                   	ret    

00800e89 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e89:	55                   	push   %ebp
  800e8a:	89 e5                	mov    %esp,%ebp
  800e8c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e92:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e95:	8b 45 08             	mov    0x8(%ebp),%eax
  800e98:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e9b:	eb 16                	jmp    800eb3 <memcpy+0x2a>
		*d++ = *s++;
  800e9d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea0:	8d 50 01             	lea    0x1(%eax),%edx
  800ea3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ea6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ea9:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eac:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800eaf:	8a 12                	mov    (%edx),%dl
  800eb1:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800eb3:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eb9:	89 55 10             	mov    %edx,0x10(%ebp)
  800ebc:	85 c0                	test   %eax,%eax
  800ebe:	75 dd                	jne    800e9d <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800ec0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ec3:	c9                   	leave  
  800ec4:	c3                   	ret    

00800ec5 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800ec5:	55                   	push   %ebp
  800ec6:	89 e5                	mov    %esp,%ebp
  800ec8:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ecb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ece:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800ed7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eda:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800edd:	73 50                	jae    800f2f <memmove+0x6a>
  800edf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ee2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee5:	01 d0                	add    %edx,%eax
  800ee7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800eea:	76 43                	jbe    800f2f <memmove+0x6a>
		s += n;
  800eec:	8b 45 10             	mov    0x10(%ebp),%eax
  800eef:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800ef2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef5:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ef8:	eb 10                	jmp    800f0a <memmove+0x45>
			*--d = *--s;
  800efa:	ff 4d f8             	decl   -0x8(%ebp)
  800efd:	ff 4d fc             	decl   -0x4(%ebp)
  800f00:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f03:	8a 10                	mov    (%eax),%dl
  800f05:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f08:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f0a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f0d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f10:	89 55 10             	mov    %edx,0x10(%ebp)
  800f13:	85 c0                	test   %eax,%eax
  800f15:	75 e3                	jne    800efa <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f17:	eb 23                	jmp    800f3c <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f19:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f1c:	8d 50 01             	lea    0x1(%eax),%edx
  800f1f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f22:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f25:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f28:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f2b:	8a 12                	mov    (%edx),%dl
  800f2d:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f2f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f32:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f35:	89 55 10             	mov    %edx,0x10(%ebp)
  800f38:	85 c0                	test   %eax,%eax
  800f3a:	75 dd                	jne    800f19 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f3c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f3f:	c9                   	leave  
  800f40:	c3                   	ret    

00800f41 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f41:	55                   	push   %ebp
  800f42:	89 e5                	mov    %esp,%ebp
  800f44:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f47:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f50:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f53:	eb 2a                	jmp    800f7f <memcmp+0x3e>
		if (*s1 != *s2)
  800f55:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f58:	8a 10                	mov    (%eax),%dl
  800f5a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f5d:	8a 00                	mov    (%eax),%al
  800f5f:	38 c2                	cmp    %al,%dl
  800f61:	74 16                	je     800f79 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f63:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f66:	8a 00                	mov    (%eax),%al
  800f68:	0f b6 d0             	movzbl %al,%edx
  800f6b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f6e:	8a 00                	mov    (%eax),%al
  800f70:	0f b6 c0             	movzbl %al,%eax
  800f73:	29 c2                	sub    %eax,%edx
  800f75:	89 d0                	mov    %edx,%eax
  800f77:	eb 18                	jmp    800f91 <memcmp+0x50>
		s1++, s2++;
  800f79:	ff 45 fc             	incl   -0x4(%ebp)
  800f7c:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f7f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f82:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f85:	89 55 10             	mov    %edx,0x10(%ebp)
  800f88:	85 c0                	test   %eax,%eax
  800f8a:	75 c9                	jne    800f55 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f8c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f91:	c9                   	leave  
  800f92:	c3                   	ret    

00800f93 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f93:	55                   	push   %ebp
  800f94:	89 e5                	mov    %esp,%ebp
  800f96:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f99:	8b 55 08             	mov    0x8(%ebp),%edx
  800f9c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f9f:	01 d0                	add    %edx,%eax
  800fa1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800fa4:	eb 15                	jmp    800fbb <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa9:	8a 00                	mov    (%eax),%al
  800fab:	0f b6 d0             	movzbl %al,%edx
  800fae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb1:	0f b6 c0             	movzbl %al,%eax
  800fb4:	39 c2                	cmp    %eax,%edx
  800fb6:	74 0d                	je     800fc5 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800fb8:	ff 45 08             	incl   0x8(%ebp)
  800fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbe:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800fc1:	72 e3                	jb     800fa6 <memfind+0x13>
  800fc3:	eb 01                	jmp    800fc6 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800fc5:	90                   	nop
	return (void *) s;
  800fc6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fc9:	c9                   	leave  
  800fca:	c3                   	ret    

00800fcb <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800fcb:	55                   	push   %ebp
  800fcc:	89 e5                	mov    %esp,%ebp
  800fce:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800fd1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800fd8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fdf:	eb 03                	jmp    800fe4 <strtol+0x19>
		s++;
  800fe1:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe7:	8a 00                	mov    (%eax),%al
  800fe9:	3c 20                	cmp    $0x20,%al
  800feb:	74 f4                	je     800fe1 <strtol+0x16>
  800fed:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff0:	8a 00                	mov    (%eax),%al
  800ff2:	3c 09                	cmp    $0x9,%al
  800ff4:	74 eb                	je     800fe1 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff9:	8a 00                	mov    (%eax),%al
  800ffb:	3c 2b                	cmp    $0x2b,%al
  800ffd:	75 05                	jne    801004 <strtol+0x39>
		s++;
  800fff:	ff 45 08             	incl   0x8(%ebp)
  801002:	eb 13                	jmp    801017 <strtol+0x4c>
	else if (*s == '-')
  801004:	8b 45 08             	mov    0x8(%ebp),%eax
  801007:	8a 00                	mov    (%eax),%al
  801009:	3c 2d                	cmp    $0x2d,%al
  80100b:	75 0a                	jne    801017 <strtol+0x4c>
		s++, neg = 1;
  80100d:	ff 45 08             	incl   0x8(%ebp)
  801010:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801017:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80101b:	74 06                	je     801023 <strtol+0x58>
  80101d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801021:	75 20                	jne    801043 <strtol+0x78>
  801023:	8b 45 08             	mov    0x8(%ebp),%eax
  801026:	8a 00                	mov    (%eax),%al
  801028:	3c 30                	cmp    $0x30,%al
  80102a:	75 17                	jne    801043 <strtol+0x78>
  80102c:	8b 45 08             	mov    0x8(%ebp),%eax
  80102f:	40                   	inc    %eax
  801030:	8a 00                	mov    (%eax),%al
  801032:	3c 78                	cmp    $0x78,%al
  801034:	75 0d                	jne    801043 <strtol+0x78>
		s += 2, base = 16;
  801036:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80103a:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801041:	eb 28                	jmp    80106b <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801043:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801047:	75 15                	jne    80105e <strtol+0x93>
  801049:	8b 45 08             	mov    0x8(%ebp),%eax
  80104c:	8a 00                	mov    (%eax),%al
  80104e:	3c 30                	cmp    $0x30,%al
  801050:	75 0c                	jne    80105e <strtol+0x93>
		s++, base = 8;
  801052:	ff 45 08             	incl   0x8(%ebp)
  801055:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80105c:	eb 0d                	jmp    80106b <strtol+0xa0>
	else if (base == 0)
  80105e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801062:	75 07                	jne    80106b <strtol+0xa0>
		base = 10;
  801064:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80106b:	8b 45 08             	mov    0x8(%ebp),%eax
  80106e:	8a 00                	mov    (%eax),%al
  801070:	3c 2f                	cmp    $0x2f,%al
  801072:	7e 19                	jle    80108d <strtol+0xc2>
  801074:	8b 45 08             	mov    0x8(%ebp),%eax
  801077:	8a 00                	mov    (%eax),%al
  801079:	3c 39                	cmp    $0x39,%al
  80107b:	7f 10                	jg     80108d <strtol+0xc2>
			dig = *s - '0';
  80107d:	8b 45 08             	mov    0x8(%ebp),%eax
  801080:	8a 00                	mov    (%eax),%al
  801082:	0f be c0             	movsbl %al,%eax
  801085:	83 e8 30             	sub    $0x30,%eax
  801088:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80108b:	eb 42                	jmp    8010cf <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80108d:	8b 45 08             	mov    0x8(%ebp),%eax
  801090:	8a 00                	mov    (%eax),%al
  801092:	3c 60                	cmp    $0x60,%al
  801094:	7e 19                	jle    8010af <strtol+0xe4>
  801096:	8b 45 08             	mov    0x8(%ebp),%eax
  801099:	8a 00                	mov    (%eax),%al
  80109b:	3c 7a                	cmp    $0x7a,%al
  80109d:	7f 10                	jg     8010af <strtol+0xe4>
			dig = *s - 'a' + 10;
  80109f:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a2:	8a 00                	mov    (%eax),%al
  8010a4:	0f be c0             	movsbl %al,%eax
  8010a7:	83 e8 57             	sub    $0x57,%eax
  8010aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010ad:	eb 20                	jmp    8010cf <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010af:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b2:	8a 00                	mov    (%eax),%al
  8010b4:	3c 40                	cmp    $0x40,%al
  8010b6:	7e 39                	jle    8010f1 <strtol+0x126>
  8010b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bb:	8a 00                	mov    (%eax),%al
  8010bd:	3c 5a                	cmp    $0x5a,%al
  8010bf:	7f 30                	jg     8010f1 <strtol+0x126>
			dig = *s - 'A' + 10;
  8010c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c4:	8a 00                	mov    (%eax),%al
  8010c6:	0f be c0             	movsbl %al,%eax
  8010c9:	83 e8 37             	sub    $0x37,%eax
  8010cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8010cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010d2:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010d5:	7d 19                	jge    8010f0 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8010d7:	ff 45 08             	incl   0x8(%ebp)
  8010da:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010dd:	0f af 45 10          	imul   0x10(%ebp),%eax
  8010e1:	89 c2                	mov    %eax,%edx
  8010e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010e6:	01 d0                	add    %edx,%eax
  8010e8:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8010eb:	e9 7b ff ff ff       	jmp    80106b <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8010f0:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010f1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010f5:	74 08                	je     8010ff <strtol+0x134>
		*endptr = (char *) s;
  8010f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8010fd:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8010ff:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801103:	74 07                	je     80110c <strtol+0x141>
  801105:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801108:	f7 d8                	neg    %eax
  80110a:	eb 03                	jmp    80110f <strtol+0x144>
  80110c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80110f:	c9                   	leave  
  801110:	c3                   	ret    

00801111 <ltostr>:

void
ltostr(long value, char *str)
{
  801111:	55                   	push   %ebp
  801112:	89 e5                	mov    %esp,%ebp
  801114:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801117:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80111e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801125:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801129:	79 13                	jns    80113e <ltostr+0x2d>
	{
		neg = 1;
  80112b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801132:	8b 45 0c             	mov    0xc(%ebp),%eax
  801135:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801138:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80113b:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80113e:	8b 45 08             	mov    0x8(%ebp),%eax
  801141:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801146:	99                   	cltd   
  801147:	f7 f9                	idiv   %ecx
  801149:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80114c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80114f:	8d 50 01             	lea    0x1(%eax),%edx
  801152:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801155:	89 c2                	mov    %eax,%edx
  801157:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115a:	01 d0                	add    %edx,%eax
  80115c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80115f:	83 c2 30             	add    $0x30,%edx
  801162:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801164:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801167:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80116c:	f7 e9                	imul   %ecx
  80116e:	c1 fa 02             	sar    $0x2,%edx
  801171:	89 c8                	mov    %ecx,%eax
  801173:	c1 f8 1f             	sar    $0x1f,%eax
  801176:	29 c2                	sub    %eax,%edx
  801178:	89 d0                	mov    %edx,%eax
  80117a:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80117d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801180:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801185:	f7 e9                	imul   %ecx
  801187:	c1 fa 02             	sar    $0x2,%edx
  80118a:	89 c8                	mov    %ecx,%eax
  80118c:	c1 f8 1f             	sar    $0x1f,%eax
  80118f:	29 c2                	sub    %eax,%edx
  801191:	89 d0                	mov    %edx,%eax
  801193:	c1 e0 02             	shl    $0x2,%eax
  801196:	01 d0                	add    %edx,%eax
  801198:	01 c0                	add    %eax,%eax
  80119a:	29 c1                	sub    %eax,%ecx
  80119c:	89 ca                	mov    %ecx,%edx
  80119e:	85 d2                	test   %edx,%edx
  8011a0:	75 9c                	jne    80113e <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8011a2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8011a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ac:	48                   	dec    %eax
  8011ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8011b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011b4:	74 3d                	je     8011f3 <ltostr+0xe2>
		start = 1 ;
  8011b6:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8011bd:	eb 34                	jmp    8011f3 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8011bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c5:	01 d0                	add    %edx,%eax
  8011c7:	8a 00                	mov    (%eax),%al
  8011c9:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8011cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d2:	01 c2                	add    %eax,%edx
  8011d4:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8011d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011da:	01 c8                	add    %ecx,%eax
  8011dc:	8a 00                	mov    (%eax),%al
  8011de:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8011e0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e6:	01 c2                	add    %eax,%edx
  8011e8:	8a 45 eb             	mov    -0x15(%ebp),%al
  8011eb:	88 02                	mov    %al,(%edx)
		start++ ;
  8011ed:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8011f0:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8011f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011f6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011f9:	7c c4                	jl     8011bf <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8011fb:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8011fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801201:	01 d0                	add    %edx,%eax
  801203:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801206:	90                   	nop
  801207:	c9                   	leave  
  801208:	c3                   	ret    

00801209 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801209:	55                   	push   %ebp
  80120a:	89 e5                	mov    %esp,%ebp
  80120c:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80120f:	ff 75 08             	pushl  0x8(%ebp)
  801212:	e8 54 fa ff ff       	call   800c6b <strlen>
  801217:	83 c4 04             	add    $0x4,%esp
  80121a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80121d:	ff 75 0c             	pushl  0xc(%ebp)
  801220:	e8 46 fa ff ff       	call   800c6b <strlen>
  801225:	83 c4 04             	add    $0x4,%esp
  801228:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80122b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801232:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801239:	eb 17                	jmp    801252 <strcconcat+0x49>
		final[s] = str1[s] ;
  80123b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80123e:	8b 45 10             	mov    0x10(%ebp),%eax
  801241:	01 c2                	add    %eax,%edx
  801243:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801246:	8b 45 08             	mov    0x8(%ebp),%eax
  801249:	01 c8                	add    %ecx,%eax
  80124b:	8a 00                	mov    (%eax),%al
  80124d:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80124f:	ff 45 fc             	incl   -0x4(%ebp)
  801252:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801255:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801258:	7c e1                	jl     80123b <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80125a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801261:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801268:	eb 1f                	jmp    801289 <strcconcat+0x80>
		final[s++] = str2[i] ;
  80126a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80126d:	8d 50 01             	lea    0x1(%eax),%edx
  801270:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801273:	89 c2                	mov    %eax,%edx
  801275:	8b 45 10             	mov    0x10(%ebp),%eax
  801278:	01 c2                	add    %eax,%edx
  80127a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80127d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801280:	01 c8                	add    %ecx,%eax
  801282:	8a 00                	mov    (%eax),%al
  801284:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801286:	ff 45 f8             	incl   -0x8(%ebp)
  801289:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80128c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80128f:	7c d9                	jl     80126a <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801291:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801294:	8b 45 10             	mov    0x10(%ebp),%eax
  801297:	01 d0                	add    %edx,%eax
  801299:	c6 00 00             	movb   $0x0,(%eax)
}
  80129c:	90                   	nop
  80129d:	c9                   	leave  
  80129e:	c3                   	ret    

0080129f <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80129f:	55                   	push   %ebp
  8012a0:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8012a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8012a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8012ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ae:	8b 00                	mov    (%eax),%eax
  8012b0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ba:	01 d0                	add    %edx,%eax
  8012bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012c2:	eb 0c                	jmp    8012d0 <strsplit+0x31>
			*string++ = 0;
  8012c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c7:	8d 50 01             	lea    0x1(%eax),%edx
  8012ca:	89 55 08             	mov    %edx,0x8(%ebp)
  8012cd:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d3:	8a 00                	mov    (%eax),%al
  8012d5:	84 c0                	test   %al,%al
  8012d7:	74 18                	je     8012f1 <strsplit+0x52>
  8012d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012dc:	8a 00                	mov    (%eax),%al
  8012de:	0f be c0             	movsbl %al,%eax
  8012e1:	50                   	push   %eax
  8012e2:	ff 75 0c             	pushl  0xc(%ebp)
  8012e5:	e8 13 fb ff ff       	call   800dfd <strchr>
  8012ea:	83 c4 08             	add    $0x8,%esp
  8012ed:	85 c0                	test   %eax,%eax
  8012ef:	75 d3                	jne    8012c4 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8012f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f4:	8a 00                	mov    (%eax),%al
  8012f6:	84 c0                	test   %al,%al
  8012f8:	74 5a                	je     801354 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8012fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8012fd:	8b 00                	mov    (%eax),%eax
  8012ff:	83 f8 0f             	cmp    $0xf,%eax
  801302:	75 07                	jne    80130b <strsplit+0x6c>
		{
			return 0;
  801304:	b8 00 00 00 00       	mov    $0x0,%eax
  801309:	eb 66                	jmp    801371 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80130b:	8b 45 14             	mov    0x14(%ebp),%eax
  80130e:	8b 00                	mov    (%eax),%eax
  801310:	8d 48 01             	lea    0x1(%eax),%ecx
  801313:	8b 55 14             	mov    0x14(%ebp),%edx
  801316:	89 0a                	mov    %ecx,(%edx)
  801318:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80131f:	8b 45 10             	mov    0x10(%ebp),%eax
  801322:	01 c2                	add    %eax,%edx
  801324:	8b 45 08             	mov    0x8(%ebp),%eax
  801327:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801329:	eb 03                	jmp    80132e <strsplit+0x8f>
			string++;
  80132b:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80132e:	8b 45 08             	mov    0x8(%ebp),%eax
  801331:	8a 00                	mov    (%eax),%al
  801333:	84 c0                	test   %al,%al
  801335:	74 8b                	je     8012c2 <strsplit+0x23>
  801337:	8b 45 08             	mov    0x8(%ebp),%eax
  80133a:	8a 00                	mov    (%eax),%al
  80133c:	0f be c0             	movsbl %al,%eax
  80133f:	50                   	push   %eax
  801340:	ff 75 0c             	pushl  0xc(%ebp)
  801343:	e8 b5 fa ff ff       	call   800dfd <strchr>
  801348:	83 c4 08             	add    $0x8,%esp
  80134b:	85 c0                	test   %eax,%eax
  80134d:	74 dc                	je     80132b <strsplit+0x8c>
			string++;
	}
  80134f:	e9 6e ff ff ff       	jmp    8012c2 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801354:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801355:	8b 45 14             	mov    0x14(%ebp),%eax
  801358:	8b 00                	mov    (%eax),%eax
  80135a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801361:	8b 45 10             	mov    0x10(%ebp),%eax
  801364:	01 d0                	add    %edx,%eax
  801366:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80136c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801371:	c9                   	leave  
  801372:	c3                   	ret    

00801373 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801373:	55                   	push   %ebp
  801374:	89 e5                	mov    %esp,%ebp
  801376:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801379:	a1 04 40 80 00       	mov    0x804004,%eax
  80137e:	85 c0                	test   %eax,%eax
  801380:	74 1f                	je     8013a1 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801382:	e8 1d 00 00 00       	call   8013a4 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801387:	83 ec 0c             	sub    $0xc,%esp
  80138a:	68 30 3a 80 00       	push   $0x803a30
  80138f:	e8 55 f2 ff ff       	call   8005e9 <cprintf>
  801394:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801397:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  80139e:	00 00 00 
	}
}
  8013a1:	90                   	nop
  8013a2:	c9                   	leave  
  8013a3:	c3                   	ret    

008013a4 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8013a4:	55                   	push   %ebp
  8013a5:	89 e5                	mov    %esp,%ebp
  8013a7:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  8013aa:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  8013b1:	00 00 00 
  8013b4:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  8013bb:	00 00 00 
  8013be:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  8013c5:	00 00 00 
		LIST_INIT(&AllocMemBlocksList);
  8013c8:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  8013cf:	00 00 00 
  8013d2:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  8013d9:	00 00 00 
  8013dc:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  8013e3:	00 00 00 

		MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES ;
  8013e6:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  8013ed:	00 02 00 
		MemBlockNodes =(struct MemBlock*)USER_DYN_BLKS_ARRAY ;
  8013f0:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  8013f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013fa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013ff:	2d 00 10 00 00       	sub    $0x1000,%eax
  801404:	a3 50 40 80 00       	mov    %eax,0x804050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock),PAGE_SIZE),PERM_USER|PERM_WRITEABLE);
  801409:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801410:	a1 20 41 80 00       	mov    0x804120,%eax
  801415:	c1 e0 04             	shl    $0x4,%eax
  801418:	89 c2                	mov    %eax,%edx
  80141a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80141d:	01 d0                	add    %edx,%eax
  80141f:	48                   	dec    %eax
  801420:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801423:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801426:	ba 00 00 00 00       	mov    $0x0,%edx
  80142b:	f7 75 f0             	divl   -0x10(%ebp)
  80142e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801431:	29 d0                	sub    %edx,%eax
  801433:	89 c2                	mov    %eax,%edx
  801435:	c7 45 e8 00 00 e0 7f 	movl   $0x7fe00000,-0x18(%ebp)
  80143c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80143f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801444:	2d 00 10 00 00       	sub    $0x1000,%eax
  801449:	83 ec 04             	sub    $0x4,%esp
  80144c:	6a 06                	push   $0x6
  80144e:	52                   	push   %edx
  80144f:	50                   	push   %eax
  801450:	e8 71 05 00 00       	call   8019c6 <sys_allocate_chunk>
  801455:	83 c4 10             	add    $0x10,%esp
		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801458:	a1 20 41 80 00       	mov    0x804120,%eax
  80145d:	83 ec 0c             	sub    $0xc,%esp
  801460:	50                   	push   %eax
  801461:	e8 e6 0b 00 00       	call   80204c <initialize_MemBlocksList>
  801466:	83 c4 10             	add    $0x10,%esp

		struct MemBlock  *block_node;
		block_node = AvailableMemBlocksList.lh_first;
  801469:	a1 48 41 80 00       	mov    0x804148,%eax
  80146e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&(AvailableMemBlocksList),block_node);
  801471:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801475:	75 14                	jne    80148b <initialize_dyn_block_system+0xe7>
  801477:	83 ec 04             	sub    $0x4,%esp
  80147a:	68 55 3a 80 00       	push   $0x803a55
  80147f:	6a 2b                	push   $0x2b
  801481:	68 73 3a 80 00       	push   $0x803a73
  801486:	e8 aa ee ff ff       	call   800335 <_panic>
  80148b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80148e:	8b 00                	mov    (%eax),%eax
  801490:	85 c0                	test   %eax,%eax
  801492:	74 10                	je     8014a4 <initialize_dyn_block_system+0x100>
  801494:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801497:	8b 00                	mov    (%eax),%eax
  801499:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80149c:	8b 52 04             	mov    0x4(%edx),%edx
  80149f:	89 50 04             	mov    %edx,0x4(%eax)
  8014a2:	eb 0b                	jmp    8014af <initialize_dyn_block_system+0x10b>
  8014a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014a7:	8b 40 04             	mov    0x4(%eax),%eax
  8014aa:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8014af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014b2:	8b 40 04             	mov    0x4(%eax),%eax
  8014b5:	85 c0                	test   %eax,%eax
  8014b7:	74 0f                	je     8014c8 <initialize_dyn_block_system+0x124>
  8014b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014bc:	8b 40 04             	mov    0x4(%eax),%eax
  8014bf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8014c2:	8b 12                	mov    (%edx),%edx
  8014c4:	89 10                	mov    %edx,(%eax)
  8014c6:	eb 0a                	jmp    8014d2 <initialize_dyn_block_system+0x12e>
  8014c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014cb:	8b 00                	mov    (%eax),%eax
  8014cd:	a3 48 41 80 00       	mov    %eax,0x804148
  8014d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014d5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8014db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014de:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8014e5:	a1 54 41 80 00       	mov    0x804154,%eax
  8014ea:	48                   	dec    %eax
  8014eb:	a3 54 41 80 00       	mov    %eax,0x804154
		block_node->sva = USER_HEAP_START ;
  8014f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014f3:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
		block_node->size = ((USER_HEAP_MAX - USER_HEAP_START));
  8014fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014fd:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		insert_sorted_with_merge_freeList(block_node);
  801504:	83 ec 0c             	sub    $0xc,%esp
  801507:	ff 75 e4             	pushl  -0x1c(%ebp)
  80150a:	e8 d2 13 00 00       	call   8028e1 <insert_sorted_with_merge_freeList>
  80150f:	83 c4 10             	add    $0x10,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801512:	90                   	nop
  801513:	c9                   	leave  
  801514:	c3                   	ret    

00801515 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801515:	55                   	push   %ebp
  801516:	89 e5                	mov    %esp,%ebp
  801518:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80151b:	e8 53 fe ff ff       	call   801373 <InitializeUHeap>
	if (size == 0) return NULL ;
  801520:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801524:	75 07                	jne    80152d <malloc+0x18>
  801526:	b8 00 00 00 00       	mov    $0x0,%eax
  80152b:	eb 61                	jmp    80158e <malloc+0x79>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	size= ROUNDUP(size,PAGE_SIZE);
  80152d:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801534:	8b 55 08             	mov    0x8(%ebp),%edx
  801537:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80153a:	01 d0                	add    %edx,%eax
  80153c:	48                   	dec    %eax
  80153d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801540:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801543:	ba 00 00 00 00       	mov    $0x0,%edx
  801548:	f7 75 f4             	divl   -0xc(%ebp)
  80154b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80154e:	29 d0                	sub    %edx,%eax
  801550:	89 45 08             	mov    %eax,0x8(%ebp)
	    			if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801553:	e8 3c 08 00 00       	call   801d94 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801558:	85 c0                	test   %eax,%eax
  80155a:	74 2d                	je     801589 <malloc+0x74>
	    			{
	    				struct MemBlock * ff_block = alloc_block_FF(size);
  80155c:	83 ec 0c             	sub    $0xc,%esp
  80155f:	ff 75 08             	pushl  0x8(%ebp)
  801562:	e8 3e 0f 00 00       	call   8024a5 <alloc_block_FF>
  801567:	83 c4 10             	add    $0x10,%esp
  80156a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    				if(ff_block!=NULL)
  80156d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801571:	74 16                	je     801589 <malloc+0x74>
	    				{

	    					insert_sorted_allocList(ff_block);
  801573:	83 ec 0c             	sub    $0xc,%esp
  801576:	ff 75 ec             	pushl  -0x14(%ebp)
  801579:	e8 48 0c 00 00       	call   8021c6 <insert_sorted_allocList>
  80157e:	83 c4 10             	add    $0x10,%esp
	    					return (void*) ff_block->sva ;
  801581:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801584:	8b 40 08             	mov    0x8(%eax),%eax
  801587:	eb 05                	jmp    80158e <malloc+0x79>

	    				}
	}
	    			return (void*) NULL ;
  801589:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  80158e:	c9                   	leave  
  80158f:	c3                   	ret    

00801590 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801590:	55                   	push   %ebp
  801591:	89 e5                	mov    %esp,%ebp
  801593:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock *elementForEach;
		virtual_address = ROUNDDOWN(virtual_address, PAGE_SIZE);
  801596:	8b 45 08             	mov    0x8(%ebp),%eax
  801599:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80159c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80159f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015a4:	89 45 08             	mov    %eax,0x8(%ebp)
	//	if (is_mallocPages[indexindex((uint32) virtual_address)] == 1) {
		elementForEach = find_block(&AllocMemBlocksList,(uint32)virtual_address);
  8015a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015aa:	83 ec 08             	sub    $0x8,%esp
  8015ad:	50                   	push   %eax
  8015ae:	68 40 40 80 00       	push   $0x804040
  8015b3:	e8 71 0b 00 00       	call   802129 <find_block>
  8015b8:	83 c4 10             	add    $0x10,%esp
  8015bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
		sys_free_user_mem((uint32) virtual_address, elementForEach->size);
  8015be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015c1:	8b 50 0c             	mov    0xc(%eax),%edx
  8015c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c7:	83 ec 08             	sub    $0x8,%esp
  8015ca:	52                   	push   %edx
  8015cb:	50                   	push   %eax
  8015cc:	e8 bd 03 00 00       	call   80198e <sys_free_user_mem>
  8015d1:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,elementForEach);
  8015d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8015d8:	75 14                	jne    8015ee <free+0x5e>
  8015da:	83 ec 04             	sub    $0x4,%esp
  8015dd:	68 55 3a 80 00       	push   $0x803a55
  8015e2:	6a 71                	push   $0x71
  8015e4:	68 73 3a 80 00       	push   $0x803a73
  8015e9:	e8 47 ed ff ff       	call   800335 <_panic>
  8015ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015f1:	8b 00                	mov    (%eax),%eax
  8015f3:	85 c0                	test   %eax,%eax
  8015f5:	74 10                	je     801607 <free+0x77>
  8015f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015fa:	8b 00                	mov    (%eax),%eax
  8015fc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015ff:	8b 52 04             	mov    0x4(%edx),%edx
  801602:	89 50 04             	mov    %edx,0x4(%eax)
  801605:	eb 0b                	jmp    801612 <free+0x82>
  801607:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80160a:	8b 40 04             	mov    0x4(%eax),%eax
  80160d:	a3 44 40 80 00       	mov    %eax,0x804044
  801612:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801615:	8b 40 04             	mov    0x4(%eax),%eax
  801618:	85 c0                	test   %eax,%eax
  80161a:	74 0f                	je     80162b <free+0x9b>
  80161c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80161f:	8b 40 04             	mov    0x4(%eax),%eax
  801622:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801625:	8b 12                	mov    (%edx),%edx
  801627:	89 10                	mov    %edx,(%eax)
  801629:	eb 0a                	jmp    801635 <free+0xa5>
  80162b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80162e:	8b 00                	mov    (%eax),%eax
  801630:	a3 40 40 80 00       	mov    %eax,0x804040
  801635:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801638:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80163e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801641:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801648:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80164d:	48                   	dec    %eax
  80164e:	a3 4c 40 80 00       	mov    %eax,0x80404c
		insert_sorted_with_merge_freeList(elementForEach);
  801653:	83 ec 0c             	sub    $0xc,%esp
  801656:	ff 75 f0             	pushl  -0x10(%ebp)
  801659:	e8 83 12 00 00       	call   8028e1 <insert_sorted_with_merge_freeList>
  80165e:	83 c4 10             	add    $0x10,%esp
	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801661:	90                   	nop
  801662:	c9                   	leave  
  801663:	c3                   	ret    

00801664 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801664:	55                   	push   %ebp
  801665:	89 e5                	mov    %esp,%ebp
  801667:	83 ec 28             	sub    $0x28,%esp
  80166a:	8b 45 10             	mov    0x10(%ebp),%eax
  80166d:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801670:	e8 fe fc ff ff       	call   801373 <InitializeUHeap>
	if (size == 0) return NULL ;
  801675:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801679:	75 0a                	jne    801685 <smalloc+0x21>
  80167b:	b8 00 00 00 00       	mov    $0x0,%eax
  801680:	e9 86 00 00 00       	jmp    80170b <smalloc+0xa7>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code

	size=ROUNDUP(size,PAGE_SIZE);
  801685:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80168c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80168f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801692:	01 d0                	add    %edx,%eax
  801694:	48                   	dec    %eax
  801695:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801698:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80169b:	ba 00 00 00 00       	mov    $0x0,%edx
  8016a0:	f7 75 f4             	divl   -0xc(%ebp)
  8016a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016a6:	29 d0                	sub    %edx,%eax
  8016a8:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8016ab:	e8 e4 06 00 00       	call   801d94 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016b0:	85 c0                	test   %eax,%eax
  8016b2:	74 52                	je     801706 <smalloc+0xa2>
		{
		struct MemBlock * ff_block ;
		ff_block = alloc_block_FF(size);
  8016b4:	83 ec 0c             	sub    $0xc,%esp
  8016b7:	ff 75 0c             	pushl  0xc(%ebp)
  8016ba:	e8 e6 0d 00 00       	call   8024a5 <alloc_block_FF>
  8016bf:	83 c4 10             	add    $0x10,%esp
  8016c2:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(ff_block==NULL)
  8016c5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8016c9:	75 07                	jne    8016d2 <smalloc+0x6e>
			return NULL ;
  8016cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8016d0:	eb 39                	jmp    80170b <smalloc+0xa7>

		int obj_id =sys_createSharedObject(sharedVarName,size,isWritable,(void*)ff_block->sva);
  8016d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016d5:	8b 40 08             	mov    0x8(%eax),%eax
  8016d8:	89 c2                	mov    %eax,%edx
  8016da:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8016de:	52                   	push   %edx
  8016df:	50                   	push   %eax
  8016e0:	ff 75 0c             	pushl  0xc(%ebp)
  8016e3:	ff 75 08             	pushl  0x8(%ebp)
  8016e6:	e8 2e 04 00 00       	call   801b19 <sys_createSharedObject>
  8016eb:	83 c4 10             	add    $0x10,%esp
  8016ee:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(obj_id < 0)
  8016f1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8016f5:	79 07                	jns    8016fe <smalloc+0x9a>
			return (void*)NULL ;
  8016f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8016fc:	eb 0d                	jmp    80170b <smalloc+0xa7>
		else
		    return (void*)ff_block->sva ;
  8016fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801701:	8b 40 08             	mov    0x8(%eax),%eax
  801704:	eb 05                	jmp    80170b <smalloc+0xa7>
		}
		return (void*)NULL ;
  801706:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80170b:	c9                   	leave  
  80170c:	c3                   	ret    

0080170d <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80170d:	55                   	push   %ebp
  80170e:	89 e5                	mov    %esp,%ebp
  801710:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801713:	e8 5b fc ff ff       	call   801373 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801718:	83 ec 08             	sub    $0x8,%esp
  80171b:	ff 75 0c             	pushl  0xc(%ebp)
  80171e:	ff 75 08             	pushl  0x8(%ebp)
  801721:	e8 1d 04 00 00       	call   801b43 <sys_getSizeOfSharedObject>
  801726:	83 c4 10             	add    $0x10,%esp
  801729:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(size == 0)
  80172c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801730:	75 0a                	jne    80173c <sget+0x2f>
			return NULL ;
  801732:	b8 00 00 00 00       	mov    $0x0,%eax
  801737:	e9 83 00 00 00       	jmp    8017bf <sget+0xb2>
		size=ROUNDUP(size,PAGE_SIZE);
  80173c:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801743:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801746:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801749:	01 d0                	add    %edx,%eax
  80174b:	48                   	dec    %eax
  80174c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80174f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801752:	ba 00 00 00 00       	mov    $0x0,%edx
  801757:	f7 75 f0             	divl   -0x10(%ebp)
  80175a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80175d:	29 d0                	sub    %edx,%eax
  80175f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801762:	e8 2d 06 00 00       	call   801d94 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801767:	85 c0                	test   %eax,%eax
  801769:	74 4f                	je     8017ba <sget+0xad>
		{
			struct MemBlock * ff_block ;
				ff_block = alloc_block_FF(size);
  80176b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80176e:	83 ec 0c             	sub    $0xc,%esp
  801771:	50                   	push   %eax
  801772:	e8 2e 0d 00 00       	call   8024a5 <alloc_block_FF>
  801777:	83 c4 10             	add    $0x10,%esp
  80177a:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ff_block==NULL)
  80177d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801781:	75 07                	jne    80178a <sget+0x7d>
					return (void*)NULL ;
  801783:	b8 00 00 00 00       	mov    $0x0,%eax
  801788:	eb 35                	jmp    8017bf <sget+0xb2>

		int obj_id =sys_getSharedObject((int)ownerEnvID,sharedVarName,(void*)ff_block->sva);
  80178a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80178d:	8b 40 08             	mov    0x8(%eax),%eax
  801790:	83 ec 04             	sub    $0x4,%esp
  801793:	50                   	push   %eax
  801794:	ff 75 0c             	pushl  0xc(%ebp)
  801797:	ff 75 08             	pushl  0x8(%ebp)
  80179a:	e8 c1 03 00 00       	call   801b60 <sys_getSharedObject>
  80179f:	83 c4 10             	add    $0x10,%esp
  8017a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if(obj_id<0)
  8017a5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8017a9:	79 07                	jns    8017b2 <sget+0xa5>
				return (void*)NULL ;
  8017ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8017b0:	eb 0d                	jmp    8017bf <sget+0xb2>
			else
				return (void*)ff_block->sva ;
  8017b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017b5:	8b 40 08             	mov    0x8(%eax),%eax
  8017b8:	eb 05                	jmp    8017bf <sget+0xb2>


		}
	return (void*)NULL ;
  8017ba:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8017bf:	c9                   	leave  
  8017c0:	c3                   	ret    

008017c1 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8017c1:	55                   	push   %ebp
  8017c2:	89 e5                	mov    %esp,%ebp
  8017c4:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017c7:	e8 a7 fb ff ff       	call   801373 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8017cc:	83 ec 04             	sub    $0x4,%esp
  8017cf:	68 80 3a 80 00       	push   $0x803a80
  8017d4:	68 f9 00 00 00       	push   $0xf9
  8017d9:	68 73 3a 80 00       	push   $0x803a73
  8017de:	e8 52 eb ff ff       	call   800335 <_panic>

008017e3 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8017e3:	55                   	push   %ebp
  8017e4:	89 e5                	mov    %esp,%ebp
  8017e6:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8017e9:	83 ec 04             	sub    $0x4,%esp
  8017ec:	68 a8 3a 80 00       	push   $0x803aa8
  8017f1:	68 0d 01 00 00       	push   $0x10d
  8017f6:	68 73 3a 80 00       	push   $0x803a73
  8017fb:	e8 35 eb ff ff       	call   800335 <_panic>

00801800 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801800:	55                   	push   %ebp
  801801:	89 e5                	mov    %esp,%ebp
  801803:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801806:	83 ec 04             	sub    $0x4,%esp
  801809:	68 cc 3a 80 00       	push   $0x803acc
  80180e:	68 18 01 00 00       	push   $0x118
  801813:	68 73 3a 80 00       	push   $0x803a73
  801818:	e8 18 eb ff ff       	call   800335 <_panic>

0080181d <shrink>:

}
void shrink(uint32 newSize)
{
  80181d:	55                   	push   %ebp
  80181e:	89 e5                	mov    %esp,%ebp
  801820:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801823:	83 ec 04             	sub    $0x4,%esp
  801826:	68 cc 3a 80 00       	push   $0x803acc
  80182b:	68 1d 01 00 00       	push   $0x11d
  801830:	68 73 3a 80 00       	push   $0x803a73
  801835:	e8 fb ea ff ff       	call   800335 <_panic>

0080183a <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80183a:	55                   	push   %ebp
  80183b:	89 e5                	mov    %esp,%ebp
  80183d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801840:	83 ec 04             	sub    $0x4,%esp
  801843:	68 cc 3a 80 00       	push   $0x803acc
  801848:	68 22 01 00 00       	push   $0x122
  80184d:	68 73 3a 80 00       	push   $0x803a73
  801852:	e8 de ea ff ff       	call   800335 <_panic>

00801857 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801857:	55                   	push   %ebp
  801858:	89 e5                	mov    %esp,%ebp
  80185a:	57                   	push   %edi
  80185b:	56                   	push   %esi
  80185c:	53                   	push   %ebx
  80185d:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801860:	8b 45 08             	mov    0x8(%ebp),%eax
  801863:	8b 55 0c             	mov    0xc(%ebp),%edx
  801866:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801869:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80186c:	8b 7d 18             	mov    0x18(%ebp),%edi
  80186f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801872:	cd 30                	int    $0x30
  801874:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801877:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80187a:	83 c4 10             	add    $0x10,%esp
  80187d:	5b                   	pop    %ebx
  80187e:	5e                   	pop    %esi
  80187f:	5f                   	pop    %edi
  801880:	5d                   	pop    %ebp
  801881:	c3                   	ret    

00801882 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801882:	55                   	push   %ebp
  801883:	89 e5                	mov    %esp,%ebp
  801885:	83 ec 04             	sub    $0x4,%esp
  801888:	8b 45 10             	mov    0x10(%ebp),%eax
  80188b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80188e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801892:	8b 45 08             	mov    0x8(%ebp),%eax
  801895:	6a 00                	push   $0x0
  801897:	6a 00                	push   $0x0
  801899:	52                   	push   %edx
  80189a:	ff 75 0c             	pushl  0xc(%ebp)
  80189d:	50                   	push   %eax
  80189e:	6a 00                	push   $0x0
  8018a0:	e8 b2 ff ff ff       	call   801857 <syscall>
  8018a5:	83 c4 18             	add    $0x18,%esp
}
  8018a8:	90                   	nop
  8018a9:	c9                   	leave  
  8018aa:	c3                   	ret    

008018ab <sys_cgetc>:

int
sys_cgetc(void)
{
  8018ab:	55                   	push   %ebp
  8018ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 00                	push   $0x0
  8018b4:	6a 00                	push   $0x0
  8018b6:	6a 00                	push   $0x0
  8018b8:	6a 01                	push   $0x1
  8018ba:	e8 98 ff ff ff       	call   801857 <syscall>
  8018bf:	83 c4 18             	add    $0x18,%esp
}
  8018c2:	c9                   	leave  
  8018c3:	c3                   	ret    

008018c4 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018c4:	55                   	push   %ebp
  8018c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cd:	6a 00                	push   $0x0
  8018cf:	6a 00                	push   $0x0
  8018d1:	6a 00                	push   $0x0
  8018d3:	52                   	push   %edx
  8018d4:	50                   	push   %eax
  8018d5:	6a 05                	push   $0x5
  8018d7:	e8 7b ff ff ff       	call   801857 <syscall>
  8018dc:	83 c4 18             	add    $0x18,%esp
}
  8018df:	c9                   	leave  
  8018e0:	c3                   	ret    

008018e1 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018e1:	55                   	push   %ebp
  8018e2:	89 e5                	mov    %esp,%ebp
  8018e4:	56                   	push   %esi
  8018e5:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018e6:	8b 75 18             	mov    0x18(%ebp),%esi
  8018e9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018ec:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f5:	56                   	push   %esi
  8018f6:	53                   	push   %ebx
  8018f7:	51                   	push   %ecx
  8018f8:	52                   	push   %edx
  8018f9:	50                   	push   %eax
  8018fa:	6a 06                	push   $0x6
  8018fc:	e8 56 ff ff ff       	call   801857 <syscall>
  801901:	83 c4 18             	add    $0x18,%esp
}
  801904:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801907:	5b                   	pop    %ebx
  801908:	5e                   	pop    %esi
  801909:	5d                   	pop    %ebp
  80190a:	c3                   	ret    

0080190b <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80190b:	55                   	push   %ebp
  80190c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80190e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801911:	8b 45 08             	mov    0x8(%ebp),%eax
  801914:	6a 00                	push   $0x0
  801916:	6a 00                	push   $0x0
  801918:	6a 00                	push   $0x0
  80191a:	52                   	push   %edx
  80191b:	50                   	push   %eax
  80191c:	6a 07                	push   $0x7
  80191e:	e8 34 ff ff ff       	call   801857 <syscall>
  801923:	83 c4 18             	add    $0x18,%esp
}
  801926:	c9                   	leave  
  801927:	c3                   	ret    

00801928 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801928:	55                   	push   %ebp
  801929:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	ff 75 0c             	pushl  0xc(%ebp)
  801934:	ff 75 08             	pushl  0x8(%ebp)
  801937:	6a 08                	push   $0x8
  801939:	e8 19 ff ff ff       	call   801857 <syscall>
  80193e:	83 c4 18             	add    $0x18,%esp
}
  801941:	c9                   	leave  
  801942:	c3                   	ret    

00801943 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801943:	55                   	push   %ebp
  801944:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801946:	6a 00                	push   $0x0
  801948:	6a 00                	push   $0x0
  80194a:	6a 00                	push   $0x0
  80194c:	6a 00                	push   $0x0
  80194e:	6a 00                	push   $0x0
  801950:	6a 09                	push   $0x9
  801952:	e8 00 ff ff ff       	call   801857 <syscall>
  801957:	83 c4 18             	add    $0x18,%esp
}
  80195a:	c9                   	leave  
  80195b:	c3                   	ret    

0080195c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80195c:	55                   	push   %ebp
  80195d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80195f:	6a 00                	push   $0x0
  801961:	6a 00                	push   $0x0
  801963:	6a 00                	push   $0x0
  801965:	6a 00                	push   $0x0
  801967:	6a 00                	push   $0x0
  801969:	6a 0a                	push   $0xa
  80196b:	e8 e7 fe ff ff       	call   801857 <syscall>
  801970:	83 c4 18             	add    $0x18,%esp
}
  801973:	c9                   	leave  
  801974:	c3                   	ret    

00801975 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801975:	55                   	push   %ebp
  801976:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801978:	6a 00                	push   $0x0
  80197a:	6a 00                	push   $0x0
  80197c:	6a 00                	push   $0x0
  80197e:	6a 00                	push   $0x0
  801980:	6a 00                	push   $0x0
  801982:	6a 0b                	push   $0xb
  801984:	e8 ce fe ff ff       	call   801857 <syscall>
  801989:	83 c4 18             	add    $0x18,%esp
}
  80198c:	c9                   	leave  
  80198d:	c3                   	ret    

0080198e <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80198e:	55                   	push   %ebp
  80198f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801991:	6a 00                	push   $0x0
  801993:	6a 00                	push   $0x0
  801995:	6a 00                	push   $0x0
  801997:	ff 75 0c             	pushl  0xc(%ebp)
  80199a:	ff 75 08             	pushl  0x8(%ebp)
  80199d:	6a 0f                	push   $0xf
  80199f:	e8 b3 fe ff ff       	call   801857 <syscall>
  8019a4:	83 c4 18             	add    $0x18,%esp
	return;
  8019a7:	90                   	nop
}
  8019a8:	c9                   	leave  
  8019a9:	c3                   	ret    

008019aa <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019aa:	55                   	push   %ebp
  8019ab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 00                	push   $0x0
  8019b3:	ff 75 0c             	pushl  0xc(%ebp)
  8019b6:	ff 75 08             	pushl  0x8(%ebp)
  8019b9:	6a 10                	push   $0x10
  8019bb:	e8 97 fe ff ff       	call   801857 <syscall>
  8019c0:	83 c4 18             	add    $0x18,%esp
	return ;
  8019c3:	90                   	nop
}
  8019c4:	c9                   	leave  
  8019c5:	c3                   	ret    

008019c6 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8019c6:	55                   	push   %ebp
  8019c7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 00                	push   $0x0
  8019cd:	ff 75 10             	pushl  0x10(%ebp)
  8019d0:	ff 75 0c             	pushl  0xc(%ebp)
  8019d3:	ff 75 08             	pushl  0x8(%ebp)
  8019d6:	6a 11                	push   $0x11
  8019d8:	e8 7a fe ff ff       	call   801857 <syscall>
  8019dd:	83 c4 18             	add    $0x18,%esp
	return ;
  8019e0:	90                   	nop
}
  8019e1:	c9                   	leave  
  8019e2:	c3                   	ret    

008019e3 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019e3:	55                   	push   %ebp
  8019e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 0c                	push   $0xc
  8019f2:	e8 60 fe ff ff       	call   801857 <syscall>
  8019f7:	83 c4 18             	add    $0x18,%esp
}
  8019fa:	c9                   	leave  
  8019fb:	c3                   	ret    

008019fc <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019fc:	55                   	push   %ebp
  8019fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 00                	push   $0x0
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	ff 75 08             	pushl  0x8(%ebp)
  801a0a:	6a 0d                	push   $0xd
  801a0c:	e8 46 fe ff ff       	call   801857 <syscall>
  801a11:	83 c4 18             	add    $0x18,%esp
}
  801a14:	c9                   	leave  
  801a15:	c3                   	ret    

00801a16 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a16:	55                   	push   %ebp
  801a17:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 00                	push   $0x0
  801a23:	6a 0e                	push   $0xe
  801a25:	e8 2d fe ff ff       	call   801857 <syscall>
  801a2a:	83 c4 18             	add    $0x18,%esp
}
  801a2d:	90                   	nop
  801a2e:	c9                   	leave  
  801a2f:	c3                   	ret    

00801a30 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a30:	55                   	push   %ebp
  801a31:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 13                	push   $0x13
  801a3f:	e8 13 fe ff ff       	call   801857 <syscall>
  801a44:	83 c4 18             	add    $0x18,%esp
}
  801a47:	90                   	nop
  801a48:	c9                   	leave  
  801a49:	c3                   	ret    

00801a4a <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a4a:	55                   	push   %ebp
  801a4b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a4d:	6a 00                	push   $0x0
  801a4f:	6a 00                	push   $0x0
  801a51:	6a 00                	push   $0x0
  801a53:	6a 00                	push   $0x0
  801a55:	6a 00                	push   $0x0
  801a57:	6a 14                	push   $0x14
  801a59:	e8 f9 fd ff ff       	call   801857 <syscall>
  801a5e:	83 c4 18             	add    $0x18,%esp
}
  801a61:	90                   	nop
  801a62:	c9                   	leave  
  801a63:	c3                   	ret    

00801a64 <sys_cputc>:


void
sys_cputc(const char c)
{
  801a64:	55                   	push   %ebp
  801a65:	89 e5                	mov    %esp,%ebp
  801a67:	83 ec 04             	sub    $0x4,%esp
  801a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a70:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a74:	6a 00                	push   $0x0
  801a76:	6a 00                	push   $0x0
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 00                	push   $0x0
  801a7c:	50                   	push   %eax
  801a7d:	6a 15                	push   $0x15
  801a7f:	e8 d3 fd ff ff       	call   801857 <syscall>
  801a84:	83 c4 18             	add    $0x18,%esp
}
  801a87:	90                   	nop
  801a88:	c9                   	leave  
  801a89:	c3                   	ret    

00801a8a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a8a:	55                   	push   %ebp
  801a8b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	6a 16                	push   $0x16
  801a99:	e8 b9 fd ff ff       	call   801857 <syscall>
  801a9e:	83 c4 18             	add    $0x18,%esp
}
  801aa1:	90                   	nop
  801aa2:	c9                   	leave  
  801aa3:	c3                   	ret    

00801aa4 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801aa4:	55                   	push   %ebp
  801aa5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	ff 75 0c             	pushl  0xc(%ebp)
  801ab3:	50                   	push   %eax
  801ab4:	6a 17                	push   $0x17
  801ab6:	e8 9c fd ff ff       	call   801857 <syscall>
  801abb:	83 c4 18             	add    $0x18,%esp
}
  801abe:	c9                   	leave  
  801abf:	c3                   	ret    

00801ac0 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801ac0:	55                   	push   %ebp
  801ac1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ac3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	52                   	push   %edx
  801ad0:	50                   	push   %eax
  801ad1:	6a 1a                	push   $0x1a
  801ad3:	e8 7f fd ff ff       	call   801857 <syscall>
  801ad8:	83 c4 18             	add    $0x18,%esp
}
  801adb:	c9                   	leave  
  801adc:	c3                   	ret    

00801add <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801add:	55                   	push   %ebp
  801ade:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ae0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	52                   	push   %edx
  801aed:	50                   	push   %eax
  801aee:	6a 18                	push   $0x18
  801af0:	e8 62 fd ff ff       	call   801857 <syscall>
  801af5:	83 c4 18             	add    $0x18,%esp
}
  801af8:	90                   	nop
  801af9:	c9                   	leave  
  801afa:	c3                   	ret    

00801afb <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801afb:	55                   	push   %ebp
  801afc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801afe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b01:	8b 45 08             	mov    0x8(%ebp),%eax
  801b04:	6a 00                	push   $0x0
  801b06:	6a 00                	push   $0x0
  801b08:	6a 00                	push   $0x0
  801b0a:	52                   	push   %edx
  801b0b:	50                   	push   %eax
  801b0c:	6a 19                	push   $0x19
  801b0e:	e8 44 fd ff ff       	call   801857 <syscall>
  801b13:	83 c4 18             	add    $0x18,%esp
}
  801b16:	90                   	nop
  801b17:	c9                   	leave  
  801b18:	c3                   	ret    

00801b19 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b19:	55                   	push   %ebp
  801b1a:	89 e5                	mov    %esp,%ebp
  801b1c:	83 ec 04             	sub    $0x4,%esp
  801b1f:	8b 45 10             	mov    0x10(%ebp),%eax
  801b22:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b25:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b28:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2f:	6a 00                	push   $0x0
  801b31:	51                   	push   %ecx
  801b32:	52                   	push   %edx
  801b33:	ff 75 0c             	pushl  0xc(%ebp)
  801b36:	50                   	push   %eax
  801b37:	6a 1b                	push   $0x1b
  801b39:	e8 19 fd ff ff       	call   801857 <syscall>
  801b3e:	83 c4 18             	add    $0x18,%esp
}
  801b41:	c9                   	leave  
  801b42:	c3                   	ret    

00801b43 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b43:	55                   	push   %ebp
  801b44:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b46:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b49:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 00                	push   $0x0
  801b50:	6a 00                	push   $0x0
  801b52:	52                   	push   %edx
  801b53:	50                   	push   %eax
  801b54:	6a 1c                	push   $0x1c
  801b56:	e8 fc fc ff ff       	call   801857 <syscall>
  801b5b:	83 c4 18             	add    $0x18,%esp
}
  801b5e:	c9                   	leave  
  801b5f:	c3                   	ret    

00801b60 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b60:	55                   	push   %ebp
  801b61:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b63:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b66:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b69:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 00                	push   $0x0
  801b70:	51                   	push   %ecx
  801b71:	52                   	push   %edx
  801b72:	50                   	push   %eax
  801b73:	6a 1d                	push   $0x1d
  801b75:	e8 dd fc ff ff       	call   801857 <syscall>
  801b7a:	83 c4 18             	add    $0x18,%esp
}
  801b7d:	c9                   	leave  
  801b7e:	c3                   	ret    

00801b7f <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b7f:	55                   	push   %ebp
  801b80:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b82:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b85:	8b 45 08             	mov    0x8(%ebp),%eax
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 00                	push   $0x0
  801b8e:	52                   	push   %edx
  801b8f:	50                   	push   %eax
  801b90:	6a 1e                	push   $0x1e
  801b92:	e8 c0 fc ff ff       	call   801857 <syscall>
  801b97:	83 c4 18             	add    $0x18,%esp
}
  801b9a:	c9                   	leave  
  801b9b:	c3                   	ret    

00801b9c <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b9c:	55                   	push   %ebp
  801b9d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b9f:	6a 00                	push   $0x0
  801ba1:	6a 00                	push   $0x0
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 1f                	push   $0x1f
  801bab:	e8 a7 fc ff ff       	call   801857 <syscall>
  801bb0:	83 c4 18             	add    $0x18,%esp
}
  801bb3:	c9                   	leave  
  801bb4:	c3                   	ret    

00801bb5 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801bb5:	55                   	push   %ebp
  801bb6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbb:	6a 00                	push   $0x0
  801bbd:	ff 75 14             	pushl  0x14(%ebp)
  801bc0:	ff 75 10             	pushl  0x10(%ebp)
  801bc3:	ff 75 0c             	pushl  0xc(%ebp)
  801bc6:	50                   	push   %eax
  801bc7:	6a 20                	push   $0x20
  801bc9:	e8 89 fc ff ff       	call   801857 <syscall>
  801bce:	83 c4 18             	add    $0x18,%esp
}
  801bd1:	c9                   	leave  
  801bd2:	c3                   	ret    

00801bd3 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801bd3:	55                   	push   %ebp
  801bd4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	50                   	push   %eax
  801be2:	6a 21                	push   $0x21
  801be4:	e8 6e fc ff ff       	call   801857 <syscall>
  801be9:	83 c4 18             	add    $0x18,%esp
}
  801bec:	90                   	nop
  801bed:	c9                   	leave  
  801bee:	c3                   	ret    

00801bef <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801bef:	55                   	push   %ebp
  801bf0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 00                	push   $0x0
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 00                	push   $0x0
  801bfd:	50                   	push   %eax
  801bfe:	6a 22                	push   $0x22
  801c00:	e8 52 fc ff ff       	call   801857 <syscall>
  801c05:	83 c4 18             	add    $0x18,%esp
}
  801c08:	c9                   	leave  
  801c09:	c3                   	ret    

00801c0a <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c0a:	55                   	push   %ebp
  801c0b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 00                	push   $0x0
  801c13:	6a 00                	push   $0x0
  801c15:	6a 00                	push   $0x0
  801c17:	6a 02                	push   $0x2
  801c19:	e8 39 fc ff ff       	call   801857 <syscall>
  801c1e:	83 c4 18             	add    $0x18,%esp
}
  801c21:	c9                   	leave  
  801c22:	c3                   	ret    

00801c23 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c23:	55                   	push   %ebp
  801c24:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c26:	6a 00                	push   $0x0
  801c28:	6a 00                	push   $0x0
  801c2a:	6a 00                	push   $0x0
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 03                	push   $0x3
  801c32:	e8 20 fc ff ff       	call   801857 <syscall>
  801c37:	83 c4 18             	add    $0x18,%esp
}
  801c3a:	c9                   	leave  
  801c3b:	c3                   	ret    

00801c3c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c3c:	55                   	push   %ebp
  801c3d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c3f:	6a 00                	push   $0x0
  801c41:	6a 00                	push   $0x0
  801c43:	6a 00                	push   $0x0
  801c45:	6a 00                	push   $0x0
  801c47:	6a 00                	push   $0x0
  801c49:	6a 04                	push   $0x4
  801c4b:	e8 07 fc ff ff       	call   801857 <syscall>
  801c50:	83 c4 18             	add    $0x18,%esp
}
  801c53:	c9                   	leave  
  801c54:	c3                   	ret    

00801c55 <sys_exit_env>:


void sys_exit_env(void)
{
  801c55:	55                   	push   %ebp
  801c56:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 00                	push   $0x0
  801c62:	6a 23                	push   $0x23
  801c64:	e8 ee fb ff ff       	call   801857 <syscall>
  801c69:	83 c4 18             	add    $0x18,%esp
}
  801c6c:	90                   	nop
  801c6d:	c9                   	leave  
  801c6e:	c3                   	ret    

00801c6f <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c6f:	55                   	push   %ebp
  801c70:	89 e5                	mov    %esp,%ebp
  801c72:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c75:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c78:	8d 50 04             	lea    0x4(%eax),%edx
  801c7b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c7e:	6a 00                	push   $0x0
  801c80:	6a 00                	push   $0x0
  801c82:	6a 00                	push   $0x0
  801c84:	52                   	push   %edx
  801c85:	50                   	push   %eax
  801c86:	6a 24                	push   $0x24
  801c88:	e8 ca fb ff ff       	call   801857 <syscall>
  801c8d:	83 c4 18             	add    $0x18,%esp
	return result;
  801c90:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c93:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c96:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c99:	89 01                	mov    %eax,(%ecx)
  801c9b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca1:	c9                   	leave  
  801ca2:	c2 04 00             	ret    $0x4

00801ca5 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801ca5:	55                   	push   %ebp
  801ca6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 00                	push   $0x0
  801cac:	ff 75 10             	pushl  0x10(%ebp)
  801caf:	ff 75 0c             	pushl  0xc(%ebp)
  801cb2:	ff 75 08             	pushl  0x8(%ebp)
  801cb5:	6a 12                	push   $0x12
  801cb7:	e8 9b fb ff ff       	call   801857 <syscall>
  801cbc:	83 c4 18             	add    $0x18,%esp
	return ;
  801cbf:	90                   	nop
}
  801cc0:	c9                   	leave  
  801cc1:	c3                   	ret    

00801cc2 <sys_rcr2>:
uint32 sys_rcr2()
{
  801cc2:	55                   	push   %ebp
  801cc3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801cc5:	6a 00                	push   $0x0
  801cc7:	6a 00                	push   $0x0
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 25                	push   $0x25
  801cd1:	e8 81 fb ff ff       	call   801857 <syscall>
  801cd6:	83 c4 18             	add    $0x18,%esp
}
  801cd9:	c9                   	leave  
  801cda:	c3                   	ret    

00801cdb <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801cdb:	55                   	push   %ebp
  801cdc:	89 e5                	mov    %esp,%ebp
  801cde:	83 ec 04             	sub    $0x4,%esp
  801ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ce7:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ceb:	6a 00                	push   $0x0
  801ced:	6a 00                	push   $0x0
  801cef:	6a 00                	push   $0x0
  801cf1:	6a 00                	push   $0x0
  801cf3:	50                   	push   %eax
  801cf4:	6a 26                	push   $0x26
  801cf6:	e8 5c fb ff ff       	call   801857 <syscall>
  801cfb:	83 c4 18             	add    $0x18,%esp
	return ;
  801cfe:	90                   	nop
}
  801cff:	c9                   	leave  
  801d00:	c3                   	ret    

00801d01 <rsttst>:
void rsttst()
{
  801d01:	55                   	push   %ebp
  801d02:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d04:	6a 00                	push   $0x0
  801d06:	6a 00                	push   $0x0
  801d08:	6a 00                	push   $0x0
  801d0a:	6a 00                	push   $0x0
  801d0c:	6a 00                	push   $0x0
  801d0e:	6a 28                	push   $0x28
  801d10:	e8 42 fb ff ff       	call   801857 <syscall>
  801d15:	83 c4 18             	add    $0x18,%esp
	return ;
  801d18:	90                   	nop
}
  801d19:	c9                   	leave  
  801d1a:	c3                   	ret    

00801d1b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d1b:	55                   	push   %ebp
  801d1c:	89 e5                	mov    %esp,%ebp
  801d1e:	83 ec 04             	sub    $0x4,%esp
  801d21:	8b 45 14             	mov    0x14(%ebp),%eax
  801d24:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d27:	8b 55 18             	mov    0x18(%ebp),%edx
  801d2a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d2e:	52                   	push   %edx
  801d2f:	50                   	push   %eax
  801d30:	ff 75 10             	pushl  0x10(%ebp)
  801d33:	ff 75 0c             	pushl  0xc(%ebp)
  801d36:	ff 75 08             	pushl  0x8(%ebp)
  801d39:	6a 27                	push   $0x27
  801d3b:	e8 17 fb ff ff       	call   801857 <syscall>
  801d40:	83 c4 18             	add    $0x18,%esp
	return ;
  801d43:	90                   	nop
}
  801d44:	c9                   	leave  
  801d45:	c3                   	ret    

00801d46 <chktst>:
void chktst(uint32 n)
{
  801d46:	55                   	push   %ebp
  801d47:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 00                	push   $0x0
  801d4f:	6a 00                	push   $0x0
  801d51:	ff 75 08             	pushl  0x8(%ebp)
  801d54:	6a 29                	push   $0x29
  801d56:	e8 fc fa ff ff       	call   801857 <syscall>
  801d5b:	83 c4 18             	add    $0x18,%esp
	return ;
  801d5e:	90                   	nop
}
  801d5f:	c9                   	leave  
  801d60:	c3                   	ret    

00801d61 <inctst>:

void inctst()
{
  801d61:	55                   	push   %ebp
  801d62:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d64:	6a 00                	push   $0x0
  801d66:	6a 00                	push   $0x0
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 2a                	push   $0x2a
  801d70:	e8 e2 fa ff ff       	call   801857 <syscall>
  801d75:	83 c4 18             	add    $0x18,%esp
	return ;
  801d78:	90                   	nop
}
  801d79:	c9                   	leave  
  801d7a:	c3                   	ret    

00801d7b <gettst>:
uint32 gettst()
{
  801d7b:	55                   	push   %ebp
  801d7c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d7e:	6a 00                	push   $0x0
  801d80:	6a 00                	push   $0x0
  801d82:	6a 00                	push   $0x0
  801d84:	6a 00                	push   $0x0
  801d86:	6a 00                	push   $0x0
  801d88:	6a 2b                	push   $0x2b
  801d8a:	e8 c8 fa ff ff       	call   801857 <syscall>
  801d8f:	83 c4 18             	add    $0x18,%esp
}
  801d92:	c9                   	leave  
  801d93:	c3                   	ret    

00801d94 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d94:	55                   	push   %ebp
  801d95:	89 e5                	mov    %esp,%ebp
  801d97:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d9a:	6a 00                	push   $0x0
  801d9c:	6a 00                	push   $0x0
  801d9e:	6a 00                	push   $0x0
  801da0:	6a 00                	push   $0x0
  801da2:	6a 00                	push   $0x0
  801da4:	6a 2c                	push   $0x2c
  801da6:	e8 ac fa ff ff       	call   801857 <syscall>
  801dab:	83 c4 18             	add    $0x18,%esp
  801dae:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801db1:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801db5:	75 07                	jne    801dbe <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801db7:	b8 01 00 00 00       	mov    $0x1,%eax
  801dbc:	eb 05                	jmp    801dc3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801dbe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dc3:	c9                   	leave  
  801dc4:	c3                   	ret    

00801dc5 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801dc5:	55                   	push   %ebp
  801dc6:	89 e5                	mov    %esp,%ebp
  801dc8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dcb:	6a 00                	push   $0x0
  801dcd:	6a 00                	push   $0x0
  801dcf:	6a 00                	push   $0x0
  801dd1:	6a 00                	push   $0x0
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 2c                	push   $0x2c
  801dd7:	e8 7b fa ff ff       	call   801857 <syscall>
  801ddc:	83 c4 18             	add    $0x18,%esp
  801ddf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801de2:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801de6:	75 07                	jne    801def <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801de8:	b8 01 00 00 00       	mov    $0x1,%eax
  801ded:	eb 05                	jmp    801df4 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801def:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801df4:	c9                   	leave  
  801df5:	c3                   	ret    

00801df6 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801df6:	55                   	push   %ebp
  801df7:	89 e5                	mov    %esp,%ebp
  801df9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dfc:	6a 00                	push   $0x0
  801dfe:	6a 00                	push   $0x0
  801e00:	6a 00                	push   $0x0
  801e02:	6a 00                	push   $0x0
  801e04:	6a 00                	push   $0x0
  801e06:	6a 2c                	push   $0x2c
  801e08:	e8 4a fa ff ff       	call   801857 <syscall>
  801e0d:	83 c4 18             	add    $0x18,%esp
  801e10:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e13:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e17:	75 07                	jne    801e20 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e19:	b8 01 00 00 00       	mov    $0x1,%eax
  801e1e:	eb 05                	jmp    801e25 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e20:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e25:	c9                   	leave  
  801e26:	c3                   	ret    

00801e27 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e27:	55                   	push   %ebp
  801e28:	89 e5                	mov    %esp,%ebp
  801e2a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 00                	push   $0x0
  801e33:	6a 00                	push   $0x0
  801e35:	6a 00                	push   $0x0
  801e37:	6a 2c                	push   $0x2c
  801e39:	e8 19 fa ff ff       	call   801857 <syscall>
  801e3e:	83 c4 18             	add    $0x18,%esp
  801e41:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e44:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e48:	75 07                	jne    801e51 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e4a:	b8 01 00 00 00       	mov    $0x1,%eax
  801e4f:	eb 05                	jmp    801e56 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e51:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e56:	c9                   	leave  
  801e57:	c3                   	ret    

00801e58 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e58:	55                   	push   %ebp
  801e59:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e5b:	6a 00                	push   $0x0
  801e5d:	6a 00                	push   $0x0
  801e5f:	6a 00                	push   $0x0
  801e61:	6a 00                	push   $0x0
  801e63:	ff 75 08             	pushl  0x8(%ebp)
  801e66:	6a 2d                	push   $0x2d
  801e68:	e8 ea f9 ff ff       	call   801857 <syscall>
  801e6d:	83 c4 18             	add    $0x18,%esp
	return ;
  801e70:	90                   	nop
}
  801e71:	c9                   	leave  
  801e72:	c3                   	ret    

00801e73 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e73:	55                   	push   %ebp
  801e74:	89 e5                	mov    %esp,%ebp
  801e76:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e77:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e7a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e80:	8b 45 08             	mov    0x8(%ebp),%eax
  801e83:	6a 00                	push   $0x0
  801e85:	53                   	push   %ebx
  801e86:	51                   	push   %ecx
  801e87:	52                   	push   %edx
  801e88:	50                   	push   %eax
  801e89:	6a 2e                	push   $0x2e
  801e8b:	e8 c7 f9 ff ff       	call   801857 <syscall>
  801e90:	83 c4 18             	add    $0x18,%esp
}
  801e93:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e96:	c9                   	leave  
  801e97:	c3                   	ret    

00801e98 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e98:	55                   	push   %ebp
  801e99:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea1:	6a 00                	push   $0x0
  801ea3:	6a 00                	push   $0x0
  801ea5:	6a 00                	push   $0x0
  801ea7:	52                   	push   %edx
  801ea8:	50                   	push   %eax
  801ea9:	6a 2f                	push   $0x2f
  801eab:	e8 a7 f9 ff ff       	call   801857 <syscall>
  801eb0:	83 c4 18             	add    $0x18,%esp
}
  801eb3:	c9                   	leave  
  801eb4:	c3                   	ret    

00801eb5 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801eb5:	55                   	push   %ebp
  801eb6:	89 e5                	mov    %esp,%ebp
  801eb8:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801ebb:	83 ec 0c             	sub    $0xc,%esp
  801ebe:	68 dc 3a 80 00       	push   $0x803adc
  801ec3:	e8 21 e7 ff ff       	call   8005e9 <cprintf>
  801ec8:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801ecb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801ed2:	83 ec 0c             	sub    $0xc,%esp
  801ed5:	68 08 3b 80 00       	push   $0x803b08
  801eda:	e8 0a e7 ff ff       	call   8005e9 <cprintf>
  801edf:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801ee2:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ee6:	a1 38 41 80 00       	mov    0x804138,%eax
  801eeb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801eee:	eb 56                	jmp    801f46 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ef0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ef4:	74 1c                	je     801f12 <print_mem_block_lists+0x5d>
  801ef6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef9:	8b 50 08             	mov    0x8(%eax),%edx
  801efc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eff:	8b 48 08             	mov    0x8(%eax),%ecx
  801f02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f05:	8b 40 0c             	mov    0xc(%eax),%eax
  801f08:	01 c8                	add    %ecx,%eax
  801f0a:	39 c2                	cmp    %eax,%edx
  801f0c:	73 04                	jae    801f12 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801f0e:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f15:	8b 50 08             	mov    0x8(%eax),%edx
  801f18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f1b:	8b 40 0c             	mov    0xc(%eax),%eax
  801f1e:	01 c2                	add    %eax,%edx
  801f20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f23:	8b 40 08             	mov    0x8(%eax),%eax
  801f26:	83 ec 04             	sub    $0x4,%esp
  801f29:	52                   	push   %edx
  801f2a:	50                   	push   %eax
  801f2b:	68 1d 3b 80 00       	push   $0x803b1d
  801f30:	e8 b4 e6 ff ff       	call   8005e9 <cprintf>
  801f35:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f3e:	a1 40 41 80 00       	mov    0x804140,%eax
  801f43:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f46:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f4a:	74 07                	je     801f53 <print_mem_block_lists+0x9e>
  801f4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f4f:	8b 00                	mov    (%eax),%eax
  801f51:	eb 05                	jmp    801f58 <print_mem_block_lists+0xa3>
  801f53:	b8 00 00 00 00       	mov    $0x0,%eax
  801f58:	a3 40 41 80 00       	mov    %eax,0x804140
  801f5d:	a1 40 41 80 00       	mov    0x804140,%eax
  801f62:	85 c0                	test   %eax,%eax
  801f64:	75 8a                	jne    801ef0 <print_mem_block_lists+0x3b>
  801f66:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f6a:	75 84                	jne    801ef0 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f6c:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f70:	75 10                	jne    801f82 <print_mem_block_lists+0xcd>
  801f72:	83 ec 0c             	sub    $0xc,%esp
  801f75:	68 2c 3b 80 00       	push   $0x803b2c
  801f7a:	e8 6a e6 ff ff       	call   8005e9 <cprintf>
  801f7f:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f82:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f89:	83 ec 0c             	sub    $0xc,%esp
  801f8c:	68 50 3b 80 00       	push   $0x803b50
  801f91:	e8 53 e6 ff ff       	call   8005e9 <cprintf>
  801f96:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f99:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f9d:	a1 40 40 80 00       	mov    0x804040,%eax
  801fa2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fa5:	eb 56                	jmp    801ffd <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801fa7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fab:	74 1c                	je     801fc9 <print_mem_block_lists+0x114>
  801fad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb0:	8b 50 08             	mov    0x8(%eax),%edx
  801fb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fb6:	8b 48 08             	mov    0x8(%eax),%ecx
  801fb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fbc:	8b 40 0c             	mov    0xc(%eax),%eax
  801fbf:	01 c8                	add    %ecx,%eax
  801fc1:	39 c2                	cmp    %eax,%edx
  801fc3:	73 04                	jae    801fc9 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801fc5:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801fc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fcc:	8b 50 08             	mov    0x8(%eax),%edx
  801fcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd2:	8b 40 0c             	mov    0xc(%eax),%eax
  801fd5:	01 c2                	add    %eax,%edx
  801fd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fda:	8b 40 08             	mov    0x8(%eax),%eax
  801fdd:	83 ec 04             	sub    $0x4,%esp
  801fe0:	52                   	push   %edx
  801fe1:	50                   	push   %eax
  801fe2:	68 1d 3b 80 00       	push   $0x803b1d
  801fe7:	e8 fd e5 ff ff       	call   8005e9 <cprintf>
  801fec:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801ff5:	a1 48 40 80 00       	mov    0x804048,%eax
  801ffa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ffd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802001:	74 07                	je     80200a <print_mem_block_lists+0x155>
  802003:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802006:	8b 00                	mov    (%eax),%eax
  802008:	eb 05                	jmp    80200f <print_mem_block_lists+0x15a>
  80200a:	b8 00 00 00 00       	mov    $0x0,%eax
  80200f:	a3 48 40 80 00       	mov    %eax,0x804048
  802014:	a1 48 40 80 00       	mov    0x804048,%eax
  802019:	85 c0                	test   %eax,%eax
  80201b:	75 8a                	jne    801fa7 <print_mem_block_lists+0xf2>
  80201d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802021:	75 84                	jne    801fa7 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802023:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802027:	75 10                	jne    802039 <print_mem_block_lists+0x184>
  802029:	83 ec 0c             	sub    $0xc,%esp
  80202c:	68 68 3b 80 00       	push   $0x803b68
  802031:	e8 b3 e5 ff ff       	call   8005e9 <cprintf>
  802036:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802039:	83 ec 0c             	sub    $0xc,%esp
  80203c:	68 dc 3a 80 00       	push   $0x803adc
  802041:	e8 a3 e5 ff ff       	call   8005e9 <cprintf>
  802046:	83 c4 10             	add    $0x10,%esp

}
  802049:	90                   	nop
  80204a:	c9                   	leave  
  80204b:	c3                   	ret    

0080204c <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80204c:	55                   	push   %ebp
  80204d:	89 e5                	mov    %esp,%ebp
  80204f:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  802052:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  802059:	00 00 00 
  80205c:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  802063:	00 00 00 
  802066:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  80206d:	00 00 00 
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  802070:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802077:	e9 9e 00 00 00       	jmp    80211a <initialize_MemBlocksList+0xce>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
  80207c:	a1 50 40 80 00       	mov    0x804050,%eax
  802081:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802084:	c1 e2 04             	shl    $0x4,%edx
  802087:	01 d0                	add    %edx,%eax
  802089:	85 c0                	test   %eax,%eax
  80208b:	75 14                	jne    8020a1 <initialize_MemBlocksList+0x55>
  80208d:	83 ec 04             	sub    $0x4,%esp
  802090:	68 90 3b 80 00       	push   $0x803b90
  802095:	6a 43                	push   $0x43
  802097:	68 b3 3b 80 00       	push   $0x803bb3
  80209c:	e8 94 e2 ff ff       	call   800335 <_panic>
  8020a1:	a1 50 40 80 00       	mov    0x804050,%eax
  8020a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020a9:	c1 e2 04             	shl    $0x4,%edx
  8020ac:	01 d0                	add    %edx,%eax
  8020ae:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8020b4:	89 10                	mov    %edx,(%eax)
  8020b6:	8b 00                	mov    (%eax),%eax
  8020b8:	85 c0                	test   %eax,%eax
  8020ba:	74 18                	je     8020d4 <initialize_MemBlocksList+0x88>
  8020bc:	a1 48 41 80 00       	mov    0x804148,%eax
  8020c1:	8b 15 50 40 80 00    	mov    0x804050,%edx
  8020c7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8020ca:	c1 e1 04             	shl    $0x4,%ecx
  8020cd:	01 ca                	add    %ecx,%edx
  8020cf:	89 50 04             	mov    %edx,0x4(%eax)
  8020d2:	eb 12                	jmp    8020e6 <initialize_MemBlocksList+0x9a>
  8020d4:	a1 50 40 80 00       	mov    0x804050,%eax
  8020d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020dc:	c1 e2 04             	shl    $0x4,%edx
  8020df:	01 d0                	add    %edx,%eax
  8020e1:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8020e6:	a1 50 40 80 00       	mov    0x804050,%eax
  8020eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020ee:	c1 e2 04             	shl    $0x4,%edx
  8020f1:	01 d0                	add    %edx,%eax
  8020f3:	a3 48 41 80 00       	mov    %eax,0x804148
  8020f8:	a1 50 40 80 00       	mov    0x804050,%eax
  8020fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802100:	c1 e2 04             	shl    $0x4,%edx
  802103:	01 d0                	add    %edx,%eax
  802105:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80210c:	a1 54 41 80 00       	mov    0x804154,%eax
  802111:	40                   	inc    %eax
  802112:	a3 54 41 80 00       	mov    %eax,0x804154
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  802117:	ff 45 f4             	incl   -0xc(%ebp)
  80211a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802120:	0f 82 56 ff ff ff    	jb     80207c <initialize_MemBlocksList+0x30>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
		}
}
  802126:	90                   	nop
  802127:	c9                   	leave  
  802128:	c3                   	ret    

00802129 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802129:	55                   	push   %ebp
  80212a:	89 e5                	mov    %esp,%ebp
  80212c:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  80212f:	a1 38 41 80 00       	mov    0x804138,%eax
  802134:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802137:	eb 18                	jmp    802151 <find_block+0x28>
	{
		if (ele->sva==va)
  802139:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80213c:	8b 40 08             	mov    0x8(%eax),%eax
  80213f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802142:	75 05                	jne    802149 <find_block+0x20>
			return ele;
  802144:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802147:	eb 7b                	jmp    8021c4 <find_block+0x9b>
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  802149:	a1 40 41 80 00       	mov    0x804140,%eax
  80214e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802151:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802155:	74 07                	je     80215e <find_block+0x35>
  802157:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80215a:	8b 00                	mov    (%eax),%eax
  80215c:	eb 05                	jmp    802163 <find_block+0x3a>
  80215e:	b8 00 00 00 00       	mov    $0x0,%eax
  802163:	a3 40 41 80 00       	mov    %eax,0x804140
  802168:	a1 40 41 80 00       	mov    0x804140,%eax
  80216d:	85 c0                	test   %eax,%eax
  80216f:	75 c8                	jne    802139 <find_block+0x10>
  802171:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802175:	75 c2                	jne    802139 <find_block+0x10>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  802177:	a1 40 40 80 00       	mov    0x804040,%eax
  80217c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80217f:	eb 18                	jmp    802199 <find_block+0x70>
	{
		if (ele->sva==va)
  802181:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802184:	8b 40 08             	mov    0x8(%eax),%eax
  802187:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80218a:	75 05                	jne    802191 <find_block+0x68>
					return ele;
  80218c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80218f:	eb 33                	jmp    8021c4 <find_block+0x9b>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  802191:	a1 48 40 80 00       	mov    0x804048,%eax
  802196:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802199:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80219d:	74 07                	je     8021a6 <find_block+0x7d>
  80219f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021a2:	8b 00                	mov    (%eax),%eax
  8021a4:	eb 05                	jmp    8021ab <find_block+0x82>
  8021a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ab:	a3 48 40 80 00       	mov    %eax,0x804048
  8021b0:	a1 48 40 80 00       	mov    0x804048,%eax
  8021b5:	85 c0                	test   %eax,%eax
  8021b7:	75 c8                	jne    802181 <find_block+0x58>
  8021b9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021bd:	75 c2                	jne    802181 <find_block+0x58>
	{
		if (ele->sva==va)
					return ele;
	}
return NULL;
  8021bf:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  8021c4:	c9                   	leave  
  8021c5:	c3                   	ret    

008021c6 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8021c6:	55                   	push   %ebp
  8021c7:	89 e5                	mov    %esp,%ebp
  8021c9:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;

int x =LIST_SIZE(&AllocMemBlocksList);
  8021cc:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021d1:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((x==0))
  8021d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021d8:	75 62                	jne    80223c <insert_sorted_allocList+0x76>
	{
	//	blockToInsert=AllocMemBlocksList.lh_first;
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  8021da:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021de:	75 14                	jne    8021f4 <insert_sorted_allocList+0x2e>
  8021e0:	83 ec 04             	sub    $0x4,%esp
  8021e3:	68 90 3b 80 00       	push   $0x803b90
  8021e8:	6a 69                	push   $0x69
  8021ea:	68 b3 3b 80 00       	push   $0x803bb3
  8021ef:	e8 41 e1 ff ff       	call   800335 <_panic>
  8021f4:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8021fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fd:	89 10                	mov    %edx,(%eax)
  8021ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802202:	8b 00                	mov    (%eax),%eax
  802204:	85 c0                	test   %eax,%eax
  802206:	74 0d                	je     802215 <insert_sorted_allocList+0x4f>
  802208:	a1 40 40 80 00       	mov    0x804040,%eax
  80220d:	8b 55 08             	mov    0x8(%ebp),%edx
  802210:	89 50 04             	mov    %edx,0x4(%eax)
  802213:	eb 08                	jmp    80221d <insert_sorted_allocList+0x57>
  802215:	8b 45 08             	mov    0x8(%ebp),%eax
  802218:	a3 44 40 80 00       	mov    %eax,0x804044
  80221d:	8b 45 08             	mov    0x8(%ebp),%eax
  802220:	a3 40 40 80 00       	mov    %eax,0x804040
  802225:	8b 45 08             	mov    0x8(%ebp),%eax
  802228:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80222f:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802234:	40                   	inc    %eax
  802235:	a3 4c 40 80 00       	mov    %eax,0x80404c
  80223a:	eb 72                	jmp    8022ae <insert_sorted_allocList+0xe8>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
  80223c:	a1 40 40 80 00       	mov    0x804040,%eax
  802241:	8b 50 08             	mov    0x8(%eax),%edx
  802244:	8b 45 08             	mov    0x8(%ebp),%eax
  802247:	8b 40 08             	mov    0x8(%eax),%eax
  80224a:	39 c2                	cmp    %eax,%edx
  80224c:	76 60                	jbe    8022ae <insert_sorted_allocList+0xe8>
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  80224e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802252:	75 14                	jne    802268 <insert_sorted_allocList+0xa2>
  802254:	83 ec 04             	sub    $0x4,%esp
  802257:	68 90 3b 80 00       	push   $0x803b90
  80225c:	6a 6d                	push   $0x6d
  80225e:	68 b3 3b 80 00       	push   $0x803bb3
  802263:	e8 cd e0 ff ff       	call   800335 <_panic>
  802268:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80226e:	8b 45 08             	mov    0x8(%ebp),%eax
  802271:	89 10                	mov    %edx,(%eax)
  802273:	8b 45 08             	mov    0x8(%ebp),%eax
  802276:	8b 00                	mov    (%eax),%eax
  802278:	85 c0                	test   %eax,%eax
  80227a:	74 0d                	je     802289 <insert_sorted_allocList+0xc3>
  80227c:	a1 40 40 80 00       	mov    0x804040,%eax
  802281:	8b 55 08             	mov    0x8(%ebp),%edx
  802284:	89 50 04             	mov    %edx,0x4(%eax)
  802287:	eb 08                	jmp    802291 <insert_sorted_allocList+0xcb>
  802289:	8b 45 08             	mov    0x8(%ebp),%eax
  80228c:	a3 44 40 80 00       	mov    %eax,0x804044
  802291:	8b 45 08             	mov    0x8(%ebp),%eax
  802294:	a3 40 40 80 00       	mov    %eax,0x804040
  802299:	8b 45 08             	mov    0x8(%ebp),%eax
  80229c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022a3:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022a8:	40                   	inc    %eax
  8022a9:	a3 4c 40 80 00       	mov    %eax,0x80404c
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  8022ae:	a1 40 40 80 00       	mov    0x804040,%eax
  8022b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022b6:	e9 b9 01 00 00       	jmp    802474 <insert_sorted_allocList+0x2ae>
	{


		if ((blockToInsert->sva>AllocMemBlocksList.lh_first->sva)&&blockToInsert->sva<element->sva)
  8022bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022be:	8b 50 08             	mov    0x8(%eax),%edx
  8022c1:	a1 40 40 80 00       	mov    0x804040,%eax
  8022c6:	8b 40 08             	mov    0x8(%eax),%eax
  8022c9:	39 c2                	cmp    %eax,%edx
  8022cb:	76 7c                	jbe    802349 <insert_sorted_allocList+0x183>
  8022cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d0:	8b 50 08             	mov    0x8(%eax),%edx
  8022d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d6:	8b 40 08             	mov    0x8(%eax),%eax
  8022d9:	39 c2                	cmp    %eax,%edx
  8022db:	73 6c                	jae    802349 <insert_sorted_allocList+0x183>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,element,blockToInsert);
  8022dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022e1:	74 06                	je     8022e9 <insert_sorted_allocList+0x123>
  8022e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022e7:	75 14                	jne    8022fd <insert_sorted_allocList+0x137>
  8022e9:	83 ec 04             	sub    $0x4,%esp
  8022ec:	68 cc 3b 80 00       	push   $0x803bcc
  8022f1:	6a 75                	push   $0x75
  8022f3:	68 b3 3b 80 00       	push   $0x803bb3
  8022f8:	e8 38 e0 ff ff       	call   800335 <_panic>
  8022fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802300:	8b 50 04             	mov    0x4(%eax),%edx
  802303:	8b 45 08             	mov    0x8(%ebp),%eax
  802306:	89 50 04             	mov    %edx,0x4(%eax)
  802309:	8b 45 08             	mov    0x8(%ebp),%eax
  80230c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80230f:	89 10                	mov    %edx,(%eax)
  802311:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802314:	8b 40 04             	mov    0x4(%eax),%eax
  802317:	85 c0                	test   %eax,%eax
  802319:	74 0d                	je     802328 <insert_sorted_allocList+0x162>
  80231b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231e:	8b 40 04             	mov    0x4(%eax),%eax
  802321:	8b 55 08             	mov    0x8(%ebp),%edx
  802324:	89 10                	mov    %edx,(%eax)
  802326:	eb 08                	jmp    802330 <insert_sorted_allocList+0x16a>
  802328:	8b 45 08             	mov    0x8(%ebp),%eax
  80232b:	a3 40 40 80 00       	mov    %eax,0x804040
  802330:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802333:	8b 55 08             	mov    0x8(%ebp),%edx
  802336:	89 50 04             	mov    %edx,0x4(%eax)
  802339:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80233e:	40                   	inc    %eax
  80233f:	a3 4c 40 80 00       	mov    %eax,0x80404c

		break;}
  802344:	e9 59 01 00 00       	jmp    8024a2 <insert_sorted_allocList+0x2dc>

	else if ((blockToInsert->sva>element->sva)&&(blockToInsert->sva<AllocMemBlocksList.lh_last->sva)&&blockToInsert->sva<LIST_NEXT(element)->sva)
  802349:	8b 45 08             	mov    0x8(%ebp),%eax
  80234c:	8b 50 08             	mov    0x8(%eax),%edx
  80234f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802352:	8b 40 08             	mov    0x8(%eax),%eax
  802355:	39 c2                	cmp    %eax,%edx
  802357:	0f 86 98 00 00 00    	jbe    8023f5 <insert_sorted_allocList+0x22f>
  80235d:	8b 45 08             	mov    0x8(%ebp),%eax
  802360:	8b 50 08             	mov    0x8(%eax),%edx
  802363:	a1 44 40 80 00       	mov    0x804044,%eax
  802368:	8b 40 08             	mov    0x8(%eax),%eax
  80236b:	39 c2                	cmp    %eax,%edx
  80236d:	0f 83 82 00 00 00    	jae    8023f5 <insert_sorted_allocList+0x22f>
  802373:	8b 45 08             	mov    0x8(%ebp),%eax
  802376:	8b 50 08             	mov    0x8(%eax),%edx
  802379:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237c:	8b 00                	mov    (%eax),%eax
  80237e:	8b 40 08             	mov    0x8(%eax),%eax
  802381:	39 c2                	cmp    %eax,%edx
  802383:	73 70                	jae    8023f5 <insert_sorted_allocList+0x22f>
	{

	LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  802385:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802389:	74 06                	je     802391 <insert_sorted_allocList+0x1cb>
  80238b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80238f:	75 14                	jne    8023a5 <insert_sorted_allocList+0x1df>
  802391:	83 ec 04             	sub    $0x4,%esp
  802394:	68 04 3c 80 00       	push   $0x803c04
  802399:	6a 7c                	push   $0x7c
  80239b:	68 b3 3b 80 00       	push   $0x803bb3
  8023a0:	e8 90 df ff ff       	call   800335 <_panic>
  8023a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a8:	8b 10                	mov    (%eax),%edx
  8023aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ad:	89 10                	mov    %edx,(%eax)
  8023af:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b2:	8b 00                	mov    (%eax),%eax
  8023b4:	85 c0                	test   %eax,%eax
  8023b6:	74 0b                	je     8023c3 <insert_sorted_allocList+0x1fd>
  8023b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bb:	8b 00                	mov    (%eax),%eax
  8023bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8023c0:	89 50 04             	mov    %edx,0x4(%eax)
  8023c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8023c9:	89 10                	mov    %edx,(%eax)
  8023cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023d1:	89 50 04             	mov    %edx,0x4(%eax)
  8023d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d7:	8b 00                	mov    (%eax),%eax
  8023d9:	85 c0                	test   %eax,%eax
  8023db:	75 08                	jne    8023e5 <insert_sorted_allocList+0x21f>
  8023dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e0:	a3 44 40 80 00       	mov    %eax,0x804044
  8023e5:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8023ea:	40                   	inc    %eax
  8023eb:	a3 4c 40 80 00       	mov    %eax,0x80404c
		break;
  8023f0:	e9 ad 00 00 00       	jmp    8024a2 <insert_sorted_allocList+0x2dc>
	}else if (blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  8023f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f8:	8b 50 08             	mov    0x8(%eax),%edx
  8023fb:	a1 44 40 80 00       	mov    0x804044,%eax
  802400:	8b 40 08             	mov    0x8(%eax),%eax
  802403:	39 c2                	cmp    %eax,%edx
  802405:	76 65                	jbe    80246c <insert_sorted_allocList+0x2a6>
	{
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
  802407:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80240b:	75 17                	jne    802424 <insert_sorted_allocList+0x25e>
  80240d:	83 ec 04             	sub    $0x4,%esp
  802410:	68 38 3c 80 00       	push   $0x803c38
  802415:	68 80 00 00 00       	push   $0x80
  80241a:	68 b3 3b 80 00       	push   $0x803bb3
  80241f:	e8 11 df ff ff       	call   800335 <_panic>
  802424:	8b 15 44 40 80 00    	mov    0x804044,%edx
  80242a:	8b 45 08             	mov    0x8(%ebp),%eax
  80242d:	89 50 04             	mov    %edx,0x4(%eax)
  802430:	8b 45 08             	mov    0x8(%ebp),%eax
  802433:	8b 40 04             	mov    0x4(%eax),%eax
  802436:	85 c0                	test   %eax,%eax
  802438:	74 0c                	je     802446 <insert_sorted_allocList+0x280>
  80243a:	a1 44 40 80 00       	mov    0x804044,%eax
  80243f:	8b 55 08             	mov    0x8(%ebp),%edx
  802442:	89 10                	mov    %edx,(%eax)
  802444:	eb 08                	jmp    80244e <insert_sorted_allocList+0x288>
  802446:	8b 45 08             	mov    0x8(%ebp),%eax
  802449:	a3 40 40 80 00       	mov    %eax,0x804040
  80244e:	8b 45 08             	mov    0x8(%ebp),%eax
  802451:	a3 44 40 80 00       	mov    %eax,0x804044
  802456:	8b 45 08             	mov    0x8(%ebp),%eax
  802459:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80245f:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802464:	40                   	inc    %eax
  802465:	a3 4c 40 80 00       	mov    %eax,0x80404c
		break;
  80246a:	eb 36                	jmp    8024a2 <insert_sorted_allocList+0x2dc>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  80246c:	a1 48 40 80 00       	mov    0x804048,%eax
  802471:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802474:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802478:	74 07                	je     802481 <insert_sorted_allocList+0x2bb>
  80247a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247d:	8b 00                	mov    (%eax),%eax
  80247f:	eb 05                	jmp    802486 <insert_sorted_allocList+0x2c0>
  802481:	b8 00 00 00 00       	mov    $0x0,%eax
  802486:	a3 48 40 80 00       	mov    %eax,0x804048
  80248b:	a1 48 40 80 00       	mov    0x804048,%eax
  802490:	85 c0                	test   %eax,%eax
  802492:	0f 85 23 fe ff ff    	jne    8022bb <insert_sorted_allocList+0xf5>
  802498:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80249c:	0f 85 19 fe ff ff    	jne    8022bb <insert_sorted_allocList+0xf5>
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
		break;

	}
	}
}
  8024a2:	90                   	nop
  8024a3:	c9                   	leave  
  8024a4:	c3                   	ret    

008024a5 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8024a5:	55                   	push   %ebp
  8024a6:	89 e5                	mov    %esp,%ebp
  8024a8:	83 ec 18             	sub    $0x18,%esp
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  8024ab:	a1 38 41 80 00       	mov    0x804138,%eax
  8024b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024b3:	e9 7c 01 00 00       	jmp    802634 <alloc_block_FF+0x18f>
		{
			// case 2
				if(element->size == size)
  8024b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8024be:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024c1:	0f 85 90 00 00 00    	jne    802557 <alloc_block_FF+0xb2>
				{
					tmp_block=element;
  8024c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,element);
  8024cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024d1:	75 17                	jne    8024ea <alloc_block_FF+0x45>
  8024d3:	83 ec 04             	sub    $0x4,%esp
  8024d6:	68 5b 3c 80 00       	push   $0x803c5b
  8024db:	68 ba 00 00 00       	push   $0xba
  8024e0:	68 b3 3b 80 00       	push   $0x803bb3
  8024e5:	e8 4b de ff ff       	call   800335 <_panic>
  8024ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ed:	8b 00                	mov    (%eax),%eax
  8024ef:	85 c0                	test   %eax,%eax
  8024f1:	74 10                	je     802503 <alloc_block_FF+0x5e>
  8024f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f6:	8b 00                	mov    (%eax),%eax
  8024f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024fb:	8b 52 04             	mov    0x4(%edx),%edx
  8024fe:	89 50 04             	mov    %edx,0x4(%eax)
  802501:	eb 0b                	jmp    80250e <alloc_block_FF+0x69>
  802503:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802506:	8b 40 04             	mov    0x4(%eax),%eax
  802509:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80250e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802511:	8b 40 04             	mov    0x4(%eax),%eax
  802514:	85 c0                	test   %eax,%eax
  802516:	74 0f                	je     802527 <alloc_block_FF+0x82>
  802518:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251b:	8b 40 04             	mov    0x4(%eax),%eax
  80251e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802521:	8b 12                	mov    (%edx),%edx
  802523:	89 10                	mov    %edx,(%eax)
  802525:	eb 0a                	jmp    802531 <alloc_block_FF+0x8c>
  802527:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252a:	8b 00                	mov    (%eax),%eax
  80252c:	a3 38 41 80 00       	mov    %eax,0x804138
  802531:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802534:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80253a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802544:	a1 44 41 80 00       	mov    0x804144,%eax
  802549:	48                   	dec    %eax
  80254a:	a3 44 41 80 00       	mov    %eax,0x804144
					return tmp_block;
  80254f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802552:	e9 10 01 00 00       	jmp    802667 <alloc_block_FF+0x1c2>
				}
				 // case 3
				else if(element->size > size)
  802557:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255a:	8b 40 0c             	mov    0xc(%eax),%eax
  80255d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802560:	0f 86 c6 00 00 00    	jbe    80262c <alloc_block_FF+0x187>
				{
					// the new block are created
					tmp_block = AvailableMemBlocksList.lh_first ;
  802566:	a1 48 41 80 00       	mov    0x804148,%eax
  80256b:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  80256e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802572:	75 17                	jne    80258b <alloc_block_FF+0xe6>
  802574:	83 ec 04             	sub    $0x4,%esp
  802577:	68 5b 3c 80 00       	push   $0x803c5b
  80257c:	68 c2 00 00 00       	push   $0xc2
  802581:	68 b3 3b 80 00       	push   $0x803bb3
  802586:	e8 aa dd ff ff       	call   800335 <_panic>
  80258b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80258e:	8b 00                	mov    (%eax),%eax
  802590:	85 c0                	test   %eax,%eax
  802592:	74 10                	je     8025a4 <alloc_block_FF+0xff>
  802594:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802597:	8b 00                	mov    (%eax),%eax
  802599:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80259c:	8b 52 04             	mov    0x4(%edx),%edx
  80259f:	89 50 04             	mov    %edx,0x4(%eax)
  8025a2:	eb 0b                	jmp    8025af <alloc_block_FF+0x10a>
  8025a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025a7:	8b 40 04             	mov    0x4(%eax),%eax
  8025aa:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8025af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b2:	8b 40 04             	mov    0x4(%eax),%eax
  8025b5:	85 c0                	test   %eax,%eax
  8025b7:	74 0f                	je     8025c8 <alloc_block_FF+0x123>
  8025b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025bc:	8b 40 04             	mov    0x4(%eax),%eax
  8025bf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025c2:	8b 12                	mov    (%edx),%edx
  8025c4:	89 10                	mov    %edx,(%eax)
  8025c6:	eb 0a                	jmp    8025d2 <alloc_block_FF+0x12d>
  8025c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025cb:	8b 00                	mov    (%eax),%eax
  8025cd:	a3 48 41 80 00       	mov    %eax,0x804148
  8025d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025d5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025de:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025e5:	a1 54 41 80 00       	mov    0x804154,%eax
  8025ea:	48                   	dec    %eax
  8025eb:	a3 54 41 80 00       	mov    %eax,0x804154
					tmp_block->sva=element->sva;
  8025f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f3:	8b 50 08             	mov    0x8(%eax),%edx
  8025f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025f9:	89 50 08             	mov    %edx,0x8(%eax)
					tmp_block->size=size;
  8025fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ff:	8b 55 08             	mov    0x8(%ebp),%edx
  802602:	89 50 0c             	mov    %edx,0xc(%eax)
					//update block with remaining space
					element->size-=size;
  802605:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802608:	8b 40 0c             	mov    0xc(%eax),%eax
  80260b:	2b 45 08             	sub    0x8(%ebp),%eax
  80260e:	89 c2                	mov    %eax,%edx
  802610:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802613:	89 50 0c             	mov    %edx,0xc(%eax)
					element->sva = element->sva + size;
  802616:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802619:	8b 50 08             	mov    0x8(%eax),%edx
  80261c:	8b 45 08             	mov    0x8(%ebp),%eax
  80261f:	01 c2                	add    %eax,%edx
  802621:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802624:	89 50 08             	mov    %edx,0x8(%eax)
					// return back the new block
					return tmp_block ;
  802627:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80262a:	eb 3b                	jmp    802667 <alloc_block_FF+0x1c2>
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  80262c:	a1 40 41 80 00       	mov    0x804140,%eax
  802631:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802634:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802638:	74 07                	je     802641 <alloc_block_FF+0x19c>
  80263a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263d:	8b 00                	mov    (%eax),%eax
  80263f:	eb 05                	jmp    802646 <alloc_block_FF+0x1a1>
  802641:	b8 00 00 00 00       	mov    $0x0,%eax
  802646:	a3 40 41 80 00       	mov    %eax,0x804140
  80264b:	a1 40 41 80 00       	mov    0x804140,%eax
  802650:	85 c0                	test   %eax,%eax
  802652:	0f 85 60 fe ff ff    	jne    8024b8 <alloc_block_FF+0x13>
  802658:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80265c:	0f 85 56 fe ff ff    	jne    8024b8 <alloc_block_FF+0x13>
					// return back the new block
					return tmp_block ;
				}
		}
		// case 1
	  return NULL ;}
  802662:	b8 00 00 00 00       	mov    $0x0,%eax
  802667:	c9                   	leave  
  802668:	c3                   	ret    

00802669 <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================

struct MemBlock *alloc_block_BF(uint32 size)
{
  802669:	55                   	push   %ebp
  80266a:	89 e5                	mov    %esp,%ebp
  80266c:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
  80266f:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802676:	a1 38 41 80 00       	mov    0x804138,%eax
  80267b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80267e:	eb 3a                	jmp    8026ba <alloc_block_BF+0x51>
		{
			if(element->size >= size)
  802680:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802683:	8b 40 0c             	mov    0xc(%eax),%eax
  802686:	3b 45 08             	cmp    0x8(%ebp),%eax
  802689:	72 27                	jb     8026b2 <alloc_block_BF+0x49>
			{
				if(best_size==-1)
  80268b:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80268f:	75 0b                	jne    80269c <alloc_block_BF+0x33>
					best_size= element->size;
  802691:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802694:	8b 40 0c             	mov    0xc(%eax),%eax
  802697:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80269a:	eb 16                	jmp    8026b2 <alloc_block_BF+0x49>
				else if(best_size >= element->size)
  80269c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269f:	8b 50 0c             	mov    0xc(%eax),%edx
  8026a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026a5:	39 c2                	cmp    %eax,%edx
  8026a7:	77 09                	ja     8026b2 <alloc_block_BF+0x49>
					best_size=element->size;
  8026a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ac:	8b 40 0c             	mov    0xc(%eax),%eax
  8026af:	89 45 f0             	mov    %eax,-0x10(%ebp)

struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  8026b2:	a1 40 41 80 00       	mov    0x804140,%eax
  8026b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026be:	74 07                	je     8026c7 <alloc_block_BF+0x5e>
  8026c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c3:	8b 00                	mov    (%eax),%eax
  8026c5:	eb 05                	jmp    8026cc <alloc_block_BF+0x63>
  8026c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8026cc:	a3 40 41 80 00       	mov    %eax,0x804140
  8026d1:	a1 40 41 80 00       	mov    0x804140,%eax
  8026d6:	85 c0                	test   %eax,%eax
  8026d8:	75 a6                	jne    802680 <alloc_block_BF+0x17>
  8026da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026de:	75 a0                	jne    802680 <alloc_block_BF+0x17>
					best_size= element->size;
				else if(best_size >= element->size)
					best_size=element->size;
			}
		}
		if(best_size != -1)
  8026e0:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8026e4:	0f 84 d3 01 00 00    	je     8028bd <alloc_block_BF+0x254>
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  8026ea:	a1 38 41 80 00       	mov    0x804138,%eax
  8026ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026f2:	e9 98 01 00 00       	jmp    80288f <alloc_block_BF+0x226>
			{
			 if((best_size > size) && (best_size == element->size))
  8026f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026fa:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026fd:	0f 86 da 00 00 00    	jbe    8027dd <alloc_block_BF+0x174>
  802703:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802706:	8b 50 0c             	mov    0xc(%eax),%edx
  802709:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80270c:	39 c2                	cmp    %eax,%edx
  80270e:	0f 85 c9 00 00 00    	jne    8027dd <alloc_block_BF+0x174>
			  {
				// the new block are created
			    tmp_block = AvailableMemBlocksList.lh_first ;
  802714:	a1 48 41 80 00       	mov    0x804148,%eax
  802719:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  80271c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802720:	75 17                	jne    802739 <alloc_block_BF+0xd0>
  802722:	83 ec 04             	sub    $0x4,%esp
  802725:	68 5b 3c 80 00       	push   $0x803c5b
  80272a:	68 ea 00 00 00       	push   $0xea
  80272f:	68 b3 3b 80 00       	push   $0x803bb3
  802734:	e8 fc db ff ff       	call   800335 <_panic>
  802739:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80273c:	8b 00                	mov    (%eax),%eax
  80273e:	85 c0                	test   %eax,%eax
  802740:	74 10                	je     802752 <alloc_block_BF+0xe9>
  802742:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802745:	8b 00                	mov    (%eax),%eax
  802747:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80274a:	8b 52 04             	mov    0x4(%edx),%edx
  80274d:	89 50 04             	mov    %edx,0x4(%eax)
  802750:	eb 0b                	jmp    80275d <alloc_block_BF+0xf4>
  802752:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802755:	8b 40 04             	mov    0x4(%eax),%eax
  802758:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80275d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802760:	8b 40 04             	mov    0x4(%eax),%eax
  802763:	85 c0                	test   %eax,%eax
  802765:	74 0f                	je     802776 <alloc_block_BF+0x10d>
  802767:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80276a:	8b 40 04             	mov    0x4(%eax),%eax
  80276d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802770:	8b 12                	mov    (%edx),%edx
  802772:	89 10                	mov    %edx,(%eax)
  802774:	eb 0a                	jmp    802780 <alloc_block_BF+0x117>
  802776:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802779:	8b 00                	mov    (%eax),%eax
  80277b:	a3 48 41 80 00       	mov    %eax,0x804148
  802780:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802783:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802789:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80278c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802793:	a1 54 41 80 00       	mov    0x804154,%eax
  802798:	48                   	dec    %eax
  802799:	a3 54 41 80 00       	mov    %eax,0x804154
				tmp_block->sva=element->sva;
  80279e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a1:	8b 50 08             	mov    0x8(%eax),%edx
  8027a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027a7:	89 50 08             	mov    %edx,0x8(%eax)
				tmp_block->size=size;
  8027aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8027b0:	89 50 0c             	mov    %edx,0xc(%eax)
				//update block with remaining space
				element->size-=size;
  8027b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8027b9:	2b 45 08             	sub    0x8(%ebp),%eax
  8027bc:	89 c2                	mov    %eax,%edx
  8027be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c1:	89 50 0c             	mov    %edx,0xc(%eax)
				element->sva = element->sva + size;
  8027c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c7:	8b 50 08             	mov    0x8(%eax),%edx
  8027ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8027cd:	01 c2                	add    %eax,%edx
  8027cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d2:	89 50 08             	mov    %edx,0x8(%eax)
				// return back the new block
				return tmp_block ;
  8027d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027d8:	e9 e5 00 00 00       	jmp    8028c2 <alloc_block_BF+0x259>

			  }
			else if((element->size == best_size)&&(best_size == size))
  8027dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e0:	8b 50 0c             	mov    0xc(%eax),%edx
  8027e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e6:	39 c2                	cmp    %eax,%edx
  8027e8:	0f 85 99 00 00 00    	jne    802887 <alloc_block_BF+0x21e>
  8027ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027f4:	0f 85 8d 00 00 00    	jne    802887 <alloc_block_BF+0x21e>
			  {
				tmp_block=element;
  8027fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fd:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&FreeMemBlocksList,element);
  802800:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802804:	75 17                	jne    80281d <alloc_block_BF+0x1b4>
  802806:	83 ec 04             	sub    $0x4,%esp
  802809:	68 5b 3c 80 00       	push   $0x803c5b
  80280e:	68 f7 00 00 00       	push   $0xf7
  802813:	68 b3 3b 80 00       	push   $0x803bb3
  802818:	e8 18 db ff ff       	call   800335 <_panic>
  80281d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802820:	8b 00                	mov    (%eax),%eax
  802822:	85 c0                	test   %eax,%eax
  802824:	74 10                	je     802836 <alloc_block_BF+0x1cd>
  802826:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802829:	8b 00                	mov    (%eax),%eax
  80282b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80282e:	8b 52 04             	mov    0x4(%edx),%edx
  802831:	89 50 04             	mov    %edx,0x4(%eax)
  802834:	eb 0b                	jmp    802841 <alloc_block_BF+0x1d8>
  802836:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802839:	8b 40 04             	mov    0x4(%eax),%eax
  80283c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802841:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802844:	8b 40 04             	mov    0x4(%eax),%eax
  802847:	85 c0                	test   %eax,%eax
  802849:	74 0f                	je     80285a <alloc_block_BF+0x1f1>
  80284b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284e:	8b 40 04             	mov    0x4(%eax),%eax
  802851:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802854:	8b 12                	mov    (%edx),%edx
  802856:	89 10                	mov    %edx,(%eax)
  802858:	eb 0a                	jmp    802864 <alloc_block_BF+0x1fb>
  80285a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285d:	8b 00                	mov    (%eax),%eax
  80285f:	a3 38 41 80 00       	mov    %eax,0x804138
  802864:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802867:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80286d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802870:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802877:	a1 44 41 80 00       	mov    0x804144,%eax
  80287c:	48                   	dec    %eax
  80287d:	a3 44 41 80 00       	mov    %eax,0x804144
				return tmp_block;
  802882:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802885:	eb 3b                	jmp    8028c2 <alloc_block_BF+0x259>
					best_size=element->size;
			}
		}
		if(best_size != -1)
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  802887:	a1 40 41 80 00       	mov    0x804140,%eax
  80288c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80288f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802893:	74 07                	je     80289c <alloc_block_BF+0x233>
  802895:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802898:	8b 00                	mov    (%eax),%eax
  80289a:	eb 05                	jmp    8028a1 <alloc_block_BF+0x238>
  80289c:	b8 00 00 00 00       	mov    $0x0,%eax
  8028a1:	a3 40 41 80 00       	mov    %eax,0x804140
  8028a6:	a1 40 41 80 00       	mov    0x804140,%eax
  8028ab:	85 c0                	test   %eax,%eax
  8028ad:	0f 85 44 fe ff ff    	jne    8026f7 <alloc_block_BF+0x8e>
  8028b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028b7:	0f 85 3a fe ff ff    	jne    8026f7 <alloc_block_BF+0x8e>
				LIST_REMOVE(&FreeMemBlocksList,element);
				return tmp_block;
			 }
			}
		}
		return NULL ;}
  8028bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8028c2:	c9                   	leave  
  8028c3:	c3                   	ret    

008028c4 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8028c4:	55                   	push   %ebp
  8028c5:	89 e5                	mov    %esp,%ebp
  8028c7:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  8028ca:	83 ec 04             	sub    $0x4,%esp
  8028cd:	68 7c 3c 80 00       	push   $0x803c7c
  8028d2:	68 04 01 00 00       	push   $0x104
  8028d7:	68 b3 3b 80 00       	push   $0x803bb3
  8028dc:	e8 54 da ff ff       	call   800335 <_panic>

008028e1 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{struct MemBlock * blk_itr;
  8028e1:	55                   	push   %ebp
  8028e2:	89 e5                	mov    %esp,%ebp
  8028e4:	83 ec 18             	sub    $0x18,%esp
struct MemBlock * next;
struct MemBlock * first = LIST_FIRST(&(FreeMemBlocksList));
  8028e7:	a1 38 41 80 00       	mov    0x804138,%eax
  8028ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
struct MemBlock * last = LIST_LAST(&(FreeMemBlocksList));
  8028ef:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8028f4:	89 45 ec             	mov    %eax,-0x14(%ebp)

if(LIST_EMPTY(&(FreeMemBlocksList)))
  8028f7:	a1 38 41 80 00       	mov    0x804138,%eax
  8028fc:	85 c0                	test   %eax,%eax
  8028fe:	75 68                	jne    802968 <insert_sorted_with_merge_freeList+0x87>
			{

				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  802900:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802904:	75 17                	jne    80291d <insert_sorted_with_merge_freeList+0x3c>
  802906:	83 ec 04             	sub    $0x4,%esp
  802909:	68 90 3b 80 00       	push   $0x803b90
  80290e:	68 14 01 00 00       	push   $0x114
  802913:	68 b3 3b 80 00       	push   $0x803bb3
  802918:	e8 18 da ff ff       	call   800335 <_panic>
  80291d:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802923:	8b 45 08             	mov    0x8(%ebp),%eax
  802926:	89 10                	mov    %edx,(%eax)
  802928:	8b 45 08             	mov    0x8(%ebp),%eax
  80292b:	8b 00                	mov    (%eax),%eax
  80292d:	85 c0                	test   %eax,%eax
  80292f:	74 0d                	je     80293e <insert_sorted_with_merge_freeList+0x5d>
  802931:	a1 38 41 80 00       	mov    0x804138,%eax
  802936:	8b 55 08             	mov    0x8(%ebp),%edx
  802939:	89 50 04             	mov    %edx,0x4(%eax)
  80293c:	eb 08                	jmp    802946 <insert_sorted_with_merge_freeList+0x65>
  80293e:	8b 45 08             	mov    0x8(%ebp),%eax
  802941:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802946:	8b 45 08             	mov    0x8(%ebp),%eax
  802949:	a3 38 41 80 00       	mov    %eax,0x804138
  80294e:	8b 45 08             	mov    0x8(%ebp),%eax
  802951:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802958:	a1 44 41 80 00       	mov    0x804144,%eax
  80295d:	40                   	inc    %eax
  80295e:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  802963:	e9 d2 06 00 00       	jmp    80303a <insert_sorted_with_merge_freeList+0x759>
				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);

			}
else
{
	if( blockToInsert->sva  < first->sva )
  802968:	8b 45 08             	mov    0x8(%ebp),%eax
  80296b:	8b 50 08             	mov    0x8(%eax),%edx
  80296e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802971:	8b 40 08             	mov    0x8(%eax),%eax
  802974:	39 c2                	cmp    %eax,%edx
  802976:	0f 83 22 01 00 00    	jae    802a9e <insert_sorted_with_merge_freeList+0x1bd>
	{
                if( blockToInsert->sva + blockToInsert->size == first->sva)
  80297c:	8b 45 08             	mov    0x8(%ebp),%eax
  80297f:	8b 50 08             	mov    0x8(%eax),%edx
  802982:	8b 45 08             	mov    0x8(%ebp),%eax
  802985:	8b 40 0c             	mov    0xc(%eax),%eax
  802988:	01 c2                	add    %eax,%edx
  80298a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80298d:	8b 40 08             	mov    0x8(%eax),%eax
  802990:	39 c2                	cmp    %eax,%edx
  802992:	0f 85 9e 00 00 00    	jne    802a36 <insert_sorted_with_merge_freeList+0x155>
                {

                	first->sva = blockToInsert->sva;
  802998:	8b 45 08             	mov    0x8(%ebp),%eax
  80299b:	8b 50 08             	mov    0x8(%eax),%edx
  80299e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a1:	89 50 08             	mov    %edx,0x8(%eax)
                	first->size = first->size + blockToInsert->size;
  8029a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a7:	8b 50 0c             	mov    0xc(%eax),%edx
  8029aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ad:	8b 40 0c             	mov    0xc(%eax),%eax
  8029b0:	01 c2                	add    %eax,%edx
  8029b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029b5:	89 50 0c             	mov    %edx,0xc(%eax)
                	blockToInsert->size = blockToInsert->sva = 0;
  8029b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029bb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8029c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c5:	8b 50 08             	mov    0x8(%eax),%edx
  8029c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029cb:	89 50 0c             	mov    %edx,0xc(%eax)
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  8029ce:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029d2:	75 17                	jne    8029eb <insert_sorted_with_merge_freeList+0x10a>
  8029d4:	83 ec 04             	sub    $0x4,%esp
  8029d7:	68 90 3b 80 00       	push   $0x803b90
  8029dc:	68 21 01 00 00       	push   $0x121
  8029e1:	68 b3 3b 80 00       	push   $0x803bb3
  8029e6:	e8 4a d9 ff ff       	call   800335 <_panic>
  8029eb:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8029f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f4:	89 10                	mov    %edx,(%eax)
  8029f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f9:	8b 00                	mov    (%eax),%eax
  8029fb:	85 c0                	test   %eax,%eax
  8029fd:	74 0d                	je     802a0c <insert_sorted_with_merge_freeList+0x12b>
  8029ff:	a1 48 41 80 00       	mov    0x804148,%eax
  802a04:	8b 55 08             	mov    0x8(%ebp),%edx
  802a07:	89 50 04             	mov    %edx,0x4(%eax)
  802a0a:	eb 08                	jmp    802a14 <insert_sorted_with_merge_freeList+0x133>
  802a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a14:	8b 45 08             	mov    0x8(%ebp),%eax
  802a17:	a3 48 41 80 00       	mov    %eax,0x804148
  802a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a26:	a1 54 41 80 00       	mov    0x804154,%eax
  802a2b:	40                   	inc    %eax
  802a2c:	a3 54 41 80 00       	mov    %eax,0x804154
						}
				}
        }

}
}
  802a31:	e9 04 06 00 00       	jmp    80303a <insert_sorted_with_merge_freeList+0x759>
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
                }

                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  802a36:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a3a:	75 17                	jne    802a53 <insert_sorted_with_merge_freeList+0x172>
  802a3c:	83 ec 04             	sub    $0x4,%esp
  802a3f:	68 90 3b 80 00       	push   $0x803b90
  802a44:	68 26 01 00 00       	push   $0x126
  802a49:	68 b3 3b 80 00       	push   $0x803bb3
  802a4e:	e8 e2 d8 ff ff       	call   800335 <_panic>
  802a53:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802a59:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5c:	89 10                	mov    %edx,(%eax)
  802a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a61:	8b 00                	mov    (%eax),%eax
  802a63:	85 c0                	test   %eax,%eax
  802a65:	74 0d                	je     802a74 <insert_sorted_with_merge_freeList+0x193>
  802a67:	a1 38 41 80 00       	mov    0x804138,%eax
  802a6c:	8b 55 08             	mov    0x8(%ebp),%edx
  802a6f:	89 50 04             	mov    %edx,0x4(%eax)
  802a72:	eb 08                	jmp    802a7c <insert_sorted_with_merge_freeList+0x19b>
  802a74:	8b 45 08             	mov    0x8(%ebp),%eax
  802a77:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7f:	a3 38 41 80 00       	mov    %eax,0x804138
  802a84:	8b 45 08             	mov    0x8(%ebp),%eax
  802a87:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a8e:	a1 44 41 80 00       	mov    0x804144,%eax
  802a93:	40                   	inc    %eax
  802a94:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  802a99:	e9 9c 05 00 00       	jmp    80303a <insert_sorted_with_merge_freeList+0x759>
                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
                }
	}
    else if(blockToInsert->sva > last->sva)
  802a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa1:	8b 50 08             	mov    0x8(%eax),%edx
  802aa4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aa7:	8b 40 08             	mov    0x8(%eax),%eax
  802aaa:	39 c2                	cmp    %eax,%edx
  802aac:	0f 86 16 01 00 00    	jbe    802bc8 <insert_sorted_with_merge_freeList+0x2e7>
 	{

				if(last->sva + last->size == blockToInsert->sva)
  802ab2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ab5:	8b 50 08             	mov    0x8(%eax),%edx
  802ab8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802abb:	8b 40 0c             	mov    0xc(%eax),%eax
  802abe:	01 c2                	add    %eax,%edx
  802ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac3:	8b 40 08             	mov    0x8(%eax),%eax
  802ac6:	39 c2                	cmp    %eax,%edx
  802ac8:	0f 85 92 00 00 00    	jne    802b60 <insert_sorted_with_merge_freeList+0x27f>
				{

					last->size = last->size + blockToInsert->size;
  802ace:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ad1:	8b 50 0c             	mov    0xc(%eax),%edx
  802ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad7:	8b 40 0c             	mov    0xc(%eax),%eax
  802ada:	01 c2                	add    %eax,%edx
  802adc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802adf:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->size = blockToInsert->sva = 0;
  802ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802aec:	8b 45 08             	mov    0x8(%ebp),%eax
  802aef:	8b 50 08             	mov    0x8(%eax),%edx
  802af2:	8b 45 08             	mov    0x8(%ebp),%eax
  802af5:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802af8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802afc:	75 17                	jne    802b15 <insert_sorted_with_merge_freeList+0x234>
  802afe:	83 ec 04             	sub    $0x4,%esp
  802b01:	68 90 3b 80 00       	push   $0x803b90
  802b06:	68 31 01 00 00       	push   $0x131
  802b0b:	68 b3 3b 80 00       	push   $0x803bb3
  802b10:	e8 20 d8 ff ff       	call   800335 <_panic>
  802b15:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1e:	89 10                	mov    %edx,(%eax)
  802b20:	8b 45 08             	mov    0x8(%ebp),%eax
  802b23:	8b 00                	mov    (%eax),%eax
  802b25:	85 c0                	test   %eax,%eax
  802b27:	74 0d                	je     802b36 <insert_sorted_with_merge_freeList+0x255>
  802b29:	a1 48 41 80 00       	mov    0x804148,%eax
  802b2e:	8b 55 08             	mov    0x8(%ebp),%edx
  802b31:	89 50 04             	mov    %edx,0x4(%eax)
  802b34:	eb 08                	jmp    802b3e <insert_sorted_with_merge_freeList+0x25d>
  802b36:	8b 45 08             	mov    0x8(%ebp),%eax
  802b39:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b41:	a3 48 41 80 00       	mov    %eax,0x804148
  802b46:	8b 45 08             	mov    0x8(%ebp),%eax
  802b49:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b50:	a1 54 41 80 00       	mov    0x804154,%eax
  802b55:	40                   	inc    %eax
  802b56:	a3 54 41 80 00       	mov    %eax,0x804154
						}
				}
        }

}
}
  802b5b:	e9 da 04 00 00       	jmp    80303a <insert_sorted_with_merge_freeList+0x759>

				}

				else
				{
					LIST_INSERT_TAIL(&(FreeMemBlocksList),  blockToInsert);
  802b60:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b64:	75 17                	jne    802b7d <insert_sorted_with_merge_freeList+0x29c>
  802b66:	83 ec 04             	sub    $0x4,%esp
  802b69:	68 38 3c 80 00       	push   $0x803c38
  802b6e:	68 37 01 00 00       	push   $0x137
  802b73:	68 b3 3b 80 00       	push   $0x803bb3
  802b78:	e8 b8 d7 ff ff       	call   800335 <_panic>
  802b7d:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802b83:	8b 45 08             	mov    0x8(%ebp),%eax
  802b86:	89 50 04             	mov    %edx,0x4(%eax)
  802b89:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8c:	8b 40 04             	mov    0x4(%eax),%eax
  802b8f:	85 c0                	test   %eax,%eax
  802b91:	74 0c                	je     802b9f <insert_sorted_with_merge_freeList+0x2be>
  802b93:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b98:	8b 55 08             	mov    0x8(%ebp),%edx
  802b9b:	89 10                	mov    %edx,(%eax)
  802b9d:	eb 08                	jmp    802ba7 <insert_sorted_with_merge_freeList+0x2c6>
  802b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba2:	a3 38 41 80 00       	mov    %eax,0x804138
  802ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  802baa:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802baf:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bb8:	a1 44 41 80 00       	mov    0x804144,%eax
  802bbd:	40                   	inc    %eax
  802bbe:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  802bc3:	e9 72 04 00 00       	jmp    80303a <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  802bc8:	a1 38 41 80 00       	mov    0x804138,%eax
  802bcd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bd0:	e9 35 04 00 00       	jmp    80300a <insert_sorted_with_merge_freeList+0x729>
				{
				     next=LIST_NEXT(blk_itr);
  802bd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd8:	8b 00                	mov    (%eax),%eax
  802bda:	89 45 e8             	mov    %eax,-0x18(%ebp)


					if( (blockToInsert->sva > blk_itr->sva) )
  802bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  802be0:	8b 50 08             	mov    0x8(%eax),%edx
  802be3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be6:	8b 40 08             	mov    0x8(%eax),%eax
  802be9:	39 c2                	cmp    %eax,%edx
  802beb:	0f 86 11 04 00 00    	jbe    803002 <insert_sorted_with_merge_freeList+0x721>
						{
							if(((blk_itr->sva) + (blk_itr->size) < blockToInsert->sva && (blockToInsert->sva) + (blockToInsert->size) < next->sva))
  802bf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf4:	8b 50 08             	mov    0x8(%eax),%edx
  802bf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfa:	8b 40 0c             	mov    0xc(%eax),%eax
  802bfd:	01 c2                	add    %eax,%edx
  802bff:	8b 45 08             	mov    0x8(%ebp),%eax
  802c02:	8b 40 08             	mov    0x8(%eax),%eax
  802c05:	39 c2                	cmp    %eax,%edx
  802c07:	0f 83 8b 00 00 00    	jae    802c98 <insert_sorted_with_merge_freeList+0x3b7>
  802c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c10:	8b 50 08             	mov    0x8(%eax),%edx
  802c13:	8b 45 08             	mov    0x8(%ebp),%eax
  802c16:	8b 40 0c             	mov    0xc(%eax),%eax
  802c19:	01 c2                	add    %eax,%edx
  802c1b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c1e:	8b 40 08             	mov    0x8(%eax),%eax
  802c21:	39 c2                	cmp    %eax,%edx
  802c23:	73 73                	jae    802c98 <insert_sorted_with_merge_freeList+0x3b7>
							{
								LIST_INSERT_AFTER(&(FreeMemBlocksList), blk_itr, blockToInsert);
  802c25:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c29:	74 06                	je     802c31 <insert_sorted_with_merge_freeList+0x350>
  802c2b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c2f:	75 17                	jne    802c48 <insert_sorted_with_merge_freeList+0x367>
  802c31:	83 ec 04             	sub    $0x4,%esp
  802c34:	68 04 3c 80 00       	push   $0x803c04
  802c39:	68 48 01 00 00       	push   $0x148
  802c3e:	68 b3 3b 80 00       	push   $0x803bb3
  802c43:	e8 ed d6 ff ff       	call   800335 <_panic>
  802c48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4b:	8b 10                	mov    (%eax),%edx
  802c4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c50:	89 10                	mov    %edx,(%eax)
  802c52:	8b 45 08             	mov    0x8(%ebp),%eax
  802c55:	8b 00                	mov    (%eax),%eax
  802c57:	85 c0                	test   %eax,%eax
  802c59:	74 0b                	je     802c66 <insert_sorted_with_merge_freeList+0x385>
  802c5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5e:	8b 00                	mov    (%eax),%eax
  802c60:	8b 55 08             	mov    0x8(%ebp),%edx
  802c63:	89 50 04             	mov    %edx,0x4(%eax)
  802c66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c69:	8b 55 08             	mov    0x8(%ebp),%edx
  802c6c:	89 10                	mov    %edx,(%eax)
  802c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c71:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c74:	89 50 04             	mov    %edx,0x4(%eax)
  802c77:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7a:	8b 00                	mov    (%eax),%eax
  802c7c:	85 c0                	test   %eax,%eax
  802c7e:	75 08                	jne    802c88 <insert_sorted_with_merge_freeList+0x3a7>
  802c80:	8b 45 08             	mov    0x8(%ebp),%eax
  802c83:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c88:	a1 44 41 80 00       	mov    0x804144,%eax
  802c8d:	40                   	inc    %eax
  802c8e:	a3 44 41 80 00       	mov    %eax,0x804144
								break;
  802c93:	e9 a2 03 00 00       	jmp    80303a <insert_sorted_with_merge_freeList+0x759>

							}
							else if((blockToInsert->sva + blockToInsert->size) < next->sva  && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  802c98:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9b:	8b 50 08             	mov    0x8(%eax),%edx
  802c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ca4:	01 c2                	add    %eax,%edx
  802ca6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ca9:	8b 40 08             	mov    0x8(%eax),%eax
  802cac:	39 c2                	cmp    %eax,%edx
  802cae:	0f 83 ae 00 00 00    	jae    802d62 <insert_sorted_with_merge_freeList+0x481>
  802cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb7:	8b 50 08             	mov    0x8(%eax),%edx
  802cba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbd:	8b 48 08             	mov    0x8(%eax),%ecx
  802cc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc3:	8b 40 0c             	mov    0xc(%eax),%eax
  802cc6:	01 c8                	add    %ecx,%eax
  802cc8:	39 c2                	cmp    %eax,%edx
  802cca:	0f 85 92 00 00 00    	jne    802d62 <insert_sorted_with_merge_freeList+0x481>
							{

								blk_itr->size=blk_itr->size+blockToInsert->size;
  802cd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd3:	8b 50 0c             	mov    0xc(%eax),%edx
  802cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd9:	8b 40 0c             	mov    0xc(%eax),%eax
  802cdc:	01 c2                	add    %eax,%edx
  802cde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce1:	89 50 0c             	mov    %edx,0xc(%eax)
								 blockToInsert->size=blockToInsert->sva=0;
  802ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802cee:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf1:	8b 50 08             	mov    0x8(%eax),%edx
  802cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf7:	89 50 0c             	mov    %edx,0xc(%eax)
								 LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802cfa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cfe:	75 17                	jne    802d17 <insert_sorted_with_merge_freeList+0x436>
  802d00:	83 ec 04             	sub    $0x4,%esp
  802d03:	68 90 3b 80 00       	push   $0x803b90
  802d08:	68 51 01 00 00       	push   $0x151
  802d0d:	68 b3 3b 80 00       	push   $0x803bb3
  802d12:	e8 1e d6 ff ff       	call   800335 <_panic>
  802d17:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d20:	89 10                	mov    %edx,(%eax)
  802d22:	8b 45 08             	mov    0x8(%ebp),%eax
  802d25:	8b 00                	mov    (%eax),%eax
  802d27:	85 c0                	test   %eax,%eax
  802d29:	74 0d                	je     802d38 <insert_sorted_with_merge_freeList+0x457>
  802d2b:	a1 48 41 80 00       	mov    0x804148,%eax
  802d30:	8b 55 08             	mov    0x8(%ebp),%edx
  802d33:	89 50 04             	mov    %edx,0x4(%eax)
  802d36:	eb 08                	jmp    802d40 <insert_sorted_with_merge_freeList+0x45f>
  802d38:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d40:	8b 45 08             	mov    0x8(%ebp),%eax
  802d43:	a3 48 41 80 00       	mov    %eax,0x804148
  802d48:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d52:	a1 54 41 80 00       	mov    0x804154,%eax
  802d57:	40                   	inc    %eax
  802d58:	a3 54 41 80 00       	mov    %eax,0x804154
								 break;
  802d5d:	e9 d8 02 00 00       	jmp    80303a <insert_sorted_with_merge_freeList+0x759>

							}
							else if( (blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva > (blk_itr->sva + blk_itr->size))
  802d62:	8b 45 08             	mov    0x8(%ebp),%eax
  802d65:	8b 50 08             	mov    0x8(%eax),%edx
  802d68:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6b:	8b 40 0c             	mov    0xc(%eax),%eax
  802d6e:	01 c2                	add    %eax,%edx
  802d70:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d73:	8b 40 08             	mov    0x8(%eax),%eax
  802d76:	39 c2                	cmp    %eax,%edx
  802d78:	0f 85 ba 00 00 00    	jne    802e38 <insert_sorted_with_merge_freeList+0x557>
  802d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d81:	8b 50 08             	mov    0x8(%eax),%edx
  802d84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d87:	8b 48 08             	mov    0x8(%eax),%ecx
  802d8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8d:	8b 40 0c             	mov    0xc(%eax),%eax
  802d90:	01 c8                	add    %ecx,%eax
  802d92:	39 c2                	cmp    %eax,%edx
  802d94:	0f 86 9e 00 00 00    	jbe    802e38 <insert_sorted_with_merge_freeList+0x557>
							{
								next->size = next->size + blockToInsert->size;
  802d9a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d9d:	8b 50 0c             	mov    0xc(%eax),%edx
  802da0:	8b 45 08             	mov    0x8(%ebp),%eax
  802da3:	8b 40 0c             	mov    0xc(%eax),%eax
  802da6:	01 c2                	add    %eax,%edx
  802da8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dab:	89 50 0c             	mov    %edx,0xc(%eax)
								next->sva = blockToInsert->sva;
  802dae:	8b 45 08             	mov    0x8(%ebp),%eax
  802db1:	8b 50 08             	mov    0x8(%eax),%edx
  802db4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802db7:	89 50 08             	mov    %edx,0x8(%eax)

								blockToInsert->size = blockToInsert->sva = 0;
  802dba:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc7:	8b 50 08             	mov    0x8(%eax),%edx
  802dca:	8b 45 08             	mov    0x8(%ebp),%eax
  802dcd:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802dd0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dd4:	75 17                	jne    802ded <insert_sorted_with_merge_freeList+0x50c>
  802dd6:	83 ec 04             	sub    $0x4,%esp
  802dd9:	68 90 3b 80 00       	push   $0x803b90
  802dde:	68 5b 01 00 00       	push   $0x15b
  802de3:	68 b3 3b 80 00       	push   $0x803bb3
  802de8:	e8 48 d5 ff ff       	call   800335 <_panic>
  802ded:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802df3:	8b 45 08             	mov    0x8(%ebp),%eax
  802df6:	89 10                	mov    %edx,(%eax)
  802df8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfb:	8b 00                	mov    (%eax),%eax
  802dfd:	85 c0                	test   %eax,%eax
  802dff:	74 0d                	je     802e0e <insert_sorted_with_merge_freeList+0x52d>
  802e01:	a1 48 41 80 00       	mov    0x804148,%eax
  802e06:	8b 55 08             	mov    0x8(%ebp),%edx
  802e09:	89 50 04             	mov    %edx,0x4(%eax)
  802e0c:	eb 08                	jmp    802e16 <insert_sorted_with_merge_freeList+0x535>
  802e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e11:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e16:	8b 45 08             	mov    0x8(%ebp),%eax
  802e19:	a3 48 41 80 00       	mov    %eax,0x804148
  802e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e21:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e28:	a1 54 41 80 00       	mov    0x804154,%eax
  802e2d:	40                   	inc    %eax
  802e2e:	a3 54 41 80 00       	mov    %eax,0x804154
								break;
  802e33:	e9 02 02 00 00       	jmp    80303a <insert_sorted_with_merge_freeList+0x759>
							}
							else if ((blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  802e38:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3b:	8b 50 08             	mov    0x8(%eax),%edx
  802e3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e41:	8b 40 0c             	mov    0xc(%eax),%eax
  802e44:	01 c2                	add    %eax,%edx
  802e46:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e49:	8b 40 08             	mov    0x8(%eax),%eax
  802e4c:	39 c2                	cmp    %eax,%edx
  802e4e:	0f 85 ae 01 00 00    	jne    803002 <insert_sorted_with_merge_freeList+0x721>
  802e54:	8b 45 08             	mov    0x8(%ebp),%eax
  802e57:	8b 50 08             	mov    0x8(%eax),%edx
  802e5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5d:	8b 48 08             	mov    0x8(%eax),%ecx
  802e60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e63:	8b 40 0c             	mov    0xc(%eax),%eax
  802e66:	01 c8                	add    %ecx,%eax
  802e68:	39 c2                	cmp    %eax,%edx
  802e6a:	0f 85 92 01 00 00    	jne    803002 <insert_sorted_with_merge_freeList+0x721>
							{
								blk_itr->size = blk_itr->size + blockToInsert->size + next->size;
  802e70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e73:	8b 50 0c             	mov    0xc(%eax),%edx
  802e76:	8b 45 08             	mov    0x8(%ebp),%eax
  802e79:	8b 40 0c             	mov    0xc(%eax),%eax
  802e7c:	01 c2                	add    %eax,%edx
  802e7e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e81:	8b 40 0c             	mov    0xc(%eax),%eax
  802e84:	01 c2                	add    %eax,%edx
  802e86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e89:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size = blockToInsert->sva=0;
  802e8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802e96:	8b 45 08             	mov    0x8(%ebp),%eax
  802e99:	8b 50 08             	mov    0x8(%eax),%edx
  802e9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9f:	89 50 0c             	mov    %edx,0xc(%eax)
								next->size = next->sva = 0;
  802ea2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ea5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802eac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eaf:	8b 50 08             	mov    0x8(%eax),%edx
  802eb2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eb5:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_REMOVE(&FreeMemBlocksList, next);
  802eb8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ebc:	75 17                	jne    802ed5 <insert_sorted_with_merge_freeList+0x5f4>
  802ebe:	83 ec 04             	sub    $0x4,%esp
  802ec1:	68 5b 3c 80 00       	push   $0x803c5b
  802ec6:	68 63 01 00 00       	push   $0x163
  802ecb:	68 b3 3b 80 00       	push   $0x803bb3
  802ed0:	e8 60 d4 ff ff       	call   800335 <_panic>
  802ed5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ed8:	8b 00                	mov    (%eax),%eax
  802eda:	85 c0                	test   %eax,%eax
  802edc:	74 10                	je     802eee <insert_sorted_with_merge_freeList+0x60d>
  802ede:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ee1:	8b 00                	mov    (%eax),%eax
  802ee3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ee6:	8b 52 04             	mov    0x4(%edx),%edx
  802ee9:	89 50 04             	mov    %edx,0x4(%eax)
  802eec:	eb 0b                	jmp    802ef9 <insert_sorted_with_merge_freeList+0x618>
  802eee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ef1:	8b 40 04             	mov    0x4(%eax),%eax
  802ef4:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ef9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802efc:	8b 40 04             	mov    0x4(%eax),%eax
  802eff:	85 c0                	test   %eax,%eax
  802f01:	74 0f                	je     802f12 <insert_sorted_with_merge_freeList+0x631>
  802f03:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f06:	8b 40 04             	mov    0x4(%eax),%eax
  802f09:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f0c:	8b 12                	mov    (%edx),%edx
  802f0e:	89 10                	mov    %edx,(%eax)
  802f10:	eb 0a                	jmp    802f1c <insert_sorted_with_merge_freeList+0x63b>
  802f12:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f15:	8b 00                	mov    (%eax),%eax
  802f17:	a3 38 41 80 00       	mov    %eax,0x804138
  802f1c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f1f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f25:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f28:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f2f:	a1 44 41 80 00       	mov    0x804144,%eax
  802f34:	48                   	dec    %eax
  802f35:	a3 44 41 80 00       	mov    %eax,0x804144
								LIST_INSERT_HEAD(&AvailableMemBlocksList, next );
  802f3a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f3e:	75 17                	jne    802f57 <insert_sorted_with_merge_freeList+0x676>
  802f40:	83 ec 04             	sub    $0x4,%esp
  802f43:	68 90 3b 80 00       	push   $0x803b90
  802f48:	68 64 01 00 00       	push   $0x164
  802f4d:	68 b3 3b 80 00       	push   $0x803bb3
  802f52:	e8 de d3 ff ff       	call   800335 <_panic>
  802f57:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f5d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f60:	89 10                	mov    %edx,(%eax)
  802f62:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f65:	8b 00                	mov    (%eax),%eax
  802f67:	85 c0                	test   %eax,%eax
  802f69:	74 0d                	je     802f78 <insert_sorted_with_merge_freeList+0x697>
  802f6b:	a1 48 41 80 00       	mov    0x804148,%eax
  802f70:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f73:	89 50 04             	mov    %edx,0x4(%eax)
  802f76:	eb 08                	jmp    802f80 <insert_sorted_with_merge_freeList+0x69f>
  802f78:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f7b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f80:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f83:	a3 48 41 80 00       	mov    %eax,0x804148
  802f88:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f8b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f92:	a1 54 41 80 00       	mov    0x804154,%eax
  802f97:	40                   	inc    %eax
  802f98:	a3 54 41 80 00       	mov    %eax,0x804154
							    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802f9d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fa1:	75 17                	jne    802fba <insert_sorted_with_merge_freeList+0x6d9>
  802fa3:	83 ec 04             	sub    $0x4,%esp
  802fa6:	68 90 3b 80 00       	push   $0x803b90
  802fab:	68 65 01 00 00       	push   $0x165
  802fb0:	68 b3 3b 80 00       	push   $0x803bb3
  802fb5:	e8 7b d3 ff ff       	call   800335 <_panic>
  802fba:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc3:	89 10                	mov    %edx,(%eax)
  802fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc8:	8b 00                	mov    (%eax),%eax
  802fca:	85 c0                	test   %eax,%eax
  802fcc:	74 0d                	je     802fdb <insert_sorted_with_merge_freeList+0x6fa>
  802fce:	a1 48 41 80 00       	mov    0x804148,%eax
  802fd3:	8b 55 08             	mov    0x8(%ebp),%edx
  802fd6:	89 50 04             	mov    %edx,0x4(%eax)
  802fd9:	eb 08                	jmp    802fe3 <insert_sorted_with_merge_freeList+0x702>
  802fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fde:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe6:	a3 48 41 80 00       	mov    %eax,0x804148
  802feb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ff5:	a1 54 41 80 00       	mov    0x804154,%eax
  802ffa:	40                   	inc    %eax
  802ffb:	a3 54 41 80 00       	mov    %eax,0x804154
								break;
  803000:	eb 38                	jmp    80303a <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  803002:	a1 40 41 80 00       	mov    0x804140,%eax
  803007:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80300a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80300e:	74 07                	je     803017 <insert_sorted_with_merge_freeList+0x736>
  803010:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803013:	8b 00                	mov    (%eax),%eax
  803015:	eb 05                	jmp    80301c <insert_sorted_with_merge_freeList+0x73b>
  803017:	b8 00 00 00 00       	mov    $0x0,%eax
  80301c:	a3 40 41 80 00       	mov    %eax,0x804140
  803021:	a1 40 41 80 00       	mov    0x804140,%eax
  803026:	85 c0                	test   %eax,%eax
  803028:	0f 85 a7 fb ff ff    	jne    802bd5 <insert_sorted_with_merge_freeList+0x2f4>
  80302e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803032:	0f 85 9d fb ff ff    	jne    802bd5 <insert_sorted_with_merge_freeList+0x2f4>
						}
				}
        }

}
}
  803038:	eb 00                	jmp    80303a <insert_sorted_with_merge_freeList+0x759>
  80303a:	90                   	nop
  80303b:	c9                   	leave  
  80303c:	c3                   	ret    
  80303d:	66 90                	xchg   %ax,%ax
  80303f:	90                   	nop

00803040 <__udivdi3>:
  803040:	55                   	push   %ebp
  803041:	57                   	push   %edi
  803042:	56                   	push   %esi
  803043:	53                   	push   %ebx
  803044:	83 ec 1c             	sub    $0x1c,%esp
  803047:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80304b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80304f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803053:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803057:	89 ca                	mov    %ecx,%edx
  803059:	89 f8                	mov    %edi,%eax
  80305b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80305f:	85 f6                	test   %esi,%esi
  803061:	75 2d                	jne    803090 <__udivdi3+0x50>
  803063:	39 cf                	cmp    %ecx,%edi
  803065:	77 65                	ja     8030cc <__udivdi3+0x8c>
  803067:	89 fd                	mov    %edi,%ebp
  803069:	85 ff                	test   %edi,%edi
  80306b:	75 0b                	jne    803078 <__udivdi3+0x38>
  80306d:	b8 01 00 00 00       	mov    $0x1,%eax
  803072:	31 d2                	xor    %edx,%edx
  803074:	f7 f7                	div    %edi
  803076:	89 c5                	mov    %eax,%ebp
  803078:	31 d2                	xor    %edx,%edx
  80307a:	89 c8                	mov    %ecx,%eax
  80307c:	f7 f5                	div    %ebp
  80307e:	89 c1                	mov    %eax,%ecx
  803080:	89 d8                	mov    %ebx,%eax
  803082:	f7 f5                	div    %ebp
  803084:	89 cf                	mov    %ecx,%edi
  803086:	89 fa                	mov    %edi,%edx
  803088:	83 c4 1c             	add    $0x1c,%esp
  80308b:	5b                   	pop    %ebx
  80308c:	5e                   	pop    %esi
  80308d:	5f                   	pop    %edi
  80308e:	5d                   	pop    %ebp
  80308f:	c3                   	ret    
  803090:	39 ce                	cmp    %ecx,%esi
  803092:	77 28                	ja     8030bc <__udivdi3+0x7c>
  803094:	0f bd fe             	bsr    %esi,%edi
  803097:	83 f7 1f             	xor    $0x1f,%edi
  80309a:	75 40                	jne    8030dc <__udivdi3+0x9c>
  80309c:	39 ce                	cmp    %ecx,%esi
  80309e:	72 0a                	jb     8030aa <__udivdi3+0x6a>
  8030a0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8030a4:	0f 87 9e 00 00 00    	ja     803148 <__udivdi3+0x108>
  8030aa:	b8 01 00 00 00       	mov    $0x1,%eax
  8030af:	89 fa                	mov    %edi,%edx
  8030b1:	83 c4 1c             	add    $0x1c,%esp
  8030b4:	5b                   	pop    %ebx
  8030b5:	5e                   	pop    %esi
  8030b6:	5f                   	pop    %edi
  8030b7:	5d                   	pop    %ebp
  8030b8:	c3                   	ret    
  8030b9:	8d 76 00             	lea    0x0(%esi),%esi
  8030bc:	31 ff                	xor    %edi,%edi
  8030be:	31 c0                	xor    %eax,%eax
  8030c0:	89 fa                	mov    %edi,%edx
  8030c2:	83 c4 1c             	add    $0x1c,%esp
  8030c5:	5b                   	pop    %ebx
  8030c6:	5e                   	pop    %esi
  8030c7:	5f                   	pop    %edi
  8030c8:	5d                   	pop    %ebp
  8030c9:	c3                   	ret    
  8030ca:	66 90                	xchg   %ax,%ax
  8030cc:	89 d8                	mov    %ebx,%eax
  8030ce:	f7 f7                	div    %edi
  8030d0:	31 ff                	xor    %edi,%edi
  8030d2:	89 fa                	mov    %edi,%edx
  8030d4:	83 c4 1c             	add    $0x1c,%esp
  8030d7:	5b                   	pop    %ebx
  8030d8:	5e                   	pop    %esi
  8030d9:	5f                   	pop    %edi
  8030da:	5d                   	pop    %ebp
  8030db:	c3                   	ret    
  8030dc:	bd 20 00 00 00       	mov    $0x20,%ebp
  8030e1:	89 eb                	mov    %ebp,%ebx
  8030e3:	29 fb                	sub    %edi,%ebx
  8030e5:	89 f9                	mov    %edi,%ecx
  8030e7:	d3 e6                	shl    %cl,%esi
  8030e9:	89 c5                	mov    %eax,%ebp
  8030eb:	88 d9                	mov    %bl,%cl
  8030ed:	d3 ed                	shr    %cl,%ebp
  8030ef:	89 e9                	mov    %ebp,%ecx
  8030f1:	09 f1                	or     %esi,%ecx
  8030f3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8030f7:	89 f9                	mov    %edi,%ecx
  8030f9:	d3 e0                	shl    %cl,%eax
  8030fb:	89 c5                	mov    %eax,%ebp
  8030fd:	89 d6                	mov    %edx,%esi
  8030ff:	88 d9                	mov    %bl,%cl
  803101:	d3 ee                	shr    %cl,%esi
  803103:	89 f9                	mov    %edi,%ecx
  803105:	d3 e2                	shl    %cl,%edx
  803107:	8b 44 24 08          	mov    0x8(%esp),%eax
  80310b:	88 d9                	mov    %bl,%cl
  80310d:	d3 e8                	shr    %cl,%eax
  80310f:	09 c2                	or     %eax,%edx
  803111:	89 d0                	mov    %edx,%eax
  803113:	89 f2                	mov    %esi,%edx
  803115:	f7 74 24 0c          	divl   0xc(%esp)
  803119:	89 d6                	mov    %edx,%esi
  80311b:	89 c3                	mov    %eax,%ebx
  80311d:	f7 e5                	mul    %ebp
  80311f:	39 d6                	cmp    %edx,%esi
  803121:	72 19                	jb     80313c <__udivdi3+0xfc>
  803123:	74 0b                	je     803130 <__udivdi3+0xf0>
  803125:	89 d8                	mov    %ebx,%eax
  803127:	31 ff                	xor    %edi,%edi
  803129:	e9 58 ff ff ff       	jmp    803086 <__udivdi3+0x46>
  80312e:	66 90                	xchg   %ax,%ax
  803130:	8b 54 24 08          	mov    0x8(%esp),%edx
  803134:	89 f9                	mov    %edi,%ecx
  803136:	d3 e2                	shl    %cl,%edx
  803138:	39 c2                	cmp    %eax,%edx
  80313a:	73 e9                	jae    803125 <__udivdi3+0xe5>
  80313c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80313f:	31 ff                	xor    %edi,%edi
  803141:	e9 40 ff ff ff       	jmp    803086 <__udivdi3+0x46>
  803146:	66 90                	xchg   %ax,%ax
  803148:	31 c0                	xor    %eax,%eax
  80314a:	e9 37 ff ff ff       	jmp    803086 <__udivdi3+0x46>
  80314f:	90                   	nop

00803150 <__umoddi3>:
  803150:	55                   	push   %ebp
  803151:	57                   	push   %edi
  803152:	56                   	push   %esi
  803153:	53                   	push   %ebx
  803154:	83 ec 1c             	sub    $0x1c,%esp
  803157:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80315b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80315f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803163:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803167:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80316b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80316f:	89 f3                	mov    %esi,%ebx
  803171:	89 fa                	mov    %edi,%edx
  803173:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803177:	89 34 24             	mov    %esi,(%esp)
  80317a:	85 c0                	test   %eax,%eax
  80317c:	75 1a                	jne    803198 <__umoddi3+0x48>
  80317e:	39 f7                	cmp    %esi,%edi
  803180:	0f 86 a2 00 00 00    	jbe    803228 <__umoddi3+0xd8>
  803186:	89 c8                	mov    %ecx,%eax
  803188:	89 f2                	mov    %esi,%edx
  80318a:	f7 f7                	div    %edi
  80318c:	89 d0                	mov    %edx,%eax
  80318e:	31 d2                	xor    %edx,%edx
  803190:	83 c4 1c             	add    $0x1c,%esp
  803193:	5b                   	pop    %ebx
  803194:	5e                   	pop    %esi
  803195:	5f                   	pop    %edi
  803196:	5d                   	pop    %ebp
  803197:	c3                   	ret    
  803198:	39 f0                	cmp    %esi,%eax
  80319a:	0f 87 ac 00 00 00    	ja     80324c <__umoddi3+0xfc>
  8031a0:	0f bd e8             	bsr    %eax,%ebp
  8031a3:	83 f5 1f             	xor    $0x1f,%ebp
  8031a6:	0f 84 ac 00 00 00    	je     803258 <__umoddi3+0x108>
  8031ac:	bf 20 00 00 00       	mov    $0x20,%edi
  8031b1:	29 ef                	sub    %ebp,%edi
  8031b3:	89 fe                	mov    %edi,%esi
  8031b5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8031b9:	89 e9                	mov    %ebp,%ecx
  8031bb:	d3 e0                	shl    %cl,%eax
  8031bd:	89 d7                	mov    %edx,%edi
  8031bf:	89 f1                	mov    %esi,%ecx
  8031c1:	d3 ef                	shr    %cl,%edi
  8031c3:	09 c7                	or     %eax,%edi
  8031c5:	89 e9                	mov    %ebp,%ecx
  8031c7:	d3 e2                	shl    %cl,%edx
  8031c9:	89 14 24             	mov    %edx,(%esp)
  8031cc:	89 d8                	mov    %ebx,%eax
  8031ce:	d3 e0                	shl    %cl,%eax
  8031d0:	89 c2                	mov    %eax,%edx
  8031d2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031d6:	d3 e0                	shl    %cl,%eax
  8031d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8031dc:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031e0:	89 f1                	mov    %esi,%ecx
  8031e2:	d3 e8                	shr    %cl,%eax
  8031e4:	09 d0                	or     %edx,%eax
  8031e6:	d3 eb                	shr    %cl,%ebx
  8031e8:	89 da                	mov    %ebx,%edx
  8031ea:	f7 f7                	div    %edi
  8031ec:	89 d3                	mov    %edx,%ebx
  8031ee:	f7 24 24             	mull   (%esp)
  8031f1:	89 c6                	mov    %eax,%esi
  8031f3:	89 d1                	mov    %edx,%ecx
  8031f5:	39 d3                	cmp    %edx,%ebx
  8031f7:	0f 82 87 00 00 00    	jb     803284 <__umoddi3+0x134>
  8031fd:	0f 84 91 00 00 00    	je     803294 <__umoddi3+0x144>
  803203:	8b 54 24 04          	mov    0x4(%esp),%edx
  803207:	29 f2                	sub    %esi,%edx
  803209:	19 cb                	sbb    %ecx,%ebx
  80320b:	89 d8                	mov    %ebx,%eax
  80320d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803211:	d3 e0                	shl    %cl,%eax
  803213:	89 e9                	mov    %ebp,%ecx
  803215:	d3 ea                	shr    %cl,%edx
  803217:	09 d0                	or     %edx,%eax
  803219:	89 e9                	mov    %ebp,%ecx
  80321b:	d3 eb                	shr    %cl,%ebx
  80321d:	89 da                	mov    %ebx,%edx
  80321f:	83 c4 1c             	add    $0x1c,%esp
  803222:	5b                   	pop    %ebx
  803223:	5e                   	pop    %esi
  803224:	5f                   	pop    %edi
  803225:	5d                   	pop    %ebp
  803226:	c3                   	ret    
  803227:	90                   	nop
  803228:	89 fd                	mov    %edi,%ebp
  80322a:	85 ff                	test   %edi,%edi
  80322c:	75 0b                	jne    803239 <__umoddi3+0xe9>
  80322e:	b8 01 00 00 00       	mov    $0x1,%eax
  803233:	31 d2                	xor    %edx,%edx
  803235:	f7 f7                	div    %edi
  803237:	89 c5                	mov    %eax,%ebp
  803239:	89 f0                	mov    %esi,%eax
  80323b:	31 d2                	xor    %edx,%edx
  80323d:	f7 f5                	div    %ebp
  80323f:	89 c8                	mov    %ecx,%eax
  803241:	f7 f5                	div    %ebp
  803243:	89 d0                	mov    %edx,%eax
  803245:	e9 44 ff ff ff       	jmp    80318e <__umoddi3+0x3e>
  80324a:	66 90                	xchg   %ax,%ax
  80324c:	89 c8                	mov    %ecx,%eax
  80324e:	89 f2                	mov    %esi,%edx
  803250:	83 c4 1c             	add    $0x1c,%esp
  803253:	5b                   	pop    %ebx
  803254:	5e                   	pop    %esi
  803255:	5f                   	pop    %edi
  803256:	5d                   	pop    %ebp
  803257:	c3                   	ret    
  803258:	3b 04 24             	cmp    (%esp),%eax
  80325b:	72 06                	jb     803263 <__umoddi3+0x113>
  80325d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803261:	77 0f                	ja     803272 <__umoddi3+0x122>
  803263:	89 f2                	mov    %esi,%edx
  803265:	29 f9                	sub    %edi,%ecx
  803267:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80326b:	89 14 24             	mov    %edx,(%esp)
  80326e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803272:	8b 44 24 04          	mov    0x4(%esp),%eax
  803276:	8b 14 24             	mov    (%esp),%edx
  803279:	83 c4 1c             	add    $0x1c,%esp
  80327c:	5b                   	pop    %ebx
  80327d:	5e                   	pop    %esi
  80327e:	5f                   	pop    %edi
  80327f:	5d                   	pop    %ebp
  803280:	c3                   	ret    
  803281:	8d 76 00             	lea    0x0(%esi),%esi
  803284:	2b 04 24             	sub    (%esp),%eax
  803287:	19 fa                	sbb    %edi,%edx
  803289:	89 d1                	mov    %edx,%ecx
  80328b:	89 c6                	mov    %eax,%esi
  80328d:	e9 71 ff ff ff       	jmp    803203 <__umoddi3+0xb3>
  803292:	66 90                	xchg   %ax,%ax
  803294:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803298:	72 ea                	jb     803284 <__umoddi3+0x134>
  80329a:	89 d9                	mov    %ebx,%ecx
  80329c:	e9 62 ff ff ff       	jmp    803203 <__umoddi3+0xb3>
