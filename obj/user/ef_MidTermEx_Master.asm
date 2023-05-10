
obj/user/ef_MidTermEx_Master:     file format elf32-i386


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
  800031:	e8 b4 01 00 00       	call   8001ea <libmain>
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
  800045:	68 60 33 80 00       	push   $0x803360
  80004a:	e8 06 16 00 00       	call   801655 <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*X = 5 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 05 00 00 00    	movl   $0x5,(%eax)

	/*[2] SPECIFY WHETHER TO USE SEMAPHORE OR NOT*/
	//cprintf("Do you want to use semaphore (y/n)? ") ;
	//char select = getchar() ;
	char select = 'y';
  80005e:	c6 45 f3 79          	movb   $0x79,-0xd(%ebp)
	//cputchar(select);
	//cputchar('\n');

	/*[3] SHARE THIS SELECTION WITH OTHER PROCESSES*/
	int *useSem = smalloc("useSem", sizeof(int) , 0) ;
  800062:	83 ec 04             	sub    $0x4,%esp
  800065:	6a 00                	push   $0x0
  800067:	6a 04                	push   $0x4
  800069:	68 62 33 80 00       	push   $0x803362
  80006e:	e8 e2 15 00 00       	call   801655 <smalloc>
  800073:	83 c4 10             	add    $0x10,%esp
  800076:	89 45 ec             	mov    %eax,-0x14(%ebp)
	*useSem = 0 ;
  800079:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80007c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	if (select == 'Y' || select == 'y')
  800082:	80 7d f3 59          	cmpb   $0x59,-0xd(%ebp)
  800086:	74 06                	je     80008e <_main+0x56>
  800088:	80 7d f3 79          	cmpb   $0x79,-0xd(%ebp)
  80008c:	75 09                	jne    800097 <_main+0x5f>
		*useSem = 1 ;
  80008e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800091:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	if (*useSem == 1)
  800097:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80009a:	8b 00                	mov    (%eax),%eax
  80009c:	83 f8 01             	cmp    $0x1,%eax
  80009f:	75 12                	jne    8000b3 <_main+0x7b>
	{
		sys_createSemaphore("T", 0);
  8000a1:	83 ec 08             	sub    $0x8,%esp
  8000a4:	6a 00                	push   $0x0
  8000a6:	68 69 33 80 00       	push   $0x803369
  8000ab:	e8 e5 19 00 00       	call   801a95 <sys_createSemaphore>
  8000b0:	83 c4 10             	add    $0x10,%esp
	}

	/*[4] CREATE AND RUN ProcessA & ProcessB*/

	//Create the check-finishing counter
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  8000b3:	83 ec 04             	sub    $0x4,%esp
  8000b6:	6a 01                	push   $0x1
  8000b8:	6a 04                	push   $0x4
  8000ba:	68 6b 33 80 00       	push   $0x80336b
  8000bf:	e8 91 15 00 00       	call   801655 <smalloc>
  8000c4:	83 c4 10             	add    $0x10,%esp
  8000c7:	89 45 e8             	mov    %eax,-0x18(%ebp)
	*numOfFinished = 0 ;
  8000ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	//Create the 2 processes
	int32 envIdProcessA = sys_create_env("midterm_a", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  8000d3:	a1 20 40 80 00       	mov    0x804020,%eax
  8000d8:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8000de:	89 c2                	mov    %eax,%edx
  8000e0:	a1 20 40 80 00       	mov    0x804020,%eax
  8000e5:	8b 40 74             	mov    0x74(%eax),%eax
  8000e8:	6a 32                	push   $0x32
  8000ea:	52                   	push   %edx
  8000eb:	50                   	push   %eax
  8000ec:	68 79 33 80 00       	push   $0x803379
  8000f1:	e8 b0 1a 00 00       	call   801ba6 <sys_create_env>
  8000f6:	83 c4 10             	add    $0x10,%esp
  8000f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int32 envIdProcessB = sys_create_env("midterm_b", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  8000fc:	a1 20 40 80 00       	mov    0x804020,%eax
  800101:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800107:	89 c2                	mov    %eax,%edx
  800109:	a1 20 40 80 00       	mov    0x804020,%eax
  80010e:	8b 40 74             	mov    0x74(%eax),%eax
  800111:	6a 32                	push   $0x32
  800113:	52                   	push   %edx
  800114:	50                   	push   %eax
  800115:	68 83 33 80 00       	push   $0x803383
  80011a:	e8 87 1a 00 00       	call   801ba6 <sys_create_env>
  80011f:	83 c4 10             	add    $0x10,%esp
  800122:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (envIdProcessA == E_ENV_CREATION_ERROR || envIdProcessB == E_ENV_CREATION_ERROR)
  800125:	83 7d e4 ef          	cmpl   $0xffffffef,-0x1c(%ebp)
  800129:	74 06                	je     800131 <_main+0xf9>
  80012b:	83 7d e0 ef          	cmpl   $0xffffffef,-0x20(%ebp)
  80012f:	75 14                	jne    800145 <_main+0x10d>
		panic("NO AVAILABLE ENVs...");
  800131:	83 ec 04             	sub    $0x4,%esp
  800134:	68 8d 33 80 00       	push   $0x80338d
  800139:	6a 27                	push   $0x27
  80013b:	68 a2 33 80 00       	push   $0x8033a2
  800140:	e8 e1 01 00 00       	call   800326 <_panic>

	//Run the 2 processes
	sys_run_env(envIdProcessA);
  800145:	83 ec 0c             	sub    $0xc,%esp
  800148:	ff 75 e4             	pushl  -0x1c(%ebp)
  80014b:	e8 74 1a 00 00       	call   801bc4 <sys_run_env>
  800150:	83 c4 10             	add    $0x10,%esp
	env_sleep(10000);
  800153:	83 ec 0c             	sub    $0xc,%esp
  800156:	68 10 27 00 00       	push   $0x2710
  80015b:	e8 ce 2e 00 00       	call   80302e <env_sleep>
  800160:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  800163:	83 ec 0c             	sub    $0xc,%esp
  800166:	ff 75 e0             	pushl  -0x20(%ebp)
  800169:	e8 56 1a 00 00       	call   801bc4 <sys_run_env>
  80016e:	83 c4 10             	add    $0x10,%esp

	/*[5] BUSY-WAIT TILL FINISHING BOTH PROCESSES*/
	while (*numOfFinished != 2) ;
  800171:	90                   	nop
  800172:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800175:	8b 00                	mov    (%eax),%eax
  800177:	83 f8 02             	cmp    $0x2,%eax
  80017a:	75 f6                	jne    800172 <_main+0x13a>

	/*[6] PRINT X*/
	cprintf("Final value of X = %d\n", *X);
  80017c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80017f:	8b 00                	mov    (%eax),%eax
  800181:	83 ec 08             	sub    $0x8,%esp
  800184:	50                   	push   %eax
  800185:	68 bd 33 80 00       	push   $0x8033bd
  80018a:	e8 4b 04 00 00       	call   8005da <cprintf>
  80018f:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  800192:	e8 96 1a 00 00       	call   801c2d <sys_getparentenvid>
  800197:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if(parentenvID > 0)
  80019a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80019e:	7e 47                	jle    8001e7 <_main+0x1af>
	{
		//Get the check-finishing counter
		int *AllFinish = NULL;
  8001a0:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		AllFinish = sget(parentenvID, "finishedCount") ;
  8001a7:	83 ec 08             	sub    $0x8,%esp
  8001aa:	68 6b 33 80 00       	push   $0x80336b
  8001af:	ff 75 dc             	pushl  -0x24(%ebp)
  8001b2:	e8 47 15 00 00       	call   8016fe <sget>
  8001b7:	83 c4 10             	add    $0x10,%esp
  8001ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
		sys_destroy_env(envIdProcessA);
  8001bd:	83 ec 0c             	sub    $0xc,%esp
  8001c0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001c3:	e8 18 1a 00 00       	call   801be0 <sys_destroy_env>
  8001c8:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(envIdProcessB);
  8001cb:	83 ec 0c             	sub    $0xc,%esp
  8001ce:	ff 75 e0             	pushl  -0x20(%ebp)
  8001d1:	e8 0a 1a 00 00       	call   801be0 <sys_destroy_env>
  8001d6:	83 c4 10             	add    $0x10,%esp
		(*AllFinish)++ ;
  8001d9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001dc:	8b 00                	mov    (%eax),%eax
  8001de:	8d 50 01             	lea    0x1(%eax),%edx
  8001e1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001e4:	89 10                	mov    %edx,(%eax)
	}

	return;
  8001e6:	90                   	nop
  8001e7:	90                   	nop
}
  8001e8:	c9                   	leave  
  8001e9:	c3                   	ret    

008001ea <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8001ea:	55                   	push   %ebp
  8001eb:	89 e5                	mov    %esp,%ebp
  8001ed:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8001f0:	e8 1f 1a 00 00       	call   801c14 <sys_getenvindex>
  8001f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8001f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001fb:	89 d0                	mov    %edx,%eax
  8001fd:	c1 e0 03             	shl    $0x3,%eax
  800200:	01 d0                	add    %edx,%eax
  800202:	01 c0                	add    %eax,%eax
  800204:	01 d0                	add    %edx,%eax
  800206:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80020d:	01 d0                	add    %edx,%eax
  80020f:	c1 e0 04             	shl    $0x4,%eax
  800212:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800217:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80021c:	a1 20 40 80 00       	mov    0x804020,%eax
  800221:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800227:	84 c0                	test   %al,%al
  800229:	74 0f                	je     80023a <libmain+0x50>
		binaryname = myEnv->prog_name;
  80022b:	a1 20 40 80 00       	mov    0x804020,%eax
  800230:	05 5c 05 00 00       	add    $0x55c,%eax
  800235:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80023a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80023e:	7e 0a                	jle    80024a <libmain+0x60>
		binaryname = argv[0];
  800240:	8b 45 0c             	mov    0xc(%ebp),%eax
  800243:	8b 00                	mov    (%eax),%eax
  800245:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  80024a:	83 ec 08             	sub    $0x8,%esp
  80024d:	ff 75 0c             	pushl  0xc(%ebp)
  800250:	ff 75 08             	pushl  0x8(%ebp)
  800253:	e8 e0 fd ff ff       	call   800038 <_main>
  800258:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80025b:	e8 c1 17 00 00       	call   801a21 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800260:	83 ec 0c             	sub    $0xc,%esp
  800263:	68 ec 33 80 00       	push   $0x8033ec
  800268:	e8 6d 03 00 00       	call   8005da <cprintf>
  80026d:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800270:	a1 20 40 80 00       	mov    0x804020,%eax
  800275:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80027b:	a1 20 40 80 00       	mov    0x804020,%eax
  800280:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800286:	83 ec 04             	sub    $0x4,%esp
  800289:	52                   	push   %edx
  80028a:	50                   	push   %eax
  80028b:	68 14 34 80 00       	push   $0x803414
  800290:	e8 45 03 00 00       	call   8005da <cprintf>
  800295:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800298:	a1 20 40 80 00       	mov    0x804020,%eax
  80029d:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8002a3:	a1 20 40 80 00       	mov    0x804020,%eax
  8002a8:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8002ae:	a1 20 40 80 00       	mov    0x804020,%eax
  8002b3:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8002b9:	51                   	push   %ecx
  8002ba:	52                   	push   %edx
  8002bb:	50                   	push   %eax
  8002bc:	68 3c 34 80 00       	push   $0x80343c
  8002c1:	e8 14 03 00 00       	call   8005da <cprintf>
  8002c6:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002c9:	a1 20 40 80 00       	mov    0x804020,%eax
  8002ce:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8002d4:	83 ec 08             	sub    $0x8,%esp
  8002d7:	50                   	push   %eax
  8002d8:	68 94 34 80 00       	push   $0x803494
  8002dd:	e8 f8 02 00 00       	call   8005da <cprintf>
  8002e2:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8002e5:	83 ec 0c             	sub    $0xc,%esp
  8002e8:	68 ec 33 80 00       	push   $0x8033ec
  8002ed:	e8 e8 02 00 00       	call   8005da <cprintf>
  8002f2:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8002f5:	e8 41 17 00 00       	call   801a3b <sys_enable_interrupt>

	// exit gracefully
	exit();
  8002fa:	e8 19 00 00 00       	call   800318 <exit>
}
  8002ff:	90                   	nop
  800300:	c9                   	leave  
  800301:	c3                   	ret    

00800302 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800302:	55                   	push   %ebp
  800303:	89 e5                	mov    %esp,%ebp
  800305:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800308:	83 ec 0c             	sub    $0xc,%esp
  80030b:	6a 00                	push   $0x0
  80030d:	e8 ce 18 00 00       	call   801be0 <sys_destroy_env>
  800312:	83 c4 10             	add    $0x10,%esp
}
  800315:	90                   	nop
  800316:	c9                   	leave  
  800317:	c3                   	ret    

00800318 <exit>:

void
exit(void)
{
  800318:	55                   	push   %ebp
  800319:	89 e5                	mov    %esp,%ebp
  80031b:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80031e:	e8 23 19 00 00       	call   801c46 <sys_exit_env>
}
  800323:	90                   	nop
  800324:	c9                   	leave  
  800325:	c3                   	ret    

00800326 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800326:	55                   	push   %ebp
  800327:	89 e5                	mov    %esp,%ebp
  800329:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80032c:	8d 45 10             	lea    0x10(%ebp),%eax
  80032f:	83 c0 04             	add    $0x4,%eax
  800332:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800335:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80033a:	85 c0                	test   %eax,%eax
  80033c:	74 16                	je     800354 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80033e:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800343:	83 ec 08             	sub    $0x8,%esp
  800346:	50                   	push   %eax
  800347:	68 a8 34 80 00       	push   $0x8034a8
  80034c:	e8 89 02 00 00       	call   8005da <cprintf>
  800351:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800354:	a1 00 40 80 00       	mov    0x804000,%eax
  800359:	ff 75 0c             	pushl  0xc(%ebp)
  80035c:	ff 75 08             	pushl  0x8(%ebp)
  80035f:	50                   	push   %eax
  800360:	68 ad 34 80 00       	push   $0x8034ad
  800365:	e8 70 02 00 00       	call   8005da <cprintf>
  80036a:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80036d:	8b 45 10             	mov    0x10(%ebp),%eax
  800370:	83 ec 08             	sub    $0x8,%esp
  800373:	ff 75 f4             	pushl  -0xc(%ebp)
  800376:	50                   	push   %eax
  800377:	e8 f3 01 00 00       	call   80056f <vcprintf>
  80037c:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80037f:	83 ec 08             	sub    $0x8,%esp
  800382:	6a 00                	push   $0x0
  800384:	68 c9 34 80 00       	push   $0x8034c9
  800389:	e8 e1 01 00 00       	call   80056f <vcprintf>
  80038e:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800391:	e8 82 ff ff ff       	call   800318 <exit>

	// should not return here
	while (1) ;
  800396:	eb fe                	jmp    800396 <_panic+0x70>

00800398 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800398:	55                   	push   %ebp
  800399:	89 e5                	mov    %esp,%ebp
  80039b:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80039e:	a1 20 40 80 00       	mov    0x804020,%eax
  8003a3:	8b 50 74             	mov    0x74(%eax),%edx
  8003a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003a9:	39 c2                	cmp    %eax,%edx
  8003ab:	74 14                	je     8003c1 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8003ad:	83 ec 04             	sub    $0x4,%esp
  8003b0:	68 cc 34 80 00       	push   $0x8034cc
  8003b5:	6a 26                	push   $0x26
  8003b7:	68 18 35 80 00       	push   $0x803518
  8003bc:	e8 65 ff ff ff       	call   800326 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8003c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8003c8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003cf:	e9 c2 00 00 00       	jmp    800496 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8003d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003d7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003de:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e1:	01 d0                	add    %edx,%eax
  8003e3:	8b 00                	mov    (%eax),%eax
  8003e5:	85 c0                	test   %eax,%eax
  8003e7:	75 08                	jne    8003f1 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8003e9:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003ec:	e9 a2 00 00 00       	jmp    800493 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8003f1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003f8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003ff:	eb 69                	jmp    80046a <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800401:	a1 20 40 80 00       	mov    0x804020,%eax
  800406:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80040c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80040f:	89 d0                	mov    %edx,%eax
  800411:	01 c0                	add    %eax,%eax
  800413:	01 d0                	add    %edx,%eax
  800415:	c1 e0 03             	shl    $0x3,%eax
  800418:	01 c8                	add    %ecx,%eax
  80041a:	8a 40 04             	mov    0x4(%eax),%al
  80041d:	84 c0                	test   %al,%al
  80041f:	75 46                	jne    800467 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800421:	a1 20 40 80 00       	mov    0x804020,%eax
  800426:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80042c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80042f:	89 d0                	mov    %edx,%eax
  800431:	01 c0                	add    %eax,%eax
  800433:	01 d0                	add    %edx,%eax
  800435:	c1 e0 03             	shl    $0x3,%eax
  800438:	01 c8                	add    %ecx,%eax
  80043a:	8b 00                	mov    (%eax),%eax
  80043c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80043f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800442:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800447:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800449:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80044c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800453:	8b 45 08             	mov    0x8(%ebp),%eax
  800456:	01 c8                	add    %ecx,%eax
  800458:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80045a:	39 c2                	cmp    %eax,%edx
  80045c:	75 09                	jne    800467 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80045e:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800465:	eb 12                	jmp    800479 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800467:	ff 45 e8             	incl   -0x18(%ebp)
  80046a:	a1 20 40 80 00       	mov    0x804020,%eax
  80046f:	8b 50 74             	mov    0x74(%eax),%edx
  800472:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800475:	39 c2                	cmp    %eax,%edx
  800477:	77 88                	ja     800401 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800479:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80047d:	75 14                	jne    800493 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80047f:	83 ec 04             	sub    $0x4,%esp
  800482:	68 24 35 80 00       	push   $0x803524
  800487:	6a 3a                	push   $0x3a
  800489:	68 18 35 80 00       	push   $0x803518
  80048e:	e8 93 fe ff ff       	call   800326 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800493:	ff 45 f0             	incl   -0x10(%ebp)
  800496:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800499:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80049c:	0f 8c 32 ff ff ff    	jl     8003d4 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8004a2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004a9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8004b0:	eb 26                	jmp    8004d8 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8004b2:	a1 20 40 80 00       	mov    0x804020,%eax
  8004b7:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8004bd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004c0:	89 d0                	mov    %edx,%eax
  8004c2:	01 c0                	add    %eax,%eax
  8004c4:	01 d0                	add    %edx,%eax
  8004c6:	c1 e0 03             	shl    $0x3,%eax
  8004c9:	01 c8                	add    %ecx,%eax
  8004cb:	8a 40 04             	mov    0x4(%eax),%al
  8004ce:	3c 01                	cmp    $0x1,%al
  8004d0:	75 03                	jne    8004d5 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8004d2:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004d5:	ff 45 e0             	incl   -0x20(%ebp)
  8004d8:	a1 20 40 80 00       	mov    0x804020,%eax
  8004dd:	8b 50 74             	mov    0x74(%eax),%edx
  8004e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004e3:	39 c2                	cmp    %eax,%edx
  8004e5:	77 cb                	ja     8004b2 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004ea:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004ed:	74 14                	je     800503 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8004ef:	83 ec 04             	sub    $0x4,%esp
  8004f2:	68 78 35 80 00       	push   $0x803578
  8004f7:	6a 44                	push   $0x44
  8004f9:	68 18 35 80 00       	push   $0x803518
  8004fe:	e8 23 fe ff ff       	call   800326 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800503:	90                   	nop
  800504:	c9                   	leave  
  800505:	c3                   	ret    

00800506 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800506:	55                   	push   %ebp
  800507:	89 e5                	mov    %esp,%ebp
  800509:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80050c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80050f:	8b 00                	mov    (%eax),%eax
  800511:	8d 48 01             	lea    0x1(%eax),%ecx
  800514:	8b 55 0c             	mov    0xc(%ebp),%edx
  800517:	89 0a                	mov    %ecx,(%edx)
  800519:	8b 55 08             	mov    0x8(%ebp),%edx
  80051c:	88 d1                	mov    %dl,%cl
  80051e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800521:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800525:	8b 45 0c             	mov    0xc(%ebp),%eax
  800528:	8b 00                	mov    (%eax),%eax
  80052a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80052f:	75 2c                	jne    80055d <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800531:	a0 24 40 80 00       	mov    0x804024,%al
  800536:	0f b6 c0             	movzbl %al,%eax
  800539:	8b 55 0c             	mov    0xc(%ebp),%edx
  80053c:	8b 12                	mov    (%edx),%edx
  80053e:	89 d1                	mov    %edx,%ecx
  800540:	8b 55 0c             	mov    0xc(%ebp),%edx
  800543:	83 c2 08             	add    $0x8,%edx
  800546:	83 ec 04             	sub    $0x4,%esp
  800549:	50                   	push   %eax
  80054a:	51                   	push   %ecx
  80054b:	52                   	push   %edx
  80054c:	e8 22 13 00 00       	call   801873 <sys_cputs>
  800551:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800554:	8b 45 0c             	mov    0xc(%ebp),%eax
  800557:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80055d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800560:	8b 40 04             	mov    0x4(%eax),%eax
  800563:	8d 50 01             	lea    0x1(%eax),%edx
  800566:	8b 45 0c             	mov    0xc(%ebp),%eax
  800569:	89 50 04             	mov    %edx,0x4(%eax)
}
  80056c:	90                   	nop
  80056d:	c9                   	leave  
  80056e:	c3                   	ret    

0080056f <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80056f:	55                   	push   %ebp
  800570:	89 e5                	mov    %esp,%ebp
  800572:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800578:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80057f:	00 00 00 
	b.cnt = 0;
  800582:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800589:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80058c:	ff 75 0c             	pushl  0xc(%ebp)
  80058f:	ff 75 08             	pushl  0x8(%ebp)
  800592:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800598:	50                   	push   %eax
  800599:	68 06 05 80 00       	push   $0x800506
  80059e:	e8 11 02 00 00       	call   8007b4 <vprintfmt>
  8005a3:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8005a6:	a0 24 40 80 00       	mov    0x804024,%al
  8005ab:	0f b6 c0             	movzbl %al,%eax
  8005ae:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8005b4:	83 ec 04             	sub    $0x4,%esp
  8005b7:	50                   	push   %eax
  8005b8:	52                   	push   %edx
  8005b9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005bf:	83 c0 08             	add    $0x8,%eax
  8005c2:	50                   	push   %eax
  8005c3:	e8 ab 12 00 00       	call   801873 <sys_cputs>
  8005c8:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005cb:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  8005d2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005d8:	c9                   	leave  
  8005d9:	c3                   	ret    

008005da <cprintf>:

int cprintf(const char *fmt, ...) {
  8005da:	55                   	push   %ebp
  8005db:	89 e5                	mov    %esp,%ebp
  8005dd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005e0:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  8005e7:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f0:	83 ec 08             	sub    $0x8,%esp
  8005f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8005f6:	50                   	push   %eax
  8005f7:	e8 73 ff ff ff       	call   80056f <vcprintf>
  8005fc:	83 c4 10             	add    $0x10,%esp
  8005ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800602:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800605:	c9                   	leave  
  800606:	c3                   	ret    

00800607 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800607:	55                   	push   %ebp
  800608:	89 e5                	mov    %esp,%ebp
  80060a:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80060d:	e8 0f 14 00 00       	call   801a21 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800612:	8d 45 0c             	lea    0xc(%ebp),%eax
  800615:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800618:	8b 45 08             	mov    0x8(%ebp),%eax
  80061b:	83 ec 08             	sub    $0x8,%esp
  80061e:	ff 75 f4             	pushl  -0xc(%ebp)
  800621:	50                   	push   %eax
  800622:	e8 48 ff ff ff       	call   80056f <vcprintf>
  800627:	83 c4 10             	add    $0x10,%esp
  80062a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80062d:	e8 09 14 00 00       	call   801a3b <sys_enable_interrupt>
	return cnt;
  800632:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800635:	c9                   	leave  
  800636:	c3                   	ret    

00800637 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800637:	55                   	push   %ebp
  800638:	89 e5                	mov    %esp,%ebp
  80063a:	53                   	push   %ebx
  80063b:	83 ec 14             	sub    $0x14,%esp
  80063e:	8b 45 10             	mov    0x10(%ebp),%eax
  800641:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800644:	8b 45 14             	mov    0x14(%ebp),%eax
  800647:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80064a:	8b 45 18             	mov    0x18(%ebp),%eax
  80064d:	ba 00 00 00 00       	mov    $0x0,%edx
  800652:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800655:	77 55                	ja     8006ac <printnum+0x75>
  800657:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80065a:	72 05                	jb     800661 <printnum+0x2a>
  80065c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80065f:	77 4b                	ja     8006ac <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800661:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800664:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800667:	8b 45 18             	mov    0x18(%ebp),%eax
  80066a:	ba 00 00 00 00       	mov    $0x0,%edx
  80066f:	52                   	push   %edx
  800670:	50                   	push   %eax
  800671:	ff 75 f4             	pushl  -0xc(%ebp)
  800674:	ff 75 f0             	pushl  -0x10(%ebp)
  800677:	e8 68 2a 00 00       	call   8030e4 <__udivdi3>
  80067c:	83 c4 10             	add    $0x10,%esp
  80067f:	83 ec 04             	sub    $0x4,%esp
  800682:	ff 75 20             	pushl  0x20(%ebp)
  800685:	53                   	push   %ebx
  800686:	ff 75 18             	pushl  0x18(%ebp)
  800689:	52                   	push   %edx
  80068a:	50                   	push   %eax
  80068b:	ff 75 0c             	pushl  0xc(%ebp)
  80068e:	ff 75 08             	pushl  0x8(%ebp)
  800691:	e8 a1 ff ff ff       	call   800637 <printnum>
  800696:	83 c4 20             	add    $0x20,%esp
  800699:	eb 1a                	jmp    8006b5 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80069b:	83 ec 08             	sub    $0x8,%esp
  80069e:	ff 75 0c             	pushl  0xc(%ebp)
  8006a1:	ff 75 20             	pushl  0x20(%ebp)
  8006a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a7:	ff d0                	call   *%eax
  8006a9:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006ac:	ff 4d 1c             	decl   0x1c(%ebp)
  8006af:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006b3:	7f e6                	jg     80069b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006b5:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006b8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006c3:	53                   	push   %ebx
  8006c4:	51                   	push   %ecx
  8006c5:	52                   	push   %edx
  8006c6:	50                   	push   %eax
  8006c7:	e8 28 2b 00 00       	call   8031f4 <__umoddi3>
  8006cc:	83 c4 10             	add    $0x10,%esp
  8006cf:	05 f4 37 80 00       	add    $0x8037f4,%eax
  8006d4:	8a 00                	mov    (%eax),%al
  8006d6:	0f be c0             	movsbl %al,%eax
  8006d9:	83 ec 08             	sub    $0x8,%esp
  8006dc:	ff 75 0c             	pushl  0xc(%ebp)
  8006df:	50                   	push   %eax
  8006e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e3:	ff d0                	call   *%eax
  8006e5:	83 c4 10             	add    $0x10,%esp
}
  8006e8:	90                   	nop
  8006e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006ec:	c9                   	leave  
  8006ed:	c3                   	ret    

