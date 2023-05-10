
obj/user/ef_tst_semaphore_1master:     file format elf32-i386


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
  800031:	e8 f8 01 00 00       	call   80022e <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Master program: create the semaphores, run slaves and wait them to finish
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	int envID = sys_getenvid();
  80003e:	e8 fc 1b 00 00       	call   801c3f <sys_getenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)

	sys_createSemaphore("cs1", 1);
  800046:	83 ec 08             	sub    $0x8,%esp
  800049:	6a 01                	push   $0x1
  80004b:	68 e0 32 80 00       	push   $0x8032e0
  800050:	e8 84 1a 00 00       	call   801ad9 <sys_createSemaphore>
  800055:	83 c4 10             	add    $0x10,%esp

	sys_createSemaphore("depend1", 0);
  800058:	83 ec 08             	sub    $0x8,%esp
  80005b:	6a 00                	push   $0x0
  80005d:	68 e4 32 80 00       	push   $0x8032e4
  800062:	e8 72 1a 00 00       	call   801ad9 <sys_createSemaphore>
  800067:	83 c4 10             	add    $0x10,%esp

	int id1, id2, id3;
	id1 = sys_create_env("ef_sem1Slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  80006a:	a1 20 40 80 00       	mov    0x804020,%eax
  80006f:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800075:	89 c2                	mov    %eax,%edx
  800077:	a1 20 40 80 00       	mov    0x804020,%eax
  80007c:	8b 40 74             	mov    0x74(%eax),%eax
  80007f:	6a 32                	push   $0x32
  800081:	52                   	push   %edx
  800082:	50                   	push   %eax
  800083:	68 ec 32 80 00       	push   $0x8032ec
  800088:	e8 5d 1b 00 00       	call   801bea <sys_create_env>
  80008d:	83 c4 10             	add    $0x10,%esp
  800090:	89 45 f0             	mov    %eax,-0x10(%ebp)
	id2 = sys_create_env("ef_sem1Slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  800093:	a1 20 40 80 00       	mov    0x804020,%eax
  800098:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80009e:	89 c2                	mov    %eax,%edx
  8000a0:	a1 20 40 80 00       	mov    0x804020,%eax
  8000a5:	8b 40 74             	mov    0x74(%eax),%eax
  8000a8:	6a 32                	push   $0x32
  8000aa:	52                   	push   %edx
  8000ab:	50                   	push   %eax
  8000ac:	68 ec 32 80 00       	push   $0x8032ec
  8000b1:	e8 34 1b 00 00       	call   801bea <sys_create_env>
  8000b6:	83 c4 10             	add    $0x10,%esp
  8000b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
	id3 = sys_create_env("ef_sem1Slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  8000bc:	a1 20 40 80 00       	mov    0x804020,%eax
  8000c1:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8000c7:	89 c2                	mov    %eax,%edx
  8000c9:	a1 20 40 80 00       	mov    0x804020,%eax
  8000ce:	8b 40 74             	mov    0x74(%eax),%eax
  8000d1:	6a 32                	push   $0x32
  8000d3:	52                   	push   %edx
  8000d4:	50                   	push   %eax
  8000d5:	68 ec 32 80 00       	push   $0x8032ec
  8000da:	e8 0b 1b 00 00       	call   801bea <sys_create_env>
  8000df:	83 c4 10             	add    $0x10,%esp
  8000e2:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if (id1 == E_ENV_CREATION_ERROR || id2 == E_ENV_CREATION_ERROR || id3 == E_ENV_CREATION_ERROR)
  8000e5:	83 7d f0 ef          	cmpl   $0xffffffef,-0x10(%ebp)
  8000e9:	74 0c                	je     8000f7 <_main+0xbf>
  8000eb:	83 7d ec ef          	cmpl   $0xffffffef,-0x14(%ebp)
  8000ef:	74 06                	je     8000f7 <_main+0xbf>
  8000f1:	83 7d e8 ef          	cmpl   $0xffffffef,-0x18(%ebp)
  8000f5:	75 14                	jne    80010b <_main+0xd3>
		panic("NO AVAILABLE ENVs...");
  8000f7:	83 ec 04             	sub    $0x4,%esp
  8000fa:	68 f9 32 80 00       	push   $0x8032f9
  8000ff:	6a 13                	push   $0x13
  800101:	68 10 33 80 00       	push   $0x803310
  800106:	e8 5f 02 00 00       	call   80036a <_panic>

	sys_run_env(id1);
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	ff 75 f0             	pushl  -0x10(%ebp)
  800111:	e8 f2 1a 00 00       	call   801c08 <sys_run_env>
  800116:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id2);
  800119:	83 ec 0c             	sub    $0xc,%esp
  80011c:	ff 75 ec             	pushl  -0x14(%ebp)
  80011f:	e8 e4 1a 00 00       	call   801c08 <sys_run_env>
  800124:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id3);
  800127:	83 ec 0c             	sub    $0xc,%esp
  80012a:	ff 75 e8             	pushl  -0x18(%ebp)
  80012d:	e8 d6 1a 00 00       	call   801c08 <sys_run_env>
  800132:	83 c4 10             	add    $0x10,%esp

	sys_waitSemaphore(envID, "depend1") ;
  800135:	83 ec 08             	sub    $0x8,%esp
  800138:	68 e4 32 80 00       	push   $0x8032e4
  80013d:	ff 75 f4             	pushl  -0xc(%ebp)
  800140:	e8 cd 19 00 00       	call   801b12 <sys_waitSemaphore>
  800145:	83 c4 10             	add    $0x10,%esp
	sys_waitSemaphore(envID, "depend1") ;
  800148:	83 ec 08             	sub    $0x8,%esp
  80014b:	68 e4 32 80 00       	push   $0x8032e4
  800150:	ff 75 f4             	pushl  -0xc(%ebp)
  800153:	e8 ba 19 00 00       	call   801b12 <sys_waitSemaphore>
  800158:	83 c4 10             	add    $0x10,%esp
	sys_waitSemaphore(envID, "depend1") ;
  80015b:	83 ec 08             	sub    $0x8,%esp
  80015e:	68 e4 32 80 00       	push   $0x8032e4
  800163:	ff 75 f4             	pushl  -0xc(%ebp)
  800166:	e8 a7 19 00 00       	call   801b12 <sys_waitSemaphore>
  80016b:	83 c4 10             	add    $0x10,%esp

	int sem1val = sys_getSemaphoreValue(envID, "cs1");
  80016e:	83 ec 08             	sub    $0x8,%esp
  800171:	68 e0 32 80 00       	push   $0x8032e0
  800176:	ff 75 f4             	pushl  -0xc(%ebp)
  800179:	e8 77 19 00 00       	call   801af5 <sys_getSemaphoreValue>
  80017e:	83 c4 10             	add    $0x10,%esp
  800181:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int sem2val = sys_getSemaphoreValue(envID, "depend1");
  800184:	83 ec 08             	sub    $0x8,%esp
  800187:	68 e4 32 80 00       	push   $0x8032e4
  80018c:	ff 75 f4             	pushl  -0xc(%ebp)
  80018f:	e8 61 19 00 00       	call   801af5 <sys_getSemaphoreValue>
  800194:	83 c4 10             	add    $0x10,%esp
  800197:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (sem2val == 0 && sem1val == 1)
  80019a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80019e:	75 18                	jne    8001b8 <_main+0x180>
  8001a0:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  8001a4:	75 12                	jne    8001b8 <_main+0x180>
		cprintf("Congratulations!! Test of Semaphores [1] completed successfully!!\n\n\n");
  8001a6:	83 ec 0c             	sub    $0xc,%esp
  8001a9:	68 30 33 80 00       	push   $0x803330
  8001ae:	e8 6b 04 00 00       	call   80061e <cprintf>
  8001b3:	83 c4 10             	add    $0x10,%esp
  8001b6:	eb 10                	jmp    8001c8 <_main+0x190>
	else
		cprintf("Error: wrong semaphore value... please review your semaphore code again...");
  8001b8:	83 ec 0c             	sub    $0xc,%esp
  8001bb:	68 78 33 80 00       	push   $0x803378
  8001c0:	e8 59 04 00 00       	call   80061e <cprintf>
  8001c5:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  8001c8:	e8 a4 1a 00 00       	call   801c71 <sys_getparentenvid>
  8001cd:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if(parentenvID > 0)
  8001d0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8001d4:	7e 55                	jle    80022b <_main+0x1f3>
	{
		//Get the check-finishing counter
		int *finishedCount = NULL;
  8001d6:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		finishedCount = sget(parentenvID, "finishedCount") ;
  8001dd:	83 ec 08             	sub    $0x8,%esp
  8001e0:	68 c3 33 80 00       	push   $0x8033c3
  8001e5:	ff 75 dc             	pushl  -0x24(%ebp)
  8001e8:	e8 55 15 00 00       	call   801742 <sget>
  8001ed:	83 c4 10             	add    $0x10,%esp
  8001f0:	89 45 d8             	mov    %eax,-0x28(%ebp)
		sys_destroy_env(id1);
  8001f3:	83 ec 0c             	sub    $0xc,%esp
  8001f6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f9:	e8 26 1a 00 00       	call   801c24 <sys_destroy_env>
  8001fe:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(id2);
  800201:	83 ec 0c             	sub    $0xc,%esp
  800204:	ff 75 ec             	pushl  -0x14(%ebp)
  800207:	e8 18 1a 00 00       	call   801c24 <sys_destroy_env>
  80020c:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(id3);
  80020f:	83 ec 0c             	sub    $0xc,%esp
  800212:	ff 75 e8             	pushl  -0x18(%ebp)
  800215:	e8 0a 1a 00 00       	call   801c24 <sys_destroy_env>
  80021a:	83 c4 10             	add    $0x10,%esp
		(*finishedCount)++ ;
  80021d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800220:	8b 00                	mov    (%eax),%eax
  800222:	8d 50 01             	lea    0x1(%eax),%edx
  800225:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800228:	89 10                	mov    %edx,(%eax)
	}

	return;
  80022a:	90                   	nop
  80022b:	90                   	nop
}
  80022c:	c9                   	leave  
  80022d:	c3                   	ret    

0080022e <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80022e:	55                   	push   %ebp
  80022f:	89 e5                	mov    %esp,%ebp
  800231:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800234:	e8 1f 1a 00 00       	call   801c58 <sys_getenvindex>
  800239:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80023c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80023f:	89 d0                	mov    %edx,%eax
  800241:	c1 e0 03             	shl    $0x3,%eax
  800244:	01 d0                	add    %edx,%eax
  800246:	01 c0                	add    %eax,%eax
  800248:	01 d0                	add    %edx,%eax
  80024a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800251:	01 d0                	add    %edx,%eax
  800253:	c1 e0 04             	shl    $0x4,%eax
  800256:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80025b:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800260:	a1 20 40 80 00       	mov    0x804020,%eax
  800265:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80026b:	84 c0                	test   %al,%al
  80026d:	74 0f                	je     80027e <libmain+0x50>
		binaryname = myEnv->prog_name;
  80026f:	a1 20 40 80 00       	mov    0x804020,%eax
  800274:	05 5c 05 00 00       	add    $0x55c,%eax
  800279:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80027e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800282:	7e 0a                	jle    80028e <libmain+0x60>
		binaryname = argv[0];
  800284:	8b 45 0c             	mov    0xc(%ebp),%eax
  800287:	8b 00                	mov    (%eax),%eax
  800289:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  80028e:	83 ec 08             	sub    $0x8,%esp
  800291:	ff 75 0c             	pushl  0xc(%ebp)
  800294:	ff 75 08             	pushl  0x8(%ebp)
  800297:	e8 9c fd ff ff       	call   800038 <_main>
  80029c:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80029f:	e8 c1 17 00 00       	call   801a65 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8002a4:	83 ec 0c             	sub    $0xc,%esp
  8002a7:	68 ec 33 80 00       	push   $0x8033ec
  8002ac:	e8 6d 03 00 00       	call   80061e <cprintf>
  8002b1:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002b4:	a1 20 40 80 00       	mov    0x804020,%eax
  8002b9:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8002bf:	a1 20 40 80 00       	mov    0x804020,%eax
  8002c4:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8002ca:	83 ec 04             	sub    $0x4,%esp
  8002cd:	52                   	push   %edx
  8002ce:	50                   	push   %eax
  8002cf:	68 14 34 80 00       	push   $0x803414
  8002d4:	e8 45 03 00 00       	call   80061e <cprintf>
  8002d9:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8002dc:	a1 20 40 80 00       	mov    0x804020,%eax
  8002e1:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8002e7:	a1 20 40 80 00       	mov    0x804020,%eax
  8002ec:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8002f2:	a1 20 40 80 00       	mov    0x804020,%eax
  8002f7:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8002fd:	51                   	push   %ecx
  8002fe:	52                   	push   %edx
  8002ff:	50                   	push   %eax
  800300:	68 3c 34 80 00       	push   $0x80343c
  800305:	e8 14 03 00 00       	call   80061e <cprintf>
  80030a:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80030d:	a1 20 40 80 00       	mov    0x804020,%eax
  800312:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800318:	83 ec 08             	sub    $0x8,%esp
  80031b:	50                   	push   %eax
  80031c:	68 94 34 80 00       	push   $0x803494
  800321:	e8 f8 02 00 00       	call   80061e <cprintf>
  800326:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800329:	83 ec 0c             	sub    $0xc,%esp
  80032c:	68 ec 33 80 00       	push   $0x8033ec
  800331:	e8 e8 02 00 00       	call   80061e <cprintf>
  800336:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800339:	e8 41 17 00 00       	call   801a7f <sys_enable_interrupt>

	// exit gracefully
	exit();
  80033e:	e8 19 00 00 00       	call   80035c <exit>
}
  800343:	90                   	nop
  800344:	c9                   	leave  
  800345:	c3                   	ret    

00800346 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800346:	55                   	push   %ebp
  800347:	89 e5                	mov    %esp,%ebp
  800349:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80034c:	83 ec 0c             	sub    $0xc,%esp
  80034f:	6a 00                	push   $0x0
  800351:	e8 ce 18 00 00       	call   801c24 <sys_destroy_env>
  800356:	83 c4 10             	add    $0x10,%esp
}
  800359:	90                   	nop
  80035a:	c9                   	leave  
  80035b:	c3                   	ret    

0080035c <exit>:

void
exit(void)
{
  80035c:	55                   	push   %ebp
  80035d:	89 e5                	mov    %esp,%ebp
  80035f:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800362:	e8 23 19 00 00       	call   801c8a <sys_exit_env>
}
  800367:	90                   	nop
  800368:	c9                   	leave  
  800369:	c3                   	ret    

0080036a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80036a:	55                   	push   %ebp
  80036b:	89 e5                	mov    %esp,%ebp
  80036d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800370:	8d 45 10             	lea    0x10(%ebp),%eax
  800373:	83 c0 04             	add    $0x4,%eax
  800376:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800379:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80037e:	85 c0                	test   %eax,%eax
  800380:	74 16                	je     800398 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800382:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800387:	83 ec 08             	sub    $0x8,%esp
  80038a:	50                   	push   %eax
  80038b:	68 a8 34 80 00       	push   $0x8034a8
  800390:	e8 89 02 00 00       	call   80061e <cprintf>
  800395:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800398:	a1 00 40 80 00       	mov    0x804000,%eax
  80039d:	ff 75 0c             	pushl  0xc(%ebp)
  8003a0:	ff 75 08             	pushl  0x8(%ebp)
  8003a3:	50                   	push   %eax
  8003a4:	68 ad 34 80 00       	push   $0x8034ad
  8003a9:	e8 70 02 00 00       	call   80061e <cprintf>
  8003ae:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8003b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8003b4:	83 ec 08             	sub    $0x8,%esp
  8003b7:	ff 75 f4             	pushl  -0xc(%ebp)
  8003ba:	50                   	push   %eax
  8003bb:	e8 f3 01 00 00       	call   8005b3 <vcprintf>
  8003c0:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8003c3:	83 ec 08             	sub    $0x8,%esp
  8003c6:	6a 00                	push   $0x0
  8003c8:	68 c9 34 80 00       	push   $0x8034c9
  8003cd:	e8 e1 01 00 00       	call   8005b3 <vcprintf>
  8003d2:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8003d5:	e8 82 ff ff ff       	call   80035c <exit>

	// should not return here
	while (1) ;
  8003da:	eb fe                	jmp    8003da <_panic+0x70>

008003dc <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8003dc:	55                   	push   %ebp
  8003dd:	89 e5                	mov    %esp,%ebp
  8003df:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8003e2:	a1 20 40 80 00       	mov    0x804020,%eax
  8003e7:	8b 50 74             	mov    0x74(%eax),%edx
  8003ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ed:	39 c2                	cmp    %eax,%edx
  8003ef:	74 14                	je     800405 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8003f1:	83 ec 04             	sub    $0x4,%esp
  8003f4:	68 cc 34 80 00       	push   $0x8034cc
  8003f9:	6a 26                	push   $0x26
  8003fb:	68 18 35 80 00       	push   $0x803518
  800400:	e8 65 ff ff ff       	call   80036a <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800405:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80040c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800413:	e9 c2 00 00 00       	jmp    8004da <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800418:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80041b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800422:	8b 45 08             	mov    0x8(%ebp),%eax
  800425:	01 d0                	add    %edx,%eax
  800427:	8b 00                	mov    (%eax),%eax
  800429:	85 c0                	test   %eax,%eax
  80042b:	75 08                	jne    800435 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80042d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800430:	e9 a2 00 00 00       	jmp    8004d7 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800435:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80043c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800443:	eb 69                	jmp    8004ae <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800445:	a1 20 40 80 00       	mov    0x804020,%eax
  80044a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800450:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800453:	89 d0                	mov    %edx,%eax
  800455:	01 c0                	add    %eax,%eax
  800457:	01 d0                	add    %edx,%eax
  800459:	c1 e0 03             	shl    $0x3,%eax
  80045c:	01 c8                	add    %ecx,%eax
  80045e:	8a 40 04             	mov    0x4(%eax),%al
  800461:	84 c0                	test   %al,%al
  800463:	75 46                	jne    8004ab <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800465:	a1 20 40 80 00       	mov    0x804020,%eax
  80046a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800470:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800473:	89 d0                	mov    %edx,%eax
  800475:	01 c0                	add    %eax,%eax
  800477:	01 d0                	add    %edx,%eax
  800479:	c1 e0 03             	shl    $0x3,%eax
  80047c:	01 c8                	add    %ecx,%eax
  80047e:	8b 00                	mov    (%eax),%eax
  800480:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800483:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800486:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80048b:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80048d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800490:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800497:	8b 45 08             	mov    0x8(%ebp),%eax
  80049a:	01 c8                	add    %ecx,%eax
  80049c:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80049e:	39 c2                	cmp    %eax,%edx
  8004a0:	75 09                	jne    8004ab <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8004a2:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8004a9:	eb 12                	jmp    8004bd <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004ab:	ff 45 e8             	incl   -0x18(%ebp)
  8004ae:	a1 20 40 80 00       	mov    0x804020,%eax
  8004b3:	8b 50 74             	mov    0x74(%eax),%edx
  8004b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004b9:	39 c2                	cmp    %eax,%edx
  8004bb:	77 88                	ja     800445 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8004bd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8004c1:	75 14                	jne    8004d7 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8004c3:	83 ec 04             	sub    $0x4,%esp
  8004c6:	68 24 35 80 00       	push   $0x803524
  8004cb:	6a 3a                	push   $0x3a
  8004cd:	68 18 35 80 00       	push   $0x803518
  8004d2:	e8 93 fe ff ff       	call   80036a <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8004d7:	ff 45 f0             	incl   -0x10(%ebp)
  8004da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004dd:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004e0:	0f 8c 32 ff ff ff    	jl     800418 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8004e6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004ed:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8004f4:	eb 26                	jmp    80051c <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8004f6:	a1 20 40 80 00       	mov    0x804020,%eax
  8004fb:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800501:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800504:	89 d0                	mov    %edx,%eax
  800506:	01 c0                	add    %eax,%eax
  800508:	01 d0                	add    %edx,%eax
  80050a:	c1 e0 03             	shl    $0x3,%eax
  80050d:	01 c8                	add    %ecx,%eax
  80050f:	8a 40 04             	mov    0x4(%eax),%al
  800512:	3c 01                	cmp    $0x1,%al
  800514:	75 03                	jne    800519 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800516:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800519:	ff 45 e0             	incl   -0x20(%ebp)
  80051c:	a1 20 40 80 00       	mov    0x804020,%eax
  800521:	8b 50 74             	mov    0x74(%eax),%edx
  800524:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800527:	39 c2                	cmp    %eax,%edx
  800529:	77 cb                	ja     8004f6 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80052b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80052e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800531:	74 14                	je     800547 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800533:	83 ec 04             	sub    $0x4,%esp
  800536:	68 78 35 80 00       	push   $0x803578
  80053b:	6a 44                	push   $0x44
  80053d:	68 18 35 80 00       	push   $0x803518
  800542:	e8 23 fe ff ff       	call   80036a <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800547:	90                   	nop
  800548:	c9                   	leave  
  800549:	c3                   	ret    

0080054a <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80054a:	55                   	push   %ebp
  80054b:	89 e5                	mov    %esp,%ebp
  80054d:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800550:	8b 45 0c             	mov    0xc(%ebp),%eax
  800553:	8b 00                	mov    (%eax),%eax
  800555:	8d 48 01             	lea    0x1(%eax),%ecx
  800558:	8b 55 0c             	mov    0xc(%ebp),%edx
  80055b:	89 0a                	mov    %ecx,(%edx)
  80055d:	8b 55 08             	mov    0x8(%ebp),%edx
  800560:	88 d1                	mov    %dl,%cl
  800562:	8b 55 0c             	mov    0xc(%ebp),%edx
  800565:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800569:	8b 45 0c             	mov    0xc(%ebp),%eax
  80056c:	8b 00                	mov    (%eax),%eax
  80056e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800573:	75 2c                	jne    8005a1 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800575:	a0 24 40 80 00       	mov    0x804024,%al
  80057a:	0f b6 c0             	movzbl %al,%eax
  80057d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800580:	8b 12                	mov    (%edx),%edx
  800582:	89 d1                	mov    %edx,%ecx
  800584:	8b 55 0c             	mov    0xc(%ebp),%edx
  800587:	83 c2 08             	add    $0x8,%edx
  80058a:	83 ec 04             	sub    $0x4,%esp
  80058d:	50                   	push   %eax
  80058e:	51                   	push   %ecx
  80058f:	52                   	push   %edx
  800590:	e8 22 13 00 00       	call   8018b7 <sys_cputs>
  800595:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800598:	8b 45 0c             	mov    0xc(%ebp),%eax
  80059b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8005a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005a4:	8b 40 04             	mov    0x4(%eax),%eax
  8005a7:	8d 50 01             	lea    0x1(%eax),%edx
  8005aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005ad:	89 50 04             	mov    %edx,0x4(%eax)
}
  8005b0:	90                   	nop
  8005b1:	c9                   	leave  
  8005b2:	c3                   	ret    

008005b3 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8005b3:	55                   	push   %ebp
  8005b4:	89 e5                	mov    %esp,%ebp
  8005b6:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005bc:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005c3:	00 00 00 
	b.cnt = 0;
  8005c6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005cd:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8005d0:	ff 75 0c             	pushl  0xc(%ebp)
  8005d3:	ff 75 08             	pushl  0x8(%ebp)
  8005d6:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005dc:	50                   	push   %eax
  8005dd:	68 4a 05 80 00       	push   $0x80054a
  8005e2:	e8 11 02 00 00       	call   8007f8 <vprintfmt>
  8005e7:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8005ea:	a0 24 40 80 00       	mov    0x804024,%al
  8005ef:	0f b6 c0             	movzbl %al,%eax
  8005f2:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8005f8:	83 ec 04             	sub    $0x4,%esp
  8005fb:	50                   	push   %eax
  8005fc:	52                   	push   %edx
  8005fd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800603:	83 c0 08             	add    $0x8,%eax
  800606:	50                   	push   %eax
  800607:	e8 ab 12 00 00       	call   8018b7 <sys_cputs>
  80060c:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80060f:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800616:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80061c:	c9                   	leave  
  80061d:	c3                   	ret    

0080061e <cprintf>:

int cprintf(const char *fmt, ...) {
  80061e:	55                   	push   %ebp
  80061f:	89 e5                	mov    %esp,%ebp
  800621:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800624:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  80062b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80062e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800631:	8b 45 08             	mov    0x8(%ebp),%eax
  800634:	83 ec 08             	sub    $0x8,%esp
  800637:	ff 75 f4             	pushl  -0xc(%ebp)
  80063a:	50                   	push   %eax
  80063b:	e8 73 ff ff ff       	call   8005b3 <vcprintf>
  800640:	83 c4 10             	add    $0x10,%esp
  800643:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800646:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800649:	c9                   	leave  
  80064a:	c3                   	ret    

0080064b <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80064b:	55                   	push   %ebp
  80064c:	89 e5                	mov    %esp,%ebp
  80064e:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800651:	e8 0f 14 00 00       	call   801a65 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800656:	8d 45 0c             	lea    0xc(%ebp),%eax
  800659:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80065c:	8b 45 08             	mov    0x8(%ebp),%eax
  80065f:	83 ec 08             	sub    $0x8,%esp
  800662:	ff 75 f4             	pushl  -0xc(%ebp)
  800665:	50                   	push   %eax
  800666:	e8 48 ff ff ff       	call   8005b3 <vcprintf>
  80066b:	83 c4 10             	add    $0x10,%esp
  80066e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800671:	e8 09 14 00 00       	call   801a7f <sys_enable_interrupt>
	return cnt;
  800676:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800679:	c9                   	leave  
  80067a:	c3                   	ret    

0080067b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80067b:	55                   	push   %ebp
  80067c:	89 e5                	mov    %esp,%ebp
  80067e:	53                   	push   %ebx
  80067f:	83 ec 14             	sub    $0x14,%esp
  800682:	8b 45 10             	mov    0x10(%ebp),%eax
  800685:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800688:	8b 45 14             	mov    0x14(%ebp),%eax
  80068b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80068e:	8b 45 18             	mov    0x18(%ebp),%eax
  800691:	ba 00 00 00 00       	mov    $0x0,%edx
  800696:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800699:	77 55                	ja     8006f0 <printnum+0x75>
  80069b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80069e:	72 05                	jb     8006a5 <printnum+0x2a>
  8006a0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8006a3:	77 4b                	ja     8006f0 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006a5:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006a8:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8006ab:	8b 45 18             	mov    0x18(%ebp),%eax
  8006ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8006b3:	52                   	push   %edx
  8006b4:	50                   	push   %eax
  8006b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8006b8:	ff 75 f0             	pushl  -0x10(%ebp)
  8006bb:	e8 b4 29 00 00       	call   803074 <__udivdi3>
  8006c0:	83 c4 10             	add    $0x10,%esp
  8006c3:	83 ec 04             	sub    $0x4,%esp
  8006c6:	ff 75 20             	pushl  0x20(%ebp)
  8006c9:	53                   	push   %ebx
  8006ca:	ff 75 18             	pushl  0x18(%ebp)
  8006cd:	52                   	push   %edx
  8006ce:	50                   	push   %eax
  8006cf:	ff 75 0c             	pushl  0xc(%ebp)
  8006d2:	ff 75 08             	pushl  0x8(%ebp)
  8006d5:	e8 a1 ff ff ff       	call   80067b <printnum>
  8006da:	83 c4 20             	add    $0x20,%esp
  8006dd:	eb 1a                	jmp    8006f9 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006df:	83 ec 08             	sub    $0x8,%esp
  8006e2:	ff 75 0c             	pushl  0xc(%ebp)
  8006e5:	ff 75 20             	pushl  0x20(%ebp)
  8006e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006eb:	ff d0                	call   *%eax
  8006ed:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006f0:	ff 4d 1c             	decl   0x1c(%ebp)
  8006f3:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006f7:	7f e6                	jg     8006df <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006f9:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006fc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800701:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800704:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800707:	53                   	push   %ebx
  800708:	51                   	push   %ecx
  800709:	52                   	push   %edx
  80070a:	50                   	push   %eax
  80070b:	e8 74 2a 00 00       	call   803184 <__umoddi3>
  800710:	83 c4 10             	add    $0x10,%esp
  800713:	05 f4 37 80 00       	add    $0x8037f4,%eax
  800718:	8a 00                	mov    (%eax),%al
  80071a:	0f be c0             	movsbl %al,%eax
  80071d:	83 ec 08             	sub    $0x8,%esp
  800720:	ff 75 0c             	pushl  0xc(%ebp)
  800723:	50                   	push   %eax
  800724:	8b 45 08             	mov    0x8(%ebp),%eax
  800727:	ff d0                	call   *%eax
  800729:	83 c4 10             	add    $0x10,%esp
}
  80072c:	90                   	nop
  80072d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800730:	c9                   	leave  
  800731:	c3                   	ret    

