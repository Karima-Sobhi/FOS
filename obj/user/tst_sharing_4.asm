
obj/user/tst_sharing_4:     file format elf32-i386


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
  800031:	e8 41 05 00 00       	call   800577 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the free of shared variables (create_shared_memory)
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 44             	sub    $0x44,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80003f:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800043:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004a:	eb 29                	jmp    800075 <_main+0x3d>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004c:	a1 20 50 80 00       	mov    0x805020,%eax
  800051:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800057:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80005a:	89 d0                	mov    %edx,%eax
  80005c:	01 c0                	add    %eax,%eax
  80005e:	01 d0                	add    %edx,%eax
  800060:	c1 e0 03             	shl    $0x3,%eax
  800063:	01 c8                	add    %ecx,%eax
  800065:	8a 40 04             	mov    0x4(%eax),%al
  800068:	84 c0                	test   %al,%al
  80006a:	74 06                	je     800072 <_main+0x3a>
			{
				fullWS = 0;
  80006c:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  800070:	eb 12                	jmp    800084 <_main+0x4c>
_main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800072:	ff 45 f0             	incl   -0x10(%ebp)
  800075:	a1 20 50 80 00       	mov    0x805020,%eax
  80007a:	8b 50 74             	mov    0x74(%eax),%edx
  80007d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800080:	39 c2                	cmp    %eax,%edx
  800082:	77 c8                	ja     80004c <_main+0x14>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800084:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800088:	74 14                	je     80009e <_main+0x66>
  80008a:	83 ec 04             	sub    $0x4,%esp
  80008d:	68 20 36 80 00       	push   $0x803620
  800092:	6a 12                	push   $0x12
  800094:	68 3c 36 80 00       	push   $0x80363c
  800099:	e8 15 06 00 00       	call   8006b3 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	6a 00                	push   $0x0
  8000a3:	e8 eb 17 00 00       	call   801893 <malloc>
  8000a8:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	cprintf("************************************************\n");
  8000ab:	83 ec 0c             	sub    $0xc,%esp
  8000ae:	68 54 36 80 00       	push   $0x803654
  8000b3:	e8 af 08 00 00       	call   800967 <cprintf>
  8000b8:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000bb:	83 ec 0c             	sub    $0xc,%esp
  8000be:	68 88 36 80 00       	push   $0x803688
  8000c3:	e8 9f 08 00 00       	call   800967 <cprintf>
  8000c8:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000cb:	83 ec 0c             	sub    $0xc,%esp
  8000ce:	68 e4 36 80 00       	push   $0x8036e4
  8000d3:	e8 8f 08 00 00       	call   800967 <cprintf>
  8000d8:	83 c4 10             	add    $0x10,%esp

	int Mega = 1024*1024;
  8000db:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000e2:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	int envID = sys_getenvid();
  8000e9:	e8 9a 1e 00 00       	call   801f88 <sys_getenvid>
  8000ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	cprintf("STEP A: checking free of a shared object ... \n");
  8000f1:	83 ec 0c             	sub    $0xc,%esp
  8000f4:	68 18 37 80 00       	push   $0x803718
  8000f9:	e8 69 08 00 00       	call   800967 <cprintf>
  8000fe:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x;
		int freeFrames = sys_calculate_free_frames() ;
  800101:	e8 bb 1b 00 00       	call   801cc1 <sys_calculate_free_frames>
  800106:	89 45 e0             	mov    %eax,-0x20(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  800109:	83 ec 04             	sub    $0x4,%esp
  80010c:	6a 01                	push   $0x1
  80010e:	68 00 10 00 00       	push   $0x1000
  800113:	68 47 37 80 00       	push   $0x803747
  800118:	e8 c5 18 00 00       	call   8019e2 <smalloc>
  80011d:	83 c4 10             	add    $0x10,%esp
  800120:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800123:	81 7d dc 00 00 00 80 	cmpl   $0x80000000,-0x24(%ebp)
  80012a:	74 14                	je     800140 <_main+0x108>
  80012c:	83 ec 04             	sub    $0x4,%esp
  80012f:	68 4c 37 80 00       	push   $0x80374c
  800134:	6a 24                	push   $0x24
  800136:	68 3c 36 80 00       	push   $0x80363c
  80013b:	e8 73 05 00 00       	call   8006b3 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800140:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800143:	e8 79 1b 00 00       	call   801cc1 <sys_calculate_free_frames>
  800148:	29 c3                	sub    %eax,%ebx
  80014a:	89 d8                	mov    %ebx,%eax
  80014c:	83 f8 04             	cmp    $0x4,%eax
  80014f:	74 14                	je     800165 <_main+0x12d>
  800151:	83 ec 04             	sub    $0x4,%esp
  800154:	68 b8 37 80 00       	push   $0x8037b8
  800159:	6a 25                	push   $0x25
  80015b:	68 3c 36 80 00       	push   $0x80363c
  800160:	e8 4e 05 00 00       	call   8006b3 <_panic>

		sfree(x);
  800165:	83 ec 0c             	sub    $0xc,%esp
  800168:	ff 75 dc             	pushl  -0x24(%ebp)
  80016b:	e8 f1 19 00 00       	call   801b61 <sfree>
  800170:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) ==  0+0+2) panic("Wrong free: make sure that you free the shared object by calling free_share_object()");
  800173:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800176:	e8 46 1b 00 00       	call   801cc1 <sys_calculate_free_frames>
  80017b:	29 c3                	sub    %eax,%ebx
  80017d:	89 d8                	mov    %ebx,%eax
  80017f:	83 f8 02             	cmp    $0x2,%eax
  800182:	75 14                	jne    800198 <_main+0x160>
  800184:	83 ec 04             	sub    $0x4,%esp
  800187:	68 38 38 80 00       	push   $0x803838
  80018c:	6a 28                	push   $0x28
  80018e:	68 3c 36 80 00       	push   $0x80363c
  800193:	e8 1b 05 00 00       	call   8006b3 <_panic>
		else if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: revise your freeSharedObject logic");
  800198:	e8 24 1b 00 00       	call   801cc1 <sys_calculate_free_frames>
  80019d:	89 c2                	mov    %eax,%edx
  80019f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001a2:	39 c2                	cmp    %eax,%edx
  8001a4:	74 14                	je     8001ba <_main+0x182>
  8001a6:	83 ec 04             	sub    $0x4,%esp
  8001a9:	68 90 38 80 00       	push   $0x803890
  8001ae:	6a 29                	push   $0x29
  8001b0:	68 3c 36 80 00       	push   $0x80363c
  8001b5:	e8 f9 04 00 00       	call   8006b3 <_panic>
	}
	cprintf("Step A completed successfully!!\n\n\n");
  8001ba:	83 ec 0c             	sub    $0xc,%esp
  8001bd:	68 c0 38 80 00       	push   $0x8038c0
  8001c2:	e8 a0 07 00 00       	call   800967 <cprintf>
  8001c7:	83 c4 10             	add    $0x10,%esp


	cprintf("STEP B: checking free of 2 shared objects ... \n");
  8001ca:	83 ec 0c             	sub    $0xc,%esp
  8001cd:	68 e4 38 80 00       	push   $0x8038e4
  8001d2:	e8 90 07 00 00       	call   800967 <cprintf>
  8001d7:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x, *z ;
		int freeFrames = sys_calculate_free_frames() ;
  8001da:	e8 e2 1a 00 00       	call   801cc1 <sys_calculate_free_frames>
  8001df:	89 45 d8             	mov    %eax,-0x28(%ebp)
		z = smalloc("z", PAGE_SIZE, 1);
  8001e2:	83 ec 04             	sub    $0x4,%esp
  8001e5:	6a 01                	push   $0x1
  8001e7:	68 00 10 00 00       	push   $0x1000
  8001ec:	68 14 39 80 00       	push   $0x803914
  8001f1:	e8 ec 17 00 00       	call   8019e2 <smalloc>
  8001f6:	83 c4 10             	add    $0x10,%esp
  8001f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8001fc:	83 ec 04             	sub    $0x4,%esp
  8001ff:	6a 01                	push   $0x1
  800201:	68 00 10 00 00       	push   $0x1000
  800206:	68 47 37 80 00       	push   $0x803747
  80020b:	e8 d2 17 00 00       	call   8019e2 <smalloc>
  800210:	83 c4 10             	add    $0x10,%esp
  800213:	89 45 d0             	mov    %eax,-0x30(%ebp)

		if(x == NULL) panic("Wrong free: make sure that you free the shared object by calling free_share_object()");
  800216:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80021a:	75 14                	jne    800230 <_main+0x1f8>
  80021c:	83 ec 04             	sub    $0x4,%esp
  80021f:	68 38 38 80 00       	push   $0x803838
  800224:	6a 35                	push   $0x35
  800226:	68 3c 36 80 00       	push   $0x80363c
  80022b:	e8 83 04 00 00       	call   8006b3 <_panic>

		if ((freeFrames - sys_calculate_free_frames()) !=  2+1+4) panic("Wrong previous free: make sure that you correctly free shared object before (Step A)");
  800230:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800233:	e8 89 1a 00 00       	call   801cc1 <sys_calculate_free_frames>
  800238:	29 c3                	sub    %eax,%ebx
  80023a:	89 d8                	mov    %ebx,%eax
  80023c:	83 f8 07             	cmp    $0x7,%eax
  80023f:	74 14                	je     800255 <_main+0x21d>
  800241:	83 ec 04             	sub    $0x4,%esp
  800244:	68 18 39 80 00       	push   $0x803918
  800249:	6a 37                	push   $0x37
  80024b:	68 3c 36 80 00       	push   $0x80363c
  800250:	e8 5e 04 00 00       	call   8006b3 <_panic>

		sfree(z);
  800255:	83 ec 0c             	sub    $0xc,%esp
  800258:	ff 75 d4             	pushl  -0x2c(%ebp)
  80025b:	e8 01 19 00 00       	call   801b61 <sfree>
  800260:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  800263:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800266:	e8 56 1a 00 00       	call   801cc1 <sys_calculate_free_frames>
  80026b:	29 c3                	sub    %eax,%ebx
  80026d:	89 d8                	mov    %ebx,%eax
  80026f:	83 f8 04             	cmp    $0x4,%eax
  800272:	74 14                	je     800288 <_main+0x250>
  800274:	83 ec 04             	sub    $0x4,%esp
  800277:	68 6d 39 80 00       	push   $0x80396d
  80027c:	6a 3a                	push   $0x3a
  80027e:	68 3c 36 80 00       	push   $0x80363c
  800283:	e8 2b 04 00 00       	call   8006b3 <_panic>

		sfree(x);
  800288:	83 ec 0c             	sub    $0xc,%esp
  80028b:	ff 75 d0             	pushl  -0x30(%ebp)
  80028e:	e8 ce 18 00 00       	call   801b61 <sfree>
  800293:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  800296:	e8 26 1a 00 00       	call   801cc1 <sys_calculate_free_frames>
  80029b:	89 c2                	mov    %eax,%edx
  80029d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002a0:	39 c2                	cmp    %eax,%edx
  8002a2:	74 14                	je     8002b8 <_main+0x280>
  8002a4:	83 ec 04             	sub    $0x4,%esp
  8002a7:	68 6d 39 80 00       	push   $0x80396d
  8002ac:	6a 3d                	push   $0x3d
  8002ae:	68 3c 36 80 00       	push   $0x80363c
  8002b3:	e8 fb 03 00 00       	call   8006b3 <_panic>

	}
	cprintf("Step B completed successfully!!\n\n\n");
  8002b8:	83 ec 0c             	sub    $0xc,%esp
  8002bb:	68 8c 39 80 00       	push   $0x80398c
  8002c0:	e8 a2 06 00 00       	call   800967 <cprintf>
  8002c5:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP C: checking range of loop during free... \n");
  8002c8:	83 ec 0c             	sub    $0xc,%esp
  8002cb:	68 b0 39 80 00       	push   $0x8039b0
  8002d0:	e8 92 06 00 00       	call   800967 <cprintf>
  8002d5:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *w, *u;
		int freeFrames = sys_calculate_free_frames() ;
  8002d8:	e8 e4 19 00 00       	call   801cc1 <sys_calculate_free_frames>
  8002dd:	89 45 cc             	mov    %eax,-0x34(%ebp)
		w = smalloc("w", 3 * PAGE_SIZE+1, 1);
  8002e0:	83 ec 04             	sub    $0x4,%esp
  8002e3:	6a 01                	push   $0x1
  8002e5:	68 01 30 00 00       	push   $0x3001
  8002ea:	68 e0 39 80 00       	push   $0x8039e0
  8002ef:	e8 ee 16 00 00       	call   8019e2 <smalloc>
  8002f4:	83 c4 10             	add    $0x10,%esp
  8002f7:	89 45 c8             	mov    %eax,-0x38(%ebp)
		u = smalloc("u", PAGE_SIZE, 1);
  8002fa:	83 ec 04             	sub    $0x4,%esp
  8002fd:	6a 01                	push   $0x1
  8002ff:	68 00 10 00 00       	push   $0x1000
  800304:	68 e2 39 80 00       	push   $0x8039e2
  800309:	e8 d4 16 00 00       	call   8019e2 <smalloc>
  80030e:	83 c4 10             	add    $0x10,%esp
  800311:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if ((freeFrames - sys_calculate_free_frames()) != 5+1+4) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800314:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800317:	e8 a5 19 00 00       	call   801cc1 <sys_calculate_free_frames>
  80031c:	29 c3                	sub    %eax,%ebx
  80031e:	89 d8                	mov    %ebx,%eax
  800320:	83 f8 0a             	cmp    $0xa,%eax
  800323:	74 14                	je     800339 <_main+0x301>
  800325:	83 ec 04             	sub    $0x4,%esp
  800328:	68 b8 37 80 00       	push   $0x8037b8
  80032d:	6a 48                	push   $0x48
  80032f:	68 3c 36 80 00       	push   $0x80363c
  800334:	e8 7a 03 00 00       	call   8006b3 <_panic>

		sfree(w);
  800339:	83 ec 0c             	sub    $0xc,%esp
  80033c:	ff 75 c8             	pushl  -0x38(%ebp)
  80033f:	e8 1d 18 00 00       	call   801b61 <sfree>
  800344:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  800347:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80034a:	e8 72 19 00 00       	call   801cc1 <sys_calculate_free_frames>
  80034f:	29 c3                	sub    %eax,%ebx
  800351:	89 d8                	mov    %ebx,%eax
  800353:	83 f8 04             	cmp    $0x4,%eax
  800356:	74 14                	je     80036c <_main+0x334>
  800358:	83 ec 04             	sub    $0x4,%esp
  80035b:	68 6d 39 80 00       	push   $0x80396d
  800360:	6a 4b                	push   $0x4b
  800362:	68 3c 36 80 00       	push   $0x80363c
  800367:	e8 47 03 00 00       	call   8006b3 <_panic>

		uint32 *o;

		o = smalloc("o", 2 * PAGE_SIZE-1,1);
  80036c:	83 ec 04             	sub    $0x4,%esp
  80036f:	6a 01                	push   $0x1
  800371:	68 ff 1f 00 00       	push   $0x1fff
  800376:	68 e4 39 80 00       	push   $0x8039e4
  80037b:	e8 62 16 00 00       	call   8019e2 <smalloc>
  800380:	83 c4 10             	add    $0x10,%esp
  800383:	89 45 c0             	mov    %eax,-0x40(%ebp)

		cprintf("2\n");
  800386:	83 ec 0c             	sub    $0xc,%esp
  800389:	68 e6 39 80 00       	push   $0x8039e6
  80038e:	e8 d4 05 00 00       	call   800967 <cprintf>
  800393:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) != 3+1+4) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800396:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800399:	e8 23 19 00 00       	call   801cc1 <sys_calculate_free_frames>
  80039e:	29 c3                	sub    %eax,%ebx
  8003a0:	89 d8                	mov    %ebx,%eax
  8003a2:	83 f8 08             	cmp    $0x8,%eax
  8003a5:	74 14                	je     8003bb <_main+0x383>
  8003a7:	83 ec 04             	sub    $0x4,%esp
  8003aa:	68 b8 37 80 00       	push   $0x8037b8
  8003af:	6a 52                	push   $0x52
  8003b1:	68 3c 36 80 00       	push   $0x80363c
  8003b6:	e8 f8 02 00 00       	call   8006b3 <_panic>

		sfree(o);
  8003bb:	83 ec 0c             	sub    $0xc,%esp
  8003be:	ff 75 c0             	pushl  -0x40(%ebp)
  8003c1:	e8 9b 17 00 00       	call   801b61 <sfree>
  8003c6:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  8003c9:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8003cc:	e8 f0 18 00 00       	call   801cc1 <sys_calculate_free_frames>
  8003d1:	29 c3                	sub    %eax,%ebx
  8003d3:	89 d8                	mov    %ebx,%eax
  8003d5:	83 f8 04             	cmp    $0x4,%eax
  8003d8:	74 14                	je     8003ee <_main+0x3b6>
  8003da:	83 ec 04             	sub    $0x4,%esp
  8003dd:	68 6d 39 80 00       	push   $0x80396d
  8003e2:	6a 55                	push   $0x55
  8003e4:	68 3c 36 80 00       	push   $0x80363c
  8003e9:	e8 c5 02 00 00       	call   8006b3 <_panic>

		sfree(u);
  8003ee:	83 ec 0c             	sub    $0xc,%esp
  8003f1:	ff 75 c4             	pushl  -0x3c(%ebp)
  8003f4:	e8 68 17 00 00       	call   801b61 <sfree>
  8003f9:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  8003fc:	e8 c0 18 00 00       	call   801cc1 <sys_calculate_free_frames>
  800401:	89 c2                	mov    %eax,%edx
  800403:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800406:	39 c2                	cmp    %eax,%edx
  800408:	74 14                	je     80041e <_main+0x3e6>
  80040a:	83 ec 04             	sub    $0x4,%esp
  80040d:	68 6d 39 80 00       	push   $0x80396d
  800412:	6a 58                	push   $0x58
  800414:	68 3c 36 80 00       	push   $0x80363c
  800419:	e8 95 02 00 00       	call   8006b3 <_panic>


		//Checking boundaries of page tables
		freeFrames = sys_calculate_free_frames() ;
  80041e:	e8 9e 18 00 00       	call   801cc1 <sys_calculate_free_frames>
  800423:	89 45 cc             	mov    %eax,-0x34(%ebp)
		w = smalloc("w", 3 * Mega - 1*kilo, 1);
  800426:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800429:	89 c2                	mov    %eax,%edx
  80042b:	01 d2                	add    %edx,%edx
  80042d:	01 d0                	add    %edx,%eax
  80042f:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800432:	83 ec 04             	sub    $0x4,%esp
  800435:	6a 01                	push   $0x1
  800437:	50                   	push   %eax
  800438:	68 e0 39 80 00       	push   $0x8039e0
  80043d:	e8 a0 15 00 00       	call   8019e2 <smalloc>
  800442:	83 c4 10             	add    $0x10,%esp
  800445:	89 45 c8             	mov    %eax,-0x38(%ebp)
		u = smalloc("u", 7 * Mega - 1*kilo, 1);
  800448:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80044b:	89 d0                	mov    %edx,%eax
  80044d:	01 c0                	add    %eax,%eax
  80044f:	01 d0                	add    %edx,%eax
  800451:	01 c0                	add    %eax,%eax
  800453:	01 d0                	add    %edx,%eax
  800455:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800458:	83 ec 04             	sub    $0x4,%esp
  80045b:	6a 01                	push   $0x1
  80045d:	50                   	push   %eax
  80045e:	68 e2 39 80 00       	push   $0x8039e2
  800463:	e8 7a 15 00 00       	call   8019e2 <smalloc>
  800468:	83 c4 10             	add    $0x10,%esp
  80046b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		o = smalloc("o", 2 * Mega + 1*kilo, 1);
  80046e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800471:	01 c0                	add    %eax,%eax
  800473:	89 c2                	mov    %eax,%edx
  800475:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800478:	01 d0                	add    %edx,%eax
  80047a:	83 ec 04             	sub    $0x4,%esp
  80047d:	6a 01                	push   $0x1
  80047f:	50                   	push   %eax
  800480:	68 e4 39 80 00       	push   $0x8039e4
  800485:	e8 58 15 00 00       	call   8019e2 <smalloc>
  80048a:	83 c4 10             	add    $0x10,%esp
  80048d:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if ((freeFrames - sys_calculate_free_frames()) != 3073+4+7) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800490:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800493:	e8 29 18 00 00       	call   801cc1 <sys_calculate_free_frames>
  800498:	29 c3                	sub    %eax,%ebx
  80049a:	89 d8                	mov    %ebx,%eax
  80049c:	3d 0c 0c 00 00       	cmp    $0xc0c,%eax
  8004a1:	74 14                	je     8004b7 <_main+0x47f>
  8004a3:	83 ec 04             	sub    $0x4,%esp
  8004a6:	68 b8 37 80 00       	push   $0x8037b8
  8004ab:	6a 61                	push   $0x61
  8004ad:	68 3c 36 80 00       	push   $0x80363c
  8004b2:	e8 fc 01 00 00       	call   8006b3 <_panic>

		sfree(o);
  8004b7:	83 ec 0c             	sub    $0xc,%esp
  8004ba:	ff 75 c0             	pushl  -0x40(%ebp)
  8004bd:	e8 9f 16 00 00       	call   801b61 <sfree>
  8004c2:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  2560+3+5) panic("Wrong free: check your logic");
  8004c5:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004c8:	e8 f4 17 00 00       	call   801cc1 <sys_calculate_free_frames>
  8004cd:	29 c3                	sub    %eax,%ebx
  8004cf:	89 d8                	mov    %ebx,%eax
  8004d1:	3d 08 0a 00 00       	cmp    $0xa08,%eax
  8004d6:	74 14                	je     8004ec <_main+0x4b4>
  8004d8:	83 ec 04             	sub    $0x4,%esp
  8004db:	68 6d 39 80 00       	push   $0x80396d
  8004e0:	6a 64                	push   $0x64
  8004e2:	68 3c 36 80 00       	push   $0x80363c
  8004e7:	e8 c7 01 00 00       	call   8006b3 <_panic>

		sfree(w);
  8004ec:	83 ec 0c             	sub    $0xc,%esp
  8004ef:	ff 75 c8             	pushl  -0x38(%ebp)
  8004f2:	e8 6a 16 00 00       	call   801b61 <sfree>
  8004f7:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1792+3+3) panic("Wrong free: check your logic");
  8004fa:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004fd:	e8 bf 17 00 00       	call   801cc1 <sys_calculate_free_frames>
  800502:	29 c3                	sub    %eax,%ebx
  800504:	89 d8                	mov    %ebx,%eax
  800506:	3d 06 07 00 00       	cmp    $0x706,%eax
  80050b:	74 14                	je     800521 <_main+0x4e9>
  80050d:	83 ec 04             	sub    $0x4,%esp
  800510:	68 6d 39 80 00       	push   $0x80396d
  800515:	6a 67                	push   $0x67
  800517:	68 3c 36 80 00       	push   $0x80363c
  80051c:	e8 92 01 00 00       	call   8006b3 <_panic>

		sfree(u);
  800521:	83 ec 0c             	sub    $0xc,%esp
  800524:	ff 75 c4             	pushl  -0x3c(%ebp)
  800527:	e8 35 16 00 00       	call   801b61 <sfree>
  80052c:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  80052f:	e8 8d 17 00 00       	call   801cc1 <sys_calculate_free_frames>
  800534:	89 c2                	mov    %eax,%edx
  800536:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800539:	39 c2                	cmp    %eax,%edx
  80053b:	74 14                	je     800551 <_main+0x519>
  80053d:	83 ec 04             	sub    $0x4,%esp
  800540:	68 6d 39 80 00       	push   $0x80396d
  800545:	6a 6a                	push   $0x6a
  800547:	68 3c 36 80 00       	push   $0x80363c
  80054c:	e8 62 01 00 00       	call   8006b3 <_panic>
	}
	cprintf("Step C completed successfully!!\n\n\n");
  800551:	83 ec 0c             	sub    $0xc,%esp
  800554:	68 ec 39 80 00       	push   $0x8039ec
  800559:	e8 09 04 00 00       	call   800967 <cprintf>
  80055e:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! Test of freeSharedObjects [4] completed successfully!!\n\n\n");
  800561:	83 ec 0c             	sub    $0xc,%esp
  800564:	68 10 3a 80 00       	push   $0x803a10
  800569:	e8 f9 03 00 00       	call   800967 <cprintf>
  80056e:	83 c4 10             	add    $0x10,%esp

	return;
  800571:	90                   	nop
}
  800572:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800575:	c9                   	leave  
  800576:	c3                   	ret    

00800577 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800577:	55                   	push   %ebp
  800578:	89 e5                	mov    %esp,%ebp
  80057a:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80057d:	e8 1f 1a 00 00       	call   801fa1 <sys_getenvindex>
  800582:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800585:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800588:	89 d0                	mov    %edx,%eax
  80058a:	c1 e0 03             	shl    $0x3,%eax
  80058d:	01 d0                	add    %edx,%eax
  80058f:	01 c0                	add    %eax,%eax
  800591:	01 d0                	add    %edx,%eax
  800593:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80059a:	01 d0                	add    %edx,%eax
  80059c:	c1 e0 04             	shl    $0x4,%eax
  80059f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8005a4:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8005a9:	a1 20 50 80 00       	mov    0x805020,%eax
  8005ae:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8005b4:	84 c0                	test   %al,%al
  8005b6:	74 0f                	je     8005c7 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8005b8:	a1 20 50 80 00       	mov    0x805020,%eax
  8005bd:	05 5c 05 00 00       	add    $0x55c,%eax
  8005c2:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8005c7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8005cb:	7e 0a                	jle    8005d7 <libmain+0x60>
		binaryname = argv[0];
  8005cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005d0:	8b 00                	mov    (%eax),%eax
  8005d2:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8005d7:	83 ec 08             	sub    $0x8,%esp
  8005da:	ff 75 0c             	pushl  0xc(%ebp)
  8005dd:	ff 75 08             	pushl  0x8(%ebp)
  8005e0:	e8 53 fa ff ff       	call   800038 <_main>
  8005e5:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8005e8:	e8 c1 17 00 00       	call   801dae <sys_disable_interrupt>
	cprintf("**************************************\n");
  8005ed:	83 ec 0c             	sub    $0xc,%esp
  8005f0:	68 74 3a 80 00       	push   $0x803a74
  8005f5:	e8 6d 03 00 00       	call   800967 <cprintf>
  8005fa:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8005fd:	a1 20 50 80 00       	mov    0x805020,%eax
  800602:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800608:	a1 20 50 80 00       	mov    0x805020,%eax
  80060d:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800613:	83 ec 04             	sub    $0x4,%esp
  800616:	52                   	push   %edx
  800617:	50                   	push   %eax
  800618:	68 9c 3a 80 00       	push   $0x803a9c
  80061d:	e8 45 03 00 00       	call   800967 <cprintf>
  800622:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800625:	a1 20 50 80 00       	mov    0x805020,%eax
  80062a:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800630:	a1 20 50 80 00       	mov    0x805020,%eax
  800635:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80063b:	a1 20 50 80 00       	mov    0x805020,%eax
  800640:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800646:	51                   	push   %ecx
  800647:	52                   	push   %edx
  800648:	50                   	push   %eax
  800649:	68 c4 3a 80 00       	push   $0x803ac4
  80064e:	e8 14 03 00 00       	call   800967 <cprintf>
  800653:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800656:	a1 20 50 80 00       	mov    0x805020,%eax
  80065b:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800661:	83 ec 08             	sub    $0x8,%esp
  800664:	50                   	push   %eax
  800665:	68 1c 3b 80 00       	push   $0x803b1c
  80066a:	e8 f8 02 00 00       	call   800967 <cprintf>
  80066f:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800672:	83 ec 0c             	sub    $0xc,%esp
  800675:	68 74 3a 80 00       	push   $0x803a74
  80067a:	e8 e8 02 00 00       	call   800967 <cprintf>
  80067f:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800682:	e8 41 17 00 00       	call   801dc8 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800687:	e8 19 00 00 00       	call   8006a5 <exit>
}
  80068c:	90                   	nop
  80068d:	c9                   	leave  
  80068e:	c3                   	ret    

0080068f <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80068f:	55                   	push   %ebp
  800690:	89 e5                	mov    %esp,%ebp
  800692:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800695:	83 ec 0c             	sub    $0xc,%esp
  800698:	6a 00                	push   $0x0
  80069a:	e8 ce 18 00 00       	call   801f6d <sys_destroy_env>
  80069f:	83 c4 10             	add    $0x10,%esp
}
  8006a2:	90                   	nop
  8006a3:	c9                   	leave  
  8006a4:	c3                   	ret    

008006a5 <exit>:

void
exit(void)
{
  8006a5:	55                   	push   %ebp
  8006a6:	89 e5                	mov    %esp,%ebp
  8006a8:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8006ab:	e8 23 19 00 00       	call   801fd3 <sys_exit_env>
}
  8006b0:	90                   	nop
  8006b1:	c9                   	leave  
  8006b2:	c3                   	ret    

