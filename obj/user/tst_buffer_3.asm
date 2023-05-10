
obj/user/tst_buffer_3:     file format elf32-i386


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
  800031:	e8 82 02 00 00       	call   8002b8 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* *********************************************************** */

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 44             	sub    $0x44,%esp
//		if( ROUNDDOWN(myEnv->__uptr_pws[9].virtual_address,PAGE_SIZE) !=   0x803000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
//		if( ROUNDDOWN(myEnv->__uptr_pws[10].virtual_address,PAGE_SIZE) !=   0x804000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
//		if( ROUNDDOWN(myEnv->__uptr_pws[11].virtual_address,PAGE_SIZE) !=   0xeebfd000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
//		if( myEnv->page_last_WS_index !=  0)  										panic("INITIAL PAGE WS last index checking failed! Review size of the WS..!!");
	}
	int kilo = 1024;
  80003f:	c7 45 ec 00 04 00 00 	movl   $0x400,-0x14(%ebp)
	int Mega = 1024*1024;
  800046:	c7 45 e8 00 00 10 00 	movl   $0x100000,-0x18(%ebp)

	{
		int freeFrames = sys_calculate_free_frames() ;
  80004d:	e8 b0 19 00 00       	call   801a02 <sys_calculate_free_frames>
  800052:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int origFreeFrames = freeFrames ;
  800055:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800058:	89 45 e0             	mov    %eax,-0x20(%ebp)

		uint32 size = 10*Mega;
  80005b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80005e:	89 d0                	mov    %edx,%eax
  800060:	c1 e0 02             	shl    $0x2,%eax
  800063:	01 d0                	add    %edx,%eax
  800065:	01 c0                	add    %eax,%eax
  800067:	89 45 dc             	mov    %eax,-0x24(%ebp)
		unsigned char *x = malloc(sizeof(unsigned char)*size) ;
  80006a:	83 ec 0c             	sub    $0xc,%esp
  80006d:	ff 75 dc             	pushl  -0x24(%ebp)
  800070:	e8 5f 15 00 00       	call   8015d4 <malloc>
  800075:	83 c4 10             	add    $0x10,%esp
  800078:	89 45 d8             	mov    %eax,-0x28(%ebp)
		freeFrames = sys_calculate_free_frames() ;
  80007b:	e8 82 19 00 00       	call   801a02 <sys_calculate_free_frames>
  800080:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int modFrames = sys_calculate_modified_frames();
  800083:	e8 93 19 00 00       	call   801a1b <sys_calculate_modified_frames>
  800088:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		cprintf("all frames AFTER malloc = %d\n", freeFrames + modFrames);
  80008b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80008e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800091:	01 d0                	add    %edx,%eax
  800093:	83 ec 08             	sub    $0x8,%esp
  800096:	50                   	push   %eax
  800097:	68 60 33 80 00       	push   $0x803360
  80009c:	e8 07 06 00 00       	call   8006a8 <cprintf>
  8000a1:	83 c4 10             	add    $0x10,%esp
		x[1]=-1;
  8000a4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000a7:	40                   	inc    %eax
  8000a8:	c6 00 ff             	movb   $0xff,(%eax)

		x[1*Mega] = -1;
  8000ab:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8000ae:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000b1:	01 d0                	add    %edx,%eax
  8000b3:	c6 00 ff             	movb   $0xff,(%eax)

		int i = x[2*Mega];
  8000b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000b9:	01 c0                	add    %eax,%eax
  8000bb:	89 c2                	mov    %eax,%edx
  8000bd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000c0:	01 d0                	add    %edx,%eax
  8000c2:	8a 00                	mov    (%eax),%al
  8000c4:	0f b6 c0             	movzbl %al,%eax
  8000c7:	89 45 f4             	mov    %eax,-0xc(%ebp)

		int j = x[3*Mega];
  8000ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000cd:	89 c2                	mov    %eax,%edx
  8000cf:	01 d2                	add    %edx,%edx
  8000d1:	01 d0                	add    %edx,%eax
  8000d3:	89 c2                	mov    %eax,%edx
  8000d5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000d8:	01 d0                	add    %edx,%eax
  8000da:	8a 00                	mov    (%eax),%al
  8000dc:	0f b6 c0             	movzbl %al,%eax
  8000df:	89 45 d0             	mov    %eax,-0x30(%ebp)

		x[4*Mega] = -1;
  8000e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000e5:	c1 e0 02             	shl    $0x2,%eax
  8000e8:	89 c2                	mov    %eax,%edx
  8000ea:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000ed:	01 d0                	add    %edx,%eax
  8000ef:	c6 00 ff             	movb   $0xff,(%eax)

		x[5*Mega] = -1;
  8000f2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8000f5:	89 d0                	mov    %edx,%eax
  8000f7:	c1 e0 02             	shl    $0x2,%eax
  8000fa:	01 d0                	add    %edx,%eax
  8000fc:	89 c2                	mov    %eax,%edx
  8000fe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800101:	01 d0                	add    %edx,%eax
  800103:	c6 00 ff             	movb   $0xff,(%eax)

		x[6*Mega] = -1;
  800106:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800109:	89 d0                	mov    %edx,%eax
  80010b:	01 c0                	add    %eax,%eax
  80010d:	01 d0                	add    %edx,%eax
  80010f:	01 c0                	add    %eax,%eax
  800111:	89 c2                	mov    %eax,%edx
  800113:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800116:	01 d0                	add    %edx,%eax
  800118:	c6 00 ff             	movb   $0xff,(%eax)

		x[7*Mega] = -1;
  80011b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80011e:	89 d0                	mov    %edx,%eax
  800120:	01 c0                	add    %eax,%eax
  800122:	01 d0                	add    %edx,%eax
  800124:	01 c0                	add    %eax,%eax
  800126:	01 d0                	add    %edx,%eax
  800128:	89 c2                	mov    %eax,%edx
  80012a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80012d:	01 d0                	add    %edx,%eax
  80012f:	c6 00 ff             	movb   $0xff,(%eax)

		x[8*Mega] = -1;
  800132:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800135:	c1 e0 03             	shl    $0x3,%eax
  800138:	89 c2                	mov    %eax,%edx
  80013a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80013d:	01 d0                	add    %edx,%eax
  80013f:	c6 00 ff             	movb   $0xff,(%eax)

		x[9*Mega] = -1;
  800142:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800145:	89 d0                	mov    %edx,%eax
  800147:	c1 e0 03             	shl    $0x3,%eax
  80014a:	01 d0                	add    %edx,%eax
  80014c:	89 c2                	mov    %eax,%edx
  80014e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800151:	01 d0                	add    %edx,%eax
  800153:	c6 00 ff             	movb   $0xff,(%eax)

		free(x);
  800156:	83 ec 0c             	sub    $0xc,%esp
  800159:	ff 75 d8             	pushl  -0x28(%ebp)
  80015c:	e8 ee 14 00 00       	call   80164f <free>
  800161:	83 c4 10             	add    $0x10,%esp

		int numOFEmptyLocInWS = 0;
  800164:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		for (i = 0 ; i < (myEnv->page_WS_max_size); i++)
  80016b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800172:	eb 79                	jmp    8001ed <_main+0x1b5>
		{
			if (myEnv->__uptr_pws[i].empty)
  800174:	a1 20 40 80 00       	mov    0x804020,%eax
  800179:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80017f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800182:	89 d0                	mov    %edx,%eax
  800184:	01 c0                	add    %eax,%eax
  800186:	01 d0                	add    %edx,%eax
  800188:	c1 e0 03             	shl    $0x3,%eax
  80018b:	01 c8                	add    %ecx,%eax
  80018d:	8a 40 04             	mov    0x4(%eax),%al
  800190:	84 c0                	test   %al,%al
  800192:	74 05                	je     800199 <_main+0x161>
			{
				numOFEmptyLocInWS++;
  800194:	ff 45 f0             	incl   -0x10(%ebp)
  800197:	eb 51                	jmp    8001ea <_main+0x1b2>
			}
			else
			{
				uint32 va = ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) ;
  800199:	a1 20 40 80 00       	mov    0x804020,%eax
  80019e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8001a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001a7:	89 d0                	mov    %edx,%eax
  8001a9:	01 c0                	add    %eax,%eax
  8001ab:	01 d0                	add    %edx,%eax
  8001ad:	c1 e0 03             	shl    $0x3,%eax
  8001b0:	01 c8                	add    %ecx,%eax
  8001b2:	8b 00                	mov    (%eax),%eax
  8001b4:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8001b7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001ba:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001bf:	89 45 c8             	mov    %eax,-0x38(%ebp)
				if (va >= USER_HEAP_START && va < (USER_HEAP_START + size))
  8001c2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8001c5:	85 c0                	test   %eax,%eax
  8001c7:	79 21                	jns    8001ea <_main+0x1b2>
  8001c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001cc:	05 00 00 00 80       	add    $0x80000000,%eax
  8001d1:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8001d4:	76 14                	jbe    8001ea <_main+0x1b2>
					panic("freeMem didn't remove its page(s) from the WS");
  8001d6:	83 ec 04             	sub    $0x4,%esp
  8001d9:	68 80 33 80 00       	push   $0x803380
  8001de:	6a 4e                	push   $0x4e
  8001e0:	68 ae 33 80 00       	push   $0x8033ae
  8001e5:	e8 0a 02 00 00       	call   8003f4 <_panic>
		x[9*Mega] = -1;

		free(x);

		int numOFEmptyLocInWS = 0;
		for (i = 0 ; i < (myEnv->page_WS_max_size); i++)
  8001ea:	ff 45 f4             	incl   -0xc(%ebp)
  8001ed:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f2:	8b 50 74             	mov    0x74(%eax),%edx
  8001f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001f8:	39 c2                	cmp    %eax,%edx
  8001fa:	0f 87 74 ff ff ff    	ja     800174 <_main+0x13c>
				uint32 va = ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) ;
				if (va >= USER_HEAP_START && va < (USER_HEAP_START + size))
					panic("freeMem didn't remove its page(s) from the WS");
			}
		}
		int free_frames = sys_calculate_free_frames();
  800200:	e8 fd 17 00 00       	call   801a02 <sys_calculate_free_frames>
  800205:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		int mod_frames = sys_calculate_modified_frames();
  800208:	e8 0e 18 00 00       	call   801a1b <sys_calculate_modified_frames>
  80020d:	89 45 c0             	mov    %eax,-0x40(%ebp)
		if ((sys_calculate_modified_frames() + sys_calculate_free_frames() - numOFEmptyLocInWS) - (modFrames + freeFrames) != 0 ) panic("FreeMem didn't remove all modified frames in the given range from the modified list");
  800210:	e8 06 18 00 00       	call   801a1b <sys_calculate_modified_frames>
  800215:	89 c3                	mov    %eax,%ebx
  800217:	e8 e6 17 00 00       	call   801a02 <sys_calculate_free_frames>
  80021c:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  80021f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800222:	89 d1                	mov    %edx,%ecx
  800224:	29 c1                	sub    %eax,%ecx
  800226:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800229:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80022c:	01 d0                	add    %edx,%eax
  80022e:	39 c1                	cmp    %eax,%ecx
  800230:	74 14                	je     800246 <_main+0x20e>
  800232:	83 ec 04             	sub    $0x4,%esp
  800235:	68 c4 33 80 00       	push   $0x8033c4
  80023a:	6a 53                	push   $0x53
  80023c:	68 ae 33 80 00       	push   $0x8033ae
  800241:	e8 ae 01 00 00       	call   8003f4 <_panic>
		//if (sys_calculate_modified_frames() != 0 ) panic("FreeMem didn't remove all modified frames in the given range from the modified list");
		//if (sys_calculate_notmod_frames() != 7) panic("FreeMem didn't remove all un-modified frames in the given range from the free frame list");

		//if (sys_calculate_free_frames() - freeFrames != 3) panic("FreeMem didn't UN-BUFFER the removed BUFFERED frames in the given range.. (check updating of isBuffered");

		cprintf("Congratulations!! test of removing BUFFERED pages in freeHeap is completed successfully.\n");
  800246:	83 ec 0c             	sub    $0xc,%esp
  800249:	68 18 34 80 00       	push   $0x803418
  80024e:	e8 55 04 00 00       	call   8006a8 <cprintf>
  800253:	83 c4 10             	add    $0x10,%esp

		//Try to access any of the removed buffered pages in the Heap [It's ILLEGAL ACCESS now]
		{
			cprintf("\nNow, trying to access the removed BUFFERED pages, you should make the kernel PANIC with ILLEGAL MEMORY ACCESS in page_fault_handler() since we have illegal access to page that is NOT EXIST in PF and NOT BELONGS to STACK.\n\n\n");
  800256:	83 ec 0c             	sub    $0xc,%esp
  800259:	68 74 34 80 00       	push   $0x803474
  80025e:	e8 45 04 00 00       	call   8006a8 <cprintf>
  800263:	83 c4 10             	add    $0x10,%esp

			x[1]=-1;
  800266:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800269:	40                   	inc    %eax
  80026a:	c6 00 ff             	movb   $0xff,(%eax)

			x[1*Mega] = -1;
  80026d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800270:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800273:	01 d0                	add    %edx,%eax
  800275:	c6 00 ff             	movb   $0xff,(%eax)

			int i = x[2*Mega];
  800278:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80027b:	01 c0                	add    %eax,%eax
  80027d:	89 c2                	mov    %eax,%edx
  80027f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800282:	01 d0                	add    %edx,%eax
  800284:	8a 00                	mov    (%eax),%al
  800286:	0f b6 c0             	movzbl %al,%eax
  800289:	89 45 bc             	mov    %eax,-0x44(%ebp)

			int j = x[3*Mega];
  80028c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80028f:	89 c2                	mov    %eax,%edx
  800291:	01 d2                	add    %edx,%edx
  800293:	01 d0                	add    %edx,%eax
  800295:	89 c2                	mov    %eax,%edx
  800297:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80029a:	01 d0                	add    %edx,%eax
  80029c:	8a 00                	mov    (%eax),%al
  80029e:	0f b6 c0             	movzbl %al,%eax
  8002a1:	89 45 b8             	mov    %eax,-0x48(%ebp)
		}
		panic("ERROR: FOS SHOULD NOT panic here, it should panic earlier in page_fault_handler(), since we have illegal access to page that is NOT EXIST in PF and NOT BELONGS to STACK. REMEMBER: creating new page in page file shouldn't be allowed except ONLY for stack pages\n");
  8002a4:	83 ec 04             	sub    $0x4,%esp
  8002a7:	68 58 35 80 00       	push   $0x803558
  8002ac:	6a 68                	push   $0x68
  8002ae:	68 ae 33 80 00       	push   $0x8033ae
  8002b3:	e8 3c 01 00 00       	call   8003f4 <_panic>

008002b8 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8002b8:	55                   	push   %ebp
  8002b9:	89 e5                	mov    %esp,%ebp
  8002bb:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8002be:	e8 1f 1a 00 00       	call   801ce2 <sys_getenvindex>
  8002c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8002c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8002c9:	89 d0                	mov    %edx,%eax
  8002cb:	c1 e0 03             	shl    $0x3,%eax
  8002ce:	01 d0                	add    %edx,%eax
  8002d0:	01 c0                	add    %eax,%eax
  8002d2:	01 d0                	add    %edx,%eax
  8002d4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002db:	01 d0                	add    %edx,%eax
  8002dd:	c1 e0 04             	shl    $0x4,%eax
  8002e0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002e5:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002ea:	a1 20 40 80 00       	mov    0x804020,%eax
  8002ef:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8002f5:	84 c0                	test   %al,%al
  8002f7:	74 0f                	je     800308 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8002f9:	a1 20 40 80 00       	mov    0x804020,%eax
  8002fe:	05 5c 05 00 00       	add    $0x55c,%eax
  800303:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800308:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80030c:	7e 0a                	jle    800318 <libmain+0x60>
		binaryname = argv[0];
  80030e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800311:	8b 00                	mov    (%eax),%eax
  800313:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800318:	83 ec 08             	sub    $0x8,%esp
  80031b:	ff 75 0c             	pushl  0xc(%ebp)
  80031e:	ff 75 08             	pushl  0x8(%ebp)
  800321:	e8 12 fd ff ff       	call   800038 <_main>
  800326:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800329:	e8 c1 17 00 00       	call   801aef <sys_disable_interrupt>
	cprintf("**************************************\n");
  80032e:	83 ec 0c             	sub    $0xc,%esp
  800331:	68 78 36 80 00       	push   $0x803678
  800336:	e8 6d 03 00 00       	call   8006a8 <cprintf>
  80033b:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80033e:	a1 20 40 80 00       	mov    0x804020,%eax
  800343:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800349:	a1 20 40 80 00       	mov    0x804020,%eax
  80034e:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800354:	83 ec 04             	sub    $0x4,%esp
  800357:	52                   	push   %edx
  800358:	50                   	push   %eax
  800359:	68 a0 36 80 00       	push   $0x8036a0
  80035e:	e8 45 03 00 00       	call   8006a8 <cprintf>
  800363:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800366:	a1 20 40 80 00       	mov    0x804020,%eax
  80036b:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800371:	a1 20 40 80 00       	mov    0x804020,%eax
  800376:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80037c:	a1 20 40 80 00       	mov    0x804020,%eax
  800381:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800387:	51                   	push   %ecx
  800388:	52                   	push   %edx
  800389:	50                   	push   %eax
  80038a:	68 c8 36 80 00       	push   $0x8036c8
  80038f:	e8 14 03 00 00       	call   8006a8 <cprintf>
  800394:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800397:	a1 20 40 80 00       	mov    0x804020,%eax
  80039c:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8003a2:	83 ec 08             	sub    $0x8,%esp
  8003a5:	50                   	push   %eax
  8003a6:	68 20 37 80 00       	push   $0x803720
  8003ab:	e8 f8 02 00 00       	call   8006a8 <cprintf>
  8003b0:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8003b3:	83 ec 0c             	sub    $0xc,%esp
  8003b6:	68 78 36 80 00       	push   $0x803678
  8003bb:	e8 e8 02 00 00       	call   8006a8 <cprintf>
  8003c0:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8003c3:	e8 41 17 00 00       	call   801b09 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8003c8:	e8 19 00 00 00       	call   8003e6 <exit>
}
  8003cd:	90                   	nop
  8003ce:	c9                   	leave  
  8003cf:	c3                   	ret    

008003d0 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8003d0:	55                   	push   %ebp
  8003d1:	89 e5                	mov    %esp,%ebp
  8003d3:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8003d6:	83 ec 0c             	sub    $0xc,%esp
  8003d9:	6a 00                	push   $0x0
  8003db:	e8 ce 18 00 00       	call   801cae <sys_destroy_env>
  8003e0:	83 c4 10             	add    $0x10,%esp
}
  8003e3:	90                   	nop
  8003e4:	c9                   	leave  
  8003e5:	c3                   	ret    

008003e6 <exit>:

void
exit(void)
{
  8003e6:	55                   	push   %ebp
  8003e7:	89 e5                	mov    %esp,%ebp
  8003e9:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8003ec:	e8 23 19 00 00       	call   801d14 <sys_exit_env>
}
  8003f1:	90                   	nop
  8003f2:	c9                   	leave  
  8003f3:	c3                   	ret    

008003f4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8003f4:	55                   	push   %ebp
  8003f5:	89 e5                	mov    %esp,%ebp
  8003f7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8003fa:	8d 45 10             	lea    0x10(%ebp),%eax
  8003fd:	83 c0 04             	add    $0x4,%eax
  800400:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800403:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800408:	85 c0                	test   %eax,%eax
  80040a:	74 16                	je     800422 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80040c:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800411:	83 ec 08             	sub    $0x8,%esp
  800414:	50                   	push   %eax
  800415:	68 34 37 80 00       	push   $0x803734
  80041a:	e8 89 02 00 00       	call   8006a8 <cprintf>
  80041f:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800422:	a1 00 40 80 00       	mov    0x804000,%eax
  800427:	ff 75 0c             	pushl  0xc(%ebp)
  80042a:	ff 75 08             	pushl  0x8(%ebp)
  80042d:	50                   	push   %eax
  80042e:	68 39 37 80 00       	push   $0x803739
  800433:	e8 70 02 00 00       	call   8006a8 <cprintf>
  800438:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80043b:	8b 45 10             	mov    0x10(%ebp),%eax
  80043e:	83 ec 08             	sub    $0x8,%esp
  800441:	ff 75 f4             	pushl  -0xc(%ebp)
  800444:	50                   	push   %eax
  800445:	e8 f3 01 00 00       	call   80063d <vcprintf>
  80044a:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80044d:	83 ec 08             	sub    $0x8,%esp
  800450:	6a 00                	push   $0x0
  800452:	68 55 37 80 00       	push   $0x803755
  800457:	e8 e1 01 00 00       	call   80063d <vcprintf>
  80045c:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80045f:	e8 82 ff ff ff       	call   8003e6 <exit>

	// should not return here
	while (1) ;
  800464:	eb fe                	jmp    800464 <_panic+0x70>

00800466 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800466:	55                   	push   %ebp
  800467:	89 e5                	mov    %esp,%ebp
  800469:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80046c:	a1 20 40 80 00       	mov    0x804020,%eax
  800471:	8b 50 74             	mov    0x74(%eax),%edx
  800474:	8b 45 0c             	mov    0xc(%ebp),%eax
  800477:	39 c2                	cmp    %eax,%edx
  800479:	74 14                	je     80048f <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80047b:	83 ec 04             	sub    $0x4,%esp
  80047e:	68 58 37 80 00       	push   $0x803758
  800483:	6a 26                	push   $0x26
  800485:	68 a4 37 80 00       	push   $0x8037a4
  80048a:	e8 65 ff ff ff       	call   8003f4 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80048f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800496:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80049d:	e9 c2 00 00 00       	jmp    800564 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8004a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004a5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8004af:	01 d0                	add    %edx,%eax
  8004b1:	8b 00                	mov    (%eax),%eax
  8004b3:	85 c0                	test   %eax,%eax
  8004b5:	75 08                	jne    8004bf <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8004b7:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8004ba:	e9 a2 00 00 00       	jmp    800561 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8004bf:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004c6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8004cd:	eb 69                	jmp    800538 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8004cf:	a1 20 40 80 00       	mov    0x804020,%eax
  8004d4:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8004da:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004dd:	89 d0                	mov    %edx,%eax
  8004df:	01 c0                	add    %eax,%eax
  8004e1:	01 d0                	add    %edx,%eax
  8004e3:	c1 e0 03             	shl    $0x3,%eax
  8004e6:	01 c8                	add    %ecx,%eax
  8004e8:	8a 40 04             	mov    0x4(%eax),%al
  8004eb:	84 c0                	test   %al,%al
  8004ed:	75 46                	jne    800535 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004ef:	a1 20 40 80 00       	mov    0x804020,%eax
  8004f4:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8004fa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004fd:	89 d0                	mov    %edx,%eax
  8004ff:	01 c0                	add    %eax,%eax
  800501:	01 d0                	add    %edx,%eax
  800503:	c1 e0 03             	shl    $0x3,%eax
  800506:	01 c8                	add    %ecx,%eax
  800508:	8b 00                	mov    (%eax),%eax
  80050a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80050d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800510:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800515:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800517:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80051a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800521:	8b 45 08             	mov    0x8(%ebp),%eax
  800524:	01 c8                	add    %ecx,%eax
  800526:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800528:	39 c2                	cmp    %eax,%edx
  80052a:	75 09                	jne    800535 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80052c:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800533:	eb 12                	jmp    800547 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800535:	ff 45 e8             	incl   -0x18(%ebp)
  800538:	a1 20 40 80 00       	mov    0x804020,%eax
  80053d:	8b 50 74             	mov    0x74(%eax),%edx
  800540:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800543:	39 c2                	cmp    %eax,%edx
  800545:	77 88                	ja     8004cf <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800547:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80054b:	75 14                	jne    800561 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80054d:	83 ec 04             	sub    $0x4,%esp
  800550:	68 b0 37 80 00       	push   $0x8037b0
  800555:	6a 3a                	push   $0x3a
  800557:	68 a4 37 80 00       	push   $0x8037a4
  80055c:	e8 93 fe ff ff       	call   8003f4 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800561:	ff 45 f0             	incl   -0x10(%ebp)
  800564:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800567:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80056a:	0f 8c 32 ff ff ff    	jl     8004a2 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800570:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800577:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80057e:	eb 26                	jmp    8005a6 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800580:	a1 20 40 80 00       	mov    0x804020,%eax
  800585:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80058b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80058e:	89 d0                	mov    %edx,%eax
  800590:	01 c0                	add    %eax,%eax
  800592:	01 d0                	add    %edx,%eax
  800594:	c1 e0 03             	shl    $0x3,%eax
  800597:	01 c8                	add    %ecx,%eax
  800599:	8a 40 04             	mov    0x4(%eax),%al
  80059c:	3c 01                	cmp    $0x1,%al
  80059e:	75 03                	jne    8005a3 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8005a0:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005a3:	ff 45 e0             	incl   -0x20(%ebp)
  8005a6:	a1 20 40 80 00       	mov    0x804020,%eax
  8005ab:	8b 50 74             	mov    0x74(%eax),%edx
  8005ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005b1:	39 c2                	cmp    %eax,%edx
  8005b3:	77 cb                	ja     800580 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8005b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005b8:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8005bb:	74 14                	je     8005d1 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8005bd:	83 ec 04             	sub    $0x4,%esp
  8005c0:	68 04 38 80 00       	push   $0x803804
  8005c5:	6a 44                	push   $0x44
  8005c7:	68 a4 37 80 00       	push   $0x8037a4
  8005cc:	e8 23 fe ff ff       	call   8003f4 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8005d1:	90                   	nop
  8005d2:	c9                   	leave  
  8005d3:	c3                   	ret    

008005d4 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8005d4:	55                   	push   %ebp
  8005d5:	89 e5                	mov    %esp,%ebp
  8005d7:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8005da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005dd:	8b 00                	mov    (%eax),%eax
  8005df:	8d 48 01             	lea    0x1(%eax),%ecx
  8005e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005e5:	89 0a                	mov    %ecx,(%edx)
  8005e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8005ea:	88 d1                	mov    %dl,%cl
  8005ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005ef:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8005f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005f6:	8b 00                	mov    (%eax),%eax
  8005f8:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005fd:	75 2c                	jne    80062b <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8005ff:	a0 24 40 80 00       	mov    0x804024,%al
  800604:	0f b6 c0             	movzbl %al,%eax
  800607:	8b 55 0c             	mov    0xc(%ebp),%edx
  80060a:	8b 12                	mov    (%edx),%edx
  80060c:	89 d1                	mov    %edx,%ecx
  80060e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800611:	83 c2 08             	add    $0x8,%edx
  800614:	83 ec 04             	sub    $0x4,%esp
  800617:	50                   	push   %eax
  800618:	51                   	push   %ecx
  800619:	52                   	push   %edx
  80061a:	e8 22 13 00 00       	call   801941 <sys_cputs>
  80061f:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800622:	8b 45 0c             	mov    0xc(%ebp),%eax
  800625:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80062b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80062e:	8b 40 04             	mov    0x4(%eax),%eax
  800631:	8d 50 01             	lea    0x1(%eax),%edx
  800634:	8b 45 0c             	mov    0xc(%ebp),%eax
  800637:	89 50 04             	mov    %edx,0x4(%eax)
}
  80063a:	90                   	nop
  80063b:	c9                   	leave  
  80063c:	c3                   	ret    

0080063d <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80063d:	55                   	push   %ebp
  80063e:	89 e5                	mov    %esp,%ebp
  800640:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800646:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80064d:	00 00 00 
	b.cnt = 0;
  800650:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800657:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80065a:	ff 75 0c             	pushl  0xc(%ebp)
  80065d:	ff 75 08             	pushl  0x8(%ebp)
  800660:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800666:	50                   	push   %eax
  800667:	68 d4 05 80 00       	push   $0x8005d4
  80066c:	e8 11 02 00 00       	call   800882 <vprintfmt>
  800671:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800674:	a0 24 40 80 00       	mov    0x804024,%al
  800679:	0f b6 c0             	movzbl %al,%eax
  80067c:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800682:	83 ec 04             	sub    $0x4,%esp
  800685:	50                   	push   %eax
  800686:	52                   	push   %edx
  800687:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80068d:	83 c0 08             	add    $0x8,%eax
  800690:	50                   	push   %eax
  800691:	e8 ab 12 00 00       	call   801941 <sys_cputs>
  800696:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800699:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  8006a0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8006a6:	c9                   	leave  
  8006a7:	c3                   	ret    

