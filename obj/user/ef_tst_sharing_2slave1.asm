
obj/user/ef_tst_sharing_2slave1:     file format elf32-i386


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
  800031:	e8 1e 02 00 00       	call   800254 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Slave program1: Read the 2 shared variables, edit the 3rd one, and exit
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
  80008d:	68 00 33 80 00       	push   $0x803300
  800092:	6a 13                	push   $0x13
  800094:	68 1c 33 80 00       	push   $0x80331c
  800099:	e8 f2 02 00 00       	call   800390 <_panic>
	}
	uint32 *x,*y,*z;
	int32 parentenvID = sys_getparentenvid();
  80009e:	e8 f4 1b 00 00       	call   801c97 <sys_getparentenvid>
  8000a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//GET: z then y then x, opposite to creation order (x then y then z)
	//So, addresses here will be different from the OWNER addresses
	sys_disable_interrupt();
  8000a6:	e8 e0 19 00 00       	call   801a8b <sys_disable_interrupt>
	int freeFrames = sys_calculate_free_frames() ;
  8000ab:	e8 ee 18 00 00       	call   80199e <sys_calculate_free_frames>
  8000b0:	89 45 e8             	mov    %eax,-0x18(%ebp)
	z = sget(parentenvID,"z");
  8000b3:	83 ec 08             	sub    $0x8,%esp
  8000b6:	68 3a 33 80 00       	push   $0x80333a
  8000bb:	ff 75 ec             	pushl  -0x14(%ebp)
  8000be:	e8 a5 16 00 00       	call   801768 <sget>
  8000c3:	83 c4 10             	add    $0x10,%esp
  8000c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (z != (uint32*)(USER_HEAP_START + 0 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8000c9:	81 7d e4 00 00 00 80 	cmpl   $0x80000000,-0x1c(%ebp)
  8000d0:	74 14                	je     8000e6 <_main+0xae>
  8000d2:	83 ec 04             	sub    $0x4,%esp
  8000d5:	68 3c 33 80 00       	push   $0x80333c
  8000da:	6a 1c                	push   $0x1c
  8000dc:	68 1c 33 80 00       	push   $0x80331c
  8000e1:	e8 aa 02 00 00       	call   800390 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  8000e6:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000e9:	e8 b0 18 00 00       	call   80199e <sys_calculate_free_frames>
  8000ee:	29 c3                	sub    %eax,%ebx
  8000f0:	89 d8                	mov    %ebx,%eax
  8000f2:	83 f8 01             	cmp    $0x1,%eax
  8000f5:	74 14                	je     80010b <_main+0xd3>
  8000f7:	83 ec 04             	sub    $0x4,%esp
  8000fa:	68 9c 33 80 00       	push   $0x80339c
  8000ff:	6a 1d                	push   $0x1d
  800101:	68 1c 33 80 00       	push   $0x80331c
  800106:	e8 85 02 00 00       	call   800390 <_panic>
	sys_enable_interrupt();
  80010b:	e8 95 19 00 00       	call   801aa5 <sys_enable_interrupt>

	sys_disable_interrupt();
  800110:	e8 76 19 00 00       	call   801a8b <sys_disable_interrupt>
	freeFrames = sys_calculate_free_frames() ;
  800115:	e8 84 18 00 00       	call   80199e <sys_calculate_free_frames>
  80011a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	y = sget(parentenvID,"y");
  80011d:	83 ec 08             	sub    $0x8,%esp
  800120:	68 2d 34 80 00       	push   $0x80342d
  800125:	ff 75 ec             	pushl  -0x14(%ebp)
  800128:	e8 3b 16 00 00       	call   801768 <sget>
  80012d:	83 c4 10             	add    $0x10,%esp
  800130:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (y != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  800133:	81 7d e0 00 10 00 80 	cmpl   $0x80001000,-0x20(%ebp)
  80013a:	74 14                	je     800150 <_main+0x118>
  80013c:	83 ec 04             	sub    $0x4,%esp
  80013f:	68 3c 33 80 00       	push   $0x80333c
  800144:	6a 23                	push   $0x23
  800146:	68 1c 33 80 00       	push   $0x80331c
  80014b:	e8 40 02 00 00       	call   800390 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  800150:	e8 49 18 00 00       	call   80199e <sys_calculate_free_frames>
  800155:	89 c2                	mov    %eax,%edx
  800157:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80015a:	39 c2                	cmp    %eax,%edx
  80015c:	74 14                	je     800172 <_main+0x13a>
  80015e:	83 ec 04             	sub    $0x4,%esp
  800161:	68 9c 33 80 00       	push   $0x80339c
  800166:	6a 24                	push   $0x24
  800168:	68 1c 33 80 00       	push   $0x80331c
  80016d:	e8 1e 02 00 00       	call   800390 <_panic>
	sys_enable_interrupt();
  800172:	e8 2e 19 00 00       	call   801aa5 <sys_enable_interrupt>
	
	if (*y != 20) panic("Get(): Shared Variable is not created or got correctly") ;
  800177:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80017a:	8b 00                	mov    (%eax),%eax
  80017c:	83 f8 14             	cmp    $0x14,%eax
  80017f:	74 14                	je     800195 <_main+0x15d>
  800181:	83 ec 04             	sub    $0x4,%esp
  800184:	68 30 34 80 00       	push   $0x803430
  800189:	6a 27                	push   $0x27
  80018b:	68 1c 33 80 00       	push   $0x80331c
  800190:	e8 fb 01 00 00       	call   800390 <_panic>

	sys_disable_interrupt();
  800195:	e8 f1 18 00 00       	call   801a8b <sys_disable_interrupt>
	freeFrames = sys_calculate_free_frames() ;
  80019a:	e8 ff 17 00 00       	call   80199e <sys_calculate_free_frames>
  80019f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	x = sget(parentenvID,"x");
  8001a2:	83 ec 08             	sub    $0x8,%esp
  8001a5:	68 67 34 80 00       	push   $0x803467
  8001aa:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ad:	e8 b6 15 00 00       	call   801768 <sget>
  8001b2:	83 c4 10             	add    $0x10,%esp
  8001b5:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (x != (uint32*)(USER_HEAP_START + 2 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8001b8:	81 7d dc 00 20 00 80 	cmpl   $0x80002000,-0x24(%ebp)
  8001bf:	74 14                	je     8001d5 <_main+0x19d>
  8001c1:	83 ec 04             	sub    $0x4,%esp
  8001c4:	68 3c 33 80 00       	push   $0x80333c
  8001c9:	6a 2c                	push   $0x2c
  8001cb:	68 1c 33 80 00       	push   $0x80331c
  8001d0:	e8 bb 01 00 00       	call   800390 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  8001d5:	e8 c4 17 00 00       	call   80199e <sys_calculate_free_frames>
  8001da:	89 c2                	mov    %eax,%edx
  8001dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001df:	39 c2                	cmp    %eax,%edx
  8001e1:	74 14                	je     8001f7 <_main+0x1bf>
  8001e3:	83 ec 04             	sub    $0x4,%esp
  8001e6:	68 9c 33 80 00       	push   $0x80339c
  8001eb:	6a 2d                	push   $0x2d
  8001ed:	68 1c 33 80 00       	push   $0x80331c
  8001f2:	e8 99 01 00 00       	call   800390 <_panic>
	sys_enable_interrupt();
  8001f7:	e8 a9 18 00 00       	call   801aa5 <sys_enable_interrupt>

	if (*x != 10) panic("Get(): Shared Variable is not created or got correctly") ;
  8001fc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001ff:	8b 00                	mov    (%eax),%eax
  800201:	83 f8 0a             	cmp    $0xa,%eax
  800204:	74 14                	je     80021a <_main+0x1e2>
  800206:	83 ec 04             	sub    $0x4,%esp
  800209:	68 30 34 80 00       	push   $0x803430
  80020e:	6a 30                	push   $0x30
  800210:	68 1c 33 80 00       	push   $0x80331c
  800215:	e8 76 01 00 00       	call   800390 <_panic>

	*z = *x + *y ;
  80021a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80021d:	8b 10                	mov    (%eax),%edx
  80021f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800222:	8b 00                	mov    (%eax),%eax
  800224:	01 c2                	add    %eax,%edx
  800226:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800229:	89 10                	mov    %edx,(%eax)
	if (*z != 30) panic("Get(): Shared Variable is not created or got correctly") ;
  80022b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80022e:	8b 00                	mov    (%eax),%eax
  800230:	83 f8 1e             	cmp    $0x1e,%eax
  800233:	74 14                	je     800249 <_main+0x211>
  800235:	83 ec 04             	sub    $0x4,%esp
  800238:	68 30 34 80 00       	push   $0x803430
  80023d:	6a 33                	push   $0x33
  80023f:	68 1c 33 80 00       	push   $0x80331c
  800244:	e8 47 01 00 00       	call   800390 <_panic>

	//To indicate that it's completed successfully
	inctst();
  800249:	e8 6e 1b 00 00       	call   801dbc <inctst>

	return;
  80024e:	90                   	nop
}
  80024f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800252:	c9                   	leave  
  800253:	c3                   	ret    

00800254 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800254:	55                   	push   %ebp
  800255:	89 e5                	mov    %esp,%ebp
  800257:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80025a:	e8 1f 1a 00 00       	call   801c7e <sys_getenvindex>
  80025f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800262:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800265:	89 d0                	mov    %edx,%eax
  800267:	c1 e0 03             	shl    $0x3,%eax
  80026a:	01 d0                	add    %edx,%eax
  80026c:	01 c0                	add    %eax,%eax
  80026e:	01 d0                	add    %edx,%eax
  800270:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800277:	01 d0                	add    %edx,%eax
  800279:	c1 e0 04             	shl    $0x4,%eax
  80027c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800281:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800286:	a1 20 40 80 00       	mov    0x804020,%eax
  80028b:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800291:	84 c0                	test   %al,%al
  800293:	74 0f                	je     8002a4 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800295:	a1 20 40 80 00       	mov    0x804020,%eax
  80029a:	05 5c 05 00 00       	add    $0x55c,%eax
  80029f:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002a4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002a8:	7e 0a                	jle    8002b4 <libmain+0x60>
		binaryname = argv[0];
  8002aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ad:	8b 00                	mov    (%eax),%eax
  8002af:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8002b4:	83 ec 08             	sub    $0x8,%esp
  8002b7:	ff 75 0c             	pushl  0xc(%ebp)
  8002ba:	ff 75 08             	pushl  0x8(%ebp)
  8002bd:	e8 76 fd ff ff       	call   800038 <_main>
  8002c2:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8002c5:	e8 c1 17 00 00       	call   801a8b <sys_disable_interrupt>
	cprintf("**************************************\n");
  8002ca:	83 ec 0c             	sub    $0xc,%esp
  8002cd:	68 84 34 80 00       	push   $0x803484
  8002d2:	e8 6d 03 00 00       	call   800644 <cprintf>
  8002d7:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002da:	a1 20 40 80 00       	mov    0x804020,%eax
  8002df:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8002e5:	a1 20 40 80 00       	mov    0x804020,%eax
  8002ea:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8002f0:	83 ec 04             	sub    $0x4,%esp
  8002f3:	52                   	push   %edx
  8002f4:	50                   	push   %eax
  8002f5:	68 ac 34 80 00       	push   $0x8034ac
  8002fa:	e8 45 03 00 00       	call   800644 <cprintf>
  8002ff:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800302:	a1 20 40 80 00       	mov    0x804020,%eax
  800307:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80030d:	a1 20 40 80 00       	mov    0x804020,%eax
  800312:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800318:	a1 20 40 80 00       	mov    0x804020,%eax
  80031d:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800323:	51                   	push   %ecx
  800324:	52                   	push   %edx
  800325:	50                   	push   %eax
  800326:	68 d4 34 80 00       	push   $0x8034d4
  80032b:	e8 14 03 00 00       	call   800644 <cprintf>
  800330:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800333:	a1 20 40 80 00       	mov    0x804020,%eax
  800338:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80033e:	83 ec 08             	sub    $0x8,%esp
  800341:	50                   	push   %eax
  800342:	68 2c 35 80 00       	push   $0x80352c
  800347:	e8 f8 02 00 00       	call   800644 <cprintf>
  80034c:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80034f:	83 ec 0c             	sub    $0xc,%esp
  800352:	68 84 34 80 00       	push   $0x803484
  800357:	e8 e8 02 00 00       	call   800644 <cprintf>
  80035c:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80035f:	e8 41 17 00 00       	call   801aa5 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800364:	e8 19 00 00 00       	call   800382 <exit>
}
  800369:	90                   	nop
  80036a:	c9                   	leave  
  80036b:	c3                   	ret    

0080036c <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80036c:	55                   	push   %ebp
  80036d:	89 e5                	mov    %esp,%ebp
  80036f:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800372:	83 ec 0c             	sub    $0xc,%esp
  800375:	6a 00                	push   $0x0
  800377:	e8 ce 18 00 00       	call   801c4a <sys_destroy_env>
  80037c:	83 c4 10             	add    $0x10,%esp
}
  80037f:	90                   	nop
  800380:	c9                   	leave  
  800381:	c3                   	ret    

00800382 <exit>:

void
exit(void)
{
  800382:	55                   	push   %ebp
  800383:	89 e5                	mov    %esp,%ebp
  800385:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800388:	e8 23 19 00 00       	call   801cb0 <sys_exit_env>
}
  80038d:	90                   	nop
  80038e:	c9                   	leave  
  80038f:	c3                   	ret    

00800390 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800390:	55                   	push   %ebp
  800391:	89 e5                	mov    %esp,%ebp
  800393:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800396:	8d 45 10             	lea    0x10(%ebp),%eax
  800399:	83 c0 04             	add    $0x4,%eax
  80039c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80039f:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8003a4:	85 c0                	test   %eax,%eax
  8003a6:	74 16                	je     8003be <_panic+0x2e>
		cprintf("%s: ", argv0);
  8003a8:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8003ad:	83 ec 08             	sub    $0x8,%esp
  8003b0:	50                   	push   %eax
  8003b1:	68 40 35 80 00       	push   $0x803540
  8003b6:	e8 89 02 00 00       	call   800644 <cprintf>
  8003bb:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8003be:	a1 00 40 80 00       	mov    0x804000,%eax
  8003c3:	ff 75 0c             	pushl  0xc(%ebp)
  8003c6:	ff 75 08             	pushl  0x8(%ebp)
  8003c9:	50                   	push   %eax
  8003ca:	68 45 35 80 00       	push   $0x803545
  8003cf:	e8 70 02 00 00       	call   800644 <cprintf>
  8003d4:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8003d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8003da:	83 ec 08             	sub    $0x8,%esp
  8003dd:	ff 75 f4             	pushl  -0xc(%ebp)
  8003e0:	50                   	push   %eax
  8003e1:	e8 f3 01 00 00       	call   8005d9 <vcprintf>
  8003e6:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8003e9:	83 ec 08             	sub    $0x8,%esp
  8003ec:	6a 00                	push   $0x0
  8003ee:	68 61 35 80 00       	push   $0x803561
  8003f3:	e8 e1 01 00 00       	call   8005d9 <vcprintf>
  8003f8:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8003fb:	e8 82 ff ff ff       	call   800382 <exit>

	// should not return here
	while (1) ;
  800400:	eb fe                	jmp    800400 <_panic+0x70>

00800402 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800402:	55                   	push   %ebp
  800403:	89 e5                	mov    %esp,%ebp
  800405:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800408:	a1 20 40 80 00       	mov    0x804020,%eax
  80040d:	8b 50 74             	mov    0x74(%eax),%edx
  800410:	8b 45 0c             	mov    0xc(%ebp),%eax
  800413:	39 c2                	cmp    %eax,%edx
  800415:	74 14                	je     80042b <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800417:	83 ec 04             	sub    $0x4,%esp
  80041a:	68 64 35 80 00       	push   $0x803564
  80041f:	6a 26                	push   $0x26
  800421:	68 b0 35 80 00       	push   $0x8035b0
  800426:	e8 65 ff ff ff       	call   800390 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80042b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800432:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800439:	e9 c2 00 00 00       	jmp    800500 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80043e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800441:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800448:	8b 45 08             	mov    0x8(%ebp),%eax
  80044b:	01 d0                	add    %edx,%eax
  80044d:	8b 00                	mov    (%eax),%eax
  80044f:	85 c0                	test   %eax,%eax
  800451:	75 08                	jne    80045b <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800453:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800456:	e9 a2 00 00 00       	jmp    8004fd <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80045b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800462:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800469:	eb 69                	jmp    8004d4 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80046b:	a1 20 40 80 00       	mov    0x804020,%eax
  800470:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800476:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800479:	89 d0                	mov    %edx,%eax
  80047b:	01 c0                	add    %eax,%eax
  80047d:	01 d0                	add    %edx,%eax
  80047f:	c1 e0 03             	shl    $0x3,%eax
  800482:	01 c8                	add    %ecx,%eax
  800484:	8a 40 04             	mov    0x4(%eax),%al
  800487:	84 c0                	test   %al,%al
  800489:	75 46                	jne    8004d1 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80048b:	a1 20 40 80 00       	mov    0x804020,%eax
  800490:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800496:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800499:	89 d0                	mov    %edx,%eax
  80049b:	01 c0                	add    %eax,%eax
  80049d:	01 d0                	add    %edx,%eax
  80049f:	c1 e0 03             	shl    $0x3,%eax
  8004a2:	01 c8                	add    %ecx,%eax
  8004a4:	8b 00                	mov    (%eax),%eax
  8004a6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004ac:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8004b1:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8004b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004b6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8004bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c0:	01 c8                	add    %ecx,%eax
  8004c2:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004c4:	39 c2                	cmp    %eax,%edx
  8004c6:	75 09                	jne    8004d1 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8004c8:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8004cf:	eb 12                	jmp    8004e3 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004d1:	ff 45 e8             	incl   -0x18(%ebp)
  8004d4:	a1 20 40 80 00       	mov    0x804020,%eax
  8004d9:	8b 50 74             	mov    0x74(%eax),%edx
  8004dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004df:	39 c2                	cmp    %eax,%edx
  8004e1:	77 88                	ja     80046b <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8004e3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8004e7:	75 14                	jne    8004fd <CheckWSWithoutLastIndex+0xfb>
			panic(
  8004e9:	83 ec 04             	sub    $0x4,%esp
  8004ec:	68 bc 35 80 00       	push   $0x8035bc
  8004f1:	6a 3a                	push   $0x3a
  8004f3:	68 b0 35 80 00       	push   $0x8035b0
  8004f8:	e8 93 fe ff ff       	call   800390 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8004fd:	ff 45 f0             	incl   -0x10(%ebp)
  800500:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800503:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800506:	0f 8c 32 ff ff ff    	jl     80043e <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80050c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800513:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80051a:	eb 26                	jmp    800542 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80051c:	a1 20 40 80 00       	mov    0x804020,%eax
  800521:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800527:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80052a:	89 d0                	mov    %edx,%eax
  80052c:	01 c0                	add    %eax,%eax
  80052e:	01 d0                	add    %edx,%eax
  800530:	c1 e0 03             	shl    $0x3,%eax
  800533:	01 c8                	add    %ecx,%eax
  800535:	8a 40 04             	mov    0x4(%eax),%al
  800538:	3c 01                	cmp    $0x1,%al
  80053a:	75 03                	jne    80053f <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80053c:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80053f:	ff 45 e0             	incl   -0x20(%ebp)
  800542:	a1 20 40 80 00       	mov    0x804020,%eax
  800547:	8b 50 74             	mov    0x74(%eax),%edx
  80054a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80054d:	39 c2                	cmp    %eax,%edx
  80054f:	77 cb                	ja     80051c <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800551:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800554:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800557:	74 14                	je     80056d <CheckWSWithoutLastIndex+0x16b>
		panic(
  800559:	83 ec 04             	sub    $0x4,%esp
  80055c:	68 10 36 80 00       	push   $0x803610
  800561:	6a 44                	push   $0x44
  800563:	68 b0 35 80 00       	push   $0x8035b0
  800568:	e8 23 fe ff ff       	call   800390 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80056d:	90                   	nop
  80056e:	c9                   	leave  
  80056f:	c3                   	ret    

00800570 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800570:	55                   	push   %ebp
  800571:	89 e5                	mov    %esp,%ebp
  800573:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800576:	8b 45 0c             	mov    0xc(%ebp),%eax
  800579:	8b 00                	mov    (%eax),%eax
  80057b:	8d 48 01             	lea    0x1(%eax),%ecx
  80057e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800581:	89 0a                	mov    %ecx,(%edx)
  800583:	8b 55 08             	mov    0x8(%ebp),%edx
  800586:	88 d1                	mov    %dl,%cl
  800588:	8b 55 0c             	mov    0xc(%ebp),%edx
  80058b:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80058f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800592:	8b 00                	mov    (%eax),%eax
  800594:	3d ff 00 00 00       	cmp    $0xff,%eax
  800599:	75 2c                	jne    8005c7 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80059b:	a0 24 40 80 00       	mov    0x804024,%al
  8005a0:	0f b6 c0             	movzbl %al,%eax
  8005a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005a6:	8b 12                	mov    (%edx),%edx
  8005a8:	89 d1                	mov    %edx,%ecx
  8005aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005ad:	83 c2 08             	add    $0x8,%edx
  8005b0:	83 ec 04             	sub    $0x4,%esp
  8005b3:	50                   	push   %eax
  8005b4:	51                   	push   %ecx
  8005b5:	52                   	push   %edx
  8005b6:	e8 22 13 00 00       	call   8018dd <sys_cputs>
  8005bb:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8005be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8005c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005ca:	8b 40 04             	mov    0x4(%eax),%eax
  8005cd:	8d 50 01             	lea    0x1(%eax),%edx
  8005d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005d3:	89 50 04             	mov    %edx,0x4(%eax)
}
  8005d6:	90                   	nop
  8005d7:	c9                   	leave  
  8005d8:	c3                   	ret    

008005d9 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8005d9:	55                   	push   %ebp
  8005da:	89 e5                	mov    %esp,%ebp
  8005dc:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005e2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005e9:	00 00 00 
	b.cnt = 0;
  8005ec:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005f3:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8005f6:	ff 75 0c             	pushl  0xc(%ebp)
  8005f9:	ff 75 08             	pushl  0x8(%ebp)
  8005fc:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800602:	50                   	push   %eax
  800603:	68 70 05 80 00       	push   $0x800570
  800608:	e8 11 02 00 00       	call   80081e <vprintfmt>
  80060d:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800610:	a0 24 40 80 00       	mov    0x804024,%al
  800615:	0f b6 c0             	movzbl %al,%eax
  800618:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80061e:	83 ec 04             	sub    $0x4,%esp
  800621:	50                   	push   %eax
  800622:	52                   	push   %edx
  800623:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800629:	83 c0 08             	add    $0x8,%eax
  80062c:	50                   	push   %eax
  80062d:	e8 ab 12 00 00       	call   8018dd <sys_cputs>
  800632:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800635:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80063c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800642:	c9                   	leave  
  800643:	c3                   	ret    

00800644 <cprintf>:

int cprintf(const char *fmt, ...) {
  800644:	55                   	push   %ebp
  800645:	89 e5                	mov    %esp,%ebp
  800647:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80064a:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800651:	8d 45 0c             	lea    0xc(%ebp),%eax
  800654:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800657:	8b 45 08             	mov    0x8(%ebp),%eax
  80065a:	83 ec 08             	sub    $0x8,%esp
  80065d:	ff 75 f4             	pushl  -0xc(%ebp)
  800660:	50                   	push   %eax
  800661:	e8 73 ff ff ff       	call   8005d9 <vcprintf>
  800666:	83 c4 10             	add    $0x10,%esp
  800669:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80066c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80066f:	c9                   	leave  
  800670:	c3                   	ret    

00800671 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800671:	55                   	push   %ebp
  800672:	89 e5                	mov    %esp,%ebp
  800674:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800677:	e8 0f 14 00 00       	call   801a8b <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80067c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80067f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800682:	8b 45 08             	mov    0x8(%ebp),%eax
  800685:	83 ec 08             	sub    $0x8,%esp
  800688:	ff 75 f4             	pushl  -0xc(%ebp)
  80068b:	50                   	push   %eax
  80068c:	e8 48 ff ff ff       	call   8005d9 <vcprintf>
  800691:	83 c4 10             	add    $0x10,%esp
  800694:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800697:	e8 09 14 00 00       	call   801aa5 <sys_enable_interrupt>
	return cnt;
  80069c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80069f:	c9                   	leave  
  8006a0:	c3                   	ret    

008006a1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006a1:	55                   	push   %ebp
  8006a2:	89 e5                	mov    %esp,%ebp
  8006a4:	53                   	push   %ebx
  8006a5:	83 ec 14             	sub    $0x14,%esp
  8006a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8006ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006b4:	8b 45 18             	mov    0x18(%ebp),%eax
  8006b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8006bc:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006bf:	77 55                	ja     800716 <printnum+0x75>
  8006c1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006c4:	72 05                	jb     8006cb <printnum+0x2a>
  8006c6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8006c9:	77 4b                	ja     800716 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006cb:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006ce:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8006d1:	8b 45 18             	mov    0x18(%ebp),%eax
  8006d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d9:	52                   	push   %edx
  8006da:	50                   	push   %eax
  8006db:	ff 75 f4             	pushl  -0xc(%ebp)
  8006de:	ff 75 f0             	pushl  -0x10(%ebp)
  8006e1:	e8 b2 29 00 00       	call   803098 <__udivdi3>
  8006e6:	83 c4 10             	add    $0x10,%esp
  8006e9:	83 ec 04             	sub    $0x4,%esp
  8006ec:	ff 75 20             	pushl  0x20(%ebp)
  8006ef:	53                   	push   %ebx
  8006f0:	ff 75 18             	pushl  0x18(%ebp)
  8006f3:	52                   	push   %edx
  8006f4:	50                   	push   %eax
  8006f5:	ff 75 0c             	pushl  0xc(%ebp)
  8006f8:	ff 75 08             	pushl  0x8(%ebp)
  8006fb:	e8 a1 ff ff ff       	call   8006a1 <printnum>
  800700:	83 c4 20             	add    $0x20,%esp
  800703:	eb 1a                	jmp    80071f <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800705:	83 ec 08             	sub    $0x8,%esp
  800708:	ff 75 0c             	pushl  0xc(%ebp)
  80070b:	ff 75 20             	pushl  0x20(%ebp)
  80070e:	8b 45 08             	mov    0x8(%ebp),%eax
  800711:	ff d0                	call   *%eax
  800713:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800716:	ff 4d 1c             	decl   0x1c(%ebp)
  800719:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80071d:	7f e6                	jg     800705 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80071f:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800722:	bb 00 00 00 00       	mov    $0x0,%ebx
  800727:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80072a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80072d:	53                   	push   %ebx
  80072e:	51                   	push   %ecx
  80072f:	52                   	push   %edx
  800730:	50                   	push   %eax
  800731:	e8 72 2a 00 00       	call   8031a8 <__umoddi3>
  800736:	83 c4 10             	add    $0x10,%esp
  800739:	05 74 38 80 00       	add    $0x803874,%eax
  80073e:	8a 00                	mov    (%eax),%al
  800740:	0f be c0             	movsbl %al,%eax
  800743:	83 ec 08             	sub    $0x8,%esp
  800746:	ff 75 0c             	pushl  0xc(%ebp)
  800749:	50                   	push   %eax
  80074a:	8b 45 08             	mov    0x8(%ebp),%eax
  80074d:	ff d0                	call   *%eax
  80074f:	83 c4 10             	add    $0x10,%esp
}
  800752:	90                   	nop
  800753:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800756:	c9                   	leave  
  800757:	c3                   	ret    

00800758 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800758:	55                   	push   %ebp
  800759:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80075b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80075f:	7e 1c                	jle    80077d <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800761:	8b 45 08             	mov    0x8(%ebp),%eax
  800764:	8b 00                	mov    (%eax),%eax
  800766:	8d 50 08             	lea    0x8(%eax),%edx
  800769:	8b 45 08             	mov    0x8(%ebp),%eax
  80076c:	89 10                	mov    %edx,(%eax)
  80076e:	8b 45 08             	mov    0x8(%ebp),%eax
  800771:	8b 00                	mov    (%eax),%eax
  800773:	83 e8 08             	sub    $0x8,%eax
  800776:	8b 50 04             	mov    0x4(%eax),%edx
  800779:	8b 00                	mov    (%eax),%eax
  80077b:	eb 40                	jmp    8007bd <getuint+0x65>
	else if (lflag)
  80077d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800781:	74 1e                	je     8007a1 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800783:	8b 45 08             	mov    0x8(%ebp),%eax
  800786:	8b 00                	mov    (%eax),%eax
  800788:	8d 50 04             	lea    0x4(%eax),%edx
  80078b:	8b 45 08             	mov    0x8(%ebp),%eax
  80078e:	89 10                	mov    %edx,(%eax)
  800790:	8b 45 08             	mov    0x8(%ebp),%eax
  800793:	8b 00                	mov    (%eax),%eax
  800795:	83 e8 04             	sub    $0x4,%eax
  800798:	8b 00                	mov    (%eax),%eax
  80079a:	ba 00 00 00 00       	mov    $0x0,%edx
  80079f:	eb 1c                	jmp    8007bd <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8007a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a4:	8b 00                	mov    (%eax),%eax
  8007a6:	8d 50 04             	lea    0x4(%eax),%edx
  8007a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ac:	89 10                	mov    %edx,(%eax)
  8007ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b1:	8b 00                	mov    (%eax),%eax
  8007b3:	83 e8 04             	sub    $0x4,%eax
  8007b6:	8b 00                	mov    (%eax),%eax
  8007b8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8007bd:	5d                   	pop    %ebp
  8007be:	c3                   	ret    

008007bf <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007bf:	55                   	push   %ebp
  8007c0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007c2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007c6:	7e 1c                	jle    8007e4 <getint+0x25>
		return va_arg(*ap, long long);
  8007c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cb:	8b 00                	mov    (%eax),%eax
  8007cd:	8d 50 08             	lea    0x8(%eax),%edx
  8007d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d3:	89 10                	mov    %edx,(%eax)
  8007d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d8:	8b 00                	mov    (%eax),%eax
  8007da:	83 e8 08             	sub    $0x8,%eax
  8007dd:	8b 50 04             	mov    0x4(%eax),%edx
  8007e0:	8b 00                	mov    (%eax),%eax
  8007e2:	eb 38                	jmp    80081c <getint+0x5d>
	else if (lflag)
  8007e4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007e8:	74 1a                	je     800804 <getint+0x45>
		return va_arg(*ap, long);
  8007ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ed:	8b 00                	mov    (%eax),%eax
  8007ef:	8d 50 04             	lea    0x4(%eax),%edx
  8007f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f5:	89 10                	mov    %edx,(%eax)
  8007f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fa:	8b 00                	mov    (%eax),%eax
  8007fc:	83 e8 04             	sub    $0x4,%eax
  8007ff:	8b 00                	mov    (%eax),%eax
  800801:	99                   	cltd   
  800802:	eb 18                	jmp    80081c <getint+0x5d>
	else
		return va_arg(*ap, int);
  800804:	8b 45 08             	mov    0x8(%ebp),%eax
  800807:	8b 00                	mov    (%eax),%eax
  800809:	8d 50 04             	lea    0x4(%eax),%edx
  80080c:	8b 45 08             	mov    0x8(%ebp),%eax
  80080f:	89 10                	mov    %edx,(%eax)
  800811:	8b 45 08             	mov    0x8(%ebp),%eax
  800814:	8b 00                	mov    (%eax),%eax
  800816:	83 e8 04             	sub    $0x4,%eax
  800819:	8b 00                	mov    (%eax),%eax
  80081b:	99                   	cltd   
}
  80081c:	5d                   	pop    %ebp
  80081d:	c3                   	ret    

0080081e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80081e:	55                   	push   %ebp
  80081f:	89 e5                	mov    %esp,%ebp
  800821:	56                   	push   %esi
  800822:	53                   	push   %ebx
  800823:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800826:	eb 17                	jmp    80083f <vprintfmt+0x21>
			if (ch == '\0')
  800828:	85 db                	test   %ebx,%ebx
  80082a:	0f 84 af 03 00 00    	je     800bdf <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800830:	83 ec 08             	sub    $0x8,%esp
  800833:	ff 75 0c             	pushl  0xc(%ebp)
  800836:	53                   	push   %ebx
  800837:	8b 45 08             	mov    0x8(%ebp),%eax
  80083a:	ff d0                	call   *%eax
  80083c:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80083f:	8b 45 10             	mov    0x10(%ebp),%eax
  800842:	8d 50 01             	lea    0x1(%eax),%edx
  800845:	89 55 10             	mov    %edx,0x10(%ebp)
  800848:	8a 00                	mov    (%eax),%al
  80084a:	0f b6 d8             	movzbl %al,%ebx
  80084d:	83 fb 25             	cmp    $0x25,%ebx
  800850:	75 d6                	jne    800828 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800852:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800856:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80085d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800864:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80086b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800872:	8b 45 10             	mov    0x10(%ebp),%eax
  800875:	8d 50 01             	lea    0x1(%eax),%edx
  800878:	89 55 10             	mov    %edx,0x10(%ebp)
  80087b:	8a 00                	mov    (%eax),%al
  80087d:	0f b6 d8             	movzbl %al,%ebx
  800880:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800883:	83 f8 55             	cmp    $0x55,%eax
  800886:	0f 87 2b 03 00 00    	ja     800bb7 <vprintfmt+0x399>
  80088c:	8b 04 85 98 38 80 00 	mov    0x803898(,%eax,4),%eax
  800893:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800895:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800899:	eb d7                	jmp    800872 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80089b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80089f:	eb d1                	jmp    800872 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008a1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8008a8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008ab:	89 d0                	mov    %edx,%eax
  8008ad:	c1 e0 02             	shl    $0x2,%eax
  8008b0:	01 d0                	add    %edx,%eax
  8008b2:	01 c0                	add    %eax,%eax
  8008b4:	01 d8                	add    %ebx,%eax
  8008b6:	83 e8 30             	sub    $0x30,%eax
  8008b9:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8008bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8008bf:	8a 00                	mov    (%eax),%al
  8008c1:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8008c4:	83 fb 2f             	cmp    $0x2f,%ebx
  8008c7:	7e 3e                	jle    800907 <vprintfmt+0xe9>
  8008c9:	83 fb 39             	cmp    $0x39,%ebx
  8008cc:	7f 39                	jg     800907 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008ce:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008d1:	eb d5                	jmp    8008a8 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d6:	83 c0 04             	add    $0x4,%eax
  8008d9:	89 45 14             	mov    %eax,0x14(%ebp)
  8008dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8008df:	83 e8 04             	sub    $0x4,%eax
  8008e2:	8b 00                	mov    (%eax),%eax
  8008e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008e7:	eb 1f                	jmp    800908 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008e9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ed:	79 83                	jns    800872 <vprintfmt+0x54>
				width = 0;
  8008ef:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008f6:	e9 77 ff ff ff       	jmp    800872 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008fb:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800902:	e9 6b ff ff ff       	jmp    800872 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800907:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800908:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80090c:	0f 89 60 ff ff ff    	jns    800872 <vprintfmt+0x54>
				width = precision, precision = -1;
  800912:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800915:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800918:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80091f:	e9 4e ff ff ff       	jmp    800872 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800924:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800927:	e9 46 ff ff ff       	jmp    800872 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80092c:	8b 45 14             	mov    0x14(%ebp),%eax
  80092f:	83 c0 04             	add    $0x4,%eax
  800932:	89 45 14             	mov    %eax,0x14(%ebp)
  800935:	8b 45 14             	mov    0x14(%ebp),%eax
  800938:	83 e8 04             	sub    $0x4,%eax
  80093b:	8b 00                	mov    (%eax),%eax
  80093d:	83 ec 08             	sub    $0x8,%esp
  800940:	ff 75 0c             	pushl  0xc(%ebp)
  800943:	50                   	push   %eax
  800944:	8b 45 08             	mov    0x8(%ebp),%eax
  800947:	ff d0                	call   *%eax
  800949:	83 c4 10             	add    $0x10,%esp
			break;
  80094c:	e9 89 02 00 00       	jmp    800bda <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800951:	8b 45 14             	mov    0x14(%ebp),%eax
  800954:	83 c0 04             	add    $0x4,%eax
  800957:	89 45 14             	mov    %eax,0x14(%ebp)
  80095a:	8b 45 14             	mov    0x14(%ebp),%eax
  80095d:	83 e8 04             	sub    $0x4,%eax
  800960:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800962:	85 db                	test   %ebx,%ebx
  800964:	79 02                	jns    800968 <vprintfmt+0x14a>
				err = -err;
  800966:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800968:	83 fb 64             	cmp    $0x64,%ebx
  80096b:	7f 0b                	jg     800978 <vprintfmt+0x15a>
  80096d:	8b 34 9d e0 36 80 00 	mov    0x8036e0(,%ebx,4),%esi
  800974:	85 f6                	test   %esi,%esi
  800976:	75 19                	jne    800991 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800978:	53                   	push   %ebx
  800979:	68 85 38 80 00       	push   $0x803885
  80097e:	ff 75 0c             	pushl  0xc(%ebp)
  800981:	ff 75 08             	pushl  0x8(%ebp)
  800984:	e8 5e 02 00 00       	call   800be7 <printfmt>
  800989:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80098c:	e9 49 02 00 00       	jmp    800bda <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800991:	56                   	push   %esi
  800992:	68 8e 38 80 00       	push   $0x80388e
  800997:	ff 75 0c             	pushl  0xc(%ebp)
  80099a:	ff 75 08             	pushl  0x8(%ebp)
  80099d:	e8 45 02 00 00       	call   800be7 <printfmt>
  8009a2:	83 c4 10             	add    $0x10,%esp
			break;
  8009a5:	e9 30 02 00 00       	jmp    800bda <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8009aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ad:	83 c0 04             	add    $0x4,%eax
  8009b0:	89 45 14             	mov    %eax,0x14(%ebp)
  8009b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b6:	83 e8 04             	sub    $0x4,%eax
  8009b9:	8b 30                	mov    (%eax),%esi
  8009bb:	85 f6                	test   %esi,%esi
  8009bd:	75 05                	jne    8009c4 <vprintfmt+0x1a6>
				p = "(null)";
  8009bf:	be 91 38 80 00       	mov    $0x803891,%esi
			if (width > 0 && padc != '-')
  8009c4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009c8:	7e 6d                	jle    800a37 <vprintfmt+0x219>
  8009ca:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8009ce:	74 67                	je     800a37 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009d3:	83 ec 08             	sub    $0x8,%esp
  8009d6:	50                   	push   %eax
  8009d7:	56                   	push   %esi
  8009d8:	e8 0c 03 00 00       	call   800ce9 <strnlen>
  8009dd:	83 c4 10             	add    $0x10,%esp
  8009e0:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009e3:	eb 16                	jmp    8009fb <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009e5:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009e9:	83 ec 08             	sub    $0x8,%esp
  8009ec:	ff 75 0c             	pushl  0xc(%ebp)
  8009ef:	50                   	push   %eax
  8009f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f3:	ff d0                	call   *%eax
  8009f5:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009f8:	ff 4d e4             	decl   -0x1c(%ebp)
  8009fb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009ff:	7f e4                	jg     8009e5 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a01:	eb 34                	jmp    800a37 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a03:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a07:	74 1c                	je     800a25 <vprintfmt+0x207>
  800a09:	83 fb 1f             	cmp    $0x1f,%ebx
  800a0c:	7e 05                	jle    800a13 <vprintfmt+0x1f5>
  800a0e:	83 fb 7e             	cmp    $0x7e,%ebx
  800a11:	7e 12                	jle    800a25 <vprintfmt+0x207>
					putch('?', putdat);
  800a13:	83 ec 08             	sub    $0x8,%esp
  800a16:	ff 75 0c             	pushl  0xc(%ebp)
  800a19:	6a 3f                	push   $0x3f
  800a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1e:	ff d0                	call   *%eax
  800a20:	83 c4 10             	add    $0x10,%esp
  800a23:	eb 0f                	jmp    800a34 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a25:	83 ec 08             	sub    $0x8,%esp
  800a28:	ff 75 0c             	pushl  0xc(%ebp)
  800a2b:	53                   	push   %ebx
  800a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2f:	ff d0                	call   *%eax
  800a31:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a34:	ff 4d e4             	decl   -0x1c(%ebp)
  800a37:	89 f0                	mov    %esi,%eax
  800a39:	8d 70 01             	lea    0x1(%eax),%esi
  800a3c:	8a 00                	mov    (%eax),%al
  800a3e:	0f be d8             	movsbl %al,%ebx
  800a41:	85 db                	test   %ebx,%ebx
  800a43:	74 24                	je     800a69 <vprintfmt+0x24b>
  800a45:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a49:	78 b8                	js     800a03 <vprintfmt+0x1e5>
  800a4b:	ff 4d e0             	decl   -0x20(%ebp)
  800a4e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a52:	79 af                	jns    800a03 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a54:	eb 13                	jmp    800a69 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a56:	83 ec 08             	sub    $0x8,%esp
  800a59:	ff 75 0c             	pushl  0xc(%ebp)
  800a5c:	6a 20                	push   $0x20
  800a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a61:	ff d0                	call   *%eax
  800a63:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a66:	ff 4d e4             	decl   -0x1c(%ebp)
  800a69:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a6d:	7f e7                	jg     800a56 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a6f:	e9 66 01 00 00       	jmp    800bda <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a74:	83 ec 08             	sub    $0x8,%esp
  800a77:	ff 75 e8             	pushl  -0x18(%ebp)
  800a7a:	8d 45 14             	lea    0x14(%ebp),%eax
  800a7d:	50                   	push   %eax
  800a7e:	e8 3c fd ff ff       	call   8007bf <getint>
  800a83:	83 c4 10             	add    $0x10,%esp
  800a86:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a89:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a8f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a92:	85 d2                	test   %edx,%edx
  800a94:	79 23                	jns    800ab9 <vprintfmt+0x29b>
				putch('-', putdat);
  800a96:	83 ec 08             	sub    $0x8,%esp
  800a99:	ff 75 0c             	pushl  0xc(%ebp)
  800a9c:	6a 2d                	push   $0x2d
  800a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa1:	ff d0                	call   *%eax
  800aa3:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800aa6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800aa9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800aac:	f7 d8                	neg    %eax
  800aae:	83 d2 00             	adc    $0x0,%edx
  800ab1:	f7 da                	neg    %edx
  800ab3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ab6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ab9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ac0:	e9 bc 00 00 00       	jmp    800b81 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ac5:	83 ec 08             	sub    $0x8,%esp
  800ac8:	ff 75 e8             	pushl  -0x18(%ebp)
  800acb:	8d 45 14             	lea    0x14(%ebp),%eax
  800ace:	50                   	push   %eax
  800acf:	e8 84 fc ff ff       	call   800758 <getuint>
  800ad4:	83 c4 10             	add    $0x10,%esp
  800ad7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ada:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800add:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ae4:	e9 98 00 00 00       	jmp    800b81 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ae9:	83 ec 08             	sub    $0x8,%esp
  800aec:	ff 75 0c             	pushl  0xc(%ebp)
  800aef:	6a 58                	push   $0x58
  800af1:	8b 45 08             	mov    0x8(%ebp),%eax
  800af4:	ff d0                	call   *%eax
  800af6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800af9:	83 ec 08             	sub    $0x8,%esp
  800afc:	ff 75 0c             	pushl  0xc(%ebp)
  800aff:	6a 58                	push   $0x58
  800b01:	8b 45 08             	mov    0x8(%ebp),%eax
  800b04:	ff d0                	call   *%eax
  800b06:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b09:	83 ec 08             	sub    $0x8,%esp
  800b0c:	ff 75 0c             	pushl  0xc(%ebp)
  800b0f:	6a 58                	push   $0x58
  800b11:	8b 45 08             	mov    0x8(%ebp),%eax
  800b14:	ff d0                	call   *%eax
  800b16:	83 c4 10             	add    $0x10,%esp
			break;
  800b19:	e9 bc 00 00 00       	jmp    800bda <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800b1e:	83 ec 08             	sub    $0x8,%esp
  800b21:	ff 75 0c             	pushl  0xc(%ebp)
  800b24:	6a 30                	push   $0x30
  800b26:	8b 45 08             	mov    0x8(%ebp),%eax
  800b29:	ff d0                	call   *%eax
  800b2b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b2e:	83 ec 08             	sub    $0x8,%esp
  800b31:	ff 75 0c             	pushl  0xc(%ebp)
  800b34:	6a 78                	push   $0x78
  800b36:	8b 45 08             	mov    0x8(%ebp),%eax
  800b39:	ff d0                	call   *%eax
  800b3b:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b41:	83 c0 04             	add    $0x4,%eax
  800b44:	89 45 14             	mov    %eax,0x14(%ebp)
  800b47:	8b 45 14             	mov    0x14(%ebp),%eax
  800b4a:	83 e8 04             	sub    $0x4,%eax
  800b4d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b52:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b59:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b60:	eb 1f                	jmp    800b81 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b62:	83 ec 08             	sub    $0x8,%esp
  800b65:	ff 75 e8             	pushl  -0x18(%ebp)
  800b68:	8d 45 14             	lea    0x14(%ebp),%eax
  800b6b:	50                   	push   %eax
  800b6c:	e8 e7 fb ff ff       	call   800758 <getuint>
  800b71:	83 c4 10             	add    $0x10,%esp
  800b74:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b77:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b7a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b81:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b88:	83 ec 04             	sub    $0x4,%esp
  800b8b:	52                   	push   %edx
  800b8c:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b8f:	50                   	push   %eax
  800b90:	ff 75 f4             	pushl  -0xc(%ebp)
  800b93:	ff 75 f0             	pushl  -0x10(%ebp)
  800b96:	ff 75 0c             	pushl  0xc(%ebp)
  800b99:	ff 75 08             	pushl  0x8(%ebp)
  800b9c:	e8 00 fb ff ff       	call   8006a1 <printnum>
  800ba1:	83 c4 20             	add    $0x20,%esp
			break;
  800ba4:	eb 34                	jmp    800bda <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ba6:	83 ec 08             	sub    $0x8,%esp
  800ba9:	ff 75 0c             	pushl  0xc(%ebp)
  800bac:	53                   	push   %ebx
  800bad:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb0:	ff d0                	call   *%eax
  800bb2:	83 c4 10             	add    $0x10,%esp
			break;
  800bb5:	eb 23                	jmp    800bda <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800bb7:	83 ec 08             	sub    $0x8,%esp
  800bba:	ff 75 0c             	pushl  0xc(%ebp)
  800bbd:	6a 25                	push   $0x25
  800bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc2:	ff d0                	call   *%eax
  800bc4:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bc7:	ff 4d 10             	decl   0x10(%ebp)
  800bca:	eb 03                	jmp    800bcf <vprintfmt+0x3b1>
  800bcc:	ff 4d 10             	decl   0x10(%ebp)
  800bcf:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd2:	48                   	dec    %eax
  800bd3:	8a 00                	mov    (%eax),%al
  800bd5:	3c 25                	cmp    $0x25,%al
  800bd7:	75 f3                	jne    800bcc <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800bd9:	90                   	nop
		}
	}
  800bda:	e9 47 fc ff ff       	jmp    800826 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bdf:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800be0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800be3:	5b                   	pop    %ebx
  800be4:	5e                   	pop    %esi
  800be5:	5d                   	pop    %ebp
  800be6:	c3                   	ret    

