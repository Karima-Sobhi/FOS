
obj/user/tst_sharing_3:     file format elf32-i386


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
  800031:	e8 8a 02 00 00       	call   8002c0 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the SPECIAL CASES during the creation of shared variables (create_shared_memory)
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 48             	sub    $0x48,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80003e:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800042:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800049:	eb 29                	jmp    800074 <_main+0x3c>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004b:	a1 20 50 80 00       	mov    0x805020,%eax
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
  800074:	a1 20 50 80 00       	mov    0x805020,%eax
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
  80008c:	68 80 33 80 00       	push   $0x803380
  800091:	6a 12                	push   $0x12
  800093:	68 9c 33 80 00       	push   $0x80339c
  800098:	e8 5f 03 00 00       	call   8003fc <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009d:	83 ec 0c             	sub    $0xc,%esp
  8000a0:	6a 00                	push   $0x0
  8000a2:	e8 35 15 00 00       	call   8015dc <malloc>
  8000a7:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	cprintf("************************************************\n");
  8000aa:	83 ec 0c             	sub    $0xc,%esp
  8000ad:	68 b4 33 80 00       	push   $0x8033b4
  8000b2:	e8 f9 05 00 00       	call   8006b0 <cprintf>
  8000b7:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000ba:	83 ec 0c             	sub    $0xc,%esp
  8000bd:	68 e8 33 80 00       	push   $0x8033e8
  8000c2:	e8 e9 05 00 00       	call   8006b0 <cprintf>
  8000c7:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000ca:	83 ec 0c             	sub    $0xc,%esp
  8000cd:	68 44 34 80 00       	push   $0x803444
  8000d2:	e8 d9 05 00 00       	call   8006b0 <cprintf>
  8000d7:	83 c4 10             	add    $0x10,%esp

	uint32 *x, *y, *z ;
	cprintf("STEP A: checking creation of shared object that is already exists... \n\n");
  8000da:	83 ec 0c             	sub    $0xc,%esp
  8000dd:	68 78 34 80 00       	push   $0x803478
  8000e2:	e8 c9 05 00 00       	call   8006b0 <cprintf>
  8000e7:	83 c4 10             	add    $0x10,%esp
	{
		int ret ;
		//int ret = sys_createSharedObject("x", PAGE_SIZE, 1, (void*)&x);
		x = smalloc("x", PAGE_SIZE, 1);
  8000ea:	83 ec 04             	sub    $0x4,%esp
  8000ed:	6a 01                	push   $0x1
  8000ef:	68 00 10 00 00       	push   $0x1000
  8000f4:	68 c0 34 80 00       	push   $0x8034c0
  8000f9:	e8 2d 16 00 00       	call   80172b <smalloc>
  8000fe:	83 c4 10             	add    $0x10,%esp
  800101:	89 45 e8             	mov    %eax,-0x18(%ebp)
		int freeFrames = sys_calculate_free_frames() ;
  800104:	e8 01 19 00 00       	call   801a0a <sys_calculate_free_frames>
  800109:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  80010c:	83 ec 04             	sub    $0x4,%esp
  80010f:	6a 01                	push   $0x1
  800111:	68 00 10 00 00       	push   $0x1000
  800116:	68 c0 34 80 00       	push   $0x8034c0
  80011b:	e8 0b 16 00 00       	call   80172b <smalloc>
  800120:	83 c4 10             	add    $0x10,%esp
  800123:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (x != NULL) panic("Trying to create an already exists object and corresponding error is not returned!!");
  800126:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80012a:	74 14                	je     800140 <_main+0x108>
  80012c:	83 ec 04             	sub    $0x4,%esp
  80012f:	68 c4 34 80 00       	push   $0x8034c4
  800134:	6a 24                	push   $0x24
  800136:	68 9c 33 80 00       	push   $0x80339c
  80013b:	e8 bc 02 00 00       	call   8003fc <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong allocation: make sure that you don't allocate any memory if the shared object exists");
  800140:	e8 c5 18 00 00       	call   801a0a <sys_calculate_free_frames>
  800145:	89 c2                	mov    %eax,%edx
  800147:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80014a:	39 c2                	cmp    %eax,%edx
  80014c:	74 14                	je     800162 <_main+0x12a>
  80014e:	83 ec 04             	sub    $0x4,%esp
  800151:	68 18 35 80 00       	push   $0x803518
  800156:	6a 25                	push   $0x25
  800158:	68 9c 33 80 00       	push   $0x80339c
  80015d:	e8 9a 02 00 00       	call   8003fc <_panic>
	}

	cprintf("STEP B: checking the creation of shared object that exceeds the SHARED area limit... \n\n");
  800162:	83 ec 0c             	sub    $0xc,%esp
  800165:	68 74 35 80 00       	push   $0x803574
  80016a:	e8 41 05 00 00       	call   8006b0 <cprintf>
  80016f:	83 c4 10             	add    $0x10,%esp
	{
		int freeFrames = sys_calculate_free_frames() ;
  800172:	e8 93 18 00 00       	call   801a0a <sys_calculate_free_frames>
  800177:	89 45 e0             	mov    %eax,-0x20(%ebp)
		uint32 size = USER_HEAP_MAX - USER_HEAP_START ;
  80017a:	c7 45 dc 00 00 00 20 	movl   $0x20000000,-0x24(%ebp)
		y = smalloc("y", size, 1);
  800181:	83 ec 04             	sub    $0x4,%esp
  800184:	6a 01                	push   $0x1
  800186:	ff 75 dc             	pushl  -0x24(%ebp)
  800189:	68 cc 35 80 00       	push   $0x8035cc
  80018e:	e8 98 15 00 00       	call   80172b <smalloc>
  800193:	83 c4 10             	add    $0x10,%esp
  800196:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (y != NULL) panic("Trying to create a shared object that exceed the SHARED area limit and the corresponding error is not returned!!");
  800199:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80019d:	74 14                	je     8001b3 <_main+0x17b>
  80019f:	83 ec 04             	sub    $0x4,%esp
  8001a2:	68 d0 35 80 00       	push   $0x8035d0
  8001a7:	6a 2d                	push   $0x2d
  8001a9:	68 9c 33 80 00       	push   $0x80339c
  8001ae:	e8 49 02 00 00       	call   8003fc <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong allocation: make sure that you don't allocate any memory if the shared object exceed the SHARED area limit");
  8001b3:	e8 52 18 00 00       	call   801a0a <sys_calculate_free_frames>
  8001b8:	89 c2                	mov    %eax,%edx
  8001ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001bd:	39 c2                	cmp    %eax,%edx
  8001bf:	74 14                	je     8001d5 <_main+0x19d>
  8001c1:	83 ec 04             	sub    $0x4,%esp
  8001c4:	68 44 36 80 00       	push   $0x803644
  8001c9:	6a 2e                	push   $0x2e
  8001cb:	68 9c 33 80 00       	push   $0x80339c
  8001d0:	e8 27 02 00 00       	call   8003fc <_panic>
	}

	cprintf("STEP C: checking the creation of a number of shared objects that exceeds the MAX ALLOWED NUMBER of OBJECTS... \n\n");
  8001d5:	83 ec 0c             	sub    $0xc,%esp
  8001d8:	68 b8 36 80 00       	push   $0x8036b8
  8001dd:	e8 ce 04 00 00       	call   8006b0 <cprintf>
  8001e2:	83 c4 10             	add    $0x10,%esp
	{
		uint32 maxShares = sys_getMaxShares();
  8001e5:	e8 79 1a 00 00       	call   801c63 <sys_getMaxShares>
  8001ea:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		int i ;
		for (i = 0 ; i < maxShares - 1; i++)
  8001ed:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8001f4:	eb 45                	jmp    80023b <_main+0x203>
		{
			char shareName[10] ;
			ltostr(i, shareName) ;
  8001f6:	83 ec 08             	sub    $0x8,%esp
  8001f9:	8d 45 c2             	lea    -0x3e(%ebp),%eax
  8001fc:	50                   	push   %eax
  8001fd:	ff 75 ec             	pushl  -0x14(%ebp)
  800200:	e8 d3 0f 00 00       	call   8011d8 <ltostr>
  800205:	83 c4 10             	add    $0x10,%esp
			z = smalloc(shareName, 1, 1);
  800208:	83 ec 04             	sub    $0x4,%esp
  80020b:	6a 01                	push   $0x1
  80020d:	6a 01                	push   $0x1
  80020f:	8d 45 c2             	lea    -0x3e(%ebp),%eax
  800212:	50                   	push   %eax
  800213:	e8 13 15 00 00       	call   80172b <smalloc>
  800218:	83 c4 10             	add    $0x10,%esp
  80021b:	89 45 d0             	mov    %eax,-0x30(%ebp)
			if (z == NULL) panic("WRONG... supposed no problem in creation here!!");
  80021e:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800222:	75 14                	jne    800238 <_main+0x200>
  800224:	83 ec 04             	sub    $0x4,%esp
  800227:	68 2c 37 80 00       	push   $0x80372c
  80022c:	6a 3a                	push   $0x3a
  80022e:	68 9c 33 80 00       	push   $0x80339c
  800233:	e8 c4 01 00 00       	call   8003fc <_panic>

	cprintf("STEP C: checking the creation of a number of shared objects that exceeds the MAX ALLOWED NUMBER of OBJECTS... \n\n");
	{
		uint32 maxShares = sys_getMaxShares();
		int i ;
		for (i = 0 ; i < maxShares - 1; i++)
  800238:	ff 45 ec             	incl   -0x14(%ebp)
  80023b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80023e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800241:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800244:	39 c2                	cmp    %eax,%edx
  800246:	77 ae                	ja     8001f6 <_main+0x1be>
			char shareName[10] ;
			ltostr(i, shareName) ;
			z = smalloc(shareName, 1, 1);
			if (z == NULL) panic("WRONG... supposed no problem in creation here!!");
		}
		z = smalloc("outOfBounds", 1, 1);
  800248:	83 ec 04             	sub    $0x4,%esp
  80024b:	6a 01                	push   $0x1
  80024d:	6a 01                	push   $0x1
  80024f:	68 5c 37 80 00       	push   $0x80375c
  800254:	e8 d2 14 00 00       	call   80172b <smalloc>
  800259:	83 c4 10             	add    $0x10,%esp
  80025c:	89 45 d0             	mov    %eax,-0x30(%ebp)
		uint32 maxShares_after = sys_getMaxShares();
  80025f:	e8 ff 19 00 00       	call   801c63 <sys_getMaxShares>
  800264:	89 45 cc             	mov    %eax,-0x34(%ebp)
		//if krealloc is NOT invoked to double the size of max shares
		if ((maxShares_after == maxShares) && (z != NULL)) panic("Trying to create a shared object that exceed the number of ALLOWED OBJECTS and the corresponding error is not returned!!");
  800267:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80026a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80026d:	75 1a                	jne    800289 <_main+0x251>
  80026f:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800273:	74 14                	je     800289 <_main+0x251>
  800275:	83 ec 04             	sub    $0x4,%esp
  800278:	68 68 37 80 00       	push   $0x803768
  80027d:	6a 3f                	push   $0x3f
  80027f:	68 9c 33 80 00       	push   $0x80339c
  800284:	e8 73 01 00 00       	call   8003fc <_panic>
		//else
		if ((maxShares_after == 2*maxShares) && (z == NULL)) panic("Trying to create a shared object that exceed the number of ALLOWED OBJECTS, krealloc should be invoked to double the size of shares array!!");
  800289:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80028c:	01 c0                	add    %eax,%eax
  80028e:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  800291:	75 1a                	jne    8002ad <_main+0x275>
  800293:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800297:	75 14                	jne    8002ad <_main+0x275>
  800299:	83 ec 04             	sub    $0x4,%esp
  80029c:	68 e4 37 80 00       	push   $0x8037e4
  8002a1:	6a 41                	push   $0x41
  8002a3:	68 9c 33 80 00       	push   $0x80339c
  8002a8:	e8 4f 01 00 00       	call   8003fc <_panic>
	}
	cprintf("Congratulations!! Test of Shared Variables [Create: Special Cases] completed successfully!!\n\n\n");
  8002ad:	83 ec 0c             	sub    $0xc,%esp
  8002b0:	68 70 38 80 00       	push   $0x803870
  8002b5:	e8 f6 03 00 00       	call   8006b0 <cprintf>
  8002ba:	83 c4 10             	add    $0x10,%esp

	return;
  8002bd:	90                   	nop
}
  8002be:	c9                   	leave  
  8002bf:	c3                   	ret    

008002c0 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8002c0:	55                   	push   %ebp
  8002c1:	89 e5                	mov    %esp,%ebp
  8002c3:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8002c6:	e8 1f 1a 00 00       	call   801cea <sys_getenvindex>
  8002cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8002ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8002d1:	89 d0                	mov    %edx,%eax
  8002d3:	c1 e0 03             	shl    $0x3,%eax
  8002d6:	01 d0                	add    %edx,%eax
  8002d8:	01 c0                	add    %eax,%eax
  8002da:	01 d0                	add    %edx,%eax
  8002dc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002e3:	01 d0                	add    %edx,%eax
  8002e5:	c1 e0 04             	shl    $0x4,%eax
  8002e8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002ed:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002f2:	a1 20 50 80 00       	mov    0x805020,%eax
  8002f7:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8002fd:	84 c0                	test   %al,%al
  8002ff:	74 0f                	je     800310 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800301:	a1 20 50 80 00       	mov    0x805020,%eax
  800306:	05 5c 05 00 00       	add    $0x55c,%eax
  80030b:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800310:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800314:	7e 0a                	jle    800320 <libmain+0x60>
		binaryname = argv[0];
  800316:	8b 45 0c             	mov    0xc(%ebp),%eax
  800319:	8b 00                	mov    (%eax),%eax
  80031b:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800320:	83 ec 08             	sub    $0x8,%esp
  800323:	ff 75 0c             	pushl  0xc(%ebp)
  800326:	ff 75 08             	pushl  0x8(%ebp)
  800329:	e8 0a fd ff ff       	call   800038 <_main>
  80032e:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800331:	e8 c1 17 00 00       	call   801af7 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800336:	83 ec 0c             	sub    $0xc,%esp
  800339:	68 e8 38 80 00       	push   $0x8038e8
  80033e:	e8 6d 03 00 00       	call   8006b0 <cprintf>
  800343:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800346:	a1 20 50 80 00       	mov    0x805020,%eax
  80034b:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800351:	a1 20 50 80 00       	mov    0x805020,%eax
  800356:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80035c:	83 ec 04             	sub    $0x4,%esp
  80035f:	52                   	push   %edx
  800360:	50                   	push   %eax
  800361:	68 10 39 80 00       	push   $0x803910
  800366:	e8 45 03 00 00       	call   8006b0 <cprintf>
  80036b:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80036e:	a1 20 50 80 00       	mov    0x805020,%eax
  800373:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800379:	a1 20 50 80 00       	mov    0x805020,%eax
  80037e:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800384:	a1 20 50 80 00       	mov    0x805020,%eax
  800389:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80038f:	51                   	push   %ecx
  800390:	52                   	push   %edx
  800391:	50                   	push   %eax
  800392:	68 38 39 80 00       	push   $0x803938
  800397:	e8 14 03 00 00       	call   8006b0 <cprintf>
  80039c:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80039f:	a1 20 50 80 00       	mov    0x805020,%eax
  8003a4:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8003aa:	83 ec 08             	sub    $0x8,%esp
  8003ad:	50                   	push   %eax
  8003ae:	68 90 39 80 00       	push   $0x803990
  8003b3:	e8 f8 02 00 00       	call   8006b0 <cprintf>
  8003b8:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8003bb:	83 ec 0c             	sub    $0xc,%esp
  8003be:	68 e8 38 80 00       	push   $0x8038e8
  8003c3:	e8 e8 02 00 00       	call   8006b0 <cprintf>
  8003c8:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8003cb:	e8 41 17 00 00       	call   801b11 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8003d0:	e8 19 00 00 00       	call   8003ee <exit>
}
  8003d5:	90                   	nop
  8003d6:	c9                   	leave  
  8003d7:	c3                   	ret    

008003d8 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8003d8:	55                   	push   %ebp
  8003d9:	89 e5                	mov    %esp,%ebp
  8003db:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8003de:	83 ec 0c             	sub    $0xc,%esp
  8003e1:	6a 00                	push   $0x0
  8003e3:	e8 ce 18 00 00       	call   801cb6 <sys_destroy_env>
  8003e8:	83 c4 10             	add    $0x10,%esp
}
  8003eb:	90                   	nop
  8003ec:	c9                   	leave  
  8003ed:	c3                   	ret    

008003ee <exit>:

void
exit(void)
{
  8003ee:	55                   	push   %ebp
  8003ef:	89 e5                	mov    %esp,%ebp
  8003f1:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8003f4:	e8 23 19 00 00       	call   801d1c <sys_exit_env>
}
  8003f9:	90                   	nop
  8003fa:	c9                   	leave  
  8003fb:	c3                   	ret    

008003fc <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8003fc:	55                   	push   %ebp
  8003fd:	89 e5                	mov    %esp,%ebp
  8003ff:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800402:	8d 45 10             	lea    0x10(%ebp),%eax
  800405:	83 c0 04             	add    $0x4,%eax
  800408:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80040b:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800410:	85 c0                	test   %eax,%eax
  800412:	74 16                	je     80042a <_panic+0x2e>
		cprintf("%s: ", argv0);
  800414:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800419:	83 ec 08             	sub    $0x8,%esp
  80041c:	50                   	push   %eax
  80041d:	68 a4 39 80 00       	push   $0x8039a4
  800422:	e8 89 02 00 00       	call   8006b0 <cprintf>
  800427:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80042a:	a1 00 50 80 00       	mov    0x805000,%eax
  80042f:	ff 75 0c             	pushl  0xc(%ebp)
  800432:	ff 75 08             	pushl  0x8(%ebp)
  800435:	50                   	push   %eax
  800436:	68 a9 39 80 00       	push   $0x8039a9
  80043b:	e8 70 02 00 00       	call   8006b0 <cprintf>
  800440:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800443:	8b 45 10             	mov    0x10(%ebp),%eax
  800446:	83 ec 08             	sub    $0x8,%esp
  800449:	ff 75 f4             	pushl  -0xc(%ebp)
  80044c:	50                   	push   %eax
  80044d:	e8 f3 01 00 00       	call   800645 <vcprintf>
  800452:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800455:	83 ec 08             	sub    $0x8,%esp
  800458:	6a 00                	push   $0x0
  80045a:	68 c5 39 80 00       	push   $0x8039c5
  80045f:	e8 e1 01 00 00       	call   800645 <vcprintf>
  800464:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800467:	e8 82 ff ff ff       	call   8003ee <exit>

	// should not return here
	while (1) ;
  80046c:	eb fe                	jmp    80046c <_panic+0x70>

0080046e <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80046e:	55                   	push   %ebp
  80046f:	89 e5                	mov    %esp,%ebp
  800471:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800474:	a1 20 50 80 00       	mov    0x805020,%eax
  800479:	8b 50 74             	mov    0x74(%eax),%edx
  80047c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80047f:	39 c2                	cmp    %eax,%edx
  800481:	74 14                	je     800497 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800483:	83 ec 04             	sub    $0x4,%esp
  800486:	68 c8 39 80 00       	push   $0x8039c8
  80048b:	6a 26                	push   $0x26
  80048d:	68 14 3a 80 00       	push   $0x803a14
  800492:	e8 65 ff ff ff       	call   8003fc <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800497:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80049e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004a5:	e9 c2 00 00 00       	jmp    80056c <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8004aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004ad:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b7:	01 d0                	add    %edx,%eax
  8004b9:	8b 00                	mov    (%eax),%eax
  8004bb:	85 c0                	test   %eax,%eax
  8004bd:	75 08                	jne    8004c7 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8004bf:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8004c2:	e9 a2 00 00 00       	jmp    800569 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8004c7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004ce:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8004d5:	eb 69                	jmp    800540 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8004d7:	a1 20 50 80 00       	mov    0x805020,%eax
  8004dc:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8004e2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004e5:	89 d0                	mov    %edx,%eax
  8004e7:	01 c0                	add    %eax,%eax
  8004e9:	01 d0                	add    %edx,%eax
  8004eb:	c1 e0 03             	shl    $0x3,%eax
  8004ee:	01 c8                	add    %ecx,%eax
  8004f0:	8a 40 04             	mov    0x4(%eax),%al
  8004f3:	84 c0                	test   %al,%al
  8004f5:	75 46                	jne    80053d <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004f7:	a1 20 50 80 00       	mov    0x805020,%eax
  8004fc:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800502:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800505:	89 d0                	mov    %edx,%eax
  800507:	01 c0                	add    %eax,%eax
  800509:	01 d0                	add    %edx,%eax
  80050b:	c1 e0 03             	shl    $0x3,%eax
  80050e:	01 c8                	add    %ecx,%eax
  800510:	8b 00                	mov    (%eax),%eax
  800512:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800515:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800518:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80051d:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80051f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800522:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800529:	8b 45 08             	mov    0x8(%ebp),%eax
  80052c:	01 c8                	add    %ecx,%eax
  80052e:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800530:	39 c2                	cmp    %eax,%edx
  800532:	75 09                	jne    80053d <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800534:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80053b:	eb 12                	jmp    80054f <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80053d:	ff 45 e8             	incl   -0x18(%ebp)
  800540:	a1 20 50 80 00       	mov    0x805020,%eax
  800545:	8b 50 74             	mov    0x74(%eax),%edx
  800548:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80054b:	39 c2                	cmp    %eax,%edx
  80054d:	77 88                	ja     8004d7 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80054f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800553:	75 14                	jne    800569 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800555:	83 ec 04             	sub    $0x4,%esp
  800558:	68 20 3a 80 00       	push   $0x803a20
  80055d:	6a 3a                	push   $0x3a
  80055f:	68 14 3a 80 00       	push   $0x803a14
  800564:	e8 93 fe ff ff       	call   8003fc <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800569:	ff 45 f0             	incl   -0x10(%ebp)
  80056c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80056f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800572:	0f 8c 32 ff ff ff    	jl     8004aa <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800578:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80057f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800586:	eb 26                	jmp    8005ae <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800588:	a1 20 50 80 00       	mov    0x805020,%eax
  80058d:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800593:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800596:	89 d0                	mov    %edx,%eax
  800598:	01 c0                	add    %eax,%eax
  80059a:	01 d0                	add    %edx,%eax
  80059c:	c1 e0 03             	shl    $0x3,%eax
  80059f:	01 c8                	add    %ecx,%eax
  8005a1:	8a 40 04             	mov    0x4(%eax),%al
  8005a4:	3c 01                	cmp    $0x1,%al
  8005a6:	75 03                	jne    8005ab <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8005a8:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005ab:	ff 45 e0             	incl   -0x20(%ebp)
  8005ae:	a1 20 50 80 00       	mov    0x805020,%eax
  8005b3:	8b 50 74             	mov    0x74(%eax),%edx
  8005b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005b9:	39 c2                	cmp    %eax,%edx
  8005bb:	77 cb                	ja     800588 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8005bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005c0:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8005c3:	74 14                	je     8005d9 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8005c5:	83 ec 04             	sub    $0x4,%esp
  8005c8:	68 74 3a 80 00       	push   $0x803a74
  8005cd:	6a 44                	push   $0x44
  8005cf:	68 14 3a 80 00       	push   $0x803a14
  8005d4:	e8 23 fe ff ff       	call   8003fc <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8005d9:	90                   	nop
  8005da:	c9                   	leave  
  8005db:	c3                   	ret    

008005dc <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8005dc:	55                   	push   %ebp
  8005dd:	89 e5                	mov    %esp,%ebp
  8005df:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8005e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005e5:	8b 00                	mov    (%eax),%eax
  8005e7:	8d 48 01             	lea    0x1(%eax),%ecx
  8005ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005ed:	89 0a                	mov    %ecx,(%edx)
  8005ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8005f2:	88 d1                	mov    %dl,%cl
  8005f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005f7:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8005fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005fe:	8b 00                	mov    (%eax),%eax
  800600:	3d ff 00 00 00       	cmp    $0xff,%eax
  800605:	75 2c                	jne    800633 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800607:	a0 24 50 80 00       	mov    0x805024,%al
  80060c:	0f b6 c0             	movzbl %al,%eax
  80060f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800612:	8b 12                	mov    (%edx),%edx
  800614:	89 d1                	mov    %edx,%ecx
  800616:	8b 55 0c             	mov    0xc(%ebp),%edx
  800619:	83 c2 08             	add    $0x8,%edx
  80061c:	83 ec 04             	sub    $0x4,%esp
  80061f:	50                   	push   %eax
  800620:	51                   	push   %ecx
  800621:	52                   	push   %edx
  800622:	e8 22 13 00 00       	call   801949 <sys_cputs>
  800627:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80062a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80062d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800633:	8b 45 0c             	mov    0xc(%ebp),%eax
  800636:	8b 40 04             	mov    0x4(%eax),%eax
  800639:	8d 50 01             	lea    0x1(%eax),%edx
  80063c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80063f:	89 50 04             	mov    %edx,0x4(%eax)
}
  800642:	90                   	nop
  800643:	c9                   	leave  
  800644:	c3                   	ret    

00800645 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800645:	55                   	push   %ebp
  800646:	89 e5                	mov    %esp,%ebp
  800648:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80064e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800655:	00 00 00 
	b.cnt = 0;
  800658:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80065f:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800662:	ff 75 0c             	pushl  0xc(%ebp)
  800665:	ff 75 08             	pushl  0x8(%ebp)
  800668:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80066e:	50                   	push   %eax
  80066f:	68 dc 05 80 00       	push   $0x8005dc
  800674:	e8 11 02 00 00       	call   80088a <vprintfmt>
  800679:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80067c:	a0 24 50 80 00       	mov    0x805024,%al
  800681:	0f b6 c0             	movzbl %al,%eax
  800684:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80068a:	83 ec 04             	sub    $0x4,%esp
  80068d:	50                   	push   %eax
  80068e:	52                   	push   %edx
  80068f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800695:	83 c0 08             	add    $0x8,%eax
  800698:	50                   	push   %eax
  800699:	e8 ab 12 00 00       	call   801949 <sys_cputs>
  80069e:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8006a1:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  8006a8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8006ae:	c9                   	leave  
  8006af:	c3                   	ret    

008006b0 <cprintf>:

int cprintf(const char *fmt, ...) {
  8006b0:	55                   	push   %ebp
  8006b1:	89 e5                	mov    %esp,%ebp
  8006b3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8006b6:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  8006bd:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c6:	83 ec 08             	sub    $0x8,%esp
  8006c9:	ff 75 f4             	pushl  -0xc(%ebp)
  8006cc:	50                   	push   %eax
  8006cd:	e8 73 ff ff ff       	call   800645 <vcprintf>
  8006d2:	83 c4 10             	add    $0x10,%esp
  8006d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8006d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006db:	c9                   	leave  
  8006dc:	c3                   	ret    

008006dd <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8006dd:	55                   	push   %ebp
  8006de:	89 e5                	mov    %esp,%ebp
  8006e0:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8006e3:	e8 0f 14 00 00       	call   801af7 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8006e8:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f1:	83 ec 08             	sub    $0x8,%esp
  8006f4:	ff 75 f4             	pushl  -0xc(%ebp)
  8006f7:	50                   	push   %eax
  8006f8:	e8 48 ff ff ff       	call   800645 <vcprintf>
  8006fd:	83 c4 10             	add    $0x10,%esp
  800700:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800703:	e8 09 14 00 00       	call   801b11 <sys_enable_interrupt>
	return cnt;
  800708:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80070b:	c9                   	leave  
  80070c:	c3                   	ret    

0080070d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80070d:	55                   	push   %ebp
  80070e:	89 e5                	mov    %esp,%ebp
  800710:	53                   	push   %ebx
  800711:	83 ec 14             	sub    $0x14,%esp
  800714:	8b 45 10             	mov    0x10(%ebp),%eax
  800717:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80071a:	8b 45 14             	mov    0x14(%ebp),%eax
  80071d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800720:	8b 45 18             	mov    0x18(%ebp),%eax
  800723:	ba 00 00 00 00       	mov    $0x0,%edx
  800728:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80072b:	77 55                	ja     800782 <printnum+0x75>
  80072d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800730:	72 05                	jb     800737 <printnum+0x2a>
  800732:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800735:	77 4b                	ja     800782 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800737:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80073a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80073d:	8b 45 18             	mov    0x18(%ebp),%eax
  800740:	ba 00 00 00 00       	mov    $0x0,%edx
  800745:	52                   	push   %edx
  800746:	50                   	push   %eax
  800747:	ff 75 f4             	pushl  -0xc(%ebp)
  80074a:	ff 75 f0             	pushl  -0x10(%ebp)
  80074d:	e8 b2 29 00 00       	call   803104 <__udivdi3>
  800752:	83 c4 10             	add    $0x10,%esp
  800755:	83 ec 04             	sub    $0x4,%esp
  800758:	ff 75 20             	pushl  0x20(%ebp)
  80075b:	53                   	push   %ebx
  80075c:	ff 75 18             	pushl  0x18(%ebp)
  80075f:	52                   	push   %edx
  800760:	50                   	push   %eax
  800761:	ff 75 0c             	pushl  0xc(%ebp)
  800764:	ff 75 08             	pushl  0x8(%ebp)
  800767:	e8 a1 ff ff ff       	call   80070d <printnum>
  80076c:	83 c4 20             	add    $0x20,%esp
  80076f:	eb 1a                	jmp    80078b <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800771:	83 ec 08             	sub    $0x8,%esp
  800774:	ff 75 0c             	pushl  0xc(%ebp)
  800777:	ff 75 20             	pushl  0x20(%ebp)
  80077a:	8b 45 08             	mov    0x8(%ebp),%eax
  80077d:	ff d0                	call   *%eax
  80077f:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800782:	ff 4d 1c             	decl   0x1c(%ebp)
  800785:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800789:	7f e6                	jg     800771 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80078b:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80078e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800793:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800796:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800799:	53                   	push   %ebx
  80079a:	51                   	push   %ecx
  80079b:	52                   	push   %edx
  80079c:	50                   	push   %eax
  80079d:	e8 72 2a 00 00       	call   803214 <__umoddi3>
  8007a2:	83 c4 10             	add    $0x10,%esp
  8007a5:	05 d4 3c 80 00       	add    $0x803cd4,%eax
  8007aa:	8a 00                	mov    (%eax),%al
  8007ac:	0f be c0             	movsbl %al,%eax
  8007af:	83 ec 08             	sub    $0x8,%esp
  8007b2:	ff 75 0c             	pushl  0xc(%ebp)
  8007b5:	50                   	push   %eax
  8007b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b9:	ff d0                	call   *%eax
  8007bb:	83 c4 10             	add    $0x10,%esp
}
  8007be:	90                   	nop
  8007bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007c2:	c9                   	leave  
  8007c3:	c3                   	ret    

008007c4 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007c4:	55                   	push   %ebp
  8007c5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007c7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007cb:	7e 1c                	jle    8007e9 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8007cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d0:	8b 00                	mov    (%eax),%eax
  8007d2:	8d 50 08             	lea    0x8(%eax),%edx
  8007d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d8:	89 10                	mov    %edx,(%eax)
  8007da:	8b 45 08             	mov    0x8(%ebp),%eax
  8007dd:	8b 00                	mov    (%eax),%eax
  8007df:	83 e8 08             	sub    $0x8,%eax
  8007e2:	8b 50 04             	mov    0x4(%eax),%edx
  8007e5:	8b 00                	mov    (%eax),%eax
  8007e7:	eb 40                	jmp    800829 <getuint+0x65>
	else if (lflag)
  8007e9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007ed:	74 1e                	je     80080d <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8007ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f2:	8b 00                	mov    (%eax),%eax
  8007f4:	8d 50 04             	lea    0x4(%eax),%edx
  8007f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fa:	89 10                	mov    %edx,(%eax)
  8007fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ff:	8b 00                	mov    (%eax),%eax
  800801:	83 e8 04             	sub    $0x4,%eax
  800804:	8b 00                	mov    (%eax),%eax
  800806:	ba 00 00 00 00       	mov    $0x0,%edx
  80080b:	eb 1c                	jmp    800829 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80080d:	8b 45 08             	mov    0x8(%ebp),%eax
  800810:	8b 00                	mov    (%eax),%eax
  800812:	8d 50 04             	lea    0x4(%eax),%edx
  800815:	8b 45 08             	mov    0x8(%ebp),%eax
  800818:	89 10                	mov    %edx,(%eax)
  80081a:	8b 45 08             	mov    0x8(%ebp),%eax
  80081d:	8b 00                	mov    (%eax),%eax
  80081f:	83 e8 04             	sub    $0x4,%eax
  800822:	8b 00                	mov    (%eax),%eax
  800824:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800829:	5d                   	pop    %ebp
  80082a:	c3                   	ret    

0080082b <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80082b:	55                   	push   %ebp
  80082c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80082e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800832:	7e 1c                	jle    800850 <getint+0x25>
		return va_arg(*ap, long long);
  800834:	8b 45 08             	mov    0x8(%ebp),%eax
  800837:	8b 00                	mov    (%eax),%eax
  800839:	8d 50 08             	lea    0x8(%eax),%edx
  80083c:	8b 45 08             	mov    0x8(%ebp),%eax
  80083f:	89 10                	mov    %edx,(%eax)
  800841:	8b 45 08             	mov    0x8(%ebp),%eax
  800844:	8b 00                	mov    (%eax),%eax
  800846:	83 e8 08             	sub    $0x8,%eax
  800849:	8b 50 04             	mov    0x4(%eax),%edx
  80084c:	8b 00                	mov    (%eax),%eax
  80084e:	eb 38                	jmp    800888 <getint+0x5d>
	else if (lflag)
  800850:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800854:	74 1a                	je     800870 <getint+0x45>
		return va_arg(*ap, long);
  800856:	8b 45 08             	mov    0x8(%ebp),%eax
  800859:	8b 00                	mov    (%eax),%eax
  80085b:	8d 50 04             	lea    0x4(%eax),%edx
  80085e:	8b 45 08             	mov    0x8(%ebp),%eax
  800861:	89 10                	mov    %edx,(%eax)
  800863:	8b 45 08             	mov    0x8(%ebp),%eax
  800866:	8b 00                	mov    (%eax),%eax
  800868:	83 e8 04             	sub    $0x4,%eax
  80086b:	8b 00                	mov    (%eax),%eax
  80086d:	99                   	cltd   
  80086e:	eb 18                	jmp    800888 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800870:	8b 45 08             	mov    0x8(%ebp),%eax
  800873:	8b 00                	mov    (%eax),%eax
  800875:	8d 50 04             	lea    0x4(%eax),%edx
  800878:	8b 45 08             	mov    0x8(%ebp),%eax
  80087b:	89 10                	mov    %edx,(%eax)
  80087d:	8b 45 08             	mov    0x8(%ebp),%eax
  800880:	8b 00                	mov    (%eax),%eax
  800882:	83 e8 04             	sub    $0x4,%eax
  800885:	8b 00                	mov    (%eax),%eax
  800887:	99                   	cltd   
}
  800888:	5d                   	pop    %ebp
  800889:	c3                   	ret    

0080088a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80088a:	55                   	push   %ebp
  80088b:	89 e5                	mov    %esp,%ebp
  80088d:	56                   	push   %esi
  80088e:	53                   	push   %ebx
  80088f:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800892:	eb 17                	jmp    8008ab <vprintfmt+0x21>
			if (ch == '\0')
  800894:	85 db                	test   %ebx,%ebx
  800896:	0f 84 af 03 00 00    	je     800c4b <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80089c:	83 ec 08             	sub    $0x8,%esp
  80089f:	ff 75 0c             	pushl  0xc(%ebp)
  8008a2:	53                   	push   %ebx
  8008a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a6:	ff d0                	call   *%eax
  8008a8:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8008ae:	8d 50 01             	lea    0x1(%eax),%edx
  8008b1:	89 55 10             	mov    %edx,0x10(%ebp)
  8008b4:	8a 00                	mov    (%eax),%al
  8008b6:	0f b6 d8             	movzbl %al,%ebx
  8008b9:	83 fb 25             	cmp    $0x25,%ebx
  8008bc:	75 d6                	jne    800894 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008be:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8008c2:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8008c9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8008d0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8008d7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008de:	8b 45 10             	mov    0x10(%ebp),%eax
  8008e1:	8d 50 01             	lea    0x1(%eax),%edx
  8008e4:	89 55 10             	mov    %edx,0x10(%ebp)
  8008e7:	8a 00                	mov    (%eax),%al
  8008e9:	0f b6 d8             	movzbl %al,%ebx
  8008ec:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8008ef:	83 f8 55             	cmp    $0x55,%eax
  8008f2:	0f 87 2b 03 00 00    	ja     800c23 <vprintfmt+0x399>
  8008f8:	8b 04 85 f8 3c 80 00 	mov    0x803cf8(,%eax,4),%eax
  8008ff:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800901:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800905:	eb d7                	jmp    8008de <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800907:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80090b:	eb d1                	jmp    8008de <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80090d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800914:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800917:	89 d0                	mov    %edx,%eax
  800919:	c1 e0 02             	shl    $0x2,%eax
  80091c:	01 d0                	add    %edx,%eax
  80091e:	01 c0                	add    %eax,%eax
  800920:	01 d8                	add    %ebx,%eax
  800922:	83 e8 30             	sub    $0x30,%eax
  800925:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800928:	8b 45 10             	mov    0x10(%ebp),%eax
  80092b:	8a 00                	mov    (%eax),%al
  80092d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800930:	83 fb 2f             	cmp    $0x2f,%ebx
  800933:	7e 3e                	jle    800973 <vprintfmt+0xe9>
  800935:	83 fb 39             	cmp    $0x39,%ebx
  800938:	7f 39                	jg     800973 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80093a:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80093d:	eb d5                	jmp    800914 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80093f:	8b 45 14             	mov    0x14(%ebp),%eax
  800942:	83 c0 04             	add    $0x4,%eax
  800945:	89 45 14             	mov    %eax,0x14(%ebp)
  800948:	8b 45 14             	mov    0x14(%ebp),%eax
  80094b:	83 e8 04             	sub    $0x4,%eax
  80094e:	8b 00                	mov    (%eax),%eax
  800950:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800953:	eb 1f                	jmp    800974 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800955:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800959:	79 83                	jns    8008de <vprintfmt+0x54>
				width = 0;
  80095b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800962:	e9 77 ff ff ff       	jmp    8008de <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800967:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80096e:	e9 6b ff ff ff       	jmp    8008de <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800973:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800974:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800978:	0f 89 60 ff ff ff    	jns    8008de <vprintfmt+0x54>
				width = precision, precision = -1;
  80097e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800981:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800984:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80098b:	e9 4e ff ff ff       	jmp    8008de <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800990:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800993:	e9 46 ff ff ff       	jmp    8008de <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800998:	8b 45 14             	mov    0x14(%ebp),%eax
  80099b:	83 c0 04             	add    $0x4,%eax
  80099e:	89 45 14             	mov    %eax,0x14(%ebp)
  8009a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a4:	83 e8 04             	sub    $0x4,%eax
  8009a7:	8b 00                	mov    (%eax),%eax
  8009a9:	83 ec 08             	sub    $0x8,%esp
  8009ac:	ff 75 0c             	pushl  0xc(%ebp)
  8009af:	50                   	push   %eax
  8009b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b3:	ff d0                	call   *%eax
  8009b5:	83 c4 10             	add    $0x10,%esp
			break;
  8009b8:	e9 89 02 00 00       	jmp    800c46 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8009bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c0:	83 c0 04             	add    $0x4,%eax
  8009c3:	89 45 14             	mov    %eax,0x14(%ebp)
  8009c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c9:	83 e8 04             	sub    $0x4,%eax
  8009cc:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8009ce:	85 db                	test   %ebx,%ebx
  8009d0:	79 02                	jns    8009d4 <vprintfmt+0x14a>
				err = -err;
  8009d2:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8009d4:	83 fb 64             	cmp    $0x64,%ebx
  8009d7:	7f 0b                	jg     8009e4 <vprintfmt+0x15a>
  8009d9:	8b 34 9d 40 3b 80 00 	mov    0x803b40(,%ebx,4),%esi
  8009e0:	85 f6                	test   %esi,%esi
  8009e2:	75 19                	jne    8009fd <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009e4:	53                   	push   %ebx
  8009e5:	68 e5 3c 80 00       	push   $0x803ce5
  8009ea:	ff 75 0c             	pushl  0xc(%ebp)
  8009ed:	ff 75 08             	pushl  0x8(%ebp)
  8009f0:	e8 5e 02 00 00       	call   800c53 <printfmt>
  8009f5:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009f8:	e9 49 02 00 00       	jmp    800c46 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009fd:	56                   	push   %esi
  8009fe:	68 ee 3c 80 00       	push   $0x803cee
  800a03:	ff 75 0c             	pushl  0xc(%ebp)
  800a06:	ff 75 08             	pushl  0x8(%ebp)
  800a09:	e8 45 02 00 00       	call   800c53 <printfmt>
  800a0e:	83 c4 10             	add    $0x10,%esp
			break;
  800a11:	e9 30 02 00 00       	jmp    800c46 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a16:	8b 45 14             	mov    0x14(%ebp),%eax
  800a19:	83 c0 04             	add    $0x4,%eax
  800a1c:	89 45 14             	mov    %eax,0x14(%ebp)
  800a1f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a22:	83 e8 04             	sub    $0x4,%eax
  800a25:	8b 30                	mov    (%eax),%esi
  800a27:	85 f6                	test   %esi,%esi
  800a29:	75 05                	jne    800a30 <vprintfmt+0x1a6>
				p = "(null)";
  800a2b:	be f1 3c 80 00       	mov    $0x803cf1,%esi
			if (width > 0 && padc != '-')
  800a30:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a34:	7e 6d                	jle    800aa3 <vprintfmt+0x219>
  800a36:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a3a:	74 67                	je     800aa3 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a3c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a3f:	83 ec 08             	sub    $0x8,%esp
  800a42:	50                   	push   %eax
  800a43:	56                   	push   %esi
  800a44:	e8 0c 03 00 00       	call   800d55 <strnlen>
  800a49:	83 c4 10             	add    $0x10,%esp
  800a4c:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a4f:	eb 16                	jmp    800a67 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a51:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a55:	83 ec 08             	sub    $0x8,%esp
  800a58:	ff 75 0c             	pushl  0xc(%ebp)
  800a5b:	50                   	push   %eax
  800a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5f:	ff d0                	call   *%eax
  800a61:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a64:	ff 4d e4             	decl   -0x1c(%ebp)
  800a67:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a6b:	7f e4                	jg     800a51 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a6d:	eb 34                	jmp    800aa3 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a6f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a73:	74 1c                	je     800a91 <vprintfmt+0x207>
  800a75:	83 fb 1f             	cmp    $0x1f,%ebx
  800a78:	7e 05                	jle    800a7f <vprintfmt+0x1f5>
  800a7a:	83 fb 7e             	cmp    $0x7e,%ebx
  800a7d:	7e 12                	jle    800a91 <vprintfmt+0x207>
					putch('?', putdat);
  800a7f:	83 ec 08             	sub    $0x8,%esp
  800a82:	ff 75 0c             	pushl  0xc(%ebp)
  800a85:	6a 3f                	push   $0x3f
  800a87:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8a:	ff d0                	call   *%eax
  800a8c:	83 c4 10             	add    $0x10,%esp
  800a8f:	eb 0f                	jmp    800aa0 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a91:	83 ec 08             	sub    $0x8,%esp
  800a94:	ff 75 0c             	pushl  0xc(%ebp)
  800a97:	53                   	push   %ebx
  800a98:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9b:	ff d0                	call   *%eax
  800a9d:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800aa0:	ff 4d e4             	decl   -0x1c(%ebp)
  800aa3:	89 f0                	mov    %esi,%eax
  800aa5:	8d 70 01             	lea    0x1(%eax),%esi
  800aa8:	8a 00                	mov    (%eax),%al
  800aaa:	0f be d8             	movsbl %al,%ebx
  800aad:	85 db                	test   %ebx,%ebx
  800aaf:	74 24                	je     800ad5 <vprintfmt+0x24b>
  800ab1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ab5:	78 b8                	js     800a6f <vprintfmt+0x1e5>
  800ab7:	ff 4d e0             	decl   -0x20(%ebp)
  800aba:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800abe:	79 af                	jns    800a6f <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ac0:	eb 13                	jmp    800ad5 <vprintfmt+0x24b>
				putch(' ', putdat);
  800ac2:	83 ec 08             	sub    $0x8,%esp
  800ac5:	ff 75 0c             	pushl  0xc(%ebp)
  800ac8:	6a 20                	push   $0x20
  800aca:	8b 45 08             	mov    0x8(%ebp),%eax
  800acd:	ff d0                	call   *%eax
  800acf:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ad2:	ff 4d e4             	decl   -0x1c(%ebp)
  800ad5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ad9:	7f e7                	jg     800ac2 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800adb:	e9 66 01 00 00       	jmp    800c46 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ae0:	83 ec 08             	sub    $0x8,%esp
  800ae3:	ff 75 e8             	pushl  -0x18(%ebp)
  800ae6:	8d 45 14             	lea    0x14(%ebp),%eax
  800ae9:	50                   	push   %eax
  800aea:	e8 3c fd ff ff       	call   80082b <getint>
  800aef:	83 c4 10             	add    $0x10,%esp
  800af2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800af5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800af8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800afb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800afe:	85 d2                	test   %edx,%edx
  800b00:	79 23                	jns    800b25 <vprintfmt+0x29b>
				putch('-', putdat);
  800b02:	83 ec 08             	sub    $0x8,%esp
  800b05:	ff 75 0c             	pushl  0xc(%ebp)
  800b08:	6a 2d                	push   $0x2d
  800b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0d:	ff d0                	call   *%eax
  800b0f:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b15:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b18:	f7 d8                	neg    %eax
  800b1a:	83 d2 00             	adc    $0x0,%edx
  800b1d:	f7 da                	neg    %edx
  800b1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b22:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b25:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b2c:	e9 bc 00 00 00       	jmp    800bed <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b31:	83 ec 08             	sub    $0x8,%esp
  800b34:	ff 75 e8             	pushl  -0x18(%ebp)
  800b37:	8d 45 14             	lea    0x14(%ebp),%eax
  800b3a:	50                   	push   %eax
  800b3b:	e8 84 fc ff ff       	call   8007c4 <getuint>
  800b40:	83 c4 10             	add    $0x10,%esp
  800b43:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b46:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b49:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b50:	e9 98 00 00 00       	jmp    800bed <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b55:	83 ec 08             	sub    $0x8,%esp
  800b58:	ff 75 0c             	pushl  0xc(%ebp)
  800b5b:	6a 58                	push   $0x58
  800b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b60:	ff d0                	call   *%eax
  800b62:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b65:	83 ec 08             	sub    $0x8,%esp
  800b68:	ff 75 0c             	pushl  0xc(%ebp)
  800b6b:	6a 58                	push   $0x58
  800b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b70:	ff d0                	call   *%eax
  800b72:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b75:	83 ec 08             	sub    $0x8,%esp
  800b78:	ff 75 0c             	pushl  0xc(%ebp)
  800b7b:	6a 58                	push   $0x58
  800b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b80:	ff d0                	call   *%eax
  800b82:	83 c4 10             	add    $0x10,%esp
			break;
  800b85:	e9 bc 00 00 00       	jmp    800c46 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800b8a:	83 ec 08             	sub    $0x8,%esp
  800b8d:	ff 75 0c             	pushl  0xc(%ebp)
  800b90:	6a 30                	push   $0x30
  800b92:	8b 45 08             	mov    0x8(%ebp),%eax
  800b95:	ff d0                	call   *%eax
  800b97:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b9a:	83 ec 08             	sub    $0x8,%esp
  800b9d:	ff 75 0c             	pushl  0xc(%ebp)
  800ba0:	6a 78                	push   $0x78
  800ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba5:	ff d0                	call   *%eax
  800ba7:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800baa:	8b 45 14             	mov    0x14(%ebp),%eax
  800bad:	83 c0 04             	add    $0x4,%eax
  800bb0:	89 45 14             	mov    %eax,0x14(%ebp)
  800bb3:	8b 45 14             	mov    0x14(%ebp),%eax
  800bb6:	83 e8 04             	sub    $0x4,%eax
  800bb9:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bbb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bbe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800bc5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800bcc:	eb 1f                	jmp    800bed <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800bce:	83 ec 08             	sub    $0x8,%esp
  800bd1:	ff 75 e8             	pushl  -0x18(%ebp)
  800bd4:	8d 45 14             	lea    0x14(%ebp),%eax
  800bd7:	50                   	push   %eax
  800bd8:	e8 e7 fb ff ff       	call   8007c4 <getuint>
  800bdd:	83 c4 10             	add    $0x10,%esp
  800be0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800be3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800be6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800bed:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800bf1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bf4:	83 ec 04             	sub    $0x4,%esp
  800bf7:	52                   	push   %edx
  800bf8:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bfb:	50                   	push   %eax
  800bfc:	ff 75 f4             	pushl  -0xc(%ebp)
  800bff:	ff 75 f0             	pushl  -0x10(%ebp)
  800c02:	ff 75 0c             	pushl  0xc(%ebp)
  800c05:	ff 75 08             	pushl  0x8(%ebp)
  800c08:	e8 00 fb ff ff       	call   80070d <printnum>
  800c0d:	83 c4 20             	add    $0x20,%esp
			break;
  800c10:	eb 34                	jmp    800c46 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c12:	83 ec 08             	sub    $0x8,%esp
  800c15:	ff 75 0c             	pushl  0xc(%ebp)
  800c18:	53                   	push   %ebx
  800c19:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1c:	ff d0                	call   *%eax
  800c1e:	83 c4 10             	add    $0x10,%esp
			break;
  800c21:	eb 23                	jmp    800c46 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c23:	83 ec 08             	sub    $0x8,%esp
  800c26:	ff 75 0c             	pushl  0xc(%ebp)
  800c29:	6a 25                	push   $0x25
  800c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2e:	ff d0                	call   *%eax
  800c30:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c33:	ff 4d 10             	decl   0x10(%ebp)
  800c36:	eb 03                	jmp    800c3b <vprintfmt+0x3b1>
  800c38:	ff 4d 10             	decl   0x10(%ebp)
  800c3b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c3e:	48                   	dec    %eax
  800c3f:	8a 00                	mov    (%eax),%al
  800c41:	3c 25                	cmp    $0x25,%al
  800c43:	75 f3                	jne    800c38 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800c45:	90                   	nop
		}
	}
  800c46:	e9 47 fc ff ff       	jmp    800892 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c4b:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c4c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c4f:	5b                   	pop    %ebx
  800c50:	5e                   	pop    %esi
  800c51:	5d                   	pop    %ebp
  800c52:	c3                   	ret    

00800c53 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c53:	55                   	push   %ebp
  800c54:	89 e5                	mov    %esp,%ebp
  800c56:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c59:	8d 45 10             	lea    0x10(%ebp),%eax
  800c5c:	83 c0 04             	add    $0x4,%eax
  800c5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c62:	8b 45 10             	mov    0x10(%ebp),%eax
  800c65:	ff 75 f4             	pushl  -0xc(%ebp)
  800c68:	50                   	push   %eax
  800c69:	ff 75 0c             	pushl  0xc(%ebp)
  800c6c:	ff 75 08             	pushl  0x8(%ebp)
  800c6f:	e8 16 fc ff ff       	call   80088a <vprintfmt>
  800c74:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c77:	90                   	nop
  800c78:	c9                   	leave  
  800c79:	c3                   	ret    

00800c7a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c7a:	55                   	push   %ebp
  800c7b:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c80:	8b 40 08             	mov    0x8(%eax),%eax
  800c83:	8d 50 01             	lea    0x1(%eax),%edx
  800c86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c89:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8f:	8b 10                	mov    (%eax),%edx
  800c91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c94:	8b 40 04             	mov    0x4(%eax),%eax
  800c97:	39 c2                	cmp    %eax,%edx
  800c99:	73 12                	jae    800cad <sprintputch+0x33>
		*b->buf++ = ch;
  800c9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9e:	8b 00                	mov    (%eax),%eax
  800ca0:	8d 48 01             	lea    0x1(%eax),%ecx
  800ca3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ca6:	89 0a                	mov    %ecx,(%edx)
  800ca8:	8b 55 08             	mov    0x8(%ebp),%edx
  800cab:	88 10                	mov    %dl,(%eax)
}
  800cad:	90                   	nop
  800cae:	5d                   	pop    %ebp
  800caf:	c3                   	ret    

00800cb0 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800cb0:	55                   	push   %ebp
  800cb1:	89 e5                	mov    %esp,%ebp
  800cb3:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800cbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cbf:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc5:	01 d0                	add    %edx,%eax
  800cc7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800cd1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800cd5:	74 06                	je     800cdd <vsnprintf+0x2d>
  800cd7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cdb:	7f 07                	jg     800ce4 <vsnprintf+0x34>
		return -E_INVAL;
  800cdd:	b8 03 00 00 00       	mov    $0x3,%eax
  800ce2:	eb 20                	jmp    800d04 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ce4:	ff 75 14             	pushl  0x14(%ebp)
  800ce7:	ff 75 10             	pushl  0x10(%ebp)
  800cea:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ced:	50                   	push   %eax
  800cee:	68 7a 0c 80 00       	push   $0x800c7a
  800cf3:	e8 92 fb ff ff       	call   80088a <vprintfmt>
  800cf8:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800cfb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cfe:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d01:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d04:	c9                   	leave  
  800d05:	c3                   	ret    

00800d06 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d06:	55                   	push   %ebp
  800d07:	89 e5                	mov    %esp,%ebp
  800d09:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d0c:	8d 45 10             	lea    0x10(%ebp),%eax
  800d0f:	83 c0 04             	add    $0x4,%eax
  800d12:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d15:	8b 45 10             	mov    0x10(%ebp),%eax
  800d18:	ff 75 f4             	pushl  -0xc(%ebp)
  800d1b:	50                   	push   %eax
  800d1c:	ff 75 0c             	pushl  0xc(%ebp)
  800d1f:	ff 75 08             	pushl  0x8(%ebp)
  800d22:	e8 89 ff ff ff       	call   800cb0 <vsnprintf>
  800d27:	83 c4 10             	add    $0x10,%esp
  800d2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d30:	c9                   	leave  
  800d31:	c3                   	ret    

00800d32 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800d32:	55                   	push   %ebp
  800d33:	89 e5                	mov    %esp,%ebp
  800d35:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d38:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d3f:	eb 06                	jmp    800d47 <strlen+0x15>
		n++;
  800d41:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d44:	ff 45 08             	incl   0x8(%ebp)
  800d47:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4a:	8a 00                	mov    (%eax),%al
  800d4c:	84 c0                	test   %al,%al
  800d4e:	75 f1                	jne    800d41 <strlen+0xf>
		n++;
	return n;
  800d50:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d53:	c9                   	leave  
  800d54:	c3                   	ret    