008006a8 <cprintf>:

int cprintf(const char *fmt, ...) {
  8006a8:	55                   	push   %ebp
  8006a9:	89 e5                	mov    %esp,%ebp
  8006ab:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8006ae:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  8006b5:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006be:	83 ec 08             	sub    $0x8,%esp
  8006c1:	ff 75 f4             	pushl  -0xc(%ebp)
  8006c4:	50                   	push   %eax
  8006c5:	e8 73 ff ff ff       	call   80063d <vcprintf>
  8006ca:	83 c4 10             	add    $0x10,%esp
  8006cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8006d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006d3:	c9                   	leave  
  8006d4:	c3                   	ret    

008006d5 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8006d5:	55                   	push   %ebp
  8006d6:	89 e5                	mov    %esp,%ebp
  8006d8:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8006db:	e8 0f 14 00 00       	call   801aef <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8006e0:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e9:	83 ec 08             	sub    $0x8,%esp
  8006ec:	ff 75 f4             	pushl  -0xc(%ebp)
  8006ef:	50                   	push   %eax
  8006f0:	e8 48 ff ff ff       	call   80063d <vcprintf>
  8006f5:	83 c4 10             	add    $0x10,%esp
  8006f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8006fb:	e8 09 14 00 00       	call   801b09 <sys_enable_interrupt>
	return cnt;
  800700:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800703:	c9                   	leave  
  800704:	c3                   	ret    

00800705 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800705:	55                   	push   %ebp
  800706:	89 e5                	mov    %esp,%ebp
  800708:	53                   	push   %ebx
  800709:	83 ec 14             	sub    $0x14,%esp
  80070c:	8b 45 10             	mov    0x10(%ebp),%eax
  80070f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800712:	8b 45 14             	mov    0x14(%ebp),%eax
  800715:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800718:	8b 45 18             	mov    0x18(%ebp),%eax
  80071b:	ba 00 00 00 00       	mov    $0x0,%edx
  800720:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800723:	77 55                	ja     80077a <printnum+0x75>
  800725:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800728:	72 05                	jb     80072f <printnum+0x2a>
  80072a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80072d:	77 4b                	ja     80077a <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80072f:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800732:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800735:	8b 45 18             	mov    0x18(%ebp),%eax
  800738:	ba 00 00 00 00       	mov    $0x0,%edx
  80073d:	52                   	push   %edx
  80073e:	50                   	push   %eax
  80073f:	ff 75 f4             	pushl  -0xc(%ebp)
  800742:	ff 75 f0             	pushl  -0x10(%ebp)
  800745:	e8 b2 29 00 00       	call   8030fc <__udivdi3>
  80074a:	83 c4 10             	add    $0x10,%esp
  80074d:	83 ec 04             	sub    $0x4,%esp
  800750:	ff 75 20             	pushl  0x20(%ebp)
  800753:	53                   	push   %ebx
  800754:	ff 75 18             	pushl  0x18(%ebp)
  800757:	52                   	push   %edx
  800758:	50                   	push   %eax
  800759:	ff 75 0c             	pushl  0xc(%ebp)
  80075c:	ff 75 08             	pushl  0x8(%ebp)
  80075f:	e8 a1 ff ff ff       	call   800705 <printnum>
  800764:	83 c4 20             	add    $0x20,%esp
  800767:	eb 1a                	jmp    800783 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800769:	83 ec 08             	sub    $0x8,%esp
  80076c:	ff 75 0c             	pushl  0xc(%ebp)
  80076f:	ff 75 20             	pushl  0x20(%ebp)
  800772:	8b 45 08             	mov    0x8(%ebp),%eax
  800775:	ff d0                	call   *%eax
  800777:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80077a:	ff 4d 1c             	decl   0x1c(%ebp)
  80077d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800781:	7f e6                	jg     800769 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800783:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800786:	bb 00 00 00 00       	mov    $0x0,%ebx
  80078b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80078e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800791:	53                   	push   %ebx
  800792:	51                   	push   %ecx
  800793:	52                   	push   %edx
  800794:	50                   	push   %eax
  800795:	e8 72 2a 00 00       	call   80320c <__umoddi3>
  80079a:	83 c4 10             	add    $0x10,%esp
  80079d:	05 74 3a 80 00       	add    $0x803a74,%eax
  8007a2:	8a 00                	mov    (%eax),%al
  8007a4:	0f be c0             	movsbl %al,%eax
  8007a7:	83 ec 08             	sub    $0x8,%esp
  8007aa:	ff 75 0c             	pushl  0xc(%ebp)
  8007ad:	50                   	push   %eax
  8007ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b1:	ff d0                	call   *%eax
  8007b3:	83 c4 10             	add    $0x10,%esp
}
  8007b6:	90                   	nop
  8007b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007ba:	c9                   	leave  
  8007bb:	c3                   	ret    

008007bc <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007bc:	55                   	push   %ebp
  8007bd:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007bf:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007c3:	7e 1c                	jle    8007e1 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8007c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c8:	8b 00                	mov    (%eax),%eax
  8007ca:	8d 50 08             	lea    0x8(%eax),%edx
  8007cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d0:	89 10                	mov    %edx,(%eax)
  8007d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d5:	8b 00                	mov    (%eax),%eax
  8007d7:	83 e8 08             	sub    $0x8,%eax
  8007da:	8b 50 04             	mov    0x4(%eax),%edx
  8007dd:	8b 00                	mov    (%eax),%eax
  8007df:	eb 40                	jmp    800821 <getuint+0x65>
	else if (lflag)
  8007e1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007e5:	74 1e                	je     800805 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8007e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ea:	8b 00                	mov    (%eax),%eax
  8007ec:	8d 50 04             	lea    0x4(%eax),%edx
  8007ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f2:	89 10                	mov    %edx,(%eax)
  8007f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f7:	8b 00                	mov    (%eax),%eax
  8007f9:	83 e8 04             	sub    $0x4,%eax
  8007fc:	8b 00                	mov    (%eax),%eax
  8007fe:	ba 00 00 00 00       	mov    $0x0,%edx
  800803:	eb 1c                	jmp    800821 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800805:	8b 45 08             	mov    0x8(%ebp),%eax
  800808:	8b 00                	mov    (%eax),%eax
  80080a:	8d 50 04             	lea    0x4(%eax),%edx
  80080d:	8b 45 08             	mov    0x8(%ebp),%eax
  800810:	89 10                	mov    %edx,(%eax)
  800812:	8b 45 08             	mov    0x8(%ebp),%eax
  800815:	8b 00                	mov    (%eax),%eax
  800817:	83 e8 04             	sub    $0x4,%eax
  80081a:	8b 00                	mov    (%eax),%eax
  80081c:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800821:	5d                   	pop    %ebp
  800822:	c3                   	ret    

00800823 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800823:	55                   	push   %ebp
  800824:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800826:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80082a:	7e 1c                	jle    800848 <getint+0x25>
		return va_arg(*ap, long long);
  80082c:	8b 45 08             	mov    0x8(%ebp),%eax
  80082f:	8b 00                	mov    (%eax),%eax
  800831:	8d 50 08             	lea    0x8(%eax),%edx
  800834:	8b 45 08             	mov    0x8(%ebp),%eax
  800837:	89 10                	mov    %edx,(%eax)
  800839:	8b 45 08             	mov    0x8(%ebp),%eax
  80083c:	8b 00                	mov    (%eax),%eax
  80083e:	83 e8 08             	sub    $0x8,%eax
  800841:	8b 50 04             	mov    0x4(%eax),%edx
  800844:	8b 00                	mov    (%eax),%eax
  800846:	eb 38                	jmp    800880 <getint+0x5d>
	else if (lflag)
  800848:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80084c:	74 1a                	je     800868 <getint+0x45>
		return va_arg(*ap, long);
  80084e:	8b 45 08             	mov    0x8(%ebp),%eax
  800851:	8b 00                	mov    (%eax),%eax
  800853:	8d 50 04             	lea    0x4(%eax),%edx
  800856:	8b 45 08             	mov    0x8(%ebp),%eax
  800859:	89 10                	mov    %edx,(%eax)
  80085b:	8b 45 08             	mov    0x8(%ebp),%eax
  80085e:	8b 00                	mov    (%eax),%eax
  800860:	83 e8 04             	sub    $0x4,%eax
  800863:	8b 00                	mov    (%eax),%eax
  800865:	99                   	cltd   
  800866:	eb 18                	jmp    800880 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800868:	8b 45 08             	mov    0x8(%ebp),%eax
  80086b:	8b 00                	mov    (%eax),%eax
  80086d:	8d 50 04             	lea    0x4(%eax),%edx
  800870:	8b 45 08             	mov    0x8(%ebp),%eax
  800873:	89 10                	mov    %edx,(%eax)
  800875:	8b 45 08             	mov    0x8(%ebp),%eax
  800878:	8b 00                	mov    (%eax),%eax
  80087a:	83 e8 04             	sub    $0x4,%eax
  80087d:	8b 00                	mov    (%eax),%eax
  80087f:	99                   	cltd   
}
  800880:	5d                   	pop    %ebp
  800881:	c3                   	ret    

00800882 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800882:	55                   	push   %ebp
  800883:	89 e5                	mov    %esp,%ebp
  800885:	56                   	push   %esi
  800886:	53                   	push   %ebx
  800887:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80088a:	eb 17                	jmp    8008a3 <vprintfmt+0x21>
			if (ch == '\0')
  80088c:	85 db                	test   %ebx,%ebx
  80088e:	0f 84 af 03 00 00    	je     800c43 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800894:	83 ec 08             	sub    $0x8,%esp
  800897:	ff 75 0c             	pushl  0xc(%ebp)
  80089a:	53                   	push   %ebx
  80089b:	8b 45 08             	mov    0x8(%ebp),%eax
  80089e:	ff d0                	call   *%eax
  8008a0:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8008a6:	8d 50 01             	lea    0x1(%eax),%edx
  8008a9:	89 55 10             	mov    %edx,0x10(%ebp)
  8008ac:	8a 00                	mov    (%eax),%al
  8008ae:	0f b6 d8             	movzbl %al,%ebx
  8008b1:	83 fb 25             	cmp    $0x25,%ebx
  8008b4:	75 d6                	jne    80088c <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008b6:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8008ba:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8008c1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8008c8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8008cf:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8008d9:	8d 50 01             	lea    0x1(%eax),%edx
  8008dc:	89 55 10             	mov    %edx,0x10(%ebp)
  8008df:	8a 00                	mov    (%eax),%al
  8008e1:	0f b6 d8             	movzbl %al,%ebx
  8008e4:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8008e7:	83 f8 55             	cmp    $0x55,%eax
  8008ea:	0f 87 2b 03 00 00    	ja     800c1b <vprintfmt+0x399>
  8008f0:	8b 04 85 98 3a 80 00 	mov    0x803a98(,%eax,4),%eax
  8008f7:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8008f9:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8008fd:	eb d7                	jmp    8008d6 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008ff:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800903:	eb d1                	jmp    8008d6 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800905:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80090c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80090f:	89 d0                	mov    %edx,%eax
  800911:	c1 e0 02             	shl    $0x2,%eax
  800914:	01 d0                	add    %edx,%eax
  800916:	01 c0                	add    %eax,%eax
  800918:	01 d8                	add    %ebx,%eax
  80091a:	83 e8 30             	sub    $0x30,%eax
  80091d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800920:	8b 45 10             	mov    0x10(%ebp),%eax
  800923:	8a 00                	mov    (%eax),%al
  800925:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800928:	83 fb 2f             	cmp    $0x2f,%ebx
  80092b:	7e 3e                	jle    80096b <vprintfmt+0xe9>
  80092d:	83 fb 39             	cmp    $0x39,%ebx
  800930:	7f 39                	jg     80096b <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800932:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800935:	eb d5                	jmp    80090c <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800937:	8b 45 14             	mov    0x14(%ebp),%eax
  80093a:	83 c0 04             	add    $0x4,%eax
  80093d:	89 45 14             	mov    %eax,0x14(%ebp)
  800940:	8b 45 14             	mov    0x14(%ebp),%eax
  800943:	83 e8 04             	sub    $0x4,%eax
  800946:	8b 00                	mov    (%eax),%eax
  800948:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80094b:	eb 1f                	jmp    80096c <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80094d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800951:	79 83                	jns    8008d6 <vprintfmt+0x54>
				width = 0;
  800953:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80095a:	e9 77 ff ff ff       	jmp    8008d6 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80095f:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800966:	e9 6b ff ff ff       	jmp    8008d6 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80096b:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80096c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800970:	0f 89 60 ff ff ff    	jns    8008d6 <vprintfmt+0x54>
				width = precision, precision = -1;
  800976:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800979:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80097c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800983:	e9 4e ff ff ff       	jmp    8008d6 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800988:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80098b:	e9 46 ff ff ff       	jmp    8008d6 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800990:	8b 45 14             	mov    0x14(%ebp),%eax
  800993:	83 c0 04             	add    $0x4,%eax
  800996:	89 45 14             	mov    %eax,0x14(%ebp)
  800999:	8b 45 14             	mov    0x14(%ebp),%eax
  80099c:	83 e8 04             	sub    $0x4,%eax
  80099f:	8b 00                	mov    (%eax),%eax
  8009a1:	83 ec 08             	sub    $0x8,%esp
  8009a4:	ff 75 0c             	pushl  0xc(%ebp)
  8009a7:	50                   	push   %eax
  8009a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ab:	ff d0                	call   *%eax
  8009ad:	83 c4 10             	add    $0x10,%esp
			break;
  8009b0:	e9 89 02 00 00       	jmp    800c3e <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8009b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b8:	83 c0 04             	add    $0x4,%eax
  8009bb:	89 45 14             	mov    %eax,0x14(%ebp)
  8009be:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c1:	83 e8 04             	sub    $0x4,%eax
  8009c4:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8009c6:	85 db                	test   %ebx,%ebx
  8009c8:	79 02                	jns    8009cc <vprintfmt+0x14a>
				err = -err;
  8009ca:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8009cc:	83 fb 64             	cmp    $0x64,%ebx
  8009cf:	7f 0b                	jg     8009dc <vprintfmt+0x15a>
  8009d1:	8b 34 9d e0 38 80 00 	mov    0x8038e0(,%ebx,4),%esi
  8009d8:	85 f6                	test   %esi,%esi
  8009da:	75 19                	jne    8009f5 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009dc:	53                   	push   %ebx
  8009dd:	68 85 3a 80 00       	push   $0x803a85
  8009e2:	ff 75 0c             	pushl  0xc(%ebp)
  8009e5:	ff 75 08             	pushl  0x8(%ebp)
  8009e8:	e8 5e 02 00 00       	call   800c4b <printfmt>
  8009ed:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009f0:	e9 49 02 00 00       	jmp    800c3e <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009f5:	56                   	push   %esi
  8009f6:	68 8e 3a 80 00       	push   $0x803a8e
  8009fb:	ff 75 0c             	pushl  0xc(%ebp)
  8009fe:	ff 75 08             	pushl  0x8(%ebp)
  800a01:	e8 45 02 00 00       	call   800c4b <printfmt>
  800a06:	83 c4 10             	add    $0x10,%esp
			break;
  800a09:	e9 30 02 00 00       	jmp    800c3e <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a0e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a11:	83 c0 04             	add    $0x4,%eax
  800a14:	89 45 14             	mov    %eax,0x14(%ebp)
  800a17:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1a:	83 e8 04             	sub    $0x4,%eax
  800a1d:	8b 30                	mov    (%eax),%esi
  800a1f:	85 f6                	test   %esi,%esi
  800a21:	75 05                	jne    800a28 <vprintfmt+0x1a6>
				p = "(null)";
  800a23:	be 91 3a 80 00       	mov    $0x803a91,%esi
			if (width > 0 && padc != '-')
  800a28:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a2c:	7e 6d                	jle    800a9b <vprintfmt+0x219>
  800a2e:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a32:	74 67                	je     800a9b <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a34:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a37:	83 ec 08             	sub    $0x8,%esp
  800a3a:	50                   	push   %eax
  800a3b:	56                   	push   %esi
  800a3c:	e8 0c 03 00 00       	call   800d4d <strnlen>
  800a41:	83 c4 10             	add    $0x10,%esp
  800a44:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a47:	eb 16                	jmp    800a5f <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a49:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a4d:	83 ec 08             	sub    $0x8,%esp
  800a50:	ff 75 0c             	pushl  0xc(%ebp)
  800a53:	50                   	push   %eax
  800a54:	8b 45 08             	mov    0x8(%ebp),%eax
  800a57:	ff d0                	call   *%eax
  800a59:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a5c:	ff 4d e4             	decl   -0x1c(%ebp)
  800a5f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a63:	7f e4                	jg     800a49 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a65:	eb 34                	jmp    800a9b <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a67:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a6b:	74 1c                	je     800a89 <vprintfmt+0x207>
  800a6d:	83 fb 1f             	cmp    $0x1f,%ebx
  800a70:	7e 05                	jle    800a77 <vprintfmt+0x1f5>
  800a72:	83 fb 7e             	cmp    $0x7e,%ebx
  800a75:	7e 12                	jle    800a89 <vprintfmt+0x207>
					putch('?', putdat);
  800a77:	83 ec 08             	sub    $0x8,%esp
  800a7a:	ff 75 0c             	pushl  0xc(%ebp)
  800a7d:	6a 3f                	push   $0x3f
  800a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a82:	ff d0                	call   *%eax
  800a84:	83 c4 10             	add    $0x10,%esp
  800a87:	eb 0f                	jmp    800a98 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a89:	83 ec 08             	sub    $0x8,%esp
  800a8c:	ff 75 0c             	pushl  0xc(%ebp)
  800a8f:	53                   	push   %ebx
  800a90:	8b 45 08             	mov    0x8(%ebp),%eax
  800a93:	ff d0                	call   *%eax
  800a95:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a98:	ff 4d e4             	decl   -0x1c(%ebp)
  800a9b:	89 f0                	mov    %esi,%eax
  800a9d:	8d 70 01             	lea    0x1(%eax),%esi
  800aa0:	8a 00                	mov    (%eax),%al
  800aa2:	0f be d8             	movsbl %al,%ebx
  800aa5:	85 db                	test   %ebx,%ebx
  800aa7:	74 24                	je     800acd <vprintfmt+0x24b>
  800aa9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800aad:	78 b8                	js     800a67 <vprintfmt+0x1e5>
  800aaf:	ff 4d e0             	decl   -0x20(%ebp)
  800ab2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ab6:	79 af                	jns    800a67 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ab8:	eb 13                	jmp    800acd <vprintfmt+0x24b>
				putch(' ', putdat);
  800aba:	83 ec 08             	sub    $0x8,%esp
  800abd:	ff 75 0c             	pushl  0xc(%ebp)
  800ac0:	6a 20                	push   $0x20
  800ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac5:	ff d0                	call   *%eax
  800ac7:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800aca:	ff 4d e4             	decl   -0x1c(%ebp)
  800acd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ad1:	7f e7                	jg     800aba <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800ad3:	e9 66 01 00 00       	jmp    800c3e <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ad8:	83 ec 08             	sub    $0x8,%esp
  800adb:	ff 75 e8             	pushl  -0x18(%ebp)
  800ade:	8d 45 14             	lea    0x14(%ebp),%eax
  800ae1:	50                   	push   %eax
  800ae2:	e8 3c fd ff ff       	call   800823 <getint>
  800ae7:	83 c4 10             	add    $0x10,%esp
  800aea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aed:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800af0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800af3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800af6:	85 d2                	test   %edx,%edx
  800af8:	79 23                	jns    800b1d <vprintfmt+0x29b>
				putch('-', putdat);
  800afa:	83 ec 08             	sub    $0x8,%esp
  800afd:	ff 75 0c             	pushl  0xc(%ebp)
  800b00:	6a 2d                	push   $0x2d
  800b02:	8b 45 08             	mov    0x8(%ebp),%eax
  800b05:	ff d0                	call   *%eax
  800b07:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b0d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b10:	f7 d8                	neg    %eax
  800b12:	83 d2 00             	adc    $0x0,%edx
  800b15:	f7 da                	neg    %edx
  800b17:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b1a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b1d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b24:	e9 bc 00 00 00       	jmp    800be5 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b29:	83 ec 08             	sub    $0x8,%esp
  800b2c:	ff 75 e8             	pushl  -0x18(%ebp)
  800b2f:	8d 45 14             	lea    0x14(%ebp),%eax
  800b32:	50                   	push   %eax
  800b33:	e8 84 fc ff ff       	call   8007bc <getuint>
  800b38:	83 c4 10             	add    $0x10,%esp
  800b3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b3e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b41:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b48:	e9 98 00 00 00       	jmp    800be5 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b4d:	83 ec 08             	sub    $0x8,%esp
  800b50:	ff 75 0c             	pushl  0xc(%ebp)
  800b53:	6a 58                	push   $0x58
  800b55:	8b 45 08             	mov    0x8(%ebp),%eax
  800b58:	ff d0                	call   *%eax
  800b5a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b5d:	83 ec 08             	sub    $0x8,%esp
  800b60:	ff 75 0c             	pushl  0xc(%ebp)
  800b63:	6a 58                	push   $0x58
  800b65:	8b 45 08             	mov    0x8(%ebp),%eax
  800b68:	ff d0                	call   *%eax
  800b6a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b6d:	83 ec 08             	sub    $0x8,%esp
  800b70:	ff 75 0c             	pushl  0xc(%ebp)
  800b73:	6a 58                	push   $0x58
  800b75:	8b 45 08             	mov    0x8(%ebp),%eax
  800b78:	ff d0                	call   *%eax
  800b7a:	83 c4 10             	add    $0x10,%esp
			break;
  800b7d:	e9 bc 00 00 00       	jmp    800c3e <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800b82:	83 ec 08             	sub    $0x8,%esp
  800b85:	ff 75 0c             	pushl  0xc(%ebp)
  800b88:	6a 30                	push   $0x30
  800b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8d:	ff d0                	call   *%eax
  800b8f:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b92:	83 ec 08             	sub    $0x8,%esp
  800b95:	ff 75 0c             	pushl  0xc(%ebp)
  800b98:	6a 78                	push   $0x78
  800b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9d:	ff d0                	call   *%eax
  800b9f:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ba2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ba5:	83 c0 04             	add    $0x4,%eax
  800ba8:	89 45 14             	mov    %eax,0x14(%ebp)
  800bab:	8b 45 14             	mov    0x14(%ebp),%eax
  800bae:	83 e8 04             	sub    $0x4,%eax
  800bb1:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bb3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bb6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800bbd:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800bc4:	eb 1f                	jmp    800be5 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800bc6:	83 ec 08             	sub    $0x8,%esp
  800bc9:	ff 75 e8             	pushl  -0x18(%ebp)
  800bcc:	8d 45 14             	lea    0x14(%ebp),%eax
  800bcf:	50                   	push   %eax
  800bd0:	e8 e7 fb ff ff       	call   8007bc <getuint>
  800bd5:	83 c4 10             	add    $0x10,%esp
  800bd8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bdb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800bde:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800be5:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800be9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bec:	83 ec 04             	sub    $0x4,%esp
  800bef:	52                   	push   %edx
  800bf0:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bf3:	50                   	push   %eax
  800bf4:	ff 75 f4             	pushl  -0xc(%ebp)
  800bf7:	ff 75 f0             	pushl  -0x10(%ebp)
  800bfa:	ff 75 0c             	pushl  0xc(%ebp)
  800bfd:	ff 75 08             	pushl  0x8(%ebp)
  800c00:	e8 00 fb ff ff       	call   800705 <printnum>
  800c05:	83 c4 20             	add    $0x20,%esp
			break;
  800c08:	eb 34                	jmp    800c3e <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c0a:	83 ec 08             	sub    $0x8,%esp
  800c0d:	ff 75 0c             	pushl  0xc(%ebp)
  800c10:	53                   	push   %ebx
  800c11:	8b 45 08             	mov    0x8(%ebp),%eax
  800c14:	ff d0                	call   *%eax
  800c16:	83 c4 10             	add    $0x10,%esp
			break;
  800c19:	eb 23                	jmp    800c3e <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c1b:	83 ec 08             	sub    $0x8,%esp
  800c1e:	ff 75 0c             	pushl  0xc(%ebp)
  800c21:	6a 25                	push   $0x25
  800c23:	8b 45 08             	mov    0x8(%ebp),%eax
  800c26:	ff d0                	call   *%eax
  800c28:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c2b:	ff 4d 10             	decl   0x10(%ebp)
  800c2e:	eb 03                	jmp    800c33 <vprintfmt+0x3b1>
  800c30:	ff 4d 10             	decl   0x10(%ebp)
  800c33:	8b 45 10             	mov    0x10(%ebp),%eax
  800c36:	48                   	dec    %eax
  800c37:	8a 00                	mov    (%eax),%al
  800c39:	3c 25                	cmp    $0x25,%al
  800c3b:	75 f3                	jne    800c30 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800c3d:	90                   	nop
		}
	}
  800c3e:	e9 47 fc ff ff       	jmp    80088a <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c43:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c44:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c47:	5b                   	pop    %ebx
  800c48:	5e                   	pop    %esi
  800c49:	5d                   	pop    %ebp
  800c4a:	c3                   	ret    

00800c4b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c4b:	55                   	push   %ebp
  800c4c:	89 e5                	mov    %esp,%ebp
  800c4e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c51:	8d 45 10             	lea    0x10(%ebp),%eax
  800c54:	83 c0 04             	add    $0x4,%eax
  800c57:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c5a:	8b 45 10             	mov    0x10(%ebp),%eax
  800c5d:	ff 75 f4             	pushl  -0xc(%ebp)
  800c60:	50                   	push   %eax
  800c61:	ff 75 0c             	pushl  0xc(%ebp)
  800c64:	ff 75 08             	pushl  0x8(%ebp)
  800c67:	e8 16 fc ff ff       	call   800882 <vprintfmt>
  800c6c:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c6f:	90                   	nop
  800c70:	c9                   	leave  
  800c71:	c3                   	ret    

00800c72 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c72:	55                   	push   %ebp
  800c73:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c78:	8b 40 08             	mov    0x8(%eax),%eax
  800c7b:	8d 50 01             	lea    0x1(%eax),%edx
  800c7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c81:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c87:	8b 10                	mov    (%eax),%edx
  800c89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8c:	8b 40 04             	mov    0x4(%eax),%eax
  800c8f:	39 c2                	cmp    %eax,%edx
  800c91:	73 12                	jae    800ca5 <sprintputch+0x33>
		*b->buf++ = ch;
  800c93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c96:	8b 00                	mov    (%eax),%eax
  800c98:	8d 48 01             	lea    0x1(%eax),%ecx
  800c9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c9e:	89 0a                	mov    %ecx,(%edx)
  800ca0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca3:	88 10                	mov    %dl,(%eax)
}
  800ca5:	90                   	nop
  800ca6:	5d                   	pop    %ebp
  800ca7:	c3                   	ret    

00800ca8 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ca8:	55                   	push   %ebp
  800ca9:	89 e5                	mov    %esp,%ebp
  800cab:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800cae:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800cb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cba:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbd:	01 d0                	add    %edx,%eax
  800cbf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cc2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800cc9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ccd:	74 06                	je     800cd5 <vsnprintf+0x2d>
  800ccf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cd3:	7f 07                	jg     800cdc <vsnprintf+0x34>
		return -E_INVAL;
  800cd5:	b8 03 00 00 00       	mov    $0x3,%eax
  800cda:	eb 20                	jmp    800cfc <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800cdc:	ff 75 14             	pushl  0x14(%ebp)
  800cdf:	ff 75 10             	pushl  0x10(%ebp)
  800ce2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ce5:	50                   	push   %eax
  800ce6:	68 72 0c 80 00       	push   $0x800c72
  800ceb:	e8 92 fb ff ff       	call   800882 <vprintfmt>
  800cf0:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800cf3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cf6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800cf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800cfc:	c9                   	leave  
  800cfd:	c3                   	ret    