008006b3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8006b3:	55                   	push   %ebp
  8006b4:	89 e5                	mov    %esp,%ebp
  8006b6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8006b9:	8d 45 10             	lea    0x10(%ebp),%eax
  8006bc:	83 c0 04             	add    $0x4,%eax
  8006bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8006c2:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8006c7:	85 c0                	test   %eax,%eax
  8006c9:	74 16                	je     8006e1 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8006cb:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8006d0:	83 ec 08             	sub    $0x8,%esp
  8006d3:	50                   	push   %eax
  8006d4:	68 30 3b 80 00       	push   $0x803b30
  8006d9:	e8 89 02 00 00       	call   800967 <cprintf>
  8006de:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8006e1:	a1 00 50 80 00       	mov    0x805000,%eax
  8006e6:	ff 75 0c             	pushl  0xc(%ebp)
  8006e9:	ff 75 08             	pushl  0x8(%ebp)
  8006ec:	50                   	push   %eax
  8006ed:	68 35 3b 80 00       	push   $0x803b35
  8006f2:	e8 70 02 00 00       	call   800967 <cprintf>
  8006f7:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8006fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8006fd:	83 ec 08             	sub    $0x8,%esp
  800700:	ff 75 f4             	pushl  -0xc(%ebp)
  800703:	50                   	push   %eax
  800704:	e8 f3 01 00 00       	call   8008fc <vcprintf>
  800709:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80070c:	83 ec 08             	sub    $0x8,%esp
  80070f:	6a 00                	push   $0x0
  800711:	68 51 3b 80 00       	push   $0x803b51
  800716:	e8 e1 01 00 00       	call   8008fc <vcprintf>
  80071b:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80071e:	e8 82 ff ff ff       	call   8006a5 <exit>

	// should not return here
	while (1) ;
  800723:	eb fe                	jmp    800723 <_panic+0x70>

00800725 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800725:	55                   	push   %ebp
  800726:	89 e5                	mov    %esp,%ebp
  800728:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80072b:	a1 20 50 80 00       	mov    0x805020,%eax
  800730:	8b 50 74             	mov    0x74(%eax),%edx
  800733:	8b 45 0c             	mov    0xc(%ebp),%eax
  800736:	39 c2                	cmp    %eax,%edx
  800738:	74 14                	je     80074e <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80073a:	83 ec 04             	sub    $0x4,%esp
  80073d:	68 54 3b 80 00       	push   $0x803b54
  800742:	6a 26                	push   $0x26
  800744:	68 a0 3b 80 00       	push   $0x803ba0
  800749:	e8 65 ff ff ff       	call   8006b3 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80074e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800755:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80075c:	e9 c2 00 00 00       	jmp    800823 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800761:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800764:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80076b:	8b 45 08             	mov    0x8(%ebp),%eax
  80076e:	01 d0                	add    %edx,%eax
  800770:	8b 00                	mov    (%eax),%eax
  800772:	85 c0                	test   %eax,%eax
  800774:	75 08                	jne    80077e <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800776:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800779:	e9 a2 00 00 00       	jmp    800820 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80077e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800785:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80078c:	eb 69                	jmp    8007f7 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80078e:	a1 20 50 80 00       	mov    0x805020,%eax
  800793:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800799:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80079c:	89 d0                	mov    %edx,%eax
  80079e:	01 c0                	add    %eax,%eax
  8007a0:	01 d0                	add    %edx,%eax
  8007a2:	c1 e0 03             	shl    $0x3,%eax
  8007a5:	01 c8                	add    %ecx,%eax
  8007a7:	8a 40 04             	mov    0x4(%eax),%al
  8007aa:	84 c0                	test   %al,%al
  8007ac:	75 46                	jne    8007f4 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8007ae:	a1 20 50 80 00       	mov    0x805020,%eax
  8007b3:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8007b9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007bc:	89 d0                	mov    %edx,%eax
  8007be:	01 c0                	add    %eax,%eax
  8007c0:	01 d0                	add    %edx,%eax
  8007c2:	c1 e0 03             	shl    $0x3,%eax
  8007c5:	01 c8                	add    %ecx,%eax
  8007c7:	8b 00                	mov    (%eax),%eax
  8007c9:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8007cc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8007cf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8007d4:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8007d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007d9:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8007e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e3:	01 c8                	add    %ecx,%eax
  8007e5:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8007e7:	39 c2                	cmp    %eax,%edx
  8007e9:	75 09                	jne    8007f4 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8007eb:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8007f2:	eb 12                	jmp    800806 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8007f4:	ff 45 e8             	incl   -0x18(%ebp)
  8007f7:	a1 20 50 80 00       	mov    0x805020,%eax
  8007fc:	8b 50 74             	mov    0x74(%eax),%edx
  8007ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800802:	39 c2                	cmp    %eax,%edx
  800804:	77 88                	ja     80078e <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800806:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80080a:	75 14                	jne    800820 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80080c:	83 ec 04             	sub    $0x4,%esp
  80080f:	68 ac 3b 80 00       	push   $0x803bac
  800814:	6a 3a                	push   $0x3a
  800816:	68 a0 3b 80 00       	push   $0x803ba0
  80081b:	e8 93 fe ff ff       	call   8006b3 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800820:	ff 45 f0             	incl   -0x10(%ebp)
  800823:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800826:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800829:	0f 8c 32 ff ff ff    	jl     800761 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80082f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800836:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80083d:	eb 26                	jmp    800865 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80083f:	a1 20 50 80 00       	mov    0x805020,%eax
  800844:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80084a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80084d:	89 d0                	mov    %edx,%eax
  80084f:	01 c0                	add    %eax,%eax
  800851:	01 d0                	add    %edx,%eax
  800853:	c1 e0 03             	shl    $0x3,%eax
  800856:	01 c8                	add    %ecx,%eax
  800858:	8a 40 04             	mov    0x4(%eax),%al
  80085b:	3c 01                	cmp    $0x1,%al
  80085d:	75 03                	jne    800862 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80085f:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800862:	ff 45 e0             	incl   -0x20(%ebp)
  800865:	a1 20 50 80 00       	mov    0x805020,%eax
  80086a:	8b 50 74             	mov    0x74(%eax),%edx
  80086d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800870:	39 c2                	cmp    %eax,%edx
  800872:	77 cb                	ja     80083f <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800874:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800877:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80087a:	74 14                	je     800890 <CheckWSWithoutLastIndex+0x16b>
		panic(
  80087c:	83 ec 04             	sub    $0x4,%esp
  80087f:	68 00 3c 80 00       	push   $0x803c00
  800884:	6a 44                	push   $0x44
  800886:	68 a0 3b 80 00       	push   $0x803ba0
  80088b:	e8 23 fe ff ff       	call   8006b3 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800890:	90                   	nop
  800891:	c9                   	leave  
  800892:	c3                   	ret    

00800893 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800893:	55                   	push   %ebp
  800894:	89 e5                	mov    %esp,%ebp
  800896:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800899:	8b 45 0c             	mov    0xc(%ebp),%eax
  80089c:	8b 00                	mov    (%eax),%eax
  80089e:	8d 48 01             	lea    0x1(%eax),%ecx
  8008a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008a4:	89 0a                	mov    %ecx,(%edx)
  8008a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8008a9:	88 d1                	mov    %dl,%cl
  8008ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ae:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8008b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008b5:	8b 00                	mov    (%eax),%eax
  8008b7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8008bc:	75 2c                	jne    8008ea <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8008be:	a0 24 50 80 00       	mov    0x805024,%al
  8008c3:	0f b6 c0             	movzbl %al,%eax
  8008c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008c9:	8b 12                	mov    (%edx),%edx
  8008cb:	89 d1                	mov    %edx,%ecx
  8008cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008d0:	83 c2 08             	add    $0x8,%edx
  8008d3:	83 ec 04             	sub    $0x4,%esp
  8008d6:	50                   	push   %eax
  8008d7:	51                   	push   %ecx
  8008d8:	52                   	push   %edx
  8008d9:	e8 22 13 00 00       	call   801c00 <sys_cputs>
  8008de:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8008e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8008ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ed:	8b 40 04             	mov    0x4(%eax),%eax
  8008f0:	8d 50 01             	lea    0x1(%eax),%edx
  8008f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008f6:	89 50 04             	mov    %edx,0x4(%eax)
}
  8008f9:	90                   	nop
  8008fa:	c9                   	leave  
  8008fb:	c3                   	ret    

008008fc <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8008fc:	55                   	push   %ebp
  8008fd:	89 e5                	mov    %esp,%ebp
  8008ff:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800905:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80090c:	00 00 00 
	b.cnt = 0;
  80090f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800916:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800919:	ff 75 0c             	pushl  0xc(%ebp)
  80091c:	ff 75 08             	pushl  0x8(%ebp)
  80091f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800925:	50                   	push   %eax
  800926:	68 93 08 80 00       	push   $0x800893
  80092b:	e8 11 02 00 00       	call   800b41 <vprintfmt>
  800930:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800933:	a0 24 50 80 00       	mov    0x805024,%al
  800938:	0f b6 c0             	movzbl %al,%eax
  80093b:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800941:	83 ec 04             	sub    $0x4,%esp
  800944:	50                   	push   %eax
  800945:	52                   	push   %edx
  800946:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80094c:	83 c0 08             	add    $0x8,%eax
  80094f:	50                   	push   %eax
  800950:	e8 ab 12 00 00       	call   801c00 <sys_cputs>
  800955:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800958:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  80095f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800965:	c9                   	leave  
  800966:	c3                   	ret    

00800967 <cprintf>:

int cprintf(const char *fmt, ...) {
  800967:	55                   	push   %ebp
  800968:	89 e5                	mov    %esp,%ebp
  80096a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80096d:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800974:	8d 45 0c             	lea    0xc(%ebp),%eax
  800977:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80097a:	8b 45 08             	mov    0x8(%ebp),%eax
  80097d:	83 ec 08             	sub    $0x8,%esp
  800980:	ff 75 f4             	pushl  -0xc(%ebp)
  800983:	50                   	push   %eax
  800984:	e8 73 ff ff ff       	call   8008fc <vcprintf>
  800989:	83 c4 10             	add    $0x10,%esp
  80098c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80098f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800992:	c9                   	leave  
  800993:	c3                   	ret    

00800994 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800994:	55                   	push   %ebp
  800995:	89 e5                	mov    %esp,%ebp
  800997:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80099a:	e8 0f 14 00 00       	call   801dae <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80099f:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a8:	83 ec 08             	sub    $0x8,%esp
  8009ab:	ff 75 f4             	pushl  -0xc(%ebp)
  8009ae:	50                   	push   %eax
  8009af:	e8 48 ff ff ff       	call   8008fc <vcprintf>
  8009b4:	83 c4 10             	add    $0x10,%esp
  8009b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8009ba:	e8 09 14 00 00       	call   801dc8 <sys_enable_interrupt>
	return cnt;
  8009bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009c2:	c9                   	leave  
  8009c3:	c3                   	ret    

008009c4 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8009c4:	55                   	push   %ebp
  8009c5:	89 e5                	mov    %esp,%ebp
  8009c7:	53                   	push   %ebx
  8009c8:	83 ec 14             	sub    $0x14,%esp
  8009cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8009d7:	8b 45 18             	mov    0x18(%ebp),%eax
  8009da:	ba 00 00 00 00       	mov    $0x0,%edx
  8009df:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8009e2:	77 55                	ja     800a39 <printnum+0x75>
  8009e4:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8009e7:	72 05                	jb     8009ee <printnum+0x2a>
  8009e9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8009ec:	77 4b                	ja     800a39 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8009ee:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8009f1:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8009f4:	8b 45 18             	mov    0x18(%ebp),%eax
  8009f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8009fc:	52                   	push   %edx
  8009fd:	50                   	push   %eax
  8009fe:	ff 75 f4             	pushl  -0xc(%ebp)
  800a01:	ff 75 f0             	pushl  -0x10(%ebp)
  800a04:	e8 b3 29 00 00       	call   8033bc <__udivdi3>
  800a09:	83 c4 10             	add    $0x10,%esp
  800a0c:	83 ec 04             	sub    $0x4,%esp
  800a0f:	ff 75 20             	pushl  0x20(%ebp)
  800a12:	53                   	push   %ebx
  800a13:	ff 75 18             	pushl  0x18(%ebp)
  800a16:	52                   	push   %edx
  800a17:	50                   	push   %eax
  800a18:	ff 75 0c             	pushl  0xc(%ebp)
  800a1b:	ff 75 08             	pushl  0x8(%ebp)
  800a1e:	e8 a1 ff ff ff       	call   8009c4 <printnum>
  800a23:	83 c4 20             	add    $0x20,%esp
  800a26:	eb 1a                	jmp    800a42 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a28:	83 ec 08             	sub    $0x8,%esp
  800a2b:	ff 75 0c             	pushl  0xc(%ebp)
  800a2e:	ff 75 20             	pushl  0x20(%ebp)
  800a31:	8b 45 08             	mov    0x8(%ebp),%eax
  800a34:	ff d0                	call   *%eax
  800a36:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800a39:	ff 4d 1c             	decl   0x1c(%ebp)
  800a3c:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800a40:	7f e6                	jg     800a28 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800a42:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800a45:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a50:	53                   	push   %ebx
  800a51:	51                   	push   %ecx
  800a52:	52                   	push   %edx
  800a53:	50                   	push   %eax
  800a54:	e8 73 2a 00 00       	call   8034cc <__umoddi3>
  800a59:	83 c4 10             	add    $0x10,%esp
  800a5c:	05 74 3e 80 00       	add    $0x803e74,%eax
  800a61:	8a 00                	mov    (%eax),%al
  800a63:	0f be c0             	movsbl %al,%eax
  800a66:	83 ec 08             	sub    $0x8,%esp
  800a69:	ff 75 0c             	pushl  0xc(%ebp)
  800a6c:	50                   	push   %eax
  800a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a70:	ff d0                	call   *%eax
  800a72:	83 c4 10             	add    $0x10,%esp
}
  800a75:	90                   	nop
  800a76:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a79:	c9                   	leave  
  800a7a:	c3                   	ret    

00800a7b <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800a7b:	55                   	push   %ebp
  800a7c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800a7e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800a82:	7e 1c                	jle    800aa0 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800a84:	8b 45 08             	mov    0x8(%ebp),%eax
  800a87:	8b 00                	mov    (%eax),%eax
  800a89:	8d 50 08             	lea    0x8(%eax),%edx
  800a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8f:	89 10                	mov    %edx,(%eax)
  800a91:	8b 45 08             	mov    0x8(%ebp),%eax
  800a94:	8b 00                	mov    (%eax),%eax
  800a96:	83 e8 08             	sub    $0x8,%eax
  800a99:	8b 50 04             	mov    0x4(%eax),%edx
  800a9c:	8b 00                	mov    (%eax),%eax
  800a9e:	eb 40                	jmp    800ae0 <getuint+0x65>
	else if (lflag)
  800aa0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800aa4:	74 1e                	je     800ac4 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa9:	8b 00                	mov    (%eax),%eax
  800aab:	8d 50 04             	lea    0x4(%eax),%edx
  800aae:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab1:	89 10                	mov    %edx,(%eax)
  800ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab6:	8b 00                	mov    (%eax),%eax
  800ab8:	83 e8 04             	sub    $0x4,%eax
  800abb:	8b 00                	mov    (%eax),%eax
  800abd:	ba 00 00 00 00       	mov    $0x0,%edx
  800ac2:	eb 1c                	jmp    800ae0 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac7:	8b 00                	mov    (%eax),%eax
  800ac9:	8d 50 04             	lea    0x4(%eax),%edx
  800acc:	8b 45 08             	mov    0x8(%ebp),%eax
  800acf:	89 10                	mov    %edx,(%eax)
  800ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad4:	8b 00                	mov    (%eax),%eax
  800ad6:	83 e8 04             	sub    $0x4,%eax
  800ad9:	8b 00                	mov    (%eax),%eax
  800adb:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800ae0:	5d                   	pop    %ebp
  800ae1:	c3                   	ret    

00800ae2 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800ae2:	55                   	push   %ebp
  800ae3:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ae5:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800ae9:	7e 1c                	jle    800b07 <getint+0x25>
		return va_arg(*ap, long long);
  800aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800aee:	8b 00                	mov    (%eax),%eax
  800af0:	8d 50 08             	lea    0x8(%eax),%edx
  800af3:	8b 45 08             	mov    0x8(%ebp),%eax
  800af6:	89 10                	mov    %edx,(%eax)
  800af8:	8b 45 08             	mov    0x8(%ebp),%eax
  800afb:	8b 00                	mov    (%eax),%eax
  800afd:	83 e8 08             	sub    $0x8,%eax
  800b00:	8b 50 04             	mov    0x4(%eax),%edx
  800b03:	8b 00                	mov    (%eax),%eax
  800b05:	eb 38                	jmp    800b3f <getint+0x5d>
	else if (lflag)
  800b07:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b0b:	74 1a                	je     800b27 <getint+0x45>
		return va_arg(*ap, long);
  800b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b10:	8b 00                	mov    (%eax),%eax
  800b12:	8d 50 04             	lea    0x4(%eax),%edx
  800b15:	8b 45 08             	mov    0x8(%ebp),%eax
  800b18:	89 10                	mov    %edx,(%eax)
  800b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1d:	8b 00                	mov    (%eax),%eax
  800b1f:	83 e8 04             	sub    $0x4,%eax
  800b22:	8b 00                	mov    (%eax),%eax
  800b24:	99                   	cltd   
  800b25:	eb 18                	jmp    800b3f <getint+0x5d>
	else
		return va_arg(*ap, int);
  800b27:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2a:	8b 00                	mov    (%eax),%eax
  800b2c:	8d 50 04             	lea    0x4(%eax),%edx
  800b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b32:	89 10                	mov    %edx,(%eax)
  800b34:	8b 45 08             	mov    0x8(%ebp),%eax
  800b37:	8b 00                	mov    (%eax),%eax
  800b39:	83 e8 04             	sub    $0x4,%eax
  800b3c:	8b 00                	mov    (%eax),%eax
  800b3e:	99                   	cltd   
}
  800b3f:	5d                   	pop    %ebp
  800b40:	c3                   	ret    

00800b41 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b41:	55                   	push   %ebp
  800b42:	89 e5                	mov    %esp,%ebp
  800b44:	56                   	push   %esi
  800b45:	53                   	push   %ebx
  800b46:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b49:	eb 17                	jmp    800b62 <vprintfmt+0x21>
			if (ch == '\0')
  800b4b:	85 db                	test   %ebx,%ebx
  800b4d:	0f 84 af 03 00 00    	je     800f02 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800b53:	83 ec 08             	sub    $0x8,%esp
  800b56:	ff 75 0c             	pushl  0xc(%ebp)
  800b59:	53                   	push   %ebx
  800b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5d:	ff d0                	call   *%eax
  800b5f:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b62:	8b 45 10             	mov    0x10(%ebp),%eax
  800b65:	8d 50 01             	lea    0x1(%eax),%edx
  800b68:	89 55 10             	mov    %edx,0x10(%ebp)
  800b6b:	8a 00                	mov    (%eax),%al
  800b6d:	0f b6 d8             	movzbl %al,%ebx
  800b70:	83 fb 25             	cmp    $0x25,%ebx
  800b73:	75 d6                	jne    800b4b <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800b75:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800b79:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800b80:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800b87:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800b8e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b95:	8b 45 10             	mov    0x10(%ebp),%eax
  800b98:	8d 50 01             	lea    0x1(%eax),%edx
  800b9b:	89 55 10             	mov    %edx,0x10(%ebp)
  800b9e:	8a 00                	mov    (%eax),%al
  800ba0:	0f b6 d8             	movzbl %al,%ebx
  800ba3:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800ba6:	83 f8 55             	cmp    $0x55,%eax
  800ba9:	0f 87 2b 03 00 00    	ja     800eda <vprintfmt+0x399>
  800baf:	8b 04 85 98 3e 80 00 	mov    0x803e98(,%eax,4),%eax
  800bb6:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800bb8:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800bbc:	eb d7                	jmp    800b95 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800bbe:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800bc2:	eb d1                	jmp    800b95 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bc4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800bcb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800bce:	89 d0                	mov    %edx,%eax
  800bd0:	c1 e0 02             	shl    $0x2,%eax
  800bd3:	01 d0                	add    %edx,%eax
  800bd5:	01 c0                	add    %eax,%eax
  800bd7:	01 d8                	add    %ebx,%eax
  800bd9:	83 e8 30             	sub    $0x30,%eax
  800bdc:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800bdf:	8b 45 10             	mov    0x10(%ebp),%eax
  800be2:	8a 00                	mov    (%eax),%al
  800be4:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800be7:	83 fb 2f             	cmp    $0x2f,%ebx
  800bea:	7e 3e                	jle    800c2a <vprintfmt+0xe9>
  800bec:	83 fb 39             	cmp    $0x39,%ebx
  800bef:	7f 39                	jg     800c2a <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bf1:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800bf4:	eb d5                	jmp    800bcb <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800bf6:	8b 45 14             	mov    0x14(%ebp),%eax
  800bf9:	83 c0 04             	add    $0x4,%eax
  800bfc:	89 45 14             	mov    %eax,0x14(%ebp)
  800bff:	8b 45 14             	mov    0x14(%ebp),%eax
  800c02:	83 e8 04             	sub    $0x4,%eax
  800c05:	8b 00                	mov    (%eax),%eax
  800c07:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800c0a:	eb 1f                	jmp    800c2b <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800c0c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c10:	79 83                	jns    800b95 <vprintfmt+0x54>
				width = 0;
  800c12:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800c19:	e9 77 ff ff ff       	jmp    800b95 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800c1e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800c25:	e9 6b ff ff ff       	jmp    800b95 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c2a:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c2b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c2f:	0f 89 60 ff ff ff    	jns    800b95 <vprintfmt+0x54>
				width = precision, precision = -1;
  800c35:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c38:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c3b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800c42:	e9 4e ff ff ff       	jmp    800b95 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c47:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800c4a:	e9 46 ff ff ff       	jmp    800b95 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800c4f:	8b 45 14             	mov    0x14(%ebp),%eax
  800c52:	83 c0 04             	add    $0x4,%eax
  800c55:	89 45 14             	mov    %eax,0x14(%ebp)
  800c58:	8b 45 14             	mov    0x14(%ebp),%eax
  800c5b:	83 e8 04             	sub    $0x4,%eax
  800c5e:	8b 00                	mov    (%eax),%eax
  800c60:	83 ec 08             	sub    $0x8,%esp
  800c63:	ff 75 0c             	pushl  0xc(%ebp)
  800c66:	50                   	push   %eax
  800c67:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6a:	ff d0                	call   *%eax
  800c6c:	83 c4 10             	add    $0x10,%esp
			break;
  800c6f:	e9 89 02 00 00       	jmp    800efd <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800c74:	8b 45 14             	mov    0x14(%ebp),%eax
  800c77:	83 c0 04             	add    $0x4,%eax
  800c7a:	89 45 14             	mov    %eax,0x14(%ebp)
  800c7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c80:	83 e8 04             	sub    $0x4,%eax
  800c83:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800c85:	85 db                	test   %ebx,%ebx
  800c87:	79 02                	jns    800c8b <vprintfmt+0x14a>
				err = -err;
  800c89:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800c8b:	83 fb 64             	cmp    $0x64,%ebx
  800c8e:	7f 0b                	jg     800c9b <vprintfmt+0x15a>
  800c90:	8b 34 9d e0 3c 80 00 	mov    0x803ce0(,%ebx,4),%esi
  800c97:	85 f6                	test   %esi,%esi
  800c99:	75 19                	jne    800cb4 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800c9b:	53                   	push   %ebx
  800c9c:	68 85 3e 80 00       	push   $0x803e85
  800ca1:	ff 75 0c             	pushl  0xc(%ebp)
  800ca4:	ff 75 08             	pushl  0x8(%ebp)
  800ca7:	e8 5e 02 00 00       	call   800f0a <printfmt>
  800cac:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800caf:	e9 49 02 00 00       	jmp    800efd <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800cb4:	56                   	push   %esi
  800cb5:	68 8e 3e 80 00       	push   $0x803e8e
  800cba:	ff 75 0c             	pushl  0xc(%ebp)
  800cbd:	ff 75 08             	pushl  0x8(%ebp)
  800cc0:	e8 45 02 00 00       	call   800f0a <printfmt>
  800cc5:	83 c4 10             	add    $0x10,%esp
			break;
  800cc8:	e9 30 02 00 00       	jmp    800efd <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ccd:	8b 45 14             	mov    0x14(%ebp),%eax
  800cd0:	83 c0 04             	add    $0x4,%eax
  800cd3:	89 45 14             	mov    %eax,0x14(%ebp)
  800cd6:	8b 45 14             	mov    0x14(%ebp),%eax
  800cd9:	83 e8 04             	sub    $0x4,%eax
  800cdc:	8b 30                	mov    (%eax),%esi
  800cde:	85 f6                	test   %esi,%esi
  800ce0:	75 05                	jne    800ce7 <vprintfmt+0x1a6>
				p = "(null)";
  800ce2:	be 91 3e 80 00       	mov    $0x803e91,%esi
			if (width > 0 && padc != '-')
  800ce7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ceb:	7e 6d                	jle    800d5a <vprintfmt+0x219>
  800ced:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800cf1:	74 67                	je     800d5a <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800cf3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800cf6:	83 ec 08             	sub    $0x8,%esp
  800cf9:	50                   	push   %eax
  800cfa:	56                   	push   %esi
  800cfb:	e8 0c 03 00 00       	call   80100c <strnlen>
  800d00:	83 c4 10             	add    $0x10,%esp
  800d03:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800d06:	eb 16                	jmp    800d1e <vprintfmt+0x1dd>
					putch(padc, putdat);
  800d08:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800d0c:	83 ec 08             	sub    $0x8,%esp
  800d0f:	ff 75 0c             	pushl  0xc(%ebp)
  800d12:	50                   	push   %eax
  800d13:	8b 45 08             	mov    0x8(%ebp),%eax
  800d16:	ff d0                	call   *%eax
  800d18:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d1b:	ff 4d e4             	decl   -0x1c(%ebp)
  800d1e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d22:	7f e4                	jg     800d08 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d24:	eb 34                	jmp    800d5a <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800d26:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d2a:	74 1c                	je     800d48 <vprintfmt+0x207>
  800d2c:	83 fb 1f             	cmp    $0x1f,%ebx
  800d2f:	7e 05                	jle    800d36 <vprintfmt+0x1f5>
  800d31:	83 fb 7e             	cmp    $0x7e,%ebx
  800d34:	7e 12                	jle    800d48 <vprintfmt+0x207>
					putch('?', putdat);
  800d36:	83 ec 08             	sub    $0x8,%esp
  800d39:	ff 75 0c             	pushl  0xc(%ebp)
  800d3c:	6a 3f                	push   $0x3f
  800d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d41:	ff d0                	call   *%eax
  800d43:	83 c4 10             	add    $0x10,%esp
  800d46:	eb 0f                	jmp    800d57 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800d48:	83 ec 08             	sub    $0x8,%esp
  800d4b:	ff 75 0c             	pushl  0xc(%ebp)
  800d4e:	53                   	push   %ebx
  800d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d52:	ff d0                	call   *%eax
  800d54:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d57:	ff 4d e4             	decl   -0x1c(%ebp)
  800d5a:	89 f0                	mov    %esi,%eax
  800d5c:	8d 70 01             	lea    0x1(%eax),%esi
  800d5f:	8a 00                	mov    (%eax),%al
  800d61:	0f be d8             	movsbl %al,%ebx
  800d64:	85 db                	test   %ebx,%ebx
  800d66:	74 24                	je     800d8c <vprintfmt+0x24b>
  800d68:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d6c:	78 b8                	js     800d26 <vprintfmt+0x1e5>
  800d6e:	ff 4d e0             	decl   -0x20(%ebp)
  800d71:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d75:	79 af                	jns    800d26 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d77:	eb 13                	jmp    800d8c <vprintfmt+0x24b>
				putch(' ', putdat);
  800d79:	83 ec 08             	sub    $0x8,%esp
  800d7c:	ff 75 0c             	pushl  0xc(%ebp)
  800d7f:	6a 20                	push   $0x20
  800d81:	8b 45 08             	mov    0x8(%ebp),%eax
  800d84:	ff d0                	call   *%eax
  800d86:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d89:	ff 4d e4             	decl   -0x1c(%ebp)
  800d8c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d90:	7f e7                	jg     800d79 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800d92:	e9 66 01 00 00       	jmp    800efd <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800d97:	83 ec 08             	sub    $0x8,%esp
  800d9a:	ff 75 e8             	pushl  -0x18(%ebp)
  800d9d:	8d 45 14             	lea    0x14(%ebp),%eax
  800da0:	50                   	push   %eax
  800da1:	e8 3c fd ff ff       	call   800ae2 <getint>
  800da6:	83 c4 10             	add    $0x10,%esp
  800da9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dac:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800daf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800db2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800db5:	85 d2                	test   %edx,%edx
  800db7:	79 23                	jns    800ddc <vprintfmt+0x29b>
				putch('-', putdat);
  800db9:	83 ec 08             	sub    $0x8,%esp
  800dbc:	ff 75 0c             	pushl  0xc(%ebp)
  800dbf:	6a 2d                	push   $0x2d
  800dc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc4:	ff d0                	call   *%eax
  800dc6:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800dc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dcc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dcf:	f7 d8                	neg    %eax
  800dd1:	83 d2 00             	adc    $0x0,%edx
  800dd4:	f7 da                	neg    %edx
  800dd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dd9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ddc:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800de3:	e9 bc 00 00 00       	jmp    800ea4 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800de8:	83 ec 08             	sub    $0x8,%esp
  800deb:	ff 75 e8             	pushl  -0x18(%ebp)
  800dee:	8d 45 14             	lea    0x14(%ebp),%eax
  800df1:	50                   	push   %eax
  800df2:	e8 84 fc ff ff       	call   800a7b <getuint>
  800df7:	83 c4 10             	add    $0x10,%esp
  800dfa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dfd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800e00:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e07:	e9 98 00 00 00       	jmp    800ea4 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e0c:	83 ec 08             	sub    $0x8,%esp
  800e0f:	ff 75 0c             	pushl  0xc(%ebp)
  800e12:	6a 58                	push   $0x58
  800e14:	8b 45 08             	mov    0x8(%ebp),%eax
  800e17:	ff d0                	call   *%eax
  800e19:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e1c:	83 ec 08             	sub    $0x8,%esp
  800e1f:	ff 75 0c             	pushl  0xc(%ebp)
  800e22:	6a 58                	push   $0x58
  800e24:	8b 45 08             	mov    0x8(%ebp),%eax
  800e27:	ff d0                	call   *%eax
  800e29:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e2c:	83 ec 08             	sub    $0x8,%esp
  800e2f:	ff 75 0c             	pushl  0xc(%ebp)
  800e32:	6a 58                	push   $0x58
  800e34:	8b 45 08             	mov    0x8(%ebp),%eax
  800e37:	ff d0                	call   *%eax
  800e39:	83 c4 10             	add    $0x10,%esp
			break;
  800e3c:	e9 bc 00 00 00       	jmp    800efd <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800e41:	83 ec 08             	sub    $0x8,%esp
  800e44:	ff 75 0c             	pushl  0xc(%ebp)
  800e47:	6a 30                	push   $0x30
  800e49:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4c:	ff d0                	call   *%eax
  800e4e:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800e51:	83 ec 08             	sub    $0x8,%esp
  800e54:	ff 75 0c             	pushl  0xc(%ebp)
  800e57:	6a 78                	push   $0x78
  800e59:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5c:	ff d0                	call   *%eax
  800e5e:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800e61:	8b 45 14             	mov    0x14(%ebp),%eax
  800e64:	83 c0 04             	add    $0x4,%eax
  800e67:	89 45 14             	mov    %eax,0x14(%ebp)
  800e6a:	8b 45 14             	mov    0x14(%ebp),%eax
  800e6d:	83 e8 04             	sub    $0x4,%eax
  800e70:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e72:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e75:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800e7c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800e83:	eb 1f                	jmp    800ea4 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800e85:	83 ec 08             	sub    $0x8,%esp
  800e88:	ff 75 e8             	pushl  -0x18(%ebp)
  800e8b:	8d 45 14             	lea    0x14(%ebp),%eax
  800e8e:	50                   	push   %eax
  800e8f:	e8 e7 fb ff ff       	call   800a7b <getuint>
  800e94:	83 c4 10             	add    $0x10,%esp
  800e97:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e9a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800e9d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ea4:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ea8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800eab:	83 ec 04             	sub    $0x4,%esp
  800eae:	52                   	push   %edx
  800eaf:	ff 75 e4             	pushl  -0x1c(%ebp)
  800eb2:	50                   	push   %eax
  800eb3:	ff 75 f4             	pushl  -0xc(%ebp)
  800eb6:	ff 75 f0             	pushl  -0x10(%ebp)
  800eb9:	ff 75 0c             	pushl  0xc(%ebp)
  800ebc:	ff 75 08             	pushl  0x8(%ebp)
  800ebf:	e8 00 fb ff ff       	call   8009c4 <printnum>
  800ec4:	83 c4 20             	add    $0x20,%esp
			break;
  800ec7:	eb 34                	jmp    800efd <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ec9:	83 ec 08             	sub    $0x8,%esp
  800ecc:	ff 75 0c             	pushl  0xc(%ebp)
  800ecf:	53                   	push   %ebx
  800ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed3:	ff d0                	call   *%eax
  800ed5:	83 c4 10             	add    $0x10,%esp
			break;
  800ed8:	eb 23                	jmp    800efd <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800eda:	83 ec 08             	sub    $0x8,%esp
  800edd:	ff 75 0c             	pushl  0xc(%ebp)
  800ee0:	6a 25                	push   $0x25
  800ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee5:	ff d0                	call   *%eax
  800ee7:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800eea:	ff 4d 10             	decl   0x10(%ebp)
  800eed:	eb 03                	jmp    800ef2 <vprintfmt+0x3b1>
  800eef:	ff 4d 10             	decl   0x10(%ebp)
  800ef2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef5:	48                   	dec    %eax
  800ef6:	8a 00                	mov    (%eax),%al
  800ef8:	3c 25                	cmp    $0x25,%al
  800efa:	75 f3                	jne    800eef <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800efc:	90                   	nop
		}
	}
  800efd:	e9 47 fc ff ff       	jmp    800b49 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f02:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800f03:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f06:	5b                   	pop    %ebx
  800f07:	5e                   	pop    %esi
  800f08:	5d                   	pop    %ebp
  800f09:	c3                   	ret    

