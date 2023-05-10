
obj/user/fos_alloc:     file format elf32-i386


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
  800031:	e8 02 01 00 00       	call   800138 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>


void _main(void)
{	
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	//uint32 size = 2*1024*1024 +120*4096+1;
	//uint32 size = 1*1024*1024 + 256*1024;
	//uint32 size = 1*1024*1024;
	uint32 size = 100;
  80003e:	c7 45 f0 64 00 00 00 	movl   $0x64,-0x10(%ebp)

	unsigned char *x = malloc(sizeof(unsigned char)*size) ;
  800045:	83 ec 0c             	sub    $0xc,%esp
  800048:	ff 75 f0             	pushl  -0x10(%ebp)
  80004b:	e8 24 12 00 00       	call   801274 <malloc>
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	89 45 ec             	mov    %eax,-0x14(%ebp)
	atomic_cprintf("x allocated at %x\n",x);
  800056:	83 ec 08             	sub    $0x8,%esp
  800059:	ff 75 ec             	pushl  -0x14(%ebp)
  80005c:	68 e0 31 80 00       	push   $0x8031e0
  800061:	e8 0f 03 00 00       	call   800375 <atomic_cprintf>
  800066:	83 c4 10             	add    $0x10,%esp

	//unsigned char *z = malloc(sizeof(unsigned char)*size) ;
	//cprintf("z allocated at %x\n",z);
	
	int i ;
	for (i = 0 ; i < size ; i++)
  800069:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800070:	eb 20                	jmp    800092 <_main+0x5a>
	{
		x[i] = i%256 ;
  800072:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800075:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800078:	01 c2                	add    %eax,%edx
  80007a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80007d:	25 ff 00 00 80       	and    $0x800000ff,%eax
  800082:	85 c0                	test   %eax,%eax
  800084:	79 07                	jns    80008d <_main+0x55>
  800086:	48                   	dec    %eax
  800087:	0d 00 ff ff ff       	or     $0xffffff00,%eax
  80008c:	40                   	inc    %eax
  80008d:	88 02                	mov    %al,(%edx)

	//unsigned char *z = malloc(sizeof(unsigned char)*size) ;
	//cprintf("z allocated at %x\n",z);
	
	int i ;
	for (i = 0 ; i < size ; i++)
  80008f:	ff 45 f4             	incl   -0xc(%ebp)
  800092:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800095:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800098:	72 d8                	jb     800072 <_main+0x3a>
		////z[i] = (int)(x[i]  * y[i]);
		////z[i] = i%256;
	}

	
	for (i = size-7 ; i < size ; i++)
  80009a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80009d:	83 e8 07             	sub    $0x7,%eax
  8000a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8000a3:	eb 24                	jmp    8000c9 <_main+0x91>
		atomic_cprintf("x[%d] = %d\n",i, x[i]);
  8000a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000ab:	01 d0                	add    %edx,%eax
  8000ad:	8a 00                	mov    (%eax),%al
  8000af:	0f b6 c0             	movzbl %al,%eax
  8000b2:	83 ec 04             	sub    $0x4,%esp
  8000b5:	50                   	push   %eax
  8000b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8000b9:	68 f3 31 80 00       	push   $0x8031f3
  8000be:	e8 b2 02 00 00       	call   800375 <atomic_cprintf>
  8000c3:	83 c4 10             	add    $0x10,%esp
		////z[i] = (int)(x[i]  * y[i]);
		////z[i] = i%256;
	}

	
	for (i = size-7 ; i < size ; i++)
  8000c6:	ff 45 f4             	incl   -0xc(%ebp)
  8000c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000cc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8000cf:	72 d4                	jb     8000a5 <_main+0x6d>
		atomic_cprintf("x[%d] = %d\n",i, x[i]);
	
	free(x);
  8000d1:	83 ec 0c             	sub    $0xc,%esp
  8000d4:	ff 75 ec             	pushl  -0x14(%ebp)
  8000d7:	e8 13 12 00 00       	call   8012ef <free>
  8000dc:	83 c4 10             	add    $0x10,%esp

	x = malloc(sizeof(unsigned char)*size) ;
  8000df:	83 ec 0c             	sub    $0xc,%esp
  8000e2:	ff 75 f0             	pushl  -0x10(%ebp)
  8000e5:	e8 8a 11 00 00       	call   801274 <malloc>
  8000ea:	83 c4 10             	add    $0x10,%esp
  8000ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
	
	for (i = size-7 ; i < size ; i++)
  8000f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000f3:	83 e8 07             	sub    $0x7,%eax
  8000f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8000f9:	eb 24                	jmp    80011f <_main+0xe7>
	{
		atomic_cprintf("x[%d] = %d\n",i,x[i]);
  8000fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800101:	01 d0                	add    %edx,%eax
  800103:	8a 00                	mov    (%eax),%al
  800105:	0f b6 c0             	movzbl %al,%eax
  800108:	83 ec 04             	sub    $0x4,%esp
  80010b:	50                   	push   %eax
  80010c:	ff 75 f4             	pushl  -0xc(%ebp)
  80010f:	68 f3 31 80 00       	push   $0x8031f3
  800114:	e8 5c 02 00 00       	call   800375 <atomic_cprintf>
  800119:	83 c4 10             	add    $0x10,%esp
	
	free(x);

	x = malloc(sizeof(unsigned char)*size) ;
	
	for (i = size-7 ; i < size ; i++)
  80011c:	ff 45 f4             	incl   -0xc(%ebp)
  80011f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800122:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800125:	72 d4                	jb     8000fb <_main+0xc3>
	{
		atomic_cprintf("x[%d] = %d\n",i,x[i]);
	}

	free(x);
  800127:	83 ec 0c             	sub    $0xc,%esp
  80012a:	ff 75 ec             	pushl  -0x14(%ebp)
  80012d:	e8 bd 11 00 00       	call   8012ef <free>
  800132:	83 c4 10             	add    $0x10,%esp
	
	return;	
  800135:	90                   	nop
}
  800136:	c9                   	leave  
  800137:	c3                   	ret    

00800138 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800138:	55                   	push   %ebp
  800139:	89 e5                	mov    %esp,%ebp
  80013b:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80013e:	e8 3f 18 00 00       	call   801982 <sys_getenvindex>
  800143:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800146:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800149:	89 d0                	mov    %edx,%eax
  80014b:	c1 e0 03             	shl    $0x3,%eax
  80014e:	01 d0                	add    %edx,%eax
  800150:	01 c0                	add    %eax,%eax
  800152:	01 d0                	add    %edx,%eax
  800154:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80015b:	01 d0                	add    %edx,%eax
  80015d:	c1 e0 04             	shl    $0x4,%eax
  800160:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800165:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80016a:	a1 20 40 80 00       	mov    0x804020,%eax
  80016f:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800175:	84 c0                	test   %al,%al
  800177:	74 0f                	je     800188 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800179:	a1 20 40 80 00       	mov    0x804020,%eax
  80017e:	05 5c 05 00 00       	add    $0x55c,%eax
  800183:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800188:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80018c:	7e 0a                	jle    800198 <libmain+0x60>
		binaryname = argv[0];
  80018e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800191:	8b 00                	mov    (%eax),%eax
  800193:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800198:	83 ec 08             	sub    $0x8,%esp
  80019b:	ff 75 0c             	pushl  0xc(%ebp)
  80019e:	ff 75 08             	pushl  0x8(%ebp)
  8001a1:	e8 92 fe ff ff       	call   800038 <_main>
  8001a6:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001a9:	e8 e1 15 00 00       	call   80178f <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001ae:	83 ec 0c             	sub    $0xc,%esp
  8001b1:	68 18 32 80 00       	push   $0x803218
  8001b6:	e8 8d 01 00 00       	call   800348 <cprintf>
  8001bb:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001be:	a1 20 40 80 00       	mov    0x804020,%eax
  8001c3:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8001c9:	a1 20 40 80 00       	mov    0x804020,%eax
  8001ce:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8001d4:	83 ec 04             	sub    $0x4,%esp
  8001d7:	52                   	push   %edx
  8001d8:	50                   	push   %eax
  8001d9:	68 40 32 80 00       	push   $0x803240
  8001de:	e8 65 01 00 00       	call   800348 <cprintf>
  8001e3:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001e6:	a1 20 40 80 00       	mov    0x804020,%eax
  8001eb:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8001f1:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f6:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8001fc:	a1 20 40 80 00       	mov    0x804020,%eax
  800201:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800207:	51                   	push   %ecx
  800208:	52                   	push   %edx
  800209:	50                   	push   %eax
  80020a:	68 68 32 80 00       	push   $0x803268
  80020f:	e8 34 01 00 00       	call   800348 <cprintf>
  800214:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800217:	a1 20 40 80 00       	mov    0x804020,%eax
  80021c:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800222:	83 ec 08             	sub    $0x8,%esp
  800225:	50                   	push   %eax
  800226:	68 c0 32 80 00       	push   $0x8032c0
  80022b:	e8 18 01 00 00       	call   800348 <cprintf>
  800230:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800233:	83 ec 0c             	sub    $0xc,%esp
  800236:	68 18 32 80 00       	push   $0x803218
  80023b:	e8 08 01 00 00       	call   800348 <cprintf>
  800240:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800243:	e8 61 15 00 00       	call   8017a9 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800248:	e8 19 00 00 00       	call   800266 <exit>
}
  80024d:	90                   	nop
  80024e:	c9                   	leave  
  80024f:	c3                   	ret    

00800250 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800250:	55                   	push   %ebp
  800251:	89 e5                	mov    %esp,%ebp
  800253:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800256:	83 ec 0c             	sub    $0xc,%esp
  800259:	6a 00                	push   $0x0
  80025b:	e8 ee 16 00 00       	call   80194e <sys_destroy_env>
  800260:	83 c4 10             	add    $0x10,%esp
}
  800263:	90                   	nop
  800264:	c9                   	leave  
  800265:	c3                   	ret    

00800266 <exit>:

void
exit(void)
{
  800266:	55                   	push   %ebp
  800267:	89 e5                	mov    %esp,%ebp
  800269:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80026c:	e8 43 17 00 00       	call   8019b4 <sys_exit_env>
}
  800271:	90                   	nop
  800272:	c9                   	leave  
  800273:	c3                   	ret    

00800274 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800274:	55                   	push   %ebp
  800275:	89 e5                	mov    %esp,%ebp
  800277:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80027a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80027d:	8b 00                	mov    (%eax),%eax
  80027f:	8d 48 01             	lea    0x1(%eax),%ecx
  800282:	8b 55 0c             	mov    0xc(%ebp),%edx
  800285:	89 0a                	mov    %ecx,(%edx)
  800287:	8b 55 08             	mov    0x8(%ebp),%edx
  80028a:	88 d1                	mov    %dl,%cl
  80028c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80028f:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800293:	8b 45 0c             	mov    0xc(%ebp),%eax
  800296:	8b 00                	mov    (%eax),%eax
  800298:	3d ff 00 00 00       	cmp    $0xff,%eax
  80029d:	75 2c                	jne    8002cb <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80029f:	a0 24 40 80 00       	mov    0x804024,%al
  8002a4:	0f b6 c0             	movzbl %al,%eax
  8002a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002aa:	8b 12                	mov    (%edx),%edx
  8002ac:	89 d1                	mov    %edx,%ecx
  8002ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002b1:	83 c2 08             	add    $0x8,%edx
  8002b4:	83 ec 04             	sub    $0x4,%esp
  8002b7:	50                   	push   %eax
  8002b8:	51                   	push   %ecx
  8002b9:	52                   	push   %edx
  8002ba:	e8 22 13 00 00       	call   8015e1 <sys_cputs>
  8002bf:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8002c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8002cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ce:	8b 40 04             	mov    0x4(%eax),%eax
  8002d1:	8d 50 01             	lea    0x1(%eax),%edx
  8002d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002d7:	89 50 04             	mov    %edx,0x4(%eax)
}
  8002da:	90                   	nop
  8002db:	c9                   	leave  
  8002dc:	c3                   	ret    

008002dd <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8002dd:	55                   	push   %ebp
  8002de:	89 e5                	mov    %esp,%ebp
  8002e0:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002e6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002ed:	00 00 00 
	b.cnt = 0;
  8002f0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002f7:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8002fa:	ff 75 0c             	pushl  0xc(%ebp)
  8002fd:	ff 75 08             	pushl  0x8(%ebp)
  800300:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800306:	50                   	push   %eax
  800307:	68 74 02 80 00       	push   $0x800274
  80030c:	e8 11 02 00 00       	call   800522 <vprintfmt>
  800311:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800314:	a0 24 40 80 00       	mov    0x804024,%al
  800319:	0f b6 c0             	movzbl %al,%eax
  80031c:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800322:	83 ec 04             	sub    $0x4,%esp
  800325:	50                   	push   %eax
  800326:	52                   	push   %edx
  800327:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80032d:	83 c0 08             	add    $0x8,%eax
  800330:	50                   	push   %eax
  800331:	e8 ab 12 00 00       	call   8015e1 <sys_cputs>
  800336:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800339:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800340:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800346:	c9                   	leave  
  800347:	c3                   	ret    

00800348 <cprintf>:

int cprintf(const char *fmt, ...) {
  800348:	55                   	push   %ebp
  800349:	89 e5                	mov    %esp,%ebp
  80034b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80034e:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800355:	8d 45 0c             	lea    0xc(%ebp),%eax
  800358:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80035b:	8b 45 08             	mov    0x8(%ebp),%eax
  80035e:	83 ec 08             	sub    $0x8,%esp
  800361:	ff 75 f4             	pushl  -0xc(%ebp)
  800364:	50                   	push   %eax
  800365:	e8 73 ff ff ff       	call   8002dd <vcprintf>
  80036a:	83 c4 10             	add    $0x10,%esp
  80036d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800370:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800373:	c9                   	leave  
  800374:	c3                   	ret    

00800375 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800375:	55                   	push   %ebp
  800376:	89 e5                	mov    %esp,%ebp
  800378:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80037b:	e8 0f 14 00 00       	call   80178f <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800380:	8d 45 0c             	lea    0xc(%ebp),%eax
  800383:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800386:	8b 45 08             	mov    0x8(%ebp),%eax
  800389:	83 ec 08             	sub    $0x8,%esp
  80038c:	ff 75 f4             	pushl  -0xc(%ebp)
  80038f:	50                   	push   %eax
  800390:	e8 48 ff ff ff       	call   8002dd <vcprintf>
  800395:	83 c4 10             	add    $0x10,%esp
  800398:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80039b:	e8 09 14 00 00       	call   8017a9 <sys_enable_interrupt>
	return cnt;
  8003a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003a3:	c9                   	leave  
  8003a4:	c3                   	ret    

008003a5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003a5:	55                   	push   %ebp
  8003a6:	89 e5                	mov    %esp,%ebp
  8003a8:	53                   	push   %ebx
  8003a9:	83 ec 14             	sub    $0x14,%esp
  8003ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8003af:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8003b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003b8:	8b 45 18             	mov    0x18(%ebp),%eax
  8003bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8003c0:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003c3:	77 55                	ja     80041a <printnum+0x75>
  8003c5:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003c8:	72 05                	jb     8003cf <printnum+0x2a>
  8003ca:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8003cd:	77 4b                	ja     80041a <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003cf:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8003d2:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8003d5:	8b 45 18             	mov    0x18(%ebp),%eax
  8003d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8003dd:	52                   	push   %edx
  8003de:	50                   	push   %eax
  8003df:	ff 75 f4             	pushl  -0xc(%ebp)
  8003e2:	ff 75 f0             	pushl  -0x10(%ebp)
  8003e5:	e8 92 2b 00 00       	call   802f7c <__udivdi3>
  8003ea:	83 c4 10             	add    $0x10,%esp
  8003ed:	83 ec 04             	sub    $0x4,%esp
  8003f0:	ff 75 20             	pushl  0x20(%ebp)
  8003f3:	53                   	push   %ebx
  8003f4:	ff 75 18             	pushl  0x18(%ebp)
  8003f7:	52                   	push   %edx
  8003f8:	50                   	push   %eax
  8003f9:	ff 75 0c             	pushl  0xc(%ebp)
  8003fc:	ff 75 08             	pushl  0x8(%ebp)
  8003ff:	e8 a1 ff ff ff       	call   8003a5 <printnum>
  800404:	83 c4 20             	add    $0x20,%esp
  800407:	eb 1a                	jmp    800423 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800409:	83 ec 08             	sub    $0x8,%esp
  80040c:	ff 75 0c             	pushl  0xc(%ebp)
  80040f:	ff 75 20             	pushl  0x20(%ebp)
  800412:	8b 45 08             	mov    0x8(%ebp),%eax
  800415:	ff d0                	call   *%eax
  800417:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80041a:	ff 4d 1c             	decl   0x1c(%ebp)
  80041d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800421:	7f e6                	jg     800409 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800423:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800426:	bb 00 00 00 00       	mov    $0x0,%ebx
  80042b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80042e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800431:	53                   	push   %ebx
  800432:	51                   	push   %ecx
  800433:	52                   	push   %edx
  800434:	50                   	push   %eax
  800435:	e8 52 2c 00 00       	call   80308c <__umoddi3>
  80043a:	83 c4 10             	add    $0x10,%esp
  80043d:	05 f4 34 80 00       	add    $0x8034f4,%eax
  800442:	8a 00                	mov    (%eax),%al
  800444:	0f be c0             	movsbl %al,%eax
  800447:	83 ec 08             	sub    $0x8,%esp
  80044a:	ff 75 0c             	pushl  0xc(%ebp)
  80044d:	50                   	push   %eax
  80044e:	8b 45 08             	mov    0x8(%ebp),%eax
  800451:	ff d0                	call   *%eax
  800453:	83 c4 10             	add    $0x10,%esp
}
  800456:	90                   	nop
  800457:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80045a:	c9                   	leave  
  80045b:	c3                   	ret    

0080045c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80045c:	55                   	push   %ebp
  80045d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80045f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800463:	7e 1c                	jle    800481 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800465:	8b 45 08             	mov    0x8(%ebp),%eax
  800468:	8b 00                	mov    (%eax),%eax
  80046a:	8d 50 08             	lea    0x8(%eax),%edx
  80046d:	8b 45 08             	mov    0x8(%ebp),%eax
  800470:	89 10                	mov    %edx,(%eax)
  800472:	8b 45 08             	mov    0x8(%ebp),%eax
  800475:	8b 00                	mov    (%eax),%eax
  800477:	83 e8 08             	sub    $0x8,%eax
  80047a:	8b 50 04             	mov    0x4(%eax),%edx
  80047d:	8b 00                	mov    (%eax),%eax
  80047f:	eb 40                	jmp    8004c1 <getuint+0x65>
	else if (lflag)
  800481:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800485:	74 1e                	je     8004a5 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800487:	8b 45 08             	mov    0x8(%ebp),%eax
  80048a:	8b 00                	mov    (%eax),%eax
  80048c:	8d 50 04             	lea    0x4(%eax),%edx
  80048f:	8b 45 08             	mov    0x8(%ebp),%eax
  800492:	89 10                	mov    %edx,(%eax)
  800494:	8b 45 08             	mov    0x8(%ebp),%eax
  800497:	8b 00                	mov    (%eax),%eax
  800499:	83 e8 04             	sub    $0x4,%eax
  80049c:	8b 00                	mov    (%eax),%eax
  80049e:	ba 00 00 00 00       	mov    $0x0,%edx
  8004a3:	eb 1c                	jmp    8004c1 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8004a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a8:	8b 00                	mov    (%eax),%eax
  8004aa:	8d 50 04             	lea    0x4(%eax),%edx
  8004ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b0:	89 10                	mov    %edx,(%eax)
  8004b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b5:	8b 00                	mov    (%eax),%eax
  8004b7:	83 e8 04             	sub    $0x4,%eax
  8004ba:	8b 00                	mov    (%eax),%eax
  8004bc:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004c1:	5d                   	pop    %ebp
  8004c2:	c3                   	ret    

008004c3 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004c3:	55                   	push   %ebp
  8004c4:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004c6:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004ca:	7e 1c                	jle    8004e8 <getint+0x25>
		return va_arg(*ap, long long);
  8004cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8004cf:	8b 00                	mov    (%eax),%eax
  8004d1:	8d 50 08             	lea    0x8(%eax),%edx
  8004d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d7:	89 10                	mov    %edx,(%eax)
  8004d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004dc:	8b 00                	mov    (%eax),%eax
  8004de:	83 e8 08             	sub    $0x8,%eax
  8004e1:	8b 50 04             	mov    0x4(%eax),%edx
  8004e4:	8b 00                	mov    (%eax),%eax
  8004e6:	eb 38                	jmp    800520 <getint+0x5d>
	else if (lflag)
  8004e8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004ec:	74 1a                	je     800508 <getint+0x45>
		return va_arg(*ap, long);
  8004ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f1:	8b 00                	mov    (%eax),%eax
  8004f3:	8d 50 04             	lea    0x4(%eax),%edx
  8004f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f9:	89 10                	mov    %edx,(%eax)
  8004fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004fe:	8b 00                	mov    (%eax),%eax
  800500:	83 e8 04             	sub    $0x4,%eax
  800503:	8b 00                	mov    (%eax),%eax
  800505:	99                   	cltd   
  800506:	eb 18                	jmp    800520 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800508:	8b 45 08             	mov    0x8(%ebp),%eax
  80050b:	8b 00                	mov    (%eax),%eax
  80050d:	8d 50 04             	lea    0x4(%eax),%edx
  800510:	8b 45 08             	mov    0x8(%ebp),%eax
  800513:	89 10                	mov    %edx,(%eax)
  800515:	8b 45 08             	mov    0x8(%ebp),%eax
  800518:	8b 00                	mov    (%eax),%eax
  80051a:	83 e8 04             	sub    $0x4,%eax
  80051d:	8b 00                	mov    (%eax),%eax
  80051f:	99                   	cltd   
}
  800520:	5d                   	pop    %ebp
  800521:	c3                   	ret    