00800cfe <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800cfe:	55                   	push   %ebp
  800cff:	89 e5                	mov    %esp,%ebp
  800d01:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d04:	8d 45 10             	lea    0x10(%ebp),%eax
  800d07:	83 c0 04             	add    $0x4,%eax
  800d0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d0d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d10:	ff 75 f4             	pushl  -0xc(%ebp)
  800d13:	50                   	push   %eax
  800d14:	ff 75 0c             	pushl  0xc(%ebp)
  800d17:	ff 75 08             	pushl  0x8(%ebp)
  800d1a:	e8 89 ff ff ff       	call   800ca8 <vsnprintf>
  800d1f:	83 c4 10             	add    $0x10,%esp
  800d22:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d25:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d28:	c9                   	leave  
  800d29:	c3                   	ret    

00800d2a <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800d2a:	55                   	push   %ebp
  800d2b:	89 e5                	mov    %esp,%ebp
  800d2d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d30:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d37:	eb 06                	jmp    800d3f <strlen+0x15>
		n++;
  800d39:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d3c:	ff 45 08             	incl   0x8(%ebp)
  800d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d42:	8a 00                	mov    (%eax),%al
  800d44:	84 c0                	test   %al,%al
  800d46:	75 f1                	jne    800d39 <strlen+0xf>
		n++;
	return n;
  800d48:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d4b:	c9                   	leave  
  800d4c:	c3                   	ret    

00800d4d <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d4d:	55                   	push   %ebp
  800d4e:	89 e5                	mov    %esp,%ebp
  800d50:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d53:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d5a:	eb 09                	jmp    800d65 <strnlen+0x18>
		n++;
  800d5c:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d5f:	ff 45 08             	incl   0x8(%ebp)
  800d62:	ff 4d 0c             	decl   0xc(%ebp)
  800d65:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d69:	74 09                	je     800d74 <strnlen+0x27>
  800d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6e:	8a 00                	mov    (%eax),%al
  800d70:	84 c0                	test   %al,%al
  800d72:	75 e8                	jne    800d5c <strnlen+0xf>
		n++;
	return n;
  800d74:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d77:	c9                   	leave  
  800d78:	c3                   	ret    

00800d79 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d79:	55                   	push   %ebp
  800d7a:	89 e5                	mov    %esp,%ebp
  800d7c:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d82:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d85:	90                   	nop
  800d86:	8b 45 08             	mov    0x8(%ebp),%eax
  800d89:	8d 50 01             	lea    0x1(%eax),%edx
  800d8c:	89 55 08             	mov    %edx,0x8(%ebp)
  800d8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d92:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d95:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d98:	8a 12                	mov    (%edx),%dl
  800d9a:	88 10                	mov    %dl,(%eax)
  800d9c:	8a 00                	mov    (%eax),%al
  800d9e:	84 c0                	test   %al,%al
  800da0:	75 e4                	jne    800d86 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800da2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800da5:	c9                   	leave  
  800da6:	c3                   	ret    

00800da7 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800da7:	55                   	push   %ebp
  800da8:	89 e5                	mov    %esp,%ebp
  800daa:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800dad:	8b 45 08             	mov    0x8(%ebp),%eax
  800db0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800db3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dba:	eb 1f                	jmp    800ddb <strncpy+0x34>
		*dst++ = *src;
  800dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbf:	8d 50 01             	lea    0x1(%eax),%edx
  800dc2:	89 55 08             	mov    %edx,0x8(%ebp)
  800dc5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dc8:	8a 12                	mov    (%edx),%dl
  800dca:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800dcc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcf:	8a 00                	mov    (%eax),%al
  800dd1:	84 c0                	test   %al,%al
  800dd3:	74 03                	je     800dd8 <strncpy+0x31>
			src++;
  800dd5:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800dd8:	ff 45 fc             	incl   -0x4(%ebp)
  800ddb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dde:	3b 45 10             	cmp    0x10(%ebp),%eax
  800de1:	72 d9                	jb     800dbc <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800de3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800de6:	c9                   	leave  
  800de7:	c3                   	ret    

00800de8 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800de8:	55                   	push   %ebp
  800de9:	89 e5                	mov    %esp,%ebp
  800deb:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800dee:	8b 45 08             	mov    0x8(%ebp),%eax
  800df1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800df4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800df8:	74 30                	je     800e2a <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800dfa:	eb 16                	jmp    800e12 <strlcpy+0x2a>
			*dst++ = *src++;
  800dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dff:	8d 50 01             	lea    0x1(%eax),%edx
  800e02:	89 55 08             	mov    %edx,0x8(%ebp)
  800e05:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e08:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e0b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e0e:	8a 12                	mov    (%edx),%dl
  800e10:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e12:	ff 4d 10             	decl   0x10(%ebp)
  800e15:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e19:	74 09                	je     800e24 <strlcpy+0x3c>
  800e1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1e:	8a 00                	mov    (%eax),%al
  800e20:	84 c0                	test   %al,%al
  800e22:	75 d8                	jne    800dfc <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e24:	8b 45 08             	mov    0x8(%ebp),%eax
  800e27:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e2a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e30:	29 c2                	sub    %eax,%edx
  800e32:	89 d0                	mov    %edx,%eax
}
  800e34:	c9                   	leave  
  800e35:	c3                   	ret    

00800e36 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e36:	55                   	push   %ebp
  800e37:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e39:	eb 06                	jmp    800e41 <strcmp+0xb>
		p++, q++;
  800e3b:	ff 45 08             	incl   0x8(%ebp)
  800e3e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e41:	8b 45 08             	mov    0x8(%ebp),%eax
  800e44:	8a 00                	mov    (%eax),%al
  800e46:	84 c0                	test   %al,%al
  800e48:	74 0e                	je     800e58 <strcmp+0x22>
  800e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4d:	8a 10                	mov    (%eax),%dl
  800e4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e52:	8a 00                	mov    (%eax),%al
  800e54:	38 c2                	cmp    %al,%dl
  800e56:	74 e3                	je     800e3b <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e58:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5b:	8a 00                	mov    (%eax),%al
  800e5d:	0f b6 d0             	movzbl %al,%edx
  800e60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e63:	8a 00                	mov    (%eax),%al
  800e65:	0f b6 c0             	movzbl %al,%eax
  800e68:	29 c2                	sub    %eax,%edx
  800e6a:	89 d0                	mov    %edx,%eax
}
  800e6c:	5d                   	pop    %ebp
  800e6d:	c3                   	ret    

00800e6e <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e6e:	55                   	push   %ebp
  800e6f:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e71:	eb 09                	jmp    800e7c <strncmp+0xe>
		n--, p++, q++;
  800e73:	ff 4d 10             	decl   0x10(%ebp)
  800e76:	ff 45 08             	incl   0x8(%ebp)
  800e79:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e7c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e80:	74 17                	je     800e99 <strncmp+0x2b>
  800e82:	8b 45 08             	mov    0x8(%ebp),%eax
  800e85:	8a 00                	mov    (%eax),%al
  800e87:	84 c0                	test   %al,%al
  800e89:	74 0e                	je     800e99 <strncmp+0x2b>
  800e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8e:	8a 10                	mov    (%eax),%dl
  800e90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e93:	8a 00                	mov    (%eax),%al
  800e95:	38 c2                	cmp    %al,%dl
  800e97:	74 da                	je     800e73 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e99:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e9d:	75 07                	jne    800ea6 <strncmp+0x38>
		return 0;
  800e9f:	b8 00 00 00 00       	mov    $0x0,%eax
  800ea4:	eb 14                	jmp    800eba <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea9:	8a 00                	mov    (%eax),%al
  800eab:	0f b6 d0             	movzbl %al,%edx
  800eae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb1:	8a 00                	mov    (%eax),%al
  800eb3:	0f b6 c0             	movzbl %al,%eax
  800eb6:	29 c2                	sub    %eax,%edx
  800eb8:	89 d0                	mov    %edx,%eax
}
  800eba:	5d                   	pop    %ebp
  800ebb:	c3                   	ret    

00800ebc <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ebc:	55                   	push   %ebp
  800ebd:	89 e5                	mov    %esp,%ebp
  800ebf:	83 ec 04             	sub    $0x4,%esp
  800ec2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec5:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ec8:	eb 12                	jmp    800edc <strchr+0x20>
		if (*s == c)
  800eca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecd:	8a 00                	mov    (%eax),%al
  800ecf:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ed2:	75 05                	jne    800ed9 <strchr+0x1d>
			return (char *) s;
  800ed4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed7:	eb 11                	jmp    800eea <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ed9:	ff 45 08             	incl   0x8(%ebp)
  800edc:	8b 45 08             	mov    0x8(%ebp),%eax
  800edf:	8a 00                	mov    (%eax),%al
  800ee1:	84 c0                	test   %al,%al
  800ee3:	75 e5                	jne    800eca <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ee5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800eea:	c9                   	leave  
  800eeb:	c3                   	ret    

00800eec <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800eec:	55                   	push   %ebp
  800eed:	89 e5                	mov    %esp,%ebp
  800eef:	83 ec 04             	sub    $0x4,%esp
  800ef2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef5:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ef8:	eb 0d                	jmp    800f07 <strfind+0x1b>
		if (*s == c)
  800efa:	8b 45 08             	mov    0x8(%ebp),%eax
  800efd:	8a 00                	mov    (%eax),%al
  800eff:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f02:	74 0e                	je     800f12 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f04:	ff 45 08             	incl   0x8(%ebp)
  800f07:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0a:	8a 00                	mov    (%eax),%al
  800f0c:	84 c0                	test   %al,%al
  800f0e:	75 ea                	jne    800efa <strfind+0xe>
  800f10:	eb 01                	jmp    800f13 <strfind+0x27>
		if (*s == c)
			break;
  800f12:	90                   	nop
	return (char *) s;
  800f13:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f16:	c9                   	leave  
  800f17:	c3                   	ret    

00800f18 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800f18:	55                   	push   %ebp
  800f19:	89 e5                	mov    %esp,%ebp
  800f1b:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800f1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f21:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800f24:	8b 45 10             	mov    0x10(%ebp),%eax
  800f27:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800f2a:	eb 0e                	jmp    800f3a <memset+0x22>
		*p++ = c;
  800f2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f2f:	8d 50 01             	lea    0x1(%eax),%edx
  800f32:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f35:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f38:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800f3a:	ff 4d f8             	decl   -0x8(%ebp)
  800f3d:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800f41:	79 e9                	jns    800f2c <memset+0x14>
		*p++ = c;

	return v;
  800f43:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f46:	c9                   	leave  
  800f47:	c3                   	ret    

00800f48 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f48:	55                   	push   %ebp
  800f49:	89 e5                	mov    %esp,%ebp
  800f4b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f51:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f54:	8b 45 08             	mov    0x8(%ebp),%eax
  800f57:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800f5a:	eb 16                	jmp    800f72 <memcpy+0x2a>
		*d++ = *s++;
  800f5c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f5f:	8d 50 01             	lea    0x1(%eax),%edx
  800f62:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f65:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f68:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f6b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f6e:	8a 12                	mov    (%edx),%dl
  800f70:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f72:	8b 45 10             	mov    0x10(%ebp),%eax
  800f75:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f78:	89 55 10             	mov    %edx,0x10(%ebp)
  800f7b:	85 c0                	test   %eax,%eax
  800f7d:	75 dd                	jne    800f5c <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f7f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f82:	c9                   	leave  
  800f83:	c3                   	ret    

00800f84 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f84:	55                   	push   %ebp
  800f85:	89 e5                	mov    %esp,%ebp
  800f87:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f90:	8b 45 08             	mov    0x8(%ebp),%eax
  800f93:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f96:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f99:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f9c:	73 50                	jae    800fee <memmove+0x6a>
  800f9e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fa1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa4:	01 d0                	add    %edx,%eax
  800fa6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fa9:	76 43                	jbe    800fee <memmove+0x6a>
		s += n;
  800fab:	8b 45 10             	mov    0x10(%ebp),%eax
  800fae:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800fb1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb4:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fb7:	eb 10                	jmp    800fc9 <memmove+0x45>
			*--d = *--s;
  800fb9:	ff 4d f8             	decl   -0x8(%ebp)
  800fbc:	ff 4d fc             	decl   -0x4(%ebp)
  800fbf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fc2:	8a 10                	mov    (%eax),%dl
  800fc4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc7:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fc9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcc:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fcf:	89 55 10             	mov    %edx,0x10(%ebp)
  800fd2:	85 c0                	test   %eax,%eax
  800fd4:	75 e3                	jne    800fb9 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fd6:	eb 23                	jmp    800ffb <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fd8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fdb:	8d 50 01             	lea    0x1(%eax),%edx
  800fde:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fe1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fe4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fe7:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fea:	8a 12                	mov    (%edx),%dl
  800fec:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800fee:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ff4:	89 55 10             	mov    %edx,0x10(%ebp)
  800ff7:	85 c0                	test   %eax,%eax
  800ff9:	75 dd                	jne    800fd8 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ffb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ffe:	c9                   	leave  
  800fff:	c3                   	ret    

00801000 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801000:	55                   	push   %ebp
  801001:	89 e5                	mov    %esp,%ebp
  801003:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801006:	8b 45 08             	mov    0x8(%ebp),%eax
  801009:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80100c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100f:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801012:	eb 2a                	jmp    80103e <memcmp+0x3e>
		if (*s1 != *s2)
  801014:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801017:	8a 10                	mov    (%eax),%dl
  801019:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101c:	8a 00                	mov    (%eax),%al
  80101e:	38 c2                	cmp    %al,%dl
  801020:	74 16                	je     801038 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801022:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801025:	8a 00                	mov    (%eax),%al
  801027:	0f b6 d0             	movzbl %al,%edx
  80102a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80102d:	8a 00                	mov    (%eax),%al
  80102f:	0f b6 c0             	movzbl %al,%eax
  801032:	29 c2                	sub    %eax,%edx
  801034:	89 d0                	mov    %edx,%eax
  801036:	eb 18                	jmp    801050 <memcmp+0x50>
		s1++, s2++;
  801038:	ff 45 fc             	incl   -0x4(%ebp)
  80103b:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80103e:	8b 45 10             	mov    0x10(%ebp),%eax
  801041:	8d 50 ff             	lea    -0x1(%eax),%edx
  801044:	89 55 10             	mov    %edx,0x10(%ebp)
  801047:	85 c0                	test   %eax,%eax
  801049:	75 c9                	jne    801014 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80104b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801050:	c9                   	leave  
  801051:	c3                   	ret    

00801052 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801052:	55                   	push   %ebp
  801053:	89 e5                	mov    %esp,%ebp
  801055:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801058:	8b 55 08             	mov    0x8(%ebp),%edx
  80105b:	8b 45 10             	mov    0x10(%ebp),%eax
  80105e:	01 d0                	add    %edx,%eax
  801060:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801063:	eb 15                	jmp    80107a <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801065:	8b 45 08             	mov    0x8(%ebp),%eax
  801068:	8a 00                	mov    (%eax),%al
  80106a:	0f b6 d0             	movzbl %al,%edx
  80106d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801070:	0f b6 c0             	movzbl %al,%eax
  801073:	39 c2                	cmp    %eax,%edx
  801075:	74 0d                	je     801084 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801077:	ff 45 08             	incl   0x8(%ebp)
  80107a:	8b 45 08             	mov    0x8(%ebp),%eax
  80107d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801080:	72 e3                	jb     801065 <memfind+0x13>
  801082:	eb 01                	jmp    801085 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801084:	90                   	nop
	return (void *) s;
  801085:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801088:	c9                   	leave  
  801089:	c3                   	ret    

0080108a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80108a:	55                   	push   %ebp
  80108b:	89 e5                	mov    %esp,%ebp
  80108d:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801090:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801097:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80109e:	eb 03                	jmp    8010a3 <strtol+0x19>
		s++;
  8010a0:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a6:	8a 00                	mov    (%eax),%al
  8010a8:	3c 20                	cmp    $0x20,%al
  8010aa:	74 f4                	je     8010a0 <strtol+0x16>
  8010ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8010af:	8a 00                	mov    (%eax),%al
  8010b1:	3c 09                	cmp    $0x9,%al
  8010b3:	74 eb                	je     8010a0 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b8:	8a 00                	mov    (%eax),%al
  8010ba:	3c 2b                	cmp    $0x2b,%al
  8010bc:	75 05                	jne    8010c3 <strtol+0x39>
		s++;
  8010be:	ff 45 08             	incl   0x8(%ebp)
  8010c1:	eb 13                	jmp    8010d6 <strtol+0x4c>
	else if (*s == '-')
  8010c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c6:	8a 00                	mov    (%eax),%al
  8010c8:	3c 2d                	cmp    $0x2d,%al
  8010ca:	75 0a                	jne    8010d6 <strtol+0x4c>
		s++, neg = 1;
  8010cc:	ff 45 08             	incl   0x8(%ebp)
  8010cf:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010d6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010da:	74 06                	je     8010e2 <strtol+0x58>
  8010dc:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010e0:	75 20                	jne    801102 <strtol+0x78>
  8010e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e5:	8a 00                	mov    (%eax),%al
  8010e7:	3c 30                	cmp    $0x30,%al
  8010e9:	75 17                	jne    801102 <strtol+0x78>
  8010eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ee:	40                   	inc    %eax
  8010ef:	8a 00                	mov    (%eax),%al
  8010f1:	3c 78                	cmp    $0x78,%al
  8010f3:	75 0d                	jne    801102 <strtol+0x78>
		s += 2, base = 16;
  8010f5:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010f9:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801100:	eb 28                	jmp    80112a <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801102:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801106:	75 15                	jne    80111d <strtol+0x93>
  801108:	8b 45 08             	mov    0x8(%ebp),%eax
  80110b:	8a 00                	mov    (%eax),%al
  80110d:	3c 30                	cmp    $0x30,%al
  80110f:	75 0c                	jne    80111d <strtol+0x93>
		s++, base = 8;
  801111:	ff 45 08             	incl   0x8(%ebp)
  801114:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80111b:	eb 0d                	jmp    80112a <strtol+0xa0>
	else if (base == 0)
  80111d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801121:	75 07                	jne    80112a <strtol+0xa0>
		base = 10;
  801123:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80112a:	8b 45 08             	mov    0x8(%ebp),%eax
  80112d:	8a 00                	mov    (%eax),%al
  80112f:	3c 2f                	cmp    $0x2f,%al
  801131:	7e 19                	jle    80114c <strtol+0xc2>
  801133:	8b 45 08             	mov    0x8(%ebp),%eax
  801136:	8a 00                	mov    (%eax),%al
  801138:	3c 39                	cmp    $0x39,%al
  80113a:	7f 10                	jg     80114c <strtol+0xc2>
			dig = *s - '0';
  80113c:	8b 45 08             	mov    0x8(%ebp),%eax
  80113f:	8a 00                	mov    (%eax),%al
  801141:	0f be c0             	movsbl %al,%eax
  801144:	83 e8 30             	sub    $0x30,%eax
  801147:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80114a:	eb 42                	jmp    80118e <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80114c:	8b 45 08             	mov    0x8(%ebp),%eax
  80114f:	8a 00                	mov    (%eax),%al
  801151:	3c 60                	cmp    $0x60,%al
  801153:	7e 19                	jle    80116e <strtol+0xe4>
  801155:	8b 45 08             	mov    0x8(%ebp),%eax
  801158:	8a 00                	mov    (%eax),%al
  80115a:	3c 7a                	cmp    $0x7a,%al
  80115c:	7f 10                	jg     80116e <strtol+0xe4>
			dig = *s - 'a' + 10;
  80115e:	8b 45 08             	mov    0x8(%ebp),%eax
  801161:	8a 00                	mov    (%eax),%al
  801163:	0f be c0             	movsbl %al,%eax
  801166:	83 e8 57             	sub    $0x57,%eax
  801169:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80116c:	eb 20                	jmp    80118e <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80116e:	8b 45 08             	mov    0x8(%ebp),%eax
  801171:	8a 00                	mov    (%eax),%al
  801173:	3c 40                	cmp    $0x40,%al
  801175:	7e 39                	jle    8011b0 <strtol+0x126>
  801177:	8b 45 08             	mov    0x8(%ebp),%eax
  80117a:	8a 00                	mov    (%eax),%al
  80117c:	3c 5a                	cmp    $0x5a,%al
  80117e:	7f 30                	jg     8011b0 <strtol+0x126>
			dig = *s - 'A' + 10;
  801180:	8b 45 08             	mov    0x8(%ebp),%eax
  801183:	8a 00                	mov    (%eax),%al
  801185:	0f be c0             	movsbl %al,%eax
  801188:	83 e8 37             	sub    $0x37,%eax
  80118b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80118e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801191:	3b 45 10             	cmp    0x10(%ebp),%eax
  801194:	7d 19                	jge    8011af <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801196:	ff 45 08             	incl   0x8(%ebp)
  801199:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80119c:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011a0:	89 c2                	mov    %eax,%edx
  8011a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011a5:	01 d0                	add    %edx,%eax
  8011a7:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011aa:	e9 7b ff ff ff       	jmp    80112a <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011af:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011b0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011b4:	74 08                	je     8011be <strtol+0x134>
		*endptr = (char *) s;
  8011b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8011bc:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011be:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011c2:	74 07                	je     8011cb <strtol+0x141>
  8011c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011c7:	f7 d8                	neg    %eax
  8011c9:	eb 03                	jmp    8011ce <strtol+0x144>
  8011cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011ce:	c9                   	leave  
  8011cf:	c3                   	ret    

008011d0 <ltostr>:

void
ltostr(long value, char *str)
{
  8011d0:	55                   	push   %ebp
  8011d1:	89 e5                	mov    %esp,%ebp
  8011d3:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011d6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011dd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011e4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011e8:	79 13                	jns    8011fd <ltostr+0x2d>
	{
		neg = 1;
  8011ea:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f4:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011f7:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8011fa:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8011fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801200:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801205:	99                   	cltd   
  801206:	f7 f9                	idiv   %ecx
  801208:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80120b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80120e:	8d 50 01             	lea    0x1(%eax),%edx
  801211:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801214:	89 c2                	mov    %eax,%edx
  801216:	8b 45 0c             	mov    0xc(%ebp),%eax
  801219:	01 d0                	add    %edx,%eax
  80121b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80121e:	83 c2 30             	add    $0x30,%edx
  801221:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801223:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801226:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80122b:	f7 e9                	imul   %ecx
  80122d:	c1 fa 02             	sar    $0x2,%edx
  801230:	89 c8                	mov    %ecx,%eax
  801232:	c1 f8 1f             	sar    $0x1f,%eax
  801235:	29 c2                	sub    %eax,%edx
  801237:	89 d0                	mov    %edx,%eax
  801239:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80123c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80123f:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801244:	f7 e9                	imul   %ecx
  801246:	c1 fa 02             	sar    $0x2,%edx
  801249:	89 c8                	mov    %ecx,%eax
  80124b:	c1 f8 1f             	sar    $0x1f,%eax
  80124e:	29 c2                	sub    %eax,%edx
  801250:	89 d0                	mov    %edx,%eax
  801252:	c1 e0 02             	shl    $0x2,%eax
  801255:	01 d0                	add    %edx,%eax
  801257:	01 c0                	add    %eax,%eax
  801259:	29 c1                	sub    %eax,%ecx
  80125b:	89 ca                	mov    %ecx,%edx
  80125d:	85 d2                	test   %edx,%edx
  80125f:	75 9c                	jne    8011fd <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801261:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801268:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80126b:	48                   	dec    %eax
  80126c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80126f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801273:	74 3d                	je     8012b2 <ltostr+0xe2>
		start = 1 ;
  801275:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80127c:	eb 34                	jmp    8012b2 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80127e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801281:	8b 45 0c             	mov    0xc(%ebp),%eax
  801284:	01 d0                	add    %edx,%eax
  801286:	8a 00                	mov    (%eax),%al
  801288:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80128b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80128e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801291:	01 c2                	add    %eax,%edx
  801293:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801296:	8b 45 0c             	mov    0xc(%ebp),%eax
  801299:	01 c8                	add    %ecx,%eax
  80129b:	8a 00                	mov    (%eax),%al
  80129d:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80129f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a5:	01 c2                	add    %eax,%edx
  8012a7:	8a 45 eb             	mov    -0x15(%ebp),%al
  8012aa:	88 02                	mov    %al,(%edx)
		start++ ;
  8012ac:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012af:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012b5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012b8:	7c c4                	jl     80127e <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012ba:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c0:	01 d0                	add    %edx,%eax
  8012c2:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012c5:	90                   	nop
  8012c6:	c9                   	leave  
  8012c7:	c3                   	ret    

008012c8 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012c8:	55                   	push   %ebp
  8012c9:	89 e5                	mov    %esp,%ebp
  8012cb:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012ce:	ff 75 08             	pushl  0x8(%ebp)
  8012d1:	e8 54 fa ff ff       	call   800d2a <strlen>
  8012d6:	83 c4 04             	add    $0x4,%esp
  8012d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012dc:	ff 75 0c             	pushl  0xc(%ebp)
  8012df:	e8 46 fa ff ff       	call   800d2a <strlen>
  8012e4:	83 c4 04             	add    $0x4,%esp
  8012e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012ea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012f1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012f8:	eb 17                	jmp    801311 <strcconcat+0x49>
		final[s] = str1[s] ;
  8012fa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801300:	01 c2                	add    %eax,%edx
  801302:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801305:	8b 45 08             	mov    0x8(%ebp),%eax
  801308:	01 c8                	add    %ecx,%eax
  80130a:	8a 00                	mov    (%eax),%al
  80130c:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80130e:	ff 45 fc             	incl   -0x4(%ebp)
  801311:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801314:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801317:	7c e1                	jl     8012fa <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801319:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801320:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801327:	eb 1f                	jmp    801348 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801329:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80132c:	8d 50 01             	lea    0x1(%eax),%edx
  80132f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801332:	89 c2                	mov    %eax,%edx
  801334:	8b 45 10             	mov    0x10(%ebp),%eax
  801337:	01 c2                	add    %eax,%edx
  801339:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80133c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133f:	01 c8                	add    %ecx,%eax
  801341:	8a 00                	mov    (%eax),%al
  801343:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801345:	ff 45 f8             	incl   -0x8(%ebp)
  801348:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80134b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80134e:	7c d9                	jl     801329 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801350:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801353:	8b 45 10             	mov    0x10(%ebp),%eax
  801356:	01 d0                	add    %edx,%eax
  801358:	c6 00 00             	movb   $0x0,(%eax)
}
  80135b:	90                   	nop
  80135c:	c9                   	leave  
  80135d:	c3                   	ret    

0080135e <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80135e:	55                   	push   %ebp
  80135f:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801361:	8b 45 14             	mov    0x14(%ebp),%eax
  801364:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80136a:	8b 45 14             	mov    0x14(%ebp),%eax
  80136d:	8b 00                	mov    (%eax),%eax
  80136f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801376:	8b 45 10             	mov    0x10(%ebp),%eax
  801379:	01 d0                	add    %edx,%eax
  80137b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801381:	eb 0c                	jmp    80138f <strsplit+0x31>
			*string++ = 0;
  801383:	8b 45 08             	mov    0x8(%ebp),%eax
  801386:	8d 50 01             	lea    0x1(%eax),%edx
  801389:	89 55 08             	mov    %edx,0x8(%ebp)
  80138c:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80138f:	8b 45 08             	mov    0x8(%ebp),%eax
  801392:	8a 00                	mov    (%eax),%al
  801394:	84 c0                	test   %al,%al
  801396:	74 18                	je     8013b0 <strsplit+0x52>
  801398:	8b 45 08             	mov    0x8(%ebp),%eax
  80139b:	8a 00                	mov    (%eax),%al
  80139d:	0f be c0             	movsbl %al,%eax
  8013a0:	50                   	push   %eax
  8013a1:	ff 75 0c             	pushl  0xc(%ebp)
  8013a4:	e8 13 fb ff ff       	call   800ebc <strchr>
  8013a9:	83 c4 08             	add    $0x8,%esp
  8013ac:	85 c0                	test   %eax,%eax
  8013ae:	75 d3                	jne    801383 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8013b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b3:	8a 00                	mov    (%eax),%al
  8013b5:	84 c0                	test   %al,%al
  8013b7:	74 5a                	je     801413 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8013bc:	8b 00                	mov    (%eax),%eax
  8013be:	83 f8 0f             	cmp    $0xf,%eax
  8013c1:	75 07                	jne    8013ca <strsplit+0x6c>
		{
			return 0;
  8013c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8013c8:	eb 66                	jmp    801430 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8013cd:	8b 00                	mov    (%eax),%eax
  8013cf:	8d 48 01             	lea    0x1(%eax),%ecx
  8013d2:	8b 55 14             	mov    0x14(%ebp),%edx
  8013d5:	89 0a                	mov    %ecx,(%edx)
  8013d7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013de:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e1:	01 c2                	add    %eax,%edx
  8013e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e6:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013e8:	eb 03                	jmp    8013ed <strsplit+0x8f>
			string++;
  8013ea:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f0:	8a 00                	mov    (%eax),%al
  8013f2:	84 c0                	test   %al,%al
  8013f4:	74 8b                	je     801381 <strsplit+0x23>
  8013f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f9:	8a 00                	mov    (%eax),%al
  8013fb:	0f be c0             	movsbl %al,%eax
  8013fe:	50                   	push   %eax
  8013ff:	ff 75 0c             	pushl  0xc(%ebp)
  801402:	e8 b5 fa ff ff       	call   800ebc <strchr>
  801407:	83 c4 08             	add    $0x8,%esp
  80140a:	85 c0                	test   %eax,%eax
  80140c:	74 dc                	je     8013ea <strsplit+0x8c>
			string++;
	}
  80140e:	e9 6e ff ff ff       	jmp    801381 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801413:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801414:	8b 45 14             	mov    0x14(%ebp),%eax
  801417:	8b 00                	mov    (%eax),%eax
  801419:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801420:	8b 45 10             	mov    0x10(%ebp),%eax
  801423:	01 d0                	add    %edx,%eax
  801425:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80142b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801430:	c9                   	leave  
  801431:	c3                   	ret    

00801432 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801432:	55                   	push   %ebp
  801433:	89 e5                	mov    %esp,%ebp
  801435:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801438:	a1 04 40 80 00       	mov    0x804004,%eax
  80143d:	85 c0                	test   %eax,%eax
  80143f:	74 1f                	je     801460 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801441:	e8 1d 00 00 00       	call   801463 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801446:	83 ec 0c             	sub    $0xc,%esp
  801449:	68 f0 3b 80 00       	push   $0x803bf0
  80144e:	e8 55 f2 ff ff       	call   8006a8 <cprintf>
  801453:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801456:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  80145d:	00 00 00 
	}
}
  801460:	90                   	nop
  801461:	c9                   	leave  
  801462:	c3                   	ret    

