
obj/user/MidTermEx_ProcessB:     file format elf32-i386


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
  800031:	e8 35 01 00 00       	call   80016b <libmain>
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
  80003e:	e8 8b 19 00 00       	call   8019ce <sys_getparentenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int delay;

	/*[1] GET SHARED VARIABLE, SEMAPHORE SEL, check-finishing counter*/
	int *X = sget(parentenvID, "X") ;
  800046:	83 ec 08             	sub    $0x8,%esp
  800049:	68 e0 32 80 00       	push   $0x8032e0
  80004e:	ff 75 f4             	pushl  -0xc(%ebp)
  800051:	e8 49 14 00 00       	call   80149f <sget>
  800056:	83 c4 10             	add    $0x10,%esp
  800059:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int *useSem = sget(parentenvID, "useSem") ;
  80005c:	83 ec 08             	sub    $0x8,%esp
  80005f:	68 e2 32 80 00       	push   $0x8032e2
  800064:	ff 75 f4             	pushl  -0xc(%ebp)
  800067:	e8 33 14 00 00       	call   80149f <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int *finishedCount = sget(parentenvID, "finishedCount") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 e9 32 80 00       	push   $0x8032e9
  80007a:	ff 75 f4             	pushl  -0xc(%ebp)
  80007d:	e8 1d 14 00 00       	call   80149f <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	/*[2] DO THE JOB*/
	int Z ;
	if (*useSem == 1)
  800088:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80008b:	8b 00                	mov    (%eax),%eax
  80008d:	83 f8 01             	cmp    $0x1,%eax
  800090:	75 13                	jne    8000a5 <_main+0x6d>
	{
		sys_waitSemaphore(parentenvID, "T") ;
  800092:	83 ec 08             	sub    $0x8,%esp
  800095:	68 f7 32 80 00       	push   $0x8032f7
  80009a:	ff 75 f4             	pushl  -0xc(%ebp)
  80009d:	e8 cd 17 00 00       	call   80186f <sys_waitSemaphore>
  8000a2:	83 c4 10             	add    $0x10,%esp
	}

	//random delay
	delay = RAND(2000, 10000);
  8000a5:	8d 45 c8             	lea    -0x38(%ebp),%eax
  8000a8:	83 ec 0c             	sub    $0xc,%esp
  8000ab:	50                   	push   %eax
  8000ac:	e8 50 19 00 00       	call   801a01 <sys_get_virtual_time>
  8000b1:	83 c4 0c             	add    $0xc,%esp
  8000b4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8000b7:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  8000bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8000c1:	f7 f1                	div    %ecx
  8000c3:	89 d0                	mov    %edx,%eax
  8000c5:	05 d0 07 00 00       	add    $0x7d0,%eax
  8000ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	env_sleep(delay);
  8000cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000d0:	83 ec 0c             	sub    $0xc,%esp
  8000d3:	50                   	push   %eax
  8000d4:	e8 f6 2c 00 00       	call   802dcf <env_sleep>
  8000d9:	83 c4 10             	add    $0x10,%esp
//	cprintf("delay = %d\n", delay);

	Z = (*X) + 1 ;
  8000dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000df:	8b 00                	mov    (%eax),%eax
  8000e1:	40                   	inc    %eax
  8000e2:	89 45 e0             	mov    %eax,-0x20(%ebp)

	//random delay
	delay = RAND(2000, 10000);
  8000e5:	8d 45 d0             	lea    -0x30(%ebp),%eax
  8000e8:	83 ec 0c             	sub    $0xc,%esp
  8000eb:	50                   	push   %eax
  8000ec:	e8 10 19 00 00       	call   801a01 <sys_get_virtual_time>
  8000f1:	83 c4 0c             	add    $0xc,%esp
  8000f4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8000f7:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  8000fc:	ba 00 00 00 00       	mov    $0x0,%edx
  800101:	f7 f1                	div    %ecx
  800103:	89 d0                	mov    %edx,%eax
  800105:	05 d0 07 00 00       	add    $0x7d0,%eax
  80010a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	env_sleep(delay);
  80010d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800110:	83 ec 0c             	sub    $0xc,%esp
  800113:	50                   	push   %eax
  800114:	e8 b6 2c 00 00       	call   802dcf <env_sleep>
  800119:	83 c4 10             	add    $0x10,%esp
//	cprintf("delay = %d\n", delay);

	(*X) = Z ;
  80011c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80011f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800122:	89 10                	mov    %edx,(%eax)

	//random delay
	delay = RAND(2000, 10000);
  800124:	8d 45 d8             	lea    -0x28(%ebp),%eax
  800127:	83 ec 0c             	sub    $0xc,%esp
  80012a:	50                   	push   %eax
  80012b:	e8 d1 18 00 00       	call   801a01 <sys_get_virtual_time>
  800130:	83 c4 0c             	add    $0xc,%esp
  800133:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800136:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  80013b:	ba 00 00 00 00       	mov    $0x0,%edx
  800140:	f7 f1                	div    %ecx
  800142:	89 d0                	mov    %edx,%eax
  800144:	05 d0 07 00 00       	add    $0x7d0,%eax
  800149:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	env_sleep(delay);
  80014c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80014f:	83 ec 0c             	sub    $0xc,%esp
  800152:	50                   	push   %eax
  800153:	e8 77 2c 00 00       	call   802dcf <env_sleep>
  800158:	83 c4 10             	add    $0x10,%esp
//	cprintf("delay = %d\n", delay);

	/*[3] DECLARE FINISHING*/
	(*finishedCount)++ ;
  80015b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80015e:	8b 00                	mov    (%eax),%eax
  800160:	8d 50 01             	lea    0x1(%eax),%edx
  800163:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800166:	89 10                	mov    %edx,(%eax)

}
  800168:	90                   	nop
  800169:	c9                   	leave  
  80016a:	c3                   	ret    

0080016b <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80016b:	55                   	push   %ebp
  80016c:	89 e5                	mov    %esp,%ebp
  80016e:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800171:	e8 3f 18 00 00       	call   8019b5 <sys_getenvindex>
  800176:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800179:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80017c:	89 d0                	mov    %edx,%eax
  80017e:	c1 e0 03             	shl    $0x3,%eax
  800181:	01 d0                	add    %edx,%eax
  800183:	01 c0                	add    %eax,%eax
  800185:	01 d0                	add    %edx,%eax
  800187:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80018e:	01 d0                	add    %edx,%eax
  800190:	c1 e0 04             	shl    $0x4,%eax
  800193:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800198:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80019d:	a1 20 40 80 00       	mov    0x804020,%eax
  8001a2:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8001a8:	84 c0                	test   %al,%al
  8001aa:	74 0f                	je     8001bb <libmain+0x50>
		binaryname = myEnv->prog_name;
  8001ac:	a1 20 40 80 00       	mov    0x804020,%eax
  8001b1:	05 5c 05 00 00       	add    $0x55c,%eax
  8001b6:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001bb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001bf:	7e 0a                	jle    8001cb <libmain+0x60>
		binaryname = argv[0];
  8001c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001c4:	8b 00                	mov    (%eax),%eax
  8001c6:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8001cb:	83 ec 08             	sub    $0x8,%esp
  8001ce:	ff 75 0c             	pushl  0xc(%ebp)
  8001d1:	ff 75 08             	pushl  0x8(%ebp)
  8001d4:	e8 5f fe ff ff       	call   800038 <_main>
  8001d9:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001dc:	e8 e1 15 00 00       	call   8017c2 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001e1:	83 ec 0c             	sub    $0xc,%esp
  8001e4:	68 14 33 80 00       	push   $0x803314
  8001e9:	e8 8d 01 00 00       	call   80037b <cprintf>
  8001ee:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001f1:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f6:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8001fc:	a1 20 40 80 00       	mov    0x804020,%eax
  800201:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800207:	83 ec 04             	sub    $0x4,%esp
  80020a:	52                   	push   %edx
  80020b:	50                   	push   %eax
  80020c:	68 3c 33 80 00       	push   $0x80333c
  800211:	e8 65 01 00 00       	call   80037b <cprintf>
  800216:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800219:	a1 20 40 80 00       	mov    0x804020,%eax
  80021e:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800224:	a1 20 40 80 00       	mov    0x804020,%eax
  800229:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80022f:	a1 20 40 80 00       	mov    0x804020,%eax
  800234:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80023a:	51                   	push   %ecx
  80023b:	52                   	push   %edx
  80023c:	50                   	push   %eax
  80023d:	68 64 33 80 00       	push   $0x803364
  800242:	e8 34 01 00 00       	call   80037b <cprintf>
  800247:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80024a:	a1 20 40 80 00       	mov    0x804020,%eax
  80024f:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800255:	83 ec 08             	sub    $0x8,%esp
  800258:	50                   	push   %eax
  800259:	68 bc 33 80 00       	push   $0x8033bc
  80025e:	e8 18 01 00 00       	call   80037b <cprintf>
  800263:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800266:	83 ec 0c             	sub    $0xc,%esp
  800269:	68 14 33 80 00       	push   $0x803314
  80026e:	e8 08 01 00 00       	call   80037b <cprintf>
  800273:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800276:	e8 61 15 00 00       	call   8017dc <sys_enable_interrupt>

	// exit gracefully
	exit();
  80027b:	e8 19 00 00 00       	call   800299 <exit>
}
  800280:	90                   	nop
  800281:	c9                   	leave  
  800282:	c3                   	ret    

00800283 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800283:	55                   	push   %ebp
  800284:	89 e5                	mov    %esp,%ebp
  800286:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800289:	83 ec 0c             	sub    $0xc,%esp
  80028c:	6a 00                	push   $0x0
  80028e:	e8 ee 16 00 00       	call   801981 <sys_destroy_env>
  800293:	83 c4 10             	add    $0x10,%esp
}
  800296:	90                   	nop
  800297:	c9                   	leave  
  800298:	c3                   	ret    

00800299 <exit>:

void
exit(void)
{
  800299:	55                   	push   %ebp
  80029a:	89 e5                	mov    %esp,%ebp
  80029c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80029f:	e8 43 17 00 00       	call   8019e7 <sys_exit_env>
}
  8002a4:	90                   	nop
  8002a5:	c9                   	leave  
  8002a6:	c3                   	ret    

008002a7 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8002a7:	55                   	push   %ebp
  8002a8:	89 e5                	mov    %esp,%ebp
  8002aa:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8002ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002b0:	8b 00                	mov    (%eax),%eax
  8002b2:	8d 48 01             	lea    0x1(%eax),%ecx
  8002b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002b8:	89 0a                	mov    %ecx,(%edx)
  8002ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8002bd:	88 d1                	mov    %dl,%cl
  8002bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002c2:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8002c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002c9:	8b 00                	mov    (%eax),%eax
  8002cb:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002d0:	75 2c                	jne    8002fe <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8002d2:	a0 24 40 80 00       	mov    0x804024,%al
  8002d7:	0f b6 c0             	movzbl %al,%eax
  8002da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002dd:	8b 12                	mov    (%edx),%edx
  8002df:	89 d1                	mov    %edx,%ecx
  8002e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002e4:	83 c2 08             	add    $0x8,%edx
  8002e7:	83 ec 04             	sub    $0x4,%esp
  8002ea:	50                   	push   %eax
  8002eb:	51                   	push   %ecx
  8002ec:	52                   	push   %edx
  8002ed:	e8 22 13 00 00       	call   801614 <sys_cputs>
  8002f2:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8002f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8002fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800301:	8b 40 04             	mov    0x4(%eax),%eax
  800304:	8d 50 01             	lea    0x1(%eax),%edx
  800307:	8b 45 0c             	mov    0xc(%ebp),%eax
  80030a:	89 50 04             	mov    %edx,0x4(%eax)
}
  80030d:	90                   	nop
  80030e:	c9                   	leave  
  80030f:	c3                   	ret    

00800310 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800310:	55                   	push   %ebp
  800311:	89 e5                	mov    %esp,%ebp
  800313:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800319:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800320:	00 00 00 
	b.cnt = 0;
  800323:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80032a:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80032d:	ff 75 0c             	pushl  0xc(%ebp)
  800330:	ff 75 08             	pushl  0x8(%ebp)
  800333:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800339:	50                   	push   %eax
  80033a:	68 a7 02 80 00       	push   $0x8002a7
  80033f:	e8 11 02 00 00       	call   800555 <vprintfmt>
  800344:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800347:	a0 24 40 80 00       	mov    0x804024,%al
  80034c:	0f b6 c0             	movzbl %al,%eax
  80034f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800355:	83 ec 04             	sub    $0x4,%esp
  800358:	50                   	push   %eax
  800359:	52                   	push   %edx
  80035a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800360:	83 c0 08             	add    $0x8,%eax
  800363:	50                   	push   %eax
  800364:	e8 ab 12 00 00       	call   801614 <sys_cputs>
  800369:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80036c:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800373:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800379:	c9                   	leave  
  80037a:	c3                   	ret    

0080037b <cprintf>:

int cprintf(const char *fmt, ...) {
  80037b:	55                   	push   %ebp
  80037c:	89 e5                	mov    %esp,%ebp
  80037e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800381:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800388:	8d 45 0c             	lea    0xc(%ebp),%eax
  80038b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80038e:	8b 45 08             	mov    0x8(%ebp),%eax
  800391:	83 ec 08             	sub    $0x8,%esp
  800394:	ff 75 f4             	pushl  -0xc(%ebp)
  800397:	50                   	push   %eax
  800398:	e8 73 ff ff ff       	call   800310 <vcprintf>
  80039d:	83 c4 10             	add    $0x10,%esp
  8003a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8003a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003a6:	c9                   	leave  
  8003a7:	c3                   	ret    

008003a8 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8003a8:	55                   	push   %ebp
  8003a9:	89 e5                	mov    %esp,%ebp
  8003ab:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8003ae:	e8 0f 14 00 00       	call   8017c2 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8003b3:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8003b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bc:	83 ec 08             	sub    $0x8,%esp
  8003bf:	ff 75 f4             	pushl  -0xc(%ebp)
  8003c2:	50                   	push   %eax
  8003c3:	e8 48 ff ff ff       	call   800310 <vcprintf>
  8003c8:	83 c4 10             	add    $0x10,%esp
  8003cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8003ce:	e8 09 14 00 00       	call   8017dc <sys_enable_interrupt>
	return cnt;
  8003d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003d6:	c9                   	leave  
  8003d7:	c3                   	ret    

008003d8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003d8:	55                   	push   %ebp
  8003d9:	89 e5                	mov    %esp,%ebp
  8003db:	53                   	push   %ebx
  8003dc:	83 ec 14             	sub    $0x14,%esp
  8003df:	8b 45 10             	mov    0x10(%ebp),%eax
  8003e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8003e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003eb:	8b 45 18             	mov    0x18(%ebp),%eax
  8003ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8003f3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003f6:	77 55                	ja     80044d <printnum+0x75>
  8003f8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003fb:	72 05                	jb     800402 <printnum+0x2a>
  8003fd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800400:	77 4b                	ja     80044d <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800402:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800405:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800408:	8b 45 18             	mov    0x18(%ebp),%eax
  80040b:	ba 00 00 00 00       	mov    $0x0,%edx
  800410:	52                   	push   %edx
  800411:	50                   	push   %eax
  800412:	ff 75 f4             	pushl  -0xc(%ebp)
  800415:	ff 75 f0             	pushl  -0x10(%ebp)
  800418:	e8 47 2c 00 00       	call   803064 <__udivdi3>
  80041d:	83 c4 10             	add    $0x10,%esp
  800420:	83 ec 04             	sub    $0x4,%esp
  800423:	ff 75 20             	pushl  0x20(%ebp)
  800426:	53                   	push   %ebx
  800427:	ff 75 18             	pushl  0x18(%ebp)
  80042a:	52                   	push   %edx
  80042b:	50                   	push   %eax
  80042c:	ff 75 0c             	pushl  0xc(%ebp)
  80042f:	ff 75 08             	pushl  0x8(%ebp)
  800432:	e8 a1 ff ff ff       	call   8003d8 <printnum>
  800437:	83 c4 20             	add    $0x20,%esp
  80043a:	eb 1a                	jmp    800456 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80043c:	83 ec 08             	sub    $0x8,%esp
  80043f:	ff 75 0c             	pushl  0xc(%ebp)
  800442:	ff 75 20             	pushl  0x20(%ebp)
  800445:	8b 45 08             	mov    0x8(%ebp),%eax
  800448:	ff d0                	call   *%eax
  80044a:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80044d:	ff 4d 1c             	decl   0x1c(%ebp)
  800450:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800454:	7f e6                	jg     80043c <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800456:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800459:	bb 00 00 00 00       	mov    $0x0,%ebx
  80045e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800461:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800464:	53                   	push   %ebx
  800465:	51                   	push   %ecx
  800466:	52                   	push   %edx
  800467:	50                   	push   %eax
  800468:	e8 07 2d 00 00       	call   803174 <__umoddi3>
  80046d:	83 c4 10             	add    $0x10,%esp
  800470:	05 f4 35 80 00       	add    $0x8035f4,%eax
  800475:	8a 00                	mov    (%eax),%al
  800477:	0f be c0             	movsbl %al,%eax
  80047a:	83 ec 08             	sub    $0x8,%esp
  80047d:	ff 75 0c             	pushl  0xc(%ebp)
  800480:	50                   	push   %eax
  800481:	8b 45 08             	mov    0x8(%ebp),%eax
  800484:	ff d0                	call   *%eax
  800486:	83 c4 10             	add    $0x10,%esp
}
  800489:	90                   	nop
  80048a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80048d:	c9                   	leave  
  80048e:	c3                   	ret    

0080048f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80048f:	55                   	push   %ebp
  800490:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800492:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800496:	7e 1c                	jle    8004b4 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800498:	8b 45 08             	mov    0x8(%ebp),%eax
  80049b:	8b 00                	mov    (%eax),%eax
  80049d:	8d 50 08             	lea    0x8(%eax),%edx
  8004a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a3:	89 10                	mov    %edx,(%eax)
  8004a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a8:	8b 00                	mov    (%eax),%eax
  8004aa:	83 e8 08             	sub    $0x8,%eax
  8004ad:	8b 50 04             	mov    0x4(%eax),%edx
  8004b0:	8b 00                	mov    (%eax),%eax
  8004b2:	eb 40                	jmp    8004f4 <getuint+0x65>
	else if (lflag)
  8004b4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004b8:	74 1e                	je     8004d8 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8004ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8004bd:	8b 00                	mov    (%eax),%eax
  8004bf:	8d 50 04             	lea    0x4(%eax),%edx
  8004c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c5:	89 10                	mov    %edx,(%eax)
  8004c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ca:	8b 00                	mov    (%eax),%eax
  8004cc:	83 e8 04             	sub    $0x4,%eax
  8004cf:	8b 00                	mov    (%eax),%eax
  8004d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8004d6:	eb 1c                	jmp    8004f4 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8004d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004db:	8b 00                	mov    (%eax),%eax
  8004dd:	8d 50 04             	lea    0x4(%eax),%edx
  8004e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e3:	89 10                	mov    %edx,(%eax)
  8004e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e8:	8b 00                	mov    (%eax),%eax
  8004ea:	83 e8 04             	sub    $0x4,%eax
  8004ed:	8b 00                	mov    (%eax),%eax
  8004ef:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004f4:	5d                   	pop    %ebp
  8004f5:	c3                   	ret    

008004f6 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004f6:	55                   	push   %ebp
  8004f7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004f9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004fd:	7e 1c                	jle    80051b <getint+0x25>
		return va_arg(*ap, long long);
  8004ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800502:	8b 00                	mov    (%eax),%eax
  800504:	8d 50 08             	lea    0x8(%eax),%edx
  800507:	8b 45 08             	mov    0x8(%ebp),%eax
  80050a:	89 10                	mov    %edx,(%eax)
  80050c:	8b 45 08             	mov    0x8(%ebp),%eax
  80050f:	8b 00                	mov    (%eax),%eax
  800511:	83 e8 08             	sub    $0x8,%eax
  800514:	8b 50 04             	mov    0x4(%eax),%edx
  800517:	8b 00                	mov    (%eax),%eax
  800519:	eb 38                	jmp    800553 <getint+0x5d>
	else if (lflag)
  80051b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80051f:	74 1a                	je     80053b <getint+0x45>
		return va_arg(*ap, long);
  800521:	8b 45 08             	mov    0x8(%ebp),%eax
  800524:	8b 00                	mov    (%eax),%eax
  800526:	8d 50 04             	lea    0x4(%eax),%edx
  800529:	8b 45 08             	mov    0x8(%ebp),%eax
  80052c:	89 10                	mov    %edx,(%eax)
  80052e:	8b 45 08             	mov    0x8(%ebp),%eax
  800531:	8b 00                	mov    (%eax),%eax
  800533:	83 e8 04             	sub    $0x4,%eax
  800536:	8b 00                	mov    (%eax),%eax
  800538:	99                   	cltd   
  800539:	eb 18                	jmp    800553 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80053b:	8b 45 08             	mov    0x8(%ebp),%eax
  80053e:	8b 00                	mov    (%eax),%eax
  800540:	8d 50 04             	lea    0x4(%eax),%edx
  800543:	8b 45 08             	mov    0x8(%ebp),%eax
  800546:	89 10                	mov    %edx,(%eax)
  800548:	8b 45 08             	mov    0x8(%ebp),%eax
  80054b:	8b 00                	mov    (%eax),%eax
  80054d:	83 e8 04             	sub    $0x4,%eax
  800550:	8b 00                	mov    (%eax),%eax
  800552:	99                   	cltd   
}
  800553:	5d                   	pop    %ebp
  800554:	c3                   	ret    