00800be7 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800be7:	55                   	push   %ebp
  800be8:	89 e5                	mov    %esp,%ebp
  800bea:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bed:	8d 45 10             	lea    0x10(%ebp),%eax
  800bf0:	83 c0 04             	add    $0x4,%eax
  800bf3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800bf6:	8b 45 10             	mov    0x10(%ebp),%eax
  800bf9:	ff 75 f4             	pushl  -0xc(%ebp)
  800bfc:	50                   	push   %eax
  800bfd:	ff 75 0c             	pushl  0xc(%ebp)
  800c00:	ff 75 08             	pushl  0x8(%ebp)
  800c03:	e8 16 fc ff ff       	call   80081e <vprintfmt>
  800c08:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c0b:	90                   	nop
  800c0c:	c9                   	leave  
  800c0d:	c3                   	ret    

00800c0e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c0e:	55                   	push   %ebp
  800c0f:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c14:	8b 40 08             	mov    0x8(%eax),%eax
  800c17:	8d 50 01             	lea    0x1(%eax),%edx
  800c1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c1d:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c23:	8b 10                	mov    (%eax),%edx
  800c25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c28:	8b 40 04             	mov    0x4(%eax),%eax
  800c2b:	39 c2                	cmp    %eax,%edx
  800c2d:	73 12                	jae    800c41 <sprintputch+0x33>
		*b->buf++ = ch;
  800c2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c32:	8b 00                	mov    (%eax),%eax
  800c34:	8d 48 01             	lea    0x1(%eax),%ecx
  800c37:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c3a:	89 0a                	mov    %ecx,(%edx)
  800c3c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c3f:	88 10                	mov    %dl,(%eax)
}
  800c41:	90                   	nop
  800c42:	5d                   	pop    %ebp
  800c43:	c3                   	ret    

00800c44 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c44:	55                   	push   %ebp
  800c45:	89 e5                	mov    %esp,%ebp
  800c47:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c53:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c56:	8b 45 08             	mov    0x8(%ebp),%eax
  800c59:	01 d0                	add    %edx,%eax
  800c5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c5e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c65:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c69:	74 06                	je     800c71 <vsnprintf+0x2d>
  800c6b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c6f:	7f 07                	jg     800c78 <vsnprintf+0x34>
		return -E_INVAL;
  800c71:	b8 03 00 00 00       	mov    $0x3,%eax
  800c76:	eb 20                	jmp    800c98 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c78:	ff 75 14             	pushl  0x14(%ebp)
  800c7b:	ff 75 10             	pushl  0x10(%ebp)
  800c7e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c81:	50                   	push   %eax
  800c82:	68 0e 0c 80 00       	push   $0x800c0e
  800c87:	e8 92 fb ff ff       	call   80081e <vprintfmt>
  800c8c:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c92:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c95:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c98:	c9                   	leave  
  800c99:	c3                   	ret    

00800c9a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c9a:	55                   	push   %ebp
  800c9b:	89 e5                	mov    %esp,%ebp
  800c9d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ca0:	8d 45 10             	lea    0x10(%ebp),%eax
  800ca3:	83 c0 04             	add    $0x4,%eax
  800ca6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ca9:	8b 45 10             	mov    0x10(%ebp),%eax
  800cac:	ff 75 f4             	pushl  -0xc(%ebp)
  800caf:	50                   	push   %eax
  800cb0:	ff 75 0c             	pushl  0xc(%ebp)
  800cb3:	ff 75 08             	pushl  0x8(%ebp)
  800cb6:	e8 89 ff ff ff       	call   800c44 <vsnprintf>
  800cbb:	83 c4 10             	add    $0x10,%esp
  800cbe:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800cc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800cc4:	c9                   	leave  
  800cc5:	c3                   	ret    

00800cc6 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800cc6:	55                   	push   %ebp
  800cc7:	89 e5                	mov    %esp,%ebp
  800cc9:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ccc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cd3:	eb 06                	jmp    800cdb <strlen+0x15>
		n++;
  800cd5:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cd8:	ff 45 08             	incl   0x8(%ebp)
  800cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cde:	8a 00                	mov    (%eax),%al
  800ce0:	84 c0                	test   %al,%al
  800ce2:	75 f1                	jne    800cd5 <strlen+0xf>
		n++;
	return n;
  800ce4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ce7:	c9                   	leave  
  800ce8:	c3                   	ret    

00800ce9 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800ce9:	55                   	push   %ebp
  800cea:	89 e5                	mov    %esp,%ebp
  800cec:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cf6:	eb 09                	jmp    800d01 <strnlen+0x18>
		n++;
  800cf8:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cfb:	ff 45 08             	incl   0x8(%ebp)
  800cfe:	ff 4d 0c             	decl   0xc(%ebp)
  800d01:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d05:	74 09                	je     800d10 <strnlen+0x27>
  800d07:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0a:	8a 00                	mov    (%eax),%al
  800d0c:	84 c0                	test   %al,%al
  800d0e:	75 e8                	jne    800cf8 <strnlen+0xf>
		n++;
	return n;
  800d10:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d13:	c9                   	leave  
  800d14:	c3                   	ret    

00800d15 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d15:	55                   	push   %ebp
  800d16:	89 e5                	mov    %esp,%ebp
  800d18:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d21:	90                   	nop
  800d22:	8b 45 08             	mov    0x8(%ebp),%eax
  800d25:	8d 50 01             	lea    0x1(%eax),%edx
  800d28:	89 55 08             	mov    %edx,0x8(%ebp)
  800d2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d2e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d31:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d34:	8a 12                	mov    (%edx),%dl
  800d36:	88 10                	mov    %dl,(%eax)
  800d38:	8a 00                	mov    (%eax),%al
  800d3a:	84 c0                	test   %al,%al
  800d3c:	75 e4                	jne    800d22 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d41:	c9                   	leave  
  800d42:	c3                   	ret    

00800d43 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d43:	55                   	push   %ebp
  800d44:	89 e5                	mov    %esp,%ebp
  800d46:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d49:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d4f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d56:	eb 1f                	jmp    800d77 <strncpy+0x34>
		*dst++ = *src;
  800d58:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5b:	8d 50 01             	lea    0x1(%eax),%edx
  800d5e:	89 55 08             	mov    %edx,0x8(%ebp)
  800d61:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d64:	8a 12                	mov    (%edx),%dl
  800d66:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6b:	8a 00                	mov    (%eax),%al
  800d6d:	84 c0                	test   %al,%al
  800d6f:	74 03                	je     800d74 <strncpy+0x31>
			src++;
  800d71:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d74:	ff 45 fc             	incl   -0x4(%ebp)
  800d77:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d7a:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d7d:	72 d9                	jb     800d58 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d7f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d82:	c9                   	leave  
  800d83:	c3                   	ret    