00800732 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800732:	55                   	push   %ebp
  800733:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800735:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800739:	7e 1c                	jle    800757 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80073b:	8b 45 08             	mov    0x8(%ebp),%eax
  80073e:	8b 00                	mov    (%eax),%eax
  800740:	8d 50 08             	lea    0x8(%eax),%edx
  800743:	8b 45 08             	mov    0x8(%ebp),%eax
  800746:	89 10                	mov    %edx,(%eax)
  800748:	8b 45 08             	mov    0x8(%ebp),%eax
  80074b:	8b 00                	mov    (%eax),%eax
  80074d:	83 e8 08             	sub    $0x8,%eax
  800750:	8b 50 04             	mov    0x4(%eax),%edx
  800753:	8b 00                	mov    (%eax),%eax
  800755:	eb 40                	jmp    800797 <getuint+0x65>
	else if (lflag)
  800757:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80075b:	74 1e                	je     80077b <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80075d:	8b 45 08             	mov    0x8(%ebp),%eax
  800760:	8b 00                	mov    (%eax),%eax
  800762:	8d 50 04             	lea    0x4(%eax),%edx
  800765:	8b 45 08             	mov    0x8(%ebp),%eax
  800768:	89 10                	mov    %edx,(%eax)
  80076a:	8b 45 08             	mov    0x8(%ebp),%eax
  80076d:	8b 00                	mov    (%eax),%eax
  80076f:	83 e8 04             	sub    $0x4,%eax
  800772:	8b 00                	mov    (%eax),%eax
  800774:	ba 00 00 00 00       	mov    $0x0,%edx
  800779:	eb 1c                	jmp    800797 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80077b:	8b 45 08             	mov    0x8(%ebp),%eax
  80077e:	8b 00                	mov    (%eax),%eax
  800780:	8d 50 04             	lea    0x4(%eax),%edx
  800783:	8b 45 08             	mov    0x8(%ebp),%eax
  800786:	89 10                	mov    %edx,(%eax)
  800788:	8b 45 08             	mov    0x8(%ebp),%eax
  80078b:	8b 00                	mov    (%eax),%eax
  80078d:	83 e8 04             	sub    $0x4,%eax
  800790:	8b 00                	mov    (%eax),%eax
  800792:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800797:	5d                   	pop    %ebp
  800798:	c3                   	ret    

00800799 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800799:	55                   	push   %ebp
  80079a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80079c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007a0:	7e 1c                	jle    8007be <getint+0x25>
		return va_arg(*ap, long long);
  8007a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a5:	8b 00                	mov    (%eax),%eax
  8007a7:	8d 50 08             	lea    0x8(%eax),%edx
  8007aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ad:	89 10                	mov    %edx,(%eax)
  8007af:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b2:	8b 00                	mov    (%eax),%eax
  8007b4:	83 e8 08             	sub    $0x8,%eax
  8007b7:	8b 50 04             	mov    0x4(%eax),%edx
  8007ba:	8b 00                	mov    (%eax),%eax
  8007bc:	eb 38                	jmp    8007f6 <getint+0x5d>
	else if (lflag)
  8007be:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007c2:	74 1a                	je     8007de <getint+0x45>
		return va_arg(*ap, long);
  8007c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c7:	8b 00                	mov    (%eax),%eax
  8007c9:	8d 50 04             	lea    0x4(%eax),%edx
  8007cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cf:	89 10                	mov    %edx,(%eax)
  8007d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d4:	8b 00                	mov    (%eax),%eax
  8007d6:	83 e8 04             	sub    $0x4,%eax
  8007d9:	8b 00                	mov    (%eax),%eax
  8007db:	99                   	cltd   
  8007dc:	eb 18                	jmp    8007f6 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007de:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e1:	8b 00                	mov    (%eax),%eax
  8007e3:	8d 50 04             	lea    0x4(%eax),%edx
  8007e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e9:	89 10                	mov    %edx,(%eax)
  8007eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ee:	8b 00                	mov    (%eax),%eax
  8007f0:	83 e8 04             	sub    $0x4,%eax
  8007f3:	8b 00                	mov    (%eax),%eax
  8007f5:	99                   	cltd   
}
  8007f6:	5d                   	pop    %ebp
  8007f7:	c3                   	ret    

008007f8 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007f8:	55                   	push   %ebp
  8007f9:	89 e5                	mov    %esp,%ebp
  8007fb:	56                   	push   %esi
  8007fc:	53                   	push   %ebx
  8007fd:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800800:	eb 17                	jmp    800819 <vprintfmt+0x21>
			if (ch == '\0')
  800802:	85 db                	test   %ebx,%ebx
  800804:	0f 84 af 03 00 00    	je     800bb9 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80080a:	83 ec 08             	sub    $0x8,%esp
  80080d:	ff 75 0c             	pushl  0xc(%ebp)
  800810:	53                   	push   %ebx
  800811:	8b 45 08             	mov    0x8(%ebp),%eax
  800814:	ff d0                	call   *%eax
  800816:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800819:	8b 45 10             	mov    0x10(%ebp),%eax
  80081c:	8d 50 01             	lea    0x1(%eax),%edx
  80081f:	89 55 10             	mov    %edx,0x10(%ebp)
  800822:	8a 00                	mov    (%eax),%al
  800824:	0f b6 d8             	movzbl %al,%ebx
  800827:	83 fb 25             	cmp    $0x25,%ebx
  80082a:	75 d6                	jne    800802 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80082c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800830:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800837:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80083e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800845:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80084c:	8b 45 10             	mov    0x10(%ebp),%eax
  80084f:	8d 50 01             	lea    0x1(%eax),%edx
  800852:	89 55 10             	mov    %edx,0x10(%ebp)
  800855:	8a 00                	mov    (%eax),%al
  800857:	0f b6 d8             	movzbl %al,%ebx
  80085a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80085d:	83 f8 55             	cmp    $0x55,%eax
  800860:	0f 87 2b 03 00 00    	ja     800b91 <vprintfmt+0x399>
  800866:	8b 04 85 18 38 80 00 	mov    0x803818(,%eax,4),%eax
  80086d:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80086f:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800873:	eb d7                	jmp    80084c <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800875:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800879:	eb d1                	jmp    80084c <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80087b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800882:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800885:	89 d0                	mov    %edx,%eax
  800887:	c1 e0 02             	shl    $0x2,%eax
  80088a:	01 d0                	add    %edx,%eax
  80088c:	01 c0                	add    %eax,%eax
  80088e:	01 d8                	add    %ebx,%eax
  800890:	83 e8 30             	sub    $0x30,%eax
  800893:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800896:	8b 45 10             	mov    0x10(%ebp),%eax
  800899:	8a 00                	mov    (%eax),%al
  80089b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80089e:	83 fb 2f             	cmp    $0x2f,%ebx
  8008a1:	7e 3e                	jle    8008e1 <vprintfmt+0xe9>
  8008a3:	83 fb 39             	cmp    $0x39,%ebx
  8008a6:	7f 39                	jg     8008e1 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008a8:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008ab:	eb d5                	jmp    800882 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b0:	83 c0 04             	add    $0x4,%eax
  8008b3:	89 45 14             	mov    %eax,0x14(%ebp)
  8008b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b9:	83 e8 04             	sub    $0x4,%eax
  8008bc:	8b 00                	mov    (%eax),%eax
  8008be:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008c1:	eb 1f                	jmp    8008e2 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008c3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008c7:	79 83                	jns    80084c <vprintfmt+0x54>
				width = 0;
  8008c9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008d0:	e9 77 ff ff ff       	jmp    80084c <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008d5:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008dc:	e9 6b ff ff ff       	jmp    80084c <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008e1:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008e2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008e6:	0f 89 60 ff ff ff    	jns    80084c <vprintfmt+0x54>
				width = precision, precision = -1;
  8008ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008ef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008f2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008f9:	e9 4e ff ff ff       	jmp    80084c <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008fe:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800901:	e9 46 ff ff ff       	jmp    80084c <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800906:	8b 45 14             	mov    0x14(%ebp),%eax
  800909:	83 c0 04             	add    $0x4,%eax
  80090c:	89 45 14             	mov    %eax,0x14(%ebp)
  80090f:	8b 45 14             	mov    0x14(%ebp),%eax
  800912:	83 e8 04             	sub    $0x4,%eax
  800915:	8b 00                	mov    (%eax),%eax
  800917:	83 ec 08             	sub    $0x8,%esp
  80091a:	ff 75 0c             	pushl  0xc(%ebp)
  80091d:	50                   	push   %eax
  80091e:	8b 45 08             	mov    0x8(%ebp),%eax
  800921:	ff d0                	call   *%eax
  800923:	83 c4 10             	add    $0x10,%esp
			break;
  800926:	e9 89 02 00 00       	jmp    800bb4 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80092b:	8b 45 14             	mov    0x14(%ebp),%eax
  80092e:	83 c0 04             	add    $0x4,%eax
  800931:	89 45 14             	mov    %eax,0x14(%ebp)
  800934:	8b 45 14             	mov    0x14(%ebp),%eax
  800937:	83 e8 04             	sub    $0x4,%eax
  80093a:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80093c:	85 db                	test   %ebx,%ebx
  80093e:	79 02                	jns    800942 <vprintfmt+0x14a>
				err = -err;
  800940:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800942:	83 fb 64             	cmp    $0x64,%ebx
  800945:	7f 0b                	jg     800952 <vprintfmt+0x15a>
  800947:	8b 34 9d 60 36 80 00 	mov    0x803660(,%ebx,4),%esi
  80094e:	85 f6                	test   %esi,%esi
  800950:	75 19                	jne    80096b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800952:	53                   	push   %ebx
  800953:	68 05 38 80 00       	push   $0x803805
  800958:	ff 75 0c             	pushl  0xc(%ebp)
  80095b:	ff 75 08             	pushl  0x8(%ebp)
  80095e:	e8 5e 02 00 00       	call   800bc1 <printfmt>
  800963:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800966:	e9 49 02 00 00       	jmp    800bb4 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80096b:	56                   	push   %esi
  80096c:	68 0e 38 80 00       	push   $0x80380e
  800971:	ff 75 0c             	pushl  0xc(%ebp)
  800974:	ff 75 08             	pushl  0x8(%ebp)
  800977:	e8 45 02 00 00       	call   800bc1 <printfmt>
  80097c:	83 c4 10             	add    $0x10,%esp
			break;
  80097f:	e9 30 02 00 00       	jmp    800bb4 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800984:	8b 45 14             	mov    0x14(%ebp),%eax
  800987:	83 c0 04             	add    $0x4,%eax
  80098a:	89 45 14             	mov    %eax,0x14(%ebp)
  80098d:	8b 45 14             	mov    0x14(%ebp),%eax
  800990:	83 e8 04             	sub    $0x4,%eax
  800993:	8b 30                	mov    (%eax),%esi
  800995:	85 f6                	test   %esi,%esi
  800997:	75 05                	jne    80099e <vprintfmt+0x1a6>
				p = "(null)";
  800999:	be 11 38 80 00       	mov    $0x803811,%esi
			if (width > 0 && padc != '-')
  80099e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009a2:	7e 6d                	jle    800a11 <vprintfmt+0x219>
  8009a4:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8009a8:	74 67                	je     800a11 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009ad:	83 ec 08             	sub    $0x8,%esp
  8009b0:	50                   	push   %eax
  8009b1:	56                   	push   %esi
  8009b2:	e8 0c 03 00 00       	call   800cc3 <strnlen>
  8009b7:	83 c4 10             	add    $0x10,%esp
  8009ba:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009bd:	eb 16                	jmp    8009d5 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009bf:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009c3:	83 ec 08             	sub    $0x8,%esp
  8009c6:	ff 75 0c             	pushl  0xc(%ebp)
  8009c9:	50                   	push   %eax
  8009ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cd:	ff d0                	call   *%eax
  8009cf:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009d2:	ff 4d e4             	decl   -0x1c(%ebp)
  8009d5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009d9:	7f e4                	jg     8009bf <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009db:	eb 34                	jmp    800a11 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009dd:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009e1:	74 1c                	je     8009ff <vprintfmt+0x207>
  8009e3:	83 fb 1f             	cmp    $0x1f,%ebx
  8009e6:	7e 05                	jle    8009ed <vprintfmt+0x1f5>
  8009e8:	83 fb 7e             	cmp    $0x7e,%ebx
  8009eb:	7e 12                	jle    8009ff <vprintfmt+0x207>
					putch('?', putdat);
  8009ed:	83 ec 08             	sub    $0x8,%esp
  8009f0:	ff 75 0c             	pushl  0xc(%ebp)
  8009f3:	6a 3f                	push   $0x3f
  8009f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f8:	ff d0                	call   *%eax
  8009fa:	83 c4 10             	add    $0x10,%esp
  8009fd:	eb 0f                	jmp    800a0e <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009ff:	83 ec 08             	sub    $0x8,%esp
  800a02:	ff 75 0c             	pushl  0xc(%ebp)
  800a05:	53                   	push   %ebx
  800a06:	8b 45 08             	mov    0x8(%ebp),%eax
  800a09:	ff d0                	call   *%eax
  800a0b:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a0e:	ff 4d e4             	decl   -0x1c(%ebp)
  800a11:	89 f0                	mov    %esi,%eax
  800a13:	8d 70 01             	lea    0x1(%eax),%esi
  800a16:	8a 00                	mov    (%eax),%al
  800a18:	0f be d8             	movsbl %al,%ebx
  800a1b:	85 db                	test   %ebx,%ebx
  800a1d:	74 24                	je     800a43 <vprintfmt+0x24b>
  800a1f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a23:	78 b8                	js     8009dd <vprintfmt+0x1e5>
  800a25:	ff 4d e0             	decl   -0x20(%ebp)
  800a28:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a2c:	79 af                	jns    8009dd <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a2e:	eb 13                	jmp    800a43 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a30:	83 ec 08             	sub    $0x8,%esp
  800a33:	ff 75 0c             	pushl  0xc(%ebp)
  800a36:	6a 20                	push   $0x20
  800a38:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3b:	ff d0                	call   *%eax
  800a3d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a40:	ff 4d e4             	decl   -0x1c(%ebp)
  800a43:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a47:	7f e7                	jg     800a30 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a49:	e9 66 01 00 00       	jmp    800bb4 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a4e:	83 ec 08             	sub    $0x8,%esp
  800a51:	ff 75 e8             	pushl  -0x18(%ebp)
  800a54:	8d 45 14             	lea    0x14(%ebp),%eax
  800a57:	50                   	push   %eax
  800a58:	e8 3c fd ff ff       	call   800799 <getint>
  800a5d:	83 c4 10             	add    $0x10,%esp
  800a60:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a63:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a69:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a6c:	85 d2                	test   %edx,%edx
  800a6e:	79 23                	jns    800a93 <vprintfmt+0x29b>
				putch('-', putdat);
  800a70:	83 ec 08             	sub    $0x8,%esp
  800a73:	ff 75 0c             	pushl  0xc(%ebp)
  800a76:	6a 2d                	push   $0x2d
  800a78:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7b:	ff d0                	call   *%eax
  800a7d:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a83:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a86:	f7 d8                	neg    %eax
  800a88:	83 d2 00             	adc    $0x0,%edx
  800a8b:	f7 da                	neg    %edx
  800a8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a90:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a93:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a9a:	e9 bc 00 00 00       	jmp    800b5b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a9f:	83 ec 08             	sub    $0x8,%esp
  800aa2:	ff 75 e8             	pushl  -0x18(%ebp)
  800aa5:	8d 45 14             	lea    0x14(%ebp),%eax
  800aa8:	50                   	push   %eax
  800aa9:	e8 84 fc ff ff       	call   800732 <getuint>
  800aae:	83 c4 10             	add    $0x10,%esp
  800ab1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ab4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ab7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800abe:	e9 98 00 00 00       	jmp    800b5b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ac3:	83 ec 08             	sub    $0x8,%esp
  800ac6:	ff 75 0c             	pushl  0xc(%ebp)
  800ac9:	6a 58                	push   $0x58
  800acb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ace:	ff d0                	call   *%eax
  800ad0:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ad3:	83 ec 08             	sub    $0x8,%esp
  800ad6:	ff 75 0c             	pushl  0xc(%ebp)
  800ad9:	6a 58                	push   $0x58
  800adb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ade:	ff d0                	call   *%eax
  800ae0:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ae3:	83 ec 08             	sub    $0x8,%esp
  800ae6:	ff 75 0c             	pushl  0xc(%ebp)
  800ae9:	6a 58                	push   $0x58
  800aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800aee:	ff d0                	call   *%eax
  800af0:	83 c4 10             	add    $0x10,%esp
			break;
  800af3:	e9 bc 00 00 00       	jmp    800bb4 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800af8:	83 ec 08             	sub    $0x8,%esp
  800afb:	ff 75 0c             	pushl  0xc(%ebp)
  800afe:	6a 30                	push   $0x30
  800b00:	8b 45 08             	mov    0x8(%ebp),%eax
  800b03:	ff d0                	call   *%eax
  800b05:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b08:	83 ec 08             	sub    $0x8,%esp
  800b0b:	ff 75 0c             	pushl  0xc(%ebp)
  800b0e:	6a 78                	push   $0x78
  800b10:	8b 45 08             	mov    0x8(%ebp),%eax
  800b13:	ff d0                	call   *%eax
  800b15:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b18:	8b 45 14             	mov    0x14(%ebp),%eax
  800b1b:	83 c0 04             	add    $0x4,%eax
  800b1e:	89 45 14             	mov    %eax,0x14(%ebp)
  800b21:	8b 45 14             	mov    0x14(%ebp),%eax
  800b24:	83 e8 04             	sub    $0x4,%eax
  800b27:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b29:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b2c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b33:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b3a:	eb 1f                	jmp    800b5b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b3c:	83 ec 08             	sub    $0x8,%esp
  800b3f:	ff 75 e8             	pushl  -0x18(%ebp)
  800b42:	8d 45 14             	lea    0x14(%ebp),%eax
  800b45:	50                   	push   %eax
  800b46:	e8 e7 fb ff ff       	call   800732 <getuint>
  800b4b:	83 c4 10             	add    $0x10,%esp
  800b4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b51:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b54:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b5b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b62:	83 ec 04             	sub    $0x4,%esp
  800b65:	52                   	push   %edx
  800b66:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b69:	50                   	push   %eax
  800b6a:	ff 75 f4             	pushl  -0xc(%ebp)
  800b6d:	ff 75 f0             	pushl  -0x10(%ebp)
  800b70:	ff 75 0c             	pushl  0xc(%ebp)
  800b73:	ff 75 08             	pushl  0x8(%ebp)
  800b76:	e8 00 fb ff ff       	call   80067b <printnum>
  800b7b:	83 c4 20             	add    $0x20,%esp
			break;
  800b7e:	eb 34                	jmp    800bb4 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b80:	83 ec 08             	sub    $0x8,%esp
  800b83:	ff 75 0c             	pushl  0xc(%ebp)
  800b86:	53                   	push   %ebx
  800b87:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8a:	ff d0                	call   *%eax
  800b8c:	83 c4 10             	add    $0x10,%esp
			break;
  800b8f:	eb 23                	jmp    800bb4 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b91:	83 ec 08             	sub    $0x8,%esp
  800b94:	ff 75 0c             	pushl  0xc(%ebp)
  800b97:	6a 25                	push   $0x25
  800b99:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9c:	ff d0                	call   *%eax
  800b9e:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ba1:	ff 4d 10             	decl   0x10(%ebp)
  800ba4:	eb 03                	jmp    800ba9 <vprintfmt+0x3b1>
  800ba6:	ff 4d 10             	decl   0x10(%ebp)
  800ba9:	8b 45 10             	mov    0x10(%ebp),%eax
  800bac:	48                   	dec    %eax
  800bad:	8a 00                	mov    (%eax),%al
  800baf:	3c 25                	cmp    $0x25,%al
  800bb1:	75 f3                	jne    800ba6 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800bb3:	90                   	nop
		}
	}
  800bb4:	e9 47 fc ff ff       	jmp    800800 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bb9:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800bba:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bbd:	5b                   	pop    %ebx
  800bbe:	5e                   	pop    %esi
  800bbf:	5d                   	pop    %ebp
  800bc0:	c3                   	ret    

00800bc1 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bc1:	55                   	push   %ebp
  800bc2:	89 e5                	mov    %esp,%ebp
  800bc4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bc7:	8d 45 10             	lea    0x10(%ebp),%eax
  800bca:	83 c0 04             	add    $0x4,%eax
  800bcd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800bd0:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd3:	ff 75 f4             	pushl  -0xc(%ebp)
  800bd6:	50                   	push   %eax
  800bd7:	ff 75 0c             	pushl  0xc(%ebp)
  800bda:	ff 75 08             	pushl  0x8(%ebp)
  800bdd:	e8 16 fc ff ff       	call   8007f8 <vprintfmt>
  800be2:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800be5:	90                   	nop
  800be6:	c9                   	leave  
  800be7:	c3                   	ret    

00800be8 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800be8:	55                   	push   %ebp
  800be9:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800beb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bee:	8b 40 08             	mov    0x8(%eax),%eax
  800bf1:	8d 50 01             	lea    0x1(%eax),%edx
  800bf4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf7:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800bfa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bfd:	8b 10                	mov    (%eax),%edx
  800bff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c02:	8b 40 04             	mov    0x4(%eax),%eax
  800c05:	39 c2                	cmp    %eax,%edx
  800c07:	73 12                	jae    800c1b <sprintputch+0x33>
		*b->buf++ = ch;
  800c09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c0c:	8b 00                	mov    (%eax),%eax
  800c0e:	8d 48 01             	lea    0x1(%eax),%ecx
  800c11:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c14:	89 0a                	mov    %ecx,(%edx)
  800c16:	8b 55 08             	mov    0x8(%ebp),%edx
  800c19:	88 10                	mov    %dl,(%eax)
}
  800c1b:	90                   	nop
  800c1c:	5d                   	pop    %ebp
  800c1d:	c3                   	ret    

00800c1e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c1e:	55                   	push   %ebp
  800c1f:	89 e5                	mov    %esp,%ebp
  800c21:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c24:	8b 45 08             	mov    0x8(%ebp),%eax
  800c27:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c30:	8b 45 08             	mov    0x8(%ebp),%eax
  800c33:	01 d0                	add    %edx,%eax
  800c35:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c38:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c3f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c43:	74 06                	je     800c4b <vsnprintf+0x2d>
  800c45:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c49:	7f 07                	jg     800c52 <vsnprintf+0x34>
		return -E_INVAL;
  800c4b:	b8 03 00 00 00       	mov    $0x3,%eax
  800c50:	eb 20                	jmp    800c72 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c52:	ff 75 14             	pushl  0x14(%ebp)
  800c55:	ff 75 10             	pushl  0x10(%ebp)
  800c58:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c5b:	50                   	push   %eax
  800c5c:	68 e8 0b 80 00       	push   $0x800be8
  800c61:	e8 92 fb ff ff       	call   8007f8 <vprintfmt>
  800c66:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c69:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c6c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c72:	c9                   	leave  
  800c73:	c3                   	ret    

00800c74 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c74:	55                   	push   %ebp
  800c75:	89 e5                	mov    %esp,%ebp
  800c77:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c7a:	8d 45 10             	lea    0x10(%ebp),%eax
  800c7d:	83 c0 04             	add    $0x4,%eax
  800c80:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c83:	8b 45 10             	mov    0x10(%ebp),%eax
  800c86:	ff 75 f4             	pushl  -0xc(%ebp)
  800c89:	50                   	push   %eax
  800c8a:	ff 75 0c             	pushl  0xc(%ebp)
  800c8d:	ff 75 08             	pushl  0x8(%ebp)
  800c90:	e8 89 ff ff ff       	call   800c1e <vsnprintf>
  800c95:	83 c4 10             	add    $0x10,%esp
  800c98:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c9e:	c9                   	leave  
  800c9f:	c3                   	ret    

00800ca0 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ca0:	55                   	push   %ebp
  800ca1:	89 e5                	mov    %esp,%ebp
  800ca3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ca6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cad:	eb 06                	jmp    800cb5 <strlen+0x15>
		n++;
  800caf:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cb2:	ff 45 08             	incl   0x8(%ebp)
  800cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb8:	8a 00                	mov    (%eax),%al
  800cba:	84 c0                	test   %al,%al
  800cbc:	75 f1                	jne    800caf <strlen+0xf>
		n++;
	return n;
  800cbe:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cc1:	c9                   	leave  
  800cc2:	c3                   	ret    

00800cc3 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800cc3:	55                   	push   %ebp
  800cc4:	89 e5                	mov    %esp,%ebp
  800cc6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cc9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cd0:	eb 09                	jmp    800cdb <strnlen+0x18>
		n++;
  800cd2:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cd5:	ff 45 08             	incl   0x8(%ebp)
  800cd8:	ff 4d 0c             	decl   0xc(%ebp)
  800cdb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cdf:	74 09                	je     800cea <strnlen+0x27>
  800ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce4:	8a 00                	mov    (%eax),%al
  800ce6:	84 c0                	test   %al,%al
  800ce8:	75 e8                	jne    800cd2 <strnlen+0xf>
		n++;
	return n;
  800cea:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ced:	c9                   	leave  
  800cee:	c3                   	ret    

00800cef <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cef:	55                   	push   %ebp
  800cf0:	89 e5                	mov    %esp,%ebp
  800cf2:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cfb:	90                   	nop
  800cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cff:	8d 50 01             	lea    0x1(%eax),%edx
  800d02:	89 55 08             	mov    %edx,0x8(%ebp)
  800d05:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d08:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d0b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d0e:	8a 12                	mov    (%edx),%dl
  800d10:	88 10                	mov    %dl,(%eax)
  800d12:	8a 00                	mov    (%eax),%al
  800d14:	84 c0                	test   %al,%al
  800d16:	75 e4                	jne    800cfc <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d18:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d1b:	c9                   	leave  
  800d1c:	c3                   	ret    

