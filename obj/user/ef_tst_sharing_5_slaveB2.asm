
obj/user/ef_tst_sharing_5_slaveB2:     file format elf32-i386


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
  800031:	e8 77 01 00 00       	call   8001ad <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the free of shared variables
#include <inc/lib.h>

void
_main(void)
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
_main(void)
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
  80008c:	68 20 33 80 00       	push   $0x803320
  800091:	6a 12                	push   $0x12
  800093:	68 3c 33 80 00       	push   $0x80333c
  800098:	e8 4c 02 00 00       	call   8002e9 <_panic>
	}
	uint32 *z;
	z = sget(sys_getparentenvid(),"z");
  80009d:	e8 4e 1b 00 00       	call   801bf0 <sys_getparentenvid>
  8000a2:	83 ec 08             	sub    $0x8,%esp
  8000a5:	68 5c 33 80 00       	push   $0x80335c
  8000aa:	50                   	push   %eax
  8000ab:	e8 11 16 00 00       	call   8016c1 <sget>
  8000b0:	83 c4 10             	add    $0x10,%esp
  8000b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("Slave B2 env used z (getSharedObject)\n");
  8000b6:	83 ec 0c             	sub    $0xc,%esp
  8000b9:	68 60 33 80 00       	push   $0x803360
  8000be:	e8 da 04 00 00       	call   80059d <cprintf>
  8000c3:	83 c4 10             	add    $0x10,%esp

	cprintf("Slave B2 please be patient ...\n");
  8000c6:	83 ec 0c             	sub    $0xc,%esp
  8000c9:	68 88 33 80 00       	push   $0x803388
  8000ce:	e8 ca 04 00 00       	call   80059d <cprintf>
  8000d3:	83 c4 10             	add    $0x10,%esp

	env_sleep(9000);
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	68 28 23 00 00       	push   $0x2328
  8000de:	e8 0e 2f 00 00       	call   802ff1 <env_sleep>
  8000e3:	83 c4 10             	add    $0x10,%esp
	int freeFrames = sys_calculate_free_frames() ;
  8000e6:	e8 0c 18 00 00       	call   8018f7 <sys_calculate_free_frames>
  8000eb:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sfree(z);
  8000ee:	83 ec 0c             	sub    $0xc,%esp
  8000f1:	ff 75 ec             	pushl  -0x14(%ebp)
  8000f4:	e8 9e 16 00 00       	call   801797 <sfree>
  8000f9:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B2 env removed z\n");
  8000fc:	83 ec 0c             	sub    $0xc,%esp
  8000ff:	68 a8 33 80 00       	push   $0x8033a8
  800104:	e8 94 04 00 00       	call   80059d <cprintf>
  800109:	83 c4 10             	add    $0x10,%esp

	if ((sys_calculate_free_frames() - freeFrames) !=  4) panic("wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table + 1 frame for z\nframes_storage of z: should be cleared now\n");
  80010c:	e8 e6 17 00 00       	call   8018f7 <sys_calculate_free_frames>
  800111:	89 c2                	mov    %eax,%edx
  800113:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800116:	29 c2                	sub    %eax,%edx
  800118:	89 d0                	mov    %edx,%eax
  80011a:	83 f8 04             	cmp    $0x4,%eax
  80011d:	74 14                	je     800133 <_main+0xfb>
  80011f:	83 ec 04             	sub    $0x4,%esp
  800122:	68 c0 33 80 00       	push   $0x8033c0
  800127:	6a 20                	push   $0x20
  800129:	68 3c 33 80 00       	push   $0x80333c
  80012e:	e8 b6 01 00 00       	call   8002e9 <_panic>

	//to ensure that the other environments completed successfully
	if (gettst()!=2) panic("test failed");
  800133:	e8 f7 1b 00 00       	call   801d2f <gettst>
  800138:	83 f8 02             	cmp    $0x2,%eax
  80013b:	74 14                	je     800151 <_main+0x119>
  80013d:	83 ec 04             	sub    $0x4,%esp
  800140:	68 60 34 80 00       	push   $0x803460
  800145:	6a 23                	push   $0x23
  800147:	68 3c 33 80 00       	push   $0x80333c
  80014c:	e8 98 01 00 00       	call   8002e9 <_panic>

	cprintf("Step B completed successfully!!\n\n\n");
  800151:	83 ec 0c             	sub    $0xc,%esp
  800154:	68 6c 34 80 00       	push   $0x80346c
  800159:	e8 3f 04 00 00       	call   80059d <cprintf>
  80015e:	83 c4 10             	add    $0x10,%esp
	cprintf("Congratulations!! Test of freeSharedObjects [5] completed successfully!!\n\n\n");
  800161:	83 ec 0c             	sub    $0xc,%esp
  800164:	68 90 34 80 00       	push   $0x803490
  800169:	e8 2f 04 00 00       	call   80059d <cprintf>
  80016e:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  800171:	e8 7a 1a 00 00       	call   801bf0 <sys_getparentenvid>
  800176:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(parentenvID > 0)
  800179:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80017d:	7e 2b                	jle    8001aa <_main+0x172>
	{
		//Get the check-finishing counter
		int *finish = NULL;
  80017f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		finish = sget(parentenvID, "finish_children") ;
  800186:	83 ec 08             	sub    $0x8,%esp
  800189:	68 dc 34 80 00       	push   $0x8034dc
  80018e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800191:	e8 2b 15 00 00       	call   8016c1 <sget>
  800196:	83 c4 10             	add    $0x10,%esp
  800199:	89 45 e0             	mov    %eax,-0x20(%ebp)
		(*finish)++ ;
  80019c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80019f:	8b 00                	mov    (%eax),%eax
  8001a1:	8d 50 01             	lea    0x1(%eax),%edx
  8001a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001a7:	89 10                	mov    %edx,(%eax)
	}
	return;
  8001a9:	90                   	nop
  8001aa:	90                   	nop
}
  8001ab:	c9                   	leave  
  8001ac:	c3                   	ret    

008001ad <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8001ad:	55                   	push   %ebp
  8001ae:	89 e5                	mov    %esp,%ebp
  8001b0:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8001b3:	e8 1f 1a 00 00       	call   801bd7 <sys_getenvindex>
  8001b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8001bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001be:	89 d0                	mov    %edx,%eax
  8001c0:	c1 e0 03             	shl    $0x3,%eax
  8001c3:	01 d0                	add    %edx,%eax
  8001c5:	01 c0                	add    %eax,%eax
  8001c7:	01 d0                	add    %edx,%eax
  8001c9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001d0:	01 d0                	add    %edx,%eax
  8001d2:	c1 e0 04             	shl    $0x4,%eax
  8001d5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001da:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001df:	a1 20 40 80 00       	mov    0x804020,%eax
  8001e4:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8001ea:	84 c0                	test   %al,%al
  8001ec:	74 0f                	je     8001fd <libmain+0x50>
		binaryname = myEnv->prog_name;
  8001ee:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f3:	05 5c 05 00 00       	add    $0x55c,%eax
  8001f8:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001fd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800201:	7e 0a                	jle    80020d <libmain+0x60>
		binaryname = argv[0];
  800203:	8b 45 0c             	mov    0xc(%ebp),%eax
  800206:	8b 00                	mov    (%eax),%eax
  800208:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  80020d:	83 ec 08             	sub    $0x8,%esp
  800210:	ff 75 0c             	pushl  0xc(%ebp)
  800213:	ff 75 08             	pushl  0x8(%ebp)
  800216:	e8 1d fe ff ff       	call   800038 <_main>
  80021b:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80021e:	e8 c1 17 00 00       	call   8019e4 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800223:	83 ec 0c             	sub    $0xc,%esp
  800226:	68 04 35 80 00       	push   $0x803504
  80022b:	e8 6d 03 00 00       	call   80059d <cprintf>
  800230:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800233:	a1 20 40 80 00       	mov    0x804020,%eax
  800238:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80023e:	a1 20 40 80 00       	mov    0x804020,%eax
  800243:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800249:	83 ec 04             	sub    $0x4,%esp
  80024c:	52                   	push   %edx
  80024d:	50                   	push   %eax
  80024e:	68 2c 35 80 00       	push   $0x80352c
  800253:	e8 45 03 00 00       	call   80059d <cprintf>
  800258:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80025b:	a1 20 40 80 00       	mov    0x804020,%eax
  800260:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800266:	a1 20 40 80 00       	mov    0x804020,%eax
  80026b:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800271:	a1 20 40 80 00       	mov    0x804020,%eax
  800276:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80027c:	51                   	push   %ecx
  80027d:	52                   	push   %edx
  80027e:	50                   	push   %eax
  80027f:	68 54 35 80 00       	push   $0x803554
  800284:	e8 14 03 00 00       	call   80059d <cprintf>
  800289:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80028c:	a1 20 40 80 00       	mov    0x804020,%eax
  800291:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800297:	83 ec 08             	sub    $0x8,%esp
  80029a:	50                   	push   %eax
  80029b:	68 ac 35 80 00       	push   $0x8035ac
  8002a0:	e8 f8 02 00 00       	call   80059d <cprintf>
  8002a5:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8002a8:	83 ec 0c             	sub    $0xc,%esp
  8002ab:	68 04 35 80 00       	push   $0x803504
  8002b0:	e8 e8 02 00 00       	call   80059d <cprintf>
  8002b5:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8002b8:	e8 41 17 00 00       	call   8019fe <sys_enable_interrupt>

	// exit gracefully
	exit();
  8002bd:	e8 19 00 00 00       	call   8002db <exit>
}
  8002c2:	90                   	nop
  8002c3:	c9                   	leave  
  8002c4:	c3                   	ret    

008002c5 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002c5:	55                   	push   %ebp
  8002c6:	89 e5                	mov    %esp,%ebp
  8002c8:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002cb:	83 ec 0c             	sub    $0xc,%esp
  8002ce:	6a 00                	push   $0x0
  8002d0:	e8 ce 18 00 00       	call   801ba3 <sys_destroy_env>
  8002d5:	83 c4 10             	add    $0x10,%esp
}
  8002d8:	90                   	nop
  8002d9:	c9                   	leave  
  8002da:	c3                   	ret    

008002db <exit>:

void
exit(void)
{
  8002db:	55                   	push   %ebp
  8002dc:	89 e5                	mov    %esp,%ebp
  8002de:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002e1:	e8 23 19 00 00       	call   801c09 <sys_exit_env>
}
  8002e6:	90                   	nop
  8002e7:	c9                   	leave  
  8002e8:	c3                   	ret    

008002e9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002e9:	55                   	push   %ebp
  8002ea:	89 e5                	mov    %esp,%ebp
  8002ec:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002ef:	8d 45 10             	lea    0x10(%ebp),%eax
  8002f2:	83 c0 04             	add    $0x4,%eax
  8002f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002f8:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8002fd:	85 c0                	test   %eax,%eax
  8002ff:	74 16                	je     800317 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800301:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800306:	83 ec 08             	sub    $0x8,%esp
  800309:	50                   	push   %eax
  80030a:	68 c0 35 80 00       	push   $0x8035c0
  80030f:	e8 89 02 00 00       	call   80059d <cprintf>
  800314:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800317:	a1 00 40 80 00       	mov    0x804000,%eax
  80031c:	ff 75 0c             	pushl  0xc(%ebp)
  80031f:	ff 75 08             	pushl  0x8(%ebp)
  800322:	50                   	push   %eax
  800323:	68 c5 35 80 00       	push   $0x8035c5
  800328:	e8 70 02 00 00       	call   80059d <cprintf>
  80032d:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800330:	8b 45 10             	mov    0x10(%ebp),%eax
  800333:	83 ec 08             	sub    $0x8,%esp
  800336:	ff 75 f4             	pushl  -0xc(%ebp)
  800339:	50                   	push   %eax
  80033a:	e8 f3 01 00 00       	call   800532 <vcprintf>
  80033f:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800342:	83 ec 08             	sub    $0x8,%esp
  800345:	6a 00                	push   $0x0
  800347:	68 e1 35 80 00       	push   $0x8035e1
  80034c:	e8 e1 01 00 00       	call   800532 <vcprintf>
  800351:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800354:	e8 82 ff ff ff       	call   8002db <exit>

	// should not return here
	while (1) ;
  800359:	eb fe                	jmp    800359 <_panic+0x70>

0080035b <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80035b:	55                   	push   %ebp
  80035c:	89 e5                	mov    %esp,%ebp
  80035e:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800361:	a1 20 40 80 00       	mov    0x804020,%eax
  800366:	8b 50 74             	mov    0x74(%eax),%edx
  800369:	8b 45 0c             	mov    0xc(%ebp),%eax
  80036c:	39 c2                	cmp    %eax,%edx
  80036e:	74 14                	je     800384 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800370:	83 ec 04             	sub    $0x4,%esp
  800373:	68 e4 35 80 00       	push   $0x8035e4
  800378:	6a 26                	push   $0x26
  80037a:	68 30 36 80 00       	push   $0x803630
  80037f:	e8 65 ff ff ff       	call   8002e9 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800384:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80038b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800392:	e9 c2 00 00 00       	jmp    800459 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800397:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80039a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a4:	01 d0                	add    %edx,%eax
  8003a6:	8b 00                	mov    (%eax),%eax
  8003a8:	85 c0                	test   %eax,%eax
  8003aa:	75 08                	jne    8003b4 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8003ac:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003af:	e9 a2 00 00 00       	jmp    800456 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8003b4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003bb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003c2:	eb 69                	jmp    80042d <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003c4:	a1 20 40 80 00       	mov    0x804020,%eax
  8003c9:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003cf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003d2:	89 d0                	mov    %edx,%eax
  8003d4:	01 c0                	add    %eax,%eax
  8003d6:	01 d0                	add    %edx,%eax
  8003d8:	c1 e0 03             	shl    $0x3,%eax
  8003db:	01 c8                	add    %ecx,%eax
  8003dd:	8a 40 04             	mov    0x4(%eax),%al
  8003e0:	84 c0                	test   %al,%al
  8003e2:	75 46                	jne    80042a <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003e4:	a1 20 40 80 00       	mov    0x804020,%eax
  8003e9:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003ef:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003f2:	89 d0                	mov    %edx,%eax
  8003f4:	01 c0                	add    %eax,%eax
  8003f6:	01 d0                	add    %edx,%eax
  8003f8:	c1 e0 03             	shl    $0x3,%eax
  8003fb:	01 c8                	add    %ecx,%eax
  8003fd:	8b 00                	mov    (%eax),%eax
  8003ff:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800402:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800405:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80040a:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80040c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80040f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800416:	8b 45 08             	mov    0x8(%ebp),%eax
  800419:	01 c8                	add    %ecx,%eax
  80041b:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80041d:	39 c2                	cmp    %eax,%edx
  80041f:	75 09                	jne    80042a <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800421:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800428:	eb 12                	jmp    80043c <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80042a:	ff 45 e8             	incl   -0x18(%ebp)
  80042d:	a1 20 40 80 00       	mov    0x804020,%eax
  800432:	8b 50 74             	mov    0x74(%eax),%edx
  800435:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800438:	39 c2                	cmp    %eax,%edx
  80043a:	77 88                	ja     8003c4 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80043c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800440:	75 14                	jne    800456 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800442:	83 ec 04             	sub    $0x4,%esp
  800445:	68 3c 36 80 00       	push   $0x80363c
  80044a:	6a 3a                	push   $0x3a
  80044c:	68 30 36 80 00       	push   $0x803630
  800451:	e8 93 fe ff ff       	call   8002e9 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800456:	ff 45 f0             	incl   -0x10(%ebp)
  800459:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80045c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80045f:	0f 8c 32 ff ff ff    	jl     800397 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800465:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80046c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800473:	eb 26                	jmp    80049b <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800475:	a1 20 40 80 00       	mov    0x804020,%eax
  80047a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800480:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800483:	89 d0                	mov    %edx,%eax
  800485:	01 c0                	add    %eax,%eax
  800487:	01 d0                	add    %edx,%eax
  800489:	c1 e0 03             	shl    $0x3,%eax
  80048c:	01 c8                	add    %ecx,%eax
  80048e:	8a 40 04             	mov    0x4(%eax),%al
  800491:	3c 01                	cmp    $0x1,%al
  800493:	75 03                	jne    800498 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800495:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800498:	ff 45 e0             	incl   -0x20(%ebp)
  80049b:	a1 20 40 80 00       	mov    0x804020,%eax
  8004a0:	8b 50 74             	mov    0x74(%eax),%edx
  8004a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004a6:	39 c2                	cmp    %eax,%edx
  8004a8:	77 cb                	ja     800475 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004ad:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004b0:	74 14                	je     8004c6 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8004b2:	83 ec 04             	sub    $0x4,%esp
  8004b5:	68 90 36 80 00       	push   $0x803690
  8004ba:	6a 44                	push   $0x44
  8004bc:	68 30 36 80 00       	push   $0x803630
  8004c1:	e8 23 fe ff ff       	call   8002e9 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004c6:	90                   	nop
  8004c7:	c9                   	leave  
  8004c8:	c3                   	ret    

008004c9 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8004c9:	55                   	push   %ebp
  8004ca:	89 e5                	mov    %esp,%ebp
  8004cc:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8004cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004d2:	8b 00                	mov    (%eax),%eax
  8004d4:	8d 48 01             	lea    0x1(%eax),%ecx
  8004d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004da:	89 0a                	mov    %ecx,(%edx)
  8004dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8004df:	88 d1                	mov    %dl,%cl
  8004e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004e4:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004eb:	8b 00                	mov    (%eax),%eax
  8004ed:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004f2:	75 2c                	jne    800520 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8004f4:	a0 24 40 80 00       	mov    0x804024,%al
  8004f9:	0f b6 c0             	movzbl %al,%eax
  8004fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ff:	8b 12                	mov    (%edx),%edx
  800501:	89 d1                	mov    %edx,%ecx
  800503:	8b 55 0c             	mov    0xc(%ebp),%edx
  800506:	83 c2 08             	add    $0x8,%edx
  800509:	83 ec 04             	sub    $0x4,%esp
  80050c:	50                   	push   %eax
  80050d:	51                   	push   %ecx
  80050e:	52                   	push   %edx
  80050f:	e8 22 13 00 00       	call   801836 <sys_cputs>
  800514:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800517:	8b 45 0c             	mov    0xc(%ebp),%eax
  80051a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800520:	8b 45 0c             	mov    0xc(%ebp),%eax
  800523:	8b 40 04             	mov    0x4(%eax),%eax
  800526:	8d 50 01             	lea    0x1(%eax),%edx
  800529:	8b 45 0c             	mov    0xc(%ebp),%eax
  80052c:	89 50 04             	mov    %edx,0x4(%eax)
}
  80052f:	90                   	nop
  800530:	c9                   	leave  
  800531:	c3                   	ret    

00800532 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800532:	55                   	push   %ebp
  800533:	89 e5                	mov    %esp,%ebp
  800535:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80053b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800542:	00 00 00 
	b.cnt = 0;
  800545:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80054c:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80054f:	ff 75 0c             	pushl  0xc(%ebp)
  800552:	ff 75 08             	pushl  0x8(%ebp)
  800555:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80055b:	50                   	push   %eax
  80055c:	68 c9 04 80 00       	push   $0x8004c9
  800561:	e8 11 02 00 00       	call   800777 <vprintfmt>
  800566:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800569:	a0 24 40 80 00       	mov    0x804024,%al
  80056e:	0f b6 c0             	movzbl %al,%eax
  800571:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800577:	83 ec 04             	sub    $0x4,%esp
  80057a:	50                   	push   %eax
  80057b:	52                   	push   %edx
  80057c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800582:	83 c0 08             	add    $0x8,%eax
  800585:	50                   	push   %eax
  800586:	e8 ab 12 00 00       	call   801836 <sys_cputs>
  80058b:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80058e:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800595:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80059b:	c9                   	leave  
  80059c:	c3                   	ret    

0080059d <cprintf>:

int cprintf(const char *fmt, ...) {
  80059d:	55                   	push   %ebp
  80059e:	89 e5                	mov    %esp,%ebp
  8005a0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005a3:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  8005aa:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b3:	83 ec 08             	sub    $0x8,%esp
  8005b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8005b9:	50                   	push   %eax
  8005ba:	e8 73 ff ff ff       	call   800532 <vcprintf>
  8005bf:	83 c4 10             	add    $0x10,%esp
  8005c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005c8:	c9                   	leave  
  8005c9:	c3                   	ret    

008005ca <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8005ca:	55                   	push   %ebp
  8005cb:	89 e5                	mov    %esp,%ebp
  8005cd:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005d0:	e8 0f 14 00 00       	call   8019e4 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005d5:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005db:	8b 45 08             	mov    0x8(%ebp),%eax
  8005de:	83 ec 08             	sub    $0x8,%esp
  8005e1:	ff 75 f4             	pushl  -0xc(%ebp)
  8005e4:	50                   	push   %eax
  8005e5:	e8 48 ff ff ff       	call   800532 <vcprintf>
  8005ea:	83 c4 10             	add    $0x10,%esp
  8005ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8005f0:	e8 09 14 00 00       	call   8019fe <sys_enable_interrupt>
	return cnt;
  8005f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005f8:	c9                   	leave  
  8005f9:	c3                   	ret    

008005fa <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005fa:	55                   	push   %ebp
  8005fb:	89 e5                	mov    %esp,%ebp
  8005fd:	53                   	push   %ebx
  8005fe:	83 ec 14             	sub    $0x14,%esp
  800601:	8b 45 10             	mov    0x10(%ebp),%eax
  800604:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800607:	8b 45 14             	mov    0x14(%ebp),%eax
  80060a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80060d:	8b 45 18             	mov    0x18(%ebp),%eax
  800610:	ba 00 00 00 00       	mov    $0x0,%edx
  800615:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800618:	77 55                	ja     80066f <printnum+0x75>
  80061a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80061d:	72 05                	jb     800624 <printnum+0x2a>
  80061f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800622:	77 4b                	ja     80066f <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800624:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800627:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80062a:	8b 45 18             	mov    0x18(%ebp),%eax
  80062d:	ba 00 00 00 00       	mov    $0x0,%edx
  800632:	52                   	push   %edx
  800633:	50                   	push   %eax
  800634:	ff 75 f4             	pushl  -0xc(%ebp)
  800637:	ff 75 f0             	pushl  -0x10(%ebp)
  80063a:	e8 69 2a 00 00       	call   8030a8 <__udivdi3>
  80063f:	83 c4 10             	add    $0x10,%esp
  800642:	83 ec 04             	sub    $0x4,%esp
  800645:	ff 75 20             	pushl  0x20(%ebp)
  800648:	53                   	push   %ebx
  800649:	ff 75 18             	pushl  0x18(%ebp)
  80064c:	52                   	push   %edx
  80064d:	50                   	push   %eax
  80064e:	ff 75 0c             	pushl  0xc(%ebp)
  800651:	ff 75 08             	pushl  0x8(%ebp)
  800654:	e8 a1 ff ff ff       	call   8005fa <printnum>
  800659:	83 c4 20             	add    $0x20,%esp
  80065c:	eb 1a                	jmp    800678 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80065e:	83 ec 08             	sub    $0x8,%esp
  800661:	ff 75 0c             	pushl  0xc(%ebp)
  800664:	ff 75 20             	pushl  0x20(%ebp)
  800667:	8b 45 08             	mov    0x8(%ebp),%eax
  80066a:	ff d0                	call   *%eax
  80066c:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80066f:	ff 4d 1c             	decl   0x1c(%ebp)
  800672:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800676:	7f e6                	jg     80065e <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800678:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80067b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800680:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800683:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800686:	53                   	push   %ebx
  800687:	51                   	push   %ecx
  800688:	52                   	push   %edx
  800689:	50                   	push   %eax
  80068a:	e8 29 2b 00 00       	call   8031b8 <__umoddi3>
  80068f:	83 c4 10             	add    $0x10,%esp
  800692:	05 f4 38 80 00       	add    $0x8038f4,%eax
  800697:	8a 00                	mov    (%eax),%al
  800699:	0f be c0             	movsbl %al,%eax
  80069c:	83 ec 08             	sub    $0x8,%esp
  80069f:	ff 75 0c             	pushl  0xc(%ebp)
  8006a2:	50                   	push   %eax
  8006a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a6:	ff d0                	call   *%eax
  8006a8:	83 c4 10             	add    $0x10,%esp
}
  8006ab:	90                   	nop
  8006ac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006af:	c9                   	leave  
  8006b0:	c3                   	ret    

008006b1 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006b1:	55                   	push   %ebp
  8006b2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006b4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006b8:	7e 1c                	jle    8006d6 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8006ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bd:	8b 00                	mov    (%eax),%eax
  8006bf:	8d 50 08             	lea    0x8(%eax),%edx
  8006c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c5:	89 10                	mov    %edx,(%eax)
  8006c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ca:	8b 00                	mov    (%eax),%eax
  8006cc:	83 e8 08             	sub    $0x8,%eax
  8006cf:	8b 50 04             	mov    0x4(%eax),%edx
  8006d2:	8b 00                	mov    (%eax),%eax
  8006d4:	eb 40                	jmp    800716 <getuint+0x65>
	else if (lflag)
  8006d6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006da:	74 1e                	je     8006fa <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006df:	8b 00                	mov    (%eax),%eax
  8006e1:	8d 50 04             	lea    0x4(%eax),%edx
  8006e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e7:	89 10                	mov    %edx,(%eax)
  8006e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ec:	8b 00                	mov    (%eax),%eax
  8006ee:	83 e8 04             	sub    $0x4,%eax
  8006f1:	8b 00                	mov    (%eax),%eax
  8006f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8006f8:	eb 1c                	jmp    800716 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fd:	8b 00                	mov    (%eax),%eax
  8006ff:	8d 50 04             	lea    0x4(%eax),%edx
  800702:	8b 45 08             	mov    0x8(%ebp),%eax
  800705:	89 10                	mov    %edx,(%eax)
  800707:	8b 45 08             	mov    0x8(%ebp),%eax
  80070a:	8b 00                	mov    (%eax),%eax
  80070c:	83 e8 04             	sub    $0x4,%eax
  80070f:	8b 00                	mov    (%eax),%eax
  800711:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800716:	5d                   	pop    %ebp
  800717:	c3                   	ret    