00800d84 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d84:	55                   	push   %ebp
  800d85:	89 e5                	mov    %esp,%ebp
  800d87:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d90:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d94:	74 30                	je     800dc6 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d96:	eb 16                	jmp    800dae <strlcpy+0x2a>
			*dst++ = *src++;
  800d98:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9b:	8d 50 01             	lea    0x1(%eax),%edx
  800d9e:	89 55 08             	mov    %edx,0x8(%ebp)
  800da1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800da4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800da7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800daa:	8a 12                	mov    (%edx),%dl
  800dac:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800dae:	ff 4d 10             	decl   0x10(%ebp)
  800db1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800db5:	74 09                	je     800dc0 <strlcpy+0x3c>
  800db7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dba:	8a 00                	mov    (%eax),%al
  800dbc:	84 c0                	test   %al,%al
  800dbe:	75 d8                	jne    800d98 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc3:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800dc6:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dcc:	29 c2                	sub    %eax,%edx
  800dce:	89 d0                	mov    %edx,%eax
}
  800dd0:	c9                   	leave  
  800dd1:	c3                   	ret    

00800dd2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800dd2:	55                   	push   %ebp
  800dd3:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800dd5:	eb 06                	jmp    800ddd <strcmp+0xb>
		p++, q++;
  800dd7:	ff 45 08             	incl   0x8(%ebp)
  800dda:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  800de0:	8a 00                	mov    (%eax),%al
  800de2:	84 c0                	test   %al,%al
  800de4:	74 0e                	je     800df4 <strcmp+0x22>
  800de6:	8b 45 08             	mov    0x8(%ebp),%eax
  800de9:	8a 10                	mov    (%eax),%dl
  800deb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dee:	8a 00                	mov    (%eax),%al
  800df0:	38 c2                	cmp    %al,%dl
  800df2:	74 e3                	je     800dd7 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800df4:	8b 45 08             	mov    0x8(%ebp),%eax
  800df7:	8a 00                	mov    (%eax),%al
  800df9:	0f b6 d0             	movzbl %al,%edx
  800dfc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dff:	8a 00                	mov    (%eax),%al
  800e01:	0f b6 c0             	movzbl %al,%eax
  800e04:	29 c2                	sub    %eax,%edx
  800e06:	89 d0                	mov    %edx,%eax
}
  800e08:	5d                   	pop    %ebp
  800e09:	c3                   	ret    

00800e0a <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e0a:	55                   	push   %ebp
  800e0b:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e0d:	eb 09                	jmp    800e18 <strncmp+0xe>
		n--, p++, q++;
  800e0f:	ff 4d 10             	decl   0x10(%ebp)
  800e12:	ff 45 08             	incl   0x8(%ebp)
  800e15:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e18:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e1c:	74 17                	je     800e35 <strncmp+0x2b>
  800e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e21:	8a 00                	mov    (%eax),%al
  800e23:	84 c0                	test   %al,%al
  800e25:	74 0e                	je     800e35 <strncmp+0x2b>
  800e27:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2a:	8a 10                	mov    (%eax),%dl
  800e2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2f:	8a 00                	mov    (%eax),%al
  800e31:	38 c2                	cmp    %al,%dl
  800e33:	74 da                	je     800e0f <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e35:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e39:	75 07                	jne    800e42 <strncmp+0x38>
		return 0;
  800e3b:	b8 00 00 00 00       	mov    $0x0,%eax
  800e40:	eb 14                	jmp    800e56 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e42:	8b 45 08             	mov    0x8(%ebp),%eax
  800e45:	8a 00                	mov    (%eax),%al
  800e47:	0f b6 d0             	movzbl %al,%edx
  800e4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4d:	8a 00                	mov    (%eax),%al
  800e4f:	0f b6 c0             	movzbl %al,%eax
  800e52:	29 c2                	sub    %eax,%edx
  800e54:	89 d0                	mov    %edx,%eax
}
  800e56:	5d                   	pop    %ebp
  800e57:	c3                   	ret    

00800e58 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e58:	55                   	push   %ebp
  800e59:	89 e5                	mov    %esp,%ebp
  800e5b:	83 ec 04             	sub    $0x4,%esp
  800e5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e61:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e64:	eb 12                	jmp    800e78 <strchr+0x20>
		if (*s == c)
  800e66:	8b 45 08             	mov    0x8(%ebp),%eax
  800e69:	8a 00                	mov    (%eax),%al
  800e6b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e6e:	75 05                	jne    800e75 <strchr+0x1d>
			return (char *) s;
  800e70:	8b 45 08             	mov    0x8(%ebp),%eax
  800e73:	eb 11                	jmp    800e86 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e75:	ff 45 08             	incl   0x8(%ebp)
  800e78:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7b:	8a 00                	mov    (%eax),%al
  800e7d:	84 c0                	test   %al,%al
  800e7f:	75 e5                	jne    800e66 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e81:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e86:	c9                   	leave  
  800e87:	c3                   	ret    

00800e88 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e88:	55                   	push   %ebp
  800e89:	89 e5                	mov    %esp,%ebp
  800e8b:	83 ec 04             	sub    $0x4,%esp
  800e8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e91:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e94:	eb 0d                	jmp    800ea3 <strfind+0x1b>
		if (*s == c)
  800e96:	8b 45 08             	mov    0x8(%ebp),%eax
  800e99:	8a 00                	mov    (%eax),%al
  800e9b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e9e:	74 0e                	je     800eae <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ea0:	ff 45 08             	incl   0x8(%ebp)
  800ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea6:	8a 00                	mov    (%eax),%al
  800ea8:	84 c0                	test   %al,%al
  800eaa:	75 ea                	jne    800e96 <strfind+0xe>
  800eac:	eb 01                	jmp    800eaf <strfind+0x27>
		if (*s == c)
			break;
  800eae:	90                   	nop
	return (char *) s;
  800eaf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eb2:	c9                   	leave  
  800eb3:	c3                   	ret    

00800eb4 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800eb4:	55                   	push   %ebp
  800eb5:	89 e5                	mov    %esp,%ebp
  800eb7:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800eba:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800ec0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800ec6:	eb 0e                	jmp    800ed6 <memset+0x22>
		*p++ = c;
  800ec8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ecb:	8d 50 01             	lea    0x1(%eax),%edx
  800ece:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ed1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ed4:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800ed6:	ff 4d f8             	decl   -0x8(%ebp)
  800ed9:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800edd:	79 e9                	jns    800ec8 <memset+0x14>
		*p++ = c;

	return v;
  800edf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ee2:	c9                   	leave  
  800ee3:	c3                   	ret    

00800ee4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ee4:	55                   	push   %ebp
  800ee5:	89 e5                	mov    %esp,%ebp
  800ee7:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800eea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eed:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800ef6:	eb 16                	jmp    800f0e <memcpy+0x2a>
		*d++ = *s++;
  800ef8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800efb:	8d 50 01             	lea    0x1(%eax),%edx
  800efe:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f01:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f04:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f07:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f0a:	8a 12                	mov    (%edx),%dl
  800f0c:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f0e:	8b 45 10             	mov    0x10(%ebp),%eax
  800f11:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f14:	89 55 10             	mov    %edx,0x10(%ebp)
  800f17:	85 c0                	test   %eax,%eax
  800f19:	75 dd                	jne    800ef8 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f1b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f1e:	c9                   	leave  
  800f1f:	c3                   	ret    

00800f20 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f20:	55                   	push   %ebp
  800f21:	89 e5                	mov    %esp,%ebp
  800f23:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f29:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f32:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f35:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f38:	73 50                	jae    800f8a <memmove+0x6a>
  800f3a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f3d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f40:	01 d0                	add    %edx,%eax
  800f42:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f45:	76 43                	jbe    800f8a <memmove+0x6a>
		s += n;
  800f47:	8b 45 10             	mov    0x10(%ebp),%eax
  800f4a:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f4d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f50:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f53:	eb 10                	jmp    800f65 <memmove+0x45>
			*--d = *--s;
  800f55:	ff 4d f8             	decl   -0x8(%ebp)
  800f58:	ff 4d fc             	decl   -0x4(%ebp)
  800f5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f5e:	8a 10                	mov    (%eax),%dl
  800f60:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f63:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f65:	8b 45 10             	mov    0x10(%ebp),%eax
  800f68:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f6b:	89 55 10             	mov    %edx,0x10(%ebp)
  800f6e:	85 c0                	test   %eax,%eax
  800f70:	75 e3                	jne    800f55 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f72:	eb 23                	jmp    800f97 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f74:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f77:	8d 50 01             	lea    0x1(%eax),%edx
  800f7a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f7d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f80:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f83:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f86:	8a 12                	mov    (%edx),%dl
  800f88:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f8a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f90:	89 55 10             	mov    %edx,0x10(%ebp)
  800f93:	85 c0                	test   %eax,%eax
  800f95:	75 dd                	jne    800f74 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f97:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f9a:	c9                   	leave  
  800f9b:	c3                   	ret    

00800f9c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f9c:	55                   	push   %ebp
  800f9d:	89 e5                	mov    %esp,%ebp
  800f9f:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800fa2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800fa8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fab:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800fae:	eb 2a                	jmp    800fda <memcmp+0x3e>
		if (*s1 != *s2)
  800fb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fb3:	8a 10                	mov    (%eax),%dl
  800fb5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fb8:	8a 00                	mov    (%eax),%al
  800fba:	38 c2                	cmp    %al,%dl
  800fbc:	74 16                	je     800fd4 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800fbe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fc1:	8a 00                	mov    (%eax),%al
  800fc3:	0f b6 d0             	movzbl %al,%edx
  800fc6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc9:	8a 00                	mov    (%eax),%al
  800fcb:	0f b6 c0             	movzbl %al,%eax
  800fce:	29 c2                	sub    %eax,%edx
  800fd0:	89 d0                	mov    %edx,%eax
  800fd2:	eb 18                	jmp    800fec <memcmp+0x50>
		s1++, s2++;
  800fd4:	ff 45 fc             	incl   -0x4(%ebp)
  800fd7:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800fda:	8b 45 10             	mov    0x10(%ebp),%eax
  800fdd:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fe0:	89 55 10             	mov    %edx,0x10(%ebp)
  800fe3:	85 c0                	test   %eax,%eax
  800fe5:	75 c9                	jne    800fb0 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800fe7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fec:	c9                   	leave  
  800fed:	c3                   	ret    

00800fee <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800fee:	55                   	push   %ebp
  800fef:	89 e5                	mov    %esp,%ebp
  800ff1:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ff4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff7:	8b 45 10             	mov    0x10(%ebp),%eax
  800ffa:	01 d0                	add    %edx,%eax
  800ffc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800fff:	eb 15                	jmp    801016 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801001:	8b 45 08             	mov    0x8(%ebp),%eax
  801004:	8a 00                	mov    (%eax),%al
  801006:	0f b6 d0             	movzbl %al,%edx
  801009:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100c:	0f b6 c0             	movzbl %al,%eax
  80100f:	39 c2                	cmp    %eax,%edx
  801011:	74 0d                	je     801020 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801013:	ff 45 08             	incl   0x8(%ebp)
  801016:	8b 45 08             	mov    0x8(%ebp),%eax
  801019:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80101c:	72 e3                	jb     801001 <memfind+0x13>
  80101e:	eb 01                	jmp    801021 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801020:	90                   	nop
	return (void *) s;
  801021:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801024:	c9                   	leave  
  801025:	c3                   	ret    

00801026 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801026:	55                   	push   %ebp
  801027:	89 e5                	mov    %esp,%ebp
  801029:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80102c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801033:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80103a:	eb 03                	jmp    80103f <strtol+0x19>
		s++;
  80103c:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80103f:	8b 45 08             	mov    0x8(%ebp),%eax
  801042:	8a 00                	mov    (%eax),%al
  801044:	3c 20                	cmp    $0x20,%al
  801046:	74 f4                	je     80103c <strtol+0x16>
  801048:	8b 45 08             	mov    0x8(%ebp),%eax
  80104b:	8a 00                	mov    (%eax),%al
  80104d:	3c 09                	cmp    $0x9,%al
  80104f:	74 eb                	je     80103c <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801051:	8b 45 08             	mov    0x8(%ebp),%eax
  801054:	8a 00                	mov    (%eax),%al
  801056:	3c 2b                	cmp    $0x2b,%al
  801058:	75 05                	jne    80105f <strtol+0x39>
		s++;
  80105a:	ff 45 08             	incl   0x8(%ebp)
  80105d:	eb 13                	jmp    801072 <strtol+0x4c>
	else if (*s == '-')
  80105f:	8b 45 08             	mov    0x8(%ebp),%eax
  801062:	8a 00                	mov    (%eax),%al
  801064:	3c 2d                	cmp    $0x2d,%al
  801066:	75 0a                	jne    801072 <strtol+0x4c>
		s++, neg = 1;
  801068:	ff 45 08             	incl   0x8(%ebp)
  80106b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801072:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801076:	74 06                	je     80107e <strtol+0x58>
  801078:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80107c:	75 20                	jne    80109e <strtol+0x78>
  80107e:	8b 45 08             	mov    0x8(%ebp),%eax
  801081:	8a 00                	mov    (%eax),%al
  801083:	3c 30                	cmp    $0x30,%al
  801085:	75 17                	jne    80109e <strtol+0x78>
  801087:	8b 45 08             	mov    0x8(%ebp),%eax
  80108a:	40                   	inc    %eax
  80108b:	8a 00                	mov    (%eax),%al
  80108d:	3c 78                	cmp    $0x78,%al
  80108f:	75 0d                	jne    80109e <strtol+0x78>
		s += 2, base = 16;
  801091:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801095:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80109c:	eb 28                	jmp    8010c6 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80109e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010a2:	75 15                	jne    8010b9 <strtol+0x93>
  8010a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a7:	8a 00                	mov    (%eax),%al
  8010a9:	3c 30                	cmp    $0x30,%al
  8010ab:	75 0c                	jne    8010b9 <strtol+0x93>
		s++, base = 8;
  8010ad:	ff 45 08             	incl   0x8(%ebp)
  8010b0:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8010b7:	eb 0d                	jmp    8010c6 <strtol+0xa0>
	else if (base == 0)
  8010b9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010bd:	75 07                	jne    8010c6 <strtol+0xa0>
		base = 10;
  8010bf:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c9:	8a 00                	mov    (%eax),%al
  8010cb:	3c 2f                	cmp    $0x2f,%al
  8010cd:	7e 19                	jle    8010e8 <strtol+0xc2>
  8010cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d2:	8a 00                	mov    (%eax),%al
  8010d4:	3c 39                	cmp    $0x39,%al
  8010d6:	7f 10                	jg     8010e8 <strtol+0xc2>
			dig = *s - '0';
  8010d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010db:	8a 00                	mov    (%eax),%al
  8010dd:	0f be c0             	movsbl %al,%eax
  8010e0:	83 e8 30             	sub    $0x30,%eax
  8010e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010e6:	eb 42                	jmp    80112a <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8010e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010eb:	8a 00                	mov    (%eax),%al
  8010ed:	3c 60                	cmp    $0x60,%al
  8010ef:	7e 19                	jle    80110a <strtol+0xe4>
  8010f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f4:	8a 00                	mov    (%eax),%al
  8010f6:	3c 7a                	cmp    $0x7a,%al
  8010f8:	7f 10                	jg     80110a <strtol+0xe4>
			dig = *s - 'a' + 10;
  8010fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fd:	8a 00                	mov    (%eax),%al
  8010ff:	0f be c0             	movsbl %al,%eax
  801102:	83 e8 57             	sub    $0x57,%eax
  801105:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801108:	eb 20                	jmp    80112a <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80110a:	8b 45 08             	mov    0x8(%ebp),%eax
  80110d:	8a 00                	mov    (%eax),%al
  80110f:	3c 40                	cmp    $0x40,%al
  801111:	7e 39                	jle    80114c <strtol+0x126>
  801113:	8b 45 08             	mov    0x8(%ebp),%eax
  801116:	8a 00                	mov    (%eax),%al
  801118:	3c 5a                	cmp    $0x5a,%al
  80111a:	7f 30                	jg     80114c <strtol+0x126>
			dig = *s - 'A' + 10;
  80111c:	8b 45 08             	mov    0x8(%ebp),%eax
  80111f:	8a 00                	mov    (%eax),%al
  801121:	0f be c0             	movsbl %al,%eax
  801124:	83 e8 37             	sub    $0x37,%eax
  801127:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80112a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80112d:	3b 45 10             	cmp    0x10(%ebp),%eax
  801130:	7d 19                	jge    80114b <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801132:	ff 45 08             	incl   0x8(%ebp)
  801135:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801138:	0f af 45 10          	imul   0x10(%ebp),%eax
  80113c:	89 c2                	mov    %eax,%edx
  80113e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801141:	01 d0                	add    %edx,%eax
  801143:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801146:	e9 7b ff ff ff       	jmp    8010c6 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80114b:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80114c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801150:	74 08                	je     80115a <strtol+0x134>
		*endptr = (char *) s;
  801152:	8b 45 0c             	mov    0xc(%ebp),%eax
  801155:	8b 55 08             	mov    0x8(%ebp),%edx
  801158:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80115a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80115e:	74 07                	je     801167 <strtol+0x141>
  801160:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801163:	f7 d8                	neg    %eax
  801165:	eb 03                	jmp    80116a <strtol+0x144>
  801167:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80116a:	c9                   	leave  
  80116b:	c3                   	ret    

0080116c <ltostr>:

void
ltostr(long value, char *str)
{
  80116c:	55                   	push   %ebp
  80116d:	89 e5                	mov    %esp,%ebp
  80116f:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801172:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801179:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801180:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801184:	79 13                	jns    801199 <ltostr+0x2d>
	{
		neg = 1;
  801186:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80118d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801190:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801193:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801196:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801199:	8b 45 08             	mov    0x8(%ebp),%eax
  80119c:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8011a1:	99                   	cltd   
  8011a2:	f7 f9                	idiv   %ecx
  8011a4:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8011a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011aa:	8d 50 01             	lea    0x1(%eax),%edx
  8011ad:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011b0:	89 c2                	mov    %eax,%edx
  8011b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b5:	01 d0                	add    %edx,%eax
  8011b7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011ba:	83 c2 30             	add    $0x30,%edx
  8011bd:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8011bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011c2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011c7:	f7 e9                	imul   %ecx
  8011c9:	c1 fa 02             	sar    $0x2,%edx
  8011cc:	89 c8                	mov    %ecx,%eax
  8011ce:	c1 f8 1f             	sar    $0x1f,%eax
  8011d1:	29 c2                	sub    %eax,%edx
  8011d3:	89 d0                	mov    %edx,%eax
  8011d5:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8011d8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011db:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011e0:	f7 e9                	imul   %ecx
  8011e2:	c1 fa 02             	sar    $0x2,%edx
  8011e5:	89 c8                	mov    %ecx,%eax
  8011e7:	c1 f8 1f             	sar    $0x1f,%eax
  8011ea:	29 c2                	sub    %eax,%edx
  8011ec:	89 d0                	mov    %edx,%eax
  8011ee:	c1 e0 02             	shl    $0x2,%eax
  8011f1:	01 d0                	add    %edx,%eax
  8011f3:	01 c0                	add    %eax,%eax
  8011f5:	29 c1                	sub    %eax,%ecx
  8011f7:	89 ca                	mov    %ecx,%edx
  8011f9:	85 d2                	test   %edx,%edx
  8011fb:	75 9c                	jne    801199 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8011fd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801204:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801207:	48                   	dec    %eax
  801208:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80120b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80120f:	74 3d                	je     80124e <ltostr+0xe2>
		start = 1 ;
  801211:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801218:	eb 34                	jmp    80124e <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80121a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80121d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801220:	01 d0                	add    %edx,%eax
  801222:	8a 00                	mov    (%eax),%al
  801224:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801227:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80122a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122d:	01 c2                	add    %eax,%edx
  80122f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801232:	8b 45 0c             	mov    0xc(%ebp),%eax
  801235:	01 c8                	add    %ecx,%eax
  801237:	8a 00                	mov    (%eax),%al
  801239:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80123b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80123e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801241:	01 c2                	add    %eax,%edx
  801243:	8a 45 eb             	mov    -0x15(%ebp),%al
  801246:	88 02                	mov    %al,(%edx)
		start++ ;
  801248:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80124b:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80124e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801251:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801254:	7c c4                	jl     80121a <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801256:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801259:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125c:	01 d0                	add    %edx,%eax
  80125e:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801261:	90                   	nop
  801262:	c9                   	leave  
  801263:	c3                   	ret    

00801264 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801264:	55                   	push   %ebp
  801265:	89 e5                	mov    %esp,%ebp
  801267:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80126a:	ff 75 08             	pushl  0x8(%ebp)
  80126d:	e8 54 fa ff ff       	call   800cc6 <strlen>
  801272:	83 c4 04             	add    $0x4,%esp
  801275:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801278:	ff 75 0c             	pushl  0xc(%ebp)
  80127b:	e8 46 fa ff ff       	call   800cc6 <strlen>
  801280:	83 c4 04             	add    $0x4,%esp
  801283:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801286:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80128d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801294:	eb 17                	jmp    8012ad <strcconcat+0x49>
		final[s] = str1[s] ;
  801296:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801299:	8b 45 10             	mov    0x10(%ebp),%eax
  80129c:	01 c2                	add    %eax,%edx
  80129e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a4:	01 c8                	add    %ecx,%eax
  8012a6:	8a 00                	mov    (%eax),%al
  8012a8:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012aa:	ff 45 fc             	incl   -0x4(%ebp)
  8012ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012b0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012b3:	7c e1                	jl     801296 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012b5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012bc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8012c3:	eb 1f                	jmp    8012e4 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012c8:	8d 50 01             	lea    0x1(%eax),%edx
  8012cb:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012ce:	89 c2                	mov    %eax,%edx
  8012d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d3:	01 c2                	add    %eax,%edx
  8012d5:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012db:	01 c8                	add    %ecx,%eax
  8012dd:	8a 00                	mov    (%eax),%al
  8012df:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012e1:	ff 45 f8             	incl   -0x8(%ebp)
  8012e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012e7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012ea:	7c d9                	jl     8012c5 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8012ec:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f2:	01 d0                	add    %edx,%eax
  8012f4:	c6 00 00             	movb   $0x0,(%eax)
}
  8012f7:	90                   	nop
  8012f8:	c9                   	leave  
  8012f9:	c3                   	ret    

008012fa <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8012fa:	55                   	push   %ebp
  8012fb:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8012fd:	8b 45 14             	mov    0x14(%ebp),%eax
  801300:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801306:	8b 45 14             	mov    0x14(%ebp),%eax
  801309:	8b 00                	mov    (%eax),%eax
  80130b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801312:	8b 45 10             	mov    0x10(%ebp),%eax
  801315:	01 d0                	add    %edx,%eax
  801317:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80131d:	eb 0c                	jmp    80132b <strsplit+0x31>
			*string++ = 0;
  80131f:	8b 45 08             	mov    0x8(%ebp),%eax
  801322:	8d 50 01             	lea    0x1(%eax),%edx
  801325:	89 55 08             	mov    %edx,0x8(%ebp)
  801328:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80132b:	8b 45 08             	mov    0x8(%ebp),%eax
  80132e:	8a 00                	mov    (%eax),%al
  801330:	84 c0                	test   %al,%al
  801332:	74 18                	je     80134c <strsplit+0x52>
  801334:	8b 45 08             	mov    0x8(%ebp),%eax
  801337:	8a 00                	mov    (%eax),%al
  801339:	0f be c0             	movsbl %al,%eax
  80133c:	50                   	push   %eax
  80133d:	ff 75 0c             	pushl  0xc(%ebp)
  801340:	e8 13 fb ff ff       	call   800e58 <strchr>
  801345:	83 c4 08             	add    $0x8,%esp
  801348:	85 c0                	test   %eax,%eax
  80134a:	75 d3                	jne    80131f <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80134c:	8b 45 08             	mov    0x8(%ebp),%eax
  80134f:	8a 00                	mov    (%eax),%al
  801351:	84 c0                	test   %al,%al
  801353:	74 5a                	je     8013af <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801355:	8b 45 14             	mov    0x14(%ebp),%eax
  801358:	8b 00                	mov    (%eax),%eax
  80135a:	83 f8 0f             	cmp    $0xf,%eax
  80135d:	75 07                	jne    801366 <strsplit+0x6c>
		{
			return 0;
  80135f:	b8 00 00 00 00       	mov    $0x0,%eax
  801364:	eb 66                	jmp    8013cc <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801366:	8b 45 14             	mov    0x14(%ebp),%eax
  801369:	8b 00                	mov    (%eax),%eax
  80136b:	8d 48 01             	lea    0x1(%eax),%ecx
  80136e:	8b 55 14             	mov    0x14(%ebp),%edx
  801371:	89 0a                	mov    %ecx,(%edx)
  801373:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80137a:	8b 45 10             	mov    0x10(%ebp),%eax
  80137d:	01 c2                	add    %eax,%edx
  80137f:	8b 45 08             	mov    0x8(%ebp),%eax
  801382:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801384:	eb 03                	jmp    801389 <strsplit+0x8f>
			string++;
  801386:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801389:	8b 45 08             	mov    0x8(%ebp),%eax
  80138c:	8a 00                	mov    (%eax),%al
  80138e:	84 c0                	test   %al,%al
  801390:	74 8b                	je     80131d <strsplit+0x23>
  801392:	8b 45 08             	mov    0x8(%ebp),%eax
  801395:	8a 00                	mov    (%eax),%al
  801397:	0f be c0             	movsbl %al,%eax
  80139a:	50                   	push   %eax
  80139b:	ff 75 0c             	pushl  0xc(%ebp)
  80139e:	e8 b5 fa ff ff       	call   800e58 <strchr>
  8013a3:	83 c4 08             	add    $0x8,%esp
  8013a6:	85 c0                	test   %eax,%eax
  8013a8:	74 dc                	je     801386 <strsplit+0x8c>
			string++;
	}
  8013aa:	e9 6e ff ff ff       	jmp    80131d <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013af:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8013b3:	8b 00                	mov    (%eax),%eax
  8013b5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8013bf:	01 d0                	add    %edx,%eax
  8013c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013c7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013cc:	c9                   	leave  
  8013cd:	c3                   	ret    

008013ce <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8013ce:	55                   	push   %ebp
  8013cf:	89 e5                	mov    %esp,%ebp
  8013d1:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8013d4:	a1 04 40 80 00       	mov    0x804004,%eax
  8013d9:	85 c0                	test   %eax,%eax
  8013db:	74 1f                	je     8013fc <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8013dd:	e8 1d 00 00 00       	call   8013ff <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8013e2:	83 ec 0c             	sub    $0xc,%esp
  8013e5:	68 f0 39 80 00       	push   $0x8039f0
  8013ea:	e8 55 f2 ff ff       	call   800644 <cprintf>
  8013ef:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8013f2:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8013f9:	00 00 00 
	}
}
  8013fc:	90                   	nop
  8013fd:	c9                   	leave  
  8013fe:	c3                   	ret    

