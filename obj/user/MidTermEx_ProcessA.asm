
obj/user/MidTermEx_ProcessA:     file format elf32-i386


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
  800031:	e8 36 01 00 00       	call   80016c <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 38             	sub    $0x38,%esp
	int32 parentenvID = sys_getparentenvid();
  80003e:	e8 8c 19 00 00       	call   8019cf <sys_getparentenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int delay;

	/*[1] GET SHARED VARIABLE, SEMAPHORE SEL, check-finishing counter*/
	int *X = sget(parentenvID, "X") ;
  800046:	83 ec 08             	sub    $0x8,%esp
  800049:	68 e0 32 80 00       	push   $0x8032e0
  80004e:	ff 75 f4             	pushl  -0xc(%ebp)
  800051:	e8 4a 14 00 00       	call   8014a0 <sget>
  800056:	83 c4 10             	add    $0x10,%esp
  800059:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int *useSem = sget(parentenvID, "useSem") ;
  80005c:	83 ec 08             	sub    $0x8,%esp
  80005f:	68 e2 32 80 00       	push   $0x8032e2
  800064:	ff 75 f4             	pushl  -0xc(%ebp)
  800067:	e8 34 14 00 00       	call   8014a0 <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int *finishedCount = sget(parentenvID, "finishedCount") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 e9 32 80 00       	push   $0x8032e9
  80007a:	ff 75 f4             	pushl  -0xc(%ebp)
  80007d:	e8 1e 14 00 00       	call   8014a0 <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	/*[2] DO THE JOB*/
	int Y ;
	//random delay
	delay = RAND(2000, 10000);
  800088:	8d 45 c8             	lea    -0x38(%ebp),%eax
  80008b:	83 ec 0c             	sub    $0xc,%esp
  80008e:	50                   	push   %eax
  80008f:	e8 6e 19 00 00       	call   801a02 <sys_get_virtual_time>
  800094:	83 c4 0c             	add    $0xc,%esp
  800097:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80009a:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  80009f:	ba 00 00 00 00       	mov    $0x0,%edx
  8000a4:	f7 f1                	div    %ecx
  8000a6:	89 d0                	mov    %edx,%eax
  8000a8:	05 d0 07 00 00       	add    $0x7d0,%eax
  8000ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	env_sleep(delay);
  8000b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000b3:	83 ec 0c             	sub    $0xc,%esp
  8000b6:	50                   	push   %eax
  8000b7:	e8 14 2d 00 00       	call   802dd0 <env_sleep>
  8000bc:	83 c4 10             	add    $0x10,%esp
//	cprintf("delay = %d\n", delay);

	Y = (*X) * 2 ;
  8000bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c2:	8b 00                	mov    (%eax),%eax
  8000c4:	01 c0                	add    %eax,%eax
  8000c6:	89 45 e0             	mov    %eax,-0x20(%ebp)

	//random delay
	delay = RAND(2000, 10000);
  8000c9:	8d 45 d0             	lea    -0x30(%ebp),%eax
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	50                   	push   %eax
  8000d0:	e8 2d 19 00 00       	call   801a02 <sys_get_virtual_time>
  8000d5:	83 c4 0c             	add    $0xc,%esp
  8000d8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8000db:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  8000e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8000e5:	f7 f1                	div    %ecx
  8000e7:	89 d0                	mov    %edx,%eax
  8000e9:	05 d0 07 00 00       	add    $0x7d0,%eax
  8000ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	env_sleep(delay);
  8000f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f4:	83 ec 0c             	sub    $0xc,%esp
  8000f7:	50                   	push   %eax
  8000f8:	e8 d3 2c 00 00       	call   802dd0 <env_sleep>
  8000fd:	83 c4 10             	add    $0x10,%esp
//	cprintf("delay = %d\n", delay);

	(*X) = Y ;
  800100:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800103:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800106:	89 10                	mov    %edx,(%eax)

	//random delay
	delay = RAND(2000, 10000);
  800108:	8d 45 d8             	lea    -0x28(%ebp),%eax
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	50                   	push   %eax
  80010f:	e8 ee 18 00 00       	call   801a02 <sys_get_virtual_time>
  800114:	83 c4 0c             	add    $0xc,%esp
  800117:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80011a:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  80011f:	ba 00 00 00 00       	mov    $0x0,%edx
  800124:	f7 f1                	div    %ecx
  800126:	89 d0                	mov    %edx,%eax
  800128:	05 d0 07 00 00       	add    $0x7d0,%eax
  80012d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	env_sleep(delay);
  800130:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800133:	83 ec 0c             	sub    $0xc,%esp
  800136:	50                   	push   %eax
  800137:	e8 94 2c 00 00       	call   802dd0 <env_sleep>
  80013c:	83 c4 10             	add    $0x10,%esp
//	cprintf("delay = %d\n", delay);

	if (*useSem == 1)
  80013f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800142:	8b 00                	mov    (%eax),%eax
  800144:	83 f8 01             	cmp    $0x1,%eax
  800147:	75 13                	jne    80015c <_main+0x124>
	{
		sys_signalSemaphore(parentenvID, "T") ;
  800149:	83 ec 08             	sub    $0x8,%esp
  80014c:	68 f7 32 80 00       	push   $0x8032f7
  800151:	ff 75 f4             	pushl  -0xc(%ebp)
  800154:	e8 35 17 00 00       	call   80188e <sys_signalSemaphore>
  800159:	83 c4 10             	add    $0x10,%esp
	}

	/*[3] DECLARE FINISHING*/
	(*finishedCount)++ ;
  80015c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80015f:	8b 00                	mov    (%eax),%eax
  800161:	8d 50 01             	lea    0x1(%eax),%edx
  800164:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800167:	89 10                	mov    %edx,(%eax)

}
  800169:	90                   	nop
  80016a:	c9                   	leave  
  80016b:	c3                   	ret    

0080016c <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80016c:	55                   	push   %ebp
  80016d:	89 e5                	mov    %esp,%ebp
  80016f:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800172:	e8 3f 18 00 00       	call   8019b6 <sys_getenvindex>
  800177:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80017a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80017d:	89 d0                	mov    %edx,%eax
  80017f:	c1 e0 03             	shl    $0x3,%eax
  800182:	01 d0                	add    %edx,%eax
  800184:	01 c0                	add    %eax,%eax
  800186:	01 d0                	add    %edx,%eax
  800188:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80018f:	01 d0                	add    %edx,%eax
  800191:	c1 e0 04             	shl    $0x4,%eax
  800194:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800199:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80019e:	a1 20 40 80 00       	mov    0x804020,%eax
  8001a3:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8001a9:	84 c0                	test   %al,%al
  8001ab:	74 0f                	je     8001bc <libmain+0x50>
		binaryname = myEnv->prog_name;
  8001ad:	a1 20 40 80 00       	mov    0x804020,%eax
  8001b2:	05 5c 05 00 00       	add    $0x55c,%eax
  8001b7:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001bc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001c0:	7e 0a                	jle    8001cc <libmain+0x60>
		binaryname = argv[0];
  8001c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001c5:	8b 00                	mov    (%eax),%eax
  8001c7:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8001cc:	83 ec 08             	sub    $0x8,%esp
  8001cf:	ff 75 0c             	pushl  0xc(%ebp)
  8001d2:	ff 75 08             	pushl  0x8(%ebp)
  8001d5:	e8 5e fe ff ff       	call   800038 <_main>
  8001da:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001dd:	e8 e1 15 00 00       	call   8017c3 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001e2:	83 ec 0c             	sub    $0xc,%esp
  8001e5:	68 14 33 80 00       	push   $0x803314
  8001ea:	e8 8d 01 00 00       	call   80037c <cprintf>
  8001ef:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001f2:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f7:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8001fd:	a1 20 40 80 00       	mov    0x804020,%eax
  800202:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800208:	83 ec 04             	sub    $0x4,%esp
  80020b:	52                   	push   %edx
  80020c:	50                   	push   %eax
  80020d:	68 3c 33 80 00       	push   $0x80333c
  800212:	e8 65 01 00 00       	call   80037c <cprintf>
  800217:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80021a:	a1 20 40 80 00       	mov    0x804020,%eax
  80021f:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800225:	a1 20 40 80 00       	mov    0x804020,%eax
  80022a:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800230:	a1 20 40 80 00       	mov    0x804020,%eax
  800235:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80023b:	51                   	push   %ecx
  80023c:	52                   	push   %edx
  80023d:	50                   	push   %eax
  80023e:	68 64 33 80 00       	push   $0x803364
  800243:	e8 34 01 00 00       	call   80037c <cprintf>
  800248:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80024b:	a1 20 40 80 00       	mov    0x804020,%eax
  800250:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800256:	83 ec 08             	sub    $0x8,%esp
  800259:	50                   	push   %eax
  80025a:	68 bc 33 80 00       	push   $0x8033bc
  80025f:	e8 18 01 00 00       	call   80037c <cprintf>
  800264:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800267:	83 ec 0c             	sub    $0xc,%esp
  80026a:	68 14 33 80 00       	push   $0x803314
  80026f:	e8 08 01 00 00       	call   80037c <cprintf>
  800274:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800277:	e8 61 15 00 00       	call   8017dd <sys_enable_interrupt>

	// exit gracefully
	exit();
  80027c:	e8 19 00 00 00       	call   80029a <exit>
}
  800281:	90                   	nop
  800282:	c9                   	leave  
  800283:	c3                   	ret    

00800284 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800284:	55                   	push   %ebp
  800285:	89 e5                	mov    %esp,%ebp
  800287:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80028a:	83 ec 0c             	sub    $0xc,%esp
  80028d:	6a 00                	push   $0x0
  80028f:	e8 ee 16 00 00       	call   801982 <sys_destroy_env>
  800294:	83 c4 10             	add    $0x10,%esp
}
  800297:	90                   	nop
  800298:	c9                   	leave  
  800299:	c3                   	ret    

0080029a <exit>:

void
exit(void)
{
  80029a:	55                   	push   %ebp
  80029b:	89 e5                	mov    %esp,%ebp
  80029d:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002a0:	e8 43 17 00 00       	call   8019e8 <sys_exit_env>
}
  8002a5:	90                   	nop
  8002a6:	c9                   	leave  
  8002a7:	c3                   	ret    

008002a8 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8002a8:	55                   	push   %ebp
  8002a9:	89 e5                	mov    %esp,%ebp
  8002ab:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8002ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002b1:	8b 00                	mov    (%eax),%eax
  8002b3:	8d 48 01             	lea    0x1(%eax),%ecx
  8002b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002b9:	89 0a                	mov    %ecx,(%edx)
  8002bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8002be:	88 d1                	mov    %dl,%cl
  8002c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002c3:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8002c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ca:	8b 00                	mov    (%eax),%eax
  8002cc:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002d1:	75 2c                	jne    8002ff <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8002d3:	a0 24 40 80 00       	mov    0x804024,%al
  8002d8:	0f b6 c0             	movzbl %al,%eax
  8002db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002de:	8b 12                	mov    (%edx),%edx
  8002e0:	89 d1                	mov    %edx,%ecx
  8002e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002e5:	83 c2 08             	add    $0x8,%edx
  8002e8:	83 ec 04             	sub    $0x4,%esp
  8002eb:	50                   	push   %eax
  8002ec:	51                   	push   %ecx
  8002ed:	52                   	push   %edx
  8002ee:	e8 22 13 00 00       	call   801615 <sys_cputs>
  8002f3:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8002f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8002ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800302:	8b 40 04             	mov    0x4(%eax),%eax
  800305:	8d 50 01             	lea    0x1(%eax),%edx
  800308:	8b 45 0c             	mov    0xc(%ebp),%eax
  80030b:	89 50 04             	mov    %edx,0x4(%eax)
}
  80030e:	90                   	nop
  80030f:	c9                   	leave  
  800310:	c3                   	ret    

00800311 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800311:	55                   	push   %ebp
  800312:	89 e5                	mov    %esp,%ebp
  800314:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80031a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800321:	00 00 00 
	b.cnt = 0;
  800324:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80032b:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80032e:	ff 75 0c             	pushl  0xc(%ebp)
  800331:	ff 75 08             	pushl  0x8(%ebp)
  800334:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80033a:	50                   	push   %eax
  80033b:	68 a8 02 80 00       	push   $0x8002a8
  800340:	e8 11 02 00 00       	call   800556 <vprintfmt>
  800345:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800348:	a0 24 40 80 00       	mov    0x804024,%al
  80034d:	0f b6 c0             	movzbl %al,%eax
  800350:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800356:	83 ec 04             	sub    $0x4,%esp
  800359:	50                   	push   %eax
  80035a:	52                   	push   %edx
  80035b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800361:	83 c0 08             	add    $0x8,%eax
  800364:	50                   	push   %eax
  800365:	e8 ab 12 00 00       	call   801615 <sys_cputs>
  80036a:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80036d:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800374:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80037a:	c9                   	leave  
  80037b:	c3                   	ret    

0080037c <cprintf>:

int cprintf(const char *fmt, ...) {
  80037c:	55                   	push   %ebp
  80037d:	89 e5                	mov    %esp,%ebp
  80037f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800382:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800389:	8d 45 0c             	lea    0xc(%ebp),%eax
  80038c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80038f:	8b 45 08             	mov    0x8(%ebp),%eax
  800392:	83 ec 08             	sub    $0x8,%esp
  800395:	ff 75 f4             	pushl  -0xc(%ebp)
  800398:	50                   	push   %eax
  800399:	e8 73 ff ff ff       	call   800311 <vcprintf>
  80039e:	83 c4 10             	add    $0x10,%esp
  8003a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8003a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003a7:	c9                   	leave  
  8003a8:	c3                   	ret    

008003a9 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8003a9:	55                   	push   %ebp
  8003aa:	89 e5                	mov    %esp,%ebp
  8003ac:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8003af:	e8 0f 14 00 00       	call   8017c3 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8003b4:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8003ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bd:	83 ec 08             	sub    $0x8,%esp
  8003c0:	ff 75 f4             	pushl  -0xc(%ebp)
  8003c3:	50                   	push   %eax
  8003c4:	e8 48 ff ff ff       	call   800311 <vcprintf>
  8003c9:	83 c4 10             	add    $0x10,%esp
  8003cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8003cf:	e8 09 14 00 00       	call   8017dd <sys_enable_interrupt>
	return cnt;
  8003d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003d7:	c9                   	leave  
  8003d8:	c3                   	ret    

008003d9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003d9:	55                   	push   %ebp
  8003da:	89 e5                	mov    %esp,%ebp
  8003dc:	53                   	push   %ebx
  8003dd:	83 ec 14             	sub    $0x14,%esp
  8003e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8003e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8003e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003ec:	8b 45 18             	mov    0x18(%ebp),%eax
  8003ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8003f4:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003f7:	77 55                	ja     80044e <printnum+0x75>
  8003f9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003fc:	72 05                	jb     800403 <printnum+0x2a>
  8003fe:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800401:	77 4b                	ja     80044e <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800403:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800406:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800409:	8b 45 18             	mov    0x18(%ebp),%eax
  80040c:	ba 00 00 00 00       	mov    $0x0,%edx
  800411:	52                   	push   %edx
  800412:	50                   	push   %eax
  800413:	ff 75 f4             	pushl  -0xc(%ebp)
  800416:	ff 75 f0             	pushl  -0x10(%ebp)
  800419:	e8 46 2c 00 00       	call   803064 <__udivdi3>
  80041e:	83 c4 10             	add    $0x10,%esp
  800421:	83 ec 04             	sub    $0x4,%esp
  800424:	ff 75 20             	pushl  0x20(%ebp)
  800427:	53                   	push   %ebx
  800428:	ff 75 18             	pushl  0x18(%ebp)
  80042b:	52                   	push   %edx
  80042c:	50                   	push   %eax
  80042d:	ff 75 0c             	pushl  0xc(%ebp)
  800430:	ff 75 08             	pushl  0x8(%ebp)
  800433:	e8 a1 ff ff ff       	call   8003d9 <printnum>
  800438:	83 c4 20             	add    $0x20,%esp
  80043b:	eb 1a                	jmp    800457 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80043d:	83 ec 08             	sub    $0x8,%esp
  800440:	ff 75 0c             	pushl  0xc(%ebp)
  800443:	ff 75 20             	pushl  0x20(%ebp)
  800446:	8b 45 08             	mov    0x8(%ebp),%eax
  800449:	ff d0                	call   *%eax
  80044b:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80044e:	ff 4d 1c             	decl   0x1c(%ebp)
  800451:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800455:	7f e6                	jg     80043d <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800457:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80045a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80045f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800462:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800465:	53                   	push   %ebx
  800466:	51                   	push   %ecx
  800467:	52                   	push   %edx
  800468:	50                   	push   %eax
  800469:	e8 06 2d 00 00       	call   803174 <__umoddi3>
  80046e:	83 c4 10             	add    $0x10,%esp
  800471:	05 f4 35 80 00       	add    $0x8035f4,%eax
  800476:	8a 00                	mov    (%eax),%al
  800478:	0f be c0             	movsbl %al,%eax
  80047b:	83 ec 08             	sub    $0x8,%esp
  80047e:	ff 75 0c             	pushl  0xc(%ebp)
  800481:	50                   	push   %eax
  800482:	8b 45 08             	mov    0x8(%ebp),%eax
  800485:	ff d0                	call   *%eax
  800487:	83 c4 10             	add    $0x10,%esp
}
  80048a:	90                   	nop
  80048b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80048e:	c9                   	leave  
  80048f:	c3                   	ret    

00800490 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800490:	55                   	push   %ebp
  800491:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800493:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800497:	7e 1c                	jle    8004b5 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800499:	8b 45 08             	mov    0x8(%ebp),%eax
  80049c:	8b 00                	mov    (%eax),%eax
  80049e:	8d 50 08             	lea    0x8(%eax),%edx
  8004a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a4:	89 10                	mov    %edx,(%eax)
  8004a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a9:	8b 00                	mov    (%eax),%eax
  8004ab:	83 e8 08             	sub    $0x8,%eax
  8004ae:	8b 50 04             	mov    0x4(%eax),%edx
  8004b1:	8b 00                	mov    (%eax),%eax
  8004b3:	eb 40                	jmp    8004f5 <getuint+0x65>
	else if (lflag)
  8004b5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004b9:	74 1e                	je     8004d9 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8004bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004be:	8b 00                	mov    (%eax),%eax
  8004c0:	8d 50 04             	lea    0x4(%eax),%edx
  8004c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c6:	89 10                	mov    %edx,(%eax)
  8004c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004cb:	8b 00                	mov    (%eax),%eax
  8004cd:	83 e8 04             	sub    $0x4,%eax
  8004d0:	8b 00                	mov    (%eax),%eax
  8004d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8004d7:	eb 1c                	jmp    8004f5 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8004d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004dc:	8b 00                	mov    (%eax),%eax
  8004de:	8d 50 04             	lea    0x4(%eax),%edx
  8004e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e4:	89 10                	mov    %edx,(%eax)
  8004e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e9:	8b 00                	mov    (%eax),%eax
  8004eb:	83 e8 04             	sub    $0x4,%eax
  8004ee:	8b 00                	mov    (%eax),%eax
  8004f0:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004f5:	5d                   	pop    %ebp
  8004f6:	c3                   	ret    

008004f7 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004f7:	55                   	push   %ebp
  8004f8:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004fa:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004fe:	7e 1c                	jle    80051c <getint+0x25>
		return va_arg(*ap, long long);
  800500:	8b 45 08             	mov    0x8(%ebp),%eax
  800503:	8b 00                	mov    (%eax),%eax
  800505:	8d 50 08             	lea    0x8(%eax),%edx
  800508:	8b 45 08             	mov    0x8(%ebp),%eax
  80050b:	89 10                	mov    %edx,(%eax)
  80050d:	8b 45 08             	mov    0x8(%ebp),%eax
  800510:	8b 00                	mov    (%eax),%eax
  800512:	83 e8 08             	sub    $0x8,%eax
  800515:	8b 50 04             	mov    0x4(%eax),%edx
  800518:	8b 00                	mov    (%eax),%eax
  80051a:	eb 38                	jmp    800554 <getint+0x5d>
	else if (lflag)
  80051c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800520:	74 1a                	je     80053c <getint+0x45>
		return va_arg(*ap, long);
  800522:	8b 45 08             	mov    0x8(%ebp),%eax
  800525:	8b 00                	mov    (%eax),%eax
  800527:	8d 50 04             	lea    0x4(%eax),%edx
  80052a:	8b 45 08             	mov    0x8(%ebp),%eax
  80052d:	89 10                	mov    %edx,(%eax)
  80052f:	8b 45 08             	mov    0x8(%ebp),%eax
  800532:	8b 00                	mov    (%eax),%eax
  800534:	83 e8 04             	sub    $0x4,%eax
  800537:	8b 00                	mov    (%eax),%eax
  800539:	99                   	cltd   
  80053a:	eb 18                	jmp    800554 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80053c:	8b 45 08             	mov    0x8(%ebp),%eax
  80053f:	8b 00                	mov    (%eax),%eax
  800541:	8d 50 04             	lea    0x4(%eax),%edx
  800544:	8b 45 08             	mov    0x8(%ebp),%eax
  800547:	89 10                	mov    %edx,(%eax)
  800549:	8b 45 08             	mov    0x8(%ebp),%eax
  80054c:	8b 00                	mov    (%eax),%eax
  80054e:	83 e8 04             	sub    $0x4,%eax
  800551:	8b 00                	mov    (%eax),%eax
  800553:	99                   	cltd   
}
  800554:	5d                   	pop    %ebp
  800555:	c3                   	ret    

