
obj/user/tst_sharing_2slave1:     file format elf32-i386


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
  800031:	e8 2b 02 00 00       	call   800261 <libmain>
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
  80008d:	68 20 33 80 00       	push   $0x803320
  800092:	6a 13                	push   $0x13
  800094:	68 3c 33 80 00       	push   $0x80333c
  800099:	e8 ff 02 00 00       	call   80039d <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	6a 00                	push   $0x0
  8000a3:	e8 d5 14 00 00       	call   80157d <malloc>
  8000a8:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	uint32 *x,*y,*z;
	int32 parentenvID = sys_getparentenvid();
  8000ab:	e8 f4 1b 00 00       	call   801ca4 <sys_getparentenvid>
  8000b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//GET: z then y then x, opposite to creation order (x then y then z)
	//So, addresses here will be different from the OWNER addresses
	sys_disable_interrupt();
  8000b3:	e8 e0 19 00 00       	call   801a98 <sys_disable_interrupt>
	int freeFrames = sys_calculate_free_frames() ;
  8000b8:	e8 ee 18 00 00       	call   8019ab <sys_calculate_free_frames>
  8000bd:	89 45 e8             	mov    %eax,-0x18(%ebp)
	z = sget(parentenvID,"z");
  8000c0:	83 ec 08             	sub    $0x8,%esp
  8000c3:	68 57 33 80 00       	push   $0x803357
  8000c8:	ff 75 ec             	pushl  -0x14(%ebp)
  8000cb:	e8 a5 16 00 00       	call   801775 <sget>
  8000d0:	83 c4 10             	add    $0x10,%esp
  8000d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (z != (uint32*)(USER_HEAP_START + 0 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8000d6:	81 7d e4 00 00 00 80 	cmpl   $0x80000000,-0x1c(%ebp)
  8000dd:	74 14                	je     8000f3 <_main+0xbb>
  8000df:	83 ec 04             	sub    $0x4,%esp
  8000e2:	68 5c 33 80 00       	push   $0x80335c
  8000e7:	6a 20                	push   $0x20
  8000e9:	68 3c 33 80 00       	push   $0x80333c
  8000ee:	e8 aa 02 00 00       	call   80039d <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  8000f3:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000f6:	e8 b0 18 00 00       	call   8019ab <sys_calculate_free_frames>
  8000fb:	29 c3                	sub    %eax,%ebx
  8000fd:	89 d8                	mov    %ebx,%eax
  8000ff:	83 f8 01             	cmp    $0x1,%eax
  800102:	74 14                	je     800118 <_main+0xe0>
  800104:	83 ec 04             	sub    $0x4,%esp
  800107:	68 bc 33 80 00       	push   $0x8033bc
  80010c:	6a 21                	push   $0x21
  80010e:	68 3c 33 80 00       	push   $0x80333c
  800113:	e8 85 02 00 00       	call   80039d <_panic>
	sys_enable_interrupt();
  800118:	e8 95 19 00 00       	call   801ab2 <sys_enable_interrupt>

	sys_disable_interrupt();
  80011d:	e8 76 19 00 00       	call   801a98 <sys_disable_interrupt>
	freeFrames = sys_calculate_free_frames() ;
  800122:	e8 84 18 00 00       	call   8019ab <sys_calculate_free_frames>
  800127:	89 45 e8             	mov    %eax,-0x18(%ebp)
	y = sget(parentenvID,"y");
  80012a:	83 ec 08             	sub    $0x8,%esp
  80012d:	68 4d 34 80 00       	push   $0x80344d
  800132:	ff 75 ec             	pushl  -0x14(%ebp)
  800135:	e8 3b 16 00 00       	call   801775 <sget>
  80013a:	83 c4 10             	add    $0x10,%esp
  80013d:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (y != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  800140:	81 7d e0 00 10 00 80 	cmpl   $0x80001000,-0x20(%ebp)
  800147:	74 14                	je     80015d <_main+0x125>
  800149:	83 ec 04             	sub    $0x4,%esp
  80014c:	68 5c 33 80 00       	push   $0x80335c
  800151:	6a 27                	push   $0x27
  800153:	68 3c 33 80 00       	push   $0x80333c
  800158:	e8 40 02 00 00       	call   80039d <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  80015d:	e8 49 18 00 00       	call   8019ab <sys_calculate_free_frames>
  800162:	89 c2                	mov    %eax,%edx
  800164:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800167:	39 c2                	cmp    %eax,%edx
  800169:	74 14                	je     80017f <_main+0x147>
  80016b:	83 ec 04             	sub    $0x4,%esp
  80016e:	68 bc 33 80 00       	push   $0x8033bc
  800173:	6a 28                	push   $0x28
  800175:	68 3c 33 80 00       	push   $0x80333c
  80017a:	e8 1e 02 00 00       	call   80039d <_panic>
	sys_enable_interrupt();
  80017f:	e8 2e 19 00 00       	call   801ab2 <sys_enable_interrupt>

	if (*y != 20) panic("Get(): Shared Variable is not created or got correctly") ;
  800184:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800187:	8b 00                	mov    (%eax),%eax
  800189:	83 f8 14             	cmp    $0x14,%eax
  80018c:	74 14                	je     8001a2 <_main+0x16a>
  80018e:	83 ec 04             	sub    $0x4,%esp
  800191:	68 50 34 80 00       	push   $0x803450
  800196:	6a 2b                	push   $0x2b
  800198:	68 3c 33 80 00       	push   $0x80333c
  80019d:	e8 fb 01 00 00       	call   80039d <_panic>

	sys_disable_interrupt();
  8001a2:	e8 f1 18 00 00       	call   801a98 <sys_disable_interrupt>
	freeFrames = sys_calculate_free_frames() ;
  8001a7:	e8 ff 17 00 00       	call   8019ab <sys_calculate_free_frames>
  8001ac:	89 45 e8             	mov    %eax,-0x18(%ebp)
	x = sget(parentenvID,"x");
  8001af:	83 ec 08             	sub    $0x8,%esp
  8001b2:	68 87 34 80 00       	push   $0x803487
  8001b7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ba:	e8 b6 15 00 00       	call   801775 <sget>
  8001bf:	83 c4 10             	add    $0x10,%esp
  8001c2:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (x != (uint32*)(USER_HEAP_START + 2 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8001c5:	81 7d dc 00 20 00 80 	cmpl   $0x80002000,-0x24(%ebp)
  8001cc:	74 14                	je     8001e2 <_main+0x1aa>
  8001ce:	83 ec 04             	sub    $0x4,%esp
  8001d1:	68 5c 33 80 00       	push   $0x80335c
  8001d6:	6a 30                	push   $0x30
  8001d8:	68 3c 33 80 00       	push   $0x80333c
  8001dd:	e8 bb 01 00 00       	call   80039d <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  8001e2:	e8 c4 17 00 00       	call   8019ab <sys_calculate_free_frames>
  8001e7:	89 c2                	mov    %eax,%edx
  8001e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001ec:	39 c2                	cmp    %eax,%edx
  8001ee:	74 14                	je     800204 <_main+0x1cc>
  8001f0:	83 ec 04             	sub    $0x4,%esp
  8001f3:	68 bc 33 80 00       	push   $0x8033bc
  8001f8:	6a 31                	push   $0x31
  8001fa:	68 3c 33 80 00       	push   $0x80333c
  8001ff:	e8 99 01 00 00       	call   80039d <_panic>
	sys_enable_interrupt();
  800204:	e8 a9 18 00 00       	call   801ab2 <sys_enable_interrupt>

	if (*x != 10) panic("Get(): Shared Variable is not created or got correctly") ;
  800209:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80020c:	8b 00                	mov    (%eax),%eax
  80020e:	83 f8 0a             	cmp    $0xa,%eax
  800211:	74 14                	je     800227 <_main+0x1ef>
  800213:	83 ec 04             	sub    $0x4,%esp
  800216:	68 50 34 80 00       	push   $0x803450
  80021b:	6a 34                	push   $0x34
  80021d:	68 3c 33 80 00       	push   $0x80333c
  800222:	e8 76 01 00 00       	call   80039d <_panic>

	*z = *x + *y ;
  800227:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80022a:	8b 10                	mov    (%eax),%edx
  80022c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80022f:	8b 00                	mov    (%eax),%eax
  800231:	01 c2                	add    %eax,%edx
  800233:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800236:	89 10                	mov    %edx,(%eax)
	if (*z != 30) panic("Get(): Shared Variable is not created or got correctly") ;
  800238:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80023b:	8b 00                	mov    (%eax),%eax
  80023d:	83 f8 1e             	cmp    $0x1e,%eax
  800240:	74 14                	je     800256 <_main+0x21e>
  800242:	83 ec 04             	sub    $0x4,%esp
  800245:	68 50 34 80 00       	push   $0x803450
  80024a:	6a 37                	push   $0x37
  80024c:	68 3c 33 80 00       	push   $0x80333c
  800251:	e8 47 01 00 00       	call   80039d <_panic>

	//To indicate that it's completed successfully
	inctst();
  800256:	e8 6e 1b 00 00       	call   801dc9 <inctst>

	return;
  80025b:	90                   	nop
}
  80025c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80025f:	c9                   	leave  
  800260:	c3                   	ret    

00800261 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800261:	55                   	push   %ebp
  800262:	89 e5                	mov    %esp,%ebp
  800264:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800267:	e8 1f 1a 00 00       	call   801c8b <sys_getenvindex>
  80026c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80026f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800272:	89 d0                	mov    %edx,%eax
  800274:	c1 e0 03             	shl    $0x3,%eax
  800277:	01 d0                	add    %edx,%eax
  800279:	01 c0                	add    %eax,%eax
  80027b:	01 d0                	add    %edx,%eax
  80027d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800284:	01 d0                	add    %edx,%eax
  800286:	c1 e0 04             	shl    $0x4,%eax
  800289:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80028e:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800293:	a1 20 40 80 00       	mov    0x804020,%eax
  800298:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80029e:	84 c0                	test   %al,%al
  8002a0:	74 0f                	je     8002b1 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8002a2:	a1 20 40 80 00       	mov    0x804020,%eax
  8002a7:	05 5c 05 00 00       	add    $0x55c,%eax
  8002ac:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002b1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002b5:	7e 0a                	jle    8002c1 <libmain+0x60>
		binaryname = argv[0];
  8002b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ba:	8b 00                	mov    (%eax),%eax
  8002bc:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8002c1:	83 ec 08             	sub    $0x8,%esp
  8002c4:	ff 75 0c             	pushl  0xc(%ebp)
  8002c7:	ff 75 08             	pushl  0x8(%ebp)
  8002ca:	e8 69 fd ff ff       	call   800038 <_main>
  8002cf:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8002d2:	e8 c1 17 00 00       	call   801a98 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8002d7:	83 ec 0c             	sub    $0xc,%esp
  8002da:	68 a4 34 80 00       	push   $0x8034a4
  8002df:	e8 6d 03 00 00       	call   800651 <cprintf>
  8002e4:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002e7:	a1 20 40 80 00       	mov    0x804020,%eax
  8002ec:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8002f2:	a1 20 40 80 00       	mov    0x804020,%eax
  8002f7:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8002fd:	83 ec 04             	sub    $0x4,%esp
  800300:	52                   	push   %edx
  800301:	50                   	push   %eax
  800302:	68 cc 34 80 00       	push   $0x8034cc
  800307:	e8 45 03 00 00       	call   800651 <cprintf>
  80030c:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80030f:	a1 20 40 80 00       	mov    0x804020,%eax
  800314:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80031a:	a1 20 40 80 00       	mov    0x804020,%eax
  80031f:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800325:	a1 20 40 80 00       	mov    0x804020,%eax
  80032a:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800330:	51                   	push   %ecx
  800331:	52                   	push   %edx
  800332:	50                   	push   %eax
  800333:	68 f4 34 80 00       	push   $0x8034f4
  800338:	e8 14 03 00 00       	call   800651 <cprintf>
  80033d:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800340:	a1 20 40 80 00       	mov    0x804020,%eax
  800345:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80034b:	83 ec 08             	sub    $0x8,%esp
  80034e:	50                   	push   %eax
  80034f:	68 4c 35 80 00       	push   $0x80354c
  800354:	e8 f8 02 00 00       	call   800651 <cprintf>
  800359:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80035c:	83 ec 0c             	sub    $0xc,%esp
  80035f:	68 a4 34 80 00       	push   $0x8034a4
  800364:	e8 e8 02 00 00       	call   800651 <cprintf>
  800369:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80036c:	e8 41 17 00 00       	call   801ab2 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800371:	e8 19 00 00 00       	call   80038f <exit>
}
  800376:	90                   	nop
  800377:	c9                   	leave  
  800378:	c3                   	ret    

00800379 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800379:	55                   	push   %ebp
  80037a:	89 e5                	mov    %esp,%ebp
  80037c:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80037f:	83 ec 0c             	sub    $0xc,%esp
  800382:	6a 00                	push   $0x0
  800384:	e8 ce 18 00 00       	call   801c57 <sys_destroy_env>
  800389:	83 c4 10             	add    $0x10,%esp
}
  80038c:	90                   	nop
  80038d:	c9                   	leave  
  80038e:	c3                   	ret    

0080038f <exit>:

void
exit(void)
{
  80038f:	55                   	push   %ebp
  800390:	89 e5                	mov    %esp,%ebp
  800392:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800395:	e8 23 19 00 00       	call   801cbd <sys_exit_env>
}
  80039a:	90                   	nop
  80039b:	c9                   	leave  
  80039c:	c3                   	ret    

0080039d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80039d:	55                   	push   %ebp
  80039e:	89 e5                	mov    %esp,%ebp
  8003a0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8003a3:	8d 45 10             	lea    0x10(%ebp),%eax
  8003a6:	83 c0 04             	add    $0x4,%eax
  8003a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8003ac:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8003b1:	85 c0                	test   %eax,%eax
  8003b3:	74 16                	je     8003cb <_panic+0x2e>
		cprintf("%s: ", argv0);
  8003b5:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8003ba:	83 ec 08             	sub    $0x8,%esp
  8003bd:	50                   	push   %eax
  8003be:	68 60 35 80 00       	push   $0x803560
  8003c3:	e8 89 02 00 00       	call   800651 <cprintf>
  8003c8:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8003cb:	a1 00 40 80 00       	mov    0x804000,%eax
  8003d0:	ff 75 0c             	pushl  0xc(%ebp)
  8003d3:	ff 75 08             	pushl  0x8(%ebp)
  8003d6:	50                   	push   %eax
  8003d7:	68 65 35 80 00       	push   $0x803565
  8003dc:	e8 70 02 00 00       	call   800651 <cprintf>
  8003e1:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8003e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8003e7:	83 ec 08             	sub    $0x8,%esp
  8003ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8003ed:	50                   	push   %eax
  8003ee:	e8 f3 01 00 00       	call   8005e6 <vcprintf>
  8003f3:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8003f6:	83 ec 08             	sub    $0x8,%esp
  8003f9:	6a 00                	push   $0x0
  8003fb:	68 81 35 80 00       	push   $0x803581
  800400:	e8 e1 01 00 00       	call   8005e6 <vcprintf>
  800405:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800408:	e8 82 ff ff ff       	call   80038f <exit>

	// should not return here
	while (1) ;
  80040d:	eb fe                	jmp    80040d <_panic+0x70>

0080040f <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80040f:	55                   	push   %ebp
  800410:	89 e5                	mov    %esp,%ebp
  800412:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800415:	a1 20 40 80 00       	mov    0x804020,%eax
  80041a:	8b 50 74             	mov    0x74(%eax),%edx
  80041d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800420:	39 c2                	cmp    %eax,%edx
  800422:	74 14                	je     800438 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800424:	83 ec 04             	sub    $0x4,%esp
  800427:	68 84 35 80 00       	push   $0x803584
  80042c:	6a 26                	push   $0x26
  80042e:	68 d0 35 80 00       	push   $0x8035d0
  800433:	e8 65 ff ff ff       	call   80039d <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800438:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80043f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800446:	e9 c2 00 00 00       	jmp    80050d <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80044b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80044e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800455:	8b 45 08             	mov    0x8(%ebp),%eax
  800458:	01 d0                	add    %edx,%eax
  80045a:	8b 00                	mov    (%eax),%eax
  80045c:	85 c0                	test   %eax,%eax
  80045e:	75 08                	jne    800468 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800460:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800463:	e9 a2 00 00 00       	jmp    80050a <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800468:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80046f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800476:	eb 69                	jmp    8004e1 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800478:	a1 20 40 80 00       	mov    0x804020,%eax
  80047d:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800483:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800486:	89 d0                	mov    %edx,%eax
  800488:	01 c0                	add    %eax,%eax
  80048a:	01 d0                	add    %edx,%eax
  80048c:	c1 e0 03             	shl    $0x3,%eax
  80048f:	01 c8                	add    %ecx,%eax
  800491:	8a 40 04             	mov    0x4(%eax),%al
  800494:	84 c0                	test   %al,%al
  800496:	75 46                	jne    8004de <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800498:	a1 20 40 80 00       	mov    0x804020,%eax
  80049d:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8004a3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004a6:	89 d0                	mov    %edx,%eax
  8004a8:	01 c0                	add    %eax,%eax
  8004aa:	01 d0                	add    %edx,%eax
  8004ac:	c1 e0 03             	shl    $0x3,%eax
  8004af:	01 c8                	add    %ecx,%eax
  8004b1:	8b 00                	mov    (%eax),%eax
  8004b3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004b9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8004be:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8004c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004c3:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8004ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8004cd:	01 c8                	add    %ecx,%eax
  8004cf:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004d1:	39 c2                	cmp    %eax,%edx
  8004d3:	75 09                	jne    8004de <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8004d5:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8004dc:	eb 12                	jmp    8004f0 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004de:	ff 45 e8             	incl   -0x18(%ebp)
  8004e1:	a1 20 40 80 00       	mov    0x804020,%eax
  8004e6:	8b 50 74             	mov    0x74(%eax),%edx
  8004e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004ec:	39 c2                	cmp    %eax,%edx
  8004ee:	77 88                	ja     800478 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8004f0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8004f4:	75 14                	jne    80050a <CheckWSWithoutLastIndex+0xfb>
			panic(
  8004f6:	83 ec 04             	sub    $0x4,%esp
  8004f9:	68 dc 35 80 00       	push   $0x8035dc
  8004fe:	6a 3a                	push   $0x3a
  800500:	68 d0 35 80 00       	push   $0x8035d0
  800505:	e8 93 fe ff ff       	call   80039d <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80050a:	ff 45 f0             	incl   -0x10(%ebp)
  80050d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800510:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800513:	0f 8c 32 ff ff ff    	jl     80044b <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800519:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800520:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800527:	eb 26                	jmp    80054f <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800529:	a1 20 40 80 00       	mov    0x804020,%eax
  80052e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800534:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800537:	89 d0                	mov    %edx,%eax
  800539:	01 c0                	add    %eax,%eax
  80053b:	01 d0                	add    %edx,%eax
  80053d:	c1 e0 03             	shl    $0x3,%eax
  800540:	01 c8                	add    %ecx,%eax
  800542:	8a 40 04             	mov    0x4(%eax),%al
  800545:	3c 01                	cmp    $0x1,%al
  800547:	75 03                	jne    80054c <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800549:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80054c:	ff 45 e0             	incl   -0x20(%ebp)
  80054f:	a1 20 40 80 00       	mov    0x804020,%eax
  800554:	8b 50 74             	mov    0x74(%eax),%edx
  800557:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80055a:	39 c2                	cmp    %eax,%edx
  80055c:	77 cb                	ja     800529 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80055e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800561:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800564:	74 14                	je     80057a <CheckWSWithoutLastIndex+0x16b>
		panic(
  800566:	83 ec 04             	sub    $0x4,%esp
  800569:	68 30 36 80 00       	push   $0x803630
  80056e:	6a 44                	push   $0x44
  800570:	68 d0 35 80 00       	push   $0x8035d0
  800575:	e8 23 fe ff ff       	call   80039d <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80057a:	90                   	nop
  80057b:	c9                   	leave  
  80057c:	c3                   	ret    

0080057d <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80057d:	55                   	push   %ebp
  80057e:	89 e5                	mov    %esp,%ebp
  800580:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800583:	8b 45 0c             	mov    0xc(%ebp),%eax
  800586:	8b 00                	mov    (%eax),%eax
  800588:	8d 48 01             	lea    0x1(%eax),%ecx
  80058b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80058e:	89 0a                	mov    %ecx,(%edx)
  800590:	8b 55 08             	mov    0x8(%ebp),%edx
  800593:	88 d1                	mov    %dl,%cl
  800595:	8b 55 0c             	mov    0xc(%ebp),%edx
  800598:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80059c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80059f:	8b 00                	mov    (%eax),%eax
  8005a1:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005a6:	75 2c                	jne    8005d4 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8005a8:	a0 24 40 80 00       	mov    0x804024,%al
  8005ad:	0f b6 c0             	movzbl %al,%eax
  8005b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005b3:	8b 12                	mov    (%edx),%edx
  8005b5:	89 d1                	mov    %edx,%ecx
  8005b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005ba:	83 c2 08             	add    $0x8,%edx
  8005bd:	83 ec 04             	sub    $0x4,%esp
  8005c0:	50                   	push   %eax
  8005c1:	51                   	push   %ecx
  8005c2:	52                   	push   %edx
  8005c3:	e8 22 13 00 00       	call   8018ea <sys_cputs>
  8005c8:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8005cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8005d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005d7:	8b 40 04             	mov    0x4(%eax),%eax
  8005da:	8d 50 01             	lea    0x1(%eax),%edx
  8005dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005e0:	89 50 04             	mov    %edx,0x4(%eax)
}
  8005e3:	90                   	nop
  8005e4:	c9                   	leave  
  8005e5:	c3                   	ret    

008005e6 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8005e6:	55                   	push   %ebp
  8005e7:	89 e5                	mov    %esp,%ebp
  8005e9:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005ef:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005f6:	00 00 00 
	b.cnt = 0;
  8005f9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800600:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800603:	ff 75 0c             	pushl  0xc(%ebp)
  800606:	ff 75 08             	pushl  0x8(%ebp)
  800609:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80060f:	50                   	push   %eax
  800610:	68 7d 05 80 00       	push   $0x80057d
  800615:	e8 11 02 00 00       	call   80082b <vprintfmt>
  80061a:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80061d:	a0 24 40 80 00       	mov    0x804024,%al
  800622:	0f b6 c0             	movzbl %al,%eax
  800625:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80062b:	83 ec 04             	sub    $0x4,%esp
  80062e:	50                   	push   %eax
  80062f:	52                   	push   %edx
  800630:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800636:	83 c0 08             	add    $0x8,%eax
  800639:	50                   	push   %eax
  80063a:	e8 ab 12 00 00       	call   8018ea <sys_cputs>
  80063f:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800642:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800649:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80064f:	c9                   	leave  
  800650:	c3                   	ret    

00800651 <cprintf>:

int cprintf(const char *fmt, ...) {
  800651:	55                   	push   %ebp
  800652:	89 e5                	mov    %esp,%ebp
  800654:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800657:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  80065e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800661:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800664:	8b 45 08             	mov    0x8(%ebp),%eax
  800667:	83 ec 08             	sub    $0x8,%esp
  80066a:	ff 75 f4             	pushl  -0xc(%ebp)
  80066d:	50                   	push   %eax
  80066e:	e8 73 ff ff ff       	call   8005e6 <vcprintf>
  800673:	83 c4 10             	add    $0x10,%esp
  800676:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800679:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80067c:	c9                   	leave  
  80067d:	c3                   	ret    

0080067e <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80067e:	55                   	push   %ebp
  80067f:	89 e5                	mov    %esp,%ebp
  800681:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800684:	e8 0f 14 00 00       	call   801a98 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800689:	8d 45 0c             	lea    0xc(%ebp),%eax
  80068c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80068f:	8b 45 08             	mov    0x8(%ebp),%eax
  800692:	83 ec 08             	sub    $0x8,%esp
  800695:	ff 75 f4             	pushl  -0xc(%ebp)
  800698:	50                   	push   %eax
  800699:	e8 48 ff ff ff       	call   8005e6 <vcprintf>
  80069e:	83 c4 10             	add    $0x10,%esp
  8006a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8006a4:	e8 09 14 00 00       	call   801ab2 <sys_enable_interrupt>
	return cnt;
  8006a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006ac:	c9                   	leave  
  8006ad:	c3                   	ret    

008006ae <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006ae:	55                   	push   %ebp
  8006af:	89 e5                	mov    %esp,%ebp
  8006b1:	53                   	push   %ebx
  8006b2:	83 ec 14             	sub    $0x14,%esp
  8006b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8006b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006be:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006c1:	8b 45 18             	mov    0x18(%ebp),%eax
  8006c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006cc:	77 55                	ja     800723 <printnum+0x75>
  8006ce:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006d1:	72 05                	jb     8006d8 <printnum+0x2a>
  8006d3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8006d6:	77 4b                	ja     800723 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006d8:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006db:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8006de:	8b 45 18             	mov    0x18(%ebp),%eax
  8006e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8006e6:	52                   	push   %edx
  8006e7:	50                   	push   %eax
  8006e8:	ff 75 f4             	pushl  -0xc(%ebp)
  8006eb:	ff 75 f0             	pushl  -0x10(%ebp)
  8006ee:	e8 b5 29 00 00       	call   8030a8 <__udivdi3>
  8006f3:	83 c4 10             	add    $0x10,%esp
  8006f6:	83 ec 04             	sub    $0x4,%esp
  8006f9:	ff 75 20             	pushl  0x20(%ebp)
  8006fc:	53                   	push   %ebx
  8006fd:	ff 75 18             	pushl  0x18(%ebp)
  800700:	52                   	push   %edx
  800701:	50                   	push   %eax
  800702:	ff 75 0c             	pushl  0xc(%ebp)
  800705:	ff 75 08             	pushl  0x8(%ebp)
  800708:	e8 a1 ff ff ff       	call   8006ae <printnum>
  80070d:	83 c4 20             	add    $0x20,%esp
  800710:	eb 1a                	jmp    80072c <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800712:	83 ec 08             	sub    $0x8,%esp
  800715:	ff 75 0c             	pushl  0xc(%ebp)
  800718:	ff 75 20             	pushl  0x20(%ebp)
  80071b:	8b 45 08             	mov    0x8(%ebp),%eax
  80071e:	ff d0                	call   *%eax
  800720:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800723:	ff 4d 1c             	decl   0x1c(%ebp)
  800726:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80072a:	7f e6                	jg     800712 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80072c:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80072f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800734:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800737:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80073a:	53                   	push   %ebx
  80073b:	51                   	push   %ecx
  80073c:	52                   	push   %edx
  80073d:	50                   	push   %eax
  80073e:	e8 75 2a 00 00       	call   8031b8 <__umoddi3>
  800743:	83 c4 10             	add    $0x10,%esp
  800746:	05 94 38 80 00       	add    $0x803894,%eax
  80074b:	8a 00                	mov    (%eax),%al
  80074d:	0f be c0             	movsbl %al,%eax
  800750:	83 ec 08             	sub    $0x8,%esp
  800753:	ff 75 0c             	pushl  0xc(%ebp)
  800756:	50                   	push   %eax
  800757:	8b 45 08             	mov    0x8(%ebp),%eax
  80075a:	ff d0                	call   *%eax
  80075c:	83 c4 10             	add    $0x10,%esp
}
  80075f:	90                   	nop
  800760:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800763:	c9                   	leave  
  800764:	c3                   	ret    

00800765 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800765:	55                   	push   %ebp
  800766:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800768:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80076c:	7e 1c                	jle    80078a <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80076e:	8b 45 08             	mov    0x8(%ebp),%eax
  800771:	8b 00                	mov    (%eax),%eax
  800773:	8d 50 08             	lea    0x8(%eax),%edx
  800776:	8b 45 08             	mov    0x8(%ebp),%eax
  800779:	89 10                	mov    %edx,(%eax)
  80077b:	8b 45 08             	mov    0x8(%ebp),%eax
  80077e:	8b 00                	mov    (%eax),%eax
  800780:	83 e8 08             	sub    $0x8,%eax
  800783:	8b 50 04             	mov    0x4(%eax),%edx
  800786:	8b 00                	mov    (%eax),%eax
  800788:	eb 40                	jmp    8007ca <getuint+0x65>
	else if (lflag)
  80078a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80078e:	74 1e                	je     8007ae <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800790:	8b 45 08             	mov    0x8(%ebp),%eax
  800793:	8b 00                	mov    (%eax),%eax
  800795:	8d 50 04             	lea    0x4(%eax),%edx
  800798:	8b 45 08             	mov    0x8(%ebp),%eax
  80079b:	89 10                	mov    %edx,(%eax)
  80079d:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a0:	8b 00                	mov    (%eax),%eax
  8007a2:	83 e8 04             	sub    $0x4,%eax
  8007a5:	8b 00                	mov    (%eax),%eax
  8007a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8007ac:	eb 1c                	jmp    8007ca <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8007ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b1:	8b 00                	mov    (%eax),%eax
  8007b3:	8d 50 04             	lea    0x4(%eax),%edx
  8007b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b9:	89 10                	mov    %edx,(%eax)
  8007bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007be:	8b 00                	mov    (%eax),%eax
  8007c0:	83 e8 04             	sub    $0x4,%eax
  8007c3:	8b 00                	mov    (%eax),%eax
  8007c5:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8007ca:	5d                   	pop    %ebp
  8007cb:	c3                   	ret    

008007cc <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007cc:	55                   	push   %ebp
  8007cd:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007cf:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007d3:	7e 1c                	jle    8007f1 <getint+0x25>
		return va_arg(*ap, long long);
  8007d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d8:	8b 00                	mov    (%eax),%eax
  8007da:	8d 50 08             	lea    0x8(%eax),%edx
  8007dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e0:	89 10                	mov    %edx,(%eax)
  8007e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e5:	8b 00                	mov    (%eax),%eax
  8007e7:	83 e8 08             	sub    $0x8,%eax
  8007ea:	8b 50 04             	mov    0x4(%eax),%edx
  8007ed:	8b 00                	mov    (%eax),%eax
  8007ef:	eb 38                	jmp    800829 <getint+0x5d>
	else if (lflag)
  8007f1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007f5:	74 1a                	je     800811 <getint+0x45>
		return va_arg(*ap, long);
  8007f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fa:	8b 00                	mov    (%eax),%eax
  8007fc:	8d 50 04             	lea    0x4(%eax),%edx
  8007ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800802:	89 10                	mov    %edx,(%eax)
  800804:	8b 45 08             	mov    0x8(%ebp),%eax
  800807:	8b 00                	mov    (%eax),%eax
  800809:	83 e8 04             	sub    $0x4,%eax
  80080c:	8b 00                	mov    (%eax),%eax
  80080e:	99                   	cltd   
  80080f:	eb 18                	jmp    800829 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800811:	8b 45 08             	mov    0x8(%ebp),%eax
  800814:	8b 00                	mov    (%eax),%eax
  800816:	8d 50 04             	lea    0x4(%eax),%edx
  800819:	8b 45 08             	mov    0x8(%ebp),%eax
  80081c:	89 10                	mov    %edx,(%eax)
  80081e:	8b 45 08             	mov    0x8(%ebp),%eax
  800821:	8b 00                	mov    (%eax),%eax
  800823:	83 e8 04             	sub    $0x4,%eax
  800826:	8b 00                	mov    (%eax),%eax
  800828:	99                   	cltd   
}
  800829:	5d                   	pop    %ebp
  80082a:	c3                   	ret    

0080082b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80082b:	55                   	push   %ebp
  80082c:	89 e5                	mov    %esp,%ebp
  80082e:	56                   	push   %esi
  80082f:	53                   	push   %ebx
  800830:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800833:	eb 17                	jmp    80084c <vprintfmt+0x21>
			if (ch == '\0')
  800835:	85 db                	test   %ebx,%ebx
  800837:	0f 84 af 03 00 00    	je     800bec <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80083d:	83 ec 08             	sub    $0x8,%esp
  800840:	ff 75 0c             	pushl  0xc(%ebp)
  800843:	53                   	push   %ebx
  800844:	8b 45 08             	mov    0x8(%ebp),%eax
  800847:	ff d0                	call   *%eax
  800849:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80084c:	8b 45 10             	mov    0x10(%ebp),%eax
  80084f:	8d 50 01             	lea    0x1(%eax),%edx
  800852:	89 55 10             	mov    %edx,0x10(%ebp)
  800855:	8a 00                	mov    (%eax),%al
  800857:	0f b6 d8             	movzbl %al,%ebx
  80085a:	83 fb 25             	cmp    $0x25,%ebx
  80085d:	75 d6                	jne    800835 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80085f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800863:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80086a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800871:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800878:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80087f:	8b 45 10             	mov    0x10(%ebp),%eax
  800882:	8d 50 01             	lea    0x1(%eax),%edx
  800885:	89 55 10             	mov    %edx,0x10(%ebp)
  800888:	8a 00                	mov    (%eax),%al
  80088a:	0f b6 d8             	movzbl %al,%ebx
  80088d:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800890:	83 f8 55             	cmp    $0x55,%eax
  800893:	0f 87 2b 03 00 00    	ja     800bc4 <vprintfmt+0x399>
  800899:	8b 04 85 b8 38 80 00 	mov    0x8038b8(,%eax,4),%eax
  8008a0:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8008a2:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8008a6:	eb d7                	jmp    80087f <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008a8:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8008ac:	eb d1                	jmp    80087f <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008ae:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8008b5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008b8:	89 d0                	mov    %edx,%eax
  8008ba:	c1 e0 02             	shl    $0x2,%eax
  8008bd:	01 d0                	add    %edx,%eax
  8008bf:	01 c0                	add    %eax,%eax
  8008c1:	01 d8                	add    %ebx,%eax
  8008c3:	83 e8 30             	sub    $0x30,%eax
  8008c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8008c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8008cc:	8a 00                	mov    (%eax),%al
  8008ce:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8008d1:	83 fb 2f             	cmp    $0x2f,%ebx
  8008d4:	7e 3e                	jle    800914 <vprintfmt+0xe9>
  8008d6:	83 fb 39             	cmp    $0x39,%ebx
  8008d9:	7f 39                	jg     800914 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008db:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008de:	eb d5                	jmp    8008b5 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e3:	83 c0 04             	add    $0x4,%eax
  8008e6:	89 45 14             	mov    %eax,0x14(%ebp)
  8008e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ec:	83 e8 04             	sub    $0x4,%eax
  8008ef:	8b 00                	mov    (%eax),%eax
  8008f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008f4:	eb 1f                	jmp    800915 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008f6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008fa:	79 83                	jns    80087f <vprintfmt+0x54>
				width = 0;
  8008fc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800903:	e9 77 ff ff ff       	jmp    80087f <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800908:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80090f:	e9 6b ff ff ff       	jmp    80087f <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800914:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800915:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800919:	0f 89 60 ff ff ff    	jns    80087f <vprintfmt+0x54>
				width = precision, precision = -1;
  80091f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800922:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800925:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80092c:	e9 4e ff ff ff       	jmp    80087f <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800931:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800934:	e9 46 ff ff ff       	jmp    80087f <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800939:	8b 45 14             	mov    0x14(%ebp),%eax
  80093c:	83 c0 04             	add    $0x4,%eax
  80093f:	89 45 14             	mov    %eax,0x14(%ebp)
  800942:	8b 45 14             	mov    0x14(%ebp),%eax
  800945:	83 e8 04             	sub    $0x4,%eax
  800948:	8b 00                	mov    (%eax),%eax
  80094a:	83 ec 08             	sub    $0x8,%esp
  80094d:	ff 75 0c             	pushl  0xc(%ebp)
  800950:	50                   	push   %eax
  800951:	8b 45 08             	mov    0x8(%ebp),%eax
  800954:	ff d0                	call   *%eax
  800956:	83 c4 10             	add    $0x10,%esp
			break;
  800959:	e9 89 02 00 00       	jmp    800be7 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80095e:	8b 45 14             	mov    0x14(%ebp),%eax
  800961:	83 c0 04             	add    $0x4,%eax
  800964:	89 45 14             	mov    %eax,0x14(%ebp)
  800967:	8b 45 14             	mov    0x14(%ebp),%eax
  80096a:	83 e8 04             	sub    $0x4,%eax
  80096d:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80096f:	85 db                	test   %ebx,%ebx
  800971:	79 02                	jns    800975 <vprintfmt+0x14a>
				err = -err;
  800973:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800975:	83 fb 64             	cmp    $0x64,%ebx
  800978:	7f 0b                	jg     800985 <vprintfmt+0x15a>
  80097a:	8b 34 9d 00 37 80 00 	mov    0x803700(,%ebx,4),%esi
  800981:	85 f6                	test   %esi,%esi
  800983:	75 19                	jne    80099e <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800985:	53                   	push   %ebx
  800986:	68 a5 38 80 00       	push   $0x8038a5
  80098b:	ff 75 0c             	pushl  0xc(%ebp)
  80098e:	ff 75 08             	pushl  0x8(%ebp)
  800991:	e8 5e 02 00 00       	call   800bf4 <printfmt>
  800996:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800999:	e9 49 02 00 00       	jmp    800be7 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80099e:	56                   	push   %esi
  80099f:	68 ae 38 80 00       	push   $0x8038ae
  8009a4:	ff 75 0c             	pushl  0xc(%ebp)
  8009a7:	ff 75 08             	pushl  0x8(%ebp)
  8009aa:	e8 45 02 00 00       	call   800bf4 <printfmt>
  8009af:	83 c4 10             	add    $0x10,%esp
			break;
  8009b2:	e9 30 02 00 00       	jmp    800be7 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8009b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ba:	83 c0 04             	add    $0x4,%eax
  8009bd:	89 45 14             	mov    %eax,0x14(%ebp)
  8009c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c3:	83 e8 04             	sub    $0x4,%eax
  8009c6:	8b 30                	mov    (%eax),%esi
  8009c8:	85 f6                	test   %esi,%esi
  8009ca:	75 05                	jne    8009d1 <vprintfmt+0x1a6>
				p = "(null)";
  8009cc:	be b1 38 80 00       	mov    $0x8038b1,%esi
			if (width > 0 && padc != '-')
  8009d1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009d5:	7e 6d                	jle    800a44 <vprintfmt+0x219>
  8009d7:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8009db:	74 67                	je     800a44 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009e0:	83 ec 08             	sub    $0x8,%esp
  8009e3:	50                   	push   %eax
  8009e4:	56                   	push   %esi
  8009e5:	e8 0c 03 00 00       	call   800cf6 <strnlen>
  8009ea:	83 c4 10             	add    $0x10,%esp
  8009ed:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009f0:	eb 16                	jmp    800a08 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009f2:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009f6:	83 ec 08             	sub    $0x8,%esp
  8009f9:	ff 75 0c             	pushl  0xc(%ebp)
  8009fc:	50                   	push   %eax
  8009fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800a00:	ff d0                	call   *%eax
  800a02:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a05:	ff 4d e4             	decl   -0x1c(%ebp)
  800a08:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a0c:	7f e4                	jg     8009f2 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a0e:	eb 34                	jmp    800a44 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a10:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a14:	74 1c                	je     800a32 <vprintfmt+0x207>
  800a16:	83 fb 1f             	cmp    $0x1f,%ebx
  800a19:	7e 05                	jle    800a20 <vprintfmt+0x1f5>
  800a1b:	83 fb 7e             	cmp    $0x7e,%ebx
  800a1e:	7e 12                	jle    800a32 <vprintfmt+0x207>
					putch('?', putdat);
  800a20:	83 ec 08             	sub    $0x8,%esp
  800a23:	ff 75 0c             	pushl  0xc(%ebp)
  800a26:	6a 3f                	push   $0x3f
  800a28:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2b:	ff d0                	call   *%eax
  800a2d:	83 c4 10             	add    $0x10,%esp
  800a30:	eb 0f                	jmp    800a41 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a32:	83 ec 08             	sub    $0x8,%esp
  800a35:	ff 75 0c             	pushl  0xc(%ebp)
  800a38:	53                   	push   %ebx
  800a39:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3c:	ff d0                	call   *%eax
  800a3e:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a41:	ff 4d e4             	decl   -0x1c(%ebp)
  800a44:	89 f0                	mov    %esi,%eax
  800a46:	8d 70 01             	lea    0x1(%eax),%esi
  800a49:	8a 00                	mov    (%eax),%al
  800a4b:	0f be d8             	movsbl %al,%ebx
  800a4e:	85 db                	test   %ebx,%ebx
  800a50:	74 24                	je     800a76 <vprintfmt+0x24b>
  800a52:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a56:	78 b8                	js     800a10 <vprintfmt+0x1e5>
  800a58:	ff 4d e0             	decl   -0x20(%ebp)
  800a5b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a5f:	79 af                	jns    800a10 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a61:	eb 13                	jmp    800a76 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a63:	83 ec 08             	sub    $0x8,%esp
  800a66:	ff 75 0c             	pushl  0xc(%ebp)
  800a69:	6a 20                	push   $0x20
  800a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6e:	ff d0                	call   *%eax
  800a70:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a73:	ff 4d e4             	decl   -0x1c(%ebp)
  800a76:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a7a:	7f e7                	jg     800a63 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a7c:	e9 66 01 00 00       	jmp    800be7 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a81:	83 ec 08             	sub    $0x8,%esp
  800a84:	ff 75 e8             	pushl  -0x18(%ebp)
  800a87:	8d 45 14             	lea    0x14(%ebp),%eax
  800a8a:	50                   	push   %eax
  800a8b:	e8 3c fd ff ff       	call   8007cc <getint>
  800a90:	83 c4 10             	add    $0x10,%esp
  800a93:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a96:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a9f:	85 d2                	test   %edx,%edx
  800aa1:	79 23                	jns    800ac6 <vprintfmt+0x29b>
				putch('-', putdat);
  800aa3:	83 ec 08             	sub    $0x8,%esp
  800aa6:	ff 75 0c             	pushl  0xc(%ebp)
  800aa9:	6a 2d                	push   $0x2d
  800aab:	8b 45 08             	mov    0x8(%ebp),%eax
  800aae:	ff d0                	call   *%eax
  800ab0:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800ab3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ab6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ab9:	f7 d8                	neg    %eax
  800abb:	83 d2 00             	adc    $0x0,%edx
  800abe:	f7 da                	neg    %edx
  800ac0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ac3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ac6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800acd:	e9 bc 00 00 00       	jmp    800b8e <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ad2:	83 ec 08             	sub    $0x8,%esp
  800ad5:	ff 75 e8             	pushl  -0x18(%ebp)
  800ad8:	8d 45 14             	lea    0x14(%ebp),%eax
  800adb:	50                   	push   %eax
  800adc:	e8 84 fc ff ff       	call   800765 <getuint>
  800ae1:	83 c4 10             	add    $0x10,%esp
  800ae4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ae7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800aea:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800af1:	e9 98 00 00 00       	jmp    800b8e <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800af6:	83 ec 08             	sub    $0x8,%esp
  800af9:	ff 75 0c             	pushl  0xc(%ebp)
  800afc:	6a 58                	push   $0x58
  800afe:	8b 45 08             	mov    0x8(%ebp),%eax
  800b01:	ff d0                	call   *%eax
  800b03:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b06:	83 ec 08             	sub    $0x8,%esp
  800b09:	ff 75 0c             	pushl  0xc(%ebp)
  800b0c:	6a 58                	push   $0x58
  800b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b11:	ff d0                	call   *%eax
  800b13:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b16:	83 ec 08             	sub    $0x8,%esp
  800b19:	ff 75 0c             	pushl  0xc(%ebp)
  800b1c:	6a 58                	push   $0x58
  800b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b21:	ff d0                	call   *%eax
  800b23:	83 c4 10             	add    $0x10,%esp
			break;
  800b26:	e9 bc 00 00 00       	jmp    800be7 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800b2b:	83 ec 08             	sub    $0x8,%esp
  800b2e:	ff 75 0c             	pushl  0xc(%ebp)
  800b31:	6a 30                	push   $0x30
  800b33:	8b 45 08             	mov    0x8(%ebp),%eax
  800b36:	ff d0                	call   *%eax
  800b38:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b3b:	83 ec 08             	sub    $0x8,%esp
  800b3e:	ff 75 0c             	pushl  0xc(%ebp)
  800b41:	6a 78                	push   $0x78
  800b43:	8b 45 08             	mov    0x8(%ebp),%eax
  800b46:	ff d0                	call   *%eax
  800b48:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b4b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b4e:	83 c0 04             	add    $0x4,%eax
  800b51:	89 45 14             	mov    %eax,0x14(%ebp)
  800b54:	8b 45 14             	mov    0x14(%ebp),%eax
  800b57:	83 e8 04             	sub    $0x4,%eax
  800b5a:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b5f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b66:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b6d:	eb 1f                	jmp    800b8e <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b6f:	83 ec 08             	sub    $0x8,%esp
  800b72:	ff 75 e8             	pushl  -0x18(%ebp)
  800b75:	8d 45 14             	lea    0x14(%ebp),%eax
  800b78:	50                   	push   %eax
  800b79:	e8 e7 fb ff ff       	call   800765 <getuint>
  800b7e:	83 c4 10             	add    $0x10,%esp
  800b81:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b84:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b87:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b8e:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b92:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b95:	83 ec 04             	sub    $0x4,%esp
  800b98:	52                   	push   %edx
  800b99:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b9c:	50                   	push   %eax
  800b9d:	ff 75 f4             	pushl  -0xc(%ebp)
  800ba0:	ff 75 f0             	pushl  -0x10(%ebp)
  800ba3:	ff 75 0c             	pushl  0xc(%ebp)
  800ba6:	ff 75 08             	pushl  0x8(%ebp)
  800ba9:	e8 00 fb ff ff       	call   8006ae <printnum>
  800bae:	83 c4 20             	add    $0x20,%esp
			break;
  800bb1:	eb 34                	jmp    800be7 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800bb3:	83 ec 08             	sub    $0x8,%esp
  800bb6:	ff 75 0c             	pushl  0xc(%ebp)
  800bb9:	53                   	push   %ebx
  800bba:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbd:	ff d0                	call   *%eax
  800bbf:	83 c4 10             	add    $0x10,%esp
			break;
  800bc2:	eb 23                	jmp    800be7 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800bc4:	83 ec 08             	sub    $0x8,%esp
  800bc7:	ff 75 0c             	pushl  0xc(%ebp)
  800bca:	6a 25                	push   $0x25
  800bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcf:	ff d0                	call   *%eax
  800bd1:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bd4:	ff 4d 10             	decl   0x10(%ebp)
  800bd7:	eb 03                	jmp    800bdc <vprintfmt+0x3b1>
  800bd9:	ff 4d 10             	decl   0x10(%ebp)
  800bdc:	8b 45 10             	mov    0x10(%ebp),%eax
  800bdf:	48                   	dec    %eax
  800be0:	8a 00                	mov    (%eax),%al
  800be2:	3c 25                	cmp    $0x25,%al
  800be4:	75 f3                	jne    800bd9 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800be6:	90                   	nop
		}
	}
  800be7:	e9 47 fc ff ff       	jmp    800833 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bec:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800bed:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bf0:	5b                   	pop    %ebx
  800bf1:	5e                   	pop    %esi
  800bf2:	5d                   	pop    %ebp
  800bf3:	c3                   	ret    

