
obj/user/tst_malloc_0:     file format elf32-i386


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
  800031:	e8 a3 01 00 00       	call   8001d9 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* *********************************************************** */

#include <inc/lib.h>

void _main(void)
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
void _main(void)
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
  800091:	6a 14                	push   $0x14
  800093:	68 bc 32 80 00       	push   $0x8032bc
  800098:	e8 78 02 00 00       	call   800315 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	if(STATIC_MEMBLOCK_ALLOC != 0)
		panic("STATIC_MEMBLOCK_ALLOC = 1 & it shall be 0. Go to 'inc/dynamic_allocator.h' and set STATIC_MEMBLOCK_ALLOC by 0. Then, repeat the test again.");

	int freeFrames_before = sys_calculate_free_frames() ;
  80009d:	e8 81 18 00 00       	call   801923 <sys_calculate_free_frames>
  8000a2:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int freeDiskFrames_before = sys_pf_calculate_allocated_pages() ;
  8000a5:	e8 19 19 00 00       	call   8019c3 <sys_pf_calculate_allocated_pages>
  8000aa:	89 45 e8             	mov    %eax,-0x18(%ebp)
	malloc(0);
  8000ad:	83 ec 0c             	sub    $0xc,%esp
  8000b0:	6a 00                	push   $0x0
  8000b2:	e8 3e 14 00 00       	call   8014f5 <malloc>
  8000b7:	83 c4 10             	add    $0x10,%esp
	int freeFrames_after = sys_calculate_free_frames() ;
  8000ba:	e8 64 18 00 00       	call   801923 <sys_calculate_free_frames>
  8000bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int freeDiskFrames_after = sys_pf_calculate_allocated_pages() ;
  8000c2:	e8 fc 18 00 00       	call   8019c3 <sys_pf_calculate_allocated_pages>
  8000c7:	89 45 e0             	mov    %eax,-0x20(%ebp)

	//Check MAX_MEM_BLOCK_CNT
	if(MAX_MEM_BLOCK_CNT != ((0xA0000000-0x80000000)/4096))
  8000ca:	a1 20 41 80 00       	mov    0x804120,%eax
  8000cf:	3d 00 00 02 00       	cmp    $0x20000,%eax
  8000d4:	74 14                	je     8000ea <_main+0xb2>
	{
		panic("Wrong initialize: MAX_MEM_BLOCK_CNT is not set with the correct size of the array");
  8000d6:	83 ec 04             	sub    $0x4,%esp
  8000d9:	68 d0 32 80 00       	push   $0x8032d0
  8000de:	6a 23                	push   $0x23
  8000e0:	68 bc 32 80 00       	push   $0x8032bc
  8000e5:	e8 2b 02 00 00       	call   800315 <_panic>
	}

	//Check number of nodes in AvailableMemBlocksList
	if (LIST_SIZE(&(AvailableMemBlocksList)) != MAX_MEM_BLOCK_CNT-1)
  8000ea:	a1 54 41 80 00       	mov    0x804154,%eax
  8000ef:	8b 15 20 41 80 00    	mov    0x804120,%edx
  8000f5:	4a                   	dec    %edx
  8000f6:	39 d0                	cmp    %edx,%eax
  8000f8:	74 14                	je     80010e <_main+0xd6>
	{
		panic("Wrong initialize: Wrong size for the AvailableMemBlocksList");
  8000fa:	83 ec 04             	sub    $0x4,%esp
  8000fd:	68 24 33 80 00       	push   $0x803324
  800102:	6a 29                	push   $0x29
  800104:	68 bc 32 80 00       	push   $0x8032bc
  800109:	e8 07 02 00 00       	call   800315 <_panic>
	}

	//Check number of nodes in AllocMemBlocksList
	if (LIST_SIZE(&(AllocMemBlocksList)) != 0)
  80010e:	a1 4c 40 80 00       	mov    0x80404c,%eax
  800113:	85 c0                	test   %eax,%eax
  800115:	74 14                	je     80012b <_main+0xf3>
	{
		panic("Wrong initialize: Wrong size for the AllocMemBlocksList");
  800117:	83 ec 04             	sub    $0x4,%esp
  80011a:	68 60 33 80 00       	push   $0x803360
  80011f:	6a 2f                	push   $0x2f
  800121:	68 bc 32 80 00       	push   $0x8032bc
  800126:	e8 ea 01 00 00       	call   800315 <_panic>
	}

	//Check number of nodes in FreeMemBlocksList
	if (LIST_SIZE(&(FreeMemBlocksList)) != 1)
  80012b:	a1 44 41 80 00       	mov    0x804144,%eax
  800130:	83 f8 01             	cmp    $0x1,%eax
  800133:	74 14                	je     800149 <_main+0x111>
	{
		panic("Wrong initialize: Wrong size for the FreeMemBlocksList");
  800135:	83 ec 04             	sub    $0x4,%esp
  800138:	68 98 33 80 00       	push   $0x803398
  80013d:	6a 35                	push   $0x35
  80013f:	68 bc 32 80 00       	push   $0x8032bc
  800144:	e8 cc 01 00 00       	call   800315 <_panic>
	}

	//Check content of FreeMemBlocksList
	struct MemBlock* block = LIST_FIRST(&FreeMemBlocksList);
  800149:	a1 38 41 80 00       	mov    0x804138,%eax
  80014e:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if(block == NULL || block->size != (0xA0000000-0x80000000) || block->sva != 0x80000000)
  800151:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800155:	74 1a                	je     800171 <_main+0x139>
  800157:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80015a:	8b 40 0c             	mov    0xc(%eax),%eax
  80015d:	3d 00 00 00 20       	cmp    $0x20000000,%eax
  800162:	75 0d                	jne    800171 <_main+0x139>
  800164:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800167:	8b 40 08             	mov    0x8(%eax),%eax
  80016a:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  80016f:	74 14                	je     800185 <_main+0x14d>
	{
		panic("Wrong initialize: Wrong content for the FreeMemBlocksList.");
  800171:	83 ec 04             	sub    $0x4,%esp
  800174:	68 d0 33 80 00       	push   $0x8033d0
  800179:	6a 3c                	push   $0x3c
  80017b:	68 bc 32 80 00       	push   $0x8032bc
  800180:	e8 90 01 00 00       	call   800315 <_panic>
	}

	//Check number of disk and memory frames
	if ((freeDiskFrames_after - freeDiskFrames_before) != 0) panic("Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)");
  800185:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800188:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80018b:	74 14                	je     8001a1 <_main+0x169>
  80018d:	83 ec 04             	sub    $0x4,%esp
  800190:	68 0c 34 80 00       	push   $0x80340c
  800195:	6a 40                	push   $0x40
  800197:	68 bc 32 80 00       	push   $0x8032bc
  80019c:	e8 74 01 00 00       	call   800315 <_panic>
	if ((freeFrames_before - freeFrames_after) != 512 + 1) panic("Wrong allocation: pages are not loaded successfully into memory %d", (freeFrames_before - freeFrames_after));
  8001a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001a4:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8001a7:	3d 01 02 00 00       	cmp    $0x201,%eax
  8001ac:	74 18                	je     8001c6 <_main+0x18e>
  8001ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001b1:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8001b4:	50                   	push   %eax
  8001b5:	68 74 34 80 00       	push   $0x803474
  8001ba:	6a 41                	push   $0x41
  8001bc:	68 bc 32 80 00       	push   $0x8032bc
  8001c1:	e8 4f 01 00 00       	call   800315 <_panic>

	/*=================================================*/

	cprintf("Congratulations!! test initialize_dyn_block_system of UHEAP completed successfully.\n");
  8001c6:	83 ec 0c             	sub    $0xc,%esp
  8001c9:	68 b8 34 80 00       	push   $0x8034b8
  8001ce:	e8 f6 03 00 00       	call   8005c9 <cprintf>
  8001d3:	83 c4 10             	add    $0x10,%esp

	return;
  8001d6:	90                   	nop
}
  8001d7:	c9                   	leave  
  8001d8:	c3                   	ret    

008001d9 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8001d9:	55                   	push   %ebp
  8001da:	89 e5                	mov    %esp,%ebp
  8001dc:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8001df:	e8 1f 1a 00 00       	call   801c03 <sys_getenvindex>
  8001e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8001e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001ea:	89 d0                	mov    %edx,%eax
  8001ec:	c1 e0 03             	shl    $0x3,%eax
  8001ef:	01 d0                	add    %edx,%eax
  8001f1:	01 c0                	add    %eax,%eax
  8001f3:	01 d0                	add    %edx,%eax
  8001f5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001fc:	01 d0                	add    %edx,%eax
  8001fe:	c1 e0 04             	shl    $0x4,%eax
  800201:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800206:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80020b:	a1 20 40 80 00       	mov    0x804020,%eax
  800210:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800216:	84 c0                	test   %al,%al
  800218:	74 0f                	je     800229 <libmain+0x50>
		binaryname = myEnv->prog_name;
  80021a:	a1 20 40 80 00       	mov    0x804020,%eax
  80021f:	05 5c 05 00 00       	add    $0x55c,%eax
  800224:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800229:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80022d:	7e 0a                	jle    800239 <libmain+0x60>
		binaryname = argv[0];
  80022f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800232:	8b 00                	mov    (%eax),%eax
  800234:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800239:	83 ec 08             	sub    $0x8,%esp
  80023c:	ff 75 0c             	pushl  0xc(%ebp)
  80023f:	ff 75 08             	pushl  0x8(%ebp)
  800242:	e8 f1 fd ff ff       	call   800038 <_main>
  800247:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80024a:	e8 c1 17 00 00       	call   801a10 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80024f:	83 ec 0c             	sub    $0xc,%esp
  800252:	68 28 35 80 00       	push   $0x803528
  800257:	e8 6d 03 00 00       	call   8005c9 <cprintf>
  80025c:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80025f:	a1 20 40 80 00       	mov    0x804020,%eax
  800264:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80026a:	a1 20 40 80 00       	mov    0x804020,%eax
  80026f:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800275:	83 ec 04             	sub    $0x4,%esp
  800278:	52                   	push   %edx
  800279:	50                   	push   %eax
  80027a:	68 50 35 80 00       	push   $0x803550
  80027f:	e8 45 03 00 00       	call   8005c9 <cprintf>
  800284:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800287:	a1 20 40 80 00       	mov    0x804020,%eax
  80028c:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800292:	a1 20 40 80 00       	mov    0x804020,%eax
  800297:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80029d:	a1 20 40 80 00       	mov    0x804020,%eax
  8002a2:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8002a8:	51                   	push   %ecx
  8002a9:	52                   	push   %edx
  8002aa:	50                   	push   %eax
  8002ab:	68 78 35 80 00       	push   $0x803578
  8002b0:	e8 14 03 00 00       	call   8005c9 <cprintf>
  8002b5:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002b8:	a1 20 40 80 00       	mov    0x804020,%eax
  8002bd:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8002c3:	83 ec 08             	sub    $0x8,%esp
  8002c6:	50                   	push   %eax
  8002c7:	68 d0 35 80 00       	push   $0x8035d0
  8002cc:	e8 f8 02 00 00       	call   8005c9 <cprintf>
  8002d1:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8002d4:	83 ec 0c             	sub    $0xc,%esp
  8002d7:	68 28 35 80 00       	push   $0x803528
  8002dc:	e8 e8 02 00 00       	call   8005c9 <cprintf>
  8002e1:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8002e4:	e8 41 17 00 00       	call   801a2a <sys_enable_interrupt>

	// exit gracefully
	exit();
  8002e9:	e8 19 00 00 00       	call   800307 <exit>
}
  8002ee:	90                   	nop
  8002ef:	c9                   	leave  
  8002f0:	c3                   	ret    

008002f1 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002f1:	55                   	push   %ebp
  8002f2:	89 e5                	mov    %esp,%ebp
  8002f4:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002f7:	83 ec 0c             	sub    $0xc,%esp
  8002fa:	6a 00                	push   $0x0
  8002fc:	e8 ce 18 00 00       	call   801bcf <sys_destroy_env>
  800301:	83 c4 10             	add    $0x10,%esp
}
  800304:	90                   	nop
  800305:	c9                   	leave  
  800306:	c3                   	ret    

00800307 <exit>:

void
exit(void)
{
  800307:	55                   	push   %ebp
  800308:	89 e5                	mov    %esp,%ebp
  80030a:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80030d:	e8 23 19 00 00       	call   801c35 <sys_exit_env>
}
  800312:	90                   	nop
  800313:	c9                   	leave  
  800314:	c3                   	ret    

00800315 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800315:	55                   	push   %ebp
  800316:	89 e5                	mov    %esp,%ebp
  800318:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80031b:	8d 45 10             	lea    0x10(%ebp),%eax
  80031e:	83 c0 04             	add    $0x4,%eax
  800321:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800324:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800329:	85 c0                	test   %eax,%eax
  80032b:	74 16                	je     800343 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80032d:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800332:	83 ec 08             	sub    $0x8,%esp
  800335:	50                   	push   %eax
  800336:	68 e4 35 80 00       	push   $0x8035e4
  80033b:	e8 89 02 00 00       	call   8005c9 <cprintf>
  800340:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800343:	a1 00 40 80 00       	mov    0x804000,%eax
  800348:	ff 75 0c             	pushl  0xc(%ebp)
  80034b:	ff 75 08             	pushl  0x8(%ebp)
  80034e:	50                   	push   %eax
  80034f:	68 e9 35 80 00       	push   $0x8035e9
  800354:	e8 70 02 00 00       	call   8005c9 <cprintf>
  800359:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80035c:	8b 45 10             	mov    0x10(%ebp),%eax
  80035f:	83 ec 08             	sub    $0x8,%esp
  800362:	ff 75 f4             	pushl  -0xc(%ebp)
  800365:	50                   	push   %eax
  800366:	e8 f3 01 00 00       	call   80055e <vcprintf>
  80036b:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80036e:	83 ec 08             	sub    $0x8,%esp
  800371:	6a 00                	push   $0x0
  800373:	68 05 36 80 00       	push   $0x803605
  800378:	e8 e1 01 00 00       	call   80055e <vcprintf>
  80037d:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800380:	e8 82 ff ff ff       	call   800307 <exit>

	// should not return here
	while (1) ;
  800385:	eb fe                	jmp    800385 <_panic+0x70>

00800387 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800387:	55                   	push   %ebp
  800388:	89 e5                	mov    %esp,%ebp
  80038a:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80038d:	a1 20 40 80 00       	mov    0x804020,%eax
  800392:	8b 50 74             	mov    0x74(%eax),%edx
  800395:	8b 45 0c             	mov    0xc(%ebp),%eax
  800398:	39 c2                	cmp    %eax,%edx
  80039a:	74 14                	je     8003b0 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80039c:	83 ec 04             	sub    $0x4,%esp
  80039f:	68 08 36 80 00       	push   $0x803608
  8003a4:	6a 26                	push   $0x26
  8003a6:	68 54 36 80 00       	push   $0x803654
  8003ab:	e8 65 ff ff ff       	call   800315 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8003b0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8003b7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003be:	e9 c2 00 00 00       	jmp    800485 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8003c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003c6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d0:	01 d0                	add    %edx,%eax
  8003d2:	8b 00                	mov    (%eax),%eax
  8003d4:	85 c0                	test   %eax,%eax
  8003d6:	75 08                	jne    8003e0 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8003d8:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003db:	e9 a2 00 00 00       	jmp    800482 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8003e0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003e7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003ee:	eb 69                	jmp    800459 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003f0:	a1 20 40 80 00       	mov    0x804020,%eax
  8003f5:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003fb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003fe:	89 d0                	mov    %edx,%eax
  800400:	01 c0                	add    %eax,%eax
  800402:	01 d0                	add    %edx,%eax
  800404:	c1 e0 03             	shl    $0x3,%eax
  800407:	01 c8                	add    %ecx,%eax
  800409:	8a 40 04             	mov    0x4(%eax),%al
  80040c:	84 c0                	test   %al,%al
  80040e:	75 46                	jne    800456 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800410:	a1 20 40 80 00       	mov    0x804020,%eax
  800415:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80041b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80041e:	89 d0                	mov    %edx,%eax
  800420:	01 c0                	add    %eax,%eax
  800422:	01 d0                	add    %edx,%eax
  800424:	c1 e0 03             	shl    $0x3,%eax
  800427:	01 c8                	add    %ecx,%eax
  800429:	8b 00                	mov    (%eax),%eax
  80042b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80042e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800431:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800436:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800438:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80043b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800442:	8b 45 08             	mov    0x8(%ebp),%eax
  800445:	01 c8                	add    %ecx,%eax
  800447:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800449:	39 c2                	cmp    %eax,%edx
  80044b:	75 09                	jne    800456 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80044d:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800454:	eb 12                	jmp    800468 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800456:	ff 45 e8             	incl   -0x18(%ebp)
  800459:	a1 20 40 80 00       	mov    0x804020,%eax
  80045e:	8b 50 74             	mov    0x74(%eax),%edx
  800461:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800464:	39 c2                	cmp    %eax,%edx
  800466:	77 88                	ja     8003f0 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800468:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80046c:	75 14                	jne    800482 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80046e:	83 ec 04             	sub    $0x4,%esp
  800471:	68 60 36 80 00       	push   $0x803660
  800476:	6a 3a                	push   $0x3a
  800478:	68 54 36 80 00       	push   $0x803654
  80047d:	e8 93 fe ff ff       	call   800315 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800482:	ff 45 f0             	incl   -0x10(%ebp)
  800485:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800488:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80048b:	0f 8c 32 ff ff ff    	jl     8003c3 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800491:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800498:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80049f:	eb 26                	jmp    8004c7 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8004a1:	a1 20 40 80 00       	mov    0x804020,%eax
  8004a6:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8004ac:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004af:	89 d0                	mov    %edx,%eax
  8004b1:	01 c0                	add    %eax,%eax
  8004b3:	01 d0                	add    %edx,%eax
  8004b5:	c1 e0 03             	shl    $0x3,%eax
  8004b8:	01 c8                	add    %ecx,%eax
  8004ba:	8a 40 04             	mov    0x4(%eax),%al
  8004bd:	3c 01                	cmp    $0x1,%al
  8004bf:	75 03                	jne    8004c4 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8004c1:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004c4:	ff 45 e0             	incl   -0x20(%ebp)
  8004c7:	a1 20 40 80 00       	mov    0x804020,%eax
  8004cc:	8b 50 74             	mov    0x74(%eax),%edx
  8004cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004d2:	39 c2                	cmp    %eax,%edx
  8004d4:	77 cb                	ja     8004a1 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004d9:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004dc:	74 14                	je     8004f2 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8004de:	83 ec 04             	sub    $0x4,%esp
  8004e1:	68 b4 36 80 00       	push   $0x8036b4
  8004e6:	6a 44                	push   $0x44
  8004e8:	68 54 36 80 00       	push   $0x803654
  8004ed:	e8 23 fe ff ff       	call   800315 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004f2:	90                   	nop
  8004f3:	c9                   	leave  
  8004f4:	c3                   	ret    

008004f5 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8004f5:	55                   	push   %ebp
  8004f6:	89 e5                	mov    %esp,%ebp
  8004f8:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8004fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004fe:	8b 00                	mov    (%eax),%eax
  800500:	8d 48 01             	lea    0x1(%eax),%ecx
  800503:	8b 55 0c             	mov    0xc(%ebp),%edx
  800506:	89 0a                	mov    %ecx,(%edx)
  800508:	8b 55 08             	mov    0x8(%ebp),%edx
  80050b:	88 d1                	mov    %dl,%cl
  80050d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800510:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800514:	8b 45 0c             	mov    0xc(%ebp),%eax
  800517:	8b 00                	mov    (%eax),%eax
  800519:	3d ff 00 00 00       	cmp    $0xff,%eax
  80051e:	75 2c                	jne    80054c <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800520:	a0 24 40 80 00       	mov    0x804024,%al
  800525:	0f b6 c0             	movzbl %al,%eax
  800528:	8b 55 0c             	mov    0xc(%ebp),%edx
  80052b:	8b 12                	mov    (%edx),%edx
  80052d:	89 d1                	mov    %edx,%ecx
  80052f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800532:	83 c2 08             	add    $0x8,%edx
  800535:	83 ec 04             	sub    $0x4,%esp
  800538:	50                   	push   %eax
  800539:	51                   	push   %ecx
  80053a:	52                   	push   %edx
  80053b:	e8 22 13 00 00       	call   801862 <sys_cputs>
  800540:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800543:	8b 45 0c             	mov    0xc(%ebp),%eax
  800546:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80054c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80054f:	8b 40 04             	mov    0x4(%eax),%eax
  800552:	8d 50 01             	lea    0x1(%eax),%edx
  800555:	8b 45 0c             	mov    0xc(%ebp),%eax
  800558:	89 50 04             	mov    %edx,0x4(%eax)
}
  80055b:	90                   	nop
  80055c:	c9                   	leave  
  80055d:	c3                   	ret    

0080055e <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80055e:	55                   	push   %ebp
  80055f:	89 e5                	mov    %esp,%ebp
  800561:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800567:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80056e:	00 00 00 
	b.cnt = 0;
  800571:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800578:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80057b:	ff 75 0c             	pushl  0xc(%ebp)
  80057e:	ff 75 08             	pushl  0x8(%ebp)
  800581:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800587:	50                   	push   %eax
  800588:	68 f5 04 80 00       	push   $0x8004f5
  80058d:	e8 11 02 00 00       	call   8007a3 <vprintfmt>
  800592:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800595:	a0 24 40 80 00       	mov    0x804024,%al
  80059a:	0f b6 c0             	movzbl %al,%eax
  80059d:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8005a3:	83 ec 04             	sub    $0x4,%esp
  8005a6:	50                   	push   %eax
  8005a7:	52                   	push   %edx
  8005a8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005ae:	83 c0 08             	add    $0x8,%eax
  8005b1:	50                   	push   %eax
  8005b2:	e8 ab 12 00 00       	call   801862 <sys_cputs>
  8005b7:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005ba:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  8005c1:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005c7:	c9                   	leave  
  8005c8:	c3                   	ret    

008005c9 <cprintf>:

int cprintf(const char *fmt, ...) {
  8005c9:	55                   	push   %ebp
  8005ca:	89 e5                	mov    %esp,%ebp
  8005cc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005cf:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  8005d6:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8005df:	83 ec 08             	sub    $0x8,%esp
  8005e2:	ff 75 f4             	pushl  -0xc(%ebp)
  8005e5:	50                   	push   %eax
  8005e6:	e8 73 ff ff ff       	call   80055e <vcprintf>
  8005eb:	83 c4 10             	add    $0x10,%esp
  8005ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005f4:	c9                   	leave  
  8005f5:	c3                   	ret    

008005f6 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8005f6:	55                   	push   %ebp
  8005f7:	89 e5                	mov    %esp,%ebp
  8005f9:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005fc:	e8 0f 14 00 00       	call   801a10 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800601:	8d 45 0c             	lea    0xc(%ebp),%eax
  800604:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800607:	8b 45 08             	mov    0x8(%ebp),%eax
  80060a:	83 ec 08             	sub    $0x8,%esp
  80060d:	ff 75 f4             	pushl  -0xc(%ebp)
  800610:	50                   	push   %eax
  800611:	e8 48 ff ff ff       	call   80055e <vcprintf>
  800616:	83 c4 10             	add    $0x10,%esp
  800619:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80061c:	e8 09 14 00 00       	call   801a2a <sys_enable_interrupt>
	return cnt;
  800621:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800624:	c9                   	leave  
  800625:	c3                   	ret    

00800626 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800626:	55                   	push   %ebp
  800627:	89 e5                	mov    %esp,%ebp
  800629:	53                   	push   %ebx
  80062a:	83 ec 14             	sub    $0x14,%esp
  80062d:	8b 45 10             	mov    0x10(%ebp),%eax
  800630:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800633:	8b 45 14             	mov    0x14(%ebp),%eax
  800636:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800639:	8b 45 18             	mov    0x18(%ebp),%eax
  80063c:	ba 00 00 00 00       	mov    $0x0,%edx
  800641:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800644:	77 55                	ja     80069b <printnum+0x75>
  800646:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800649:	72 05                	jb     800650 <printnum+0x2a>
  80064b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80064e:	77 4b                	ja     80069b <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800650:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800653:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800656:	8b 45 18             	mov    0x18(%ebp),%eax
  800659:	ba 00 00 00 00       	mov    $0x0,%edx
  80065e:	52                   	push   %edx
  80065f:	50                   	push   %eax
  800660:	ff 75 f4             	pushl  -0xc(%ebp)
  800663:	ff 75 f0             	pushl  -0x10(%ebp)
  800666:	e8 b5 29 00 00       	call   803020 <__udivdi3>
  80066b:	83 c4 10             	add    $0x10,%esp
  80066e:	83 ec 04             	sub    $0x4,%esp
  800671:	ff 75 20             	pushl  0x20(%ebp)
  800674:	53                   	push   %ebx
  800675:	ff 75 18             	pushl  0x18(%ebp)
  800678:	52                   	push   %edx
  800679:	50                   	push   %eax
  80067a:	ff 75 0c             	pushl  0xc(%ebp)
  80067d:	ff 75 08             	pushl  0x8(%ebp)
  800680:	e8 a1 ff ff ff       	call   800626 <printnum>
  800685:	83 c4 20             	add    $0x20,%esp
  800688:	eb 1a                	jmp    8006a4 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80068a:	83 ec 08             	sub    $0x8,%esp
  80068d:	ff 75 0c             	pushl  0xc(%ebp)
  800690:	ff 75 20             	pushl  0x20(%ebp)
  800693:	8b 45 08             	mov    0x8(%ebp),%eax
  800696:	ff d0                	call   *%eax
  800698:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80069b:	ff 4d 1c             	decl   0x1c(%ebp)
  80069e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006a2:	7f e6                	jg     80068a <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006a4:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006a7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006b2:	53                   	push   %ebx
  8006b3:	51                   	push   %ecx
  8006b4:	52                   	push   %edx
  8006b5:	50                   	push   %eax
  8006b6:	e8 75 2a 00 00       	call   803130 <__umoddi3>
  8006bb:	83 c4 10             	add    $0x10,%esp
  8006be:	05 14 39 80 00       	add    $0x803914,%eax
  8006c3:	8a 00                	mov    (%eax),%al
  8006c5:	0f be c0             	movsbl %al,%eax
  8006c8:	83 ec 08             	sub    $0x8,%esp
  8006cb:	ff 75 0c             	pushl  0xc(%ebp)
  8006ce:	50                   	push   %eax
  8006cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d2:	ff d0                	call   *%eax
  8006d4:	83 c4 10             	add    $0x10,%esp
}
  8006d7:	90                   	nop
  8006d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006db:	c9                   	leave  
  8006dc:	c3                   	ret    