00800556 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800556:	55                   	push   %ebp
  800557:	89 e5                	mov    %esp,%ebp
  800559:	56                   	push   %esi
  80055a:	53                   	push   %ebx
  80055b:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80055e:	eb 17                	jmp    800577 <vprintfmt+0x21>
			if (ch == '\0')
  800560:	85 db                	test   %ebx,%ebx
  800562:	0f 84 af 03 00 00    	je     800917 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800568:	83 ec 08             	sub    $0x8,%esp
  80056b:	ff 75 0c             	pushl  0xc(%ebp)
  80056e:	53                   	push   %ebx
  80056f:	8b 45 08             	mov    0x8(%ebp),%eax
  800572:	ff d0                	call   *%eax
  800574:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800577:	8b 45 10             	mov    0x10(%ebp),%eax
  80057a:	8d 50 01             	lea    0x1(%eax),%edx
  80057d:	89 55 10             	mov    %edx,0x10(%ebp)
  800580:	8a 00                	mov    (%eax),%al
  800582:	0f b6 d8             	movzbl %al,%ebx
  800585:	83 fb 25             	cmp    $0x25,%ebx
  800588:	75 d6                	jne    800560 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80058a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80058e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800595:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80059c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8005a3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8005ad:	8d 50 01             	lea    0x1(%eax),%edx
  8005b0:	89 55 10             	mov    %edx,0x10(%ebp)
  8005b3:	8a 00                	mov    (%eax),%al
  8005b5:	0f b6 d8             	movzbl %al,%ebx
  8005b8:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8005bb:	83 f8 55             	cmp    $0x55,%eax
  8005be:	0f 87 2b 03 00 00    	ja     8008ef <vprintfmt+0x399>
  8005c4:	8b 04 85 18 36 80 00 	mov    0x803618(,%eax,4),%eax
  8005cb:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8005cd:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8005d1:	eb d7                	jmp    8005aa <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8005d3:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8005d7:	eb d1                	jmp    8005aa <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005d9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8005e0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005e3:	89 d0                	mov    %edx,%eax
  8005e5:	c1 e0 02             	shl    $0x2,%eax
  8005e8:	01 d0                	add    %edx,%eax
  8005ea:	01 c0                	add    %eax,%eax
  8005ec:	01 d8                	add    %ebx,%eax
  8005ee:	83 e8 30             	sub    $0x30,%eax
  8005f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8005f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8005f7:	8a 00                	mov    (%eax),%al
  8005f9:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8005fc:	83 fb 2f             	cmp    $0x2f,%ebx
  8005ff:	7e 3e                	jle    80063f <vprintfmt+0xe9>
  800601:	83 fb 39             	cmp    $0x39,%ebx
  800604:	7f 39                	jg     80063f <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800606:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800609:	eb d5                	jmp    8005e0 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80060b:	8b 45 14             	mov    0x14(%ebp),%eax
  80060e:	83 c0 04             	add    $0x4,%eax
  800611:	89 45 14             	mov    %eax,0x14(%ebp)
  800614:	8b 45 14             	mov    0x14(%ebp),%eax
  800617:	83 e8 04             	sub    $0x4,%eax
  80061a:	8b 00                	mov    (%eax),%eax
  80061c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80061f:	eb 1f                	jmp    800640 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800621:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800625:	79 83                	jns    8005aa <vprintfmt+0x54>
				width = 0;
  800627:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80062e:	e9 77 ff ff ff       	jmp    8005aa <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800633:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80063a:	e9 6b ff ff ff       	jmp    8005aa <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80063f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800640:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800644:	0f 89 60 ff ff ff    	jns    8005aa <vprintfmt+0x54>
				width = precision, precision = -1;
  80064a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80064d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800650:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800657:	e9 4e ff ff ff       	jmp    8005aa <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80065c:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80065f:	e9 46 ff ff ff       	jmp    8005aa <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800664:	8b 45 14             	mov    0x14(%ebp),%eax
  800667:	83 c0 04             	add    $0x4,%eax
  80066a:	89 45 14             	mov    %eax,0x14(%ebp)
  80066d:	8b 45 14             	mov    0x14(%ebp),%eax
  800670:	83 e8 04             	sub    $0x4,%eax
  800673:	8b 00                	mov    (%eax),%eax
  800675:	83 ec 08             	sub    $0x8,%esp
  800678:	ff 75 0c             	pushl  0xc(%ebp)
  80067b:	50                   	push   %eax
  80067c:	8b 45 08             	mov    0x8(%ebp),%eax
  80067f:	ff d0                	call   *%eax
  800681:	83 c4 10             	add    $0x10,%esp
			break;
  800684:	e9 89 02 00 00       	jmp    800912 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800689:	8b 45 14             	mov    0x14(%ebp),%eax
  80068c:	83 c0 04             	add    $0x4,%eax
  80068f:	89 45 14             	mov    %eax,0x14(%ebp)
  800692:	8b 45 14             	mov    0x14(%ebp),%eax
  800695:	83 e8 04             	sub    $0x4,%eax
  800698:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80069a:	85 db                	test   %ebx,%ebx
  80069c:	79 02                	jns    8006a0 <vprintfmt+0x14a>
				err = -err;
  80069e:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8006a0:	83 fb 64             	cmp    $0x64,%ebx
  8006a3:	7f 0b                	jg     8006b0 <vprintfmt+0x15a>
  8006a5:	8b 34 9d 60 34 80 00 	mov    0x803460(,%ebx,4),%esi
  8006ac:	85 f6                	test   %esi,%esi
  8006ae:	75 19                	jne    8006c9 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006b0:	53                   	push   %ebx
  8006b1:	68 05 36 80 00       	push   $0x803605
  8006b6:	ff 75 0c             	pushl  0xc(%ebp)
  8006b9:	ff 75 08             	pushl  0x8(%ebp)
  8006bc:	e8 5e 02 00 00       	call   80091f <printfmt>
  8006c1:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8006c4:	e9 49 02 00 00       	jmp    800912 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8006c9:	56                   	push   %esi
  8006ca:	68 0e 36 80 00       	push   $0x80360e
  8006cf:	ff 75 0c             	pushl  0xc(%ebp)
  8006d2:	ff 75 08             	pushl  0x8(%ebp)
  8006d5:	e8 45 02 00 00       	call   80091f <printfmt>
  8006da:	83 c4 10             	add    $0x10,%esp
			break;
  8006dd:	e9 30 02 00 00       	jmp    800912 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e5:	83 c0 04             	add    $0x4,%eax
  8006e8:	89 45 14             	mov    %eax,0x14(%ebp)
  8006eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ee:	83 e8 04             	sub    $0x4,%eax
  8006f1:	8b 30                	mov    (%eax),%esi
  8006f3:	85 f6                	test   %esi,%esi
  8006f5:	75 05                	jne    8006fc <vprintfmt+0x1a6>
				p = "(null)";
  8006f7:	be 11 36 80 00       	mov    $0x803611,%esi
			if (width > 0 && padc != '-')
  8006fc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800700:	7e 6d                	jle    80076f <vprintfmt+0x219>
  800702:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800706:	74 67                	je     80076f <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800708:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80070b:	83 ec 08             	sub    $0x8,%esp
  80070e:	50                   	push   %eax
  80070f:	56                   	push   %esi
  800710:	e8 0c 03 00 00       	call   800a21 <strnlen>
  800715:	83 c4 10             	add    $0x10,%esp
  800718:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80071b:	eb 16                	jmp    800733 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80071d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800721:	83 ec 08             	sub    $0x8,%esp
  800724:	ff 75 0c             	pushl  0xc(%ebp)
  800727:	50                   	push   %eax
  800728:	8b 45 08             	mov    0x8(%ebp),%eax
  80072b:	ff d0                	call   *%eax
  80072d:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800730:	ff 4d e4             	decl   -0x1c(%ebp)
  800733:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800737:	7f e4                	jg     80071d <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800739:	eb 34                	jmp    80076f <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80073b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80073f:	74 1c                	je     80075d <vprintfmt+0x207>
  800741:	83 fb 1f             	cmp    $0x1f,%ebx
  800744:	7e 05                	jle    80074b <vprintfmt+0x1f5>
  800746:	83 fb 7e             	cmp    $0x7e,%ebx
  800749:	7e 12                	jle    80075d <vprintfmt+0x207>
					putch('?', putdat);
  80074b:	83 ec 08             	sub    $0x8,%esp
  80074e:	ff 75 0c             	pushl  0xc(%ebp)
  800751:	6a 3f                	push   $0x3f
  800753:	8b 45 08             	mov    0x8(%ebp),%eax
  800756:	ff d0                	call   *%eax
  800758:	83 c4 10             	add    $0x10,%esp
  80075b:	eb 0f                	jmp    80076c <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80075d:	83 ec 08             	sub    $0x8,%esp
  800760:	ff 75 0c             	pushl  0xc(%ebp)
  800763:	53                   	push   %ebx
  800764:	8b 45 08             	mov    0x8(%ebp),%eax
  800767:	ff d0                	call   *%eax
  800769:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80076c:	ff 4d e4             	decl   -0x1c(%ebp)
  80076f:	89 f0                	mov    %esi,%eax
  800771:	8d 70 01             	lea    0x1(%eax),%esi
  800774:	8a 00                	mov    (%eax),%al
  800776:	0f be d8             	movsbl %al,%ebx
  800779:	85 db                	test   %ebx,%ebx
  80077b:	74 24                	je     8007a1 <vprintfmt+0x24b>
  80077d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800781:	78 b8                	js     80073b <vprintfmt+0x1e5>
  800783:	ff 4d e0             	decl   -0x20(%ebp)
  800786:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80078a:	79 af                	jns    80073b <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80078c:	eb 13                	jmp    8007a1 <vprintfmt+0x24b>
				putch(' ', putdat);
  80078e:	83 ec 08             	sub    $0x8,%esp
  800791:	ff 75 0c             	pushl  0xc(%ebp)
  800794:	6a 20                	push   $0x20
  800796:	8b 45 08             	mov    0x8(%ebp),%eax
  800799:	ff d0                	call   *%eax
  80079b:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80079e:	ff 4d e4             	decl   -0x1c(%ebp)
  8007a1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007a5:	7f e7                	jg     80078e <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8007a7:	e9 66 01 00 00       	jmp    800912 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8007ac:	83 ec 08             	sub    $0x8,%esp
  8007af:	ff 75 e8             	pushl  -0x18(%ebp)
  8007b2:	8d 45 14             	lea    0x14(%ebp),%eax
  8007b5:	50                   	push   %eax
  8007b6:	e8 3c fd ff ff       	call   8004f7 <getint>
  8007bb:	83 c4 10             	add    $0x10,%esp
  8007be:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007c1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8007c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007ca:	85 d2                	test   %edx,%edx
  8007cc:	79 23                	jns    8007f1 <vprintfmt+0x29b>
				putch('-', putdat);
  8007ce:	83 ec 08             	sub    $0x8,%esp
  8007d1:	ff 75 0c             	pushl  0xc(%ebp)
  8007d4:	6a 2d                	push   $0x2d
  8007d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d9:	ff d0                	call   *%eax
  8007db:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8007de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007e4:	f7 d8                	neg    %eax
  8007e6:	83 d2 00             	adc    $0x0,%edx
  8007e9:	f7 da                	neg    %edx
  8007eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007ee:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8007f1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007f8:	e9 bc 00 00 00       	jmp    8008b9 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007fd:	83 ec 08             	sub    $0x8,%esp
  800800:	ff 75 e8             	pushl  -0x18(%ebp)
  800803:	8d 45 14             	lea    0x14(%ebp),%eax
  800806:	50                   	push   %eax
  800807:	e8 84 fc ff ff       	call   800490 <getuint>
  80080c:	83 c4 10             	add    $0x10,%esp
  80080f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800812:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800815:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80081c:	e9 98 00 00 00       	jmp    8008b9 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800821:	83 ec 08             	sub    $0x8,%esp
  800824:	ff 75 0c             	pushl  0xc(%ebp)
  800827:	6a 58                	push   $0x58
  800829:	8b 45 08             	mov    0x8(%ebp),%eax
  80082c:	ff d0                	call   *%eax
  80082e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800831:	83 ec 08             	sub    $0x8,%esp
  800834:	ff 75 0c             	pushl  0xc(%ebp)
  800837:	6a 58                	push   $0x58
  800839:	8b 45 08             	mov    0x8(%ebp),%eax
  80083c:	ff d0                	call   *%eax
  80083e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800841:	83 ec 08             	sub    $0x8,%esp
  800844:	ff 75 0c             	pushl  0xc(%ebp)
  800847:	6a 58                	push   $0x58
  800849:	8b 45 08             	mov    0x8(%ebp),%eax
  80084c:	ff d0                	call   *%eax
  80084e:	83 c4 10             	add    $0x10,%esp
			break;
  800851:	e9 bc 00 00 00       	jmp    800912 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800856:	83 ec 08             	sub    $0x8,%esp
  800859:	ff 75 0c             	pushl  0xc(%ebp)
  80085c:	6a 30                	push   $0x30
  80085e:	8b 45 08             	mov    0x8(%ebp),%eax
  800861:	ff d0                	call   *%eax
  800863:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800866:	83 ec 08             	sub    $0x8,%esp
  800869:	ff 75 0c             	pushl  0xc(%ebp)
  80086c:	6a 78                	push   $0x78
  80086e:	8b 45 08             	mov    0x8(%ebp),%eax
  800871:	ff d0                	call   *%eax
  800873:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800876:	8b 45 14             	mov    0x14(%ebp),%eax
  800879:	83 c0 04             	add    $0x4,%eax
  80087c:	89 45 14             	mov    %eax,0x14(%ebp)
  80087f:	8b 45 14             	mov    0x14(%ebp),%eax
  800882:	83 e8 04             	sub    $0x4,%eax
  800885:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800887:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80088a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800891:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800898:	eb 1f                	jmp    8008b9 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80089a:	83 ec 08             	sub    $0x8,%esp
  80089d:	ff 75 e8             	pushl  -0x18(%ebp)
  8008a0:	8d 45 14             	lea    0x14(%ebp),%eax
  8008a3:	50                   	push   %eax
  8008a4:	e8 e7 fb ff ff       	call   800490 <getuint>
  8008a9:	83 c4 10             	add    $0x10,%esp
  8008ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008af:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8008b2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8008b9:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8008bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008c0:	83 ec 04             	sub    $0x4,%esp
  8008c3:	52                   	push   %edx
  8008c4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8008c7:	50                   	push   %eax
  8008c8:	ff 75 f4             	pushl  -0xc(%ebp)
  8008cb:	ff 75 f0             	pushl  -0x10(%ebp)
  8008ce:	ff 75 0c             	pushl  0xc(%ebp)
  8008d1:	ff 75 08             	pushl  0x8(%ebp)
  8008d4:	e8 00 fb ff ff       	call   8003d9 <printnum>
  8008d9:	83 c4 20             	add    $0x20,%esp
			break;
  8008dc:	eb 34                	jmp    800912 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008de:	83 ec 08             	sub    $0x8,%esp
  8008e1:	ff 75 0c             	pushl  0xc(%ebp)
  8008e4:	53                   	push   %ebx
  8008e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e8:	ff d0                	call   *%eax
  8008ea:	83 c4 10             	add    $0x10,%esp
			break;
  8008ed:	eb 23                	jmp    800912 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008ef:	83 ec 08             	sub    $0x8,%esp
  8008f2:	ff 75 0c             	pushl  0xc(%ebp)
  8008f5:	6a 25                	push   $0x25
  8008f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fa:	ff d0                	call   *%eax
  8008fc:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008ff:	ff 4d 10             	decl   0x10(%ebp)
  800902:	eb 03                	jmp    800907 <vprintfmt+0x3b1>
  800904:	ff 4d 10             	decl   0x10(%ebp)
  800907:	8b 45 10             	mov    0x10(%ebp),%eax
  80090a:	48                   	dec    %eax
  80090b:	8a 00                	mov    (%eax),%al
  80090d:	3c 25                	cmp    $0x25,%al
  80090f:	75 f3                	jne    800904 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800911:	90                   	nop
		}
	}
  800912:	e9 47 fc ff ff       	jmp    80055e <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800917:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800918:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80091b:	5b                   	pop    %ebx
  80091c:	5e                   	pop    %esi
  80091d:	5d                   	pop    %ebp
  80091e:	c3                   	ret    

0080091f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80091f:	55                   	push   %ebp
  800920:	89 e5                	mov    %esp,%ebp
  800922:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800925:	8d 45 10             	lea    0x10(%ebp),%eax
  800928:	83 c0 04             	add    $0x4,%eax
  80092b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80092e:	8b 45 10             	mov    0x10(%ebp),%eax
  800931:	ff 75 f4             	pushl  -0xc(%ebp)
  800934:	50                   	push   %eax
  800935:	ff 75 0c             	pushl  0xc(%ebp)
  800938:	ff 75 08             	pushl  0x8(%ebp)
  80093b:	e8 16 fc ff ff       	call   800556 <vprintfmt>
  800940:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800943:	90                   	nop
  800944:	c9                   	leave  
  800945:	c3                   	ret    

00800946 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800946:	55                   	push   %ebp
  800947:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800949:	8b 45 0c             	mov    0xc(%ebp),%eax
  80094c:	8b 40 08             	mov    0x8(%eax),%eax
  80094f:	8d 50 01             	lea    0x1(%eax),%edx
  800952:	8b 45 0c             	mov    0xc(%ebp),%eax
  800955:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800958:	8b 45 0c             	mov    0xc(%ebp),%eax
  80095b:	8b 10                	mov    (%eax),%edx
  80095d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800960:	8b 40 04             	mov    0x4(%eax),%eax
  800963:	39 c2                	cmp    %eax,%edx
  800965:	73 12                	jae    800979 <sprintputch+0x33>
		*b->buf++ = ch;
  800967:	8b 45 0c             	mov    0xc(%ebp),%eax
  80096a:	8b 00                	mov    (%eax),%eax
  80096c:	8d 48 01             	lea    0x1(%eax),%ecx
  80096f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800972:	89 0a                	mov    %ecx,(%edx)
  800974:	8b 55 08             	mov    0x8(%ebp),%edx
  800977:	88 10                	mov    %dl,(%eax)
}
  800979:	90                   	nop
  80097a:	5d                   	pop    %ebp
  80097b:	c3                   	ret    

0080097c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80097c:	55                   	push   %ebp
  80097d:	89 e5                	mov    %esp,%ebp
  80097f:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800982:	8b 45 08             	mov    0x8(%ebp),%eax
  800985:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800988:	8b 45 0c             	mov    0xc(%ebp),%eax
  80098b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80098e:	8b 45 08             	mov    0x8(%ebp),%eax
  800991:	01 d0                	add    %edx,%eax
  800993:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800996:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80099d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8009a1:	74 06                	je     8009a9 <vsnprintf+0x2d>
  8009a3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009a7:	7f 07                	jg     8009b0 <vsnprintf+0x34>
		return -E_INVAL;
  8009a9:	b8 03 00 00 00       	mov    $0x3,%eax
  8009ae:	eb 20                	jmp    8009d0 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009b0:	ff 75 14             	pushl  0x14(%ebp)
  8009b3:	ff 75 10             	pushl  0x10(%ebp)
  8009b6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009b9:	50                   	push   %eax
  8009ba:	68 46 09 80 00       	push   $0x800946
  8009bf:	e8 92 fb ff ff       	call   800556 <vprintfmt>
  8009c4:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8009c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009ca:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8009d0:	c9                   	leave  
  8009d1:	c3                   	ret    

008009d2 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009d2:	55                   	push   %ebp
  8009d3:	89 e5                	mov    %esp,%ebp
  8009d5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009d8:	8d 45 10             	lea    0x10(%ebp),%eax
  8009db:	83 c0 04             	add    $0x4,%eax
  8009de:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8009e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8009e4:	ff 75 f4             	pushl  -0xc(%ebp)
  8009e7:	50                   	push   %eax
  8009e8:	ff 75 0c             	pushl  0xc(%ebp)
  8009eb:	ff 75 08             	pushl  0x8(%ebp)
  8009ee:	e8 89 ff ff ff       	call   80097c <vsnprintf>
  8009f3:	83 c4 10             	add    $0x10,%esp
  8009f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8009f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009fc:	c9                   	leave  
  8009fd:	c3                   	ret    

008009fe <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8009fe:	55                   	push   %ebp
  8009ff:	89 e5                	mov    %esp,%ebp
  800a01:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800a04:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a0b:	eb 06                	jmp    800a13 <strlen+0x15>
		n++;
  800a0d:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800a10:	ff 45 08             	incl   0x8(%ebp)
  800a13:	8b 45 08             	mov    0x8(%ebp),%eax
  800a16:	8a 00                	mov    (%eax),%al
  800a18:	84 c0                	test   %al,%al
  800a1a:	75 f1                	jne    800a0d <strlen+0xf>
		n++;
	return n;
  800a1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a1f:	c9                   	leave  
  800a20:	c3                   	ret    

00800a21 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800a21:	55                   	push   %ebp
  800a22:	89 e5                	mov    %esp,%ebp
  800a24:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a27:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a2e:	eb 09                	jmp    800a39 <strnlen+0x18>
		n++;
  800a30:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a33:	ff 45 08             	incl   0x8(%ebp)
  800a36:	ff 4d 0c             	decl   0xc(%ebp)
  800a39:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a3d:	74 09                	je     800a48 <strnlen+0x27>
  800a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a42:	8a 00                	mov    (%eax),%al
  800a44:	84 c0                	test   %al,%al
  800a46:	75 e8                	jne    800a30 <strnlen+0xf>
		n++;
	return n;
  800a48:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a4b:	c9                   	leave  
  800a4c:	c3                   	ret    

00800a4d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a4d:	55                   	push   %ebp
  800a4e:	89 e5                	mov    %esp,%ebp
  800a50:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800a53:	8b 45 08             	mov    0x8(%ebp),%eax
  800a56:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a59:	90                   	nop
  800a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5d:	8d 50 01             	lea    0x1(%eax),%edx
  800a60:	89 55 08             	mov    %edx,0x8(%ebp)
  800a63:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a66:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a69:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a6c:	8a 12                	mov    (%edx),%dl
  800a6e:	88 10                	mov    %dl,(%eax)
  800a70:	8a 00                	mov    (%eax),%al
  800a72:	84 c0                	test   %al,%al
  800a74:	75 e4                	jne    800a5a <strcpy+0xd>
		/* do nothing */;
	return ret;
  800a76:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a79:	c9                   	leave  
  800a7a:	c3                   	ret    

00800a7b <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800a7b:	55                   	push   %ebp
  800a7c:	89 e5                	mov    %esp,%ebp
  800a7e:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800a81:	8b 45 08             	mov    0x8(%ebp),%eax
  800a84:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800a87:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a8e:	eb 1f                	jmp    800aaf <strncpy+0x34>
		*dst++ = *src;
  800a90:	8b 45 08             	mov    0x8(%ebp),%eax
  800a93:	8d 50 01             	lea    0x1(%eax),%edx
  800a96:	89 55 08             	mov    %edx,0x8(%ebp)
  800a99:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a9c:	8a 12                	mov    (%edx),%dl
  800a9e:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800aa0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aa3:	8a 00                	mov    (%eax),%al
  800aa5:	84 c0                	test   %al,%al
  800aa7:	74 03                	je     800aac <strncpy+0x31>
			src++;
  800aa9:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800aac:	ff 45 fc             	incl   -0x4(%ebp)
  800aaf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ab2:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ab5:	72 d9                	jb     800a90 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ab7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800aba:	c9                   	leave  
  800abb:	c3                   	ret    

00800abc <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800abc:	55                   	push   %ebp
  800abd:	89 e5                	mov    %esp,%ebp
  800abf:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ac8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800acc:	74 30                	je     800afe <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ace:	eb 16                	jmp    800ae6 <strlcpy+0x2a>
			*dst++ = *src++;
  800ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad3:	8d 50 01             	lea    0x1(%eax),%edx
  800ad6:	89 55 08             	mov    %edx,0x8(%ebp)
  800ad9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800adc:	8d 4a 01             	lea    0x1(%edx),%ecx
  800adf:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ae2:	8a 12                	mov    (%edx),%dl
  800ae4:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ae6:	ff 4d 10             	decl   0x10(%ebp)
  800ae9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800aed:	74 09                	je     800af8 <strlcpy+0x3c>
  800aef:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af2:	8a 00                	mov    (%eax),%al
  800af4:	84 c0                	test   %al,%al
  800af6:	75 d8                	jne    800ad0 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800af8:	8b 45 08             	mov    0x8(%ebp),%eax
  800afb:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800afe:	8b 55 08             	mov    0x8(%ebp),%edx
  800b01:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b04:	29 c2                	sub    %eax,%edx
  800b06:	89 d0                	mov    %edx,%eax
}
  800b08:	c9                   	leave  
  800b09:	c3                   	ret    

00800b0a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b0a:	55                   	push   %ebp
  800b0b:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800b0d:	eb 06                	jmp    800b15 <strcmp+0xb>
		p++, q++;
  800b0f:	ff 45 08             	incl   0x8(%ebp)
  800b12:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800b15:	8b 45 08             	mov    0x8(%ebp),%eax
  800b18:	8a 00                	mov    (%eax),%al
  800b1a:	84 c0                	test   %al,%al
  800b1c:	74 0e                	je     800b2c <strcmp+0x22>
  800b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b21:	8a 10                	mov    (%eax),%dl
  800b23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b26:	8a 00                	mov    (%eax),%al
  800b28:	38 c2                	cmp    %al,%dl
  800b2a:	74 e3                	je     800b0f <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2f:	8a 00                	mov    (%eax),%al
  800b31:	0f b6 d0             	movzbl %al,%edx
  800b34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b37:	8a 00                	mov    (%eax),%al
  800b39:	0f b6 c0             	movzbl %al,%eax
  800b3c:	29 c2                	sub    %eax,%edx
  800b3e:	89 d0                	mov    %edx,%eax
}
  800b40:	5d                   	pop    %ebp
  800b41:	c3                   	ret    

00800b42 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800b42:	55                   	push   %ebp
  800b43:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b45:	eb 09                	jmp    800b50 <strncmp+0xe>
		n--, p++, q++;
  800b47:	ff 4d 10             	decl   0x10(%ebp)
  800b4a:	ff 45 08             	incl   0x8(%ebp)
  800b4d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800b50:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b54:	74 17                	je     800b6d <strncmp+0x2b>
  800b56:	8b 45 08             	mov    0x8(%ebp),%eax
  800b59:	8a 00                	mov    (%eax),%al
  800b5b:	84 c0                	test   %al,%al
  800b5d:	74 0e                	je     800b6d <strncmp+0x2b>
  800b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b62:	8a 10                	mov    (%eax),%dl
  800b64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b67:	8a 00                	mov    (%eax),%al
  800b69:	38 c2                	cmp    %al,%dl
  800b6b:	74 da                	je     800b47 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800b6d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b71:	75 07                	jne    800b7a <strncmp+0x38>
		return 0;
  800b73:	b8 00 00 00 00       	mov    $0x0,%eax
  800b78:	eb 14                	jmp    800b8e <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7d:	8a 00                	mov    (%eax),%al
  800b7f:	0f b6 d0             	movzbl %al,%edx
  800b82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b85:	8a 00                	mov    (%eax),%al
  800b87:	0f b6 c0             	movzbl %al,%eax
  800b8a:	29 c2                	sub    %eax,%edx
  800b8c:	89 d0                	mov    %edx,%eax
}
  800b8e:	5d                   	pop    %ebp
  800b8f:	c3                   	ret    

00800b90 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b90:	55                   	push   %ebp
  800b91:	89 e5                	mov    %esp,%ebp
  800b93:	83 ec 04             	sub    $0x4,%esp
  800b96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b99:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b9c:	eb 12                	jmp    800bb0 <strchr+0x20>
		if (*s == c)
  800b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba1:	8a 00                	mov    (%eax),%al
  800ba3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ba6:	75 05                	jne    800bad <strchr+0x1d>
			return (char *) s;
  800ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bab:	eb 11                	jmp    800bbe <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800bad:	ff 45 08             	incl   0x8(%ebp)
  800bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb3:	8a 00                	mov    (%eax),%al
  800bb5:	84 c0                	test   %al,%al
  800bb7:	75 e5                	jne    800b9e <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800bb9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bbe:	c9                   	leave  
  800bbf:	c3                   	ret    

00800bc0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800bc0:	55                   	push   %ebp
  800bc1:	89 e5                	mov    %esp,%ebp
  800bc3:	83 ec 04             	sub    $0x4,%esp
  800bc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800bcc:	eb 0d                	jmp    800bdb <strfind+0x1b>
		if (*s == c)
  800bce:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd1:	8a 00                	mov    (%eax),%al
  800bd3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800bd6:	74 0e                	je     800be6 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800bd8:	ff 45 08             	incl   0x8(%ebp)
  800bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bde:	8a 00                	mov    (%eax),%al
  800be0:	84 c0                	test   %al,%al
  800be2:	75 ea                	jne    800bce <strfind+0xe>
  800be4:	eb 01                	jmp    800be7 <strfind+0x27>
		if (*s == c)
			break;
  800be6:	90                   	nop
	return (char *) s;
  800be7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bea:	c9                   	leave  
  800beb:	c3                   	ret    

00800bec <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800bec:	55                   	push   %ebp
  800bed:	89 e5                	mov    %esp,%ebp
  800bef:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800bf8:	8b 45 10             	mov    0x10(%ebp),%eax
  800bfb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800bfe:	eb 0e                	jmp    800c0e <memset+0x22>
		*p++ = c;
  800c00:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c03:	8d 50 01             	lea    0x1(%eax),%edx
  800c06:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800c09:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c0c:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800c0e:	ff 4d f8             	decl   -0x8(%ebp)
  800c11:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800c15:	79 e9                	jns    800c00 <memset+0x14>
		*p++ = c;

	return v;
  800c17:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c1a:	c9                   	leave  
  800c1b:	c3                   	ret    

00800c1c <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800c1c:	55                   	push   %ebp
  800c1d:	89 e5                	mov    %esp,%ebp
  800c1f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c25:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c28:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800c2e:	eb 16                	jmp    800c46 <memcpy+0x2a>
		*d++ = *s++;
  800c30:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c33:	8d 50 01             	lea    0x1(%eax),%edx
  800c36:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c39:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c3c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c3f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c42:	8a 12                	mov    (%edx),%dl
  800c44:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800c46:	8b 45 10             	mov    0x10(%ebp),%eax
  800c49:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c4c:	89 55 10             	mov    %edx,0x10(%ebp)
  800c4f:	85 c0                	test   %eax,%eax
  800c51:	75 dd                	jne    800c30 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800c53:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c56:	c9                   	leave  
  800c57:	c3                   	ret    

00800c58 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800c58:	55                   	push   %ebp
  800c59:	89 e5                	mov    %esp,%ebp
  800c5b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c61:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c64:	8b 45 08             	mov    0x8(%ebp),%eax
  800c67:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800c6a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c6d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c70:	73 50                	jae    800cc2 <memmove+0x6a>
  800c72:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c75:	8b 45 10             	mov    0x10(%ebp),%eax
  800c78:	01 d0                	add    %edx,%eax
  800c7a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c7d:	76 43                	jbe    800cc2 <memmove+0x6a>
		s += n;
  800c7f:	8b 45 10             	mov    0x10(%ebp),%eax
  800c82:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800c85:	8b 45 10             	mov    0x10(%ebp),%eax
  800c88:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800c8b:	eb 10                	jmp    800c9d <memmove+0x45>
			*--d = *--s;
  800c8d:	ff 4d f8             	decl   -0x8(%ebp)
  800c90:	ff 4d fc             	decl   -0x4(%ebp)
  800c93:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c96:	8a 10                	mov    (%eax),%dl
  800c98:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c9b:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800c9d:	8b 45 10             	mov    0x10(%ebp),%eax
  800ca0:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ca3:	89 55 10             	mov    %edx,0x10(%ebp)
  800ca6:	85 c0                	test   %eax,%eax
  800ca8:	75 e3                	jne    800c8d <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800caa:	eb 23                	jmp    800ccf <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800cac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800caf:	8d 50 01             	lea    0x1(%eax),%edx
  800cb2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800cb5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800cb8:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cbb:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800cbe:	8a 12                	mov    (%edx),%dl
  800cc0:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800cc2:	8b 45 10             	mov    0x10(%ebp),%eax
  800cc5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cc8:	89 55 10             	mov    %edx,0x10(%ebp)
  800ccb:	85 c0                	test   %eax,%eax
  800ccd:	75 dd                	jne    800cac <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ccf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cd2:	c9                   	leave  
  800cd3:	c3                   	ret    

00800cd4 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800cd4:	55                   	push   %ebp
  800cd5:	89 e5                	mov    %esp,%ebp
  800cd7:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800cda:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ce0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce3:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ce6:	eb 2a                	jmp    800d12 <memcmp+0x3e>
		if (*s1 != *s2)
  800ce8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ceb:	8a 10                	mov    (%eax),%dl
  800ced:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cf0:	8a 00                	mov    (%eax),%al
  800cf2:	38 c2                	cmp    %al,%dl
  800cf4:	74 16                	je     800d0c <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800cf6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cf9:	8a 00                	mov    (%eax),%al
  800cfb:	0f b6 d0             	movzbl %al,%edx
  800cfe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d01:	8a 00                	mov    (%eax),%al
  800d03:	0f b6 c0             	movzbl %al,%eax
  800d06:	29 c2                	sub    %eax,%edx
  800d08:	89 d0                	mov    %edx,%eax
  800d0a:	eb 18                	jmp    800d24 <memcmp+0x50>
		s1++, s2++;
  800d0c:	ff 45 fc             	incl   -0x4(%ebp)
  800d0f:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800d12:	8b 45 10             	mov    0x10(%ebp),%eax
  800d15:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d18:	89 55 10             	mov    %edx,0x10(%ebp)
  800d1b:	85 c0                	test   %eax,%eax
  800d1d:	75 c9                	jne    800ce8 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800d1f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d24:	c9                   	leave  
  800d25:	c3                   	ret    