00800bf4 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bf4:	55                   	push   %ebp
  800bf5:	89 e5                	mov    %esp,%ebp
  800bf7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bfa:	8d 45 10             	lea    0x10(%ebp),%eax
  800bfd:	83 c0 04             	add    $0x4,%eax
  800c00:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c03:	8b 45 10             	mov    0x10(%ebp),%eax
  800c06:	ff 75 f4             	pushl  -0xc(%ebp)
  800c09:	50                   	push   %eax
  800c0a:	ff 75 0c             	pushl  0xc(%ebp)
  800c0d:	ff 75 08             	pushl  0x8(%ebp)
  800c10:	e8 16 fc ff ff       	call   80082b <vprintfmt>
  800c15:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c18:	90                   	nop
  800c19:	c9                   	leave  
  800c1a:	c3                   	ret    

00800c1b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c1b:	55                   	push   %ebp
  800c1c:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c21:	8b 40 08             	mov    0x8(%eax),%eax
  800c24:	8d 50 01             	lea    0x1(%eax),%edx
  800c27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2a:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c30:	8b 10                	mov    (%eax),%edx
  800c32:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c35:	8b 40 04             	mov    0x4(%eax),%eax
  800c38:	39 c2                	cmp    %eax,%edx
  800c3a:	73 12                	jae    800c4e <sprintputch+0x33>
		*b->buf++ = ch;
  800c3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c3f:	8b 00                	mov    (%eax),%eax
  800c41:	8d 48 01             	lea    0x1(%eax),%ecx
  800c44:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c47:	89 0a                	mov    %ecx,(%edx)
  800c49:	8b 55 08             	mov    0x8(%ebp),%edx
  800c4c:	88 10                	mov    %dl,(%eax)
}
  800c4e:	90                   	nop
  800c4f:	5d                   	pop    %ebp
  800c50:	c3                   	ret    

00800c51 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c51:	55                   	push   %ebp
  800c52:	89 e5                	mov    %esp,%ebp
  800c54:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c57:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c60:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c63:	8b 45 08             	mov    0x8(%ebp),%eax
  800c66:	01 d0                	add    %edx,%eax
  800c68:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c6b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c72:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c76:	74 06                	je     800c7e <vsnprintf+0x2d>
  800c78:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c7c:	7f 07                	jg     800c85 <vsnprintf+0x34>
		return -E_INVAL;
  800c7e:	b8 03 00 00 00       	mov    $0x3,%eax
  800c83:	eb 20                	jmp    800ca5 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c85:	ff 75 14             	pushl  0x14(%ebp)
  800c88:	ff 75 10             	pushl  0x10(%ebp)
  800c8b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c8e:	50                   	push   %eax
  800c8f:	68 1b 0c 80 00       	push   $0x800c1b
  800c94:	e8 92 fb ff ff       	call   80082b <vprintfmt>
  800c99:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c9f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ca2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ca5:	c9                   	leave  
  800ca6:	c3                   	ret    

00800ca7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ca7:	55                   	push   %ebp
  800ca8:	89 e5                	mov    %esp,%ebp
  800caa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800cad:	8d 45 10             	lea    0x10(%ebp),%eax
  800cb0:	83 c0 04             	add    $0x4,%eax
  800cb3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800cb6:	8b 45 10             	mov    0x10(%ebp),%eax
  800cb9:	ff 75 f4             	pushl  -0xc(%ebp)
  800cbc:	50                   	push   %eax
  800cbd:	ff 75 0c             	pushl  0xc(%ebp)
  800cc0:	ff 75 08             	pushl  0x8(%ebp)
  800cc3:	e8 89 ff ff ff       	call   800c51 <vsnprintf>
  800cc8:	83 c4 10             	add    $0x10,%esp
  800ccb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800cce:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800cd1:	c9                   	leave  
  800cd2:	c3                   	ret    

00800cd3 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800cd3:	55                   	push   %ebp
  800cd4:	89 e5                	mov    %esp,%ebp
  800cd6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800cd9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ce0:	eb 06                	jmp    800ce8 <strlen+0x15>
		n++;
  800ce2:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ce5:	ff 45 08             	incl   0x8(%ebp)
  800ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ceb:	8a 00                	mov    (%eax),%al
  800ced:	84 c0                	test   %al,%al
  800cef:	75 f1                	jne    800ce2 <strlen+0xf>
		n++;
	return n;
  800cf1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cf4:	c9                   	leave  
  800cf5:	c3                   	ret    

00800cf6 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800cf6:	55                   	push   %ebp
  800cf7:	89 e5                	mov    %esp,%ebp
  800cf9:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cfc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d03:	eb 09                	jmp    800d0e <strnlen+0x18>
		n++;
  800d05:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d08:	ff 45 08             	incl   0x8(%ebp)
  800d0b:	ff 4d 0c             	decl   0xc(%ebp)
  800d0e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d12:	74 09                	je     800d1d <strnlen+0x27>
  800d14:	8b 45 08             	mov    0x8(%ebp),%eax
  800d17:	8a 00                	mov    (%eax),%al
  800d19:	84 c0                	test   %al,%al
  800d1b:	75 e8                	jne    800d05 <strnlen+0xf>
		n++;
	return n;
  800d1d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d20:	c9                   	leave  
  800d21:	c3                   	ret    

00800d22 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d22:	55                   	push   %ebp
  800d23:	89 e5                	mov    %esp,%ebp
  800d25:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d28:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d2e:	90                   	nop
  800d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d32:	8d 50 01             	lea    0x1(%eax),%edx
  800d35:	89 55 08             	mov    %edx,0x8(%ebp)
  800d38:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d3b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d3e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d41:	8a 12                	mov    (%edx),%dl
  800d43:	88 10                	mov    %dl,(%eax)
  800d45:	8a 00                	mov    (%eax),%al
  800d47:	84 c0                	test   %al,%al
  800d49:	75 e4                	jne    800d2f <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d4b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d4e:	c9                   	leave  
  800d4f:	c3                   	ret    

00800d50 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d50:	55                   	push   %ebp
  800d51:	89 e5                	mov    %esp,%ebp
  800d53:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d56:	8b 45 08             	mov    0x8(%ebp),%eax
  800d59:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d5c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d63:	eb 1f                	jmp    800d84 <strncpy+0x34>
		*dst++ = *src;
  800d65:	8b 45 08             	mov    0x8(%ebp),%eax
  800d68:	8d 50 01             	lea    0x1(%eax),%edx
  800d6b:	89 55 08             	mov    %edx,0x8(%ebp)
  800d6e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d71:	8a 12                	mov    (%edx),%dl
  800d73:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d78:	8a 00                	mov    (%eax),%al
  800d7a:	84 c0                	test   %al,%al
  800d7c:	74 03                	je     800d81 <strncpy+0x31>
			src++;
  800d7e:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d81:	ff 45 fc             	incl   -0x4(%ebp)
  800d84:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d87:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d8a:	72 d9                	jb     800d65 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d8c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d8f:	c9                   	leave  
  800d90:	c3                   	ret    