00800555 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800555:	55                   	push   %ebp
  800556:	89 e5                	mov    %esp,%ebp
  800558:	56                   	push   %esi
  800559:	53                   	push   %ebx
  80055a:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80055d:	eb 17                	jmp    800576 <vprintfmt+0x21>
			if (ch == '\0')
  80055f:	85 db                	test   %ebx,%ebx
  800561:	0f 84 af 03 00 00    	je     800916 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800567:	83 ec 08             	sub    $0x8,%esp
  80056a:	ff 75 0c             	pushl  0xc(%ebp)
  80056d:	53                   	push   %ebx
  80056e:	8b 45 08             	mov    0x8(%ebp),%eax
  800571:	ff d0                	call   *%eax
  800573:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800576:	8b 45 10             	mov    0x10(%ebp),%eax
  800579:	8d 50 01             	lea    0x1(%eax),%edx
  80057c:	89 55 10             	mov    %edx,0x10(%ebp)
  80057f:	8a 00                	mov    (%eax),%al
  800581:	0f b6 d8             	movzbl %al,%ebx
  800584:	83 fb 25             	cmp    $0x25,%ebx
  800587:	75 d6                	jne    80055f <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800589:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80058d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800594:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80059b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8005a2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8005ac:	8d 50 01             	lea    0x1(%eax),%edx
  8005af:	89 55 10             	mov    %edx,0x10(%ebp)
  8005b2:	8a 00                	mov    (%eax),%al
  8005b4:	0f b6 d8             	movzbl %al,%ebx
  8005b7:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8005ba:	83 f8 55             	cmp    $0x55,%eax
  8005bd:	0f 87 2b 03 00 00    	ja     8008ee <vprintfmt+0x399>
  8005c3:	8b 04 85 18 36 80 00 	mov    0x803618(,%eax,4),%eax
  8005ca:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8005cc:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8005d0:	eb d7                	jmp    8005a9 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8005d2:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8005d6:	eb d1                	jmp    8005a9 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005d8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8005df:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005e2:	89 d0                	mov    %edx,%eax
  8005e4:	c1 e0 02             	shl    $0x2,%eax
  8005e7:	01 d0                	add    %edx,%eax
  8005e9:	01 c0                	add    %eax,%eax
  8005eb:	01 d8                	add    %ebx,%eax
  8005ed:	83 e8 30             	sub    $0x30,%eax
  8005f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8005f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8005f6:	8a 00                	mov    (%eax),%al
  8005f8:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8005fb:	83 fb 2f             	cmp    $0x2f,%ebx
  8005fe:	7e 3e                	jle    80063e <vprintfmt+0xe9>
  800600:	83 fb 39             	cmp    $0x39,%ebx
  800603:	7f 39                	jg     80063e <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800605:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800608:	eb d5                	jmp    8005df <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80060a:	8b 45 14             	mov    0x14(%ebp),%eax
  80060d:	83 c0 04             	add    $0x4,%eax
  800610:	89 45 14             	mov    %eax,0x14(%ebp)
  800613:	8b 45 14             	mov    0x14(%ebp),%eax
  800616:	83 e8 04             	sub    $0x4,%eax
  800619:	8b 00                	mov    (%eax),%eax
  80061b:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80061e:	eb 1f                	jmp    80063f <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800620:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800624:	79 83                	jns    8005a9 <vprintfmt+0x54>
				width = 0;
  800626:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80062d:	e9 77 ff ff ff       	jmp    8005a9 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800632:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800639:	e9 6b ff ff ff       	jmp    8005a9 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80063e:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80063f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800643:	0f 89 60 ff ff ff    	jns    8005a9 <vprintfmt+0x54>
				width = precision, precision = -1;
  800649:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80064c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80064f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800656:	e9 4e ff ff ff       	jmp    8005a9 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80065b:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80065e:	e9 46 ff ff ff       	jmp    8005a9 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800663:	8b 45 14             	mov    0x14(%ebp),%eax
  800666:	83 c0 04             	add    $0x4,%eax
  800669:	89 45 14             	mov    %eax,0x14(%ebp)
  80066c:	8b 45 14             	mov    0x14(%ebp),%eax
  80066f:	83 e8 04             	sub    $0x4,%eax
  800672:	8b 00                	mov    (%eax),%eax
  800674:	83 ec 08             	sub    $0x8,%esp
  800677:	ff 75 0c             	pushl  0xc(%ebp)
  80067a:	50                   	push   %eax
  80067b:	8b 45 08             	mov    0x8(%ebp),%eax
  80067e:	ff d0                	call   *%eax
  800680:	83 c4 10             	add    $0x10,%esp
			break;
  800683:	e9 89 02 00 00       	jmp    800911 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800688:	8b 45 14             	mov    0x14(%ebp),%eax
  80068b:	83 c0 04             	add    $0x4,%eax
  80068e:	89 45 14             	mov    %eax,0x14(%ebp)
  800691:	8b 45 14             	mov    0x14(%ebp),%eax
  800694:	83 e8 04             	sub    $0x4,%eax
  800697:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800699:	85 db                	test   %ebx,%ebx
  80069b:	79 02                	jns    80069f <vprintfmt+0x14a>
				err = -err;
  80069d:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80069f:	83 fb 64             	cmp    $0x64,%ebx
  8006a2:	7f 0b                	jg     8006af <vprintfmt+0x15a>
  8006a4:	8b 34 9d 60 34 80 00 	mov    0x803460(,%ebx,4),%esi
  8006ab:	85 f6                	test   %esi,%esi
  8006ad:	75 19                	jne    8006c8 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006af:	53                   	push   %ebx
  8006b0:	68 05 36 80 00       	push   $0x803605
  8006b5:	ff 75 0c             	pushl  0xc(%ebp)
  8006b8:	ff 75 08             	pushl  0x8(%ebp)
  8006bb:	e8 5e 02 00 00       	call   80091e <printfmt>
  8006c0:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8006c3:	e9 49 02 00 00       	jmp    800911 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8006c8:	56                   	push   %esi
  8006c9:	68 0e 36 80 00       	push   $0x80360e
  8006ce:	ff 75 0c             	pushl  0xc(%ebp)
  8006d1:	ff 75 08             	pushl  0x8(%ebp)
  8006d4:	e8 45 02 00 00       	call   80091e <printfmt>
  8006d9:	83 c4 10             	add    $0x10,%esp
			break;
  8006dc:	e9 30 02 00 00       	jmp    800911 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e4:	83 c0 04             	add    $0x4,%eax
  8006e7:	89 45 14             	mov    %eax,0x14(%ebp)
  8006ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ed:	83 e8 04             	sub    $0x4,%eax
  8006f0:	8b 30                	mov    (%eax),%esi
  8006f2:	85 f6                	test   %esi,%esi
  8006f4:	75 05                	jne    8006fb <vprintfmt+0x1a6>
				p = "(null)";
  8006f6:	be 11 36 80 00       	mov    $0x803611,%esi
			if (width > 0 && padc != '-')
  8006fb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006ff:	7e 6d                	jle    80076e <vprintfmt+0x219>
  800701:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800705:	74 67                	je     80076e <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800707:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80070a:	83 ec 08             	sub    $0x8,%esp
  80070d:	50                   	push   %eax
  80070e:	56                   	push   %esi
  80070f:	e8 0c 03 00 00       	call   800a20 <strnlen>
  800714:	83 c4 10             	add    $0x10,%esp
  800717:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80071a:	eb 16                	jmp    800732 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80071c:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800720:	83 ec 08             	sub    $0x8,%esp
  800723:	ff 75 0c             	pushl  0xc(%ebp)
  800726:	50                   	push   %eax
  800727:	8b 45 08             	mov    0x8(%ebp),%eax
  80072a:	ff d0                	call   *%eax
  80072c:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80072f:	ff 4d e4             	decl   -0x1c(%ebp)
  800732:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800736:	7f e4                	jg     80071c <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800738:	eb 34                	jmp    80076e <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80073a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80073e:	74 1c                	je     80075c <vprintfmt+0x207>
  800740:	83 fb 1f             	cmp    $0x1f,%ebx
  800743:	7e 05                	jle    80074a <vprintfmt+0x1f5>
  800745:	83 fb 7e             	cmp    $0x7e,%ebx
  800748:	7e 12                	jle    80075c <vprintfmt+0x207>
					putch('?', putdat);
  80074a:	83 ec 08             	sub    $0x8,%esp
  80074d:	ff 75 0c             	pushl  0xc(%ebp)
  800750:	6a 3f                	push   $0x3f
  800752:	8b 45 08             	mov    0x8(%ebp),%eax
  800755:	ff d0                	call   *%eax
  800757:	83 c4 10             	add    $0x10,%esp
  80075a:	eb 0f                	jmp    80076b <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80075c:	83 ec 08             	sub    $0x8,%esp
  80075f:	ff 75 0c             	pushl  0xc(%ebp)
  800762:	53                   	push   %ebx
  800763:	8b 45 08             	mov    0x8(%ebp),%eax
  800766:	ff d0                	call   *%eax
  800768:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80076b:	ff 4d e4             	decl   -0x1c(%ebp)
  80076e:	89 f0                	mov    %esi,%eax
  800770:	8d 70 01             	lea    0x1(%eax),%esi
  800773:	8a 00                	mov    (%eax),%al
  800775:	0f be d8             	movsbl %al,%ebx
  800778:	85 db                	test   %ebx,%ebx
  80077a:	74 24                	je     8007a0 <vprintfmt+0x24b>
  80077c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800780:	78 b8                	js     80073a <vprintfmt+0x1e5>
  800782:	ff 4d e0             	decl   -0x20(%ebp)
  800785:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800789:	79 af                	jns    80073a <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80078b:	eb 13                	jmp    8007a0 <vprintfmt+0x24b>
				putch(' ', putdat);
  80078d:	83 ec 08             	sub    $0x8,%esp
  800790:	ff 75 0c             	pushl  0xc(%ebp)
  800793:	6a 20                	push   $0x20
  800795:	8b 45 08             	mov    0x8(%ebp),%eax
  800798:	ff d0                	call   *%eax
  80079a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80079d:	ff 4d e4             	decl   -0x1c(%ebp)
  8007a0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007a4:	7f e7                	jg     80078d <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8007a6:	e9 66 01 00 00       	jmp    800911 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8007ab:	83 ec 08             	sub    $0x8,%esp
  8007ae:	ff 75 e8             	pushl  -0x18(%ebp)
  8007b1:	8d 45 14             	lea    0x14(%ebp),%eax
  8007b4:	50                   	push   %eax
  8007b5:	e8 3c fd ff ff       	call   8004f6 <getint>
  8007ba:	83 c4 10             	add    $0x10,%esp
  8007bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007c0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8007c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007c9:	85 d2                	test   %edx,%edx
  8007cb:	79 23                	jns    8007f0 <vprintfmt+0x29b>
				putch('-', putdat);
  8007cd:	83 ec 08             	sub    $0x8,%esp
  8007d0:	ff 75 0c             	pushl  0xc(%ebp)
  8007d3:	6a 2d                	push   $0x2d
  8007d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d8:	ff d0                	call   *%eax
  8007da:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8007dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007e3:	f7 d8                	neg    %eax
  8007e5:	83 d2 00             	adc    $0x0,%edx
  8007e8:	f7 da                	neg    %edx
  8007ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007ed:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8007f0:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007f7:	e9 bc 00 00 00       	jmp    8008b8 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007fc:	83 ec 08             	sub    $0x8,%esp
  8007ff:	ff 75 e8             	pushl  -0x18(%ebp)
  800802:	8d 45 14             	lea    0x14(%ebp),%eax
  800805:	50                   	push   %eax
  800806:	e8 84 fc ff ff       	call   80048f <getuint>
  80080b:	83 c4 10             	add    $0x10,%esp
  80080e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800811:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800814:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80081b:	e9 98 00 00 00       	jmp    8008b8 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800820:	83 ec 08             	sub    $0x8,%esp
  800823:	ff 75 0c             	pushl  0xc(%ebp)
  800826:	6a 58                	push   $0x58
  800828:	8b 45 08             	mov    0x8(%ebp),%eax
  80082b:	ff d0                	call   *%eax
  80082d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800830:	83 ec 08             	sub    $0x8,%esp
  800833:	ff 75 0c             	pushl  0xc(%ebp)
  800836:	6a 58                	push   $0x58
  800838:	8b 45 08             	mov    0x8(%ebp),%eax
  80083b:	ff d0                	call   *%eax
  80083d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800840:	83 ec 08             	sub    $0x8,%esp
  800843:	ff 75 0c             	pushl  0xc(%ebp)
  800846:	6a 58                	push   $0x58
  800848:	8b 45 08             	mov    0x8(%ebp),%eax
  80084b:	ff d0                	call   *%eax
  80084d:	83 c4 10             	add    $0x10,%esp
			break;
  800850:	e9 bc 00 00 00       	jmp    800911 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800855:	83 ec 08             	sub    $0x8,%esp
  800858:	ff 75 0c             	pushl  0xc(%ebp)
  80085b:	6a 30                	push   $0x30
  80085d:	8b 45 08             	mov    0x8(%ebp),%eax
  800860:	ff d0                	call   *%eax
  800862:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800865:	83 ec 08             	sub    $0x8,%esp
  800868:	ff 75 0c             	pushl  0xc(%ebp)
  80086b:	6a 78                	push   $0x78
  80086d:	8b 45 08             	mov    0x8(%ebp),%eax
  800870:	ff d0                	call   *%eax
  800872:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800875:	8b 45 14             	mov    0x14(%ebp),%eax
  800878:	83 c0 04             	add    $0x4,%eax
  80087b:	89 45 14             	mov    %eax,0x14(%ebp)
  80087e:	8b 45 14             	mov    0x14(%ebp),%eax
  800881:	83 e8 04             	sub    $0x4,%eax
  800884:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800886:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800889:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800890:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800897:	eb 1f                	jmp    8008b8 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800899:	83 ec 08             	sub    $0x8,%esp
  80089c:	ff 75 e8             	pushl  -0x18(%ebp)
  80089f:	8d 45 14             	lea    0x14(%ebp),%eax
  8008a2:	50                   	push   %eax
  8008a3:	e8 e7 fb ff ff       	call   80048f <getuint>
  8008a8:	83 c4 10             	add    $0x10,%esp
  8008ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008ae:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8008b1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8008b8:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8008bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008bf:	83 ec 04             	sub    $0x4,%esp
  8008c2:	52                   	push   %edx
  8008c3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8008c6:	50                   	push   %eax
  8008c7:	ff 75 f4             	pushl  -0xc(%ebp)
  8008ca:	ff 75 f0             	pushl  -0x10(%ebp)
  8008cd:	ff 75 0c             	pushl  0xc(%ebp)
  8008d0:	ff 75 08             	pushl  0x8(%ebp)
  8008d3:	e8 00 fb ff ff       	call   8003d8 <printnum>
  8008d8:	83 c4 20             	add    $0x20,%esp
			break;
  8008db:	eb 34                	jmp    800911 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008dd:	83 ec 08             	sub    $0x8,%esp
  8008e0:	ff 75 0c             	pushl  0xc(%ebp)
  8008e3:	53                   	push   %ebx
  8008e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e7:	ff d0                	call   *%eax
  8008e9:	83 c4 10             	add    $0x10,%esp
			break;
  8008ec:	eb 23                	jmp    800911 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008ee:	83 ec 08             	sub    $0x8,%esp
  8008f1:	ff 75 0c             	pushl  0xc(%ebp)
  8008f4:	6a 25                	push   $0x25
  8008f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f9:	ff d0                	call   *%eax
  8008fb:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008fe:	ff 4d 10             	decl   0x10(%ebp)
  800901:	eb 03                	jmp    800906 <vprintfmt+0x3b1>
  800903:	ff 4d 10             	decl   0x10(%ebp)
  800906:	8b 45 10             	mov    0x10(%ebp),%eax
  800909:	48                   	dec    %eax
  80090a:	8a 00                	mov    (%eax),%al
  80090c:	3c 25                	cmp    $0x25,%al
  80090e:	75 f3                	jne    800903 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800910:	90                   	nop
		}
	}
  800911:	e9 47 fc ff ff       	jmp    80055d <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800916:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800917:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80091a:	5b                   	pop    %ebx
  80091b:	5e                   	pop    %esi
  80091c:	5d                   	pop    %ebp
  80091d:	c3                   	ret    

0080091e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80091e:	55                   	push   %ebp
  80091f:	89 e5                	mov    %esp,%ebp
  800921:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800924:	8d 45 10             	lea    0x10(%ebp),%eax
  800927:	83 c0 04             	add    $0x4,%eax
  80092a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80092d:	8b 45 10             	mov    0x10(%ebp),%eax
  800930:	ff 75 f4             	pushl  -0xc(%ebp)
  800933:	50                   	push   %eax
  800934:	ff 75 0c             	pushl  0xc(%ebp)
  800937:	ff 75 08             	pushl  0x8(%ebp)
  80093a:	e8 16 fc ff ff       	call   800555 <vprintfmt>
  80093f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800942:	90                   	nop
  800943:	c9                   	leave  
  800944:	c3                   	ret    

00800945 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800945:	55                   	push   %ebp
  800946:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800948:	8b 45 0c             	mov    0xc(%ebp),%eax
  80094b:	8b 40 08             	mov    0x8(%eax),%eax
  80094e:	8d 50 01             	lea    0x1(%eax),%edx
  800951:	8b 45 0c             	mov    0xc(%ebp),%eax
  800954:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800957:	8b 45 0c             	mov    0xc(%ebp),%eax
  80095a:	8b 10                	mov    (%eax),%edx
  80095c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80095f:	8b 40 04             	mov    0x4(%eax),%eax
  800962:	39 c2                	cmp    %eax,%edx
  800964:	73 12                	jae    800978 <sprintputch+0x33>
		*b->buf++ = ch;
  800966:	8b 45 0c             	mov    0xc(%ebp),%eax
  800969:	8b 00                	mov    (%eax),%eax
  80096b:	8d 48 01             	lea    0x1(%eax),%ecx
  80096e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800971:	89 0a                	mov    %ecx,(%edx)
  800973:	8b 55 08             	mov    0x8(%ebp),%edx
  800976:	88 10                	mov    %dl,(%eax)
}
  800978:	90                   	nop
  800979:	5d                   	pop    %ebp
  80097a:	c3                   	ret    

0080097b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80097b:	55                   	push   %ebp
  80097c:	89 e5                	mov    %esp,%ebp
  80097e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800981:	8b 45 08             	mov    0x8(%ebp),%eax
  800984:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800987:	8b 45 0c             	mov    0xc(%ebp),%eax
  80098a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80098d:	8b 45 08             	mov    0x8(%ebp),%eax
  800990:	01 d0                	add    %edx,%eax
  800992:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800995:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80099c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8009a0:	74 06                	je     8009a8 <vsnprintf+0x2d>
  8009a2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009a6:	7f 07                	jg     8009af <vsnprintf+0x34>
		return -E_INVAL;
  8009a8:	b8 03 00 00 00       	mov    $0x3,%eax
  8009ad:	eb 20                	jmp    8009cf <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009af:	ff 75 14             	pushl  0x14(%ebp)
  8009b2:	ff 75 10             	pushl  0x10(%ebp)
  8009b5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009b8:	50                   	push   %eax
  8009b9:	68 45 09 80 00       	push   $0x800945
  8009be:	e8 92 fb ff ff       	call   800555 <vprintfmt>
  8009c3:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8009c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009c9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8009cf:	c9                   	leave  
  8009d0:	c3                   	ret    

008009d1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009d1:	55                   	push   %ebp
  8009d2:	89 e5                	mov    %esp,%ebp
  8009d4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009d7:	8d 45 10             	lea    0x10(%ebp),%eax
  8009da:	83 c0 04             	add    $0x4,%eax
  8009dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8009e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8009e3:	ff 75 f4             	pushl  -0xc(%ebp)
  8009e6:	50                   	push   %eax
  8009e7:	ff 75 0c             	pushl  0xc(%ebp)
  8009ea:	ff 75 08             	pushl  0x8(%ebp)
  8009ed:	e8 89 ff ff ff       	call   80097b <vsnprintf>
  8009f2:	83 c4 10             	add    $0x10,%esp
  8009f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8009f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009fb:	c9                   	leave  
  8009fc:	c3                   	ret    

008009fd <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8009fd:	55                   	push   %ebp
  8009fe:	89 e5                	mov    %esp,%ebp
  800a00:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800a03:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a0a:	eb 06                	jmp    800a12 <strlen+0x15>
		n++;
  800a0c:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800a0f:	ff 45 08             	incl   0x8(%ebp)
  800a12:	8b 45 08             	mov    0x8(%ebp),%eax
  800a15:	8a 00                	mov    (%eax),%al
  800a17:	84 c0                	test   %al,%al
  800a19:	75 f1                	jne    800a0c <strlen+0xf>
		n++;
	return n;
  800a1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a1e:	c9                   	leave  
  800a1f:	c3                   	ret    

00800a20 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800a20:	55                   	push   %ebp
  800a21:	89 e5                	mov    %esp,%ebp
  800a23:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a26:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a2d:	eb 09                	jmp    800a38 <strnlen+0x18>
		n++;
  800a2f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a32:	ff 45 08             	incl   0x8(%ebp)
  800a35:	ff 4d 0c             	decl   0xc(%ebp)
  800a38:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a3c:	74 09                	je     800a47 <strnlen+0x27>
  800a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a41:	8a 00                	mov    (%eax),%al
  800a43:	84 c0                	test   %al,%al
  800a45:	75 e8                	jne    800a2f <strnlen+0xf>
		n++;
	return n;
  800a47:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a4a:	c9                   	leave  
  800a4b:	c3                   	ret    

00800a4c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a4c:	55                   	push   %ebp
  800a4d:	89 e5                	mov    %esp,%ebp
  800a4f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800a52:	8b 45 08             	mov    0x8(%ebp),%eax
  800a55:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a58:	90                   	nop
  800a59:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5c:	8d 50 01             	lea    0x1(%eax),%edx
  800a5f:	89 55 08             	mov    %edx,0x8(%ebp)
  800a62:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a65:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a68:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a6b:	8a 12                	mov    (%edx),%dl
  800a6d:	88 10                	mov    %dl,(%eax)
  800a6f:	8a 00                	mov    (%eax),%al
  800a71:	84 c0                	test   %al,%al
  800a73:	75 e4                	jne    800a59 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800a75:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a78:	c9                   	leave  
  800a79:	c3                   	ret    

00800a7a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800a7a:	55                   	push   %ebp
  800a7b:	89 e5                	mov    %esp,%ebp
  800a7d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800a80:	8b 45 08             	mov    0x8(%ebp),%eax
  800a83:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800a86:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a8d:	eb 1f                	jmp    800aae <strncpy+0x34>
		*dst++ = *src;
  800a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a92:	8d 50 01             	lea    0x1(%eax),%edx
  800a95:	89 55 08             	mov    %edx,0x8(%ebp)
  800a98:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a9b:	8a 12                	mov    (%edx),%dl
  800a9d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800a9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aa2:	8a 00                	mov    (%eax),%al
  800aa4:	84 c0                	test   %al,%al
  800aa6:	74 03                	je     800aab <strncpy+0x31>
			src++;
  800aa8:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800aab:	ff 45 fc             	incl   -0x4(%ebp)
  800aae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ab1:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ab4:	72 d9                	jb     800a8f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ab6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ab9:	c9                   	leave  
  800aba:	c3                   	ret    

00800abb <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800abb:	55                   	push   %ebp
  800abc:	89 e5                	mov    %esp,%ebp
  800abe:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ac7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800acb:	74 30                	je     800afd <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800acd:	eb 16                	jmp    800ae5 <strlcpy+0x2a>
			*dst++ = *src++;
  800acf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad2:	8d 50 01             	lea    0x1(%eax),%edx
  800ad5:	89 55 08             	mov    %edx,0x8(%ebp)
  800ad8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800adb:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ade:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ae1:	8a 12                	mov    (%edx),%dl
  800ae3:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ae5:	ff 4d 10             	decl   0x10(%ebp)
  800ae8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800aec:	74 09                	je     800af7 <strlcpy+0x3c>
  800aee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af1:	8a 00                	mov    (%eax),%al
  800af3:	84 c0                	test   %al,%al
  800af5:	75 d8                	jne    800acf <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800af7:	8b 45 08             	mov    0x8(%ebp),%eax
  800afa:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800afd:	8b 55 08             	mov    0x8(%ebp),%edx
  800b00:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b03:	29 c2                	sub    %eax,%edx
  800b05:	89 d0                	mov    %edx,%eax
}
  800b07:	c9                   	leave  
  800b08:	c3                   	ret    

00800b09 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b09:	55                   	push   %ebp
  800b0a:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800b0c:	eb 06                	jmp    800b14 <strcmp+0xb>
		p++, q++;
  800b0e:	ff 45 08             	incl   0x8(%ebp)
  800b11:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800b14:	8b 45 08             	mov    0x8(%ebp),%eax
  800b17:	8a 00                	mov    (%eax),%al
  800b19:	84 c0                	test   %al,%al
  800b1b:	74 0e                	je     800b2b <strcmp+0x22>
  800b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b20:	8a 10                	mov    (%eax),%dl
  800b22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b25:	8a 00                	mov    (%eax),%al
  800b27:	38 c2                	cmp    %al,%dl
  800b29:	74 e3                	je     800b0e <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2e:	8a 00                	mov    (%eax),%al
  800b30:	0f b6 d0             	movzbl %al,%edx
  800b33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b36:	8a 00                	mov    (%eax),%al
  800b38:	0f b6 c0             	movzbl %al,%eax
  800b3b:	29 c2                	sub    %eax,%edx
  800b3d:	89 d0                	mov    %edx,%eax
}
  800b3f:	5d                   	pop    %ebp
  800b40:	c3                   	ret    

00800b41 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800b41:	55                   	push   %ebp
  800b42:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b44:	eb 09                	jmp    800b4f <strncmp+0xe>
		n--, p++, q++;
  800b46:	ff 4d 10             	decl   0x10(%ebp)
  800b49:	ff 45 08             	incl   0x8(%ebp)
  800b4c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800b4f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b53:	74 17                	je     800b6c <strncmp+0x2b>
  800b55:	8b 45 08             	mov    0x8(%ebp),%eax
  800b58:	8a 00                	mov    (%eax),%al
  800b5a:	84 c0                	test   %al,%al
  800b5c:	74 0e                	je     800b6c <strncmp+0x2b>
  800b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b61:	8a 10                	mov    (%eax),%dl
  800b63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b66:	8a 00                	mov    (%eax),%al
  800b68:	38 c2                	cmp    %al,%dl
  800b6a:	74 da                	je     800b46 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800b6c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b70:	75 07                	jne    800b79 <strncmp+0x38>
		return 0;
  800b72:	b8 00 00 00 00       	mov    $0x0,%eax
  800b77:	eb 14                	jmp    800b8d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b79:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7c:	8a 00                	mov    (%eax),%al
  800b7e:	0f b6 d0             	movzbl %al,%edx
  800b81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b84:	8a 00                	mov    (%eax),%al
  800b86:	0f b6 c0             	movzbl %al,%eax
  800b89:	29 c2                	sub    %eax,%edx
  800b8b:	89 d0                	mov    %edx,%eax
}
  800b8d:	5d                   	pop    %ebp
  800b8e:	c3                   	ret    

00800b8f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b8f:	55                   	push   %ebp
  800b90:	89 e5                	mov    %esp,%ebp
  800b92:	83 ec 04             	sub    $0x4,%esp
  800b95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b98:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b9b:	eb 12                	jmp    800baf <strchr+0x20>
		if (*s == c)
  800b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba0:	8a 00                	mov    (%eax),%al
  800ba2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ba5:	75 05                	jne    800bac <strchr+0x1d>
			return (char *) s;
  800ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  800baa:	eb 11                	jmp    800bbd <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800bac:	ff 45 08             	incl   0x8(%ebp)
  800baf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb2:	8a 00                	mov    (%eax),%al
  800bb4:	84 c0                	test   %al,%al
  800bb6:	75 e5                	jne    800b9d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800bb8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bbd:	c9                   	leave  
  800bbe:	c3                   	ret    

00800bbf <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800bbf:	55                   	push   %ebp
  800bc0:	89 e5                	mov    %esp,%ebp
  800bc2:	83 ec 04             	sub    $0x4,%esp
  800bc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800bcb:	eb 0d                	jmp    800bda <strfind+0x1b>
		if (*s == c)
  800bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd0:	8a 00                	mov    (%eax),%al
  800bd2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800bd5:	74 0e                	je     800be5 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800bd7:	ff 45 08             	incl   0x8(%ebp)
  800bda:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdd:	8a 00                	mov    (%eax),%al
  800bdf:	84 c0                	test   %al,%al
  800be1:	75 ea                	jne    800bcd <strfind+0xe>
  800be3:	eb 01                	jmp    800be6 <strfind+0x27>
		if (*s == c)
			break;
  800be5:	90                   	nop
	return (char *) s;
  800be6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800be9:	c9                   	leave  
  800bea:	c3                   	ret    

00800beb <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800beb:	55                   	push   %ebp
  800bec:	89 e5                	mov    %esp,%ebp
  800bee:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800bf7:	8b 45 10             	mov    0x10(%ebp),%eax
  800bfa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800bfd:	eb 0e                	jmp    800c0d <memset+0x22>
		*p++ = c;
  800bff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c02:	8d 50 01             	lea    0x1(%eax),%edx
  800c05:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800c08:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c0b:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800c0d:	ff 4d f8             	decl   -0x8(%ebp)
  800c10:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800c14:	79 e9                	jns    800bff <memset+0x14>
		*p++ = c;

	return v;
  800c16:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c19:	c9                   	leave  
  800c1a:	c3                   	ret    