00800d26 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800d26:	55                   	push   %ebp
  800d27:	89 e5                	mov    %esp,%ebp
  800d29:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800d2c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d2f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d32:	01 d0                	add    %edx,%eax
  800d34:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800d37:	eb 15                	jmp    800d4e <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d39:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3c:	8a 00                	mov    (%eax),%al
  800d3e:	0f b6 d0             	movzbl %al,%edx
  800d41:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d44:	0f b6 c0             	movzbl %al,%eax
  800d47:	39 c2                	cmp    %eax,%edx
  800d49:	74 0d                	je     800d58 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d4b:	ff 45 08             	incl   0x8(%ebp)
  800d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d51:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800d54:	72 e3                	jb     800d39 <memfind+0x13>
  800d56:	eb 01                	jmp    800d59 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800d58:	90                   	nop
	return (void *) s;
  800d59:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d5c:	c9                   	leave  
  800d5d:	c3                   	ret    

00800d5e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d5e:	55                   	push   %ebp
  800d5f:	89 e5                	mov    %esp,%ebp
  800d61:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800d64:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800d6b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d72:	eb 03                	jmp    800d77 <strtol+0x19>
		s++;
  800d74:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d77:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7a:	8a 00                	mov    (%eax),%al
  800d7c:	3c 20                	cmp    $0x20,%al
  800d7e:	74 f4                	je     800d74 <strtol+0x16>
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	8a 00                	mov    (%eax),%al
  800d85:	3c 09                	cmp    $0x9,%al
  800d87:	74 eb                	je     800d74 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d89:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8c:	8a 00                	mov    (%eax),%al
  800d8e:	3c 2b                	cmp    $0x2b,%al
  800d90:	75 05                	jne    800d97 <strtol+0x39>
		s++;
  800d92:	ff 45 08             	incl   0x8(%ebp)
  800d95:	eb 13                	jmp    800daa <strtol+0x4c>
	else if (*s == '-')
  800d97:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9a:	8a 00                	mov    (%eax),%al
  800d9c:	3c 2d                	cmp    $0x2d,%al
  800d9e:	75 0a                	jne    800daa <strtol+0x4c>
		s++, neg = 1;
  800da0:	ff 45 08             	incl   0x8(%ebp)
  800da3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800daa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dae:	74 06                	je     800db6 <strtol+0x58>
  800db0:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800db4:	75 20                	jne    800dd6 <strtol+0x78>
  800db6:	8b 45 08             	mov    0x8(%ebp),%eax
  800db9:	8a 00                	mov    (%eax),%al
  800dbb:	3c 30                	cmp    $0x30,%al
  800dbd:	75 17                	jne    800dd6 <strtol+0x78>
  800dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc2:	40                   	inc    %eax
  800dc3:	8a 00                	mov    (%eax),%al
  800dc5:	3c 78                	cmp    $0x78,%al
  800dc7:	75 0d                	jne    800dd6 <strtol+0x78>
		s += 2, base = 16;
  800dc9:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800dcd:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800dd4:	eb 28                	jmp    800dfe <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800dd6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dda:	75 15                	jne    800df1 <strtol+0x93>
  800ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddf:	8a 00                	mov    (%eax),%al
  800de1:	3c 30                	cmp    $0x30,%al
  800de3:	75 0c                	jne    800df1 <strtol+0x93>
		s++, base = 8;
  800de5:	ff 45 08             	incl   0x8(%ebp)
  800de8:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800def:	eb 0d                	jmp    800dfe <strtol+0xa0>
	else if (base == 0)
  800df1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800df5:	75 07                	jne    800dfe <strtol+0xa0>
		base = 10;
  800df7:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800e01:	8a 00                	mov    (%eax),%al
  800e03:	3c 2f                	cmp    $0x2f,%al
  800e05:	7e 19                	jle    800e20 <strtol+0xc2>
  800e07:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0a:	8a 00                	mov    (%eax),%al
  800e0c:	3c 39                	cmp    $0x39,%al
  800e0e:	7f 10                	jg     800e20 <strtol+0xc2>
			dig = *s - '0';
  800e10:	8b 45 08             	mov    0x8(%ebp),%eax
  800e13:	8a 00                	mov    (%eax),%al
  800e15:	0f be c0             	movsbl %al,%eax
  800e18:	83 e8 30             	sub    $0x30,%eax
  800e1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e1e:	eb 42                	jmp    800e62 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800e20:	8b 45 08             	mov    0x8(%ebp),%eax
  800e23:	8a 00                	mov    (%eax),%al
  800e25:	3c 60                	cmp    $0x60,%al
  800e27:	7e 19                	jle    800e42 <strtol+0xe4>
  800e29:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2c:	8a 00                	mov    (%eax),%al
  800e2e:	3c 7a                	cmp    $0x7a,%al
  800e30:	7f 10                	jg     800e42 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800e32:	8b 45 08             	mov    0x8(%ebp),%eax
  800e35:	8a 00                	mov    (%eax),%al
  800e37:	0f be c0             	movsbl %al,%eax
  800e3a:	83 e8 57             	sub    $0x57,%eax
  800e3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e40:	eb 20                	jmp    800e62 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800e42:	8b 45 08             	mov    0x8(%ebp),%eax
  800e45:	8a 00                	mov    (%eax),%al
  800e47:	3c 40                	cmp    $0x40,%al
  800e49:	7e 39                	jle    800e84 <strtol+0x126>
  800e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4e:	8a 00                	mov    (%eax),%al
  800e50:	3c 5a                	cmp    $0x5a,%al
  800e52:	7f 30                	jg     800e84 <strtol+0x126>
			dig = *s - 'A' + 10;
  800e54:	8b 45 08             	mov    0x8(%ebp),%eax
  800e57:	8a 00                	mov    (%eax),%al
  800e59:	0f be c0             	movsbl %al,%eax
  800e5c:	83 e8 37             	sub    $0x37,%eax
  800e5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800e62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e65:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e68:	7d 19                	jge    800e83 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800e6a:	ff 45 08             	incl   0x8(%ebp)
  800e6d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e70:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e74:	89 c2                	mov    %eax,%edx
  800e76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e79:	01 d0                	add    %edx,%eax
  800e7b:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800e7e:	e9 7b ff ff ff       	jmp    800dfe <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800e83:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800e84:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e88:	74 08                	je     800e92 <strtol+0x134>
		*endptr = (char *) s;
  800e8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e90:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800e92:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e96:	74 07                	je     800e9f <strtol+0x141>
  800e98:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e9b:	f7 d8                	neg    %eax
  800e9d:	eb 03                	jmp    800ea2 <strtol+0x144>
  800e9f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ea2:	c9                   	leave  
  800ea3:	c3                   	ret    

00800ea4 <ltostr>:

void
ltostr(long value, char *str)
{
  800ea4:	55                   	push   %ebp
  800ea5:	89 e5                	mov    %esp,%ebp
  800ea7:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800eaa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800eb1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800eb8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ebc:	79 13                	jns    800ed1 <ltostr+0x2d>
	{
		neg = 1;
  800ebe:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800ec5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec8:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800ecb:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800ece:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed4:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800ed9:	99                   	cltd   
  800eda:	f7 f9                	idiv   %ecx
  800edc:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800edf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ee2:	8d 50 01             	lea    0x1(%eax),%edx
  800ee5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ee8:	89 c2                	mov    %eax,%edx
  800eea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eed:	01 d0                	add    %edx,%eax
  800eef:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ef2:	83 c2 30             	add    $0x30,%edx
  800ef5:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800ef7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800efa:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800eff:	f7 e9                	imul   %ecx
  800f01:	c1 fa 02             	sar    $0x2,%edx
  800f04:	89 c8                	mov    %ecx,%eax
  800f06:	c1 f8 1f             	sar    $0x1f,%eax
  800f09:	29 c2                	sub    %eax,%edx
  800f0b:	89 d0                	mov    %edx,%eax
  800f0d:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800f10:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f13:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800f18:	f7 e9                	imul   %ecx
  800f1a:	c1 fa 02             	sar    $0x2,%edx
  800f1d:	89 c8                	mov    %ecx,%eax
  800f1f:	c1 f8 1f             	sar    $0x1f,%eax
  800f22:	29 c2                	sub    %eax,%edx
  800f24:	89 d0                	mov    %edx,%eax
  800f26:	c1 e0 02             	shl    $0x2,%eax
  800f29:	01 d0                	add    %edx,%eax
  800f2b:	01 c0                	add    %eax,%eax
  800f2d:	29 c1                	sub    %eax,%ecx
  800f2f:	89 ca                	mov    %ecx,%edx
  800f31:	85 d2                	test   %edx,%edx
  800f33:	75 9c                	jne    800ed1 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800f35:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800f3c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f3f:	48                   	dec    %eax
  800f40:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800f43:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f47:	74 3d                	je     800f86 <ltostr+0xe2>
		start = 1 ;
  800f49:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800f50:	eb 34                	jmp    800f86 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800f52:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f58:	01 d0                	add    %edx,%eax
  800f5a:	8a 00                	mov    (%eax),%al
  800f5c:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800f5f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f65:	01 c2                	add    %eax,%edx
  800f67:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800f6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6d:	01 c8                	add    %ecx,%eax
  800f6f:	8a 00                	mov    (%eax),%al
  800f71:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800f73:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f76:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f79:	01 c2                	add    %eax,%edx
  800f7b:	8a 45 eb             	mov    -0x15(%ebp),%al
  800f7e:	88 02                	mov    %al,(%edx)
		start++ ;
  800f80:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800f83:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800f86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f89:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f8c:	7c c4                	jl     800f52 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800f8e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800f91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f94:	01 d0                	add    %edx,%eax
  800f96:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800f99:	90                   	nop
  800f9a:	c9                   	leave  
  800f9b:	c3                   	ret    

00800f9c <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800f9c:	55                   	push   %ebp
  800f9d:	89 e5                	mov    %esp,%ebp
  800f9f:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800fa2:	ff 75 08             	pushl  0x8(%ebp)
  800fa5:	e8 54 fa ff ff       	call   8009fe <strlen>
  800faa:	83 c4 04             	add    $0x4,%esp
  800fad:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800fb0:	ff 75 0c             	pushl  0xc(%ebp)
  800fb3:	e8 46 fa ff ff       	call   8009fe <strlen>
  800fb8:	83 c4 04             	add    $0x4,%esp
  800fbb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800fbe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800fc5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800fcc:	eb 17                	jmp    800fe5 <strcconcat+0x49>
		final[s] = str1[s] ;
  800fce:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fd1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd4:	01 c2                	add    %eax,%edx
  800fd6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdc:	01 c8                	add    %ecx,%eax
  800fde:	8a 00                	mov    (%eax),%al
  800fe0:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800fe2:	ff 45 fc             	incl   -0x4(%ebp)
  800fe5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fe8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800feb:	7c e1                	jl     800fce <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800fed:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800ff4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800ffb:	eb 1f                	jmp    80101c <strcconcat+0x80>
		final[s++] = str2[i] ;
  800ffd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801000:	8d 50 01             	lea    0x1(%eax),%edx
  801003:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801006:	89 c2                	mov    %eax,%edx
  801008:	8b 45 10             	mov    0x10(%ebp),%eax
  80100b:	01 c2                	add    %eax,%edx
  80100d:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801010:	8b 45 0c             	mov    0xc(%ebp),%eax
  801013:	01 c8                	add    %ecx,%eax
  801015:	8a 00                	mov    (%eax),%al
  801017:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801019:	ff 45 f8             	incl   -0x8(%ebp)
  80101c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801022:	7c d9                	jl     800ffd <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801024:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801027:	8b 45 10             	mov    0x10(%ebp),%eax
  80102a:	01 d0                	add    %edx,%eax
  80102c:	c6 00 00             	movb   $0x0,(%eax)
}
  80102f:	90                   	nop
  801030:	c9                   	leave  
  801031:	c3                   	ret    

00801032 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801032:	55                   	push   %ebp
  801033:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801035:	8b 45 14             	mov    0x14(%ebp),%eax
  801038:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80103e:	8b 45 14             	mov    0x14(%ebp),%eax
  801041:	8b 00                	mov    (%eax),%eax
  801043:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80104a:	8b 45 10             	mov    0x10(%ebp),%eax
  80104d:	01 d0                	add    %edx,%eax
  80104f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801055:	eb 0c                	jmp    801063 <strsplit+0x31>
			*string++ = 0;
  801057:	8b 45 08             	mov    0x8(%ebp),%eax
  80105a:	8d 50 01             	lea    0x1(%eax),%edx
  80105d:	89 55 08             	mov    %edx,0x8(%ebp)
  801060:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801063:	8b 45 08             	mov    0x8(%ebp),%eax
  801066:	8a 00                	mov    (%eax),%al
  801068:	84 c0                	test   %al,%al
  80106a:	74 18                	je     801084 <strsplit+0x52>
  80106c:	8b 45 08             	mov    0x8(%ebp),%eax
  80106f:	8a 00                	mov    (%eax),%al
  801071:	0f be c0             	movsbl %al,%eax
  801074:	50                   	push   %eax
  801075:	ff 75 0c             	pushl  0xc(%ebp)
  801078:	e8 13 fb ff ff       	call   800b90 <strchr>
  80107d:	83 c4 08             	add    $0x8,%esp
  801080:	85 c0                	test   %eax,%eax
  801082:	75 d3                	jne    801057 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801084:	8b 45 08             	mov    0x8(%ebp),%eax
  801087:	8a 00                	mov    (%eax),%al
  801089:	84 c0                	test   %al,%al
  80108b:	74 5a                	je     8010e7 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80108d:	8b 45 14             	mov    0x14(%ebp),%eax
  801090:	8b 00                	mov    (%eax),%eax
  801092:	83 f8 0f             	cmp    $0xf,%eax
  801095:	75 07                	jne    80109e <strsplit+0x6c>
		{
			return 0;
  801097:	b8 00 00 00 00       	mov    $0x0,%eax
  80109c:	eb 66                	jmp    801104 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80109e:	8b 45 14             	mov    0x14(%ebp),%eax
  8010a1:	8b 00                	mov    (%eax),%eax
  8010a3:	8d 48 01             	lea    0x1(%eax),%ecx
  8010a6:	8b 55 14             	mov    0x14(%ebp),%edx
  8010a9:	89 0a                	mov    %ecx,(%edx)
  8010ab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b5:	01 c2                	add    %eax,%edx
  8010b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ba:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8010bc:	eb 03                	jmp    8010c1 <strsplit+0x8f>
			string++;
  8010be:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8010c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c4:	8a 00                	mov    (%eax),%al
  8010c6:	84 c0                	test   %al,%al
  8010c8:	74 8b                	je     801055 <strsplit+0x23>
  8010ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cd:	8a 00                	mov    (%eax),%al
  8010cf:	0f be c0             	movsbl %al,%eax
  8010d2:	50                   	push   %eax
  8010d3:	ff 75 0c             	pushl  0xc(%ebp)
  8010d6:	e8 b5 fa ff ff       	call   800b90 <strchr>
  8010db:	83 c4 08             	add    $0x8,%esp
  8010de:	85 c0                	test   %eax,%eax
  8010e0:	74 dc                	je     8010be <strsplit+0x8c>
			string++;
	}
  8010e2:	e9 6e ff ff ff       	jmp    801055 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8010e7:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8010e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8010eb:	8b 00                	mov    (%eax),%eax
  8010ed:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f7:	01 d0                	add    %edx,%eax
  8010f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8010ff:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801104:	c9                   	leave  
  801105:	c3                   	ret    

00801106 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801106:	55                   	push   %ebp
  801107:	89 e5                	mov    %esp,%ebp
  801109:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  80110c:	a1 04 40 80 00       	mov    0x804004,%eax
  801111:	85 c0                	test   %eax,%eax
  801113:	74 1f                	je     801134 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801115:	e8 1d 00 00 00       	call   801137 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80111a:	83 ec 0c             	sub    $0xc,%esp
  80111d:	68 70 37 80 00       	push   $0x803770
  801122:	e8 55 f2 ff ff       	call   80037c <cprintf>
  801127:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80112a:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801131:	00 00 00 
	}
}
  801134:	90                   	nop
  801135:	c9                   	leave  
  801136:	c3                   	ret    

00801137 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801137:	55                   	push   %ebp
  801138:	89 e5                	mov    %esp,%ebp
  80113a:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  80113d:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801144:	00 00 00 
  801147:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80114e:	00 00 00 
  801151:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801158:	00 00 00 
		LIST_INIT(&AllocMemBlocksList);
  80115b:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801162:	00 00 00 
  801165:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80116c:	00 00 00 
  80116f:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801176:	00 00 00 

		MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES ;
  801179:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801180:	00 02 00 
		MemBlockNodes =(struct MemBlock*)USER_DYN_BLKS_ARRAY ;
  801183:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  80118a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80118d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801192:	2d 00 10 00 00       	sub    $0x1000,%eax
  801197:	a3 50 40 80 00       	mov    %eax,0x804050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock),PAGE_SIZE),PERM_USER|PERM_WRITEABLE);
  80119c:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8011a3:	a1 20 41 80 00       	mov    0x804120,%eax
  8011a8:	c1 e0 04             	shl    $0x4,%eax
  8011ab:	89 c2                	mov    %eax,%edx
  8011ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011b0:	01 d0                	add    %edx,%eax
  8011b2:	48                   	dec    %eax
  8011b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8011b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8011be:	f7 75 f0             	divl   -0x10(%ebp)
  8011c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011c4:	29 d0                	sub    %edx,%eax
  8011c6:	89 c2                	mov    %eax,%edx
  8011c8:	c7 45 e8 00 00 e0 7f 	movl   $0x7fe00000,-0x18(%ebp)
  8011cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8011d2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011d7:	2d 00 10 00 00       	sub    $0x1000,%eax
  8011dc:	83 ec 04             	sub    $0x4,%esp
  8011df:	6a 06                	push   $0x6
  8011e1:	52                   	push   %edx
  8011e2:	50                   	push   %eax
  8011e3:	e8 71 05 00 00       	call   801759 <sys_allocate_chunk>
  8011e8:	83 c4 10             	add    $0x10,%esp
		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8011eb:	a1 20 41 80 00       	mov    0x804120,%eax
  8011f0:	83 ec 0c             	sub    $0xc,%esp
  8011f3:	50                   	push   %eax
  8011f4:	e8 e6 0b 00 00       	call   801ddf <initialize_MemBlocksList>
  8011f9:	83 c4 10             	add    $0x10,%esp

		struct MemBlock  *block_node;
		block_node = AvailableMemBlocksList.lh_first;
  8011fc:	a1 48 41 80 00       	mov    0x804148,%eax
  801201:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&(AvailableMemBlocksList),block_node);
  801204:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801208:	75 14                	jne    80121e <initialize_dyn_block_system+0xe7>
  80120a:	83 ec 04             	sub    $0x4,%esp
  80120d:	68 95 37 80 00       	push   $0x803795
  801212:	6a 2b                	push   $0x2b
  801214:	68 b3 37 80 00       	push   $0x8037b3
  801219:	e8 66 1c 00 00       	call   802e84 <_panic>
  80121e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801221:	8b 00                	mov    (%eax),%eax
  801223:	85 c0                	test   %eax,%eax
  801225:	74 10                	je     801237 <initialize_dyn_block_system+0x100>
  801227:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80122a:	8b 00                	mov    (%eax),%eax
  80122c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80122f:	8b 52 04             	mov    0x4(%edx),%edx
  801232:	89 50 04             	mov    %edx,0x4(%eax)
  801235:	eb 0b                	jmp    801242 <initialize_dyn_block_system+0x10b>
  801237:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80123a:	8b 40 04             	mov    0x4(%eax),%eax
  80123d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801242:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801245:	8b 40 04             	mov    0x4(%eax),%eax
  801248:	85 c0                	test   %eax,%eax
  80124a:	74 0f                	je     80125b <initialize_dyn_block_system+0x124>
  80124c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80124f:	8b 40 04             	mov    0x4(%eax),%eax
  801252:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801255:	8b 12                	mov    (%edx),%edx
  801257:	89 10                	mov    %edx,(%eax)
  801259:	eb 0a                	jmp    801265 <initialize_dyn_block_system+0x12e>
  80125b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80125e:	8b 00                	mov    (%eax),%eax
  801260:	a3 48 41 80 00       	mov    %eax,0x804148
  801265:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801268:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80126e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801271:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801278:	a1 54 41 80 00       	mov    0x804154,%eax
  80127d:	48                   	dec    %eax
  80127e:	a3 54 41 80 00       	mov    %eax,0x804154
		block_node->sva = USER_HEAP_START ;
  801283:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801286:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
		block_node->size = ((USER_HEAP_MAX - USER_HEAP_START));
  80128d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801290:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		insert_sorted_with_merge_freeList(block_node);
  801297:	83 ec 0c             	sub    $0xc,%esp
  80129a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80129d:	e8 d2 13 00 00       	call   802674 <insert_sorted_with_merge_freeList>
  8012a2:	83 c4 10             	add    $0x10,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  8012a5:	90                   	nop
  8012a6:	c9                   	leave  
  8012a7:	c3                   	ret    

008012a8 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8012a8:	55                   	push   %ebp
  8012a9:	89 e5                	mov    %esp,%ebp
  8012ab:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8012ae:	e8 53 fe ff ff       	call   801106 <InitializeUHeap>
	if (size == 0) return NULL ;
  8012b3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012b7:	75 07                	jne    8012c0 <malloc+0x18>
  8012b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8012be:	eb 61                	jmp    801321 <malloc+0x79>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	size= ROUNDUP(size,PAGE_SIZE);
  8012c0:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8012c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8012ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012cd:	01 d0                	add    %edx,%eax
  8012cf:	48                   	dec    %eax
  8012d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8012d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8012db:	f7 75 f4             	divl   -0xc(%ebp)
  8012de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012e1:	29 d0                	sub    %edx,%eax
  8012e3:	89 45 08             	mov    %eax,0x8(%ebp)
	    			if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8012e6:	e8 3c 08 00 00       	call   801b27 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8012eb:	85 c0                	test   %eax,%eax
  8012ed:	74 2d                	je     80131c <malloc+0x74>
	    			{
	    				struct MemBlock * ff_block = alloc_block_FF(size);
  8012ef:	83 ec 0c             	sub    $0xc,%esp
  8012f2:	ff 75 08             	pushl  0x8(%ebp)
  8012f5:	e8 3e 0f 00 00       	call   802238 <alloc_block_FF>
  8012fa:	83 c4 10             	add    $0x10,%esp
  8012fd:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    				if(ff_block!=NULL)
  801300:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801304:	74 16                	je     80131c <malloc+0x74>
	    				{

	    					insert_sorted_allocList(ff_block);
  801306:	83 ec 0c             	sub    $0xc,%esp
  801309:	ff 75 ec             	pushl  -0x14(%ebp)
  80130c:	e8 48 0c 00 00       	call   801f59 <insert_sorted_allocList>
  801311:	83 c4 10             	add    $0x10,%esp
	    					return (void*) ff_block->sva ;
  801314:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801317:	8b 40 08             	mov    0x8(%eax),%eax
  80131a:	eb 05                	jmp    801321 <malloc+0x79>

	    				}
	}
	    			return (void*) NULL ;
  80131c:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801321:	c9                   	leave  
  801322:	c3                   	ret    

00801323 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801323:	55                   	push   %ebp
  801324:	89 e5                	mov    %esp,%ebp
  801326:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock *elementForEach;
		virtual_address = ROUNDDOWN(virtual_address, PAGE_SIZE);
  801329:	8b 45 08             	mov    0x8(%ebp),%eax
  80132c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80132f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801332:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801337:	89 45 08             	mov    %eax,0x8(%ebp)
	//	if (is_mallocPages[indexindex((uint32) virtual_address)] == 1) {
		elementForEach = find_block(&AllocMemBlocksList,(uint32)virtual_address);
  80133a:	8b 45 08             	mov    0x8(%ebp),%eax
  80133d:	83 ec 08             	sub    $0x8,%esp
  801340:	50                   	push   %eax
  801341:	68 40 40 80 00       	push   $0x804040
  801346:	e8 71 0b 00 00       	call   801ebc <find_block>
  80134b:	83 c4 10             	add    $0x10,%esp
  80134e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		sys_free_user_mem((uint32) virtual_address, elementForEach->size);
  801351:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801354:	8b 50 0c             	mov    0xc(%eax),%edx
  801357:	8b 45 08             	mov    0x8(%ebp),%eax
  80135a:	83 ec 08             	sub    $0x8,%esp
  80135d:	52                   	push   %edx
  80135e:	50                   	push   %eax
  80135f:	e8 bd 03 00 00       	call   801721 <sys_free_user_mem>
  801364:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,elementForEach);
  801367:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80136b:	75 14                	jne    801381 <free+0x5e>
  80136d:	83 ec 04             	sub    $0x4,%esp
  801370:	68 95 37 80 00       	push   $0x803795
  801375:	6a 71                	push   $0x71
  801377:	68 b3 37 80 00       	push   $0x8037b3
  80137c:	e8 03 1b 00 00       	call   802e84 <_panic>
  801381:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801384:	8b 00                	mov    (%eax),%eax
  801386:	85 c0                	test   %eax,%eax
  801388:	74 10                	je     80139a <free+0x77>
  80138a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80138d:	8b 00                	mov    (%eax),%eax
  80138f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801392:	8b 52 04             	mov    0x4(%edx),%edx
  801395:	89 50 04             	mov    %edx,0x4(%eax)
  801398:	eb 0b                	jmp    8013a5 <free+0x82>
  80139a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80139d:	8b 40 04             	mov    0x4(%eax),%eax
  8013a0:	a3 44 40 80 00       	mov    %eax,0x804044
  8013a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013a8:	8b 40 04             	mov    0x4(%eax),%eax
  8013ab:	85 c0                	test   %eax,%eax
  8013ad:	74 0f                	je     8013be <free+0x9b>
  8013af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013b2:	8b 40 04             	mov    0x4(%eax),%eax
  8013b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013b8:	8b 12                	mov    (%edx),%edx
  8013ba:	89 10                	mov    %edx,(%eax)
  8013bc:	eb 0a                	jmp    8013c8 <free+0xa5>
  8013be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013c1:	8b 00                	mov    (%eax),%eax
  8013c3:	a3 40 40 80 00       	mov    %eax,0x804040
  8013c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8013d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013d4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8013db:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8013e0:	48                   	dec    %eax
  8013e1:	a3 4c 40 80 00       	mov    %eax,0x80404c
		insert_sorted_with_merge_freeList(elementForEach);
  8013e6:	83 ec 0c             	sub    $0xc,%esp
  8013e9:	ff 75 f0             	pushl  -0x10(%ebp)
  8013ec:	e8 83 12 00 00       	call   802674 <insert_sorted_with_merge_freeList>
  8013f1:	83 c4 10             	add    $0x10,%esp
	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  8013f4:	90                   	nop
  8013f5:	c9                   	leave  
  8013f6:	c3                   	ret    