00800522 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800522:	55                   	push   %ebp
  800523:	89 e5                	mov    %esp,%ebp
  800525:	56                   	push   %esi
  800526:	53                   	push   %ebx
  800527:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80052a:	eb 17                	jmp    800543 <vprintfmt+0x21>
			if (ch == '\0')
  80052c:	85 db                	test   %ebx,%ebx
  80052e:	0f 84 af 03 00 00    	je     8008e3 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800534:	83 ec 08             	sub    $0x8,%esp
  800537:	ff 75 0c             	pushl  0xc(%ebp)
  80053a:	53                   	push   %ebx
  80053b:	8b 45 08             	mov    0x8(%ebp),%eax
  80053e:	ff d0                	call   *%eax
  800540:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800543:	8b 45 10             	mov    0x10(%ebp),%eax
  800546:	8d 50 01             	lea    0x1(%eax),%edx
  800549:	89 55 10             	mov    %edx,0x10(%ebp)
  80054c:	8a 00                	mov    (%eax),%al
  80054e:	0f b6 d8             	movzbl %al,%ebx
  800551:	83 fb 25             	cmp    $0x25,%ebx
  800554:	75 d6                	jne    80052c <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800556:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80055a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800561:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800568:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80056f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800576:	8b 45 10             	mov    0x10(%ebp),%eax
  800579:	8d 50 01             	lea    0x1(%eax),%edx
  80057c:	89 55 10             	mov    %edx,0x10(%ebp)
  80057f:	8a 00                	mov    (%eax),%al
  800581:	0f b6 d8             	movzbl %al,%ebx
  800584:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800587:	83 f8 55             	cmp    $0x55,%eax
  80058a:	0f 87 2b 03 00 00    	ja     8008bb <vprintfmt+0x399>
  800590:	8b 04 85 18 35 80 00 	mov    0x803518(,%eax,4),%eax
  800597:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800599:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80059d:	eb d7                	jmp    800576 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80059f:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8005a3:	eb d1                	jmp    800576 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005a5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8005ac:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005af:	89 d0                	mov    %edx,%eax
  8005b1:	c1 e0 02             	shl    $0x2,%eax
  8005b4:	01 d0                	add    %edx,%eax
  8005b6:	01 c0                	add    %eax,%eax
  8005b8:	01 d8                	add    %ebx,%eax
  8005ba:	83 e8 30             	sub    $0x30,%eax
  8005bd:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8005c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8005c3:	8a 00                	mov    (%eax),%al
  8005c5:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8005c8:	83 fb 2f             	cmp    $0x2f,%ebx
  8005cb:	7e 3e                	jle    80060b <vprintfmt+0xe9>
  8005cd:	83 fb 39             	cmp    $0x39,%ebx
  8005d0:	7f 39                	jg     80060b <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005d2:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8005d5:	eb d5                	jmp    8005ac <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8005d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005da:	83 c0 04             	add    $0x4,%eax
  8005dd:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e3:	83 e8 04             	sub    $0x4,%eax
  8005e6:	8b 00                	mov    (%eax),%eax
  8005e8:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8005eb:	eb 1f                	jmp    80060c <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8005ed:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005f1:	79 83                	jns    800576 <vprintfmt+0x54>
				width = 0;
  8005f3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8005fa:	e9 77 ff ff ff       	jmp    800576 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8005ff:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800606:	e9 6b ff ff ff       	jmp    800576 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80060b:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80060c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800610:	0f 89 60 ff ff ff    	jns    800576 <vprintfmt+0x54>
				width = precision, precision = -1;
  800616:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800619:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80061c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800623:	e9 4e ff ff ff       	jmp    800576 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800628:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80062b:	e9 46 ff ff ff       	jmp    800576 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800630:	8b 45 14             	mov    0x14(%ebp),%eax
  800633:	83 c0 04             	add    $0x4,%eax
  800636:	89 45 14             	mov    %eax,0x14(%ebp)
  800639:	8b 45 14             	mov    0x14(%ebp),%eax
  80063c:	83 e8 04             	sub    $0x4,%eax
  80063f:	8b 00                	mov    (%eax),%eax
  800641:	83 ec 08             	sub    $0x8,%esp
  800644:	ff 75 0c             	pushl  0xc(%ebp)
  800647:	50                   	push   %eax
  800648:	8b 45 08             	mov    0x8(%ebp),%eax
  80064b:	ff d0                	call   *%eax
  80064d:	83 c4 10             	add    $0x10,%esp
			break;
  800650:	e9 89 02 00 00       	jmp    8008de <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800655:	8b 45 14             	mov    0x14(%ebp),%eax
  800658:	83 c0 04             	add    $0x4,%eax
  80065b:	89 45 14             	mov    %eax,0x14(%ebp)
  80065e:	8b 45 14             	mov    0x14(%ebp),%eax
  800661:	83 e8 04             	sub    $0x4,%eax
  800664:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800666:	85 db                	test   %ebx,%ebx
  800668:	79 02                	jns    80066c <vprintfmt+0x14a>
				err = -err;
  80066a:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80066c:	83 fb 64             	cmp    $0x64,%ebx
  80066f:	7f 0b                	jg     80067c <vprintfmt+0x15a>
  800671:	8b 34 9d 60 33 80 00 	mov    0x803360(,%ebx,4),%esi
  800678:	85 f6                	test   %esi,%esi
  80067a:	75 19                	jne    800695 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80067c:	53                   	push   %ebx
  80067d:	68 05 35 80 00       	push   $0x803505
  800682:	ff 75 0c             	pushl  0xc(%ebp)
  800685:	ff 75 08             	pushl  0x8(%ebp)
  800688:	e8 5e 02 00 00       	call   8008eb <printfmt>
  80068d:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800690:	e9 49 02 00 00       	jmp    8008de <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800695:	56                   	push   %esi
  800696:	68 0e 35 80 00       	push   $0x80350e
  80069b:	ff 75 0c             	pushl  0xc(%ebp)
  80069e:	ff 75 08             	pushl  0x8(%ebp)
  8006a1:	e8 45 02 00 00       	call   8008eb <printfmt>
  8006a6:	83 c4 10             	add    $0x10,%esp
			break;
  8006a9:	e9 30 02 00 00       	jmp    8008de <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b1:	83 c0 04             	add    $0x4,%eax
  8006b4:	89 45 14             	mov    %eax,0x14(%ebp)
  8006b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ba:	83 e8 04             	sub    $0x4,%eax
  8006bd:	8b 30                	mov    (%eax),%esi
  8006bf:	85 f6                	test   %esi,%esi
  8006c1:	75 05                	jne    8006c8 <vprintfmt+0x1a6>
				p = "(null)";
  8006c3:	be 11 35 80 00       	mov    $0x803511,%esi
			if (width > 0 && padc != '-')
  8006c8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006cc:	7e 6d                	jle    80073b <vprintfmt+0x219>
  8006ce:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8006d2:	74 67                	je     80073b <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006d7:	83 ec 08             	sub    $0x8,%esp
  8006da:	50                   	push   %eax
  8006db:	56                   	push   %esi
  8006dc:	e8 0c 03 00 00       	call   8009ed <strnlen>
  8006e1:	83 c4 10             	add    $0x10,%esp
  8006e4:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8006e7:	eb 16                	jmp    8006ff <vprintfmt+0x1dd>
					putch(padc, putdat);
  8006e9:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8006ed:	83 ec 08             	sub    $0x8,%esp
  8006f0:	ff 75 0c             	pushl  0xc(%ebp)
  8006f3:	50                   	push   %eax
  8006f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f7:	ff d0                	call   *%eax
  8006f9:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006fc:	ff 4d e4             	decl   -0x1c(%ebp)
  8006ff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800703:	7f e4                	jg     8006e9 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800705:	eb 34                	jmp    80073b <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800707:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80070b:	74 1c                	je     800729 <vprintfmt+0x207>
  80070d:	83 fb 1f             	cmp    $0x1f,%ebx
  800710:	7e 05                	jle    800717 <vprintfmt+0x1f5>
  800712:	83 fb 7e             	cmp    $0x7e,%ebx
  800715:	7e 12                	jle    800729 <vprintfmt+0x207>
					putch('?', putdat);
  800717:	83 ec 08             	sub    $0x8,%esp
  80071a:	ff 75 0c             	pushl  0xc(%ebp)
  80071d:	6a 3f                	push   $0x3f
  80071f:	8b 45 08             	mov    0x8(%ebp),%eax
  800722:	ff d0                	call   *%eax
  800724:	83 c4 10             	add    $0x10,%esp
  800727:	eb 0f                	jmp    800738 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800729:	83 ec 08             	sub    $0x8,%esp
  80072c:	ff 75 0c             	pushl  0xc(%ebp)
  80072f:	53                   	push   %ebx
  800730:	8b 45 08             	mov    0x8(%ebp),%eax
  800733:	ff d0                	call   *%eax
  800735:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800738:	ff 4d e4             	decl   -0x1c(%ebp)
  80073b:	89 f0                	mov    %esi,%eax
  80073d:	8d 70 01             	lea    0x1(%eax),%esi
  800740:	8a 00                	mov    (%eax),%al
  800742:	0f be d8             	movsbl %al,%ebx
  800745:	85 db                	test   %ebx,%ebx
  800747:	74 24                	je     80076d <vprintfmt+0x24b>
  800749:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80074d:	78 b8                	js     800707 <vprintfmt+0x1e5>
  80074f:	ff 4d e0             	decl   -0x20(%ebp)
  800752:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800756:	79 af                	jns    800707 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800758:	eb 13                	jmp    80076d <vprintfmt+0x24b>
				putch(' ', putdat);
  80075a:	83 ec 08             	sub    $0x8,%esp
  80075d:	ff 75 0c             	pushl  0xc(%ebp)
  800760:	6a 20                	push   $0x20
  800762:	8b 45 08             	mov    0x8(%ebp),%eax
  800765:	ff d0                	call   *%eax
  800767:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80076a:	ff 4d e4             	decl   -0x1c(%ebp)
  80076d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800771:	7f e7                	jg     80075a <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800773:	e9 66 01 00 00       	jmp    8008de <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800778:	83 ec 08             	sub    $0x8,%esp
  80077b:	ff 75 e8             	pushl  -0x18(%ebp)
  80077e:	8d 45 14             	lea    0x14(%ebp),%eax
  800781:	50                   	push   %eax
  800782:	e8 3c fd ff ff       	call   8004c3 <getint>
  800787:	83 c4 10             	add    $0x10,%esp
  80078a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80078d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800790:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800793:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800796:	85 d2                	test   %edx,%edx
  800798:	79 23                	jns    8007bd <vprintfmt+0x29b>
				putch('-', putdat);
  80079a:	83 ec 08             	sub    $0x8,%esp
  80079d:	ff 75 0c             	pushl  0xc(%ebp)
  8007a0:	6a 2d                	push   $0x2d
  8007a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a5:	ff d0                	call   *%eax
  8007a7:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8007aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007b0:	f7 d8                	neg    %eax
  8007b2:	83 d2 00             	adc    $0x0,%edx
  8007b5:	f7 da                	neg    %edx
  8007b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007ba:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8007bd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007c4:	e9 bc 00 00 00       	jmp    800885 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007c9:	83 ec 08             	sub    $0x8,%esp
  8007cc:	ff 75 e8             	pushl  -0x18(%ebp)
  8007cf:	8d 45 14             	lea    0x14(%ebp),%eax
  8007d2:	50                   	push   %eax
  8007d3:	e8 84 fc ff ff       	call   80045c <getuint>
  8007d8:	83 c4 10             	add    $0x10,%esp
  8007db:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007de:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8007e1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007e8:	e9 98 00 00 00       	jmp    800885 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8007ed:	83 ec 08             	sub    $0x8,%esp
  8007f0:	ff 75 0c             	pushl  0xc(%ebp)
  8007f3:	6a 58                	push   $0x58
  8007f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f8:	ff d0                	call   *%eax
  8007fa:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007fd:	83 ec 08             	sub    $0x8,%esp
  800800:	ff 75 0c             	pushl  0xc(%ebp)
  800803:	6a 58                	push   $0x58
  800805:	8b 45 08             	mov    0x8(%ebp),%eax
  800808:	ff d0                	call   *%eax
  80080a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80080d:	83 ec 08             	sub    $0x8,%esp
  800810:	ff 75 0c             	pushl  0xc(%ebp)
  800813:	6a 58                	push   $0x58
  800815:	8b 45 08             	mov    0x8(%ebp),%eax
  800818:	ff d0                	call   *%eax
  80081a:	83 c4 10             	add    $0x10,%esp
			break;
  80081d:	e9 bc 00 00 00       	jmp    8008de <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800822:	83 ec 08             	sub    $0x8,%esp
  800825:	ff 75 0c             	pushl  0xc(%ebp)
  800828:	6a 30                	push   $0x30
  80082a:	8b 45 08             	mov    0x8(%ebp),%eax
  80082d:	ff d0                	call   *%eax
  80082f:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800832:	83 ec 08             	sub    $0x8,%esp
  800835:	ff 75 0c             	pushl  0xc(%ebp)
  800838:	6a 78                	push   $0x78
  80083a:	8b 45 08             	mov    0x8(%ebp),%eax
  80083d:	ff d0                	call   *%eax
  80083f:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800842:	8b 45 14             	mov    0x14(%ebp),%eax
  800845:	83 c0 04             	add    $0x4,%eax
  800848:	89 45 14             	mov    %eax,0x14(%ebp)
  80084b:	8b 45 14             	mov    0x14(%ebp),%eax
  80084e:	83 e8 04             	sub    $0x4,%eax
  800851:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800853:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800856:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80085d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800864:	eb 1f                	jmp    800885 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800866:	83 ec 08             	sub    $0x8,%esp
  800869:	ff 75 e8             	pushl  -0x18(%ebp)
  80086c:	8d 45 14             	lea    0x14(%ebp),%eax
  80086f:	50                   	push   %eax
  800870:	e8 e7 fb ff ff       	call   80045c <getuint>
  800875:	83 c4 10             	add    $0x10,%esp
  800878:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80087b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80087e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800885:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800889:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80088c:	83 ec 04             	sub    $0x4,%esp
  80088f:	52                   	push   %edx
  800890:	ff 75 e4             	pushl  -0x1c(%ebp)
  800893:	50                   	push   %eax
  800894:	ff 75 f4             	pushl  -0xc(%ebp)
  800897:	ff 75 f0             	pushl  -0x10(%ebp)
  80089a:	ff 75 0c             	pushl  0xc(%ebp)
  80089d:	ff 75 08             	pushl  0x8(%ebp)
  8008a0:	e8 00 fb ff ff       	call   8003a5 <printnum>
  8008a5:	83 c4 20             	add    $0x20,%esp
			break;
  8008a8:	eb 34                	jmp    8008de <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008aa:	83 ec 08             	sub    $0x8,%esp
  8008ad:	ff 75 0c             	pushl  0xc(%ebp)
  8008b0:	53                   	push   %ebx
  8008b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b4:	ff d0                	call   *%eax
  8008b6:	83 c4 10             	add    $0x10,%esp
			break;
  8008b9:	eb 23                	jmp    8008de <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008bb:	83 ec 08             	sub    $0x8,%esp
  8008be:	ff 75 0c             	pushl  0xc(%ebp)
  8008c1:	6a 25                	push   $0x25
  8008c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c6:	ff d0                	call   *%eax
  8008c8:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008cb:	ff 4d 10             	decl   0x10(%ebp)
  8008ce:	eb 03                	jmp    8008d3 <vprintfmt+0x3b1>
  8008d0:	ff 4d 10             	decl   0x10(%ebp)
  8008d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8008d6:	48                   	dec    %eax
  8008d7:	8a 00                	mov    (%eax),%al
  8008d9:	3c 25                	cmp    $0x25,%al
  8008db:	75 f3                	jne    8008d0 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8008dd:	90                   	nop
		}
	}
  8008de:	e9 47 fc ff ff       	jmp    80052a <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8008e3:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8008e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008e7:	5b                   	pop    %ebx
  8008e8:	5e                   	pop    %esi
  8008e9:	5d                   	pop    %ebp
  8008ea:	c3                   	ret    

008008eb <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8008eb:	55                   	push   %ebp
  8008ec:	89 e5                	mov    %esp,%ebp
  8008ee:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8008f1:	8d 45 10             	lea    0x10(%ebp),%eax
  8008f4:	83 c0 04             	add    $0x4,%eax
  8008f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8008fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8008fd:	ff 75 f4             	pushl  -0xc(%ebp)
  800900:	50                   	push   %eax
  800901:	ff 75 0c             	pushl  0xc(%ebp)
  800904:	ff 75 08             	pushl  0x8(%ebp)
  800907:	e8 16 fc ff ff       	call   800522 <vprintfmt>
  80090c:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80090f:	90                   	nop
  800910:	c9                   	leave  
  800911:	c3                   	ret    

00800912 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800912:	55                   	push   %ebp
  800913:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800915:	8b 45 0c             	mov    0xc(%ebp),%eax
  800918:	8b 40 08             	mov    0x8(%eax),%eax
  80091b:	8d 50 01             	lea    0x1(%eax),%edx
  80091e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800921:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800924:	8b 45 0c             	mov    0xc(%ebp),%eax
  800927:	8b 10                	mov    (%eax),%edx
  800929:	8b 45 0c             	mov    0xc(%ebp),%eax
  80092c:	8b 40 04             	mov    0x4(%eax),%eax
  80092f:	39 c2                	cmp    %eax,%edx
  800931:	73 12                	jae    800945 <sprintputch+0x33>
		*b->buf++ = ch;
  800933:	8b 45 0c             	mov    0xc(%ebp),%eax
  800936:	8b 00                	mov    (%eax),%eax
  800938:	8d 48 01             	lea    0x1(%eax),%ecx
  80093b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80093e:	89 0a                	mov    %ecx,(%edx)
  800940:	8b 55 08             	mov    0x8(%ebp),%edx
  800943:	88 10                	mov    %dl,(%eax)
}
  800945:	90                   	nop
  800946:	5d                   	pop    %ebp
  800947:	c3                   	ret    

00800948 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800948:	55                   	push   %ebp
  800949:	89 e5                	mov    %esp,%ebp
  80094b:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80094e:	8b 45 08             	mov    0x8(%ebp),%eax
  800951:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800954:	8b 45 0c             	mov    0xc(%ebp),%eax
  800957:	8d 50 ff             	lea    -0x1(%eax),%edx
  80095a:	8b 45 08             	mov    0x8(%ebp),%eax
  80095d:	01 d0                	add    %edx,%eax
  80095f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800962:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800969:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80096d:	74 06                	je     800975 <vsnprintf+0x2d>
  80096f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800973:	7f 07                	jg     80097c <vsnprintf+0x34>
		return -E_INVAL;
  800975:	b8 03 00 00 00       	mov    $0x3,%eax
  80097a:	eb 20                	jmp    80099c <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80097c:	ff 75 14             	pushl  0x14(%ebp)
  80097f:	ff 75 10             	pushl  0x10(%ebp)
  800982:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800985:	50                   	push   %eax
  800986:	68 12 09 80 00       	push   $0x800912
  80098b:	e8 92 fb ff ff       	call   800522 <vprintfmt>
  800990:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800993:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800996:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800999:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80099c:	c9                   	leave  
  80099d:	c3                   	ret    

0080099e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80099e:	55                   	push   %ebp
  80099f:	89 e5                	mov    %esp,%ebp
  8009a1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009a4:	8d 45 10             	lea    0x10(%ebp),%eax
  8009a7:	83 c0 04             	add    $0x4,%eax
  8009aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8009ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8009b0:	ff 75 f4             	pushl  -0xc(%ebp)
  8009b3:	50                   	push   %eax
  8009b4:	ff 75 0c             	pushl  0xc(%ebp)
  8009b7:	ff 75 08             	pushl  0x8(%ebp)
  8009ba:	e8 89 ff ff ff       	call   800948 <vsnprintf>
  8009bf:	83 c4 10             	add    $0x10,%esp
  8009c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8009c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009c8:	c9                   	leave  
  8009c9:	c3                   	ret    

008009ca <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8009ca:	55                   	push   %ebp
  8009cb:	89 e5                	mov    %esp,%ebp
  8009cd:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8009d0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009d7:	eb 06                	jmp    8009df <strlen+0x15>
		n++;
  8009d9:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8009dc:	ff 45 08             	incl   0x8(%ebp)
  8009df:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e2:	8a 00                	mov    (%eax),%al
  8009e4:	84 c0                	test   %al,%al
  8009e6:	75 f1                	jne    8009d9 <strlen+0xf>
		n++;
	return n;
  8009e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009eb:	c9                   	leave  
  8009ec:	c3                   	ret    

008009ed <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8009ed:	55                   	push   %ebp
  8009ee:	89 e5                	mov    %esp,%ebp
  8009f0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009f3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009fa:	eb 09                	jmp    800a05 <strnlen+0x18>
		n++;
  8009fc:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009ff:	ff 45 08             	incl   0x8(%ebp)
  800a02:	ff 4d 0c             	decl   0xc(%ebp)
  800a05:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a09:	74 09                	je     800a14 <strnlen+0x27>
  800a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0e:	8a 00                	mov    (%eax),%al
  800a10:	84 c0                	test   %al,%al
  800a12:	75 e8                	jne    8009fc <strnlen+0xf>
		n++;
	return n;
  800a14:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a17:	c9                   	leave  
  800a18:	c3                   	ret    

00800a19 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a19:	55                   	push   %ebp
  800a1a:	89 e5                	mov    %esp,%ebp
  800a1c:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a22:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a25:	90                   	nop
  800a26:	8b 45 08             	mov    0x8(%ebp),%eax
  800a29:	8d 50 01             	lea    0x1(%eax),%edx
  800a2c:	89 55 08             	mov    %edx,0x8(%ebp)
  800a2f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a32:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a35:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a38:	8a 12                	mov    (%edx),%dl
  800a3a:	88 10                	mov    %dl,(%eax)
  800a3c:	8a 00                	mov    (%eax),%al
  800a3e:	84 c0                	test   %al,%al
  800a40:	75 e4                	jne    800a26 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800a42:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a45:	c9                   	leave  
  800a46:	c3                   	ret    

00800a47 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800a47:	55                   	push   %ebp
  800a48:	89 e5                	mov    %esp,%ebp
  800a4a:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a50:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800a53:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a5a:	eb 1f                	jmp    800a7b <strncpy+0x34>
		*dst++ = *src;
  800a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5f:	8d 50 01             	lea    0x1(%eax),%edx
  800a62:	89 55 08             	mov    %edx,0x8(%ebp)
  800a65:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a68:	8a 12                	mov    (%edx),%dl
  800a6a:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800a6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a6f:	8a 00                	mov    (%eax),%al
  800a71:	84 c0                	test   %al,%al
  800a73:	74 03                	je     800a78 <strncpy+0x31>
			src++;
  800a75:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a78:	ff 45 fc             	incl   -0x4(%ebp)
  800a7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a7e:	3b 45 10             	cmp    0x10(%ebp),%eax
  800a81:	72 d9                	jb     800a5c <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800a83:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800a86:	c9                   	leave  
  800a87:	c3                   	ret    

00800a88 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800a88:	55                   	push   %ebp
  800a89:	89 e5                	mov    %esp,%ebp
  800a8b:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a91:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800a94:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a98:	74 30                	je     800aca <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800a9a:	eb 16                	jmp    800ab2 <strlcpy+0x2a>
			*dst++ = *src++;
  800a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9f:	8d 50 01             	lea    0x1(%eax),%edx
  800aa2:	89 55 08             	mov    %edx,0x8(%ebp)
  800aa5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aa8:	8d 4a 01             	lea    0x1(%edx),%ecx
  800aab:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800aae:	8a 12                	mov    (%edx),%dl
  800ab0:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ab2:	ff 4d 10             	decl   0x10(%ebp)
  800ab5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ab9:	74 09                	je     800ac4 <strlcpy+0x3c>
  800abb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800abe:	8a 00                	mov    (%eax),%al
  800ac0:	84 c0                	test   %al,%al
  800ac2:	75 d8                	jne    800a9c <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac7:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800aca:	8b 55 08             	mov    0x8(%ebp),%edx
  800acd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ad0:	29 c2                	sub    %eax,%edx
  800ad2:	89 d0                	mov    %edx,%eax
}
  800ad4:	c9                   	leave  
  800ad5:	c3                   	ret    

00800ad6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ad6:	55                   	push   %ebp
  800ad7:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ad9:	eb 06                	jmp    800ae1 <strcmp+0xb>
		p++, q++;
  800adb:	ff 45 08             	incl   0x8(%ebp)
  800ade:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae4:	8a 00                	mov    (%eax),%al
  800ae6:	84 c0                	test   %al,%al
  800ae8:	74 0e                	je     800af8 <strcmp+0x22>
  800aea:	8b 45 08             	mov    0x8(%ebp),%eax
  800aed:	8a 10                	mov    (%eax),%dl
  800aef:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af2:	8a 00                	mov    (%eax),%al
  800af4:	38 c2                	cmp    %al,%dl
  800af6:	74 e3                	je     800adb <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800af8:	8b 45 08             	mov    0x8(%ebp),%eax
  800afb:	8a 00                	mov    (%eax),%al
  800afd:	0f b6 d0             	movzbl %al,%edx
  800b00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b03:	8a 00                	mov    (%eax),%al
  800b05:	0f b6 c0             	movzbl %al,%eax
  800b08:	29 c2                	sub    %eax,%edx
  800b0a:	89 d0                	mov    %edx,%eax
}
  800b0c:	5d                   	pop    %ebp
  800b0d:	c3                   	ret    

00800b0e <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800b0e:	55                   	push   %ebp
  800b0f:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b11:	eb 09                	jmp    800b1c <strncmp+0xe>
		n--, p++, q++;
  800b13:	ff 4d 10             	decl   0x10(%ebp)
  800b16:	ff 45 08             	incl   0x8(%ebp)
  800b19:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800b1c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b20:	74 17                	je     800b39 <strncmp+0x2b>
  800b22:	8b 45 08             	mov    0x8(%ebp),%eax
  800b25:	8a 00                	mov    (%eax),%al
  800b27:	84 c0                	test   %al,%al
  800b29:	74 0e                	je     800b39 <strncmp+0x2b>
  800b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2e:	8a 10                	mov    (%eax),%dl
  800b30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b33:	8a 00                	mov    (%eax),%al
  800b35:	38 c2                	cmp    %al,%dl
  800b37:	74 da                	je     800b13 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800b39:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b3d:	75 07                	jne    800b46 <strncmp+0x38>
		return 0;
  800b3f:	b8 00 00 00 00       	mov    $0x0,%eax
  800b44:	eb 14                	jmp    800b5a <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b46:	8b 45 08             	mov    0x8(%ebp),%eax
  800b49:	8a 00                	mov    (%eax),%al
  800b4b:	0f b6 d0             	movzbl %al,%edx
  800b4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b51:	8a 00                	mov    (%eax),%al
  800b53:	0f b6 c0             	movzbl %al,%eax
  800b56:	29 c2                	sub    %eax,%edx
  800b58:	89 d0                	mov    %edx,%eax
}
  800b5a:	5d                   	pop    %ebp
  800b5b:	c3                   	ret    

00800b5c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b5c:	55                   	push   %ebp
  800b5d:	89 e5                	mov    %esp,%ebp
  800b5f:	83 ec 04             	sub    $0x4,%esp
  800b62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b65:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b68:	eb 12                	jmp    800b7c <strchr+0x20>
		if (*s == c)
  800b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6d:	8a 00                	mov    (%eax),%al
  800b6f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b72:	75 05                	jne    800b79 <strchr+0x1d>
			return (char *) s;
  800b74:	8b 45 08             	mov    0x8(%ebp),%eax
  800b77:	eb 11                	jmp    800b8a <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b79:	ff 45 08             	incl   0x8(%ebp)
  800b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7f:	8a 00                	mov    (%eax),%al
  800b81:	84 c0                	test   %al,%al
  800b83:	75 e5                	jne    800b6a <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800b85:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b8a:	c9                   	leave  
  800b8b:	c3                   	ret    

00800b8c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b8c:	55                   	push   %ebp
  800b8d:	89 e5                	mov    %esp,%ebp
  800b8f:	83 ec 04             	sub    $0x4,%esp
  800b92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b95:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b98:	eb 0d                	jmp    800ba7 <strfind+0x1b>
		if (*s == c)
  800b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9d:	8a 00                	mov    (%eax),%al
  800b9f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ba2:	74 0e                	je     800bb2 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ba4:	ff 45 08             	incl   0x8(%ebp)
  800ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  800baa:	8a 00                	mov    (%eax),%al
  800bac:	84 c0                	test   %al,%al
  800bae:	75 ea                	jne    800b9a <strfind+0xe>
  800bb0:	eb 01                	jmp    800bb3 <strfind+0x27>
		if (*s == c)
			break;
  800bb2:	90                   	nop
	return (char *) s;
  800bb3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bb6:	c9                   	leave  
  800bb7:	c3                   	ret    