00800d55 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d55:	55                   	push   %ebp
  800d56:	89 e5                	mov    %esp,%ebp
  800d58:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d5b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d62:	eb 09                	jmp    800d6d <strnlen+0x18>
		n++;
  800d64:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d67:	ff 45 08             	incl   0x8(%ebp)
  800d6a:	ff 4d 0c             	decl   0xc(%ebp)
  800d6d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d71:	74 09                	je     800d7c <strnlen+0x27>
  800d73:	8b 45 08             	mov    0x8(%ebp),%eax
  800d76:	8a 00                	mov    (%eax),%al
  800d78:	84 c0                	test   %al,%al
  800d7a:	75 e8                	jne    800d64 <strnlen+0xf>
		n++;
	return n;
  800d7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d7f:	c9                   	leave  
  800d80:	c3                   	ret    

00800d81 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d81:	55                   	push   %ebp
  800d82:	89 e5                	mov    %esp,%ebp
  800d84:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d87:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d8d:	90                   	nop
  800d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d91:	8d 50 01             	lea    0x1(%eax),%edx
  800d94:	89 55 08             	mov    %edx,0x8(%ebp)
  800d97:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d9a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d9d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800da0:	8a 12                	mov    (%edx),%dl
  800da2:	88 10                	mov    %dl,(%eax)
  800da4:	8a 00                	mov    (%eax),%al
  800da6:	84 c0                	test   %al,%al
  800da8:	75 e4                	jne    800d8e <strcpy+0xd>
		/* do nothing */;
	return ret;
  800daa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800dad:	c9                   	leave  
  800dae:	c3                   	ret    

00800daf <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800daf:	55                   	push   %ebp
  800db0:	89 e5                	mov    %esp,%ebp
  800db2:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800db5:	8b 45 08             	mov    0x8(%ebp),%eax
  800db8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800dbb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dc2:	eb 1f                	jmp    800de3 <strncpy+0x34>
		*dst++ = *src;
  800dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc7:	8d 50 01             	lea    0x1(%eax),%edx
  800dca:	89 55 08             	mov    %edx,0x8(%ebp)
  800dcd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dd0:	8a 12                	mov    (%edx),%dl
  800dd2:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800dd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd7:	8a 00                	mov    (%eax),%al
  800dd9:	84 c0                	test   %al,%al
  800ddb:	74 03                	je     800de0 <strncpy+0x31>
			src++;
  800ddd:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800de0:	ff 45 fc             	incl   -0x4(%ebp)
  800de3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800de6:	3b 45 10             	cmp    0x10(%ebp),%eax
  800de9:	72 d9                	jb     800dc4 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800deb:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800dee:	c9                   	leave  
  800def:	c3                   	ret    

00800df0 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800df0:	55                   	push   %ebp
  800df1:	89 e5                	mov    %esp,%ebp
  800df3:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800df6:	8b 45 08             	mov    0x8(%ebp),%eax
  800df9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800dfc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e00:	74 30                	je     800e32 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e02:	eb 16                	jmp    800e1a <strlcpy+0x2a>
			*dst++ = *src++;
  800e04:	8b 45 08             	mov    0x8(%ebp),%eax
  800e07:	8d 50 01             	lea    0x1(%eax),%edx
  800e0a:	89 55 08             	mov    %edx,0x8(%ebp)
  800e0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e10:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e13:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e16:	8a 12                	mov    (%edx),%dl
  800e18:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e1a:	ff 4d 10             	decl   0x10(%ebp)
  800e1d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e21:	74 09                	je     800e2c <strlcpy+0x3c>
  800e23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e26:	8a 00                	mov    (%eax),%al
  800e28:	84 c0                	test   %al,%al
  800e2a:	75 d8                	jne    800e04 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e32:	8b 55 08             	mov    0x8(%ebp),%edx
  800e35:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e38:	29 c2                	sub    %eax,%edx
  800e3a:	89 d0                	mov    %edx,%eax
}
  800e3c:	c9                   	leave  
  800e3d:	c3                   	ret    

00800e3e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e3e:	55                   	push   %ebp
  800e3f:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e41:	eb 06                	jmp    800e49 <strcmp+0xb>
		p++, q++;
  800e43:	ff 45 08             	incl   0x8(%ebp)
  800e46:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e49:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4c:	8a 00                	mov    (%eax),%al
  800e4e:	84 c0                	test   %al,%al
  800e50:	74 0e                	je     800e60 <strcmp+0x22>
  800e52:	8b 45 08             	mov    0x8(%ebp),%eax
  800e55:	8a 10                	mov    (%eax),%dl
  800e57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5a:	8a 00                	mov    (%eax),%al
  800e5c:	38 c2                	cmp    %al,%dl
  800e5e:	74 e3                	je     800e43 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e60:	8b 45 08             	mov    0x8(%ebp),%eax
  800e63:	8a 00                	mov    (%eax),%al
  800e65:	0f b6 d0             	movzbl %al,%edx
  800e68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6b:	8a 00                	mov    (%eax),%al
  800e6d:	0f b6 c0             	movzbl %al,%eax
  800e70:	29 c2                	sub    %eax,%edx
  800e72:	89 d0                	mov    %edx,%eax
}
  800e74:	5d                   	pop    %ebp
  800e75:	c3                   	ret    

00800e76 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e76:	55                   	push   %ebp
  800e77:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e79:	eb 09                	jmp    800e84 <strncmp+0xe>
		n--, p++, q++;
  800e7b:	ff 4d 10             	decl   0x10(%ebp)
  800e7e:	ff 45 08             	incl   0x8(%ebp)
  800e81:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e84:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e88:	74 17                	je     800ea1 <strncmp+0x2b>
  800e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8d:	8a 00                	mov    (%eax),%al
  800e8f:	84 c0                	test   %al,%al
  800e91:	74 0e                	je     800ea1 <strncmp+0x2b>
  800e93:	8b 45 08             	mov    0x8(%ebp),%eax
  800e96:	8a 10                	mov    (%eax),%dl
  800e98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9b:	8a 00                	mov    (%eax),%al
  800e9d:	38 c2                	cmp    %al,%dl
  800e9f:	74 da                	je     800e7b <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800ea1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ea5:	75 07                	jne    800eae <strncmp+0x38>
		return 0;
  800ea7:	b8 00 00 00 00       	mov    $0x0,%eax
  800eac:	eb 14                	jmp    800ec2 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800eae:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb1:	8a 00                	mov    (%eax),%al
  800eb3:	0f b6 d0             	movzbl %al,%edx
  800eb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb9:	8a 00                	mov    (%eax),%al
  800ebb:	0f b6 c0             	movzbl %al,%eax
  800ebe:	29 c2                	sub    %eax,%edx
  800ec0:	89 d0                	mov    %edx,%eax
}
  800ec2:	5d                   	pop    %ebp
  800ec3:	c3                   	ret    

00800ec4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ec4:	55                   	push   %ebp
  800ec5:	89 e5                	mov    %esp,%ebp
  800ec7:	83 ec 04             	sub    $0x4,%esp
  800eca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ecd:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ed0:	eb 12                	jmp    800ee4 <strchr+0x20>
		if (*s == c)
  800ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed5:	8a 00                	mov    (%eax),%al
  800ed7:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800eda:	75 05                	jne    800ee1 <strchr+0x1d>
			return (char *) s;
  800edc:	8b 45 08             	mov    0x8(%ebp),%eax
  800edf:	eb 11                	jmp    800ef2 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ee1:	ff 45 08             	incl   0x8(%ebp)
  800ee4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee7:	8a 00                	mov    (%eax),%al
  800ee9:	84 c0                	test   %al,%al
  800eeb:	75 e5                	jne    800ed2 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800eed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ef2:	c9                   	leave  
  800ef3:	c3                   	ret    

00800ef4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ef4:	55                   	push   %ebp
  800ef5:	89 e5                	mov    %esp,%ebp
  800ef7:	83 ec 04             	sub    $0x4,%esp
  800efa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efd:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f00:	eb 0d                	jmp    800f0f <strfind+0x1b>
		if (*s == c)
  800f02:	8b 45 08             	mov    0x8(%ebp),%eax
  800f05:	8a 00                	mov    (%eax),%al
  800f07:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f0a:	74 0e                	je     800f1a <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f0c:	ff 45 08             	incl   0x8(%ebp)
  800f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f12:	8a 00                	mov    (%eax),%al
  800f14:	84 c0                	test   %al,%al
  800f16:	75 ea                	jne    800f02 <strfind+0xe>
  800f18:	eb 01                	jmp    800f1b <strfind+0x27>
		if (*s == c)
			break;
  800f1a:	90                   	nop
	return (char *) s;
  800f1b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f1e:	c9                   	leave  
  800f1f:	c3                   	ret    

00800f20 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800f20:	55                   	push   %ebp
  800f21:	89 e5                	mov    %esp,%ebp
  800f23:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800f26:	8b 45 08             	mov    0x8(%ebp),%eax
  800f29:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800f2c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f2f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800f32:	eb 0e                	jmp    800f42 <memset+0x22>
		*p++ = c;
  800f34:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f37:	8d 50 01             	lea    0x1(%eax),%edx
  800f3a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f40:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800f42:	ff 4d f8             	decl   -0x8(%ebp)
  800f45:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800f49:	79 e9                	jns    800f34 <memset+0x14>
		*p++ = c;

	return v;
  800f4b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f4e:	c9                   	leave  
  800f4f:	c3                   	ret    

00800f50 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f50:	55                   	push   %ebp
  800f51:	89 e5                	mov    %esp,%ebp
  800f53:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f59:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800f62:	eb 16                	jmp    800f7a <memcpy+0x2a>
		*d++ = *s++;
  800f64:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f67:	8d 50 01             	lea    0x1(%eax),%edx
  800f6a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f6d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f70:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f73:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f76:	8a 12                	mov    (%edx),%dl
  800f78:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f7a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f7d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f80:	89 55 10             	mov    %edx,0x10(%ebp)
  800f83:	85 c0                	test   %eax,%eax
  800f85:	75 dd                	jne    800f64 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f87:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f8a:	c9                   	leave  
  800f8b:	c3                   	ret    

00800f8c <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f8c:	55                   	push   %ebp
  800f8d:	89 e5                	mov    %esp,%ebp
  800f8f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f95:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f98:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fa1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fa4:	73 50                	jae    800ff6 <memmove+0x6a>
  800fa6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fa9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fac:	01 d0                	add    %edx,%eax
  800fae:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fb1:	76 43                	jbe    800ff6 <memmove+0x6a>
		s += n;
  800fb3:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb6:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800fb9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fbc:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fbf:	eb 10                	jmp    800fd1 <memmove+0x45>
			*--d = *--s;
  800fc1:	ff 4d f8             	decl   -0x8(%ebp)
  800fc4:	ff 4d fc             	decl   -0x4(%ebp)
  800fc7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fca:	8a 10                	mov    (%eax),%dl
  800fcc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fcf:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fd1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fd7:	89 55 10             	mov    %edx,0x10(%ebp)
  800fda:	85 c0                	test   %eax,%eax
  800fdc:	75 e3                	jne    800fc1 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fde:	eb 23                	jmp    801003 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fe0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fe3:	8d 50 01             	lea    0x1(%eax),%edx
  800fe6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fe9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fec:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fef:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ff2:	8a 12                	mov    (%edx),%dl
  800ff4:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800ff6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ffc:	89 55 10             	mov    %edx,0x10(%ebp)
  800fff:	85 c0                	test   %eax,%eax
  801001:	75 dd                	jne    800fe0 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801003:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801006:	c9                   	leave  
  801007:	c3                   	ret    

00801008 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801008:	55                   	push   %ebp
  801009:	89 e5                	mov    %esp,%ebp
  80100b:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80100e:	8b 45 08             	mov    0x8(%ebp),%eax
  801011:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801014:	8b 45 0c             	mov    0xc(%ebp),%eax
  801017:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80101a:	eb 2a                	jmp    801046 <memcmp+0x3e>
		if (*s1 != *s2)
  80101c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80101f:	8a 10                	mov    (%eax),%dl
  801021:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801024:	8a 00                	mov    (%eax),%al
  801026:	38 c2                	cmp    %al,%dl
  801028:	74 16                	je     801040 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80102a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80102d:	8a 00                	mov    (%eax),%al
  80102f:	0f b6 d0             	movzbl %al,%edx
  801032:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801035:	8a 00                	mov    (%eax),%al
  801037:	0f b6 c0             	movzbl %al,%eax
  80103a:	29 c2                	sub    %eax,%edx
  80103c:	89 d0                	mov    %edx,%eax
  80103e:	eb 18                	jmp    801058 <memcmp+0x50>
		s1++, s2++;
  801040:	ff 45 fc             	incl   -0x4(%ebp)
  801043:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801046:	8b 45 10             	mov    0x10(%ebp),%eax
  801049:	8d 50 ff             	lea    -0x1(%eax),%edx
  80104c:	89 55 10             	mov    %edx,0x10(%ebp)
  80104f:	85 c0                	test   %eax,%eax
  801051:	75 c9                	jne    80101c <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801053:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801058:	c9                   	leave  
  801059:	c3                   	ret    

0080105a <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80105a:	55                   	push   %ebp
  80105b:	89 e5                	mov    %esp,%ebp
  80105d:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801060:	8b 55 08             	mov    0x8(%ebp),%edx
  801063:	8b 45 10             	mov    0x10(%ebp),%eax
  801066:	01 d0                	add    %edx,%eax
  801068:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80106b:	eb 15                	jmp    801082 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80106d:	8b 45 08             	mov    0x8(%ebp),%eax
  801070:	8a 00                	mov    (%eax),%al
  801072:	0f b6 d0             	movzbl %al,%edx
  801075:	8b 45 0c             	mov    0xc(%ebp),%eax
  801078:	0f b6 c0             	movzbl %al,%eax
  80107b:	39 c2                	cmp    %eax,%edx
  80107d:	74 0d                	je     80108c <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80107f:	ff 45 08             	incl   0x8(%ebp)
  801082:	8b 45 08             	mov    0x8(%ebp),%eax
  801085:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801088:	72 e3                	jb     80106d <memfind+0x13>
  80108a:	eb 01                	jmp    80108d <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80108c:	90                   	nop
	return (void *) s;
  80108d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801090:	c9                   	leave  
  801091:	c3                   	ret    

00801092 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801092:	55                   	push   %ebp
  801093:	89 e5                	mov    %esp,%ebp
  801095:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801098:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80109f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010a6:	eb 03                	jmp    8010ab <strtol+0x19>
		s++;
  8010a8:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ae:	8a 00                	mov    (%eax),%al
  8010b0:	3c 20                	cmp    $0x20,%al
  8010b2:	74 f4                	je     8010a8 <strtol+0x16>
  8010b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b7:	8a 00                	mov    (%eax),%al
  8010b9:	3c 09                	cmp    $0x9,%al
  8010bb:	74 eb                	je     8010a8 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c0:	8a 00                	mov    (%eax),%al
  8010c2:	3c 2b                	cmp    $0x2b,%al
  8010c4:	75 05                	jne    8010cb <strtol+0x39>
		s++;
  8010c6:	ff 45 08             	incl   0x8(%ebp)
  8010c9:	eb 13                	jmp    8010de <strtol+0x4c>
	else if (*s == '-')
  8010cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ce:	8a 00                	mov    (%eax),%al
  8010d0:	3c 2d                	cmp    $0x2d,%al
  8010d2:	75 0a                	jne    8010de <strtol+0x4c>
		s++, neg = 1;
  8010d4:	ff 45 08             	incl   0x8(%ebp)
  8010d7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010de:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010e2:	74 06                	je     8010ea <strtol+0x58>
  8010e4:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010e8:	75 20                	jne    80110a <strtol+0x78>
  8010ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ed:	8a 00                	mov    (%eax),%al
  8010ef:	3c 30                	cmp    $0x30,%al
  8010f1:	75 17                	jne    80110a <strtol+0x78>
  8010f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f6:	40                   	inc    %eax
  8010f7:	8a 00                	mov    (%eax),%al
  8010f9:	3c 78                	cmp    $0x78,%al
  8010fb:	75 0d                	jne    80110a <strtol+0x78>
		s += 2, base = 16;
  8010fd:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801101:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801108:	eb 28                	jmp    801132 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80110a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80110e:	75 15                	jne    801125 <strtol+0x93>
  801110:	8b 45 08             	mov    0x8(%ebp),%eax
  801113:	8a 00                	mov    (%eax),%al
  801115:	3c 30                	cmp    $0x30,%al
  801117:	75 0c                	jne    801125 <strtol+0x93>
		s++, base = 8;
  801119:	ff 45 08             	incl   0x8(%ebp)
  80111c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801123:	eb 0d                	jmp    801132 <strtol+0xa0>
	else if (base == 0)
  801125:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801129:	75 07                	jne    801132 <strtol+0xa0>
		base = 10;
  80112b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801132:	8b 45 08             	mov    0x8(%ebp),%eax
  801135:	8a 00                	mov    (%eax),%al
  801137:	3c 2f                	cmp    $0x2f,%al
  801139:	7e 19                	jle    801154 <strtol+0xc2>
  80113b:	8b 45 08             	mov    0x8(%ebp),%eax
  80113e:	8a 00                	mov    (%eax),%al
  801140:	3c 39                	cmp    $0x39,%al
  801142:	7f 10                	jg     801154 <strtol+0xc2>
			dig = *s - '0';
  801144:	8b 45 08             	mov    0x8(%ebp),%eax
  801147:	8a 00                	mov    (%eax),%al
  801149:	0f be c0             	movsbl %al,%eax
  80114c:	83 e8 30             	sub    $0x30,%eax
  80114f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801152:	eb 42                	jmp    801196 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801154:	8b 45 08             	mov    0x8(%ebp),%eax
  801157:	8a 00                	mov    (%eax),%al
  801159:	3c 60                	cmp    $0x60,%al
  80115b:	7e 19                	jle    801176 <strtol+0xe4>
  80115d:	8b 45 08             	mov    0x8(%ebp),%eax
  801160:	8a 00                	mov    (%eax),%al
  801162:	3c 7a                	cmp    $0x7a,%al
  801164:	7f 10                	jg     801176 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801166:	8b 45 08             	mov    0x8(%ebp),%eax
  801169:	8a 00                	mov    (%eax),%al
  80116b:	0f be c0             	movsbl %al,%eax
  80116e:	83 e8 57             	sub    $0x57,%eax
  801171:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801174:	eb 20                	jmp    801196 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801176:	8b 45 08             	mov    0x8(%ebp),%eax
  801179:	8a 00                	mov    (%eax),%al
  80117b:	3c 40                	cmp    $0x40,%al
  80117d:	7e 39                	jle    8011b8 <strtol+0x126>
  80117f:	8b 45 08             	mov    0x8(%ebp),%eax
  801182:	8a 00                	mov    (%eax),%al
  801184:	3c 5a                	cmp    $0x5a,%al
  801186:	7f 30                	jg     8011b8 <strtol+0x126>
			dig = *s - 'A' + 10;
  801188:	8b 45 08             	mov    0x8(%ebp),%eax
  80118b:	8a 00                	mov    (%eax),%al
  80118d:	0f be c0             	movsbl %al,%eax
  801190:	83 e8 37             	sub    $0x37,%eax
  801193:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801196:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801199:	3b 45 10             	cmp    0x10(%ebp),%eax
  80119c:	7d 19                	jge    8011b7 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80119e:	ff 45 08             	incl   0x8(%ebp)
  8011a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011a4:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011a8:	89 c2                	mov    %eax,%edx
  8011aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011ad:	01 d0                	add    %edx,%eax
  8011af:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011b2:	e9 7b ff ff ff       	jmp    801132 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011b7:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011b8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011bc:	74 08                	je     8011c6 <strtol+0x134>
		*endptr = (char *) s;
  8011be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8011c4:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011c6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011ca:	74 07                	je     8011d3 <strtol+0x141>
  8011cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011cf:	f7 d8                	neg    %eax
  8011d1:	eb 03                	jmp    8011d6 <strtol+0x144>
  8011d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011d6:	c9                   	leave  
  8011d7:	c3                   	ret    

008011d8 <ltostr>:

void
ltostr(long value, char *str)
{
  8011d8:	55                   	push   %ebp
  8011d9:	89 e5                	mov    %esp,%ebp
  8011db:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011e5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011ec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011f0:	79 13                	jns    801205 <ltostr+0x2d>
	{
		neg = 1;
  8011f2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fc:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011ff:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801202:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801205:	8b 45 08             	mov    0x8(%ebp),%eax
  801208:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80120d:	99                   	cltd   
  80120e:	f7 f9                	idiv   %ecx
  801210:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801213:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801216:	8d 50 01             	lea    0x1(%eax),%edx
  801219:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80121c:	89 c2                	mov    %eax,%edx
  80121e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801221:	01 d0                	add    %edx,%eax
  801223:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801226:	83 c2 30             	add    $0x30,%edx
  801229:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80122b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80122e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801233:	f7 e9                	imul   %ecx
  801235:	c1 fa 02             	sar    $0x2,%edx
  801238:	89 c8                	mov    %ecx,%eax
  80123a:	c1 f8 1f             	sar    $0x1f,%eax
  80123d:	29 c2                	sub    %eax,%edx
  80123f:	89 d0                	mov    %edx,%eax
  801241:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801244:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801247:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80124c:	f7 e9                	imul   %ecx
  80124e:	c1 fa 02             	sar    $0x2,%edx
  801251:	89 c8                	mov    %ecx,%eax
  801253:	c1 f8 1f             	sar    $0x1f,%eax
  801256:	29 c2                	sub    %eax,%edx
  801258:	89 d0                	mov    %edx,%eax
  80125a:	c1 e0 02             	shl    $0x2,%eax
  80125d:	01 d0                	add    %edx,%eax
  80125f:	01 c0                	add    %eax,%eax
  801261:	29 c1                	sub    %eax,%ecx
  801263:	89 ca                	mov    %ecx,%edx
  801265:	85 d2                	test   %edx,%edx
  801267:	75 9c                	jne    801205 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801269:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801270:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801273:	48                   	dec    %eax
  801274:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801277:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80127b:	74 3d                	je     8012ba <ltostr+0xe2>
		start = 1 ;
  80127d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801284:	eb 34                	jmp    8012ba <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801286:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801289:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128c:	01 d0                	add    %edx,%eax
  80128e:	8a 00                	mov    (%eax),%al
  801290:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801293:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801296:	8b 45 0c             	mov    0xc(%ebp),%eax
  801299:	01 c2                	add    %eax,%edx
  80129b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80129e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a1:	01 c8                	add    %ecx,%eax
  8012a3:	8a 00                	mov    (%eax),%al
  8012a5:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8012a7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ad:	01 c2                	add    %eax,%edx
  8012af:	8a 45 eb             	mov    -0x15(%ebp),%al
  8012b2:	88 02                	mov    %al,(%edx)
		start++ ;
  8012b4:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012b7:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012bd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012c0:	7c c4                	jl     801286 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012c2:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c8:	01 d0                	add    %edx,%eax
  8012ca:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012cd:	90                   	nop
  8012ce:	c9                   	leave  
  8012cf:	c3                   	ret    

008012d0 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012d0:	55                   	push   %ebp
  8012d1:	89 e5                	mov    %esp,%ebp
  8012d3:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012d6:	ff 75 08             	pushl  0x8(%ebp)
  8012d9:	e8 54 fa ff ff       	call   800d32 <strlen>
  8012de:	83 c4 04             	add    $0x4,%esp
  8012e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012e4:	ff 75 0c             	pushl  0xc(%ebp)
  8012e7:	e8 46 fa ff ff       	call   800d32 <strlen>
  8012ec:	83 c4 04             	add    $0x4,%esp
  8012ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012f2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012f9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801300:	eb 17                	jmp    801319 <strcconcat+0x49>
		final[s] = str1[s] ;
  801302:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801305:	8b 45 10             	mov    0x10(%ebp),%eax
  801308:	01 c2                	add    %eax,%edx
  80130a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80130d:	8b 45 08             	mov    0x8(%ebp),%eax
  801310:	01 c8                	add    %ecx,%eax
  801312:	8a 00                	mov    (%eax),%al
  801314:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801316:	ff 45 fc             	incl   -0x4(%ebp)
  801319:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80131c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80131f:	7c e1                	jl     801302 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801321:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801328:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80132f:	eb 1f                	jmp    801350 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801331:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801334:	8d 50 01             	lea    0x1(%eax),%edx
  801337:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80133a:	89 c2                	mov    %eax,%edx
  80133c:	8b 45 10             	mov    0x10(%ebp),%eax
  80133f:	01 c2                	add    %eax,%edx
  801341:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801344:	8b 45 0c             	mov    0xc(%ebp),%eax
  801347:	01 c8                	add    %ecx,%eax
  801349:	8a 00                	mov    (%eax),%al
  80134b:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80134d:	ff 45 f8             	incl   -0x8(%ebp)
  801350:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801353:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801356:	7c d9                	jl     801331 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801358:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80135b:	8b 45 10             	mov    0x10(%ebp),%eax
  80135e:	01 d0                	add    %edx,%eax
  801360:	c6 00 00             	movb   $0x0,(%eax)
}
  801363:	90                   	nop
  801364:	c9                   	leave  
  801365:	c3                   	ret    

00801366 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801366:	55                   	push   %ebp
  801367:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801369:	8b 45 14             	mov    0x14(%ebp),%eax
  80136c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801372:	8b 45 14             	mov    0x14(%ebp),%eax
  801375:	8b 00                	mov    (%eax),%eax
  801377:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80137e:	8b 45 10             	mov    0x10(%ebp),%eax
  801381:	01 d0                	add    %edx,%eax
  801383:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801389:	eb 0c                	jmp    801397 <strsplit+0x31>
			*string++ = 0;
  80138b:	8b 45 08             	mov    0x8(%ebp),%eax
  80138e:	8d 50 01             	lea    0x1(%eax),%edx
  801391:	89 55 08             	mov    %edx,0x8(%ebp)
  801394:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801397:	8b 45 08             	mov    0x8(%ebp),%eax
  80139a:	8a 00                	mov    (%eax),%al
  80139c:	84 c0                	test   %al,%al
  80139e:	74 18                	je     8013b8 <strsplit+0x52>
  8013a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a3:	8a 00                	mov    (%eax),%al
  8013a5:	0f be c0             	movsbl %al,%eax
  8013a8:	50                   	push   %eax
  8013a9:	ff 75 0c             	pushl  0xc(%ebp)
  8013ac:	e8 13 fb ff ff       	call   800ec4 <strchr>
  8013b1:	83 c4 08             	add    $0x8,%esp
  8013b4:	85 c0                	test   %eax,%eax
  8013b6:	75 d3                	jne    80138b <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8013b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bb:	8a 00                	mov    (%eax),%al
  8013bd:	84 c0                	test   %al,%al
  8013bf:	74 5a                	je     80141b <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8013c4:	8b 00                	mov    (%eax),%eax
  8013c6:	83 f8 0f             	cmp    $0xf,%eax
  8013c9:	75 07                	jne    8013d2 <strsplit+0x6c>
		{
			return 0;
  8013cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8013d0:	eb 66                	jmp    801438 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8013d5:	8b 00                	mov    (%eax),%eax
  8013d7:	8d 48 01             	lea    0x1(%eax),%ecx
  8013da:	8b 55 14             	mov    0x14(%ebp),%edx
  8013dd:	89 0a                	mov    %ecx,(%edx)
  8013df:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e9:	01 c2                	add    %eax,%edx
  8013eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ee:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013f0:	eb 03                	jmp    8013f5 <strsplit+0x8f>
			string++;
  8013f2:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f8:	8a 00                	mov    (%eax),%al
  8013fa:	84 c0                	test   %al,%al
  8013fc:	74 8b                	je     801389 <strsplit+0x23>
  8013fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801401:	8a 00                	mov    (%eax),%al
  801403:	0f be c0             	movsbl %al,%eax
  801406:	50                   	push   %eax
  801407:	ff 75 0c             	pushl  0xc(%ebp)
  80140a:	e8 b5 fa ff ff       	call   800ec4 <strchr>
  80140f:	83 c4 08             	add    $0x8,%esp
  801412:	85 c0                	test   %eax,%eax
  801414:	74 dc                	je     8013f2 <strsplit+0x8c>
			string++;
	}
  801416:	e9 6e ff ff ff       	jmp    801389 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80141b:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80141c:	8b 45 14             	mov    0x14(%ebp),%eax
  80141f:	8b 00                	mov    (%eax),%eax
  801421:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801428:	8b 45 10             	mov    0x10(%ebp),%eax
  80142b:	01 d0                	add    %edx,%eax
  80142d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801433:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801438:	c9                   	leave  
  801439:	c3                   	ret    

0080143a <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  80143a:	55                   	push   %ebp
  80143b:	89 e5                	mov    %esp,%ebp
  80143d:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801440:	a1 04 50 80 00       	mov    0x805004,%eax
  801445:	85 c0                	test   %eax,%eax
  801447:	74 1f                	je     801468 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801449:	e8 1d 00 00 00       	call   80146b <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80144e:	83 ec 0c             	sub    $0xc,%esp
  801451:	68 50 3e 80 00       	push   $0x803e50
  801456:	e8 55 f2 ff ff       	call   8006b0 <cprintf>
  80145b:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80145e:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801465:	00 00 00 
	}
}
  801468:	90                   	nop
  801469:	c9                   	leave  
  80146a:	c3                   	ret    