008006dd <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006dd:	55                   	push   %ebp
  8006de:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006e0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006e4:	7e 1c                	jle    800702 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8006e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e9:	8b 00                	mov    (%eax),%eax
  8006eb:	8d 50 08             	lea    0x8(%eax),%edx
  8006ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f1:	89 10                	mov    %edx,(%eax)
  8006f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f6:	8b 00                	mov    (%eax),%eax
  8006f8:	83 e8 08             	sub    $0x8,%eax
  8006fb:	8b 50 04             	mov    0x4(%eax),%edx
  8006fe:	8b 00                	mov    (%eax),%eax
  800700:	eb 40                	jmp    800742 <getuint+0x65>
	else if (lflag)
  800702:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800706:	74 1e                	je     800726 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800708:	8b 45 08             	mov    0x8(%ebp),%eax
  80070b:	8b 00                	mov    (%eax),%eax
  80070d:	8d 50 04             	lea    0x4(%eax),%edx
  800710:	8b 45 08             	mov    0x8(%ebp),%eax
  800713:	89 10                	mov    %edx,(%eax)
  800715:	8b 45 08             	mov    0x8(%ebp),%eax
  800718:	8b 00                	mov    (%eax),%eax
  80071a:	83 e8 04             	sub    $0x4,%eax
  80071d:	8b 00                	mov    (%eax),%eax
  80071f:	ba 00 00 00 00       	mov    $0x0,%edx
  800724:	eb 1c                	jmp    800742 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800726:	8b 45 08             	mov    0x8(%ebp),%eax
  800729:	8b 00                	mov    (%eax),%eax
  80072b:	8d 50 04             	lea    0x4(%eax),%edx
  80072e:	8b 45 08             	mov    0x8(%ebp),%eax
  800731:	89 10                	mov    %edx,(%eax)
  800733:	8b 45 08             	mov    0x8(%ebp),%eax
  800736:	8b 00                	mov    (%eax),%eax
  800738:	83 e8 04             	sub    $0x4,%eax
  80073b:	8b 00                	mov    (%eax),%eax
  80073d:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800742:	5d                   	pop    %ebp
  800743:	c3                   	ret    

00800744 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800744:	55                   	push   %ebp
  800745:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800747:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80074b:	7e 1c                	jle    800769 <getint+0x25>
		return va_arg(*ap, long long);
  80074d:	8b 45 08             	mov    0x8(%ebp),%eax
  800750:	8b 00                	mov    (%eax),%eax
  800752:	8d 50 08             	lea    0x8(%eax),%edx
  800755:	8b 45 08             	mov    0x8(%ebp),%eax
  800758:	89 10                	mov    %edx,(%eax)
  80075a:	8b 45 08             	mov    0x8(%ebp),%eax
  80075d:	8b 00                	mov    (%eax),%eax
  80075f:	83 e8 08             	sub    $0x8,%eax
  800762:	8b 50 04             	mov    0x4(%eax),%edx
  800765:	8b 00                	mov    (%eax),%eax
  800767:	eb 38                	jmp    8007a1 <getint+0x5d>
	else if (lflag)
  800769:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80076d:	74 1a                	je     800789 <getint+0x45>
		return va_arg(*ap, long);
  80076f:	8b 45 08             	mov    0x8(%ebp),%eax
  800772:	8b 00                	mov    (%eax),%eax
  800774:	8d 50 04             	lea    0x4(%eax),%edx
  800777:	8b 45 08             	mov    0x8(%ebp),%eax
  80077a:	89 10                	mov    %edx,(%eax)
  80077c:	8b 45 08             	mov    0x8(%ebp),%eax
  80077f:	8b 00                	mov    (%eax),%eax
  800781:	83 e8 04             	sub    $0x4,%eax
  800784:	8b 00                	mov    (%eax),%eax
  800786:	99                   	cltd   
  800787:	eb 18                	jmp    8007a1 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800789:	8b 45 08             	mov    0x8(%ebp),%eax
  80078c:	8b 00                	mov    (%eax),%eax
  80078e:	8d 50 04             	lea    0x4(%eax),%edx
  800791:	8b 45 08             	mov    0x8(%ebp),%eax
  800794:	89 10                	mov    %edx,(%eax)
  800796:	8b 45 08             	mov    0x8(%ebp),%eax
  800799:	8b 00                	mov    (%eax),%eax
  80079b:	83 e8 04             	sub    $0x4,%eax
  80079e:	8b 00                	mov    (%eax),%eax
  8007a0:	99                   	cltd   
}
  8007a1:	5d                   	pop    %ebp
  8007a2:	c3                   	ret    

008007a3 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007a3:	55                   	push   %ebp
  8007a4:	89 e5                	mov    %esp,%ebp
  8007a6:	56                   	push   %esi
  8007a7:	53                   	push   %ebx
  8007a8:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007ab:	eb 17                	jmp    8007c4 <vprintfmt+0x21>
			if (ch == '\0')
  8007ad:	85 db                	test   %ebx,%ebx
  8007af:	0f 84 af 03 00 00    	je     800b64 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8007b5:	83 ec 08             	sub    $0x8,%esp
  8007b8:	ff 75 0c             	pushl  0xc(%ebp)
  8007bb:	53                   	push   %ebx
  8007bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bf:	ff d0                	call   *%eax
  8007c1:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8007c7:	8d 50 01             	lea    0x1(%eax),%edx
  8007ca:	89 55 10             	mov    %edx,0x10(%ebp)
  8007cd:	8a 00                	mov    (%eax),%al
  8007cf:	0f b6 d8             	movzbl %al,%ebx
  8007d2:	83 fb 25             	cmp    $0x25,%ebx
  8007d5:	75 d6                	jne    8007ad <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007d7:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007db:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8007e2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007e9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8007f0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8007fa:	8d 50 01             	lea    0x1(%eax),%edx
  8007fd:	89 55 10             	mov    %edx,0x10(%ebp)
  800800:	8a 00                	mov    (%eax),%al
  800802:	0f b6 d8             	movzbl %al,%ebx
  800805:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800808:	83 f8 55             	cmp    $0x55,%eax
  80080b:	0f 87 2b 03 00 00    	ja     800b3c <vprintfmt+0x399>
  800811:	8b 04 85 38 39 80 00 	mov    0x803938(,%eax,4),%eax
  800818:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80081a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80081e:	eb d7                	jmp    8007f7 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800820:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800824:	eb d1                	jmp    8007f7 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800826:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80082d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800830:	89 d0                	mov    %edx,%eax
  800832:	c1 e0 02             	shl    $0x2,%eax
  800835:	01 d0                	add    %edx,%eax
  800837:	01 c0                	add    %eax,%eax
  800839:	01 d8                	add    %ebx,%eax
  80083b:	83 e8 30             	sub    $0x30,%eax
  80083e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800841:	8b 45 10             	mov    0x10(%ebp),%eax
  800844:	8a 00                	mov    (%eax),%al
  800846:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800849:	83 fb 2f             	cmp    $0x2f,%ebx
  80084c:	7e 3e                	jle    80088c <vprintfmt+0xe9>
  80084e:	83 fb 39             	cmp    $0x39,%ebx
  800851:	7f 39                	jg     80088c <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800853:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800856:	eb d5                	jmp    80082d <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800858:	8b 45 14             	mov    0x14(%ebp),%eax
  80085b:	83 c0 04             	add    $0x4,%eax
  80085e:	89 45 14             	mov    %eax,0x14(%ebp)
  800861:	8b 45 14             	mov    0x14(%ebp),%eax
  800864:	83 e8 04             	sub    $0x4,%eax
  800867:	8b 00                	mov    (%eax),%eax
  800869:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80086c:	eb 1f                	jmp    80088d <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80086e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800872:	79 83                	jns    8007f7 <vprintfmt+0x54>
				width = 0;
  800874:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80087b:	e9 77 ff ff ff       	jmp    8007f7 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800880:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800887:	e9 6b ff ff ff       	jmp    8007f7 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80088c:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80088d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800891:	0f 89 60 ff ff ff    	jns    8007f7 <vprintfmt+0x54>
				width = precision, precision = -1;
  800897:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80089a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80089d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008a4:	e9 4e ff ff ff       	jmp    8007f7 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008a9:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008ac:	e9 46 ff ff ff       	jmp    8007f7 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b4:	83 c0 04             	add    $0x4,%eax
  8008b7:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8008bd:	83 e8 04             	sub    $0x4,%eax
  8008c0:	8b 00                	mov    (%eax),%eax
  8008c2:	83 ec 08             	sub    $0x8,%esp
  8008c5:	ff 75 0c             	pushl  0xc(%ebp)
  8008c8:	50                   	push   %eax
  8008c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cc:	ff d0                	call   *%eax
  8008ce:	83 c4 10             	add    $0x10,%esp
			break;
  8008d1:	e9 89 02 00 00       	jmp    800b5f <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d9:	83 c0 04             	add    $0x4,%eax
  8008dc:	89 45 14             	mov    %eax,0x14(%ebp)
  8008df:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e2:	83 e8 04             	sub    $0x4,%eax
  8008e5:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008e7:	85 db                	test   %ebx,%ebx
  8008e9:	79 02                	jns    8008ed <vprintfmt+0x14a>
				err = -err;
  8008eb:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008ed:	83 fb 64             	cmp    $0x64,%ebx
  8008f0:	7f 0b                	jg     8008fd <vprintfmt+0x15a>
  8008f2:	8b 34 9d 80 37 80 00 	mov    0x803780(,%ebx,4),%esi
  8008f9:	85 f6                	test   %esi,%esi
  8008fb:	75 19                	jne    800916 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008fd:	53                   	push   %ebx
  8008fe:	68 25 39 80 00       	push   $0x803925
  800903:	ff 75 0c             	pushl  0xc(%ebp)
  800906:	ff 75 08             	pushl  0x8(%ebp)
  800909:	e8 5e 02 00 00       	call   800b6c <printfmt>
  80090e:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800911:	e9 49 02 00 00       	jmp    800b5f <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800916:	56                   	push   %esi
  800917:	68 2e 39 80 00       	push   $0x80392e
  80091c:	ff 75 0c             	pushl  0xc(%ebp)
  80091f:	ff 75 08             	pushl  0x8(%ebp)
  800922:	e8 45 02 00 00       	call   800b6c <printfmt>
  800927:	83 c4 10             	add    $0x10,%esp
			break;
  80092a:	e9 30 02 00 00       	jmp    800b5f <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80092f:	8b 45 14             	mov    0x14(%ebp),%eax
  800932:	83 c0 04             	add    $0x4,%eax
  800935:	89 45 14             	mov    %eax,0x14(%ebp)
  800938:	8b 45 14             	mov    0x14(%ebp),%eax
  80093b:	83 e8 04             	sub    $0x4,%eax
  80093e:	8b 30                	mov    (%eax),%esi
  800940:	85 f6                	test   %esi,%esi
  800942:	75 05                	jne    800949 <vprintfmt+0x1a6>
				p = "(null)";
  800944:	be 31 39 80 00       	mov    $0x803931,%esi
			if (width > 0 && padc != '-')
  800949:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80094d:	7e 6d                	jle    8009bc <vprintfmt+0x219>
  80094f:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800953:	74 67                	je     8009bc <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800955:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800958:	83 ec 08             	sub    $0x8,%esp
  80095b:	50                   	push   %eax
  80095c:	56                   	push   %esi
  80095d:	e8 0c 03 00 00       	call   800c6e <strnlen>
  800962:	83 c4 10             	add    $0x10,%esp
  800965:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800968:	eb 16                	jmp    800980 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80096a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80096e:	83 ec 08             	sub    $0x8,%esp
  800971:	ff 75 0c             	pushl  0xc(%ebp)
  800974:	50                   	push   %eax
  800975:	8b 45 08             	mov    0x8(%ebp),%eax
  800978:	ff d0                	call   *%eax
  80097a:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80097d:	ff 4d e4             	decl   -0x1c(%ebp)
  800980:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800984:	7f e4                	jg     80096a <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800986:	eb 34                	jmp    8009bc <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800988:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80098c:	74 1c                	je     8009aa <vprintfmt+0x207>
  80098e:	83 fb 1f             	cmp    $0x1f,%ebx
  800991:	7e 05                	jle    800998 <vprintfmt+0x1f5>
  800993:	83 fb 7e             	cmp    $0x7e,%ebx
  800996:	7e 12                	jle    8009aa <vprintfmt+0x207>
					putch('?', putdat);
  800998:	83 ec 08             	sub    $0x8,%esp
  80099b:	ff 75 0c             	pushl  0xc(%ebp)
  80099e:	6a 3f                	push   $0x3f
  8009a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a3:	ff d0                	call   *%eax
  8009a5:	83 c4 10             	add    $0x10,%esp
  8009a8:	eb 0f                	jmp    8009b9 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009aa:	83 ec 08             	sub    $0x8,%esp
  8009ad:	ff 75 0c             	pushl  0xc(%ebp)
  8009b0:	53                   	push   %ebx
  8009b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b4:	ff d0                	call   *%eax
  8009b6:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009b9:	ff 4d e4             	decl   -0x1c(%ebp)
  8009bc:	89 f0                	mov    %esi,%eax
  8009be:	8d 70 01             	lea    0x1(%eax),%esi
  8009c1:	8a 00                	mov    (%eax),%al
  8009c3:	0f be d8             	movsbl %al,%ebx
  8009c6:	85 db                	test   %ebx,%ebx
  8009c8:	74 24                	je     8009ee <vprintfmt+0x24b>
  8009ca:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009ce:	78 b8                	js     800988 <vprintfmt+0x1e5>
  8009d0:	ff 4d e0             	decl   -0x20(%ebp)
  8009d3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009d7:	79 af                	jns    800988 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009d9:	eb 13                	jmp    8009ee <vprintfmt+0x24b>
				putch(' ', putdat);
  8009db:	83 ec 08             	sub    $0x8,%esp
  8009de:	ff 75 0c             	pushl  0xc(%ebp)
  8009e1:	6a 20                	push   $0x20
  8009e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e6:	ff d0                	call   *%eax
  8009e8:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009eb:	ff 4d e4             	decl   -0x1c(%ebp)
  8009ee:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009f2:	7f e7                	jg     8009db <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8009f4:	e9 66 01 00 00       	jmp    800b5f <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009f9:	83 ec 08             	sub    $0x8,%esp
  8009fc:	ff 75 e8             	pushl  -0x18(%ebp)
  8009ff:	8d 45 14             	lea    0x14(%ebp),%eax
  800a02:	50                   	push   %eax
  800a03:	e8 3c fd ff ff       	call   800744 <getint>
  800a08:	83 c4 10             	add    $0x10,%esp
  800a0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a0e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a14:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a17:	85 d2                	test   %edx,%edx
  800a19:	79 23                	jns    800a3e <vprintfmt+0x29b>
				putch('-', putdat);
  800a1b:	83 ec 08             	sub    $0x8,%esp
  800a1e:	ff 75 0c             	pushl  0xc(%ebp)
  800a21:	6a 2d                	push   $0x2d
  800a23:	8b 45 08             	mov    0x8(%ebp),%eax
  800a26:	ff d0                	call   *%eax
  800a28:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a31:	f7 d8                	neg    %eax
  800a33:	83 d2 00             	adc    $0x0,%edx
  800a36:	f7 da                	neg    %edx
  800a38:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a3b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a3e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a45:	e9 bc 00 00 00       	jmp    800b06 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a4a:	83 ec 08             	sub    $0x8,%esp
  800a4d:	ff 75 e8             	pushl  -0x18(%ebp)
  800a50:	8d 45 14             	lea    0x14(%ebp),%eax
  800a53:	50                   	push   %eax
  800a54:	e8 84 fc ff ff       	call   8006dd <getuint>
  800a59:	83 c4 10             	add    $0x10,%esp
  800a5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a5f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a62:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a69:	e9 98 00 00 00       	jmp    800b06 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a6e:	83 ec 08             	sub    $0x8,%esp
  800a71:	ff 75 0c             	pushl  0xc(%ebp)
  800a74:	6a 58                	push   $0x58
  800a76:	8b 45 08             	mov    0x8(%ebp),%eax
  800a79:	ff d0                	call   *%eax
  800a7b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a7e:	83 ec 08             	sub    $0x8,%esp
  800a81:	ff 75 0c             	pushl  0xc(%ebp)
  800a84:	6a 58                	push   $0x58
  800a86:	8b 45 08             	mov    0x8(%ebp),%eax
  800a89:	ff d0                	call   *%eax
  800a8b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a8e:	83 ec 08             	sub    $0x8,%esp
  800a91:	ff 75 0c             	pushl  0xc(%ebp)
  800a94:	6a 58                	push   $0x58
  800a96:	8b 45 08             	mov    0x8(%ebp),%eax
  800a99:	ff d0                	call   *%eax
  800a9b:	83 c4 10             	add    $0x10,%esp
			break;
  800a9e:	e9 bc 00 00 00       	jmp    800b5f <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800aa3:	83 ec 08             	sub    $0x8,%esp
  800aa6:	ff 75 0c             	pushl  0xc(%ebp)
  800aa9:	6a 30                	push   $0x30
  800aab:	8b 45 08             	mov    0x8(%ebp),%eax
  800aae:	ff d0                	call   *%eax
  800ab0:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ab3:	83 ec 08             	sub    $0x8,%esp
  800ab6:	ff 75 0c             	pushl  0xc(%ebp)
  800ab9:	6a 78                	push   $0x78
  800abb:	8b 45 08             	mov    0x8(%ebp),%eax
  800abe:	ff d0                	call   *%eax
  800ac0:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ac3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac6:	83 c0 04             	add    $0x4,%eax
  800ac9:	89 45 14             	mov    %eax,0x14(%ebp)
  800acc:	8b 45 14             	mov    0x14(%ebp),%eax
  800acf:	83 e8 04             	sub    $0x4,%eax
  800ad2:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ad4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ad7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ade:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ae5:	eb 1f                	jmp    800b06 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ae7:	83 ec 08             	sub    $0x8,%esp
  800aea:	ff 75 e8             	pushl  -0x18(%ebp)
  800aed:	8d 45 14             	lea    0x14(%ebp),%eax
  800af0:	50                   	push   %eax
  800af1:	e8 e7 fb ff ff       	call   8006dd <getuint>
  800af6:	83 c4 10             	add    $0x10,%esp
  800af9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800afc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800aff:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b06:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b0d:	83 ec 04             	sub    $0x4,%esp
  800b10:	52                   	push   %edx
  800b11:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b14:	50                   	push   %eax
  800b15:	ff 75 f4             	pushl  -0xc(%ebp)
  800b18:	ff 75 f0             	pushl  -0x10(%ebp)
  800b1b:	ff 75 0c             	pushl  0xc(%ebp)
  800b1e:	ff 75 08             	pushl  0x8(%ebp)
  800b21:	e8 00 fb ff ff       	call   800626 <printnum>
  800b26:	83 c4 20             	add    $0x20,%esp
			break;
  800b29:	eb 34                	jmp    800b5f <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b2b:	83 ec 08             	sub    $0x8,%esp
  800b2e:	ff 75 0c             	pushl  0xc(%ebp)
  800b31:	53                   	push   %ebx
  800b32:	8b 45 08             	mov    0x8(%ebp),%eax
  800b35:	ff d0                	call   *%eax
  800b37:	83 c4 10             	add    $0x10,%esp
			break;
  800b3a:	eb 23                	jmp    800b5f <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b3c:	83 ec 08             	sub    $0x8,%esp
  800b3f:	ff 75 0c             	pushl  0xc(%ebp)
  800b42:	6a 25                	push   $0x25
  800b44:	8b 45 08             	mov    0x8(%ebp),%eax
  800b47:	ff d0                	call   *%eax
  800b49:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b4c:	ff 4d 10             	decl   0x10(%ebp)
  800b4f:	eb 03                	jmp    800b54 <vprintfmt+0x3b1>
  800b51:	ff 4d 10             	decl   0x10(%ebp)
  800b54:	8b 45 10             	mov    0x10(%ebp),%eax
  800b57:	48                   	dec    %eax
  800b58:	8a 00                	mov    (%eax),%al
  800b5a:	3c 25                	cmp    $0x25,%al
  800b5c:	75 f3                	jne    800b51 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b5e:	90                   	nop
		}
	}
  800b5f:	e9 47 fc ff ff       	jmp    8007ab <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b64:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b65:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b68:	5b                   	pop    %ebx
  800b69:	5e                   	pop    %esi
  800b6a:	5d                   	pop    %ebp
  800b6b:	c3                   	ret    

00800b6c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b6c:	55                   	push   %ebp
  800b6d:	89 e5                	mov    %esp,%ebp
  800b6f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b72:	8d 45 10             	lea    0x10(%ebp),%eax
  800b75:	83 c0 04             	add    $0x4,%eax
  800b78:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b7b:	8b 45 10             	mov    0x10(%ebp),%eax
  800b7e:	ff 75 f4             	pushl  -0xc(%ebp)
  800b81:	50                   	push   %eax
  800b82:	ff 75 0c             	pushl  0xc(%ebp)
  800b85:	ff 75 08             	pushl  0x8(%ebp)
  800b88:	e8 16 fc ff ff       	call   8007a3 <vprintfmt>
  800b8d:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b90:	90                   	nop
  800b91:	c9                   	leave  
  800b92:	c3                   	ret    

00800b93 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b93:	55                   	push   %ebp
  800b94:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b99:	8b 40 08             	mov    0x8(%eax),%eax
  800b9c:	8d 50 01             	lea    0x1(%eax),%edx
  800b9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba2:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800ba5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba8:	8b 10                	mov    (%eax),%edx
  800baa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bad:	8b 40 04             	mov    0x4(%eax),%eax
  800bb0:	39 c2                	cmp    %eax,%edx
  800bb2:	73 12                	jae    800bc6 <sprintputch+0x33>
		*b->buf++ = ch;
  800bb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb7:	8b 00                	mov    (%eax),%eax
  800bb9:	8d 48 01             	lea    0x1(%eax),%ecx
  800bbc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bbf:	89 0a                	mov    %ecx,(%edx)
  800bc1:	8b 55 08             	mov    0x8(%ebp),%edx
  800bc4:	88 10                	mov    %dl,(%eax)
}
  800bc6:	90                   	nop
  800bc7:	5d                   	pop    %ebp
  800bc8:	c3                   	ret    

00800bc9 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800bc9:	55                   	push   %ebp
  800bca:	89 e5                	mov    %esp,%ebp
  800bcc:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800bd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bde:	01 d0                	add    %edx,%eax
  800be0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800be3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800bea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800bee:	74 06                	je     800bf6 <vsnprintf+0x2d>
  800bf0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bf4:	7f 07                	jg     800bfd <vsnprintf+0x34>
		return -E_INVAL;
  800bf6:	b8 03 00 00 00       	mov    $0x3,%eax
  800bfb:	eb 20                	jmp    800c1d <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bfd:	ff 75 14             	pushl  0x14(%ebp)
  800c00:	ff 75 10             	pushl  0x10(%ebp)
  800c03:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c06:	50                   	push   %eax
  800c07:	68 93 0b 80 00       	push   $0x800b93
  800c0c:	e8 92 fb ff ff       	call   8007a3 <vprintfmt>
  800c11:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c17:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c1d:	c9                   	leave  
  800c1e:	c3                   	ret    

00800c1f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c1f:	55                   	push   %ebp
  800c20:	89 e5                	mov    %esp,%ebp
  800c22:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c25:	8d 45 10             	lea    0x10(%ebp),%eax
  800c28:	83 c0 04             	add    $0x4,%eax
  800c2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c2e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c31:	ff 75 f4             	pushl  -0xc(%ebp)
  800c34:	50                   	push   %eax
  800c35:	ff 75 0c             	pushl  0xc(%ebp)
  800c38:	ff 75 08             	pushl  0x8(%ebp)
  800c3b:	e8 89 ff ff ff       	call   800bc9 <vsnprintf>
  800c40:	83 c4 10             	add    $0x10,%esp
  800c43:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c46:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c49:	c9                   	leave  
  800c4a:	c3                   	ret    

00800c4b <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c4b:	55                   	push   %ebp
  800c4c:	89 e5                	mov    %esp,%ebp
  800c4e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c51:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c58:	eb 06                	jmp    800c60 <strlen+0x15>
		n++;
  800c5a:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c5d:	ff 45 08             	incl   0x8(%ebp)
  800c60:	8b 45 08             	mov    0x8(%ebp),%eax
  800c63:	8a 00                	mov    (%eax),%al
  800c65:	84 c0                	test   %al,%al
  800c67:	75 f1                	jne    800c5a <strlen+0xf>
		n++;
	return n;
  800c69:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c6c:	c9                   	leave  
  800c6d:	c3                   	ret    

00800c6e <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c6e:	55                   	push   %ebp
  800c6f:	89 e5                	mov    %esp,%ebp
  800c71:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c74:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c7b:	eb 09                	jmp    800c86 <strnlen+0x18>
		n++;
  800c7d:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c80:	ff 45 08             	incl   0x8(%ebp)
  800c83:	ff 4d 0c             	decl   0xc(%ebp)
  800c86:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c8a:	74 09                	je     800c95 <strnlen+0x27>
  800c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8f:	8a 00                	mov    (%eax),%al
  800c91:	84 c0                	test   %al,%al
  800c93:	75 e8                	jne    800c7d <strnlen+0xf>
		n++;
	return n;
  800c95:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c98:	c9                   	leave  
  800c99:	c3                   	ret    

00800c9a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c9a:	55                   	push   %ebp
  800c9b:	89 e5                	mov    %esp,%ebp
  800c9d:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800ca6:	90                   	nop
  800ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  800caa:	8d 50 01             	lea    0x1(%eax),%edx
  800cad:	89 55 08             	mov    %edx,0x8(%ebp)
  800cb0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cb3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cb6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cb9:	8a 12                	mov    (%edx),%dl
  800cbb:	88 10                	mov    %dl,(%eax)
  800cbd:	8a 00                	mov    (%eax),%al
  800cbf:	84 c0                	test   %al,%al
  800cc1:	75 e4                	jne    800ca7 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800cc3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cc6:	c9                   	leave  
  800cc7:	c3                   	ret    

00800cc8 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800cc8:	55                   	push   %ebp
  800cc9:	89 e5                	mov    %esp,%ebp
  800ccb:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800cce:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800cd4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cdb:	eb 1f                	jmp    800cfc <strncpy+0x34>
		*dst++ = *src;
  800cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce0:	8d 50 01             	lea    0x1(%eax),%edx
  800ce3:	89 55 08             	mov    %edx,0x8(%ebp)
  800ce6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ce9:	8a 12                	mov    (%edx),%dl
  800ceb:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ced:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf0:	8a 00                	mov    (%eax),%al
  800cf2:	84 c0                	test   %al,%al
  800cf4:	74 03                	je     800cf9 <strncpy+0x31>
			src++;
  800cf6:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800cf9:	ff 45 fc             	incl   -0x4(%ebp)
  800cfc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cff:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d02:	72 d9                	jb     800cdd <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d04:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d07:	c9                   	leave  
  800d08:	c3                   	ret    