00801463 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801463:	55                   	push   %ebp
  801464:	89 e5                	mov    %esp,%ebp
  801466:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  801469:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801470:	00 00 00 
  801473:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80147a:	00 00 00 
  80147d:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801484:	00 00 00 
		LIST_INIT(&AllocMemBlocksList);
  801487:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  80148e:	00 00 00 
  801491:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801498:	00 00 00 
  80149b:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  8014a2:	00 00 00 

		MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES ;
  8014a5:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  8014ac:	00 02 00 
		MemBlockNodes =(struct MemBlock*)USER_DYN_BLKS_ARRAY ;
  8014af:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  8014b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014b9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014be:	2d 00 10 00 00       	sub    $0x1000,%eax
  8014c3:	a3 50 40 80 00       	mov    %eax,0x804050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock),PAGE_SIZE),PERM_USER|PERM_WRITEABLE);
  8014c8:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8014cf:	a1 20 41 80 00       	mov    0x804120,%eax
  8014d4:	c1 e0 04             	shl    $0x4,%eax
  8014d7:	89 c2                	mov    %eax,%edx
  8014d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014dc:	01 d0                	add    %edx,%eax
  8014de:	48                   	dec    %eax
  8014df:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8014e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8014ea:	f7 75 f0             	divl   -0x10(%ebp)
  8014ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014f0:	29 d0                	sub    %edx,%eax
  8014f2:	89 c2                	mov    %eax,%edx
  8014f4:	c7 45 e8 00 00 e0 7f 	movl   $0x7fe00000,-0x18(%ebp)
  8014fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014fe:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801503:	2d 00 10 00 00       	sub    $0x1000,%eax
  801508:	83 ec 04             	sub    $0x4,%esp
  80150b:	6a 06                	push   $0x6
  80150d:	52                   	push   %edx
  80150e:	50                   	push   %eax
  80150f:	e8 71 05 00 00       	call   801a85 <sys_allocate_chunk>
  801514:	83 c4 10             	add    $0x10,%esp
		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801517:	a1 20 41 80 00       	mov    0x804120,%eax
  80151c:	83 ec 0c             	sub    $0xc,%esp
  80151f:	50                   	push   %eax
  801520:	e8 e6 0b 00 00       	call   80210b <initialize_MemBlocksList>
  801525:	83 c4 10             	add    $0x10,%esp

		struct MemBlock  *block_node;
		block_node = AvailableMemBlocksList.lh_first;
  801528:	a1 48 41 80 00       	mov    0x804148,%eax
  80152d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&(AvailableMemBlocksList),block_node);
  801530:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801534:	75 14                	jne    80154a <initialize_dyn_block_system+0xe7>
  801536:	83 ec 04             	sub    $0x4,%esp
  801539:	68 15 3c 80 00       	push   $0x803c15
  80153e:	6a 2b                	push   $0x2b
  801540:	68 33 3c 80 00       	push   $0x803c33
  801545:	e8 aa ee ff ff       	call   8003f4 <_panic>
  80154a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80154d:	8b 00                	mov    (%eax),%eax
  80154f:	85 c0                	test   %eax,%eax
  801551:	74 10                	je     801563 <initialize_dyn_block_system+0x100>
  801553:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801556:	8b 00                	mov    (%eax),%eax
  801558:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80155b:	8b 52 04             	mov    0x4(%edx),%edx
  80155e:	89 50 04             	mov    %edx,0x4(%eax)
  801561:	eb 0b                	jmp    80156e <initialize_dyn_block_system+0x10b>
  801563:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801566:	8b 40 04             	mov    0x4(%eax),%eax
  801569:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80156e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801571:	8b 40 04             	mov    0x4(%eax),%eax
  801574:	85 c0                	test   %eax,%eax
  801576:	74 0f                	je     801587 <initialize_dyn_block_system+0x124>
  801578:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80157b:	8b 40 04             	mov    0x4(%eax),%eax
  80157e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801581:	8b 12                	mov    (%edx),%edx
  801583:	89 10                	mov    %edx,(%eax)
  801585:	eb 0a                	jmp    801591 <initialize_dyn_block_system+0x12e>
  801587:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80158a:	8b 00                	mov    (%eax),%eax
  80158c:	a3 48 41 80 00       	mov    %eax,0x804148
  801591:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801594:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80159a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80159d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8015a4:	a1 54 41 80 00       	mov    0x804154,%eax
  8015a9:	48                   	dec    %eax
  8015aa:	a3 54 41 80 00       	mov    %eax,0x804154
		block_node->sva = USER_HEAP_START ;
  8015af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015b2:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
		block_node->size = ((USER_HEAP_MAX - USER_HEAP_START));
  8015b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015bc:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		insert_sorted_with_merge_freeList(block_node);
  8015c3:	83 ec 0c             	sub    $0xc,%esp
  8015c6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8015c9:	e8 d2 13 00 00       	call   8029a0 <insert_sorted_with_merge_freeList>
  8015ce:	83 c4 10             	add    $0x10,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  8015d1:	90                   	nop
  8015d2:	c9                   	leave  
  8015d3:	c3                   	ret    

008015d4 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8015d4:	55                   	push   %ebp
  8015d5:	89 e5                	mov    %esp,%ebp
  8015d7:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015da:	e8 53 fe ff ff       	call   801432 <InitializeUHeap>
	if (size == 0) return NULL ;
  8015df:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015e3:	75 07                	jne    8015ec <malloc+0x18>
  8015e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8015ea:	eb 61                	jmp    80164d <malloc+0x79>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	size= ROUNDUP(size,PAGE_SIZE);
  8015ec:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8015f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8015f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015f9:	01 d0                	add    %edx,%eax
  8015fb:	48                   	dec    %eax
  8015fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801602:	ba 00 00 00 00       	mov    $0x0,%edx
  801607:	f7 75 f4             	divl   -0xc(%ebp)
  80160a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80160d:	29 d0                	sub    %edx,%eax
  80160f:	89 45 08             	mov    %eax,0x8(%ebp)
	    			if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801612:	e8 3c 08 00 00       	call   801e53 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801617:	85 c0                	test   %eax,%eax
  801619:	74 2d                	je     801648 <malloc+0x74>
	    			{
	    				struct MemBlock * ff_block = alloc_block_FF(size);
  80161b:	83 ec 0c             	sub    $0xc,%esp
  80161e:	ff 75 08             	pushl  0x8(%ebp)
  801621:	e8 3e 0f 00 00       	call   802564 <alloc_block_FF>
  801626:	83 c4 10             	add    $0x10,%esp
  801629:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    				if(ff_block!=NULL)
  80162c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801630:	74 16                	je     801648 <malloc+0x74>
	    				{

	    					insert_sorted_allocList(ff_block);
  801632:	83 ec 0c             	sub    $0xc,%esp
  801635:	ff 75 ec             	pushl  -0x14(%ebp)
  801638:	e8 48 0c 00 00       	call   802285 <insert_sorted_allocList>
  80163d:	83 c4 10             	add    $0x10,%esp
	    					return (void*) ff_block->sva ;
  801640:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801643:	8b 40 08             	mov    0x8(%eax),%eax
  801646:	eb 05                	jmp    80164d <malloc+0x79>

	    				}
	}
	    			return (void*) NULL ;
  801648:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  80164d:	c9                   	leave  
  80164e:	c3                   	ret    

0080164f <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80164f:	55                   	push   %ebp
  801650:	89 e5                	mov    %esp,%ebp
  801652:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock *elementForEach;
		virtual_address = ROUNDDOWN(virtual_address, PAGE_SIZE);
  801655:	8b 45 08             	mov    0x8(%ebp),%eax
  801658:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80165b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80165e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801663:	89 45 08             	mov    %eax,0x8(%ebp)
	//	if (is_mallocPages[indexindex((uint32) virtual_address)] == 1) {
		elementForEach = find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801666:	8b 45 08             	mov    0x8(%ebp),%eax
  801669:	83 ec 08             	sub    $0x8,%esp
  80166c:	50                   	push   %eax
  80166d:	68 40 40 80 00       	push   $0x804040
  801672:	e8 71 0b 00 00       	call   8021e8 <find_block>
  801677:	83 c4 10             	add    $0x10,%esp
  80167a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		sys_free_user_mem((uint32) virtual_address, elementForEach->size);
  80167d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801680:	8b 50 0c             	mov    0xc(%eax),%edx
  801683:	8b 45 08             	mov    0x8(%ebp),%eax
  801686:	83 ec 08             	sub    $0x8,%esp
  801689:	52                   	push   %edx
  80168a:	50                   	push   %eax
  80168b:	e8 bd 03 00 00       	call   801a4d <sys_free_user_mem>
  801690:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,elementForEach);
  801693:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801697:	75 14                	jne    8016ad <free+0x5e>
  801699:	83 ec 04             	sub    $0x4,%esp
  80169c:	68 15 3c 80 00       	push   $0x803c15
  8016a1:	6a 71                	push   $0x71
  8016a3:	68 33 3c 80 00       	push   $0x803c33
  8016a8:	e8 47 ed ff ff       	call   8003f4 <_panic>
  8016ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b0:	8b 00                	mov    (%eax),%eax
  8016b2:	85 c0                	test   %eax,%eax
  8016b4:	74 10                	je     8016c6 <free+0x77>
  8016b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b9:	8b 00                	mov    (%eax),%eax
  8016bb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016be:	8b 52 04             	mov    0x4(%edx),%edx
  8016c1:	89 50 04             	mov    %edx,0x4(%eax)
  8016c4:	eb 0b                	jmp    8016d1 <free+0x82>
  8016c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016c9:	8b 40 04             	mov    0x4(%eax),%eax
  8016cc:	a3 44 40 80 00       	mov    %eax,0x804044
  8016d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016d4:	8b 40 04             	mov    0x4(%eax),%eax
  8016d7:	85 c0                	test   %eax,%eax
  8016d9:	74 0f                	je     8016ea <free+0x9b>
  8016db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016de:	8b 40 04             	mov    0x4(%eax),%eax
  8016e1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016e4:	8b 12                	mov    (%edx),%edx
  8016e6:	89 10                	mov    %edx,(%eax)
  8016e8:	eb 0a                	jmp    8016f4 <free+0xa5>
  8016ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ed:	8b 00                	mov    (%eax),%eax
  8016ef:	a3 40 40 80 00       	mov    %eax,0x804040
  8016f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8016fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801700:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801707:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80170c:	48                   	dec    %eax
  80170d:	a3 4c 40 80 00       	mov    %eax,0x80404c
		insert_sorted_with_merge_freeList(elementForEach);
  801712:	83 ec 0c             	sub    $0xc,%esp
  801715:	ff 75 f0             	pushl  -0x10(%ebp)
  801718:	e8 83 12 00 00       	call   8029a0 <insert_sorted_with_merge_freeList>
  80171d:	83 c4 10             	add    $0x10,%esp
	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801720:	90                   	nop
  801721:	c9                   	leave  
  801722:	c3                   	ret    

00801723 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801723:	55                   	push   %ebp
  801724:	89 e5                	mov    %esp,%ebp
  801726:	83 ec 28             	sub    $0x28,%esp
  801729:	8b 45 10             	mov    0x10(%ebp),%eax
  80172c:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80172f:	e8 fe fc ff ff       	call   801432 <InitializeUHeap>
	if (size == 0) return NULL ;
  801734:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801738:	75 0a                	jne    801744 <smalloc+0x21>
  80173a:	b8 00 00 00 00       	mov    $0x0,%eax
  80173f:	e9 86 00 00 00       	jmp    8017ca <smalloc+0xa7>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code

	size=ROUNDUP(size,PAGE_SIZE);
  801744:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80174b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80174e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801751:	01 d0                	add    %edx,%eax
  801753:	48                   	dec    %eax
  801754:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801757:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80175a:	ba 00 00 00 00       	mov    $0x0,%edx
  80175f:	f7 75 f4             	divl   -0xc(%ebp)
  801762:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801765:	29 d0                	sub    %edx,%eax
  801767:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80176a:	e8 e4 06 00 00       	call   801e53 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80176f:	85 c0                	test   %eax,%eax
  801771:	74 52                	je     8017c5 <smalloc+0xa2>
		{
		struct MemBlock * ff_block ;
		ff_block = alloc_block_FF(size);
  801773:	83 ec 0c             	sub    $0xc,%esp
  801776:	ff 75 0c             	pushl  0xc(%ebp)
  801779:	e8 e6 0d 00 00       	call   802564 <alloc_block_FF>
  80177e:	83 c4 10             	add    $0x10,%esp
  801781:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(ff_block==NULL)
  801784:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801788:	75 07                	jne    801791 <smalloc+0x6e>
			return NULL ;
  80178a:	b8 00 00 00 00       	mov    $0x0,%eax
  80178f:	eb 39                	jmp    8017ca <smalloc+0xa7>

		int obj_id =sys_createSharedObject(sharedVarName,size,isWritable,(void*)ff_block->sva);
  801791:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801794:	8b 40 08             	mov    0x8(%eax),%eax
  801797:	89 c2                	mov    %eax,%edx
  801799:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  80179d:	52                   	push   %edx
  80179e:	50                   	push   %eax
  80179f:	ff 75 0c             	pushl  0xc(%ebp)
  8017a2:	ff 75 08             	pushl  0x8(%ebp)
  8017a5:	e8 2e 04 00 00       	call   801bd8 <sys_createSharedObject>
  8017aa:	83 c4 10             	add    $0x10,%esp
  8017ad:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(obj_id < 0)
  8017b0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8017b4:	79 07                	jns    8017bd <smalloc+0x9a>
			return (void*)NULL ;
  8017b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8017bb:	eb 0d                	jmp    8017ca <smalloc+0xa7>
		else
		    return (void*)ff_block->sva ;
  8017bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017c0:	8b 40 08             	mov    0x8(%eax),%eax
  8017c3:	eb 05                	jmp    8017ca <smalloc+0xa7>
		}
		return (void*)NULL ;
  8017c5:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8017ca:	c9                   	leave  
  8017cb:	c3                   	ret    

008017cc <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8017cc:	55                   	push   %ebp
  8017cd:	89 e5                	mov    %esp,%ebp
  8017cf:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017d2:	e8 5b fc ff ff       	call   801432 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8017d7:	83 ec 08             	sub    $0x8,%esp
  8017da:	ff 75 0c             	pushl  0xc(%ebp)
  8017dd:	ff 75 08             	pushl  0x8(%ebp)
  8017e0:	e8 1d 04 00 00       	call   801c02 <sys_getSizeOfSharedObject>
  8017e5:	83 c4 10             	add    $0x10,%esp
  8017e8:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(size == 0)
  8017eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8017ef:	75 0a                	jne    8017fb <sget+0x2f>
			return NULL ;
  8017f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8017f6:	e9 83 00 00 00       	jmp    80187e <sget+0xb2>
		size=ROUNDUP(size,PAGE_SIZE);
  8017fb:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801802:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801805:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801808:	01 d0                	add    %edx,%eax
  80180a:	48                   	dec    %eax
  80180b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80180e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801811:	ba 00 00 00 00       	mov    $0x0,%edx
  801816:	f7 75 f0             	divl   -0x10(%ebp)
  801819:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80181c:	29 d0                	sub    %edx,%eax
  80181e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801821:	e8 2d 06 00 00       	call   801e53 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801826:	85 c0                	test   %eax,%eax
  801828:	74 4f                	je     801879 <sget+0xad>
		{
			struct MemBlock * ff_block ;
				ff_block = alloc_block_FF(size);
  80182a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80182d:	83 ec 0c             	sub    $0xc,%esp
  801830:	50                   	push   %eax
  801831:	e8 2e 0d 00 00       	call   802564 <alloc_block_FF>
  801836:	83 c4 10             	add    $0x10,%esp
  801839:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ff_block==NULL)
  80183c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801840:	75 07                	jne    801849 <sget+0x7d>
					return (void*)NULL ;
  801842:	b8 00 00 00 00       	mov    $0x0,%eax
  801847:	eb 35                	jmp    80187e <sget+0xb2>

		int obj_id =sys_getSharedObject((int)ownerEnvID,sharedVarName,(void*)ff_block->sva);
  801849:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80184c:	8b 40 08             	mov    0x8(%eax),%eax
  80184f:	83 ec 04             	sub    $0x4,%esp
  801852:	50                   	push   %eax
  801853:	ff 75 0c             	pushl  0xc(%ebp)
  801856:	ff 75 08             	pushl  0x8(%ebp)
  801859:	e8 c1 03 00 00       	call   801c1f <sys_getSharedObject>
  80185e:	83 c4 10             	add    $0x10,%esp
  801861:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if(obj_id<0)
  801864:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801868:	79 07                	jns    801871 <sget+0xa5>
				return (void*)NULL ;
  80186a:	b8 00 00 00 00       	mov    $0x0,%eax
  80186f:	eb 0d                	jmp    80187e <sget+0xb2>
			else
				return (void*)ff_block->sva ;
  801871:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801874:	8b 40 08             	mov    0x8(%eax),%eax
  801877:	eb 05                	jmp    80187e <sget+0xb2>


		}
	return (void*)NULL ;
  801879:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80187e:	c9                   	leave  
  80187f:	c3                   	ret    

00801880 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801880:	55                   	push   %ebp
  801881:	89 e5                	mov    %esp,%ebp
  801883:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801886:	e8 a7 fb ff ff       	call   801432 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80188b:	83 ec 04             	sub    $0x4,%esp
  80188e:	68 40 3c 80 00       	push   $0x803c40
  801893:	68 f9 00 00 00       	push   $0xf9
  801898:	68 33 3c 80 00       	push   $0x803c33
  80189d:	e8 52 eb ff ff       	call   8003f4 <_panic>

008018a2 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8018a2:	55                   	push   %ebp
  8018a3:	89 e5                	mov    %esp,%ebp
  8018a5:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8018a8:	83 ec 04             	sub    $0x4,%esp
  8018ab:	68 68 3c 80 00       	push   $0x803c68
  8018b0:	68 0d 01 00 00       	push   $0x10d
  8018b5:	68 33 3c 80 00       	push   $0x803c33
  8018ba:	e8 35 eb ff ff       	call   8003f4 <_panic>

008018bf <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8018bf:	55                   	push   %ebp
  8018c0:	89 e5                	mov    %esp,%ebp
  8018c2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018c5:	83 ec 04             	sub    $0x4,%esp
  8018c8:	68 8c 3c 80 00       	push   $0x803c8c
  8018cd:	68 18 01 00 00       	push   $0x118
  8018d2:	68 33 3c 80 00       	push   $0x803c33
  8018d7:	e8 18 eb ff ff       	call   8003f4 <_panic>

008018dc <shrink>:

}
void shrink(uint32 newSize)
{
  8018dc:	55                   	push   %ebp
  8018dd:	89 e5                	mov    %esp,%ebp
  8018df:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018e2:	83 ec 04             	sub    $0x4,%esp
  8018e5:	68 8c 3c 80 00       	push   $0x803c8c
  8018ea:	68 1d 01 00 00       	push   $0x11d
  8018ef:	68 33 3c 80 00       	push   $0x803c33
  8018f4:	e8 fb ea ff ff       	call   8003f4 <_panic>

008018f9 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8018f9:	55                   	push   %ebp
  8018fa:	89 e5                	mov    %esp,%ebp
  8018fc:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018ff:	83 ec 04             	sub    $0x4,%esp
  801902:	68 8c 3c 80 00       	push   $0x803c8c
  801907:	68 22 01 00 00       	push   $0x122
  80190c:	68 33 3c 80 00       	push   $0x803c33
  801911:	e8 de ea ff ff       	call   8003f4 <_panic>

00801916 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801916:	55                   	push   %ebp
  801917:	89 e5                	mov    %esp,%ebp
  801919:	57                   	push   %edi
  80191a:	56                   	push   %esi
  80191b:	53                   	push   %ebx
  80191c:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80191f:	8b 45 08             	mov    0x8(%ebp),%eax
  801922:	8b 55 0c             	mov    0xc(%ebp),%edx
  801925:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801928:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80192b:	8b 7d 18             	mov    0x18(%ebp),%edi
  80192e:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801931:	cd 30                	int    $0x30
  801933:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801936:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801939:	83 c4 10             	add    $0x10,%esp
  80193c:	5b                   	pop    %ebx
  80193d:	5e                   	pop    %esi
  80193e:	5f                   	pop    %edi
  80193f:	5d                   	pop    %ebp
  801940:	c3                   	ret    

00801941 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801941:	55                   	push   %ebp
  801942:	89 e5                	mov    %esp,%ebp
  801944:	83 ec 04             	sub    $0x4,%esp
  801947:	8b 45 10             	mov    0x10(%ebp),%eax
  80194a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80194d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801951:	8b 45 08             	mov    0x8(%ebp),%eax
  801954:	6a 00                	push   $0x0
  801956:	6a 00                	push   $0x0
  801958:	52                   	push   %edx
  801959:	ff 75 0c             	pushl  0xc(%ebp)
  80195c:	50                   	push   %eax
  80195d:	6a 00                	push   $0x0
  80195f:	e8 b2 ff ff ff       	call   801916 <syscall>
  801964:	83 c4 18             	add    $0x18,%esp
}
  801967:	90                   	nop
  801968:	c9                   	leave  
  801969:	c3                   	ret    

0080196a <sys_cgetc>:

int
sys_cgetc(void)
{
  80196a:	55                   	push   %ebp
  80196b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80196d:	6a 00                	push   $0x0
  80196f:	6a 00                	push   $0x0
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	6a 00                	push   $0x0
  801977:	6a 01                	push   $0x1
  801979:	e8 98 ff ff ff       	call   801916 <syscall>
  80197e:	83 c4 18             	add    $0x18,%esp
}
  801981:	c9                   	leave  
  801982:	c3                   	ret    

00801983 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801983:	55                   	push   %ebp
  801984:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801986:	8b 55 0c             	mov    0xc(%ebp),%edx
  801989:	8b 45 08             	mov    0x8(%ebp),%eax
  80198c:	6a 00                	push   $0x0
  80198e:	6a 00                	push   $0x0
  801990:	6a 00                	push   $0x0
  801992:	52                   	push   %edx
  801993:	50                   	push   %eax
  801994:	6a 05                	push   $0x5
  801996:	e8 7b ff ff ff       	call   801916 <syscall>
  80199b:	83 c4 18             	add    $0x18,%esp
}
  80199e:	c9                   	leave  
  80199f:	c3                   	ret    

008019a0 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8019a0:	55                   	push   %ebp
  8019a1:	89 e5                	mov    %esp,%ebp
  8019a3:	56                   	push   %esi
  8019a4:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8019a5:	8b 75 18             	mov    0x18(%ebp),%esi
  8019a8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019ab:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b4:	56                   	push   %esi
  8019b5:	53                   	push   %ebx
  8019b6:	51                   	push   %ecx
  8019b7:	52                   	push   %edx
  8019b8:	50                   	push   %eax
  8019b9:	6a 06                	push   $0x6
  8019bb:	e8 56 ff ff ff       	call   801916 <syscall>
  8019c0:	83 c4 18             	add    $0x18,%esp
}
  8019c3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019c6:	5b                   	pop    %ebx
  8019c7:	5e                   	pop    %esi
  8019c8:	5d                   	pop    %ebp
  8019c9:	c3                   	ret    

008019ca <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8019ca:	55                   	push   %ebp
  8019cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8019cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	52                   	push   %edx
  8019da:	50                   	push   %eax
  8019db:	6a 07                	push   $0x7
  8019dd:	e8 34 ff ff ff       	call   801916 <syscall>
  8019e2:	83 c4 18             	add    $0x18,%esp
}
  8019e5:	c9                   	leave  
  8019e6:	c3                   	ret    

008019e7 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8019e7:	55                   	push   %ebp
  8019e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 00                	push   $0x0
  8019f0:	ff 75 0c             	pushl  0xc(%ebp)
  8019f3:	ff 75 08             	pushl  0x8(%ebp)
  8019f6:	6a 08                	push   $0x8
  8019f8:	e8 19 ff ff ff       	call   801916 <syscall>
  8019fd:	83 c4 18             	add    $0x18,%esp
}
  801a00:	c9                   	leave  
  801a01:	c3                   	ret    

00801a02 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a02:	55                   	push   %ebp
  801a03:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 09                	push   $0x9
  801a11:	e8 00 ff ff ff       	call   801916 <syscall>
  801a16:	83 c4 18             	add    $0x18,%esp
}
  801a19:	c9                   	leave  
  801a1a:	c3                   	ret    

00801a1b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a1b:	55                   	push   %ebp
  801a1c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 00                	push   $0x0
  801a22:	6a 00                	push   $0x0
  801a24:	6a 00                	push   $0x0
  801a26:	6a 00                	push   $0x0
  801a28:	6a 0a                	push   $0xa
  801a2a:	e8 e7 fe ff ff       	call   801916 <syscall>
  801a2f:	83 c4 18             	add    $0x18,%esp
}
  801a32:	c9                   	leave  
  801a33:	c3                   	ret    