0080146b <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80146b:	55                   	push   %ebp
  80146c:	89 e5                	mov    %esp,%ebp
  80146e:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  801471:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801478:	00 00 00 
  80147b:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801482:	00 00 00 
  801485:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  80148c:	00 00 00 
		LIST_INIT(&AllocMemBlocksList);
  80148f:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801496:	00 00 00 
  801499:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  8014a0:	00 00 00 
  8014a3:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  8014aa:	00 00 00 

		MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES ;
  8014ad:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  8014b4:	00 02 00 
		MemBlockNodes =(struct MemBlock*)USER_DYN_BLKS_ARRAY ;
  8014b7:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  8014be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014c1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014c6:	2d 00 10 00 00       	sub    $0x1000,%eax
  8014cb:	a3 50 50 80 00       	mov    %eax,0x805050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock),PAGE_SIZE),PERM_USER|PERM_WRITEABLE);
  8014d0:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8014d7:	a1 20 51 80 00       	mov    0x805120,%eax
  8014dc:	c1 e0 04             	shl    $0x4,%eax
  8014df:	89 c2                	mov    %eax,%edx
  8014e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014e4:	01 d0                	add    %edx,%eax
  8014e6:	48                   	dec    %eax
  8014e7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8014ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8014f2:	f7 75 f0             	divl   -0x10(%ebp)
  8014f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014f8:	29 d0                	sub    %edx,%eax
  8014fa:	89 c2                	mov    %eax,%edx
  8014fc:	c7 45 e8 00 00 e0 7f 	movl   $0x7fe00000,-0x18(%ebp)
  801503:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801506:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80150b:	2d 00 10 00 00       	sub    $0x1000,%eax
  801510:	83 ec 04             	sub    $0x4,%esp
  801513:	6a 06                	push   $0x6
  801515:	52                   	push   %edx
  801516:	50                   	push   %eax
  801517:	e8 71 05 00 00       	call   801a8d <sys_allocate_chunk>
  80151c:	83 c4 10             	add    $0x10,%esp
		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80151f:	a1 20 51 80 00       	mov    0x805120,%eax
  801524:	83 ec 0c             	sub    $0xc,%esp
  801527:	50                   	push   %eax
  801528:	e8 e6 0b 00 00       	call   802113 <initialize_MemBlocksList>
  80152d:	83 c4 10             	add    $0x10,%esp

		struct MemBlock  *block_node;
		block_node = AvailableMemBlocksList.lh_first;
  801530:	a1 48 51 80 00       	mov    0x805148,%eax
  801535:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&(AvailableMemBlocksList),block_node);
  801538:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80153c:	75 14                	jne    801552 <initialize_dyn_block_system+0xe7>
  80153e:	83 ec 04             	sub    $0x4,%esp
  801541:	68 75 3e 80 00       	push   $0x803e75
  801546:	6a 2b                	push   $0x2b
  801548:	68 93 3e 80 00       	push   $0x803e93
  80154d:	e8 aa ee ff ff       	call   8003fc <_panic>
  801552:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801555:	8b 00                	mov    (%eax),%eax
  801557:	85 c0                	test   %eax,%eax
  801559:	74 10                	je     80156b <initialize_dyn_block_system+0x100>
  80155b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80155e:	8b 00                	mov    (%eax),%eax
  801560:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801563:	8b 52 04             	mov    0x4(%edx),%edx
  801566:	89 50 04             	mov    %edx,0x4(%eax)
  801569:	eb 0b                	jmp    801576 <initialize_dyn_block_system+0x10b>
  80156b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80156e:	8b 40 04             	mov    0x4(%eax),%eax
  801571:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801576:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801579:	8b 40 04             	mov    0x4(%eax),%eax
  80157c:	85 c0                	test   %eax,%eax
  80157e:	74 0f                	je     80158f <initialize_dyn_block_system+0x124>
  801580:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801583:	8b 40 04             	mov    0x4(%eax),%eax
  801586:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801589:	8b 12                	mov    (%edx),%edx
  80158b:	89 10                	mov    %edx,(%eax)
  80158d:	eb 0a                	jmp    801599 <initialize_dyn_block_system+0x12e>
  80158f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801592:	8b 00                	mov    (%eax),%eax
  801594:	a3 48 51 80 00       	mov    %eax,0x805148
  801599:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80159c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8015a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015a5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8015ac:	a1 54 51 80 00       	mov    0x805154,%eax
  8015b1:	48                   	dec    %eax
  8015b2:	a3 54 51 80 00       	mov    %eax,0x805154
		block_node->sva = USER_HEAP_START ;
  8015b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015ba:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
		block_node->size = ((USER_HEAP_MAX - USER_HEAP_START));
  8015c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015c4:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		insert_sorted_with_merge_freeList(block_node);
  8015cb:	83 ec 0c             	sub    $0xc,%esp
  8015ce:	ff 75 e4             	pushl  -0x1c(%ebp)
  8015d1:	e8 d2 13 00 00       	call   8029a8 <insert_sorted_with_merge_freeList>
  8015d6:	83 c4 10             	add    $0x10,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  8015d9:	90                   	nop
  8015da:	c9                   	leave  
  8015db:	c3                   	ret    

008015dc <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8015dc:	55                   	push   %ebp
  8015dd:	89 e5                	mov    %esp,%ebp
  8015df:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015e2:	e8 53 fe ff ff       	call   80143a <InitializeUHeap>
	if (size == 0) return NULL ;
  8015e7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015eb:	75 07                	jne    8015f4 <malloc+0x18>
  8015ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8015f2:	eb 61                	jmp    801655 <malloc+0x79>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	size= ROUNDUP(size,PAGE_SIZE);
  8015f4:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8015fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8015fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801601:	01 d0                	add    %edx,%eax
  801603:	48                   	dec    %eax
  801604:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801607:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80160a:	ba 00 00 00 00       	mov    $0x0,%edx
  80160f:	f7 75 f4             	divl   -0xc(%ebp)
  801612:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801615:	29 d0                	sub    %edx,%eax
  801617:	89 45 08             	mov    %eax,0x8(%ebp)
	    			if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80161a:	e8 3c 08 00 00       	call   801e5b <sys_isUHeapPlacementStrategyFIRSTFIT>
  80161f:	85 c0                	test   %eax,%eax
  801621:	74 2d                	je     801650 <malloc+0x74>
	    			{
	    				struct MemBlock * ff_block = alloc_block_FF(size);
  801623:	83 ec 0c             	sub    $0xc,%esp
  801626:	ff 75 08             	pushl  0x8(%ebp)
  801629:	e8 3e 0f 00 00       	call   80256c <alloc_block_FF>
  80162e:	83 c4 10             	add    $0x10,%esp
  801631:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    				if(ff_block!=NULL)
  801634:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801638:	74 16                	je     801650 <malloc+0x74>
	    				{

	    					insert_sorted_allocList(ff_block);
  80163a:	83 ec 0c             	sub    $0xc,%esp
  80163d:	ff 75 ec             	pushl  -0x14(%ebp)
  801640:	e8 48 0c 00 00       	call   80228d <insert_sorted_allocList>
  801645:	83 c4 10             	add    $0x10,%esp
	    					return (void*) ff_block->sva ;
  801648:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80164b:	8b 40 08             	mov    0x8(%eax),%eax
  80164e:	eb 05                	jmp    801655 <malloc+0x79>

	    				}
	}
	    			return (void*) NULL ;
  801650:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801655:	c9                   	leave  
  801656:	c3                   	ret    

00801657 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801657:	55                   	push   %ebp
  801658:	89 e5                	mov    %esp,%ebp
  80165a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock *elementForEach;
		virtual_address = ROUNDDOWN(virtual_address, PAGE_SIZE);
  80165d:	8b 45 08             	mov    0x8(%ebp),%eax
  801660:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801663:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801666:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80166b:	89 45 08             	mov    %eax,0x8(%ebp)
	//	if (is_mallocPages[indexindex((uint32) virtual_address)] == 1) {
		elementForEach = find_block(&AllocMemBlocksList,(uint32)virtual_address);
  80166e:	8b 45 08             	mov    0x8(%ebp),%eax
  801671:	83 ec 08             	sub    $0x8,%esp
  801674:	50                   	push   %eax
  801675:	68 40 50 80 00       	push   $0x805040
  80167a:	e8 71 0b 00 00       	call   8021f0 <find_block>
  80167f:	83 c4 10             	add    $0x10,%esp
  801682:	89 45 f0             	mov    %eax,-0x10(%ebp)
		sys_free_user_mem((uint32) virtual_address, elementForEach->size);
  801685:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801688:	8b 50 0c             	mov    0xc(%eax),%edx
  80168b:	8b 45 08             	mov    0x8(%ebp),%eax
  80168e:	83 ec 08             	sub    $0x8,%esp
  801691:	52                   	push   %edx
  801692:	50                   	push   %eax
  801693:	e8 bd 03 00 00       	call   801a55 <sys_free_user_mem>
  801698:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,elementForEach);
  80169b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80169f:	75 14                	jne    8016b5 <free+0x5e>
  8016a1:	83 ec 04             	sub    $0x4,%esp
  8016a4:	68 75 3e 80 00       	push   $0x803e75
  8016a9:	6a 71                	push   $0x71
  8016ab:	68 93 3e 80 00       	push   $0x803e93
  8016b0:	e8 47 ed ff ff       	call   8003fc <_panic>
  8016b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b8:	8b 00                	mov    (%eax),%eax
  8016ba:	85 c0                	test   %eax,%eax
  8016bc:	74 10                	je     8016ce <free+0x77>
  8016be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016c1:	8b 00                	mov    (%eax),%eax
  8016c3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016c6:	8b 52 04             	mov    0x4(%edx),%edx
  8016c9:	89 50 04             	mov    %edx,0x4(%eax)
  8016cc:	eb 0b                	jmp    8016d9 <free+0x82>
  8016ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016d1:	8b 40 04             	mov    0x4(%eax),%eax
  8016d4:	a3 44 50 80 00       	mov    %eax,0x805044
  8016d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016dc:	8b 40 04             	mov    0x4(%eax),%eax
  8016df:	85 c0                	test   %eax,%eax
  8016e1:	74 0f                	je     8016f2 <free+0x9b>
  8016e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016e6:	8b 40 04             	mov    0x4(%eax),%eax
  8016e9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016ec:	8b 12                	mov    (%edx),%edx
  8016ee:	89 10                	mov    %edx,(%eax)
  8016f0:	eb 0a                	jmp    8016fc <free+0xa5>
  8016f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016f5:	8b 00                	mov    (%eax),%eax
  8016f7:	a3 40 50 80 00       	mov    %eax,0x805040
  8016fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801705:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801708:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80170f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801714:	48                   	dec    %eax
  801715:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(elementForEach);
  80171a:	83 ec 0c             	sub    $0xc,%esp
  80171d:	ff 75 f0             	pushl  -0x10(%ebp)
  801720:	e8 83 12 00 00       	call   8029a8 <insert_sorted_with_merge_freeList>
  801725:	83 c4 10             	add    $0x10,%esp
	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801728:	90                   	nop
  801729:	c9                   	leave  
  80172a:	c3                   	ret    

0080172b <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80172b:	55                   	push   %ebp
  80172c:	89 e5                	mov    %esp,%ebp
  80172e:	83 ec 28             	sub    $0x28,%esp
  801731:	8b 45 10             	mov    0x10(%ebp),%eax
  801734:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801737:	e8 fe fc ff ff       	call   80143a <InitializeUHeap>
	if (size == 0) return NULL ;
  80173c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801740:	75 0a                	jne    80174c <smalloc+0x21>
  801742:	b8 00 00 00 00       	mov    $0x0,%eax
  801747:	e9 86 00 00 00       	jmp    8017d2 <smalloc+0xa7>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code

	size=ROUNDUP(size,PAGE_SIZE);
  80174c:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801753:	8b 55 0c             	mov    0xc(%ebp),%edx
  801756:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801759:	01 d0                	add    %edx,%eax
  80175b:	48                   	dec    %eax
  80175c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80175f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801762:	ba 00 00 00 00       	mov    $0x0,%edx
  801767:	f7 75 f4             	divl   -0xc(%ebp)
  80176a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80176d:	29 d0                	sub    %edx,%eax
  80176f:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801772:	e8 e4 06 00 00       	call   801e5b <sys_isUHeapPlacementStrategyFIRSTFIT>
  801777:	85 c0                	test   %eax,%eax
  801779:	74 52                	je     8017cd <smalloc+0xa2>
		{
		struct MemBlock * ff_block ;
		ff_block = alloc_block_FF(size);
  80177b:	83 ec 0c             	sub    $0xc,%esp
  80177e:	ff 75 0c             	pushl  0xc(%ebp)
  801781:	e8 e6 0d 00 00       	call   80256c <alloc_block_FF>
  801786:	83 c4 10             	add    $0x10,%esp
  801789:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(ff_block==NULL)
  80178c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801790:	75 07                	jne    801799 <smalloc+0x6e>
			return NULL ;
  801792:	b8 00 00 00 00       	mov    $0x0,%eax
  801797:	eb 39                	jmp    8017d2 <smalloc+0xa7>

		int obj_id =sys_createSharedObject(sharedVarName,size,isWritable,(void*)ff_block->sva);
  801799:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80179c:	8b 40 08             	mov    0x8(%eax),%eax
  80179f:	89 c2                	mov    %eax,%edx
  8017a1:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8017a5:	52                   	push   %edx
  8017a6:	50                   	push   %eax
  8017a7:	ff 75 0c             	pushl  0xc(%ebp)
  8017aa:	ff 75 08             	pushl  0x8(%ebp)
  8017ad:	e8 2e 04 00 00       	call   801be0 <sys_createSharedObject>
  8017b2:	83 c4 10             	add    $0x10,%esp
  8017b5:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(obj_id < 0)
  8017b8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8017bc:	79 07                	jns    8017c5 <smalloc+0x9a>
			return (void*)NULL ;
  8017be:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c3:	eb 0d                	jmp    8017d2 <smalloc+0xa7>
		else
		    return (void*)ff_block->sva ;
  8017c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017c8:	8b 40 08             	mov    0x8(%eax),%eax
  8017cb:	eb 05                	jmp    8017d2 <smalloc+0xa7>
		}
		return (void*)NULL ;
  8017cd:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8017d2:	c9                   	leave  
  8017d3:	c3                   	ret    

008017d4 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8017d4:	55                   	push   %ebp
  8017d5:	89 e5                	mov    %esp,%ebp
  8017d7:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017da:	e8 5b fc ff ff       	call   80143a <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8017df:	83 ec 08             	sub    $0x8,%esp
  8017e2:	ff 75 0c             	pushl  0xc(%ebp)
  8017e5:	ff 75 08             	pushl  0x8(%ebp)
  8017e8:	e8 1d 04 00 00       	call   801c0a <sys_getSizeOfSharedObject>
  8017ed:	83 c4 10             	add    $0x10,%esp
  8017f0:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(size == 0)
  8017f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8017f7:	75 0a                	jne    801803 <sget+0x2f>
			return NULL ;
  8017f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8017fe:	e9 83 00 00 00       	jmp    801886 <sget+0xb2>
		size=ROUNDUP(size,PAGE_SIZE);
  801803:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80180a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80180d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801810:	01 d0                	add    %edx,%eax
  801812:	48                   	dec    %eax
  801813:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801816:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801819:	ba 00 00 00 00       	mov    $0x0,%edx
  80181e:	f7 75 f0             	divl   -0x10(%ebp)
  801821:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801824:	29 d0                	sub    %edx,%eax
  801826:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801829:	e8 2d 06 00 00       	call   801e5b <sys_isUHeapPlacementStrategyFIRSTFIT>
  80182e:	85 c0                	test   %eax,%eax
  801830:	74 4f                	je     801881 <sget+0xad>
		{
			struct MemBlock * ff_block ;
				ff_block = alloc_block_FF(size);
  801832:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801835:	83 ec 0c             	sub    $0xc,%esp
  801838:	50                   	push   %eax
  801839:	e8 2e 0d 00 00       	call   80256c <alloc_block_FF>
  80183e:	83 c4 10             	add    $0x10,%esp
  801841:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ff_block==NULL)
  801844:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801848:	75 07                	jne    801851 <sget+0x7d>
					return (void*)NULL ;
  80184a:	b8 00 00 00 00       	mov    $0x0,%eax
  80184f:	eb 35                	jmp    801886 <sget+0xb2>

		int obj_id =sys_getSharedObject((int)ownerEnvID,sharedVarName,(void*)ff_block->sva);
  801851:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801854:	8b 40 08             	mov    0x8(%eax),%eax
  801857:	83 ec 04             	sub    $0x4,%esp
  80185a:	50                   	push   %eax
  80185b:	ff 75 0c             	pushl  0xc(%ebp)
  80185e:	ff 75 08             	pushl  0x8(%ebp)
  801861:	e8 c1 03 00 00       	call   801c27 <sys_getSharedObject>
  801866:	83 c4 10             	add    $0x10,%esp
  801869:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if(obj_id<0)
  80186c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801870:	79 07                	jns    801879 <sget+0xa5>
				return (void*)NULL ;
  801872:	b8 00 00 00 00       	mov    $0x0,%eax
  801877:	eb 0d                	jmp    801886 <sget+0xb2>
			else
				return (void*)ff_block->sva ;
  801879:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80187c:	8b 40 08             	mov    0x8(%eax),%eax
  80187f:	eb 05                	jmp    801886 <sget+0xb2>


		}
	return (void*)NULL ;
  801881:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801886:	c9                   	leave  
  801887:	c3                   	ret    

00801888 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801888:	55                   	push   %ebp
  801889:	89 e5                	mov    %esp,%ebp
  80188b:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80188e:	e8 a7 fb ff ff       	call   80143a <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801893:	83 ec 04             	sub    $0x4,%esp
  801896:	68 a0 3e 80 00       	push   $0x803ea0
  80189b:	68 f9 00 00 00       	push   $0xf9
  8018a0:	68 93 3e 80 00       	push   $0x803e93
  8018a5:	e8 52 eb ff ff       	call   8003fc <_panic>

008018aa <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8018aa:	55                   	push   %ebp
  8018ab:	89 e5                	mov    %esp,%ebp
  8018ad:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8018b0:	83 ec 04             	sub    $0x4,%esp
  8018b3:	68 c8 3e 80 00       	push   $0x803ec8
  8018b8:	68 0d 01 00 00       	push   $0x10d
  8018bd:	68 93 3e 80 00       	push   $0x803e93
  8018c2:	e8 35 eb ff ff       	call   8003fc <_panic>

008018c7 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8018c7:	55                   	push   %ebp
  8018c8:	89 e5                	mov    %esp,%ebp
  8018ca:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018cd:	83 ec 04             	sub    $0x4,%esp
  8018d0:	68 ec 3e 80 00       	push   $0x803eec
  8018d5:	68 18 01 00 00       	push   $0x118
  8018da:	68 93 3e 80 00       	push   $0x803e93
  8018df:	e8 18 eb ff ff       	call   8003fc <_panic>

008018e4 <shrink>:

}
void shrink(uint32 newSize)
{
  8018e4:	55                   	push   %ebp
  8018e5:	89 e5                	mov    %esp,%ebp
  8018e7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018ea:	83 ec 04             	sub    $0x4,%esp
  8018ed:	68 ec 3e 80 00       	push   $0x803eec
  8018f2:	68 1d 01 00 00       	push   $0x11d
  8018f7:	68 93 3e 80 00       	push   $0x803e93
  8018fc:	e8 fb ea ff ff       	call   8003fc <_panic>

00801901 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801901:	55                   	push   %ebp
  801902:	89 e5                	mov    %esp,%ebp
  801904:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801907:	83 ec 04             	sub    $0x4,%esp
  80190a:	68 ec 3e 80 00       	push   $0x803eec
  80190f:	68 22 01 00 00       	push   $0x122
  801914:	68 93 3e 80 00       	push   $0x803e93
  801919:	e8 de ea ff ff       	call   8003fc <_panic>

0080191e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80191e:	55                   	push   %ebp
  80191f:	89 e5                	mov    %esp,%ebp
  801921:	57                   	push   %edi
  801922:	56                   	push   %esi
  801923:	53                   	push   %ebx
  801924:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801927:	8b 45 08             	mov    0x8(%ebp),%eax
  80192a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80192d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801930:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801933:	8b 7d 18             	mov    0x18(%ebp),%edi
  801936:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801939:	cd 30                	int    $0x30
  80193b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80193e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801941:	83 c4 10             	add    $0x10,%esp
  801944:	5b                   	pop    %ebx
  801945:	5e                   	pop    %esi
  801946:	5f                   	pop    %edi
  801947:	5d                   	pop    %ebp
  801948:	c3                   	ret    

00801949 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801949:	55                   	push   %ebp
  80194a:	89 e5                	mov    %esp,%ebp
  80194c:	83 ec 04             	sub    $0x4,%esp
  80194f:	8b 45 10             	mov    0x10(%ebp),%eax
  801952:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801955:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801959:	8b 45 08             	mov    0x8(%ebp),%eax
  80195c:	6a 00                	push   $0x0
  80195e:	6a 00                	push   $0x0
  801960:	52                   	push   %edx
  801961:	ff 75 0c             	pushl  0xc(%ebp)
  801964:	50                   	push   %eax
  801965:	6a 00                	push   $0x0
  801967:	e8 b2 ff ff ff       	call   80191e <syscall>
  80196c:	83 c4 18             	add    $0x18,%esp
}
  80196f:	90                   	nop
  801970:	c9                   	leave  
  801971:	c3                   	ret    

00801972 <sys_cgetc>:

int
sys_cgetc(void)
{
  801972:	55                   	push   %ebp
  801973:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801975:	6a 00                	push   $0x0
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	6a 01                	push   $0x1
  801981:	e8 98 ff ff ff       	call   80191e <syscall>
  801986:	83 c4 18             	add    $0x18,%esp
}
  801989:	c9                   	leave  
  80198a:	c3                   	ret    

0080198b <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80198b:	55                   	push   %ebp
  80198c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80198e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801991:	8b 45 08             	mov    0x8(%ebp),%eax
  801994:	6a 00                	push   $0x0
  801996:	6a 00                	push   $0x0
  801998:	6a 00                	push   $0x0
  80199a:	52                   	push   %edx
  80199b:	50                   	push   %eax
  80199c:	6a 05                	push   $0x5
  80199e:	e8 7b ff ff ff       	call   80191e <syscall>
  8019a3:	83 c4 18             	add    $0x18,%esp
}
  8019a6:	c9                   	leave  
  8019a7:	c3                   	ret    

008019a8 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8019a8:	55                   	push   %ebp
  8019a9:	89 e5                	mov    %esp,%ebp
  8019ab:	56                   	push   %esi
  8019ac:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8019ad:	8b 75 18             	mov    0x18(%ebp),%esi
  8019b0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019b3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bc:	56                   	push   %esi
  8019bd:	53                   	push   %ebx
  8019be:	51                   	push   %ecx
  8019bf:	52                   	push   %edx
  8019c0:	50                   	push   %eax
  8019c1:	6a 06                	push   $0x6
  8019c3:	e8 56 ff ff ff       	call   80191e <syscall>
  8019c8:	83 c4 18             	add    $0x18,%esp
}
  8019cb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019ce:	5b                   	pop    %ebx
  8019cf:	5e                   	pop    %esi
  8019d0:	5d                   	pop    %ebp
  8019d1:	c3                   	ret    

008019d2 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8019d2:	55                   	push   %ebp
  8019d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8019d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	52                   	push   %edx
  8019e2:	50                   	push   %eax
  8019e3:	6a 07                	push   $0x7
  8019e5:	e8 34 ff ff ff       	call   80191e <syscall>
  8019ea:	83 c4 18             	add    $0x18,%esp
}
  8019ed:	c9                   	leave  
  8019ee:	c3                   	ret    

008019ef <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8019ef:	55                   	push   %ebp
  8019f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 00                	push   $0x0
  8019f8:	ff 75 0c             	pushl  0xc(%ebp)
  8019fb:	ff 75 08             	pushl  0x8(%ebp)
  8019fe:	6a 08                	push   $0x8
  801a00:	e8 19 ff ff ff       	call   80191e <syscall>
  801a05:	83 c4 18             	add    $0x18,%esp
}
  801a08:	c9                   	leave  
  801a09:	c3                   	ret    

00801a0a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a0a:	55                   	push   %ebp
  801a0b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 00                	push   $0x0
  801a11:	6a 00                	push   $0x0
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	6a 09                	push   $0x9
  801a19:	e8 00 ff ff ff       	call   80191e <syscall>
  801a1e:	83 c4 18             	add    $0x18,%esp
}
  801a21:	c9                   	leave  
  801a22:	c3                   	ret    

00801a23 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a23:	55                   	push   %ebp
  801a24:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 0a                	push   $0xa
  801a32:	e8 e7 fe ff ff       	call   80191e <syscall>
  801a37:	83 c4 18             	add    $0x18,%esp
}
  801a3a:	c9                   	leave  
  801a3b:	c3                   	ret    

00801a3c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a3c:	55                   	push   %ebp
  801a3d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a3f:	6a 00                	push   $0x0
  801a41:	6a 00                	push   $0x0
  801a43:	6a 00                	push   $0x0
  801a45:	6a 00                	push   $0x0
  801a47:	6a 00                	push   $0x0
  801a49:	6a 0b                	push   $0xb
  801a4b:	e8 ce fe ff ff       	call   80191e <syscall>
  801a50:	83 c4 18             	add    $0x18,%esp
}
  801a53:	c9                   	leave  
  801a54:	c3                   	ret    

00801a55 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a55:	55                   	push   %ebp
  801a56:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 00                	push   $0x0
  801a5c:	6a 00                	push   $0x0
  801a5e:	ff 75 0c             	pushl  0xc(%ebp)
  801a61:	ff 75 08             	pushl  0x8(%ebp)
  801a64:	6a 0f                	push   $0xf
  801a66:	e8 b3 fe ff ff       	call   80191e <syscall>
  801a6b:	83 c4 18             	add    $0x18,%esp
	return;
  801a6e:	90                   	nop
}
  801a6f:	c9                   	leave  
  801a70:	c3                   	ret    