00800d09 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d09:	55                   	push   %ebp
  800d0a:	89 e5                	mov    %esp,%ebp
  800d0c:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d12:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d15:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d19:	74 30                	je     800d4b <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d1b:	eb 16                	jmp    800d33 <strlcpy+0x2a>
			*dst++ = *src++;
  800d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d20:	8d 50 01             	lea    0x1(%eax),%edx
  800d23:	89 55 08             	mov    %edx,0x8(%ebp)
  800d26:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d29:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d2c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d2f:	8a 12                	mov    (%edx),%dl
  800d31:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d33:	ff 4d 10             	decl   0x10(%ebp)
  800d36:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d3a:	74 09                	je     800d45 <strlcpy+0x3c>
  800d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3f:	8a 00                	mov    (%eax),%al
  800d41:	84 c0                	test   %al,%al
  800d43:	75 d8                	jne    800d1d <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d45:	8b 45 08             	mov    0x8(%ebp),%eax
  800d48:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d4b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d51:	29 c2                	sub    %eax,%edx
  800d53:	89 d0                	mov    %edx,%eax
}
  800d55:	c9                   	leave  
  800d56:	c3                   	ret    

00800d57 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d57:	55                   	push   %ebp
  800d58:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d5a:	eb 06                	jmp    800d62 <strcmp+0xb>
		p++, q++;
  800d5c:	ff 45 08             	incl   0x8(%ebp)
  800d5f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d62:	8b 45 08             	mov    0x8(%ebp),%eax
  800d65:	8a 00                	mov    (%eax),%al
  800d67:	84 c0                	test   %al,%al
  800d69:	74 0e                	je     800d79 <strcmp+0x22>
  800d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6e:	8a 10                	mov    (%eax),%dl
  800d70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d73:	8a 00                	mov    (%eax),%al
  800d75:	38 c2                	cmp    %al,%dl
  800d77:	74 e3                	je     800d5c <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d79:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7c:	8a 00                	mov    (%eax),%al
  800d7e:	0f b6 d0             	movzbl %al,%edx
  800d81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d84:	8a 00                	mov    (%eax),%al
  800d86:	0f b6 c0             	movzbl %al,%eax
  800d89:	29 c2                	sub    %eax,%edx
  800d8b:	89 d0                	mov    %edx,%eax
}
  800d8d:	5d                   	pop    %ebp
  800d8e:	c3                   	ret    

00800d8f <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d8f:	55                   	push   %ebp
  800d90:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d92:	eb 09                	jmp    800d9d <strncmp+0xe>
		n--, p++, q++;
  800d94:	ff 4d 10             	decl   0x10(%ebp)
  800d97:	ff 45 08             	incl   0x8(%ebp)
  800d9a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d9d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800da1:	74 17                	je     800dba <strncmp+0x2b>
  800da3:	8b 45 08             	mov    0x8(%ebp),%eax
  800da6:	8a 00                	mov    (%eax),%al
  800da8:	84 c0                	test   %al,%al
  800daa:	74 0e                	je     800dba <strncmp+0x2b>
  800dac:	8b 45 08             	mov    0x8(%ebp),%eax
  800daf:	8a 10                	mov    (%eax),%dl
  800db1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db4:	8a 00                	mov    (%eax),%al
  800db6:	38 c2                	cmp    %al,%dl
  800db8:	74 da                	je     800d94 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800dba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dbe:	75 07                	jne    800dc7 <strncmp+0x38>
		return 0;
  800dc0:	b8 00 00 00 00       	mov    $0x0,%eax
  800dc5:	eb 14                	jmp    800ddb <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dca:	8a 00                	mov    (%eax),%al
  800dcc:	0f b6 d0             	movzbl %al,%edx
  800dcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd2:	8a 00                	mov    (%eax),%al
  800dd4:	0f b6 c0             	movzbl %al,%eax
  800dd7:	29 c2                	sub    %eax,%edx
  800dd9:	89 d0                	mov    %edx,%eax
}
  800ddb:	5d                   	pop    %ebp
  800ddc:	c3                   	ret    

00800ddd <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ddd:	55                   	push   %ebp
  800dde:	89 e5                	mov    %esp,%ebp
  800de0:	83 ec 04             	sub    $0x4,%esp
  800de3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de6:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800de9:	eb 12                	jmp    800dfd <strchr+0x20>
		if (*s == c)
  800deb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dee:	8a 00                	mov    (%eax),%al
  800df0:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800df3:	75 05                	jne    800dfa <strchr+0x1d>
			return (char *) s;
  800df5:	8b 45 08             	mov    0x8(%ebp),%eax
  800df8:	eb 11                	jmp    800e0b <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800dfa:	ff 45 08             	incl   0x8(%ebp)
  800dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800e00:	8a 00                	mov    (%eax),%al
  800e02:	84 c0                	test   %al,%al
  800e04:	75 e5                	jne    800deb <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e06:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e0b:	c9                   	leave  
  800e0c:	c3                   	ret    

00800e0d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e0d:	55                   	push   %ebp
  800e0e:	89 e5                	mov    %esp,%ebp
  800e10:	83 ec 04             	sub    $0x4,%esp
  800e13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e16:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e19:	eb 0d                	jmp    800e28 <strfind+0x1b>
		if (*s == c)
  800e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1e:	8a 00                	mov    (%eax),%al
  800e20:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e23:	74 0e                	je     800e33 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e25:	ff 45 08             	incl   0x8(%ebp)
  800e28:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2b:	8a 00                	mov    (%eax),%al
  800e2d:	84 c0                	test   %al,%al
  800e2f:	75 ea                	jne    800e1b <strfind+0xe>
  800e31:	eb 01                	jmp    800e34 <strfind+0x27>
		if (*s == c)
			break;
  800e33:	90                   	nop
	return (char *) s;
  800e34:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e37:	c9                   	leave  
  800e38:	c3                   	ret    

00800e39 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e39:	55                   	push   %ebp
  800e3a:	89 e5                	mov    %esp,%ebp
  800e3c:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e42:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e45:	8b 45 10             	mov    0x10(%ebp),%eax
  800e48:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e4b:	eb 0e                	jmp    800e5b <memset+0x22>
		*p++ = c;
  800e4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e50:	8d 50 01             	lea    0x1(%eax),%edx
  800e53:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e56:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e59:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e5b:	ff 4d f8             	decl   -0x8(%ebp)
  800e5e:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e62:	79 e9                	jns    800e4d <memset+0x14>
		*p++ = c;

	return v;
  800e64:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e67:	c9                   	leave  
  800e68:	c3                   	ret    

00800e69 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e69:	55                   	push   %ebp
  800e6a:	89 e5                	mov    %esp,%ebp
  800e6c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e72:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e75:	8b 45 08             	mov    0x8(%ebp),%eax
  800e78:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e7b:	eb 16                	jmp    800e93 <memcpy+0x2a>
		*d++ = *s++;
  800e7d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e80:	8d 50 01             	lea    0x1(%eax),%edx
  800e83:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e86:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e89:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e8c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e8f:	8a 12                	mov    (%edx),%dl
  800e91:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e93:	8b 45 10             	mov    0x10(%ebp),%eax
  800e96:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e99:	89 55 10             	mov    %edx,0x10(%ebp)
  800e9c:	85 c0                	test   %eax,%eax
  800e9e:	75 dd                	jne    800e7d <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800ea0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ea3:	c9                   	leave  
  800ea4:	c3                   	ret    

00800ea5 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800ea5:	55                   	push   %ebp
  800ea6:	89 e5                	mov    %esp,%ebp
  800ea8:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800eab:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eae:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800eb7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eba:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ebd:	73 50                	jae    800f0f <memmove+0x6a>
  800ebf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ec2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec5:	01 d0                	add    %edx,%eax
  800ec7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800eca:	76 43                	jbe    800f0f <memmove+0x6a>
		s += n;
  800ecc:	8b 45 10             	mov    0x10(%ebp),%eax
  800ecf:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800ed2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed5:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ed8:	eb 10                	jmp    800eea <memmove+0x45>
			*--d = *--s;
  800eda:	ff 4d f8             	decl   -0x8(%ebp)
  800edd:	ff 4d fc             	decl   -0x4(%ebp)
  800ee0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee3:	8a 10                	mov    (%eax),%dl
  800ee5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ee8:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800eea:	8b 45 10             	mov    0x10(%ebp),%eax
  800eed:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ef0:	89 55 10             	mov    %edx,0x10(%ebp)
  800ef3:	85 c0                	test   %eax,%eax
  800ef5:	75 e3                	jne    800eda <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ef7:	eb 23                	jmp    800f1c <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800ef9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800efc:	8d 50 01             	lea    0x1(%eax),%edx
  800eff:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f02:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f05:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f08:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f0b:	8a 12                	mov    (%edx),%dl
  800f0d:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f0f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f12:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f15:	89 55 10             	mov    %edx,0x10(%ebp)
  800f18:	85 c0                	test   %eax,%eax
  800f1a:	75 dd                	jne    800ef9 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f1c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f1f:	c9                   	leave  
  800f20:	c3                   	ret    

00800f21 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f21:	55                   	push   %ebp
  800f22:	89 e5                	mov    %esp,%ebp
  800f24:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f27:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f30:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f33:	eb 2a                	jmp    800f5f <memcmp+0x3e>
		if (*s1 != *s2)
  800f35:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f38:	8a 10                	mov    (%eax),%dl
  800f3a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f3d:	8a 00                	mov    (%eax),%al
  800f3f:	38 c2                	cmp    %al,%dl
  800f41:	74 16                	je     800f59 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f43:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f46:	8a 00                	mov    (%eax),%al
  800f48:	0f b6 d0             	movzbl %al,%edx
  800f4b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f4e:	8a 00                	mov    (%eax),%al
  800f50:	0f b6 c0             	movzbl %al,%eax
  800f53:	29 c2                	sub    %eax,%edx
  800f55:	89 d0                	mov    %edx,%eax
  800f57:	eb 18                	jmp    800f71 <memcmp+0x50>
		s1++, s2++;
  800f59:	ff 45 fc             	incl   -0x4(%ebp)
  800f5c:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f5f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f62:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f65:	89 55 10             	mov    %edx,0x10(%ebp)
  800f68:	85 c0                	test   %eax,%eax
  800f6a:	75 c9                	jne    800f35 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f6c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f71:	c9                   	leave  
  800f72:	c3                   	ret    

00800f73 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f73:	55                   	push   %ebp
  800f74:	89 e5                	mov    %esp,%ebp
  800f76:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f79:	8b 55 08             	mov    0x8(%ebp),%edx
  800f7c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f7f:	01 d0                	add    %edx,%eax
  800f81:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f84:	eb 15                	jmp    800f9b <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f86:	8b 45 08             	mov    0x8(%ebp),%eax
  800f89:	8a 00                	mov    (%eax),%al
  800f8b:	0f b6 d0             	movzbl %al,%edx
  800f8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f91:	0f b6 c0             	movzbl %al,%eax
  800f94:	39 c2                	cmp    %eax,%edx
  800f96:	74 0d                	je     800fa5 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f98:	ff 45 08             	incl   0x8(%ebp)
  800f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800fa1:	72 e3                	jb     800f86 <memfind+0x13>
  800fa3:	eb 01                	jmp    800fa6 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800fa5:	90                   	nop
	return (void *) s;
  800fa6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fa9:	c9                   	leave  
  800faa:	c3                   	ret    

00800fab <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800fab:	55                   	push   %ebp
  800fac:	89 e5                	mov    %esp,%ebp
  800fae:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800fb1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800fb8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fbf:	eb 03                	jmp    800fc4 <strtol+0x19>
		s++;
  800fc1:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc7:	8a 00                	mov    (%eax),%al
  800fc9:	3c 20                	cmp    $0x20,%al
  800fcb:	74 f4                	je     800fc1 <strtol+0x16>
  800fcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd0:	8a 00                	mov    (%eax),%al
  800fd2:	3c 09                	cmp    $0x9,%al
  800fd4:	74 eb                	je     800fc1 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800fd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd9:	8a 00                	mov    (%eax),%al
  800fdb:	3c 2b                	cmp    $0x2b,%al
  800fdd:	75 05                	jne    800fe4 <strtol+0x39>
		s++;
  800fdf:	ff 45 08             	incl   0x8(%ebp)
  800fe2:	eb 13                	jmp    800ff7 <strtol+0x4c>
	else if (*s == '-')
  800fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe7:	8a 00                	mov    (%eax),%al
  800fe9:	3c 2d                	cmp    $0x2d,%al
  800feb:	75 0a                	jne    800ff7 <strtol+0x4c>
		s++, neg = 1;
  800fed:	ff 45 08             	incl   0x8(%ebp)
  800ff0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ff7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ffb:	74 06                	je     801003 <strtol+0x58>
  800ffd:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801001:	75 20                	jne    801023 <strtol+0x78>
  801003:	8b 45 08             	mov    0x8(%ebp),%eax
  801006:	8a 00                	mov    (%eax),%al
  801008:	3c 30                	cmp    $0x30,%al
  80100a:	75 17                	jne    801023 <strtol+0x78>
  80100c:	8b 45 08             	mov    0x8(%ebp),%eax
  80100f:	40                   	inc    %eax
  801010:	8a 00                	mov    (%eax),%al
  801012:	3c 78                	cmp    $0x78,%al
  801014:	75 0d                	jne    801023 <strtol+0x78>
		s += 2, base = 16;
  801016:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80101a:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801021:	eb 28                	jmp    80104b <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801023:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801027:	75 15                	jne    80103e <strtol+0x93>
  801029:	8b 45 08             	mov    0x8(%ebp),%eax
  80102c:	8a 00                	mov    (%eax),%al
  80102e:	3c 30                	cmp    $0x30,%al
  801030:	75 0c                	jne    80103e <strtol+0x93>
		s++, base = 8;
  801032:	ff 45 08             	incl   0x8(%ebp)
  801035:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80103c:	eb 0d                	jmp    80104b <strtol+0xa0>
	else if (base == 0)
  80103e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801042:	75 07                	jne    80104b <strtol+0xa0>
		base = 10;
  801044:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80104b:	8b 45 08             	mov    0x8(%ebp),%eax
  80104e:	8a 00                	mov    (%eax),%al
  801050:	3c 2f                	cmp    $0x2f,%al
  801052:	7e 19                	jle    80106d <strtol+0xc2>
  801054:	8b 45 08             	mov    0x8(%ebp),%eax
  801057:	8a 00                	mov    (%eax),%al
  801059:	3c 39                	cmp    $0x39,%al
  80105b:	7f 10                	jg     80106d <strtol+0xc2>
			dig = *s - '0';
  80105d:	8b 45 08             	mov    0x8(%ebp),%eax
  801060:	8a 00                	mov    (%eax),%al
  801062:	0f be c0             	movsbl %al,%eax
  801065:	83 e8 30             	sub    $0x30,%eax
  801068:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80106b:	eb 42                	jmp    8010af <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80106d:	8b 45 08             	mov    0x8(%ebp),%eax
  801070:	8a 00                	mov    (%eax),%al
  801072:	3c 60                	cmp    $0x60,%al
  801074:	7e 19                	jle    80108f <strtol+0xe4>
  801076:	8b 45 08             	mov    0x8(%ebp),%eax
  801079:	8a 00                	mov    (%eax),%al
  80107b:	3c 7a                	cmp    $0x7a,%al
  80107d:	7f 10                	jg     80108f <strtol+0xe4>
			dig = *s - 'a' + 10;
  80107f:	8b 45 08             	mov    0x8(%ebp),%eax
  801082:	8a 00                	mov    (%eax),%al
  801084:	0f be c0             	movsbl %al,%eax
  801087:	83 e8 57             	sub    $0x57,%eax
  80108a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80108d:	eb 20                	jmp    8010af <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80108f:	8b 45 08             	mov    0x8(%ebp),%eax
  801092:	8a 00                	mov    (%eax),%al
  801094:	3c 40                	cmp    $0x40,%al
  801096:	7e 39                	jle    8010d1 <strtol+0x126>
  801098:	8b 45 08             	mov    0x8(%ebp),%eax
  80109b:	8a 00                	mov    (%eax),%al
  80109d:	3c 5a                	cmp    $0x5a,%al
  80109f:	7f 30                	jg     8010d1 <strtol+0x126>
			dig = *s - 'A' + 10;
  8010a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a4:	8a 00                	mov    (%eax),%al
  8010a6:	0f be c0             	movsbl %al,%eax
  8010a9:	83 e8 37             	sub    $0x37,%eax
  8010ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8010af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010b2:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010b5:	7d 19                	jge    8010d0 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8010b7:	ff 45 08             	incl   0x8(%ebp)
  8010ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010bd:	0f af 45 10          	imul   0x10(%ebp),%eax
  8010c1:	89 c2                	mov    %eax,%edx
  8010c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010c6:	01 d0                	add    %edx,%eax
  8010c8:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8010cb:	e9 7b ff ff ff       	jmp    80104b <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8010d0:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010d1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010d5:	74 08                	je     8010df <strtol+0x134>
		*endptr = (char *) s;
  8010d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010da:	8b 55 08             	mov    0x8(%ebp),%edx
  8010dd:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8010df:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010e3:	74 07                	je     8010ec <strtol+0x141>
  8010e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e8:	f7 d8                	neg    %eax
  8010ea:	eb 03                	jmp    8010ef <strtol+0x144>
  8010ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010ef:	c9                   	leave  
  8010f0:	c3                   	ret    

008010f1 <ltostr>:

void
ltostr(long value, char *str)
{
  8010f1:	55                   	push   %ebp
  8010f2:	89 e5                	mov    %esp,%ebp
  8010f4:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8010f7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8010fe:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801105:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801109:	79 13                	jns    80111e <ltostr+0x2d>
	{
		neg = 1;
  80110b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801112:	8b 45 0c             	mov    0xc(%ebp),%eax
  801115:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801118:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80111b:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80111e:	8b 45 08             	mov    0x8(%ebp),%eax
  801121:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801126:	99                   	cltd   
  801127:	f7 f9                	idiv   %ecx
  801129:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80112c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80112f:	8d 50 01             	lea    0x1(%eax),%edx
  801132:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801135:	89 c2                	mov    %eax,%edx
  801137:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113a:	01 d0                	add    %edx,%eax
  80113c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80113f:	83 c2 30             	add    $0x30,%edx
  801142:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801144:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801147:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80114c:	f7 e9                	imul   %ecx
  80114e:	c1 fa 02             	sar    $0x2,%edx
  801151:	89 c8                	mov    %ecx,%eax
  801153:	c1 f8 1f             	sar    $0x1f,%eax
  801156:	29 c2                	sub    %eax,%edx
  801158:	89 d0                	mov    %edx,%eax
  80115a:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80115d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801160:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801165:	f7 e9                	imul   %ecx
  801167:	c1 fa 02             	sar    $0x2,%edx
  80116a:	89 c8                	mov    %ecx,%eax
  80116c:	c1 f8 1f             	sar    $0x1f,%eax
  80116f:	29 c2                	sub    %eax,%edx
  801171:	89 d0                	mov    %edx,%eax
  801173:	c1 e0 02             	shl    $0x2,%eax
  801176:	01 d0                	add    %edx,%eax
  801178:	01 c0                	add    %eax,%eax
  80117a:	29 c1                	sub    %eax,%ecx
  80117c:	89 ca                	mov    %ecx,%edx
  80117e:	85 d2                	test   %edx,%edx
  801180:	75 9c                	jne    80111e <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801182:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801189:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80118c:	48                   	dec    %eax
  80118d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801190:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801194:	74 3d                	je     8011d3 <ltostr+0xe2>
		start = 1 ;
  801196:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80119d:	eb 34                	jmp    8011d3 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80119f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a5:	01 d0                	add    %edx,%eax
  8011a7:	8a 00                	mov    (%eax),%al
  8011a9:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8011ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b2:	01 c2                	add    %eax,%edx
  8011b4:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8011b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ba:	01 c8                	add    %ecx,%eax
  8011bc:	8a 00                	mov    (%eax),%al
  8011be:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8011c0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c6:	01 c2                	add    %eax,%edx
  8011c8:	8a 45 eb             	mov    -0x15(%ebp),%al
  8011cb:	88 02                	mov    %al,(%edx)
		start++ ;
  8011cd:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8011d0:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8011d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011d6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011d9:	7c c4                	jl     80119f <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8011db:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8011de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e1:	01 d0                	add    %edx,%eax
  8011e3:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8011e6:	90                   	nop
  8011e7:	c9                   	leave  
  8011e8:	c3                   	ret    

008011e9 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011e9:	55                   	push   %ebp
  8011ea:	89 e5                	mov    %esp,%ebp
  8011ec:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8011ef:	ff 75 08             	pushl  0x8(%ebp)
  8011f2:	e8 54 fa ff ff       	call   800c4b <strlen>
  8011f7:	83 c4 04             	add    $0x4,%esp
  8011fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8011fd:	ff 75 0c             	pushl  0xc(%ebp)
  801200:	e8 46 fa ff ff       	call   800c4b <strlen>
  801205:	83 c4 04             	add    $0x4,%esp
  801208:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80120b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801212:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801219:	eb 17                	jmp    801232 <strcconcat+0x49>
		final[s] = str1[s] ;
  80121b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80121e:	8b 45 10             	mov    0x10(%ebp),%eax
  801221:	01 c2                	add    %eax,%edx
  801223:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801226:	8b 45 08             	mov    0x8(%ebp),%eax
  801229:	01 c8                	add    %ecx,%eax
  80122b:	8a 00                	mov    (%eax),%al
  80122d:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80122f:	ff 45 fc             	incl   -0x4(%ebp)
  801232:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801235:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801238:	7c e1                	jl     80121b <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80123a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801241:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801248:	eb 1f                	jmp    801269 <strcconcat+0x80>
		final[s++] = str2[i] ;
  80124a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80124d:	8d 50 01             	lea    0x1(%eax),%edx
  801250:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801253:	89 c2                	mov    %eax,%edx
  801255:	8b 45 10             	mov    0x10(%ebp),%eax
  801258:	01 c2                	add    %eax,%edx
  80125a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80125d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801260:	01 c8                	add    %ecx,%eax
  801262:	8a 00                	mov    (%eax),%al
  801264:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801266:	ff 45 f8             	incl   -0x8(%ebp)
  801269:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80126c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80126f:	7c d9                	jl     80124a <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801271:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801274:	8b 45 10             	mov    0x10(%ebp),%eax
  801277:	01 d0                	add    %edx,%eax
  801279:	c6 00 00             	movb   $0x0,(%eax)
}
  80127c:	90                   	nop
  80127d:	c9                   	leave  
  80127e:	c3                   	ret    

0080127f <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80127f:	55                   	push   %ebp
  801280:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801282:	8b 45 14             	mov    0x14(%ebp),%eax
  801285:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80128b:	8b 45 14             	mov    0x14(%ebp),%eax
  80128e:	8b 00                	mov    (%eax),%eax
  801290:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801297:	8b 45 10             	mov    0x10(%ebp),%eax
  80129a:	01 d0                	add    %edx,%eax
  80129c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012a2:	eb 0c                	jmp    8012b0 <strsplit+0x31>
			*string++ = 0;
  8012a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a7:	8d 50 01             	lea    0x1(%eax),%edx
  8012aa:	89 55 08             	mov    %edx,0x8(%ebp)
  8012ad:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b3:	8a 00                	mov    (%eax),%al
  8012b5:	84 c0                	test   %al,%al
  8012b7:	74 18                	je     8012d1 <strsplit+0x52>
  8012b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bc:	8a 00                	mov    (%eax),%al
  8012be:	0f be c0             	movsbl %al,%eax
  8012c1:	50                   	push   %eax
  8012c2:	ff 75 0c             	pushl  0xc(%ebp)
  8012c5:	e8 13 fb ff ff       	call   800ddd <strchr>
  8012ca:	83 c4 08             	add    $0x8,%esp
  8012cd:	85 c0                	test   %eax,%eax
  8012cf:	75 d3                	jne    8012a4 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8012d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d4:	8a 00                	mov    (%eax),%al
  8012d6:	84 c0                	test   %al,%al
  8012d8:	74 5a                	je     801334 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8012da:	8b 45 14             	mov    0x14(%ebp),%eax
  8012dd:	8b 00                	mov    (%eax),%eax
  8012df:	83 f8 0f             	cmp    $0xf,%eax
  8012e2:	75 07                	jne    8012eb <strsplit+0x6c>
		{
			return 0;
  8012e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8012e9:	eb 66                	jmp    801351 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ee:	8b 00                	mov    (%eax),%eax
  8012f0:	8d 48 01             	lea    0x1(%eax),%ecx
  8012f3:	8b 55 14             	mov    0x14(%ebp),%edx
  8012f6:	89 0a                	mov    %ecx,(%edx)
  8012f8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012ff:	8b 45 10             	mov    0x10(%ebp),%eax
  801302:	01 c2                	add    %eax,%edx
  801304:	8b 45 08             	mov    0x8(%ebp),%eax
  801307:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801309:	eb 03                	jmp    80130e <strsplit+0x8f>
			string++;
  80130b:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80130e:	8b 45 08             	mov    0x8(%ebp),%eax
  801311:	8a 00                	mov    (%eax),%al
  801313:	84 c0                	test   %al,%al
  801315:	74 8b                	je     8012a2 <strsplit+0x23>
  801317:	8b 45 08             	mov    0x8(%ebp),%eax
  80131a:	8a 00                	mov    (%eax),%al
  80131c:	0f be c0             	movsbl %al,%eax
  80131f:	50                   	push   %eax
  801320:	ff 75 0c             	pushl  0xc(%ebp)
  801323:	e8 b5 fa ff ff       	call   800ddd <strchr>
  801328:	83 c4 08             	add    $0x8,%esp
  80132b:	85 c0                	test   %eax,%eax
  80132d:	74 dc                	je     80130b <strsplit+0x8c>
			string++;
	}
  80132f:	e9 6e ff ff ff       	jmp    8012a2 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801334:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801335:	8b 45 14             	mov    0x14(%ebp),%eax
  801338:	8b 00                	mov    (%eax),%eax
  80133a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801341:	8b 45 10             	mov    0x10(%ebp),%eax
  801344:	01 d0                	add    %edx,%eax
  801346:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80134c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801351:	c9                   	leave  
  801352:	c3                   	ret    

00801353 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801353:	55                   	push   %ebp
  801354:	89 e5                	mov    %esp,%ebp
  801356:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801359:	a1 04 40 80 00       	mov    0x804004,%eax
  80135e:	85 c0                	test   %eax,%eax
  801360:	74 1f                	je     801381 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801362:	e8 1d 00 00 00       	call   801384 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801367:	83 ec 0c             	sub    $0xc,%esp
  80136a:	68 90 3a 80 00       	push   $0x803a90
  80136f:	e8 55 f2 ff ff       	call   8005c9 <cprintf>
  801374:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801377:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  80137e:	00 00 00 
	}
}
  801381:	90                   	nop
  801382:	c9                   	leave  
  801383:	c3                   	ret    