008006ee <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006ee:	55                   	push   %ebp
  8006ef:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006f1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006f5:	7e 1c                	jle    800713 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8006f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fa:	8b 00                	mov    (%eax),%eax
  8006fc:	8d 50 08             	lea    0x8(%eax),%edx
  8006ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800702:	89 10                	mov    %edx,(%eax)
  800704:	8b 45 08             	mov    0x8(%ebp),%eax
  800707:	8b 00                	mov    (%eax),%eax
  800709:	83 e8 08             	sub    $0x8,%eax
  80070c:	8b 50 04             	mov    0x4(%eax),%edx
  80070f:	8b 00                	mov    (%eax),%eax
  800711:	eb 40                	jmp    800753 <getuint+0x65>
	else if (lflag)
  800713:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800717:	74 1e                	je     800737 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800719:	8b 45 08             	mov    0x8(%ebp),%eax
  80071c:	8b 00                	mov    (%eax),%eax
  80071e:	8d 50 04             	lea    0x4(%eax),%edx
  800721:	8b 45 08             	mov    0x8(%ebp),%eax
  800724:	89 10                	mov    %edx,(%eax)
  800726:	8b 45 08             	mov    0x8(%ebp),%eax
  800729:	8b 00                	mov    (%eax),%eax
  80072b:	83 e8 04             	sub    $0x4,%eax
  80072e:	8b 00                	mov    (%eax),%eax
  800730:	ba 00 00 00 00       	mov    $0x0,%edx
  800735:	eb 1c                	jmp    800753 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800737:	8b 45 08             	mov    0x8(%ebp),%eax
  80073a:	8b 00                	mov    (%eax),%eax
  80073c:	8d 50 04             	lea    0x4(%eax),%edx
  80073f:	8b 45 08             	mov    0x8(%ebp),%eax
  800742:	89 10                	mov    %edx,(%eax)
  800744:	8b 45 08             	mov    0x8(%ebp),%eax
  800747:	8b 00                	mov    (%eax),%eax
  800749:	83 e8 04             	sub    $0x4,%eax
  80074c:	8b 00                	mov    (%eax),%eax
  80074e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800753:	5d                   	pop    %ebp
  800754:	c3                   	ret    

00800755 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800755:	55                   	push   %ebp
  800756:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800758:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80075c:	7e 1c                	jle    80077a <getint+0x25>
		return va_arg(*ap, long long);
  80075e:	8b 45 08             	mov    0x8(%ebp),%eax
  800761:	8b 00                	mov    (%eax),%eax
  800763:	8d 50 08             	lea    0x8(%eax),%edx
  800766:	8b 45 08             	mov    0x8(%ebp),%eax
  800769:	89 10                	mov    %edx,(%eax)
  80076b:	8b 45 08             	mov    0x8(%ebp),%eax
  80076e:	8b 00                	mov    (%eax),%eax
  800770:	83 e8 08             	sub    $0x8,%eax
  800773:	8b 50 04             	mov    0x4(%eax),%edx
  800776:	8b 00                	mov    (%eax),%eax
  800778:	eb 38                	jmp    8007b2 <getint+0x5d>
	else if (lflag)
  80077a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80077e:	74 1a                	je     80079a <getint+0x45>
		return va_arg(*ap, long);
  800780:	8b 45 08             	mov    0x8(%ebp),%eax
  800783:	8b 00                	mov    (%eax),%eax
  800785:	8d 50 04             	lea    0x4(%eax),%edx
  800788:	8b 45 08             	mov    0x8(%ebp),%eax
  80078b:	89 10                	mov    %edx,(%eax)
  80078d:	8b 45 08             	mov    0x8(%ebp),%eax
  800790:	8b 00                	mov    (%eax),%eax
  800792:	83 e8 04             	sub    $0x4,%eax
  800795:	8b 00                	mov    (%eax),%eax
  800797:	99                   	cltd   
  800798:	eb 18                	jmp    8007b2 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80079a:	8b 45 08             	mov    0x8(%ebp),%eax
  80079d:	8b 00                	mov    (%eax),%eax
  80079f:	8d 50 04             	lea    0x4(%eax),%edx
  8007a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a5:	89 10                	mov    %edx,(%eax)
  8007a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007aa:	8b 00                	mov    (%eax),%eax
  8007ac:	83 e8 04             	sub    $0x4,%eax
  8007af:	8b 00                	mov    (%eax),%eax
  8007b1:	99                   	cltd   
}
  8007b2:	5d                   	pop    %ebp
  8007b3:	c3                   	ret    

008007b4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007b4:	55                   	push   %ebp
  8007b5:	89 e5                	mov    %esp,%ebp
  8007b7:	56                   	push   %esi
  8007b8:	53                   	push   %ebx
  8007b9:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007bc:	eb 17                	jmp    8007d5 <vprintfmt+0x21>
			if (ch == '\0')
  8007be:	85 db                	test   %ebx,%ebx
  8007c0:	0f 84 af 03 00 00    	je     800b75 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8007c6:	83 ec 08             	sub    $0x8,%esp
  8007c9:	ff 75 0c             	pushl  0xc(%ebp)
  8007cc:	53                   	push   %ebx
  8007cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d0:	ff d0                	call   *%eax
  8007d2:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8007d8:	8d 50 01             	lea    0x1(%eax),%edx
  8007db:	89 55 10             	mov    %edx,0x10(%ebp)
  8007de:	8a 00                	mov    (%eax),%al
  8007e0:	0f b6 d8             	movzbl %al,%ebx
  8007e3:	83 fb 25             	cmp    $0x25,%ebx
  8007e6:	75 d6                	jne    8007be <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007e8:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007ec:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8007f3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007fa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800801:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800808:	8b 45 10             	mov    0x10(%ebp),%eax
  80080b:	8d 50 01             	lea    0x1(%eax),%edx
  80080e:	89 55 10             	mov    %edx,0x10(%ebp)
  800811:	8a 00                	mov    (%eax),%al
  800813:	0f b6 d8             	movzbl %al,%ebx
  800816:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800819:	83 f8 55             	cmp    $0x55,%eax
  80081c:	0f 87 2b 03 00 00    	ja     800b4d <vprintfmt+0x399>
  800822:	8b 04 85 18 38 80 00 	mov    0x803818(,%eax,4),%eax
  800829:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80082b:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80082f:	eb d7                	jmp    800808 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800831:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800835:	eb d1                	jmp    800808 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800837:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80083e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800841:	89 d0                	mov    %edx,%eax
  800843:	c1 e0 02             	shl    $0x2,%eax
  800846:	01 d0                	add    %edx,%eax
  800848:	01 c0                	add    %eax,%eax
  80084a:	01 d8                	add    %ebx,%eax
  80084c:	83 e8 30             	sub    $0x30,%eax
  80084f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800852:	8b 45 10             	mov    0x10(%ebp),%eax
  800855:	8a 00                	mov    (%eax),%al
  800857:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80085a:	83 fb 2f             	cmp    $0x2f,%ebx
  80085d:	7e 3e                	jle    80089d <vprintfmt+0xe9>
  80085f:	83 fb 39             	cmp    $0x39,%ebx
  800862:	7f 39                	jg     80089d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800864:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800867:	eb d5                	jmp    80083e <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800869:	8b 45 14             	mov    0x14(%ebp),%eax
  80086c:	83 c0 04             	add    $0x4,%eax
  80086f:	89 45 14             	mov    %eax,0x14(%ebp)
  800872:	8b 45 14             	mov    0x14(%ebp),%eax
  800875:	83 e8 04             	sub    $0x4,%eax
  800878:	8b 00                	mov    (%eax),%eax
  80087a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80087d:	eb 1f                	jmp    80089e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80087f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800883:	79 83                	jns    800808 <vprintfmt+0x54>
				width = 0;
  800885:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80088c:	e9 77 ff ff ff       	jmp    800808 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800891:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800898:	e9 6b ff ff ff       	jmp    800808 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80089d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80089e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008a2:	0f 89 60 ff ff ff    	jns    800808 <vprintfmt+0x54>
				width = precision, precision = -1;
  8008a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008ae:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008b5:	e9 4e ff ff ff       	jmp    800808 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008ba:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008bd:	e9 46 ff ff ff       	jmp    800808 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c5:	83 c0 04             	add    $0x4,%eax
  8008c8:	89 45 14             	mov    %eax,0x14(%ebp)
  8008cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ce:	83 e8 04             	sub    $0x4,%eax
  8008d1:	8b 00                	mov    (%eax),%eax
  8008d3:	83 ec 08             	sub    $0x8,%esp
  8008d6:	ff 75 0c             	pushl  0xc(%ebp)
  8008d9:	50                   	push   %eax
  8008da:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dd:	ff d0                	call   *%eax
  8008df:	83 c4 10             	add    $0x10,%esp
			break;
  8008e2:	e9 89 02 00 00       	jmp    800b70 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ea:	83 c0 04             	add    $0x4,%eax
  8008ed:	89 45 14             	mov    %eax,0x14(%ebp)
  8008f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f3:	83 e8 04             	sub    $0x4,%eax
  8008f6:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008f8:	85 db                	test   %ebx,%ebx
  8008fa:	79 02                	jns    8008fe <vprintfmt+0x14a>
				err = -err;
  8008fc:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008fe:	83 fb 64             	cmp    $0x64,%ebx
  800901:	7f 0b                	jg     80090e <vprintfmt+0x15a>
  800903:	8b 34 9d 60 36 80 00 	mov    0x803660(,%ebx,4),%esi
  80090a:	85 f6                	test   %esi,%esi
  80090c:	75 19                	jne    800927 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80090e:	53                   	push   %ebx
  80090f:	68 05 38 80 00       	push   $0x803805
  800914:	ff 75 0c             	pushl  0xc(%ebp)
  800917:	ff 75 08             	pushl  0x8(%ebp)
  80091a:	e8 5e 02 00 00       	call   800b7d <printfmt>
  80091f:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800922:	e9 49 02 00 00       	jmp    800b70 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800927:	56                   	push   %esi
  800928:	68 0e 38 80 00       	push   $0x80380e
  80092d:	ff 75 0c             	pushl  0xc(%ebp)
  800930:	ff 75 08             	pushl  0x8(%ebp)
  800933:	e8 45 02 00 00       	call   800b7d <printfmt>
  800938:	83 c4 10             	add    $0x10,%esp
			break;
  80093b:	e9 30 02 00 00       	jmp    800b70 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800940:	8b 45 14             	mov    0x14(%ebp),%eax
  800943:	83 c0 04             	add    $0x4,%eax
  800946:	89 45 14             	mov    %eax,0x14(%ebp)
  800949:	8b 45 14             	mov    0x14(%ebp),%eax
  80094c:	83 e8 04             	sub    $0x4,%eax
  80094f:	8b 30                	mov    (%eax),%esi
  800951:	85 f6                	test   %esi,%esi
  800953:	75 05                	jne    80095a <vprintfmt+0x1a6>
				p = "(null)";
  800955:	be 11 38 80 00       	mov    $0x803811,%esi
			if (width > 0 && padc != '-')
  80095a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80095e:	7e 6d                	jle    8009cd <vprintfmt+0x219>
  800960:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800964:	74 67                	je     8009cd <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800966:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800969:	83 ec 08             	sub    $0x8,%esp
  80096c:	50                   	push   %eax
  80096d:	56                   	push   %esi
  80096e:	e8 0c 03 00 00       	call   800c7f <strnlen>
  800973:	83 c4 10             	add    $0x10,%esp
  800976:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800979:	eb 16                	jmp    800991 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80097b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80097f:	83 ec 08             	sub    $0x8,%esp
  800982:	ff 75 0c             	pushl  0xc(%ebp)
  800985:	50                   	push   %eax
  800986:	8b 45 08             	mov    0x8(%ebp),%eax
  800989:	ff d0                	call   *%eax
  80098b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80098e:	ff 4d e4             	decl   -0x1c(%ebp)
  800991:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800995:	7f e4                	jg     80097b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800997:	eb 34                	jmp    8009cd <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800999:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80099d:	74 1c                	je     8009bb <vprintfmt+0x207>
  80099f:	83 fb 1f             	cmp    $0x1f,%ebx
  8009a2:	7e 05                	jle    8009a9 <vprintfmt+0x1f5>
  8009a4:	83 fb 7e             	cmp    $0x7e,%ebx
  8009a7:	7e 12                	jle    8009bb <vprintfmt+0x207>
					putch('?', putdat);
  8009a9:	83 ec 08             	sub    $0x8,%esp
  8009ac:	ff 75 0c             	pushl  0xc(%ebp)
  8009af:	6a 3f                	push   $0x3f
  8009b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b4:	ff d0                	call   *%eax
  8009b6:	83 c4 10             	add    $0x10,%esp
  8009b9:	eb 0f                	jmp    8009ca <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009bb:	83 ec 08             	sub    $0x8,%esp
  8009be:	ff 75 0c             	pushl  0xc(%ebp)
  8009c1:	53                   	push   %ebx
  8009c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c5:	ff d0                	call   *%eax
  8009c7:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009ca:	ff 4d e4             	decl   -0x1c(%ebp)
  8009cd:	89 f0                	mov    %esi,%eax
  8009cf:	8d 70 01             	lea    0x1(%eax),%esi
  8009d2:	8a 00                	mov    (%eax),%al
  8009d4:	0f be d8             	movsbl %al,%ebx
  8009d7:	85 db                	test   %ebx,%ebx
  8009d9:	74 24                	je     8009ff <vprintfmt+0x24b>
  8009db:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009df:	78 b8                	js     800999 <vprintfmt+0x1e5>
  8009e1:	ff 4d e0             	decl   -0x20(%ebp)
  8009e4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009e8:	79 af                	jns    800999 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009ea:	eb 13                	jmp    8009ff <vprintfmt+0x24b>
				putch(' ', putdat);
  8009ec:	83 ec 08             	sub    $0x8,%esp
  8009ef:	ff 75 0c             	pushl  0xc(%ebp)
  8009f2:	6a 20                	push   $0x20
  8009f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f7:	ff d0                	call   *%eax
  8009f9:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009fc:	ff 4d e4             	decl   -0x1c(%ebp)
  8009ff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a03:	7f e7                	jg     8009ec <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a05:	e9 66 01 00 00       	jmp    800b70 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a0a:	83 ec 08             	sub    $0x8,%esp
  800a0d:	ff 75 e8             	pushl  -0x18(%ebp)
  800a10:	8d 45 14             	lea    0x14(%ebp),%eax
  800a13:	50                   	push   %eax
  800a14:	e8 3c fd ff ff       	call   800755 <getint>
  800a19:	83 c4 10             	add    $0x10,%esp
  800a1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a1f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a25:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a28:	85 d2                	test   %edx,%edx
  800a2a:	79 23                	jns    800a4f <vprintfmt+0x29b>
				putch('-', putdat);
  800a2c:	83 ec 08             	sub    $0x8,%esp
  800a2f:	ff 75 0c             	pushl  0xc(%ebp)
  800a32:	6a 2d                	push   $0x2d
  800a34:	8b 45 08             	mov    0x8(%ebp),%eax
  800a37:	ff d0                	call   *%eax
  800a39:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a42:	f7 d8                	neg    %eax
  800a44:	83 d2 00             	adc    $0x0,%edx
  800a47:	f7 da                	neg    %edx
  800a49:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a4c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a4f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a56:	e9 bc 00 00 00       	jmp    800b17 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a5b:	83 ec 08             	sub    $0x8,%esp
  800a5e:	ff 75 e8             	pushl  -0x18(%ebp)
  800a61:	8d 45 14             	lea    0x14(%ebp),%eax
  800a64:	50                   	push   %eax
  800a65:	e8 84 fc ff ff       	call   8006ee <getuint>
  800a6a:	83 c4 10             	add    $0x10,%esp
  800a6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a70:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a73:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a7a:	e9 98 00 00 00       	jmp    800b17 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a7f:	83 ec 08             	sub    $0x8,%esp
  800a82:	ff 75 0c             	pushl  0xc(%ebp)
  800a85:	6a 58                	push   $0x58
  800a87:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8a:	ff d0                	call   *%eax
  800a8c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a8f:	83 ec 08             	sub    $0x8,%esp
  800a92:	ff 75 0c             	pushl  0xc(%ebp)
  800a95:	6a 58                	push   $0x58
  800a97:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9a:	ff d0                	call   *%eax
  800a9c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a9f:	83 ec 08             	sub    $0x8,%esp
  800aa2:	ff 75 0c             	pushl  0xc(%ebp)
  800aa5:	6a 58                	push   $0x58
  800aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aaa:	ff d0                	call   *%eax
  800aac:	83 c4 10             	add    $0x10,%esp
			break;
  800aaf:	e9 bc 00 00 00       	jmp    800b70 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800ab4:	83 ec 08             	sub    $0x8,%esp
  800ab7:	ff 75 0c             	pushl  0xc(%ebp)
  800aba:	6a 30                	push   $0x30
  800abc:	8b 45 08             	mov    0x8(%ebp),%eax
  800abf:	ff d0                	call   *%eax
  800ac1:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ac4:	83 ec 08             	sub    $0x8,%esp
  800ac7:	ff 75 0c             	pushl  0xc(%ebp)
  800aca:	6a 78                	push   $0x78
  800acc:	8b 45 08             	mov    0x8(%ebp),%eax
  800acf:	ff d0                	call   *%eax
  800ad1:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ad4:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad7:	83 c0 04             	add    $0x4,%eax
  800ada:	89 45 14             	mov    %eax,0x14(%ebp)
  800add:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae0:	83 e8 04             	sub    $0x4,%eax
  800ae3:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ae5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ae8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800aef:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800af6:	eb 1f                	jmp    800b17 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800af8:	83 ec 08             	sub    $0x8,%esp
  800afb:	ff 75 e8             	pushl  -0x18(%ebp)
  800afe:	8d 45 14             	lea    0x14(%ebp),%eax
  800b01:	50                   	push   %eax
  800b02:	e8 e7 fb ff ff       	call   8006ee <getuint>
  800b07:	83 c4 10             	add    $0x10,%esp
  800b0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b0d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b10:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b17:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b1e:	83 ec 04             	sub    $0x4,%esp
  800b21:	52                   	push   %edx
  800b22:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b25:	50                   	push   %eax
  800b26:	ff 75 f4             	pushl  -0xc(%ebp)
  800b29:	ff 75 f0             	pushl  -0x10(%ebp)
  800b2c:	ff 75 0c             	pushl  0xc(%ebp)
  800b2f:	ff 75 08             	pushl  0x8(%ebp)
  800b32:	e8 00 fb ff ff       	call   800637 <printnum>
  800b37:	83 c4 20             	add    $0x20,%esp
			break;
  800b3a:	eb 34                	jmp    800b70 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b3c:	83 ec 08             	sub    $0x8,%esp
  800b3f:	ff 75 0c             	pushl  0xc(%ebp)
  800b42:	53                   	push   %ebx
  800b43:	8b 45 08             	mov    0x8(%ebp),%eax
  800b46:	ff d0                	call   *%eax
  800b48:	83 c4 10             	add    $0x10,%esp
			break;
  800b4b:	eb 23                	jmp    800b70 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b4d:	83 ec 08             	sub    $0x8,%esp
  800b50:	ff 75 0c             	pushl  0xc(%ebp)
  800b53:	6a 25                	push   $0x25
  800b55:	8b 45 08             	mov    0x8(%ebp),%eax
  800b58:	ff d0                	call   *%eax
  800b5a:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b5d:	ff 4d 10             	decl   0x10(%ebp)
  800b60:	eb 03                	jmp    800b65 <vprintfmt+0x3b1>
  800b62:	ff 4d 10             	decl   0x10(%ebp)
  800b65:	8b 45 10             	mov    0x10(%ebp),%eax
  800b68:	48                   	dec    %eax
  800b69:	8a 00                	mov    (%eax),%al
  800b6b:	3c 25                	cmp    $0x25,%al
  800b6d:	75 f3                	jne    800b62 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b6f:	90                   	nop
		}
	}
  800b70:	e9 47 fc ff ff       	jmp    8007bc <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b75:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b76:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b79:	5b                   	pop    %ebx
  800b7a:	5e                   	pop    %esi
  800b7b:	5d                   	pop    %ebp
  800b7c:	c3                   	ret    

00800b7d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b7d:	55                   	push   %ebp
  800b7e:	89 e5                	mov    %esp,%ebp
  800b80:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b83:	8d 45 10             	lea    0x10(%ebp),%eax
  800b86:	83 c0 04             	add    $0x4,%eax
  800b89:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b8c:	8b 45 10             	mov    0x10(%ebp),%eax
  800b8f:	ff 75 f4             	pushl  -0xc(%ebp)
  800b92:	50                   	push   %eax
  800b93:	ff 75 0c             	pushl  0xc(%ebp)
  800b96:	ff 75 08             	pushl  0x8(%ebp)
  800b99:	e8 16 fc ff ff       	call   8007b4 <vprintfmt>
  800b9e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800ba1:	90                   	nop
  800ba2:	c9                   	leave  
  800ba3:	c3                   	ret    

00800ba4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ba4:	55                   	push   %ebp
  800ba5:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800ba7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800baa:	8b 40 08             	mov    0x8(%eax),%eax
  800bad:	8d 50 01             	lea    0x1(%eax),%edx
  800bb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb3:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800bb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb9:	8b 10                	mov    (%eax),%edx
  800bbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bbe:	8b 40 04             	mov    0x4(%eax),%eax
  800bc1:	39 c2                	cmp    %eax,%edx
  800bc3:	73 12                	jae    800bd7 <sprintputch+0x33>
		*b->buf++ = ch;
  800bc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc8:	8b 00                	mov    (%eax),%eax
  800bca:	8d 48 01             	lea    0x1(%eax),%ecx
  800bcd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bd0:	89 0a                	mov    %ecx,(%edx)
  800bd2:	8b 55 08             	mov    0x8(%ebp),%edx
  800bd5:	88 10                	mov    %dl,(%eax)
}
  800bd7:	90                   	nop
  800bd8:	5d                   	pop    %ebp
  800bd9:	c3                   	ret    

00800bda <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800bda:	55                   	push   %ebp
  800bdb:	89 e5                	mov    %esp,%ebp
  800bdd:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800be0:	8b 45 08             	mov    0x8(%ebp),%eax
  800be3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800be6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bec:	8b 45 08             	mov    0x8(%ebp),%eax
  800bef:	01 d0                	add    %edx,%eax
  800bf1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bf4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800bfb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800bff:	74 06                	je     800c07 <vsnprintf+0x2d>
  800c01:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c05:	7f 07                	jg     800c0e <vsnprintf+0x34>
		return -E_INVAL;
  800c07:	b8 03 00 00 00       	mov    $0x3,%eax
  800c0c:	eb 20                	jmp    800c2e <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c0e:	ff 75 14             	pushl  0x14(%ebp)
  800c11:	ff 75 10             	pushl  0x10(%ebp)
  800c14:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c17:	50                   	push   %eax
  800c18:	68 a4 0b 80 00       	push   $0x800ba4
  800c1d:	e8 92 fb ff ff       	call   8007b4 <vprintfmt>
  800c22:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c28:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c2e:	c9                   	leave  
  800c2f:	c3                   	ret    

00800c30 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c30:	55                   	push   %ebp
  800c31:	89 e5                	mov    %esp,%ebp
  800c33:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c36:	8d 45 10             	lea    0x10(%ebp),%eax
  800c39:	83 c0 04             	add    $0x4,%eax
  800c3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c3f:	8b 45 10             	mov    0x10(%ebp),%eax
  800c42:	ff 75 f4             	pushl  -0xc(%ebp)
  800c45:	50                   	push   %eax
  800c46:	ff 75 0c             	pushl  0xc(%ebp)
  800c49:	ff 75 08             	pushl  0x8(%ebp)
  800c4c:	e8 89 ff ff ff       	call   800bda <vsnprintf>
  800c51:	83 c4 10             	add    $0x10,%esp
  800c54:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c57:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c5a:	c9                   	leave  
  800c5b:	c3                   	ret    

00800c5c <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c5c:	55                   	push   %ebp
  800c5d:	89 e5                	mov    %esp,%ebp
  800c5f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c62:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c69:	eb 06                	jmp    800c71 <strlen+0x15>
		n++;
  800c6b:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c6e:	ff 45 08             	incl   0x8(%ebp)
  800c71:	8b 45 08             	mov    0x8(%ebp),%eax
  800c74:	8a 00                	mov    (%eax),%al
  800c76:	84 c0                	test   %al,%al
  800c78:	75 f1                	jne    800c6b <strlen+0xf>
		n++;
	return n;
  800c7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c7d:	c9                   	leave  
  800c7e:	c3                   	ret    

00800c7f <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c7f:	55                   	push   %ebp
  800c80:	89 e5                	mov    %esp,%ebp
  800c82:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c85:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c8c:	eb 09                	jmp    800c97 <strnlen+0x18>
		n++;
  800c8e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c91:	ff 45 08             	incl   0x8(%ebp)
  800c94:	ff 4d 0c             	decl   0xc(%ebp)
  800c97:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c9b:	74 09                	je     800ca6 <strnlen+0x27>
  800c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca0:	8a 00                	mov    (%eax),%al
  800ca2:	84 c0                	test   %al,%al
  800ca4:	75 e8                	jne    800c8e <strnlen+0xf>
		n++;
	return n;
  800ca6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ca9:	c9                   	leave  
  800caa:	c3                   	ret    

00800cab <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cab:	55                   	push   %ebp
  800cac:	89 e5                	mov    %esp,%ebp
  800cae:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cb7:	90                   	nop
  800cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbb:	8d 50 01             	lea    0x1(%eax),%edx
  800cbe:	89 55 08             	mov    %edx,0x8(%ebp)
  800cc1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cc4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cc7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cca:	8a 12                	mov    (%edx),%dl
  800ccc:	88 10                	mov    %dl,(%eax)
  800cce:	8a 00                	mov    (%eax),%al
  800cd0:	84 c0                	test   %al,%al
  800cd2:	75 e4                	jne    800cb8 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800cd4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cd7:	c9                   	leave  
  800cd8:	c3                   	ret    

00800cd9 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800cd9:	55                   	push   %ebp
  800cda:	89 e5                	mov    %esp,%ebp
  800cdc:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ce5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cec:	eb 1f                	jmp    800d0d <strncpy+0x34>
		*dst++ = *src;
  800cee:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf1:	8d 50 01             	lea    0x1(%eax),%edx
  800cf4:	89 55 08             	mov    %edx,0x8(%ebp)
  800cf7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cfa:	8a 12                	mov    (%edx),%dl
  800cfc:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800cfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d01:	8a 00                	mov    (%eax),%al
  800d03:	84 c0                	test   %al,%al
  800d05:	74 03                	je     800d0a <strncpy+0x31>
			src++;
  800d07:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d0a:	ff 45 fc             	incl   -0x4(%ebp)
  800d0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d10:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d13:	72 d9                	jb     800cee <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d15:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d18:	c9                   	leave  
  800d19:	c3                   	ret    

00800d1a <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d1a:	55                   	push   %ebp
  800d1b:	89 e5                	mov    %esp,%ebp
  800d1d:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d20:	8b 45 08             	mov    0x8(%ebp),%eax
  800d23:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d26:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d2a:	74 30                	je     800d5c <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d2c:	eb 16                	jmp    800d44 <strlcpy+0x2a>
			*dst++ = *src++;
  800d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d31:	8d 50 01             	lea    0x1(%eax),%edx
  800d34:	89 55 08             	mov    %edx,0x8(%ebp)
  800d37:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d3a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d3d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d40:	8a 12                	mov    (%edx),%dl
  800d42:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d44:	ff 4d 10             	decl   0x10(%ebp)
  800d47:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d4b:	74 09                	je     800d56 <strlcpy+0x3c>
  800d4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d50:	8a 00                	mov    (%eax),%al
  800d52:	84 c0                	test   %al,%al
  800d54:	75 d8                	jne    800d2e <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d56:	8b 45 08             	mov    0x8(%ebp),%eax
  800d59:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d5c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d62:	29 c2                	sub    %eax,%edx
  800d64:	89 d0                	mov    %edx,%eax
}
  800d66:	c9                   	leave  
  800d67:	c3                   	ret    