00801a71 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a71:	55                   	push   %ebp
  801a72:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a74:	6a 00                	push   $0x0
  801a76:	6a 00                	push   $0x0
  801a78:	6a 00                	push   $0x0
  801a7a:	ff 75 0c             	pushl  0xc(%ebp)
  801a7d:	ff 75 08             	pushl  0x8(%ebp)
  801a80:	6a 10                	push   $0x10
  801a82:	e8 97 fe ff ff       	call   80191e <syscall>
  801a87:	83 c4 18             	add    $0x18,%esp
	return ;
  801a8a:	90                   	nop
}
  801a8b:	c9                   	leave  
  801a8c:	c3                   	ret    

00801a8d <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a8d:	55                   	push   %ebp
  801a8e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	ff 75 10             	pushl  0x10(%ebp)
  801a97:	ff 75 0c             	pushl  0xc(%ebp)
  801a9a:	ff 75 08             	pushl  0x8(%ebp)
  801a9d:	6a 11                	push   $0x11
  801a9f:	e8 7a fe ff ff       	call   80191e <syscall>
  801aa4:	83 c4 18             	add    $0x18,%esp
	return ;
  801aa7:	90                   	nop
}
  801aa8:	c9                   	leave  
  801aa9:	c3                   	ret    

00801aaa <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801aaa:	55                   	push   %ebp
  801aab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 00                	push   $0x0
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 0c                	push   $0xc
  801ab9:	e8 60 fe ff ff       	call   80191e <syscall>
  801abe:	83 c4 18             	add    $0x18,%esp
}
  801ac1:	c9                   	leave  
  801ac2:	c3                   	ret    

00801ac3 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ac3:	55                   	push   %ebp
  801ac4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 00                	push   $0x0
  801acc:	6a 00                	push   $0x0
  801ace:	ff 75 08             	pushl  0x8(%ebp)
  801ad1:	6a 0d                	push   $0xd
  801ad3:	e8 46 fe ff ff       	call   80191e <syscall>
  801ad8:	83 c4 18             	add    $0x18,%esp
}
  801adb:	c9                   	leave  
  801adc:	c3                   	ret    

00801add <sys_scarce_memory>:

void sys_scarce_memory()
{
  801add:	55                   	push   %ebp
  801ade:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 0e                	push   $0xe
  801aec:	e8 2d fe ff ff       	call   80191e <syscall>
  801af1:	83 c4 18             	add    $0x18,%esp
}
  801af4:	90                   	nop
  801af5:	c9                   	leave  
  801af6:	c3                   	ret    

00801af7 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801af7:	55                   	push   %ebp
  801af8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801afa:	6a 00                	push   $0x0
  801afc:	6a 00                	push   $0x0
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	6a 13                	push   $0x13
  801b06:	e8 13 fe ff ff       	call   80191e <syscall>
  801b0b:	83 c4 18             	add    $0x18,%esp
}
  801b0e:	90                   	nop
  801b0f:	c9                   	leave  
  801b10:	c3                   	ret    

00801b11 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801b11:	55                   	push   %ebp
  801b12:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 14                	push   $0x14
  801b20:	e8 f9 fd ff ff       	call   80191e <syscall>
  801b25:	83 c4 18             	add    $0x18,%esp
}
  801b28:	90                   	nop
  801b29:	c9                   	leave  
  801b2a:	c3                   	ret    

00801b2b <sys_cputc>:


void
sys_cputc(const char c)
{
  801b2b:	55                   	push   %ebp
  801b2c:	89 e5                	mov    %esp,%ebp
  801b2e:	83 ec 04             	sub    $0x4,%esp
  801b31:	8b 45 08             	mov    0x8(%ebp),%eax
  801b34:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b37:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 00                	push   $0x0
  801b43:	50                   	push   %eax
  801b44:	6a 15                	push   $0x15
  801b46:	e8 d3 fd ff ff       	call   80191e <syscall>
  801b4b:	83 c4 18             	add    $0x18,%esp
}
  801b4e:	90                   	nop
  801b4f:	c9                   	leave  
  801b50:	c3                   	ret    

00801b51 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b51:	55                   	push   %ebp
  801b52:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b54:	6a 00                	push   $0x0
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 16                	push   $0x16
  801b60:	e8 b9 fd ff ff       	call   80191e <syscall>
  801b65:	83 c4 18             	add    $0x18,%esp
}
  801b68:	90                   	nop
  801b69:	c9                   	leave  
  801b6a:	c3                   	ret    

00801b6b <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801b6b:	55                   	push   %ebp
  801b6c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	6a 00                	push   $0x0
  801b77:	ff 75 0c             	pushl  0xc(%ebp)
  801b7a:	50                   	push   %eax
  801b7b:	6a 17                	push   $0x17
  801b7d:	e8 9c fd ff ff       	call   80191e <syscall>
  801b82:	83 c4 18             	add    $0x18,%esp
}
  801b85:	c9                   	leave  
  801b86:	c3                   	ret    

00801b87 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b87:	55                   	push   %ebp
  801b88:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b8a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	52                   	push   %edx
  801b97:	50                   	push   %eax
  801b98:	6a 1a                	push   $0x1a
  801b9a:	e8 7f fd ff ff       	call   80191e <syscall>
  801b9f:	83 c4 18             	add    $0x18,%esp
}
  801ba2:	c9                   	leave  
  801ba3:	c3                   	ret    

00801ba4 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ba4:	55                   	push   %ebp
  801ba5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ba7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801baa:	8b 45 08             	mov    0x8(%ebp),%eax
  801bad:	6a 00                	push   $0x0
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 00                	push   $0x0
  801bb3:	52                   	push   %edx
  801bb4:	50                   	push   %eax
  801bb5:	6a 18                	push   $0x18
  801bb7:	e8 62 fd ff ff       	call   80191e <syscall>
  801bbc:	83 c4 18             	add    $0x18,%esp
}
  801bbf:	90                   	nop
  801bc0:	c9                   	leave  
  801bc1:	c3                   	ret    

00801bc2 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801bc2:	55                   	push   %ebp
  801bc3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bc5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	52                   	push   %edx
  801bd2:	50                   	push   %eax
  801bd3:	6a 19                	push   $0x19
  801bd5:	e8 44 fd ff ff       	call   80191e <syscall>
  801bda:	83 c4 18             	add    $0x18,%esp
}
  801bdd:	90                   	nop
  801bde:	c9                   	leave  
  801bdf:	c3                   	ret    

00801be0 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801be0:	55                   	push   %ebp
  801be1:	89 e5                	mov    %esp,%ebp
  801be3:	83 ec 04             	sub    $0x4,%esp
  801be6:	8b 45 10             	mov    0x10(%ebp),%eax
  801be9:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801bec:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801bef:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf6:	6a 00                	push   $0x0
  801bf8:	51                   	push   %ecx
  801bf9:	52                   	push   %edx
  801bfa:	ff 75 0c             	pushl  0xc(%ebp)
  801bfd:	50                   	push   %eax
  801bfe:	6a 1b                	push   $0x1b
  801c00:	e8 19 fd ff ff       	call   80191e <syscall>
  801c05:	83 c4 18             	add    $0x18,%esp
}
  801c08:	c9                   	leave  
  801c09:	c3                   	ret    

00801c0a <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801c0a:	55                   	push   %ebp
  801c0b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801c0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c10:	8b 45 08             	mov    0x8(%ebp),%eax
  801c13:	6a 00                	push   $0x0
  801c15:	6a 00                	push   $0x0
  801c17:	6a 00                	push   $0x0
  801c19:	52                   	push   %edx
  801c1a:	50                   	push   %eax
  801c1b:	6a 1c                	push   $0x1c
  801c1d:	e8 fc fc ff ff       	call   80191e <syscall>
  801c22:	83 c4 18             	add    $0x18,%esp
}
  801c25:	c9                   	leave  
  801c26:	c3                   	ret    

00801c27 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801c27:	55                   	push   %ebp
  801c28:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801c2a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c2d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c30:	8b 45 08             	mov    0x8(%ebp),%eax
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	51                   	push   %ecx
  801c38:	52                   	push   %edx
  801c39:	50                   	push   %eax
  801c3a:	6a 1d                	push   $0x1d
  801c3c:	e8 dd fc ff ff       	call   80191e <syscall>
  801c41:	83 c4 18             	add    $0x18,%esp
}
  801c44:	c9                   	leave  
  801c45:	c3                   	ret    

00801c46 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c46:	55                   	push   %ebp
  801c47:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c49:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	52                   	push   %edx
  801c56:	50                   	push   %eax
  801c57:	6a 1e                	push   $0x1e
  801c59:	e8 c0 fc ff ff       	call   80191e <syscall>
  801c5e:	83 c4 18             	add    $0x18,%esp
}
  801c61:	c9                   	leave  
  801c62:	c3                   	ret    

00801c63 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801c63:	55                   	push   %ebp
  801c64:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 1f                	push   $0x1f
  801c72:	e8 a7 fc ff ff       	call   80191e <syscall>
  801c77:	83 c4 18             	add    $0x18,%esp
}
  801c7a:	c9                   	leave  
  801c7b:	c3                   	ret    

00801c7c <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c7c:	55                   	push   %ebp
  801c7d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c82:	6a 00                	push   $0x0
  801c84:	ff 75 14             	pushl  0x14(%ebp)
  801c87:	ff 75 10             	pushl  0x10(%ebp)
  801c8a:	ff 75 0c             	pushl  0xc(%ebp)
  801c8d:	50                   	push   %eax
  801c8e:	6a 20                	push   $0x20
  801c90:	e8 89 fc ff ff       	call   80191e <syscall>
  801c95:	83 c4 18             	add    $0x18,%esp
}
  801c98:	c9                   	leave  
  801c99:	c3                   	ret    

00801c9a <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c9a:	55                   	push   %ebp
  801c9b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	50                   	push   %eax
  801ca9:	6a 21                	push   $0x21
  801cab:	e8 6e fc ff ff       	call   80191e <syscall>
  801cb0:	83 c4 18             	add    $0x18,%esp
}
  801cb3:	90                   	nop
  801cb4:	c9                   	leave  
  801cb5:	c3                   	ret    

00801cb6 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801cb6:	55                   	push   %ebp
  801cb7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 00                	push   $0x0
  801cc4:	50                   	push   %eax
  801cc5:	6a 22                	push   $0x22
  801cc7:	e8 52 fc ff ff       	call   80191e <syscall>
  801ccc:	83 c4 18             	add    $0x18,%esp
}
  801ccf:	c9                   	leave  
  801cd0:	c3                   	ret    

00801cd1 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801cd1:	55                   	push   %ebp
  801cd2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 00                	push   $0x0
  801cdc:	6a 00                	push   $0x0
  801cde:	6a 02                	push   $0x2
  801ce0:	e8 39 fc ff ff       	call   80191e <syscall>
  801ce5:	83 c4 18             	add    $0x18,%esp
}
  801ce8:	c9                   	leave  
  801ce9:	c3                   	ret    

00801cea <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801cea:	55                   	push   %ebp
  801ceb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ced:	6a 00                	push   $0x0
  801cef:	6a 00                	push   $0x0
  801cf1:	6a 00                	push   $0x0
  801cf3:	6a 00                	push   $0x0
  801cf5:	6a 00                	push   $0x0
  801cf7:	6a 03                	push   $0x3
  801cf9:	e8 20 fc ff ff       	call   80191e <syscall>
  801cfe:	83 c4 18             	add    $0x18,%esp
}
  801d01:	c9                   	leave  
  801d02:	c3                   	ret    

00801d03 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801d03:	55                   	push   %ebp
  801d04:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801d06:	6a 00                	push   $0x0
  801d08:	6a 00                	push   $0x0
  801d0a:	6a 00                	push   $0x0
  801d0c:	6a 00                	push   $0x0
  801d0e:	6a 00                	push   $0x0
  801d10:	6a 04                	push   $0x4
  801d12:	e8 07 fc ff ff       	call   80191e <syscall>
  801d17:	83 c4 18             	add    $0x18,%esp
}
  801d1a:	c9                   	leave  
  801d1b:	c3                   	ret    

00801d1c <sys_exit_env>:


void sys_exit_env(void)
{
  801d1c:	55                   	push   %ebp
  801d1d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 00                	push   $0x0
  801d23:	6a 00                	push   $0x0
  801d25:	6a 00                	push   $0x0
  801d27:	6a 00                	push   $0x0
  801d29:	6a 23                	push   $0x23
  801d2b:	e8 ee fb ff ff       	call   80191e <syscall>
  801d30:	83 c4 18             	add    $0x18,%esp
}
  801d33:	90                   	nop
  801d34:	c9                   	leave  
  801d35:	c3                   	ret    

00801d36 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801d36:	55                   	push   %ebp
  801d37:	89 e5                	mov    %esp,%ebp
  801d39:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d3c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d3f:	8d 50 04             	lea    0x4(%eax),%edx
  801d42:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d45:	6a 00                	push   $0x0
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	52                   	push   %edx
  801d4c:	50                   	push   %eax
  801d4d:	6a 24                	push   $0x24
  801d4f:	e8 ca fb ff ff       	call   80191e <syscall>
  801d54:	83 c4 18             	add    $0x18,%esp
	return result;
  801d57:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d5a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d5d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d60:	89 01                	mov    %eax,(%ecx)
  801d62:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d65:	8b 45 08             	mov    0x8(%ebp),%eax
  801d68:	c9                   	leave  
  801d69:	c2 04 00             	ret    $0x4

00801d6c <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d6c:	55                   	push   %ebp
  801d6d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	ff 75 10             	pushl  0x10(%ebp)
  801d76:	ff 75 0c             	pushl  0xc(%ebp)
  801d79:	ff 75 08             	pushl  0x8(%ebp)
  801d7c:	6a 12                	push   $0x12
  801d7e:	e8 9b fb ff ff       	call   80191e <syscall>
  801d83:	83 c4 18             	add    $0x18,%esp
	return ;
  801d86:	90                   	nop
}
  801d87:	c9                   	leave  
  801d88:	c3                   	ret    

00801d89 <sys_rcr2>:
uint32 sys_rcr2()
{
  801d89:	55                   	push   %ebp
  801d8a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d8c:	6a 00                	push   $0x0
  801d8e:	6a 00                	push   $0x0
  801d90:	6a 00                	push   $0x0
  801d92:	6a 00                	push   $0x0
  801d94:	6a 00                	push   $0x0
  801d96:	6a 25                	push   $0x25
  801d98:	e8 81 fb ff ff       	call   80191e <syscall>
  801d9d:	83 c4 18             	add    $0x18,%esp
}
  801da0:	c9                   	leave  
  801da1:	c3                   	ret    

00801da2 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801da2:	55                   	push   %ebp
  801da3:	89 e5                	mov    %esp,%ebp
  801da5:	83 ec 04             	sub    $0x4,%esp
  801da8:	8b 45 08             	mov    0x8(%ebp),%eax
  801dab:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801dae:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801db2:	6a 00                	push   $0x0
  801db4:	6a 00                	push   $0x0
  801db6:	6a 00                	push   $0x0
  801db8:	6a 00                	push   $0x0
  801dba:	50                   	push   %eax
  801dbb:	6a 26                	push   $0x26
  801dbd:	e8 5c fb ff ff       	call   80191e <syscall>
  801dc2:	83 c4 18             	add    $0x18,%esp
	return ;
  801dc5:	90                   	nop
}
  801dc6:	c9                   	leave  
  801dc7:	c3                   	ret    

00801dc8 <rsttst>:
void rsttst()
{
  801dc8:	55                   	push   %ebp
  801dc9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801dcb:	6a 00                	push   $0x0
  801dcd:	6a 00                	push   $0x0
  801dcf:	6a 00                	push   $0x0
  801dd1:	6a 00                	push   $0x0
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 28                	push   $0x28
  801dd7:	e8 42 fb ff ff       	call   80191e <syscall>
  801ddc:	83 c4 18             	add    $0x18,%esp
	return ;
  801ddf:	90                   	nop
}
  801de0:	c9                   	leave  
  801de1:	c3                   	ret    

00801de2 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801de2:	55                   	push   %ebp
  801de3:	89 e5                	mov    %esp,%ebp
  801de5:	83 ec 04             	sub    $0x4,%esp
  801de8:	8b 45 14             	mov    0x14(%ebp),%eax
  801deb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801dee:	8b 55 18             	mov    0x18(%ebp),%edx
  801df1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801df5:	52                   	push   %edx
  801df6:	50                   	push   %eax
  801df7:	ff 75 10             	pushl  0x10(%ebp)
  801dfa:	ff 75 0c             	pushl  0xc(%ebp)
  801dfd:	ff 75 08             	pushl  0x8(%ebp)
  801e00:	6a 27                	push   $0x27
  801e02:	e8 17 fb ff ff       	call   80191e <syscall>
  801e07:	83 c4 18             	add    $0x18,%esp
	return ;
  801e0a:	90                   	nop
}
  801e0b:	c9                   	leave  
  801e0c:	c3                   	ret    

00801e0d <chktst>:
void chktst(uint32 n)
{
  801e0d:	55                   	push   %ebp
  801e0e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801e10:	6a 00                	push   $0x0
  801e12:	6a 00                	push   $0x0
  801e14:	6a 00                	push   $0x0
  801e16:	6a 00                	push   $0x0
  801e18:	ff 75 08             	pushl  0x8(%ebp)
  801e1b:	6a 29                	push   $0x29
  801e1d:	e8 fc fa ff ff       	call   80191e <syscall>
  801e22:	83 c4 18             	add    $0x18,%esp
	return ;
  801e25:	90                   	nop
}
  801e26:	c9                   	leave  
  801e27:	c3                   	ret    

00801e28 <inctst>:

void inctst()
{
  801e28:	55                   	push   %ebp
  801e29:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 00                	push   $0x0
  801e33:	6a 00                	push   $0x0
  801e35:	6a 2a                	push   $0x2a
  801e37:	e8 e2 fa ff ff       	call   80191e <syscall>
  801e3c:	83 c4 18             	add    $0x18,%esp
	return ;
  801e3f:	90                   	nop
}
  801e40:	c9                   	leave  
  801e41:	c3                   	ret    

00801e42 <gettst>:
uint32 gettst()
{
  801e42:	55                   	push   %ebp
  801e43:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e45:	6a 00                	push   $0x0
  801e47:	6a 00                	push   $0x0
  801e49:	6a 00                	push   $0x0
  801e4b:	6a 00                	push   $0x0
  801e4d:	6a 00                	push   $0x0
  801e4f:	6a 2b                	push   $0x2b
  801e51:	e8 c8 fa ff ff       	call   80191e <syscall>
  801e56:	83 c4 18             	add    $0x18,%esp
}
  801e59:	c9                   	leave  
  801e5a:	c3                   	ret    

00801e5b <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e5b:	55                   	push   %ebp
  801e5c:	89 e5                	mov    %esp,%ebp
  801e5e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e61:	6a 00                	push   $0x0
  801e63:	6a 00                	push   $0x0
  801e65:	6a 00                	push   $0x0
  801e67:	6a 00                	push   $0x0
  801e69:	6a 00                	push   $0x0
  801e6b:	6a 2c                	push   $0x2c
  801e6d:	e8 ac fa ff ff       	call   80191e <syscall>
  801e72:	83 c4 18             	add    $0x18,%esp
  801e75:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e78:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e7c:	75 07                	jne    801e85 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e7e:	b8 01 00 00 00       	mov    $0x1,%eax
  801e83:	eb 05                	jmp    801e8a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e85:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e8a:	c9                   	leave  
  801e8b:	c3                   	ret    

00801e8c <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e8c:	55                   	push   %ebp
  801e8d:	89 e5                	mov    %esp,%ebp
  801e8f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e92:	6a 00                	push   $0x0
  801e94:	6a 00                	push   $0x0
  801e96:	6a 00                	push   $0x0
  801e98:	6a 00                	push   $0x0
  801e9a:	6a 00                	push   $0x0
  801e9c:	6a 2c                	push   $0x2c
  801e9e:	e8 7b fa ff ff       	call   80191e <syscall>
  801ea3:	83 c4 18             	add    $0x18,%esp
  801ea6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801ea9:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801ead:	75 07                	jne    801eb6 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801eaf:	b8 01 00 00 00       	mov    $0x1,%eax
  801eb4:	eb 05                	jmp    801ebb <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801eb6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ebb:	c9                   	leave  
  801ebc:	c3                   	ret    

00801ebd <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801ebd:	55                   	push   %ebp
  801ebe:	89 e5                	mov    %esp,%ebp
  801ec0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ec3:	6a 00                	push   $0x0
  801ec5:	6a 00                	push   $0x0
  801ec7:	6a 00                	push   $0x0
  801ec9:	6a 00                	push   $0x0
  801ecb:	6a 00                	push   $0x0
  801ecd:	6a 2c                	push   $0x2c
  801ecf:	e8 4a fa ff ff       	call   80191e <syscall>
  801ed4:	83 c4 18             	add    $0x18,%esp
  801ed7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801eda:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801ede:	75 07                	jne    801ee7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801ee0:	b8 01 00 00 00       	mov    $0x1,%eax
  801ee5:	eb 05                	jmp    801eec <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801ee7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eec:	c9                   	leave  
  801eed:	c3                   	ret    

00801eee <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801eee:	55                   	push   %ebp
  801eef:	89 e5                	mov    %esp,%ebp
  801ef1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ef4:	6a 00                	push   $0x0
  801ef6:	6a 00                	push   $0x0
  801ef8:	6a 00                	push   $0x0
  801efa:	6a 00                	push   $0x0
  801efc:	6a 00                	push   $0x0
  801efe:	6a 2c                	push   $0x2c
  801f00:	e8 19 fa ff ff       	call   80191e <syscall>
  801f05:	83 c4 18             	add    $0x18,%esp
  801f08:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801f0b:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801f0f:	75 07                	jne    801f18 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801f11:	b8 01 00 00 00       	mov    $0x1,%eax
  801f16:	eb 05                	jmp    801f1d <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801f18:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f1d:	c9                   	leave  
  801f1e:	c3                   	ret    

00801f1f <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801f1f:	55                   	push   %ebp
  801f20:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801f22:	6a 00                	push   $0x0
  801f24:	6a 00                	push   $0x0
  801f26:	6a 00                	push   $0x0
  801f28:	6a 00                	push   $0x0
  801f2a:	ff 75 08             	pushl  0x8(%ebp)
  801f2d:	6a 2d                	push   $0x2d
  801f2f:	e8 ea f9 ff ff       	call   80191e <syscall>
  801f34:	83 c4 18             	add    $0x18,%esp
	return ;
  801f37:	90                   	nop
}
  801f38:	c9                   	leave  
  801f39:	c3                   	ret    

00801f3a <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f3a:	55                   	push   %ebp
  801f3b:	89 e5                	mov    %esp,%ebp
  801f3d:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f3e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f41:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f44:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f47:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4a:	6a 00                	push   $0x0
  801f4c:	53                   	push   %ebx
  801f4d:	51                   	push   %ecx
  801f4e:	52                   	push   %edx
  801f4f:	50                   	push   %eax
  801f50:	6a 2e                	push   $0x2e
  801f52:	e8 c7 f9 ff ff       	call   80191e <syscall>
  801f57:	83 c4 18             	add    $0x18,%esp
}
  801f5a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f5d:	c9                   	leave  
  801f5e:	c3                   	ret    

00801f5f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f5f:	55                   	push   %ebp
  801f60:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f62:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f65:	8b 45 08             	mov    0x8(%ebp),%eax
  801f68:	6a 00                	push   $0x0
  801f6a:	6a 00                	push   $0x0
  801f6c:	6a 00                	push   $0x0
  801f6e:	52                   	push   %edx
  801f6f:	50                   	push   %eax
  801f70:	6a 2f                	push   $0x2f
  801f72:	e8 a7 f9 ff ff       	call   80191e <syscall>
  801f77:	83 c4 18             	add    $0x18,%esp
}
  801f7a:	c9                   	leave  
  801f7b:	c3                   	ret    

00801f7c <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801f7c:	55                   	push   %ebp
  801f7d:	89 e5                	mov    %esp,%ebp
  801f7f:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801f82:	83 ec 0c             	sub    $0xc,%esp
  801f85:	68 fc 3e 80 00       	push   $0x803efc
  801f8a:	e8 21 e7 ff ff       	call   8006b0 <cprintf>
  801f8f:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801f92:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801f99:	83 ec 0c             	sub    $0xc,%esp
  801f9c:	68 28 3f 80 00       	push   $0x803f28
  801fa1:	e8 0a e7 ff ff       	call   8006b0 <cprintf>
  801fa6:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801fa9:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801fad:	a1 38 51 80 00       	mov    0x805138,%eax
  801fb2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fb5:	eb 56                	jmp    80200d <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801fb7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fbb:	74 1c                	je     801fd9 <print_mem_block_lists+0x5d>
  801fbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc0:	8b 50 08             	mov    0x8(%eax),%edx
  801fc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fc6:	8b 48 08             	mov    0x8(%eax),%ecx
  801fc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fcc:	8b 40 0c             	mov    0xc(%eax),%eax
  801fcf:	01 c8                	add    %ecx,%eax
  801fd1:	39 c2                	cmp    %eax,%edx
  801fd3:	73 04                	jae    801fd9 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801fd5:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801fd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fdc:	8b 50 08             	mov    0x8(%eax),%edx
  801fdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe2:	8b 40 0c             	mov    0xc(%eax),%eax
  801fe5:	01 c2                	add    %eax,%edx
  801fe7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fea:	8b 40 08             	mov    0x8(%eax),%eax
  801fed:	83 ec 04             	sub    $0x4,%esp
  801ff0:	52                   	push   %edx
  801ff1:	50                   	push   %eax
  801ff2:	68 3d 3f 80 00       	push   $0x803f3d
  801ff7:	e8 b4 e6 ff ff       	call   8006b0 <cprintf>
  801ffc:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802002:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802005:	a1 40 51 80 00       	mov    0x805140,%eax
  80200a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80200d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802011:	74 07                	je     80201a <print_mem_block_lists+0x9e>
  802013:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802016:	8b 00                	mov    (%eax),%eax
  802018:	eb 05                	jmp    80201f <print_mem_block_lists+0xa3>
  80201a:	b8 00 00 00 00       	mov    $0x0,%eax
  80201f:	a3 40 51 80 00       	mov    %eax,0x805140
  802024:	a1 40 51 80 00       	mov    0x805140,%eax
  802029:	85 c0                	test   %eax,%eax
  80202b:	75 8a                	jne    801fb7 <print_mem_block_lists+0x3b>
  80202d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802031:	75 84                	jne    801fb7 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802033:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802037:	75 10                	jne    802049 <print_mem_block_lists+0xcd>
  802039:	83 ec 0c             	sub    $0xc,%esp
  80203c:	68 4c 3f 80 00       	push   $0x803f4c
  802041:	e8 6a e6 ff ff       	call   8006b0 <cprintf>
  802046:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802049:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802050:	83 ec 0c             	sub    $0xc,%esp
  802053:	68 70 3f 80 00       	push   $0x803f70
  802058:	e8 53 e6 ff ff       	call   8006b0 <cprintf>
  80205d:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802060:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802064:	a1 40 50 80 00       	mov    0x805040,%eax
  802069:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80206c:	eb 56                	jmp    8020c4 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80206e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802072:	74 1c                	je     802090 <print_mem_block_lists+0x114>
  802074:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802077:	8b 50 08             	mov    0x8(%eax),%edx
  80207a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80207d:	8b 48 08             	mov    0x8(%eax),%ecx
  802080:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802083:	8b 40 0c             	mov    0xc(%eax),%eax
  802086:	01 c8                	add    %ecx,%eax
  802088:	39 c2                	cmp    %eax,%edx
  80208a:	73 04                	jae    802090 <print_mem_block_lists+0x114>
			sorted = 0 ;
  80208c:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802090:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802093:	8b 50 08             	mov    0x8(%eax),%edx
  802096:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802099:	8b 40 0c             	mov    0xc(%eax),%eax
  80209c:	01 c2                	add    %eax,%edx
  80209e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a1:	8b 40 08             	mov    0x8(%eax),%eax
  8020a4:	83 ec 04             	sub    $0x4,%esp
  8020a7:	52                   	push   %edx
  8020a8:	50                   	push   %eax
  8020a9:	68 3d 3f 80 00       	push   $0x803f3d
  8020ae:	e8 fd e5 ff ff       	call   8006b0 <cprintf>
  8020b3:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8020b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8020bc:	a1 48 50 80 00       	mov    0x805048,%eax
  8020c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020c8:	74 07                	je     8020d1 <print_mem_block_lists+0x155>
  8020ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020cd:	8b 00                	mov    (%eax),%eax
  8020cf:	eb 05                	jmp    8020d6 <print_mem_block_lists+0x15a>
  8020d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8020d6:	a3 48 50 80 00       	mov    %eax,0x805048
  8020db:	a1 48 50 80 00       	mov    0x805048,%eax
  8020e0:	85 c0                	test   %eax,%eax
  8020e2:	75 8a                	jne    80206e <print_mem_block_lists+0xf2>
  8020e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020e8:	75 84                	jne    80206e <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8020ea:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8020ee:	75 10                	jne    802100 <print_mem_block_lists+0x184>
  8020f0:	83 ec 0c             	sub    $0xc,%esp
  8020f3:	68 88 3f 80 00       	push   $0x803f88
  8020f8:	e8 b3 e5 ff ff       	call   8006b0 <cprintf>
  8020fd:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802100:	83 ec 0c             	sub    $0xc,%esp
  802103:	68 fc 3e 80 00       	push   $0x803efc
  802108:	e8 a3 e5 ff ff       	call   8006b0 <cprintf>
  80210d:	83 c4 10             	add    $0x10,%esp

}
  802110:	90                   	nop
  802111:	c9                   	leave  
  802112:	c3                   	ret    