00801384 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801384:	55                   	push   %ebp
  801385:	89 e5                	mov    %esp,%ebp
  801387:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  80138a:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801391:	00 00 00 
  801394:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80139b:	00 00 00 
  80139e:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  8013a5:	00 00 00 
		LIST_INIT(&AllocMemBlocksList);
  8013a8:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  8013af:	00 00 00 
  8013b2:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  8013b9:	00 00 00 
  8013bc:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  8013c3:	00 00 00 

		MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES ;
  8013c6:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  8013cd:	00 02 00 
		MemBlockNodes =(struct MemBlock*)USER_DYN_BLKS_ARRAY ;
  8013d0:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  8013d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013da:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013df:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013e4:	a3 50 40 80 00       	mov    %eax,0x804050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock),PAGE_SIZE),PERM_USER|PERM_WRITEABLE);
  8013e9:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8013f0:	a1 20 41 80 00       	mov    0x804120,%eax
  8013f5:	c1 e0 04             	shl    $0x4,%eax
  8013f8:	89 c2                	mov    %eax,%edx
  8013fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013fd:	01 d0                	add    %edx,%eax
  8013ff:	48                   	dec    %eax
  801400:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801403:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801406:	ba 00 00 00 00       	mov    $0x0,%edx
  80140b:	f7 75 f0             	divl   -0x10(%ebp)
  80140e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801411:	29 d0                	sub    %edx,%eax
  801413:	89 c2                	mov    %eax,%edx
  801415:	c7 45 e8 00 00 e0 7f 	movl   $0x7fe00000,-0x18(%ebp)
  80141c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80141f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801424:	2d 00 10 00 00       	sub    $0x1000,%eax
  801429:	83 ec 04             	sub    $0x4,%esp
  80142c:	6a 06                	push   $0x6
  80142e:	52                   	push   %edx
  80142f:	50                   	push   %eax
  801430:	e8 71 05 00 00       	call   8019a6 <sys_allocate_chunk>
  801435:	83 c4 10             	add    $0x10,%esp
		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801438:	a1 20 41 80 00       	mov    0x804120,%eax
  80143d:	83 ec 0c             	sub    $0xc,%esp
  801440:	50                   	push   %eax
  801441:	e8 e6 0b 00 00       	call   80202c <initialize_MemBlocksList>
  801446:	83 c4 10             	add    $0x10,%esp

		struct MemBlock  *block_node;
		block_node = AvailableMemBlocksList.lh_first;
  801449:	a1 48 41 80 00       	mov    0x804148,%eax
  80144e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&(AvailableMemBlocksList),block_node);
  801451:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801455:	75 14                	jne    80146b <initialize_dyn_block_system+0xe7>
  801457:	83 ec 04             	sub    $0x4,%esp
  80145a:	68 b5 3a 80 00       	push   $0x803ab5
  80145f:	6a 2b                	push   $0x2b
  801461:	68 d3 3a 80 00       	push   $0x803ad3
  801466:	e8 aa ee ff ff       	call   800315 <_panic>
  80146b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80146e:	8b 00                	mov    (%eax),%eax
  801470:	85 c0                	test   %eax,%eax
  801472:	74 10                	je     801484 <initialize_dyn_block_system+0x100>
  801474:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801477:	8b 00                	mov    (%eax),%eax
  801479:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80147c:	8b 52 04             	mov    0x4(%edx),%edx
  80147f:	89 50 04             	mov    %edx,0x4(%eax)
  801482:	eb 0b                	jmp    80148f <initialize_dyn_block_system+0x10b>
  801484:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801487:	8b 40 04             	mov    0x4(%eax),%eax
  80148a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80148f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801492:	8b 40 04             	mov    0x4(%eax),%eax
  801495:	85 c0                	test   %eax,%eax
  801497:	74 0f                	je     8014a8 <initialize_dyn_block_system+0x124>
  801499:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80149c:	8b 40 04             	mov    0x4(%eax),%eax
  80149f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8014a2:	8b 12                	mov    (%edx),%edx
  8014a4:	89 10                	mov    %edx,(%eax)
  8014a6:	eb 0a                	jmp    8014b2 <initialize_dyn_block_system+0x12e>
  8014a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014ab:	8b 00                	mov    (%eax),%eax
  8014ad:	a3 48 41 80 00       	mov    %eax,0x804148
  8014b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8014bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014be:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8014c5:	a1 54 41 80 00       	mov    0x804154,%eax
  8014ca:	48                   	dec    %eax
  8014cb:	a3 54 41 80 00       	mov    %eax,0x804154
		block_node->sva = USER_HEAP_START ;
  8014d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014d3:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
		block_node->size = ((USER_HEAP_MAX - USER_HEAP_START));
  8014da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014dd:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		insert_sorted_with_merge_freeList(block_node);
  8014e4:	83 ec 0c             	sub    $0xc,%esp
  8014e7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8014ea:	e8 d2 13 00 00       	call   8028c1 <insert_sorted_with_merge_freeList>
  8014ef:	83 c4 10             	add    $0x10,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  8014f2:	90                   	nop
  8014f3:	c9                   	leave  
  8014f4:	c3                   	ret    

008014f5 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8014f5:	55                   	push   %ebp
  8014f6:	89 e5                	mov    %esp,%ebp
  8014f8:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014fb:	e8 53 fe ff ff       	call   801353 <InitializeUHeap>
	if (size == 0) return NULL ;
  801500:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801504:	75 07                	jne    80150d <malloc+0x18>
  801506:	b8 00 00 00 00       	mov    $0x0,%eax
  80150b:	eb 61                	jmp    80156e <malloc+0x79>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	size= ROUNDUP(size,PAGE_SIZE);
  80150d:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801514:	8b 55 08             	mov    0x8(%ebp),%edx
  801517:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80151a:	01 d0                	add    %edx,%eax
  80151c:	48                   	dec    %eax
  80151d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801520:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801523:	ba 00 00 00 00       	mov    $0x0,%edx
  801528:	f7 75 f4             	divl   -0xc(%ebp)
  80152b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80152e:	29 d0                	sub    %edx,%eax
  801530:	89 45 08             	mov    %eax,0x8(%ebp)
	    			if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801533:	e8 3c 08 00 00       	call   801d74 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801538:	85 c0                	test   %eax,%eax
  80153a:	74 2d                	je     801569 <malloc+0x74>
	    			{
	    				struct MemBlock * ff_block = alloc_block_FF(size);
  80153c:	83 ec 0c             	sub    $0xc,%esp
  80153f:	ff 75 08             	pushl  0x8(%ebp)
  801542:	e8 3e 0f 00 00       	call   802485 <alloc_block_FF>
  801547:	83 c4 10             	add    $0x10,%esp
  80154a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    				if(ff_block!=NULL)
  80154d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801551:	74 16                	je     801569 <malloc+0x74>
	    				{

	    					insert_sorted_allocList(ff_block);
  801553:	83 ec 0c             	sub    $0xc,%esp
  801556:	ff 75 ec             	pushl  -0x14(%ebp)
  801559:	e8 48 0c 00 00       	call   8021a6 <insert_sorted_allocList>
  80155e:	83 c4 10             	add    $0x10,%esp
	    					return (void*) ff_block->sva ;
  801561:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801564:	8b 40 08             	mov    0x8(%eax),%eax
  801567:	eb 05                	jmp    80156e <malloc+0x79>

	    				}
	}
	    			return (void*) NULL ;
  801569:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  80156e:	c9                   	leave  
  80156f:	c3                   	ret    

00801570 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801570:	55                   	push   %ebp
  801571:	89 e5                	mov    %esp,%ebp
  801573:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock *elementForEach;
		virtual_address = ROUNDDOWN(virtual_address, PAGE_SIZE);
  801576:	8b 45 08             	mov    0x8(%ebp),%eax
  801579:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80157c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80157f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801584:	89 45 08             	mov    %eax,0x8(%ebp)
	//	if (is_mallocPages[indexindex((uint32) virtual_address)] == 1) {
		elementForEach = find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801587:	8b 45 08             	mov    0x8(%ebp),%eax
  80158a:	83 ec 08             	sub    $0x8,%esp
  80158d:	50                   	push   %eax
  80158e:	68 40 40 80 00       	push   $0x804040
  801593:	e8 71 0b 00 00       	call   802109 <find_block>
  801598:	83 c4 10             	add    $0x10,%esp
  80159b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		sys_free_user_mem((uint32) virtual_address, elementForEach->size);
  80159e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015a1:	8b 50 0c             	mov    0xc(%eax),%edx
  8015a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a7:	83 ec 08             	sub    $0x8,%esp
  8015aa:	52                   	push   %edx
  8015ab:	50                   	push   %eax
  8015ac:	e8 bd 03 00 00       	call   80196e <sys_free_user_mem>
  8015b1:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,elementForEach);
  8015b4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8015b8:	75 14                	jne    8015ce <free+0x5e>
  8015ba:	83 ec 04             	sub    $0x4,%esp
  8015bd:	68 b5 3a 80 00       	push   $0x803ab5
  8015c2:	6a 71                	push   $0x71
  8015c4:	68 d3 3a 80 00       	push   $0x803ad3
  8015c9:	e8 47 ed ff ff       	call   800315 <_panic>
  8015ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015d1:	8b 00                	mov    (%eax),%eax
  8015d3:	85 c0                	test   %eax,%eax
  8015d5:	74 10                	je     8015e7 <free+0x77>
  8015d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015da:	8b 00                	mov    (%eax),%eax
  8015dc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015df:	8b 52 04             	mov    0x4(%edx),%edx
  8015e2:	89 50 04             	mov    %edx,0x4(%eax)
  8015e5:	eb 0b                	jmp    8015f2 <free+0x82>
  8015e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ea:	8b 40 04             	mov    0x4(%eax),%eax
  8015ed:	a3 44 40 80 00       	mov    %eax,0x804044
  8015f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015f5:	8b 40 04             	mov    0x4(%eax),%eax
  8015f8:	85 c0                	test   %eax,%eax
  8015fa:	74 0f                	je     80160b <free+0x9b>
  8015fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ff:	8b 40 04             	mov    0x4(%eax),%eax
  801602:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801605:	8b 12                	mov    (%edx),%edx
  801607:	89 10                	mov    %edx,(%eax)
  801609:	eb 0a                	jmp    801615 <free+0xa5>
  80160b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80160e:	8b 00                	mov    (%eax),%eax
  801610:	a3 40 40 80 00       	mov    %eax,0x804040
  801615:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801618:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80161e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801621:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801628:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80162d:	48                   	dec    %eax
  80162e:	a3 4c 40 80 00       	mov    %eax,0x80404c
		insert_sorted_with_merge_freeList(elementForEach);
  801633:	83 ec 0c             	sub    $0xc,%esp
  801636:	ff 75 f0             	pushl  -0x10(%ebp)
  801639:	e8 83 12 00 00       	call   8028c1 <insert_sorted_with_merge_freeList>
  80163e:	83 c4 10             	add    $0x10,%esp
	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801641:	90                   	nop
  801642:	c9                   	leave  
  801643:	c3                   	ret    

00801644 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801644:	55                   	push   %ebp
  801645:	89 e5                	mov    %esp,%ebp
  801647:	83 ec 28             	sub    $0x28,%esp
  80164a:	8b 45 10             	mov    0x10(%ebp),%eax
  80164d:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801650:	e8 fe fc ff ff       	call   801353 <InitializeUHeap>
	if (size == 0) return NULL ;
  801655:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801659:	75 0a                	jne    801665 <smalloc+0x21>
  80165b:	b8 00 00 00 00       	mov    $0x0,%eax
  801660:	e9 86 00 00 00       	jmp    8016eb <smalloc+0xa7>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code

	size=ROUNDUP(size,PAGE_SIZE);
  801665:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80166c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80166f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801672:	01 d0                	add    %edx,%eax
  801674:	48                   	dec    %eax
  801675:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801678:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80167b:	ba 00 00 00 00       	mov    $0x0,%edx
  801680:	f7 75 f4             	divl   -0xc(%ebp)
  801683:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801686:	29 d0                	sub    %edx,%eax
  801688:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80168b:	e8 e4 06 00 00       	call   801d74 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801690:	85 c0                	test   %eax,%eax
  801692:	74 52                	je     8016e6 <smalloc+0xa2>
		{
		struct MemBlock * ff_block ;
		ff_block = alloc_block_FF(size);
  801694:	83 ec 0c             	sub    $0xc,%esp
  801697:	ff 75 0c             	pushl  0xc(%ebp)
  80169a:	e8 e6 0d 00 00       	call   802485 <alloc_block_FF>
  80169f:	83 c4 10             	add    $0x10,%esp
  8016a2:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(ff_block==NULL)
  8016a5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8016a9:	75 07                	jne    8016b2 <smalloc+0x6e>
			return NULL ;
  8016ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b0:	eb 39                	jmp    8016eb <smalloc+0xa7>

		int obj_id =sys_createSharedObject(sharedVarName,size,isWritable,(void*)ff_block->sva);
  8016b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016b5:	8b 40 08             	mov    0x8(%eax),%eax
  8016b8:	89 c2                	mov    %eax,%edx
  8016ba:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8016be:	52                   	push   %edx
  8016bf:	50                   	push   %eax
  8016c0:	ff 75 0c             	pushl  0xc(%ebp)
  8016c3:	ff 75 08             	pushl  0x8(%ebp)
  8016c6:	e8 2e 04 00 00       	call   801af9 <sys_createSharedObject>
  8016cb:	83 c4 10             	add    $0x10,%esp
  8016ce:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(obj_id < 0)
  8016d1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8016d5:	79 07                	jns    8016de <smalloc+0x9a>
			return (void*)NULL ;
  8016d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8016dc:	eb 0d                	jmp    8016eb <smalloc+0xa7>
		else
		    return (void*)ff_block->sva ;
  8016de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016e1:	8b 40 08             	mov    0x8(%eax),%eax
  8016e4:	eb 05                	jmp    8016eb <smalloc+0xa7>
		}
		return (void*)NULL ;
  8016e6:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8016eb:	c9                   	leave  
  8016ec:	c3                   	ret    

008016ed <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016ed:	55                   	push   %ebp
  8016ee:	89 e5                	mov    %esp,%ebp
  8016f0:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016f3:	e8 5b fc ff ff       	call   801353 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8016f8:	83 ec 08             	sub    $0x8,%esp
  8016fb:	ff 75 0c             	pushl  0xc(%ebp)
  8016fe:	ff 75 08             	pushl  0x8(%ebp)
  801701:	e8 1d 04 00 00       	call   801b23 <sys_getSizeOfSharedObject>
  801706:	83 c4 10             	add    $0x10,%esp
  801709:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(size == 0)
  80170c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801710:	75 0a                	jne    80171c <sget+0x2f>
			return NULL ;
  801712:	b8 00 00 00 00       	mov    $0x0,%eax
  801717:	e9 83 00 00 00       	jmp    80179f <sget+0xb2>
		size=ROUNDUP(size,PAGE_SIZE);
  80171c:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801723:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801726:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801729:	01 d0                	add    %edx,%eax
  80172b:	48                   	dec    %eax
  80172c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80172f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801732:	ba 00 00 00 00       	mov    $0x0,%edx
  801737:	f7 75 f0             	divl   -0x10(%ebp)
  80173a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80173d:	29 d0                	sub    %edx,%eax
  80173f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801742:	e8 2d 06 00 00       	call   801d74 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801747:	85 c0                	test   %eax,%eax
  801749:	74 4f                	je     80179a <sget+0xad>
		{
			struct MemBlock * ff_block ;
				ff_block = alloc_block_FF(size);
  80174b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80174e:	83 ec 0c             	sub    $0xc,%esp
  801751:	50                   	push   %eax
  801752:	e8 2e 0d 00 00       	call   802485 <alloc_block_FF>
  801757:	83 c4 10             	add    $0x10,%esp
  80175a:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ff_block==NULL)
  80175d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801761:	75 07                	jne    80176a <sget+0x7d>
					return (void*)NULL ;
  801763:	b8 00 00 00 00       	mov    $0x0,%eax
  801768:	eb 35                	jmp    80179f <sget+0xb2>

		int obj_id =sys_getSharedObject((int)ownerEnvID,sharedVarName,(void*)ff_block->sva);
  80176a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80176d:	8b 40 08             	mov    0x8(%eax),%eax
  801770:	83 ec 04             	sub    $0x4,%esp
  801773:	50                   	push   %eax
  801774:	ff 75 0c             	pushl  0xc(%ebp)
  801777:	ff 75 08             	pushl  0x8(%ebp)
  80177a:	e8 c1 03 00 00       	call   801b40 <sys_getSharedObject>
  80177f:	83 c4 10             	add    $0x10,%esp
  801782:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if(obj_id<0)
  801785:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801789:	79 07                	jns    801792 <sget+0xa5>
				return (void*)NULL ;
  80178b:	b8 00 00 00 00       	mov    $0x0,%eax
  801790:	eb 0d                	jmp    80179f <sget+0xb2>
			else
				return (void*)ff_block->sva ;
  801792:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801795:	8b 40 08             	mov    0x8(%eax),%eax
  801798:	eb 05                	jmp    80179f <sget+0xb2>


		}
	return (void*)NULL ;
  80179a:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80179f:	c9                   	leave  
  8017a0:	c3                   	ret    

008017a1 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8017a1:	55                   	push   %ebp
  8017a2:	89 e5                	mov    %esp,%ebp
  8017a4:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017a7:	e8 a7 fb ff ff       	call   801353 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8017ac:	83 ec 04             	sub    $0x4,%esp
  8017af:	68 e0 3a 80 00       	push   $0x803ae0
  8017b4:	68 f9 00 00 00       	push   $0xf9
  8017b9:	68 d3 3a 80 00       	push   $0x803ad3
  8017be:	e8 52 eb ff ff       	call   800315 <_panic>

008017c3 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8017c3:	55                   	push   %ebp
  8017c4:	89 e5                	mov    %esp,%ebp
  8017c6:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8017c9:	83 ec 04             	sub    $0x4,%esp
  8017cc:	68 08 3b 80 00       	push   $0x803b08
  8017d1:	68 0d 01 00 00       	push   $0x10d
  8017d6:	68 d3 3a 80 00       	push   $0x803ad3
  8017db:	e8 35 eb ff ff       	call   800315 <_panic>

008017e0 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8017e0:	55                   	push   %ebp
  8017e1:	89 e5                	mov    %esp,%ebp
  8017e3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017e6:	83 ec 04             	sub    $0x4,%esp
  8017e9:	68 2c 3b 80 00       	push   $0x803b2c
  8017ee:	68 18 01 00 00       	push   $0x118
  8017f3:	68 d3 3a 80 00       	push   $0x803ad3
  8017f8:	e8 18 eb ff ff       	call   800315 <_panic>

008017fd <shrink>:

}
void shrink(uint32 newSize)
{
  8017fd:	55                   	push   %ebp
  8017fe:	89 e5                	mov    %esp,%ebp
  801800:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801803:	83 ec 04             	sub    $0x4,%esp
  801806:	68 2c 3b 80 00       	push   $0x803b2c
  80180b:	68 1d 01 00 00       	push   $0x11d
  801810:	68 d3 3a 80 00       	push   $0x803ad3
  801815:	e8 fb ea ff ff       	call   800315 <_panic>

0080181a <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80181a:	55                   	push   %ebp
  80181b:	89 e5                	mov    %esp,%ebp
  80181d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801820:	83 ec 04             	sub    $0x4,%esp
  801823:	68 2c 3b 80 00       	push   $0x803b2c
  801828:	68 22 01 00 00       	push   $0x122
  80182d:	68 d3 3a 80 00       	push   $0x803ad3
  801832:	e8 de ea ff ff       	call   800315 <_panic>

00801837 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801837:	55                   	push   %ebp
  801838:	89 e5                	mov    %esp,%ebp
  80183a:	57                   	push   %edi
  80183b:	56                   	push   %esi
  80183c:	53                   	push   %ebx
  80183d:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801840:	8b 45 08             	mov    0x8(%ebp),%eax
  801843:	8b 55 0c             	mov    0xc(%ebp),%edx
  801846:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801849:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80184c:	8b 7d 18             	mov    0x18(%ebp),%edi
  80184f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801852:	cd 30                	int    $0x30
  801854:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801857:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80185a:	83 c4 10             	add    $0x10,%esp
  80185d:	5b                   	pop    %ebx
  80185e:	5e                   	pop    %esi
  80185f:	5f                   	pop    %edi
  801860:	5d                   	pop    %ebp
  801861:	c3                   	ret    

00801862 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801862:	55                   	push   %ebp
  801863:	89 e5                	mov    %esp,%ebp
  801865:	83 ec 04             	sub    $0x4,%esp
  801868:	8b 45 10             	mov    0x10(%ebp),%eax
  80186b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80186e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801872:	8b 45 08             	mov    0x8(%ebp),%eax
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	52                   	push   %edx
  80187a:	ff 75 0c             	pushl  0xc(%ebp)
  80187d:	50                   	push   %eax
  80187e:	6a 00                	push   $0x0
  801880:	e8 b2 ff ff ff       	call   801837 <syscall>
  801885:	83 c4 18             	add    $0x18,%esp
}
  801888:	90                   	nop
  801889:	c9                   	leave  
  80188a:	c3                   	ret    

0080188b <sys_cgetc>:

int
sys_cgetc(void)
{
  80188b:	55                   	push   %ebp
  80188c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80188e:	6a 00                	push   $0x0
  801890:	6a 00                	push   $0x0
  801892:	6a 00                	push   $0x0
  801894:	6a 00                	push   $0x0
  801896:	6a 00                	push   $0x0
  801898:	6a 01                	push   $0x1
  80189a:	e8 98 ff ff ff       	call   801837 <syscall>
  80189f:	83 c4 18             	add    $0x18,%esp
}
  8018a2:	c9                   	leave  
  8018a3:	c3                   	ret    

008018a4 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018a4:	55                   	push   %ebp
  8018a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ad:	6a 00                	push   $0x0
  8018af:	6a 00                	push   $0x0
  8018b1:	6a 00                	push   $0x0
  8018b3:	52                   	push   %edx
  8018b4:	50                   	push   %eax
  8018b5:	6a 05                	push   $0x5
  8018b7:	e8 7b ff ff ff       	call   801837 <syscall>
  8018bc:	83 c4 18             	add    $0x18,%esp
}
  8018bf:	c9                   	leave  
  8018c0:	c3                   	ret    

008018c1 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018c1:	55                   	push   %ebp
  8018c2:	89 e5                	mov    %esp,%ebp
  8018c4:	56                   	push   %esi
  8018c5:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018c6:	8b 75 18             	mov    0x18(%ebp),%esi
  8018c9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018cc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d5:	56                   	push   %esi
  8018d6:	53                   	push   %ebx
  8018d7:	51                   	push   %ecx
  8018d8:	52                   	push   %edx
  8018d9:	50                   	push   %eax
  8018da:	6a 06                	push   $0x6
  8018dc:	e8 56 ff ff ff       	call   801837 <syscall>
  8018e1:	83 c4 18             	add    $0x18,%esp
}
  8018e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018e7:	5b                   	pop    %ebx
  8018e8:	5e                   	pop    %esi
  8018e9:	5d                   	pop    %ebp
  8018ea:	c3                   	ret    

008018eb <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018eb:	55                   	push   %ebp
  8018ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 00                	push   $0x0
  8018f8:	6a 00                	push   $0x0
  8018fa:	52                   	push   %edx
  8018fb:	50                   	push   %eax
  8018fc:	6a 07                	push   $0x7
  8018fe:	e8 34 ff ff ff       	call   801837 <syscall>
  801903:	83 c4 18             	add    $0x18,%esp
}
  801906:	c9                   	leave  
  801907:	c3                   	ret    

00801908 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801908:	55                   	push   %ebp
  801909:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80190b:	6a 00                	push   $0x0
  80190d:	6a 00                	push   $0x0
  80190f:	6a 00                	push   $0x0
  801911:	ff 75 0c             	pushl  0xc(%ebp)
  801914:	ff 75 08             	pushl  0x8(%ebp)
  801917:	6a 08                	push   $0x8
  801919:	e8 19 ff ff ff       	call   801837 <syscall>
  80191e:	83 c4 18             	add    $0x18,%esp
}
  801921:	c9                   	leave  
  801922:	c3                   	ret    

00801923 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801923:	55                   	push   %ebp
  801924:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801926:	6a 00                	push   $0x0
  801928:	6a 00                	push   $0x0
  80192a:	6a 00                	push   $0x0
  80192c:	6a 00                	push   $0x0
  80192e:	6a 00                	push   $0x0
  801930:	6a 09                	push   $0x9
  801932:	e8 00 ff ff ff       	call   801837 <syscall>
  801937:	83 c4 18             	add    $0x18,%esp
}
  80193a:	c9                   	leave  
  80193b:	c3                   	ret    

0080193c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80193c:	55                   	push   %ebp
  80193d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80193f:	6a 00                	push   $0x0
  801941:	6a 00                	push   $0x0
  801943:	6a 00                	push   $0x0
  801945:	6a 00                	push   $0x0
  801947:	6a 00                	push   $0x0
  801949:	6a 0a                	push   $0xa
  80194b:	e8 e7 fe ff ff       	call   801837 <syscall>
  801950:	83 c4 18             	add    $0x18,%esp
}
  801953:	c9                   	leave  
  801954:	c3                   	ret    

00801955 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801955:	55                   	push   %ebp
  801956:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801958:	6a 00                	push   $0x0
  80195a:	6a 00                	push   $0x0
  80195c:	6a 00                	push   $0x0
  80195e:	6a 00                	push   $0x0
  801960:	6a 00                	push   $0x0
  801962:	6a 0b                	push   $0xb
  801964:	e8 ce fe ff ff       	call   801837 <syscall>
  801969:	83 c4 18             	add    $0x18,%esp
}
  80196c:	c9                   	leave  
  80196d:	c3                   	ret    

0080196e <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80196e:	55                   	push   %ebp
  80196f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	6a 00                	push   $0x0
  801977:	ff 75 0c             	pushl  0xc(%ebp)
  80197a:	ff 75 08             	pushl  0x8(%ebp)
  80197d:	6a 0f                	push   $0xf
  80197f:	e8 b3 fe ff ff       	call   801837 <syscall>
  801984:	83 c4 18             	add    $0x18,%esp
	return;
  801987:	90                   	nop
}
  801988:	c9                   	leave  
  801989:	c3                   	ret    

0080198a <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80198a:	55                   	push   %ebp
  80198b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80198d:	6a 00                	push   $0x0
  80198f:	6a 00                	push   $0x0
  801991:	6a 00                	push   $0x0
  801993:	ff 75 0c             	pushl  0xc(%ebp)
  801996:	ff 75 08             	pushl  0x8(%ebp)
  801999:	6a 10                	push   $0x10
  80199b:	e8 97 fe ff ff       	call   801837 <syscall>
  8019a0:	83 c4 18             	add    $0x18,%esp
	return ;
  8019a3:	90                   	nop
}
  8019a4:	c9                   	leave  
  8019a5:	c3                   	ret    

008019a6 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8019a6:	55                   	push   %ebp
  8019a7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 00                	push   $0x0
  8019ad:	ff 75 10             	pushl  0x10(%ebp)
  8019b0:	ff 75 0c             	pushl  0xc(%ebp)
  8019b3:	ff 75 08             	pushl  0x8(%ebp)
  8019b6:	6a 11                	push   $0x11
  8019b8:	e8 7a fe ff ff       	call   801837 <syscall>
  8019bd:	83 c4 18             	add    $0x18,%esp
	return ;
  8019c0:	90                   	nop
}
  8019c1:	c9                   	leave  
  8019c2:	c3                   	ret    