00800d68 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d68:	55                   	push   %ebp
  800d69:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d6b:	eb 06                	jmp    800d73 <strcmp+0xb>
		p++, q++;
  800d6d:	ff 45 08             	incl   0x8(%ebp)
  800d70:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d73:	8b 45 08             	mov    0x8(%ebp),%eax
  800d76:	8a 00                	mov    (%eax),%al
  800d78:	84 c0                	test   %al,%al
  800d7a:	74 0e                	je     800d8a <strcmp+0x22>
  800d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7f:	8a 10                	mov    (%eax),%dl
  800d81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d84:	8a 00                	mov    (%eax),%al
  800d86:	38 c2                	cmp    %al,%dl
  800d88:	74 e3                	je     800d6d <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8d:	8a 00                	mov    (%eax),%al
  800d8f:	0f b6 d0             	movzbl %al,%edx
  800d92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d95:	8a 00                	mov    (%eax),%al
  800d97:	0f b6 c0             	movzbl %al,%eax
  800d9a:	29 c2                	sub    %eax,%edx
  800d9c:	89 d0                	mov    %edx,%eax
}
  800d9e:	5d                   	pop    %ebp
  800d9f:	c3                   	ret    

00800da0 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800da0:	55                   	push   %ebp
  800da1:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800da3:	eb 09                	jmp    800dae <strncmp+0xe>
		n--, p++, q++;
  800da5:	ff 4d 10             	decl   0x10(%ebp)
  800da8:	ff 45 08             	incl   0x8(%ebp)
  800dab:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800dae:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800db2:	74 17                	je     800dcb <strncmp+0x2b>
  800db4:	8b 45 08             	mov    0x8(%ebp),%eax
  800db7:	8a 00                	mov    (%eax),%al
  800db9:	84 c0                	test   %al,%al
  800dbb:	74 0e                	je     800dcb <strncmp+0x2b>
  800dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc0:	8a 10                	mov    (%eax),%dl
  800dc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc5:	8a 00                	mov    (%eax),%al
  800dc7:	38 c2                	cmp    %al,%dl
  800dc9:	74 da                	je     800da5 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800dcb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dcf:	75 07                	jne    800dd8 <strncmp+0x38>
		return 0;
  800dd1:	b8 00 00 00 00       	mov    $0x0,%eax
  800dd6:	eb 14                	jmp    800dec <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800dd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddb:	8a 00                	mov    (%eax),%al
  800ddd:	0f b6 d0             	movzbl %al,%edx
  800de0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de3:	8a 00                	mov    (%eax),%al
  800de5:	0f b6 c0             	movzbl %al,%eax
  800de8:	29 c2                	sub    %eax,%edx
  800dea:	89 d0                	mov    %edx,%eax
}
  800dec:	5d                   	pop    %ebp
  800ded:	c3                   	ret    

00800dee <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800dee:	55                   	push   %ebp
  800def:	89 e5                	mov    %esp,%ebp
  800df1:	83 ec 04             	sub    $0x4,%esp
  800df4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dfa:	eb 12                	jmp    800e0e <strchr+0x20>
		if (*s == c)
  800dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dff:	8a 00                	mov    (%eax),%al
  800e01:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e04:	75 05                	jne    800e0b <strchr+0x1d>
			return (char *) s;
  800e06:	8b 45 08             	mov    0x8(%ebp),%eax
  800e09:	eb 11                	jmp    800e1c <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e0b:	ff 45 08             	incl   0x8(%ebp)
  800e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e11:	8a 00                	mov    (%eax),%al
  800e13:	84 c0                	test   %al,%al
  800e15:	75 e5                	jne    800dfc <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e17:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e1c:	c9                   	leave  
  800e1d:	c3                   	ret    

00800e1e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e1e:	55                   	push   %ebp
  800e1f:	89 e5                	mov    %esp,%ebp
  800e21:	83 ec 04             	sub    $0x4,%esp
  800e24:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e27:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e2a:	eb 0d                	jmp    800e39 <strfind+0x1b>
		if (*s == c)
  800e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2f:	8a 00                	mov    (%eax),%al
  800e31:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e34:	74 0e                	je     800e44 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e36:	ff 45 08             	incl   0x8(%ebp)
  800e39:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3c:	8a 00                	mov    (%eax),%al
  800e3e:	84 c0                	test   %al,%al
  800e40:	75 ea                	jne    800e2c <strfind+0xe>
  800e42:	eb 01                	jmp    800e45 <strfind+0x27>
		if (*s == c)
			break;
  800e44:	90                   	nop
	return (char *) s;
  800e45:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e48:	c9                   	leave  
  800e49:	c3                   	ret    

00800e4a <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e4a:	55                   	push   %ebp
  800e4b:	89 e5                	mov    %esp,%ebp
  800e4d:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e50:	8b 45 08             	mov    0x8(%ebp),%eax
  800e53:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e56:	8b 45 10             	mov    0x10(%ebp),%eax
  800e59:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e5c:	eb 0e                	jmp    800e6c <memset+0x22>
		*p++ = c;
  800e5e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e61:	8d 50 01             	lea    0x1(%eax),%edx
  800e64:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e67:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e6a:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e6c:	ff 4d f8             	decl   -0x8(%ebp)
  800e6f:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e73:	79 e9                	jns    800e5e <memset+0x14>
		*p++ = c;

	return v;
  800e75:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e78:	c9                   	leave  
  800e79:	c3                   	ret    

00800e7a <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e7a:	55                   	push   %ebp
  800e7b:	89 e5                	mov    %esp,%ebp
  800e7d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e83:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e86:	8b 45 08             	mov    0x8(%ebp),%eax
  800e89:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e8c:	eb 16                	jmp    800ea4 <memcpy+0x2a>
		*d++ = *s++;
  800e8e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e91:	8d 50 01             	lea    0x1(%eax),%edx
  800e94:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e97:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e9a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e9d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ea0:	8a 12                	mov    (%edx),%dl
  800ea2:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800ea4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eaa:	89 55 10             	mov    %edx,0x10(%ebp)
  800ead:	85 c0                	test   %eax,%eax
  800eaf:	75 dd                	jne    800e8e <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800eb1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eb4:	c9                   	leave  
  800eb5:	c3                   	ret    

00800eb6 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800eb6:	55                   	push   %ebp
  800eb7:	89 e5                	mov    %esp,%ebp
  800eb9:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ebc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ebf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800ec8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ecb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ece:	73 50                	jae    800f20 <memmove+0x6a>
  800ed0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ed3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed6:	01 d0                	add    %edx,%eax
  800ed8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800edb:	76 43                	jbe    800f20 <memmove+0x6a>
		s += n;
  800edd:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee0:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800ee3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee6:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ee9:	eb 10                	jmp    800efb <memmove+0x45>
			*--d = *--s;
  800eeb:	ff 4d f8             	decl   -0x8(%ebp)
  800eee:	ff 4d fc             	decl   -0x4(%ebp)
  800ef1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ef4:	8a 10                	mov    (%eax),%dl
  800ef6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ef9:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800efb:	8b 45 10             	mov    0x10(%ebp),%eax
  800efe:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f01:	89 55 10             	mov    %edx,0x10(%ebp)
  800f04:	85 c0                	test   %eax,%eax
  800f06:	75 e3                	jne    800eeb <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f08:	eb 23                	jmp    800f2d <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f0a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f0d:	8d 50 01             	lea    0x1(%eax),%edx
  800f10:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f13:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f16:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f19:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f1c:	8a 12                	mov    (%edx),%dl
  800f1e:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f20:	8b 45 10             	mov    0x10(%ebp),%eax
  800f23:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f26:	89 55 10             	mov    %edx,0x10(%ebp)
  800f29:	85 c0                	test   %eax,%eax
  800f2b:	75 dd                	jne    800f0a <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f2d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f30:	c9                   	leave  
  800f31:	c3                   	ret    

00800f32 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f32:	55                   	push   %ebp
  800f33:	89 e5                	mov    %esp,%ebp
  800f35:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f38:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f41:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f44:	eb 2a                	jmp    800f70 <memcmp+0x3e>
		if (*s1 != *s2)
  800f46:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f49:	8a 10                	mov    (%eax),%dl
  800f4b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f4e:	8a 00                	mov    (%eax),%al
  800f50:	38 c2                	cmp    %al,%dl
  800f52:	74 16                	je     800f6a <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f54:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f57:	8a 00                	mov    (%eax),%al
  800f59:	0f b6 d0             	movzbl %al,%edx
  800f5c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f5f:	8a 00                	mov    (%eax),%al
  800f61:	0f b6 c0             	movzbl %al,%eax
  800f64:	29 c2                	sub    %eax,%edx
  800f66:	89 d0                	mov    %edx,%eax
  800f68:	eb 18                	jmp    800f82 <memcmp+0x50>
		s1++, s2++;
  800f6a:	ff 45 fc             	incl   -0x4(%ebp)
  800f6d:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f70:	8b 45 10             	mov    0x10(%ebp),%eax
  800f73:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f76:	89 55 10             	mov    %edx,0x10(%ebp)
  800f79:	85 c0                	test   %eax,%eax
  800f7b:	75 c9                	jne    800f46 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f7d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f82:	c9                   	leave  
  800f83:	c3                   	ret    

00800f84 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f84:	55                   	push   %ebp
  800f85:	89 e5                	mov    %esp,%ebp
  800f87:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f8a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f8d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f90:	01 d0                	add    %edx,%eax
  800f92:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f95:	eb 15                	jmp    800fac <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f97:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9a:	8a 00                	mov    (%eax),%al
  800f9c:	0f b6 d0             	movzbl %al,%edx
  800f9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa2:	0f b6 c0             	movzbl %al,%eax
  800fa5:	39 c2                	cmp    %eax,%edx
  800fa7:	74 0d                	je     800fb6 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800fa9:	ff 45 08             	incl   0x8(%ebp)
  800fac:	8b 45 08             	mov    0x8(%ebp),%eax
  800faf:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800fb2:	72 e3                	jb     800f97 <memfind+0x13>
  800fb4:	eb 01                	jmp    800fb7 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800fb6:	90                   	nop
	return (void *) s;
  800fb7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fba:	c9                   	leave  
  800fbb:	c3                   	ret    

00800fbc <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800fbc:	55                   	push   %ebp
  800fbd:	89 e5                	mov    %esp,%ebp
  800fbf:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800fc2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800fc9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fd0:	eb 03                	jmp    800fd5 <strtol+0x19>
		s++;
  800fd2:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd8:	8a 00                	mov    (%eax),%al
  800fda:	3c 20                	cmp    $0x20,%al
  800fdc:	74 f4                	je     800fd2 <strtol+0x16>
  800fde:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe1:	8a 00                	mov    (%eax),%al
  800fe3:	3c 09                	cmp    $0x9,%al
  800fe5:	74 eb                	je     800fd2 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fea:	8a 00                	mov    (%eax),%al
  800fec:	3c 2b                	cmp    $0x2b,%al
  800fee:	75 05                	jne    800ff5 <strtol+0x39>
		s++;
  800ff0:	ff 45 08             	incl   0x8(%ebp)
  800ff3:	eb 13                	jmp    801008 <strtol+0x4c>
	else if (*s == '-')
  800ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff8:	8a 00                	mov    (%eax),%al
  800ffa:	3c 2d                	cmp    $0x2d,%al
  800ffc:	75 0a                	jne    801008 <strtol+0x4c>
		s++, neg = 1;
  800ffe:	ff 45 08             	incl   0x8(%ebp)
  801001:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801008:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80100c:	74 06                	je     801014 <strtol+0x58>
  80100e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801012:	75 20                	jne    801034 <strtol+0x78>
  801014:	8b 45 08             	mov    0x8(%ebp),%eax
  801017:	8a 00                	mov    (%eax),%al
  801019:	3c 30                	cmp    $0x30,%al
  80101b:	75 17                	jne    801034 <strtol+0x78>
  80101d:	8b 45 08             	mov    0x8(%ebp),%eax
  801020:	40                   	inc    %eax
  801021:	8a 00                	mov    (%eax),%al
  801023:	3c 78                	cmp    $0x78,%al
  801025:	75 0d                	jne    801034 <strtol+0x78>
		s += 2, base = 16;
  801027:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80102b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801032:	eb 28                	jmp    80105c <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801034:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801038:	75 15                	jne    80104f <strtol+0x93>
  80103a:	8b 45 08             	mov    0x8(%ebp),%eax
  80103d:	8a 00                	mov    (%eax),%al
  80103f:	3c 30                	cmp    $0x30,%al
  801041:	75 0c                	jne    80104f <strtol+0x93>
		s++, base = 8;
  801043:	ff 45 08             	incl   0x8(%ebp)
  801046:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80104d:	eb 0d                	jmp    80105c <strtol+0xa0>
	else if (base == 0)
  80104f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801053:	75 07                	jne    80105c <strtol+0xa0>
		base = 10;
  801055:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80105c:	8b 45 08             	mov    0x8(%ebp),%eax
  80105f:	8a 00                	mov    (%eax),%al
  801061:	3c 2f                	cmp    $0x2f,%al
  801063:	7e 19                	jle    80107e <strtol+0xc2>
  801065:	8b 45 08             	mov    0x8(%ebp),%eax
  801068:	8a 00                	mov    (%eax),%al
  80106a:	3c 39                	cmp    $0x39,%al
  80106c:	7f 10                	jg     80107e <strtol+0xc2>
			dig = *s - '0';
  80106e:	8b 45 08             	mov    0x8(%ebp),%eax
  801071:	8a 00                	mov    (%eax),%al
  801073:	0f be c0             	movsbl %al,%eax
  801076:	83 e8 30             	sub    $0x30,%eax
  801079:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80107c:	eb 42                	jmp    8010c0 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80107e:	8b 45 08             	mov    0x8(%ebp),%eax
  801081:	8a 00                	mov    (%eax),%al
  801083:	3c 60                	cmp    $0x60,%al
  801085:	7e 19                	jle    8010a0 <strtol+0xe4>
  801087:	8b 45 08             	mov    0x8(%ebp),%eax
  80108a:	8a 00                	mov    (%eax),%al
  80108c:	3c 7a                	cmp    $0x7a,%al
  80108e:	7f 10                	jg     8010a0 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801090:	8b 45 08             	mov    0x8(%ebp),%eax
  801093:	8a 00                	mov    (%eax),%al
  801095:	0f be c0             	movsbl %al,%eax
  801098:	83 e8 57             	sub    $0x57,%eax
  80109b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80109e:	eb 20                	jmp    8010c0 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a3:	8a 00                	mov    (%eax),%al
  8010a5:	3c 40                	cmp    $0x40,%al
  8010a7:	7e 39                	jle    8010e2 <strtol+0x126>
  8010a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ac:	8a 00                	mov    (%eax),%al
  8010ae:	3c 5a                	cmp    $0x5a,%al
  8010b0:	7f 30                	jg     8010e2 <strtol+0x126>
			dig = *s - 'A' + 10;
  8010b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b5:	8a 00                	mov    (%eax),%al
  8010b7:	0f be c0             	movsbl %al,%eax
  8010ba:	83 e8 37             	sub    $0x37,%eax
  8010bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8010c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010c3:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010c6:	7d 19                	jge    8010e1 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8010c8:	ff 45 08             	incl   0x8(%ebp)
  8010cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ce:	0f af 45 10          	imul   0x10(%ebp),%eax
  8010d2:	89 c2                	mov    %eax,%edx
  8010d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010d7:	01 d0                	add    %edx,%eax
  8010d9:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8010dc:	e9 7b ff ff ff       	jmp    80105c <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8010e1:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010e2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010e6:	74 08                	je     8010f0 <strtol+0x134>
		*endptr = (char *) s;
  8010e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ee:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8010f0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010f4:	74 07                	je     8010fd <strtol+0x141>
  8010f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f9:	f7 d8                	neg    %eax
  8010fb:	eb 03                	jmp    801100 <strtol+0x144>
  8010fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801100:	c9                   	leave  
  801101:	c3                   	ret    

00801102 <ltostr>:

void
ltostr(long value, char *str)
{
  801102:	55                   	push   %ebp
  801103:	89 e5                	mov    %esp,%ebp
  801105:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801108:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80110f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801116:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80111a:	79 13                	jns    80112f <ltostr+0x2d>
	{
		neg = 1;
  80111c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801123:	8b 45 0c             	mov    0xc(%ebp),%eax
  801126:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801129:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80112c:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80112f:	8b 45 08             	mov    0x8(%ebp),%eax
  801132:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801137:	99                   	cltd   
  801138:	f7 f9                	idiv   %ecx
  80113a:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80113d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801140:	8d 50 01             	lea    0x1(%eax),%edx
  801143:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801146:	89 c2                	mov    %eax,%edx
  801148:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114b:	01 d0                	add    %edx,%eax
  80114d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801150:	83 c2 30             	add    $0x30,%edx
  801153:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801155:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801158:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80115d:	f7 e9                	imul   %ecx
  80115f:	c1 fa 02             	sar    $0x2,%edx
  801162:	89 c8                	mov    %ecx,%eax
  801164:	c1 f8 1f             	sar    $0x1f,%eax
  801167:	29 c2                	sub    %eax,%edx
  801169:	89 d0                	mov    %edx,%eax
  80116b:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80116e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801171:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801176:	f7 e9                	imul   %ecx
  801178:	c1 fa 02             	sar    $0x2,%edx
  80117b:	89 c8                	mov    %ecx,%eax
  80117d:	c1 f8 1f             	sar    $0x1f,%eax
  801180:	29 c2                	sub    %eax,%edx
  801182:	89 d0                	mov    %edx,%eax
  801184:	c1 e0 02             	shl    $0x2,%eax
  801187:	01 d0                	add    %edx,%eax
  801189:	01 c0                	add    %eax,%eax
  80118b:	29 c1                	sub    %eax,%ecx
  80118d:	89 ca                	mov    %ecx,%edx
  80118f:	85 d2                	test   %edx,%edx
  801191:	75 9c                	jne    80112f <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801193:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80119a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80119d:	48                   	dec    %eax
  80119e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8011a1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011a5:	74 3d                	je     8011e4 <ltostr+0xe2>
		start = 1 ;
  8011a7:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8011ae:	eb 34                	jmp    8011e4 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8011b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b6:	01 d0                	add    %edx,%eax
  8011b8:	8a 00                	mov    (%eax),%al
  8011ba:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8011bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c3:	01 c2                	add    %eax,%edx
  8011c5:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8011c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011cb:	01 c8                	add    %ecx,%eax
  8011cd:	8a 00                	mov    (%eax),%al
  8011cf:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8011d1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d7:	01 c2                	add    %eax,%edx
  8011d9:	8a 45 eb             	mov    -0x15(%ebp),%al
  8011dc:	88 02                	mov    %al,(%edx)
		start++ ;
  8011de:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8011e1:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8011e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011e7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011ea:	7c c4                	jl     8011b0 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8011ec:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8011ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f2:	01 d0                	add    %edx,%eax
  8011f4:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8011f7:	90                   	nop
  8011f8:	c9                   	leave  
  8011f9:	c3                   	ret    

008011fa <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011fa:	55                   	push   %ebp
  8011fb:	89 e5                	mov    %esp,%ebp
  8011fd:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801200:	ff 75 08             	pushl  0x8(%ebp)
  801203:	e8 54 fa ff ff       	call   800c5c <strlen>
  801208:	83 c4 04             	add    $0x4,%esp
  80120b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80120e:	ff 75 0c             	pushl  0xc(%ebp)
  801211:	e8 46 fa ff ff       	call   800c5c <strlen>
  801216:	83 c4 04             	add    $0x4,%esp
  801219:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80121c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801223:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80122a:	eb 17                	jmp    801243 <strcconcat+0x49>
		final[s] = str1[s] ;
  80122c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80122f:	8b 45 10             	mov    0x10(%ebp),%eax
  801232:	01 c2                	add    %eax,%edx
  801234:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801237:	8b 45 08             	mov    0x8(%ebp),%eax
  80123a:	01 c8                	add    %ecx,%eax
  80123c:	8a 00                	mov    (%eax),%al
  80123e:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801240:	ff 45 fc             	incl   -0x4(%ebp)
  801243:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801246:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801249:	7c e1                	jl     80122c <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80124b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801252:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801259:	eb 1f                	jmp    80127a <strcconcat+0x80>
		final[s++] = str2[i] ;
  80125b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80125e:	8d 50 01             	lea    0x1(%eax),%edx
  801261:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801264:	89 c2                	mov    %eax,%edx
  801266:	8b 45 10             	mov    0x10(%ebp),%eax
  801269:	01 c2                	add    %eax,%edx
  80126b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80126e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801271:	01 c8                	add    %ecx,%eax
  801273:	8a 00                	mov    (%eax),%al
  801275:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801277:	ff 45 f8             	incl   -0x8(%ebp)
  80127a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80127d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801280:	7c d9                	jl     80125b <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801282:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801285:	8b 45 10             	mov    0x10(%ebp),%eax
  801288:	01 d0                	add    %edx,%eax
  80128a:	c6 00 00             	movb   $0x0,(%eax)
}
  80128d:	90                   	nop
  80128e:	c9                   	leave  
  80128f:	c3                   	ret    

00801290 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801290:	55                   	push   %ebp
  801291:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801293:	8b 45 14             	mov    0x14(%ebp),%eax
  801296:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80129c:	8b 45 14             	mov    0x14(%ebp),%eax
  80129f:	8b 00                	mov    (%eax),%eax
  8012a1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ab:	01 d0                	add    %edx,%eax
  8012ad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012b3:	eb 0c                	jmp    8012c1 <strsplit+0x31>
			*string++ = 0;
  8012b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b8:	8d 50 01             	lea    0x1(%eax),%edx
  8012bb:	89 55 08             	mov    %edx,0x8(%ebp)
  8012be:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c4:	8a 00                	mov    (%eax),%al
  8012c6:	84 c0                	test   %al,%al
  8012c8:	74 18                	je     8012e2 <strsplit+0x52>
  8012ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cd:	8a 00                	mov    (%eax),%al
  8012cf:	0f be c0             	movsbl %al,%eax
  8012d2:	50                   	push   %eax
  8012d3:	ff 75 0c             	pushl  0xc(%ebp)
  8012d6:	e8 13 fb ff ff       	call   800dee <strchr>
  8012db:	83 c4 08             	add    $0x8,%esp
  8012de:	85 c0                	test   %eax,%eax
  8012e0:	75 d3                	jne    8012b5 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8012e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e5:	8a 00                	mov    (%eax),%al
  8012e7:	84 c0                	test   %al,%al
  8012e9:	74 5a                	je     801345 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8012eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ee:	8b 00                	mov    (%eax),%eax
  8012f0:	83 f8 0f             	cmp    $0xf,%eax
  8012f3:	75 07                	jne    8012fc <strsplit+0x6c>
		{
			return 0;
  8012f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8012fa:	eb 66                	jmp    801362 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ff:	8b 00                	mov    (%eax),%eax
  801301:	8d 48 01             	lea    0x1(%eax),%ecx
  801304:	8b 55 14             	mov    0x14(%ebp),%edx
  801307:	89 0a                	mov    %ecx,(%edx)
  801309:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801310:	8b 45 10             	mov    0x10(%ebp),%eax
  801313:	01 c2                	add    %eax,%edx
  801315:	8b 45 08             	mov    0x8(%ebp),%eax
  801318:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80131a:	eb 03                	jmp    80131f <strsplit+0x8f>
			string++;
  80131c:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80131f:	8b 45 08             	mov    0x8(%ebp),%eax
  801322:	8a 00                	mov    (%eax),%al
  801324:	84 c0                	test   %al,%al
  801326:	74 8b                	je     8012b3 <strsplit+0x23>
  801328:	8b 45 08             	mov    0x8(%ebp),%eax
  80132b:	8a 00                	mov    (%eax),%al
  80132d:	0f be c0             	movsbl %al,%eax
  801330:	50                   	push   %eax
  801331:	ff 75 0c             	pushl  0xc(%ebp)
  801334:	e8 b5 fa ff ff       	call   800dee <strchr>
  801339:	83 c4 08             	add    $0x8,%esp
  80133c:	85 c0                	test   %eax,%eax
  80133e:	74 dc                	je     80131c <strsplit+0x8c>
			string++;
	}
  801340:	e9 6e ff ff ff       	jmp    8012b3 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801345:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801346:	8b 45 14             	mov    0x14(%ebp),%eax
  801349:	8b 00                	mov    (%eax),%eax
  80134b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801352:	8b 45 10             	mov    0x10(%ebp),%eax
  801355:	01 d0                	add    %edx,%eax
  801357:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80135d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801362:	c9                   	leave  
  801363:	c3                   	ret    

00801364 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801364:	55                   	push   %ebp
  801365:	89 e5                	mov    %esp,%ebp
  801367:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  80136a:	a1 04 40 80 00       	mov    0x804004,%eax
  80136f:	85 c0                	test   %eax,%eax
  801371:	74 1f                	je     801392 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801373:	e8 1d 00 00 00       	call   801395 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801378:	83 ec 0c             	sub    $0xc,%esp
  80137b:	68 70 39 80 00       	push   $0x803970
  801380:	e8 55 f2 ff ff       	call   8005da <cprintf>
  801385:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801388:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  80138f:	00 00 00 
	}
}
  801392:	90                   	nop
  801393:	c9                   	leave  
  801394:	c3                   	ret    