00800bb8 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800bb8:	55                   	push   %ebp
  800bb9:	89 e5                	mov    %esp,%ebp
  800bbb:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800bbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800bc4:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800bca:	eb 0e                	jmp    800bda <memset+0x22>
		*p++ = c;
  800bcc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bcf:	8d 50 01             	lea    0x1(%eax),%edx
  800bd2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800bd5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bd8:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800bda:	ff 4d f8             	decl   -0x8(%ebp)
  800bdd:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800be1:	79 e9                	jns    800bcc <memset+0x14>
		*p++ = c;

	return v;
  800be3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800be6:	c9                   	leave  
  800be7:	c3                   	ret    

00800be8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800be8:	55                   	push   %ebp
  800be9:	89 e5                	mov    %esp,%ebp
  800beb:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800bee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800bfa:	eb 16                	jmp    800c12 <memcpy+0x2a>
		*d++ = *s++;
  800bfc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bff:	8d 50 01             	lea    0x1(%eax),%edx
  800c02:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c05:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c08:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c0b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c0e:	8a 12                	mov    (%edx),%dl
  800c10:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800c12:	8b 45 10             	mov    0x10(%ebp),%eax
  800c15:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c18:	89 55 10             	mov    %edx,0x10(%ebp)
  800c1b:	85 c0                	test   %eax,%eax
  800c1d:	75 dd                	jne    800bfc <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800c1f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c22:	c9                   	leave  
  800c23:	c3                   	ret    

00800c24 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800c24:	55                   	push   %ebp
  800c25:	89 e5                	mov    %esp,%ebp
  800c27:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c30:	8b 45 08             	mov    0x8(%ebp),%eax
  800c33:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800c36:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c39:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c3c:	73 50                	jae    800c8e <memmove+0x6a>
  800c3e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c41:	8b 45 10             	mov    0x10(%ebp),%eax
  800c44:	01 d0                	add    %edx,%eax
  800c46:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c49:	76 43                	jbe    800c8e <memmove+0x6a>
		s += n;
  800c4b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c4e:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800c51:	8b 45 10             	mov    0x10(%ebp),%eax
  800c54:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800c57:	eb 10                	jmp    800c69 <memmove+0x45>
			*--d = *--s;
  800c59:	ff 4d f8             	decl   -0x8(%ebp)
  800c5c:	ff 4d fc             	decl   -0x4(%ebp)
  800c5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c62:	8a 10                	mov    (%eax),%dl
  800c64:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c67:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800c69:	8b 45 10             	mov    0x10(%ebp),%eax
  800c6c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c6f:	89 55 10             	mov    %edx,0x10(%ebp)
  800c72:	85 c0                	test   %eax,%eax
  800c74:	75 e3                	jne    800c59 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c76:	eb 23                	jmp    800c9b <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800c78:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c7b:	8d 50 01             	lea    0x1(%eax),%edx
  800c7e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c81:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c84:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c87:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c8a:	8a 12                	mov    (%edx),%dl
  800c8c:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800c8e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c91:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c94:	89 55 10             	mov    %edx,0x10(%ebp)
  800c97:	85 c0                	test   %eax,%eax
  800c99:	75 dd                	jne    800c78 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800c9b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c9e:	c9                   	leave  
  800c9f:	c3                   	ret    

00800ca0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ca0:	55                   	push   %ebp
  800ca1:	89 e5                	mov    %esp,%ebp
  800ca3:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800cac:	8b 45 0c             	mov    0xc(%ebp),%eax
  800caf:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800cb2:	eb 2a                	jmp    800cde <memcmp+0x3e>
		if (*s1 != *s2)
  800cb4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cb7:	8a 10                	mov    (%eax),%dl
  800cb9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cbc:	8a 00                	mov    (%eax),%al
  800cbe:	38 c2                	cmp    %al,%dl
  800cc0:	74 16                	je     800cd8 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800cc2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cc5:	8a 00                	mov    (%eax),%al
  800cc7:	0f b6 d0             	movzbl %al,%edx
  800cca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ccd:	8a 00                	mov    (%eax),%al
  800ccf:	0f b6 c0             	movzbl %al,%eax
  800cd2:	29 c2                	sub    %eax,%edx
  800cd4:	89 d0                	mov    %edx,%eax
  800cd6:	eb 18                	jmp    800cf0 <memcmp+0x50>
		s1++, s2++;
  800cd8:	ff 45 fc             	incl   -0x4(%ebp)
  800cdb:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800cde:	8b 45 10             	mov    0x10(%ebp),%eax
  800ce1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ce4:	89 55 10             	mov    %edx,0x10(%ebp)
  800ce7:	85 c0                	test   %eax,%eax
  800ce9:	75 c9                	jne    800cb4 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ceb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cf0:	c9                   	leave  
  800cf1:	c3                   	ret    

00800cf2 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800cf2:	55                   	push   %ebp
  800cf3:	89 e5                	mov    %esp,%ebp
  800cf5:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800cf8:	8b 55 08             	mov    0x8(%ebp),%edx
  800cfb:	8b 45 10             	mov    0x10(%ebp),%eax
  800cfe:	01 d0                	add    %edx,%eax
  800d00:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800d03:	eb 15                	jmp    800d1a <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d05:	8b 45 08             	mov    0x8(%ebp),%eax
  800d08:	8a 00                	mov    (%eax),%al
  800d0a:	0f b6 d0             	movzbl %al,%edx
  800d0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d10:	0f b6 c0             	movzbl %al,%eax
  800d13:	39 c2                	cmp    %eax,%edx
  800d15:	74 0d                	je     800d24 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d17:	ff 45 08             	incl   0x8(%ebp)
  800d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800d20:	72 e3                	jb     800d05 <memfind+0x13>
  800d22:	eb 01                	jmp    800d25 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800d24:	90                   	nop
	return (void *) s;
  800d25:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d28:	c9                   	leave  
  800d29:	c3                   	ret    

00800d2a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d2a:	55                   	push   %ebp
  800d2b:	89 e5                	mov    %esp,%ebp
  800d2d:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800d30:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800d37:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d3e:	eb 03                	jmp    800d43 <strtol+0x19>
		s++;
  800d40:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d43:	8b 45 08             	mov    0x8(%ebp),%eax
  800d46:	8a 00                	mov    (%eax),%al
  800d48:	3c 20                	cmp    $0x20,%al
  800d4a:	74 f4                	je     800d40 <strtol+0x16>
  800d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4f:	8a 00                	mov    (%eax),%al
  800d51:	3c 09                	cmp    $0x9,%al
  800d53:	74 eb                	je     800d40 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d55:	8b 45 08             	mov    0x8(%ebp),%eax
  800d58:	8a 00                	mov    (%eax),%al
  800d5a:	3c 2b                	cmp    $0x2b,%al
  800d5c:	75 05                	jne    800d63 <strtol+0x39>
		s++;
  800d5e:	ff 45 08             	incl   0x8(%ebp)
  800d61:	eb 13                	jmp    800d76 <strtol+0x4c>
	else if (*s == '-')
  800d63:	8b 45 08             	mov    0x8(%ebp),%eax
  800d66:	8a 00                	mov    (%eax),%al
  800d68:	3c 2d                	cmp    $0x2d,%al
  800d6a:	75 0a                	jne    800d76 <strtol+0x4c>
		s++, neg = 1;
  800d6c:	ff 45 08             	incl   0x8(%ebp)
  800d6f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d76:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d7a:	74 06                	je     800d82 <strtol+0x58>
  800d7c:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800d80:	75 20                	jne    800da2 <strtol+0x78>
  800d82:	8b 45 08             	mov    0x8(%ebp),%eax
  800d85:	8a 00                	mov    (%eax),%al
  800d87:	3c 30                	cmp    $0x30,%al
  800d89:	75 17                	jne    800da2 <strtol+0x78>
  800d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8e:	40                   	inc    %eax
  800d8f:	8a 00                	mov    (%eax),%al
  800d91:	3c 78                	cmp    $0x78,%al
  800d93:	75 0d                	jne    800da2 <strtol+0x78>
		s += 2, base = 16;
  800d95:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800d99:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800da0:	eb 28                	jmp    800dca <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800da2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800da6:	75 15                	jne    800dbd <strtol+0x93>
  800da8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dab:	8a 00                	mov    (%eax),%al
  800dad:	3c 30                	cmp    $0x30,%al
  800daf:	75 0c                	jne    800dbd <strtol+0x93>
		s++, base = 8;
  800db1:	ff 45 08             	incl   0x8(%ebp)
  800db4:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800dbb:	eb 0d                	jmp    800dca <strtol+0xa0>
	else if (base == 0)
  800dbd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dc1:	75 07                	jne    800dca <strtol+0xa0>
		base = 10;
  800dc3:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800dca:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcd:	8a 00                	mov    (%eax),%al
  800dcf:	3c 2f                	cmp    $0x2f,%al
  800dd1:	7e 19                	jle    800dec <strtol+0xc2>
  800dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd6:	8a 00                	mov    (%eax),%al
  800dd8:	3c 39                	cmp    $0x39,%al
  800dda:	7f 10                	jg     800dec <strtol+0xc2>
			dig = *s - '0';
  800ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddf:	8a 00                	mov    (%eax),%al
  800de1:	0f be c0             	movsbl %al,%eax
  800de4:	83 e8 30             	sub    $0x30,%eax
  800de7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800dea:	eb 42                	jmp    800e2e <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800dec:	8b 45 08             	mov    0x8(%ebp),%eax
  800def:	8a 00                	mov    (%eax),%al
  800df1:	3c 60                	cmp    $0x60,%al
  800df3:	7e 19                	jle    800e0e <strtol+0xe4>
  800df5:	8b 45 08             	mov    0x8(%ebp),%eax
  800df8:	8a 00                	mov    (%eax),%al
  800dfa:	3c 7a                	cmp    $0x7a,%al
  800dfc:	7f 10                	jg     800e0e <strtol+0xe4>
			dig = *s - 'a' + 10;
  800dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800e01:	8a 00                	mov    (%eax),%al
  800e03:	0f be c0             	movsbl %al,%eax
  800e06:	83 e8 57             	sub    $0x57,%eax
  800e09:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e0c:	eb 20                	jmp    800e2e <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e11:	8a 00                	mov    (%eax),%al
  800e13:	3c 40                	cmp    $0x40,%al
  800e15:	7e 39                	jle    800e50 <strtol+0x126>
  800e17:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1a:	8a 00                	mov    (%eax),%al
  800e1c:	3c 5a                	cmp    $0x5a,%al
  800e1e:	7f 30                	jg     800e50 <strtol+0x126>
			dig = *s - 'A' + 10;
  800e20:	8b 45 08             	mov    0x8(%ebp),%eax
  800e23:	8a 00                	mov    (%eax),%al
  800e25:	0f be c0             	movsbl %al,%eax
  800e28:	83 e8 37             	sub    $0x37,%eax
  800e2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800e2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e31:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e34:	7d 19                	jge    800e4f <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800e36:	ff 45 08             	incl   0x8(%ebp)
  800e39:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e3c:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e40:	89 c2                	mov    %eax,%edx
  800e42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e45:	01 d0                	add    %edx,%eax
  800e47:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800e4a:	e9 7b ff ff ff       	jmp    800dca <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800e4f:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800e50:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e54:	74 08                	je     800e5e <strtol+0x134>
		*endptr = (char *) s;
  800e56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e59:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5c:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800e5e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e62:	74 07                	je     800e6b <strtol+0x141>
  800e64:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e67:	f7 d8                	neg    %eax
  800e69:	eb 03                	jmp    800e6e <strtol+0x144>
  800e6b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e6e:	c9                   	leave  
  800e6f:	c3                   	ret    

00800e70 <ltostr>:

void
ltostr(long value, char *str)
{
  800e70:	55                   	push   %ebp
  800e71:	89 e5                	mov    %esp,%ebp
  800e73:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800e76:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800e7d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800e84:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e88:	79 13                	jns    800e9d <ltostr+0x2d>
	{
		neg = 1;
  800e8a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800e91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e94:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800e97:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800e9a:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea0:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800ea5:	99                   	cltd   
  800ea6:	f7 f9                	idiv   %ecx
  800ea8:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800eab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eae:	8d 50 01             	lea    0x1(%eax),%edx
  800eb1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800eb4:	89 c2                	mov    %eax,%edx
  800eb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb9:	01 d0                	add    %edx,%eax
  800ebb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ebe:	83 c2 30             	add    $0x30,%edx
  800ec1:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800ec3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ec6:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800ecb:	f7 e9                	imul   %ecx
  800ecd:	c1 fa 02             	sar    $0x2,%edx
  800ed0:	89 c8                	mov    %ecx,%eax
  800ed2:	c1 f8 1f             	sar    $0x1f,%eax
  800ed5:	29 c2                	sub    %eax,%edx
  800ed7:	89 d0                	mov    %edx,%eax
  800ed9:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800edc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800edf:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800ee4:	f7 e9                	imul   %ecx
  800ee6:	c1 fa 02             	sar    $0x2,%edx
  800ee9:	89 c8                	mov    %ecx,%eax
  800eeb:	c1 f8 1f             	sar    $0x1f,%eax
  800eee:	29 c2                	sub    %eax,%edx
  800ef0:	89 d0                	mov    %edx,%eax
  800ef2:	c1 e0 02             	shl    $0x2,%eax
  800ef5:	01 d0                	add    %edx,%eax
  800ef7:	01 c0                	add    %eax,%eax
  800ef9:	29 c1                	sub    %eax,%ecx
  800efb:	89 ca                	mov    %ecx,%edx
  800efd:	85 d2                	test   %edx,%edx
  800eff:	75 9c                	jne    800e9d <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800f01:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800f08:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f0b:	48                   	dec    %eax
  800f0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800f0f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f13:	74 3d                	je     800f52 <ltostr+0xe2>
		start = 1 ;
  800f15:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800f1c:	eb 34                	jmp    800f52 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800f1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f24:	01 d0                	add    %edx,%eax
  800f26:	8a 00                	mov    (%eax),%al
  800f28:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800f2b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f31:	01 c2                	add    %eax,%edx
  800f33:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800f36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f39:	01 c8                	add    %ecx,%eax
  800f3b:	8a 00                	mov    (%eax),%al
  800f3d:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800f3f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f45:	01 c2                	add    %eax,%edx
  800f47:	8a 45 eb             	mov    -0x15(%ebp),%al
  800f4a:	88 02                	mov    %al,(%edx)
		start++ ;
  800f4c:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800f4f:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800f52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f55:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f58:	7c c4                	jl     800f1e <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800f5a:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800f5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f60:	01 d0                	add    %edx,%eax
  800f62:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800f65:	90                   	nop
  800f66:	c9                   	leave  
  800f67:	c3                   	ret    

00800f68 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800f68:	55                   	push   %ebp
  800f69:	89 e5                	mov    %esp,%ebp
  800f6b:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800f6e:	ff 75 08             	pushl  0x8(%ebp)
  800f71:	e8 54 fa ff ff       	call   8009ca <strlen>
  800f76:	83 c4 04             	add    $0x4,%esp
  800f79:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800f7c:	ff 75 0c             	pushl  0xc(%ebp)
  800f7f:	e8 46 fa ff ff       	call   8009ca <strlen>
  800f84:	83 c4 04             	add    $0x4,%esp
  800f87:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800f8a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800f91:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f98:	eb 17                	jmp    800fb1 <strcconcat+0x49>
		final[s] = str1[s] ;
  800f9a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f9d:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa0:	01 c2                	add    %eax,%edx
  800fa2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa8:	01 c8                	add    %ecx,%eax
  800faa:	8a 00                	mov    (%eax),%al
  800fac:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800fae:	ff 45 fc             	incl   -0x4(%ebp)
  800fb1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fb4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800fb7:	7c e1                	jl     800f9a <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800fb9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800fc0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800fc7:	eb 1f                	jmp    800fe8 <strcconcat+0x80>
		final[s++] = str2[i] ;
  800fc9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fcc:	8d 50 01             	lea    0x1(%eax),%edx
  800fcf:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800fd2:	89 c2                	mov    %eax,%edx
  800fd4:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd7:	01 c2                	add    %eax,%edx
  800fd9:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800fdc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fdf:	01 c8                	add    %ecx,%eax
  800fe1:	8a 00                	mov    (%eax),%al
  800fe3:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800fe5:	ff 45 f8             	incl   -0x8(%ebp)
  800fe8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800feb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800fee:	7c d9                	jl     800fc9 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800ff0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ff3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff6:	01 d0                	add    %edx,%eax
  800ff8:	c6 00 00             	movb   $0x0,(%eax)
}
  800ffb:	90                   	nop
  800ffc:	c9                   	leave  
  800ffd:	c3                   	ret    

00800ffe <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800ffe:	55                   	push   %ebp
  800fff:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801001:	8b 45 14             	mov    0x14(%ebp),%eax
  801004:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80100a:	8b 45 14             	mov    0x14(%ebp),%eax
  80100d:	8b 00                	mov    (%eax),%eax
  80100f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801016:	8b 45 10             	mov    0x10(%ebp),%eax
  801019:	01 d0                	add    %edx,%eax
  80101b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801021:	eb 0c                	jmp    80102f <strsplit+0x31>
			*string++ = 0;
  801023:	8b 45 08             	mov    0x8(%ebp),%eax
  801026:	8d 50 01             	lea    0x1(%eax),%edx
  801029:	89 55 08             	mov    %edx,0x8(%ebp)
  80102c:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80102f:	8b 45 08             	mov    0x8(%ebp),%eax
  801032:	8a 00                	mov    (%eax),%al
  801034:	84 c0                	test   %al,%al
  801036:	74 18                	je     801050 <strsplit+0x52>
  801038:	8b 45 08             	mov    0x8(%ebp),%eax
  80103b:	8a 00                	mov    (%eax),%al
  80103d:	0f be c0             	movsbl %al,%eax
  801040:	50                   	push   %eax
  801041:	ff 75 0c             	pushl  0xc(%ebp)
  801044:	e8 13 fb ff ff       	call   800b5c <strchr>
  801049:	83 c4 08             	add    $0x8,%esp
  80104c:	85 c0                	test   %eax,%eax
  80104e:	75 d3                	jne    801023 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801050:	8b 45 08             	mov    0x8(%ebp),%eax
  801053:	8a 00                	mov    (%eax),%al
  801055:	84 c0                	test   %al,%al
  801057:	74 5a                	je     8010b3 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801059:	8b 45 14             	mov    0x14(%ebp),%eax
  80105c:	8b 00                	mov    (%eax),%eax
  80105e:	83 f8 0f             	cmp    $0xf,%eax
  801061:	75 07                	jne    80106a <strsplit+0x6c>
		{
			return 0;
  801063:	b8 00 00 00 00       	mov    $0x0,%eax
  801068:	eb 66                	jmp    8010d0 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80106a:	8b 45 14             	mov    0x14(%ebp),%eax
  80106d:	8b 00                	mov    (%eax),%eax
  80106f:	8d 48 01             	lea    0x1(%eax),%ecx
  801072:	8b 55 14             	mov    0x14(%ebp),%edx
  801075:	89 0a                	mov    %ecx,(%edx)
  801077:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80107e:	8b 45 10             	mov    0x10(%ebp),%eax
  801081:	01 c2                	add    %eax,%edx
  801083:	8b 45 08             	mov    0x8(%ebp),%eax
  801086:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801088:	eb 03                	jmp    80108d <strsplit+0x8f>
			string++;
  80108a:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80108d:	8b 45 08             	mov    0x8(%ebp),%eax
  801090:	8a 00                	mov    (%eax),%al
  801092:	84 c0                	test   %al,%al
  801094:	74 8b                	je     801021 <strsplit+0x23>
  801096:	8b 45 08             	mov    0x8(%ebp),%eax
  801099:	8a 00                	mov    (%eax),%al
  80109b:	0f be c0             	movsbl %al,%eax
  80109e:	50                   	push   %eax
  80109f:	ff 75 0c             	pushl  0xc(%ebp)
  8010a2:	e8 b5 fa ff ff       	call   800b5c <strchr>
  8010a7:	83 c4 08             	add    $0x8,%esp
  8010aa:	85 c0                	test   %eax,%eax
  8010ac:	74 dc                	je     80108a <strsplit+0x8c>
			string++;
	}
  8010ae:	e9 6e ff ff ff       	jmp    801021 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8010b3:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8010b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8010b7:	8b 00                	mov    (%eax),%eax
  8010b9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c3:	01 d0                	add    %edx,%eax
  8010c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8010cb:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8010d0:	c9                   	leave  
  8010d1:	c3                   	ret    

008010d2 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8010d2:	55                   	push   %ebp
  8010d3:	89 e5                	mov    %esp,%ebp
  8010d5:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8010d8:	a1 04 40 80 00       	mov    0x804004,%eax
  8010dd:	85 c0                	test   %eax,%eax
  8010df:	74 1f                	je     801100 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8010e1:	e8 1d 00 00 00       	call   801103 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8010e6:	83 ec 0c             	sub    $0xc,%esp
  8010e9:	68 70 36 80 00       	push   $0x803670
  8010ee:	e8 55 f2 ff ff       	call   800348 <cprintf>
  8010f3:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8010f6:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8010fd:	00 00 00 
	}
}
  801100:	90                   	nop
  801101:	c9                   	leave  
  801102:	c3                   	ret    

00801103 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801103:	55                   	push   %ebp
  801104:	89 e5                	mov    %esp,%ebp
  801106:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  801109:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801110:	00 00 00 
  801113:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80111a:	00 00 00 
  80111d:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801124:	00 00 00 
		LIST_INIT(&AllocMemBlocksList);
  801127:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  80112e:	00 00 00 
  801131:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801138:	00 00 00 
  80113b:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801142:	00 00 00 

		MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES ;
  801145:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  80114c:	00 02 00 
		MemBlockNodes =(struct MemBlock*)USER_DYN_BLKS_ARRAY ;
  80114f:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801156:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801159:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80115e:	2d 00 10 00 00       	sub    $0x1000,%eax
  801163:	a3 50 40 80 00       	mov    %eax,0x804050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock),PAGE_SIZE),PERM_USER|PERM_WRITEABLE);
  801168:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80116f:	a1 20 41 80 00       	mov    0x804120,%eax
  801174:	c1 e0 04             	shl    $0x4,%eax
  801177:	89 c2                	mov    %eax,%edx
  801179:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80117c:	01 d0                	add    %edx,%eax
  80117e:	48                   	dec    %eax
  80117f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801182:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801185:	ba 00 00 00 00       	mov    $0x0,%edx
  80118a:	f7 75 f0             	divl   -0x10(%ebp)
  80118d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801190:	29 d0                	sub    %edx,%eax
  801192:	89 c2                	mov    %eax,%edx
  801194:	c7 45 e8 00 00 e0 7f 	movl   $0x7fe00000,-0x18(%ebp)
  80119b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80119e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011a3:	2d 00 10 00 00       	sub    $0x1000,%eax
  8011a8:	83 ec 04             	sub    $0x4,%esp
  8011ab:	6a 06                	push   $0x6
  8011ad:	52                   	push   %edx
  8011ae:	50                   	push   %eax
  8011af:	e8 71 05 00 00       	call   801725 <sys_allocate_chunk>
  8011b4:	83 c4 10             	add    $0x10,%esp
		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8011b7:	a1 20 41 80 00       	mov    0x804120,%eax
  8011bc:	83 ec 0c             	sub    $0xc,%esp
  8011bf:	50                   	push   %eax
  8011c0:	e8 e6 0b 00 00       	call   801dab <initialize_MemBlocksList>
  8011c5:	83 c4 10             	add    $0x10,%esp

		struct MemBlock  *block_node;
		block_node = AvailableMemBlocksList.lh_first;
  8011c8:	a1 48 41 80 00       	mov    0x804148,%eax
  8011cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&(AvailableMemBlocksList),block_node);
  8011d0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8011d4:	75 14                	jne    8011ea <initialize_dyn_block_system+0xe7>
  8011d6:	83 ec 04             	sub    $0x4,%esp
  8011d9:	68 95 36 80 00       	push   $0x803695
  8011de:	6a 2b                	push   $0x2b
  8011e0:	68 b3 36 80 00       	push   $0x8036b3
  8011e5:	e8 b2 1b 00 00       	call   802d9c <_panic>
  8011ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011ed:	8b 00                	mov    (%eax),%eax
  8011ef:	85 c0                	test   %eax,%eax
  8011f1:	74 10                	je     801203 <initialize_dyn_block_system+0x100>
  8011f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011f6:	8b 00                	mov    (%eax),%eax
  8011f8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8011fb:	8b 52 04             	mov    0x4(%edx),%edx
  8011fe:	89 50 04             	mov    %edx,0x4(%eax)
  801201:	eb 0b                	jmp    80120e <initialize_dyn_block_system+0x10b>
  801203:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801206:	8b 40 04             	mov    0x4(%eax),%eax
  801209:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80120e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801211:	8b 40 04             	mov    0x4(%eax),%eax
  801214:	85 c0                	test   %eax,%eax
  801216:	74 0f                	je     801227 <initialize_dyn_block_system+0x124>
  801218:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80121b:	8b 40 04             	mov    0x4(%eax),%eax
  80121e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801221:	8b 12                	mov    (%edx),%edx
  801223:	89 10                	mov    %edx,(%eax)
  801225:	eb 0a                	jmp    801231 <initialize_dyn_block_system+0x12e>
  801227:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80122a:	8b 00                	mov    (%eax),%eax
  80122c:	a3 48 41 80 00       	mov    %eax,0x804148
  801231:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801234:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80123a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80123d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801244:	a1 54 41 80 00       	mov    0x804154,%eax
  801249:	48                   	dec    %eax
  80124a:	a3 54 41 80 00       	mov    %eax,0x804154
		block_node->sva = USER_HEAP_START ;
  80124f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801252:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
		block_node->size = ((USER_HEAP_MAX - USER_HEAP_START));
  801259:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80125c:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		insert_sorted_with_merge_freeList(block_node);
  801263:	83 ec 0c             	sub    $0xc,%esp
  801266:	ff 75 e4             	pushl  -0x1c(%ebp)
  801269:	e8 d2 13 00 00       	call   802640 <insert_sorted_with_merge_freeList>
  80126e:	83 c4 10             	add    $0x10,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801271:	90                   	nop
  801272:	c9                   	leave  
  801273:	c3                   	ret    