00800d91 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d91:	55                   	push   %ebp
  800d92:	89 e5                	mov    %esp,%ebp
  800d94:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d97:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d9d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800da1:	74 30                	je     800dd3 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800da3:	eb 16                	jmp    800dbb <strlcpy+0x2a>
			*dst++ = *src++;
  800da5:	8b 45 08             	mov    0x8(%ebp),%eax
  800da8:	8d 50 01             	lea    0x1(%eax),%edx
  800dab:	89 55 08             	mov    %edx,0x8(%ebp)
  800dae:	8b 55 0c             	mov    0xc(%ebp),%edx
  800db1:	8d 4a 01             	lea    0x1(%edx),%ecx
  800db4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800db7:	8a 12                	mov    (%edx),%dl
  800db9:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800dbb:	ff 4d 10             	decl   0x10(%ebp)
  800dbe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dc2:	74 09                	je     800dcd <strlcpy+0x3c>
  800dc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc7:	8a 00                	mov    (%eax),%al
  800dc9:	84 c0                	test   %al,%al
  800dcb:	75 d8                	jne    800da5 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd0:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800dd3:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dd9:	29 c2                	sub    %eax,%edx
  800ddb:	89 d0                	mov    %edx,%eax
}
  800ddd:	c9                   	leave  
  800dde:	c3                   	ret    

00800ddf <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ddf:	55                   	push   %ebp
  800de0:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800de2:	eb 06                	jmp    800dea <strcmp+0xb>
		p++, q++;
  800de4:	ff 45 08             	incl   0x8(%ebp)
  800de7:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800dea:	8b 45 08             	mov    0x8(%ebp),%eax
  800ded:	8a 00                	mov    (%eax),%al
  800def:	84 c0                	test   %al,%al
  800df1:	74 0e                	je     800e01 <strcmp+0x22>
  800df3:	8b 45 08             	mov    0x8(%ebp),%eax
  800df6:	8a 10                	mov    (%eax),%dl
  800df8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dfb:	8a 00                	mov    (%eax),%al
  800dfd:	38 c2                	cmp    %al,%dl
  800dff:	74 e3                	je     800de4 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e01:	8b 45 08             	mov    0x8(%ebp),%eax
  800e04:	8a 00                	mov    (%eax),%al
  800e06:	0f b6 d0             	movzbl %al,%edx
  800e09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0c:	8a 00                	mov    (%eax),%al
  800e0e:	0f b6 c0             	movzbl %al,%eax
  800e11:	29 c2                	sub    %eax,%edx
  800e13:	89 d0                	mov    %edx,%eax
}
  800e15:	5d                   	pop    %ebp
  800e16:	c3                   	ret    

00800e17 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e17:	55                   	push   %ebp
  800e18:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e1a:	eb 09                	jmp    800e25 <strncmp+0xe>
		n--, p++, q++;
  800e1c:	ff 4d 10             	decl   0x10(%ebp)
  800e1f:	ff 45 08             	incl   0x8(%ebp)
  800e22:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e25:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e29:	74 17                	je     800e42 <strncmp+0x2b>
  800e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2e:	8a 00                	mov    (%eax),%al
  800e30:	84 c0                	test   %al,%al
  800e32:	74 0e                	je     800e42 <strncmp+0x2b>
  800e34:	8b 45 08             	mov    0x8(%ebp),%eax
  800e37:	8a 10                	mov    (%eax),%dl
  800e39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3c:	8a 00                	mov    (%eax),%al
  800e3e:	38 c2                	cmp    %al,%dl
  800e40:	74 da                	je     800e1c <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e42:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e46:	75 07                	jne    800e4f <strncmp+0x38>
		return 0;
  800e48:	b8 00 00 00 00       	mov    $0x0,%eax
  800e4d:	eb 14                	jmp    800e63 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e52:	8a 00                	mov    (%eax),%al
  800e54:	0f b6 d0             	movzbl %al,%edx
  800e57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5a:	8a 00                	mov    (%eax),%al
  800e5c:	0f b6 c0             	movzbl %al,%eax
  800e5f:	29 c2                	sub    %eax,%edx
  800e61:	89 d0                	mov    %edx,%eax
}
  800e63:	5d                   	pop    %ebp
  800e64:	c3                   	ret    

00800e65 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e65:	55                   	push   %ebp
  800e66:	89 e5                	mov    %esp,%ebp
  800e68:	83 ec 04             	sub    $0x4,%esp
  800e6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e71:	eb 12                	jmp    800e85 <strchr+0x20>
		if (*s == c)
  800e73:	8b 45 08             	mov    0x8(%ebp),%eax
  800e76:	8a 00                	mov    (%eax),%al
  800e78:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e7b:	75 05                	jne    800e82 <strchr+0x1d>
			return (char *) s;
  800e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e80:	eb 11                	jmp    800e93 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e82:	ff 45 08             	incl   0x8(%ebp)
  800e85:	8b 45 08             	mov    0x8(%ebp),%eax
  800e88:	8a 00                	mov    (%eax),%al
  800e8a:	84 c0                	test   %al,%al
  800e8c:	75 e5                	jne    800e73 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e8e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e93:	c9                   	leave  
  800e94:	c3                   	ret    

00800e95 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e95:	55                   	push   %ebp
  800e96:	89 e5                	mov    %esp,%ebp
  800e98:	83 ec 04             	sub    $0x4,%esp
  800e9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ea1:	eb 0d                	jmp    800eb0 <strfind+0x1b>
		if (*s == c)
  800ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea6:	8a 00                	mov    (%eax),%al
  800ea8:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800eab:	74 0e                	je     800ebb <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ead:	ff 45 08             	incl   0x8(%ebp)
  800eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb3:	8a 00                	mov    (%eax),%al
  800eb5:	84 c0                	test   %al,%al
  800eb7:	75 ea                	jne    800ea3 <strfind+0xe>
  800eb9:	eb 01                	jmp    800ebc <strfind+0x27>
		if (*s == c)
			break;
  800ebb:	90                   	nop
	return (char *) s;
  800ebc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ebf:	c9                   	leave  
  800ec0:	c3                   	ret    

00800ec1 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800ec1:	55                   	push   %ebp
  800ec2:	89 e5                	mov    %esp,%ebp
  800ec4:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800ec7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800ecd:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800ed3:	eb 0e                	jmp    800ee3 <memset+0x22>
		*p++ = c;
  800ed5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed8:	8d 50 01             	lea    0x1(%eax),%edx
  800edb:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ede:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ee1:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800ee3:	ff 4d f8             	decl   -0x8(%ebp)
  800ee6:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800eea:	79 e9                	jns    800ed5 <memset+0x14>
		*p++ = c;

	return v;
  800eec:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eef:	c9                   	leave  
  800ef0:	c3                   	ret    

00800ef1 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ef1:	55                   	push   %ebp
  800ef2:	89 e5                	mov    %esp,%ebp
  800ef4:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ef7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800efd:	8b 45 08             	mov    0x8(%ebp),%eax
  800f00:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800f03:	eb 16                	jmp    800f1b <memcpy+0x2a>
		*d++ = *s++;
  800f05:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f08:	8d 50 01             	lea    0x1(%eax),%edx
  800f0b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f0e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f11:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f14:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f17:	8a 12                	mov    (%edx),%dl
  800f19:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f1b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f21:	89 55 10             	mov    %edx,0x10(%ebp)
  800f24:	85 c0                	test   %eax,%eax
  800f26:	75 dd                	jne    800f05 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f28:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f2b:	c9                   	leave  
  800f2c:	c3                   	ret    

00800f2d <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f2d:	55                   	push   %ebp
  800f2e:	89 e5                	mov    %esp,%ebp
  800f30:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f36:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f39:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f3f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f42:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f45:	73 50                	jae    800f97 <memmove+0x6a>
  800f47:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f4a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f4d:	01 d0                	add    %edx,%eax
  800f4f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f52:	76 43                	jbe    800f97 <memmove+0x6a>
		s += n;
  800f54:	8b 45 10             	mov    0x10(%ebp),%eax
  800f57:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f5a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f5d:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f60:	eb 10                	jmp    800f72 <memmove+0x45>
			*--d = *--s;
  800f62:	ff 4d f8             	decl   -0x8(%ebp)
  800f65:	ff 4d fc             	decl   -0x4(%ebp)
  800f68:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f6b:	8a 10                	mov    (%eax),%dl
  800f6d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f70:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f72:	8b 45 10             	mov    0x10(%ebp),%eax
  800f75:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f78:	89 55 10             	mov    %edx,0x10(%ebp)
  800f7b:	85 c0                	test   %eax,%eax
  800f7d:	75 e3                	jne    800f62 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f7f:	eb 23                	jmp    800fa4 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f81:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f84:	8d 50 01             	lea    0x1(%eax),%edx
  800f87:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f8a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f8d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f90:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f93:	8a 12                	mov    (%edx),%dl
  800f95:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f97:	8b 45 10             	mov    0x10(%ebp),%eax
  800f9a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f9d:	89 55 10             	mov    %edx,0x10(%ebp)
  800fa0:	85 c0                	test   %eax,%eax
  800fa2:	75 dd                	jne    800f81 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800fa4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fa7:	c9                   	leave  
  800fa8:	c3                   	ret    

00800fa9 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800fa9:	55                   	push   %ebp
  800faa:	89 e5                	mov    %esp,%ebp
  800fac:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800faf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800fb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb8:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800fbb:	eb 2a                	jmp    800fe7 <memcmp+0x3e>
		if (*s1 != *s2)
  800fbd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fc0:	8a 10                	mov    (%eax),%dl
  800fc2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc5:	8a 00                	mov    (%eax),%al
  800fc7:	38 c2                	cmp    %al,%dl
  800fc9:	74 16                	je     800fe1 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800fcb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fce:	8a 00                	mov    (%eax),%al
  800fd0:	0f b6 d0             	movzbl %al,%edx
  800fd3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fd6:	8a 00                	mov    (%eax),%al
  800fd8:	0f b6 c0             	movzbl %al,%eax
  800fdb:	29 c2                	sub    %eax,%edx
  800fdd:	89 d0                	mov    %edx,%eax
  800fdf:	eb 18                	jmp    800ff9 <memcmp+0x50>
		s1++, s2++;
  800fe1:	ff 45 fc             	incl   -0x4(%ebp)
  800fe4:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800fe7:	8b 45 10             	mov    0x10(%ebp),%eax
  800fea:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fed:	89 55 10             	mov    %edx,0x10(%ebp)
  800ff0:	85 c0                	test   %eax,%eax
  800ff2:	75 c9                	jne    800fbd <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ff4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ff9:	c9                   	leave  
  800ffa:	c3                   	ret    

00800ffb <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800ffb:	55                   	push   %ebp
  800ffc:	89 e5                	mov    %esp,%ebp
  800ffe:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801001:	8b 55 08             	mov    0x8(%ebp),%edx
  801004:	8b 45 10             	mov    0x10(%ebp),%eax
  801007:	01 d0                	add    %edx,%eax
  801009:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80100c:	eb 15                	jmp    801023 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80100e:	8b 45 08             	mov    0x8(%ebp),%eax
  801011:	8a 00                	mov    (%eax),%al
  801013:	0f b6 d0             	movzbl %al,%edx
  801016:	8b 45 0c             	mov    0xc(%ebp),%eax
  801019:	0f b6 c0             	movzbl %al,%eax
  80101c:	39 c2                	cmp    %eax,%edx
  80101e:	74 0d                	je     80102d <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801020:	ff 45 08             	incl   0x8(%ebp)
  801023:	8b 45 08             	mov    0x8(%ebp),%eax
  801026:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801029:	72 e3                	jb     80100e <memfind+0x13>
  80102b:	eb 01                	jmp    80102e <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80102d:	90                   	nop
	return (void *) s;
  80102e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801031:	c9                   	leave  
  801032:	c3                   	ret    

00801033 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801033:	55                   	push   %ebp
  801034:	89 e5                	mov    %esp,%ebp
  801036:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801039:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801040:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801047:	eb 03                	jmp    80104c <strtol+0x19>
		s++;
  801049:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80104c:	8b 45 08             	mov    0x8(%ebp),%eax
  80104f:	8a 00                	mov    (%eax),%al
  801051:	3c 20                	cmp    $0x20,%al
  801053:	74 f4                	je     801049 <strtol+0x16>
  801055:	8b 45 08             	mov    0x8(%ebp),%eax
  801058:	8a 00                	mov    (%eax),%al
  80105a:	3c 09                	cmp    $0x9,%al
  80105c:	74 eb                	je     801049 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80105e:	8b 45 08             	mov    0x8(%ebp),%eax
  801061:	8a 00                	mov    (%eax),%al
  801063:	3c 2b                	cmp    $0x2b,%al
  801065:	75 05                	jne    80106c <strtol+0x39>
		s++;
  801067:	ff 45 08             	incl   0x8(%ebp)
  80106a:	eb 13                	jmp    80107f <strtol+0x4c>
	else if (*s == '-')
  80106c:	8b 45 08             	mov    0x8(%ebp),%eax
  80106f:	8a 00                	mov    (%eax),%al
  801071:	3c 2d                	cmp    $0x2d,%al
  801073:	75 0a                	jne    80107f <strtol+0x4c>
		s++, neg = 1;
  801075:	ff 45 08             	incl   0x8(%ebp)
  801078:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80107f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801083:	74 06                	je     80108b <strtol+0x58>
  801085:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801089:	75 20                	jne    8010ab <strtol+0x78>
  80108b:	8b 45 08             	mov    0x8(%ebp),%eax
  80108e:	8a 00                	mov    (%eax),%al
  801090:	3c 30                	cmp    $0x30,%al
  801092:	75 17                	jne    8010ab <strtol+0x78>
  801094:	8b 45 08             	mov    0x8(%ebp),%eax
  801097:	40                   	inc    %eax
  801098:	8a 00                	mov    (%eax),%al
  80109a:	3c 78                	cmp    $0x78,%al
  80109c:	75 0d                	jne    8010ab <strtol+0x78>
		s += 2, base = 16;
  80109e:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010a2:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8010a9:	eb 28                	jmp    8010d3 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8010ab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010af:	75 15                	jne    8010c6 <strtol+0x93>
  8010b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b4:	8a 00                	mov    (%eax),%al
  8010b6:	3c 30                	cmp    $0x30,%al
  8010b8:	75 0c                	jne    8010c6 <strtol+0x93>
		s++, base = 8;
  8010ba:	ff 45 08             	incl   0x8(%ebp)
  8010bd:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8010c4:	eb 0d                	jmp    8010d3 <strtol+0xa0>
	else if (base == 0)
  8010c6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010ca:	75 07                	jne    8010d3 <strtol+0xa0>
		base = 10;
  8010cc:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d6:	8a 00                	mov    (%eax),%al
  8010d8:	3c 2f                	cmp    $0x2f,%al
  8010da:	7e 19                	jle    8010f5 <strtol+0xc2>
  8010dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010df:	8a 00                	mov    (%eax),%al
  8010e1:	3c 39                	cmp    $0x39,%al
  8010e3:	7f 10                	jg     8010f5 <strtol+0xc2>
			dig = *s - '0';
  8010e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e8:	8a 00                	mov    (%eax),%al
  8010ea:	0f be c0             	movsbl %al,%eax
  8010ed:	83 e8 30             	sub    $0x30,%eax
  8010f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010f3:	eb 42                	jmp    801137 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8010f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f8:	8a 00                	mov    (%eax),%al
  8010fa:	3c 60                	cmp    $0x60,%al
  8010fc:	7e 19                	jle    801117 <strtol+0xe4>
  8010fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801101:	8a 00                	mov    (%eax),%al
  801103:	3c 7a                	cmp    $0x7a,%al
  801105:	7f 10                	jg     801117 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801107:	8b 45 08             	mov    0x8(%ebp),%eax
  80110a:	8a 00                	mov    (%eax),%al
  80110c:	0f be c0             	movsbl %al,%eax
  80110f:	83 e8 57             	sub    $0x57,%eax
  801112:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801115:	eb 20                	jmp    801137 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801117:	8b 45 08             	mov    0x8(%ebp),%eax
  80111a:	8a 00                	mov    (%eax),%al
  80111c:	3c 40                	cmp    $0x40,%al
  80111e:	7e 39                	jle    801159 <strtol+0x126>
  801120:	8b 45 08             	mov    0x8(%ebp),%eax
  801123:	8a 00                	mov    (%eax),%al
  801125:	3c 5a                	cmp    $0x5a,%al
  801127:	7f 30                	jg     801159 <strtol+0x126>
			dig = *s - 'A' + 10;
  801129:	8b 45 08             	mov    0x8(%ebp),%eax
  80112c:	8a 00                	mov    (%eax),%al
  80112e:	0f be c0             	movsbl %al,%eax
  801131:	83 e8 37             	sub    $0x37,%eax
  801134:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801137:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80113a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80113d:	7d 19                	jge    801158 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80113f:	ff 45 08             	incl   0x8(%ebp)
  801142:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801145:	0f af 45 10          	imul   0x10(%ebp),%eax
  801149:	89 c2                	mov    %eax,%edx
  80114b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80114e:	01 d0                	add    %edx,%eax
  801150:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801153:	e9 7b ff ff ff       	jmp    8010d3 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801158:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801159:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80115d:	74 08                	je     801167 <strtol+0x134>
		*endptr = (char *) s;
  80115f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801162:	8b 55 08             	mov    0x8(%ebp),%edx
  801165:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801167:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80116b:	74 07                	je     801174 <strtol+0x141>
  80116d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801170:	f7 d8                	neg    %eax
  801172:	eb 03                	jmp    801177 <strtol+0x144>
  801174:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801177:	c9                   	leave  
  801178:	c3                   	ret    

00801179 <ltostr>:

void
ltostr(long value, char *str)
{
  801179:	55                   	push   %ebp
  80117a:	89 e5                	mov    %esp,%ebp
  80117c:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80117f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801186:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80118d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801191:	79 13                	jns    8011a6 <ltostr+0x2d>
	{
		neg = 1;
  801193:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80119a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119d:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011a0:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8011a3:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8011a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a9:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8011ae:	99                   	cltd   
  8011af:	f7 f9                	idiv   %ecx
  8011b1:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8011b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011b7:	8d 50 01             	lea    0x1(%eax),%edx
  8011ba:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011bd:	89 c2                	mov    %eax,%edx
  8011bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c2:	01 d0                	add    %edx,%eax
  8011c4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011c7:	83 c2 30             	add    $0x30,%edx
  8011ca:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8011cc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011cf:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011d4:	f7 e9                	imul   %ecx
  8011d6:	c1 fa 02             	sar    $0x2,%edx
  8011d9:	89 c8                	mov    %ecx,%eax
  8011db:	c1 f8 1f             	sar    $0x1f,%eax
  8011de:	29 c2                	sub    %eax,%edx
  8011e0:	89 d0                	mov    %edx,%eax
  8011e2:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8011e5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011e8:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011ed:	f7 e9                	imul   %ecx
  8011ef:	c1 fa 02             	sar    $0x2,%edx
  8011f2:	89 c8                	mov    %ecx,%eax
  8011f4:	c1 f8 1f             	sar    $0x1f,%eax
  8011f7:	29 c2                	sub    %eax,%edx
  8011f9:	89 d0                	mov    %edx,%eax
  8011fb:	c1 e0 02             	shl    $0x2,%eax
  8011fe:	01 d0                	add    %edx,%eax
  801200:	01 c0                	add    %eax,%eax
  801202:	29 c1                	sub    %eax,%ecx
  801204:	89 ca                	mov    %ecx,%edx
  801206:	85 d2                	test   %edx,%edx
  801208:	75 9c                	jne    8011a6 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80120a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801211:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801214:	48                   	dec    %eax
  801215:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801218:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80121c:	74 3d                	je     80125b <ltostr+0xe2>
		start = 1 ;
  80121e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801225:	eb 34                	jmp    80125b <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801227:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80122a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122d:	01 d0                	add    %edx,%eax
  80122f:	8a 00                	mov    (%eax),%al
  801231:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801234:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801237:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123a:	01 c2                	add    %eax,%edx
  80123c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80123f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801242:	01 c8                	add    %ecx,%eax
  801244:	8a 00                	mov    (%eax),%al
  801246:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801248:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80124b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124e:	01 c2                	add    %eax,%edx
  801250:	8a 45 eb             	mov    -0x15(%ebp),%al
  801253:	88 02                	mov    %al,(%edx)
		start++ ;
  801255:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801258:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80125b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80125e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801261:	7c c4                	jl     801227 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801263:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801266:	8b 45 0c             	mov    0xc(%ebp),%eax
  801269:	01 d0                	add    %edx,%eax
  80126b:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80126e:	90                   	nop
  80126f:	c9                   	leave  
  801270:	c3                   	ret    

00801271 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801271:	55                   	push   %ebp
  801272:	89 e5                	mov    %esp,%ebp
  801274:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801277:	ff 75 08             	pushl  0x8(%ebp)
  80127a:	e8 54 fa ff ff       	call   800cd3 <strlen>
  80127f:	83 c4 04             	add    $0x4,%esp
  801282:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801285:	ff 75 0c             	pushl  0xc(%ebp)
  801288:	e8 46 fa ff ff       	call   800cd3 <strlen>
  80128d:	83 c4 04             	add    $0x4,%esp
  801290:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801293:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80129a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012a1:	eb 17                	jmp    8012ba <strcconcat+0x49>
		final[s] = str1[s] ;
  8012a3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a9:	01 c2                	add    %eax,%edx
  8012ab:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b1:	01 c8                	add    %ecx,%eax
  8012b3:	8a 00                	mov    (%eax),%al
  8012b5:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012b7:	ff 45 fc             	incl   -0x4(%ebp)
  8012ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012bd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012c0:	7c e1                	jl     8012a3 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012c2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012c9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8012d0:	eb 1f                	jmp    8012f1 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012d5:	8d 50 01             	lea    0x1(%eax),%edx
  8012d8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012db:	89 c2                	mov    %eax,%edx
  8012dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e0:	01 c2                	add    %eax,%edx
  8012e2:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e8:	01 c8                	add    %ecx,%eax
  8012ea:	8a 00                	mov    (%eax),%al
  8012ec:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012ee:	ff 45 f8             	incl   -0x8(%ebp)
  8012f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012f4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012f7:	7c d9                	jl     8012d2 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8012f9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ff:	01 d0                	add    %edx,%eax
  801301:	c6 00 00             	movb   $0x0,(%eax)
}
  801304:	90                   	nop
  801305:	c9                   	leave  
  801306:	c3                   	ret    

00801307 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801307:	55                   	push   %ebp
  801308:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80130a:	8b 45 14             	mov    0x14(%ebp),%eax
  80130d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801313:	8b 45 14             	mov    0x14(%ebp),%eax
  801316:	8b 00                	mov    (%eax),%eax
  801318:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80131f:	8b 45 10             	mov    0x10(%ebp),%eax
  801322:	01 d0                	add    %edx,%eax
  801324:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80132a:	eb 0c                	jmp    801338 <strsplit+0x31>
			*string++ = 0;
  80132c:	8b 45 08             	mov    0x8(%ebp),%eax
  80132f:	8d 50 01             	lea    0x1(%eax),%edx
  801332:	89 55 08             	mov    %edx,0x8(%ebp)
  801335:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801338:	8b 45 08             	mov    0x8(%ebp),%eax
  80133b:	8a 00                	mov    (%eax),%al
  80133d:	84 c0                	test   %al,%al
  80133f:	74 18                	je     801359 <strsplit+0x52>
  801341:	8b 45 08             	mov    0x8(%ebp),%eax
  801344:	8a 00                	mov    (%eax),%al
  801346:	0f be c0             	movsbl %al,%eax
  801349:	50                   	push   %eax
  80134a:	ff 75 0c             	pushl  0xc(%ebp)
  80134d:	e8 13 fb ff ff       	call   800e65 <strchr>
  801352:	83 c4 08             	add    $0x8,%esp
  801355:	85 c0                	test   %eax,%eax
  801357:	75 d3                	jne    80132c <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801359:	8b 45 08             	mov    0x8(%ebp),%eax
  80135c:	8a 00                	mov    (%eax),%al
  80135e:	84 c0                	test   %al,%al
  801360:	74 5a                	je     8013bc <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801362:	8b 45 14             	mov    0x14(%ebp),%eax
  801365:	8b 00                	mov    (%eax),%eax
  801367:	83 f8 0f             	cmp    $0xf,%eax
  80136a:	75 07                	jne    801373 <strsplit+0x6c>
		{
			return 0;
  80136c:	b8 00 00 00 00       	mov    $0x0,%eax
  801371:	eb 66                	jmp    8013d9 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801373:	8b 45 14             	mov    0x14(%ebp),%eax
  801376:	8b 00                	mov    (%eax),%eax
  801378:	8d 48 01             	lea    0x1(%eax),%ecx
  80137b:	8b 55 14             	mov    0x14(%ebp),%edx
  80137e:	89 0a                	mov    %ecx,(%edx)
  801380:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801387:	8b 45 10             	mov    0x10(%ebp),%eax
  80138a:	01 c2                	add    %eax,%edx
  80138c:	8b 45 08             	mov    0x8(%ebp),%eax
  80138f:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801391:	eb 03                	jmp    801396 <strsplit+0x8f>
			string++;
  801393:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801396:	8b 45 08             	mov    0x8(%ebp),%eax
  801399:	8a 00                	mov    (%eax),%al
  80139b:	84 c0                	test   %al,%al
  80139d:	74 8b                	je     80132a <strsplit+0x23>
  80139f:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a2:	8a 00                	mov    (%eax),%al
  8013a4:	0f be c0             	movsbl %al,%eax
  8013a7:	50                   	push   %eax
  8013a8:	ff 75 0c             	pushl  0xc(%ebp)
  8013ab:	e8 b5 fa ff ff       	call   800e65 <strchr>
  8013b0:	83 c4 08             	add    $0x8,%esp
  8013b3:	85 c0                	test   %eax,%eax
  8013b5:	74 dc                	je     801393 <strsplit+0x8c>
			string++;
	}
  8013b7:	e9 6e ff ff ff       	jmp    80132a <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013bc:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8013c0:	8b 00                	mov    (%eax),%eax
  8013c2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8013cc:	01 d0                	add    %edx,%eax
  8013ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013d4:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013d9:	c9                   	leave  
  8013da:	c3                   	ret    

008013db <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8013db:	55                   	push   %ebp
  8013dc:	89 e5                	mov    %esp,%ebp
  8013de:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8013e1:	a1 04 40 80 00       	mov    0x804004,%eax
  8013e6:	85 c0                	test   %eax,%eax
  8013e8:	74 1f                	je     801409 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8013ea:	e8 1d 00 00 00       	call   80140c <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8013ef:	83 ec 0c             	sub    $0xc,%esp
  8013f2:	68 10 3a 80 00       	push   $0x803a10
  8013f7:	e8 55 f2 ff ff       	call   800651 <cprintf>
  8013fc:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8013ff:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801406:	00 00 00 
	}
}
  801409:	90                   	nop
  80140a:	c9                   	leave  
  80140b:	c3                   	ret    

