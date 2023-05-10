
obj/user/MidTermEx_Master:     file format elf32-i386


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
  800031:	e8 14 02 00 00       	call   80024a <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Scenario that tests the usage of shared variables
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	/*[1] CREATE SHARED VARIABLE & INITIALIZE IT*/
	int *X = smalloc("X", sizeof(int) , 1) ;
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 01                	push   $0x1
  800043:	6a 04                	push   $0x4
  800045:	68 00 33 80 00       	push   $0x803300
  80004a:	e8 86 14 00 00       	call   8014d5 <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*X = 5 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 05 00 00 00    	movl   $0x5,(%eax)

	/*[2] SPECIFY WHETHER TO USE SEMAPHORE OR NOT*/
	cprintf("Do you want to use semaphore (y/n)? ") ;
  80005e:	83 ec 0c             	sub    $0xc,%esp
  800061:	68 04 33 80 00       	push   $0x803304
  800066:	e8 ef 03 00 00       	call   80045a <cprintf>
  80006b:	83 c4 10             	add    $0x10,%esp
	char select = getchar() ;
  80006e:	e8 7f 01 00 00       	call   8001f2 <getchar>
  800073:	88 45 f3             	mov    %al,-0xd(%ebp)
	cputchar(select);
  800076:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
  80007a:	83 ec 0c             	sub    $0xc,%esp
  80007d:	50                   	push   %eax
  80007e:	e8 27 01 00 00       	call   8001aa <cputchar>
  800083:	83 c4 10             	add    $0x10,%esp
	cputchar('\n');
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	6a 0a                	push   $0xa
  80008b:	e8 1a 01 00 00       	call   8001aa <cputchar>
  800090:	83 c4 10             	add    $0x10,%esp

	/*[3] SHARE THIS SELECTION WITH OTHER PROCESSES*/
	int *useSem = smalloc("useSem", sizeof(int) , 0) ;
  800093:	83 ec 04             	sub    $0x4,%esp
  800096:	6a 00                	push   $0x0
  800098:	6a 04                	push   $0x4
  80009a:	68 29 33 80 00       	push   $0x803329
  80009f:	e8 31 14 00 00       	call   8014d5 <smalloc>
  8000a4:	83 c4 10             	add    $0x10,%esp
  8000a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
	*useSem = 0 ;
  8000aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000ad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	if (select == 'Y' || select == 'y')
  8000b3:	80 7d f3 59          	cmpb   $0x59,-0xd(%ebp)
  8000b7:	74 06                	je     8000bf <_main+0x87>
  8000b9:	80 7d f3 79          	cmpb   $0x79,-0xd(%ebp)
  8000bd:	75 09                	jne    8000c8 <_main+0x90>
		*useSem = 1 ;
  8000bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000c2:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	if (*useSem == 1)
  8000c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000cb:	8b 00                	mov    (%eax),%eax
  8000cd:	83 f8 01             	cmp    $0x1,%eax
  8000d0:	75 12                	jne    8000e4 <_main+0xac>
	{
		sys_createSemaphore("T", 0);
  8000d2:	83 ec 08             	sub    $0x8,%esp
  8000d5:	6a 00                	push   $0x0
  8000d7:	68 30 33 80 00       	push   $0x803330
  8000dc:	e8 34 18 00 00       	call   801915 <sys_createSemaphore>
  8000e1:	83 c4 10             	add    $0x10,%esp
	}

	/*[4] CREATE AND RUN ProcessA & ProcessB*/

	//Create the check-finishing counter
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  8000e4:	83 ec 04             	sub    $0x4,%esp
  8000e7:	6a 01                	push   $0x1
  8000e9:	6a 04                	push   $0x4
  8000eb:	68 32 33 80 00       	push   $0x803332
  8000f0:	e8 e0 13 00 00       	call   8014d5 <smalloc>
  8000f5:	83 c4 10             	add    $0x10,%esp
  8000f8:	89 45 e8             	mov    %eax,-0x18(%ebp)
	*numOfFinished = 0 ;
  8000fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	//Create the 2 processes
	int32 envIdProcessA = sys_create_env("midterm_a", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800104:	a1 20 40 80 00       	mov    0x804020,%eax
  800109:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  80010f:	a1 20 40 80 00       	mov    0x804020,%eax
  800114:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80011a:	89 c1                	mov    %eax,%ecx
  80011c:	a1 20 40 80 00       	mov    0x804020,%eax
  800121:	8b 40 74             	mov    0x74(%eax),%eax
  800124:	52                   	push   %edx
  800125:	51                   	push   %ecx
  800126:	50                   	push   %eax
  800127:	68 40 33 80 00       	push   $0x803340
  80012c:	e8 f5 18 00 00       	call   801a26 <sys_create_env>
  800131:	83 c4 10             	add    $0x10,%esp
  800134:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int32 envIdProcessB = sys_create_env("midterm_b", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800137:	a1 20 40 80 00       	mov    0x804020,%eax
  80013c:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800142:	a1 20 40 80 00       	mov    0x804020,%eax
  800147:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80014d:	89 c1                	mov    %eax,%ecx
  80014f:	a1 20 40 80 00       	mov    0x804020,%eax
  800154:	8b 40 74             	mov    0x74(%eax),%eax
  800157:	52                   	push   %edx
  800158:	51                   	push   %ecx
  800159:	50                   	push   %eax
  80015a:	68 4a 33 80 00       	push   $0x80334a
  80015f:	e8 c2 18 00 00       	call   801a26 <sys_create_env>
  800164:	83 c4 10             	add    $0x10,%esp
  800167:	89 45 e0             	mov    %eax,-0x20(%ebp)

	//Run the 2 processes
	sys_run_env(envIdProcessA);
  80016a:	83 ec 0c             	sub    $0xc,%esp
  80016d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800170:	e8 cf 18 00 00       	call   801a44 <sys_run_env>
  800175:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  800178:	83 ec 0c             	sub    $0xc,%esp
  80017b:	ff 75 e0             	pushl  -0x20(%ebp)
  80017e:	e8 c1 18 00 00       	call   801a44 <sys_run_env>
  800183:	83 c4 10             	add    $0x10,%esp

	/*[5] BUSY-WAIT TILL FINISHING BOTH PROCESSES*/
	while (*numOfFinished != 2) ;
  800186:	90                   	nop
  800187:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80018a:	8b 00                	mov    (%eax),%eax
  80018c:	83 f8 02             	cmp    $0x2,%eax
  80018f:	75 f6                	jne    800187 <_main+0x14f>

	/*[6] PRINT X*/
	cprintf("Final value of X = %d\n", *X);
  800191:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800194:	8b 00                	mov    (%eax),%eax
  800196:	83 ec 08             	sub    $0x8,%esp
  800199:	50                   	push   %eax
  80019a:	68 54 33 80 00       	push   $0x803354
  80019f:	e8 b6 02 00 00       	call   80045a <cprintf>
  8001a4:	83 c4 10             	add    $0x10,%esp

	return;
  8001a7:	90                   	nop
}
  8001a8:	c9                   	leave  
  8001a9:	c3                   	ret    

008001aa <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8001aa:	55                   	push   %ebp
  8001ab:	89 e5                	mov    %esp,%ebp
  8001ad:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8001b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8001b3:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8001b6:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8001ba:	83 ec 0c             	sub    $0xc,%esp
  8001bd:	50                   	push   %eax
  8001be:	e8 12 17 00 00       	call   8018d5 <sys_cputc>
  8001c3:	83 c4 10             	add    $0x10,%esp
}
  8001c6:	90                   	nop
  8001c7:	c9                   	leave  
  8001c8:	c3                   	ret    

008001c9 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  8001c9:	55                   	push   %ebp
  8001ca:	89 e5                	mov    %esp,%ebp
  8001cc:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8001cf:	e8 cd 16 00 00       	call   8018a1 <sys_disable_interrupt>
	char c = ch;
  8001d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8001d7:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8001da:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8001de:	83 ec 0c             	sub    $0xc,%esp
  8001e1:	50                   	push   %eax
  8001e2:	e8 ee 16 00 00       	call   8018d5 <sys_cputc>
  8001e7:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8001ea:	e8 cc 16 00 00       	call   8018bb <sys_enable_interrupt>
}
  8001ef:	90                   	nop
  8001f0:	c9                   	leave  
  8001f1:	c3                   	ret    

008001f2 <getchar>:

int
getchar(void)
{
  8001f2:	55                   	push   %ebp
  8001f3:	89 e5                	mov    %esp,%ebp
  8001f5:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  8001f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8001ff:	eb 08                	jmp    800209 <getchar+0x17>
	{
		c = sys_cgetc();
  800201:	e8 16 15 00 00       	call   80171c <sys_cgetc>
  800206:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  800209:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80020d:	74 f2                	je     800201 <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  80020f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800212:	c9                   	leave  
  800213:	c3                   	ret    

00800214 <atomic_getchar>:

int
atomic_getchar(void)
{
  800214:	55                   	push   %ebp
  800215:	89 e5                	mov    %esp,%ebp
  800217:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80021a:	e8 82 16 00 00       	call   8018a1 <sys_disable_interrupt>
	int c=0;
  80021f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800226:	eb 08                	jmp    800230 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800228:	e8 ef 14 00 00       	call   80171c <sys_cgetc>
  80022d:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  800230:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800234:	74 f2                	je     800228 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  800236:	e8 80 16 00 00       	call   8018bb <sys_enable_interrupt>
	return c;
  80023b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80023e:	c9                   	leave  
  80023f:	c3                   	ret    

00800240 <iscons>:

int iscons(int fdnum)
{
  800240:	55                   	push   %ebp
  800241:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  800243:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800248:	5d                   	pop    %ebp
  800249:	c3                   	ret    

0080024a <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80024a:	55                   	push   %ebp
  80024b:	89 e5                	mov    %esp,%ebp
  80024d:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800250:	e8 3f 18 00 00       	call   801a94 <sys_getenvindex>
  800255:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800258:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80025b:	89 d0                	mov    %edx,%eax
  80025d:	c1 e0 03             	shl    $0x3,%eax
  800260:	01 d0                	add    %edx,%eax
  800262:	01 c0                	add    %eax,%eax
  800264:	01 d0                	add    %edx,%eax
  800266:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80026d:	01 d0                	add    %edx,%eax
  80026f:	c1 e0 04             	shl    $0x4,%eax
  800272:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800277:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80027c:	a1 20 40 80 00       	mov    0x804020,%eax
  800281:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800287:	84 c0                	test   %al,%al
  800289:	74 0f                	je     80029a <libmain+0x50>
		binaryname = myEnv->prog_name;
  80028b:	a1 20 40 80 00       	mov    0x804020,%eax
  800290:	05 5c 05 00 00       	add    $0x55c,%eax
  800295:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80029a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80029e:	7e 0a                	jle    8002aa <libmain+0x60>
		binaryname = argv[0];
  8002a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002a3:	8b 00                	mov    (%eax),%eax
  8002a5:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8002aa:	83 ec 08             	sub    $0x8,%esp
  8002ad:	ff 75 0c             	pushl  0xc(%ebp)
  8002b0:	ff 75 08             	pushl  0x8(%ebp)
  8002b3:	e8 80 fd ff ff       	call   800038 <_main>
  8002b8:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8002bb:	e8 e1 15 00 00       	call   8018a1 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8002c0:	83 ec 0c             	sub    $0xc,%esp
  8002c3:	68 84 33 80 00       	push   $0x803384
  8002c8:	e8 8d 01 00 00       	call   80045a <cprintf>
  8002cd:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002d0:	a1 20 40 80 00       	mov    0x804020,%eax
  8002d5:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8002db:	a1 20 40 80 00       	mov    0x804020,%eax
  8002e0:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8002e6:	83 ec 04             	sub    $0x4,%esp
  8002e9:	52                   	push   %edx
  8002ea:	50                   	push   %eax
  8002eb:	68 ac 33 80 00       	push   $0x8033ac
  8002f0:	e8 65 01 00 00       	call   80045a <cprintf>
  8002f5:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8002f8:	a1 20 40 80 00       	mov    0x804020,%eax
  8002fd:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800303:	a1 20 40 80 00       	mov    0x804020,%eax
  800308:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80030e:	a1 20 40 80 00       	mov    0x804020,%eax
  800313:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800319:	51                   	push   %ecx
  80031a:	52                   	push   %edx
  80031b:	50                   	push   %eax
  80031c:	68 d4 33 80 00       	push   $0x8033d4
  800321:	e8 34 01 00 00       	call   80045a <cprintf>
  800326:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800329:	a1 20 40 80 00       	mov    0x804020,%eax
  80032e:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800334:	83 ec 08             	sub    $0x8,%esp
  800337:	50                   	push   %eax
  800338:	68 2c 34 80 00       	push   $0x80342c
  80033d:	e8 18 01 00 00       	call   80045a <cprintf>
  800342:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800345:	83 ec 0c             	sub    $0xc,%esp
  800348:	68 84 33 80 00       	push   $0x803384
  80034d:	e8 08 01 00 00       	call   80045a <cprintf>
  800352:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800355:	e8 61 15 00 00       	call   8018bb <sys_enable_interrupt>

	// exit gracefully
	exit();
  80035a:	e8 19 00 00 00       	call   800378 <exit>
}
  80035f:	90                   	nop
  800360:	c9                   	leave  
  800361:	c3                   	ret    

00800362 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800362:	55                   	push   %ebp
  800363:	89 e5                	mov    %esp,%ebp
  800365:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800368:	83 ec 0c             	sub    $0xc,%esp
  80036b:	6a 00                	push   $0x0
  80036d:	e8 ee 16 00 00       	call   801a60 <sys_destroy_env>
  800372:	83 c4 10             	add    $0x10,%esp
}
  800375:	90                   	nop
  800376:	c9                   	leave  
  800377:	c3                   	ret    

00800378 <exit>:

void
exit(void)
{
  800378:	55                   	push   %ebp
  800379:	89 e5                	mov    %esp,%ebp
  80037b:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80037e:	e8 43 17 00 00       	call   801ac6 <sys_exit_env>
}
  800383:	90                   	nop
  800384:	c9                   	leave  
  800385:	c3                   	ret    

00800386 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800386:	55                   	push   %ebp
  800387:	89 e5                	mov    %esp,%ebp
  800389:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80038c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80038f:	8b 00                	mov    (%eax),%eax
  800391:	8d 48 01             	lea    0x1(%eax),%ecx
  800394:	8b 55 0c             	mov    0xc(%ebp),%edx
  800397:	89 0a                	mov    %ecx,(%edx)
  800399:	8b 55 08             	mov    0x8(%ebp),%edx
  80039c:	88 d1                	mov    %dl,%cl
  80039e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003a1:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8003a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003a8:	8b 00                	mov    (%eax),%eax
  8003aa:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003af:	75 2c                	jne    8003dd <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8003b1:	a0 24 40 80 00       	mov    0x804024,%al
  8003b6:	0f b6 c0             	movzbl %al,%eax
  8003b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003bc:	8b 12                	mov    (%edx),%edx
  8003be:	89 d1                	mov    %edx,%ecx
  8003c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003c3:	83 c2 08             	add    $0x8,%edx
  8003c6:	83 ec 04             	sub    $0x4,%esp
  8003c9:	50                   	push   %eax
  8003ca:	51                   	push   %ecx
  8003cb:	52                   	push   %edx
  8003cc:	e8 22 13 00 00       	call   8016f3 <sys_cputs>
  8003d1:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8003d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8003dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003e0:	8b 40 04             	mov    0x4(%eax),%eax
  8003e3:	8d 50 01             	lea    0x1(%eax),%edx
  8003e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003e9:	89 50 04             	mov    %edx,0x4(%eax)
}
  8003ec:	90                   	nop
  8003ed:	c9                   	leave  
  8003ee:	c3                   	ret    

008003ef <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8003ef:	55                   	push   %ebp
  8003f0:	89 e5                	mov    %esp,%ebp
  8003f2:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003f8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003ff:	00 00 00 
	b.cnt = 0;
  800402:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800409:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80040c:	ff 75 0c             	pushl  0xc(%ebp)
  80040f:	ff 75 08             	pushl  0x8(%ebp)
  800412:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800418:	50                   	push   %eax
  800419:	68 86 03 80 00       	push   $0x800386
  80041e:	e8 11 02 00 00       	call   800634 <vprintfmt>
  800423:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800426:	a0 24 40 80 00       	mov    0x804024,%al
  80042b:	0f b6 c0             	movzbl %al,%eax
  80042e:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800434:	83 ec 04             	sub    $0x4,%esp
  800437:	50                   	push   %eax
  800438:	52                   	push   %edx
  800439:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80043f:	83 c0 08             	add    $0x8,%eax
  800442:	50                   	push   %eax
  800443:	e8 ab 12 00 00       	call   8016f3 <sys_cputs>
  800448:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80044b:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800452:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800458:	c9                   	leave  
  800459:	c3                   	ret    

0080045a <cprintf>:

int cprintf(const char *fmt, ...) {
  80045a:	55                   	push   %ebp
  80045b:	89 e5                	mov    %esp,%ebp
  80045d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800460:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800467:	8d 45 0c             	lea    0xc(%ebp),%eax
  80046a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80046d:	8b 45 08             	mov    0x8(%ebp),%eax
  800470:	83 ec 08             	sub    $0x8,%esp
  800473:	ff 75 f4             	pushl  -0xc(%ebp)
  800476:	50                   	push   %eax
  800477:	e8 73 ff ff ff       	call   8003ef <vcprintf>
  80047c:	83 c4 10             	add    $0x10,%esp
  80047f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800482:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800485:	c9                   	leave  
  800486:	c3                   	ret    

00800487 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800487:	55                   	push   %ebp
  800488:	89 e5                	mov    %esp,%ebp
  80048a:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80048d:	e8 0f 14 00 00       	call   8018a1 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800492:	8d 45 0c             	lea    0xc(%ebp),%eax
  800495:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800498:	8b 45 08             	mov    0x8(%ebp),%eax
  80049b:	83 ec 08             	sub    $0x8,%esp
  80049e:	ff 75 f4             	pushl  -0xc(%ebp)
  8004a1:	50                   	push   %eax
  8004a2:	e8 48 ff ff ff       	call   8003ef <vcprintf>
  8004a7:	83 c4 10             	add    $0x10,%esp
  8004aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8004ad:	e8 09 14 00 00       	call   8018bb <sys_enable_interrupt>
	return cnt;
  8004b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004b5:	c9                   	leave  
  8004b6:	c3                   	ret    

008004b7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004b7:	55                   	push   %ebp
  8004b8:	89 e5                	mov    %esp,%ebp
  8004ba:	53                   	push   %ebx
  8004bb:	83 ec 14             	sub    $0x14,%esp
  8004be:	8b 45 10             	mov    0x10(%ebp),%eax
  8004c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8004c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004ca:	8b 45 18             	mov    0x18(%ebp),%eax
  8004cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8004d2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004d5:	77 55                	ja     80052c <printnum+0x75>
  8004d7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004da:	72 05                	jb     8004e1 <printnum+0x2a>
  8004dc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8004df:	77 4b                	ja     80052c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004e1:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8004e4:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8004e7:	8b 45 18             	mov    0x18(%ebp),%eax
  8004ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8004ef:	52                   	push   %edx
  8004f0:	50                   	push   %eax
  8004f1:	ff 75 f4             	pushl  -0xc(%ebp)
  8004f4:	ff 75 f0             	pushl  -0x10(%ebp)
  8004f7:	e8 94 2b 00 00       	call   803090 <__udivdi3>
  8004fc:	83 c4 10             	add    $0x10,%esp
  8004ff:	83 ec 04             	sub    $0x4,%esp
  800502:	ff 75 20             	pushl  0x20(%ebp)
  800505:	53                   	push   %ebx
  800506:	ff 75 18             	pushl  0x18(%ebp)
  800509:	52                   	push   %edx
  80050a:	50                   	push   %eax
  80050b:	ff 75 0c             	pushl  0xc(%ebp)
  80050e:	ff 75 08             	pushl  0x8(%ebp)
  800511:	e8 a1 ff ff ff       	call   8004b7 <printnum>
  800516:	83 c4 20             	add    $0x20,%esp
  800519:	eb 1a                	jmp    800535 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80051b:	83 ec 08             	sub    $0x8,%esp
  80051e:	ff 75 0c             	pushl  0xc(%ebp)
  800521:	ff 75 20             	pushl  0x20(%ebp)
  800524:	8b 45 08             	mov    0x8(%ebp),%eax
  800527:	ff d0                	call   *%eax
  800529:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80052c:	ff 4d 1c             	decl   0x1c(%ebp)
  80052f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800533:	7f e6                	jg     80051b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800535:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800538:	bb 00 00 00 00       	mov    $0x0,%ebx
  80053d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800540:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800543:	53                   	push   %ebx
  800544:	51                   	push   %ecx
  800545:	52                   	push   %edx
  800546:	50                   	push   %eax
  800547:	e8 54 2c 00 00       	call   8031a0 <__umoddi3>
  80054c:	83 c4 10             	add    $0x10,%esp
  80054f:	05 54 36 80 00       	add    $0x803654,%eax
  800554:	8a 00                	mov    (%eax),%al
  800556:	0f be c0             	movsbl %al,%eax
  800559:	83 ec 08             	sub    $0x8,%esp
  80055c:	ff 75 0c             	pushl  0xc(%ebp)
  80055f:	50                   	push   %eax
  800560:	8b 45 08             	mov    0x8(%ebp),%eax
  800563:	ff d0                	call   *%eax
  800565:	83 c4 10             	add    $0x10,%esp
}
  800568:	90                   	nop
  800569:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80056c:	c9                   	leave  
  80056d:	c3                   	ret    

0080056e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80056e:	55                   	push   %ebp
  80056f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800571:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800575:	7e 1c                	jle    800593 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800577:	8b 45 08             	mov    0x8(%ebp),%eax
  80057a:	8b 00                	mov    (%eax),%eax
  80057c:	8d 50 08             	lea    0x8(%eax),%edx
  80057f:	8b 45 08             	mov    0x8(%ebp),%eax
  800582:	89 10                	mov    %edx,(%eax)
  800584:	8b 45 08             	mov    0x8(%ebp),%eax
  800587:	8b 00                	mov    (%eax),%eax
  800589:	83 e8 08             	sub    $0x8,%eax
  80058c:	8b 50 04             	mov    0x4(%eax),%edx
  80058f:	8b 00                	mov    (%eax),%eax
  800591:	eb 40                	jmp    8005d3 <getuint+0x65>
	else if (lflag)
  800593:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800597:	74 1e                	je     8005b7 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800599:	8b 45 08             	mov    0x8(%ebp),%eax
  80059c:	8b 00                	mov    (%eax),%eax
  80059e:	8d 50 04             	lea    0x4(%eax),%edx
  8005a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a4:	89 10                	mov    %edx,(%eax)
  8005a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a9:	8b 00                	mov    (%eax),%eax
  8005ab:	83 e8 04             	sub    $0x4,%eax
  8005ae:	8b 00                	mov    (%eax),%eax
  8005b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8005b5:	eb 1c                	jmp    8005d3 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8005b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ba:	8b 00                	mov    (%eax),%eax
  8005bc:	8d 50 04             	lea    0x4(%eax),%edx
  8005bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c2:	89 10                	mov    %edx,(%eax)
  8005c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c7:	8b 00                	mov    (%eax),%eax
  8005c9:	83 e8 04             	sub    $0x4,%eax
  8005cc:	8b 00                	mov    (%eax),%eax
  8005ce:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005d3:	5d                   	pop    %ebp
  8005d4:	c3                   	ret    

008005d5 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005d5:	55                   	push   %ebp
  8005d6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005d8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005dc:	7e 1c                	jle    8005fa <getint+0x25>
		return va_arg(*ap, long long);
  8005de:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e1:	8b 00                	mov    (%eax),%eax
  8005e3:	8d 50 08             	lea    0x8(%eax),%edx
  8005e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e9:	89 10                	mov    %edx,(%eax)
  8005eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ee:	8b 00                	mov    (%eax),%eax
  8005f0:	83 e8 08             	sub    $0x8,%eax
  8005f3:	8b 50 04             	mov    0x4(%eax),%edx
  8005f6:	8b 00                	mov    (%eax),%eax
  8005f8:	eb 38                	jmp    800632 <getint+0x5d>
	else if (lflag)
  8005fa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005fe:	74 1a                	je     80061a <getint+0x45>
		return va_arg(*ap, long);
  800600:	8b 45 08             	mov    0x8(%ebp),%eax
  800603:	8b 00                	mov    (%eax),%eax
  800605:	8d 50 04             	lea    0x4(%eax),%edx
  800608:	8b 45 08             	mov    0x8(%ebp),%eax
  80060b:	89 10                	mov    %edx,(%eax)
  80060d:	8b 45 08             	mov    0x8(%ebp),%eax
  800610:	8b 00                	mov    (%eax),%eax
  800612:	83 e8 04             	sub    $0x4,%eax
  800615:	8b 00                	mov    (%eax),%eax
  800617:	99                   	cltd   
  800618:	eb 18                	jmp    800632 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80061a:	8b 45 08             	mov    0x8(%ebp),%eax
  80061d:	8b 00                	mov    (%eax),%eax
  80061f:	8d 50 04             	lea    0x4(%eax),%edx
  800622:	8b 45 08             	mov    0x8(%ebp),%eax
  800625:	89 10                	mov    %edx,(%eax)
  800627:	8b 45 08             	mov    0x8(%ebp),%eax
  80062a:	8b 00                	mov    (%eax),%eax
  80062c:	83 e8 04             	sub    $0x4,%eax
  80062f:	8b 00                	mov    (%eax),%eax
  800631:	99                   	cltd   
}
  800632:	5d                   	pop    %ebp
  800633:	c3                   	ret    