008013ff <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8013ff:	55                   	push   %ebp
  801400:	89 e5                	mov    %esp,%ebp
  801402:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  801405:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  80140c:	00 00 00 
  80140f:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801416:	00 00 00 
  801419:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801420:	00 00 00 
		LIST_INIT(&AllocMemBlocksList);
  801423:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  80142a:	00 00 00 
  80142d:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801434:	00 00 00 
  801437:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  80143e:	00 00 00 

		MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES ;
  801441:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801448:	00 02 00 
		MemBlockNodes =(struct MemBlock*)USER_DYN_BLKS_ARRAY ;
  80144b:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801452:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801455:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80145a:	2d 00 10 00 00       	sub    $0x1000,%eax
  80145f:	a3 50 40 80 00       	mov    %eax,0x804050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock),PAGE_SIZE),PERM_USER|PERM_WRITEABLE);
  801464:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80146b:	a1 20 41 80 00       	mov    0x804120,%eax
  801470:	c1 e0 04             	shl    $0x4,%eax
  801473:	89 c2                	mov    %eax,%edx
  801475:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801478:	01 d0                	add    %edx,%eax
  80147a:	48                   	dec    %eax
  80147b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80147e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801481:	ba 00 00 00 00       	mov    $0x0,%edx
  801486:	f7 75 f0             	divl   -0x10(%ebp)
  801489:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80148c:	29 d0                	sub    %edx,%eax
  80148e:	89 c2                	mov    %eax,%edx
  801490:	c7 45 e8 00 00 e0 7f 	movl   $0x7fe00000,-0x18(%ebp)
  801497:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80149a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80149f:	2d 00 10 00 00       	sub    $0x1000,%eax
  8014a4:	83 ec 04             	sub    $0x4,%esp
  8014a7:	6a 06                	push   $0x6
  8014a9:	52                   	push   %edx
  8014aa:	50                   	push   %eax
  8014ab:	e8 71 05 00 00       	call   801a21 <sys_allocate_chunk>
  8014b0:	83 c4 10             	add    $0x10,%esp
		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8014b3:	a1 20 41 80 00       	mov    0x804120,%eax
  8014b8:	83 ec 0c             	sub    $0xc,%esp
  8014bb:	50                   	push   %eax
  8014bc:	e8 e6 0b 00 00       	call   8020a7 <initialize_MemBlocksList>
  8014c1:	83 c4 10             	add    $0x10,%esp

		struct MemBlock  *block_node;
		block_node = AvailableMemBlocksList.lh_first;
  8014c4:	a1 48 41 80 00       	mov    0x804148,%eax
  8014c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&(AvailableMemBlocksList),block_node);
  8014cc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8014d0:	75 14                	jne    8014e6 <initialize_dyn_block_system+0xe7>
  8014d2:	83 ec 04             	sub    $0x4,%esp
  8014d5:	68 15 3a 80 00       	push   $0x803a15
  8014da:	6a 2b                	push   $0x2b
  8014dc:	68 33 3a 80 00       	push   $0x803a33
  8014e1:	e8 aa ee ff ff       	call   800390 <_panic>
  8014e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014e9:	8b 00                	mov    (%eax),%eax
  8014eb:	85 c0                	test   %eax,%eax
  8014ed:	74 10                	je     8014ff <initialize_dyn_block_system+0x100>
  8014ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014f2:	8b 00                	mov    (%eax),%eax
  8014f4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8014f7:	8b 52 04             	mov    0x4(%edx),%edx
  8014fa:	89 50 04             	mov    %edx,0x4(%eax)
  8014fd:	eb 0b                	jmp    80150a <initialize_dyn_block_system+0x10b>
  8014ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801502:	8b 40 04             	mov    0x4(%eax),%eax
  801505:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80150a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80150d:	8b 40 04             	mov    0x4(%eax),%eax
  801510:	85 c0                	test   %eax,%eax
  801512:	74 0f                	je     801523 <initialize_dyn_block_system+0x124>
  801514:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801517:	8b 40 04             	mov    0x4(%eax),%eax
  80151a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80151d:	8b 12                	mov    (%edx),%edx
  80151f:	89 10                	mov    %edx,(%eax)
  801521:	eb 0a                	jmp    80152d <initialize_dyn_block_system+0x12e>
  801523:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801526:	8b 00                	mov    (%eax),%eax
  801528:	a3 48 41 80 00       	mov    %eax,0x804148
  80152d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801530:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801536:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801539:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801540:	a1 54 41 80 00       	mov    0x804154,%eax
  801545:	48                   	dec    %eax
  801546:	a3 54 41 80 00       	mov    %eax,0x804154
		block_node->sva = USER_HEAP_START ;
  80154b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80154e:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
		block_node->size = ((USER_HEAP_MAX - USER_HEAP_START));
  801555:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801558:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		insert_sorted_with_merge_freeList(block_node);
  80155f:	83 ec 0c             	sub    $0xc,%esp
  801562:	ff 75 e4             	pushl  -0x1c(%ebp)
  801565:	e8 d2 13 00 00       	call   80293c <insert_sorted_with_merge_freeList>
  80156a:	83 c4 10             	add    $0x10,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  80156d:	90                   	nop
  80156e:	c9                   	leave  
  80156f:	c3                   	ret    

00801570 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801570:	55                   	push   %ebp
  801571:	89 e5                	mov    %esp,%ebp
  801573:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801576:	e8 53 fe ff ff       	call   8013ce <InitializeUHeap>
	if (size == 0) return NULL ;
  80157b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80157f:	75 07                	jne    801588 <malloc+0x18>
  801581:	b8 00 00 00 00       	mov    $0x0,%eax
  801586:	eb 61                	jmp    8015e9 <malloc+0x79>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	size= ROUNDUP(size,PAGE_SIZE);
  801588:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80158f:	8b 55 08             	mov    0x8(%ebp),%edx
  801592:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801595:	01 d0                	add    %edx,%eax
  801597:	48                   	dec    %eax
  801598:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80159b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80159e:	ba 00 00 00 00       	mov    $0x0,%edx
  8015a3:	f7 75 f4             	divl   -0xc(%ebp)
  8015a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015a9:	29 d0                	sub    %edx,%eax
  8015ab:	89 45 08             	mov    %eax,0x8(%ebp)
	    			if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8015ae:	e8 3c 08 00 00       	call   801def <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015b3:	85 c0                	test   %eax,%eax
  8015b5:	74 2d                	je     8015e4 <malloc+0x74>
	    			{
	    				struct MemBlock * ff_block = alloc_block_FF(size);
  8015b7:	83 ec 0c             	sub    $0xc,%esp
  8015ba:	ff 75 08             	pushl  0x8(%ebp)
  8015bd:	e8 3e 0f 00 00       	call   802500 <alloc_block_FF>
  8015c2:	83 c4 10             	add    $0x10,%esp
  8015c5:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    				if(ff_block!=NULL)
  8015c8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8015cc:	74 16                	je     8015e4 <malloc+0x74>
	    				{

	    					insert_sorted_allocList(ff_block);
  8015ce:	83 ec 0c             	sub    $0xc,%esp
  8015d1:	ff 75 ec             	pushl  -0x14(%ebp)
  8015d4:	e8 48 0c 00 00       	call   802221 <insert_sorted_allocList>
  8015d9:	83 c4 10             	add    $0x10,%esp
	    					return (void*) ff_block->sva ;
  8015dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015df:	8b 40 08             	mov    0x8(%eax),%eax
  8015e2:	eb 05                	jmp    8015e9 <malloc+0x79>

	    				}
	}
	    			return (void*) NULL ;
  8015e4:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  8015e9:	c9                   	leave  
  8015ea:	c3                   	ret    

008015eb <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8015eb:	55                   	push   %ebp
  8015ec:	89 e5                	mov    %esp,%ebp
  8015ee:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock *elementForEach;
		virtual_address = ROUNDDOWN(virtual_address, PAGE_SIZE);
  8015f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8015f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015fa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015ff:	89 45 08             	mov    %eax,0x8(%ebp)
	//	if (is_mallocPages[indexindex((uint32) virtual_address)] == 1) {
		elementForEach = find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801602:	8b 45 08             	mov    0x8(%ebp),%eax
  801605:	83 ec 08             	sub    $0x8,%esp
  801608:	50                   	push   %eax
  801609:	68 40 40 80 00       	push   $0x804040
  80160e:	e8 71 0b 00 00       	call   802184 <find_block>
  801613:	83 c4 10             	add    $0x10,%esp
  801616:	89 45 f0             	mov    %eax,-0x10(%ebp)
		sys_free_user_mem((uint32) virtual_address, elementForEach->size);
  801619:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80161c:	8b 50 0c             	mov    0xc(%eax),%edx
  80161f:	8b 45 08             	mov    0x8(%ebp),%eax
  801622:	83 ec 08             	sub    $0x8,%esp
  801625:	52                   	push   %edx
  801626:	50                   	push   %eax
  801627:	e8 bd 03 00 00       	call   8019e9 <sys_free_user_mem>
  80162c:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,elementForEach);
  80162f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801633:	75 14                	jne    801649 <free+0x5e>
  801635:	83 ec 04             	sub    $0x4,%esp
  801638:	68 15 3a 80 00       	push   $0x803a15
  80163d:	6a 71                	push   $0x71
  80163f:	68 33 3a 80 00       	push   $0x803a33
  801644:	e8 47 ed ff ff       	call   800390 <_panic>
  801649:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80164c:	8b 00                	mov    (%eax),%eax
  80164e:	85 c0                	test   %eax,%eax
  801650:	74 10                	je     801662 <free+0x77>
  801652:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801655:	8b 00                	mov    (%eax),%eax
  801657:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80165a:	8b 52 04             	mov    0x4(%edx),%edx
  80165d:	89 50 04             	mov    %edx,0x4(%eax)
  801660:	eb 0b                	jmp    80166d <free+0x82>
  801662:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801665:	8b 40 04             	mov    0x4(%eax),%eax
  801668:	a3 44 40 80 00       	mov    %eax,0x804044
  80166d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801670:	8b 40 04             	mov    0x4(%eax),%eax
  801673:	85 c0                	test   %eax,%eax
  801675:	74 0f                	je     801686 <free+0x9b>
  801677:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80167a:	8b 40 04             	mov    0x4(%eax),%eax
  80167d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801680:	8b 12                	mov    (%edx),%edx
  801682:	89 10                	mov    %edx,(%eax)
  801684:	eb 0a                	jmp    801690 <free+0xa5>
  801686:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801689:	8b 00                	mov    (%eax),%eax
  80168b:	a3 40 40 80 00       	mov    %eax,0x804040
  801690:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801693:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801699:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80169c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8016a3:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8016a8:	48                   	dec    %eax
  8016a9:	a3 4c 40 80 00       	mov    %eax,0x80404c
		insert_sorted_with_merge_freeList(elementForEach);
  8016ae:	83 ec 0c             	sub    $0xc,%esp
  8016b1:	ff 75 f0             	pushl  -0x10(%ebp)
  8016b4:	e8 83 12 00 00       	call   80293c <insert_sorted_with_merge_freeList>
  8016b9:	83 c4 10             	add    $0x10,%esp
	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  8016bc:	90                   	nop
  8016bd:	c9                   	leave  
  8016be:	c3                   	ret    

008016bf <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8016bf:	55                   	push   %ebp
  8016c0:	89 e5                	mov    %esp,%ebp
  8016c2:	83 ec 28             	sub    $0x28,%esp
  8016c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8016c8:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016cb:	e8 fe fc ff ff       	call   8013ce <InitializeUHeap>
	if (size == 0) return NULL ;
  8016d0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016d4:	75 0a                	jne    8016e0 <smalloc+0x21>
  8016d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8016db:	e9 86 00 00 00       	jmp    801766 <smalloc+0xa7>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code

	size=ROUNDUP(size,PAGE_SIZE);
  8016e0:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8016e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016ed:	01 d0                	add    %edx,%eax
  8016ef:	48                   	dec    %eax
  8016f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8016fb:	f7 75 f4             	divl   -0xc(%ebp)
  8016fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801701:	29 d0                	sub    %edx,%eax
  801703:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801706:	e8 e4 06 00 00       	call   801def <sys_isUHeapPlacementStrategyFIRSTFIT>
  80170b:	85 c0                	test   %eax,%eax
  80170d:	74 52                	je     801761 <smalloc+0xa2>
		{
		struct MemBlock * ff_block ;
		ff_block = alloc_block_FF(size);
  80170f:	83 ec 0c             	sub    $0xc,%esp
  801712:	ff 75 0c             	pushl  0xc(%ebp)
  801715:	e8 e6 0d 00 00       	call   802500 <alloc_block_FF>
  80171a:	83 c4 10             	add    $0x10,%esp
  80171d:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(ff_block==NULL)
  801720:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801724:	75 07                	jne    80172d <smalloc+0x6e>
			return NULL ;
  801726:	b8 00 00 00 00       	mov    $0x0,%eax
  80172b:	eb 39                	jmp    801766 <smalloc+0xa7>

		int obj_id =sys_createSharedObject(sharedVarName,size,isWritable,(void*)ff_block->sva);
  80172d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801730:	8b 40 08             	mov    0x8(%eax),%eax
  801733:	89 c2                	mov    %eax,%edx
  801735:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801739:	52                   	push   %edx
  80173a:	50                   	push   %eax
  80173b:	ff 75 0c             	pushl  0xc(%ebp)
  80173e:	ff 75 08             	pushl  0x8(%ebp)
  801741:	e8 2e 04 00 00       	call   801b74 <sys_createSharedObject>
  801746:	83 c4 10             	add    $0x10,%esp
  801749:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(obj_id < 0)
  80174c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801750:	79 07                	jns    801759 <smalloc+0x9a>
			return (void*)NULL ;
  801752:	b8 00 00 00 00       	mov    $0x0,%eax
  801757:	eb 0d                	jmp    801766 <smalloc+0xa7>
		else
		    return (void*)ff_block->sva ;
  801759:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80175c:	8b 40 08             	mov    0x8(%eax),%eax
  80175f:	eb 05                	jmp    801766 <smalloc+0xa7>
		}
		return (void*)NULL ;
  801761:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801766:	c9                   	leave  
  801767:	c3                   	ret    

00801768 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801768:	55                   	push   %ebp
  801769:	89 e5                	mov    %esp,%ebp
  80176b:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80176e:	e8 5b fc ff ff       	call   8013ce <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801773:	83 ec 08             	sub    $0x8,%esp
  801776:	ff 75 0c             	pushl  0xc(%ebp)
  801779:	ff 75 08             	pushl  0x8(%ebp)
  80177c:	e8 1d 04 00 00       	call   801b9e <sys_getSizeOfSharedObject>
  801781:	83 c4 10             	add    $0x10,%esp
  801784:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(size == 0)
  801787:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80178b:	75 0a                	jne    801797 <sget+0x2f>
			return NULL ;
  80178d:	b8 00 00 00 00       	mov    $0x0,%eax
  801792:	e9 83 00 00 00       	jmp    80181a <sget+0xb2>
		size=ROUNDUP(size,PAGE_SIZE);
  801797:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80179e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017a4:	01 d0                	add    %edx,%eax
  8017a6:	48                   	dec    %eax
  8017a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8017aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8017b2:	f7 75 f0             	divl   -0x10(%ebp)
  8017b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017b8:	29 d0                	sub    %edx,%eax
  8017ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8017bd:	e8 2d 06 00 00       	call   801def <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017c2:	85 c0                	test   %eax,%eax
  8017c4:	74 4f                	je     801815 <sget+0xad>
		{
			struct MemBlock * ff_block ;
				ff_block = alloc_block_FF(size);
  8017c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017c9:	83 ec 0c             	sub    $0xc,%esp
  8017cc:	50                   	push   %eax
  8017cd:	e8 2e 0d 00 00       	call   802500 <alloc_block_FF>
  8017d2:	83 c4 10             	add    $0x10,%esp
  8017d5:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ff_block==NULL)
  8017d8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8017dc:	75 07                	jne    8017e5 <sget+0x7d>
					return (void*)NULL ;
  8017de:	b8 00 00 00 00       	mov    $0x0,%eax
  8017e3:	eb 35                	jmp    80181a <sget+0xb2>

		int obj_id =sys_getSharedObject((int)ownerEnvID,sharedVarName,(void*)ff_block->sva);
  8017e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017e8:	8b 40 08             	mov    0x8(%eax),%eax
  8017eb:	83 ec 04             	sub    $0x4,%esp
  8017ee:	50                   	push   %eax
  8017ef:	ff 75 0c             	pushl  0xc(%ebp)
  8017f2:	ff 75 08             	pushl  0x8(%ebp)
  8017f5:	e8 c1 03 00 00       	call   801bbb <sys_getSharedObject>
  8017fa:	83 c4 10             	add    $0x10,%esp
  8017fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if(obj_id<0)
  801800:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801804:	79 07                	jns    80180d <sget+0xa5>
				return (void*)NULL ;
  801806:	b8 00 00 00 00       	mov    $0x0,%eax
  80180b:	eb 0d                	jmp    80181a <sget+0xb2>
			else
				return (void*)ff_block->sva ;
  80180d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801810:	8b 40 08             	mov    0x8(%eax),%eax
  801813:	eb 05                	jmp    80181a <sget+0xb2>


		}
	return (void*)NULL ;
  801815:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80181a:	c9                   	leave  
  80181b:	c3                   	ret    

0080181c <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80181c:	55                   	push   %ebp
  80181d:	89 e5                	mov    %esp,%ebp
  80181f:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801822:	e8 a7 fb ff ff       	call   8013ce <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801827:	83 ec 04             	sub    $0x4,%esp
  80182a:	68 40 3a 80 00       	push   $0x803a40
  80182f:	68 f9 00 00 00       	push   $0xf9
  801834:	68 33 3a 80 00       	push   $0x803a33
  801839:	e8 52 eb ff ff       	call   800390 <_panic>

0080183e <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80183e:	55                   	push   %ebp
  80183f:	89 e5                	mov    %esp,%ebp
  801841:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801844:	83 ec 04             	sub    $0x4,%esp
  801847:	68 68 3a 80 00       	push   $0x803a68
  80184c:	68 0d 01 00 00       	push   $0x10d
  801851:	68 33 3a 80 00       	push   $0x803a33
  801856:	e8 35 eb ff ff       	call   800390 <_panic>

0080185b <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80185b:	55                   	push   %ebp
  80185c:	89 e5                	mov    %esp,%ebp
  80185e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801861:	83 ec 04             	sub    $0x4,%esp
  801864:	68 8c 3a 80 00       	push   $0x803a8c
  801869:	68 18 01 00 00       	push   $0x118
  80186e:	68 33 3a 80 00       	push   $0x803a33
  801873:	e8 18 eb ff ff       	call   800390 <_panic>

00801878 <shrink>:

}
void shrink(uint32 newSize)
{
  801878:	55                   	push   %ebp
  801879:	89 e5                	mov    %esp,%ebp
  80187b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80187e:	83 ec 04             	sub    $0x4,%esp
  801881:	68 8c 3a 80 00       	push   $0x803a8c
  801886:	68 1d 01 00 00       	push   $0x11d
  80188b:	68 33 3a 80 00       	push   $0x803a33
  801890:	e8 fb ea ff ff       	call   800390 <_panic>

00801895 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801895:	55                   	push   %ebp
  801896:	89 e5                	mov    %esp,%ebp
  801898:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80189b:	83 ec 04             	sub    $0x4,%esp
  80189e:	68 8c 3a 80 00       	push   $0x803a8c
  8018a3:	68 22 01 00 00       	push   $0x122
  8018a8:	68 33 3a 80 00       	push   $0x803a33
  8018ad:	e8 de ea ff ff       	call   800390 <_panic>

008018b2 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8018b2:	55                   	push   %ebp
  8018b3:	89 e5                	mov    %esp,%ebp
  8018b5:	57                   	push   %edi
  8018b6:	56                   	push   %esi
  8018b7:	53                   	push   %ebx
  8018b8:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018c4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018c7:	8b 7d 18             	mov    0x18(%ebp),%edi
  8018ca:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8018cd:	cd 30                	int    $0x30
  8018cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8018d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018d5:	83 c4 10             	add    $0x10,%esp
  8018d8:	5b                   	pop    %ebx
  8018d9:	5e                   	pop    %esi
  8018da:	5f                   	pop    %edi
  8018db:	5d                   	pop    %ebp
  8018dc:	c3                   	ret    

008018dd <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8018dd:	55                   	push   %ebp
  8018de:	89 e5                	mov    %esp,%ebp
  8018e0:	83 ec 04             	sub    $0x4,%esp
  8018e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8018e6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8018e9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f0:	6a 00                	push   $0x0
  8018f2:	6a 00                	push   $0x0
  8018f4:	52                   	push   %edx
  8018f5:	ff 75 0c             	pushl  0xc(%ebp)
  8018f8:	50                   	push   %eax
  8018f9:	6a 00                	push   $0x0
  8018fb:	e8 b2 ff ff ff       	call   8018b2 <syscall>
  801900:	83 c4 18             	add    $0x18,%esp
}
  801903:	90                   	nop
  801904:	c9                   	leave  
  801905:	c3                   	ret    

00801906 <sys_cgetc>:

int
sys_cgetc(void)
{
  801906:	55                   	push   %ebp
  801907:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801909:	6a 00                	push   $0x0
  80190b:	6a 00                	push   $0x0
  80190d:	6a 00                	push   $0x0
  80190f:	6a 00                	push   $0x0
  801911:	6a 00                	push   $0x0
  801913:	6a 01                	push   $0x1
  801915:	e8 98 ff ff ff       	call   8018b2 <syscall>
  80191a:	83 c4 18             	add    $0x18,%esp
}
  80191d:	c9                   	leave  
  80191e:	c3                   	ret    

0080191f <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80191f:	55                   	push   %ebp
  801920:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801922:	8b 55 0c             	mov    0xc(%ebp),%edx
  801925:	8b 45 08             	mov    0x8(%ebp),%eax
  801928:	6a 00                	push   $0x0
  80192a:	6a 00                	push   $0x0
  80192c:	6a 00                	push   $0x0
  80192e:	52                   	push   %edx
  80192f:	50                   	push   %eax
  801930:	6a 05                	push   $0x5
  801932:	e8 7b ff ff ff       	call   8018b2 <syscall>
  801937:	83 c4 18             	add    $0x18,%esp
}
  80193a:	c9                   	leave  
  80193b:	c3                   	ret    

0080193c <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80193c:	55                   	push   %ebp
  80193d:	89 e5                	mov    %esp,%ebp
  80193f:	56                   	push   %esi
  801940:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801941:	8b 75 18             	mov    0x18(%ebp),%esi
  801944:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801947:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80194a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80194d:	8b 45 08             	mov    0x8(%ebp),%eax
  801950:	56                   	push   %esi
  801951:	53                   	push   %ebx
  801952:	51                   	push   %ecx
  801953:	52                   	push   %edx
  801954:	50                   	push   %eax
  801955:	6a 06                	push   $0x6
  801957:	e8 56 ff ff ff       	call   8018b2 <syscall>
  80195c:	83 c4 18             	add    $0x18,%esp
}
  80195f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801962:	5b                   	pop    %ebx
  801963:	5e                   	pop    %esi
  801964:	5d                   	pop    %ebp
  801965:	c3                   	ret    

00801966 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801966:	55                   	push   %ebp
  801967:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801969:	8b 55 0c             	mov    0xc(%ebp),%edx
  80196c:	8b 45 08             	mov    0x8(%ebp),%eax
  80196f:	6a 00                	push   $0x0
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	52                   	push   %edx
  801976:	50                   	push   %eax
  801977:	6a 07                	push   $0x7
  801979:	e8 34 ff ff ff       	call   8018b2 <syscall>
  80197e:	83 c4 18             	add    $0x18,%esp
}
  801981:	c9                   	leave  
  801982:	c3                   	ret    

00801983 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801983:	55                   	push   %ebp
  801984:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	ff 75 0c             	pushl  0xc(%ebp)
  80198f:	ff 75 08             	pushl  0x8(%ebp)
  801992:	6a 08                	push   $0x8
  801994:	e8 19 ff ff ff       	call   8018b2 <syscall>
  801999:	83 c4 18             	add    $0x18,%esp
}
  80199c:	c9                   	leave  
  80199d:	c3                   	ret    

0080199e <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80199e:	55                   	push   %ebp
  80199f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 09                	push   $0x9
  8019ad:	e8 00 ff ff ff       	call   8018b2 <syscall>
  8019b2:	83 c4 18             	add    $0x18,%esp
}
  8019b5:	c9                   	leave  
  8019b6:	c3                   	ret    

008019b7 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8019b7:	55                   	push   %ebp
  8019b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 00                	push   $0x0
  8019c4:	6a 0a                	push   $0xa
  8019c6:	e8 e7 fe ff ff       	call   8018b2 <syscall>
  8019cb:	83 c4 18             	add    $0x18,%esp
}
  8019ce:	c9                   	leave  
  8019cf:	c3                   	ret    

008019d0 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8019d0:	55                   	push   %ebp
  8019d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 0b                	push   $0xb
  8019df:	e8 ce fe ff ff       	call   8018b2 <syscall>
  8019e4:	83 c4 18             	add    $0x18,%esp
}
  8019e7:	c9                   	leave  
  8019e8:	c3                   	ret    

008019e9 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019e9:	55                   	push   %ebp
  8019ea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 00                	push   $0x0
  8019f2:	ff 75 0c             	pushl  0xc(%ebp)
  8019f5:	ff 75 08             	pushl  0x8(%ebp)
  8019f8:	6a 0f                	push   $0xf
  8019fa:	e8 b3 fe ff ff       	call   8018b2 <syscall>
  8019ff:	83 c4 18             	add    $0x18,%esp
	return;
  801a02:	90                   	nop
}
  801a03:	c9                   	leave  
  801a04:	c3                   	ret    

00801a05 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a05:	55                   	push   %ebp
  801a06:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 00                	push   $0x0
  801a0e:	ff 75 0c             	pushl  0xc(%ebp)
  801a11:	ff 75 08             	pushl  0x8(%ebp)
  801a14:	6a 10                	push   $0x10
  801a16:	e8 97 fe ff ff       	call   8018b2 <syscall>
  801a1b:	83 c4 18             	add    $0x18,%esp
	return ;
  801a1e:	90                   	nop
}
  801a1f:	c9                   	leave  
  801a20:	c3                   	ret    

00801a21 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a21:	55                   	push   %ebp
  801a22:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a24:	6a 00                	push   $0x0
  801a26:	6a 00                	push   $0x0
  801a28:	ff 75 10             	pushl  0x10(%ebp)
  801a2b:	ff 75 0c             	pushl  0xc(%ebp)
  801a2e:	ff 75 08             	pushl  0x8(%ebp)
  801a31:	6a 11                	push   $0x11
  801a33:	e8 7a fe ff ff       	call   8018b2 <syscall>
  801a38:	83 c4 18             	add    $0x18,%esp
	return ;
  801a3b:	90                   	nop
}
  801a3c:	c9                   	leave  
  801a3d:	c3                   	ret    

00801a3e <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a3e:	55                   	push   %ebp
  801a3f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a41:	6a 00                	push   $0x0
  801a43:	6a 00                	push   $0x0
  801a45:	6a 00                	push   $0x0
  801a47:	6a 00                	push   $0x0
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 0c                	push   $0xc
  801a4d:	e8 60 fe ff ff       	call   8018b2 <syscall>
  801a52:	83 c4 18             	add    $0x18,%esp
}
  801a55:	c9                   	leave  
  801a56:	c3                   	ret    

00801a57 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a57:	55                   	push   %ebp
  801a58:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a5a:	6a 00                	push   $0x0
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 00                	push   $0x0
  801a62:	ff 75 08             	pushl  0x8(%ebp)
  801a65:	6a 0d                	push   $0xd
  801a67:	e8 46 fe ff ff       	call   8018b2 <syscall>
  801a6c:	83 c4 18             	add    $0x18,%esp
}
  801a6f:	c9                   	leave  
  801a70:	c3                   	ret    