00801a34 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a34:	55                   	push   %ebp
  801a35:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 00                	push   $0x0
  801a41:	6a 0b                	push   $0xb
  801a43:	e8 ce fe ff ff       	call   801916 <syscall>
  801a48:	83 c4 18             	add    $0x18,%esp
}
  801a4b:	c9                   	leave  
  801a4c:	c3                   	ret    

00801a4d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a4d:	55                   	push   %ebp
  801a4e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	ff 75 0c             	pushl  0xc(%ebp)
  801a59:	ff 75 08             	pushl  0x8(%ebp)
  801a5c:	6a 0f                	push   $0xf
  801a5e:	e8 b3 fe ff ff       	call   801916 <syscall>
  801a63:	83 c4 18             	add    $0x18,%esp
	return;
  801a66:	90                   	nop
}
  801a67:	c9                   	leave  
  801a68:	c3                   	ret    

00801a69 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a69:	55                   	push   %ebp
  801a6a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 00                	push   $0x0
  801a72:	ff 75 0c             	pushl  0xc(%ebp)
  801a75:	ff 75 08             	pushl  0x8(%ebp)
  801a78:	6a 10                	push   $0x10
  801a7a:	e8 97 fe ff ff       	call   801916 <syscall>
  801a7f:	83 c4 18             	add    $0x18,%esp
	return ;
  801a82:	90                   	nop
}
  801a83:	c9                   	leave  
  801a84:	c3                   	ret    

00801a85 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a85:	55                   	push   %ebp
  801a86:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 00                	push   $0x0
  801a8c:	ff 75 10             	pushl  0x10(%ebp)
  801a8f:	ff 75 0c             	pushl  0xc(%ebp)
  801a92:	ff 75 08             	pushl  0x8(%ebp)
  801a95:	6a 11                	push   $0x11
  801a97:	e8 7a fe ff ff       	call   801916 <syscall>
  801a9c:	83 c4 18             	add    $0x18,%esp
	return ;
  801a9f:	90                   	nop
}
  801aa0:	c9                   	leave  
  801aa1:	c3                   	ret    

00801aa2 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801aa2:	55                   	push   %ebp
  801aa3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 0c                	push   $0xc
  801ab1:	e8 60 fe ff ff       	call   801916 <syscall>
  801ab6:	83 c4 18             	add    $0x18,%esp
}
  801ab9:	c9                   	leave  
  801aba:	c3                   	ret    

00801abb <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801abb:	55                   	push   %ebp
  801abc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 00                	push   $0x0
  801ac6:	ff 75 08             	pushl  0x8(%ebp)
  801ac9:	6a 0d                	push   $0xd
  801acb:	e8 46 fe ff ff       	call   801916 <syscall>
  801ad0:	83 c4 18             	add    $0x18,%esp
}
  801ad3:	c9                   	leave  
  801ad4:	c3                   	ret    

00801ad5 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801ad5:	55                   	push   %ebp
  801ad6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 0e                	push   $0xe
  801ae4:	e8 2d fe ff ff       	call   801916 <syscall>
  801ae9:	83 c4 18             	add    $0x18,%esp
}
  801aec:	90                   	nop
  801aed:	c9                   	leave  
  801aee:	c3                   	ret    

00801aef <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801aef:	55                   	push   %ebp
  801af0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	6a 13                	push   $0x13
  801afe:	e8 13 fe ff ff       	call   801916 <syscall>
  801b03:	83 c4 18             	add    $0x18,%esp
}
  801b06:	90                   	nop
  801b07:	c9                   	leave  
  801b08:	c3                   	ret    

00801b09 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801b09:	55                   	push   %ebp
  801b0a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801b0c:	6a 00                	push   $0x0
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	6a 00                	push   $0x0
  801b16:	6a 14                	push   $0x14
  801b18:	e8 f9 fd ff ff       	call   801916 <syscall>
  801b1d:	83 c4 18             	add    $0x18,%esp
}
  801b20:	90                   	nop
  801b21:	c9                   	leave  
  801b22:	c3                   	ret    

00801b23 <sys_cputc>:


void
sys_cputc(const char c)
{
  801b23:	55                   	push   %ebp
  801b24:	89 e5                	mov    %esp,%ebp
  801b26:	83 ec 04             	sub    $0x4,%esp
  801b29:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b2f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b33:	6a 00                	push   $0x0
  801b35:	6a 00                	push   $0x0
  801b37:	6a 00                	push   $0x0
  801b39:	6a 00                	push   $0x0
  801b3b:	50                   	push   %eax
  801b3c:	6a 15                	push   $0x15
  801b3e:	e8 d3 fd ff ff       	call   801916 <syscall>
  801b43:	83 c4 18             	add    $0x18,%esp
}
  801b46:	90                   	nop
  801b47:	c9                   	leave  
  801b48:	c3                   	ret    

00801b49 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b49:	55                   	push   %ebp
  801b4a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 00                	push   $0x0
  801b50:	6a 00                	push   $0x0
  801b52:	6a 00                	push   $0x0
  801b54:	6a 00                	push   $0x0
  801b56:	6a 16                	push   $0x16
  801b58:	e8 b9 fd ff ff       	call   801916 <syscall>
  801b5d:	83 c4 18             	add    $0x18,%esp
}
  801b60:	90                   	nop
  801b61:	c9                   	leave  
  801b62:	c3                   	ret    

00801b63 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801b63:	55                   	push   %ebp
  801b64:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801b66:	8b 45 08             	mov    0x8(%ebp),%eax
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	ff 75 0c             	pushl  0xc(%ebp)
  801b72:	50                   	push   %eax
  801b73:	6a 17                	push   $0x17
  801b75:	e8 9c fd ff ff       	call   801916 <syscall>
  801b7a:	83 c4 18             	add    $0x18,%esp
}
  801b7d:	c9                   	leave  
  801b7e:	c3                   	ret    

00801b7f <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b7f:	55                   	push   %ebp
  801b80:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b82:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b85:	8b 45 08             	mov    0x8(%ebp),%eax
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 00                	push   $0x0
  801b8e:	52                   	push   %edx
  801b8f:	50                   	push   %eax
  801b90:	6a 1a                	push   $0x1a
  801b92:	e8 7f fd ff ff       	call   801916 <syscall>
  801b97:	83 c4 18             	add    $0x18,%esp
}
  801b9a:	c9                   	leave  
  801b9b:	c3                   	ret    

00801b9c <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b9c:	55                   	push   %ebp
  801b9d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	52                   	push   %edx
  801bac:	50                   	push   %eax
  801bad:	6a 18                	push   $0x18
  801baf:	e8 62 fd ff ff       	call   801916 <syscall>
  801bb4:	83 c4 18             	add    $0x18,%esp
}
  801bb7:	90                   	nop
  801bb8:	c9                   	leave  
  801bb9:	c3                   	ret    

00801bba <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801bba:	55                   	push   %ebp
  801bbb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bbd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	52                   	push   %edx
  801bca:	50                   	push   %eax
  801bcb:	6a 19                	push   $0x19
  801bcd:	e8 44 fd ff ff       	call   801916 <syscall>
  801bd2:	83 c4 18             	add    $0x18,%esp
}
  801bd5:	90                   	nop
  801bd6:	c9                   	leave  
  801bd7:	c3                   	ret    

00801bd8 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801bd8:	55                   	push   %ebp
  801bd9:	89 e5                	mov    %esp,%ebp
  801bdb:	83 ec 04             	sub    $0x4,%esp
  801bde:	8b 45 10             	mov    0x10(%ebp),%eax
  801be1:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801be4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801be7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801beb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bee:	6a 00                	push   $0x0
  801bf0:	51                   	push   %ecx
  801bf1:	52                   	push   %edx
  801bf2:	ff 75 0c             	pushl  0xc(%ebp)
  801bf5:	50                   	push   %eax
  801bf6:	6a 1b                	push   $0x1b
  801bf8:	e8 19 fd ff ff       	call   801916 <syscall>
  801bfd:	83 c4 18             	add    $0x18,%esp
}
  801c00:	c9                   	leave  
  801c01:	c3                   	ret    

00801c02 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801c02:	55                   	push   %ebp
  801c03:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801c05:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c08:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	52                   	push   %edx
  801c12:	50                   	push   %eax
  801c13:	6a 1c                	push   $0x1c
  801c15:	e8 fc fc ff ff       	call   801916 <syscall>
  801c1a:	83 c4 18             	add    $0x18,%esp
}
  801c1d:	c9                   	leave  
  801c1e:	c3                   	ret    

00801c1f <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801c1f:	55                   	push   %ebp
  801c20:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801c22:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c25:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c28:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 00                	push   $0x0
  801c2f:	51                   	push   %ecx
  801c30:	52                   	push   %edx
  801c31:	50                   	push   %eax
  801c32:	6a 1d                	push   $0x1d
  801c34:	e8 dd fc ff ff       	call   801916 <syscall>
  801c39:	83 c4 18             	add    $0x18,%esp
}
  801c3c:	c9                   	leave  
  801c3d:	c3                   	ret    

00801c3e <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c3e:	55                   	push   %ebp
  801c3f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c41:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c44:	8b 45 08             	mov    0x8(%ebp),%eax
  801c47:	6a 00                	push   $0x0
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 00                	push   $0x0
  801c4d:	52                   	push   %edx
  801c4e:	50                   	push   %eax
  801c4f:	6a 1e                	push   $0x1e
  801c51:	e8 c0 fc ff ff       	call   801916 <syscall>
  801c56:	83 c4 18             	add    $0x18,%esp
}
  801c59:	c9                   	leave  
  801c5a:	c3                   	ret    

00801c5b <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801c5b:	55                   	push   %ebp
  801c5c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 00                	push   $0x0
  801c62:	6a 00                	push   $0x0
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	6a 1f                	push   $0x1f
  801c6a:	e8 a7 fc ff ff       	call   801916 <syscall>
  801c6f:	83 c4 18             	add    $0x18,%esp
}
  801c72:	c9                   	leave  
  801c73:	c3                   	ret    

00801c74 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c74:	55                   	push   %ebp
  801c75:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c77:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7a:	6a 00                	push   $0x0
  801c7c:	ff 75 14             	pushl  0x14(%ebp)
  801c7f:	ff 75 10             	pushl  0x10(%ebp)
  801c82:	ff 75 0c             	pushl  0xc(%ebp)
  801c85:	50                   	push   %eax
  801c86:	6a 20                	push   $0x20
  801c88:	e8 89 fc ff ff       	call   801916 <syscall>
  801c8d:	83 c4 18             	add    $0x18,%esp
}
  801c90:	c9                   	leave  
  801c91:	c3                   	ret    

00801c92 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c92:	55                   	push   %ebp
  801c93:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c95:	8b 45 08             	mov    0x8(%ebp),%eax
  801c98:	6a 00                	push   $0x0
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 00                	push   $0x0
  801ca0:	50                   	push   %eax
  801ca1:	6a 21                	push   $0x21
  801ca3:	e8 6e fc ff ff       	call   801916 <syscall>
  801ca8:	83 c4 18             	add    $0x18,%esp
}
  801cab:	90                   	nop
  801cac:	c9                   	leave  
  801cad:	c3                   	ret    

00801cae <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801cae:	55                   	push   %ebp
  801caf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 00                	push   $0x0
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	50                   	push   %eax
  801cbd:	6a 22                	push   $0x22
  801cbf:	e8 52 fc ff ff       	call   801916 <syscall>
  801cc4:	83 c4 18             	add    $0x18,%esp
}
  801cc7:	c9                   	leave  
  801cc8:	c3                   	ret    

00801cc9 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801cc9:	55                   	push   %ebp
  801cca:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ccc:	6a 00                	push   $0x0
  801cce:	6a 00                	push   $0x0
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 02                	push   $0x2
  801cd8:	e8 39 fc ff ff       	call   801916 <syscall>
  801cdd:	83 c4 18             	add    $0x18,%esp
}
  801ce0:	c9                   	leave  
  801ce1:	c3                   	ret    

00801ce2 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ce2:	55                   	push   %ebp
  801ce3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 00                	push   $0x0
  801ced:	6a 00                	push   $0x0
  801cef:	6a 03                	push   $0x3
  801cf1:	e8 20 fc ff ff       	call   801916 <syscall>
  801cf6:	83 c4 18             	add    $0x18,%esp
}
  801cf9:	c9                   	leave  
  801cfa:	c3                   	ret    

00801cfb <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801cfb:	55                   	push   %ebp
  801cfc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 00                	push   $0x0
  801d02:	6a 00                	push   $0x0
  801d04:	6a 00                	push   $0x0
  801d06:	6a 00                	push   $0x0
  801d08:	6a 04                	push   $0x4
  801d0a:	e8 07 fc ff ff       	call   801916 <syscall>
  801d0f:	83 c4 18             	add    $0x18,%esp
}
  801d12:	c9                   	leave  
  801d13:	c3                   	ret    

00801d14 <sys_exit_env>:


void sys_exit_env(void)
{
  801d14:	55                   	push   %ebp
  801d15:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801d17:	6a 00                	push   $0x0
  801d19:	6a 00                	push   $0x0
  801d1b:	6a 00                	push   $0x0
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 23                	push   $0x23
  801d23:	e8 ee fb ff ff       	call   801916 <syscall>
  801d28:	83 c4 18             	add    $0x18,%esp
}
  801d2b:	90                   	nop
  801d2c:	c9                   	leave  
  801d2d:	c3                   	ret    

00801d2e <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801d2e:	55                   	push   %ebp
  801d2f:	89 e5                	mov    %esp,%ebp
  801d31:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d34:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d37:	8d 50 04             	lea    0x4(%eax),%edx
  801d3a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	52                   	push   %edx
  801d44:	50                   	push   %eax
  801d45:	6a 24                	push   $0x24
  801d47:	e8 ca fb ff ff       	call   801916 <syscall>
  801d4c:	83 c4 18             	add    $0x18,%esp
	return result;
  801d4f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d52:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d55:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d58:	89 01                	mov    %eax,(%ecx)
  801d5a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d60:	c9                   	leave  
  801d61:	c2 04 00             	ret    $0x4

00801d64 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d64:	55                   	push   %ebp
  801d65:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d67:	6a 00                	push   $0x0
  801d69:	6a 00                	push   $0x0
  801d6b:	ff 75 10             	pushl  0x10(%ebp)
  801d6e:	ff 75 0c             	pushl  0xc(%ebp)
  801d71:	ff 75 08             	pushl  0x8(%ebp)
  801d74:	6a 12                	push   $0x12
  801d76:	e8 9b fb ff ff       	call   801916 <syscall>
  801d7b:	83 c4 18             	add    $0x18,%esp
	return ;
  801d7e:	90                   	nop
}
  801d7f:	c9                   	leave  
  801d80:	c3                   	ret    

00801d81 <sys_rcr2>:
uint32 sys_rcr2()
{
  801d81:	55                   	push   %ebp
  801d82:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d84:	6a 00                	push   $0x0
  801d86:	6a 00                	push   $0x0
  801d88:	6a 00                	push   $0x0
  801d8a:	6a 00                	push   $0x0
  801d8c:	6a 00                	push   $0x0
  801d8e:	6a 25                	push   $0x25
  801d90:	e8 81 fb ff ff       	call   801916 <syscall>
  801d95:	83 c4 18             	add    $0x18,%esp
}
  801d98:	c9                   	leave  
  801d99:	c3                   	ret    

00801d9a <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d9a:	55                   	push   %ebp
  801d9b:	89 e5                	mov    %esp,%ebp
  801d9d:	83 ec 04             	sub    $0x4,%esp
  801da0:	8b 45 08             	mov    0x8(%ebp),%eax
  801da3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801da6:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801daa:	6a 00                	push   $0x0
  801dac:	6a 00                	push   $0x0
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	50                   	push   %eax
  801db3:	6a 26                	push   $0x26
  801db5:	e8 5c fb ff ff       	call   801916 <syscall>
  801dba:	83 c4 18             	add    $0x18,%esp
	return ;
  801dbd:	90                   	nop
}
  801dbe:	c9                   	leave  
  801dbf:	c3                   	ret    

00801dc0 <rsttst>:
void rsttst()
{
  801dc0:	55                   	push   %ebp
  801dc1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801dc3:	6a 00                	push   $0x0
  801dc5:	6a 00                	push   $0x0
  801dc7:	6a 00                	push   $0x0
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 00                	push   $0x0
  801dcd:	6a 28                	push   $0x28
  801dcf:	e8 42 fb ff ff       	call   801916 <syscall>
  801dd4:	83 c4 18             	add    $0x18,%esp
	return ;
  801dd7:	90                   	nop
}
  801dd8:	c9                   	leave  
  801dd9:	c3                   	ret    

00801dda <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801dda:	55                   	push   %ebp
  801ddb:	89 e5                	mov    %esp,%ebp
  801ddd:	83 ec 04             	sub    $0x4,%esp
  801de0:	8b 45 14             	mov    0x14(%ebp),%eax
  801de3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801de6:	8b 55 18             	mov    0x18(%ebp),%edx
  801de9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ded:	52                   	push   %edx
  801dee:	50                   	push   %eax
  801def:	ff 75 10             	pushl  0x10(%ebp)
  801df2:	ff 75 0c             	pushl  0xc(%ebp)
  801df5:	ff 75 08             	pushl  0x8(%ebp)
  801df8:	6a 27                	push   $0x27
  801dfa:	e8 17 fb ff ff       	call   801916 <syscall>
  801dff:	83 c4 18             	add    $0x18,%esp
	return ;
  801e02:	90                   	nop
}
  801e03:	c9                   	leave  
  801e04:	c3                   	ret    

00801e05 <chktst>:
void chktst(uint32 n)
{
  801e05:	55                   	push   %ebp
  801e06:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801e08:	6a 00                	push   $0x0
  801e0a:	6a 00                	push   $0x0
  801e0c:	6a 00                	push   $0x0
  801e0e:	6a 00                	push   $0x0
  801e10:	ff 75 08             	pushl  0x8(%ebp)
  801e13:	6a 29                	push   $0x29
  801e15:	e8 fc fa ff ff       	call   801916 <syscall>
  801e1a:	83 c4 18             	add    $0x18,%esp
	return ;
  801e1d:	90                   	nop
}
  801e1e:	c9                   	leave  
  801e1f:	c3                   	ret    

00801e20 <inctst>:

void inctst()
{
  801e20:	55                   	push   %ebp
  801e21:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e23:	6a 00                	push   $0x0
  801e25:	6a 00                	push   $0x0
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 2a                	push   $0x2a
  801e2f:	e8 e2 fa ff ff       	call   801916 <syscall>
  801e34:	83 c4 18             	add    $0x18,%esp
	return ;
  801e37:	90                   	nop
}
  801e38:	c9                   	leave  
  801e39:	c3                   	ret    

00801e3a <gettst>:
uint32 gettst()
{
  801e3a:	55                   	push   %ebp
  801e3b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 00                	push   $0x0
  801e41:	6a 00                	push   $0x0
  801e43:	6a 00                	push   $0x0
  801e45:	6a 00                	push   $0x0
  801e47:	6a 2b                	push   $0x2b
  801e49:	e8 c8 fa ff ff       	call   801916 <syscall>
  801e4e:	83 c4 18             	add    $0x18,%esp
}
  801e51:	c9                   	leave  
  801e52:	c3                   	ret    

00801e53 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e53:	55                   	push   %ebp
  801e54:	89 e5                	mov    %esp,%ebp
  801e56:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e59:	6a 00                	push   $0x0
  801e5b:	6a 00                	push   $0x0
  801e5d:	6a 00                	push   $0x0
  801e5f:	6a 00                	push   $0x0
  801e61:	6a 00                	push   $0x0
  801e63:	6a 2c                	push   $0x2c
  801e65:	e8 ac fa ff ff       	call   801916 <syscall>
  801e6a:	83 c4 18             	add    $0x18,%esp
  801e6d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e70:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e74:	75 07                	jne    801e7d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e76:	b8 01 00 00 00       	mov    $0x1,%eax
  801e7b:	eb 05                	jmp    801e82 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e7d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e82:	c9                   	leave  
  801e83:	c3                   	ret    

00801e84 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e84:	55                   	push   %ebp
  801e85:	89 e5                	mov    %esp,%ebp
  801e87:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e8a:	6a 00                	push   $0x0
  801e8c:	6a 00                	push   $0x0
  801e8e:	6a 00                	push   $0x0
  801e90:	6a 00                	push   $0x0
  801e92:	6a 00                	push   $0x0
  801e94:	6a 2c                	push   $0x2c
  801e96:	e8 7b fa ff ff       	call   801916 <syscall>
  801e9b:	83 c4 18             	add    $0x18,%esp
  801e9e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801ea1:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801ea5:	75 07                	jne    801eae <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801ea7:	b8 01 00 00 00       	mov    $0x1,%eax
  801eac:	eb 05                	jmp    801eb3 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801eae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eb3:	c9                   	leave  
  801eb4:	c3                   	ret    

00801eb5 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801eb5:	55                   	push   %ebp
  801eb6:	89 e5                	mov    %esp,%ebp
  801eb8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ebb:	6a 00                	push   $0x0
  801ebd:	6a 00                	push   $0x0
  801ebf:	6a 00                	push   $0x0
  801ec1:	6a 00                	push   $0x0
  801ec3:	6a 00                	push   $0x0
  801ec5:	6a 2c                	push   $0x2c
  801ec7:	e8 4a fa ff ff       	call   801916 <syscall>
  801ecc:	83 c4 18             	add    $0x18,%esp
  801ecf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801ed2:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801ed6:	75 07                	jne    801edf <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801ed8:	b8 01 00 00 00       	mov    $0x1,%eax
  801edd:	eb 05                	jmp    801ee4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801edf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ee4:	c9                   	leave  
  801ee5:	c3                   	ret    

00801ee6 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801ee6:	55                   	push   %ebp
  801ee7:	89 e5                	mov    %esp,%ebp
  801ee9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801eec:	6a 00                	push   $0x0
  801eee:	6a 00                	push   $0x0
  801ef0:	6a 00                	push   $0x0
  801ef2:	6a 00                	push   $0x0
  801ef4:	6a 00                	push   $0x0
  801ef6:	6a 2c                	push   $0x2c
  801ef8:	e8 19 fa ff ff       	call   801916 <syscall>
  801efd:	83 c4 18             	add    $0x18,%esp
  801f00:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801f03:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801f07:	75 07                	jne    801f10 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801f09:	b8 01 00 00 00       	mov    $0x1,%eax
  801f0e:	eb 05                	jmp    801f15 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801f10:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f15:	c9                   	leave  
  801f16:	c3                   	ret    

00801f17 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801f17:	55                   	push   %ebp
  801f18:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801f1a:	6a 00                	push   $0x0
  801f1c:	6a 00                	push   $0x0
  801f1e:	6a 00                	push   $0x0
  801f20:	6a 00                	push   $0x0
  801f22:	ff 75 08             	pushl  0x8(%ebp)
  801f25:	6a 2d                	push   $0x2d
  801f27:	e8 ea f9 ff ff       	call   801916 <syscall>
  801f2c:	83 c4 18             	add    $0x18,%esp
	return ;
  801f2f:	90                   	nop
}
  801f30:	c9                   	leave  
  801f31:	c3                   	ret    

00801f32 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f32:	55                   	push   %ebp
  801f33:	89 e5                	mov    %esp,%ebp
  801f35:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f36:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f39:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f42:	6a 00                	push   $0x0
  801f44:	53                   	push   %ebx
  801f45:	51                   	push   %ecx
  801f46:	52                   	push   %edx
  801f47:	50                   	push   %eax
  801f48:	6a 2e                	push   $0x2e
  801f4a:	e8 c7 f9 ff ff       	call   801916 <syscall>
  801f4f:	83 c4 18             	add    $0x18,%esp
}
  801f52:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f55:	c9                   	leave  
  801f56:	c3                   	ret    

00801f57 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f57:	55                   	push   %ebp
  801f58:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f60:	6a 00                	push   $0x0
  801f62:	6a 00                	push   $0x0
  801f64:	6a 00                	push   $0x0
  801f66:	52                   	push   %edx
  801f67:	50                   	push   %eax
  801f68:	6a 2f                	push   $0x2f
  801f6a:	e8 a7 f9 ff ff       	call   801916 <syscall>
  801f6f:	83 c4 18             	add    $0x18,%esp
}
  801f72:	c9                   	leave  
  801f73:	c3                   	ret    

00801f74 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801f74:	55                   	push   %ebp
  801f75:	89 e5                	mov    %esp,%ebp
  801f77:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801f7a:	83 ec 0c             	sub    $0xc,%esp
  801f7d:	68 9c 3c 80 00       	push   $0x803c9c
  801f82:	e8 21 e7 ff ff       	call   8006a8 <cprintf>
  801f87:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801f8a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801f91:	83 ec 0c             	sub    $0xc,%esp
  801f94:	68 c8 3c 80 00       	push   $0x803cc8
  801f99:	e8 0a e7 ff ff       	call   8006a8 <cprintf>
  801f9e:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801fa1:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801fa5:	a1 38 41 80 00       	mov    0x804138,%eax
  801faa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fad:	eb 56                	jmp    802005 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801faf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fb3:	74 1c                	je     801fd1 <print_mem_block_lists+0x5d>
  801fb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb8:	8b 50 08             	mov    0x8(%eax),%edx
  801fbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fbe:	8b 48 08             	mov    0x8(%eax),%ecx
  801fc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fc4:	8b 40 0c             	mov    0xc(%eax),%eax
  801fc7:	01 c8                	add    %ecx,%eax
  801fc9:	39 c2                	cmp    %eax,%edx
  801fcb:	73 04                	jae    801fd1 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801fcd:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801fd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd4:	8b 50 08             	mov    0x8(%eax),%edx
  801fd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fda:	8b 40 0c             	mov    0xc(%eax),%eax
  801fdd:	01 c2                	add    %eax,%edx
  801fdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe2:	8b 40 08             	mov    0x8(%eax),%eax
  801fe5:	83 ec 04             	sub    $0x4,%esp
  801fe8:	52                   	push   %edx
  801fe9:	50                   	push   %eax
  801fea:	68 dd 3c 80 00       	push   $0x803cdd
  801fef:	e8 b4 e6 ff ff       	call   8006a8 <cprintf>
  801ff4:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801ff7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ffa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ffd:	a1 40 41 80 00       	mov    0x804140,%eax
  802002:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802005:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802009:	74 07                	je     802012 <print_mem_block_lists+0x9e>
  80200b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80200e:	8b 00                	mov    (%eax),%eax
  802010:	eb 05                	jmp    802017 <print_mem_block_lists+0xa3>
  802012:	b8 00 00 00 00       	mov    $0x0,%eax
  802017:	a3 40 41 80 00       	mov    %eax,0x804140
  80201c:	a1 40 41 80 00       	mov    0x804140,%eax
  802021:	85 c0                	test   %eax,%eax
  802023:	75 8a                	jne    801faf <print_mem_block_lists+0x3b>
  802025:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802029:	75 84                	jne    801faf <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80202b:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80202f:	75 10                	jne    802041 <print_mem_block_lists+0xcd>
  802031:	83 ec 0c             	sub    $0xc,%esp
  802034:	68 ec 3c 80 00       	push   $0x803cec
  802039:	e8 6a e6 ff ff       	call   8006a8 <cprintf>
  80203e:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802041:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802048:	83 ec 0c             	sub    $0xc,%esp
  80204b:	68 10 3d 80 00       	push   $0x803d10
  802050:	e8 53 e6 ff ff       	call   8006a8 <cprintf>
  802055:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802058:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80205c:	a1 40 40 80 00       	mov    0x804040,%eax
  802061:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802064:	eb 56                	jmp    8020bc <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802066:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80206a:	74 1c                	je     802088 <print_mem_block_lists+0x114>
  80206c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80206f:	8b 50 08             	mov    0x8(%eax),%edx
  802072:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802075:	8b 48 08             	mov    0x8(%eax),%ecx
  802078:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80207b:	8b 40 0c             	mov    0xc(%eax),%eax
  80207e:	01 c8                	add    %ecx,%eax
  802080:	39 c2                	cmp    %eax,%edx
  802082:	73 04                	jae    802088 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802084:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802088:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80208b:	8b 50 08             	mov    0x8(%eax),%edx
  80208e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802091:	8b 40 0c             	mov    0xc(%eax),%eax
  802094:	01 c2                	add    %eax,%edx
  802096:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802099:	8b 40 08             	mov    0x8(%eax),%eax
  80209c:	83 ec 04             	sub    $0x4,%esp
  80209f:	52                   	push   %edx
  8020a0:	50                   	push   %eax
  8020a1:	68 dd 3c 80 00       	push   $0x803cdd
  8020a6:	e8 fd e5 ff ff       	call   8006a8 <cprintf>
  8020ab:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8020ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8020b4:	a1 48 40 80 00       	mov    0x804048,%eax
  8020b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020c0:	74 07                	je     8020c9 <print_mem_block_lists+0x155>
  8020c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c5:	8b 00                	mov    (%eax),%eax
  8020c7:	eb 05                	jmp    8020ce <print_mem_block_lists+0x15a>
  8020c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ce:	a3 48 40 80 00       	mov    %eax,0x804048
  8020d3:	a1 48 40 80 00       	mov    0x804048,%eax
  8020d8:	85 c0                	test   %eax,%eax
  8020da:	75 8a                	jne    802066 <print_mem_block_lists+0xf2>
  8020dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020e0:	75 84                	jne    802066 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8020e2:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8020e6:	75 10                	jne    8020f8 <print_mem_block_lists+0x184>
  8020e8:	83 ec 0c             	sub    $0xc,%esp
  8020eb:	68 28 3d 80 00       	push   $0x803d28
  8020f0:	e8 b3 e5 ff ff       	call   8006a8 <cprintf>
  8020f5:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8020f8:	83 ec 0c             	sub    $0xc,%esp
  8020fb:	68 9c 3c 80 00       	push   $0x803c9c
  802100:	e8 a3 e5 ff ff       	call   8006a8 <cprintf>
  802105:	83 c4 10             	add    $0x10,%esp

}
  802108:	90                   	nop
  802109:	c9                   	leave  
  80210a:	c3                   	ret    