00800718 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800718:	55                   	push   %ebp
  800719:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80071b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80071f:	7e 1c                	jle    80073d <getint+0x25>
		return va_arg(*ap, long long);
  800721:	8b 45 08             	mov    0x8(%ebp),%eax
  800724:	8b 00                	mov    (%eax),%eax
  800726:	8d 50 08             	lea    0x8(%eax),%edx
  800729:	8b 45 08             	mov    0x8(%ebp),%eax
  80072c:	89 10                	mov    %edx,(%eax)
  80072e:	8b 45 08             	mov    0x8(%ebp),%eax
  800731:	8b 00                	mov    (%eax),%eax
  800733:	83 e8 08             	sub    $0x8,%eax
  800736:	8b 50 04             	mov    0x4(%eax),%edx
  800739:	8b 00                	mov    (%eax),%eax
  80073b:	eb 38                	jmp    800775 <getint+0x5d>
	else if (lflag)
  80073d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800741:	74 1a                	je     80075d <getint+0x45>
		return va_arg(*ap, long);
  800743:	8b 45 08             	mov    0x8(%ebp),%eax
  800746:	8b 00                	mov    (%eax),%eax
  800748:	8d 50 04             	lea    0x4(%eax),%edx
  80074b:	8b 45 08             	mov    0x8(%ebp),%eax
  80074e:	89 10                	mov    %edx,(%eax)
  800750:	8b 45 08             	mov    0x8(%ebp),%eax
  800753:	8b 00                	mov    (%eax),%eax
  800755:	83 e8 04             	sub    $0x4,%eax
  800758:	8b 00                	mov    (%eax),%eax
  80075a:	99                   	cltd   
  80075b:	eb 18                	jmp    800775 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80075d:	8b 45 08             	mov    0x8(%ebp),%eax
  800760:	8b 00                	mov    (%eax),%eax
  800762:	8d 50 04             	lea    0x4(%eax),%edx
  800765:	8b 45 08             	mov    0x8(%ebp),%eax
  800768:	89 10                	mov    %edx,(%eax)
  80076a:	8b 45 08             	mov    0x8(%ebp),%eax
  80076d:	8b 00                	mov    (%eax),%eax
  80076f:	83 e8 04             	sub    $0x4,%eax
  800772:	8b 00                	mov    (%eax),%eax
  800774:	99                   	cltd   
}
  800775:	5d                   	pop    %ebp
  800776:	c3                   	ret    

00800777 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800777:	55                   	push   %ebp
  800778:	89 e5                	mov    %esp,%ebp
  80077a:	56                   	push   %esi
  80077b:	53                   	push   %ebx
  80077c:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80077f:	eb 17                	jmp    800798 <vprintfmt+0x21>
			if (ch == '\0')
  800781:	85 db                	test   %ebx,%ebx
  800783:	0f 84 af 03 00 00    	je     800b38 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800789:	83 ec 08             	sub    $0x8,%esp
  80078c:	ff 75 0c             	pushl  0xc(%ebp)
  80078f:	53                   	push   %ebx
  800790:	8b 45 08             	mov    0x8(%ebp),%eax
  800793:	ff d0                	call   *%eax
  800795:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800798:	8b 45 10             	mov    0x10(%ebp),%eax
  80079b:	8d 50 01             	lea    0x1(%eax),%edx
  80079e:	89 55 10             	mov    %edx,0x10(%ebp)
  8007a1:	8a 00                	mov    (%eax),%al
  8007a3:	0f b6 d8             	movzbl %al,%ebx
  8007a6:	83 fb 25             	cmp    $0x25,%ebx
  8007a9:	75 d6                	jne    800781 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007ab:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007af:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8007b6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007bd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8007c4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ce:	8d 50 01             	lea    0x1(%eax),%edx
  8007d1:	89 55 10             	mov    %edx,0x10(%ebp)
  8007d4:	8a 00                	mov    (%eax),%al
  8007d6:	0f b6 d8             	movzbl %al,%ebx
  8007d9:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007dc:	83 f8 55             	cmp    $0x55,%eax
  8007df:	0f 87 2b 03 00 00    	ja     800b10 <vprintfmt+0x399>
  8007e5:	8b 04 85 18 39 80 00 	mov    0x803918(,%eax,4),%eax
  8007ec:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007ee:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007f2:	eb d7                	jmp    8007cb <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007f4:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007f8:	eb d1                	jmp    8007cb <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007fa:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800801:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800804:	89 d0                	mov    %edx,%eax
  800806:	c1 e0 02             	shl    $0x2,%eax
  800809:	01 d0                	add    %edx,%eax
  80080b:	01 c0                	add    %eax,%eax
  80080d:	01 d8                	add    %ebx,%eax
  80080f:	83 e8 30             	sub    $0x30,%eax
  800812:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800815:	8b 45 10             	mov    0x10(%ebp),%eax
  800818:	8a 00                	mov    (%eax),%al
  80081a:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80081d:	83 fb 2f             	cmp    $0x2f,%ebx
  800820:	7e 3e                	jle    800860 <vprintfmt+0xe9>
  800822:	83 fb 39             	cmp    $0x39,%ebx
  800825:	7f 39                	jg     800860 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800827:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80082a:	eb d5                	jmp    800801 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80082c:	8b 45 14             	mov    0x14(%ebp),%eax
  80082f:	83 c0 04             	add    $0x4,%eax
  800832:	89 45 14             	mov    %eax,0x14(%ebp)
  800835:	8b 45 14             	mov    0x14(%ebp),%eax
  800838:	83 e8 04             	sub    $0x4,%eax
  80083b:	8b 00                	mov    (%eax),%eax
  80083d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800840:	eb 1f                	jmp    800861 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800842:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800846:	79 83                	jns    8007cb <vprintfmt+0x54>
				width = 0;
  800848:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80084f:	e9 77 ff ff ff       	jmp    8007cb <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800854:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80085b:	e9 6b ff ff ff       	jmp    8007cb <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800860:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800861:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800865:	0f 89 60 ff ff ff    	jns    8007cb <vprintfmt+0x54>
				width = precision, precision = -1;
  80086b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80086e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800871:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800878:	e9 4e ff ff ff       	jmp    8007cb <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80087d:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800880:	e9 46 ff ff ff       	jmp    8007cb <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800885:	8b 45 14             	mov    0x14(%ebp),%eax
  800888:	83 c0 04             	add    $0x4,%eax
  80088b:	89 45 14             	mov    %eax,0x14(%ebp)
  80088e:	8b 45 14             	mov    0x14(%ebp),%eax
  800891:	83 e8 04             	sub    $0x4,%eax
  800894:	8b 00                	mov    (%eax),%eax
  800896:	83 ec 08             	sub    $0x8,%esp
  800899:	ff 75 0c             	pushl  0xc(%ebp)
  80089c:	50                   	push   %eax
  80089d:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a0:	ff d0                	call   *%eax
  8008a2:	83 c4 10             	add    $0x10,%esp
			break;
  8008a5:	e9 89 02 00 00       	jmp    800b33 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ad:	83 c0 04             	add    $0x4,%eax
  8008b0:	89 45 14             	mov    %eax,0x14(%ebp)
  8008b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b6:	83 e8 04             	sub    $0x4,%eax
  8008b9:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008bb:	85 db                	test   %ebx,%ebx
  8008bd:	79 02                	jns    8008c1 <vprintfmt+0x14a>
				err = -err;
  8008bf:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008c1:	83 fb 64             	cmp    $0x64,%ebx
  8008c4:	7f 0b                	jg     8008d1 <vprintfmt+0x15a>
  8008c6:	8b 34 9d 60 37 80 00 	mov    0x803760(,%ebx,4),%esi
  8008cd:	85 f6                	test   %esi,%esi
  8008cf:	75 19                	jne    8008ea <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008d1:	53                   	push   %ebx
  8008d2:	68 05 39 80 00       	push   $0x803905
  8008d7:	ff 75 0c             	pushl  0xc(%ebp)
  8008da:	ff 75 08             	pushl  0x8(%ebp)
  8008dd:	e8 5e 02 00 00       	call   800b40 <printfmt>
  8008e2:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008e5:	e9 49 02 00 00       	jmp    800b33 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008ea:	56                   	push   %esi
  8008eb:	68 0e 39 80 00       	push   $0x80390e
  8008f0:	ff 75 0c             	pushl  0xc(%ebp)
  8008f3:	ff 75 08             	pushl  0x8(%ebp)
  8008f6:	e8 45 02 00 00       	call   800b40 <printfmt>
  8008fb:	83 c4 10             	add    $0x10,%esp
			break;
  8008fe:	e9 30 02 00 00       	jmp    800b33 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800903:	8b 45 14             	mov    0x14(%ebp),%eax
  800906:	83 c0 04             	add    $0x4,%eax
  800909:	89 45 14             	mov    %eax,0x14(%ebp)
  80090c:	8b 45 14             	mov    0x14(%ebp),%eax
  80090f:	83 e8 04             	sub    $0x4,%eax
  800912:	8b 30                	mov    (%eax),%esi
  800914:	85 f6                	test   %esi,%esi
  800916:	75 05                	jne    80091d <vprintfmt+0x1a6>
				p = "(null)";
  800918:	be 11 39 80 00       	mov    $0x803911,%esi
			if (width > 0 && padc != '-')
  80091d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800921:	7e 6d                	jle    800990 <vprintfmt+0x219>
  800923:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800927:	74 67                	je     800990 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800929:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80092c:	83 ec 08             	sub    $0x8,%esp
  80092f:	50                   	push   %eax
  800930:	56                   	push   %esi
  800931:	e8 0c 03 00 00       	call   800c42 <strnlen>
  800936:	83 c4 10             	add    $0x10,%esp
  800939:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80093c:	eb 16                	jmp    800954 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80093e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800942:	83 ec 08             	sub    $0x8,%esp
  800945:	ff 75 0c             	pushl  0xc(%ebp)
  800948:	50                   	push   %eax
  800949:	8b 45 08             	mov    0x8(%ebp),%eax
  80094c:	ff d0                	call   *%eax
  80094e:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800951:	ff 4d e4             	decl   -0x1c(%ebp)
  800954:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800958:	7f e4                	jg     80093e <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80095a:	eb 34                	jmp    800990 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80095c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800960:	74 1c                	je     80097e <vprintfmt+0x207>
  800962:	83 fb 1f             	cmp    $0x1f,%ebx
  800965:	7e 05                	jle    80096c <vprintfmt+0x1f5>
  800967:	83 fb 7e             	cmp    $0x7e,%ebx
  80096a:	7e 12                	jle    80097e <vprintfmt+0x207>
					putch('?', putdat);
  80096c:	83 ec 08             	sub    $0x8,%esp
  80096f:	ff 75 0c             	pushl  0xc(%ebp)
  800972:	6a 3f                	push   $0x3f
  800974:	8b 45 08             	mov    0x8(%ebp),%eax
  800977:	ff d0                	call   *%eax
  800979:	83 c4 10             	add    $0x10,%esp
  80097c:	eb 0f                	jmp    80098d <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80097e:	83 ec 08             	sub    $0x8,%esp
  800981:	ff 75 0c             	pushl  0xc(%ebp)
  800984:	53                   	push   %ebx
  800985:	8b 45 08             	mov    0x8(%ebp),%eax
  800988:	ff d0                	call   *%eax
  80098a:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80098d:	ff 4d e4             	decl   -0x1c(%ebp)
  800990:	89 f0                	mov    %esi,%eax
  800992:	8d 70 01             	lea    0x1(%eax),%esi
  800995:	8a 00                	mov    (%eax),%al
  800997:	0f be d8             	movsbl %al,%ebx
  80099a:	85 db                	test   %ebx,%ebx
  80099c:	74 24                	je     8009c2 <vprintfmt+0x24b>
  80099e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009a2:	78 b8                	js     80095c <vprintfmt+0x1e5>
  8009a4:	ff 4d e0             	decl   -0x20(%ebp)
  8009a7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009ab:	79 af                	jns    80095c <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009ad:	eb 13                	jmp    8009c2 <vprintfmt+0x24b>
				putch(' ', putdat);
  8009af:	83 ec 08             	sub    $0x8,%esp
  8009b2:	ff 75 0c             	pushl  0xc(%ebp)
  8009b5:	6a 20                	push   $0x20
  8009b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ba:	ff d0                	call   *%eax
  8009bc:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009bf:	ff 4d e4             	decl   -0x1c(%ebp)
  8009c2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009c6:	7f e7                	jg     8009af <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8009c8:	e9 66 01 00 00       	jmp    800b33 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009cd:	83 ec 08             	sub    $0x8,%esp
  8009d0:	ff 75 e8             	pushl  -0x18(%ebp)
  8009d3:	8d 45 14             	lea    0x14(%ebp),%eax
  8009d6:	50                   	push   %eax
  8009d7:	e8 3c fd ff ff       	call   800718 <getint>
  8009dc:	83 c4 10             	add    $0x10,%esp
  8009df:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009e2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009eb:	85 d2                	test   %edx,%edx
  8009ed:	79 23                	jns    800a12 <vprintfmt+0x29b>
				putch('-', putdat);
  8009ef:	83 ec 08             	sub    $0x8,%esp
  8009f2:	ff 75 0c             	pushl  0xc(%ebp)
  8009f5:	6a 2d                	push   $0x2d
  8009f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fa:	ff d0                	call   *%eax
  8009fc:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a02:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a05:	f7 d8                	neg    %eax
  800a07:	83 d2 00             	adc    $0x0,%edx
  800a0a:	f7 da                	neg    %edx
  800a0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a0f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a12:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a19:	e9 bc 00 00 00       	jmp    800ada <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a1e:	83 ec 08             	sub    $0x8,%esp
  800a21:	ff 75 e8             	pushl  -0x18(%ebp)
  800a24:	8d 45 14             	lea    0x14(%ebp),%eax
  800a27:	50                   	push   %eax
  800a28:	e8 84 fc ff ff       	call   8006b1 <getuint>
  800a2d:	83 c4 10             	add    $0x10,%esp
  800a30:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a33:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a36:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a3d:	e9 98 00 00 00       	jmp    800ada <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a42:	83 ec 08             	sub    $0x8,%esp
  800a45:	ff 75 0c             	pushl  0xc(%ebp)
  800a48:	6a 58                	push   $0x58
  800a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4d:	ff d0                	call   *%eax
  800a4f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a52:	83 ec 08             	sub    $0x8,%esp
  800a55:	ff 75 0c             	pushl  0xc(%ebp)
  800a58:	6a 58                	push   $0x58
  800a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5d:	ff d0                	call   *%eax
  800a5f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a62:	83 ec 08             	sub    $0x8,%esp
  800a65:	ff 75 0c             	pushl  0xc(%ebp)
  800a68:	6a 58                	push   $0x58
  800a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6d:	ff d0                	call   *%eax
  800a6f:	83 c4 10             	add    $0x10,%esp
			break;
  800a72:	e9 bc 00 00 00       	jmp    800b33 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a77:	83 ec 08             	sub    $0x8,%esp
  800a7a:	ff 75 0c             	pushl  0xc(%ebp)
  800a7d:	6a 30                	push   $0x30
  800a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a82:	ff d0                	call   *%eax
  800a84:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a87:	83 ec 08             	sub    $0x8,%esp
  800a8a:	ff 75 0c             	pushl  0xc(%ebp)
  800a8d:	6a 78                	push   $0x78
  800a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a92:	ff d0                	call   *%eax
  800a94:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a97:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9a:	83 c0 04             	add    $0x4,%eax
  800a9d:	89 45 14             	mov    %eax,0x14(%ebp)
  800aa0:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa3:	83 e8 04             	sub    $0x4,%eax
  800aa6:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800aa8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ab2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ab9:	eb 1f                	jmp    800ada <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800abb:	83 ec 08             	sub    $0x8,%esp
  800abe:	ff 75 e8             	pushl  -0x18(%ebp)
  800ac1:	8d 45 14             	lea    0x14(%ebp),%eax
  800ac4:	50                   	push   %eax
  800ac5:	e8 e7 fb ff ff       	call   8006b1 <getuint>
  800aca:	83 c4 10             	add    $0x10,%esp
  800acd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ad0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ad3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ada:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ade:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ae1:	83 ec 04             	sub    $0x4,%esp
  800ae4:	52                   	push   %edx
  800ae5:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ae8:	50                   	push   %eax
  800ae9:	ff 75 f4             	pushl  -0xc(%ebp)
  800aec:	ff 75 f0             	pushl  -0x10(%ebp)
  800aef:	ff 75 0c             	pushl  0xc(%ebp)
  800af2:	ff 75 08             	pushl  0x8(%ebp)
  800af5:	e8 00 fb ff ff       	call   8005fa <printnum>
  800afa:	83 c4 20             	add    $0x20,%esp
			break;
  800afd:	eb 34                	jmp    800b33 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800aff:	83 ec 08             	sub    $0x8,%esp
  800b02:	ff 75 0c             	pushl  0xc(%ebp)
  800b05:	53                   	push   %ebx
  800b06:	8b 45 08             	mov    0x8(%ebp),%eax
  800b09:	ff d0                	call   *%eax
  800b0b:	83 c4 10             	add    $0x10,%esp
			break;
  800b0e:	eb 23                	jmp    800b33 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b10:	83 ec 08             	sub    $0x8,%esp
  800b13:	ff 75 0c             	pushl  0xc(%ebp)
  800b16:	6a 25                	push   $0x25
  800b18:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1b:	ff d0                	call   *%eax
  800b1d:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b20:	ff 4d 10             	decl   0x10(%ebp)
  800b23:	eb 03                	jmp    800b28 <vprintfmt+0x3b1>
  800b25:	ff 4d 10             	decl   0x10(%ebp)
  800b28:	8b 45 10             	mov    0x10(%ebp),%eax
  800b2b:	48                   	dec    %eax
  800b2c:	8a 00                	mov    (%eax),%al
  800b2e:	3c 25                	cmp    $0x25,%al
  800b30:	75 f3                	jne    800b25 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b32:	90                   	nop
		}
	}
  800b33:	e9 47 fc ff ff       	jmp    80077f <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b38:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b39:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b3c:	5b                   	pop    %ebx
  800b3d:	5e                   	pop    %esi
  800b3e:	5d                   	pop    %ebp
  800b3f:	c3                   	ret    

00800b40 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b40:	55                   	push   %ebp
  800b41:	89 e5                	mov    %esp,%ebp
  800b43:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b46:	8d 45 10             	lea    0x10(%ebp),%eax
  800b49:	83 c0 04             	add    $0x4,%eax
  800b4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b4f:	8b 45 10             	mov    0x10(%ebp),%eax
  800b52:	ff 75 f4             	pushl  -0xc(%ebp)
  800b55:	50                   	push   %eax
  800b56:	ff 75 0c             	pushl  0xc(%ebp)
  800b59:	ff 75 08             	pushl  0x8(%ebp)
  800b5c:	e8 16 fc ff ff       	call   800777 <vprintfmt>
  800b61:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b64:	90                   	nop
  800b65:	c9                   	leave  
  800b66:	c3                   	ret    

00800b67 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b67:	55                   	push   %ebp
  800b68:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b6d:	8b 40 08             	mov    0x8(%eax),%eax
  800b70:	8d 50 01             	lea    0x1(%eax),%edx
  800b73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b76:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b7c:	8b 10                	mov    (%eax),%edx
  800b7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b81:	8b 40 04             	mov    0x4(%eax),%eax
  800b84:	39 c2                	cmp    %eax,%edx
  800b86:	73 12                	jae    800b9a <sprintputch+0x33>
		*b->buf++ = ch;
  800b88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8b:	8b 00                	mov    (%eax),%eax
  800b8d:	8d 48 01             	lea    0x1(%eax),%ecx
  800b90:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b93:	89 0a                	mov    %ecx,(%edx)
  800b95:	8b 55 08             	mov    0x8(%ebp),%edx
  800b98:	88 10                	mov    %dl,(%eax)
}
  800b9a:	90                   	nop
  800b9b:	5d                   	pop    %ebp
  800b9c:	c3                   	ret    

00800b9d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b9d:	55                   	push   %ebp
  800b9e:	89 e5                	mov    %esp,%ebp
  800ba0:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800ba9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bac:	8d 50 ff             	lea    -0x1(%eax),%edx
  800baf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb2:	01 d0                	add    %edx,%eax
  800bb4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bb7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800bbe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800bc2:	74 06                	je     800bca <vsnprintf+0x2d>
  800bc4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bc8:	7f 07                	jg     800bd1 <vsnprintf+0x34>
		return -E_INVAL;
  800bca:	b8 03 00 00 00       	mov    $0x3,%eax
  800bcf:	eb 20                	jmp    800bf1 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bd1:	ff 75 14             	pushl  0x14(%ebp)
  800bd4:	ff 75 10             	pushl  0x10(%ebp)
  800bd7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bda:	50                   	push   %eax
  800bdb:	68 67 0b 80 00       	push   $0x800b67
  800be0:	e8 92 fb ff ff       	call   800777 <vprintfmt>
  800be5:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800be8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800beb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bee:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bf1:	c9                   	leave  
  800bf2:	c3                   	ret    

00800bf3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bf3:	55                   	push   %ebp
  800bf4:	89 e5                	mov    %esp,%ebp
  800bf6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bf9:	8d 45 10             	lea    0x10(%ebp),%eax
  800bfc:	83 c0 04             	add    $0x4,%eax
  800bff:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c02:	8b 45 10             	mov    0x10(%ebp),%eax
  800c05:	ff 75 f4             	pushl  -0xc(%ebp)
  800c08:	50                   	push   %eax
  800c09:	ff 75 0c             	pushl  0xc(%ebp)
  800c0c:	ff 75 08             	pushl  0x8(%ebp)
  800c0f:	e8 89 ff ff ff       	call   800b9d <vsnprintf>
  800c14:	83 c4 10             	add    $0x10,%esp
  800c17:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c1d:	c9                   	leave  
  800c1e:	c3                   	ret    

00800c1f <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c1f:	55                   	push   %ebp
  800c20:	89 e5                	mov    %esp,%ebp
  800c22:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c25:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c2c:	eb 06                	jmp    800c34 <strlen+0x15>
		n++;
  800c2e:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c31:	ff 45 08             	incl   0x8(%ebp)
  800c34:	8b 45 08             	mov    0x8(%ebp),%eax
  800c37:	8a 00                	mov    (%eax),%al
  800c39:	84 c0                	test   %al,%al
  800c3b:	75 f1                	jne    800c2e <strlen+0xf>
		n++;
	return n;
  800c3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c40:	c9                   	leave  
  800c41:	c3                   	ret    

00800c42 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c42:	55                   	push   %ebp
  800c43:	89 e5                	mov    %esp,%ebp
  800c45:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c48:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c4f:	eb 09                	jmp    800c5a <strnlen+0x18>
		n++;
  800c51:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c54:	ff 45 08             	incl   0x8(%ebp)
  800c57:	ff 4d 0c             	decl   0xc(%ebp)
  800c5a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c5e:	74 09                	je     800c69 <strnlen+0x27>
  800c60:	8b 45 08             	mov    0x8(%ebp),%eax
  800c63:	8a 00                	mov    (%eax),%al
  800c65:	84 c0                	test   %al,%al
  800c67:	75 e8                	jne    800c51 <strnlen+0xf>
		n++;
	return n;
  800c69:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c6c:	c9                   	leave  
  800c6d:	c3                   	ret    

00800c6e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c6e:	55                   	push   %ebp
  800c6f:	89 e5                	mov    %esp,%ebp
  800c71:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c74:	8b 45 08             	mov    0x8(%ebp),%eax
  800c77:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c7a:	90                   	nop
  800c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7e:	8d 50 01             	lea    0x1(%eax),%edx
  800c81:	89 55 08             	mov    %edx,0x8(%ebp)
  800c84:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c87:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c8a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c8d:	8a 12                	mov    (%edx),%dl
  800c8f:	88 10                	mov    %dl,(%eax)
  800c91:	8a 00                	mov    (%eax),%al
  800c93:	84 c0                	test   %al,%al
  800c95:	75 e4                	jne    800c7b <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c97:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c9a:	c9                   	leave  
  800c9b:	c3                   	ret    