00801a71 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a71:	55                   	push   %ebp
  801a72:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a74:	6a 00                	push   $0x0
  801a76:	6a 00                	push   $0x0
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 0e                	push   $0xe
  801a80:	e8 2d fe ff ff       	call   8018b2 <syscall>
  801a85:	83 c4 18             	add    $0x18,%esp
}
  801a88:	90                   	nop
  801a89:	c9                   	leave  
  801a8a:	c3                   	ret    

00801a8b <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a8b:	55                   	push   %ebp
  801a8c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	6a 13                	push   $0x13
  801a9a:	e8 13 fe ff ff       	call   8018b2 <syscall>
  801a9f:	83 c4 18             	add    $0x18,%esp
}
  801aa2:	90                   	nop
  801aa3:	c9                   	leave  
  801aa4:	c3                   	ret    

00801aa5 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801aa5:	55                   	push   %ebp
  801aa6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 14                	push   $0x14
  801ab4:	e8 f9 fd ff ff       	call   8018b2 <syscall>
  801ab9:	83 c4 18             	add    $0x18,%esp
}
  801abc:	90                   	nop
  801abd:	c9                   	leave  
  801abe:	c3                   	ret    

00801abf <sys_cputc>:


void
sys_cputc(const char c)
{
  801abf:	55                   	push   %ebp
  801ac0:	89 e5                	mov    %esp,%ebp
  801ac2:	83 ec 04             	sub    $0x4,%esp
  801ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801acb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 00                	push   $0x0
  801ad3:	6a 00                	push   $0x0
  801ad5:	6a 00                	push   $0x0
  801ad7:	50                   	push   %eax
  801ad8:	6a 15                	push   $0x15
  801ada:	e8 d3 fd ff ff       	call   8018b2 <syscall>
  801adf:	83 c4 18             	add    $0x18,%esp
}
  801ae2:	90                   	nop
  801ae3:	c9                   	leave  
  801ae4:	c3                   	ret    

00801ae5 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ae5:	55                   	push   %ebp
  801ae6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	6a 00                	push   $0x0
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	6a 16                	push   $0x16
  801af4:	e8 b9 fd ff ff       	call   8018b2 <syscall>
  801af9:	83 c4 18             	add    $0x18,%esp
}
  801afc:	90                   	nop
  801afd:	c9                   	leave  
  801afe:	c3                   	ret    

00801aff <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801aff:	55                   	push   %ebp
  801b00:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801b02:	8b 45 08             	mov    0x8(%ebp),%eax
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	ff 75 0c             	pushl  0xc(%ebp)
  801b0e:	50                   	push   %eax
  801b0f:	6a 17                	push   $0x17
  801b11:	e8 9c fd ff ff       	call   8018b2 <syscall>
  801b16:	83 c4 18             	add    $0x18,%esp
}
  801b19:	c9                   	leave  
  801b1a:	c3                   	ret    

00801b1b <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b1b:	55                   	push   %ebp
  801b1c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b21:	8b 45 08             	mov    0x8(%ebp),%eax
  801b24:	6a 00                	push   $0x0
  801b26:	6a 00                	push   $0x0
  801b28:	6a 00                	push   $0x0
  801b2a:	52                   	push   %edx
  801b2b:	50                   	push   %eax
  801b2c:	6a 1a                	push   $0x1a
  801b2e:	e8 7f fd ff ff       	call   8018b2 <syscall>
  801b33:	83 c4 18             	add    $0x18,%esp
}
  801b36:	c9                   	leave  
  801b37:	c3                   	ret    

00801b38 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b38:	55                   	push   %ebp
  801b39:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b41:	6a 00                	push   $0x0
  801b43:	6a 00                	push   $0x0
  801b45:	6a 00                	push   $0x0
  801b47:	52                   	push   %edx
  801b48:	50                   	push   %eax
  801b49:	6a 18                	push   $0x18
  801b4b:	e8 62 fd ff ff       	call   8018b2 <syscall>
  801b50:	83 c4 18             	add    $0x18,%esp
}
  801b53:	90                   	nop
  801b54:	c9                   	leave  
  801b55:	c3                   	ret    

00801b56 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b56:	55                   	push   %ebp
  801b57:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b59:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5f:	6a 00                	push   $0x0
  801b61:	6a 00                	push   $0x0
  801b63:	6a 00                	push   $0x0
  801b65:	52                   	push   %edx
  801b66:	50                   	push   %eax
  801b67:	6a 19                	push   $0x19
  801b69:	e8 44 fd ff ff       	call   8018b2 <syscall>
  801b6e:	83 c4 18             	add    $0x18,%esp
}
  801b71:	90                   	nop
  801b72:	c9                   	leave  
  801b73:	c3                   	ret    

00801b74 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b74:	55                   	push   %ebp
  801b75:	89 e5                	mov    %esp,%ebp
  801b77:	83 ec 04             	sub    $0x4,%esp
  801b7a:	8b 45 10             	mov    0x10(%ebp),%eax
  801b7d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b80:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b83:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b87:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8a:	6a 00                	push   $0x0
  801b8c:	51                   	push   %ecx
  801b8d:	52                   	push   %edx
  801b8e:	ff 75 0c             	pushl  0xc(%ebp)
  801b91:	50                   	push   %eax
  801b92:	6a 1b                	push   $0x1b
  801b94:	e8 19 fd ff ff       	call   8018b2 <syscall>
  801b99:	83 c4 18             	add    $0x18,%esp
}
  801b9c:	c9                   	leave  
  801b9d:	c3                   	ret    

00801b9e <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b9e:	55                   	push   %ebp
  801b9f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801ba1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	52                   	push   %edx
  801bae:	50                   	push   %eax
  801baf:	6a 1c                	push   $0x1c
  801bb1:	e8 fc fc ff ff       	call   8018b2 <syscall>
  801bb6:	83 c4 18             	add    $0x18,%esp
}
  801bb9:	c9                   	leave  
  801bba:	c3                   	ret    

00801bbb <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801bbb:	55                   	push   %ebp
  801bbc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801bbe:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bc1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 00                	push   $0x0
  801bcb:	51                   	push   %ecx
  801bcc:	52                   	push   %edx
  801bcd:	50                   	push   %eax
  801bce:	6a 1d                	push   $0x1d
  801bd0:	e8 dd fc ff ff       	call   8018b2 <syscall>
  801bd5:	83 c4 18             	add    $0x18,%esp
}
  801bd8:	c9                   	leave  
  801bd9:	c3                   	ret    

00801bda <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801bda:	55                   	push   %ebp
  801bdb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801bdd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801be0:	8b 45 08             	mov    0x8(%ebp),%eax
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	6a 00                	push   $0x0
  801be9:	52                   	push   %edx
  801bea:	50                   	push   %eax
  801beb:	6a 1e                	push   $0x1e
  801bed:	e8 c0 fc ff ff       	call   8018b2 <syscall>
  801bf2:	83 c4 18             	add    $0x18,%esp
}
  801bf5:	c9                   	leave  
  801bf6:	c3                   	ret    

00801bf7 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801bf7:	55                   	push   %ebp
  801bf8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801bfa:	6a 00                	push   $0x0
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	6a 1f                	push   $0x1f
  801c06:	e8 a7 fc ff ff       	call   8018b2 <syscall>
  801c0b:	83 c4 18             	add    $0x18,%esp
}
  801c0e:	c9                   	leave  
  801c0f:	c3                   	ret    

00801c10 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c10:	55                   	push   %ebp
  801c11:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c13:	8b 45 08             	mov    0x8(%ebp),%eax
  801c16:	6a 00                	push   $0x0
  801c18:	ff 75 14             	pushl  0x14(%ebp)
  801c1b:	ff 75 10             	pushl  0x10(%ebp)
  801c1e:	ff 75 0c             	pushl  0xc(%ebp)
  801c21:	50                   	push   %eax
  801c22:	6a 20                	push   $0x20
  801c24:	e8 89 fc ff ff       	call   8018b2 <syscall>
  801c29:	83 c4 18             	add    $0x18,%esp
}
  801c2c:	c9                   	leave  
  801c2d:	c3                   	ret    

00801c2e <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c2e:	55                   	push   %ebp
  801c2f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c31:	8b 45 08             	mov    0x8(%ebp),%eax
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 00                	push   $0x0
  801c3c:	50                   	push   %eax
  801c3d:	6a 21                	push   $0x21
  801c3f:	e8 6e fc ff ff       	call   8018b2 <syscall>
  801c44:	83 c4 18             	add    $0x18,%esp
}
  801c47:	90                   	nop
  801c48:	c9                   	leave  
  801c49:	c3                   	ret    

00801c4a <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c4a:	55                   	push   %ebp
  801c4b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c50:	6a 00                	push   $0x0
  801c52:	6a 00                	push   $0x0
  801c54:	6a 00                	push   $0x0
  801c56:	6a 00                	push   $0x0
  801c58:	50                   	push   %eax
  801c59:	6a 22                	push   $0x22
  801c5b:	e8 52 fc ff ff       	call   8018b2 <syscall>
  801c60:	83 c4 18             	add    $0x18,%esp
}
  801c63:	c9                   	leave  
  801c64:	c3                   	ret    

00801c65 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c65:	55                   	push   %ebp
  801c66:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 00                	push   $0x0
  801c72:	6a 02                	push   $0x2
  801c74:	e8 39 fc ff ff       	call   8018b2 <syscall>
  801c79:	83 c4 18             	add    $0x18,%esp
}
  801c7c:	c9                   	leave  
  801c7d:	c3                   	ret    

00801c7e <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c7e:	55                   	push   %ebp
  801c7f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c81:	6a 00                	push   $0x0
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 03                	push   $0x3
  801c8d:	e8 20 fc ff ff       	call   8018b2 <syscall>
  801c92:	83 c4 18             	add    $0x18,%esp
}
  801c95:	c9                   	leave  
  801c96:	c3                   	ret    

00801c97 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c97:	55                   	push   %ebp
  801c98:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 04                	push   $0x4
  801ca6:	e8 07 fc ff ff       	call   8018b2 <syscall>
  801cab:	83 c4 18             	add    $0x18,%esp
}
  801cae:	c9                   	leave  
  801caf:	c3                   	ret    

00801cb0 <sys_exit_env>:


void sys_exit_env(void)
{
  801cb0:	55                   	push   %ebp
  801cb1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801cb3:	6a 00                	push   $0x0
  801cb5:	6a 00                	push   $0x0
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 00                	push   $0x0
  801cbd:	6a 23                	push   $0x23
  801cbf:	e8 ee fb ff ff       	call   8018b2 <syscall>
  801cc4:	83 c4 18             	add    $0x18,%esp
}
  801cc7:	90                   	nop
  801cc8:	c9                   	leave  
  801cc9:	c3                   	ret    

00801cca <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801cca:	55                   	push   %ebp
  801ccb:	89 e5                	mov    %esp,%ebp
  801ccd:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801cd0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cd3:	8d 50 04             	lea    0x4(%eax),%edx
  801cd6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cd9:	6a 00                	push   $0x0
  801cdb:	6a 00                	push   $0x0
  801cdd:	6a 00                	push   $0x0
  801cdf:	52                   	push   %edx
  801ce0:	50                   	push   %eax
  801ce1:	6a 24                	push   $0x24
  801ce3:	e8 ca fb ff ff       	call   8018b2 <syscall>
  801ce8:	83 c4 18             	add    $0x18,%esp
	return result;
  801ceb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cf1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801cf4:	89 01                	mov    %eax,(%ecx)
  801cf6:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfc:	c9                   	leave  
  801cfd:	c2 04 00             	ret    $0x4

00801d00 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d00:	55                   	push   %ebp
  801d01:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d03:	6a 00                	push   $0x0
  801d05:	6a 00                	push   $0x0
  801d07:	ff 75 10             	pushl  0x10(%ebp)
  801d0a:	ff 75 0c             	pushl  0xc(%ebp)
  801d0d:	ff 75 08             	pushl  0x8(%ebp)
  801d10:	6a 12                	push   $0x12
  801d12:	e8 9b fb ff ff       	call   8018b2 <syscall>
  801d17:	83 c4 18             	add    $0x18,%esp
	return ;
  801d1a:	90                   	nop
}
  801d1b:	c9                   	leave  
  801d1c:	c3                   	ret    

00801d1d <sys_rcr2>:
uint32 sys_rcr2()
{
  801d1d:	55                   	push   %ebp
  801d1e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d20:	6a 00                	push   $0x0
  801d22:	6a 00                	push   $0x0
  801d24:	6a 00                	push   $0x0
  801d26:	6a 00                	push   $0x0
  801d28:	6a 00                	push   $0x0
  801d2a:	6a 25                	push   $0x25
  801d2c:	e8 81 fb ff ff       	call   8018b2 <syscall>
  801d31:	83 c4 18             	add    $0x18,%esp
}
  801d34:	c9                   	leave  
  801d35:	c3                   	ret    

00801d36 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d36:	55                   	push   %ebp
  801d37:	89 e5                	mov    %esp,%ebp
  801d39:	83 ec 04             	sub    $0x4,%esp
  801d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d42:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d46:	6a 00                	push   $0x0
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 00                	push   $0x0
  801d4e:	50                   	push   %eax
  801d4f:	6a 26                	push   $0x26
  801d51:	e8 5c fb ff ff       	call   8018b2 <syscall>
  801d56:	83 c4 18             	add    $0x18,%esp
	return ;
  801d59:	90                   	nop
}
  801d5a:	c9                   	leave  
  801d5b:	c3                   	ret    

00801d5c <rsttst>:
void rsttst()
{
  801d5c:	55                   	push   %ebp
  801d5d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d5f:	6a 00                	push   $0x0
  801d61:	6a 00                	push   $0x0
  801d63:	6a 00                	push   $0x0
  801d65:	6a 00                	push   $0x0
  801d67:	6a 00                	push   $0x0
  801d69:	6a 28                	push   $0x28
  801d6b:	e8 42 fb ff ff       	call   8018b2 <syscall>
  801d70:	83 c4 18             	add    $0x18,%esp
	return ;
  801d73:	90                   	nop
}
  801d74:	c9                   	leave  
  801d75:	c3                   	ret    

00801d76 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d76:	55                   	push   %ebp
  801d77:	89 e5                	mov    %esp,%ebp
  801d79:	83 ec 04             	sub    $0x4,%esp
  801d7c:	8b 45 14             	mov    0x14(%ebp),%eax
  801d7f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d82:	8b 55 18             	mov    0x18(%ebp),%edx
  801d85:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d89:	52                   	push   %edx
  801d8a:	50                   	push   %eax
  801d8b:	ff 75 10             	pushl  0x10(%ebp)
  801d8e:	ff 75 0c             	pushl  0xc(%ebp)
  801d91:	ff 75 08             	pushl  0x8(%ebp)
  801d94:	6a 27                	push   $0x27
  801d96:	e8 17 fb ff ff       	call   8018b2 <syscall>
  801d9b:	83 c4 18             	add    $0x18,%esp
	return ;
  801d9e:	90                   	nop
}
  801d9f:	c9                   	leave  
  801da0:	c3                   	ret    

00801da1 <chktst>:
void chktst(uint32 n)
{
  801da1:	55                   	push   %ebp
  801da2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801da4:	6a 00                	push   $0x0
  801da6:	6a 00                	push   $0x0
  801da8:	6a 00                	push   $0x0
  801daa:	6a 00                	push   $0x0
  801dac:	ff 75 08             	pushl  0x8(%ebp)
  801daf:	6a 29                	push   $0x29
  801db1:	e8 fc fa ff ff       	call   8018b2 <syscall>
  801db6:	83 c4 18             	add    $0x18,%esp
	return ;
  801db9:	90                   	nop
}
  801dba:	c9                   	leave  
  801dbb:	c3                   	ret    

00801dbc <inctst>:

void inctst()
{
  801dbc:	55                   	push   %ebp
  801dbd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801dbf:	6a 00                	push   $0x0
  801dc1:	6a 00                	push   $0x0
  801dc3:	6a 00                	push   $0x0
  801dc5:	6a 00                	push   $0x0
  801dc7:	6a 00                	push   $0x0
  801dc9:	6a 2a                	push   $0x2a
  801dcb:	e8 e2 fa ff ff       	call   8018b2 <syscall>
  801dd0:	83 c4 18             	add    $0x18,%esp
	return ;
  801dd3:	90                   	nop
}
  801dd4:	c9                   	leave  
  801dd5:	c3                   	ret    

00801dd6 <gettst>:
uint32 gettst()
{
  801dd6:	55                   	push   %ebp
  801dd7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 00                	push   $0x0
  801de3:	6a 2b                	push   $0x2b
  801de5:	e8 c8 fa ff ff       	call   8018b2 <syscall>
  801dea:	83 c4 18             	add    $0x18,%esp
}
  801ded:	c9                   	leave  
  801dee:	c3                   	ret    

00801def <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801def:	55                   	push   %ebp
  801df0:	89 e5                	mov    %esp,%ebp
  801df2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801df5:	6a 00                	push   $0x0
  801df7:	6a 00                	push   $0x0
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 00                	push   $0x0
  801dfd:	6a 00                	push   $0x0
  801dff:	6a 2c                	push   $0x2c
  801e01:	e8 ac fa ff ff       	call   8018b2 <syscall>
  801e06:	83 c4 18             	add    $0x18,%esp
  801e09:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e0c:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e10:	75 07                	jne    801e19 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e12:	b8 01 00 00 00       	mov    $0x1,%eax
  801e17:	eb 05                	jmp    801e1e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e19:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e1e:	c9                   	leave  
  801e1f:	c3                   	ret    

00801e20 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e20:	55                   	push   %ebp
  801e21:	89 e5                	mov    %esp,%ebp
  801e23:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e26:	6a 00                	push   $0x0
  801e28:	6a 00                	push   $0x0
  801e2a:	6a 00                	push   $0x0
  801e2c:	6a 00                	push   $0x0
  801e2e:	6a 00                	push   $0x0
  801e30:	6a 2c                	push   $0x2c
  801e32:	e8 7b fa ff ff       	call   8018b2 <syscall>
  801e37:	83 c4 18             	add    $0x18,%esp
  801e3a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e3d:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e41:	75 07                	jne    801e4a <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e43:	b8 01 00 00 00       	mov    $0x1,%eax
  801e48:	eb 05                	jmp    801e4f <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e4a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e4f:	c9                   	leave  
  801e50:	c3                   	ret    

00801e51 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e51:	55                   	push   %ebp
  801e52:	89 e5                	mov    %esp,%ebp
  801e54:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e57:	6a 00                	push   $0x0
  801e59:	6a 00                	push   $0x0
  801e5b:	6a 00                	push   $0x0
  801e5d:	6a 00                	push   $0x0
  801e5f:	6a 00                	push   $0x0
  801e61:	6a 2c                	push   $0x2c
  801e63:	e8 4a fa ff ff       	call   8018b2 <syscall>
  801e68:	83 c4 18             	add    $0x18,%esp
  801e6b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e6e:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e72:	75 07                	jne    801e7b <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e74:	b8 01 00 00 00       	mov    $0x1,%eax
  801e79:	eb 05                	jmp    801e80 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e7b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e80:	c9                   	leave  
  801e81:	c3                   	ret    

00801e82 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e82:	55                   	push   %ebp
  801e83:	89 e5                	mov    %esp,%ebp
  801e85:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e88:	6a 00                	push   $0x0
  801e8a:	6a 00                	push   $0x0
  801e8c:	6a 00                	push   $0x0
  801e8e:	6a 00                	push   $0x0
  801e90:	6a 00                	push   $0x0
  801e92:	6a 2c                	push   $0x2c
  801e94:	e8 19 fa ff ff       	call   8018b2 <syscall>
  801e99:	83 c4 18             	add    $0x18,%esp
  801e9c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e9f:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ea3:	75 07                	jne    801eac <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ea5:	b8 01 00 00 00       	mov    $0x1,%eax
  801eaa:	eb 05                	jmp    801eb1 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801eac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eb1:	c9                   	leave  
  801eb2:	c3                   	ret    

00801eb3 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801eb3:	55                   	push   %ebp
  801eb4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801eb6:	6a 00                	push   $0x0
  801eb8:	6a 00                	push   $0x0
  801eba:	6a 00                	push   $0x0
  801ebc:	6a 00                	push   $0x0
  801ebe:	ff 75 08             	pushl  0x8(%ebp)
  801ec1:	6a 2d                	push   $0x2d
  801ec3:	e8 ea f9 ff ff       	call   8018b2 <syscall>
  801ec8:	83 c4 18             	add    $0x18,%esp
	return ;
  801ecb:	90                   	nop
}
  801ecc:	c9                   	leave  
  801ecd:	c3                   	ret    

00801ece <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ece:	55                   	push   %ebp
  801ecf:	89 e5                	mov    %esp,%ebp
  801ed1:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ed2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ed5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ed8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801edb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ede:	6a 00                	push   $0x0
  801ee0:	53                   	push   %ebx
  801ee1:	51                   	push   %ecx
  801ee2:	52                   	push   %edx
  801ee3:	50                   	push   %eax
  801ee4:	6a 2e                	push   $0x2e
  801ee6:	e8 c7 f9 ff ff       	call   8018b2 <syscall>
  801eeb:	83 c4 18             	add    $0x18,%esp
}
  801eee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ef1:	c9                   	leave  
  801ef2:	c3                   	ret    

00801ef3 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ef3:	55                   	push   %ebp
  801ef4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ef6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  801efc:	6a 00                	push   $0x0
  801efe:	6a 00                	push   $0x0
  801f00:	6a 00                	push   $0x0
  801f02:	52                   	push   %edx
  801f03:	50                   	push   %eax
  801f04:	6a 2f                	push   $0x2f
  801f06:	e8 a7 f9 ff ff       	call   8018b2 <syscall>
  801f0b:	83 c4 18             	add    $0x18,%esp
}
  801f0e:	c9                   	leave  
  801f0f:	c3                   	ret    

00801f10 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801f10:	55                   	push   %ebp
  801f11:	89 e5                	mov    %esp,%ebp
  801f13:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801f16:	83 ec 0c             	sub    $0xc,%esp
  801f19:	68 9c 3a 80 00       	push   $0x803a9c
  801f1e:	e8 21 e7 ff ff       	call   800644 <cprintf>
  801f23:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801f26:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801f2d:	83 ec 0c             	sub    $0xc,%esp
  801f30:	68 c8 3a 80 00       	push   $0x803ac8
  801f35:	e8 0a e7 ff ff       	call   800644 <cprintf>
  801f3a:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801f3d:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f41:	a1 38 41 80 00       	mov    0x804138,%eax
  801f46:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f49:	eb 56                	jmp    801fa1 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f4b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f4f:	74 1c                	je     801f6d <print_mem_block_lists+0x5d>
  801f51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f54:	8b 50 08             	mov    0x8(%eax),%edx
  801f57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f5a:	8b 48 08             	mov    0x8(%eax),%ecx
  801f5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f60:	8b 40 0c             	mov    0xc(%eax),%eax
  801f63:	01 c8                	add    %ecx,%eax
  801f65:	39 c2                	cmp    %eax,%edx
  801f67:	73 04                	jae    801f6d <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801f69:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f70:	8b 50 08             	mov    0x8(%eax),%edx
  801f73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f76:	8b 40 0c             	mov    0xc(%eax),%eax
  801f79:	01 c2                	add    %eax,%edx
  801f7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7e:	8b 40 08             	mov    0x8(%eax),%eax
  801f81:	83 ec 04             	sub    $0x4,%esp
  801f84:	52                   	push   %edx
  801f85:	50                   	push   %eax
  801f86:	68 dd 3a 80 00       	push   $0x803add
  801f8b:	e8 b4 e6 ff ff       	call   800644 <cprintf>
  801f90:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f96:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f99:	a1 40 41 80 00       	mov    0x804140,%eax
  801f9e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fa1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fa5:	74 07                	je     801fae <print_mem_block_lists+0x9e>
  801fa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801faa:	8b 00                	mov    (%eax),%eax
  801fac:	eb 05                	jmp    801fb3 <print_mem_block_lists+0xa3>
  801fae:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb3:	a3 40 41 80 00       	mov    %eax,0x804140
  801fb8:	a1 40 41 80 00       	mov    0x804140,%eax
  801fbd:	85 c0                	test   %eax,%eax
  801fbf:	75 8a                	jne    801f4b <print_mem_block_lists+0x3b>
  801fc1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fc5:	75 84                	jne    801f4b <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801fc7:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fcb:	75 10                	jne    801fdd <print_mem_block_lists+0xcd>
  801fcd:	83 ec 0c             	sub    $0xc,%esp
  801fd0:	68 ec 3a 80 00       	push   $0x803aec
  801fd5:	e8 6a e6 ff ff       	call   800644 <cprintf>
  801fda:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801fdd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801fe4:	83 ec 0c             	sub    $0xc,%esp
  801fe7:	68 10 3b 80 00       	push   $0x803b10
  801fec:	e8 53 e6 ff ff       	call   800644 <cprintf>
  801ff1:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801ff4:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801ff8:	a1 40 40 80 00       	mov    0x804040,%eax
  801ffd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802000:	eb 56                	jmp    802058 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802002:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802006:	74 1c                	je     802024 <print_mem_block_lists+0x114>
  802008:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80200b:	8b 50 08             	mov    0x8(%eax),%edx
  80200e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802011:	8b 48 08             	mov    0x8(%eax),%ecx
  802014:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802017:	8b 40 0c             	mov    0xc(%eax),%eax
  80201a:	01 c8                	add    %ecx,%eax
  80201c:	39 c2                	cmp    %eax,%edx
  80201e:	73 04                	jae    802024 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802020:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802024:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802027:	8b 50 08             	mov    0x8(%eax),%edx
  80202a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202d:	8b 40 0c             	mov    0xc(%eax),%eax
  802030:	01 c2                	add    %eax,%edx
  802032:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802035:	8b 40 08             	mov    0x8(%eax),%eax
  802038:	83 ec 04             	sub    $0x4,%esp
  80203b:	52                   	push   %edx
  80203c:	50                   	push   %eax
  80203d:	68 dd 3a 80 00       	push   $0x803add
  802042:	e8 fd e5 ff ff       	call   800644 <cprintf>
  802047:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80204a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80204d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802050:	a1 48 40 80 00       	mov    0x804048,%eax
  802055:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802058:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80205c:	74 07                	je     802065 <print_mem_block_lists+0x155>
  80205e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802061:	8b 00                	mov    (%eax),%eax
  802063:	eb 05                	jmp    80206a <print_mem_block_lists+0x15a>
  802065:	b8 00 00 00 00       	mov    $0x0,%eax
  80206a:	a3 48 40 80 00       	mov    %eax,0x804048
  80206f:	a1 48 40 80 00       	mov    0x804048,%eax
  802074:	85 c0                	test   %eax,%eax
  802076:	75 8a                	jne    802002 <print_mem_block_lists+0xf2>
  802078:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80207c:	75 84                	jne    802002 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80207e:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802082:	75 10                	jne    802094 <print_mem_block_lists+0x184>
  802084:	83 ec 0c             	sub    $0xc,%esp
  802087:	68 28 3b 80 00       	push   $0x803b28
  80208c:	e8 b3 e5 ff ff       	call   800644 <cprintf>
  802091:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802094:	83 ec 0c             	sub    $0xc,%esp
  802097:	68 9c 3a 80 00       	push   $0x803a9c
  80209c:	e8 a3 e5 ff ff       	call   800644 <cprintf>
  8020a1:	83 c4 10             	add    $0x10,%esp

}
  8020a4:	90                   	nop
  8020a5:	c9                   	leave  
  8020a6:	c3                   	ret    