00801395 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801395:	55                   	push   %ebp
  801396:	89 e5                	mov    %esp,%ebp
  801398:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  80139b:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  8013a2:	00 00 00 
  8013a5:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  8013ac:	00 00 00 
  8013af:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  8013b6:	00 00 00 
		LIST_INIT(&AllocMemBlocksList);
  8013b9:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  8013c0:	00 00 00 
  8013c3:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  8013ca:	00 00 00 
  8013cd:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  8013d4:	00 00 00 

		MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES ;
  8013d7:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  8013de:	00 02 00 
		MemBlockNodes =(struct MemBlock*)USER_DYN_BLKS_ARRAY ;
  8013e1:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  8013e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013eb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013f0:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013f5:	a3 50 40 80 00       	mov    %eax,0x804050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock),PAGE_SIZE),PERM_USER|PERM_WRITEABLE);
  8013fa:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801401:	a1 20 41 80 00       	mov    0x804120,%eax
  801406:	c1 e0 04             	shl    $0x4,%eax
  801409:	89 c2                	mov    %eax,%edx
  80140b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80140e:	01 d0                	add    %edx,%eax
  801410:	48                   	dec    %eax
  801411:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801414:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801417:	ba 00 00 00 00       	mov    $0x0,%edx
  80141c:	f7 75 f0             	divl   -0x10(%ebp)
  80141f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801422:	29 d0                	sub    %edx,%eax
  801424:	89 c2                	mov    %eax,%edx
  801426:	c7 45 e8 00 00 e0 7f 	movl   $0x7fe00000,-0x18(%ebp)
  80142d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801430:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801435:	2d 00 10 00 00       	sub    $0x1000,%eax
  80143a:	83 ec 04             	sub    $0x4,%esp
  80143d:	6a 06                	push   $0x6
  80143f:	52                   	push   %edx
  801440:	50                   	push   %eax
  801441:	e8 71 05 00 00       	call   8019b7 <sys_allocate_chunk>
  801446:	83 c4 10             	add    $0x10,%esp
		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801449:	a1 20 41 80 00       	mov    0x804120,%eax
  80144e:	83 ec 0c             	sub    $0xc,%esp
  801451:	50                   	push   %eax
  801452:	e8 e6 0b 00 00       	call   80203d <initialize_MemBlocksList>
  801457:	83 c4 10             	add    $0x10,%esp

		struct MemBlock  *block_node;
		block_node = AvailableMemBlocksList.lh_first;
  80145a:	a1 48 41 80 00       	mov    0x804148,%eax
  80145f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&(AvailableMemBlocksList),block_node);
  801462:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801466:	75 14                	jne    80147c <initialize_dyn_block_system+0xe7>
  801468:	83 ec 04             	sub    $0x4,%esp
  80146b:	68 95 39 80 00       	push   $0x803995
  801470:	6a 2b                	push   $0x2b
  801472:	68 b3 39 80 00       	push   $0x8039b3
  801477:	e8 aa ee ff ff       	call   800326 <_panic>
  80147c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80147f:	8b 00                	mov    (%eax),%eax
  801481:	85 c0                	test   %eax,%eax
  801483:	74 10                	je     801495 <initialize_dyn_block_system+0x100>
  801485:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801488:	8b 00                	mov    (%eax),%eax
  80148a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80148d:	8b 52 04             	mov    0x4(%edx),%edx
  801490:	89 50 04             	mov    %edx,0x4(%eax)
  801493:	eb 0b                	jmp    8014a0 <initialize_dyn_block_system+0x10b>
  801495:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801498:	8b 40 04             	mov    0x4(%eax),%eax
  80149b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8014a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014a3:	8b 40 04             	mov    0x4(%eax),%eax
  8014a6:	85 c0                	test   %eax,%eax
  8014a8:	74 0f                	je     8014b9 <initialize_dyn_block_system+0x124>
  8014aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014ad:	8b 40 04             	mov    0x4(%eax),%eax
  8014b0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8014b3:	8b 12                	mov    (%edx),%edx
  8014b5:	89 10                	mov    %edx,(%eax)
  8014b7:	eb 0a                	jmp    8014c3 <initialize_dyn_block_system+0x12e>
  8014b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014bc:	8b 00                	mov    (%eax),%eax
  8014be:	a3 48 41 80 00       	mov    %eax,0x804148
  8014c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8014cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014cf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8014d6:	a1 54 41 80 00       	mov    0x804154,%eax
  8014db:	48                   	dec    %eax
  8014dc:	a3 54 41 80 00       	mov    %eax,0x804154
		block_node->sva = USER_HEAP_START ;
  8014e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014e4:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
		block_node->size = ((USER_HEAP_MAX - USER_HEAP_START));
  8014eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014ee:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		insert_sorted_with_merge_freeList(block_node);
  8014f5:	83 ec 0c             	sub    $0xc,%esp
  8014f8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8014fb:	e8 d2 13 00 00       	call   8028d2 <insert_sorted_with_merge_freeList>
  801500:	83 c4 10             	add    $0x10,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801503:	90                   	nop
  801504:	c9                   	leave  
  801505:	c3                   	ret    

00801506 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801506:	55                   	push   %ebp
  801507:	89 e5                	mov    %esp,%ebp
  801509:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80150c:	e8 53 fe ff ff       	call   801364 <InitializeUHeap>
	if (size == 0) return NULL ;
  801511:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801515:	75 07                	jne    80151e <malloc+0x18>
  801517:	b8 00 00 00 00       	mov    $0x0,%eax
  80151c:	eb 61                	jmp    80157f <malloc+0x79>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	size= ROUNDUP(size,PAGE_SIZE);
  80151e:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801525:	8b 55 08             	mov    0x8(%ebp),%edx
  801528:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80152b:	01 d0                	add    %edx,%eax
  80152d:	48                   	dec    %eax
  80152e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801531:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801534:	ba 00 00 00 00       	mov    $0x0,%edx
  801539:	f7 75 f4             	divl   -0xc(%ebp)
  80153c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80153f:	29 d0                	sub    %edx,%eax
  801541:	89 45 08             	mov    %eax,0x8(%ebp)
	    			if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801544:	e8 3c 08 00 00       	call   801d85 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801549:	85 c0                	test   %eax,%eax
  80154b:	74 2d                	je     80157a <malloc+0x74>
	    			{
	    				struct MemBlock * ff_block = alloc_block_FF(size);
  80154d:	83 ec 0c             	sub    $0xc,%esp
  801550:	ff 75 08             	pushl  0x8(%ebp)
  801553:	e8 3e 0f 00 00       	call   802496 <alloc_block_FF>
  801558:	83 c4 10             	add    $0x10,%esp
  80155b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    				if(ff_block!=NULL)
  80155e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801562:	74 16                	je     80157a <malloc+0x74>
	    				{

	    					insert_sorted_allocList(ff_block);
  801564:	83 ec 0c             	sub    $0xc,%esp
  801567:	ff 75 ec             	pushl  -0x14(%ebp)
  80156a:	e8 48 0c 00 00       	call   8021b7 <insert_sorted_allocList>
  80156f:	83 c4 10             	add    $0x10,%esp
	    					return (void*) ff_block->sva ;
  801572:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801575:	8b 40 08             	mov    0x8(%eax),%eax
  801578:	eb 05                	jmp    80157f <malloc+0x79>

	    				}
	}
	    			return (void*) NULL ;
  80157a:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  80157f:	c9                   	leave  
  801580:	c3                   	ret    

00801581 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801581:	55                   	push   %ebp
  801582:	89 e5                	mov    %esp,%ebp
  801584:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock *elementForEach;
		virtual_address = ROUNDDOWN(virtual_address, PAGE_SIZE);
  801587:	8b 45 08             	mov    0x8(%ebp),%eax
  80158a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80158d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801590:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801595:	89 45 08             	mov    %eax,0x8(%ebp)
	//	if (is_mallocPages[indexindex((uint32) virtual_address)] == 1) {
		elementForEach = find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801598:	8b 45 08             	mov    0x8(%ebp),%eax
  80159b:	83 ec 08             	sub    $0x8,%esp
  80159e:	50                   	push   %eax
  80159f:	68 40 40 80 00       	push   $0x804040
  8015a4:	e8 71 0b 00 00       	call   80211a <find_block>
  8015a9:	83 c4 10             	add    $0x10,%esp
  8015ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
		sys_free_user_mem((uint32) virtual_address, elementForEach->size);
  8015af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015b2:	8b 50 0c             	mov    0xc(%eax),%edx
  8015b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b8:	83 ec 08             	sub    $0x8,%esp
  8015bb:	52                   	push   %edx
  8015bc:	50                   	push   %eax
  8015bd:	e8 bd 03 00 00       	call   80197f <sys_free_user_mem>
  8015c2:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,elementForEach);
  8015c5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8015c9:	75 14                	jne    8015df <free+0x5e>
  8015cb:	83 ec 04             	sub    $0x4,%esp
  8015ce:	68 95 39 80 00       	push   $0x803995
  8015d3:	6a 71                	push   $0x71
  8015d5:	68 b3 39 80 00       	push   $0x8039b3
  8015da:	e8 47 ed ff ff       	call   800326 <_panic>
  8015df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015e2:	8b 00                	mov    (%eax),%eax
  8015e4:	85 c0                	test   %eax,%eax
  8015e6:	74 10                	je     8015f8 <free+0x77>
  8015e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015eb:	8b 00                	mov    (%eax),%eax
  8015ed:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015f0:	8b 52 04             	mov    0x4(%edx),%edx
  8015f3:	89 50 04             	mov    %edx,0x4(%eax)
  8015f6:	eb 0b                	jmp    801603 <free+0x82>
  8015f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015fb:	8b 40 04             	mov    0x4(%eax),%eax
  8015fe:	a3 44 40 80 00       	mov    %eax,0x804044
  801603:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801606:	8b 40 04             	mov    0x4(%eax),%eax
  801609:	85 c0                	test   %eax,%eax
  80160b:	74 0f                	je     80161c <free+0x9b>
  80160d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801610:	8b 40 04             	mov    0x4(%eax),%eax
  801613:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801616:	8b 12                	mov    (%edx),%edx
  801618:	89 10                	mov    %edx,(%eax)
  80161a:	eb 0a                	jmp    801626 <free+0xa5>
  80161c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80161f:	8b 00                	mov    (%eax),%eax
  801621:	a3 40 40 80 00       	mov    %eax,0x804040
  801626:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801629:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80162f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801632:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801639:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80163e:	48                   	dec    %eax
  80163f:	a3 4c 40 80 00       	mov    %eax,0x80404c
		insert_sorted_with_merge_freeList(elementForEach);
  801644:	83 ec 0c             	sub    $0xc,%esp
  801647:	ff 75 f0             	pushl  -0x10(%ebp)
  80164a:	e8 83 12 00 00       	call   8028d2 <insert_sorted_with_merge_freeList>
  80164f:	83 c4 10             	add    $0x10,%esp
	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801652:	90                   	nop
  801653:	c9                   	leave  
  801654:	c3                   	ret    

00801655 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801655:	55                   	push   %ebp
  801656:	89 e5                	mov    %esp,%ebp
  801658:	83 ec 28             	sub    $0x28,%esp
  80165b:	8b 45 10             	mov    0x10(%ebp),%eax
  80165e:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801661:	e8 fe fc ff ff       	call   801364 <InitializeUHeap>
	if (size == 0) return NULL ;
  801666:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80166a:	75 0a                	jne    801676 <smalloc+0x21>
  80166c:	b8 00 00 00 00       	mov    $0x0,%eax
  801671:	e9 86 00 00 00       	jmp    8016fc <smalloc+0xa7>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code

	size=ROUNDUP(size,PAGE_SIZE);
  801676:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80167d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801680:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801683:	01 d0                	add    %edx,%eax
  801685:	48                   	dec    %eax
  801686:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801689:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80168c:	ba 00 00 00 00       	mov    $0x0,%edx
  801691:	f7 75 f4             	divl   -0xc(%ebp)
  801694:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801697:	29 d0                	sub    %edx,%eax
  801699:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80169c:	e8 e4 06 00 00       	call   801d85 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016a1:	85 c0                	test   %eax,%eax
  8016a3:	74 52                	je     8016f7 <smalloc+0xa2>
		{
		struct MemBlock * ff_block ;
		ff_block = alloc_block_FF(size);
  8016a5:	83 ec 0c             	sub    $0xc,%esp
  8016a8:	ff 75 0c             	pushl  0xc(%ebp)
  8016ab:	e8 e6 0d 00 00       	call   802496 <alloc_block_FF>
  8016b0:	83 c4 10             	add    $0x10,%esp
  8016b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(ff_block==NULL)
  8016b6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8016ba:	75 07                	jne    8016c3 <smalloc+0x6e>
			return NULL ;
  8016bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8016c1:	eb 39                	jmp    8016fc <smalloc+0xa7>

		int obj_id =sys_createSharedObject(sharedVarName,size,isWritable,(void*)ff_block->sva);
  8016c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016c6:	8b 40 08             	mov    0x8(%eax),%eax
  8016c9:	89 c2                	mov    %eax,%edx
  8016cb:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8016cf:	52                   	push   %edx
  8016d0:	50                   	push   %eax
  8016d1:	ff 75 0c             	pushl  0xc(%ebp)
  8016d4:	ff 75 08             	pushl  0x8(%ebp)
  8016d7:	e8 2e 04 00 00       	call   801b0a <sys_createSharedObject>
  8016dc:	83 c4 10             	add    $0x10,%esp
  8016df:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(obj_id < 0)
  8016e2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8016e6:	79 07                	jns    8016ef <smalloc+0x9a>
			return (void*)NULL ;
  8016e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ed:	eb 0d                	jmp    8016fc <smalloc+0xa7>
		else
		    return (void*)ff_block->sva ;
  8016ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016f2:	8b 40 08             	mov    0x8(%eax),%eax
  8016f5:	eb 05                	jmp    8016fc <smalloc+0xa7>
		}
		return (void*)NULL ;
  8016f7:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8016fc:	c9                   	leave  
  8016fd:	c3                   	ret    

008016fe <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016fe:	55                   	push   %ebp
  8016ff:	89 e5                	mov    %esp,%ebp
  801701:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801704:	e8 5b fc ff ff       	call   801364 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801709:	83 ec 08             	sub    $0x8,%esp
  80170c:	ff 75 0c             	pushl  0xc(%ebp)
  80170f:	ff 75 08             	pushl  0x8(%ebp)
  801712:	e8 1d 04 00 00       	call   801b34 <sys_getSizeOfSharedObject>
  801717:	83 c4 10             	add    $0x10,%esp
  80171a:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(size == 0)
  80171d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801721:	75 0a                	jne    80172d <sget+0x2f>
			return NULL ;
  801723:	b8 00 00 00 00       	mov    $0x0,%eax
  801728:	e9 83 00 00 00       	jmp    8017b0 <sget+0xb2>
		size=ROUNDUP(size,PAGE_SIZE);
  80172d:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801734:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801737:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80173a:	01 d0                	add    %edx,%eax
  80173c:	48                   	dec    %eax
  80173d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801740:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801743:	ba 00 00 00 00       	mov    $0x0,%edx
  801748:	f7 75 f0             	divl   -0x10(%ebp)
  80174b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80174e:	29 d0                	sub    %edx,%eax
  801750:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801753:	e8 2d 06 00 00       	call   801d85 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801758:	85 c0                	test   %eax,%eax
  80175a:	74 4f                	je     8017ab <sget+0xad>
		{
			struct MemBlock * ff_block ;
				ff_block = alloc_block_FF(size);
  80175c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80175f:	83 ec 0c             	sub    $0xc,%esp
  801762:	50                   	push   %eax
  801763:	e8 2e 0d 00 00       	call   802496 <alloc_block_FF>
  801768:	83 c4 10             	add    $0x10,%esp
  80176b:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ff_block==NULL)
  80176e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801772:	75 07                	jne    80177b <sget+0x7d>
					return (void*)NULL ;
  801774:	b8 00 00 00 00       	mov    $0x0,%eax
  801779:	eb 35                	jmp    8017b0 <sget+0xb2>

		int obj_id =sys_getSharedObject((int)ownerEnvID,sharedVarName,(void*)ff_block->sva);
  80177b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80177e:	8b 40 08             	mov    0x8(%eax),%eax
  801781:	83 ec 04             	sub    $0x4,%esp
  801784:	50                   	push   %eax
  801785:	ff 75 0c             	pushl  0xc(%ebp)
  801788:	ff 75 08             	pushl  0x8(%ebp)
  80178b:	e8 c1 03 00 00       	call   801b51 <sys_getSharedObject>
  801790:	83 c4 10             	add    $0x10,%esp
  801793:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if(obj_id<0)
  801796:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80179a:	79 07                	jns    8017a3 <sget+0xa5>
				return (void*)NULL ;
  80179c:	b8 00 00 00 00       	mov    $0x0,%eax
  8017a1:	eb 0d                	jmp    8017b0 <sget+0xb2>
			else
				return (void*)ff_block->sva ;
  8017a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017a6:	8b 40 08             	mov    0x8(%eax),%eax
  8017a9:	eb 05                	jmp    8017b0 <sget+0xb2>


		}
	return (void*)NULL ;
  8017ab:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8017b0:	c9                   	leave  
  8017b1:	c3                   	ret    

008017b2 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8017b2:	55                   	push   %ebp
  8017b3:	89 e5                	mov    %esp,%ebp
  8017b5:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017b8:	e8 a7 fb ff ff       	call   801364 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8017bd:	83 ec 04             	sub    $0x4,%esp
  8017c0:	68 c0 39 80 00       	push   $0x8039c0
  8017c5:	68 f9 00 00 00       	push   $0xf9
  8017ca:	68 b3 39 80 00       	push   $0x8039b3
  8017cf:	e8 52 eb ff ff       	call   800326 <_panic>

008017d4 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8017d4:	55                   	push   %ebp
  8017d5:	89 e5                	mov    %esp,%ebp
  8017d7:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8017da:	83 ec 04             	sub    $0x4,%esp
  8017dd:	68 e8 39 80 00       	push   $0x8039e8
  8017e2:	68 0d 01 00 00       	push   $0x10d
  8017e7:	68 b3 39 80 00       	push   $0x8039b3
  8017ec:	e8 35 eb ff ff       	call   800326 <_panic>

008017f1 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8017f1:	55                   	push   %ebp
  8017f2:	89 e5                	mov    %esp,%ebp
  8017f4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017f7:	83 ec 04             	sub    $0x4,%esp
  8017fa:	68 0c 3a 80 00       	push   $0x803a0c
  8017ff:	68 18 01 00 00       	push   $0x118
  801804:	68 b3 39 80 00       	push   $0x8039b3
  801809:	e8 18 eb ff ff       	call   800326 <_panic>

0080180e <shrink>:

}
void shrink(uint32 newSize)
{
  80180e:	55                   	push   %ebp
  80180f:	89 e5                	mov    %esp,%ebp
  801811:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801814:	83 ec 04             	sub    $0x4,%esp
  801817:	68 0c 3a 80 00       	push   $0x803a0c
  80181c:	68 1d 01 00 00       	push   $0x11d
  801821:	68 b3 39 80 00       	push   $0x8039b3
  801826:	e8 fb ea ff ff       	call   800326 <_panic>

0080182b <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80182b:	55                   	push   %ebp
  80182c:	89 e5                	mov    %esp,%ebp
  80182e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801831:	83 ec 04             	sub    $0x4,%esp
  801834:	68 0c 3a 80 00       	push   $0x803a0c
  801839:	68 22 01 00 00       	push   $0x122
  80183e:	68 b3 39 80 00       	push   $0x8039b3
  801843:	e8 de ea ff ff       	call   800326 <_panic>

00801848 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801848:	55                   	push   %ebp
  801849:	89 e5                	mov    %esp,%ebp
  80184b:	57                   	push   %edi
  80184c:	56                   	push   %esi
  80184d:	53                   	push   %ebx
  80184e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801851:	8b 45 08             	mov    0x8(%ebp),%eax
  801854:	8b 55 0c             	mov    0xc(%ebp),%edx
  801857:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80185a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80185d:	8b 7d 18             	mov    0x18(%ebp),%edi
  801860:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801863:	cd 30                	int    $0x30
  801865:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801868:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80186b:	83 c4 10             	add    $0x10,%esp
  80186e:	5b                   	pop    %ebx
  80186f:	5e                   	pop    %esi
  801870:	5f                   	pop    %edi
  801871:	5d                   	pop    %ebp
  801872:	c3                   	ret    

00801873 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801873:	55                   	push   %ebp
  801874:	89 e5                	mov    %esp,%ebp
  801876:	83 ec 04             	sub    $0x4,%esp
  801879:	8b 45 10             	mov    0x10(%ebp),%eax
  80187c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80187f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801883:	8b 45 08             	mov    0x8(%ebp),%eax
  801886:	6a 00                	push   $0x0
  801888:	6a 00                	push   $0x0
  80188a:	52                   	push   %edx
  80188b:	ff 75 0c             	pushl  0xc(%ebp)
  80188e:	50                   	push   %eax
  80188f:	6a 00                	push   $0x0
  801891:	e8 b2 ff ff ff       	call   801848 <syscall>
  801896:	83 c4 18             	add    $0x18,%esp
}
  801899:	90                   	nop
  80189a:	c9                   	leave  
  80189b:	c3                   	ret    

0080189c <sys_cgetc>:

int
sys_cgetc(void)
{
  80189c:	55                   	push   %ebp
  80189d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80189f:	6a 00                	push   $0x0
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 00                	push   $0x0
  8018a5:	6a 00                	push   $0x0
  8018a7:	6a 00                	push   $0x0
  8018a9:	6a 01                	push   $0x1
  8018ab:	e8 98 ff ff ff       	call   801848 <syscall>
  8018b0:	83 c4 18             	add    $0x18,%esp
}
  8018b3:	c9                   	leave  
  8018b4:	c3                   	ret    

008018b5 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018b5:	55                   	push   %ebp
  8018b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018be:	6a 00                	push   $0x0
  8018c0:	6a 00                	push   $0x0
  8018c2:	6a 00                	push   $0x0
  8018c4:	52                   	push   %edx
  8018c5:	50                   	push   %eax
  8018c6:	6a 05                	push   $0x5
  8018c8:	e8 7b ff ff ff       	call   801848 <syscall>
  8018cd:	83 c4 18             	add    $0x18,%esp
}
  8018d0:	c9                   	leave  
  8018d1:	c3                   	ret    

008018d2 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018d2:	55                   	push   %ebp
  8018d3:	89 e5                	mov    %esp,%ebp
  8018d5:	56                   	push   %esi
  8018d6:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018d7:	8b 75 18             	mov    0x18(%ebp),%esi
  8018da:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018dd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e6:	56                   	push   %esi
  8018e7:	53                   	push   %ebx
  8018e8:	51                   	push   %ecx
  8018e9:	52                   	push   %edx
  8018ea:	50                   	push   %eax
  8018eb:	6a 06                	push   $0x6
  8018ed:	e8 56 ff ff ff       	call   801848 <syscall>
  8018f2:	83 c4 18             	add    $0x18,%esp
}
  8018f5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018f8:	5b                   	pop    %ebx
  8018f9:	5e                   	pop    %esi
  8018fa:	5d                   	pop    %ebp
  8018fb:	c3                   	ret    

008018fc <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018fc:	55                   	push   %ebp
  8018fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801902:	8b 45 08             	mov    0x8(%ebp),%eax
  801905:	6a 00                	push   $0x0
  801907:	6a 00                	push   $0x0
  801909:	6a 00                	push   $0x0
  80190b:	52                   	push   %edx
  80190c:	50                   	push   %eax
  80190d:	6a 07                	push   $0x7
  80190f:	e8 34 ff ff ff       	call   801848 <syscall>
  801914:	83 c4 18             	add    $0x18,%esp
}
  801917:	c9                   	leave  
  801918:	c3                   	ret    

00801919 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801919:	55                   	push   %ebp
  80191a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80191c:	6a 00                	push   $0x0
  80191e:	6a 00                	push   $0x0
  801920:	6a 00                	push   $0x0
  801922:	ff 75 0c             	pushl  0xc(%ebp)
  801925:	ff 75 08             	pushl  0x8(%ebp)
  801928:	6a 08                	push   $0x8
  80192a:	e8 19 ff ff ff       	call   801848 <syscall>
  80192f:	83 c4 18             	add    $0x18,%esp
}
  801932:	c9                   	leave  
  801933:	c3                   	ret    

00801934 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801934:	55                   	push   %ebp
  801935:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801937:	6a 00                	push   $0x0
  801939:	6a 00                	push   $0x0
  80193b:	6a 00                	push   $0x0
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	6a 09                	push   $0x9
  801943:	e8 00 ff ff ff       	call   801848 <syscall>
  801948:	83 c4 18             	add    $0x18,%esp
}
  80194b:	c9                   	leave  
  80194c:	c3                   	ret    

0080194d <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80194d:	55                   	push   %ebp
  80194e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801950:	6a 00                	push   $0x0
  801952:	6a 00                	push   $0x0
  801954:	6a 00                	push   $0x0
  801956:	6a 00                	push   $0x0
  801958:	6a 00                	push   $0x0
  80195a:	6a 0a                	push   $0xa
  80195c:	e8 e7 fe ff ff       	call   801848 <syscall>
  801961:	83 c4 18             	add    $0x18,%esp
}
  801964:	c9                   	leave  
  801965:	c3                   	ret    

00801966 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801966:	55                   	push   %ebp
  801967:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801969:	6a 00                	push   $0x0
  80196b:	6a 00                	push   $0x0
  80196d:	6a 00                	push   $0x0
  80196f:	6a 00                	push   $0x0
  801971:	6a 00                	push   $0x0
  801973:	6a 0b                	push   $0xb
  801975:	e8 ce fe ff ff       	call   801848 <syscall>
  80197a:	83 c4 18             	add    $0x18,%esp
}
  80197d:	c9                   	leave  
  80197e:	c3                   	ret    

0080197f <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80197f:	55                   	push   %ebp
  801980:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	ff 75 0c             	pushl  0xc(%ebp)
  80198b:	ff 75 08             	pushl  0x8(%ebp)
  80198e:	6a 0f                	push   $0xf
  801990:	e8 b3 fe ff ff       	call   801848 <syscall>
  801995:	83 c4 18             	add    $0x18,%esp
	return;
  801998:	90                   	nop
}
  801999:	c9                   	leave  
  80199a:	c3                   	ret    

0080199b <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80199b:	55                   	push   %ebp
  80199c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80199e:	6a 00                	push   $0x0
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 00                	push   $0x0
  8019a4:	ff 75 0c             	pushl  0xc(%ebp)
  8019a7:	ff 75 08             	pushl  0x8(%ebp)
  8019aa:	6a 10                	push   $0x10
  8019ac:	e8 97 fe ff ff       	call   801848 <syscall>
  8019b1:	83 c4 18             	add    $0x18,%esp
	return ;
  8019b4:	90                   	nop
}
  8019b5:	c9                   	leave  
  8019b6:	c3                   	ret    

008019b7 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8019b7:	55                   	push   %ebp
  8019b8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	ff 75 10             	pushl  0x10(%ebp)
  8019c1:	ff 75 0c             	pushl  0xc(%ebp)
  8019c4:	ff 75 08             	pushl  0x8(%ebp)
  8019c7:	6a 11                	push   $0x11
  8019c9:	e8 7a fe ff ff       	call   801848 <syscall>
  8019ce:	83 c4 18             	add    $0x18,%esp
	return ;
  8019d1:	90                   	nop
}
  8019d2:	c9                   	leave  
  8019d3:	c3                   	ret    

008019d4 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019d4:	55                   	push   %ebp
  8019d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 0c                	push   $0xc
  8019e3:	e8 60 fe ff ff       	call   801848 <syscall>
  8019e8:	83 c4 18             	add    $0x18,%esp
}
  8019eb:	c9                   	leave  
  8019ec:	c3                   	ret    

008019ed <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019ed:	55                   	push   %ebp
  8019ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 00                	push   $0x0
  8019f8:	ff 75 08             	pushl  0x8(%ebp)
  8019fb:	6a 0d                	push   $0xd
  8019fd:	e8 46 fe ff ff       	call   801848 <syscall>
  801a02:	83 c4 18             	add    $0x18,%esp
}
  801a05:	c9                   	leave  
  801a06:	c3                   	ret    

00801a07 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a07:	55                   	push   %ebp
  801a08:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	6a 0e                	push   $0xe
  801a16:	e8 2d fe ff ff       	call   801848 <syscall>
  801a1b:	83 c4 18             	add    $0x18,%esp
}
  801a1e:	90                   	nop
  801a1f:	c9                   	leave  
  801a20:	c3                   	ret    

00801a21 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a21:	55                   	push   %ebp
  801a22:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a24:	6a 00                	push   $0x0
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 13                	push   $0x13
  801a30:	e8 13 fe ff ff       	call   801848 <syscall>
  801a35:	83 c4 18             	add    $0x18,%esp
}
  801a38:	90                   	nop
  801a39:	c9                   	leave  
  801a3a:	c3                   	ret    