00800c9c <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c9c:	55                   	push   %ebp
  800c9d:	89 e5                	mov    %esp,%ebp
  800c9f:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ca8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800caf:	eb 1f                	jmp    800cd0 <strncpy+0x34>
		*dst++ = *src;
  800cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb4:	8d 50 01             	lea    0x1(%eax),%edx
  800cb7:	89 55 08             	mov    %edx,0x8(%ebp)
  800cba:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cbd:	8a 12                	mov    (%edx),%dl
  800cbf:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800cc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc4:	8a 00                	mov    (%eax),%al
  800cc6:	84 c0                	test   %al,%al
  800cc8:	74 03                	je     800ccd <strncpy+0x31>
			src++;
  800cca:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ccd:	ff 45 fc             	incl   -0x4(%ebp)
  800cd0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cd3:	3b 45 10             	cmp    0x10(%ebp),%eax
  800cd6:	72 d9                	jb     800cb1 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800cd8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800cdb:	c9                   	leave  
  800cdc:	c3                   	ret    

00800cdd <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800cdd:	55                   	push   %ebp
  800cde:	89 e5                	mov    %esp,%ebp
  800ce0:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ce9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ced:	74 30                	je     800d1f <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800cef:	eb 16                	jmp    800d07 <strlcpy+0x2a>
			*dst++ = *src++;
  800cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf4:	8d 50 01             	lea    0x1(%eax),%edx
  800cf7:	89 55 08             	mov    %edx,0x8(%ebp)
  800cfa:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cfd:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d00:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d03:	8a 12                	mov    (%edx),%dl
  800d05:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d07:	ff 4d 10             	decl   0x10(%ebp)
  800d0a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d0e:	74 09                	je     800d19 <strlcpy+0x3c>
  800d10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d13:	8a 00                	mov    (%eax),%al
  800d15:	84 c0                	test   %al,%al
  800d17:	75 d8                	jne    800cf1 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d19:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d1f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d22:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d25:	29 c2                	sub    %eax,%edx
  800d27:	89 d0                	mov    %edx,%eax
}
  800d29:	c9                   	leave  
  800d2a:	c3                   	ret    

00800d2b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d2b:	55                   	push   %ebp
  800d2c:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d2e:	eb 06                	jmp    800d36 <strcmp+0xb>
		p++, q++;
  800d30:	ff 45 08             	incl   0x8(%ebp)
  800d33:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d36:	8b 45 08             	mov    0x8(%ebp),%eax
  800d39:	8a 00                	mov    (%eax),%al
  800d3b:	84 c0                	test   %al,%al
  800d3d:	74 0e                	je     800d4d <strcmp+0x22>
  800d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d42:	8a 10                	mov    (%eax),%dl
  800d44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d47:	8a 00                	mov    (%eax),%al
  800d49:	38 c2                	cmp    %al,%dl
  800d4b:	74 e3                	je     800d30 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d50:	8a 00                	mov    (%eax),%al
  800d52:	0f b6 d0             	movzbl %al,%edx
  800d55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d58:	8a 00                	mov    (%eax),%al
  800d5a:	0f b6 c0             	movzbl %al,%eax
  800d5d:	29 c2                	sub    %eax,%edx
  800d5f:	89 d0                	mov    %edx,%eax
}
  800d61:	5d                   	pop    %ebp
  800d62:	c3                   	ret    

00800d63 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d63:	55                   	push   %ebp
  800d64:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d66:	eb 09                	jmp    800d71 <strncmp+0xe>
		n--, p++, q++;
  800d68:	ff 4d 10             	decl   0x10(%ebp)
  800d6b:	ff 45 08             	incl   0x8(%ebp)
  800d6e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d71:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d75:	74 17                	je     800d8e <strncmp+0x2b>
  800d77:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7a:	8a 00                	mov    (%eax),%al
  800d7c:	84 c0                	test   %al,%al
  800d7e:	74 0e                	je     800d8e <strncmp+0x2b>
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	8a 10                	mov    (%eax),%dl
  800d85:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d88:	8a 00                	mov    (%eax),%al
  800d8a:	38 c2                	cmp    %al,%dl
  800d8c:	74 da                	je     800d68 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d8e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d92:	75 07                	jne    800d9b <strncmp+0x38>
		return 0;
  800d94:	b8 00 00 00 00       	mov    $0x0,%eax
  800d99:	eb 14                	jmp    800daf <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9e:	8a 00                	mov    (%eax),%al
  800da0:	0f b6 d0             	movzbl %al,%edx
  800da3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da6:	8a 00                	mov    (%eax),%al
  800da8:	0f b6 c0             	movzbl %al,%eax
  800dab:	29 c2                	sub    %eax,%edx
  800dad:	89 d0                	mov    %edx,%eax
}
  800daf:	5d                   	pop    %ebp
  800db0:	c3                   	ret    

00800db1 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800db1:	55                   	push   %ebp
  800db2:	89 e5                	mov    %esp,%ebp
  800db4:	83 ec 04             	sub    $0x4,%esp
  800db7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dba:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dbd:	eb 12                	jmp    800dd1 <strchr+0x20>
		if (*s == c)
  800dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc2:	8a 00                	mov    (%eax),%al
  800dc4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dc7:	75 05                	jne    800dce <strchr+0x1d>
			return (char *) s;
  800dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcc:	eb 11                	jmp    800ddf <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800dce:	ff 45 08             	incl   0x8(%ebp)
  800dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd4:	8a 00                	mov    (%eax),%al
  800dd6:	84 c0                	test   %al,%al
  800dd8:	75 e5                	jne    800dbf <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800dda:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ddf:	c9                   	leave  
  800de0:	c3                   	ret    

00800de1 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800de1:	55                   	push   %ebp
  800de2:	89 e5                	mov    %esp,%ebp
  800de4:	83 ec 04             	sub    $0x4,%esp
  800de7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dea:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ded:	eb 0d                	jmp    800dfc <strfind+0x1b>
		if (*s == c)
  800def:	8b 45 08             	mov    0x8(%ebp),%eax
  800df2:	8a 00                	mov    (%eax),%al
  800df4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800df7:	74 0e                	je     800e07 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800df9:	ff 45 08             	incl   0x8(%ebp)
  800dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dff:	8a 00                	mov    (%eax),%al
  800e01:	84 c0                	test   %al,%al
  800e03:	75 ea                	jne    800def <strfind+0xe>
  800e05:	eb 01                	jmp    800e08 <strfind+0x27>
		if (*s == c)
			break;
  800e07:	90                   	nop
	return (char *) s;
  800e08:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e0b:	c9                   	leave  
  800e0c:	c3                   	ret    

00800e0d <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e0d:	55                   	push   %ebp
  800e0e:	89 e5                	mov    %esp,%ebp
  800e10:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e13:	8b 45 08             	mov    0x8(%ebp),%eax
  800e16:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e19:	8b 45 10             	mov    0x10(%ebp),%eax
  800e1c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e1f:	eb 0e                	jmp    800e2f <memset+0x22>
		*p++ = c;
  800e21:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e24:	8d 50 01             	lea    0x1(%eax),%edx
  800e27:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e2d:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e2f:	ff 4d f8             	decl   -0x8(%ebp)
  800e32:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e36:	79 e9                	jns    800e21 <memset+0x14>
		*p++ = c;

	return v;
  800e38:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e3b:	c9                   	leave  
  800e3c:	c3                   	ret    

00800e3d <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e3d:	55                   	push   %ebp
  800e3e:	89 e5                	mov    %esp,%ebp
  800e40:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e46:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e49:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e4f:	eb 16                	jmp    800e67 <memcpy+0x2a>
		*d++ = *s++;
  800e51:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e54:	8d 50 01             	lea    0x1(%eax),%edx
  800e57:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e5a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e5d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e60:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e63:	8a 12                	mov    (%edx),%dl
  800e65:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e67:	8b 45 10             	mov    0x10(%ebp),%eax
  800e6a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e6d:	89 55 10             	mov    %edx,0x10(%ebp)
  800e70:	85 c0                	test   %eax,%eax
  800e72:	75 dd                	jne    800e51 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e74:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e77:	c9                   	leave  
  800e78:	c3                   	ret    

00800e79 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e79:	55                   	push   %ebp
  800e7a:	89 e5                	mov    %esp,%ebp
  800e7c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e82:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e85:	8b 45 08             	mov    0x8(%ebp),%eax
  800e88:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e8b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e8e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e91:	73 50                	jae    800ee3 <memmove+0x6a>
  800e93:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e96:	8b 45 10             	mov    0x10(%ebp),%eax
  800e99:	01 d0                	add    %edx,%eax
  800e9b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e9e:	76 43                	jbe    800ee3 <memmove+0x6a>
		s += n;
  800ea0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea3:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800ea6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea9:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800eac:	eb 10                	jmp    800ebe <memmove+0x45>
			*--d = *--s;
  800eae:	ff 4d f8             	decl   -0x8(%ebp)
  800eb1:	ff 4d fc             	decl   -0x4(%ebp)
  800eb4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eb7:	8a 10                	mov    (%eax),%dl
  800eb9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ebc:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800ebe:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ec4:	89 55 10             	mov    %edx,0x10(%ebp)
  800ec7:	85 c0                	test   %eax,%eax
  800ec9:	75 e3                	jne    800eae <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ecb:	eb 23                	jmp    800ef0 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800ecd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ed0:	8d 50 01             	lea    0x1(%eax),%edx
  800ed3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ed6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ed9:	8d 4a 01             	lea    0x1(%edx),%ecx
  800edc:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800edf:	8a 12                	mov    (%edx),%dl
  800ee1:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800ee3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ee9:	89 55 10             	mov    %edx,0x10(%ebp)
  800eec:	85 c0                	test   %eax,%eax
  800eee:	75 dd                	jne    800ecd <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ef0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ef3:	c9                   	leave  
  800ef4:	c3                   	ret    

00800ef5 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ef5:	55                   	push   %ebp
  800ef6:	89 e5                	mov    %esp,%ebp
  800ef8:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800efb:	8b 45 08             	mov    0x8(%ebp),%eax
  800efe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f04:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f07:	eb 2a                	jmp    800f33 <memcmp+0x3e>
		if (*s1 != *s2)
  800f09:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f0c:	8a 10                	mov    (%eax),%dl
  800f0e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f11:	8a 00                	mov    (%eax),%al
  800f13:	38 c2                	cmp    %al,%dl
  800f15:	74 16                	je     800f2d <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f17:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f1a:	8a 00                	mov    (%eax),%al
  800f1c:	0f b6 d0             	movzbl %al,%edx
  800f1f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f22:	8a 00                	mov    (%eax),%al
  800f24:	0f b6 c0             	movzbl %al,%eax
  800f27:	29 c2                	sub    %eax,%edx
  800f29:	89 d0                	mov    %edx,%eax
  800f2b:	eb 18                	jmp    800f45 <memcmp+0x50>
		s1++, s2++;
  800f2d:	ff 45 fc             	incl   -0x4(%ebp)
  800f30:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f33:	8b 45 10             	mov    0x10(%ebp),%eax
  800f36:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f39:	89 55 10             	mov    %edx,0x10(%ebp)
  800f3c:	85 c0                	test   %eax,%eax
  800f3e:	75 c9                	jne    800f09 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f40:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f45:	c9                   	leave  
  800f46:	c3                   	ret    

00800f47 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f47:	55                   	push   %ebp
  800f48:	89 e5                	mov    %esp,%ebp
  800f4a:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f4d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f50:	8b 45 10             	mov    0x10(%ebp),%eax
  800f53:	01 d0                	add    %edx,%eax
  800f55:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f58:	eb 15                	jmp    800f6f <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5d:	8a 00                	mov    (%eax),%al
  800f5f:	0f b6 d0             	movzbl %al,%edx
  800f62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f65:	0f b6 c0             	movzbl %al,%eax
  800f68:	39 c2                	cmp    %eax,%edx
  800f6a:	74 0d                	je     800f79 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f6c:	ff 45 08             	incl   0x8(%ebp)
  800f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f72:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f75:	72 e3                	jb     800f5a <memfind+0x13>
  800f77:	eb 01                	jmp    800f7a <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f79:	90                   	nop
	return (void *) s;
  800f7a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f7d:	c9                   	leave  
  800f7e:	c3                   	ret    

00800f7f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f7f:	55                   	push   %ebp
  800f80:	89 e5                	mov    %esp,%ebp
  800f82:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f85:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f8c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f93:	eb 03                	jmp    800f98 <strtol+0x19>
		s++;
  800f95:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f98:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9b:	8a 00                	mov    (%eax),%al
  800f9d:	3c 20                	cmp    $0x20,%al
  800f9f:	74 f4                	je     800f95 <strtol+0x16>
  800fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa4:	8a 00                	mov    (%eax),%al
  800fa6:	3c 09                	cmp    $0x9,%al
  800fa8:	74 eb                	je     800f95 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800faa:	8b 45 08             	mov    0x8(%ebp),%eax
  800fad:	8a 00                	mov    (%eax),%al
  800faf:	3c 2b                	cmp    $0x2b,%al
  800fb1:	75 05                	jne    800fb8 <strtol+0x39>
		s++;
  800fb3:	ff 45 08             	incl   0x8(%ebp)
  800fb6:	eb 13                	jmp    800fcb <strtol+0x4c>
	else if (*s == '-')
  800fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbb:	8a 00                	mov    (%eax),%al
  800fbd:	3c 2d                	cmp    $0x2d,%al
  800fbf:	75 0a                	jne    800fcb <strtol+0x4c>
		s++, neg = 1;
  800fc1:	ff 45 08             	incl   0x8(%ebp)
  800fc4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800fcb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fcf:	74 06                	je     800fd7 <strtol+0x58>
  800fd1:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800fd5:	75 20                	jne    800ff7 <strtol+0x78>
  800fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fda:	8a 00                	mov    (%eax),%al
  800fdc:	3c 30                	cmp    $0x30,%al
  800fde:	75 17                	jne    800ff7 <strtol+0x78>
  800fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe3:	40                   	inc    %eax
  800fe4:	8a 00                	mov    (%eax),%al
  800fe6:	3c 78                	cmp    $0x78,%al
  800fe8:	75 0d                	jne    800ff7 <strtol+0x78>
		s += 2, base = 16;
  800fea:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fee:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800ff5:	eb 28                	jmp    80101f <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800ff7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ffb:	75 15                	jne    801012 <strtol+0x93>
  800ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  801000:	8a 00                	mov    (%eax),%al
  801002:	3c 30                	cmp    $0x30,%al
  801004:	75 0c                	jne    801012 <strtol+0x93>
		s++, base = 8;
  801006:	ff 45 08             	incl   0x8(%ebp)
  801009:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801010:	eb 0d                	jmp    80101f <strtol+0xa0>
	else if (base == 0)
  801012:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801016:	75 07                	jne    80101f <strtol+0xa0>
		base = 10;
  801018:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80101f:	8b 45 08             	mov    0x8(%ebp),%eax
  801022:	8a 00                	mov    (%eax),%al
  801024:	3c 2f                	cmp    $0x2f,%al
  801026:	7e 19                	jle    801041 <strtol+0xc2>
  801028:	8b 45 08             	mov    0x8(%ebp),%eax
  80102b:	8a 00                	mov    (%eax),%al
  80102d:	3c 39                	cmp    $0x39,%al
  80102f:	7f 10                	jg     801041 <strtol+0xc2>
			dig = *s - '0';
  801031:	8b 45 08             	mov    0x8(%ebp),%eax
  801034:	8a 00                	mov    (%eax),%al
  801036:	0f be c0             	movsbl %al,%eax
  801039:	83 e8 30             	sub    $0x30,%eax
  80103c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80103f:	eb 42                	jmp    801083 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801041:	8b 45 08             	mov    0x8(%ebp),%eax
  801044:	8a 00                	mov    (%eax),%al
  801046:	3c 60                	cmp    $0x60,%al
  801048:	7e 19                	jle    801063 <strtol+0xe4>
  80104a:	8b 45 08             	mov    0x8(%ebp),%eax
  80104d:	8a 00                	mov    (%eax),%al
  80104f:	3c 7a                	cmp    $0x7a,%al
  801051:	7f 10                	jg     801063 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801053:	8b 45 08             	mov    0x8(%ebp),%eax
  801056:	8a 00                	mov    (%eax),%al
  801058:	0f be c0             	movsbl %al,%eax
  80105b:	83 e8 57             	sub    $0x57,%eax
  80105e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801061:	eb 20                	jmp    801083 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801063:	8b 45 08             	mov    0x8(%ebp),%eax
  801066:	8a 00                	mov    (%eax),%al
  801068:	3c 40                	cmp    $0x40,%al
  80106a:	7e 39                	jle    8010a5 <strtol+0x126>
  80106c:	8b 45 08             	mov    0x8(%ebp),%eax
  80106f:	8a 00                	mov    (%eax),%al
  801071:	3c 5a                	cmp    $0x5a,%al
  801073:	7f 30                	jg     8010a5 <strtol+0x126>
			dig = *s - 'A' + 10;
  801075:	8b 45 08             	mov    0x8(%ebp),%eax
  801078:	8a 00                	mov    (%eax),%al
  80107a:	0f be c0             	movsbl %al,%eax
  80107d:	83 e8 37             	sub    $0x37,%eax
  801080:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801083:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801086:	3b 45 10             	cmp    0x10(%ebp),%eax
  801089:	7d 19                	jge    8010a4 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80108b:	ff 45 08             	incl   0x8(%ebp)
  80108e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801091:	0f af 45 10          	imul   0x10(%ebp),%eax
  801095:	89 c2                	mov    %eax,%edx
  801097:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80109a:	01 d0                	add    %edx,%eax
  80109c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80109f:	e9 7b ff ff ff       	jmp    80101f <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8010a4:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010a5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010a9:	74 08                	je     8010b3 <strtol+0x134>
		*endptr = (char *) s;
  8010ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b1:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8010b3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010b7:	74 07                	je     8010c0 <strtol+0x141>
  8010b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010bc:	f7 d8                	neg    %eax
  8010be:	eb 03                	jmp    8010c3 <strtol+0x144>
  8010c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010c3:	c9                   	leave  
  8010c4:	c3                   	ret    

008010c5 <ltostr>:

void
ltostr(long value, char *str)
{
  8010c5:	55                   	push   %ebp
  8010c6:	89 e5                	mov    %esp,%ebp
  8010c8:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8010cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8010d2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010d9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010dd:	79 13                	jns    8010f2 <ltostr+0x2d>
	{
		neg = 1;
  8010df:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e9:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010ec:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010ef:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f5:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010fa:	99                   	cltd   
  8010fb:	f7 f9                	idiv   %ecx
  8010fd:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801100:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801103:	8d 50 01             	lea    0x1(%eax),%edx
  801106:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801109:	89 c2                	mov    %eax,%edx
  80110b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110e:	01 d0                	add    %edx,%eax
  801110:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801113:	83 c2 30             	add    $0x30,%edx
  801116:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801118:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80111b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801120:	f7 e9                	imul   %ecx
  801122:	c1 fa 02             	sar    $0x2,%edx
  801125:	89 c8                	mov    %ecx,%eax
  801127:	c1 f8 1f             	sar    $0x1f,%eax
  80112a:	29 c2                	sub    %eax,%edx
  80112c:	89 d0                	mov    %edx,%eax
  80112e:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801131:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801134:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801139:	f7 e9                	imul   %ecx
  80113b:	c1 fa 02             	sar    $0x2,%edx
  80113e:	89 c8                	mov    %ecx,%eax
  801140:	c1 f8 1f             	sar    $0x1f,%eax
  801143:	29 c2                	sub    %eax,%edx
  801145:	89 d0                	mov    %edx,%eax
  801147:	c1 e0 02             	shl    $0x2,%eax
  80114a:	01 d0                	add    %edx,%eax
  80114c:	01 c0                	add    %eax,%eax
  80114e:	29 c1                	sub    %eax,%ecx
  801150:	89 ca                	mov    %ecx,%edx
  801152:	85 d2                	test   %edx,%edx
  801154:	75 9c                	jne    8010f2 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801156:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80115d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801160:	48                   	dec    %eax
  801161:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801164:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801168:	74 3d                	je     8011a7 <ltostr+0xe2>
		start = 1 ;
  80116a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801171:	eb 34                	jmp    8011a7 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801173:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801176:	8b 45 0c             	mov    0xc(%ebp),%eax
  801179:	01 d0                	add    %edx,%eax
  80117b:	8a 00                	mov    (%eax),%al
  80117d:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801180:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801183:	8b 45 0c             	mov    0xc(%ebp),%eax
  801186:	01 c2                	add    %eax,%edx
  801188:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80118b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118e:	01 c8                	add    %ecx,%eax
  801190:	8a 00                	mov    (%eax),%al
  801192:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801194:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801197:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119a:	01 c2                	add    %eax,%edx
  80119c:	8a 45 eb             	mov    -0x15(%ebp),%al
  80119f:	88 02                	mov    %al,(%edx)
		start++ ;
  8011a1:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8011a4:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8011a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011aa:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011ad:	7c c4                	jl     801173 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8011af:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8011b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b5:	01 d0                	add    %edx,%eax
  8011b7:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8011ba:	90                   	nop
  8011bb:	c9                   	leave  
  8011bc:	c3                   	ret    

008011bd <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011bd:	55                   	push   %ebp
  8011be:	89 e5                	mov    %esp,%ebp
  8011c0:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8011c3:	ff 75 08             	pushl  0x8(%ebp)
  8011c6:	e8 54 fa ff ff       	call   800c1f <strlen>
  8011cb:	83 c4 04             	add    $0x4,%esp
  8011ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8011d1:	ff 75 0c             	pushl  0xc(%ebp)
  8011d4:	e8 46 fa ff ff       	call   800c1f <strlen>
  8011d9:	83 c4 04             	add    $0x4,%esp
  8011dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011df:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8011e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011ed:	eb 17                	jmp    801206 <strcconcat+0x49>
		final[s] = str1[s] ;
  8011ef:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f5:	01 c2                	add    %eax,%edx
  8011f7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fd:	01 c8                	add    %ecx,%eax
  8011ff:	8a 00                	mov    (%eax),%al
  801201:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801203:	ff 45 fc             	incl   -0x4(%ebp)
  801206:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801209:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80120c:	7c e1                	jl     8011ef <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80120e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801215:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80121c:	eb 1f                	jmp    80123d <strcconcat+0x80>
		final[s++] = str2[i] ;
  80121e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801221:	8d 50 01             	lea    0x1(%eax),%edx
  801224:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801227:	89 c2                	mov    %eax,%edx
  801229:	8b 45 10             	mov    0x10(%ebp),%eax
  80122c:	01 c2                	add    %eax,%edx
  80122e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801231:	8b 45 0c             	mov    0xc(%ebp),%eax
  801234:	01 c8                	add    %ecx,%eax
  801236:	8a 00                	mov    (%eax),%al
  801238:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80123a:	ff 45 f8             	incl   -0x8(%ebp)
  80123d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801240:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801243:	7c d9                	jl     80121e <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801245:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801248:	8b 45 10             	mov    0x10(%ebp),%eax
  80124b:	01 d0                	add    %edx,%eax
  80124d:	c6 00 00             	movb   $0x0,(%eax)
}
  801250:	90                   	nop
  801251:	c9                   	leave  
  801252:	c3                   	ret    

00801253 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801253:	55                   	push   %ebp
  801254:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801256:	8b 45 14             	mov    0x14(%ebp),%eax
  801259:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80125f:	8b 45 14             	mov    0x14(%ebp),%eax
  801262:	8b 00                	mov    (%eax),%eax
  801264:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80126b:	8b 45 10             	mov    0x10(%ebp),%eax
  80126e:	01 d0                	add    %edx,%eax
  801270:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801276:	eb 0c                	jmp    801284 <strsplit+0x31>
			*string++ = 0;
  801278:	8b 45 08             	mov    0x8(%ebp),%eax
  80127b:	8d 50 01             	lea    0x1(%eax),%edx
  80127e:	89 55 08             	mov    %edx,0x8(%ebp)
  801281:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801284:	8b 45 08             	mov    0x8(%ebp),%eax
  801287:	8a 00                	mov    (%eax),%al
  801289:	84 c0                	test   %al,%al
  80128b:	74 18                	je     8012a5 <strsplit+0x52>
  80128d:	8b 45 08             	mov    0x8(%ebp),%eax
  801290:	8a 00                	mov    (%eax),%al
  801292:	0f be c0             	movsbl %al,%eax
  801295:	50                   	push   %eax
  801296:	ff 75 0c             	pushl  0xc(%ebp)
  801299:	e8 13 fb ff ff       	call   800db1 <strchr>
  80129e:	83 c4 08             	add    $0x8,%esp
  8012a1:	85 c0                	test   %eax,%eax
  8012a3:	75 d3                	jne    801278 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8012a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a8:	8a 00                	mov    (%eax),%al
  8012aa:	84 c0                	test   %al,%al
  8012ac:	74 5a                	je     801308 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8012ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8012b1:	8b 00                	mov    (%eax),%eax
  8012b3:	83 f8 0f             	cmp    $0xf,%eax
  8012b6:	75 07                	jne    8012bf <strsplit+0x6c>
		{
			return 0;
  8012b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8012bd:	eb 66                	jmp    801325 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8012c2:	8b 00                	mov    (%eax),%eax
  8012c4:	8d 48 01             	lea    0x1(%eax),%ecx
  8012c7:	8b 55 14             	mov    0x14(%ebp),%edx
  8012ca:	89 0a                	mov    %ecx,(%edx)
  8012cc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d6:	01 c2                	add    %eax,%edx
  8012d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012db:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012dd:	eb 03                	jmp    8012e2 <strsplit+0x8f>
			string++;
  8012df:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e5:	8a 00                	mov    (%eax),%al
  8012e7:	84 c0                	test   %al,%al
  8012e9:	74 8b                	je     801276 <strsplit+0x23>
  8012eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ee:	8a 00                	mov    (%eax),%al
  8012f0:	0f be c0             	movsbl %al,%eax
  8012f3:	50                   	push   %eax
  8012f4:	ff 75 0c             	pushl  0xc(%ebp)
  8012f7:	e8 b5 fa ff ff       	call   800db1 <strchr>
  8012fc:	83 c4 08             	add    $0x8,%esp
  8012ff:	85 c0                	test   %eax,%eax
  801301:	74 dc                	je     8012df <strsplit+0x8c>
			string++;
	}
  801303:	e9 6e ff ff ff       	jmp    801276 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801308:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801309:	8b 45 14             	mov    0x14(%ebp),%eax
  80130c:	8b 00                	mov    (%eax),%eax
  80130e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801315:	8b 45 10             	mov    0x10(%ebp),%eax
  801318:	01 d0                	add    %edx,%eax
  80131a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801320:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801325:	c9                   	leave  
  801326:	c3                   	ret    

00801327 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801327:	55                   	push   %ebp
  801328:	89 e5                	mov    %esp,%ebp
  80132a:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  80132d:	a1 04 40 80 00       	mov    0x804004,%eax
  801332:	85 c0                	test   %eax,%eax
  801334:	74 1f                	je     801355 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801336:	e8 1d 00 00 00       	call   801358 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80133b:	83 ec 0c             	sub    $0xc,%esp
  80133e:	68 70 3a 80 00       	push   $0x803a70
  801343:	e8 55 f2 ff ff       	call   80059d <cprintf>
  801348:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80134b:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801352:	00 00 00 
	}
}
  801355:	90                   	nop
  801356:	c9                   	leave  
  801357:	c3                   	ret    