00800d1d <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d1d:	55                   	push   %ebp
  800d1e:	89 e5                	mov    %esp,%ebp
  800d20:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d23:	8b 45 08             	mov    0x8(%ebp),%eax
  800d26:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d29:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d30:	eb 1f                	jmp    800d51 <strncpy+0x34>
		*dst++ = *src;
  800d32:	8b 45 08             	mov    0x8(%ebp),%eax
  800d35:	8d 50 01             	lea    0x1(%eax),%edx
  800d38:	89 55 08             	mov    %edx,0x8(%ebp)
  800d3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d3e:	8a 12                	mov    (%edx),%dl
  800d40:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d45:	8a 00                	mov    (%eax),%al
  800d47:	84 c0                	test   %al,%al
  800d49:	74 03                	je     800d4e <strncpy+0x31>
			src++;
  800d4b:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d4e:	ff 45 fc             	incl   -0x4(%ebp)
  800d51:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d54:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d57:	72 d9                	jb     800d32 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d59:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d5c:	c9                   	leave  
  800d5d:	c3                   	ret    

00800d5e <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d5e:	55                   	push   %ebp
  800d5f:	89 e5                	mov    %esp,%ebp
  800d61:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d64:	8b 45 08             	mov    0x8(%ebp),%eax
  800d67:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d6a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d6e:	74 30                	je     800da0 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d70:	eb 16                	jmp    800d88 <strlcpy+0x2a>
			*dst++ = *src++;
  800d72:	8b 45 08             	mov    0x8(%ebp),%eax
  800d75:	8d 50 01             	lea    0x1(%eax),%edx
  800d78:	89 55 08             	mov    %edx,0x8(%ebp)
  800d7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d7e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d81:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d84:	8a 12                	mov    (%edx),%dl
  800d86:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d88:	ff 4d 10             	decl   0x10(%ebp)
  800d8b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d8f:	74 09                	je     800d9a <strlcpy+0x3c>
  800d91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d94:	8a 00                	mov    (%eax),%al
  800d96:	84 c0                	test   %al,%al
  800d98:	75 d8                	jne    800d72 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800da0:	8b 55 08             	mov    0x8(%ebp),%edx
  800da3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800da6:	29 c2                	sub    %eax,%edx
  800da8:	89 d0                	mov    %edx,%eax
}
  800daa:	c9                   	leave  
  800dab:	c3                   	ret    

00800dac <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800dac:	55                   	push   %ebp
  800dad:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800daf:	eb 06                	jmp    800db7 <strcmp+0xb>
		p++, q++;
  800db1:	ff 45 08             	incl   0x8(%ebp)
  800db4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800db7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dba:	8a 00                	mov    (%eax),%al
  800dbc:	84 c0                	test   %al,%al
  800dbe:	74 0e                	je     800dce <strcmp+0x22>
  800dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc3:	8a 10                	mov    (%eax),%dl
  800dc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc8:	8a 00                	mov    (%eax),%al
  800dca:	38 c2                	cmp    %al,%dl
  800dcc:	74 e3                	je     800db1 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800dce:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd1:	8a 00                	mov    (%eax),%al
  800dd3:	0f b6 d0             	movzbl %al,%edx
  800dd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd9:	8a 00                	mov    (%eax),%al
  800ddb:	0f b6 c0             	movzbl %al,%eax
  800dde:	29 c2                	sub    %eax,%edx
  800de0:	89 d0                	mov    %edx,%eax
}
  800de2:	5d                   	pop    %ebp
  800de3:	c3                   	ret    

00800de4 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800de4:	55                   	push   %ebp
  800de5:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800de7:	eb 09                	jmp    800df2 <strncmp+0xe>
		n--, p++, q++;
  800de9:	ff 4d 10             	decl   0x10(%ebp)
  800dec:	ff 45 08             	incl   0x8(%ebp)
  800def:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800df2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800df6:	74 17                	je     800e0f <strncmp+0x2b>
  800df8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfb:	8a 00                	mov    (%eax),%al
  800dfd:	84 c0                	test   %al,%al
  800dff:	74 0e                	je     800e0f <strncmp+0x2b>
  800e01:	8b 45 08             	mov    0x8(%ebp),%eax
  800e04:	8a 10                	mov    (%eax),%dl
  800e06:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e09:	8a 00                	mov    (%eax),%al
  800e0b:	38 c2                	cmp    %al,%dl
  800e0d:	74 da                	je     800de9 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e0f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e13:	75 07                	jne    800e1c <strncmp+0x38>
		return 0;
  800e15:	b8 00 00 00 00       	mov    $0x0,%eax
  800e1a:	eb 14                	jmp    800e30 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1f:	8a 00                	mov    (%eax),%al
  800e21:	0f b6 d0             	movzbl %al,%edx
  800e24:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e27:	8a 00                	mov    (%eax),%al
  800e29:	0f b6 c0             	movzbl %al,%eax
  800e2c:	29 c2                	sub    %eax,%edx
  800e2e:	89 d0                	mov    %edx,%eax
}
  800e30:	5d                   	pop    %ebp
  800e31:	c3                   	ret    

00800e32 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e32:	55                   	push   %ebp
  800e33:	89 e5                	mov    %esp,%ebp
  800e35:	83 ec 04             	sub    $0x4,%esp
  800e38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e3e:	eb 12                	jmp    800e52 <strchr+0x20>
		if (*s == c)
  800e40:	8b 45 08             	mov    0x8(%ebp),%eax
  800e43:	8a 00                	mov    (%eax),%al
  800e45:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e48:	75 05                	jne    800e4f <strchr+0x1d>
			return (char *) s;
  800e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4d:	eb 11                	jmp    800e60 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e4f:	ff 45 08             	incl   0x8(%ebp)
  800e52:	8b 45 08             	mov    0x8(%ebp),%eax
  800e55:	8a 00                	mov    (%eax),%al
  800e57:	84 c0                	test   %al,%al
  800e59:	75 e5                	jne    800e40 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e5b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e60:	c9                   	leave  
  800e61:	c3                   	ret    

00800e62 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e62:	55                   	push   %ebp
  800e63:	89 e5                	mov    %esp,%ebp
  800e65:	83 ec 04             	sub    $0x4,%esp
  800e68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e6e:	eb 0d                	jmp    800e7d <strfind+0x1b>
		if (*s == c)
  800e70:	8b 45 08             	mov    0x8(%ebp),%eax
  800e73:	8a 00                	mov    (%eax),%al
  800e75:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e78:	74 0e                	je     800e88 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e7a:	ff 45 08             	incl   0x8(%ebp)
  800e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e80:	8a 00                	mov    (%eax),%al
  800e82:	84 c0                	test   %al,%al
  800e84:	75 ea                	jne    800e70 <strfind+0xe>
  800e86:	eb 01                	jmp    800e89 <strfind+0x27>
		if (*s == c)
			break;
  800e88:	90                   	nop
	return (char *) s;
  800e89:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e8c:	c9                   	leave  
  800e8d:	c3                   	ret    

00800e8e <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e8e:	55                   	push   %ebp
  800e8f:	89 e5                	mov    %esp,%ebp
  800e91:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e94:	8b 45 08             	mov    0x8(%ebp),%eax
  800e97:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e9a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e9d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800ea0:	eb 0e                	jmp    800eb0 <memset+0x22>
		*p++ = c;
  800ea2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea5:	8d 50 01             	lea    0x1(%eax),%edx
  800ea8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800eab:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eae:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800eb0:	ff 4d f8             	decl   -0x8(%ebp)
  800eb3:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800eb7:	79 e9                	jns    800ea2 <memset+0x14>
		*p++ = c;

	return v;
  800eb9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ebc:	c9                   	leave  
  800ebd:	c3                   	ret    

00800ebe <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ebe:	55                   	push   %ebp
  800ebf:	89 e5                	mov    %esp,%ebp
  800ec1:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ec4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800eca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800ed0:	eb 16                	jmp    800ee8 <memcpy+0x2a>
		*d++ = *s++;
  800ed2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ed5:	8d 50 01             	lea    0x1(%eax),%edx
  800ed8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800edb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ede:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ee1:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ee4:	8a 12                	mov    (%edx),%dl
  800ee6:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800ee8:	8b 45 10             	mov    0x10(%ebp),%eax
  800eeb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eee:	89 55 10             	mov    %edx,0x10(%ebp)
  800ef1:	85 c0                	test   %eax,%eax
  800ef3:	75 dd                	jne    800ed2 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800ef5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ef8:	c9                   	leave  
  800ef9:	c3                   	ret    

00800efa <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800efa:	55                   	push   %ebp
  800efb:	89 e5                	mov    %esp,%ebp
  800efd:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f03:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f06:	8b 45 08             	mov    0x8(%ebp),%eax
  800f09:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f0f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f12:	73 50                	jae    800f64 <memmove+0x6a>
  800f14:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f17:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1a:	01 d0                	add    %edx,%eax
  800f1c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f1f:	76 43                	jbe    800f64 <memmove+0x6a>
		s += n;
  800f21:	8b 45 10             	mov    0x10(%ebp),%eax
  800f24:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f27:	8b 45 10             	mov    0x10(%ebp),%eax
  800f2a:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f2d:	eb 10                	jmp    800f3f <memmove+0x45>
			*--d = *--s;
  800f2f:	ff 4d f8             	decl   -0x8(%ebp)
  800f32:	ff 4d fc             	decl   -0x4(%ebp)
  800f35:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f38:	8a 10                	mov    (%eax),%dl
  800f3a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f3d:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f3f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f42:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f45:	89 55 10             	mov    %edx,0x10(%ebp)
  800f48:	85 c0                	test   %eax,%eax
  800f4a:	75 e3                	jne    800f2f <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f4c:	eb 23                	jmp    800f71 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f4e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f51:	8d 50 01             	lea    0x1(%eax),%edx
  800f54:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f57:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f5a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f5d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f60:	8a 12                	mov    (%edx),%dl
  800f62:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f64:	8b 45 10             	mov    0x10(%ebp),%eax
  800f67:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f6a:	89 55 10             	mov    %edx,0x10(%ebp)
  800f6d:	85 c0                	test   %eax,%eax
  800f6f:	75 dd                	jne    800f4e <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f71:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f74:	c9                   	leave  
  800f75:	c3                   	ret    

00800f76 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f76:	55                   	push   %ebp
  800f77:	89 e5                	mov    %esp,%ebp
  800f79:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f85:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f88:	eb 2a                	jmp    800fb4 <memcmp+0x3e>
		if (*s1 != *s2)
  800f8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f8d:	8a 10                	mov    (%eax),%dl
  800f8f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f92:	8a 00                	mov    (%eax),%al
  800f94:	38 c2                	cmp    %al,%dl
  800f96:	74 16                	je     800fae <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f98:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f9b:	8a 00                	mov    (%eax),%al
  800f9d:	0f b6 d0             	movzbl %al,%edx
  800fa0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fa3:	8a 00                	mov    (%eax),%al
  800fa5:	0f b6 c0             	movzbl %al,%eax
  800fa8:	29 c2                	sub    %eax,%edx
  800faa:	89 d0                	mov    %edx,%eax
  800fac:	eb 18                	jmp    800fc6 <memcmp+0x50>
		s1++, s2++;
  800fae:	ff 45 fc             	incl   -0x4(%ebp)
  800fb1:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800fb4:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fba:	89 55 10             	mov    %edx,0x10(%ebp)
  800fbd:	85 c0                	test   %eax,%eax
  800fbf:	75 c9                	jne    800f8a <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800fc1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fc6:	c9                   	leave  
  800fc7:	c3                   	ret    

00800fc8 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800fc8:	55                   	push   %ebp
  800fc9:	89 e5                	mov    %esp,%ebp
  800fcb:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800fce:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd4:	01 d0                	add    %edx,%eax
  800fd6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800fd9:	eb 15                	jmp    800ff0 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fde:	8a 00                	mov    (%eax),%al
  800fe0:	0f b6 d0             	movzbl %al,%edx
  800fe3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe6:	0f b6 c0             	movzbl %al,%eax
  800fe9:	39 c2                	cmp    %eax,%edx
  800feb:	74 0d                	je     800ffa <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800fed:	ff 45 08             	incl   0x8(%ebp)
  800ff0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ff6:	72 e3                	jb     800fdb <memfind+0x13>
  800ff8:	eb 01                	jmp    800ffb <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800ffa:	90                   	nop
	return (void *) s;
  800ffb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ffe:	c9                   	leave  
  800fff:	c3                   	ret    

00801000 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801000:	55                   	push   %ebp
  801001:	89 e5                	mov    %esp,%ebp
  801003:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801006:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80100d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801014:	eb 03                	jmp    801019 <strtol+0x19>
		s++;
  801016:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801019:	8b 45 08             	mov    0x8(%ebp),%eax
  80101c:	8a 00                	mov    (%eax),%al
  80101e:	3c 20                	cmp    $0x20,%al
  801020:	74 f4                	je     801016 <strtol+0x16>
  801022:	8b 45 08             	mov    0x8(%ebp),%eax
  801025:	8a 00                	mov    (%eax),%al
  801027:	3c 09                	cmp    $0x9,%al
  801029:	74 eb                	je     801016 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80102b:	8b 45 08             	mov    0x8(%ebp),%eax
  80102e:	8a 00                	mov    (%eax),%al
  801030:	3c 2b                	cmp    $0x2b,%al
  801032:	75 05                	jne    801039 <strtol+0x39>
		s++;
  801034:	ff 45 08             	incl   0x8(%ebp)
  801037:	eb 13                	jmp    80104c <strtol+0x4c>
	else if (*s == '-')
  801039:	8b 45 08             	mov    0x8(%ebp),%eax
  80103c:	8a 00                	mov    (%eax),%al
  80103e:	3c 2d                	cmp    $0x2d,%al
  801040:	75 0a                	jne    80104c <strtol+0x4c>
		s++, neg = 1;
  801042:	ff 45 08             	incl   0x8(%ebp)
  801045:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80104c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801050:	74 06                	je     801058 <strtol+0x58>
  801052:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801056:	75 20                	jne    801078 <strtol+0x78>
  801058:	8b 45 08             	mov    0x8(%ebp),%eax
  80105b:	8a 00                	mov    (%eax),%al
  80105d:	3c 30                	cmp    $0x30,%al
  80105f:	75 17                	jne    801078 <strtol+0x78>
  801061:	8b 45 08             	mov    0x8(%ebp),%eax
  801064:	40                   	inc    %eax
  801065:	8a 00                	mov    (%eax),%al
  801067:	3c 78                	cmp    $0x78,%al
  801069:	75 0d                	jne    801078 <strtol+0x78>
		s += 2, base = 16;
  80106b:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80106f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801076:	eb 28                	jmp    8010a0 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801078:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80107c:	75 15                	jne    801093 <strtol+0x93>
  80107e:	8b 45 08             	mov    0x8(%ebp),%eax
  801081:	8a 00                	mov    (%eax),%al
  801083:	3c 30                	cmp    $0x30,%al
  801085:	75 0c                	jne    801093 <strtol+0x93>
		s++, base = 8;
  801087:	ff 45 08             	incl   0x8(%ebp)
  80108a:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801091:	eb 0d                	jmp    8010a0 <strtol+0xa0>
	else if (base == 0)
  801093:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801097:	75 07                	jne    8010a0 <strtol+0xa0>
		base = 10;
  801099:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a3:	8a 00                	mov    (%eax),%al
  8010a5:	3c 2f                	cmp    $0x2f,%al
  8010a7:	7e 19                	jle    8010c2 <strtol+0xc2>
  8010a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ac:	8a 00                	mov    (%eax),%al
  8010ae:	3c 39                	cmp    $0x39,%al
  8010b0:	7f 10                	jg     8010c2 <strtol+0xc2>
			dig = *s - '0';
  8010b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b5:	8a 00                	mov    (%eax),%al
  8010b7:	0f be c0             	movsbl %al,%eax
  8010ba:	83 e8 30             	sub    $0x30,%eax
  8010bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010c0:	eb 42                	jmp    801104 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8010c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c5:	8a 00                	mov    (%eax),%al
  8010c7:	3c 60                	cmp    $0x60,%al
  8010c9:	7e 19                	jle    8010e4 <strtol+0xe4>
  8010cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ce:	8a 00                	mov    (%eax),%al
  8010d0:	3c 7a                	cmp    $0x7a,%al
  8010d2:	7f 10                	jg     8010e4 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8010d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d7:	8a 00                	mov    (%eax),%al
  8010d9:	0f be c0             	movsbl %al,%eax
  8010dc:	83 e8 57             	sub    $0x57,%eax
  8010df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010e2:	eb 20                	jmp    801104 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e7:	8a 00                	mov    (%eax),%al
  8010e9:	3c 40                	cmp    $0x40,%al
  8010eb:	7e 39                	jle    801126 <strtol+0x126>
  8010ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f0:	8a 00                	mov    (%eax),%al
  8010f2:	3c 5a                	cmp    $0x5a,%al
  8010f4:	7f 30                	jg     801126 <strtol+0x126>
			dig = *s - 'A' + 10;
  8010f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f9:	8a 00                	mov    (%eax),%al
  8010fb:	0f be c0             	movsbl %al,%eax
  8010fe:	83 e8 37             	sub    $0x37,%eax
  801101:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801104:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801107:	3b 45 10             	cmp    0x10(%ebp),%eax
  80110a:	7d 19                	jge    801125 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80110c:	ff 45 08             	incl   0x8(%ebp)
  80110f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801112:	0f af 45 10          	imul   0x10(%ebp),%eax
  801116:	89 c2                	mov    %eax,%edx
  801118:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80111b:	01 d0                	add    %edx,%eax
  80111d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801120:	e9 7b ff ff ff       	jmp    8010a0 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801125:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801126:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80112a:	74 08                	je     801134 <strtol+0x134>
		*endptr = (char *) s;
  80112c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112f:	8b 55 08             	mov    0x8(%ebp),%edx
  801132:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801134:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801138:	74 07                	je     801141 <strtol+0x141>
  80113a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80113d:	f7 d8                	neg    %eax
  80113f:	eb 03                	jmp    801144 <strtol+0x144>
  801141:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801144:	c9                   	leave  
  801145:	c3                   	ret    

00801146 <ltostr>:

void
ltostr(long value, char *str)
{
  801146:	55                   	push   %ebp
  801147:	89 e5                	mov    %esp,%ebp
  801149:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80114c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801153:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80115a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80115e:	79 13                	jns    801173 <ltostr+0x2d>
	{
		neg = 1;
  801160:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801167:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116a:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80116d:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801170:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801173:	8b 45 08             	mov    0x8(%ebp),%eax
  801176:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80117b:	99                   	cltd   
  80117c:	f7 f9                	idiv   %ecx
  80117e:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801181:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801184:	8d 50 01             	lea    0x1(%eax),%edx
  801187:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80118a:	89 c2                	mov    %eax,%edx
  80118c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118f:	01 d0                	add    %edx,%eax
  801191:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801194:	83 c2 30             	add    $0x30,%edx
  801197:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801199:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80119c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011a1:	f7 e9                	imul   %ecx
  8011a3:	c1 fa 02             	sar    $0x2,%edx
  8011a6:	89 c8                	mov    %ecx,%eax
  8011a8:	c1 f8 1f             	sar    $0x1f,%eax
  8011ab:	29 c2                	sub    %eax,%edx
  8011ad:	89 d0                	mov    %edx,%eax
  8011af:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8011b2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011b5:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011ba:	f7 e9                	imul   %ecx
  8011bc:	c1 fa 02             	sar    $0x2,%edx
  8011bf:	89 c8                	mov    %ecx,%eax
  8011c1:	c1 f8 1f             	sar    $0x1f,%eax
  8011c4:	29 c2                	sub    %eax,%edx
  8011c6:	89 d0                	mov    %edx,%eax
  8011c8:	c1 e0 02             	shl    $0x2,%eax
  8011cb:	01 d0                	add    %edx,%eax
  8011cd:	01 c0                	add    %eax,%eax
  8011cf:	29 c1                	sub    %eax,%ecx
  8011d1:	89 ca                	mov    %ecx,%edx
  8011d3:	85 d2                	test   %edx,%edx
  8011d5:	75 9c                	jne    801173 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8011d7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8011de:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e1:	48                   	dec    %eax
  8011e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8011e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011e9:	74 3d                	je     801228 <ltostr+0xe2>
		start = 1 ;
  8011eb:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8011f2:	eb 34                	jmp    801228 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8011f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fa:	01 d0                	add    %edx,%eax
  8011fc:	8a 00                	mov    (%eax),%al
  8011fe:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801201:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801204:	8b 45 0c             	mov    0xc(%ebp),%eax
  801207:	01 c2                	add    %eax,%edx
  801209:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80120c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120f:	01 c8                	add    %ecx,%eax
  801211:	8a 00                	mov    (%eax),%al
  801213:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801215:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801218:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121b:	01 c2                	add    %eax,%edx
  80121d:	8a 45 eb             	mov    -0x15(%ebp),%al
  801220:	88 02                	mov    %al,(%edx)
		start++ ;
  801222:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801225:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801228:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80122b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80122e:	7c c4                	jl     8011f4 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801230:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801233:	8b 45 0c             	mov    0xc(%ebp),%eax
  801236:	01 d0                	add    %edx,%eax
  801238:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80123b:	90                   	nop
  80123c:	c9                   	leave  
  80123d:	c3                   	ret    

0080123e <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80123e:	55                   	push   %ebp
  80123f:	89 e5                	mov    %esp,%ebp
  801241:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801244:	ff 75 08             	pushl  0x8(%ebp)
  801247:	e8 54 fa ff ff       	call   800ca0 <strlen>
  80124c:	83 c4 04             	add    $0x4,%esp
  80124f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801252:	ff 75 0c             	pushl  0xc(%ebp)
  801255:	e8 46 fa ff ff       	call   800ca0 <strlen>
  80125a:	83 c4 04             	add    $0x4,%esp
  80125d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801260:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801267:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80126e:	eb 17                	jmp    801287 <strcconcat+0x49>
		final[s] = str1[s] ;
  801270:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801273:	8b 45 10             	mov    0x10(%ebp),%eax
  801276:	01 c2                	add    %eax,%edx
  801278:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80127b:	8b 45 08             	mov    0x8(%ebp),%eax
  80127e:	01 c8                	add    %ecx,%eax
  801280:	8a 00                	mov    (%eax),%al
  801282:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801284:	ff 45 fc             	incl   -0x4(%ebp)
  801287:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80128a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80128d:	7c e1                	jl     801270 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80128f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801296:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80129d:	eb 1f                	jmp    8012be <strcconcat+0x80>
		final[s++] = str2[i] ;
  80129f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012a2:	8d 50 01             	lea    0x1(%eax),%edx
  8012a5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012a8:	89 c2                	mov    %eax,%edx
  8012aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ad:	01 c2                	add    %eax,%edx
  8012af:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b5:	01 c8                	add    %ecx,%eax
  8012b7:	8a 00                	mov    (%eax),%al
  8012b9:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012bb:	ff 45 f8             	incl   -0x8(%ebp)
  8012be:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012c4:	7c d9                	jl     80129f <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8012c6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8012cc:	01 d0                	add    %edx,%eax
  8012ce:	c6 00 00             	movb   $0x0,(%eax)
}
  8012d1:	90                   	nop
  8012d2:	c9                   	leave  
  8012d3:	c3                   	ret    

008012d4 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8012d4:	55                   	push   %ebp
  8012d5:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8012d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8012da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8012e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8012e3:	8b 00                	mov    (%eax),%eax
  8012e5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ef:	01 d0                	add    %edx,%eax
  8012f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012f7:	eb 0c                	jmp    801305 <strsplit+0x31>
			*string++ = 0;
  8012f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fc:	8d 50 01             	lea    0x1(%eax),%edx
  8012ff:	89 55 08             	mov    %edx,0x8(%ebp)
  801302:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801305:	8b 45 08             	mov    0x8(%ebp),%eax
  801308:	8a 00                	mov    (%eax),%al
  80130a:	84 c0                	test   %al,%al
  80130c:	74 18                	je     801326 <strsplit+0x52>
  80130e:	8b 45 08             	mov    0x8(%ebp),%eax
  801311:	8a 00                	mov    (%eax),%al
  801313:	0f be c0             	movsbl %al,%eax
  801316:	50                   	push   %eax
  801317:	ff 75 0c             	pushl  0xc(%ebp)
  80131a:	e8 13 fb ff ff       	call   800e32 <strchr>
  80131f:	83 c4 08             	add    $0x8,%esp
  801322:	85 c0                	test   %eax,%eax
  801324:	75 d3                	jne    8012f9 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801326:	8b 45 08             	mov    0x8(%ebp),%eax
  801329:	8a 00                	mov    (%eax),%al
  80132b:	84 c0                	test   %al,%al
  80132d:	74 5a                	je     801389 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80132f:	8b 45 14             	mov    0x14(%ebp),%eax
  801332:	8b 00                	mov    (%eax),%eax
  801334:	83 f8 0f             	cmp    $0xf,%eax
  801337:	75 07                	jne    801340 <strsplit+0x6c>
		{
			return 0;
  801339:	b8 00 00 00 00       	mov    $0x0,%eax
  80133e:	eb 66                	jmp    8013a6 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801340:	8b 45 14             	mov    0x14(%ebp),%eax
  801343:	8b 00                	mov    (%eax),%eax
  801345:	8d 48 01             	lea    0x1(%eax),%ecx
  801348:	8b 55 14             	mov    0x14(%ebp),%edx
  80134b:	89 0a                	mov    %ecx,(%edx)
  80134d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801354:	8b 45 10             	mov    0x10(%ebp),%eax
  801357:	01 c2                	add    %eax,%edx
  801359:	8b 45 08             	mov    0x8(%ebp),%eax
  80135c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80135e:	eb 03                	jmp    801363 <strsplit+0x8f>
			string++;
  801360:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801363:	8b 45 08             	mov    0x8(%ebp),%eax
  801366:	8a 00                	mov    (%eax),%al
  801368:	84 c0                	test   %al,%al
  80136a:	74 8b                	je     8012f7 <strsplit+0x23>
  80136c:	8b 45 08             	mov    0x8(%ebp),%eax
  80136f:	8a 00                	mov    (%eax),%al
  801371:	0f be c0             	movsbl %al,%eax
  801374:	50                   	push   %eax
  801375:	ff 75 0c             	pushl  0xc(%ebp)
  801378:	e8 b5 fa ff ff       	call   800e32 <strchr>
  80137d:	83 c4 08             	add    $0x8,%esp
  801380:	85 c0                	test   %eax,%eax
  801382:	74 dc                	je     801360 <strsplit+0x8c>
			string++;
	}
  801384:	e9 6e ff ff ff       	jmp    8012f7 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801389:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80138a:	8b 45 14             	mov    0x14(%ebp),%eax
  80138d:	8b 00                	mov    (%eax),%eax
  80138f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801396:	8b 45 10             	mov    0x10(%ebp),%eax
  801399:	01 d0                	add    %edx,%eax
  80139b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013a1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013a6:	c9                   	leave  
  8013a7:	c3                   	ret    

008013a8 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8013a8:	55                   	push   %ebp
  8013a9:	89 e5                	mov    %esp,%ebp
  8013ab:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8013ae:	a1 04 40 80 00       	mov    0x804004,%eax
  8013b3:	85 c0                	test   %eax,%eax
  8013b5:	74 1f                	je     8013d6 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8013b7:	e8 1d 00 00 00       	call   8013d9 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8013bc:	83 ec 0c             	sub    $0xc,%esp
  8013bf:	68 70 39 80 00       	push   $0x803970
  8013c4:	e8 55 f2 ff ff       	call   80061e <cprintf>
  8013c9:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8013cc:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8013d3:	00 00 00 
	}
}
  8013d6:	90                   	nop
  8013d7:	c9                   	leave  
  8013d8:	c3                   	ret    