0080210b <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80210b:	55                   	push   %ebp
  80210c:	89 e5                	mov    %esp,%ebp
  80210e:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  802111:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  802118:	00 00 00 
  80211b:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  802122:	00 00 00 
  802125:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  80212c:	00 00 00 
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  80212f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802136:	e9 9e 00 00 00       	jmp    8021d9 <initialize_MemBlocksList+0xce>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
  80213b:	a1 50 40 80 00       	mov    0x804050,%eax
  802140:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802143:	c1 e2 04             	shl    $0x4,%edx
  802146:	01 d0                	add    %edx,%eax
  802148:	85 c0                	test   %eax,%eax
  80214a:	75 14                	jne    802160 <initialize_MemBlocksList+0x55>
  80214c:	83 ec 04             	sub    $0x4,%esp
  80214f:	68 50 3d 80 00       	push   $0x803d50
  802154:	6a 43                	push   $0x43
  802156:	68 73 3d 80 00       	push   $0x803d73
  80215b:	e8 94 e2 ff ff       	call   8003f4 <_panic>
  802160:	a1 50 40 80 00       	mov    0x804050,%eax
  802165:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802168:	c1 e2 04             	shl    $0x4,%edx
  80216b:	01 d0                	add    %edx,%eax
  80216d:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802173:	89 10                	mov    %edx,(%eax)
  802175:	8b 00                	mov    (%eax),%eax
  802177:	85 c0                	test   %eax,%eax
  802179:	74 18                	je     802193 <initialize_MemBlocksList+0x88>
  80217b:	a1 48 41 80 00       	mov    0x804148,%eax
  802180:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802186:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802189:	c1 e1 04             	shl    $0x4,%ecx
  80218c:	01 ca                	add    %ecx,%edx
  80218e:	89 50 04             	mov    %edx,0x4(%eax)
  802191:	eb 12                	jmp    8021a5 <initialize_MemBlocksList+0x9a>
  802193:	a1 50 40 80 00       	mov    0x804050,%eax
  802198:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80219b:	c1 e2 04             	shl    $0x4,%edx
  80219e:	01 d0                	add    %edx,%eax
  8021a0:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8021a5:	a1 50 40 80 00       	mov    0x804050,%eax
  8021aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021ad:	c1 e2 04             	shl    $0x4,%edx
  8021b0:	01 d0                	add    %edx,%eax
  8021b2:	a3 48 41 80 00       	mov    %eax,0x804148
  8021b7:	a1 50 40 80 00       	mov    0x804050,%eax
  8021bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021bf:	c1 e2 04             	shl    $0x4,%edx
  8021c2:	01 d0                	add    %edx,%eax
  8021c4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021cb:	a1 54 41 80 00       	mov    0x804154,%eax
  8021d0:	40                   	inc    %eax
  8021d1:	a3 54 41 80 00       	mov    %eax,0x804154
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  8021d6:	ff 45 f4             	incl   -0xc(%ebp)
  8021d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021dc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021df:	0f 82 56 ff ff ff    	jb     80213b <initialize_MemBlocksList+0x30>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
		}
}
  8021e5:	90                   	nop
  8021e6:	c9                   	leave  
  8021e7:	c3                   	ret    

008021e8 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8021e8:	55                   	push   %ebp
  8021e9:	89 e5                	mov    %esp,%ebp
  8021eb:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  8021ee:	a1 38 41 80 00       	mov    0x804138,%eax
  8021f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021f6:	eb 18                	jmp    802210 <find_block+0x28>
	{
		if (ele->sva==va)
  8021f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021fb:	8b 40 08             	mov    0x8(%eax),%eax
  8021fe:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802201:	75 05                	jne    802208 <find_block+0x20>
			return ele;
  802203:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802206:	eb 7b                	jmp    802283 <find_block+0x9b>
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  802208:	a1 40 41 80 00       	mov    0x804140,%eax
  80220d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802210:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802214:	74 07                	je     80221d <find_block+0x35>
  802216:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802219:	8b 00                	mov    (%eax),%eax
  80221b:	eb 05                	jmp    802222 <find_block+0x3a>
  80221d:	b8 00 00 00 00       	mov    $0x0,%eax
  802222:	a3 40 41 80 00       	mov    %eax,0x804140
  802227:	a1 40 41 80 00       	mov    0x804140,%eax
  80222c:	85 c0                	test   %eax,%eax
  80222e:	75 c8                	jne    8021f8 <find_block+0x10>
  802230:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802234:	75 c2                	jne    8021f8 <find_block+0x10>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  802236:	a1 40 40 80 00       	mov    0x804040,%eax
  80223b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80223e:	eb 18                	jmp    802258 <find_block+0x70>
	{
		if (ele->sva==va)
  802240:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802243:	8b 40 08             	mov    0x8(%eax),%eax
  802246:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802249:	75 05                	jne    802250 <find_block+0x68>
					return ele;
  80224b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80224e:	eb 33                	jmp    802283 <find_block+0x9b>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  802250:	a1 48 40 80 00       	mov    0x804048,%eax
  802255:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802258:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80225c:	74 07                	je     802265 <find_block+0x7d>
  80225e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802261:	8b 00                	mov    (%eax),%eax
  802263:	eb 05                	jmp    80226a <find_block+0x82>
  802265:	b8 00 00 00 00       	mov    $0x0,%eax
  80226a:	a3 48 40 80 00       	mov    %eax,0x804048
  80226f:	a1 48 40 80 00       	mov    0x804048,%eax
  802274:	85 c0                	test   %eax,%eax
  802276:	75 c8                	jne    802240 <find_block+0x58>
  802278:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80227c:	75 c2                	jne    802240 <find_block+0x58>
	{
		if (ele->sva==va)
					return ele;
	}
return NULL;
  80227e:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802283:	c9                   	leave  
  802284:	c3                   	ret    

00802285 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802285:	55                   	push   %ebp
  802286:	89 e5                	mov    %esp,%ebp
  802288:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;

int x =LIST_SIZE(&AllocMemBlocksList);
  80228b:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802290:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((x==0))
  802293:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802297:	75 62                	jne    8022fb <insert_sorted_allocList+0x76>
	{
	//	blockToInsert=AllocMemBlocksList.lh_first;
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  802299:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80229d:	75 14                	jne    8022b3 <insert_sorted_allocList+0x2e>
  80229f:	83 ec 04             	sub    $0x4,%esp
  8022a2:	68 50 3d 80 00       	push   $0x803d50
  8022a7:	6a 69                	push   $0x69
  8022a9:	68 73 3d 80 00       	push   $0x803d73
  8022ae:	e8 41 e1 ff ff       	call   8003f4 <_panic>
  8022b3:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8022b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bc:	89 10                	mov    %edx,(%eax)
  8022be:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c1:	8b 00                	mov    (%eax),%eax
  8022c3:	85 c0                	test   %eax,%eax
  8022c5:	74 0d                	je     8022d4 <insert_sorted_allocList+0x4f>
  8022c7:	a1 40 40 80 00       	mov    0x804040,%eax
  8022cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8022cf:	89 50 04             	mov    %edx,0x4(%eax)
  8022d2:	eb 08                	jmp    8022dc <insert_sorted_allocList+0x57>
  8022d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d7:	a3 44 40 80 00       	mov    %eax,0x804044
  8022dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022df:	a3 40 40 80 00       	mov    %eax,0x804040
  8022e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022ee:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022f3:	40                   	inc    %eax
  8022f4:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8022f9:	eb 72                	jmp    80236d <insert_sorted_allocList+0xe8>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
  8022fb:	a1 40 40 80 00       	mov    0x804040,%eax
  802300:	8b 50 08             	mov    0x8(%eax),%edx
  802303:	8b 45 08             	mov    0x8(%ebp),%eax
  802306:	8b 40 08             	mov    0x8(%eax),%eax
  802309:	39 c2                	cmp    %eax,%edx
  80230b:	76 60                	jbe    80236d <insert_sorted_allocList+0xe8>
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  80230d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802311:	75 14                	jne    802327 <insert_sorted_allocList+0xa2>
  802313:	83 ec 04             	sub    $0x4,%esp
  802316:	68 50 3d 80 00       	push   $0x803d50
  80231b:	6a 6d                	push   $0x6d
  80231d:	68 73 3d 80 00       	push   $0x803d73
  802322:	e8 cd e0 ff ff       	call   8003f4 <_panic>
  802327:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80232d:	8b 45 08             	mov    0x8(%ebp),%eax
  802330:	89 10                	mov    %edx,(%eax)
  802332:	8b 45 08             	mov    0x8(%ebp),%eax
  802335:	8b 00                	mov    (%eax),%eax
  802337:	85 c0                	test   %eax,%eax
  802339:	74 0d                	je     802348 <insert_sorted_allocList+0xc3>
  80233b:	a1 40 40 80 00       	mov    0x804040,%eax
  802340:	8b 55 08             	mov    0x8(%ebp),%edx
  802343:	89 50 04             	mov    %edx,0x4(%eax)
  802346:	eb 08                	jmp    802350 <insert_sorted_allocList+0xcb>
  802348:	8b 45 08             	mov    0x8(%ebp),%eax
  80234b:	a3 44 40 80 00       	mov    %eax,0x804044
  802350:	8b 45 08             	mov    0x8(%ebp),%eax
  802353:	a3 40 40 80 00       	mov    %eax,0x804040
  802358:	8b 45 08             	mov    0x8(%ebp),%eax
  80235b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802362:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802367:	40                   	inc    %eax
  802368:	a3 4c 40 80 00       	mov    %eax,0x80404c
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  80236d:	a1 40 40 80 00       	mov    0x804040,%eax
  802372:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802375:	e9 b9 01 00 00       	jmp    802533 <insert_sorted_allocList+0x2ae>
	{


		if ((blockToInsert->sva>AllocMemBlocksList.lh_first->sva)&&blockToInsert->sva<element->sva)
  80237a:	8b 45 08             	mov    0x8(%ebp),%eax
  80237d:	8b 50 08             	mov    0x8(%eax),%edx
  802380:	a1 40 40 80 00       	mov    0x804040,%eax
  802385:	8b 40 08             	mov    0x8(%eax),%eax
  802388:	39 c2                	cmp    %eax,%edx
  80238a:	76 7c                	jbe    802408 <insert_sorted_allocList+0x183>
  80238c:	8b 45 08             	mov    0x8(%ebp),%eax
  80238f:	8b 50 08             	mov    0x8(%eax),%edx
  802392:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802395:	8b 40 08             	mov    0x8(%eax),%eax
  802398:	39 c2                	cmp    %eax,%edx
  80239a:	73 6c                	jae    802408 <insert_sorted_allocList+0x183>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,element,blockToInsert);
  80239c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023a0:	74 06                	je     8023a8 <insert_sorted_allocList+0x123>
  8023a2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023a6:	75 14                	jne    8023bc <insert_sorted_allocList+0x137>
  8023a8:	83 ec 04             	sub    $0x4,%esp
  8023ab:	68 8c 3d 80 00       	push   $0x803d8c
  8023b0:	6a 75                	push   $0x75
  8023b2:	68 73 3d 80 00       	push   $0x803d73
  8023b7:	e8 38 e0 ff ff       	call   8003f4 <_panic>
  8023bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bf:	8b 50 04             	mov    0x4(%eax),%edx
  8023c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c5:	89 50 04             	mov    %edx,0x4(%eax)
  8023c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023ce:	89 10                	mov    %edx,(%eax)
  8023d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d3:	8b 40 04             	mov    0x4(%eax),%eax
  8023d6:	85 c0                	test   %eax,%eax
  8023d8:	74 0d                	je     8023e7 <insert_sorted_allocList+0x162>
  8023da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023dd:	8b 40 04             	mov    0x4(%eax),%eax
  8023e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8023e3:	89 10                	mov    %edx,(%eax)
  8023e5:	eb 08                	jmp    8023ef <insert_sorted_allocList+0x16a>
  8023e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ea:	a3 40 40 80 00       	mov    %eax,0x804040
  8023ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8023f5:	89 50 04             	mov    %edx,0x4(%eax)
  8023f8:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8023fd:	40                   	inc    %eax
  8023fe:	a3 4c 40 80 00       	mov    %eax,0x80404c

		break;}
  802403:	e9 59 01 00 00       	jmp    802561 <insert_sorted_allocList+0x2dc>

	else if ((blockToInsert->sva>element->sva)&&(blockToInsert->sva<AllocMemBlocksList.lh_last->sva)&&blockToInsert->sva<LIST_NEXT(element)->sva)
  802408:	8b 45 08             	mov    0x8(%ebp),%eax
  80240b:	8b 50 08             	mov    0x8(%eax),%edx
  80240e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802411:	8b 40 08             	mov    0x8(%eax),%eax
  802414:	39 c2                	cmp    %eax,%edx
  802416:	0f 86 98 00 00 00    	jbe    8024b4 <insert_sorted_allocList+0x22f>
  80241c:	8b 45 08             	mov    0x8(%ebp),%eax
  80241f:	8b 50 08             	mov    0x8(%eax),%edx
  802422:	a1 44 40 80 00       	mov    0x804044,%eax
  802427:	8b 40 08             	mov    0x8(%eax),%eax
  80242a:	39 c2                	cmp    %eax,%edx
  80242c:	0f 83 82 00 00 00    	jae    8024b4 <insert_sorted_allocList+0x22f>
  802432:	8b 45 08             	mov    0x8(%ebp),%eax
  802435:	8b 50 08             	mov    0x8(%eax),%edx
  802438:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243b:	8b 00                	mov    (%eax),%eax
  80243d:	8b 40 08             	mov    0x8(%eax),%eax
  802440:	39 c2                	cmp    %eax,%edx
  802442:	73 70                	jae    8024b4 <insert_sorted_allocList+0x22f>
	{

	LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  802444:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802448:	74 06                	je     802450 <insert_sorted_allocList+0x1cb>
  80244a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80244e:	75 14                	jne    802464 <insert_sorted_allocList+0x1df>
  802450:	83 ec 04             	sub    $0x4,%esp
  802453:	68 c4 3d 80 00       	push   $0x803dc4
  802458:	6a 7c                	push   $0x7c
  80245a:	68 73 3d 80 00       	push   $0x803d73
  80245f:	e8 90 df ff ff       	call   8003f4 <_panic>
  802464:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802467:	8b 10                	mov    (%eax),%edx
  802469:	8b 45 08             	mov    0x8(%ebp),%eax
  80246c:	89 10                	mov    %edx,(%eax)
  80246e:	8b 45 08             	mov    0x8(%ebp),%eax
  802471:	8b 00                	mov    (%eax),%eax
  802473:	85 c0                	test   %eax,%eax
  802475:	74 0b                	je     802482 <insert_sorted_allocList+0x1fd>
  802477:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247a:	8b 00                	mov    (%eax),%eax
  80247c:	8b 55 08             	mov    0x8(%ebp),%edx
  80247f:	89 50 04             	mov    %edx,0x4(%eax)
  802482:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802485:	8b 55 08             	mov    0x8(%ebp),%edx
  802488:	89 10                	mov    %edx,(%eax)
  80248a:	8b 45 08             	mov    0x8(%ebp),%eax
  80248d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802490:	89 50 04             	mov    %edx,0x4(%eax)
  802493:	8b 45 08             	mov    0x8(%ebp),%eax
  802496:	8b 00                	mov    (%eax),%eax
  802498:	85 c0                	test   %eax,%eax
  80249a:	75 08                	jne    8024a4 <insert_sorted_allocList+0x21f>
  80249c:	8b 45 08             	mov    0x8(%ebp),%eax
  80249f:	a3 44 40 80 00       	mov    %eax,0x804044
  8024a4:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8024a9:	40                   	inc    %eax
  8024aa:	a3 4c 40 80 00       	mov    %eax,0x80404c
		break;
  8024af:	e9 ad 00 00 00       	jmp    802561 <insert_sorted_allocList+0x2dc>
	}else if (blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  8024b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b7:	8b 50 08             	mov    0x8(%eax),%edx
  8024ba:	a1 44 40 80 00       	mov    0x804044,%eax
  8024bf:	8b 40 08             	mov    0x8(%eax),%eax
  8024c2:	39 c2                	cmp    %eax,%edx
  8024c4:	76 65                	jbe    80252b <insert_sorted_allocList+0x2a6>
	{
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
  8024c6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024ca:	75 17                	jne    8024e3 <insert_sorted_allocList+0x25e>
  8024cc:	83 ec 04             	sub    $0x4,%esp
  8024cf:	68 f8 3d 80 00       	push   $0x803df8
  8024d4:	68 80 00 00 00       	push   $0x80
  8024d9:	68 73 3d 80 00       	push   $0x803d73
  8024de:	e8 11 df ff ff       	call   8003f4 <_panic>
  8024e3:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8024e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ec:	89 50 04             	mov    %edx,0x4(%eax)
  8024ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f2:	8b 40 04             	mov    0x4(%eax),%eax
  8024f5:	85 c0                	test   %eax,%eax
  8024f7:	74 0c                	je     802505 <insert_sorted_allocList+0x280>
  8024f9:	a1 44 40 80 00       	mov    0x804044,%eax
  8024fe:	8b 55 08             	mov    0x8(%ebp),%edx
  802501:	89 10                	mov    %edx,(%eax)
  802503:	eb 08                	jmp    80250d <insert_sorted_allocList+0x288>
  802505:	8b 45 08             	mov    0x8(%ebp),%eax
  802508:	a3 40 40 80 00       	mov    %eax,0x804040
  80250d:	8b 45 08             	mov    0x8(%ebp),%eax
  802510:	a3 44 40 80 00       	mov    %eax,0x804044
  802515:	8b 45 08             	mov    0x8(%ebp),%eax
  802518:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80251e:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802523:	40                   	inc    %eax
  802524:	a3 4c 40 80 00       	mov    %eax,0x80404c
		break;
  802529:	eb 36                	jmp    802561 <insert_sorted_allocList+0x2dc>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  80252b:	a1 48 40 80 00       	mov    0x804048,%eax
  802530:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802533:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802537:	74 07                	je     802540 <insert_sorted_allocList+0x2bb>
  802539:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253c:	8b 00                	mov    (%eax),%eax
  80253e:	eb 05                	jmp    802545 <insert_sorted_allocList+0x2c0>
  802540:	b8 00 00 00 00       	mov    $0x0,%eax
  802545:	a3 48 40 80 00       	mov    %eax,0x804048
  80254a:	a1 48 40 80 00       	mov    0x804048,%eax
  80254f:	85 c0                	test   %eax,%eax
  802551:	0f 85 23 fe ff ff    	jne    80237a <insert_sorted_allocList+0xf5>
  802557:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80255b:	0f 85 19 fe ff ff    	jne    80237a <insert_sorted_allocList+0xf5>
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
		break;

	}
	}
}
  802561:	90                   	nop
  802562:	c9                   	leave  
  802563:	c3                   	ret    

00802564 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802564:	55                   	push   %ebp
  802565:	89 e5                	mov    %esp,%ebp
  802567:	83 ec 18             	sub    $0x18,%esp
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  80256a:	a1 38 41 80 00       	mov    0x804138,%eax
  80256f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802572:	e9 7c 01 00 00       	jmp    8026f3 <alloc_block_FF+0x18f>
		{
			// case 2
				if(element->size == size)
  802577:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257a:	8b 40 0c             	mov    0xc(%eax),%eax
  80257d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802580:	0f 85 90 00 00 00    	jne    802616 <alloc_block_FF+0xb2>
				{
					tmp_block=element;
  802586:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802589:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,element);
  80258c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802590:	75 17                	jne    8025a9 <alloc_block_FF+0x45>
  802592:	83 ec 04             	sub    $0x4,%esp
  802595:	68 1b 3e 80 00       	push   $0x803e1b
  80259a:	68 ba 00 00 00       	push   $0xba
  80259f:	68 73 3d 80 00       	push   $0x803d73
  8025a4:	e8 4b de ff ff       	call   8003f4 <_panic>
  8025a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ac:	8b 00                	mov    (%eax),%eax
  8025ae:	85 c0                	test   %eax,%eax
  8025b0:	74 10                	je     8025c2 <alloc_block_FF+0x5e>
  8025b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b5:	8b 00                	mov    (%eax),%eax
  8025b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025ba:	8b 52 04             	mov    0x4(%edx),%edx
  8025bd:	89 50 04             	mov    %edx,0x4(%eax)
  8025c0:	eb 0b                	jmp    8025cd <alloc_block_FF+0x69>
  8025c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c5:	8b 40 04             	mov    0x4(%eax),%eax
  8025c8:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8025cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d0:	8b 40 04             	mov    0x4(%eax),%eax
  8025d3:	85 c0                	test   %eax,%eax
  8025d5:	74 0f                	je     8025e6 <alloc_block_FF+0x82>
  8025d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025da:	8b 40 04             	mov    0x4(%eax),%eax
  8025dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025e0:	8b 12                	mov    (%edx),%edx
  8025e2:	89 10                	mov    %edx,(%eax)
  8025e4:	eb 0a                	jmp    8025f0 <alloc_block_FF+0x8c>
  8025e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e9:	8b 00                	mov    (%eax),%eax
  8025eb:	a3 38 41 80 00       	mov    %eax,0x804138
  8025f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802603:	a1 44 41 80 00       	mov    0x804144,%eax
  802608:	48                   	dec    %eax
  802609:	a3 44 41 80 00       	mov    %eax,0x804144
					return tmp_block;
  80260e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802611:	e9 10 01 00 00       	jmp    802726 <alloc_block_FF+0x1c2>
				}
				 // case 3
				else if(element->size > size)
  802616:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802619:	8b 40 0c             	mov    0xc(%eax),%eax
  80261c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80261f:	0f 86 c6 00 00 00    	jbe    8026eb <alloc_block_FF+0x187>
				{
					// the new block are created
					tmp_block = AvailableMemBlocksList.lh_first ;
  802625:	a1 48 41 80 00       	mov    0x804148,%eax
  80262a:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  80262d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802631:	75 17                	jne    80264a <alloc_block_FF+0xe6>
  802633:	83 ec 04             	sub    $0x4,%esp
  802636:	68 1b 3e 80 00       	push   $0x803e1b
  80263b:	68 c2 00 00 00       	push   $0xc2
  802640:	68 73 3d 80 00       	push   $0x803d73
  802645:	e8 aa dd ff ff       	call   8003f4 <_panic>
  80264a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80264d:	8b 00                	mov    (%eax),%eax
  80264f:	85 c0                	test   %eax,%eax
  802651:	74 10                	je     802663 <alloc_block_FF+0xff>
  802653:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802656:	8b 00                	mov    (%eax),%eax
  802658:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80265b:	8b 52 04             	mov    0x4(%edx),%edx
  80265e:	89 50 04             	mov    %edx,0x4(%eax)
  802661:	eb 0b                	jmp    80266e <alloc_block_FF+0x10a>
  802663:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802666:	8b 40 04             	mov    0x4(%eax),%eax
  802669:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80266e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802671:	8b 40 04             	mov    0x4(%eax),%eax
  802674:	85 c0                	test   %eax,%eax
  802676:	74 0f                	je     802687 <alloc_block_FF+0x123>
  802678:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80267b:	8b 40 04             	mov    0x4(%eax),%eax
  80267e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802681:	8b 12                	mov    (%edx),%edx
  802683:	89 10                	mov    %edx,(%eax)
  802685:	eb 0a                	jmp    802691 <alloc_block_FF+0x12d>
  802687:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80268a:	8b 00                	mov    (%eax),%eax
  80268c:	a3 48 41 80 00       	mov    %eax,0x804148
  802691:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802694:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80269a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80269d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026a4:	a1 54 41 80 00       	mov    0x804154,%eax
  8026a9:	48                   	dec    %eax
  8026aa:	a3 54 41 80 00       	mov    %eax,0x804154
					tmp_block->sva=element->sva;
  8026af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b2:	8b 50 08             	mov    0x8(%eax),%edx
  8026b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026b8:	89 50 08             	mov    %edx,0x8(%eax)
					tmp_block->size=size;
  8026bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026be:	8b 55 08             	mov    0x8(%ebp),%edx
  8026c1:	89 50 0c             	mov    %edx,0xc(%eax)
					//update block with remaining space
					element->size-=size;
  8026c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8026ca:	2b 45 08             	sub    0x8(%ebp),%eax
  8026cd:	89 c2                	mov    %eax,%edx
  8026cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d2:	89 50 0c             	mov    %edx,0xc(%eax)
					element->sva = element->sva + size;
  8026d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d8:	8b 50 08             	mov    0x8(%eax),%edx
  8026db:	8b 45 08             	mov    0x8(%ebp),%eax
  8026de:	01 c2                	add    %eax,%edx
  8026e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e3:	89 50 08             	mov    %edx,0x8(%eax)
					// return back the new block
					return tmp_block ;
  8026e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026e9:	eb 3b                	jmp    802726 <alloc_block_FF+0x1c2>
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  8026eb:	a1 40 41 80 00       	mov    0x804140,%eax
  8026f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026f7:	74 07                	je     802700 <alloc_block_FF+0x19c>
  8026f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fc:	8b 00                	mov    (%eax),%eax
  8026fe:	eb 05                	jmp    802705 <alloc_block_FF+0x1a1>
  802700:	b8 00 00 00 00       	mov    $0x0,%eax
  802705:	a3 40 41 80 00       	mov    %eax,0x804140
  80270a:	a1 40 41 80 00       	mov    0x804140,%eax
  80270f:	85 c0                	test   %eax,%eax
  802711:	0f 85 60 fe ff ff    	jne    802577 <alloc_block_FF+0x13>
  802717:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80271b:	0f 85 56 fe ff ff    	jne    802577 <alloc_block_FF+0x13>
					// return back the new block
					return tmp_block ;
				}
		}
		// case 1
	  return NULL ;}
  802721:	b8 00 00 00 00       	mov    $0x0,%eax
  802726:	c9                   	leave  
  802727:	c3                   	ret    