00801358 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801358:	55                   	push   %ebp
  801359:	89 e5                	mov    %esp,%ebp
  80135b:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  80135e:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801365:	00 00 00 
  801368:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80136f:	00 00 00 
  801372:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801379:	00 00 00 
		LIST_INIT(&AllocMemBlocksList);
  80137c:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801383:	00 00 00 
  801386:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80138d:	00 00 00 
  801390:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801397:	00 00 00 

		MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES ;
  80139a:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  8013a1:	00 02 00 
		MemBlockNodes =(struct MemBlock*)USER_DYN_BLKS_ARRAY ;
  8013a4:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  8013ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013ae:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013b3:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013b8:	a3 50 40 80 00       	mov    %eax,0x804050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock),PAGE_SIZE),PERM_USER|PERM_WRITEABLE);
  8013bd:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8013c4:	a1 20 41 80 00       	mov    0x804120,%eax
  8013c9:	c1 e0 04             	shl    $0x4,%eax
  8013cc:	89 c2                	mov    %eax,%edx
  8013ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013d1:	01 d0                	add    %edx,%eax
  8013d3:	48                   	dec    %eax
  8013d4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8013d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013da:	ba 00 00 00 00       	mov    $0x0,%edx
  8013df:	f7 75 f0             	divl   -0x10(%ebp)
  8013e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013e5:	29 d0                	sub    %edx,%eax
  8013e7:	89 c2                	mov    %eax,%edx
  8013e9:	c7 45 e8 00 00 e0 7f 	movl   $0x7fe00000,-0x18(%ebp)
  8013f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013f3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013f8:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013fd:	83 ec 04             	sub    $0x4,%esp
  801400:	6a 06                	push   $0x6
  801402:	52                   	push   %edx
  801403:	50                   	push   %eax
  801404:	e8 71 05 00 00       	call   80197a <sys_allocate_chunk>
  801409:	83 c4 10             	add    $0x10,%esp
		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80140c:	a1 20 41 80 00       	mov    0x804120,%eax
  801411:	83 ec 0c             	sub    $0xc,%esp
  801414:	50                   	push   %eax
  801415:	e8 e6 0b 00 00       	call   802000 <initialize_MemBlocksList>
  80141a:	83 c4 10             	add    $0x10,%esp

		struct MemBlock  *block_node;
		block_node = AvailableMemBlocksList.lh_first;
  80141d:	a1 48 41 80 00       	mov    0x804148,%eax
  801422:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&(AvailableMemBlocksList),block_node);
  801425:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801429:	75 14                	jne    80143f <initialize_dyn_block_system+0xe7>
  80142b:	83 ec 04             	sub    $0x4,%esp
  80142e:	68 95 3a 80 00       	push   $0x803a95
  801433:	6a 2b                	push   $0x2b
  801435:	68 b3 3a 80 00       	push   $0x803ab3
  80143a:	e8 aa ee ff ff       	call   8002e9 <_panic>
  80143f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801442:	8b 00                	mov    (%eax),%eax
  801444:	85 c0                	test   %eax,%eax
  801446:	74 10                	je     801458 <initialize_dyn_block_system+0x100>
  801448:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80144b:	8b 00                	mov    (%eax),%eax
  80144d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801450:	8b 52 04             	mov    0x4(%edx),%edx
  801453:	89 50 04             	mov    %edx,0x4(%eax)
  801456:	eb 0b                	jmp    801463 <initialize_dyn_block_system+0x10b>
  801458:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80145b:	8b 40 04             	mov    0x4(%eax),%eax
  80145e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801463:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801466:	8b 40 04             	mov    0x4(%eax),%eax
  801469:	85 c0                	test   %eax,%eax
  80146b:	74 0f                	je     80147c <initialize_dyn_block_system+0x124>
  80146d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801470:	8b 40 04             	mov    0x4(%eax),%eax
  801473:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801476:	8b 12                	mov    (%edx),%edx
  801478:	89 10                	mov    %edx,(%eax)
  80147a:	eb 0a                	jmp    801486 <initialize_dyn_block_system+0x12e>
  80147c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80147f:	8b 00                	mov    (%eax),%eax
  801481:	a3 48 41 80 00       	mov    %eax,0x804148
  801486:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801489:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80148f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801492:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801499:	a1 54 41 80 00       	mov    0x804154,%eax
  80149e:	48                   	dec    %eax
  80149f:	a3 54 41 80 00       	mov    %eax,0x804154
		block_node->sva = USER_HEAP_START ;
  8014a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014a7:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
		block_node->size = ((USER_HEAP_MAX - USER_HEAP_START));
  8014ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014b1:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		insert_sorted_with_merge_freeList(block_node);
  8014b8:	83 ec 0c             	sub    $0xc,%esp
  8014bb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8014be:	e8 d2 13 00 00       	call   802895 <insert_sorted_with_merge_freeList>
  8014c3:	83 c4 10             	add    $0x10,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  8014c6:	90                   	nop
  8014c7:	c9                   	leave  
  8014c8:	c3                   	ret    

008014c9 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8014c9:	55                   	push   %ebp
  8014ca:	89 e5                	mov    %esp,%ebp
  8014cc:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014cf:	e8 53 fe ff ff       	call   801327 <InitializeUHeap>
	if (size == 0) return NULL ;
  8014d4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014d8:	75 07                	jne    8014e1 <malloc+0x18>
  8014da:	b8 00 00 00 00       	mov    $0x0,%eax
  8014df:	eb 61                	jmp    801542 <malloc+0x79>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	size= ROUNDUP(size,PAGE_SIZE);
  8014e1:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8014e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8014eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014ee:	01 d0                	add    %edx,%eax
  8014f0:	48                   	dec    %eax
  8014f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8014fc:	f7 75 f4             	divl   -0xc(%ebp)
  8014ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801502:	29 d0                	sub    %edx,%eax
  801504:	89 45 08             	mov    %eax,0x8(%ebp)
	    			if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801507:	e8 3c 08 00 00       	call   801d48 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80150c:	85 c0                	test   %eax,%eax
  80150e:	74 2d                	je     80153d <malloc+0x74>
	    			{
	    				struct MemBlock * ff_block = alloc_block_FF(size);
  801510:	83 ec 0c             	sub    $0xc,%esp
  801513:	ff 75 08             	pushl  0x8(%ebp)
  801516:	e8 3e 0f 00 00       	call   802459 <alloc_block_FF>
  80151b:	83 c4 10             	add    $0x10,%esp
  80151e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    				if(ff_block!=NULL)
  801521:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801525:	74 16                	je     80153d <malloc+0x74>
	    				{

	    					insert_sorted_allocList(ff_block);
  801527:	83 ec 0c             	sub    $0xc,%esp
  80152a:	ff 75 ec             	pushl  -0x14(%ebp)
  80152d:	e8 48 0c 00 00       	call   80217a <insert_sorted_allocList>
  801532:	83 c4 10             	add    $0x10,%esp
	    					return (void*) ff_block->sva ;
  801535:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801538:	8b 40 08             	mov    0x8(%eax),%eax
  80153b:	eb 05                	jmp    801542 <malloc+0x79>

	    				}
	}
	    			return (void*) NULL ;
  80153d:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801542:	c9                   	leave  
  801543:	c3                   	ret    

00801544 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801544:	55                   	push   %ebp
  801545:	89 e5                	mov    %esp,%ebp
  801547:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock *elementForEach;
		virtual_address = ROUNDDOWN(virtual_address, PAGE_SIZE);
  80154a:	8b 45 08             	mov    0x8(%ebp),%eax
  80154d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801550:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801553:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801558:	89 45 08             	mov    %eax,0x8(%ebp)
	//	if (is_mallocPages[indexindex((uint32) virtual_address)] == 1) {
		elementForEach = find_block(&AllocMemBlocksList,(uint32)virtual_address);
  80155b:	8b 45 08             	mov    0x8(%ebp),%eax
  80155e:	83 ec 08             	sub    $0x8,%esp
  801561:	50                   	push   %eax
  801562:	68 40 40 80 00       	push   $0x804040
  801567:	e8 71 0b 00 00       	call   8020dd <find_block>
  80156c:	83 c4 10             	add    $0x10,%esp
  80156f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		sys_free_user_mem((uint32) virtual_address, elementForEach->size);
  801572:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801575:	8b 50 0c             	mov    0xc(%eax),%edx
  801578:	8b 45 08             	mov    0x8(%ebp),%eax
  80157b:	83 ec 08             	sub    $0x8,%esp
  80157e:	52                   	push   %edx
  80157f:	50                   	push   %eax
  801580:	e8 bd 03 00 00       	call   801942 <sys_free_user_mem>
  801585:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,elementForEach);
  801588:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80158c:	75 14                	jne    8015a2 <free+0x5e>
  80158e:	83 ec 04             	sub    $0x4,%esp
  801591:	68 95 3a 80 00       	push   $0x803a95
  801596:	6a 71                	push   $0x71
  801598:	68 b3 3a 80 00       	push   $0x803ab3
  80159d:	e8 47 ed ff ff       	call   8002e9 <_panic>
  8015a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015a5:	8b 00                	mov    (%eax),%eax
  8015a7:	85 c0                	test   %eax,%eax
  8015a9:	74 10                	je     8015bb <free+0x77>
  8015ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ae:	8b 00                	mov    (%eax),%eax
  8015b0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015b3:	8b 52 04             	mov    0x4(%edx),%edx
  8015b6:	89 50 04             	mov    %edx,0x4(%eax)
  8015b9:	eb 0b                	jmp    8015c6 <free+0x82>
  8015bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015be:	8b 40 04             	mov    0x4(%eax),%eax
  8015c1:	a3 44 40 80 00       	mov    %eax,0x804044
  8015c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015c9:	8b 40 04             	mov    0x4(%eax),%eax
  8015cc:	85 c0                	test   %eax,%eax
  8015ce:	74 0f                	je     8015df <free+0x9b>
  8015d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015d3:	8b 40 04             	mov    0x4(%eax),%eax
  8015d6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015d9:	8b 12                	mov    (%edx),%edx
  8015db:	89 10                	mov    %edx,(%eax)
  8015dd:	eb 0a                	jmp    8015e9 <free+0xa5>
  8015df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015e2:	8b 00                	mov    (%eax),%eax
  8015e4:	a3 40 40 80 00       	mov    %eax,0x804040
  8015e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8015f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015f5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8015fc:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801601:	48                   	dec    %eax
  801602:	a3 4c 40 80 00       	mov    %eax,0x80404c
		insert_sorted_with_merge_freeList(elementForEach);
  801607:	83 ec 0c             	sub    $0xc,%esp
  80160a:	ff 75 f0             	pushl  -0x10(%ebp)
  80160d:	e8 83 12 00 00       	call   802895 <insert_sorted_with_merge_freeList>
  801612:	83 c4 10             	add    $0x10,%esp
	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801615:	90                   	nop
  801616:	c9                   	leave  
  801617:	c3                   	ret    

00801618 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801618:	55                   	push   %ebp
  801619:	89 e5                	mov    %esp,%ebp
  80161b:	83 ec 28             	sub    $0x28,%esp
  80161e:	8b 45 10             	mov    0x10(%ebp),%eax
  801621:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801624:	e8 fe fc ff ff       	call   801327 <InitializeUHeap>
	if (size == 0) return NULL ;
  801629:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80162d:	75 0a                	jne    801639 <smalloc+0x21>
  80162f:	b8 00 00 00 00       	mov    $0x0,%eax
  801634:	e9 86 00 00 00       	jmp    8016bf <smalloc+0xa7>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code

	size=ROUNDUP(size,PAGE_SIZE);
  801639:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801640:	8b 55 0c             	mov    0xc(%ebp),%edx
  801643:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801646:	01 d0                	add    %edx,%eax
  801648:	48                   	dec    %eax
  801649:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80164c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80164f:	ba 00 00 00 00       	mov    $0x0,%edx
  801654:	f7 75 f4             	divl   -0xc(%ebp)
  801657:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80165a:	29 d0                	sub    %edx,%eax
  80165c:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80165f:	e8 e4 06 00 00       	call   801d48 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801664:	85 c0                	test   %eax,%eax
  801666:	74 52                	je     8016ba <smalloc+0xa2>
		{
		struct MemBlock * ff_block ;
		ff_block = alloc_block_FF(size);
  801668:	83 ec 0c             	sub    $0xc,%esp
  80166b:	ff 75 0c             	pushl  0xc(%ebp)
  80166e:	e8 e6 0d 00 00       	call   802459 <alloc_block_FF>
  801673:	83 c4 10             	add    $0x10,%esp
  801676:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(ff_block==NULL)
  801679:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80167d:	75 07                	jne    801686 <smalloc+0x6e>
			return NULL ;
  80167f:	b8 00 00 00 00       	mov    $0x0,%eax
  801684:	eb 39                	jmp    8016bf <smalloc+0xa7>

		int obj_id =sys_createSharedObject(sharedVarName,size,isWritable,(void*)ff_block->sva);
  801686:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801689:	8b 40 08             	mov    0x8(%eax),%eax
  80168c:	89 c2                	mov    %eax,%edx
  80168e:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801692:	52                   	push   %edx
  801693:	50                   	push   %eax
  801694:	ff 75 0c             	pushl  0xc(%ebp)
  801697:	ff 75 08             	pushl  0x8(%ebp)
  80169a:	e8 2e 04 00 00       	call   801acd <sys_createSharedObject>
  80169f:	83 c4 10             	add    $0x10,%esp
  8016a2:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(obj_id < 0)
  8016a5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8016a9:	79 07                	jns    8016b2 <smalloc+0x9a>
			return (void*)NULL ;
  8016ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b0:	eb 0d                	jmp    8016bf <smalloc+0xa7>
		else
		    return (void*)ff_block->sva ;
  8016b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016b5:	8b 40 08             	mov    0x8(%eax),%eax
  8016b8:	eb 05                	jmp    8016bf <smalloc+0xa7>
		}
		return (void*)NULL ;
  8016ba:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8016bf:	c9                   	leave  
  8016c0:	c3                   	ret    

008016c1 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016c1:	55                   	push   %ebp
  8016c2:	89 e5                	mov    %esp,%ebp
  8016c4:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016c7:	e8 5b fc ff ff       	call   801327 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8016cc:	83 ec 08             	sub    $0x8,%esp
  8016cf:	ff 75 0c             	pushl  0xc(%ebp)
  8016d2:	ff 75 08             	pushl  0x8(%ebp)
  8016d5:	e8 1d 04 00 00       	call   801af7 <sys_getSizeOfSharedObject>
  8016da:	83 c4 10             	add    $0x10,%esp
  8016dd:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(size == 0)
  8016e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016e4:	75 0a                	jne    8016f0 <sget+0x2f>
			return NULL ;
  8016e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8016eb:	e9 83 00 00 00       	jmp    801773 <sget+0xb2>
		size=ROUNDUP(size,PAGE_SIZE);
  8016f0:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8016f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016fd:	01 d0                	add    %edx,%eax
  8016ff:	48                   	dec    %eax
  801700:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801703:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801706:	ba 00 00 00 00       	mov    $0x0,%edx
  80170b:	f7 75 f0             	divl   -0x10(%ebp)
  80170e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801711:	29 d0                	sub    %edx,%eax
  801713:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801716:	e8 2d 06 00 00       	call   801d48 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80171b:	85 c0                	test   %eax,%eax
  80171d:	74 4f                	je     80176e <sget+0xad>
		{
			struct MemBlock * ff_block ;
				ff_block = alloc_block_FF(size);
  80171f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801722:	83 ec 0c             	sub    $0xc,%esp
  801725:	50                   	push   %eax
  801726:	e8 2e 0d 00 00       	call   802459 <alloc_block_FF>
  80172b:	83 c4 10             	add    $0x10,%esp
  80172e:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ff_block==NULL)
  801731:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801735:	75 07                	jne    80173e <sget+0x7d>
					return (void*)NULL ;
  801737:	b8 00 00 00 00       	mov    $0x0,%eax
  80173c:	eb 35                	jmp    801773 <sget+0xb2>

		int obj_id =sys_getSharedObject((int)ownerEnvID,sharedVarName,(void*)ff_block->sva);
  80173e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801741:	8b 40 08             	mov    0x8(%eax),%eax
  801744:	83 ec 04             	sub    $0x4,%esp
  801747:	50                   	push   %eax
  801748:	ff 75 0c             	pushl  0xc(%ebp)
  80174b:	ff 75 08             	pushl  0x8(%ebp)
  80174e:	e8 c1 03 00 00       	call   801b14 <sys_getSharedObject>
  801753:	83 c4 10             	add    $0x10,%esp
  801756:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if(obj_id<0)
  801759:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80175d:	79 07                	jns    801766 <sget+0xa5>
				return (void*)NULL ;
  80175f:	b8 00 00 00 00       	mov    $0x0,%eax
  801764:	eb 0d                	jmp    801773 <sget+0xb2>
			else
				return (void*)ff_block->sva ;
  801766:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801769:	8b 40 08             	mov    0x8(%eax),%eax
  80176c:	eb 05                	jmp    801773 <sget+0xb2>


		}
	return (void*)NULL ;
  80176e:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801773:	c9                   	leave  
  801774:	c3                   	ret    

00801775 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801775:	55                   	push   %ebp
  801776:	89 e5                	mov    %esp,%ebp
  801778:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80177b:	e8 a7 fb ff ff       	call   801327 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801780:	83 ec 04             	sub    $0x4,%esp
  801783:	68 c0 3a 80 00       	push   $0x803ac0
  801788:	68 f9 00 00 00       	push   $0xf9
  80178d:	68 b3 3a 80 00       	push   $0x803ab3
  801792:	e8 52 eb ff ff       	call   8002e9 <_panic>

00801797 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801797:	55                   	push   %ebp
  801798:	89 e5                	mov    %esp,%ebp
  80179a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80179d:	83 ec 04             	sub    $0x4,%esp
  8017a0:	68 e8 3a 80 00       	push   $0x803ae8
  8017a5:	68 0d 01 00 00       	push   $0x10d
  8017aa:	68 b3 3a 80 00       	push   $0x803ab3
  8017af:	e8 35 eb ff ff       	call   8002e9 <_panic>

008017b4 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8017b4:	55                   	push   %ebp
  8017b5:	89 e5                	mov    %esp,%ebp
  8017b7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017ba:	83 ec 04             	sub    $0x4,%esp
  8017bd:	68 0c 3b 80 00       	push   $0x803b0c
  8017c2:	68 18 01 00 00       	push   $0x118
  8017c7:	68 b3 3a 80 00       	push   $0x803ab3
  8017cc:	e8 18 eb ff ff       	call   8002e9 <_panic>

008017d1 <shrink>:

}
void shrink(uint32 newSize)
{
  8017d1:	55                   	push   %ebp
  8017d2:	89 e5                	mov    %esp,%ebp
  8017d4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017d7:	83 ec 04             	sub    $0x4,%esp
  8017da:	68 0c 3b 80 00       	push   $0x803b0c
  8017df:	68 1d 01 00 00       	push   $0x11d
  8017e4:	68 b3 3a 80 00       	push   $0x803ab3
  8017e9:	e8 fb ea ff ff       	call   8002e9 <_panic>

008017ee <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8017ee:	55                   	push   %ebp
  8017ef:	89 e5                	mov    %esp,%ebp
  8017f1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017f4:	83 ec 04             	sub    $0x4,%esp
  8017f7:	68 0c 3b 80 00       	push   $0x803b0c
  8017fc:	68 22 01 00 00       	push   $0x122
  801801:	68 b3 3a 80 00       	push   $0x803ab3
  801806:	e8 de ea ff ff       	call   8002e9 <_panic>

0080180b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80180b:	55                   	push   %ebp
  80180c:	89 e5                	mov    %esp,%ebp
  80180e:	57                   	push   %edi
  80180f:	56                   	push   %esi
  801810:	53                   	push   %ebx
  801811:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801814:	8b 45 08             	mov    0x8(%ebp),%eax
  801817:	8b 55 0c             	mov    0xc(%ebp),%edx
  80181a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80181d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801820:	8b 7d 18             	mov    0x18(%ebp),%edi
  801823:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801826:	cd 30                	int    $0x30
  801828:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80182b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80182e:	83 c4 10             	add    $0x10,%esp
  801831:	5b                   	pop    %ebx
  801832:	5e                   	pop    %esi
  801833:	5f                   	pop    %edi
  801834:	5d                   	pop    %ebp
  801835:	c3                   	ret    

00801836 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801836:	55                   	push   %ebp
  801837:	89 e5                	mov    %esp,%ebp
  801839:	83 ec 04             	sub    $0x4,%esp
  80183c:	8b 45 10             	mov    0x10(%ebp),%eax
  80183f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801842:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801846:	8b 45 08             	mov    0x8(%ebp),%eax
  801849:	6a 00                	push   $0x0
  80184b:	6a 00                	push   $0x0
  80184d:	52                   	push   %edx
  80184e:	ff 75 0c             	pushl  0xc(%ebp)
  801851:	50                   	push   %eax
  801852:	6a 00                	push   $0x0
  801854:	e8 b2 ff ff ff       	call   80180b <syscall>
  801859:	83 c4 18             	add    $0x18,%esp
}
  80185c:	90                   	nop
  80185d:	c9                   	leave  
  80185e:	c3                   	ret    

0080185f <sys_cgetc>:

int
sys_cgetc(void)
{
  80185f:	55                   	push   %ebp
  801860:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	6a 00                	push   $0x0
  80186a:	6a 00                	push   $0x0
  80186c:	6a 01                	push   $0x1
  80186e:	e8 98 ff ff ff       	call   80180b <syscall>
  801873:	83 c4 18             	add    $0x18,%esp
}
  801876:	c9                   	leave  
  801877:	c3                   	ret    

00801878 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801878:	55                   	push   %ebp
  801879:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80187b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80187e:	8b 45 08             	mov    0x8(%ebp),%eax
  801881:	6a 00                	push   $0x0
  801883:	6a 00                	push   $0x0
  801885:	6a 00                	push   $0x0
  801887:	52                   	push   %edx
  801888:	50                   	push   %eax
  801889:	6a 05                	push   $0x5
  80188b:	e8 7b ff ff ff       	call   80180b <syscall>
  801890:	83 c4 18             	add    $0x18,%esp
}
  801893:	c9                   	leave  
  801894:	c3                   	ret    

00801895 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801895:	55                   	push   %ebp
  801896:	89 e5                	mov    %esp,%ebp
  801898:	56                   	push   %esi
  801899:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80189a:	8b 75 18             	mov    0x18(%ebp),%esi
  80189d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018a0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a9:	56                   	push   %esi
  8018aa:	53                   	push   %ebx
  8018ab:	51                   	push   %ecx
  8018ac:	52                   	push   %edx
  8018ad:	50                   	push   %eax
  8018ae:	6a 06                	push   $0x6
  8018b0:	e8 56 ff ff ff       	call   80180b <syscall>
  8018b5:	83 c4 18             	add    $0x18,%esp
}
  8018b8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018bb:	5b                   	pop    %ebx
  8018bc:	5e                   	pop    %esi
  8018bd:	5d                   	pop    %ebp
  8018be:	c3                   	ret    

008018bf <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018bf:	55                   	push   %ebp
  8018c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 00                	push   $0x0
  8018ce:	52                   	push   %edx
  8018cf:	50                   	push   %eax
  8018d0:	6a 07                	push   $0x7
  8018d2:	e8 34 ff ff ff       	call   80180b <syscall>
  8018d7:	83 c4 18             	add    $0x18,%esp
}
  8018da:	c9                   	leave  
  8018db:	c3                   	ret    