00800634 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800634:	55                   	push   %ebp
  800635:	89 e5                	mov    %esp,%ebp
  800637:	56                   	push   %esi
  800638:	53                   	push   %ebx
  800639:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80063c:	eb 17                	jmp    800655 <vprintfmt+0x21>
			if (ch == '\0')
  80063e:	85 db                	test   %ebx,%ebx
  800640:	0f 84 af 03 00 00    	je     8009f5 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800646:	83 ec 08             	sub    $0x8,%esp
  800649:	ff 75 0c             	pushl  0xc(%ebp)
  80064c:	53                   	push   %ebx
  80064d:	8b 45 08             	mov    0x8(%ebp),%eax
  800650:	ff d0                	call   *%eax
  800652:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800655:	8b 45 10             	mov    0x10(%ebp),%eax
  800658:	8d 50 01             	lea    0x1(%eax),%edx
  80065b:	89 55 10             	mov    %edx,0x10(%ebp)
  80065e:	8a 00                	mov    (%eax),%al
  800660:	0f b6 d8             	movzbl %al,%ebx
  800663:	83 fb 25             	cmp    $0x25,%ebx
  800666:	75 d6                	jne    80063e <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800668:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80066c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800673:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80067a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800681:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800688:	8b 45 10             	mov    0x10(%ebp),%eax
  80068b:	8d 50 01             	lea    0x1(%eax),%edx
  80068e:	89 55 10             	mov    %edx,0x10(%ebp)
  800691:	8a 00                	mov    (%eax),%al
  800693:	0f b6 d8             	movzbl %al,%ebx
  800696:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800699:	83 f8 55             	cmp    $0x55,%eax
  80069c:	0f 87 2b 03 00 00    	ja     8009cd <vprintfmt+0x399>
  8006a2:	8b 04 85 78 36 80 00 	mov    0x803678(,%eax,4),%eax
  8006a9:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8006ab:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8006af:	eb d7                	jmp    800688 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006b1:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8006b5:	eb d1                	jmp    800688 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006b7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8006be:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006c1:	89 d0                	mov    %edx,%eax
  8006c3:	c1 e0 02             	shl    $0x2,%eax
  8006c6:	01 d0                	add    %edx,%eax
  8006c8:	01 c0                	add    %eax,%eax
  8006ca:	01 d8                	add    %ebx,%eax
  8006cc:	83 e8 30             	sub    $0x30,%eax
  8006cf:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8006d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8006d5:	8a 00                	mov    (%eax),%al
  8006d7:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8006da:	83 fb 2f             	cmp    $0x2f,%ebx
  8006dd:	7e 3e                	jle    80071d <vprintfmt+0xe9>
  8006df:	83 fb 39             	cmp    $0x39,%ebx
  8006e2:	7f 39                	jg     80071d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006e4:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8006e7:	eb d5                	jmp    8006be <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8006e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ec:	83 c0 04             	add    $0x4,%eax
  8006ef:	89 45 14             	mov    %eax,0x14(%ebp)
  8006f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f5:	83 e8 04             	sub    $0x4,%eax
  8006f8:	8b 00                	mov    (%eax),%eax
  8006fa:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8006fd:	eb 1f                	jmp    80071e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8006ff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800703:	79 83                	jns    800688 <vprintfmt+0x54>
				width = 0;
  800705:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80070c:	e9 77 ff ff ff       	jmp    800688 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800711:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800718:	e9 6b ff ff ff       	jmp    800688 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80071d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80071e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800722:	0f 89 60 ff ff ff    	jns    800688 <vprintfmt+0x54>
				width = precision, precision = -1;
  800728:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80072b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80072e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800735:	e9 4e ff ff ff       	jmp    800688 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80073a:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80073d:	e9 46 ff ff ff       	jmp    800688 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800742:	8b 45 14             	mov    0x14(%ebp),%eax
  800745:	83 c0 04             	add    $0x4,%eax
  800748:	89 45 14             	mov    %eax,0x14(%ebp)
  80074b:	8b 45 14             	mov    0x14(%ebp),%eax
  80074e:	83 e8 04             	sub    $0x4,%eax
  800751:	8b 00                	mov    (%eax),%eax
  800753:	83 ec 08             	sub    $0x8,%esp
  800756:	ff 75 0c             	pushl  0xc(%ebp)
  800759:	50                   	push   %eax
  80075a:	8b 45 08             	mov    0x8(%ebp),%eax
  80075d:	ff d0                	call   *%eax
  80075f:	83 c4 10             	add    $0x10,%esp
			break;
  800762:	e9 89 02 00 00       	jmp    8009f0 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800767:	8b 45 14             	mov    0x14(%ebp),%eax
  80076a:	83 c0 04             	add    $0x4,%eax
  80076d:	89 45 14             	mov    %eax,0x14(%ebp)
  800770:	8b 45 14             	mov    0x14(%ebp),%eax
  800773:	83 e8 04             	sub    $0x4,%eax
  800776:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800778:	85 db                	test   %ebx,%ebx
  80077a:	79 02                	jns    80077e <vprintfmt+0x14a>
				err = -err;
  80077c:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80077e:	83 fb 64             	cmp    $0x64,%ebx
  800781:	7f 0b                	jg     80078e <vprintfmt+0x15a>
  800783:	8b 34 9d c0 34 80 00 	mov    0x8034c0(,%ebx,4),%esi
  80078a:	85 f6                	test   %esi,%esi
  80078c:	75 19                	jne    8007a7 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80078e:	53                   	push   %ebx
  80078f:	68 65 36 80 00       	push   $0x803665
  800794:	ff 75 0c             	pushl  0xc(%ebp)
  800797:	ff 75 08             	pushl  0x8(%ebp)
  80079a:	e8 5e 02 00 00       	call   8009fd <printfmt>
  80079f:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8007a2:	e9 49 02 00 00       	jmp    8009f0 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8007a7:	56                   	push   %esi
  8007a8:	68 6e 36 80 00       	push   $0x80366e
  8007ad:	ff 75 0c             	pushl  0xc(%ebp)
  8007b0:	ff 75 08             	pushl  0x8(%ebp)
  8007b3:	e8 45 02 00 00       	call   8009fd <printfmt>
  8007b8:	83 c4 10             	add    $0x10,%esp
			break;
  8007bb:	e9 30 02 00 00       	jmp    8009f0 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8007c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c3:	83 c0 04             	add    $0x4,%eax
  8007c6:	89 45 14             	mov    %eax,0x14(%ebp)
  8007c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cc:	83 e8 04             	sub    $0x4,%eax
  8007cf:	8b 30                	mov    (%eax),%esi
  8007d1:	85 f6                	test   %esi,%esi
  8007d3:	75 05                	jne    8007da <vprintfmt+0x1a6>
				p = "(null)";
  8007d5:	be 71 36 80 00       	mov    $0x803671,%esi
			if (width > 0 && padc != '-')
  8007da:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007de:	7e 6d                	jle    80084d <vprintfmt+0x219>
  8007e0:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8007e4:	74 67                	je     80084d <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007e9:	83 ec 08             	sub    $0x8,%esp
  8007ec:	50                   	push   %eax
  8007ed:	56                   	push   %esi
  8007ee:	e8 0c 03 00 00       	call   800aff <strnlen>
  8007f3:	83 c4 10             	add    $0x10,%esp
  8007f6:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8007f9:	eb 16                	jmp    800811 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8007fb:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8007ff:	83 ec 08             	sub    $0x8,%esp
  800802:	ff 75 0c             	pushl  0xc(%ebp)
  800805:	50                   	push   %eax
  800806:	8b 45 08             	mov    0x8(%ebp),%eax
  800809:	ff d0                	call   *%eax
  80080b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80080e:	ff 4d e4             	decl   -0x1c(%ebp)
  800811:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800815:	7f e4                	jg     8007fb <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800817:	eb 34                	jmp    80084d <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800819:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80081d:	74 1c                	je     80083b <vprintfmt+0x207>
  80081f:	83 fb 1f             	cmp    $0x1f,%ebx
  800822:	7e 05                	jle    800829 <vprintfmt+0x1f5>
  800824:	83 fb 7e             	cmp    $0x7e,%ebx
  800827:	7e 12                	jle    80083b <vprintfmt+0x207>
					putch('?', putdat);
  800829:	83 ec 08             	sub    $0x8,%esp
  80082c:	ff 75 0c             	pushl  0xc(%ebp)
  80082f:	6a 3f                	push   $0x3f
  800831:	8b 45 08             	mov    0x8(%ebp),%eax
  800834:	ff d0                	call   *%eax
  800836:	83 c4 10             	add    $0x10,%esp
  800839:	eb 0f                	jmp    80084a <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80083b:	83 ec 08             	sub    $0x8,%esp
  80083e:	ff 75 0c             	pushl  0xc(%ebp)
  800841:	53                   	push   %ebx
  800842:	8b 45 08             	mov    0x8(%ebp),%eax
  800845:	ff d0                	call   *%eax
  800847:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80084a:	ff 4d e4             	decl   -0x1c(%ebp)
  80084d:	89 f0                	mov    %esi,%eax
  80084f:	8d 70 01             	lea    0x1(%eax),%esi
  800852:	8a 00                	mov    (%eax),%al
  800854:	0f be d8             	movsbl %al,%ebx
  800857:	85 db                	test   %ebx,%ebx
  800859:	74 24                	je     80087f <vprintfmt+0x24b>
  80085b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80085f:	78 b8                	js     800819 <vprintfmt+0x1e5>
  800861:	ff 4d e0             	decl   -0x20(%ebp)
  800864:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800868:	79 af                	jns    800819 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80086a:	eb 13                	jmp    80087f <vprintfmt+0x24b>
				putch(' ', putdat);
  80086c:	83 ec 08             	sub    $0x8,%esp
  80086f:	ff 75 0c             	pushl  0xc(%ebp)
  800872:	6a 20                	push   $0x20
  800874:	8b 45 08             	mov    0x8(%ebp),%eax
  800877:	ff d0                	call   *%eax
  800879:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80087c:	ff 4d e4             	decl   -0x1c(%ebp)
  80087f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800883:	7f e7                	jg     80086c <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800885:	e9 66 01 00 00       	jmp    8009f0 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80088a:	83 ec 08             	sub    $0x8,%esp
  80088d:	ff 75 e8             	pushl  -0x18(%ebp)
  800890:	8d 45 14             	lea    0x14(%ebp),%eax
  800893:	50                   	push   %eax
  800894:	e8 3c fd ff ff       	call   8005d5 <getint>
  800899:	83 c4 10             	add    $0x10,%esp
  80089c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80089f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8008a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008a8:	85 d2                	test   %edx,%edx
  8008aa:	79 23                	jns    8008cf <vprintfmt+0x29b>
				putch('-', putdat);
  8008ac:	83 ec 08             	sub    $0x8,%esp
  8008af:	ff 75 0c             	pushl  0xc(%ebp)
  8008b2:	6a 2d                	push   $0x2d
  8008b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b7:	ff d0                	call   *%eax
  8008b9:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8008bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008c2:	f7 d8                	neg    %eax
  8008c4:	83 d2 00             	adc    $0x0,%edx
  8008c7:	f7 da                	neg    %edx
  8008c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008cc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8008cf:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008d6:	e9 bc 00 00 00       	jmp    800997 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8008db:	83 ec 08             	sub    $0x8,%esp
  8008de:	ff 75 e8             	pushl  -0x18(%ebp)
  8008e1:	8d 45 14             	lea    0x14(%ebp),%eax
  8008e4:	50                   	push   %eax
  8008e5:	e8 84 fc ff ff       	call   80056e <getuint>
  8008ea:	83 c4 10             	add    $0x10,%esp
  8008ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008f0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8008f3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008fa:	e9 98 00 00 00       	jmp    800997 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8008ff:	83 ec 08             	sub    $0x8,%esp
  800902:	ff 75 0c             	pushl  0xc(%ebp)
  800905:	6a 58                	push   $0x58
  800907:	8b 45 08             	mov    0x8(%ebp),%eax
  80090a:	ff d0                	call   *%eax
  80090c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80090f:	83 ec 08             	sub    $0x8,%esp
  800912:	ff 75 0c             	pushl  0xc(%ebp)
  800915:	6a 58                	push   $0x58
  800917:	8b 45 08             	mov    0x8(%ebp),%eax
  80091a:	ff d0                	call   *%eax
  80091c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80091f:	83 ec 08             	sub    $0x8,%esp
  800922:	ff 75 0c             	pushl  0xc(%ebp)
  800925:	6a 58                	push   $0x58
  800927:	8b 45 08             	mov    0x8(%ebp),%eax
  80092a:	ff d0                	call   *%eax
  80092c:	83 c4 10             	add    $0x10,%esp
			break;
  80092f:	e9 bc 00 00 00       	jmp    8009f0 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800934:	83 ec 08             	sub    $0x8,%esp
  800937:	ff 75 0c             	pushl  0xc(%ebp)
  80093a:	6a 30                	push   $0x30
  80093c:	8b 45 08             	mov    0x8(%ebp),%eax
  80093f:	ff d0                	call   *%eax
  800941:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800944:	83 ec 08             	sub    $0x8,%esp
  800947:	ff 75 0c             	pushl  0xc(%ebp)
  80094a:	6a 78                	push   $0x78
  80094c:	8b 45 08             	mov    0x8(%ebp),%eax
  80094f:	ff d0                	call   *%eax
  800951:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800954:	8b 45 14             	mov    0x14(%ebp),%eax
  800957:	83 c0 04             	add    $0x4,%eax
  80095a:	89 45 14             	mov    %eax,0x14(%ebp)
  80095d:	8b 45 14             	mov    0x14(%ebp),%eax
  800960:	83 e8 04             	sub    $0x4,%eax
  800963:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800965:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800968:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80096f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800976:	eb 1f                	jmp    800997 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800978:	83 ec 08             	sub    $0x8,%esp
  80097b:	ff 75 e8             	pushl  -0x18(%ebp)
  80097e:	8d 45 14             	lea    0x14(%ebp),%eax
  800981:	50                   	push   %eax
  800982:	e8 e7 fb ff ff       	call   80056e <getuint>
  800987:	83 c4 10             	add    $0x10,%esp
  80098a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80098d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800990:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800997:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80099b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80099e:	83 ec 04             	sub    $0x4,%esp
  8009a1:	52                   	push   %edx
  8009a2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8009a5:	50                   	push   %eax
  8009a6:	ff 75 f4             	pushl  -0xc(%ebp)
  8009a9:	ff 75 f0             	pushl  -0x10(%ebp)
  8009ac:	ff 75 0c             	pushl  0xc(%ebp)
  8009af:	ff 75 08             	pushl  0x8(%ebp)
  8009b2:	e8 00 fb ff ff       	call   8004b7 <printnum>
  8009b7:	83 c4 20             	add    $0x20,%esp
			break;
  8009ba:	eb 34                	jmp    8009f0 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009bc:	83 ec 08             	sub    $0x8,%esp
  8009bf:	ff 75 0c             	pushl  0xc(%ebp)
  8009c2:	53                   	push   %ebx
  8009c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c6:	ff d0                	call   *%eax
  8009c8:	83 c4 10             	add    $0x10,%esp
			break;
  8009cb:	eb 23                	jmp    8009f0 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009cd:	83 ec 08             	sub    $0x8,%esp
  8009d0:	ff 75 0c             	pushl  0xc(%ebp)
  8009d3:	6a 25                	push   $0x25
  8009d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d8:	ff d0                	call   *%eax
  8009da:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009dd:	ff 4d 10             	decl   0x10(%ebp)
  8009e0:	eb 03                	jmp    8009e5 <vprintfmt+0x3b1>
  8009e2:	ff 4d 10             	decl   0x10(%ebp)
  8009e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8009e8:	48                   	dec    %eax
  8009e9:	8a 00                	mov    (%eax),%al
  8009eb:	3c 25                	cmp    $0x25,%al
  8009ed:	75 f3                	jne    8009e2 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8009ef:	90                   	nop
		}
	}
  8009f0:	e9 47 fc ff ff       	jmp    80063c <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8009f5:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8009f6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8009f9:	5b                   	pop    %ebx
  8009fa:	5e                   	pop    %esi
  8009fb:	5d                   	pop    %ebp
  8009fc:	c3                   	ret    

008009fd <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8009fd:	55                   	push   %ebp
  8009fe:	89 e5                	mov    %esp,%ebp
  800a00:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800a03:	8d 45 10             	lea    0x10(%ebp),%eax
  800a06:	83 c0 04             	add    $0x4,%eax
  800a09:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800a0c:	8b 45 10             	mov    0x10(%ebp),%eax
  800a0f:	ff 75 f4             	pushl  -0xc(%ebp)
  800a12:	50                   	push   %eax
  800a13:	ff 75 0c             	pushl  0xc(%ebp)
  800a16:	ff 75 08             	pushl  0x8(%ebp)
  800a19:	e8 16 fc ff ff       	call   800634 <vprintfmt>
  800a1e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800a21:	90                   	nop
  800a22:	c9                   	leave  
  800a23:	c3                   	ret    

00800a24 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a24:	55                   	push   %ebp
  800a25:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800a27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a2a:	8b 40 08             	mov    0x8(%eax),%eax
  800a2d:	8d 50 01             	lea    0x1(%eax),%edx
  800a30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a33:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800a36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a39:	8b 10                	mov    (%eax),%edx
  800a3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a3e:	8b 40 04             	mov    0x4(%eax),%eax
  800a41:	39 c2                	cmp    %eax,%edx
  800a43:	73 12                	jae    800a57 <sprintputch+0x33>
		*b->buf++ = ch;
  800a45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a48:	8b 00                	mov    (%eax),%eax
  800a4a:	8d 48 01             	lea    0x1(%eax),%ecx
  800a4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a50:	89 0a                	mov    %ecx,(%edx)
  800a52:	8b 55 08             	mov    0x8(%ebp),%edx
  800a55:	88 10                	mov    %dl,(%eax)
}
  800a57:	90                   	nop
  800a58:	5d                   	pop    %ebp
  800a59:	c3                   	ret    

00800a5a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a5a:	55                   	push   %ebp
  800a5b:	89 e5                	mov    %esp,%ebp
  800a5d:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a60:	8b 45 08             	mov    0x8(%ebp),%eax
  800a63:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a69:	8d 50 ff             	lea    -0x1(%eax),%edx
  800a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6f:	01 d0                	add    %edx,%eax
  800a71:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a74:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a7b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a7f:	74 06                	je     800a87 <vsnprintf+0x2d>
  800a81:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a85:	7f 07                	jg     800a8e <vsnprintf+0x34>
		return -E_INVAL;
  800a87:	b8 03 00 00 00       	mov    $0x3,%eax
  800a8c:	eb 20                	jmp    800aae <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a8e:	ff 75 14             	pushl  0x14(%ebp)
  800a91:	ff 75 10             	pushl  0x10(%ebp)
  800a94:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a97:	50                   	push   %eax
  800a98:	68 24 0a 80 00       	push   $0x800a24
  800a9d:	e8 92 fb ff ff       	call   800634 <vprintfmt>
  800aa2:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800aa5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800aa8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800aab:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800aae:	c9                   	leave  
  800aaf:	c3                   	ret    

00800ab0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ab0:	55                   	push   %ebp
  800ab1:	89 e5                	mov    %esp,%ebp
  800ab3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ab6:	8d 45 10             	lea    0x10(%ebp),%eax
  800ab9:	83 c0 04             	add    $0x4,%eax
  800abc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800abf:	8b 45 10             	mov    0x10(%ebp),%eax
  800ac2:	ff 75 f4             	pushl  -0xc(%ebp)
  800ac5:	50                   	push   %eax
  800ac6:	ff 75 0c             	pushl  0xc(%ebp)
  800ac9:	ff 75 08             	pushl  0x8(%ebp)
  800acc:	e8 89 ff ff ff       	call   800a5a <vsnprintf>
  800ad1:	83 c4 10             	add    $0x10,%esp
  800ad4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ad7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ada:	c9                   	leave  
  800adb:	c3                   	ret    

00800adc <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800adc:	55                   	push   %ebp
  800add:	89 e5                	mov    %esp,%ebp
  800adf:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ae2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ae9:	eb 06                	jmp    800af1 <strlen+0x15>
		n++;
  800aeb:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800aee:	ff 45 08             	incl   0x8(%ebp)
  800af1:	8b 45 08             	mov    0x8(%ebp),%eax
  800af4:	8a 00                	mov    (%eax),%al
  800af6:	84 c0                	test   %al,%al
  800af8:	75 f1                	jne    800aeb <strlen+0xf>
		n++;
	return n;
  800afa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800afd:	c9                   	leave  
  800afe:	c3                   	ret    

00800aff <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800aff:	55                   	push   %ebp
  800b00:	89 e5                	mov    %esp,%ebp
  800b02:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b05:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b0c:	eb 09                	jmp    800b17 <strnlen+0x18>
		n++;
  800b0e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b11:	ff 45 08             	incl   0x8(%ebp)
  800b14:	ff 4d 0c             	decl   0xc(%ebp)
  800b17:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b1b:	74 09                	je     800b26 <strnlen+0x27>
  800b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b20:	8a 00                	mov    (%eax),%al
  800b22:	84 c0                	test   %al,%al
  800b24:	75 e8                	jne    800b0e <strnlen+0xf>
		n++;
	return n;
  800b26:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b29:	c9                   	leave  
  800b2a:	c3                   	ret    

00800b2b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b2b:	55                   	push   %ebp
  800b2c:	89 e5                	mov    %esp,%ebp
  800b2e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800b31:	8b 45 08             	mov    0x8(%ebp),%eax
  800b34:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800b37:	90                   	nop
  800b38:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3b:	8d 50 01             	lea    0x1(%eax),%edx
  800b3e:	89 55 08             	mov    %edx,0x8(%ebp)
  800b41:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b44:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b47:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b4a:	8a 12                	mov    (%edx),%dl
  800b4c:	88 10                	mov    %dl,(%eax)
  800b4e:	8a 00                	mov    (%eax),%al
  800b50:	84 c0                	test   %al,%al
  800b52:	75 e4                	jne    800b38 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800b54:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b57:	c9                   	leave  
  800b58:	c3                   	ret    

00800b59 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800b59:	55                   	push   %ebp
  800b5a:	89 e5                	mov    %esp,%ebp
  800b5c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b62:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800b65:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b6c:	eb 1f                	jmp    800b8d <strncpy+0x34>
		*dst++ = *src;
  800b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b71:	8d 50 01             	lea    0x1(%eax),%edx
  800b74:	89 55 08             	mov    %edx,0x8(%ebp)
  800b77:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b7a:	8a 12                	mov    (%edx),%dl
  800b7c:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800b7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b81:	8a 00                	mov    (%eax),%al
  800b83:	84 c0                	test   %al,%al
  800b85:	74 03                	je     800b8a <strncpy+0x31>
			src++;
  800b87:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b8a:	ff 45 fc             	incl   -0x4(%ebp)
  800b8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b90:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b93:	72 d9                	jb     800b6e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800b95:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800b98:	c9                   	leave  
  800b99:	c3                   	ret    

00800b9a <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800b9a:	55                   	push   %ebp
  800b9b:	89 e5                	mov    %esp,%ebp
  800b9d:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ba6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800baa:	74 30                	je     800bdc <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800bac:	eb 16                	jmp    800bc4 <strlcpy+0x2a>
			*dst++ = *src++;
  800bae:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb1:	8d 50 01             	lea    0x1(%eax),%edx
  800bb4:	89 55 08             	mov    %edx,0x8(%ebp)
  800bb7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bba:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bbd:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bc0:	8a 12                	mov    (%edx),%dl
  800bc2:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800bc4:	ff 4d 10             	decl   0x10(%ebp)
  800bc7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bcb:	74 09                	je     800bd6 <strlcpy+0x3c>
  800bcd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd0:	8a 00                	mov    (%eax),%al
  800bd2:	84 c0                	test   %al,%al
  800bd4:	75 d8                	jne    800bae <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd9:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800bdc:	8b 55 08             	mov    0x8(%ebp),%edx
  800bdf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800be2:	29 c2                	sub    %eax,%edx
  800be4:	89 d0                	mov    %edx,%eax
}
  800be6:	c9                   	leave  
  800be7:	c3                   	ret    

00800be8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800be8:	55                   	push   %ebp
  800be9:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800beb:	eb 06                	jmp    800bf3 <strcmp+0xb>
		p++, q++;
  800bed:	ff 45 08             	incl   0x8(%ebp)
  800bf0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf6:	8a 00                	mov    (%eax),%al
  800bf8:	84 c0                	test   %al,%al
  800bfa:	74 0e                	je     800c0a <strcmp+0x22>
  800bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bff:	8a 10                	mov    (%eax),%dl
  800c01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c04:	8a 00                	mov    (%eax),%al
  800c06:	38 c2                	cmp    %al,%dl
  800c08:	74 e3                	je     800bed <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0d:	8a 00                	mov    (%eax),%al
  800c0f:	0f b6 d0             	movzbl %al,%edx
  800c12:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c15:	8a 00                	mov    (%eax),%al
  800c17:	0f b6 c0             	movzbl %al,%eax
  800c1a:	29 c2                	sub    %eax,%edx
  800c1c:	89 d0                	mov    %edx,%eax
}
  800c1e:	5d                   	pop    %ebp
  800c1f:	c3                   	ret    

00800c20 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800c20:	55                   	push   %ebp
  800c21:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800c23:	eb 09                	jmp    800c2e <strncmp+0xe>
		n--, p++, q++;
  800c25:	ff 4d 10             	decl   0x10(%ebp)
  800c28:	ff 45 08             	incl   0x8(%ebp)
  800c2b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800c2e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c32:	74 17                	je     800c4b <strncmp+0x2b>
  800c34:	8b 45 08             	mov    0x8(%ebp),%eax
  800c37:	8a 00                	mov    (%eax),%al
  800c39:	84 c0                	test   %al,%al
  800c3b:	74 0e                	je     800c4b <strncmp+0x2b>
  800c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c40:	8a 10                	mov    (%eax),%dl
  800c42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c45:	8a 00                	mov    (%eax),%al
  800c47:	38 c2                	cmp    %al,%dl
  800c49:	74 da                	je     800c25 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800c4b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c4f:	75 07                	jne    800c58 <strncmp+0x38>
		return 0;
  800c51:	b8 00 00 00 00       	mov    $0x0,%eax
  800c56:	eb 14                	jmp    800c6c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c58:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5b:	8a 00                	mov    (%eax),%al
  800c5d:	0f b6 d0             	movzbl %al,%edx
  800c60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c63:	8a 00                	mov    (%eax),%al
  800c65:	0f b6 c0             	movzbl %al,%eax
  800c68:	29 c2                	sub    %eax,%edx
  800c6a:	89 d0                	mov    %edx,%eax
}
  800c6c:	5d                   	pop    %ebp
  800c6d:	c3                   	ret    

00800c6e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c6e:	55                   	push   %ebp
  800c6f:	89 e5                	mov    %esp,%ebp
  800c71:	83 ec 04             	sub    $0x4,%esp
  800c74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c77:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c7a:	eb 12                	jmp    800c8e <strchr+0x20>
		if (*s == c)
  800c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7f:	8a 00                	mov    (%eax),%al
  800c81:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c84:	75 05                	jne    800c8b <strchr+0x1d>
			return (char *) s;
  800c86:	8b 45 08             	mov    0x8(%ebp),%eax
  800c89:	eb 11                	jmp    800c9c <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800c8b:	ff 45 08             	incl   0x8(%ebp)
  800c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c91:	8a 00                	mov    (%eax),%al
  800c93:	84 c0                	test   %al,%al
  800c95:	75 e5                	jne    800c7c <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800c97:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c9c:	c9                   	leave  
  800c9d:	c3                   	ret    

00800c9e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c9e:	55                   	push   %ebp
  800c9f:	89 e5                	mov    %esp,%ebp
  800ca1:	83 ec 04             	sub    $0x4,%esp
  800ca4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800caa:	eb 0d                	jmp    800cb9 <strfind+0x1b>
		if (*s == c)
  800cac:	8b 45 08             	mov    0x8(%ebp),%eax
  800caf:	8a 00                	mov    (%eax),%al
  800cb1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800cb4:	74 0e                	je     800cc4 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800cb6:	ff 45 08             	incl   0x8(%ebp)
  800cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbc:	8a 00                	mov    (%eax),%al
  800cbe:	84 c0                	test   %al,%al
  800cc0:	75 ea                	jne    800cac <strfind+0xe>
  800cc2:	eb 01                	jmp    800cc5 <strfind+0x27>
		if (*s == c)
			break;
  800cc4:	90                   	nop
	return (char *) s;
  800cc5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cc8:	c9                   	leave  
  800cc9:	c3                   	ret    

00800cca <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800cca:	55                   	push   %ebp
  800ccb:	89 e5                	mov    %esp,%ebp
  800ccd:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800cd6:	8b 45 10             	mov    0x10(%ebp),%eax
  800cd9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800cdc:	eb 0e                	jmp    800cec <memset+0x22>
		*p++ = c;
  800cde:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ce1:	8d 50 01             	lea    0x1(%eax),%edx
  800ce4:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ce7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cea:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800cec:	ff 4d f8             	decl   -0x8(%ebp)
  800cef:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800cf3:	79 e9                	jns    800cde <memset+0x14>
		*p++ = c;

	return v;
  800cf5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cf8:	c9                   	leave  
  800cf9:	c3                   	ret    