00800f0a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f0a:	55                   	push   %ebp
  800f0b:	89 e5                	mov    %esp,%ebp
  800f0d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f10:	8d 45 10             	lea    0x10(%ebp),%eax
  800f13:	83 c0 04             	add    $0x4,%eax
  800f16:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f19:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1c:	ff 75 f4             	pushl  -0xc(%ebp)
  800f1f:	50                   	push   %eax
  800f20:	ff 75 0c             	pushl  0xc(%ebp)
  800f23:	ff 75 08             	pushl  0x8(%ebp)
  800f26:	e8 16 fc ff ff       	call   800b41 <vprintfmt>
  800f2b:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800f2e:	90                   	nop
  800f2f:	c9                   	leave  
  800f30:	c3                   	ret    

00800f31 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f31:	55                   	push   %ebp
  800f32:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800f34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f37:	8b 40 08             	mov    0x8(%eax),%eax
  800f3a:	8d 50 01             	lea    0x1(%eax),%edx
  800f3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f40:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800f43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f46:	8b 10                	mov    (%eax),%edx
  800f48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4b:	8b 40 04             	mov    0x4(%eax),%eax
  800f4e:	39 c2                	cmp    %eax,%edx
  800f50:	73 12                	jae    800f64 <sprintputch+0x33>
		*b->buf++ = ch;
  800f52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f55:	8b 00                	mov    (%eax),%eax
  800f57:	8d 48 01             	lea    0x1(%eax),%ecx
  800f5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f5d:	89 0a                	mov    %ecx,(%edx)
  800f5f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f62:	88 10                	mov    %dl,(%eax)
}
  800f64:	90                   	nop
  800f65:	5d                   	pop    %ebp
  800f66:	c3                   	ret    

00800f67 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f67:	55                   	push   %ebp
  800f68:	89 e5                	mov    %esp,%ebp
  800f6a:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f70:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800f73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f76:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f79:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7c:	01 d0                	add    %edx,%eax
  800f7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f81:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800f88:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f8c:	74 06                	je     800f94 <vsnprintf+0x2d>
  800f8e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f92:	7f 07                	jg     800f9b <vsnprintf+0x34>
		return -E_INVAL;
  800f94:	b8 03 00 00 00       	mov    $0x3,%eax
  800f99:	eb 20                	jmp    800fbb <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800f9b:	ff 75 14             	pushl  0x14(%ebp)
  800f9e:	ff 75 10             	pushl  0x10(%ebp)
  800fa1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800fa4:	50                   	push   %eax
  800fa5:	68 31 0f 80 00       	push   $0x800f31
  800faa:	e8 92 fb ff ff       	call   800b41 <vprintfmt>
  800faf:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800fb2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fb5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800fb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800fbb:	c9                   	leave  
  800fbc:	c3                   	ret    

00800fbd <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800fbd:	55                   	push   %ebp
  800fbe:	89 e5                	mov    %esp,%ebp
  800fc0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800fc3:	8d 45 10             	lea    0x10(%ebp),%eax
  800fc6:	83 c0 04             	add    $0x4,%eax
  800fc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800fcc:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcf:	ff 75 f4             	pushl  -0xc(%ebp)
  800fd2:	50                   	push   %eax
  800fd3:	ff 75 0c             	pushl  0xc(%ebp)
  800fd6:	ff 75 08             	pushl  0x8(%ebp)
  800fd9:	e8 89 ff ff ff       	call   800f67 <vsnprintf>
  800fde:	83 c4 10             	add    $0x10,%esp
  800fe1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800fe4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800fe7:	c9                   	leave  
  800fe8:	c3                   	ret    

00800fe9 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800fe9:	55                   	push   %ebp
  800fea:	89 e5                	mov    %esp,%ebp
  800fec:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800fef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ff6:	eb 06                	jmp    800ffe <strlen+0x15>
		n++;
  800ff8:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ffb:	ff 45 08             	incl   0x8(%ebp)
  800ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  801001:	8a 00                	mov    (%eax),%al
  801003:	84 c0                	test   %al,%al
  801005:	75 f1                	jne    800ff8 <strlen+0xf>
		n++;
	return n;
  801007:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80100a:	c9                   	leave  
  80100b:	c3                   	ret    

0080100c <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80100c:	55                   	push   %ebp
  80100d:	89 e5                	mov    %esp,%ebp
  80100f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801012:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801019:	eb 09                	jmp    801024 <strnlen+0x18>
		n++;
  80101b:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80101e:	ff 45 08             	incl   0x8(%ebp)
  801021:	ff 4d 0c             	decl   0xc(%ebp)
  801024:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801028:	74 09                	je     801033 <strnlen+0x27>
  80102a:	8b 45 08             	mov    0x8(%ebp),%eax
  80102d:	8a 00                	mov    (%eax),%al
  80102f:	84 c0                	test   %al,%al
  801031:	75 e8                	jne    80101b <strnlen+0xf>
		n++;
	return n;
  801033:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801036:	c9                   	leave  
  801037:	c3                   	ret    

00801038 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801038:	55                   	push   %ebp
  801039:	89 e5                	mov    %esp,%ebp
  80103b:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80103e:	8b 45 08             	mov    0x8(%ebp),%eax
  801041:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801044:	90                   	nop
  801045:	8b 45 08             	mov    0x8(%ebp),%eax
  801048:	8d 50 01             	lea    0x1(%eax),%edx
  80104b:	89 55 08             	mov    %edx,0x8(%ebp)
  80104e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801051:	8d 4a 01             	lea    0x1(%edx),%ecx
  801054:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801057:	8a 12                	mov    (%edx),%dl
  801059:	88 10                	mov    %dl,(%eax)
  80105b:	8a 00                	mov    (%eax),%al
  80105d:	84 c0                	test   %al,%al
  80105f:	75 e4                	jne    801045 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801061:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801064:	c9                   	leave  
  801065:	c3                   	ret    

00801066 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801066:	55                   	push   %ebp
  801067:	89 e5                	mov    %esp,%ebp
  801069:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80106c:	8b 45 08             	mov    0x8(%ebp),%eax
  80106f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801072:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801079:	eb 1f                	jmp    80109a <strncpy+0x34>
		*dst++ = *src;
  80107b:	8b 45 08             	mov    0x8(%ebp),%eax
  80107e:	8d 50 01             	lea    0x1(%eax),%edx
  801081:	89 55 08             	mov    %edx,0x8(%ebp)
  801084:	8b 55 0c             	mov    0xc(%ebp),%edx
  801087:	8a 12                	mov    (%edx),%dl
  801089:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80108b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108e:	8a 00                	mov    (%eax),%al
  801090:	84 c0                	test   %al,%al
  801092:	74 03                	je     801097 <strncpy+0x31>
			src++;
  801094:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801097:	ff 45 fc             	incl   -0x4(%ebp)
  80109a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80109d:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010a0:	72 d9                	jb     80107b <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8010a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010a5:	c9                   	leave  
  8010a6:	c3                   	ret    

008010a7 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8010a7:	55                   	push   %ebp
  8010a8:	89 e5                	mov    %esp,%ebp
  8010aa:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8010ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8010b3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010b7:	74 30                	je     8010e9 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8010b9:	eb 16                	jmp    8010d1 <strlcpy+0x2a>
			*dst++ = *src++;
  8010bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010be:	8d 50 01             	lea    0x1(%eax),%edx
  8010c1:	89 55 08             	mov    %edx,0x8(%ebp)
  8010c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010c7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010ca:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010cd:	8a 12                	mov    (%edx),%dl
  8010cf:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8010d1:	ff 4d 10             	decl   0x10(%ebp)
  8010d4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010d8:	74 09                	je     8010e3 <strlcpy+0x3c>
  8010da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010dd:	8a 00                	mov    (%eax),%al
  8010df:	84 c0                	test   %al,%al
  8010e1:	75 d8                	jne    8010bb <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8010e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8010e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ef:	29 c2                	sub    %eax,%edx
  8010f1:	89 d0                	mov    %edx,%eax
}
  8010f3:	c9                   	leave  
  8010f4:	c3                   	ret    

008010f5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8010f5:	55                   	push   %ebp
  8010f6:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8010f8:	eb 06                	jmp    801100 <strcmp+0xb>
		p++, q++;
  8010fa:	ff 45 08             	incl   0x8(%ebp)
  8010fd:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801100:	8b 45 08             	mov    0x8(%ebp),%eax
  801103:	8a 00                	mov    (%eax),%al
  801105:	84 c0                	test   %al,%al
  801107:	74 0e                	je     801117 <strcmp+0x22>
  801109:	8b 45 08             	mov    0x8(%ebp),%eax
  80110c:	8a 10                	mov    (%eax),%dl
  80110e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801111:	8a 00                	mov    (%eax),%al
  801113:	38 c2                	cmp    %al,%dl
  801115:	74 e3                	je     8010fa <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801117:	8b 45 08             	mov    0x8(%ebp),%eax
  80111a:	8a 00                	mov    (%eax),%al
  80111c:	0f b6 d0             	movzbl %al,%edx
  80111f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801122:	8a 00                	mov    (%eax),%al
  801124:	0f b6 c0             	movzbl %al,%eax
  801127:	29 c2                	sub    %eax,%edx
  801129:	89 d0                	mov    %edx,%eax
}
  80112b:	5d                   	pop    %ebp
  80112c:	c3                   	ret    

0080112d <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80112d:	55                   	push   %ebp
  80112e:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801130:	eb 09                	jmp    80113b <strncmp+0xe>
		n--, p++, q++;
  801132:	ff 4d 10             	decl   0x10(%ebp)
  801135:	ff 45 08             	incl   0x8(%ebp)
  801138:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80113b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80113f:	74 17                	je     801158 <strncmp+0x2b>
  801141:	8b 45 08             	mov    0x8(%ebp),%eax
  801144:	8a 00                	mov    (%eax),%al
  801146:	84 c0                	test   %al,%al
  801148:	74 0e                	je     801158 <strncmp+0x2b>
  80114a:	8b 45 08             	mov    0x8(%ebp),%eax
  80114d:	8a 10                	mov    (%eax),%dl
  80114f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801152:	8a 00                	mov    (%eax),%al
  801154:	38 c2                	cmp    %al,%dl
  801156:	74 da                	je     801132 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801158:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80115c:	75 07                	jne    801165 <strncmp+0x38>
		return 0;
  80115e:	b8 00 00 00 00       	mov    $0x0,%eax
  801163:	eb 14                	jmp    801179 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801165:	8b 45 08             	mov    0x8(%ebp),%eax
  801168:	8a 00                	mov    (%eax),%al
  80116a:	0f b6 d0             	movzbl %al,%edx
  80116d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801170:	8a 00                	mov    (%eax),%al
  801172:	0f b6 c0             	movzbl %al,%eax
  801175:	29 c2                	sub    %eax,%edx
  801177:	89 d0                	mov    %edx,%eax
}
  801179:	5d                   	pop    %ebp
  80117a:	c3                   	ret    

0080117b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80117b:	55                   	push   %ebp
  80117c:	89 e5                	mov    %esp,%ebp
  80117e:	83 ec 04             	sub    $0x4,%esp
  801181:	8b 45 0c             	mov    0xc(%ebp),%eax
  801184:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801187:	eb 12                	jmp    80119b <strchr+0x20>
		if (*s == c)
  801189:	8b 45 08             	mov    0x8(%ebp),%eax
  80118c:	8a 00                	mov    (%eax),%al
  80118e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801191:	75 05                	jne    801198 <strchr+0x1d>
			return (char *) s;
  801193:	8b 45 08             	mov    0x8(%ebp),%eax
  801196:	eb 11                	jmp    8011a9 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801198:	ff 45 08             	incl   0x8(%ebp)
  80119b:	8b 45 08             	mov    0x8(%ebp),%eax
  80119e:	8a 00                	mov    (%eax),%al
  8011a0:	84 c0                	test   %al,%al
  8011a2:	75 e5                	jne    801189 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8011a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011a9:	c9                   	leave  
  8011aa:	c3                   	ret    

008011ab <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011ab:	55                   	push   %ebp
  8011ac:	89 e5                	mov    %esp,%ebp
  8011ae:	83 ec 04             	sub    $0x4,%esp
  8011b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011b7:	eb 0d                	jmp    8011c6 <strfind+0x1b>
		if (*s == c)
  8011b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bc:	8a 00                	mov    (%eax),%al
  8011be:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011c1:	74 0e                	je     8011d1 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8011c3:	ff 45 08             	incl   0x8(%ebp)
  8011c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c9:	8a 00                	mov    (%eax),%al
  8011cb:	84 c0                	test   %al,%al
  8011cd:	75 ea                	jne    8011b9 <strfind+0xe>
  8011cf:	eb 01                	jmp    8011d2 <strfind+0x27>
		if (*s == c)
			break;
  8011d1:	90                   	nop
	return (char *) s;
  8011d2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011d5:	c9                   	leave  
  8011d6:	c3                   	ret    

008011d7 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8011d7:	55                   	push   %ebp
  8011d8:	89 e5                	mov    %esp,%ebp
  8011da:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8011dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8011e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8011e9:	eb 0e                	jmp    8011f9 <memset+0x22>
		*p++ = c;
  8011eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ee:	8d 50 01             	lea    0x1(%eax),%edx
  8011f1:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011f7:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8011f9:	ff 4d f8             	decl   -0x8(%ebp)
  8011fc:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801200:	79 e9                	jns    8011eb <memset+0x14>
		*p++ = c;

	return v;
  801202:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801205:	c9                   	leave  
  801206:	c3                   	ret    

00801207 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801207:	55                   	push   %ebp
  801208:	89 e5                	mov    %esp,%ebp
  80120a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80120d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801210:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801213:	8b 45 08             	mov    0x8(%ebp),%eax
  801216:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801219:	eb 16                	jmp    801231 <memcpy+0x2a>
		*d++ = *s++;
  80121b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80121e:	8d 50 01             	lea    0x1(%eax),%edx
  801221:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801224:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801227:	8d 4a 01             	lea    0x1(%edx),%ecx
  80122a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80122d:	8a 12                	mov    (%edx),%dl
  80122f:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801231:	8b 45 10             	mov    0x10(%ebp),%eax
  801234:	8d 50 ff             	lea    -0x1(%eax),%edx
  801237:	89 55 10             	mov    %edx,0x10(%ebp)
  80123a:	85 c0                	test   %eax,%eax
  80123c:	75 dd                	jne    80121b <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80123e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801241:	c9                   	leave  
  801242:	c3                   	ret    

00801243 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801243:	55                   	push   %ebp
  801244:	89 e5                	mov    %esp,%ebp
  801246:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801249:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80124f:	8b 45 08             	mov    0x8(%ebp),%eax
  801252:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801255:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801258:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80125b:	73 50                	jae    8012ad <memmove+0x6a>
  80125d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801260:	8b 45 10             	mov    0x10(%ebp),%eax
  801263:	01 d0                	add    %edx,%eax
  801265:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801268:	76 43                	jbe    8012ad <memmove+0x6a>
		s += n;
  80126a:	8b 45 10             	mov    0x10(%ebp),%eax
  80126d:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801270:	8b 45 10             	mov    0x10(%ebp),%eax
  801273:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801276:	eb 10                	jmp    801288 <memmove+0x45>
			*--d = *--s;
  801278:	ff 4d f8             	decl   -0x8(%ebp)
  80127b:	ff 4d fc             	decl   -0x4(%ebp)
  80127e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801281:	8a 10                	mov    (%eax),%dl
  801283:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801286:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801288:	8b 45 10             	mov    0x10(%ebp),%eax
  80128b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80128e:	89 55 10             	mov    %edx,0x10(%ebp)
  801291:	85 c0                	test   %eax,%eax
  801293:	75 e3                	jne    801278 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801295:	eb 23                	jmp    8012ba <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801297:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80129a:	8d 50 01             	lea    0x1(%eax),%edx
  80129d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012a0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012a3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012a6:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8012a9:	8a 12                	mov    (%edx),%dl
  8012ab:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8012ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012b3:	89 55 10             	mov    %edx,0x10(%ebp)
  8012b6:	85 c0                	test   %eax,%eax
  8012b8:	75 dd                	jne    801297 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8012ba:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012bd:	c9                   	leave  
  8012be:	c3                   	ret    

008012bf <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8012bf:	55                   	push   %ebp
  8012c0:	89 e5                	mov    %esp,%ebp
  8012c2:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8012c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8012cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ce:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8012d1:	eb 2a                	jmp    8012fd <memcmp+0x3e>
		if (*s1 != *s2)
  8012d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012d6:	8a 10                	mov    (%eax),%dl
  8012d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012db:	8a 00                	mov    (%eax),%al
  8012dd:	38 c2                	cmp    %al,%dl
  8012df:	74 16                	je     8012f7 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8012e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012e4:	8a 00                	mov    (%eax),%al
  8012e6:	0f b6 d0             	movzbl %al,%edx
  8012e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012ec:	8a 00                	mov    (%eax),%al
  8012ee:	0f b6 c0             	movzbl %al,%eax
  8012f1:	29 c2                	sub    %eax,%edx
  8012f3:	89 d0                	mov    %edx,%eax
  8012f5:	eb 18                	jmp    80130f <memcmp+0x50>
		s1++, s2++;
  8012f7:	ff 45 fc             	incl   -0x4(%ebp)
  8012fa:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8012fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801300:	8d 50 ff             	lea    -0x1(%eax),%edx
  801303:	89 55 10             	mov    %edx,0x10(%ebp)
  801306:	85 c0                	test   %eax,%eax
  801308:	75 c9                	jne    8012d3 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80130a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80130f:	c9                   	leave  
  801310:	c3                   	ret    

00801311 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801311:	55                   	push   %ebp
  801312:	89 e5                	mov    %esp,%ebp
  801314:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801317:	8b 55 08             	mov    0x8(%ebp),%edx
  80131a:	8b 45 10             	mov    0x10(%ebp),%eax
  80131d:	01 d0                	add    %edx,%eax
  80131f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801322:	eb 15                	jmp    801339 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801324:	8b 45 08             	mov    0x8(%ebp),%eax
  801327:	8a 00                	mov    (%eax),%al
  801329:	0f b6 d0             	movzbl %al,%edx
  80132c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80132f:	0f b6 c0             	movzbl %al,%eax
  801332:	39 c2                	cmp    %eax,%edx
  801334:	74 0d                	je     801343 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801336:	ff 45 08             	incl   0x8(%ebp)
  801339:	8b 45 08             	mov    0x8(%ebp),%eax
  80133c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80133f:	72 e3                	jb     801324 <memfind+0x13>
  801341:	eb 01                	jmp    801344 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801343:	90                   	nop
	return (void *) s;
  801344:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801347:	c9                   	leave  
  801348:	c3                   	ret    

00801349 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801349:	55                   	push   %ebp
  80134a:	89 e5                	mov    %esp,%ebp
  80134c:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80134f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801356:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80135d:	eb 03                	jmp    801362 <strtol+0x19>
		s++;
  80135f:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801362:	8b 45 08             	mov    0x8(%ebp),%eax
  801365:	8a 00                	mov    (%eax),%al
  801367:	3c 20                	cmp    $0x20,%al
  801369:	74 f4                	je     80135f <strtol+0x16>
  80136b:	8b 45 08             	mov    0x8(%ebp),%eax
  80136e:	8a 00                	mov    (%eax),%al
  801370:	3c 09                	cmp    $0x9,%al
  801372:	74 eb                	je     80135f <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801374:	8b 45 08             	mov    0x8(%ebp),%eax
  801377:	8a 00                	mov    (%eax),%al
  801379:	3c 2b                	cmp    $0x2b,%al
  80137b:	75 05                	jne    801382 <strtol+0x39>
		s++;
  80137d:	ff 45 08             	incl   0x8(%ebp)
  801380:	eb 13                	jmp    801395 <strtol+0x4c>
	else if (*s == '-')
  801382:	8b 45 08             	mov    0x8(%ebp),%eax
  801385:	8a 00                	mov    (%eax),%al
  801387:	3c 2d                	cmp    $0x2d,%al
  801389:	75 0a                	jne    801395 <strtol+0x4c>
		s++, neg = 1;
  80138b:	ff 45 08             	incl   0x8(%ebp)
  80138e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801395:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801399:	74 06                	je     8013a1 <strtol+0x58>
  80139b:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80139f:	75 20                	jne    8013c1 <strtol+0x78>
  8013a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a4:	8a 00                	mov    (%eax),%al
  8013a6:	3c 30                	cmp    $0x30,%al
  8013a8:	75 17                	jne    8013c1 <strtol+0x78>
  8013aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ad:	40                   	inc    %eax
  8013ae:	8a 00                	mov    (%eax),%al
  8013b0:	3c 78                	cmp    $0x78,%al
  8013b2:	75 0d                	jne    8013c1 <strtol+0x78>
		s += 2, base = 16;
  8013b4:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8013b8:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8013bf:	eb 28                	jmp    8013e9 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8013c1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013c5:	75 15                	jne    8013dc <strtol+0x93>
  8013c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ca:	8a 00                	mov    (%eax),%al
  8013cc:	3c 30                	cmp    $0x30,%al
  8013ce:	75 0c                	jne    8013dc <strtol+0x93>
		s++, base = 8;
  8013d0:	ff 45 08             	incl   0x8(%ebp)
  8013d3:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8013da:	eb 0d                	jmp    8013e9 <strtol+0xa0>
	else if (base == 0)
  8013dc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013e0:	75 07                	jne    8013e9 <strtol+0xa0>
		base = 10;
  8013e2:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8013e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ec:	8a 00                	mov    (%eax),%al
  8013ee:	3c 2f                	cmp    $0x2f,%al
  8013f0:	7e 19                	jle    80140b <strtol+0xc2>
  8013f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f5:	8a 00                	mov    (%eax),%al
  8013f7:	3c 39                	cmp    $0x39,%al
  8013f9:	7f 10                	jg     80140b <strtol+0xc2>
			dig = *s - '0';
  8013fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fe:	8a 00                	mov    (%eax),%al
  801400:	0f be c0             	movsbl %al,%eax
  801403:	83 e8 30             	sub    $0x30,%eax
  801406:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801409:	eb 42                	jmp    80144d <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80140b:	8b 45 08             	mov    0x8(%ebp),%eax
  80140e:	8a 00                	mov    (%eax),%al
  801410:	3c 60                	cmp    $0x60,%al
  801412:	7e 19                	jle    80142d <strtol+0xe4>
  801414:	8b 45 08             	mov    0x8(%ebp),%eax
  801417:	8a 00                	mov    (%eax),%al
  801419:	3c 7a                	cmp    $0x7a,%al
  80141b:	7f 10                	jg     80142d <strtol+0xe4>
			dig = *s - 'a' + 10;
  80141d:	8b 45 08             	mov    0x8(%ebp),%eax
  801420:	8a 00                	mov    (%eax),%al
  801422:	0f be c0             	movsbl %al,%eax
  801425:	83 e8 57             	sub    $0x57,%eax
  801428:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80142b:	eb 20                	jmp    80144d <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80142d:	8b 45 08             	mov    0x8(%ebp),%eax
  801430:	8a 00                	mov    (%eax),%al
  801432:	3c 40                	cmp    $0x40,%al
  801434:	7e 39                	jle    80146f <strtol+0x126>
  801436:	8b 45 08             	mov    0x8(%ebp),%eax
  801439:	8a 00                	mov    (%eax),%al
  80143b:	3c 5a                	cmp    $0x5a,%al
  80143d:	7f 30                	jg     80146f <strtol+0x126>
			dig = *s - 'A' + 10;
  80143f:	8b 45 08             	mov    0x8(%ebp),%eax
  801442:	8a 00                	mov    (%eax),%al
  801444:	0f be c0             	movsbl %al,%eax
  801447:	83 e8 37             	sub    $0x37,%eax
  80144a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80144d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801450:	3b 45 10             	cmp    0x10(%ebp),%eax
  801453:	7d 19                	jge    80146e <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801455:	ff 45 08             	incl   0x8(%ebp)
  801458:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80145b:	0f af 45 10          	imul   0x10(%ebp),%eax
  80145f:	89 c2                	mov    %eax,%edx
  801461:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801464:	01 d0                	add    %edx,%eax
  801466:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801469:	e9 7b ff ff ff       	jmp    8013e9 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80146e:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80146f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801473:	74 08                	je     80147d <strtol+0x134>
		*endptr = (char *) s;
  801475:	8b 45 0c             	mov    0xc(%ebp),%eax
  801478:	8b 55 08             	mov    0x8(%ebp),%edx
  80147b:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80147d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801481:	74 07                	je     80148a <strtol+0x141>
  801483:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801486:	f7 d8                	neg    %eax
  801488:	eb 03                	jmp    80148d <strtol+0x144>
  80148a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80148d:	c9                   	leave  
  80148e:	c3                   	ret    

0080148f <ltostr>:

void
ltostr(long value, char *str)
{
  80148f:	55                   	push   %ebp
  801490:	89 e5                	mov    %esp,%ebp
  801492:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801495:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80149c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8014a3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014a7:	79 13                	jns    8014bc <ltostr+0x2d>
	{
		neg = 1;
  8014a9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8014b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014b3:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8014b6:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8014b9:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8014bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bf:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8014c4:	99                   	cltd   
  8014c5:	f7 f9                	idiv   %ecx
  8014c7:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8014ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014cd:	8d 50 01             	lea    0x1(%eax),%edx
  8014d0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014d3:	89 c2                	mov    %eax,%edx
  8014d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d8:	01 d0                	add    %edx,%eax
  8014da:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8014dd:	83 c2 30             	add    $0x30,%edx
  8014e0:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8014e2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014e5:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8014ea:	f7 e9                	imul   %ecx
  8014ec:	c1 fa 02             	sar    $0x2,%edx
  8014ef:	89 c8                	mov    %ecx,%eax
  8014f1:	c1 f8 1f             	sar    $0x1f,%eax
  8014f4:	29 c2                	sub    %eax,%edx
  8014f6:	89 d0                	mov    %edx,%eax
  8014f8:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8014fb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014fe:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801503:	f7 e9                	imul   %ecx
  801505:	c1 fa 02             	sar    $0x2,%edx
  801508:	89 c8                	mov    %ecx,%eax
  80150a:	c1 f8 1f             	sar    $0x1f,%eax
  80150d:	29 c2                	sub    %eax,%edx
  80150f:	89 d0                	mov    %edx,%eax
  801511:	c1 e0 02             	shl    $0x2,%eax
  801514:	01 d0                	add    %edx,%eax
  801516:	01 c0                	add    %eax,%eax
  801518:	29 c1                	sub    %eax,%ecx
  80151a:	89 ca                	mov    %ecx,%edx
  80151c:	85 d2                	test   %edx,%edx
  80151e:	75 9c                	jne    8014bc <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801520:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801527:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80152a:	48                   	dec    %eax
  80152b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80152e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801532:	74 3d                	je     801571 <ltostr+0xe2>
		start = 1 ;
  801534:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80153b:	eb 34                	jmp    801571 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80153d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801540:	8b 45 0c             	mov    0xc(%ebp),%eax
  801543:	01 d0                	add    %edx,%eax
  801545:	8a 00                	mov    (%eax),%al
  801547:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80154a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80154d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801550:	01 c2                	add    %eax,%edx
  801552:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801555:	8b 45 0c             	mov    0xc(%ebp),%eax
  801558:	01 c8                	add    %ecx,%eax
  80155a:	8a 00                	mov    (%eax),%al
  80155c:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80155e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801561:	8b 45 0c             	mov    0xc(%ebp),%eax
  801564:	01 c2                	add    %eax,%edx
  801566:	8a 45 eb             	mov    -0x15(%ebp),%al
  801569:	88 02                	mov    %al,(%edx)
		start++ ;
  80156b:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80156e:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801571:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801574:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801577:	7c c4                	jl     80153d <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801579:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80157c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80157f:	01 d0                	add    %edx,%eax
  801581:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801584:	90                   	nop
  801585:	c9                   	leave  
  801586:	c3                   	ret    

00801587 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801587:	55                   	push   %ebp
  801588:	89 e5                	mov    %esp,%ebp
  80158a:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80158d:	ff 75 08             	pushl  0x8(%ebp)
  801590:	e8 54 fa ff ff       	call   800fe9 <strlen>
  801595:	83 c4 04             	add    $0x4,%esp
  801598:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80159b:	ff 75 0c             	pushl  0xc(%ebp)
  80159e:	e8 46 fa ff ff       	call   800fe9 <strlen>
  8015a3:	83 c4 04             	add    $0x4,%esp
  8015a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8015a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8015b0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015b7:	eb 17                	jmp    8015d0 <strcconcat+0x49>
		final[s] = str1[s] ;
  8015b9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8015bf:	01 c2                	add    %eax,%edx
  8015c1:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c7:	01 c8                	add    %ecx,%eax
  8015c9:	8a 00                	mov    (%eax),%al
  8015cb:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8015cd:	ff 45 fc             	incl   -0x4(%ebp)
  8015d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015d3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8015d6:	7c e1                	jl     8015b9 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8015d8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8015df:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8015e6:	eb 1f                	jmp    801607 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8015e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015eb:	8d 50 01             	lea    0x1(%eax),%edx
  8015ee:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8015f1:	89 c2                	mov    %eax,%edx
  8015f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8015f6:	01 c2                	add    %eax,%edx
  8015f8:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8015fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015fe:	01 c8                	add    %ecx,%eax
  801600:	8a 00                	mov    (%eax),%al
  801602:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801604:	ff 45 f8             	incl   -0x8(%ebp)
  801607:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80160a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80160d:	7c d9                	jl     8015e8 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80160f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801612:	8b 45 10             	mov    0x10(%ebp),%eax
  801615:	01 d0                	add    %edx,%eax
  801617:	c6 00 00             	movb   $0x0,(%eax)
}
  80161a:	90                   	nop
  80161b:	c9                   	leave  
  80161c:	c3                   	ret    

0080161d <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80161d:	55                   	push   %ebp
  80161e:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801620:	8b 45 14             	mov    0x14(%ebp),%eax
  801623:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801629:	8b 45 14             	mov    0x14(%ebp),%eax
  80162c:	8b 00                	mov    (%eax),%eax
  80162e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801635:	8b 45 10             	mov    0x10(%ebp),%eax
  801638:	01 d0                	add    %edx,%eax
  80163a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801640:	eb 0c                	jmp    80164e <strsplit+0x31>
			*string++ = 0;
  801642:	8b 45 08             	mov    0x8(%ebp),%eax
  801645:	8d 50 01             	lea    0x1(%eax),%edx
  801648:	89 55 08             	mov    %edx,0x8(%ebp)
  80164b:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80164e:	8b 45 08             	mov    0x8(%ebp),%eax
  801651:	8a 00                	mov    (%eax),%al
  801653:	84 c0                	test   %al,%al
  801655:	74 18                	je     80166f <strsplit+0x52>
  801657:	8b 45 08             	mov    0x8(%ebp),%eax
  80165a:	8a 00                	mov    (%eax),%al
  80165c:	0f be c0             	movsbl %al,%eax
  80165f:	50                   	push   %eax
  801660:	ff 75 0c             	pushl  0xc(%ebp)
  801663:	e8 13 fb ff ff       	call   80117b <strchr>
  801668:	83 c4 08             	add    $0x8,%esp
  80166b:	85 c0                	test   %eax,%eax
  80166d:	75 d3                	jne    801642 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80166f:	8b 45 08             	mov    0x8(%ebp),%eax
  801672:	8a 00                	mov    (%eax),%al
  801674:	84 c0                	test   %al,%al
  801676:	74 5a                	je     8016d2 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801678:	8b 45 14             	mov    0x14(%ebp),%eax
  80167b:	8b 00                	mov    (%eax),%eax
  80167d:	83 f8 0f             	cmp    $0xf,%eax
  801680:	75 07                	jne    801689 <strsplit+0x6c>
		{
			return 0;
  801682:	b8 00 00 00 00       	mov    $0x0,%eax
  801687:	eb 66                	jmp    8016ef <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801689:	8b 45 14             	mov    0x14(%ebp),%eax
  80168c:	8b 00                	mov    (%eax),%eax
  80168e:	8d 48 01             	lea    0x1(%eax),%ecx
  801691:	8b 55 14             	mov    0x14(%ebp),%edx
  801694:	89 0a                	mov    %ecx,(%edx)
  801696:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80169d:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a0:	01 c2                	add    %eax,%edx
  8016a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a5:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016a7:	eb 03                	jmp    8016ac <strsplit+0x8f>
			string++;
  8016a9:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8016af:	8a 00                	mov    (%eax),%al
  8016b1:	84 c0                	test   %al,%al
  8016b3:	74 8b                	je     801640 <strsplit+0x23>
  8016b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b8:	8a 00                	mov    (%eax),%al
  8016ba:	0f be c0             	movsbl %al,%eax
  8016bd:	50                   	push   %eax
  8016be:	ff 75 0c             	pushl  0xc(%ebp)
  8016c1:	e8 b5 fa ff ff       	call   80117b <strchr>
  8016c6:	83 c4 08             	add    $0x8,%esp
  8016c9:	85 c0                	test   %eax,%eax
  8016cb:	74 dc                	je     8016a9 <strsplit+0x8c>
			string++;
	}
  8016cd:	e9 6e ff ff ff       	jmp    801640 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8016d2:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8016d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8016d6:	8b 00                	mov    (%eax),%eax
  8016d8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016df:	8b 45 10             	mov    0x10(%ebp),%eax
  8016e2:	01 d0                	add    %edx,%eax
  8016e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8016ea:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8016ef:	c9                   	leave  
  8016f0:	c3                   	ret    

008016f1 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8016f1:	55                   	push   %ebp
  8016f2:	89 e5                	mov    %esp,%ebp
  8016f4:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8016f7:	a1 04 50 80 00       	mov    0x805004,%eax
  8016fc:	85 c0                	test   %eax,%eax
  8016fe:	74 1f                	je     80171f <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801700:	e8 1d 00 00 00       	call   801722 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801705:	83 ec 0c             	sub    $0xc,%esp
  801708:	68 f0 3f 80 00       	push   $0x803ff0
  80170d:	e8 55 f2 ff ff       	call   800967 <cprintf>
  801712:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801715:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  80171c:	00 00 00 
	}
}
  80171f:	90                   	nop
  801720:	c9                   	leave  
  801721:	c3                   	ret    

00801722 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801722:	55                   	push   %ebp
  801723:	89 e5                	mov    %esp,%ebp
  801725:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  801728:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  80172f:	00 00 00 
  801732:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801739:	00 00 00 
  80173c:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801743:	00 00 00 
		LIST_INIT(&AllocMemBlocksList);
  801746:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  80174d:	00 00 00 
  801750:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801757:	00 00 00 
  80175a:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801761:	00 00 00 

		MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES ;
  801764:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  80176b:	00 02 00 
		MemBlockNodes =(struct MemBlock*)USER_DYN_BLKS_ARRAY ;
  80176e:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801775:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801778:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80177d:	2d 00 10 00 00       	sub    $0x1000,%eax
  801782:	a3 50 50 80 00       	mov    %eax,0x805050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock),PAGE_SIZE),PERM_USER|PERM_WRITEABLE);
  801787:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80178e:	a1 20 51 80 00       	mov    0x805120,%eax
  801793:	c1 e0 04             	shl    $0x4,%eax
  801796:	89 c2                	mov    %eax,%edx
  801798:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80179b:	01 d0                	add    %edx,%eax
  80179d:	48                   	dec    %eax
  80179e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8017a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8017a9:	f7 75 f0             	divl   -0x10(%ebp)
  8017ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017af:	29 d0                	sub    %edx,%eax
  8017b1:	89 c2                	mov    %eax,%edx
  8017b3:	c7 45 e8 00 00 e0 7f 	movl   $0x7fe00000,-0x18(%ebp)
  8017ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017bd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017c2:	2d 00 10 00 00       	sub    $0x1000,%eax
  8017c7:	83 ec 04             	sub    $0x4,%esp
  8017ca:	6a 06                	push   $0x6
  8017cc:	52                   	push   %edx
  8017cd:	50                   	push   %eax
  8017ce:	e8 71 05 00 00       	call   801d44 <sys_allocate_chunk>
  8017d3:	83 c4 10             	add    $0x10,%esp
		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8017d6:	a1 20 51 80 00       	mov    0x805120,%eax
  8017db:	83 ec 0c             	sub    $0xc,%esp
  8017de:	50                   	push   %eax
  8017df:	e8 e6 0b 00 00       	call   8023ca <initialize_MemBlocksList>
  8017e4:	83 c4 10             	add    $0x10,%esp

		struct MemBlock  *block_node;
		block_node = AvailableMemBlocksList.lh_first;
  8017e7:	a1 48 51 80 00       	mov    0x805148,%eax
  8017ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&(AvailableMemBlocksList),block_node);
  8017ef:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8017f3:	75 14                	jne    801809 <initialize_dyn_block_system+0xe7>
  8017f5:	83 ec 04             	sub    $0x4,%esp
  8017f8:	68 15 40 80 00       	push   $0x804015
  8017fd:	6a 2b                	push   $0x2b
  8017ff:	68 33 40 80 00       	push   $0x804033
  801804:	e8 aa ee ff ff       	call   8006b3 <_panic>
  801809:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80180c:	8b 00                	mov    (%eax),%eax
  80180e:	85 c0                	test   %eax,%eax
  801810:	74 10                	je     801822 <initialize_dyn_block_system+0x100>
  801812:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801815:	8b 00                	mov    (%eax),%eax
  801817:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80181a:	8b 52 04             	mov    0x4(%edx),%edx
  80181d:	89 50 04             	mov    %edx,0x4(%eax)
  801820:	eb 0b                	jmp    80182d <initialize_dyn_block_system+0x10b>
  801822:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801825:	8b 40 04             	mov    0x4(%eax),%eax
  801828:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80182d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801830:	8b 40 04             	mov    0x4(%eax),%eax
  801833:	85 c0                	test   %eax,%eax
  801835:	74 0f                	je     801846 <initialize_dyn_block_system+0x124>
  801837:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80183a:	8b 40 04             	mov    0x4(%eax),%eax
  80183d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801840:	8b 12                	mov    (%edx),%edx
  801842:	89 10                	mov    %edx,(%eax)
  801844:	eb 0a                	jmp    801850 <initialize_dyn_block_system+0x12e>
  801846:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801849:	8b 00                	mov    (%eax),%eax
  80184b:	a3 48 51 80 00       	mov    %eax,0x805148
  801850:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801853:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801859:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80185c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801863:	a1 54 51 80 00       	mov    0x805154,%eax
  801868:	48                   	dec    %eax
  801869:	a3 54 51 80 00       	mov    %eax,0x805154
		block_node->sva = USER_HEAP_START ;
  80186e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801871:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
		block_node->size = ((USER_HEAP_MAX - USER_HEAP_START));
  801878:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80187b:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		insert_sorted_with_merge_freeList(block_node);
  801882:	83 ec 0c             	sub    $0xc,%esp
  801885:	ff 75 e4             	pushl  -0x1c(%ebp)
  801888:	e8 d2 13 00 00       	call   802c5f <insert_sorted_with_merge_freeList>
  80188d:	83 c4 10             	add    $0x10,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801890:	90                   	nop
  801891:	c9                   	leave  
  801892:	c3                   	ret    

00801893 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801893:	55                   	push   %ebp
  801894:	89 e5                	mov    %esp,%ebp
  801896:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801899:	e8 53 fe ff ff       	call   8016f1 <InitializeUHeap>
	if (size == 0) return NULL ;
  80189e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018a2:	75 07                	jne    8018ab <malloc+0x18>
  8018a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8018a9:	eb 61                	jmp    80190c <malloc+0x79>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	size= ROUNDUP(size,PAGE_SIZE);
  8018ab:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8018b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8018b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018b8:	01 d0                	add    %edx,%eax
  8018ba:	48                   	dec    %eax
  8018bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8018be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018c1:	ba 00 00 00 00       	mov    $0x0,%edx
  8018c6:	f7 75 f4             	divl   -0xc(%ebp)
  8018c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018cc:	29 d0                	sub    %edx,%eax
  8018ce:	89 45 08             	mov    %eax,0x8(%ebp)
	    			if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8018d1:	e8 3c 08 00 00       	call   802112 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8018d6:	85 c0                	test   %eax,%eax
  8018d8:	74 2d                	je     801907 <malloc+0x74>
	    			{
	    				struct MemBlock * ff_block = alloc_block_FF(size);
  8018da:	83 ec 0c             	sub    $0xc,%esp
  8018dd:	ff 75 08             	pushl  0x8(%ebp)
  8018e0:	e8 3e 0f 00 00       	call   802823 <alloc_block_FF>
  8018e5:	83 c4 10             	add    $0x10,%esp
  8018e8:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    				if(ff_block!=NULL)
  8018eb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8018ef:	74 16                	je     801907 <malloc+0x74>
	    				{

	    					insert_sorted_allocList(ff_block);
  8018f1:	83 ec 0c             	sub    $0xc,%esp
  8018f4:	ff 75 ec             	pushl  -0x14(%ebp)
  8018f7:	e8 48 0c 00 00       	call   802544 <insert_sorted_allocList>
  8018fc:	83 c4 10             	add    $0x10,%esp
	    					return (void*) ff_block->sva ;
  8018ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801902:	8b 40 08             	mov    0x8(%eax),%eax
  801905:	eb 05                	jmp    80190c <malloc+0x79>

	    				}
	}
	    			return (void*) NULL ;
  801907:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  80190c:	c9                   	leave  
  80190d:	c3                   	ret    

0080190e <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80190e:	55                   	push   %ebp
  80190f:	89 e5                	mov    %esp,%ebp
  801911:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock *elementForEach;
		virtual_address = ROUNDDOWN(virtual_address, PAGE_SIZE);
  801914:	8b 45 08             	mov    0x8(%ebp),%eax
  801917:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80191a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80191d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801922:	89 45 08             	mov    %eax,0x8(%ebp)
	//	if (is_mallocPages[indexindex((uint32) virtual_address)] == 1) {
		elementForEach = find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801925:	8b 45 08             	mov    0x8(%ebp),%eax
  801928:	83 ec 08             	sub    $0x8,%esp
  80192b:	50                   	push   %eax
  80192c:	68 40 50 80 00       	push   $0x805040
  801931:	e8 71 0b 00 00       	call   8024a7 <find_block>
  801936:	83 c4 10             	add    $0x10,%esp
  801939:	89 45 f0             	mov    %eax,-0x10(%ebp)
		sys_free_user_mem((uint32) virtual_address, elementForEach->size);
  80193c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80193f:	8b 50 0c             	mov    0xc(%eax),%edx
  801942:	8b 45 08             	mov    0x8(%ebp),%eax
  801945:	83 ec 08             	sub    $0x8,%esp
  801948:	52                   	push   %edx
  801949:	50                   	push   %eax
  80194a:	e8 bd 03 00 00       	call   801d0c <sys_free_user_mem>
  80194f:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,elementForEach);
  801952:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801956:	75 14                	jne    80196c <free+0x5e>
  801958:	83 ec 04             	sub    $0x4,%esp
  80195b:	68 15 40 80 00       	push   $0x804015
  801960:	6a 71                	push   $0x71
  801962:	68 33 40 80 00       	push   $0x804033
  801967:	e8 47 ed ff ff       	call   8006b3 <_panic>
  80196c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80196f:	8b 00                	mov    (%eax),%eax
  801971:	85 c0                	test   %eax,%eax
  801973:	74 10                	je     801985 <free+0x77>
  801975:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801978:	8b 00                	mov    (%eax),%eax
  80197a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80197d:	8b 52 04             	mov    0x4(%edx),%edx
  801980:	89 50 04             	mov    %edx,0x4(%eax)
  801983:	eb 0b                	jmp    801990 <free+0x82>
  801985:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801988:	8b 40 04             	mov    0x4(%eax),%eax
  80198b:	a3 44 50 80 00       	mov    %eax,0x805044
  801990:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801993:	8b 40 04             	mov    0x4(%eax),%eax
  801996:	85 c0                	test   %eax,%eax
  801998:	74 0f                	je     8019a9 <free+0x9b>
  80199a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80199d:	8b 40 04             	mov    0x4(%eax),%eax
  8019a0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019a3:	8b 12                	mov    (%edx),%edx
  8019a5:	89 10                	mov    %edx,(%eax)
  8019a7:	eb 0a                	jmp    8019b3 <free+0xa5>
  8019a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019ac:	8b 00                	mov    (%eax),%eax
  8019ae:	a3 40 50 80 00       	mov    %eax,0x805040
  8019b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019b6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8019bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019bf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8019c6:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8019cb:	48                   	dec    %eax
  8019cc:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(elementForEach);
  8019d1:	83 ec 0c             	sub    $0xc,%esp
  8019d4:	ff 75 f0             	pushl  -0x10(%ebp)
  8019d7:	e8 83 12 00 00       	call   802c5f <insert_sorted_with_merge_freeList>
  8019dc:	83 c4 10             	add    $0x10,%esp
	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  8019df:	90                   	nop
  8019e0:	c9                   	leave  
  8019e1:	c3                   	ret    

008019e2 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8019e2:	55                   	push   %ebp
  8019e3:	89 e5                	mov    %esp,%ebp
  8019e5:	83 ec 28             	sub    $0x28,%esp
  8019e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8019eb:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8019ee:	e8 fe fc ff ff       	call   8016f1 <InitializeUHeap>
	if (size == 0) return NULL ;
  8019f3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8019f7:	75 0a                	jne    801a03 <smalloc+0x21>
  8019f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8019fe:	e9 86 00 00 00       	jmp    801a89 <smalloc+0xa7>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code

	size=ROUNDUP(size,PAGE_SIZE);
  801a03:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801a0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a10:	01 d0                	add    %edx,%eax
  801a12:	48                   	dec    %eax
  801a13:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a19:	ba 00 00 00 00       	mov    $0x0,%edx
  801a1e:	f7 75 f4             	divl   -0xc(%ebp)
  801a21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a24:	29 d0                	sub    %edx,%eax
  801a26:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801a29:	e8 e4 06 00 00       	call   802112 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801a2e:	85 c0                	test   %eax,%eax
  801a30:	74 52                	je     801a84 <smalloc+0xa2>
		{
		struct MemBlock * ff_block ;
		ff_block = alloc_block_FF(size);
  801a32:	83 ec 0c             	sub    $0xc,%esp
  801a35:	ff 75 0c             	pushl  0xc(%ebp)
  801a38:	e8 e6 0d 00 00       	call   802823 <alloc_block_FF>
  801a3d:	83 c4 10             	add    $0x10,%esp
  801a40:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(ff_block==NULL)
  801a43:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801a47:	75 07                	jne    801a50 <smalloc+0x6e>
			return NULL ;
  801a49:	b8 00 00 00 00       	mov    $0x0,%eax
  801a4e:	eb 39                	jmp    801a89 <smalloc+0xa7>

		int obj_id =sys_createSharedObject(sharedVarName,size,isWritable,(void*)ff_block->sva);
  801a50:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a53:	8b 40 08             	mov    0x8(%eax),%eax
  801a56:	89 c2                	mov    %eax,%edx
  801a58:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801a5c:	52                   	push   %edx
  801a5d:	50                   	push   %eax
  801a5e:	ff 75 0c             	pushl  0xc(%ebp)
  801a61:	ff 75 08             	pushl  0x8(%ebp)
  801a64:	e8 2e 04 00 00       	call   801e97 <sys_createSharedObject>
  801a69:	83 c4 10             	add    $0x10,%esp
  801a6c:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(obj_id < 0)
  801a6f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801a73:	79 07                	jns    801a7c <smalloc+0x9a>
			return (void*)NULL ;
  801a75:	b8 00 00 00 00       	mov    $0x0,%eax
  801a7a:	eb 0d                	jmp    801a89 <smalloc+0xa7>
		else
		    return (void*)ff_block->sva ;
  801a7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a7f:	8b 40 08             	mov    0x8(%eax),%eax
  801a82:	eb 05                	jmp    801a89 <smalloc+0xa7>
		}
		return (void*)NULL ;
  801a84:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801a89:	c9                   	leave  
  801a8a:	c3                   	ret    

00801a8b <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801a8b:	55                   	push   %ebp
  801a8c:	89 e5                	mov    %esp,%ebp
  801a8e:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a91:	e8 5b fc ff ff       	call   8016f1 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801a96:	83 ec 08             	sub    $0x8,%esp
  801a99:	ff 75 0c             	pushl  0xc(%ebp)
  801a9c:	ff 75 08             	pushl  0x8(%ebp)
  801a9f:	e8 1d 04 00 00       	call   801ec1 <sys_getSizeOfSharedObject>
  801aa4:	83 c4 10             	add    $0x10,%esp
  801aa7:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(size == 0)
  801aaa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801aae:	75 0a                	jne    801aba <sget+0x2f>
			return NULL ;
  801ab0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ab5:	e9 83 00 00 00       	jmp    801b3d <sget+0xb2>
		size=ROUNDUP(size,PAGE_SIZE);
  801aba:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801ac1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ac4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ac7:	01 d0                	add    %edx,%eax
  801ac9:	48                   	dec    %eax
  801aca:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801acd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ad0:	ba 00 00 00 00       	mov    $0x0,%edx
  801ad5:	f7 75 f0             	divl   -0x10(%ebp)
  801ad8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801adb:	29 d0                	sub    %edx,%eax
  801add:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801ae0:	e8 2d 06 00 00       	call   802112 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801ae5:	85 c0                	test   %eax,%eax
  801ae7:	74 4f                	je     801b38 <sget+0xad>
		{
			struct MemBlock * ff_block ;
				ff_block = alloc_block_FF(size);
  801ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aec:	83 ec 0c             	sub    $0xc,%esp
  801aef:	50                   	push   %eax
  801af0:	e8 2e 0d 00 00       	call   802823 <alloc_block_FF>
  801af5:	83 c4 10             	add    $0x10,%esp
  801af8:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ff_block==NULL)
  801afb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801aff:	75 07                	jne    801b08 <sget+0x7d>
					return (void*)NULL ;
  801b01:	b8 00 00 00 00       	mov    $0x0,%eax
  801b06:	eb 35                	jmp    801b3d <sget+0xb2>

		int obj_id =sys_getSharedObject((int)ownerEnvID,sharedVarName,(void*)ff_block->sva);
  801b08:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b0b:	8b 40 08             	mov    0x8(%eax),%eax
  801b0e:	83 ec 04             	sub    $0x4,%esp
  801b11:	50                   	push   %eax
  801b12:	ff 75 0c             	pushl  0xc(%ebp)
  801b15:	ff 75 08             	pushl  0x8(%ebp)
  801b18:	e8 c1 03 00 00       	call   801ede <sys_getSharedObject>
  801b1d:	83 c4 10             	add    $0x10,%esp
  801b20:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if(obj_id<0)
  801b23:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801b27:	79 07                	jns    801b30 <sget+0xa5>
				return (void*)NULL ;
  801b29:	b8 00 00 00 00       	mov    $0x0,%eax
  801b2e:	eb 0d                	jmp    801b3d <sget+0xb2>
			else
				return (void*)ff_block->sva ;
  801b30:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b33:	8b 40 08             	mov    0x8(%eax),%eax
  801b36:	eb 05                	jmp    801b3d <sget+0xb2>


		}
	return (void*)NULL ;
  801b38:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801b3d:	c9                   	leave  
  801b3e:	c3                   	ret    

00801b3f <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801b3f:	55                   	push   %ebp
  801b40:	89 e5                	mov    %esp,%ebp
  801b42:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b45:	e8 a7 fb ff ff       	call   8016f1 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801b4a:	83 ec 04             	sub    $0x4,%esp
  801b4d:	68 40 40 80 00       	push   $0x804040
  801b52:	68 f9 00 00 00       	push   $0xf9
  801b57:	68 33 40 80 00       	push   $0x804033
  801b5c:	e8 52 eb ff ff       	call   8006b3 <_panic>

00801b61 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801b61:	55                   	push   %ebp
  801b62:	89 e5                	mov    %esp,%ebp
  801b64:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801b67:	83 ec 04             	sub    $0x4,%esp
  801b6a:	68 68 40 80 00       	push   $0x804068
  801b6f:	68 0d 01 00 00       	push   $0x10d
  801b74:	68 33 40 80 00       	push   $0x804033
  801b79:	e8 35 eb ff ff       	call   8006b3 <_panic>

00801b7e <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801b7e:	55                   	push   %ebp
  801b7f:	89 e5                	mov    %esp,%ebp
  801b81:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b84:	83 ec 04             	sub    $0x4,%esp
  801b87:	68 8c 40 80 00       	push   $0x80408c
  801b8c:	68 18 01 00 00       	push   $0x118
  801b91:	68 33 40 80 00       	push   $0x804033
  801b96:	e8 18 eb ff ff       	call   8006b3 <_panic>

00801b9b <shrink>:

}
void shrink(uint32 newSize)
{
  801b9b:	55                   	push   %ebp
  801b9c:	89 e5                	mov    %esp,%ebp
  801b9e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ba1:	83 ec 04             	sub    $0x4,%esp
  801ba4:	68 8c 40 80 00       	push   $0x80408c
  801ba9:	68 1d 01 00 00       	push   $0x11d
  801bae:	68 33 40 80 00       	push   $0x804033
  801bb3:	e8 fb ea ff ff       	call   8006b3 <_panic>

00801bb8 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801bb8:	55                   	push   %ebp
  801bb9:	89 e5                	mov    %esp,%ebp
  801bbb:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801bbe:	83 ec 04             	sub    $0x4,%esp
  801bc1:	68 8c 40 80 00       	push   $0x80408c
  801bc6:	68 22 01 00 00       	push   $0x122
  801bcb:	68 33 40 80 00       	push   $0x804033
  801bd0:	e8 de ea ff ff       	call   8006b3 <_panic>

00801bd5 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801bd5:	55                   	push   %ebp
  801bd6:	89 e5                	mov    %esp,%ebp
  801bd8:	57                   	push   %edi
  801bd9:	56                   	push   %esi
  801bda:	53                   	push   %ebx
  801bdb:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801bde:	8b 45 08             	mov    0x8(%ebp),%eax
  801be1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801be4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801be7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801bea:	8b 7d 18             	mov    0x18(%ebp),%edi
  801bed:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801bf0:	cd 30                	int    $0x30
  801bf2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801bf5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801bf8:	83 c4 10             	add    $0x10,%esp
  801bfb:	5b                   	pop    %ebx
  801bfc:	5e                   	pop    %esi
  801bfd:	5f                   	pop    %edi
  801bfe:	5d                   	pop    %ebp
  801bff:	c3                   	ret    

00801c00 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801c00:	55                   	push   %ebp
  801c01:	89 e5                	mov    %esp,%ebp
  801c03:	83 ec 04             	sub    $0x4,%esp
  801c06:	8b 45 10             	mov    0x10(%ebp),%eax
  801c09:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801c0c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c10:	8b 45 08             	mov    0x8(%ebp),%eax
  801c13:	6a 00                	push   $0x0
  801c15:	6a 00                	push   $0x0
  801c17:	52                   	push   %edx
  801c18:	ff 75 0c             	pushl  0xc(%ebp)
  801c1b:	50                   	push   %eax
  801c1c:	6a 00                	push   $0x0
  801c1e:	e8 b2 ff ff ff       	call   801bd5 <syscall>
  801c23:	83 c4 18             	add    $0x18,%esp
}
  801c26:	90                   	nop
  801c27:	c9                   	leave  
  801c28:	c3                   	ret    

00801c29 <sys_cgetc>:

int
sys_cgetc(void)
{
  801c29:	55                   	push   %ebp
  801c2a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	6a 01                	push   $0x1
  801c38:	e8 98 ff ff ff       	call   801bd5 <syscall>
  801c3d:	83 c4 18             	add    $0x18,%esp
}
  801c40:	c9                   	leave  
  801c41:	c3                   	ret    

00801c42 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801c42:	55                   	push   %ebp
  801c43:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801c45:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c48:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	52                   	push   %edx
  801c52:	50                   	push   %eax
  801c53:	6a 05                	push   $0x5
  801c55:	e8 7b ff ff ff       	call   801bd5 <syscall>
  801c5a:	83 c4 18             	add    $0x18,%esp
}
  801c5d:	c9                   	leave  
  801c5e:	c3                   	ret    

00801c5f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801c5f:	55                   	push   %ebp
  801c60:	89 e5                	mov    %esp,%ebp
  801c62:	56                   	push   %esi
  801c63:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801c64:	8b 75 18             	mov    0x18(%ebp),%esi
  801c67:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c6a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c70:	8b 45 08             	mov    0x8(%ebp),%eax
  801c73:	56                   	push   %esi
  801c74:	53                   	push   %ebx
  801c75:	51                   	push   %ecx
  801c76:	52                   	push   %edx
  801c77:	50                   	push   %eax
  801c78:	6a 06                	push   $0x6
  801c7a:	e8 56 ff ff ff       	call   801bd5 <syscall>
  801c7f:	83 c4 18             	add    $0x18,%esp
}
  801c82:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c85:	5b                   	pop    %ebx
  801c86:	5e                   	pop    %esi
  801c87:	5d                   	pop    %ebp
  801c88:	c3                   	ret    

00801c89 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801c89:	55                   	push   %ebp
  801c8a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801c8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c92:	6a 00                	push   $0x0
  801c94:	6a 00                	push   $0x0
  801c96:	6a 00                	push   $0x0
  801c98:	52                   	push   %edx
  801c99:	50                   	push   %eax
  801c9a:	6a 07                	push   $0x7
  801c9c:	e8 34 ff ff ff       	call   801bd5 <syscall>
  801ca1:	83 c4 18             	add    $0x18,%esp
}
  801ca4:	c9                   	leave  
  801ca5:	c3                   	ret    

00801ca6 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801ca6:	55                   	push   %ebp
  801ca7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 00                	push   $0x0
  801cad:	6a 00                	push   $0x0
  801caf:	ff 75 0c             	pushl  0xc(%ebp)
  801cb2:	ff 75 08             	pushl  0x8(%ebp)
  801cb5:	6a 08                	push   $0x8
  801cb7:	e8 19 ff ff ff       	call   801bd5 <syscall>
  801cbc:	83 c4 18             	add    $0x18,%esp
}
  801cbf:	c9                   	leave  
  801cc0:	c3                   	ret    

00801cc1 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801cc1:	55                   	push   %ebp
  801cc2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801cc4:	6a 00                	push   $0x0
  801cc6:	6a 00                	push   $0x0
  801cc8:	6a 00                	push   $0x0
  801cca:	6a 00                	push   $0x0
  801ccc:	6a 00                	push   $0x0
  801cce:	6a 09                	push   $0x9
  801cd0:	e8 00 ff ff ff       	call   801bd5 <syscall>
  801cd5:	83 c4 18             	add    $0x18,%esp
}
  801cd8:	c9                   	leave  
  801cd9:	c3                   	ret    

00801cda <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801cda:	55                   	push   %ebp
  801cdb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801cdd:	6a 00                	push   $0x0
  801cdf:	6a 00                	push   $0x0
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 0a                	push   $0xa
  801ce9:	e8 e7 fe ff ff       	call   801bd5 <syscall>
  801cee:	83 c4 18             	add    $0x18,%esp
}
  801cf1:	c9                   	leave  
  801cf2:	c3                   	ret    

00801cf3 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801cf3:	55                   	push   %ebp
  801cf4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801cf6:	6a 00                	push   $0x0
  801cf8:	6a 00                	push   $0x0
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 0b                	push   $0xb
  801d02:	e8 ce fe ff ff       	call   801bd5 <syscall>
  801d07:	83 c4 18             	add    $0x18,%esp
}
  801d0a:	c9                   	leave  
  801d0b:	c3                   	ret    

00801d0c <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801d0c:	55                   	push   %ebp
  801d0d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801d0f:	6a 00                	push   $0x0
  801d11:	6a 00                	push   $0x0
  801d13:	6a 00                	push   $0x0
  801d15:	ff 75 0c             	pushl  0xc(%ebp)
  801d18:	ff 75 08             	pushl  0x8(%ebp)
  801d1b:	6a 0f                	push   $0xf
  801d1d:	e8 b3 fe ff ff       	call   801bd5 <syscall>
  801d22:	83 c4 18             	add    $0x18,%esp
	return;
  801d25:	90                   	nop
}
  801d26:	c9                   	leave  
  801d27:	c3                   	ret    

00801d28 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801d28:	55                   	push   %ebp
  801d29:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 00                	push   $0x0
  801d31:	ff 75 0c             	pushl  0xc(%ebp)
  801d34:	ff 75 08             	pushl  0x8(%ebp)
  801d37:	6a 10                	push   $0x10
  801d39:	e8 97 fe ff ff       	call   801bd5 <syscall>
  801d3e:	83 c4 18             	add    $0x18,%esp
	return ;
  801d41:	90                   	nop
}
  801d42:	c9                   	leave  
  801d43:	c3                   	ret    

00801d44 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801d44:	55                   	push   %ebp
  801d45:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	ff 75 10             	pushl  0x10(%ebp)
  801d4e:	ff 75 0c             	pushl  0xc(%ebp)
  801d51:	ff 75 08             	pushl  0x8(%ebp)
  801d54:	6a 11                	push   $0x11
  801d56:	e8 7a fe ff ff       	call   801bd5 <syscall>
  801d5b:	83 c4 18             	add    $0x18,%esp
	return ;
  801d5e:	90                   	nop
}
  801d5f:	c9                   	leave  
  801d60:	c3                   	ret    

00801d61 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801d61:	55                   	push   %ebp
  801d62:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801d64:	6a 00                	push   $0x0
  801d66:	6a 00                	push   $0x0
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 0c                	push   $0xc
  801d70:	e8 60 fe ff ff       	call   801bd5 <syscall>
  801d75:	83 c4 18             	add    $0x18,%esp
}
  801d78:	c9                   	leave  
  801d79:	c3                   	ret    

00801d7a <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801d7a:	55                   	push   %ebp
  801d7b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 00                	push   $0x0
  801d83:	6a 00                	push   $0x0
  801d85:	ff 75 08             	pushl  0x8(%ebp)
  801d88:	6a 0d                	push   $0xd
  801d8a:	e8 46 fe ff ff       	call   801bd5 <syscall>
  801d8f:	83 c4 18             	add    $0x18,%esp
}
  801d92:	c9                   	leave  
  801d93:	c3                   	ret    

00801d94 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801d94:	55                   	push   %ebp
  801d95:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801d97:	6a 00                	push   $0x0
  801d99:	6a 00                	push   $0x0
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 00                	push   $0x0
  801d9f:	6a 00                	push   $0x0
  801da1:	6a 0e                	push   $0xe
  801da3:	e8 2d fe ff ff       	call   801bd5 <syscall>
  801da8:	83 c4 18             	add    $0x18,%esp
}
  801dab:	90                   	nop
  801dac:	c9                   	leave  
  801dad:	c3                   	ret    

00801dae <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801dae:	55                   	push   %ebp
  801daf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801db1:	6a 00                	push   $0x0
  801db3:	6a 00                	push   $0x0
  801db5:	6a 00                	push   $0x0
  801db7:	6a 00                	push   $0x0
  801db9:	6a 00                	push   $0x0
  801dbb:	6a 13                	push   $0x13
  801dbd:	e8 13 fe ff ff       	call   801bd5 <syscall>
  801dc2:	83 c4 18             	add    $0x18,%esp
}
  801dc5:	90                   	nop
  801dc6:	c9                   	leave  
  801dc7:	c3                   	ret    

00801dc8 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801dc8:	55                   	push   %ebp
  801dc9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801dcb:	6a 00                	push   $0x0
  801dcd:	6a 00                	push   $0x0
  801dcf:	6a 00                	push   $0x0
  801dd1:	6a 00                	push   $0x0
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 14                	push   $0x14
  801dd7:	e8 f9 fd ff ff       	call   801bd5 <syscall>
  801ddc:	83 c4 18             	add    $0x18,%esp
}
  801ddf:	90                   	nop
  801de0:	c9                   	leave  
  801de1:	c3                   	ret    

00801de2 <sys_cputc>:


void
sys_cputc(const char c)
{
  801de2:	55                   	push   %ebp
  801de3:	89 e5                	mov    %esp,%ebp
  801de5:	83 ec 04             	sub    $0x4,%esp
  801de8:	8b 45 08             	mov    0x8(%ebp),%eax
  801deb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801dee:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801df2:	6a 00                	push   $0x0
  801df4:	6a 00                	push   $0x0
  801df6:	6a 00                	push   $0x0
  801df8:	6a 00                	push   $0x0
  801dfa:	50                   	push   %eax
  801dfb:	6a 15                	push   $0x15
  801dfd:	e8 d3 fd ff ff       	call   801bd5 <syscall>
  801e02:	83 c4 18             	add    $0x18,%esp
}
  801e05:	90                   	nop
  801e06:	c9                   	leave  
  801e07:	c3                   	ret    

00801e08 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801e08:	55                   	push   %ebp
  801e09:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	6a 16                	push   $0x16
  801e17:	e8 b9 fd ff ff       	call   801bd5 <syscall>
  801e1c:	83 c4 18             	add    $0x18,%esp
}
  801e1f:	90                   	nop
  801e20:	c9                   	leave  
  801e21:	c3                   	ret    

00801e22 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801e22:	55                   	push   %ebp
  801e23:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801e25:	8b 45 08             	mov    0x8(%ebp),%eax
  801e28:	6a 00                	push   $0x0
  801e2a:	6a 00                	push   $0x0
  801e2c:	6a 00                	push   $0x0
  801e2e:	ff 75 0c             	pushl  0xc(%ebp)
  801e31:	50                   	push   %eax
  801e32:	6a 17                	push   $0x17
  801e34:	e8 9c fd ff ff       	call   801bd5 <syscall>
  801e39:	83 c4 18             	add    $0x18,%esp
}
  801e3c:	c9                   	leave  
  801e3d:	c3                   	ret    

00801e3e <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801e3e:	55                   	push   %ebp
  801e3f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801e41:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e44:	8b 45 08             	mov    0x8(%ebp),%eax
  801e47:	6a 00                	push   $0x0
  801e49:	6a 00                	push   $0x0
  801e4b:	6a 00                	push   $0x0
  801e4d:	52                   	push   %edx
  801e4e:	50                   	push   %eax
  801e4f:	6a 1a                	push   $0x1a
  801e51:	e8 7f fd ff ff       	call   801bd5 <syscall>
  801e56:	83 c4 18             	add    $0x18,%esp
}
  801e59:	c9                   	leave  
  801e5a:	c3                   	ret    

00801e5b <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801e5b:	55                   	push   %ebp
  801e5c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801e5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e61:	8b 45 08             	mov    0x8(%ebp),%eax
  801e64:	6a 00                	push   $0x0
  801e66:	6a 00                	push   $0x0
  801e68:	6a 00                	push   $0x0
  801e6a:	52                   	push   %edx
  801e6b:	50                   	push   %eax
  801e6c:	6a 18                	push   $0x18
  801e6e:	e8 62 fd ff ff       	call   801bd5 <syscall>
  801e73:	83 c4 18             	add    $0x18,%esp
}
  801e76:	90                   	nop
  801e77:	c9                   	leave  
  801e78:	c3                   	ret    

00801e79 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801e79:	55                   	push   %ebp
  801e7a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801e7c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e82:	6a 00                	push   $0x0
  801e84:	6a 00                	push   $0x0
  801e86:	6a 00                	push   $0x0
  801e88:	52                   	push   %edx
  801e89:	50                   	push   %eax
  801e8a:	6a 19                	push   $0x19
  801e8c:	e8 44 fd ff ff       	call   801bd5 <syscall>
  801e91:	83 c4 18             	add    $0x18,%esp
}
  801e94:	90                   	nop
  801e95:	c9                   	leave  
  801e96:	c3                   	ret    

00801e97 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801e97:	55                   	push   %ebp
  801e98:	89 e5                	mov    %esp,%ebp
  801e9a:	83 ec 04             	sub    $0x4,%esp
  801e9d:	8b 45 10             	mov    0x10(%ebp),%eax
  801ea0:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801ea3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ea6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801eaa:	8b 45 08             	mov    0x8(%ebp),%eax
  801ead:	6a 00                	push   $0x0
  801eaf:	51                   	push   %ecx
  801eb0:	52                   	push   %edx
  801eb1:	ff 75 0c             	pushl  0xc(%ebp)
  801eb4:	50                   	push   %eax
  801eb5:	6a 1b                	push   $0x1b
  801eb7:	e8 19 fd ff ff       	call   801bd5 <syscall>
  801ebc:	83 c4 18             	add    $0x18,%esp
}
  801ebf:	c9                   	leave  
  801ec0:	c3                   	ret    

00801ec1 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801ec1:	55                   	push   %ebp
  801ec2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801ec4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ec7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eca:	6a 00                	push   $0x0
  801ecc:	6a 00                	push   $0x0
  801ece:	6a 00                	push   $0x0
  801ed0:	52                   	push   %edx
  801ed1:	50                   	push   %eax
  801ed2:	6a 1c                	push   $0x1c
  801ed4:	e8 fc fc ff ff       	call   801bd5 <syscall>
  801ed9:	83 c4 18             	add    $0x18,%esp
}
  801edc:	c9                   	leave  
  801edd:	c3                   	ret    

00801ede <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801ede:	55                   	push   %ebp
  801edf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801ee1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ee4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ee7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eea:	6a 00                	push   $0x0
  801eec:	6a 00                	push   $0x0
  801eee:	51                   	push   %ecx
  801eef:	52                   	push   %edx
  801ef0:	50                   	push   %eax
  801ef1:	6a 1d                	push   $0x1d
  801ef3:	e8 dd fc ff ff       	call   801bd5 <syscall>
  801ef8:	83 c4 18             	add    $0x18,%esp
}
  801efb:	c9                   	leave  
  801efc:	c3                   	ret    

00801efd <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801efd:	55                   	push   %ebp
  801efe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801f00:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f03:	8b 45 08             	mov    0x8(%ebp),%eax
  801f06:	6a 00                	push   $0x0
  801f08:	6a 00                	push   $0x0
  801f0a:	6a 00                	push   $0x0
  801f0c:	52                   	push   %edx
  801f0d:	50                   	push   %eax
  801f0e:	6a 1e                	push   $0x1e
  801f10:	e8 c0 fc ff ff       	call   801bd5 <syscall>
  801f15:	83 c4 18             	add    $0x18,%esp
}
  801f18:	c9                   	leave  
  801f19:	c3                   	ret    

00801f1a <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801f1a:	55                   	push   %ebp
  801f1b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801f1d:	6a 00                	push   $0x0
  801f1f:	6a 00                	push   $0x0
  801f21:	6a 00                	push   $0x0
  801f23:	6a 00                	push   $0x0
  801f25:	6a 00                	push   $0x0
  801f27:	6a 1f                	push   $0x1f
  801f29:	e8 a7 fc ff ff       	call   801bd5 <syscall>
  801f2e:	83 c4 18             	add    $0x18,%esp
}
  801f31:	c9                   	leave  
  801f32:	c3                   	ret    

00801f33 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801f33:	55                   	push   %ebp
  801f34:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801f36:	8b 45 08             	mov    0x8(%ebp),%eax
  801f39:	6a 00                	push   $0x0
  801f3b:	ff 75 14             	pushl  0x14(%ebp)
  801f3e:	ff 75 10             	pushl  0x10(%ebp)
  801f41:	ff 75 0c             	pushl  0xc(%ebp)
  801f44:	50                   	push   %eax
  801f45:	6a 20                	push   $0x20
  801f47:	e8 89 fc ff ff       	call   801bd5 <syscall>
  801f4c:	83 c4 18             	add    $0x18,%esp
}
  801f4f:	c9                   	leave  
  801f50:	c3                   	ret    

00801f51 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801f51:	55                   	push   %ebp
  801f52:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801f54:	8b 45 08             	mov    0x8(%ebp),%eax
  801f57:	6a 00                	push   $0x0
  801f59:	6a 00                	push   $0x0
  801f5b:	6a 00                	push   $0x0
  801f5d:	6a 00                	push   $0x0
  801f5f:	50                   	push   %eax
  801f60:	6a 21                	push   $0x21
  801f62:	e8 6e fc ff ff       	call   801bd5 <syscall>
  801f67:	83 c4 18             	add    $0x18,%esp
}
  801f6a:	90                   	nop
  801f6b:	c9                   	leave  
  801f6c:	c3                   	ret    

00801f6d <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801f6d:	55                   	push   %ebp
  801f6e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801f70:	8b 45 08             	mov    0x8(%ebp),%eax
  801f73:	6a 00                	push   $0x0
  801f75:	6a 00                	push   $0x0
  801f77:	6a 00                	push   $0x0
  801f79:	6a 00                	push   $0x0
  801f7b:	50                   	push   %eax
  801f7c:	6a 22                	push   $0x22
  801f7e:	e8 52 fc ff ff       	call   801bd5 <syscall>
  801f83:	83 c4 18             	add    $0x18,%esp
}
  801f86:	c9                   	leave  
  801f87:	c3                   	ret    

00801f88 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801f88:	55                   	push   %ebp
  801f89:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801f8b:	6a 00                	push   $0x0
  801f8d:	6a 00                	push   $0x0
  801f8f:	6a 00                	push   $0x0
  801f91:	6a 00                	push   $0x0
  801f93:	6a 00                	push   $0x0
  801f95:	6a 02                	push   $0x2
  801f97:	e8 39 fc ff ff       	call   801bd5 <syscall>
  801f9c:	83 c4 18             	add    $0x18,%esp
}
  801f9f:	c9                   	leave  
  801fa0:	c3                   	ret    

00801fa1 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801fa1:	55                   	push   %ebp
  801fa2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801fa4:	6a 00                	push   $0x0
  801fa6:	6a 00                	push   $0x0
  801fa8:	6a 00                	push   $0x0
  801faa:	6a 00                	push   $0x0
  801fac:	6a 00                	push   $0x0
  801fae:	6a 03                	push   $0x3
  801fb0:	e8 20 fc ff ff       	call   801bd5 <syscall>
  801fb5:	83 c4 18             	add    $0x18,%esp
}
  801fb8:	c9                   	leave  
  801fb9:	c3                   	ret    

00801fba <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801fba:	55                   	push   %ebp
  801fbb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801fbd:	6a 00                	push   $0x0
  801fbf:	6a 00                	push   $0x0
  801fc1:	6a 00                	push   $0x0
  801fc3:	6a 00                	push   $0x0
  801fc5:	6a 00                	push   $0x0
  801fc7:	6a 04                	push   $0x4
  801fc9:	e8 07 fc ff ff       	call   801bd5 <syscall>
  801fce:	83 c4 18             	add    $0x18,%esp
}
  801fd1:	c9                   	leave  
  801fd2:	c3                   	ret    

00801fd3 <sys_exit_env>:


void sys_exit_env(void)
{
  801fd3:	55                   	push   %ebp
  801fd4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801fd6:	6a 00                	push   $0x0
  801fd8:	6a 00                	push   $0x0
  801fda:	6a 00                	push   $0x0
  801fdc:	6a 00                	push   $0x0
  801fde:	6a 00                	push   $0x0
  801fe0:	6a 23                	push   $0x23
  801fe2:	e8 ee fb ff ff       	call   801bd5 <syscall>
  801fe7:	83 c4 18             	add    $0x18,%esp
}
  801fea:	90                   	nop
  801feb:	c9                   	leave  
  801fec:	c3                   	ret    

00801fed <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801fed:	55                   	push   %ebp
  801fee:	89 e5                	mov    %esp,%ebp
  801ff0:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801ff3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ff6:	8d 50 04             	lea    0x4(%eax),%edx
  801ff9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ffc:	6a 00                	push   $0x0
  801ffe:	6a 00                	push   $0x0
  802000:	6a 00                	push   $0x0
  802002:	52                   	push   %edx
  802003:	50                   	push   %eax
  802004:	6a 24                	push   $0x24
  802006:	e8 ca fb ff ff       	call   801bd5 <syscall>
  80200b:	83 c4 18             	add    $0x18,%esp
	return result;
  80200e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802011:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802014:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802017:	89 01                	mov    %eax,(%ecx)
  802019:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80201c:	8b 45 08             	mov    0x8(%ebp),%eax
  80201f:	c9                   	leave  
  802020:	c2 04 00             	ret    $0x4

00802023 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802023:	55                   	push   %ebp
  802024:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802026:	6a 00                	push   $0x0
  802028:	6a 00                	push   $0x0
  80202a:	ff 75 10             	pushl  0x10(%ebp)
  80202d:	ff 75 0c             	pushl  0xc(%ebp)
  802030:	ff 75 08             	pushl  0x8(%ebp)
  802033:	6a 12                	push   $0x12
  802035:	e8 9b fb ff ff       	call   801bd5 <syscall>
  80203a:	83 c4 18             	add    $0x18,%esp
	return ;
  80203d:	90                   	nop
}
  80203e:	c9                   	leave  
  80203f:	c3                   	ret    

00802040 <sys_rcr2>:
uint32 sys_rcr2()
{
  802040:	55                   	push   %ebp
  802041:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802043:	6a 00                	push   $0x0
  802045:	6a 00                	push   $0x0
  802047:	6a 00                	push   $0x0
  802049:	6a 00                	push   $0x0
  80204b:	6a 00                	push   $0x0
  80204d:	6a 25                	push   $0x25
  80204f:	e8 81 fb ff ff       	call   801bd5 <syscall>
  802054:	83 c4 18             	add    $0x18,%esp
}
  802057:	c9                   	leave  
  802058:	c3                   	ret    

00802059 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802059:	55                   	push   %ebp
  80205a:	89 e5                	mov    %esp,%ebp
  80205c:	83 ec 04             	sub    $0x4,%esp
  80205f:	8b 45 08             	mov    0x8(%ebp),%eax
  802062:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802065:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802069:	6a 00                	push   $0x0
  80206b:	6a 00                	push   $0x0
  80206d:	6a 00                	push   $0x0
  80206f:	6a 00                	push   $0x0
  802071:	50                   	push   %eax
  802072:	6a 26                	push   $0x26
  802074:	e8 5c fb ff ff       	call   801bd5 <syscall>
  802079:	83 c4 18             	add    $0x18,%esp
	return ;
  80207c:	90                   	nop
}
  80207d:	c9                   	leave  
  80207e:	c3                   	ret    

0080207f <rsttst>:
void rsttst()
{
  80207f:	55                   	push   %ebp
  802080:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802082:	6a 00                	push   $0x0
  802084:	6a 00                	push   $0x0
  802086:	6a 00                	push   $0x0
  802088:	6a 00                	push   $0x0
  80208a:	6a 00                	push   $0x0
  80208c:	6a 28                	push   $0x28
  80208e:	e8 42 fb ff ff       	call   801bd5 <syscall>
  802093:	83 c4 18             	add    $0x18,%esp
	return ;
  802096:	90                   	nop
}
  802097:	c9                   	leave  
  802098:	c3                   	ret    

00802099 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802099:	55                   	push   %ebp
  80209a:	89 e5                	mov    %esp,%ebp
  80209c:	83 ec 04             	sub    $0x4,%esp
  80209f:	8b 45 14             	mov    0x14(%ebp),%eax
  8020a2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8020a5:	8b 55 18             	mov    0x18(%ebp),%edx
  8020a8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8020ac:	52                   	push   %edx
  8020ad:	50                   	push   %eax
  8020ae:	ff 75 10             	pushl  0x10(%ebp)
  8020b1:	ff 75 0c             	pushl  0xc(%ebp)
  8020b4:	ff 75 08             	pushl  0x8(%ebp)
  8020b7:	6a 27                	push   $0x27
  8020b9:	e8 17 fb ff ff       	call   801bd5 <syscall>
  8020be:	83 c4 18             	add    $0x18,%esp
	return ;
  8020c1:	90                   	nop
}
  8020c2:	c9                   	leave  
  8020c3:	c3                   	ret    

008020c4 <chktst>:
void chktst(uint32 n)
{
  8020c4:	55                   	push   %ebp
  8020c5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8020c7:	6a 00                	push   $0x0
  8020c9:	6a 00                	push   $0x0
  8020cb:	6a 00                	push   $0x0
  8020cd:	6a 00                	push   $0x0
  8020cf:	ff 75 08             	pushl  0x8(%ebp)
  8020d2:	6a 29                	push   $0x29
  8020d4:	e8 fc fa ff ff       	call   801bd5 <syscall>
  8020d9:	83 c4 18             	add    $0x18,%esp
	return ;
  8020dc:	90                   	nop
}
  8020dd:	c9                   	leave  
  8020de:	c3                   	ret    

008020df <inctst>:

void inctst()
{
  8020df:	55                   	push   %ebp
  8020e0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8020e2:	6a 00                	push   $0x0
  8020e4:	6a 00                	push   $0x0
  8020e6:	6a 00                	push   $0x0
  8020e8:	6a 00                	push   $0x0
  8020ea:	6a 00                	push   $0x0
  8020ec:	6a 2a                	push   $0x2a
  8020ee:	e8 e2 fa ff ff       	call   801bd5 <syscall>
  8020f3:	83 c4 18             	add    $0x18,%esp
	return ;
  8020f6:	90                   	nop
}
  8020f7:	c9                   	leave  
  8020f8:	c3                   	ret    

008020f9 <gettst>:
uint32 gettst()
{
  8020f9:	55                   	push   %ebp
  8020fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8020fc:	6a 00                	push   $0x0
  8020fe:	6a 00                	push   $0x0
  802100:	6a 00                	push   $0x0
  802102:	6a 00                	push   $0x0
  802104:	6a 00                	push   $0x0
  802106:	6a 2b                	push   $0x2b
  802108:	e8 c8 fa ff ff       	call   801bd5 <syscall>
  80210d:	83 c4 18             	add    $0x18,%esp
}
  802110:	c9                   	leave  
  802111:	c3                   	ret    

00802112 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802112:	55                   	push   %ebp
  802113:	89 e5                	mov    %esp,%ebp
  802115:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802118:	6a 00                	push   $0x0
  80211a:	6a 00                	push   $0x0
  80211c:	6a 00                	push   $0x0
  80211e:	6a 00                	push   $0x0
  802120:	6a 00                	push   $0x0
  802122:	6a 2c                	push   $0x2c
  802124:	e8 ac fa ff ff       	call   801bd5 <syscall>
  802129:	83 c4 18             	add    $0x18,%esp
  80212c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80212f:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802133:	75 07                	jne    80213c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802135:	b8 01 00 00 00       	mov    $0x1,%eax
  80213a:	eb 05                	jmp    802141 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80213c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802141:	c9                   	leave  
  802142:	c3                   	ret    

00802143 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802143:	55                   	push   %ebp
  802144:	89 e5                	mov    %esp,%ebp
  802146:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802149:	6a 00                	push   $0x0
  80214b:	6a 00                	push   $0x0
  80214d:	6a 00                	push   $0x0
  80214f:	6a 00                	push   $0x0
  802151:	6a 00                	push   $0x0
  802153:	6a 2c                	push   $0x2c
  802155:	e8 7b fa ff ff       	call   801bd5 <syscall>
  80215a:	83 c4 18             	add    $0x18,%esp
  80215d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802160:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802164:	75 07                	jne    80216d <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802166:	b8 01 00 00 00       	mov    $0x1,%eax
  80216b:	eb 05                	jmp    802172 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80216d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802172:	c9                   	leave  
  802173:	c3                   	ret    

00802174 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802174:	55                   	push   %ebp
  802175:	89 e5                	mov    %esp,%ebp
  802177:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80217a:	6a 00                	push   $0x0
  80217c:	6a 00                	push   $0x0
  80217e:	6a 00                	push   $0x0
  802180:	6a 00                	push   $0x0
  802182:	6a 00                	push   $0x0
  802184:	6a 2c                	push   $0x2c
  802186:	e8 4a fa ff ff       	call   801bd5 <syscall>
  80218b:	83 c4 18             	add    $0x18,%esp
  80218e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802191:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802195:	75 07                	jne    80219e <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802197:	b8 01 00 00 00       	mov    $0x1,%eax
  80219c:	eb 05                	jmp    8021a3 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80219e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021a3:	c9                   	leave  
  8021a4:	c3                   	ret    

008021a5 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8021a5:	55                   	push   %ebp
  8021a6:	89 e5                	mov    %esp,%ebp
  8021a8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021ab:	6a 00                	push   $0x0
  8021ad:	6a 00                	push   $0x0
  8021af:	6a 00                	push   $0x0
  8021b1:	6a 00                	push   $0x0
  8021b3:	6a 00                	push   $0x0
  8021b5:	6a 2c                	push   $0x2c
  8021b7:	e8 19 fa ff ff       	call   801bd5 <syscall>
  8021bc:	83 c4 18             	add    $0x18,%esp
  8021bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8021c2:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8021c6:	75 07                	jne    8021cf <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8021c8:	b8 01 00 00 00       	mov    $0x1,%eax
  8021cd:	eb 05                	jmp    8021d4 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8021cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021d4:	c9                   	leave  
  8021d5:	c3                   	ret    