00801274 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801274:	55                   	push   %ebp
  801275:	89 e5                	mov    %esp,%ebp
  801277:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80127a:	e8 53 fe ff ff       	call   8010d2 <InitializeUHeap>
	if (size == 0) return NULL ;
  80127f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801283:	75 07                	jne    80128c <malloc+0x18>
  801285:	b8 00 00 00 00       	mov    $0x0,%eax
  80128a:	eb 61                	jmp    8012ed <malloc+0x79>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	size= ROUNDUP(size,PAGE_SIZE);
  80128c:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801293:	8b 55 08             	mov    0x8(%ebp),%edx
  801296:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801299:	01 d0                	add    %edx,%eax
  80129b:	48                   	dec    %eax
  80129c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80129f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8012a7:	f7 75 f4             	divl   -0xc(%ebp)
  8012aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012ad:	29 d0                	sub    %edx,%eax
  8012af:	89 45 08             	mov    %eax,0x8(%ebp)
	    			if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8012b2:	e8 3c 08 00 00       	call   801af3 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8012b7:	85 c0                	test   %eax,%eax
  8012b9:	74 2d                	je     8012e8 <malloc+0x74>
	    			{
	    				struct MemBlock * ff_block = alloc_block_FF(size);
  8012bb:	83 ec 0c             	sub    $0xc,%esp
  8012be:	ff 75 08             	pushl  0x8(%ebp)
  8012c1:	e8 3e 0f 00 00       	call   802204 <alloc_block_FF>
  8012c6:	83 c4 10             	add    $0x10,%esp
  8012c9:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    				if(ff_block!=NULL)
  8012cc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8012d0:	74 16                	je     8012e8 <malloc+0x74>
	    				{

	    					insert_sorted_allocList(ff_block);
  8012d2:	83 ec 0c             	sub    $0xc,%esp
  8012d5:	ff 75 ec             	pushl  -0x14(%ebp)
  8012d8:	e8 48 0c 00 00       	call   801f25 <insert_sorted_allocList>
  8012dd:	83 c4 10             	add    $0x10,%esp
	    					return (void*) ff_block->sva ;
  8012e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8012e3:	8b 40 08             	mov    0x8(%eax),%eax
  8012e6:	eb 05                	jmp    8012ed <malloc+0x79>

	    				}
	}
	    			return (void*) NULL ;
  8012e8:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  8012ed:	c9                   	leave  
  8012ee:	c3                   	ret    

008012ef <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8012ef:	55                   	push   %ebp
  8012f0:	89 e5                	mov    %esp,%ebp
  8012f2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock *elementForEach;
		virtual_address = ROUNDDOWN(virtual_address, PAGE_SIZE);
  8012f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012fe:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801303:	89 45 08             	mov    %eax,0x8(%ebp)
	//	if (is_mallocPages[indexindex((uint32) virtual_address)] == 1) {
		elementForEach = find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801306:	8b 45 08             	mov    0x8(%ebp),%eax
  801309:	83 ec 08             	sub    $0x8,%esp
  80130c:	50                   	push   %eax
  80130d:	68 40 40 80 00       	push   $0x804040
  801312:	e8 71 0b 00 00       	call   801e88 <find_block>
  801317:	83 c4 10             	add    $0x10,%esp
  80131a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		sys_free_user_mem((uint32) virtual_address, elementForEach->size);
  80131d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801320:	8b 50 0c             	mov    0xc(%eax),%edx
  801323:	8b 45 08             	mov    0x8(%ebp),%eax
  801326:	83 ec 08             	sub    $0x8,%esp
  801329:	52                   	push   %edx
  80132a:	50                   	push   %eax
  80132b:	e8 bd 03 00 00       	call   8016ed <sys_free_user_mem>
  801330:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,elementForEach);
  801333:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801337:	75 14                	jne    80134d <free+0x5e>
  801339:	83 ec 04             	sub    $0x4,%esp
  80133c:	68 95 36 80 00       	push   $0x803695
  801341:	6a 71                	push   $0x71
  801343:	68 b3 36 80 00       	push   $0x8036b3
  801348:	e8 4f 1a 00 00       	call   802d9c <_panic>
  80134d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801350:	8b 00                	mov    (%eax),%eax
  801352:	85 c0                	test   %eax,%eax
  801354:	74 10                	je     801366 <free+0x77>
  801356:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801359:	8b 00                	mov    (%eax),%eax
  80135b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80135e:	8b 52 04             	mov    0x4(%edx),%edx
  801361:	89 50 04             	mov    %edx,0x4(%eax)
  801364:	eb 0b                	jmp    801371 <free+0x82>
  801366:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801369:	8b 40 04             	mov    0x4(%eax),%eax
  80136c:	a3 44 40 80 00       	mov    %eax,0x804044
  801371:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801374:	8b 40 04             	mov    0x4(%eax),%eax
  801377:	85 c0                	test   %eax,%eax
  801379:	74 0f                	je     80138a <free+0x9b>
  80137b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80137e:	8b 40 04             	mov    0x4(%eax),%eax
  801381:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801384:	8b 12                	mov    (%edx),%edx
  801386:	89 10                	mov    %edx,(%eax)
  801388:	eb 0a                	jmp    801394 <free+0xa5>
  80138a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80138d:	8b 00                	mov    (%eax),%eax
  80138f:	a3 40 40 80 00       	mov    %eax,0x804040
  801394:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801397:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80139d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013a0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8013a7:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8013ac:	48                   	dec    %eax
  8013ad:	a3 4c 40 80 00       	mov    %eax,0x80404c
		insert_sorted_with_merge_freeList(elementForEach);
  8013b2:	83 ec 0c             	sub    $0xc,%esp
  8013b5:	ff 75 f0             	pushl  -0x10(%ebp)
  8013b8:	e8 83 12 00 00       	call   802640 <insert_sorted_with_merge_freeList>
  8013bd:	83 c4 10             	add    $0x10,%esp
	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  8013c0:	90                   	nop
  8013c1:	c9                   	leave  
  8013c2:	c3                   	ret    

008013c3 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8013c3:	55                   	push   %ebp
  8013c4:	89 e5                	mov    %esp,%ebp
  8013c6:	83 ec 28             	sub    $0x28,%esp
  8013c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8013cc:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8013cf:	e8 fe fc ff ff       	call   8010d2 <InitializeUHeap>
	if (size == 0) return NULL ;
  8013d4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8013d8:	75 0a                	jne    8013e4 <smalloc+0x21>
  8013da:	b8 00 00 00 00       	mov    $0x0,%eax
  8013df:	e9 86 00 00 00       	jmp    80146a <smalloc+0xa7>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code

	size=ROUNDUP(size,PAGE_SIZE);
  8013e4:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8013eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013f1:	01 d0                	add    %edx,%eax
  8013f3:	48                   	dec    %eax
  8013f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8013ff:	f7 75 f4             	divl   -0xc(%ebp)
  801402:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801405:	29 d0                	sub    %edx,%eax
  801407:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80140a:	e8 e4 06 00 00       	call   801af3 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80140f:	85 c0                	test   %eax,%eax
  801411:	74 52                	je     801465 <smalloc+0xa2>
		{
		struct MemBlock * ff_block ;
		ff_block = alloc_block_FF(size);
  801413:	83 ec 0c             	sub    $0xc,%esp
  801416:	ff 75 0c             	pushl  0xc(%ebp)
  801419:	e8 e6 0d 00 00       	call   802204 <alloc_block_FF>
  80141e:	83 c4 10             	add    $0x10,%esp
  801421:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(ff_block==NULL)
  801424:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801428:	75 07                	jne    801431 <smalloc+0x6e>
			return NULL ;
  80142a:	b8 00 00 00 00       	mov    $0x0,%eax
  80142f:	eb 39                	jmp    80146a <smalloc+0xa7>

		int obj_id =sys_createSharedObject(sharedVarName,size,isWritable,(void*)ff_block->sva);
  801431:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801434:	8b 40 08             	mov    0x8(%eax),%eax
  801437:	89 c2                	mov    %eax,%edx
  801439:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  80143d:	52                   	push   %edx
  80143e:	50                   	push   %eax
  80143f:	ff 75 0c             	pushl  0xc(%ebp)
  801442:	ff 75 08             	pushl  0x8(%ebp)
  801445:	e8 2e 04 00 00       	call   801878 <sys_createSharedObject>
  80144a:	83 c4 10             	add    $0x10,%esp
  80144d:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(obj_id < 0)
  801450:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801454:	79 07                	jns    80145d <smalloc+0x9a>
			return (void*)NULL ;
  801456:	b8 00 00 00 00       	mov    $0x0,%eax
  80145b:	eb 0d                	jmp    80146a <smalloc+0xa7>
		else
		    return (void*)ff_block->sva ;
  80145d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801460:	8b 40 08             	mov    0x8(%eax),%eax
  801463:	eb 05                	jmp    80146a <smalloc+0xa7>
		}
		return (void*)NULL ;
  801465:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80146a:	c9                   	leave  
  80146b:	c3                   	ret    

0080146c <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80146c:	55                   	push   %ebp
  80146d:	89 e5                	mov    %esp,%ebp
  80146f:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801472:	e8 5b fc ff ff       	call   8010d2 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801477:	83 ec 08             	sub    $0x8,%esp
  80147a:	ff 75 0c             	pushl  0xc(%ebp)
  80147d:	ff 75 08             	pushl  0x8(%ebp)
  801480:	e8 1d 04 00 00       	call   8018a2 <sys_getSizeOfSharedObject>
  801485:	83 c4 10             	add    $0x10,%esp
  801488:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(size == 0)
  80148b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80148f:	75 0a                	jne    80149b <sget+0x2f>
			return NULL ;
  801491:	b8 00 00 00 00       	mov    $0x0,%eax
  801496:	e9 83 00 00 00       	jmp    80151e <sget+0xb2>
		size=ROUNDUP(size,PAGE_SIZE);
  80149b:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8014a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014a8:	01 d0                	add    %edx,%eax
  8014aa:	48                   	dec    %eax
  8014ab:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8014ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8014b6:	f7 75 f0             	divl   -0x10(%ebp)
  8014b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014bc:	29 d0                	sub    %edx,%eax
  8014be:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8014c1:	e8 2d 06 00 00       	call   801af3 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014c6:	85 c0                	test   %eax,%eax
  8014c8:	74 4f                	je     801519 <sget+0xad>
		{
			struct MemBlock * ff_block ;
				ff_block = alloc_block_FF(size);
  8014ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014cd:	83 ec 0c             	sub    $0xc,%esp
  8014d0:	50                   	push   %eax
  8014d1:	e8 2e 0d 00 00       	call   802204 <alloc_block_FF>
  8014d6:	83 c4 10             	add    $0x10,%esp
  8014d9:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ff_block==NULL)
  8014dc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8014e0:	75 07                	jne    8014e9 <sget+0x7d>
					return (void*)NULL ;
  8014e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8014e7:	eb 35                	jmp    80151e <sget+0xb2>

		int obj_id =sys_getSharedObject((int)ownerEnvID,sharedVarName,(void*)ff_block->sva);
  8014e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014ec:	8b 40 08             	mov    0x8(%eax),%eax
  8014ef:	83 ec 04             	sub    $0x4,%esp
  8014f2:	50                   	push   %eax
  8014f3:	ff 75 0c             	pushl  0xc(%ebp)
  8014f6:	ff 75 08             	pushl  0x8(%ebp)
  8014f9:	e8 c1 03 00 00       	call   8018bf <sys_getSharedObject>
  8014fe:	83 c4 10             	add    $0x10,%esp
  801501:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if(obj_id<0)
  801504:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801508:	79 07                	jns    801511 <sget+0xa5>
				return (void*)NULL ;
  80150a:	b8 00 00 00 00       	mov    $0x0,%eax
  80150f:	eb 0d                	jmp    80151e <sget+0xb2>
			else
				return (void*)ff_block->sva ;
  801511:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801514:	8b 40 08             	mov    0x8(%eax),%eax
  801517:	eb 05                	jmp    80151e <sget+0xb2>


		}
	return (void*)NULL ;
  801519:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80151e:	c9                   	leave  
  80151f:	c3                   	ret    

00801520 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801520:	55                   	push   %ebp
  801521:	89 e5                	mov    %esp,%ebp
  801523:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801526:	e8 a7 fb ff ff       	call   8010d2 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80152b:	83 ec 04             	sub    $0x4,%esp
  80152e:	68 c0 36 80 00       	push   $0x8036c0
  801533:	68 f9 00 00 00       	push   $0xf9
  801538:	68 b3 36 80 00       	push   $0x8036b3
  80153d:	e8 5a 18 00 00       	call   802d9c <_panic>

00801542 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801542:	55                   	push   %ebp
  801543:	89 e5                	mov    %esp,%ebp
  801545:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801548:	83 ec 04             	sub    $0x4,%esp
  80154b:	68 e8 36 80 00       	push   $0x8036e8
  801550:	68 0d 01 00 00       	push   $0x10d
  801555:	68 b3 36 80 00       	push   $0x8036b3
  80155a:	e8 3d 18 00 00       	call   802d9c <_panic>

0080155f <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80155f:	55                   	push   %ebp
  801560:	89 e5                	mov    %esp,%ebp
  801562:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801565:	83 ec 04             	sub    $0x4,%esp
  801568:	68 0c 37 80 00       	push   $0x80370c
  80156d:	68 18 01 00 00       	push   $0x118
  801572:	68 b3 36 80 00       	push   $0x8036b3
  801577:	e8 20 18 00 00       	call   802d9c <_panic>

0080157c <shrink>:

}
void shrink(uint32 newSize)
{
  80157c:	55                   	push   %ebp
  80157d:	89 e5                	mov    %esp,%ebp
  80157f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801582:	83 ec 04             	sub    $0x4,%esp
  801585:	68 0c 37 80 00       	push   $0x80370c
  80158a:	68 1d 01 00 00       	push   $0x11d
  80158f:	68 b3 36 80 00       	push   $0x8036b3
  801594:	e8 03 18 00 00       	call   802d9c <_panic>

00801599 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801599:	55                   	push   %ebp
  80159a:	89 e5                	mov    %esp,%ebp
  80159c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80159f:	83 ec 04             	sub    $0x4,%esp
  8015a2:	68 0c 37 80 00       	push   $0x80370c
  8015a7:	68 22 01 00 00       	push   $0x122
  8015ac:	68 b3 36 80 00       	push   $0x8036b3
  8015b1:	e8 e6 17 00 00       	call   802d9c <_panic>

008015b6 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8015b6:	55                   	push   %ebp
  8015b7:	89 e5                	mov    %esp,%ebp
  8015b9:	57                   	push   %edi
  8015ba:	56                   	push   %esi
  8015bb:	53                   	push   %ebx
  8015bc:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015c5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015c8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015cb:	8b 7d 18             	mov    0x18(%ebp),%edi
  8015ce:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8015d1:	cd 30                	int    $0x30
  8015d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8015d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015d9:	83 c4 10             	add    $0x10,%esp
  8015dc:	5b                   	pop    %ebx
  8015dd:	5e                   	pop    %esi
  8015de:	5f                   	pop    %edi
  8015df:	5d                   	pop    %ebp
  8015e0:	c3                   	ret    

008015e1 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8015e1:	55                   	push   %ebp
  8015e2:	89 e5                	mov    %esp,%ebp
  8015e4:	83 ec 04             	sub    $0x4,%esp
  8015e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ea:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8015ed:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8015f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f4:	6a 00                	push   $0x0
  8015f6:	6a 00                	push   $0x0
  8015f8:	52                   	push   %edx
  8015f9:	ff 75 0c             	pushl  0xc(%ebp)
  8015fc:	50                   	push   %eax
  8015fd:	6a 00                	push   $0x0
  8015ff:	e8 b2 ff ff ff       	call   8015b6 <syscall>
  801604:	83 c4 18             	add    $0x18,%esp
}
  801607:	90                   	nop
  801608:	c9                   	leave  
  801609:	c3                   	ret    

0080160a <sys_cgetc>:

int
sys_cgetc(void)
{
  80160a:	55                   	push   %ebp
  80160b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80160d:	6a 00                	push   $0x0
  80160f:	6a 00                	push   $0x0
  801611:	6a 00                	push   $0x0
  801613:	6a 00                	push   $0x0
  801615:	6a 00                	push   $0x0
  801617:	6a 01                	push   $0x1
  801619:	e8 98 ff ff ff       	call   8015b6 <syscall>
  80161e:	83 c4 18             	add    $0x18,%esp
}
  801621:	c9                   	leave  
  801622:	c3                   	ret    

00801623 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801623:	55                   	push   %ebp
  801624:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801626:	8b 55 0c             	mov    0xc(%ebp),%edx
  801629:	8b 45 08             	mov    0x8(%ebp),%eax
  80162c:	6a 00                	push   $0x0
  80162e:	6a 00                	push   $0x0
  801630:	6a 00                	push   $0x0
  801632:	52                   	push   %edx
  801633:	50                   	push   %eax
  801634:	6a 05                	push   $0x5
  801636:	e8 7b ff ff ff       	call   8015b6 <syscall>
  80163b:	83 c4 18             	add    $0x18,%esp
}
  80163e:	c9                   	leave  
  80163f:	c3                   	ret    

00801640 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801640:	55                   	push   %ebp
  801641:	89 e5                	mov    %esp,%ebp
  801643:	56                   	push   %esi
  801644:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801645:	8b 75 18             	mov    0x18(%ebp),%esi
  801648:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80164b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80164e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801651:	8b 45 08             	mov    0x8(%ebp),%eax
  801654:	56                   	push   %esi
  801655:	53                   	push   %ebx
  801656:	51                   	push   %ecx
  801657:	52                   	push   %edx
  801658:	50                   	push   %eax
  801659:	6a 06                	push   $0x6
  80165b:	e8 56 ff ff ff       	call   8015b6 <syscall>
  801660:	83 c4 18             	add    $0x18,%esp
}
  801663:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801666:	5b                   	pop    %ebx
  801667:	5e                   	pop    %esi
  801668:	5d                   	pop    %ebp
  801669:	c3                   	ret    

0080166a <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80166a:	55                   	push   %ebp
  80166b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80166d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801670:	8b 45 08             	mov    0x8(%ebp),%eax
  801673:	6a 00                	push   $0x0
  801675:	6a 00                	push   $0x0
  801677:	6a 00                	push   $0x0
  801679:	52                   	push   %edx
  80167a:	50                   	push   %eax
  80167b:	6a 07                	push   $0x7
  80167d:	e8 34 ff ff ff       	call   8015b6 <syscall>
  801682:	83 c4 18             	add    $0x18,%esp
}
  801685:	c9                   	leave  
  801686:	c3                   	ret    

00801687 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801687:	55                   	push   %ebp
  801688:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80168a:	6a 00                	push   $0x0
  80168c:	6a 00                	push   $0x0
  80168e:	6a 00                	push   $0x0
  801690:	ff 75 0c             	pushl  0xc(%ebp)
  801693:	ff 75 08             	pushl  0x8(%ebp)
  801696:	6a 08                	push   $0x8
  801698:	e8 19 ff ff ff       	call   8015b6 <syscall>
  80169d:	83 c4 18             	add    $0x18,%esp
}
  8016a0:	c9                   	leave  
  8016a1:	c3                   	ret    

008016a2 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8016a2:	55                   	push   %ebp
  8016a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8016a5:	6a 00                	push   $0x0
  8016a7:	6a 00                	push   $0x0
  8016a9:	6a 00                	push   $0x0
  8016ab:	6a 00                	push   $0x0
  8016ad:	6a 00                	push   $0x0
  8016af:	6a 09                	push   $0x9
  8016b1:	e8 00 ff ff ff       	call   8015b6 <syscall>
  8016b6:	83 c4 18             	add    $0x18,%esp
}
  8016b9:	c9                   	leave  
  8016ba:	c3                   	ret    

008016bb <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8016bb:	55                   	push   %ebp
  8016bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8016be:	6a 00                	push   $0x0
  8016c0:	6a 00                	push   $0x0
  8016c2:	6a 00                	push   $0x0
  8016c4:	6a 00                	push   $0x0
  8016c6:	6a 00                	push   $0x0
  8016c8:	6a 0a                	push   $0xa
  8016ca:	e8 e7 fe ff ff       	call   8015b6 <syscall>
  8016cf:	83 c4 18             	add    $0x18,%esp
}
  8016d2:	c9                   	leave  
  8016d3:	c3                   	ret    

008016d4 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8016d4:	55                   	push   %ebp
  8016d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8016d7:	6a 00                	push   $0x0
  8016d9:	6a 00                	push   $0x0
  8016db:	6a 00                	push   $0x0
  8016dd:	6a 00                	push   $0x0
  8016df:	6a 00                	push   $0x0
  8016e1:	6a 0b                	push   $0xb
  8016e3:	e8 ce fe ff ff       	call   8015b6 <syscall>
  8016e8:	83 c4 18             	add    $0x18,%esp
}
  8016eb:	c9                   	leave  
  8016ec:	c3                   	ret    

008016ed <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8016ed:	55                   	push   %ebp
  8016ee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8016f0:	6a 00                	push   $0x0
  8016f2:	6a 00                	push   $0x0
  8016f4:	6a 00                	push   $0x0
  8016f6:	ff 75 0c             	pushl  0xc(%ebp)
  8016f9:	ff 75 08             	pushl  0x8(%ebp)
  8016fc:	6a 0f                	push   $0xf
  8016fe:	e8 b3 fe ff ff       	call   8015b6 <syscall>
  801703:	83 c4 18             	add    $0x18,%esp
	return;
  801706:	90                   	nop
}
  801707:	c9                   	leave  
  801708:	c3                   	ret    

00801709 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801709:	55                   	push   %ebp
  80170a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80170c:	6a 00                	push   $0x0
  80170e:	6a 00                	push   $0x0
  801710:	6a 00                	push   $0x0
  801712:	ff 75 0c             	pushl  0xc(%ebp)
  801715:	ff 75 08             	pushl  0x8(%ebp)
  801718:	6a 10                	push   $0x10
  80171a:	e8 97 fe ff ff       	call   8015b6 <syscall>
  80171f:	83 c4 18             	add    $0x18,%esp
	return ;
  801722:	90                   	nop
}
  801723:	c9                   	leave  
  801724:	c3                   	ret    

00801725 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801725:	55                   	push   %ebp
  801726:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801728:	6a 00                	push   $0x0
  80172a:	6a 00                	push   $0x0
  80172c:	ff 75 10             	pushl  0x10(%ebp)
  80172f:	ff 75 0c             	pushl  0xc(%ebp)
  801732:	ff 75 08             	pushl  0x8(%ebp)
  801735:	6a 11                	push   $0x11
  801737:	e8 7a fe ff ff       	call   8015b6 <syscall>
  80173c:	83 c4 18             	add    $0x18,%esp
	return ;
  80173f:	90                   	nop
}
  801740:	c9                   	leave  
  801741:	c3                   	ret    

00801742 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801742:	55                   	push   %ebp
  801743:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801745:	6a 00                	push   $0x0
  801747:	6a 00                	push   $0x0
  801749:	6a 00                	push   $0x0
  80174b:	6a 00                	push   $0x0
  80174d:	6a 00                	push   $0x0
  80174f:	6a 0c                	push   $0xc
  801751:	e8 60 fe ff ff       	call   8015b6 <syscall>
  801756:	83 c4 18             	add    $0x18,%esp
}
  801759:	c9                   	leave  
  80175a:	c3                   	ret    

0080175b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80175b:	55                   	push   %ebp
  80175c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80175e:	6a 00                	push   $0x0
  801760:	6a 00                	push   $0x0
  801762:	6a 00                	push   $0x0
  801764:	6a 00                	push   $0x0
  801766:	ff 75 08             	pushl  0x8(%ebp)
  801769:	6a 0d                	push   $0xd
  80176b:	e8 46 fe ff ff       	call   8015b6 <syscall>
  801770:	83 c4 18             	add    $0x18,%esp
}
  801773:	c9                   	leave  
  801774:	c3                   	ret    

00801775 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801775:	55                   	push   %ebp
  801776:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801778:	6a 00                	push   $0x0
  80177a:	6a 00                	push   $0x0
  80177c:	6a 00                	push   $0x0
  80177e:	6a 00                	push   $0x0
  801780:	6a 00                	push   $0x0
  801782:	6a 0e                	push   $0xe
  801784:	e8 2d fe ff ff       	call   8015b6 <syscall>
  801789:	83 c4 18             	add    $0x18,%esp
}
  80178c:	90                   	nop
  80178d:	c9                   	leave  
  80178e:	c3                   	ret    

0080178f <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80178f:	55                   	push   %ebp
  801790:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801792:	6a 00                	push   $0x0
  801794:	6a 00                	push   $0x0
  801796:	6a 00                	push   $0x0
  801798:	6a 00                	push   $0x0
  80179a:	6a 00                	push   $0x0
  80179c:	6a 13                	push   $0x13
  80179e:	e8 13 fe ff ff       	call   8015b6 <syscall>
  8017a3:	83 c4 18             	add    $0x18,%esp
}
  8017a6:	90                   	nop
  8017a7:	c9                   	leave  
  8017a8:	c3                   	ret    