008013d9 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8013d9:	55                   	push   %ebp
  8013da:	89 e5                	mov    %esp,%ebp
  8013dc:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  8013df:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  8013e6:	00 00 00 
  8013e9:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  8013f0:	00 00 00 
  8013f3:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  8013fa:	00 00 00 
		LIST_INIT(&AllocMemBlocksList);
  8013fd:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801404:	00 00 00 
  801407:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80140e:	00 00 00 
  801411:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801418:	00 00 00 

		MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES ;
  80141b:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801422:	00 02 00 
		MemBlockNodes =(struct MemBlock*)USER_DYN_BLKS_ARRAY ;
  801425:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  80142c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80142f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801434:	2d 00 10 00 00       	sub    $0x1000,%eax
  801439:	a3 50 40 80 00       	mov    %eax,0x804050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock),PAGE_SIZE),PERM_USER|PERM_WRITEABLE);
  80143e:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801445:	a1 20 41 80 00       	mov    0x804120,%eax
  80144a:	c1 e0 04             	shl    $0x4,%eax
  80144d:	89 c2                	mov    %eax,%edx
  80144f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801452:	01 d0                	add    %edx,%eax
  801454:	48                   	dec    %eax
  801455:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801458:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80145b:	ba 00 00 00 00       	mov    $0x0,%edx
  801460:	f7 75 f0             	divl   -0x10(%ebp)
  801463:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801466:	29 d0                	sub    %edx,%eax
  801468:	89 c2                	mov    %eax,%edx
  80146a:	c7 45 e8 00 00 e0 7f 	movl   $0x7fe00000,-0x18(%ebp)
  801471:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801474:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801479:	2d 00 10 00 00       	sub    $0x1000,%eax
  80147e:	83 ec 04             	sub    $0x4,%esp
  801481:	6a 06                	push   $0x6
  801483:	52                   	push   %edx
  801484:	50                   	push   %eax
  801485:	e8 71 05 00 00       	call   8019fb <sys_allocate_chunk>
  80148a:	83 c4 10             	add    $0x10,%esp
		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80148d:	a1 20 41 80 00       	mov    0x804120,%eax
  801492:	83 ec 0c             	sub    $0xc,%esp
  801495:	50                   	push   %eax
  801496:	e8 e6 0b 00 00       	call   802081 <initialize_MemBlocksList>
  80149b:	83 c4 10             	add    $0x10,%esp

		struct MemBlock  *block_node;
		block_node = AvailableMemBlocksList.lh_first;
  80149e:	a1 48 41 80 00       	mov    0x804148,%eax
  8014a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&(AvailableMemBlocksList),block_node);
  8014a6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8014aa:	75 14                	jne    8014c0 <initialize_dyn_block_system+0xe7>
  8014ac:	83 ec 04             	sub    $0x4,%esp
  8014af:	68 95 39 80 00       	push   $0x803995
  8014b4:	6a 2b                	push   $0x2b
  8014b6:	68 b3 39 80 00       	push   $0x8039b3
  8014bb:	e8 aa ee ff ff       	call   80036a <_panic>
  8014c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014c3:	8b 00                	mov    (%eax),%eax
  8014c5:	85 c0                	test   %eax,%eax
  8014c7:	74 10                	je     8014d9 <initialize_dyn_block_system+0x100>
  8014c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014cc:	8b 00                	mov    (%eax),%eax
  8014ce:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8014d1:	8b 52 04             	mov    0x4(%edx),%edx
  8014d4:	89 50 04             	mov    %edx,0x4(%eax)
  8014d7:	eb 0b                	jmp    8014e4 <initialize_dyn_block_system+0x10b>
  8014d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014dc:	8b 40 04             	mov    0x4(%eax),%eax
  8014df:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8014e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014e7:	8b 40 04             	mov    0x4(%eax),%eax
  8014ea:	85 c0                	test   %eax,%eax
  8014ec:	74 0f                	je     8014fd <initialize_dyn_block_system+0x124>
  8014ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014f1:	8b 40 04             	mov    0x4(%eax),%eax
  8014f4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8014f7:	8b 12                	mov    (%edx),%edx
  8014f9:	89 10                	mov    %edx,(%eax)
  8014fb:	eb 0a                	jmp    801507 <initialize_dyn_block_system+0x12e>
  8014fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801500:	8b 00                	mov    (%eax),%eax
  801502:	a3 48 41 80 00       	mov    %eax,0x804148
  801507:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80150a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801510:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801513:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80151a:	a1 54 41 80 00       	mov    0x804154,%eax
  80151f:	48                   	dec    %eax
  801520:	a3 54 41 80 00       	mov    %eax,0x804154
		block_node->sva = USER_HEAP_START ;
  801525:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801528:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
		block_node->size = ((USER_HEAP_MAX - USER_HEAP_START));
  80152f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801532:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		insert_sorted_with_merge_freeList(block_node);
  801539:	83 ec 0c             	sub    $0xc,%esp
  80153c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80153f:	e8 d2 13 00 00       	call   802916 <insert_sorted_with_merge_freeList>
  801544:	83 c4 10             	add    $0x10,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801547:	90                   	nop
  801548:	c9                   	leave  
  801549:	c3                   	ret    

0080154a <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  80154a:	55                   	push   %ebp
  80154b:	89 e5                	mov    %esp,%ebp
  80154d:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801550:	e8 53 fe ff ff       	call   8013a8 <InitializeUHeap>
	if (size == 0) return NULL ;
  801555:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801559:	75 07                	jne    801562 <malloc+0x18>
  80155b:	b8 00 00 00 00       	mov    $0x0,%eax
  801560:	eb 61                	jmp    8015c3 <malloc+0x79>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	size= ROUNDUP(size,PAGE_SIZE);
  801562:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801569:	8b 55 08             	mov    0x8(%ebp),%edx
  80156c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80156f:	01 d0                	add    %edx,%eax
  801571:	48                   	dec    %eax
  801572:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801575:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801578:	ba 00 00 00 00       	mov    $0x0,%edx
  80157d:	f7 75 f4             	divl   -0xc(%ebp)
  801580:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801583:	29 d0                	sub    %edx,%eax
  801585:	89 45 08             	mov    %eax,0x8(%ebp)
	    			if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801588:	e8 3c 08 00 00       	call   801dc9 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80158d:	85 c0                	test   %eax,%eax
  80158f:	74 2d                	je     8015be <malloc+0x74>
	    			{
	    				struct MemBlock * ff_block = alloc_block_FF(size);
  801591:	83 ec 0c             	sub    $0xc,%esp
  801594:	ff 75 08             	pushl  0x8(%ebp)
  801597:	e8 3e 0f 00 00       	call   8024da <alloc_block_FF>
  80159c:	83 c4 10             	add    $0x10,%esp
  80159f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    				if(ff_block!=NULL)
  8015a2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8015a6:	74 16                	je     8015be <malloc+0x74>
	    				{

	    					insert_sorted_allocList(ff_block);
  8015a8:	83 ec 0c             	sub    $0xc,%esp
  8015ab:	ff 75 ec             	pushl  -0x14(%ebp)
  8015ae:	e8 48 0c 00 00       	call   8021fb <insert_sorted_allocList>
  8015b3:	83 c4 10             	add    $0x10,%esp
	    					return (void*) ff_block->sva ;
  8015b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015b9:	8b 40 08             	mov    0x8(%eax),%eax
  8015bc:	eb 05                	jmp    8015c3 <malloc+0x79>

	    				}
	}
	    			return (void*) NULL ;
  8015be:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  8015c3:	c9                   	leave  
  8015c4:	c3                   	ret    

008015c5 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8015c5:	55                   	push   %ebp
  8015c6:	89 e5                	mov    %esp,%ebp
  8015c8:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock *elementForEach;
		virtual_address = ROUNDDOWN(virtual_address, PAGE_SIZE);
  8015cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8015d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015d4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015d9:	89 45 08             	mov    %eax,0x8(%ebp)
	//	if (is_mallocPages[indexindex((uint32) virtual_address)] == 1) {
		elementForEach = find_block(&AllocMemBlocksList,(uint32)virtual_address);
  8015dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8015df:	83 ec 08             	sub    $0x8,%esp
  8015e2:	50                   	push   %eax
  8015e3:	68 40 40 80 00       	push   $0x804040
  8015e8:	e8 71 0b 00 00       	call   80215e <find_block>
  8015ed:	83 c4 10             	add    $0x10,%esp
  8015f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
		sys_free_user_mem((uint32) virtual_address, elementForEach->size);
  8015f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015f6:	8b 50 0c             	mov    0xc(%eax),%edx
  8015f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fc:	83 ec 08             	sub    $0x8,%esp
  8015ff:	52                   	push   %edx
  801600:	50                   	push   %eax
  801601:	e8 bd 03 00 00       	call   8019c3 <sys_free_user_mem>
  801606:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,elementForEach);
  801609:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80160d:	75 14                	jne    801623 <free+0x5e>
  80160f:	83 ec 04             	sub    $0x4,%esp
  801612:	68 95 39 80 00       	push   $0x803995
  801617:	6a 71                	push   $0x71
  801619:	68 b3 39 80 00       	push   $0x8039b3
  80161e:	e8 47 ed ff ff       	call   80036a <_panic>
  801623:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801626:	8b 00                	mov    (%eax),%eax
  801628:	85 c0                	test   %eax,%eax
  80162a:	74 10                	je     80163c <free+0x77>
  80162c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80162f:	8b 00                	mov    (%eax),%eax
  801631:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801634:	8b 52 04             	mov    0x4(%edx),%edx
  801637:	89 50 04             	mov    %edx,0x4(%eax)
  80163a:	eb 0b                	jmp    801647 <free+0x82>
  80163c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80163f:	8b 40 04             	mov    0x4(%eax),%eax
  801642:	a3 44 40 80 00       	mov    %eax,0x804044
  801647:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80164a:	8b 40 04             	mov    0x4(%eax),%eax
  80164d:	85 c0                	test   %eax,%eax
  80164f:	74 0f                	je     801660 <free+0x9b>
  801651:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801654:	8b 40 04             	mov    0x4(%eax),%eax
  801657:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80165a:	8b 12                	mov    (%edx),%edx
  80165c:	89 10                	mov    %edx,(%eax)
  80165e:	eb 0a                	jmp    80166a <free+0xa5>
  801660:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801663:	8b 00                	mov    (%eax),%eax
  801665:	a3 40 40 80 00       	mov    %eax,0x804040
  80166a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80166d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801673:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801676:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80167d:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801682:	48                   	dec    %eax
  801683:	a3 4c 40 80 00       	mov    %eax,0x80404c
		insert_sorted_with_merge_freeList(elementForEach);
  801688:	83 ec 0c             	sub    $0xc,%esp
  80168b:	ff 75 f0             	pushl  -0x10(%ebp)
  80168e:	e8 83 12 00 00       	call   802916 <insert_sorted_with_merge_freeList>
  801693:	83 c4 10             	add    $0x10,%esp
	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801696:	90                   	nop
  801697:	c9                   	leave  
  801698:	c3                   	ret    

00801699 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801699:	55                   	push   %ebp
  80169a:	89 e5                	mov    %esp,%ebp
  80169c:	83 ec 28             	sub    $0x28,%esp
  80169f:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a2:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016a5:	e8 fe fc ff ff       	call   8013a8 <InitializeUHeap>
	if (size == 0) return NULL ;
  8016aa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016ae:	75 0a                	jne    8016ba <smalloc+0x21>
  8016b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b5:	e9 86 00 00 00       	jmp    801740 <smalloc+0xa7>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code

	size=ROUNDUP(size,PAGE_SIZE);
  8016ba:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8016c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016c7:	01 d0                	add    %edx,%eax
  8016c9:	48                   	dec    %eax
  8016ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8016d5:	f7 75 f4             	divl   -0xc(%ebp)
  8016d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016db:	29 d0                	sub    %edx,%eax
  8016dd:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8016e0:	e8 e4 06 00 00       	call   801dc9 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016e5:	85 c0                	test   %eax,%eax
  8016e7:	74 52                	je     80173b <smalloc+0xa2>
		{
		struct MemBlock * ff_block ;
		ff_block = alloc_block_FF(size);
  8016e9:	83 ec 0c             	sub    $0xc,%esp
  8016ec:	ff 75 0c             	pushl  0xc(%ebp)
  8016ef:	e8 e6 0d 00 00       	call   8024da <alloc_block_FF>
  8016f4:	83 c4 10             	add    $0x10,%esp
  8016f7:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(ff_block==NULL)
  8016fa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8016fe:	75 07                	jne    801707 <smalloc+0x6e>
			return NULL ;
  801700:	b8 00 00 00 00       	mov    $0x0,%eax
  801705:	eb 39                	jmp    801740 <smalloc+0xa7>

		int obj_id =sys_createSharedObject(sharedVarName,size,isWritable,(void*)ff_block->sva);
  801707:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80170a:	8b 40 08             	mov    0x8(%eax),%eax
  80170d:	89 c2                	mov    %eax,%edx
  80170f:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801713:	52                   	push   %edx
  801714:	50                   	push   %eax
  801715:	ff 75 0c             	pushl  0xc(%ebp)
  801718:	ff 75 08             	pushl  0x8(%ebp)
  80171b:	e8 2e 04 00 00       	call   801b4e <sys_createSharedObject>
  801720:	83 c4 10             	add    $0x10,%esp
  801723:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(obj_id < 0)
  801726:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80172a:	79 07                	jns    801733 <smalloc+0x9a>
			return (void*)NULL ;
  80172c:	b8 00 00 00 00       	mov    $0x0,%eax
  801731:	eb 0d                	jmp    801740 <smalloc+0xa7>
		else
		    return (void*)ff_block->sva ;
  801733:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801736:	8b 40 08             	mov    0x8(%eax),%eax
  801739:	eb 05                	jmp    801740 <smalloc+0xa7>
		}
		return (void*)NULL ;
  80173b:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801740:	c9                   	leave  
  801741:	c3                   	ret    

00801742 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801742:	55                   	push   %ebp
  801743:	89 e5                	mov    %esp,%ebp
  801745:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801748:	e8 5b fc ff ff       	call   8013a8 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80174d:	83 ec 08             	sub    $0x8,%esp
  801750:	ff 75 0c             	pushl  0xc(%ebp)
  801753:	ff 75 08             	pushl  0x8(%ebp)
  801756:	e8 1d 04 00 00       	call   801b78 <sys_getSizeOfSharedObject>
  80175b:	83 c4 10             	add    $0x10,%esp
  80175e:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(size == 0)
  801761:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801765:	75 0a                	jne    801771 <sget+0x2f>
			return NULL ;
  801767:	b8 00 00 00 00       	mov    $0x0,%eax
  80176c:	e9 83 00 00 00       	jmp    8017f4 <sget+0xb2>
		size=ROUNDUP(size,PAGE_SIZE);
  801771:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801778:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80177b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80177e:	01 d0                	add    %edx,%eax
  801780:	48                   	dec    %eax
  801781:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801784:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801787:	ba 00 00 00 00       	mov    $0x0,%edx
  80178c:	f7 75 f0             	divl   -0x10(%ebp)
  80178f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801792:	29 d0                	sub    %edx,%eax
  801794:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801797:	e8 2d 06 00 00       	call   801dc9 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80179c:	85 c0                	test   %eax,%eax
  80179e:	74 4f                	je     8017ef <sget+0xad>
		{
			struct MemBlock * ff_block ;
				ff_block = alloc_block_FF(size);
  8017a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017a3:	83 ec 0c             	sub    $0xc,%esp
  8017a6:	50                   	push   %eax
  8017a7:	e8 2e 0d 00 00       	call   8024da <alloc_block_FF>
  8017ac:	83 c4 10             	add    $0x10,%esp
  8017af:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ff_block==NULL)
  8017b2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8017b6:	75 07                	jne    8017bf <sget+0x7d>
					return (void*)NULL ;
  8017b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8017bd:	eb 35                	jmp    8017f4 <sget+0xb2>

		int obj_id =sys_getSharedObject((int)ownerEnvID,sharedVarName,(void*)ff_block->sva);
  8017bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017c2:	8b 40 08             	mov    0x8(%eax),%eax
  8017c5:	83 ec 04             	sub    $0x4,%esp
  8017c8:	50                   	push   %eax
  8017c9:	ff 75 0c             	pushl  0xc(%ebp)
  8017cc:	ff 75 08             	pushl  0x8(%ebp)
  8017cf:	e8 c1 03 00 00       	call   801b95 <sys_getSharedObject>
  8017d4:	83 c4 10             	add    $0x10,%esp
  8017d7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if(obj_id<0)
  8017da:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8017de:	79 07                	jns    8017e7 <sget+0xa5>
				return (void*)NULL ;
  8017e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8017e5:	eb 0d                	jmp    8017f4 <sget+0xb2>
			else
				return (void*)ff_block->sva ;
  8017e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017ea:	8b 40 08             	mov    0x8(%eax),%eax
  8017ed:	eb 05                	jmp    8017f4 <sget+0xb2>


		}
	return (void*)NULL ;
  8017ef:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8017f4:	c9                   	leave  
  8017f5:	c3                   	ret    

008017f6 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8017f6:	55                   	push   %ebp
  8017f7:	89 e5                	mov    %esp,%ebp
  8017f9:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017fc:	e8 a7 fb ff ff       	call   8013a8 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801801:	83 ec 04             	sub    $0x4,%esp
  801804:	68 c0 39 80 00       	push   $0x8039c0
  801809:	68 f9 00 00 00       	push   $0xf9
  80180e:	68 b3 39 80 00       	push   $0x8039b3
  801813:	e8 52 eb ff ff       	call   80036a <_panic>

00801818 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801818:	55                   	push   %ebp
  801819:	89 e5                	mov    %esp,%ebp
  80181b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80181e:	83 ec 04             	sub    $0x4,%esp
  801821:	68 e8 39 80 00       	push   $0x8039e8
  801826:	68 0d 01 00 00       	push   $0x10d
  80182b:	68 b3 39 80 00       	push   $0x8039b3
  801830:	e8 35 eb ff ff       	call   80036a <_panic>

00801835 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801835:	55                   	push   %ebp
  801836:	89 e5                	mov    %esp,%ebp
  801838:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80183b:	83 ec 04             	sub    $0x4,%esp
  80183e:	68 0c 3a 80 00       	push   $0x803a0c
  801843:	68 18 01 00 00       	push   $0x118
  801848:	68 b3 39 80 00       	push   $0x8039b3
  80184d:	e8 18 eb ff ff       	call   80036a <_panic>

00801852 <shrink>:

}
void shrink(uint32 newSize)
{
  801852:	55                   	push   %ebp
  801853:	89 e5                	mov    %esp,%ebp
  801855:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801858:	83 ec 04             	sub    $0x4,%esp
  80185b:	68 0c 3a 80 00       	push   $0x803a0c
  801860:	68 1d 01 00 00       	push   $0x11d
  801865:	68 b3 39 80 00       	push   $0x8039b3
  80186a:	e8 fb ea ff ff       	call   80036a <_panic>

0080186f <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80186f:	55                   	push   %ebp
  801870:	89 e5                	mov    %esp,%ebp
  801872:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801875:	83 ec 04             	sub    $0x4,%esp
  801878:	68 0c 3a 80 00       	push   $0x803a0c
  80187d:	68 22 01 00 00       	push   $0x122
  801882:	68 b3 39 80 00       	push   $0x8039b3
  801887:	e8 de ea ff ff       	call   80036a <_panic>

0080188c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80188c:	55                   	push   %ebp
  80188d:	89 e5                	mov    %esp,%ebp
  80188f:	57                   	push   %edi
  801890:	56                   	push   %esi
  801891:	53                   	push   %ebx
  801892:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801895:	8b 45 08             	mov    0x8(%ebp),%eax
  801898:	8b 55 0c             	mov    0xc(%ebp),%edx
  80189b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80189e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018a1:	8b 7d 18             	mov    0x18(%ebp),%edi
  8018a4:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8018a7:	cd 30                	int    $0x30
  8018a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8018ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018af:	83 c4 10             	add    $0x10,%esp
  8018b2:	5b                   	pop    %ebx
  8018b3:	5e                   	pop    %esi
  8018b4:	5f                   	pop    %edi
  8018b5:	5d                   	pop    %ebp
  8018b6:	c3                   	ret    

008018b7 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8018b7:	55                   	push   %ebp
  8018b8:	89 e5                	mov    %esp,%ebp
  8018ba:	83 ec 04             	sub    $0x4,%esp
  8018bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8018c0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8018c3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 00                	push   $0x0
  8018ce:	52                   	push   %edx
  8018cf:	ff 75 0c             	pushl  0xc(%ebp)
  8018d2:	50                   	push   %eax
  8018d3:	6a 00                	push   $0x0
  8018d5:	e8 b2 ff ff ff       	call   80188c <syscall>
  8018da:	83 c4 18             	add    $0x18,%esp
}
  8018dd:	90                   	nop
  8018de:	c9                   	leave  
  8018df:	c3                   	ret    

008018e0 <sys_cgetc>:

int
sys_cgetc(void)
{
  8018e0:	55                   	push   %ebp
  8018e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8018e3:	6a 00                	push   $0x0
  8018e5:	6a 00                	push   $0x0
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 01                	push   $0x1
  8018ef:	e8 98 ff ff ff       	call   80188c <syscall>
  8018f4:	83 c4 18             	add    $0x18,%esp
}
  8018f7:	c9                   	leave  
  8018f8:	c3                   	ret    

008018f9 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018f9:	55                   	push   %ebp
  8018fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	6a 00                	push   $0x0
  801908:	52                   	push   %edx
  801909:	50                   	push   %eax
  80190a:	6a 05                	push   $0x5
  80190c:	e8 7b ff ff ff       	call   80188c <syscall>
  801911:	83 c4 18             	add    $0x18,%esp
}
  801914:	c9                   	leave  
  801915:	c3                   	ret    

00801916 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801916:	55                   	push   %ebp
  801917:	89 e5                	mov    %esp,%ebp
  801919:	56                   	push   %esi
  80191a:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80191b:	8b 75 18             	mov    0x18(%ebp),%esi
  80191e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801921:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801924:	8b 55 0c             	mov    0xc(%ebp),%edx
  801927:	8b 45 08             	mov    0x8(%ebp),%eax
  80192a:	56                   	push   %esi
  80192b:	53                   	push   %ebx
  80192c:	51                   	push   %ecx
  80192d:	52                   	push   %edx
  80192e:	50                   	push   %eax
  80192f:	6a 06                	push   $0x6
  801931:	e8 56 ff ff ff       	call   80188c <syscall>
  801936:	83 c4 18             	add    $0x18,%esp
}
  801939:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80193c:	5b                   	pop    %ebx
  80193d:	5e                   	pop    %esi
  80193e:	5d                   	pop    %ebp
  80193f:	c3                   	ret    

00801940 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801940:	55                   	push   %ebp
  801941:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801943:	8b 55 0c             	mov    0xc(%ebp),%edx
  801946:	8b 45 08             	mov    0x8(%ebp),%eax
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	6a 00                	push   $0x0
  80194f:	52                   	push   %edx
  801950:	50                   	push   %eax
  801951:	6a 07                	push   $0x7
  801953:	e8 34 ff ff ff       	call   80188c <syscall>
  801958:	83 c4 18             	add    $0x18,%esp
}
  80195b:	c9                   	leave  
  80195c:	c3                   	ret    

0080195d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80195d:	55                   	push   %ebp
  80195e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801960:	6a 00                	push   $0x0
  801962:	6a 00                	push   $0x0
  801964:	6a 00                	push   $0x0
  801966:	ff 75 0c             	pushl  0xc(%ebp)
  801969:	ff 75 08             	pushl  0x8(%ebp)
  80196c:	6a 08                	push   $0x8
  80196e:	e8 19 ff ff ff       	call   80188c <syscall>
  801973:	83 c4 18             	add    $0x18,%esp
}
  801976:	c9                   	leave  
  801977:	c3                   	ret    

00801978 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801978:	55                   	push   %ebp
  801979:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	6a 00                	push   $0x0
  801981:	6a 00                	push   $0x0
  801983:	6a 00                	push   $0x0
  801985:	6a 09                	push   $0x9
  801987:	e8 00 ff ff ff       	call   80188c <syscall>
  80198c:	83 c4 18             	add    $0x18,%esp
}
  80198f:	c9                   	leave  
  801990:	c3                   	ret    

00801991 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801991:	55                   	push   %ebp
  801992:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801994:	6a 00                	push   $0x0
  801996:	6a 00                	push   $0x0
  801998:	6a 00                	push   $0x0
  80199a:	6a 00                	push   $0x0
  80199c:	6a 00                	push   $0x0
  80199e:	6a 0a                	push   $0xa
  8019a0:	e8 e7 fe ff ff       	call   80188c <syscall>
  8019a5:	83 c4 18             	add    $0x18,%esp
}
  8019a8:	c9                   	leave  
  8019a9:	c3                   	ret    

008019aa <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8019aa:	55                   	push   %ebp
  8019ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 0b                	push   $0xb
  8019b9:	e8 ce fe ff ff       	call   80188c <syscall>
  8019be:	83 c4 18             	add    $0x18,%esp
}
  8019c1:	c9                   	leave  
  8019c2:	c3                   	ret    

008019c3 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019c3:	55                   	push   %ebp
  8019c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	ff 75 0c             	pushl  0xc(%ebp)
  8019cf:	ff 75 08             	pushl  0x8(%ebp)
  8019d2:	6a 0f                	push   $0xf
  8019d4:	e8 b3 fe ff ff       	call   80188c <syscall>
  8019d9:	83 c4 18             	add    $0x18,%esp
	return;
  8019dc:	90                   	nop
}
  8019dd:	c9                   	leave  
  8019de:	c3                   	ret    

008019df <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019df:	55                   	push   %ebp
  8019e0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 00                	push   $0x0
  8019e8:	ff 75 0c             	pushl  0xc(%ebp)
  8019eb:	ff 75 08             	pushl  0x8(%ebp)
  8019ee:	6a 10                	push   $0x10
  8019f0:	e8 97 fe ff ff       	call   80188c <syscall>
  8019f5:	83 c4 18             	add    $0x18,%esp
	return ;
  8019f8:	90                   	nop
}
  8019f9:	c9                   	leave  
  8019fa:	c3                   	ret    

008019fb <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8019fb:	55                   	push   %ebp
  8019fc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 00                	push   $0x0
  801a02:	ff 75 10             	pushl  0x10(%ebp)
  801a05:	ff 75 0c             	pushl  0xc(%ebp)
  801a08:	ff 75 08             	pushl  0x8(%ebp)
  801a0b:	6a 11                	push   $0x11
  801a0d:	e8 7a fe ff ff       	call   80188c <syscall>
  801a12:	83 c4 18             	add    $0x18,%esp
	return ;
  801a15:	90                   	nop
}
  801a16:	c9                   	leave  
  801a17:	c3                   	ret    

00801a18 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a18:	55                   	push   %ebp
  801a19:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 00                	push   $0x0
  801a23:	6a 00                	push   $0x0
  801a25:	6a 0c                	push   $0xc
  801a27:	e8 60 fe ff ff       	call   80188c <syscall>
  801a2c:	83 c4 18             	add    $0x18,%esp
}
  801a2f:	c9                   	leave  
  801a30:	c3                   	ret    