00800cfa <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800cfa:	55                   	push   %ebp
  800cfb:	89 e5                	mov    %esp,%ebp
  800cfd:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d03:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d06:	8b 45 08             	mov    0x8(%ebp),%eax
  800d09:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800d0c:	eb 16                	jmp    800d24 <memcpy+0x2a>
		*d++ = *s++;
  800d0e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d11:	8d 50 01             	lea    0x1(%eax),%edx
  800d14:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d17:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d1a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d1d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d20:	8a 12                	mov    (%edx),%dl
  800d22:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800d24:	8b 45 10             	mov    0x10(%ebp),%eax
  800d27:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d2a:	89 55 10             	mov    %edx,0x10(%ebp)
  800d2d:	85 c0                	test   %eax,%eax
  800d2f:	75 dd                	jne    800d0e <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800d31:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d34:	c9                   	leave  
  800d35:	c3                   	ret    

00800d36 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800d36:	55                   	push   %ebp
  800d37:	89 e5                	mov    %esp,%ebp
  800d39:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d42:	8b 45 08             	mov    0x8(%ebp),%eax
  800d45:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800d48:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d4b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d4e:	73 50                	jae    800da0 <memmove+0x6a>
  800d50:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d53:	8b 45 10             	mov    0x10(%ebp),%eax
  800d56:	01 d0                	add    %edx,%eax
  800d58:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d5b:	76 43                	jbe    800da0 <memmove+0x6a>
		s += n;
  800d5d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d60:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800d63:	8b 45 10             	mov    0x10(%ebp),%eax
  800d66:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d69:	eb 10                	jmp    800d7b <memmove+0x45>
			*--d = *--s;
  800d6b:	ff 4d f8             	decl   -0x8(%ebp)
  800d6e:	ff 4d fc             	decl   -0x4(%ebp)
  800d71:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d74:	8a 10                	mov    (%eax),%dl
  800d76:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d79:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800d7b:	8b 45 10             	mov    0x10(%ebp),%eax
  800d7e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d81:	89 55 10             	mov    %edx,0x10(%ebp)
  800d84:	85 c0                	test   %eax,%eax
  800d86:	75 e3                	jne    800d6b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d88:	eb 23                	jmp    800dad <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800d8a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d8d:	8d 50 01             	lea    0x1(%eax),%edx
  800d90:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d93:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d96:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d99:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d9c:	8a 12                	mov    (%edx),%dl
  800d9e:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800da0:	8b 45 10             	mov    0x10(%ebp),%eax
  800da3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800da6:	89 55 10             	mov    %edx,0x10(%ebp)
  800da9:	85 c0                	test   %eax,%eax
  800dab:	75 dd                	jne    800d8a <memmove+0x54>
			*d++ = *s++;

	return dst;
  800dad:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800db0:	c9                   	leave  
  800db1:	c3                   	ret    

00800db2 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800db2:	55                   	push   %ebp
  800db3:	89 e5                	mov    %esp,%ebp
  800db5:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800db8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800dbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc1:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800dc4:	eb 2a                	jmp    800df0 <memcmp+0x3e>
		if (*s1 != *s2)
  800dc6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dc9:	8a 10                	mov    (%eax),%dl
  800dcb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dce:	8a 00                	mov    (%eax),%al
  800dd0:	38 c2                	cmp    %al,%dl
  800dd2:	74 16                	je     800dea <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800dd4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dd7:	8a 00                	mov    (%eax),%al
  800dd9:	0f b6 d0             	movzbl %al,%edx
  800ddc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ddf:	8a 00                	mov    (%eax),%al
  800de1:	0f b6 c0             	movzbl %al,%eax
  800de4:	29 c2                	sub    %eax,%edx
  800de6:	89 d0                	mov    %edx,%eax
  800de8:	eb 18                	jmp    800e02 <memcmp+0x50>
		s1++, s2++;
  800dea:	ff 45 fc             	incl   -0x4(%ebp)
  800ded:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800df0:	8b 45 10             	mov    0x10(%ebp),%eax
  800df3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800df6:	89 55 10             	mov    %edx,0x10(%ebp)
  800df9:	85 c0                	test   %eax,%eax
  800dfb:	75 c9                	jne    800dc6 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800dfd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e02:	c9                   	leave  
  800e03:	c3                   	ret    

00800e04 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e04:	55                   	push   %ebp
  800e05:	89 e5                	mov    %esp,%ebp
  800e07:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e0a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e10:	01 d0                	add    %edx,%eax
  800e12:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e15:	eb 15                	jmp    800e2c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e17:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1a:	8a 00                	mov    (%eax),%al
  800e1c:	0f b6 d0             	movzbl %al,%edx
  800e1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e22:	0f b6 c0             	movzbl %al,%eax
  800e25:	39 c2                	cmp    %eax,%edx
  800e27:	74 0d                	je     800e36 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e29:	ff 45 08             	incl   0x8(%ebp)
  800e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800e32:	72 e3                	jb     800e17 <memfind+0x13>
  800e34:	eb 01                	jmp    800e37 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800e36:	90                   	nop
	return (void *) s;
  800e37:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e3a:	c9                   	leave  
  800e3b:	c3                   	ret    

00800e3c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e3c:	55                   	push   %ebp
  800e3d:	89 e5                	mov    %esp,%ebp
  800e3f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800e42:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800e49:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e50:	eb 03                	jmp    800e55 <strtol+0x19>
		s++;
  800e52:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e55:	8b 45 08             	mov    0x8(%ebp),%eax
  800e58:	8a 00                	mov    (%eax),%al
  800e5a:	3c 20                	cmp    $0x20,%al
  800e5c:	74 f4                	je     800e52 <strtol+0x16>
  800e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e61:	8a 00                	mov    (%eax),%al
  800e63:	3c 09                	cmp    $0x9,%al
  800e65:	74 eb                	je     800e52 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e67:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6a:	8a 00                	mov    (%eax),%al
  800e6c:	3c 2b                	cmp    $0x2b,%al
  800e6e:	75 05                	jne    800e75 <strtol+0x39>
		s++;
  800e70:	ff 45 08             	incl   0x8(%ebp)
  800e73:	eb 13                	jmp    800e88 <strtol+0x4c>
	else if (*s == '-')
  800e75:	8b 45 08             	mov    0x8(%ebp),%eax
  800e78:	8a 00                	mov    (%eax),%al
  800e7a:	3c 2d                	cmp    $0x2d,%al
  800e7c:	75 0a                	jne    800e88 <strtol+0x4c>
		s++, neg = 1;
  800e7e:	ff 45 08             	incl   0x8(%ebp)
  800e81:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e88:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e8c:	74 06                	je     800e94 <strtol+0x58>
  800e8e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800e92:	75 20                	jne    800eb4 <strtol+0x78>
  800e94:	8b 45 08             	mov    0x8(%ebp),%eax
  800e97:	8a 00                	mov    (%eax),%al
  800e99:	3c 30                	cmp    $0x30,%al
  800e9b:	75 17                	jne    800eb4 <strtol+0x78>
  800e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea0:	40                   	inc    %eax
  800ea1:	8a 00                	mov    (%eax),%al
  800ea3:	3c 78                	cmp    $0x78,%al
  800ea5:	75 0d                	jne    800eb4 <strtol+0x78>
		s += 2, base = 16;
  800ea7:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800eab:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800eb2:	eb 28                	jmp    800edc <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800eb4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eb8:	75 15                	jne    800ecf <strtol+0x93>
  800eba:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebd:	8a 00                	mov    (%eax),%al
  800ebf:	3c 30                	cmp    $0x30,%al
  800ec1:	75 0c                	jne    800ecf <strtol+0x93>
		s++, base = 8;
  800ec3:	ff 45 08             	incl   0x8(%ebp)
  800ec6:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800ecd:	eb 0d                	jmp    800edc <strtol+0xa0>
	else if (base == 0)
  800ecf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ed3:	75 07                	jne    800edc <strtol+0xa0>
		base = 10;
  800ed5:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800edc:	8b 45 08             	mov    0x8(%ebp),%eax
  800edf:	8a 00                	mov    (%eax),%al
  800ee1:	3c 2f                	cmp    $0x2f,%al
  800ee3:	7e 19                	jle    800efe <strtol+0xc2>
  800ee5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee8:	8a 00                	mov    (%eax),%al
  800eea:	3c 39                	cmp    $0x39,%al
  800eec:	7f 10                	jg     800efe <strtol+0xc2>
			dig = *s - '0';
  800eee:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef1:	8a 00                	mov    (%eax),%al
  800ef3:	0f be c0             	movsbl %al,%eax
  800ef6:	83 e8 30             	sub    $0x30,%eax
  800ef9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800efc:	eb 42                	jmp    800f40 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800efe:	8b 45 08             	mov    0x8(%ebp),%eax
  800f01:	8a 00                	mov    (%eax),%al
  800f03:	3c 60                	cmp    $0x60,%al
  800f05:	7e 19                	jle    800f20 <strtol+0xe4>
  800f07:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0a:	8a 00                	mov    (%eax),%al
  800f0c:	3c 7a                	cmp    $0x7a,%al
  800f0e:	7f 10                	jg     800f20 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f10:	8b 45 08             	mov    0x8(%ebp),%eax
  800f13:	8a 00                	mov    (%eax),%al
  800f15:	0f be c0             	movsbl %al,%eax
  800f18:	83 e8 57             	sub    $0x57,%eax
  800f1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f1e:	eb 20                	jmp    800f40 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800f20:	8b 45 08             	mov    0x8(%ebp),%eax
  800f23:	8a 00                	mov    (%eax),%al
  800f25:	3c 40                	cmp    $0x40,%al
  800f27:	7e 39                	jle    800f62 <strtol+0x126>
  800f29:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2c:	8a 00                	mov    (%eax),%al
  800f2e:	3c 5a                	cmp    $0x5a,%al
  800f30:	7f 30                	jg     800f62 <strtol+0x126>
			dig = *s - 'A' + 10;
  800f32:	8b 45 08             	mov    0x8(%ebp),%eax
  800f35:	8a 00                	mov    (%eax),%al
  800f37:	0f be c0             	movsbl %al,%eax
  800f3a:	83 e8 37             	sub    $0x37,%eax
  800f3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800f40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f43:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f46:	7d 19                	jge    800f61 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800f48:	ff 45 08             	incl   0x8(%ebp)
  800f4b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f4e:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f52:	89 c2                	mov    %eax,%edx
  800f54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f57:	01 d0                	add    %edx,%eax
  800f59:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800f5c:	e9 7b ff ff ff       	jmp    800edc <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800f61:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f62:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f66:	74 08                	je     800f70 <strtol+0x134>
		*endptr = (char *) s;
  800f68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f6e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800f70:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f74:	74 07                	je     800f7d <strtol+0x141>
  800f76:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f79:	f7 d8                	neg    %eax
  800f7b:	eb 03                	jmp    800f80 <strtol+0x144>
  800f7d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f80:	c9                   	leave  
  800f81:	c3                   	ret    

00800f82 <ltostr>:

void
ltostr(long value, char *str)
{
  800f82:	55                   	push   %ebp
  800f83:	89 e5                	mov    %esp,%ebp
  800f85:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800f88:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800f8f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800f96:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f9a:	79 13                	jns    800faf <ltostr+0x2d>
	{
		neg = 1;
  800f9c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800fa3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa6:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800fa9:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800fac:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800faf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb2:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800fb7:	99                   	cltd   
  800fb8:	f7 f9                	idiv   %ecx
  800fba:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800fbd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc0:	8d 50 01             	lea    0x1(%eax),%edx
  800fc3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fc6:	89 c2                	mov    %eax,%edx
  800fc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fcb:	01 d0                	add    %edx,%eax
  800fcd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800fd0:	83 c2 30             	add    $0x30,%edx
  800fd3:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800fd5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fd8:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800fdd:	f7 e9                	imul   %ecx
  800fdf:	c1 fa 02             	sar    $0x2,%edx
  800fe2:	89 c8                	mov    %ecx,%eax
  800fe4:	c1 f8 1f             	sar    $0x1f,%eax
  800fe7:	29 c2                	sub    %eax,%edx
  800fe9:	89 d0                	mov    %edx,%eax
  800feb:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800fee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ff1:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800ff6:	f7 e9                	imul   %ecx
  800ff8:	c1 fa 02             	sar    $0x2,%edx
  800ffb:	89 c8                	mov    %ecx,%eax
  800ffd:	c1 f8 1f             	sar    $0x1f,%eax
  801000:	29 c2                	sub    %eax,%edx
  801002:	89 d0                	mov    %edx,%eax
  801004:	c1 e0 02             	shl    $0x2,%eax
  801007:	01 d0                	add    %edx,%eax
  801009:	01 c0                	add    %eax,%eax
  80100b:	29 c1                	sub    %eax,%ecx
  80100d:	89 ca                	mov    %ecx,%edx
  80100f:	85 d2                	test   %edx,%edx
  801011:	75 9c                	jne    800faf <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801013:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80101a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101d:	48                   	dec    %eax
  80101e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801021:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801025:	74 3d                	je     801064 <ltostr+0xe2>
		start = 1 ;
  801027:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80102e:	eb 34                	jmp    801064 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801030:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801033:	8b 45 0c             	mov    0xc(%ebp),%eax
  801036:	01 d0                	add    %edx,%eax
  801038:	8a 00                	mov    (%eax),%al
  80103a:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80103d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801040:	8b 45 0c             	mov    0xc(%ebp),%eax
  801043:	01 c2                	add    %eax,%edx
  801045:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801048:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104b:	01 c8                	add    %ecx,%eax
  80104d:	8a 00                	mov    (%eax),%al
  80104f:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801051:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801054:	8b 45 0c             	mov    0xc(%ebp),%eax
  801057:	01 c2                	add    %eax,%edx
  801059:	8a 45 eb             	mov    -0x15(%ebp),%al
  80105c:	88 02                	mov    %al,(%edx)
		start++ ;
  80105e:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801061:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801064:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801067:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80106a:	7c c4                	jl     801030 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80106c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80106f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801072:	01 d0                	add    %edx,%eax
  801074:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801077:	90                   	nop
  801078:	c9                   	leave  
  801079:	c3                   	ret    

0080107a <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80107a:	55                   	push   %ebp
  80107b:	89 e5                	mov    %esp,%ebp
  80107d:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801080:	ff 75 08             	pushl  0x8(%ebp)
  801083:	e8 54 fa ff ff       	call   800adc <strlen>
  801088:	83 c4 04             	add    $0x4,%esp
  80108b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80108e:	ff 75 0c             	pushl  0xc(%ebp)
  801091:	e8 46 fa ff ff       	call   800adc <strlen>
  801096:	83 c4 04             	add    $0x4,%esp
  801099:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80109c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8010a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010aa:	eb 17                	jmp    8010c3 <strcconcat+0x49>
		final[s] = str1[s] ;
  8010ac:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010af:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b2:	01 c2                	add    %eax,%edx
  8010b4:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8010b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ba:	01 c8                	add    %ecx,%eax
  8010bc:	8a 00                	mov    (%eax),%al
  8010be:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8010c0:	ff 45 fc             	incl   -0x4(%ebp)
  8010c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010c6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010c9:	7c e1                	jl     8010ac <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8010cb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8010d2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8010d9:	eb 1f                	jmp    8010fa <strcconcat+0x80>
		final[s++] = str2[i] ;
  8010db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010de:	8d 50 01             	lea    0x1(%eax),%edx
  8010e1:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010e4:	89 c2                	mov    %eax,%edx
  8010e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e9:	01 c2                	add    %eax,%edx
  8010eb:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f1:	01 c8                	add    %ecx,%eax
  8010f3:	8a 00                	mov    (%eax),%al
  8010f5:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8010f7:	ff 45 f8             	incl   -0x8(%ebp)
  8010fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010fd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801100:	7c d9                	jl     8010db <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801102:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801105:	8b 45 10             	mov    0x10(%ebp),%eax
  801108:	01 d0                	add    %edx,%eax
  80110a:	c6 00 00             	movb   $0x0,(%eax)
}
  80110d:	90                   	nop
  80110e:	c9                   	leave  
  80110f:	c3                   	ret    

00801110 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801110:	55                   	push   %ebp
  801111:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801113:	8b 45 14             	mov    0x14(%ebp),%eax
  801116:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80111c:	8b 45 14             	mov    0x14(%ebp),%eax
  80111f:	8b 00                	mov    (%eax),%eax
  801121:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801128:	8b 45 10             	mov    0x10(%ebp),%eax
  80112b:	01 d0                	add    %edx,%eax
  80112d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801133:	eb 0c                	jmp    801141 <strsplit+0x31>
			*string++ = 0;
  801135:	8b 45 08             	mov    0x8(%ebp),%eax
  801138:	8d 50 01             	lea    0x1(%eax),%edx
  80113b:	89 55 08             	mov    %edx,0x8(%ebp)
  80113e:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801141:	8b 45 08             	mov    0x8(%ebp),%eax
  801144:	8a 00                	mov    (%eax),%al
  801146:	84 c0                	test   %al,%al
  801148:	74 18                	je     801162 <strsplit+0x52>
  80114a:	8b 45 08             	mov    0x8(%ebp),%eax
  80114d:	8a 00                	mov    (%eax),%al
  80114f:	0f be c0             	movsbl %al,%eax
  801152:	50                   	push   %eax
  801153:	ff 75 0c             	pushl  0xc(%ebp)
  801156:	e8 13 fb ff ff       	call   800c6e <strchr>
  80115b:	83 c4 08             	add    $0x8,%esp
  80115e:	85 c0                	test   %eax,%eax
  801160:	75 d3                	jne    801135 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801162:	8b 45 08             	mov    0x8(%ebp),%eax
  801165:	8a 00                	mov    (%eax),%al
  801167:	84 c0                	test   %al,%al
  801169:	74 5a                	je     8011c5 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80116b:	8b 45 14             	mov    0x14(%ebp),%eax
  80116e:	8b 00                	mov    (%eax),%eax
  801170:	83 f8 0f             	cmp    $0xf,%eax
  801173:	75 07                	jne    80117c <strsplit+0x6c>
		{
			return 0;
  801175:	b8 00 00 00 00       	mov    $0x0,%eax
  80117a:	eb 66                	jmp    8011e2 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80117c:	8b 45 14             	mov    0x14(%ebp),%eax
  80117f:	8b 00                	mov    (%eax),%eax
  801181:	8d 48 01             	lea    0x1(%eax),%ecx
  801184:	8b 55 14             	mov    0x14(%ebp),%edx
  801187:	89 0a                	mov    %ecx,(%edx)
  801189:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801190:	8b 45 10             	mov    0x10(%ebp),%eax
  801193:	01 c2                	add    %eax,%edx
  801195:	8b 45 08             	mov    0x8(%ebp),%eax
  801198:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80119a:	eb 03                	jmp    80119f <strsplit+0x8f>
			string++;
  80119c:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80119f:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a2:	8a 00                	mov    (%eax),%al
  8011a4:	84 c0                	test   %al,%al
  8011a6:	74 8b                	je     801133 <strsplit+0x23>
  8011a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ab:	8a 00                	mov    (%eax),%al
  8011ad:	0f be c0             	movsbl %al,%eax
  8011b0:	50                   	push   %eax
  8011b1:	ff 75 0c             	pushl  0xc(%ebp)
  8011b4:	e8 b5 fa ff ff       	call   800c6e <strchr>
  8011b9:	83 c4 08             	add    $0x8,%esp
  8011bc:	85 c0                	test   %eax,%eax
  8011be:	74 dc                	je     80119c <strsplit+0x8c>
			string++;
	}
  8011c0:	e9 6e ff ff ff       	jmp    801133 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8011c5:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8011c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8011c9:	8b 00                	mov    (%eax),%eax
  8011cb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d5:	01 d0                	add    %edx,%eax
  8011d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8011dd:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8011e2:	c9                   	leave  
  8011e3:	c3                   	ret    

008011e4 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8011e4:	55                   	push   %ebp
  8011e5:	89 e5                	mov    %esp,%ebp
  8011e7:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8011ea:	a1 04 40 80 00       	mov    0x804004,%eax
  8011ef:	85 c0                	test   %eax,%eax
  8011f1:	74 1f                	je     801212 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8011f3:	e8 1d 00 00 00       	call   801215 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8011f8:	83 ec 0c             	sub    $0xc,%esp
  8011fb:	68 d0 37 80 00       	push   $0x8037d0
  801200:	e8 55 f2 ff ff       	call   80045a <cprintf>
  801205:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801208:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  80120f:	00 00 00 
	}
}
  801212:	90                   	nop
  801213:	c9                   	leave  
  801214:	c3                   	ret    

00801215 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801215:	55                   	push   %ebp
  801216:	89 e5                	mov    %esp,%ebp
  801218:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  80121b:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801222:	00 00 00 
  801225:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80122c:	00 00 00 
  80122f:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801236:	00 00 00 
		LIST_INIT(&AllocMemBlocksList);
  801239:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801240:	00 00 00 
  801243:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80124a:	00 00 00 
  80124d:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801254:	00 00 00 

		MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES ;
  801257:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  80125e:	00 02 00 
		MemBlockNodes =(struct MemBlock*)USER_DYN_BLKS_ARRAY ;
  801261:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801268:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80126b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801270:	2d 00 10 00 00       	sub    $0x1000,%eax
  801275:	a3 50 40 80 00       	mov    %eax,0x804050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock),PAGE_SIZE),PERM_USER|PERM_WRITEABLE);
  80127a:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801281:	a1 20 41 80 00       	mov    0x804120,%eax
  801286:	c1 e0 04             	shl    $0x4,%eax
  801289:	89 c2                	mov    %eax,%edx
  80128b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80128e:	01 d0                	add    %edx,%eax
  801290:	48                   	dec    %eax
  801291:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801294:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801297:	ba 00 00 00 00       	mov    $0x0,%edx
  80129c:	f7 75 f0             	divl   -0x10(%ebp)
  80129f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8012a2:	29 d0                	sub    %edx,%eax
  8012a4:	89 c2                	mov    %eax,%edx
  8012a6:	c7 45 e8 00 00 e0 7f 	movl   $0x7fe00000,-0x18(%ebp)
  8012ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8012b0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8012b5:	2d 00 10 00 00       	sub    $0x1000,%eax
  8012ba:	83 ec 04             	sub    $0x4,%esp
  8012bd:	6a 06                	push   $0x6
  8012bf:	52                   	push   %edx
  8012c0:	50                   	push   %eax
  8012c1:	e8 71 05 00 00       	call   801837 <sys_allocate_chunk>
  8012c6:	83 c4 10             	add    $0x10,%esp
		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8012c9:	a1 20 41 80 00       	mov    0x804120,%eax
  8012ce:	83 ec 0c             	sub    $0xc,%esp
  8012d1:	50                   	push   %eax
  8012d2:	e8 e6 0b 00 00       	call   801ebd <initialize_MemBlocksList>
  8012d7:	83 c4 10             	add    $0x10,%esp

		struct MemBlock  *block_node;
		block_node = AvailableMemBlocksList.lh_first;
  8012da:	a1 48 41 80 00       	mov    0x804148,%eax
  8012df:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&(AvailableMemBlocksList),block_node);
  8012e2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8012e6:	75 14                	jne    8012fc <initialize_dyn_block_system+0xe7>
  8012e8:	83 ec 04             	sub    $0x4,%esp
  8012eb:	68 f5 37 80 00       	push   $0x8037f5
  8012f0:	6a 2b                	push   $0x2b
  8012f2:	68 13 38 80 00       	push   $0x803813
  8012f7:	e8 b2 1b 00 00       	call   802eae <_panic>
  8012fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012ff:	8b 00                	mov    (%eax),%eax
  801301:	85 c0                	test   %eax,%eax
  801303:	74 10                	je     801315 <initialize_dyn_block_system+0x100>
  801305:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801308:	8b 00                	mov    (%eax),%eax
  80130a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80130d:	8b 52 04             	mov    0x4(%edx),%edx
  801310:	89 50 04             	mov    %edx,0x4(%eax)
  801313:	eb 0b                	jmp    801320 <initialize_dyn_block_system+0x10b>
  801315:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801318:	8b 40 04             	mov    0x4(%eax),%eax
  80131b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801320:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801323:	8b 40 04             	mov    0x4(%eax),%eax
  801326:	85 c0                	test   %eax,%eax
  801328:	74 0f                	je     801339 <initialize_dyn_block_system+0x124>
  80132a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80132d:	8b 40 04             	mov    0x4(%eax),%eax
  801330:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801333:	8b 12                	mov    (%edx),%edx
  801335:	89 10                	mov    %edx,(%eax)
  801337:	eb 0a                	jmp    801343 <initialize_dyn_block_system+0x12e>
  801339:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80133c:	8b 00                	mov    (%eax),%eax
  80133e:	a3 48 41 80 00       	mov    %eax,0x804148
  801343:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801346:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80134c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80134f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801356:	a1 54 41 80 00       	mov    0x804154,%eax
  80135b:	48                   	dec    %eax
  80135c:	a3 54 41 80 00       	mov    %eax,0x804154
		block_node->sva = USER_HEAP_START ;
  801361:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801364:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
		block_node->size = ((USER_HEAP_MAX - USER_HEAP_START));
  80136b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80136e:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		insert_sorted_with_merge_freeList(block_node);
  801375:	83 ec 0c             	sub    $0xc,%esp
  801378:	ff 75 e4             	pushl  -0x1c(%ebp)
  80137b:	e8 d2 13 00 00       	call   802752 <insert_sorted_with_merge_freeList>
  801380:	83 c4 10             	add    $0x10,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801383:	90                   	nop
  801384:	c9                   	leave  
  801385:	c3                   	ret    

00801386 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801386:	55                   	push   %ebp
  801387:	89 e5                	mov    %esp,%ebp
  801389:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80138c:	e8 53 fe ff ff       	call   8011e4 <InitializeUHeap>
	if (size == 0) return NULL ;
  801391:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801395:	75 07                	jne    80139e <malloc+0x18>
  801397:	b8 00 00 00 00       	mov    $0x0,%eax
  80139c:	eb 61                	jmp    8013ff <malloc+0x79>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	size= ROUNDUP(size,PAGE_SIZE);
  80139e:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8013a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8013a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013ab:	01 d0                	add    %edx,%eax
  8013ad:	48                   	dec    %eax
  8013ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8013b9:	f7 75 f4             	divl   -0xc(%ebp)
  8013bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013bf:	29 d0                	sub    %edx,%eax
  8013c1:	89 45 08             	mov    %eax,0x8(%ebp)
	    			if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8013c4:	e8 3c 08 00 00       	call   801c05 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8013c9:	85 c0                	test   %eax,%eax
  8013cb:	74 2d                	je     8013fa <malloc+0x74>
	    			{
	    				struct MemBlock * ff_block = alloc_block_FF(size);
  8013cd:	83 ec 0c             	sub    $0xc,%esp
  8013d0:	ff 75 08             	pushl  0x8(%ebp)
  8013d3:	e8 3e 0f 00 00       	call   802316 <alloc_block_FF>
  8013d8:	83 c4 10             	add    $0x10,%esp
  8013db:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    				if(ff_block!=NULL)
  8013de:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8013e2:	74 16                	je     8013fa <malloc+0x74>
	    				{

	    					insert_sorted_allocList(ff_block);
  8013e4:	83 ec 0c             	sub    $0xc,%esp
  8013e7:	ff 75 ec             	pushl  -0x14(%ebp)
  8013ea:	e8 48 0c 00 00       	call   802037 <insert_sorted_allocList>
  8013ef:	83 c4 10             	add    $0x10,%esp
	    					return (void*) ff_block->sva ;
  8013f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013f5:	8b 40 08             	mov    0x8(%eax),%eax
  8013f8:	eb 05                	jmp    8013ff <malloc+0x79>

	    				}
	}
	    			return (void*) NULL ;
  8013fa:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  8013ff:	c9                   	leave  
  801400:	c3                   	ret    