00800c1b <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800c1b:	55                   	push   %ebp
  800c1c:	89 e5                	mov    %esp,%ebp
  800c1e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c24:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c27:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800c2d:	eb 16                	jmp    800c45 <memcpy+0x2a>
		*d++ = *s++;
  800c2f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c32:	8d 50 01             	lea    0x1(%eax),%edx
  800c35:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c38:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c3b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c3e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c41:	8a 12                	mov    (%edx),%dl
  800c43:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800c45:	8b 45 10             	mov    0x10(%ebp),%eax
  800c48:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c4b:	89 55 10             	mov    %edx,0x10(%ebp)
  800c4e:	85 c0                	test   %eax,%eax
  800c50:	75 dd                	jne    800c2f <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800c52:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c55:	c9                   	leave  
  800c56:	c3                   	ret    

00800c57 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800c57:	55                   	push   %ebp
  800c58:	89 e5                	mov    %esp,%ebp
  800c5a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c60:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c63:	8b 45 08             	mov    0x8(%ebp),%eax
  800c66:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800c69:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c6c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c6f:	73 50                	jae    800cc1 <memmove+0x6a>
  800c71:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c74:	8b 45 10             	mov    0x10(%ebp),%eax
  800c77:	01 d0                	add    %edx,%eax
  800c79:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c7c:	76 43                	jbe    800cc1 <memmove+0x6a>
		s += n;
  800c7e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c81:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800c84:	8b 45 10             	mov    0x10(%ebp),%eax
  800c87:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800c8a:	eb 10                	jmp    800c9c <memmove+0x45>
			*--d = *--s;
  800c8c:	ff 4d f8             	decl   -0x8(%ebp)
  800c8f:	ff 4d fc             	decl   -0x4(%ebp)
  800c92:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c95:	8a 10                	mov    (%eax),%dl
  800c97:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c9a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800c9c:	8b 45 10             	mov    0x10(%ebp),%eax
  800c9f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ca2:	89 55 10             	mov    %edx,0x10(%ebp)
  800ca5:	85 c0                	test   %eax,%eax
  800ca7:	75 e3                	jne    800c8c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ca9:	eb 23                	jmp    800cce <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800cab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cae:	8d 50 01             	lea    0x1(%eax),%edx
  800cb1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800cb4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800cb7:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cba:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800cbd:	8a 12                	mov    (%edx),%dl
  800cbf:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800cc1:	8b 45 10             	mov    0x10(%ebp),%eax
  800cc4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cc7:	89 55 10             	mov    %edx,0x10(%ebp)
  800cca:	85 c0                	test   %eax,%eax
  800ccc:	75 dd                	jne    800cab <memmove+0x54>
			*d++ = *s++;

	return dst;
  800cce:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cd1:	c9                   	leave  
  800cd2:	c3                   	ret    

00800cd3 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800cd3:	55                   	push   %ebp
  800cd4:	89 e5                	mov    %esp,%ebp
  800cd6:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800cdf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce2:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ce5:	eb 2a                	jmp    800d11 <memcmp+0x3e>
		if (*s1 != *s2)
  800ce7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cea:	8a 10                	mov    (%eax),%dl
  800cec:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cef:	8a 00                	mov    (%eax),%al
  800cf1:	38 c2                	cmp    %al,%dl
  800cf3:	74 16                	je     800d0b <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800cf5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cf8:	8a 00                	mov    (%eax),%al
  800cfa:	0f b6 d0             	movzbl %al,%edx
  800cfd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d00:	8a 00                	mov    (%eax),%al
  800d02:	0f b6 c0             	movzbl %al,%eax
  800d05:	29 c2                	sub    %eax,%edx
  800d07:	89 d0                	mov    %edx,%eax
  800d09:	eb 18                	jmp    800d23 <memcmp+0x50>
		s1++, s2++;
  800d0b:	ff 45 fc             	incl   -0x4(%ebp)
  800d0e:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800d11:	8b 45 10             	mov    0x10(%ebp),%eax
  800d14:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d17:	89 55 10             	mov    %edx,0x10(%ebp)
  800d1a:	85 c0                	test   %eax,%eax
  800d1c:	75 c9                	jne    800ce7 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800d1e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d23:	c9                   	leave  
  800d24:	c3                   	ret    

00800d25 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800d25:	55                   	push   %ebp
  800d26:	89 e5                	mov    %esp,%ebp
  800d28:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800d2b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d2e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d31:	01 d0                	add    %edx,%eax
  800d33:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800d36:	eb 15                	jmp    800d4d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d38:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3b:	8a 00                	mov    (%eax),%al
  800d3d:	0f b6 d0             	movzbl %al,%edx
  800d40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d43:	0f b6 c0             	movzbl %al,%eax
  800d46:	39 c2                	cmp    %eax,%edx
  800d48:	74 0d                	je     800d57 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d4a:	ff 45 08             	incl   0x8(%ebp)
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d50:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800d53:	72 e3                	jb     800d38 <memfind+0x13>
  800d55:	eb 01                	jmp    800d58 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800d57:	90                   	nop
	return (void *) s;
  800d58:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d5b:	c9                   	leave  
  800d5c:	c3                   	ret    

00800d5d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d5d:	55                   	push   %ebp
  800d5e:	89 e5                	mov    %esp,%ebp
  800d60:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800d63:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800d6a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d71:	eb 03                	jmp    800d76 <strtol+0x19>
		s++;
  800d73:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d76:	8b 45 08             	mov    0x8(%ebp),%eax
  800d79:	8a 00                	mov    (%eax),%al
  800d7b:	3c 20                	cmp    $0x20,%al
  800d7d:	74 f4                	je     800d73 <strtol+0x16>
  800d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d82:	8a 00                	mov    (%eax),%al
  800d84:	3c 09                	cmp    $0x9,%al
  800d86:	74 eb                	je     800d73 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d88:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8b:	8a 00                	mov    (%eax),%al
  800d8d:	3c 2b                	cmp    $0x2b,%al
  800d8f:	75 05                	jne    800d96 <strtol+0x39>
		s++;
  800d91:	ff 45 08             	incl   0x8(%ebp)
  800d94:	eb 13                	jmp    800da9 <strtol+0x4c>
	else if (*s == '-')
  800d96:	8b 45 08             	mov    0x8(%ebp),%eax
  800d99:	8a 00                	mov    (%eax),%al
  800d9b:	3c 2d                	cmp    $0x2d,%al
  800d9d:	75 0a                	jne    800da9 <strtol+0x4c>
		s++, neg = 1;
  800d9f:	ff 45 08             	incl   0x8(%ebp)
  800da2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800da9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dad:	74 06                	je     800db5 <strtol+0x58>
  800daf:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800db3:	75 20                	jne    800dd5 <strtol+0x78>
  800db5:	8b 45 08             	mov    0x8(%ebp),%eax
  800db8:	8a 00                	mov    (%eax),%al
  800dba:	3c 30                	cmp    $0x30,%al
  800dbc:	75 17                	jne    800dd5 <strtol+0x78>
  800dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc1:	40                   	inc    %eax
  800dc2:	8a 00                	mov    (%eax),%al
  800dc4:	3c 78                	cmp    $0x78,%al
  800dc6:	75 0d                	jne    800dd5 <strtol+0x78>
		s += 2, base = 16;
  800dc8:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800dcc:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800dd3:	eb 28                	jmp    800dfd <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800dd5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dd9:	75 15                	jne    800df0 <strtol+0x93>
  800ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dde:	8a 00                	mov    (%eax),%al
  800de0:	3c 30                	cmp    $0x30,%al
  800de2:	75 0c                	jne    800df0 <strtol+0x93>
		s++, base = 8;
  800de4:	ff 45 08             	incl   0x8(%ebp)
  800de7:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800dee:	eb 0d                	jmp    800dfd <strtol+0xa0>
	else if (base == 0)
  800df0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800df4:	75 07                	jne    800dfd <strtol+0xa0>
		base = 10;
  800df6:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800e00:	8a 00                	mov    (%eax),%al
  800e02:	3c 2f                	cmp    $0x2f,%al
  800e04:	7e 19                	jle    800e1f <strtol+0xc2>
  800e06:	8b 45 08             	mov    0x8(%ebp),%eax
  800e09:	8a 00                	mov    (%eax),%al
  800e0b:	3c 39                	cmp    $0x39,%al
  800e0d:	7f 10                	jg     800e1f <strtol+0xc2>
			dig = *s - '0';
  800e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e12:	8a 00                	mov    (%eax),%al
  800e14:	0f be c0             	movsbl %al,%eax
  800e17:	83 e8 30             	sub    $0x30,%eax
  800e1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e1d:	eb 42                	jmp    800e61 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e22:	8a 00                	mov    (%eax),%al
  800e24:	3c 60                	cmp    $0x60,%al
  800e26:	7e 19                	jle    800e41 <strtol+0xe4>
  800e28:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2b:	8a 00                	mov    (%eax),%al
  800e2d:	3c 7a                	cmp    $0x7a,%al
  800e2f:	7f 10                	jg     800e41 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800e31:	8b 45 08             	mov    0x8(%ebp),%eax
  800e34:	8a 00                	mov    (%eax),%al
  800e36:	0f be c0             	movsbl %al,%eax
  800e39:	83 e8 57             	sub    $0x57,%eax
  800e3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e3f:	eb 20                	jmp    800e61 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800e41:	8b 45 08             	mov    0x8(%ebp),%eax
  800e44:	8a 00                	mov    (%eax),%al
  800e46:	3c 40                	cmp    $0x40,%al
  800e48:	7e 39                	jle    800e83 <strtol+0x126>
  800e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4d:	8a 00                	mov    (%eax),%al
  800e4f:	3c 5a                	cmp    $0x5a,%al
  800e51:	7f 30                	jg     800e83 <strtol+0x126>
			dig = *s - 'A' + 10;
  800e53:	8b 45 08             	mov    0x8(%ebp),%eax
  800e56:	8a 00                	mov    (%eax),%al
  800e58:	0f be c0             	movsbl %al,%eax
  800e5b:	83 e8 37             	sub    $0x37,%eax
  800e5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e64:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e67:	7d 19                	jge    800e82 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800e69:	ff 45 08             	incl   0x8(%ebp)
  800e6c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e6f:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e73:	89 c2                	mov    %eax,%edx
  800e75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e78:	01 d0                	add    %edx,%eax
  800e7a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800e7d:	e9 7b ff ff ff       	jmp    800dfd <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800e82:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800e83:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e87:	74 08                	je     800e91 <strtol+0x134>
		*endptr = (char *) s;
  800e89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e8f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800e91:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e95:	74 07                	je     800e9e <strtol+0x141>
  800e97:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e9a:	f7 d8                	neg    %eax
  800e9c:	eb 03                	jmp    800ea1 <strtol+0x144>
  800e9e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ea1:	c9                   	leave  
  800ea2:	c3                   	ret    

00800ea3 <ltostr>:

void
ltostr(long value, char *str)
{
  800ea3:	55                   	push   %ebp
  800ea4:	89 e5                	mov    %esp,%ebp
  800ea6:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800ea9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800eb0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800eb7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ebb:	79 13                	jns    800ed0 <ltostr+0x2d>
	{
		neg = 1;
  800ebd:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800ec4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec7:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800eca:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800ecd:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed3:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800ed8:	99                   	cltd   
  800ed9:	f7 f9                	idiv   %ecx
  800edb:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800ede:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ee1:	8d 50 01             	lea    0x1(%eax),%edx
  800ee4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ee7:	89 c2                	mov    %eax,%edx
  800ee9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eec:	01 d0                	add    %edx,%eax
  800eee:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ef1:	83 c2 30             	add    $0x30,%edx
  800ef4:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800ef6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ef9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800efe:	f7 e9                	imul   %ecx
  800f00:	c1 fa 02             	sar    $0x2,%edx
  800f03:	89 c8                	mov    %ecx,%eax
  800f05:	c1 f8 1f             	sar    $0x1f,%eax
  800f08:	29 c2                	sub    %eax,%edx
  800f0a:	89 d0                	mov    %edx,%eax
  800f0c:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800f0f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f12:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800f17:	f7 e9                	imul   %ecx
  800f19:	c1 fa 02             	sar    $0x2,%edx
  800f1c:	89 c8                	mov    %ecx,%eax
  800f1e:	c1 f8 1f             	sar    $0x1f,%eax
  800f21:	29 c2                	sub    %eax,%edx
  800f23:	89 d0                	mov    %edx,%eax
  800f25:	c1 e0 02             	shl    $0x2,%eax
  800f28:	01 d0                	add    %edx,%eax
  800f2a:	01 c0                	add    %eax,%eax
  800f2c:	29 c1                	sub    %eax,%ecx
  800f2e:	89 ca                	mov    %ecx,%edx
  800f30:	85 d2                	test   %edx,%edx
  800f32:	75 9c                	jne    800ed0 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800f34:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800f3b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f3e:	48                   	dec    %eax
  800f3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800f42:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f46:	74 3d                	je     800f85 <ltostr+0xe2>
		start = 1 ;
  800f48:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800f4f:	eb 34                	jmp    800f85 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800f51:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f57:	01 d0                	add    %edx,%eax
  800f59:	8a 00                	mov    (%eax),%al
  800f5b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800f5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f64:	01 c2                	add    %eax,%edx
  800f66:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800f69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6c:	01 c8                	add    %ecx,%eax
  800f6e:	8a 00                	mov    (%eax),%al
  800f70:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800f72:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f78:	01 c2                	add    %eax,%edx
  800f7a:	8a 45 eb             	mov    -0x15(%ebp),%al
  800f7d:	88 02                	mov    %al,(%edx)
		start++ ;
  800f7f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800f82:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800f85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f88:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f8b:	7c c4                	jl     800f51 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800f8d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800f90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f93:	01 d0                	add    %edx,%eax
  800f95:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800f98:	90                   	nop
  800f99:	c9                   	leave  
  800f9a:	c3                   	ret    

00800f9b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800f9b:	55                   	push   %ebp
  800f9c:	89 e5                	mov    %esp,%ebp
  800f9e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800fa1:	ff 75 08             	pushl  0x8(%ebp)
  800fa4:	e8 54 fa ff ff       	call   8009fd <strlen>
  800fa9:	83 c4 04             	add    $0x4,%esp
  800fac:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800faf:	ff 75 0c             	pushl  0xc(%ebp)
  800fb2:	e8 46 fa ff ff       	call   8009fd <strlen>
  800fb7:	83 c4 04             	add    $0x4,%esp
  800fba:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800fbd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800fc4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800fcb:	eb 17                	jmp    800fe4 <strcconcat+0x49>
		final[s] = str1[s] ;
  800fcd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fd0:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd3:	01 c2                	add    %eax,%edx
  800fd5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdb:	01 c8                	add    %ecx,%eax
  800fdd:	8a 00                	mov    (%eax),%al
  800fdf:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800fe1:	ff 45 fc             	incl   -0x4(%ebp)
  800fe4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fe7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800fea:	7c e1                	jl     800fcd <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800fec:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800ff3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800ffa:	eb 1f                	jmp    80101b <strcconcat+0x80>
		final[s++] = str2[i] ;
  800ffc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fff:	8d 50 01             	lea    0x1(%eax),%edx
  801002:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801005:	89 c2                	mov    %eax,%edx
  801007:	8b 45 10             	mov    0x10(%ebp),%eax
  80100a:	01 c2                	add    %eax,%edx
  80100c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80100f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801012:	01 c8                	add    %ecx,%eax
  801014:	8a 00                	mov    (%eax),%al
  801016:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801018:	ff 45 f8             	incl   -0x8(%ebp)
  80101b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801021:	7c d9                	jl     800ffc <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801023:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801026:	8b 45 10             	mov    0x10(%ebp),%eax
  801029:	01 d0                	add    %edx,%eax
  80102b:	c6 00 00             	movb   $0x0,(%eax)
}
  80102e:	90                   	nop
  80102f:	c9                   	leave  
  801030:	c3                   	ret    

00801031 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801031:	55                   	push   %ebp
  801032:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801034:	8b 45 14             	mov    0x14(%ebp),%eax
  801037:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80103d:	8b 45 14             	mov    0x14(%ebp),%eax
  801040:	8b 00                	mov    (%eax),%eax
  801042:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801049:	8b 45 10             	mov    0x10(%ebp),%eax
  80104c:	01 d0                	add    %edx,%eax
  80104e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801054:	eb 0c                	jmp    801062 <strsplit+0x31>
			*string++ = 0;
  801056:	8b 45 08             	mov    0x8(%ebp),%eax
  801059:	8d 50 01             	lea    0x1(%eax),%edx
  80105c:	89 55 08             	mov    %edx,0x8(%ebp)
  80105f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801062:	8b 45 08             	mov    0x8(%ebp),%eax
  801065:	8a 00                	mov    (%eax),%al
  801067:	84 c0                	test   %al,%al
  801069:	74 18                	je     801083 <strsplit+0x52>
  80106b:	8b 45 08             	mov    0x8(%ebp),%eax
  80106e:	8a 00                	mov    (%eax),%al
  801070:	0f be c0             	movsbl %al,%eax
  801073:	50                   	push   %eax
  801074:	ff 75 0c             	pushl  0xc(%ebp)
  801077:	e8 13 fb ff ff       	call   800b8f <strchr>
  80107c:	83 c4 08             	add    $0x8,%esp
  80107f:	85 c0                	test   %eax,%eax
  801081:	75 d3                	jne    801056 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801083:	8b 45 08             	mov    0x8(%ebp),%eax
  801086:	8a 00                	mov    (%eax),%al
  801088:	84 c0                	test   %al,%al
  80108a:	74 5a                	je     8010e6 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80108c:	8b 45 14             	mov    0x14(%ebp),%eax
  80108f:	8b 00                	mov    (%eax),%eax
  801091:	83 f8 0f             	cmp    $0xf,%eax
  801094:	75 07                	jne    80109d <strsplit+0x6c>
		{
			return 0;
  801096:	b8 00 00 00 00       	mov    $0x0,%eax
  80109b:	eb 66                	jmp    801103 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80109d:	8b 45 14             	mov    0x14(%ebp),%eax
  8010a0:	8b 00                	mov    (%eax),%eax
  8010a2:	8d 48 01             	lea    0x1(%eax),%ecx
  8010a5:	8b 55 14             	mov    0x14(%ebp),%edx
  8010a8:	89 0a                	mov    %ecx,(%edx)
  8010aa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b4:	01 c2                	add    %eax,%edx
  8010b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b9:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8010bb:	eb 03                	jmp    8010c0 <strsplit+0x8f>
			string++;
  8010bd:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8010c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c3:	8a 00                	mov    (%eax),%al
  8010c5:	84 c0                	test   %al,%al
  8010c7:	74 8b                	je     801054 <strsplit+0x23>
  8010c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cc:	8a 00                	mov    (%eax),%al
  8010ce:	0f be c0             	movsbl %al,%eax
  8010d1:	50                   	push   %eax
  8010d2:	ff 75 0c             	pushl  0xc(%ebp)
  8010d5:	e8 b5 fa ff ff       	call   800b8f <strchr>
  8010da:	83 c4 08             	add    $0x8,%esp
  8010dd:	85 c0                	test   %eax,%eax
  8010df:	74 dc                	je     8010bd <strsplit+0x8c>
			string++;
	}
  8010e1:	e9 6e ff ff ff       	jmp    801054 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8010e6:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8010e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8010ea:	8b 00                	mov    (%eax),%eax
  8010ec:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f6:	01 d0                	add    %edx,%eax
  8010f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8010fe:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801103:	c9                   	leave  
  801104:	c3                   	ret    

00801105 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801105:	55                   	push   %ebp
  801106:	89 e5                	mov    %esp,%ebp
  801108:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  80110b:	a1 04 40 80 00       	mov    0x804004,%eax
  801110:	85 c0                	test   %eax,%eax
  801112:	74 1f                	je     801133 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801114:	e8 1d 00 00 00       	call   801136 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801119:	83 ec 0c             	sub    $0xc,%esp
  80111c:	68 70 37 80 00       	push   $0x803770
  801121:	e8 55 f2 ff ff       	call   80037b <cprintf>
  801126:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801129:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801130:	00 00 00 
	}
}
  801133:	90                   	nop
  801134:	c9                   	leave  
  801135:	c3                   	ret    

00801136 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801136:	55                   	push   %ebp
  801137:	89 e5                	mov    %esp,%ebp
  801139:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  80113c:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801143:	00 00 00 
  801146:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80114d:	00 00 00 
  801150:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801157:	00 00 00 
		LIST_INIT(&AllocMemBlocksList);
  80115a:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801161:	00 00 00 
  801164:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80116b:	00 00 00 
  80116e:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801175:	00 00 00 

		MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES ;
  801178:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  80117f:	00 02 00 
		MemBlockNodes =(struct MemBlock*)USER_DYN_BLKS_ARRAY ;
  801182:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801189:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80118c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801191:	2d 00 10 00 00       	sub    $0x1000,%eax
  801196:	a3 50 40 80 00       	mov    %eax,0x804050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock),PAGE_SIZE),PERM_USER|PERM_WRITEABLE);
  80119b:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8011a2:	a1 20 41 80 00       	mov    0x804120,%eax
  8011a7:	c1 e0 04             	shl    $0x4,%eax
  8011aa:	89 c2                	mov    %eax,%edx
  8011ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011af:	01 d0                	add    %edx,%eax
  8011b1:	48                   	dec    %eax
  8011b2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8011b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8011bd:	f7 75 f0             	divl   -0x10(%ebp)
  8011c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011c3:	29 d0                	sub    %edx,%eax
  8011c5:	89 c2                	mov    %eax,%edx
  8011c7:	c7 45 e8 00 00 e0 7f 	movl   $0x7fe00000,-0x18(%ebp)
  8011ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8011d1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011d6:	2d 00 10 00 00       	sub    $0x1000,%eax
  8011db:	83 ec 04             	sub    $0x4,%esp
  8011de:	6a 06                	push   $0x6
  8011e0:	52                   	push   %edx
  8011e1:	50                   	push   %eax
  8011e2:	e8 71 05 00 00       	call   801758 <sys_allocate_chunk>
  8011e7:	83 c4 10             	add    $0x10,%esp
		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8011ea:	a1 20 41 80 00       	mov    0x804120,%eax
  8011ef:	83 ec 0c             	sub    $0xc,%esp
  8011f2:	50                   	push   %eax
  8011f3:	e8 e6 0b 00 00       	call   801dde <initialize_MemBlocksList>
  8011f8:	83 c4 10             	add    $0x10,%esp

		struct MemBlock  *block_node;
		block_node = AvailableMemBlocksList.lh_first;
  8011fb:	a1 48 41 80 00       	mov    0x804148,%eax
  801200:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&(AvailableMemBlocksList),block_node);
  801203:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801207:	75 14                	jne    80121d <initialize_dyn_block_system+0xe7>
  801209:	83 ec 04             	sub    $0x4,%esp
  80120c:	68 95 37 80 00       	push   $0x803795
  801211:	6a 2b                	push   $0x2b
  801213:	68 b3 37 80 00       	push   $0x8037b3
  801218:	e8 66 1c 00 00       	call   802e83 <_panic>
  80121d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801220:	8b 00                	mov    (%eax),%eax
  801222:	85 c0                	test   %eax,%eax
  801224:	74 10                	je     801236 <initialize_dyn_block_system+0x100>
  801226:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801229:	8b 00                	mov    (%eax),%eax
  80122b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80122e:	8b 52 04             	mov    0x4(%edx),%edx
  801231:	89 50 04             	mov    %edx,0x4(%eax)
  801234:	eb 0b                	jmp    801241 <initialize_dyn_block_system+0x10b>
  801236:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801239:	8b 40 04             	mov    0x4(%eax),%eax
  80123c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801241:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801244:	8b 40 04             	mov    0x4(%eax),%eax
  801247:	85 c0                	test   %eax,%eax
  801249:	74 0f                	je     80125a <initialize_dyn_block_system+0x124>
  80124b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80124e:	8b 40 04             	mov    0x4(%eax),%eax
  801251:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801254:	8b 12                	mov    (%edx),%edx
  801256:	89 10                	mov    %edx,(%eax)
  801258:	eb 0a                	jmp    801264 <initialize_dyn_block_system+0x12e>
  80125a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80125d:	8b 00                	mov    (%eax),%eax
  80125f:	a3 48 41 80 00       	mov    %eax,0x804148
  801264:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801267:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80126d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801270:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801277:	a1 54 41 80 00       	mov    0x804154,%eax
  80127c:	48                   	dec    %eax
  80127d:	a3 54 41 80 00       	mov    %eax,0x804154
		block_node->sva = USER_HEAP_START ;
  801282:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801285:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
		block_node->size = ((USER_HEAP_MAX - USER_HEAP_START));
  80128c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80128f:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		insert_sorted_with_merge_freeList(block_node);
  801296:	83 ec 0c             	sub    $0xc,%esp
  801299:	ff 75 e4             	pushl  -0x1c(%ebp)
  80129c:	e8 d2 13 00 00       	call   802673 <insert_sorted_with_merge_freeList>
  8012a1:	83 c4 10             	add    $0x10,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  8012a4:	90                   	nop
  8012a5:	c9                   	leave  
  8012a6:	c3                   	ret    