008013f7 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8013f7:	55                   	push   %ebp
  8013f8:	89 e5                	mov    %esp,%ebp
  8013fa:	83 ec 28             	sub    $0x28,%esp
  8013fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801400:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801403:	e8 fe fc ff ff       	call   801106 <InitializeUHeap>
	if (size == 0) return NULL ;
  801408:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80140c:	75 0a                	jne    801418 <smalloc+0x21>
  80140e:	b8 00 00 00 00       	mov    $0x0,%eax
  801413:	e9 86 00 00 00       	jmp    80149e <smalloc+0xa7>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code

	size=ROUNDUP(size,PAGE_SIZE);
  801418:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80141f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801422:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801425:	01 d0                	add    %edx,%eax
  801427:	48                   	dec    %eax
  801428:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80142b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80142e:	ba 00 00 00 00       	mov    $0x0,%edx
  801433:	f7 75 f4             	divl   -0xc(%ebp)
  801436:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801439:	29 d0                	sub    %edx,%eax
  80143b:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80143e:	e8 e4 06 00 00       	call   801b27 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801443:	85 c0                	test   %eax,%eax
  801445:	74 52                	je     801499 <smalloc+0xa2>
		{
		struct MemBlock * ff_block ;
		ff_block = alloc_block_FF(size);
  801447:	83 ec 0c             	sub    $0xc,%esp
  80144a:	ff 75 0c             	pushl  0xc(%ebp)
  80144d:	e8 e6 0d 00 00       	call   802238 <alloc_block_FF>
  801452:	83 c4 10             	add    $0x10,%esp
  801455:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(ff_block==NULL)
  801458:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80145c:	75 07                	jne    801465 <smalloc+0x6e>
			return NULL ;
  80145e:	b8 00 00 00 00       	mov    $0x0,%eax
  801463:	eb 39                	jmp    80149e <smalloc+0xa7>

		int obj_id =sys_createSharedObject(sharedVarName,size,isWritable,(void*)ff_block->sva);
  801465:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801468:	8b 40 08             	mov    0x8(%eax),%eax
  80146b:	89 c2                	mov    %eax,%edx
  80146d:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801471:	52                   	push   %edx
  801472:	50                   	push   %eax
  801473:	ff 75 0c             	pushl  0xc(%ebp)
  801476:	ff 75 08             	pushl  0x8(%ebp)
  801479:	e8 2e 04 00 00       	call   8018ac <sys_createSharedObject>
  80147e:	83 c4 10             	add    $0x10,%esp
  801481:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(obj_id < 0)
  801484:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801488:	79 07                	jns    801491 <smalloc+0x9a>
			return (void*)NULL ;
  80148a:	b8 00 00 00 00       	mov    $0x0,%eax
  80148f:	eb 0d                	jmp    80149e <smalloc+0xa7>
		else
		    return (void*)ff_block->sva ;
  801491:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801494:	8b 40 08             	mov    0x8(%eax),%eax
  801497:	eb 05                	jmp    80149e <smalloc+0xa7>
		}
		return (void*)NULL ;
  801499:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80149e:	c9                   	leave  
  80149f:	c3                   	ret    

008014a0 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8014a0:	55                   	push   %ebp
  8014a1:	89 e5                	mov    %esp,%ebp
  8014a3:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014a6:	e8 5b fc ff ff       	call   801106 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8014ab:	83 ec 08             	sub    $0x8,%esp
  8014ae:	ff 75 0c             	pushl  0xc(%ebp)
  8014b1:	ff 75 08             	pushl  0x8(%ebp)
  8014b4:	e8 1d 04 00 00       	call   8018d6 <sys_getSizeOfSharedObject>
  8014b9:	83 c4 10             	add    $0x10,%esp
  8014bc:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(size == 0)
  8014bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8014c3:	75 0a                	jne    8014cf <sget+0x2f>
			return NULL ;
  8014c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ca:	e9 83 00 00 00       	jmp    801552 <sget+0xb2>
		size=ROUNDUP(size,PAGE_SIZE);
  8014cf:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8014d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014dc:	01 d0                	add    %edx,%eax
  8014de:	48                   	dec    %eax
  8014df:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8014e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8014ea:	f7 75 f0             	divl   -0x10(%ebp)
  8014ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014f0:	29 d0                	sub    %edx,%eax
  8014f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8014f5:	e8 2d 06 00 00       	call   801b27 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014fa:	85 c0                	test   %eax,%eax
  8014fc:	74 4f                	je     80154d <sget+0xad>
		{
			struct MemBlock * ff_block ;
				ff_block = alloc_block_FF(size);
  8014fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801501:	83 ec 0c             	sub    $0xc,%esp
  801504:	50                   	push   %eax
  801505:	e8 2e 0d 00 00       	call   802238 <alloc_block_FF>
  80150a:	83 c4 10             	add    $0x10,%esp
  80150d:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ff_block==NULL)
  801510:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801514:	75 07                	jne    80151d <sget+0x7d>
					return (void*)NULL ;
  801516:	b8 00 00 00 00       	mov    $0x0,%eax
  80151b:	eb 35                	jmp    801552 <sget+0xb2>

		int obj_id =sys_getSharedObject((int)ownerEnvID,sharedVarName,(void*)ff_block->sva);
  80151d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801520:	8b 40 08             	mov    0x8(%eax),%eax
  801523:	83 ec 04             	sub    $0x4,%esp
  801526:	50                   	push   %eax
  801527:	ff 75 0c             	pushl  0xc(%ebp)
  80152a:	ff 75 08             	pushl  0x8(%ebp)
  80152d:	e8 c1 03 00 00       	call   8018f3 <sys_getSharedObject>
  801532:	83 c4 10             	add    $0x10,%esp
  801535:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if(obj_id<0)
  801538:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80153c:	79 07                	jns    801545 <sget+0xa5>
				return (void*)NULL ;
  80153e:	b8 00 00 00 00       	mov    $0x0,%eax
  801543:	eb 0d                	jmp    801552 <sget+0xb2>
			else
				return (void*)ff_block->sva ;
  801545:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801548:	8b 40 08             	mov    0x8(%eax),%eax
  80154b:	eb 05                	jmp    801552 <sget+0xb2>


		}
	return (void*)NULL ;
  80154d:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801552:	c9                   	leave  
  801553:	c3                   	ret    

00801554 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801554:	55                   	push   %ebp
  801555:	89 e5                	mov    %esp,%ebp
  801557:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80155a:	e8 a7 fb ff ff       	call   801106 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80155f:	83 ec 04             	sub    $0x4,%esp
  801562:	68 c0 37 80 00       	push   $0x8037c0
  801567:	68 f9 00 00 00       	push   $0xf9
  80156c:	68 b3 37 80 00       	push   $0x8037b3
  801571:	e8 0e 19 00 00       	call   802e84 <_panic>

00801576 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801576:	55                   	push   %ebp
  801577:	89 e5                	mov    %esp,%ebp
  801579:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80157c:	83 ec 04             	sub    $0x4,%esp
  80157f:	68 e8 37 80 00       	push   $0x8037e8
  801584:	68 0d 01 00 00       	push   $0x10d
  801589:	68 b3 37 80 00       	push   $0x8037b3
  80158e:	e8 f1 18 00 00       	call   802e84 <_panic>

00801593 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801593:	55                   	push   %ebp
  801594:	89 e5                	mov    %esp,%ebp
  801596:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801599:	83 ec 04             	sub    $0x4,%esp
  80159c:	68 0c 38 80 00       	push   $0x80380c
  8015a1:	68 18 01 00 00       	push   $0x118
  8015a6:	68 b3 37 80 00       	push   $0x8037b3
  8015ab:	e8 d4 18 00 00       	call   802e84 <_panic>

008015b0 <shrink>:

}
void shrink(uint32 newSize)
{
  8015b0:	55                   	push   %ebp
  8015b1:	89 e5                	mov    %esp,%ebp
  8015b3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015b6:	83 ec 04             	sub    $0x4,%esp
  8015b9:	68 0c 38 80 00       	push   $0x80380c
  8015be:	68 1d 01 00 00       	push   $0x11d
  8015c3:	68 b3 37 80 00       	push   $0x8037b3
  8015c8:	e8 b7 18 00 00       	call   802e84 <_panic>

008015cd <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8015cd:	55                   	push   %ebp
  8015ce:	89 e5                	mov    %esp,%ebp
  8015d0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015d3:	83 ec 04             	sub    $0x4,%esp
  8015d6:	68 0c 38 80 00       	push   $0x80380c
  8015db:	68 22 01 00 00       	push   $0x122
  8015e0:	68 b3 37 80 00       	push   $0x8037b3
  8015e5:	e8 9a 18 00 00       	call   802e84 <_panic>

008015ea <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8015ea:	55                   	push   %ebp
  8015eb:	89 e5                	mov    %esp,%ebp
  8015ed:	57                   	push   %edi
  8015ee:	56                   	push   %esi
  8015ef:	53                   	push   %ebx
  8015f0:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015f9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015fc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015ff:	8b 7d 18             	mov    0x18(%ebp),%edi
  801602:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801605:	cd 30                	int    $0x30
  801607:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80160a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80160d:	83 c4 10             	add    $0x10,%esp
  801610:	5b                   	pop    %ebx
  801611:	5e                   	pop    %esi
  801612:	5f                   	pop    %edi
  801613:	5d                   	pop    %ebp
  801614:	c3                   	ret    

00801615 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801615:	55                   	push   %ebp
  801616:	89 e5                	mov    %esp,%ebp
  801618:	83 ec 04             	sub    $0x4,%esp
  80161b:	8b 45 10             	mov    0x10(%ebp),%eax
  80161e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801621:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801625:	8b 45 08             	mov    0x8(%ebp),%eax
  801628:	6a 00                	push   $0x0
  80162a:	6a 00                	push   $0x0
  80162c:	52                   	push   %edx
  80162d:	ff 75 0c             	pushl  0xc(%ebp)
  801630:	50                   	push   %eax
  801631:	6a 00                	push   $0x0
  801633:	e8 b2 ff ff ff       	call   8015ea <syscall>
  801638:	83 c4 18             	add    $0x18,%esp
}
  80163b:	90                   	nop
  80163c:	c9                   	leave  
  80163d:	c3                   	ret    

0080163e <sys_cgetc>:

int
sys_cgetc(void)
{
  80163e:	55                   	push   %ebp
  80163f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801641:	6a 00                	push   $0x0
  801643:	6a 00                	push   $0x0
  801645:	6a 00                	push   $0x0
  801647:	6a 00                	push   $0x0
  801649:	6a 00                	push   $0x0
  80164b:	6a 01                	push   $0x1
  80164d:	e8 98 ff ff ff       	call   8015ea <syscall>
  801652:	83 c4 18             	add    $0x18,%esp
}
  801655:	c9                   	leave  
  801656:	c3                   	ret    

00801657 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801657:	55                   	push   %ebp
  801658:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80165a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80165d:	8b 45 08             	mov    0x8(%ebp),%eax
  801660:	6a 00                	push   $0x0
  801662:	6a 00                	push   $0x0
  801664:	6a 00                	push   $0x0
  801666:	52                   	push   %edx
  801667:	50                   	push   %eax
  801668:	6a 05                	push   $0x5
  80166a:	e8 7b ff ff ff       	call   8015ea <syscall>
  80166f:	83 c4 18             	add    $0x18,%esp
}
  801672:	c9                   	leave  
  801673:	c3                   	ret    

00801674 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801674:	55                   	push   %ebp
  801675:	89 e5                	mov    %esp,%ebp
  801677:	56                   	push   %esi
  801678:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801679:	8b 75 18             	mov    0x18(%ebp),%esi
  80167c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80167f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801682:	8b 55 0c             	mov    0xc(%ebp),%edx
  801685:	8b 45 08             	mov    0x8(%ebp),%eax
  801688:	56                   	push   %esi
  801689:	53                   	push   %ebx
  80168a:	51                   	push   %ecx
  80168b:	52                   	push   %edx
  80168c:	50                   	push   %eax
  80168d:	6a 06                	push   $0x6
  80168f:	e8 56 ff ff ff       	call   8015ea <syscall>
  801694:	83 c4 18             	add    $0x18,%esp
}
  801697:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80169a:	5b                   	pop    %ebx
  80169b:	5e                   	pop    %esi
  80169c:	5d                   	pop    %ebp
  80169d:	c3                   	ret    

0080169e <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80169e:	55                   	push   %ebp
  80169f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8016a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a7:	6a 00                	push   $0x0
  8016a9:	6a 00                	push   $0x0
  8016ab:	6a 00                	push   $0x0
  8016ad:	52                   	push   %edx
  8016ae:	50                   	push   %eax
  8016af:	6a 07                	push   $0x7
  8016b1:	e8 34 ff ff ff       	call   8015ea <syscall>
  8016b6:	83 c4 18             	add    $0x18,%esp
}
  8016b9:	c9                   	leave  
  8016ba:	c3                   	ret    

008016bb <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8016bb:	55                   	push   %ebp
  8016bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8016be:	6a 00                	push   $0x0
  8016c0:	6a 00                	push   $0x0
  8016c2:	6a 00                	push   $0x0
  8016c4:	ff 75 0c             	pushl  0xc(%ebp)
  8016c7:	ff 75 08             	pushl  0x8(%ebp)
  8016ca:	6a 08                	push   $0x8
  8016cc:	e8 19 ff ff ff       	call   8015ea <syscall>
  8016d1:	83 c4 18             	add    $0x18,%esp
}
  8016d4:	c9                   	leave  
  8016d5:	c3                   	ret    

008016d6 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8016d6:	55                   	push   %ebp
  8016d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8016d9:	6a 00                	push   $0x0
  8016db:	6a 00                	push   $0x0
  8016dd:	6a 00                	push   $0x0
  8016df:	6a 00                	push   $0x0
  8016e1:	6a 00                	push   $0x0
  8016e3:	6a 09                	push   $0x9
  8016e5:	e8 00 ff ff ff       	call   8015ea <syscall>
  8016ea:	83 c4 18             	add    $0x18,%esp
}
  8016ed:	c9                   	leave  
  8016ee:	c3                   	ret    

008016ef <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8016ef:	55                   	push   %ebp
  8016f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8016f2:	6a 00                	push   $0x0
  8016f4:	6a 00                	push   $0x0
  8016f6:	6a 00                	push   $0x0
  8016f8:	6a 00                	push   $0x0
  8016fa:	6a 00                	push   $0x0
  8016fc:	6a 0a                	push   $0xa
  8016fe:	e8 e7 fe ff ff       	call   8015ea <syscall>
  801703:	83 c4 18             	add    $0x18,%esp
}
  801706:	c9                   	leave  
  801707:	c3                   	ret    

00801708 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801708:	55                   	push   %ebp
  801709:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80170b:	6a 00                	push   $0x0
  80170d:	6a 00                	push   $0x0
  80170f:	6a 00                	push   $0x0
  801711:	6a 00                	push   $0x0
  801713:	6a 00                	push   $0x0
  801715:	6a 0b                	push   $0xb
  801717:	e8 ce fe ff ff       	call   8015ea <syscall>
  80171c:	83 c4 18             	add    $0x18,%esp
}
  80171f:	c9                   	leave  
  801720:	c3                   	ret    

00801721 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801721:	55                   	push   %ebp
  801722:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801724:	6a 00                	push   $0x0
  801726:	6a 00                	push   $0x0
  801728:	6a 00                	push   $0x0
  80172a:	ff 75 0c             	pushl  0xc(%ebp)
  80172d:	ff 75 08             	pushl  0x8(%ebp)
  801730:	6a 0f                	push   $0xf
  801732:	e8 b3 fe ff ff       	call   8015ea <syscall>
  801737:	83 c4 18             	add    $0x18,%esp
	return;
  80173a:	90                   	nop
}
  80173b:	c9                   	leave  
  80173c:	c3                   	ret    

0080173d <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80173d:	55                   	push   %ebp
  80173e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801740:	6a 00                	push   $0x0
  801742:	6a 00                	push   $0x0
  801744:	6a 00                	push   $0x0
  801746:	ff 75 0c             	pushl  0xc(%ebp)
  801749:	ff 75 08             	pushl  0x8(%ebp)
  80174c:	6a 10                	push   $0x10
  80174e:	e8 97 fe ff ff       	call   8015ea <syscall>
  801753:	83 c4 18             	add    $0x18,%esp
	return ;
  801756:	90                   	nop
}
  801757:	c9                   	leave  
  801758:	c3                   	ret    

00801759 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801759:	55                   	push   %ebp
  80175a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80175c:	6a 00                	push   $0x0
  80175e:	6a 00                	push   $0x0
  801760:	ff 75 10             	pushl  0x10(%ebp)
  801763:	ff 75 0c             	pushl  0xc(%ebp)
  801766:	ff 75 08             	pushl  0x8(%ebp)
  801769:	6a 11                	push   $0x11
  80176b:	e8 7a fe ff ff       	call   8015ea <syscall>
  801770:	83 c4 18             	add    $0x18,%esp
	return ;
  801773:	90                   	nop
}
  801774:	c9                   	leave  
  801775:	c3                   	ret    

00801776 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801776:	55                   	push   %ebp
  801777:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801779:	6a 00                	push   $0x0
  80177b:	6a 00                	push   $0x0
  80177d:	6a 00                	push   $0x0
  80177f:	6a 00                	push   $0x0
  801781:	6a 00                	push   $0x0
  801783:	6a 0c                	push   $0xc
  801785:	e8 60 fe ff ff       	call   8015ea <syscall>
  80178a:	83 c4 18             	add    $0x18,%esp
}
  80178d:	c9                   	leave  
  80178e:	c3                   	ret    

0080178f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80178f:	55                   	push   %ebp
  801790:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801792:	6a 00                	push   $0x0
  801794:	6a 00                	push   $0x0
  801796:	6a 00                	push   $0x0
  801798:	6a 00                	push   $0x0
  80179a:	ff 75 08             	pushl  0x8(%ebp)
  80179d:	6a 0d                	push   $0xd
  80179f:	e8 46 fe ff ff       	call   8015ea <syscall>
  8017a4:	83 c4 18             	add    $0x18,%esp
}
  8017a7:	c9                   	leave  
  8017a8:	c3                   	ret    

008017a9 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8017a9:	55                   	push   %ebp
  8017aa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8017ac:	6a 00                	push   $0x0
  8017ae:	6a 00                	push   $0x0
  8017b0:	6a 00                	push   $0x0
  8017b2:	6a 00                	push   $0x0
  8017b4:	6a 00                	push   $0x0
  8017b6:	6a 0e                	push   $0xe
  8017b8:	e8 2d fe ff ff       	call   8015ea <syscall>
  8017bd:	83 c4 18             	add    $0x18,%esp
}
  8017c0:	90                   	nop
  8017c1:	c9                   	leave  
  8017c2:	c3                   	ret    

008017c3 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8017c3:	55                   	push   %ebp
  8017c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8017c6:	6a 00                	push   $0x0
  8017c8:	6a 00                	push   $0x0
  8017ca:	6a 00                	push   $0x0
  8017cc:	6a 00                	push   $0x0
  8017ce:	6a 00                	push   $0x0
  8017d0:	6a 13                	push   $0x13
  8017d2:	e8 13 fe ff ff       	call   8015ea <syscall>
  8017d7:	83 c4 18             	add    $0x18,%esp
}
  8017da:	90                   	nop
  8017db:	c9                   	leave  
  8017dc:	c3                   	ret    

008017dd <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8017dd:	55                   	push   %ebp
  8017de:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8017e0:	6a 00                	push   $0x0
  8017e2:	6a 00                	push   $0x0
  8017e4:	6a 00                	push   $0x0
  8017e6:	6a 00                	push   $0x0
  8017e8:	6a 00                	push   $0x0
  8017ea:	6a 14                	push   $0x14
  8017ec:	e8 f9 fd ff ff       	call   8015ea <syscall>
  8017f1:	83 c4 18             	add    $0x18,%esp
}
  8017f4:	90                   	nop
  8017f5:	c9                   	leave  
  8017f6:	c3                   	ret    

008017f7 <sys_cputc>:


void
sys_cputc(const char c)
{
  8017f7:	55                   	push   %ebp
  8017f8:	89 e5                	mov    %esp,%ebp
  8017fa:	83 ec 04             	sub    $0x4,%esp
  8017fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801800:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801803:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801807:	6a 00                	push   $0x0
  801809:	6a 00                	push   $0x0
  80180b:	6a 00                	push   $0x0
  80180d:	6a 00                	push   $0x0
  80180f:	50                   	push   %eax
  801810:	6a 15                	push   $0x15
  801812:	e8 d3 fd ff ff       	call   8015ea <syscall>
  801817:	83 c4 18             	add    $0x18,%esp
}
  80181a:	90                   	nop
  80181b:	c9                   	leave  
  80181c:	c3                   	ret    

0080181d <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80181d:	55                   	push   %ebp
  80181e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801820:	6a 00                	push   $0x0
  801822:	6a 00                	push   $0x0
  801824:	6a 00                	push   $0x0
  801826:	6a 00                	push   $0x0
  801828:	6a 00                	push   $0x0
  80182a:	6a 16                	push   $0x16
  80182c:	e8 b9 fd ff ff       	call   8015ea <syscall>
  801831:	83 c4 18             	add    $0x18,%esp
}
  801834:	90                   	nop
  801835:	c9                   	leave  
  801836:	c3                   	ret    

00801837 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801837:	55                   	push   %ebp
  801838:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80183a:	8b 45 08             	mov    0x8(%ebp),%eax
  80183d:	6a 00                	push   $0x0
  80183f:	6a 00                	push   $0x0
  801841:	6a 00                	push   $0x0
  801843:	ff 75 0c             	pushl  0xc(%ebp)
  801846:	50                   	push   %eax
  801847:	6a 17                	push   $0x17
  801849:	e8 9c fd ff ff       	call   8015ea <syscall>
  80184e:	83 c4 18             	add    $0x18,%esp
}
  801851:	c9                   	leave  
  801852:	c3                   	ret    

00801853 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801853:	55                   	push   %ebp
  801854:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801856:	8b 55 0c             	mov    0xc(%ebp),%edx
  801859:	8b 45 08             	mov    0x8(%ebp),%eax
  80185c:	6a 00                	push   $0x0
  80185e:	6a 00                	push   $0x0
  801860:	6a 00                	push   $0x0
  801862:	52                   	push   %edx
  801863:	50                   	push   %eax
  801864:	6a 1a                	push   $0x1a
  801866:	e8 7f fd ff ff       	call   8015ea <syscall>
  80186b:	83 c4 18             	add    $0x18,%esp
}
  80186e:	c9                   	leave  
  80186f:	c3                   	ret    

00801870 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801870:	55                   	push   %ebp
  801871:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801873:	8b 55 0c             	mov    0xc(%ebp),%edx
  801876:	8b 45 08             	mov    0x8(%ebp),%eax
  801879:	6a 00                	push   $0x0
  80187b:	6a 00                	push   $0x0
  80187d:	6a 00                	push   $0x0
  80187f:	52                   	push   %edx
  801880:	50                   	push   %eax
  801881:	6a 18                	push   $0x18
  801883:	e8 62 fd ff ff       	call   8015ea <syscall>
  801888:	83 c4 18             	add    $0x18,%esp
}
  80188b:	90                   	nop
  80188c:	c9                   	leave  
  80188d:	c3                   	ret    

0080188e <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80188e:	55                   	push   %ebp
  80188f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801891:	8b 55 0c             	mov    0xc(%ebp),%edx
  801894:	8b 45 08             	mov    0x8(%ebp),%eax
  801897:	6a 00                	push   $0x0
  801899:	6a 00                	push   $0x0
  80189b:	6a 00                	push   $0x0
  80189d:	52                   	push   %edx
  80189e:	50                   	push   %eax
  80189f:	6a 19                	push   $0x19
  8018a1:	e8 44 fd ff ff       	call   8015ea <syscall>
  8018a6:	83 c4 18             	add    $0x18,%esp
}
  8018a9:	90                   	nop
  8018aa:	c9                   	leave  
  8018ab:	c3                   	ret    

008018ac <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8018ac:	55                   	push   %ebp
  8018ad:	89 e5                	mov    %esp,%ebp
  8018af:	83 ec 04             	sub    $0x4,%esp
  8018b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8018b5:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8018b8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018bb:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c2:	6a 00                	push   $0x0
  8018c4:	51                   	push   %ecx
  8018c5:	52                   	push   %edx
  8018c6:	ff 75 0c             	pushl  0xc(%ebp)
  8018c9:	50                   	push   %eax
  8018ca:	6a 1b                	push   $0x1b
  8018cc:	e8 19 fd ff ff       	call   8015ea <syscall>
  8018d1:	83 c4 18             	add    $0x18,%esp
}
  8018d4:	c9                   	leave  
  8018d5:	c3                   	ret    

008018d6 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8018d6:	55                   	push   %ebp
  8018d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8018d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018df:	6a 00                	push   $0x0
  8018e1:	6a 00                	push   $0x0
  8018e3:	6a 00                	push   $0x0
  8018e5:	52                   	push   %edx
  8018e6:	50                   	push   %eax
  8018e7:	6a 1c                	push   $0x1c
  8018e9:	e8 fc fc ff ff       	call   8015ea <syscall>
  8018ee:	83 c4 18             	add    $0x18,%esp
}
  8018f1:	c9                   	leave  
  8018f2:	c3                   	ret    

008018f3 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8018f3:	55                   	push   %ebp
  8018f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8018f6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ff:	6a 00                	push   $0x0
  801901:	6a 00                	push   $0x0
  801903:	51                   	push   %ecx
  801904:	52                   	push   %edx
  801905:	50                   	push   %eax
  801906:	6a 1d                	push   $0x1d
  801908:	e8 dd fc ff ff       	call   8015ea <syscall>
  80190d:	83 c4 18             	add    $0x18,%esp
}
  801910:	c9                   	leave  
  801911:	c3                   	ret    

00801912 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801912:	55                   	push   %ebp
  801913:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801915:	8b 55 0c             	mov    0xc(%ebp),%edx
  801918:	8b 45 08             	mov    0x8(%ebp),%eax
  80191b:	6a 00                	push   $0x0
  80191d:	6a 00                	push   $0x0
  80191f:	6a 00                	push   $0x0
  801921:	52                   	push   %edx
  801922:	50                   	push   %eax
  801923:	6a 1e                	push   $0x1e
  801925:	e8 c0 fc ff ff       	call   8015ea <syscall>
  80192a:	83 c4 18             	add    $0x18,%esp
}
  80192d:	c9                   	leave  
  80192e:	c3                   	ret    

0080192f <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80192f:	55                   	push   %ebp
  801930:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801932:	6a 00                	push   $0x0
  801934:	6a 00                	push   $0x0
  801936:	6a 00                	push   $0x0
  801938:	6a 00                	push   $0x0
  80193a:	6a 00                	push   $0x0
  80193c:	6a 1f                	push   $0x1f
  80193e:	e8 a7 fc ff ff       	call   8015ea <syscall>
  801943:	83 c4 18             	add    $0x18,%esp
}
  801946:	c9                   	leave  
  801947:	c3                   	ret    

00801948 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801948:	55                   	push   %ebp
  801949:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80194b:	8b 45 08             	mov    0x8(%ebp),%eax
  80194e:	6a 00                	push   $0x0
  801950:	ff 75 14             	pushl  0x14(%ebp)
  801953:	ff 75 10             	pushl  0x10(%ebp)
  801956:	ff 75 0c             	pushl  0xc(%ebp)
  801959:	50                   	push   %eax
  80195a:	6a 20                	push   $0x20
  80195c:	e8 89 fc ff ff       	call   8015ea <syscall>
  801961:	83 c4 18             	add    $0x18,%esp
}
  801964:	c9                   	leave  
  801965:	c3                   	ret    