008018dc <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018dc:	55                   	push   %ebp
  8018dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018df:	6a 00                	push   $0x0
  8018e1:	6a 00                	push   $0x0
  8018e3:	6a 00                	push   $0x0
  8018e5:	ff 75 0c             	pushl  0xc(%ebp)
  8018e8:	ff 75 08             	pushl  0x8(%ebp)
  8018eb:	6a 08                	push   $0x8
  8018ed:	e8 19 ff ff ff       	call   80180b <syscall>
  8018f2:	83 c4 18             	add    $0x18,%esp
}
  8018f5:	c9                   	leave  
  8018f6:	c3                   	ret    

008018f7 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8018f7:	55                   	push   %ebp
  8018f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	6a 00                	push   $0x0
  801904:	6a 09                	push   $0x9
  801906:	e8 00 ff ff ff       	call   80180b <syscall>
  80190b:	83 c4 18             	add    $0x18,%esp
}
  80190e:	c9                   	leave  
  80190f:	c3                   	ret    

00801910 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801910:	55                   	push   %ebp
  801911:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801913:	6a 00                	push   $0x0
  801915:	6a 00                	push   $0x0
  801917:	6a 00                	push   $0x0
  801919:	6a 00                	push   $0x0
  80191b:	6a 00                	push   $0x0
  80191d:	6a 0a                	push   $0xa
  80191f:	e8 e7 fe ff ff       	call   80180b <syscall>
  801924:	83 c4 18             	add    $0x18,%esp
}
  801927:	c9                   	leave  
  801928:	c3                   	ret    

00801929 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801929:	55                   	push   %ebp
  80192a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80192c:	6a 00                	push   $0x0
  80192e:	6a 00                	push   $0x0
  801930:	6a 00                	push   $0x0
  801932:	6a 00                	push   $0x0
  801934:	6a 00                	push   $0x0
  801936:	6a 0b                	push   $0xb
  801938:	e8 ce fe ff ff       	call   80180b <syscall>
  80193d:	83 c4 18             	add    $0x18,%esp
}
  801940:	c9                   	leave  
  801941:	c3                   	ret    

00801942 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801942:	55                   	push   %ebp
  801943:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801945:	6a 00                	push   $0x0
  801947:	6a 00                	push   $0x0
  801949:	6a 00                	push   $0x0
  80194b:	ff 75 0c             	pushl  0xc(%ebp)
  80194e:	ff 75 08             	pushl  0x8(%ebp)
  801951:	6a 0f                	push   $0xf
  801953:	e8 b3 fe ff ff       	call   80180b <syscall>
  801958:	83 c4 18             	add    $0x18,%esp
	return;
  80195b:	90                   	nop
}
  80195c:	c9                   	leave  
  80195d:	c3                   	ret    

0080195e <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80195e:	55                   	push   %ebp
  80195f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801961:	6a 00                	push   $0x0
  801963:	6a 00                	push   $0x0
  801965:	6a 00                	push   $0x0
  801967:	ff 75 0c             	pushl  0xc(%ebp)
  80196a:	ff 75 08             	pushl  0x8(%ebp)
  80196d:	6a 10                	push   $0x10
  80196f:	e8 97 fe ff ff       	call   80180b <syscall>
  801974:	83 c4 18             	add    $0x18,%esp
	return ;
  801977:	90                   	nop
}
  801978:	c9                   	leave  
  801979:	c3                   	ret    

0080197a <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80197a:	55                   	push   %ebp
  80197b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80197d:	6a 00                	push   $0x0
  80197f:	6a 00                	push   $0x0
  801981:	ff 75 10             	pushl  0x10(%ebp)
  801984:	ff 75 0c             	pushl  0xc(%ebp)
  801987:	ff 75 08             	pushl  0x8(%ebp)
  80198a:	6a 11                	push   $0x11
  80198c:	e8 7a fe ff ff       	call   80180b <syscall>
  801991:	83 c4 18             	add    $0x18,%esp
	return ;
  801994:	90                   	nop
}
  801995:	c9                   	leave  
  801996:	c3                   	ret    

00801997 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801997:	55                   	push   %ebp
  801998:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80199a:	6a 00                	push   $0x0
  80199c:	6a 00                	push   $0x0
  80199e:	6a 00                	push   $0x0
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 0c                	push   $0xc
  8019a6:	e8 60 fe ff ff       	call   80180b <syscall>
  8019ab:	83 c4 18             	add    $0x18,%esp
}
  8019ae:	c9                   	leave  
  8019af:	c3                   	ret    

008019b0 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019b0:	55                   	push   %ebp
  8019b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 00                	push   $0x0
  8019bb:	ff 75 08             	pushl  0x8(%ebp)
  8019be:	6a 0d                	push   $0xd
  8019c0:	e8 46 fe ff ff       	call   80180b <syscall>
  8019c5:	83 c4 18             	add    $0x18,%esp
}
  8019c8:	c9                   	leave  
  8019c9:	c3                   	ret    

008019ca <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019ca:	55                   	push   %ebp
  8019cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 0e                	push   $0xe
  8019d9:	e8 2d fe ff ff       	call   80180b <syscall>
  8019de:	83 c4 18             	add    $0x18,%esp
}
  8019e1:	90                   	nop
  8019e2:	c9                   	leave  
  8019e3:	c3                   	ret    

008019e4 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8019e4:	55                   	push   %ebp
  8019e5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 13                	push   $0x13
  8019f3:	e8 13 fe ff ff       	call   80180b <syscall>
  8019f8:	83 c4 18             	add    $0x18,%esp
}
  8019fb:	90                   	nop
  8019fc:	c9                   	leave  
  8019fd:	c3                   	ret    

008019fe <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8019fe:	55                   	push   %ebp
  8019ff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a01:	6a 00                	push   $0x0
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 14                	push   $0x14
  801a0d:	e8 f9 fd ff ff       	call   80180b <syscall>
  801a12:	83 c4 18             	add    $0x18,%esp
}
  801a15:	90                   	nop
  801a16:	c9                   	leave  
  801a17:	c3                   	ret    

00801a18 <sys_cputc>:


void
sys_cputc(const char c)
{
  801a18:	55                   	push   %ebp
  801a19:	89 e5                	mov    %esp,%ebp
  801a1b:	83 ec 04             	sub    $0x4,%esp
  801a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a21:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a24:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	50                   	push   %eax
  801a31:	6a 15                	push   $0x15
  801a33:	e8 d3 fd ff ff       	call   80180b <syscall>
  801a38:	83 c4 18             	add    $0x18,%esp
}
  801a3b:	90                   	nop
  801a3c:	c9                   	leave  
  801a3d:	c3                   	ret    

00801a3e <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a3e:	55                   	push   %ebp
  801a3f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a41:	6a 00                	push   $0x0
  801a43:	6a 00                	push   $0x0
  801a45:	6a 00                	push   $0x0
  801a47:	6a 00                	push   $0x0
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 16                	push   $0x16
  801a4d:	e8 b9 fd ff ff       	call   80180b <syscall>
  801a52:	83 c4 18             	add    $0x18,%esp
}
  801a55:	90                   	nop
  801a56:	c9                   	leave  
  801a57:	c3                   	ret    

00801a58 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a58:	55                   	push   %ebp
  801a59:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 00                	push   $0x0
  801a62:	6a 00                	push   $0x0
  801a64:	ff 75 0c             	pushl  0xc(%ebp)
  801a67:	50                   	push   %eax
  801a68:	6a 17                	push   $0x17
  801a6a:	e8 9c fd ff ff       	call   80180b <syscall>
  801a6f:	83 c4 18             	add    $0x18,%esp
}
  801a72:	c9                   	leave  
  801a73:	c3                   	ret    

00801a74 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a74:	55                   	push   %ebp
  801a75:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a77:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	52                   	push   %edx
  801a84:	50                   	push   %eax
  801a85:	6a 1a                	push   $0x1a
  801a87:	e8 7f fd ff ff       	call   80180b <syscall>
  801a8c:	83 c4 18             	add    $0x18,%esp
}
  801a8f:	c9                   	leave  
  801a90:	c3                   	ret    

00801a91 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a91:	55                   	push   %ebp
  801a92:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a94:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a97:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	52                   	push   %edx
  801aa1:	50                   	push   %eax
  801aa2:	6a 18                	push   $0x18
  801aa4:	e8 62 fd ff ff       	call   80180b <syscall>
  801aa9:	83 c4 18             	add    $0x18,%esp
}
  801aac:	90                   	nop
  801aad:	c9                   	leave  
  801aae:	c3                   	ret    

00801aaf <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801aaf:	55                   	push   %ebp
  801ab0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ab2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	52                   	push   %edx
  801abf:	50                   	push   %eax
  801ac0:	6a 19                	push   $0x19
  801ac2:	e8 44 fd ff ff       	call   80180b <syscall>
  801ac7:	83 c4 18             	add    $0x18,%esp
}
  801aca:	90                   	nop
  801acb:	c9                   	leave  
  801acc:	c3                   	ret    

00801acd <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801acd:	55                   	push   %ebp
  801ace:	89 e5                	mov    %esp,%ebp
  801ad0:	83 ec 04             	sub    $0x4,%esp
  801ad3:	8b 45 10             	mov    0x10(%ebp),%eax
  801ad6:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801ad9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801adc:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae3:	6a 00                	push   $0x0
  801ae5:	51                   	push   %ecx
  801ae6:	52                   	push   %edx
  801ae7:	ff 75 0c             	pushl  0xc(%ebp)
  801aea:	50                   	push   %eax
  801aeb:	6a 1b                	push   $0x1b
  801aed:	e8 19 fd ff ff       	call   80180b <syscall>
  801af2:	83 c4 18             	add    $0x18,%esp
}
  801af5:	c9                   	leave  
  801af6:	c3                   	ret    

00801af7 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801af7:	55                   	push   %ebp
  801af8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801afa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801afd:	8b 45 08             	mov    0x8(%ebp),%eax
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	52                   	push   %edx
  801b07:	50                   	push   %eax
  801b08:	6a 1c                	push   $0x1c
  801b0a:	e8 fc fc ff ff       	call   80180b <syscall>
  801b0f:	83 c4 18             	add    $0x18,%esp
}
  801b12:	c9                   	leave  
  801b13:	c3                   	ret    

00801b14 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b14:	55                   	push   %ebp
  801b15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b17:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b1a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	51                   	push   %ecx
  801b25:	52                   	push   %edx
  801b26:	50                   	push   %eax
  801b27:	6a 1d                	push   $0x1d
  801b29:	e8 dd fc ff ff       	call   80180b <syscall>
  801b2e:	83 c4 18             	add    $0x18,%esp
}
  801b31:	c9                   	leave  
  801b32:	c3                   	ret    

00801b33 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b33:	55                   	push   %ebp
  801b34:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b36:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b39:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	52                   	push   %edx
  801b43:	50                   	push   %eax
  801b44:	6a 1e                	push   $0x1e
  801b46:	e8 c0 fc ff ff       	call   80180b <syscall>
  801b4b:	83 c4 18             	add    $0x18,%esp
}
  801b4e:	c9                   	leave  
  801b4f:	c3                   	ret    

00801b50 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b50:	55                   	push   %ebp
  801b51:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b53:	6a 00                	push   $0x0
  801b55:	6a 00                	push   $0x0
  801b57:	6a 00                	push   $0x0
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 00                	push   $0x0
  801b5d:	6a 1f                	push   $0x1f
  801b5f:	e8 a7 fc ff ff       	call   80180b <syscall>
  801b64:	83 c4 18             	add    $0x18,%esp
}
  801b67:	c9                   	leave  
  801b68:	c3                   	ret    

00801b69 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b69:	55                   	push   %ebp
  801b6a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6f:	6a 00                	push   $0x0
  801b71:	ff 75 14             	pushl  0x14(%ebp)
  801b74:	ff 75 10             	pushl  0x10(%ebp)
  801b77:	ff 75 0c             	pushl  0xc(%ebp)
  801b7a:	50                   	push   %eax
  801b7b:	6a 20                	push   $0x20
  801b7d:	e8 89 fc ff ff       	call   80180b <syscall>
  801b82:	83 c4 18             	add    $0x18,%esp
}
  801b85:	c9                   	leave  
  801b86:	c3                   	ret    

00801b87 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b87:	55                   	push   %ebp
  801b88:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	50                   	push   %eax
  801b96:	6a 21                	push   $0x21
  801b98:	e8 6e fc ff ff       	call   80180b <syscall>
  801b9d:	83 c4 18             	add    $0x18,%esp
}
  801ba0:	90                   	nop
  801ba1:	c9                   	leave  
  801ba2:	c3                   	ret    

00801ba3 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801ba3:	55                   	push   %ebp
  801ba4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	6a 00                	push   $0x0
  801baf:	6a 00                	push   $0x0
  801bb1:	50                   	push   %eax
  801bb2:	6a 22                	push   $0x22
  801bb4:	e8 52 fc ff ff       	call   80180b <syscall>
  801bb9:	83 c4 18             	add    $0x18,%esp
}
  801bbc:	c9                   	leave  
  801bbd:	c3                   	ret    

00801bbe <sys_getenvid>:

int32 sys_getenvid(void)
{
  801bbe:	55                   	push   %ebp
  801bbf:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 02                	push   $0x2
  801bcd:	e8 39 fc ff ff       	call   80180b <syscall>
  801bd2:	83 c4 18             	add    $0x18,%esp
}
  801bd5:	c9                   	leave  
  801bd6:	c3                   	ret    

00801bd7 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801bd7:	55                   	push   %ebp
  801bd8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 00                	push   $0x0
  801be0:	6a 00                	push   $0x0
  801be2:	6a 00                	push   $0x0
  801be4:	6a 03                	push   $0x3
  801be6:	e8 20 fc ff ff       	call   80180b <syscall>
  801beb:	83 c4 18             	add    $0x18,%esp
}
  801bee:	c9                   	leave  
  801bef:	c3                   	ret    

00801bf0 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801bf0:	55                   	push   %ebp
  801bf1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 00                	push   $0x0
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 04                	push   $0x4
  801bff:	e8 07 fc ff ff       	call   80180b <syscall>
  801c04:	83 c4 18             	add    $0x18,%esp
}
  801c07:	c9                   	leave  
  801c08:	c3                   	ret    

00801c09 <sys_exit_env>:


void sys_exit_env(void)
{
  801c09:	55                   	push   %ebp
  801c0a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 00                	push   $0x0
  801c12:	6a 00                	push   $0x0
  801c14:	6a 00                	push   $0x0
  801c16:	6a 23                	push   $0x23
  801c18:	e8 ee fb ff ff       	call   80180b <syscall>
  801c1d:	83 c4 18             	add    $0x18,%esp
}
  801c20:	90                   	nop
  801c21:	c9                   	leave  
  801c22:	c3                   	ret    

00801c23 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c23:	55                   	push   %ebp
  801c24:	89 e5                	mov    %esp,%ebp
  801c26:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c29:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c2c:	8d 50 04             	lea    0x4(%eax),%edx
  801c2f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	52                   	push   %edx
  801c39:	50                   	push   %eax
  801c3a:	6a 24                	push   $0x24
  801c3c:	e8 ca fb ff ff       	call   80180b <syscall>
  801c41:	83 c4 18             	add    $0x18,%esp
	return result;
  801c44:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c47:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c4a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c4d:	89 01                	mov    %eax,(%ecx)
  801c4f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c52:	8b 45 08             	mov    0x8(%ebp),%eax
  801c55:	c9                   	leave  
  801c56:	c2 04 00             	ret    $0x4

00801c59 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c59:	55                   	push   %ebp
  801c5a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 00                	push   $0x0
  801c60:	ff 75 10             	pushl  0x10(%ebp)
  801c63:	ff 75 0c             	pushl  0xc(%ebp)
  801c66:	ff 75 08             	pushl  0x8(%ebp)
  801c69:	6a 12                	push   $0x12
  801c6b:	e8 9b fb ff ff       	call   80180b <syscall>
  801c70:	83 c4 18             	add    $0x18,%esp
	return ;
  801c73:	90                   	nop
}
  801c74:	c9                   	leave  
  801c75:	c3                   	ret    

00801c76 <sys_rcr2>:
uint32 sys_rcr2()
{
  801c76:	55                   	push   %ebp
  801c77:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 00                	push   $0x0
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 00                	push   $0x0
  801c83:	6a 25                	push   $0x25
  801c85:	e8 81 fb ff ff       	call   80180b <syscall>
  801c8a:	83 c4 18             	add    $0x18,%esp
}
  801c8d:	c9                   	leave  
  801c8e:	c3                   	ret    

00801c8f <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c8f:	55                   	push   %ebp
  801c90:	89 e5                	mov    %esp,%ebp
  801c92:	83 ec 04             	sub    $0x4,%esp
  801c95:	8b 45 08             	mov    0x8(%ebp),%eax
  801c98:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c9b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c9f:	6a 00                	push   $0x0
  801ca1:	6a 00                	push   $0x0
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	50                   	push   %eax
  801ca8:	6a 26                	push   $0x26
  801caa:	e8 5c fb ff ff       	call   80180b <syscall>
  801caf:	83 c4 18             	add    $0x18,%esp
	return ;
  801cb2:	90                   	nop
}
  801cb3:	c9                   	leave  
  801cb4:	c3                   	ret    

00801cb5 <rsttst>:
void rsttst()
{
  801cb5:	55                   	push   %ebp
  801cb6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 28                	push   $0x28
  801cc4:	e8 42 fb ff ff       	call   80180b <syscall>
  801cc9:	83 c4 18             	add    $0x18,%esp
	return ;
  801ccc:	90                   	nop
}
  801ccd:	c9                   	leave  
  801cce:	c3                   	ret    

00801ccf <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ccf:	55                   	push   %ebp
  801cd0:	89 e5                	mov    %esp,%ebp
  801cd2:	83 ec 04             	sub    $0x4,%esp
  801cd5:	8b 45 14             	mov    0x14(%ebp),%eax
  801cd8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801cdb:	8b 55 18             	mov    0x18(%ebp),%edx
  801cde:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ce2:	52                   	push   %edx
  801ce3:	50                   	push   %eax
  801ce4:	ff 75 10             	pushl  0x10(%ebp)
  801ce7:	ff 75 0c             	pushl  0xc(%ebp)
  801cea:	ff 75 08             	pushl  0x8(%ebp)
  801ced:	6a 27                	push   $0x27
  801cef:	e8 17 fb ff ff       	call   80180b <syscall>
  801cf4:	83 c4 18             	add    $0x18,%esp
	return ;
  801cf7:	90                   	nop
}
  801cf8:	c9                   	leave  
  801cf9:	c3                   	ret    

00801cfa <chktst>:
void chktst(uint32 n)
{
  801cfa:	55                   	push   %ebp
  801cfb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801cfd:	6a 00                	push   $0x0
  801cff:	6a 00                	push   $0x0
  801d01:	6a 00                	push   $0x0
  801d03:	6a 00                	push   $0x0
  801d05:	ff 75 08             	pushl  0x8(%ebp)
  801d08:	6a 29                	push   $0x29
  801d0a:	e8 fc fa ff ff       	call   80180b <syscall>
  801d0f:	83 c4 18             	add    $0x18,%esp
	return ;
  801d12:	90                   	nop
}
  801d13:	c9                   	leave  
  801d14:	c3                   	ret    

00801d15 <inctst>:

void inctst()
{
  801d15:	55                   	push   %ebp
  801d16:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 00                	push   $0x0
  801d22:	6a 2a                	push   $0x2a
  801d24:	e8 e2 fa ff ff       	call   80180b <syscall>
  801d29:	83 c4 18             	add    $0x18,%esp
	return ;
  801d2c:	90                   	nop
}
  801d2d:	c9                   	leave  
  801d2e:	c3                   	ret    

00801d2f <gettst>:
uint32 gettst()
{
  801d2f:	55                   	push   %ebp
  801d30:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d32:	6a 00                	push   $0x0
  801d34:	6a 00                	push   $0x0
  801d36:	6a 00                	push   $0x0
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 00                	push   $0x0
  801d3c:	6a 2b                	push   $0x2b
  801d3e:	e8 c8 fa ff ff       	call   80180b <syscall>
  801d43:	83 c4 18             	add    $0x18,%esp
}
  801d46:	c9                   	leave  
  801d47:	c3                   	ret    

00801d48 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d48:	55                   	push   %ebp
  801d49:	89 e5                	mov    %esp,%ebp
  801d4b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d4e:	6a 00                	push   $0x0
  801d50:	6a 00                	push   $0x0
  801d52:	6a 00                	push   $0x0
  801d54:	6a 00                	push   $0x0
  801d56:	6a 00                	push   $0x0
  801d58:	6a 2c                	push   $0x2c
  801d5a:	e8 ac fa ff ff       	call   80180b <syscall>
  801d5f:	83 c4 18             	add    $0x18,%esp
  801d62:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d65:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d69:	75 07                	jne    801d72 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d6b:	b8 01 00 00 00       	mov    $0x1,%eax
  801d70:	eb 05                	jmp    801d77 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d72:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d77:	c9                   	leave  
  801d78:	c3                   	ret    

00801d79 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d79:	55                   	push   %ebp
  801d7a:	89 e5                	mov    %esp,%ebp
  801d7c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 00                	push   $0x0
  801d83:	6a 00                	push   $0x0
  801d85:	6a 00                	push   $0x0
  801d87:	6a 00                	push   $0x0
  801d89:	6a 2c                	push   $0x2c
  801d8b:	e8 7b fa ff ff       	call   80180b <syscall>
  801d90:	83 c4 18             	add    $0x18,%esp
  801d93:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d96:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d9a:	75 07                	jne    801da3 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d9c:	b8 01 00 00 00       	mov    $0x1,%eax
  801da1:	eb 05                	jmp    801da8 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801da3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801da8:	c9                   	leave  
  801da9:	c3                   	ret    

00801daa <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801daa:	55                   	push   %ebp
  801dab:	89 e5                	mov    %esp,%ebp
  801dad:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801db0:	6a 00                	push   $0x0
  801db2:	6a 00                	push   $0x0
  801db4:	6a 00                	push   $0x0
  801db6:	6a 00                	push   $0x0
  801db8:	6a 00                	push   $0x0
  801dba:	6a 2c                	push   $0x2c
  801dbc:	e8 4a fa ff ff       	call   80180b <syscall>
  801dc1:	83 c4 18             	add    $0x18,%esp
  801dc4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801dc7:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801dcb:	75 07                	jne    801dd4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801dcd:	b8 01 00 00 00       	mov    $0x1,%eax
  801dd2:	eb 05                	jmp    801dd9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801dd4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dd9:	c9                   	leave  
  801dda:	c3                   	ret    

00801ddb <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801ddb:	55                   	push   %ebp
  801ddc:	89 e5                	mov    %esp,%ebp
  801dde:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801de1:	6a 00                	push   $0x0
  801de3:	6a 00                	push   $0x0
  801de5:	6a 00                	push   $0x0
  801de7:	6a 00                	push   $0x0
  801de9:	6a 00                	push   $0x0
  801deb:	6a 2c                	push   $0x2c
  801ded:	e8 19 fa ff ff       	call   80180b <syscall>
  801df2:	83 c4 18             	add    $0x18,%esp
  801df5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801df8:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801dfc:	75 07                	jne    801e05 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801dfe:	b8 01 00 00 00       	mov    $0x1,%eax
  801e03:	eb 05                	jmp    801e0a <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e05:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e0a:	c9                   	leave  
  801e0b:	c3                   	ret    

00801e0c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e0c:	55                   	push   %ebp
  801e0d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	6a 00                	push   $0x0
  801e17:	ff 75 08             	pushl  0x8(%ebp)
  801e1a:	6a 2d                	push   $0x2d
  801e1c:	e8 ea f9 ff ff       	call   80180b <syscall>
  801e21:	83 c4 18             	add    $0x18,%esp
	return ;
  801e24:	90                   	nop
}
  801e25:	c9                   	leave  
  801e26:	c3                   	ret    

00801e27 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e27:	55                   	push   %ebp
  801e28:	89 e5                	mov    %esp,%ebp
  801e2a:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e2b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e2e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e31:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e34:	8b 45 08             	mov    0x8(%ebp),%eax
  801e37:	6a 00                	push   $0x0
  801e39:	53                   	push   %ebx
  801e3a:	51                   	push   %ecx
  801e3b:	52                   	push   %edx
  801e3c:	50                   	push   %eax
  801e3d:	6a 2e                	push   $0x2e
  801e3f:	e8 c7 f9 ff ff       	call   80180b <syscall>
  801e44:	83 c4 18             	add    $0x18,%esp
}
  801e47:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e4a:	c9                   	leave  
  801e4b:	c3                   	ret    

00801e4c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e4c:	55                   	push   %ebp
  801e4d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e4f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e52:	8b 45 08             	mov    0x8(%ebp),%eax
  801e55:	6a 00                	push   $0x0
  801e57:	6a 00                	push   $0x0
  801e59:	6a 00                	push   $0x0
  801e5b:	52                   	push   %edx
  801e5c:	50                   	push   %eax
  801e5d:	6a 2f                	push   $0x2f
  801e5f:	e8 a7 f9 ff ff       	call   80180b <syscall>
  801e64:	83 c4 18             	add    $0x18,%esp
}
  801e67:	c9                   	leave  
  801e68:	c3                   	ret    