008021d6 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8021d6:	55                   	push   %ebp
  8021d7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8021d9:	6a 00                	push   $0x0
  8021db:	6a 00                	push   $0x0
  8021dd:	6a 00                	push   $0x0
  8021df:	6a 00                	push   $0x0
  8021e1:	ff 75 08             	pushl  0x8(%ebp)
  8021e4:	6a 2d                	push   $0x2d
  8021e6:	e8 ea f9 ff ff       	call   801bd5 <syscall>
  8021eb:	83 c4 18             	add    $0x18,%esp
	return ;
  8021ee:	90                   	nop
}
  8021ef:	c9                   	leave  
  8021f0:	c3                   	ret    

008021f1 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8021f1:	55                   	push   %ebp
  8021f2:	89 e5                	mov    %esp,%ebp
  8021f4:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8021f5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021f8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802201:	6a 00                	push   $0x0
  802203:	53                   	push   %ebx
  802204:	51                   	push   %ecx
  802205:	52                   	push   %edx
  802206:	50                   	push   %eax
  802207:	6a 2e                	push   $0x2e
  802209:	e8 c7 f9 ff ff       	call   801bd5 <syscall>
  80220e:	83 c4 18             	add    $0x18,%esp
}
  802211:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802214:	c9                   	leave  
  802215:	c3                   	ret    

00802216 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802216:	55                   	push   %ebp
  802217:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802219:	8b 55 0c             	mov    0xc(%ebp),%edx
  80221c:	8b 45 08             	mov    0x8(%ebp),%eax
  80221f:	6a 00                	push   $0x0
  802221:	6a 00                	push   $0x0
  802223:	6a 00                	push   $0x0
  802225:	52                   	push   %edx
  802226:	50                   	push   %eax
  802227:	6a 2f                	push   $0x2f
  802229:	e8 a7 f9 ff ff       	call   801bd5 <syscall>
  80222e:	83 c4 18             	add    $0x18,%esp
}
  802231:	c9                   	leave  
  802232:	c3                   	ret    

00802233 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802233:	55                   	push   %ebp
  802234:	89 e5                	mov    %esp,%ebp
  802236:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802239:	83 ec 0c             	sub    $0xc,%esp
  80223c:	68 9c 40 80 00       	push   $0x80409c
  802241:	e8 21 e7 ff ff       	call   800967 <cprintf>
  802246:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802249:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802250:	83 ec 0c             	sub    $0xc,%esp
  802253:	68 c8 40 80 00       	push   $0x8040c8
  802258:	e8 0a e7 ff ff       	call   800967 <cprintf>
  80225d:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802260:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802264:	a1 38 51 80 00       	mov    0x805138,%eax
  802269:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80226c:	eb 56                	jmp    8022c4 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80226e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802272:	74 1c                	je     802290 <print_mem_block_lists+0x5d>
  802274:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802277:	8b 50 08             	mov    0x8(%eax),%edx
  80227a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80227d:	8b 48 08             	mov    0x8(%eax),%ecx
  802280:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802283:	8b 40 0c             	mov    0xc(%eax),%eax
  802286:	01 c8                	add    %ecx,%eax
  802288:	39 c2                	cmp    %eax,%edx
  80228a:	73 04                	jae    802290 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  80228c:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802290:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802293:	8b 50 08             	mov    0x8(%eax),%edx
  802296:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802299:	8b 40 0c             	mov    0xc(%eax),%eax
  80229c:	01 c2                	add    %eax,%edx
  80229e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a1:	8b 40 08             	mov    0x8(%eax),%eax
  8022a4:	83 ec 04             	sub    $0x4,%esp
  8022a7:	52                   	push   %edx
  8022a8:	50                   	push   %eax
  8022a9:	68 dd 40 80 00       	push   $0x8040dd
  8022ae:	e8 b4 e6 ff ff       	call   800967 <cprintf>
  8022b3:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8022b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8022bc:	a1 40 51 80 00       	mov    0x805140,%eax
  8022c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022c8:	74 07                	je     8022d1 <print_mem_block_lists+0x9e>
  8022ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cd:	8b 00                	mov    (%eax),%eax
  8022cf:	eb 05                	jmp    8022d6 <print_mem_block_lists+0xa3>
  8022d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8022d6:	a3 40 51 80 00       	mov    %eax,0x805140
  8022db:	a1 40 51 80 00       	mov    0x805140,%eax
  8022e0:	85 c0                	test   %eax,%eax
  8022e2:	75 8a                	jne    80226e <print_mem_block_lists+0x3b>
  8022e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022e8:	75 84                	jne    80226e <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8022ea:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8022ee:	75 10                	jne    802300 <print_mem_block_lists+0xcd>
  8022f0:	83 ec 0c             	sub    $0xc,%esp
  8022f3:	68 ec 40 80 00       	push   $0x8040ec
  8022f8:	e8 6a e6 ff ff       	call   800967 <cprintf>
  8022fd:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802300:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802307:	83 ec 0c             	sub    $0xc,%esp
  80230a:	68 10 41 80 00       	push   $0x804110
  80230f:	e8 53 e6 ff ff       	call   800967 <cprintf>
  802314:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802317:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80231b:	a1 40 50 80 00       	mov    0x805040,%eax
  802320:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802323:	eb 56                	jmp    80237b <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802325:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802329:	74 1c                	je     802347 <print_mem_block_lists+0x114>
  80232b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232e:	8b 50 08             	mov    0x8(%eax),%edx
  802331:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802334:	8b 48 08             	mov    0x8(%eax),%ecx
  802337:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80233a:	8b 40 0c             	mov    0xc(%eax),%eax
  80233d:	01 c8                	add    %ecx,%eax
  80233f:	39 c2                	cmp    %eax,%edx
  802341:	73 04                	jae    802347 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802343:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802347:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234a:	8b 50 08             	mov    0x8(%eax),%edx
  80234d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802350:	8b 40 0c             	mov    0xc(%eax),%eax
  802353:	01 c2                	add    %eax,%edx
  802355:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802358:	8b 40 08             	mov    0x8(%eax),%eax
  80235b:	83 ec 04             	sub    $0x4,%esp
  80235e:	52                   	push   %edx
  80235f:	50                   	push   %eax
  802360:	68 dd 40 80 00       	push   $0x8040dd
  802365:	e8 fd e5 ff ff       	call   800967 <cprintf>
  80236a:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80236d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802370:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802373:	a1 48 50 80 00       	mov    0x805048,%eax
  802378:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80237b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80237f:	74 07                	je     802388 <print_mem_block_lists+0x155>
  802381:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802384:	8b 00                	mov    (%eax),%eax
  802386:	eb 05                	jmp    80238d <print_mem_block_lists+0x15a>
  802388:	b8 00 00 00 00       	mov    $0x0,%eax
  80238d:	a3 48 50 80 00       	mov    %eax,0x805048
  802392:	a1 48 50 80 00       	mov    0x805048,%eax
  802397:	85 c0                	test   %eax,%eax
  802399:	75 8a                	jne    802325 <print_mem_block_lists+0xf2>
  80239b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80239f:	75 84                	jne    802325 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8023a1:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8023a5:	75 10                	jne    8023b7 <print_mem_block_lists+0x184>
  8023a7:	83 ec 0c             	sub    $0xc,%esp
  8023aa:	68 28 41 80 00       	push   $0x804128
  8023af:	e8 b3 e5 ff ff       	call   800967 <cprintf>
  8023b4:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8023b7:	83 ec 0c             	sub    $0xc,%esp
  8023ba:	68 9c 40 80 00       	push   $0x80409c
  8023bf:	e8 a3 e5 ff ff       	call   800967 <cprintf>
  8023c4:	83 c4 10             	add    $0x10,%esp

}
  8023c7:	90                   	nop
  8023c8:	c9                   	leave  
  8023c9:	c3                   	ret    

008023ca <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8023ca:	55                   	push   %ebp
  8023cb:	89 e5                	mov    %esp,%ebp
  8023cd:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  8023d0:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8023d7:	00 00 00 
  8023da:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8023e1:	00 00 00 
  8023e4:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8023eb:	00 00 00 
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  8023ee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8023f5:	e9 9e 00 00 00       	jmp    802498 <initialize_MemBlocksList+0xce>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
  8023fa:	a1 50 50 80 00       	mov    0x805050,%eax
  8023ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802402:	c1 e2 04             	shl    $0x4,%edx
  802405:	01 d0                	add    %edx,%eax
  802407:	85 c0                	test   %eax,%eax
  802409:	75 14                	jne    80241f <initialize_MemBlocksList+0x55>
  80240b:	83 ec 04             	sub    $0x4,%esp
  80240e:	68 50 41 80 00       	push   $0x804150
  802413:	6a 43                	push   $0x43
  802415:	68 73 41 80 00       	push   $0x804173
  80241a:	e8 94 e2 ff ff       	call   8006b3 <_panic>
  80241f:	a1 50 50 80 00       	mov    0x805050,%eax
  802424:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802427:	c1 e2 04             	shl    $0x4,%edx
  80242a:	01 d0                	add    %edx,%eax
  80242c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802432:	89 10                	mov    %edx,(%eax)
  802434:	8b 00                	mov    (%eax),%eax
  802436:	85 c0                	test   %eax,%eax
  802438:	74 18                	je     802452 <initialize_MemBlocksList+0x88>
  80243a:	a1 48 51 80 00       	mov    0x805148,%eax
  80243f:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802445:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802448:	c1 e1 04             	shl    $0x4,%ecx
  80244b:	01 ca                	add    %ecx,%edx
  80244d:	89 50 04             	mov    %edx,0x4(%eax)
  802450:	eb 12                	jmp    802464 <initialize_MemBlocksList+0x9a>
  802452:	a1 50 50 80 00       	mov    0x805050,%eax
  802457:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80245a:	c1 e2 04             	shl    $0x4,%edx
  80245d:	01 d0                	add    %edx,%eax
  80245f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802464:	a1 50 50 80 00       	mov    0x805050,%eax
  802469:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80246c:	c1 e2 04             	shl    $0x4,%edx
  80246f:	01 d0                	add    %edx,%eax
  802471:	a3 48 51 80 00       	mov    %eax,0x805148
  802476:	a1 50 50 80 00       	mov    0x805050,%eax
  80247b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80247e:	c1 e2 04             	shl    $0x4,%edx
  802481:	01 d0                	add    %edx,%eax
  802483:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80248a:	a1 54 51 80 00       	mov    0x805154,%eax
  80248f:	40                   	inc    %eax
  802490:	a3 54 51 80 00       	mov    %eax,0x805154
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  802495:	ff 45 f4             	incl   -0xc(%ebp)
  802498:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80249e:	0f 82 56 ff ff ff    	jb     8023fa <initialize_MemBlocksList+0x30>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
		}
}
  8024a4:	90                   	nop
  8024a5:	c9                   	leave  
  8024a6:	c3                   	ret    

008024a7 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8024a7:	55                   	push   %ebp
  8024a8:	89 e5                	mov    %esp,%ebp
  8024aa:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  8024ad:	a1 38 51 80 00       	mov    0x805138,%eax
  8024b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8024b5:	eb 18                	jmp    8024cf <find_block+0x28>
	{
		if (ele->sva==va)
  8024b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024ba:	8b 40 08             	mov    0x8(%eax),%eax
  8024bd:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8024c0:	75 05                	jne    8024c7 <find_block+0x20>
			return ele;
  8024c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024c5:	eb 7b                	jmp    802542 <find_block+0x9b>
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  8024c7:	a1 40 51 80 00       	mov    0x805140,%eax
  8024cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8024cf:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8024d3:	74 07                	je     8024dc <find_block+0x35>
  8024d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024d8:	8b 00                	mov    (%eax),%eax
  8024da:	eb 05                	jmp    8024e1 <find_block+0x3a>
  8024dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8024e1:	a3 40 51 80 00       	mov    %eax,0x805140
  8024e6:	a1 40 51 80 00       	mov    0x805140,%eax
  8024eb:	85 c0                	test   %eax,%eax
  8024ed:	75 c8                	jne    8024b7 <find_block+0x10>
  8024ef:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8024f3:	75 c2                	jne    8024b7 <find_block+0x10>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  8024f5:	a1 40 50 80 00       	mov    0x805040,%eax
  8024fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8024fd:	eb 18                	jmp    802517 <find_block+0x70>
	{
		if (ele->sva==va)
  8024ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802502:	8b 40 08             	mov    0x8(%eax),%eax
  802505:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802508:	75 05                	jne    80250f <find_block+0x68>
					return ele;
  80250a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80250d:	eb 33                	jmp    802542 <find_block+0x9b>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  80250f:	a1 48 50 80 00       	mov    0x805048,%eax
  802514:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802517:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80251b:	74 07                	je     802524 <find_block+0x7d>
  80251d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802520:	8b 00                	mov    (%eax),%eax
  802522:	eb 05                	jmp    802529 <find_block+0x82>
  802524:	b8 00 00 00 00       	mov    $0x0,%eax
  802529:	a3 48 50 80 00       	mov    %eax,0x805048
  80252e:	a1 48 50 80 00       	mov    0x805048,%eax
  802533:	85 c0                	test   %eax,%eax
  802535:	75 c8                	jne    8024ff <find_block+0x58>
  802537:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80253b:	75 c2                	jne    8024ff <find_block+0x58>
	{
		if (ele->sva==va)
					return ele;
	}
return NULL;
  80253d:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802542:	c9                   	leave  
  802543:	c3                   	ret    

00802544 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802544:	55                   	push   %ebp
  802545:	89 e5                	mov    %esp,%ebp
  802547:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;

int x =LIST_SIZE(&AllocMemBlocksList);
  80254a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80254f:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((x==0))
  802552:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802556:	75 62                	jne    8025ba <insert_sorted_allocList+0x76>
	{
	//	blockToInsert=AllocMemBlocksList.lh_first;
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  802558:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80255c:	75 14                	jne    802572 <insert_sorted_allocList+0x2e>
  80255e:	83 ec 04             	sub    $0x4,%esp
  802561:	68 50 41 80 00       	push   $0x804150
  802566:	6a 69                	push   $0x69
  802568:	68 73 41 80 00       	push   $0x804173
  80256d:	e8 41 e1 ff ff       	call   8006b3 <_panic>
  802572:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802578:	8b 45 08             	mov    0x8(%ebp),%eax
  80257b:	89 10                	mov    %edx,(%eax)
  80257d:	8b 45 08             	mov    0x8(%ebp),%eax
  802580:	8b 00                	mov    (%eax),%eax
  802582:	85 c0                	test   %eax,%eax
  802584:	74 0d                	je     802593 <insert_sorted_allocList+0x4f>
  802586:	a1 40 50 80 00       	mov    0x805040,%eax
  80258b:	8b 55 08             	mov    0x8(%ebp),%edx
  80258e:	89 50 04             	mov    %edx,0x4(%eax)
  802591:	eb 08                	jmp    80259b <insert_sorted_allocList+0x57>
  802593:	8b 45 08             	mov    0x8(%ebp),%eax
  802596:	a3 44 50 80 00       	mov    %eax,0x805044
  80259b:	8b 45 08             	mov    0x8(%ebp),%eax
  80259e:	a3 40 50 80 00       	mov    %eax,0x805040
  8025a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025ad:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8025b2:	40                   	inc    %eax
  8025b3:	a3 4c 50 80 00       	mov    %eax,0x80504c
  8025b8:	eb 72                	jmp    80262c <insert_sorted_allocList+0xe8>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
  8025ba:	a1 40 50 80 00       	mov    0x805040,%eax
  8025bf:	8b 50 08             	mov    0x8(%eax),%edx
  8025c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c5:	8b 40 08             	mov    0x8(%eax),%eax
  8025c8:	39 c2                	cmp    %eax,%edx
  8025ca:	76 60                	jbe    80262c <insert_sorted_allocList+0xe8>
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  8025cc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8025d0:	75 14                	jne    8025e6 <insert_sorted_allocList+0xa2>
  8025d2:	83 ec 04             	sub    $0x4,%esp
  8025d5:	68 50 41 80 00       	push   $0x804150
  8025da:	6a 6d                	push   $0x6d
  8025dc:	68 73 41 80 00       	push   $0x804173
  8025e1:	e8 cd e0 ff ff       	call   8006b3 <_panic>
  8025e6:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8025ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ef:	89 10                	mov    %edx,(%eax)
  8025f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f4:	8b 00                	mov    (%eax),%eax
  8025f6:	85 c0                	test   %eax,%eax
  8025f8:	74 0d                	je     802607 <insert_sorted_allocList+0xc3>
  8025fa:	a1 40 50 80 00       	mov    0x805040,%eax
  8025ff:	8b 55 08             	mov    0x8(%ebp),%edx
  802602:	89 50 04             	mov    %edx,0x4(%eax)
  802605:	eb 08                	jmp    80260f <insert_sorted_allocList+0xcb>
  802607:	8b 45 08             	mov    0x8(%ebp),%eax
  80260a:	a3 44 50 80 00       	mov    %eax,0x805044
  80260f:	8b 45 08             	mov    0x8(%ebp),%eax
  802612:	a3 40 50 80 00       	mov    %eax,0x805040
  802617:	8b 45 08             	mov    0x8(%ebp),%eax
  80261a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802621:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802626:	40                   	inc    %eax
  802627:	a3 4c 50 80 00       	mov    %eax,0x80504c
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  80262c:	a1 40 50 80 00       	mov    0x805040,%eax
  802631:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802634:	e9 b9 01 00 00       	jmp    8027f2 <insert_sorted_allocList+0x2ae>
	{


		if ((blockToInsert->sva>AllocMemBlocksList.lh_first->sva)&&blockToInsert->sva<element->sva)
  802639:	8b 45 08             	mov    0x8(%ebp),%eax
  80263c:	8b 50 08             	mov    0x8(%eax),%edx
  80263f:	a1 40 50 80 00       	mov    0x805040,%eax
  802644:	8b 40 08             	mov    0x8(%eax),%eax
  802647:	39 c2                	cmp    %eax,%edx
  802649:	76 7c                	jbe    8026c7 <insert_sorted_allocList+0x183>
  80264b:	8b 45 08             	mov    0x8(%ebp),%eax
  80264e:	8b 50 08             	mov    0x8(%eax),%edx
  802651:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802654:	8b 40 08             	mov    0x8(%eax),%eax
  802657:	39 c2                	cmp    %eax,%edx
  802659:	73 6c                	jae    8026c7 <insert_sorted_allocList+0x183>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,element,blockToInsert);
  80265b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80265f:	74 06                	je     802667 <insert_sorted_allocList+0x123>
  802661:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802665:	75 14                	jne    80267b <insert_sorted_allocList+0x137>
  802667:	83 ec 04             	sub    $0x4,%esp
  80266a:	68 8c 41 80 00       	push   $0x80418c
  80266f:	6a 75                	push   $0x75
  802671:	68 73 41 80 00       	push   $0x804173
  802676:	e8 38 e0 ff ff       	call   8006b3 <_panic>
  80267b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267e:	8b 50 04             	mov    0x4(%eax),%edx
  802681:	8b 45 08             	mov    0x8(%ebp),%eax
  802684:	89 50 04             	mov    %edx,0x4(%eax)
  802687:	8b 45 08             	mov    0x8(%ebp),%eax
  80268a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80268d:	89 10                	mov    %edx,(%eax)
  80268f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802692:	8b 40 04             	mov    0x4(%eax),%eax
  802695:	85 c0                	test   %eax,%eax
  802697:	74 0d                	je     8026a6 <insert_sorted_allocList+0x162>
  802699:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269c:	8b 40 04             	mov    0x4(%eax),%eax
  80269f:	8b 55 08             	mov    0x8(%ebp),%edx
  8026a2:	89 10                	mov    %edx,(%eax)
  8026a4:	eb 08                	jmp    8026ae <insert_sorted_allocList+0x16a>
  8026a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a9:	a3 40 50 80 00       	mov    %eax,0x805040
  8026ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8026b4:	89 50 04             	mov    %edx,0x4(%eax)
  8026b7:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8026bc:	40                   	inc    %eax
  8026bd:	a3 4c 50 80 00       	mov    %eax,0x80504c

		break;}
  8026c2:	e9 59 01 00 00       	jmp    802820 <insert_sorted_allocList+0x2dc>

	else if ((blockToInsert->sva>element->sva)&&(blockToInsert->sva<AllocMemBlocksList.lh_last->sva)&&blockToInsert->sva<LIST_NEXT(element)->sva)
  8026c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ca:	8b 50 08             	mov    0x8(%eax),%edx
  8026cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d0:	8b 40 08             	mov    0x8(%eax),%eax
  8026d3:	39 c2                	cmp    %eax,%edx
  8026d5:	0f 86 98 00 00 00    	jbe    802773 <insert_sorted_allocList+0x22f>
  8026db:	8b 45 08             	mov    0x8(%ebp),%eax
  8026de:	8b 50 08             	mov    0x8(%eax),%edx
  8026e1:	a1 44 50 80 00       	mov    0x805044,%eax
  8026e6:	8b 40 08             	mov    0x8(%eax),%eax
  8026e9:	39 c2                	cmp    %eax,%edx
  8026eb:	0f 83 82 00 00 00    	jae    802773 <insert_sorted_allocList+0x22f>
  8026f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f4:	8b 50 08             	mov    0x8(%eax),%edx
  8026f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fa:	8b 00                	mov    (%eax),%eax
  8026fc:	8b 40 08             	mov    0x8(%eax),%eax
  8026ff:	39 c2                	cmp    %eax,%edx
  802701:	73 70                	jae    802773 <insert_sorted_allocList+0x22f>
	{

	LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  802703:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802707:	74 06                	je     80270f <insert_sorted_allocList+0x1cb>
  802709:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80270d:	75 14                	jne    802723 <insert_sorted_allocList+0x1df>
  80270f:	83 ec 04             	sub    $0x4,%esp
  802712:	68 c4 41 80 00       	push   $0x8041c4
  802717:	6a 7c                	push   $0x7c
  802719:	68 73 41 80 00       	push   $0x804173
  80271e:	e8 90 df ff ff       	call   8006b3 <_panic>
  802723:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802726:	8b 10                	mov    (%eax),%edx
  802728:	8b 45 08             	mov    0x8(%ebp),%eax
  80272b:	89 10                	mov    %edx,(%eax)
  80272d:	8b 45 08             	mov    0x8(%ebp),%eax
  802730:	8b 00                	mov    (%eax),%eax
  802732:	85 c0                	test   %eax,%eax
  802734:	74 0b                	je     802741 <insert_sorted_allocList+0x1fd>
  802736:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802739:	8b 00                	mov    (%eax),%eax
  80273b:	8b 55 08             	mov    0x8(%ebp),%edx
  80273e:	89 50 04             	mov    %edx,0x4(%eax)
  802741:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802744:	8b 55 08             	mov    0x8(%ebp),%edx
  802747:	89 10                	mov    %edx,(%eax)
  802749:	8b 45 08             	mov    0x8(%ebp),%eax
  80274c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80274f:	89 50 04             	mov    %edx,0x4(%eax)
  802752:	8b 45 08             	mov    0x8(%ebp),%eax
  802755:	8b 00                	mov    (%eax),%eax
  802757:	85 c0                	test   %eax,%eax
  802759:	75 08                	jne    802763 <insert_sorted_allocList+0x21f>
  80275b:	8b 45 08             	mov    0x8(%ebp),%eax
  80275e:	a3 44 50 80 00       	mov    %eax,0x805044
  802763:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802768:	40                   	inc    %eax
  802769:	a3 4c 50 80 00       	mov    %eax,0x80504c
		break;
  80276e:	e9 ad 00 00 00       	jmp    802820 <insert_sorted_allocList+0x2dc>
	}else if (blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  802773:	8b 45 08             	mov    0x8(%ebp),%eax
  802776:	8b 50 08             	mov    0x8(%eax),%edx
  802779:	a1 44 50 80 00       	mov    0x805044,%eax
  80277e:	8b 40 08             	mov    0x8(%eax),%eax
  802781:	39 c2                	cmp    %eax,%edx
  802783:	76 65                	jbe    8027ea <insert_sorted_allocList+0x2a6>
	{
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
  802785:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802789:	75 17                	jne    8027a2 <insert_sorted_allocList+0x25e>
  80278b:	83 ec 04             	sub    $0x4,%esp
  80278e:	68 f8 41 80 00       	push   $0x8041f8
  802793:	68 80 00 00 00       	push   $0x80
  802798:	68 73 41 80 00       	push   $0x804173
  80279d:	e8 11 df ff ff       	call   8006b3 <_panic>
  8027a2:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8027a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ab:	89 50 04             	mov    %edx,0x4(%eax)
  8027ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b1:	8b 40 04             	mov    0x4(%eax),%eax
  8027b4:	85 c0                	test   %eax,%eax
  8027b6:	74 0c                	je     8027c4 <insert_sorted_allocList+0x280>
  8027b8:	a1 44 50 80 00       	mov    0x805044,%eax
  8027bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8027c0:	89 10                	mov    %edx,(%eax)
  8027c2:	eb 08                	jmp    8027cc <insert_sorted_allocList+0x288>
  8027c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c7:	a3 40 50 80 00       	mov    %eax,0x805040
  8027cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8027cf:	a3 44 50 80 00       	mov    %eax,0x805044
  8027d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027dd:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8027e2:	40                   	inc    %eax
  8027e3:	a3 4c 50 80 00       	mov    %eax,0x80504c
		break;
  8027e8:	eb 36                	jmp    802820 <insert_sorted_allocList+0x2dc>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  8027ea:	a1 48 50 80 00       	mov    0x805048,%eax
  8027ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027f6:	74 07                	je     8027ff <insert_sorted_allocList+0x2bb>
  8027f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fb:	8b 00                	mov    (%eax),%eax
  8027fd:	eb 05                	jmp    802804 <insert_sorted_allocList+0x2c0>
  8027ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802804:	a3 48 50 80 00       	mov    %eax,0x805048
  802809:	a1 48 50 80 00       	mov    0x805048,%eax
  80280e:	85 c0                	test   %eax,%eax
  802810:	0f 85 23 fe ff ff    	jne    802639 <insert_sorted_allocList+0xf5>
  802816:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80281a:	0f 85 19 fe ff ff    	jne    802639 <insert_sorted_allocList+0xf5>
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
		break;

	}
	}
}
  802820:	90                   	nop
  802821:	c9                   	leave  
  802822:	c3                   	ret    

00802823 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802823:	55                   	push   %ebp
  802824:	89 e5                	mov    %esp,%ebp
  802826:	83 ec 18             	sub    $0x18,%esp
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802829:	a1 38 51 80 00       	mov    0x805138,%eax
  80282e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802831:	e9 7c 01 00 00       	jmp    8029b2 <alloc_block_FF+0x18f>
		{
			// case 2
				if(element->size == size)
  802836:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802839:	8b 40 0c             	mov    0xc(%eax),%eax
  80283c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80283f:	0f 85 90 00 00 00    	jne    8028d5 <alloc_block_FF+0xb2>
				{
					tmp_block=element;
  802845:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802848:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,element);
  80284b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80284f:	75 17                	jne    802868 <alloc_block_FF+0x45>
  802851:	83 ec 04             	sub    $0x4,%esp
  802854:	68 1b 42 80 00       	push   $0x80421b
  802859:	68 ba 00 00 00       	push   $0xba
  80285e:	68 73 41 80 00       	push   $0x804173
  802863:	e8 4b de ff ff       	call   8006b3 <_panic>
  802868:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286b:	8b 00                	mov    (%eax),%eax
  80286d:	85 c0                	test   %eax,%eax
  80286f:	74 10                	je     802881 <alloc_block_FF+0x5e>
  802871:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802874:	8b 00                	mov    (%eax),%eax
  802876:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802879:	8b 52 04             	mov    0x4(%edx),%edx
  80287c:	89 50 04             	mov    %edx,0x4(%eax)
  80287f:	eb 0b                	jmp    80288c <alloc_block_FF+0x69>
  802881:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802884:	8b 40 04             	mov    0x4(%eax),%eax
  802887:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80288c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288f:	8b 40 04             	mov    0x4(%eax),%eax
  802892:	85 c0                	test   %eax,%eax
  802894:	74 0f                	je     8028a5 <alloc_block_FF+0x82>
  802896:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802899:	8b 40 04             	mov    0x4(%eax),%eax
  80289c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80289f:	8b 12                	mov    (%edx),%edx
  8028a1:	89 10                	mov    %edx,(%eax)
  8028a3:	eb 0a                	jmp    8028af <alloc_block_FF+0x8c>
  8028a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a8:	8b 00                	mov    (%eax),%eax
  8028aa:	a3 38 51 80 00       	mov    %eax,0x805138
  8028af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028c2:	a1 44 51 80 00       	mov    0x805144,%eax
  8028c7:	48                   	dec    %eax
  8028c8:	a3 44 51 80 00       	mov    %eax,0x805144
					return tmp_block;
  8028cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d0:	e9 10 01 00 00       	jmp    8029e5 <alloc_block_FF+0x1c2>
				}
				 // case 3
				else if(element->size > size)
  8028d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8028db:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028de:	0f 86 c6 00 00 00    	jbe    8029aa <alloc_block_FF+0x187>
				{
					// the new block are created
					tmp_block = AvailableMemBlocksList.lh_first ;
  8028e4:	a1 48 51 80 00       	mov    0x805148,%eax
  8028e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  8028ec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028f0:	75 17                	jne    802909 <alloc_block_FF+0xe6>
  8028f2:	83 ec 04             	sub    $0x4,%esp
  8028f5:	68 1b 42 80 00       	push   $0x80421b
  8028fa:	68 c2 00 00 00       	push   $0xc2
  8028ff:	68 73 41 80 00       	push   $0x804173
  802904:	e8 aa dd ff ff       	call   8006b3 <_panic>
  802909:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80290c:	8b 00                	mov    (%eax),%eax
  80290e:	85 c0                	test   %eax,%eax
  802910:	74 10                	je     802922 <alloc_block_FF+0xff>
  802912:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802915:	8b 00                	mov    (%eax),%eax
  802917:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80291a:	8b 52 04             	mov    0x4(%edx),%edx
  80291d:	89 50 04             	mov    %edx,0x4(%eax)
  802920:	eb 0b                	jmp    80292d <alloc_block_FF+0x10a>
  802922:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802925:	8b 40 04             	mov    0x4(%eax),%eax
  802928:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80292d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802930:	8b 40 04             	mov    0x4(%eax),%eax
  802933:	85 c0                	test   %eax,%eax
  802935:	74 0f                	je     802946 <alloc_block_FF+0x123>
  802937:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80293a:	8b 40 04             	mov    0x4(%eax),%eax
  80293d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802940:	8b 12                	mov    (%edx),%edx
  802942:	89 10                	mov    %edx,(%eax)
  802944:	eb 0a                	jmp    802950 <alloc_block_FF+0x12d>
  802946:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802949:	8b 00                	mov    (%eax),%eax
  80294b:	a3 48 51 80 00       	mov    %eax,0x805148
  802950:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802953:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802959:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80295c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802963:	a1 54 51 80 00       	mov    0x805154,%eax
  802968:	48                   	dec    %eax
  802969:	a3 54 51 80 00       	mov    %eax,0x805154
					tmp_block->sva=element->sva;
  80296e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802971:	8b 50 08             	mov    0x8(%eax),%edx
  802974:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802977:	89 50 08             	mov    %edx,0x8(%eax)
					tmp_block->size=size;
  80297a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80297d:	8b 55 08             	mov    0x8(%ebp),%edx
  802980:	89 50 0c             	mov    %edx,0xc(%eax)
					//update block with remaining space
					element->size-=size;
  802983:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802986:	8b 40 0c             	mov    0xc(%eax),%eax
  802989:	2b 45 08             	sub    0x8(%ebp),%eax
  80298c:	89 c2                	mov    %eax,%edx
  80298e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802991:	89 50 0c             	mov    %edx,0xc(%eax)
					element->sva = element->sva + size;
  802994:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802997:	8b 50 08             	mov    0x8(%eax),%edx
  80299a:	8b 45 08             	mov    0x8(%ebp),%eax
  80299d:	01 c2                	add    %eax,%edx
  80299f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a2:	89 50 08             	mov    %edx,0x8(%eax)
					// return back the new block
					return tmp_block ;
  8029a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a8:	eb 3b                	jmp    8029e5 <alloc_block_FF+0x1c2>
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  8029aa:	a1 40 51 80 00       	mov    0x805140,%eax
  8029af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029b6:	74 07                	je     8029bf <alloc_block_FF+0x19c>
  8029b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bb:	8b 00                	mov    (%eax),%eax
  8029bd:	eb 05                	jmp    8029c4 <alloc_block_FF+0x1a1>
  8029bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8029c4:	a3 40 51 80 00       	mov    %eax,0x805140
  8029c9:	a1 40 51 80 00       	mov    0x805140,%eax
  8029ce:	85 c0                	test   %eax,%eax
  8029d0:	0f 85 60 fe ff ff    	jne    802836 <alloc_block_FF+0x13>
  8029d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029da:	0f 85 56 fe ff ff    	jne    802836 <alloc_block_FF+0x13>
					// return back the new block
					return tmp_block ;
				}
		}
		// case 1
	  return NULL ;}
  8029e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8029e5:	c9                   	leave  
  8029e6:	c3                   	ret    