008019c3 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019c3:	55                   	push   %ebp
  8019c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 0c                	push   $0xc
  8019d2:	e8 60 fe ff ff       	call   801837 <syscall>
  8019d7:	83 c4 18             	add    $0x18,%esp
}
  8019da:	c9                   	leave  
  8019db:	c3                   	ret    

008019dc <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019dc:	55                   	push   %ebp
  8019dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	ff 75 08             	pushl  0x8(%ebp)
  8019ea:	6a 0d                	push   $0xd
  8019ec:	e8 46 fe ff ff       	call   801837 <syscall>
  8019f1:	83 c4 18             	add    $0x18,%esp
}
  8019f4:	c9                   	leave  
  8019f5:	c3                   	ret    

008019f6 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019f6:	55                   	push   %ebp
  8019f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 00                	push   $0x0
  801a03:	6a 0e                	push   $0xe
  801a05:	e8 2d fe ff ff       	call   801837 <syscall>
  801a0a:	83 c4 18             	add    $0x18,%esp
}
  801a0d:	90                   	nop
  801a0e:	c9                   	leave  
  801a0f:	c3                   	ret    

00801a10 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a10:	55                   	push   %ebp
  801a11:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 13                	push   $0x13
  801a1f:	e8 13 fe ff ff       	call   801837 <syscall>
  801a24:	83 c4 18             	add    $0x18,%esp
}
  801a27:	90                   	nop
  801a28:	c9                   	leave  
  801a29:	c3                   	ret    

00801a2a <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a2a:	55                   	push   %ebp
  801a2b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	6a 14                	push   $0x14
  801a39:	e8 f9 fd ff ff       	call   801837 <syscall>
  801a3e:	83 c4 18             	add    $0x18,%esp
}
  801a41:	90                   	nop
  801a42:	c9                   	leave  
  801a43:	c3                   	ret    

00801a44 <sys_cputc>:


void
sys_cputc(const char c)
{
  801a44:	55                   	push   %ebp
  801a45:	89 e5                	mov    %esp,%ebp
  801a47:	83 ec 04             	sub    $0x4,%esp
  801a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a50:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a54:	6a 00                	push   $0x0
  801a56:	6a 00                	push   $0x0
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 00                	push   $0x0
  801a5c:	50                   	push   %eax
  801a5d:	6a 15                	push   $0x15
  801a5f:	e8 d3 fd ff ff       	call   801837 <syscall>
  801a64:	83 c4 18             	add    $0x18,%esp
}
  801a67:	90                   	nop
  801a68:	c9                   	leave  
  801a69:	c3                   	ret    

00801a6a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a6a:	55                   	push   %ebp
  801a6b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	6a 16                	push   $0x16
  801a79:	e8 b9 fd ff ff       	call   801837 <syscall>
  801a7e:	83 c4 18             	add    $0x18,%esp
}
  801a81:	90                   	nop
  801a82:	c9                   	leave  
  801a83:	c3                   	ret    

00801a84 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a84:	55                   	push   %ebp
  801a85:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a87:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	ff 75 0c             	pushl  0xc(%ebp)
  801a93:	50                   	push   %eax
  801a94:	6a 17                	push   $0x17
  801a96:	e8 9c fd ff ff       	call   801837 <syscall>
  801a9b:	83 c4 18             	add    $0x18,%esp
}
  801a9e:	c9                   	leave  
  801a9f:	c3                   	ret    

00801aa0 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801aa0:	55                   	push   %ebp
  801aa1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801aa3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	6a 00                	push   $0x0
  801aaf:	52                   	push   %edx
  801ab0:	50                   	push   %eax
  801ab1:	6a 1a                	push   $0x1a
  801ab3:	e8 7f fd ff ff       	call   801837 <syscall>
  801ab8:	83 c4 18             	add    $0x18,%esp
}
  801abb:	c9                   	leave  
  801abc:	c3                   	ret    

00801abd <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801abd:	55                   	push   %ebp
  801abe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ac0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 00                	push   $0x0
  801acc:	52                   	push   %edx
  801acd:	50                   	push   %eax
  801ace:	6a 18                	push   $0x18
  801ad0:	e8 62 fd ff ff       	call   801837 <syscall>
  801ad5:	83 c4 18             	add    $0x18,%esp
}
  801ad8:	90                   	nop
  801ad9:	c9                   	leave  
  801ada:	c3                   	ret    

00801adb <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801adb:	55                   	push   %ebp
  801adc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ade:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 00                	push   $0x0
  801aea:	52                   	push   %edx
  801aeb:	50                   	push   %eax
  801aec:	6a 19                	push   $0x19
  801aee:	e8 44 fd ff ff       	call   801837 <syscall>
  801af3:	83 c4 18             	add    $0x18,%esp
}
  801af6:	90                   	nop
  801af7:	c9                   	leave  
  801af8:	c3                   	ret    

00801af9 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801af9:	55                   	push   %ebp
  801afa:	89 e5                	mov    %esp,%ebp
  801afc:	83 ec 04             	sub    $0x4,%esp
  801aff:	8b 45 10             	mov    0x10(%ebp),%eax
  801b02:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b05:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b08:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0f:	6a 00                	push   $0x0
  801b11:	51                   	push   %ecx
  801b12:	52                   	push   %edx
  801b13:	ff 75 0c             	pushl  0xc(%ebp)
  801b16:	50                   	push   %eax
  801b17:	6a 1b                	push   $0x1b
  801b19:	e8 19 fd ff ff       	call   801837 <syscall>
  801b1e:	83 c4 18             	add    $0x18,%esp
}
  801b21:	c9                   	leave  
  801b22:	c3                   	ret    

00801b23 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b23:	55                   	push   %ebp
  801b24:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b26:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b29:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 00                	push   $0x0
  801b32:	52                   	push   %edx
  801b33:	50                   	push   %eax
  801b34:	6a 1c                	push   $0x1c
  801b36:	e8 fc fc ff ff       	call   801837 <syscall>
  801b3b:	83 c4 18             	add    $0x18,%esp
}
  801b3e:	c9                   	leave  
  801b3f:	c3                   	ret    

00801b40 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b40:	55                   	push   %ebp
  801b41:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b43:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b46:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b49:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 00                	push   $0x0
  801b50:	51                   	push   %ecx
  801b51:	52                   	push   %edx
  801b52:	50                   	push   %eax
  801b53:	6a 1d                	push   $0x1d
  801b55:	e8 dd fc ff ff       	call   801837 <syscall>
  801b5a:	83 c4 18             	add    $0x18,%esp
}
  801b5d:	c9                   	leave  
  801b5e:	c3                   	ret    

00801b5f <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b5f:	55                   	push   %ebp
  801b60:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b62:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b65:	8b 45 08             	mov    0x8(%ebp),%eax
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	52                   	push   %edx
  801b6f:	50                   	push   %eax
  801b70:	6a 1e                	push   $0x1e
  801b72:	e8 c0 fc ff ff       	call   801837 <syscall>
  801b77:	83 c4 18             	add    $0x18,%esp
}
  801b7a:	c9                   	leave  
  801b7b:	c3                   	ret    

00801b7c <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b7c:	55                   	push   %ebp
  801b7d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	6a 00                	push   $0x0
  801b87:	6a 00                	push   $0x0
  801b89:	6a 1f                	push   $0x1f
  801b8b:	e8 a7 fc ff ff       	call   801837 <syscall>
  801b90:	83 c4 18             	add    $0x18,%esp
}
  801b93:	c9                   	leave  
  801b94:	c3                   	ret    

00801b95 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b95:	55                   	push   %ebp
  801b96:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b98:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9b:	6a 00                	push   $0x0
  801b9d:	ff 75 14             	pushl  0x14(%ebp)
  801ba0:	ff 75 10             	pushl  0x10(%ebp)
  801ba3:	ff 75 0c             	pushl  0xc(%ebp)
  801ba6:	50                   	push   %eax
  801ba7:	6a 20                	push   $0x20
  801ba9:	e8 89 fc ff ff       	call   801837 <syscall>
  801bae:	83 c4 18             	add    $0x18,%esp
}
  801bb1:	c9                   	leave  
  801bb2:	c3                   	ret    

00801bb3 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801bb3:	55                   	push   %ebp
  801bb4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 00                	push   $0x0
  801bc1:	50                   	push   %eax
  801bc2:	6a 21                	push   $0x21
  801bc4:	e8 6e fc ff ff       	call   801837 <syscall>
  801bc9:	83 c4 18             	add    $0x18,%esp
}
  801bcc:	90                   	nop
  801bcd:	c9                   	leave  
  801bce:	c3                   	ret    

00801bcf <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801bcf:	55                   	push   %ebp
  801bd0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	50                   	push   %eax
  801bde:	6a 22                	push   $0x22
  801be0:	e8 52 fc ff ff       	call   801837 <syscall>
  801be5:	83 c4 18             	add    $0x18,%esp
}
  801be8:	c9                   	leave  
  801be9:	c3                   	ret    

00801bea <sys_getenvid>:

int32 sys_getenvid(void)
{
  801bea:	55                   	push   %ebp
  801beb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 02                	push   $0x2
  801bf9:	e8 39 fc ff ff       	call   801837 <syscall>
  801bfe:	83 c4 18             	add    $0x18,%esp
}
  801c01:	c9                   	leave  
  801c02:	c3                   	ret    

00801c03 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c03:	55                   	push   %ebp
  801c04:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c06:	6a 00                	push   $0x0
  801c08:	6a 00                	push   $0x0
  801c0a:	6a 00                	push   $0x0
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 03                	push   $0x3
  801c12:	e8 20 fc ff ff       	call   801837 <syscall>
  801c17:	83 c4 18             	add    $0x18,%esp
}
  801c1a:	c9                   	leave  
  801c1b:	c3                   	ret    

00801c1c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c1c:	55                   	push   %ebp
  801c1d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	6a 00                	push   $0x0
  801c27:	6a 00                	push   $0x0
  801c29:	6a 04                	push   $0x4
  801c2b:	e8 07 fc ff ff       	call   801837 <syscall>
  801c30:	83 c4 18             	add    $0x18,%esp
}
  801c33:	c9                   	leave  
  801c34:	c3                   	ret    

00801c35 <sys_exit_env>:


void sys_exit_env(void)
{
  801c35:	55                   	push   %ebp
  801c36:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	6a 23                	push   $0x23
  801c44:	e8 ee fb ff ff       	call   801837 <syscall>
  801c49:	83 c4 18             	add    $0x18,%esp
}
  801c4c:	90                   	nop
  801c4d:	c9                   	leave  
  801c4e:	c3                   	ret    

00801c4f <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c4f:	55                   	push   %ebp
  801c50:	89 e5                	mov    %esp,%ebp
  801c52:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c55:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c58:	8d 50 04             	lea    0x4(%eax),%edx
  801c5b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 00                	push   $0x0
  801c62:	6a 00                	push   $0x0
  801c64:	52                   	push   %edx
  801c65:	50                   	push   %eax
  801c66:	6a 24                	push   $0x24
  801c68:	e8 ca fb ff ff       	call   801837 <syscall>
  801c6d:	83 c4 18             	add    $0x18,%esp
	return result;
  801c70:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c73:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c76:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c79:	89 01                	mov    %eax,(%ecx)
  801c7b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c81:	c9                   	leave  
  801c82:	c2 04 00             	ret    $0x4

00801c85 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c85:	55                   	push   %ebp
  801c86:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	ff 75 10             	pushl  0x10(%ebp)
  801c8f:	ff 75 0c             	pushl  0xc(%ebp)
  801c92:	ff 75 08             	pushl  0x8(%ebp)
  801c95:	6a 12                	push   $0x12
  801c97:	e8 9b fb ff ff       	call   801837 <syscall>
  801c9c:	83 c4 18             	add    $0x18,%esp
	return ;
  801c9f:	90                   	nop
}
  801ca0:	c9                   	leave  
  801ca1:	c3                   	ret    

00801ca2 <sys_rcr2>:
uint32 sys_rcr2()
{
  801ca2:	55                   	push   %ebp
  801ca3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 00                	push   $0x0
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 00                	push   $0x0
  801cad:	6a 00                	push   $0x0
  801caf:	6a 25                	push   $0x25
  801cb1:	e8 81 fb ff ff       	call   801837 <syscall>
  801cb6:	83 c4 18             	add    $0x18,%esp
}
  801cb9:	c9                   	leave  
  801cba:	c3                   	ret    

00801cbb <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801cbb:	55                   	push   %ebp
  801cbc:	89 e5                	mov    %esp,%ebp
  801cbe:	83 ec 04             	sub    $0x4,%esp
  801cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801cc7:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 00                	push   $0x0
  801cd1:	6a 00                	push   $0x0
  801cd3:	50                   	push   %eax
  801cd4:	6a 26                	push   $0x26
  801cd6:	e8 5c fb ff ff       	call   801837 <syscall>
  801cdb:	83 c4 18             	add    $0x18,%esp
	return ;
  801cde:	90                   	nop
}
  801cdf:	c9                   	leave  
  801ce0:	c3                   	ret    

00801ce1 <rsttst>:
void rsttst()
{
  801ce1:	55                   	push   %ebp
  801ce2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 00                	push   $0x0
  801cec:	6a 00                	push   $0x0
  801cee:	6a 28                	push   $0x28
  801cf0:	e8 42 fb ff ff       	call   801837 <syscall>
  801cf5:	83 c4 18             	add    $0x18,%esp
	return ;
  801cf8:	90                   	nop
}
  801cf9:	c9                   	leave  
  801cfa:	c3                   	ret    

00801cfb <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801cfb:	55                   	push   %ebp
  801cfc:	89 e5                	mov    %esp,%ebp
  801cfe:	83 ec 04             	sub    $0x4,%esp
  801d01:	8b 45 14             	mov    0x14(%ebp),%eax
  801d04:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d07:	8b 55 18             	mov    0x18(%ebp),%edx
  801d0a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d0e:	52                   	push   %edx
  801d0f:	50                   	push   %eax
  801d10:	ff 75 10             	pushl  0x10(%ebp)
  801d13:	ff 75 0c             	pushl  0xc(%ebp)
  801d16:	ff 75 08             	pushl  0x8(%ebp)
  801d19:	6a 27                	push   $0x27
  801d1b:	e8 17 fb ff ff       	call   801837 <syscall>
  801d20:	83 c4 18             	add    $0x18,%esp
	return ;
  801d23:	90                   	nop
}
  801d24:	c9                   	leave  
  801d25:	c3                   	ret    

00801d26 <chktst>:
void chktst(uint32 n)
{
  801d26:	55                   	push   %ebp
  801d27:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 00                	push   $0x0
  801d31:	ff 75 08             	pushl  0x8(%ebp)
  801d34:	6a 29                	push   $0x29
  801d36:	e8 fc fa ff ff       	call   801837 <syscall>
  801d3b:	83 c4 18             	add    $0x18,%esp
	return ;
  801d3e:	90                   	nop
}
  801d3f:	c9                   	leave  
  801d40:	c3                   	ret    

00801d41 <inctst>:

void inctst()
{
  801d41:	55                   	push   %ebp
  801d42:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d44:	6a 00                	push   $0x0
  801d46:	6a 00                	push   $0x0
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 2a                	push   $0x2a
  801d50:	e8 e2 fa ff ff       	call   801837 <syscall>
  801d55:	83 c4 18             	add    $0x18,%esp
	return ;
  801d58:	90                   	nop
}
  801d59:	c9                   	leave  
  801d5a:	c3                   	ret    

00801d5b <gettst>:
uint32 gettst()
{
  801d5b:	55                   	push   %ebp
  801d5c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 00                	push   $0x0
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	6a 00                	push   $0x0
  801d68:	6a 2b                	push   $0x2b
  801d6a:	e8 c8 fa ff ff       	call   801837 <syscall>
  801d6f:	83 c4 18             	add    $0x18,%esp
}
  801d72:	c9                   	leave  
  801d73:	c3                   	ret    

00801d74 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
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
  801d86:	e8 ac fa ff ff       	call   801837 <syscall>
  801d8b:	83 c4 18             	add    $0x18,%esp
  801d8e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d91:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d95:	75 07                	jne    801d9e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d97:	b8 01 00 00 00       	mov    $0x1,%eax
  801d9c:	eb 05                	jmp    801da3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d9e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801da3:	c9                   	leave  
  801da4:	c3                   	ret    

00801da5 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801da5:	55                   	push   %ebp
  801da6:	89 e5                	mov    %esp,%ebp
  801da8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dab:	6a 00                	push   $0x0
  801dad:	6a 00                	push   $0x0
  801daf:	6a 00                	push   $0x0
  801db1:	6a 00                	push   $0x0
  801db3:	6a 00                	push   $0x0
  801db5:	6a 2c                	push   $0x2c
  801db7:	e8 7b fa ff ff       	call   801837 <syscall>
  801dbc:	83 c4 18             	add    $0x18,%esp
  801dbf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801dc2:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801dc6:	75 07                	jne    801dcf <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801dc8:	b8 01 00 00 00       	mov    $0x1,%eax
  801dcd:	eb 05                	jmp    801dd4 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801dcf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dd4:	c9                   	leave  
  801dd5:	c3                   	ret    

00801dd6 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801dd6:	55                   	push   %ebp
  801dd7:	89 e5                	mov    %esp,%ebp
  801dd9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 00                	push   $0x0
  801de0:	6a 00                	push   $0x0
  801de2:	6a 00                	push   $0x0
  801de4:	6a 00                	push   $0x0
  801de6:	6a 2c                	push   $0x2c
  801de8:	e8 4a fa ff ff       	call   801837 <syscall>
  801ded:	83 c4 18             	add    $0x18,%esp
  801df0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801df3:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801df7:	75 07                	jne    801e00 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801df9:	b8 01 00 00 00       	mov    $0x1,%eax
  801dfe:	eb 05                	jmp    801e05 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e00:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e05:	c9                   	leave  
  801e06:	c3                   	ret    

00801e07 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e07:	55                   	push   %ebp
  801e08:	89 e5                	mov    %esp,%ebp
  801e0a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	6a 00                	push   $0x0
  801e17:	6a 2c                	push   $0x2c
  801e19:	e8 19 fa ff ff       	call   801837 <syscall>
  801e1e:	83 c4 18             	add    $0x18,%esp
  801e21:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e24:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e28:	75 07                	jne    801e31 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e2a:	b8 01 00 00 00       	mov    $0x1,%eax
  801e2f:	eb 05                	jmp    801e36 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e31:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e36:	c9                   	leave  
  801e37:	c3                   	ret    

00801e38 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e38:	55                   	push   %ebp
  801e39:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e3b:	6a 00                	push   $0x0
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 00                	push   $0x0
  801e41:	6a 00                	push   $0x0
  801e43:	ff 75 08             	pushl  0x8(%ebp)
  801e46:	6a 2d                	push   $0x2d
  801e48:	e8 ea f9 ff ff       	call   801837 <syscall>
  801e4d:	83 c4 18             	add    $0x18,%esp
	return ;
  801e50:	90                   	nop
}
  801e51:	c9                   	leave  
  801e52:	c3                   	ret    

00801e53 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e53:	55                   	push   %ebp
  801e54:	89 e5                	mov    %esp,%ebp
  801e56:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e57:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e5a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e5d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e60:	8b 45 08             	mov    0x8(%ebp),%eax
  801e63:	6a 00                	push   $0x0
  801e65:	53                   	push   %ebx
  801e66:	51                   	push   %ecx
  801e67:	52                   	push   %edx
  801e68:	50                   	push   %eax
  801e69:	6a 2e                	push   $0x2e
  801e6b:	e8 c7 f9 ff ff       	call   801837 <syscall>
  801e70:	83 c4 18             	add    $0x18,%esp
}
  801e73:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e76:	c9                   	leave  
  801e77:	c3                   	ret    

00801e78 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e78:	55                   	push   %ebp
  801e79:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e81:	6a 00                	push   $0x0
  801e83:	6a 00                	push   $0x0
  801e85:	6a 00                	push   $0x0
  801e87:	52                   	push   %edx
  801e88:	50                   	push   %eax
  801e89:	6a 2f                	push   $0x2f
  801e8b:	e8 a7 f9 ff ff       	call   801837 <syscall>
  801e90:	83 c4 18             	add    $0x18,%esp
}
  801e93:	c9                   	leave  
  801e94:	c3                   	ret    

00801e95 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e95:	55                   	push   %ebp
  801e96:	89 e5                	mov    %esp,%ebp
  801e98:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e9b:	83 ec 0c             	sub    $0xc,%esp
  801e9e:	68 3c 3b 80 00       	push   $0x803b3c
  801ea3:	e8 21 e7 ff ff       	call   8005c9 <cprintf>
  801ea8:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801eab:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801eb2:	83 ec 0c             	sub    $0xc,%esp
  801eb5:	68 68 3b 80 00       	push   $0x803b68
  801eba:	e8 0a e7 ff ff       	call   8005c9 <cprintf>
  801ebf:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801ec2:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ec6:	a1 38 41 80 00       	mov    0x804138,%eax
  801ecb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ece:	eb 56                	jmp    801f26 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ed0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ed4:	74 1c                	je     801ef2 <print_mem_block_lists+0x5d>
  801ed6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed9:	8b 50 08             	mov    0x8(%eax),%edx
  801edc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801edf:	8b 48 08             	mov    0x8(%eax),%ecx
  801ee2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ee5:	8b 40 0c             	mov    0xc(%eax),%eax
  801ee8:	01 c8                	add    %ecx,%eax
  801eea:	39 c2                	cmp    %eax,%edx
  801eec:	73 04                	jae    801ef2 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801eee:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801ef2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef5:	8b 50 08             	mov    0x8(%eax),%edx
  801ef8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801efb:	8b 40 0c             	mov    0xc(%eax),%eax
  801efe:	01 c2                	add    %eax,%edx
  801f00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f03:	8b 40 08             	mov    0x8(%eax),%eax
  801f06:	83 ec 04             	sub    $0x4,%esp
  801f09:	52                   	push   %edx
  801f0a:	50                   	push   %eax
  801f0b:	68 7d 3b 80 00       	push   $0x803b7d
  801f10:	e8 b4 e6 ff ff       	call   8005c9 <cprintf>
  801f15:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f1e:	a1 40 41 80 00       	mov    0x804140,%eax
  801f23:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f26:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f2a:	74 07                	je     801f33 <print_mem_block_lists+0x9e>
  801f2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f2f:	8b 00                	mov    (%eax),%eax
  801f31:	eb 05                	jmp    801f38 <print_mem_block_lists+0xa3>
  801f33:	b8 00 00 00 00       	mov    $0x0,%eax
  801f38:	a3 40 41 80 00       	mov    %eax,0x804140
  801f3d:	a1 40 41 80 00       	mov    0x804140,%eax
  801f42:	85 c0                	test   %eax,%eax
  801f44:	75 8a                	jne    801ed0 <print_mem_block_lists+0x3b>
  801f46:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f4a:	75 84                	jne    801ed0 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f4c:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f50:	75 10                	jne    801f62 <print_mem_block_lists+0xcd>
  801f52:	83 ec 0c             	sub    $0xc,%esp
  801f55:	68 8c 3b 80 00       	push   $0x803b8c
  801f5a:	e8 6a e6 ff ff       	call   8005c9 <cprintf>
  801f5f:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f62:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f69:	83 ec 0c             	sub    $0xc,%esp
  801f6c:	68 b0 3b 80 00       	push   $0x803bb0
  801f71:	e8 53 e6 ff ff       	call   8005c9 <cprintf>
  801f76:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f79:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f7d:	a1 40 40 80 00       	mov    0x804040,%eax
  801f82:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f85:	eb 56                	jmp    801fdd <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f87:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f8b:	74 1c                	je     801fa9 <print_mem_block_lists+0x114>
  801f8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f90:	8b 50 08             	mov    0x8(%eax),%edx
  801f93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f96:	8b 48 08             	mov    0x8(%eax),%ecx
  801f99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f9c:	8b 40 0c             	mov    0xc(%eax),%eax
  801f9f:	01 c8                	add    %ecx,%eax
  801fa1:	39 c2                	cmp    %eax,%edx
  801fa3:	73 04                	jae    801fa9 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801fa5:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801fa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fac:	8b 50 08             	mov    0x8(%eax),%edx
  801faf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb2:	8b 40 0c             	mov    0xc(%eax),%eax
  801fb5:	01 c2                	add    %eax,%edx
  801fb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fba:	8b 40 08             	mov    0x8(%eax),%eax
  801fbd:	83 ec 04             	sub    $0x4,%esp
  801fc0:	52                   	push   %edx
  801fc1:	50                   	push   %eax
  801fc2:	68 7d 3b 80 00       	push   $0x803b7d
  801fc7:	e8 fd e5 ff ff       	call   8005c9 <cprintf>
  801fcc:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801fd5:	a1 48 40 80 00       	mov    0x804048,%eax
  801fda:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fdd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fe1:	74 07                	je     801fea <print_mem_block_lists+0x155>
  801fe3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe6:	8b 00                	mov    (%eax),%eax
  801fe8:	eb 05                	jmp    801fef <print_mem_block_lists+0x15a>
  801fea:	b8 00 00 00 00       	mov    $0x0,%eax
  801fef:	a3 48 40 80 00       	mov    %eax,0x804048
  801ff4:	a1 48 40 80 00       	mov    0x804048,%eax
  801ff9:	85 c0                	test   %eax,%eax
  801ffb:	75 8a                	jne    801f87 <print_mem_block_lists+0xf2>
  801ffd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802001:	75 84                	jne    801f87 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802003:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802007:	75 10                	jne    802019 <print_mem_block_lists+0x184>
  802009:	83 ec 0c             	sub    $0xc,%esp
  80200c:	68 c8 3b 80 00       	push   $0x803bc8
  802011:	e8 b3 e5 ff ff       	call   8005c9 <cprintf>
  802016:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802019:	83 ec 0c             	sub    $0xc,%esp
  80201c:	68 3c 3b 80 00       	push   $0x803b3c
  802021:	e8 a3 e5 ff ff       	call   8005c9 <cprintf>
  802026:	83 c4 10             	add    $0x10,%esp

}
  802029:	90                   	nop
  80202a:	c9                   	leave  
  80202b:	c3                   	ret    