00801966 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801966:	55                   	push   %ebp
  801967:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801969:	8b 45 08             	mov    0x8(%ebp),%eax
  80196c:	6a 00                	push   $0x0
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	6a 00                	push   $0x0
  801974:	50                   	push   %eax
  801975:	6a 21                	push   $0x21
  801977:	e8 6e fc ff ff       	call   8015ea <syscall>
  80197c:	83 c4 18             	add    $0x18,%esp
}
  80197f:	90                   	nop
  801980:	c9                   	leave  
  801981:	c3                   	ret    

00801982 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801982:	55                   	push   %ebp
  801983:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801985:	8b 45 08             	mov    0x8(%ebp),%eax
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	6a 00                	push   $0x0
  80198e:	6a 00                	push   $0x0
  801990:	50                   	push   %eax
  801991:	6a 22                	push   $0x22
  801993:	e8 52 fc ff ff       	call   8015ea <syscall>
  801998:	83 c4 18             	add    $0x18,%esp
}
  80199b:	c9                   	leave  
  80199c:	c3                   	ret    

0080199d <sys_getenvid>:

int32 sys_getenvid(void)
{
  80199d:	55                   	push   %ebp
  80199e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 00                	push   $0x0
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 02                	push   $0x2
  8019ac:	e8 39 fc ff ff       	call   8015ea <syscall>
  8019b1:	83 c4 18             	add    $0x18,%esp
}
  8019b4:	c9                   	leave  
  8019b5:	c3                   	ret    

008019b6 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8019b6:	55                   	push   %ebp
  8019b7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 03                	push   $0x3
  8019c5:	e8 20 fc ff ff       	call   8015ea <syscall>
  8019ca:	83 c4 18             	add    $0x18,%esp
}
  8019cd:	c9                   	leave  
  8019ce:	c3                   	ret    

008019cf <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8019cf:	55                   	push   %ebp
  8019d0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 00                	push   $0x0
  8019d6:	6a 00                	push   $0x0
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 04                	push   $0x4
  8019de:	e8 07 fc ff ff       	call   8015ea <syscall>
  8019e3:	83 c4 18             	add    $0x18,%esp
}
  8019e6:	c9                   	leave  
  8019e7:	c3                   	ret    

008019e8 <sys_exit_env>:


void sys_exit_env(void)
{
  8019e8:	55                   	push   %ebp
  8019e9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 23                	push   $0x23
  8019f7:	e8 ee fb ff ff       	call   8015ea <syscall>
  8019fc:	83 c4 18             	add    $0x18,%esp
}
  8019ff:	90                   	nop
  801a00:	c9                   	leave  
  801a01:	c3                   	ret    

00801a02 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801a02:	55                   	push   %ebp
  801a03:	89 e5                	mov    %esp,%ebp
  801a05:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a08:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a0b:	8d 50 04             	lea    0x4(%eax),%edx
  801a0e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a11:	6a 00                	push   $0x0
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	52                   	push   %edx
  801a18:	50                   	push   %eax
  801a19:	6a 24                	push   $0x24
  801a1b:	e8 ca fb ff ff       	call   8015ea <syscall>
  801a20:	83 c4 18             	add    $0x18,%esp
	return result;
  801a23:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a26:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a29:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a2c:	89 01                	mov    %eax,(%ecx)
  801a2e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801a31:	8b 45 08             	mov    0x8(%ebp),%eax
  801a34:	c9                   	leave  
  801a35:	c2 04 00             	ret    $0x4

00801a38 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801a38:	55                   	push   %ebp
  801a39:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	ff 75 10             	pushl  0x10(%ebp)
  801a42:	ff 75 0c             	pushl  0xc(%ebp)
  801a45:	ff 75 08             	pushl  0x8(%ebp)
  801a48:	6a 12                	push   $0x12
  801a4a:	e8 9b fb ff ff       	call   8015ea <syscall>
  801a4f:	83 c4 18             	add    $0x18,%esp
	return ;
  801a52:	90                   	nop
}
  801a53:	c9                   	leave  
  801a54:	c3                   	ret    

00801a55 <sys_rcr2>:
uint32 sys_rcr2()
{
  801a55:	55                   	push   %ebp
  801a56:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 00                	push   $0x0
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 00                	push   $0x0
  801a62:	6a 25                	push   $0x25
  801a64:	e8 81 fb ff ff       	call   8015ea <syscall>
  801a69:	83 c4 18             	add    $0x18,%esp
}
  801a6c:	c9                   	leave  
  801a6d:	c3                   	ret    

00801a6e <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801a6e:	55                   	push   %ebp
  801a6f:	89 e5                	mov    %esp,%ebp
  801a71:	83 ec 04             	sub    $0x4,%esp
  801a74:	8b 45 08             	mov    0x8(%ebp),%eax
  801a77:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801a7a:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	50                   	push   %eax
  801a87:	6a 26                	push   $0x26
  801a89:	e8 5c fb ff ff       	call   8015ea <syscall>
  801a8e:	83 c4 18             	add    $0x18,%esp
	return ;
  801a91:	90                   	nop
}
  801a92:	c9                   	leave  
  801a93:	c3                   	ret    

00801a94 <rsttst>:
void rsttst()
{
  801a94:	55                   	push   %ebp
  801a95:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 28                	push   $0x28
  801aa3:	e8 42 fb ff ff       	call   8015ea <syscall>
  801aa8:	83 c4 18             	add    $0x18,%esp
	return ;
  801aab:	90                   	nop
}
  801aac:	c9                   	leave  
  801aad:	c3                   	ret    

00801aae <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801aae:	55                   	push   %ebp
  801aaf:	89 e5                	mov    %esp,%ebp
  801ab1:	83 ec 04             	sub    $0x4,%esp
  801ab4:	8b 45 14             	mov    0x14(%ebp),%eax
  801ab7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801aba:	8b 55 18             	mov    0x18(%ebp),%edx
  801abd:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ac1:	52                   	push   %edx
  801ac2:	50                   	push   %eax
  801ac3:	ff 75 10             	pushl  0x10(%ebp)
  801ac6:	ff 75 0c             	pushl  0xc(%ebp)
  801ac9:	ff 75 08             	pushl  0x8(%ebp)
  801acc:	6a 27                	push   $0x27
  801ace:	e8 17 fb ff ff       	call   8015ea <syscall>
  801ad3:	83 c4 18             	add    $0x18,%esp
	return ;
  801ad6:	90                   	nop
}
  801ad7:	c9                   	leave  
  801ad8:	c3                   	ret    

00801ad9 <chktst>:
void chktst(uint32 n)
{
  801ad9:	55                   	push   %ebp
  801ada:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 00                	push   $0x0
  801ae4:	ff 75 08             	pushl  0x8(%ebp)
  801ae7:	6a 29                	push   $0x29
  801ae9:	e8 fc fa ff ff       	call   8015ea <syscall>
  801aee:	83 c4 18             	add    $0x18,%esp
	return ;
  801af1:	90                   	nop
}
  801af2:	c9                   	leave  
  801af3:	c3                   	ret    

00801af4 <inctst>:

void inctst()
{
  801af4:	55                   	push   %ebp
  801af5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	6a 00                	push   $0x0
  801afd:	6a 00                	push   $0x0
  801aff:	6a 00                	push   $0x0
  801b01:	6a 2a                	push   $0x2a
  801b03:	e8 e2 fa ff ff       	call   8015ea <syscall>
  801b08:	83 c4 18             	add    $0x18,%esp
	return ;
  801b0b:	90                   	nop
}
  801b0c:	c9                   	leave  
  801b0d:	c3                   	ret    

00801b0e <gettst>:
uint32 gettst()
{
  801b0e:	55                   	push   %ebp
  801b0f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b11:	6a 00                	push   $0x0
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 2b                	push   $0x2b
  801b1d:	e8 c8 fa ff ff       	call   8015ea <syscall>
  801b22:	83 c4 18             	add    $0x18,%esp
}
  801b25:	c9                   	leave  
  801b26:	c3                   	ret    

00801b27 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801b27:	55                   	push   %ebp
  801b28:	89 e5                	mov    %esp,%ebp
  801b2a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	6a 00                	push   $0x0
  801b37:	6a 2c                	push   $0x2c
  801b39:	e8 ac fa ff ff       	call   8015ea <syscall>
  801b3e:	83 c4 18             	add    $0x18,%esp
  801b41:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801b44:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801b48:	75 07                	jne    801b51 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801b4a:	b8 01 00 00 00       	mov    $0x1,%eax
  801b4f:	eb 05                	jmp    801b56 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801b51:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b56:	c9                   	leave  
  801b57:	c3                   	ret    

00801b58 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801b58:	55                   	push   %ebp
  801b59:	89 e5                	mov    %esp,%ebp
  801b5b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b5e:	6a 00                	push   $0x0
  801b60:	6a 00                	push   $0x0
  801b62:	6a 00                	push   $0x0
  801b64:	6a 00                	push   $0x0
  801b66:	6a 00                	push   $0x0
  801b68:	6a 2c                	push   $0x2c
  801b6a:	e8 7b fa ff ff       	call   8015ea <syscall>
  801b6f:	83 c4 18             	add    $0x18,%esp
  801b72:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801b75:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801b79:	75 07                	jne    801b82 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801b7b:	b8 01 00 00 00       	mov    $0x1,%eax
  801b80:	eb 05                	jmp    801b87 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801b82:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b87:	c9                   	leave  
  801b88:	c3                   	ret    

00801b89 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801b89:	55                   	push   %ebp
  801b8a:	89 e5                	mov    %esp,%ebp
  801b8c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	6a 2c                	push   $0x2c
  801b9b:	e8 4a fa ff ff       	call   8015ea <syscall>
  801ba0:	83 c4 18             	add    $0x18,%esp
  801ba3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801ba6:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801baa:	75 07                	jne    801bb3 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801bac:	b8 01 00 00 00       	mov    $0x1,%eax
  801bb1:	eb 05                	jmp    801bb8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801bb3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bb8:	c9                   	leave  
  801bb9:	c3                   	ret    

00801bba <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801bba:	55                   	push   %ebp
  801bbb:	89 e5                	mov    %esp,%ebp
  801bbd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bc0:	6a 00                	push   $0x0
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 2c                	push   $0x2c
  801bcc:	e8 19 fa ff ff       	call   8015ea <syscall>
  801bd1:	83 c4 18             	add    $0x18,%esp
  801bd4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801bd7:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801bdb:	75 07                	jne    801be4 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801bdd:	b8 01 00 00 00       	mov    $0x1,%eax
  801be2:	eb 05                	jmp    801be9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801be4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801be9:	c9                   	leave  
  801bea:	c3                   	ret    

00801beb <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801beb:	55                   	push   %ebp
  801bec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 00                	push   $0x0
  801bf6:	ff 75 08             	pushl  0x8(%ebp)
  801bf9:	6a 2d                	push   $0x2d
  801bfb:	e8 ea f9 ff ff       	call   8015ea <syscall>
  801c00:	83 c4 18             	add    $0x18,%esp
	return ;
  801c03:	90                   	nop
}
  801c04:	c9                   	leave  
  801c05:	c3                   	ret    

00801c06 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c06:	55                   	push   %ebp
  801c07:	89 e5                	mov    %esp,%ebp
  801c09:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c0a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c0d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c10:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c13:	8b 45 08             	mov    0x8(%ebp),%eax
  801c16:	6a 00                	push   $0x0
  801c18:	53                   	push   %ebx
  801c19:	51                   	push   %ecx
  801c1a:	52                   	push   %edx
  801c1b:	50                   	push   %eax
  801c1c:	6a 2e                	push   $0x2e
  801c1e:	e8 c7 f9 ff ff       	call   8015ea <syscall>
  801c23:	83 c4 18             	add    $0x18,%esp
}
  801c26:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c29:	c9                   	leave  
  801c2a:	c3                   	ret    

00801c2b <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801c2b:	55                   	push   %ebp
  801c2c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801c2e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c31:	8b 45 08             	mov    0x8(%ebp),%eax
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	6a 00                	push   $0x0
  801c3a:	52                   	push   %edx
  801c3b:	50                   	push   %eax
  801c3c:	6a 2f                	push   $0x2f
  801c3e:	e8 a7 f9 ff ff       	call   8015ea <syscall>
  801c43:	83 c4 18             	add    $0x18,%esp
}
  801c46:	c9                   	leave  
  801c47:	c3                   	ret    

00801c48 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801c48:	55                   	push   %ebp
  801c49:	89 e5                	mov    %esp,%ebp
  801c4b:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801c4e:	83 ec 0c             	sub    $0xc,%esp
  801c51:	68 1c 38 80 00       	push   $0x80381c
  801c56:	e8 21 e7 ff ff       	call   80037c <cprintf>
  801c5b:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801c5e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801c65:	83 ec 0c             	sub    $0xc,%esp
  801c68:	68 48 38 80 00       	push   $0x803848
  801c6d:	e8 0a e7 ff ff       	call   80037c <cprintf>
  801c72:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801c75:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801c79:	a1 38 41 80 00       	mov    0x804138,%eax
  801c7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c81:	eb 56                	jmp    801cd9 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801c83:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c87:	74 1c                	je     801ca5 <print_mem_block_lists+0x5d>
  801c89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c8c:	8b 50 08             	mov    0x8(%eax),%edx
  801c8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c92:	8b 48 08             	mov    0x8(%eax),%ecx
  801c95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c98:	8b 40 0c             	mov    0xc(%eax),%eax
  801c9b:	01 c8                	add    %ecx,%eax
  801c9d:	39 c2                	cmp    %eax,%edx
  801c9f:	73 04                	jae    801ca5 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801ca1:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801ca5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ca8:	8b 50 08             	mov    0x8(%eax),%edx
  801cab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cae:	8b 40 0c             	mov    0xc(%eax),%eax
  801cb1:	01 c2                	add    %eax,%edx
  801cb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cb6:	8b 40 08             	mov    0x8(%eax),%eax
  801cb9:	83 ec 04             	sub    $0x4,%esp
  801cbc:	52                   	push   %edx
  801cbd:	50                   	push   %eax
  801cbe:	68 5d 38 80 00       	push   $0x80385d
  801cc3:	e8 b4 e6 ff ff       	call   80037c <cprintf>
  801cc8:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801ccb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cce:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801cd1:	a1 40 41 80 00       	mov    0x804140,%eax
  801cd6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801cd9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801cdd:	74 07                	je     801ce6 <print_mem_block_lists+0x9e>
  801cdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ce2:	8b 00                	mov    (%eax),%eax
  801ce4:	eb 05                	jmp    801ceb <print_mem_block_lists+0xa3>
  801ce6:	b8 00 00 00 00       	mov    $0x0,%eax
  801ceb:	a3 40 41 80 00       	mov    %eax,0x804140
  801cf0:	a1 40 41 80 00       	mov    0x804140,%eax
  801cf5:	85 c0                	test   %eax,%eax
  801cf7:	75 8a                	jne    801c83 <print_mem_block_lists+0x3b>
  801cf9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801cfd:	75 84                	jne    801c83 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801cff:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801d03:	75 10                	jne    801d15 <print_mem_block_lists+0xcd>
  801d05:	83 ec 0c             	sub    $0xc,%esp
  801d08:	68 6c 38 80 00       	push   $0x80386c
  801d0d:	e8 6a e6 ff ff       	call   80037c <cprintf>
  801d12:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801d15:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801d1c:	83 ec 0c             	sub    $0xc,%esp
  801d1f:	68 90 38 80 00       	push   $0x803890
  801d24:	e8 53 e6 ff ff       	call   80037c <cprintf>
  801d29:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801d2c:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801d30:	a1 40 40 80 00       	mov    0x804040,%eax
  801d35:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d38:	eb 56                	jmp    801d90 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801d3a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d3e:	74 1c                	je     801d5c <print_mem_block_lists+0x114>
  801d40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d43:	8b 50 08             	mov    0x8(%eax),%edx
  801d46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d49:	8b 48 08             	mov    0x8(%eax),%ecx
  801d4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d4f:	8b 40 0c             	mov    0xc(%eax),%eax
  801d52:	01 c8                	add    %ecx,%eax
  801d54:	39 c2                	cmp    %eax,%edx
  801d56:	73 04                	jae    801d5c <print_mem_block_lists+0x114>
			sorted = 0 ;
  801d58:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801d5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d5f:	8b 50 08             	mov    0x8(%eax),%edx
  801d62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d65:	8b 40 0c             	mov    0xc(%eax),%eax
  801d68:	01 c2                	add    %eax,%edx
  801d6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d6d:	8b 40 08             	mov    0x8(%eax),%eax
  801d70:	83 ec 04             	sub    $0x4,%esp
  801d73:	52                   	push   %edx
  801d74:	50                   	push   %eax
  801d75:	68 5d 38 80 00       	push   $0x80385d
  801d7a:	e8 fd e5 ff ff       	call   80037c <cprintf>
  801d7f:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801d82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d85:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801d88:	a1 48 40 80 00       	mov    0x804048,%eax
  801d8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d90:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d94:	74 07                	je     801d9d <print_mem_block_lists+0x155>
  801d96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d99:	8b 00                	mov    (%eax),%eax
  801d9b:	eb 05                	jmp    801da2 <print_mem_block_lists+0x15a>
  801d9d:	b8 00 00 00 00       	mov    $0x0,%eax
  801da2:	a3 48 40 80 00       	mov    %eax,0x804048
  801da7:	a1 48 40 80 00       	mov    0x804048,%eax
  801dac:	85 c0                	test   %eax,%eax
  801dae:	75 8a                	jne    801d3a <print_mem_block_lists+0xf2>
  801db0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801db4:	75 84                	jne    801d3a <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801db6:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801dba:	75 10                	jne    801dcc <print_mem_block_lists+0x184>
  801dbc:	83 ec 0c             	sub    $0xc,%esp
  801dbf:	68 a8 38 80 00       	push   $0x8038a8
  801dc4:	e8 b3 e5 ff ff       	call   80037c <cprintf>
  801dc9:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801dcc:	83 ec 0c             	sub    $0xc,%esp
  801dcf:	68 1c 38 80 00       	push   $0x80381c
  801dd4:	e8 a3 e5 ff ff       	call   80037c <cprintf>
  801dd9:	83 c4 10             	add    $0x10,%esp

}
  801ddc:	90                   	nop
  801ddd:	c9                   	leave  
  801dde:	c3                   	ret    

00801ddf <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801ddf:	55                   	push   %ebp
  801de0:	89 e5                	mov    %esp,%ebp
  801de2:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  801de5:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801dec:	00 00 00 
  801def:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801df6:	00 00 00 
  801df9:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801e00:	00 00 00 
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  801e03:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801e0a:	e9 9e 00 00 00       	jmp    801ead <initialize_MemBlocksList+0xce>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
  801e0f:	a1 50 40 80 00       	mov    0x804050,%eax
  801e14:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e17:	c1 e2 04             	shl    $0x4,%edx
  801e1a:	01 d0                	add    %edx,%eax
  801e1c:	85 c0                	test   %eax,%eax
  801e1e:	75 14                	jne    801e34 <initialize_MemBlocksList+0x55>
  801e20:	83 ec 04             	sub    $0x4,%esp
  801e23:	68 d0 38 80 00       	push   $0x8038d0
  801e28:	6a 43                	push   $0x43
  801e2a:	68 f3 38 80 00       	push   $0x8038f3
  801e2f:	e8 50 10 00 00       	call   802e84 <_panic>
  801e34:	a1 50 40 80 00       	mov    0x804050,%eax
  801e39:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e3c:	c1 e2 04             	shl    $0x4,%edx
  801e3f:	01 d0                	add    %edx,%eax
  801e41:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801e47:	89 10                	mov    %edx,(%eax)
  801e49:	8b 00                	mov    (%eax),%eax
  801e4b:	85 c0                	test   %eax,%eax
  801e4d:	74 18                	je     801e67 <initialize_MemBlocksList+0x88>
  801e4f:	a1 48 41 80 00       	mov    0x804148,%eax
  801e54:	8b 15 50 40 80 00    	mov    0x804050,%edx
  801e5a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801e5d:	c1 e1 04             	shl    $0x4,%ecx
  801e60:	01 ca                	add    %ecx,%edx
  801e62:	89 50 04             	mov    %edx,0x4(%eax)
  801e65:	eb 12                	jmp    801e79 <initialize_MemBlocksList+0x9a>
  801e67:	a1 50 40 80 00       	mov    0x804050,%eax
  801e6c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e6f:	c1 e2 04             	shl    $0x4,%edx
  801e72:	01 d0                	add    %edx,%eax
  801e74:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801e79:	a1 50 40 80 00       	mov    0x804050,%eax
  801e7e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e81:	c1 e2 04             	shl    $0x4,%edx
  801e84:	01 d0                	add    %edx,%eax
  801e86:	a3 48 41 80 00       	mov    %eax,0x804148
  801e8b:	a1 50 40 80 00       	mov    0x804050,%eax
  801e90:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e93:	c1 e2 04             	shl    $0x4,%edx
  801e96:	01 d0                	add    %edx,%eax
  801e98:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801e9f:	a1 54 41 80 00       	mov    0x804154,%eax
  801ea4:	40                   	inc    %eax
  801ea5:	a3 54 41 80 00       	mov    %eax,0x804154
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  801eaa:	ff 45 f4             	incl   -0xc(%ebp)
  801ead:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb0:	3b 45 08             	cmp    0x8(%ebp),%eax
  801eb3:	0f 82 56 ff ff ff    	jb     801e0f <initialize_MemBlocksList+0x30>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
		}
}
  801eb9:	90                   	nop
  801eba:	c9                   	leave  
  801ebb:	c3                   	ret    