008020a7 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8020a7:	55                   	push   %ebp
  8020a8:	89 e5                	mov    %esp,%ebp
  8020aa:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  8020ad:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  8020b4:	00 00 00 
  8020b7:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  8020be:	00 00 00 
  8020c1:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  8020c8:	00 00 00 
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  8020cb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8020d2:	e9 9e 00 00 00       	jmp    802175 <initialize_MemBlocksList+0xce>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
  8020d7:	a1 50 40 80 00       	mov    0x804050,%eax
  8020dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020df:	c1 e2 04             	shl    $0x4,%edx
  8020e2:	01 d0                	add    %edx,%eax
  8020e4:	85 c0                	test   %eax,%eax
  8020e6:	75 14                	jne    8020fc <initialize_MemBlocksList+0x55>
  8020e8:	83 ec 04             	sub    $0x4,%esp
  8020eb:	68 50 3b 80 00       	push   $0x803b50
  8020f0:	6a 43                	push   $0x43
  8020f2:	68 73 3b 80 00       	push   $0x803b73
  8020f7:	e8 94 e2 ff ff       	call   800390 <_panic>
  8020fc:	a1 50 40 80 00       	mov    0x804050,%eax
  802101:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802104:	c1 e2 04             	shl    $0x4,%edx
  802107:	01 d0                	add    %edx,%eax
  802109:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80210f:	89 10                	mov    %edx,(%eax)
  802111:	8b 00                	mov    (%eax),%eax
  802113:	85 c0                	test   %eax,%eax
  802115:	74 18                	je     80212f <initialize_MemBlocksList+0x88>
  802117:	a1 48 41 80 00       	mov    0x804148,%eax
  80211c:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802122:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802125:	c1 e1 04             	shl    $0x4,%ecx
  802128:	01 ca                	add    %ecx,%edx
  80212a:	89 50 04             	mov    %edx,0x4(%eax)
  80212d:	eb 12                	jmp    802141 <initialize_MemBlocksList+0x9a>
  80212f:	a1 50 40 80 00       	mov    0x804050,%eax
  802134:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802137:	c1 e2 04             	shl    $0x4,%edx
  80213a:	01 d0                	add    %edx,%eax
  80213c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802141:	a1 50 40 80 00       	mov    0x804050,%eax
  802146:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802149:	c1 e2 04             	shl    $0x4,%edx
  80214c:	01 d0                	add    %edx,%eax
  80214e:	a3 48 41 80 00       	mov    %eax,0x804148
  802153:	a1 50 40 80 00       	mov    0x804050,%eax
  802158:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80215b:	c1 e2 04             	shl    $0x4,%edx
  80215e:	01 d0                	add    %edx,%eax
  802160:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802167:	a1 54 41 80 00       	mov    0x804154,%eax
  80216c:	40                   	inc    %eax
  80216d:	a3 54 41 80 00       	mov    %eax,0x804154
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  802172:	ff 45 f4             	incl   -0xc(%ebp)
  802175:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802178:	3b 45 08             	cmp    0x8(%ebp),%eax
  80217b:	0f 82 56 ff ff ff    	jb     8020d7 <initialize_MemBlocksList+0x30>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
		}
}
  802181:	90                   	nop
  802182:	c9                   	leave  
  802183:	c3                   	ret    

00802184 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802184:	55                   	push   %ebp
  802185:	89 e5                	mov    %esp,%ebp
  802187:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  80218a:	a1 38 41 80 00       	mov    0x804138,%eax
  80218f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802192:	eb 18                	jmp    8021ac <find_block+0x28>
	{
		if (ele->sva==va)
  802194:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802197:	8b 40 08             	mov    0x8(%eax),%eax
  80219a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80219d:	75 05                	jne    8021a4 <find_block+0x20>
			return ele;
  80219f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021a2:	eb 7b                	jmp    80221f <find_block+0x9b>
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  8021a4:	a1 40 41 80 00       	mov    0x804140,%eax
  8021a9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021b0:	74 07                	je     8021b9 <find_block+0x35>
  8021b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021b5:	8b 00                	mov    (%eax),%eax
  8021b7:	eb 05                	jmp    8021be <find_block+0x3a>
  8021b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8021be:	a3 40 41 80 00       	mov    %eax,0x804140
  8021c3:	a1 40 41 80 00       	mov    0x804140,%eax
  8021c8:	85 c0                	test   %eax,%eax
  8021ca:	75 c8                	jne    802194 <find_block+0x10>
  8021cc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021d0:	75 c2                	jne    802194 <find_block+0x10>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  8021d2:	a1 40 40 80 00       	mov    0x804040,%eax
  8021d7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021da:	eb 18                	jmp    8021f4 <find_block+0x70>
	{
		if (ele->sva==va)
  8021dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021df:	8b 40 08             	mov    0x8(%eax),%eax
  8021e2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8021e5:	75 05                	jne    8021ec <find_block+0x68>
					return ele;
  8021e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021ea:	eb 33                	jmp    80221f <find_block+0x9b>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  8021ec:	a1 48 40 80 00       	mov    0x804048,%eax
  8021f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021f4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021f8:	74 07                	je     802201 <find_block+0x7d>
  8021fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021fd:	8b 00                	mov    (%eax),%eax
  8021ff:	eb 05                	jmp    802206 <find_block+0x82>
  802201:	b8 00 00 00 00       	mov    $0x0,%eax
  802206:	a3 48 40 80 00       	mov    %eax,0x804048
  80220b:	a1 48 40 80 00       	mov    0x804048,%eax
  802210:	85 c0                	test   %eax,%eax
  802212:	75 c8                	jne    8021dc <find_block+0x58>
  802214:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802218:	75 c2                	jne    8021dc <find_block+0x58>
	{
		if (ele->sva==va)
					return ele;
	}
return NULL;
  80221a:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  80221f:	c9                   	leave  
  802220:	c3                   	ret    

00802221 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802221:	55                   	push   %ebp
  802222:	89 e5                	mov    %esp,%ebp
  802224:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;

int x =LIST_SIZE(&AllocMemBlocksList);
  802227:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80222c:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((x==0))
  80222f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802233:	75 62                	jne    802297 <insert_sorted_allocList+0x76>
	{
	//	blockToInsert=AllocMemBlocksList.lh_first;
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  802235:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802239:	75 14                	jne    80224f <insert_sorted_allocList+0x2e>
  80223b:	83 ec 04             	sub    $0x4,%esp
  80223e:	68 50 3b 80 00       	push   $0x803b50
  802243:	6a 69                	push   $0x69
  802245:	68 73 3b 80 00       	push   $0x803b73
  80224a:	e8 41 e1 ff ff       	call   800390 <_panic>
  80224f:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802255:	8b 45 08             	mov    0x8(%ebp),%eax
  802258:	89 10                	mov    %edx,(%eax)
  80225a:	8b 45 08             	mov    0x8(%ebp),%eax
  80225d:	8b 00                	mov    (%eax),%eax
  80225f:	85 c0                	test   %eax,%eax
  802261:	74 0d                	je     802270 <insert_sorted_allocList+0x4f>
  802263:	a1 40 40 80 00       	mov    0x804040,%eax
  802268:	8b 55 08             	mov    0x8(%ebp),%edx
  80226b:	89 50 04             	mov    %edx,0x4(%eax)
  80226e:	eb 08                	jmp    802278 <insert_sorted_allocList+0x57>
  802270:	8b 45 08             	mov    0x8(%ebp),%eax
  802273:	a3 44 40 80 00       	mov    %eax,0x804044
  802278:	8b 45 08             	mov    0x8(%ebp),%eax
  80227b:	a3 40 40 80 00       	mov    %eax,0x804040
  802280:	8b 45 08             	mov    0x8(%ebp),%eax
  802283:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80228a:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80228f:	40                   	inc    %eax
  802290:	a3 4c 40 80 00       	mov    %eax,0x80404c
  802295:	eb 72                	jmp    802309 <insert_sorted_allocList+0xe8>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
  802297:	a1 40 40 80 00       	mov    0x804040,%eax
  80229c:	8b 50 08             	mov    0x8(%eax),%edx
  80229f:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a2:	8b 40 08             	mov    0x8(%eax),%eax
  8022a5:	39 c2                	cmp    %eax,%edx
  8022a7:	76 60                	jbe    802309 <insert_sorted_allocList+0xe8>
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  8022a9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022ad:	75 14                	jne    8022c3 <insert_sorted_allocList+0xa2>
  8022af:	83 ec 04             	sub    $0x4,%esp
  8022b2:	68 50 3b 80 00       	push   $0x803b50
  8022b7:	6a 6d                	push   $0x6d
  8022b9:	68 73 3b 80 00       	push   $0x803b73
  8022be:	e8 cd e0 ff ff       	call   800390 <_panic>
  8022c3:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8022c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cc:	89 10                	mov    %edx,(%eax)
  8022ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d1:	8b 00                	mov    (%eax),%eax
  8022d3:	85 c0                	test   %eax,%eax
  8022d5:	74 0d                	je     8022e4 <insert_sorted_allocList+0xc3>
  8022d7:	a1 40 40 80 00       	mov    0x804040,%eax
  8022dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8022df:	89 50 04             	mov    %edx,0x4(%eax)
  8022e2:	eb 08                	jmp    8022ec <insert_sorted_allocList+0xcb>
  8022e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e7:	a3 44 40 80 00       	mov    %eax,0x804044
  8022ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ef:	a3 40 40 80 00       	mov    %eax,0x804040
  8022f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022fe:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802303:	40                   	inc    %eax
  802304:	a3 4c 40 80 00       	mov    %eax,0x80404c
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  802309:	a1 40 40 80 00       	mov    0x804040,%eax
  80230e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802311:	e9 b9 01 00 00       	jmp    8024cf <insert_sorted_allocList+0x2ae>
	{


		if ((blockToInsert->sva>AllocMemBlocksList.lh_first->sva)&&blockToInsert->sva<element->sva)
  802316:	8b 45 08             	mov    0x8(%ebp),%eax
  802319:	8b 50 08             	mov    0x8(%eax),%edx
  80231c:	a1 40 40 80 00       	mov    0x804040,%eax
  802321:	8b 40 08             	mov    0x8(%eax),%eax
  802324:	39 c2                	cmp    %eax,%edx
  802326:	76 7c                	jbe    8023a4 <insert_sorted_allocList+0x183>
  802328:	8b 45 08             	mov    0x8(%ebp),%eax
  80232b:	8b 50 08             	mov    0x8(%eax),%edx
  80232e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802331:	8b 40 08             	mov    0x8(%eax),%eax
  802334:	39 c2                	cmp    %eax,%edx
  802336:	73 6c                	jae    8023a4 <insert_sorted_allocList+0x183>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,element,blockToInsert);
  802338:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80233c:	74 06                	je     802344 <insert_sorted_allocList+0x123>
  80233e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802342:	75 14                	jne    802358 <insert_sorted_allocList+0x137>
  802344:	83 ec 04             	sub    $0x4,%esp
  802347:	68 8c 3b 80 00       	push   $0x803b8c
  80234c:	6a 75                	push   $0x75
  80234e:	68 73 3b 80 00       	push   $0x803b73
  802353:	e8 38 e0 ff ff       	call   800390 <_panic>
  802358:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235b:	8b 50 04             	mov    0x4(%eax),%edx
  80235e:	8b 45 08             	mov    0x8(%ebp),%eax
  802361:	89 50 04             	mov    %edx,0x4(%eax)
  802364:	8b 45 08             	mov    0x8(%ebp),%eax
  802367:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80236a:	89 10                	mov    %edx,(%eax)
  80236c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236f:	8b 40 04             	mov    0x4(%eax),%eax
  802372:	85 c0                	test   %eax,%eax
  802374:	74 0d                	je     802383 <insert_sorted_allocList+0x162>
  802376:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802379:	8b 40 04             	mov    0x4(%eax),%eax
  80237c:	8b 55 08             	mov    0x8(%ebp),%edx
  80237f:	89 10                	mov    %edx,(%eax)
  802381:	eb 08                	jmp    80238b <insert_sorted_allocList+0x16a>
  802383:	8b 45 08             	mov    0x8(%ebp),%eax
  802386:	a3 40 40 80 00       	mov    %eax,0x804040
  80238b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238e:	8b 55 08             	mov    0x8(%ebp),%edx
  802391:	89 50 04             	mov    %edx,0x4(%eax)
  802394:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802399:	40                   	inc    %eax
  80239a:	a3 4c 40 80 00       	mov    %eax,0x80404c

		break;}
  80239f:	e9 59 01 00 00       	jmp    8024fd <insert_sorted_allocList+0x2dc>

	else if ((blockToInsert->sva>element->sva)&&(blockToInsert->sva<AllocMemBlocksList.lh_last->sva)&&blockToInsert->sva<LIST_NEXT(element)->sva)
  8023a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a7:	8b 50 08             	mov    0x8(%eax),%edx
  8023aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ad:	8b 40 08             	mov    0x8(%eax),%eax
  8023b0:	39 c2                	cmp    %eax,%edx
  8023b2:	0f 86 98 00 00 00    	jbe    802450 <insert_sorted_allocList+0x22f>
  8023b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bb:	8b 50 08             	mov    0x8(%eax),%edx
  8023be:	a1 44 40 80 00       	mov    0x804044,%eax
  8023c3:	8b 40 08             	mov    0x8(%eax),%eax
  8023c6:	39 c2                	cmp    %eax,%edx
  8023c8:	0f 83 82 00 00 00    	jae    802450 <insert_sorted_allocList+0x22f>
  8023ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d1:	8b 50 08             	mov    0x8(%eax),%edx
  8023d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d7:	8b 00                	mov    (%eax),%eax
  8023d9:	8b 40 08             	mov    0x8(%eax),%eax
  8023dc:	39 c2                	cmp    %eax,%edx
  8023de:	73 70                	jae    802450 <insert_sorted_allocList+0x22f>
	{

	LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  8023e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023e4:	74 06                	je     8023ec <insert_sorted_allocList+0x1cb>
  8023e6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023ea:	75 14                	jne    802400 <insert_sorted_allocList+0x1df>
  8023ec:	83 ec 04             	sub    $0x4,%esp
  8023ef:	68 c4 3b 80 00       	push   $0x803bc4
  8023f4:	6a 7c                	push   $0x7c
  8023f6:	68 73 3b 80 00       	push   $0x803b73
  8023fb:	e8 90 df ff ff       	call   800390 <_panic>
  802400:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802403:	8b 10                	mov    (%eax),%edx
  802405:	8b 45 08             	mov    0x8(%ebp),%eax
  802408:	89 10                	mov    %edx,(%eax)
  80240a:	8b 45 08             	mov    0x8(%ebp),%eax
  80240d:	8b 00                	mov    (%eax),%eax
  80240f:	85 c0                	test   %eax,%eax
  802411:	74 0b                	je     80241e <insert_sorted_allocList+0x1fd>
  802413:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802416:	8b 00                	mov    (%eax),%eax
  802418:	8b 55 08             	mov    0x8(%ebp),%edx
  80241b:	89 50 04             	mov    %edx,0x4(%eax)
  80241e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802421:	8b 55 08             	mov    0x8(%ebp),%edx
  802424:	89 10                	mov    %edx,(%eax)
  802426:	8b 45 08             	mov    0x8(%ebp),%eax
  802429:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80242c:	89 50 04             	mov    %edx,0x4(%eax)
  80242f:	8b 45 08             	mov    0x8(%ebp),%eax
  802432:	8b 00                	mov    (%eax),%eax
  802434:	85 c0                	test   %eax,%eax
  802436:	75 08                	jne    802440 <insert_sorted_allocList+0x21f>
  802438:	8b 45 08             	mov    0x8(%ebp),%eax
  80243b:	a3 44 40 80 00       	mov    %eax,0x804044
  802440:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802445:	40                   	inc    %eax
  802446:	a3 4c 40 80 00       	mov    %eax,0x80404c
		break;
  80244b:	e9 ad 00 00 00       	jmp    8024fd <insert_sorted_allocList+0x2dc>
	}else if (blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  802450:	8b 45 08             	mov    0x8(%ebp),%eax
  802453:	8b 50 08             	mov    0x8(%eax),%edx
  802456:	a1 44 40 80 00       	mov    0x804044,%eax
  80245b:	8b 40 08             	mov    0x8(%eax),%eax
  80245e:	39 c2                	cmp    %eax,%edx
  802460:	76 65                	jbe    8024c7 <insert_sorted_allocList+0x2a6>
	{
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
  802462:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802466:	75 17                	jne    80247f <insert_sorted_allocList+0x25e>
  802468:	83 ec 04             	sub    $0x4,%esp
  80246b:	68 f8 3b 80 00       	push   $0x803bf8
  802470:	68 80 00 00 00       	push   $0x80
  802475:	68 73 3b 80 00       	push   $0x803b73
  80247a:	e8 11 df ff ff       	call   800390 <_panic>
  80247f:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802485:	8b 45 08             	mov    0x8(%ebp),%eax
  802488:	89 50 04             	mov    %edx,0x4(%eax)
  80248b:	8b 45 08             	mov    0x8(%ebp),%eax
  80248e:	8b 40 04             	mov    0x4(%eax),%eax
  802491:	85 c0                	test   %eax,%eax
  802493:	74 0c                	je     8024a1 <insert_sorted_allocList+0x280>
  802495:	a1 44 40 80 00       	mov    0x804044,%eax
  80249a:	8b 55 08             	mov    0x8(%ebp),%edx
  80249d:	89 10                	mov    %edx,(%eax)
  80249f:	eb 08                	jmp    8024a9 <insert_sorted_allocList+0x288>
  8024a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a4:	a3 40 40 80 00       	mov    %eax,0x804040
  8024a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ac:	a3 44 40 80 00       	mov    %eax,0x804044
  8024b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024ba:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8024bf:	40                   	inc    %eax
  8024c0:	a3 4c 40 80 00       	mov    %eax,0x80404c
		break;
  8024c5:	eb 36                	jmp    8024fd <insert_sorted_allocList+0x2dc>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  8024c7:	a1 48 40 80 00       	mov    0x804048,%eax
  8024cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024d3:	74 07                	je     8024dc <insert_sorted_allocList+0x2bb>
  8024d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d8:	8b 00                	mov    (%eax),%eax
  8024da:	eb 05                	jmp    8024e1 <insert_sorted_allocList+0x2c0>
  8024dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8024e1:	a3 48 40 80 00       	mov    %eax,0x804048
  8024e6:	a1 48 40 80 00       	mov    0x804048,%eax
  8024eb:	85 c0                	test   %eax,%eax
  8024ed:	0f 85 23 fe ff ff    	jne    802316 <insert_sorted_allocList+0xf5>
  8024f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024f7:	0f 85 19 fe ff ff    	jne    802316 <insert_sorted_allocList+0xf5>
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
		break;

	}
	}
}
  8024fd:	90                   	nop
  8024fe:	c9                   	leave  
  8024ff:	c3                   	ret    

00802500 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802500:	55                   	push   %ebp
  802501:	89 e5                	mov    %esp,%ebp
  802503:	83 ec 18             	sub    $0x18,%esp
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802506:	a1 38 41 80 00       	mov    0x804138,%eax
  80250b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80250e:	e9 7c 01 00 00       	jmp    80268f <alloc_block_FF+0x18f>
		{
			// case 2
				if(element->size == size)
  802513:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802516:	8b 40 0c             	mov    0xc(%eax),%eax
  802519:	3b 45 08             	cmp    0x8(%ebp),%eax
  80251c:	0f 85 90 00 00 00    	jne    8025b2 <alloc_block_FF+0xb2>
				{
					tmp_block=element;
  802522:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802525:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,element);
  802528:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80252c:	75 17                	jne    802545 <alloc_block_FF+0x45>
  80252e:	83 ec 04             	sub    $0x4,%esp
  802531:	68 1b 3c 80 00       	push   $0x803c1b
  802536:	68 ba 00 00 00       	push   $0xba
  80253b:	68 73 3b 80 00       	push   $0x803b73
  802540:	e8 4b de ff ff       	call   800390 <_panic>
  802545:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802548:	8b 00                	mov    (%eax),%eax
  80254a:	85 c0                	test   %eax,%eax
  80254c:	74 10                	je     80255e <alloc_block_FF+0x5e>
  80254e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802551:	8b 00                	mov    (%eax),%eax
  802553:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802556:	8b 52 04             	mov    0x4(%edx),%edx
  802559:	89 50 04             	mov    %edx,0x4(%eax)
  80255c:	eb 0b                	jmp    802569 <alloc_block_FF+0x69>
  80255e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802561:	8b 40 04             	mov    0x4(%eax),%eax
  802564:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802569:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256c:	8b 40 04             	mov    0x4(%eax),%eax
  80256f:	85 c0                	test   %eax,%eax
  802571:	74 0f                	je     802582 <alloc_block_FF+0x82>
  802573:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802576:	8b 40 04             	mov    0x4(%eax),%eax
  802579:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80257c:	8b 12                	mov    (%edx),%edx
  80257e:	89 10                	mov    %edx,(%eax)
  802580:	eb 0a                	jmp    80258c <alloc_block_FF+0x8c>
  802582:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802585:	8b 00                	mov    (%eax),%eax
  802587:	a3 38 41 80 00       	mov    %eax,0x804138
  80258c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802595:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802598:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80259f:	a1 44 41 80 00       	mov    0x804144,%eax
  8025a4:	48                   	dec    %eax
  8025a5:	a3 44 41 80 00       	mov    %eax,0x804144
					return tmp_block;
  8025aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ad:	e9 10 01 00 00       	jmp    8026c2 <alloc_block_FF+0x1c2>
				}
				 // case 3
				else if(element->size > size)
  8025b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b5:	8b 40 0c             	mov    0xc(%eax),%eax
  8025b8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025bb:	0f 86 c6 00 00 00    	jbe    802687 <alloc_block_FF+0x187>
				{
					// the new block are created
					tmp_block = AvailableMemBlocksList.lh_first ;
  8025c1:	a1 48 41 80 00       	mov    0x804148,%eax
  8025c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  8025c9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025cd:	75 17                	jne    8025e6 <alloc_block_FF+0xe6>
  8025cf:	83 ec 04             	sub    $0x4,%esp
  8025d2:	68 1b 3c 80 00       	push   $0x803c1b
  8025d7:	68 c2 00 00 00       	push   $0xc2
  8025dc:	68 73 3b 80 00       	push   $0x803b73
  8025e1:	e8 aa dd ff ff       	call   800390 <_panic>
  8025e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025e9:	8b 00                	mov    (%eax),%eax
  8025eb:	85 c0                	test   %eax,%eax
  8025ed:	74 10                	je     8025ff <alloc_block_FF+0xff>
  8025ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025f2:	8b 00                	mov    (%eax),%eax
  8025f4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025f7:	8b 52 04             	mov    0x4(%edx),%edx
  8025fa:	89 50 04             	mov    %edx,0x4(%eax)
  8025fd:	eb 0b                	jmp    80260a <alloc_block_FF+0x10a>
  8025ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802602:	8b 40 04             	mov    0x4(%eax),%eax
  802605:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80260a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80260d:	8b 40 04             	mov    0x4(%eax),%eax
  802610:	85 c0                	test   %eax,%eax
  802612:	74 0f                	je     802623 <alloc_block_FF+0x123>
  802614:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802617:	8b 40 04             	mov    0x4(%eax),%eax
  80261a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80261d:	8b 12                	mov    (%edx),%edx
  80261f:	89 10                	mov    %edx,(%eax)
  802621:	eb 0a                	jmp    80262d <alloc_block_FF+0x12d>
  802623:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802626:	8b 00                	mov    (%eax),%eax
  802628:	a3 48 41 80 00       	mov    %eax,0x804148
  80262d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802630:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802636:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802639:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802640:	a1 54 41 80 00       	mov    0x804154,%eax
  802645:	48                   	dec    %eax
  802646:	a3 54 41 80 00       	mov    %eax,0x804154
					tmp_block->sva=element->sva;
  80264b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264e:	8b 50 08             	mov    0x8(%eax),%edx
  802651:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802654:	89 50 08             	mov    %edx,0x8(%eax)
					tmp_block->size=size;
  802657:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80265a:	8b 55 08             	mov    0x8(%ebp),%edx
  80265d:	89 50 0c             	mov    %edx,0xc(%eax)
					//update block with remaining space
					element->size-=size;
  802660:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802663:	8b 40 0c             	mov    0xc(%eax),%eax
  802666:	2b 45 08             	sub    0x8(%ebp),%eax
  802669:	89 c2                	mov    %eax,%edx
  80266b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266e:	89 50 0c             	mov    %edx,0xc(%eax)
					element->sva = element->sva + size;
  802671:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802674:	8b 50 08             	mov    0x8(%eax),%edx
  802677:	8b 45 08             	mov    0x8(%ebp),%eax
  80267a:	01 c2                	add    %eax,%edx
  80267c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267f:	89 50 08             	mov    %edx,0x8(%eax)
					// return back the new block
					return tmp_block ;
  802682:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802685:	eb 3b                	jmp    8026c2 <alloc_block_FF+0x1c2>
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802687:	a1 40 41 80 00       	mov    0x804140,%eax
  80268c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80268f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802693:	74 07                	je     80269c <alloc_block_FF+0x19c>
  802695:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802698:	8b 00                	mov    (%eax),%eax
  80269a:	eb 05                	jmp    8026a1 <alloc_block_FF+0x1a1>
  80269c:	b8 00 00 00 00       	mov    $0x0,%eax
  8026a1:	a3 40 41 80 00       	mov    %eax,0x804140
  8026a6:	a1 40 41 80 00       	mov    0x804140,%eax
  8026ab:	85 c0                	test   %eax,%eax
  8026ad:	0f 85 60 fe ff ff    	jne    802513 <alloc_block_FF+0x13>
  8026b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026b7:	0f 85 56 fe ff ff    	jne    802513 <alloc_block_FF+0x13>
					// return back the new block
					return tmp_block ;
				}
		}
		// case 1
	  return NULL ;}
  8026bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8026c2:	c9                   	leave  
  8026c3:	c3                   	ret    

008026c4 <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================