00801401 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801401:	55                   	push   %ebp
  801402:	89 e5                	mov    %esp,%ebp
  801404:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock *elementForEach;
		virtual_address = ROUNDDOWN(virtual_address, PAGE_SIZE);
  801407:	8b 45 08             	mov    0x8(%ebp),%eax
  80140a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80140d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801410:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801415:	89 45 08             	mov    %eax,0x8(%ebp)
	//	if (is_mallocPages[indexindex((uint32) virtual_address)] == 1) {
		elementForEach = find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801418:	8b 45 08             	mov    0x8(%ebp),%eax
  80141b:	83 ec 08             	sub    $0x8,%esp
  80141e:	50                   	push   %eax
  80141f:	68 40 40 80 00       	push   $0x804040
  801424:	e8 71 0b 00 00       	call   801f9a <find_block>
  801429:	83 c4 10             	add    $0x10,%esp
  80142c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		sys_free_user_mem((uint32) virtual_address, elementForEach->size);
  80142f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801432:	8b 50 0c             	mov    0xc(%eax),%edx
  801435:	8b 45 08             	mov    0x8(%ebp),%eax
  801438:	83 ec 08             	sub    $0x8,%esp
  80143b:	52                   	push   %edx
  80143c:	50                   	push   %eax
  80143d:	e8 bd 03 00 00       	call   8017ff <sys_free_user_mem>
  801442:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,elementForEach);
  801445:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801449:	75 14                	jne    80145f <free+0x5e>
  80144b:	83 ec 04             	sub    $0x4,%esp
  80144e:	68 f5 37 80 00       	push   $0x8037f5
  801453:	6a 71                	push   $0x71
  801455:	68 13 38 80 00       	push   $0x803813
  80145a:	e8 4f 1a 00 00       	call   802eae <_panic>
  80145f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801462:	8b 00                	mov    (%eax),%eax
  801464:	85 c0                	test   %eax,%eax
  801466:	74 10                	je     801478 <free+0x77>
  801468:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80146b:	8b 00                	mov    (%eax),%eax
  80146d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801470:	8b 52 04             	mov    0x4(%edx),%edx
  801473:	89 50 04             	mov    %edx,0x4(%eax)
  801476:	eb 0b                	jmp    801483 <free+0x82>
  801478:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80147b:	8b 40 04             	mov    0x4(%eax),%eax
  80147e:	a3 44 40 80 00       	mov    %eax,0x804044
  801483:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801486:	8b 40 04             	mov    0x4(%eax),%eax
  801489:	85 c0                	test   %eax,%eax
  80148b:	74 0f                	je     80149c <free+0x9b>
  80148d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801490:	8b 40 04             	mov    0x4(%eax),%eax
  801493:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801496:	8b 12                	mov    (%edx),%edx
  801498:	89 10                	mov    %edx,(%eax)
  80149a:	eb 0a                	jmp    8014a6 <free+0xa5>
  80149c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80149f:	8b 00                	mov    (%eax),%eax
  8014a1:	a3 40 40 80 00       	mov    %eax,0x804040
  8014a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8014af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014b2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8014b9:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8014be:	48                   	dec    %eax
  8014bf:	a3 4c 40 80 00       	mov    %eax,0x80404c
		insert_sorted_with_merge_freeList(elementForEach);
  8014c4:	83 ec 0c             	sub    $0xc,%esp
  8014c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8014ca:	e8 83 12 00 00       	call   802752 <insert_sorted_with_merge_freeList>
  8014cf:	83 c4 10             	add    $0x10,%esp
	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  8014d2:	90                   	nop
  8014d3:	c9                   	leave  
  8014d4:	c3                   	ret    

008014d5 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8014d5:	55                   	push   %ebp
  8014d6:	89 e5                	mov    %esp,%ebp
  8014d8:	83 ec 28             	sub    $0x28,%esp
  8014db:	8b 45 10             	mov    0x10(%ebp),%eax
  8014de:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014e1:	e8 fe fc ff ff       	call   8011e4 <InitializeUHeap>
	if (size == 0) return NULL ;
  8014e6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014ea:	75 0a                	jne    8014f6 <smalloc+0x21>
  8014ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8014f1:	e9 86 00 00 00       	jmp    80157c <smalloc+0xa7>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code

	size=ROUNDUP(size,PAGE_SIZE);
  8014f6:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8014fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801500:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801503:	01 d0                	add    %edx,%eax
  801505:	48                   	dec    %eax
  801506:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801509:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80150c:	ba 00 00 00 00       	mov    $0x0,%edx
  801511:	f7 75 f4             	divl   -0xc(%ebp)
  801514:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801517:	29 d0                	sub    %edx,%eax
  801519:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80151c:	e8 e4 06 00 00       	call   801c05 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801521:	85 c0                	test   %eax,%eax
  801523:	74 52                	je     801577 <smalloc+0xa2>
		{
		struct MemBlock * ff_block ;
		ff_block = alloc_block_FF(size);
  801525:	83 ec 0c             	sub    $0xc,%esp
  801528:	ff 75 0c             	pushl  0xc(%ebp)
  80152b:	e8 e6 0d 00 00       	call   802316 <alloc_block_FF>
  801530:	83 c4 10             	add    $0x10,%esp
  801533:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(ff_block==NULL)
  801536:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80153a:	75 07                	jne    801543 <smalloc+0x6e>
			return NULL ;
  80153c:	b8 00 00 00 00       	mov    $0x0,%eax
  801541:	eb 39                	jmp    80157c <smalloc+0xa7>

		int obj_id =sys_createSharedObject(sharedVarName,size,isWritable,(void*)ff_block->sva);
  801543:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801546:	8b 40 08             	mov    0x8(%eax),%eax
  801549:	89 c2                	mov    %eax,%edx
  80154b:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  80154f:	52                   	push   %edx
  801550:	50                   	push   %eax
  801551:	ff 75 0c             	pushl  0xc(%ebp)
  801554:	ff 75 08             	pushl  0x8(%ebp)
  801557:	e8 2e 04 00 00       	call   80198a <sys_createSharedObject>
  80155c:	83 c4 10             	add    $0x10,%esp
  80155f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(obj_id < 0)
  801562:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801566:	79 07                	jns    80156f <smalloc+0x9a>
			return (void*)NULL ;
  801568:	b8 00 00 00 00       	mov    $0x0,%eax
  80156d:	eb 0d                	jmp    80157c <smalloc+0xa7>
		else
		    return (void*)ff_block->sva ;
  80156f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801572:	8b 40 08             	mov    0x8(%eax),%eax
  801575:	eb 05                	jmp    80157c <smalloc+0xa7>
		}
		return (void*)NULL ;
  801577:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80157c:	c9                   	leave  
  80157d:	c3                   	ret    

0080157e <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80157e:	55                   	push   %ebp
  80157f:	89 e5                	mov    %esp,%ebp
  801581:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801584:	e8 5b fc ff ff       	call   8011e4 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801589:	83 ec 08             	sub    $0x8,%esp
  80158c:	ff 75 0c             	pushl  0xc(%ebp)
  80158f:	ff 75 08             	pushl  0x8(%ebp)
  801592:	e8 1d 04 00 00       	call   8019b4 <sys_getSizeOfSharedObject>
  801597:	83 c4 10             	add    $0x10,%esp
  80159a:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(size == 0)
  80159d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8015a1:	75 0a                	jne    8015ad <sget+0x2f>
			return NULL ;
  8015a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8015a8:	e9 83 00 00 00       	jmp    801630 <sget+0xb2>
		size=ROUNDUP(size,PAGE_SIZE);
  8015ad:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8015b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ba:	01 d0                	add    %edx,%eax
  8015bc:	48                   	dec    %eax
  8015bd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8015c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8015c8:	f7 75 f0             	divl   -0x10(%ebp)
  8015cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015ce:	29 d0                	sub    %edx,%eax
  8015d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8015d3:	e8 2d 06 00 00       	call   801c05 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015d8:	85 c0                	test   %eax,%eax
  8015da:	74 4f                	je     80162b <sget+0xad>
		{
			struct MemBlock * ff_block ;
				ff_block = alloc_block_FF(size);
  8015dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015df:	83 ec 0c             	sub    $0xc,%esp
  8015e2:	50                   	push   %eax
  8015e3:	e8 2e 0d 00 00       	call   802316 <alloc_block_FF>
  8015e8:	83 c4 10             	add    $0x10,%esp
  8015eb:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ff_block==NULL)
  8015ee:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8015f2:	75 07                	jne    8015fb <sget+0x7d>
					return (void*)NULL ;
  8015f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8015f9:	eb 35                	jmp    801630 <sget+0xb2>

		int obj_id =sys_getSharedObject((int)ownerEnvID,sharedVarName,(void*)ff_block->sva);
  8015fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015fe:	8b 40 08             	mov    0x8(%eax),%eax
  801601:	83 ec 04             	sub    $0x4,%esp
  801604:	50                   	push   %eax
  801605:	ff 75 0c             	pushl  0xc(%ebp)
  801608:	ff 75 08             	pushl  0x8(%ebp)
  80160b:	e8 c1 03 00 00       	call   8019d1 <sys_getSharedObject>
  801610:	83 c4 10             	add    $0x10,%esp
  801613:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if(obj_id<0)
  801616:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80161a:	79 07                	jns    801623 <sget+0xa5>
				return (void*)NULL ;
  80161c:	b8 00 00 00 00       	mov    $0x0,%eax
  801621:	eb 0d                	jmp    801630 <sget+0xb2>
			else
				return (void*)ff_block->sva ;
  801623:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801626:	8b 40 08             	mov    0x8(%eax),%eax
  801629:	eb 05                	jmp    801630 <sget+0xb2>


		}
	return (void*)NULL ;
  80162b:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801630:	c9                   	leave  
  801631:	c3                   	ret    

00801632 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801632:	55                   	push   %ebp
  801633:	89 e5                	mov    %esp,%ebp
  801635:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801638:	e8 a7 fb ff ff       	call   8011e4 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80163d:	83 ec 04             	sub    $0x4,%esp
  801640:	68 20 38 80 00       	push   $0x803820
  801645:	68 f9 00 00 00       	push   $0xf9
  80164a:	68 13 38 80 00       	push   $0x803813
  80164f:	e8 5a 18 00 00       	call   802eae <_panic>

00801654 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801654:	55                   	push   %ebp
  801655:	89 e5                	mov    %esp,%ebp
  801657:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80165a:	83 ec 04             	sub    $0x4,%esp
  80165d:	68 48 38 80 00       	push   $0x803848
  801662:	68 0d 01 00 00       	push   $0x10d
  801667:	68 13 38 80 00       	push   $0x803813
  80166c:	e8 3d 18 00 00       	call   802eae <_panic>

00801671 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801671:	55                   	push   %ebp
  801672:	89 e5                	mov    %esp,%ebp
  801674:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801677:	83 ec 04             	sub    $0x4,%esp
  80167a:	68 6c 38 80 00       	push   $0x80386c
  80167f:	68 18 01 00 00       	push   $0x118
  801684:	68 13 38 80 00       	push   $0x803813
  801689:	e8 20 18 00 00       	call   802eae <_panic>

0080168e <shrink>:

}
void shrink(uint32 newSize)
{
  80168e:	55                   	push   %ebp
  80168f:	89 e5                	mov    %esp,%ebp
  801691:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801694:	83 ec 04             	sub    $0x4,%esp
  801697:	68 6c 38 80 00       	push   $0x80386c
  80169c:	68 1d 01 00 00       	push   $0x11d
  8016a1:	68 13 38 80 00       	push   $0x803813
  8016a6:	e8 03 18 00 00       	call   802eae <_panic>

008016ab <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8016ab:	55                   	push   %ebp
  8016ac:	89 e5                	mov    %esp,%ebp
  8016ae:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016b1:	83 ec 04             	sub    $0x4,%esp
  8016b4:	68 6c 38 80 00       	push   $0x80386c
  8016b9:	68 22 01 00 00       	push   $0x122
  8016be:	68 13 38 80 00       	push   $0x803813
  8016c3:	e8 e6 17 00 00       	call   802eae <_panic>

008016c8 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8016c8:	55                   	push   %ebp
  8016c9:	89 e5                	mov    %esp,%ebp
  8016cb:	57                   	push   %edi
  8016cc:	56                   	push   %esi
  8016cd:	53                   	push   %ebx
  8016ce:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016da:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016dd:	8b 7d 18             	mov    0x18(%ebp),%edi
  8016e0:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8016e3:	cd 30                	int    $0x30
  8016e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8016e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8016eb:	83 c4 10             	add    $0x10,%esp
  8016ee:	5b                   	pop    %ebx
  8016ef:	5e                   	pop    %esi
  8016f0:	5f                   	pop    %edi
  8016f1:	5d                   	pop    %ebp
  8016f2:	c3                   	ret    

008016f3 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8016f3:	55                   	push   %ebp
  8016f4:	89 e5                	mov    %esp,%ebp
  8016f6:	83 ec 04             	sub    $0x4,%esp
  8016f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8016fc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8016ff:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801703:	8b 45 08             	mov    0x8(%ebp),%eax
  801706:	6a 00                	push   $0x0
  801708:	6a 00                	push   $0x0
  80170a:	52                   	push   %edx
  80170b:	ff 75 0c             	pushl  0xc(%ebp)
  80170e:	50                   	push   %eax
  80170f:	6a 00                	push   $0x0
  801711:	e8 b2 ff ff ff       	call   8016c8 <syscall>
  801716:	83 c4 18             	add    $0x18,%esp
}
  801719:	90                   	nop
  80171a:	c9                   	leave  
  80171b:	c3                   	ret    

0080171c <sys_cgetc>:

int
sys_cgetc(void)
{
  80171c:	55                   	push   %ebp
  80171d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80171f:	6a 00                	push   $0x0
  801721:	6a 00                	push   $0x0
  801723:	6a 00                	push   $0x0
  801725:	6a 00                	push   $0x0
  801727:	6a 00                	push   $0x0
  801729:	6a 01                	push   $0x1
  80172b:	e8 98 ff ff ff       	call   8016c8 <syscall>
  801730:	83 c4 18             	add    $0x18,%esp
}
  801733:	c9                   	leave  
  801734:	c3                   	ret    

00801735 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801735:	55                   	push   %ebp
  801736:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801738:	8b 55 0c             	mov    0xc(%ebp),%edx
  80173b:	8b 45 08             	mov    0x8(%ebp),%eax
  80173e:	6a 00                	push   $0x0
  801740:	6a 00                	push   $0x0
  801742:	6a 00                	push   $0x0
  801744:	52                   	push   %edx
  801745:	50                   	push   %eax
  801746:	6a 05                	push   $0x5
  801748:	e8 7b ff ff ff       	call   8016c8 <syscall>
  80174d:	83 c4 18             	add    $0x18,%esp
}
  801750:	c9                   	leave  
  801751:	c3                   	ret    

00801752 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801752:	55                   	push   %ebp
  801753:	89 e5                	mov    %esp,%ebp
  801755:	56                   	push   %esi
  801756:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801757:	8b 75 18             	mov    0x18(%ebp),%esi
  80175a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80175d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801760:	8b 55 0c             	mov    0xc(%ebp),%edx
  801763:	8b 45 08             	mov    0x8(%ebp),%eax
  801766:	56                   	push   %esi
  801767:	53                   	push   %ebx
  801768:	51                   	push   %ecx
  801769:	52                   	push   %edx
  80176a:	50                   	push   %eax
  80176b:	6a 06                	push   $0x6
  80176d:	e8 56 ff ff ff       	call   8016c8 <syscall>
  801772:	83 c4 18             	add    $0x18,%esp
}
  801775:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801778:	5b                   	pop    %ebx
  801779:	5e                   	pop    %esi
  80177a:	5d                   	pop    %ebp
  80177b:	c3                   	ret    

0080177c <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80177c:	55                   	push   %ebp
  80177d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80177f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801782:	8b 45 08             	mov    0x8(%ebp),%eax
  801785:	6a 00                	push   $0x0
  801787:	6a 00                	push   $0x0
  801789:	6a 00                	push   $0x0
  80178b:	52                   	push   %edx
  80178c:	50                   	push   %eax
  80178d:	6a 07                	push   $0x7
  80178f:	e8 34 ff ff ff       	call   8016c8 <syscall>
  801794:	83 c4 18             	add    $0x18,%esp
}
  801797:	c9                   	leave  
  801798:	c3                   	ret    

00801799 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801799:	55                   	push   %ebp
  80179a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80179c:	6a 00                	push   $0x0
  80179e:	6a 00                	push   $0x0
  8017a0:	6a 00                	push   $0x0
  8017a2:	ff 75 0c             	pushl  0xc(%ebp)
  8017a5:	ff 75 08             	pushl  0x8(%ebp)
  8017a8:	6a 08                	push   $0x8
  8017aa:	e8 19 ff ff ff       	call   8016c8 <syscall>
  8017af:	83 c4 18             	add    $0x18,%esp
}
  8017b2:	c9                   	leave  
  8017b3:	c3                   	ret    

008017b4 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8017b4:	55                   	push   %ebp
  8017b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8017b7:	6a 00                	push   $0x0
  8017b9:	6a 00                	push   $0x0
  8017bb:	6a 00                	push   $0x0
  8017bd:	6a 00                	push   $0x0
  8017bf:	6a 00                	push   $0x0
  8017c1:	6a 09                	push   $0x9
  8017c3:	e8 00 ff ff ff       	call   8016c8 <syscall>
  8017c8:	83 c4 18             	add    $0x18,%esp
}
  8017cb:	c9                   	leave  
  8017cc:	c3                   	ret    

008017cd <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8017cd:	55                   	push   %ebp
  8017ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8017d0:	6a 00                	push   $0x0
  8017d2:	6a 00                	push   $0x0
  8017d4:	6a 00                	push   $0x0
  8017d6:	6a 00                	push   $0x0
  8017d8:	6a 00                	push   $0x0
  8017da:	6a 0a                	push   $0xa
  8017dc:	e8 e7 fe ff ff       	call   8016c8 <syscall>
  8017e1:	83 c4 18             	add    $0x18,%esp
}
  8017e4:	c9                   	leave  
  8017e5:	c3                   	ret    

008017e6 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8017e6:	55                   	push   %ebp
  8017e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8017e9:	6a 00                	push   $0x0
  8017eb:	6a 00                	push   $0x0
  8017ed:	6a 00                	push   $0x0
  8017ef:	6a 00                	push   $0x0
  8017f1:	6a 00                	push   $0x0
  8017f3:	6a 0b                	push   $0xb
  8017f5:	e8 ce fe ff ff       	call   8016c8 <syscall>
  8017fa:	83 c4 18             	add    $0x18,%esp
}
  8017fd:	c9                   	leave  
  8017fe:	c3                   	ret    

008017ff <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8017ff:	55                   	push   %ebp
  801800:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801802:	6a 00                	push   $0x0
  801804:	6a 00                	push   $0x0
  801806:	6a 00                	push   $0x0
  801808:	ff 75 0c             	pushl  0xc(%ebp)
  80180b:	ff 75 08             	pushl  0x8(%ebp)
  80180e:	6a 0f                	push   $0xf
  801810:	e8 b3 fe ff ff       	call   8016c8 <syscall>
  801815:	83 c4 18             	add    $0x18,%esp
	return;
  801818:	90                   	nop
}
  801819:	c9                   	leave  
  80181a:	c3                   	ret    

0080181b <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80181b:	55                   	push   %ebp
  80181c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80181e:	6a 00                	push   $0x0
  801820:	6a 00                	push   $0x0
  801822:	6a 00                	push   $0x0
  801824:	ff 75 0c             	pushl  0xc(%ebp)
  801827:	ff 75 08             	pushl  0x8(%ebp)
  80182a:	6a 10                	push   $0x10
  80182c:	e8 97 fe ff ff       	call   8016c8 <syscall>
  801831:	83 c4 18             	add    $0x18,%esp
	return ;
  801834:	90                   	nop
}
  801835:	c9                   	leave  
  801836:	c3                   	ret    

00801837 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801837:	55                   	push   %ebp
  801838:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80183a:	6a 00                	push   $0x0
  80183c:	6a 00                	push   $0x0
  80183e:	ff 75 10             	pushl  0x10(%ebp)
  801841:	ff 75 0c             	pushl  0xc(%ebp)
  801844:	ff 75 08             	pushl  0x8(%ebp)
  801847:	6a 11                	push   $0x11
  801849:	e8 7a fe ff ff       	call   8016c8 <syscall>
  80184e:	83 c4 18             	add    $0x18,%esp
	return ;
  801851:	90                   	nop
}
  801852:	c9                   	leave  
  801853:	c3                   	ret    

00801854 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801854:	55                   	push   %ebp
  801855:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801857:	6a 00                	push   $0x0
  801859:	6a 00                	push   $0x0
  80185b:	6a 00                	push   $0x0
  80185d:	6a 00                	push   $0x0
  80185f:	6a 00                	push   $0x0
  801861:	6a 0c                	push   $0xc
  801863:	e8 60 fe ff ff       	call   8016c8 <syscall>
  801868:	83 c4 18             	add    $0x18,%esp
}
  80186b:	c9                   	leave  
  80186c:	c3                   	ret    

0080186d <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80186d:	55                   	push   %ebp
  80186e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801870:	6a 00                	push   $0x0
  801872:	6a 00                	push   $0x0
  801874:	6a 00                	push   $0x0
  801876:	6a 00                	push   $0x0
  801878:	ff 75 08             	pushl  0x8(%ebp)
  80187b:	6a 0d                	push   $0xd
  80187d:	e8 46 fe ff ff       	call   8016c8 <syscall>
  801882:	83 c4 18             	add    $0x18,%esp
}
  801885:	c9                   	leave  
  801886:	c3                   	ret    

00801887 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801887:	55                   	push   %ebp
  801888:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80188a:	6a 00                	push   $0x0
  80188c:	6a 00                	push   $0x0
  80188e:	6a 00                	push   $0x0
  801890:	6a 00                	push   $0x0
  801892:	6a 00                	push   $0x0
  801894:	6a 0e                	push   $0xe
  801896:	e8 2d fe ff ff       	call   8016c8 <syscall>
  80189b:	83 c4 18             	add    $0x18,%esp
}
  80189e:	90                   	nop
  80189f:	c9                   	leave  
  8018a0:	c3                   	ret    

008018a1 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8018a1:	55                   	push   %ebp
  8018a2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 13                	push   $0x13
  8018b0:	e8 13 fe ff ff       	call   8016c8 <syscall>
  8018b5:	83 c4 18             	add    $0x18,%esp
}
  8018b8:	90                   	nop
  8018b9:	c9                   	leave  
  8018ba:	c3                   	ret    

008018bb <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8018bb:	55                   	push   %ebp
  8018bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8018be:	6a 00                	push   $0x0
  8018c0:	6a 00                	push   $0x0
  8018c2:	6a 00                	push   $0x0
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 00                	push   $0x0
  8018c8:	6a 14                	push   $0x14
  8018ca:	e8 f9 fd ff ff       	call   8016c8 <syscall>
  8018cf:	83 c4 18             	add    $0x18,%esp
}
  8018d2:	90                   	nop
  8018d3:	c9                   	leave  
  8018d4:	c3                   	ret    

008018d5 <sys_cputc>:


void
sys_cputc(const char c)
{
  8018d5:	55                   	push   %ebp
  8018d6:	89 e5                	mov    %esp,%ebp
  8018d8:	83 ec 04             	sub    $0x4,%esp
  8018db:	8b 45 08             	mov    0x8(%ebp),%eax
  8018de:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8018e1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8018e5:	6a 00                	push   $0x0
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 00                	push   $0x0
  8018ed:	50                   	push   %eax
  8018ee:	6a 15                	push   $0x15
  8018f0:	e8 d3 fd ff ff       	call   8016c8 <syscall>
  8018f5:	83 c4 18             	add    $0x18,%esp
}
  8018f8:	90                   	nop
  8018f9:	c9                   	leave  
  8018fa:	c3                   	ret    

008018fb <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8018fb:	55                   	push   %ebp
  8018fc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	6a 00                	push   $0x0
  801908:	6a 16                	push   $0x16
  80190a:	e8 b9 fd ff ff       	call   8016c8 <syscall>
  80190f:	83 c4 18             	add    $0x18,%esp
}
  801912:	90                   	nop
  801913:	c9                   	leave  
  801914:	c3                   	ret    

00801915 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801915:	55                   	push   %ebp
  801916:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801918:	8b 45 08             	mov    0x8(%ebp),%eax
  80191b:	6a 00                	push   $0x0
  80191d:	6a 00                	push   $0x0
  80191f:	6a 00                	push   $0x0
  801921:	ff 75 0c             	pushl  0xc(%ebp)
  801924:	50                   	push   %eax
  801925:	6a 17                	push   $0x17
  801927:	e8 9c fd ff ff       	call   8016c8 <syscall>
  80192c:	83 c4 18             	add    $0x18,%esp
}
  80192f:	c9                   	leave  
  801930:	c3                   	ret    

00801931 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801931:	55                   	push   %ebp
  801932:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801934:	8b 55 0c             	mov    0xc(%ebp),%edx
  801937:	8b 45 08             	mov    0x8(%ebp),%eax
  80193a:	6a 00                	push   $0x0
  80193c:	6a 00                	push   $0x0
  80193e:	6a 00                	push   $0x0
  801940:	52                   	push   %edx
  801941:	50                   	push   %eax
  801942:	6a 1a                	push   $0x1a
  801944:	e8 7f fd ff ff       	call   8016c8 <syscall>
  801949:	83 c4 18             	add    $0x18,%esp
}
  80194c:	c9                   	leave  
  80194d:	c3                   	ret    

0080194e <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80194e:	55                   	push   %ebp
  80194f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801951:	8b 55 0c             	mov    0xc(%ebp),%edx
  801954:	8b 45 08             	mov    0x8(%ebp),%eax
  801957:	6a 00                	push   $0x0
  801959:	6a 00                	push   $0x0
  80195b:	6a 00                	push   $0x0
  80195d:	52                   	push   %edx
  80195e:	50                   	push   %eax
  80195f:	6a 18                	push   $0x18
  801961:	e8 62 fd ff ff       	call   8016c8 <syscall>
  801966:	83 c4 18             	add    $0x18,%esp
}
  801969:	90                   	nop
  80196a:	c9                   	leave  
  80196b:	c3                   	ret    

0080196c <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80196c:	55                   	push   %ebp
  80196d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80196f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801972:	8b 45 08             	mov    0x8(%ebp),%eax
  801975:	6a 00                	push   $0x0
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	52                   	push   %edx
  80197c:	50                   	push   %eax
  80197d:	6a 19                	push   $0x19
  80197f:	e8 44 fd ff ff       	call   8016c8 <syscall>
  801984:	83 c4 18             	add    $0x18,%esp
}
  801987:	90                   	nop
  801988:	c9                   	leave  
  801989:	c3                   	ret    