00801ebc <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801ebc:	55                   	push   %ebp
  801ebd:	89 e5                	mov    %esp,%ebp
  801ebf:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  801ec2:	a1 38 41 80 00       	mov    0x804138,%eax
  801ec7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801eca:	eb 18                	jmp    801ee4 <find_block+0x28>
	{
		if (ele->sva==va)
  801ecc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ecf:	8b 40 08             	mov    0x8(%eax),%eax
  801ed2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801ed5:	75 05                	jne    801edc <find_block+0x20>
			return ele;
  801ed7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801eda:	eb 7b                	jmp    801f57 <find_block+0x9b>
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  801edc:	a1 40 41 80 00       	mov    0x804140,%eax
  801ee1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801ee4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801ee8:	74 07                	je     801ef1 <find_block+0x35>
  801eea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801eed:	8b 00                	mov    (%eax),%eax
  801eef:	eb 05                	jmp    801ef6 <find_block+0x3a>
  801ef1:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef6:	a3 40 41 80 00       	mov    %eax,0x804140
  801efb:	a1 40 41 80 00       	mov    0x804140,%eax
  801f00:	85 c0                	test   %eax,%eax
  801f02:	75 c8                	jne    801ecc <find_block+0x10>
  801f04:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f08:	75 c2                	jne    801ecc <find_block+0x10>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  801f0a:	a1 40 40 80 00       	mov    0x804040,%eax
  801f0f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f12:	eb 18                	jmp    801f2c <find_block+0x70>
	{
		if (ele->sva==va)
  801f14:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f17:	8b 40 08             	mov    0x8(%eax),%eax
  801f1a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801f1d:	75 05                	jne    801f24 <find_block+0x68>
					return ele;
  801f1f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f22:	eb 33                	jmp    801f57 <find_block+0x9b>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  801f24:	a1 48 40 80 00       	mov    0x804048,%eax
  801f29:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f2c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f30:	74 07                	je     801f39 <find_block+0x7d>
  801f32:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f35:	8b 00                	mov    (%eax),%eax
  801f37:	eb 05                	jmp    801f3e <find_block+0x82>
  801f39:	b8 00 00 00 00       	mov    $0x0,%eax
  801f3e:	a3 48 40 80 00       	mov    %eax,0x804048
  801f43:	a1 48 40 80 00       	mov    0x804048,%eax
  801f48:	85 c0                	test   %eax,%eax
  801f4a:	75 c8                	jne    801f14 <find_block+0x58>
  801f4c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f50:	75 c2                	jne    801f14 <find_block+0x58>
	{
		if (ele->sva==va)
					return ele;
	}
return NULL;
  801f52:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  801f57:	c9                   	leave  
  801f58:	c3                   	ret    

00801f59 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801f59:	55                   	push   %ebp
  801f5a:	89 e5                	mov    %esp,%ebp
  801f5c:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;

int x =LIST_SIZE(&AllocMemBlocksList);
  801f5f:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801f64:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((x==0))
  801f67:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f6b:	75 62                	jne    801fcf <insert_sorted_allocList+0x76>
	{
	//	blockToInsert=AllocMemBlocksList.lh_first;
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  801f6d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f71:	75 14                	jne    801f87 <insert_sorted_allocList+0x2e>
  801f73:	83 ec 04             	sub    $0x4,%esp
  801f76:	68 d0 38 80 00       	push   $0x8038d0
  801f7b:	6a 69                	push   $0x69
  801f7d:	68 f3 38 80 00       	push   $0x8038f3
  801f82:	e8 fd 0e 00 00       	call   802e84 <_panic>
  801f87:	8b 15 40 40 80 00    	mov    0x804040,%edx
  801f8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f90:	89 10                	mov    %edx,(%eax)
  801f92:	8b 45 08             	mov    0x8(%ebp),%eax
  801f95:	8b 00                	mov    (%eax),%eax
  801f97:	85 c0                	test   %eax,%eax
  801f99:	74 0d                	je     801fa8 <insert_sorted_allocList+0x4f>
  801f9b:	a1 40 40 80 00       	mov    0x804040,%eax
  801fa0:	8b 55 08             	mov    0x8(%ebp),%edx
  801fa3:	89 50 04             	mov    %edx,0x4(%eax)
  801fa6:	eb 08                	jmp    801fb0 <insert_sorted_allocList+0x57>
  801fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  801fab:	a3 44 40 80 00       	mov    %eax,0x804044
  801fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb3:	a3 40 40 80 00       	mov    %eax,0x804040
  801fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801fc2:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801fc7:	40                   	inc    %eax
  801fc8:	a3 4c 40 80 00       	mov    %eax,0x80404c
  801fcd:	eb 72                	jmp    802041 <insert_sorted_allocList+0xe8>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
  801fcf:	a1 40 40 80 00       	mov    0x804040,%eax
  801fd4:	8b 50 08             	mov    0x8(%eax),%edx
  801fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801fda:	8b 40 08             	mov    0x8(%eax),%eax
  801fdd:	39 c2                	cmp    %eax,%edx
  801fdf:	76 60                	jbe    802041 <insert_sorted_allocList+0xe8>
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  801fe1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801fe5:	75 14                	jne    801ffb <insert_sorted_allocList+0xa2>
  801fe7:	83 ec 04             	sub    $0x4,%esp
  801fea:	68 d0 38 80 00       	push   $0x8038d0
  801fef:	6a 6d                	push   $0x6d
  801ff1:	68 f3 38 80 00       	push   $0x8038f3
  801ff6:	e8 89 0e 00 00       	call   802e84 <_panic>
  801ffb:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802001:	8b 45 08             	mov    0x8(%ebp),%eax
  802004:	89 10                	mov    %edx,(%eax)
  802006:	8b 45 08             	mov    0x8(%ebp),%eax
  802009:	8b 00                	mov    (%eax),%eax
  80200b:	85 c0                	test   %eax,%eax
  80200d:	74 0d                	je     80201c <insert_sorted_allocList+0xc3>
  80200f:	a1 40 40 80 00       	mov    0x804040,%eax
  802014:	8b 55 08             	mov    0x8(%ebp),%edx
  802017:	89 50 04             	mov    %edx,0x4(%eax)
  80201a:	eb 08                	jmp    802024 <insert_sorted_allocList+0xcb>
  80201c:	8b 45 08             	mov    0x8(%ebp),%eax
  80201f:	a3 44 40 80 00       	mov    %eax,0x804044
  802024:	8b 45 08             	mov    0x8(%ebp),%eax
  802027:	a3 40 40 80 00       	mov    %eax,0x804040
  80202c:	8b 45 08             	mov    0x8(%ebp),%eax
  80202f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802036:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80203b:	40                   	inc    %eax
  80203c:	a3 4c 40 80 00       	mov    %eax,0x80404c
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  802041:	a1 40 40 80 00       	mov    0x804040,%eax
  802046:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802049:	e9 b9 01 00 00       	jmp    802207 <insert_sorted_allocList+0x2ae>
	{


		if ((blockToInsert->sva>AllocMemBlocksList.lh_first->sva)&&blockToInsert->sva<element->sva)
  80204e:	8b 45 08             	mov    0x8(%ebp),%eax
  802051:	8b 50 08             	mov    0x8(%eax),%edx
  802054:	a1 40 40 80 00       	mov    0x804040,%eax
  802059:	8b 40 08             	mov    0x8(%eax),%eax
  80205c:	39 c2                	cmp    %eax,%edx
  80205e:	76 7c                	jbe    8020dc <insert_sorted_allocList+0x183>
  802060:	8b 45 08             	mov    0x8(%ebp),%eax
  802063:	8b 50 08             	mov    0x8(%eax),%edx
  802066:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802069:	8b 40 08             	mov    0x8(%eax),%eax
  80206c:	39 c2                	cmp    %eax,%edx
  80206e:	73 6c                	jae    8020dc <insert_sorted_allocList+0x183>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,element,blockToInsert);
  802070:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802074:	74 06                	je     80207c <insert_sorted_allocList+0x123>
  802076:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80207a:	75 14                	jne    802090 <insert_sorted_allocList+0x137>
  80207c:	83 ec 04             	sub    $0x4,%esp
  80207f:	68 0c 39 80 00       	push   $0x80390c
  802084:	6a 75                	push   $0x75
  802086:	68 f3 38 80 00       	push   $0x8038f3
  80208b:	e8 f4 0d 00 00       	call   802e84 <_panic>
  802090:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802093:	8b 50 04             	mov    0x4(%eax),%edx
  802096:	8b 45 08             	mov    0x8(%ebp),%eax
  802099:	89 50 04             	mov    %edx,0x4(%eax)
  80209c:	8b 45 08             	mov    0x8(%ebp),%eax
  80209f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020a2:	89 10                	mov    %edx,(%eax)
  8020a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a7:	8b 40 04             	mov    0x4(%eax),%eax
  8020aa:	85 c0                	test   %eax,%eax
  8020ac:	74 0d                	je     8020bb <insert_sorted_allocList+0x162>
  8020ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b1:	8b 40 04             	mov    0x4(%eax),%eax
  8020b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8020b7:	89 10                	mov    %edx,(%eax)
  8020b9:	eb 08                	jmp    8020c3 <insert_sorted_allocList+0x16a>
  8020bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020be:	a3 40 40 80 00       	mov    %eax,0x804040
  8020c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8020c9:	89 50 04             	mov    %edx,0x4(%eax)
  8020cc:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8020d1:	40                   	inc    %eax
  8020d2:	a3 4c 40 80 00       	mov    %eax,0x80404c

		break;}
  8020d7:	e9 59 01 00 00       	jmp    802235 <insert_sorted_allocList+0x2dc>

	else if ((blockToInsert->sva>element->sva)&&(blockToInsert->sva<AllocMemBlocksList.lh_last->sva)&&blockToInsert->sva<LIST_NEXT(element)->sva)
  8020dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020df:	8b 50 08             	mov    0x8(%eax),%edx
  8020e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e5:	8b 40 08             	mov    0x8(%eax),%eax
  8020e8:	39 c2                	cmp    %eax,%edx
  8020ea:	0f 86 98 00 00 00    	jbe    802188 <insert_sorted_allocList+0x22f>
  8020f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f3:	8b 50 08             	mov    0x8(%eax),%edx
  8020f6:	a1 44 40 80 00       	mov    0x804044,%eax
  8020fb:	8b 40 08             	mov    0x8(%eax),%eax
  8020fe:	39 c2                	cmp    %eax,%edx
  802100:	0f 83 82 00 00 00    	jae    802188 <insert_sorted_allocList+0x22f>
  802106:	8b 45 08             	mov    0x8(%ebp),%eax
  802109:	8b 50 08             	mov    0x8(%eax),%edx
  80210c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210f:	8b 00                	mov    (%eax),%eax
  802111:	8b 40 08             	mov    0x8(%eax),%eax
  802114:	39 c2                	cmp    %eax,%edx
  802116:	73 70                	jae    802188 <insert_sorted_allocList+0x22f>
	{

	LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  802118:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80211c:	74 06                	je     802124 <insert_sorted_allocList+0x1cb>
  80211e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802122:	75 14                	jne    802138 <insert_sorted_allocList+0x1df>
  802124:	83 ec 04             	sub    $0x4,%esp
  802127:	68 44 39 80 00       	push   $0x803944
  80212c:	6a 7c                	push   $0x7c
  80212e:	68 f3 38 80 00       	push   $0x8038f3
  802133:	e8 4c 0d 00 00       	call   802e84 <_panic>
  802138:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80213b:	8b 10                	mov    (%eax),%edx
  80213d:	8b 45 08             	mov    0x8(%ebp),%eax
  802140:	89 10                	mov    %edx,(%eax)
  802142:	8b 45 08             	mov    0x8(%ebp),%eax
  802145:	8b 00                	mov    (%eax),%eax
  802147:	85 c0                	test   %eax,%eax
  802149:	74 0b                	je     802156 <insert_sorted_allocList+0x1fd>
  80214b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80214e:	8b 00                	mov    (%eax),%eax
  802150:	8b 55 08             	mov    0x8(%ebp),%edx
  802153:	89 50 04             	mov    %edx,0x4(%eax)
  802156:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802159:	8b 55 08             	mov    0x8(%ebp),%edx
  80215c:	89 10                	mov    %edx,(%eax)
  80215e:	8b 45 08             	mov    0x8(%ebp),%eax
  802161:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802164:	89 50 04             	mov    %edx,0x4(%eax)
  802167:	8b 45 08             	mov    0x8(%ebp),%eax
  80216a:	8b 00                	mov    (%eax),%eax
  80216c:	85 c0                	test   %eax,%eax
  80216e:	75 08                	jne    802178 <insert_sorted_allocList+0x21f>
  802170:	8b 45 08             	mov    0x8(%ebp),%eax
  802173:	a3 44 40 80 00       	mov    %eax,0x804044
  802178:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80217d:	40                   	inc    %eax
  80217e:	a3 4c 40 80 00       	mov    %eax,0x80404c
		break;
  802183:	e9 ad 00 00 00       	jmp    802235 <insert_sorted_allocList+0x2dc>
	}else if (blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  802188:	8b 45 08             	mov    0x8(%ebp),%eax
  80218b:	8b 50 08             	mov    0x8(%eax),%edx
  80218e:	a1 44 40 80 00       	mov    0x804044,%eax
  802193:	8b 40 08             	mov    0x8(%eax),%eax
  802196:	39 c2                	cmp    %eax,%edx
  802198:	76 65                	jbe    8021ff <insert_sorted_allocList+0x2a6>
	{
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
  80219a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80219e:	75 17                	jne    8021b7 <insert_sorted_allocList+0x25e>
  8021a0:	83 ec 04             	sub    $0x4,%esp
  8021a3:	68 78 39 80 00       	push   $0x803978
  8021a8:	68 80 00 00 00       	push   $0x80
  8021ad:	68 f3 38 80 00       	push   $0x8038f3
  8021b2:	e8 cd 0c 00 00       	call   802e84 <_panic>
  8021b7:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8021bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c0:	89 50 04             	mov    %edx,0x4(%eax)
  8021c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c6:	8b 40 04             	mov    0x4(%eax),%eax
  8021c9:	85 c0                	test   %eax,%eax
  8021cb:	74 0c                	je     8021d9 <insert_sorted_allocList+0x280>
  8021cd:	a1 44 40 80 00       	mov    0x804044,%eax
  8021d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8021d5:	89 10                	mov    %edx,(%eax)
  8021d7:	eb 08                	jmp    8021e1 <insert_sorted_allocList+0x288>
  8021d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021dc:	a3 40 40 80 00       	mov    %eax,0x804040
  8021e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e4:	a3 44 40 80 00       	mov    %eax,0x804044
  8021e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021f2:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021f7:	40                   	inc    %eax
  8021f8:	a3 4c 40 80 00       	mov    %eax,0x80404c
		break;
  8021fd:	eb 36                	jmp    802235 <insert_sorted_allocList+0x2dc>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  8021ff:	a1 48 40 80 00       	mov    0x804048,%eax
  802204:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802207:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80220b:	74 07                	je     802214 <insert_sorted_allocList+0x2bb>
  80220d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802210:	8b 00                	mov    (%eax),%eax
  802212:	eb 05                	jmp    802219 <insert_sorted_allocList+0x2c0>
  802214:	b8 00 00 00 00       	mov    $0x0,%eax
  802219:	a3 48 40 80 00       	mov    %eax,0x804048
  80221e:	a1 48 40 80 00       	mov    0x804048,%eax
  802223:	85 c0                	test   %eax,%eax
  802225:	0f 85 23 fe ff ff    	jne    80204e <insert_sorted_allocList+0xf5>
  80222b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80222f:	0f 85 19 fe ff ff    	jne    80204e <insert_sorted_allocList+0xf5>
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
		break;

	}
	}
}
  802235:	90                   	nop
  802236:	c9                   	leave  
  802237:	c3                   	ret    

00802238 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802238:	55                   	push   %ebp
  802239:	89 e5                	mov    %esp,%ebp
  80223b:	83 ec 18             	sub    $0x18,%esp
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  80223e:	a1 38 41 80 00       	mov    0x804138,%eax
  802243:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802246:	e9 7c 01 00 00       	jmp    8023c7 <alloc_block_FF+0x18f>
		{
			// case 2
				if(element->size == size)
  80224b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224e:	8b 40 0c             	mov    0xc(%eax),%eax
  802251:	3b 45 08             	cmp    0x8(%ebp),%eax
  802254:	0f 85 90 00 00 00    	jne    8022ea <alloc_block_FF+0xb2>
				{
					tmp_block=element;
  80225a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225d:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,element);
  802260:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802264:	75 17                	jne    80227d <alloc_block_FF+0x45>
  802266:	83 ec 04             	sub    $0x4,%esp
  802269:	68 9b 39 80 00       	push   $0x80399b
  80226e:	68 ba 00 00 00       	push   $0xba
  802273:	68 f3 38 80 00       	push   $0x8038f3
  802278:	e8 07 0c 00 00       	call   802e84 <_panic>
  80227d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802280:	8b 00                	mov    (%eax),%eax
  802282:	85 c0                	test   %eax,%eax
  802284:	74 10                	je     802296 <alloc_block_FF+0x5e>
  802286:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802289:	8b 00                	mov    (%eax),%eax
  80228b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80228e:	8b 52 04             	mov    0x4(%edx),%edx
  802291:	89 50 04             	mov    %edx,0x4(%eax)
  802294:	eb 0b                	jmp    8022a1 <alloc_block_FF+0x69>
  802296:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802299:	8b 40 04             	mov    0x4(%eax),%eax
  80229c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8022a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a4:	8b 40 04             	mov    0x4(%eax),%eax
  8022a7:	85 c0                	test   %eax,%eax
  8022a9:	74 0f                	je     8022ba <alloc_block_FF+0x82>
  8022ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ae:	8b 40 04             	mov    0x4(%eax),%eax
  8022b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022b4:	8b 12                	mov    (%edx),%edx
  8022b6:	89 10                	mov    %edx,(%eax)
  8022b8:	eb 0a                	jmp    8022c4 <alloc_block_FF+0x8c>
  8022ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022bd:	8b 00                	mov    (%eax),%eax
  8022bf:	a3 38 41 80 00       	mov    %eax,0x804138
  8022c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022d7:	a1 44 41 80 00       	mov    0x804144,%eax
  8022dc:	48                   	dec    %eax
  8022dd:	a3 44 41 80 00       	mov    %eax,0x804144
					return tmp_block;
  8022e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022e5:	e9 10 01 00 00       	jmp    8023fa <alloc_block_FF+0x1c2>
				}
				 // case 3
				else if(element->size > size)
  8022ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8022f0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022f3:	0f 86 c6 00 00 00    	jbe    8023bf <alloc_block_FF+0x187>
				{
					// the new block are created
					tmp_block = AvailableMemBlocksList.lh_first ;
  8022f9:	a1 48 41 80 00       	mov    0x804148,%eax
  8022fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  802301:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802305:	75 17                	jne    80231e <alloc_block_FF+0xe6>
  802307:	83 ec 04             	sub    $0x4,%esp
  80230a:	68 9b 39 80 00       	push   $0x80399b
  80230f:	68 c2 00 00 00       	push   $0xc2
  802314:	68 f3 38 80 00       	push   $0x8038f3
  802319:	e8 66 0b 00 00       	call   802e84 <_panic>
  80231e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802321:	8b 00                	mov    (%eax),%eax
  802323:	85 c0                	test   %eax,%eax
  802325:	74 10                	je     802337 <alloc_block_FF+0xff>
  802327:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80232a:	8b 00                	mov    (%eax),%eax
  80232c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80232f:	8b 52 04             	mov    0x4(%edx),%edx
  802332:	89 50 04             	mov    %edx,0x4(%eax)
  802335:	eb 0b                	jmp    802342 <alloc_block_FF+0x10a>
  802337:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80233a:	8b 40 04             	mov    0x4(%eax),%eax
  80233d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802342:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802345:	8b 40 04             	mov    0x4(%eax),%eax
  802348:	85 c0                	test   %eax,%eax
  80234a:	74 0f                	je     80235b <alloc_block_FF+0x123>
  80234c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80234f:	8b 40 04             	mov    0x4(%eax),%eax
  802352:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802355:	8b 12                	mov    (%edx),%edx
  802357:	89 10                	mov    %edx,(%eax)
  802359:	eb 0a                	jmp    802365 <alloc_block_FF+0x12d>
  80235b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80235e:	8b 00                	mov    (%eax),%eax
  802360:	a3 48 41 80 00       	mov    %eax,0x804148
  802365:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802368:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80236e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802371:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802378:	a1 54 41 80 00       	mov    0x804154,%eax
  80237d:	48                   	dec    %eax
  80237e:	a3 54 41 80 00       	mov    %eax,0x804154
					tmp_block->sva=element->sva;
  802383:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802386:	8b 50 08             	mov    0x8(%eax),%edx
  802389:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80238c:	89 50 08             	mov    %edx,0x8(%eax)
					tmp_block->size=size;
  80238f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802392:	8b 55 08             	mov    0x8(%ebp),%edx
  802395:	89 50 0c             	mov    %edx,0xc(%eax)
					//update block with remaining space
					element->size-=size;
  802398:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239b:	8b 40 0c             	mov    0xc(%eax),%eax
  80239e:	2b 45 08             	sub    0x8(%ebp),%eax
  8023a1:	89 c2                	mov    %eax,%edx
  8023a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a6:	89 50 0c             	mov    %edx,0xc(%eax)
					element->sva = element->sva + size;
  8023a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ac:	8b 50 08             	mov    0x8(%eax),%edx
  8023af:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b2:	01 c2                	add    %eax,%edx
  8023b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b7:	89 50 08             	mov    %edx,0x8(%eax)
					// return back the new block
					return tmp_block ;
  8023ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023bd:	eb 3b                	jmp    8023fa <alloc_block_FF+0x1c2>
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  8023bf:	a1 40 41 80 00       	mov    0x804140,%eax
  8023c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023cb:	74 07                	je     8023d4 <alloc_block_FF+0x19c>
  8023cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d0:	8b 00                	mov    (%eax),%eax
  8023d2:	eb 05                	jmp    8023d9 <alloc_block_FF+0x1a1>
  8023d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8023d9:	a3 40 41 80 00       	mov    %eax,0x804140
  8023de:	a1 40 41 80 00       	mov    0x804140,%eax
  8023e3:	85 c0                	test   %eax,%eax
  8023e5:	0f 85 60 fe ff ff    	jne    80224b <alloc_block_FF+0x13>
  8023eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023ef:	0f 85 56 fe ff ff    	jne    80224b <alloc_block_FF+0x13>
					// return back the new block
					return tmp_block ;
				}
		}
		// case 1
	  return NULL ;}
  8023f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8023fa:	c9                   	leave  
  8023fb:	c3                   	ret    

008023fc <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================

struct MemBlock *alloc_block_BF(uint32 size)
{
  8023fc:	55                   	push   %ebp
  8023fd:	89 e5                	mov    %esp,%ebp
  8023ff:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
  802402:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802409:	a1 38 41 80 00       	mov    0x804138,%eax
  80240e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802411:	eb 3a                	jmp    80244d <alloc_block_BF+0x51>
		{
			if(element->size >= size)
  802413:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802416:	8b 40 0c             	mov    0xc(%eax),%eax
  802419:	3b 45 08             	cmp    0x8(%ebp),%eax
  80241c:	72 27                	jb     802445 <alloc_block_BF+0x49>
			{
				if(best_size==-1)
  80241e:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802422:	75 0b                	jne    80242f <alloc_block_BF+0x33>
					best_size= element->size;
  802424:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802427:	8b 40 0c             	mov    0xc(%eax),%eax
  80242a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80242d:	eb 16                	jmp    802445 <alloc_block_BF+0x49>
				else if(best_size >= element->size)
  80242f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802432:	8b 50 0c             	mov    0xc(%eax),%edx
  802435:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802438:	39 c2                	cmp    %eax,%edx
  80243a:	77 09                	ja     802445 <alloc_block_BF+0x49>
					best_size=element->size;
  80243c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243f:	8b 40 0c             	mov    0xc(%eax),%eax
  802442:	89 45 f0             	mov    %eax,-0x10(%ebp)

struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802445:	a1 40 41 80 00       	mov    0x804140,%eax
  80244a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80244d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802451:	74 07                	je     80245a <alloc_block_BF+0x5e>
  802453:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802456:	8b 00                	mov    (%eax),%eax
  802458:	eb 05                	jmp    80245f <alloc_block_BF+0x63>
  80245a:	b8 00 00 00 00       	mov    $0x0,%eax
  80245f:	a3 40 41 80 00       	mov    %eax,0x804140
  802464:	a1 40 41 80 00       	mov    0x804140,%eax
  802469:	85 c0                	test   %eax,%eax
  80246b:	75 a6                	jne    802413 <alloc_block_BF+0x17>
  80246d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802471:	75 a0                	jne    802413 <alloc_block_BF+0x17>
					best_size= element->size;
				else if(best_size >= element->size)
					best_size=element->size;
			}
		}
		if(best_size != -1)
  802473:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802477:	0f 84 d3 01 00 00    	je     802650 <alloc_block_BF+0x254>
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  80247d:	a1 38 41 80 00       	mov    0x804138,%eax
  802482:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802485:	e9 98 01 00 00       	jmp    802622 <alloc_block_BF+0x226>
			{
			 if((best_size > size) && (best_size == element->size))
  80248a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80248d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802490:	0f 86 da 00 00 00    	jbe    802570 <alloc_block_BF+0x174>
  802496:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802499:	8b 50 0c             	mov    0xc(%eax),%edx
  80249c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80249f:	39 c2                	cmp    %eax,%edx
  8024a1:	0f 85 c9 00 00 00    	jne    802570 <alloc_block_BF+0x174>
			  {
				// the new block are created
			    tmp_block = AvailableMemBlocksList.lh_first ;
  8024a7:	a1 48 41 80 00       	mov    0x804148,%eax
  8024ac:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  8024af:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8024b3:	75 17                	jne    8024cc <alloc_block_BF+0xd0>
  8024b5:	83 ec 04             	sub    $0x4,%esp
  8024b8:	68 9b 39 80 00       	push   $0x80399b
  8024bd:	68 ea 00 00 00       	push   $0xea
  8024c2:	68 f3 38 80 00       	push   $0x8038f3
  8024c7:	e8 b8 09 00 00       	call   802e84 <_panic>
  8024cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024cf:	8b 00                	mov    (%eax),%eax
  8024d1:	85 c0                	test   %eax,%eax
  8024d3:	74 10                	je     8024e5 <alloc_block_BF+0xe9>
  8024d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024d8:	8b 00                	mov    (%eax),%eax
  8024da:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024dd:	8b 52 04             	mov    0x4(%edx),%edx
  8024e0:	89 50 04             	mov    %edx,0x4(%eax)
  8024e3:	eb 0b                	jmp    8024f0 <alloc_block_BF+0xf4>
  8024e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024e8:	8b 40 04             	mov    0x4(%eax),%eax
  8024eb:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8024f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024f3:	8b 40 04             	mov    0x4(%eax),%eax
  8024f6:	85 c0                	test   %eax,%eax
  8024f8:	74 0f                	je     802509 <alloc_block_BF+0x10d>
  8024fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024fd:	8b 40 04             	mov    0x4(%eax),%eax
  802500:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802503:	8b 12                	mov    (%edx),%edx
  802505:	89 10                	mov    %edx,(%eax)
  802507:	eb 0a                	jmp    802513 <alloc_block_BF+0x117>
  802509:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80250c:	8b 00                	mov    (%eax),%eax
  80250e:	a3 48 41 80 00       	mov    %eax,0x804148
  802513:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802516:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80251c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80251f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802526:	a1 54 41 80 00       	mov    0x804154,%eax
  80252b:	48                   	dec    %eax
  80252c:	a3 54 41 80 00       	mov    %eax,0x804154
				tmp_block->sva=element->sva;
  802531:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802534:	8b 50 08             	mov    0x8(%eax),%edx
  802537:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80253a:	89 50 08             	mov    %edx,0x8(%eax)
				tmp_block->size=size;
  80253d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802540:	8b 55 08             	mov    0x8(%ebp),%edx
  802543:	89 50 0c             	mov    %edx,0xc(%eax)
				//update block with remaining space
				element->size-=size;
  802546:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802549:	8b 40 0c             	mov    0xc(%eax),%eax
  80254c:	2b 45 08             	sub    0x8(%ebp),%eax
  80254f:	89 c2                	mov    %eax,%edx
  802551:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802554:	89 50 0c             	mov    %edx,0xc(%eax)
				element->sva = element->sva + size;
  802557:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255a:	8b 50 08             	mov    0x8(%eax),%edx
  80255d:	8b 45 08             	mov    0x8(%ebp),%eax
  802560:	01 c2                	add    %eax,%edx
  802562:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802565:	89 50 08             	mov    %edx,0x8(%eax)
				// return back the new block
				return tmp_block ;
  802568:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80256b:	e9 e5 00 00 00       	jmp    802655 <alloc_block_BF+0x259>

			  }
			else if((element->size == best_size)&&(best_size == size))
  802570:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802573:	8b 50 0c             	mov    0xc(%eax),%edx
  802576:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802579:	39 c2                	cmp    %eax,%edx
  80257b:	0f 85 99 00 00 00    	jne    80261a <alloc_block_BF+0x21e>
  802581:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802584:	3b 45 08             	cmp    0x8(%ebp),%eax
  802587:	0f 85 8d 00 00 00    	jne    80261a <alloc_block_BF+0x21e>
			  {
				tmp_block=element;
  80258d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802590:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&FreeMemBlocksList,element);
  802593:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802597:	75 17                	jne    8025b0 <alloc_block_BF+0x1b4>
  802599:	83 ec 04             	sub    $0x4,%esp
  80259c:	68 9b 39 80 00       	push   $0x80399b
  8025a1:	68 f7 00 00 00       	push   $0xf7
  8025a6:	68 f3 38 80 00       	push   $0x8038f3
  8025ab:	e8 d4 08 00 00       	call   802e84 <_panic>
  8025b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b3:	8b 00                	mov    (%eax),%eax
  8025b5:	85 c0                	test   %eax,%eax
  8025b7:	74 10                	je     8025c9 <alloc_block_BF+0x1cd>
  8025b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bc:	8b 00                	mov    (%eax),%eax
  8025be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025c1:	8b 52 04             	mov    0x4(%edx),%edx
  8025c4:	89 50 04             	mov    %edx,0x4(%eax)
  8025c7:	eb 0b                	jmp    8025d4 <alloc_block_BF+0x1d8>
  8025c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cc:	8b 40 04             	mov    0x4(%eax),%eax
  8025cf:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8025d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d7:	8b 40 04             	mov    0x4(%eax),%eax
  8025da:	85 c0                	test   %eax,%eax
  8025dc:	74 0f                	je     8025ed <alloc_block_BF+0x1f1>
  8025de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e1:	8b 40 04             	mov    0x4(%eax),%eax
  8025e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025e7:	8b 12                	mov    (%edx),%edx
  8025e9:	89 10                	mov    %edx,(%eax)
  8025eb:	eb 0a                	jmp    8025f7 <alloc_block_BF+0x1fb>
  8025ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f0:	8b 00                	mov    (%eax),%eax
  8025f2:	a3 38 41 80 00       	mov    %eax,0x804138
  8025f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802600:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802603:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80260a:	a1 44 41 80 00       	mov    0x804144,%eax
  80260f:	48                   	dec    %eax
  802610:	a3 44 41 80 00       	mov    %eax,0x804144
				return tmp_block;
  802615:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802618:	eb 3b                	jmp    802655 <alloc_block_BF+0x259>
					best_size=element->size;
			}
		}
		if(best_size != -1)
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  80261a:	a1 40 41 80 00       	mov    0x804140,%eax
  80261f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802622:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802626:	74 07                	je     80262f <alloc_block_BF+0x233>
  802628:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262b:	8b 00                	mov    (%eax),%eax
  80262d:	eb 05                	jmp    802634 <alloc_block_BF+0x238>
  80262f:	b8 00 00 00 00       	mov    $0x0,%eax
  802634:	a3 40 41 80 00       	mov    %eax,0x804140
  802639:	a1 40 41 80 00       	mov    0x804140,%eax
  80263e:	85 c0                	test   %eax,%eax
  802640:	0f 85 44 fe ff ff    	jne    80248a <alloc_block_BF+0x8e>
  802646:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80264a:	0f 85 3a fe ff ff    	jne    80248a <alloc_block_BF+0x8e>
				LIST_REMOVE(&FreeMemBlocksList,element);
				return tmp_block;
			 }
			}
		}
		return NULL ;}
  802650:	b8 00 00 00 00       	mov    $0x0,%eax
  802655:	c9                   	leave  
  802656:	c3                   	ret    

00802657 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802657:	55                   	push   %ebp
  802658:	89 e5                	mov    %esp,%ebp
  80265a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  80265d:	83 ec 04             	sub    $0x4,%esp
  802660:	68 bc 39 80 00       	push   $0x8039bc
  802665:	68 04 01 00 00       	push   $0x104
  80266a:	68 f3 38 80 00       	push   $0x8038f3
  80266f:	e8 10 08 00 00       	call   802e84 <_panic>