00802728 <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================

struct MemBlock *alloc_block_BF(uint32 size)
{
  802728:	55                   	push   %ebp
  802729:	89 e5                	mov    %esp,%ebp
  80272b:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
  80272e:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802735:	a1 38 41 80 00       	mov    0x804138,%eax
  80273a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80273d:	eb 3a                	jmp    802779 <alloc_block_BF+0x51>
		{
			if(element->size >= size)
  80273f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802742:	8b 40 0c             	mov    0xc(%eax),%eax
  802745:	3b 45 08             	cmp    0x8(%ebp),%eax
  802748:	72 27                	jb     802771 <alloc_block_BF+0x49>
			{
				if(best_size==-1)
  80274a:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80274e:	75 0b                	jne    80275b <alloc_block_BF+0x33>
					best_size= element->size;
  802750:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802753:	8b 40 0c             	mov    0xc(%eax),%eax
  802756:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802759:	eb 16                	jmp    802771 <alloc_block_BF+0x49>
				else if(best_size >= element->size)
  80275b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275e:	8b 50 0c             	mov    0xc(%eax),%edx
  802761:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802764:	39 c2                	cmp    %eax,%edx
  802766:	77 09                	ja     802771 <alloc_block_BF+0x49>
					best_size=element->size;
  802768:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276b:	8b 40 0c             	mov    0xc(%eax),%eax
  80276e:	89 45 f0             	mov    %eax,-0x10(%ebp)

struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802771:	a1 40 41 80 00       	mov    0x804140,%eax
  802776:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802779:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80277d:	74 07                	je     802786 <alloc_block_BF+0x5e>
  80277f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802782:	8b 00                	mov    (%eax),%eax
  802784:	eb 05                	jmp    80278b <alloc_block_BF+0x63>
  802786:	b8 00 00 00 00       	mov    $0x0,%eax
  80278b:	a3 40 41 80 00       	mov    %eax,0x804140
  802790:	a1 40 41 80 00       	mov    0x804140,%eax
  802795:	85 c0                	test   %eax,%eax
  802797:	75 a6                	jne    80273f <alloc_block_BF+0x17>
  802799:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80279d:	75 a0                	jne    80273f <alloc_block_BF+0x17>
					best_size= element->size;
				else if(best_size >= element->size)
					best_size=element->size;
			}
		}
		if(best_size != -1)
  80279f:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8027a3:	0f 84 d3 01 00 00    	je     80297c <alloc_block_BF+0x254>
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  8027a9:	a1 38 41 80 00       	mov    0x804138,%eax
  8027ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027b1:	e9 98 01 00 00       	jmp    80294e <alloc_block_BF+0x226>
			{
			 if((best_size > size) && (best_size == element->size))
  8027b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027bc:	0f 86 da 00 00 00    	jbe    80289c <alloc_block_BF+0x174>
  8027c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c5:	8b 50 0c             	mov    0xc(%eax),%edx
  8027c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027cb:	39 c2                	cmp    %eax,%edx
  8027cd:	0f 85 c9 00 00 00    	jne    80289c <alloc_block_BF+0x174>
			  {
				// the new block are created
			    tmp_block = AvailableMemBlocksList.lh_first ;
  8027d3:	a1 48 41 80 00       	mov    0x804148,%eax
  8027d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  8027db:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8027df:	75 17                	jne    8027f8 <alloc_block_BF+0xd0>
  8027e1:	83 ec 04             	sub    $0x4,%esp
  8027e4:	68 1b 3e 80 00       	push   $0x803e1b
  8027e9:	68 ea 00 00 00       	push   $0xea
  8027ee:	68 73 3d 80 00       	push   $0x803d73
  8027f3:	e8 fc db ff ff       	call   8003f4 <_panic>
  8027f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027fb:	8b 00                	mov    (%eax),%eax
  8027fd:	85 c0                	test   %eax,%eax
  8027ff:	74 10                	je     802811 <alloc_block_BF+0xe9>
  802801:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802804:	8b 00                	mov    (%eax),%eax
  802806:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802809:	8b 52 04             	mov    0x4(%edx),%edx
  80280c:	89 50 04             	mov    %edx,0x4(%eax)
  80280f:	eb 0b                	jmp    80281c <alloc_block_BF+0xf4>
  802811:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802814:	8b 40 04             	mov    0x4(%eax),%eax
  802817:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80281c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80281f:	8b 40 04             	mov    0x4(%eax),%eax
  802822:	85 c0                	test   %eax,%eax
  802824:	74 0f                	je     802835 <alloc_block_BF+0x10d>
  802826:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802829:	8b 40 04             	mov    0x4(%eax),%eax
  80282c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80282f:	8b 12                	mov    (%edx),%edx
  802831:	89 10                	mov    %edx,(%eax)
  802833:	eb 0a                	jmp    80283f <alloc_block_BF+0x117>
  802835:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802838:	8b 00                	mov    (%eax),%eax
  80283a:	a3 48 41 80 00       	mov    %eax,0x804148
  80283f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802842:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802848:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80284b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802852:	a1 54 41 80 00       	mov    0x804154,%eax
  802857:	48                   	dec    %eax
  802858:	a3 54 41 80 00       	mov    %eax,0x804154
				tmp_block->sva=element->sva;
  80285d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802860:	8b 50 08             	mov    0x8(%eax),%edx
  802863:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802866:	89 50 08             	mov    %edx,0x8(%eax)
				tmp_block->size=size;
  802869:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80286c:	8b 55 08             	mov    0x8(%ebp),%edx
  80286f:	89 50 0c             	mov    %edx,0xc(%eax)
				//update block with remaining space
				element->size-=size;
  802872:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802875:	8b 40 0c             	mov    0xc(%eax),%eax
  802878:	2b 45 08             	sub    0x8(%ebp),%eax
  80287b:	89 c2                	mov    %eax,%edx
  80287d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802880:	89 50 0c             	mov    %edx,0xc(%eax)
				element->sva = element->sva + size;
  802883:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802886:	8b 50 08             	mov    0x8(%eax),%edx
  802889:	8b 45 08             	mov    0x8(%ebp),%eax
  80288c:	01 c2                	add    %eax,%edx
  80288e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802891:	89 50 08             	mov    %edx,0x8(%eax)
				// return back the new block
				return tmp_block ;
  802894:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802897:	e9 e5 00 00 00       	jmp    802981 <alloc_block_BF+0x259>

			  }
			else if((element->size == best_size)&&(best_size == size))
  80289c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289f:	8b 50 0c             	mov    0xc(%eax),%edx
  8028a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a5:	39 c2                	cmp    %eax,%edx
  8028a7:	0f 85 99 00 00 00    	jne    802946 <alloc_block_BF+0x21e>
  8028ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028b3:	0f 85 8d 00 00 00    	jne    802946 <alloc_block_BF+0x21e>
			  {
				tmp_block=element;
  8028b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bc:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&FreeMemBlocksList,element);
  8028bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028c3:	75 17                	jne    8028dc <alloc_block_BF+0x1b4>
  8028c5:	83 ec 04             	sub    $0x4,%esp
  8028c8:	68 1b 3e 80 00       	push   $0x803e1b
  8028cd:	68 f7 00 00 00       	push   $0xf7
  8028d2:	68 73 3d 80 00       	push   $0x803d73
  8028d7:	e8 18 db ff ff       	call   8003f4 <_panic>
  8028dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028df:	8b 00                	mov    (%eax),%eax
  8028e1:	85 c0                	test   %eax,%eax
  8028e3:	74 10                	je     8028f5 <alloc_block_BF+0x1cd>
  8028e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e8:	8b 00                	mov    (%eax),%eax
  8028ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028ed:	8b 52 04             	mov    0x4(%edx),%edx
  8028f0:	89 50 04             	mov    %edx,0x4(%eax)
  8028f3:	eb 0b                	jmp    802900 <alloc_block_BF+0x1d8>
  8028f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f8:	8b 40 04             	mov    0x4(%eax),%eax
  8028fb:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802900:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802903:	8b 40 04             	mov    0x4(%eax),%eax
  802906:	85 c0                	test   %eax,%eax
  802908:	74 0f                	je     802919 <alloc_block_BF+0x1f1>
  80290a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290d:	8b 40 04             	mov    0x4(%eax),%eax
  802910:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802913:	8b 12                	mov    (%edx),%edx
  802915:	89 10                	mov    %edx,(%eax)
  802917:	eb 0a                	jmp    802923 <alloc_block_BF+0x1fb>
  802919:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291c:	8b 00                	mov    (%eax),%eax
  80291e:	a3 38 41 80 00       	mov    %eax,0x804138
  802923:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802926:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80292c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802936:	a1 44 41 80 00       	mov    0x804144,%eax
  80293b:	48                   	dec    %eax
  80293c:	a3 44 41 80 00       	mov    %eax,0x804144
				return tmp_block;
  802941:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802944:	eb 3b                	jmp    802981 <alloc_block_BF+0x259>
					best_size=element->size;
			}
		}
		if(best_size != -1)
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  802946:	a1 40 41 80 00       	mov    0x804140,%eax
  80294b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80294e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802952:	74 07                	je     80295b <alloc_block_BF+0x233>
  802954:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802957:	8b 00                	mov    (%eax),%eax
  802959:	eb 05                	jmp    802960 <alloc_block_BF+0x238>
  80295b:	b8 00 00 00 00       	mov    $0x0,%eax
  802960:	a3 40 41 80 00       	mov    %eax,0x804140
  802965:	a1 40 41 80 00       	mov    0x804140,%eax
  80296a:	85 c0                	test   %eax,%eax
  80296c:	0f 85 44 fe ff ff    	jne    8027b6 <alloc_block_BF+0x8e>
  802972:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802976:	0f 85 3a fe ff ff    	jne    8027b6 <alloc_block_BF+0x8e>
				LIST_REMOVE(&FreeMemBlocksList,element);
				return tmp_block;
			 }
			}
		}
		return NULL ;}
  80297c:	b8 00 00 00 00       	mov    $0x0,%eax
  802981:	c9                   	leave  
  802982:	c3                   	ret    

00802983 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802983:	55                   	push   %ebp
  802984:	89 e5                	mov    %esp,%ebp
  802986:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802989:	83 ec 04             	sub    $0x4,%esp
  80298c:	68 3c 3e 80 00       	push   $0x803e3c
  802991:	68 04 01 00 00       	push   $0x104
  802996:	68 73 3d 80 00       	push   $0x803d73
  80299b:	e8 54 da ff ff       	call   8003f4 <_panic>

008029a0 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{struct MemBlock * blk_itr;
  8029a0:	55                   	push   %ebp
  8029a1:	89 e5                	mov    %esp,%ebp
  8029a3:	83 ec 18             	sub    $0x18,%esp
struct MemBlock * next;
struct MemBlock * first = LIST_FIRST(&(FreeMemBlocksList));
  8029a6:	a1 38 41 80 00       	mov    0x804138,%eax
  8029ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
struct MemBlock * last = LIST_LAST(&(FreeMemBlocksList));
  8029ae:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8029b3:	89 45 ec             	mov    %eax,-0x14(%ebp)

if(LIST_EMPTY(&(FreeMemBlocksList)))
  8029b6:	a1 38 41 80 00       	mov    0x804138,%eax
  8029bb:	85 c0                	test   %eax,%eax
  8029bd:	75 68                	jne    802a27 <insert_sorted_with_merge_freeList+0x87>
			{

				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  8029bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029c3:	75 17                	jne    8029dc <insert_sorted_with_merge_freeList+0x3c>
  8029c5:	83 ec 04             	sub    $0x4,%esp
  8029c8:	68 50 3d 80 00       	push   $0x803d50
  8029cd:	68 14 01 00 00       	push   $0x114
  8029d2:	68 73 3d 80 00       	push   $0x803d73
  8029d7:	e8 18 da ff ff       	call   8003f4 <_panic>
  8029dc:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8029e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e5:	89 10                	mov    %edx,(%eax)
  8029e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ea:	8b 00                	mov    (%eax),%eax
  8029ec:	85 c0                	test   %eax,%eax
  8029ee:	74 0d                	je     8029fd <insert_sorted_with_merge_freeList+0x5d>
  8029f0:	a1 38 41 80 00       	mov    0x804138,%eax
  8029f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8029f8:	89 50 04             	mov    %edx,0x4(%eax)
  8029fb:	eb 08                	jmp    802a05 <insert_sorted_with_merge_freeList+0x65>
  8029fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802a00:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a05:	8b 45 08             	mov    0x8(%ebp),%eax
  802a08:	a3 38 41 80 00       	mov    %eax,0x804138
  802a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a10:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a17:	a1 44 41 80 00       	mov    0x804144,%eax
  802a1c:	40                   	inc    %eax
  802a1d:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  802a22:	e9 d2 06 00 00       	jmp    8030f9 <insert_sorted_with_merge_freeList+0x759>
				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);

			}