00801e69 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e69:	55                   	push   %ebp
  801e6a:	89 e5                	mov    %esp,%ebp
  801e6c:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e6f:	83 ec 0c             	sub    $0xc,%esp
  801e72:	68 1c 3b 80 00       	push   $0x803b1c
  801e77:	e8 21 e7 ff ff       	call   80059d <cprintf>
  801e7c:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e7f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801e86:	83 ec 0c             	sub    $0xc,%esp
  801e89:	68 48 3b 80 00       	push   $0x803b48
  801e8e:	e8 0a e7 ff ff       	call   80059d <cprintf>
  801e93:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801e96:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e9a:	a1 38 41 80 00       	mov    0x804138,%eax
  801e9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ea2:	eb 56                	jmp    801efa <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ea4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ea8:	74 1c                	je     801ec6 <print_mem_block_lists+0x5d>
  801eaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ead:	8b 50 08             	mov    0x8(%eax),%edx
  801eb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eb3:	8b 48 08             	mov    0x8(%eax),%ecx
  801eb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eb9:	8b 40 0c             	mov    0xc(%eax),%eax
  801ebc:	01 c8                	add    %ecx,%eax
  801ebe:	39 c2                	cmp    %eax,%edx
  801ec0:	73 04                	jae    801ec6 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801ec2:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801ec6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec9:	8b 50 08             	mov    0x8(%eax),%edx
  801ecc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ecf:	8b 40 0c             	mov    0xc(%eax),%eax
  801ed2:	01 c2                	add    %eax,%edx
  801ed4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed7:	8b 40 08             	mov    0x8(%eax),%eax
  801eda:	83 ec 04             	sub    $0x4,%esp
  801edd:	52                   	push   %edx
  801ede:	50                   	push   %eax
  801edf:	68 5d 3b 80 00       	push   $0x803b5d
  801ee4:	e8 b4 e6 ff ff       	call   80059d <cprintf>
  801ee9:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801eec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eef:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ef2:	a1 40 41 80 00       	mov    0x804140,%eax
  801ef7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801efa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801efe:	74 07                	je     801f07 <print_mem_block_lists+0x9e>
  801f00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f03:	8b 00                	mov    (%eax),%eax
  801f05:	eb 05                	jmp    801f0c <print_mem_block_lists+0xa3>
  801f07:	b8 00 00 00 00       	mov    $0x0,%eax
  801f0c:	a3 40 41 80 00       	mov    %eax,0x804140
  801f11:	a1 40 41 80 00       	mov    0x804140,%eax
  801f16:	85 c0                	test   %eax,%eax
  801f18:	75 8a                	jne    801ea4 <print_mem_block_lists+0x3b>
  801f1a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f1e:	75 84                	jne    801ea4 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f20:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f24:	75 10                	jne    801f36 <print_mem_block_lists+0xcd>
  801f26:	83 ec 0c             	sub    $0xc,%esp
  801f29:	68 6c 3b 80 00       	push   $0x803b6c
  801f2e:	e8 6a e6 ff ff       	call   80059d <cprintf>
  801f33:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f36:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f3d:	83 ec 0c             	sub    $0xc,%esp
  801f40:	68 90 3b 80 00       	push   $0x803b90
  801f45:	e8 53 e6 ff ff       	call   80059d <cprintf>
  801f4a:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f4d:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f51:	a1 40 40 80 00       	mov    0x804040,%eax
  801f56:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f59:	eb 56                	jmp    801fb1 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f5b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f5f:	74 1c                	je     801f7d <print_mem_block_lists+0x114>
  801f61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f64:	8b 50 08             	mov    0x8(%eax),%edx
  801f67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f6a:	8b 48 08             	mov    0x8(%eax),%ecx
  801f6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f70:	8b 40 0c             	mov    0xc(%eax),%eax
  801f73:	01 c8                	add    %ecx,%eax
  801f75:	39 c2                	cmp    %eax,%edx
  801f77:	73 04                	jae    801f7d <print_mem_block_lists+0x114>
			sorted = 0 ;
  801f79:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f80:	8b 50 08             	mov    0x8(%eax),%edx
  801f83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f86:	8b 40 0c             	mov    0xc(%eax),%eax
  801f89:	01 c2                	add    %eax,%edx
  801f8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8e:	8b 40 08             	mov    0x8(%eax),%eax
  801f91:	83 ec 04             	sub    $0x4,%esp
  801f94:	52                   	push   %edx
  801f95:	50                   	push   %eax
  801f96:	68 5d 3b 80 00       	push   $0x803b5d
  801f9b:	e8 fd e5 ff ff       	call   80059d <cprintf>
  801fa0:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801fa9:	a1 48 40 80 00       	mov    0x804048,%eax
  801fae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fb1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fb5:	74 07                	je     801fbe <print_mem_block_lists+0x155>
  801fb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fba:	8b 00                	mov    (%eax),%eax
  801fbc:	eb 05                	jmp    801fc3 <print_mem_block_lists+0x15a>
  801fbe:	b8 00 00 00 00       	mov    $0x0,%eax
  801fc3:	a3 48 40 80 00       	mov    %eax,0x804048
  801fc8:	a1 48 40 80 00       	mov    0x804048,%eax
  801fcd:	85 c0                	test   %eax,%eax
  801fcf:	75 8a                	jne    801f5b <print_mem_block_lists+0xf2>
  801fd1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fd5:	75 84                	jne    801f5b <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801fd7:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fdb:	75 10                	jne    801fed <print_mem_block_lists+0x184>
  801fdd:	83 ec 0c             	sub    $0xc,%esp
  801fe0:	68 a8 3b 80 00       	push   $0x803ba8
  801fe5:	e8 b3 e5 ff ff       	call   80059d <cprintf>
  801fea:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801fed:	83 ec 0c             	sub    $0xc,%esp
  801ff0:	68 1c 3b 80 00       	push   $0x803b1c
  801ff5:	e8 a3 e5 ff ff       	call   80059d <cprintf>
  801ffa:	83 c4 10             	add    $0x10,%esp

}
  801ffd:	90                   	nop
  801ffe:	c9                   	leave  
  801fff:	c3                   	ret    

00802000 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802000:	55                   	push   %ebp
  802001:	89 e5                	mov    %esp,%ebp
  802003:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  802006:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  80200d:	00 00 00 
  802010:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  802017:	00 00 00 
  80201a:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802021:	00 00 00 
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  802024:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80202b:	e9 9e 00 00 00       	jmp    8020ce <initialize_MemBlocksList+0xce>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
  802030:	a1 50 40 80 00       	mov    0x804050,%eax
  802035:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802038:	c1 e2 04             	shl    $0x4,%edx
  80203b:	01 d0                	add    %edx,%eax
  80203d:	85 c0                	test   %eax,%eax
  80203f:	75 14                	jne    802055 <initialize_MemBlocksList+0x55>
  802041:	83 ec 04             	sub    $0x4,%esp
  802044:	68 d0 3b 80 00       	push   $0x803bd0
  802049:	6a 43                	push   $0x43
  80204b:	68 f3 3b 80 00       	push   $0x803bf3
  802050:	e8 94 e2 ff ff       	call   8002e9 <_panic>
  802055:	a1 50 40 80 00       	mov    0x804050,%eax
  80205a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80205d:	c1 e2 04             	shl    $0x4,%edx
  802060:	01 d0                	add    %edx,%eax
  802062:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802068:	89 10                	mov    %edx,(%eax)
  80206a:	8b 00                	mov    (%eax),%eax
  80206c:	85 c0                	test   %eax,%eax
  80206e:	74 18                	je     802088 <initialize_MemBlocksList+0x88>
  802070:	a1 48 41 80 00       	mov    0x804148,%eax
  802075:	8b 15 50 40 80 00    	mov    0x804050,%edx
  80207b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80207e:	c1 e1 04             	shl    $0x4,%ecx
  802081:	01 ca                	add    %ecx,%edx
  802083:	89 50 04             	mov    %edx,0x4(%eax)
  802086:	eb 12                	jmp    80209a <initialize_MemBlocksList+0x9a>
  802088:	a1 50 40 80 00       	mov    0x804050,%eax
  80208d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802090:	c1 e2 04             	shl    $0x4,%edx
  802093:	01 d0                	add    %edx,%eax
  802095:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80209a:	a1 50 40 80 00       	mov    0x804050,%eax
  80209f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020a2:	c1 e2 04             	shl    $0x4,%edx
  8020a5:	01 d0                	add    %edx,%eax
  8020a7:	a3 48 41 80 00       	mov    %eax,0x804148
  8020ac:	a1 50 40 80 00       	mov    0x804050,%eax
  8020b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020b4:	c1 e2 04             	shl    $0x4,%edx
  8020b7:	01 d0                	add    %edx,%eax
  8020b9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020c0:	a1 54 41 80 00       	mov    0x804154,%eax
  8020c5:	40                   	inc    %eax
  8020c6:	a3 54 41 80 00       	mov    %eax,0x804154
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  8020cb:	ff 45 f4             	incl   -0xc(%ebp)
  8020ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020d4:	0f 82 56 ff ff ff    	jb     802030 <initialize_MemBlocksList+0x30>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
		}
}
  8020da:	90                   	nop
  8020db:	c9                   	leave  
  8020dc:	c3                   	ret    

008020dd <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8020dd:	55                   	push   %ebp
  8020de:	89 e5                	mov    %esp,%ebp
  8020e0:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  8020e3:	a1 38 41 80 00       	mov    0x804138,%eax
  8020e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020eb:	eb 18                	jmp    802105 <find_block+0x28>
	{
		if (ele->sva==va)
  8020ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020f0:	8b 40 08             	mov    0x8(%eax),%eax
  8020f3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8020f6:	75 05                	jne    8020fd <find_block+0x20>
			return ele;
  8020f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020fb:	eb 7b                	jmp    802178 <find_block+0x9b>
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  8020fd:	a1 40 41 80 00       	mov    0x804140,%eax
  802102:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802105:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802109:	74 07                	je     802112 <find_block+0x35>
  80210b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80210e:	8b 00                	mov    (%eax),%eax
  802110:	eb 05                	jmp    802117 <find_block+0x3a>
  802112:	b8 00 00 00 00       	mov    $0x0,%eax
  802117:	a3 40 41 80 00       	mov    %eax,0x804140
  80211c:	a1 40 41 80 00       	mov    0x804140,%eax
  802121:	85 c0                	test   %eax,%eax
  802123:	75 c8                	jne    8020ed <find_block+0x10>
  802125:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802129:	75 c2                	jne    8020ed <find_block+0x10>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  80212b:	a1 40 40 80 00       	mov    0x804040,%eax
  802130:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802133:	eb 18                	jmp    80214d <find_block+0x70>
	{
		if (ele->sva==va)
  802135:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802138:	8b 40 08             	mov    0x8(%eax),%eax
  80213b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80213e:	75 05                	jne    802145 <find_block+0x68>
					return ele;
  802140:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802143:	eb 33                	jmp    802178 <find_block+0x9b>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  802145:	a1 48 40 80 00       	mov    0x804048,%eax
  80214a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80214d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802151:	74 07                	je     80215a <find_block+0x7d>
  802153:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802156:	8b 00                	mov    (%eax),%eax
  802158:	eb 05                	jmp    80215f <find_block+0x82>
  80215a:	b8 00 00 00 00       	mov    $0x0,%eax
  80215f:	a3 48 40 80 00       	mov    %eax,0x804048
  802164:	a1 48 40 80 00       	mov    0x804048,%eax
  802169:	85 c0                	test   %eax,%eax
  80216b:	75 c8                	jne    802135 <find_block+0x58>
  80216d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802171:	75 c2                	jne    802135 <find_block+0x58>
	{
		if (ele->sva==va)
					return ele;
	}
return NULL;
  802173:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802178:	c9                   	leave  
  802179:	c3                   	ret    

0080217a <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80217a:	55                   	push   %ebp
  80217b:	89 e5                	mov    %esp,%ebp
  80217d:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;

int x =LIST_SIZE(&AllocMemBlocksList);
  802180:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802185:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((x==0))
  802188:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80218c:	75 62                	jne    8021f0 <insert_sorted_allocList+0x76>
	{
	//	blockToInsert=AllocMemBlocksList.lh_first;
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  80218e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802192:	75 14                	jne    8021a8 <insert_sorted_allocList+0x2e>
  802194:	83 ec 04             	sub    $0x4,%esp
  802197:	68 d0 3b 80 00       	push   $0x803bd0
  80219c:	6a 69                	push   $0x69
  80219e:	68 f3 3b 80 00       	push   $0x803bf3
  8021a3:	e8 41 e1 ff ff       	call   8002e9 <_panic>
  8021a8:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8021ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b1:	89 10                	mov    %edx,(%eax)
  8021b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b6:	8b 00                	mov    (%eax),%eax
  8021b8:	85 c0                	test   %eax,%eax
  8021ba:	74 0d                	je     8021c9 <insert_sorted_allocList+0x4f>
  8021bc:	a1 40 40 80 00       	mov    0x804040,%eax
  8021c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8021c4:	89 50 04             	mov    %edx,0x4(%eax)
  8021c7:	eb 08                	jmp    8021d1 <insert_sorted_allocList+0x57>
  8021c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cc:	a3 44 40 80 00       	mov    %eax,0x804044
  8021d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d4:	a3 40 40 80 00       	mov    %eax,0x804040
  8021d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021dc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021e3:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021e8:	40                   	inc    %eax
  8021e9:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8021ee:	eb 72                	jmp    802262 <insert_sorted_allocList+0xe8>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
  8021f0:	a1 40 40 80 00       	mov    0x804040,%eax
  8021f5:	8b 50 08             	mov    0x8(%eax),%edx
  8021f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fb:	8b 40 08             	mov    0x8(%eax),%eax
  8021fe:	39 c2                	cmp    %eax,%edx
  802200:	76 60                	jbe    802262 <insert_sorted_allocList+0xe8>
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  802202:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802206:	75 14                	jne    80221c <insert_sorted_allocList+0xa2>
  802208:	83 ec 04             	sub    $0x4,%esp
  80220b:	68 d0 3b 80 00       	push   $0x803bd0
  802210:	6a 6d                	push   $0x6d
  802212:	68 f3 3b 80 00       	push   $0x803bf3
  802217:	e8 cd e0 ff ff       	call   8002e9 <_panic>
  80221c:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802222:	8b 45 08             	mov    0x8(%ebp),%eax
  802225:	89 10                	mov    %edx,(%eax)
  802227:	8b 45 08             	mov    0x8(%ebp),%eax
  80222a:	8b 00                	mov    (%eax),%eax
  80222c:	85 c0                	test   %eax,%eax
  80222e:	74 0d                	je     80223d <insert_sorted_allocList+0xc3>
  802230:	a1 40 40 80 00       	mov    0x804040,%eax
  802235:	8b 55 08             	mov    0x8(%ebp),%edx
  802238:	89 50 04             	mov    %edx,0x4(%eax)
  80223b:	eb 08                	jmp    802245 <insert_sorted_allocList+0xcb>
  80223d:	8b 45 08             	mov    0x8(%ebp),%eax
  802240:	a3 44 40 80 00       	mov    %eax,0x804044
  802245:	8b 45 08             	mov    0x8(%ebp),%eax
  802248:	a3 40 40 80 00       	mov    %eax,0x804040
  80224d:	8b 45 08             	mov    0x8(%ebp),%eax
  802250:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802257:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80225c:	40                   	inc    %eax
  80225d:	a3 4c 40 80 00       	mov    %eax,0x80404c
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  802262:	a1 40 40 80 00       	mov    0x804040,%eax
  802267:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80226a:	e9 b9 01 00 00       	jmp    802428 <insert_sorted_allocList+0x2ae>
	{


		if ((blockToInsert->sva>AllocMemBlocksList.lh_first->sva)&&blockToInsert->sva<element->sva)
  80226f:	8b 45 08             	mov    0x8(%ebp),%eax
  802272:	8b 50 08             	mov    0x8(%eax),%edx
  802275:	a1 40 40 80 00       	mov    0x804040,%eax
  80227a:	8b 40 08             	mov    0x8(%eax),%eax
  80227d:	39 c2                	cmp    %eax,%edx
  80227f:	76 7c                	jbe    8022fd <insert_sorted_allocList+0x183>
  802281:	8b 45 08             	mov    0x8(%ebp),%eax
  802284:	8b 50 08             	mov    0x8(%eax),%edx
  802287:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228a:	8b 40 08             	mov    0x8(%eax),%eax
  80228d:	39 c2                	cmp    %eax,%edx
  80228f:	73 6c                	jae    8022fd <insert_sorted_allocList+0x183>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,element,blockToInsert);
  802291:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802295:	74 06                	je     80229d <insert_sorted_allocList+0x123>
  802297:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80229b:	75 14                	jne    8022b1 <insert_sorted_allocList+0x137>
  80229d:	83 ec 04             	sub    $0x4,%esp
  8022a0:	68 0c 3c 80 00       	push   $0x803c0c
  8022a5:	6a 75                	push   $0x75
  8022a7:	68 f3 3b 80 00       	push   $0x803bf3
  8022ac:	e8 38 e0 ff ff       	call   8002e9 <_panic>
  8022b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b4:	8b 50 04             	mov    0x4(%eax),%edx
  8022b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ba:	89 50 04             	mov    %edx,0x4(%eax)
  8022bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022c3:	89 10                	mov    %edx,(%eax)
  8022c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c8:	8b 40 04             	mov    0x4(%eax),%eax
  8022cb:	85 c0                	test   %eax,%eax
  8022cd:	74 0d                	je     8022dc <insert_sorted_allocList+0x162>
  8022cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d2:	8b 40 04             	mov    0x4(%eax),%eax
  8022d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8022d8:	89 10                	mov    %edx,(%eax)
  8022da:	eb 08                	jmp    8022e4 <insert_sorted_allocList+0x16a>
  8022dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022df:	a3 40 40 80 00       	mov    %eax,0x804040
  8022e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8022ea:	89 50 04             	mov    %edx,0x4(%eax)
  8022ed:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022f2:	40                   	inc    %eax
  8022f3:	a3 4c 40 80 00       	mov    %eax,0x80404c

		break;}
  8022f8:	e9 59 01 00 00       	jmp    802456 <insert_sorted_allocList+0x2dc>

	else if ((blockToInsert->sva>element->sva)&&(blockToInsert->sva<AllocMemBlocksList.lh_last->sva)&&blockToInsert->sva<LIST_NEXT(element)->sva)
  8022fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802300:	8b 50 08             	mov    0x8(%eax),%edx
  802303:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802306:	8b 40 08             	mov    0x8(%eax),%eax
  802309:	39 c2                	cmp    %eax,%edx
  80230b:	0f 86 98 00 00 00    	jbe    8023a9 <insert_sorted_allocList+0x22f>
  802311:	8b 45 08             	mov    0x8(%ebp),%eax
  802314:	8b 50 08             	mov    0x8(%eax),%edx
  802317:	a1 44 40 80 00       	mov    0x804044,%eax
  80231c:	8b 40 08             	mov    0x8(%eax),%eax
  80231f:	39 c2                	cmp    %eax,%edx
  802321:	0f 83 82 00 00 00    	jae    8023a9 <insert_sorted_allocList+0x22f>
  802327:	8b 45 08             	mov    0x8(%ebp),%eax
  80232a:	8b 50 08             	mov    0x8(%eax),%edx
  80232d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802330:	8b 00                	mov    (%eax),%eax
  802332:	8b 40 08             	mov    0x8(%eax),%eax
  802335:	39 c2                	cmp    %eax,%edx
  802337:	73 70                	jae    8023a9 <insert_sorted_allocList+0x22f>
	{

	LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  802339:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80233d:	74 06                	je     802345 <insert_sorted_allocList+0x1cb>
  80233f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802343:	75 14                	jne    802359 <insert_sorted_allocList+0x1df>
  802345:	83 ec 04             	sub    $0x4,%esp
  802348:	68 44 3c 80 00       	push   $0x803c44
  80234d:	6a 7c                	push   $0x7c
  80234f:	68 f3 3b 80 00       	push   $0x803bf3
  802354:	e8 90 df ff ff       	call   8002e9 <_panic>
  802359:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235c:	8b 10                	mov    (%eax),%edx
  80235e:	8b 45 08             	mov    0x8(%ebp),%eax
  802361:	89 10                	mov    %edx,(%eax)
  802363:	8b 45 08             	mov    0x8(%ebp),%eax
  802366:	8b 00                	mov    (%eax),%eax
  802368:	85 c0                	test   %eax,%eax
  80236a:	74 0b                	je     802377 <insert_sorted_allocList+0x1fd>
  80236c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236f:	8b 00                	mov    (%eax),%eax
  802371:	8b 55 08             	mov    0x8(%ebp),%edx
  802374:	89 50 04             	mov    %edx,0x4(%eax)
  802377:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237a:	8b 55 08             	mov    0x8(%ebp),%edx
  80237d:	89 10                	mov    %edx,(%eax)
  80237f:	8b 45 08             	mov    0x8(%ebp),%eax
  802382:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802385:	89 50 04             	mov    %edx,0x4(%eax)
  802388:	8b 45 08             	mov    0x8(%ebp),%eax
  80238b:	8b 00                	mov    (%eax),%eax
  80238d:	85 c0                	test   %eax,%eax
  80238f:	75 08                	jne    802399 <insert_sorted_allocList+0x21f>
  802391:	8b 45 08             	mov    0x8(%ebp),%eax
  802394:	a3 44 40 80 00       	mov    %eax,0x804044
  802399:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80239e:	40                   	inc    %eax
  80239f:	a3 4c 40 80 00       	mov    %eax,0x80404c
		break;
  8023a4:	e9 ad 00 00 00       	jmp    802456 <insert_sorted_allocList+0x2dc>
	}else if (blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  8023a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ac:	8b 50 08             	mov    0x8(%eax),%edx
  8023af:	a1 44 40 80 00       	mov    0x804044,%eax
  8023b4:	8b 40 08             	mov    0x8(%eax),%eax
  8023b7:	39 c2                	cmp    %eax,%edx
  8023b9:	76 65                	jbe    802420 <insert_sorted_allocList+0x2a6>
	{
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
  8023bb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023bf:	75 17                	jne    8023d8 <insert_sorted_allocList+0x25e>
  8023c1:	83 ec 04             	sub    $0x4,%esp
  8023c4:	68 78 3c 80 00       	push   $0x803c78
  8023c9:	68 80 00 00 00       	push   $0x80
  8023ce:	68 f3 3b 80 00       	push   $0x803bf3
  8023d3:	e8 11 df ff ff       	call   8002e9 <_panic>
  8023d8:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8023de:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e1:	89 50 04             	mov    %edx,0x4(%eax)
  8023e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e7:	8b 40 04             	mov    0x4(%eax),%eax
  8023ea:	85 c0                	test   %eax,%eax
  8023ec:	74 0c                	je     8023fa <insert_sorted_allocList+0x280>
  8023ee:	a1 44 40 80 00       	mov    0x804044,%eax
  8023f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8023f6:	89 10                	mov    %edx,(%eax)
  8023f8:	eb 08                	jmp    802402 <insert_sorted_allocList+0x288>
  8023fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fd:	a3 40 40 80 00       	mov    %eax,0x804040
  802402:	8b 45 08             	mov    0x8(%ebp),%eax
  802405:	a3 44 40 80 00       	mov    %eax,0x804044
  80240a:	8b 45 08             	mov    0x8(%ebp),%eax
  80240d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802413:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802418:	40                   	inc    %eax
  802419:	a3 4c 40 80 00       	mov    %eax,0x80404c
		break;
  80241e:	eb 36                	jmp    802456 <insert_sorted_allocList+0x2dc>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  802420:	a1 48 40 80 00       	mov    0x804048,%eax
  802425:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802428:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80242c:	74 07                	je     802435 <insert_sorted_allocList+0x2bb>
  80242e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802431:	8b 00                	mov    (%eax),%eax
  802433:	eb 05                	jmp    80243a <insert_sorted_allocList+0x2c0>
  802435:	b8 00 00 00 00       	mov    $0x0,%eax
  80243a:	a3 48 40 80 00       	mov    %eax,0x804048
  80243f:	a1 48 40 80 00       	mov    0x804048,%eax
  802444:	85 c0                	test   %eax,%eax
  802446:	0f 85 23 fe ff ff    	jne    80226f <insert_sorted_allocList+0xf5>
  80244c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802450:	0f 85 19 fe ff ff    	jne    80226f <insert_sorted_allocList+0xf5>
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
		break;

	}
	}
}
  802456:	90                   	nop
  802457:	c9                   	leave  
  802458:	c3                   	ret    

00802459 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802459:	55                   	push   %ebp
  80245a:	89 e5                	mov    %esp,%ebp
  80245c:	83 ec 18             	sub    $0x18,%esp
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  80245f:	a1 38 41 80 00       	mov    0x804138,%eax
  802464:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802467:	e9 7c 01 00 00       	jmp    8025e8 <alloc_block_FF+0x18f>
		{
			// case 2
				if(element->size == size)
  80246c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246f:	8b 40 0c             	mov    0xc(%eax),%eax
  802472:	3b 45 08             	cmp    0x8(%ebp),%eax
  802475:	0f 85 90 00 00 00    	jne    80250b <alloc_block_FF+0xb2>
				{
					tmp_block=element;
  80247b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247e:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,element);
  802481:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802485:	75 17                	jne    80249e <alloc_block_FF+0x45>
  802487:	83 ec 04             	sub    $0x4,%esp
  80248a:	68 9b 3c 80 00       	push   $0x803c9b
  80248f:	68 ba 00 00 00       	push   $0xba
  802494:	68 f3 3b 80 00       	push   $0x803bf3
  802499:	e8 4b de ff ff       	call   8002e9 <_panic>
  80249e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a1:	8b 00                	mov    (%eax),%eax
  8024a3:	85 c0                	test   %eax,%eax
  8024a5:	74 10                	je     8024b7 <alloc_block_FF+0x5e>
  8024a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024aa:	8b 00                	mov    (%eax),%eax
  8024ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024af:	8b 52 04             	mov    0x4(%edx),%edx
  8024b2:	89 50 04             	mov    %edx,0x4(%eax)
  8024b5:	eb 0b                	jmp    8024c2 <alloc_block_FF+0x69>
  8024b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ba:	8b 40 04             	mov    0x4(%eax),%eax
  8024bd:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8024c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c5:	8b 40 04             	mov    0x4(%eax),%eax
  8024c8:	85 c0                	test   %eax,%eax
  8024ca:	74 0f                	je     8024db <alloc_block_FF+0x82>
  8024cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cf:	8b 40 04             	mov    0x4(%eax),%eax
  8024d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024d5:	8b 12                	mov    (%edx),%edx
  8024d7:	89 10                	mov    %edx,(%eax)
  8024d9:	eb 0a                	jmp    8024e5 <alloc_block_FF+0x8c>
  8024db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024de:	8b 00                	mov    (%eax),%eax
  8024e0:	a3 38 41 80 00       	mov    %eax,0x804138
  8024e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024f8:	a1 44 41 80 00       	mov    0x804144,%eax
  8024fd:	48                   	dec    %eax
  8024fe:	a3 44 41 80 00       	mov    %eax,0x804144
					return tmp_block;
  802503:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802506:	e9 10 01 00 00       	jmp    80261b <alloc_block_FF+0x1c2>
				}
				 // case 3
				else if(element->size > size)
  80250b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250e:	8b 40 0c             	mov    0xc(%eax),%eax
  802511:	3b 45 08             	cmp    0x8(%ebp),%eax
  802514:	0f 86 c6 00 00 00    	jbe    8025e0 <alloc_block_FF+0x187>
				{
					// the new block are created
					tmp_block = AvailableMemBlocksList.lh_first ;
  80251a:	a1 48 41 80 00       	mov    0x804148,%eax
  80251f:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  802522:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802526:	75 17                	jne    80253f <alloc_block_FF+0xe6>
  802528:	83 ec 04             	sub    $0x4,%esp
  80252b:	68 9b 3c 80 00       	push   $0x803c9b
  802530:	68 c2 00 00 00       	push   $0xc2
  802535:	68 f3 3b 80 00       	push   $0x803bf3
  80253a:	e8 aa dd ff ff       	call   8002e9 <_panic>
  80253f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802542:	8b 00                	mov    (%eax),%eax
  802544:	85 c0                	test   %eax,%eax
  802546:	74 10                	je     802558 <alloc_block_FF+0xff>
  802548:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80254b:	8b 00                	mov    (%eax),%eax
  80254d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802550:	8b 52 04             	mov    0x4(%edx),%edx
  802553:	89 50 04             	mov    %edx,0x4(%eax)
  802556:	eb 0b                	jmp    802563 <alloc_block_FF+0x10a>
  802558:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80255b:	8b 40 04             	mov    0x4(%eax),%eax
  80255e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802563:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802566:	8b 40 04             	mov    0x4(%eax),%eax
  802569:	85 c0                	test   %eax,%eax
  80256b:	74 0f                	je     80257c <alloc_block_FF+0x123>
  80256d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802570:	8b 40 04             	mov    0x4(%eax),%eax
  802573:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802576:	8b 12                	mov    (%edx),%edx
  802578:	89 10                	mov    %edx,(%eax)
  80257a:	eb 0a                	jmp    802586 <alloc_block_FF+0x12d>
  80257c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80257f:	8b 00                	mov    (%eax),%eax
  802581:	a3 48 41 80 00       	mov    %eax,0x804148
  802586:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802589:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80258f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802592:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802599:	a1 54 41 80 00       	mov    0x804154,%eax
  80259e:	48                   	dec    %eax
  80259f:	a3 54 41 80 00       	mov    %eax,0x804154
					tmp_block->sva=element->sva;
  8025a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a7:	8b 50 08             	mov    0x8(%eax),%edx
  8025aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ad:	89 50 08             	mov    %edx,0x8(%eax)
					tmp_block->size=size;
  8025b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8025b6:	89 50 0c             	mov    %edx,0xc(%eax)
					//update block with remaining space
					element->size-=size;
  8025b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8025bf:	2b 45 08             	sub    0x8(%ebp),%eax
  8025c2:	89 c2                	mov    %eax,%edx
  8025c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c7:	89 50 0c             	mov    %edx,0xc(%eax)
					element->sva = element->sva + size;
  8025ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cd:	8b 50 08             	mov    0x8(%eax),%edx
  8025d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d3:	01 c2                	add    %eax,%edx
  8025d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d8:	89 50 08             	mov    %edx,0x8(%eax)
					// return back the new block
					return tmp_block ;
  8025db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025de:	eb 3b                	jmp    80261b <alloc_block_FF+0x1c2>
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  8025e0:	a1 40 41 80 00       	mov    0x804140,%eax
  8025e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025ec:	74 07                	je     8025f5 <alloc_block_FF+0x19c>
  8025ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f1:	8b 00                	mov    (%eax),%eax
  8025f3:	eb 05                	jmp    8025fa <alloc_block_FF+0x1a1>
  8025f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8025fa:	a3 40 41 80 00       	mov    %eax,0x804140
  8025ff:	a1 40 41 80 00       	mov    0x804140,%eax
  802604:	85 c0                	test   %eax,%eax
  802606:	0f 85 60 fe ff ff    	jne    80246c <alloc_block_FF+0x13>
  80260c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802610:	0f 85 56 fe ff ff    	jne    80246c <alloc_block_FF+0x13>
					// return back the new block
					return tmp_block ;
				}
		}
		// case 1
	  return NULL ;}
  802616:	b8 00 00 00 00       	mov    $0x0,%eax
  80261b:	c9                   	leave  
  80261c:	c3                   	ret    