008012a7 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8012a7:	55                   	push   %ebp
  8012a8:	89 e5                	mov    %esp,%ebp
  8012aa:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8012ad:	e8 53 fe ff ff       	call   801105 <InitializeUHeap>
	if (size == 0) return NULL ;
  8012b2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012b6:	75 07                	jne    8012bf <malloc+0x18>
  8012b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8012bd:	eb 61                	jmp    801320 <malloc+0x79>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	size= ROUNDUP(size,PAGE_SIZE);
  8012bf:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8012c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8012c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012cc:	01 d0                	add    %edx,%eax
  8012ce:	48                   	dec    %eax
  8012cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8012d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8012da:	f7 75 f4             	divl   -0xc(%ebp)
  8012dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012e0:	29 d0                	sub    %edx,%eax
  8012e2:	89 45 08             	mov    %eax,0x8(%ebp)
	    			if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8012e5:	e8 3c 08 00 00       	call   801b26 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8012ea:	85 c0                	test   %eax,%eax
  8012ec:	74 2d                	je     80131b <malloc+0x74>
	    			{
	    				struct MemBlock * ff_block = alloc_block_FF(size);
  8012ee:	83 ec 0c             	sub    $0xc,%esp
  8012f1:	ff 75 08             	pushl  0x8(%ebp)
  8012f4:	e8 3e 0f 00 00       	call   802237 <alloc_block_FF>
  8012f9:	83 c4 10             	add    $0x10,%esp
  8012fc:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    				if(ff_block!=NULL)
  8012ff:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801303:	74 16                	je     80131b <malloc+0x74>
	    				{

	    					insert_sorted_allocList(ff_block);
  801305:	83 ec 0c             	sub    $0xc,%esp
  801308:	ff 75 ec             	pushl  -0x14(%ebp)
  80130b:	e8 48 0c 00 00       	call   801f58 <insert_sorted_allocList>
  801310:	83 c4 10             	add    $0x10,%esp
	    					return (void*) ff_block->sva ;
  801313:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801316:	8b 40 08             	mov    0x8(%eax),%eax
  801319:	eb 05                	jmp    801320 <malloc+0x79>

	    				}
	}
	    			return (void*) NULL ;
  80131b:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801320:	c9                   	leave  
  801321:	c3                   	ret    

00801322 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801322:	55                   	push   %ebp
  801323:	89 e5                	mov    %esp,%ebp
  801325:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock *elementForEach;
		virtual_address = ROUNDDOWN(virtual_address, PAGE_SIZE);
  801328:	8b 45 08             	mov    0x8(%ebp),%eax
  80132b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80132e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801331:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801336:	89 45 08             	mov    %eax,0x8(%ebp)
	//	if (is_mallocPages[indexindex((uint32) virtual_address)] == 1) {
		elementForEach = find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801339:	8b 45 08             	mov    0x8(%ebp),%eax
  80133c:	83 ec 08             	sub    $0x8,%esp
  80133f:	50                   	push   %eax
  801340:	68 40 40 80 00       	push   $0x804040
  801345:	e8 71 0b 00 00       	call   801ebb <find_block>
  80134a:	83 c4 10             	add    $0x10,%esp
  80134d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		sys_free_user_mem((uint32) virtual_address, elementForEach->size);
  801350:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801353:	8b 50 0c             	mov    0xc(%eax),%edx
  801356:	8b 45 08             	mov    0x8(%ebp),%eax
  801359:	83 ec 08             	sub    $0x8,%esp
  80135c:	52                   	push   %edx
  80135d:	50                   	push   %eax
  80135e:	e8 bd 03 00 00       	call   801720 <sys_free_user_mem>
  801363:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,elementForEach);
  801366:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80136a:	75 14                	jne    801380 <free+0x5e>
  80136c:	83 ec 04             	sub    $0x4,%esp
  80136f:	68 95 37 80 00       	push   $0x803795
  801374:	6a 71                	push   $0x71
  801376:	68 b3 37 80 00       	push   $0x8037b3
  80137b:	e8 03 1b 00 00       	call   802e83 <_panic>
  801380:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801383:	8b 00                	mov    (%eax),%eax
  801385:	85 c0                	test   %eax,%eax
  801387:	74 10                	je     801399 <free+0x77>
  801389:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80138c:	8b 00                	mov    (%eax),%eax
  80138e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801391:	8b 52 04             	mov    0x4(%edx),%edx
  801394:	89 50 04             	mov    %edx,0x4(%eax)
  801397:	eb 0b                	jmp    8013a4 <free+0x82>
  801399:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80139c:	8b 40 04             	mov    0x4(%eax),%eax
  80139f:	a3 44 40 80 00       	mov    %eax,0x804044
  8013a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013a7:	8b 40 04             	mov    0x4(%eax),%eax
  8013aa:	85 c0                	test   %eax,%eax
  8013ac:	74 0f                	je     8013bd <free+0x9b>
  8013ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013b1:	8b 40 04             	mov    0x4(%eax),%eax
  8013b4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013b7:	8b 12                	mov    (%edx),%edx
  8013b9:	89 10                	mov    %edx,(%eax)
  8013bb:	eb 0a                	jmp    8013c7 <free+0xa5>
  8013bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013c0:	8b 00                	mov    (%eax),%eax
  8013c2:	a3 40 40 80 00       	mov    %eax,0x804040
  8013c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8013d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013d3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8013da:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8013df:	48                   	dec    %eax
  8013e0:	a3 4c 40 80 00       	mov    %eax,0x80404c
		insert_sorted_with_merge_freeList(elementForEach);
  8013e5:	83 ec 0c             	sub    $0xc,%esp
  8013e8:	ff 75 f0             	pushl  -0x10(%ebp)
  8013eb:	e8 83 12 00 00       	call   802673 <insert_sorted_with_merge_freeList>
  8013f0:	83 c4 10             	add    $0x10,%esp
	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  8013f3:	90                   	nop
  8013f4:	c9                   	leave  
  8013f5:	c3                   	ret    

008013f6 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8013f6:	55                   	push   %ebp
  8013f7:	89 e5                	mov    %esp,%ebp
  8013f9:	83 ec 28             	sub    $0x28,%esp
  8013fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8013ff:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801402:	e8 fe fc ff ff       	call   801105 <InitializeUHeap>
	if (size == 0) return NULL ;
  801407:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80140b:	75 0a                	jne    801417 <smalloc+0x21>
  80140d:	b8 00 00 00 00       	mov    $0x0,%eax
  801412:	e9 86 00 00 00       	jmp    80149d <smalloc+0xa7>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code

	size=ROUNDUP(size,PAGE_SIZE);
  801417:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80141e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801421:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801424:	01 d0                	add    %edx,%eax
  801426:	48                   	dec    %eax
  801427:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80142a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80142d:	ba 00 00 00 00       	mov    $0x0,%edx
  801432:	f7 75 f4             	divl   -0xc(%ebp)
  801435:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801438:	29 d0                	sub    %edx,%eax
  80143a:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80143d:	e8 e4 06 00 00       	call   801b26 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801442:	85 c0                	test   %eax,%eax
  801444:	74 52                	je     801498 <smalloc+0xa2>
		{
		struct MemBlock * ff_block ;
		ff_block = alloc_block_FF(size);
  801446:	83 ec 0c             	sub    $0xc,%esp
  801449:	ff 75 0c             	pushl  0xc(%ebp)
  80144c:	e8 e6 0d 00 00       	call   802237 <alloc_block_FF>
  801451:	83 c4 10             	add    $0x10,%esp
  801454:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(ff_block==NULL)
  801457:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80145b:	75 07                	jne    801464 <smalloc+0x6e>
			return NULL ;
  80145d:	b8 00 00 00 00       	mov    $0x0,%eax
  801462:	eb 39                	jmp    80149d <smalloc+0xa7>

		int obj_id =sys_createSharedObject(sharedVarName,size,isWritable,(void*)ff_block->sva);
  801464:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801467:	8b 40 08             	mov    0x8(%eax),%eax
  80146a:	89 c2                	mov    %eax,%edx
  80146c:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801470:	52                   	push   %edx
  801471:	50                   	push   %eax
  801472:	ff 75 0c             	pushl  0xc(%ebp)
  801475:	ff 75 08             	pushl  0x8(%ebp)
  801478:	e8 2e 04 00 00       	call   8018ab <sys_createSharedObject>
  80147d:	83 c4 10             	add    $0x10,%esp
  801480:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(obj_id < 0)
  801483:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801487:	79 07                	jns    801490 <smalloc+0x9a>
			return (void*)NULL ;
  801489:	b8 00 00 00 00       	mov    $0x0,%eax
  80148e:	eb 0d                	jmp    80149d <smalloc+0xa7>
		else
		    return (void*)ff_block->sva ;
  801490:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801493:	8b 40 08             	mov    0x8(%eax),%eax
  801496:	eb 05                	jmp    80149d <smalloc+0xa7>
		}
		return (void*)NULL ;
  801498:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80149d:	c9                   	leave  
  80149e:	c3                   	ret    

0080149f <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80149f:	55                   	push   %ebp
  8014a0:	89 e5                	mov    %esp,%ebp
  8014a2:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014a5:	e8 5b fc ff ff       	call   801105 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8014aa:	83 ec 08             	sub    $0x8,%esp
  8014ad:	ff 75 0c             	pushl  0xc(%ebp)
  8014b0:	ff 75 08             	pushl  0x8(%ebp)
  8014b3:	e8 1d 04 00 00       	call   8018d5 <sys_getSizeOfSharedObject>
  8014b8:	83 c4 10             	add    $0x10,%esp
  8014bb:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(size == 0)
  8014be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8014c2:	75 0a                	jne    8014ce <sget+0x2f>
			return NULL ;
  8014c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c9:	e9 83 00 00 00       	jmp    801551 <sget+0xb2>
		size=ROUNDUP(size,PAGE_SIZE);
  8014ce:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8014d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014db:	01 d0                	add    %edx,%eax
  8014dd:	48                   	dec    %eax
  8014de:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8014e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8014e9:	f7 75 f0             	divl   -0x10(%ebp)
  8014ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014ef:	29 d0                	sub    %edx,%eax
  8014f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8014f4:	e8 2d 06 00 00       	call   801b26 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014f9:	85 c0                	test   %eax,%eax
  8014fb:	74 4f                	je     80154c <sget+0xad>
		{
			struct MemBlock * ff_block ;
				ff_block = alloc_block_FF(size);
  8014fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801500:	83 ec 0c             	sub    $0xc,%esp
  801503:	50                   	push   %eax
  801504:	e8 2e 0d 00 00       	call   802237 <alloc_block_FF>
  801509:	83 c4 10             	add    $0x10,%esp
  80150c:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ff_block==NULL)
  80150f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801513:	75 07                	jne    80151c <sget+0x7d>
					return (void*)NULL ;
  801515:	b8 00 00 00 00       	mov    $0x0,%eax
  80151a:	eb 35                	jmp    801551 <sget+0xb2>

		int obj_id =sys_getSharedObject((int)ownerEnvID,sharedVarName,(void*)ff_block->sva);
  80151c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80151f:	8b 40 08             	mov    0x8(%eax),%eax
  801522:	83 ec 04             	sub    $0x4,%esp
  801525:	50                   	push   %eax
  801526:	ff 75 0c             	pushl  0xc(%ebp)
  801529:	ff 75 08             	pushl  0x8(%ebp)
  80152c:	e8 c1 03 00 00       	call   8018f2 <sys_getSharedObject>
  801531:	83 c4 10             	add    $0x10,%esp
  801534:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if(obj_id<0)
  801537:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80153b:	79 07                	jns    801544 <sget+0xa5>
				return (void*)NULL ;
  80153d:	b8 00 00 00 00       	mov    $0x0,%eax
  801542:	eb 0d                	jmp    801551 <sget+0xb2>
			else
				return (void*)ff_block->sva ;
  801544:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801547:	8b 40 08             	mov    0x8(%eax),%eax
  80154a:	eb 05                	jmp    801551 <sget+0xb2>


		}
	return (void*)NULL ;
  80154c:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801551:	c9                   	leave  
  801552:	c3                   	ret    

00801553 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801553:	55                   	push   %ebp
  801554:	89 e5                	mov    %esp,%ebp
  801556:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801559:	e8 a7 fb ff ff       	call   801105 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80155e:	83 ec 04             	sub    $0x4,%esp
  801561:	68 c0 37 80 00       	push   $0x8037c0
  801566:	68 f9 00 00 00       	push   $0xf9
  80156b:	68 b3 37 80 00       	push   $0x8037b3
  801570:	e8 0e 19 00 00       	call   802e83 <_panic>

00801575 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801575:	55                   	push   %ebp
  801576:	89 e5                	mov    %esp,%ebp
  801578:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80157b:	83 ec 04             	sub    $0x4,%esp
  80157e:	68 e8 37 80 00       	push   $0x8037e8
  801583:	68 0d 01 00 00       	push   $0x10d
  801588:	68 b3 37 80 00       	push   $0x8037b3
  80158d:	e8 f1 18 00 00       	call   802e83 <_panic>

00801592 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801592:	55                   	push   %ebp
  801593:	89 e5                	mov    %esp,%ebp
  801595:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801598:	83 ec 04             	sub    $0x4,%esp
  80159b:	68 0c 38 80 00       	push   $0x80380c
  8015a0:	68 18 01 00 00       	push   $0x118
  8015a5:	68 b3 37 80 00       	push   $0x8037b3
  8015aa:	e8 d4 18 00 00       	call   802e83 <_panic>

008015af <shrink>:

}
void shrink(uint32 newSize)
{
  8015af:	55                   	push   %ebp
  8015b0:	89 e5                	mov    %esp,%ebp
  8015b2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015b5:	83 ec 04             	sub    $0x4,%esp
  8015b8:	68 0c 38 80 00       	push   $0x80380c
  8015bd:	68 1d 01 00 00       	push   $0x11d
  8015c2:	68 b3 37 80 00       	push   $0x8037b3
  8015c7:	e8 b7 18 00 00       	call   802e83 <_panic>

008015cc <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8015cc:	55                   	push   %ebp
  8015cd:	89 e5                	mov    %esp,%ebp
  8015cf:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015d2:	83 ec 04             	sub    $0x4,%esp
  8015d5:	68 0c 38 80 00       	push   $0x80380c
  8015da:	68 22 01 00 00       	push   $0x122
  8015df:	68 b3 37 80 00       	push   $0x8037b3
  8015e4:	e8 9a 18 00 00       	call   802e83 <_panic>

008015e9 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8015e9:	55                   	push   %ebp
  8015ea:	89 e5                	mov    %esp,%ebp
  8015ec:	57                   	push   %edi
  8015ed:	56                   	push   %esi
  8015ee:	53                   	push   %ebx
  8015ef:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015f8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015fb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015fe:	8b 7d 18             	mov    0x18(%ebp),%edi
  801601:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801604:	cd 30                	int    $0x30
  801606:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801609:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80160c:	83 c4 10             	add    $0x10,%esp
  80160f:	5b                   	pop    %ebx
  801610:	5e                   	pop    %esi
  801611:	5f                   	pop    %edi
  801612:	5d                   	pop    %ebp
  801613:	c3                   	ret    

00801614 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801614:	55                   	push   %ebp
  801615:	89 e5                	mov    %esp,%ebp
  801617:	83 ec 04             	sub    $0x4,%esp
  80161a:	8b 45 10             	mov    0x10(%ebp),%eax
  80161d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801620:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801624:	8b 45 08             	mov    0x8(%ebp),%eax
  801627:	6a 00                	push   $0x0
  801629:	6a 00                	push   $0x0
  80162b:	52                   	push   %edx
  80162c:	ff 75 0c             	pushl  0xc(%ebp)
  80162f:	50                   	push   %eax
  801630:	6a 00                	push   $0x0
  801632:	e8 b2 ff ff ff       	call   8015e9 <syscall>
  801637:	83 c4 18             	add    $0x18,%esp
}
  80163a:	90                   	nop
  80163b:	c9                   	leave  
  80163c:	c3                   	ret    

0080163d <sys_cgetc>:

int
sys_cgetc(void)
{
  80163d:	55                   	push   %ebp
  80163e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801640:	6a 00                	push   $0x0
  801642:	6a 00                	push   $0x0
  801644:	6a 00                	push   $0x0
  801646:	6a 00                	push   $0x0
  801648:	6a 00                	push   $0x0
  80164a:	6a 01                	push   $0x1
  80164c:	e8 98 ff ff ff       	call   8015e9 <syscall>
  801651:	83 c4 18             	add    $0x18,%esp
}
  801654:	c9                   	leave  
  801655:	c3                   	ret    

00801656 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801656:	55                   	push   %ebp
  801657:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801659:	8b 55 0c             	mov    0xc(%ebp),%edx
  80165c:	8b 45 08             	mov    0x8(%ebp),%eax
  80165f:	6a 00                	push   $0x0
  801661:	6a 00                	push   $0x0
  801663:	6a 00                	push   $0x0
  801665:	52                   	push   %edx
  801666:	50                   	push   %eax
  801667:	6a 05                	push   $0x5
  801669:	e8 7b ff ff ff       	call   8015e9 <syscall>
  80166e:	83 c4 18             	add    $0x18,%esp
}
  801671:	c9                   	leave  
  801672:	c3                   	ret    

00801673 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801673:	55                   	push   %ebp
  801674:	89 e5                	mov    %esp,%ebp
  801676:	56                   	push   %esi
  801677:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801678:	8b 75 18             	mov    0x18(%ebp),%esi
  80167b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80167e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801681:	8b 55 0c             	mov    0xc(%ebp),%edx
  801684:	8b 45 08             	mov    0x8(%ebp),%eax
  801687:	56                   	push   %esi
  801688:	53                   	push   %ebx
  801689:	51                   	push   %ecx
  80168a:	52                   	push   %edx
  80168b:	50                   	push   %eax
  80168c:	6a 06                	push   $0x6
  80168e:	e8 56 ff ff ff       	call   8015e9 <syscall>
  801693:	83 c4 18             	add    $0x18,%esp
}
  801696:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801699:	5b                   	pop    %ebx
  80169a:	5e                   	pop    %esi
  80169b:	5d                   	pop    %ebp
  80169c:	c3                   	ret    

0080169d <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80169d:	55                   	push   %ebp
  80169e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8016a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a6:	6a 00                	push   $0x0
  8016a8:	6a 00                	push   $0x0
  8016aa:	6a 00                	push   $0x0
  8016ac:	52                   	push   %edx
  8016ad:	50                   	push   %eax
  8016ae:	6a 07                	push   $0x7
  8016b0:	e8 34 ff ff ff       	call   8015e9 <syscall>
  8016b5:	83 c4 18             	add    $0x18,%esp
}
  8016b8:	c9                   	leave  
  8016b9:	c3                   	ret    

008016ba <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8016ba:	55                   	push   %ebp
  8016bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8016bd:	6a 00                	push   $0x0
  8016bf:	6a 00                	push   $0x0
  8016c1:	6a 00                	push   $0x0
  8016c3:	ff 75 0c             	pushl  0xc(%ebp)
  8016c6:	ff 75 08             	pushl  0x8(%ebp)
  8016c9:	6a 08                	push   $0x8
  8016cb:	e8 19 ff ff ff       	call   8015e9 <syscall>
  8016d0:	83 c4 18             	add    $0x18,%esp
}
  8016d3:	c9                   	leave  
  8016d4:	c3                   	ret    

008016d5 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8016d5:	55                   	push   %ebp
  8016d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8016d8:	6a 00                	push   $0x0
  8016da:	6a 00                	push   $0x0
  8016dc:	6a 00                	push   $0x0
  8016de:	6a 00                	push   $0x0
  8016e0:	6a 00                	push   $0x0
  8016e2:	6a 09                	push   $0x9
  8016e4:	e8 00 ff ff ff       	call   8015e9 <syscall>
  8016e9:	83 c4 18             	add    $0x18,%esp
}
  8016ec:	c9                   	leave  
  8016ed:	c3                   	ret    

008016ee <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8016ee:	55                   	push   %ebp
  8016ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8016f1:	6a 00                	push   $0x0
  8016f3:	6a 00                	push   $0x0
  8016f5:	6a 00                	push   $0x0
  8016f7:	6a 00                	push   $0x0
  8016f9:	6a 00                	push   $0x0
  8016fb:	6a 0a                	push   $0xa
  8016fd:	e8 e7 fe ff ff       	call   8015e9 <syscall>
  801702:	83 c4 18             	add    $0x18,%esp
}
  801705:	c9                   	leave  
  801706:	c3                   	ret    

00801707 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801707:	55                   	push   %ebp
  801708:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80170a:	6a 00                	push   $0x0
  80170c:	6a 00                	push   $0x0
  80170e:	6a 00                	push   $0x0
  801710:	6a 00                	push   $0x0
  801712:	6a 00                	push   $0x0
  801714:	6a 0b                	push   $0xb
  801716:	e8 ce fe ff ff       	call   8015e9 <syscall>
  80171b:	83 c4 18             	add    $0x18,%esp
}
  80171e:	c9                   	leave  
  80171f:	c3                   	ret    

00801720 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801720:	55                   	push   %ebp
  801721:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801723:	6a 00                	push   $0x0
  801725:	6a 00                	push   $0x0
  801727:	6a 00                	push   $0x0
  801729:	ff 75 0c             	pushl  0xc(%ebp)
  80172c:	ff 75 08             	pushl  0x8(%ebp)
  80172f:	6a 0f                	push   $0xf
  801731:	e8 b3 fe ff ff       	call   8015e9 <syscall>
  801736:	83 c4 18             	add    $0x18,%esp
	return;
  801739:	90                   	nop
}
  80173a:	c9                   	leave  
  80173b:	c3                   	ret    

0080173c <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80173c:	55                   	push   %ebp
  80173d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80173f:	6a 00                	push   $0x0
  801741:	6a 00                	push   $0x0
  801743:	6a 00                	push   $0x0
  801745:	ff 75 0c             	pushl  0xc(%ebp)
  801748:	ff 75 08             	pushl  0x8(%ebp)
  80174b:	6a 10                	push   $0x10
  80174d:	e8 97 fe ff ff       	call   8015e9 <syscall>
  801752:	83 c4 18             	add    $0x18,%esp
	return ;
  801755:	90                   	nop
}
  801756:	c9                   	leave  
  801757:	c3                   	ret    

00801758 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801758:	55                   	push   %ebp
  801759:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80175b:	6a 00                	push   $0x0
  80175d:	6a 00                	push   $0x0
  80175f:	ff 75 10             	pushl  0x10(%ebp)
  801762:	ff 75 0c             	pushl  0xc(%ebp)
  801765:	ff 75 08             	pushl  0x8(%ebp)
  801768:	6a 11                	push   $0x11
  80176a:	e8 7a fe ff ff       	call   8015e9 <syscall>
  80176f:	83 c4 18             	add    $0x18,%esp
	return ;
  801772:	90                   	nop
}
  801773:	c9                   	leave  
  801774:	c3                   	ret    

00801775 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801775:	55                   	push   %ebp
  801776:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801778:	6a 00                	push   $0x0
  80177a:	6a 00                	push   $0x0
  80177c:	6a 00                	push   $0x0
  80177e:	6a 00                	push   $0x0
  801780:	6a 00                	push   $0x0
  801782:	6a 0c                	push   $0xc
  801784:	e8 60 fe ff ff       	call   8015e9 <syscall>
  801789:	83 c4 18             	add    $0x18,%esp
}
  80178c:	c9                   	leave  
  80178d:	c3                   	ret    

0080178e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80178e:	55                   	push   %ebp
  80178f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801791:	6a 00                	push   $0x0
  801793:	6a 00                	push   $0x0
  801795:	6a 00                	push   $0x0
  801797:	6a 00                	push   $0x0
  801799:	ff 75 08             	pushl  0x8(%ebp)
  80179c:	6a 0d                	push   $0xd
  80179e:	e8 46 fe ff ff       	call   8015e9 <syscall>
  8017a3:	83 c4 18             	add    $0x18,%esp
}
  8017a6:	c9                   	leave  
  8017a7:	c3                   	ret    

008017a8 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8017a8:	55                   	push   %ebp
  8017a9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8017ab:	6a 00                	push   $0x0
  8017ad:	6a 00                	push   $0x0
  8017af:	6a 00                	push   $0x0
  8017b1:	6a 00                	push   $0x0
  8017b3:	6a 00                	push   $0x0
  8017b5:	6a 0e                	push   $0xe
  8017b7:	e8 2d fe ff ff       	call   8015e9 <syscall>
  8017bc:	83 c4 18             	add    $0x18,%esp
}
  8017bf:	90                   	nop
  8017c0:	c9                   	leave  
  8017c1:	c3                   	ret    

008017c2 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8017c2:	55                   	push   %ebp
  8017c3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8017c5:	6a 00                	push   $0x0
  8017c7:	6a 00                	push   $0x0
  8017c9:	6a 00                	push   $0x0
  8017cb:	6a 00                	push   $0x0
  8017cd:	6a 00                	push   $0x0
  8017cf:	6a 13                	push   $0x13
  8017d1:	e8 13 fe ff ff       	call   8015e9 <syscall>
  8017d6:	83 c4 18             	add    $0x18,%esp
}
  8017d9:	90                   	nop
  8017da:	c9                   	leave  
  8017db:	c3                   	ret    

008017dc <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8017dc:	55                   	push   %ebp
  8017dd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8017df:	6a 00                	push   $0x0
  8017e1:	6a 00                	push   $0x0
  8017e3:	6a 00                	push   $0x0
  8017e5:	6a 00                	push   $0x0
  8017e7:	6a 00                	push   $0x0
  8017e9:	6a 14                	push   $0x14
  8017eb:	e8 f9 fd ff ff       	call   8015e9 <syscall>
  8017f0:	83 c4 18             	add    $0x18,%esp
}
  8017f3:	90                   	nop
  8017f4:	c9                   	leave  
  8017f5:	c3                   	ret    

008017f6 <sys_cputc>:


void
sys_cputc(const char c)
{
  8017f6:	55                   	push   %ebp
  8017f7:	89 e5                	mov    %esp,%ebp
  8017f9:	83 ec 04             	sub    $0x4,%esp
  8017fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ff:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801802:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801806:	6a 00                	push   $0x0
  801808:	6a 00                	push   $0x0
  80180a:	6a 00                	push   $0x0
  80180c:	6a 00                	push   $0x0
  80180e:	50                   	push   %eax
  80180f:	6a 15                	push   $0x15
  801811:	e8 d3 fd ff ff       	call   8015e9 <syscall>
  801816:	83 c4 18             	add    $0x18,%esp
}
  801819:	90                   	nop
  80181a:	c9                   	leave  
  80181b:	c3                   	ret    