008017a9 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8017a9:	55                   	push   %ebp
  8017aa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8017ac:	6a 00                	push   $0x0
  8017ae:	6a 00                	push   $0x0
  8017b0:	6a 00                	push   $0x0
  8017b2:	6a 00                	push   $0x0
  8017b4:	6a 00                	push   $0x0
  8017b6:	6a 14                	push   $0x14
  8017b8:	e8 f9 fd ff ff       	call   8015b6 <syscall>
  8017bd:	83 c4 18             	add    $0x18,%esp
}
  8017c0:	90                   	nop
  8017c1:	c9                   	leave  
  8017c2:	c3                   	ret    

008017c3 <sys_cputc>:


void
sys_cputc(const char c)
{
  8017c3:	55                   	push   %ebp
  8017c4:	89 e5                	mov    %esp,%ebp
  8017c6:	83 ec 04             	sub    $0x4,%esp
  8017c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8017cf:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8017d3:	6a 00                	push   $0x0
  8017d5:	6a 00                	push   $0x0
  8017d7:	6a 00                	push   $0x0
  8017d9:	6a 00                	push   $0x0
  8017db:	50                   	push   %eax
  8017dc:	6a 15                	push   $0x15
  8017de:	e8 d3 fd ff ff       	call   8015b6 <syscall>
  8017e3:	83 c4 18             	add    $0x18,%esp
}
  8017e6:	90                   	nop
  8017e7:	c9                   	leave  
  8017e8:	c3                   	ret    

008017e9 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8017e9:	55                   	push   %ebp
  8017ea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8017ec:	6a 00                	push   $0x0
  8017ee:	6a 00                	push   $0x0
  8017f0:	6a 00                	push   $0x0
  8017f2:	6a 00                	push   $0x0
  8017f4:	6a 00                	push   $0x0
  8017f6:	6a 16                	push   $0x16
  8017f8:	e8 b9 fd ff ff       	call   8015b6 <syscall>
  8017fd:	83 c4 18             	add    $0x18,%esp
}
  801800:	90                   	nop
  801801:	c9                   	leave  
  801802:	c3                   	ret    

00801803 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801803:	55                   	push   %ebp
  801804:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801806:	8b 45 08             	mov    0x8(%ebp),%eax
  801809:	6a 00                	push   $0x0
  80180b:	6a 00                	push   $0x0
  80180d:	6a 00                	push   $0x0
  80180f:	ff 75 0c             	pushl  0xc(%ebp)
  801812:	50                   	push   %eax
  801813:	6a 17                	push   $0x17
  801815:	e8 9c fd ff ff       	call   8015b6 <syscall>
  80181a:	83 c4 18             	add    $0x18,%esp
}
  80181d:	c9                   	leave  
  80181e:	c3                   	ret    

0080181f <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80181f:	55                   	push   %ebp
  801820:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801822:	8b 55 0c             	mov    0xc(%ebp),%edx
  801825:	8b 45 08             	mov    0x8(%ebp),%eax
  801828:	6a 00                	push   $0x0
  80182a:	6a 00                	push   $0x0
  80182c:	6a 00                	push   $0x0
  80182e:	52                   	push   %edx
  80182f:	50                   	push   %eax
  801830:	6a 1a                	push   $0x1a
  801832:	e8 7f fd ff ff       	call   8015b6 <syscall>
  801837:	83 c4 18             	add    $0x18,%esp
}
  80183a:	c9                   	leave  
  80183b:	c3                   	ret    

0080183c <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80183c:	55                   	push   %ebp
  80183d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80183f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801842:	8b 45 08             	mov    0x8(%ebp),%eax
  801845:	6a 00                	push   $0x0
  801847:	6a 00                	push   $0x0
  801849:	6a 00                	push   $0x0
  80184b:	52                   	push   %edx
  80184c:	50                   	push   %eax
  80184d:	6a 18                	push   $0x18
  80184f:	e8 62 fd ff ff       	call   8015b6 <syscall>
  801854:	83 c4 18             	add    $0x18,%esp
}
  801857:	90                   	nop
  801858:	c9                   	leave  
  801859:	c3                   	ret    

0080185a <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80185a:	55                   	push   %ebp
  80185b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80185d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801860:	8b 45 08             	mov    0x8(%ebp),%eax
  801863:	6a 00                	push   $0x0
  801865:	6a 00                	push   $0x0
  801867:	6a 00                	push   $0x0
  801869:	52                   	push   %edx
  80186a:	50                   	push   %eax
  80186b:	6a 19                	push   $0x19
  80186d:	e8 44 fd ff ff       	call   8015b6 <syscall>
  801872:	83 c4 18             	add    $0x18,%esp
}
  801875:	90                   	nop
  801876:	c9                   	leave  
  801877:	c3                   	ret    

00801878 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801878:	55                   	push   %ebp
  801879:	89 e5                	mov    %esp,%ebp
  80187b:	83 ec 04             	sub    $0x4,%esp
  80187e:	8b 45 10             	mov    0x10(%ebp),%eax
  801881:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801884:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801887:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80188b:	8b 45 08             	mov    0x8(%ebp),%eax
  80188e:	6a 00                	push   $0x0
  801890:	51                   	push   %ecx
  801891:	52                   	push   %edx
  801892:	ff 75 0c             	pushl  0xc(%ebp)
  801895:	50                   	push   %eax
  801896:	6a 1b                	push   $0x1b
  801898:	e8 19 fd ff ff       	call   8015b6 <syscall>
  80189d:	83 c4 18             	add    $0x18,%esp
}
  8018a0:	c9                   	leave  
  8018a1:	c3                   	ret    

008018a2 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8018a2:	55                   	push   %ebp
  8018a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8018a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ab:	6a 00                	push   $0x0
  8018ad:	6a 00                	push   $0x0
  8018af:	6a 00                	push   $0x0
  8018b1:	52                   	push   %edx
  8018b2:	50                   	push   %eax
  8018b3:	6a 1c                	push   $0x1c
  8018b5:	e8 fc fc ff ff       	call   8015b6 <syscall>
  8018ba:	83 c4 18             	add    $0x18,%esp
}
  8018bd:	c9                   	leave  
  8018be:	c3                   	ret    

008018bf <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8018bf:	55                   	push   %ebp
  8018c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8018c2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cb:	6a 00                	push   $0x0
  8018cd:	6a 00                	push   $0x0
  8018cf:	51                   	push   %ecx
  8018d0:	52                   	push   %edx
  8018d1:	50                   	push   %eax
  8018d2:	6a 1d                	push   $0x1d
  8018d4:	e8 dd fc ff ff       	call   8015b6 <syscall>
  8018d9:	83 c4 18             	add    $0x18,%esp
}
  8018dc:	c9                   	leave  
  8018dd:	c3                   	ret    

008018de <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8018de:	55                   	push   %ebp
  8018df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8018e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 00                	push   $0x0
  8018ed:	52                   	push   %edx
  8018ee:	50                   	push   %eax
  8018ef:	6a 1e                	push   $0x1e
  8018f1:	e8 c0 fc ff ff       	call   8015b6 <syscall>
  8018f6:	83 c4 18             	add    $0x18,%esp
}
  8018f9:	c9                   	leave  
  8018fa:	c3                   	ret    

008018fb <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8018fb:	55                   	push   %ebp
  8018fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	6a 00                	push   $0x0
  801908:	6a 1f                	push   $0x1f
  80190a:	e8 a7 fc ff ff       	call   8015b6 <syscall>
  80190f:	83 c4 18             	add    $0x18,%esp
}
  801912:	c9                   	leave  
  801913:	c3                   	ret    

00801914 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801914:	55                   	push   %ebp
  801915:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801917:	8b 45 08             	mov    0x8(%ebp),%eax
  80191a:	6a 00                	push   $0x0
  80191c:	ff 75 14             	pushl  0x14(%ebp)
  80191f:	ff 75 10             	pushl  0x10(%ebp)
  801922:	ff 75 0c             	pushl  0xc(%ebp)
  801925:	50                   	push   %eax
  801926:	6a 20                	push   $0x20
  801928:	e8 89 fc ff ff       	call   8015b6 <syscall>
  80192d:	83 c4 18             	add    $0x18,%esp
}
  801930:	c9                   	leave  
  801931:	c3                   	ret    

00801932 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801932:	55                   	push   %ebp
  801933:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801935:	8b 45 08             	mov    0x8(%ebp),%eax
  801938:	6a 00                	push   $0x0
  80193a:	6a 00                	push   $0x0
  80193c:	6a 00                	push   $0x0
  80193e:	6a 00                	push   $0x0
  801940:	50                   	push   %eax
  801941:	6a 21                	push   $0x21
  801943:	e8 6e fc ff ff       	call   8015b6 <syscall>
  801948:	83 c4 18             	add    $0x18,%esp
}
  80194b:	90                   	nop
  80194c:	c9                   	leave  
  80194d:	c3                   	ret    

0080194e <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80194e:	55                   	push   %ebp
  80194f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801951:	8b 45 08             	mov    0x8(%ebp),%eax
  801954:	6a 00                	push   $0x0
  801956:	6a 00                	push   $0x0
  801958:	6a 00                	push   $0x0
  80195a:	6a 00                	push   $0x0
  80195c:	50                   	push   %eax
  80195d:	6a 22                	push   $0x22
  80195f:	e8 52 fc ff ff       	call   8015b6 <syscall>
  801964:	83 c4 18             	add    $0x18,%esp
}
  801967:	c9                   	leave  
  801968:	c3                   	ret    

00801969 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801969:	55                   	push   %ebp
  80196a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80196c:	6a 00                	push   $0x0
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	6a 00                	push   $0x0
  801974:	6a 00                	push   $0x0
  801976:	6a 02                	push   $0x2
  801978:	e8 39 fc ff ff       	call   8015b6 <syscall>
  80197d:	83 c4 18             	add    $0x18,%esp
}
  801980:	c9                   	leave  
  801981:	c3                   	ret    

00801982 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801982:	55                   	push   %ebp
  801983:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801985:	6a 00                	push   $0x0
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	6a 00                	push   $0x0
  80198f:	6a 03                	push   $0x3
  801991:	e8 20 fc ff ff       	call   8015b6 <syscall>
  801996:	83 c4 18             	add    $0x18,%esp
}
  801999:	c9                   	leave  
  80199a:	c3                   	ret    

0080199b <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80199b:	55                   	push   %ebp
  80199c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80199e:	6a 00                	push   $0x0
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 00                	push   $0x0
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 04                	push   $0x4
  8019aa:	e8 07 fc ff ff       	call   8015b6 <syscall>
  8019af:	83 c4 18             	add    $0x18,%esp
}
  8019b2:	c9                   	leave  
  8019b3:	c3                   	ret    

008019b4 <sys_exit_env>:


void sys_exit_env(void)
{
  8019b4:	55                   	push   %ebp
  8019b5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 23                	push   $0x23
  8019c3:	e8 ee fb ff ff       	call   8015b6 <syscall>
  8019c8:	83 c4 18             	add    $0x18,%esp
}
  8019cb:	90                   	nop
  8019cc:	c9                   	leave  
  8019cd:	c3                   	ret    

008019ce <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8019ce:	55                   	push   %ebp
  8019cf:	89 e5                	mov    %esp,%ebp
  8019d1:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8019d4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8019d7:	8d 50 04             	lea    0x4(%eax),%edx
  8019da:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	52                   	push   %edx
  8019e4:	50                   	push   %eax
  8019e5:	6a 24                	push   $0x24
  8019e7:	e8 ca fb ff ff       	call   8015b6 <syscall>
  8019ec:	83 c4 18             	add    $0x18,%esp
	return result;
  8019ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019f5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019f8:	89 01                	mov    %eax,(%ecx)
  8019fa:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8019fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801a00:	c9                   	leave  
  801a01:	c2 04 00             	ret    $0x4

00801a04 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801a04:	55                   	push   %ebp
  801a05:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	ff 75 10             	pushl  0x10(%ebp)
  801a0e:	ff 75 0c             	pushl  0xc(%ebp)
  801a11:	ff 75 08             	pushl  0x8(%ebp)
  801a14:	6a 12                	push   $0x12
  801a16:	e8 9b fb ff ff       	call   8015b6 <syscall>
  801a1b:	83 c4 18             	add    $0x18,%esp
	return ;
  801a1e:	90                   	nop
}
  801a1f:	c9                   	leave  
  801a20:	c3                   	ret    

00801a21 <sys_rcr2>:
uint32 sys_rcr2()
{
  801a21:	55                   	push   %ebp
  801a22:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801a24:	6a 00                	push   $0x0
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 25                	push   $0x25
  801a30:	e8 81 fb ff ff       	call   8015b6 <syscall>
  801a35:	83 c4 18             	add    $0x18,%esp
}
  801a38:	c9                   	leave  
  801a39:	c3                   	ret    

00801a3a <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801a3a:	55                   	push   %ebp
  801a3b:	89 e5                	mov    %esp,%ebp
  801a3d:	83 ec 04             	sub    $0x4,%esp
  801a40:	8b 45 08             	mov    0x8(%ebp),%eax
  801a43:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801a46:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 00                	push   $0x0
  801a52:	50                   	push   %eax
  801a53:	6a 26                	push   $0x26
  801a55:	e8 5c fb ff ff       	call   8015b6 <syscall>
  801a5a:	83 c4 18             	add    $0x18,%esp
	return ;
  801a5d:	90                   	nop
}
  801a5e:	c9                   	leave  
  801a5f:	c3                   	ret    

00801a60 <rsttst>:
void rsttst()
{
  801a60:	55                   	push   %ebp
  801a61:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801a63:	6a 00                	push   $0x0
  801a65:	6a 00                	push   $0x0
  801a67:	6a 00                	push   $0x0
  801a69:	6a 00                	push   $0x0
  801a6b:	6a 00                	push   $0x0
  801a6d:	6a 28                	push   $0x28
  801a6f:	e8 42 fb ff ff       	call   8015b6 <syscall>
  801a74:	83 c4 18             	add    $0x18,%esp
	return ;
  801a77:	90                   	nop
}
  801a78:	c9                   	leave  
  801a79:	c3                   	ret    

00801a7a <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801a7a:	55                   	push   %ebp
  801a7b:	89 e5                	mov    %esp,%ebp
  801a7d:	83 ec 04             	sub    $0x4,%esp
  801a80:	8b 45 14             	mov    0x14(%ebp),%eax
  801a83:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801a86:	8b 55 18             	mov    0x18(%ebp),%edx
  801a89:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a8d:	52                   	push   %edx
  801a8e:	50                   	push   %eax
  801a8f:	ff 75 10             	pushl  0x10(%ebp)
  801a92:	ff 75 0c             	pushl  0xc(%ebp)
  801a95:	ff 75 08             	pushl  0x8(%ebp)
  801a98:	6a 27                	push   $0x27
  801a9a:	e8 17 fb ff ff       	call   8015b6 <syscall>
  801a9f:	83 c4 18             	add    $0x18,%esp
	return ;
  801aa2:	90                   	nop
}
  801aa3:	c9                   	leave  
  801aa4:	c3                   	ret    

00801aa5 <chktst>:
void chktst(uint32 n)
{
  801aa5:	55                   	push   %ebp
  801aa6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	ff 75 08             	pushl  0x8(%ebp)
  801ab3:	6a 29                	push   $0x29
  801ab5:	e8 fc fa ff ff       	call   8015b6 <syscall>
  801aba:	83 c4 18             	add    $0x18,%esp
	return ;
  801abd:	90                   	nop
}
  801abe:	c9                   	leave  
  801abf:	c3                   	ret    

00801ac0 <inctst>:

void inctst()
{
  801ac0:	55                   	push   %ebp
  801ac1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 2a                	push   $0x2a
  801acf:	e8 e2 fa ff ff       	call   8015b6 <syscall>
  801ad4:	83 c4 18             	add    $0x18,%esp
	return ;
  801ad7:	90                   	nop
}
  801ad8:	c9                   	leave  
  801ad9:	c3                   	ret    

00801ada <gettst>:
uint32 gettst()
{
  801ada:	55                   	push   %ebp
  801adb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801add:	6a 00                	push   $0x0
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 2b                	push   $0x2b
  801ae9:	e8 c8 fa ff ff       	call   8015b6 <syscall>
  801aee:	83 c4 18             	add    $0x18,%esp
}
  801af1:	c9                   	leave  
  801af2:	c3                   	ret    

00801af3 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801af3:	55                   	push   %ebp
  801af4:	89 e5                	mov    %esp,%ebp
  801af6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801af9:	6a 00                	push   $0x0
  801afb:	6a 00                	push   $0x0
  801afd:	6a 00                	push   $0x0
  801aff:	6a 00                	push   $0x0
  801b01:	6a 00                	push   $0x0
  801b03:	6a 2c                	push   $0x2c
  801b05:	e8 ac fa ff ff       	call   8015b6 <syscall>
  801b0a:	83 c4 18             	add    $0x18,%esp
  801b0d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801b10:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801b14:	75 07                	jne    801b1d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801b16:	b8 01 00 00 00       	mov    $0x1,%eax
  801b1b:	eb 05                	jmp    801b22 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801b1d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b22:	c9                   	leave  
  801b23:	c3                   	ret    

00801b24 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801b24:	55                   	push   %ebp
  801b25:	89 e5                	mov    %esp,%ebp
  801b27:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 00                	push   $0x0
  801b32:	6a 00                	push   $0x0
  801b34:	6a 2c                	push   $0x2c
  801b36:	e8 7b fa ff ff       	call   8015b6 <syscall>
  801b3b:	83 c4 18             	add    $0x18,%esp
  801b3e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801b41:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801b45:	75 07                	jne    801b4e <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801b47:	b8 01 00 00 00       	mov    $0x1,%eax
  801b4c:	eb 05                	jmp    801b53 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801b4e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b53:	c9                   	leave  
  801b54:	c3                   	ret    

00801b55 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801b55:	55                   	push   %ebp
  801b56:	89 e5                	mov    %esp,%ebp
  801b58:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b5b:	6a 00                	push   $0x0
  801b5d:	6a 00                	push   $0x0
  801b5f:	6a 00                	push   $0x0
  801b61:	6a 00                	push   $0x0
  801b63:	6a 00                	push   $0x0
  801b65:	6a 2c                	push   $0x2c
  801b67:	e8 4a fa ff ff       	call   8015b6 <syscall>
  801b6c:	83 c4 18             	add    $0x18,%esp
  801b6f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801b72:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801b76:	75 07                	jne    801b7f <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801b78:	b8 01 00 00 00       	mov    $0x1,%eax
  801b7d:	eb 05                	jmp    801b84 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801b7f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b84:	c9                   	leave  
  801b85:	c3                   	ret    

00801b86 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801b86:	55                   	push   %ebp
  801b87:	89 e5                	mov    %esp,%ebp
  801b89:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	6a 2c                	push   $0x2c
  801b98:	e8 19 fa ff ff       	call   8015b6 <syscall>
  801b9d:	83 c4 18             	add    $0x18,%esp
  801ba0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ba3:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ba7:	75 07                	jne    801bb0 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ba9:	b8 01 00 00 00       	mov    $0x1,%eax
  801bae:	eb 05                	jmp    801bb5 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801bb0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bb5:	c9                   	leave  
  801bb6:	c3                   	ret    

00801bb7 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801bb7:	55                   	push   %ebp
  801bb8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 00                	push   $0x0
  801bc0:	6a 00                	push   $0x0
  801bc2:	ff 75 08             	pushl  0x8(%ebp)
  801bc5:	6a 2d                	push   $0x2d
  801bc7:	e8 ea f9 ff ff       	call   8015b6 <syscall>
  801bcc:	83 c4 18             	add    $0x18,%esp
	return ;
  801bcf:	90                   	nop
}
  801bd0:	c9                   	leave  
  801bd1:	c3                   	ret    

00801bd2 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801bd2:	55                   	push   %ebp
  801bd3:	89 e5                	mov    %esp,%ebp
  801bd5:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801bd6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801bd9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bdc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bdf:	8b 45 08             	mov    0x8(%ebp),%eax
  801be2:	6a 00                	push   $0x0
  801be4:	53                   	push   %ebx
  801be5:	51                   	push   %ecx
  801be6:	52                   	push   %edx
  801be7:	50                   	push   %eax
  801be8:	6a 2e                	push   $0x2e
  801bea:	e8 c7 f9 ff ff       	call   8015b6 <syscall>
  801bef:	83 c4 18             	add    $0x18,%esp
}
  801bf2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bf5:	c9                   	leave  
  801bf6:	c3                   	ret    

00801bf7 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801bf7:	55                   	push   %ebp
  801bf8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801bfa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	52                   	push   %edx
  801c07:	50                   	push   %eax
  801c08:	6a 2f                	push   $0x2f
  801c0a:	e8 a7 f9 ff ff       	call   8015b6 <syscall>
  801c0f:	83 c4 18             	add    $0x18,%esp
}
  801c12:	c9                   	leave  
  801c13:	c3                   	ret    

00801c14 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801c14:	55                   	push   %ebp
  801c15:	89 e5                	mov    %esp,%ebp
  801c17:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801c1a:	83 ec 0c             	sub    $0xc,%esp
  801c1d:	68 1c 37 80 00       	push   $0x80371c
  801c22:	e8 21 e7 ff ff       	call   800348 <cprintf>
  801c27:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801c2a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801c31:	83 ec 0c             	sub    $0xc,%esp
  801c34:	68 48 37 80 00       	push   $0x803748
  801c39:	e8 0a e7 ff ff       	call   800348 <cprintf>
  801c3e:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801c41:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801c45:	a1 38 41 80 00       	mov    0x804138,%eax
  801c4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c4d:	eb 56                	jmp    801ca5 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801c4f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c53:	74 1c                	je     801c71 <print_mem_block_lists+0x5d>
  801c55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c58:	8b 50 08             	mov    0x8(%eax),%edx
  801c5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c5e:	8b 48 08             	mov    0x8(%eax),%ecx
  801c61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c64:	8b 40 0c             	mov    0xc(%eax),%eax
  801c67:	01 c8                	add    %ecx,%eax
  801c69:	39 c2                	cmp    %eax,%edx
  801c6b:	73 04                	jae    801c71 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801c6d:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801c71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c74:	8b 50 08             	mov    0x8(%eax),%edx
  801c77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c7a:	8b 40 0c             	mov    0xc(%eax),%eax
  801c7d:	01 c2                	add    %eax,%edx
  801c7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c82:	8b 40 08             	mov    0x8(%eax),%eax
  801c85:	83 ec 04             	sub    $0x4,%esp
  801c88:	52                   	push   %edx
  801c89:	50                   	push   %eax
  801c8a:	68 5d 37 80 00       	push   $0x80375d
  801c8f:	e8 b4 e6 ff ff       	call   800348 <cprintf>
  801c94:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801c97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801c9d:	a1 40 41 80 00       	mov    0x804140,%eax
  801ca2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ca5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ca9:	74 07                	je     801cb2 <print_mem_block_lists+0x9e>
  801cab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cae:	8b 00                	mov    (%eax),%eax
  801cb0:	eb 05                	jmp    801cb7 <print_mem_block_lists+0xa3>
  801cb2:	b8 00 00 00 00       	mov    $0x0,%eax
  801cb7:	a3 40 41 80 00       	mov    %eax,0x804140
  801cbc:	a1 40 41 80 00       	mov    0x804140,%eax
  801cc1:	85 c0                	test   %eax,%eax
  801cc3:	75 8a                	jne    801c4f <print_mem_block_lists+0x3b>
  801cc5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801cc9:	75 84                	jne    801c4f <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801ccb:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801ccf:	75 10                	jne    801ce1 <print_mem_block_lists+0xcd>
  801cd1:	83 ec 0c             	sub    $0xc,%esp
  801cd4:	68 6c 37 80 00       	push   $0x80376c
  801cd9:	e8 6a e6 ff ff       	call   800348 <cprintf>
  801cde:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801ce1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801ce8:	83 ec 0c             	sub    $0xc,%esp
  801ceb:	68 90 37 80 00       	push   $0x803790
  801cf0:	e8 53 e6 ff ff       	call   800348 <cprintf>
  801cf5:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801cf8:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801cfc:	a1 40 40 80 00       	mov    0x804040,%eax
  801d01:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d04:	eb 56                	jmp    801d5c <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801d06:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d0a:	74 1c                	je     801d28 <print_mem_block_lists+0x114>
  801d0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d0f:	8b 50 08             	mov    0x8(%eax),%edx
  801d12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d15:	8b 48 08             	mov    0x8(%eax),%ecx
  801d18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d1b:	8b 40 0c             	mov    0xc(%eax),%eax
  801d1e:	01 c8                	add    %ecx,%eax
  801d20:	39 c2                	cmp    %eax,%edx
  801d22:	73 04                	jae    801d28 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801d24:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801d28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d2b:	8b 50 08             	mov    0x8(%eax),%edx
  801d2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d31:	8b 40 0c             	mov    0xc(%eax),%eax
  801d34:	01 c2                	add    %eax,%edx
  801d36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d39:	8b 40 08             	mov    0x8(%eax),%eax
  801d3c:	83 ec 04             	sub    $0x4,%esp
  801d3f:	52                   	push   %edx
  801d40:	50                   	push   %eax
  801d41:	68 5d 37 80 00       	push   $0x80375d
  801d46:	e8 fd e5 ff ff       	call   800348 <cprintf>
  801d4b:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801d4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d51:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801d54:	a1 48 40 80 00       	mov    0x804048,%eax
  801d59:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d5c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d60:	74 07                	je     801d69 <print_mem_block_lists+0x155>
  801d62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d65:	8b 00                	mov    (%eax),%eax
  801d67:	eb 05                	jmp    801d6e <print_mem_block_lists+0x15a>
  801d69:	b8 00 00 00 00       	mov    $0x0,%eax
  801d6e:	a3 48 40 80 00       	mov    %eax,0x804048
  801d73:	a1 48 40 80 00       	mov    0x804048,%eax
  801d78:	85 c0                	test   %eax,%eax
  801d7a:	75 8a                	jne    801d06 <print_mem_block_lists+0xf2>
  801d7c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d80:	75 84                	jne    801d06 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801d82:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801d86:	75 10                	jne    801d98 <print_mem_block_lists+0x184>
  801d88:	83 ec 0c             	sub    $0xc,%esp
  801d8b:	68 a8 37 80 00       	push   $0x8037a8
  801d90:	e8 b3 e5 ff ff       	call   800348 <cprintf>
  801d95:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801d98:	83 ec 0c             	sub    $0xc,%esp
  801d9b:	68 1c 37 80 00       	push   $0x80371c
  801da0:	e8 a3 e5 ff ff       	call   800348 <cprintf>
  801da5:	83 c4 10             	add    $0x10,%esp

}
  801da8:	90                   	nop
  801da9:	c9                   	leave  
  801daa:	c3                   	ret    