00801a3b <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a3b:	55                   	push   %ebp
  801a3c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a3e:	6a 00                	push   $0x0
  801a40:	6a 00                	push   $0x0
  801a42:	6a 00                	push   $0x0
  801a44:	6a 00                	push   $0x0
  801a46:	6a 00                	push   $0x0
  801a48:	6a 14                	push   $0x14
  801a4a:	e8 f9 fd ff ff       	call   801848 <syscall>
  801a4f:	83 c4 18             	add    $0x18,%esp
}
  801a52:	90                   	nop
  801a53:	c9                   	leave  
  801a54:	c3                   	ret    

00801a55 <sys_cputc>:


void
sys_cputc(const char c)
{
  801a55:	55                   	push   %ebp
  801a56:	89 e5                	mov    %esp,%ebp
  801a58:	83 ec 04             	sub    $0x4,%esp
  801a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a61:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a65:	6a 00                	push   $0x0
  801a67:	6a 00                	push   $0x0
  801a69:	6a 00                	push   $0x0
  801a6b:	6a 00                	push   $0x0
  801a6d:	50                   	push   %eax
  801a6e:	6a 15                	push   $0x15
  801a70:	e8 d3 fd ff ff       	call   801848 <syscall>
  801a75:	83 c4 18             	add    $0x18,%esp
}
  801a78:	90                   	nop
  801a79:	c9                   	leave  
  801a7a:	c3                   	ret    

00801a7b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a7b:	55                   	push   %ebp
  801a7c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	6a 16                	push   $0x16
  801a8a:	e8 b9 fd ff ff       	call   801848 <syscall>
  801a8f:	83 c4 18             	add    $0x18,%esp
}
  801a92:	90                   	nop
  801a93:	c9                   	leave  
  801a94:	c3                   	ret    

00801a95 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a95:	55                   	push   %ebp
  801a96:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a98:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	ff 75 0c             	pushl  0xc(%ebp)
  801aa4:	50                   	push   %eax
  801aa5:	6a 17                	push   $0x17
  801aa7:	e8 9c fd ff ff       	call   801848 <syscall>
  801aac:	83 c4 18             	add    $0x18,%esp
}
  801aaf:	c9                   	leave  
  801ab0:	c3                   	ret    

00801ab1 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801ab1:	55                   	push   %ebp
  801ab2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ab4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	6a 00                	push   $0x0
  801ac0:	52                   	push   %edx
  801ac1:	50                   	push   %eax
  801ac2:	6a 1a                	push   $0x1a
  801ac4:	e8 7f fd ff ff       	call   801848 <syscall>
  801ac9:	83 c4 18             	add    $0x18,%esp
}
  801acc:	c9                   	leave  
  801acd:	c3                   	ret    

00801ace <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ace:	55                   	push   %ebp
  801acf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ad1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 00                	push   $0x0
  801add:	52                   	push   %edx
  801ade:	50                   	push   %eax
  801adf:	6a 18                	push   $0x18
  801ae1:	e8 62 fd ff ff       	call   801848 <syscall>
  801ae6:	83 c4 18             	add    $0x18,%esp
}
  801ae9:	90                   	nop
  801aea:	c9                   	leave  
  801aeb:	c3                   	ret    

00801aec <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801aec:	55                   	push   %ebp
  801aed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801aef:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af2:	8b 45 08             	mov    0x8(%ebp),%eax
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	52                   	push   %edx
  801afc:	50                   	push   %eax
  801afd:	6a 19                	push   $0x19
  801aff:	e8 44 fd ff ff       	call   801848 <syscall>
  801b04:	83 c4 18             	add    $0x18,%esp
}
  801b07:	90                   	nop
  801b08:	c9                   	leave  
  801b09:	c3                   	ret    

00801b0a <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b0a:	55                   	push   %ebp
  801b0b:	89 e5                	mov    %esp,%ebp
  801b0d:	83 ec 04             	sub    $0x4,%esp
  801b10:	8b 45 10             	mov    0x10(%ebp),%eax
  801b13:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b16:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b19:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b20:	6a 00                	push   $0x0
  801b22:	51                   	push   %ecx
  801b23:	52                   	push   %edx
  801b24:	ff 75 0c             	pushl  0xc(%ebp)
  801b27:	50                   	push   %eax
  801b28:	6a 1b                	push   $0x1b
  801b2a:	e8 19 fd ff ff       	call   801848 <syscall>
  801b2f:	83 c4 18             	add    $0x18,%esp
}
  801b32:	c9                   	leave  
  801b33:	c3                   	ret    

00801b34 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b34:	55                   	push   %ebp
  801b35:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b37:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 00                	push   $0x0
  801b43:	52                   	push   %edx
  801b44:	50                   	push   %eax
  801b45:	6a 1c                	push   $0x1c
  801b47:	e8 fc fc ff ff       	call   801848 <syscall>
  801b4c:	83 c4 18             	add    $0x18,%esp
}
  801b4f:	c9                   	leave  
  801b50:	c3                   	ret    

00801b51 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b51:	55                   	push   %ebp
  801b52:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b54:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b57:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5d:	6a 00                	push   $0x0
  801b5f:	6a 00                	push   $0x0
  801b61:	51                   	push   %ecx
  801b62:	52                   	push   %edx
  801b63:	50                   	push   %eax
  801b64:	6a 1d                	push   $0x1d
  801b66:	e8 dd fc ff ff       	call   801848 <syscall>
  801b6b:	83 c4 18             	add    $0x18,%esp
}
  801b6e:	c9                   	leave  
  801b6f:	c3                   	ret    

00801b70 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b70:	55                   	push   %ebp
  801b71:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b73:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b76:	8b 45 08             	mov    0x8(%ebp),%eax
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	52                   	push   %edx
  801b80:	50                   	push   %eax
  801b81:	6a 1e                	push   $0x1e
  801b83:	e8 c0 fc ff ff       	call   801848 <syscall>
  801b88:	83 c4 18             	add    $0x18,%esp
}
  801b8b:	c9                   	leave  
  801b8c:	c3                   	ret    

00801b8d <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b8d:	55                   	push   %ebp
  801b8e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 1f                	push   $0x1f
  801b9c:	e8 a7 fc ff ff       	call   801848 <syscall>
  801ba1:	83 c4 18             	add    $0x18,%esp
}
  801ba4:	c9                   	leave  
  801ba5:	c3                   	ret    

00801ba6 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801ba6:	55                   	push   %ebp
  801ba7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bac:	6a 00                	push   $0x0
  801bae:	ff 75 14             	pushl  0x14(%ebp)
  801bb1:	ff 75 10             	pushl  0x10(%ebp)
  801bb4:	ff 75 0c             	pushl  0xc(%ebp)
  801bb7:	50                   	push   %eax
  801bb8:	6a 20                	push   $0x20
  801bba:	e8 89 fc ff ff       	call   801848 <syscall>
  801bbf:	83 c4 18             	add    $0x18,%esp
}
  801bc2:	c9                   	leave  
  801bc3:	c3                   	ret    

00801bc4 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801bc4:	55                   	push   %ebp
  801bc5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 00                	push   $0x0
  801bd2:	50                   	push   %eax
  801bd3:	6a 21                	push   $0x21
  801bd5:	e8 6e fc ff ff       	call   801848 <syscall>
  801bda:	83 c4 18             	add    $0x18,%esp
}
  801bdd:	90                   	nop
  801bde:	c9                   	leave  
  801bdf:	c3                   	ret    

00801be0 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801be0:	55                   	push   %ebp
  801be1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801be3:	8b 45 08             	mov    0x8(%ebp),%eax
  801be6:	6a 00                	push   $0x0
  801be8:	6a 00                	push   $0x0
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	50                   	push   %eax
  801bef:	6a 22                	push   $0x22
  801bf1:	e8 52 fc ff ff       	call   801848 <syscall>
  801bf6:	83 c4 18             	add    $0x18,%esp
}
  801bf9:	c9                   	leave  
  801bfa:	c3                   	ret    

00801bfb <sys_getenvid>:

int32 sys_getenvid(void)
{
  801bfb:	55                   	push   %ebp
  801bfc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	6a 02                	push   $0x2
  801c0a:	e8 39 fc ff ff       	call   801848 <syscall>
  801c0f:	83 c4 18             	add    $0x18,%esp
}
  801c12:	c9                   	leave  
  801c13:	c3                   	ret    

00801c14 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c14:	55                   	push   %ebp
  801c15:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c17:	6a 00                	push   $0x0
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 03                	push   $0x3
  801c23:	e8 20 fc ff ff       	call   801848 <syscall>
  801c28:	83 c4 18             	add    $0x18,%esp
}
  801c2b:	c9                   	leave  
  801c2c:	c3                   	ret    

00801c2d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c2d:	55                   	push   %ebp
  801c2e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 04                	push   $0x4
  801c3c:	e8 07 fc ff ff       	call   801848 <syscall>
  801c41:	83 c4 18             	add    $0x18,%esp
}
  801c44:	c9                   	leave  
  801c45:	c3                   	ret    

00801c46 <sys_exit_env>:


void sys_exit_env(void)
{
  801c46:	55                   	push   %ebp
  801c47:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 23                	push   $0x23
  801c55:	e8 ee fb ff ff       	call   801848 <syscall>
  801c5a:	83 c4 18             	add    $0x18,%esp
}
  801c5d:	90                   	nop
  801c5e:	c9                   	leave  
  801c5f:	c3                   	ret    

00801c60 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c60:	55                   	push   %ebp
  801c61:	89 e5                	mov    %esp,%ebp
  801c63:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c66:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c69:	8d 50 04             	lea    0x4(%eax),%edx
  801c6c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 00                	push   $0x0
  801c73:	6a 00                	push   $0x0
  801c75:	52                   	push   %edx
  801c76:	50                   	push   %eax
  801c77:	6a 24                	push   $0x24
  801c79:	e8 ca fb ff ff       	call   801848 <syscall>
  801c7e:	83 c4 18             	add    $0x18,%esp
	return result;
  801c81:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c84:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c87:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c8a:	89 01                	mov    %eax,(%ecx)
  801c8c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c92:	c9                   	leave  
  801c93:	c2 04 00             	ret    $0x4

00801c96 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c96:	55                   	push   %ebp
  801c97:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c99:	6a 00                	push   $0x0
  801c9b:	6a 00                	push   $0x0
  801c9d:	ff 75 10             	pushl  0x10(%ebp)
  801ca0:	ff 75 0c             	pushl  0xc(%ebp)
  801ca3:	ff 75 08             	pushl  0x8(%ebp)
  801ca6:	6a 12                	push   $0x12
  801ca8:	e8 9b fb ff ff       	call   801848 <syscall>
  801cad:	83 c4 18             	add    $0x18,%esp
	return ;
  801cb0:	90                   	nop
}
  801cb1:	c9                   	leave  
  801cb2:	c3                   	ret    

00801cb3 <sys_rcr2>:
uint32 sys_rcr2()
{
  801cb3:	55                   	push   %ebp
  801cb4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801cb6:	6a 00                	push   $0x0
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 25                	push   $0x25
  801cc2:	e8 81 fb ff ff       	call   801848 <syscall>
  801cc7:	83 c4 18             	add    $0x18,%esp
}
  801cca:	c9                   	leave  
  801ccb:	c3                   	ret    

00801ccc <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801ccc:	55                   	push   %ebp
  801ccd:	89 e5                	mov    %esp,%ebp
  801ccf:	83 ec 04             	sub    $0x4,%esp
  801cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801cd8:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801cdc:	6a 00                	push   $0x0
  801cde:	6a 00                	push   $0x0
  801ce0:	6a 00                	push   $0x0
  801ce2:	6a 00                	push   $0x0
  801ce4:	50                   	push   %eax
  801ce5:	6a 26                	push   $0x26
  801ce7:	e8 5c fb ff ff       	call   801848 <syscall>
  801cec:	83 c4 18             	add    $0x18,%esp
	return ;
  801cef:	90                   	nop
}
  801cf0:	c9                   	leave  
  801cf1:	c3                   	ret    

00801cf2 <rsttst>:
void rsttst()
{
  801cf2:	55                   	push   %ebp
  801cf3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801cf5:	6a 00                	push   $0x0
  801cf7:	6a 00                	push   $0x0
  801cf9:	6a 00                	push   $0x0
  801cfb:	6a 00                	push   $0x0
  801cfd:	6a 00                	push   $0x0
  801cff:	6a 28                	push   $0x28
  801d01:	e8 42 fb ff ff       	call   801848 <syscall>
  801d06:	83 c4 18             	add    $0x18,%esp
	return ;
  801d09:	90                   	nop
}
  801d0a:	c9                   	leave  
  801d0b:	c3                   	ret    

00801d0c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d0c:	55                   	push   %ebp
  801d0d:	89 e5                	mov    %esp,%ebp
  801d0f:	83 ec 04             	sub    $0x4,%esp
  801d12:	8b 45 14             	mov    0x14(%ebp),%eax
  801d15:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d18:	8b 55 18             	mov    0x18(%ebp),%edx
  801d1b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d1f:	52                   	push   %edx
  801d20:	50                   	push   %eax
  801d21:	ff 75 10             	pushl  0x10(%ebp)
  801d24:	ff 75 0c             	pushl  0xc(%ebp)
  801d27:	ff 75 08             	pushl  0x8(%ebp)
  801d2a:	6a 27                	push   $0x27
  801d2c:	e8 17 fb ff ff       	call   801848 <syscall>
  801d31:	83 c4 18             	add    $0x18,%esp
	return ;
  801d34:	90                   	nop
}
  801d35:	c9                   	leave  
  801d36:	c3                   	ret    

00801d37 <chktst>:
void chktst(uint32 n)
{
  801d37:	55                   	push   %ebp
  801d38:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d3a:	6a 00                	push   $0x0
  801d3c:	6a 00                	push   $0x0
  801d3e:	6a 00                	push   $0x0
  801d40:	6a 00                	push   $0x0
  801d42:	ff 75 08             	pushl  0x8(%ebp)
  801d45:	6a 29                	push   $0x29
  801d47:	e8 fc fa ff ff       	call   801848 <syscall>
  801d4c:	83 c4 18             	add    $0x18,%esp
	return ;
  801d4f:	90                   	nop
}
  801d50:	c9                   	leave  
  801d51:	c3                   	ret    

00801d52 <inctst>:

void inctst()
{
  801d52:	55                   	push   %ebp
  801d53:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d55:	6a 00                	push   $0x0
  801d57:	6a 00                	push   $0x0
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 00                	push   $0x0
  801d5f:	6a 2a                	push   $0x2a
  801d61:	e8 e2 fa ff ff       	call   801848 <syscall>
  801d66:	83 c4 18             	add    $0x18,%esp
	return ;
  801d69:	90                   	nop
}
  801d6a:	c9                   	leave  
  801d6b:	c3                   	ret    

00801d6c <gettst>:
uint32 gettst()
{
  801d6c:	55                   	push   %ebp
  801d6d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	6a 00                	push   $0x0
  801d75:	6a 00                	push   $0x0
  801d77:	6a 00                	push   $0x0
  801d79:	6a 2b                	push   $0x2b
  801d7b:	e8 c8 fa ff ff       	call   801848 <syscall>
  801d80:	83 c4 18             	add    $0x18,%esp
}
  801d83:	c9                   	leave  
  801d84:	c3                   	ret    

00801d85 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d85:	55                   	push   %ebp
  801d86:	89 e5                	mov    %esp,%ebp
  801d88:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 00                	push   $0x0
  801d8f:	6a 00                	push   $0x0
  801d91:	6a 00                	push   $0x0
  801d93:	6a 00                	push   $0x0
  801d95:	6a 2c                	push   $0x2c
  801d97:	e8 ac fa ff ff       	call   801848 <syscall>
  801d9c:	83 c4 18             	add    $0x18,%esp
  801d9f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801da2:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801da6:	75 07                	jne    801daf <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801da8:	b8 01 00 00 00       	mov    $0x1,%eax
  801dad:	eb 05                	jmp    801db4 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801daf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801db4:	c9                   	leave  
  801db5:	c3                   	ret    

00801db6 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801db6:	55                   	push   %ebp
  801db7:	89 e5                	mov    %esp,%ebp
  801db9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 00                	push   $0x0
  801dc2:	6a 00                	push   $0x0
  801dc4:	6a 00                	push   $0x0
  801dc6:	6a 2c                	push   $0x2c
  801dc8:	e8 7b fa ff ff       	call   801848 <syscall>
  801dcd:	83 c4 18             	add    $0x18,%esp
  801dd0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801dd3:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801dd7:	75 07                	jne    801de0 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801dd9:	b8 01 00 00 00       	mov    $0x1,%eax
  801dde:	eb 05                	jmp    801de5 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801de0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801de5:	c9                   	leave  
  801de6:	c3                   	ret    

00801de7 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801de7:	55                   	push   %ebp
  801de8:	89 e5                	mov    %esp,%ebp
  801dea:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ded:	6a 00                	push   $0x0
  801def:	6a 00                	push   $0x0
  801df1:	6a 00                	push   $0x0
  801df3:	6a 00                	push   $0x0
  801df5:	6a 00                	push   $0x0
  801df7:	6a 2c                	push   $0x2c
  801df9:	e8 4a fa ff ff       	call   801848 <syscall>
  801dfe:	83 c4 18             	add    $0x18,%esp
  801e01:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e04:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e08:	75 07                	jne    801e11 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e0a:	b8 01 00 00 00       	mov    $0x1,%eax
  801e0f:	eb 05                	jmp    801e16 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e11:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e16:	c9                   	leave  
  801e17:	c3                   	ret    

00801e18 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e18:	55                   	push   %ebp
  801e19:	89 e5                	mov    %esp,%ebp
  801e1b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e1e:	6a 00                	push   $0x0
  801e20:	6a 00                	push   $0x0
  801e22:	6a 00                	push   $0x0
  801e24:	6a 00                	push   $0x0
  801e26:	6a 00                	push   $0x0
  801e28:	6a 2c                	push   $0x2c
  801e2a:	e8 19 fa ff ff       	call   801848 <syscall>
  801e2f:	83 c4 18             	add    $0x18,%esp
  801e32:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e35:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e39:	75 07                	jne    801e42 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e3b:	b8 01 00 00 00       	mov    $0x1,%eax
  801e40:	eb 05                	jmp    801e47 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e42:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e47:	c9                   	leave  
  801e48:	c3                   	ret    

00801e49 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e49:	55                   	push   %ebp
  801e4a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e4c:	6a 00                	push   $0x0
  801e4e:	6a 00                	push   $0x0
  801e50:	6a 00                	push   $0x0
  801e52:	6a 00                	push   $0x0
  801e54:	ff 75 08             	pushl  0x8(%ebp)
  801e57:	6a 2d                	push   $0x2d
  801e59:	e8 ea f9 ff ff       	call   801848 <syscall>
  801e5e:	83 c4 18             	add    $0x18,%esp
	return ;
  801e61:	90                   	nop
}
  801e62:	c9                   	leave  
  801e63:	c3                   	ret    

00801e64 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e64:	55                   	push   %ebp
  801e65:	89 e5                	mov    %esp,%ebp
  801e67:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e68:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e6b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e6e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e71:	8b 45 08             	mov    0x8(%ebp),%eax
  801e74:	6a 00                	push   $0x0
  801e76:	53                   	push   %ebx
  801e77:	51                   	push   %ecx
  801e78:	52                   	push   %edx
  801e79:	50                   	push   %eax
  801e7a:	6a 2e                	push   $0x2e
  801e7c:	e8 c7 f9 ff ff       	call   801848 <syscall>
  801e81:	83 c4 18             	add    $0x18,%esp
}
  801e84:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e87:	c9                   	leave  
  801e88:	c3                   	ret    

00801e89 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e89:	55                   	push   %ebp
  801e8a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e92:	6a 00                	push   $0x0
  801e94:	6a 00                	push   $0x0
  801e96:	6a 00                	push   $0x0
  801e98:	52                   	push   %edx
  801e99:	50                   	push   %eax
  801e9a:	6a 2f                	push   $0x2f
  801e9c:	e8 a7 f9 ff ff       	call   801848 <syscall>
  801ea1:	83 c4 18             	add    $0x18,%esp
}
  801ea4:	c9                   	leave  
  801ea5:	c3                   	ret    

00801ea6 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801ea6:	55                   	push   %ebp
  801ea7:	89 e5                	mov    %esp,%ebp
  801ea9:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801eac:	83 ec 0c             	sub    $0xc,%esp
  801eaf:	68 1c 3a 80 00       	push   $0x803a1c
  801eb4:	e8 21 e7 ff ff       	call   8005da <cprintf>
  801eb9:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801ebc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801ec3:	83 ec 0c             	sub    $0xc,%esp
  801ec6:	68 48 3a 80 00       	push   $0x803a48
  801ecb:	e8 0a e7 ff ff       	call   8005da <cprintf>
  801ed0:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801ed3:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ed7:	a1 38 41 80 00       	mov    0x804138,%eax
  801edc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801edf:	eb 56                	jmp    801f37 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ee1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ee5:	74 1c                	je     801f03 <print_mem_block_lists+0x5d>
  801ee7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eea:	8b 50 08             	mov    0x8(%eax),%edx
  801eed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ef0:	8b 48 08             	mov    0x8(%eax),%ecx
  801ef3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ef6:	8b 40 0c             	mov    0xc(%eax),%eax
  801ef9:	01 c8                	add    %ecx,%eax
  801efb:	39 c2                	cmp    %eax,%edx
  801efd:	73 04                	jae    801f03 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801eff:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f06:	8b 50 08             	mov    0x8(%eax),%edx
  801f09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f0c:	8b 40 0c             	mov    0xc(%eax),%eax
  801f0f:	01 c2                	add    %eax,%edx
  801f11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f14:	8b 40 08             	mov    0x8(%eax),%eax
  801f17:	83 ec 04             	sub    $0x4,%esp
  801f1a:	52                   	push   %edx
  801f1b:	50                   	push   %eax
  801f1c:	68 5d 3a 80 00       	push   $0x803a5d
  801f21:	e8 b4 e6 ff ff       	call   8005da <cprintf>
  801f26:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f2f:	a1 40 41 80 00       	mov    0x804140,%eax
  801f34:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f37:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f3b:	74 07                	je     801f44 <print_mem_block_lists+0x9e>
  801f3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f40:	8b 00                	mov    (%eax),%eax
  801f42:	eb 05                	jmp    801f49 <print_mem_block_lists+0xa3>
  801f44:	b8 00 00 00 00       	mov    $0x0,%eax
  801f49:	a3 40 41 80 00       	mov    %eax,0x804140
  801f4e:	a1 40 41 80 00       	mov    0x804140,%eax
  801f53:	85 c0                	test   %eax,%eax
  801f55:	75 8a                	jne    801ee1 <print_mem_block_lists+0x3b>
  801f57:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f5b:	75 84                	jne    801ee1 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f5d:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f61:	75 10                	jne    801f73 <print_mem_block_lists+0xcd>
  801f63:	83 ec 0c             	sub    $0xc,%esp
  801f66:	68 6c 3a 80 00       	push   $0x803a6c
  801f6b:	e8 6a e6 ff ff       	call   8005da <cprintf>
  801f70:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f73:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f7a:	83 ec 0c             	sub    $0xc,%esp
  801f7d:	68 90 3a 80 00       	push   $0x803a90
  801f82:	e8 53 e6 ff ff       	call   8005da <cprintf>
  801f87:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f8a:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f8e:	a1 40 40 80 00       	mov    0x804040,%eax
  801f93:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f96:	eb 56                	jmp    801fee <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f98:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f9c:	74 1c                	je     801fba <print_mem_block_lists+0x114>
  801f9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa1:	8b 50 08             	mov    0x8(%eax),%edx
  801fa4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fa7:	8b 48 08             	mov    0x8(%eax),%ecx
  801faa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fad:	8b 40 0c             	mov    0xc(%eax),%eax
  801fb0:	01 c8                	add    %ecx,%eax
  801fb2:	39 c2                	cmp    %eax,%edx
  801fb4:	73 04                	jae    801fba <print_mem_block_lists+0x114>
			sorted = 0 ;
  801fb6:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801fba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fbd:	8b 50 08             	mov    0x8(%eax),%edx
  801fc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc3:	8b 40 0c             	mov    0xc(%eax),%eax
  801fc6:	01 c2                	add    %eax,%edx
  801fc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fcb:	8b 40 08             	mov    0x8(%eax),%eax
  801fce:	83 ec 04             	sub    $0x4,%esp
  801fd1:	52                   	push   %edx
  801fd2:	50                   	push   %eax
  801fd3:	68 5d 3a 80 00       	push   $0x803a5d
  801fd8:	e8 fd e5 ff ff       	call   8005da <cprintf>
  801fdd:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fe0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801fe6:	a1 48 40 80 00       	mov    0x804048,%eax
  801feb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ff2:	74 07                	je     801ffb <print_mem_block_lists+0x155>
  801ff4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff7:	8b 00                	mov    (%eax),%eax
  801ff9:	eb 05                	jmp    802000 <print_mem_block_lists+0x15a>
  801ffb:	b8 00 00 00 00       	mov    $0x0,%eax
  802000:	a3 48 40 80 00       	mov    %eax,0x804048
  802005:	a1 48 40 80 00       	mov    0x804048,%eax
  80200a:	85 c0                	test   %eax,%eax
  80200c:	75 8a                	jne    801f98 <print_mem_block_lists+0xf2>
  80200e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802012:	75 84                	jne    801f98 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802014:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802018:	75 10                	jne    80202a <print_mem_block_lists+0x184>
  80201a:	83 ec 0c             	sub    $0xc,%esp
  80201d:	68 a8 3a 80 00       	push   $0x803aa8
  802022:	e8 b3 e5 ff ff       	call   8005da <cprintf>
  802027:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80202a:	83 ec 0c             	sub    $0xc,%esp
  80202d:	68 1c 3a 80 00       	push   $0x803a1c
  802032:	e8 a3 e5 ff ff       	call   8005da <cprintf>
  802037:	83 c4 10             	add    $0x10,%esp

}
  80203a:	90                   	nop
  80203b:	c9                   	leave  
  80203c:	c3                   	ret    