0080198a <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80198a:	55                   	push   %ebp
  80198b:	89 e5                	mov    %esp,%ebp
  80198d:	83 ec 04             	sub    $0x4,%esp
  801990:	8b 45 10             	mov    0x10(%ebp),%eax
  801993:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801996:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801999:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80199d:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a0:	6a 00                	push   $0x0
  8019a2:	51                   	push   %ecx
  8019a3:	52                   	push   %edx
  8019a4:	ff 75 0c             	pushl  0xc(%ebp)
  8019a7:	50                   	push   %eax
  8019a8:	6a 1b                	push   $0x1b
  8019aa:	e8 19 fd ff ff       	call   8016c8 <syscall>
  8019af:	83 c4 18             	add    $0x18,%esp
}
  8019b2:	c9                   	leave  
  8019b3:	c3                   	ret    

008019b4 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8019b4:	55                   	push   %ebp
  8019b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8019b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	52                   	push   %edx
  8019c4:	50                   	push   %eax
  8019c5:	6a 1c                	push   $0x1c
  8019c7:	e8 fc fc ff ff       	call   8016c8 <syscall>
  8019cc:	83 c4 18             	add    $0x18,%esp
}
  8019cf:	c9                   	leave  
  8019d0:	c3                   	ret    

008019d1 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8019d1:	55                   	push   %ebp
  8019d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8019d4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019da:	8b 45 08             	mov    0x8(%ebp),%eax
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	51                   	push   %ecx
  8019e2:	52                   	push   %edx
  8019e3:	50                   	push   %eax
  8019e4:	6a 1d                	push   $0x1d
  8019e6:	e8 dd fc ff ff       	call   8016c8 <syscall>
  8019eb:	83 c4 18             	add    $0x18,%esp
}
  8019ee:	c9                   	leave  
  8019ef:	c3                   	ret    

008019f0 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8019f0:	55                   	push   %ebp
  8019f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8019f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 00                	push   $0x0
  8019ff:	52                   	push   %edx
  801a00:	50                   	push   %eax
  801a01:	6a 1e                	push   $0x1e
  801a03:	e8 c0 fc ff ff       	call   8016c8 <syscall>
  801a08:	83 c4 18             	add    $0x18,%esp
}
  801a0b:	c9                   	leave  
  801a0c:	c3                   	ret    

00801a0d <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801a0d:	55                   	push   %ebp
  801a0e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 1f                	push   $0x1f
  801a1c:	e8 a7 fc ff ff       	call   8016c8 <syscall>
  801a21:	83 c4 18             	add    $0x18,%esp
}
  801a24:	c9                   	leave  
  801a25:	c3                   	ret    

00801a26 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a26:	55                   	push   %ebp
  801a27:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a29:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2c:	6a 00                	push   $0x0
  801a2e:	ff 75 14             	pushl  0x14(%ebp)
  801a31:	ff 75 10             	pushl  0x10(%ebp)
  801a34:	ff 75 0c             	pushl  0xc(%ebp)
  801a37:	50                   	push   %eax
  801a38:	6a 20                	push   $0x20
  801a3a:	e8 89 fc ff ff       	call   8016c8 <syscall>
  801a3f:	83 c4 18             	add    $0x18,%esp
}
  801a42:	c9                   	leave  
  801a43:	c3                   	ret    

00801a44 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801a44:	55                   	push   %ebp
  801a45:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a47:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 00                	push   $0x0
  801a52:	50                   	push   %eax
  801a53:	6a 21                	push   $0x21
  801a55:	e8 6e fc ff ff       	call   8016c8 <syscall>
  801a5a:	83 c4 18             	add    $0x18,%esp
}
  801a5d:	90                   	nop
  801a5e:	c9                   	leave  
  801a5f:	c3                   	ret    

00801a60 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801a60:	55                   	push   %ebp
  801a61:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a63:	8b 45 08             	mov    0x8(%ebp),%eax
  801a66:	6a 00                	push   $0x0
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	50                   	push   %eax
  801a6f:	6a 22                	push   $0x22
  801a71:	e8 52 fc ff ff       	call   8016c8 <syscall>
  801a76:	83 c4 18             	add    $0x18,%esp
}
  801a79:	c9                   	leave  
  801a7a:	c3                   	ret    

00801a7b <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a7b:	55                   	push   %ebp
  801a7c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	6a 02                	push   $0x2
  801a8a:	e8 39 fc ff ff       	call   8016c8 <syscall>
  801a8f:	83 c4 18             	add    $0x18,%esp
}
  801a92:	c9                   	leave  
  801a93:	c3                   	ret    

00801a94 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a94:	55                   	push   %ebp
  801a95:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 03                	push   $0x3
  801aa3:	e8 20 fc ff ff       	call   8016c8 <syscall>
  801aa8:	83 c4 18             	add    $0x18,%esp
}
  801aab:	c9                   	leave  
  801aac:	c3                   	ret    

00801aad <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801aad:	55                   	push   %ebp
  801aae:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 04                	push   $0x4
  801abc:	e8 07 fc ff ff       	call   8016c8 <syscall>
  801ac1:	83 c4 18             	add    $0x18,%esp
}
  801ac4:	c9                   	leave  
  801ac5:	c3                   	ret    

00801ac6 <sys_exit_env>:


void sys_exit_env(void)
{
  801ac6:	55                   	push   %ebp
  801ac7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 00                	push   $0x0
  801ad3:	6a 23                	push   $0x23
  801ad5:	e8 ee fb ff ff       	call   8016c8 <syscall>
  801ada:	83 c4 18             	add    $0x18,%esp
}
  801add:	90                   	nop
  801ade:	c9                   	leave  
  801adf:	c3                   	ret    

00801ae0 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801ae0:	55                   	push   %ebp
  801ae1:	89 e5                	mov    %esp,%ebp
  801ae3:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801ae6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ae9:	8d 50 04             	lea    0x4(%eax),%edx
  801aec:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801aef:	6a 00                	push   $0x0
  801af1:	6a 00                	push   $0x0
  801af3:	6a 00                	push   $0x0
  801af5:	52                   	push   %edx
  801af6:	50                   	push   %eax
  801af7:	6a 24                	push   $0x24
  801af9:	e8 ca fb ff ff       	call   8016c8 <syscall>
  801afe:	83 c4 18             	add    $0x18,%esp
	return result;
  801b01:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b04:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b07:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b0a:	89 01                	mov    %eax,(%ecx)
  801b0c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b12:	c9                   	leave  
  801b13:	c2 04 00             	ret    $0x4

00801b16 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b16:	55                   	push   %ebp
  801b17:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 00                	push   $0x0
  801b1d:	ff 75 10             	pushl  0x10(%ebp)
  801b20:	ff 75 0c             	pushl  0xc(%ebp)
  801b23:	ff 75 08             	pushl  0x8(%ebp)
  801b26:	6a 12                	push   $0x12
  801b28:	e8 9b fb ff ff       	call   8016c8 <syscall>
  801b2d:	83 c4 18             	add    $0x18,%esp
	return ;
  801b30:	90                   	nop
}
  801b31:	c9                   	leave  
  801b32:	c3                   	ret    

00801b33 <sys_rcr2>:
uint32 sys_rcr2()
{
  801b33:	55                   	push   %ebp
  801b34:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 25                	push   $0x25
  801b42:	e8 81 fb ff ff       	call   8016c8 <syscall>
  801b47:	83 c4 18             	add    $0x18,%esp
}
  801b4a:	c9                   	leave  
  801b4b:	c3                   	ret    

00801b4c <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801b4c:	55                   	push   %ebp
  801b4d:	89 e5                	mov    %esp,%ebp
  801b4f:	83 ec 04             	sub    $0x4,%esp
  801b52:	8b 45 08             	mov    0x8(%ebp),%eax
  801b55:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b58:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 00                	push   $0x0
  801b60:	6a 00                	push   $0x0
  801b62:	6a 00                	push   $0x0
  801b64:	50                   	push   %eax
  801b65:	6a 26                	push   $0x26
  801b67:	e8 5c fb ff ff       	call   8016c8 <syscall>
  801b6c:	83 c4 18             	add    $0x18,%esp
	return ;
  801b6f:	90                   	nop
}
  801b70:	c9                   	leave  
  801b71:	c3                   	ret    

00801b72 <rsttst>:
void rsttst()
{
  801b72:	55                   	push   %ebp
  801b73:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b75:	6a 00                	push   $0x0
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 28                	push   $0x28
  801b81:	e8 42 fb ff ff       	call   8016c8 <syscall>
  801b86:	83 c4 18             	add    $0x18,%esp
	return ;
  801b89:	90                   	nop
}
  801b8a:	c9                   	leave  
  801b8b:	c3                   	ret    

00801b8c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b8c:	55                   	push   %ebp
  801b8d:	89 e5                	mov    %esp,%ebp
  801b8f:	83 ec 04             	sub    $0x4,%esp
  801b92:	8b 45 14             	mov    0x14(%ebp),%eax
  801b95:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b98:	8b 55 18             	mov    0x18(%ebp),%edx
  801b9b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b9f:	52                   	push   %edx
  801ba0:	50                   	push   %eax
  801ba1:	ff 75 10             	pushl  0x10(%ebp)
  801ba4:	ff 75 0c             	pushl  0xc(%ebp)
  801ba7:	ff 75 08             	pushl  0x8(%ebp)
  801baa:	6a 27                	push   $0x27
  801bac:	e8 17 fb ff ff       	call   8016c8 <syscall>
  801bb1:	83 c4 18             	add    $0x18,%esp
	return ;
  801bb4:	90                   	nop
}
  801bb5:	c9                   	leave  
  801bb6:	c3                   	ret    

00801bb7 <chktst>:
void chktst(uint32 n)
{
  801bb7:	55                   	push   %ebp
  801bb8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 00                	push   $0x0
  801bc0:	6a 00                	push   $0x0
  801bc2:	ff 75 08             	pushl  0x8(%ebp)
  801bc5:	6a 29                	push   $0x29
  801bc7:	e8 fc fa ff ff       	call   8016c8 <syscall>
  801bcc:	83 c4 18             	add    $0x18,%esp
	return ;
  801bcf:	90                   	nop
}
  801bd0:	c9                   	leave  
  801bd1:	c3                   	ret    

00801bd2 <inctst>:

void inctst()
{
  801bd2:	55                   	push   %ebp
  801bd3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 2a                	push   $0x2a
  801be1:	e8 e2 fa ff ff       	call   8016c8 <syscall>
  801be6:	83 c4 18             	add    $0x18,%esp
	return ;
  801be9:	90                   	nop
}
  801bea:	c9                   	leave  
  801beb:	c3                   	ret    

00801bec <gettst>:
uint32 gettst()
{
  801bec:	55                   	push   %ebp
  801bed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 00                	push   $0x0
  801bf9:	6a 2b                	push   $0x2b
  801bfb:	e8 c8 fa ff ff       	call   8016c8 <syscall>
  801c00:	83 c4 18             	add    $0x18,%esp
}
  801c03:	c9                   	leave  
  801c04:	c3                   	ret    

00801c05 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801c05:	55                   	push   %ebp
  801c06:	89 e5                	mov    %esp,%ebp
  801c08:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 00                	push   $0x0
  801c13:	6a 00                	push   $0x0
  801c15:	6a 2c                	push   $0x2c
  801c17:	e8 ac fa ff ff       	call   8016c8 <syscall>
  801c1c:	83 c4 18             	add    $0x18,%esp
  801c1f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c22:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c26:	75 07                	jne    801c2f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c28:	b8 01 00 00 00       	mov    $0x1,%eax
  801c2d:	eb 05                	jmp    801c34 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801c2f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c34:	c9                   	leave  
  801c35:	c3                   	ret    

00801c36 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801c36:	55                   	push   %ebp
  801c37:	89 e5                	mov    %esp,%ebp
  801c39:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	6a 2c                	push   $0x2c
  801c48:	e8 7b fa ff ff       	call   8016c8 <syscall>
  801c4d:	83 c4 18             	add    $0x18,%esp
  801c50:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801c53:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801c57:	75 07                	jne    801c60 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801c59:	b8 01 00 00 00       	mov    $0x1,%eax
  801c5e:	eb 05                	jmp    801c65 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801c60:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c65:	c9                   	leave  
  801c66:	c3                   	ret    

00801c67 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801c67:	55                   	push   %ebp
  801c68:	89 e5                	mov    %esp,%ebp
  801c6a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 00                	push   $0x0
  801c73:	6a 00                	push   $0x0
  801c75:	6a 00                	push   $0x0
  801c77:	6a 2c                	push   $0x2c
  801c79:	e8 4a fa ff ff       	call   8016c8 <syscall>
  801c7e:	83 c4 18             	add    $0x18,%esp
  801c81:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801c84:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801c88:	75 07                	jne    801c91 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801c8a:	b8 01 00 00 00       	mov    $0x1,%eax
  801c8f:	eb 05                	jmp    801c96 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801c91:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c96:	c9                   	leave  
  801c97:	c3                   	ret    

00801c98 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801c98:	55                   	push   %ebp
  801c99:	89 e5                	mov    %esp,%ebp
  801c9b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 2c                	push   $0x2c
  801caa:	e8 19 fa ff ff       	call   8016c8 <syscall>
  801caf:	83 c4 18             	add    $0x18,%esp
  801cb2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801cb5:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801cb9:	75 07                	jne    801cc2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801cbb:	b8 01 00 00 00       	mov    $0x1,%eax
  801cc0:	eb 05                	jmp    801cc7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801cc2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cc7:	c9                   	leave  
  801cc8:	c3                   	ret    

00801cc9 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801cc9:	55                   	push   %ebp
  801cca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ccc:	6a 00                	push   $0x0
  801cce:	6a 00                	push   $0x0
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 00                	push   $0x0
  801cd4:	ff 75 08             	pushl  0x8(%ebp)
  801cd7:	6a 2d                	push   $0x2d
  801cd9:	e8 ea f9 ff ff       	call   8016c8 <syscall>
  801cde:	83 c4 18             	add    $0x18,%esp
	return ;
  801ce1:	90                   	nop
}
  801ce2:	c9                   	leave  
  801ce3:	c3                   	ret    

00801ce4 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ce4:	55                   	push   %ebp
  801ce5:	89 e5                	mov    %esp,%ebp
  801ce7:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ce8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ceb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cee:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf4:	6a 00                	push   $0x0
  801cf6:	53                   	push   %ebx
  801cf7:	51                   	push   %ecx
  801cf8:	52                   	push   %edx
  801cf9:	50                   	push   %eax
  801cfa:	6a 2e                	push   $0x2e
  801cfc:	e8 c7 f9 ff ff       	call   8016c8 <syscall>
  801d01:	83 c4 18             	add    $0x18,%esp
}
  801d04:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d07:	c9                   	leave  
  801d08:	c3                   	ret    

00801d09 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d09:	55                   	push   %ebp
  801d0a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d12:	6a 00                	push   $0x0
  801d14:	6a 00                	push   $0x0
  801d16:	6a 00                	push   $0x0
  801d18:	52                   	push   %edx
  801d19:	50                   	push   %eax
  801d1a:	6a 2f                	push   $0x2f
  801d1c:	e8 a7 f9 ff ff       	call   8016c8 <syscall>
  801d21:	83 c4 18             	add    $0x18,%esp
}
  801d24:	c9                   	leave  
  801d25:	c3                   	ret    

00801d26 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801d26:	55                   	push   %ebp
  801d27:	89 e5                	mov    %esp,%ebp
  801d29:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801d2c:	83 ec 0c             	sub    $0xc,%esp
  801d2f:	68 7c 38 80 00       	push   $0x80387c
  801d34:	e8 21 e7 ff ff       	call   80045a <cprintf>
  801d39:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801d3c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801d43:	83 ec 0c             	sub    $0xc,%esp
  801d46:	68 a8 38 80 00       	push   $0x8038a8
  801d4b:	e8 0a e7 ff ff       	call   80045a <cprintf>
  801d50:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801d53:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d57:	a1 38 41 80 00       	mov    0x804138,%eax
  801d5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d5f:	eb 56                	jmp    801db7 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801d61:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d65:	74 1c                	je     801d83 <print_mem_block_lists+0x5d>
  801d67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d6a:	8b 50 08             	mov    0x8(%eax),%edx
  801d6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d70:	8b 48 08             	mov    0x8(%eax),%ecx
  801d73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d76:	8b 40 0c             	mov    0xc(%eax),%eax
  801d79:	01 c8                	add    %ecx,%eax
  801d7b:	39 c2                	cmp    %eax,%edx
  801d7d:	73 04                	jae    801d83 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801d7f:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801d83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d86:	8b 50 08             	mov    0x8(%eax),%edx
  801d89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d8c:	8b 40 0c             	mov    0xc(%eax),%eax
  801d8f:	01 c2                	add    %eax,%edx
  801d91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d94:	8b 40 08             	mov    0x8(%eax),%eax
  801d97:	83 ec 04             	sub    $0x4,%esp
  801d9a:	52                   	push   %edx
  801d9b:	50                   	push   %eax
  801d9c:	68 bd 38 80 00       	push   $0x8038bd
  801da1:	e8 b4 e6 ff ff       	call   80045a <cprintf>
  801da6:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801da9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dac:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801daf:	a1 40 41 80 00       	mov    0x804140,%eax
  801db4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801db7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dbb:	74 07                	je     801dc4 <print_mem_block_lists+0x9e>
  801dbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc0:	8b 00                	mov    (%eax),%eax
  801dc2:	eb 05                	jmp    801dc9 <print_mem_block_lists+0xa3>
  801dc4:	b8 00 00 00 00       	mov    $0x0,%eax
  801dc9:	a3 40 41 80 00       	mov    %eax,0x804140
  801dce:	a1 40 41 80 00       	mov    0x804140,%eax
  801dd3:	85 c0                	test   %eax,%eax
  801dd5:	75 8a                	jne    801d61 <print_mem_block_lists+0x3b>
  801dd7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ddb:	75 84                	jne    801d61 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801ddd:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801de1:	75 10                	jne    801df3 <print_mem_block_lists+0xcd>
  801de3:	83 ec 0c             	sub    $0xc,%esp
  801de6:	68 cc 38 80 00       	push   $0x8038cc
  801deb:	e8 6a e6 ff ff       	call   80045a <cprintf>
  801df0:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801df3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801dfa:	83 ec 0c             	sub    $0xc,%esp
  801dfd:	68 f0 38 80 00       	push   $0x8038f0
  801e02:	e8 53 e6 ff ff       	call   80045a <cprintf>
  801e07:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801e0a:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e0e:	a1 40 40 80 00       	mov    0x804040,%eax
  801e13:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e16:	eb 56                	jmp    801e6e <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e18:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e1c:	74 1c                	je     801e3a <print_mem_block_lists+0x114>
  801e1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e21:	8b 50 08             	mov    0x8(%eax),%edx
  801e24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e27:	8b 48 08             	mov    0x8(%eax),%ecx
  801e2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e2d:	8b 40 0c             	mov    0xc(%eax),%eax
  801e30:	01 c8                	add    %ecx,%eax
  801e32:	39 c2                	cmp    %eax,%edx
  801e34:	73 04                	jae    801e3a <print_mem_block_lists+0x114>
			sorted = 0 ;
  801e36:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e3d:	8b 50 08             	mov    0x8(%eax),%edx
  801e40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e43:	8b 40 0c             	mov    0xc(%eax),%eax
  801e46:	01 c2                	add    %eax,%edx
  801e48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e4b:	8b 40 08             	mov    0x8(%eax),%eax
  801e4e:	83 ec 04             	sub    $0x4,%esp
  801e51:	52                   	push   %edx
  801e52:	50                   	push   %eax
  801e53:	68 bd 38 80 00       	push   $0x8038bd
  801e58:	e8 fd e5 ff ff       	call   80045a <cprintf>
  801e5d:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e63:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e66:	a1 48 40 80 00       	mov    0x804048,%eax
  801e6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e6e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e72:	74 07                	je     801e7b <print_mem_block_lists+0x155>
  801e74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e77:	8b 00                	mov    (%eax),%eax
  801e79:	eb 05                	jmp    801e80 <print_mem_block_lists+0x15a>
  801e7b:	b8 00 00 00 00       	mov    $0x0,%eax
  801e80:	a3 48 40 80 00       	mov    %eax,0x804048
  801e85:	a1 48 40 80 00       	mov    0x804048,%eax
  801e8a:	85 c0                	test   %eax,%eax
  801e8c:	75 8a                	jne    801e18 <print_mem_block_lists+0xf2>
  801e8e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e92:	75 84                	jne    801e18 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801e94:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e98:	75 10                	jne    801eaa <print_mem_block_lists+0x184>
  801e9a:	83 ec 0c             	sub    $0xc,%esp
  801e9d:	68 08 39 80 00       	push   $0x803908
  801ea2:	e8 b3 e5 ff ff       	call   80045a <cprintf>
  801ea7:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801eaa:	83 ec 0c             	sub    $0xc,%esp
  801ead:	68 7c 38 80 00       	push   $0x80387c
  801eb2:	e8 a3 e5 ff ff       	call   80045a <cprintf>
  801eb7:	83 c4 10             	add    $0x10,%esp

}
  801eba:	90                   	nop
  801ebb:	c9                   	leave  
  801ebc:	c3                   	ret    

00801ebd <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801ebd:	55                   	push   %ebp
  801ebe:	89 e5                	mov    %esp,%ebp
  801ec0:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  801ec3:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801eca:	00 00 00 
  801ecd:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801ed4:	00 00 00 
  801ed7:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801ede:	00 00 00 
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  801ee1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801ee8:	e9 9e 00 00 00       	jmp    801f8b <initialize_MemBlocksList+0xce>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
  801eed:	a1 50 40 80 00       	mov    0x804050,%eax
  801ef2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ef5:	c1 e2 04             	shl    $0x4,%edx
  801ef8:	01 d0                	add    %edx,%eax
  801efa:	85 c0                	test   %eax,%eax
  801efc:	75 14                	jne    801f12 <initialize_MemBlocksList+0x55>
  801efe:	83 ec 04             	sub    $0x4,%esp
  801f01:	68 30 39 80 00       	push   $0x803930
  801f06:	6a 43                	push   $0x43
  801f08:	68 53 39 80 00       	push   $0x803953
  801f0d:	e8 9c 0f 00 00       	call   802eae <_panic>
  801f12:	a1 50 40 80 00       	mov    0x804050,%eax
  801f17:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f1a:	c1 e2 04             	shl    $0x4,%edx
  801f1d:	01 d0                	add    %edx,%eax
  801f1f:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801f25:	89 10                	mov    %edx,(%eax)
  801f27:	8b 00                	mov    (%eax),%eax
  801f29:	85 c0                	test   %eax,%eax
  801f2b:	74 18                	je     801f45 <initialize_MemBlocksList+0x88>
  801f2d:	a1 48 41 80 00       	mov    0x804148,%eax
  801f32:	8b 15 50 40 80 00    	mov    0x804050,%edx
  801f38:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801f3b:	c1 e1 04             	shl    $0x4,%ecx
  801f3e:	01 ca                	add    %ecx,%edx
  801f40:	89 50 04             	mov    %edx,0x4(%eax)
  801f43:	eb 12                	jmp    801f57 <initialize_MemBlocksList+0x9a>
  801f45:	a1 50 40 80 00       	mov    0x804050,%eax
  801f4a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f4d:	c1 e2 04             	shl    $0x4,%edx
  801f50:	01 d0                	add    %edx,%eax
  801f52:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801f57:	a1 50 40 80 00       	mov    0x804050,%eax
  801f5c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f5f:	c1 e2 04             	shl    $0x4,%edx
  801f62:	01 d0                	add    %edx,%eax
  801f64:	a3 48 41 80 00       	mov    %eax,0x804148
  801f69:	a1 50 40 80 00       	mov    0x804050,%eax
  801f6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f71:	c1 e2 04             	shl    $0x4,%edx
  801f74:	01 d0                	add    %edx,%eax
  801f76:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f7d:	a1 54 41 80 00       	mov    0x804154,%eax
  801f82:	40                   	inc    %eax
  801f83:	a3 54 41 80 00       	mov    %eax,0x804154
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  801f88:	ff 45 f4             	incl   -0xc(%ebp)
  801f8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8e:	3b 45 08             	cmp    0x8(%ebp),%eax
  801f91:	0f 82 56 ff ff ff    	jb     801eed <initialize_MemBlocksList+0x30>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
		}
}
  801f97:	90                   	nop
  801f98:	c9                   	leave  
  801f99:	c3                   	ret    