00802674 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{struct MemBlock * blk_itr;
  802674:	55                   	push   %ebp
  802675:	89 e5                	mov    %esp,%ebp
  802677:	83 ec 18             	sub    $0x18,%esp
struct MemBlock * next;
struct MemBlock * first = LIST_FIRST(&(FreeMemBlocksList));
  80267a:	a1 38 41 80 00       	mov    0x804138,%eax
  80267f:	89 45 f0             	mov    %eax,-0x10(%ebp)
struct MemBlock * last = LIST_LAST(&(FreeMemBlocksList));
  802682:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802687:	89 45 ec             	mov    %eax,-0x14(%ebp)

if(LIST_EMPTY(&(FreeMemBlocksList)))
  80268a:	a1 38 41 80 00       	mov    0x804138,%eax
  80268f:	85 c0                	test   %eax,%eax
  802691:	75 68                	jne    8026fb <insert_sorted_with_merge_freeList+0x87>
			{

				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  802693:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802697:	75 17                	jne    8026b0 <insert_sorted_with_merge_freeList+0x3c>
  802699:	83 ec 04             	sub    $0x4,%esp
  80269c:	68 d0 38 80 00       	push   $0x8038d0
  8026a1:	68 14 01 00 00       	push   $0x114
  8026a6:	68 f3 38 80 00       	push   $0x8038f3
  8026ab:	e8 d4 07 00 00       	call   802e84 <_panic>
  8026b0:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8026b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b9:	89 10                	mov    %edx,(%eax)
  8026bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8026be:	8b 00                	mov    (%eax),%eax
  8026c0:	85 c0                	test   %eax,%eax
  8026c2:	74 0d                	je     8026d1 <insert_sorted_with_merge_freeList+0x5d>
  8026c4:	a1 38 41 80 00       	mov    0x804138,%eax
  8026c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8026cc:	89 50 04             	mov    %edx,0x4(%eax)
  8026cf:	eb 08                	jmp    8026d9 <insert_sorted_with_merge_freeList+0x65>
  8026d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d4:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8026d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8026dc:	a3 38 41 80 00       	mov    %eax,0x804138
  8026e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026eb:	a1 44 41 80 00       	mov    0x804144,%eax
  8026f0:	40                   	inc    %eax
  8026f1:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  8026f6:	e9 d2 06 00 00       	jmp    802dcd <insert_sorted_with_merge_freeList+0x759>
				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);

			}