0080140c <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80140c:	55                   	push   %ebp
  80140d:	89 e5                	mov    %esp,%ebp
  80140f:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  801412:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801419:	00 00 00 
  80141c:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801423:	00 00 00 
  801426:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  80142d:	00 00 00 
		LIST_INIT(&AllocMemBlocksList);
  801430:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801437:	00 00 00 
  80143a:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801441:	00 00 00 
  801444:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  80144b:	00 00 00 

		MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES ;
  80144e:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801455:	00 02 00 
		MemBlockNodes =(struct MemBlock*)USER_DYN_BLKS_ARRAY ;
  801458:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  80145f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801462:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801467:	2d 00 10 00 00       	sub    $0x1000,%eax
  80146c:	a3 50 40 80 00       	mov    %eax,0x804050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock),PAGE_SIZE),PERM_USER|PERM_WRITEABLE);
  801471:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801478:	a1 20 41 80 00       	mov    0x804120,%eax
  80147d:	c1 e0 04             	shl    $0x4,%eax
  801480:	89 c2                	mov    %eax,%edx
  801482:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801485:	01 d0                	add    %edx,%eax
  801487:	48                   	dec    %eax
  801488:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80148b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80148e:	ba 00 00 00 00       	mov    $0x0,%edx
  801493:	f7 75 f0             	divl   -0x10(%ebp)
  801496:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801499:	29 d0                	sub    %edx,%eax
  80149b:	89 c2                	mov    %eax,%edx
  80149d:	c7 45 e8 00 00 e0 7f 	movl   $0x7fe00000,-0x18(%ebp)
  8014a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014a7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014ac:	2d 00 10 00 00       	sub    $0x1000,%eax
  8014b1:	83 ec 04             	sub    $0x4,%esp
  8014b4:	6a 06                	push   $0x6
  8014b6:	52                   	push   %edx
  8014b7:	50                   	push   %eax
  8014b8:	e8 71 05 00 00       	call   801a2e <sys_allocate_chunk>
  8014bd:	83 c4 10             	add    $0x10,%esp
		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8014c0:	a1 20 41 80 00       	mov    0x804120,%eax
  8014c5:	83 ec 0c             	sub    $0xc,%esp
  8014c8:	50                   	push   %eax
  8014c9:	e8 e6 0b 00 00       	call   8020b4 <initialize_MemBlocksList>
  8014ce:	83 c4 10             	add    $0x10,%esp

		struct MemBlock  *block_node;
		block_node = AvailableMemBlocksList.lh_first;
  8014d1:	a1 48 41 80 00       	mov    0x804148,%eax
  8014d6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&(AvailableMemBlocksList),block_node);
  8014d9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8014dd:	75 14                	jne    8014f3 <initialize_dyn_block_system+0xe7>
  8014df:	83 ec 04             	sub    $0x4,%esp
  8014e2:	68 35 3a 80 00       	push   $0x803a35
  8014e7:	6a 2b                	push   $0x2b
  8014e9:	68 53 3a 80 00       	push   $0x803a53
  8014ee:	e8 aa ee ff ff       	call   80039d <_panic>
  8014f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014f6:	8b 00                	mov    (%eax),%eax
  8014f8:	85 c0                	test   %eax,%eax
  8014fa:	74 10                	je     80150c <initialize_dyn_block_system+0x100>
  8014fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014ff:	8b 00                	mov    (%eax),%eax
  801501:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801504:	8b 52 04             	mov    0x4(%edx),%edx
  801507:	89 50 04             	mov    %edx,0x4(%eax)
  80150a:	eb 0b                	jmp    801517 <initialize_dyn_block_system+0x10b>
  80150c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80150f:	8b 40 04             	mov    0x4(%eax),%eax
  801512:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801517:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80151a:	8b 40 04             	mov    0x4(%eax),%eax
  80151d:	85 c0                	test   %eax,%eax
  80151f:	74 0f                	je     801530 <initialize_dyn_block_system+0x124>
  801521:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801524:	8b 40 04             	mov    0x4(%eax),%eax
  801527:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80152a:	8b 12                	mov    (%edx),%edx
  80152c:	89 10                	mov    %edx,(%eax)
  80152e:	eb 0a                	jmp    80153a <initialize_dyn_block_system+0x12e>
  801530:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801533:	8b 00                	mov    (%eax),%eax
  801535:	a3 48 41 80 00       	mov    %eax,0x804148
  80153a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80153d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801543:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801546:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80154d:	a1 54 41 80 00       	mov    0x804154,%eax
  801552:	48                   	dec    %eax
  801553:	a3 54 41 80 00       	mov    %eax,0x804154
		block_node->sva = USER_HEAP_START ;
  801558:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80155b:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
		block_node->size = ((USER_HEAP_MAX - USER_HEAP_START));
  801562:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801565:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		insert_sorted_with_merge_freeList(block_node);
  80156c:	83 ec 0c             	sub    $0xc,%esp
  80156f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801572:	e8 d2 13 00 00       	call   802949 <insert_sorted_with_merge_freeList>
  801577:	83 c4 10             	add    $0x10,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  80157a:	90                   	nop
  80157b:	c9                   	leave  
  80157c:	c3                   	ret    

0080157d <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  80157d:	55                   	push   %ebp
  80157e:	89 e5                	mov    %esp,%ebp
  801580:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801583:	e8 53 fe ff ff       	call   8013db <InitializeUHeap>
	if (size == 0) return NULL ;
  801588:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80158c:	75 07                	jne    801595 <malloc+0x18>
  80158e:	b8 00 00 00 00       	mov    $0x0,%eax
  801593:	eb 61                	jmp    8015f6 <malloc+0x79>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	size= ROUNDUP(size,PAGE_SIZE);
  801595:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80159c:	8b 55 08             	mov    0x8(%ebp),%edx
  80159f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015a2:	01 d0                	add    %edx,%eax
  8015a4:	48                   	dec    %eax
  8015a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8015b0:	f7 75 f4             	divl   -0xc(%ebp)
  8015b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015b6:	29 d0                	sub    %edx,%eax
  8015b8:	89 45 08             	mov    %eax,0x8(%ebp)
	    			if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8015bb:	e8 3c 08 00 00       	call   801dfc <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015c0:	85 c0                	test   %eax,%eax
  8015c2:	74 2d                	je     8015f1 <malloc+0x74>
	    			{
	    				struct MemBlock * ff_block = alloc_block_FF(size);
  8015c4:	83 ec 0c             	sub    $0xc,%esp
  8015c7:	ff 75 08             	pushl  0x8(%ebp)
  8015ca:	e8 3e 0f 00 00       	call   80250d <alloc_block_FF>
  8015cf:	83 c4 10             	add    $0x10,%esp
  8015d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    				if(ff_block!=NULL)
  8015d5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8015d9:	74 16                	je     8015f1 <malloc+0x74>
	    				{

	    					insert_sorted_allocList(ff_block);
  8015db:	83 ec 0c             	sub    $0xc,%esp
  8015de:	ff 75 ec             	pushl  -0x14(%ebp)
  8015e1:	e8 48 0c 00 00       	call   80222e <insert_sorted_allocList>
  8015e6:	83 c4 10             	add    $0x10,%esp
	    					return (void*) ff_block->sva ;
  8015e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015ec:	8b 40 08             	mov    0x8(%eax),%eax
  8015ef:	eb 05                	jmp    8015f6 <malloc+0x79>

	    				}
	}
	    			return (void*) NULL ;
  8015f1:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  8015f6:	c9                   	leave  
  8015f7:	c3                   	ret    

008015f8 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8015f8:	55                   	push   %ebp
  8015f9:	89 e5                	mov    %esp,%ebp
  8015fb:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock *elementForEach;
		virtual_address = ROUNDDOWN(virtual_address, PAGE_SIZE);
  8015fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801601:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801604:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801607:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80160c:	89 45 08             	mov    %eax,0x8(%ebp)
	//	if (is_mallocPages[indexindex((uint32) virtual_address)] == 1) {
		elementForEach = find_block(&AllocMemBlocksList,(uint32)virtual_address);
  80160f:	8b 45 08             	mov    0x8(%ebp),%eax
  801612:	83 ec 08             	sub    $0x8,%esp
  801615:	50                   	push   %eax
  801616:	68 40 40 80 00       	push   $0x804040
  80161b:	e8 71 0b 00 00       	call   802191 <find_block>
  801620:	83 c4 10             	add    $0x10,%esp
  801623:	89 45 f0             	mov    %eax,-0x10(%ebp)
		sys_free_user_mem((uint32) virtual_address, elementForEach->size);
  801626:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801629:	8b 50 0c             	mov    0xc(%eax),%edx
  80162c:	8b 45 08             	mov    0x8(%ebp),%eax
  80162f:	83 ec 08             	sub    $0x8,%esp
  801632:	52                   	push   %edx
  801633:	50                   	push   %eax
  801634:	e8 bd 03 00 00       	call   8019f6 <sys_free_user_mem>
  801639:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,elementForEach);
  80163c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801640:	75 14                	jne    801656 <free+0x5e>
  801642:	83 ec 04             	sub    $0x4,%esp
  801645:	68 35 3a 80 00       	push   $0x803a35
  80164a:	6a 71                	push   $0x71
  80164c:	68 53 3a 80 00       	push   $0x803a53
  801651:	e8 47 ed ff ff       	call   80039d <_panic>
  801656:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801659:	8b 00                	mov    (%eax),%eax
  80165b:	85 c0                	test   %eax,%eax
  80165d:	74 10                	je     80166f <free+0x77>
  80165f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801662:	8b 00                	mov    (%eax),%eax
  801664:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801667:	8b 52 04             	mov    0x4(%edx),%edx
  80166a:	89 50 04             	mov    %edx,0x4(%eax)
  80166d:	eb 0b                	jmp    80167a <free+0x82>
  80166f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801672:	8b 40 04             	mov    0x4(%eax),%eax
  801675:	a3 44 40 80 00       	mov    %eax,0x804044
  80167a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80167d:	8b 40 04             	mov    0x4(%eax),%eax
  801680:	85 c0                	test   %eax,%eax
  801682:	74 0f                	je     801693 <free+0x9b>
  801684:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801687:	8b 40 04             	mov    0x4(%eax),%eax
  80168a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80168d:	8b 12                	mov    (%edx),%edx
  80168f:	89 10                	mov    %edx,(%eax)
  801691:	eb 0a                	jmp    80169d <free+0xa5>
  801693:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801696:	8b 00                	mov    (%eax),%eax
  801698:	a3 40 40 80 00       	mov    %eax,0x804040
  80169d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8016a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016a9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8016b0:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8016b5:	48                   	dec    %eax
  8016b6:	a3 4c 40 80 00       	mov    %eax,0x80404c
		insert_sorted_with_merge_freeList(elementForEach);
  8016bb:	83 ec 0c             	sub    $0xc,%esp
  8016be:	ff 75 f0             	pushl  -0x10(%ebp)
  8016c1:	e8 83 12 00 00       	call   802949 <insert_sorted_with_merge_freeList>
  8016c6:	83 c4 10             	add    $0x10,%esp
	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  8016c9:	90                   	nop
  8016ca:	c9                   	leave  
  8016cb:	c3                   	ret    

008016cc <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8016cc:	55                   	push   %ebp
  8016cd:	89 e5                	mov    %esp,%ebp
  8016cf:	83 ec 28             	sub    $0x28,%esp
  8016d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8016d5:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016d8:	e8 fe fc ff ff       	call   8013db <InitializeUHeap>
	if (size == 0) return NULL ;
  8016dd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016e1:	75 0a                	jne    8016ed <smalloc+0x21>
  8016e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8016e8:	e9 86 00 00 00       	jmp    801773 <smalloc+0xa7>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code

	size=ROUNDUP(size,PAGE_SIZE);
  8016ed:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8016f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016fa:	01 d0                	add    %edx,%eax
  8016fc:	48                   	dec    %eax
  8016fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801700:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801703:	ba 00 00 00 00       	mov    $0x0,%edx
  801708:	f7 75 f4             	divl   -0xc(%ebp)
  80170b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80170e:	29 d0                	sub    %edx,%eax
  801710:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801713:	e8 e4 06 00 00       	call   801dfc <sys_isUHeapPlacementStrategyFIRSTFIT>
  801718:	85 c0                	test   %eax,%eax
  80171a:	74 52                	je     80176e <smalloc+0xa2>
		{
		struct MemBlock * ff_block ;
		ff_block = alloc_block_FF(size);
  80171c:	83 ec 0c             	sub    $0xc,%esp
  80171f:	ff 75 0c             	pushl  0xc(%ebp)
  801722:	e8 e6 0d 00 00       	call   80250d <alloc_block_FF>
  801727:	83 c4 10             	add    $0x10,%esp
  80172a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(ff_block==NULL)
  80172d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801731:	75 07                	jne    80173a <smalloc+0x6e>
			return NULL ;
  801733:	b8 00 00 00 00       	mov    $0x0,%eax
  801738:	eb 39                	jmp    801773 <smalloc+0xa7>

		int obj_id =sys_createSharedObject(sharedVarName,size,isWritable,(void*)ff_block->sva);
  80173a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80173d:	8b 40 08             	mov    0x8(%eax),%eax
  801740:	89 c2                	mov    %eax,%edx
  801742:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801746:	52                   	push   %edx
  801747:	50                   	push   %eax
  801748:	ff 75 0c             	pushl  0xc(%ebp)
  80174b:	ff 75 08             	pushl  0x8(%ebp)
  80174e:	e8 2e 04 00 00       	call   801b81 <sys_createSharedObject>
  801753:	83 c4 10             	add    $0x10,%esp
  801756:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(obj_id < 0)
  801759:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80175d:	79 07                	jns    801766 <smalloc+0x9a>
			return (void*)NULL ;
  80175f:	b8 00 00 00 00       	mov    $0x0,%eax
  801764:	eb 0d                	jmp    801773 <smalloc+0xa7>
		else
		    return (void*)ff_block->sva ;
  801766:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801769:	8b 40 08             	mov    0x8(%eax),%eax
  80176c:	eb 05                	jmp    801773 <smalloc+0xa7>
		}
		return (void*)NULL ;
  80176e:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801773:	c9                   	leave  
  801774:	c3                   	ret    

00801775 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801775:	55                   	push   %ebp
  801776:	89 e5                	mov    %esp,%ebp
  801778:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80177b:	e8 5b fc ff ff       	call   8013db <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801780:	83 ec 08             	sub    $0x8,%esp
  801783:	ff 75 0c             	pushl  0xc(%ebp)
  801786:	ff 75 08             	pushl  0x8(%ebp)
  801789:	e8 1d 04 00 00       	call   801bab <sys_getSizeOfSharedObject>
  80178e:	83 c4 10             	add    $0x10,%esp
  801791:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(size == 0)
  801794:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801798:	75 0a                	jne    8017a4 <sget+0x2f>
			return NULL ;
  80179a:	b8 00 00 00 00       	mov    $0x0,%eax
  80179f:	e9 83 00 00 00       	jmp    801827 <sget+0xb2>
		size=ROUNDUP(size,PAGE_SIZE);
  8017a4:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8017ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017b1:	01 d0                	add    %edx,%eax
  8017b3:	48                   	dec    %eax
  8017b4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8017b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8017bf:	f7 75 f0             	divl   -0x10(%ebp)
  8017c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017c5:	29 d0                	sub    %edx,%eax
  8017c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8017ca:	e8 2d 06 00 00       	call   801dfc <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017cf:	85 c0                	test   %eax,%eax
  8017d1:	74 4f                	je     801822 <sget+0xad>
		{
			struct MemBlock * ff_block ;
				ff_block = alloc_block_FF(size);
  8017d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017d6:	83 ec 0c             	sub    $0xc,%esp
  8017d9:	50                   	push   %eax
  8017da:	e8 2e 0d 00 00       	call   80250d <alloc_block_FF>
  8017df:	83 c4 10             	add    $0x10,%esp
  8017e2:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ff_block==NULL)
  8017e5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8017e9:	75 07                	jne    8017f2 <sget+0x7d>
					return (void*)NULL ;
  8017eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8017f0:	eb 35                	jmp    801827 <sget+0xb2>

		int obj_id =sys_getSharedObject((int)ownerEnvID,sharedVarName,(void*)ff_block->sva);
  8017f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017f5:	8b 40 08             	mov    0x8(%eax),%eax
  8017f8:	83 ec 04             	sub    $0x4,%esp
  8017fb:	50                   	push   %eax
  8017fc:	ff 75 0c             	pushl  0xc(%ebp)
  8017ff:	ff 75 08             	pushl  0x8(%ebp)
  801802:	e8 c1 03 00 00       	call   801bc8 <sys_getSharedObject>
  801807:	83 c4 10             	add    $0x10,%esp
  80180a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if(obj_id<0)
  80180d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801811:	79 07                	jns    80181a <sget+0xa5>
				return (void*)NULL ;
  801813:	b8 00 00 00 00       	mov    $0x0,%eax
  801818:	eb 0d                	jmp    801827 <sget+0xb2>
			else
				return (void*)ff_block->sva ;
  80181a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80181d:	8b 40 08             	mov    0x8(%eax),%eax
  801820:	eb 05                	jmp    801827 <sget+0xb2>


		}
	return (void*)NULL ;
  801822:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801827:	c9                   	leave  
  801828:	c3                   	ret    

00801829 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801829:	55                   	push   %ebp
  80182a:	89 e5                	mov    %esp,%ebp
  80182c:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80182f:	e8 a7 fb ff ff       	call   8013db <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801834:	83 ec 04             	sub    $0x4,%esp
  801837:	68 60 3a 80 00       	push   $0x803a60
  80183c:	68 f9 00 00 00       	push   $0xf9
  801841:	68 53 3a 80 00       	push   $0x803a53
  801846:	e8 52 eb ff ff       	call   80039d <_panic>

0080184b <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80184b:	55                   	push   %ebp
  80184c:	89 e5                	mov    %esp,%ebp
  80184e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801851:	83 ec 04             	sub    $0x4,%esp
  801854:	68 88 3a 80 00       	push   $0x803a88
  801859:	68 0d 01 00 00       	push   $0x10d
  80185e:	68 53 3a 80 00       	push   $0x803a53
  801863:	e8 35 eb ff ff       	call   80039d <_panic>

00801868 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801868:	55                   	push   %ebp
  801869:	89 e5                	mov    %esp,%ebp
  80186b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80186e:	83 ec 04             	sub    $0x4,%esp
  801871:	68 ac 3a 80 00       	push   $0x803aac
  801876:	68 18 01 00 00       	push   $0x118
  80187b:	68 53 3a 80 00       	push   $0x803a53
  801880:	e8 18 eb ff ff       	call   80039d <_panic>

00801885 <shrink>:

}
void shrink(uint32 newSize)
{
  801885:	55                   	push   %ebp
  801886:	89 e5                	mov    %esp,%ebp
  801888:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80188b:	83 ec 04             	sub    $0x4,%esp
  80188e:	68 ac 3a 80 00       	push   $0x803aac
  801893:	68 1d 01 00 00       	push   $0x11d
  801898:	68 53 3a 80 00       	push   $0x803a53
  80189d:	e8 fb ea ff ff       	call   80039d <_panic>

008018a2 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8018a2:	55                   	push   %ebp
  8018a3:	89 e5                	mov    %esp,%ebp
  8018a5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018a8:	83 ec 04             	sub    $0x4,%esp
  8018ab:	68 ac 3a 80 00       	push   $0x803aac
  8018b0:	68 22 01 00 00       	push   $0x122
  8018b5:	68 53 3a 80 00       	push   $0x803a53
  8018ba:	e8 de ea ff ff       	call   80039d <_panic>

008018bf <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8018bf:	55                   	push   %ebp
  8018c0:	89 e5                	mov    %esp,%ebp
  8018c2:	57                   	push   %edi
  8018c3:	56                   	push   %esi
  8018c4:	53                   	push   %ebx
  8018c5:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ce:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018d1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018d4:	8b 7d 18             	mov    0x18(%ebp),%edi
  8018d7:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8018da:	cd 30                	int    $0x30
  8018dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8018df:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018e2:	83 c4 10             	add    $0x10,%esp
  8018e5:	5b                   	pop    %ebx
  8018e6:	5e                   	pop    %esi
  8018e7:	5f                   	pop    %edi
  8018e8:	5d                   	pop    %ebp
  8018e9:	c3                   	ret    

008018ea <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8018ea:	55                   	push   %ebp
  8018eb:	89 e5                	mov    %esp,%ebp
  8018ed:	83 ec 04             	sub    $0x4,%esp
  8018f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8018f3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8018f6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fd:	6a 00                	push   $0x0
  8018ff:	6a 00                	push   $0x0
  801901:	52                   	push   %edx
  801902:	ff 75 0c             	pushl  0xc(%ebp)
  801905:	50                   	push   %eax
  801906:	6a 00                	push   $0x0
  801908:	e8 b2 ff ff ff       	call   8018bf <syscall>
  80190d:	83 c4 18             	add    $0x18,%esp
}
  801910:	90                   	nop
  801911:	c9                   	leave  
  801912:	c3                   	ret    

00801913 <sys_cgetc>:

int
sys_cgetc(void)
{
  801913:	55                   	push   %ebp
  801914:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801916:	6a 00                	push   $0x0
  801918:	6a 00                	push   $0x0
  80191a:	6a 00                	push   $0x0
  80191c:	6a 00                	push   $0x0
  80191e:	6a 00                	push   $0x0
  801920:	6a 01                	push   $0x1
  801922:	e8 98 ff ff ff       	call   8018bf <syscall>
  801927:	83 c4 18             	add    $0x18,%esp
}
  80192a:	c9                   	leave  
  80192b:	c3                   	ret    

0080192c <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80192c:	55                   	push   %ebp
  80192d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80192f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801932:	8b 45 08             	mov    0x8(%ebp),%eax
  801935:	6a 00                	push   $0x0
  801937:	6a 00                	push   $0x0
  801939:	6a 00                	push   $0x0
  80193b:	52                   	push   %edx
  80193c:	50                   	push   %eax
  80193d:	6a 05                	push   $0x5
  80193f:	e8 7b ff ff ff       	call   8018bf <syscall>
  801944:	83 c4 18             	add    $0x18,%esp
}
  801947:	c9                   	leave  
  801948:	c3                   	ret    

00801949 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801949:	55                   	push   %ebp
  80194a:	89 e5                	mov    %esp,%ebp
  80194c:	56                   	push   %esi
  80194d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80194e:	8b 75 18             	mov    0x18(%ebp),%esi
  801951:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801954:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801957:	8b 55 0c             	mov    0xc(%ebp),%edx
  80195a:	8b 45 08             	mov    0x8(%ebp),%eax
  80195d:	56                   	push   %esi
  80195e:	53                   	push   %ebx
  80195f:	51                   	push   %ecx
  801960:	52                   	push   %edx
  801961:	50                   	push   %eax
  801962:	6a 06                	push   $0x6
  801964:	e8 56 ff ff ff       	call   8018bf <syscall>
  801969:	83 c4 18             	add    $0x18,%esp
}
  80196c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80196f:	5b                   	pop    %ebx
  801970:	5e                   	pop    %esi
  801971:	5d                   	pop    %ebp
  801972:	c3                   	ret    

00801973 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801973:	55                   	push   %ebp
  801974:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801976:	8b 55 0c             	mov    0xc(%ebp),%edx
  801979:	8b 45 08             	mov    0x8(%ebp),%eax
  80197c:	6a 00                	push   $0x0
  80197e:	6a 00                	push   $0x0
  801980:	6a 00                	push   $0x0
  801982:	52                   	push   %edx
  801983:	50                   	push   %eax
  801984:	6a 07                	push   $0x7
  801986:	e8 34 ff ff ff       	call   8018bf <syscall>
  80198b:	83 c4 18             	add    $0x18,%esp
}
  80198e:	c9                   	leave  
  80198f:	c3                   	ret    

00801990 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801990:	55                   	push   %ebp
  801991:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801993:	6a 00                	push   $0x0
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	ff 75 0c             	pushl  0xc(%ebp)
  80199c:	ff 75 08             	pushl  0x8(%ebp)
  80199f:	6a 08                	push   $0x8
  8019a1:	e8 19 ff ff ff       	call   8018bf <syscall>
  8019a6:	83 c4 18             	add    $0x18,%esp
}
  8019a9:	c9                   	leave  
  8019aa:	c3                   	ret    

008019ab <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8019ab:	55                   	push   %ebp
  8019ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 09                	push   $0x9
  8019ba:	e8 00 ff ff ff       	call   8018bf <syscall>
  8019bf:	83 c4 18             	add    $0x18,%esp
}
  8019c2:	c9                   	leave  
  8019c3:	c3                   	ret    

008019c4 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8019c4:	55                   	push   %ebp
  8019c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 0a                	push   $0xa
  8019d3:	e8 e7 fe ff ff       	call   8018bf <syscall>
  8019d8:	83 c4 18             	add    $0x18,%esp
}
  8019db:	c9                   	leave  
  8019dc:	c3                   	ret    

008019dd <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8019dd:	55                   	push   %ebp
  8019de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 0b                	push   $0xb
  8019ec:	e8 ce fe ff ff       	call   8018bf <syscall>
  8019f1:	83 c4 18             	add    $0x18,%esp
}
  8019f4:	c9                   	leave  
  8019f5:	c3                   	ret    

008019f6 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019f6:	55                   	push   %ebp
  8019f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 00                	push   $0x0
  8019ff:	ff 75 0c             	pushl  0xc(%ebp)
  801a02:	ff 75 08             	pushl  0x8(%ebp)
  801a05:	6a 0f                	push   $0xf
  801a07:	e8 b3 fe ff ff       	call   8018bf <syscall>
  801a0c:	83 c4 18             	add    $0x18,%esp
	return;
  801a0f:	90                   	nop
}
  801a10:	c9                   	leave  
  801a11:	c3                   	ret    

00801a12 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a12:	55                   	push   %ebp
  801a13:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	ff 75 0c             	pushl  0xc(%ebp)
  801a1e:	ff 75 08             	pushl  0x8(%ebp)
  801a21:	6a 10                	push   $0x10
  801a23:	e8 97 fe ff ff       	call   8018bf <syscall>
  801a28:	83 c4 18             	add    $0x18,%esp
	return ;
  801a2b:	90                   	nop
}
  801a2c:	c9                   	leave  
  801a2d:	c3                   	ret    

00801a2e <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a2e:	55                   	push   %ebp
  801a2f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	ff 75 10             	pushl  0x10(%ebp)
  801a38:	ff 75 0c             	pushl  0xc(%ebp)
  801a3b:	ff 75 08             	pushl  0x8(%ebp)
  801a3e:	6a 11                	push   $0x11
  801a40:	e8 7a fe ff ff       	call   8018bf <syscall>
  801a45:	83 c4 18             	add    $0x18,%esp
	return ;
  801a48:	90                   	nop
}
  801a49:	c9                   	leave  
  801a4a:	c3                   	ret    

00801a4b <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a4b:	55                   	push   %ebp
  801a4c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	6a 00                	push   $0x0
  801a58:	6a 0c                	push   $0xc
  801a5a:	e8 60 fe ff ff       	call   8018bf <syscall>
  801a5f:	83 c4 18             	add    $0x18,%esp
}
  801a62:	c9                   	leave  
  801a63:	c3                   	ret    

00801a64 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a64:	55                   	push   %ebp
  801a65:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a67:	6a 00                	push   $0x0
  801a69:	6a 00                	push   $0x0
  801a6b:	6a 00                	push   $0x0
  801a6d:	6a 00                	push   $0x0
  801a6f:	ff 75 08             	pushl  0x8(%ebp)
  801a72:	6a 0d                	push   $0xd
  801a74:	e8 46 fe ff ff       	call   8018bf <syscall>
  801a79:	83 c4 18             	add    $0x18,%esp
}
  801a7c:	c9                   	leave  
  801a7d:	c3                   	ret    

00801a7e <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a7e:	55                   	push   %ebp
  801a7f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	6a 00                	push   $0x0
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 0e                	push   $0xe
  801a8d:	e8 2d fe ff ff       	call   8018bf <syscall>
  801a92:	83 c4 18             	add    $0x18,%esp
}
  801a95:	90                   	nop
  801a96:	c9                   	leave  
  801a97:	c3                   	ret    

00801a98 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a98:	55                   	push   %ebp
  801a99:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 13                	push   $0x13
  801aa7:	e8 13 fe ff ff       	call   8018bf <syscall>
  801aac:	83 c4 18             	add    $0x18,%esp
}
  801aaf:	90                   	nop
  801ab0:	c9                   	leave  
  801ab1:	c3                   	ret    