0080203d <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80203d:	55                   	push   %ebp
  80203e:	89 e5                	mov    %esp,%ebp
  802040:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  802043:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  80204a:	00 00 00 
  80204d:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  802054:	00 00 00 
  802057:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  80205e:	00 00 00 
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  802061:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802068:	e9 9e 00 00 00       	jmp    80210b <initialize_MemBlocksList+0xce>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
  80206d:	a1 50 40 80 00       	mov    0x804050,%eax
  802072:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802075:	c1 e2 04             	shl    $0x4,%edx
  802078:	01 d0                	add    %edx,%eax
  80207a:	85 c0                	test   %eax,%eax
  80207c:	75 14                	jne    802092 <initialize_MemBlocksList+0x55>
  80207e:	83 ec 04             	sub    $0x4,%esp
  802081:	68 d0 3a 80 00       	push   $0x803ad0
  802086:	6a 43                	push   $0x43
  802088:	68 f3 3a 80 00       	push   $0x803af3
  80208d:	e8 94 e2 ff ff       	call   800326 <_panic>
  802092:	a1 50 40 80 00       	mov    0x804050,%eax
  802097:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80209a:	c1 e2 04             	shl    $0x4,%edx
  80209d:	01 d0                	add    %edx,%eax
  80209f:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8020a5:	89 10                	mov    %edx,(%eax)
  8020a7:	8b 00                	mov    (%eax),%eax
  8020a9:	85 c0                	test   %eax,%eax
  8020ab:	74 18                	je     8020c5 <initialize_MemBlocksList+0x88>
  8020ad:	a1 48 41 80 00       	mov    0x804148,%eax
  8020b2:	8b 15 50 40 80 00    	mov    0x804050,%edx
  8020b8:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8020bb:	c1 e1 04             	shl    $0x4,%ecx
  8020be:	01 ca                	add    %ecx,%edx
  8020c0:	89 50 04             	mov    %edx,0x4(%eax)
  8020c3:	eb 12                	jmp    8020d7 <initialize_MemBlocksList+0x9a>
  8020c5:	a1 50 40 80 00       	mov    0x804050,%eax
  8020ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020cd:	c1 e2 04             	shl    $0x4,%edx
  8020d0:	01 d0                	add    %edx,%eax
  8020d2:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8020d7:	a1 50 40 80 00       	mov    0x804050,%eax
  8020dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020df:	c1 e2 04             	shl    $0x4,%edx
  8020e2:	01 d0                	add    %edx,%eax
  8020e4:	a3 48 41 80 00       	mov    %eax,0x804148
  8020e9:	a1 50 40 80 00       	mov    0x804050,%eax
  8020ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020f1:	c1 e2 04             	shl    $0x4,%edx
  8020f4:	01 d0                	add    %edx,%eax
  8020f6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020fd:	a1 54 41 80 00       	mov    0x804154,%eax
  802102:	40                   	inc    %eax
  802103:	a3 54 41 80 00       	mov    %eax,0x804154
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  802108:	ff 45 f4             	incl   -0xc(%ebp)
  80210b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802111:	0f 82 56 ff ff ff    	jb     80206d <initialize_MemBlocksList+0x30>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
		}
}
  802117:	90                   	nop
  802118:	c9                   	leave  
  802119:	c3                   	ret    

0080211a <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80211a:	55                   	push   %ebp
  80211b:	89 e5                	mov    %esp,%ebp
  80211d:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  802120:	a1 38 41 80 00       	mov    0x804138,%eax
  802125:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802128:	eb 18                	jmp    802142 <find_block+0x28>
	{
		if (ele->sva==va)
  80212a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80212d:	8b 40 08             	mov    0x8(%eax),%eax
  802130:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802133:	75 05                	jne    80213a <find_block+0x20>
			return ele;
  802135:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802138:	eb 7b                	jmp    8021b5 <find_block+0x9b>
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  80213a:	a1 40 41 80 00       	mov    0x804140,%eax
  80213f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802142:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802146:	74 07                	je     80214f <find_block+0x35>
  802148:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80214b:	8b 00                	mov    (%eax),%eax
  80214d:	eb 05                	jmp    802154 <find_block+0x3a>
  80214f:	b8 00 00 00 00       	mov    $0x0,%eax
  802154:	a3 40 41 80 00       	mov    %eax,0x804140
  802159:	a1 40 41 80 00       	mov    0x804140,%eax
  80215e:	85 c0                	test   %eax,%eax
  802160:	75 c8                	jne    80212a <find_block+0x10>
  802162:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802166:	75 c2                	jne    80212a <find_block+0x10>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  802168:	a1 40 40 80 00       	mov    0x804040,%eax
  80216d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802170:	eb 18                	jmp    80218a <find_block+0x70>
	{
		if (ele->sva==va)
  802172:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802175:	8b 40 08             	mov    0x8(%eax),%eax
  802178:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80217b:	75 05                	jne    802182 <find_block+0x68>
					return ele;
  80217d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802180:	eb 33                	jmp    8021b5 <find_block+0x9b>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  802182:	a1 48 40 80 00       	mov    0x804048,%eax
  802187:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80218a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80218e:	74 07                	je     802197 <find_block+0x7d>
  802190:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802193:	8b 00                	mov    (%eax),%eax
  802195:	eb 05                	jmp    80219c <find_block+0x82>
  802197:	b8 00 00 00 00       	mov    $0x0,%eax
  80219c:	a3 48 40 80 00       	mov    %eax,0x804048
  8021a1:	a1 48 40 80 00       	mov    0x804048,%eax
  8021a6:	85 c0                	test   %eax,%eax
  8021a8:	75 c8                	jne    802172 <find_block+0x58>
  8021aa:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021ae:	75 c2                	jne    802172 <find_block+0x58>
	{
		if (ele->sva==va)
					return ele;
	}
return NULL;
  8021b0:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  8021b5:	c9                   	leave  
  8021b6:	c3                   	ret    

008021b7 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8021b7:	55                   	push   %ebp
  8021b8:	89 e5                	mov    %esp,%ebp
  8021ba:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;

int x =LIST_SIZE(&AllocMemBlocksList);
  8021bd:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021c2:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((x==0))
  8021c5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021c9:	75 62                	jne    80222d <insert_sorted_allocList+0x76>
	{
	//	blockToInsert=AllocMemBlocksList.lh_first;
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  8021cb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021cf:	75 14                	jne    8021e5 <insert_sorted_allocList+0x2e>
  8021d1:	83 ec 04             	sub    $0x4,%esp
  8021d4:	68 d0 3a 80 00       	push   $0x803ad0
  8021d9:	6a 69                	push   $0x69
  8021db:	68 f3 3a 80 00       	push   $0x803af3
  8021e0:	e8 41 e1 ff ff       	call   800326 <_panic>
  8021e5:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8021eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ee:	89 10                	mov    %edx,(%eax)
  8021f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f3:	8b 00                	mov    (%eax),%eax
  8021f5:	85 c0                	test   %eax,%eax
  8021f7:	74 0d                	je     802206 <insert_sorted_allocList+0x4f>
  8021f9:	a1 40 40 80 00       	mov    0x804040,%eax
  8021fe:	8b 55 08             	mov    0x8(%ebp),%edx
  802201:	89 50 04             	mov    %edx,0x4(%eax)
  802204:	eb 08                	jmp    80220e <insert_sorted_allocList+0x57>
  802206:	8b 45 08             	mov    0x8(%ebp),%eax
  802209:	a3 44 40 80 00       	mov    %eax,0x804044
  80220e:	8b 45 08             	mov    0x8(%ebp),%eax
  802211:	a3 40 40 80 00       	mov    %eax,0x804040
  802216:	8b 45 08             	mov    0x8(%ebp),%eax
  802219:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802220:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802225:	40                   	inc    %eax
  802226:	a3 4c 40 80 00       	mov    %eax,0x80404c
  80222b:	eb 72                	jmp    80229f <insert_sorted_allocList+0xe8>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
  80222d:	a1 40 40 80 00       	mov    0x804040,%eax
  802232:	8b 50 08             	mov    0x8(%eax),%edx
  802235:	8b 45 08             	mov    0x8(%ebp),%eax
  802238:	8b 40 08             	mov    0x8(%eax),%eax
  80223b:	39 c2                	cmp    %eax,%edx
  80223d:	76 60                	jbe    80229f <insert_sorted_allocList+0xe8>
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  80223f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802243:	75 14                	jne    802259 <insert_sorted_allocList+0xa2>
  802245:	83 ec 04             	sub    $0x4,%esp
  802248:	68 d0 3a 80 00       	push   $0x803ad0
  80224d:	6a 6d                	push   $0x6d
  80224f:	68 f3 3a 80 00       	push   $0x803af3
  802254:	e8 cd e0 ff ff       	call   800326 <_panic>
  802259:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80225f:	8b 45 08             	mov    0x8(%ebp),%eax
  802262:	89 10                	mov    %edx,(%eax)
  802264:	8b 45 08             	mov    0x8(%ebp),%eax
  802267:	8b 00                	mov    (%eax),%eax
  802269:	85 c0                	test   %eax,%eax
  80226b:	74 0d                	je     80227a <insert_sorted_allocList+0xc3>
  80226d:	a1 40 40 80 00       	mov    0x804040,%eax
  802272:	8b 55 08             	mov    0x8(%ebp),%edx
  802275:	89 50 04             	mov    %edx,0x4(%eax)
  802278:	eb 08                	jmp    802282 <insert_sorted_allocList+0xcb>
  80227a:	8b 45 08             	mov    0x8(%ebp),%eax
  80227d:	a3 44 40 80 00       	mov    %eax,0x804044
  802282:	8b 45 08             	mov    0x8(%ebp),%eax
  802285:	a3 40 40 80 00       	mov    %eax,0x804040
  80228a:	8b 45 08             	mov    0x8(%ebp),%eax
  80228d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802294:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802299:	40                   	inc    %eax
  80229a:	a3 4c 40 80 00       	mov    %eax,0x80404c
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  80229f:	a1 40 40 80 00       	mov    0x804040,%eax
  8022a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022a7:	e9 b9 01 00 00       	jmp    802465 <insert_sorted_allocList+0x2ae>
	{


		if ((blockToInsert->sva>AllocMemBlocksList.lh_first->sva)&&blockToInsert->sva<element->sva)
  8022ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8022af:	8b 50 08             	mov    0x8(%eax),%edx
  8022b2:	a1 40 40 80 00       	mov    0x804040,%eax
  8022b7:	8b 40 08             	mov    0x8(%eax),%eax
  8022ba:	39 c2                	cmp    %eax,%edx
  8022bc:	76 7c                	jbe    80233a <insert_sorted_allocList+0x183>
  8022be:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c1:	8b 50 08             	mov    0x8(%eax),%edx
  8022c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c7:	8b 40 08             	mov    0x8(%eax),%eax
  8022ca:	39 c2                	cmp    %eax,%edx
  8022cc:	73 6c                	jae    80233a <insert_sorted_allocList+0x183>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,element,blockToInsert);
  8022ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022d2:	74 06                	je     8022da <insert_sorted_allocList+0x123>
  8022d4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022d8:	75 14                	jne    8022ee <insert_sorted_allocList+0x137>
  8022da:	83 ec 04             	sub    $0x4,%esp
  8022dd:	68 0c 3b 80 00       	push   $0x803b0c
  8022e2:	6a 75                	push   $0x75
  8022e4:	68 f3 3a 80 00       	push   $0x803af3
  8022e9:	e8 38 e0 ff ff       	call   800326 <_panic>
  8022ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f1:	8b 50 04             	mov    0x4(%eax),%edx
  8022f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f7:	89 50 04             	mov    %edx,0x4(%eax)
  8022fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802300:	89 10                	mov    %edx,(%eax)
  802302:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802305:	8b 40 04             	mov    0x4(%eax),%eax
  802308:	85 c0                	test   %eax,%eax
  80230a:	74 0d                	je     802319 <insert_sorted_allocList+0x162>
  80230c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230f:	8b 40 04             	mov    0x4(%eax),%eax
  802312:	8b 55 08             	mov    0x8(%ebp),%edx
  802315:	89 10                	mov    %edx,(%eax)
  802317:	eb 08                	jmp    802321 <insert_sorted_allocList+0x16a>
  802319:	8b 45 08             	mov    0x8(%ebp),%eax
  80231c:	a3 40 40 80 00       	mov    %eax,0x804040
  802321:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802324:	8b 55 08             	mov    0x8(%ebp),%edx
  802327:	89 50 04             	mov    %edx,0x4(%eax)
  80232a:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80232f:	40                   	inc    %eax
  802330:	a3 4c 40 80 00       	mov    %eax,0x80404c

		break;}
  802335:	e9 59 01 00 00       	jmp    802493 <insert_sorted_allocList+0x2dc>

	else if ((blockToInsert->sva>element->sva)&&(blockToInsert->sva<AllocMemBlocksList.lh_last->sva)&&blockToInsert->sva<LIST_NEXT(element)->sva)
  80233a:	8b 45 08             	mov    0x8(%ebp),%eax
  80233d:	8b 50 08             	mov    0x8(%eax),%edx
  802340:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802343:	8b 40 08             	mov    0x8(%eax),%eax
  802346:	39 c2                	cmp    %eax,%edx
  802348:	0f 86 98 00 00 00    	jbe    8023e6 <insert_sorted_allocList+0x22f>
  80234e:	8b 45 08             	mov    0x8(%ebp),%eax
  802351:	8b 50 08             	mov    0x8(%eax),%edx
  802354:	a1 44 40 80 00       	mov    0x804044,%eax
  802359:	8b 40 08             	mov    0x8(%eax),%eax
  80235c:	39 c2                	cmp    %eax,%edx
  80235e:	0f 83 82 00 00 00    	jae    8023e6 <insert_sorted_allocList+0x22f>
  802364:	8b 45 08             	mov    0x8(%ebp),%eax
  802367:	8b 50 08             	mov    0x8(%eax),%edx
  80236a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236d:	8b 00                	mov    (%eax),%eax
  80236f:	8b 40 08             	mov    0x8(%eax),%eax
  802372:	39 c2                	cmp    %eax,%edx
  802374:	73 70                	jae    8023e6 <insert_sorted_allocList+0x22f>
	{

	LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  802376:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80237a:	74 06                	je     802382 <insert_sorted_allocList+0x1cb>
  80237c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802380:	75 14                	jne    802396 <insert_sorted_allocList+0x1df>
  802382:	83 ec 04             	sub    $0x4,%esp
  802385:	68 44 3b 80 00       	push   $0x803b44
  80238a:	6a 7c                	push   $0x7c
  80238c:	68 f3 3a 80 00       	push   $0x803af3
  802391:	e8 90 df ff ff       	call   800326 <_panic>
  802396:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802399:	8b 10                	mov    (%eax),%edx
  80239b:	8b 45 08             	mov    0x8(%ebp),%eax
  80239e:	89 10                	mov    %edx,(%eax)
  8023a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a3:	8b 00                	mov    (%eax),%eax
  8023a5:	85 c0                	test   %eax,%eax
  8023a7:	74 0b                	je     8023b4 <insert_sorted_allocList+0x1fd>
  8023a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ac:	8b 00                	mov    (%eax),%eax
  8023ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8023b1:	89 50 04             	mov    %edx,0x4(%eax)
  8023b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8023ba:	89 10                	mov    %edx,(%eax)
  8023bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023c2:	89 50 04             	mov    %edx,0x4(%eax)
  8023c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c8:	8b 00                	mov    (%eax),%eax
  8023ca:	85 c0                	test   %eax,%eax
  8023cc:	75 08                	jne    8023d6 <insert_sorted_allocList+0x21f>
  8023ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d1:	a3 44 40 80 00       	mov    %eax,0x804044
  8023d6:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8023db:	40                   	inc    %eax
  8023dc:	a3 4c 40 80 00       	mov    %eax,0x80404c
		break;
  8023e1:	e9 ad 00 00 00       	jmp    802493 <insert_sorted_allocList+0x2dc>
	}else if (blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  8023e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e9:	8b 50 08             	mov    0x8(%eax),%edx
  8023ec:	a1 44 40 80 00       	mov    0x804044,%eax
  8023f1:	8b 40 08             	mov    0x8(%eax),%eax
  8023f4:	39 c2                	cmp    %eax,%edx
  8023f6:	76 65                	jbe    80245d <insert_sorted_allocList+0x2a6>
	{
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
  8023f8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023fc:	75 17                	jne    802415 <insert_sorted_allocList+0x25e>
  8023fe:	83 ec 04             	sub    $0x4,%esp
  802401:	68 78 3b 80 00       	push   $0x803b78
  802406:	68 80 00 00 00       	push   $0x80
  80240b:	68 f3 3a 80 00       	push   $0x803af3
  802410:	e8 11 df ff ff       	call   800326 <_panic>
  802415:	8b 15 44 40 80 00    	mov    0x804044,%edx
  80241b:	8b 45 08             	mov    0x8(%ebp),%eax
  80241e:	89 50 04             	mov    %edx,0x4(%eax)
  802421:	8b 45 08             	mov    0x8(%ebp),%eax
  802424:	8b 40 04             	mov    0x4(%eax),%eax
  802427:	85 c0                	test   %eax,%eax
  802429:	74 0c                	je     802437 <insert_sorted_allocList+0x280>
  80242b:	a1 44 40 80 00       	mov    0x804044,%eax
  802430:	8b 55 08             	mov    0x8(%ebp),%edx
  802433:	89 10                	mov    %edx,(%eax)
  802435:	eb 08                	jmp    80243f <insert_sorted_allocList+0x288>
  802437:	8b 45 08             	mov    0x8(%ebp),%eax
  80243a:	a3 40 40 80 00       	mov    %eax,0x804040
  80243f:	8b 45 08             	mov    0x8(%ebp),%eax
  802442:	a3 44 40 80 00       	mov    %eax,0x804044
  802447:	8b 45 08             	mov    0x8(%ebp),%eax
  80244a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802450:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802455:	40                   	inc    %eax
  802456:	a3 4c 40 80 00       	mov    %eax,0x80404c
		break;
  80245b:	eb 36                	jmp    802493 <insert_sorted_allocList+0x2dc>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  80245d:	a1 48 40 80 00       	mov    0x804048,%eax
  802462:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802465:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802469:	74 07                	je     802472 <insert_sorted_allocList+0x2bb>
  80246b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246e:	8b 00                	mov    (%eax),%eax
  802470:	eb 05                	jmp    802477 <insert_sorted_allocList+0x2c0>
  802472:	b8 00 00 00 00       	mov    $0x0,%eax
  802477:	a3 48 40 80 00       	mov    %eax,0x804048
  80247c:	a1 48 40 80 00       	mov    0x804048,%eax
  802481:	85 c0                	test   %eax,%eax
  802483:	0f 85 23 fe ff ff    	jne    8022ac <insert_sorted_allocList+0xf5>
  802489:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80248d:	0f 85 19 fe ff ff    	jne    8022ac <insert_sorted_allocList+0xf5>
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
		break;

	}
	}
}
  802493:	90                   	nop
  802494:	c9                   	leave  
  802495:	c3                   	ret    

00802496 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802496:	55                   	push   %ebp
  802497:	89 e5                	mov    %esp,%ebp
  802499:	83 ec 18             	sub    $0x18,%esp
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  80249c:	a1 38 41 80 00       	mov    0x804138,%eax
  8024a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024a4:	e9 7c 01 00 00       	jmp    802625 <alloc_block_FF+0x18f>
		{
			// case 2
				if(element->size == size)
  8024a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ac:	8b 40 0c             	mov    0xc(%eax),%eax
  8024af:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024b2:	0f 85 90 00 00 00    	jne    802548 <alloc_block_FF+0xb2>
				{
					tmp_block=element;
  8024b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,element);
  8024be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024c2:	75 17                	jne    8024db <alloc_block_FF+0x45>
  8024c4:	83 ec 04             	sub    $0x4,%esp
  8024c7:	68 9b 3b 80 00       	push   $0x803b9b
  8024cc:	68 ba 00 00 00       	push   $0xba
  8024d1:	68 f3 3a 80 00       	push   $0x803af3
  8024d6:	e8 4b de ff ff       	call   800326 <_panic>
  8024db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024de:	8b 00                	mov    (%eax),%eax
  8024e0:	85 c0                	test   %eax,%eax
  8024e2:	74 10                	je     8024f4 <alloc_block_FF+0x5e>
  8024e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e7:	8b 00                	mov    (%eax),%eax
  8024e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024ec:	8b 52 04             	mov    0x4(%edx),%edx
  8024ef:	89 50 04             	mov    %edx,0x4(%eax)
  8024f2:	eb 0b                	jmp    8024ff <alloc_block_FF+0x69>
  8024f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f7:	8b 40 04             	mov    0x4(%eax),%eax
  8024fa:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8024ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802502:	8b 40 04             	mov    0x4(%eax),%eax
  802505:	85 c0                	test   %eax,%eax
  802507:	74 0f                	je     802518 <alloc_block_FF+0x82>
  802509:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250c:	8b 40 04             	mov    0x4(%eax),%eax
  80250f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802512:	8b 12                	mov    (%edx),%edx
  802514:	89 10                	mov    %edx,(%eax)
  802516:	eb 0a                	jmp    802522 <alloc_block_FF+0x8c>
  802518:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251b:	8b 00                	mov    (%eax),%eax
  80251d:	a3 38 41 80 00       	mov    %eax,0x804138
  802522:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802525:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80252b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802535:	a1 44 41 80 00       	mov    0x804144,%eax
  80253a:	48                   	dec    %eax
  80253b:	a3 44 41 80 00       	mov    %eax,0x804144
					return tmp_block;
  802540:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802543:	e9 10 01 00 00       	jmp    802658 <alloc_block_FF+0x1c2>
				}
				 // case 3
				else if(element->size > size)
  802548:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254b:	8b 40 0c             	mov    0xc(%eax),%eax
  80254e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802551:	0f 86 c6 00 00 00    	jbe    80261d <alloc_block_FF+0x187>
				{
					// the new block are created
					tmp_block = AvailableMemBlocksList.lh_first ;
  802557:	a1 48 41 80 00       	mov    0x804148,%eax
  80255c:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  80255f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802563:	75 17                	jne    80257c <alloc_block_FF+0xe6>
  802565:	83 ec 04             	sub    $0x4,%esp
  802568:	68 9b 3b 80 00       	push   $0x803b9b
  80256d:	68 c2 00 00 00       	push   $0xc2
  802572:	68 f3 3a 80 00       	push   $0x803af3
  802577:	e8 aa dd ff ff       	call   800326 <_panic>
  80257c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80257f:	8b 00                	mov    (%eax),%eax
  802581:	85 c0                	test   %eax,%eax
  802583:	74 10                	je     802595 <alloc_block_FF+0xff>
  802585:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802588:	8b 00                	mov    (%eax),%eax
  80258a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80258d:	8b 52 04             	mov    0x4(%edx),%edx
  802590:	89 50 04             	mov    %edx,0x4(%eax)
  802593:	eb 0b                	jmp    8025a0 <alloc_block_FF+0x10a>
  802595:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802598:	8b 40 04             	mov    0x4(%eax),%eax
  80259b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8025a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025a3:	8b 40 04             	mov    0x4(%eax),%eax
  8025a6:	85 c0                	test   %eax,%eax
  8025a8:	74 0f                	je     8025b9 <alloc_block_FF+0x123>
  8025aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ad:	8b 40 04             	mov    0x4(%eax),%eax
  8025b0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025b3:	8b 12                	mov    (%edx),%edx
  8025b5:	89 10                	mov    %edx,(%eax)
  8025b7:	eb 0a                	jmp    8025c3 <alloc_block_FF+0x12d>
  8025b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025bc:	8b 00                	mov    (%eax),%eax
  8025be:	a3 48 41 80 00       	mov    %eax,0x804148
  8025c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025cf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025d6:	a1 54 41 80 00       	mov    0x804154,%eax
  8025db:	48                   	dec    %eax
  8025dc:	a3 54 41 80 00       	mov    %eax,0x804154
					tmp_block->sva=element->sva;
  8025e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e4:	8b 50 08             	mov    0x8(%eax),%edx
  8025e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ea:	89 50 08             	mov    %edx,0x8(%eax)
					tmp_block->size=size;
  8025ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8025f3:	89 50 0c             	mov    %edx,0xc(%eax)
					//update block with remaining space
					element->size-=size;
  8025f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f9:	8b 40 0c             	mov    0xc(%eax),%eax
  8025fc:	2b 45 08             	sub    0x8(%ebp),%eax
  8025ff:	89 c2                	mov    %eax,%edx
  802601:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802604:	89 50 0c             	mov    %edx,0xc(%eax)
					element->sva = element->sva + size;
  802607:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260a:	8b 50 08             	mov    0x8(%eax),%edx
  80260d:	8b 45 08             	mov    0x8(%ebp),%eax
  802610:	01 c2                	add    %eax,%edx
  802612:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802615:	89 50 08             	mov    %edx,0x8(%eax)
					// return back the new block
					return tmp_block ;
  802618:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80261b:	eb 3b                	jmp    802658 <alloc_block_FF+0x1c2>
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  80261d:	a1 40 41 80 00       	mov    0x804140,%eax
  802622:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802625:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802629:	74 07                	je     802632 <alloc_block_FF+0x19c>
  80262b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262e:	8b 00                	mov    (%eax),%eax
  802630:	eb 05                	jmp    802637 <alloc_block_FF+0x1a1>
  802632:	b8 00 00 00 00       	mov    $0x0,%eax
  802637:	a3 40 41 80 00       	mov    %eax,0x804140
  80263c:	a1 40 41 80 00       	mov    0x804140,%eax
  802641:	85 c0                	test   %eax,%eax
  802643:	0f 85 60 fe ff ff    	jne    8024a9 <alloc_block_FF+0x13>
  802649:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80264d:	0f 85 56 fe ff ff    	jne    8024a9 <alloc_block_FF+0x13>
					// return back the new block
					return tmp_block ;
				}
		}
		// case 1
	  return NULL ;}
  802653:	b8 00 00 00 00       	mov    $0x0,%eax
  802658:	c9                   	leave  
  802659:	c3                   	ret    

0080265a <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================