008029e7 <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================

struct MemBlock *alloc_block_BF(uint32 size)
{
  8029e7:	55                   	push   %ebp
  8029e8:	89 e5                	mov    %esp,%ebp
  8029ea:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
  8029ed:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		LIST_FOREACH(element, &(FreeMemBlocksList))
  8029f4:	a1 38 51 80 00       	mov    0x805138,%eax
  8029f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029fc:	eb 3a                	jmp    802a38 <alloc_block_BF+0x51>
		{
			if(element->size >= size)
  8029fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a01:	8b 40 0c             	mov    0xc(%eax),%eax
  802a04:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a07:	72 27                	jb     802a30 <alloc_block_BF+0x49>
			{
				if(best_size==-1)
  802a09:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802a0d:	75 0b                	jne    802a1a <alloc_block_BF+0x33>
					best_size= element->size;
  802a0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a12:	8b 40 0c             	mov    0xc(%eax),%eax
  802a15:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802a18:	eb 16                	jmp    802a30 <alloc_block_BF+0x49>
				else if(best_size >= element->size)
  802a1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1d:	8b 50 0c             	mov    0xc(%eax),%edx
  802a20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a23:	39 c2                	cmp    %eax,%edx
  802a25:	77 09                	ja     802a30 <alloc_block_BF+0x49>
					best_size=element->size;
  802a27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2a:	8b 40 0c             	mov    0xc(%eax),%eax
  802a2d:	89 45 f0             	mov    %eax,-0x10(%ebp)

struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802a30:	a1 40 51 80 00       	mov    0x805140,%eax
  802a35:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a38:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a3c:	74 07                	je     802a45 <alloc_block_BF+0x5e>
  802a3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a41:	8b 00                	mov    (%eax),%eax
  802a43:	eb 05                	jmp    802a4a <alloc_block_BF+0x63>
  802a45:	b8 00 00 00 00       	mov    $0x0,%eax
  802a4a:	a3 40 51 80 00       	mov    %eax,0x805140
  802a4f:	a1 40 51 80 00       	mov    0x805140,%eax
  802a54:	85 c0                	test   %eax,%eax
  802a56:	75 a6                	jne    8029fe <alloc_block_BF+0x17>
  802a58:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a5c:	75 a0                	jne    8029fe <alloc_block_BF+0x17>
					best_size= element->size;
				else if(best_size >= element->size)
					best_size=element->size;
			}
		}
		if(best_size != -1)
  802a5e:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802a62:	0f 84 d3 01 00 00    	je     802c3b <alloc_block_BF+0x254>
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  802a68:	a1 38 51 80 00       	mov    0x805138,%eax
  802a6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a70:	e9 98 01 00 00       	jmp    802c0d <alloc_block_BF+0x226>
			{
			 if((best_size > size) && (best_size == element->size))
  802a75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a78:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a7b:	0f 86 da 00 00 00    	jbe    802b5b <alloc_block_BF+0x174>
  802a81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a84:	8b 50 0c             	mov    0xc(%eax),%edx
  802a87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a8a:	39 c2                	cmp    %eax,%edx
  802a8c:	0f 85 c9 00 00 00    	jne    802b5b <alloc_block_BF+0x174>
			  {
				// the new block are created
			    tmp_block = AvailableMemBlocksList.lh_first ;
  802a92:	a1 48 51 80 00       	mov    0x805148,%eax
  802a97:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  802a9a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a9e:	75 17                	jne    802ab7 <alloc_block_BF+0xd0>
  802aa0:	83 ec 04             	sub    $0x4,%esp
  802aa3:	68 1b 42 80 00       	push   $0x80421b
  802aa8:	68 ea 00 00 00       	push   $0xea
  802aad:	68 73 41 80 00       	push   $0x804173
  802ab2:	e8 fc db ff ff       	call   8006b3 <_panic>
  802ab7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aba:	8b 00                	mov    (%eax),%eax
  802abc:	85 c0                	test   %eax,%eax
  802abe:	74 10                	je     802ad0 <alloc_block_BF+0xe9>
  802ac0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ac3:	8b 00                	mov    (%eax),%eax
  802ac5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ac8:	8b 52 04             	mov    0x4(%edx),%edx
  802acb:	89 50 04             	mov    %edx,0x4(%eax)
  802ace:	eb 0b                	jmp    802adb <alloc_block_BF+0xf4>
  802ad0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ad3:	8b 40 04             	mov    0x4(%eax),%eax
  802ad6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802adb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ade:	8b 40 04             	mov    0x4(%eax),%eax
  802ae1:	85 c0                	test   %eax,%eax
  802ae3:	74 0f                	je     802af4 <alloc_block_BF+0x10d>
  802ae5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ae8:	8b 40 04             	mov    0x4(%eax),%eax
  802aeb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802aee:	8b 12                	mov    (%edx),%edx
  802af0:	89 10                	mov    %edx,(%eax)
  802af2:	eb 0a                	jmp    802afe <alloc_block_BF+0x117>
  802af4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802af7:	8b 00                	mov    (%eax),%eax
  802af9:	a3 48 51 80 00       	mov    %eax,0x805148
  802afe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b01:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b07:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b0a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b11:	a1 54 51 80 00       	mov    0x805154,%eax
  802b16:	48                   	dec    %eax
  802b17:	a3 54 51 80 00       	mov    %eax,0x805154
				tmp_block->sva=element->sva;
  802b1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1f:	8b 50 08             	mov    0x8(%eax),%edx
  802b22:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b25:	89 50 08             	mov    %edx,0x8(%eax)
				tmp_block->size=size;
  802b28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b2b:	8b 55 08             	mov    0x8(%ebp),%edx
  802b2e:	89 50 0c             	mov    %edx,0xc(%eax)
				//update block with remaining space
				element->size-=size;
  802b31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b34:	8b 40 0c             	mov    0xc(%eax),%eax
  802b37:	2b 45 08             	sub    0x8(%ebp),%eax
  802b3a:	89 c2                	mov    %eax,%edx
  802b3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3f:	89 50 0c             	mov    %edx,0xc(%eax)
				element->sva = element->sva + size;
  802b42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b45:	8b 50 08             	mov    0x8(%eax),%edx
  802b48:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4b:	01 c2                	add    %eax,%edx
  802b4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b50:	89 50 08             	mov    %edx,0x8(%eax)
				// return back the new block
				return tmp_block ;
  802b53:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b56:	e9 e5 00 00 00       	jmp    802c40 <alloc_block_BF+0x259>

			  }
			else if((element->size == best_size)&&(best_size == size))
  802b5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5e:	8b 50 0c             	mov    0xc(%eax),%edx
  802b61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b64:	39 c2                	cmp    %eax,%edx
  802b66:	0f 85 99 00 00 00    	jne    802c05 <alloc_block_BF+0x21e>
  802b6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b6f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b72:	0f 85 8d 00 00 00    	jne    802c05 <alloc_block_BF+0x21e>
			  {
				tmp_block=element;
  802b78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7b:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&FreeMemBlocksList,element);
  802b7e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b82:	75 17                	jne    802b9b <alloc_block_BF+0x1b4>
  802b84:	83 ec 04             	sub    $0x4,%esp
  802b87:	68 1b 42 80 00       	push   $0x80421b
  802b8c:	68 f7 00 00 00       	push   $0xf7
  802b91:	68 73 41 80 00       	push   $0x804173
  802b96:	e8 18 db ff ff       	call   8006b3 <_panic>
  802b9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9e:	8b 00                	mov    (%eax),%eax
  802ba0:	85 c0                	test   %eax,%eax
  802ba2:	74 10                	je     802bb4 <alloc_block_BF+0x1cd>
  802ba4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba7:	8b 00                	mov    (%eax),%eax
  802ba9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bac:	8b 52 04             	mov    0x4(%edx),%edx
  802baf:	89 50 04             	mov    %edx,0x4(%eax)
  802bb2:	eb 0b                	jmp    802bbf <alloc_block_BF+0x1d8>
  802bb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb7:	8b 40 04             	mov    0x4(%eax),%eax
  802bba:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802bbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc2:	8b 40 04             	mov    0x4(%eax),%eax
  802bc5:	85 c0                	test   %eax,%eax
  802bc7:	74 0f                	je     802bd8 <alloc_block_BF+0x1f1>
  802bc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcc:	8b 40 04             	mov    0x4(%eax),%eax
  802bcf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bd2:	8b 12                	mov    (%edx),%edx
  802bd4:	89 10                	mov    %edx,(%eax)
  802bd6:	eb 0a                	jmp    802be2 <alloc_block_BF+0x1fb>
  802bd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bdb:	8b 00                	mov    (%eax),%eax
  802bdd:	a3 38 51 80 00       	mov    %eax,0x805138
  802be2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802beb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bf5:	a1 44 51 80 00       	mov    0x805144,%eax
  802bfa:	48                   	dec    %eax
  802bfb:	a3 44 51 80 00       	mov    %eax,0x805144
				return tmp_block;
  802c00:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c03:	eb 3b                	jmp    802c40 <alloc_block_BF+0x259>
					best_size=element->size;
			}
		}
		if(best_size != -1)
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  802c05:	a1 40 51 80 00       	mov    0x805140,%eax
  802c0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c0d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c11:	74 07                	je     802c1a <alloc_block_BF+0x233>
  802c13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c16:	8b 00                	mov    (%eax),%eax
  802c18:	eb 05                	jmp    802c1f <alloc_block_BF+0x238>
  802c1a:	b8 00 00 00 00       	mov    $0x0,%eax
  802c1f:	a3 40 51 80 00       	mov    %eax,0x805140
  802c24:	a1 40 51 80 00       	mov    0x805140,%eax
  802c29:	85 c0                	test   %eax,%eax
  802c2b:	0f 85 44 fe ff ff    	jne    802a75 <alloc_block_BF+0x8e>
  802c31:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c35:	0f 85 3a fe ff ff    	jne    802a75 <alloc_block_BF+0x8e>
				LIST_REMOVE(&FreeMemBlocksList,element);
				return tmp_block;
			 }
			}
		}
		return NULL ;}
  802c3b:	b8 00 00 00 00       	mov    $0x0,%eax
  802c40:	c9                   	leave  
  802c41:	c3                   	ret    

00802c42 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802c42:	55                   	push   %ebp
  802c43:	89 e5                	mov    %esp,%ebp
  802c45:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802c48:	83 ec 04             	sub    $0x4,%esp
  802c4b:	68 3c 42 80 00       	push   $0x80423c
  802c50:	68 04 01 00 00       	push   $0x104
  802c55:	68 73 41 80 00       	push   $0x804173
  802c5a:	e8 54 da ff ff       	call   8006b3 <_panic>

00802c5f <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{struct MemBlock * blk_itr;
  802c5f:	55                   	push   %ebp
  802c60:	89 e5                	mov    %esp,%ebp
  802c62:	83 ec 18             	sub    $0x18,%esp
struct MemBlock * next;
struct MemBlock * first = LIST_FIRST(&(FreeMemBlocksList));
  802c65:	a1 38 51 80 00       	mov    0x805138,%eax
  802c6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
struct MemBlock * last = LIST_LAST(&(FreeMemBlocksList));
  802c6d:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802c72:	89 45 ec             	mov    %eax,-0x14(%ebp)

if(LIST_EMPTY(&(FreeMemBlocksList)))
  802c75:	a1 38 51 80 00       	mov    0x805138,%eax
  802c7a:	85 c0                	test   %eax,%eax
  802c7c:	75 68                	jne    802ce6 <insert_sorted_with_merge_freeList+0x87>
			{

				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  802c7e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c82:	75 17                	jne    802c9b <insert_sorted_with_merge_freeList+0x3c>
  802c84:	83 ec 04             	sub    $0x4,%esp
  802c87:	68 50 41 80 00       	push   $0x804150
  802c8c:	68 14 01 00 00       	push   $0x114
  802c91:	68 73 41 80 00       	push   $0x804173
  802c96:	e8 18 da ff ff       	call   8006b3 <_panic>
  802c9b:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802ca1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca4:	89 10                	mov    %edx,(%eax)
  802ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca9:	8b 00                	mov    (%eax),%eax
  802cab:	85 c0                	test   %eax,%eax
  802cad:	74 0d                	je     802cbc <insert_sorted_with_merge_freeList+0x5d>
  802caf:	a1 38 51 80 00       	mov    0x805138,%eax
  802cb4:	8b 55 08             	mov    0x8(%ebp),%edx
  802cb7:	89 50 04             	mov    %edx,0x4(%eax)
  802cba:	eb 08                	jmp    802cc4 <insert_sorted_with_merge_freeList+0x65>
  802cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbf:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc7:	a3 38 51 80 00       	mov    %eax,0x805138
  802ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ccf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cd6:	a1 44 51 80 00       	mov    0x805144,%eax
  802cdb:	40                   	inc    %eax
  802cdc:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  802ce1:	e9 d2 06 00 00       	jmp    8033b8 <insert_sorted_with_merge_freeList+0x759>
				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);

			}