00801a31 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a31:	55                   	push   %ebp
  801a32:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a34:	6a 00                	push   $0x0
  801a36:	6a 00                	push   $0x0
  801a38:	6a 00                	push   $0x0
  801a3a:	6a 00                	push   $0x0
  801a3c:	ff 75 08             	pushl  0x8(%ebp)
  801a3f:	6a 0d                	push   $0xd
  801a41:	e8 46 fe ff ff       	call   80188c <syscall>
  801a46:	83 c4 18             	add    $0x18,%esp
}
  801a49:	c9                   	leave  
  801a4a:	c3                   	ret    

00801a4b <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a4b:	55                   	push   %ebp
  801a4c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	6a 00                	push   $0x0
  801a58:	6a 0e                	push   $0xe
  801a5a:	e8 2d fe ff ff       	call   80188c <syscall>
  801a5f:	83 c4 18             	add    $0x18,%esp
}
  801a62:	90                   	nop
  801a63:	c9                   	leave  
  801a64:	c3                   	ret    

00801a65 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a65:	55                   	push   %ebp
  801a66:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 00                	push   $0x0
  801a72:	6a 13                	push   $0x13
  801a74:	e8 13 fe ff ff       	call   80188c <syscall>
  801a79:	83 c4 18             	add    $0x18,%esp
}
  801a7c:	90                   	nop
  801a7d:	c9                   	leave  
  801a7e:	c3                   	ret    

00801a7f <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a7f:	55                   	push   %ebp
  801a80:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 14                	push   $0x14
  801a8e:	e8 f9 fd ff ff       	call   80188c <syscall>
  801a93:	83 c4 18             	add    $0x18,%esp
}
  801a96:	90                   	nop
  801a97:	c9                   	leave  
  801a98:	c3                   	ret    

00801a99 <sys_cputc>:


void
sys_cputc(const char c)
{
  801a99:	55                   	push   %ebp
  801a9a:	89 e5                	mov    %esp,%ebp
  801a9c:	83 ec 04             	sub    $0x4,%esp
  801a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801aa5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 00                	push   $0x0
  801ab1:	50                   	push   %eax
  801ab2:	6a 15                	push   $0x15
  801ab4:	e8 d3 fd ff ff       	call   80188c <syscall>
  801ab9:	83 c4 18             	add    $0x18,%esp
}
  801abc:	90                   	nop
  801abd:	c9                   	leave  
  801abe:	c3                   	ret    

00801abf <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801abf:	55                   	push   %ebp
  801ac0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 00                	push   $0x0
  801acc:	6a 16                	push   $0x16
  801ace:	e8 b9 fd ff ff       	call   80188c <syscall>
  801ad3:	83 c4 18             	add    $0x18,%esp
}
  801ad6:	90                   	nop
  801ad7:	c9                   	leave  
  801ad8:	c3                   	ret    

00801ad9 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801ad9:	55                   	push   %ebp
  801ada:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801adc:	8b 45 08             	mov    0x8(%ebp),%eax
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	ff 75 0c             	pushl  0xc(%ebp)
  801ae8:	50                   	push   %eax
  801ae9:	6a 17                	push   $0x17
  801aeb:	e8 9c fd ff ff       	call   80188c <syscall>
  801af0:	83 c4 18             	add    $0x18,%esp
}
  801af3:	c9                   	leave  
  801af4:	c3                   	ret    

00801af5 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801af5:	55                   	push   %ebp
  801af6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801af8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801afb:	8b 45 08             	mov    0x8(%ebp),%eax
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	52                   	push   %edx
  801b05:	50                   	push   %eax
  801b06:	6a 1a                	push   $0x1a
  801b08:	e8 7f fd ff ff       	call   80188c <syscall>
  801b0d:	83 c4 18             	add    $0x18,%esp
}
  801b10:	c9                   	leave  
  801b11:	c3                   	ret    

00801b12 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b12:	55                   	push   %ebp
  801b13:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b15:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b18:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1b:	6a 00                	push   $0x0
  801b1d:	6a 00                	push   $0x0
  801b1f:	6a 00                	push   $0x0
  801b21:	52                   	push   %edx
  801b22:	50                   	push   %eax
  801b23:	6a 18                	push   $0x18
  801b25:	e8 62 fd ff ff       	call   80188c <syscall>
  801b2a:	83 c4 18             	add    $0x18,%esp
}
  801b2d:	90                   	nop
  801b2e:	c9                   	leave  
  801b2f:	c3                   	ret    

00801b30 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b30:	55                   	push   %ebp
  801b31:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b33:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b36:	8b 45 08             	mov    0x8(%ebp),%eax
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	52                   	push   %edx
  801b40:	50                   	push   %eax
  801b41:	6a 19                	push   $0x19
  801b43:	e8 44 fd ff ff       	call   80188c <syscall>
  801b48:	83 c4 18             	add    $0x18,%esp
}
  801b4b:	90                   	nop
  801b4c:	c9                   	leave  
  801b4d:	c3                   	ret    

00801b4e <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b4e:	55                   	push   %ebp
  801b4f:	89 e5                	mov    %esp,%ebp
  801b51:	83 ec 04             	sub    $0x4,%esp
  801b54:	8b 45 10             	mov    0x10(%ebp),%eax
  801b57:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b5a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b5d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b61:	8b 45 08             	mov    0x8(%ebp),%eax
  801b64:	6a 00                	push   $0x0
  801b66:	51                   	push   %ecx
  801b67:	52                   	push   %edx
  801b68:	ff 75 0c             	pushl  0xc(%ebp)
  801b6b:	50                   	push   %eax
  801b6c:	6a 1b                	push   $0x1b
  801b6e:	e8 19 fd ff ff       	call   80188c <syscall>
  801b73:	83 c4 18             	add    $0x18,%esp
}
  801b76:	c9                   	leave  
  801b77:	c3                   	ret    

00801b78 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b78:	55                   	push   %ebp
  801b79:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	6a 00                	push   $0x0
  801b87:	52                   	push   %edx
  801b88:	50                   	push   %eax
  801b89:	6a 1c                	push   $0x1c
  801b8b:	e8 fc fc ff ff       	call   80188c <syscall>
  801b90:	83 c4 18             	add    $0x18,%esp
}
  801b93:	c9                   	leave  
  801b94:	c3                   	ret    

00801b95 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b95:	55                   	push   %ebp
  801b96:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b98:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba1:	6a 00                	push   $0x0
  801ba3:	6a 00                	push   $0x0
  801ba5:	51                   	push   %ecx
  801ba6:	52                   	push   %edx
  801ba7:	50                   	push   %eax
  801ba8:	6a 1d                	push   $0x1d
  801baa:	e8 dd fc ff ff       	call   80188c <syscall>
  801baf:	83 c4 18             	add    $0x18,%esp
}
  801bb2:	c9                   	leave  
  801bb3:	c3                   	ret    

00801bb4 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801bb4:	55                   	push   %ebp
  801bb5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801bb7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bba:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	52                   	push   %edx
  801bc4:	50                   	push   %eax
  801bc5:	6a 1e                	push   $0x1e
  801bc7:	e8 c0 fc ff ff       	call   80188c <syscall>
  801bcc:	83 c4 18             	add    $0x18,%esp
}
  801bcf:	c9                   	leave  
  801bd0:	c3                   	ret    

00801bd1 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801bd1:	55                   	push   %ebp
  801bd2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 1f                	push   $0x1f
  801be0:	e8 a7 fc ff ff       	call   80188c <syscall>
  801be5:	83 c4 18             	add    $0x18,%esp
}
  801be8:	c9                   	leave  
  801be9:	c3                   	ret    

00801bea <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801bea:	55                   	push   %ebp
  801beb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801bed:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf0:	6a 00                	push   $0x0
  801bf2:	ff 75 14             	pushl  0x14(%ebp)
  801bf5:	ff 75 10             	pushl  0x10(%ebp)
  801bf8:	ff 75 0c             	pushl  0xc(%ebp)
  801bfb:	50                   	push   %eax
  801bfc:	6a 20                	push   $0x20
  801bfe:	e8 89 fc ff ff       	call   80188c <syscall>
  801c03:	83 c4 18             	add    $0x18,%esp
}
  801c06:	c9                   	leave  
  801c07:	c3                   	ret    

00801c08 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c08:	55                   	push   %ebp
  801c09:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 00                	push   $0x0
  801c12:	6a 00                	push   $0x0
  801c14:	6a 00                	push   $0x0
  801c16:	50                   	push   %eax
  801c17:	6a 21                	push   $0x21
  801c19:	e8 6e fc ff ff       	call   80188c <syscall>
  801c1e:	83 c4 18             	add    $0x18,%esp
}
  801c21:	90                   	nop
  801c22:	c9                   	leave  
  801c23:	c3                   	ret    

00801c24 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c24:	55                   	push   %ebp
  801c25:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c27:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2a:	6a 00                	push   $0x0
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 00                	push   $0x0
  801c32:	50                   	push   %eax
  801c33:	6a 22                	push   $0x22
  801c35:	e8 52 fc ff ff       	call   80188c <syscall>
  801c3a:	83 c4 18             	add    $0x18,%esp
}
  801c3d:	c9                   	leave  
  801c3e:	c3                   	ret    

00801c3f <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c3f:	55                   	push   %ebp
  801c40:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 02                	push   $0x2
  801c4e:	e8 39 fc ff ff       	call   80188c <syscall>
  801c53:	83 c4 18             	add    $0x18,%esp
}
  801c56:	c9                   	leave  
  801c57:	c3                   	ret    

00801c58 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c58:	55                   	push   %ebp
  801c59:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c5b:	6a 00                	push   $0x0
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 00                	push   $0x0
  801c61:	6a 00                	push   $0x0
  801c63:	6a 00                	push   $0x0
  801c65:	6a 03                	push   $0x3
  801c67:	e8 20 fc ff ff       	call   80188c <syscall>
  801c6c:	83 c4 18             	add    $0x18,%esp
}
  801c6f:	c9                   	leave  
  801c70:	c3                   	ret    

00801c71 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c71:	55                   	push   %ebp
  801c72:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c74:	6a 00                	push   $0x0
  801c76:	6a 00                	push   $0x0
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 04                	push   $0x4
  801c80:	e8 07 fc ff ff       	call   80188c <syscall>
  801c85:	83 c4 18             	add    $0x18,%esp
}
  801c88:	c9                   	leave  
  801c89:	c3                   	ret    

00801c8a <sys_exit_env>:


void sys_exit_env(void)
{
  801c8a:	55                   	push   %ebp
  801c8b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	6a 00                	push   $0x0
  801c97:	6a 23                	push   $0x23
  801c99:	e8 ee fb ff ff       	call   80188c <syscall>
  801c9e:	83 c4 18             	add    $0x18,%esp
}
  801ca1:	90                   	nop
  801ca2:	c9                   	leave  
  801ca3:	c3                   	ret    

00801ca4 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801ca4:	55                   	push   %ebp
  801ca5:	89 e5                	mov    %esp,%ebp
  801ca7:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801caa:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cad:	8d 50 04             	lea    0x4(%eax),%edx
  801cb0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cb3:	6a 00                	push   $0x0
  801cb5:	6a 00                	push   $0x0
  801cb7:	6a 00                	push   $0x0
  801cb9:	52                   	push   %edx
  801cba:	50                   	push   %eax
  801cbb:	6a 24                	push   $0x24
  801cbd:	e8 ca fb ff ff       	call   80188c <syscall>
  801cc2:	83 c4 18             	add    $0x18,%esp
	return result;
  801cc5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cc8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ccb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801cce:	89 01                	mov    %eax,(%ecx)
  801cd0:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801cd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd6:	c9                   	leave  
  801cd7:	c2 04 00             	ret    $0x4

00801cda <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801cda:	55                   	push   %ebp
  801cdb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801cdd:	6a 00                	push   $0x0
  801cdf:	6a 00                	push   $0x0
  801ce1:	ff 75 10             	pushl  0x10(%ebp)
  801ce4:	ff 75 0c             	pushl  0xc(%ebp)
  801ce7:	ff 75 08             	pushl  0x8(%ebp)
  801cea:	6a 12                	push   $0x12
  801cec:	e8 9b fb ff ff       	call   80188c <syscall>
  801cf1:	83 c4 18             	add    $0x18,%esp
	return ;
  801cf4:	90                   	nop
}
  801cf5:	c9                   	leave  
  801cf6:	c3                   	ret    

00801cf7 <sys_rcr2>:
uint32 sys_rcr2()
{
  801cf7:	55                   	push   %ebp
  801cf8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 00                	push   $0x0
  801d02:	6a 00                	push   $0x0
  801d04:	6a 25                	push   $0x25
  801d06:	e8 81 fb ff ff       	call   80188c <syscall>
  801d0b:	83 c4 18             	add    $0x18,%esp
}
  801d0e:	c9                   	leave  
  801d0f:	c3                   	ret    

00801d10 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d10:	55                   	push   %ebp
  801d11:	89 e5                	mov    %esp,%ebp
  801d13:	83 ec 04             	sub    $0x4,%esp
  801d16:	8b 45 08             	mov    0x8(%ebp),%eax
  801d19:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d1c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d20:	6a 00                	push   $0x0
  801d22:	6a 00                	push   $0x0
  801d24:	6a 00                	push   $0x0
  801d26:	6a 00                	push   $0x0
  801d28:	50                   	push   %eax
  801d29:	6a 26                	push   $0x26
  801d2b:	e8 5c fb ff ff       	call   80188c <syscall>
  801d30:	83 c4 18             	add    $0x18,%esp
	return ;
  801d33:	90                   	nop
}
  801d34:	c9                   	leave  
  801d35:	c3                   	ret    

00801d36 <rsttst>:
void rsttst()
{
  801d36:	55                   	push   %ebp
  801d37:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d39:	6a 00                	push   $0x0
  801d3b:	6a 00                	push   $0x0
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	6a 28                	push   $0x28
  801d45:	e8 42 fb ff ff       	call   80188c <syscall>
  801d4a:	83 c4 18             	add    $0x18,%esp
	return ;
  801d4d:	90                   	nop
}
  801d4e:	c9                   	leave  
  801d4f:	c3                   	ret    

00801d50 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d50:	55                   	push   %ebp
  801d51:	89 e5                	mov    %esp,%ebp
  801d53:	83 ec 04             	sub    $0x4,%esp
  801d56:	8b 45 14             	mov    0x14(%ebp),%eax
  801d59:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d5c:	8b 55 18             	mov    0x18(%ebp),%edx
  801d5f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d63:	52                   	push   %edx
  801d64:	50                   	push   %eax
  801d65:	ff 75 10             	pushl  0x10(%ebp)
  801d68:	ff 75 0c             	pushl  0xc(%ebp)
  801d6b:	ff 75 08             	pushl  0x8(%ebp)
  801d6e:	6a 27                	push   $0x27
  801d70:	e8 17 fb ff ff       	call   80188c <syscall>
  801d75:	83 c4 18             	add    $0x18,%esp
	return ;
  801d78:	90                   	nop
}
  801d79:	c9                   	leave  
  801d7a:	c3                   	ret    

00801d7b <chktst>:
void chktst(uint32 n)
{
  801d7b:	55                   	push   %ebp
  801d7c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d7e:	6a 00                	push   $0x0
  801d80:	6a 00                	push   $0x0
  801d82:	6a 00                	push   $0x0
  801d84:	6a 00                	push   $0x0
  801d86:	ff 75 08             	pushl  0x8(%ebp)
  801d89:	6a 29                	push   $0x29
  801d8b:	e8 fc fa ff ff       	call   80188c <syscall>
  801d90:	83 c4 18             	add    $0x18,%esp
	return ;
  801d93:	90                   	nop
}
  801d94:	c9                   	leave  
  801d95:	c3                   	ret    

00801d96 <inctst>:

void inctst()
{
  801d96:	55                   	push   %ebp
  801d97:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d99:	6a 00                	push   $0x0
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 00                	push   $0x0
  801d9f:	6a 00                	push   $0x0
  801da1:	6a 00                	push   $0x0
  801da3:	6a 2a                	push   $0x2a
  801da5:	e8 e2 fa ff ff       	call   80188c <syscall>
  801daa:	83 c4 18             	add    $0x18,%esp
	return ;
  801dad:	90                   	nop
}
  801dae:	c9                   	leave  
  801daf:	c3                   	ret    

00801db0 <gettst>:
uint32 gettst()
{
  801db0:	55                   	push   %ebp
  801db1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801db3:	6a 00                	push   $0x0
  801db5:	6a 00                	push   $0x0
  801db7:	6a 00                	push   $0x0
  801db9:	6a 00                	push   $0x0
  801dbb:	6a 00                	push   $0x0
  801dbd:	6a 2b                	push   $0x2b
  801dbf:	e8 c8 fa ff ff       	call   80188c <syscall>
  801dc4:	83 c4 18             	add    $0x18,%esp
}
  801dc7:	c9                   	leave  
  801dc8:	c3                   	ret    

00801dc9 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801dc9:	55                   	push   %ebp
  801dca:	89 e5                	mov    %esp,%ebp
  801dcc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dcf:	6a 00                	push   $0x0
  801dd1:	6a 00                	push   $0x0
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 2c                	push   $0x2c
  801ddb:	e8 ac fa ff ff       	call   80188c <syscall>
  801de0:	83 c4 18             	add    $0x18,%esp
  801de3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801de6:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801dea:	75 07                	jne    801df3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801dec:	b8 01 00 00 00       	mov    $0x1,%eax
  801df1:	eb 05                	jmp    801df8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801df3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801df8:	c9                   	leave  
  801df9:	c3                   	ret    

00801dfa <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801dfa:	55                   	push   %ebp
  801dfb:	89 e5                	mov    %esp,%ebp
  801dfd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e00:	6a 00                	push   $0x0
  801e02:	6a 00                	push   $0x0
  801e04:	6a 00                	push   $0x0
  801e06:	6a 00                	push   $0x0
  801e08:	6a 00                	push   $0x0
  801e0a:	6a 2c                	push   $0x2c
  801e0c:	e8 7b fa ff ff       	call   80188c <syscall>
  801e11:	83 c4 18             	add    $0x18,%esp
  801e14:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e17:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e1b:	75 07                	jne    801e24 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e1d:	b8 01 00 00 00       	mov    $0x1,%eax
  801e22:	eb 05                	jmp    801e29 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e24:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e29:	c9                   	leave  
  801e2a:	c3                   	ret    

00801e2b <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e2b:	55                   	push   %ebp
  801e2c:	89 e5                	mov    %esp,%ebp
  801e2e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e31:	6a 00                	push   $0x0
  801e33:	6a 00                	push   $0x0
  801e35:	6a 00                	push   $0x0
  801e37:	6a 00                	push   $0x0
  801e39:	6a 00                	push   $0x0
  801e3b:	6a 2c                	push   $0x2c
  801e3d:	e8 4a fa ff ff       	call   80188c <syscall>
  801e42:	83 c4 18             	add    $0x18,%esp
  801e45:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e48:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e4c:	75 07                	jne    801e55 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e4e:	b8 01 00 00 00       	mov    $0x1,%eax
  801e53:	eb 05                	jmp    801e5a <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e55:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e5a:	c9                   	leave  
  801e5b:	c3                   	ret    

00801e5c <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e5c:	55                   	push   %ebp
  801e5d:	89 e5                	mov    %esp,%ebp
  801e5f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e62:	6a 00                	push   $0x0
  801e64:	6a 00                	push   $0x0
  801e66:	6a 00                	push   $0x0
  801e68:	6a 00                	push   $0x0
  801e6a:	6a 00                	push   $0x0
  801e6c:	6a 2c                	push   $0x2c
  801e6e:	e8 19 fa ff ff       	call   80188c <syscall>
  801e73:	83 c4 18             	add    $0x18,%esp
  801e76:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e79:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e7d:	75 07                	jne    801e86 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e7f:	b8 01 00 00 00       	mov    $0x1,%eax
  801e84:	eb 05                	jmp    801e8b <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e86:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e8b:	c9                   	leave  
  801e8c:	c3                   	ret    

00801e8d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e8d:	55                   	push   %ebp
  801e8e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e90:	6a 00                	push   $0x0
  801e92:	6a 00                	push   $0x0
  801e94:	6a 00                	push   $0x0
  801e96:	6a 00                	push   $0x0
  801e98:	ff 75 08             	pushl  0x8(%ebp)
  801e9b:	6a 2d                	push   $0x2d
  801e9d:	e8 ea f9 ff ff       	call   80188c <syscall>
  801ea2:	83 c4 18             	add    $0x18,%esp
	return ;
  801ea5:	90                   	nop
}
  801ea6:	c9                   	leave  
  801ea7:	c3                   	ret    

00801ea8 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ea8:	55                   	push   %ebp
  801ea9:	89 e5                	mov    %esp,%ebp
  801eab:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801eac:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801eaf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801eb2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb8:	6a 00                	push   $0x0
  801eba:	53                   	push   %ebx
  801ebb:	51                   	push   %ecx
  801ebc:	52                   	push   %edx
  801ebd:	50                   	push   %eax
  801ebe:	6a 2e                	push   $0x2e
  801ec0:	e8 c7 f9 ff ff       	call   80188c <syscall>
  801ec5:	83 c4 18             	add    $0x18,%esp
}
  801ec8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ecb:	c9                   	leave  
  801ecc:	c3                   	ret    

00801ecd <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ecd:	55                   	push   %ebp
  801ece:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ed0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed6:	6a 00                	push   $0x0
  801ed8:	6a 00                	push   $0x0
  801eda:	6a 00                	push   $0x0
  801edc:	52                   	push   %edx
  801edd:	50                   	push   %eax
  801ede:	6a 2f                	push   $0x2f
  801ee0:	e8 a7 f9 ff ff       	call   80188c <syscall>
  801ee5:	83 c4 18             	add    $0x18,%esp
}
  801ee8:	c9                   	leave  
  801ee9:	c3                   	ret    

00801eea <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801eea:	55                   	push   %ebp
  801eeb:	89 e5                	mov    %esp,%ebp
  801eed:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801ef0:	83 ec 0c             	sub    $0xc,%esp
  801ef3:	68 1c 3a 80 00       	push   $0x803a1c
  801ef8:	e8 21 e7 ff ff       	call   80061e <cprintf>
  801efd:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801f00:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801f07:	83 ec 0c             	sub    $0xc,%esp
  801f0a:	68 48 3a 80 00       	push   $0x803a48
  801f0f:	e8 0a e7 ff ff       	call   80061e <cprintf>
  801f14:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801f17:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f1b:	a1 38 41 80 00       	mov    0x804138,%eax
  801f20:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f23:	eb 56                	jmp    801f7b <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f25:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f29:	74 1c                	je     801f47 <print_mem_block_lists+0x5d>
  801f2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f2e:	8b 50 08             	mov    0x8(%eax),%edx
  801f31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f34:	8b 48 08             	mov    0x8(%eax),%ecx
  801f37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f3a:	8b 40 0c             	mov    0xc(%eax),%eax
  801f3d:	01 c8                	add    %ecx,%eax
  801f3f:	39 c2                	cmp    %eax,%edx
  801f41:	73 04                	jae    801f47 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801f43:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f4a:	8b 50 08             	mov    0x8(%eax),%edx
  801f4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f50:	8b 40 0c             	mov    0xc(%eax),%eax
  801f53:	01 c2                	add    %eax,%edx
  801f55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f58:	8b 40 08             	mov    0x8(%eax),%eax
  801f5b:	83 ec 04             	sub    $0x4,%esp
  801f5e:	52                   	push   %edx
  801f5f:	50                   	push   %eax
  801f60:	68 5d 3a 80 00       	push   $0x803a5d
  801f65:	e8 b4 e6 ff ff       	call   80061e <cprintf>
  801f6a:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f70:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f73:	a1 40 41 80 00       	mov    0x804140,%eax
  801f78:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f7b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f7f:	74 07                	je     801f88 <print_mem_block_lists+0x9e>
  801f81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f84:	8b 00                	mov    (%eax),%eax
  801f86:	eb 05                	jmp    801f8d <print_mem_block_lists+0xa3>
  801f88:	b8 00 00 00 00       	mov    $0x0,%eax
  801f8d:	a3 40 41 80 00       	mov    %eax,0x804140
  801f92:	a1 40 41 80 00       	mov    0x804140,%eax
  801f97:	85 c0                	test   %eax,%eax
  801f99:	75 8a                	jne    801f25 <print_mem_block_lists+0x3b>
  801f9b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f9f:	75 84                	jne    801f25 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801fa1:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fa5:	75 10                	jne    801fb7 <print_mem_block_lists+0xcd>
  801fa7:	83 ec 0c             	sub    $0xc,%esp
  801faa:	68 6c 3a 80 00       	push   $0x803a6c
  801faf:	e8 6a e6 ff ff       	call   80061e <cprintf>
  801fb4:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801fb7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801fbe:	83 ec 0c             	sub    $0xc,%esp
  801fc1:	68 90 3a 80 00       	push   $0x803a90
  801fc6:	e8 53 e6 ff ff       	call   80061e <cprintf>
  801fcb:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801fce:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801fd2:	a1 40 40 80 00       	mov    0x804040,%eax
  801fd7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fda:	eb 56                	jmp    802032 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801fdc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fe0:	74 1c                	je     801ffe <print_mem_block_lists+0x114>
  801fe2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe5:	8b 50 08             	mov    0x8(%eax),%edx
  801fe8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801feb:	8b 48 08             	mov    0x8(%eax),%ecx
  801fee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ff1:	8b 40 0c             	mov    0xc(%eax),%eax
  801ff4:	01 c8                	add    %ecx,%eax
  801ff6:	39 c2                	cmp    %eax,%edx
  801ff8:	73 04                	jae    801ffe <print_mem_block_lists+0x114>
			sorted = 0 ;
  801ffa:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801ffe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802001:	8b 50 08             	mov    0x8(%eax),%edx
  802004:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802007:	8b 40 0c             	mov    0xc(%eax),%eax
  80200a:	01 c2                	add    %eax,%edx
  80200c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80200f:	8b 40 08             	mov    0x8(%eax),%eax
  802012:	83 ec 04             	sub    $0x4,%esp
  802015:	52                   	push   %edx
  802016:	50                   	push   %eax
  802017:	68 5d 3a 80 00       	push   $0x803a5d
  80201c:	e8 fd e5 ff ff       	call   80061e <cprintf>
  802021:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802024:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802027:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80202a:	a1 48 40 80 00       	mov    0x804048,%eax
  80202f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802032:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802036:	74 07                	je     80203f <print_mem_block_lists+0x155>
  802038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80203b:	8b 00                	mov    (%eax),%eax
  80203d:	eb 05                	jmp    802044 <print_mem_block_lists+0x15a>
  80203f:	b8 00 00 00 00       	mov    $0x0,%eax
  802044:	a3 48 40 80 00       	mov    %eax,0x804048
  802049:	a1 48 40 80 00       	mov    0x804048,%eax
  80204e:	85 c0                	test   %eax,%eax
  802050:	75 8a                	jne    801fdc <print_mem_block_lists+0xf2>
  802052:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802056:	75 84                	jne    801fdc <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802058:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80205c:	75 10                	jne    80206e <print_mem_block_lists+0x184>
  80205e:	83 ec 0c             	sub    $0xc,%esp
  802061:	68 a8 3a 80 00       	push   $0x803aa8
  802066:	e8 b3 e5 ff ff       	call   80061e <cprintf>
  80206b:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80206e:	83 ec 0c             	sub    $0xc,%esp
  802071:	68 1c 3a 80 00       	push   $0x803a1c
  802076:	e8 a3 e5 ff ff       	call   80061e <cprintf>
  80207b:	83 c4 10             	add    $0x10,%esp

}
  80207e:	90                   	nop
  80207f:	c9                   	leave  
  802080:	c3                   	ret    