00801f9a <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801f9a:	55                   	push   %ebp
  801f9b:	89 e5                	mov    %esp,%ebp
  801f9d:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  801fa0:	a1 38 41 80 00       	mov    0x804138,%eax
  801fa5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801fa8:	eb 18                	jmp    801fc2 <find_block+0x28>
	{
		if (ele->sva==va)
  801faa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fad:	8b 40 08             	mov    0x8(%eax),%eax
  801fb0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801fb3:	75 05                	jne    801fba <find_block+0x20>
			return ele;
  801fb5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fb8:	eb 7b                	jmp    802035 <find_block+0x9b>
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  801fba:	a1 40 41 80 00       	mov    0x804140,%eax
  801fbf:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801fc2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801fc6:	74 07                	je     801fcf <find_block+0x35>
  801fc8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fcb:	8b 00                	mov    (%eax),%eax
  801fcd:	eb 05                	jmp    801fd4 <find_block+0x3a>
  801fcf:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd4:	a3 40 41 80 00       	mov    %eax,0x804140
  801fd9:	a1 40 41 80 00       	mov    0x804140,%eax
  801fde:	85 c0                	test   %eax,%eax
  801fe0:	75 c8                	jne    801faa <find_block+0x10>
  801fe2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801fe6:	75 c2                	jne    801faa <find_block+0x10>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  801fe8:	a1 40 40 80 00       	mov    0x804040,%eax
  801fed:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801ff0:	eb 18                	jmp    80200a <find_block+0x70>
	{
		if (ele->sva==va)
  801ff2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ff5:	8b 40 08             	mov    0x8(%eax),%eax
  801ff8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801ffb:	75 05                	jne    802002 <find_block+0x68>
					return ele;
  801ffd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802000:	eb 33                	jmp    802035 <find_block+0x9b>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  802002:	a1 48 40 80 00       	mov    0x804048,%eax
  802007:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80200a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80200e:	74 07                	je     802017 <find_block+0x7d>
  802010:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802013:	8b 00                	mov    (%eax),%eax
  802015:	eb 05                	jmp    80201c <find_block+0x82>
  802017:	b8 00 00 00 00       	mov    $0x0,%eax
  80201c:	a3 48 40 80 00       	mov    %eax,0x804048
  802021:	a1 48 40 80 00       	mov    0x804048,%eax
  802026:	85 c0                	test   %eax,%eax
  802028:	75 c8                	jne    801ff2 <find_block+0x58>
  80202a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80202e:	75 c2                	jne    801ff2 <find_block+0x58>
	{
		if (ele->sva==va)
					return ele;
	}
return NULL;
  802030:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802035:	c9                   	leave  
  802036:	c3                   	ret    

00802037 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802037:	55                   	push   %ebp
  802038:	89 e5                	mov    %esp,%ebp
  80203a:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;

int x =LIST_SIZE(&AllocMemBlocksList);
  80203d:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802042:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((x==0))
  802045:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802049:	75 62                	jne    8020ad <insert_sorted_allocList+0x76>
	{
	//	blockToInsert=AllocMemBlocksList.lh_first;
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  80204b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80204f:	75 14                	jne    802065 <insert_sorted_allocList+0x2e>
  802051:	83 ec 04             	sub    $0x4,%esp
  802054:	68 30 39 80 00       	push   $0x803930
  802059:	6a 69                	push   $0x69
  80205b:	68 53 39 80 00       	push   $0x803953
  802060:	e8 49 0e 00 00       	call   802eae <_panic>
  802065:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80206b:	8b 45 08             	mov    0x8(%ebp),%eax
  80206e:	89 10                	mov    %edx,(%eax)
  802070:	8b 45 08             	mov    0x8(%ebp),%eax
  802073:	8b 00                	mov    (%eax),%eax
  802075:	85 c0                	test   %eax,%eax
  802077:	74 0d                	je     802086 <insert_sorted_allocList+0x4f>
  802079:	a1 40 40 80 00       	mov    0x804040,%eax
  80207e:	8b 55 08             	mov    0x8(%ebp),%edx
  802081:	89 50 04             	mov    %edx,0x4(%eax)
  802084:	eb 08                	jmp    80208e <insert_sorted_allocList+0x57>
  802086:	8b 45 08             	mov    0x8(%ebp),%eax
  802089:	a3 44 40 80 00       	mov    %eax,0x804044
  80208e:	8b 45 08             	mov    0x8(%ebp),%eax
  802091:	a3 40 40 80 00       	mov    %eax,0x804040
  802096:	8b 45 08             	mov    0x8(%ebp),%eax
  802099:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020a0:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8020a5:	40                   	inc    %eax
  8020a6:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8020ab:	eb 72                	jmp    80211f <insert_sorted_allocList+0xe8>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
  8020ad:	a1 40 40 80 00       	mov    0x804040,%eax
  8020b2:	8b 50 08             	mov    0x8(%eax),%edx
  8020b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b8:	8b 40 08             	mov    0x8(%eax),%eax
  8020bb:	39 c2                	cmp    %eax,%edx
  8020bd:	76 60                	jbe    80211f <insert_sorted_allocList+0xe8>
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  8020bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020c3:	75 14                	jne    8020d9 <insert_sorted_allocList+0xa2>
  8020c5:	83 ec 04             	sub    $0x4,%esp
  8020c8:	68 30 39 80 00       	push   $0x803930
  8020cd:	6a 6d                	push   $0x6d
  8020cf:	68 53 39 80 00       	push   $0x803953
  8020d4:	e8 d5 0d 00 00       	call   802eae <_panic>
  8020d9:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8020df:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e2:	89 10                	mov    %edx,(%eax)
  8020e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e7:	8b 00                	mov    (%eax),%eax
  8020e9:	85 c0                	test   %eax,%eax
  8020eb:	74 0d                	je     8020fa <insert_sorted_allocList+0xc3>
  8020ed:	a1 40 40 80 00       	mov    0x804040,%eax
  8020f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8020f5:	89 50 04             	mov    %edx,0x4(%eax)
  8020f8:	eb 08                	jmp    802102 <insert_sorted_allocList+0xcb>
  8020fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fd:	a3 44 40 80 00       	mov    %eax,0x804044
  802102:	8b 45 08             	mov    0x8(%ebp),%eax
  802105:	a3 40 40 80 00       	mov    %eax,0x804040
  80210a:	8b 45 08             	mov    0x8(%ebp),%eax
  80210d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802114:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802119:	40                   	inc    %eax
  80211a:	a3 4c 40 80 00       	mov    %eax,0x80404c
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  80211f:	a1 40 40 80 00       	mov    0x804040,%eax
  802124:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802127:	e9 b9 01 00 00       	jmp    8022e5 <insert_sorted_allocList+0x2ae>
	{


		if ((blockToInsert->sva>AllocMemBlocksList.lh_first->sva)&&blockToInsert->sva<element->sva)
  80212c:	8b 45 08             	mov    0x8(%ebp),%eax
  80212f:	8b 50 08             	mov    0x8(%eax),%edx
  802132:	a1 40 40 80 00       	mov    0x804040,%eax
  802137:	8b 40 08             	mov    0x8(%eax),%eax
  80213a:	39 c2                	cmp    %eax,%edx
  80213c:	76 7c                	jbe    8021ba <insert_sorted_allocList+0x183>
  80213e:	8b 45 08             	mov    0x8(%ebp),%eax
  802141:	8b 50 08             	mov    0x8(%eax),%edx
  802144:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802147:	8b 40 08             	mov    0x8(%eax),%eax
  80214a:	39 c2                	cmp    %eax,%edx
  80214c:	73 6c                	jae    8021ba <insert_sorted_allocList+0x183>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,element,blockToInsert);
  80214e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802152:	74 06                	je     80215a <insert_sorted_allocList+0x123>
  802154:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802158:	75 14                	jne    80216e <insert_sorted_allocList+0x137>
  80215a:	83 ec 04             	sub    $0x4,%esp
  80215d:	68 6c 39 80 00       	push   $0x80396c
  802162:	6a 75                	push   $0x75
  802164:	68 53 39 80 00       	push   $0x803953
  802169:	e8 40 0d 00 00       	call   802eae <_panic>
  80216e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802171:	8b 50 04             	mov    0x4(%eax),%edx
  802174:	8b 45 08             	mov    0x8(%ebp),%eax
  802177:	89 50 04             	mov    %edx,0x4(%eax)
  80217a:	8b 45 08             	mov    0x8(%ebp),%eax
  80217d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802180:	89 10                	mov    %edx,(%eax)
  802182:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802185:	8b 40 04             	mov    0x4(%eax),%eax
  802188:	85 c0                	test   %eax,%eax
  80218a:	74 0d                	je     802199 <insert_sorted_allocList+0x162>
  80218c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218f:	8b 40 04             	mov    0x4(%eax),%eax
  802192:	8b 55 08             	mov    0x8(%ebp),%edx
  802195:	89 10                	mov    %edx,(%eax)
  802197:	eb 08                	jmp    8021a1 <insert_sorted_allocList+0x16a>
  802199:	8b 45 08             	mov    0x8(%ebp),%eax
  80219c:	a3 40 40 80 00       	mov    %eax,0x804040
  8021a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8021a7:	89 50 04             	mov    %edx,0x4(%eax)
  8021aa:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021af:	40                   	inc    %eax
  8021b0:	a3 4c 40 80 00       	mov    %eax,0x80404c

		break;}
  8021b5:	e9 59 01 00 00       	jmp    802313 <insert_sorted_allocList+0x2dc>

	else if ((blockToInsert->sva>element->sva)&&(blockToInsert->sva<AllocMemBlocksList.lh_last->sva)&&blockToInsert->sva<LIST_NEXT(element)->sva)
  8021ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bd:	8b 50 08             	mov    0x8(%eax),%edx
  8021c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c3:	8b 40 08             	mov    0x8(%eax),%eax
  8021c6:	39 c2                	cmp    %eax,%edx
  8021c8:	0f 86 98 00 00 00    	jbe    802266 <insert_sorted_allocList+0x22f>
  8021ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d1:	8b 50 08             	mov    0x8(%eax),%edx
  8021d4:	a1 44 40 80 00       	mov    0x804044,%eax
  8021d9:	8b 40 08             	mov    0x8(%eax),%eax
  8021dc:	39 c2                	cmp    %eax,%edx
  8021de:	0f 83 82 00 00 00    	jae    802266 <insert_sorted_allocList+0x22f>
  8021e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e7:	8b 50 08             	mov    0x8(%eax),%edx
  8021ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ed:	8b 00                	mov    (%eax),%eax
  8021ef:	8b 40 08             	mov    0x8(%eax),%eax
  8021f2:	39 c2                	cmp    %eax,%edx
  8021f4:	73 70                	jae    802266 <insert_sorted_allocList+0x22f>
	{

	LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  8021f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021fa:	74 06                	je     802202 <insert_sorted_allocList+0x1cb>
  8021fc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802200:	75 14                	jne    802216 <insert_sorted_allocList+0x1df>
  802202:	83 ec 04             	sub    $0x4,%esp
  802205:	68 a4 39 80 00       	push   $0x8039a4
  80220a:	6a 7c                	push   $0x7c
  80220c:	68 53 39 80 00       	push   $0x803953
  802211:	e8 98 0c 00 00       	call   802eae <_panic>
  802216:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802219:	8b 10                	mov    (%eax),%edx
  80221b:	8b 45 08             	mov    0x8(%ebp),%eax
  80221e:	89 10                	mov    %edx,(%eax)
  802220:	8b 45 08             	mov    0x8(%ebp),%eax
  802223:	8b 00                	mov    (%eax),%eax
  802225:	85 c0                	test   %eax,%eax
  802227:	74 0b                	je     802234 <insert_sorted_allocList+0x1fd>
  802229:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222c:	8b 00                	mov    (%eax),%eax
  80222e:	8b 55 08             	mov    0x8(%ebp),%edx
  802231:	89 50 04             	mov    %edx,0x4(%eax)
  802234:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802237:	8b 55 08             	mov    0x8(%ebp),%edx
  80223a:	89 10                	mov    %edx,(%eax)
  80223c:	8b 45 08             	mov    0x8(%ebp),%eax
  80223f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802242:	89 50 04             	mov    %edx,0x4(%eax)
  802245:	8b 45 08             	mov    0x8(%ebp),%eax
  802248:	8b 00                	mov    (%eax),%eax
  80224a:	85 c0                	test   %eax,%eax
  80224c:	75 08                	jne    802256 <insert_sorted_allocList+0x21f>
  80224e:	8b 45 08             	mov    0x8(%ebp),%eax
  802251:	a3 44 40 80 00       	mov    %eax,0x804044
  802256:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80225b:	40                   	inc    %eax
  80225c:	a3 4c 40 80 00       	mov    %eax,0x80404c
		break;
  802261:	e9 ad 00 00 00       	jmp    802313 <insert_sorted_allocList+0x2dc>
	}else if (blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  802266:	8b 45 08             	mov    0x8(%ebp),%eax
  802269:	8b 50 08             	mov    0x8(%eax),%edx
  80226c:	a1 44 40 80 00       	mov    0x804044,%eax
  802271:	8b 40 08             	mov    0x8(%eax),%eax
  802274:	39 c2                	cmp    %eax,%edx
  802276:	76 65                	jbe    8022dd <insert_sorted_allocList+0x2a6>
	{
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
  802278:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80227c:	75 17                	jne    802295 <insert_sorted_allocList+0x25e>
  80227e:	83 ec 04             	sub    $0x4,%esp
  802281:	68 d8 39 80 00       	push   $0x8039d8
  802286:	68 80 00 00 00       	push   $0x80
  80228b:	68 53 39 80 00       	push   $0x803953
  802290:	e8 19 0c 00 00       	call   802eae <_panic>
  802295:	8b 15 44 40 80 00    	mov    0x804044,%edx
  80229b:	8b 45 08             	mov    0x8(%ebp),%eax
  80229e:	89 50 04             	mov    %edx,0x4(%eax)
  8022a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a4:	8b 40 04             	mov    0x4(%eax),%eax
  8022a7:	85 c0                	test   %eax,%eax
  8022a9:	74 0c                	je     8022b7 <insert_sorted_allocList+0x280>
  8022ab:	a1 44 40 80 00       	mov    0x804044,%eax
  8022b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8022b3:	89 10                	mov    %edx,(%eax)
  8022b5:	eb 08                	jmp    8022bf <insert_sorted_allocList+0x288>
  8022b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ba:	a3 40 40 80 00       	mov    %eax,0x804040
  8022bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c2:	a3 44 40 80 00       	mov    %eax,0x804044
  8022c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022d0:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022d5:	40                   	inc    %eax
  8022d6:	a3 4c 40 80 00       	mov    %eax,0x80404c
		break;
  8022db:	eb 36                	jmp    802313 <insert_sorted_allocList+0x2dc>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  8022dd:	a1 48 40 80 00       	mov    0x804048,%eax
  8022e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022e9:	74 07                	je     8022f2 <insert_sorted_allocList+0x2bb>
  8022eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ee:	8b 00                	mov    (%eax),%eax
  8022f0:	eb 05                	jmp    8022f7 <insert_sorted_allocList+0x2c0>
  8022f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8022f7:	a3 48 40 80 00       	mov    %eax,0x804048
  8022fc:	a1 48 40 80 00       	mov    0x804048,%eax
  802301:	85 c0                	test   %eax,%eax
  802303:	0f 85 23 fe ff ff    	jne    80212c <insert_sorted_allocList+0xf5>
  802309:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80230d:	0f 85 19 fe ff ff    	jne    80212c <insert_sorted_allocList+0xf5>
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
		break;

	}
	}
}
  802313:	90                   	nop
  802314:	c9                   	leave  
  802315:	c3                   	ret    

00802316 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802316:	55                   	push   %ebp
  802317:	89 e5                	mov    %esp,%ebp
  802319:	83 ec 18             	sub    $0x18,%esp
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  80231c:	a1 38 41 80 00       	mov    0x804138,%eax
  802321:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802324:	e9 7c 01 00 00       	jmp    8024a5 <alloc_block_FF+0x18f>
		{
			// case 2
				if(element->size == size)
  802329:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232c:	8b 40 0c             	mov    0xc(%eax),%eax
  80232f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802332:	0f 85 90 00 00 00    	jne    8023c8 <alloc_block_FF+0xb2>
				{
					tmp_block=element;
  802338:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233b:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,element);
  80233e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802342:	75 17                	jne    80235b <alloc_block_FF+0x45>
  802344:	83 ec 04             	sub    $0x4,%esp
  802347:	68 fb 39 80 00       	push   $0x8039fb
  80234c:	68 ba 00 00 00       	push   $0xba
  802351:	68 53 39 80 00       	push   $0x803953
  802356:	e8 53 0b 00 00       	call   802eae <_panic>
  80235b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235e:	8b 00                	mov    (%eax),%eax
  802360:	85 c0                	test   %eax,%eax
  802362:	74 10                	je     802374 <alloc_block_FF+0x5e>
  802364:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802367:	8b 00                	mov    (%eax),%eax
  802369:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80236c:	8b 52 04             	mov    0x4(%edx),%edx
  80236f:	89 50 04             	mov    %edx,0x4(%eax)
  802372:	eb 0b                	jmp    80237f <alloc_block_FF+0x69>
  802374:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802377:	8b 40 04             	mov    0x4(%eax),%eax
  80237a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80237f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802382:	8b 40 04             	mov    0x4(%eax),%eax
  802385:	85 c0                	test   %eax,%eax
  802387:	74 0f                	je     802398 <alloc_block_FF+0x82>
  802389:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238c:	8b 40 04             	mov    0x4(%eax),%eax
  80238f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802392:	8b 12                	mov    (%edx),%edx
  802394:	89 10                	mov    %edx,(%eax)
  802396:	eb 0a                	jmp    8023a2 <alloc_block_FF+0x8c>
  802398:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239b:	8b 00                	mov    (%eax),%eax
  80239d:	a3 38 41 80 00       	mov    %eax,0x804138
  8023a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023b5:	a1 44 41 80 00       	mov    0x804144,%eax
  8023ba:	48                   	dec    %eax
  8023bb:	a3 44 41 80 00       	mov    %eax,0x804144
					return tmp_block;
  8023c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023c3:	e9 10 01 00 00       	jmp    8024d8 <alloc_block_FF+0x1c2>
				}
				 // case 3
				else if(element->size > size)
  8023c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8023ce:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023d1:	0f 86 c6 00 00 00    	jbe    80249d <alloc_block_FF+0x187>
				{
					// the new block are created
					tmp_block = AvailableMemBlocksList.lh_first ;
  8023d7:	a1 48 41 80 00       	mov    0x804148,%eax
  8023dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  8023df:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023e3:	75 17                	jne    8023fc <alloc_block_FF+0xe6>
  8023e5:	83 ec 04             	sub    $0x4,%esp
  8023e8:	68 fb 39 80 00       	push   $0x8039fb
  8023ed:	68 c2 00 00 00       	push   $0xc2
  8023f2:	68 53 39 80 00       	push   $0x803953
  8023f7:	e8 b2 0a 00 00       	call   802eae <_panic>
  8023fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ff:	8b 00                	mov    (%eax),%eax
  802401:	85 c0                	test   %eax,%eax
  802403:	74 10                	je     802415 <alloc_block_FF+0xff>
  802405:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802408:	8b 00                	mov    (%eax),%eax
  80240a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80240d:	8b 52 04             	mov    0x4(%edx),%edx
  802410:	89 50 04             	mov    %edx,0x4(%eax)
  802413:	eb 0b                	jmp    802420 <alloc_block_FF+0x10a>
  802415:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802418:	8b 40 04             	mov    0x4(%eax),%eax
  80241b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802420:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802423:	8b 40 04             	mov    0x4(%eax),%eax
  802426:	85 c0                	test   %eax,%eax
  802428:	74 0f                	je     802439 <alloc_block_FF+0x123>
  80242a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80242d:	8b 40 04             	mov    0x4(%eax),%eax
  802430:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802433:	8b 12                	mov    (%edx),%edx
  802435:	89 10                	mov    %edx,(%eax)
  802437:	eb 0a                	jmp    802443 <alloc_block_FF+0x12d>
  802439:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80243c:	8b 00                	mov    (%eax),%eax
  80243e:	a3 48 41 80 00       	mov    %eax,0x804148
  802443:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802446:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80244c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80244f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802456:	a1 54 41 80 00       	mov    0x804154,%eax
  80245b:	48                   	dec    %eax
  80245c:	a3 54 41 80 00       	mov    %eax,0x804154
					tmp_block->sva=element->sva;
  802461:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802464:	8b 50 08             	mov    0x8(%eax),%edx
  802467:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80246a:	89 50 08             	mov    %edx,0x8(%eax)
					tmp_block->size=size;
  80246d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802470:	8b 55 08             	mov    0x8(%ebp),%edx
  802473:	89 50 0c             	mov    %edx,0xc(%eax)
					//update block with remaining space
					element->size-=size;
  802476:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802479:	8b 40 0c             	mov    0xc(%eax),%eax
  80247c:	2b 45 08             	sub    0x8(%ebp),%eax
  80247f:	89 c2                	mov    %eax,%edx
  802481:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802484:	89 50 0c             	mov    %edx,0xc(%eax)
					element->sva = element->sva + size;
  802487:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248a:	8b 50 08             	mov    0x8(%eax),%edx
  80248d:	8b 45 08             	mov    0x8(%ebp),%eax
  802490:	01 c2                	add    %eax,%edx
  802492:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802495:	89 50 08             	mov    %edx,0x8(%eax)
					// return back the new block
					return tmp_block ;
  802498:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80249b:	eb 3b                	jmp    8024d8 <alloc_block_FF+0x1c2>
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  80249d:	a1 40 41 80 00       	mov    0x804140,%eax
  8024a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024a9:	74 07                	je     8024b2 <alloc_block_FF+0x19c>
  8024ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ae:	8b 00                	mov    (%eax),%eax
  8024b0:	eb 05                	jmp    8024b7 <alloc_block_FF+0x1a1>
  8024b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8024b7:	a3 40 41 80 00       	mov    %eax,0x804140
  8024bc:	a1 40 41 80 00       	mov    0x804140,%eax
  8024c1:	85 c0                	test   %eax,%eax
  8024c3:	0f 85 60 fe ff ff    	jne    802329 <alloc_block_FF+0x13>
  8024c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024cd:	0f 85 56 fe ff ff    	jne    802329 <alloc_block_FF+0x13>
					// return back the new block
					return tmp_block ;
				}
		}
		// case 1
	  return NULL ;}
  8024d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8024d8:	c9                   	leave  
  8024d9:	c3                   	ret    

008024da <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================

struct MemBlock *alloc_block_BF(uint32 size)
{
  8024da:	55                   	push   %ebp
  8024db:	89 e5                	mov    %esp,%ebp
  8024dd:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
  8024e0:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		LIST_FOREACH(element, &(FreeMemBlocksList))
  8024e7:	a1 38 41 80 00       	mov    0x804138,%eax
  8024ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024ef:	eb 3a                	jmp    80252b <alloc_block_BF+0x51>
		{
			if(element->size >= size)
  8024f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f4:	8b 40 0c             	mov    0xc(%eax),%eax
  8024f7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024fa:	72 27                	jb     802523 <alloc_block_BF+0x49>
			{
				if(best_size==-1)
  8024fc:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802500:	75 0b                	jne    80250d <alloc_block_BF+0x33>
					best_size= element->size;
  802502:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802505:	8b 40 0c             	mov    0xc(%eax),%eax
  802508:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80250b:	eb 16                	jmp    802523 <alloc_block_BF+0x49>
				else if(best_size >= element->size)
  80250d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802510:	8b 50 0c             	mov    0xc(%eax),%edx
  802513:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802516:	39 c2                	cmp    %eax,%edx
  802518:	77 09                	ja     802523 <alloc_block_BF+0x49>
					best_size=element->size;
  80251a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251d:	8b 40 0c             	mov    0xc(%eax),%eax
  802520:	89 45 f0             	mov    %eax,-0x10(%ebp)

struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802523:	a1 40 41 80 00       	mov    0x804140,%eax
  802528:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80252b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80252f:	74 07                	je     802538 <alloc_block_BF+0x5e>
  802531:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802534:	8b 00                	mov    (%eax),%eax
  802536:	eb 05                	jmp    80253d <alloc_block_BF+0x63>
  802538:	b8 00 00 00 00       	mov    $0x0,%eax
  80253d:	a3 40 41 80 00       	mov    %eax,0x804140
  802542:	a1 40 41 80 00       	mov    0x804140,%eax
  802547:	85 c0                	test   %eax,%eax
  802549:	75 a6                	jne    8024f1 <alloc_block_BF+0x17>
  80254b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80254f:	75 a0                	jne    8024f1 <alloc_block_BF+0x17>
					best_size= element->size;
				else if(best_size >= element->size)
					best_size=element->size;
			}
		}
		if(best_size != -1)
  802551:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802555:	0f 84 d3 01 00 00    	je     80272e <alloc_block_BF+0x254>
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  80255b:	a1 38 41 80 00       	mov    0x804138,%eax
  802560:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802563:	e9 98 01 00 00       	jmp    802700 <alloc_block_BF+0x226>
			{
			 if((best_size > size) && (best_size == element->size))
  802568:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80256b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80256e:	0f 86 da 00 00 00    	jbe    80264e <alloc_block_BF+0x174>
  802574:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802577:	8b 50 0c             	mov    0xc(%eax),%edx
  80257a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80257d:	39 c2                	cmp    %eax,%edx
  80257f:	0f 85 c9 00 00 00    	jne    80264e <alloc_block_BF+0x174>
			  {
				// the new block are created
			    tmp_block = AvailableMemBlocksList.lh_first ;
  802585:	a1 48 41 80 00       	mov    0x804148,%eax
  80258a:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  80258d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802591:	75 17                	jne    8025aa <alloc_block_BF+0xd0>
  802593:	83 ec 04             	sub    $0x4,%esp
  802596:	68 fb 39 80 00       	push   $0x8039fb
  80259b:	68 ea 00 00 00       	push   $0xea
  8025a0:	68 53 39 80 00       	push   $0x803953
  8025a5:	e8 04 09 00 00       	call   802eae <_panic>
  8025aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ad:	8b 00                	mov    (%eax),%eax
  8025af:	85 c0                	test   %eax,%eax
  8025b1:	74 10                	je     8025c3 <alloc_block_BF+0xe9>
  8025b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025b6:	8b 00                	mov    (%eax),%eax
  8025b8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025bb:	8b 52 04             	mov    0x4(%edx),%edx
  8025be:	89 50 04             	mov    %edx,0x4(%eax)
  8025c1:	eb 0b                	jmp    8025ce <alloc_block_BF+0xf4>
  8025c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025c6:	8b 40 04             	mov    0x4(%eax),%eax
  8025c9:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8025ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025d1:	8b 40 04             	mov    0x4(%eax),%eax
  8025d4:	85 c0                	test   %eax,%eax
  8025d6:	74 0f                	je     8025e7 <alloc_block_BF+0x10d>
  8025d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025db:	8b 40 04             	mov    0x4(%eax),%eax
  8025de:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025e1:	8b 12                	mov    (%edx),%edx
  8025e3:	89 10                	mov    %edx,(%eax)
  8025e5:	eb 0a                	jmp    8025f1 <alloc_block_BF+0x117>
  8025e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ea:	8b 00                	mov    (%eax),%eax
  8025ec:	a3 48 41 80 00       	mov    %eax,0x804148
  8025f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802604:	a1 54 41 80 00       	mov    0x804154,%eax
  802609:	48                   	dec    %eax
  80260a:	a3 54 41 80 00       	mov    %eax,0x804154
				tmp_block->sva=element->sva;
  80260f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802612:	8b 50 08             	mov    0x8(%eax),%edx
  802615:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802618:	89 50 08             	mov    %edx,0x8(%eax)
				tmp_block->size=size;
  80261b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80261e:	8b 55 08             	mov    0x8(%ebp),%edx
  802621:	89 50 0c             	mov    %edx,0xc(%eax)
				//update block with remaining space
				element->size-=size;
  802624:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802627:	8b 40 0c             	mov    0xc(%eax),%eax
  80262a:	2b 45 08             	sub    0x8(%ebp),%eax
  80262d:	89 c2                	mov    %eax,%edx
  80262f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802632:	89 50 0c             	mov    %edx,0xc(%eax)
				element->sva = element->sva + size;
  802635:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802638:	8b 50 08             	mov    0x8(%eax),%edx
  80263b:	8b 45 08             	mov    0x8(%ebp),%eax
  80263e:	01 c2                	add    %eax,%edx
  802640:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802643:	89 50 08             	mov    %edx,0x8(%eax)
				// return back the new block
				return tmp_block ;
  802646:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802649:	e9 e5 00 00 00       	jmp    802733 <alloc_block_BF+0x259>

			  }
			else if((element->size == best_size)&&(best_size == size))
  80264e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802651:	8b 50 0c             	mov    0xc(%eax),%edx
  802654:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802657:	39 c2                	cmp    %eax,%edx
  802659:	0f 85 99 00 00 00    	jne    8026f8 <alloc_block_BF+0x21e>
  80265f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802662:	3b 45 08             	cmp    0x8(%ebp),%eax
  802665:	0f 85 8d 00 00 00    	jne    8026f8 <alloc_block_BF+0x21e>
			  {
				tmp_block=element;
  80266b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266e:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&FreeMemBlocksList,element);
  802671:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802675:	75 17                	jne    80268e <alloc_block_BF+0x1b4>
  802677:	83 ec 04             	sub    $0x4,%esp
  80267a:	68 fb 39 80 00       	push   $0x8039fb
  80267f:	68 f7 00 00 00       	push   $0xf7
  802684:	68 53 39 80 00       	push   $0x803953
  802689:	e8 20 08 00 00       	call   802eae <_panic>
  80268e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802691:	8b 00                	mov    (%eax),%eax
  802693:	85 c0                	test   %eax,%eax
  802695:	74 10                	je     8026a7 <alloc_block_BF+0x1cd>
  802697:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269a:	8b 00                	mov    (%eax),%eax
  80269c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80269f:	8b 52 04             	mov    0x4(%edx),%edx
  8026a2:	89 50 04             	mov    %edx,0x4(%eax)
  8026a5:	eb 0b                	jmp    8026b2 <alloc_block_BF+0x1d8>
  8026a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026aa:	8b 40 04             	mov    0x4(%eax),%eax
  8026ad:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8026b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b5:	8b 40 04             	mov    0x4(%eax),%eax
  8026b8:	85 c0                	test   %eax,%eax
  8026ba:	74 0f                	je     8026cb <alloc_block_BF+0x1f1>
  8026bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bf:	8b 40 04             	mov    0x4(%eax),%eax
  8026c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026c5:	8b 12                	mov    (%edx),%edx
  8026c7:	89 10                	mov    %edx,(%eax)
  8026c9:	eb 0a                	jmp    8026d5 <alloc_block_BF+0x1fb>
  8026cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ce:	8b 00                	mov    (%eax),%eax
  8026d0:	a3 38 41 80 00       	mov    %eax,0x804138
  8026d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026e8:	a1 44 41 80 00       	mov    0x804144,%eax
  8026ed:	48                   	dec    %eax
  8026ee:	a3 44 41 80 00       	mov    %eax,0x804144
				return tmp_block;
  8026f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026f6:	eb 3b                	jmp    802733 <alloc_block_BF+0x259>
					best_size=element->size;
			}
		}
		if(best_size != -1)
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  8026f8:	a1 40 41 80 00       	mov    0x804140,%eax
  8026fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802700:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802704:	74 07                	je     80270d <alloc_block_BF+0x233>
  802706:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802709:	8b 00                	mov    (%eax),%eax
  80270b:	eb 05                	jmp    802712 <alloc_block_BF+0x238>
  80270d:	b8 00 00 00 00       	mov    $0x0,%eax
  802712:	a3 40 41 80 00       	mov    %eax,0x804140
  802717:	a1 40 41 80 00       	mov    0x804140,%eax
  80271c:	85 c0                	test   %eax,%eax
  80271e:	0f 85 44 fe ff ff    	jne    802568 <alloc_block_BF+0x8e>
  802724:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802728:	0f 85 3a fe ff ff    	jne    802568 <alloc_block_BF+0x8e>
				LIST_REMOVE(&FreeMemBlocksList,element);
				return tmp_block;
			 }
			}
		}
		return NULL ;}
  80272e:	b8 00 00 00 00       	mov    $0x0,%eax
  802733:	c9                   	leave  
  802734:	c3                   	ret    