00802113 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802113:	55                   	push   %ebp
  802114:	89 e5                	mov    %esp,%ebp
  802116:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  802119:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802120:	00 00 00 
  802123:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80212a:	00 00 00 
  80212d:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802134:	00 00 00 
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  802137:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80213e:	e9 9e 00 00 00       	jmp    8021e1 <initialize_MemBlocksList+0xce>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
  802143:	a1 50 50 80 00       	mov    0x805050,%eax
  802148:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80214b:	c1 e2 04             	shl    $0x4,%edx
  80214e:	01 d0                	add    %edx,%eax
  802150:	85 c0                	test   %eax,%eax
  802152:	75 14                	jne    802168 <initialize_MemBlocksList+0x55>
  802154:	83 ec 04             	sub    $0x4,%esp
  802157:	68 b0 3f 80 00       	push   $0x803fb0
  80215c:	6a 43                	push   $0x43
  80215e:	68 d3 3f 80 00       	push   $0x803fd3
  802163:	e8 94 e2 ff ff       	call   8003fc <_panic>
  802168:	a1 50 50 80 00       	mov    0x805050,%eax
  80216d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802170:	c1 e2 04             	shl    $0x4,%edx
  802173:	01 d0                	add    %edx,%eax
  802175:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80217b:	89 10                	mov    %edx,(%eax)
  80217d:	8b 00                	mov    (%eax),%eax
  80217f:	85 c0                	test   %eax,%eax
  802181:	74 18                	je     80219b <initialize_MemBlocksList+0x88>
  802183:	a1 48 51 80 00       	mov    0x805148,%eax
  802188:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80218e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802191:	c1 e1 04             	shl    $0x4,%ecx
  802194:	01 ca                	add    %ecx,%edx
  802196:	89 50 04             	mov    %edx,0x4(%eax)
  802199:	eb 12                	jmp    8021ad <initialize_MemBlocksList+0x9a>
  80219b:	a1 50 50 80 00       	mov    0x805050,%eax
  8021a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021a3:	c1 e2 04             	shl    $0x4,%edx
  8021a6:	01 d0                	add    %edx,%eax
  8021a8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8021ad:	a1 50 50 80 00       	mov    0x805050,%eax
  8021b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021b5:	c1 e2 04             	shl    $0x4,%edx
  8021b8:	01 d0                	add    %edx,%eax
  8021ba:	a3 48 51 80 00       	mov    %eax,0x805148
  8021bf:	a1 50 50 80 00       	mov    0x805050,%eax
  8021c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021c7:	c1 e2 04             	shl    $0x4,%edx
  8021ca:	01 d0                	add    %edx,%eax
  8021cc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021d3:	a1 54 51 80 00       	mov    0x805154,%eax
  8021d8:	40                   	inc    %eax
  8021d9:	a3 54 51 80 00       	mov    %eax,0x805154
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  8021de:	ff 45 f4             	incl   -0xc(%ebp)
  8021e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021e7:	0f 82 56 ff ff ff    	jb     802143 <initialize_MemBlocksList+0x30>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
		}
}
  8021ed:	90                   	nop
  8021ee:	c9                   	leave  
  8021ef:	c3                   	ret    

008021f0 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8021f0:	55                   	push   %ebp
  8021f1:	89 e5                	mov    %esp,%ebp
  8021f3:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  8021f6:	a1 38 51 80 00       	mov    0x805138,%eax
  8021fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021fe:	eb 18                	jmp    802218 <find_block+0x28>
	{
		if (ele->sva==va)
  802200:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802203:	8b 40 08             	mov    0x8(%eax),%eax
  802206:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802209:	75 05                	jne    802210 <find_block+0x20>
			return ele;
  80220b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80220e:	eb 7b                	jmp    80228b <find_block+0x9b>
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  802210:	a1 40 51 80 00       	mov    0x805140,%eax
  802215:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802218:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80221c:	74 07                	je     802225 <find_block+0x35>
  80221e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802221:	8b 00                	mov    (%eax),%eax
  802223:	eb 05                	jmp    80222a <find_block+0x3a>
  802225:	b8 00 00 00 00       	mov    $0x0,%eax
  80222a:	a3 40 51 80 00       	mov    %eax,0x805140
  80222f:	a1 40 51 80 00       	mov    0x805140,%eax
  802234:	85 c0                	test   %eax,%eax
  802236:	75 c8                	jne    802200 <find_block+0x10>
  802238:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80223c:	75 c2                	jne    802200 <find_block+0x10>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  80223e:	a1 40 50 80 00       	mov    0x805040,%eax
  802243:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802246:	eb 18                	jmp    802260 <find_block+0x70>
	{
		if (ele->sva==va)
  802248:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80224b:	8b 40 08             	mov    0x8(%eax),%eax
  80224e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802251:	75 05                	jne    802258 <find_block+0x68>
					return ele;
  802253:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802256:	eb 33                	jmp    80228b <find_block+0x9b>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  802258:	a1 48 50 80 00       	mov    0x805048,%eax
  80225d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802260:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802264:	74 07                	je     80226d <find_block+0x7d>
  802266:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802269:	8b 00                	mov    (%eax),%eax
  80226b:	eb 05                	jmp    802272 <find_block+0x82>
  80226d:	b8 00 00 00 00       	mov    $0x0,%eax
  802272:	a3 48 50 80 00       	mov    %eax,0x805048
  802277:	a1 48 50 80 00       	mov    0x805048,%eax
  80227c:	85 c0                	test   %eax,%eax
  80227e:	75 c8                	jne    802248 <find_block+0x58>
  802280:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802284:	75 c2                	jne    802248 <find_block+0x58>
	{
		if (ele->sva==va)
					return ele;
	}
return NULL;
  802286:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  80228b:	c9                   	leave  
  80228c:	c3                   	ret    

0080228d <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80228d:	55                   	push   %ebp
  80228e:	89 e5                	mov    %esp,%ebp
  802290:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;

int x =LIST_SIZE(&AllocMemBlocksList);
  802293:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802298:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((x==0))
  80229b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80229f:	75 62                	jne    802303 <insert_sorted_allocList+0x76>
	{
	//	blockToInsert=AllocMemBlocksList.lh_first;
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  8022a1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022a5:	75 14                	jne    8022bb <insert_sorted_allocList+0x2e>
  8022a7:	83 ec 04             	sub    $0x4,%esp
  8022aa:	68 b0 3f 80 00       	push   $0x803fb0
  8022af:	6a 69                	push   $0x69
  8022b1:	68 d3 3f 80 00       	push   $0x803fd3
  8022b6:	e8 41 e1 ff ff       	call   8003fc <_panic>
  8022bb:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8022c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c4:	89 10                	mov    %edx,(%eax)
  8022c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c9:	8b 00                	mov    (%eax),%eax
  8022cb:	85 c0                	test   %eax,%eax
  8022cd:	74 0d                	je     8022dc <insert_sorted_allocList+0x4f>
  8022cf:	a1 40 50 80 00       	mov    0x805040,%eax
  8022d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8022d7:	89 50 04             	mov    %edx,0x4(%eax)
  8022da:	eb 08                	jmp    8022e4 <insert_sorted_allocList+0x57>
  8022dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022df:	a3 44 50 80 00       	mov    %eax,0x805044
  8022e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e7:	a3 40 50 80 00       	mov    %eax,0x805040
  8022ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022f6:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022fb:	40                   	inc    %eax
  8022fc:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802301:	eb 72                	jmp    802375 <insert_sorted_allocList+0xe8>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
  802303:	a1 40 50 80 00       	mov    0x805040,%eax
  802308:	8b 50 08             	mov    0x8(%eax),%edx
  80230b:	8b 45 08             	mov    0x8(%ebp),%eax
  80230e:	8b 40 08             	mov    0x8(%eax),%eax
  802311:	39 c2                	cmp    %eax,%edx
  802313:	76 60                	jbe    802375 <insert_sorted_allocList+0xe8>
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  802315:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802319:	75 14                	jne    80232f <insert_sorted_allocList+0xa2>
  80231b:	83 ec 04             	sub    $0x4,%esp
  80231e:	68 b0 3f 80 00       	push   $0x803fb0
  802323:	6a 6d                	push   $0x6d
  802325:	68 d3 3f 80 00       	push   $0x803fd3
  80232a:	e8 cd e0 ff ff       	call   8003fc <_panic>
  80232f:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802335:	8b 45 08             	mov    0x8(%ebp),%eax
  802338:	89 10                	mov    %edx,(%eax)
  80233a:	8b 45 08             	mov    0x8(%ebp),%eax
  80233d:	8b 00                	mov    (%eax),%eax
  80233f:	85 c0                	test   %eax,%eax
  802341:	74 0d                	je     802350 <insert_sorted_allocList+0xc3>
  802343:	a1 40 50 80 00       	mov    0x805040,%eax
  802348:	8b 55 08             	mov    0x8(%ebp),%edx
  80234b:	89 50 04             	mov    %edx,0x4(%eax)
  80234e:	eb 08                	jmp    802358 <insert_sorted_allocList+0xcb>
  802350:	8b 45 08             	mov    0x8(%ebp),%eax
  802353:	a3 44 50 80 00       	mov    %eax,0x805044
  802358:	8b 45 08             	mov    0x8(%ebp),%eax
  80235b:	a3 40 50 80 00       	mov    %eax,0x805040
  802360:	8b 45 08             	mov    0x8(%ebp),%eax
  802363:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80236a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80236f:	40                   	inc    %eax
  802370:	a3 4c 50 80 00       	mov    %eax,0x80504c
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  802375:	a1 40 50 80 00       	mov    0x805040,%eax
  80237a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80237d:	e9 b9 01 00 00       	jmp    80253b <insert_sorted_allocList+0x2ae>
	{


		if ((blockToInsert->sva>AllocMemBlocksList.lh_first->sva)&&blockToInsert->sva<element->sva)
  802382:	8b 45 08             	mov    0x8(%ebp),%eax
  802385:	8b 50 08             	mov    0x8(%eax),%edx
  802388:	a1 40 50 80 00       	mov    0x805040,%eax
  80238d:	8b 40 08             	mov    0x8(%eax),%eax
  802390:	39 c2                	cmp    %eax,%edx
  802392:	76 7c                	jbe    802410 <insert_sorted_allocList+0x183>
  802394:	8b 45 08             	mov    0x8(%ebp),%eax
  802397:	8b 50 08             	mov    0x8(%eax),%edx
  80239a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239d:	8b 40 08             	mov    0x8(%eax),%eax
  8023a0:	39 c2                	cmp    %eax,%edx
  8023a2:	73 6c                	jae    802410 <insert_sorted_allocList+0x183>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,element,blockToInsert);
  8023a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023a8:	74 06                	je     8023b0 <insert_sorted_allocList+0x123>
  8023aa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023ae:	75 14                	jne    8023c4 <insert_sorted_allocList+0x137>
  8023b0:	83 ec 04             	sub    $0x4,%esp
  8023b3:	68 ec 3f 80 00       	push   $0x803fec
  8023b8:	6a 75                	push   $0x75
  8023ba:	68 d3 3f 80 00       	push   $0x803fd3
  8023bf:	e8 38 e0 ff ff       	call   8003fc <_panic>
  8023c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c7:	8b 50 04             	mov    0x4(%eax),%edx
  8023ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8023cd:	89 50 04             	mov    %edx,0x4(%eax)
  8023d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023d6:	89 10                	mov    %edx,(%eax)
  8023d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023db:	8b 40 04             	mov    0x4(%eax),%eax
  8023de:	85 c0                	test   %eax,%eax
  8023e0:	74 0d                	je     8023ef <insert_sorted_allocList+0x162>
  8023e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e5:	8b 40 04             	mov    0x4(%eax),%eax
  8023e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8023eb:	89 10                	mov    %edx,(%eax)
  8023ed:	eb 08                	jmp    8023f7 <insert_sorted_allocList+0x16a>
  8023ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f2:	a3 40 50 80 00       	mov    %eax,0x805040
  8023f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8023fd:	89 50 04             	mov    %edx,0x4(%eax)
  802400:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802405:	40                   	inc    %eax
  802406:	a3 4c 50 80 00       	mov    %eax,0x80504c

		break;}
  80240b:	e9 59 01 00 00       	jmp    802569 <insert_sorted_allocList+0x2dc>

	else if ((blockToInsert->sva>element->sva)&&(blockToInsert->sva<AllocMemBlocksList.lh_last->sva)&&blockToInsert->sva<LIST_NEXT(element)->sva)
  802410:	8b 45 08             	mov    0x8(%ebp),%eax
  802413:	8b 50 08             	mov    0x8(%eax),%edx
  802416:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802419:	8b 40 08             	mov    0x8(%eax),%eax
  80241c:	39 c2                	cmp    %eax,%edx
  80241e:	0f 86 98 00 00 00    	jbe    8024bc <insert_sorted_allocList+0x22f>
  802424:	8b 45 08             	mov    0x8(%ebp),%eax
  802427:	8b 50 08             	mov    0x8(%eax),%edx
  80242a:	a1 44 50 80 00       	mov    0x805044,%eax
  80242f:	8b 40 08             	mov    0x8(%eax),%eax
  802432:	39 c2                	cmp    %eax,%edx
  802434:	0f 83 82 00 00 00    	jae    8024bc <insert_sorted_allocList+0x22f>
  80243a:	8b 45 08             	mov    0x8(%ebp),%eax
  80243d:	8b 50 08             	mov    0x8(%eax),%edx
  802440:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802443:	8b 00                	mov    (%eax),%eax
  802445:	8b 40 08             	mov    0x8(%eax),%eax
  802448:	39 c2                	cmp    %eax,%edx
  80244a:	73 70                	jae    8024bc <insert_sorted_allocList+0x22f>
	{

	LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  80244c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802450:	74 06                	je     802458 <insert_sorted_allocList+0x1cb>
  802452:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802456:	75 14                	jne    80246c <insert_sorted_allocList+0x1df>
  802458:	83 ec 04             	sub    $0x4,%esp
  80245b:	68 24 40 80 00       	push   $0x804024
  802460:	6a 7c                	push   $0x7c
  802462:	68 d3 3f 80 00       	push   $0x803fd3
  802467:	e8 90 df ff ff       	call   8003fc <_panic>
  80246c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246f:	8b 10                	mov    (%eax),%edx
  802471:	8b 45 08             	mov    0x8(%ebp),%eax
  802474:	89 10                	mov    %edx,(%eax)
  802476:	8b 45 08             	mov    0x8(%ebp),%eax
  802479:	8b 00                	mov    (%eax),%eax
  80247b:	85 c0                	test   %eax,%eax
  80247d:	74 0b                	je     80248a <insert_sorted_allocList+0x1fd>
  80247f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802482:	8b 00                	mov    (%eax),%eax
  802484:	8b 55 08             	mov    0x8(%ebp),%edx
  802487:	89 50 04             	mov    %edx,0x4(%eax)
  80248a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248d:	8b 55 08             	mov    0x8(%ebp),%edx
  802490:	89 10                	mov    %edx,(%eax)
  802492:	8b 45 08             	mov    0x8(%ebp),%eax
  802495:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802498:	89 50 04             	mov    %edx,0x4(%eax)
  80249b:	8b 45 08             	mov    0x8(%ebp),%eax
  80249e:	8b 00                	mov    (%eax),%eax
  8024a0:	85 c0                	test   %eax,%eax
  8024a2:	75 08                	jne    8024ac <insert_sorted_allocList+0x21f>
  8024a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a7:	a3 44 50 80 00       	mov    %eax,0x805044
  8024ac:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8024b1:	40                   	inc    %eax
  8024b2:	a3 4c 50 80 00       	mov    %eax,0x80504c
		break;
  8024b7:	e9 ad 00 00 00       	jmp    802569 <insert_sorted_allocList+0x2dc>
	}else if (blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  8024bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8024bf:	8b 50 08             	mov    0x8(%eax),%edx
  8024c2:	a1 44 50 80 00       	mov    0x805044,%eax
  8024c7:	8b 40 08             	mov    0x8(%eax),%eax
  8024ca:	39 c2                	cmp    %eax,%edx
  8024cc:	76 65                	jbe    802533 <insert_sorted_allocList+0x2a6>
	{
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
  8024ce:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024d2:	75 17                	jne    8024eb <insert_sorted_allocList+0x25e>
  8024d4:	83 ec 04             	sub    $0x4,%esp
  8024d7:	68 58 40 80 00       	push   $0x804058
  8024dc:	68 80 00 00 00       	push   $0x80
  8024e1:	68 d3 3f 80 00       	push   $0x803fd3
  8024e6:	e8 11 df ff ff       	call   8003fc <_panic>
  8024eb:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8024f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f4:	89 50 04             	mov    %edx,0x4(%eax)
  8024f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8024fa:	8b 40 04             	mov    0x4(%eax),%eax
  8024fd:	85 c0                	test   %eax,%eax
  8024ff:	74 0c                	je     80250d <insert_sorted_allocList+0x280>
  802501:	a1 44 50 80 00       	mov    0x805044,%eax
  802506:	8b 55 08             	mov    0x8(%ebp),%edx
  802509:	89 10                	mov    %edx,(%eax)
  80250b:	eb 08                	jmp    802515 <insert_sorted_allocList+0x288>
  80250d:	8b 45 08             	mov    0x8(%ebp),%eax
  802510:	a3 40 50 80 00       	mov    %eax,0x805040
  802515:	8b 45 08             	mov    0x8(%ebp),%eax
  802518:	a3 44 50 80 00       	mov    %eax,0x805044
  80251d:	8b 45 08             	mov    0x8(%ebp),%eax
  802520:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802526:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80252b:	40                   	inc    %eax
  80252c:	a3 4c 50 80 00       	mov    %eax,0x80504c
		break;
  802531:	eb 36                	jmp    802569 <insert_sorted_allocList+0x2dc>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  802533:	a1 48 50 80 00       	mov    0x805048,%eax
  802538:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80253b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80253f:	74 07                	je     802548 <insert_sorted_allocList+0x2bb>
  802541:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802544:	8b 00                	mov    (%eax),%eax
  802546:	eb 05                	jmp    80254d <insert_sorted_allocList+0x2c0>
  802548:	b8 00 00 00 00       	mov    $0x0,%eax
  80254d:	a3 48 50 80 00       	mov    %eax,0x805048
  802552:	a1 48 50 80 00       	mov    0x805048,%eax
  802557:	85 c0                	test   %eax,%eax
  802559:	0f 85 23 fe ff ff    	jne    802382 <insert_sorted_allocList+0xf5>
  80255f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802563:	0f 85 19 fe ff ff    	jne    802382 <insert_sorted_allocList+0xf5>
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
		break;

	}
	}
}
  802569:	90                   	nop
  80256a:	c9                   	leave  
  80256b:	c3                   	ret    

0080256c <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80256c:	55                   	push   %ebp
  80256d:	89 e5                	mov    %esp,%ebp
  80256f:	83 ec 18             	sub    $0x18,%esp
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802572:	a1 38 51 80 00       	mov    0x805138,%eax
  802577:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80257a:	e9 7c 01 00 00       	jmp    8026fb <alloc_block_FF+0x18f>
		{
			// case 2
				if(element->size == size)
  80257f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802582:	8b 40 0c             	mov    0xc(%eax),%eax
  802585:	3b 45 08             	cmp    0x8(%ebp),%eax
  802588:	0f 85 90 00 00 00    	jne    80261e <alloc_block_FF+0xb2>
				{
					tmp_block=element;
  80258e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802591:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,element);
  802594:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802598:	75 17                	jne    8025b1 <alloc_block_FF+0x45>
  80259a:	83 ec 04             	sub    $0x4,%esp
  80259d:	68 7b 40 80 00       	push   $0x80407b
  8025a2:	68 ba 00 00 00       	push   $0xba
  8025a7:	68 d3 3f 80 00       	push   $0x803fd3
  8025ac:	e8 4b de ff ff       	call   8003fc <_panic>
  8025b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b4:	8b 00                	mov    (%eax),%eax
  8025b6:	85 c0                	test   %eax,%eax
  8025b8:	74 10                	je     8025ca <alloc_block_FF+0x5e>
  8025ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bd:	8b 00                	mov    (%eax),%eax
  8025bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025c2:	8b 52 04             	mov    0x4(%edx),%edx
  8025c5:	89 50 04             	mov    %edx,0x4(%eax)
  8025c8:	eb 0b                	jmp    8025d5 <alloc_block_FF+0x69>
  8025ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cd:	8b 40 04             	mov    0x4(%eax),%eax
  8025d0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8025d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d8:	8b 40 04             	mov    0x4(%eax),%eax
  8025db:	85 c0                	test   %eax,%eax
  8025dd:	74 0f                	je     8025ee <alloc_block_FF+0x82>
  8025df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e2:	8b 40 04             	mov    0x4(%eax),%eax
  8025e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025e8:	8b 12                	mov    (%edx),%edx
  8025ea:	89 10                	mov    %edx,(%eax)
  8025ec:	eb 0a                	jmp    8025f8 <alloc_block_FF+0x8c>
  8025ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f1:	8b 00                	mov    (%eax),%eax
  8025f3:	a3 38 51 80 00       	mov    %eax,0x805138
  8025f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802601:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802604:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80260b:	a1 44 51 80 00       	mov    0x805144,%eax
  802610:	48                   	dec    %eax
  802611:	a3 44 51 80 00       	mov    %eax,0x805144
					return tmp_block;
  802616:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802619:	e9 10 01 00 00       	jmp    80272e <alloc_block_FF+0x1c2>
				}
				 // case 3
				else if(element->size > size)
  80261e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802621:	8b 40 0c             	mov    0xc(%eax),%eax
  802624:	3b 45 08             	cmp    0x8(%ebp),%eax
  802627:	0f 86 c6 00 00 00    	jbe    8026f3 <alloc_block_FF+0x187>
				{
					// the new block are created
					tmp_block = AvailableMemBlocksList.lh_first ;
  80262d:	a1 48 51 80 00       	mov    0x805148,%eax
  802632:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  802635:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802639:	75 17                	jne    802652 <alloc_block_FF+0xe6>
  80263b:	83 ec 04             	sub    $0x4,%esp
  80263e:	68 7b 40 80 00       	push   $0x80407b
  802643:	68 c2 00 00 00       	push   $0xc2
  802648:	68 d3 3f 80 00       	push   $0x803fd3
  80264d:	e8 aa dd ff ff       	call   8003fc <_panic>
  802652:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802655:	8b 00                	mov    (%eax),%eax
  802657:	85 c0                	test   %eax,%eax
  802659:	74 10                	je     80266b <alloc_block_FF+0xff>
  80265b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80265e:	8b 00                	mov    (%eax),%eax
  802660:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802663:	8b 52 04             	mov    0x4(%edx),%edx
  802666:	89 50 04             	mov    %edx,0x4(%eax)
  802669:	eb 0b                	jmp    802676 <alloc_block_FF+0x10a>
  80266b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80266e:	8b 40 04             	mov    0x4(%eax),%eax
  802671:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802676:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802679:	8b 40 04             	mov    0x4(%eax),%eax
  80267c:	85 c0                	test   %eax,%eax
  80267e:	74 0f                	je     80268f <alloc_block_FF+0x123>
  802680:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802683:	8b 40 04             	mov    0x4(%eax),%eax
  802686:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802689:	8b 12                	mov    (%edx),%edx
  80268b:	89 10                	mov    %edx,(%eax)
  80268d:	eb 0a                	jmp    802699 <alloc_block_FF+0x12d>
  80268f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802692:	8b 00                	mov    (%eax),%eax
  802694:	a3 48 51 80 00       	mov    %eax,0x805148
  802699:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80269c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026a5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026ac:	a1 54 51 80 00       	mov    0x805154,%eax
  8026b1:	48                   	dec    %eax
  8026b2:	a3 54 51 80 00       	mov    %eax,0x805154
					tmp_block->sva=element->sva;
  8026b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ba:	8b 50 08             	mov    0x8(%eax),%edx
  8026bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026c0:	89 50 08             	mov    %edx,0x8(%eax)
					tmp_block->size=size;
  8026c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8026c9:	89 50 0c             	mov    %edx,0xc(%eax)
					//update block with remaining space
					element->size-=size;
  8026cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8026d2:	2b 45 08             	sub    0x8(%ebp),%eax
  8026d5:	89 c2                	mov    %eax,%edx
  8026d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026da:	89 50 0c             	mov    %edx,0xc(%eax)
					element->sva = element->sva + size;
  8026dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e0:	8b 50 08             	mov    0x8(%eax),%edx
  8026e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e6:	01 c2                	add    %eax,%edx
  8026e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026eb:	89 50 08             	mov    %edx,0x8(%eax)
					// return back the new block
					return tmp_block ;
  8026ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026f1:	eb 3b                	jmp    80272e <alloc_block_FF+0x1c2>
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  8026f3:	a1 40 51 80 00       	mov    0x805140,%eax
  8026f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026ff:	74 07                	je     802708 <alloc_block_FF+0x19c>
  802701:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802704:	8b 00                	mov    (%eax),%eax
  802706:	eb 05                	jmp    80270d <alloc_block_FF+0x1a1>
  802708:	b8 00 00 00 00       	mov    $0x0,%eax
  80270d:	a3 40 51 80 00       	mov    %eax,0x805140
  802712:	a1 40 51 80 00       	mov    0x805140,%eax
  802717:	85 c0                	test   %eax,%eax
  802719:	0f 85 60 fe ff ff    	jne    80257f <alloc_block_FF+0x13>
  80271f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802723:	0f 85 56 fe ff ff    	jne    80257f <alloc_block_FF+0x13>
					// return back the new block
					return tmp_block ;
				}
		}
		// case 1
	  return NULL ;}
  802729:	b8 00 00 00 00       	mov    $0x0,%eax
  80272e:	c9                   	leave  
  80272f:	c3                   	ret    

00802730 <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================