0080181c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80181c:	55                   	push   %ebp
  80181d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80181f:	6a 00                	push   $0x0
  801821:	6a 00                	push   $0x0
  801823:	6a 00                	push   $0x0
  801825:	6a 00                	push   $0x0
  801827:	6a 00                	push   $0x0
  801829:	6a 16                	push   $0x16
  80182b:	e8 b9 fd ff ff       	call   8015e9 <syscall>
  801830:	83 c4 18             	add    $0x18,%esp
}
  801833:	90                   	nop
  801834:	c9                   	leave  
  801835:	c3                   	ret    

00801836 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801836:	55                   	push   %ebp
  801837:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801839:	8b 45 08             	mov    0x8(%ebp),%eax
  80183c:	6a 00                	push   $0x0
  80183e:	6a 00                	push   $0x0
  801840:	6a 00                	push   $0x0
  801842:	ff 75 0c             	pushl  0xc(%ebp)
  801845:	50                   	push   %eax
  801846:	6a 17                	push   $0x17
  801848:	e8 9c fd ff ff       	call   8015e9 <syscall>
  80184d:	83 c4 18             	add    $0x18,%esp
}
  801850:	c9                   	leave  
  801851:	c3                   	ret    

00801852 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801852:	55                   	push   %ebp
  801853:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801855:	8b 55 0c             	mov    0xc(%ebp),%edx
  801858:	8b 45 08             	mov    0x8(%ebp),%eax
  80185b:	6a 00                	push   $0x0
  80185d:	6a 00                	push   $0x0
  80185f:	6a 00                	push   $0x0
  801861:	52                   	push   %edx
  801862:	50                   	push   %eax
  801863:	6a 1a                	push   $0x1a
  801865:	e8 7f fd ff ff       	call   8015e9 <syscall>
  80186a:	83 c4 18             	add    $0x18,%esp
}
  80186d:	c9                   	leave  
  80186e:	c3                   	ret    

0080186f <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80186f:	55                   	push   %ebp
  801870:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801872:	8b 55 0c             	mov    0xc(%ebp),%edx
  801875:	8b 45 08             	mov    0x8(%ebp),%eax
  801878:	6a 00                	push   $0x0
  80187a:	6a 00                	push   $0x0
  80187c:	6a 00                	push   $0x0
  80187e:	52                   	push   %edx
  80187f:	50                   	push   %eax
  801880:	6a 18                	push   $0x18
  801882:	e8 62 fd ff ff       	call   8015e9 <syscall>
  801887:	83 c4 18             	add    $0x18,%esp
}
  80188a:	90                   	nop
  80188b:	c9                   	leave  
  80188c:	c3                   	ret    

0080188d <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80188d:	55                   	push   %ebp
  80188e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801890:	8b 55 0c             	mov    0xc(%ebp),%edx
  801893:	8b 45 08             	mov    0x8(%ebp),%eax
  801896:	6a 00                	push   $0x0
  801898:	6a 00                	push   $0x0
  80189a:	6a 00                	push   $0x0
  80189c:	52                   	push   %edx
  80189d:	50                   	push   %eax
  80189e:	6a 19                	push   $0x19
  8018a0:	e8 44 fd ff ff       	call   8015e9 <syscall>
  8018a5:	83 c4 18             	add    $0x18,%esp
}
  8018a8:	90                   	nop
  8018a9:	c9                   	leave  
  8018aa:	c3                   	ret    

008018ab <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8018ab:	55                   	push   %ebp
  8018ac:	89 e5                	mov    %esp,%ebp
  8018ae:	83 ec 04             	sub    $0x4,%esp
  8018b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8018b4:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8018b7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018ba:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018be:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c1:	6a 00                	push   $0x0
  8018c3:	51                   	push   %ecx
  8018c4:	52                   	push   %edx
  8018c5:	ff 75 0c             	pushl  0xc(%ebp)
  8018c8:	50                   	push   %eax
  8018c9:	6a 1b                	push   $0x1b
  8018cb:	e8 19 fd ff ff       	call   8015e9 <syscall>
  8018d0:	83 c4 18             	add    $0x18,%esp
}
  8018d3:	c9                   	leave  
  8018d4:	c3                   	ret    

008018d5 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8018d5:	55                   	push   %ebp
  8018d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8018d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018db:	8b 45 08             	mov    0x8(%ebp),%eax
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	52                   	push   %edx
  8018e5:	50                   	push   %eax
  8018e6:	6a 1c                	push   $0x1c
  8018e8:	e8 fc fc ff ff       	call   8015e9 <syscall>
  8018ed:	83 c4 18             	add    $0x18,%esp
}
  8018f0:	c9                   	leave  
  8018f1:	c3                   	ret    

008018f2 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8018f2:	55                   	push   %ebp
  8018f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8018f5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	51                   	push   %ecx
  801903:	52                   	push   %edx
  801904:	50                   	push   %eax
  801905:	6a 1d                	push   $0x1d
  801907:	e8 dd fc ff ff       	call   8015e9 <syscall>
  80190c:	83 c4 18             	add    $0x18,%esp
}
  80190f:	c9                   	leave  
  801910:	c3                   	ret    

00801911 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801911:	55                   	push   %ebp
  801912:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801914:	8b 55 0c             	mov    0xc(%ebp),%edx
  801917:	8b 45 08             	mov    0x8(%ebp),%eax
  80191a:	6a 00                	push   $0x0
  80191c:	6a 00                	push   $0x0
  80191e:	6a 00                	push   $0x0
  801920:	52                   	push   %edx
  801921:	50                   	push   %eax
  801922:	6a 1e                	push   $0x1e
  801924:	e8 c0 fc ff ff       	call   8015e9 <syscall>
  801929:	83 c4 18             	add    $0x18,%esp
}
  80192c:	c9                   	leave  
  80192d:	c3                   	ret    

0080192e <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80192e:	55                   	push   %ebp
  80192f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801931:	6a 00                	push   $0x0
  801933:	6a 00                	push   $0x0
  801935:	6a 00                	push   $0x0
  801937:	6a 00                	push   $0x0
  801939:	6a 00                	push   $0x0
  80193b:	6a 1f                	push   $0x1f
  80193d:	e8 a7 fc ff ff       	call   8015e9 <syscall>
  801942:	83 c4 18             	add    $0x18,%esp
}
  801945:	c9                   	leave  
  801946:	c3                   	ret    

00801947 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801947:	55                   	push   %ebp
  801948:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80194a:	8b 45 08             	mov    0x8(%ebp),%eax
  80194d:	6a 00                	push   $0x0
  80194f:	ff 75 14             	pushl  0x14(%ebp)
  801952:	ff 75 10             	pushl  0x10(%ebp)
  801955:	ff 75 0c             	pushl  0xc(%ebp)
  801958:	50                   	push   %eax
  801959:	6a 20                	push   $0x20
  80195b:	e8 89 fc ff ff       	call   8015e9 <syscall>
  801960:	83 c4 18             	add    $0x18,%esp
}
  801963:	c9                   	leave  
  801964:	c3                   	ret    

00801965 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801965:	55                   	push   %ebp
  801966:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801968:	8b 45 08             	mov    0x8(%ebp),%eax
  80196b:	6a 00                	push   $0x0
  80196d:	6a 00                	push   $0x0
  80196f:	6a 00                	push   $0x0
  801971:	6a 00                	push   $0x0
  801973:	50                   	push   %eax
  801974:	6a 21                	push   $0x21
  801976:	e8 6e fc ff ff       	call   8015e9 <syscall>
  80197b:	83 c4 18             	add    $0x18,%esp
}
  80197e:	90                   	nop
  80197f:	c9                   	leave  
  801980:	c3                   	ret    

00801981 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801981:	55                   	push   %ebp
  801982:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801984:	8b 45 08             	mov    0x8(%ebp),%eax
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	6a 00                	push   $0x0
  80198f:	50                   	push   %eax
  801990:	6a 22                	push   $0x22
  801992:	e8 52 fc ff ff       	call   8015e9 <syscall>
  801997:	83 c4 18             	add    $0x18,%esp
}
  80199a:	c9                   	leave  
  80199b:	c3                   	ret    

0080199c <sys_getenvid>:

int32 sys_getenvid(void)
{
  80199c:	55                   	push   %ebp
  80199d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 02                	push   $0x2
  8019ab:	e8 39 fc ff ff       	call   8015e9 <syscall>
  8019b0:	83 c4 18             	add    $0x18,%esp
}
  8019b3:	c9                   	leave  
  8019b4:	c3                   	ret    

008019b5 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8019b5:	55                   	push   %ebp
  8019b6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 03                	push   $0x3
  8019c4:	e8 20 fc ff ff       	call   8015e9 <syscall>
  8019c9:	83 c4 18             	add    $0x18,%esp
}
  8019cc:	c9                   	leave  
  8019cd:	c3                   	ret    

008019ce <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8019ce:	55                   	push   %ebp
  8019cf:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 04                	push   $0x4
  8019dd:	e8 07 fc ff ff       	call   8015e9 <syscall>
  8019e2:	83 c4 18             	add    $0x18,%esp
}
  8019e5:	c9                   	leave  
  8019e6:	c3                   	ret    

008019e7 <sys_exit_env>:


void sys_exit_env(void)
{
  8019e7:	55                   	push   %ebp
  8019e8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 23                	push   $0x23
  8019f6:	e8 ee fb ff ff       	call   8015e9 <syscall>
  8019fb:	83 c4 18             	add    $0x18,%esp
}
  8019fe:	90                   	nop
  8019ff:	c9                   	leave  
  801a00:	c3                   	ret    

00801a01 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801a01:	55                   	push   %ebp
  801a02:	89 e5                	mov    %esp,%ebp
  801a04:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a07:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a0a:	8d 50 04             	lea    0x4(%eax),%edx
  801a0d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	52                   	push   %edx
  801a17:	50                   	push   %eax
  801a18:	6a 24                	push   $0x24
  801a1a:	e8 ca fb ff ff       	call   8015e9 <syscall>
  801a1f:	83 c4 18             	add    $0x18,%esp
	return result;
  801a22:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a25:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a28:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a2b:	89 01                	mov    %eax,(%ecx)
  801a2d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801a30:	8b 45 08             	mov    0x8(%ebp),%eax
  801a33:	c9                   	leave  
  801a34:	c2 04 00             	ret    $0x4

00801a37 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801a37:	55                   	push   %ebp
  801a38:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801a3a:	6a 00                	push   $0x0
  801a3c:	6a 00                	push   $0x0
  801a3e:	ff 75 10             	pushl  0x10(%ebp)
  801a41:	ff 75 0c             	pushl  0xc(%ebp)
  801a44:	ff 75 08             	pushl  0x8(%ebp)
  801a47:	6a 12                	push   $0x12
  801a49:	e8 9b fb ff ff       	call   8015e9 <syscall>
  801a4e:	83 c4 18             	add    $0x18,%esp
	return ;
  801a51:	90                   	nop
}
  801a52:	c9                   	leave  
  801a53:	c3                   	ret    

00801a54 <sys_rcr2>:
uint32 sys_rcr2()
{
  801a54:	55                   	push   %ebp
  801a55:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801a57:	6a 00                	push   $0x0
  801a59:	6a 00                	push   $0x0
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 25                	push   $0x25
  801a63:	e8 81 fb ff ff       	call   8015e9 <syscall>
  801a68:	83 c4 18             	add    $0x18,%esp
}
  801a6b:	c9                   	leave  
  801a6c:	c3                   	ret    

00801a6d <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801a6d:	55                   	push   %ebp
  801a6e:	89 e5                	mov    %esp,%ebp
  801a70:	83 ec 04             	sub    $0x4,%esp
  801a73:	8b 45 08             	mov    0x8(%ebp),%eax
  801a76:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801a79:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	50                   	push   %eax
  801a86:	6a 26                	push   $0x26
  801a88:	e8 5c fb ff ff       	call   8015e9 <syscall>
  801a8d:	83 c4 18             	add    $0x18,%esp
	return ;
  801a90:	90                   	nop
}
  801a91:	c9                   	leave  
  801a92:	c3                   	ret    

00801a93 <rsttst>:
void rsttst()
{
  801a93:	55                   	push   %ebp
  801a94:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 28                	push   $0x28
  801aa2:	e8 42 fb ff ff       	call   8015e9 <syscall>
  801aa7:	83 c4 18             	add    $0x18,%esp
	return ;
  801aaa:	90                   	nop
}
  801aab:	c9                   	leave  
  801aac:	c3                   	ret    

00801aad <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801aad:	55                   	push   %ebp
  801aae:	89 e5                	mov    %esp,%ebp
  801ab0:	83 ec 04             	sub    $0x4,%esp
  801ab3:	8b 45 14             	mov    0x14(%ebp),%eax
  801ab6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ab9:	8b 55 18             	mov    0x18(%ebp),%edx
  801abc:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ac0:	52                   	push   %edx
  801ac1:	50                   	push   %eax
  801ac2:	ff 75 10             	pushl  0x10(%ebp)
  801ac5:	ff 75 0c             	pushl  0xc(%ebp)
  801ac8:	ff 75 08             	pushl  0x8(%ebp)
  801acb:	6a 27                	push   $0x27
  801acd:	e8 17 fb ff ff       	call   8015e9 <syscall>
  801ad2:	83 c4 18             	add    $0x18,%esp
	return ;
  801ad5:	90                   	nop
}
  801ad6:	c9                   	leave  
  801ad7:	c3                   	ret    

00801ad8 <chktst>:
void chktst(uint32 n)
{
  801ad8:	55                   	push   %ebp
  801ad9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 00                	push   $0x0
  801ae3:	ff 75 08             	pushl  0x8(%ebp)
  801ae6:	6a 29                	push   $0x29
  801ae8:	e8 fc fa ff ff       	call   8015e9 <syscall>
  801aed:	83 c4 18             	add    $0x18,%esp
	return ;
  801af0:	90                   	nop
}
  801af1:	c9                   	leave  
  801af2:	c3                   	ret    

00801af3 <inctst>:

void inctst()
{
  801af3:	55                   	push   %ebp
  801af4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	6a 00                	push   $0x0
  801afe:	6a 00                	push   $0x0
  801b00:	6a 2a                	push   $0x2a
  801b02:	e8 e2 fa ff ff       	call   8015e9 <syscall>
  801b07:	83 c4 18             	add    $0x18,%esp
	return ;
  801b0a:	90                   	nop
}
  801b0b:	c9                   	leave  
  801b0c:	c3                   	ret    

00801b0d <gettst>:
uint32 gettst()
{
  801b0d:	55                   	push   %ebp
  801b0e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 2b                	push   $0x2b
  801b1c:	e8 c8 fa ff ff       	call   8015e9 <syscall>
  801b21:	83 c4 18             	add    $0x18,%esp
}
  801b24:	c9                   	leave  
  801b25:	c3                   	ret    

00801b26 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801b26:	55                   	push   %ebp
  801b27:	89 e5                	mov    %esp,%ebp
  801b29:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 00                	push   $0x0
  801b32:	6a 00                	push   $0x0
  801b34:	6a 00                	push   $0x0
  801b36:	6a 2c                	push   $0x2c
  801b38:	e8 ac fa ff ff       	call   8015e9 <syscall>
  801b3d:	83 c4 18             	add    $0x18,%esp
  801b40:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801b43:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801b47:	75 07                	jne    801b50 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801b49:	b8 01 00 00 00       	mov    $0x1,%eax
  801b4e:	eb 05                	jmp    801b55 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801b50:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b55:	c9                   	leave  
  801b56:	c3                   	ret    

00801b57 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801b57:	55                   	push   %ebp
  801b58:	89 e5                	mov    %esp,%ebp
  801b5a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b5d:	6a 00                	push   $0x0
  801b5f:	6a 00                	push   $0x0
  801b61:	6a 00                	push   $0x0
  801b63:	6a 00                	push   $0x0
  801b65:	6a 00                	push   $0x0
  801b67:	6a 2c                	push   $0x2c
  801b69:	e8 7b fa ff ff       	call   8015e9 <syscall>
  801b6e:	83 c4 18             	add    $0x18,%esp
  801b71:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801b74:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801b78:	75 07                	jne    801b81 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801b7a:	b8 01 00 00 00       	mov    $0x1,%eax
  801b7f:	eb 05                	jmp    801b86 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801b81:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b86:	c9                   	leave  
  801b87:	c3                   	ret    

00801b88 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801b88:	55                   	push   %ebp
  801b89:	89 e5                	mov    %esp,%ebp
  801b8b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	6a 2c                	push   $0x2c
  801b9a:	e8 4a fa ff ff       	call   8015e9 <syscall>
  801b9f:	83 c4 18             	add    $0x18,%esp
  801ba2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801ba5:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801ba9:	75 07                	jne    801bb2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801bab:	b8 01 00 00 00       	mov    $0x1,%eax
  801bb0:	eb 05                	jmp    801bb7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801bb2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bb7:	c9                   	leave  
  801bb8:	c3                   	ret    

00801bb9 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801bb9:	55                   	push   %ebp
  801bba:	89 e5                	mov    %esp,%ebp
  801bbc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 2c                	push   $0x2c
  801bcb:	e8 19 fa ff ff       	call   8015e9 <syscall>
  801bd0:	83 c4 18             	add    $0x18,%esp
  801bd3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801bd6:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801bda:	75 07                	jne    801be3 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801bdc:	b8 01 00 00 00       	mov    $0x1,%eax
  801be1:	eb 05                	jmp    801be8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801be3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801be8:	c9                   	leave  
  801be9:	c3                   	ret    

00801bea <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801bea:	55                   	push   %ebp
  801beb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 00                	push   $0x0
  801bf5:	ff 75 08             	pushl  0x8(%ebp)
  801bf8:	6a 2d                	push   $0x2d
  801bfa:	e8 ea f9 ff ff       	call   8015e9 <syscall>
  801bff:	83 c4 18             	add    $0x18,%esp
	return ;
  801c02:	90                   	nop
}
  801c03:	c9                   	leave  
  801c04:	c3                   	ret    

00801c05 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c05:	55                   	push   %ebp
  801c06:	89 e5                	mov    %esp,%ebp
  801c08:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c09:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c0c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c0f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c12:	8b 45 08             	mov    0x8(%ebp),%eax
  801c15:	6a 00                	push   $0x0
  801c17:	53                   	push   %ebx
  801c18:	51                   	push   %ecx
  801c19:	52                   	push   %edx
  801c1a:	50                   	push   %eax
  801c1b:	6a 2e                	push   $0x2e
  801c1d:	e8 c7 f9 ff ff       	call   8015e9 <syscall>
  801c22:	83 c4 18             	add    $0x18,%esp
}
  801c25:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c28:	c9                   	leave  
  801c29:	c3                   	ret    

00801c2a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801c2a:	55                   	push   %ebp
  801c2b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801c2d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c30:	8b 45 08             	mov    0x8(%ebp),%eax
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	52                   	push   %edx
  801c3a:	50                   	push   %eax
  801c3b:	6a 2f                	push   $0x2f
  801c3d:	e8 a7 f9 ff ff       	call   8015e9 <syscall>
  801c42:	83 c4 18             	add    $0x18,%esp
}
  801c45:	c9                   	leave  
  801c46:	c3                   	ret    

00801c47 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801c47:	55                   	push   %ebp
  801c48:	89 e5                	mov    %esp,%ebp
  801c4a:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801c4d:	83 ec 0c             	sub    $0xc,%esp
  801c50:	68 1c 38 80 00       	push   $0x80381c
  801c55:	e8 21 e7 ff ff       	call   80037b <cprintf>
  801c5a:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801c5d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801c64:	83 ec 0c             	sub    $0xc,%esp
  801c67:	68 48 38 80 00       	push   $0x803848
  801c6c:	e8 0a e7 ff ff       	call   80037b <cprintf>
  801c71:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801c74:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801c78:	a1 38 41 80 00       	mov    0x804138,%eax
  801c7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c80:	eb 56                	jmp    801cd8 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801c82:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c86:	74 1c                	je     801ca4 <print_mem_block_lists+0x5d>
  801c88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c8b:	8b 50 08             	mov    0x8(%eax),%edx
  801c8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c91:	8b 48 08             	mov    0x8(%eax),%ecx
  801c94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c97:	8b 40 0c             	mov    0xc(%eax),%eax
  801c9a:	01 c8                	add    %ecx,%eax
  801c9c:	39 c2                	cmp    %eax,%edx
  801c9e:	73 04                	jae    801ca4 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801ca0:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801ca4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ca7:	8b 50 08             	mov    0x8(%eax),%edx
  801caa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cad:	8b 40 0c             	mov    0xc(%eax),%eax
  801cb0:	01 c2                	add    %eax,%edx
  801cb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cb5:	8b 40 08             	mov    0x8(%eax),%eax
  801cb8:	83 ec 04             	sub    $0x4,%esp
  801cbb:	52                   	push   %edx
  801cbc:	50                   	push   %eax
  801cbd:	68 5d 38 80 00       	push   $0x80385d
  801cc2:	e8 b4 e6 ff ff       	call   80037b <cprintf>
  801cc7:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801cca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ccd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801cd0:	a1 40 41 80 00       	mov    0x804140,%eax
  801cd5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801cd8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801cdc:	74 07                	je     801ce5 <print_mem_block_lists+0x9e>
  801cde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ce1:	8b 00                	mov    (%eax),%eax
  801ce3:	eb 05                	jmp    801cea <print_mem_block_lists+0xa3>
  801ce5:	b8 00 00 00 00       	mov    $0x0,%eax
  801cea:	a3 40 41 80 00       	mov    %eax,0x804140
  801cef:	a1 40 41 80 00       	mov    0x804140,%eax
  801cf4:	85 c0                	test   %eax,%eax
  801cf6:	75 8a                	jne    801c82 <print_mem_block_lists+0x3b>
  801cf8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801cfc:	75 84                	jne    801c82 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801cfe:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801d02:	75 10                	jne    801d14 <print_mem_block_lists+0xcd>
  801d04:	83 ec 0c             	sub    $0xc,%esp
  801d07:	68 6c 38 80 00       	push   $0x80386c
  801d0c:	e8 6a e6 ff ff       	call   80037b <cprintf>
  801d11:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801d14:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801d1b:	83 ec 0c             	sub    $0xc,%esp
  801d1e:	68 90 38 80 00       	push   $0x803890
  801d23:	e8 53 e6 ff ff       	call   80037b <cprintf>
  801d28:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801d2b:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801d2f:	a1 40 40 80 00       	mov    0x804040,%eax
  801d34:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d37:	eb 56                	jmp    801d8f <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801d39:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d3d:	74 1c                	je     801d5b <print_mem_block_lists+0x114>
  801d3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d42:	8b 50 08             	mov    0x8(%eax),%edx
  801d45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d48:	8b 48 08             	mov    0x8(%eax),%ecx
  801d4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d4e:	8b 40 0c             	mov    0xc(%eax),%eax
  801d51:	01 c8                	add    %ecx,%eax
  801d53:	39 c2                	cmp    %eax,%edx
  801d55:	73 04                	jae    801d5b <print_mem_block_lists+0x114>
			sorted = 0 ;
  801d57:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801d5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d5e:	8b 50 08             	mov    0x8(%eax),%edx
  801d61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d64:	8b 40 0c             	mov    0xc(%eax),%eax
  801d67:	01 c2                	add    %eax,%edx
  801d69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d6c:	8b 40 08             	mov    0x8(%eax),%eax
  801d6f:	83 ec 04             	sub    $0x4,%esp
  801d72:	52                   	push   %edx
  801d73:	50                   	push   %eax
  801d74:	68 5d 38 80 00       	push   $0x80385d
  801d79:	e8 fd e5 ff ff       	call   80037b <cprintf>
  801d7e:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801d81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d84:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801d87:	a1 48 40 80 00       	mov    0x804048,%eax
  801d8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d8f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d93:	74 07                	je     801d9c <print_mem_block_lists+0x155>
  801d95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d98:	8b 00                	mov    (%eax),%eax
  801d9a:	eb 05                	jmp    801da1 <print_mem_block_lists+0x15a>
  801d9c:	b8 00 00 00 00       	mov    $0x0,%eax
  801da1:	a3 48 40 80 00       	mov    %eax,0x804048
  801da6:	a1 48 40 80 00       	mov    0x804048,%eax
  801dab:	85 c0                	test   %eax,%eax
  801dad:	75 8a                	jne    801d39 <print_mem_block_lists+0xf2>
  801daf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801db3:	75 84                	jne    801d39 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801db5:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801db9:	75 10                	jne    801dcb <print_mem_block_lists+0x184>
  801dbb:	83 ec 0c             	sub    $0xc,%esp
  801dbe:	68 a8 38 80 00       	push   $0x8038a8
  801dc3:	e8 b3 e5 ff ff       	call   80037b <cprintf>
  801dc8:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801dcb:	83 ec 0c             	sub    $0xc,%esp
  801dce:	68 1c 38 80 00       	push   $0x80381c
  801dd3:	e8 a3 e5 ff ff       	call   80037b <cprintf>
  801dd8:	83 c4 10             	add    $0x10,%esp

}
  801ddb:	90                   	nop
  801ddc:	c9                   	leave  
  801ddd:	c3                   	ret    