00802735 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802735:	55                   	push   %ebp
  802736:	89 e5                	mov    %esp,%ebp
  802738:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  80273b:	83 ec 04             	sub    $0x4,%esp
  80273e:	68 1c 3a 80 00       	push   $0x803a1c
  802743:	68 04 01 00 00       	push   $0x104
  802748:	68 53 39 80 00       	push   $0x803953
  80274d:	e8 5c 07 00 00       	call   802eae <_panic>

00802752 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{struct MemBlock * blk_itr;
  802752:	55                   	push   %ebp
  802753:	89 e5                	mov    %esp,%ebp
  802755:	83 ec 18             	sub    $0x18,%esp
struct MemBlock * next;
struct MemBlock * first = LIST_FIRST(&(FreeMemBlocksList));
  802758:	a1 38 41 80 00       	mov    0x804138,%eax
  80275d:	89 45 f0             	mov    %eax,-0x10(%ebp)
struct MemBlock * last = LIST_LAST(&(FreeMemBlocksList));
  802760:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802765:	89 45 ec             	mov    %eax,-0x14(%ebp)

if(LIST_EMPTY(&(FreeMemBlocksList)))
  802768:	a1 38 41 80 00       	mov    0x804138,%eax
  80276d:	85 c0                	test   %eax,%eax
  80276f:	75 68                	jne    8027d9 <insert_sorted_with_merge_freeList+0x87>
			{

				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  802771:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802775:	75 17                	jne    80278e <insert_sorted_with_merge_freeList+0x3c>
  802777:	83 ec 04             	sub    $0x4,%esp
  80277a:	68 30 39 80 00       	push   $0x803930
  80277f:	68 14 01 00 00       	push   $0x114
  802784:	68 53 39 80 00       	push   $0x803953
  802789:	e8 20 07 00 00       	call   802eae <_panic>
  80278e:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802794:	8b 45 08             	mov    0x8(%ebp),%eax
  802797:	89 10                	mov    %edx,(%eax)
  802799:	8b 45 08             	mov    0x8(%ebp),%eax
  80279c:	8b 00                	mov    (%eax),%eax
  80279e:	85 c0                	test   %eax,%eax
  8027a0:	74 0d                	je     8027af <insert_sorted_with_merge_freeList+0x5d>
  8027a2:	a1 38 41 80 00       	mov    0x804138,%eax
  8027a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8027aa:	89 50 04             	mov    %edx,0x4(%eax)
  8027ad:	eb 08                	jmp    8027b7 <insert_sorted_with_merge_freeList+0x65>
  8027af:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b2:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8027b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ba:	a3 38 41 80 00       	mov    %eax,0x804138
  8027bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027c9:	a1 44 41 80 00       	mov    0x804144,%eax
  8027ce:	40                   	inc    %eax
  8027cf:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  8027d4:	e9 d2 06 00 00       	jmp    802eab <insert_sorted_with_merge_freeList+0x759>
				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);

			}