struct MemBlock *alloc_block_BF(uint32 size)
{
  802730:	55                   	push   %ebp
  802731:	89 e5                	mov    %esp,%ebp
  802733:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
  802736:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		LIST_FOREACH(element, &(FreeMemBlocksList))
  80273d:	a1 38 51 80 00       	mov    0x805138,%eax
  802742:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802745:	eb 3a                	jmp    802781 <alloc_block_BF+0x51>
		{
			if(element->size >= size)
  802747:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274a:	8b 40 0c             	mov    0xc(%eax),%eax
  80274d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802750:	72 27                	jb     802779 <alloc_block_BF+0x49>
			{
				if(best_size==-1)
  802752:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802756:	75 0b                	jne    802763 <alloc_block_BF+0x33>
					best_size= element->size;
  802758:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275b:	8b 40 0c             	mov    0xc(%eax),%eax
  80275e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802761:	eb 16                	jmp    802779 <alloc_block_BF+0x49>
				else if(best_size >= element->size)
  802763:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802766:	8b 50 0c             	mov    0xc(%eax),%edx
  802769:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80276c:	39 c2                	cmp    %eax,%edx
  80276e:	77 09                	ja     802779 <alloc_block_BF+0x49>
					best_size=element->size;
  802770:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802773:	8b 40 0c             	mov    0xc(%eax),%eax
  802776:	89 45 f0             	mov    %eax,-0x10(%ebp)

struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802779:	a1 40 51 80 00       	mov    0x805140,%eax
  80277e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802781:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802785:	74 07                	je     80278e <alloc_block_BF+0x5e>
  802787:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278a:	8b 00                	mov    (%eax),%eax
  80278c:	eb 05                	jmp    802793 <alloc_block_BF+0x63>
  80278e:	b8 00 00 00 00       	mov    $0x0,%eax
  802793:	a3 40 51 80 00       	mov    %eax,0x805140
  802798:	a1 40 51 80 00       	mov    0x805140,%eax
  80279d:	85 c0                	test   %eax,%eax
  80279f:	75 a6                	jne    802747 <alloc_block_BF+0x17>
  8027a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027a5:	75 a0                	jne    802747 <alloc_block_BF+0x17>
					best_size= element->size;
				else if(best_size >= element->size)
					best_size=element->size;
			}
		}
		if(best_size != -1)
  8027a7:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8027ab:	0f 84 d3 01 00 00    	je     802984 <alloc_block_BF+0x254>
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  8027b1:	a1 38 51 80 00       	mov    0x805138,%eax
  8027b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027b9:	e9 98 01 00 00       	jmp    802956 <alloc_block_BF+0x226>
			{
			 if((best_size > size) && (best_size == element->size))
  8027be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027c4:	0f 86 da 00 00 00    	jbe    8028a4 <alloc_block_BF+0x174>
  8027ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cd:	8b 50 0c             	mov    0xc(%eax),%edx
  8027d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d3:	39 c2                	cmp    %eax,%edx
  8027d5:	0f 85 c9 00 00 00    	jne    8028a4 <alloc_block_BF+0x174>
			  {
				// the new block are created
			    tmp_block = AvailableMemBlocksList.lh_first ;
  8027db:	a1 48 51 80 00       	mov    0x805148,%eax
  8027e0:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  8027e3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8027e7:	75 17                	jne    802800 <alloc_block_BF+0xd0>
  8027e9:	83 ec 04             	sub    $0x4,%esp
  8027ec:	68 7b 40 80 00       	push   $0x80407b
  8027f1:	68 ea 00 00 00       	push   $0xea
  8027f6:	68 d3 3f 80 00       	push   $0x803fd3
  8027fb:	e8 fc db ff ff       	call   8003fc <_panic>
  802800:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802803:	8b 00                	mov    (%eax),%eax
  802805:	85 c0                	test   %eax,%eax
  802807:	74 10                	je     802819 <alloc_block_BF+0xe9>
  802809:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80280c:	8b 00                	mov    (%eax),%eax
  80280e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802811:	8b 52 04             	mov    0x4(%edx),%edx
  802814:	89 50 04             	mov    %edx,0x4(%eax)
  802817:	eb 0b                	jmp    802824 <alloc_block_BF+0xf4>
  802819:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80281c:	8b 40 04             	mov    0x4(%eax),%eax
  80281f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802824:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802827:	8b 40 04             	mov    0x4(%eax),%eax
  80282a:	85 c0                	test   %eax,%eax
  80282c:	74 0f                	je     80283d <alloc_block_BF+0x10d>
  80282e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802831:	8b 40 04             	mov    0x4(%eax),%eax
  802834:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802837:	8b 12                	mov    (%edx),%edx
  802839:	89 10                	mov    %edx,(%eax)
  80283b:	eb 0a                	jmp    802847 <alloc_block_BF+0x117>
  80283d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802840:	8b 00                	mov    (%eax),%eax
  802842:	a3 48 51 80 00       	mov    %eax,0x805148
  802847:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80284a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802850:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802853:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80285a:	a1 54 51 80 00       	mov    0x805154,%eax
  80285f:	48                   	dec    %eax
  802860:	a3 54 51 80 00       	mov    %eax,0x805154
				tmp_block->sva=element->sva;
  802865:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802868:	8b 50 08             	mov    0x8(%eax),%edx
  80286b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80286e:	89 50 08             	mov    %edx,0x8(%eax)
				tmp_block->size=size;
  802871:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802874:	8b 55 08             	mov    0x8(%ebp),%edx
  802877:	89 50 0c             	mov    %edx,0xc(%eax)
				//update block with remaining space
				element->size-=size;
  80287a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287d:	8b 40 0c             	mov    0xc(%eax),%eax
  802880:	2b 45 08             	sub    0x8(%ebp),%eax
  802883:	89 c2                	mov    %eax,%edx
  802885:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802888:	89 50 0c             	mov    %edx,0xc(%eax)
				element->sva = element->sva + size;
  80288b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288e:	8b 50 08             	mov    0x8(%eax),%edx
  802891:	8b 45 08             	mov    0x8(%ebp),%eax
  802894:	01 c2                	add    %eax,%edx
  802896:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802899:	89 50 08             	mov    %edx,0x8(%eax)
				// return back the new block
				return tmp_block ;
  80289c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80289f:	e9 e5 00 00 00       	jmp    802989 <alloc_block_BF+0x259>

			  }
			else if((element->size == best_size)&&(best_size == size))
  8028a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a7:	8b 50 0c             	mov    0xc(%eax),%edx
  8028aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ad:	39 c2                	cmp    %eax,%edx
  8028af:	0f 85 99 00 00 00    	jne    80294e <alloc_block_BF+0x21e>
  8028b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028bb:	0f 85 8d 00 00 00    	jne    80294e <alloc_block_BF+0x21e>
			  {
				tmp_block=element;
  8028c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&FreeMemBlocksList,element);
  8028c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028cb:	75 17                	jne    8028e4 <alloc_block_BF+0x1b4>
  8028cd:	83 ec 04             	sub    $0x4,%esp
  8028d0:	68 7b 40 80 00       	push   $0x80407b
  8028d5:	68 f7 00 00 00       	push   $0xf7
  8028da:	68 d3 3f 80 00       	push   $0x803fd3
  8028df:	e8 18 db ff ff       	call   8003fc <_panic>
  8028e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e7:	8b 00                	mov    (%eax),%eax
  8028e9:	85 c0                	test   %eax,%eax
  8028eb:	74 10                	je     8028fd <alloc_block_BF+0x1cd>
  8028ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f0:	8b 00                	mov    (%eax),%eax
  8028f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028f5:	8b 52 04             	mov    0x4(%edx),%edx
  8028f8:	89 50 04             	mov    %edx,0x4(%eax)
  8028fb:	eb 0b                	jmp    802908 <alloc_block_BF+0x1d8>
  8028fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802900:	8b 40 04             	mov    0x4(%eax),%eax
  802903:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802908:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290b:	8b 40 04             	mov    0x4(%eax),%eax
  80290e:	85 c0                	test   %eax,%eax
  802910:	74 0f                	je     802921 <alloc_block_BF+0x1f1>
  802912:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802915:	8b 40 04             	mov    0x4(%eax),%eax
  802918:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80291b:	8b 12                	mov    (%edx),%edx
  80291d:	89 10                	mov    %edx,(%eax)
  80291f:	eb 0a                	jmp    80292b <alloc_block_BF+0x1fb>
  802921:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802924:	8b 00                	mov    (%eax),%eax
  802926:	a3 38 51 80 00       	mov    %eax,0x805138
  80292b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802934:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802937:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80293e:	a1 44 51 80 00       	mov    0x805144,%eax
  802943:	48                   	dec    %eax
  802944:	a3 44 51 80 00       	mov    %eax,0x805144
				return tmp_block;
  802949:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80294c:	eb 3b                	jmp    802989 <alloc_block_BF+0x259>
					best_size=element->size;
			}
		}
		if(best_size != -1)
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  80294e:	a1 40 51 80 00       	mov    0x805140,%eax
  802953:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802956:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80295a:	74 07                	je     802963 <alloc_block_BF+0x233>
  80295c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295f:	8b 00                	mov    (%eax),%eax
  802961:	eb 05                	jmp    802968 <alloc_block_BF+0x238>
  802963:	b8 00 00 00 00       	mov    $0x0,%eax
  802968:	a3 40 51 80 00       	mov    %eax,0x805140
  80296d:	a1 40 51 80 00       	mov    0x805140,%eax
  802972:	85 c0                	test   %eax,%eax
  802974:	0f 85 44 fe ff ff    	jne    8027be <alloc_block_BF+0x8e>
  80297a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80297e:	0f 85 3a fe ff ff    	jne    8027be <alloc_block_BF+0x8e>
				LIST_REMOVE(&FreeMemBlocksList,element);
				return tmp_block;
			 }
			}
		}
		return NULL ;}
  802984:	b8 00 00 00 00       	mov    $0x0,%eax
  802989:	c9                   	leave  
  80298a:	c3                   	ret    

0080298b <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  80298b:	55                   	push   %ebp
  80298c:	89 e5                	mov    %esp,%ebp
  80298e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802991:	83 ec 04             	sub    $0x4,%esp
  802994:	68 9c 40 80 00       	push   $0x80409c
  802999:	68 04 01 00 00       	push   $0x104
  80299e:	68 d3 3f 80 00       	push   $0x803fd3
  8029a3:	e8 54 da ff ff       	call   8003fc <_panic>

008029a8 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{struct MemBlock * blk_itr;
  8029a8:	55                   	push   %ebp
  8029a9:	89 e5                	mov    %esp,%ebp
  8029ab:	83 ec 18             	sub    $0x18,%esp
struct MemBlock * next;
struct MemBlock * first = LIST_FIRST(&(FreeMemBlocksList));
  8029ae:	a1 38 51 80 00       	mov    0x805138,%eax
  8029b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
struct MemBlock * last = LIST_LAST(&(FreeMemBlocksList));
  8029b6:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8029bb:	89 45 ec             	mov    %eax,-0x14(%ebp)

if(LIST_EMPTY(&(FreeMemBlocksList)))
  8029be:	a1 38 51 80 00       	mov    0x805138,%eax
  8029c3:	85 c0                	test   %eax,%eax
  8029c5:	75 68                	jne    802a2f <insert_sorted_with_merge_freeList+0x87>
			{

				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  8029c7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029cb:	75 17                	jne    8029e4 <insert_sorted_with_merge_freeList+0x3c>
  8029cd:	83 ec 04             	sub    $0x4,%esp
  8029d0:	68 b0 3f 80 00       	push   $0x803fb0
  8029d5:	68 14 01 00 00       	push   $0x114
  8029da:	68 d3 3f 80 00       	push   $0x803fd3
  8029df:	e8 18 da ff ff       	call   8003fc <_panic>
  8029e4:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8029ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ed:	89 10                	mov    %edx,(%eax)
  8029ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f2:	8b 00                	mov    (%eax),%eax
  8029f4:	85 c0                	test   %eax,%eax
  8029f6:	74 0d                	je     802a05 <insert_sorted_with_merge_freeList+0x5d>
  8029f8:	a1 38 51 80 00       	mov    0x805138,%eax
  8029fd:	8b 55 08             	mov    0x8(%ebp),%edx
  802a00:	89 50 04             	mov    %edx,0x4(%eax)
  802a03:	eb 08                	jmp    802a0d <insert_sorted_with_merge_freeList+0x65>
  802a05:	8b 45 08             	mov    0x8(%ebp),%eax
  802a08:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a10:	a3 38 51 80 00       	mov    %eax,0x805138
  802a15:	8b 45 08             	mov    0x8(%ebp),%eax
  802a18:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a1f:	a1 44 51 80 00       	mov    0x805144,%eax
  802a24:	40                   	inc    %eax
  802a25:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  802a2a:	e9 d2 06 00 00       	jmp    803101 <insert_sorted_with_merge_freeList+0x759>
				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);

			}