else
{
	if( blockToInsert->sva  < first->sva )
  802a27:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2a:	8b 50 08             	mov    0x8(%eax),%edx
  802a2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a30:	8b 40 08             	mov    0x8(%eax),%eax
  802a33:	39 c2                	cmp    %eax,%edx
  802a35:	0f 83 22 01 00 00    	jae    802b5d <insert_sorted_with_merge_freeList+0x1bd>
	{
                if( blockToInsert->sva + blockToInsert->size == first->sva)
  802a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3e:	8b 50 08             	mov    0x8(%eax),%edx
  802a41:	8b 45 08             	mov    0x8(%ebp),%eax
  802a44:	8b 40 0c             	mov    0xc(%eax),%eax
  802a47:	01 c2                	add    %eax,%edx
  802a49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a4c:	8b 40 08             	mov    0x8(%eax),%eax
  802a4f:	39 c2                	cmp    %eax,%edx
  802a51:	0f 85 9e 00 00 00    	jne    802af5 <insert_sorted_with_merge_freeList+0x155>
                {

                	first->sva = blockToInsert->sva;
  802a57:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5a:	8b 50 08             	mov    0x8(%eax),%edx
  802a5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a60:	89 50 08             	mov    %edx,0x8(%eax)
                	first->size = first->size + blockToInsert->size;
  802a63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a66:	8b 50 0c             	mov    0xc(%eax),%edx
  802a69:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6c:	8b 40 0c             	mov    0xc(%eax),%eax
  802a6f:	01 c2                	add    %eax,%edx
  802a71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a74:	89 50 0c             	mov    %edx,0xc(%eax)
                	blockToInsert->size = blockToInsert->sva = 0;
  802a77:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802a81:	8b 45 08             	mov    0x8(%ebp),%eax
  802a84:	8b 50 08             	mov    0x8(%eax),%edx
  802a87:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8a:	89 50 0c             	mov    %edx,0xc(%eax)
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802a8d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a91:	75 17                	jne    802aaa <insert_sorted_with_merge_freeList+0x10a>
  802a93:	83 ec 04             	sub    $0x4,%esp
  802a96:	68 50 3d 80 00       	push   $0x803d50
  802a9b:	68 21 01 00 00       	push   $0x121
  802aa0:	68 73 3d 80 00       	push   $0x803d73
  802aa5:	e8 4a d9 ff ff       	call   8003f4 <_panic>
  802aaa:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab3:	89 10                	mov    %edx,(%eax)
  802ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab8:	8b 00                	mov    (%eax),%eax
  802aba:	85 c0                	test   %eax,%eax
  802abc:	74 0d                	je     802acb <insert_sorted_with_merge_freeList+0x12b>
  802abe:	a1 48 41 80 00       	mov    0x804148,%eax
  802ac3:	8b 55 08             	mov    0x8(%ebp),%edx
  802ac6:	89 50 04             	mov    %edx,0x4(%eax)
  802ac9:	eb 08                	jmp    802ad3 <insert_sorted_with_merge_freeList+0x133>
  802acb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ace:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad6:	a3 48 41 80 00       	mov    %eax,0x804148
  802adb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ade:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ae5:	a1 54 41 80 00       	mov    0x804154,%eax
  802aea:	40                   	inc    %eax
  802aeb:	a3 54 41 80 00       	mov    %eax,0x804154
						}
				}
        }

}
}
  802af0:	e9 04 06 00 00       	jmp    8030f9 <insert_sorted_with_merge_freeList+0x759>
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
                }

                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  802af5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802af9:	75 17                	jne    802b12 <insert_sorted_with_merge_freeList+0x172>
  802afb:	83 ec 04             	sub    $0x4,%esp
  802afe:	68 50 3d 80 00       	push   $0x803d50
  802b03:	68 26 01 00 00       	push   $0x126
  802b08:	68 73 3d 80 00       	push   $0x803d73
  802b0d:	e8 e2 d8 ff ff       	call   8003f4 <_panic>
  802b12:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802b18:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1b:	89 10                	mov    %edx,(%eax)
  802b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b20:	8b 00                	mov    (%eax),%eax
  802b22:	85 c0                	test   %eax,%eax
  802b24:	74 0d                	je     802b33 <insert_sorted_with_merge_freeList+0x193>
  802b26:	a1 38 41 80 00       	mov    0x804138,%eax
  802b2b:	8b 55 08             	mov    0x8(%ebp),%edx
  802b2e:	89 50 04             	mov    %edx,0x4(%eax)
  802b31:	eb 08                	jmp    802b3b <insert_sorted_with_merge_freeList+0x19b>
  802b33:	8b 45 08             	mov    0x8(%ebp),%eax
  802b36:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3e:	a3 38 41 80 00       	mov    %eax,0x804138
  802b43:	8b 45 08             	mov    0x8(%ebp),%eax
  802b46:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b4d:	a1 44 41 80 00       	mov    0x804144,%eax
  802b52:	40                   	inc    %eax
  802b53:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  802b58:	e9 9c 05 00 00       	jmp    8030f9 <insert_sorted_with_merge_freeList+0x759>
                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
                }
	}
    else if(blockToInsert->sva > last->sva)
  802b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b60:	8b 50 08             	mov    0x8(%eax),%edx
  802b63:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b66:	8b 40 08             	mov    0x8(%eax),%eax
  802b69:	39 c2                	cmp    %eax,%edx
  802b6b:	0f 86 16 01 00 00    	jbe    802c87 <insert_sorted_with_merge_freeList+0x2e7>
 	{

				if(last->sva + last->size == blockToInsert->sva)
  802b71:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b74:	8b 50 08             	mov    0x8(%eax),%edx
  802b77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b7a:	8b 40 0c             	mov    0xc(%eax),%eax
  802b7d:	01 c2                	add    %eax,%edx
  802b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b82:	8b 40 08             	mov    0x8(%eax),%eax
  802b85:	39 c2                	cmp    %eax,%edx
  802b87:	0f 85 92 00 00 00    	jne    802c1f <insert_sorted_with_merge_freeList+0x27f>
				{

					last->size = last->size + blockToInsert->size;
  802b8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b90:	8b 50 0c             	mov    0xc(%eax),%edx
  802b93:	8b 45 08             	mov    0x8(%ebp),%eax
  802b96:	8b 40 0c             	mov    0xc(%eax),%eax
  802b99:	01 c2                	add    %eax,%edx
  802b9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b9e:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->size = blockToInsert->sva = 0;
  802ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802bab:	8b 45 08             	mov    0x8(%ebp),%eax
  802bae:	8b 50 08             	mov    0x8(%eax),%edx
  802bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb4:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802bb7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bbb:	75 17                	jne    802bd4 <insert_sorted_with_merge_freeList+0x234>
  802bbd:	83 ec 04             	sub    $0x4,%esp
  802bc0:	68 50 3d 80 00       	push   $0x803d50
  802bc5:	68 31 01 00 00       	push   $0x131
  802bca:	68 73 3d 80 00       	push   $0x803d73
  802bcf:	e8 20 d8 ff ff       	call   8003f4 <_panic>
  802bd4:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802bda:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdd:	89 10                	mov    %edx,(%eax)
  802bdf:	8b 45 08             	mov    0x8(%ebp),%eax
  802be2:	8b 00                	mov    (%eax),%eax
  802be4:	85 c0                	test   %eax,%eax
  802be6:	74 0d                	je     802bf5 <insert_sorted_with_merge_freeList+0x255>
  802be8:	a1 48 41 80 00       	mov    0x804148,%eax
  802bed:	8b 55 08             	mov    0x8(%ebp),%edx
  802bf0:	89 50 04             	mov    %edx,0x4(%eax)
  802bf3:	eb 08                	jmp    802bfd <insert_sorted_with_merge_freeList+0x25d>
  802bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf8:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  802c00:	a3 48 41 80 00       	mov    %eax,0x804148
  802c05:	8b 45 08             	mov    0x8(%ebp),%eax
  802c08:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c0f:	a1 54 41 80 00       	mov    0x804154,%eax
  802c14:	40                   	inc    %eax
  802c15:	a3 54 41 80 00       	mov    %eax,0x804154
						}
				}
        }

}
}
  802c1a:	e9 da 04 00 00       	jmp    8030f9 <insert_sorted_with_merge_freeList+0x759>

				}

				else
				{
					LIST_INSERT_TAIL(&(FreeMemBlocksList),  blockToInsert);
  802c1f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c23:	75 17                	jne    802c3c <insert_sorted_with_merge_freeList+0x29c>
  802c25:	83 ec 04             	sub    $0x4,%esp
  802c28:	68 f8 3d 80 00       	push   $0x803df8
  802c2d:	68 37 01 00 00       	push   $0x137
  802c32:	68 73 3d 80 00       	push   $0x803d73
  802c37:	e8 b8 d7 ff ff       	call   8003f4 <_panic>
  802c3c:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802c42:	8b 45 08             	mov    0x8(%ebp),%eax
  802c45:	89 50 04             	mov    %edx,0x4(%eax)
  802c48:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4b:	8b 40 04             	mov    0x4(%eax),%eax
  802c4e:	85 c0                	test   %eax,%eax
  802c50:	74 0c                	je     802c5e <insert_sorted_with_merge_freeList+0x2be>
  802c52:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802c57:	8b 55 08             	mov    0x8(%ebp),%edx
  802c5a:	89 10                	mov    %edx,(%eax)
  802c5c:	eb 08                	jmp    802c66 <insert_sorted_with_merge_freeList+0x2c6>
  802c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c61:	a3 38 41 80 00       	mov    %eax,0x804138
  802c66:	8b 45 08             	mov    0x8(%ebp),%eax
  802c69:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c71:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c77:	a1 44 41 80 00       	mov    0x804144,%eax
  802c7c:	40                   	inc    %eax
  802c7d:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  802c82:	e9 72 04 00 00       	jmp    8030f9 <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  802c87:	a1 38 41 80 00       	mov    0x804138,%eax
  802c8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c8f:	e9 35 04 00 00       	jmp    8030c9 <insert_sorted_with_merge_freeList+0x729>
				{
				     next=LIST_NEXT(blk_itr);
  802c94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c97:	8b 00                	mov    (%eax),%eax
  802c99:	89 45 e8             	mov    %eax,-0x18(%ebp)


					if( (blockToInsert->sva > blk_itr->sva) )
  802c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9f:	8b 50 08             	mov    0x8(%eax),%edx
  802ca2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca5:	8b 40 08             	mov    0x8(%eax),%eax
  802ca8:	39 c2                	cmp    %eax,%edx
  802caa:	0f 86 11 04 00 00    	jbe    8030c1 <insert_sorted_with_merge_freeList+0x721>
						{
							if(((blk_itr->sva) + (blk_itr->size) < blockToInsert->sva && (blockToInsert->sva) + (blockToInsert->size) < next->sva))
  802cb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb3:	8b 50 08             	mov    0x8(%eax),%edx
  802cb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb9:	8b 40 0c             	mov    0xc(%eax),%eax
  802cbc:	01 c2                	add    %eax,%edx
  802cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc1:	8b 40 08             	mov    0x8(%eax),%eax
  802cc4:	39 c2                	cmp    %eax,%edx
  802cc6:	0f 83 8b 00 00 00    	jae    802d57 <insert_sorted_with_merge_freeList+0x3b7>
  802ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ccf:	8b 50 08             	mov    0x8(%eax),%edx
  802cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd5:	8b 40 0c             	mov    0xc(%eax),%eax
  802cd8:	01 c2                	add    %eax,%edx
  802cda:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cdd:	8b 40 08             	mov    0x8(%eax),%eax
  802ce0:	39 c2                	cmp    %eax,%edx
  802ce2:	73 73                	jae    802d57 <insert_sorted_with_merge_freeList+0x3b7>
							{
								LIST_INSERT_AFTER(&(FreeMemBlocksList), blk_itr, blockToInsert);
  802ce4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ce8:	74 06                	je     802cf0 <insert_sorted_with_merge_freeList+0x350>
  802cea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cee:	75 17                	jne    802d07 <insert_sorted_with_merge_freeList+0x367>
  802cf0:	83 ec 04             	sub    $0x4,%esp
  802cf3:	68 c4 3d 80 00       	push   $0x803dc4
  802cf8:	68 48 01 00 00       	push   $0x148
  802cfd:	68 73 3d 80 00       	push   $0x803d73
  802d02:	e8 ed d6 ff ff       	call   8003f4 <_panic>
  802d07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0a:	8b 10                	mov    (%eax),%edx
  802d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0f:	89 10                	mov    %edx,(%eax)
  802d11:	8b 45 08             	mov    0x8(%ebp),%eax
  802d14:	8b 00                	mov    (%eax),%eax
  802d16:	85 c0                	test   %eax,%eax
  802d18:	74 0b                	je     802d25 <insert_sorted_with_merge_freeList+0x385>
  802d1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1d:	8b 00                	mov    (%eax),%eax
  802d1f:	8b 55 08             	mov    0x8(%ebp),%edx
  802d22:	89 50 04             	mov    %edx,0x4(%eax)
  802d25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d28:	8b 55 08             	mov    0x8(%ebp),%edx
  802d2b:	89 10                	mov    %edx,(%eax)
  802d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d30:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d33:	89 50 04             	mov    %edx,0x4(%eax)
  802d36:	8b 45 08             	mov    0x8(%ebp),%eax
  802d39:	8b 00                	mov    (%eax),%eax
  802d3b:	85 c0                	test   %eax,%eax
  802d3d:	75 08                	jne    802d47 <insert_sorted_with_merge_freeList+0x3a7>
  802d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d42:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802d47:	a1 44 41 80 00       	mov    0x804144,%eax
  802d4c:	40                   	inc    %eax
  802d4d:	a3 44 41 80 00       	mov    %eax,0x804144
								break;
  802d52:	e9 a2 03 00 00       	jmp    8030f9 <insert_sorted_with_merge_freeList+0x759>

							}
							else if((blockToInsert->sva + blockToInsert->size) < next->sva  && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  802d57:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5a:	8b 50 08             	mov    0x8(%eax),%edx
  802d5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d60:	8b 40 0c             	mov    0xc(%eax),%eax
  802d63:	01 c2                	add    %eax,%edx
  802d65:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d68:	8b 40 08             	mov    0x8(%eax),%eax
  802d6b:	39 c2                	cmp    %eax,%edx
  802d6d:	0f 83 ae 00 00 00    	jae    802e21 <insert_sorted_with_merge_freeList+0x481>
  802d73:	8b 45 08             	mov    0x8(%ebp),%eax
  802d76:	8b 50 08             	mov    0x8(%eax),%edx
  802d79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7c:	8b 48 08             	mov    0x8(%eax),%ecx
  802d7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d82:	8b 40 0c             	mov    0xc(%eax),%eax
  802d85:	01 c8                	add    %ecx,%eax
  802d87:	39 c2                	cmp    %eax,%edx
  802d89:	0f 85 92 00 00 00    	jne    802e21 <insert_sorted_with_merge_freeList+0x481>
							{

								blk_itr->size=blk_itr->size+blockToInsert->size;
  802d8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d92:	8b 50 0c             	mov    0xc(%eax),%edx
  802d95:	8b 45 08             	mov    0x8(%ebp),%eax
  802d98:	8b 40 0c             	mov    0xc(%eax),%eax
  802d9b:	01 c2                	add    %eax,%edx
  802d9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da0:	89 50 0c             	mov    %edx,0xc(%eax)
								 blockToInsert->size=blockToInsert->sva=0;
  802da3:	8b 45 08             	mov    0x8(%ebp),%eax
  802da6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802dad:	8b 45 08             	mov    0x8(%ebp),%eax
  802db0:	8b 50 08             	mov    0x8(%eax),%edx
  802db3:	8b 45 08             	mov    0x8(%ebp),%eax
  802db6:	89 50 0c             	mov    %edx,0xc(%eax)
								 LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802db9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dbd:	75 17                	jne    802dd6 <insert_sorted_with_merge_freeList+0x436>
  802dbf:	83 ec 04             	sub    $0x4,%esp
  802dc2:	68 50 3d 80 00       	push   $0x803d50
  802dc7:	68 51 01 00 00       	push   $0x151
  802dcc:	68 73 3d 80 00       	push   $0x803d73
  802dd1:	e8 1e d6 ff ff       	call   8003f4 <_panic>
  802dd6:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddf:	89 10                	mov    %edx,(%eax)
  802de1:	8b 45 08             	mov    0x8(%ebp),%eax
  802de4:	8b 00                	mov    (%eax),%eax
  802de6:	85 c0                	test   %eax,%eax
  802de8:	74 0d                	je     802df7 <insert_sorted_with_merge_freeList+0x457>
  802dea:	a1 48 41 80 00       	mov    0x804148,%eax
  802def:	8b 55 08             	mov    0x8(%ebp),%edx
  802df2:	89 50 04             	mov    %edx,0x4(%eax)
  802df5:	eb 08                	jmp    802dff <insert_sorted_with_merge_freeList+0x45f>
  802df7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfa:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802dff:	8b 45 08             	mov    0x8(%ebp),%eax
  802e02:	a3 48 41 80 00       	mov    %eax,0x804148
  802e07:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e11:	a1 54 41 80 00       	mov    0x804154,%eax
  802e16:	40                   	inc    %eax
  802e17:	a3 54 41 80 00       	mov    %eax,0x804154
								 break;
  802e1c:	e9 d8 02 00 00       	jmp    8030f9 <insert_sorted_with_merge_freeList+0x759>

							}
							else if( (blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva > (blk_itr->sva + blk_itr->size))
  802e21:	8b 45 08             	mov    0x8(%ebp),%eax
  802e24:	8b 50 08             	mov    0x8(%eax),%edx
  802e27:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2a:	8b 40 0c             	mov    0xc(%eax),%eax
  802e2d:	01 c2                	add    %eax,%edx
  802e2f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e32:	8b 40 08             	mov    0x8(%eax),%eax
  802e35:	39 c2                	cmp    %eax,%edx
  802e37:	0f 85 ba 00 00 00    	jne    802ef7 <insert_sorted_with_merge_freeList+0x557>
  802e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e40:	8b 50 08             	mov    0x8(%eax),%edx
  802e43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e46:	8b 48 08             	mov    0x8(%eax),%ecx
  802e49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4c:	8b 40 0c             	mov    0xc(%eax),%eax
  802e4f:	01 c8                	add    %ecx,%eax
  802e51:	39 c2                	cmp    %eax,%edx
  802e53:	0f 86 9e 00 00 00    	jbe    802ef7 <insert_sorted_with_merge_freeList+0x557>
							{
								next->size = next->size + blockToInsert->size;
  802e59:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e5c:	8b 50 0c             	mov    0xc(%eax),%edx
  802e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e62:	8b 40 0c             	mov    0xc(%eax),%eax
  802e65:	01 c2                	add    %eax,%edx
  802e67:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e6a:	89 50 0c             	mov    %edx,0xc(%eax)
								next->sva = blockToInsert->sva;
  802e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e70:	8b 50 08             	mov    0x8(%eax),%edx
  802e73:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e76:	89 50 08             	mov    %edx,0x8(%eax)

								blockToInsert->size = blockToInsert->sva = 0;
  802e79:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802e83:	8b 45 08             	mov    0x8(%ebp),%eax
  802e86:	8b 50 08             	mov    0x8(%eax),%edx
  802e89:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8c:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802e8f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e93:	75 17                	jne    802eac <insert_sorted_with_merge_freeList+0x50c>
  802e95:	83 ec 04             	sub    $0x4,%esp
  802e98:	68 50 3d 80 00       	push   $0x803d50
  802e9d:	68 5b 01 00 00       	push   $0x15b
  802ea2:	68 73 3d 80 00       	push   $0x803d73
  802ea7:	e8 48 d5 ff ff       	call   8003f4 <_panic>
  802eac:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802eb2:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb5:	89 10                	mov    %edx,(%eax)
  802eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eba:	8b 00                	mov    (%eax),%eax
  802ebc:	85 c0                	test   %eax,%eax
  802ebe:	74 0d                	je     802ecd <insert_sorted_with_merge_freeList+0x52d>
  802ec0:	a1 48 41 80 00       	mov    0x804148,%eax
  802ec5:	8b 55 08             	mov    0x8(%ebp),%edx
  802ec8:	89 50 04             	mov    %edx,0x4(%eax)
  802ecb:	eb 08                	jmp    802ed5 <insert_sorted_with_merge_freeList+0x535>
  802ecd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed0:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed8:	a3 48 41 80 00       	mov    %eax,0x804148
  802edd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ee7:	a1 54 41 80 00       	mov    0x804154,%eax
  802eec:	40                   	inc    %eax
  802eed:	a3 54 41 80 00       	mov    %eax,0x804154
								break;
  802ef2:	e9 02 02 00 00       	jmp    8030f9 <insert_sorted_with_merge_freeList+0x759>
							}
							else if ((blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  802ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  802efa:	8b 50 08             	mov    0x8(%eax),%edx
  802efd:	8b 45 08             	mov    0x8(%ebp),%eax
  802f00:	8b 40 0c             	mov    0xc(%eax),%eax
  802f03:	01 c2                	add    %eax,%edx
  802f05:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f08:	8b 40 08             	mov    0x8(%eax),%eax
  802f0b:	39 c2                	cmp    %eax,%edx
  802f0d:	0f 85 ae 01 00 00    	jne    8030c1 <insert_sorted_with_merge_freeList+0x721>
  802f13:	8b 45 08             	mov    0x8(%ebp),%eax
  802f16:	8b 50 08             	mov    0x8(%eax),%edx
  802f19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1c:	8b 48 08             	mov    0x8(%eax),%ecx
  802f1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f22:	8b 40 0c             	mov    0xc(%eax),%eax
  802f25:	01 c8                	add    %ecx,%eax
  802f27:	39 c2                	cmp    %eax,%edx
  802f29:	0f 85 92 01 00 00    	jne    8030c1 <insert_sorted_with_merge_freeList+0x721>
							{
								blk_itr->size = blk_itr->size + blockToInsert->size + next->size;
  802f2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f32:	8b 50 0c             	mov    0xc(%eax),%edx
  802f35:	8b 45 08             	mov    0x8(%ebp),%eax
  802f38:	8b 40 0c             	mov    0xc(%eax),%eax
  802f3b:	01 c2                	add    %eax,%edx
  802f3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f40:	8b 40 0c             	mov    0xc(%eax),%eax
  802f43:	01 c2                	add    %eax,%edx
  802f45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f48:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size = blockToInsert->sva=0;
  802f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802f55:	8b 45 08             	mov    0x8(%ebp),%eax
  802f58:	8b 50 08             	mov    0x8(%eax),%edx
  802f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5e:	89 50 0c             	mov    %edx,0xc(%eax)
								next->size = next->sva = 0;
  802f61:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f64:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802f6b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f6e:	8b 50 08             	mov    0x8(%eax),%edx
  802f71:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f74:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_REMOVE(&FreeMemBlocksList, next);
  802f77:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f7b:	75 17                	jne    802f94 <insert_sorted_with_merge_freeList+0x5f4>
  802f7d:	83 ec 04             	sub    $0x4,%esp
  802f80:	68 1b 3e 80 00       	push   $0x803e1b
  802f85:	68 63 01 00 00       	push   $0x163
  802f8a:	68 73 3d 80 00       	push   $0x803d73
  802f8f:	e8 60 d4 ff ff       	call   8003f4 <_panic>
  802f94:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f97:	8b 00                	mov    (%eax),%eax
  802f99:	85 c0                	test   %eax,%eax
  802f9b:	74 10                	je     802fad <insert_sorted_with_merge_freeList+0x60d>
  802f9d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fa0:	8b 00                	mov    (%eax),%eax
  802fa2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fa5:	8b 52 04             	mov    0x4(%edx),%edx
  802fa8:	89 50 04             	mov    %edx,0x4(%eax)
  802fab:	eb 0b                	jmp    802fb8 <insert_sorted_with_merge_freeList+0x618>
  802fad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fb0:	8b 40 04             	mov    0x4(%eax),%eax
  802fb3:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802fb8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fbb:	8b 40 04             	mov    0x4(%eax),%eax
  802fbe:	85 c0                	test   %eax,%eax
  802fc0:	74 0f                	je     802fd1 <insert_sorted_with_merge_freeList+0x631>
  802fc2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fc5:	8b 40 04             	mov    0x4(%eax),%eax
  802fc8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fcb:	8b 12                	mov    (%edx),%edx
  802fcd:	89 10                	mov    %edx,(%eax)
  802fcf:	eb 0a                	jmp    802fdb <insert_sorted_with_merge_freeList+0x63b>
  802fd1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fd4:	8b 00                	mov    (%eax),%eax
  802fd6:	a3 38 41 80 00       	mov    %eax,0x804138
  802fdb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fde:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fe4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fe7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fee:	a1 44 41 80 00       	mov    0x804144,%eax
  802ff3:	48                   	dec    %eax
  802ff4:	a3 44 41 80 00       	mov    %eax,0x804144
								LIST_INSERT_HEAD(&AvailableMemBlocksList, next );
  802ff9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ffd:	75 17                	jne    803016 <insert_sorted_with_merge_freeList+0x676>
  802fff:	83 ec 04             	sub    $0x4,%esp
  803002:	68 50 3d 80 00       	push   $0x803d50
  803007:	68 64 01 00 00       	push   $0x164
  80300c:	68 73 3d 80 00       	push   $0x803d73
  803011:	e8 de d3 ff ff       	call   8003f4 <_panic>
  803016:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80301c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80301f:	89 10                	mov    %edx,(%eax)
  803021:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803024:	8b 00                	mov    (%eax),%eax
  803026:	85 c0                	test   %eax,%eax
  803028:	74 0d                	je     803037 <insert_sorted_with_merge_freeList+0x697>
  80302a:	a1 48 41 80 00       	mov    0x804148,%eax
  80302f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803032:	89 50 04             	mov    %edx,0x4(%eax)
  803035:	eb 08                	jmp    80303f <insert_sorted_with_merge_freeList+0x69f>
  803037:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80303a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80303f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803042:	a3 48 41 80 00       	mov    %eax,0x804148
  803047:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80304a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803051:	a1 54 41 80 00       	mov    0x804154,%eax
  803056:	40                   	inc    %eax
  803057:	a3 54 41 80 00       	mov    %eax,0x804154
							    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  80305c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803060:	75 17                	jne    803079 <insert_sorted_with_merge_freeList+0x6d9>
  803062:	83 ec 04             	sub    $0x4,%esp
  803065:	68 50 3d 80 00       	push   $0x803d50
  80306a:	68 65 01 00 00       	push   $0x165
  80306f:	68 73 3d 80 00       	push   $0x803d73
  803074:	e8 7b d3 ff ff       	call   8003f4 <_panic>
  803079:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80307f:	8b 45 08             	mov    0x8(%ebp),%eax
  803082:	89 10                	mov    %edx,(%eax)
  803084:	8b 45 08             	mov    0x8(%ebp),%eax
  803087:	8b 00                	mov    (%eax),%eax
  803089:	85 c0                	test   %eax,%eax
  80308b:	74 0d                	je     80309a <insert_sorted_with_merge_freeList+0x6fa>
  80308d:	a1 48 41 80 00       	mov    0x804148,%eax
  803092:	8b 55 08             	mov    0x8(%ebp),%edx
  803095:	89 50 04             	mov    %edx,0x4(%eax)
  803098:	eb 08                	jmp    8030a2 <insert_sorted_with_merge_freeList+0x702>
  80309a:	8b 45 08             	mov    0x8(%ebp),%eax
  80309d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8030a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a5:	a3 48 41 80 00       	mov    %eax,0x804148
  8030aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030b4:	a1 54 41 80 00       	mov    0x804154,%eax
  8030b9:	40                   	inc    %eax
  8030ba:	a3 54 41 80 00       	mov    %eax,0x804154
								break;
  8030bf:	eb 38                	jmp    8030f9 <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  8030c1:	a1 40 41 80 00       	mov    0x804140,%eax
  8030c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030cd:	74 07                	je     8030d6 <insert_sorted_with_merge_freeList+0x736>
  8030cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d2:	8b 00                	mov    (%eax),%eax
  8030d4:	eb 05                	jmp    8030db <insert_sorted_with_merge_freeList+0x73b>
  8030d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8030db:	a3 40 41 80 00       	mov    %eax,0x804140
  8030e0:	a1 40 41 80 00       	mov    0x804140,%eax
  8030e5:	85 c0                	test   %eax,%eax
  8030e7:	0f 85 a7 fb ff ff    	jne    802c94 <insert_sorted_with_merge_freeList+0x2f4>
  8030ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030f1:	0f 85 9d fb ff ff    	jne    802c94 <insert_sorted_with_merge_freeList+0x2f4>
						}
				}
        }

}
}
  8030f7:	eb 00                	jmp    8030f9 <insert_sorted_with_merge_freeList+0x759>
  8030f9:	90                   	nop
  8030fa:	c9                   	leave  
  8030fb:	c3                   	ret    

008030fc <__udivdi3>:
  8030fc:	55                   	push   %ebp
  8030fd:	57                   	push   %edi
  8030fe:	56                   	push   %esi
  8030ff:	53                   	push   %ebx
  803100:	83 ec 1c             	sub    $0x1c,%esp
  803103:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803107:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80310b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80310f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803113:	89 ca                	mov    %ecx,%edx
  803115:	89 f8                	mov    %edi,%eax
  803117:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80311b:	85 f6                	test   %esi,%esi
  80311d:	75 2d                	jne    80314c <__udivdi3+0x50>
  80311f:	39 cf                	cmp    %ecx,%edi
  803121:	77 65                	ja     803188 <__udivdi3+0x8c>
  803123:	89 fd                	mov    %edi,%ebp
  803125:	85 ff                	test   %edi,%edi
  803127:	75 0b                	jne    803134 <__udivdi3+0x38>
  803129:	b8 01 00 00 00       	mov    $0x1,%eax
  80312e:	31 d2                	xor    %edx,%edx
  803130:	f7 f7                	div    %edi
  803132:	89 c5                	mov    %eax,%ebp
  803134:	31 d2                	xor    %edx,%edx
  803136:	89 c8                	mov    %ecx,%eax
  803138:	f7 f5                	div    %ebp
  80313a:	89 c1                	mov    %eax,%ecx
  80313c:	89 d8                	mov    %ebx,%eax
  80313e:	f7 f5                	div    %ebp
  803140:	89 cf                	mov    %ecx,%edi
  803142:	89 fa                	mov    %edi,%edx
  803144:	83 c4 1c             	add    $0x1c,%esp
  803147:	5b                   	pop    %ebx
  803148:	5e                   	pop    %esi
  803149:	5f                   	pop    %edi
  80314a:	5d                   	pop    %ebp
  80314b:	c3                   	ret    
  80314c:	39 ce                	cmp    %ecx,%esi
  80314e:	77 28                	ja     803178 <__udivdi3+0x7c>
  803150:	0f bd fe             	bsr    %esi,%edi
  803153:	83 f7 1f             	xor    $0x1f,%edi
  803156:	75 40                	jne    803198 <__udivdi3+0x9c>
  803158:	39 ce                	cmp    %ecx,%esi
  80315a:	72 0a                	jb     803166 <__udivdi3+0x6a>
  80315c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803160:	0f 87 9e 00 00 00    	ja     803204 <__udivdi3+0x108>
  803166:	b8 01 00 00 00       	mov    $0x1,%eax
  80316b:	89 fa                	mov    %edi,%edx
  80316d:	83 c4 1c             	add    $0x1c,%esp
  803170:	5b                   	pop    %ebx
  803171:	5e                   	pop    %esi
  803172:	5f                   	pop    %edi
  803173:	5d                   	pop    %ebp
  803174:	c3                   	ret    
  803175:	8d 76 00             	lea    0x0(%esi),%esi
  803178:	31 ff                	xor    %edi,%edi
  80317a:	31 c0                	xor    %eax,%eax
  80317c:	89 fa                	mov    %edi,%edx
  80317e:	83 c4 1c             	add    $0x1c,%esp
  803181:	5b                   	pop    %ebx
  803182:	5e                   	pop    %esi
  803183:	5f                   	pop    %edi
  803184:	5d                   	pop    %ebp
  803185:	c3                   	ret    
  803186:	66 90                	xchg   %ax,%ax
  803188:	89 d8                	mov    %ebx,%eax
  80318a:	f7 f7                	div    %edi
  80318c:	31 ff                	xor    %edi,%edi
  80318e:	89 fa                	mov    %edi,%edx
  803190:	83 c4 1c             	add    $0x1c,%esp
  803193:	5b                   	pop    %ebx
  803194:	5e                   	pop    %esi
  803195:	5f                   	pop    %edi
  803196:	5d                   	pop    %ebp
  803197:	c3                   	ret    
  803198:	bd 20 00 00 00       	mov    $0x20,%ebp
  80319d:	89 eb                	mov    %ebp,%ebx
  80319f:	29 fb                	sub    %edi,%ebx
  8031a1:	89 f9                	mov    %edi,%ecx
  8031a3:	d3 e6                	shl    %cl,%esi
  8031a5:	89 c5                	mov    %eax,%ebp
  8031a7:	88 d9                	mov    %bl,%cl
  8031a9:	d3 ed                	shr    %cl,%ebp
  8031ab:	89 e9                	mov    %ebp,%ecx
  8031ad:	09 f1                	or     %esi,%ecx
  8031af:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8031b3:	89 f9                	mov    %edi,%ecx
  8031b5:	d3 e0                	shl    %cl,%eax
  8031b7:	89 c5                	mov    %eax,%ebp
  8031b9:	89 d6                	mov    %edx,%esi
  8031bb:	88 d9                	mov    %bl,%cl
  8031bd:	d3 ee                	shr    %cl,%esi
  8031bf:	89 f9                	mov    %edi,%ecx
  8031c1:	d3 e2                	shl    %cl,%edx
  8031c3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031c7:	88 d9                	mov    %bl,%cl
  8031c9:	d3 e8                	shr    %cl,%eax
  8031cb:	09 c2                	or     %eax,%edx
  8031cd:	89 d0                	mov    %edx,%eax
  8031cf:	89 f2                	mov    %esi,%edx
  8031d1:	f7 74 24 0c          	divl   0xc(%esp)
  8031d5:	89 d6                	mov    %edx,%esi
  8031d7:	89 c3                	mov    %eax,%ebx
  8031d9:	f7 e5                	mul    %ebp
  8031db:	39 d6                	cmp    %edx,%esi
  8031dd:	72 19                	jb     8031f8 <__udivdi3+0xfc>
  8031df:	74 0b                	je     8031ec <__udivdi3+0xf0>
  8031e1:	89 d8                	mov    %ebx,%eax
  8031e3:	31 ff                	xor    %edi,%edi
  8031e5:	e9 58 ff ff ff       	jmp    803142 <__udivdi3+0x46>
  8031ea:	66 90                	xchg   %ax,%ax
  8031ec:	8b 54 24 08          	mov    0x8(%esp),%edx
  8031f0:	89 f9                	mov    %edi,%ecx
  8031f2:	d3 e2                	shl    %cl,%edx
  8031f4:	39 c2                	cmp    %eax,%edx
  8031f6:	73 e9                	jae    8031e1 <__udivdi3+0xe5>
  8031f8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8031fb:	31 ff                	xor    %edi,%edi
  8031fd:	e9 40 ff ff ff       	jmp    803142 <__udivdi3+0x46>
  803202:	66 90                	xchg   %ax,%ax
  803204:	31 c0                	xor    %eax,%eax
  803206:	e9 37 ff ff ff       	jmp    803142 <__udivdi3+0x46>
  80320b:	90                   	nop

0080320c <__umoddi3>:
  80320c:	55                   	push   %ebp
  80320d:	57                   	push   %edi
  80320e:	56                   	push   %esi
  80320f:	53                   	push   %ebx
  803210:	83 ec 1c             	sub    $0x1c,%esp
  803213:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803217:	8b 74 24 34          	mov    0x34(%esp),%esi
  80321b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80321f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803223:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803227:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80322b:	89 f3                	mov    %esi,%ebx
  80322d:	89 fa                	mov    %edi,%edx
  80322f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803233:	89 34 24             	mov    %esi,(%esp)
  803236:	85 c0                	test   %eax,%eax
  803238:	75 1a                	jne    803254 <__umoddi3+0x48>
  80323a:	39 f7                	cmp    %esi,%edi
  80323c:	0f 86 a2 00 00 00    	jbe    8032e4 <__umoddi3+0xd8>
  803242:	89 c8                	mov    %ecx,%eax
  803244:	89 f2                	mov    %esi,%edx
  803246:	f7 f7                	div    %edi
  803248:	89 d0                	mov    %edx,%eax
  80324a:	31 d2                	xor    %edx,%edx
  80324c:	83 c4 1c             	add    $0x1c,%esp
  80324f:	5b                   	pop    %ebx
  803250:	5e                   	pop    %esi
  803251:	5f                   	pop    %edi
  803252:	5d                   	pop    %ebp
  803253:	c3                   	ret    
  803254:	39 f0                	cmp    %esi,%eax
  803256:	0f 87 ac 00 00 00    	ja     803308 <__umoddi3+0xfc>
  80325c:	0f bd e8             	bsr    %eax,%ebp
  80325f:	83 f5 1f             	xor    $0x1f,%ebp
  803262:	0f 84 ac 00 00 00    	je     803314 <__umoddi3+0x108>
  803268:	bf 20 00 00 00       	mov    $0x20,%edi
  80326d:	29 ef                	sub    %ebp,%edi
  80326f:	89 fe                	mov    %edi,%esi
  803271:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803275:	89 e9                	mov    %ebp,%ecx
  803277:	d3 e0                	shl    %cl,%eax
  803279:	89 d7                	mov    %edx,%edi
  80327b:	89 f1                	mov    %esi,%ecx
  80327d:	d3 ef                	shr    %cl,%edi
  80327f:	09 c7                	or     %eax,%edi
  803281:	89 e9                	mov    %ebp,%ecx
  803283:	d3 e2                	shl    %cl,%edx
  803285:	89 14 24             	mov    %edx,(%esp)
  803288:	89 d8                	mov    %ebx,%eax
  80328a:	d3 e0                	shl    %cl,%eax
  80328c:	89 c2                	mov    %eax,%edx
  80328e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803292:	d3 e0                	shl    %cl,%eax
  803294:	89 44 24 04          	mov    %eax,0x4(%esp)
  803298:	8b 44 24 08          	mov    0x8(%esp),%eax
  80329c:	89 f1                	mov    %esi,%ecx
  80329e:	d3 e8                	shr    %cl,%eax
  8032a0:	09 d0                	or     %edx,%eax
  8032a2:	d3 eb                	shr    %cl,%ebx
  8032a4:	89 da                	mov    %ebx,%edx
  8032a6:	f7 f7                	div    %edi
  8032a8:	89 d3                	mov    %edx,%ebx
  8032aa:	f7 24 24             	mull   (%esp)
  8032ad:	89 c6                	mov    %eax,%esi
  8032af:	89 d1                	mov    %edx,%ecx
  8032b1:	39 d3                	cmp    %edx,%ebx
  8032b3:	0f 82 87 00 00 00    	jb     803340 <__umoddi3+0x134>
  8032b9:	0f 84 91 00 00 00    	je     803350 <__umoddi3+0x144>
  8032bf:	8b 54 24 04          	mov    0x4(%esp),%edx
  8032c3:	29 f2                	sub    %esi,%edx
  8032c5:	19 cb                	sbb    %ecx,%ebx
  8032c7:	89 d8                	mov    %ebx,%eax
  8032c9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8032cd:	d3 e0                	shl    %cl,%eax
  8032cf:	89 e9                	mov    %ebp,%ecx
  8032d1:	d3 ea                	shr    %cl,%edx
  8032d3:	09 d0                	or     %edx,%eax
  8032d5:	89 e9                	mov    %ebp,%ecx
  8032d7:	d3 eb                	shr    %cl,%ebx
  8032d9:	89 da                	mov    %ebx,%edx
  8032db:	83 c4 1c             	add    $0x1c,%esp
  8032de:	5b                   	pop    %ebx
  8032df:	5e                   	pop    %esi
  8032e0:	5f                   	pop    %edi
  8032e1:	5d                   	pop    %ebp
  8032e2:	c3                   	ret    
  8032e3:	90                   	nop
  8032e4:	89 fd                	mov    %edi,%ebp
  8032e6:	85 ff                	test   %edi,%edi
  8032e8:	75 0b                	jne    8032f5 <__umoddi3+0xe9>
  8032ea:	b8 01 00 00 00       	mov    $0x1,%eax
  8032ef:	31 d2                	xor    %edx,%edx
  8032f1:	f7 f7                	div    %edi
  8032f3:	89 c5                	mov    %eax,%ebp
  8032f5:	89 f0                	mov    %esi,%eax
  8032f7:	31 d2                	xor    %edx,%edx
  8032f9:	f7 f5                	div    %ebp
  8032fb:	89 c8                	mov    %ecx,%eax
  8032fd:	f7 f5                	div    %ebp
  8032ff:	89 d0                	mov    %edx,%eax
  803301:	e9 44 ff ff ff       	jmp    80324a <__umoddi3+0x3e>
  803306:	66 90                	xchg   %ax,%ax
  803308:	89 c8                	mov    %ecx,%eax
  80330a:	89 f2                	mov    %esi,%edx
  80330c:	83 c4 1c             	add    $0x1c,%esp
  80330f:	5b                   	pop    %ebx
  803310:	5e                   	pop    %esi
  803311:	5f                   	pop    %edi
  803312:	5d                   	pop    %ebp
  803313:	c3                   	ret    
  803314:	3b 04 24             	cmp    (%esp),%eax
  803317:	72 06                	jb     80331f <__umoddi3+0x113>
  803319:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80331d:	77 0f                	ja     80332e <__umoddi3+0x122>
  80331f:	89 f2                	mov    %esi,%edx
  803321:	29 f9                	sub    %edi,%ecx
  803323:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803327:	89 14 24             	mov    %edx,(%esp)
  80332a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80332e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803332:	8b 14 24             	mov    (%esp),%edx
  803335:	83 c4 1c             	add    $0x1c,%esp
  803338:	5b                   	pop    %ebx
  803339:	5e                   	pop    %esi
  80333a:	5f                   	pop    %edi
  80333b:	5d                   	pop    %ebp
  80333c:	c3                   	ret    
  80333d:	8d 76 00             	lea    0x0(%esi),%esi
  803340:	2b 04 24             	sub    (%esp),%eax
  803343:	19 fa                	sbb    %edi,%edx
  803345:	89 d1                	mov    %edx,%ecx
  803347:	89 c6                	mov    %eax,%esi
  803349:	e9 71 ff ff ff       	jmp    8032bf <__umoddi3+0xb3>
  80334e:	66 90                	xchg   %ax,%ax
  803350:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803354:	72 ea                	jb     803340 <__umoddi3+0x134>
  803356:	89 d9                	mov    %ebx,%ecx
  803358:	e9 62 ff ff ff       	jmp    8032bf <__umoddi3+0xb3>