else
{
	if( blockToInsert->sva  < first->sva )
  8027d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027dc:	8b 50 08             	mov    0x8(%eax),%edx
  8027df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e2:	8b 40 08             	mov    0x8(%eax),%eax
  8027e5:	39 c2                	cmp    %eax,%edx
  8027e7:	0f 83 22 01 00 00    	jae    80290f <insert_sorted_with_merge_freeList+0x1bd>
	{
                if( blockToInsert->sva + blockToInsert->size == first->sva)
  8027ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f0:	8b 50 08             	mov    0x8(%eax),%edx
  8027f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f6:	8b 40 0c             	mov    0xc(%eax),%eax
  8027f9:	01 c2                	add    %eax,%edx
  8027fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027fe:	8b 40 08             	mov    0x8(%eax),%eax
  802801:	39 c2                	cmp    %eax,%edx
  802803:	0f 85 9e 00 00 00    	jne    8028a7 <insert_sorted_with_merge_freeList+0x155>
                {

                	first->sva = blockToInsert->sva;
  802809:	8b 45 08             	mov    0x8(%ebp),%eax
  80280c:	8b 50 08             	mov    0x8(%eax),%edx
  80280f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802812:	89 50 08             	mov    %edx,0x8(%eax)
                	first->size = first->size + blockToInsert->size;
  802815:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802818:	8b 50 0c             	mov    0xc(%eax),%edx
  80281b:	8b 45 08             	mov    0x8(%ebp),%eax
  80281e:	8b 40 0c             	mov    0xc(%eax),%eax
  802821:	01 c2                	add    %eax,%edx
  802823:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802826:	89 50 0c             	mov    %edx,0xc(%eax)
                	blockToInsert->size = blockToInsert->sva = 0;
  802829:	8b 45 08             	mov    0x8(%ebp),%eax
  80282c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802833:	8b 45 08             	mov    0x8(%ebp),%eax
  802836:	8b 50 08             	mov    0x8(%eax),%edx
  802839:	8b 45 08             	mov    0x8(%ebp),%eax
  80283c:	89 50 0c             	mov    %edx,0xc(%eax)
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  80283f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802843:	75 17                	jne    80285c <insert_sorted_with_merge_freeList+0x10a>
  802845:	83 ec 04             	sub    $0x4,%esp
  802848:	68 30 39 80 00       	push   $0x803930
  80284d:	68 21 01 00 00       	push   $0x121
  802852:	68 53 39 80 00       	push   $0x803953
  802857:	e8 52 06 00 00       	call   802eae <_panic>
  80285c:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802862:	8b 45 08             	mov    0x8(%ebp),%eax
  802865:	89 10                	mov    %edx,(%eax)
  802867:	8b 45 08             	mov    0x8(%ebp),%eax
  80286a:	8b 00                	mov    (%eax),%eax
  80286c:	85 c0                	test   %eax,%eax
  80286e:	74 0d                	je     80287d <insert_sorted_with_merge_freeList+0x12b>
  802870:	a1 48 41 80 00       	mov    0x804148,%eax
  802875:	8b 55 08             	mov    0x8(%ebp),%edx
  802878:	89 50 04             	mov    %edx,0x4(%eax)
  80287b:	eb 08                	jmp    802885 <insert_sorted_with_merge_freeList+0x133>
  80287d:	8b 45 08             	mov    0x8(%ebp),%eax
  802880:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802885:	8b 45 08             	mov    0x8(%ebp),%eax
  802888:	a3 48 41 80 00       	mov    %eax,0x804148
  80288d:	8b 45 08             	mov    0x8(%ebp),%eax
  802890:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802897:	a1 54 41 80 00       	mov    0x804154,%eax
  80289c:	40                   	inc    %eax
  80289d:	a3 54 41 80 00       	mov    %eax,0x804154
						}
				}
        }

}
}
  8028a2:	e9 04 06 00 00       	jmp    802eab <insert_sorted_with_merge_freeList+0x759>
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
                }

                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  8028a7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028ab:	75 17                	jne    8028c4 <insert_sorted_with_merge_freeList+0x172>
  8028ad:	83 ec 04             	sub    $0x4,%esp
  8028b0:	68 30 39 80 00       	push   $0x803930
  8028b5:	68 26 01 00 00       	push   $0x126
  8028ba:	68 53 39 80 00       	push   $0x803953
  8028bf:	e8 ea 05 00 00       	call   802eae <_panic>
  8028c4:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8028ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8028cd:	89 10                	mov    %edx,(%eax)
  8028cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d2:	8b 00                	mov    (%eax),%eax
  8028d4:	85 c0                	test   %eax,%eax
  8028d6:	74 0d                	je     8028e5 <insert_sorted_with_merge_freeList+0x193>
  8028d8:	a1 38 41 80 00       	mov    0x804138,%eax
  8028dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8028e0:	89 50 04             	mov    %edx,0x4(%eax)
  8028e3:	eb 08                	jmp    8028ed <insert_sorted_with_merge_freeList+0x19b>
  8028e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e8:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8028ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f0:	a3 38 41 80 00       	mov    %eax,0x804138
  8028f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028ff:	a1 44 41 80 00       	mov    0x804144,%eax
  802904:	40                   	inc    %eax
  802905:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  80290a:	e9 9c 05 00 00       	jmp    802eab <insert_sorted_with_merge_freeList+0x759>
                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
                }
	}
    else if(blockToInsert->sva > last->sva)
  80290f:	8b 45 08             	mov    0x8(%ebp),%eax
  802912:	8b 50 08             	mov    0x8(%eax),%edx
  802915:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802918:	8b 40 08             	mov    0x8(%eax),%eax
  80291b:	39 c2                	cmp    %eax,%edx
  80291d:	0f 86 16 01 00 00    	jbe    802a39 <insert_sorted_with_merge_freeList+0x2e7>
 	{

				if(last->sva + last->size == blockToInsert->sva)
  802923:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802926:	8b 50 08             	mov    0x8(%eax),%edx
  802929:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80292c:	8b 40 0c             	mov    0xc(%eax),%eax
  80292f:	01 c2                	add    %eax,%edx
  802931:	8b 45 08             	mov    0x8(%ebp),%eax
  802934:	8b 40 08             	mov    0x8(%eax),%eax
  802937:	39 c2                	cmp    %eax,%edx
  802939:	0f 85 92 00 00 00    	jne    8029d1 <insert_sorted_with_merge_freeList+0x27f>
				{

					last->size = last->size + blockToInsert->size;
  80293f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802942:	8b 50 0c             	mov    0xc(%eax),%edx
  802945:	8b 45 08             	mov    0x8(%ebp),%eax
  802948:	8b 40 0c             	mov    0xc(%eax),%eax
  80294b:	01 c2                	add    %eax,%edx
  80294d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802950:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->size = blockToInsert->sva = 0;
  802953:	8b 45 08             	mov    0x8(%ebp),%eax
  802956:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80295d:	8b 45 08             	mov    0x8(%ebp),%eax
  802960:	8b 50 08             	mov    0x8(%eax),%edx
  802963:	8b 45 08             	mov    0x8(%ebp),%eax
  802966:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802969:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80296d:	75 17                	jne    802986 <insert_sorted_with_merge_freeList+0x234>
  80296f:	83 ec 04             	sub    $0x4,%esp
  802972:	68 30 39 80 00       	push   $0x803930
  802977:	68 31 01 00 00       	push   $0x131
  80297c:	68 53 39 80 00       	push   $0x803953
  802981:	e8 28 05 00 00       	call   802eae <_panic>
  802986:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80298c:	8b 45 08             	mov    0x8(%ebp),%eax
  80298f:	89 10                	mov    %edx,(%eax)
  802991:	8b 45 08             	mov    0x8(%ebp),%eax
  802994:	8b 00                	mov    (%eax),%eax
  802996:	85 c0                	test   %eax,%eax
  802998:	74 0d                	je     8029a7 <insert_sorted_with_merge_freeList+0x255>
  80299a:	a1 48 41 80 00       	mov    0x804148,%eax
  80299f:	8b 55 08             	mov    0x8(%ebp),%edx
  8029a2:	89 50 04             	mov    %edx,0x4(%eax)
  8029a5:	eb 08                	jmp    8029af <insert_sorted_with_merge_freeList+0x25d>
  8029a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029aa:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8029af:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b2:	a3 48 41 80 00       	mov    %eax,0x804148
  8029b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029c1:	a1 54 41 80 00       	mov    0x804154,%eax
  8029c6:	40                   	inc    %eax
  8029c7:	a3 54 41 80 00       	mov    %eax,0x804154
						}
				}
        }

}
}
  8029cc:	e9 da 04 00 00       	jmp    802eab <insert_sorted_with_merge_freeList+0x759>

				}

				else
				{
					LIST_INSERT_TAIL(&(FreeMemBlocksList),  blockToInsert);
  8029d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029d5:	75 17                	jne    8029ee <insert_sorted_with_merge_freeList+0x29c>
  8029d7:	83 ec 04             	sub    $0x4,%esp
  8029da:	68 d8 39 80 00       	push   $0x8039d8
  8029df:	68 37 01 00 00       	push   $0x137
  8029e4:	68 53 39 80 00       	push   $0x803953
  8029e9:	e8 c0 04 00 00       	call   802eae <_panic>
  8029ee:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  8029f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f7:	89 50 04             	mov    %edx,0x4(%eax)
  8029fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8029fd:	8b 40 04             	mov    0x4(%eax),%eax
  802a00:	85 c0                	test   %eax,%eax
  802a02:	74 0c                	je     802a10 <insert_sorted_with_merge_freeList+0x2be>
  802a04:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a09:	8b 55 08             	mov    0x8(%ebp),%edx
  802a0c:	89 10                	mov    %edx,(%eax)
  802a0e:	eb 08                	jmp    802a18 <insert_sorted_with_merge_freeList+0x2c6>
  802a10:	8b 45 08             	mov    0x8(%ebp),%eax
  802a13:	a3 38 41 80 00       	mov    %eax,0x804138
  802a18:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a20:	8b 45 08             	mov    0x8(%ebp),%eax
  802a23:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a29:	a1 44 41 80 00       	mov    0x804144,%eax
  802a2e:	40                   	inc    %eax
  802a2f:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  802a34:	e9 72 04 00 00       	jmp    802eab <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  802a39:	a1 38 41 80 00       	mov    0x804138,%eax
  802a3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a41:	e9 35 04 00 00       	jmp    802e7b <insert_sorted_with_merge_freeList+0x729>
				{
				     next=LIST_NEXT(blk_itr);
  802a46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a49:	8b 00                	mov    (%eax),%eax
  802a4b:	89 45 e8             	mov    %eax,-0x18(%ebp)


					if( (blockToInsert->sva > blk_itr->sva) )
  802a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a51:	8b 50 08             	mov    0x8(%eax),%edx
  802a54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a57:	8b 40 08             	mov    0x8(%eax),%eax
  802a5a:	39 c2                	cmp    %eax,%edx
  802a5c:	0f 86 11 04 00 00    	jbe    802e73 <insert_sorted_with_merge_freeList+0x721>
						{
							if(((blk_itr->sva) + (blk_itr->size) < blockToInsert->sva && (blockToInsert->sva) + (blockToInsert->size) < next->sva))
  802a62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a65:	8b 50 08             	mov    0x8(%eax),%edx
  802a68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6b:	8b 40 0c             	mov    0xc(%eax),%eax
  802a6e:	01 c2                	add    %eax,%edx
  802a70:	8b 45 08             	mov    0x8(%ebp),%eax
  802a73:	8b 40 08             	mov    0x8(%eax),%eax
  802a76:	39 c2                	cmp    %eax,%edx
  802a78:	0f 83 8b 00 00 00    	jae    802b09 <insert_sorted_with_merge_freeList+0x3b7>
  802a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a81:	8b 50 08             	mov    0x8(%eax),%edx
  802a84:	8b 45 08             	mov    0x8(%ebp),%eax
  802a87:	8b 40 0c             	mov    0xc(%eax),%eax
  802a8a:	01 c2                	add    %eax,%edx
  802a8c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a8f:	8b 40 08             	mov    0x8(%eax),%eax
  802a92:	39 c2                	cmp    %eax,%edx
  802a94:	73 73                	jae    802b09 <insert_sorted_with_merge_freeList+0x3b7>
							{
								LIST_INSERT_AFTER(&(FreeMemBlocksList), blk_itr, blockToInsert);
  802a96:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a9a:	74 06                	je     802aa2 <insert_sorted_with_merge_freeList+0x350>
  802a9c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802aa0:	75 17                	jne    802ab9 <insert_sorted_with_merge_freeList+0x367>
  802aa2:	83 ec 04             	sub    $0x4,%esp
  802aa5:	68 a4 39 80 00       	push   $0x8039a4
  802aaa:	68 48 01 00 00       	push   $0x148
  802aaf:	68 53 39 80 00       	push   $0x803953
  802ab4:	e8 f5 03 00 00       	call   802eae <_panic>
  802ab9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abc:	8b 10                	mov    (%eax),%edx
  802abe:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac1:	89 10                	mov    %edx,(%eax)
  802ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac6:	8b 00                	mov    (%eax),%eax
  802ac8:	85 c0                	test   %eax,%eax
  802aca:	74 0b                	je     802ad7 <insert_sorted_with_merge_freeList+0x385>
  802acc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acf:	8b 00                	mov    (%eax),%eax
  802ad1:	8b 55 08             	mov    0x8(%ebp),%edx
  802ad4:	89 50 04             	mov    %edx,0x4(%eax)
  802ad7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ada:	8b 55 08             	mov    0x8(%ebp),%edx
  802add:	89 10                	mov    %edx,(%eax)
  802adf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ae5:	89 50 04             	mov    %edx,0x4(%eax)
  802ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  802aeb:	8b 00                	mov    (%eax),%eax
  802aed:	85 c0                	test   %eax,%eax
  802aef:	75 08                	jne    802af9 <insert_sorted_with_merge_freeList+0x3a7>
  802af1:	8b 45 08             	mov    0x8(%ebp),%eax
  802af4:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802af9:	a1 44 41 80 00       	mov    0x804144,%eax
  802afe:	40                   	inc    %eax
  802aff:	a3 44 41 80 00       	mov    %eax,0x804144
								break;
  802b04:	e9 a2 03 00 00       	jmp    802eab <insert_sorted_with_merge_freeList+0x759>

							}
							else if((blockToInsert->sva + blockToInsert->size) < next->sva  && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  802b09:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0c:	8b 50 08             	mov    0x8(%eax),%edx
  802b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b12:	8b 40 0c             	mov    0xc(%eax),%eax
  802b15:	01 c2                	add    %eax,%edx
  802b17:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b1a:	8b 40 08             	mov    0x8(%eax),%eax
  802b1d:	39 c2                	cmp    %eax,%edx
  802b1f:	0f 83 ae 00 00 00    	jae    802bd3 <insert_sorted_with_merge_freeList+0x481>
  802b25:	8b 45 08             	mov    0x8(%ebp),%eax
  802b28:	8b 50 08             	mov    0x8(%eax),%edx
  802b2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2e:	8b 48 08             	mov    0x8(%eax),%ecx
  802b31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b34:	8b 40 0c             	mov    0xc(%eax),%eax
  802b37:	01 c8                	add    %ecx,%eax
  802b39:	39 c2                	cmp    %eax,%edx
  802b3b:	0f 85 92 00 00 00    	jne    802bd3 <insert_sorted_with_merge_freeList+0x481>
							{

								blk_itr->size=blk_itr->size+blockToInsert->size;
  802b41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b44:	8b 50 0c             	mov    0xc(%eax),%edx
  802b47:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4a:	8b 40 0c             	mov    0xc(%eax),%eax
  802b4d:	01 c2                	add    %eax,%edx
  802b4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b52:	89 50 0c             	mov    %edx,0xc(%eax)
								 blockToInsert->size=blockToInsert->sva=0;
  802b55:	8b 45 08             	mov    0x8(%ebp),%eax
  802b58:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b62:	8b 50 08             	mov    0x8(%eax),%edx
  802b65:	8b 45 08             	mov    0x8(%ebp),%eax
  802b68:	89 50 0c             	mov    %edx,0xc(%eax)
								 LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802b6b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b6f:	75 17                	jne    802b88 <insert_sorted_with_merge_freeList+0x436>
  802b71:	83 ec 04             	sub    $0x4,%esp
  802b74:	68 30 39 80 00       	push   $0x803930
  802b79:	68 51 01 00 00       	push   $0x151
  802b7e:	68 53 39 80 00       	push   $0x803953
  802b83:	e8 26 03 00 00       	call   802eae <_panic>
  802b88:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b91:	89 10                	mov    %edx,(%eax)
  802b93:	8b 45 08             	mov    0x8(%ebp),%eax
  802b96:	8b 00                	mov    (%eax),%eax
  802b98:	85 c0                	test   %eax,%eax
  802b9a:	74 0d                	je     802ba9 <insert_sorted_with_merge_freeList+0x457>
  802b9c:	a1 48 41 80 00       	mov    0x804148,%eax
  802ba1:	8b 55 08             	mov    0x8(%ebp),%edx
  802ba4:	89 50 04             	mov    %edx,0x4(%eax)
  802ba7:	eb 08                	jmp    802bb1 <insert_sorted_with_merge_freeList+0x45f>
  802ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bac:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb4:	a3 48 41 80 00       	mov    %eax,0x804148
  802bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bc3:	a1 54 41 80 00       	mov    0x804154,%eax
  802bc8:	40                   	inc    %eax
  802bc9:	a3 54 41 80 00       	mov    %eax,0x804154
								 break;
  802bce:	e9 d8 02 00 00       	jmp    802eab <insert_sorted_with_merge_freeList+0x759>

							}
							else if( (blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva > (blk_itr->sva + blk_itr->size))
  802bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd6:	8b 50 08             	mov    0x8(%eax),%edx
  802bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdc:	8b 40 0c             	mov    0xc(%eax),%eax
  802bdf:	01 c2                	add    %eax,%edx
  802be1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802be4:	8b 40 08             	mov    0x8(%eax),%eax
  802be7:	39 c2                	cmp    %eax,%edx
  802be9:	0f 85 ba 00 00 00    	jne    802ca9 <insert_sorted_with_merge_freeList+0x557>
  802bef:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf2:	8b 50 08             	mov    0x8(%eax),%edx
  802bf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf8:	8b 48 08             	mov    0x8(%eax),%ecx
  802bfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfe:	8b 40 0c             	mov    0xc(%eax),%eax
  802c01:	01 c8                	add    %ecx,%eax
  802c03:	39 c2                	cmp    %eax,%edx
  802c05:	0f 86 9e 00 00 00    	jbe    802ca9 <insert_sorted_with_merge_freeList+0x557>
							{
								next->size = next->size + blockToInsert->size;
  802c0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c0e:	8b 50 0c             	mov    0xc(%eax),%edx
  802c11:	8b 45 08             	mov    0x8(%ebp),%eax
  802c14:	8b 40 0c             	mov    0xc(%eax),%eax
  802c17:	01 c2                	add    %eax,%edx
  802c19:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c1c:	89 50 0c             	mov    %edx,0xc(%eax)
								next->sva = blockToInsert->sva;
  802c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c22:	8b 50 08             	mov    0x8(%eax),%edx
  802c25:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c28:	89 50 08             	mov    %edx,0x8(%eax)

								blockToInsert->size = blockToInsert->sva = 0;
  802c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802c35:	8b 45 08             	mov    0x8(%ebp),%eax
  802c38:	8b 50 08             	mov    0x8(%eax),%edx
  802c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3e:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802c41:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c45:	75 17                	jne    802c5e <insert_sorted_with_merge_freeList+0x50c>
  802c47:	83 ec 04             	sub    $0x4,%esp
  802c4a:	68 30 39 80 00       	push   $0x803930
  802c4f:	68 5b 01 00 00       	push   $0x15b
  802c54:	68 53 39 80 00       	push   $0x803953
  802c59:	e8 50 02 00 00       	call   802eae <_panic>
  802c5e:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c64:	8b 45 08             	mov    0x8(%ebp),%eax
  802c67:	89 10                	mov    %edx,(%eax)
  802c69:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6c:	8b 00                	mov    (%eax),%eax
  802c6e:	85 c0                	test   %eax,%eax
  802c70:	74 0d                	je     802c7f <insert_sorted_with_merge_freeList+0x52d>
  802c72:	a1 48 41 80 00       	mov    0x804148,%eax
  802c77:	8b 55 08             	mov    0x8(%ebp),%edx
  802c7a:	89 50 04             	mov    %edx,0x4(%eax)
  802c7d:	eb 08                	jmp    802c87 <insert_sorted_with_merge_freeList+0x535>
  802c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c82:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c87:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8a:	a3 48 41 80 00       	mov    %eax,0x804148
  802c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c92:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c99:	a1 54 41 80 00       	mov    0x804154,%eax
  802c9e:	40                   	inc    %eax
  802c9f:	a3 54 41 80 00       	mov    %eax,0x804154
								break;
  802ca4:	e9 02 02 00 00       	jmp    802eab <insert_sorted_with_merge_freeList+0x759>
							}
							else if ((blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  802ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cac:	8b 50 08             	mov    0x8(%eax),%edx
  802caf:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb2:	8b 40 0c             	mov    0xc(%eax),%eax
  802cb5:	01 c2                	add    %eax,%edx
  802cb7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cba:	8b 40 08             	mov    0x8(%eax),%eax
  802cbd:	39 c2                	cmp    %eax,%edx
  802cbf:	0f 85 ae 01 00 00    	jne    802e73 <insert_sorted_with_merge_freeList+0x721>
  802cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc8:	8b 50 08             	mov    0x8(%eax),%edx
  802ccb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cce:	8b 48 08             	mov    0x8(%eax),%ecx
  802cd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd4:	8b 40 0c             	mov    0xc(%eax),%eax
  802cd7:	01 c8                	add    %ecx,%eax
  802cd9:	39 c2                	cmp    %eax,%edx
  802cdb:	0f 85 92 01 00 00    	jne    802e73 <insert_sorted_with_merge_freeList+0x721>
							{
								blk_itr->size = blk_itr->size + blockToInsert->size + next->size;
  802ce1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce4:	8b 50 0c             	mov    0xc(%eax),%edx
  802ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cea:	8b 40 0c             	mov    0xc(%eax),%eax
  802ced:	01 c2                	add    %eax,%edx
  802cef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cf2:	8b 40 0c             	mov    0xc(%eax),%eax
  802cf5:	01 c2                	add    %eax,%edx
  802cf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfa:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size = blockToInsert->sva=0;
  802cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  802d00:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802d07:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0a:	8b 50 08             	mov    0x8(%eax),%edx
  802d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d10:	89 50 0c             	mov    %edx,0xc(%eax)
								next->size = next->sva = 0;
  802d13:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d16:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802d1d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d20:	8b 50 08             	mov    0x8(%eax),%edx
  802d23:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d26:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_REMOVE(&FreeMemBlocksList, next);
  802d29:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802d2d:	75 17                	jne    802d46 <insert_sorted_with_merge_freeList+0x5f4>
  802d2f:	83 ec 04             	sub    $0x4,%esp
  802d32:	68 fb 39 80 00       	push   $0x8039fb
  802d37:	68 63 01 00 00       	push   $0x163
  802d3c:	68 53 39 80 00       	push   $0x803953
  802d41:	e8 68 01 00 00       	call   802eae <_panic>
  802d46:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d49:	8b 00                	mov    (%eax),%eax
  802d4b:	85 c0                	test   %eax,%eax
  802d4d:	74 10                	je     802d5f <insert_sorted_with_merge_freeList+0x60d>
  802d4f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d52:	8b 00                	mov    (%eax),%eax
  802d54:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d57:	8b 52 04             	mov    0x4(%edx),%edx
  802d5a:	89 50 04             	mov    %edx,0x4(%eax)
  802d5d:	eb 0b                	jmp    802d6a <insert_sorted_with_merge_freeList+0x618>
  802d5f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d62:	8b 40 04             	mov    0x4(%eax),%eax
  802d65:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802d6a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d6d:	8b 40 04             	mov    0x4(%eax),%eax
  802d70:	85 c0                	test   %eax,%eax
  802d72:	74 0f                	je     802d83 <insert_sorted_with_merge_freeList+0x631>
  802d74:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d77:	8b 40 04             	mov    0x4(%eax),%eax
  802d7a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d7d:	8b 12                	mov    (%edx),%edx
  802d7f:	89 10                	mov    %edx,(%eax)
  802d81:	eb 0a                	jmp    802d8d <insert_sorted_with_merge_freeList+0x63b>
  802d83:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d86:	8b 00                	mov    (%eax),%eax
  802d88:	a3 38 41 80 00       	mov    %eax,0x804138
  802d8d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d90:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d96:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d99:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802da0:	a1 44 41 80 00       	mov    0x804144,%eax
  802da5:	48                   	dec    %eax
  802da6:	a3 44 41 80 00       	mov    %eax,0x804144
								LIST_INSERT_HEAD(&AvailableMemBlocksList, next );
  802dab:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802daf:	75 17                	jne    802dc8 <insert_sorted_with_merge_freeList+0x676>
  802db1:	83 ec 04             	sub    $0x4,%esp
  802db4:	68 30 39 80 00       	push   $0x803930
  802db9:	68 64 01 00 00       	push   $0x164
  802dbe:	68 53 39 80 00       	push   $0x803953
  802dc3:	e8 e6 00 00 00       	call   802eae <_panic>
  802dc8:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802dce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dd1:	89 10                	mov    %edx,(%eax)
  802dd3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dd6:	8b 00                	mov    (%eax),%eax
  802dd8:	85 c0                	test   %eax,%eax
  802dda:	74 0d                	je     802de9 <insert_sorted_with_merge_freeList+0x697>
  802ddc:	a1 48 41 80 00       	mov    0x804148,%eax
  802de1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802de4:	89 50 04             	mov    %edx,0x4(%eax)
  802de7:	eb 08                	jmp    802df1 <insert_sorted_with_merge_freeList+0x69f>
  802de9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dec:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802df1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802df4:	a3 48 41 80 00       	mov    %eax,0x804148
  802df9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dfc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e03:	a1 54 41 80 00       	mov    0x804154,%eax
  802e08:	40                   	inc    %eax
  802e09:	a3 54 41 80 00       	mov    %eax,0x804154
							    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802e0e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e12:	75 17                	jne    802e2b <insert_sorted_with_merge_freeList+0x6d9>
  802e14:	83 ec 04             	sub    $0x4,%esp
  802e17:	68 30 39 80 00       	push   $0x803930
  802e1c:	68 65 01 00 00       	push   $0x165
  802e21:	68 53 39 80 00       	push   $0x803953
  802e26:	e8 83 00 00 00       	call   802eae <_panic>
  802e2b:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e31:	8b 45 08             	mov    0x8(%ebp),%eax
  802e34:	89 10                	mov    %edx,(%eax)
  802e36:	8b 45 08             	mov    0x8(%ebp),%eax
  802e39:	8b 00                	mov    (%eax),%eax
  802e3b:	85 c0                	test   %eax,%eax
  802e3d:	74 0d                	je     802e4c <insert_sorted_with_merge_freeList+0x6fa>
  802e3f:	a1 48 41 80 00       	mov    0x804148,%eax
  802e44:	8b 55 08             	mov    0x8(%ebp),%edx
  802e47:	89 50 04             	mov    %edx,0x4(%eax)
  802e4a:	eb 08                	jmp    802e54 <insert_sorted_with_merge_freeList+0x702>
  802e4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e54:	8b 45 08             	mov    0x8(%ebp),%eax
  802e57:	a3 48 41 80 00       	mov    %eax,0x804148
  802e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e66:	a1 54 41 80 00       	mov    0x804154,%eax
  802e6b:	40                   	inc    %eax
  802e6c:	a3 54 41 80 00       	mov    %eax,0x804154
								break;
  802e71:	eb 38                	jmp    802eab <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  802e73:	a1 40 41 80 00       	mov    0x804140,%eax
  802e78:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e7b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e7f:	74 07                	je     802e88 <insert_sorted_with_merge_freeList+0x736>
  802e81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e84:	8b 00                	mov    (%eax),%eax
  802e86:	eb 05                	jmp    802e8d <insert_sorted_with_merge_freeList+0x73b>
  802e88:	b8 00 00 00 00       	mov    $0x0,%eax
  802e8d:	a3 40 41 80 00       	mov    %eax,0x804140
  802e92:	a1 40 41 80 00       	mov    0x804140,%eax
  802e97:	85 c0                	test   %eax,%eax
  802e99:	0f 85 a7 fb ff ff    	jne    802a46 <insert_sorted_with_merge_freeList+0x2f4>
  802e9f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ea3:	0f 85 9d fb ff ff    	jne    802a46 <insert_sorted_with_merge_freeList+0x2f4>
						}
				}
        }

}
}
  802ea9:	eb 00                	jmp    802eab <insert_sorted_with_merge_freeList+0x759>
  802eab:	90                   	nop
  802eac:	c9                   	leave  
  802ead:	c3                   	ret    

00802eae <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  802eae:	55                   	push   %ebp
  802eaf:	89 e5                	mov    %esp,%ebp
  802eb1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  802eb4:	8d 45 10             	lea    0x10(%ebp),%eax
  802eb7:	83 c0 04             	add    $0x4,%eax
  802eba:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  802ebd:	a1 5c 41 80 00       	mov    0x80415c,%eax
  802ec2:	85 c0                	test   %eax,%eax
  802ec4:	74 16                	je     802edc <_panic+0x2e>
		cprintf("%s: ", argv0);
  802ec6:	a1 5c 41 80 00       	mov    0x80415c,%eax
  802ecb:	83 ec 08             	sub    $0x8,%esp
  802ece:	50                   	push   %eax
  802ecf:	68 4c 3a 80 00       	push   $0x803a4c
  802ed4:	e8 81 d5 ff ff       	call   80045a <cprintf>
  802ed9:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  802edc:	a1 00 40 80 00       	mov    0x804000,%eax
  802ee1:	ff 75 0c             	pushl  0xc(%ebp)
  802ee4:	ff 75 08             	pushl  0x8(%ebp)
  802ee7:	50                   	push   %eax
  802ee8:	68 51 3a 80 00       	push   $0x803a51
  802eed:	e8 68 d5 ff ff       	call   80045a <cprintf>
  802ef2:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  802ef5:	8b 45 10             	mov    0x10(%ebp),%eax
  802ef8:	83 ec 08             	sub    $0x8,%esp
  802efb:	ff 75 f4             	pushl  -0xc(%ebp)
  802efe:	50                   	push   %eax
  802eff:	e8 eb d4 ff ff       	call   8003ef <vcprintf>
  802f04:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  802f07:	83 ec 08             	sub    $0x8,%esp
  802f0a:	6a 00                	push   $0x0
  802f0c:	68 6d 3a 80 00       	push   $0x803a6d
  802f11:	e8 d9 d4 ff ff       	call   8003ef <vcprintf>
  802f16:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  802f19:	e8 5a d4 ff ff       	call   800378 <exit>

	// should not return here
	while (1) ;
  802f1e:	eb fe                	jmp    802f1e <_panic+0x70>

00802f20 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  802f20:	55                   	push   %ebp
  802f21:	89 e5                	mov    %esp,%ebp
  802f23:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  802f26:	a1 20 40 80 00       	mov    0x804020,%eax
  802f2b:	8b 50 74             	mov    0x74(%eax),%edx
  802f2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f31:	39 c2                	cmp    %eax,%edx
  802f33:	74 14                	je     802f49 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  802f35:	83 ec 04             	sub    $0x4,%esp
  802f38:	68 70 3a 80 00       	push   $0x803a70
  802f3d:	6a 26                	push   $0x26
  802f3f:	68 bc 3a 80 00       	push   $0x803abc
  802f44:	e8 65 ff ff ff       	call   802eae <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  802f49:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  802f50:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802f57:	e9 c2 00 00 00       	jmp    80301e <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  802f5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f5f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802f66:	8b 45 08             	mov    0x8(%ebp),%eax
  802f69:	01 d0                	add    %edx,%eax
  802f6b:	8b 00                	mov    (%eax),%eax
  802f6d:	85 c0                	test   %eax,%eax
  802f6f:	75 08                	jne    802f79 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  802f71:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  802f74:	e9 a2 00 00 00       	jmp    80301b <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  802f79:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802f80:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802f87:	eb 69                	jmp    802ff2 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  802f89:	a1 20 40 80 00       	mov    0x804020,%eax
  802f8e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  802f94:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f97:	89 d0                	mov    %edx,%eax
  802f99:	01 c0                	add    %eax,%eax
  802f9b:	01 d0                	add    %edx,%eax
  802f9d:	c1 e0 03             	shl    $0x3,%eax
  802fa0:	01 c8                	add    %ecx,%eax
  802fa2:	8a 40 04             	mov    0x4(%eax),%al
  802fa5:	84 c0                	test   %al,%al
  802fa7:	75 46                	jne    802fef <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  802fa9:	a1 20 40 80 00       	mov    0x804020,%eax
  802fae:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  802fb4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fb7:	89 d0                	mov    %edx,%eax
  802fb9:	01 c0                	add    %eax,%eax
  802fbb:	01 d0                	add    %edx,%eax
  802fbd:	c1 e0 03             	shl    $0x3,%eax
  802fc0:	01 c8                	add    %ecx,%eax
  802fc2:	8b 00                	mov    (%eax),%eax
  802fc4:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802fc7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fca:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802fcf:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  802fd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fd4:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  802fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fde:	01 c8                	add    %ecx,%eax
  802fe0:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  802fe2:	39 c2                	cmp    %eax,%edx
  802fe4:	75 09                	jne    802fef <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  802fe6:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  802fed:	eb 12                	jmp    803001 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802fef:	ff 45 e8             	incl   -0x18(%ebp)
  802ff2:	a1 20 40 80 00       	mov    0x804020,%eax
  802ff7:	8b 50 74             	mov    0x74(%eax),%edx
  802ffa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ffd:	39 c2                	cmp    %eax,%edx
  802fff:	77 88                	ja     802f89 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803001:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803005:	75 14                	jne    80301b <CheckWSWithoutLastIndex+0xfb>
			panic(
  803007:	83 ec 04             	sub    $0x4,%esp
  80300a:	68 c8 3a 80 00       	push   $0x803ac8
  80300f:	6a 3a                	push   $0x3a
  803011:	68 bc 3a 80 00       	push   $0x803abc
  803016:	e8 93 fe ff ff       	call   802eae <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80301b:	ff 45 f0             	incl   -0x10(%ebp)
  80301e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803021:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803024:	0f 8c 32 ff ff ff    	jl     802f5c <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80302a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803031:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803038:	eb 26                	jmp    803060 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80303a:	a1 20 40 80 00       	mov    0x804020,%eax
  80303f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803045:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803048:	89 d0                	mov    %edx,%eax
  80304a:	01 c0                	add    %eax,%eax
  80304c:	01 d0                	add    %edx,%eax
  80304e:	c1 e0 03             	shl    $0x3,%eax
  803051:	01 c8                	add    %ecx,%eax
  803053:	8a 40 04             	mov    0x4(%eax),%al
  803056:	3c 01                	cmp    $0x1,%al
  803058:	75 03                	jne    80305d <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80305a:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80305d:	ff 45 e0             	incl   -0x20(%ebp)
  803060:	a1 20 40 80 00       	mov    0x804020,%eax
  803065:	8b 50 74             	mov    0x74(%eax),%edx
  803068:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80306b:	39 c2                	cmp    %eax,%edx
  80306d:	77 cb                	ja     80303a <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80306f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803072:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803075:	74 14                	je     80308b <CheckWSWithoutLastIndex+0x16b>
		panic(
  803077:	83 ec 04             	sub    $0x4,%esp
  80307a:	68 1c 3b 80 00       	push   $0x803b1c
  80307f:	6a 44                	push   $0x44
  803081:	68 bc 3a 80 00       	push   $0x803abc
  803086:	e8 23 fe ff ff       	call   802eae <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80308b:	90                   	nop
  80308c:	c9                   	leave  
  80308d:	c3                   	ret    
  80308e:	66 90                	xchg   %ax,%ax

00803090 <__udivdi3>:
  803090:	55                   	push   %ebp
  803091:	57                   	push   %edi
  803092:	56                   	push   %esi
  803093:	53                   	push   %ebx
  803094:	83 ec 1c             	sub    $0x1c,%esp
  803097:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80309b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80309f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8030a3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8030a7:	89 ca                	mov    %ecx,%edx
  8030a9:	89 f8                	mov    %edi,%eax
  8030ab:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8030af:	85 f6                	test   %esi,%esi
  8030b1:	75 2d                	jne    8030e0 <__udivdi3+0x50>
  8030b3:	39 cf                	cmp    %ecx,%edi
  8030b5:	77 65                	ja     80311c <__udivdi3+0x8c>
  8030b7:	89 fd                	mov    %edi,%ebp
  8030b9:	85 ff                	test   %edi,%edi
  8030bb:	75 0b                	jne    8030c8 <__udivdi3+0x38>
  8030bd:	b8 01 00 00 00       	mov    $0x1,%eax
  8030c2:	31 d2                	xor    %edx,%edx
  8030c4:	f7 f7                	div    %edi
  8030c6:	89 c5                	mov    %eax,%ebp
  8030c8:	31 d2                	xor    %edx,%edx
  8030ca:	89 c8                	mov    %ecx,%eax
  8030cc:	f7 f5                	div    %ebp
  8030ce:	89 c1                	mov    %eax,%ecx
  8030d0:	89 d8                	mov    %ebx,%eax
  8030d2:	f7 f5                	div    %ebp
  8030d4:	89 cf                	mov    %ecx,%edi
  8030d6:	89 fa                	mov    %edi,%edx
  8030d8:	83 c4 1c             	add    $0x1c,%esp
  8030db:	5b                   	pop    %ebx
  8030dc:	5e                   	pop    %esi
  8030dd:	5f                   	pop    %edi
  8030de:	5d                   	pop    %ebp
  8030df:	c3                   	ret    
  8030e0:	39 ce                	cmp    %ecx,%esi
  8030e2:	77 28                	ja     80310c <__udivdi3+0x7c>
  8030e4:	0f bd fe             	bsr    %esi,%edi
  8030e7:	83 f7 1f             	xor    $0x1f,%edi
  8030ea:	75 40                	jne    80312c <__udivdi3+0x9c>
  8030ec:	39 ce                	cmp    %ecx,%esi
  8030ee:	72 0a                	jb     8030fa <__udivdi3+0x6a>
  8030f0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8030f4:	0f 87 9e 00 00 00    	ja     803198 <__udivdi3+0x108>
  8030fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8030ff:	89 fa                	mov    %edi,%edx
  803101:	83 c4 1c             	add    $0x1c,%esp
  803104:	5b                   	pop    %ebx
  803105:	5e                   	pop    %esi
  803106:	5f                   	pop    %edi
  803107:	5d                   	pop    %ebp
  803108:	c3                   	ret    
  803109:	8d 76 00             	lea    0x0(%esi),%esi
  80310c:	31 ff                	xor    %edi,%edi
  80310e:	31 c0                	xor    %eax,%eax
  803110:	89 fa                	mov    %edi,%edx
  803112:	83 c4 1c             	add    $0x1c,%esp
  803115:	5b                   	pop    %ebx
  803116:	5e                   	pop    %esi
  803117:	5f                   	pop    %edi
  803118:	5d                   	pop    %ebp
  803119:	c3                   	ret    
  80311a:	66 90                	xchg   %ax,%ax
  80311c:	89 d8                	mov    %ebx,%eax
  80311e:	f7 f7                	div    %edi
  803120:	31 ff                	xor    %edi,%edi
  803122:	89 fa                	mov    %edi,%edx
  803124:	83 c4 1c             	add    $0x1c,%esp
  803127:	5b                   	pop    %ebx
  803128:	5e                   	pop    %esi
  803129:	5f                   	pop    %edi
  80312a:	5d                   	pop    %ebp
  80312b:	c3                   	ret    
  80312c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803131:	89 eb                	mov    %ebp,%ebx
  803133:	29 fb                	sub    %edi,%ebx
  803135:	89 f9                	mov    %edi,%ecx
  803137:	d3 e6                	shl    %cl,%esi
  803139:	89 c5                	mov    %eax,%ebp
  80313b:	88 d9                	mov    %bl,%cl
  80313d:	d3 ed                	shr    %cl,%ebp
  80313f:	89 e9                	mov    %ebp,%ecx
  803141:	09 f1                	or     %esi,%ecx
  803143:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803147:	89 f9                	mov    %edi,%ecx
  803149:	d3 e0                	shl    %cl,%eax
  80314b:	89 c5                	mov    %eax,%ebp
  80314d:	89 d6                	mov    %edx,%esi
  80314f:	88 d9                	mov    %bl,%cl
  803151:	d3 ee                	shr    %cl,%esi
  803153:	89 f9                	mov    %edi,%ecx
  803155:	d3 e2                	shl    %cl,%edx
  803157:	8b 44 24 08          	mov    0x8(%esp),%eax
  80315b:	88 d9                	mov    %bl,%cl
  80315d:	d3 e8                	shr    %cl,%eax
  80315f:	09 c2                	or     %eax,%edx
  803161:	89 d0                	mov    %edx,%eax
  803163:	89 f2                	mov    %esi,%edx
  803165:	f7 74 24 0c          	divl   0xc(%esp)
  803169:	89 d6                	mov    %edx,%esi
  80316b:	89 c3                	mov    %eax,%ebx
  80316d:	f7 e5                	mul    %ebp
  80316f:	39 d6                	cmp    %edx,%esi
  803171:	72 19                	jb     80318c <__udivdi3+0xfc>
  803173:	74 0b                	je     803180 <__udivdi3+0xf0>
  803175:	89 d8                	mov    %ebx,%eax
  803177:	31 ff                	xor    %edi,%edi
  803179:	e9 58 ff ff ff       	jmp    8030d6 <__udivdi3+0x46>
  80317e:	66 90                	xchg   %ax,%ax
  803180:	8b 54 24 08          	mov    0x8(%esp),%edx
  803184:	89 f9                	mov    %edi,%ecx
  803186:	d3 e2                	shl    %cl,%edx
  803188:	39 c2                	cmp    %eax,%edx
  80318a:	73 e9                	jae    803175 <__udivdi3+0xe5>
  80318c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80318f:	31 ff                	xor    %edi,%edi
  803191:	e9 40 ff ff ff       	jmp    8030d6 <__udivdi3+0x46>
  803196:	66 90                	xchg   %ax,%ax
  803198:	31 c0                	xor    %eax,%eax
  80319a:	e9 37 ff ff ff       	jmp    8030d6 <__udivdi3+0x46>
  80319f:	90                   	nop

008031a0 <__umoddi3>:
  8031a0:	55                   	push   %ebp
  8031a1:	57                   	push   %edi
  8031a2:	56                   	push   %esi
  8031a3:	53                   	push   %ebx
  8031a4:	83 ec 1c             	sub    $0x1c,%esp
  8031a7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8031ab:	8b 74 24 34          	mov    0x34(%esp),%esi
  8031af:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8031b3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8031b7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8031bb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8031bf:	89 f3                	mov    %esi,%ebx
  8031c1:	89 fa                	mov    %edi,%edx
  8031c3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8031c7:	89 34 24             	mov    %esi,(%esp)
  8031ca:	85 c0                	test   %eax,%eax
  8031cc:	75 1a                	jne    8031e8 <__umoddi3+0x48>
  8031ce:	39 f7                	cmp    %esi,%edi
  8031d0:	0f 86 a2 00 00 00    	jbe    803278 <__umoddi3+0xd8>
  8031d6:	89 c8                	mov    %ecx,%eax
  8031d8:	89 f2                	mov    %esi,%edx
  8031da:	f7 f7                	div    %edi
  8031dc:	89 d0                	mov    %edx,%eax
  8031de:	31 d2                	xor    %edx,%edx
  8031e0:	83 c4 1c             	add    $0x1c,%esp
  8031e3:	5b                   	pop    %ebx
  8031e4:	5e                   	pop    %esi
  8031e5:	5f                   	pop    %edi
  8031e6:	5d                   	pop    %ebp
  8031e7:	c3                   	ret    
  8031e8:	39 f0                	cmp    %esi,%eax
  8031ea:	0f 87 ac 00 00 00    	ja     80329c <__umoddi3+0xfc>
  8031f0:	0f bd e8             	bsr    %eax,%ebp
  8031f3:	83 f5 1f             	xor    $0x1f,%ebp
  8031f6:	0f 84 ac 00 00 00    	je     8032a8 <__umoddi3+0x108>
  8031fc:	bf 20 00 00 00       	mov    $0x20,%edi
  803201:	29 ef                	sub    %ebp,%edi
  803203:	89 fe                	mov    %edi,%esi
  803205:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803209:	89 e9                	mov    %ebp,%ecx
  80320b:	d3 e0                	shl    %cl,%eax
  80320d:	89 d7                	mov    %edx,%edi
  80320f:	89 f1                	mov    %esi,%ecx
  803211:	d3 ef                	shr    %cl,%edi
  803213:	09 c7                	or     %eax,%edi
  803215:	89 e9                	mov    %ebp,%ecx
  803217:	d3 e2                	shl    %cl,%edx
  803219:	89 14 24             	mov    %edx,(%esp)
  80321c:	89 d8                	mov    %ebx,%eax
  80321e:	d3 e0                	shl    %cl,%eax
  803220:	89 c2                	mov    %eax,%edx
  803222:	8b 44 24 08          	mov    0x8(%esp),%eax
  803226:	d3 e0                	shl    %cl,%eax
  803228:	89 44 24 04          	mov    %eax,0x4(%esp)
  80322c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803230:	89 f1                	mov    %esi,%ecx
  803232:	d3 e8                	shr    %cl,%eax
  803234:	09 d0                	or     %edx,%eax
  803236:	d3 eb                	shr    %cl,%ebx
  803238:	89 da                	mov    %ebx,%edx
  80323a:	f7 f7                	div    %edi
  80323c:	89 d3                	mov    %edx,%ebx
  80323e:	f7 24 24             	mull   (%esp)
  803241:	89 c6                	mov    %eax,%esi
  803243:	89 d1                	mov    %edx,%ecx
  803245:	39 d3                	cmp    %edx,%ebx
  803247:	0f 82 87 00 00 00    	jb     8032d4 <__umoddi3+0x134>
  80324d:	0f 84 91 00 00 00    	je     8032e4 <__umoddi3+0x144>
  803253:	8b 54 24 04          	mov    0x4(%esp),%edx
  803257:	29 f2                	sub    %esi,%edx
  803259:	19 cb                	sbb    %ecx,%ebx
  80325b:	89 d8                	mov    %ebx,%eax
  80325d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803261:	d3 e0                	shl    %cl,%eax
  803263:	89 e9                	mov    %ebp,%ecx
  803265:	d3 ea                	shr    %cl,%edx
  803267:	09 d0                	or     %edx,%eax
  803269:	89 e9                	mov    %ebp,%ecx
  80326b:	d3 eb                	shr    %cl,%ebx
  80326d:	89 da                	mov    %ebx,%edx
  80326f:	83 c4 1c             	add    $0x1c,%esp
  803272:	5b                   	pop    %ebx
  803273:	5e                   	pop    %esi
  803274:	5f                   	pop    %edi
  803275:	5d                   	pop    %ebp
  803276:	c3                   	ret    
  803277:	90                   	nop
  803278:	89 fd                	mov    %edi,%ebp
  80327a:	85 ff                	test   %edi,%edi
  80327c:	75 0b                	jne    803289 <__umoddi3+0xe9>
  80327e:	b8 01 00 00 00       	mov    $0x1,%eax
  803283:	31 d2                	xor    %edx,%edx
  803285:	f7 f7                	div    %edi
  803287:	89 c5                	mov    %eax,%ebp
  803289:	89 f0                	mov    %esi,%eax
  80328b:	31 d2                	xor    %edx,%edx
  80328d:	f7 f5                	div    %ebp
  80328f:	89 c8                	mov    %ecx,%eax
  803291:	f7 f5                	div    %ebp
  803293:	89 d0                	mov    %edx,%eax
  803295:	e9 44 ff ff ff       	jmp    8031de <__umoddi3+0x3e>
  80329a:	66 90                	xchg   %ax,%ax
  80329c:	89 c8                	mov    %ecx,%eax
  80329e:	89 f2                	mov    %esi,%edx
  8032a0:	83 c4 1c             	add    $0x1c,%esp
  8032a3:	5b                   	pop    %ebx
  8032a4:	5e                   	pop    %esi
  8032a5:	5f                   	pop    %edi
  8032a6:	5d                   	pop    %ebp
  8032a7:	c3                   	ret    
  8032a8:	3b 04 24             	cmp    (%esp),%eax
  8032ab:	72 06                	jb     8032b3 <__umoddi3+0x113>
  8032ad:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8032b1:	77 0f                	ja     8032c2 <__umoddi3+0x122>
  8032b3:	89 f2                	mov    %esi,%edx
  8032b5:	29 f9                	sub    %edi,%ecx
  8032b7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8032bb:	89 14 24             	mov    %edx,(%esp)
  8032be:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8032c2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8032c6:	8b 14 24             	mov    (%esp),%edx
  8032c9:	83 c4 1c             	add    $0x1c,%esp
  8032cc:	5b                   	pop    %ebx
  8032cd:	5e                   	pop    %esi
  8032ce:	5f                   	pop    %edi
  8032cf:	5d                   	pop    %ebp
  8032d0:	c3                   	ret    
  8032d1:	8d 76 00             	lea    0x0(%esi),%esi
  8032d4:	2b 04 24             	sub    (%esp),%eax
  8032d7:	19 fa                	sbb    %edi,%edx
  8032d9:	89 d1                	mov    %edx,%ecx
  8032db:	89 c6                	mov    %eax,%esi
  8032dd:	e9 71 ff ff ff       	jmp    803253 <__umoddi3+0xb3>
  8032e2:	66 90                	xchg   %ax,%ax
  8032e4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8032e8:	72 ea                	jb     8032d4 <__umoddi3+0x134>
  8032ea:	89 d9                	mov    %ebx,%ecx
  8032ec:	e9 62 ff ff ff       	jmp    803253 <__umoddi3+0xb3>