00801dde <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801dde:	55                   	push   %ebp
  801ddf:	89 e5                	mov    %esp,%ebp
  801de1:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  801de4:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801deb:	00 00 00 
  801dee:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801df5:	00 00 00 
  801df8:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801dff:	00 00 00 
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  801e02:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801e09:	e9 9e 00 00 00       	jmp    801eac <initialize_MemBlocksList+0xce>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
  801e0e:	a1 50 40 80 00       	mov    0x804050,%eax
  801e13:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e16:	c1 e2 04             	shl    $0x4,%edx
  801e19:	01 d0                	add    %edx,%eax
  801e1b:	85 c0                	test   %eax,%eax
  801e1d:	75 14                	jne    801e33 <initialize_MemBlocksList+0x55>
  801e1f:	83 ec 04             	sub    $0x4,%esp
  801e22:	68 d0 38 80 00       	push   $0x8038d0
  801e27:	6a 43                	push   $0x43
  801e29:	68 f3 38 80 00       	push   $0x8038f3
  801e2e:	e8 50 10 00 00       	call   802e83 <_panic>
  801e33:	a1 50 40 80 00       	mov    0x804050,%eax
  801e38:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e3b:	c1 e2 04             	shl    $0x4,%edx
  801e3e:	01 d0                	add    %edx,%eax
  801e40:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801e46:	89 10                	mov    %edx,(%eax)
  801e48:	8b 00                	mov    (%eax),%eax
  801e4a:	85 c0                	test   %eax,%eax
  801e4c:	74 18                	je     801e66 <initialize_MemBlocksList+0x88>
  801e4e:	a1 48 41 80 00       	mov    0x804148,%eax
  801e53:	8b 15 50 40 80 00    	mov    0x804050,%edx
  801e59:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801e5c:	c1 e1 04             	shl    $0x4,%ecx
  801e5f:	01 ca                	add    %ecx,%edx
  801e61:	89 50 04             	mov    %edx,0x4(%eax)
  801e64:	eb 12                	jmp    801e78 <initialize_MemBlocksList+0x9a>
  801e66:	a1 50 40 80 00       	mov    0x804050,%eax
  801e6b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e6e:	c1 e2 04             	shl    $0x4,%edx
  801e71:	01 d0                	add    %edx,%eax
  801e73:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801e78:	a1 50 40 80 00       	mov    0x804050,%eax
  801e7d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e80:	c1 e2 04             	shl    $0x4,%edx
  801e83:	01 d0                	add    %edx,%eax
  801e85:	a3 48 41 80 00       	mov    %eax,0x804148
  801e8a:	a1 50 40 80 00       	mov    0x804050,%eax
  801e8f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e92:	c1 e2 04             	shl    $0x4,%edx
  801e95:	01 d0                	add    %edx,%eax
  801e97:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801e9e:	a1 54 41 80 00       	mov    0x804154,%eax
  801ea3:	40                   	inc    %eax
  801ea4:	a3 54 41 80 00       	mov    %eax,0x804154
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  801ea9:	ff 45 f4             	incl   -0xc(%ebp)
  801eac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eaf:	3b 45 08             	cmp    0x8(%ebp),%eax
  801eb2:	0f 82 56 ff ff ff    	jb     801e0e <initialize_MemBlocksList+0x30>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
		}
}
  801eb8:	90                   	nop
  801eb9:	c9                   	leave  
  801eba:	c3                   	ret    

00801ebb <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801ebb:	55                   	push   %ebp
  801ebc:	89 e5                	mov    %esp,%ebp
  801ebe:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  801ec1:	a1 38 41 80 00       	mov    0x804138,%eax
  801ec6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801ec9:	eb 18                	jmp    801ee3 <find_block+0x28>
	{
		if (ele->sva==va)
  801ecb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ece:	8b 40 08             	mov    0x8(%eax),%eax
  801ed1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801ed4:	75 05                	jne    801edb <find_block+0x20>
			return ele;
  801ed6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ed9:	eb 7b                	jmp    801f56 <find_block+0x9b>
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  801edb:	a1 40 41 80 00       	mov    0x804140,%eax
  801ee0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801ee3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801ee7:	74 07                	je     801ef0 <find_block+0x35>
  801ee9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801eec:	8b 00                	mov    (%eax),%eax
  801eee:	eb 05                	jmp    801ef5 <find_block+0x3a>
  801ef0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef5:	a3 40 41 80 00       	mov    %eax,0x804140
  801efa:	a1 40 41 80 00       	mov    0x804140,%eax
  801eff:	85 c0                	test   %eax,%eax
  801f01:	75 c8                	jne    801ecb <find_block+0x10>
  801f03:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f07:	75 c2                	jne    801ecb <find_block+0x10>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  801f09:	a1 40 40 80 00       	mov    0x804040,%eax
  801f0e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f11:	eb 18                	jmp    801f2b <find_block+0x70>
	{
		if (ele->sva==va)
  801f13:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f16:	8b 40 08             	mov    0x8(%eax),%eax
  801f19:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801f1c:	75 05                	jne    801f23 <find_block+0x68>
					return ele;
  801f1e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f21:	eb 33                	jmp    801f56 <find_block+0x9b>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  801f23:	a1 48 40 80 00       	mov    0x804048,%eax
  801f28:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f2b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f2f:	74 07                	je     801f38 <find_block+0x7d>
  801f31:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f34:	8b 00                	mov    (%eax),%eax
  801f36:	eb 05                	jmp    801f3d <find_block+0x82>
  801f38:	b8 00 00 00 00       	mov    $0x0,%eax
  801f3d:	a3 48 40 80 00       	mov    %eax,0x804048
  801f42:	a1 48 40 80 00       	mov    0x804048,%eax
  801f47:	85 c0                	test   %eax,%eax
  801f49:	75 c8                	jne    801f13 <find_block+0x58>
  801f4b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f4f:	75 c2                	jne    801f13 <find_block+0x58>
	{
		if (ele->sva==va)
					return ele;
	}
return NULL;
  801f51:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  801f56:	c9                   	leave  
  801f57:	c3                   	ret    

00801f58 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801f58:	55                   	push   %ebp
  801f59:	89 e5                	mov    %esp,%ebp
  801f5b:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;

int x =LIST_SIZE(&AllocMemBlocksList);
  801f5e:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801f63:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((x==0))
  801f66:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f6a:	75 62                	jne    801fce <insert_sorted_allocList+0x76>
	{
	//	blockToInsert=AllocMemBlocksList.lh_first;
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  801f6c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f70:	75 14                	jne    801f86 <insert_sorted_allocList+0x2e>
  801f72:	83 ec 04             	sub    $0x4,%esp
  801f75:	68 d0 38 80 00       	push   $0x8038d0
  801f7a:	6a 69                	push   $0x69
  801f7c:	68 f3 38 80 00       	push   $0x8038f3
  801f81:	e8 fd 0e 00 00       	call   802e83 <_panic>
  801f86:	8b 15 40 40 80 00    	mov    0x804040,%edx
  801f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8f:	89 10                	mov    %edx,(%eax)
  801f91:	8b 45 08             	mov    0x8(%ebp),%eax
  801f94:	8b 00                	mov    (%eax),%eax
  801f96:	85 c0                	test   %eax,%eax
  801f98:	74 0d                	je     801fa7 <insert_sorted_allocList+0x4f>
  801f9a:	a1 40 40 80 00       	mov    0x804040,%eax
  801f9f:	8b 55 08             	mov    0x8(%ebp),%edx
  801fa2:	89 50 04             	mov    %edx,0x4(%eax)
  801fa5:	eb 08                	jmp    801faf <insert_sorted_allocList+0x57>
  801fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  801faa:	a3 44 40 80 00       	mov    %eax,0x804044
  801faf:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb2:	a3 40 40 80 00       	mov    %eax,0x804040
  801fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801fba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801fc1:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801fc6:	40                   	inc    %eax
  801fc7:	a3 4c 40 80 00       	mov    %eax,0x80404c
  801fcc:	eb 72                	jmp    802040 <insert_sorted_allocList+0xe8>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
  801fce:	a1 40 40 80 00       	mov    0x804040,%eax
  801fd3:	8b 50 08             	mov    0x8(%eax),%edx
  801fd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd9:	8b 40 08             	mov    0x8(%eax),%eax
  801fdc:	39 c2                	cmp    %eax,%edx
  801fde:	76 60                	jbe    802040 <insert_sorted_allocList+0xe8>
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  801fe0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801fe4:	75 14                	jne    801ffa <insert_sorted_allocList+0xa2>
  801fe6:	83 ec 04             	sub    $0x4,%esp
  801fe9:	68 d0 38 80 00       	push   $0x8038d0
  801fee:	6a 6d                	push   $0x6d
  801ff0:	68 f3 38 80 00       	push   $0x8038f3
  801ff5:	e8 89 0e 00 00       	call   802e83 <_panic>
  801ffa:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802000:	8b 45 08             	mov    0x8(%ebp),%eax
  802003:	89 10                	mov    %edx,(%eax)
  802005:	8b 45 08             	mov    0x8(%ebp),%eax
  802008:	8b 00                	mov    (%eax),%eax
  80200a:	85 c0                	test   %eax,%eax
  80200c:	74 0d                	je     80201b <insert_sorted_allocList+0xc3>
  80200e:	a1 40 40 80 00       	mov    0x804040,%eax
  802013:	8b 55 08             	mov    0x8(%ebp),%edx
  802016:	89 50 04             	mov    %edx,0x4(%eax)
  802019:	eb 08                	jmp    802023 <insert_sorted_allocList+0xcb>
  80201b:	8b 45 08             	mov    0x8(%ebp),%eax
  80201e:	a3 44 40 80 00       	mov    %eax,0x804044
  802023:	8b 45 08             	mov    0x8(%ebp),%eax
  802026:	a3 40 40 80 00       	mov    %eax,0x804040
  80202b:	8b 45 08             	mov    0x8(%ebp),%eax
  80202e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802035:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80203a:	40                   	inc    %eax
  80203b:	a3 4c 40 80 00       	mov    %eax,0x80404c
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  802040:	a1 40 40 80 00       	mov    0x804040,%eax
  802045:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802048:	e9 b9 01 00 00       	jmp    802206 <insert_sorted_allocList+0x2ae>
	{


		if ((blockToInsert->sva>AllocMemBlocksList.lh_first->sva)&&blockToInsert->sva<element->sva)
  80204d:	8b 45 08             	mov    0x8(%ebp),%eax
  802050:	8b 50 08             	mov    0x8(%eax),%edx
  802053:	a1 40 40 80 00       	mov    0x804040,%eax
  802058:	8b 40 08             	mov    0x8(%eax),%eax
  80205b:	39 c2                	cmp    %eax,%edx
  80205d:	76 7c                	jbe    8020db <insert_sorted_allocList+0x183>
  80205f:	8b 45 08             	mov    0x8(%ebp),%eax
  802062:	8b 50 08             	mov    0x8(%eax),%edx
  802065:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802068:	8b 40 08             	mov    0x8(%eax),%eax
  80206b:	39 c2                	cmp    %eax,%edx
  80206d:	73 6c                	jae    8020db <insert_sorted_allocList+0x183>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,element,blockToInsert);
  80206f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802073:	74 06                	je     80207b <insert_sorted_allocList+0x123>
  802075:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802079:	75 14                	jne    80208f <insert_sorted_allocList+0x137>
  80207b:	83 ec 04             	sub    $0x4,%esp
  80207e:	68 0c 39 80 00       	push   $0x80390c
  802083:	6a 75                	push   $0x75
  802085:	68 f3 38 80 00       	push   $0x8038f3
  80208a:	e8 f4 0d 00 00       	call   802e83 <_panic>
  80208f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802092:	8b 50 04             	mov    0x4(%eax),%edx
  802095:	8b 45 08             	mov    0x8(%ebp),%eax
  802098:	89 50 04             	mov    %edx,0x4(%eax)
  80209b:	8b 45 08             	mov    0x8(%ebp),%eax
  80209e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020a1:	89 10                	mov    %edx,(%eax)
  8020a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a6:	8b 40 04             	mov    0x4(%eax),%eax
  8020a9:	85 c0                	test   %eax,%eax
  8020ab:	74 0d                	je     8020ba <insert_sorted_allocList+0x162>
  8020ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b0:	8b 40 04             	mov    0x4(%eax),%eax
  8020b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8020b6:	89 10                	mov    %edx,(%eax)
  8020b8:	eb 08                	jmp    8020c2 <insert_sorted_allocList+0x16a>
  8020ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bd:	a3 40 40 80 00       	mov    %eax,0x804040
  8020c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8020c8:	89 50 04             	mov    %edx,0x4(%eax)
  8020cb:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8020d0:	40                   	inc    %eax
  8020d1:	a3 4c 40 80 00       	mov    %eax,0x80404c

		break;}
  8020d6:	e9 59 01 00 00       	jmp    802234 <insert_sorted_allocList+0x2dc>

	else if ((blockToInsert->sva>element->sva)&&(blockToInsert->sva<AllocMemBlocksList.lh_last->sva)&&blockToInsert->sva<LIST_NEXT(element)->sva)
  8020db:	8b 45 08             	mov    0x8(%ebp),%eax
  8020de:	8b 50 08             	mov    0x8(%eax),%edx
  8020e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e4:	8b 40 08             	mov    0x8(%eax),%eax
  8020e7:	39 c2                	cmp    %eax,%edx
  8020e9:	0f 86 98 00 00 00    	jbe    802187 <insert_sorted_allocList+0x22f>
  8020ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f2:	8b 50 08             	mov    0x8(%eax),%edx
  8020f5:	a1 44 40 80 00       	mov    0x804044,%eax
  8020fa:	8b 40 08             	mov    0x8(%eax),%eax
  8020fd:	39 c2                	cmp    %eax,%edx
  8020ff:	0f 83 82 00 00 00    	jae    802187 <insert_sorted_allocList+0x22f>
  802105:	8b 45 08             	mov    0x8(%ebp),%eax
  802108:	8b 50 08             	mov    0x8(%eax),%edx
  80210b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210e:	8b 00                	mov    (%eax),%eax
  802110:	8b 40 08             	mov    0x8(%eax),%eax
  802113:	39 c2                	cmp    %eax,%edx
  802115:	73 70                	jae    802187 <insert_sorted_allocList+0x22f>
	{

	LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  802117:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80211b:	74 06                	je     802123 <insert_sorted_allocList+0x1cb>
  80211d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802121:	75 14                	jne    802137 <insert_sorted_allocList+0x1df>
  802123:	83 ec 04             	sub    $0x4,%esp
  802126:	68 44 39 80 00       	push   $0x803944
  80212b:	6a 7c                	push   $0x7c
  80212d:	68 f3 38 80 00       	push   $0x8038f3
  802132:	e8 4c 0d 00 00       	call   802e83 <_panic>
  802137:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80213a:	8b 10                	mov    (%eax),%edx
  80213c:	8b 45 08             	mov    0x8(%ebp),%eax
  80213f:	89 10                	mov    %edx,(%eax)
  802141:	8b 45 08             	mov    0x8(%ebp),%eax
  802144:	8b 00                	mov    (%eax),%eax
  802146:	85 c0                	test   %eax,%eax
  802148:	74 0b                	je     802155 <insert_sorted_allocList+0x1fd>
  80214a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80214d:	8b 00                	mov    (%eax),%eax
  80214f:	8b 55 08             	mov    0x8(%ebp),%edx
  802152:	89 50 04             	mov    %edx,0x4(%eax)
  802155:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802158:	8b 55 08             	mov    0x8(%ebp),%edx
  80215b:	89 10                	mov    %edx,(%eax)
  80215d:	8b 45 08             	mov    0x8(%ebp),%eax
  802160:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802163:	89 50 04             	mov    %edx,0x4(%eax)
  802166:	8b 45 08             	mov    0x8(%ebp),%eax
  802169:	8b 00                	mov    (%eax),%eax
  80216b:	85 c0                	test   %eax,%eax
  80216d:	75 08                	jne    802177 <insert_sorted_allocList+0x21f>
  80216f:	8b 45 08             	mov    0x8(%ebp),%eax
  802172:	a3 44 40 80 00       	mov    %eax,0x804044
  802177:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80217c:	40                   	inc    %eax
  80217d:	a3 4c 40 80 00       	mov    %eax,0x80404c
		break;
  802182:	e9 ad 00 00 00       	jmp    802234 <insert_sorted_allocList+0x2dc>
	}else if (blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  802187:	8b 45 08             	mov    0x8(%ebp),%eax
  80218a:	8b 50 08             	mov    0x8(%eax),%edx
  80218d:	a1 44 40 80 00       	mov    0x804044,%eax
  802192:	8b 40 08             	mov    0x8(%eax),%eax
  802195:	39 c2                	cmp    %eax,%edx
  802197:	76 65                	jbe    8021fe <insert_sorted_allocList+0x2a6>
	{
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
  802199:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80219d:	75 17                	jne    8021b6 <insert_sorted_allocList+0x25e>
  80219f:	83 ec 04             	sub    $0x4,%esp
  8021a2:	68 78 39 80 00       	push   $0x803978
  8021a7:	68 80 00 00 00       	push   $0x80
  8021ac:	68 f3 38 80 00       	push   $0x8038f3
  8021b1:	e8 cd 0c 00 00       	call   802e83 <_panic>
  8021b6:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8021bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bf:	89 50 04             	mov    %edx,0x4(%eax)
  8021c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c5:	8b 40 04             	mov    0x4(%eax),%eax
  8021c8:	85 c0                	test   %eax,%eax
  8021ca:	74 0c                	je     8021d8 <insert_sorted_allocList+0x280>
  8021cc:	a1 44 40 80 00       	mov    0x804044,%eax
  8021d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8021d4:	89 10                	mov    %edx,(%eax)
  8021d6:	eb 08                	jmp    8021e0 <insert_sorted_allocList+0x288>
  8021d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021db:	a3 40 40 80 00       	mov    %eax,0x804040
  8021e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e3:	a3 44 40 80 00       	mov    %eax,0x804044
  8021e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021f1:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021f6:	40                   	inc    %eax
  8021f7:	a3 4c 40 80 00       	mov    %eax,0x80404c
		break;
  8021fc:	eb 36                	jmp    802234 <insert_sorted_allocList+0x2dc>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  8021fe:	a1 48 40 80 00       	mov    0x804048,%eax
  802203:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802206:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80220a:	74 07                	je     802213 <insert_sorted_allocList+0x2bb>
  80220c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80220f:	8b 00                	mov    (%eax),%eax
  802211:	eb 05                	jmp    802218 <insert_sorted_allocList+0x2c0>
  802213:	b8 00 00 00 00       	mov    $0x0,%eax
  802218:	a3 48 40 80 00       	mov    %eax,0x804048
  80221d:	a1 48 40 80 00       	mov    0x804048,%eax
  802222:	85 c0                	test   %eax,%eax
  802224:	0f 85 23 fe ff ff    	jne    80204d <insert_sorted_allocList+0xf5>
  80222a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80222e:	0f 85 19 fe ff ff    	jne    80204d <insert_sorted_allocList+0xf5>
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
		break;

	}
	}
}
  802234:	90                   	nop
  802235:	c9                   	leave  
  802236:	c3                   	ret    

00802237 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802237:	55                   	push   %ebp
  802238:	89 e5                	mov    %esp,%ebp
  80223a:	83 ec 18             	sub    $0x18,%esp
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  80223d:	a1 38 41 80 00       	mov    0x804138,%eax
  802242:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802245:	e9 7c 01 00 00       	jmp    8023c6 <alloc_block_FF+0x18f>
		{
			// case 2
				if(element->size == size)
  80224a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224d:	8b 40 0c             	mov    0xc(%eax),%eax
  802250:	3b 45 08             	cmp    0x8(%ebp),%eax
  802253:	0f 85 90 00 00 00    	jne    8022e9 <alloc_block_FF+0xb2>
				{
					tmp_block=element;
  802259:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225c:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,element);
  80225f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802263:	75 17                	jne    80227c <alloc_block_FF+0x45>
  802265:	83 ec 04             	sub    $0x4,%esp
  802268:	68 9b 39 80 00       	push   $0x80399b
  80226d:	68 ba 00 00 00       	push   $0xba
  802272:	68 f3 38 80 00       	push   $0x8038f3
  802277:	e8 07 0c 00 00       	call   802e83 <_panic>
  80227c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227f:	8b 00                	mov    (%eax),%eax
  802281:	85 c0                	test   %eax,%eax
  802283:	74 10                	je     802295 <alloc_block_FF+0x5e>
  802285:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802288:	8b 00                	mov    (%eax),%eax
  80228a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80228d:	8b 52 04             	mov    0x4(%edx),%edx
  802290:	89 50 04             	mov    %edx,0x4(%eax)
  802293:	eb 0b                	jmp    8022a0 <alloc_block_FF+0x69>
  802295:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802298:	8b 40 04             	mov    0x4(%eax),%eax
  80229b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8022a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a3:	8b 40 04             	mov    0x4(%eax),%eax
  8022a6:	85 c0                	test   %eax,%eax
  8022a8:	74 0f                	je     8022b9 <alloc_block_FF+0x82>
  8022aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ad:	8b 40 04             	mov    0x4(%eax),%eax
  8022b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022b3:	8b 12                	mov    (%edx),%edx
  8022b5:	89 10                	mov    %edx,(%eax)
  8022b7:	eb 0a                	jmp    8022c3 <alloc_block_FF+0x8c>
  8022b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022bc:	8b 00                	mov    (%eax),%eax
  8022be:	a3 38 41 80 00       	mov    %eax,0x804138
  8022c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022d6:	a1 44 41 80 00       	mov    0x804144,%eax
  8022db:	48                   	dec    %eax
  8022dc:	a3 44 41 80 00       	mov    %eax,0x804144
					return tmp_block;
  8022e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022e4:	e9 10 01 00 00       	jmp    8023f9 <alloc_block_FF+0x1c2>
				}
				 // case 3
				else if(element->size > size)
  8022e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8022ef:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022f2:	0f 86 c6 00 00 00    	jbe    8023be <alloc_block_FF+0x187>
				{
					// the new block are created
					tmp_block = AvailableMemBlocksList.lh_first ;
  8022f8:	a1 48 41 80 00       	mov    0x804148,%eax
  8022fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  802300:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802304:	75 17                	jne    80231d <alloc_block_FF+0xe6>
  802306:	83 ec 04             	sub    $0x4,%esp
  802309:	68 9b 39 80 00       	push   $0x80399b
  80230e:	68 c2 00 00 00       	push   $0xc2
  802313:	68 f3 38 80 00       	push   $0x8038f3
  802318:	e8 66 0b 00 00       	call   802e83 <_panic>
  80231d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802320:	8b 00                	mov    (%eax),%eax
  802322:	85 c0                	test   %eax,%eax
  802324:	74 10                	je     802336 <alloc_block_FF+0xff>
  802326:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802329:	8b 00                	mov    (%eax),%eax
  80232b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80232e:	8b 52 04             	mov    0x4(%edx),%edx
  802331:	89 50 04             	mov    %edx,0x4(%eax)
  802334:	eb 0b                	jmp    802341 <alloc_block_FF+0x10a>
  802336:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802339:	8b 40 04             	mov    0x4(%eax),%eax
  80233c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802341:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802344:	8b 40 04             	mov    0x4(%eax),%eax
  802347:	85 c0                	test   %eax,%eax
  802349:	74 0f                	je     80235a <alloc_block_FF+0x123>
  80234b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80234e:	8b 40 04             	mov    0x4(%eax),%eax
  802351:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802354:	8b 12                	mov    (%edx),%edx
  802356:	89 10                	mov    %edx,(%eax)
  802358:	eb 0a                	jmp    802364 <alloc_block_FF+0x12d>
  80235a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80235d:	8b 00                	mov    (%eax),%eax
  80235f:	a3 48 41 80 00       	mov    %eax,0x804148
  802364:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802367:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80236d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802370:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802377:	a1 54 41 80 00       	mov    0x804154,%eax
  80237c:	48                   	dec    %eax
  80237d:	a3 54 41 80 00       	mov    %eax,0x804154
					tmp_block->sva=element->sva;
  802382:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802385:	8b 50 08             	mov    0x8(%eax),%edx
  802388:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80238b:	89 50 08             	mov    %edx,0x8(%eax)
					tmp_block->size=size;
  80238e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802391:	8b 55 08             	mov    0x8(%ebp),%edx
  802394:	89 50 0c             	mov    %edx,0xc(%eax)
					//update block with remaining space
					element->size-=size;
  802397:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239a:	8b 40 0c             	mov    0xc(%eax),%eax
  80239d:	2b 45 08             	sub    0x8(%ebp),%eax
  8023a0:	89 c2                	mov    %eax,%edx
  8023a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a5:	89 50 0c             	mov    %edx,0xc(%eax)
					element->sva = element->sva + size;
  8023a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ab:	8b 50 08             	mov    0x8(%eax),%edx
  8023ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b1:	01 c2                	add    %eax,%edx
  8023b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b6:	89 50 08             	mov    %edx,0x8(%eax)
					// return back the new block
					return tmp_block ;
  8023b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023bc:	eb 3b                	jmp    8023f9 <alloc_block_FF+0x1c2>
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  8023be:	a1 40 41 80 00       	mov    0x804140,%eax
  8023c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023ca:	74 07                	je     8023d3 <alloc_block_FF+0x19c>
  8023cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cf:	8b 00                	mov    (%eax),%eax
  8023d1:	eb 05                	jmp    8023d8 <alloc_block_FF+0x1a1>
  8023d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8023d8:	a3 40 41 80 00       	mov    %eax,0x804140
  8023dd:	a1 40 41 80 00       	mov    0x804140,%eax
  8023e2:	85 c0                	test   %eax,%eax
  8023e4:	0f 85 60 fe ff ff    	jne    80224a <alloc_block_FF+0x13>
  8023ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023ee:	0f 85 56 fe ff ff    	jne    80224a <alloc_block_FF+0x13>
					// return back the new block
					return tmp_block ;
				}
		}
		// case 1
	  return NULL ;}
  8023f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8023f9:	c9                   	leave  
  8023fa:	c3                   	ret    

008023fb <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================