struct MemBlock *alloc_block_BF(uint32 size)
{
  80265a:	55                   	push   %ebp
  80265b:	89 e5                	mov    %esp,%ebp
  80265d:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
  802660:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802667:	a1 38 41 80 00       	mov    0x804138,%eax
  80266c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80266f:	eb 3a                	jmp    8026ab <alloc_block_BF+0x51>
		{
			if(element->size >= size)
  802671:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802674:	8b 40 0c             	mov    0xc(%eax),%eax
  802677:	3b 45 08             	cmp    0x8(%ebp),%eax
  80267a:	72 27                	jb     8026a3 <alloc_block_BF+0x49>
			{
				if(best_size==-1)
  80267c:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802680:	75 0b                	jne    80268d <alloc_block_BF+0x33>
					best_size= element->size;
  802682:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802685:	8b 40 0c             	mov    0xc(%eax),%eax
  802688:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80268b:	eb 16                	jmp    8026a3 <alloc_block_BF+0x49>
				else if(best_size >= element->size)
  80268d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802690:	8b 50 0c             	mov    0xc(%eax),%edx
  802693:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802696:	39 c2                	cmp    %eax,%edx
  802698:	77 09                	ja     8026a3 <alloc_block_BF+0x49>
					best_size=element->size;
  80269a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269d:	8b 40 0c             	mov    0xc(%eax),%eax
  8026a0:	89 45 f0             	mov    %eax,-0x10(%ebp)

struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  8026a3:	a1 40 41 80 00       	mov    0x804140,%eax
  8026a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026af:	74 07                	je     8026b8 <alloc_block_BF+0x5e>
  8026b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b4:	8b 00                	mov    (%eax),%eax
  8026b6:	eb 05                	jmp    8026bd <alloc_block_BF+0x63>
  8026b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8026bd:	a3 40 41 80 00       	mov    %eax,0x804140
  8026c2:	a1 40 41 80 00       	mov    0x804140,%eax
  8026c7:	85 c0                	test   %eax,%eax
  8026c9:	75 a6                	jne    802671 <alloc_block_BF+0x17>
  8026cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026cf:	75 a0                	jne    802671 <alloc_block_BF+0x17>
					best_size= element->size;
				else if(best_size >= element->size)
					best_size=element->size;
			}
		}
		if(best_size != -1)
  8026d1:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8026d5:	0f 84 d3 01 00 00    	je     8028ae <alloc_block_BF+0x254>
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  8026db:	a1 38 41 80 00       	mov    0x804138,%eax
  8026e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026e3:	e9 98 01 00 00       	jmp    802880 <alloc_block_BF+0x226>
			{
			 if((best_size > size) && (best_size == element->size))
  8026e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026eb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026ee:	0f 86 da 00 00 00    	jbe    8027ce <alloc_block_BF+0x174>
  8026f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f7:	8b 50 0c             	mov    0xc(%eax),%edx
  8026fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026fd:	39 c2                	cmp    %eax,%edx
  8026ff:	0f 85 c9 00 00 00    	jne    8027ce <alloc_block_BF+0x174>
			  {
				// the new block are created
			    tmp_block = AvailableMemBlocksList.lh_first ;
  802705:	a1 48 41 80 00       	mov    0x804148,%eax
  80270a:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  80270d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802711:	75 17                	jne    80272a <alloc_block_BF+0xd0>
  802713:	83 ec 04             	sub    $0x4,%esp
  802716:	68 9b 3b 80 00       	push   $0x803b9b
  80271b:	68 ea 00 00 00       	push   $0xea
  802720:	68 f3 3a 80 00       	push   $0x803af3
  802725:	e8 fc db ff ff       	call   800326 <_panic>
  80272a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80272d:	8b 00                	mov    (%eax),%eax
  80272f:	85 c0                	test   %eax,%eax
  802731:	74 10                	je     802743 <alloc_block_BF+0xe9>
  802733:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802736:	8b 00                	mov    (%eax),%eax
  802738:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80273b:	8b 52 04             	mov    0x4(%edx),%edx
  80273e:	89 50 04             	mov    %edx,0x4(%eax)
  802741:	eb 0b                	jmp    80274e <alloc_block_BF+0xf4>
  802743:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802746:	8b 40 04             	mov    0x4(%eax),%eax
  802749:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80274e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802751:	8b 40 04             	mov    0x4(%eax),%eax
  802754:	85 c0                	test   %eax,%eax
  802756:	74 0f                	je     802767 <alloc_block_BF+0x10d>
  802758:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80275b:	8b 40 04             	mov    0x4(%eax),%eax
  80275e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802761:	8b 12                	mov    (%edx),%edx
  802763:	89 10                	mov    %edx,(%eax)
  802765:	eb 0a                	jmp    802771 <alloc_block_BF+0x117>
  802767:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80276a:	8b 00                	mov    (%eax),%eax
  80276c:	a3 48 41 80 00       	mov    %eax,0x804148
  802771:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802774:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80277a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80277d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802784:	a1 54 41 80 00       	mov    0x804154,%eax
  802789:	48                   	dec    %eax
  80278a:	a3 54 41 80 00       	mov    %eax,0x804154
				tmp_block->sva=element->sva;
  80278f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802792:	8b 50 08             	mov    0x8(%eax),%edx
  802795:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802798:	89 50 08             	mov    %edx,0x8(%eax)
				tmp_block->size=size;
  80279b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80279e:	8b 55 08             	mov    0x8(%ebp),%edx
  8027a1:	89 50 0c             	mov    %edx,0xc(%eax)
				//update block with remaining space
				element->size-=size;
  8027a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8027aa:	2b 45 08             	sub    0x8(%ebp),%eax
  8027ad:	89 c2                	mov    %eax,%edx
  8027af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b2:	89 50 0c             	mov    %edx,0xc(%eax)
				element->sva = element->sva + size;
  8027b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b8:	8b 50 08             	mov    0x8(%eax),%edx
  8027bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8027be:	01 c2                	add    %eax,%edx
  8027c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c3:	89 50 08             	mov    %edx,0x8(%eax)
				// return back the new block
				return tmp_block ;
  8027c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027c9:	e9 e5 00 00 00       	jmp    8028b3 <alloc_block_BF+0x259>

			  }
			else if((element->size == best_size)&&(best_size == size))
  8027ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d1:	8b 50 0c             	mov    0xc(%eax),%edx
  8027d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d7:	39 c2                	cmp    %eax,%edx
  8027d9:	0f 85 99 00 00 00    	jne    802878 <alloc_block_BF+0x21e>
  8027df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027e5:	0f 85 8d 00 00 00    	jne    802878 <alloc_block_BF+0x21e>
			  {
				tmp_block=element;
  8027eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&FreeMemBlocksList,element);
  8027f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027f5:	75 17                	jne    80280e <alloc_block_BF+0x1b4>
  8027f7:	83 ec 04             	sub    $0x4,%esp
  8027fa:	68 9b 3b 80 00       	push   $0x803b9b
  8027ff:	68 f7 00 00 00       	push   $0xf7
  802804:	68 f3 3a 80 00       	push   $0x803af3
  802809:	e8 18 db ff ff       	call   800326 <_panic>
  80280e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802811:	8b 00                	mov    (%eax),%eax
  802813:	85 c0                	test   %eax,%eax
  802815:	74 10                	je     802827 <alloc_block_BF+0x1cd>
  802817:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281a:	8b 00                	mov    (%eax),%eax
  80281c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80281f:	8b 52 04             	mov    0x4(%edx),%edx
  802822:	89 50 04             	mov    %edx,0x4(%eax)
  802825:	eb 0b                	jmp    802832 <alloc_block_BF+0x1d8>
  802827:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282a:	8b 40 04             	mov    0x4(%eax),%eax
  80282d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802832:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802835:	8b 40 04             	mov    0x4(%eax),%eax
  802838:	85 c0                	test   %eax,%eax
  80283a:	74 0f                	je     80284b <alloc_block_BF+0x1f1>
  80283c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283f:	8b 40 04             	mov    0x4(%eax),%eax
  802842:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802845:	8b 12                	mov    (%edx),%edx
  802847:	89 10                	mov    %edx,(%eax)
  802849:	eb 0a                	jmp    802855 <alloc_block_BF+0x1fb>
  80284b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284e:	8b 00                	mov    (%eax),%eax
  802850:	a3 38 41 80 00       	mov    %eax,0x804138
  802855:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802858:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80285e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802861:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802868:	a1 44 41 80 00       	mov    0x804144,%eax
  80286d:	48                   	dec    %eax
  80286e:	a3 44 41 80 00       	mov    %eax,0x804144
				return tmp_block;
  802873:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802876:	eb 3b                	jmp    8028b3 <alloc_block_BF+0x259>
					best_size=element->size;
			}
		}
		if(best_size != -1)
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  802878:	a1 40 41 80 00       	mov    0x804140,%eax
  80287d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802880:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802884:	74 07                	je     80288d <alloc_block_BF+0x233>
  802886:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802889:	8b 00                	mov    (%eax),%eax
  80288b:	eb 05                	jmp    802892 <alloc_block_BF+0x238>
  80288d:	b8 00 00 00 00       	mov    $0x0,%eax
  802892:	a3 40 41 80 00       	mov    %eax,0x804140
  802897:	a1 40 41 80 00       	mov    0x804140,%eax
  80289c:	85 c0                	test   %eax,%eax
  80289e:	0f 85 44 fe ff ff    	jne    8026e8 <alloc_block_BF+0x8e>
  8028a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028a8:	0f 85 3a fe ff ff    	jne    8026e8 <alloc_block_BF+0x8e>
				LIST_REMOVE(&FreeMemBlocksList,element);
				return tmp_block;
			 }
			}
		}
		return NULL ;}
  8028ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8028b3:	c9                   	leave  
  8028b4:	c3                   	ret    

008028b5 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8028b5:	55                   	push   %ebp
  8028b6:	89 e5                	mov    %esp,%ebp
  8028b8:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  8028bb:	83 ec 04             	sub    $0x4,%esp
  8028be:	68 bc 3b 80 00       	push   $0x803bbc
  8028c3:	68 04 01 00 00       	push   $0x104
  8028c8:	68 f3 3a 80 00       	push   $0x803af3
  8028cd:	e8 54 da ff ff       	call   800326 <_panic>

008028d2 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{struct MemBlock * blk_itr;
  8028d2:	55                   	push   %ebp
  8028d3:	89 e5                	mov    %esp,%ebp
  8028d5:	83 ec 18             	sub    $0x18,%esp
struct MemBlock * next;
struct MemBlock * first = LIST_FIRST(&(FreeMemBlocksList));
  8028d8:	a1 38 41 80 00       	mov    0x804138,%eax
  8028dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
struct MemBlock * last = LIST_LAST(&(FreeMemBlocksList));
  8028e0:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8028e5:	89 45 ec             	mov    %eax,-0x14(%ebp)

if(LIST_EMPTY(&(FreeMemBlocksList)))
  8028e8:	a1 38 41 80 00       	mov    0x804138,%eax
  8028ed:	85 c0                	test   %eax,%eax
  8028ef:	75 68                	jne    802959 <insert_sorted_with_merge_freeList+0x87>
			{

				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  8028f1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028f5:	75 17                	jne    80290e <insert_sorted_with_merge_freeList+0x3c>
  8028f7:	83 ec 04             	sub    $0x4,%esp
  8028fa:	68 d0 3a 80 00       	push   $0x803ad0
  8028ff:	68 14 01 00 00       	push   $0x114
  802904:	68 f3 3a 80 00       	push   $0x803af3
  802909:	e8 18 da ff ff       	call   800326 <_panic>
  80290e:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802914:	8b 45 08             	mov    0x8(%ebp),%eax
  802917:	89 10                	mov    %edx,(%eax)
  802919:	8b 45 08             	mov    0x8(%ebp),%eax
  80291c:	8b 00                	mov    (%eax),%eax
  80291e:	85 c0                	test   %eax,%eax
  802920:	74 0d                	je     80292f <insert_sorted_with_merge_freeList+0x5d>
  802922:	a1 38 41 80 00       	mov    0x804138,%eax
  802927:	8b 55 08             	mov    0x8(%ebp),%edx
  80292a:	89 50 04             	mov    %edx,0x4(%eax)
  80292d:	eb 08                	jmp    802937 <insert_sorted_with_merge_freeList+0x65>
  80292f:	8b 45 08             	mov    0x8(%ebp),%eax
  802932:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802937:	8b 45 08             	mov    0x8(%ebp),%eax
  80293a:	a3 38 41 80 00       	mov    %eax,0x804138
  80293f:	8b 45 08             	mov    0x8(%ebp),%eax
  802942:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802949:	a1 44 41 80 00       	mov    0x804144,%eax
  80294e:	40                   	inc    %eax
  80294f:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  802954:	e9 d2 06 00 00       	jmp    80302b <insert_sorted_with_merge_freeList+0x759>
				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);

			}