else
{
	if( blockToInsert->sva  < first->sva )
  8026fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8026fe:	8b 50 08             	mov    0x8(%eax),%edx
  802701:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802704:	8b 40 08             	mov    0x8(%eax),%eax
  802707:	39 c2                	cmp    %eax,%edx
  802709:	0f 83 22 01 00 00    	jae    802831 <insert_sorted_with_merge_freeList+0x1bd>
	{
                if( blockToInsert->sva + blockToInsert->size == first->sva)
  80270f:	8b 45 08             	mov    0x8(%ebp),%eax
  802712:	8b 50 08             	mov    0x8(%eax),%edx
  802715:	8b 45 08             	mov    0x8(%ebp),%eax
  802718:	8b 40 0c             	mov    0xc(%eax),%eax
  80271b:	01 c2                	add    %eax,%edx
  80271d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802720:	8b 40 08             	mov    0x8(%eax),%eax
  802723:	39 c2                	cmp    %eax,%edx
  802725:	0f 85 9e 00 00 00    	jne    8027c9 <insert_sorted_with_merge_freeList+0x155>
                {

                	first->sva = blockToInsert->sva;
  80272b:	8b 45 08             	mov    0x8(%ebp),%eax
  80272e:	8b 50 08             	mov    0x8(%eax),%edx
  802731:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802734:	89 50 08             	mov    %edx,0x8(%eax)
                	first->size = first->size + blockToInsert->size;
  802737:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80273a:	8b 50 0c             	mov    0xc(%eax),%edx
  80273d:	8b 45 08             	mov    0x8(%ebp),%eax
  802740:	8b 40 0c             	mov    0xc(%eax),%eax
  802743:	01 c2                	add    %eax,%edx
  802745:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802748:	89 50 0c             	mov    %edx,0xc(%eax)
                	blockToInsert->size = blockToInsert->sva = 0;
  80274b:	8b 45 08             	mov    0x8(%ebp),%eax
  80274e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802755:	8b 45 08             	mov    0x8(%ebp),%eax
  802758:	8b 50 08             	mov    0x8(%eax),%edx
  80275b:	8b 45 08             	mov    0x8(%ebp),%eax
  80275e:	89 50 0c             	mov    %edx,0xc(%eax)
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802761:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802765:	75 17                	jne    80277e <insert_sorted_with_merge_freeList+0x10a>
  802767:	83 ec 04             	sub    $0x4,%esp
  80276a:	68 d0 38 80 00       	push   $0x8038d0
  80276f:	68 21 01 00 00       	push   $0x121
  802774:	68 f3 38 80 00       	push   $0x8038f3
  802779:	e8 06 07 00 00       	call   802e84 <_panic>
  80277e:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802784:	8b 45 08             	mov    0x8(%ebp),%eax
  802787:	89 10                	mov    %edx,(%eax)
  802789:	8b 45 08             	mov    0x8(%ebp),%eax
  80278c:	8b 00                	mov    (%eax),%eax
  80278e:	85 c0                	test   %eax,%eax
  802790:	74 0d                	je     80279f <insert_sorted_with_merge_freeList+0x12b>
  802792:	a1 48 41 80 00       	mov    0x804148,%eax
  802797:	8b 55 08             	mov    0x8(%ebp),%edx
  80279a:	89 50 04             	mov    %edx,0x4(%eax)
  80279d:	eb 08                	jmp    8027a7 <insert_sorted_with_merge_freeList+0x133>
  80279f:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a2:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8027a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8027aa:	a3 48 41 80 00       	mov    %eax,0x804148
  8027af:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027b9:	a1 54 41 80 00       	mov    0x804154,%eax
  8027be:	40                   	inc    %eax
  8027bf:	a3 54 41 80 00       	mov    %eax,0x804154
						}
				}
        }

}
}
  8027c4:	e9 04 06 00 00       	jmp    802dcd <insert_sorted_with_merge_freeList+0x759>
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
                }

                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  8027c9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027cd:	75 17                	jne    8027e6 <insert_sorted_with_merge_freeList+0x172>
  8027cf:	83 ec 04             	sub    $0x4,%esp
  8027d2:	68 d0 38 80 00       	push   $0x8038d0
  8027d7:	68 26 01 00 00       	push   $0x126
  8027dc:	68 f3 38 80 00       	push   $0x8038f3
  8027e1:	e8 9e 06 00 00       	call   802e84 <_panic>
  8027e6:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8027ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ef:	89 10                	mov    %edx,(%eax)
  8027f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f4:	8b 00                	mov    (%eax),%eax
  8027f6:	85 c0                	test   %eax,%eax
  8027f8:	74 0d                	je     802807 <insert_sorted_with_merge_freeList+0x193>
  8027fa:	a1 38 41 80 00       	mov    0x804138,%eax
  8027ff:	8b 55 08             	mov    0x8(%ebp),%edx
  802802:	89 50 04             	mov    %edx,0x4(%eax)
  802805:	eb 08                	jmp    80280f <insert_sorted_with_merge_freeList+0x19b>
  802807:	8b 45 08             	mov    0x8(%ebp),%eax
  80280a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80280f:	8b 45 08             	mov    0x8(%ebp),%eax
  802812:	a3 38 41 80 00       	mov    %eax,0x804138
  802817:	8b 45 08             	mov    0x8(%ebp),%eax
  80281a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802821:	a1 44 41 80 00       	mov    0x804144,%eax
  802826:	40                   	inc    %eax
  802827:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  80282c:	e9 9c 05 00 00       	jmp    802dcd <insert_sorted_with_merge_freeList+0x759>
                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
                }
	}
    else if(blockToInsert->sva > last->sva)
  802831:	8b 45 08             	mov    0x8(%ebp),%eax
  802834:	8b 50 08             	mov    0x8(%eax),%edx
  802837:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80283a:	8b 40 08             	mov    0x8(%eax),%eax
  80283d:	39 c2                	cmp    %eax,%edx
  80283f:	0f 86 16 01 00 00    	jbe    80295b <insert_sorted_with_merge_freeList+0x2e7>
 	{

				if(last->sva + last->size == blockToInsert->sva)
  802845:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802848:	8b 50 08             	mov    0x8(%eax),%edx
  80284b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80284e:	8b 40 0c             	mov    0xc(%eax),%eax
  802851:	01 c2                	add    %eax,%edx
  802853:	8b 45 08             	mov    0x8(%ebp),%eax
  802856:	8b 40 08             	mov    0x8(%eax),%eax
  802859:	39 c2                	cmp    %eax,%edx
  80285b:	0f 85 92 00 00 00    	jne    8028f3 <insert_sorted_with_merge_freeList+0x27f>
				{

					last->size = last->size + blockToInsert->size;
  802861:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802864:	8b 50 0c             	mov    0xc(%eax),%edx
  802867:	8b 45 08             	mov    0x8(%ebp),%eax
  80286a:	8b 40 0c             	mov    0xc(%eax),%eax
  80286d:	01 c2                	add    %eax,%edx
  80286f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802872:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->size = blockToInsert->sva = 0;
  802875:	8b 45 08             	mov    0x8(%ebp),%eax
  802878:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80287f:	8b 45 08             	mov    0x8(%ebp),%eax
  802882:	8b 50 08             	mov    0x8(%eax),%edx
  802885:	8b 45 08             	mov    0x8(%ebp),%eax
  802888:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  80288b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80288f:	75 17                	jne    8028a8 <insert_sorted_with_merge_freeList+0x234>
  802891:	83 ec 04             	sub    $0x4,%esp
  802894:	68 d0 38 80 00       	push   $0x8038d0
  802899:	68 31 01 00 00       	push   $0x131
  80289e:	68 f3 38 80 00       	push   $0x8038f3
  8028a3:	e8 dc 05 00 00       	call   802e84 <_panic>
  8028a8:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8028ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b1:	89 10                	mov    %edx,(%eax)
  8028b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b6:	8b 00                	mov    (%eax),%eax
  8028b8:	85 c0                	test   %eax,%eax
  8028ba:	74 0d                	je     8028c9 <insert_sorted_with_merge_freeList+0x255>
  8028bc:	a1 48 41 80 00       	mov    0x804148,%eax
  8028c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8028c4:	89 50 04             	mov    %edx,0x4(%eax)
  8028c7:	eb 08                	jmp    8028d1 <insert_sorted_with_merge_freeList+0x25d>
  8028c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028cc:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8028d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d4:	a3 48 41 80 00       	mov    %eax,0x804148
  8028d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028dc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028e3:	a1 54 41 80 00       	mov    0x804154,%eax
  8028e8:	40                   	inc    %eax
  8028e9:	a3 54 41 80 00       	mov    %eax,0x804154
						}
				}
        }

}
}
  8028ee:	e9 da 04 00 00       	jmp    802dcd <insert_sorted_with_merge_freeList+0x759>

				}

				else
				{
					LIST_INSERT_TAIL(&(FreeMemBlocksList),  blockToInsert);
  8028f3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028f7:	75 17                	jne    802910 <insert_sorted_with_merge_freeList+0x29c>
  8028f9:	83 ec 04             	sub    $0x4,%esp
  8028fc:	68 78 39 80 00       	push   $0x803978
  802901:	68 37 01 00 00       	push   $0x137
  802906:	68 f3 38 80 00       	push   $0x8038f3
  80290b:	e8 74 05 00 00       	call   802e84 <_panic>
  802910:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802916:	8b 45 08             	mov    0x8(%ebp),%eax
  802919:	89 50 04             	mov    %edx,0x4(%eax)
  80291c:	8b 45 08             	mov    0x8(%ebp),%eax
  80291f:	8b 40 04             	mov    0x4(%eax),%eax
  802922:	85 c0                	test   %eax,%eax
  802924:	74 0c                	je     802932 <insert_sorted_with_merge_freeList+0x2be>
  802926:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80292b:	8b 55 08             	mov    0x8(%ebp),%edx
  80292e:	89 10                	mov    %edx,(%eax)
  802930:	eb 08                	jmp    80293a <insert_sorted_with_merge_freeList+0x2c6>
  802932:	8b 45 08             	mov    0x8(%ebp),%eax
  802935:	a3 38 41 80 00       	mov    %eax,0x804138
  80293a:	8b 45 08             	mov    0x8(%ebp),%eax
  80293d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802942:	8b 45 08             	mov    0x8(%ebp),%eax
  802945:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80294b:	a1 44 41 80 00       	mov    0x804144,%eax
  802950:	40                   	inc    %eax
  802951:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  802956:	e9 72 04 00 00       	jmp    802dcd <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  80295b:	a1 38 41 80 00       	mov    0x804138,%eax
  802960:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802963:	e9 35 04 00 00       	jmp    802d9d <insert_sorted_with_merge_freeList+0x729>
				{
				     next=LIST_NEXT(blk_itr);
  802968:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296b:	8b 00                	mov    (%eax),%eax
  80296d:	89 45 e8             	mov    %eax,-0x18(%ebp)


					if( (blockToInsert->sva > blk_itr->sva) )
  802970:	8b 45 08             	mov    0x8(%ebp),%eax
  802973:	8b 50 08             	mov    0x8(%eax),%edx
  802976:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802979:	8b 40 08             	mov    0x8(%eax),%eax
  80297c:	39 c2                	cmp    %eax,%edx
  80297e:	0f 86 11 04 00 00    	jbe    802d95 <insert_sorted_with_merge_freeList+0x721>
						{
							if(((blk_itr->sva) + (blk_itr->size) < blockToInsert->sva && (blockToInsert->sva) + (blockToInsert->size) < next->sva))
  802984:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802987:	8b 50 08             	mov    0x8(%eax),%edx
  80298a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298d:	8b 40 0c             	mov    0xc(%eax),%eax
  802990:	01 c2                	add    %eax,%edx
  802992:	8b 45 08             	mov    0x8(%ebp),%eax
  802995:	8b 40 08             	mov    0x8(%eax),%eax
  802998:	39 c2                	cmp    %eax,%edx
  80299a:	0f 83 8b 00 00 00    	jae    802a2b <insert_sorted_with_merge_freeList+0x3b7>
  8029a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a3:	8b 50 08             	mov    0x8(%eax),%edx
  8029a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8029ac:	01 c2                	add    %eax,%edx
  8029ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029b1:	8b 40 08             	mov    0x8(%eax),%eax
  8029b4:	39 c2                	cmp    %eax,%edx
  8029b6:	73 73                	jae    802a2b <insert_sorted_with_merge_freeList+0x3b7>
							{
								LIST_INSERT_AFTER(&(FreeMemBlocksList), blk_itr, blockToInsert);
  8029b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029bc:	74 06                	je     8029c4 <insert_sorted_with_merge_freeList+0x350>
  8029be:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029c2:	75 17                	jne    8029db <insert_sorted_with_merge_freeList+0x367>
  8029c4:	83 ec 04             	sub    $0x4,%esp
  8029c7:	68 44 39 80 00       	push   $0x803944
  8029cc:	68 48 01 00 00       	push   $0x148
  8029d1:	68 f3 38 80 00       	push   $0x8038f3
  8029d6:	e8 a9 04 00 00       	call   802e84 <_panic>
  8029db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029de:	8b 10                	mov    (%eax),%edx
  8029e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e3:	89 10                	mov    %edx,(%eax)
  8029e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e8:	8b 00                	mov    (%eax),%eax
  8029ea:	85 c0                	test   %eax,%eax
  8029ec:	74 0b                	je     8029f9 <insert_sorted_with_merge_freeList+0x385>
  8029ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f1:	8b 00                	mov    (%eax),%eax
  8029f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8029f6:	89 50 04             	mov    %edx,0x4(%eax)
  8029f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8029ff:	89 10                	mov    %edx,(%eax)
  802a01:	8b 45 08             	mov    0x8(%ebp),%eax
  802a04:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a07:	89 50 04             	mov    %edx,0x4(%eax)
  802a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0d:	8b 00                	mov    (%eax),%eax
  802a0f:	85 c0                	test   %eax,%eax
  802a11:	75 08                	jne    802a1b <insert_sorted_with_merge_freeList+0x3a7>
  802a13:	8b 45 08             	mov    0x8(%ebp),%eax
  802a16:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a1b:	a1 44 41 80 00       	mov    0x804144,%eax
  802a20:	40                   	inc    %eax
  802a21:	a3 44 41 80 00       	mov    %eax,0x804144
								break;
  802a26:	e9 a2 03 00 00       	jmp    802dcd <insert_sorted_with_merge_freeList+0x759>

							}
							else if((blockToInsert->sva + blockToInsert->size) < next->sva  && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  802a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2e:	8b 50 08             	mov    0x8(%eax),%edx
  802a31:	8b 45 08             	mov    0x8(%ebp),%eax
  802a34:	8b 40 0c             	mov    0xc(%eax),%eax
  802a37:	01 c2                	add    %eax,%edx
  802a39:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a3c:	8b 40 08             	mov    0x8(%eax),%eax
  802a3f:	39 c2                	cmp    %eax,%edx
  802a41:	0f 83 ae 00 00 00    	jae    802af5 <insert_sorted_with_merge_freeList+0x481>
  802a47:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4a:	8b 50 08             	mov    0x8(%eax),%edx
  802a4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a50:	8b 48 08             	mov    0x8(%eax),%ecx
  802a53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a56:	8b 40 0c             	mov    0xc(%eax),%eax
  802a59:	01 c8                	add    %ecx,%eax
  802a5b:	39 c2                	cmp    %eax,%edx
  802a5d:	0f 85 92 00 00 00    	jne    802af5 <insert_sorted_with_merge_freeList+0x481>
							{

								blk_itr->size=blk_itr->size+blockToInsert->size;
  802a63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a66:	8b 50 0c             	mov    0xc(%eax),%edx
  802a69:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6c:	8b 40 0c             	mov    0xc(%eax),%eax
  802a6f:	01 c2                	add    %eax,%edx
  802a71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a74:	89 50 0c             	mov    %edx,0xc(%eax)
								 blockToInsert->size=blockToInsert->sva=0;
  802a77:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802a81:	8b 45 08             	mov    0x8(%ebp),%eax
  802a84:	8b 50 08             	mov    0x8(%eax),%edx
  802a87:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8a:	89 50 0c             	mov    %edx,0xc(%eax)
								 LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802a8d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a91:	75 17                	jne    802aaa <insert_sorted_with_merge_freeList+0x436>
  802a93:	83 ec 04             	sub    $0x4,%esp
  802a96:	68 d0 38 80 00       	push   $0x8038d0
  802a9b:	68 51 01 00 00       	push   $0x151
  802aa0:	68 f3 38 80 00       	push   $0x8038f3
  802aa5:	e8 da 03 00 00       	call   802e84 <_panic>
  802aaa:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab3:	89 10                	mov    %edx,(%eax)
  802ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab8:	8b 00                	mov    (%eax),%eax
  802aba:	85 c0                	test   %eax,%eax
  802abc:	74 0d                	je     802acb <insert_sorted_with_merge_freeList+0x457>
  802abe:	a1 48 41 80 00       	mov    0x804148,%eax
  802ac3:	8b 55 08             	mov    0x8(%ebp),%edx
  802ac6:	89 50 04             	mov    %edx,0x4(%eax)
  802ac9:	eb 08                	jmp    802ad3 <insert_sorted_with_merge_freeList+0x45f>
  802acb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ace:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad6:	a3 48 41 80 00       	mov    %eax,0x804148
  802adb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ade:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ae5:	a1 54 41 80 00       	mov    0x804154,%eax
  802aea:	40                   	inc    %eax
  802aeb:	a3 54 41 80 00       	mov    %eax,0x804154
								 break;
  802af0:	e9 d8 02 00 00       	jmp    802dcd <insert_sorted_with_merge_freeList+0x759>

							}
							else if( (blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva > (blk_itr->sva + blk_itr->size))
  802af5:	8b 45 08             	mov    0x8(%ebp),%eax
  802af8:	8b 50 08             	mov    0x8(%eax),%edx
  802afb:	8b 45 08             	mov    0x8(%ebp),%eax
  802afe:	8b 40 0c             	mov    0xc(%eax),%eax
  802b01:	01 c2                	add    %eax,%edx
  802b03:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b06:	8b 40 08             	mov    0x8(%eax),%eax
  802b09:	39 c2                	cmp    %eax,%edx
  802b0b:	0f 85 ba 00 00 00    	jne    802bcb <insert_sorted_with_merge_freeList+0x557>
  802b11:	8b 45 08             	mov    0x8(%ebp),%eax
  802b14:	8b 50 08             	mov    0x8(%eax),%edx
  802b17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1a:	8b 48 08             	mov    0x8(%eax),%ecx
  802b1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b20:	8b 40 0c             	mov    0xc(%eax),%eax
  802b23:	01 c8                	add    %ecx,%eax
  802b25:	39 c2                	cmp    %eax,%edx
  802b27:	0f 86 9e 00 00 00    	jbe    802bcb <insert_sorted_with_merge_freeList+0x557>
							{
								next->size = next->size + blockToInsert->size;
  802b2d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b30:	8b 50 0c             	mov    0xc(%eax),%edx
  802b33:	8b 45 08             	mov    0x8(%ebp),%eax
  802b36:	8b 40 0c             	mov    0xc(%eax),%eax
  802b39:	01 c2                	add    %eax,%edx
  802b3b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b3e:	89 50 0c             	mov    %edx,0xc(%eax)
								next->sva = blockToInsert->sva;
  802b41:	8b 45 08             	mov    0x8(%ebp),%eax
  802b44:	8b 50 08             	mov    0x8(%eax),%edx
  802b47:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b4a:	89 50 08             	mov    %edx,0x8(%eax)

								blockToInsert->size = blockToInsert->sva = 0;
  802b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b50:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802b57:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5a:	8b 50 08             	mov    0x8(%eax),%edx
  802b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b60:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802b63:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b67:	75 17                	jne    802b80 <insert_sorted_with_merge_freeList+0x50c>
  802b69:	83 ec 04             	sub    $0x4,%esp
  802b6c:	68 d0 38 80 00       	push   $0x8038d0
  802b71:	68 5b 01 00 00       	push   $0x15b
  802b76:	68 f3 38 80 00       	push   $0x8038f3
  802b7b:	e8 04 03 00 00       	call   802e84 <_panic>
  802b80:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b86:	8b 45 08             	mov    0x8(%ebp),%eax
  802b89:	89 10                	mov    %edx,(%eax)
  802b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8e:	8b 00                	mov    (%eax),%eax
  802b90:	85 c0                	test   %eax,%eax
  802b92:	74 0d                	je     802ba1 <insert_sorted_with_merge_freeList+0x52d>
  802b94:	a1 48 41 80 00       	mov    0x804148,%eax
  802b99:	8b 55 08             	mov    0x8(%ebp),%edx
  802b9c:	89 50 04             	mov    %edx,0x4(%eax)
  802b9f:	eb 08                	jmp    802ba9 <insert_sorted_with_merge_freeList+0x535>
  802ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba4:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bac:	a3 48 41 80 00       	mov    %eax,0x804148
  802bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bbb:	a1 54 41 80 00       	mov    0x804154,%eax
  802bc0:	40                   	inc    %eax
  802bc1:	a3 54 41 80 00       	mov    %eax,0x804154
								break;
  802bc6:	e9 02 02 00 00       	jmp    802dcd <insert_sorted_with_merge_freeList+0x759>
							}
							else if ((blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  802bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bce:	8b 50 08             	mov    0x8(%eax),%edx
  802bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd4:	8b 40 0c             	mov    0xc(%eax),%eax
  802bd7:	01 c2                	add    %eax,%edx
  802bd9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bdc:	8b 40 08             	mov    0x8(%eax),%eax
  802bdf:	39 c2                	cmp    %eax,%edx
  802be1:	0f 85 ae 01 00 00    	jne    802d95 <insert_sorted_with_merge_freeList+0x721>
  802be7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bea:	8b 50 08             	mov    0x8(%eax),%edx
  802bed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf0:	8b 48 08             	mov    0x8(%eax),%ecx
  802bf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf6:	8b 40 0c             	mov    0xc(%eax),%eax
  802bf9:	01 c8                	add    %ecx,%eax
  802bfb:	39 c2                	cmp    %eax,%edx
  802bfd:	0f 85 92 01 00 00    	jne    802d95 <insert_sorted_with_merge_freeList+0x721>
							{
								blk_itr->size = blk_itr->size + blockToInsert->size + next->size;
  802c03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c06:	8b 50 0c             	mov    0xc(%eax),%edx
  802c09:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0c:	8b 40 0c             	mov    0xc(%eax),%eax
  802c0f:	01 c2                	add    %eax,%edx
  802c11:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c14:	8b 40 0c             	mov    0xc(%eax),%eax
  802c17:	01 c2                	add    %eax,%edx
  802c19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1c:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size = blockToInsert->sva=0;
  802c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c22:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802c29:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2c:	8b 50 08             	mov    0x8(%eax),%edx
  802c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c32:	89 50 0c             	mov    %edx,0xc(%eax)
								next->size = next->sva = 0;
  802c35:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c38:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802c3f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c42:	8b 50 08             	mov    0x8(%eax),%edx
  802c45:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c48:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_REMOVE(&FreeMemBlocksList, next);
  802c4b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802c4f:	75 17                	jne    802c68 <insert_sorted_with_merge_freeList+0x5f4>
  802c51:	83 ec 04             	sub    $0x4,%esp
  802c54:	68 9b 39 80 00       	push   $0x80399b
  802c59:	68 63 01 00 00       	push   $0x163
  802c5e:	68 f3 38 80 00       	push   $0x8038f3
  802c63:	e8 1c 02 00 00       	call   802e84 <_panic>
  802c68:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c6b:	8b 00                	mov    (%eax),%eax
  802c6d:	85 c0                	test   %eax,%eax
  802c6f:	74 10                	je     802c81 <insert_sorted_with_merge_freeList+0x60d>
  802c71:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c74:	8b 00                	mov    (%eax),%eax
  802c76:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c79:	8b 52 04             	mov    0x4(%edx),%edx
  802c7c:	89 50 04             	mov    %edx,0x4(%eax)
  802c7f:	eb 0b                	jmp    802c8c <insert_sorted_with_merge_freeList+0x618>
  802c81:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c84:	8b 40 04             	mov    0x4(%eax),%eax
  802c87:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c8c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c8f:	8b 40 04             	mov    0x4(%eax),%eax
  802c92:	85 c0                	test   %eax,%eax
  802c94:	74 0f                	je     802ca5 <insert_sorted_with_merge_freeList+0x631>
  802c96:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c99:	8b 40 04             	mov    0x4(%eax),%eax
  802c9c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c9f:	8b 12                	mov    (%edx),%edx
  802ca1:	89 10                	mov    %edx,(%eax)
  802ca3:	eb 0a                	jmp    802caf <insert_sorted_with_merge_freeList+0x63b>
  802ca5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ca8:	8b 00                	mov    (%eax),%eax
  802caa:	a3 38 41 80 00       	mov    %eax,0x804138
  802caf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cb2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cb8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cbb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cc2:	a1 44 41 80 00       	mov    0x804144,%eax
  802cc7:	48                   	dec    %eax
  802cc8:	a3 44 41 80 00       	mov    %eax,0x804144
								LIST_INSERT_HEAD(&AvailableMemBlocksList, next );
  802ccd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802cd1:	75 17                	jne    802cea <insert_sorted_with_merge_freeList+0x676>
  802cd3:	83 ec 04             	sub    $0x4,%esp
  802cd6:	68 d0 38 80 00       	push   $0x8038d0
  802cdb:	68 64 01 00 00       	push   $0x164
  802ce0:	68 f3 38 80 00       	push   $0x8038f3
  802ce5:	e8 9a 01 00 00       	call   802e84 <_panic>
  802cea:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802cf0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cf3:	89 10                	mov    %edx,(%eax)
  802cf5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cf8:	8b 00                	mov    (%eax),%eax
  802cfa:	85 c0                	test   %eax,%eax
  802cfc:	74 0d                	je     802d0b <insert_sorted_with_merge_freeList+0x697>
  802cfe:	a1 48 41 80 00       	mov    0x804148,%eax
  802d03:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d06:	89 50 04             	mov    %edx,0x4(%eax)
  802d09:	eb 08                	jmp    802d13 <insert_sorted_with_merge_freeList+0x69f>
  802d0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d0e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d13:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d16:	a3 48 41 80 00       	mov    %eax,0x804148
  802d1b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d1e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d25:	a1 54 41 80 00       	mov    0x804154,%eax
  802d2a:	40                   	inc    %eax
  802d2b:	a3 54 41 80 00       	mov    %eax,0x804154
							    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802d30:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d34:	75 17                	jne    802d4d <insert_sorted_with_merge_freeList+0x6d9>
  802d36:	83 ec 04             	sub    $0x4,%esp
  802d39:	68 d0 38 80 00       	push   $0x8038d0
  802d3e:	68 65 01 00 00       	push   $0x165
  802d43:	68 f3 38 80 00       	push   $0x8038f3
  802d48:	e8 37 01 00 00       	call   802e84 <_panic>
  802d4d:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d53:	8b 45 08             	mov    0x8(%ebp),%eax
  802d56:	89 10                	mov    %edx,(%eax)
  802d58:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5b:	8b 00                	mov    (%eax),%eax
  802d5d:	85 c0                	test   %eax,%eax
  802d5f:	74 0d                	je     802d6e <insert_sorted_with_merge_freeList+0x6fa>
  802d61:	a1 48 41 80 00       	mov    0x804148,%eax
  802d66:	8b 55 08             	mov    0x8(%ebp),%edx
  802d69:	89 50 04             	mov    %edx,0x4(%eax)
  802d6c:	eb 08                	jmp    802d76 <insert_sorted_with_merge_freeList+0x702>
  802d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d71:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d76:	8b 45 08             	mov    0x8(%ebp),%eax
  802d79:	a3 48 41 80 00       	mov    %eax,0x804148
  802d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d81:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d88:	a1 54 41 80 00       	mov    0x804154,%eax
  802d8d:	40                   	inc    %eax
  802d8e:	a3 54 41 80 00       	mov    %eax,0x804154
								break;
  802d93:	eb 38                	jmp    802dcd <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  802d95:	a1 40 41 80 00       	mov    0x804140,%eax
  802d9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d9d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802da1:	74 07                	je     802daa <insert_sorted_with_merge_freeList+0x736>
  802da3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da6:	8b 00                	mov    (%eax),%eax
  802da8:	eb 05                	jmp    802daf <insert_sorted_with_merge_freeList+0x73b>
  802daa:	b8 00 00 00 00       	mov    $0x0,%eax
  802daf:	a3 40 41 80 00       	mov    %eax,0x804140
  802db4:	a1 40 41 80 00       	mov    0x804140,%eax
  802db9:	85 c0                	test   %eax,%eax
  802dbb:	0f 85 a7 fb ff ff    	jne    802968 <insert_sorted_with_merge_freeList+0x2f4>
  802dc1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dc5:	0f 85 9d fb ff ff    	jne    802968 <insert_sorted_with_merge_freeList+0x2f4>
						}
				}
        }

}
}
  802dcb:	eb 00                	jmp    802dcd <insert_sorted_with_merge_freeList+0x759>
  802dcd:	90                   	nop
  802dce:	c9                   	leave  
  802dcf:	c3                   	ret    

00802dd0 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  802dd0:	55                   	push   %ebp
  802dd1:	89 e5                	mov    %esp,%ebp
  802dd3:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  802dd6:	8b 55 08             	mov    0x8(%ebp),%edx
  802dd9:	89 d0                	mov    %edx,%eax
  802ddb:	c1 e0 02             	shl    $0x2,%eax
  802dde:	01 d0                	add    %edx,%eax
  802de0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802de7:	01 d0                	add    %edx,%eax
  802de9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802df0:	01 d0                	add    %edx,%eax
  802df2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802df9:	01 d0                	add    %edx,%eax
  802dfb:	c1 e0 04             	shl    $0x4,%eax
  802dfe:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  802e01:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  802e08:	8d 45 e8             	lea    -0x18(%ebp),%eax
  802e0b:	83 ec 0c             	sub    $0xc,%esp
  802e0e:	50                   	push   %eax
  802e0f:	e8 ee eb ff ff       	call   801a02 <sys_get_virtual_time>
  802e14:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  802e17:	eb 41                	jmp    802e5a <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  802e19:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802e1c:	83 ec 0c             	sub    $0xc,%esp
  802e1f:	50                   	push   %eax
  802e20:	e8 dd eb ff ff       	call   801a02 <sys_get_virtual_time>
  802e25:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  802e28:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e2b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e2e:	29 c2                	sub    %eax,%edx
  802e30:	89 d0                	mov    %edx,%eax
  802e32:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  802e35:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e3b:	89 d1                	mov    %edx,%ecx
  802e3d:	29 c1                	sub    %eax,%ecx
  802e3f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802e42:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e45:	39 c2                	cmp    %eax,%edx
  802e47:	0f 97 c0             	seta   %al
  802e4a:	0f b6 c0             	movzbl %al,%eax
  802e4d:	29 c1                	sub    %eax,%ecx
  802e4f:	89 c8                	mov    %ecx,%eax
  802e51:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  802e54:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802e57:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  802e5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802e60:	72 b7                	jb     802e19 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  802e62:	90                   	nop
  802e63:	c9                   	leave  
  802e64:	c3                   	ret    

00802e65 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  802e65:	55                   	push   %ebp
  802e66:	89 e5                	mov    %esp,%ebp
  802e68:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  802e6b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  802e72:	eb 03                	jmp    802e77 <busy_wait+0x12>
  802e74:	ff 45 fc             	incl   -0x4(%ebp)
  802e77:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802e7a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e7d:	72 f5                	jb     802e74 <busy_wait+0xf>
	return i;
  802e7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802e82:	c9                   	leave  
  802e83:	c3                   	ret    

00802e84 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  802e84:	55                   	push   %ebp
  802e85:	89 e5                	mov    %esp,%ebp
  802e87:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  802e8a:	8d 45 10             	lea    0x10(%ebp),%eax
  802e8d:	83 c0 04             	add    $0x4,%eax
  802e90:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  802e93:	a1 5c 41 80 00       	mov    0x80415c,%eax
  802e98:	85 c0                	test   %eax,%eax
  802e9a:	74 16                	je     802eb2 <_panic+0x2e>
		cprintf("%s: ", argv0);
  802e9c:	a1 5c 41 80 00       	mov    0x80415c,%eax
  802ea1:	83 ec 08             	sub    $0x8,%esp
  802ea4:	50                   	push   %eax
  802ea5:	68 ec 39 80 00       	push   $0x8039ec
  802eaa:	e8 cd d4 ff ff       	call   80037c <cprintf>
  802eaf:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  802eb2:	a1 00 40 80 00       	mov    0x804000,%eax
  802eb7:	ff 75 0c             	pushl  0xc(%ebp)
  802eba:	ff 75 08             	pushl  0x8(%ebp)
  802ebd:	50                   	push   %eax
  802ebe:	68 f1 39 80 00       	push   $0x8039f1
  802ec3:	e8 b4 d4 ff ff       	call   80037c <cprintf>
  802ec8:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  802ecb:	8b 45 10             	mov    0x10(%ebp),%eax
  802ece:	83 ec 08             	sub    $0x8,%esp
  802ed1:	ff 75 f4             	pushl  -0xc(%ebp)
  802ed4:	50                   	push   %eax
  802ed5:	e8 37 d4 ff ff       	call   800311 <vcprintf>
  802eda:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  802edd:	83 ec 08             	sub    $0x8,%esp
  802ee0:	6a 00                	push   $0x0
  802ee2:	68 0d 3a 80 00       	push   $0x803a0d
  802ee7:	e8 25 d4 ff ff       	call   800311 <vcprintf>
  802eec:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  802eef:	e8 a6 d3 ff ff       	call   80029a <exit>

	// should not return here
	while (1) ;
  802ef4:	eb fe                	jmp    802ef4 <_panic+0x70>

00802ef6 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  802ef6:	55                   	push   %ebp
  802ef7:	89 e5                	mov    %esp,%ebp
  802ef9:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  802efc:	a1 20 40 80 00       	mov    0x804020,%eax
  802f01:	8b 50 74             	mov    0x74(%eax),%edx
  802f04:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f07:	39 c2                	cmp    %eax,%edx
  802f09:	74 14                	je     802f1f <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  802f0b:	83 ec 04             	sub    $0x4,%esp
  802f0e:	68 10 3a 80 00       	push   $0x803a10
  802f13:	6a 26                	push   $0x26
  802f15:	68 5c 3a 80 00       	push   $0x803a5c
  802f1a:	e8 65 ff ff ff       	call   802e84 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  802f1f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  802f26:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802f2d:	e9 c2 00 00 00       	jmp    802ff4 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  802f32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f35:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3f:	01 d0                	add    %edx,%eax
  802f41:	8b 00                	mov    (%eax),%eax
  802f43:	85 c0                	test   %eax,%eax
  802f45:	75 08                	jne    802f4f <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  802f47:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  802f4a:	e9 a2 00 00 00       	jmp    802ff1 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  802f4f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802f56:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802f5d:	eb 69                	jmp    802fc8 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  802f5f:	a1 20 40 80 00       	mov    0x804020,%eax
  802f64:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  802f6a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f6d:	89 d0                	mov    %edx,%eax
  802f6f:	01 c0                	add    %eax,%eax
  802f71:	01 d0                	add    %edx,%eax
  802f73:	c1 e0 03             	shl    $0x3,%eax
  802f76:	01 c8                	add    %ecx,%eax
  802f78:	8a 40 04             	mov    0x4(%eax),%al
  802f7b:	84 c0                	test   %al,%al
  802f7d:	75 46                	jne    802fc5 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  802f7f:	a1 20 40 80 00       	mov    0x804020,%eax
  802f84:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  802f8a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f8d:	89 d0                	mov    %edx,%eax
  802f8f:	01 c0                	add    %eax,%eax
  802f91:	01 d0                	add    %edx,%eax
  802f93:	c1 e0 03             	shl    $0x3,%eax
  802f96:	01 c8                	add    %ecx,%eax
  802f98:	8b 00                	mov    (%eax),%eax
  802f9a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802f9d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fa0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802fa5:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  802fa7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802faa:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  802fb1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb4:	01 c8                	add    %ecx,%eax
  802fb6:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  802fb8:	39 c2                	cmp    %eax,%edx
  802fba:	75 09                	jne    802fc5 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  802fbc:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  802fc3:	eb 12                	jmp    802fd7 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802fc5:	ff 45 e8             	incl   -0x18(%ebp)
  802fc8:	a1 20 40 80 00       	mov    0x804020,%eax
  802fcd:	8b 50 74             	mov    0x74(%eax),%edx
  802fd0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fd3:	39 c2                	cmp    %eax,%edx
  802fd5:	77 88                	ja     802f5f <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  802fd7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802fdb:	75 14                	jne    802ff1 <CheckWSWithoutLastIndex+0xfb>
			panic(
  802fdd:	83 ec 04             	sub    $0x4,%esp
  802fe0:	68 68 3a 80 00       	push   $0x803a68
  802fe5:	6a 3a                	push   $0x3a
  802fe7:	68 5c 3a 80 00       	push   $0x803a5c
  802fec:	e8 93 fe ff ff       	call   802e84 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  802ff1:	ff 45 f0             	incl   -0x10(%ebp)
  802ff4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ff7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802ffa:	0f 8c 32 ff ff ff    	jl     802f32 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803000:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803007:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80300e:	eb 26                	jmp    803036 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803010:	a1 20 40 80 00       	mov    0x804020,%eax
  803015:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80301b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80301e:	89 d0                	mov    %edx,%eax
  803020:	01 c0                	add    %eax,%eax
  803022:	01 d0                	add    %edx,%eax
  803024:	c1 e0 03             	shl    $0x3,%eax
  803027:	01 c8                	add    %ecx,%eax
  803029:	8a 40 04             	mov    0x4(%eax),%al
  80302c:	3c 01                	cmp    $0x1,%al
  80302e:	75 03                	jne    803033 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  803030:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803033:	ff 45 e0             	incl   -0x20(%ebp)
  803036:	a1 20 40 80 00       	mov    0x804020,%eax
  80303b:	8b 50 74             	mov    0x74(%eax),%edx
  80303e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803041:	39 c2                	cmp    %eax,%edx
  803043:	77 cb                	ja     803010 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803045:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803048:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80304b:	74 14                	je     803061 <CheckWSWithoutLastIndex+0x16b>
		panic(
  80304d:	83 ec 04             	sub    $0x4,%esp
  803050:	68 bc 3a 80 00       	push   $0x803abc
  803055:	6a 44                	push   $0x44
  803057:	68 5c 3a 80 00       	push   $0x803a5c
  80305c:	e8 23 fe ff ff       	call   802e84 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803061:	90                   	nop
  803062:	c9                   	leave  
  803063:	c3                   	ret    

00803064 <__udivdi3>:
  803064:	55                   	push   %ebp
  803065:	57                   	push   %edi
  803066:	56                   	push   %esi
  803067:	53                   	push   %ebx
  803068:	83 ec 1c             	sub    $0x1c,%esp
  80306b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80306f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803073:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803077:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80307b:	89 ca                	mov    %ecx,%edx
  80307d:	89 f8                	mov    %edi,%eax
  80307f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803083:	85 f6                	test   %esi,%esi
  803085:	75 2d                	jne    8030b4 <__udivdi3+0x50>
  803087:	39 cf                	cmp    %ecx,%edi
  803089:	77 65                	ja     8030f0 <__udivdi3+0x8c>
  80308b:	89 fd                	mov    %edi,%ebp
  80308d:	85 ff                	test   %edi,%edi
  80308f:	75 0b                	jne    80309c <__udivdi3+0x38>
  803091:	b8 01 00 00 00       	mov    $0x1,%eax
  803096:	31 d2                	xor    %edx,%edx
  803098:	f7 f7                	div    %edi
  80309a:	89 c5                	mov    %eax,%ebp
  80309c:	31 d2                	xor    %edx,%edx
  80309e:	89 c8                	mov    %ecx,%eax
  8030a0:	f7 f5                	div    %ebp
  8030a2:	89 c1                	mov    %eax,%ecx
  8030a4:	89 d8                	mov    %ebx,%eax
  8030a6:	f7 f5                	div    %ebp
  8030a8:	89 cf                	mov    %ecx,%edi
  8030aa:	89 fa                	mov    %edi,%edx
  8030ac:	83 c4 1c             	add    $0x1c,%esp
  8030af:	5b                   	pop    %ebx
  8030b0:	5e                   	pop    %esi
  8030b1:	5f                   	pop    %edi
  8030b2:	5d                   	pop    %ebp
  8030b3:	c3                   	ret    
  8030b4:	39 ce                	cmp    %ecx,%esi
  8030b6:	77 28                	ja     8030e0 <__udivdi3+0x7c>
  8030b8:	0f bd fe             	bsr    %esi,%edi
  8030bb:	83 f7 1f             	xor    $0x1f,%edi
  8030be:	75 40                	jne    803100 <__udivdi3+0x9c>
  8030c0:	39 ce                	cmp    %ecx,%esi
  8030c2:	72 0a                	jb     8030ce <__udivdi3+0x6a>
  8030c4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8030c8:	0f 87 9e 00 00 00    	ja     80316c <__udivdi3+0x108>
  8030ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8030d3:	89 fa                	mov    %edi,%edx
  8030d5:	83 c4 1c             	add    $0x1c,%esp
  8030d8:	5b                   	pop    %ebx
  8030d9:	5e                   	pop    %esi
  8030da:	5f                   	pop    %edi
  8030db:	5d                   	pop    %ebp
  8030dc:	c3                   	ret    
  8030dd:	8d 76 00             	lea    0x0(%esi),%esi
  8030e0:	31 ff                	xor    %edi,%edi
  8030e2:	31 c0                	xor    %eax,%eax
  8030e4:	89 fa                	mov    %edi,%edx
  8030e6:	83 c4 1c             	add    $0x1c,%esp
  8030e9:	5b                   	pop    %ebx
  8030ea:	5e                   	pop    %esi
  8030eb:	5f                   	pop    %edi
  8030ec:	5d                   	pop    %ebp
  8030ed:	c3                   	ret    
  8030ee:	66 90                	xchg   %ax,%ax
  8030f0:	89 d8                	mov    %ebx,%eax
  8030f2:	f7 f7                	div    %edi
  8030f4:	31 ff                	xor    %edi,%edi
  8030f6:	89 fa                	mov    %edi,%edx
  8030f8:	83 c4 1c             	add    $0x1c,%esp
  8030fb:	5b                   	pop    %ebx
  8030fc:	5e                   	pop    %esi
  8030fd:	5f                   	pop    %edi
  8030fe:	5d                   	pop    %ebp
  8030ff:	c3                   	ret    
  803100:	bd 20 00 00 00       	mov    $0x20,%ebp
  803105:	89 eb                	mov    %ebp,%ebx
  803107:	29 fb                	sub    %edi,%ebx
  803109:	89 f9                	mov    %edi,%ecx
  80310b:	d3 e6                	shl    %cl,%esi
  80310d:	89 c5                	mov    %eax,%ebp
  80310f:	88 d9                	mov    %bl,%cl
  803111:	d3 ed                	shr    %cl,%ebp
  803113:	89 e9                	mov    %ebp,%ecx
  803115:	09 f1                	or     %esi,%ecx
  803117:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80311b:	89 f9                	mov    %edi,%ecx
  80311d:	d3 e0                	shl    %cl,%eax
  80311f:	89 c5                	mov    %eax,%ebp
  803121:	89 d6                	mov    %edx,%esi
  803123:	88 d9                	mov    %bl,%cl
  803125:	d3 ee                	shr    %cl,%esi
  803127:	89 f9                	mov    %edi,%ecx
  803129:	d3 e2                	shl    %cl,%edx
  80312b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80312f:	88 d9                	mov    %bl,%cl
  803131:	d3 e8                	shr    %cl,%eax
  803133:	09 c2                	or     %eax,%edx
  803135:	89 d0                	mov    %edx,%eax
  803137:	89 f2                	mov    %esi,%edx
  803139:	f7 74 24 0c          	divl   0xc(%esp)
  80313d:	89 d6                	mov    %edx,%esi
  80313f:	89 c3                	mov    %eax,%ebx
  803141:	f7 e5                	mul    %ebp
  803143:	39 d6                	cmp    %edx,%esi
  803145:	72 19                	jb     803160 <__udivdi3+0xfc>
  803147:	74 0b                	je     803154 <__udivdi3+0xf0>
  803149:	89 d8                	mov    %ebx,%eax
  80314b:	31 ff                	xor    %edi,%edi
  80314d:	e9 58 ff ff ff       	jmp    8030aa <__udivdi3+0x46>
  803152:	66 90                	xchg   %ax,%ax
  803154:	8b 54 24 08          	mov    0x8(%esp),%edx
  803158:	89 f9                	mov    %edi,%ecx
  80315a:	d3 e2                	shl    %cl,%edx
  80315c:	39 c2                	cmp    %eax,%edx
  80315e:	73 e9                	jae    803149 <__udivdi3+0xe5>
  803160:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803163:	31 ff                	xor    %edi,%edi
  803165:	e9 40 ff ff ff       	jmp    8030aa <__udivdi3+0x46>
  80316a:	66 90                	xchg   %ax,%ax
  80316c:	31 c0                	xor    %eax,%eax
  80316e:	e9 37 ff ff ff       	jmp    8030aa <__udivdi3+0x46>
  803173:	90                   	nop

00803174 <__umoddi3>:
  803174:	55                   	push   %ebp
  803175:	57                   	push   %edi
  803176:	56                   	push   %esi
  803177:	53                   	push   %ebx
  803178:	83 ec 1c             	sub    $0x1c,%esp
  80317b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80317f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803183:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803187:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80318b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80318f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803193:	89 f3                	mov    %esi,%ebx
  803195:	89 fa                	mov    %edi,%edx
  803197:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80319b:	89 34 24             	mov    %esi,(%esp)
  80319e:	85 c0                	test   %eax,%eax
  8031a0:	75 1a                	jne    8031bc <__umoddi3+0x48>
  8031a2:	39 f7                	cmp    %esi,%edi
  8031a4:	0f 86 a2 00 00 00    	jbe    80324c <__umoddi3+0xd8>
  8031aa:	89 c8                	mov    %ecx,%eax
  8031ac:	89 f2                	mov    %esi,%edx
  8031ae:	f7 f7                	div    %edi
  8031b0:	89 d0                	mov    %edx,%eax
  8031b2:	31 d2                	xor    %edx,%edx
  8031b4:	83 c4 1c             	add    $0x1c,%esp
  8031b7:	5b                   	pop    %ebx
  8031b8:	5e                   	pop    %esi
  8031b9:	5f                   	pop    %edi
  8031ba:	5d                   	pop    %ebp
  8031bb:	c3                   	ret    
  8031bc:	39 f0                	cmp    %esi,%eax
  8031be:	0f 87 ac 00 00 00    	ja     803270 <__umoddi3+0xfc>
  8031c4:	0f bd e8             	bsr    %eax,%ebp
  8031c7:	83 f5 1f             	xor    $0x1f,%ebp
  8031ca:	0f 84 ac 00 00 00    	je     80327c <__umoddi3+0x108>
  8031d0:	bf 20 00 00 00       	mov    $0x20,%edi
  8031d5:	29 ef                	sub    %ebp,%edi
  8031d7:	89 fe                	mov    %edi,%esi
  8031d9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8031dd:	89 e9                	mov    %ebp,%ecx
  8031df:	d3 e0                	shl    %cl,%eax
  8031e1:	89 d7                	mov    %edx,%edi
  8031e3:	89 f1                	mov    %esi,%ecx
  8031e5:	d3 ef                	shr    %cl,%edi
  8031e7:	09 c7                	or     %eax,%edi
  8031e9:	89 e9                	mov    %ebp,%ecx
  8031eb:	d3 e2                	shl    %cl,%edx
  8031ed:	89 14 24             	mov    %edx,(%esp)
  8031f0:	89 d8                	mov    %ebx,%eax
  8031f2:	d3 e0                	shl    %cl,%eax
  8031f4:	89 c2                	mov    %eax,%edx
  8031f6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031fa:	d3 e0                	shl    %cl,%eax
  8031fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  803200:	8b 44 24 08          	mov    0x8(%esp),%eax
  803204:	89 f1                	mov    %esi,%ecx
  803206:	d3 e8                	shr    %cl,%eax
  803208:	09 d0                	or     %edx,%eax
  80320a:	d3 eb                	shr    %cl,%ebx
  80320c:	89 da                	mov    %ebx,%edx
  80320e:	f7 f7                	div    %edi
  803210:	89 d3                	mov    %edx,%ebx
  803212:	f7 24 24             	mull   (%esp)
  803215:	89 c6                	mov    %eax,%esi
  803217:	89 d1                	mov    %edx,%ecx
  803219:	39 d3                	cmp    %edx,%ebx
  80321b:	0f 82 87 00 00 00    	jb     8032a8 <__umoddi3+0x134>
  803221:	0f 84 91 00 00 00    	je     8032b8 <__umoddi3+0x144>
  803227:	8b 54 24 04          	mov    0x4(%esp),%edx
  80322b:	29 f2                	sub    %esi,%edx
  80322d:	19 cb                	sbb    %ecx,%ebx
  80322f:	89 d8                	mov    %ebx,%eax
  803231:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803235:	d3 e0                	shl    %cl,%eax
  803237:	89 e9                	mov    %ebp,%ecx
  803239:	d3 ea                	shr    %cl,%edx
  80323b:	09 d0                	or     %edx,%eax
  80323d:	89 e9                	mov    %ebp,%ecx
  80323f:	d3 eb                	shr    %cl,%ebx
  803241:	89 da                	mov    %ebx,%edx
  803243:	83 c4 1c             	add    $0x1c,%esp
  803246:	5b                   	pop    %ebx
  803247:	5e                   	pop    %esi
  803248:	5f                   	pop    %edi
  803249:	5d                   	pop    %ebp
  80324a:	c3                   	ret    
  80324b:	90                   	nop
  80324c:	89 fd                	mov    %edi,%ebp
  80324e:	85 ff                	test   %edi,%edi
  803250:	75 0b                	jne    80325d <__umoddi3+0xe9>
  803252:	b8 01 00 00 00       	mov    $0x1,%eax
  803257:	31 d2                	xor    %edx,%edx
  803259:	f7 f7                	div    %edi
  80325b:	89 c5                	mov    %eax,%ebp
  80325d:	89 f0                	mov    %esi,%eax
  80325f:	31 d2                	xor    %edx,%edx
  803261:	f7 f5                	div    %ebp
  803263:	89 c8                	mov    %ecx,%eax
  803265:	f7 f5                	div    %ebp
  803267:	89 d0                	mov    %edx,%eax
  803269:	e9 44 ff ff ff       	jmp    8031b2 <__umoddi3+0x3e>
  80326e:	66 90                	xchg   %ax,%ax
  803270:	89 c8                	mov    %ecx,%eax
  803272:	89 f2                	mov    %esi,%edx
  803274:	83 c4 1c             	add    $0x1c,%esp
  803277:	5b                   	pop    %ebx
  803278:	5e                   	pop    %esi
  803279:	5f                   	pop    %edi
  80327a:	5d                   	pop    %ebp
  80327b:	c3                   	ret    
  80327c:	3b 04 24             	cmp    (%esp),%eax
  80327f:	72 06                	jb     803287 <__umoddi3+0x113>
  803281:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803285:	77 0f                	ja     803296 <__umoddi3+0x122>
  803287:	89 f2                	mov    %esi,%edx
  803289:	29 f9                	sub    %edi,%ecx
  80328b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80328f:	89 14 24             	mov    %edx,(%esp)
  803292:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803296:	8b 44 24 04          	mov    0x4(%esp),%eax
  80329a:	8b 14 24             	mov    (%esp),%edx
  80329d:	83 c4 1c             	add    $0x1c,%esp
  8032a0:	5b                   	pop    %ebx
  8032a1:	5e                   	pop    %esi
  8032a2:	5f                   	pop    %edi
  8032a3:	5d                   	pop    %ebp
  8032a4:	c3                   	ret    
  8032a5:	8d 76 00             	lea    0x0(%esi),%esi
  8032a8:	2b 04 24             	sub    (%esp),%eax
  8032ab:	19 fa                	sbb    %edi,%edx
  8032ad:	89 d1                	mov    %edx,%ecx
  8032af:	89 c6                	mov    %eax,%esi
  8032b1:	e9 71 ff ff ff       	jmp    803227 <__umoddi3+0xb3>
  8032b6:	66 90                	xchg   %ax,%ax
  8032b8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8032bc:	72 ea                	jb     8032a8 <__umoddi3+0x134>
  8032be:	89 d9                	mov    %ebx,%ecx
  8032c0:	e9 62 ff ff ff       	jmp    803227 <__umoddi3+0xb3>