struct MemBlock *alloc_block_BF(uint32 size)
{
  8026c4:	55                   	push   %ebp
  8026c5:	89 e5                	mov    %esp,%ebp
  8026c7:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
  8026ca:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		LIST_FOREACH(element, &(FreeMemBlocksList))
  8026d1:	a1 38 41 80 00       	mov    0x804138,%eax
  8026d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026d9:	eb 3a                	jmp    802715 <alloc_block_BF+0x51>
		{
			if(element->size >= size)
  8026db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026de:	8b 40 0c             	mov    0xc(%eax),%eax
  8026e1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026e4:	72 27                	jb     80270d <alloc_block_BF+0x49>
			{
				if(best_size==-1)
  8026e6:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8026ea:	75 0b                	jne    8026f7 <alloc_block_BF+0x33>
					best_size= element->size;
  8026ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8026f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8026f5:	eb 16                	jmp    80270d <alloc_block_BF+0x49>
				else if(best_size >= element->size)
  8026f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fa:	8b 50 0c             	mov    0xc(%eax),%edx
  8026fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802700:	39 c2                	cmp    %eax,%edx
  802702:	77 09                	ja     80270d <alloc_block_BF+0x49>
					best_size=element->size;
  802704:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802707:	8b 40 0c             	mov    0xc(%eax),%eax
  80270a:	89 45 f0             	mov    %eax,-0x10(%ebp)

struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  80270d:	a1 40 41 80 00       	mov    0x804140,%eax
  802712:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802715:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802719:	74 07                	je     802722 <alloc_block_BF+0x5e>
  80271b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271e:	8b 00                	mov    (%eax),%eax
  802720:	eb 05                	jmp    802727 <alloc_block_BF+0x63>
  802722:	b8 00 00 00 00       	mov    $0x0,%eax
  802727:	a3 40 41 80 00       	mov    %eax,0x804140
  80272c:	a1 40 41 80 00       	mov    0x804140,%eax
  802731:	85 c0                	test   %eax,%eax
  802733:	75 a6                	jne    8026db <alloc_block_BF+0x17>
  802735:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802739:	75 a0                	jne    8026db <alloc_block_BF+0x17>
					best_size= element->size;
				else if(best_size >= element->size)
					best_size=element->size;
			}
		}
		if(best_size != -1)
  80273b:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80273f:	0f 84 d3 01 00 00    	je     802918 <alloc_block_BF+0x254>
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  802745:	a1 38 41 80 00       	mov    0x804138,%eax
  80274a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80274d:	e9 98 01 00 00       	jmp    8028ea <alloc_block_BF+0x226>
			{
			 if((best_size > size) && (best_size == element->size))
  802752:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802755:	3b 45 08             	cmp    0x8(%ebp),%eax
  802758:	0f 86 da 00 00 00    	jbe    802838 <alloc_block_BF+0x174>
  80275e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802761:	8b 50 0c             	mov    0xc(%eax),%edx
  802764:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802767:	39 c2                	cmp    %eax,%edx
  802769:	0f 85 c9 00 00 00    	jne    802838 <alloc_block_BF+0x174>
			  {
				// the new block are created
			    tmp_block = AvailableMemBlocksList.lh_first ;
  80276f:	a1 48 41 80 00       	mov    0x804148,%eax
  802774:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  802777:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80277b:	75 17                	jne    802794 <alloc_block_BF+0xd0>
  80277d:	83 ec 04             	sub    $0x4,%esp
  802780:	68 1b 3c 80 00       	push   $0x803c1b
  802785:	68 ea 00 00 00       	push   $0xea
  80278a:	68 73 3b 80 00       	push   $0x803b73
  80278f:	e8 fc db ff ff       	call   800390 <_panic>
  802794:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802797:	8b 00                	mov    (%eax),%eax
  802799:	85 c0                	test   %eax,%eax
  80279b:	74 10                	je     8027ad <alloc_block_BF+0xe9>
  80279d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027a0:	8b 00                	mov    (%eax),%eax
  8027a2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027a5:	8b 52 04             	mov    0x4(%edx),%edx
  8027a8:	89 50 04             	mov    %edx,0x4(%eax)
  8027ab:	eb 0b                	jmp    8027b8 <alloc_block_BF+0xf4>
  8027ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027b0:	8b 40 04             	mov    0x4(%eax),%eax
  8027b3:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8027b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027bb:	8b 40 04             	mov    0x4(%eax),%eax
  8027be:	85 c0                	test   %eax,%eax
  8027c0:	74 0f                	je     8027d1 <alloc_block_BF+0x10d>
  8027c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027c5:	8b 40 04             	mov    0x4(%eax),%eax
  8027c8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027cb:	8b 12                	mov    (%edx),%edx
  8027cd:	89 10                	mov    %edx,(%eax)
  8027cf:	eb 0a                	jmp    8027db <alloc_block_BF+0x117>
  8027d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027d4:	8b 00                	mov    (%eax),%eax
  8027d6:	a3 48 41 80 00       	mov    %eax,0x804148
  8027db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027e7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027ee:	a1 54 41 80 00       	mov    0x804154,%eax
  8027f3:	48                   	dec    %eax
  8027f4:	a3 54 41 80 00       	mov    %eax,0x804154
				tmp_block->sva=element->sva;
  8027f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fc:	8b 50 08             	mov    0x8(%eax),%edx
  8027ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802802:	89 50 08             	mov    %edx,0x8(%eax)
				tmp_block->size=size;
  802805:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802808:	8b 55 08             	mov    0x8(%ebp),%edx
  80280b:	89 50 0c             	mov    %edx,0xc(%eax)
				//update block with remaining space
				element->size-=size;
  80280e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802811:	8b 40 0c             	mov    0xc(%eax),%eax
  802814:	2b 45 08             	sub    0x8(%ebp),%eax
  802817:	89 c2                	mov    %eax,%edx
  802819:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281c:	89 50 0c             	mov    %edx,0xc(%eax)
				element->sva = element->sva + size;
  80281f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802822:	8b 50 08             	mov    0x8(%eax),%edx
  802825:	8b 45 08             	mov    0x8(%ebp),%eax
  802828:	01 c2                	add    %eax,%edx
  80282a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282d:	89 50 08             	mov    %edx,0x8(%eax)
				// return back the new block
				return tmp_block ;
  802830:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802833:	e9 e5 00 00 00       	jmp    80291d <alloc_block_BF+0x259>

			  }
			else if((element->size == best_size)&&(best_size == size))
  802838:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283b:	8b 50 0c             	mov    0xc(%eax),%edx
  80283e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802841:	39 c2                	cmp    %eax,%edx
  802843:	0f 85 99 00 00 00    	jne    8028e2 <alloc_block_BF+0x21e>
  802849:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80284c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80284f:	0f 85 8d 00 00 00    	jne    8028e2 <alloc_block_BF+0x21e>
			  {
				tmp_block=element;
  802855:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802858:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&FreeMemBlocksList,element);
  80285b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80285f:	75 17                	jne    802878 <alloc_block_BF+0x1b4>
  802861:	83 ec 04             	sub    $0x4,%esp
  802864:	68 1b 3c 80 00       	push   $0x803c1b
  802869:	68 f7 00 00 00       	push   $0xf7
  80286e:	68 73 3b 80 00       	push   $0x803b73
  802873:	e8 18 db ff ff       	call   800390 <_panic>
  802878:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287b:	8b 00                	mov    (%eax),%eax
  80287d:	85 c0                	test   %eax,%eax
  80287f:	74 10                	je     802891 <alloc_block_BF+0x1cd>
  802881:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802884:	8b 00                	mov    (%eax),%eax
  802886:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802889:	8b 52 04             	mov    0x4(%edx),%edx
  80288c:	89 50 04             	mov    %edx,0x4(%eax)
  80288f:	eb 0b                	jmp    80289c <alloc_block_BF+0x1d8>
  802891:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802894:	8b 40 04             	mov    0x4(%eax),%eax
  802897:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80289c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289f:	8b 40 04             	mov    0x4(%eax),%eax
  8028a2:	85 c0                	test   %eax,%eax
  8028a4:	74 0f                	je     8028b5 <alloc_block_BF+0x1f1>
  8028a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a9:	8b 40 04             	mov    0x4(%eax),%eax
  8028ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028af:	8b 12                	mov    (%edx),%edx
  8028b1:	89 10                	mov    %edx,(%eax)
  8028b3:	eb 0a                	jmp    8028bf <alloc_block_BF+0x1fb>
  8028b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b8:	8b 00                	mov    (%eax),%eax
  8028ba:	a3 38 41 80 00       	mov    %eax,0x804138
  8028bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028d2:	a1 44 41 80 00       	mov    0x804144,%eax
  8028d7:	48                   	dec    %eax
  8028d8:	a3 44 41 80 00       	mov    %eax,0x804144
				return tmp_block;
  8028dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028e0:	eb 3b                	jmp    80291d <alloc_block_BF+0x259>
					best_size=element->size;
			}
		}
		if(best_size != -1)
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  8028e2:	a1 40 41 80 00       	mov    0x804140,%eax
  8028e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028ee:	74 07                	je     8028f7 <alloc_block_BF+0x233>
  8028f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f3:	8b 00                	mov    (%eax),%eax
  8028f5:	eb 05                	jmp    8028fc <alloc_block_BF+0x238>
  8028f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8028fc:	a3 40 41 80 00       	mov    %eax,0x804140
  802901:	a1 40 41 80 00       	mov    0x804140,%eax
  802906:	85 c0                	test   %eax,%eax
  802908:	0f 85 44 fe ff ff    	jne    802752 <alloc_block_BF+0x8e>
  80290e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802912:	0f 85 3a fe ff ff    	jne    802752 <alloc_block_BF+0x8e>
				LIST_REMOVE(&FreeMemBlocksList,element);
				return tmp_block;
			 }
			}
		}
		return NULL ;}
  802918:	b8 00 00 00 00       	mov    $0x0,%eax
  80291d:	c9                   	leave  
  80291e:	c3                   	ret    

0080291f <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  80291f:	55                   	push   %ebp
  802920:	89 e5                	mov    %esp,%ebp
  802922:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802925:	83 ec 04             	sub    $0x4,%esp
  802928:	68 3c 3c 80 00       	push   $0x803c3c
  80292d:	68 04 01 00 00       	push   $0x104
  802932:	68 73 3b 80 00       	push   $0x803b73
  802937:	e8 54 da ff ff       	call   800390 <_panic>

0080293c <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{struct MemBlock * blk_itr;
  80293c:	55                   	push   %ebp
  80293d:	89 e5                	mov    %esp,%ebp
  80293f:	83 ec 18             	sub    $0x18,%esp
struct MemBlock * next;
struct MemBlock * first = LIST_FIRST(&(FreeMemBlocksList));
  802942:	a1 38 41 80 00       	mov    0x804138,%eax
  802947:	89 45 f0             	mov    %eax,-0x10(%ebp)
struct MemBlock * last = LIST_LAST(&(FreeMemBlocksList));
  80294a:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80294f:	89 45 ec             	mov    %eax,-0x14(%ebp)

if(LIST_EMPTY(&(FreeMemBlocksList)))
  802952:	a1 38 41 80 00       	mov    0x804138,%eax
  802957:	85 c0                	test   %eax,%eax
  802959:	75 68                	jne    8029c3 <insert_sorted_with_merge_freeList+0x87>
			{

				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  80295b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80295f:	75 17                	jne    802978 <insert_sorted_with_merge_freeList+0x3c>
  802961:	83 ec 04             	sub    $0x4,%esp
  802964:	68 50 3b 80 00       	push   $0x803b50
  802969:	68 14 01 00 00       	push   $0x114
  80296e:	68 73 3b 80 00       	push   $0x803b73
  802973:	e8 18 da ff ff       	call   800390 <_panic>
  802978:	8b 15 38 41 80 00    	mov    0x804138,%edx
  80297e:	8b 45 08             	mov    0x8(%ebp),%eax
  802981:	89 10                	mov    %edx,(%eax)
  802983:	8b 45 08             	mov    0x8(%ebp),%eax
  802986:	8b 00                	mov    (%eax),%eax
  802988:	85 c0                	test   %eax,%eax
  80298a:	74 0d                	je     802999 <insert_sorted_with_merge_freeList+0x5d>
  80298c:	a1 38 41 80 00       	mov    0x804138,%eax
  802991:	8b 55 08             	mov    0x8(%ebp),%edx
  802994:	89 50 04             	mov    %edx,0x4(%eax)
  802997:	eb 08                	jmp    8029a1 <insert_sorted_with_merge_freeList+0x65>
  802999:	8b 45 08             	mov    0x8(%ebp),%eax
  80299c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a4:	a3 38 41 80 00       	mov    %eax,0x804138
  8029a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029b3:	a1 44 41 80 00       	mov    0x804144,%eax
  8029b8:	40                   	inc    %eax
  8029b9:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  8029be:	e9 d2 06 00 00       	jmp    803095 <insert_sorted_with_merge_freeList+0x759>
				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);

			}