00801dab <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801dab:	55                   	push   %ebp
  801dac:	89 e5                	mov    %esp,%ebp
  801dae:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  801db1:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801db8:	00 00 00 
  801dbb:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801dc2:	00 00 00 
  801dc5:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801dcc:	00 00 00 
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  801dcf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801dd6:	e9 9e 00 00 00       	jmp    801e79 <initialize_MemBlocksList+0xce>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
  801ddb:	a1 50 40 80 00       	mov    0x804050,%eax
  801de0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801de3:	c1 e2 04             	shl    $0x4,%edx
  801de6:	01 d0                	add    %edx,%eax
  801de8:	85 c0                	test   %eax,%eax
  801dea:	75 14                	jne    801e00 <initialize_MemBlocksList+0x55>
  801dec:	83 ec 04             	sub    $0x4,%esp
  801def:	68 d0 37 80 00       	push   $0x8037d0
  801df4:	6a 43                	push   $0x43
  801df6:	68 f3 37 80 00       	push   $0x8037f3
  801dfb:	e8 9c 0f 00 00       	call   802d9c <_panic>
  801e00:	a1 50 40 80 00       	mov    0x804050,%eax
  801e05:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e08:	c1 e2 04             	shl    $0x4,%edx
  801e0b:	01 d0                	add    %edx,%eax
  801e0d:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801e13:	89 10                	mov    %edx,(%eax)
  801e15:	8b 00                	mov    (%eax),%eax
  801e17:	85 c0                	test   %eax,%eax
  801e19:	74 18                	je     801e33 <initialize_MemBlocksList+0x88>
  801e1b:	a1 48 41 80 00       	mov    0x804148,%eax
  801e20:	8b 15 50 40 80 00    	mov    0x804050,%edx
  801e26:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801e29:	c1 e1 04             	shl    $0x4,%ecx
  801e2c:	01 ca                	add    %ecx,%edx
  801e2e:	89 50 04             	mov    %edx,0x4(%eax)
  801e31:	eb 12                	jmp    801e45 <initialize_MemBlocksList+0x9a>
  801e33:	a1 50 40 80 00       	mov    0x804050,%eax
  801e38:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e3b:	c1 e2 04             	shl    $0x4,%edx
  801e3e:	01 d0                	add    %edx,%eax
  801e40:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801e45:	a1 50 40 80 00       	mov    0x804050,%eax
  801e4a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e4d:	c1 e2 04             	shl    $0x4,%edx
  801e50:	01 d0                	add    %edx,%eax
  801e52:	a3 48 41 80 00       	mov    %eax,0x804148
  801e57:	a1 50 40 80 00       	mov    0x804050,%eax
  801e5c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e5f:	c1 e2 04             	shl    $0x4,%edx
  801e62:	01 d0                	add    %edx,%eax
  801e64:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801e6b:	a1 54 41 80 00       	mov    0x804154,%eax
  801e70:	40                   	inc    %eax
  801e71:	a3 54 41 80 00       	mov    %eax,0x804154
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  801e76:	ff 45 f4             	incl   -0xc(%ebp)
  801e79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e7c:	3b 45 08             	cmp    0x8(%ebp),%eax
  801e7f:	0f 82 56 ff ff ff    	jb     801ddb <initialize_MemBlocksList+0x30>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
		}
}
  801e85:	90                   	nop
  801e86:	c9                   	leave  
  801e87:	c3                   	ret    

00801e88 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801e88:	55                   	push   %ebp
  801e89:	89 e5                	mov    %esp,%ebp
  801e8b:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  801e8e:	a1 38 41 80 00       	mov    0x804138,%eax
  801e93:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801e96:	eb 18                	jmp    801eb0 <find_block+0x28>
	{
		if (ele->sva==va)
  801e98:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e9b:	8b 40 08             	mov    0x8(%eax),%eax
  801e9e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801ea1:	75 05                	jne    801ea8 <find_block+0x20>
			return ele;
  801ea3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ea6:	eb 7b                	jmp    801f23 <find_block+0x9b>
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  801ea8:	a1 40 41 80 00       	mov    0x804140,%eax
  801ead:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801eb0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801eb4:	74 07                	je     801ebd <find_block+0x35>
  801eb6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801eb9:	8b 00                	mov    (%eax),%eax
  801ebb:	eb 05                	jmp    801ec2 <find_block+0x3a>
  801ebd:	b8 00 00 00 00       	mov    $0x0,%eax
  801ec2:	a3 40 41 80 00       	mov    %eax,0x804140
  801ec7:	a1 40 41 80 00       	mov    0x804140,%eax
  801ecc:	85 c0                	test   %eax,%eax
  801ece:	75 c8                	jne    801e98 <find_block+0x10>
  801ed0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801ed4:	75 c2                	jne    801e98 <find_block+0x10>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  801ed6:	a1 40 40 80 00       	mov    0x804040,%eax
  801edb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801ede:	eb 18                	jmp    801ef8 <find_block+0x70>
	{
		if (ele->sva==va)
  801ee0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ee3:	8b 40 08             	mov    0x8(%eax),%eax
  801ee6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801ee9:	75 05                	jne    801ef0 <find_block+0x68>
					return ele;
  801eeb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801eee:	eb 33                	jmp    801f23 <find_block+0x9b>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  801ef0:	a1 48 40 80 00       	mov    0x804048,%eax
  801ef5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801ef8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801efc:	74 07                	je     801f05 <find_block+0x7d>
  801efe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f01:	8b 00                	mov    (%eax),%eax
  801f03:	eb 05                	jmp    801f0a <find_block+0x82>
  801f05:	b8 00 00 00 00       	mov    $0x0,%eax
  801f0a:	a3 48 40 80 00       	mov    %eax,0x804048
  801f0f:	a1 48 40 80 00       	mov    0x804048,%eax
  801f14:	85 c0                	test   %eax,%eax
  801f16:	75 c8                	jne    801ee0 <find_block+0x58>
  801f18:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f1c:	75 c2                	jne    801ee0 <find_block+0x58>
	{
		if (ele->sva==va)
					return ele;
	}
return NULL;
  801f1e:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  801f23:	c9                   	leave  
  801f24:	c3                   	ret    

00801f25 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801f25:	55                   	push   %ebp
  801f26:	89 e5                	mov    %esp,%ebp
  801f28:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;

int x =LIST_SIZE(&AllocMemBlocksList);
  801f2b:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801f30:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((x==0))
  801f33:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f37:	75 62                	jne    801f9b <insert_sorted_allocList+0x76>
	{
	//	blockToInsert=AllocMemBlocksList.lh_first;
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  801f39:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f3d:	75 14                	jne    801f53 <insert_sorted_allocList+0x2e>
  801f3f:	83 ec 04             	sub    $0x4,%esp
  801f42:	68 d0 37 80 00       	push   $0x8037d0
  801f47:	6a 69                	push   $0x69
  801f49:	68 f3 37 80 00       	push   $0x8037f3
  801f4e:	e8 49 0e 00 00       	call   802d9c <_panic>
  801f53:	8b 15 40 40 80 00    	mov    0x804040,%edx
  801f59:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5c:	89 10                	mov    %edx,(%eax)
  801f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f61:	8b 00                	mov    (%eax),%eax
  801f63:	85 c0                	test   %eax,%eax
  801f65:	74 0d                	je     801f74 <insert_sorted_allocList+0x4f>
  801f67:	a1 40 40 80 00       	mov    0x804040,%eax
  801f6c:	8b 55 08             	mov    0x8(%ebp),%edx
  801f6f:	89 50 04             	mov    %edx,0x4(%eax)
  801f72:	eb 08                	jmp    801f7c <insert_sorted_allocList+0x57>
  801f74:	8b 45 08             	mov    0x8(%ebp),%eax
  801f77:	a3 44 40 80 00       	mov    %eax,0x804044
  801f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7f:	a3 40 40 80 00       	mov    %eax,0x804040
  801f84:	8b 45 08             	mov    0x8(%ebp),%eax
  801f87:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f8e:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801f93:	40                   	inc    %eax
  801f94:	a3 4c 40 80 00       	mov    %eax,0x80404c
  801f99:	eb 72                	jmp    80200d <insert_sorted_allocList+0xe8>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
  801f9b:	a1 40 40 80 00       	mov    0x804040,%eax
  801fa0:	8b 50 08             	mov    0x8(%eax),%edx
  801fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa6:	8b 40 08             	mov    0x8(%eax),%eax
  801fa9:	39 c2                	cmp    %eax,%edx
  801fab:	76 60                	jbe    80200d <insert_sorted_allocList+0xe8>
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  801fad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801fb1:	75 14                	jne    801fc7 <insert_sorted_allocList+0xa2>
  801fb3:	83 ec 04             	sub    $0x4,%esp
  801fb6:	68 d0 37 80 00       	push   $0x8037d0
  801fbb:	6a 6d                	push   $0x6d
  801fbd:	68 f3 37 80 00       	push   $0x8037f3
  801fc2:	e8 d5 0d 00 00       	call   802d9c <_panic>
  801fc7:	8b 15 40 40 80 00    	mov    0x804040,%edx
  801fcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd0:	89 10                	mov    %edx,(%eax)
  801fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd5:	8b 00                	mov    (%eax),%eax
  801fd7:	85 c0                	test   %eax,%eax
  801fd9:	74 0d                	je     801fe8 <insert_sorted_allocList+0xc3>
  801fdb:	a1 40 40 80 00       	mov    0x804040,%eax
  801fe0:	8b 55 08             	mov    0x8(%ebp),%edx
  801fe3:	89 50 04             	mov    %edx,0x4(%eax)
  801fe6:	eb 08                	jmp    801ff0 <insert_sorted_allocList+0xcb>
  801fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  801feb:	a3 44 40 80 00       	mov    %eax,0x804044
  801ff0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff3:	a3 40 40 80 00       	mov    %eax,0x804040
  801ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802002:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802007:	40                   	inc    %eax
  802008:	a3 4c 40 80 00       	mov    %eax,0x80404c
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  80200d:	a1 40 40 80 00       	mov    0x804040,%eax
  802012:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802015:	e9 b9 01 00 00       	jmp    8021d3 <insert_sorted_allocList+0x2ae>
	{


		if ((blockToInsert->sva>AllocMemBlocksList.lh_first->sva)&&blockToInsert->sva<element->sva)
  80201a:	8b 45 08             	mov    0x8(%ebp),%eax
  80201d:	8b 50 08             	mov    0x8(%eax),%edx
  802020:	a1 40 40 80 00       	mov    0x804040,%eax
  802025:	8b 40 08             	mov    0x8(%eax),%eax
  802028:	39 c2                	cmp    %eax,%edx
  80202a:	76 7c                	jbe    8020a8 <insert_sorted_allocList+0x183>
  80202c:	8b 45 08             	mov    0x8(%ebp),%eax
  80202f:	8b 50 08             	mov    0x8(%eax),%edx
  802032:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802035:	8b 40 08             	mov    0x8(%eax),%eax
  802038:	39 c2                	cmp    %eax,%edx
  80203a:	73 6c                	jae    8020a8 <insert_sorted_allocList+0x183>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,element,blockToInsert);
  80203c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802040:	74 06                	je     802048 <insert_sorted_allocList+0x123>
  802042:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802046:	75 14                	jne    80205c <insert_sorted_allocList+0x137>
  802048:	83 ec 04             	sub    $0x4,%esp
  80204b:	68 0c 38 80 00       	push   $0x80380c
  802050:	6a 75                	push   $0x75
  802052:	68 f3 37 80 00       	push   $0x8037f3
  802057:	e8 40 0d 00 00       	call   802d9c <_panic>
  80205c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80205f:	8b 50 04             	mov    0x4(%eax),%edx
  802062:	8b 45 08             	mov    0x8(%ebp),%eax
  802065:	89 50 04             	mov    %edx,0x4(%eax)
  802068:	8b 45 08             	mov    0x8(%ebp),%eax
  80206b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80206e:	89 10                	mov    %edx,(%eax)
  802070:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802073:	8b 40 04             	mov    0x4(%eax),%eax
  802076:	85 c0                	test   %eax,%eax
  802078:	74 0d                	je     802087 <insert_sorted_allocList+0x162>
  80207a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80207d:	8b 40 04             	mov    0x4(%eax),%eax
  802080:	8b 55 08             	mov    0x8(%ebp),%edx
  802083:	89 10                	mov    %edx,(%eax)
  802085:	eb 08                	jmp    80208f <insert_sorted_allocList+0x16a>
  802087:	8b 45 08             	mov    0x8(%ebp),%eax
  80208a:	a3 40 40 80 00       	mov    %eax,0x804040
  80208f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802092:	8b 55 08             	mov    0x8(%ebp),%edx
  802095:	89 50 04             	mov    %edx,0x4(%eax)
  802098:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80209d:	40                   	inc    %eax
  80209e:	a3 4c 40 80 00       	mov    %eax,0x80404c

		break;}
  8020a3:	e9 59 01 00 00       	jmp    802201 <insert_sorted_allocList+0x2dc>

	else if ((blockToInsert->sva>element->sva)&&(blockToInsert->sva<AllocMemBlocksList.lh_last->sva)&&blockToInsert->sva<LIST_NEXT(element)->sva)
  8020a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ab:	8b 50 08             	mov    0x8(%eax),%edx
  8020ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b1:	8b 40 08             	mov    0x8(%eax),%eax
  8020b4:	39 c2                	cmp    %eax,%edx
  8020b6:	0f 86 98 00 00 00    	jbe    802154 <insert_sorted_allocList+0x22f>
  8020bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bf:	8b 50 08             	mov    0x8(%eax),%edx
  8020c2:	a1 44 40 80 00       	mov    0x804044,%eax
  8020c7:	8b 40 08             	mov    0x8(%eax),%eax
  8020ca:	39 c2                	cmp    %eax,%edx
  8020cc:	0f 83 82 00 00 00    	jae    802154 <insert_sorted_allocList+0x22f>
  8020d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d5:	8b 50 08             	mov    0x8(%eax),%edx
  8020d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020db:	8b 00                	mov    (%eax),%eax
  8020dd:	8b 40 08             	mov    0x8(%eax),%eax
  8020e0:	39 c2                	cmp    %eax,%edx
  8020e2:	73 70                	jae    802154 <insert_sorted_allocList+0x22f>
	{

	LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  8020e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020e8:	74 06                	je     8020f0 <insert_sorted_allocList+0x1cb>
  8020ea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020ee:	75 14                	jne    802104 <insert_sorted_allocList+0x1df>
  8020f0:	83 ec 04             	sub    $0x4,%esp
  8020f3:	68 44 38 80 00       	push   $0x803844
  8020f8:	6a 7c                	push   $0x7c
  8020fa:	68 f3 37 80 00       	push   $0x8037f3
  8020ff:	e8 98 0c 00 00       	call   802d9c <_panic>
  802104:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802107:	8b 10                	mov    (%eax),%edx
  802109:	8b 45 08             	mov    0x8(%ebp),%eax
  80210c:	89 10                	mov    %edx,(%eax)
  80210e:	8b 45 08             	mov    0x8(%ebp),%eax
  802111:	8b 00                	mov    (%eax),%eax
  802113:	85 c0                	test   %eax,%eax
  802115:	74 0b                	je     802122 <insert_sorted_allocList+0x1fd>
  802117:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211a:	8b 00                	mov    (%eax),%eax
  80211c:	8b 55 08             	mov    0x8(%ebp),%edx
  80211f:	89 50 04             	mov    %edx,0x4(%eax)
  802122:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802125:	8b 55 08             	mov    0x8(%ebp),%edx
  802128:	89 10                	mov    %edx,(%eax)
  80212a:	8b 45 08             	mov    0x8(%ebp),%eax
  80212d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802130:	89 50 04             	mov    %edx,0x4(%eax)
  802133:	8b 45 08             	mov    0x8(%ebp),%eax
  802136:	8b 00                	mov    (%eax),%eax
  802138:	85 c0                	test   %eax,%eax
  80213a:	75 08                	jne    802144 <insert_sorted_allocList+0x21f>
  80213c:	8b 45 08             	mov    0x8(%ebp),%eax
  80213f:	a3 44 40 80 00       	mov    %eax,0x804044
  802144:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802149:	40                   	inc    %eax
  80214a:	a3 4c 40 80 00       	mov    %eax,0x80404c
		break;
  80214f:	e9 ad 00 00 00       	jmp    802201 <insert_sorted_allocList+0x2dc>
	}else if (blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  802154:	8b 45 08             	mov    0x8(%ebp),%eax
  802157:	8b 50 08             	mov    0x8(%eax),%edx
  80215a:	a1 44 40 80 00       	mov    0x804044,%eax
  80215f:	8b 40 08             	mov    0x8(%eax),%eax
  802162:	39 c2                	cmp    %eax,%edx
  802164:	76 65                	jbe    8021cb <insert_sorted_allocList+0x2a6>
	{
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
  802166:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80216a:	75 17                	jne    802183 <insert_sorted_allocList+0x25e>
  80216c:	83 ec 04             	sub    $0x4,%esp
  80216f:	68 78 38 80 00       	push   $0x803878
  802174:	68 80 00 00 00       	push   $0x80
  802179:	68 f3 37 80 00       	push   $0x8037f3
  80217e:	e8 19 0c 00 00       	call   802d9c <_panic>
  802183:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802189:	8b 45 08             	mov    0x8(%ebp),%eax
  80218c:	89 50 04             	mov    %edx,0x4(%eax)
  80218f:	8b 45 08             	mov    0x8(%ebp),%eax
  802192:	8b 40 04             	mov    0x4(%eax),%eax
  802195:	85 c0                	test   %eax,%eax
  802197:	74 0c                	je     8021a5 <insert_sorted_allocList+0x280>
  802199:	a1 44 40 80 00       	mov    0x804044,%eax
  80219e:	8b 55 08             	mov    0x8(%ebp),%edx
  8021a1:	89 10                	mov    %edx,(%eax)
  8021a3:	eb 08                	jmp    8021ad <insert_sorted_allocList+0x288>
  8021a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a8:	a3 40 40 80 00       	mov    %eax,0x804040
  8021ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b0:	a3 44 40 80 00       	mov    %eax,0x804044
  8021b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021be:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021c3:	40                   	inc    %eax
  8021c4:	a3 4c 40 80 00       	mov    %eax,0x80404c
		break;
  8021c9:	eb 36                	jmp    802201 <insert_sorted_allocList+0x2dc>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  8021cb:	a1 48 40 80 00       	mov    0x804048,%eax
  8021d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021d7:	74 07                	je     8021e0 <insert_sorted_allocList+0x2bb>
  8021d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021dc:	8b 00                	mov    (%eax),%eax
  8021de:	eb 05                	jmp    8021e5 <insert_sorted_allocList+0x2c0>
  8021e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8021e5:	a3 48 40 80 00       	mov    %eax,0x804048
  8021ea:	a1 48 40 80 00       	mov    0x804048,%eax
  8021ef:	85 c0                	test   %eax,%eax
  8021f1:	0f 85 23 fe ff ff    	jne    80201a <insert_sorted_allocList+0xf5>
  8021f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021fb:	0f 85 19 fe ff ff    	jne    80201a <insert_sorted_allocList+0xf5>
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
		break;

	}
	}
}
  802201:	90                   	nop
  802202:	c9                   	leave  
  802203:	c3                   	ret    

00802204 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802204:	55                   	push   %ebp
  802205:	89 e5                	mov    %esp,%ebp
  802207:	83 ec 18             	sub    $0x18,%esp
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  80220a:	a1 38 41 80 00       	mov    0x804138,%eax
  80220f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802212:	e9 7c 01 00 00       	jmp    802393 <alloc_block_FF+0x18f>
		{
			// case 2
				if(element->size == size)
  802217:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80221a:	8b 40 0c             	mov    0xc(%eax),%eax
  80221d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802220:	0f 85 90 00 00 00    	jne    8022b6 <alloc_block_FF+0xb2>
				{
					tmp_block=element;
  802226:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802229:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,element);
  80222c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802230:	75 17                	jne    802249 <alloc_block_FF+0x45>
  802232:	83 ec 04             	sub    $0x4,%esp
  802235:	68 9b 38 80 00       	push   $0x80389b
  80223a:	68 ba 00 00 00       	push   $0xba
  80223f:	68 f3 37 80 00       	push   $0x8037f3
  802244:	e8 53 0b 00 00       	call   802d9c <_panic>
  802249:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224c:	8b 00                	mov    (%eax),%eax
  80224e:	85 c0                	test   %eax,%eax
  802250:	74 10                	je     802262 <alloc_block_FF+0x5e>
  802252:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802255:	8b 00                	mov    (%eax),%eax
  802257:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80225a:	8b 52 04             	mov    0x4(%edx),%edx
  80225d:	89 50 04             	mov    %edx,0x4(%eax)
  802260:	eb 0b                	jmp    80226d <alloc_block_FF+0x69>
  802262:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802265:	8b 40 04             	mov    0x4(%eax),%eax
  802268:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80226d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802270:	8b 40 04             	mov    0x4(%eax),%eax
  802273:	85 c0                	test   %eax,%eax
  802275:	74 0f                	je     802286 <alloc_block_FF+0x82>
  802277:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227a:	8b 40 04             	mov    0x4(%eax),%eax
  80227d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802280:	8b 12                	mov    (%edx),%edx
  802282:	89 10                	mov    %edx,(%eax)
  802284:	eb 0a                	jmp    802290 <alloc_block_FF+0x8c>
  802286:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802289:	8b 00                	mov    (%eax),%eax
  80228b:	a3 38 41 80 00       	mov    %eax,0x804138
  802290:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802293:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802299:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022a3:	a1 44 41 80 00       	mov    0x804144,%eax
  8022a8:	48                   	dec    %eax
  8022a9:	a3 44 41 80 00       	mov    %eax,0x804144
					return tmp_block;
  8022ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022b1:	e9 10 01 00 00       	jmp    8023c6 <alloc_block_FF+0x1c2>
				}
				 // case 3
				else if(element->size > size)
  8022b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8022bc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022bf:	0f 86 c6 00 00 00    	jbe    80238b <alloc_block_FF+0x187>
				{
					// the new block are created
					tmp_block = AvailableMemBlocksList.lh_first ;
  8022c5:	a1 48 41 80 00       	mov    0x804148,%eax
  8022ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  8022cd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022d1:	75 17                	jne    8022ea <alloc_block_FF+0xe6>
  8022d3:	83 ec 04             	sub    $0x4,%esp
  8022d6:	68 9b 38 80 00       	push   $0x80389b
  8022db:	68 c2 00 00 00       	push   $0xc2
  8022e0:	68 f3 37 80 00       	push   $0x8037f3
  8022e5:	e8 b2 0a 00 00       	call   802d9c <_panic>
  8022ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022ed:	8b 00                	mov    (%eax),%eax
  8022ef:	85 c0                	test   %eax,%eax
  8022f1:	74 10                	je     802303 <alloc_block_FF+0xff>
  8022f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022f6:	8b 00                	mov    (%eax),%eax
  8022f8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022fb:	8b 52 04             	mov    0x4(%edx),%edx
  8022fe:	89 50 04             	mov    %edx,0x4(%eax)
  802301:	eb 0b                	jmp    80230e <alloc_block_FF+0x10a>
  802303:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802306:	8b 40 04             	mov    0x4(%eax),%eax
  802309:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80230e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802311:	8b 40 04             	mov    0x4(%eax),%eax
  802314:	85 c0                	test   %eax,%eax
  802316:	74 0f                	je     802327 <alloc_block_FF+0x123>
  802318:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80231b:	8b 40 04             	mov    0x4(%eax),%eax
  80231e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802321:	8b 12                	mov    (%edx),%edx
  802323:	89 10                	mov    %edx,(%eax)
  802325:	eb 0a                	jmp    802331 <alloc_block_FF+0x12d>
  802327:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80232a:	8b 00                	mov    (%eax),%eax
  80232c:	a3 48 41 80 00       	mov    %eax,0x804148
  802331:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802334:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80233a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80233d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802344:	a1 54 41 80 00       	mov    0x804154,%eax
  802349:	48                   	dec    %eax
  80234a:	a3 54 41 80 00       	mov    %eax,0x804154
					tmp_block->sva=element->sva;
  80234f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802352:	8b 50 08             	mov    0x8(%eax),%edx
  802355:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802358:	89 50 08             	mov    %edx,0x8(%eax)
					tmp_block->size=size;
  80235b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80235e:	8b 55 08             	mov    0x8(%ebp),%edx
  802361:	89 50 0c             	mov    %edx,0xc(%eax)
					//update block with remaining space
					element->size-=size;
  802364:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802367:	8b 40 0c             	mov    0xc(%eax),%eax
  80236a:	2b 45 08             	sub    0x8(%ebp),%eax
  80236d:	89 c2                	mov    %eax,%edx
  80236f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802372:	89 50 0c             	mov    %edx,0xc(%eax)
					element->sva = element->sva + size;
  802375:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802378:	8b 50 08             	mov    0x8(%eax),%edx
  80237b:	8b 45 08             	mov    0x8(%ebp),%eax
  80237e:	01 c2                	add    %eax,%edx
  802380:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802383:	89 50 08             	mov    %edx,0x8(%eax)
					// return back the new block
					return tmp_block ;
  802386:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802389:	eb 3b                	jmp    8023c6 <alloc_block_FF+0x1c2>
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  80238b:	a1 40 41 80 00       	mov    0x804140,%eax
  802390:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802393:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802397:	74 07                	je     8023a0 <alloc_block_FF+0x19c>
  802399:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239c:	8b 00                	mov    (%eax),%eax
  80239e:	eb 05                	jmp    8023a5 <alloc_block_FF+0x1a1>
  8023a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8023a5:	a3 40 41 80 00       	mov    %eax,0x804140
  8023aa:	a1 40 41 80 00       	mov    0x804140,%eax
  8023af:	85 c0                	test   %eax,%eax
  8023b1:	0f 85 60 fe ff ff    	jne    802217 <alloc_block_FF+0x13>
  8023b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023bb:	0f 85 56 fe ff ff    	jne    802217 <alloc_block_FF+0x13>
					// return back the new block
					return tmp_block ;
				}
		}
		// case 1
	  return NULL ;}
  8023c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8023c6:	c9                   	leave  
  8023c7:	c3                   	ret    