struct MemBlock *alloc_block_BF(uint32 size)
{
  8023fb:	55                   	push   %ebp
  8023fc:	89 e5                	mov    %esp,%ebp
  8023fe:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
  802401:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802408:	a1 38 41 80 00       	mov    0x804138,%eax
  80240d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802410:	eb 3a                	jmp    80244c <alloc_block_BF+0x51>
		{
			if(element->size >= size)
  802412:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802415:	8b 40 0c             	mov    0xc(%eax),%eax
  802418:	3b 45 08             	cmp    0x8(%ebp),%eax
  80241b:	72 27                	jb     802444 <alloc_block_BF+0x49>
			{
				if(best_size==-1)
  80241d:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802421:	75 0b                	jne    80242e <alloc_block_BF+0x33>
					best_size= element->size;
  802423:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802426:	8b 40 0c             	mov    0xc(%eax),%eax
  802429:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80242c:	eb 16                	jmp    802444 <alloc_block_BF+0x49>
				else if(best_size >= element->size)
  80242e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802431:	8b 50 0c             	mov    0xc(%eax),%edx
  802434:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802437:	39 c2                	cmp    %eax,%edx
  802439:	77 09                	ja     802444 <alloc_block_BF+0x49>
					best_size=element->size;
  80243b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243e:	8b 40 0c             	mov    0xc(%eax),%eax
  802441:	89 45 f0             	mov    %eax,-0x10(%ebp)

struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802444:	a1 40 41 80 00       	mov    0x804140,%eax
  802449:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80244c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802450:	74 07                	je     802459 <alloc_block_BF+0x5e>
  802452:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802455:	8b 00                	mov    (%eax),%eax
  802457:	eb 05                	jmp    80245e <alloc_block_BF+0x63>
  802459:	b8 00 00 00 00       	mov    $0x0,%eax
  80245e:	a3 40 41 80 00       	mov    %eax,0x804140
  802463:	a1 40 41 80 00       	mov    0x804140,%eax
  802468:	85 c0                	test   %eax,%eax
  80246a:	75 a6                	jne    802412 <alloc_block_BF+0x17>
  80246c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802470:	75 a0                	jne    802412 <alloc_block_BF+0x17>
					best_size= element->size;
				else if(best_size >= element->size)
					best_size=element->size;
			}
		}
		if(best_size != -1)
  802472:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802476:	0f 84 d3 01 00 00    	je     80264f <alloc_block_BF+0x254>
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  80247c:	a1 38 41 80 00       	mov    0x804138,%eax
  802481:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802484:	e9 98 01 00 00       	jmp    802621 <alloc_block_BF+0x226>
			{
			 if((best_size > size) && (best_size == element->size))
  802489:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80248c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80248f:	0f 86 da 00 00 00    	jbe    80256f <alloc_block_BF+0x174>
  802495:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802498:	8b 50 0c             	mov    0xc(%eax),%edx
  80249b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80249e:	39 c2                	cmp    %eax,%edx
  8024a0:	0f 85 c9 00 00 00    	jne    80256f <alloc_block_BF+0x174>
			  {
				// the new block are created
			    tmp_block = AvailableMemBlocksList.lh_first ;
  8024a6:	a1 48 41 80 00       	mov    0x804148,%eax
  8024ab:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  8024ae:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8024b2:	75 17                	jne    8024cb <alloc_block_BF+0xd0>
  8024b4:	83 ec 04             	sub    $0x4,%esp
  8024b7:	68 9b 39 80 00       	push   $0x80399b
  8024bc:	68 ea 00 00 00       	push   $0xea
  8024c1:	68 f3 38 80 00       	push   $0x8038f3
  8024c6:	e8 b8 09 00 00       	call   802e83 <_panic>
  8024cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024ce:	8b 00                	mov    (%eax),%eax
  8024d0:	85 c0                	test   %eax,%eax
  8024d2:	74 10                	je     8024e4 <alloc_block_BF+0xe9>
  8024d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024d7:	8b 00                	mov    (%eax),%eax
  8024d9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024dc:	8b 52 04             	mov    0x4(%edx),%edx
  8024df:	89 50 04             	mov    %edx,0x4(%eax)
  8024e2:	eb 0b                	jmp    8024ef <alloc_block_BF+0xf4>
  8024e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024e7:	8b 40 04             	mov    0x4(%eax),%eax
  8024ea:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8024ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024f2:	8b 40 04             	mov    0x4(%eax),%eax
  8024f5:	85 c0                	test   %eax,%eax
  8024f7:	74 0f                	je     802508 <alloc_block_BF+0x10d>
  8024f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024fc:	8b 40 04             	mov    0x4(%eax),%eax
  8024ff:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802502:	8b 12                	mov    (%edx),%edx
  802504:	89 10                	mov    %edx,(%eax)
  802506:	eb 0a                	jmp    802512 <alloc_block_BF+0x117>
  802508:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80250b:	8b 00                	mov    (%eax),%eax
  80250d:	a3 48 41 80 00       	mov    %eax,0x804148
  802512:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802515:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80251b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80251e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802525:	a1 54 41 80 00       	mov    0x804154,%eax
  80252a:	48                   	dec    %eax
  80252b:	a3 54 41 80 00       	mov    %eax,0x804154
				tmp_block->sva=element->sva;
  802530:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802533:	8b 50 08             	mov    0x8(%eax),%edx
  802536:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802539:	89 50 08             	mov    %edx,0x8(%eax)
				tmp_block->size=size;
  80253c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80253f:	8b 55 08             	mov    0x8(%ebp),%edx
  802542:	89 50 0c             	mov    %edx,0xc(%eax)
				//update block with remaining space
				element->size-=size;
  802545:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802548:	8b 40 0c             	mov    0xc(%eax),%eax
  80254b:	2b 45 08             	sub    0x8(%ebp),%eax
  80254e:	89 c2                	mov    %eax,%edx
  802550:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802553:	89 50 0c             	mov    %edx,0xc(%eax)
				element->sva = element->sva + size;
  802556:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802559:	8b 50 08             	mov    0x8(%eax),%edx
  80255c:	8b 45 08             	mov    0x8(%ebp),%eax
  80255f:	01 c2                	add    %eax,%edx
  802561:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802564:	89 50 08             	mov    %edx,0x8(%eax)
				// return back the new block
				return tmp_block ;
  802567:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80256a:	e9 e5 00 00 00       	jmp    802654 <alloc_block_BF+0x259>

			  }
			else if((element->size == best_size)&&(best_size == size))
  80256f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802572:	8b 50 0c             	mov    0xc(%eax),%edx
  802575:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802578:	39 c2                	cmp    %eax,%edx
  80257a:	0f 85 99 00 00 00    	jne    802619 <alloc_block_BF+0x21e>
  802580:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802583:	3b 45 08             	cmp    0x8(%ebp),%eax
  802586:	0f 85 8d 00 00 00    	jne    802619 <alloc_block_BF+0x21e>
			  {
				tmp_block=element;
  80258c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258f:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&FreeMemBlocksList,element);
  802592:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802596:	75 17                	jne    8025af <alloc_block_BF+0x1b4>
  802598:	83 ec 04             	sub    $0x4,%esp
  80259b:	68 9b 39 80 00       	push   $0x80399b
  8025a0:	68 f7 00 00 00       	push   $0xf7
  8025a5:	68 f3 38 80 00       	push   $0x8038f3
  8025aa:	e8 d4 08 00 00       	call   802e83 <_panic>
  8025af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b2:	8b 00                	mov    (%eax),%eax
  8025b4:	85 c0                	test   %eax,%eax
  8025b6:	74 10                	je     8025c8 <alloc_block_BF+0x1cd>
  8025b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bb:	8b 00                	mov    (%eax),%eax
  8025bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025c0:	8b 52 04             	mov    0x4(%edx),%edx
  8025c3:	89 50 04             	mov    %edx,0x4(%eax)
  8025c6:	eb 0b                	jmp    8025d3 <alloc_block_BF+0x1d8>
  8025c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cb:	8b 40 04             	mov    0x4(%eax),%eax
  8025ce:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8025d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d6:	8b 40 04             	mov    0x4(%eax),%eax
  8025d9:	85 c0                	test   %eax,%eax
  8025db:	74 0f                	je     8025ec <alloc_block_BF+0x1f1>
  8025dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e0:	8b 40 04             	mov    0x4(%eax),%eax
  8025e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025e6:	8b 12                	mov    (%edx),%edx
  8025e8:	89 10                	mov    %edx,(%eax)
  8025ea:	eb 0a                	jmp    8025f6 <alloc_block_BF+0x1fb>
  8025ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ef:	8b 00                	mov    (%eax),%eax
  8025f1:	a3 38 41 80 00       	mov    %eax,0x804138
  8025f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802602:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802609:	a1 44 41 80 00       	mov    0x804144,%eax
  80260e:	48                   	dec    %eax
  80260f:	a3 44 41 80 00       	mov    %eax,0x804144
				return tmp_block;
  802614:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802617:	eb 3b                	jmp    802654 <alloc_block_BF+0x259>
					best_size=element->size;
			}
		}
		if(best_size != -1)
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  802619:	a1 40 41 80 00       	mov    0x804140,%eax
  80261e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802621:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802625:	74 07                	je     80262e <alloc_block_BF+0x233>
  802627:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262a:	8b 00                	mov    (%eax),%eax
  80262c:	eb 05                	jmp    802633 <alloc_block_BF+0x238>
  80262e:	b8 00 00 00 00       	mov    $0x0,%eax
  802633:	a3 40 41 80 00       	mov    %eax,0x804140
  802638:	a1 40 41 80 00       	mov    0x804140,%eax
  80263d:	85 c0                	test   %eax,%eax
  80263f:	0f 85 44 fe ff ff    	jne    802489 <alloc_block_BF+0x8e>
  802645:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802649:	0f 85 3a fe ff ff    	jne    802489 <alloc_block_BF+0x8e>
				LIST_REMOVE(&FreeMemBlocksList,element);
				return tmp_block;
			 }
			}
		}
		return NULL ;}
  80264f:	b8 00 00 00 00       	mov    $0x0,%eax
  802654:	c9                   	leave  
  802655:	c3                   	ret    

00802656 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802656:	55                   	push   %ebp
  802657:	89 e5                	mov    %esp,%ebp
  802659:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  80265c:	83 ec 04             	sub    $0x4,%esp
  80265f:	68 bc 39 80 00       	push   $0x8039bc
  802664:	68 04 01 00 00       	push   $0x104
  802669:	68 f3 38 80 00       	push   $0x8038f3
  80266e:	e8 10 08 00 00       	call   802e83 <_panic>

00802673 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{struct MemBlock * blk_itr;
  802673:	55                   	push   %ebp
  802674:	89 e5                	mov    %esp,%ebp
  802676:	83 ec 18             	sub    $0x18,%esp
struct MemBlock * next;
struct MemBlock * first = LIST_FIRST(&(FreeMemBlocksList));
  802679:	a1 38 41 80 00       	mov    0x804138,%eax
  80267e:	89 45 f0             	mov    %eax,-0x10(%ebp)
struct MemBlock * last = LIST_LAST(&(FreeMemBlocksList));
  802681:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802686:	89 45 ec             	mov    %eax,-0x14(%ebp)

if(LIST_EMPTY(&(FreeMemBlocksList)))
  802689:	a1 38 41 80 00       	mov    0x804138,%eax
  80268e:	85 c0                	test   %eax,%eax
  802690:	75 68                	jne    8026fa <insert_sorted_with_merge_freeList+0x87>
			{

				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  802692:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802696:	75 17                	jne    8026af <insert_sorted_with_merge_freeList+0x3c>
  802698:	83 ec 04             	sub    $0x4,%esp
  80269b:	68 d0 38 80 00       	push   $0x8038d0
  8026a0:	68 14 01 00 00       	push   $0x114
  8026a5:	68 f3 38 80 00       	push   $0x8038f3
  8026aa:	e8 d4 07 00 00       	call   802e83 <_panic>
  8026af:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8026b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b8:	89 10                	mov    %edx,(%eax)
  8026ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8026bd:	8b 00                	mov    (%eax),%eax
  8026bf:	85 c0                	test   %eax,%eax
  8026c1:	74 0d                	je     8026d0 <insert_sorted_with_merge_freeList+0x5d>
  8026c3:	a1 38 41 80 00       	mov    0x804138,%eax
  8026c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8026cb:	89 50 04             	mov    %edx,0x4(%eax)
  8026ce:	eb 08                	jmp    8026d8 <insert_sorted_with_merge_freeList+0x65>
  8026d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d3:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8026d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8026db:	a3 38 41 80 00       	mov    %eax,0x804138
  8026e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026ea:	a1 44 41 80 00       	mov    0x804144,%eax
  8026ef:	40                   	inc    %eax
  8026f0:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  8026f5:	e9 d2 06 00 00       	jmp    802dcc <insert_sorted_with_merge_freeList+0x759>
				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);

			}