0080261d <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================

struct MemBlock *alloc_block_BF(uint32 size)
{
  80261d:	55                   	push   %ebp
  80261e:	89 e5                	mov    %esp,%ebp
  802620:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
  802623:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		LIST_FOREACH(element, &(FreeMemBlocksList))
  80262a:	a1 38 41 80 00       	mov    0x804138,%eax
  80262f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802632:	eb 3a                	jmp    80266e <alloc_block_BF+0x51>
		{
			if(element->size >= size)
  802634:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802637:	8b 40 0c             	mov    0xc(%eax),%eax
  80263a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80263d:	72 27                	jb     802666 <alloc_block_BF+0x49>
			{
				if(best_size==-1)
  80263f:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802643:	75 0b                	jne    802650 <alloc_block_BF+0x33>
					best_size= element->size;
  802645:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802648:	8b 40 0c             	mov    0xc(%eax),%eax
  80264b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80264e:	eb 16                	jmp    802666 <alloc_block_BF+0x49>
				else if(best_size >= element->size)
  802650:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802653:	8b 50 0c             	mov    0xc(%eax),%edx
  802656:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802659:	39 c2                	cmp    %eax,%edx
  80265b:	77 09                	ja     802666 <alloc_block_BF+0x49>
					best_size=element->size;
  80265d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802660:	8b 40 0c             	mov    0xc(%eax),%eax
  802663:	89 45 f0             	mov    %eax,-0x10(%ebp)

struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802666:	a1 40 41 80 00       	mov    0x804140,%eax
  80266b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80266e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802672:	74 07                	je     80267b <alloc_block_BF+0x5e>
  802674:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802677:	8b 00                	mov    (%eax),%eax
  802679:	eb 05                	jmp    802680 <alloc_block_BF+0x63>
  80267b:	b8 00 00 00 00       	mov    $0x0,%eax
  802680:	a3 40 41 80 00       	mov    %eax,0x804140
  802685:	a1 40 41 80 00       	mov    0x804140,%eax
  80268a:	85 c0                	test   %eax,%eax
  80268c:	75 a6                	jne    802634 <alloc_block_BF+0x17>
  80268e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802692:	75 a0                	jne    802634 <alloc_block_BF+0x17>
					best_size= element->size;
				else if(best_size >= element->size)
					best_size=element->size;
			}
		}
		if(best_size != -1)
  802694:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802698:	0f 84 d3 01 00 00    	je     802871 <alloc_block_BF+0x254>
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  80269e:	a1 38 41 80 00       	mov    0x804138,%eax
  8026a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026a6:	e9 98 01 00 00       	jmp    802843 <alloc_block_BF+0x226>
			{
			 if((best_size > size) && (best_size == element->size))
  8026ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ae:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026b1:	0f 86 da 00 00 00    	jbe    802791 <alloc_block_BF+0x174>
  8026b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ba:	8b 50 0c             	mov    0xc(%eax),%edx
  8026bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026c0:	39 c2                	cmp    %eax,%edx
  8026c2:	0f 85 c9 00 00 00    	jne    802791 <alloc_block_BF+0x174>
			  {
				// the new block are created
			    tmp_block = AvailableMemBlocksList.lh_first ;
  8026c8:	a1 48 41 80 00       	mov    0x804148,%eax
  8026cd:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  8026d0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8026d4:	75 17                	jne    8026ed <alloc_block_BF+0xd0>
  8026d6:	83 ec 04             	sub    $0x4,%esp
  8026d9:	68 9b 3c 80 00       	push   $0x803c9b
  8026de:	68 ea 00 00 00       	push   $0xea
  8026e3:	68 f3 3b 80 00       	push   $0x803bf3
  8026e8:	e8 fc db ff ff       	call   8002e9 <_panic>
  8026ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026f0:	8b 00                	mov    (%eax),%eax
  8026f2:	85 c0                	test   %eax,%eax
  8026f4:	74 10                	je     802706 <alloc_block_BF+0xe9>
  8026f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026f9:	8b 00                	mov    (%eax),%eax
  8026fb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026fe:	8b 52 04             	mov    0x4(%edx),%edx
  802701:	89 50 04             	mov    %edx,0x4(%eax)
  802704:	eb 0b                	jmp    802711 <alloc_block_BF+0xf4>
  802706:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802709:	8b 40 04             	mov    0x4(%eax),%eax
  80270c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802711:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802714:	8b 40 04             	mov    0x4(%eax),%eax
  802717:	85 c0                	test   %eax,%eax
  802719:	74 0f                	je     80272a <alloc_block_BF+0x10d>
  80271b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80271e:	8b 40 04             	mov    0x4(%eax),%eax
  802721:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802724:	8b 12                	mov    (%edx),%edx
  802726:	89 10                	mov    %edx,(%eax)
  802728:	eb 0a                	jmp    802734 <alloc_block_BF+0x117>
  80272a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80272d:	8b 00                	mov    (%eax),%eax
  80272f:	a3 48 41 80 00       	mov    %eax,0x804148
  802734:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802737:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80273d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802740:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802747:	a1 54 41 80 00       	mov    0x804154,%eax
  80274c:	48                   	dec    %eax
  80274d:	a3 54 41 80 00       	mov    %eax,0x804154
				tmp_block->sva=element->sva;
  802752:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802755:	8b 50 08             	mov    0x8(%eax),%edx
  802758:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80275b:	89 50 08             	mov    %edx,0x8(%eax)
				tmp_block->size=size;
  80275e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802761:	8b 55 08             	mov    0x8(%ebp),%edx
  802764:	89 50 0c             	mov    %edx,0xc(%eax)
				//update block with remaining space
				element->size-=size;
  802767:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276a:	8b 40 0c             	mov    0xc(%eax),%eax
  80276d:	2b 45 08             	sub    0x8(%ebp),%eax
  802770:	89 c2                	mov    %eax,%edx
  802772:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802775:	89 50 0c             	mov    %edx,0xc(%eax)
				element->sva = element->sva + size;
  802778:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277b:	8b 50 08             	mov    0x8(%eax),%edx
  80277e:	8b 45 08             	mov    0x8(%ebp),%eax
  802781:	01 c2                	add    %eax,%edx
  802783:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802786:	89 50 08             	mov    %edx,0x8(%eax)
				// return back the new block
				return tmp_block ;
  802789:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80278c:	e9 e5 00 00 00       	jmp    802876 <alloc_block_BF+0x259>

			  }
			else if((element->size == best_size)&&(best_size == size))
  802791:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802794:	8b 50 0c             	mov    0xc(%eax),%edx
  802797:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80279a:	39 c2                	cmp    %eax,%edx
  80279c:	0f 85 99 00 00 00    	jne    80283b <alloc_block_BF+0x21e>
  8027a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027a5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027a8:	0f 85 8d 00 00 00    	jne    80283b <alloc_block_BF+0x21e>
			  {
				tmp_block=element;
  8027ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&FreeMemBlocksList,element);
  8027b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027b8:	75 17                	jne    8027d1 <alloc_block_BF+0x1b4>
  8027ba:	83 ec 04             	sub    $0x4,%esp
  8027bd:	68 9b 3c 80 00       	push   $0x803c9b
  8027c2:	68 f7 00 00 00       	push   $0xf7
  8027c7:	68 f3 3b 80 00       	push   $0x803bf3
  8027cc:	e8 18 db ff ff       	call   8002e9 <_panic>
  8027d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d4:	8b 00                	mov    (%eax),%eax
  8027d6:	85 c0                	test   %eax,%eax
  8027d8:	74 10                	je     8027ea <alloc_block_BF+0x1cd>
  8027da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027dd:	8b 00                	mov    (%eax),%eax
  8027df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027e2:	8b 52 04             	mov    0x4(%edx),%edx
  8027e5:	89 50 04             	mov    %edx,0x4(%eax)
  8027e8:	eb 0b                	jmp    8027f5 <alloc_block_BF+0x1d8>
  8027ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ed:	8b 40 04             	mov    0x4(%eax),%eax
  8027f0:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8027f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f8:	8b 40 04             	mov    0x4(%eax),%eax
  8027fb:	85 c0                	test   %eax,%eax
  8027fd:	74 0f                	je     80280e <alloc_block_BF+0x1f1>
  8027ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802802:	8b 40 04             	mov    0x4(%eax),%eax
  802805:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802808:	8b 12                	mov    (%edx),%edx
  80280a:	89 10                	mov    %edx,(%eax)
  80280c:	eb 0a                	jmp    802818 <alloc_block_BF+0x1fb>
  80280e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802811:	8b 00                	mov    (%eax),%eax
  802813:	a3 38 41 80 00       	mov    %eax,0x804138
  802818:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802821:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802824:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80282b:	a1 44 41 80 00       	mov    0x804144,%eax
  802830:	48                   	dec    %eax
  802831:	a3 44 41 80 00       	mov    %eax,0x804144
				return tmp_block;
  802836:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802839:	eb 3b                	jmp    802876 <alloc_block_BF+0x259>
					best_size=element->size;
			}
		}
		if(best_size != -1)
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  80283b:	a1 40 41 80 00       	mov    0x804140,%eax
  802840:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802843:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802847:	74 07                	je     802850 <alloc_block_BF+0x233>
  802849:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284c:	8b 00                	mov    (%eax),%eax
  80284e:	eb 05                	jmp    802855 <alloc_block_BF+0x238>
  802850:	b8 00 00 00 00       	mov    $0x0,%eax
  802855:	a3 40 41 80 00       	mov    %eax,0x804140
  80285a:	a1 40 41 80 00       	mov    0x804140,%eax
  80285f:	85 c0                	test   %eax,%eax
  802861:	0f 85 44 fe ff ff    	jne    8026ab <alloc_block_BF+0x8e>
  802867:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80286b:	0f 85 3a fe ff ff    	jne    8026ab <alloc_block_BF+0x8e>
				LIST_REMOVE(&FreeMemBlocksList,element);
				return tmp_block;
			 }
			}
		}
		return NULL ;}
  802871:	b8 00 00 00 00       	mov    $0x0,%eax
  802876:	c9                   	leave  
  802877:	c3                   	ret    

00802878 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802878:	55                   	push   %ebp
  802879:	89 e5                	mov    %esp,%ebp
  80287b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  80287e:	83 ec 04             	sub    $0x4,%esp
  802881:	68 bc 3c 80 00       	push   $0x803cbc
  802886:	68 04 01 00 00       	push   $0x104
  80288b:	68 f3 3b 80 00       	push   $0x803bf3
  802890:	e8 54 da ff ff       	call   8002e9 <_panic>

00802895 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{struct MemBlock * blk_itr;
  802895:	55                   	push   %ebp
  802896:	89 e5                	mov    %esp,%ebp
  802898:	83 ec 18             	sub    $0x18,%esp
struct MemBlock * next;
struct MemBlock * first = LIST_FIRST(&(FreeMemBlocksList));
  80289b:	a1 38 41 80 00       	mov    0x804138,%eax
  8028a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
struct MemBlock * last = LIST_LAST(&(FreeMemBlocksList));
  8028a3:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8028a8:	89 45 ec             	mov    %eax,-0x14(%ebp)

if(LIST_EMPTY(&(FreeMemBlocksList)))
  8028ab:	a1 38 41 80 00       	mov    0x804138,%eax
  8028b0:	85 c0                	test   %eax,%eax
  8028b2:	75 68                	jne    80291c <insert_sorted_with_merge_freeList+0x87>
			{

				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  8028b4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028b8:	75 17                	jne    8028d1 <insert_sorted_with_merge_freeList+0x3c>
  8028ba:	83 ec 04             	sub    $0x4,%esp
  8028bd:	68 d0 3b 80 00       	push   $0x803bd0
  8028c2:	68 14 01 00 00       	push   $0x114
  8028c7:	68 f3 3b 80 00       	push   $0x803bf3
  8028cc:	e8 18 da ff ff       	call   8002e9 <_panic>
  8028d1:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8028d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028da:	89 10                	mov    %edx,(%eax)
  8028dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8028df:	8b 00                	mov    (%eax),%eax
  8028e1:	85 c0                	test   %eax,%eax
  8028e3:	74 0d                	je     8028f2 <insert_sorted_with_merge_freeList+0x5d>
  8028e5:	a1 38 41 80 00       	mov    0x804138,%eax
  8028ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8028ed:	89 50 04             	mov    %edx,0x4(%eax)
  8028f0:	eb 08                	jmp    8028fa <insert_sorted_with_merge_freeList+0x65>
  8028f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f5:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8028fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8028fd:	a3 38 41 80 00       	mov    %eax,0x804138
  802902:	8b 45 08             	mov    0x8(%ebp),%eax
  802905:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80290c:	a1 44 41 80 00       	mov    0x804144,%eax
  802911:	40                   	inc    %eax
  802912:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  802917:	e9 d2 06 00 00       	jmp    802fee <insert_sorted_with_merge_freeList+0x759>
				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);

			}