else
{
	if( blockToInsert->sva  < first->sva )
  8029c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c6:	8b 50 08             	mov    0x8(%eax),%edx
  8029c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029cc:	8b 40 08             	mov    0x8(%eax),%eax
  8029cf:	39 c2                	cmp    %eax,%edx
  8029d1:	0f 83 22 01 00 00    	jae    802af9 <insert_sorted_with_merge_freeList+0x1bd>
	{
                if( blockToInsert->sva + blockToInsert->size == first->sva)
  8029d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029da:	8b 50 08             	mov    0x8(%eax),%edx
  8029dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8029e3:	01 c2                	add    %eax,%edx
  8029e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e8:	8b 40 08             	mov    0x8(%eax),%eax
  8029eb:	39 c2                	cmp    %eax,%edx
  8029ed:	0f 85 9e 00 00 00    	jne    802a91 <insert_sorted_with_merge_freeList+0x155>
                {

                	first->sva = blockToInsert->sva;
  8029f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f6:	8b 50 08             	mov    0x8(%eax),%edx
  8029f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029fc:	89 50 08             	mov    %edx,0x8(%eax)
                	first->size = first->size + blockToInsert->size;
  8029ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a02:	8b 50 0c             	mov    0xc(%eax),%edx
  802a05:	8b 45 08             	mov    0x8(%ebp),%eax
  802a08:	8b 40 0c             	mov    0xc(%eax),%eax
  802a0b:	01 c2                	add    %eax,%edx
  802a0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a10:	89 50 0c             	mov    %edx,0xc(%eax)
                	blockToInsert->size = blockToInsert->sva = 0;
  802a13:	8b 45 08             	mov    0x8(%ebp),%eax
  802a16:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802a1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a20:	8b 50 08             	mov    0x8(%eax),%edx
  802a23:	8b 45 08             	mov    0x8(%ebp),%eax
  802a26:	89 50 0c             	mov    %edx,0xc(%eax)
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802a29:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a2d:	75 17                	jne    802a46 <insert_sorted_with_merge_freeList+0x10a>
  802a2f:	83 ec 04             	sub    $0x4,%esp
  802a32:	68 50 3b 80 00       	push   $0x803b50
  802a37:	68 21 01 00 00       	push   $0x121
  802a3c:	68 73 3b 80 00       	push   $0x803b73
  802a41:	e8 4a d9 ff ff       	call   800390 <_panic>
  802a46:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4f:	89 10                	mov    %edx,(%eax)
  802a51:	8b 45 08             	mov    0x8(%ebp),%eax
  802a54:	8b 00                	mov    (%eax),%eax
  802a56:	85 c0                	test   %eax,%eax
  802a58:	74 0d                	je     802a67 <insert_sorted_with_merge_freeList+0x12b>
  802a5a:	a1 48 41 80 00       	mov    0x804148,%eax
  802a5f:	8b 55 08             	mov    0x8(%ebp),%edx
  802a62:	89 50 04             	mov    %edx,0x4(%eax)
  802a65:	eb 08                	jmp    802a6f <insert_sorted_with_merge_freeList+0x133>
  802a67:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a72:	a3 48 41 80 00       	mov    %eax,0x804148
  802a77:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a81:	a1 54 41 80 00       	mov    0x804154,%eax
  802a86:	40                   	inc    %eax
  802a87:	a3 54 41 80 00       	mov    %eax,0x804154
						}
				}
        }

}
}
  802a8c:	e9 04 06 00 00       	jmp    803095 <insert_sorted_with_merge_freeList+0x759>
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
                }

                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  802a91:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a95:	75 17                	jne    802aae <insert_sorted_with_merge_freeList+0x172>
  802a97:	83 ec 04             	sub    $0x4,%esp
  802a9a:	68 50 3b 80 00       	push   $0x803b50
  802a9f:	68 26 01 00 00       	push   $0x126
  802aa4:	68 73 3b 80 00       	push   $0x803b73
  802aa9:	e8 e2 d8 ff ff       	call   800390 <_panic>
  802aae:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab7:	89 10                	mov    %edx,(%eax)
  802ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  802abc:	8b 00                	mov    (%eax),%eax
  802abe:	85 c0                	test   %eax,%eax
  802ac0:	74 0d                	je     802acf <insert_sorted_with_merge_freeList+0x193>
  802ac2:	a1 38 41 80 00       	mov    0x804138,%eax
  802ac7:	8b 55 08             	mov    0x8(%ebp),%edx
  802aca:	89 50 04             	mov    %edx,0x4(%eax)
  802acd:	eb 08                	jmp    802ad7 <insert_sorted_with_merge_freeList+0x19b>
  802acf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad2:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  802ada:	a3 38 41 80 00       	mov    %eax,0x804138
  802adf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ae9:	a1 44 41 80 00       	mov    0x804144,%eax
  802aee:	40                   	inc    %eax
  802aef:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  802af4:	e9 9c 05 00 00       	jmp    803095 <insert_sorted_with_merge_freeList+0x759>
                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
                }
	}
    else if(blockToInsert->sva > last->sva)
  802af9:	8b 45 08             	mov    0x8(%ebp),%eax
  802afc:	8b 50 08             	mov    0x8(%eax),%edx
  802aff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b02:	8b 40 08             	mov    0x8(%eax),%eax
  802b05:	39 c2                	cmp    %eax,%edx
  802b07:	0f 86 16 01 00 00    	jbe    802c23 <insert_sorted_with_merge_freeList+0x2e7>
 	{

				if(last->sva + last->size == blockToInsert->sva)
  802b0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b10:	8b 50 08             	mov    0x8(%eax),%edx
  802b13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b16:	8b 40 0c             	mov    0xc(%eax),%eax
  802b19:	01 c2                	add    %eax,%edx
  802b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1e:	8b 40 08             	mov    0x8(%eax),%eax
  802b21:	39 c2                	cmp    %eax,%edx
  802b23:	0f 85 92 00 00 00    	jne    802bbb <insert_sorted_with_merge_freeList+0x27f>
				{

					last->size = last->size + blockToInsert->size;
  802b29:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b2c:	8b 50 0c             	mov    0xc(%eax),%edx
  802b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b32:	8b 40 0c             	mov    0xc(%eax),%eax
  802b35:	01 c2                	add    %eax,%edx
  802b37:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b3a:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->size = blockToInsert->sva = 0;
  802b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b40:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802b47:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4a:	8b 50 08             	mov    0x8(%eax),%edx
  802b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b50:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802b53:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b57:	75 17                	jne    802b70 <insert_sorted_with_merge_freeList+0x234>
  802b59:	83 ec 04             	sub    $0x4,%esp
  802b5c:	68 50 3b 80 00       	push   $0x803b50
  802b61:	68 31 01 00 00       	push   $0x131
  802b66:	68 73 3b 80 00       	push   $0x803b73
  802b6b:	e8 20 d8 ff ff       	call   800390 <_panic>
  802b70:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b76:	8b 45 08             	mov    0x8(%ebp),%eax
  802b79:	89 10                	mov    %edx,(%eax)
  802b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7e:	8b 00                	mov    (%eax),%eax
  802b80:	85 c0                	test   %eax,%eax
  802b82:	74 0d                	je     802b91 <insert_sorted_with_merge_freeList+0x255>
  802b84:	a1 48 41 80 00       	mov    0x804148,%eax
  802b89:	8b 55 08             	mov    0x8(%ebp),%edx
  802b8c:	89 50 04             	mov    %edx,0x4(%eax)
  802b8f:	eb 08                	jmp    802b99 <insert_sorted_with_merge_freeList+0x25d>
  802b91:	8b 45 08             	mov    0x8(%ebp),%eax
  802b94:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b99:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9c:	a3 48 41 80 00       	mov    %eax,0x804148
  802ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bab:	a1 54 41 80 00       	mov    0x804154,%eax
  802bb0:	40                   	inc    %eax
  802bb1:	a3 54 41 80 00       	mov    %eax,0x804154
						}
				}
        }

}
}
  802bb6:	e9 da 04 00 00       	jmp    803095 <insert_sorted_with_merge_freeList+0x759>

				}

				else
				{
					LIST_INSERT_TAIL(&(FreeMemBlocksList),  blockToInsert);
  802bbb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bbf:	75 17                	jne    802bd8 <insert_sorted_with_merge_freeList+0x29c>
  802bc1:	83 ec 04             	sub    $0x4,%esp
  802bc4:	68 f8 3b 80 00       	push   $0x803bf8
  802bc9:	68 37 01 00 00       	push   $0x137
  802bce:	68 73 3b 80 00       	push   $0x803b73
  802bd3:	e8 b8 d7 ff ff       	call   800390 <_panic>
  802bd8:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802bde:	8b 45 08             	mov    0x8(%ebp),%eax
  802be1:	89 50 04             	mov    %edx,0x4(%eax)
  802be4:	8b 45 08             	mov    0x8(%ebp),%eax
  802be7:	8b 40 04             	mov    0x4(%eax),%eax
  802bea:	85 c0                	test   %eax,%eax
  802bec:	74 0c                	je     802bfa <insert_sorted_with_merge_freeList+0x2be>
  802bee:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802bf3:	8b 55 08             	mov    0x8(%ebp),%edx
  802bf6:	89 10                	mov    %edx,(%eax)
  802bf8:	eb 08                	jmp    802c02 <insert_sorted_with_merge_freeList+0x2c6>
  802bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfd:	a3 38 41 80 00       	mov    %eax,0x804138
  802c02:	8b 45 08             	mov    0x8(%ebp),%eax
  802c05:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c13:	a1 44 41 80 00       	mov    0x804144,%eax
  802c18:	40                   	inc    %eax
  802c19:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  802c1e:	e9 72 04 00 00       	jmp    803095 <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  802c23:	a1 38 41 80 00       	mov    0x804138,%eax
  802c28:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c2b:	e9 35 04 00 00       	jmp    803065 <insert_sorted_with_merge_freeList+0x729>
				{
				     next=LIST_NEXT(blk_itr);
  802c30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c33:	8b 00                	mov    (%eax),%eax
  802c35:	89 45 e8             	mov    %eax,-0x18(%ebp)


					if( (blockToInsert->sva > blk_itr->sva) )
  802c38:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3b:	8b 50 08             	mov    0x8(%eax),%edx
  802c3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c41:	8b 40 08             	mov    0x8(%eax),%eax
  802c44:	39 c2                	cmp    %eax,%edx
  802c46:	0f 86 11 04 00 00    	jbe    80305d <insert_sorted_with_merge_freeList+0x721>
						{
							if(((blk_itr->sva) + (blk_itr->size) < blockToInsert->sva && (blockToInsert->sva) + (blockToInsert->size) < next->sva))
  802c4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4f:	8b 50 08             	mov    0x8(%eax),%edx
  802c52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c55:	8b 40 0c             	mov    0xc(%eax),%eax
  802c58:	01 c2                	add    %eax,%edx
  802c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5d:	8b 40 08             	mov    0x8(%eax),%eax
  802c60:	39 c2                	cmp    %eax,%edx
  802c62:	0f 83 8b 00 00 00    	jae    802cf3 <insert_sorted_with_merge_freeList+0x3b7>
  802c68:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6b:	8b 50 08             	mov    0x8(%eax),%edx
  802c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c71:	8b 40 0c             	mov    0xc(%eax),%eax
  802c74:	01 c2                	add    %eax,%edx
  802c76:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c79:	8b 40 08             	mov    0x8(%eax),%eax
  802c7c:	39 c2                	cmp    %eax,%edx
  802c7e:	73 73                	jae    802cf3 <insert_sorted_with_merge_freeList+0x3b7>
							{
								LIST_INSERT_AFTER(&(FreeMemBlocksList), blk_itr, blockToInsert);
  802c80:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c84:	74 06                	je     802c8c <insert_sorted_with_merge_freeList+0x350>
  802c86:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c8a:	75 17                	jne    802ca3 <insert_sorted_with_merge_freeList+0x367>
  802c8c:	83 ec 04             	sub    $0x4,%esp
  802c8f:	68 c4 3b 80 00       	push   $0x803bc4
  802c94:	68 48 01 00 00       	push   $0x148
  802c99:	68 73 3b 80 00       	push   $0x803b73
  802c9e:	e8 ed d6 ff ff       	call   800390 <_panic>
  802ca3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca6:	8b 10                	mov    (%eax),%edx
  802ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  802cab:	89 10                	mov    %edx,(%eax)
  802cad:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb0:	8b 00                	mov    (%eax),%eax
  802cb2:	85 c0                	test   %eax,%eax
  802cb4:	74 0b                	je     802cc1 <insert_sorted_with_merge_freeList+0x385>
  802cb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb9:	8b 00                	mov    (%eax),%eax
  802cbb:	8b 55 08             	mov    0x8(%ebp),%edx
  802cbe:	89 50 04             	mov    %edx,0x4(%eax)
  802cc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc4:	8b 55 08             	mov    0x8(%ebp),%edx
  802cc7:	89 10                	mov    %edx,(%eax)
  802cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ccc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ccf:	89 50 04             	mov    %edx,0x4(%eax)
  802cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd5:	8b 00                	mov    (%eax),%eax
  802cd7:	85 c0                	test   %eax,%eax
  802cd9:	75 08                	jne    802ce3 <insert_sorted_with_merge_freeList+0x3a7>
  802cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cde:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ce3:	a1 44 41 80 00       	mov    0x804144,%eax
  802ce8:	40                   	inc    %eax
  802ce9:	a3 44 41 80 00       	mov    %eax,0x804144
								break;
  802cee:	e9 a2 03 00 00       	jmp    803095 <insert_sorted_with_merge_freeList+0x759>

							}
							else if((blockToInsert->sva + blockToInsert->size) < next->sva  && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  802cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf6:	8b 50 08             	mov    0x8(%eax),%edx
  802cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cfc:	8b 40 0c             	mov    0xc(%eax),%eax
  802cff:	01 c2                	add    %eax,%edx
  802d01:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d04:	8b 40 08             	mov    0x8(%eax),%eax
  802d07:	39 c2                	cmp    %eax,%edx
  802d09:	0f 83 ae 00 00 00    	jae    802dbd <insert_sorted_with_merge_freeList+0x481>
  802d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d12:	8b 50 08             	mov    0x8(%eax),%edx
  802d15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d18:	8b 48 08             	mov    0x8(%eax),%ecx
  802d1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1e:	8b 40 0c             	mov    0xc(%eax),%eax
  802d21:	01 c8                	add    %ecx,%eax
  802d23:	39 c2                	cmp    %eax,%edx
  802d25:	0f 85 92 00 00 00    	jne    802dbd <insert_sorted_with_merge_freeList+0x481>
							{

								blk_itr->size=blk_itr->size+blockToInsert->size;
  802d2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2e:	8b 50 0c             	mov    0xc(%eax),%edx
  802d31:	8b 45 08             	mov    0x8(%ebp),%eax
  802d34:	8b 40 0c             	mov    0xc(%eax),%eax
  802d37:	01 c2                	add    %eax,%edx
  802d39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3c:	89 50 0c             	mov    %edx,0xc(%eax)
								 blockToInsert->size=blockToInsert->sva=0;
  802d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d42:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802d49:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4c:	8b 50 08             	mov    0x8(%eax),%edx
  802d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d52:	89 50 0c             	mov    %edx,0xc(%eax)
								 LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802d55:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d59:	75 17                	jne    802d72 <insert_sorted_with_merge_freeList+0x436>
  802d5b:	83 ec 04             	sub    $0x4,%esp
  802d5e:	68 50 3b 80 00       	push   $0x803b50
  802d63:	68 51 01 00 00       	push   $0x151
  802d68:	68 73 3b 80 00       	push   $0x803b73
  802d6d:	e8 1e d6 ff ff       	call   800390 <_panic>
  802d72:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d78:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7b:	89 10                	mov    %edx,(%eax)
  802d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d80:	8b 00                	mov    (%eax),%eax
  802d82:	85 c0                	test   %eax,%eax
  802d84:	74 0d                	je     802d93 <insert_sorted_with_merge_freeList+0x457>
  802d86:	a1 48 41 80 00       	mov    0x804148,%eax
  802d8b:	8b 55 08             	mov    0x8(%ebp),%edx
  802d8e:	89 50 04             	mov    %edx,0x4(%eax)
  802d91:	eb 08                	jmp    802d9b <insert_sorted_with_merge_freeList+0x45f>
  802d93:	8b 45 08             	mov    0x8(%ebp),%eax
  802d96:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9e:	a3 48 41 80 00       	mov    %eax,0x804148
  802da3:	8b 45 08             	mov    0x8(%ebp),%eax
  802da6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dad:	a1 54 41 80 00       	mov    0x804154,%eax
  802db2:	40                   	inc    %eax
  802db3:	a3 54 41 80 00       	mov    %eax,0x804154
								 break;
  802db8:	e9 d8 02 00 00       	jmp    803095 <insert_sorted_with_merge_freeList+0x759>

							}
							else if( (blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva > (blk_itr->sva + blk_itr->size))
  802dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc0:	8b 50 08             	mov    0x8(%eax),%edx
  802dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc6:	8b 40 0c             	mov    0xc(%eax),%eax
  802dc9:	01 c2                	add    %eax,%edx
  802dcb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dce:	8b 40 08             	mov    0x8(%eax),%eax
  802dd1:	39 c2                	cmp    %eax,%edx
  802dd3:	0f 85 ba 00 00 00    	jne    802e93 <insert_sorted_with_merge_freeList+0x557>
  802dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddc:	8b 50 08             	mov    0x8(%eax),%edx
  802ddf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de2:	8b 48 08             	mov    0x8(%eax),%ecx
  802de5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de8:	8b 40 0c             	mov    0xc(%eax),%eax
  802deb:	01 c8                	add    %ecx,%eax
  802ded:	39 c2                	cmp    %eax,%edx
  802def:	0f 86 9e 00 00 00    	jbe    802e93 <insert_sorted_with_merge_freeList+0x557>
							{
								next->size = next->size + blockToInsert->size;
  802df5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802df8:	8b 50 0c             	mov    0xc(%eax),%edx
  802dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfe:	8b 40 0c             	mov    0xc(%eax),%eax
  802e01:	01 c2                	add    %eax,%edx
  802e03:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e06:	89 50 0c             	mov    %edx,0xc(%eax)
								next->sva = blockToInsert->sva;
  802e09:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0c:	8b 50 08             	mov    0x8(%eax),%edx
  802e0f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e12:	89 50 08             	mov    %edx,0x8(%eax)

								blockToInsert->size = blockToInsert->sva = 0;
  802e15:	8b 45 08             	mov    0x8(%ebp),%eax
  802e18:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e22:	8b 50 08             	mov    0x8(%eax),%edx
  802e25:	8b 45 08             	mov    0x8(%ebp),%eax
  802e28:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802e2b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e2f:	75 17                	jne    802e48 <insert_sorted_with_merge_freeList+0x50c>
  802e31:	83 ec 04             	sub    $0x4,%esp
  802e34:	68 50 3b 80 00       	push   $0x803b50
  802e39:	68 5b 01 00 00       	push   $0x15b
  802e3e:	68 73 3b 80 00       	push   $0x803b73
  802e43:	e8 48 d5 ff ff       	call   800390 <_panic>
  802e48:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e51:	89 10                	mov    %edx,(%eax)
  802e53:	8b 45 08             	mov    0x8(%ebp),%eax
  802e56:	8b 00                	mov    (%eax),%eax
  802e58:	85 c0                	test   %eax,%eax
  802e5a:	74 0d                	je     802e69 <insert_sorted_with_merge_freeList+0x52d>
  802e5c:	a1 48 41 80 00       	mov    0x804148,%eax
  802e61:	8b 55 08             	mov    0x8(%ebp),%edx
  802e64:	89 50 04             	mov    %edx,0x4(%eax)
  802e67:	eb 08                	jmp    802e71 <insert_sorted_with_merge_freeList+0x535>
  802e69:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e71:	8b 45 08             	mov    0x8(%ebp),%eax
  802e74:	a3 48 41 80 00       	mov    %eax,0x804148
  802e79:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e83:	a1 54 41 80 00       	mov    0x804154,%eax
  802e88:	40                   	inc    %eax
  802e89:	a3 54 41 80 00       	mov    %eax,0x804154
								break;
  802e8e:	e9 02 02 00 00       	jmp    803095 <insert_sorted_with_merge_freeList+0x759>
							}
							else if ((blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  802e93:	8b 45 08             	mov    0x8(%ebp),%eax
  802e96:	8b 50 08             	mov    0x8(%eax),%edx
  802e99:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9c:	8b 40 0c             	mov    0xc(%eax),%eax
  802e9f:	01 c2                	add    %eax,%edx
  802ea1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ea4:	8b 40 08             	mov    0x8(%eax),%eax
  802ea7:	39 c2                	cmp    %eax,%edx
  802ea9:	0f 85 ae 01 00 00    	jne    80305d <insert_sorted_with_merge_freeList+0x721>
  802eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb2:	8b 50 08             	mov    0x8(%eax),%edx
  802eb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb8:	8b 48 08             	mov    0x8(%eax),%ecx
  802ebb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebe:	8b 40 0c             	mov    0xc(%eax),%eax
  802ec1:	01 c8                	add    %ecx,%eax
  802ec3:	39 c2                	cmp    %eax,%edx
  802ec5:	0f 85 92 01 00 00    	jne    80305d <insert_sorted_with_merge_freeList+0x721>
							{
								blk_itr->size = blk_itr->size + blockToInsert->size + next->size;
  802ecb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ece:	8b 50 0c             	mov    0xc(%eax),%edx
  802ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed4:	8b 40 0c             	mov    0xc(%eax),%eax
  802ed7:	01 c2                	add    %eax,%edx
  802ed9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802edc:	8b 40 0c             	mov    0xc(%eax),%eax
  802edf:	01 c2                	add    %eax,%edx
  802ee1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee4:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size = blockToInsert->sva=0;
  802ee7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eea:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef4:	8b 50 08             	mov    0x8(%eax),%edx
  802ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  802efa:	89 50 0c             	mov    %edx,0xc(%eax)
								next->size = next->sva = 0;
  802efd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f00:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802f07:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f0a:	8b 50 08             	mov    0x8(%eax),%edx
  802f0d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f10:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_REMOVE(&FreeMemBlocksList, next);
  802f13:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f17:	75 17                	jne    802f30 <insert_sorted_with_merge_freeList+0x5f4>
  802f19:	83 ec 04             	sub    $0x4,%esp
  802f1c:	68 1b 3c 80 00       	push   $0x803c1b
  802f21:	68 63 01 00 00       	push   $0x163
  802f26:	68 73 3b 80 00       	push   $0x803b73
  802f2b:	e8 60 d4 ff ff       	call   800390 <_panic>
  802f30:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f33:	8b 00                	mov    (%eax),%eax
  802f35:	85 c0                	test   %eax,%eax
  802f37:	74 10                	je     802f49 <insert_sorted_with_merge_freeList+0x60d>
  802f39:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f3c:	8b 00                	mov    (%eax),%eax
  802f3e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f41:	8b 52 04             	mov    0x4(%edx),%edx
  802f44:	89 50 04             	mov    %edx,0x4(%eax)
  802f47:	eb 0b                	jmp    802f54 <insert_sorted_with_merge_freeList+0x618>
  802f49:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f4c:	8b 40 04             	mov    0x4(%eax),%eax
  802f4f:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802f54:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f57:	8b 40 04             	mov    0x4(%eax),%eax
  802f5a:	85 c0                	test   %eax,%eax
  802f5c:	74 0f                	je     802f6d <insert_sorted_with_merge_freeList+0x631>
  802f5e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f61:	8b 40 04             	mov    0x4(%eax),%eax
  802f64:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f67:	8b 12                	mov    (%edx),%edx
  802f69:	89 10                	mov    %edx,(%eax)
  802f6b:	eb 0a                	jmp    802f77 <insert_sorted_with_merge_freeList+0x63b>
  802f6d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f70:	8b 00                	mov    (%eax),%eax
  802f72:	a3 38 41 80 00       	mov    %eax,0x804138
  802f77:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f7a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f80:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f83:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f8a:	a1 44 41 80 00       	mov    0x804144,%eax
  802f8f:	48                   	dec    %eax
  802f90:	a3 44 41 80 00       	mov    %eax,0x804144
								LIST_INSERT_HEAD(&AvailableMemBlocksList, next );
  802f95:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f99:	75 17                	jne    802fb2 <insert_sorted_with_merge_freeList+0x676>
  802f9b:	83 ec 04             	sub    $0x4,%esp
  802f9e:	68 50 3b 80 00       	push   $0x803b50
  802fa3:	68 64 01 00 00       	push   $0x164
  802fa8:	68 73 3b 80 00       	push   $0x803b73
  802fad:	e8 de d3 ff ff       	call   800390 <_panic>
  802fb2:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802fb8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fbb:	89 10                	mov    %edx,(%eax)
  802fbd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fc0:	8b 00                	mov    (%eax),%eax
  802fc2:	85 c0                	test   %eax,%eax
  802fc4:	74 0d                	je     802fd3 <insert_sorted_with_merge_freeList+0x697>
  802fc6:	a1 48 41 80 00       	mov    0x804148,%eax
  802fcb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fce:	89 50 04             	mov    %edx,0x4(%eax)
  802fd1:	eb 08                	jmp    802fdb <insert_sorted_with_merge_freeList+0x69f>
  802fd3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fd6:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802fdb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fde:	a3 48 41 80 00       	mov    %eax,0x804148
  802fe3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fe6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fed:	a1 54 41 80 00       	mov    0x804154,%eax
  802ff2:	40                   	inc    %eax
  802ff3:	a3 54 41 80 00       	mov    %eax,0x804154
							    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802ff8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ffc:	75 17                	jne    803015 <insert_sorted_with_merge_freeList+0x6d9>
  802ffe:	83 ec 04             	sub    $0x4,%esp
  803001:	68 50 3b 80 00       	push   $0x803b50
  803006:	68 65 01 00 00       	push   $0x165
  80300b:	68 73 3b 80 00       	push   $0x803b73
  803010:	e8 7b d3 ff ff       	call   800390 <_panic>
  803015:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80301b:	8b 45 08             	mov    0x8(%ebp),%eax
  80301e:	89 10                	mov    %edx,(%eax)
  803020:	8b 45 08             	mov    0x8(%ebp),%eax
  803023:	8b 00                	mov    (%eax),%eax
  803025:	85 c0                	test   %eax,%eax
  803027:	74 0d                	je     803036 <insert_sorted_with_merge_freeList+0x6fa>
  803029:	a1 48 41 80 00       	mov    0x804148,%eax
  80302e:	8b 55 08             	mov    0x8(%ebp),%edx
  803031:	89 50 04             	mov    %edx,0x4(%eax)
  803034:	eb 08                	jmp    80303e <insert_sorted_with_merge_freeList+0x702>
  803036:	8b 45 08             	mov    0x8(%ebp),%eax
  803039:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80303e:	8b 45 08             	mov    0x8(%ebp),%eax
  803041:	a3 48 41 80 00       	mov    %eax,0x804148
  803046:	8b 45 08             	mov    0x8(%ebp),%eax
  803049:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803050:	a1 54 41 80 00       	mov    0x804154,%eax
  803055:	40                   	inc    %eax
  803056:	a3 54 41 80 00       	mov    %eax,0x804154
								break;
  80305b:	eb 38                	jmp    803095 <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  80305d:	a1 40 41 80 00       	mov    0x804140,%eax
  803062:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803065:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803069:	74 07                	je     803072 <insert_sorted_with_merge_freeList+0x736>
  80306b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306e:	8b 00                	mov    (%eax),%eax
  803070:	eb 05                	jmp    803077 <insert_sorted_with_merge_freeList+0x73b>
  803072:	b8 00 00 00 00       	mov    $0x0,%eax
  803077:	a3 40 41 80 00       	mov    %eax,0x804140
  80307c:	a1 40 41 80 00       	mov    0x804140,%eax
  803081:	85 c0                	test   %eax,%eax
  803083:	0f 85 a7 fb ff ff    	jne    802c30 <insert_sorted_with_merge_freeList+0x2f4>
  803089:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80308d:	0f 85 9d fb ff ff    	jne    802c30 <insert_sorted_with_merge_freeList+0x2f4>
						}
				}
        }

}
}
  803093:	eb 00                	jmp    803095 <insert_sorted_with_merge_freeList+0x759>
  803095:	90                   	nop
  803096:	c9                   	leave  
  803097:	c3                   	ret    

00803098 <__udivdi3>:
  803098:	55                   	push   %ebp
  803099:	57                   	push   %edi
  80309a:	56                   	push   %esi
  80309b:	53                   	push   %ebx
  80309c:	83 ec 1c             	sub    $0x1c,%esp
  80309f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8030a3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8030a7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8030ab:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8030af:	89 ca                	mov    %ecx,%edx
  8030b1:	89 f8                	mov    %edi,%eax
  8030b3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8030b7:	85 f6                	test   %esi,%esi
  8030b9:	75 2d                	jne    8030e8 <__udivdi3+0x50>
  8030bb:	39 cf                	cmp    %ecx,%edi
  8030bd:	77 65                	ja     803124 <__udivdi3+0x8c>
  8030bf:	89 fd                	mov    %edi,%ebp
  8030c1:	85 ff                	test   %edi,%edi
  8030c3:	75 0b                	jne    8030d0 <__udivdi3+0x38>
  8030c5:	b8 01 00 00 00       	mov    $0x1,%eax
  8030ca:	31 d2                	xor    %edx,%edx
  8030cc:	f7 f7                	div    %edi
  8030ce:	89 c5                	mov    %eax,%ebp
  8030d0:	31 d2                	xor    %edx,%edx
  8030d2:	89 c8                	mov    %ecx,%eax
  8030d4:	f7 f5                	div    %ebp
  8030d6:	89 c1                	mov    %eax,%ecx
  8030d8:	89 d8                	mov    %ebx,%eax
  8030da:	f7 f5                	div    %ebp
  8030dc:	89 cf                	mov    %ecx,%edi
  8030de:	89 fa                	mov    %edi,%edx
  8030e0:	83 c4 1c             	add    $0x1c,%esp
  8030e3:	5b                   	pop    %ebx
  8030e4:	5e                   	pop    %esi
  8030e5:	5f                   	pop    %edi
  8030e6:	5d                   	pop    %ebp
  8030e7:	c3                   	ret    
  8030e8:	39 ce                	cmp    %ecx,%esi
  8030ea:	77 28                	ja     803114 <__udivdi3+0x7c>
  8030ec:	0f bd fe             	bsr    %esi,%edi
  8030ef:	83 f7 1f             	xor    $0x1f,%edi
  8030f2:	75 40                	jne    803134 <__udivdi3+0x9c>
  8030f4:	39 ce                	cmp    %ecx,%esi
  8030f6:	72 0a                	jb     803102 <__udivdi3+0x6a>
  8030f8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8030fc:	0f 87 9e 00 00 00    	ja     8031a0 <__udivdi3+0x108>
  803102:	b8 01 00 00 00       	mov    $0x1,%eax
  803107:	89 fa                	mov    %edi,%edx
  803109:	83 c4 1c             	add    $0x1c,%esp
  80310c:	5b                   	pop    %ebx
  80310d:	5e                   	pop    %esi
  80310e:	5f                   	pop    %edi
  80310f:	5d                   	pop    %ebp
  803110:	c3                   	ret    
  803111:	8d 76 00             	lea    0x0(%esi),%esi
  803114:	31 ff                	xor    %edi,%edi
  803116:	31 c0                	xor    %eax,%eax
  803118:	89 fa                	mov    %edi,%edx
  80311a:	83 c4 1c             	add    $0x1c,%esp
  80311d:	5b                   	pop    %ebx
  80311e:	5e                   	pop    %esi
  80311f:	5f                   	pop    %edi
  803120:	5d                   	pop    %ebp
  803121:	c3                   	ret    
  803122:	66 90                	xchg   %ax,%ax
  803124:	89 d8                	mov    %ebx,%eax
  803126:	f7 f7                	div    %edi
  803128:	31 ff                	xor    %edi,%edi
  80312a:	89 fa                	mov    %edi,%edx
  80312c:	83 c4 1c             	add    $0x1c,%esp
  80312f:	5b                   	pop    %ebx
  803130:	5e                   	pop    %esi
  803131:	5f                   	pop    %edi
  803132:	5d                   	pop    %ebp
  803133:	c3                   	ret    
  803134:	bd 20 00 00 00       	mov    $0x20,%ebp
  803139:	89 eb                	mov    %ebp,%ebx
  80313b:	29 fb                	sub    %edi,%ebx
  80313d:	89 f9                	mov    %edi,%ecx
  80313f:	d3 e6                	shl    %cl,%esi
  803141:	89 c5                	mov    %eax,%ebp
  803143:	88 d9                	mov    %bl,%cl
  803145:	d3 ed                	shr    %cl,%ebp
  803147:	89 e9                	mov    %ebp,%ecx
  803149:	09 f1                	or     %esi,%ecx
  80314b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80314f:	89 f9                	mov    %edi,%ecx
  803151:	d3 e0                	shl    %cl,%eax
  803153:	89 c5                	mov    %eax,%ebp
  803155:	89 d6                	mov    %edx,%esi
  803157:	88 d9                	mov    %bl,%cl
  803159:	d3 ee                	shr    %cl,%esi
  80315b:	89 f9                	mov    %edi,%ecx
  80315d:	d3 e2                	shl    %cl,%edx
  80315f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803163:	88 d9                	mov    %bl,%cl
  803165:	d3 e8                	shr    %cl,%eax
  803167:	09 c2                	or     %eax,%edx
  803169:	89 d0                	mov    %edx,%eax
  80316b:	89 f2                	mov    %esi,%edx
  80316d:	f7 74 24 0c          	divl   0xc(%esp)
  803171:	89 d6                	mov    %edx,%esi
  803173:	89 c3                	mov    %eax,%ebx
  803175:	f7 e5                	mul    %ebp
  803177:	39 d6                	cmp    %edx,%esi
  803179:	72 19                	jb     803194 <__udivdi3+0xfc>
  80317b:	74 0b                	je     803188 <__udivdi3+0xf0>
  80317d:	89 d8                	mov    %ebx,%eax
  80317f:	31 ff                	xor    %edi,%edi
  803181:	e9 58 ff ff ff       	jmp    8030de <__udivdi3+0x46>
  803186:	66 90                	xchg   %ax,%ax
  803188:	8b 54 24 08          	mov    0x8(%esp),%edx
  80318c:	89 f9                	mov    %edi,%ecx
  80318e:	d3 e2                	shl    %cl,%edx
  803190:	39 c2                	cmp    %eax,%edx
  803192:	73 e9                	jae    80317d <__udivdi3+0xe5>
  803194:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803197:	31 ff                	xor    %edi,%edi
  803199:	e9 40 ff ff ff       	jmp    8030de <__udivdi3+0x46>
  80319e:	66 90                	xchg   %ax,%ax
  8031a0:	31 c0                	xor    %eax,%eax
  8031a2:	e9 37 ff ff ff       	jmp    8030de <__udivdi3+0x46>
  8031a7:	90                   	nop

008031a8 <__umoddi3>:
  8031a8:	55                   	push   %ebp
  8031a9:	57                   	push   %edi
  8031aa:	56                   	push   %esi
  8031ab:	53                   	push   %ebx
  8031ac:	83 ec 1c             	sub    $0x1c,%esp
  8031af:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8031b3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8031b7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8031bb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8031bf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8031c3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8031c7:	89 f3                	mov    %esi,%ebx
  8031c9:	89 fa                	mov    %edi,%edx
  8031cb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8031cf:	89 34 24             	mov    %esi,(%esp)
  8031d2:	85 c0                	test   %eax,%eax
  8031d4:	75 1a                	jne    8031f0 <__umoddi3+0x48>
  8031d6:	39 f7                	cmp    %esi,%edi
  8031d8:	0f 86 a2 00 00 00    	jbe    803280 <__umoddi3+0xd8>
  8031de:	89 c8                	mov    %ecx,%eax
  8031e0:	89 f2                	mov    %esi,%edx
  8031e2:	f7 f7                	div    %edi
  8031e4:	89 d0                	mov    %edx,%eax
  8031e6:	31 d2                	xor    %edx,%edx
  8031e8:	83 c4 1c             	add    $0x1c,%esp
  8031eb:	5b                   	pop    %ebx
  8031ec:	5e                   	pop    %esi
  8031ed:	5f                   	pop    %edi
  8031ee:	5d                   	pop    %ebp
  8031ef:	c3                   	ret    
  8031f0:	39 f0                	cmp    %esi,%eax
  8031f2:	0f 87 ac 00 00 00    	ja     8032a4 <__umoddi3+0xfc>
  8031f8:	0f bd e8             	bsr    %eax,%ebp
  8031fb:	83 f5 1f             	xor    $0x1f,%ebp
  8031fe:	0f 84 ac 00 00 00    	je     8032b0 <__umoddi3+0x108>
  803204:	bf 20 00 00 00       	mov    $0x20,%edi
  803209:	29 ef                	sub    %ebp,%edi
  80320b:	89 fe                	mov    %edi,%esi
  80320d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803211:	89 e9                	mov    %ebp,%ecx
  803213:	d3 e0                	shl    %cl,%eax
  803215:	89 d7                	mov    %edx,%edi
  803217:	89 f1                	mov    %esi,%ecx
  803219:	d3 ef                	shr    %cl,%edi
  80321b:	09 c7                	or     %eax,%edi
  80321d:	89 e9                	mov    %ebp,%ecx
  80321f:	d3 e2                	shl    %cl,%edx
  803221:	89 14 24             	mov    %edx,(%esp)
  803224:	89 d8                	mov    %ebx,%eax
  803226:	d3 e0                	shl    %cl,%eax
  803228:	89 c2                	mov    %eax,%edx
  80322a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80322e:	d3 e0                	shl    %cl,%eax
  803230:	89 44 24 04          	mov    %eax,0x4(%esp)
  803234:	8b 44 24 08          	mov    0x8(%esp),%eax
  803238:	89 f1                	mov    %esi,%ecx
  80323a:	d3 e8                	shr    %cl,%eax
  80323c:	09 d0                	or     %edx,%eax
  80323e:	d3 eb                	shr    %cl,%ebx
  803240:	89 da                	mov    %ebx,%edx
  803242:	f7 f7                	div    %edi
  803244:	89 d3                	mov    %edx,%ebx
  803246:	f7 24 24             	mull   (%esp)
  803249:	89 c6                	mov    %eax,%esi
  80324b:	89 d1                	mov    %edx,%ecx
  80324d:	39 d3                	cmp    %edx,%ebx
  80324f:	0f 82 87 00 00 00    	jb     8032dc <__umoddi3+0x134>
  803255:	0f 84 91 00 00 00    	je     8032ec <__umoddi3+0x144>
  80325b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80325f:	29 f2                	sub    %esi,%edx
  803261:	19 cb                	sbb    %ecx,%ebx
  803263:	89 d8                	mov    %ebx,%eax
  803265:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803269:	d3 e0                	shl    %cl,%eax
  80326b:	89 e9                	mov    %ebp,%ecx
  80326d:	d3 ea                	shr    %cl,%edx
  80326f:	09 d0                	or     %edx,%eax
  803271:	89 e9                	mov    %ebp,%ecx
  803273:	d3 eb                	shr    %cl,%ebx
  803275:	89 da                	mov    %ebx,%edx
  803277:	83 c4 1c             	add    $0x1c,%esp
  80327a:	5b                   	pop    %ebx
  80327b:	5e                   	pop    %esi
  80327c:	5f                   	pop    %edi
  80327d:	5d                   	pop    %ebp
  80327e:	c3                   	ret    
  80327f:	90                   	nop
  803280:	89 fd                	mov    %edi,%ebp
  803282:	85 ff                	test   %edi,%edi
  803284:	75 0b                	jne    803291 <__umoddi3+0xe9>
  803286:	b8 01 00 00 00       	mov    $0x1,%eax
  80328b:	31 d2                	xor    %edx,%edx
  80328d:	f7 f7                	div    %edi
  80328f:	89 c5                	mov    %eax,%ebp
  803291:	89 f0                	mov    %esi,%eax
  803293:	31 d2                	xor    %edx,%edx
  803295:	f7 f5                	div    %ebp
  803297:	89 c8                	mov    %ecx,%eax
  803299:	f7 f5                	div    %ebp
  80329b:	89 d0                	mov    %edx,%eax
  80329d:	e9 44 ff ff ff       	jmp    8031e6 <__umoddi3+0x3e>
  8032a2:	66 90                	xchg   %ax,%ax
  8032a4:	89 c8                	mov    %ecx,%eax
  8032a6:	89 f2                	mov    %esi,%edx
  8032a8:	83 c4 1c             	add    $0x1c,%esp
  8032ab:	5b                   	pop    %ebx
  8032ac:	5e                   	pop    %esi
  8032ad:	5f                   	pop    %edi
  8032ae:	5d                   	pop    %ebp
  8032af:	c3                   	ret    
  8032b0:	3b 04 24             	cmp    (%esp),%eax
  8032b3:	72 06                	jb     8032bb <__umoddi3+0x113>
  8032b5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8032b9:	77 0f                	ja     8032ca <__umoddi3+0x122>
  8032bb:	89 f2                	mov    %esi,%edx
  8032bd:	29 f9                	sub    %edi,%ecx
  8032bf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8032c3:	89 14 24             	mov    %edx,(%esp)
  8032c6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8032ca:	8b 44 24 04          	mov    0x4(%esp),%eax
  8032ce:	8b 14 24             	mov    (%esp),%edx
  8032d1:	83 c4 1c             	add    $0x1c,%esp
  8032d4:	5b                   	pop    %ebx
  8032d5:	5e                   	pop    %esi
  8032d6:	5f                   	pop    %edi
  8032d7:	5d                   	pop    %ebp
  8032d8:	c3                   	ret    
  8032d9:	8d 76 00             	lea    0x0(%esi),%esi
  8032dc:	2b 04 24             	sub    (%esp),%eax
  8032df:	19 fa                	sbb    %edi,%edx
  8032e1:	89 d1                	mov    %edx,%ecx
  8032e3:	89 c6                	mov    %eax,%esi
  8032e5:	e9 71 ff ff ff       	jmp    80325b <__umoddi3+0xb3>
  8032ea:	66 90                	xchg   %ax,%ax
  8032ec:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8032f0:	72 ea                	jb     8032dc <__umoddi3+0x134>
  8032f2:	89 d9                	mov    %ebx,%ecx
  8032f4:	e9 62 ff ff ff       	jmp    80325b <__umoddi3+0xb3>