008023c8 <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================

struct MemBlock *alloc_block_BF(uint32 size)
{
  8023c8:	55                   	push   %ebp
  8023c9:	89 e5                	mov    %esp,%ebp
  8023cb:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
  8023ce:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		LIST_FOREACH(element, &(FreeMemBlocksList))
  8023d5:	a1 38 41 80 00       	mov    0x804138,%eax
  8023da:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023dd:	eb 3a                	jmp    802419 <alloc_block_BF+0x51>
		{
			if(element->size >= size)
  8023df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8023e5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023e8:	72 27                	jb     802411 <alloc_block_BF+0x49>
			{
				if(best_size==-1)
  8023ea:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8023ee:	75 0b                	jne    8023fb <alloc_block_BF+0x33>
					best_size= element->size;
  8023f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f3:	8b 40 0c             	mov    0xc(%eax),%eax
  8023f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8023f9:	eb 16                	jmp    802411 <alloc_block_BF+0x49>
				else if(best_size >= element->size)
  8023fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fe:	8b 50 0c             	mov    0xc(%eax),%edx
  802401:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802404:	39 c2                	cmp    %eax,%edx
  802406:	77 09                	ja     802411 <alloc_block_BF+0x49>
					best_size=element->size;
  802408:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240b:	8b 40 0c             	mov    0xc(%eax),%eax
  80240e:	89 45 f0             	mov    %eax,-0x10(%ebp)

struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802411:	a1 40 41 80 00       	mov    0x804140,%eax
  802416:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802419:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80241d:	74 07                	je     802426 <alloc_block_BF+0x5e>
  80241f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802422:	8b 00                	mov    (%eax),%eax
  802424:	eb 05                	jmp    80242b <alloc_block_BF+0x63>
  802426:	b8 00 00 00 00       	mov    $0x0,%eax
  80242b:	a3 40 41 80 00       	mov    %eax,0x804140
  802430:	a1 40 41 80 00       	mov    0x804140,%eax
  802435:	85 c0                	test   %eax,%eax
  802437:	75 a6                	jne    8023df <alloc_block_BF+0x17>
  802439:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80243d:	75 a0                	jne    8023df <alloc_block_BF+0x17>
					best_size= element->size;
				else if(best_size >= element->size)
					best_size=element->size;
			}
		}
		if(best_size != -1)
  80243f:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802443:	0f 84 d3 01 00 00    	je     80261c <alloc_block_BF+0x254>
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  802449:	a1 38 41 80 00       	mov    0x804138,%eax
  80244e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802451:	e9 98 01 00 00       	jmp    8025ee <alloc_block_BF+0x226>
			{
			 if((best_size > size) && (best_size == element->size))
  802456:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802459:	3b 45 08             	cmp    0x8(%ebp),%eax
  80245c:	0f 86 da 00 00 00    	jbe    80253c <alloc_block_BF+0x174>
  802462:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802465:	8b 50 0c             	mov    0xc(%eax),%edx
  802468:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80246b:	39 c2                	cmp    %eax,%edx
  80246d:	0f 85 c9 00 00 00    	jne    80253c <alloc_block_BF+0x174>
			  {
				// the new block are created
			    tmp_block = AvailableMemBlocksList.lh_first ;
  802473:	a1 48 41 80 00       	mov    0x804148,%eax
  802478:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  80247b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80247f:	75 17                	jne    802498 <alloc_block_BF+0xd0>
  802481:	83 ec 04             	sub    $0x4,%esp
  802484:	68 9b 38 80 00       	push   $0x80389b
  802489:	68 ea 00 00 00       	push   $0xea
  80248e:	68 f3 37 80 00       	push   $0x8037f3
  802493:	e8 04 09 00 00       	call   802d9c <_panic>
  802498:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80249b:	8b 00                	mov    (%eax),%eax
  80249d:	85 c0                	test   %eax,%eax
  80249f:	74 10                	je     8024b1 <alloc_block_BF+0xe9>
  8024a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024a4:	8b 00                	mov    (%eax),%eax
  8024a6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024a9:	8b 52 04             	mov    0x4(%edx),%edx
  8024ac:	89 50 04             	mov    %edx,0x4(%eax)
  8024af:	eb 0b                	jmp    8024bc <alloc_block_BF+0xf4>
  8024b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024b4:	8b 40 04             	mov    0x4(%eax),%eax
  8024b7:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8024bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024bf:	8b 40 04             	mov    0x4(%eax),%eax
  8024c2:	85 c0                	test   %eax,%eax
  8024c4:	74 0f                	je     8024d5 <alloc_block_BF+0x10d>
  8024c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024c9:	8b 40 04             	mov    0x4(%eax),%eax
  8024cc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024cf:	8b 12                	mov    (%edx),%edx
  8024d1:	89 10                	mov    %edx,(%eax)
  8024d3:	eb 0a                	jmp    8024df <alloc_block_BF+0x117>
  8024d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024d8:	8b 00                	mov    (%eax),%eax
  8024da:	a3 48 41 80 00       	mov    %eax,0x804148
  8024df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024eb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024f2:	a1 54 41 80 00       	mov    0x804154,%eax
  8024f7:	48                   	dec    %eax
  8024f8:	a3 54 41 80 00       	mov    %eax,0x804154
				tmp_block->sva=element->sva;
  8024fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802500:	8b 50 08             	mov    0x8(%eax),%edx
  802503:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802506:	89 50 08             	mov    %edx,0x8(%eax)
				tmp_block->size=size;
  802509:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80250c:	8b 55 08             	mov    0x8(%ebp),%edx
  80250f:	89 50 0c             	mov    %edx,0xc(%eax)
				//update block with remaining space
				element->size-=size;
  802512:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802515:	8b 40 0c             	mov    0xc(%eax),%eax
  802518:	2b 45 08             	sub    0x8(%ebp),%eax
  80251b:	89 c2                	mov    %eax,%edx
  80251d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802520:	89 50 0c             	mov    %edx,0xc(%eax)
				element->sva = element->sva + size;
  802523:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802526:	8b 50 08             	mov    0x8(%eax),%edx
  802529:	8b 45 08             	mov    0x8(%ebp),%eax
  80252c:	01 c2                	add    %eax,%edx
  80252e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802531:	89 50 08             	mov    %edx,0x8(%eax)
				// return back the new block
				return tmp_block ;
  802534:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802537:	e9 e5 00 00 00       	jmp    802621 <alloc_block_BF+0x259>

			  }
			else if((element->size == best_size)&&(best_size == size))
  80253c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253f:	8b 50 0c             	mov    0xc(%eax),%edx
  802542:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802545:	39 c2                	cmp    %eax,%edx
  802547:	0f 85 99 00 00 00    	jne    8025e6 <alloc_block_BF+0x21e>
  80254d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802550:	3b 45 08             	cmp    0x8(%ebp),%eax
  802553:	0f 85 8d 00 00 00    	jne    8025e6 <alloc_block_BF+0x21e>
			  {
				tmp_block=element;
  802559:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255c:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&FreeMemBlocksList,element);
  80255f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802563:	75 17                	jne    80257c <alloc_block_BF+0x1b4>
  802565:	83 ec 04             	sub    $0x4,%esp
  802568:	68 9b 38 80 00       	push   $0x80389b
  80256d:	68 f7 00 00 00       	push   $0xf7
  802572:	68 f3 37 80 00       	push   $0x8037f3
  802577:	e8 20 08 00 00       	call   802d9c <_panic>
  80257c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257f:	8b 00                	mov    (%eax),%eax
  802581:	85 c0                	test   %eax,%eax
  802583:	74 10                	je     802595 <alloc_block_BF+0x1cd>
  802585:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802588:	8b 00                	mov    (%eax),%eax
  80258a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80258d:	8b 52 04             	mov    0x4(%edx),%edx
  802590:	89 50 04             	mov    %edx,0x4(%eax)
  802593:	eb 0b                	jmp    8025a0 <alloc_block_BF+0x1d8>
  802595:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802598:	8b 40 04             	mov    0x4(%eax),%eax
  80259b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8025a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a3:	8b 40 04             	mov    0x4(%eax),%eax
  8025a6:	85 c0                	test   %eax,%eax
  8025a8:	74 0f                	je     8025b9 <alloc_block_BF+0x1f1>
  8025aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ad:	8b 40 04             	mov    0x4(%eax),%eax
  8025b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025b3:	8b 12                	mov    (%edx),%edx
  8025b5:	89 10                	mov    %edx,(%eax)
  8025b7:	eb 0a                	jmp    8025c3 <alloc_block_BF+0x1fb>
  8025b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bc:	8b 00                	mov    (%eax),%eax
  8025be:	a3 38 41 80 00       	mov    %eax,0x804138
  8025c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025d6:	a1 44 41 80 00       	mov    0x804144,%eax
  8025db:	48                   	dec    %eax
  8025dc:	a3 44 41 80 00       	mov    %eax,0x804144
				return tmp_block;
  8025e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025e4:	eb 3b                	jmp    802621 <alloc_block_BF+0x259>
					best_size=element->size;
			}
		}
		if(best_size != -1)
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  8025e6:	a1 40 41 80 00       	mov    0x804140,%eax
  8025eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025f2:	74 07                	je     8025fb <alloc_block_BF+0x233>
  8025f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f7:	8b 00                	mov    (%eax),%eax
  8025f9:	eb 05                	jmp    802600 <alloc_block_BF+0x238>
  8025fb:	b8 00 00 00 00       	mov    $0x0,%eax
  802600:	a3 40 41 80 00       	mov    %eax,0x804140
  802605:	a1 40 41 80 00       	mov    0x804140,%eax
  80260a:	85 c0                	test   %eax,%eax
  80260c:	0f 85 44 fe ff ff    	jne    802456 <alloc_block_BF+0x8e>
  802612:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802616:	0f 85 3a fe ff ff    	jne    802456 <alloc_block_BF+0x8e>
				LIST_REMOVE(&FreeMemBlocksList,element);
				return tmp_block;
			 }
			}
		}
		return NULL ;}
  80261c:	b8 00 00 00 00       	mov    $0x0,%eax
  802621:	c9                   	leave  
  802622:	c3                   	ret    

00802623 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802623:	55                   	push   %ebp
  802624:	89 e5                	mov    %esp,%ebp
  802626:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802629:	83 ec 04             	sub    $0x4,%esp
  80262c:	68 bc 38 80 00       	push   $0x8038bc
  802631:	68 04 01 00 00       	push   $0x104
  802636:	68 f3 37 80 00       	push   $0x8037f3
  80263b:	e8 5c 07 00 00       	call   802d9c <_panic>

00802640 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{struct MemBlock * blk_itr;
  802640:	55                   	push   %ebp
  802641:	89 e5                	mov    %esp,%ebp
  802643:	83 ec 18             	sub    $0x18,%esp
struct MemBlock * next;
struct MemBlock * first = LIST_FIRST(&(FreeMemBlocksList));
  802646:	a1 38 41 80 00       	mov    0x804138,%eax
  80264b:	89 45 f0             	mov    %eax,-0x10(%ebp)
struct MemBlock * last = LIST_LAST(&(FreeMemBlocksList));
  80264e:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802653:	89 45 ec             	mov    %eax,-0x14(%ebp)

if(LIST_EMPTY(&(FreeMemBlocksList)))
  802656:	a1 38 41 80 00       	mov    0x804138,%eax
  80265b:	85 c0                	test   %eax,%eax
  80265d:	75 68                	jne    8026c7 <insert_sorted_with_merge_freeList+0x87>
			{

				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  80265f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802663:	75 17                	jne    80267c <insert_sorted_with_merge_freeList+0x3c>
  802665:	83 ec 04             	sub    $0x4,%esp
  802668:	68 d0 37 80 00       	push   $0x8037d0
  80266d:	68 14 01 00 00       	push   $0x114
  802672:	68 f3 37 80 00       	push   $0x8037f3
  802677:	e8 20 07 00 00       	call   802d9c <_panic>
  80267c:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802682:	8b 45 08             	mov    0x8(%ebp),%eax
  802685:	89 10                	mov    %edx,(%eax)
  802687:	8b 45 08             	mov    0x8(%ebp),%eax
  80268a:	8b 00                	mov    (%eax),%eax
  80268c:	85 c0                	test   %eax,%eax
  80268e:	74 0d                	je     80269d <insert_sorted_with_merge_freeList+0x5d>
  802690:	a1 38 41 80 00       	mov    0x804138,%eax
  802695:	8b 55 08             	mov    0x8(%ebp),%edx
  802698:	89 50 04             	mov    %edx,0x4(%eax)
  80269b:	eb 08                	jmp    8026a5 <insert_sorted_with_merge_freeList+0x65>
  80269d:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a0:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8026a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a8:	a3 38 41 80 00       	mov    %eax,0x804138
  8026ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026b7:	a1 44 41 80 00       	mov    0x804144,%eax
  8026bc:	40                   	inc    %eax
  8026bd:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  8026c2:	e9 d2 06 00 00       	jmp    802d99 <insert_sorted_with_merge_freeList+0x759>
				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);

			}