00802081 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802081:	55                   	push   %ebp
  802082:	89 e5                	mov    %esp,%ebp
  802084:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  802087:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  80208e:	00 00 00 
  802091:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  802098:	00 00 00 
  80209b:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  8020a2:	00 00 00 
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  8020a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8020ac:	e9 9e 00 00 00       	jmp    80214f <initialize_MemBlocksList+0xce>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
  8020b1:	a1 50 40 80 00       	mov    0x804050,%eax
  8020b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020b9:	c1 e2 04             	shl    $0x4,%edx
  8020bc:	01 d0                	add    %edx,%eax
  8020be:	85 c0                	test   %eax,%eax
  8020c0:	75 14                	jne    8020d6 <initialize_MemBlocksList+0x55>
  8020c2:	83 ec 04             	sub    $0x4,%esp
  8020c5:	68 d0 3a 80 00       	push   $0x803ad0
  8020ca:	6a 43                	push   $0x43
  8020cc:	68 f3 3a 80 00       	push   $0x803af3
  8020d1:	e8 94 e2 ff ff       	call   80036a <_panic>
  8020d6:	a1 50 40 80 00       	mov    0x804050,%eax
  8020db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020de:	c1 e2 04             	shl    $0x4,%edx
  8020e1:	01 d0                	add    %edx,%eax
  8020e3:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8020e9:	89 10                	mov    %edx,(%eax)
  8020eb:	8b 00                	mov    (%eax),%eax
  8020ed:	85 c0                	test   %eax,%eax
  8020ef:	74 18                	je     802109 <initialize_MemBlocksList+0x88>
  8020f1:	a1 48 41 80 00       	mov    0x804148,%eax
  8020f6:	8b 15 50 40 80 00    	mov    0x804050,%edx
  8020fc:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8020ff:	c1 e1 04             	shl    $0x4,%ecx
  802102:	01 ca                	add    %ecx,%edx
  802104:	89 50 04             	mov    %edx,0x4(%eax)
  802107:	eb 12                	jmp    80211b <initialize_MemBlocksList+0x9a>
  802109:	a1 50 40 80 00       	mov    0x804050,%eax
  80210e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802111:	c1 e2 04             	shl    $0x4,%edx
  802114:	01 d0                	add    %edx,%eax
  802116:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80211b:	a1 50 40 80 00       	mov    0x804050,%eax
  802120:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802123:	c1 e2 04             	shl    $0x4,%edx
  802126:	01 d0                	add    %edx,%eax
  802128:	a3 48 41 80 00       	mov    %eax,0x804148
  80212d:	a1 50 40 80 00       	mov    0x804050,%eax
  802132:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802135:	c1 e2 04             	shl    $0x4,%edx
  802138:	01 d0                	add    %edx,%eax
  80213a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802141:	a1 54 41 80 00       	mov    0x804154,%eax
  802146:	40                   	inc    %eax
  802147:	a3 54 41 80 00       	mov    %eax,0x804154
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  80214c:	ff 45 f4             	incl   -0xc(%ebp)
  80214f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802152:	3b 45 08             	cmp    0x8(%ebp),%eax
  802155:	0f 82 56 ff ff ff    	jb     8020b1 <initialize_MemBlocksList+0x30>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
		}
}
  80215b:	90                   	nop
  80215c:	c9                   	leave  
  80215d:	c3                   	ret    

0080215e <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80215e:	55                   	push   %ebp
  80215f:	89 e5                	mov    %esp,%ebp
  802161:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  802164:	a1 38 41 80 00       	mov    0x804138,%eax
  802169:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80216c:	eb 18                	jmp    802186 <find_block+0x28>
	{
		if (ele->sva==va)
  80216e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802171:	8b 40 08             	mov    0x8(%eax),%eax
  802174:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802177:	75 05                	jne    80217e <find_block+0x20>
			return ele;
  802179:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80217c:	eb 7b                	jmp    8021f9 <find_block+0x9b>
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  80217e:	a1 40 41 80 00       	mov    0x804140,%eax
  802183:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802186:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80218a:	74 07                	je     802193 <find_block+0x35>
  80218c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80218f:	8b 00                	mov    (%eax),%eax
  802191:	eb 05                	jmp    802198 <find_block+0x3a>
  802193:	b8 00 00 00 00       	mov    $0x0,%eax
  802198:	a3 40 41 80 00       	mov    %eax,0x804140
  80219d:	a1 40 41 80 00       	mov    0x804140,%eax
  8021a2:	85 c0                	test   %eax,%eax
  8021a4:	75 c8                	jne    80216e <find_block+0x10>
  8021a6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021aa:	75 c2                	jne    80216e <find_block+0x10>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  8021ac:	a1 40 40 80 00       	mov    0x804040,%eax
  8021b1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021b4:	eb 18                	jmp    8021ce <find_block+0x70>
	{
		if (ele->sva==va)
  8021b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021b9:	8b 40 08             	mov    0x8(%eax),%eax
  8021bc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8021bf:	75 05                	jne    8021c6 <find_block+0x68>
					return ele;
  8021c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021c4:	eb 33                	jmp    8021f9 <find_block+0x9b>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  8021c6:	a1 48 40 80 00       	mov    0x804048,%eax
  8021cb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021ce:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021d2:	74 07                	je     8021db <find_block+0x7d>
  8021d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021d7:	8b 00                	mov    (%eax),%eax
  8021d9:	eb 05                	jmp    8021e0 <find_block+0x82>
  8021db:	b8 00 00 00 00       	mov    $0x0,%eax
  8021e0:	a3 48 40 80 00       	mov    %eax,0x804048
  8021e5:	a1 48 40 80 00       	mov    0x804048,%eax
  8021ea:	85 c0                	test   %eax,%eax
  8021ec:	75 c8                	jne    8021b6 <find_block+0x58>
  8021ee:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021f2:	75 c2                	jne    8021b6 <find_block+0x58>
	{
		if (ele->sva==va)
					return ele;
	}
return NULL;
  8021f4:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  8021f9:	c9                   	leave  
  8021fa:	c3                   	ret    

008021fb <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8021fb:	55                   	push   %ebp
  8021fc:	89 e5                	mov    %esp,%ebp
  8021fe:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;

int x =LIST_SIZE(&AllocMemBlocksList);
  802201:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802206:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((x==0))
  802209:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80220d:	75 62                	jne    802271 <insert_sorted_allocList+0x76>
	{
	//	blockToInsert=AllocMemBlocksList.lh_first;
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  80220f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802213:	75 14                	jne    802229 <insert_sorted_allocList+0x2e>
  802215:	83 ec 04             	sub    $0x4,%esp
  802218:	68 d0 3a 80 00       	push   $0x803ad0
  80221d:	6a 69                	push   $0x69
  80221f:	68 f3 3a 80 00       	push   $0x803af3
  802224:	e8 41 e1 ff ff       	call   80036a <_panic>
  802229:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80222f:	8b 45 08             	mov    0x8(%ebp),%eax
  802232:	89 10                	mov    %edx,(%eax)
  802234:	8b 45 08             	mov    0x8(%ebp),%eax
  802237:	8b 00                	mov    (%eax),%eax
  802239:	85 c0                	test   %eax,%eax
  80223b:	74 0d                	je     80224a <insert_sorted_allocList+0x4f>
  80223d:	a1 40 40 80 00       	mov    0x804040,%eax
  802242:	8b 55 08             	mov    0x8(%ebp),%edx
  802245:	89 50 04             	mov    %edx,0x4(%eax)
  802248:	eb 08                	jmp    802252 <insert_sorted_allocList+0x57>
  80224a:	8b 45 08             	mov    0x8(%ebp),%eax
  80224d:	a3 44 40 80 00       	mov    %eax,0x804044
  802252:	8b 45 08             	mov    0x8(%ebp),%eax
  802255:	a3 40 40 80 00       	mov    %eax,0x804040
  80225a:	8b 45 08             	mov    0x8(%ebp),%eax
  80225d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802264:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802269:	40                   	inc    %eax
  80226a:	a3 4c 40 80 00       	mov    %eax,0x80404c
  80226f:	eb 72                	jmp    8022e3 <insert_sorted_allocList+0xe8>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
  802271:	a1 40 40 80 00       	mov    0x804040,%eax
  802276:	8b 50 08             	mov    0x8(%eax),%edx
  802279:	8b 45 08             	mov    0x8(%ebp),%eax
  80227c:	8b 40 08             	mov    0x8(%eax),%eax
  80227f:	39 c2                	cmp    %eax,%edx
  802281:	76 60                	jbe    8022e3 <insert_sorted_allocList+0xe8>
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  802283:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802287:	75 14                	jne    80229d <insert_sorted_allocList+0xa2>
  802289:	83 ec 04             	sub    $0x4,%esp
  80228c:	68 d0 3a 80 00       	push   $0x803ad0
  802291:	6a 6d                	push   $0x6d
  802293:	68 f3 3a 80 00       	push   $0x803af3
  802298:	e8 cd e0 ff ff       	call   80036a <_panic>
  80229d:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8022a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a6:	89 10                	mov    %edx,(%eax)
  8022a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ab:	8b 00                	mov    (%eax),%eax
  8022ad:	85 c0                	test   %eax,%eax
  8022af:	74 0d                	je     8022be <insert_sorted_allocList+0xc3>
  8022b1:	a1 40 40 80 00       	mov    0x804040,%eax
  8022b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8022b9:	89 50 04             	mov    %edx,0x4(%eax)
  8022bc:	eb 08                	jmp    8022c6 <insert_sorted_allocList+0xcb>
  8022be:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c1:	a3 44 40 80 00       	mov    %eax,0x804044
  8022c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c9:	a3 40 40 80 00       	mov    %eax,0x804040
  8022ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022d8:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022dd:	40                   	inc    %eax
  8022de:	a3 4c 40 80 00       	mov    %eax,0x80404c
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  8022e3:	a1 40 40 80 00       	mov    0x804040,%eax
  8022e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022eb:	e9 b9 01 00 00       	jmp    8024a9 <insert_sorted_allocList+0x2ae>
	{


		if ((blockToInsert->sva>AllocMemBlocksList.lh_first->sva)&&blockToInsert->sva<element->sva)
  8022f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f3:	8b 50 08             	mov    0x8(%eax),%edx
  8022f6:	a1 40 40 80 00       	mov    0x804040,%eax
  8022fb:	8b 40 08             	mov    0x8(%eax),%eax
  8022fe:	39 c2                	cmp    %eax,%edx
  802300:	76 7c                	jbe    80237e <insert_sorted_allocList+0x183>
  802302:	8b 45 08             	mov    0x8(%ebp),%eax
  802305:	8b 50 08             	mov    0x8(%eax),%edx
  802308:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230b:	8b 40 08             	mov    0x8(%eax),%eax
  80230e:	39 c2                	cmp    %eax,%edx
  802310:	73 6c                	jae    80237e <insert_sorted_allocList+0x183>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,element,blockToInsert);
  802312:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802316:	74 06                	je     80231e <insert_sorted_allocList+0x123>
  802318:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80231c:	75 14                	jne    802332 <insert_sorted_allocList+0x137>
  80231e:	83 ec 04             	sub    $0x4,%esp
  802321:	68 0c 3b 80 00       	push   $0x803b0c
  802326:	6a 75                	push   $0x75
  802328:	68 f3 3a 80 00       	push   $0x803af3
  80232d:	e8 38 e0 ff ff       	call   80036a <_panic>
  802332:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802335:	8b 50 04             	mov    0x4(%eax),%edx
  802338:	8b 45 08             	mov    0x8(%ebp),%eax
  80233b:	89 50 04             	mov    %edx,0x4(%eax)
  80233e:	8b 45 08             	mov    0x8(%ebp),%eax
  802341:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802344:	89 10                	mov    %edx,(%eax)
  802346:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802349:	8b 40 04             	mov    0x4(%eax),%eax
  80234c:	85 c0                	test   %eax,%eax
  80234e:	74 0d                	je     80235d <insert_sorted_allocList+0x162>
  802350:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802353:	8b 40 04             	mov    0x4(%eax),%eax
  802356:	8b 55 08             	mov    0x8(%ebp),%edx
  802359:	89 10                	mov    %edx,(%eax)
  80235b:	eb 08                	jmp    802365 <insert_sorted_allocList+0x16a>
  80235d:	8b 45 08             	mov    0x8(%ebp),%eax
  802360:	a3 40 40 80 00       	mov    %eax,0x804040
  802365:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802368:	8b 55 08             	mov    0x8(%ebp),%edx
  80236b:	89 50 04             	mov    %edx,0x4(%eax)
  80236e:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802373:	40                   	inc    %eax
  802374:	a3 4c 40 80 00       	mov    %eax,0x80404c

		break;}
  802379:	e9 59 01 00 00       	jmp    8024d7 <insert_sorted_allocList+0x2dc>

	else if ((blockToInsert->sva>element->sva)&&(blockToInsert->sva<AllocMemBlocksList.lh_last->sva)&&blockToInsert->sva<LIST_NEXT(element)->sva)
  80237e:	8b 45 08             	mov    0x8(%ebp),%eax
  802381:	8b 50 08             	mov    0x8(%eax),%edx
  802384:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802387:	8b 40 08             	mov    0x8(%eax),%eax
  80238a:	39 c2                	cmp    %eax,%edx
  80238c:	0f 86 98 00 00 00    	jbe    80242a <insert_sorted_allocList+0x22f>
  802392:	8b 45 08             	mov    0x8(%ebp),%eax
  802395:	8b 50 08             	mov    0x8(%eax),%edx
  802398:	a1 44 40 80 00       	mov    0x804044,%eax
  80239d:	8b 40 08             	mov    0x8(%eax),%eax
  8023a0:	39 c2                	cmp    %eax,%edx
  8023a2:	0f 83 82 00 00 00    	jae    80242a <insert_sorted_allocList+0x22f>
  8023a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ab:	8b 50 08             	mov    0x8(%eax),%edx
  8023ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b1:	8b 00                	mov    (%eax),%eax
  8023b3:	8b 40 08             	mov    0x8(%eax),%eax
  8023b6:	39 c2                	cmp    %eax,%edx
  8023b8:	73 70                	jae    80242a <insert_sorted_allocList+0x22f>
	{

	LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  8023ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023be:	74 06                	je     8023c6 <insert_sorted_allocList+0x1cb>
  8023c0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023c4:	75 14                	jne    8023da <insert_sorted_allocList+0x1df>
  8023c6:	83 ec 04             	sub    $0x4,%esp
  8023c9:	68 44 3b 80 00       	push   $0x803b44
  8023ce:	6a 7c                	push   $0x7c
  8023d0:	68 f3 3a 80 00       	push   $0x803af3
  8023d5:	e8 90 df ff ff       	call   80036a <_panic>
  8023da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023dd:	8b 10                	mov    (%eax),%edx
  8023df:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e2:	89 10                	mov    %edx,(%eax)
  8023e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e7:	8b 00                	mov    (%eax),%eax
  8023e9:	85 c0                	test   %eax,%eax
  8023eb:	74 0b                	je     8023f8 <insert_sorted_allocList+0x1fd>
  8023ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f0:	8b 00                	mov    (%eax),%eax
  8023f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8023f5:	89 50 04             	mov    %edx,0x4(%eax)
  8023f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8023fe:	89 10                	mov    %edx,(%eax)
  802400:	8b 45 08             	mov    0x8(%ebp),%eax
  802403:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802406:	89 50 04             	mov    %edx,0x4(%eax)
  802409:	8b 45 08             	mov    0x8(%ebp),%eax
  80240c:	8b 00                	mov    (%eax),%eax
  80240e:	85 c0                	test   %eax,%eax
  802410:	75 08                	jne    80241a <insert_sorted_allocList+0x21f>
  802412:	8b 45 08             	mov    0x8(%ebp),%eax
  802415:	a3 44 40 80 00       	mov    %eax,0x804044
  80241a:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80241f:	40                   	inc    %eax
  802420:	a3 4c 40 80 00       	mov    %eax,0x80404c
		break;
  802425:	e9 ad 00 00 00       	jmp    8024d7 <insert_sorted_allocList+0x2dc>
	}else if (blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  80242a:	8b 45 08             	mov    0x8(%ebp),%eax
  80242d:	8b 50 08             	mov    0x8(%eax),%edx
  802430:	a1 44 40 80 00       	mov    0x804044,%eax
  802435:	8b 40 08             	mov    0x8(%eax),%eax
  802438:	39 c2                	cmp    %eax,%edx
  80243a:	76 65                	jbe    8024a1 <insert_sorted_allocList+0x2a6>
	{
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
  80243c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802440:	75 17                	jne    802459 <insert_sorted_allocList+0x25e>
  802442:	83 ec 04             	sub    $0x4,%esp
  802445:	68 78 3b 80 00       	push   $0x803b78
  80244a:	68 80 00 00 00       	push   $0x80
  80244f:	68 f3 3a 80 00       	push   $0x803af3
  802454:	e8 11 df ff ff       	call   80036a <_panic>
  802459:	8b 15 44 40 80 00    	mov    0x804044,%edx
  80245f:	8b 45 08             	mov    0x8(%ebp),%eax
  802462:	89 50 04             	mov    %edx,0x4(%eax)
  802465:	8b 45 08             	mov    0x8(%ebp),%eax
  802468:	8b 40 04             	mov    0x4(%eax),%eax
  80246b:	85 c0                	test   %eax,%eax
  80246d:	74 0c                	je     80247b <insert_sorted_allocList+0x280>
  80246f:	a1 44 40 80 00       	mov    0x804044,%eax
  802474:	8b 55 08             	mov    0x8(%ebp),%edx
  802477:	89 10                	mov    %edx,(%eax)
  802479:	eb 08                	jmp    802483 <insert_sorted_allocList+0x288>
  80247b:	8b 45 08             	mov    0x8(%ebp),%eax
  80247e:	a3 40 40 80 00       	mov    %eax,0x804040
  802483:	8b 45 08             	mov    0x8(%ebp),%eax
  802486:	a3 44 40 80 00       	mov    %eax,0x804044
  80248b:	8b 45 08             	mov    0x8(%ebp),%eax
  80248e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802494:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802499:	40                   	inc    %eax
  80249a:	a3 4c 40 80 00       	mov    %eax,0x80404c
		break;
  80249f:	eb 36                	jmp    8024d7 <insert_sorted_allocList+0x2dc>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  8024a1:	a1 48 40 80 00       	mov    0x804048,%eax
  8024a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024ad:	74 07                	je     8024b6 <insert_sorted_allocList+0x2bb>
  8024af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b2:	8b 00                	mov    (%eax),%eax
  8024b4:	eb 05                	jmp    8024bb <insert_sorted_allocList+0x2c0>
  8024b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8024bb:	a3 48 40 80 00       	mov    %eax,0x804048
  8024c0:	a1 48 40 80 00       	mov    0x804048,%eax
  8024c5:	85 c0                	test   %eax,%eax
  8024c7:	0f 85 23 fe ff ff    	jne    8022f0 <insert_sorted_allocList+0xf5>
  8024cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024d1:	0f 85 19 fe ff ff    	jne    8022f0 <insert_sorted_allocList+0xf5>
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
		break;

	}
	}
}
  8024d7:	90                   	nop
  8024d8:	c9                   	leave  
  8024d9:	c3                   	ret    

008024da <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8024da:	55                   	push   %ebp
  8024db:	89 e5                	mov    %esp,%ebp
  8024dd:	83 ec 18             	sub    $0x18,%esp
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  8024e0:	a1 38 41 80 00       	mov    0x804138,%eax
  8024e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024e8:	e9 7c 01 00 00       	jmp    802669 <alloc_block_FF+0x18f>
		{
			// case 2
				if(element->size == size)
  8024ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f0:	8b 40 0c             	mov    0xc(%eax),%eax
  8024f3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024f6:	0f 85 90 00 00 00    	jne    80258c <alloc_block_FF+0xb2>
				{
					tmp_block=element;
  8024fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,element);
  802502:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802506:	75 17                	jne    80251f <alloc_block_FF+0x45>
  802508:	83 ec 04             	sub    $0x4,%esp
  80250b:	68 9b 3b 80 00       	push   $0x803b9b
  802510:	68 ba 00 00 00       	push   $0xba
  802515:	68 f3 3a 80 00       	push   $0x803af3
  80251a:	e8 4b de ff ff       	call   80036a <_panic>
  80251f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802522:	8b 00                	mov    (%eax),%eax
  802524:	85 c0                	test   %eax,%eax
  802526:	74 10                	je     802538 <alloc_block_FF+0x5e>
  802528:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252b:	8b 00                	mov    (%eax),%eax
  80252d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802530:	8b 52 04             	mov    0x4(%edx),%edx
  802533:	89 50 04             	mov    %edx,0x4(%eax)
  802536:	eb 0b                	jmp    802543 <alloc_block_FF+0x69>
  802538:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253b:	8b 40 04             	mov    0x4(%eax),%eax
  80253e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802543:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802546:	8b 40 04             	mov    0x4(%eax),%eax
  802549:	85 c0                	test   %eax,%eax
  80254b:	74 0f                	je     80255c <alloc_block_FF+0x82>
  80254d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802550:	8b 40 04             	mov    0x4(%eax),%eax
  802553:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802556:	8b 12                	mov    (%edx),%edx
  802558:	89 10                	mov    %edx,(%eax)
  80255a:	eb 0a                	jmp    802566 <alloc_block_FF+0x8c>
  80255c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255f:	8b 00                	mov    (%eax),%eax
  802561:	a3 38 41 80 00       	mov    %eax,0x804138
  802566:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802569:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80256f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802572:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802579:	a1 44 41 80 00       	mov    0x804144,%eax
  80257e:	48                   	dec    %eax
  80257f:	a3 44 41 80 00       	mov    %eax,0x804144
					return tmp_block;
  802584:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802587:	e9 10 01 00 00       	jmp    80269c <alloc_block_FF+0x1c2>
				}
				 // case 3
				else if(element->size > size)
  80258c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258f:	8b 40 0c             	mov    0xc(%eax),%eax
  802592:	3b 45 08             	cmp    0x8(%ebp),%eax
  802595:	0f 86 c6 00 00 00    	jbe    802661 <alloc_block_FF+0x187>
				{
					// the new block are created
					tmp_block = AvailableMemBlocksList.lh_first ;
  80259b:	a1 48 41 80 00       	mov    0x804148,%eax
  8025a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  8025a3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025a7:	75 17                	jne    8025c0 <alloc_block_FF+0xe6>
  8025a9:	83 ec 04             	sub    $0x4,%esp
  8025ac:	68 9b 3b 80 00       	push   $0x803b9b
  8025b1:	68 c2 00 00 00       	push   $0xc2
  8025b6:	68 f3 3a 80 00       	push   $0x803af3
  8025bb:	e8 aa dd ff ff       	call   80036a <_panic>
  8025c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025c3:	8b 00                	mov    (%eax),%eax
  8025c5:	85 c0                	test   %eax,%eax
  8025c7:	74 10                	je     8025d9 <alloc_block_FF+0xff>
  8025c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025cc:	8b 00                	mov    (%eax),%eax
  8025ce:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025d1:	8b 52 04             	mov    0x4(%edx),%edx
  8025d4:	89 50 04             	mov    %edx,0x4(%eax)
  8025d7:	eb 0b                	jmp    8025e4 <alloc_block_FF+0x10a>
  8025d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025dc:	8b 40 04             	mov    0x4(%eax),%eax
  8025df:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8025e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025e7:	8b 40 04             	mov    0x4(%eax),%eax
  8025ea:	85 c0                	test   %eax,%eax
  8025ec:	74 0f                	je     8025fd <alloc_block_FF+0x123>
  8025ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025f1:	8b 40 04             	mov    0x4(%eax),%eax
  8025f4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025f7:	8b 12                	mov    (%edx),%edx
  8025f9:	89 10                	mov    %edx,(%eax)
  8025fb:	eb 0a                	jmp    802607 <alloc_block_FF+0x12d>
  8025fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802600:	8b 00                	mov    (%eax),%eax
  802602:	a3 48 41 80 00       	mov    %eax,0x804148
  802607:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80260a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802610:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802613:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80261a:	a1 54 41 80 00       	mov    0x804154,%eax
  80261f:	48                   	dec    %eax
  802620:	a3 54 41 80 00       	mov    %eax,0x804154
					tmp_block->sva=element->sva;
  802625:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802628:	8b 50 08             	mov    0x8(%eax),%edx
  80262b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80262e:	89 50 08             	mov    %edx,0x8(%eax)
					tmp_block->size=size;
  802631:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802634:	8b 55 08             	mov    0x8(%ebp),%edx
  802637:	89 50 0c             	mov    %edx,0xc(%eax)
					//update block with remaining space
					element->size-=size;
  80263a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263d:	8b 40 0c             	mov    0xc(%eax),%eax
  802640:	2b 45 08             	sub    0x8(%ebp),%eax
  802643:	89 c2                	mov    %eax,%edx
  802645:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802648:	89 50 0c             	mov    %edx,0xc(%eax)
					element->sva = element->sva + size;
  80264b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264e:	8b 50 08             	mov    0x8(%eax),%edx
  802651:	8b 45 08             	mov    0x8(%ebp),%eax
  802654:	01 c2                	add    %eax,%edx
  802656:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802659:	89 50 08             	mov    %edx,0x8(%eax)
					// return back the new block
					return tmp_block ;
  80265c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80265f:	eb 3b                	jmp    80269c <alloc_block_FF+0x1c2>
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802661:	a1 40 41 80 00       	mov    0x804140,%eax
  802666:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802669:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80266d:	74 07                	je     802676 <alloc_block_FF+0x19c>
  80266f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802672:	8b 00                	mov    (%eax),%eax
  802674:	eb 05                	jmp    80267b <alloc_block_FF+0x1a1>
  802676:	b8 00 00 00 00       	mov    $0x0,%eax
  80267b:	a3 40 41 80 00       	mov    %eax,0x804140
  802680:	a1 40 41 80 00       	mov    0x804140,%eax
  802685:	85 c0                	test   %eax,%eax
  802687:	0f 85 60 fe ff ff    	jne    8024ed <alloc_block_FF+0x13>
  80268d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802691:	0f 85 56 fe ff ff    	jne    8024ed <alloc_block_FF+0x13>
					// return back the new block
					return tmp_block ;
				}
		}
		// case 1
	  return NULL ;}
  802697:	b8 00 00 00 00       	mov    $0x0,%eax
  80269c:	c9                   	leave  
  80269d:	c3                   	ret    

0080269e <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================