0080202c <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80202c:	55                   	push   %ebp
  80202d:	89 e5                	mov    %esp,%ebp
  80202f:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  802032:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  802039:	00 00 00 
  80203c:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  802043:	00 00 00 
  802046:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  80204d:	00 00 00 
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  802050:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802057:	e9 9e 00 00 00       	jmp    8020fa <initialize_MemBlocksList+0xce>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
  80205c:	a1 50 40 80 00       	mov    0x804050,%eax
  802061:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802064:	c1 e2 04             	shl    $0x4,%edx
  802067:	01 d0                	add    %edx,%eax
  802069:	85 c0                	test   %eax,%eax
  80206b:	75 14                	jne    802081 <initialize_MemBlocksList+0x55>
  80206d:	83 ec 04             	sub    $0x4,%esp
  802070:	68 f0 3b 80 00       	push   $0x803bf0
  802075:	6a 43                	push   $0x43
  802077:	68 13 3c 80 00       	push   $0x803c13
  80207c:	e8 94 e2 ff ff       	call   800315 <_panic>
  802081:	a1 50 40 80 00       	mov    0x804050,%eax
  802086:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802089:	c1 e2 04             	shl    $0x4,%edx
  80208c:	01 d0                	add    %edx,%eax
  80208e:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802094:	89 10                	mov    %edx,(%eax)
  802096:	8b 00                	mov    (%eax),%eax
  802098:	85 c0                	test   %eax,%eax
  80209a:	74 18                	je     8020b4 <initialize_MemBlocksList+0x88>
  80209c:	a1 48 41 80 00       	mov    0x804148,%eax
  8020a1:	8b 15 50 40 80 00    	mov    0x804050,%edx
  8020a7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8020aa:	c1 e1 04             	shl    $0x4,%ecx
  8020ad:	01 ca                	add    %ecx,%edx
  8020af:	89 50 04             	mov    %edx,0x4(%eax)
  8020b2:	eb 12                	jmp    8020c6 <initialize_MemBlocksList+0x9a>
  8020b4:	a1 50 40 80 00       	mov    0x804050,%eax
  8020b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020bc:	c1 e2 04             	shl    $0x4,%edx
  8020bf:	01 d0                	add    %edx,%eax
  8020c1:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8020c6:	a1 50 40 80 00       	mov    0x804050,%eax
  8020cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020ce:	c1 e2 04             	shl    $0x4,%edx
  8020d1:	01 d0                	add    %edx,%eax
  8020d3:	a3 48 41 80 00       	mov    %eax,0x804148
  8020d8:	a1 50 40 80 00       	mov    0x804050,%eax
  8020dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020e0:	c1 e2 04             	shl    $0x4,%edx
  8020e3:	01 d0                	add    %edx,%eax
  8020e5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020ec:	a1 54 41 80 00       	mov    0x804154,%eax
  8020f1:	40                   	inc    %eax
  8020f2:	a3 54 41 80 00       	mov    %eax,0x804154
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  8020f7:	ff 45 f4             	incl   -0xc(%ebp)
  8020fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fd:	3b 45 08             	cmp    0x8(%ebp),%eax
  802100:	0f 82 56 ff ff ff    	jb     80205c <initialize_MemBlocksList+0x30>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
		}
}
  802106:	90                   	nop
  802107:	c9                   	leave  
  802108:	c3                   	ret    

00802109 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802109:	55                   	push   %ebp
  80210a:	89 e5                	mov    %esp,%ebp
  80210c:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  80210f:	a1 38 41 80 00       	mov    0x804138,%eax
  802114:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802117:	eb 18                	jmp    802131 <find_block+0x28>
	{
		if (ele->sva==va)
  802119:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80211c:	8b 40 08             	mov    0x8(%eax),%eax
  80211f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802122:	75 05                	jne    802129 <find_block+0x20>
			return ele;
  802124:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802127:	eb 7b                	jmp    8021a4 <find_block+0x9b>
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  802129:	a1 40 41 80 00       	mov    0x804140,%eax
  80212e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802131:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802135:	74 07                	je     80213e <find_block+0x35>
  802137:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80213a:	8b 00                	mov    (%eax),%eax
  80213c:	eb 05                	jmp    802143 <find_block+0x3a>
  80213e:	b8 00 00 00 00       	mov    $0x0,%eax
  802143:	a3 40 41 80 00       	mov    %eax,0x804140
  802148:	a1 40 41 80 00       	mov    0x804140,%eax
  80214d:	85 c0                	test   %eax,%eax
  80214f:	75 c8                	jne    802119 <find_block+0x10>
  802151:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802155:	75 c2                	jne    802119 <find_block+0x10>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  802157:	a1 40 40 80 00       	mov    0x804040,%eax
  80215c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80215f:	eb 18                	jmp    802179 <find_block+0x70>
	{
		if (ele->sva==va)
  802161:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802164:	8b 40 08             	mov    0x8(%eax),%eax
  802167:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80216a:	75 05                	jne    802171 <find_block+0x68>
					return ele;
  80216c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80216f:	eb 33                	jmp    8021a4 <find_block+0x9b>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  802171:	a1 48 40 80 00       	mov    0x804048,%eax
  802176:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802179:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80217d:	74 07                	je     802186 <find_block+0x7d>
  80217f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802182:	8b 00                	mov    (%eax),%eax
  802184:	eb 05                	jmp    80218b <find_block+0x82>
  802186:	b8 00 00 00 00       	mov    $0x0,%eax
  80218b:	a3 48 40 80 00       	mov    %eax,0x804048
  802190:	a1 48 40 80 00       	mov    0x804048,%eax
  802195:	85 c0                	test   %eax,%eax
  802197:	75 c8                	jne    802161 <find_block+0x58>
  802199:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80219d:	75 c2                	jne    802161 <find_block+0x58>
	{
		if (ele->sva==va)
					return ele;
	}
return NULL;
  80219f:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  8021a4:	c9                   	leave  
  8021a5:	c3                   	ret    

008021a6 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8021a6:	55                   	push   %ebp
  8021a7:	89 e5                	mov    %esp,%ebp
  8021a9:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;

int x =LIST_SIZE(&AllocMemBlocksList);
  8021ac:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021b1:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((x==0))
  8021b4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021b8:	75 62                	jne    80221c <insert_sorted_allocList+0x76>
	{
	//	blockToInsert=AllocMemBlocksList.lh_first;
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  8021ba:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021be:	75 14                	jne    8021d4 <insert_sorted_allocList+0x2e>
  8021c0:	83 ec 04             	sub    $0x4,%esp
  8021c3:	68 f0 3b 80 00       	push   $0x803bf0
  8021c8:	6a 69                	push   $0x69
  8021ca:	68 13 3c 80 00       	push   $0x803c13
  8021cf:	e8 41 e1 ff ff       	call   800315 <_panic>
  8021d4:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8021da:	8b 45 08             	mov    0x8(%ebp),%eax
  8021dd:	89 10                	mov    %edx,(%eax)
  8021df:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e2:	8b 00                	mov    (%eax),%eax
  8021e4:	85 c0                	test   %eax,%eax
  8021e6:	74 0d                	je     8021f5 <insert_sorted_allocList+0x4f>
  8021e8:	a1 40 40 80 00       	mov    0x804040,%eax
  8021ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8021f0:	89 50 04             	mov    %edx,0x4(%eax)
  8021f3:	eb 08                	jmp    8021fd <insert_sorted_allocList+0x57>
  8021f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f8:	a3 44 40 80 00       	mov    %eax,0x804044
  8021fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802200:	a3 40 40 80 00       	mov    %eax,0x804040
  802205:	8b 45 08             	mov    0x8(%ebp),%eax
  802208:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80220f:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802214:	40                   	inc    %eax
  802215:	a3 4c 40 80 00       	mov    %eax,0x80404c
  80221a:	eb 72                	jmp    80228e <insert_sorted_allocList+0xe8>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
  80221c:	a1 40 40 80 00       	mov    0x804040,%eax
  802221:	8b 50 08             	mov    0x8(%eax),%edx
  802224:	8b 45 08             	mov    0x8(%ebp),%eax
  802227:	8b 40 08             	mov    0x8(%eax),%eax
  80222a:	39 c2                	cmp    %eax,%edx
  80222c:	76 60                	jbe    80228e <insert_sorted_allocList+0xe8>
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  80222e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802232:	75 14                	jne    802248 <insert_sorted_allocList+0xa2>
  802234:	83 ec 04             	sub    $0x4,%esp
  802237:	68 f0 3b 80 00       	push   $0x803bf0
  80223c:	6a 6d                	push   $0x6d
  80223e:	68 13 3c 80 00       	push   $0x803c13
  802243:	e8 cd e0 ff ff       	call   800315 <_panic>
  802248:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80224e:	8b 45 08             	mov    0x8(%ebp),%eax
  802251:	89 10                	mov    %edx,(%eax)
  802253:	8b 45 08             	mov    0x8(%ebp),%eax
  802256:	8b 00                	mov    (%eax),%eax
  802258:	85 c0                	test   %eax,%eax
  80225a:	74 0d                	je     802269 <insert_sorted_allocList+0xc3>
  80225c:	a1 40 40 80 00       	mov    0x804040,%eax
  802261:	8b 55 08             	mov    0x8(%ebp),%edx
  802264:	89 50 04             	mov    %edx,0x4(%eax)
  802267:	eb 08                	jmp    802271 <insert_sorted_allocList+0xcb>
  802269:	8b 45 08             	mov    0x8(%ebp),%eax
  80226c:	a3 44 40 80 00       	mov    %eax,0x804044
  802271:	8b 45 08             	mov    0x8(%ebp),%eax
  802274:	a3 40 40 80 00       	mov    %eax,0x804040
  802279:	8b 45 08             	mov    0x8(%ebp),%eax
  80227c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802283:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802288:	40                   	inc    %eax
  802289:	a3 4c 40 80 00       	mov    %eax,0x80404c
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  80228e:	a1 40 40 80 00       	mov    0x804040,%eax
  802293:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802296:	e9 b9 01 00 00       	jmp    802454 <insert_sorted_allocList+0x2ae>
	{


		if ((blockToInsert->sva>AllocMemBlocksList.lh_first->sva)&&blockToInsert->sva<element->sva)
  80229b:	8b 45 08             	mov    0x8(%ebp),%eax
  80229e:	8b 50 08             	mov    0x8(%eax),%edx
  8022a1:	a1 40 40 80 00       	mov    0x804040,%eax
  8022a6:	8b 40 08             	mov    0x8(%eax),%eax
  8022a9:	39 c2                	cmp    %eax,%edx
  8022ab:	76 7c                	jbe    802329 <insert_sorted_allocList+0x183>
  8022ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b0:	8b 50 08             	mov    0x8(%eax),%edx
  8022b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b6:	8b 40 08             	mov    0x8(%eax),%eax
  8022b9:	39 c2                	cmp    %eax,%edx
  8022bb:	73 6c                	jae    802329 <insert_sorted_allocList+0x183>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,element,blockToInsert);
  8022bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022c1:	74 06                	je     8022c9 <insert_sorted_allocList+0x123>
  8022c3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022c7:	75 14                	jne    8022dd <insert_sorted_allocList+0x137>
  8022c9:	83 ec 04             	sub    $0x4,%esp
  8022cc:	68 2c 3c 80 00       	push   $0x803c2c
  8022d1:	6a 75                	push   $0x75
  8022d3:	68 13 3c 80 00       	push   $0x803c13
  8022d8:	e8 38 e0 ff ff       	call   800315 <_panic>
  8022dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e0:	8b 50 04             	mov    0x4(%eax),%edx
  8022e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e6:	89 50 04             	mov    %edx,0x4(%eax)
  8022e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022ef:	89 10                	mov    %edx,(%eax)
  8022f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f4:	8b 40 04             	mov    0x4(%eax),%eax
  8022f7:	85 c0                	test   %eax,%eax
  8022f9:	74 0d                	je     802308 <insert_sorted_allocList+0x162>
  8022fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fe:	8b 40 04             	mov    0x4(%eax),%eax
  802301:	8b 55 08             	mov    0x8(%ebp),%edx
  802304:	89 10                	mov    %edx,(%eax)
  802306:	eb 08                	jmp    802310 <insert_sorted_allocList+0x16a>
  802308:	8b 45 08             	mov    0x8(%ebp),%eax
  80230b:	a3 40 40 80 00       	mov    %eax,0x804040
  802310:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802313:	8b 55 08             	mov    0x8(%ebp),%edx
  802316:	89 50 04             	mov    %edx,0x4(%eax)
  802319:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80231e:	40                   	inc    %eax
  80231f:	a3 4c 40 80 00       	mov    %eax,0x80404c

		break;}
  802324:	e9 59 01 00 00       	jmp    802482 <insert_sorted_allocList+0x2dc>

	else if ((blockToInsert->sva>element->sva)&&(blockToInsert->sva<AllocMemBlocksList.lh_last->sva)&&blockToInsert->sva<LIST_NEXT(element)->sva)
  802329:	8b 45 08             	mov    0x8(%ebp),%eax
  80232c:	8b 50 08             	mov    0x8(%eax),%edx
  80232f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802332:	8b 40 08             	mov    0x8(%eax),%eax
  802335:	39 c2                	cmp    %eax,%edx
  802337:	0f 86 98 00 00 00    	jbe    8023d5 <insert_sorted_allocList+0x22f>
  80233d:	8b 45 08             	mov    0x8(%ebp),%eax
  802340:	8b 50 08             	mov    0x8(%eax),%edx
  802343:	a1 44 40 80 00       	mov    0x804044,%eax
  802348:	8b 40 08             	mov    0x8(%eax),%eax
  80234b:	39 c2                	cmp    %eax,%edx
  80234d:	0f 83 82 00 00 00    	jae    8023d5 <insert_sorted_allocList+0x22f>
  802353:	8b 45 08             	mov    0x8(%ebp),%eax
  802356:	8b 50 08             	mov    0x8(%eax),%edx
  802359:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235c:	8b 00                	mov    (%eax),%eax
  80235e:	8b 40 08             	mov    0x8(%eax),%eax
  802361:	39 c2                	cmp    %eax,%edx
  802363:	73 70                	jae    8023d5 <insert_sorted_allocList+0x22f>
	{

	LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  802365:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802369:	74 06                	je     802371 <insert_sorted_allocList+0x1cb>
  80236b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80236f:	75 14                	jne    802385 <insert_sorted_allocList+0x1df>
  802371:	83 ec 04             	sub    $0x4,%esp
  802374:	68 64 3c 80 00       	push   $0x803c64
  802379:	6a 7c                	push   $0x7c
  80237b:	68 13 3c 80 00       	push   $0x803c13
  802380:	e8 90 df ff ff       	call   800315 <_panic>
  802385:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802388:	8b 10                	mov    (%eax),%edx
  80238a:	8b 45 08             	mov    0x8(%ebp),%eax
  80238d:	89 10                	mov    %edx,(%eax)
  80238f:	8b 45 08             	mov    0x8(%ebp),%eax
  802392:	8b 00                	mov    (%eax),%eax
  802394:	85 c0                	test   %eax,%eax
  802396:	74 0b                	je     8023a3 <insert_sorted_allocList+0x1fd>
  802398:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239b:	8b 00                	mov    (%eax),%eax
  80239d:	8b 55 08             	mov    0x8(%ebp),%edx
  8023a0:	89 50 04             	mov    %edx,0x4(%eax)
  8023a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8023a9:	89 10                	mov    %edx,(%eax)
  8023ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023b1:	89 50 04             	mov    %edx,0x4(%eax)
  8023b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b7:	8b 00                	mov    (%eax),%eax
  8023b9:	85 c0                	test   %eax,%eax
  8023bb:	75 08                	jne    8023c5 <insert_sorted_allocList+0x21f>
  8023bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c0:	a3 44 40 80 00       	mov    %eax,0x804044
  8023c5:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8023ca:	40                   	inc    %eax
  8023cb:	a3 4c 40 80 00       	mov    %eax,0x80404c
		break;
  8023d0:	e9 ad 00 00 00       	jmp    802482 <insert_sorted_allocList+0x2dc>
	}else if (blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  8023d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d8:	8b 50 08             	mov    0x8(%eax),%edx
  8023db:	a1 44 40 80 00       	mov    0x804044,%eax
  8023e0:	8b 40 08             	mov    0x8(%eax),%eax
  8023e3:	39 c2                	cmp    %eax,%edx
  8023e5:	76 65                	jbe    80244c <insert_sorted_allocList+0x2a6>
	{
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
  8023e7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023eb:	75 17                	jne    802404 <insert_sorted_allocList+0x25e>
  8023ed:	83 ec 04             	sub    $0x4,%esp
  8023f0:	68 98 3c 80 00       	push   $0x803c98
  8023f5:	68 80 00 00 00       	push   $0x80
  8023fa:	68 13 3c 80 00       	push   $0x803c13
  8023ff:	e8 11 df ff ff       	call   800315 <_panic>
  802404:	8b 15 44 40 80 00    	mov    0x804044,%edx
  80240a:	8b 45 08             	mov    0x8(%ebp),%eax
  80240d:	89 50 04             	mov    %edx,0x4(%eax)
  802410:	8b 45 08             	mov    0x8(%ebp),%eax
  802413:	8b 40 04             	mov    0x4(%eax),%eax
  802416:	85 c0                	test   %eax,%eax
  802418:	74 0c                	je     802426 <insert_sorted_allocList+0x280>
  80241a:	a1 44 40 80 00       	mov    0x804044,%eax
  80241f:	8b 55 08             	mov    0x8(%ebp),%edx
  802422:	89 10                	mov    %edx,(%eax)
  802424:	eb 08                	jmp    80242e <insert_sorted_allocList+0x288>
  802426:	8b 45 08             	mov    0x8(%ebp),%eax
  802429:	a3 40 40 80 00       	mov    %eax,0x804040
  80242e:	8b 45 08             	mov    0x8(%ebp),%eax
  802431:	a3 44 40 80 00       	mov    %eax,0x804044
  802436:	8b 45 08             	mov    0x8(%ebp),%eax
  802439:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80243f:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802444:	40                   	inc    %eax
  802445:	a3 4c 40 80 00       	mov    %eax,0x80404c
		break;
  80244a:	eb 36                	jmp    802482 <insert_sorted_allocList+0x2dc>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  80244c:	a1 48 40 80 00       	mov    0x804048,%eax
  802451:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802454:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802458:	74 07                	je     802461 <insert_sorted_allocList+0x2bb>
  80245a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245d:	8b 00                	mov    (%eax),%eax
  80245f:	eb 05                	jmp    802466 <insert_sorted_allocList+0x2c0>
  802461:	b8 00 00 00 00       	mov    $0x0,%eax
  802466:	a3 48 40 80 00       	mov    %eax,0x804048
  80246b:	a1 48 40 80 00       	mov    0x804048,%eax
  802470:	85 c0                	test   %eax,%eax
  802472:	0f 85 23 fe ff ff    	jne    80229b <insert_sorted_allocList+0xf5>
  802478:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80247c:	0f 85 19 fe ff ff    	jne    80229b <insert_sorted_allocList+0xf5>
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
		break;

	}
	}
}
  802482:	90                   	nop
  802483:	c9                   	leave  
  802484:	c3                   	ret    

00802485 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802485:	55                   	push   %ebp
  802486:	89 e5                	mov    %esp,%ebp
  802488:	83 ec 18             	sub    $0x18,%esp
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  80248b:	a1 38 41 80 00       	mov    0x804138,%eax
  802490:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802493:	e9 7c 01 00 00       	jmp    802614 <alloc_block_FF+0x18f>
		{
			// case 2
				if(element->size == size)
  802498:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249b:	8b 40 0c             	mov    0xc(%eax),%eax
  80249e:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024a1:	0f 85 90 00 00 00    	jne    802537 <alloc_block_FF+0xb2>
				{
					tmp_block=element;
  8024a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,element);
  8024ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024b1:	75 17                	jne    8024ca <alloc_block_FF+0x45>
  8024b3:	83 ec 04             	sub    $0x4,%esp
  8024b6:	68 bb 3c 80 00       	push   $0x803cbb
  8024bb:	68 ba 00 00 00       	push   $0xba
  8024c0:	68 13 3c 80 00       	push   $0x803c13
  8024c5:	e8 4b de ff ff       	call   800315 <_panic>
  8024ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cd:	8b 00                	mov    (%eax),%eax
  8024cf:	85 c0                	test   %eax,%eax
  8024d1:	74 10                	je     8024e3 <alloc_block_FF+0x5e>
  8024d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d6:	8b 00                	mov    (%eax),%eax
  8024d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024db:	8b 52 04             	mov    0x4(%edx),%edx
  8024de:	89 50 04             	mov    %edx,0x4(%eax)
  8024e1:	eb 0b                	jmp    8024ee <alloc_block_FF+0x69>
  8024e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e6:	8b 40 04             	mov    0x4(%eax),%eax
  8024e9:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8024ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f1:	8b 40 04             	mov    0x4(%eax),%eax
  8024f4:	85 c0                	test   %eax,%eax
  8024f6:	74 0f                	je     802507 <alloc_block_FF+0x82>
  8024f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fb:	8b 40 04             	mov    0x4(%eax),%eax
  8024fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802501:	8b 12                	mov    (%edx),%edx
  802503:	89 10                	mov    %edx,(%eax)
  802505:	eb 0a                	jmp    802511 <alloc_block_FF+0x8c>
  802507:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250a:	8b 00                	mov    (%eax),%eax
  80250c:	a3 38 41 80 00       	mov    %eax,0x804138
  802511:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802514:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80251a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802524:	a1 44 41 80 00       	mov    0x804144,%eax
  802529:	48                   	dec    %eax
  80252a:	a3 44 41 80 00       	mov    %eax,0x804144
					return tmp_block;
  80252f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802532:	e9 10 01 00 00       	jmp    802647 <alloc_block_FF+0x1c2>
				}
				 // case 3
				else if(element->size > size)
  802537:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253a:	8b 40 0c             	mov    0xc(%eax),%eax
  80253d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802540:	0f 86 c6 00 00 00    	jbe    80260c <alloc_block_FF+0x187>
				{
					// the new block are created
					tmp_block = AvailableMemBlocksList.lh_first ;
  802546:	a1 48 41 80 00       	mov    0x804148,%eax
  80254b:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  80254e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802552:	75 17                	jne    80256b <alloc_block_FF+0xe6>
  802554:	83 ec 04             	sub    $0x4,%esp
  802557:	68 bb 3c 80 00       	push   $0x803cbb
  80255c:	68 c2 00 00 00       	push   $0xc2
  802561:	68 13 3c 80 00       	push   $0x803c13
  802566:	e8 aa dd ff ff       	call   800315 <_panic>
  80256b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80256e:	8b 00                	mov    (%eax),%eax
  802570:	85 c0                	test   %eax,%eax
  802572:	74 10                	je     802584 <alloc_block_FF+0xff>
  802574:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802577:	8b 00                	mov    (%eax),%eax
  802579:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80257c:	8b 52 04             	mov    0x4(%edx),%edx
  80257f:	89 50 04             	mov    %edx,0x4(%eax)
  802582:	eb 0b                	jmp    80258f <alloc_block_FF+0x10a>
  802584:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802587:	8b 40 04             	mov    0x4(%eax),%eax
  80258a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80258f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802592:	8b 40 04             	mov    0x4(%eax),%eax
  802595:	85 c0                	test   %eax,%eax
  802597:	74 0f                	je     8025a8 <alloc_block_FF+0x123>
  802599:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80259c:	8b 40 04             	mov    0x4(%eax),%eax
  80259f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025a2:	8b 12                	mov    (%edx),%edx
  8025a4:	89 10                	mov    %edx,(%eax)
  8025a6:	eb 0a                	jmp    8025b2 <alloc_block_FF+0x12d>
  8025a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ab:	8b 00                	mov    (%eax),%eax
  8025ad:	a3 48 41 80 00       	mov    %eax,0x804148
  8025b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025be:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025c5:	a1 54 41 80 00       	mov    0x804154,%eax
  8025ca:	48                   	dec    %eax
  8025cb:	a3 54 41 80 00       	mov    %eax,0x804154
					tmp_block->sva=element->sva;
  8025d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d3:	8b 50 08             	mov    0x8(%eax),%edx
  8025d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025d9:	89 50 08             	mov    %edx,0x8(%eax)
					tmp_block->size=size;
  8025dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025df:	8b 55 08             	mov    0x8(%ebp),%edx
  8025e2:	89 50 0c             	mov    %edx,0xc(%eax)
					//update block with remaining space
					element->size-=size;
  8025e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e8:	8b 40 0c             	mov    0xc(%eax),%eax
  8025eb:	2b 45 08             	sub    0x8(%ebp),%eax
  8025ee:	89 c2                	mov    %eax,%edx
  8025f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f3:	89 50 0c             	mov    %edx,0xc(%eax)
					element->sva = element->sva + size;
  8025f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f9:	8b 50 08             	mov    0x8(%eax),%edx
  8025fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ff:	01 c2                	add    %eax,%edx
  802601:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802604:	89 50 08             	mov    %edx,0x8(%eax)
					// return back the new block
					return tmp_block ;
  802607:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80260a:	eb 3b                	jmp    802647 <alloc_block_FF+0x1c2>
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  80260c:	a1 40 41 80 00       	mov    0x804140,%eax
  802611:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802614:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802618:	74 07                	je     802621 <alloc_block_FF+0x19c>
  80261a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261d:	8b 00                	mov    (%eax),%eax
  80261f:	eb 05                	jmp    802626 <alloc_block_FF+0x1a1>
  802621:	b8 00 00 00 00       	mov    $0x0,%eax
  802626:	a3 40 41 80 00       	mov    %eax,0x804140
  80262b:	a1 40 41 80 00       	mov    0x804140,%eax
  802630:	85 c0                	test   %eax,%eax
  802632:	0f 85 60 fe ff ff    	jne    802498 <alloc_block_FF+0x13>
  802638:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80263c:	0f 85 56 fe ff ff    	jne    802498 <alloc_block_FF+0x13>
					// return back the new block
					return tmp_block ;
				}
		}
		// case 1
	  return NULL ;}
  802642:	b8 00 00 00 00       	mov    $0x0,%eax
  802647:	c9                   	leave  
  802648:	c3                   	ret    

00802649 <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================