else
{
	if( blockToInsert->sva  < first->sva )
  8026c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ca:	8b 50 08             	mov    0x8(%eax),%edx
  8026cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026d0:	8b 40 08             	mov    0x8(%eax),%eax
  8026d3:	39 c2                	cmp    %eax,%edx
  8026d5:	0f 83 22 01 00 00    	jae    8027fd <insert_sorted_with_merge_freeList+0x1bd>
	{
                if( blockToInsert->sva + blockToInsert->size == first->sva)
  8026db:	8b 45 08             	mov    0x8(%ebp),%eax
  8026de:	8b 50 08             	mov    0x8(%eax),%edx
  8026e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e4:	8b 40 0c             	mov    0xc(%eax),%eax
  8026e7:	01 c2                	add    %eax,%edx
  8026e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ec:	8b 40 08             	mov    0x8(%eax),%eax
  8026ef:	39 c2                	cmp    %eax,%edx
  8026f1:	0f 85 9e 00 00 00    	jne    802795 <insert_sorted_with_merge_freeList+0x155>
                {

                	first->sva = blockToInsert->sva;
  8026f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026fa:	8b 50 08             	mov    0x8(%eax),%edx
  8026fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802700:	89 50 08             	mov    %edx,0x8(%eax)
                	first->size = first->size + blockToInsert->size;
  802703:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802706:	8b 50 0c             	mov    0xc(%eax),%edx
  802709:	8b 45 08             	mov    0x8(%ebp),%eax
  80270c:	8b 40 0c             	mov    0xc(%eax),%eax
  80270f:	01 c2                	add    %eax,%edx
  802711:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802714:	89 50 0c             	mov    %edx,0xc(%eax)
                	blockToInsert->size = blockToInsert->sva = 0;
  802717:	8b 45 08             	mov    0x8(%ebp),%eax
  80271a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802721:	8b 45 08             	mov    0x8(%ebp),%eax
  802724:	8b 50 08             	mov    0x8(%eax),%edx
  802727:	8b 45 08             	mov    0x8(%ebp),%eax
  80272a:	89 50 0c             	mov    %edx,0xc(%eax)
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  80272d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802731:	75 17                	jne    80274a <insert_sorted_with_merge_freeList+0x10a>
  802733:	83 ec 04             	sub    $0x4,%esp
  802736:	68 d0 37 80 00       	push   $0x8037d0
  80273b:	68 21 01 00 00       	push   $0x121
  802740:	68 f3 37 80 00       	push   $0x8037f3
  802745:	e8 52 06 00 00       	call   802d9c <_panic>
  80274a:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802750:	8b 45 08             	mov    0x8(%ebp),%eax
  802753:	89 10                	mov    %edx,(%eax)
  802755:	8b 45 08             	mov    0x8(%ebp),%eax
  802758:	8b 00                	mov    (%eax),%eax
  80275a:	85 c0                	test   %eax,%eax
  80275c:	74 0d                	je     80276b <insert_sorted_with_merge_freeList+0x12b>
  80275e:	a1 48 41 80 00       	mov    0x804148,%eax
  802763:	8b 55 08             	mov    0x8(%ebp),%edx
  802766:	89 50 04             	mov    %edx,0x4(%eax)
  802769:	eb 08                	jmp    802773 <insert_sorted_with_merge_freeList+0x133>
  80276b:	8b 45 08             	mov    0x8(%ebp),%eax
  80276e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802773:	8b 45 08             	mov    0x8(%ebp),%eax
  802776:	a3 48 41 80 00       	mov    %eax,0x804148
  80277b:	8b 45 08             	mov    0x8(%ebp),%eax
  80277e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802785:	a1 54 41 80 00       	mov    0x804154,%eax
  80278a:	40                   	inc    %eax
  80278b:	a3 54 41 80 00       	mov    %eax,0x804154
						}
				}
        }

}
}
  802790:	e9 04 06 00 00       	jmp    802d99 <insert_sorted_with_merge_freeList+0x759>
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
                }

                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  802795:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802799:	75 17                	jne    8027b2 <insert_sorted_with_merge_freeList+0x172>
  80279b:	83 ec 04             	sub    $0x4,%esp
  80279e:	68 d0 37 80 00       	push   $0x8037d0
  8027a3:	68 26 01 00 00       	push   $0x126
  8027a8:	68 f3 37 80 00       	push   $0x8037f3
  8027ad:	e8 ea 05 00 00       	call   802d9c <_panic>
  8027b2:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8027b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8027bb:	89 10                	mov    %edx,(%eax)
  8027bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c0:	8b 00                	mov    (%eax),%eax
  8027c2:	85 c0                	test   %eax,%eax
  8027c4:	74 0d                	je     8027d3 <insert_sorted_with_merge_freeList+0x193>
  8027c6:	a1 38 41 80 00       	mov    0x804138,%eax
  8027cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8027ce:	89 50 04             	mov    %edx,0x4(%eax)
  8027d1:	eb 08                	jmp    8027db <insert_sorted_with_merge_freeList+0x19b>
  8027d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d6:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8027db:	8b 45 08             	mov    0x8(%ebp),%eax
  8027de:	a3 38 41 80 00       	mov    %eax,0x804138
  8027e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027ed:	a1 44 41 80 00       	mov    0x804144,%eax
  8027f2:	40                   	inc    %eax
  8027f3:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  8027f8:	e9 9c 05 00 00       	jmp    802d99 <insert_sorted_with_merge_freeList+0x759>
                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
                }
	}
    else if(blockToInsert->sva > last->sva)
  8027fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802800:	8b 50 08             	mov    0x8(%eax),%edx
  802803:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802806:	8b 40 08             	mov    0x8(%eax),%eax
  802809:	39 c2                	cmp    %eax,%edx
  80280b:	0f 86 16 01 00 00    	jbe    802927 <insert_sorted_with_merge_freeList+0x2e7>
 	{

				if(last->sva + last->size == blockToInsert->sva)
  802811:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802814:	8b 50 08             	mov    0x8(%eax),%edx
  802817:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80281a:	8b 40 0c             	mov    0xc(%eax),%eax
  80281d:	01 c2                	add    %eax,%edx
  80281f:	8b 45 08             	mov    0x8(%ebp),%eax
  802822:	8b 40 08             	mov    0x8(%eax),%eax
  802825:	39 c2                	cmp    %eax,%edx
  802827:	0f 85 92 00 00 00    	jne    8028bf <insert_sorted_with_merge_freeList+0x27f>
				{

					last->size = last->size + blockToInsert->size;
  80282d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802830:	8b 50 0c             	mov    0xc(%eax),%edx
  802833:	8b 45 08             	mov    0x8(%ebp),%eax
  802836:	8b 40 0c             	mov    0xc(%eax),%eax
  802839:	01 c2                	add    %eax,%edx
  80283b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80283e:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->size = blockToInsert->sva = 0;
  802841:	8b 45 08             	mov    0x8(%ebp),%eax
  802844:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80284b:	8b 45 08             	mov    0x8(%ebp),%eax
  80284e:	8b 50 08             	mov    0x8(%eax),%edx
  802851:	8b 45 08             	mov    0x8(%ebp),%eax
  802854:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802857:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80285b:	75 17                	jne    802874 <insert_sorted_with_merge_freeList+0x234>
  80285d:	83 ec 04             	sub    $0x4,%esp
  802860:	68 d0 37 80 00       	push   $0x8037d0
  802865:	68 31 01 00 00       	push   $0x131
  80286a:	68 f3 37 80 00       	push   $0x8037f3
  80286f:	e8 28 05 00 00       	call   802d9c <_panic>
  802874:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80287a:	8b 45 08             	mov    0x8(%ebp),%eax
  80287d:	89 10                	mov    %edx,(%eax)
  80287f:	8b 45 08             	mov    0x8(%ebp),%eax
  802882:	8b 00                	mov    (%eax),%eax
  802884:	85 c0                	test   %eax,%eax
  802886:	74 0d                	je     802895 <insert_sorted_with_merge_freeList+0x255>
  802888:	a1 48 41 80 00       	mov    0x804148,%eax
  80288d:	8b 55 08             	mov    0x8(%ebp),%edx
  802890:	89 50 04             	mov    %edx,0x4(%eax)
  802893:	eb 08                	jmp    80289d <insert_sorted_with_merge_freeList+0x25d>
  802895:	8b 45 08             	mov    0x8(%ebp),%eax
  802898:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80289d:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a0:	a3 48 41 80 00       	mov    %eax,0x804148
  8028a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028af:	a1 54 41 80 00       	mov    0x804154,%eax
  8028b4:	40                   	inc    %eax
  8028b5:	a3 54 41 80 00       	mov    %eax,0x804154
						}
				}
        }

}
}
  8028ba:	e9 da 04 00 00       	jmp    802d99 <insert_sorted_with_merge_freeList+0x759>

				}

				else
				{
					LIST_INSERT_TAIL(&(FreeMemBlocksList),  blockToInsert);
  8028bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028c3:	75 17                	jne    8028dc <insert_sorted_with_merge_freeList+0x29c>
  8028c5:	83 ec 04             	sub    $0x4,%esp
  8028c8:	68 78 38 80 00       	push   $0x803878
  8028cd:	68 37 01 00 00       	push   $0x137
  8028d2:	68 f3 37 80 00       	push   $0x8037f3
  8028d7:	e8 c0 04 00 00       	call   802d9c <_panic>
  8028dc:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  8028e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e5:	89 50 04             	mov    %edx,0x4(%eax)
  8028e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8028eb:	8b 40 04             	mov    0x4(%eax),%eax
  8028ee:	85 c0                	test   %eax,%eax
  8028f0:	74 0c                	je     8028fe <insert_sorted_with_merge_freeList+0x2be>
  8028f2:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8028f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8028fa:	89 10                	mov    %edx,(%eax)
  8028fc:	eb 08                	jmp    802906 <insert_sorted_with_merge_freeList+0x2c6>
  8028fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802901:	a3 38 41 80 00       	mov    %eax,0x804138
  802906:	8b 45 08             	mov    0x8(%ebp),%eax
  802909:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80290e:	8b 45 08             	mov    0x8(%ebp),%eax
  802911:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802917:	a1 44 41 80 00       	mov    0x804144,%eax
  80291c:	40                   	inc    %eax
  80291d:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  802922:	e9 72 04 00 00       	jmp    802d99 <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  802927:	a1 38 41 80 00       	mov    0x804138,%eax
  80292c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80292f:	e9 35 04 00 00       	jmp    802d69 <insert_sorted_with_merge_freeList+0x729>
				{
				     next=LIST_NEXT(blk_itr);
  802934:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802937:	8b 00                	mov    (%eax),%eax
  802939:	89 45 e8             	mov    %eax,-0x18(%ebp)


					if( (blockToInsert->sva > blk_itr->sva) )
  80293c:	8b 45 08             	mov    0x8(%ebp),%eax
  80293f:	8b 50 08             	mov    0x8(%eax),%edx
  802942:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802945:	8b 40 08             	mov    0x8(%eax),%eax
  802948:	39 c2                	cmp    %eax,%edx
  80294a:	0f 86 11 04 00 00    	jbe    802d61 <insert_sorted_with_merge_freeList+0x721>
						{
							if(((blk_itr->sva) + (blk_itr->size) < blockToInsert->sva && (blockToInsert->sva) + (blockToInsert->size) < next->sva))
  802950:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802953:	8b 50 08             	mov    0x8(%eax),%edx
  802956:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802959:	8b 40 0c             	mov    0xc(%eax),%eax
  80295c:	01 c2                	add    %eax,%edx
  80295e:	8b 45 08             	mov    0x8(%ebp),%eax
  802961:	8b 40 08             	mov    0x8(%eax),%eax
  802964:	39 c2                	cmp    %eax,%edx
  802966:	0f 83 8b 00 00 00    	jae    8029f7 <insert_sorted_with_merge_freeList+0x3b7>
  80296c:	8b 45 08             	mov    0x8(%ebp),%eax
  80296f:	8b 50 08             	mov    0x8(%eax),%edx
  802972:	8b 45 08             	mov    0x8(%ebp),%eax
  802975:	8b 40 0c             	mov    0xc(%eax),%eax
  802978:	01 c2                	add    %eax,%edx
  80297a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80297d:	8b 40 08             	mov    0x8(%eax),%eax
  802980:	39 c2                	cmp    %eax,%edx
  802982:	73 73                	jae    8029f7 <insert_sorted_with_merge_freeList+0x3b7>
							{
								LIST_INSERT_AFTER(&(FreeMemBlocksList), blk_itr, blockToInsert);
  802984:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802988:	74 06                	je     802990 <insert_sorted_with_merge_freeList+0x350>
  80298a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80298e:	75 17                	jne    8029a7 <insert_sorted_with_merge_freeList+0x367>
  802990:	83 ec 04             	sub    $0x4,%esp
  802993:	68 44 38 80 00       	push   $0x803844
  802998:	68 48 01 00 00       	push   $0x148
  80299d:	68 f3 37 80 00       	push   $0x8037f3
  8029a2:	e8 f5 03 00 00       	call   802d9c <_panic>
  8029a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029aa:	8b 10                	mov    (%eax),%edx
  8029ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8029af:	89 10                	mov    %edx,(%eax)
  8029b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b4:	8b 00                	mov    (%eax),%eax
  8029b6:	85 c0                	test   %eax,%eax
  8029b8:	74 0b                	je     8029c5 <insert_sorted_with_merge_freeList+0x385>
  8029ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bd:	8b 00                	mov    (%eax),%eax
  8029bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8029c2:	89 50 04             	mov    %edx,0x4(%eax)
  8029c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8029cb:	89 10                	mov    %edx,(%eax)
  8029cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029d3:	89 50 04             	mov    %edx,0x4(%eax)
  8029d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d9:	8b 00                	mov    (%eax),%eax
  8029db:	85 c0                	test   %eax,%eax
  8029dd:	75 08                	jne    8029e7 <insert_sorted_with_merge_freeList+0x3a7>
  8029df:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e2:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029e7:	a1 44 41 80 00       	mov    0x804144,%eax
  8029ec:	40                   	inc    %eax
  8029ed:	a3 44 41 80 00       	mov    %eax,0x804144
								break;
  8029f2:	e9 a2 03 00 00       	jmp    802d99 <insert_sorted_with_merge_freeList+0x759>

							}
							else if((blockToInsert->sva + blockToInsert->size) < next->sva  && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  8029f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029fa:	8b 50 08             	mov    0x8(%eax),%edx
  8029fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802a00:	8b 40 0c             	mov    0xc(%eax),%eax
  802a03:	01 c2                	add    %eax,%edx
  802a05:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a08:	8b 40 08             	mov    0x8(%eax),%eax
  802a0b:	39 c2                	cmp    %eax,%edx
  802a0d:	0f 83 ae 00 00 00    	jae    802ac1 <insert_sorted_with_merge_freeList+0x481>
  802a13:	8b 45 08             	mov    0x8(%ebp),%eax
  802a16:	8b 50 08             	mov    0x8(%eax),%edx
  802a19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1c:	8b 48 08             	mov    0x8(%eax),%ecx
  802a1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a22:	8b 40 0c             	mov    0xc(%eax),%eax
  802a25:	01 c8                	add    %ecx,%eax
  802a27:	39 c2                	cmp    %eax,%edx
  802a29:	0f 85 92 00 00 00    	jne    802ac1 <insert_sorted_with_merge_freeList+0x481>
							{

								blk_itr->size=blk_itr->size+blockToInsert->size;
  802a2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a32:	8b 50 0c             	mov    0xc(%eax),%edx
  802a35:	8b 45 08             	mov    0x8(%ebp),%eax
  802a38:	8b 40 0c             	mov    0xc(%eax),%eax
  802a3b:	01 c2                	add    %eax,%edx
  802a3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a40:	89 50 0c             	mov    %edx,0xc(%eax)
								 blockToInsert->size=blockToInsert->sva=0;
  802a43:	8b 45 08             	mov    0x8(%ebp),%eax
  802a46:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a50:	8b 50 08             	mov    0x8(%eax),%edx
  802a53:	8b 45 08             	mov    0x8(%ebp),%eax
  802a56:	89 50 0c             	mov    %edx,0xc(%eax)
								 LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802a59:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a5d:	75 17                	jne    802a76 <insert_sorted_with_merge_freeList+0x436>
  802a5f:	83 ec 04             	sub    $0x4,%esp
  802a62:	68 d0 37 80 00       	push   $0x8037d0
  802a67:	68 51 01 00 00       	push   $0x151
  802a6c:	68 f3 37 80 00       	push   $0x8037f3
  802a71:	e8 26 03 00 00       	call   802d9c <_panic>
  802a76:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7f:	89 10                	mov    %edx,(%eax)
  802a81:	8b 45 08             	mov    0x8(%ebp),%eax
  802a84:	8b 00                	mov    (%eax),%eax
  802a86:	85 c0                	test   %eax,%eax
  802a88:	74 0d                	je     802a97 <insert_sorted_with_merge_freeList+0x457>
  802a8a:	a1 48 41 80 00       	mov    0x804148,%eax
  802a8f:	8b 55 08             	mov    0x8(%ebp),%edx
  802a92:	89 50 04             	mov    %edx,0x4(%eax)
  802a95:	eb 08                	jmp    802a9f <insert_sorted_with_merge_freeList+0x45f>
  802a97:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa2:	a3 48 41 80 00       	mov    %eax,0x804148
  802aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  802aaa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ab1:	a1 54 41 80 00       	mov    0x804154,%eax
  802ab6:	40                   	inc    %eax
  802ab7:	a3 54 41 80 00       	mov    %eax,0x804154
								 break;
  802abc:	e9 d8 02 00 00       	jmp    802d99 <insert_sorted_with_merge_freeList+0x759>

							}
							else if( (blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva > (blk_itr->sva + blk_itr->size))
  802ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac4:	8b 50 08             	mov    0x8(%eax),%edx
  802ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  802aca:	8b 40 0c             	mov    0xc(%eax),%eax
  802acd:	01 c2                	add    %eax,%edx
  802acf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ad2:	8b 40 08             	mov    0x8(%eax),%eax
  802ad5:	39 c2                	cmp    %eax,%edx
  802ad7:	0f 85 ba 00 00 00    	jne    802b97 <insert_sorted_with_merge_freeList+0x557>
  802add:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae0:	8b 50 08             	mov    0x8(%eax),%edx
  802ae3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae6:	8b 48 08             	mov    0x8(%eax),%ecx
  802ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aec:	8b 40 0c             	mov    0xc(%eax),%eax
  802aef:	01 c8                	add    %ecx,%eax
  802af1:	39 c2                	cmp    %eax,%edx
  802af3:	0f 86 9e 00 00 00    	jbe    802b97 <insert_sorted_with_merge_freeList+0x557>
							{
								next->size = next->size + blockToInsert->size;
  802af9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802afc:	8b 50 0c             	mov    0xc(%eax),%edx
  802aff:	8b 45 08             	mov    0x8(%ebp),%eax
  802b02:	8b 40 0c             	mov    0xc(%eax),%eax
  802b05:	01 c2                	add    %eax,%edx
  802b07:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b0a:	89 50 0c             	mov    %edx,0xc(%eax)
								next->sva = blockToInsert->sva;
  802b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b10:	8b 50 08             	mov    0x8(%eax),%edx
  802b13:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b16:	89 50 08             	mov    %edx,0x8(%eax)

								blockToInsert->size = blockToInsert->sva = 0;
  802b19:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802b23:	8b 45 08             	mov    0x8(%ebp),%eax
  802b26:	8b 50 08             	mov    0x8(%eax),%edx
  802b29:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2c:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802b2f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b33:	75 17                	jne    802b4c <insert_sorted_with_merge_freeList+0x50c>
  802b35:	83 ec 04             	sub    $0x4,%esp
  802b38:	68 d0 37 80 00       	push   $0x8037d0
  802b3d:	68 5b 01 00 00       	push   $0x15b
  802b42:	68 f3 37 80 00       	push   $0x8037f3
  802b47:	e8 50 02 00 00       	call   802d9c <_panic>
  802b4c:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b52:	8b 45 08             	mov    0x8(%ebp),%eax
  802b55:	89 10                	mov    %edx,(%eax)
  802b57:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5a:	8b 00                	mov    (%eax),%eax
  802b5c:	85 c0                	test   %eax,%eax
  802b5e:	74 0d                	je     802b6d <insert_sorted_with_merge_freeList+0x52d>
  802b60:	a1 48 41 80 00       	mov    0x804148,%eax
  802b65:	8b 55 08             	mov    0x8(%ebp),%edx
  802b68:	89 50 04             	mov    %edx,0x4(%eax)
  802b6b:	eb 08                	jmp    802b75 <insert_sorted_with_merge_freeList+0x535>
  802b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b70:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b75:	8b 45 08             	mov    0x8(%ebp),%eax
  802b78:	a3 48 41 80 00       	mov    %eax,0x804148
  802b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b80:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b87:	a1 54 41 80 00       	mov    0x804154,%eax
  802b8c:	40                   	inc    %eax
  802b8d:	a3 54 41 80 00       	mov    %eax,0x804154
								break;
  802b92:	e9 02 02 00 00       	jmp    802d99 <insert_sorted_with_merge_freeList+0x759>
							}
							else if ((blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  802b97:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9a:	8b 50 08             	mov    0x8(%eax),%edx
  802b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba0:	8b 40 0c             	mov    0xc(%eax),%eax
  802ba3:	01 c2                	add    %eax,%edx
  802ba5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ba8:	8b 40 08             	mov    0x8(%eax),%eax
  802bab:	39 c2                	cmp    %eax,%edx
  802bad:	0f 85 ae 01 00 00    	jne    802d61 <insert_sorted_with_merge_freeList+0x721>
  802bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb6:	8b 50 08             	mov    0x8(%eax),%edx
  802bb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbc:	8b 48 08             	mov    0x8(%eax),%ecx
  802bbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc2:	8b 40 0c             	mov    0xc(%eax),%eax
  802bc5:	01 c8                	add    %ecx,%eax
  802bc7:	39 c2                	cmp    %eax,%edx
  802bc9:	0f 85 92 01 00 00    	jne    802d61 <insert_sorted_with_merge_freeList+0x721>
							{
								blk_itr->size = blk_itr->size + blockToInsert->size + next->size;
  802bcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd2:	8b 50 0c             	mov    0xc(%eax),%edx
  802bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd8:	8b 40 0c             	mov    0xc(%eax),%eax
  802bdb:	01 c2                	add    %eax,%edx
  802bdd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802be0:	8b 40 0c             	mov    0xc(%eax),%eax
  802be3:	01 c2                	add    %eax,%edx
  802be5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be8:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size = blockToInsert->sva=0;
  802beb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bee:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf8:	8b 50 08             	mov    0x8(%eax),%edx
  802bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfe:	89 50 0c             	mov    %edx,0xc(%eax)
								next->size = next->sva = 0;
  802c01:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c04:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802c0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c0e:	8b 50 08             	mov    0x8(%eax),%edx
  802c11:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c14:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_REMOVE(&FreeMemBlocksList, next);
  802c17:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802c1b:	75 17                	jne    802c34 <insert_sorted_with_merge_freeList+0x5f4>
  802c1d:	83 ec 04             	sub    $0x4,%esp
  802c20:	68 9b 38 80 00       	push   $0x80389b
  802c25:	68 63 01 00 00       	push   $0x163
  802c2a:	68 f3 37 80 00       	push   $0x8037f3
  802c2f:	e8 68 01 00 00       	call   802d9c <_panic>
  802c34:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c37:	8b 00                	mov    (%eax),%eax
  802c39:	85 c0                	test   %eax,%eax
  802c3b:	74 10                	je     802c4d <insert_sorted_with_merge_freeList+0x60d>
  802c3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c40:	8b 00                	mov    (%eax),%eax
  802c42:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c45:	8b 52 04             	mov    0x4(%edx),%edx
  802c48:	89 50 04             	mov    %edx,0x4(%eax)
  802c4b:	eb 0b                	jmp    802c58 <insert_sorted_with_merge_freeList+0x618>
  802c4d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c50:	8b 40 04             	mov    0x4(%eax),%eax
  802c53:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c58:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c5b:	8b 40 04             	mov    0x4(%eax),%eax
  802c5e:	85 c0                	test   %eax,%eax
  802c60:	74 0f                	je     802c71 <insert_sorted_with_merge_freeList+0x631>
  802c62:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c65:	8b 40 04             	mov    0x4(%eax),%eax
  802c68:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c6b:	8b 12                	mov    (%edx),%edx
  802c6d:	89 10                	mov    %edx,(%eax)
  802c6f:	eb 0a                	jmp    802c7b <insert_sorted_with_merge_freeList+0x63b>
  802c71:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c74:	8b 00                	mov    (%eax),%eax
  802c76:	a3 38 41 80 00       	mov    %eax,0x804138
  802c7b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c7e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c84:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c87:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c8e:	a1 44 41 80 00       	mov    0x804144,%eax
  802c93:	48                   	dec    %eax
  802c94:	a3 44 41 80 00       	mov    %eax,0x804144
								LIST_INSERT_HEAD(&AvailableMemBlocksList, next );
  802c99:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802c9d:	75 17                	jne    802cb6 <insert_sorted_with_merge_freeList+0x676>
  802c9f:	83 ec 04             	sub    $0x4,%esp
  802ca2:	68 d0 37 80 00       	push   $0x8037d0
  802ca7:	68 64 01 00 00       	push   $0x164
  802cac:	68 f3 37 80 00       	push   $0x8037f3
  802cb1:	e8 e6 00 00 00       	call   802d9c <_panic>
  802cb6:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802cbc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cbf:	89 10                	mov    %edx,(%eax)
  802cc1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cc4:	8b 00                	mov    (%eax),%eax
  802cc6:	85 c0                	test   %eax,%eax
  802cc8:	74 0d                	je     802cd7 <insert_sorted_with_merge_freeList+0x697>
  802cca:	a1 48 41 80 00       	mov    0x804148,%eax
  802ccf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802cd2:	89 50 04             	mov    %edx,0x4(%eax)
  802cd5:	eb 08                	jmp    802cdf <insert_sorted_with_merge_freeList+0x69f>
  802cd7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cda:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802cdf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ce2:	a3 48 41 80 00       	mov    %eax,0x804148
  802ce7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cf1:	a1 54 41 80 00       	mov    0x804154,%eax
  802cf6:	40                   	inc    %eax
  802cf7:	a3 54 41 80 00       	mov    %eax,0x804154
							    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802cfc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d00:	75 17                	jne    802d19 <insert_sorted_with_merge_freeList+0x6d9>
  802d02:	83 ec 04             	sub    $0x4,%esp
  802d05:	68 d0 37 80 00       	push   $0x8037d0
  802d0a:	68 65 01 00 00       	push   $0x165
  802d0f:	68 f3 37 80 00       	push   $0x8037f3
  802d14:	e8 83 00 00 00       	call   802d9c <_panic>
  802d19:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d22:	89 10                	mov    %edx,(%eax)
  802d24:	8b 45 08             	mov    0x8(%ebp),%eax
  802d27:	8b 00                	mov    (%eax),%eax
  802d29:	85 c0                	test   %eax,%eax
  802d2b:	74 0d                	je     802d3a <insert_sorted_with_merge_freeList+0x6fa>
  802d2d:	a1 48 41 80 00       	mov    0x804148,%eax
  802d32:	8b 55 08             	mov    0x8(%ebp),%edx
  802d35:	89 50 04             	mov    %edx,0x4(%eax)
  802d38:	eb 08                	jmp    802d42 <insert_sorted_with_merge_freeList+0x702>
  802d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d42:	8b 45 08             	mov    0x8(%ebp),%eax
  802d45:	a3 48 41 80 00       	mov    %eax,0x804148
  802d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d54:	a1 54 41 80 00       	mov    0x804154,%eax
  802d59:	40                   	inc    %eax
  802d5a:	a3 54 41 80 00       	mov    %eax,0x804154
								break;
  802d5f:	eb 38                	jmp    802d99 <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  802d61:	a1 40 41 80 00       	mov    0x804140,%eax
  802d66:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d69:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d6d:	74 07                	je     802d76 <insert_sorted_with_merge_freeList+0x736>
  802d6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d72:	8b 00                	mov    (%eax),%eax
  802d74:	eb 05                	jmp    802d7b <insert_sorted_with_merge_freeList+0x73b>
  802d76:	b8 00 00 00 00       	mov    $0x0,%eax
  802d7b:	a3 40 41 80 00       	mov    %eax,0x804140
  802d80:	a1 40 41 80 00       	mov    0x804140,%eax
  802d85:	85 c0                	test   %eax,%eax
  802d87:	0f 85 a7 fb ff ff    	jne    802934 <insert_sorted_with_merge_freeList+0x2f4>
  802d8d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d91:	0f 85 9d fb ff ff    	jne    802934 <insert_sorted_with_merge_freeList+0x2f4>
						}
				}
        }

}
}
  802d97:	eb 00                	jmp    802d99 <insert_sorted_with_merge_freeList+0x759>
  802d99:	90                   	nop
  802d9a:	c9                   	leave  
  802d9b:	c3                   	ret    

00802d9c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  802d9c:	55                   	push   %ebp
  802d9d:	89 e5                	mov    %esp,%ebp
  802d9f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  802da2:	8d 45 10             	lea    0x10(%ebp),%eax
  802da5:	83 c0 04             	add    $0x4,%eax
  802da8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  802dab:	a1 5c 41 80 00       	mov    0x80415c,%eax
  802db0:	85 c0                	test   %eax,%eax
  802db2:	74 16                	je     802dca <_panic+0x2e>
		cprintf("%s: ", argv0);
  802db4:	a1 5c 41 80 00       	mov    0x80415c,%eax
  802db9:	83 ec 08             	sub    $0x8,%esp
  802dbc:	50                   	push   %eax
  802dbd:	68 ec 38 80 00       	push   $0x8038ec
  802dc2:	e8 81 d5 ff ff       	call   800348 <cprintf>
  802dc7:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  802dca:	a1 00 40 80 00       	mov    0x804000,%eax
  802dcf:	ff 75 0c             	pushl  0xc(%ebp)
  802dd2:	ff 75 08             	pushl  0x8(%ebp)
  802dd5:	50                   	push   %eax
  802dd6:	68 f1 38 80 00       	push   $0x8038f1
  802ddb:	e8 68 d5 ff ff       	call   800348 <cprintf>
  802de0:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  802de3:	8b 45 10             	mov    0x10(%ebp),%eax
  802de6:	83 ec 08             	sub    $0x8,%esp
  802de9:	ff 75 f4             	pushl  -0xc(%ebp)
  802dec:	50                   	push   %eax
  802ded:	e8 eb d4 ff ff       	call   8002dd <vcprintf>
  802df2:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  802df5:	83 ec 08             	sub    $0x8,%esp
  802df8:	6a 00                	push   $0x0
  802dfa:	68 0d 39 80 00       	push   $0x80390d
  802dff:	e8 d9 d4 ff ff       	call   8002dd <vcprintf>
  802e04:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  802e07:	e8 5a d4 ff ff       	call   800266 <exit>

	// should not return here
	while (1) ;
  802e0c:	eb fe                	jmp    802e0c <_panic+0x70>

00802e0e <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  802e0e:	55                   	push   %ebp
  802e0f:	89 e5                	mov    %esp,%ebp
  802e11:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  802e14:	a1 20 40 80 00       	mov    0x804020,%eax
  802e19:	8b 50 74             	mov    0x74(%eax),%edx
  802e1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e1f:	39 c2                	cmp    %eax,%edx
  802e21:	74 14                	je     802e37 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  802e23:	83 ec 04             	sub    $0x4,%esp
  802e26:	68 10 39 80 00       	push   $0x803910
  802e2b:	6a 26                	push   $0x26
  802e2d:	68 5c 39 80 00       	push   $0x80395c
  802e32:	e8 65 ff ff ff       	call   802d9c <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  802e37:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  802e3e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802e45:	e9 c2 00 00 00       	jmp    802f0c <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  802e4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e4d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802e54:	8b 45 08             	mov    0x8(%ebp),%eax
  802e57:	01 d0                	add    %edx,%eax
  802e59:	8b 00                	mov    (%eax),%eax
  802e5b:	85 c0                	test   %eax,%eax
  802e5d:	75 08                	jne    802e67 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  802e5f:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  802e62:	e9 a2 00 00 00       	jmp    802f09 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  802e67:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802e6e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802e75:	eb 69                	jmp    802ee0 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  802e77:	a1 20 40 80 00       	mov    0x804020,%eax
  802e7c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  802e82:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e85:	89 d0                	mov    %edx,%eax
  802e87:	01 c0                	add    %eax,%eax
  802e89:	01 d0                	add    %edx,%eax
  802e8b:	c1 e0 03             	shl    $0x3,%eax
  802e8e:	01 c8                	add    %ecx,%eax
  802e90:	8a 40 04             	mov    0x4(%eax),%al
  802e93:	84 c0                	test   %al,%al
  802e95:	75 46                	jne    802edd <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  802e97:	a1 20 40 80 00       	mov    0x804020,%eax
  802e9c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  802ea2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ea5:	89 d0                	mov    %edx,%eax
  802ea7:	01 c0                	add    %eax,%eax
  802ea9:	01 d0                	add    %edx,%eax
  802eab:	c1 e0 03             	shl    $0x3,%eax
  802eae:	01 c8                	add    %ecx,%eax
  802eb0:	8b 00                	mov    (%eax),%eax
  802eb2:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802eb5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802eb8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802ebd:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  802ebf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ec2:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  802ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecc:	01 c8                	add    %ecx,%eax
  802ece:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  802ed0:	39 c2                	cmp    %eax,%edx
  802ed2:	75 09                	jne    802edd <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  802ed4:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  802edb:	eb 12                	jmp    802eef <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802edd:	ff 45 e8             	incl   -0x18(%ebp)
  802ee0:	a1 20 40 80 00       	mov    0x804020,%eax
  802ee5:	8b 50 74             	mov    0x74(%eax),%edx
  802ee8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eeb:	39 c2                	cmp    %eax,%edx
  802eed:	77 88                	ja     802e77 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  802eef:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ef3:	75 14                	jne    802f09 <CheckWSWithoutLastIndex+0xfb>
			panic(
  802ef5:	83 ec 04             	sub    $0x4,%esp
  802ef8:	68 68 39 80 00       	push   $0x803968
  802efd:	6a 3a                	push   $0x3a
  802eff:	68 5c 39 80 00       	push   $0x80395c
  802f04:	e8 93 fe ff ff       	call   802d9c <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  802f09:	ff 45 f0             	incl   -0x10(%ebp)
  802f0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f0f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802f12:	0f 8c 32 ff ff ff    	jl     802e4a <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  802f18:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802f1f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802f26:	eb 26                	jmp    802f4e <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  802f28:	a1 20 40 80 00       	mov    0x804020,%eax
  802f2d:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  802f33:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f36:	89 d0                	mov    %edx,%eax
  802f38:	01 c0                	add    %eax,%eax
  802f3a:	01 d0                	add    %edx,%eax
  802f3c:	c1 e0 03             	shl    $0x3,%eax
  802f3f:	01 c8                	add    %ecx,%eax
  802f41:	8a 40 04             	mov    0x4(%eax),%al
  802f44:	3c 01                	cmp    $0x1,%al
  802f46:	75 03                	jne    802f4b <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  802f48:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802f4b:	ff 45 e0             	incl   -0x20(%ebp)
  802f4e:	a1 20 40 80 00       	mov    0x804020,%eax
  802f53:	8b 50 74             	mov    0x74(%eax),%edx
  802f56:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f59:	39 c2                	cmp    %eax,%edx
  802f5b:	77 cb                	ja     802f28 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  802f5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f60:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802f63:	74 14                	je     802f79 <CheckWSWithoutLastIndex+0x16b>
		panic(
  802f65:	83 ec 04             	sub    $0x4,%esp
  802f68:	68 bc 39 80 00       	push   $0x8039bc
  802f6d:	6a 44                	push   $0x44
  802f6f:	68 5c 39 80 00       	push   $0x80395c
  802f74:	e8 23 fe ff ff       	call   802d9c <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  802f79:	90                   	nop
  802f7a:	c9                   	leave  
  802f7b:	c3                   	ret    

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