struct MemBlock *alloc_block_BF(uint32 size)
{
  80269e:	55                   	push   %ebp
  80269f:	89 e5                	mov    %esp,%ebp
  8026a1:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
  8026a4:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		LIST_FOREACH(element, &(FreeMemBlocksList))
  8026ab:	a1 38 41 80 00       	mov    0x804138,%eax
  8026b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026b3:	eb 3a                	jmp    8026ef <alloc_block_BF+0x51>
		{
			if(element->size >= size)
  8026b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b8:	8b 40 0c             	mov    0xc(%eax),%eax
  8026bb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026be:	72 27                	jb     8026e7 <alloc_block_BF+0x49>
			{
				if(best_size==-1)
  8026c0:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8026c4:	75 0b                	jne    8026d1 <alloc_block_BF+0x33>
					best_size= element->size;
  8026c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8026cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8026cf:	eb 16                	jmp    8026e7 <alloc_block_BF+0x49>
				else if(best_size >= element->size)
  8026d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d4:	8b 50 0c             	mov    0xc(%eax),%edx
  8026d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026da:	39 c2                	cmp    %eax,%edx
  8026dc:	77 09                	ja     8026e7 <alloc_block_BF+0x49>
					best_size=element->size;
  8026de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8026e4:	89 45 f0             	mov    %eax,-0x10(%ebp)

struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  8026e7:	a1 40 41 80 00       	mov    0x804140,%eax
  8026ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026f3:	74 07                	je     8026fc <alloc_block_BF+0x5e>
  8026f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f8:	8b 00                	mov    (%eax),%eax
  8026fa:	eb 05                	jmp    802701 <alloc_block_BF+0x63>
  8026fc:	b8 00 00 00 00       	mov    $0x0,%eax
  802701:	a3 40 41 80 00       	mov    %eax,0x804140
  802706:	a1 40 41 80 00       	mov    0x804140,%eax
  80270b:	85 c0                	test   %eax,%eax
  80270d:	75 a6                	jne    8026b5 <alloc_block_BF+0x17>
  80270f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802713:	75 a0                	jne    8026b5 <alloc_block_BF+0x17>
					best_size= element->size;
				else if(best_size >= element->size)
					best_size=element->size;
			}
		}
		if(best_size != -1)
  802715:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802719:	0f 84 d3 01 00 00    	je     8028f2 <alloc_block_BF+0x254>
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  80271f:	a1 38 41 80 00       	mov    0x804138,%eax
  802724:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802727:	e9 98 01 00 00       	jmp    8028c4 <alloc_block_BF+0x226>
			{
			 if((best_size > size) && (best_size == element->size))
  80272c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80272f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802732:	0f 86 da 00 00 00    	jbe    802812 <alloc_block_BF+0x174>
  802738:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273b:	8b 50 0c             	mov    0xc(%eax),%edx
  80273e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802741:	39 c2                	cmp    %eax,%edx
  802743:	0f 85 c9 00 00 00    	jne    802812 <alloc_block_BF+0x174>
			  {
				// the new block are created
			    tmp_block = AvailableMemBlocksList.lh_first ;
  802749:	a1 48 41 80 00       	mov    0x804148,%eax
  80274e:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  802751:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802755:	75 17                	jne    80276e <alloc_block_BF+0xd0>
  802757:	83 ec 04             	sub    $0x4,%esp
  80275a:	68 9b 3b 80 00       	push   $0x803b9b
  80275f:	68 ea 00 00 00       	push   $0xea
  802764:	68 f3 3a 80 00       	push   $0x803af3
  802769:	e8 fc db ff ff       	call   80036a <_panic>
  80276e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802771:	8b 00                	mov    (%eax),%eax
  802773:	85 c0                	test   %eax,%eax
  802775:	74 10                	je     802787 <alloc_block_BF+0xe9>
  802777:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80277a:	8b 00                	mov    (%eax),%eax
  80277c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80277f:	8b 52 04             	mov    0x4(%edx),%edx
  802782:	89 50 04             	mov    %edx,0x4(%eax)
  802785:	eb 0b                	jmp    802792 <alloc_block_BF+0xf4>
  802787:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80278a:	8b 40 04             	mov    0x4(%eax),%eax
  80278d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802792:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802795:	8b 40 04             	mov    0x4(%eax),%eax
  802798:	85 c0                	test   %eax,%eax
  80279a:	74 0f                	je     8027ab <alloc_block_BF+0x10d>
  80279c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80279f:	8b 40 04             	mov    0x4(%eax),%eax
  8027a2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027a5:	8b 12                	mov    (%edx),%edx
  8027a7:	89 10                	mov    %edx,(%eax)
  8027a9:	eb 0a                	jmp    8027b5 <alloc_block_BF+0x117>
  8027ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027ae:	8b 00                	mov    (%eax),%eax
  8027b0:	a3 48 41 80 00       	mov    %eax,0x804148
  8027b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027c1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027c8:	a1 54 41 80 00       	mov    0x804154,%eax
  8027cd:	48                   	dec    %eax
  8027ce:	a3 54 41 80 00       	mov    %eax,0x804154
				tmp_block->sva=element->sva;
  8027d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d6:	8b 50 08             	mov    0x8(%eax),%edx
  8027d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027dc:	89 50 08             	mov    %edx,0x8(%eax)
				tmp_block->size=size;
  8027df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8027e5:	89 50 0c             	mov    %edx,0xc(%eax)
				//update block with remaining space
				element->size-=size;
  8027e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027eb:	8b 40 0c             	mov    0xc(%eax),%eax
  8027ee:	2b 45 08             	sub    0x8(%ebp),%eax
  8027f1:	89 c2                	mov    %eax,%edx
  8027f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f6:	89 50 0c             	mov    %edx,0xc(%eax)
				element->sva = element->sva + size;
  8027f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fc:	8b 50 08             	mov    0x8(%eax),%edx
  8027ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802802:	01 c2                	add    %eax,%edx
  802804:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802807:	89 50 08             	mov    %edx,0x8(%eax)
				// return back the new block
				return tmp_block ;
  80280a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80280d:	e9 e5 00 00 00       	jmp    8028f7 <alloc_block_BF+0x259>

			  }
			else if((element->size == best_size)&&(best_size == size))
  802812:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802815:	8b 50 0c             	mov    0xc(%eax),%edx
  802818:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80281b:	39 c2                	cmp    %eax,%edx
  80281d:	0f 85 99 00 00 00    	jne    8028bc <alloc_block_BF+0x21e>
  802823:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802826:	3b 45 08             	cmp    0x8(%ebp),%eax
  802829:	0f 85 8d 00 00 00    	jne    8028bc <alloc_block_BF+0x21e>
			  {
				tmp_block=element;
  80282f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802832:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&FreeMemBlocksList,element);
  802835:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802839:	75 17                	jne    802852 <alloc_block_BF+0x1b4>
  80283b:	83 ec 04             	sub    $0x4,%esp
  80283e:	68 9b 3b 80 00       	push   $0x803b9b
  802843:	68 f7 00 00 00       	push   $0xf7
  802848:	68 f3 3a 80 00       	push   $0x803af3
  80284d:	e8 18 db ff ff       	call   80036a <_panic>
  802852:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802855:	8b 00                	mov    (%eax),%eax
  802857:	85 c0                	test   %eax,%eax
  802859:	74 10                	je     80286b <alloc_block_BF+0x1cd>
  80285b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285e:	8b 00                	mov    (%eax),%eax
  802860:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802863:	8b 52 04             	mov    0x4(%edx),%edx
  802866:	89 50 04             	mov    %edx,0x4(%eax)
  802869:	eb 0b                	jmp    802876 <alloc_block_BF+0x1d8>
  80286b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286e:	8b 40 04             	mov    0x4(%eax),%eax
  802871:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802876:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802879:	8b 40 04             	mov    0x4(%eax),%eax
  80287c:	85 c0                	test   %eax,%eax
  80287e:	74 0f                	je     80288f <alloc_block_BF+0x1f1>
  802880:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802883:	8b 40 04             	mov    0x4(%eax),%eax
  802886:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802889:	8b 12                	mov    (%edx),%edx
  80288b:	89 10                	mov    %edx,(%eax)
  80288d:	eb 0a                	jmp    802899 <alloc_block_BF+0x1fb>
  80288f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802892:	8b 00                	mov    (%eax),%eax
  802894:	a3 38 41 80 00       	mov    %eax,0x804138
  802899:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028ac:	a1 44 41 80 00       	mov    0x804144,%eax
  8028b1:	48                   	dec    %eax
  8028b2:	a3 44 41 80 00       	mov    %eax,0x804144
				return tmp_block;
  8028b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ba:	eb 3b                	jmp    8028f7 <alloc_block_BF+0x259>
					best_size=element->size;
			}
		}
		if(best_size != -1)
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  8028bc:	a1 40 41 80 00       	mov    0x804140,%eax
  8028c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028c8:	74 07                	je     8028d1 <alloc_block_BF+0x233>
  8028ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cd:	8b 00                	mov    (%eax),%eax
  8028cf:	eb 05                	jmp    8028d6 <alloc_block_BF+0x238>
  8028d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8028d6:	a3 40 41 80 00       	mov    %eax,0x804140
  8028db:	a1 40 41 80 00       	mov    0x804140,%eax
  8028e0:	85 c0                	test   %eax,%eax
  8028e2:	0f 85 44 fe ff ff    	jne    80272c <alloc_block_BF+0x8e>
  8028e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028ec:	0f 85 3a fe ff ff    	jne    80272c <alloc_block_BF+0x8e>
				LIST_REMOVE(&FreeMemBlocksList,element);
				return tmp_block;
			 }
			}
		}
		return NULL ;}
  8028f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8028f7:	c9                   	leave  
  8028f8:	c3                   	ret    

008028f9 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8028f9:	55                   	push   %ebp
  8028fa:	89 e5                	mov    %esp,%ebp
  8028fc:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  8028ff:	83 ec 04             	sub    $0x4,%esp
  802902:	68 bc 3b 80 00       	push   $0x803bbc
  802907:	68 04 01 00 00       	push   $0x104
  80290c:	68 f3 3a 80 00       	push   $0x803af3
  802911:	e8 54 da ff ff       	call   80036a <_panic>

00802916 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{struct MemBlock * blk_itr;
  802916:	55                   	push   %ebp
  802917:	89 e5                	mov    %esp,%ebp
  802919:	83 ec 18             	sub    $0x18,%esp
struct MemBlock * next;
struct MemBlock * first = LIST_FIRST(&(FreeMemBlocksList));
  80291c:	a1 38 41 80 00       	mov    0x804138,%eax
  802921:	89 45 f0             	mov    %eax,-0x10(%ebp)
struct MemBlock * last = LIST_LAST(&(FreeMemBlocksList));
  802924:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802929:	89 45 ec             	mov    %eax,-0x14(%ebp)

if(LIST_EMPTY(&(FreeMemBlocksList)))
  80292c:	a1 38 41 80 00       	mov    0x804138,%eax
  802931:	85 c0                	test   %eax,%eax
  802933:	75 68                	jne    80299d <insert_sorted_with_merge_freeList+0x87>
			{

				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  802935:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802939:	75 17                	jne    802952 <insert_sorted_with_merge_freeList+0x3c>
  80293b:	83 ec 04             	sub    $0x4,%esp
  80293e:	68 d0 3a 80 00       	push   $0x803ad0
  802943:	68 14 01 00 00       	push   $0x114
  802948:	68 f3 3a 80 00       	push   $0x803af3
  80294d:	e8 18 da ff ff       	call   80036a <_panic>
  802952:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802958:	8b 45 08             	mov    0x8(%ebp),%eax
  80295b:	89 10                	mov    %edx,(%eax)
  80295d:	8b 45 08             	mov    0x8(%ebp),%eax
  802960:	8b 00                	mov    (%eax),%eax
  802962:	85 c0                	test   %eax,%eax
  802964:	74 0d                	je     802973 <insert_sorted_with_merge_freeList+0x5d>
  802966:	a1 38 41 80 00       	mov    0x804138,%eax
  80296b:	8b 55 08             	mov    0x8(%ebp),%edx
  80296e:	89 50 04             	mov    %edx,0x4(%eax)
  802971:	eb 08                	jmp    80297b <insert_sorted_with_merge_freeList+0x65>
  802973:	8b 45 08             	mov    0x8(%ebp),%eax
  802976:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80297b:	8b 45 08             	mov    0x8(%ebp),%eax
  80297e:	a3 38 41 80 00       	mov    %eax,0x804138
  802983:	8b 45 08             	mov    0x8(%ebp),%eax
  802986:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80298d:	a1 44 41 80 00       	mov    0x804144,%eax
  802992:	40                   	inc    %eax
  802993:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  802998:	e9 d2 06 00 00       	jmp    80306f <insert_sorted_with_merge_freeList+0x759>
				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);

			}