else
{
	if( blockToInsert->sva  < first->sva )
  8026fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8026fd:	8b 50 08             	mov    0x8(%eax),%edx
  802700:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802703:	8b 40 08             	mov    0x8(%eax),%eax
  802706:	39 c2                	cmp    %eax,%edx
  802708:	0f 83 22 01 00 00    	jae    802830 <insert_sorted_with_merge_freeList+0x1bd>
	{
                if( blockToInsert->sva + blockToInsert->size == first->sva)
  80270e:	8b 45 08             	mov    0x8(%ebp),%eax
  802711:	8b 50 08             	mov    0x8(%eax),%edx
  802714:	8b 45 08             	mov    0x8(%ebp),%eax
  802717:	8b 40 0c             	mov    0xc(%eax),%eax
  80271a:	01 c2                	add    %eax,%edx
  80271c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80271f:	8b 40 08             	mov    0x8(%eax),%eax
  802722:	39 c2                	cmp    %eax,%edx
  802724:	0f 85 9e 00 00 00    	jne    8027c8 <insert_sorted_with_merge_freeList+0x155>
                {

                	first->sva = blockToInsert->sva;
  80272a:	8b 45 08             	mov    0x8(%ebp),%eax
  80272d:	8b 50 08             	mov    0x8(%eax),%edx
  802730:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802733:	89 50 08             	mov    %edx,0x8(%eax)
                	first->size = first->size + blockToInsert->size;
  802736:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802739:	8b 50 0c             	mov    0xc(%eax),%edx
  80273c:	8b 45 08             	mov    0x8(%ebp),%eax
  80273f:	8b 40 0c             	mov    0xc(%eax),%eax
  802742:	01 c2                	add    %eax,%edx
  802744:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802747:	89 50 0c             	mov    %edx,0xc(%eax)
                	blockToInsert->size = blockToInsert->sva = 0;
  80274a:	8b 45 08             	mov    0x8(%ebp),%eax
  80274d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802754:	8b 45 08             	mov    0x8(%ebp),%eax
  802757:	8b 50 08             	mov    0x8(%eax),%edx
  80275a:	8b 45 08             	mov    0x8(%ebp),%eax
  80275d:	89 50 0c             	mov    %edx,0xc(%eax)
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802760:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802764:	75 17                	jne    80277d <insert_sorted_with_merge_freeList+0x10a>
  802766:	83 ec 04             	sub    $0x4,%esp
  802769:	68 d0 38 80 00       	push   $0x8038d0
  80276e:	68 21 01 00 00       	push   $0x121
  802773:	68 f3 38 80 00       	push   $0x8038f3
  802778:	e8 06 07 00 00       	call   802e83 <_panic>
  80277d:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802783:	8b 45 08             	mov    0x8(%ebp),%eax
  802786:	89 10                	mov    %edx,(%eax)
  802788:	8b 45 08             	mov    0x8(%ebp),%eax
  80278b:	8b 00                	mov    (%eax),%eax
  80278d:	85 c0                	test   %eax,%eax
  80278f:	74 0d                	je     80279e <insert_sorted_with_merge_freeList+0x12b>
  802791:	a1 48 41 80 00       	mov    0x804148,%eax
  802796:	8b 55 08             	mov    0x8(%ebp),%edx
  802799:	89 50 04             	mov    %edx,0x4(%eax)
  80279c:	eb 08                	jmp    8027a6 <insert_sorted_with_merge_freeList+0x133>
  80279e:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a1:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8027a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a9:	a3 48 41 80 00       	mov    %eax,0x804148
  8027ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027b8:	a1 54 41 80 00       	mov    0x804154,%eax
  8027bd:	40                   	inc    %eax
  8027be:	a3 54 41 80 00       	mov    %eax,0x804154
						}
				}
        }

}
}
  8027c3:	e9 04 06 00 00       	jmp    802dcc <insert_sorted_with_merge_freeList+0x759>
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
                }

                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  8027c8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027cc:	75 17                	jne    8027e5 <insert_sorted_with_merge_freeList+0x172>
  8027ce:	83 ec 04             	sub    $0x4,%esp
  8027d1:	68 d0 38 80 00       	push   $0x8038d0
  8027d6:	68 26 01 00 00       	push   $0x126
  8027db:	68 f3 38 80 00       	push   $0x8038f3
  8027e0:	e8 9e 06 00 00       	call   802e83 <_panic>
  8027e5:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8027eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ee:	89 10                	mov    %edx,(%eax)
  8027f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f3:	8b 00                	mov    (%eax),%eax
  8027f5:	85 c0                	test   %eax,%eax
  8027f7:	74 0d                	je     802806 <insert_sorted_with_merge_freeList+0x193>
  8027f9:	a1 38 41 80 00       	mov    0x804138,%eax
  8027fe:	8b 55 08             	mov    0x8(%ebp),%edx
  802801:	89 50 04             	mov    %edx,0x4(%eax)
  802804:	eb 08                	jmp    80280e <insert_sorted_with_merge_freeList+0x19b>
  802806:	8b 45 08             	mov    0x8(%ebp),%eax
  802809:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80280e:	8b 45 08             	mov    0x8(%ebp),%eax
  802811:	a3 38 41 80 00       	mov    %eax,0x804138
  802816:	8b 45 08             	mov    0x8(%ebp),%eax
  802819:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802820:	a1 44 41 80 00       	mov    0x804144,%eax
  802825:	40                   	inc    %eax
  802826:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  80282b:	e9 9c 05 00 00       	jmp    802dcc <insert_sorted_with_merge_freeList+0x759>
                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
                }
	}
    else if(blockToInsert->sva > last->sva)
  802830:	8b 45 08             	mov    0x8(%ebp),%eax
  802833:	8b 50 08             	mov    0x8(%eax),%edx
  802836:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802839:	8b 40 08             	mov    0x8(%eax),%eax
  80283c:	39 c2                	cmp    %eax,%edx
  80283e:	0f 86 16 01 00 00    	jbe    80295a <insert_sorted_with_merge_freeList+0x2e7>
 	{

				if(last->sva + last->size == blockToInsert->sva)
  802844:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802847:	8b 50 08             	mov    0x8(%eax),%edx
  80284a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80284d:	8b 40 0c             	mov    0xc(%eax),%eax
  802850:	01 c2                	add    %eax,%edx
  802852:	8b 45 08             	mov    0x8(%ebp),%eax
  802855:	8b 40 08             	mov    0x8(%eax),%eax
  802858:	39 c2                	cmp    %eax,%edx
  80285a:	0f 85 92 00 00 00    	jne    8028f2 <insert_sorted_with_merge_freeList+0x27f>
				{

					last->size = last->size + blockToInsert->size;
  802860:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802863:	8b 50 0c             	mov    0xc(%eax),%edx
  802866:	8b 45 08             	mov    0x8(%ebp),%eax
  802869:	8b 40 0c             	mov    0xc(%eax),%eax
  80286c:	01 c2                	add    %eax,%edx
  80286e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802871:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->size = blockToInsert->sva = 0;
  802874:	8b 45 08             	mov    0x8(%ebp),%eax
  802877:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80287e:	8b 45 08             	mov    0x8(%ebp),%eax
  802881:	8b 50 08             	mov    0x8(%eax),%edx
  802884:	8b 45 08             	mov    0x8(%ebp),%eax
  802887:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  80288a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80288e:	75 17                	jne    8028a7 <insert_sorted_with_merge_freeList+0x234>
  802890:	83 ec 04             	sub    $0x4,%esp
  802893:	68 d0 38 80 00       	push   $0x8038d0
  802898:	68 31 01 00 00       	push   $0x131
  80289d:	68 f3 38 80 00       	push   $0x8038f3
  8028a2:	e8 dc 05 00 00       	call   802e83 <_panic>
  8028a7:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8028ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b0:	89 10                	mov    %edx,(%eax)
  8028b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b5:	8b 00                	mov    (%eax),%eax
  8028b7:	85 c0                	test   %eax,%eax
  8028b9:	74 0d                	je     8028c8 <insert_sorted_with_merge_freeList+0x255>
  8028bb:	a1 48 41 80 00       	mov    0x804148,%eax
  8028c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8028c3:	89 50 04             	mov    %edx,0x4(%eax)
  8028c6:	eb 08                	jmp    8028d0 <insert_sorted_with_merge_freeList+0x25d>
  8028c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8028cb:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8028d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d3:	a3 48 41 80 00       	mov    %eax,0x804148
  8028d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8028db:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028e2:	a1 54 41 80 00       	mov    0x804154,%eax
  8028e7:	40                   	inc    %eax
  8028e8:	a3 54 41 80 00       	mov    %eax,0x804154
						}
				}
        }

}
}
  8028ed:	e9 da 04 00 00       	jmp    802dcc <insert_sorted_with_merge_freeList+0x759>

				}

				else
				{
					LIST_INSERT_TAIL(&(FreeMemBlocksList),  blockToInsert);
  8028f2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028f6:	75 17                	jne    80290f <insert_sorted_with_merge_freeList+0x29c>
  8028f8:	83 ec 04             	sub    $0x4,%esp
  8028fb:	68 78 39 80 00       	push   $0x803978
  802900:	68 37 01 00 00       	push   $0x137
  802905:	68 f3 38 80 00       	push   $0x8038f3
  80290a:	e8 74 05 00 00       	call   802e83 <_panic>
  80290f:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802915:	8b 45 08             	mov    0x8(%ebp),%eax
  802918:	89 50 04             	mov    %edx,0x4(%eax)
  80291b:	8b 45 08             	mov    0x8(%ebp),%eax
  80291e:	8b 40 04             	mov    0x4(%eax),%eax
  802921:	85 c0                	test   %eax,%eax
  802923:	74 0c                	je     802931 <insert_sorted_with_merge_freeList+0x2be>
  802925:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80292a:	8b 55 08             	mov    0x8(%ebp),%edx
  80292d:	89 10                	mov    %edx,(%eax)
  80292f:	eb 08                	jmp    802939 <insert_sorted_with_merge_freeList+0x2c6>
  802931:	8b 45 08             	mov    0x8(%ebp),%eax
  802934:	a3 38 41 80 00       	mov    %eax,0x804138
  802939:	8b 45 08             	mov    0x8(%ebp),%eax
  80293c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802941:	8b 45 08             	mov    0x8(%ebp),%eax
  802944:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80294a:	a1 44 41 80 00       	mov    0x804144,%eax
  80294f:	40                   	inc    %eax
  802950:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  802955:	e9 72 04 00 00       	jmp    802dcc <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  80295a:	a1 38 41 80 00       	mov    0x804138,%eax
  80295f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802962:	e9 35 04 00 00       	jmp    802d9c <insert_sorted_with_merge_freeList+0x729>
				{
				     next=LIST_NEXT(blk_itr);
  802967:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296a:	8b 00                	mov    (%eax),%eax
  80296c:	89 45 e8             	mov    %eax,-0x18(%ebp)


					if( (blockToInsert->sva > blk_itr->sva) )
  80296f:	8b 45 08             	mov    0x8(%ebp),%eax
  802972:	8b 50 08             	mov    0x8(%eax),%edx
  802975:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802978:	8b 40 08             	mov    0x8(%eax),%eax
  80297b:	39 c2                	cmp    %eax,%edx
  80297d:	0f 86 11 04 00 00    	jbe    802d94 <insert_sorted_with_merge_freeList+0x721>
						{
							if(((blk_itr->sva) + (blk_itr->size) < blockToInsert->sva && (blockToInsert->sva) + (blockToInsert->size) < next->sva))
  802983:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802986:	8b 50 08             	mov    0x8(%eax),%edx
  802989:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298c:	8b 40 0c             	mov    0xc(%eax),%eax
  80298f:	01 c2                	add    %eax,%edx
  802991:	8b 45 08             	mov    0x8(%ebp),%eax
  802994:	8b 40 08             	mov    0x8(%eax),%eax
  802997:	39 c2                	cmp    %eax,%edx
  802999:	0f 83 8b 00 00 00    	jae    802a2a <insert_sorted_with_merge_freeList+0x3b7>
  80299f:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a2:	8b 50 08             	mov    0x8(%eax),%edx
  8029a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a8:	8b 40 0c             	mov    0xc(%eax),%eax
  8029ab:	01 c2                	add    %eax,%edx
  8029ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029b0:	8b 40 08             	mov    0x8(%eax),%eax
  8029b3:	39 c2                	cmp    %eax,%edx
  8029b5:	73 73                	jae    802a2a <insert_sorted_with_merge_freeList+0x3b7>
							{
								LIST_INSERT_AFTER(&(FreeMemBlocksList), blk_itr, blockToInsert);
  8029b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029bb:	74 06                	je     8029c3 <insert_sorted_with_merge_freeList+0x350>
  8029bd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029c1:	75 17                	jne    8029da <insert_sorted_with_merge_freeList+0x367>
  8029c3:	83 ec 04             	sub    $0x4,%esp
  8029c6:	68 44 39 80 00       	push   $0x803944
  8029cb:	68 48 01 00 00       	push   $0x148
  8029d0:	68 f3 38 80 00       	push   $0x8038f3
  8029d5:	e8 a9 04 00 00       	call   802e83 <_panic>
  8029da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029dd:	8b 10                	mov    (%eax),%edx
  8029df:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e2:	89 10                	mov    %edx,(%eax)
  8029e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e7:	8b 00                	mov    (%eax),%eax
  8029e9:	85 c0                	test   %eax,%eax
  8029eb:	74 0b                	je     8029f8 <insert_sorted_with_merge_freeList+0x385>
  8029ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f0:	8b 00                	mov    (%eax),%eax
  8029f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8029f5:	89 50 04             	mov    %edx,0x4(%eax)
  8029f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8029fe:	89 10                	mov    %edx,(%eax)
  802a00:	8b 45 08             	mov    0x8(%ebp),%eax
  802a03:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a06:	89 50 04             	mov    %edx,0x4(%eax)
  802a09:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0c:	8b 00                	mov    (%eax),%eax
  802a0e:	85 c0                	test   %eax,%eax
  802a10:	75 08                	jne    802a1a <insert_sorted_with_merge_freeList+0x3a7>
  802a12:	8b 45 08             	mov    0x8(%ebp),%eax
  802a15:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a1a:	a1 44 41 80 00       	mov    0x804144,%eax
  802a1f:	40                   	inc    %eax
  802a20:	a3 44 41 80 00       	mov    %eax,0x804144
								break;
  802a25:	e9 a2 03 00 00       	jmp    802dcc <insert_sorted_with_merge_freeList+0x759>

							}
							else if((blockToInsert->sva + blockToInsert->size) < next->sva  && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  802a2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2d:	8b 50 08             	mov    0x8(%eax),%edx
  802a30:	8b 45 08             	mov    0x8(%ebp),%eax
  802a33:	8b 40 0c             	mov    0xc(%eax),%eax
  802a36:	01 c2                	add    %eax,%edx
  802a38:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a3b:	8b 40 08             	mov    0x8(%eax),%eax
  802a3e:	39 c2                	cmp    %eax,%edx
  802a40:	0f 83 ae 00 00 00    	jae    802af4 <insert_sorted_with_merge_freeList+0x481>
  802a46:	8b 45 08             	mov    0x8(%ebp),%eax
  802a49:	8b 50 08             	mov    0x8(%eax),%edx
  802a4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4f:	8b 48 08             	mov    0x8(%eax),%ecx
  802a52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a55:	8b 40 0c             	mov    0xc(%eax),%eax
  802a58:	01 c8                	add    %ecx,%eax
  802a5a:	39 c2                	cmp    %eax,%edx
  802a5c:	0f 85 92 00 00 00    	jne    802af4 <insert_sorted_with_merge_freeList+0x481>
							{

								blk_itr->size=blk_itr->size+blockToInsert->size;
  802a62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a65:	8b 50 0c             	mov    0xc(%eax),%edx
  802a68:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6b:	8b 40 0c             	mov    0xc(%eax),%eax
  802a6e:	01 c2                	add    %eax,%edx
  802a70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a73:	89 50 0c             	mov    %edx,0xc(%eax)
								 blockToInsert->size=blockToInsert->sva=0;
  802a76:	8b 45 08             	mov    0x8(%ebp),%eax
  802a79:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802a80:	8b 45 08             	mov    0x8(%ebp),%eax
  802a83:	8b 50 08             	mov    0x8(%eax),%edx
  802a86:	8b 45 08             	mov    0x8(%ebp),%eax
  802a89:	89 50 0c             	mov    %edx,0xc(%eax)
								 LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802a8c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a90:	75 17                	jne    802aa9 <insert_sorted_with_merge_freeList+0x436>
  802a92:	83 ec 04             	sub    $0x4,%esp
  802a95:	68 d0 38 80 00       	push   $0x8038d0
  802a9a:	68 51 01 00 00       	push   $0x151
  802a9f:	68 f3 38 80 00       	push   $0x8038f3
  802aa4:	e8 da 03 00 00       	call   802e83 <_panic>
  802aa9:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab2:	89 10                	mov    %edx,(%eax)
  802ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab7:	8b 00                	mov    (%eax),%eax
  802ab9:	85 c0                	test   %eax,%eax
  802abb:	74 0d                	je     802aca <insert_sorted_with_merge_freeList+0x457>
  802abd:	a1 48 41 80 00       	mov    0x804148,%eax
  802ac2:	8b 55 08             	mov    0x8(%ebp),%edx
  802ac5:	89 50 04             	mov    %edx,0x4(%eax)
  802ac8:	eb 08                	jmp    802ad2 <insert_sorted_with_merge_freeList+0x45f>
  802aca:	8b 45 08             	mov    0x8(%ebp),%eax
  802acd:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad5:	a3 48 41 80 00       	mov    %eax,0x804148
  802ada:	8b 45 08             	mov    0x8(%ebp),%eax
  802add:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ae4:	a1 54 41 80 00       	mov    0x804154,%eax
  802ae9:	40                   	inc    %eax
  802aea:	a3 54 41 80 00       	mov    %eax,0x804154
								 break;
  802aef:	e9 d8 02 00 00       	jmp    802dcc <insert_sorted_with_merge_freeList+0x759>

							}
							else if( (blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva > (blk_itr->sva + blk_itr->size))
  802af4:	8b 45 08             	mov    0x8(%ebp),%eax
  802af7:	8b 50 08             	mov    0x8(%eax),%edx
  802afa:	8b 45 08             	mov    0x8(%ebp),%eax
  802afd:	8b 40 0c             	mov    0xc(%eax),%eax
  802b00:	01 c2                	add    %eax,%edx
  802b02:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b05:	8b 40 08             	mov    0x8(%eax),%eax
  802b08:	39 c2                	cmp    %eax,%edx
  802b0a:	0f 85 ba 00 00 00    	jne    802bca <insert_sorted_with_merge_freeList+0x557>
  802b10:	8b 45 08             	mov    0x8(%ebp),%eax
  802b13:	8b 50 08             	mov    0x8(%eax),%edx
  802b16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b19:	8b 48 08             	mov    0x8(%eax),%ecx
  802b1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1f:	8b 40 0c             	mov    0xc(%eax),%eax
  802b22:	01 c8                	add    %ecx,%eax
  802b24:	39 c2                	cmp    %eax,%edx
  802b26:	0f 86 9e 00 00 00    	jbe    802bca <insert_sorted_with_merge_freeList+0x557>
							{
								next->size = next->size + blockToInsert->size;
  802b2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b2f:	8b 50 0c             	mov    0xc(%eax),%edx
  802b32:	8b 45 08             	mov    0x8(%ebp),%eax
  802b35:	8b 40 0c             	mov    0xc(%eax),%eax
  802b38:	01 c2                	add    %eax,%edx
  802b3a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b3d:	89 50 0c             	mov    %edx,0xc(%eax)
								next->sva = blockToInsert->sva;
  802b40:	8b 45 08             	mov    0x8(%ebp),%eax
  802b43:	8b 50 08             	mov    0x8(%eax),%edx
  802b46:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b49:	89 50 08             	mov    %edx,0x8(%eax)

								blockToInsert->size = blockToInsert->sva = 0;
  802b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802b56:	8b 45 08             	mov    0x8(%ebp),%eax
  802b59:	8b 50 08             	mov    0x8(%eax),%edx
  802b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5f:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802b62:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b66:	75 17                	jne    802b7f <insert_sorted_with_merge_freeList+0x50c>
  802b68:	83 ec 04             	sub    $0x4,%esp
  802b6b:	68 d0 38 80 00       	push   $0x8038d0
  802b70:	68 5b 01 00 00       	push   $0x15b
  802b75:	68 f3 38 80 00       	push   $0x8038f3
  802b7a:	e8 04 03 00 00       	call   802e83 <_panic>
  802b7f:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b85:	8b 45 08             	mov    0x8(%ebp),%eax
  802b88:	89 10                	mov    %edx,(%eax)
  802b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8d:	8b 00                	mov    (%eax),%eax
  802b8f:	85 c0                	test   %eax,%eax
  802b91:	74 0d                	je     802ba0 <insert_sorted_with_merge_freeList+0x52d>
  802b93:	a1 48 41 80 00       	mov    0x804148,%eax
  802b98:	8b 55 08             	mov    0x8(%ebp),%edx
  802b9b:	89 50 04             	mov    %edx,0x4(%eax)
  802b9e:	eb 08                	jmp    802ba8 <insert_sorted_with_merge_freeList+0x535>
  802ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba3:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bab:	a3 48 41 80 00       	mov    %eax,0x804148
  802bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bba:	a1 54 41 80 00       	mov    0x804154,%eax
  802bbf:	40                   	inc    %eax
  802bc0:	a3 54 41 80 00       	mov    %eax,0x804154
								break;
  802bc5:	e9 02 02 00 00       	jmp    802dcc <insert_sorted_with_merge_freeList+0x759>
							}
							else if ((blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  802bca:	8b 45 08             	mov    0x8(%ebp),%eax
  802bcd:	8b 50 08             	mov    0x8(%eax),%edx
  802bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd3:	8b 40 0c             	mov    0xc(%eax),%eax
  802bd6:	01 c2                	add    %eax,%edx
  802bd8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bdb:	8b 40 08             	mov    0x8(%eax),%eax
  802bde:	39 c2                	cmp    %eax,%edx
  802be0:	0f 85 ae 01 00 00    	jne    802d94 <insert_sorted_with_merge_freeList+0x721>
  802be6:	8b 45 08             	mov    0x8(%ebp),%eax
  802be9:	8b 50 08             	mov    0x8(%eax),%edx
  802bec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bef:	8b 48 08             	mov    0x8(%eax),%ecx
  802bf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf5:	8b 40 0c             	mov    0xc(%eax),%eax
  802bf8:	01 c8                	add    %ecx,%eax
  802bfa:	39 c2                	cmp    %eax,%edx
  802bfc:	0f 85 92 01 00 00    	jne    802d94 <insert_sorted_with_merge_freeList+0x721>
							{
								blk_itr->size = blk_itr->size + blockToInsert->size + next->size;
  802c02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c05:	8b 50 0c             	mov    0xc(%eax),%edx
  802c08:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0b:	8b 40 0c             	mov    0xc(%eax),%eax
  802c0e:	01 c2                	add    %eax,%edx
  802c10:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c13:	8b 40 0c             	mov    0xc(%eax),%eax
  802c16:	01 c2                	add    %eax,%edx
  802c18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1b:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size = blockToInsert->sva=0;
  802c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c21:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802c28:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2b:	8b 50 08             	mov    0x8(%eax),%edx
  802c2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c31:	89 50 0c             	mov    %edx,0xc(%eax)
								next->size = next->sva = 0;
  802c34:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c37:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802c3e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c41:	8b 50 08             	mov    0x8(%eax),%edx
  802c44:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c47:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_REMOVE(&FreeMemBlocksList, next);
  802c4a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802c4e:	75 17                	jne    802c67 <insert_sorted_with_merge_freeList+0x5f4>
  802c50:	83 ec 04             	sub    $0x4,%esp
  802c53:	68 9b 39 80 00       	push   $0x80399b
  802c58:	68 63 01 00 00       	push   $0x163
  802c5d:	68 f3 38 80 00       	push   $0x8038f3
  802c62:	e8 1c 02 00 00       	call   802e83 <_panic>
  802c67:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c6a:	8b 00                	mov    (%eax),%eax
  802c6c:	85 c0                	test   %eax,%eax
  802c6e:	74 10                	je     802c80 <insert_sorted_with_merge_freeList+0x60d>
  802c70:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c73:	8b 00                	mov    (%eax),%eax
  802c75:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c78:	8b 52 04             	mov    0x4(%edx),%edx
  802c7b:	89 50 04             	mov    %edx,0x4(%eax)
  802c7e:	eb 0b                	jmp    802c8b <insert_sorted_with_merge_freeList+0x618>
  802c80:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c83:	8b 40 04             	mov    0x4(%eax),%eax
  802c86:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c8b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c8e:	8b 40 04             	mov    0x4(%eax),%eax
  802c91:	85 c0                	test   %eax,%eax
  802c93:	74 0f                	je     802ca4 <insert_sorted_with_merge_freeList+0x631>
  802c95:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c98:	8b 40 04             	mov    0x4(%eax),%eax
  802c9b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c9e:	8b 12                	mov    (%edx),%edx
  802ca0:	89 10                	mov    %edx,(%eax)
  802ca2:	eb 0a                	jmp    802cae <insert_sorted_with_merge_freeList+0x63b>
  802ca4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ca7:	8b 00                	mov    (%eax),%eax
  802ca9:	a3 38 41 80 00       	mov    %eax,0x804138
  802cae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cb1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cb7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cc1:	a1 44 41 80 00       	mov    0x804144,%eax
  802cc6:	48                   	dec    %eax
  802cc7:	a3 44 41 80 00       	mov    %eax,0x804144
								LIST_INSERT_HEAD(&AvailableMemBlocksList, next );
  802ccc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802cd0:	75 17                	jne    802ce9 <insert_sorted_with_merge_freeList+0x676>
  802cd2:	83 ec 04             	sub    $0x4,%esp
  802cd5:	68 d0 38 80 00       	push   $0x8038d0
  802cda:	68 64 01 00 00       	push   $0x164
  802cdf:	68 f3 38 80 00       	push   $0x8038f3
  802ce4:	e8 9a 01 00 00       	call   802e83 <_panic>
  802ce9:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802cef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cf2:	89 10                	mov    %edx,(%eax)
  802cf4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cf7:	8b 00                	mov    (%eax),%eax
  802cf9:	85 c0                	test   %eax,%eax
  802cfb:	74 0d                	je     802d0a <insert_sorted_with_merge_freeList+0x697>
  802cfd:	a1 48 41 80 00       	mov    0x804148,%eax
  802d02:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d05:	89 50 04             	mov    %edx,0x4(%eax)
  802d08:	eb 08                	jmp    802d12 <insert_sorted_with_merge_freeList+0x69f>
  802d0a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d0d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d12:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d15:	a3 48 41 80 00       	mov    %eax,0x804148
  802d1a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d1d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d24:	a1 54 41 80 00       	mov    0x804154,%eax
  802d29:	40                   	inc    %eax
  802d2a:	a3 54 41 80 00       	mov    %eax,0x804154
							    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802d2f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d33:	75 17                	jne    802d4c <insert_sorted_with_merge_freeList+0x6d9>
  802d35:	83 ec 04             	sub    $0x4,%esp
  802d38:	68 d0 38 80 00       	push   $0x8038d0
  802d3d:	68 65 01 00 00       	push   $0x165
  802d42:	68 f3 38 80 00       	push   $0x8038f3
  802d47:	e8 37 01 00 00       	call   802e83 <_panic>
  802d4c:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d52:	8b 45 08             	mov    0x8(%ebp),%eax
  802d55:	89 10                	mov    %edx,(%eax)
  802d57:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5a:	8b 00                	mov    (%eax),%eax
  802d5c:	85 c0                	test   %eax,%eax
  802d5e:	74 0d                	je     802d6d <insert_sorted_with_merge_freeList+0x6fa>
  802d60:	a1 48 41 80 00       	mov    0x804148,%eax
  802d65:	8b 55 08             	mov    0x8(%ebp),%edx
  802d68:	89 50 04             	mov    %edx,0x4(%eax)
  802d6b:	eb 08                	jmp    802d75 <insert_sorted_with_merge_freeList+0x702>
  802d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d70:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d75:	8b 45 08             	mov    0x8(%ebp),%eax
  802d78:	a3 48 41 80 00       	mov    %eax,0x804148
  802d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d80:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d87:	a1 54 41 80 00       	mov    0x804154,%eax
  802d8c:	40                   	inc    %eax
  802d8d:	a3 54 41 80 00       	mov    %eax,0x804154
								break;
  802d92:	eb 38                	jmp    802dcc <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  802d94:	a1 40 41 80 00       	mov    0x804140,%eax
  802d99:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d9c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802da0:	74 07                	je     802da9 <insert_sorted_with_merge_freeList+0x736>
  802da2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da5:	8b 00                	mov    (%eax),%eax
  802da7:	eb 05                	jmp    802dae <insert_sorted_with_merge_freeList+0x73b>
  802da9:	b8 00 00 00 00       	mov    $0x0,%eax
  802dae:	a3 40 41 80 00       	mov    %eax,0x804140
  802db3:	a1 40 41 80 00       	mov    0x804140,%eax
  802db8:	85 c0                	test   %eax,%eax
  802dba:	0f 85 a7 fb ff ff    	jne    802967 <insert_sorted_with_merge_freeList+0x2f4>
  802dc0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dc4:	0f 85 9d fb ff ff    	jne    802967 <insert_sorted_with_merge_freeList+0x2f4>
						}
				}
        }

}
}
  802dca:	eb 00                	jmp    802dcc <insert_sorted_with_merge_freeList+0x759>
  802dcc:	90                   	nop
  802dcd:	c9                   	leave  
  802dce:	c3                   	ret    

00802dcf <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  802dcf:	55                   	push   %ebp
  802dd0:	89 e5                	mov    %esp,%ebp
  802dd2:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  802dd5:	8b 55 08             	mov    0x8(%ebp),%edx
  802dd8:	89 d0                	mov    %edx,%eax
  802dda:	c1 e0 02             	shl    $0x2,%eax
  802ddd:	01 d0                	add    %edx,%eax
  802ddf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802de6:	01 d0                	add    %edx,%eax
  802de8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802def:	01 d0                	add    %edx,%eax
  802df1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802df8:	01 d0                	add    %edx,%eax
  802dfa:	c1 e0 04             	shl    $0x4,%eax
  802dfd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  802e00:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  802e07:	8d 45 e8             	lea    -0x18(%ebp),%eax
  802e0a:	83 ec 0c             	sub    $0xc,%esp
  802e0d:	50                   	push   %eax
  802e0e:	e8 ee eb ff ff       	call   801a01 <sys_get_virtual_time>
  802e13:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  802e16:	eb 41                	jmp    802e59 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  802e18:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802e1b:	83 ec 0c             	sub    $0xc,%esp
  802e1e:	50                   	push   %eax
  802e1f:	e8 dd eb ff ff       	call   801a01 <sys_get_virtual_time>
  802e24:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  802e27:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e2a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e2d:	29 c2                	sub    %eax,%edx
  802e2f:	89 d0                	mov    %edx,%eax
  802e31:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  802e34:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e37:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e3a:	89 d1                	mov    %edx,%ecx
  802e3c:	29 c1                	sub    %eax,%ecx
  802e3e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802e41:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e44:	39 c2                	cmp    %eax,%edx
  802e46:	0f 97 c0             	seta   %al
  802e49:	0f b6 c0             	movzbl %al,%eax
  802e4c:	29 c1                	sub    %eax,%ecx
  802e4e:	89 c8                	mov    %ecx,%eax
  802e50:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  802e53:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802e56:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  802e59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802e5f:	72 b7                	jb     802e18 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  802e61:	90                   	nop
  802e62:	c9                   	leave  
  802e63:	c3                   	ret    

00802e64 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  802e64:	55                   	push   %ebp
  802e65:	89 e5                	mov    %esp,%ebp
  802e67:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  802e6a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  802e71:	eb 03                	jmp    802e76 <busy_wait+0x12>
  802e73:	ff 45 fc             	incl   -0x4(%ebp)
  802e76:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802e79:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e7c:	72 f5                	jb     802e73 <busy_wait+0xf>
	return i;
  802e7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802e81:	c9                   	leave  
  802e82:	c3                   	ret    

00802e83 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  802e83:	55                   	push   %ebp
  802e84:	89 e5                	mov    %esp,%ebp
  802e86:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  802e89:	8d 45 10             	lea    0x10(%ebp),%eax
  802e8c:	83 c0 04             	add    $0x4,%eax
  802e8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  802e92:	a1 5c 41 80 00       	mov    0x80415c,%eax
  802e97:	85 c0                	test   %eax,%eax
  802e99:	74 16                	je     802eb1 <_panic+0x2e>
		cprintf("%s: ", argv0);
  802e9b:	a1 5c 41 80 00       	mov    0x80415c,%eax
  802ea0:	83 ec 08             	sub    $0x8,%esp
  802ea3:	50                   	push   %eax
  802ea4:	68 ec 39 80 00       	push   $0x8039ec
  802ea9:	e8 cd d4 ff ff       	call   80037b <cprintf>
  802eae:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  802eb1:	a1 00 40 80 00       	mov    0x804000,%eax
  802eb6:	ff 75 0c             	pushl  0xc(%ebp)
  802eb9:	ff 75 08             	pushl  0x8(%ebp)
  802ebc:	50                   	push   %eax
  802ebd:	68 f1 39 80 00       	push   $0x8039f1
  802ec2:	e8 b4 d4 ff ff       	call   80037b <cprintf>
  802ec7:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  802eca:	8b 45 10             	mov    0x10(%ebp),%eax
  802ecd:	83 ec 08             	sub    $0x8,%esp
  802ed0:	ff 75 f4             	pushl  -0xc(%ebp)
  802ed3:	50                   	push   %eax
  802ed4:	e8 37 d4 ff ff       	call   800310 <vcprintf>
  802ed9:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  802edc:	83 ec 08             	sub    $0x8,%esp
  802edf:	6a 00                	push   $0x0
  802ee1:	68 0d 3a 80 00       	push   $0x803a0d
  802ee6:	e8 25 d4 ff ff       	call   800310 <vcprintf>
  802eeb:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  802eee:	e8 a6 d3 ff ff       	call   800299 <exit>

	// should not return here
	while (1) ;
  802ef3:	eb fe                	jmp    802ef3 <_panic+0x70>

00802ef5 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  802ef5:	55                   	push   %ebp
  802ef6:	89 e5                	mov    %esp,%ebp
  802ef8:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  802efb:	a1 20 40 80 00       	mov    0x804020,%eax
  802f00:	8b 50 74             	mov    0x74(%eax),%edx
  802f03:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f06:	39 c2                	cmp    %eax,%edx
  802f08:	74 14                	je     802f1e <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  802f0a:	83 ec 04             	sub    $0x4,%esp
  802f0d:	68 10 3a 80 00       	push   $0x803a10
  802f12:	6a 26                	push   $0x26
  802f14:	68 5c 3a 80 00       	push   $0x803a5c
  802f19:	e8 65 ff ff ff       	call   802e83 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  802f1e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  802f25:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802f2c:	e9 c2 00 00 00       	jmp    802ff3 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  802f31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f34:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3e:	01 d0                	add    %edx,%eax
  802f40:	8b 00                	mov    (%eax),%eax
  802f42:	85 c0                	test   %eax,%eax
  802f44:	75 08                	jne    802f4e <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  802f46:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  802f49:	e9 a2 00 00 00       	jmp    802ff0 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  802f4e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802f55:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802f5c:	eb 69                	jmp    802fc7 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  802f5e:	a1 20 40 80 00       	mov    0x804020,%eax
  802f63:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  802f69:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f6c:	89 d0                	mov    %edx,%eax
  802f6e:	01 c0                	add    %eax,%eax
  802f70:	01 d0                	add    %edx,%eax
  802f72:	c1 e0 03             	shl    $0x3,%eax
  802f75:	01 c8                	add    %ecx,%eax
  802f77:	8a 40 04             	mov    0x4(%eax),%al
  802f7a:	84 c0                	test   %al,%al
  802f7c:	75 46                	jne    802fc4 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  802f7e:	a1 20 40 80 00       	mov    0x804020,%eax
  802f83:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  802f89:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f8c:	89 d0                	mov    %edx,%eax
  802f8e:	01 c0                	add    %eax,%eax
  802f90:	01 d0                	add    %edx,%eax
  802f92:	c1 e0 03             	shl    $0x3,%eax
  802f95:	01 c8                	add    %ecx,%eax
  802f97:	8b 00                	mov    (%eax),%eax
  802f99:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802f9c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f9f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802fa4:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  802fa6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fa9:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  802fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb3:	01 c8                	add    %ecx,%eax
  802fb5:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  802fb7:	39 c2                	cmp    %eax,%edx
  802fb9:	75 09                	jne    802fc4 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  802fbb:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  802fc2:	eb 12                	jmp    802fd6 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802fc4:	ff 45 e8             	incl   -0x18(%ebp)
  802fc7:	a1 20 40 80 00       	mov    0x804020,%eax
  802fcc:	8b 50 74             	mov    0x74(%eax),%edx
  802fcf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fd2:	39 c2                	cmp    %eax,%edx
  802fd4:	77 88                	ja     802f5e <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  802fd6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802fda:	75 14                	jne    802ff0 <CheckWSWithoutLastIndex+0xfb>
			panic(
  802fdc:	83 ec 04             	sub    $0x4,%esp
  802fdf:	68 68 3a 80 00       	push   $0x803a68
  802fe4:	6a 3a                	push   $0x3a
  802fe6:	68 5c 3a 80 00       	push   $0x803a5c
  802feb:	e8 93 fe ff ff       	call   802e83 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  802ff0:	ff 45 f0             	incl   -0x10(%ebp)
  802ff3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ff6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802ff9:	0f 8c 32 ff ff ff    	jl     802f31 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  802fff:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803006:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80300d:	eb 26                	jmp    803035 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80300f:	a1 20 40 80 00       	mov    0x804020,%eax
  803014:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80301a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80301d:	89 d0                	mov    %edx,%eax
  80301f:	01 c0                	add    %eax,%eax
  803021:	01 d0                	add    %edx,%eax
  803023:	c1 e0 03             	shl    $0x3,%eax
  803026:	01 c8                	add    %ecx,%eax
  803028:	8a 40 04             	mov    0x4(%eax),%al
  80302b:	3c 01                	cmp    $0x1,%al
  80302d:	75 03                	jne    803032 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80302f:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803032:	ff 45 e0             	incl   -0x20(%ebp)
  803035:	a1 20 40 80 00       	mov    0x804020,%eax
  80303a:	8b 50 74             	mov    0x74(%eax),%edx
  80303d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803040:	39 c2                	cmp    %eax,%edx
  803042:	77 cb                	ja     80300f <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803044:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803047:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80304a:	74 14                	je     803060 <CheckWSWithoutLastIndex+0x16b>
		panic(
  80304c:	83 ec 04             	sub    $0x4,%esp
  80304f:	68 bc 3a 80 00       	push   $0x803abc
  803054:	6a 44                	push   $0x44
  803056:	68 5c 3a 80 00       	push   $0x803a5c
  80305b:	e8 23 fe ff ff       	call   802e83 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803060:	90                   	nop
  803061:	c9                   	leave  
  803062:	c3                   	ret    
  803063:	90                   	nop

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