struct MemBlock *alloc_block_BF(uint32 size)
{
  802649:	55                   	push   %ebp
  80264a:	89 e5                	mov    %esp,%ebp
  80264c:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
  80264f:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802656:	a1 38 41 80 00       	mov    0x804138,%eax
  80265b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80265e:	eb 3a                	jmp    80269a <alloc_block_BF+0x51>
		{
			if(element->size >= size)
  802660:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802663:	8b 40 0c             	mov    0xc(%eax),%eax
  802666:	3b 45 08             	cmp    0x8(%ebp),%eax
  802669:	72 27                	jb     802692 <alloc_block_BF+0x49>
			{
				if(best_size==-1)
  80266b:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80266f:	75 0b                	jne    80267c <alloc_block_BF+0x33>
					best_size= element->size;
  802671:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802674:	8b 40 0c             	mov    0xc(%eax),%eax
  802677:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80267a:	eb 16                	jmp    802692 <alloc_block_BF+0x49>
				else if(best_size >= element->size)
  80267c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267f:	8b 50 0c             	mov    0xc(%eax),%edx
  802682:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802685:	39 c2                	cmp    %eax,%edx
  802687:	77 09                	ja     802692 <alloc_block_BF+0x49>
					best_size=element->size;
  802689:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268c:	8b 40 0c             	mov    0xc(%eax),%eax
  80268f:	89 45 f0             	mov    %eax,-0x10(%ebp)

struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802692:	a1 40 41 80 00       	mov    0x804140,%eax
  802697:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80269a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80269e:	74 07                	je     8026a7 <alloc_block_BF+0x5e>
  8026a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a3:	8b 00                	mov    (%eax),%eax
  8026a5:	eb 05                	jmp    8026ac <alloc_block_BF+0x63>
  8026a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8026ac:	a3 40 41 80 00       	mov    %eax,0x804140
  8026b1:	a1 40 41 80 00       	mov    0x804140,%eax
  8026b6:	85 c0                	test   %eax,%eax
  8026b8:	75 a6                	jne    802660 <alloc_block_BF+0x17>
  8026ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026be:	75 a0                	jne    802660 <alloc_block_BF+0x17>
					best_size= element->size;
				else if(best_size >= element->size)
					best_size=element->size;
			}
		}
		if(best_size != -1)
  8026c0:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8026c4:	0f 84 d3 01 00 00    	je     80289d <alloc_block_BF+0x254>
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  8026ca:	a1 38 41 80 00       	mov    0x804138,%eax
  8026cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026d2:	e9 98 01 00 00       	jmp    80286f <alloc_block_BF+0x226>
			{
			 if((best_size > size) && (best_size == element->size))
  8026d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026da:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026dd:	0f 86 da 00 00 00    	jbe    8027bd <alloc_block_BF+0x174>
  8026e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e6:	8b 50 0c             	mov    0xc(%eax),%edx
  8026e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ec:	39 c2                	cmp    %eax,%edx
  8026ee:	0f 85 c9 00 00 00    	jne    8027bd <alloc_block_BF+0x174>
			  {
				// the new block are created
			    tmp_block = AvailableMemBlocksList.lh_first ;
  8026f4:	a1 48 41 80 00       	mov    0x804148,%eax
  8026f9:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  8026fc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802700:	75 17                	jne    802719 <alloc_block_BF+0xd0>
  802702:	83 ec 04             	sub    $0x4,%esp
  802705:	68 bb 3c 80 00       	push   $0x803cbb
  80270a:	68 ea 00 00 00       	push   $0xea
  80270f:	68 13 3c 80 00       	push   $0x803c13
  802714:	e8 fc db ff ff       	call   800315 <_panic>
  802719:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80271c:	8b 00                	mov    (%eax),%eax
  80271e:	85 c0                	test   %eax,%eax
  802720:	74 10                	je     802732 <alloc_block_BF+0xe9>
  802722:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802725:	8b 00                	mov    (%eax),%eax
  802727:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80272a:	8b 52 04             	mov    0x4(%edx),%edx
  80272d:	89 50 04             	mov    %edx,0x4(%eax)
  802730:	eb 0b                	jmp    80273d <alloc_block_BF+0xf4>
  802732:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802735:	8b 40 04             	mov    0x4(%eax),%eax
  802738:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80273d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802740:	8b 40 04             	mov    0x4(%eax),%eax
  802743:	85 c0                	test   %eax,%eax
  802745:	74 0f                	je     802756 <alloc_block_BF+0x10d>
  802747:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80274a:	8b 40 04             	mov    0x4(%eax),%eax
  80274d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802750:	8b 12                	mov    (%edx),%edx
  802752:	89 10                	mov    %edx,(%eax)
  802754:	eb 0a                	jmp    802760 <alloc_block_BF+0x117>
  802756:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802759:	8b 00                	mov    (%eax),%eax
  80275b:	a3 48 41 80 00       	mov    %eax,0x804148
  802760:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802763:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802769:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80276c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802773:	a1 54 41 80 00       	mov    0x804154,%eax
  802778:	48                   	dec    %eax
  802779:	a3 54 41 80 00       	mov    %eax,0x804154
				tmp_block->sva=element->sva;
  80277e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802781:	8b 50 08             	mov    0x8(%eax),%edx
  802784:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802787:	89 50 08             	mov    %edx,0x8(%eax)
				tmp_block->size=size;
  80278a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80278d:	8b 55 08             	mov    0x8(%ebp),%edx
  802790:	89 50 0c             	mov    %edx,0xc(%eax)
				//update block with remaining space
				element->size-=size;
  802793:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802796:	8b 40 0c             	mov    0xc(%eax),%eax
  802799:	2b 45 08             	sub    0x8(%ebp),%eax
  80279c:	89 c2                	mov    %eax,%edx
  80279e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a1:	89 50 0c             	mov    %edx,0xc(%eax)
				element->sva = element->sva + size;
  8027a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a7:	8b 50 08             	mov    0x8(%eax),%edx
  8027aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ad:	01 c2                	add    %eax,%edx
  8027af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b2:	89 50 08             	mov    %edx,0x8(%eax)
				// return back the new block
				return tmp_block ;
  8027b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027b8:	e9 e5 00 00 00       	jmp    8028a2 <alloc_block_BF+0x259>

			  }
			else if((element->size == best_size)&&(best_size == size))
  8027bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c0:	8b 50 0c             	mov    0xc(%eax),%edx
  8027c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c6:	39 c2                	cmp    %eax,%edx
  8027c8:	0f 85 99 00 00 00    	jne    802867 <alloc_block_BF+0x21e>
  8027ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027d4:	0f 85 8d 00 00 00    	jne    802867 <alloc_block_BF+0x21e>
			  {
				tmp_block=element;
  8027da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027dd:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&FreeMemBlocksList,element);
  8027e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027e4:	75 17                	jne    8027fd <alloc_block_BF+0x1b4>
  8027e6:	83 ec 04             	sub    $0x4,%esp
  8027e9:	68 bb 3c 80 00       	push   $0x803cbb
  8027ee:	68 f7 00 00 00       	push   $0xf7
  8027f3:	68 13 3c 80 00       	push   $0x803c13
  8027f8:	e8 18 db ff ff       	call   800315 <_panic>
  8027fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802800:	8b 00                	mov    (%eax),%eax
  802802:	85 c0                	test   %eax,%eax
  802804:	74 10                	je     802816 <alloc_block_BF+0x1cd>
  802806:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802809:	8b 00                	mov    (%eax),%eax
  80280b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80280e:	8b 52 04             	mov    0x4(%edx),%edx
  802811:	89 50 04             	mov    %edx,0x4(%eax)
  802814:	eb 0b                	jmp    802821 <alloc_block_BF+0x1d8>
  802816:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802819:	8b 40 04             	mov    0x4(%eax),%eax
  80281c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802821:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802824:	8b 40 04             	mov    0x4(%eax),%eax
  802827:	85 c0                	test   %eax,%eax
  802829:	74 0f                	je     80283a <alloc_block_BF+0x1f1>
  80282b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282e:	8b 40 04             	mov    0x4(%eax),%eax
  802831:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802834:	8b 12                	mov    (%edx),%edx
  802836:	89 10                	mov    %edx,(%eax)
  802838:	eb 0a                	jmp    802844 <alloc_block_BF+0x1fb>
  80283a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283d:	8b 00                	mov    (%eax),%eax
  80283f:	a3 38 41 80 00       	mov    %eax,0x804138
  802844:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802847:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80284d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802850:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802857:	a1 44 41 80 00       	mov    0x804144,%eax
  80285c:	48                   	dec    %eax
  80285d:	a3 44 41 80 00       	mov    %eax,0x804144
				return tmp_block;
  802862:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802865:	eb 3b                	jmp    8028a2 <alloc_block_BF+0x259>
					best_size=element->size;
			}
		}
		if(best_size != -1)
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  802867:	a1 40 41 80 00       	mov    0x804140,%eax
  80286c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80286f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802873:	74 07                	je     80287c <alloc_block_BF+0x233>
  802875:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802878:	8b 00                	mov    (%eax),%eax
  80287a:	eb 05                	jmp    802881 <alloc_block_BF+0x238>
  80287c:	b8 00 00 00 00       	mov    $0x0,%eax
  802881:	a3 40 41 80 00       	mov    %eax,0x804140
  802886:	a1 40 41 80 00       	mov    0x804140,%eax
  80288b:	85 c0                	test   %eax,%eax
  80288d:	0f 85 44 fe ff ff    	jne    8026d7 <alloc_block_BF+0x8e>
  802893:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802897:	0f 85 3a fe ff ff    	jne    8026d7 <alloc_block_BF+0x8e>
				LIST_REMOVE(&FreeMemBlocksList,element);
				return tmp_block;
			 }
			}
		}
		return NULL ;}
  80289d:	b8 00 00 00 00       	mov    $0x0,%eax
  8028a2:	c9                   	leave  
  8028a3:	c3                   	ret    

008028a4 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8028a4:	55                   	push   %ebp
  8028a5:	89 e5                	mov    %esp,%ebp
  8028a7:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  8028aa:	83 ec 04             	sub    $0x4,%esp
  8028ad:	68 dc 3c 80 00       	push   $0x803cdc
  8028b2:	68 04 01 00 00       	push   $0x104
  8028b7:	68 13 3c 80 00       	push   $0x803c13
  8028bc:	e8 54 da ff ff       	call   800315 <_panic>

008028c1 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{struct MemBlock * blk_itr;
  8028c1:	55                   	push   %ebp
  8028c2:	89 e5                	mov    %esp,%ebp
  8028c4:	83 ec 18             	sub    $0x18,%esp
struct MemBlock * next;
struct MemBlock * first = LIST_FIRST(&(FreeMemBlocksList));
  8028c7:	a1 38 41 80 00       	mov    0x804138,%eax
  8028cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
struct MemBlock * last = LIST_LAST(&(FreeMemBlocksList));
  8028cf:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8028d4:	89 45 ec             	mov    %eax,-0x14(%ebp)

if(LIST_EMPTY(&(FreeMemBlocksList)))
  8028d7:	a1 38 41 80 00       	mov    0x804138,%eax
  8028dc:	85 c0                	test   %eax,%eax
  8028de:	75 68                	jne    802948 <insert_sorted_with_merge_freeList+0x87>
			{

				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  8028e0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028e4:	75 17                	jne    8028fd <insert_sorted_with_merge_freeList+0x3c>
  8028e6:	83 ec 04             	sub    $0x4,%esp
  8028e9:	68 f0 3b 80 00       	push   $0x803bf0
  8028ee:	68 14 01 00 00       	push   $0x114
  8028f3:	68 13 3c 80 00       	push   $0x803c13
  8028f8:	e8 18 da ff ff       	call   800315 <_panic>
  8028fd:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802903:	8b 45 08             	mov    0x8(%ebp),%eax
  802906:	89 10                	mov    %edx,(%eax)
  802908:	8b 45 08             	mov    0x8(%ebp),%eax
  80290b:	8b 00                	mov    (%eax),%eax
  80290d:	85 c0                	test   %eax,%eax
  80290f:	74 0d                	je     80291e <insert_sorted_with_merge_freeList+0x5d>
  802911:	a1 38 41 80 00       	mov    0x804138,%eax
  802916:	8b 55 08             	mov    0x8(%ebp),%edx
  802919:	89 50 04             	mov    %edx,0x4(%eax)
  80291c:	eb 08                	jmp    802926 <insert_sorted_with_merge_freeList+0x65>
  80291e:	8b 45 08             	mov    0x8(%ebp),%eax
  802921:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802926:	8b 45 08             	mov    0x8(%ebp),%eax
  802929:	a3 38 41 80 00       	mov    %eax,0x804138
  80292e:	8b 45 08             	mov    0x8(%ebp),%eax
  802931:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802938:	a1 44 41 80 00       	mov    0x804144,%eax
  80293d:	40                   	inc    %eax
  80293e:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  802943:	e9 d2 06 00 00       	jmp    80301a <insert_sorted_with_merge_freeList+0x759>
				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);

			}