else
{
	if( blockToInsert->sva  < first->sva )
  80299d:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a0:	8b 50 08             	mov    0x8(%eax),%edx
  8029a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a6:	8b 40 08             	mov    0x8(%eax),%eax
  8029a9:	39 c2                	cmp    %eax,%edx
  8029ab:	0f 83 22 01 00 00    	jae    802ad3 <insert_sorted_with_merge_freeList+0x1bd>
	{
                if( blockToInsert->sva + blockToInsert->size == first->sva)
  8029b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b4:	8b 50 08             	mov    0x8(%eax),%edx
  8029b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8029bd:	01 c2                	add    %eax,%edx
  8029bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c2:	8b 40 08             	mov    0x8(%eax),%eax
  8029c5:	39 c2                	cmp    %eax,%edx
  8029c7:	0f 85 9e 00 00 00    	jne    802a6b <insert_sorted_with_merge_freeList+0x155>
                {

                	first->sva = blockToInsert->sva;
  8029cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d0:	8b 50 08             	mov    0x8(%eax),%edx
  8029d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d6:	89 50 08             	mov    %edx,0x8(%eax)
                	first->size = first->size + blockToInsert->size;
  8029d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029dc:	8b 50 0c             	mov    0xc(%eax),%edx
  8029df:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8029e5:	01 c2                	add    %eax,%edx
  8029e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ea:	89 50 0c             	mov    %edx,0xc(%eax)
                	blockToInsert->size = blockToInsert->sva = 0;
  8029ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8029f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029fa:	8b 50 08             	mov    0x8(%eax),%edx
  8029fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802a00:	89 50 0c             	mov    %edx,0xc(%eax)
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802a03:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a07:	75 17                	jne    802a20 <insert_sorted_with_merge_freeList+0x10a>
  802a09:	83 ec 04             	sub    $0x4,%esp
  802a0c:	68 d0 3a 80 00       	push   $0x803ad0
  802a11:	68 21 01 00 00       	push   $0x121
  802a16:	68 f3 3a 80 00       	push   $0x803af3
  802a1b:	e8 4a d9 ff ff       	call   80036a <_panic>
  802a20:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802a26:	8b 45 08             	mov    0x8(%ebp),%eax
  802a29:	89 10                	mov    %edx,(%eax)
  802a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2e:	8b 00                	mov    (%eax),%eax
  802a30:	85 c0                	test   %eax,%eax
  802a32:	74 0d                	je     802a41 <insert_sorted_with_merge_freeList+0x12b>
  802a34:	a1 48 41 80 00       	mov    0x804148,%eax
  802a39:	8b 55 08             	mov    0x8(%ebp),%edx
  802a3c:	89 50 04             	mov    %edx,0x4(%eax)
  802a3f:	eb 08                	jmp    802a49 <insert_sorted_with_merge_freeList+0x133>
  802a41:	8b 45 08             	mov    0x8(%ebp),%eax
  802a44:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a49:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4c:	a3 48 41 80 00       	mov    %eax,0x804148
  802a51:	8b 45 08             	mov    0x8(%ebp),%eax
  802a54:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a5b:	a1 54 41 80 00       	mov    0x804154,%eax
  802a60:	40                   	inc    %eax
  802a61:	a3 54 41 80 00       	mov    %eax,0x804154
						}
				}
        }

}
}
  802a66:	e9 04 06 00 00       	jmp    80306f <insert_sorted_with_merge_freeList+0x759>
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
                }

                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  802a6b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a6f:	75 17                	jne    802a88 <insert_sorted_with_merge_freeList+0x172>
  802a71:	83 ec 04             	sub    $0x4,%esp
  802a74:	68 d0 3a 80 00       	push   $0x803ad0
  802a79:	68 26 01 00 00       	push   $0x126
  802a7e:	68 f3 3a 80 00       	push   $0x803af3
  802a83:	e8 e2 d8 ff ff       	call   80036a <_panic>
  802a88:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a91:	89 10                	mov    %edx,(%eax)
  802a93:	8b 45 08             	mov    0x8(%ebp),%eax
  802a96:	8b 00                	mov    (%eax),%eax
  802a98:	85 c0                	test   %eax,%eax
  802a9a:	74 0d                	je     802aa9 <insert_sorted_with_merge_freeList+0x193>
  802a9c:	a1 38 41 80 00       	mov    0x804138,%eax
  802aa1:	8b 55 08             	mov    0x8(%ebp),%edx
  802aa4:	89 50 04             	mov    %edx,0x4(%eax)
  802aa7:	eb 08                	jmp    802ab1 <insert_sorted_with_merge_freeList+0x19b>
  802aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  802aac:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab4:	a3 38 41 80 00       	mov    %eax,0x804138
  802ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  802abc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ac3:	a1 44 41 80 00       	mov    0x804144,%eax
  802ac8:	40                   	inc    %eax
  802ac9:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  802ace:	e9 9c 05 00 00       	jmp    80306f <insert_sorted_with_merge_freeList+0x759>
                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
                }
	}
    else if(blockToInsert->sva > last->sva)
  802ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad6:	8b 50 08             	mov    0x8(%eax),%edx
  802ad9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802adc:	8b 40 08             	mov    0x8(%eax),%eax
  802adf:	39 c2                	cmp    %eax,%edx
  802ae1:	0f 86 16 01 00 00    	jbe    802bfd <insert_sorted_with_merge_freeList+0x2e7>
 	{

				if(last->sva + last->size == blockToInsert->sva)
  802ae7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aea:	8b 50 08             	mov    0x8(%eax),%edx
  802aed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802af0:	8b 40 0c             	mov    0xc(%eax),%eax
  802af3:	01 c2                	add    %eax,%edx
  802af5:	8b 45 08             	mov    0x8(%ebp),%eax
  802af8:	8b 40 08             	mov    0x8(%eax),%eax
  802afb:	39 c2                	cmp    %eax,%edx
  802afd:	0f 85 92 00 00 00    	jne    802b95 <insert_sorted_with_merge_freeList+0x27f>
				{

					last->size = last->size + blockToInsert->size;
  802b03:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b06:	8b 50 0c             	mov    0xc(%eax),%edx
  802b09:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0c:	8b 40 0c             	mov    0xc(%eax),%eax
  802b0f:	01 c2                	add    %eax,%edx
  802b11:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b14:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->size = blockToInsert->sva = 0;
  802b17:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802b21:	8b 45 08             	mov    0x8(%ebp),%eax
  802b24:	8b 50 08             	mov    0x8(%eax),%edx
  802b27:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2a:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802b2d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b31:	75 17                	jne    802b4a <insert_sorted_with_merge_freeList+0x234>
  802b33:	83 ec 04             	sub    $0x4,%esp
  802b36:	68 d0 3a 80 00       	push   $0x803ad0
  802b3b:	68 31 01 00 00       	push   $0x131
  802b40:	68 f3 3a 80 00       	push   $0x803af3
  802b45:	e8 20 d8 ff ff       	call   80036a <_panic>
  802b4a:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b50:	8b 45 08             	mov    0x8(%ebp),%eax
  802b53:	89 10                	mov    %edx,(%eax)
  802b55:	8b 45 08             	mov    0x8(%ebp),%eax
  802b58:	8b 00                	mov    (%eax),%eax
  802b5a:	85 c0                	test   %eax,%eax
  802b5c:	74 0d                	je     802b6b <insert_sorted_with_merge_freeList+0x255>
  802b5e:	a1 48 41 80 00       	mov    0x804148,%eax
  802b63:	8b 55 08             	mov    0x8(%ebp),%edx
  802b66:	89 50 04             	mov    %edx,0x4(%eax)
  802b69:	eb 08                	jmp    802b73 <insert_sorted_with_merge_freeList+0x25d>
  802b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b73:	8b 45 08             	mov    0x8(%ebp),%eax
  802b76:	a3 48 41 80 00       	mov    %eax,0x804148
  802b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b85:	a1 54 41 80 00       	mov    0x804154,%eax
  802b8a:	40                   	inc    %eax
  802b8b:	a3 54 41 80 00       	mov    %eax,0x804154
						}
				}
        }

}
}
  802b90:	e9 da 04 00 00       	jmp    80306f <insert_sorted_with_merge_freeList+0x759>

				}

				else
				{
					LIST_INSERT_TAIL(&(FreeMemBlocksList),  blockToInsert);
  802b95:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b99:	75 17                	jne    802bb2 <insert_sorted_with_merge_freeList+0x29c>
  802b9b:	83 ec 04             	sub    $0x4,%esp
  802b9e:	68 78 3b 80 00       	push   $0x803b78
  802ba3:	68 37 01 00 00       	push   $0x137
  802ba8:	68 f3 3a 80 00       	push   $0x803af3
  802bad:	e8 b8 d7 ff ff       	call   80036a <_panic>
  802bb2:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbb:	89 50 04             	mov    %edx,0x4(%eax)
  802bbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc1:	8b 40 04             	mov    0x4(%eax),%eax
  802bc4:	85 c0                	test   %eax,%eax
  802bc6:	74 0c                	je     802bd4 <insert_sorted_with_merge_freeList+0x2be>
  802bc8:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802bcd:	8b 55 08             	mov    0x8(%ebp),%edx
  802bd0:	89 10                	mov    %edx,(%eax)
  802bd2:	eb 08                	jmp    802bdc <insert_sorted_with_merge_freeList+0x2c6>
  802bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd7:	a3 38 41 80 00       	mov    %eax,0x804138
  802bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdf:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802be4:	8b 45 08             	mov    0x8(%ebp),%eax
  802be7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bed:	a1 44 41 80 00       	mov    0x804144,%eax
  802bf2:	40                   	inc    %eax
  802bf3:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  802bf8:	e9 72 04 00 00       	jmp    80306f <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  802bfd:	a1 38 41 80 00       	mov    0x804138,%eax
  802c02:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c05:	e9 35 04 00 00       	jmp    80303f <insert_sorted_with_merge_freeList+0x729>
				{
				     next=LIST_NEXT(blk_itr);
  802c0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0d:	8b 00                	mov    (%eax),%eax
  802c0f:	89 45 e8             	mov    %eax,-0x18(%ebp)


					if( (blockToInsert->sva > blk_itr->sva) )
  802c12:	8b 45 08             	mov    0x8(%ebp),%eax
  802c15:	8b 50 08             	mov    0x8(%eax),%edx
  802c18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1b:	8b 40 08             	mov    0x8(%eax),%eax
  802c1e:	39 c2                	cmp    %eax,%edx
  802c20:	0f 86 11 04 00 00    	jbe    803037 <insert_sorted_with_merge_freeList+0x721>
						{
							if(((blk_itr->sva) + (blk_itr->size) < blockToInsert->sva && (blockToInsert->sva) + (blockToInsert->size) < next->sva))
  802c26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c29:	8b 50 08             	mov    0x8(%eax),%edx
  802c2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2f:	8b 40 0c             	mov    0xc(%eax),%eax
  802c32:	01 c2                	add    %eax,%edx
  802c34:	8b 45 08             	mov    0x8(%ebp),%eax
  802c37:	8b 40 08             	mov    0x8(%eax),%eax
  802c3a:	39 c2                	cmp    %eax,%edx
  802c3c:	0f 83 8b 00 00 00    	jae    802ccd <insert_sorted_with_merge_freeList+0x3b7>
  802c42:	8b 45 08             	mov    0x8(%ebp),%eax
  802c45:	8b 50 08             	mov    0x8(%eax),%edx
  802c48:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4b:	8b 40 0c             	mov    0xc(%eax),%eax
  802c4e:	01 c2                	add    %eax,%edx
  802c50:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c53:	8b 40 08             	mov    0x8(%eax),%eax
  802c56:	39 c2                	cmp    %eax,%edx
  802c58:	73 73                	jae    802ccd <insert_sorted_with_merge_freeList+0x3b7>
							{
								LIST_INSERT_AFTER(&(FreeMemBlocksList), blk_itr, blockToInsert);
  802c5a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c5e:	74 06                	je     802c66 <insert_sorted_with_merge_freeList+0x350>
  802c60:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c64:	75 17                	jne    802c7d <insert_sorted_with_merge_freeList+0x367>
  802c66:	83 ec 04             	sub    $0x4,%esp
  802c69:	68 44 3b 80 00       	push   $0x803b44
  802c6e:	68 48 01 00 00       	push   $0x148
  802c73:	68 f3 3a 80 00       	push   $0x803af3
  802c78:	e8 ed d6 ff ff       	call   80036a <_panic>
  802c7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c80:	8b 10                	mov    (%eax),%edx
  802c82:	8b 45 08             	mov    0x8(%ebp),%eax
  802c85:	89 10                	mov    %edx,(%eax)
  802c87:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8a:	8b 00                	mov    (%eax),%eax
  802c8c:	85 c0                	test   %eax,%eax
  802c8e:	74 0b                	je     802c9b <insert_sorted_with_merge_freeList+0x385>
  802c90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c93:	8b 00                	mov    (%eax),%eax
  802c95:	8b 55 08             	mov    0x8(%ebp),%edx
  802c98:	89 50 04             	mov    %edx,0x4(%eax)
  802c9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9e:	8b 55 08             	mov    0x8(%ebp),%edx
  802ca1:	89 10                	mov    %edx,(%eax)
  802ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ca9:	89 50 04             	mov    %edx,0x4(%eax)
  802cac:	8b 45 08             	mov    0x8(%ebp),%eax
  802caf:	8b 00                	mov    (%eax),%eax
  802cb1:	85 c0                	test   %eax,%eax
  802cb3:	75 08                	jne    802cbd <insert_sorted_with_merge_freeList+0x3a7>
  802cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb8:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802cbd:	a1 44 41 80 00       	mov    0x804144,%eax
  802cc2:	40                   	inc    %eax
  802cc3:	a3 44 41 80 00       	mov    %eax,0x804144
								break;
  802cc8:	e9 a2 03 00 00       	jmp    80306f <insert_sorted_with_merge_freeList+0x759>

							}
							else if((blockToInsert->sva + blockToInsert->size) < next->sva  && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  802ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd0:	8b 50 08             	mov    0x8(%eax),%edx
  802cd3:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd6:	8b 40 0c             	mov    0xc(%eax),%eax
  802cd9:	01 c2                	add    %eax,%edx
  802cdb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cde:	8b 40 08             	mov    0x8(%eax),%eax
  802ce1:	39 c2                	cmp    %eax,%edx
  802ce3:	0f 83 ae 00 00 00    	jae    802d97 <insert_sorted_with_merge_freeList+0x481>
  802ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cec:	8b 50 08             	mov    0x8(%eax),%edx
  802cef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf2:	8b 48 08             	mov    0x8(%eax),%ecx
  802cf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf8:	8b 40 0c             	mov    0xc(%eax),%eax
  802cfb:	01 c8                	add    %ecx,%eax
  802cfd:	39 c2                	cmp    %eax,%edx
  802cff:	0f 85 92 00 00 00    	jne    802d97 <insert_sorted_with_merge_freeList+0x481>
							{

								blk_itr->size=blk_itr->size+blockToInsert->size;
  802d05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d08:	8b 50 0c             	mov    0xc(%eax),%edx
  802d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0e:	8b 40 0c             	mov    0xc(%eax),%eax
  802d11:	01 c2                	add    %eax,%edx
  802d13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d16:	89 50 0c             	mov    %edx,0xc(%eax)
								 blockToInsert->size=blockToInsert->sva=0;
  802d19:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802d23:	8b 45 08             	mov    0x8(%ebp),%eax
  802d26:	8b 50 08             	mov    0x8(%eax),%edx
  802d29:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2c:	89 50 0c             	mov    %edx,0xc(%eax)
								 LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802d2f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d33:	75 17                	jne    802d4c <insert_sorted_with_merge_freeList+0x436>
  802d35:	83 ec 04             	sub    $0x4,%esp
  802d38:	68 d0 3a 80 00       	push   $0x803ad0
  802d3d:	68 51 01 00 00       	push   $0x151
  802d42:	68 f3 3a 80 00       	push   $0x803af3
  802d47:	e8 1e d6 ff ff       	call   80036a <_panic>
  802d4c:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d52:	8b 45 08             	mov    0x8(%ebp),%eax
  802d55:	89 10                	mov    %edx,(%eax)
  802d57:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5a:	8b 00                	mov    (%eax),%eax
  802d5c:	85 c0                	test   %eax,%eax
  802d5e:	74 0d                	je     802d6d <insert_sorted_with_merge_freeList+0x457>
  802d60:	a1 48 41 80 00       	mov    0x804148,%eax
  802d65:	8b 55 08             	mov    0x8(%ebp),%edx
  802d68:	89 50 04             	mov    %edx,0x4(%eax)
  802d6b:	eb 08                	jmp    802d75 <insert_sorted_with_merge_freeList+0x45f>
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
  802d92:	e9 d8 02 00 00       	jmp    80306f <insert_sorted_with_merge_freeList+0x759>

							}
							else if( (blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva > (blk_itr->sva + blk_itr->size))
  802d97:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9a:	8b 50 08             	mov    0x8(%eax),%edx
  802d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802da0:	8b 40 0c             	mov    0xc(%eax),%eax
  802da3:	01 c2                	add    %eax,%edx
  802da5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802da8:	8b 40 08             	mov    0x8(%eax),%eax
  802dab:	39 c2                	cmp    %eax,%edx
  802dad:	0f 85 ba 00 00 00    	jne    802e6d <insert_sorted_with_merge_freeList+0x557>
  802db3:	8b 45 08             	mov    0x8(%ebp),%eax
  802db6:	8b 50 08             	mov    0x8(%eax),%edx
  802db9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbc:	8b 48 08             	mov    0x8(%eax),%ecx
  802dbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc2:	8b 40 0c             	mov    0xc(%eax),%eax
  802dc5:	01 c8                	add    %ecx,%eax
  802dc7:	39 c2                	cmp    %eax,%edx
  802dc9:	0f 86 9e 00 00 00    	jbe    802e6d <insert_sorted_with_merge_freeList+0x557>
							{
								next->size = next->size + blockToInsert->size;
  802dcf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dd2:	8b 50 0c             	mov    0xc(%eax),%edx
  802dd5:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd8:	8b 40 0c             	mov    0xc(%eax),%eax
  802ddb:	01 c2                	add    %eax,%edx
  802ddd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802de0:	89 50 0c             	mov    %edx,0xc(%eax)
								next->sva = blockToInsert->sva;
  802de3:	8b 45 08             	mov    0x8(%ebp),%eax
  802de6:	8b 50 08             	mov    0x8(%eax),%edx
  802de9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dec:	89 50 08             	mov    %edx,0x8(%eax)

								blockToInsert->size = blockToInsert->sva = 0;
  802def:	8b 45 08             	mov    0x8(%ebp),%eax
  802df2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802df9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfc:	8b 50 08             	mov    0x8(%eax),%edx
  802dff:	8b 45 08             	mov    0x8(%ebp),%eax
  802e02:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802e05:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e09:	75 17                	jne    802e22 <insert_sorted_with_merge_freeList+0x50c>
  802e0b:	83 ec 04             	sub    $0x4,%esp
  802e0e:	68 d0 3a 80 00       	push   $0x803ad0
  802e13:	68 5b 01 00 00       	push   $0x15b
  802e18:	68 f3 3a 80 00       	push   $0x803af3
  802e1d:	e8 48 d5 ff ff       	call   80036a <_panic>
  802e22:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e28:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2b:	89 10                	mov    %edx,(%eax)
  802e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e30:	8b 00                	mov    (%eax),%eax
  802e32:	85 c0                	test   %eax,%eax
  802e34:	74 0d                	je     802e43 <insert_sorted_with_merge_freeList+0x52d>
  802e36:	a1 48 41 80 00       	mov    0x804148,%eax
  802e3b:	8b 55 08             	mov    0x8(%ebp),%edx
  802e3e:	89 50 04             	mov    %edx,0x4(%eax)
  802e41:	eb 08                	jmp    802e4b <insert_sorted_with_merge_freeList+0x535>
  802e43:	8b 45 08             	mov    0x8(%ebp),%eax
  802e46:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4e:	a3 48 41 80 00       	mov    %eax,0x804148
  802e53:	8b 45 08             	mov    0x8(%ebp),%eax
  802e56:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e5d:	a1 54 41 80 00       	mov    0x804154,%eax
  802e62:	40                   	inc    %eax
  802e63:	a3 54 41 80 00       	mov    %eax,0x804154
								break;
  802e68:	e9 02 02 00 00       	jmp    80306f <insert_sorted_with_merge_freeList+0x759>
							}
							else if ((blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  802e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e70:	8b 50 08             	mov    0x8(%eax),%edx
  802e73:	8b 45 08             	mov    0x8(%ebp),%eax
  802e76:	8b 40 0c             	mov    0xc(%eax),%eax
  802e79:	01 c2                	add    %eax,%edx
  802e7b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e7e:	8b 40 08             	mov    0x8(%eax),%eax
  802e81:	39 c2                	cmp    %eax,%edx
  802e83:	0f 85 ae 01 00 00    	jne    803037 <insert_sorted_with_merge_freeList+0x721>
  802e89:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8c:	8b 50 08             	mov    0x8(%eax),%edx
  802e8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e92:	8b 48 08             	mov    0x8(%eax),%ecx
  802e95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e98:	8b 40 0c             	mov    0xc(%eax),%eax
  802e9b:	01 c8                	add    %ecx,%eax
  802e9d:	39 c2                	cmp    %eax,%edx
  802e9f:	0f 85 92 01 00 00    	jne    803037 <insert_sorted_with_merge_freeList+0x721>
							{
								blk_itr->size = blk_itr->size + blockToInsert->size + next->size;
  802ea5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea8:	8b 50 0c             	mov    0xc(%eax),%edx
  802eab:	8b 45 08             	mov    0x8(%ebp),%eax
  802eae:	8b 40 0c             	mov    0xc(%eax),%eax
  802eb1:	01 c2                	add    %eax,%edx
  802eb3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eb6:	8b 40 0c             	mov    0xc(%eax),%eax
  802eb9:	01 c2                	add    %eax,%edx
  802ebb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebe:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size = blockToInsert->sva=0;
  802ec1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802ecb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ece:	8b 50 08             	mov    0x8(%eax),%edx
  802ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed4:	89 50 0c             	mov    %edx,0xc(%eax)
								next->size = next->sva = 0;
  802ed7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eda:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802ee1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ee4:	8b 50 08             	mov    0x8(%eax),%edx
  802ee7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eea:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_REMOVE(&FreeMemBlocksList, next);
  802eed:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ef1:	75 17                	jne    802f0a <insert_sorted_with_merge_freeList+0x5f4>
  802ef3:	83 ec 04             	sub    $0x4,%esp
  802ef6:	68 9b 3b 80 00       	push   $0x803b9b
  802efb:	68 63 01 00 00       	push   $0x163
  802f00:	68 f3 3a 80 00       	push   $0x803af3
  802f05:	e8 60 d4 ff ff       	call   80036a <_panic>
  802f0a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f0d:	8b 00                	mov    (%eax),%eax
  802f0f:	85 c0                	test   %eax,%eax
  802f11:	74 10                	je     802f23 <insert_sorted_with_merge_freeList+0x60d>
  802f13:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f16:	8b 00                	mov    (%eax),%eax
  802f18:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f1b:	8b 52 04             	mov    0x4(%edx),%edx
  802f1e:	89 50 04             	mov    %edx,0x4(%eax)
  802f21:	eb 0b                	jmp    802f2e <insert_sorted_with_merge_freeList+0x618>
  802f23:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f26:	8b 40 04             	mov    0x4(%eax),%eax
  802f29:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802f2e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f31:	8b 40 04             	mov    0x4(%eax),%eax
  802f34:	85 c0                	test   %eax,%eax
  802f36:	74 0f                	je     802f47 <insert_sorted_with_merge_freeList+0x631>
  802f38:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f3b:	8b 40 04             	mov    0x4(%eax),%eax
  802f3e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f41:	8b 12                	mov    (%edx),%edx
  802f43:	89 10                	mov    %edx,(%eax)
  802f45:	eb 0a                	jmp    802f51 <insert_sorted_with_merge_freeList+0x63b>
  802f47:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f4a:	8b 00                	mov    (%eax),%eax
  802f4c:	a3 38 41 80 00       	mov    %eax,0x804138
  802f51:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f54:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f5a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f5d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f64:	a1 44 41 80 00       	mov    0x804144,%eax
  802f69:	48                   	dec    %eax
  802f6a:	a3 44 41 80 00       	mov    %eax,0x804144
								LIST_INSERT_HEAD(&AvailableMemBlocksList, next );
  802f6f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f73:	75 17                	jne    802f8c <insert_sorted_with_merge_freeList+0x676>
  802f75:	83 ec 04             	sub    $0x4,%esp
  802f78:	68 d0 3a 80 00       	push   $0x803ad0
  802f7d:	68 64 01 00 00       	push   $0x164
  802f82:	68 f3 3a 80 00       	push   $0x803af3
  802f87:	e8 de d3 ff ff       	call   80036a <_panic>
  802f8c:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f92:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f95:	89 10                	mov    %edx,(%eax)
  802f97:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f9a:	8b 00                	mov    (%eax),%eax
  802f9c:	85 c0                	test   %eax,%eax
  802f9e:	74 0d                	je     802fad <insert_sorted_with_merge_freeList+0x697>
  802fa0:	a1 48 41 80 00       	mov    0x804148,%eax
  802fa5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fa8:	89 50 04             	mov    %edx,0x4(%eax)
  802fab:	eb 08                	jmp    802fb5 <insert_sorted_with_merge_freeList+0x69f>
  802fad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fb0:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802fb5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fb8:	a3 48 41 80 00       	mov    %eax,0x804148
  802fbd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fc0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fc7:	a1 54 41 80 00       	mov    0x804154,%eax
  802fcc:	40                   	inc    %eax
  802fcd:	a3 54 41 80 00       	mov    %eax,0x804154
							    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802fd2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fd6:	75 17                	jne    802fef <insert_sorted_with_merge_freeList+0x6d9>
  802fd8:	83 ec 04             	sub    $0x4,%esp
  802fdb:	68 d0 3a 80 00       	push   $0x803ad0
  802fe0:	68 65 01 00 00       	push   $0x165
  802fe5:	68 f3 3a 80 00       	push   $0x803af3
  802fea:	e8 7b d3 ff ff       	call   80036a <_panic>
  802fef:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff8:	89 10                	mov    %edx,(%eax)
  802ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffd:	8b 00                	mov    (%eax),%eax
  802fff:	85 c0                	test   %eax,%eax
  803001:	74 0d                	je     803010 <insert_sorted_with_merge_freeList+0x6fa>
  803003:	a1 48 41 80 00       	mov    0x804148,%eax
  803008:	8b 55 08             	mov    0x8(%ebp),%edx
  80300b:	89 50 04             	mov    %edx,0x4(%eax)
  80300e:	eb 08                	jmp    803018 <insert_sorted_with_merge_freeList+0x702>
  803010:	8b 45 08             	mov    0x8(%ebp),%eax
  803013:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803018:	8b 45 08             	mov    0x8(%ebp),%eax
  80301b:	a3 48 41 80 00       	mov    %eax,0x804148
  803020:	8b 45 08             	mov    0x8(%ebp),%eax
  803023:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80302a:	a1 54 41 80 00       	mov    0x804154,%eax
  80302f:	40                   	inc    %eax
  803030:	a3 54 41 80 00       	mov    %eax,0x804154
								break;
  803035:	eb 38                	jmp    80306f <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  803037:	a1 40 41 80 00       	mov    0x804140,%eax
  80303c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80303f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803043:	74 07                	je     80304c <insert_sorted_with_merge_freeList+0x736>
  803045:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803048:	8b 00                	mov    (%eax),%eax
  80304a:	eb 05                	jmp    803051 <insert_sorted_with_merge_freeList+0x73b>
  80304c:	b8 00 00 00 00       	mov    $0x0,%eax
  803051:	a3 40 41 80 00       	mov    %eax,0x804140
  803056:	a1 40 41 80 00       	mov    0x804140,%eax
  80305b:	85 c0                	test   %eax,%eax
  80305d:	0f 85 a7 fb ff ff    	jne    802c0a <insert_sorted_with_merge_freeList+0x2f4>
  803063:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803067:	0f 85 9d fb ff ff    	jne    802c0a <insert_sorted_with_merge_freeList+0x2f4>
						}
				}
        }

}
}
  80306d:	eb 00                	jmp    80306f <insert_sorted_with_merge_freeList+0x759>
  80306f:	90                   	nop
  803070:	c9                   	leave  
  803071:	c3                   	ret    
  803072:	66 90                	xchg   %ax,%ax

00803074 <__udivdi3>:
  803074:	55                   	push   %ebp
  803075:	57                   	push   %edi
  803076:	56                   	push   %esi
  803077:	53                   	push   %ebx
  803078:	83 ec 1c             	sub    $0x1c,%esp
  80307b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80307f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803083:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803087:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80308b:	89 ca                	mov    %ecx,%edx
  80308d:	89 f8                	mov    %edi,%eax
  80308f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803093:	85 f6                	test   %esi,%esi
  803095:	75 2d                	jne    8030c4 <__udivdi3+0x50>
  803097:	39 cf                	cmp    %ecx,%edi
  803099:	77 65                	ja     803100 <__udivdi3+0x8c>
  80309b:	89 fd                	mov    %edi,%ebp
  80309d:	85 ff                	test   %edi,%edi
  80309f:	75 0b                	jne    8030ac <__udivdi3+0x38>
  8030a1:	b8 01 00 00 00       	mov    $0x1,%eax
  8030a6:	31 d2                	xor    %edx,%edx
  8030a8:	f7 f7                	div    %edi
  8030aa:	89 c5                	mov    %eax,%ebp
  8030ac:	31 d2                	xor    %edx,%edx
  8030ae:	89 c8                	mov    %ecx,%eax
  8030b0:	f7 f5                	div    %ebp
  8030b2:	89 c1                	mov    %eax,%ecx
  8030b4:	89 d8                	mov    %ebx,%eax
  8030b6:	f7 f5                	div    %ebp
  8030b8:	89 cf                	mov    %ecx,%edi
  8030ba:	89 fa                	mov    %edi,%edx
  8030bc:	83 c4 1c             	add    $0x1c,%esp
  8030bf:	5b                   	pop    %ebx
  8030c0:	5e                   	pop    %esi
  8030c1:	5f                   	pop    %edi
  8030c2:	5d                   	pop    %ebp
  8030c3:	c3                   	ret    
  8030c4:	39 ce                	cmp    %ecx,%esi
  8030c6:	77 28                	ja     8030f0 <__udivdi3+0x7c>
  8030c8:	0f bd fe             	bsr    %esi,%edi
  8030cb:	83 f7 1f             	xor    $0x1f,%edi
  8030ce:	75 40                	jne    803110 <__udivdi3+0x9c>
  8030d0:	39 ce                	cmp    %ecx,%esi
  8030d2:	72 0a                	jb     8030de <__udivdi3+0x6a>
  8030d4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8030d8:	0f 87 9e 00 00 00    	ja     80317c <__udivdi3+0x108>
  8030de:	b8 01 00 00 00       	mov    $0x1,%eax
  8030e3:	89 fa                	mov    %edi,%edx
  8030e5:	83 c4 1c             	add    $0x1c,%esp
  8030e8:	5b                   	pop    %ebx
  8030e9:	5e                   	pop    %esi
  8030ea:	5f                   	pop    %edi
  8030eb:	5d                   	pop    %ebp
  8030ec:	c3                   	ret    
  8030ed:	8d 76 00             	lea    0x0(%esi),%esi
  8030f0:	31 ff                	xor    %edi,%edi
  8030f2:	31 c0                	xor    %eax,%eax
  8030f4:	89 fa                	mov    %edi,%edx
  8030f6:	83 c4 1c             	add    $0x1c,%esp
  8030f9:	5b                   	pop    %ebx
  8030fa:	5e                   	pop    %esi
  8030fb:	5f                   	pop    %edi
  8030fc:	5d                   	pop    %ebp
  8030fd:	c3                   	ret    
  8030fe:	66 90                	xchg   %ax,%ax
  803100:	89 d8                	mov    %ebx,%eax
  803102:	f7 f7                	div    %edi
  803104:	31 ff                	xor    %edi,%edi
  803106:	89 fa                	mov    %edi,%edx
  803108:	83 c4 1c             	add    $0x1c,%esp
  80310b:	5b                   	pop    %ebx
  80310c:	5e                   	pop    %esi
  80310d:	5f                   	pop    %edi
  80310e:	5d                   	pop    %ebp
  80310f:	c3                   	ret    
  803110:	bd 20 00 00 00       	mov    $0x20,%ebp
  803115:	89 eb                	mov    %ebp,%ebx
  803117:	29 fb                	sub    %edi,%ebx
  803119:	89 f9                	mov    %edi,%ecx
  80311b:	d3 e6                	shl    %cl,%esi
  80311d:	89 c5                	mov    %eax,%ebp
  80311f:	88 d9                	mov    %bl,%cl
  803121:	d3 ed                	shr    %cl,%ebp
  803123:	89 e9                	mov    %ebp,%ecx
  803125:	09 f1                	or     %esi,%ecx
  803127:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80312b:	89 f9                	mov    %edi,%ecx
  80312d:	d3 e0                	shl    %cl,%eax
  80312f:	89 c5                	mov    %eax,%ebp
  803131:	89 d6                	mov    %edx,%esi
  803133:	88 d9                	mov    %bl,%cl
  803135:	d3 ee                	shr    %cl,%esi
  803137:	89 f9                	mov    %edi,%ecx
  803139:	d3 e2                	shl    %cl,%edx
  80313b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80313f:	88 d9                	mov    %bl,%cl
  803141:	d3 e8                	shr    %cl,%eax
  803143:	09 c2                	or     %eax,%edx
  803145:	89 d0                	mov    %edx,%eax
  803147:	89 f2                	mov    %esi,%edx
  803149:	f7 74 24 0c          	divl   0xc(%esp)
  80314d:	89 d6                	mov    %edx,%esi
  80314f:	89 c3                	mov    %eax,%ebx
  803151:	f7 e5                	mul    %ebp
  803153:	39 d6                	cmp    %edx,%esi
  803155:	72 19                	jb     803170 <__udivdi3+0xfc>
  803157:	74 0b                	je     803164 <__udivdi3+0xf0>
  803159:	89 d8                	mov    %ebx,%eax
  80315b:	31 ff                	xor    %edi,%edi
  80315d:	e9 58 ff ff ff       	jmp    8030ba <__udivdi3+0x46>
  803162:	66 90                	xchg   %ax,%ax
  803164:	8b 54 24 08          	mov    0x8(%esp),%edx
  803168:	89 f9                	mov    %edi,%ecx
  80316a:	d3 e2                	shl    %cl,%edx
  80316c:	39 c2                	cmp    %eax,%edx
  80316e:	73 e9                	jae    803159 <__udivdi3+0xe5>
  803170:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803173:	31 ff                	xor    %edi,%edi
  803175:	e9 40 ff ff ff       	jmp    8030ba <__udivdi3+0x46>
  80317a:	66 90                	xchg   %ax,%ax
  80317c:	31 c0                	xor    %eax,%eax
  80317e:	e9 37 ff ff ff       	jmp    8030ba <__udivdi3+0x46>
  803183:	90                   	nop

00803184 <__umoddi3>:
  803184:	55                   	push   %ebp
  803185:	57                   	push   %edi
  803186:	56                   	push   %esi
  803187:	53                   	push   %ebx
  803188:	83 ec 1c             	sub    $0x1c,%esp
  80318b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80318f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803193:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803197:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80319b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80319f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8031a3:	89 f3                	mov    %esi,%ebx
  8031a5:	89 fa                	mov    %edi,%edx
  8031a7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8031ab:	89 34 24             	mov    %esi,(%esp)
  8031ae:	85 c0                	test   %eax,%eax
  8031b0:	75 1a                	jne    8031cc <__umoddi3+0x48>
  8031b2:	39 f7                	cmp    %esi,%edi
  8031b4:	0f 86 a2 00 00 00    	jbe    80325c <__umoddi3+0xd8>
  8031ba:	89 c8                	mov    %ecx,%eax
  8031bc:	89 f2                	mov    %esi,%edx
  8031be:	f7 f7                	div    %edi
  8031c0:	89 d0                	mov    %edx,%eax
  8031c2:	31 d2                	xor    %edx,%edx
  8031c4:	83 c4 1c             	add    $0x1c,%esp
  8031c7:	5b                   	pop    %ebx
  8031c8:	5e                   	pop    %esi
  8031c9:	5f                   	pop    %edi
  8031ca:	5d                   	pop    %ebp
  8031cb:	c3                   	ret    
  8031cc:	39 f0                	cmp    %esi,%eax
  8031ce:	0f 87 ac 00 00 00    	ja     803280 <__umoddi3+0xfc>
  8031d4:	0f bd e8             	bsr    %eax,%ebp
  8031d7:	83 f5 1f             	xor    $0x1f,%ebp
  8031da:	0f 84 ac 00 00 00    	je     80328c <__umoddi3+0x108>
  8031e0:	bf 20 00 00 00       	mov    $0x20,%edi
  8031e5:	29 ef                	sub    %ebp,%edi
  8031e7:	89 fe                	mov    %edi,%esi
  8031e9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8031ed:	89 e9                	mov    %ebp,%ecx
  8031ef:	d3 e0                	shl    %cl,%eax
  8031f1:	89 d7                	mov    %edx,%edi
  8031f3:	89 f1                	mov    %esi,%ecx
  8031f5:	d3 ef                	shr    %cl,%edi
  8031f7:	09 c7                	or     %eax,%edi
  8031f9:	89 e9                	mov    %ebp,%ecx
  8031fb:	d3 e2                	shl    %cl,%edx
  8031fd:	89 14 24             	mov    %edx,(%esp)
  803200:	89 d8                	mov    %ebx,%eax
  803202:	d3 e0                	shl    %cl,%eax
  803204:	89 c2                	mov    %eax,%edx
  803206:	8b 44 24 08          	mov    0x8(%esp),%eax
  80320a:	d3 e0                	shl    %cl,%eax
  80320c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803210:	8b 44 24 08          	mov    0x8(%esp),%eax
  803214:	89 f1                	mov    %esi,%ecx
  803216:	d3 e8                	shr    %cl,%eax
  803218:	09 d0                	or     %edx,%eax
  80321a:	d3 eb                	shr    %cl,%ebx
  80321c:	89 da                	mov    %ebx,%edx
  80321e:	f7 f7                	div    %edi
  803220:	89 d3                	mov    %edx,%ebx
  803222:	f7 24 24             	mull   (%esp)
  803225:	89 c6                	mov    %eax,%esi
  803227:	89 d1                	mov    %edx,%ecx
  803229:	39 d3                	cmp    %edx,%ebx
  80322b:	0f 82 87 00 00 00    	jb     8032b8 <__umoddi3+0x134>
  803231:	0f 84 91 00 00 00    	je     8032c8 <__umoddi3+0x144>
  803237:	8b 54 24 04          	mov    0x4(%esp),%edx
  80323b:	29 f2                	sub    %esi,%edx
  80323d:	19 cb                	sbb    %ecx,%ebx
  80323f:	89 d8                	mov    %ebx,%eax
  803241:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803245:	d3 e0                	shl    %cl,%eax
  803247:	89 e9                	mov    %ebp,%ecx
  803249:	d3 ea                	shr    %cl,%edx
  80324b:	09 d0                	or     %edx,%eax
  80324d:	89 e9                	mov    %ebp,%ecx
  80324f:	d3 eb                	shr    %cl,%ebx
  803251:	89 da                	mov    %ebx,%edx
  803253:	83 c4 1c             	add    $0x1c,%esp
  803256:	5b                   	pop    %ebx
  803257:	5e                   	pop    %esi
  803258:	5f                   	pop    %edi
  803259:	5d                   	pop    %ebp
  80325a:	c3                   	ret    
  80325b:	90                   	nop
  80325c:	89 fd                	mov    %edi,%ebp
  80325e:	85 ff                	test   %edi,%edi
  803260:	75 0b                	jne    80326d <__umoddi3+0xe9>
  803262:	b8 01 00 00 00       	mov    $0x1,%eax
  803267:	31 d2                	xor    %edx,%edx
  803269:	f7 f7                	div    %edi
  80326b:	89 c5                	mov    %eax,%ebp
  80326d:	89 f0                	mov    %esi,%eax
  80326f:	31 d2                	xor    %edx,%edx
  803271:	f7 f5                	div    %ebp
  803273:	89 c8                	mov    %ecx,%eax
  803275:	f7 f5                	div    %ebp
  803277:	89 d0                	mov    %edx,%eax
  803279:	e9 44 ff ff ff       	jmp    8031c2 <__umoddi3+0x3e>
  80327e:	66 90                	xchg   %ax,%ax
  803280:	89 c8                	mov    %ecx,%eax
  803282:	89 f2                	mov    %esi,%edx
  803284:	83 c4 1c             	add    $0x1c,%esp
  803287:	5b                   	pop    %ebx
  803288:	5e                   	pop    %esi
  803289:	5f                   	pop    %edi
  80328a:	5d                   	pop    %ebp
  80328b:	c3                   	ret    
  80328c:	3b 04 24             	cmp    (%esp),%eax
  80328f:	72 06                	jb     803297 <__umoddi3+0x113>
  803291:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803295:	77 0f                	ja     8032a6 <__umoddi3+0x122>
  803297:	89 f2                	mov    %esi,%edx
  803299:	29 f9                	sub    %edi,%ecx
  80329b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80329f:	89 14 24             	mov    %edx,(%esp)
  8032a2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8032a6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8032aa:	8b 14 24             	mov    (%esp),%edx
  8032ad:	83 c4 1c             	add    $0x1c,%esp
  8032b0:	5b                   	pop    %ebx
  8032b1:	5e                   	pop    %esi
  8032b2:	5f                   	pop    %edi
  8032b3:	5d                   	pop    %ebp
  8032b4:	c3                   	ret    
  8032b5:	8d 76 00             	lea    0x0(%esi),%esi
  8032b8:	2b 04 24             	sub    (%esp),%eax
  8032bb:	19 fa                	sbb    %edi,%edx
  8032bd:	89 d1                	mov    %edx,%ecx
  8032bf:	89 c6                	mov    %eax,%esi
  8032c1:	e9 71 ff ff ff       	jmp    803237 <__umoddi3+0xb3>
  8032c6:	66 90                	xchg   %ax,%ax
  8032c8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8032cc:	72 ea                	jb     8032b8 <__umoddi3+0x134>
  8032ce:	89 d9                	mov    %ebx,%ecx
  8032d0:	e9 62 ff ff ff       	jmp    803237 <__umoddi3+0xb3>