else
{
	if( blockToInsert->sva  < first->sva )
  802959:	8b 45 08             	mov    0x8(%ebp),%eax
  80295c:	8b 50 08             	mov    0x8(%eax),%edx
  80295f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802962:	8b 40 08             	mov    0x8(%eax),%eax
  802965:	39 c2                	cmp    %eax,%edx
  802967:	0f 83 22 01 00 00    	jae    802a8f <insert_sorted_with_merge_freeList+0x1bd>
	{
                if( blockToInsert->sva + blockToInsert->size == first->sva)
  80296d:	8b 45 08             	mov    0x8(%ebp),%eax
  802970:	8b 50 08             	mov    0x8(%eax),%edx
  802973:	8b 45 08             	mov    0x8(%ebp),%eax
  802976:	8b 40 0c             	mov    0xc(%eax),%eax
  802979:	01 c2                	add    %eax,%edx
  80297b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80297e:	8b 40 08             	mov    0x8(%eax),%eax
  802981:	39 c2                	cmp    %eax,%edx
  802983:	0f 85 9e 00 00 00    	jne    802a27 <insert_sorted_with_merge_freeList+0x155>
                {

                	first->sva = blockToInsert->sva;
  802989:	8b 45 08             	mov    0x8(%ebp),%eax
  80298c:	8b 50 08             	mov    0x8(%eax),%edx
  80298f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802992:	89 50 08             	mov    %edx,0x8(%eax)
                	first->size = first->size + blockToInsert->size;
  802995:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802998:	8b 50 0c             	mov    0xc(%eax),%edx
  80299b:	8b 45 08             	mov    0x8(%ebp),%eax
  80299e:	8b 40 0c             	mov    0xc(%eax),%eax
  8029a1:	01 c2                	add    %eax,%edx
  8029a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a6:	89 50 0c             	mov    %edx,0xc(%eax)
                	blockToInsert->size = blockToInsert->sva = 0;
  8029a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ac:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8029b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b6:	8b 50 08             	mov    0x8(%eax),%edx
  8029b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029bc:	89 50 0c             	mov    %edx,0xc(%eax)
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  8029bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029c3:	75 17                	jne    8029dc <insert_sorted_with_merge_freeList+0x10a>
  8029c5:	83 ec 04             	sub    $0x4,%esp
  8029c8:	68 d0 3a 80 00       	push   $0x803ad0
  8029cd:	68 21 01 00 00       	push   $0x121
  8029d2:	68 f3 3a 80 00       	push   $0x803af3
  8029d7:	e8 4a d9 ff ff       	call   800326 <_panic>
  8029dc:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8029e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e5:	89 10                	mov    %edx,(%eax)
  8029e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ea:	8b 00                	mov    (%eax),%eax
  8029ec:	85 c0                	test   %eax,%eax
  8029ee:	74 0d                	je     8029fd <insert_sorted_with_merge_freeList+0x12b>
  8029f0:	a1 48 41 80 00       	mov    0x804148,%eax
  8029f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8029f8:	89 50 04             	mov    %edx,0x4(%eax)
  8029fb:	eb 08                	jmp    802a05 <insert_sorted_with_merge_freeList+0x133>
  8029fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802a00:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a05:	8b 45 08             	mov    0x8(%ebp),%eax
  802a08:	a3 48 41 80 00       	mov    %eax,0x804148
  802a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a10:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a17:	a1 54 41 80 00       	mov    0x804154,%eax
  802a1c:	40                   	inc    %eax
  802a1d:	a3 54 41 80 00       	mov    %eax,0x804154
						}
				}
        }

}
}
  802a22:	e9 04 06 00 00       	jmp    80302b <insert_sorted_with_merge_freeList+0x759>
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
                }

                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  802a27:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a2b:	75 17                	jne    802a44 <insert_sorted_with_merge_freeList+0x172>
  802a2d:	83 ec 04             	sub    $0x4,%esp
  802a30:	68 d0 3a 80 00       	push   $0x803ad0
  802a35:	68 26 01 00 00       	push   $0x126
  802a3a:	68 f3 3a 80 00       	push   $0x803af3
  802a3f:	e8 e2 d8 ff ff       	call   800326 <_panic>
  802a44:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4d:	89 10                	mov    %edx,(%eax)
  802a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a52:	8b 00                	mov    (%eax),%eax
  802a54:	85 c0                	test   %eax,%eax
  802a56:	74 0d                	je     802a65 <insert_sorted_with_merge_freeList+0x193>
  802a58:	a1 38 41 80 00       	mov    0x804138,%eax
  802a5d:	8b 55 08             	mov    0x8(%ebp),%edx
  802a60:	89 50 04             	mov    %edx,0x4(%eax)
  802a63:	eb 08                	jmp    802a6d <insert_sorted_with_merge_freeList+0x19b>
  802a65:	8b 45 08             	mov    0x8(%ebp),%eax
  802a68:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a70:	a3 38 41 80 00       	mov    %eax,0x804138
  802a75:	8b 45 08             	mov    0x8(%ebp),%eax
  802a78:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a7f:	a1 44 41 80 00       	mov    0x804144,%eax
  802a84:	40                   	inc    %eax
  802a85:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  802a8a:	e9 9c 05 00 00       	jmp    80302b <insert_sorted_with_merge_freeList+0x759>
                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
                }
	}
    else if(blockToInsert->sva > last->sva)
  802a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a92:	8b 50 08             	mov    0x8(%eax),%edx
  802a95:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a98:	8b 40 08             	mov    0x8(%eax),%eax
  802a9b:	39 c2                	cmp    %eax,%edx
  802a9d:	0f 86 16 01 00 00    	jbe    802bb9 <insert_sorted_with_merge_freeList+0x2e7>
 	{

				if(last->sva + last->size == blockToInsert->sva)
  802aa3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aa6:	8b 50 08             	mov    0x8(%eax),%edx
  802aa9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aac:	8b 40 0c             	mov    0xc(%eax),%eax
  802aaf:	01 c2                	add    %eax,%edx
  802ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab4:	8b 40 08             	mov    0x8(%eax),%eax
  802ab7:	39 c2                	cmp    %eax,%edx
  802ab9:	0f 85 92 00 00 00    	jne    802b51 <insert_sorted_with_merge_freeList+0x27f>
				{

					last->size = last->size + blockToInsert->size;
  802abf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ac2:	8b 50 0c             	mov    0xc(%eax),%edx
  802ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac8:	8b 40 0c             	mov    0xc(%eax),%eax
  802acb:	01 c2                	add    %eax,%edx
  802acd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ad0:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->size = blockToInsert->sva = 0;
  802ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802add:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae0:	8b 50 08             	mov    0x8(%eax),%edx
  802ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae6:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802ae9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802aed:	75 17                	jne    802b06 <insert_sorted_with_merge_freeList+0x234>
  802aef:	83 ec 04             	sub    $0x4,%esp
  802af2:	68 d0 3a 80 00       	push   $0x803ad0
  802af7:	68 31 01 00 00       	push   $0x131
  802afc:	68 f3 3a 80 00       	push   $0x803af3
  802b01:	e8 20 d8 ff ff       	call   800326 <_panic>
  802b06:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0f:	89 10                	mov    %edx,(%eax)
  802b11:	8b 45 08             	mov    0x8(%ebp),%eax
  802b14:	8b 00                	mov    (%eax),%eax
  802b16:	85 c0                	test   %eax,%eax
  802b18:	74 0d                	je     802b27 <insert_sorted_with_merge_freeList+0x255>
  802b1a:	a1 48 41 80 00       	mov    0x804148,%eax
  802b1f:	8b 55 08             	mov    0x8(%ebp),%edx
  802b22:	89 50 04             	mov    %edx,0x4(%eax)
  802b25:	eb 08                	jmp    802b2f <insert_sorted_with_merge_freeList+0x25d>
  802b27:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b32:	a3 48 41 80 00       	mov    %eax,0x804148
  802b37:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b41:	a1 54 41 80 00       	mov    0x804154,%eax
  802b46:	40                   	inc    %eax
  802b47:	a3 54 41 80 00       	mov    %eax,0x804154
						}
				}
        }

}
}
  802b4c:	e9 da 04 00 00       	jmp    80302b <insert_sorted_with_merge_freeList+0x759>

				}

				else
				{
					LIST_INSERT_TAIL(&(FreeMemBlocksList),  blockToInsert);
  802b51:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b55:	75 17                	jne    802b6e <insert_sorted_with_merge_freeList+0x29c>
  802b57:	83 ec 04             	sub    $0x4,%esp
  802b5a:	68 78 3b 80 00       	push   $0x803b78
  802b5f:	68 37 01 00 00       	push   $0x137
  802b64:	68 f3 3a 80 00       	push   $0x803af3
  802b69:	e8 b8 d7 ff ff       	call   800326 <_panic>
  802b6e:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802b74:	8b 45 08             	mov    0x8(%ebp),%eax
  802b77:	89 50 04             	mov    %edx,0x4(%eax)
  802b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7d:	8b 40 04             	mov    0x4(%eax),%eax
  802b80:	85 c0                	test   %eax,%eax
  802b82:	74 0c                	je     802b90 <insert_sorted_with_merge_freeList+0x2be>
  802b84:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b89:	8b 55 08             	mov    0x8(%ebp),%edx
  802b8c:	89 10                	mov    %edx,(%eax)
  802b8e:	eb 08                	jmp    802b98 <insert_sorted_with_merge_freeList+0x2c6>
  802b90:	8b 45 08             	mov    0x8(%ebp),%eax
  802b93:	a3 38 41 80 00       	mov    %eax,0x804138
  802b98:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ba9:	a1 44 41 80 00       	mov    0x804144,%eax
  802bae:	40                   	inc    %eax
  802baf:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  802bb4:	e9 72 04 00 00       	jmp    80302b <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  802bb9:	a1 38 41 80 00       	mov    0x804138,%eax
  802bbe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bc1:	e9 35 04 00 00       	jmp    802ffb <insert_sorted_with_merge_freeList+0x729>
				{
				     next=LIST_NEXT(blk_itr);
  802bc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc9:	8b 00                	mov    (%eax),%eax
  802bcb:	89 45 e8             	mov    %eax,-0x18(%ebp)


					if( (blockToInsert->sva > blk_itr->sva) )
  802bce:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd1:	8b 50 08             	mov    0x8(%eax),%edx
  802bd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd7:	8b 40 08             	mov    0x8(%eax),%eax
  802bda:	39 c2                	cmp    %eax,%edx
  802bdc:	0f 86 11 04 00 00    	jbe    802ff3 <insert_sorted_with_merge_freeList+0x721>
						{
							if(((blk_itr->sva) + (blk_itr->size) < blockToInsert->sva && (blockToInsert->sva) + (blockToInsert->size) < next->sva))
  802be2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be5:	8b 50 08             	mov    0x8(%eax),%edx
  802be8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802beb:	8b 40 0c             	mov    0xc(%eax),%eax
  802bee:	01 c2                	add    %eax,%edx
  802bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf3:	8b 40 08             	mov    0x8(%eax),%eax
  802bf6:	39 c2                	cmp    %eax,%edx
  802bf8:	0f 83 8b 00 00 00    	jae    802c89 <insert_sorted_with_merge_freeList+0x3b7>
  802bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  802c01:	8b 50 08             	mov    0x8(%eax),%edx
  802c04:	8b 45 08             	mov    0x8(%ebp),%eax
  802c07:	8b 40 0c             	mov    0xc(%eax),%eax
  802c0a:	01 c2                	add    %eax,%edx
  802c0c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c0f:	8b 40 08             	mov    0x8(%eax),%eax
  802c12:	39 c2                	cmp    %eax,%edx
  802c14:	73 73                	jae    802c89 <insert_sorted_with_merge_freeList+0x3b7>
							{
								LIST_INSERT_AFTER(&(FreeMemBlocksList), blk_itr, blockToInsert);
  802c16:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c1a:	74 06                	je     802c22 <insert_sorted_with_merge_freeList+0x350>
  802c1c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c20:	75 17                	jne    802c39 <insert_sorted_with_merge_freeList+0x367>
  802c22:	83 ec 04             	sub    $0x4,%esp
  802c25:	68 44 3b 80 00       	push   $0x803b44
  802c2a:	68 48 01 00 00       	push   $0x148
  802c2f:	68 f3 3a 80 00       	push   $0x803af3
  802c34:	e8 ed d6 ff ff       	call   800326 <_panic>
  802c39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3c:	8b 10                	mov    (%eax),%edx
  802c3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c41:	89 10                	mov    %edx,(%eax)
  802c43:	8b 45 08             	mov    0x8(%ebp),%eax
  802c46:	8b 00                	mov    (%eax),%eax
  802c48:	85 c0                	test   %eax,%eax
  802c4a:	74 0b                	je     802c57 <insert_sorted_with_merge_freeList+0x385>
  802c4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4f:	8b 00                	mov    (%eax),%eax
  802c51:	8b 55 08             	mov    0x8(%ebp),%edx
  802c54:	89 50 04             	mov    %edx,0x4(%eax)
  802c57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5a:	8b 55 08             	mov    0x8(%ebp),%edx
  802c5d:	89 10                	mov    %edx,(%eax)
  802c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c62:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c65:	89 50 04             	mov    %edx,0x4(%eax)
  802c68:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6b:	8b 00                	mov    (%eax),%eax
  802c6d:	85 c0                	test   %eax,%eax
  802c6f:	75 08                	jne    802c79 <insert_sorted_with_merge_freeList+0x3a7>
  802c71:	8b 45 08             	mov    0x8(%ebp),%eax
  802c74:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c79:	a1 44 41 80 00       	mov    0x804144,%eax
  802c7e:	40                   	inc    %eax
  802c7f:	a3 44 41 80 00       	mov    %eax,0x804144
								break;
  802c84:	e9 a2 03 00 00       	jmp    80302b <insert_sorted_with_merge_freeList+0x759>

							}
							else if((blockToInsert->sva + blockToInsert->size) < next->sva  && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  802c89:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8c:	8b 50 08             	mov    0x8(%eax),%edx
  802c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c92:	8b 40 0c             	mov    0xc(%eax),%eax
  802c95:	01 c2                	add    %eax,%edx
  802c97:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c9a:	8b 40 08             	mov    0x8(%eax),%eax
  802c9d:	39 c2                	cmp    %eax,%edx
  802c9f:	0f 83 ae 00 00 00    	jae    802d53 <insert_sorted_with_merge_freeList+0x481>
  802ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca8:	8b 50 08             	mov    0x8(%eax),%edx
  802cab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cae:	8b 48 08             	mov    0x8(%eax),%ecx
  802cb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb4:	8b 40 0c             	mov    0xc(%eax),%eax
  802cb7:	01 c8                	add    %ecx,%eax
  802cb9:	39 c2                	cmp    %eax,%edx
  802cbb:	0f 85 92 00 00 00    	jne    802d53 <insert_sorted_with_merge_freeList+0x481>
							{

								blk_itr->size=blk_itr->size+blockToInsert->size;
  802cc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc4:	8b 50 0c             	mov    0xc(%eax),%edx
  802cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cca:	8b 40 0c             	mov    0xc(%eax),%eax
  802ccd:	01 c2                	add    %eax,%edx
  802ccf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd2:	89 50 0c             	mov    %edx,0xc(%eax)
								 blockToInsert->size=blockToInsert->sva=0;
  802cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce2:	8b 50 08             	mov    0x8(%eax),%edx
  802ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce8:	89 50 0c             	mov    %edx,0xc(%eax)
								 LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802ceb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cef:	75 17                	jne    802d08 <insert_sorted_with_merge_freeList+0x436>
  802cf1:	83 ec 04             	sub    $0x4,%esp
  802cf4:	68 d0 3a 80 00       	push   $0x803ad0
  802cf9:	68 51 01 00 00       	push   $0x151
  802cfe:	68 f3 3a 80 00       	push   $0x803af3
  802d03:	e8 1e d6 ff ff       	call   800326 <_panic>
  802d08:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d11:	89 10                	mov    %edx,(%eax)
  802d13:	8b 45 08             	mov    0x8(%ebp),%eax
  802d16:	8b 00                	mov    (%eax),%eax
  802d18:	85 c0                	test   %eax,%eax
  802d1a:	74 0d                	je     802d29 <insert_sorted_with_merge_freeList+0x457>
  802d1c:	a1 48 41 80 00       	mov    0x804148,%eax
  802d21:	8b 55 08             	mov    0x8(%ebp),%edx
  802d24:	89 50 04             	mov    %edx,0x4(%eax)
  802d27:	eb 08                	jmp    802d31 <insert_sorted_with_merge_freeList+0x45f>
  802d29:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d31:	8b 45 08             	mov    0x8(%ebp),%eax
  802d34:	a3 48 41 80 00       	mov    %eax,0x804148
  802d39:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d43:	a1 54 41 80 00       	mov    0x804154,%eax
  802d48:	40                   	inc    %eax
  802d49:	a3 54 41 80 00       	mov    %eax,0x804154
								 break;
  802d4e:	e9 d8 02 00 00       	jmp    80302b <insert_sorted_with_merge_freeList+0x759>

							}
							else if( (blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva > (blk_itr->sva + blk_itr->size))
  802d53:	8b 45 08             	mov    0x8(%ebp),%eax
  802d56:	8b 50 08             	mov    0x8(%eax),%edx
  802d59:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5c:	8b 40 0c             	mov    0xc(%eax),%eax
  802d5f:	01 c2                	add    %eax,%edx
  802d61:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d64:	8b 40 08             	mov    0x8(%eax),%eax
  802d67:	39 c2                	cmp    %eax,%edx
  802d69:	0f 85 ba 00 00 00    	jne    802e29 <insert_sorted_with_merge_freeList+0x557>
  802d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d72:	8b 50 08             	mov    0x8(%eax),%edx
  802d75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d78:	8b 48 08             	mov    0x8(%eax),%ecx
  802d7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7e:	8b 40 0c             	mov    0xc(%eax),%eax
  802d81:	01 c8                	add    %ecx,%eax
  802d83:	39 c2                	cmp    %eax,%edx
  802d85:	0f 86 9e 00 00 00    	jbe    802e29 <insert_sorted_with_merge_freeList+0x557>
							{
								next->size = next->size + blockToInsert->size;
  802d8b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d8e:	8b 50 0c             	mov    0xc(%eax),%edx
  802d91:	8b 45 08             	mov    0x8(%ebp),%eax
  802d94:	8b 40 0c             	mov    0xc(%eax),%eax
  802d97:	01 c2                	add    %eax,%edx
  802d99:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d9c:	89 50 0c             	mov    %edx,0xc(%eax)
								next->sva = blockToInsert->sva;
  802d9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802da2:	8b 50 08             	mov    0x8(%eax),%edx
  802da5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802da8:	89 50 08             	mov    %edx,0x8(%eax)

								blockToInsert->size = blockToInsert->sva = 0;
  802dab:	8b 45 08             	mov    0x8(%ebp),%eax
  802dae:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802db5:	8b 45 08             	mov    0x8(%ebp),%eax
  802db8:	8b 50 08             	mov    0x8(%eax),%edx
  802dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbe:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802dc1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dc5:	75 17                	jne    802dde <insert_sorted_with_merge_freeList+0x50c>
  802dc7:	83 ec 04             	sub    $0x4,%esp
  802dca:	68 d0 3a 80 00       	push   $0x803ad0
  802dcf:	68 5b 01 00 00       	push   $0x15b
  802dd4:	68 f3 3a 80 00       	push   $0x803af3
  802dd9:	e8 48 d5 ff ff       	call   800326 <_panic>
  802dde:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802de4:	8b 45 08             	mov    0x8(%ebp),%eax
  802de7:	89 10                	mov    %edx,(%eax)
  802de9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dec:	8b 00                	mov    (%eax),%eax
  802dee:	85 c0                	test   %eax,%eax
  802df0:	74 0d                	je     802dff <insert_sorted_with_merge_freeList+0x52d>
  802df2:	a1 48 41 80 00       	mov    0x804148,%eax
  802df7:	8b 55 08             	mov    0x8(%ebp),%edx
  802dfa:	89 50 04             	mov    %edx,0x4(%eax)
  802dfd:	eb 08                	jmp    802e07 <insert_sorted_with_merge_freeList+0x535>
  802dff:	8b 45 08             	mov    0x8(%ebp),%eax
  802e02:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e07:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0a:	a3 48 41 80 00       	mov    %eax,0x804148
  802e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e12:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e19:	a1 54 41 80 00       	mov    0x804154,%eax
  802e1e:	40                   	inc    %eax
  802e1f:	a3 54 41 80 00       	mov    %eax,0x804154
								break;
  802e24:	e9 02 02 00 00       	jmp    80302b <insert_sorted_with_merge_freeList+0x759>
							}
							else if ((blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  802e29:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2c:	8b 50 08             	mov    0x8(%eax),%edx
  802e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e32:	8b 40 0c             	mov    0xc(%eax),%eax
  802e35:	01 c2                	add    %eax,%edx
  802e37:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e3a:	8b 40 08             	mov    0x8(%eax),%eax
  802e3d:	39 c2                	cmp    %eax,%edx
  802e3f:	0f 85 ae 01 00 00    	jne    802ff3 <insert_sorted_with_merge_freeList+0x721>
  802e45:	8b 45 08             	mov    0x8(%ebp),%eax
  802e48:	8b 50 08             	mov    0x8(%eax),%edx
  802e4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4e:	8b 48 08             	mov    0x8(%eax),%ecx
  802e51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e54:	8b 40 0c             	mov    0xc(%eax),%eax
  802e57:	01 c8                	add    %ecx,%eax
  802e59:	39 c2                	cmp    %eax,%edx
  802e5b:	0f 85 92 01 00 00    	jne    802ff3 <insert_sorted_with_merge_freeList+0x721>
							{
								blk_itr->size = blk_itr->size + blockToInsert->size + next->size;
  802e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e64:	8b 50 0c             	mov    0xc(%eax),%edx
  802e67:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6a:	8b 40 0c             	mov    0xc(%eax),%eax
  802e6d:	01 c2                	add    %eax,%edx
  802e6f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e72:	8b 40 0c             	mov    0xc(%eax),%eax
  802e75:	01 c2                	add    %eax,%edx
  802e77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7a:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size = blockToInsert->sva=0;
  802e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e80:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802e87:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8a:	8b 50 08             	mov    0x8(%eax),%edx
  802e8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e90:	89 50 0c             	mov    %edx,0xc(%eax)
								next->size = next->sva = 0;
  802e93:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e96:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802e9d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ea0:	8b 50 08             	mov    0x8(%eax),%edx
  802ea3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ea6:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_REMOVE(&FreeMemBlocksList, next);
  802ea9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ead:	75 17                	jne    802ec6 <insert_sorted_with_merge_freeList+0x5f4>
  802eaf:	83 ec 04             	sub    $0x4,%esp
  802eb2:	68 9b 3b 80 00       	push   $0x803b9b
  802eb7:	68 63 01 00 00       	push   $0x163
  802ebc:	68 f3 3a 80 00       	push   $0x803af3
  802ec1:	e8 60 d4 ff ff       	call   800326 <_panic>
  802ec6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ec9:	8b 00                	mov    (%eax),%eax
  802ecb:	85 c0                	test   %eax,%eax
  802ecd:	74 10                	je     802edf <insert_sorted_with_merge_freeList+0x60d>
  802ecf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ed2:	8b 00                	mov    (%eax),%eax
  802ed4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ed7:	8b 52 04             	mov    0x4(%edx),%edx
  802eda:	89 50 04             	mov    %edx,0x4(%eax)
  802edd:	eb 0b                	jmp    802eea <insert_sorted_with_merge_freeList+0x618>
  802edf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ee2:	8b 40 04             	mov    0x4(%eax),%eax
  802ee5:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802eea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eed:	8b 40 04             	mov    0x4(%eax),%eax
  802ef0:	85 c0                	test   %eax,%eax
  802ef2:	74 0f                	je     802f03 <insert_sorted_with_merge_freeList+0x631>
  802ef4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ef7:	8b 40 04             	mov    0x4(%eax),%eax
  802efa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802efd:	8b 12                	mov    (%edx),%edx
  802eff:	89 10                	mov    %edx,(%eax)
  802f01:	eb 0a                	jmp    802f0d <insert_sorted_with_merge_freeList+0x63b>
  802f03:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f06:	8b 00                	mov    (%eax),%eax
  802f08:	a3 38 41 80 00       	mov    %eax,0x804138
  802f0d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f10:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f16:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f19:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f20:	a1 44 41 80 00       	mov    0x804144,%eax
  802f25:	48                   	dec    %eax
  802f26:	a3 44 41 80 00       	mov    %eax,0x804144
								LIST_INSERT_HEAD(&AvailableMemBlocksList, next );
  802f2b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f2f:	75 17                	jne    802f48 <insert_sorted_with_merge_freeList+0x676>
  802f31:	83 ec 04             	sub    $0x4,%esp
  802f34:	68 d0 3a 80 00       	push   $0x803ad0
  802f39:	68 64 01 00 00       	push   $0x164
  802f3e:	68 f3 3a 80 00       	push   $0x803af3
  802f43:	e8 de d3 ff ff       	call   800326 <_panic>
  802f48:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f4e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f51:	89 10                	mov    %edx,(%eax)
  802f53:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f56:	8b 00                	mov    (%eax),%eax
  802f58:	85 c0                	test   %eax,%eax
  802f5a:	74 0d                	je     802f69 <insert_sorted_with_merge_freeList+0x697>
  802f5c:	a1 48 41 80 00       	mov    0x804148,%eax
  802f61:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f64:	89 50 04             	mov    %edx,0x4(%eax)
  802f67:	eb 08                	jmp    802f71 <insert_sorted_with_merge_freeList+0x69f>
  802f69:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f6c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f71:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f74:	a3 48 41 80 00       	mov    %eax,0x804148
  802f79:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f7c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f83:	a1 54 41 80 00       	mov    0x804154,%eax
  802f88:	40                   	inc    %eax
  802f89:	a3 54 41 80 00       	mov    %eax,0x804154
							    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802f8e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f92:	75 17                	jne    802fab <insert_sorted_with_merge_freeList+0x6d9>
  802f94:	83 ec 04             	sub    $0x4,%esp
  802f97:	68 d0 3a 80 00       	push   $0x803ad0
  802f9c:	68 65 01 00 00       	push   $0x165
  802fa1:	68 f3 3a 80 00       	push   $0x803af3
  802fa6:	e8 7b d3 ff ff       	call   800326 <_panic>
  802fab:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802fb1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb4:	89 10                	mov    %edx,(%eax)
  802fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb9:	8b 00                	mov    (%eax),%eax
  802fbb:	85 c0                	test   %eax,%eax
  802fbd:	74 0d                	je     802fcc <insert_sorted_with_merge_freeList+0x6fa>
  802fbf:	a1 48 41 80 00       	mov    0x804148,%eax
  802fc4:	8b 55 08             	mov    0x8(%ebp),%edx
  802fc7:	89 50 04             	mov    %edx,0x4(%eax)
  802fca:	eb 08                	jmp    802fd4 <insert_sorted_with_merge_freeList+0x702>
  802fcc:	8b 45 08             	mov    0x8(%ebp),%eax
  802fcf:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802fd4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd7:	a3 48 41 80 00       	mov    %eax,0x804148
  802fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  802fdf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fe6:	a1 54 41 80 00       	mov    0x804154,%eax
  802feb:	40                   	inc    %eax
  802fec:	a3 54 41 80 00       	mov    %eax,0x804154
								break;
  802ff1:	eb 38                	jmp    80302b <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  802ff3:	a1 40 41 80 00       	mov    0x804140,%eax
  802ff8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ffb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fff:	74 07                	je     803008 <insert_sorted_with_merge_freeList+0x736>
  803001:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803004:	8b 00                	mov    (%eax),%eax
  803006:	eb 05                	jmp    80300d <insert_sorted_with_merge_freeList+0x73b>
  803008:	b8 00 00 00 00       	mov    $0x0,%eax
  80300d:	a3 40 41 80 00       	mov    %eax,0x804140
  803012:	a1 40 41 80 00       	mov    0x804140,%eax
  803017:	85 c0                	test   %eax,%eax
  803019:	0f 85 a7 fb ff ff    	jne    802bc6 <insert_sorted_with_merge_freeList+0x2f4>
  80301f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803023:	0f 85 9d fb ff ff    	jne    802bc6 <insert_sorted_with_merge_freeList+0x2f4>
						}
				}
        }

}
}
  803029:	eb 00                	jmp    80302b <insert_sorted_with_merge_freeList+0x759>
  80302b:	90                   	nop
  80302c:	c9                   	leave  
  80302d:	c3                   	ret    

0080302e <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  80302e:	55                   	push   %ebp
  80302f:	89 e5                	mov    %esp,%ebp
  803031:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803034:	8b 55 08             	mov    0x8(%ebp),%edx
  803037:	89 d0                	mov    %edx,%eax
  803039:	c1 e0 02             	shl    $0x2,%eax
  80303c:	01 d0                	add    %edx,%eax
  80303e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803045:	01 d0                	add    %edx,%eax
  803047:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80304e:	01 d0                	add    %edx,%eax
  803050:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803057:	01 d0                	add    %edx,%eax
  803059:	c1 e0 04             	shl    $0x4,%eax
  80305c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  80305f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803066:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803069:	83 ec 0c             	sub    $0xc,%esp
  80306c:	50                   	push   %eax
  80306d:	e8 ee eb ff ff       	call   801c60 <sys_get_virtual_time>
  803072:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803075:	eb 41                	jmp    8030b8 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803077:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80307a:	83 ec 0c             	sub    $0xc,%esp
  80307d:	50                   	push   %eax
  80307e:	e8 dd eb ff ff       	call   801c60 <sys_get_virtual_time>
  803083:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803086:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803089:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80308c:	29 c2                	sub    %eax,%edx
  80308e:	89 d0                	mov    %edx,%eax
  803090:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803093:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803096:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803099:	89 d1                	mov    %edx,%ecx
  80309b:	29 c1                	sub    %eax,%ecx
  80309d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8030a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030a3:	39 c2                	cmp    %eax,%edx
  8030a5:	0f 97 c0             	seta   %al
  8030a8:	0f b6 c0             	movzbl %al,%eax
  8030ab:	29 c1                	sub    %eax,%ecx
  8030ad:	89 c8                	mov    %ecx,%eax
  8030af:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8030b2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8030b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8030b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030bb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8030be:	72 b7                	jb     803077 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8030c0:	90                   	nop
  8030c1:	c9                   	leave  
  8030c2:	c3                   	ret    

008030c3 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8030c3:	55                   	push   %ebp
  8030c4:	89 e5                	mov    %esp,%ebp
  8030c6:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8030c9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8030d0:	eb 03                	jmp    8030d5 <busy_wait+0x12>
  8030d2:	ff 45 fc             	incl   -0x4(%ebp)
  8030d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8030d8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030db:	72 f5                	jb     8030d2 <busy_wait+0xf>
	return i;
  8030dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8030e0:	c9                   	leave  
  8030e1:	c3                   	ret    
  8030e2:	66 90                	xchg   %ax,%ax

008030e4 <__udivdi3>:
  8030e4:	55                   	push   %ebp
  8030e5:	57                   	push   %edi
  8030e6:	56                   	push   %esi
  8030e7:	53                   	push   %ebx
  8030e8:	83 ec 1c             	sub    $0x1c,%esp
  8030eb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8030ef:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8030f3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8030f7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8030fb:	89 ca                	mov    %ecx,%edx
  8030fd:	89 f8                	mov    %edi,%eax
  8030ff:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803103:	85 f6                	test   %esi,%esi
  803105:	75 2d                	jne    803134 <__udivdi3+0x50>
  803107:	39 cf                	cmp    %ecx,%edi
  803109:	77 65                	ja     803170 <__udivdi3+0x8c>
  80310b:	89 fd                	mov    %edi,%ebp
  80310d:	85 ff                	test   %edi,%edi
  80310f:	75 0b                	jne    80311c <__udivdi3+0x38>
  803111:	b8 01 00 00 00       	mov    $0x1,%eax
  803116:	31 d2                	xor    %edx,%edx
  803118:	f7 f7                	div    %edi
  80311a:	89 c5                	mov    %eax,%ebp
  80311c:	31 d2                	xor    %edx,%edx
  80311e:	89 c8                	mov    %ecx,%eax
  803120:	f7 f5                	div    %ebp
  803122:	89 c1                	mov    %eax,%ecx
  803124:	89 d8                	mov    %ebx,%eax
  803126:	f7 f5                	div    %ebp
  803128:	89 cf                	mov    %ecx,%edi
  80312a:	89 fa                	mov    %edi,%edx
  80312c:	83 c4 1c             	add    $0x1c,%esp
  80312f:	5b                   	pop    %ebx
  803130:	5e                   	pop    %esi
  803131:	5f                   	pop    %edi
  803132:	5d                   	pop    %ebp
  803133:	c3                   	ret    
  803134:	39 ce                	cmp    %ecx,%esi
  803136:	77 28                	ja     803160 <__udivdi3+0x7c>
  803138:	0f bd fe             	bsr    %esi,%edi
  80313b:	83 f7 1f             	xor    $0x1f,%edi
  80313e:	75 40                	jne    803180 <__udivdi3+0x9c>
  803140:	39 ce                	cmp    %ecx,%esi
  803142:	72 0a                	jb     80314e <__udivdi3+0x6a>
  803144:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803148:	0f 87 9e 00 00 00    	ja     8031ec <__udivdi3+0x108>
  80314e:	b8 01 00 00 00       	mov    $0x1,%eax
  803153:	89 fa                	mov    %edi,%edx
  803155:	83 c4 1c             	add    $0x1c,%esp
  803158:	5b                   	pop    %ebx
  803159:	5e                   	pop    %esi
  80315a:	5f                   	pop    %edi
  80315b:	5d                   	pop    %ebp
  80315c:	c3                   	ret    
  80315d:	8d 76 00             	lea    0x0(%esi),%esi
  803160:	31 ff                	xor    %edi,%edi
  803162:	31 c0                	xor    %eax,%eax
  803164:	89 fa                	mov    %edi,%edx
  803166:	83 c4 1c             	add    $0x1c,%esp
  803169:	5b                   	pop    %ebx
  80316a:	5e                   	pop    %esi
  80316b:	5f                   	pop    %edi
  80316c:	5d                   	pop    %ebp
  80316d:	c3                   	ret    
  80316e:	66 90                	xchg   %ax,%ax
  803170:	89 d8                	mov    %ebx,%eax
  803172:	f7 f7                	div    %edi
  803174:	31 ff                	xor    %edi,%edi
  803176:	89 fa                	mov    %edi,%edx
  803178:	83 c4 1c             	add    $0x1c,%esp
  80317b:	5b                   	pop    %ebx
  80317c:	5e                   	pop    %esi
  80317d:	5f                   	pop    %edi
  80317e:	5d                   	pop    %ebp
  80317f:	c3                   	ret    
  803180:	bd 20 00 00 00       	mov    $0x20,%ebp
  803185:	89 eb                	mov    %ebp,%ebx
  803187:	29 fb                	sub    %edi,%ebx
  803189:	89 f9                	mov    %edi,%ecx
  80318b:	d3 e6                	shl    %cl,%esi
  80318d:	89 c5                	mov    %eax,%ebp
  80318f:	88 d9                	mov    %bl,%cl
  803191:	d3 ed                	shr    %cl,%ebp
  803193:	89 e9                	mov    %ebp,%ecx
  803195:	09 f1                	or     %esi,%ecx
  803197:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80319b:	89 f9                	mov    %edi,%ecx
  80319d:	d3 e0                	shl    %cl,%eax
  80319f:	89 c5                	mov    %eax,%ebp
  8031a1:	89 d6                	mov    %edx,%esi
  8031a3:	88 d9                	mov    %bl,%cl
  8031a5:	d3 ee                	shr    %cl,%esi
  8031a7:	89 f9                	mov    %edi,%ecx
  8031a9:	d3 e2                	shl    %cl,%edx
  8031ab:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031af:	88 d9                	mov    %bl,%cl
  8031b1:	d3 e8                	shr    %cl,%eax
  8031b3:	09 c2                	or     %eax,%edx
  8031b5:	89 d0                	mov    %edx,%eax
  8031b7:	89 f2                	mov    %esi,%edx
  8031b9:	f7 74 24 0c          	divl   0xc(%esp)
  8031bd:	89 d6                	mov    %edx,%esi
  8031bf:	89 c3                	mov    %eax,%ebx
  8031c1:	f7 e5                	mul    %ebp
  8031c3:	39 d6                	cmp    %edx,%esi
  8031c5:	72 19                	jb     8031e0 <__udivdi3+0xfc>
  8031c7:	74 0b                	je     8031d4 <__udivdi3+0xf0>
  8031c9:	89 d8                	mov    %ebx,%eax
  8031cb:	31 ff                	xor    %edi,%edi
  8031cd:	e9 58 ff ff ff       	jmp    80312a <__udivdi3+0x46>
  8031d2:	66 90                	xchg   %ax,%ax
  8031d4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8031d8:	89 f9                	mov    %edi,%ecx
  8031da:	d3 e2                	shl    %cl,%edx
  8031dc:	39 c2                	cmp    %eax,%edx
  8031de:	73 e9                	jae    8031c9 <__udivdi3+0xe5>
  8031e0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8031e3:	31 ff                	xor    %edi,%edi
  8031e5:	e9 40 ff ff ff       	jmp    80312a <__udivdi3+0x46>
  8031ea:	66 90                	xchg   %ax,%ax
  8031ec:	31 c0                	xor    %eax,%eax
  8031ee:	e9 37 ff ff ff       	jmp    80312a <__udivdi3+0x46>
  8031f3:	90                   	nop

008031f4 <__umoddi3>:
  8031f4:	55                   	push   %ebp
  8031f5:	57                   	push   %edi
  8031f6:	56                   	push   %esi
  8031f7:	53                   	push   %ebx
  8031f8:	83 ec 1c             	sub    $0x1c,%esp
  8031fb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8031ff:	8b 74 24 34          	mov    0x34(%esp),%esi
  803203:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803207:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80320b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80320f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803213:	89 f3                	mov    %esi,%ebx
  803215:	89 fa                	mov    %edi,%edx
  803217:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80321b:	89 34 24             	mov    %esi,(%esp)
  80321e:	85 c0                	test   %eax,%eax
  803220:	75 1a                	jne    80323c <__umoddi3+0x48>
  803222:	39 f7                	cmp    %esi,%edi
  803224:	0f 86 a2 00 00 00    	jbe    8032cc <__umoddi3+0xd8>
  80322a:	89 c8                	mov    %ecx,%eax
  80322c:	89 f2                	mov    %esi,%edx
  80322e:	f7 f7                	div    %edi
  803230:	89 d0                	mov    %edx,%eax
  803232:	31 d2                	xor    %edx,%edx
  803234:	83 c4 1c             	add    $0x1c,%esp
  803237:	5b                   	pop    %ebx
  803238:	5e                   	pop    %esi
  803239:	5f                   	pop    %edi
  80323a:	5d                   	pop    %ebp
  80323b:	c3                   	ret    
  80323c:	39 f0                	cmp    %esi,%eax
  80323e:	0f 87 ac 00 00 00    	ja     8032f0 <__umoddi3+0xfc>
  803244:	0f bd e8             	bsr    %eax,%ebp
  803247:	83 f5 1f             	xor    $0x1f,%ebp
  80324a:	0f 84 ac 00 00 00    	je     8032fc <__umoddi3+0x108>
  803250:	bf 20 00 00 00       	mov    $0x20,%edi
  803255:	29 ef                	sub    %ebp,%edi
  803257:	89 fe                	mov    %edi,%esi
  803259:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80325d:	89 e9                	mov    %ebp,%ecx
  80325f:	d3 e0                	shl    %cl,%eax
  803261:	89 d7                	mov    %edx,%edi
  803263:	89 f1                	mov    %esi,%ecx
  803265:	d3 ef                	shr    %cl,%edi
  803267:	09 c7                	or     %eax,%edi
  803269:	89 e9                	mov    %ebp,%ecx
  80326b:	d3 e2                	shl    %cl,%edx
  80326d:	89 14 24             	mov    %edx,(%esp)
  803270:	89 d8                	mov    %ebx,%eax
  803272:	d3 e0                	shl    %cl,%eax
  803274:	89 c2                	mov    %eax,%edx
  803276:	8b 44 24 08          	mov    0x8(%esp),%eax
  80327a:	d3 e0                	shl    %cl,%eax
  80327c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803280:	8b 44 24 08          	mov    0x8(%esp),%eax
  803284:	89 f1                	mov    %esi,%ecx
  803286:	d3 e8                	shr    %cl,%eax
  803288:	09 d0                	or     %edx,%eax
  80328a:	d3 eb                	shr    %cl,%ebx
  80328c:	89 da                	mov    %ebx,%edx
  80328e:	f7 f7                	div    %edi
  803290:	89 d3                	mov    %edx,%ebx
  803292:	f7 24 24             	mull   (%esp)
  803295:	89 c6                	mov    %eax,%esi
  803297:	89 d1                	mov    %edx,%ecx
  803299:	39 d3                	cmp    %edx,%ebx
  80329b:	0f 82 87 00 00 00    	jb     803328 <__umoddi3+0x134>
  8032a1:	0f 84 91 00 00 00    	je     803338 <__umoddi3+0x144>
  8032a7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8032ab:	29 f2                	sub    %esi,%edx
  8032ad:	19 cb                	sbb    %ecx,%ebx
  8032af:	89 d8                	mov    %ebx,%eax
  8032b1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8032b5:	d3 e0                	shl    %cl,%eax
  8032b7:	89 e9                	mov    %ebp,%ecx
  8032b9:	d3 ea                	shr    %cl,%edx
  8032bb:	09 d0                	or     %edx,%eax
  8032bd:	89 e9                	mov    %ebp,%ecx
  8032bf:	d3 eb                	shr    %cl,%ebx
  8032c1:	89 da                	mov    %ebx,%edx
  8032c3:	83 c4 1c             	add    $0x1c,%esp
  8032c6:	5b                   	pop    %ebx
  8032c7:	5e                   	pop    %esi
  8032c8:	5f                   	pop    %edi
  8032c9:	5d                   	pop    %ebp
  8032ca:	c3                   	ret    
  8032cb:	90                   	nop
  8032cc:	89 fd                	mov    %edi,%ebp
  8032ce:	85 ff                	test   %edi,%edi
  8032d0:	75 0b                	jne    8032dd <__umoddi3+0xe9>
  8032d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8032d7:	31 d2                	xor    %edx,%edx
  8032d9:	f7 f7                	div    %edi
  8032db:	89 c5                	mov    %eax,%ebp
  8032dd:	89 f0                	mov    %esi,%eax
  8032df:	31 d2                	xor    %edx,%edx
  8032e1:	f7 f5                	div    %ebp
  8032e3:	89 c8                	mov    %ecx,%eax
  8032e5:	f7 f5                	div    %ebp
  8032e7:	89 d0                	mov    %edx,%eax
  8032e9:	e9 44 ff ff ff       	jmp    803232 <__umoddi3+0x3e>
  8032ee:	66 90                	xchg   %ax,%ax
  8032f0:	89 c8                	mov    %ecx,%eax
  8032f2:	89 f2                	mov    %esi,%edx
  8032f4:	83 c4 1c             	add    $0x1c,%esp
  8032f7:	5b                   	pop    %ebx
  8032f8:	5e                   	pop    %esi
  8032f9:	5f                   	pop    %edi
  8032fa:	5d                   	pop    %ebp
  8032fb:	c3                   	ret    
  8032fc:	3b 04 24             	cmp    (%esp),%eax
  8032ff:	72 06                	jb     803307 <__umoddi3+0x113>
  803301:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803305:	77 0f                	ja     803316 <__umoddi3+0x122>
  803307:	89 f2                	mov    %esi,%edx
  803309:	29 f9                	sub    %edi,%ecx
  80330b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80330f:	89 14 24             	mov    %edx,(%esp)
  803312:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803316:	8b 44 24 04          	mov    0x4(%esp),%eax
  80331a:	8b 14 24             	mov    (%esp),%edx
  80331d:	83 c4 1c             	add    $0x1c,%esp
  803320:	5b                   	pop    %ebx
  803321:	5e                   	pop    %esi
  803322:	5f                   	pop    %edi
  803323:	5d                   	pop    %ebp
  803324:	c3                   	ret    
  803325:	8d 76 00             	lea    0x0(%esi),%esi
  803328:	2b 04 24             	sub    (%esp),%eax
  80332b:	19 fa                	sbb    %edi,%edx
  80332d:	89 d1                	mov    %edx,%ecx
  80332f:	89 c6                	mov    %eax,%esi
  803331:	e9 71 ff ff ff       	jmp    8032a7 <__umoddi3+0xb3>
  803336:	66 90                	xchg   %ax,%ax
  803338:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80333c:	72 ea                	jb     803328 <__umoddi3+0x134>
  80333e:	89 d9                	mov    %ebx,%ecx
  803340:	e9 62 ff ff ff       	jmp    8032a7 <__umoddi3+0xb3>