else
{
	if( blockToInsert->sva  < first->sva )
  802ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce9:	8b 50 08             	mov    0x8(%eax),%edx
  802cec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cef:	8b 40 08             	mov    0x8(%eax),%eax
  802cf2:	39 c2                	cmp    %eax,%edx
  802cf4:	0f 83 22 01 00 00    	jae    802e1c <insert_sorted_with_merge_freeList+0x1bd>
	{
                if( blockToInsert->sva + blockToInsert->size == first->sva)
  802cfa:	8b 45 08             	mov    0x8(%ebp),%eax
  802cfd:	8b 50 08             	mov    0x8(%eax),%edx
  802d00:	8b 45 08             	mov    0x8(%ebp),%eax
  802d03:	8b 40 0c             	mov    0xc(%eax),%eax
  802d06:	01 c2                	add    %eax,%edx
  802d08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d0b:	8b 40 08             	mov    0x8(%eax),%eax
  802d0e:	39 c2                	cmp    %eax,%edx
  802d10:	0f 85 9e 00 00 00    	jne    802db4 <insert_sorted_with_merge_freeList+0x155>
                {

                	first->sva = blockToInsert->sva;
  802d16:	8b 45 08             	mov    0x8(%ebp),%eax
  802d19:	8b 50 08             	mov    0x8(%eax),%edx
  802d1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d1f:	89 50 08             	mov    %edx,0x8(%eax)
                	first->size = first->size + blockToInsert->size;
  802d22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d25:	8b 50 0c             	mov    0xc(%eax),%edx
  802d28:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2b:	8b 40 0c             	mov    0xc(%eax),%eax
  802d2e:	01 c2                	add    %eax,%edx
  802d30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d33:	89 50 0c             	mov    %edx,0xc(%eax)
                	blockToInsert->size = blockToInsert->sva = 0;
  802d36:	8b 45 08             	mov    0x8(%ebp),%eax
  802d39:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802d40:	8b 45 08             	mov    0x8(%ebp),%eax
  802d43:	8b 50 08             	mov    0x8(%eax),%edx
  802d46:	8b 45 08             	mov    0x8(%ebp),%eax
  802d49:	89 50 0c             	mov    %edx,0xc(%eax)
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802d4c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d50:	75 17                	jne    802d69 <insert_sorted_with_merge_freeList+0x10a>
  802d52:	83 ec 04             	sub    $0x4,%esp
  802d55:	68 50 41 80 00       	push   $0x804150
  802d5a:	68 21 01 00 00       	push   $0x121
  802d5f:	68 73 41 80 00       	push   $0x804173
  802d64:	e8 4a d9 ff ff       	call   8006b3 <_panic>
  802d69:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d72:	89 10                	mov    %edx,(%eax)
  802d74:	8b 45 08             	mov    0x8(%ebp),%eax
  802d77:	8b 00                	mov    (%eax),%eax
  802d79:	85 c0                	test   %eax,%eax
  802d7b:	74 0d                	je     802d8a <insert_sorted_with_merge_freeList+0x12b>
  802d7d:	a1 48 51 80 00       	mov    0x805148,%eax
  802d82:	8b 55 08             	mov    0x8(%ebp),%edx
  802d85:	89 50 04             	mov    %edx,0x4(%eax)
  802d88:	eb 08                	jmp    802d92 <insert_sorted_with_merge_freeList+0x133>
  802d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d92:	8b 45 08             	mov    0x8(%ebp),%eax
  802d95:	a3 48 51 80 00       	mov    %eax,0x805148
  802d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802da4:	a1 54 51 80 00       	mov    0x805154,%eax
  802da9:	40                   	inc    %eax
  802daa:	a3 54 51 80 00       	mov    %eax,0x805154
						}
				}
        }

}
}
  802daf:	e9 04 06 00 00       	jmp    8033b8 <insert_sorted_with_merge_freeList+0x759>
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
                }

                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  802db4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802db8:	75 17                	jne    802dd1 <insert_sorted_with_merge_freeList+0x172>
  802dba:	83 ec 04             	sub    $0x4,%esp
  802dbd:	68 50 41 80 00       	push   $0x804150
  802dc2:	68 26 01 00 00       	push   $0x126
  802dc7:	68 73 41 80 00       	push   $0x804173
  802dcc:	e8 e2 d8 ff ff       	call   8006b3 <_panic>
  802dd1:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dda:	89 10                	mov    %edx,(%eax)
  802ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddf:	8b 00                	mov    (%eax),%eax
  802de1:	85 c0                	test   %eax,%eax
  802de3:	74 0d                	je     802df2 <insert_sorted_with_merge_freeList+0x193>
  802de5:	a1 38 51 80 00       	mov    0x805138,%eax
  802dea:	8b 55 08             	mov    0x8(%ebp),%edx
  802ded:	89 50 04             	mov    %edx,0x4(%eax)
  802df0:	eb 08                	jmp    802dfa <insert_sorted_with_merge_freeList+0x19b>
  802df2:	8b 45 08             	mov    0x8(%ebp),%eax
  802df5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfd:	a3 38 51 80 00       	mov    %eax,0x805138
  802e02:	8b 45 08             	mov    0x8(%ebp),%eax
  802e05:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e0c:	a1 44 51 80 00       	mov    0x805144,%eax
  802e11:	40                   	inc    %eax
  802e12:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  802e17:	e9 9c 05 00 00       	jmp    8033b8 <insert_sorted_with_merge_freeList+0x759>
                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
                }
	}
    else if(blockToInsert->sva > last->sva)
  802e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1f:	8b 50 08             	mov    0x8(%eax),%edx
  802e22:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e25:	8b 40 08             	mov    0x8(%eax),%eax
  802e28:	39 c2                	cmp    %eax,%edx
  802e2a:	0f 86 16 01 00 00    	jbe    802f46 <insert_sorted_with_merge_freeList+0x2e7>
 	{

				if(last->sva + last->size == blockToInsert->sva)
  802e30:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e33:	8b 50 08             	mov    0x8(%eax),%edx
  802e36:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e39:	8b 40 0c             	mov    0xc(%eax),%eax
  802e3c:	01 c2                	add    %eax,%edx
  802e3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e41:	8b 40 08             	mov    0x8(%eax),%eax
  802e44:	39 c2                	cmp    %eax,%edx
  802e46:	0f 85 92 00 00 00    	jne    802ede <insert_sorted_with_merge_freeList+0x27f>
				{

					last->size = last->size + blockToInsert->size;
  802e4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e4f:	8b 50 0c             	mov    0xc(%eax),%edx
  802e52:	8b 45 08             	mov    0x8(%ebp),%eax
  802e55:	8b 40 0c             	mov    0xc(%eax),%eax
  802e58:	01 c2                	add    %eax,%edx
  802e5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e5d:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->size = blockToInsert->sva = 0;
  802e60:	8b 45 08             	mov    0x8(%ebp),%eax
  802e63:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6d:	8b 50 08             	mov    0x8(%eax),%edx
  802e70:	8b 45 08             	mov    0x8(%ebp),%eax
  802e73:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802e76:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e7a:	75 17                	jne    802e93 <insert_sorted_with_merge_freeList+0x234>
  802e7c:	83 ec 04             	sub    $0x4,%esp
  802e7f:	68 50 41 80 00       	push   $0x804150
  802e84:	68 31 01 00 00       	push   $0x131
  802e89:	68 73 41 80 00       	push   $0x804173
  802e8e:	e8 20 d8 ff ff       	call   8006b3 <_panic>
  802e93:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e99:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9c:	89 10                	mov    %edx,(%eax)
  802e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea1:	8b 00                	mov    (%eax),%eax
  802ea3:	85 c0                	test   %eax,%eax
  802ea5:	74 0d                	je     802eb4 <insert_sorted_with_merge_freeList+0x255>
  802ea7:	a1 48 51 80 00       	mov    0x805148,%eax
  802eac:	8b 55 08             	mov    0x8(%ebp),%edx
  802eaf:	89 50 04             	mov    %edx,0x4(%eax)
  802eb2:	eb 08                	jmp    802ebc <insert_sorted_with_merge_freeList+0x25d>
  802eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebf:	a3 48 51 80 00       	mov    %eax,0x805148
  802ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ece:	a1 54 51 80 00       	mov    0x805154,%eax
  802ed3:	40                   	inc    %eax
  802ed4:	a3 54 51 80 00       	mov    %eax,0x805154
						}
				}
        }

}
}
  802ed9:	e9 da 04 00 00       	jmp    8033b8 <insert_sorted_with_merge_freeList+0x759>

				}

				else
				{
					LIST_INSERT_TAIL(&(FreeMemBlocksList),  blockToInsert);
  802ede:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ee2:	75 17                	jne    802efb <insert_sorted_with_merge_freeList+0x29c>
  802ee4:	83 ec 04             	sub    $0x4,%esp
  802ee7:	68 f8 41 80 00       	push   $0x8041f8
  802eec:	68 37 01 00 00       	push   $0x137
  802ef1:	68 73 41 80 00       	push   $0x804173
  802ef6:	e8 b8 d7 ff ff       	call   8006b3 <_panic>
  802efb:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802f01:	8b 45 08             	mov    0x8(%ebp),%eax
  802f04:	89 50 04             	mov    %edx,0x4(%eax)
  802f07:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0a:	8b 40 04             	mov    0x4(%eax),%eax
  802f0d:	85 c0                	test   %eax,%eax
  802f0f:	74 0c                	je     802f1d <insert_sorted_with_merge_freeList+0x2be>
  802f11:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f16:	8b 55 08             	mov    0x8(%ebp),%edx
  802f19:	89 10                	mov    %edx,(%eax)
  802f1b:	eb 08                	jmp    802f25 <insert_sorted_with_merge_freeList+0x2c6>
  802f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f20:	a3 38 51 80 00       	mov    %eax,0x805138
  802f25:	8b 45 08             	mov    0x8(%ebp),%eax
  802f28:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f30:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f36:	a1 44 51 80 00       	mov    0x805144,%eax
  802f3b:	40                   	inc    %eax
  802f3c:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  802f41:	e9 72 04 00 00       	jmp    8033b8 <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  802f46:	a1 38 51 80 00       	mov    0x805138,%eax
  802f4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f4e:	e9 35 04 00 00       	jmp    803388 <insert_sorted_with_merge_freeList+0x729>
				{
				     next=LIST_NEXT(blk_itr);
  802f53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f56:	8b 00                	mov    (%eax),%eax
  802f58:	89 45 e8             	mov    %eax,-0x18(%ebp)


					if( (blockToInsert->sva > blk_itr->sva) )
  802f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5e:	8b 50 08             	mov    0x8(%eax),%edx
  802f61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f64:	8b 40 08             	mov    0x8(%eax),%eax
  802f67:	39 c2                	cmp    %eax,%edx
  802f69:	0f 86 11 04 00 00    	jbe    803380 <insert_sorted_with_merge_freeList+0x721>
						{
							if(((blk_itr->sva) + (blk_itr->size) < blockToInsert->sva && (blockToInsert->sva) + (blockToInsert->size) < next->sva))
  802f6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f72:	8b 50 08             	mov    0x8(%eax),%edx
  802f75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f78:	8b 40 0c             	mov    0xc(%eax),%eax
  802f7b:	01 c2                	add    %eax,%edx
  802f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f80:	8b 40 08             	mov    0x8(%eax),%eax
  802f83:	39 c2                	cmp    %eax,%edx
  802f85:	0f 83 8b 00 00 00    	jae    803016 <insert_sorted_with_merge_freeList+0x3b7>
  802f8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8e:	8b 50 08             	mov    0x8(%eax),%edx
  802f91:	8b 45 08             	mov    0x8(%ebp),%eax
  802f94:	8b 40 0c             	mov    0xc(%eax),%eax
  802f97:	01 c2                	add    %eax,%edx
  802f99:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f9c:	8b 40 08             	mov    0x8(%eax),%eax
  802f9f:	39 c2                	cmp    %eax,%edx
  802fa1:	73 73                	jae    803016 <insert_sorted_with_merge_freeList+0x3b7>
							{
								LIST_INSERT_AFTER(&(FreeMemBlocksList), blk_itr, blockToInsert);
  802fa3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fa7:	74 06                	je     802faf <insert_sorted_with_merge_freeList+0x350>
  802fa9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fad:	75 17                	jne    802fc6 <insert_sorted_with_merge_freeList+0x367>
  802faf:	83 ec 04             	sub    $0x4,%esp
  802fb2:	68 c4 41 80 00       	push   $0x8041c4
  802fb7:	68 48 01 00 00       	push   $0x148
  802fbc:	68 73 41 80 00       	push   $0x804173
  802fc1:	e8 ed d6 ff ff       	call   8006b3 <_panic>
  802fc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc9:	8b 10                	mov    (%eax),%edx
  802fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fce:	89 10                	mov    %edx,(%eax)
  802fd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd3:	8b 00                	mov    (%eax),%eax
  802fd5:	85 c0                	test   %eax,%eax
  802fd7:	74 0b                	je     802fe4 <insert_sorted_with_merge_freeList+0x385>
  802fd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fdc:	8b 00                	mov    (%eax),%eax
  802fde:	8b 55 08             	mov    0x8(%ebp),%edx
  802fe1:	89 50 04             	mov    %edx,0x4(%eax)
  802fe4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe7:	8b 55 08             	mov    0x8(%ebp),%edx
  802fea:	89 10                	mov    %edx,(%eax)
  802fec:	8b 45 08             	mov    0x8(%ebp),%eax
  802fef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ff2:	89 50 04             	mov    %edx,0x4(%eax)
  802ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff8:	8b 00                	mov    (%eax),%eax
  802ffa:	85 c0                	test   %eax,%eax
  802ffc:	75 08                	jne    803006 <insert_sorted_with_merge_freeList+0x3a7>
  802ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  803001:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803006:	a1 44 51 80 00       	mov    0x805144,%eax
  80300b:	40                   	inc    %eax
  80300c:	a3 44 51 80 00       	mov    %eax,0x805144
								break;
  803011:	e9 a2 03 00 00       	jmp    8033b8 <insert_sorted_with_merge_freeList+0x759>

							}
							else if((blockToInsert->sva + blockToInsert->size) < next->sva  && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  803016:	8b 45 08             	mov    0x8(%ebp),%eax
  803019:	8b 50 08             	mov    0x8(%eax),%edx
  80301c:	8b 45 08             	mov    0x8(%ebp),%eax
  80301f:	8b 40 0c             	mov    0xc(%eax),%eax
  803022:	01 c2                	add    %eax,%edx
  803024:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803027:	8b 40 08             	mov    0x8(%eax),%eax
  80302a:	39 c2                	cmp    %eax,%edx
  80302c:	0f 83 ae 00 00 00    	jae    8030e0 <insert_sorted_with_merge_freeList+0x481>
  803032:	8b 45 08             	mov    0x8(%ebp),%eax
  803035:	8b 50 08             	mov    0x8(%eax),%edx
  803038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303b:	8b 48 08             	mov    0x8(%eax),%ecx
  80303e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803041:	8b 40 0c             	mov    0xc(%eax),%eax
  803044:	01 c8                	add    %ecx,%eax
  803046:	39 c2                	cmp    %eax,%edx
  803048:	0f 85 92 00 00 00    	jne    8030e0 <insert_sorted_with_merge_freeList+0x481>
							{

								blk_itr->size=blk_itr->size+blockToInsert->size;
  80304e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803051:	8b 50 0c             	mov    0xc(%eax),%edx
  803054:	8b 45 08             	mov    0x8(%ebp),%eax
  803057:	8b 40 0c             	mov    0xc(%eax),%eax
  80305a:	01 c2                	add    %eax,%edx
  80305c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305f:	89 50 0c             	mov    %edx,0xc(%eax)
								 blockToInsert->size=blockToInsert->sva=0;
  803062:	8b 45 08             	mov    0x8(%ebp),%eax
  803065:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80306c:	8b 45 08             	mov    0x8(%ebp),%eax
  80306f:	8b 50 08             	mov    0x8(%eax),%edx
  803072:	8b 45 08             	mov    0x8(%ebp),%eax
  803075:	89 50 0c             	mov    %edx,0xc(%eax)
								 LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  803078:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80307c:	75 17                	jne    803095 <insert_sorted_with_merge_freeList+0x436>
  80307e:	83 ec 04             	sub    $0x4,%esp
  803081:	68 50 41 80 00       	push   $0x804150
  803086:	68 51 01 00 00       	push   $0x151
  80308b:	68 73 41 80 00       	push   $0x804173
  803090:	e8 1e d6 ff ff       	call   8006b3 <_panic>
  803095:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80309b:	8b 45 08             	mov    0x8(%ebp),%eax
  80309e:	89 10                	mov    %edx,(%eax)
  8030a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a3:	8b 00                	mov    (%eax),%eax
  8030a5:	85 c0                	test   %eax,%eax
  8030a7:	74 0d                	je     8030b6 <insert_sorted_with_merge_freeList+0x457>
  8030a9:	a1 48 51 80 00       	mov    0x805148,%eax
  8030ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8030b1:	89 50 04             	mov    %edx,0x4(%eax)
  8030b4:	eb 08                	jmp    8030be <insert_sorted_with_merge_freeList+0x45f>
  8030b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030be:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c1:	a3 48 51 80 00       	mov    %eax,0x805148
  8030c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030d0:	a1 54 51 80 00       	mov    0x805154,%eax
  8030d5:	40                   	inc    %eax
  8030d6:	a3 54 51 80 00       	mov    %eax,0x805154
								 break;
  8030db:	e9 d8 02 00 00       	jmp    8033b8 <insert_sorted_with_merge_freeList+0x759>

							}
							else if( (blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva > (blk_itr->sva + blk_itr->size))
  8030e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e3:	8b 50 08             	mov    0x8(%eax),%edx
  8030e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8030ec:	01 c2                	add    %eax,%edx
  8030ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f1:	8b 40 08             	mov    0x8(%eax),%eax
  8030f4:	39 c2                	cmp    %eax,%edx
  8030f6:	0f 85 ba 00 00 00    	jne    8031b6 <insert_sorted_with_merge_freeList+0x557>
  8030fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ff:	8b 50 08             	mov    0x8(%eax),%edx
  803102:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803105:	8b 48 08             	mov    0x8(%eax),%ecx
  803108:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80310b:	8b 40 0c             	mov    0xc(%eax),%eax
  80310e:	01 c8                	add    %ecx,%eax
  803110:	39 c2                	cmp    %eax,%edx
  803112:	0f 86 9e 00 00 00    	jbe    8031b6 <insert_sorted_with_merge_freeList+0x557>
							{
								next->size = next->size + blockToInsert->size;
  803118:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80311b:	8b 50 0c             	mov    0xc(%eax),%edx
  80311e:	8b 45 08             	mov    0x8(%ebp),%eax
  803121:	8b 40 0c             	mov    0xc(%eax),%eax
  803124:	01 c2                	add    %eax,%edx
  803126:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803129:	89 50 0c             	mov    %edx,0xc(%eax)
								next->sva = blockToInsert->sva;
  80312c:	8b 45 08             	mov    0x8(%ebp),%eax
  80312f:	8b 50 08             	mov    0x8(%eax),%edx
  803132:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803135:	89 50 08             	mov    %edx,0x8(%eax)

								blockToInsert->size = blockToInsert->sva = 0;
  803138:	8b 45 08             	mov    0x8(%ebp),%eax
  80313b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803142:	8b 45 08             	mov    0x8(%ebp),%eax
  803145:	8b 50 08             	mov    0x8(%eax),%edx
  803148:	8b 45 08             	mov    0x8(%ebp),%eax
  80314b:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  80314e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803152:	75 17                	jne    80316b <insert_sorted_with_merge_freeList+0x50c>
  803154:	83 ec 04             	sub    $0x4,%esp
  803157:	68 50 41 80 00       	push   $0x804150
  80315c:	68 5b 01 00 00       	push   $0x15b
  803161:	68 73 41 80 00       	push   $0x804173
  803166:	e8 48 d5 ff ff       	call   8006b3 <_panic>
  80316b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803171:	8b 45 08             	mov    0x8(%ebp),%eax
  803174:	89 10                	mov    %edx,(%eax)
  803176:	8b 45 08             	mov    0x8(%ebp),%eax
  803179:	8b 00                	mov    (%eax),%eax
  80317b:	85 c0                	test   %eax,%eax
  80317d:	74 0d                	je     80318c <insert_sorted_with_merge_freeList+0x52d>
  80317f:	a1 48 51 80 00       	mov    0x805148,%eax
  803184:	8b 55 08             	mov    0x8(%ebp),%edx
  803187:	89 50 04             	mov    %edx,0x4(%eax)
  80318a:	eb 08                	jmp    803194 <insert_sorted_with_merge_freeList+0x535>
  80318c:	8b 45 08             	mov    0x8(%ebp),%eax
  80318f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803194:	8b 45 08             	mov    0x8(%ebp),%eax
  803197:	a3 48 51 80 00       	mov    %eax,0x805148
  80319c:	8b 45 08             	mov    0x8(%ebp),%eax
  80319f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031a6:	a1 54 51 80 00       	mov    0x805154,%eax
  8031ab:	40                   	inc    %eax
  8031ac:	a3 54 51 80 00       	mov    %eax,0x805154
								break;
  8031b1:	e9 02 02 00 00       	jmp    8033b8 <insert_sorted_with_merge_freeList+0x759>
							}
							else if ((blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  8031b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b9:	8b 50 08             	mov    0x8(%eax),%edx
  8031bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8031bf:	8b 40 0c             	mov    0xc(%eax),%eax
  8031c2:	01 c2                	add    %eax,%edx
  8031c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c7:	8b 40 08             	mov    0x8(%eax),%eax
  8031ca:	39 c2                	cmp    %eax,%edx
  8031cc:	0f 85 ae 01 00 00    	jne    803380 <insert_sorted_with_merge_freeList+0x721>
  8031d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d5:	8b 50 08             	mov    0x8(%eax),%edx
  8031d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031db:	8b 48 08             	mov    0x8(%eax),%ecx
  8031de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8031e4:	01 c8                	add    %ecx,%eax
  8031e6:	39 c2                	cmp    %eax,%edx
  8031e8:	0f 85 92 01 00 00    	jne    803380 <insert_sorted_with_merge_freeList+0x721>
							{
								blk_itr->size = blk_itr->size + blockToInsert->size + next->size;
  8031ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f1:	8b 50 0c             	mov    0xc(%eax),%edx
  8031f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8031fa:	01 c2                	add    %eax,%edx
  8031fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ff:	8b 40 0c             	mov    0xc(%eax),%eax
  803202:	01 c2                	add    %eax,%edx
  803204:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803207:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size = blockToInsert->sva=0;
  80320a:	8b 45 08             	mov    0x8(%ebp),%eax
  80320d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803214:	8b 45 08             	mov    0x8(%ebp),%eax
  803217:	8b 50 08             	mov    0x8(%eax),%edx
  80321a:	8b 45 08             	mov    0x8(%ebp),%eax
  80321d:	89 50 0c             	mov    %edx,0xc(%eax)
								next->size = next->sva = 0;
  803220:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803223:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80322a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80322d:	8b 50 08             	mov    0x8(%eax),%edx
  803230:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803233:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_REMOVE(&FreeMemBlocksList, next);
  803236:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80323a:	75 17                	jne    803253 <insert_sorted_with_merge_freeList+0x5f4>
  80323c:	83 ec 04             	sub    $0x4,%esp
  80323f:	68 1b 42 80 00       	push   $0x80421b
  803244:	68 63 01 00 00       	push   $0x163
  803249:	68 73 41 80 00       	push   $0x804173
  80324e:	e8 60 d4 ff ff       	call   8006b3 <_panic>
  803253:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803256:	8b 00                	mov    (%eax),%eax
  803258:	85 c0                	test   %eax,%eax
  80325a:	74 10                	je     80326c <insert_sorted_with_merge_freeList+0x60d>
  80325c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80325f:	8b 00                	mov    (%eax),%eax
  803261:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803264:	8b 52 04             	mov    0x4(%edx),%edx
  803267:	89 50 04             	mov    %edx,0x4(%eax)
  80326a:	eb 0b                	jmp    803277 <insert_sorted_with_merge_freeList+0x618>
  80326c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80326f:	8b 40 04             	mov    0x4(%eax),%eax
  803272:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803277:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80327a:	8b 40 04             	mov    0x4(%eax),%eax
  80327d:	85 c0                	test   %eax,%eax
  80327f:	74 0f                	je     803290 <insert_sorted_with_merge_freeList+0x631>
  803281:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803284:	8b 40 04             	mov    0x4(%eax),%eax
  803287:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80328a:	8b 12                	mov    (%edx),%edx
  80328c:	89 10                	mov    %edx,(%eax)
  80328e:	eb 0a                	jmp    80329a <insert_sorted_with_merge_freeList+0x63b>
  803290:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803293:	8b 00                	mov    (%eax),%eax
  803295:	a3 38 51 80 00       	mov    %eax,0x805138
  80329a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80329d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032ad:	a1 44 51 80 00       	mov    0x805144,%eax
  8032b2:	48                   	dec    %eax
  8032b3:	a3 44 51 80 00       	mov    %eax,0x805144
								LIST_INSERT_HEAD(&AvailableMemBlocksList, next );
  8032b8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032bc:	75 17                	jne    8032d5 <insert_sorted_with_merge_freeList+0x676>
  8032be:	83 ec 04             	sub    $0x4,%esp
  8032c1:	68 50 41 80 00       	push   $0x804150
  8032c6:	68 64 01 00 00       	push   $0x164
  8032cb:	68 73 41 80 00       	push   $0x804173
  8032d0:	e8 de d3 ff ff       	call   8006b3 <_panic>
  8032d5:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032de:	89 10                	mov    %edx,(%eax)
  8032e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032e3:	8b 00                	mov    (%eax),%eax
  8032e5:	85 c0                	test   %eax,%eax
  8032e7:	74 0d                	je     8032f6 <insert_sorted_with_merge_freeList+0x697>
  8032e9:	a1 48 51 80 00       	mov    0x805148,%eax
  8032ee:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032f1:	89 50 04             	mov    %edx,0x4(%eax)
  8032f4:	eb 08                	jmp    8032fe <insert_sorted_with_merge_freeList+0x69f>
  8032f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032f9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803301:	a3 48 51 80 00       	mov    %eax,0x805148
  803306:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803309:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803310:	a1 54 51 80 00       	mov    0x805154,%eax
  803315:	40                   	inc    %eax
  803316:	a3 54 51 80 00       	mov    %eax,0x805154
							    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  80331b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80331f:	75 17                	jne    803338 <insert_sorted_with_merge_freeList+0x6d9>
  803321:	83 ec 04             	sub    $0x4,%esp
  803324:	68 50 41 80 00       	push   $0x804150
  803329:	68 65 01 00 00       	push   $0x165
  80332e:	68 73 41 80 00       	push   $0x804173
  803333:	e8 7b d3 ff ff       	call   8006b3 <_panic>
  803338:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80333e:	8b 45 08             	mov    0x8(%ebp),%eax
  803341:	89 10                	mov    %edx,(%eax)
  803343:	8b 45 08             	mov    0x8(%ebp),%eax
  803346:	8b 00                	mov    (%eax),%eax
  803348:	85 c0                	test   %eax,%eax
  80334a:	74 0d                	je     803359 <insert_sorted_with_merge_freeList+0x6fa>
  80334c:	a1 48 51 80 00       	mov    0x805148,%eax
  803351:	8b 55 08             	mov    0x8(%ebp),%edx
  803354:	89 50 04             	mov    %edx,0x4(%eax)
  803357:	eb 08                	jmp    803361 <insert_sorted_with_merge_freeList+0x702>
  803359:	8b 45 08             	mov    0x8(%ebp),%eax
  80335c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803361:	8b 45 08             	mov    0x8(%ebp),%eax
  803364:	a3 48 51 80 00       	mov    %eax,0x805148
  803369:	8b 45 08             	mov    0x8(%ebp),%eax
  80336c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803373:	a1 54 51 80 00       	mov    0x805154,%eax
  803378:	40                   	inc    %eax
  803379:	a3 54 51 80 00       	mov    %eax,0x805154
								break;
  80337e:	eb 38                	jmp    8033b8 <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  803380:	a1 40 51 80 00       	mov    0x805140,%eax
  803385:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803388:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80338c:	74 07                	je     803395 <insert_sorted_with_merge_freeList+0x736>
  80338e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803391:	8b 00                	mov    (%eax),%eax
  803393:	eb 05                	jmp    80339a <insert_sorted_with_merge_freeList+0x73b>
  803395:	b8 00 00 00 00       	mov    $0x0,%eax
  80339a:	a3 40 51 80 00       	mov    %eax,0x805140
  80339f:	a1 40 51 80 00       	mov    0x805140,%eax
  8033a4:	85 c0                	test   %eax,%eax
  8033a6:	0f 85 a7 fb ff ff    	jne    802f53 <insert_sorted_with_merge_freeList+0x2f4>
  8033ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033b0:	0f 85 9d fb ff ff    	jne    802f53 <insert_sorted_with_merge_freeList+0x2f4>
						}
				}
        }

}
}
  8033b6:	eb 00                	jmp    8033b8 <insert_sorted_with_merge_freeList+0x759>
  8033b8:	90                   	nop
  8033b9:	c9                   	leave  
  8033ba:	c3                   	ret    
  8033bb:	90                   	nop

008033bc <__udivdi3>:
  8033bc:	55                   	push   %ebp
  8033bd:	57                   	push   %edi
  8033be:	56                   	push   %esi
  8033bf:	53                   	push   %ebx
  8033c0:	83 ec 1c             	sub    $0x1c,%esp
  8033c3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8033c7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8033cb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8033cf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8033d3:	89 ca                	mov    %ecx,%edx
  8033d5:	89 f8                	mov    %edi,%eax
  8033d7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8033db:	85 f6                	test   %esi,%esi
  8033dd:	75 2d                	jne    80340c <__udivdi3+0x50>
  8033df:	39 cf                	cmp    %ecx,%edi
  8033e1:	77 65                	ja     803448 <__udivdi3+0x8c>
  8033e3:	89 fd                	mov    %edi,%ebp
  8033e5:	85 ff                	test   %edi,%edi
  8033e7:	75 0b                	jne    8033f4 <__udivdi3+0x38>
  8033e9:	b8 01 00 00 00       	mov    $0x1,%eax
  8033ee:	31 d2                	xor    %edx,%edx
  8033f0:	f7 f7                	div    %edi
  8033f2:	89 c5                	mov    %eax,%ebp
  8033f4:	31 d2                	xor    %edx,%edx
  8033f6:	89 c8                	mov    %ecx,%eax
  8033f8:	f7 f5                	div    %ebp
  8033fa:	89 c1                	mov    %eax,%ecx
  8033fc:	89 d8                	mov    %ebx,%eax
  8033fe:	f7 f5                	div    %ebp
  803400:	89 cf                	mov    %ecx,%edi
  803402:	89 fa                	mov    %edi,%edx
  803404:	83 c4 1c             	add    $0x1c,%esp
  803407:	5b                   	pop    %ebx
  803408:	5e                   	pop    %esi
  803409:	5f                   	pop    %edi
  80340a:	5d                   	pop    %ebp
  80340b:	c3                   	ret    
  80340c:	39 ce                	cmp    %ecx,%esi
  80340e:	77 28                	ja     803438 <__udivdi3+0x7c>
  803410:	0f bd fe             	bsr    %esi,%edi
  803413:	83 f7 1f             	xor    $0x1f,%edi
  803416:	75 40                	jne    803458 <__udivdi3+0x9c>
  803418:	39 ce                	cmp    %ecx,%esi
  80341a:	72 0a                	jb     803426 <__udivdi3+0x6a>
  80341c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803420:	0f 87 9e 00 00 00    	ja     8034c4 <__udivdi3+0x108>
  803426:	b8 01 00 00 00       	mov    $0x1,%eax
  80342b:	89 fa                	mov    %edi,%edx
  80342d:	83 c4 1c             	add    $0x1c,%esp
  803430:	5b                   	pop    %ebx
  803431:	5e                   	pop    %esi
  803432:	5f                   	pop    %edi
  803433:	5d                   	pop    %ebp
  803434:	c3                   	ret    
  803435:	8d 76 00             	lea    0x0(%esi),%esi
  803438:	31 ff                	xor    %edi,%edi
  80343a:	31 c0                	xor    %eax,%eax
  80343c:	89 fa                	mov    %edi,%edx
  80343e:	83 c4 1c             	add    $0x1c,%esp
  803441:	5b                   	pop    %ebx
  803442:	5e                   	pop    %esi
  803443:	5f                   	pop    %edi
  803444:	5d                   	pop    %ebp
  803445:	c3                   	ret    
  803446:	66 90                	xchg   %ax,%ax
  803448:	89 d8                	mov    %ebx,%eax
  80344a:	f7 f7                	div    %edi
  80344c:	31 ff                	xor    %edi,%edi
  80344e:	89 fa                	mov    %edi,%edx
  803450:	83 c4 1c             	add    $0x1c,%esp
  803453:	5b                   	pop    %ebx
  803454:	5e                   	pop    %esi
  803455:	5f                   	pop    %edi
  803456:	5d                   	pop    %ebp
  803457:	c3                   	ret    
  803458:	bd 20 00 00 00       	mov    $0x20,%ebp
  80345d:	89 eb                	mov    %ebp,%ebx
  80345f:	29 fb                	sub    %edi,%ebx
  803461:	89 f9                	mov    %edi,%ecx
  803463:	d3 e6                	shl    %cl,%esi
  803465:	89 c5                	mov    %eax,%ebp
  803467:	88 d9                	mov    %bl,%cl
  803469:	d3 ed                	shr    %cl,%ebp
  80346b:	89 e9                	mov    %ebp,%ecx
  80346d:	09 f1                	or     %esi,%ecx
  80346f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803473:	89 f9                	mov    %edi,%ecx
  803475:	d3 e0                	shl    %cl,%eax
  803477:	89 c5                	mov    %eax,%ebp
  803479:	89 d6                	mov    %edx,%esi
  80347b:	88 d9                	mov    %bl,%cl
  80347d:	d3 ee                	shr    %cl,%esi
  80347f:	89 f9                	mov    %edi,%ecx
  803481:	d3 e2                	shl    %cl,%edx
  803483:	8b 44 24 08          	mov    0x8(%esp),%eax
  803487:	88 d9                	mov    %bl,%cl
  803489:	d3 e8                	shr    %cl,%eax
  80348b:	09 c2                	or     %eax,%edx
  80348d:	89 d0                	mov    %edx,%eax
  80348f:	89 f2                	mov    %esi,%edx
  803491:	f7 74 24 0c          	divl   0xc(%esp)
  803495:	89 d6                	mov    %edx,%esi
  803497:	89 c3                	mov    %eax,%ebx
  803499:	f7 e5                	mul    %ebp
  80349b:	39 d6                	cmp    %edx,%esi
  80349d:	72 19                	jb     8034b8 <__udivdi3+0xfc>
  80349f:	74 0b                	je     8034ac <__udivdi3+0xf0>
  8034a1:	89 d8                	mov    %ebx,%eax
  8034a3:	31 ff                	xor    %edi,%edi
  8034a5:	e9 58 ff ff ff       	jmp    803402 <__udivdi3+0x46>
  8034aa:	66 90                	xchg   %ax,%ax
  8034ac:	8b 54 24 08          	mov    0x8(%esp),%edx
  8034b0:	89 f9                	mov    %edi,%ecx
  8034b2:	d3 e2                	shl    %cl,%edx
  8034b4:	39 c2                	cmp    %eax,%edx
  8034b6:	73 e9                	jae    8034a1 <__udivdi3+0xe5>
  8034b8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8034bb:	31 ff                	xor    %edi,%edi
  8034bd:	e9 40 ff ff ff       	jmp    803402 <__udivdi3+0x46>
  8034c2:	66 90                	xchg   %ax,%ax
  8034c4:	31 c0                	xor    %eax,%eax
  8034c6:	e9 37 ff ff ff       	jmp    803402 <__udivdi3+0x46>
  8034cb:	90                   	nop

008034cc <__umoddi3>:
  8034cc:	55                   	push   %ebp
  8034cd:	57                   	push   %edi
  8034ce:	56                   	push   %esi
  8034cf:	53                   	push   %ebx
  8034d0:	83 ec 1c             	sub    $0x1c,%esp
  8034d3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8034d7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8034db:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8034df:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8034e3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8034e7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8034eb:	89 f3                	mov    %esi,%ebx
  8034ed:	89 fa                	mov    %edi,%edx
  8034ef:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8034f3:	89 34 24             	mov    %esi,(%esp)
  8034f6:	85 c0                	test   %eax,%eax
  8034f8:	75 1a                	jne    803514 <__umoddi3+0x48>
  8034fa:	39 f7                	cmp    %esi,%edi
  8034fc:	0f 86 a2 00 00 00    	jbe    8035a4 <__umoddi3+0xd8>
  803502:	89 c8                	mov    %ecx,%eax
  803504:	89 f2                	mov    %esi,%edx
  803506:	f7 f7                	div    %edi
  803508:	89 d0                	mov    %edx,%eax
  80350a:	31 d2                	xor    %edx,%edx
  80350c:	83 c4 1c             	add    $0x1c,%esp
  80350f:	5b                   	pop    %ebx
  803510:	5e                   	pop    %esi
  803511:	5f                   	pop    %edi
  803512:	5d                   	pop    %ebp
  803513:	c3                   	ret    
  803514:	39 f0                	cmp    %esi,%eax
  803516:	0f 87 ac 00 00 00    	ja     8035c8 <__umoddi3+0xfc>
  80351c:	0f bd e8             	bsr    %eax,%ebp
  80351f:	83 f5 1f             	xor    $0x1f,%ebp
  803522:	0f 84 ac 00 00 00    	je     8035d4 <__umoddi3+0x108>
  803528:	bf 20 00 00 00       	mov    $0x20,%edi
  80352d:	29 ef                	sub    %ebp,%edi
  80352f:	89 fe                	mov    %edi,%esi
  803531:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803535:	89 e9                	mov    %ebp,%ecx
  803537:	d3 e0                	shl    %cl,%eax
  803539:	89 d7                	mov    %edx,%edi
  80353b:	89 f1                	mov    %esi,%ecx
  80353d:	d3 ef                	shr    %cl,%edi
  80353f:	09 c7                	or     %eax,%edi
  803541:	89 e9                	mov    %ebp,%ecx
  803543:	d3 e2                	shl    %cl,%edx
  803545:	89 14 24             	mov    %edx,(%esp)
  803548:	89 d8                	mov    %ebx,%eax
  80354a:	d3 e0                	shl    %cl,%eax
  80354c:	89 c2                	mov    %eax,%edx
  80354e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803552:	d3 e0                	shl    %cl,%eax
  803554:	89 44 24 04          	mov    %eax,0x4(%esp)
  803558:	8b 44 24 08          	mov    0x8(%esp),%eax
  80355c:	89 f1                	mov    %esi,%ecx
  80355e:	d3 e8                	shr    %cl,%eax
  803560:	09 d0                	or     %edx,%eax
  803562:	d3 eb                	shr    %cl,%ebx
  803564:	89 da                	mov    %ebx,%edx
  803566:	f7 f7                	div    %edi
  803568:	89 d3                	mov    %edx,%ebx
  80356a:	f7 24 24             	mull   (%esp)
  80356d:	89 c6                	mov    %eax,%esi
  80356f:	89 d1                	mov    %edx,%ecx
  803571:	39 d3                	cmp    %edx,%ebx
  803573:	0f 82 87 00 00 00    	jb     803600 <__umoddi3+0x134>
  803579:	0f 84 91 00 00 00    	je     803610 <__umoddi3+0x144>
  80357f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803583:	29 f2                	sub    %esi,%edx
  803585:	19 cb                	sbb    %ecx,%ebx
  803587:	89 d8                	mov    %ebx,%eax
  803589:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80358d:	d3 e0                	shl    %cl,%eax
  80358f:	89 e9                	mov    %ebp,%ecx
  803591:	d3 ea                	shr    %cl,%edx
  803593:	09 d0                	or     %edx,%eax
  803595:	89 e9                	mov    %ebp,%ecx
  803597:	d3 eb                	shr    %cl,%ebx
  803599:	89 da                	mov    %ebx,%edx
  80359b:	83 c4 1c             	add    $0x1c,%esp
  80359e:	5b                   	pop    %ebx
  80359f:	5e                   	pop    %esi
  8035a0:	5f                   	pop    %edi
  8035a1:	5d                   	pop    %ebp
  8035a2:	c3                   	ret    
  8035a3:	90                   	nop
  8035a4:	89 fd                	mov    %edi,%ebp
  8035a6:	85 ff                	test   %edi,%edi
  8035a8:	75 0b                	jne    8035b5 <__umoddi3+0xe9>
  8035aa:	b8 01 00 00 00       	mov    $0x1,%eax
  8035af:	31 d2                	xor    %edx,%edx
  8035b1:	f7 f7                	div    %edi
  8035b3:	89 c5                	mov    %eax,%ebp
  8035b5:	89 f0                	mov    %esi,%eax
  8035b7:	31 d2                	xor    %edx,%edx
  8035b9:	f7 f5                	div    %ebp
  8035bb:	89 c8                	mov    %ecx,%eax
  8035bd:	f7 f5                	div    %ebp
  8035bf:	89 d0                	mov    %edx,%eax
  8035c1:	e9 44 ff ff ff       	jmp    80350a <__umoddi3+0x3e>
  8035c6:	66 90                	xchg   %ax,%ax
  8035c8:	89 c8                	mov    %ecx,%eax
  8035ca:	89 f2                	mov    %esi,%edx
  8035cc:	83 c4 1c             	add    $0x1c,%esp
  8035cf:	5b                   	pop    %ebx
  8035d0:	5e                   	pop    %esi
  8035d1:	5f                   	pop    %edi
  8035d2:	5d                   	pop    %ebp
  8035d3:	c3                   	ret    
  8035d4:	3b 04 24             	cmp    (%esp),%eax
  8035d7:	72 06                	jb     8035df <__umoddi3+0x113>
  8035d9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8035dd:	77 0f                	ja     8035ee <__umoddi3+0x122>
  8035df:	89 f2                	mov    %esi,%edx
  8035e1:	29 f9                	sub    %edi,%ecx
  8035e3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8035e7:	89 14 24             	mov    %edx,(%esp)
  8035ea:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8035ee:	8b 44 24 04          	mov    0x4(%esp),%eax
  8035f2:	8b 14 24             	mov    (%esp),%edx
  8035f5:	83 c4 1c             	add    $0x1c,%esp
  8035f8:	5b                   	pop    %ebx
  8035f9:	5e                   	pop    %esi
  8035fa:	5f                   	pop    %edi
  8035fb:	5d                   	pop    %ebp
  8035fc:	c3                   	ret    
  8035fd:	8d 76 00             	lea    0x0(%esi),%esi
  803600:	2b 04 24             	sub    (%esp),%eax
  803603:	19 fa                	sbb    %edi,%edx
  803605:	89 d1                	mov    %edx,%ecx
  803607:	89 c6                	mov    %eax,%esi
  803609:	e9 71 ff ff ff       	jmp    80357f <__umoddi3+0xb3>
  80360e:	66 90                	xchg   %ax,%ax
  803610:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803614:	72 ea                	jb     803600 <__umoddi3+0x134>
  803616:	89 d9                	mov    %ebx,%ecx
  803618:	e9 62 ff ff ff       	jmp    80357f <__umoddi3+0xb3>