else
{
	if( blockToInsert->sva  < first->sva )
  80291c:	8b 45 08             	mov    0x8(%ebp),%eax
  80291f:	8b 50 08             	mov    0x8(%eax),%edx
  802922:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802925:	8b 40 08             	mov    0x8(%eax),%eax
  802928:	39 c2                	cmp    %eax,%edx
  80292a:	0f 83 22 01 00 00    	jae    802a52 <insert_sorted_with_merge_freeList+0x1bd>
	{
                if( blockToInsert->sva + blockToInsert->size == first->sva)
  802930:	8b 45 08             	mov    0x8(%ebp),%eax
  802933:	8b 50 08             	mov    0x8(%eax),%edx
  802936:	8b 45 08             	mov    0x8(%ebp),%eax
  802939:	8b 40 0c             	mov    0xc(%eax),%eax
  80293c:	01 c2                	add    %eax,%edx
  80293e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802941:	8b 40 08             	mov    0x8(%eax),%eax
  802944:	39 c2                	cmp    %eax,%edx
  802946:	0f 85 9e 00 00 00    	jne    8029ea <insert_sorted_with_merge_freeList+0x155>
                {

                	first->sva = blockToInsert->sva;
  80294c:	8b 45 08             	mov    0x8(%ebp),%eax
  80294f:	8b 50 08             	mov    0x8(%eax),%edx
  802952:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802955:	89 50 08             	mov    %edx,0x8(%eax)
                	first->size = first->size + blockToInsert->size;
  802958:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80295b:	8b 50 0c             	mov    0xc(%eax),%edx
  80295e:	8b 45 08             	mov    0x8(%ebp),%eax
  802961:	8b 40 0c             	mov    0xc(%eax),%eax
  802964:	01 c2                	add    %eax,%edx
  802966:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802969:	89 50 0c             	mov    %edx,0xc(%eax)
                	blockToInsert->size = blockToInsert->sva = 0;
  80296c:	8b 45 08             	mov    0x8(%ebp),%eax
  80296f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802976:	8b 45 08             	mov    0x8(%ebp),%eax
  802979:	8b 50 08             	mov    0x8(%eax),%edx
  80297c:	8b 45 08             	mov    0x8(%ebp),%eax
  80297f:	89 50 0c             	mov    %edx,0xc(%eax)
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802982:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802986:	75 17                	jne    80299f <insert_sorted_with_merge_freeList+0x10a>
  802988:	83 ec 04             	sub    $0x4,%esp
  80298b:	68 d0 3b 80 00       	push   $0x803bd0
  802990:	68 21 01 00 00       	push   $0x121
  802995:	68 f3 3b 80 00       	push   $0x803bf3
  80299a:	e8 4a d9 ff ff       	call   8002e9 <_panic>
  80299f:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8029a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a8:	89 10                	mov    %edx,(%eax)
  8029aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ad:	8b 00                	mov    (%eax),%eax
  8029af:	85 c0                	test   %eax,%eax
  8029b1:	74 0d                	je     8029c0 <insert_sorted_with_merge_freeList+0x12b>
  8029b3:	a1 48 41 80 00       	mov    0x804148,%eax
  8029b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8029bb:	89 50 04             	mov    %edx,0x4(%eax)
  8029be:	eb 08                	jmp    8029c8 <insert_sorted_with_merge_freeList+0x133>
  8029c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c3:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8029c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029cb:	a3 48 41 80 00       	mov    %eax,0x804148
  8029d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029da:	a1 54 41 80 00       	mov    0x804154,%eax
  8029df:	40                   	inc    %eax
  8029e0:	a3 54 41 80 00       	mov    %eax,0x804154
						}
				}
        }

}
}
  8029e5:	e9 04 06 00 00       	jmp    802fee <insert_sorted_with_merge_freeList+0x759>
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
                }

                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  8029ea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029ee:	75 17                	jne    802a07 <insert_sorted_with_merge_freeList+0x172>
  8029f0:	83 ec 04             	sub    $0x4,%esp
  8029f3:	68 d0 3b 80 00       	push   $0x803bd0
  8029f8:	68 26 01 00 00       	push   $0x126
  8029fd:	68 f3 3b 80 00       	push   $0x803bf3
  802a02:	e8 e2 d8 ff ff       	call   8002e9 <_panic>
  802a07:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a10:	89 10                	mov    %edx,(%eax)
  802a12:	8b 45 08             	mov    0x8(%ebp),%eax
  802a15:	8b 00                	mov    (%eax),%eax
  802a17:	85 c0                	test   %eax,%eax
  802a19:	74 0d                	je     802a28 <insert_sorted_with_merge_freeList+0x193>
  802a1b:	a1 38 41 80 00       	mov    0x804138,%eax
  802a20:	8b 55 08             	mov    0x8(%ebp),%edx
  802a23:	89 50 04             	mov    %edx,0x4(%eax)
  802a26:	eb 08                	jmp    802a30 <insert_sorted_with_merge_freeList+0x19b>
  802a28:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a30:	8b 45 08             	mov    0x8(%ebp),%eax
  802a33:	a3 38 41 80 00       	mov    %eax,0x804138
  802a38:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a42:	a1 44 41 80 00       	mov    0x804144,%eax
  802a47:	40                   	inc    %eax
  802a48:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  802a4d:	e9 9c 05 00 00       	jmp    802fee <insert_sorted_with_merge_freeList+0x759>
                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
                }
	}
    else if(blockToInsert->sva > last->sva)
  802a52:	8b 45 08             	mov    0x8(%ebp),%eax
  802a55:	8b 50 08             	mov    0x8(%eax),%edx
  802a58:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a5b:	8b 40 08             	mov    0x8(%eax),%eax
  802a5e:	39 c2                	cmp    %eax,%edx
  802a60:	0f 86 16 01 00 00    	jbe    802b7c <insert_sorted_with_merge_freeList+0x2e7>
 	{

				if(last->sva + last->size == blockToInsert->sva)
  802a66:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a69:	8b 50 08             	mov    0x8(%eax),%edx
  802a6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a6f:	8b 40 0c             	mov    0xc(%eax),%eax
  802a72:	01 c2                	add    %eax,%edx
  802a74:	8b 45 08             	mov    0x8(%ebp),%eax
  802a77:	8b 40 08             	mov    0x8(%eax),%eax
  802a7a:	39 c2                	cmp    %eax,%edx
  802a7c:	0f 85 92 00 00 00    	jne    802b14 <insert_sorted_with_merge_freeList+0x27f>
				{

					last->size = last->size + blockToInsert->size;
  802a82:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a85:	8b 50 0c             	mov    0xc(%eax),%edx
  802a88:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8b:	8b 40 0c             	mov    0xc(%eax),%eax
  802a8e:	01 c2                	add    %eax,%edx
  802a90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a93:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->size = blockToInsert->sva = 0;
  802a96:	8b 45 08             	mov    0x8(%ebp),%eax
  802a99:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa3:	8b 50 08             	mov    0x8(%eax),%edx
  802aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa9:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802aac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ab0:	75 17                	jne    802ac9 <insert_sorted_with_merge_freeList+0x234>
  802ab2:	83 ec 04             	sub    $0x4,%esp
  802ab5:	68 d0 3b 80 00       	push   $0x803bd0
  802aba:	68 31 01 00 00       	push   $0x131
  802abf:	68 f3 3b 80 00       	push   $0x803bf3
  802ac4:	e8 20 d8 ff ff       	call   8002e9 <_panic>
  802ac9:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802acf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad2:	89 10                	mov    %edx,(%eax)
  802ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad7:	8b 00                	mov    (%eax),%eax
  802ad9:	85 c0                	test   %eax,%eax
  802adb:	74 0d                	je     802aea <insert_sorted_with_merge_freeList+0x255>
  802add:	a1 48 41 80 00       	mov    0x804148,%eax
  802ae2:	8b 55 08             	mov    0x8(%ebp),%edx
  802ae5:	89 50 04             	mov    %edx,0x4(%eax)
  802ae8:	eb 08                	jmp    802af2 <insert_sorted_with_merge_freeList+0x25d>
  802aea:	8b 45 08             	mov    0x8(%ebp),%eax
  802aed:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802af2:	8b 45 08             	mov    0x8(%ebp),%eax
  802af5:	a3 48 41 80 00       	mov    %eax,0x804148
  802afa:	8b 45 08             	mov    0x8(%ebp),%eax
  802afd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b04:	a1 54 41 80 00       	mov    0x804154,%eax
  802b09:	40                   	inc    %eax
  802b0a:	a3 54 41 80 00       	mov    %eax,0x804154
						}
				}
        }

}
}
  802b0f:	e9 da 04 00 00       	jmp    802fee <insert_sorted_with_merge_freeList+0x759>

				}

				else
				{
					LIST_INSERT_TAIL(&(FreeMemBlocksList),  blockToInsert);
  802b14:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b18:	75 17                	jne    802b31 <insert_sorted_with_merge_freeList+0x29c>
  802b1a:	83 ec 04             	sub    $0x4,%esp
  802b1d:	68 78 3c 80 00       	push   $0x803c78
  802b22:	68 37 01 00 00       	push   $0x137
  802b27:	68 f3 3b 80 00       	push   $0x803bf3
  802b2c:	e8 b8 d7 ff ff       	call   8002e9 <_panic>
  802b31:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802b37:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3a:	89 50 04             	mov    %edx,0x4(%eax)
  802b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b40:	8b 40 04             	mov    0x4(%eax),%eax
  802b43:	85 c0                	test   %eax,%eax
  802b45:	74 0c                	je     802b53 <insert_sorted_with_merge_freeList+0x2be>
  802b47:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b4c:	8b 55 08             	mov    0x8(%ebp),%edx
  802b4f:	89 10                	mov    %edx,(%eax)
  802b51:	eb 08                	jmp    802b5b <insert_sorted_with_merge_freeList+0x2c6>
  802b53:	8b 45 08             	mov    0x8(%ebp),%eax
  802b56:	a3 38 41 80 00       	mov    %eax,0x804138
  802b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b63:	8b 45 08             	mov    0x8(%ebp),%eax
  802b66:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b6c:	a1 44 41 80 00       	mov    0x804144,%eax
  802b71:	40                   	inc    %eax
  802b72:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  802b77:	e9 72 04 00 00       	jmp    802fee <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  802b7c:	a1 38 41 80 00       	mov    0x804138,%eax
  802b81:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b84:	e9 35 04 00 00       	jmp    802fbe <insert_sorted_with_merge_freeList+0x729>
				{
				     next=LIST_NEXT(blk_itr);
  802b89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8c:	8b 00                	mov    (%eax),%eax
  802b8e:	89 45 e8             	mov    %eax,-0x18(%ebp)


					if( (blockToInsert->sva > blk_itr->sva) )
  802b91:	8b 45 08             	mov    0x8(%ebp),%eax
  802b94:	8b 50 08             	mov    0x8(%eax),%edx
  802b97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9a:	8b 40 08             	mov    0x8(%eax),%eax
  802b9d:	39 c2                	cmp    %eax,%edx
  802b9f:	0f 86 11 04 00 00    	jbe    802fb6 <insert_sorted_with_merge_freeList+0x721>
						{
							if(((blk_itr->sva) + (blk_itr->size) < blockToInsert->sva && (blockToInsert->sva) + (blockToInsert->size) < next->sva))
  802ba5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba8:	8b 50 08             	mov    0x8(%eax),%edx
  802bab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bae:	8b 40 0c             	mov    0xc(%eax),%eax
  802bb1:	01 c2                	add    %eax,%edx
  802bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb6:	8b 40 08             	mov    0x8(%eax),%eax
  802bb9:	39 c2                	cmp    %eax,%edx
  802bbb:	0f 83 8b 00 00 00    	jae    802c4c <insert_sorted_with_merge_freeList+0x3b7>
  802bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc4:	8b 50 08             	mov    0x8(%eax),%edx
  802bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bca:	8b 40 0c             	mov    0xc(%eax),%eax
  802bcd:	01 c2                	add    %eax,%edx
  802bcf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bd2:	8b 40 08             	mov    0x8(%eax),%eax
  802bd5:	39 c2                	cmp    %eax,%edx
  802bd7:	73 73                	jae    802c4c <insert_sorted_with_merge_freeList+0x3b7>
							{
								LIST_INSERT_AFTER(&(FreeMemBlocksList), blk_itr, blockToInsert);
  802bd9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bdd:	74 06                	je     802be5 <insert_sorted_with_merge_freeList+0x350>
  802bdf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802be3:	75 17                	jne    802bfc <insert_sorted_with_merge_freeList+0x367>
  802be5:	83 ec 04             	sub    $0x4,%esp
  802be8:	68 44 3c 80 00       	push   $0x803c44
  802bed:	68 48 01 00 00       	push   $0x148
  802bf2:	68 f3 3b 80 00       	push   $0x803bf3
  802bf7:	e8 ed d6 ff ff       	call   8002e9 <_panic>
  802bfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bff:	8b 10                	mov    (%eax),%edx
  802c01:	8b 45 08             	mov    0x8(%ebp),%eax
  802c04:	89 10                	mov    %edx,(%eax)
  802c06:	8b 45 08             	mov    0x8(%ebp),%eax
  802c09:	8b 00                	mov    (%eax),%eax
  802c0b:	85 c0                	test   %eax,%eax
  802c0d:	74 0b                	je     802c1a <insert_sorted_with_merge_freeList+0x385>
  802c0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c12:	8b 00                	mov    (%eax),%eax
  802c14:	8b 55 08             	mov    0x8(%ebp),%edx
  802c17:	89 50 04             	mov    %edx,0x4(%eax)
  802c1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1d:	8b 55 08             	mov    0x8(%ebp),%edx
  802c20:	89 10                	mov    %edx,(%eax)
  802c22:	8b 45 08             	mov    0x8(%ebp),%eax
  802c25:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c28:	89 50 04             	mov    %edx,0x4(%eax)
  802c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2e:	8b 00                	mov    (%eax),%eax
  802c30:	85 c0                	test   %eax,%eax
  802c32:	75 08                	jne    802c3c <insert_sorted_with_merge_freeList+0x3a7>
  802c34:	8b 45 08             	mov    0x8(%ebp),%eax
  802c37:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c3c:	a1 44 41 80 00       	mov    0x804144,%eax
  802c41:	40                   	inc    %eax
  802c42:	a3 44 41 80 00       	mov    %eax,0x804144
								break;
  802c47:	e9 a2 03 00 00       	jmp    802fee <insert_sorted_with_merge_freeList+0x759>

							}
							else if((blockToInsert->sva + blockToInsert->size) < next->sva  && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  802c4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4f:	8b 50 08             	mov    0x8(%eax),%edx
  802c52:	8b 45 08             	mov    0x8(%ebp),%eax
  802c55:	8b 40 0c             	mov    0xc(%eax),%eax
  802c58:	01 c2                	add    %eax,%edx
  802c5a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c5d:	8b 40 08             	mov    0x8(%eax),%eax
  802c60:	39 c2                	cmp    %eax,%edx
  802c62:	0f 83 ae 00 00 00    	jae    802d16 <insert_sorted_with_merge_freeList+0x481>
  802c68:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6b:	8b 50 08             	mov    0x8(%eax),%edx
  802c6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c71:	8b 48 08             	mov    0x8(%eax),%ecx
  802c74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c77:	8b 40 0c             	mov    0xc(%eax),%eax
  802c7a:	01 c8                	add    %ecx,%eax
  802c7c:	39 c2                	cmp    %eax,%edx
  802c7e:	0f 85 92 00 00 00    	jne    802d16 <insert_sorted_with_merge_freeList+0x481>
							{

								blk_itr->size=blk_itr->size+blockToInsert->size;
  802c84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c87:	8b 50 0c             	mov    0xc(%eax),%edx
  802c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8d:	8b 40 0c             	mov    0xc(%eax),%eax
  802c90:	01 c2                	add    %eax,%edx
  802c92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c95:	89 50 0c             	mov    %edx,0xc(%eax)
								 blockToInsert->size=blockToInsert->sva=0;
  802c98:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca5:	8b 50 08             	mov    0x8(%eax),%edx
  802ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  802cab:	89 50 0c             	mov    %edx,0xc(%eax)
								 LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802cae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cb2:	75 17                	jne    802ccb <insert_sorted_with_merge_freeList+0x436>
  802cb4:	83 ec 04             	sub    $0x4,%esp
  802cb7:	68 d0 3b 80 00       	push   $0x803bd0
  802cbc:	68 51 01 00 00       	push   $0x151
  802cc1:	68 f3 3b 80 00       	push   $0x803bf3
  802cc6:	e8 1e d6 ff ff       	call   8002e9 <_panic>
  802ccb:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd4:	89 10                	mov    %edx,(%eax)
  802cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd9:	8b 00                	mov    (%eax),%eax
  802cdb:	85 c0                	test   %eax,%eax
  802cdd:	74 0d                	je     802cec <insert_sorted_with_merge_freeList+0x457>
  802cdf:	a1 48 41 80 00       	mov    0x804148,%eax
  802ce4:	8b 55 08             	mov    0x8(%ebp),%edx
  802ce7:	89 50 04             	mov    %edx,0x4(%eax)
  802cea:	eb 08                	jmp    802cf4 <insert_sorted_with_merge_freeList+0x45f>
  802cec:	8b 45 08             	mov    0x8(%ebp),%eax
  802cef:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf7:	a3 48 41 80 00       	mov    %eax,0x804148
  802cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  802cff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d06:	a1 54 41 80 00       	mov    0x804154,%eax
  802d0b:	40                   	inc    %eax
  802d0c:	a3 54 41 80 00       	mov    %eax,0x804154
								 break;
  802d11:	e9 d8 02 00 00       	jmp    802fee <insert_sorted_with_merge_freeList+0x759>

							}
							else if( (blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva > (blk_itr->sva + blk_itr->size))
  802d16:	8b 45 08             	mov    0x8(%ebp),%eax
  802d19:	8b 50 08             	mov    0x8(%eax),%edx
  802d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1f:	8b 40 0c             	mov    0xc(%eax),%eax
  802d22:	01 c2                	add    %eax,%edx
  802d24:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d27:	8b 40 08             	mov    0x8(%eax),%eax
  802d2a:	39 c2                	cmp    %eax,%edx
  802d2c:	0f 85 ba 00 00 00    	jne    802dec <insert_sorted_with_merge_freeList+0x557>
  802d32:	8b 45 08             	mov    0x8(%ebp),%eax
  802d35:	8b 50 08             	mov    0x8(%eax),%edx
  802d38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3b:	8b 48 08             	mov    0x8(%eax),%ecx
  802d3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d41:	8b 40 0c             	mov    0xc(%eax),%eax
  802d44:	01 c8                	add    %ecx,%eax
  802d46:	39 c2                	cmp    %eax,%edx
  802d48:	0f 86 9e 00 00 00    	jbe    802dec <insert_sorted_with_merge_freeList+0x557>
							{
								next->size = next->size + blockToInsert->size;
  802d4e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d51:	8b 50 0c             	mov    0xc(%eax),%edx
  802d54:	8b 45 08             	mov    0x8(%ebp),%eax
  802d57:	8b 40 0c             	mov    0xc(%eax),%eax
  802d5a:	01 c2                	add    %eax,%edx
  802d5c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d5f:	89 50 0c             	mov    %edx,0xc(%eax)
								next->sva = blockToInsert->sva;
  802d62:	8b 45 08             	mov    0x8(%ebp),%eax
  802d65:	8b 50 08             	mov    0x8(%eax),%edx
  802d68:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d6b:	89 50 08             	mov    %edx,0x8(%eax)

								blockToInsert->size = blockToInsert->sva = 0;
  802d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d71:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802d78:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7b:	8b 50 08             	mov    0x8(%eax),%edx
  802d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d81:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802d84:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d88:	75 17                	jne    802da1 <insert_sorted_with_merge_freeList+0x50c>
  802d8a:	83 ec 04             	sub    $0x4,%esp
  802d8d:	68 d0 3b 80 00       	push   $0x803bd0
  802d92:	68 5b 01 00 00       	push   $0x15b
  802d97:	68 f3 3b 80 00       	push   $0x803bf3
  802d9c:	e8 48 d5 ff ff       	call   8002e9 <_panic>
  802da1:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802da7:	8b 45 08             	mov    0x8(%ebp),%eax
  802daa:	89 10                	mov    %edx,(%eax)
  802dac:	8b 45 08             	mov    0x8(%ebp),%eax
  802daf:	8b 00                	mov    (%eax),%eax
  802db1:	85 c0                	test   %eax,%eax
  802db3:	74 0d                	je     802dc2 <insert_sorted_with_merge_freeList+0x52d>
  802db5:	a1 48 41 80 00       	mov    0x804148,%eax
  802dba:	8b 55 08             	mov    0x8(%ebp),%edx
  802dbd:	89 50 04             	mov    %edx,0x4(%eax)
  802dc0:	eb 08                	jmp    802dca <insert_sorted_with_merge_freeList+0x535>
  802dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc5:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802dca:	8b 45 08             	mov    0x8(%ebp),%eax
  802dcd:	a3 48 41 80 00       	mov    %eax,0x804148
  802dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ddc:	a1 54 41 80 00       	mov    0x804154,%eax
  802de1:	40                   	inc    %eax
  802de2:	a3 54 41 80 00       	mov    %eax,0x804154
								break;
  802de7:	e9 02 02 00 00       	jmp    802fee <insert_sorted_with_merge_freeList+0x759>
							}
							else if ((blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  802dec:	8b 45 08             	mov    0x8(%ebp),%eax
  802def:	8b 50 08             	mov    0x8(%eax),%edx
  802df2:	8b 45 08             	mov    0x8(%ebp),%eax
  802df5:	8b 40 0c             	mov    0xc(%eax),%eax
  802df8:	01 c2                	add    %eax,%edx
  802dfa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dfd:	8b 40 08             	mov    0x8(%eax),%eax
  802e00:	39 c2                	cmp    %eax,%edx
  802e02:	0f 85 ae 01 00 00    	jne    802fb6 <insert_sorted_with_merge_freeList+0x721>
  802e08:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0b:	8b 50 08             	mov    0x8(%eax),%edx
  802e0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e11:	8b 48 08             	mov    0x8(%eax),%ecx
  802e14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e17:	8b 40 0c             	mov    0xc(%eax),%eax
  802e1a:	01 c8                	add    %ecx,%eax
  802e1c:	39 c2                	cmp    %eax,%edx
  802e1e:	0f 85 92 01 00 00    	jne    802fb6 <insert_sorted_with_merge_freeList+0x721>
							{
								blk_itr->size = blk_itr->size + blockToInsert->size + next->size;
  802e24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e27:	8b 50 0c             	mov    0xc(%eax),%edx
  802e2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2d:	8b 40 0c             	mov    0xc(%eax),%eax
  802e30:	01 c2                	add    %eax,%edx
  802e32:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e35:	8b 40 0c             	mov    0xc(%eax),%eax
  802e38:	01 c2                	add    %eax,%edx
  802e3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3d:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size = blockToInsert->sva=0;
  802e40:	8b 45 08             	mov    0x8(%ebp),%eax
  802e43:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4d:	8b 50 08             	mov    0x8(%eax),%edx
  802e50:	8b 45 08             	mov    0x8(%ebp),%eax
  802e53:	89 50 0c             	mov    %edx,0xc(%eax)
								next->size = next->sva = 0;
  802e56:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e59:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802e60:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e63:	8b 50 08             	mov    0x8(%eax),%edx
  802e66:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e69:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_REMOVE(&FreeMemBlocksList, next);
  802e6c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e70:	75 17                	jne    802e89 <insert_sorted_with_merge_freeList+0x5f4>
  802e72:	83 ec 04             	sub    $0x4,%esp
  802e75:	68 9b 3c 80 00       	push   $0x803c9b
  802e7a:	68 63 01 00 00       	push   $0x163
  802e7f:	68 f3 3b 80 00       	push   $0x803bf3
  802e84:	e8 60 d4 ff ff       	call   8002e9 <_panic>
  802e89:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e8c:	8b 00                	mov    (%eax),%eax
  802e8e:	85 c0                	test   %eax,%eax
  802e90:	74 10                	je     802ea2 <insert_sorted_with_merge_freeList+0x60d>
  802e92:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e95:	8b 00                	mov    (%eax),%eax
  802e97:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e9a:	8b 52 04             	mov    0x4(%edx),%edx
  802e9d:	89 50 04             	mov    %edx,0x4(%eax)
  802ea0:	eb 0b                	jmp    802ead <insert_sorted_with_merge_freeList+0x618>
  802ea2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ea5:	8b 40 04             	mov    0x4(%eax),%eax
  802ea8:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ead:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eb0:	8b 40 04             	mov    0x4(%eax),%eax
  802eb3:	85 c0                	test   %eax,%eax
  802eb5:	74 0f                	je     802ec6 <insert_sorted_with_merge_freeList+0x631>
  802eb7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eba:	8b 40 04             	mov    0x4(%eax),%eax
  802ebd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ec0:	8b 12                	mov    (%edx),%edx
  802ec2:	89 10                	mov    %edx,(%eax)
  802ec4:	eb 0a                	jmp    802ed0 <insert_sorted_with_merge_freeList+0x63b>
  802ec6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ec9:	8b 00                	mov    (%eax),%eax
  802ecb:	a3 38 41 80 00       	mov    %eax,0x804138
  802ed0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ed3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ed9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802edc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ee3:	a1 44 41 80 00       	mov    0x804144,%eax
  802ee8:	48                   	dec    %eax
  802ee9:	a3 44 41 80 00       	mov    %eax,0x804144
								LIST_INSERT_HEAD(&AvailableMemBlocksList, next );
  802eee:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ef2:	75 17                	jne    802f0b <insert_sorted_with_merge_freeList+0x676>
  802ef4:	83 ec 04             	sub    $0x4,%esp
  802ef7:	68 d0 3b 80 00       	push   $0x803bd0
  802efc:	68 64 01 00 00       	push   $0x164
  802f01:	68 f3 3b 80 00       	push   $0x803bf3
  802f06:	e8 de d3 ff ff       	call   8002e9 <_panic>
  802f0b:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f11:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f14:	89 10                	mov    %edx,(%eax)
  802f16:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f19:	8b 00                	mov    (%eax),%eax
  802f1b:	85 c0                	test   %eax,%eax
  802f1d:	74 0d                	je     802f2c <insert_sorted_with_merge_freeList+0x697>
  802f1f:	a1 48 41 80 00       	mov    0x804148,%eax
  802f24:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f27:	89 50 04             	mov    %edx,0x4(%eax)
  802f2a:	eb 08                	jmp    802f34 <insert_sorted_with_merge_freeList+0x69f>
  802f2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f2f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f34:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f37:	a3 48 41 80 00       	mov    %eax,0x804148
  802f3c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f3f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f46:	a1 54 41 80 00       	mov    0x804154,%eax
  802f4b:	40                   	inc    %eax
  802f4c:	a3 54 41 80 00       	mov    %eax,0x804154
							    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802f51:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f55:	75 17                	jne    802f6e <insert_sorted_with_merge_freeList+0x6d9>
  802f57:	83 ec 04             	sub    $0x4,%esp
  802f5a:	68 d0 3b 80 00       	push   $0x803bd0
  802f5f:	68 65 01 00 00       	push   $0x165
  802f64:	68 f3 3b 80 00       	push   $0x803bf3
  802f69:	e8 7b d3 ff ff       	call   8002e9 <_panic>
  802f6e:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f74:	8b 45 08             	mov    0x8(%ebp),%eax
  802f77:	89 10                	mov    %edx,(%eax)
  802f79:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7c:	8b 00                	mov    (%eax),%eax
  802f7e:	85 c0                	test   %eax,%eax
  802f80:	74 0d                	je     802f8f <insert_sorted_with_merge_freeList+0x6fa>
  802f82:	a1 48 41 80 00       	mov    0x804148,%eax
  802f87:	8b 55 08             	mov    0x8(%ebp),%edx
  802f8a:	89 50 04             	mov    %edx,0x4(%eax)
  802f8d:	eb 08                	jmp    802f97 <insert_sorted_with_merge_freeList+0x702>
  802f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f92:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f97:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9a:	a3 48 41 80 00       	mov    %eax,0x804148
  802f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fa9:	a1 54 41 80 00       	mov    0x804154,%eax
  802fae:	40                   	inc    %eax
  802faf:	a3 54 41 80 00       	mov    %eax,0x804154
								break;
  802fb4:	eb 38                	jmp    802fee <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  802fb6:	a1 40 41 80 00       	mov    0x804140,%eax
  802fbb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fbe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fc2:	74 07                	je     802fcb <insert_sorted_with_merge_freeList+0x736>
  802fc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc7:	8b 00                	mov    (%eax),%eax
  802fc9:	eb 05                	jmp    802fd0 <insert_sorted_with_merge_freeList+0x73b>
  802fcb:	b8 00 00 00 00       	mov    $0x0,%eax
  802fd0:	a3 40 41 80 00       	mov    %eax,0x804140
  802fd5:	a1 40 41 80 00       	mov    0x804140,%eax
  802fda:	85 c0                	test   %eax,%eax
  802fdc:	0f 85 a7 fb ff ff    	jne    802b89 <insert_sorted_with_merge_freeList+0x2f4>
  802fe2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fe6:	0f 85 9d fb ff ff    	jne    802b89 <insert_sorted_with_merge_freeList+0x2f4>
						}
				}
        }

}
}
  802fec:	eb 00                	jmp    802fee <insert_sorted_with_merge_freeList+0x759>
  802fee:	90                   	nop
  802fef:	c9                   	leave  
  802ff0:	c3                   	ret    

00802ff1 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  802ff1:	55                   	push   %ebp
  802ff2:	89 e5                	mov    %esp,%ebp
  802ff4:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  802ff7:	8b 55 08             	mov    0x8(%ebp),%edx
  802ffa:	89 d0                	mov    %edx,%eax
  802ffc:	c1 e0 02             	shl    $0x2,%eax
  802fff:	01 d0                	add    %edx,%eax
  803001:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803008:	01 d0                	add    %edx,%eax
  80300a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803011:	01 d0                	add    %edx,%eax
  803013:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80301a:	01 d0                	add    %edx,%eax
  80301c:	c1 e0 04             	shl    $0x4,%eax
  80301f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803022:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803029:	8d 45 e8             	lea    -0x18(%ebp),%eax
  80302c:	83 ec 0c             	sub    $0xc,%esp
  80302f:	50                   	push   %eax
  803030:	e8 ee eb ff ff       	call   801c23 <sys_get_virtual_time>
  803035:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803038:	eb 41                	jmp    80307b <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  80303a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80303d:	83 ec 0c             	sub    $0xc,%esp
  803040:	50                   	push   %eax
  803041:	e8 dd eb ff ff       	call   801c23 <sys_get_virtual_time>
  803046:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803049:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80304c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80304f:	29 c2                	sub    %eax,%edx
  803051:	89 d0                	mov    %edx,%eax
  803053:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803056:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803059:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80305c:	89 d1                	mov    %edx,%ecx
  80305e:	29 c1                	sub    %eax,%ecx
  803060:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803063:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803066:	39 c2                	cmp    %eax,%edx
  803068:	0f 97 c0             	seta   %al
  80306b:	0f b6 c0             	movzbl %al,%eax
  80306e:	29 c1                	sub    %eax,%ecx
  803070:	89 c8                	mov    %ecx,%eax
  803072:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803075:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803078:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  80307b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803081:	72 b7                	jb     80303a <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803083:	90                   	nop
  803084:	c9                   	leave  
  803085:	c3                   	ret    

00803086 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803086:	55                   	push   %ebp
  803087:	89 e5                	mov    %esp,%ebp
  803089:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80308c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803093:	eb 03                	jmp    803098 <busy_wait+0x12>
  803095:	ff 45 fc             	incl   -0x4(%ebp)
  803098:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80309b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80309e:	72 f5                	jb     803095 <busy_wait+0xf>
	return i;
  8030a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
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