00801ab2 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801ab2:	55                   	push   %ebp
  801ab3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 00                	push   $0x0
  801abb:	6a 00                	push   $0x0
  801abd:	6a 00                	push   $0x0
  801abf:	6a 14                	push   $0x14
  801ac1:	e8 f9 fd ff ff       	call   8018bf <syscall>
  801ac6:	83 c4 18             	add    $0x18,%esp
}
  801ac9:	90                   	nop
  801aca:	c9                   	leave  
  801acb:	c3                   	ret    

00801acc <sys_cputc>:


void
sys_cputc(const char c)
{
  801acc:	55                   	push   %ebp
  801acd:	89 e5                	mov    %esp,%ebp
  801acf:	83 ec 04             	sub    $0x4,%esp
  801ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801ad8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 00                	push   $0x0
  801ae4:	50                   	push   %eax
  801ae5:	6a 15                	push   $0x15
  801ae7:	e8 d3 fd ff ff       	call   8018bf <syscall>
  801aec:	83 c4 18             	add    $0x18,%esp
}
  801aef:	90                   	nop
  801af0:	c9                   	leave  
  801af1:	c3                   	ret    

00801af2 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801af2:	55                   	push   %ebp
  801af3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	6a 00                	push   $0x0
  801afd:	6a 00                	push   $0x0
  801aff:	6a 16                	push   $0x16
  801b01:	e8 b9 fd ff ff       	call   8018bf <syscall>
  801b06:	83 c4 18             	add    $0x18,%esp
}
  801b09:	90                   	nop
  801b0a:	c9                   	leave  
  801b0b:	c3                   	ret    

00801b0c <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801b0c:	55                   	push   %ebp
  801b0d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b12:	6a 00                	push   $0x0
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	ff 75 0c             	pushl  0xc(%ebp)
  801b1b:	50                   	push   %eax
  801b1c:	6a 17                	push   $0x17
  801b1e:	e8 9c fd ff ff       	call   8018bf <syscall>
  801b23:	83 c4 18             	add    $0x18,%esp
}
  801b26:	c9                   	leave  
  801b27:	c3                   	ret    

00801b28 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b28:	55                   	push   %ebp
  801b29:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	6a 00                	push   $0x0
  801b37:	52                   	push   %edx
  801b38:	50                   	push   %eax
  801b39:	6a 1a                	push   $0x1a
  801b3b:	e8 7f fd ff ff       	call   8018bf <syscall>
  801b40:	83 c4 18             	add    $0x18,%esp
}
  801b43:	c9                   	leave  
  801b44:	c3                   	ret    

00801b45 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b45:	55                   	push   %ebp
  801b46:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b48:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4e:	6a 00                	push   $0x0
  801b50:	6a 00                	push   $0x0
  801b52:	6a 00                	push   $0x0
  801b54:	52                   	push   %edx
  801b55:	50                   	push   %eax
  801b56:	6a 18                	push   $0x18
  801b58:	e8 62 fd ff ff       	call   8018bf <syscall>
  801b5d:	83 c4 18             	add    $0x18,%esp
}
  801b60:	90                   	nop
  801b61:	c9                   	leave  
  801b62:	c3                   	ret    

00801b63 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b63:	55                   	push   %ebp
  801b64:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b66:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b69:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 00                	push   $0x0
  801b72:	52                   	push   %edx
  801b73:	50                   	push   %eax
  801b74:	6a 19                	push   $0x19
  801b76:	e8 44 fd ff ff       	call   8018bf <syscall>
  801b7b:	83 c4 18             	add    $0x18,%esp
}
  801b7e:	90                   	nop
  801b7f:	c9                   	leave  
  801b80:	c3                   	ret    

00801b81 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b81:	55                   	push   %ebp
  801b82:	89 e5                	mov    %esp,%ebp
  801b84:	83 ec 04             	sub    $0x4,%esp
  801b87:	8b 45 10             	mov    0x10(%ebp),%eax
  801b8a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b8d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b90:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b94:	8b 45 08             	mov    0x8(%ebp),%eax
  801b97:	6a 00                	push   $0x0
  801b99:	51                   	push   %ecx
  801b9a:	52                   	push   %edx
  801b9b:	ff 75 0c             	pushl  0xc(%ebp)
  801b9e:	50                   	push   %eax
  801b9f:	6a 1b                	push   $0x1b
  801ba1:	e8 19 fd ff ff       	call   8018bf <syscall>
  801ba6:	83 c4 18             	add    $0x18,%esp
}
  801ba9:	c9                   	leave  
  801baa:	c3                   	ret    

00801bab <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801bab:	55                   	push   %ebp
  801bac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801bae:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 00                	push   $0x0
  801bba:	52                   	push   %edx
  801bbb:	50                   	push   %eax
  801bbc:	6a 1c                	push   $0x1c
  801bbe:	e8 fc fc ff ff       	call   8018bf <syscall>
  801bc3:	83 c4 18             	add    $0x18,%esp
}
  801bc6:	c9                   	leave  
  801bc7:	c3                   	ret    

00801bc8 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801bc8:	55                   	push   %ebp
  801bc9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801bcb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bce:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	51                   	push   %ecx
  801bd9:	52                   	push   %edx
  801bda:	50                   	push   %eax
  801bdb:	6a 1d                	push   $0x1d
  801bdd:	e8 dd fc ff ff       	call   8018bf <syscall>
  801be2:	83 c4 18             	add    $0x18,%esp
}
  801be5:	c9                   	leave  
  801be6:	c3                   	ret    

00801be7 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801be7:	55                   	push   %ebp
  801be8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801bea:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bed:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 00                	push   $0x0
  801bf6:	52                   	push   %edx
  801bf7:	50                   	push   %eax
  801bf8:	6a 1e                	push   $0x1e
  801bfa:	e8 c0 fc ff ff       	call   8018bf <syscall>
  801bff:	83 c4 18             	add    $0x18,%esp
}
  801c02:	c9                   	leave  
  801c03:	c3                   	ret    

00801c04 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801c04:	55                   	push   %ebp
  801c05:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 1f                	push   $0x1f
  801c13:	e8 a7 fc ff ff       	call   8018bf <syscall>
  801c18:	83 c4 18             	add    $0x18,%esp
}
  801c1b:	c9                   	leave  
  801c1c:	c3                   	ret    

00801c1d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c1d:	55                   	push   %ebp
  801c1e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c20:	8b 45 08             	mov    0x8(%ebp),%eax
  801c23:	6a 00                	push   $0x0
  801c25:	ff 75 14             	pushl  0x14(%ebp)
  801c28:	ff 75 10             	pushl  0x10(%ebp)
  801c2b:	ff 75 0c             	pushl  0xc(%ebp)
  801c2e:	50                   	push   %eax
  801c2f:	6a 20                	push   $0x20
  801c31:	e8 89 fc ff ff       	call   8018bf <syscall>
  801c36:	83 c4 18             	add    $0x18,%esp
}
  801c39:	c9                   	leave  
  801c3a:	c3                   	ret    

00801c3b <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c3b:	55                   	push   %ebp
  801c3c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c41:	6a 00                	push   $0x0
  801c43:	6a 00                	push   $0x0
  801c45:	6a 00                	push   $0x0
  801c47:	6a 00                	push   $0x0
  801c49:	50                   	push   %eax
  801c4a:	6a 21                	push   $0x21
  801c4c:	e8 6e fc ff ff       	call   8018bf <syscall>
  801c51:	83 c4 18             	add    $0x18,%esp
}
  801c54:	90                   	nop
  801c55:	c9                   	leave  
  801c56:	c3                   	ret    

00801c57 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c57:	55                   	push   %ebp
  801c58:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 00                	push   $0x0
  801c61:	6a 00                	push   $0x0
  801c63:	6a 00                	push   $0x0
  801c65:	50                   	push   %eax
  801c66:	6a 22                	push   $0x22
  801c68:	e8 52 fc ff ff       	call   8018bf <syscall>
  801c6d:	83 c4 18             	add    $0x18,%esp
}
  801c70:	c9                   	leave  
  801c71:	c3                   	ret    

00801c72 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c72:	55                   	push   %ebp
  801c73:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c75:	6a 00                	push   $0x0
  801c77:	6a 00                	push   $0x0
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 00                	push   $0x0
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 02                	push   $0x2
  801c81:	e8 39 fc ff ff       	call   8018bf <syscall>
  801c86:	83 c4 18             	add    $0x18,%esp
}
  801c89:	c9                   	leave  
  801c8a:	c3                   	ret    

00801c8b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c8b:	55                   	push   %ebp
  801c8c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	6a 00                	push   $0x0
  801c94:	6a 00                	push   $0x0
  801c96:	6a 00                	push   $0x0
  801c98:	6a 03                	push   $0x3
  801c9a:	e8 20 fc ff ff       	call   8018bf <syscall>
  801c9f:	83 c4 18             	add    $0x18,%esp
}
  801ca2:	c9                   	leave  
  801ca3:	c3                   	ret    

00801ca4 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801ca4:	55                   	push   %ebp
  801ca5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801ca7:	6a 00                	push   $0x0
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 00                	push   $0x0
  801cad:	6a 00                	push   $0x0
  801caf:	6a 00                	push   $0x0
  801cb1:	6a 04                	push   $0x4
  801cb3:	e8 07 fc ff ff       	call   8018bf <syscall>
  801cb8:	83 c4 18             	add    $0x18,%esp
}
  801cbb:	c9                   	leave  
  801cbc:	c3                   	ret    

00801cbd <sys_exit_env>:


void sys_exit_env(void)
{
  801cbd:	55                   	push   %ebp
  801cbe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 00                	push   $0x0
  801cc6:	6a 00                	push   $0x0
  801cc8:	6a 00                	push   $0x0
  801cca:	6a 23                	push   $0x23
  801ccc:	e8 ee fb ff ff       	call   8018bf <syscall>
  801cd1:	83 c4 18             	add    $0x18,%esp
}
  801cd4:	90                   	nop
  801cd5:	c9                   	leave  
  801cd6:	c3                   	ret    

00801cd7 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801cd7:	55                   	push   %ebp
  801cd8:	89 e5                	mov    %esp,%ebp
  801cda:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801cdd:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ce0:	8d 50 04             	lea    0x4(%eax),%edx
  801ce3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 00                	push   $0x0
  801cec:	52                   	push   %edx
  801ced:	50                   	push   %eax
  801cee:	6a 24                	push   $0x24
  801cf0:	e8 ca fb ff ff       	call   8018bf <syscall>
  801cf5:	83 c4 18             	add    $0x18,%esp
	return result;
  801cf8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cfb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cfe:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d01:	89 01                	mov    %eax,(%ecx)
  801d03:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d06:	8b 45 08             	mov    0x8(%ebp),%eax
  801d09:	c9                   	leave  
  801d0a:	c2 04 00             	ret    $0x4

00801d0d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d0d:	55                   	push   %ebp
  801d0e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d10:	6a 00                	push   $0x0
  801d12:	6a 00                	push   $0x0
  801d14:	ff 75 10             	pushl  0x10(%ebp)
  801d17:	ff 75 0c             	pushl  0xc(%ebp)
  801d1a:	ff 75 08             	pushl  0x8(%ebp)
  801d1d:	6a 12                	push   $0x12
  801d1f:	e8 9b fb ff ff       	call   8018bf <syscall>
  801d24:	83 c4 18             	add    $0x18,%esp
	return ;
  801d27:	90                   	nop
}
  801d28:	c9                   	leave  
  801d29:	c3                   	ret    

00801d2a <sys_rcr2>:
uint32 sys_rcr2()
{
  801d2a:	55                   	push   %ebp
  801d2b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 00                	push   $0x0
  801d31:	6a 00                	push   $0x0
  801d33:	6a 00                	push   $0x0
  801d35:	6a 00                	push   $0x0
  801d37:	6a 25                	push   $0x25
  801d39:	e8 81 fb ff ff       	call   8018bf <syscall>
  801d3e:	83 c4 18             	add    $0x18,%esp
}
  801d41:	c9                   	leave  
  801d42:	c3                   	ret    

00801d43 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d43:	55                   	push   %ebp
  801d44:	89 e5                	mov    %esp,%ebp
  801d46:	83 ec 04             	sub    $0x4,%esp
  801d49:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d4f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d53:	6a 00                	push   $0x0
  801d55:	6a 00                	push   $0x0
  801d57:	6a 00                	push   $0x0
  801d59:	6a 00                	push   $0x0
  801d5b:	50                   	push   %eax
  801d5c:	6a 26                	push   $0x26
  801d5e:	e8 5c fb ff ff       	call   8018bf <syscall>
  801d63:	83 c4 18             	add    $0x18,%esp
	return ;
  801d66:	90                   	nop
}
  801d67:	c9                   	leave  
  801d68:	c3                   	ret    

00801d69 <rsttst>:
void rsttst()
{
  801d69:	55                   	push   %ebp
  801d6a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 00                	push   $0x0
  801d70:	6a 00                	push   $0x0
  801d72:	6a 00                	push   $0x0
  801d74:	6a 00                	push   $0x0
  801d76:	6a 28                	push   $0x28
  801d78:	e8 42 fb ff ff       	call   8018bf <syscall>
  801d7d:	83 c4 18             	add    $0x18,%esp
	return ;
  801d80:	90                   	nop
}
  801d81:	c9                   	leave  
  801d82:	c3                   	ret    

00801d83 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d83:	55                   	push   %ebp
  801d84:	89 e5                	mov    %esp,%ebp
  801d86:	83 ec 04             	sub    $0x4,%esp
  801d89:	8b 45 14             	mov    0x14(%ebp),%eax
  801d8c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d8f:	8b 55 18             	mov    0x18(%ebp),%edx
  801d92:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d96:	52                   	push   %edx
  801d97:	50                   	push   %eax
  801d98:	ff 75 10             	pushl  0x10(%ebp)
  801d9b:	ff 75 0c             	pushl  0xc(%ebp)
  801d9e:	ff 75 08             	pushl  0x8(%ebp)
  801da1:	6a 27                	push   $0x27
  801da3:	e8 17 fb ff ff       	call   8018bf <syscall>
  801da8:	83 c4 18             	add    $0x18,%esp
	return ;
  801dab:	90                   	nop
}
  801dac:	c9                   	leave  
  801dad:	c3                   	ret    

00801dae <chktst>:
void chktst(uint32 n)
{
  801dae:	55                   	push   %ebp
  801daf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801db1:	6a 00                	push   $0x0
  801db3:	6a 00                	push   $0x0
  801db5:	6a 00                	push   $0x0
  801db7:	6a 00                	push   $0x0
  801db9:	ff 75 08             	pushl  0x8(%ebp)
  801dbc:	6a 29                	push   $0x29
  801dbe:	e8 fc fa ff ff       	call   8018bf <syscall>
  801dc3:	83 c4 18             	add    $0x18,%esp
	return ;
  801dc6:	90                   	nop
}
  801dc7:	c9                   	leave  
  801dc8:	c3                   	ret    

00801dc9 <inctst>:

void inctst()
{
  801dc9:	55                   	push   %ebp
  801dca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801dcc:	6a 00                	push   $0x0
  801dce:	6a 00                	push   $0x0
  801dd0:	6a 00                	push   $0x0
  801dd2:	6a 00                	push   $0x0
  801dd4:	6a 00                	push   $0x0
  801dd6:	6a 2a                	push   $0x2a
  801dd8:	e8 e2 fa ff ff       	call   8018bf <syscall>
  801ddd:	83 c4 18             	add    $0x18,%esp
	return ;
  801de0:	90                   	nop
}
  801de1:	c9                   	leave  
  801de2:	c3                   	ret    

00801de3 <gettst>:
uint32 gettst()
{
  801de3:	55                   	push   %ebp
  801de4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801de6:	6a 00                	push   $0x0
  801de8:	6a 00                	push   $0x0
  801dea:	6a 00                	push   $0x0
  801dec:	6a 00                	push   $0x0
  801dee:	6a 00                	push   $0x0
  801df0:	6a 2b                	push   $0x2b
  801df2:	e8 c8 fa ff ff       	call   8018bf <syscall>
  801df7:	83 c4 18             	add    $0x18,%esp
}
  801dfa:	c9                   	leave  
  801dfb:	c3                   	ret    

00801dfc <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801dfc:	55                   	push   %ebp
  801dfd:	89 e5                	mov    %esp,%ebp
  801dff:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e02:	6a 00                	push   $0x0
  801e04:	6a 00                	push   $0x0
  801e06:	6a 00                	push   $0x0
  801e08:	6a 00                	push   $0x0
  801e0a:	6a 00                	push   $0x0
  801e0c:	6a 2c                	push   $0x2c
  801e0e:	e8 ac fa ff ff       	call   8018bf <syscall>
  801e13:	83 c4 18             	add    $0x18,%esp
  801e16:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e19:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e1d:	75 07                	jne    801e26 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e1f:	b8 01 00 00 00       	mov    $0x1,%eax
  801e24:	eb 05                	jmp    801e2b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e26:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e2b:	c9                   	leave  
  801e2c:	c3                   	ret    

00801e2d <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e2d:	55                   	push   %ebp
  801e2e:	89 e5                	mov    %esp,%ebp
  801e30:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e33:	6a 00                	push   $0x0
  801e35:	6a 00                	push   $0x0
  801e37:	6a 00                	push   $0x0
  801e39:	6a 00                	push   $0x0
  801e3b:	6a 00                	push   $0x0
  801e3d:	6a 2c                	push   $0x2c
  801e3f:	e8 7b fa ff ff       	call   8018bf <syscall>
  801e44:	83 c4 18             	add    $0x18,%esp
  801e47:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e4a:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e4e:	75 07                	jne    801e57 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e50:	b8 01 00 00 00       	mov    $0x1,%eax
  801e55:	eb 05                	jmp    801e5c <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e57:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e5c:	c9                   	leave  
  801e5d:	c3                   	ret    

00801e5e <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e5e:	55                   	push   %ebp
  801e5f:	89 e5                	mov    %esp,%ebp
  801e61:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e64:	6a 00                	push   $0x0
  801e66:	6a 00                	push   $0x0
  801e68:	6a 00                	push   $0x0
  801e6a:	6a 00                	push   $0x0
  801e6c:	6a 00                	push   $0x0
  801e6e:	6a 2c                	push   $0x2c
  801e70:	e8 4a fa ff ff       	call   8018bf <syscall>
  801e75:	83 c4 18             	add    $0x18,%esp
  801e78:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e7b:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e7f:	75 07                	jne    801e88 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e81:	b8 01 00 00 00       	mov    $0x1,%eax
  801e86:	eb 05                	jmp    801e8d <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e88:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e8d:	c9                   	leave  
  801e8e:	c3                   	ret    

00801e8f <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e8f:	55                   	push   %ebp
  801e90:	89 e5                	mov    %esp,%ebp
  801e92:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e95:	6a 00                	push   $0x0
  801e97:	6a 00                	push   $0x0
  801e99:	6a 00                	push   $0x0
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 2c                	push   $0x2c
  801ea1:	e8 19 fa ff ff       	call   8018bf <syscall>
  801ea6:	83 c4 18             	add    $0x18,%esp
  801ea9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801eac:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801eb0:	75 07                	jne    801eb9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801eb2:	b8 01 00 00 00       	mov    $0x1,%eax
  801eb7:	eb 05                	jmp    801ebe <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801eb9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ebe:	c9                   	leave  
  801ebf:	c3                   	ret    

00801ec0 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ec0:	55                   	push   %ebp
  801ec1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ec3:	6a 00                	push   $0x0
  801ec5:	6a 00                	push   $0x0
  801ec7:	6a 00                	push   $0x0
  801ec9:	6a 00                	push   $0x0
  801ecb:	ff 75 08             	pushl  0x8(%ebp)
  801ece:	6a 2d                	push   $0x2d
  801ed0:	e8 ea f9 ff ff       	call   8018bf <syscall>
  801ed5:	83 c4 18             	add    $0x18,%esp
	return ;
  801ed8:	90                   	nop
}
  801ed9:	c9                   	leave  
  801eda:	c3                   	ret    

00801edb <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801edb:	55                   	push   %ebp
  801edc:	89 e5                	mov    %esp,%ebp
  801ede:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801edf:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ee2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ee5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  801eeb:	6a 00                	push   $0x0
  801eed:	53                   	push   %ebx
  801eee:	51                   	push   %ecx
  801eef:	52                   	push   %edx
  801ef0:	50                   	push   %eax
  801ef1:	6a 2e                	push   $0x2e
  801ef3:	e8 c7 f9 ff ff       	call   8018bf <syscall>
  801ef8:	83 c4 18             	add    $0x18,%esp
}
  801efb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801efe:	c9                   	leave  
  801eff:	c3                   	ret    

00801f00 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f00:	55                   	push   %ebp
  801f01:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f03:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f06:	8b 45 08             	mov    0x8(%ebp),%eax
  801f09:	6a 00                	push   $0x0
  801f0b:	6a 00                	push   $0x0
  801f0d:	6a 00                	push   $0x0
  801f0f:	52                   	push   %edx
  801f10:	50                   	push   %eax
  801f11:	6a 2f                	push   $0x2f
  801f13:	e8 a7 f9 ff ff       	call   8018bf <syscall>
  801f18:	83 c4 18             	add    $0x18,%esp
}
  801f1b:	c9                   	leave  
  801f1c:	c3                   	ret    

00801f1d <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801f1d:	55                   	push   %ebp
  801f1e:	89 e5                	mov    %esp,%ebp
  801f20:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801f23:	83 ec 0c             	sub    $0xc,%esp
  801f26:	68 bc 3a 80 00       	push   $0x803abc
  801f2b:	e8 21 e7 ff ff       	call   800651 <cprintf>
  801f30:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801f33:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801f3a:	83 ec 0c             	sub    $0xc,%esp
  801f3d:	68 e8 3a 80 00       	push   $0x803ae8
  801f42:	e8 0a e7 ff ff       	call   800651 <cprintf>
  801f47:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801f4a:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f4e:	a1 38 41 80 00       	mov    0x804138,%eax
  801f53:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f56:	eb 56                	jmp    801fae <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f58:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f5c:	74 1c                	je     801f7a <print_mem_block_lists+0x5d>
  801f5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f61:	8b 50 08             	mov    0x8(%eax),%edx
  801f64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f67:	8b 48 08             	mov    0x8(%eax),%ecx
  801f6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f6d:	8b 40 0c             	mov    0xc(%eax),%eax
  801f70:	01 c8                	add    %ecx,%eax
  801f72:	39 c2                	cmp    %eax,%edx
  801f74:	73 04                	jae    801f7a <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801f76:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7d:	8b 50 08             	mov    0x8(%eax),%edx
  801f80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f83:	8b 40 0c             	mov    0xc(%eax),%eax
  801f86:	01 c2                	add    %eax,%edx
  801f88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8b:	8b 40 08             	mov    0x8(%eax),%eax
  801f8e:	83 ec 04             	sub    $0x4,%esp
  801f91:	52                   	push   %edx
  801f92:	50                   	push   %eax
  801f93:	68 fd 3a 80 00       	push   $0x803afd
  801f98:	e8 b4 e6 ff ff       	call   800651 <cprintf>
  801f9d:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801fa6:	a1 40 41 80 00       	mov    0x804140,%eax
  801fab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fb2:	74 07                	je     801fbb <print_mem_block_lists+0x9e>
  801fb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb7:	8b 00                	mov    (%eax),%eax
  801fb9:	eb 05                	jmp    801fc0 <print_mem_block_lists+0xa3>
  801fbb:	b8 00 00 00 00       	mov    $0x0,%eax
  801fc0:	a3 40 41 80 00       	mov    %eax,0x804140
  801fc5:	a1 40 41 80 00       	mov    0x804140,%eax
  801fca:	85 c0                	test   %eax,%eax
  801fcc:	75 8a                	jne    801f58 <print_mem_block_lists+0x3b>
  801fce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fd2:	75 84                	jne    801f58 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801fd4:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fd8:	75 10                	jne    801fea <print_mem_block_lists+0xcd>
  801fda:	83 ec 0c             	sub    $0xc,%esp
  801fdd:	68 0c 3b 80 00       	push   $0x803b0c
  801fe2:	e8 6a e6 ff ff       	call   800651 <cprintf>
  801fe7:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801fea:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801ff1:	83 ec 0c             	sub    $0xc,%esp
  801ff4:	68 30 3b 80 00       	push   $0x803b30
  801ff9:	e8 53 e6 ff ff       	call   800651 <cprintf>
  801ffe:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802001:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802005:	a1 40 40 80 00       	mov    0x804040,%eax
  80200a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80200d:	eb 56                	jmp    802065 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80200f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802013:	74 1c                	je     802031 <print_mem_block_lists+0x114>
  802015:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802018:	8b 50 08             	mov    0x8(%eax),%edx
  80201b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80201e:	8b 48 08             	mov    0x8(%eax),%ecx
  802021:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802024:	8b 40 0c             	mov    0xc(%eax),%eax
  802027:	01 c8                	add    %ecx,%eax
  802029:	39 c2                	cmp    %eax,%edx
  80202b:	73 04                	jae    802031 <print_mem_block_lists+0x114>
			sorted = 0 ;
  80202d:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802031:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802034:	8b 50 08             	mov    0x8(%eax),%edx
  802037:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80203a:	8b 40 0c             	mov    0xc(%eax),%eax
  80203d:	01 c2                	add    %eax,%edx
  80203f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802042:	8b 40 08             	mov    0x8(%eax),%eax
  802045:	83 ec 04             	sub    $0x4,%esp
  802048:	52                   	push   %edx
  802049:	50                   	push   %eax
  80204a:	68 fd 3a 80 00       	push   $0x803afd
  80204f:	e8 fd e5 ff ff       	call   800651 <cprintf>
  802054:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802057:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80205a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80205d:	a1 48 40 80 00       	mov    0x804048,%eax
  802062:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802065:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802069:	74 07                	je     802072 <print_mem_block_lists+0x155>
  80206b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80206e:	8b 00                	mov    (%eax),%eax
  802070:	eb 05                	jmp    802077 <print_mem_block_lists+0x15a>
  802072:	b8 00 00 00 00       	mov    $0x0,%eax
  802077:	a3 48 40 80 00       	mov    %eax,0x804048
  80207c:	a1 48 40 80 00       	mov    0x804048,%eax
  802081:	85 c0                	test   %eax,%eax
  802083:	75 8a                	jne    80200f <print_mem_block_lists+0xf2>
  802085:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802089:	75 84                	jne    80200f <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80208b:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80208f:	75 10                	jne    8020a1 <print_mem_block_lists+0x184>
  802091:	83 ec 0c             	sub    $0xc,%esp
  802094:	68 48 3b 80 00       	push   $0x803b48
  802099:	e8 b3 e5 ff ff       	call   800651 <cprintf>
  80209e:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8020a1:	83 ec 0c             	sub    $0xc,%esp
  8020a4:	68 bc 3a 80 00       	push   $0x803abc
  8020a9:	e8 a3 e5 ff ff       	call   800651 <cprintf>
  8020ae:	83 c4 10             	add    $0x10,%esp

}
  8020b1:	90                   	nop
  8020b2:	c9                   	leave  
  8020b3:	c3                   	ret    