else
{
	if( blockToInsert->sva  < first->sva )
  802948:	8b 45 08             	mov    0x8(%ebp),%eax
  80294b:	8b 50 08             	mov    0x8(%eax),%edx
  80294e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802951:	8b 40 08             	mov    0x8(%eax),%eax
  802954:	39 c2                	cmp    %eax,%edx
  802956:	0f 83 22 01 00 00    	jae    802a7e <insert_sorted_with_merge_freeList+0x1bd>
	{
                if( blockToInsert->sva + blockToInsert->size == first->sva)
  80295c:	8b 45 08             	mov    0x8(%ebp),%eax
  80295f:	8b 50 08             	mov    0x8(%eax),%edx
  802962:	8b 45 08             	mov    0x8(%ebp),%eax
  802965:	8b 40 0c             	mov    0xc(%eax),%eax
  802968:	01 c2                	add    %eax,%edx
  80296a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80296d:	8b 40 08             	mov    0x8(%eax),%eax
  802970:	39 c2                	cmp    %eax,%edx
  802972:	0f 85 9e 00 00 00    	jne    802a16 <insert_sorted_with_merge_freeList+0x155>
                {

                	first->sva = blockToInsert->sva;
  802978:	8b 45 08             	mov    0x8(%ebp),%eax
  80297b:	8b 50 08             	mov    0x8(%eax),%edx
  80297e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802981:	89 50 08             	mov    %edx,0x8(%eax)
                	first->size = first->size + blockToInsert->size;
  802984:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802987:	8b 50 0c             	mov    0xc(%eax),%edx
  80298a:	8b 45 08             	mov    0x8(%ebp),%eax
  80298d:	8b 40 0c             	mov    0xc(%eax),%eax
  802990:	01 c2                	add    %eax,%edx
  802992:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802995:	89 50 0c             	mov    %edx,0xc(%eax)
                	blockToInsert->size = blockToInsert->sva = 0;
  802998:	8b 45 08             	mov    0x8(%ebp),%eax
  80299b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8029a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a5:	8b 50 08             	mov    0x8(%eax),%edx
  8029a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ab:	89 50 0c             	mov    %edx,0xc(%eax)
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  8029ae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029b2:	75 17                	jne    8029cb <insert_sorted_with_merge_freeList+0x10a>
  8029b4:	83 ec 04             	sub    $0x4,%esp
  8029b7:	68 f0 3b 80 00       	push   $0x803bf0
  8029bc:	68 21 01 00 00       	push   $0x121
  8029c1:	68 13 3c 80 00       	push   $0x803c13
  8029c6:	e8 4a d9 ff ff       	call   800315 <_panic>
  8029cb:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8029d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d4:	89 10                	mov    %edx,(%eax)
  8029d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d9:	8b 00                	mov    (%eax),%eax
  8029db:	85 c0                	test   %eax,%eax
  8029dd:	74 0d                	je     8029ec <insert_sorted_with_merge_freeList+0x12b>
  8029df:	a1 48 41 80 00       	mov    0x804148,%eax
  8029e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8029e7:	89 50 04             	mov    %edx,0x4(%eax)
  8029ea:	eb 08                	jmp    8029f4 <insert_sorted_with_merge_freeList+0x133>
  8029ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ef:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8029f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f7:	a3 48 41 80 00       	mov    %eax,0x804148
  8029fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a06:	a1 54 41 80 00       	mov    0x804154,%eax
  802a0b:	40                   	inc    %eax
  802a0c:	a3 54 41 80 00       	mov    %eax,0x804154
						}
				}
        }

}
}
  802a11:	e9 04 06 00 00       	jmp    80301a <insert_sorted_with_merge_freeList+0x759>
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
                }

                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  802a16:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a1a:	75 17                	jne    802a33 <insert_sorted_with_merge_freeList+0x172>
  802a1c:	83 ec 04             	sub    $0x4,%esp
  802a1f:	68 f0 3b 80 00       	push   $0x803bf0
  802a24:	68 26 01 00 00       	push   $0x126
  802a29:	68 13 3c 80 00       	push   $0x803c13
  802a2e:	e8 e2 d8 ff ff       	call   800315 <_panic>
  802a33:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802a39:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3c:	89 10                	mov    %edx,(%eax)
  802a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a41:	8b 00                	mov    (%eax),%eax
  802a43:	85 c0                	test   %eax,%eax
  802a45:	74 0d                	je     802a54 <insert_sorted_with_merge_freeList+0x193>
  802a47:	a1 38 41 80 00       	mov    0x804138,%eax
  802a4c:	8b 55 08             	mov    0x8(%ebp),%edx
  802a4f:	89 50 04             	mov    %edx,0x4(%eax)
  802a52:	eb 08                	jmp    802a5c <insert_sorted_with_merge_freeList+0x19b>
  802a54:	8b 45 08             	mov    0x8(%ebp),%eax
  802a57:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5f:	a3 38 41 80 00       	mov    %eax,0x804138
  802a64:	8b 45 08             	mov    0x8(%ebp),%eax
  802a67:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a6e:	a1 44 41 80 00       	mov    0x804144,%eax
  802a73:	40                   	inc    %eax
  802a74:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  802a79:	e9 9c 05 00 00       	jmp    80301a <insert_sorted_with_merge_freeList+0x759>
                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
                }
	}
    else if(blockToInsert->sva > last->sva)
  802a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a81:	8b 50 08             	mov    0x8(%eax),%edx
  802a84:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a87:	8b 40 08             	mov    0x8(%eax),%eax
  802a8a:	39 c2                	cmp    %eax,%edx
  802a8c:	0f 86 16 01 00 00    	jbe    802ba8 <insert_sorted_with_merge_freeList+0x2e7>
 	{

				if(last->sva + last->size == blockToInsert->sva)
  802a92:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a95:	8b 50 08             	mov    0x8(%eax),%edx
  802a98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a9b:	8b 40 0c             	mov    0xc(%eax),%eax
  802a9e:	01 c2                	add    %eax,%edx
  802aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa3:	8b 40 08             	mov    0x8(%eax),%eax
  802aa6:	39 c2                	cmp    %eax,%edx
  802aa8:	0f 85 92 00 00 00    	jne    802b40 <insert_sorted_with_merge_freeList+0x27f>
				{

					last->size = last->size + blockToInsert->size;
  802aae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ab1:	8b 50 0c             	mov    0xc(%eax),%edx
  802ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab7:	8b 40 0c             	mov    0xc(%eax),%eax
  802aba:	01 c2                	add    %eax,%edx
  802abc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802abf:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->size = blockToInsert->sva = 0;
  802ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802acc:	8b 45 08             	mov    0x8(%ebp),%eax
  802acf:	8b 50 08             	mov    0x8(%eax),%edx
  802ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad5:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802ad8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802adc:	75 17                	jne    802af5 <insert_sorted_with_merge_freeList+0x234>
  802ade:	83 ec 04             	sub    $0x4,%esp
  802ae1:	68 f0 3b 80 00       	push   $0x803bf0
  802ae6:	68 31 01 00 00       	push   $0x131
  802aeb:	68 13 3c 80 00       	push   $0x803c13
  802af0:	e8 20 d8 ff ff       	call   800315 <_panic>
  802af5:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802afb:	8b 45 08             	mov    0x8(%ebp),%eax
  802afe:	89 10                	mov    %edx,(%eax)
  802b00:	8b 45 08             	mov    0x8(%ebp),%eax
  802b03:	8b 00                	mov    (%eax),%eax
  802b05:	85 c0                	test   %eax,%eax
  802b07:	74 0d                	je     802b16 <insert_sorted_with_merge_freeList+0x255>
  802b09:	a1 48 41 80 00       	mov    0x804148,%eax
  802b0e:	8b 55 08             	mov    0x8(%ebp),%edx
  802b11:	89 50 04             	mov    %edx,0x4(%eax)
  802b14:	eb 08                	jmp    802b1e <insert_sorted_with_merge_freeList+0x25d>
  802b16:	8b 45 08             	mov    0x8(%ebp),%eax
  802b19:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b21:	a3 48 41 80 00       	mov    %eax,0x804148
  802b26:	8b 45 08             	mov    0x8(%ebp),%eax
  802b29:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b30:	a1 54 41 80 00       	mov    0x804154,%eax
  802b35:	40                   	inc    %eax
  802b36:	a3 54 41 80 00       	mov    %eax,0x804154
						}
				}
        }

}
}
  802b3b:	e9 da 04 00 00       	jmp    80301a <insert_sorted_with_merge_freeList+0x759>

				}

				else
				{
					LIST_INSERT_TAIL(&(FreeMemBlocksList),  blockToInsert);
  802b40:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b44:	75 17                	jne    802b5d <insert_sorted_with_merge_freeList+0x29c>
  802b46:	83 ec 04             	sub    $0x4,%esp
  802b49:	68 98 3c 80 00       	push   $0x803c98
  802b4e:	68 37 01 00 00       	push   $0x137
  802b53:	68 13 3c 80 00       	push   $0x803c13
  802b58:	e8 b8 d7 ff ff       	call   800315 <_panic>
  802b5d:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802b63:	8b 45 08             	mov    0x8(%ebp),%eax
  802b66:	89 50 04             	mov    %edx,0x4(%eax)
  802b69:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6c:	8b 40 04             	mov    0x4(%eax),%eax
  802b6f:	85 c0                	test   %eax,%eax
  802b71:	74 0c                	je     802b7f <insert_sorted_with_merge_freeList+0x2be>
  802b73:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b78:	8b 55 08             	mov    0x8(%ebp),%edx
  802b7b:	89 10                	mov    %edx,(%eax)
  802b7d:	eb 08                	jmp    802b87 <insert_sorted_with_merge_freeList+0x2c6>
  802b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b82:	a3 38 41 80 00       	mov    %eax,0x804138
  802b87:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b92:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b98:	a1 44 41 80 00       	mov    0x804144,%eax
  802b9d:	40                   	inc    %eax
  802b9e:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  802ba3:	e9 72 04 00 00       	jmp    80301a <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  802ba8:	a1 38 41 80 00       	mov    0x804138,%eax
  802bad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bb0:	e9 35 04 00 00       	jmp    802fea <insert_sorted_with_merge_freeList+0x729>
				{
				     next=LIST_NEXT(blk_itr);
  802bb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb8:	8b 00                	mov    (%eax),%eax
  802bba:	89 45 e8             	mov    %eax,-0x18(%ebp)


					if( (blockToInsert->sva > blk_itr->sva) )
  802bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc0:	8b 50 08             	mov    0x8(%eax),%edx
  802bc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc6:	8b 40 08             	mov    0x8(%eax),%eax
  802bc9:	39 c2                	cmp    %eax,%edx
  802bcb:	0f 86 11 04 00 00    	jbe    802fe2 <insert_sorted_with_merge_freeList+0x721>
						{
							if(((blk_itr->sva) + (blk_itr->size) < blockToInsert->sva && (blockToInsert->sva) + (blockToInsert->size) < next->sva))
  802bd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd4:	8b 50 08             	mov    0x8(%eax),%edx
  802bd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bda:	8b 40 0c             	mov    0xc(%eax),%eax
  802bdd:	01 c2                	add    %eax,%edx
  802bdf:	8b 45 08             	mov    0x8(%ebp),%eax
  802be2:	8b 40 08             	mov    0x8(%eax),%eax
  802be5:	39 c2                	cmp    %eax,%edx
  802be7:	0f 83 8b 00 00 00    	jae    802c78 <insert_sorted_with_merge_freeList+0x3b7>
  802bed:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf0:	8b 50 08             	mov    0x8(%eax),%edx
  802bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf6:	8b 40 0c             	mov    0xc(%eax),%eax
  802bf9:	01 c2                	add    %eax,%edx
  802bfb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bfe:	8b 40 08             	mov    0x8(%eax),%eax
  802c01:	39 c2                	cmp    %eax,%edx
  802c03:	73 73                	jae    802c78 <insert_sorted_with_merge_freeList+0x3b7>
							{
								LIST_INSERT_AFTER(&(FreeMemBlocksList), blk_itr, blockToInsert);
  802c05:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c09:	74 06                	je     802c11 <insert_sorted_with_merge_freeList+0x350>
  802c0b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c0f:	75 17                	jne    802c28 <insert_sorted_with_merge_freeList+0x367>
  802c11:	83 ec 04             	sub    $0x4,%esp
  802c14:	68 64 3c 80 00       	push   $0x803c64
  802c19:	68 48 01 00 00       	push   $0x148
  802c1e:	68 13 3c 80 00       	push   $0x803c13
  802c23:	e8 ed d6 ff ff       	call   800315 <_panic>
  802c28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2b:	8b 10                	mov    (%eax),%edx
  802c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c30:	89 10                	mov    %edx,(%eax)
  802c32:	8b 45 08             	mov    0x8(%ebp),%eax
  802c35:	8b 00                	mov    (%eax),%eax
  802c37:	85 c0                	test   %eax,%eax
  802c39:	74 0b                	je     802c46 <insert_sorted_with_merge_freeList+0x385>
  802c3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3e:	8b 00                	mov    (%eax),%eax
  802c40:	8b 55 08             	mov    0x8(%ebp),%edx
  802c43:	89 50 04             	mov    %edx,0x4(%eax)
  802c46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c49:	8b 55 08             	mov    0x8(%ebp),%edx
  802c4c:	89 10                	mov    %edx,(%eax)
  802c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c51:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c54:	89 50 04             	mov    %edx,0x4(%eax)
  802c57:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5a:	8b 00                	mov    (%eax),%eax
  802c5c:	85 c0                	test   %eax,%eax
  802c5e:	75 08                	jne    802c68 <insert_sorted_with_merge_freeList+0x3a7>
  802c60:	8b 45 08             	mov    0x8(%ebp),%eax
  802c63:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c68:	a1 44 41 80 00       	mov    0x804144,%eax
  802c6d:	40                   	inc    %eax
  802c6e:	a3 44 41 80 00       	mov    %eax,0x804144
								break;
  802c73:	e9 a2 03 00 00       	jmp    80301a <insert_sorted_with_merge_freeList+0x759>

							}
							else if((blockToInsert->sva + blockToInsert->size) < next->sva  && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  802c78:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7b:	8b 50 08             	mov    0x8(%eax),%edx
  802c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c81:	8b 40 0c             	mov    0xc(%eax),%eax
  802c84:	01 c2                	add    %eax,%edx
  802c86:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c89:	8b 40 08             	mov    0x8(%eax),%eax
  802c8c:	39 c2                	cmp    %eax,%edx
  802c8e:	0f 83 ae 00 00 00    	jae    802d42 <insert_sorted_with_merge_freeList+0x481>
  802c94:	8b 45 08             	mov    0x8(%ebp),%eax
  802c97:	8b 50 08             	mov    0x8(%eax),%edx
  802c9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9d:	8b 48 08             	mov    0x8(%eax),%ecx
  802ca0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca3:	8b 40 0c             	mov    0xc(%eax),%eax
  802ca6:	01 c8                	add    %ecx,%eax
  802ca8:	39 c2                	cmp    %eax,%edx
  802caa:	0f 85 92 00 00 00    	jne    802d42 <insert_sorted_with_merge_freeList+0x481>
							{

								blk_itr->size=blk_itr->size+blockToInsert->size;
  802cb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb3:	8b 50 0c             	mov    0xc(%eax),%edx
  802cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb9:	8b 40 0c             	mov    0xc(%eax),%eax
  802cbc:	01 c2                	add    %eax,%edx
  802cbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc1:	89 50 0c             	mov    %edx,0xc(%eax)
								 blockToInsert->size=blockToInsert->sva=0;
  802cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802cce:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd1:	8b 50 08             	mov    0x8(%eax),%edx
  802cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd7:	89 50 0c             	mov    %edx,0xc(%eax)
								 LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802cda:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cde:	75 17                	jne    802cf7 <insert_sorted_with_merge_freeList+0x436>
  802ce0:	83 ec 04             	sub    $0x4,%esp
  802ce3:	68 f0 3b 80 00       	push   $0x803bf0
  802ce8:	68 51 01 00 00       	push   $0x151
  802ced:	68 13 3c 80 00       	push   $0x803c13
  802cf2:	e8 1e d6 ff ff       	call   800315 <_panic>
  802cf7:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  802d00:	89 10                	mov    %edx,(%eax)
  802d02:	8b 45 08             	mov    0x8(%ebp),%eax
  802d05:	8b 00                	mov    (%eax),%eax
  802d07:	85 c0                	test   %eax,%eax
  802d09:	74 0d                	je     802d18 <insert_sorted_with_merge_freeList+0x457>
  802d0b:	a1 48 41 80 00       	mov    0x804148,%eax
  802d10:	8b 55 08             	mov    0x8(%ebp),%edx
  802d13:	89 50 04             	mov    %edx,0x4(%eax)
  802d16:	eb 08                	jmp    802d20 <insert_sorted_with_merge_freeList+0x45f>
  802d18:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d20:	8b 45 08             	mov    0x8(%ebp),%eax
  802d23:	a3 48 41 80 00       	mov    %eax,0x804148
  802d28:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d32:	a1 54 41 80 00       	mov    0x804154,%eax
  802d37:	40                   	inc    %eax
  802d38:	a3 54 41 80 00       	mov    %eax,0x804154
								 break;
  802d3d:	e9 d8 02 00 00       	jmp    80301a <insert_sorted_with_merge_freeList+0x759>

							}
							else if( (blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva > (blk_itr->sva + blk_itr->size))
  802d42:	8b 45 08             	mov    0x8(%ebp),%eax
  802d45:	8b 50 08             	mov    0x8(%eax),%edx
  802d48:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4b:	8b 40 0c             	mov    0xc(%eax),%eax
  802d4e:	01 c2                	add    %eax,%edx
  802d50:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d53:	8b 40 08             	mov    0x8(%eax),%eax
  802d56:	39 c2                	cmp    %eax,%edx
  802d58:	0f 85 ba 00 00 00    	jne    802e18 <insert_sorted_with_merge_freeList+0x557>
  802d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d61:	8b 50 08             	mov    0x8(%eax),%edx
  802d64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d67:	8b 48 08             	mov    0x8(%eax),%ecx
  802d6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6d:	8b 40 0c             	mov    0xc(%eax),%eax
  802d70:	01 c8                	add    %ecx,%eax
  802d72:	39 c2                	cmp    %eax,%edx
  802d74:	0f 86 9e 00 00 00    	jbe    802e18 <insert_sorted_with_merge_freeList+0x557>
							{
								next->size = next->size + blockToInsert->size;
  802d7a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d7d:	8b 50 0c             	mov    0xc(%eax),%edx
  802d80:	8b 45 08             	mov    0x8(%ebp),%eax
  802d83:	8b 40 0c             	mov    0xc(%eax),%eax
  802d86:	01 c2                	add    %eax,%edx
  802d88:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d8b:	89 50 0c             	mov    %edx,0xc(%eax)
								next->sva = blockToInsert->sva;
  802d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d91:	8b 50 08             	mov    0x8(%eax),%edx
  802d94:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d97:	89 50 08             	mov    %edx,0x8(%eax)

								blockToInsert->size = blockToInsert->sva = 0;
  802d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802da4:	8b 45 08             	mov    0x8(%ebp),%eax
  802da7:	8b 50 08             	mov    0x8(%eax),%edx
  802daa:	8b 45 08             	mov    0x8(%ebp),%eax
  802dad:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802db0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802db4:	75 17                	jne    802dcd <insert_sorted_with_merge_freeList+0x50c>
  802db6:	83 ec 04             	sub    $0x4,%esp
  802db9:	68 f0 3b 80 00       	push   $0x803bf0
  802dbe:	68 5b 01 00 00       	push   $0x15b
  802dc3:	68 13 3c 80 00       	push   $0x803c13
  802dc8:	e8 48 d5 ff ff       	call   800315 <_panic>
  802dcd:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd6:	89 10                	mov    %edx,(%eax)
  802dd8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddb:	8b 00                	mov    (%eax),%eax
  802ddd:	85 c0                	test   %eax,%eax
  802ddf:	74 0d                	je     802dee <insert_sorted_with_merge_freeList+0x52d>
  802de1:	a1 48 41 80 00       	mov    0x804148,%eax
  802de6:	8b 55 08             	mov    0x8(%ebp),%edx
  802de9:	89 50 04             	mov    %edx,0x4(%eax)
  802dec:	eb 08                	jmp    802df6 <insert_sorted_with_merge_freeList+0x535>
  802dee:	8b 45 08             	mov    0x8(%ebp),%eax
  802df1:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802df6:	8b 45 08             	mov    0x8(%ebp),%eax
  802df9:	a3 48 41 80 00       	mov    %eax,0x804148
  802dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  802e01:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e08:	a1 54 41 80 00       	mov    0x804154,%eax
  802e0d:	40                   	inc    %eax
  802e0e:	a3 54 41 80 00       	mov    %eax,0x804154
								break;
  802e13:	e9 02 02 00 00       	jmp    80301a <insert_sorted_with_merge_freeList+0x759>
							}
							else if ((blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  802e18:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1b:	8b 50 08             	mov    0x8(%eax),%edx
  802e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e21:	8b 40 0c             	mov    0xc(%eax),%eax
  802e24:	01 c2                	add    %eax,%edx
  802e26:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e29:	8b 40 08             	mov    0x8(%eax),%eax
  802e2c:	39 c2                	cmp    %eax,%edx
  802e2e:	0f 85 ae 01 00 00    	jne    802fe2 <insert_sorted_with_merge_freeList+0x721>
  802e34:	8b 45 08             	mov    0x8(%ebp),%eax
  802e37:	8b 50 08             	mov    0x8(%eax),%edx
  802e3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3d:	8b 48 08             	mov    0x8(%eax),%ecx
  802e40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e43:	8b 40 0c             	mov    0xc(%eax),%eax
  802e46:	01 c8                	add    %ecx,%eax
  802e48:	39 c2                	cmp    %eax,%edx
  802e4a:	0f 85 92 01 00 00    	jne    802fe2 <insert_sorted_with_merge_freeList+0x721>
							{
								blk_itr->size = blk_itr->size + blockToInsert->size + next->size;
  802e50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e53:	8b 50 0c             	mov    0xc(%eax),%edx
  802e56:	8b 45 08             	mov    0x8(%ebp),%eax
  802e59:	8b 40 0c             	mov    0xc(%eax),%eax
  802e5c:	01 c2                	add    %eax,%edx
  802e5e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e61:	8b 40 0c             	mov    0xc(%eax),%eax
  802e64:	01 c2                	add    %eax,%edx
  802e66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e69:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size = blockToInsert->sva=0;
  802e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802e76:	8b 45 08             	mov    0x8(%ebp),%eax
  802e79:	8b 50 08             	mov    0x8(%eax),%edx
  802e7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7f:	89 50 0c             	mov    %edx,0xc(%eax)
								next->size = next->sva = 0;
  802e82:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e85:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802e8c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e8f:	8b 50 08             	mov    0x8(%eax),%edx
  802e92:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e95:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_REMOVE(&FreeMemBlocksList, next);
  802e98:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e9c:	75 17                	jne    802eb5 <insert_sorted_with_merge_freeList+0x5f4>
  802e9e:	83 ec 04             	sub    $0x4,%esp
  802ea1:	68 bb 3c 80 00       	push   $0x803cbb
  802ea6:	68 63 01 00 00       	push   $0x163
  802eab:	68 13 3c 80 00       	push   $0x803c13
  802eb0:	e8 60 d4 ff ff       	call   800315 <_panic>
  802eb5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eb8:	8b 00                	mov    (%eax),%eax
  802eba:	85 c0                	test   %eax,%eax
  802ebc:	74 10                	je     802ece <insert_sorted_with_merge_freeList+0x60d>
  802ebe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ec1:	8b 00                	mov    (%eax),%eax
  802ec3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ec6:	8b 52 04             	mov    0x4(%edx),%edx
  802ec9:	89 50 04             	mov    %edx,0x4(%eax)
  802ecc:	eb 0b                	jmp    802ed9 <insert_sorted_with_merge_freeList+0x618>
  802ece:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ed1:	8b 40 04             	mov    0x4(%eax),%eax
  802ed4:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ed9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802edc:	8b 40 04             	mov    0x4(%eax),%eax
  802edf:	85 c0                	test   %eax,%eax
  802ee1:	74 0f                	je     802ef2 <insert_sorted_with_merge_freeList+0x631>
  802ee3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ee6:	8b 40 04             	mov    0x4(%eax),%eax
  802ee9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802eec:	8b 12                	mov    (%edx),%edx
  802eee:	89 10                	mov    %edx,(%eax)
  802ef0:	eb 0a                	jmp    802efc <insert_sorted_with_merge_freeList+0x63b>
  802ef2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ef5:	8b 00                	mov    (%eax),%eax
  802ef7:	a3 38 41 80 00       	mov    %eax,0x804138
  802efc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f05:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f08:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f0f:	a1 44 41 80 00       	mov    0x804144,%eax
  802f14:	48                   	dec    %eax
  802f15:	a3 44 41 80 00       	mov    %eax,0x804144
								LIST_INSERT_HEAD(&AvailableMemBlocksList, next );
  802f1a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f1e:	75 17                	jne    802f37 <insert_sorted_with_merge_freeList+0x676>
  802f20:	83 ec 04             	sub    $0x4,%esp
  802f23:	68 f0 3b 80 00       	push   $0x803bf0
  802f28:	68 64 01 00 00       	push   $0x164
  802f2d:	68 13 3c 80 00       	push   $0x803c13
  802f32:	e8 de d3 ff ff       	call   800315 <_panic>
  802f37:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f40:	89 10                	mov    %edx,(%eax)
  802f42:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f45:	8b 00                	mov    (%eax),%eax
  802f47:	85 c0                	test   %eax,%eax
  802f49:	74 0d                	je     802f58 <insert_sorted_with_merge_freeList+0x697>
  802f4b:	a1 48 41 80 00       	mov    0x804148,%eax
  802f50:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f53:	89 50 04             	mov    %edx,0x4(%eax)
  802f56:	eb 08                	jmp    802f60 <insert_sorted_with_merge_freeList+0x69f>
  802f58:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f5b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f60:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f63:	a3 48 41 80 00       	mov    %eax,0x804148
  802f68:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f6b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f72:	a1 54 41 80 00       	mov    0x804154,%eax
  802f77:	40                   	inc    %eax
  802f78:	a3 54 41 80 00       	mov    %eax,0x804154
							    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802f7d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f81:	75 17                	jne    802f9a <insert_sorted_with_merge_freeList+0x6d9>
  802f83:	83 ec 04             	sub    $0x4,%esp
  802f86:	68 f0 3b 80 00       	push   $0x803bf0
  802f8b:	68 65 01 00 00       	push   $0x165
  802f90:	68 13 3c 80 00       	push   $0x803c13
  802f95:	e8 7b d3 ff ff       	call   800315 <_panic>
  802f9a:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa3:	89 10                	mov    %edx,(%eax)
  802fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa8:	8b 00                	mov    (%eax),%eax
  802faa:	85 c0                	test   %eax,%eax
  802fac:	74 0d                	je     802fbb <insert_sorted_with_merge_freeList+0x6fa>
  802fae:	a1 48 41 80 00       	mov    0x804148,%eax
  802fb3:	8b 55 08             	mov    0x8(%ebp),%edx
  802fb6:	89 50 04             	mov    %edx,0x4(%eax)
  802fb9:	eb 08                	jmp    802fc3 <insert_sorted_with_merge_freeList+0x702>
  802fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbe:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc6:	a3 48 41 80 00       	mov    %eax,0x804148
  802fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fd5:	a1 54 41 80 00       	mov    0x804154,%eax
  802fda:	40                   	inc    %eax
  802fdb:	a3 54 41 80 00       	mov    %eax,0x804154
								break;
  802fe0:	eb 38                	jmp    80301a <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  802fe2:	a1 40 41 80 00       	mov    0x804140,%eax
  802fe7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fee:	74 07                	je     802ff7 <insert_sorted_with_merge_freeList+0x736>
  802ff0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff3:	8b 00                	mov    (%eax),%eax
  802ff5:	eb 05                	jmp    802ffc <insert_sorted_with_merge_freeList+0x73b>
  802ff7:	b8 00 00 00 00       	mov    $0x0,%eax
  802ffc:	a3 40 41 80 00       	mov    %eax,0x804140
  803001:	a1 40 41 80 00       	mov    0x804140,%eax
  803006:	85 c0                	test   %eax,%eax
  803008:	0f 85 a7 fb ff ff    	jne    802bb5 <insert_sorted_with_merge_freeList+0x2f4>
  80300e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803012:	0f 85 9d fb ff ff    	jne    802bb5 <insert_sorted_with_merge_freeList+0x2f4>
						}
				}
        }

}
}
  803018:	eb 00                	jmp    80301a <insert_sorted_with_merge_freeList+0x759>
  80301a:	90                   	nop
  80301b:	c9                   	leave  
  80301c:	c3                   	ret    
  80301d:	66 90                	xchg   %ax,%ax
  80301f:	90                   	nop

00803020 <__udivdi3>:
  803020:	55                   	push   %ebp
  803021:	57                   	push   %edi
  803022:	56                   	push   %esi
  803023:	53                   	push   %ebx
  803024:	83 ec 1c             	sub    $0x1c,%esp
  803027:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80302b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80302f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803033:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803037:	89 ca                	mov    %ecx,%edx
  803039:	89 f8                	mov    %edi,%eax
  80303b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80303f:	85 f6                	test   %esi,%esi
  803041:	75 2d                	jne    803070 <__udivdi3+0x50>
  803043:	39 cf                	cmp    %ecx,%edi
  803045:	77 65                	ja     8030ac <__udivdi3+0x8c>
  803047:	89 fd                	mov    %edi,%ebp
  803049:	85 ff                	test   %edi,%edi
  80304b:	75 0b                	jne    803058 <__udivdi3+0x38>
  80304d:	b8 01 00 00 00       	mov    $0x1,%eax
  803052:	31 d2                	xor    %edx,%edx
  803054:	f7 f7                	div    %edi
  803056:	89 c5                	mov    %eax,%ebp
  803058:	31 d2                	xor    %edx,%edx
  80305a:	89 c8                	mov    %ecx,%eax
  80305c:	f7 f5                	div    %ebp
  80305e:	89 c1                	mov    %eax,%ecx
  803060:	89 d8                	mov    %ebx,%eax
  803062:	f7 f5                	div    %ebp
  803064:	89 cf                	mov    %ecx,%edi
  803066:	89 fa                	mov    %edi,%edx
  803068:	83 c4 1c             	add    $0x1c,%esp
  80306b:	5b                   	pop    %ebx
  80306c:	5e                   	pop    %esi
  80306d:	5f                   	pop    %edi
  80306e:	5d                   	pop    %ebp
  80306f:	c3                   	ret    
  803070:	39 ce                	cmp    %ecx,%esi
  803072:	77 28                	ja     80309c <__udivdi3+0x7c>
  803074:	0f bd fe             	bsr    %esi,%edi
  803077:	83 f7 1f             	xor    $0x1f,%edi
  80307a:	75 40                	jne    8030bc <__udivdi3+0x9c>
  80307c:	39 ce                	cmp    %ecx,%esi
  80307e:	72 0a                	jb     80308a <__udivdi3+0x6a>
  803080:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803084:	0f 87 9e 00 00 00    	ja     803128 <__udivdi3+0x108>
  80308a:	b8 01 00 00 00       	mov    $0x1,%eax
  80308f:	89 fa                	mov    %edi,%edx
  803091:	83 c4 1c             	add    $0x1c,%esp
  803094:	5b                   	pop    %ebx
  803095:	5e                   	pop    %esi
  803096:	5f                   	pop    %edi
  803097:	5d                   	pop    %ebp
  803098:	c3                   	ret    
  803099:	8d 76 00             	lea    0x0(%esi),%esi
  80309c:	31 ff                	xor    %edi,%edi
  80309e:	31 c0                	xor    %eax,%eax
  8030a0:	89 fa                	mov    %edi,%edx
  8030a2:	83 c4 1c             	add    $0x1c,%esp
  8030a5:	5b                   	pop    %ebx
  8030a6:	5e                   	pop    %esi
  8030a7:	5f                   	pop    %edi
  8030a8:	5d                   	pop    %ebp
  8030a9:	c3                   	ret    
  8030aa:	66 90                	xchg   %ax,%ax
  8030ac:	89 d8                	mov    %ebx,%eax
  8030ae:	f7 f7                	div    %edi
  8030b0:	31 ff                	xor    %edi,%edi
  8030b2:	89 fa                	mov    %edi,%edx
  8030b4:	83 c4 1c             	add    $0x1c,%esp
  8030b7:	5b                   	pop    %ebx
  8030b8:	5e                   	pop    %esi
  8030b9:	5f                   	pop    %edi
  8030ba:	5d                   	pop    %ebp
  8030bb:	c3                   	ret    
  8030bc:	bd 20 00 00 00       	mov    $0x20,%ebp
  8030c1:	89 eb                	mov    %ebp,%ebx
  8030c3:	29 fb                	sub    %edi,%ebx
  8030c5:	89 f9                	mov    %edi,%ecx
  8030c7:	d3 e6                	shl    %cl,%esi
  8030c9:	89 c5                	mov    %eax,%ebp
  8030cb:	88 d9                	mov    %bl,%cl
  8030cd:	d3 ed                	shr    %cl,%ebp
  8030cf:	89 e9                	mov    %ebp,%ecx
  8030d1:	09 f1                	or     %esi,%ecx
  8030d3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8030d7:	89 f9                	mov    %edi,%ecx
  8030d9:	d3 e0                	shl    %cl,%eax
  8030db:	89 c5                	mov    %eax,%ebp
  8030dd:	89 d6                	mov    %edx,%esi
  8030df:	88 d9                	mov    %bl,%cl
  8030e1:	d3 ee                	shr    %cl,%esi
  8030e3:	89 f9                	mov    %edi,%ecx
  8030e5:	d3 e2                	shl    %cl,%edx
  8030e7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8030eb:	88 d9                	mov    %bl,%cl
  8030ed:	d3 e8                	shr    %cl,%eax
  8030ef:	09 c2                	or     %eax,%edx
  8030f1:	89 d0                	mov    %edx,%eax
  8030f3:	89 f2                	mov    %esi,%edx
  8030f5:	f7 74 24 0c          	divl   0xc(%esp)
  8030f9:	89 d6                	mov    %edx,%esi
  8030fb:	89 c3                	mov    %eax,%ebx
  8030fd:	f7 e5                	mul    %ebp
  8030ff:	39 d6                	cmp    %edx,%esi
  803101:	72 19                	jb     80311c <__udivdi3+0xfc>
  803103:	74 0b                	je     803110 <__udivdi3+0xf0>
  803105:	89 d8                	mov    %ebx,%eax
  803107:	31 ff                	xor    %edi,%edi
  803109:	e9 58 ff ff ff       	jmp    803066 <__udivdi3+0x46>
  80310e:	66 90                	xchg   %ax,%ax
  803110:	8b 54 24 08          	mov    0x8(%esp),%edx
  803114:	89 f9                	mov    %edi,%ecx
  803116:	d3 e2                	shl    %cl,%edx
  803118:	39 c2                	cmp    %eax,%edx
  80311a:	73 e9                	jae    803105 <__udivdi3+0xe5>
  80311c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80311f:	31 ff                	xor    %edi,%edi
  803121:	e9 40 ff ff ff       	jmp    803066 <__udivdi3+0x46>
  803126:	66 90                	xchg   %ax,%ax
  803128:	31 c0                	xor    %eax,%eax
  80312a:	e9 37 ff ff ff       	jmp    803066 <__udivdi3+0x46>
  80312f:	90                   	nop

00803130 <__umoddi3>:
  803130:	55                   	push   %ebp
  803131:	57                   	push   %edi
  803132:	56                   	push   %esi
  803133:	53                   	push   %ebx
  803134:	83 ec 1c             	sub    $0x1c,%esp
  803137:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80313b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80313f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803143:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803147:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80314b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80314f:	89 f3                	mov    %esi,%ebx
  803151:	89 fa                	mov    %edi,%edx
  803153:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803157:	89 34 24             	mov    %esi,(%esp)
  80315a:	85 c0                	test   %eax,%eax
  80315c:	75 1a                	jne    803178 <__umoddi3+0x48>
  80315e:	39 f7                	cmp    %esi,%edi
  803160:	0f 86 a2 00 00 00    	jbe    803208 <__umoddi3+0xd8>
  803166:	89 c8                	mov    %ecx,%eax
  803168:	89 f2                	mov    %esi,%edx
  80316a:	f7 f7                	div    %edi
  80316c:	89 d0                	mov    %edx,%eax
  80316e:	31 d2                	xor    %edx,%edx
  803170:	83 c4 1c             	add    $0x1c,%esp
  803173:	5b                   	pop    %ebx
  803174:	5e                   	pop    %esi
  803175:	5f                   	pop    %edi
  803176:	5d                   	pop    %ebp
  803177:	c3                   	ret    
  803178:	39 f0                	cmp    %esi,%eax
  80317a:	0f 87 ac 00 00 00    	ja     80322c <__umoddi3+0xfc>
  803180:	0f bd e8             	bsr    %eax,%ebp
  803183:	83 f5 1f             	xor    $0x1f,%ebp
  803186:	0f 84 ac 00 00 00    	je     803238 <__umoddi3+0x108>
  80318c:	bf 20 00 00 00       	mov    $0x20,%edi
  803191:	29 ef                	sub    %ebp,%edi
  803193:	89 fe                	mov    %edi,%esi
  803195:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803199:	89 e9                	mov    %ebp,%ecx
  80319b:	d3 e0                	shl    %cl,%eax
  80319d:	89 d7                	mov    %edx,%edi
  80319f:	89 f1                	mov    %esi,%ecx
  8031a1:	d3 ef                	shr    %cl,%edi
  8031a3:	09 c7                	or     %eax,%edi
  8031a5:	89 e9                	mov    %ebp,%ecx
  8031a7:	d3 e2                	shl    %cl,%edx
  8031a9:	89 14 24             	mov    %edx,(%esp)
  8031ac:	89 d8                	mov    %ebx,%eax
  8031ae:	d3 e0                	shl    %cl,%eax
  8031b0:	89 c2                	mov    %eax,%edx
  8031b2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031b6:	d3 e0                	shl    %cl,%eax
  8031b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8031bc:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031c0:	89 f1                	mov    %esi,%ecx
  8031c2:	d3 e8                	shr    %cl,%eax
  8031c4:	09 d0                	or     %edx,%eax
  8031c6:	d3 eb                	shr    %cl,%ebx
  8031c8:	89 da                	mov    %ebx,%edx
  8031ca:	f7 f7                	div    %edi
  8031cc:	89 d3                	mov    %edx,%ebx
  8031ce:	f7 24 24             	mull   (%esp)
  8031d1:	89 c6                	mov    %eax,%esi
  8031d3:	89 d1                	mov    %edx,%ecx
  8031d5:	39 d3                	cmp    %edx,%ebx
  8031d7:	0f 82 87 00 00 00    	jb     803264 <__umoddi3+0x134>
  8031dd:	0f 84 91 00 00 00    	je     803274 <__umoddi3+0x144>
  8031e3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8031e7:	29 f2                	sub    %esi,%edx
  8031e9:	19 cb                	sbb    %ecx,%ebx
  8031eb:	89 d8                	mov    %ebx,%eax
  8031ed:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8031f1:	d3 e0                	shl    %cl,%eax
  8031f3:	89 e9                	mov    %ebp,%ecx
  8031f5:	d3 ea                	shr    %cl,%edx
  8031f7:	09 d0                	or     %edx,%eax
  8031f9:	89 e9                	mov    %ebp,%ecx
  8031fb:	d3 eb                	shr    %cl,%ebx
  8031fd:	89 da                	mov    %ebx,%edx
  8031ff:	83 c4 1c             	add    $0x1c,%esp
  803202:	5b                   	pop    %ebx
  803203:	5e                   	pop    %esi
  803204:	5f                   	pop    %edi
  803205:	5d                   	pop    %ebp
  803206:	c3                   	ret    
  803207:	90                   	nop
  803208:	89 fd                	mov    %edi,%ebp
  80320a:	85 ff                	test   %edi,%edi
  80320c:	75 0b                	jne    803219 <__umoddi3+0xe9>
  80320e:	b8 01 00 00 00       	mov    $0x1,%eax
  803213:	31 d2                	xor    %edx,%edx
  803215:	f7 f7                	div    %edi
  803217:	89 c5                	mov    %eax,%ebp
  803219:	89 f0                	mov    %esi,%eax
  80321b:	31 d2                	xor    %edx,%edx
  80321d:	f7 f5                	div    %ebp
  80321f:	89 c8                	mov    %ecx,%eax
  803221:	f7 f5                	div    %ebp
  803223:	89 d0                	mov    %edx,%eax
  803225:	e9 44 ff ff ff       	jmp    80316e <__umoddi3+0x3e>
  80322a:	66 90                	xchg   %ax,%ax
  80322c:	89 c8                	mov    %ecx,%eax
  80322e:	89 f2                	mov    %esi,%edx
  803230:	83 c4 1c             	add    $0x1c,%esp
  803233:	5b                   	pop    %ebx
  803234:	5e                   	pop    %esi
  803235:	5f                   	pop    %edi
  803236:	5d                   	pop    %ebp
  803237:	c3                   	ret    
  803238:	3b 04 24             	cmp    (%esp),%eax
  80323b:	72 06                	jb     803243 <__umoddi3+0x113>
  80323d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803241:	77 0f                	ja     803252 <__umoddi3+0x122>
  803243:	89 f2                	mov    %esi,%edx
  803245:	29 f9                	sub    %edi,%ecx
  803247:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80324b:	89 14 24             	mov    %edx,(%esp)
  80324e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803252:	8b 44 24 04          	mov    0x4(%esp),%eax
  803256:	8b 14 24             	mov    (%esp),%edx
  803259:	83 c4 1c             	add    $0x1c,%esp
  80325c:	5b                   	pop    %ebx
  80325d:	5e                   	pop    %esi
  80325e:	5f                   	pop    %edi
  80325f:	5d                   	pop    %ebp
  803260:	c3                   	ret    
  803261:	8d 76 00             	lea    0x0(%esi),%esi
  803264:	2b 04 24             	sub    (%esp),%eax
  803267:	19 fa                	sbb    %edi,%edx
  803269:	89 d1                	mov    %edx,%ecx
  80326b:	89 c6                	mov    %eax,%esi
  80326d:	e9 71 ff ff ff       	jmp    8031e3 <__umoddi3+0xb3>
  803272:	66 90                	xchg   %ax,%ax
  803274:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803278:	72 ea                	jb     803264 <__umoddi3+0x134>
  80327a:	89 d9                	mov    %ebx,%ecx
  80327c:	e9 62 ff ff ff       	jmp    8031e3 <__umoddi3+0xb3>