else
{
	if( blockToInsert->sva  < first->sva )
  802a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a32:	8b 50 08             	mov    0x8(%eax),%edx
  802a35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a38:	8b 40 08             	mov    0x8(%eax),%eax
  802a3b:	39 c2                	cmp    %eax,%edx
  802a3d:	0f 83 22 01 00 00    	jae    802b65 <insert_sorted_with_merge_freeList+0x1bd>
	{
                if( blockToInsert->sva + blockToInsert->size == first->sva)
  802a43:	8b 45 08             	mov    0x8(%ebp),%eax
  802a46:	8b 50 08             	mov    0x8(%eax),%edx
  802a49:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4c:	8b 40 0c             	mov    0xc(%eax),%eax
  802a4f:	01 c2                	add    %eax,%edx
  802a51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a54:	8b 40 08             	mov    0x8(%eax),%eax
  802a57:	39 c2                	cmp    %eax,%edx
  802a59:	0f 85 9e 00 00 00    	jne    802afd <insert_sorted_with_merge_freeList+0x155>
                {

                	first->sva = blockToInsert->sva;
  802a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a62:	8b 50 08             	mov    0x8(%eax),%edx
  802a65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a68:	89 50 08             	mov    %edx,0x8(%eax)
                	first->size = first->size + blockToInsert->size;
  802a6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a6e:	8b 50 0c             	mov    0xc(%eax),%edx
  802a71:	8b 45 08             	mov    0x8(%ebp),%eax
  802a74:	8b 40 0c             	mov    0xc(%eax),%eax
  802a77:	01 c2                	add    %eax,%edx
  802a79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a7c:	89 50 0c             	mov    %edx,0xc(%eax)
                	blockToInsert->size = blockToInsert->sva = 0;
  802a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a82:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802a89:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8c:	8b 50 08             	mov    0x8(%eax),%edx
  802a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a92:	89 50 0c             	mov    %edx,0xc(%eax)
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802a95:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a99:	75 17                	jne    802ab2 <insert_sorted_with_merge_freeList+0x10a>
  802a9b:	83 ec 04             	sub    $0x4,%esp
  802a9e:	68 b0 3f 80 00       	push   $0x803fb0
  802aa3:	68 21 01 00 00       	push   $0x121
  802aa8:	68 d3 3f 80 00       	push   $0x803fd3
  802aad:	e8 4a d9 ff ff       	call   8003fc <_panic>
  802ab2:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  802abb:	89 10                	mov    %edx,(%eax)
  802abd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac0:	8b 00                	mov    (%eax),%eax
  802ac2:	85 c0                	test   %eax,%eax
  802ac4:	74 0d                	je     802ad3 <insert_sorted_with_merge_freeList+0x12b>
  802ac6:	a1 48 51 80 00       	mov    0x805148,%eax
  802acb:	8b 55 08             	mov    0x8(%ebp),%edx
  802ace:	89 50 04             	mov    %edx,0x4(%eax)
  802ad1:	eb 08                	jmp    802adb <insert_sorted_with_merge_freeList+0x133>
  802ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802adb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ade:	a3 48 51 80 00       	mov    %eax,0x805148
  802ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aed:	a1 54 51 80 00       	mov    0x805154,%eax
  802af2:	40                   	inc    %eax
  802af3:	a3 54 51 80 00       	mov    %eax,0x805154
						}
				}
        }

}
}
  802af8:	e9 04 06 00 00       	jmp    803101 <insert_sorted_with_merge_freeList+0x759>
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
                }

                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  802afd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b01:	75 17                	jne    802b1a <insert_sorted_with_merge_freeList+0x172>
  802b03:	83 ec 04             	sub    $0x4,%esp
  802b06:	68 b0 3f 80 00       	push   $0x803fb0
  802b0b:	68 26 01 00 00       	push   $0x126
  802b10:	68 d3 3f 80 00       	push   $0x803fd3
  802b15:	e8 e2 d8 ff ff       	call   8003fc <_panic>
  802b1a:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802b20:	8b 45 08             	mov    0x8(%ebp),%eax
  802b23:	89 10                	mov    %edx,(%eax)
  802b25:	8b 45 08             	mov    0x8(%ebp),%eax
  802b28:	8b 00                	mov    (%eax),%eax
  802b2a:	85 c0                	test   %eax,%eax
  802b2c:	74 0d                	je     802b3b <insert_sorted_with_merge_freeList+0x193>
  802b2e:	a1 38 51 80 00       	mov    0x805138,%eax
  802b33:	8b 55 08             	mov    0x8(%ebp),%edx
  802b36:	89 50 04             	mov    %edx,0x4(%eax)
  802b39:	eb 08                	jmp    802b43 <insert_sorted_with_merge_freeList+0x19b>
  802b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b43:	8b 45 08             	mov    0x8(%ebp),%eax
  802b46:	a3 38 51 80 00       	mov    %eax,0x805138
  802b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b55:	a1 44 51 80 00       	mov    0x805144,%eax
  802b5a:	40                   	inc    %eax
  802b5b:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  802b60:	e9 9c 05 00 00       	jmp    803101 <insert_sorted_with_merge_freeList+0x759>
                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
                }
	}
    else if(blockToInsert->sva > last->sva)
  802b65:	8b 45 08             	mov    0x8(%ebp),%eax
  802b68:	8b 50 08             	mov    0x8(%eax),%edx
  802b6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b6e:	8b 40 08             	mov    0x8(%eax),%eax
  802b71:	39 c2                	cmp    %eax,%edx
  802b73:	0f 86 16 01 00 00    	jbe    802c8f <insert_sorted_with_merge_freeList+0x2e7>
 	{

				if(last->sva + last->size == blockToInsert->sva)
  802b79:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b7c:	8b 50 08             	mov    0x8(%eax),%edx
  802b7f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b82:	8b 40 0c             	mov    0xc(%eax),%eax
  802b85:	01 c2                	add    %eax,%edx
  802b87:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8a:	8b 40 08             	mov    0x8(%eax),%eax
  802b8d:	39 c2                	cmp    %eax,%edx
  802b8f:	0f 85 92 00 00 00    	jne    802c27 <insert_sorted_with_merge_freeList+0x27f>
				{

					last->size = last->size + blockToInsert->size;
  802b95:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b98:	8b 50 0c             	mov    0xc(%eax),%edx
  802b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9e:	8b 40 0c             	mov    0xc(%eax),%eax
  802ba1:	01 c2                	add    %eax,%edx
  802ba3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ba6:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->size = blockToInsert->sva = 0;
  802ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bac:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb6:	8b 50 08             	mov    0x8(%eax),%edx
  802bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbc:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802bbf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bc3:	75 17                	jne    802bdc <insert_sorted_with_merge_freeList+0x234>
  802bc5:	83 ec 04             	sub    $0x4,%esp
  802bc8:	68 b0 3f 80 00       	push   $0x803fb0
  802bcd:	68 31 01 00 00       	push   $0x131
  802bd2:	68 d3 3f 80 00       	push   $0x803fd3
  802bd7:	e8 20 d8 ff ff       	call   8003fc <_panic>
  802bdc:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802be2:	8b 45 08             	mov    0x8(%ebp),%eax
  802be5:	89 10                	mov    %edx,(%eax)
  802be7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bea:	8b 00                	mov    (%eax),%eax
  802bec:	85 c0                	test   %eax,%eax
  802bee:	74 0d                	je     802bfd <insert_sorted_with_merge_freeList+0x255>
  802bf0:	a1 48 51 80 00       	mov    0x805148,%eax
  802bf5:	8b 55 08             	mov    0x8(%ebp),%edx
  802bf8:	89 50 04             	mov    %edx,0x4(%eax)
  802bfb:	eb 08                	jmp    802c05 <insert_sorted_with_merge_freeList+0x25d>
  802bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  802c00:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c05:	8b 45 08             	mov    0x8(%ebp),%eax
  802c08:	a3 48 51 80 00       	mov    %eax,0x805148
  802c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c10:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c17:	a1 54 51 80 00       	mov    0x805154,%eax
  802c1c:	40                   	inc    %eax
  802c1d:	a3 54 51 80 00       	mov    %eax,0x805154
						}
				}
        }

}
}
  802c22:	e9 da 04 00 00       	jmp    803101 <insert_sorted_with_merge_freeList+0x759>

				}

				else
				{
					LIST_INSERT_TAIL(&(FreeMemBlocksList),  blockToInsert);
  802c27:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c2b:	75 17                	jne    802c44 <insert_sorted_with_merge_freeList+0x29c>
  802c2d:	83 ec 04             	sub    $0x4,%esp
  802c30:	68 58 40 80 00       	push   $0x804058
  802c35:	68 37 01 00 00       	push   $0x137
  802c3a:	68 d3 3f 80 00       	push   $0x803fd3
  802c3f:	e8 b8 d7 ff ff       	call   8003fc <_panic>
  802c44:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4d:	89 50 04             	mov    %edx,0x4(%eax)
  802c50:	8b 45 08             	mov    0x8(%ebp),%eax
  802c53:	8b 40 04             	mov    0x4(%eax),%eax
  802c56:	85 c0                	test   %eax,%eax
  802c58:	74 0c                	je     802c66 <insert_sorted_with_merge_freeList+0x2be>
  802c5a:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802c5f:	8b 55 08             	mov    0x8(%ebp),%edx
  802c62:	89 10                	mov    %edx,(%eax)
  802c64:	eb 08                	jmp    802c6e <insert_sorted_with_merge_freeList+0x2c6>
  802c66:	8b 45 08             	mov    0x8(%ebp),%eax
  802c69:	a3 38 51 80 00       	mov    %eax,0x805138
  802c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c71:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c76:	8b 45 08             	mov    0x8(%ebp),%eax
  802c79:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c7f:	a1 44 51 80 00       	mov    0x805144,%eax
  802c84:	40                   	inc    %eax
  802c85:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  802c8a:	e9 72 04 00 00       	jmp    803101 <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  802c8f:	a1 38 51 80 00       	mov    0x805138,%eax
  802c94:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c97:	e9 35 04 00 00       	jmp    8030d1 <insert_sorted_with_merge_freeList+0x729>
				{
				     next=LIST_NEXT(blk_itr);
  802c9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9f:	8b 00                	mov    (%eax),%eax
  802ca1:	89 45 e8             	mov    %eax,-0x18(%ebp)


					if( (blockToInsert->sva > blk_itr->sva) )
  802ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca7:	8b 50 08             	mov    0x8(%eax),%edx
  802caa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cad:	8b 40 08             	mov    0x8(%eax),%eax
  802cb0:	39 c2                	cmp    %eax,%edx
  802cb2:	0f 86 11 04 00 00    	jbe    8030c9 <insert_sorted_with_merge_freeList+0x721>
						{
							if(((blk_itr->sva) + (blk_itr->size) < blockToInsert->sva && (blockToInsert->sva) + (blockToInsert->size) < next->sva))
  802cb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbb:	8b 50 08             	mov    0x8(%eax),%edx
  802cbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc1:	8b 40 0c             	mov    0xc(%eax),%eax
  802cc4:	01 c2                	add    %eax,%edx
  802cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc9:	8b 40 08             	mov    0x8(%eax),%eax
  802ccc:	39 c2                	cmp    %eax,%edx
  802cce:	0f 83 8b 00 00 00    	jae    802d5f <insert_sorted_with_merge_freeList+0x3b7>
  802cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd7:	8b 50 08             	mov    0x8(%eax),%edx
  802cda:	8b 45 08             	mov    0x8(%ebp),%eax
  802cdd:	8b 40 0c             	mov    0xc(%eax),%eax
  802ce0:	01 c2                	add    %eax,%edx
  802ce2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ce5:	8b 40 08             	mov    0x8(%eax),%eax
  802ce8:	39 c2                	cmp    %eax,%edx
  802cea:	73 73                	jae    802d5f <insert_sorted_with_merge_freeList+0x3b7>
							{
								LIST_INSERT_AFTER(&(FreeMemBlocksList), blk_itr, blockToInsert);
  802cec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cf0:	74 06                	je     802cf8 <insert_sorted_with_merge_freeList+0x350>
  802cf2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cf6:	75 17                	jne    802d0f <insert_sorted_with_merge_freeList+0x367>
  802cf8:	83 ec 04             	sub    $0x4,%esp
  802cfb:	68 24 40 80 00       	push   $0x804024
  802d00:	68 48 01 00 00       	push   $0x148
  802d05:	68 d3 3f 80 00       	push   $0x803fd3
  802d0a:	e8 ed d6 ff ff       	call   8003fc <_panic>
  802d0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d12:	8b 10                	mov    (%eax),%edx
  802d14:	8b 45 08             	mov    0x8(%ebp),%eax
  802d17:	89 10                	mov    %edx,(%eax)
  802d19:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1c:	8b 00                	mov    (%eax),%eax
  802d1e:	85 c0                	test   %eax,%eax
  802d20:	74 0b                	je     802d2d <insert_sorted_with_merge_freeList+0x385>
  802d22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d25:	8b 00                	mov    (%eax),%eax
  802d27:	8b 55 08             	mov    0x8(%ebp),%edx
  802d2a:	89 50 04             	mov    %edx,0x4(%eax)
  802d2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d30:	8b 55 08             	mov    0x8(%ebp),%edx
  802d33:	89 10                	mov    %edx,(%eax)
  802d35:	8b 45 08             	mov    0x8(%ebp),%eax
  802d38:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d3b:	89 50 04             	mov    %edx,0x4(%eax)
  802d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d41:	8b 00                	mov    (%eax),%eax
  802d43:	85 c0                	test   %eax,%eax
  802d45:	75 08                	jne    802d4f <insert_sorted_with_merge_freeList+0x3a7>
  802d47:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d4f:	a1 44 51 80 00       	mov    0x805144,%eax
  802d54:	40                   	inc    %eax
  802d55:	a3 44 51 80 00       	mov    %eax,0x805144
								break;
  802d5a:	e9 a2 03 00 00       	jmp    803101 <insert_sorted_with_merge_freeList+0x759>

							}
							else if((blockToInsert->sva + blockToInsert->size) < next->sva  && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  802d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d62:	8b 50 08             	mov    0x8(%eax),%edx
  802d65:	8b 45 08             	mov    0x8(%ebp),%eax
  802d68:	8b 40 0c             	mov    0xc(%eax),%eax
  802d6b:	01 c2                	add    %eax,%edx
  802d6d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d70:	8b 40 08             	mov    0x8(%eax),%eax
  802d73:	39 c2                	cmp    %eax,%edx
  802d75:	0f 83 ae 00 00 00    	jae    802e29 <insert_sorted_with_merge_freeList+0x481>
  802d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7e:	8b 50 08             	mov    0x8(%eax),%edx
  802d81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d84:	8b 48 08             	mov    0x8(%eax),%ecx
  802d87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8a:	8b 40 0c             	mov    0xc(%eax),%eax
  802d8d:	01 c8                	add    %ecx,%eax
  802d8f:	39 c2                	cmp    %eax,%edx
  802d91:	0f 85 92 00 00 00    	jne    802e29 <insert_sorted_with_merge_freeList+0x481>
							{

								blk_itr->size=blk_itr->size+blockToInsert->size;
  802d97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9a:	8b 50 0c             	mov    0xc(%eax),%edx
  802d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802da0:	8b 40 0c             	mov    0xc(%eax),%eax
  802da3:	01 c2                	add    %eax,%edx
  802da5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da8:	89 50 0c             	mov    %edx,0xc(%eax)
								 blockToInsert->size=blockToInsert->sva=0;
  802dab:	8b 45 08             	mov    0x8(%ebp),%eax
  802dae:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802db5:	8b 45 08             	mov    0x8(%ebp),%eax
  802db8:	8b 50 08             	mov    0x8(%eax),%edx
  802dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbe:	89 50 0c             	mov    %edx,0xc(%eax)
								 LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802dc1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dc5:	75 17                	jne    802dde <insert_sorted_with_merge_freeList+0x436>
  802dc7:	83 ec 04             	sub    $0x4,%esp
  802dca:	68 b0 3f 80 00       	push   $0x803fb0
  802dcf:	68 51 01 00 00       	push   $0x151
  802dd4:	68 d3 3f 80 00       	push   $0x803fd3
  802dd9:	e8 1e d6 ff ff       	call   8003fc <_panic>
  802dde:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802de4:	8b 45 08             	mov    0x8(%ebp),%eax
  802de7:	89 10                	mov    %edx,(%eax)
  802de9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dec:	8b 00                	mov    (%eax),%eax
  802dee:	85 c0                	test   %eax,%eax
  802df0:	74 0d                	je     802dff <insert_sorted_with_merge_freeList+0x457>
  802df2:	a1 48 51 80 00       	mov    0x805148,%eax
  802df7:	8b 55 08             	mov    0x8(%ebp),%edx
  802dfa:	89 50 04             	mov    %edx,0x4(%eax)
  802dfd:	eb 08                	jmp    802e07 <insert_sorted_with_merge_freeList+0x45f>
  802dff:	8b 45 08             	mov    0x8(%ebp),%eax
  802e02:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e07:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0a:	a3 48 51 80 00       	mov    %eax,0x805148
  802e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e12:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e19:	a1 54 51 80 00       	mov    0x805154,%eax
  802e1e:	40                   	inc    %eax
  802e1f:	a3 54 51 80 00       	mov    %eax,0x805154
								 break;
  802e24:	e9 d8 02 00 00       	jmp    803101 <insert_sorted_with_merge_freeList+0x759>

							}
							else if( (blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva > (blk_itr->sva + blk_itr->size))
  802e29:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2c:	8b 50 08             	mov    0x8(%eax),%edx
  802e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e32:	8b 40 0c             	mov    0xc(%eax),%eax
  802e35:	01 c2                	add    %eax,%edx
  802e37:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e3a:	8b 40 08             	mov    0x8(%eax),%eax
  802e3d:	39 c2                	cmp    %eax,%edx
  802e3f:	0f 85 ba 00 00 00    	jne    802eff <insert_sorted_with_merge_freeList+0x557>
  802e45:	8b 45 08             	mov    0x8(%ebp),%eax
  802e48:	8b 50 08             	mov    0x8(%eax),%edx
  802e4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4e:	8b 48 08             	mov    0x8(%eax),%ecx
  802e51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e54:	8b 40 0c             	mov    0xc(%eax),%eax
  802e57:	01 c8                	add    %ecx,%eax
  802e59:	39 c2                	cmp    %eax,%edx
  802e5b:	0f 86 9e 00 00 00    	jbe    802eff <insert_sorted_with_merge_freeList+0x557>
							{
								next->size = next->size + blockToInsert->size;
  802e61:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e64:	8b 50 0c             	mov    0xc(%eax),%edx
  802e67:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6a:	8b 40 0c             	mov    0xc(%eax),%eax
  802e6d:	01 c2                	add    %eax,%edx
  802e6f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e72:	89 50 0c             	mov    %edx,0xc(%eax)
								next->sva = blockToInsert->sva;
  802e75:	8b 45 08             	mov    0x8(%ebp),%eax
  802e78:	8b 50 08             	mov    0x8(%eax),%edx
  802e7b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e7e:	89 50 08             	mov    %edx,0x8(%eax)

								blockToInsert->size = blockToInsert->sva = 0;
  802e81:	8b 45 08             	mov    0x8(%ebp),%eax
  802e84:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8e:	8b 50 08             	mov    0x8(%eax),%edx
  802e91:	8b 45 08             	mov    0x8(%ebp),%eax
  802e94:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802e97:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e9b:	75 17                	jne    802eb4 <insert_sorted_with_merge_freeList+0x50c>
  802e9d:	83 ec 04             	sub    $0x4,%esp
  802ea0:	68 b0 3f 80 00       	push   $0x803fb0
  802ea5:	68 5b 01 00 00       	push   $0x15b
  802eaa:	68 d3 3f 80 00       	push   $0x803fd3
  802eaf:	e8 48 d5 ff ff       	call   8003fc <_panic>
  802eb4:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802eba:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebd:	89 10                	mov    %edx,(%eax)
  802ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec2:	8b 00                	mov    (%eax),%eax
  802ec4:	85 c0                	test   %eax,%eax
  802ec6:	74 0d                	je     802ed5 <insert_sorted_with_merge_freeList+0x52d>
  802ec8:	a1 48 51 80 00       	mov    0x805148,%eax
  802ecd:	8b 55 08             	mov    0x8(%ebp),%edx
  802ed0:	89 50 04             	mov    %edx,0x4(%eax)
  802ed3:	eb 08                	jmp    802edd <insert_sorted_with_merge_freeList+0x535>
  802ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802edd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee0:	a3 48 51 80 00       	mov    %eax,0x805148
  802ee5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eef:	a1 54 51 80 00       	mov    0x805154,%eax
  802ef4:	40                   	inc    %eax
  802ef5:	a3 54 51 80 00       	mov    %eax,0x805154
								break;
  802efa:	e9 02 02 00 00       	jmp    803101 <insert_sorted_with_merge_freeList+0x759>
							}
							else if ((blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  802eff:	8b 45 08             	mov    0x8(%ebp),%eax
  802f02:	8b 50 08             	mov    0x8(%eax),%edx
  802f05:	8b 45 08             	mov    0x8(%ebp),%eax
  802f08:	8b 40 0c             	mov    0xc(%eax),%eax
  802f0b:	01 c2                	add    %eax,%edx
  802f0d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f10:	8b 40 08             	mov    0x8(%eax),%eax
  802f13:	39 c2                	cmp    %eax,%edx
  802f15:	0f 85 ae 01 00 00    	jne    8030c9 <insert_sorted_with_merge_freeList+0x721>
  802f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1e:	8b 50 08             	mov    0x8(%eax),%edx
  802f21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f24:	8b 48 08             	mov    0x8(%eax),%ecx
  802f27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2a:	8b 40 0c             	mov    0xc(%eax),%eax
  802f2d:	01 c8                	add    %ecx,%eax
  802f2f:	39 c2                	cmp    %eax,%edx
  802f31:	0f 85 92 01 00 00    	jne    8030c9 <insert_sorted_with_merge_freeList+0x721>
							{
								blk_itr->size = blk_itr->size + blockToInsert->size + next->size;
  802f37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3a:	8b 50 0c             	mov    0xc(%eax),%edx
  802f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f40:	8b 40 0c             	mov    0xc(%eax),%eax
  802f43:	01 c2                	add    %eax,%edx
  802f45:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f48:	8b 40 0c             	mov    0xc(%eax),%eax
  802f4b:	01 c2                	add    %eax,%edx
  802f4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f50:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size = blockToInsert->sva=0;
  802f53:	8b 45 08             	mov    0x8(%ebp),%eax
  802f56:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f60:	8b 50 08             	mov    0x8(%eax),%edx
  802f63:	8b 45 08             	mov    0x8(%ebp),%eax
  802f66:	89 50 0c             	mov    %edx,0xc(%eax)
								next->size = next->sva = 0;
  802f69:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f6c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802f73:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f76:	8b 50 08             	mov    0x8(%eax),%edx
  802f79:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f7c:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_REMOVE(&FreeMemBlocksList, next);
  802f7f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f83:	75 17                	jne    802f9c <insert_sorted_with_merge_freeList+0x5f4>
  802f85:	83 ec 04             	sub    $0x4,%esp
  802f88:	68 7b 40 80 00       	push   $0x80407b
  802f8d:	68 63 01 00 00       	push   $0x163
  802f92:	68 d3 3f 80 00       	push   $0x803fd3
  802f97:	e8 60 d4 ff ff       	call   8003fc <_panic>
  802f9c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f9f:	8b 00                	mov    (%eax),%eax
  802fa1:	85 c0                	test   %eax,%eax
  802fa3:	74 10                	je     802fb5 <insert_sorted_with_merge_freeList+0x60d>
  802fa5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fa8:	8b 00                	mov    (%eax),%eax
  802faa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fad:	8b 52 04             	mov    0x4(%edx),%edx
  802fb0:	89 50 04             	mov    %edx,0x4(%eax)
  802fb3:	eb 0b                	jmp    802fc0 <insert_sorted_with_merge_freeList+0x618>
  802fb5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fb8:	8b 40 04             	mov    0x4(%eax),%eax
  802fbb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fc0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fc3:	8b 40 04             	mov    0x4(%eax),%eax
  802fc6:	85 c0                	test   %eax,%eax
  802fc8:	74 0f                	je     802fd9 <insert_sorted_with_merge_freeList+0x631>
  802fca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fcd:	8b 40 04             	mov    0x4(%eax),%eax
  802fd0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fd3:	8b 12                	mov    (%edx),%edx
  802fd5:	89 10                	mov    %edx,(%eax)
  802fd7:	eb 0a                	jmp    802fe3 <insert_sorted_with_merge_freeList+0x63b>
  802fd9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fdc:	8b 00                	mov    (%eax),%eax
  802fde:	a3 38 51 80 00       	mov    %eax,0x805138
  802fe3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fe6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ff6:	a1 44 51 80 00       	mov    0x805144,%eax
  802ffb:	48                   	dec    %eax
  802ffc:	a3 44 51 80 00       	mov    %eax,0x805144
								LIST_INSERT_HEAD(&AvailableMemBlocksList, next );
  803001:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803005:	75 17                	jne    80301e <insert_sorted_with_merge_freeList+0x676>
  803007:	83 ec 04             	sub    $0x4,%esp
  80300a:	68 b0 3f 80 00       	push   $0x803fb0
  80300f:	68 64 01 00 00       	push   $0x164
  803014:	68 d3 3f 80 00       	push   $0x803fd3
  803019:	e8 de d3 ff ff       	call   8003fc <_panic>
  80301e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803024:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803027:	89 10                	mov    %edx,(%eax)
  803029:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80302c:	8b 00                	mov    (%eax),%eax
  80302e:	85 c0                	test   %eax,%eax
  803030:	74 0d                	je     80303f <insert_sorted_with_merge_freeList+0x697>
  803032:	a1 48 51 80 00       	mov    0x805148,%eax
  803037:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80303a:	89 50 04             	mov    %edx,0x4(%eax)
  80303d:	eb 08                	jmp    803047 <insert_sorted_with_merge_freeList+0x69f>
  80303f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803042:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803047:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80304a:	a3 48 51 80 00       	mov    %eax,0x805148
  80304f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803052:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803059:	a1 54 51 80 00       	mov    0x805154,%eax
  80305e:	40                   	inc    %eax
  80305f:	a3 54 51 80 00       	mov    %eax,0x805154
							    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  803064:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803068:	75 17                	jne    803081 <insert_sorted_with_merge_freeList+0x6d9>
  80306a:	83 ec 04             	sub    $0x4,%esp
  80306d:	68 b0 3f 80 00       	push   $0x803fb0
  803072:	68 65 01 00 00       	push   $0x165
  803077:	68 d3 3f 80 00       	push   $0x803fd3
  80307c:	e8 7b d3 ff ff       	call   8003fc <_panic>
  803081:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803087:	8b 45 08             	mov    0x8(%ebp),%eax
  80308a:	89 10                	mov    %edx,(%eax)
  80308c:	8b 45 08             	mov    0x8(%ebp),%eax
  80308f:	8b 00                	mov    (%eax),%eax
  803091:	85 c0                	test   %eax,%eax
  803093:	74 0d                	je     8030a2 <insert_sorted_with_merge_freeList+0x6fa>
  803095:	a1 48 51 80 00       	mov    0x805148,%eax
  80309a:	8b 55 08             	mov    0x8(%ebp),%edx
  80309d:	89 50 04             	mov    %edx,0x4(%eax)
  8030a0:	eb 08                	jmp    8030aa <insert_sorted_with_merge_freeList+0x702>
  8030a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ad:	a3 48 51 80 00       	mov    %eax,0x805148
  8030b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030bc:	a1 54 51 80 00       	mov    0x805154,%eax
  8030c1:	40                   	inc    %eax
  8030c2:	a3 54 51 80 00       	mov    %eax,0x805154
								break;
  8030c7:	eb 38                	jmp    803101 <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  8030c9:	a1 40 51 80 00       	mov    0x805140,%eax
  8030ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030d5:	74 07                	je     8030de <insert_sorted_with_merge_freeList+0x736>
  8030d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030da:	8b 00                	mov    (%eax),%eax
  8030dc:	eb 05                	jmp    8030e3 <insert_sorted_with_merge_freeList+0x73b>
  8030de:	b8 00 00 00 00       	mov    $0x0,%eax
  8030e3:	a3 40 51 80 00       	mov    %eax,0x805140
  8030e8:	a1 40 51 80 00       	mov    0x805140,%eax
  8030ed:	85 c0                	test   %eax,%eax
  8030ef:	0f 85 a7 fb ff ff    	jne    802c9c <insert_sorted_with_merge_freeList+0x2f4>
  8030f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030f9:	0f 85 9d fb ff ff    	jne    802c9c <insert_sorted_with_merge_freeList+0x2f4>
						}
				}
        }

}
}
  8030ff:	eb 00                	jmp    803101 <insert_sorted_with_merge_freeList+0x759>
  803101:	90                   	nop
  803102:	c9                   	leave  
  803103:	c3                   	ret    

00803104 <__udivdi3>:
  803104:	55                   	push   %ebp
  803105:	57                   	push   %edi
  803106:	56                   	push   %esi
  803107:	53                   	push   %ebx
  803108:	83 ec 1c             	sub    $0x1c,%esp
  80310b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80310f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803113:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803117:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80311b:	89 ca                	mov    %ecx,%edx
  80311d:	89 f8                	mov    %edi,%eax
  80311f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803123:	85 f6                	test   %esi,%esi
  803125:	75 2d                	jne    803154 <__udivdi3+0x50>
  803127:	39 cf                	cmp    %ecx,%edi
  803129:	77 65                	ja     803190 <__udivdi3+0x8c>
  80312b:	89 fd                	mov    %edi,%ebp
  80312d:	85 ff                	test   %edi,%edi
  80312f:	75 0b                	jne    80313c <__udivdi3+0x38>
  803131:	b8 01 00 00 00       	mov    $0x1,%eax
  803136:	31 d2                	xor    %edx,%edx
  803138:	f7 f7                	div    %edi
  80313a:	89 c5                	mov    %eax,%ebp
  80313c:	31 d2                	xor    %edx,%edx
  80313e:	89 c8                	mov    %ecx,%eax
  803140:	f7 f5                	div    %ebp
  803142:	89 c1                	mov    %eax,%ecx
  803144:	89 d8                	mov    %ebx,%eax
  803146:	f7 f5                	div    %ebp
  803148:	89 cf                	mov    %ecx,%edi
  80314a:	89 fa                	mov    %edi,%edx
  80314c:	83 c4 1c             	add    $0x1c,%esp
  80314f:	5b                   	pop    %ebx
  803150:	5e                   	pop    %esi
  803151:	5f                   	pop    %edi
  803152:	5d                   	pop    %ebp
  803153:	c3                   	ret    
  803154:	39 ce                	cmp    %ecx,%esi
  803156:	77 28                	ja     803180 <__udivdi3+0x7c>
  803158:	0f bd fe             	bsr    %esi,%edi
  80315b:	83 f7 1f             	xor    $0x1f,%edi
  80315e:	75 40                	jne    8031a0 <__udivdi3+0x9c>
  803160:	39 ce                	cmp    %ecx,%esi
  803162:	72 0a                	jb     80316e <__udivdi3+0x6a>
  803164:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803168:	0f 87 9e 00 00 00    	ja     80320c <__udivdi3+0x108>
  80316e:	b8 01 00 00 00       	mov    $0x1,%eax
  803173:	89 fa                	mov    %edi,%edx
  803175:	83 c4 1c             	add    $0x1c,%esp
  803178:	5b                   	pop    %ebx
  803179:	5e                   	pop    %esi
  80317a:	5f                   	pop    %edi
  80317b:	5d                   	pop    %ebp
  80317c:	c3                   	ret    
  80317d:	8d 76 00             	lea    0x0(%esi),%esi
  803180:	31 ff                	xor    %edi,%edi
  803182:	31 c0                	xor    %eax,%eax
  803184:	89 fa                	mov    %edi,%edx
  803186:	83 c4 1c             	add    $0x1c,%esp
  803189:	5b                   	pop    %ebx
  80318a:	5e                   	pop    %esi
  80318b:	5f                   	pop    %edi
  80318c:	5d                   	pop    %ebp
  80318d:	c3                   	ret    
  80318e:	66 90                	xchg   %ax,%ax
  803190:	89 d8                	mov    %ebx,%eax
  803192:	f7 f7                	div    %edi
  803194:	31 ff                	xor    %edi,%edi
  803196:	89 fa                	mov    %edi,%edx
  803198:	83 c4 1c             	add    $0x1c,%esp
  80319b:	5b                   	pop    %ebx
  80319c:	5e                   	pop    %esi
  80319d:	5f                   	pop    %edi
  80319e:	5d                   	pop    %ebp
  80319f:	c3                   	ret    
  8031a0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8031a5:	89 eb                	mov    %ebp,%ebx
  8031a7:	29 fb                	sub    %edi,%ebx
  8031a9:	89 f9                	mov    %edi,%ecx
  8031ab:	d3 e6                	shl    %cl,%esi
  8031ad:	89 c5                	mov    %eax,%ebp
  8031af:	88 d9                	mov    %bl,%cl
  8031b1:	d3 ed                	shr    %cl,%ebp
  8031b3:	89 e9                	mov    %ebp,%ecx
  8031b5:	09 f1                	or     %esi,%ecx
  8031b7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8031bb:	89 f9                	mov    %edi,%ecx
  8031bd:	d3 e0                	shl    %cl,%eax
  8031bf:	89 c5                	mov    %eax,%ebp
  8031c1:	89 d6                	mov    %edx,%esi
  8031c3:	88 d9                	mov    %bl,%cl
  8031c5:	d3 ee                	shr    %cl,%esi
  8031c7:	89 f9                	mov    %edi,%ecx
  8031c9:	d3 e2                	shl    %cl,%edx
  8031cb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031cf:	88 d9                	mov    %bl,%cl
  8031d1:	d3 e8                	shr    %cl,%eax
  8031d3:	09 c2                	or     %eax,%edx
  8031d5:	89 d0                	mov    %edx,%eax
  8031d7:	89 f2                	mov    %esi,%edx
  8031d9:	f7 74 24 0c          	divl   0xc(%esp)
  8031dd:	89 d6                	mov    %edx,%esi
  8031df:	89 c3                	mov    %eax,%ebx
  8031e1:	f7 e5                	mul    %ebp
  8031e3:	39 d6                	cmp    %edx,%esi
  8031e5:	72 19                	jb     803200 <__udivdi3+0xfc>
  8031e7:	74 0b                	je     8031f4 <__udivdi3+0xf0>
  8031e9:	89 d8                	mov    %ebx,%eax
  8031eb:	31 ff                	xor    %edi,%edi
  8031ed:	e9 58 ff ff ff       	jmp    80314a <__udivdi3+0x46>
  8031f2:	66 90                	xchg   %ax,%ax
  8031f4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8031f8:	89 f9                	mov    %edi,%ecx
  8031fa:	d3 e2                	shl    %cl,%edx
  8031fc:	39 c2                	cmp    %eax,%edx
  8031fe:	73 e9                	jae    8031e9 <__udivdi3+0xe5>
  803200:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803203:	31 ff                	xor    %edi,%edi
  803205:	e9 40 ff ff ff       	jmp    80314a <__udivdi3+0x46>
  80320a:	66 90                	xchg   %ax,%ax
  80320c:	31 c0                	xor    %eax,%eax
  80320e:	e9 37 ff ff ff       	jmp    80314a <__udivdi3+0x46>
  803213:	90                   	nop

00803214 <__umoddi3>:
  803214:	55                   	push   %ebp
  803215:	57                   	push   %edi
  803216:	56                   	push   %esi
  803217:	53                   	push   %ebx
  803218:	83 ec 1c             	sub    $0x1c,%esp
  80321b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80321f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803223:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803227:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80322b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80322f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803233:	89 f3                	mov    %esi,%ebx
  803235:	89 fa                	mov    %edi,%edx
  803237:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80323b:	89 34 24             	mov    %esi,(%esp)
  80323e:	85 c0                	test   %eax,%eax
  803240:	75 1a                	jne    80325c <__umoddi3+0x48>
  803242:	39 f7                	cmp    %esi,%edi
  803244:	0f 86 a2 00 00 00    	jbe    8032ec <__umoddi3+0xd8>
  80324a:	89 c8                	mov    %ecx,%eax
  80324c:	89 f2                	mov    %esi,%edx
  80324e:	f7 f7                	div    %edi
  803250:	89 d0                	mov    %edx,%eax
  803252:	31 d2                	xor    %edx,%edx
  803254:	83 c4 1c             	add    $0x1c,%esp
  803257:	5b                   	pop    %ebx
  803258:	5e                   	pop    %esi
  803259:	5f                   	pop    %edi
  80325a:	5d                   	pop    %ebp
  80325b:	c3                   	ret    
  80325c:	39 f0                	cmp    %esi,%eax
  80325e:	0f 87 ac 00 00 00    	ja     803310 <__umoddi3+0xfc>
  803264:	0f bd e8             	bsr    %eax,%ebp
  803267:	83 f5 1f             	xor    $0x1f,%ebp
  80326a:	0f 84 ac 00 00 00    	je     80331c <__umoddi3+0x108>
  803270:	bf 20 00 00 00       	mov    $0x20,%edi
  803275:	29 ef                	sub    %ebp,%edi
  803277:	89 fe                	mov    %edi,%esi
  803279:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80327d:	89 e9                	mov    %ebp,%ecx
  80327f:	d3 e0                	shl    %cl,%eax
  803281:	89 d7                	mov    %edx,%edi
  803283:	89 f1                	mov    %esi,%ecx
  803285:	d3 ef                	shr    %cl,%edi
  803287:	09 c7                	or     %eax,%edi
  803289:	89 e9                	mov    %ebp,%ecx
  80328b:	d3 e2                	shl    %cl,%edx
  80328d:	89 14 24             	mov    %edx,(%esp)
  803290:	89 d8                	mov    %ebx,%eax
  803292:	d3 e0                	shl    %cl,%eax
  803294:	89 c2                	mov    %eax,%edx
  803296:	8b 44 24 08          	mov    0x8(%esp),%eax
  80329a:	d3 e0                	shl    %cl,%eax
  80329c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8032a0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032a4:	89 f1                	mov    %esi,%ecx
  8032a6:	d3 e8                	shr    %cl,%eax
  8032a8:	09 d0                	or     %edx,%eax
  8032aa:	d3 eb                	shr    %cl,%ebx
  8032ac:	89 da                	mov    %ebx,%edx
  8032ae:	f7 f7                	div    %edi
  8032b0:	89 d3                	mov    %edx,%ebx
  8032b2:	f7 24 24             	mull   (%esp)
  8032b5:	89 c6                	mov    %eax,%esi
  8032b7:	89 d1                	mov    %edx,%ecx
  8032b9:	39 d3                	cmp    %edx,%ebx
  8032bb:	0f 82 87 00 00 00    	jb     803348 <__umoddi3+0x134>
  8032c1:	0f 84 91 00 00 00    	je     803358 <__umoddi3+0x144>
  8032c7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8032cb:	29 f2                	sub    %esi,%edx
  8032cd:	19 cb                	sbb    %ecx,%ebx
  8032cf:	89 d8                	mov    %ebx,%eax
  8032d1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8032d5:	d3 e0                	shl    %cl,%eax
  8032d7:	89 e9                	mov    %ebp,%ecx
  8032d9:	d3 ea                	shr    %cl,%edx
  8032db:	09 d0                	or     %edx,%eax
  8032dd:	89 e9                	mov    %ebp,%ecx
  8032df:	d3 eb                	shr    %cl,%ebx
  8032e1:	89 da                	mov    %ebx,%edx
  8032e3:	83 c4 1c             	add    $0x1c,%esp
  8032e6:	5b                   	pop    %ebx
  8032e7:	5e                   	pop    %esi
  8032e8:	5f                   	pop    %edi
  8032e9:	5d                   	pop    %ebp
  8032ea:	c3                   	ret    
  8032eb:	90                   	nop
  8032ec:	89 fd                	mov    %edi,%ebp
  8032ee:	85 ff                	test   %edi,%edi
  8032f0:	75 0b                	jne    8032fd <__umoddi3+0xe9>
  8032f2:	b8 01 00 00 00       	mov    $0x1,%eax
  8032f7:	31 d2                	xor    %edx,%edx
  8032f9:	f7 f7                	div    %edi
  8032fb:	89 c5                	mov    %eax,%ebp
  8032fd:	89 f0                	mov    %esi,%eax
  8032ff:	31 d2                	xor    %edx,%edx
  803301:	f7 f5                	div    %ebp
  803303:	89 c8                	mov    %ecx,%eax
  803305:	f7 f5                	div    %ebp
  803307:	89 d0                	mov    %edx,%eax
  803309:	e9 44 ff ff ff       	jmp    803252 <__umoddi3+0x3e>
  80330e:	66 90                	xchg   %ax,%ax
  803310:	89 c8                	mov    %ecx,%eax
  803312:	89 f2                	mov    %esi,%edx
  803314:	83 c4 1c             	add    $0x1c,%esp
  803317:	5b                   	pop    %ebx
  803318:	5e                   	pop    %esi
  803319:	5f                   	pop    %edi
  80331a:	5d                   	pop    %ebp
  80331b:	c3                   	ret    
  80331c:	3b 04 24             	cmp    (%esp),%eax
  80331f:	72 06                	jb     803327 <__umoddi3+0x113>
  803321:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803325:	77 0f                	ja     803336 <__umoddi3+0x122>
  803327:	89 f2                	mov    %esi,%edx
  803329:	29 f9                	sub    %edi,%ecx
  80332b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80332f:	89 14 24             	mov    %edx,(%esp)
  803332:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803336:	8b 44 24 04          	mov    0x4(%esp),%eax
  80333a:	8b 14 24             	mov    (%esp),%edx
  80333d:	83 c4 1c             	add    $0x1c,%esp
  803340:	5b                   	pop    %ebx
  803341:	5e                   	pop    %esi
  803342:	5f                   	pop    %edi
  803343:	5d                   	pop    %ebp
  803344:	c3                   	ret    
  803345:	8d 76 00             	lea    0x0(%esi),%esi
  803348:	2b 04 24             	sub    (%esp),%eax
  80334b:	19 fa                	sbb    %edi,%edx
  80334d:	89 d1                	mov    %edx,%ecx
  80334f:	89 c6                	mov    %eax,%esi
  803351:	e9 71 ff ff ff       	jmp    8032c7 <__umoddi3+0xb3>
  803356:	66 90                	xchg   %ax,%ax
  803358:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80335c:	72 ea                	jb     803348 <__umoddi3+0x134>
  80335e:	89 d9                	mov    %ebx,%ecx
  803360:	e9 62 ff ff ff       	jmp    8032c7 <__umoddi3+0xb3>