008020b4 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8020b4:	55                   	push   %ebp
  8020b5:	89 e5                	mov    %esp,%ebp
  8020b7:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  8020ba:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  8020c1:	00 00 00 
  8020c4:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  8020cb:	00 00 00 
  8020ce:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  8020d5:	00 00 00 
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  8020d8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8020df:	e9 9e 00 00 00       	jmp    802182 <initialize_MemBlocksList+0xce>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
  8020e4:	a1 50 40 80 00       	mov    0x804050,%eax
  8020e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020ec:	c1 e2 04             	shl    $0x4,%edx
  8020ef:	01 d0                	add    %edx,%eax
  8020f1:	85 c0                	test   %eax,%eax
  8020f3:	75 14                	jne    802109 <initialize_MemBlocksList+0x55>
  8020f5:	83 ec 04             	sub    $0x4,%esp
  8020f8:	68 70 3b 80 00       	push   $0x803b70
  8020fd:	6a 43                	push   $0x43
  8020ff:	68 93 3b 80 00       	push   $0x803b93
  802104:	e8 94 e2 ff ff       	call   80039d <_panic>
  802109:	a1 50 40 80 00       	mov    0x804050,%eax
  80210e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802111:	c1 e2 04             	shl    $0x4,%edx
  802114:	01 d0                	add    %edx,%eax
  802116:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80211c:	89 10                	mov    %edx,(%eax)
  80211e:	8b 00                	mov    (%eax),%eax
  802120:	85 c0                	test   %eax,%eax
  802122:	74 18                	je     80213c <initialize_MemBlocksList+0x88>
  802124:	a1 48 41 80 00       	mov    0x804148,%eax
  802129:	8b 15 50 40 80 00    	mov    0x804050,%edx
  80212f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802132:	c1 e1 04             	shl    $0x4,%ecx
  802135:	01 ca                	add    %ecx,%edx
  802137:	89 50 04             	mov    %edx,0x4(%eax)
  80213a:	eb 12                	jmp    80214e <initialize_MemBlocksList+0x9a>
  80213c:	a1 50 40 80 00       	mov    0x804050,%eax
  802141:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802144:	c1 e2 04             	shl    $0x4,%edx
  802147:	01 d0                	add    %edx,%eax
  802149:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80214e:	a1 50 40 80 00       	mov    0x804050,%eax
  802153:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802156:	c1 e2 04             	shl    $0x4,%edx
  802159:	01 d0                	add    %edx,%eax
  80215b:	a3 48 41 80 00       	mov    %eax,0x804148
  802160:	a1 50 40 80 00       	mov    0x804050,%eax
  802165:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802168:	c1 e2 04             	shl    $0x4,%edx
  80216b:	01 d0                	add    %edx,%eax
  80216d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802174:	a1 54 41 80 00       	mov    0x804154,%eax
  802179:	40                   	inc    %eax
  80217a:	a3 54 41 80 00       	mov    %eax,0x804154
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  80217f:	ff 45 f4             	incl   -0xc(%ebp)
  802182:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802185:	3b 45 08             	cmp    0x8(%ebp),%eax
  802188:	0f 82 56 ff ff ff    	jb     8020e4 <initialize_MemBlocksList+0x30>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
		}
}
  80218e:	90                   	nop
  80218f:	c9                   	leave  
  802190:	c3                   	ret    

00802191 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802191:	55                   	push   %ebp
  802192:	89 e5                	mov    %esp,%ebp
  802194:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  802197:	a1 38 41 80 00       	mov    0x804138,%eax
  80219c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80219f:	eb 18                	jmp    8021b9 <find_block+0x28>
	{
		if (ele->sva==va)
  8021a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021a4:	8b 40 08             	mov    0x8(%eax),%eax
  8021a7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8021aa:	75 05                	jne    8021b1 <find_block+0x20>
			return ele;
  8021ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021af:	eb 7b                	jmp    80222c <find_block+0x9b>
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  8021b1:	a1 40 41 80 00       	mov    0x804140,%eax
  8021b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021b9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021bd:	74 07                	je     8021c6 <find_block+0x35>
  8021bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021c2:	8b 00                	mov    (%eax),%eax
  8021c4:	eb 05                	jmp    8021cb <find_block+0x3a>
  8021c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8021cb:	a3 40 41 80 00       	mov    %eax,0x804140
  8021d0:	a1 40 41 80 00       	mov    0x804140,%eax
  8021d5:	85 c0                	test   %eax,%eax
  8021d7:	75 c8                	jne    8021a1 <find_block+0x10>
  8021d9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021dd:	75 c2                	jne    8021a1 <find_block+0x10>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  8021df:	a1 40 40 80 00       	mov    0x804040,%eax
  8021e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021e7:	eb 18                	jmp    802201 <find_block+0x70>
	{
		if (ele->sva==va)
  8021e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021ec:	8b 40 08             	mov    0x8(%eax),%eax
  8021ef:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8021f2:	75 05                	jne    8021f9 <find_block+0x68>
					return ele;
  8021f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021f7:	eb 33                	jmp    80222c <find_block+0x9b>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  8021f9:	a1 48 40 80 00       	mov    0x804048,%eax
  8021fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802201:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802205:	74 07                	je     80220e <find_block+0x7d>
  802207:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80220a:	8b 00                	mov    (%eax),%eax
  80220c:	eb 05                	jmp    802213 <find_block+0x82>
  80220e:	b8 00 00 00 00       	mov    $0x0,%eax
  802213:	a3 48 40 80 00       	mov    %eax,0x804048
  802218:	a1 48 40 80 00       	mov    0x804048,%eax
  80221d:	85 c0                	test   %eax,%eax
  80221f:	75 c8                	jne    8021e9 <find_block+0x58>
  802221:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802225:	75 c2                	jne    8021e9 <find_block+0x58>
	{
		if (ele->sva==va)
					return ele;
	}
return NULL;
  802227:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  80222c:	c9                   	leave  
  80222d:	c3                   	ret    

0080222e <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80222e:	55                   	push   %ebp
  80222f:	89 e5                	mov    %esp,%ebp
  802231:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;

int x =LIST_SIZE(&AllocMemBlocksList);
  802234:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802239:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((x==0))
  80223c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802240:	75 62                	jne    8022a4 <insert_sorted_allocList+0x76>
	{
	//	blockToInsert=AllocMemBlocksList.lh_first;
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  802242:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802246:	75 14                	jne    80225c <insert_sorted_allocList+0x2e>
  802248:	83 ec 04             	sub    $0x4,%esp
  80224b:	68 70 3b 80 00       	push   $0x803b70
  802250:	6a 69                	push   $0x69
  802252:	68 93 3b 80 00       	push   $0x803b93
  802257:	e8 41 e1 ff ff       	call   80039d <_panic>
  80225c:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802262:	8b 45 08             	mov    0x8(%ebp),%eax
  802265:	89 10                	mov    %edx,(%eax)
  802267:	8b 45 08             	mov    0x8(%ebp),%eax
  80226a:	8b 00                	mov    (%eax),%eax
  80226c:	85 c0                	test   %eax,%eax
  80226e:	74 0d                	je     80227d <insert_sorted_allocList+0x4f>
  802270:	a1 40 40 80 00       	mov    0x804040,%eax
  802275:	8b 55 08             	mov    0x8(%ebp),%edx
  802278:	89 50 04             	mov    %edx,0x4(%eax)
  80227b:	eb 08                	jmp    802285 <insert_sorted_allocList+0x57>
  80227d:	8b 45 08             	mov    0x8(%ebp),%eax
  802280:	a3 44 40 80 00       	mov    %eax,0x804044
  802285:	8b 45 08             	mov    0x8(%ebp),%eax
  802288:	a3 40 40 80 00       	mov    %eax,0x804040
  80228d:	8b 45 08             	mov    0x8(%ebp),%eax
  802290:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802297:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80229c:	40                   	inc    %eax
  80229d:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8022a2:	eb 72                	jmp    802316 <insert_sorted_allocList+0xe8>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
  8022a4:	a1 40 40 80 00       	mov    0x804040,%eax
  8022a9:	8b 50 08             	mov    0x8(%eax),%edx
  8022ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8022af:	8b 40 08             	mov    0x8(%eax),%eax
  8022b2:	39 c2                	cmp    %eax,%edx
  8022b4:	76 60                	jbe    802316 <insert_sorted_allocList+0xe8>
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  8022b6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022ba:	75 14                	jne    8022d0 <insert_sorted_allocList+0xa2>
  8022bc:	83 ec 04             	sub    $0x4,%esp
  8022bf:	68 70 3b 80 00       	push   $0x803b70
  8022c4:	6a 6d                	push   $0x6d
  8022c6:	68 93 3b 80 00       	push   $0x803b93
  8022cb:	e8 cd e0 ff ff       	call   80039d <_panic>
  8022d0:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8022d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d9:	89 10                	mov    %edx,(%eax)
  8022db:	8b 45 08             	mov    0x8(%ebp),%eax
  8022de:	8b 00                	mov    (%eax),%eax
  8022e0:	85 c0                	test   %eax,%eax
  8022e2:	74 0d                	je     8022f1 <insert_sorted_allocList+0xc3>
  8022e4:	a1 40 40 80 00       	mov    0x804040,%eax
  8022e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8022ec:	89 50 04             	mov    %edx,0x4(%eax)
  8022ef:	eb 08                	jmp    8022f9 <insert_sorted_allocList+0xcb>
  8022f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f4:	a3 44 40 80 00       	mov    %eax,0x804044
  8022f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fc:	a3 40 40 80 00       	mov    %eax,0x804040
  802301:	8b 45 08             	mov    0x8(%ebp),%eax
  802304:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80230b:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802310:	40                   	inc    %eax
  802311:	a3 4c 40 80 00       	mov    %eax,0x80404c
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  802316:	a1 40 40 80 00       	mov    0x804040,%eax
  80231b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80231e:	e9 b9 01 00 00       	jmp    8024dc <insert_sorted_allocList+0x2ae>
	{


		if ((blockToInsert->sva>AllocMemBlocksList.lh_first->sva)&&blockToInsert->sva<element->sva)
  802323:	8b 45 08             	mov    0x8(%ebp),%eax
  802326:	8b 50 08             	mov    0x8(%eax),%edx
  802329:	a1 40 40 80 00       	mov    0x804040,%eax
  80232e:	8b 40 08             	mov    0x8(%eax),%eax
  802331:	39 c2                	cmp    %eax,%edx
  802333:	76 7c                	jbe    8023b1 <insert_sorted_allocList+0x183>
  802335:	8b 45 08             	mov    0x8(%ebp),%eax
  802338:	8b 50 08             	mov    0x8(%eax),%edx
  80233b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233e:	8b 40 08             	mov    0x8(%eax),%eax
  802341:	39 c2                	cmp    %eax,%edx
  802343:	73 6c                	jae    8023b1 <insert_sorted_allocList+0x183>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,element,blockToInsert);
  802345:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802349:	74 06                	je     802351 <insert_sorted_allocList+0x123>
  80234b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80234f:	75 14                	jne    802365 <insert_sorted_allocList+0x137>
  802351:	83 ec 04             	sub    $0x4,%esp
  802354:	68 ac 3b 80 00       	push   $0x803bac
  802359:	6a 75                	push   $0x75
  80235b:	68 93 3b 80 00       	push   $0x803b93
  802360:	e8 38 e0 ff ff       	call   80039d <_panic>
  802365:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802368:	8b 50 04             	mov    0x4(%eax),%edx
  80236b:	8b 45 08             	mov    0x8(%ebp),%eax
  80236e:	89 50 04             	mov    %edx,0x4(%eax)
  802371:	8b 45 08             	mov    0x8(%ebp),%eax
  802374:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802377:	89 10                	mov    %edx,(%eax)
  802379:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237c:	8b 40 04             	mov    0x4(%eax),%eax
  80237f:	85 c0                	test   %eax,%eax
  802381:	74 0d                	je     802390 <insert_sorted_allocList+0x162>
  802383:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802386:	8b 40 04             	mov    0x4(%eax),%eax
  802389:	8b 55 08             	mov    0x8(%ebp),%edx
  80238c:	89 10                	mov    %edx,(%eax)
  80238e:	eb 08                	jmp    802398 <insert_sorted_allocList+0x16a>
  802390:	8b 45 08             	mov    0x8(%ebp),%eax
  802393:	a3 40 40 80 00       	mov    %eax,0x804040
  802398:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239b:	8b 55 08             	mov    0x8(%ebp),%edx
  80239e:	89 50 04             	mov    %edx,0x4(%eax)
  8023a1:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8023a6:	40                   	inc    %eax
  8023a7:	a3 4c 40 80 00       	mov    %eax,0x80404c

		break;}
  8023ac:	e9 59 01 00 00       	jmp    80250a <insert_sorted_allocList+0x2dc>

	else if ((blockToInsert->sva>element->sva)&&(blockToInsert->sva<AllocMemBlocksList.lh_last->sva)&&blockToInsert->sva<LIST_NEXT(element)->sva)
  8023b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b4:	8b 50 08             	mov    0x8(%eax),%edx
  8023b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ba:	8b 40 08             	mov    0x8(%eax),%eax
  8023bd:	39 c2                	cmp    %eax,%edx
  8023bf:	0f 86 98 00 00 00    	jbe    80245d <insert_sorted_allocList+0x22f>
  8023c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c8:	8b 50 08             	mov    0x8(%eax),%edx
  8023cb:	a1 44 40 80 00       	mov    0x804044,%eax
  8023d0:	8b 40 08             	mov    0x8(%eax),%eax
  8023d3:	39 c2                	cmp    %eax,%edx
  8023d5:	0f 83 82 00 00 00    	jae    80245d <insert_sorted_allocList+0x22f>
  8023db:	8b 45 08             	mov    0x8(%ebp),%eax
  8023de:	8b 50 08             	mov    0x8(%eax),%edx
  8023e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e4:	8b 00                	mov    (%eax),%eax
  8023e6:	8b 40 08             	mov    0x8(%eax),%eax
  8023e9:	39 c2                	cmp    %eax,%edx
  8023eb:	73 70                	jae    80245d <insert_sorted_allocList+0x22f>
	{

	LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  8023ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023f1:	74 06                	je     8023f9 <insert_sorted_allocList+0x1cb>
  8023f3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023f7:	75 14                	jne    80240d <insert_sorted_allocList+0x1df>
  8023f9:	83 ec 04             	sub    $0x4,%esp
  8023fc:	68 e4 3b 80 00       	push   $0x803be4
  802401:	6a 7c                	push   $0x7c
  802403:	68 93 3b 80 00       	push   $0x803b93
  802408:	e8 90 df ff ff       	call   80039d <_panic>
  80240d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802410:	8b 10                	mov    (%eax),%edx
  802412:	8b 45 08             	mov    0x8(%ebp),%eax
  802415:	89 10                	mov    %edx,(%eax)
  802417:	8b 45 08             	mov    0x8(%ebp),%eax
  80241a:	8b 00                	mov    (%eax),%eax
  80241c:	85 c0                	test   %eax,%eax
  80241e:	74 0b                	je     80242b <insert_sorted_allocList+0x1fd>
  802420:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802423:	8b 00                	mov    (%eax),%eax
  802425:	8b 55 08             	mov    0x8(%ebp),%edx
  802428:	89 50 04             	mov    %edx,0x4(%eax)
  80242b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242e:	8b 55 08             	mov    0x8(%ebp),%edx
  802431:	89 10                	mov    %edx,(%eax)
  802433:	8b 45 08             	mov    0x8(%ebp),%eax
  802436:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802439:	89 50 04             	mov    %edx,0x4(%eax)
  80243c:	8b 45 08             	mov    0x8(%ebp),%eax
  80243f:	8b 00                	mov    (%eax),%eax
  802441:	85 c0                	test   %eax,%eax
  802443:	75 08                	jne    80244d <insert_sorted_allocList+0x21f>
  802445:	8b 45 08             	mov    0x8(%ebp),%eax
  802448:	a3 44 40 80 00       	mov    %eax,0x804044
  80244d:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802452:	40                   	inc    %eax
  802453:	a3 4c 40 80 00       	mov    %eax,0x80404c
		break;
  802458:	e9 ad 00 00 00       	jmp    80250a <insert_sorted_allocList+0x2dc>
	}else if (blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  80245d:	8b 45 08             	mov    0x8(%ebp),%eax
  802460:	8b 50 08             	mov    0x8(%eax),%edx
  802463:	a1 44 40 80 00       	mov    0x804044,%eax
  802468:	8b 40 08             	mov    0x8(%eax),%eax
  80246b:	39 c2                	cmp    %eax,%edx
  80246d:	76 65                	jbe    8024d4 <insert_sorted_allocList+0x2a6>
	{
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
  80246f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802473:	75 17                	jne    80248c <insert_sorted_allocList+0x25e>
  802475:	83 ec 04             	sub    $0x4,%esp
  802478:	68 18 3c 80 00       	push   $0x803c18
  80247d:	68 80 00 00 00       	push   $0x80
  802482:	68 93 3b 80 00       	push   $0x803b93
  802487:	e8 11 df ff ff       	call   80039d <_panic>
  80248c:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802492:	8b 45 08             	mov    0x8(%ebp),%eax
  802495:	89 50 04             	mov    %edx,0x4(%eax)
  802498:	8b 45 08             	mov    0x8(%ebp),%eax
  80249b:	8b 40 04             	mov    0x4(%eax),%eax
  80249e:	85 c0                	test   %eax,%eax
  8024a0:	74 0c                	je     8024ae <insert_sorted_allocList+0x280>
  8024a2:	a1 44 40 80 00       	mov    0x804044,%eax
  8024a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8024aa:	89 10                	mov    %edx,(%eax)
  8024ac:	eb 08                	jmp    8024b6 <insert_sorted_allocList+0x288>
  8024ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b1:	a3 40 40 80 00       	mov    %eax,0x804040
  8024b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b9:	a3 44 40 80 00       	mov    %eax,0x804044
  8024be:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024c7:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8024cc:	40                   	inc    %eax
  8024cd:	a3 4c 40 80 00       	mov    %eax,0x80404c
		break;
  8024d2:	eb 36                	jmp    80250a <insert_sorted_allocList+0x2dc>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  8024d4:	a1 48 40 80 00       	mov    0x804048,%eax
  8024d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024e0:	74 07                	je     8024e9 <insert_sorted_allocList+0x2bb>
  8024e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e5:	8b 00                	mov    (%eax),%eax
  8024e7:	eb 05                	jmp    8024ee <insert_sorted_allocList+0x2c0>
  8024e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8024ee:	a3 48 40 80 00       	mov    %eax,0x804048
  8024f3:	a1 48 40 80 00       	mov    0x804048,%eax
  8024f8:	85 c0                	test   %eax,%eax
  8024fa:	0f 85 23 fe ff ff    	jne    802323 <insert_sorted_allocList+0xf5>
  802500:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802504:	0f 85 19 fe ff ff    	jne    802323 <insert_sorted_allocList+0xf5>
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
		break;

	}
	}
}
  80250a:	90                   	nop
  80250b:	c9                   	leave  
  80250c:	c3                   	ret    

0080250d <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80250d:	55                   	push   %ebp
  80250e:	89 e5                	mov    %esp,%ebp
  802510:	83 ec 18             	sub    $0x18,%esp
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802513:	a1 38 41 80 00       	mov    0x804138,%eax
  802518:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80251b:	e9 7c 01 00 00       	jmp    80269c <alloc_block_FF+0x18f>
		{
			// case 2
				if(element->size == size)
  802520:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802523:	8b 40 0c             	mov    0xc(%eax),%eax
  802526:	3b 45 08             	cmp    0x8(%ebp),%eax
  802529:	0f 85 90 00 00 00    	jne    8025bf <alloc_block_FF+0xb2>
				{
					tmp_block=element;
  80252f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802532:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,element);
  802535:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802539:	75 17                	jne    802552 <alloc_block_FF+0x45>
  80253b:	83 ec 04             	sub    $0x4,%esp
  80253e:	68 3b 3c 80 00       	push   $0x803c3b
  802543:	68 ba 00 00 00       	push   $0xba
  802548:	68 93 3b 80 00       	push   $0x803b93
  80254d:	e8 4b de ff ff       	call   80039d <_panic>
  802552:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802555:	8b 00                	mov    (%eax),%eax
  802557:	85 c0                	test   %eax,%eax
  802559:	74 10                	je     80256b <alloc_block_FF+0x5e>
  80255b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255e:	8b 00                	mov    (%eax),%eax
  802560:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802563:	8b 52 04             	mov    0x4(%edx),%edx
  802566:	89 50 04             	mov    %edx,0x4(%eax)
  802569:	eb 0b                	jmp    802576 <alloc_block_FF+0x69>
  80256b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256e:	8b 40 04             	mov    0x4(%eax),%eax
  802571:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802576:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802579:	8b 40 04             	mov    0x4(%eax),%eax
  80257c:	85 c0                	test   %eax,%eax
  80257e:	74 0f                	je     80258f <alloc_block_FF+0x82>
  802580:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802583:	8b 40 04             	mov    0x4(%eax),%eax
  802586:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802589:	8b 12                	mov    (%edx),%edx
  80258b:	89 10                	mov    %edx,(%eax)
  80258d:	eb 0a                	jmp    802599 <alloc_block_FF+0x8c>
  80258f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802592:	8b 00                	mov    (%eax),%eax
  802594:	a3 38 41 80 00       	mov    %eax,0x804138
  802599:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025ac:	a1 44 41 80 00       	mov    0x804144,%eax
  8025b1:	48                   	dec    %eax
  8025b2:	a3 44 41 80 00       	mov    %eax,0x804144
					return tmp_block;
  8025b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ba:	e9 10 01 00 00       	jmp    8026cf <alloc_block_FF+0x1c2>
				}
				 // case 3
				else if(element->size > size)
  8025bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c2:	8b 40 0c             	mov    0xc(%eax),%eax
  8025c5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025c8:	0f 86 c6 00 00 00    	jbe    802694 <alloc_block_FF+0x187>
				{
					// the new block are created
					tmp_block = AvailableMemBlocksList.lh_first ;
  8025ce:	a1 48 41 80 00       	mov    0x804148,%eax
  8025d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  8025d6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025da:	75 17                	jne    8025f3 <alloc_block_FF+0xe6>
  8025dc:	83 ec 04             	sub    $0x4,%esp
  8025df:	68 3b 3c 80 00       	push   $0x803c3b
  8025e4:	68 c2 00 00 00       	push   $0xc2
  8025e9:	68 93 3b 80 00       	push   $0x803b93
  8025ee:	e8 aa dd ff ff       	call   80039d <_panic>
  8025f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025f6:	8b 00                	mov    (%eax),%eax
  8025f8:	85 c0                	test   %eax,%eax
  8025fa:	74 10                	je     80260c <alloc_block_FF+0xff>
  8025fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ff:	8b 00                	mov    (%eax),%eax
  802601:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802604:	8b 52 04             	mov    0x4(%edx),%edx
  802607:	89 50 04             	mov    %edx,0x4(%eax)
  80260a:	eb 0b                	jmp    802617 <alloc_block_FF+0x10a>
  80260c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80260f:	8b 40 04             	mov    0x4(%eax),%eax
  802612:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802617:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80261a:	8b 40 04             	mov    0x4(%eax),%eax
  80261d:	85 c0                	test   %eax,%eax
  80261f:	74 0f                	je     802630 <alloc_block_FF+0x123>
  802621:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802624:	8b 40 04             	mov    0x4(%eax),%eax
  802627:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80262a:	8b 12                	mov    (%edx),%edx
  80262c:	89 10                	mov    %edx,(%eax)
  80262e:	eb 0a                	jmp    80263a <alloc_block_FF+0x12d>
  802630:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802633:	8b 00                	mov    (%eax),%eax
  802635:	a3 48 41 80 00       	mov    %eax,0x804148
  80263a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80263d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802643:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802646:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80264d:	a1 54 41 80 00       	mov    0x804154,%eax
  802652:	48                   	dec    %eax
  802653:	a3 54 41 80 00       	mov    %eax,0x804154
					tmp_block->sva=element->sva;
  802658:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265b:	8b 50 08             	mov    0x8(%eax),%edx
  80265e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802661:	89 50 08             	mov    %edx,0x8(%eax)
					tmp_block->size=size;
  802664:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802667:	8b 55 08             	mov    0x8(%ebp),%edx
  80266a:	89 50 0c             	mov    %edx,0xc(%eax)
					//update block with remaining space
					element->size-=size;
  80266d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802670:	8b 40 0c             	mov    0xc(%eax),%eax
  802673:	2b 45 08             	sub    0x8(%ebp),%eax
  802676:	89 c2                	mov    %eax,%edx
  802678:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267b:	89 50 0c             	mov    %edx,0xc(%eax)
					element->sva = element->sva + size;
  80267e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802681:	8b 50 08             	mov    0x8(%eax),%edx
  802684:	8b 45 08             	mov    0x8(%ebp),%eax
  802687:	01 c2                	add    %eax,%edx
  802689:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268c:	89 50 08             	mov    %edx,0x8(%eax)
					// return back the new block
					return tmp_block ;
  80268f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802692:	eb 3b                	jmp    8026cf <alloc_block_FF+0x1c2>
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802694:	a1 40 41 80 00       	mov    0x804140,%eax
  802699:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80269c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026a0:	74 07                	je     8026a9 <alloc_block_FF+0x19c>
  8026a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a5:	8b 00                	mov    (%eax),%eax
  8026a7:	eb 05                	jmp    8026ae <alloc_block_FF+0x1a1>
  8026a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8026ae:	a3 40 41 80 00       	mov    %eax,0x804140
  8026b3:	a1 40 41 80 00       	mov    0x804140,%eax
  8026b8:	85 c0                	test   %eax,%eax
  8026ba:	0f 85 60 fe ff ff    	jne    802520 <alloc_block_FF+0x13>
  8026c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026c4:	0f 85 56 fe ff ff    	jne    802520 <alloc_block_FF+0x13>
					// return back the new block
					return tmp_block ;
				}
		}
		// case 1
	  return NULL ;}
  8026ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8026cf:	c9                   	leave  
  8026d0:	c3                   	ret    

008026d1 <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================

struct MemBlock *alloc_block_BF(uint32 size)
{
  8026d1:	55                   	push   %ebp
  8026d2:	89 e5                	mov    %esp,%ebp
  8026d4:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
  8026d7:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		LIST_FOREACH(element, &(FreeMemBlocksList))
  8026de:	a1 38 41 80 00       	mov    0x804138,%eax
  8026e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026e6:	eb 3a                	jmp    802722 <alloc_block_BF+0x51>
		{
			if(element->size >= size)
  8026e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026eb:	8b 40 0c             	mov    0xc(%eax),%eax
  8026ee:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026f1:	72 27                	jb     80271a <alloc_block_BF+0x49>
			{
				if(best_size==-1)
  8026f3:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8026f7:	75 0b                	jne    802704 <alloc_block_BF+0x33>
					best_size= element->size;
  8026f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8026ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802702:	eb 16                	jmp    80271a <alloc_block_BF+0x49>
				else if(best_size >= element->size)
  802704:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802707:	8b 50 0c             	mov    0xc(%eax),%edx
  80270a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80270d:	39 c2                	cmp    %eax,%edx
  80270f:	77 09                	ja     80271a <alloc_block_BF+0x49>
					best_size=element->size;
  802711:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802714:	8b 40 0c             	mov    0xc(%eax),%eax
  802717:	89 45 f0             	mov    %eax,-0x10(%ebp)

struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  80271a:	a1 40 41 80 00       	mov    0x804140,%eax
  80271f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802722:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802726:	74 07                	je     80272f <alloc_block_BF+0x5e>
  802728:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272b:	8b 00                	mov    (%eax),%eax
  80272d:	eb 05                	jmp    802734 <alloc_block_BF+0x63>
  80272f:	b8 00 00 00 00       	mov    $0x0,%eax
  802734:	a3 40 41 80 00       	mov    %eax,0x804140
  802739:	a1 40 41 80 00       	mov    0x804140,%eax
  80273e:	85 c0                	test   %eax,%eax
  802740:	75 a6                	jne    8026e8 <alloc_block_BF+0x17>
  802742:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802746:	75 a0                	jne    8026e8 <alloc_block_BF+0x17>
					best_size= element->size;
				else if(best_size >= element->size)
					best_size=element->size;
			}
		}
		if(best_size != -1)
  802748:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80274c:	0f 84 d3 01 00 00    	je     802925 <alloc_block_BF+0x254>
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  802752:	a1 38 41 80 00       	mov    0x804138,%eax
  802757:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80275a:	e9 98 01 00 00       	jmp    8028f7 <alloc_block_BF+0x226>
			{
			 if((best_size > size) && (best_size == element->size))
  80275f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802762:	3b 45 08             	cmp    0x8(%ebp),%eax
  802765:	0f 86 da 00 00 00    	jbe    802845 <alloc_block_BF+0x174>
  80276b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276e:	8b 50 0c             	mov    0xc(%eax),%edx
  802771:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802774:	39 c2                	cmp    %eax,%edx
  802776:	0f 85 c9 00 00 00    	jne    802845 <alloc_block_BF+0x174>
			  {
				// the new block are created
			    tmp_block = AvailableMemBlocksList.lh_first ;
  80277c:	a1 48 41 80 00       	mov    0x804148,%eax
  802781:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  802784:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802788:	75 17                	jne    8027a1 <alloc_block_BF+0xd0>
  80278a:	83 ec 04             	sub    $0x4,%esp
  80278d:	68 3b 3c 80 00       	push   $0x803c3b
  802792:	68 ea 00 00 00       	push   $0xea
  802797:	68 93 3b 80 00       	push   $0x803b93
  80279c:	e8 fc db ff ff       	call   80039d <_panic>
  8027a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027a4:	8b 00                	mov    (%eax),%eax
  8027a6:	85 c0                	test   %eax,%eax
  8027a8:	74 10                	je     8027ba <alloc_block_BF+0xe9>
  8027aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027ad:	8b 00                	mov    (%eax),%eax
  8027af:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027b2:	8b 52 04             	mov    0x4(%edx),%edx
  8027b5:	89 50 04             	mov    %edx,0x4(%eax)
  8027b8:	eb 0b                	jmp    8027c5 <alloc_block_BF+0xf4>
  8027ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027bd:	8b 40 04             	mov    0x4(%eax),%eax
  8027c0:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8027c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027c8:	8b 40 04             	mov    0x4(%eax),%eax
  8027cb:	85 c0                	test   %eax,%eax
  8027cd:	74 0f                	je     8027de <alloc_block_BF+0x10d>
  8027cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027d2:	8b 40 04             	mov    0x4(%eax),%eax
  8027d5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027d8:	8b 12                	mov    (%edx),%edx
  8027da:	89 10                	mov    %edx,(%eax)
  8027dc:	eb 0a                	jmp    8027e8 <alloc_block_BF+0x117>
  8027de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027e1:	8b 00                	mov    (%eax),%eax
  8027e3:	a3 48 41 80 00       	mov    %eax,0x804148
  8027e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027f4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027fb:	a1 54 41 80 00       	mov    0x804154,%eax
  802800:	48                   	dec    %eax
  802801:	a3 54 41 80 00       	mov    %eax,0x804154
				tmp_block->sva=element->sva;
  802806:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802809:	8b 50 08             	mov    0x8(%eax),%edx
  80280c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80280f:	89 50 08             	mov    %edx,0x8(%eax)
				tmp_block->size=size;
  802812:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802815:	8b 55 08             	mov    0x8(%ebp),%edx
  802818:	89 50 0c             	mov    %edx,0xc(%eax)
				//update block with remaining space
				element->size-=size;
  80281b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281e:	8b 40 0c             	mov    0xc(%eax),%eax
  802821:	2b 45 08             	sub    0x8(%ebp),%eax
  802824:	89 c2                	mov    %eax,%edx
  802826:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802829:	89 50 0c             	mov    %edx,0xc(%eax)
				element->sva = element->sva + size;
  80282c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282f:	8b 50 08             	mov    0x8(%eax),%edx
  802832:	8b 45 08             	mov    0x8(%ebp),%eax
  802835:	01 c2                	add    %eax,%edx
  802837:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283a:	89 50 08             	mov    %edx,0x8(%eax)
				// return back the new block
				return tmp_block ;
  80283d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802840:	e9 e5 00 00 00       	jmp    80292a <alloc_block_BF+0x259>

			  }
			else if((element->size == best_size)&&(best_size == size))
  802845:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802848:	8b 50 0c             	mov    0xc(%eax),%edx
  80284b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80284e:	39 c2                	cmp    %eax,%edx
  802850:	0f 85 99 00 00 00    	jne    8028ef <alloc_block_BF+0x21e>
  802856:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802859:	3b 45 08             	cmp    0x8(%ebp),%eax
  80285c:	0f 85 8d 00 00 00    	jne    8028ef <alloc_block_BF+0x21e>
			  {
				tmp_block=element;
  802862:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802865:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&FreeMemBlocksList,element);
  802868:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80286c:	75 17                	jne    802885 <alloc_block_BF+0x1b4>
  80286e:	83 ec 04             	sub    $0x4,%esp
  802871:	68 3b 3c 80 00       	push   $0x803c3b
  802876:	68 f7 00 00 00       	push   $0xf7
  80287b:	68 93 3b 80 00       	push   $0x803b93
  802880:	e8 18 db ff ff       	call   80039d <_panic>
  802885:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802888:	8b 00                	mov    (%eax),%eax
  80288a:	85 c0                	test   %eax,%eax
  80288c:	74 10                	je     80289e <alloc_block_BF+0x1cd>
  80288e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802891:	8b 00                	mov    (%eax),%eax
  802893:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802896:	8b 52 04             	mov    0x4(%edx),%edx
  802899:	89 50 04             	mov    %edx,0x4(%eax)
  80289c:	eb 0b                	jmp    8028a9 <alloc_block_BF+0x1d8>
  80289e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a1:	8b 40 04             	mov    0x4(%eax),%eax
  8028a4:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8028a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ac:	8b 40 04             	mov    0x4(%eax),%eax
  8028af:	85 c0                	test   %eax,%eax
  8028b1:	74 0f                	je     8028c2 <alloc_block_BF+0x1f1>
  8028b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b6:	8b 40 04             	mov    0x4(%eax),%eax
  8028b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028bc:	8b 12                	mov    (%edx),%edx
  8028be:	89 10                	mov    %edx,(%eax)
  8028c0:	eb 0a                	jmp    8028cc <alloc_block_BF+0x1fb>
  8028c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c5:	8b 00                	mov    (%eax),%eax
  8028c7:	a3 38 41 80 00       	mov    %eax,0x804138
  8028cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028df:	a1 44 41 80 00       	mov    0x804144,%eax
  8028e4:	48                   	dec    %eax
  8028e5:	a3 44 41 80 00       	mov    %eax,0x804144
				return tmp_block;
  8028ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ed:	eb 3b                	jmp    80292a <alloc_block_BF+0x259>
					best_size=element->size;
			}
		}
		if(best_size != -1)
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  8028ef:	a1 40 41 80 00       	mov    0x804140,%eax
  8028f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028fb:	74 07                	je     802904 <alloc_block_BF+0x233>
  8028fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802900:	8b 00                	mov    (%eax),%eax
  802902:	eb 05                	jmp    802909 <alloc_block_BF+0x238>
  802904:	b8 00 00 00 00       	mov    $0x0,%eax
  802909:	a3 40 41 80 00       	mov    %eax,0x804140
  80290e:	a1 40 41 80 00       	mov    0x804140,%eax
  802913:	85 c0                	test   %eax,%eax
  802915:	0f 85 44 fe ff ff    	jne    80275f <alloc_block_BF+0x8e>
  80291b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80291f:	0f 85 3a fe ff ff    	jne    80275f <alloc_block_BF+0x8e>
				LIST_REMOVE(&FreeMemBlocksList,element);
				return tmp_block;
			 }
			}
		}
		return NULL ;}
  802925:	b8 00 00 00 00       	mov    $0x0,%eax
  80292a:	c9                   	leave  
  80292b:	c3                   	ret    

0080292c <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  80292c:	55                   	push   %ebp
  80292d:	89 e5                	mov    %esp,%ebp
  80292f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802932:	83 ec 04             	sub    $0x4,%esp
  802935:	68 5c 3c 80 00       	push   $0x803c5c
  80293a:	68 04 01 00 00       	push   $0x104
  80293f:	68 93 3b 80 00       	push   $0x803b93
  802944:	e8 54 da ff ff       	call   80039d <_panic>

00802949 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{struct MemBlock * blk_itr;
  802949:	55                   	push   %ebp
  80294a:	89 e5                	mov    %esp,%ebp
  80294c:	83 ec 18             	sub    $0x18,%esp
struct MemBlock * next;
struct MemBlock * first = LIST_FIRST(&(FreeMemBlocksList));
  80294f:	a1 38 41 80 00       	mov    0x804138,%eax
  802954:	89 45 f0             	mov    %eax,-0x10(%ebp)
struct MemBlock * last = LIST_LAST(&(FreeMemBlocksList));
  802957:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80295c:	89 45 ec             	mov    %eax,-0x14(%ebp)

if(LIST_EMPTY(&(FreeMemBlocksList)))
  80295f:	a1 38 41 80 00       	mov    0x804138,%eax
  802964:	85 c0                	test   %eax,%eax
  802966:	75 68                	jne    8029d0 <insert_sorted_with_merge_freeList+0x87>
			{

				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  802968:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80296c:	75 17                	jne    802985 <insert_sorted_with_merge_freeList+0x3c>
  80296e:	83 ec 04             	sub    $0x4,%esp
  802971:	68 70 3b 80 00       	push   $0x803b70
  802976:	68 14 01 00 00       	push   $0x114
  80297b:	68 93 3b 80 00       	push   $0x803b93
  802980:	e8 18 da ff ff       	call   80039d <_panic>
  802985:	8b 15 38 41 80 00    	mov    0x804138,%edx
  80298b:	8b 45 08             	mov    0x8(%ebp),%eax
  80298e:	89 10                	mov    %edx,(%eax)
  802990:	8b 45 08             	mov    0x8(%ebp),%eax
  802993:	8b 00                	mov    (%eax),%eax
  802995:	85 c0                	test   %eax,%eax
  802997:	74 0d                	je     8029a6 <insert_sorted_with_merge_freeList+0x5d>
  802999:	a1 38 41 80 00       	mov    0x804138,%eax
  80299e:	8b 55 08             	mov    0x8(%ebp),%edx
  8029a1:	89 50 04             	mov    %edx,0x4(%eax)
  8029a4:	eb 08                	jmp    8029ae <insert_sorted_with_merge_freeList+0x65>
  8029a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a9:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b1:	a3 38 41 80 00       	mov    %eax,0x804138
  8029b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029c0:	a1 44 41 80 00       	mov    0x804144,%eax
  8029c5:	40                   	inc    %eax
  8029c6:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  8029cb:	e9 d2 06 00 00       	jmp    8030a2 <insert_sorted_with_merge_freeList+0x759>
				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);

			}
else
{
	if( blockToInsert->sva  < first->sva )
  8029d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d3:	8b 50 08             	mov    0x8(%eax),%edx
  8029d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d9:	8b 40 08             	mov    0x8(%eax),%eax
  8029dc:	39 c2                	cmp    %eax,%edx
  8029de:	0f 83 22 01 00 00    	jae    802b06 <insert_sorted_with_merge_freeList+0x1bd>
	{
                if( blockToInsert->sva + blockToInsert->size == first->sva)
  8029e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e7:	8b 50 08             	mov    0x8(%eax),%edx
  8029ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8029f0:	01 c2                	add    %eax,%edx
  8029f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f5:	8b 40 08             	mov    0x8(%eax),%eax
  8029f8:	39 c2                	cmp    %eax,%edx
  8029fa:	0f 85 9e 00 00 00    	jne    802a9e <insert_sorted_with_merge_freeList+0x155>
                {

                	first->sva = blockToInsert->sva;
  802a00:	8b 45 08             	mov    0x8(%ebp),%eax
  802a03:	8b 50 08             	mov    0x8(%eax),%edx
  802a06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a09:	89 50 08             	mov    %edx,0x8(%eax)
                	first->size = first->size + blockToInsert->size;
  802a0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a0f:	8b 50 0c             	mov    0xc(%eax),%edx
  802a12:	8b 45 08             	mov    0x8(%ebp),%eax
  802a15:	8b 40 0c             	mov    0xc(%eax),%eax
  802a18:	01 c2                	add    %eax,%edx
  802a1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a1d:	89 50 0c             	mov    %edx,0xc(%eax)
                	blockToInsert->size = blockToInsert->sva = 0;
  802a20:	8b 45 08             	mov    0x8(%ebp),%eax
  802a23:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802a2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2d:	8b 50 08             	mov    0x8(%eax),%edx
  802a30:	8b 45 08             	mov    0x8(%ebp),%eax
  802a33:	89 50 0c             	mov    %edx,0xc(%eax)
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802a36:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a3a:	75 17                	jne    802a53 <insert_sorted_with_merge_freeList+0x10a>
  802a3c:	83 ec 04             	sub    $0x4,%esp
  802a3f:	68 70 3b 80 00       	push   $0x803b70
  802a44:	68 21 01 00 00       	push   $0x121
  802a49:	68 93 3b 80 00       	push   $0x803b93
  802a4e:	e8 4a d9 ff ff       	call   80039d <_panic>
  802a53:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802a59:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5c:	89 10                	mov    %edx,(%eax)
  802a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a61:	8b 00                	mov    (%eax),%eax
  802a63:	85 c0                	test   %eax,%eax
  802a65:	74 0d                	je     802a74 <insert_sorted_with_merge_freeList+0x12b>
  802a67:	a1 48 41 80 00       	mov    0x804148,%eax
  802a6c:	8b 55 08             	mov    0x8(%ebp),%edx
  802a6f:	89 50 04             	mov    %edx,0x4(%eax)
  802a72:	eb 08                	jmp    802a7c <insert_sorted_with_merge_freeList+0x133>
  802a74:	8b 45 08             	mov    0x8(%ebp),%eax
  802a77:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7f:	a3 48 41 80 00       	mov    %eax,0x804148
  802a84:	8b 45 08             	mov    0x8(%ebp),%eax
  802a87:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a8e:	a1 54 41 80 00       	mov    0x804154,%eax
  802a93:	40                   	inc    %eax
  802a94:	a3 54 41 80 00       	mov    %eax,0x804154
						}
				}
        }

}
}
  802a99:	e9 04 06 00 00       	jmp    8030a2 <insert_sorted_with_merge_freeList+0x759>
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
                }

                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  802a9e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802aa2:	75 17                	jne    802abb <insert_sorted_with_merge_freeList+0x172>
  802aa4:	83 ec 04             	sub    $0x4,%esp
  802aa7:	68 70 3b 80 00       	push   $0x803b70
  802aac:	68 26 01 00 00       	push   $0x126
  802ab1:	68 93 3b 80 00       	push   $0x803b93
  802ab6:	e8 e2 d8 ff ff       	call   80039d <_panic>
  802abb:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac4:	89 10                	mov    %edx,(%eax)
  802ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac9:	8b 00                	mov    (%eax),%eax
  802acb:	85 c0                	test   %eax,%eax
  802acd:	74 0d                	je     802adc <insert_sorted_with_merge_freeList+0x193>
  802acf:	a1 38 41 80 00       	mov    0x804138,%eax
  802ad4:	8b 55 08             	mov    0x8(%ebp),%edx
  802ad7:	89 50 04             	mov    %edx,0x4(%eax)
  802ada:	eb 08                	jmp    802ae4 <insert_sorted_with_merge_freeList+0x19b>
  802adc:	8b 45 08             	mov    0x8(%ebp),%eax
  802adf:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ae4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae7:	a3 38 41 80 00       	mov    %eax,0x804138
  802aec:	8b 45 08             	mov    0x8(%ebp),%eax
  802aef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802af6:	a1 44 41 80 00       	mov    0x804144,%eax
  802afb:	40                   	inc    %eax
  802afc:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  802b01:	e9 9c 05 00 00       	jmp    8030a2 <insert_sorted_with_merge_freeList+0x759>
                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
                }
	}
    else if(blockToInsert->sva > last->sva)
  802b06:	8b 45 08             	mov    0x8(%ebp),%eax
  802b09:	8b 50 08             	mov    0x8(%eax),%edx
  802b0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b0f:	8b 40 08             	mov    0x8(%eax),%eax
  802b12:	39 c2                	cmp    %eax,%edx
  802b14:	0f 86 16 01 00 00    	jbe    802c30 <insert_sorted_with_merge_freeList+0x2e7>
 	{

				if(last->sva + last->size == blockToInsert->sva)
  802b1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b1d:	8b 50 08             	mov    0x8(%eax),%edx
  802b20:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b23:	8b 40 0c             	mov    0xc(%eax),%eax
  802b26:	01 c2                	add    %eax,%edx
  802b28:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2b:	8b 40 08             	mov    0x8(%eax),%eax
  802b2e:	39 c2                	cmp    %eax,%edx
  802b30:	0f 85 92 00 00 00    	jne    802bc8 <insert_sorted_with_merge_freeList+0x27f>
				{

					last->size = last->size + blockToInsert->size;
  802b36:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b39:	8b 50 0c             	mov    0xc(%eax),%edx
  802b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3f:	8b 40 0c             	mov    0xc(%eax),%eax
  802b42:	01 c2                	add    %eax,%edx
  802b44:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b47:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->size = blockToInsert->sva = 0;
  802b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802b54:	8b 45 08             	mov    0x8(%ebp),%eax
  802b57:	8b 50 08             	mov    0x8(%eax),%edx
  802b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5d:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802b60:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b64:	75 17                	jne    802b7d <insert_sorted_with_merge_freeList+0x234>
  802b66:	83 ec 04             	sub    $0x4,%esp
  802b69:	68 70 3b 80 00       	push   $0x803b70
  802b6e:	68 31 01 00 00       	push   $0x131
  802b73:	68 93 3b 80 00       	push   $0x803b93
  802b78:	e8 20 d8 ff ff       	call   80039d <_panic>
  802b7d:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b83:	8b 45 08             	mov    0x8(%ebp),%eax
  802b86:	89 10                	mov    %edx,(%eax)
  802b88:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8b:	8b 00                	mov    (%eax),%eax
  802b8d:	85 c0                	test   %eax,%eax
  802b8f:	74 0d                	je     802b9e <insert_sorted_with_merge_freeList+0x255>
  802b91:	a1 48 41 80 00       	mov    0x804148,%eax
  802b96:	8b 55 08             	mov    0x8(%ebp),%edx
  802b99:	89 50 04             	mov    %edx,0x4(%eax)
  802b9c:	eb 08                	jmp    802ba6 <insert_sorted_with_merge_freeList+0x25d>
  802b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba1:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba9:	a3 48 41 80 00       	mov    %eax,0x804148
  802bae:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bb8:	a1 54 41 80 00       	mov    0x804154,%eax
  802bbd:	40                   	inc    %eax
  802bbe:	a3 54 41 80 00       	mov    %eax,0x804154
						}
				}
        }

}
}
  802bc3:	e9 da 04 00 00       	jmp    8030a2 <insert_sorted_with_merge_freeList+0x759>

				}

				else
				{
					LIST_INSERT_TAIL(&(FreeMemBlocksList),  blockToInsert);
  802bc8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bcc:	75 17                	jne    802be5 <insert_sorted_with_merge_freeList+0x29c>
  802bce:	83 ec 04             	sub    $0x4,%esp
  802bd1:	68 18 3c 80 00       	push   $0x803c18
  802bd6:	68 37 01 00 00       	push   $0x137
  802bdb:	68 93 3b 80 00       	push   $0x803b93
  802be0:	e8 b8 d7 ff ff       	call   80039d <_panic>
  802be5:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802beb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bee:	89 50 04             	mov    %edx,0x4(%eax)
  802bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf4:	8b 40 04             	mov    0x4(%eax),%eax
  802bf7:	85 c0                	test   %eax,%eax
  802bf9:	74 0c                	je     802c07 <insert_sorted_with_merge_freeList+0x2be>
  802bfb:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802c00:	8b 55 08             	mov    0x8(%ebp),%edx
  802c03:	89 10                	mov    %edx,(%eax)
  802c05:	eb 08                	jmp    802c0f <insert_sorted_with_merge_freeList+0x2c6>
  802c07:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0a:	a3 38 41 80 00       	mov    %eax,0x804138
  802c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c12:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c17:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c20:	a1 44 41 80 00       	mov    0x804144,%eax
  802c25:	40                   	inc    %eax
  802c26:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  802c2b:	e9 72 04 00 00       	jmp    8030a2 <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  802c30:	a1 38 41 80 00       	mov    0x804138,%eax
  802c35:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c38:	e9 35 04 00 00       	jmp    803072 <insert_sorted_with_merge_freeList+0x729>
				{
				     next=LIST_NEXT(blk_itr);
  802c3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c40:	8b 00                	mov    (%eax),%eax
  802c42:	89 45 e8             	mov    %eax,-0x18(%ebp)


					if( (blockToInsert->sva > blk_itr->sva) )
  802c45:	8b 45 08             	mov    0x8(%ebp),%eax
  802c48:	8b 50 08             	mov    0x8(%eax),%edx
  802c4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4e:	8b 40 08             	mov    0x8(%eax),%eax
  802c51:	39 c2                	cmp    %eax,%edx
  802c53:	0f 86 11 04 00 00    	jbe    80306a <insert_sorted_with_merge_freeList+0x721>
						{
							if(((blk_itr->sva) + (blk_itr->size) < blockToInsert->sva && (blockToInsert->sva) + (blockToInsert->size) < next->sva))
  802c59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5c:	8b 50 08             	mov    0x8(%eax),%edx
  802c5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c62:	8b 40 0c             	mov    0xc(%eax),%eax
  802c65:	01 c2                	add    %eax,%edx
  802c67:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6a:	8b 40 08             	mov    0x8(%eax),%eax
  802c6d:	39 c2                	cmp    %eax,%edx
  802c6f:	0f 83 8b 00 00 00    	jae    802d00 <insert_sorted_with_merge_freeList+0x3b7>
  802c75:	8b 45 08             	mov    0x8(%ebp),%eax
  802c78:	8b 50 08             	mov    0x8(%eax),%edx
  802c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7e:	8b 40 0c             	mov    0xc(%eax),%eax
  802c81:	01 c2                	add    %eax,%edx
  802c83:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c86:	8b 40 08             	mov    0x8(%eax),%eax
  802c89:	39 c2                	cmp    %eax,%edx
  802c8b:	73 73                	jae    802d00 <insert_sorted_with_merge_freeList+0x3b7>
							{
								LIST_INSERT_AFTER(&(FreeMemBlocksList), blk_itr, blockToInsert);
  802c8d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c91:	74 06                	je     802c99 <insert_sorted_with_merge_freeList+0x350>
  802c93:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c97:	75 17                	jne    802cb0 <insert_sorted_with_merge_freeList+0x367>
  802c99:	83 ec 04             	sub    $0x4,%esp
  802c9c:	68 e4 3b 80 00       	push   $0x803be4
  802ca1:	68 48 01 00 00       	push   $0x148
  802ca6:	68 93 3b 80 00       	push   $0x803b93
  802cab:	e8 ed d6 ff ff       	call   80039d <_panic>
  802cb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb3:	8b 10                	mov    (%eax),%edx
  802cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb8:	89 10                	mov    %edx,(%eax)
  802cba:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbd:	8b 00                	mov    (%eax),%eax
  802cbf:	85 c0                	test   %eax,%eax
  802cc1:	74 0b                	je     802cce <insert_sorted_with_merge_freeList+0x385>
  802cc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc6:	8b 00                	mov    (%eax),%eax
  802cc8:	8b 55 08             	mov    0x8(%ebp),%edx
  802ccb:	89 50 04             	mov    %edx,0x4(%eax)
  802cce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd1:	8b 55 08             	mov    0x8(%ebp),%edx
  802cd4:	89 10                	mov    %edx,(%eax)
  802cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cdc:	89 50 04             	mov    %edx,0x4(%eax)
  802cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce2:	8b 00                	mov    (%eax),%eax
  802ce4:	85 c0                	test   %eax,%eax
  802ce6:	75 08                	jne    802cf0 <insert_sorted_with_merge_freeList+0x3a7>
  802ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ceb:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802cf0:	a1 44 41 80 00       	mov    0x804144,%eax
  802cf5:	40                   	inc    %eax
  802cf6:	a3 44 41 80 00       	mov    %eax,0x804144
								break;
  802cfb:	e9 a2 03 00 00       	jmp    8030a2 <insert_sorted_with_merge_freeList+0x759>

							}
							else if((blockToInsert->sva + blockToInsert->size) < next->sva  && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  802d00:	8b 45 08             	mov    0x8(%ebp),%eax
  802d03:	8b 50 08             	mov    0x8(%eax),%edx
  802d06:	8b 45 08             	mov    0x8(%ebp),%eax
  802d09:	8b 40 0c             	mov    0xc(%eax),%eax
  802d0c:	01 c2                	add    %eax,%edx
  802d0e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d11:	8b 40 08             	mov    0x8(%eax),%eax
  802d14:	39 c2                	cmp    %eax,%edx
  802d16:	0f 83 ae 00 00 00    	jae    802dca <insert_sorted_with_merge_freeList+0x481>
  802d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1f:	8b 50 08             	mov    0x8(%eax),%edx
  802d22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d25:	8b 48 08             	mov    0x8(%eax),%ecx
  802d28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2b:	8b 40 0c             	mov    0xc(%eax),%eax
  802d2e:	01 c8                	add    %ecx,%eax
  802d30:	39 c2                	cmp    %eax,%edx
  802d32:	0f 85 92 00 00 00    	jne    802dca <insert_sorted_with_merge_freeList+0x481>
							{

								blk_itr->size=blk_itr->size+blockToInsert->size;
  802d38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3b:	8b 50 0c             	mov    0xc(%eax),%edx
  802d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d41:	8b 40 0c             	mov    0xc(%eax),%eax
  802d44:	01 c2                	add    %eax,%edx
  802d46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d49:	89 50 0c             	mov    %edx,0xc(%eax)
								 blockToInsert->size=blockToInsert->sva=0;
  802d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802d56:	8b 45 08             	mov    0x8(%ebp),%eax
  802d59:	8b 50 08             	mov    0x8(%eax),%edx
  802d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5f:	89 50 0c             	mov    %edx,0xc(%eax)
								 LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802d62:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d66:	75 17                	jne    802d7f <insert_sorted_with_merge_freeList+0x436>
  802d68:	83 ec 04             	sub    $0x4,%esp
  802d6b:	68 70 3b 80 00       	push   $0x803b70
  802d70:	68 51 01 00 00       	push   $0x151
  802d75:	68 93 3b 80 00       	push   $0x803b93
  802d7a:	e8 1e d6 ff ff       	call   80039d <_panic>
  802d7f:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d85:	8b 45 08             	mov    0x8(%ebp),%eax
  802d88:	89 10                	mov    %edx,(%eax)
  802d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8d:	8b 00                	mov    (%eax),%eax
  802d8f:	85 c0                	test   %eax,%eax
  802d91:	74 0d                	je     802da0 <insert_sorted_with_merge_freeList+0x457>
  802d93:	a1 48 41 80 00       	mov    0x804148,%eax
  802d98:	8b 55 08             	mov    0x8(%ebp),%edx
  802d9b:	89 50 04             	mov    %edx,0x4(%eax)
  802d9e:	eb 08                	jmp    802da8 <insert_sorted_with_merge_freeList+0x45f>
  802da0:	8b 45 08             	mov    0x8(%ebp),%eax
  802da3:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802da8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dab:	a3 48 41 80 00       	mov    %eax,0x804148
  802db0:	8b 45 08             	mov    0x8(%ebp),%eax
  802db3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dba:	a1 54 41 80 00       	mov    0x804154,%eax
  802dbf:	40                   	inc    %eax
  802dc0:	a3 54 41 80 00       	mov    %eax,0x804154
								 break;
  802dc5:	e9 d8 02 00 00       	jmp    8030a2 <insert_sorted_with_merge_freeList+0x759>

							}
							else if( (blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva > (blk_itr->sva + blk_itr->size))
  802dca:	8b 45 08             	mov    0x8(%ebp),%eax
  802dcd:	8b 50 08             	mov    0x8(%eax),%edx
  802dd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd3:	8b 40 0c             	mov    0xc(%eax),%eax
  802dd6:	01 c2                	add    %eax,%edx
  802dd8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ddb:	8b 40 08             	mov    0x8(%eax),%eax
  802dde:	39 c2                	cmp    %eax,%edx
  802de0:	0f 85 ba 00 00 00    	jne    802ea0 <insert_sorted_with_merge_freeList+0x557>
  802de6:	8b 45 08             	mov    0x8(%ebp),%eax
  802de9:	8b 50 08             	mov    0x8(%eax),%edx
  802dec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802def:	8b 48 08             	mov    0x8(%eax),%ecx
  802df2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df5:	8b 40 0c             	mov    0xc(%eax),%eax
  802df8:	01 c8                	add    %ecx,%eax
  802dfa:	39 c2                	cmp    %eax,%edx
  802dfc:	0f 86 9e 00 00 00    	jbe    802ea0 <insert_sorted_with_merge_freeList+0x557>
							{
								next->size = next->size + blockToInsert->size;
  802e02:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e05:	8b 50 0c             	mov    0xc(%eax),%edx
  802e08:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0b:	8b 40 0c             	mov    0xc(%eax),%eax
  802e0e:	01 c2                	add    %eax,%edx
  802e10:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e13:	89 50 0c             	mov    %edx,0xc(%eax)
								next->sva = blockToInsert->sva;
  802e16:	8b 45 08             	mov    0x8(%ebp),%eax
  802e19:	8b 50 08             	mov    0x8(%eax),%edx
  802e1c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e1f:	89 50 08             	mov    %edx,0x8(%eax)

								blockToInsert->size = blockToInsert->sva = 0;
  802e22:	8b 45 08             	mov    0x8(%ebp),%eax
  802e25:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2f:	8b 50 08             	mov    0x8(%eax),%edx
  802e32:	8b 45 08             	mov    0x8(%ebp),%eax
  802e35:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802e38:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e3c:	75 17                	jne    802e55 <insert_sorted_with_merge_freeList+0x50c>
  802e3e:	83 ec 04             	sub    $0x4,%esp
  802e41:	68 70 3b 80 00       	push   $0x803b70
  802e46:	68 5b 01 00 00       	push   $0x15b
  802e4b:	68 93 3b 80 00       	push   $0x803b93
  802e50:	e8 48 d5 ff ff       	call   80039d <_panic>
  802e55:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5e:	89 10                	mov    %edx,(%eax)
  802e60:	8b 45 08             	mov    0x8(%ebp),%eax
  802e63:	8b 00                	mov    (%eax),%eax
  802e65:	85 c0                	test   %eax,%eax
  802e67:	74 0d                	je     802e76 <insert_sorted_with_merge_freeList+0x52d>
  802e69:	a1 48 41 80 00       	mov    0x804148,%eax
  802e6e:	8b 55 08             	mov    0x8(%ebp),%edx
  802e71:	89 50 04             	mov    %edx,0x4(%eax)
  802e74:	eb 08                	jmp    802e7e <insert_sorted_with_merge_freeList+0x535>
  802e76:	8b 45 08             	mov    0x8(%ebp),%eax
  802e79:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e81:	a3 48 41 80 00       	mov    %eax,0x804148
  802e86:	8b 45 08             	mov    0x8(%ebp),%eax
  802e89:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e90:	a1 54 41 80 00       	mov    0x804154,%eax
  802e95:	40                   	inc    %eax
  802e96:	a3 54 41 80 00       	mov    %eax,0x804154
								break;
  802e9b:	e9 02 02 00 00       	jmp    8030a2 <insert_sorted_with_merge_freeList+0x759>
							}
							else if ((blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  802ea0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea3:	8b 50 08             	mov    0x8(%eax),%edx
  802ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea9:	8b 40 0c             	mov    0xc(%eax),%eax
  802eac:	01 c2                	add    %eax,%edx
  802eae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eb1:	8b 40 08             	mov    0x8(%eax),%eax
  802eb4:	39 c2                	cmp    %eax,%edx
  802eb6:	0f 85 ae 01 00 00    	jne    80306a <insert_sorted_with_merge_freeList+0x721>
  802ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebf:	8b 50 08             	mov    0x8(%eax),%edx
  802ec2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec5:	8b 48 08             	mov    0x8(%eax),%ecx
  802ec8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecb:	8b 40 0c             	mov    0xc(%eax),%eax
  802ece:	01 c8                	add    %ecx,%eax
  802ed0:	39 c2                	cmp    %eax,%edx
  802ed2:	0f 85 92 01 00 00    	jne    80306a <insert_sorted_with_merge_freeList+0x721>
							{
								blk_itr->size = blk_itr->size + blockToInsert->size + next->size;
  802ed8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edb:	8b 50 0c             	mov    0xc(%eax),%edx
  802ede:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ee4:	01 c2                	add    %eax,%edx
  802ee6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ee9:	8b 40 0c             	mov    0xc(%eax),%eax
  802eec:	01 c2                	add    %eax,%edx
  802eee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef1:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size = blockToInsert->sva=0;
  802ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802efe:	8b 45 08             	mov    0x8(%ebp),%eax
  802f01:	8b 50 08             	mov    0x8(%eax),%edx
  802f04:	8b 45 08             	mov    0x8(%ebp),%eax
  802f07:	89 50 0c             	mov    %edx,0xc(%eax)
								next->size = next->sva = 0;
  802f0a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f0d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802f14:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f17:	8b 50 08             	mov    0x8(%eax),%edx
  802f1a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f1d:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_REMOVE(&FreeMemBlocksList, next);
  802f20:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f24:	75 17                	jne    802f3d <insert_sorted_with_merge_freeList+0x5f4>
  802f26:	83 ec 04             	sub    $0x4,%esp
  802f29:	68 3b 3c 80 00       	push   $0x803c3b
  802f2e:	68 63 01 00 00       	push   $0x163
  802f33:	68 93 3b 80 00       	push   $0x803b93
  802f38:	e8 60 d4 ff ff       	call   80039d <_panic>
  802f3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f40:	8b 00                	mov    (%eax),%eax
  802f42:	85 c0                	test   %eax,%eax
  802f44:	74 10                	je     802f56 <insert_sorted_with_merge_freeList+0x60d>
  802f46:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f49:	8b 00                	mov    (%eax),%eax
  802f4b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f4e:	8b 52 04             	mov    0x4(%edx),%edx
  802f51:	89 50 04             	mov    %edx,0x4(%eax)
  802f54:	eb 0b                	jmp    802f61 <insert_sorted_with_merge_freeList+0x618>
  802f56:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f59:	8b 40 04             	mov    0x4(%eax),%eax
  802f5c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802f61:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f64:	8b 40 04             	mov    0x4(%eax),%eax
  802f67:	85 c0                	test   %eax,%eax
  802f69:	74 0f                	je     802f7a <insert_sorted_with_merge_freeList+0x631>
  802f6b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f6e:	8b 40 04             	mov    0x4(%eax),%eax
  802f71:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f74:	8b 12                	mov    (%edx),%edx
  802f76:	89 10                	mov    %edx,(%eax)
  802f78:	eb 0a                	jmp    802f84 <insert_sorted_with_merge_freeList+0x63b>
  802f7a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f7d:	8b 00                	mov    (%eax),%eax
  802f7f:	a3 38 41 80 00       	mov    %eax,0x804138
  802f84:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f87:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f8d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f90:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f97:	a1 44 41 80 00       	mov    0x804144,%eax
  802f9c:	48                   	dec    %eax
  802f9d:	a3 44 41 80 00       	mov    %eax,0x804144
								LIST_INSERT_HEAD(&AvailableMemBlocksList, next );
  802fa2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802fa6:	75 17                	jne    802fbf <insert_sorted_with_merge_freeList+0x676>
  802fa8:	83 ec 04             	sub    $0x4,%esp
  802fab:	68 70 3b 80 00       	push   $0x803b70
  802fb0:	68 64 01 00 00       	push   $0x164
  802fb5:	68 93 3b 80 00       	push   $0x803b93
  802fba:	e8 de d3 ff ff       	call   80039d <_panic>
  802fbf:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802fc5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fc8:	89 10                	mov    %edx,(%eax)
  802fca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fcd:	8b 00                	mov    (%eax),%eax
  802fcf:	85 c0                	test   %eax,%eax
  802fd1:	74 0d                	je     802fe0 <insert_sorted_with_merge_freeList+0x697>
  802fd3:	a1 48 41 80 00       	mov    0x804148,%eax
  802fd8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fdb:	89 50 04             	mov    %edx,0x4(%eax)
  802fde:	eb 08                	jmp    802fe8 <insert_sorted_with_merge_freeList+0x69f>
  802fe0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fe3:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802fe8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802feb:	a3 48 41 80 00       	mov    %eax,0x804148
  802ff0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ffa:	a1 54 41 80 00       	mov    0x804154,%eax
  802fff:	40                   	inc    %eax
  803000:	a3 54 41 80 00       	mov    %eax,0x804154
							    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  803005:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803009:	75 17                	jne    803022 <insert_sorted_with_merge_freeList+0x6d9>
  80300b:	83 ec 04             	sub    $0x4,%esp
  80300e:	68 70 3b 80 00       	push   $0x803b70
  803013:	68 65 01 00 00       	push   $0x165
  803018:	68 93 3b 80 00       	push   $0x803b93
  80301d:	e8 7b d3 ff ff       	call   80039d <_panic>
  803022:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803028:	8b 45 08             	mov    0x8(%ebp),%eax
  80302b:	89 10                	mov    %edx,(%eax)
  80302d:	8b 45 08             	mov    0x8(%ebp),%eax
  803030:	8b 00                	mov    (%eax),%eax
  803032:	85 c0                	test   %eax,%eax
  803034:	74 0d                	je     803043 <insert_sorted_with_merge_freeList+0x6fa>
  803036:	a1 48 41 80 00       	mov    0x804148,%eax
  80303b:	8b 55 08             	mov    0x8(%ebp),%edx
  80303e:	89 50 04             	mov    %edx,0x4(%eax)
  803041:	eb 08                	jmp    80304b <insert_sorted_with_merge_freeList+0x702>
  803043:	8b 45 08             	mov    0x8(%ebp),%eax
  803046:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80304b:	8b 45 08             	mov    0x8(%ebp),%eax
  80304e:	a3 48 41 80 00       	mov    %eax,0x804148
  803053:	8b 45 08             	mov    0x8(%ebp),%eax
  803056:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80305d:	a1 54 41 80 00       	mov    0x804154,%eax
  803062:	40                   	inc    %eax
  803063:	a3 54 41 80 00       	mov    %eax,0x804154
								break;
  803068:	eb 38                	jmp    8030a2 <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  80306a:	a1 40 41 80 00       	mov    0x804140,%eax
  80306f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803072:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803076:	74 07                	je     80307f <insert_sorted_with_merge_freeList+0x736>
  803078:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307b:	8b 00                	mov    (%eax),%eax
  80307d:	eb 05                	jmp    803084 <insert_sorted_with_merge_freeList+0x73b>
  80307f:	b8 00 00 00 00       	mov    $0x0,%eax
  803084:	a3 40 41 80 00       	mov    %eax,0x804140
  803089:	a1 40 41 80 00       	mov    0x804140,%eax
  80308e:	85 c0                	test   %eax,%eax
  803090:	0f 85 a7 fb ff ff    	jne    802c3d <insert_sorted_with_merge_freeList+0x2f4>
  803096:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80309a:	0f 85 9d fb ff ff    	jne    802c3d <insert_sorted_with_merge_freeList+0x2f4>
						}
				}
        }

}
}
  8030a0:	eb 00                	jmp    8030a2 <insert_sorted_with_merge_freeList+0x759>
  8030a2:	90                   	nop
  8030a3:	c9                   	leave  
  8030a4:	c3                   	ret    
  8030a5:	66 90                	xchg   %ax,%ax
  8030a7:	90                   	nop

008030a8 <__udivdi3>:
  8030a8:	55                   	push   %ebp
  8030a9:	57                   	push   %edi
  8030aa:	56                   	push   %esi
  8030ab:	53                   	push   %ebx
  8030ac:	83 ec 1c             	sub    $0x1c,%esp
  8030af:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8030b3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8030b7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8030bb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8030bf:	89 ca                	mov    %ecx,%edx
  8030c1:	89 f8                	mov    %edi,%eax
  8030c3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8030c7:	85 f6                	test   %esi,%esi
  8030c9:	75 2d                	jne    8030f8 <__udivdi3+0x50>
  8030cb:	39 cf                	cmp    %ecx,%edi
  8030cd:	77 65                	ja     803134 <__udivdi3+0x8c>
  8030cf:	89 fd                	mov    %edi,%ebp
  8030d1:	85 ff                	test   %edi,%edi
  8030d3:	75 0b                	jne    8030e0 <__udivdi3+0x38>
  8030d5:	b8 01 00 00 00       	mov    $0x1,%eax
  8030da:	31 d2                	xor    %edx,%edx
  8030dc:	f7 f7                	div    %edi
  8030de:	89 c5                	mov    %eax,%ebp
  8030e0:	31 d2                	xor    %edx,%edx
  8030e2:	89 c8                	mov    %ecx,%eax
  8030e4:	f7 f5                	div    %ebp
  8030e6:	89 c1                	mov    %eax,%ecx
  8030e8:	89 d8                	mov    %ebx,%eax
  8030ea:	f7 f5                	div    %ebp
  8030ec:	89 cf                	mov    %ecx,%edi
  8030ee:	89 fa                	mov    %edi,%edx
  8030f0:	83 c4 1c             	add    $0x1c,%esp
  8030f3:	5b                   	pop    %ebx
  8030f4:	5e                   	pop    %esi
  8030f5:	5f                   	pop    %edi
  8030f6:	5d                   	pop    %ebp
  8030f7:	c3                   	ret    
  8030f8:	39 ce                	cmp    %ecx,%esi
  8030fa:	77 28                	ja     803124 <__udivdi3+0x7c>
  8030fc:	0f bd fe             	bsr    %esi,%edi
  8030ff:	83 f7 1f             	xor    $0x1f,%edi
  803102:	75 40                	jne    803144 <__udivdi3+0x9c>
  803104:	39 ce                	cmp    %ecx,%esi
  803106:	72 0a                	jb     803112 <__udivdi3+0x6a>
  803108:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80310c:	0f 87 9e 00 00 00    	ja     8031b0 <__udivdi3+0x108>
  803112:	b8 01 00 00 00       	mov    $0x1,%eax
  803117:	89 fa                	mov    %edi,%edx
  803119:	83 c4 1c             	add    $0x1c,%esp
  80311c:	5b                   	pop    %ebx
  80311d:	5e                   	pop    %esi
  80311e:	5f                   	pop    %edi
  80311f:	5d                   	pop    %ebp
  803120:	c3                   	ret    
  803121:	8d 76 00             	lea    0x0(%esi),%esi
  803124:	31 ff                	xor    %edi,%edi
  803126:	31 c0                	xor    %eax,%eax
  803128:	89 fa                	mov    %edi,%edx
  80312a:	83 c4 1c             	add    $0x1c,%esp
  80312d:	5b                   	pop    %ebx
  80312e:	5e                   	pop    %esi
  80312f:	5f                   	pop    %edi
  803130:	5d                   	pop    %ebp
  803131:	c3                   	ret    
  803132:	66 90                	xchg   %ax,%ax
  803134:	89 d8                	mov    %ebx,%eax
  803136:	f7 f7                	div    %edi
  803138:	31 ff                	xor    %edi,%edi
  80313a:	89 fa                	mov    %edi,%edx
  80313c:	83 c4 1c             	add    $0x1c,%esp
  80313f:	5b                   	pop    %ebx
  803140:	5e                   	pop    %esi
  803141:	5f                   	pop    %edi
  803142:	5d                   	pop    %ebp
  803143:	c3                   	ret    
  803144:	bd 20 00 00 00       	mov    $0x20,%ebp
  803149:	89 eb                	mov    %ebp,%ebx
  80314b:	29 fb                	sub    %edi,%ebx
  80314d:	89 f9                	mov    %edi,%ecx
  80314f:	d3 e6                	shl    %cl,%esi
  803151:	89 c5                	mov    %eax,%ebp
  803153:	88 d9                	mov    %bl,%cl
  803155:	d3 ed                	shr    %cl,%ebp
  803157:	89 e9                	mov    %ebp,%ecx
  803159:	09 f1                	or     %esi,%ecx
  80315b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80315f:	89 f9                	mov    %edi,%ecx
  803161:	d3 e0                	shl    %cl,%eax
  803163:	89 c5                	mov    %eax,%ebp
  803165:	89 d6                	mov    %edx,%esi
  803167:	88 d9                	mov    %bl,%cl
  803169:	d3 ee                	shr    %cl,%esi
  80316b:	89 f9                	mov    %edi,%ecx
  80316d:	d3 e2                	shl    %cl,%edx
  80316f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803173:	88 d9                	mov    %bl,%cl
  803175:	d3 e8                	shr    %cl,%eax
  803177:	09 c2                	or     %eax,%edx
  803179:	89 d0                	mov    %edx,%eax
  80317b:	89 f2                	mov    %esi,%edx
  80317d:	f7 74 24 0c          	divl   0xc(%esp)
  803181:	89 d6                	mov    %edx,%esi
  803183:	89 c3                	mov    %eax,%ebx
  803185:	f7 e5                	mul    %ebp
  803187:	39 d6                	cmp    %edx,%esi
  803189:	72 19                	jb     8031a4 <__udivdi3+0xfc>
  80318b:	74 0b                	je     803198 <__udivdi3+0xf0>
  80318d:	89 d8                	mov    %ebx,%eax
  80318f:	31 ff                	xor    %edi,%edi
  803191:	e9 58 ff ff ff       	jmp    8030ee <__udivdi3+0x46>
  803196:	66 90                	xchg   %ax,%ax
  803198:	8b 54 24 08          	mov    0x8(%esp),%edx
  80319c:	89 f9                	mov    %edi,%ecx
  80319e:	d3 e2                	shl    %cl,%edx
  8031a0:	39 c2                	cmp    %eax,%edx
  8031a2:	73 e9                	jae    80318d <__udivdi3+0xe5>
  8031a4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8031a7:	31 ff                	xor    %edi,%edi
  8031a9:	e9 40 ff ff ff       	jmp    8030ee <__udivdi3+0x46>
  8031ae:	66 90                	xchg   %ax,%ax
  8031b0:	31 c0                	xor    %eax,%eax
  8031b2:	e9 37 ff ff ff       	jmp    8030ee <__udivdi3+0x46>
  8031b7:	90                   	nop

008031b8 <__umoddi3>:
  8031b8:	55                   	push   %ebp
  8031b9:	57                   	push   %edi
  8031ba:	56                   	push   %esi
  8031bb:	53                   	push   %ebx
  8031bc:	83 ec 1c             	sub    $0x1c,%esp
  8031bf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8031c3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8031c7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8031cb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8031cf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8031d3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8031d7:	89 f3                	mov    %esi,%ebx
  8031d9:	89 fa                	mov    %edi,%edx
  8031db:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8031df:	89 34 24             	mov    %esi,(%esp)
  8031e2:	85 c0                	test   %eax,%eax
  8031e4:	75 1a                	jne    803200 <__umoddi3+0x48>
  8031e6:	39 f7                	cmp    %esi,%edi
  8031e8:	0f 86 a2 00 00 00    	jbe    803290 <__umoddi3+0xd8>
  8031ee:	89 c8                	mov    %ecx,%eax
  8031f0:	89 f2                	mov    %esi,%edx
  8031f2:	f7 f7                	div    %edi
  8031f4:	89 d0                	mov    %edx,%eax
  8031f6:	31 d2                	xor    %edx,%edx
  8031f8:	83 c4 1c             	add    $0x1c,%esp
  8031fb:	5b                   	pop    %ebx
  8031fc:	5e                   	pop    %esi
  8031fd:	5f                   	pop    %edi
  8031fe:	5d                   	pop    %ebp
  8031ff:	c3                   	ret    
  803200:	39 f0                	cmp    %esi,%eax
  803202:	0f 87 ac 00 00 00    	ja     8032b4 <__umoddi3+0xfc>
  803208:	0f bd e8             	bsr    %eax,%ebp
  80320b:	83 f5 1f             	xor    $0x1f,%ebp
  80320e:	0f 84 ac 00 00 00    	je     8032c0 <__umoddi3+0x108>
  803214:	bf 20 00 00 00       	mov    $0x20,%edi
  803219:	29 ef                	sub    %ebp,%edi
  80321b:	89 fe                	mov    %edi,%esi
  80321d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803221:	89 e9                	mov    %ebp,%ecx
  803223:	d3 e0                	shl    %cl,%eax
  803225:	89 d7                	mov    %edx,%edi
  803227:	89 f1                	mov    %esi,%ecx
  803229:	d3 ef                	shr    %cl,%edi
  80322b:	09 c7                	or     %eax,%edi
  80322d:	89 e9                	mov    %ebp,%ecx
  80322f:	d3 e2                	shl    %cl,%edx
  803231:	89 14 24             	mov    %edx,(%esp)
  803234:	89 d8                	mov    %ebx,%eax
  803236:	d3 e0                	shl    %cl,%eax
  803238:	89 c2                	mov    %eax,%edx
  80323a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80323e:	d3 e0                	shl    %cl,%eax
  803240:	89 44 24 04          	mov    %eax,0x4(%esp)
  803244:	8b 44 24 08          	mov    0x8(%esp),%eax
  803248:	89 f1                	mov    %esi,%ecx
  80324a:	d3 e8                	shr    %cl,%eax
  80324c:	09 d0                	or     %edx,%eax
  80324e:	d3 eb                	shr    %cl,%ebx
  803250:	89 da                	mov    %ebx,%edx
  803252:	f7 f7                	div    %edi
  803254:	89 d3                	mov    %edx,%ebx
  803256:	f7 24 24             	mull   (%esp)
  803259:	89 c6                	mov    %eax,%esi
  80325b:	89 d1                	mov    %edx,%ecx
  80325d:	39 d3                	cmp    %edx,%ebx
  80325f:	0f 82 87 00 00 00    	jb     8032ec <__umoddi3+0x134>
  803265:	0f 84 91 00 00 00    	je     8032fc <__umoddi3+0x144>
  80326b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80326f:	29 f2                	sub    %esi,%edx
  803271:	19 cb                	sbb    %ecx,%ebx
  803273:	89 d8                	mov    %ebx,%eax
  803275:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803279:	d3 e0                	shl    %cl,%eax
  80327b:	89 e9                	mov    %ebp,%ecx
  80327d:	d3 ea                	shr    %cl,%edx
  80327f:	09 d0                	or     %edx,%eax
  803281:	89 e9                	mov    %ebp,%ecx
  803283:	d3 eb                	shr    %cl,%ebx
  803285:	89 da                	mov    %ebx,%edx
  803287:	83 c4 1c             	add    $0x1c,%esp
  80328a:	5b                   	pop    %ebx
  80328b:	5e                   	pop    %esi
  80328c:	5f                   	pop    %edi
  80328d:	5d                   	pop    %ebp
  80328e:	c3                   	ret    
  80328f:	90                   	nop
  803290:	89 fd                	mov    %edi,%ebp
  803292:	85 ff                	test   %edi,%edi
  803294:	75 0b                	jne    8032a1 <__umoddi3+0xe9>
  803296:	b8 01 00 00 00       	mov    $0x1,%eax
  80329b:	31 d2                	xor    %edx,%edx
  80329d:	f7 f7                	div    %edi
  80329f:	89 c5                	mov    %eax,%ebp
  8032a1:	89 f0                	mov    %esi,%eax
  8032a3:	31 d2                	xor    %edx,%edx
  8032a5:	f7 f5                	div    %ebp
  8032a7:	89 c8                	mov    %ecx,%eax
  8032a9:	f7 f5                	div    %ebp
  8032ab:	89 d0                	mov    %edx,%eax
  8032ad:	e9 44 ff ff ff       	jmp    8031f6 <__umoddi3+0x3e>
  8032b2:	66 90                	xchg   %ax,%ax
  8032b4:	89 c8                	mov    %ecx,%eax
  8032b6:	89 f2                	mov    %esi,%edx
  8032b8:	83 c4 1c             	add    $0x1c,%esp
  8032bb:	5b                   	pop    %ebx
  8032bc:	5e                   	pop    %esi
  8032bd:	5f                   	pop    %edi
  8032be:	5d                   	pop    %ebp
  8032bf:	c3                   	ret    
  8032c0:	3b 04 24             	cmp    (%esp),%eax
  8032c3:	72 06                	jb     8032cb <__umoddi3+0x113>
  8032c5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8032c9:	77 0f                	ja     8032da <__umoddi3+0x122>
  8032cb:	89 f2                	mov    %esi,%edx
  8032cd:	29 f9                	sub    %edi,%ecx
  8032cf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8032d3:	89 14 24             	mov    %edx,(%esp)
  8032d6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8032da:	8b 44 24 04          	mov    0x4(%esp),%eax
  8032de:	8b 14 24             	mov    (%esp),%edx
  8032e1:	83 c4 1c             	add    $0x1c,%esp
  8032e4:	5b                   	pop    %ebx
  8032e5:	5e                   	pop    %esi
  8032e6:	5f                   	pop    %edi
  8032e7:	5d                   	pop    %ebp
  8032e8:	c3                   	ret    
  8032e9:	8d 76 00             	lea    0x0(%esi),%esi
  8032ec:	2b 04 24             	sub    (%esp),%eax
  8032ef:	19 fa                	sbb    %edi,%edx
  8032f1:	89 d1                	mov    %edx,%ecx
  8032f3:	89 c6                	mov    %eax,%esi
  8032f5:	e9 71 ff ff ff       	jmp    80326b <__umoddi3+0xb3>
  8032fa:	66 90                	xchg   %ax,%ax
  8032fc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803300:	72 ea                	jb     8032ec <__umoddi3+0x134>
  803302:	89 d9                	mov    %ebx,%ecx
  803304:	e9 62 ff ff ff       	jmp    80326b <__umoddi3+0xb3>
