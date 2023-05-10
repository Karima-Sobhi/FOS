
obj/user/ef_tst_sharing_4:     file format elf32-i386


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
  800031:	e8 5d 05 00 00       	call   800593 <libmain>
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
  80008d:	68 40 36 80 00       	push   $0x803640
  800092:	6a 12                	push   $0x12
  800094:	68 5c 36 80 00       	push   $0x80365c
  800099:	e8 31 06 00 00       	call   8006cf <_panic>
	}

	cprintf("************************************************\n");
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	68 74 36 80 00       	push   $0x803674
  8000a6:	e8 d8 08 00 00       	call   800983 <cprintf>
  8000ab:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000ae:	83 ec 0c             	sub    $0xc,%esp
  8000b1:	68 a8 36 80 00       	push   $0x8036a8
  8000b6:	e8 c8 08 00 00       	call   800983 <cprintf>
  8000bb:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000be:	83 ec 0c             	sub    $0xc,%esp
  8000c1:	68 04 37 80 00       	push   $0x803704
  8000c6:	e8 b8 08 00 00       	call   800983 <cprintf>
  8000cb:	83 c4 10             	add    $0x10,%esp

	int Mega = 1024*1024;
  8000ce:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000d5:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	int envID = sys_getenvid();
  8000dc:	e8 c3 1e 00 00       	call   801fa4 <sys_getenvid>
  8000e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	cprintf("STEP A: checking free of a shared object ... \n");
  8000e4:	83 ec 0c             	sub    $0xc,%esp
  8000e7:	68 38 37 80 00       	push   $0x803738
  8000ec:	e8 92 08 00 00       	call   800983 <cprintf>
  8000f1:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x;
		int freeFrames = sys_calculate_free_frames() ;
  8000f4:	e8 e4 1b 00 00       	call   801cdd <sys_calculate_free_frames>
  8000f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000fc:	83 ec 04             	sub    $0x4,%esp
  8000ff:	6a 01                	push   $0x1
  800101:	68 00 10 00 00       	push   $0x1000
  800106:	68 67 37 80 00       	push   $0x803767
  80010b:	e8 ee 18 00 00       	call   8019fe <smalloc>
  800110:	83 c4 10             	add    $0x10,%esp
  800113:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800116:	81 7d dc 00 00 00 80 	cmpl   $0x80000000,-0x24(%ebp)
  80011d:	74 14                	je     800133 <_main+0xfb>
  80011f:	83 ec 04             	sub    $0x4,%esp
  800122:	68 6c 37 80 00       	push   $0x80376c
  800127:	6a 21                	push   $0x21
  800129:	68 5c 36 80 00       	push   $0x80365c
  80012e:	e8 9c 05 00 00       	call   8006cf <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800133:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800136:	e8 a2 1b 00 00       	call   801cdd <sys_calculate_free_frames>
  80013b:	29 c3                	sub    %eax,%ebx
  80013d:	89 d8                	mov    %ebx,%eax
  80013f:	83 f8 04             	cmp    $0x4,%eax
  800142:	74 14                	je     800158 <_main+0x120>
  800144:	83 ec 04             	sub    $0x4,%esp
  800147:	68 d8 37 80 00       	push   $0x8037d8
  80014c:	6a 22                	push   $0x22
  80014e:	68 5c 36 80 00       	push   $0x80365c
  800153:	e8 77 05 00 00       	call   8006cf <_panic>

		sfree(x);
  800158:	83 ec 0c             	sub    $0xc,%esp
  80015b:	ff 75 dc             	pushl  -0x24(%ebp)
  80015e:	e8 1a 1a 00 00       	call   801b7d <sfree>
  800163:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) ==  0+0+2) panic("Wrong free: make sure that you free the shared object by calling free_share_object()");
  800166:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800169:	e8 6f 1b 00 00       	call   801cdd <sys_calculate_free_frames>
  80016e:	29 c3                	sub    %eax,%ebx
  800170:	89 d8                	mov    %ebx,%eax
  800172:	83 f8 02             	cmp    $0x2,%eax
  800175:	75 14                	jne    80018b <_main+0x153>
  800177:	83 ec 04             	sub    $0x4,%esp
  80017a:	68 58 38 80 00       	push   $0x803858
  80017f:	6a 25                	push   $0x25
  800181:	68 5c 36 80 00       	push   $0x80365c
  800186:	e8 44 05 00 00       	call   8006cf <_panic>
		else if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: revise your freeSharedObject logic");
  80018b:	e8 4d 1b 00 00       	call   801cdd <sys_calculate_free_frames>
  800190:	89 c2                	mov    %eax,%edx
  800192:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800195:	39 c2                	cmp    %eax,%edx
  800197:	74 14                	je     8001ad <_main+0x175>
  800199:	83 ec 04             	sub    $0x4,%esp
  80019c:	68 b0 38 80 00       	push   $0x8038b0
  8001a1:	6a 26                	push   $0x26
  8001a3:	68 5c 36 80 00       	push   $0x80365c
  8001a8:	e8 22 05 00 00       	call   8006cf <_panic>
	}
	cprintf("Step A completed successfully!!\n\n\n");
  8001ad:	83 ec 0c             	sub    $0xc,%esp
  8001b0:	68 e0 38 80 00       	push   $0x8038e0
  8001b5:	e8 c9 07 00 00       	call   800983 <cprintf>
  8001ba:	83 c4 10             	add    $0x10,%esp


	cprintf("STEP B: checking free of 2 shared objects ... \n");
  8001bd:	83 ec 0c             	sub    $0xc,%esp
  8001c0:	68 04 39 80 00       	push   $0x803904
  8001c5:	e8 b9 07 00 00       	call   800983 <cprintf>
  8001ca:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x, *z ;
		int freeFrames = sys_calculate_free_frames() ;
  8001cd:	e8 0b 1b 00 00       	call   801cdd <sys_calculate_free_frames>
  8001d2:	89 45 d8             	mov    %eax,-0x28(%ebp)
		z = smalloc("z", PAGE_SIZE, 1);
  8001d5:	83 ec 04             	sub    $0x4,%esp
  8001d8:	6a 01                	push   $0x1
  8001da:	68 00 10 00 00       	push   $0x1000
  8001df:	68 34 39 80 00       	push   $0x803934
  8001e4:	e8 15 18 00 00       	call   8019fe <smalloc>
  8001e9:	83 c4 10             	add    $0x10,%esp
  8001ec:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8001ef:	83 ec 04             	sub    $0x4,%esp
  8001f2:	6a 01                	push   $0x1
  8001f4:	68 00 10 00 00       	push   $0x1000
  8001f9:	68 67 37 80 00       	push   $0x803767
  8001fe:	e8 fb 17 00 00       	call   8019fe <smalloc>
  800203:	83 c4 10             	add    $0x10,%esp
  800206:	89 45 d0             	mov    %eax,-0x30(%ebp)

		if(x == NULL) panic("Wrong free: make sure that you free the shared object by calling free_share_object()");
  800209:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80020d:	75 14                	jne    800223 <_main+0x1eb>
  80020f:	83 ec 04             	sub    $0x4,%esp
  800212:	68 58 38 80 00       	push   $0x803858
  800217:	6a 32                	push   $0x32
  800219:	68 5c 36 80 00       	push   $0x80365c
  80021e:	e8 ac 04 00 00       	call   8006cf <_panic>

		if ((freeFrames - sys_calculate_free_frames()) !=  2+1+4) panic("Wrong previous free: make sure that you correctly free shared object before (Step A)");
  800223:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800226:	e8 b2 1a 00 00       	call   801cdd <sys_calculate_free_frames>
  80022b:	29 c3                	sub    %eax,%ebx
  80022d:	89 d8                	mov    %ebx,%eax
  80022f:	83 f8 07             	cmp    $0x7,%eax
  800232:	74 14                	je     800248 <_main+0x210>
  800234:	83 ec 04             	sub    $0x4,%esp
  800237:	68 38 39 80 00       	push   $0x803938
  80023c:	6a 34                	push   $0x34
  80023e:	68 5c 36 80 00       	push   $0x80365c
  800243:	e8 87 04 00 00       	call   8006cf <_panic>

		sfree(z);
  800248:	83 ec 0c             	sub    $0xc,%esp
  80024b:	ff 75 d4             	pushl  -0x2c(%ebp)
  80024e:	e8 2a 19 00 00       	call   801b7d <sfree>
  800253:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  800256:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800259:	e8 7f 1a 00 00       	call   801cdd <sys_calculate_free_frames>
  80025e:	29 c3                	sub    %eax,%ebx
  800260:	89 d8                	mov    %ebx,%eax
  800262:	83 f8 04             	cmp    $0x4,%eax
  800265:	74 14                	je     80027b <_main+0x243>
  800267:	83 ec 04             	sub    $0x4,%esp
  80026a:	68 8d 39 80 00       	push   $0x80398d
  80026f:	6a 37                	push   $0x37
  800271:	68 5c 36 80 00       	push   $0x80365c
  800276:	e8 54 04 00 00       	call   8006cf <_panic>

		sfree(x);
  80027b:	83 ec 0c             	sub    $0xc,%esp
  80027e:	ff 75 d0             	pushl  -0x30(%ebp)
  800281:	e8 f7 18 00 00       	call   801b7d <sfree>
  800286:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  800289:	e8 4f 1a 00 00       	call   801cdd <sys_calculate_free_frames>
  80028e:	89 c2                	mov    %eax,%edx
  800290:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800293:	39 c2                	cmp    %eax,%edx
  800295:	74 14                	je     8002ab <_main+0x273>
  800297:	83 ec 04             	sub    $0x4,%esp
  80029a:	68 8d 39 80 00       	push   $0x80398d
  80029f:	6a 3a                	push   $0x3a
  8002a1:	68 5c 36 80 00       	push   $0x80365c
  8002a6:	e8 24 04 00 00       	call   8006cf <_panic>

	}
	cprintf("Step B completed successfully!!\n\n\n");
  8002ab:	83 ec 0c             	sub    $0xc,%esp
  8002ae:	68 ac 39 80 00       	push   $0x8039ac
  8002b3:	e8 cb 06 00 00       	call   800983 <cprintf>
  8002b8:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP C: checking range of loop during free... \n");
  8002bb:	83 ec 0c             	sub    $0xc,%esp
  8002be:	68 d0 39 80 00       	push   $0x8039d0
  8002c3:	e8 bb 06 00 00       	call   800983 <cprintf>
  8002c8:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *w, *u;
		int freeFrames = sys_calculate_free_frames() ;
  8002cb:	e8 0d 1a 00 00       	call   801cdd <sys_calculate_free_frames>
  8002d0:	89 45 cc             	mov    %eax,-0x34(%ebp)
		w = smalloc("w", 3 * PAGE_SIZE+1, 1);
  8002d3:	83 ec 04             	sub    $0x4,%esp
  8002d6:	6a 01                	push   $0x1
  8002d8:	68 01 30 00 00       	push   $0x3001
  8002dd:	68 00 3a 80 00       	push   $0x803a00
  8002e2:	e8 17 17 00 00       	call   8019fe <smalloc>
  8002e7:	83 c4 10             	add    $0x10,%esp
  8002ea:	89 45 c8             	mov    %eax,-0x38(%ebp)
		u = smalloc("u", PAGE_SIZE, 1);
  8002ed:	83 ec 04             	sub    $0x4,%esp
  8002f0:	6a 01                	push   $0x1
  8002f2:	68 00 10 00 00       	push   $0x1000
  8002f7:	68 02 3a 80 00       	push   $0x803a02
  8002fc:	e8 fd 16 00 00       	call   8019fe <smalloc>
  800301:	83 c4 10             	add    $0x10,%esp
  800304:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		if ((freeFrames - sys_calculate_free_frames()) != 5+1+4) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800307:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80030a:	e8 ce 19 00 00       	call   801cdd <sys_calculate_free_frames>
  80030f:	29 c3                	sub    %eax,%ebx
  800311:	89 d8                	mov    %ebx,%eax
  800313:	83 f8 0a             	cmp    $0xa,%eax
  800316:	74 14                	je     80032c <_main+0x2f4>
  800318:	83 ec 04             	sub    $0x4,%esp
  80031b:	68 d8 37 80 00       	push   $0x8037d8
  800320:	6a 46                	push   $0x46
  800322:	68 5c 36 80 00       	push   $0x80365c
  800327:	e8 a3 03 00 00       	call   8006cf <_panic>

		sfree(w);
  80032c:	83 ec 0c             	sub    $0xc,%esp
  80032f:	ff 75 c8             	pushl  -0x38(%ebp)
  800332:	e8 46 18 00 00       	call   801b7d <sfree>
  800337:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  80033a:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80033d:	e8 9b 19 00 00       	call   801cdd <sys_calculate_free_frames>
  800342:	29 c3                	sub    %eax,%ebx
  800344:	89 d8                	mov    %ebx,%eax
  800346:	83 f8 04             	cmp    $0x4,%eax
  800349:	74 14                	je     80035f <_main+0x327>
  80034b:	83 ec 04             	sub    $0x4,%esp
  80034e:	68 8d 39 80 00       	push   $0x80398d
  800353:	6a 49                	push   $0x49
  800355:	68 5c 36 80 00       	push   $0x80365c
  80035a:	e8 70 03 00 00       	call   8006cf <_panic>

		uint32 *o;
		o = smalloc("o", 2 * PAGE_SIZE-1,1);
  80035f:	83 ec 04             	sub    $0x4,%esp
  800362:	6a 01                	push   $0x1
  800364:	68 ff 1f 00 00       	push   $0x1fff
  800369:	68 04 3a 80 00       	push   $0x803a04
  80036e:	e8 8b 16 00 00       	call   8019fe <smalloc>
  800373:	83 c4 10             	add    $0x10,%esp
  800376:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if ((freeFrames - sys_calculate_free_frames()) != 3+1+4) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800379:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80037c:	e8 5c 19 00 00       	call   801cdd <sys_calculate_free_frames>
  800381:	29 c3                	sub    %eax,%ebx
  800383:	89 d8                	mov    %ebx,%eax
  800385:	83 f8 08             	cmp    $0x8,%eax
  800388:	74 14                	je     80039e <_main+0x366>
  80038a:	83 ec 04             	sub    $0x4,%esp
  80038d:	68 d8 37 80 00       	push   $0x8037d8
  800392:	6a 4e                	push   $0x4e
  800394:	68 5c 36 80 00       	push   $0x80365c
  800399:	e8 31 03 00 00       	call   8006cf <_panic>

		sfree(o);
  80039e:	83 ec 0c             	sub    $0xc,%esp
  8003a1:	ff 75 c0             	pushl  -0x40(%ebp)
  8003a4:	e8 d4 17 00 00       	call   801b7d <sfree>
  8003a9:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  8003ac:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8003af:	e8 29 19 00 00       	call   801cdd <sys_calculate_free_frames>
  8003b4:	29 c3                	sub    %eax,%ebx
  8003b6:	89 d8                	mov    %ebx,%eax
  8003b8:	83 f8 04             	cmp    $0x4,%eax
  8003bb:	74 14                	je     8003d1 <_main+0x399>
  8003bd:	83 ec 04             	sub    $0x4,%esp
  8003c0:	68 8d 39 80 00       	push   $0x80398d
  8003c5:	6a 51                	push   $0x51
  8003c7:	68 5c 36 80 00       	push   $0x80365c
  8003cc:	e8 fe 02 00 00       	call   8006cf <_panic>

		sfree(u);
  8003d1:	83 ec 0c             	sub    $0xc,%esp
  8003d4:	ff 75 c4             	pushl  -0x3c(%ebp)
  8003d7:	e8 a1 17 00 00       	call   801b7d <sfree>
  8003dc:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  8003df:	e8 f9 18 00 00       	call   801cdd <sys_calculate_free_frames>
  8003e4:	89 c2                	mov    %eax,%edx
  8003e6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8003e9:	39 c2                	cmp    %eax,%edx
  8003eb:	74 14                	je     800401 <_main+0x3c9>
  8003ed:	83 ec 04             	sub    $0x4,%esp
  8003f0:	68 8d 39 80 00       	push   $0x80398d
  8003f5:	6a 54                	push   $0x54
  8003f7:	68 5c 36 80 00       	push   $0x80365c
  8003fc:	e8 ce 02 00 00       	call   8006cf <_panic>


		//Checking boundaries of page tables
		freeFrames = sys_calculate_free_frames() ;
  800401:	e8 d7 18 00 00       	call   801cdd <sys_calculate_free_frames>
  800406:	89 45 cc             	mov    %eax,-0x34(%ebp)
		w = smalloc("w", 3 * Mega - 1*kilo, 1);
  800409:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80040c:	89 c2                	mov    %eax,%edx
  80040e:	01 d2                	add    %edx,%edx
  800410:	01 d0                	add    %edx,%eax
  800412:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800415:	83 ec 04             	sub    $0x4,%esp
  800418:	6a 01                	push   $0x1
  80041a:	50                   	push   %eax
  80041b:	68 00 3a 80 00       	push   $0x803a00
  800420:	e8 d9 15 00 00       	call   8019fe <smalloc>
  800425:	83 c4 10             	add    $0x10,%esp
  800428:	89 45 c8             	mov    %eax,-0x38(%ebp)
		u = smalloc("u", 7 * Mega - 1*kilo, 1);
  80042b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80042e:	89 d0                	mov    %edx,%eax
  800430:	01 c0                	add    %eax,%eax
  800432:	01 d0                	add    %edx,%eax
  800434:	01 c0                	add    %eax,%eax
  800436:	01 d0                	add    %edx,%eax
  800438:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80043b:	83 ec 04             	sub    $0x4,%esp
  80043e:	6a 01                	push   $0x1
  800440:	50                   	push   %eax
  800441:	68 02 3a 80 00       	push   $0x803a02
  800446:	e8 b3 15 00 00       	call   8019fe <smalloc>
  80044b:	83 c4 10             	add    $0x10,%esp
  80044e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		o = smalloc("o", 2 * Mega + 1*kilo, 1);
  800451:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800454:	01 c0                	add    %eax,%eax
  800456:	89 c2                	mov    %eax,%edx
  800458:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80045b:	01 d0                	add    %edx,%eax
  80045d:	83 ec 04             	sub    $0x4,%esp
  800460:	6a 01                	push   $0x1
  800462:	50                   	push   %eax
  800463:	68 04 3a 80 00       	push   $0x803a04
  800468:	e8 91 15 00 00       	call   8019fe <smalloc>
  80046d:	83 c4 10             	add    $0x10,%esp
  800470:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if ((freeFrames - sys_calculate_free_frames()) != 3073+4+7) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800473:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800476:	e8 62 18 00 00       	call   801cdd <sys_calculate_free_frames>
  80047b:	29 c3                	sub    %eax,%ebx
  80047d:	89 d8                	mov    %ebx,%eax
  80047f:	3d 0c 0c 00 00       	cmp    $0xc0c,%eax
  800484:	74 14                	je     80049a <_main+0x462>
  800486:	83 ec 04             	sub    $0x4,%esp
  800489:	68 d8 37 80 00       	push   $0x8037d8
  80048e:	6a 5d                	push   $0x5d
  800490:	68 5c 36 80 00       	push   $0x80365c
  800495:	e8 35 02 00 00       	call   8006cf <_panic>

		sfree(o);
  80049a:	83 ec 0c             	sub    $0xc,%esp
  80049d:	ff 75 c0             	pushl  -0x40(%ebp)
  8004a0:	e8 d8 16 00 00       	call   801b7d <sfree>
  8004a5:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  2560+3+5) panic("Wrong free: check your logic");
  8004a8:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004ab:	e8 2d 18 00 00       	call   801cdd <sys_calculate_free_frames>
  8004b0:	29 c3                	sub    %eax,%ebx
  8004b2:	89 d8                	mov    %ebx,%eax
  8004b4:	3d 08 0a 00 00       	cmp    $0xa08,%eax
  8004b9:	74 14                	je     8004cf <_main+0x497>
  8004bb:	83 ec 04             	sub    $0x4,%esp
  8004be:	68 8d 39 80 00       	push   $0x80398d
  8004c3:	6a 60                	push   $0x60
  8004c5:	68 5c 36 80 00       	push   $0x80365c
  8004ca:	e8 00 02 00 00       	call   8006cf <_panic>

		sfree(w);
  8004cf:	83 ec 0c             	sub    $0xc,%esp
  8004d2:	ff 75 c8             	pushl  -0x38(%ebp)
  8004d5:	e8 a3 16 00 00       	call   801b7d <sfree>
  8004da:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1792+3+3) panic("Wrong free: check your logic");
  8004dd:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004e0:	e8 f8 17 00 00       	call   801cdd <sys_calculate_free_frames>
  8004e5:	29 c3                	sub    %eax,%ebx
  8004e7:	89 d8                	mov    %ebx,%eax
  8004e9:	3d 06 07 00 00       	cmp    $0x706,%eax
  8004ee:	74 14                	je     800504 <_main+0x4cc>
  8004f0:	83 ec 04             	sub    $0x4,%esp
  8004f3:	68 8d 39 80 00       	push   $0x80398d
  8004f8:	6a 63                	push   $0x63
  8004fa:	68 5c 36 80 00       	push   $0x80365c
  8004ff:	e8 cb 01 00 00       	call   8006cf <_panic>

		sfree(u);
  800504:	83 ec 0c             	sub    $0xc,%esp
  800507:	ff 75 c4             	pushl  -0x3c(%ebp)
  80050a:	e8 6e 16 00 00       	call   801b7d <sfree>
  80050f:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  800512:	e8 c6 17 00 00       	call   801cdd <sys_calculate_free_frames>
  800517:	89 c2                	mov    %eax,%edx
  800519:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80051c:	39 c2                	cmp    %eax,%edx
  80051e:	74 14                	je     800534 <_main+0x4fc>
  800520:	83 ec 04             	sub    $0x4,%esp
  800523:	68 8d 39 80 00       	push   $0x80398d
  800528:	6a 66                	push   $0x66
  80052a:	68 5c 36 80 00       	push   $0x80365c
  80052f:	e8 9b 01 00 00       	call   8006cf <_panic>
	}
	cprintf("Step C completed successfully!!\n\n\n");
  800534:	83 ec 0c             	sub    $0xc,%esp
  800537:	68 08 3a 80 00       	push   $0x803a08
  80053c:	e8 42 04 00 00       	call   800983 <cprintf>
  800541:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! Test of freeSharedObjects [4] completed successfully!!\n\n\n");
  800544:	83 ec 0c             	sub    $0xc,%esp
  800547:	68 2c 3a 80 00       	push   $0x803a2c
  80054c:	e8 32 04 00 00       	call   800983 <cprintf>
  800551:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  800554:	e8 7d 1a 00 00       	call   801fd6 <sys_getparentenvid>
  800559:	89 45 bc             	mov    %eax,-0x44(%ebp)
	if(parentenvID > 0)
  80055c:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  800560:	7e 2b                	jle    80058d <_main+0x555>
	{
		//Get the check-finishing counter
		int *finishedCount = NULL;
  800562:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		finishedCount = sget(parentenvID, "finishedCount") ;
  800569:	83 ec 08             	sub    $0x8,%esp
  80056c:	68 78 3a 80 00       	push   $0x803a78
  800571:	ff 75 bc             	pushl  -0x44(%ebp)
  800574:	e8 2e 15 00 00       	call   801aa7 <sget>
  800579:	83 c4 10             	add    $0x10,%esp
  80057c:	89 45 b8             	mov    %eax,-0x48(%ebp)
		(*finishedCount)++ ;
  80057f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800582:	8b 00                	mov    (%eax),%eax
  800584:	8d 50 01             	lea    0x1(%eax),%edx
  800587:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80058a:	89 10                	mov    %edx,(%eax)
	}
	return;
  80058c:	90                   	nop
  80058d:	90                   	nop
}
  80058e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800591:	c9                   	leave  
  800592:	c3                   	ret    

00800593 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800593:	55                   	push   %ebp
  800594:	89 e5                	mov    %esp,%ebp
  800596:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800599:	e8 1f 1a 00 00       	call   801fbd <sys_getenvindex>
  80059e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8005a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005a4:	89 d0                	mov    %edx,%eax
  8005a6:	c1 e0 03             	shl    $0x3,%eax
  8005a9:	01 d0                	add    %edx,%eax
  8005ab:	01 c0                	add    %eax,%eax
  8005ad:	01 d0                	add    %edx,%eax
  8005af:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005b6:	01 d0                	add    %edx,%eax
  8005b8:	c1 e0 04             	shl    $0x4,%eax
  8005bb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8005c0:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8005c5:	a1 20 50 80 00       	mov    0x805020,%eax
  8005ca:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8005d0:	84 c0                	test   %al,%al
  8005d2:	74 0f                	je     8005e3 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8005d4:	a1 20 50 80 00       	mov    0x805020,%eax
  8005d9:	05 5c 05 00 00       	add    $0x55c,%eax
  8005de:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8005e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8005e7:	7e 0a                	jle    8005f3 <libmain+0x60>
		binaryname = argv[0];
  8005e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005ec:	8b 00                	mov    (%eax),%eax
  8005ee:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8005f3:	83 ec 08             	sub    $0x8,%esp
  8005f6:	ff 75 0c             	pushl  0xc(%ebp)
  8005f9:	ff 75 08             	pushl  0x8(%ebp)
  8005fc:	e8 37 fa ff ff       	call   800038 <_main>
  800601:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800604:	e8 c1 17 00 00       	call   801dca <sys_disable_interrupt>
	cprintf("**************************************\n");
  800609:	83 ec 0c             	sub    $0xc,%esp
  80060c:	68 a0 3a 80 00       	push   $0x803aa0
  800611:	e8 6d 03 00 00       	call   800983 <cprintf>
  800616:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800619:	a1 20 50 80 00       	mov    0x805020,%eax
  80061e:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800624:	a1 20 50 80 00       	mov    0x805020,%eax
  800629:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80062f:	83 ec 04             	sub    $0x4,%esp
  800632:	52                   	push   %edx
  800633:	50                   	push   %eax
  800634:	68 c8 3a 80 00       	push   $0x803ac8
  800639:	e8 45 03 00 00       	call   800983 <cprintf>
  80063e:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800641:	a1 20 50 80 00       	mov    0x805020,%eax
  800646:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80064c:	a1 20 50 80 00       	mov    0x805020,%eax
  800651:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800657:	a1 20 50 80 00       	mov    0x805020,%eax
  80065c:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800662:	51                   	push   %ecx
  800663:	52                   	push   %edx
  800664:	50                   	push   %eax
  800665:	68 f0 3a 80 00       	push   $0x803af0
  80066a:	e8 14 03 00 00       	call   800983 <cprintf>
  80066f:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800672:	a1 20 50 80 00       	mov    0x805020,%eax
  800677:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80067d:	83 ec 08             	sub    $0x8,%esp
  800680:	50                   	push   %eax
  800681:	68 48 3b 80 00       	push   $0x803b48
  800686:	e8 f8 02 00 00       	call   800983 <cprintf>
  80068b:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80068e:	83 ec 0c             	sub    $0xc,%esp
  800691:	68 a0 3a 80 00       	push   $0x803aa0
  800696:	e8 e8 02 00 00       	call   800983 <cprintf>
  80069b:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80069e:	e8 41 17 00 00       	call   801de4 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8006a3:	e8 19 00 00 00       	call   8006c1 <exit>
}
  8006a8:	90                   	nop
  8006a9:	c9                   	leave  
  8006aa:	c3                   	ret    

008006ab <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8006ab:	55                   	push   %ebp
  8006ac:	89 e5                	mov    %esp,%ebp
  8006ae:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8006b1:	83 ec 0c             	sub    $0xc,%esp
  8006b4:	6a 00                	push   $0x0
  8006b6:	e8 ce 18 00 00       	call   801f89 <sys_destroy_env>
  8006bb:	83 c4 10             	add    $0x10,%esp
}
  8006be:	90                   	nop
  8006bf:	c9                   	leave  
  8006c0:	c3                   	ret    

008006c1 <exit>:

void
exit(void)
{
  8006c1:	55                   	push   %ebp
  8006c2:	89 e5                	mov    %esp,%ebp
  8006c4:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8006c7:	e8 23 19 00 00       	call   801fef <sys_exit_env>
}
  8006cc:	90                   	nop
  8006cd:	c9                   	leave  
  8006ce:	c3                   	ret    

008006cf <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8006cf:	55                   	push   %ebp
  8006d0:	89 e5                	mov    %esp,%ebp
  8006d2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8006d5:	8d 45 10             	lea    0x10(%ebp),%eax
  8006d8:	83 c0 04             	add    $0x4,%eax
  8006db:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8006de:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8006e3:	85 c0                	test   %eax,%eax
  8006e5:	74 16                	je     8006fd <_panic+0x2e>
		cprintf("%s: ", argv0);
  8006e7:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8006ec:	83 ec 08             	sub    $0x8,%esp
  8006ef:	50                   	push   %eax
  8006f0:	68 5c 3b 80 00       	push   $0x803b5c
  8006f5:	e8 89 02 00 00       	call   800983 <cprintf>
  8006fa:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8006fd:	a1 00 50 80 00       	mov    0x805000,%eax
  800702:	ff 75 0c             	pushl  0xc(%ebp)
  800705:	ff 75 08             	pushl  0x8(%ebp)
  800708:	50                   	push   %eax
  800709:	68 61 3b 80 00       	push   $0x803b61
  80070e:	e8 70 02 00 00       	call   800983 <cprintf>
  800713:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800716:	8b 45 10             	mov    0x10(%ebp),%eax
  800719:	83 ec 08             	sub    $0x8,%esp
  80071c:	ff 75 f4             	pushl  -0xc(%ebp)
  80071f:	50                   	push   %eax
  800720:	e8 f3 01 00 00       	call   800918 <vcprintf>
  800725:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800728:	83 ec 08             	sub    $0x8,%esp
  80072b:	6a 00                	push   $0x0
  80072d:	68 7d 3b 80 00       	push   $0x803b7d
  800732:	e8 e1 01 00 00       	call   800918 <vcprintf>
  800737:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80073a:	e8 82 ff ff ff       	call   8006c1 <exit>

	// should not return here
	while (1) ;
  80073f:	eb fe                	jmp    80073f <_panic+0x70>

00800741 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800741:	55                   	push   %ebp
  800742:	89 e5                	mov    %esp,%ebp
  800744:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800747:	a1 20 50 80 00       	mov    0x805020,%eax
  80074c:	8b 50 74             	mov    0x74(%eax),%edx
  80074f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800752:	39 c2                	cmp    %eax,%edx
  800754:	74 14                	je     80076a <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800756:	83 ec 04             	sub    $0x4,%esp
  800759:	68 80 3b 80 00       	push   $0x803b80
  80075e:	6a 26                	push   $0x26
  800760:	68 cc 3b 80 00       	push   $0x803bcc
  800765:	e8 65 ff ff ff       	call   8006cf <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80076a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800771:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800778:	e9 c2 00 00 00       	jmp    80083f <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80077d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800780:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800787:	8b 45 08             	mov    0x8(%ebp),%eax
  80078a:	01 d0                	add    %edx,%eax
  80078c:	8b 00                	mov    (%eax),%eax
  80078e:	85 c0                	test   %eax,%eax
  800790:	75 08                	jne    80079a <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800792:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800795:	e9 a2 00 00 00       	jmp    80083c <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80079a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8007a1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8007a8:	eb 69                	jmp    800813 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8007aa:	a1 20 50 80 00       	mov    0x805020,%eax
  8007af:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8007b5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007b8:	89 d0                	mov    %edx,%eax
  8007ba:	01 c0                	add    %eax,%eax
  8007bc:	01 d0                	add    %edx,%eax
  8007be:	c1 e0 03             	shl    $0x3,%eax
  8007c1:	01 c8                	add    %ecx,%eax
  8007c3:	8a 40 04             	mov    0x4(%eax),%al
  8007c6:	84 c0                	test   %al,%al
  8007c8:	75 46                	jne    800810 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8007ca:	a1 20 50 80 00       	mov    0x805020,%eax
  8007cf:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8007d5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007d8:	89 d0                	mov    %edx,%eax
  8007da:	01 c0                	add    %eax,%eax
  8007dc:	01 d0                	add    %edx,%eax
  8007de:	c1 e0 03             	shl    $0x3,%eax
  8007e1:	01 c8                	add    %ecx,%eax
  8007e3:	8b 00                	mov    (%eax),%eax
  8007e5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8007e8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8007eb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8007f0:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8007f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007f5:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8007fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ff:	01 c8                	add    %ecx,%eax
  800801:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800803:	39 c2                	cmp    %eax,%edx
  800805:	75 09                	jne    800810 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800807:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80080e:	eb 12                	jmp    800822 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800810:	ff 45 e8             	incl   -0x18(%ebp)
  800813:	a1 20 50 80 00       	mov    0x805020,%eax
  800818:	8b 50 74             	mov    0x74(%eax),%edx
  80081b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80081e:	39 c2                	cmp    %eax,%edx
  800820:	77 88                	ja     8007aa <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800822:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800826:	75 14                	jne    80083c <CheckWSWithoutLastIndex+0xfb>
			panic(
  800828:	83 ec 04             	sub    $0x4,%esp
  80082b:	68 d8 3b 80 00       	push   $0x803bd8
  800830:	6a 3a                	push   $0x3a
  800832:	68 cc 3b 80 00       	push   $0x803bcc
  800837:	e8 93 fe ff ff       	call   8006cf <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80083c:	ff 45 f0             	incl   -0x10(%ebp)
  80083f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800842:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800845:	0f 8c 32 ff ff ff    	jl     80077d <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80084b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800852:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800859:	eb 26                	jmp    800881 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80085b:	a1 20 50 80 00       	mov    0x805020,%eax
  800860:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800866:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800869:	89 d0                	mov    %edx,%eax
  80086b:	01 c0                	add    %eax,%eax
  80086d:	01 d0                	add    %edx,%eax
  80086f:	c1 e0 03             	shl    $0x3,%eax
  800872:	01 c8                	add    %ecx,%eax
  800874:	8a 40 04             	mov    0x4(%eax),%al
  800877:	3c 01                	cmp    $0x1,%al
  800879:	75 03                	jne    80087e <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80087b:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80087e:	ff 45 e0             	incl   -0x20(%ebp)
  800881:	a1 20 50 80 00       	mov    0x805020,%eax
  800886:	8b 50 74             	mov    0x74(%eax),%edx
  800889:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80088c:	39 c2                	cmp    %eax,%edx
  80088e:	77 cb                	ja     80085b <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800890:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800893:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800896:	74 14                	je     8008ac <CheckWSWithoutLastIndex+0x16b>
		panic(
  800898:	83 ec 04             	sub    $0x4,%esp
  80089b:	68 2c 3c 80 00       	push   $0x803c2c
  8008a0:	6a 44                	push   $0x44
  8008a2:	68 cc 3b 80 00       	push   $0x803bcc
  8008a7:	e8 23 fe ff ff       	call   8006cf <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8008ac:	90                   	nop
  8008ad:	c9                   	leave  
  8008ae:	c3                   	ret    

008008af <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8008af:	55                   	push   %ebp
  8008b0:	89 e5                	mov    %esp,%ebp
  8008b2:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8008b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008b8:	8b 00                	mov    (%eax),%eax
  8008ba:	8d 48 01             	lea    0x1(%eax),%ecx
  8008bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008c0:	89 0a                	mov    %ecx,(%edx)
  8008c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8008c5:	88 d1                	mov    %dl,%cl
  8008c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ca:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8008ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008d1:	8b 00                	mov    (%eax),%eax
  8008d3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8008d8:	75 2c                	jne    800906 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8008da:	a0 24 50 80 00       	mov    0x805024,%al
  8008df:	0f b6 c0             	movzbl %al,%eax
  8008e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008e5:	8b 12                	mov    (%edx),%edx
  8008e7:	89 d1                	mov    %edx,%ecx
  8008e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ec:	83 c2 08             	add    $0x8,%edx
  8008ef:	83 ec 04             	sub    $0x4,%esp
  8008f2:	50                   	push   %eax
  8008f3:	51                   	push   %ecx
  8008f4:	52                   	push   %edx
  8008f5:	e8 22 13 00 00       	call   801c1c <sys_cputs>
  8008fa:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8008fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800900:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800906:	8b 45 0c             	mov    0xc(%ebp),%eax
  800909:	8b 40 04             	mov    0x4(%eax),%eax
  80090c:	8d 50 01             	lea    0x1(%eax),%edx
  80090f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800912:	89 50 04             	mov    %edx,0x4(%eax)
}
  800915:	90                   	nop
  800916:	c9                   	leave  
  800917:	c3                   	ret    

00800918 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800918:	55                   	push   %ebp
  800919:	89 e5                	mov    %esp,%ebp
  80091b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800921:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800928:	00 00 00 
	b.cnt = 0;
  80092b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800932:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800935:	ff 75 0c             	pushl  0xc(%ebp)
  800938:	ff 75 08             	pushl  0x8(%ebp)
  80093b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800941:	50                   	push   %eax
  800942:	68 af 08 80 00       	push   $0x8008af
  800947:	e8 11 02 00 00       	call   800b5d <vprintfmt>
  80094c:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80094f:	a0 24 50 80 00       	mov    0x805024,%al
  800954:	0f b6 c0             	movzbl %al,%eax
  800957:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80095d:	83 ec 04             	sub    $0x4,%esp
  800960:	50                   	push   %eax
  800961:	52                   	push   %edx
  800962:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800968:	83 c0 08             	add    $0x8,%eax
  80096b:	50                   	push   %eax
  80096c:	e8 ab 12 00 00       	call   801c1c <sys_cputs>
  800971:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800974:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  80097b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800981:	c9                   	leave  
  800982:	c3                   	ret    

00800983 <cprintf>:

int cprintf(const char *fmt, ...) {
  800983:	55                   	push   %ebp
  800984:	89 e5                	mov    %esp,%ebp
  800986:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800989:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800990:	8d 45 0c             	lea    0xc(%ebp),%eax
  800993:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800996:	8b 45 08             	mov    0x8(%ebp),%eax
  800999:	83 ec 08             	sub    $0x8,%esp
  80099c:	ff 75 f4             	pushl  -0xc(%ebp)
  80099f:	50                   	push   %eax
  8009a0:	e8 73 ff ff ff       	call   800918 <vcprintf>
  8009a5:	83 c4 10             	add    $0x10,%esp
  8009a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8009ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009ae:	c9                   	leave  
  8009af:	c3                   	ret    

008009b0 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8009b0:	55                   	push   %ebp
  8009b1:	89 e5                	mov    %esp,%ebp
  8009b3:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8009b6:	e8 0f 14 00 00       	call   801dca <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8009bb:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009be:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c4:	83 ec 08             	sub    $0x8,%esp
  8009c7:	ff 75 f4             	pushl  -0xc(%ebp)
  8009ca:	50                   	push   %eax
  8009cb:	e8 48 ff ff ff       	call   800918 <vcprintf>
  8009d0:	83 c4 10             	add    $0x10,%esp
  8009d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8009d6:	e8 09 14 00 00       	call   801de4 <sys_enable_interrupt>
	return cnt;
  8009db:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009de:	c9                   	leave  
  8009df:	c3                   	ret    

008009e0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8009e0:	55                   	push   %ebp
  8009e1:	89 e5                	mov    %esp,%ebp
  8009e3:	53                   	push   %ebx
  8009e4:	83 ec 14             	sub    $0x14,%esp
  8009e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8009f3:	8b 45 18             	mov    0x18(%ebp),%eax
  8009f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8009fb:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8009fe:	77 55                	ja     800a55 <printnum+0x75>
  800a00:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a03:	72 05                	jb     800a0a <printnum+0x2a>
  800a05:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a08:	77 4b                	ja     800a55 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a0a:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800a0d:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a10:	8b 45 18             	mov    0x18(%ebp),%eax
  800a13:	ba 00 00 00 00       	mov    $0x0,%edx
  800a18:	52                   	push   %edx
  800a19:	50                   	push   %eax
  800a1a:	ff 75 f4             	pushl  -0xc(%ebp)
  800a1d:	ff 75 f0             	pushl  -0x10(%ebp)
  800a20:	e8 b3 29 00 00       	call   8033d8 <__udivdi3>
  800a25:	83 c4 10             	add    $0x10,%esp
  800a28:	83 ec 04             	sub    $0x4,%esp
  800a2b:	ff 75 20             	pushl  0x20(%ebp)
  800a2e:	53                   	push   %ebx
  800a2f:	ff 75 18             	pushl  0x18(%ebp)
  800a32:	52                   	push   %edx
  800a33:	50                   	push   %eax
  800a34:	ff 75 0c             	pushl  0xc(%ebp)
  800a37:	ff 75 08             	pushl  0x8(%ebp)
  800a3a:	e8 a1 ff ff ff       	call   8009e0 <printnum>
  800a3f:	83 c4 20             	add    $0x20,%esp
  800a42:	eb 1a                	jmp    800a5e <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a44:	83 ec 08             	sub    $0x8,%esp
  800a47:	ff 75 0c             	pushl  0xc(%ebp)
  800a4a:	ff 75 20             	pushl  0x20(%ebp)
  800a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a50:	ff d0                	call   *%eax
  800a52:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800a55:	ff 4d 1c             	decl   0x1c(%ebp)
  800a58:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800a5c:	7f e6                	jg     800a44 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800a5e:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800a61:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a69:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a6c:	53                   	push   %ebx
  800a6d:	51                   	push   %ecx
  800a6e:	52                   	push   %edx
  800a6f:	50                   	push   %eax
  800a70:	e8 73 2a 00 00       	call   8034e8 <__umoddi3>
  800a75:	83 c4 10             	add    $0x10,%esp
  800a78:	05 94 3e 80 00       	add    $0x803e94,%eax
  800a7d:	8a 00                	mov    (%eax),%al
  800a7f:	0f be c0             	movsbl %al,%eax
  800a82:	83 ec 08             	sub    $0x8,%esp
  800a85:	ff 75 0c             	pushl  0xc(%ebp)
  800a88:	50                   	push   %eax
  800a89:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8c:	ff d0                	call   *%eax
  800a8e:	83 c4 10             	add    $0x10,%esp
}
  800a91:	90                   	nop
  800a92:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a95:	c9                   	leave  
  800a96:	c3                   	ret    

00800a97 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800a97:	55                   	push   %ebp
  800a98:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800a9a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800a9e:	7e 1c                	jle    800abc <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa3:	8b 00                	mov    (%eax),%eax
  800aa5:	8d 50 08             	lea    0x8(%eax),%edx
  800aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  800aab:	89 10                	mov    %edx,(%eax)
  800aad:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab0:	8b 00                	mov    (%eax),%eax
  800ab2:	83 e8 08             	sub    $0x8,%eax
  800ab5:	8b 50 04             	mov    0x4(%eax),%edx
  800ab8:	8b 00                	mov    (%eax),%eax
  800aba:	eb 40                	jmp    800afc <getuint+0x65>
	else if (lflag)
  800abc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ac0:	74 1e                	je     800ae0 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac5:	8b 00                	mov    (%eax),%eax
  800ac7:	8d 50 04             	lea    0x4(%eax),%edx
  800aca:	8b 45 08             	mov    0x8(%ebp),%eax
  800acd:	89 10                	mov    %edx,(%eax)
  800acf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad2:	8b 00                	mov    (%eax),%eax
  800ad4:	83 e8 04             	sub    $0x4,%eax
  800ad7:	8b 00                	mov    (%eax),%eax
  800ad9:	ba 00 00 00 00       	mov    $0x0,%edx
  800ade:	eb 1c                	jmp    800afc <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae3:	8b 00                	mov    (%eax),%eax
  800ae5:	8d 50 04             	lea    0x4(%eax),%edx
  800ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  800aeb:	89 10                	mov    %edx,(%eax)
  800aed:	8b 45 08             	mov    0x8(%ebp),%eax
  800af0:	8b 00                	mov    (%eax),%eax
  800af2:	83 e8 04             	sub    $0x4,%eax
  800af5:	8b 00                	mov    (%eax),%eax
  800af7:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800afc:	5d                   	pop    %ebp
  800afd:	c3                   	ret    

00800afe <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800afe:	55                   	push   %ebp
  800aff:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b01:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b05:	7e 1c                	jle    800b23 <getint+0x25>
		return va_arg(*ap, long long);
  800b07:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0a:	8b 00                	mov    (%eax),%eax
  800b0c:	8d 50 08             	lea    0x8(%eax),%edx
  800b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b12:	89 10                	mov    %edx,(%eax)
  800b14:	8b 45 08             	mov    0x8(%ebp),%eax
  800b17:	8b 00                	mov    (%eax),%eax
  800b19:	83 e8 08             	sub    $0x8,%eax
  800b1c:	8b 50 04             	mov    0x4(%eax),%edx
  800b1f:	8b 00                	mov    (%eax),%eax
  800b21:	eb 38                	jmp    800b5b <getint+0x5d>
	else if (lflag)
  800b23:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b27:	74 1a                	je     800b43 <getint+0x45>
		return va_arg(*ap, long);
  800b29:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2c:	8b 00                	mov    (%eax),%eax
  800b2e:	8d 50 04             	lea    0x4(%eax),%edx
  800b31:	8b 45 08             	mov    0x8(%ebp),%eax
  800b34:	89 10                	mov    %edx,(%eax)
  800b36:	8b 45 08             	mov    0x8(%ebp),%eax
  800b39:	8b 00                	mov    (%eax),%eax
  800b3b:	83 e8 04             	sub    $0x4,%eax
  800b3e:	8b 00                	mov    (%eax),%eax
  800b40:	99                   	cltd   
  800b41:	eb 18                	jmp    800b5b <getint+0x5d>
	else
		return va_arg(*ap, int);
  800b43:	8b 45 08             	mov    0x8(%ebp),%eax
  800b46:	8b 00                	mov    (%eax),%eax
  800b48:	8d 50 04             	lea    0x4(%eax),%edx
  800b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4e:	89 10                	mov    %edx,(%eax)
  800b50:	8b 45 08             	mov    0x8(%ebp),%eax
  800b53:	8b 00                	mov    (%eax),%eax
  800b55:	83 e8 04             	sub    $0x4,%eax
  800b58:	8b 00                	mov    (%eax),%eax
  800b5a:	99                   	cltd   
}
  800b5b:	5d                   	pop    %ebp
  800b5c:	c3                   	ret    

00800b5d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b5d:	55                   	push   %ebp
  800b5e:	89 e5                	mov    %esp,%ebp
  800b60:	56                   	push   %esi
  800b61:	53                   	push   %ebx
  800b62:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b65:	eb 17                	jmp    800b7e <vprintfmt+0x21>
			if (ch == '\0')
  800b67:	85 db                	test   %ebx,%ebx
  800b69:	0f 84 af 03 00 00    	je     800f1e <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800b6f:	83 ec 08             	sub    $0x8,%esp
  800b72:	ff 75 0c             	pushl  0xc(%ebp)
  800b75:	53                   	push   %ebx
  800b76:	8b 45 08             	mov    0x8(%ebp),%eax
  800b79:	ff d0                	call   *%eax
  800b7b:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b7e:	8b 45 10             	mov    0x10(%ebp),%eax
  800b81:	8d 50 01             	lea    0x1(%eax),%edx
  800b84:	89 55 10             	mov    %edx,0x10(%ebp)
  800b87:	8a 00                	mov    (%eax),%al
  800b89:	0f b6 d8             	movzbl %al,%ebx
  800b8c:	83 fb 25             	cmp    $0x25,%ebx
  800b8f:	75 d6                	jne    800b67 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800b91:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800b95:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800b9c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800ba3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800baa:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800bb1:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb4:	8d 50 01             	lea    0x1(%eax),%edx
  800bb7:	89 55 10             	mov    %edx,0x10(%ebp)
  800bba:	8a 00                	mov    (%eax),%al
  800bbc:	0f b6 d8             	movzbl %al,%ebx
  800bbf:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800bc2:	83 f8 55             	cmp    $0x55,%eax
  800bc5:	0f 87 2b 03 00 00    	ja     800ef6 <vprintfmt+0x399>
  800bcb:	8b 04 85 b8 3e 80 00 	mov    0x803eb8(,%eax,4),%eax
  800bd2:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800bd4:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800bd8:	eb d7                	jmp    800bb1 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800bda:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800bde:	eb d1                	jmp    800bb1 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800be0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800be7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800bea:	89 d0                	mov    %edx,%eax
  800bec:	c1 e0 02             	shl    $0x2,%eax
  800bef:	01 d0                	add    %edx,%eax
  800bf1:	01 c0                	add    %eax,%eax
  800bf3:	01 d8                	add    %ebx,%eax
  800bf5:	83 e8 30             	sub    $0x30,%eax
  800bf8:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800bfb:	8b 45 10             	mov    0x10(%ebp),%eax
  800bfe:	8a 00                	mov    (%eax),%al
  800c00:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c03:	83 fb 2f             	cmp    $0x2f,%ebx
  800c06:	7e 3e                	jle    800c46 <vprintfmt+0xe9>
  800c08:	83 fb 39             	cmp    $0x39,%ebx
  800c0b:	7f 39                	jg     800c46 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c0d:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c10:	eb d5                	jmp    800be7 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c12:	8b 45 14             	mov    0x14(%ebp),%eax
  800c15:	83 c0 04             	add    $0x4,%eax
  800c18:	89 45 14             	mov    %eax,0x14(%ebp)
  800c1b:	8b 45 14             	mov    0x14(%ebp),%eax
  800c1e:	83 e8 04             	sub    $0x4,%eax
  800c21:	8b 00                	mov    (%eax),%eax
  800c23:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800c26:	eb 1f                	jmp    800c47 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800c28:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c2c:	79 83                	jns    800bb1 <vprintfmt+0x54>
				width = 0;
  800c2e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800c35:	e9 77 ff ff ff       	jmp    800bb1 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800c3a:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800c41:	e9 6b ff ff ff       	jmp    800bb1 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c46:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c47:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c4b:	0f 89 60 ff ff ff    	jns    800bb1 <vprintfmt+0x54>
				width = precision, precision = -1;
  800c51:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c54:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c57:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800c5e:	e9 4e ff ff ff       	jmp    800bb1 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c63:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800c66:	e9 46 ff ff ff       	jmp    800bb1 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800c6b:	8b 45 14             	mov    0x14(%ebp),%eax
  800c6e:	83 c0 04             	add    $0x4,%eax
  800c71:	89 45 14             	mov    %eax,0x14(%ebp)
  800c74:	8b 45 14             	mov    0x14(%ebp),%eax
  800c77:	83 e8 04             	sub    $0x4,%eax
  800c7a:	8b 00                	mov    (%eax),%eax
  800c7c:	83 ec 08             	sub    $0x8,%esp
  800c7f:	ff 75 0c             	pushl  0xc(%ebp)
  800c82:	50                   	push   %eax
  800c83:	8b 45 08             	mov    0x8(%ebp),%eax
  800c86:	ff d0                	call   *%eax
  800c88:	83 c4 10             	add    $0x10,%esp
			break;
  800c8b:	e9 89 02 00 00       	jmp    800f19 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800c90:	8b 45 14             	mov    0x14(%ebp),%eax
  800c93:	83 c0 04             	add    $0x4,%eax
  800c96:	89 45 14             	mov    %eax,0x14(%ebp)
  800c99:	8b 45 14             	mov    0x14(%ebp),%eax
  800c9c:	83 e8 04             	sub    $0x4,%eax
  800c9f:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ca1:	85 db                	test   %ebx,%ebx
  800ca3:	79 02                	jns    800ca7 <vprintfmt+0x14a>
				err = -err;
  800ca5:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ca7:	83 fb 64             	cmp    $0x64,%ebx
  800caa:	7f 0b                	jg     800cb7 <vprintfmt+0x15a>
  800cac:	8b 34 9d 00 3d 80 00 	mov    0x803d00(,%ebx,4),%esi
  800cb3:	85 f6                	test   %esi,%esi
  800cb5:	75 19                	jne    800cd0 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800cb7:	53                   	push   %ebx
  800cb8:	68 a5 3e 80 00       	push   $0x803ea5
  800cbd:	ff 75 0c             	pushl  0xc(%ebp)
  800cc0:	ff 75 08             	pushl  0x8(%ebp)
  800cc3:	e8 5e 02 00 00       	call   800f26 <printfmt>
  800cc8:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ccb:	e9 49 02 00 00       	jmp    800f19 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800cd0:	56                   	push   %esi
  800cd1:	68 ae 3e 80 00       	push   $0x803eae
  800cd6:	ff 75 0c             	pushl  0xc(%ebp)
  800cd9:	ff 75 08             	pushl  0x8(%ebp)
  800cdc:	e8 45 02 00 00       	call   800f26 <printfmt>
  800ce1:	83 c4 10             	add    $0x10,%esp
			break;
  800ce4:	e9 30 02 00 00       	jmp    800f19 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ce9:	8b 45 14             	mov    0x14(%ebp),%eax
  800cec:	83 c0 04             	add    $0x4,%eax
  800cef:	89 45 14             	mov    %eax,0x14(%ebp)
  800cf2:	8b 45 14             	mov    0x14(%ebp),%eax
  800cf5:	83 e8 04             	sub    $0x4,%eax
  800cf8:	8b 30                	mov    (%eax),%esi
  800cfa:	85 f6                	test   %esi,%esi
  800cfc:	75 05                	jne    800d03 <vprintfmt+0x1a6>
				p = "(null)";
  800cfe:	be b1 3e 80 00       	mov    $0x803eb1,%esi
			if (width > 0 && padc != '-')
  800d03:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d07:	7e 6d                	jle    800d76 <vprintfmt+0x219>
  800d09:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800d0d:	74 67                	je     800d76 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d0f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d12:	83 ec 08             	sub    $0x8,%esp
  800d15:	50                   	push   %eax
  800d16:	56                   	push   %esi
  800d17:	e8 0c 03 00 00       	call   801028 <strnlen>
  800d1c:	83 c4 10             	add    $0x10,%esp
  800d1f:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800d22:	eb 16                	jmp    800d3a <vprintfmt+0x1dd>
					putch(padc, putdat);
  800d24:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800d28:	83 ec 08             	sub    $0x8,%esp
  800d2b:	ff 75 0c             	pushl  0xc(%ebp)
  800d2e:	50                   	push   %eax
  800d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d32:	ff d0                	call   *%eax
  800d34:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d37:	ff 4d e4             	decl   -0x1c(%ebp)
  800d3a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d3e:	7f e4                	jg     800d24 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d40:	eb 34                	jmp    800d76 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800d42:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d46:	74 1c                	je     800d64 <vprintfmt+0x207>
  800d48:	83 fb 1f             	cmp    $0x1f,%ebx
  800d4b:	7e 05                	jle    800d52 <vprintfmt+0x1f5>
  800d4d:	83 fb 7e             	cmp    $0x7e,%ebx
  800d50:	7e 12                	jle    800d64 <vprintfmt+0x207>
					putch('?', putdat);
  800d52:	83 ec 08             	sub    $0x8,%esp
  800d55:	ff 75 0c             	pushl  0xc(%ebp)
  800d58:	6a 3f                	push   $0x3f
  800d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5d:	ff d0                	call   *%eax
  800d5f:	83 c4 10             	add    $0x10,%esp
  800d62:	eb 0f                	jmp    800d73 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800d64:	83 ec 08             	sub    $0x8,%esp
  800d67:	ff 75 0c             	pushl  0xc(%ebp)
  800d6a:	53                   	push   %ebx
  800d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6e:	ff d0                	call   *%eax
  800d70:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d73:	ff 4d e4             	decl   -0x1c(%ebp)
  800d76:	89 f0                	mov    %esi,%eax
  800d78:	8d 70 01             	lea    0x1(%eax),%esi
  800d7b:	8a 00                	mov    (%eax),%al
  800d7d:	0f be d8             	movsbl %al,%ebx
  800d80:	85 db                	test   %ebx,%ebx
  800d82:	74 24                	je     800da8 <vprintfmt+0x24b>
  800d84:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d88:	78 b8                	js     800d42 <vprintfmt+0x1e5>
  800d8a:	ff 4d e0             	decl   -0x20(%ebp)
  800d8d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d91:	79 af                	jns    800d42 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d93:	eb 13                	jmp    800da8 <vprintfmt+0x24b>
				putch(' ', putdat);
  800d95:	83 ec 08             	sub    $0x8,%esp
  800d98:	ff 75 0c             	pushl  0xc(%ebp)
  800d9b:	6a 20                	push   $0x20
  800d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800da0:	ff d0                	call   *%eax
  800da2:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800da5:	ff 4d e4             	decl   -0x1c(%ebp)
  800da8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dac:	7f e7                	jg     800d95 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800dae:	e9 66 01 00 00       	jmp    800f19 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800db3:	83 ec 08             	sub    $0x8,%esp
  800db6:	ff 75 e8             	pushl  -0x18(%ebp)
  800db9:	8d 45 14             	lea    0x14(%ebp),%eax
  800dbc:	50                   	push   %eax
  800dbd:	e8 3c fd ff ff       	call   800afe <getint>
  800dc2:	83 c4 10             	add    $0x10,%esp
  800dc5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dc8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800dcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dd1:	85 d2                	test   %edx,%edx
  800dd3:	79 23                	jns    800df8 <vprintfmt+0x29b>
				putch('-', putdat);
  800dd5:	83 ec 08             	sub    $0x8,%esp
  800dd8:	ff 75 0c             	pushl  0xc(%ebp)
  800ddb:	6a 2d                	push   $0x2d
  800ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  800de0:	ff d0                	call   *%eax
  800de2:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800de5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800de8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800deb:	f7 d8                	neg    %eax
  800ded:	83 d2 00             	adc    $0x0,%edx
  800df0:	f7 da                	neg    %edx
  800df2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800df5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800df8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800dff:	e9 bc 00 00 00       	jmp    800ec0 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e04:	83 ec 08             	sub    $0x8,%esp
  800e07:	ff 75 e8             	pushl  -0x18(%ebp)
  800e0a:	8d 45 14             	lea    0x14(%ebp),%eax
  800e0d:	50                   	push   %eax
  800e0e:	e8 84 fc ff ff       	call   800a97 <getuint>
  800e13:	83 c4 10             	add    $0x10,%esp
  800e16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e19:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800e1c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e23:	e9 98 00 00 00       	jmp    800ec0 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e28:	83 ec 08             	sub    $0x8,%esp
  800e2b:	ff 75 0c             	pushl  0xc(%ebp)
  800e2e:	6a 58                	push   $0x58
  800e30:	8b 45 08             	mov    0x8(%ebp),%eax
  800e33:	ff d0                	call   *%eax
  800e35:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e38:	83 ec 08             	sub    $0x8,%esp
  800e3b:	ff 75 0c             	pushl  0xc(%ebp)
  800e3e:	6a 58                	push   $0x58
  800e40:	8b 45 08             	mov    0x8(%ebp),%eax
  800e43:	ff d0                	call   *%eax
  800e45:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e48:	83 ec 08             	sub    $0x8,%esp
  800e4b:	ff 75 0c             	pushl  0xc(%ebp)
  800e4e:	6a 58                	push   $0x58
  800e50:	8b 45 08             	mov    0x8(%ebp),%eax
  800e53:	ff d0                	call   *%eax
  800e55:	83 c4 10             	add    $0x10,%esp
			break;
  800e58:	e9 bc 00 00 00       	jmp    800f19 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800e5d:	83 ec 08             	sub    $0x8,%esp
  800e60:	ff 75 0c             	pushl  0xc(%ebp)
  800e63:	6a 30                	push   $0x30
  800e65:	8b 45 08             	mov    0x8(%ebp),%eax
  800e68:	ff d0                	call   *%eax
  800e6a:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800e6d:	83 ec 08             	sub    $0x8,%esp
  800e70:	ff 75 0c             	pushl  0xc(%ebp)
  800e73:	6a 78                	push   $0x78
  800e75:	8b 45 08             	mov    0x8(%ebp),%eax
  800e78:	ff d0                	call   *%eax
  800e7a:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800e7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800e80:	83 c0 04             	add    $0x4,%eax
  800e83:	89 45 14             	mov    %eax,0x14(%ebp)
  800e86:	8b 45 14             	mov    0x14(%ebp),%eax
  800e89:	83 e8 04             	sub    $0x4,%eax
  800e8c:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e91:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800e98:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800e9f:	eb 1f                	jmp    800ec0 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ea1:	83 ec 08             	sub    $0x8,%esp
  800ea4:	ff 75 e8             	pushl  -0x18(%ebp)
  800ea7:	8d 45 14             	lea    0x14(%ebp),%eax
  800eaa:	50                   	push   %eax
  800eab:	e8 e7 fb ff ff       	call   800a97 <getuint>
  800eb0:	83 c4 10             	add    $0x10,%esp
  800eb3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800eb6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800eb9:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ec0:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ec4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ec7:	83 ec 04             	sub    $0x4,%esp
  800eca:	52                   	push   %edx
  800ecb:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ece:	50                   	push   %eax
  800ecf:	ff 75 f4             	pushl  -0xc(%ebp)
  800ed2:	ff 75 f0             	pushl  -0x10(%ebp)
  800ed5:	ff 75 0c             	pushl  0xc(%ebp)
  800ed8:	ff 75 08             	pushl  0x8(%ebp)
  800edb:	e8 00 fb ff ff       	call   8009e0 <printnum>
  800ee0:	83 c4 20             	add    $0x20,%esp
			break;
  800ee3:	eb 34                	jmp    800f19 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ee5:	83 ec 08             	sub    $0x8,%esp
  800ee8:	ff 75 0c             	pushl  0xc(%ebp)
  800eeb:	53                   	push   %ebx
  800eec:	8b 45 08             	mov    0x8(%ebp),%eax
  800eef:	ff d0                	call   *%eax
  800ef1:	83 c4 10             	add    $0x10,%esp
			break;
  800ef4:	eb 23                	jmp    800f19 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ef6:	83 ec 08             	sub    $0x8,%esp
  800ef9:	ff 75 0c             	pushl  0xc(%ebp)
  800efc:	6a 25                	push   $0x25
  800efe:	8b 45 08             	mov    0x8(%ebp),%eax
  800f01:	ff d0                	call   *%eax
  800f03:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f06:	ff 4d 10             	decl   0x10(%ebp)
  800f09:	eb 03                	jmp    800f0e <vprintfmt+0x3b1>
  800f0b:	ff 4d 10             	decl   0x10(%ebp)
  800f0e:	8b 45 10             	mov    0x10(%ebp),%eax
  800f11:	48                   	dec    %eax
  800f12:	8a 00                	mov    (%eax),%al
  800f14:	3c 25                	cmp    $0x25,%al
  800f16:	75 f3                	jne    800f0b <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800f18:	90                   	nop
		}
	}
  800f19:	e9 47 fc ff ff       	jmp    800b65 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f1e:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800f1f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f22:	5b                   	pop    %ebx
  800f23:	5e                   	pop    %esi
  800f24:	5d                   	pop    %ebp
  800f25:	c3                   	ret    

00800f26 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f26:	55                   	push   %ebp
  800f27:	89 e5                	mov    %esp,%ebp
  800f29:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f2c:	8d 45 10             	lea    0x10(%ebp),%eax
  800f2f:	83 c0 04             	add    $0x4,%eax
  800f32:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f35:	8b 45 10             	mov    0x10(%ebp),%eax
  800f38:	ff 75 f4             	pushl  -0xc(%ebp)
  800f3b:	50                   	push   %eax
  800f3c:	ff 75 0c             	pushl  0xc(%ebp)
  800f3f:	ff 75 08             	pushl  0x8(%ebp)
  800f42:	e8 16 fc ff ff       	call   800b5d <vprintfmt>
  800f47:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800f4a:	90                   	nop
  800f4b:	c9                   	leave  
  800f4c:	c3                   	ret    

00800f4d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f4d:	55                   	push   %ebp
  800f4e:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800f50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f53:	8b 40 08             	mov    0x8(%eax),%eax
  800f56:	8d 50 01             	lea    0x1(%eax),%edx
  800f59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5c:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800f5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f62:	8b 10                	mov    (%eax),%edx
  800f64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f67:	8b 40 04             	mov    0x4(%eax),%eax
  800f6a:	39 c2                	cmp    %eax,%edx
  800f6c:	73 12                	jae    800f80 <sprintputch+0x33>
		*b->buf++ = ch;
  800f6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f71:	8b 00                	mov    (%eax),%eax
  800f73:	8d 48 01             	lea    0x1(%eax),%ecx
  800f76:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f79:	89 0a                	mov    %ecx,(%edx)
  800f7b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f7e:	88 10                	mov    %dl,(%eax)
}
  800f80:	90                   	nop
  800f81:	5d                   	pop    %ebp
  800f82:	c3                   	ret    

00800f83 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f83:	55                   	push   %ebp
  800f84:	89 e5                	mov    %esp,%ebp
  800f86:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f89:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800f8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f92:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f95:	8b 45 08             	mov    0x8(%ebp),%eax
  800f98:	01 d0                	add    %edx,%eax
  800f9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f9d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800fa4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fa8:	74 06                	je     800fb0 <vsnprintf+0x2d>
  800faa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fae:	7f 07                	jg     800fb7 <vsnprintf+0x34>
		return -E_INVAL;
  800fb0:	b8 03 00 00 00       	mov    $0x3,%eax
  800fb5:	eb 20                	jmp    800fd7 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800fb7:	ff 75 14             	pushl  0x14(%ebp)
  800fba:	ff 75 10             	pushl  0x10(%ebp)
  800fbd:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800fc0:	50                   	push   %eax
  800fc1:	68 4d 0f 80 00       	push   $0x800f4d
  800fc6:	e8 92 fb ff ff       	call   800b5d <vprintfmt>
  800fcb:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800fce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fd1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800fd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800fd7:	c9                   	leave  
  800fd8:	c3                   	ret    

00800fd9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800fd9:	55                   	push   %ebp
  800fda:	89 e5                	mov    %esp,%ebp
  800fdc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800fdf:	8d 45 10             	lea    0x10(%ebp),%eax
  800fe2:	83 c0 04             	add    $0x4,%eax
  800fe5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800fe8:	8b 45 10             	mov    0x10(%ebp),%eax
  800feb:	ff 75 f4             	pushl  -0xc(%ebp)
  800fee:	50                   	push   %eax
  800fef:	ff 75 0c             	pushl  0xc(%ebp)
  800ff2:	ff 75 08             	pushl  0x8(%ebp)
  800ff5:	e8 89 ff ff ff       	call   800f83 <vsnprintf>
  800ffa:	83 c4 10             	add    $0x10,%esp
  800ffd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801000:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801003:	c9                   	leave  
  801004:	c3                   	ret    

00801005 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801005:	55                   	push   %ebp
  801006:	89 e5                	mov    %esp,%ebp
  801008:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80100b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801012:	eb 06                	jmp    80101a <strlen+0x15>
		n++;
  801014:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801017:	ff 45 08             	incl   0x8(%ebp)
  80101a:	8b 45 08             	mov    0x8(%ebp),%eax
  80101d:	8a 00                	mov    (%eax),%al
  80101f:	84 c0                	test   %al,%al
  801021:	75 f1                	jne    801014 <strlen+0xf>
		n++;
	return n;
  801023:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801026:	c9                   	leave  
  801027:	c3                   	ret    

00801028 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801028:	55                   	push   %ebp
  801029:	89 e5                	mov    %esp,%ebp
  80102b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80102e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801035:	eb 09                	jmp    801040 <strnlen+0x18>
		n++;
  801037:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80103a:	ff 45 08             	incl   0x8(%ebp)
  80103d:	ff 4d 0c             	decl   0xc(%ebp)
  801040:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801044:	74 09                	je     80104f <strnlen+0x27>
  801046:	8b 45 08             	mov    0x8(%ebp),%eax
  801049:	8a 00                	mov    (%eax),%al
  80104b:	84 c0                	test   %al,%al
  80104d:	75 e8                	jne    801037 <strnlen+0xf>
		n++;
	return n;
  80104f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801052:	c9                   	leave  
  801053:	c3                   	ret    

00801054 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801054:	55                   	push   %ebp
  801055:	89 e5                	mov    %esp,%ebp
  801057:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80105a:	8b 45 08             	mov    0x8(%ebp),%eax
  80105d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801060:	90                   	nop
  801061:	8b 45 08             	mov    0x8(%ebp),%eax
  801064:	8d 50 01             	lea    0x1(%eax),%edx
  801067:	89 55 08             	mov    %edx,0x8(%ebp)
  80106a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80106d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801070:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801073:	8a 12                	mov    (%edx),%dl
  801075:	88 10                	mov    %dl,(%eax)
  801077:	8a 00                	mov    (%eax),%al
  801079:	84 c0                	test   %al,%al
  80107b:	75 e4                	jne    801061 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80107d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801080:	c9                   	leave  
  801081:	c3                   	ret    

00801082 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801082:	55                   	push   %ebp
  801083:	89 e5                	mov    %esp,%ebp
  801085:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801088:	8b 45 08             	mov    0x8(%ebp),%eax
  80108b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80108e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801095:	eb 1f                	jmp    8010b6 <strncpy+0x34>
		*dst++ = *src;
  801097:	8b 45 08             	mov    0x8(%ebp),%eax
  80109a:	8d 50 01             	lea    0x1(%eax),%edx
  80109d:	89 55 08             	mov    %edx,0x8(%ebp)
  8010a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010a3:	8a 12                	mov    (%edx),%dl
  8010a5:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010aa:	8a 00                	mov    (%eax),%al
  8010ac:	84 c0                	test   %al,%al
  8010ae:	74 03                	je     8010b3 <strncpy+0x31>
			src++;
  8010b0:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8010b3:	ff 45 fc             	incl   -0x4(%ebp)
  8010b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010b9:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010bc:	72 d9                	jb     801097 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8010be:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010c1:	c9                   	leave  
  8010c2:	c3                   	ret    

008010c3 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8010c3:	55                   	push   %ebp
  8010c4:	89 e5                	mov    %esp,%ebp
  8010c6:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8010c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8010cf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010d3:	74 30                	je     801105 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8010d5:	eb 16                	jmp    8010ed <strlcpy+0x2a>
			*dst++ = *src++;
  8010d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010da:	8d 50 01             	lea    0x1(%eax),%edx
  8010dd:	89 55 08             	mov    %edx,0x8(%ebp)
  8010e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010e3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010e6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010e9:	8a 12                	mov    (%edx),%dl
  8010eb:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8010ed:	ff 4d 10             	decl   0x10(%ebp)
  8010f0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010f4:	74 09                	je     8010ff <strlcpy+0x3c>
  8010f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f9:	8a 00                	mov    (%eax),%al
  8010fb:	84 c0                	test   %al,%al
  8010fd:	75 d8                	jne    8010d7 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8010ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801102:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801105:	8b 55 08             	mov    0x8(%ebp),%edx
  801108:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80110b:	29 c2                	sub    %eax,%edx
  80110d:	89 d0                	mov    %edx,%eax
}
  80110f:	c9                   	leave  
  801110:	c3                   	ret    

00801111 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801111:	55                   	push   %ebp
  801112:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801114:	eb 06                	jmp    80111c <strcmp+0xb>
		p++, q++;
  801116:	ff 45 08             	incl   0x8(%ebp)
  801119:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80111c:	8b 45 08             	mov    0x8(%ebp),%eax
  80111f:	8a 00                	mov    (%eax),%al
  801121:	84 c0                	test   %al,%al
  801123:	74 0e                	je     801133 <strcmp+0x22>
  801125:	8b 45 08             	mov    0x8(%ebp),%eax
  801128:	8a 10                	mov    (%eax),%dl
  80112a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112d:	8a 00                	mov    (%eax),%al
  80112f:	38 c2                	cmp    %al,%dl
  801131:	74 e3                	je     801116 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801133:	8b 45 08             	mov    0x8(%ebp),%eax
  801136:	8a 00                	mov    (%eax),%al
  801138:	0f b6 d0             	movzbl %al,%edx
  80113b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113e:	8a 00                	mov    (%eax),%al
  801140:	0f b6 c0             	movzbl %al,%eax
  801143:	29 c2                	sub    %eax,%edx
  801145:	89 d0                	mov    %edx,%eax
}
  801147:	5d                   	pop    %ebp
  801148:	c3                   	ret    

00801149 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801149:	55                   	push   %ebp
  80114a:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80114c:	eb 09                	jmp    801157 <strncmp+0xe>
		n--, p++, q++;
  80114e:	ff 4d 10             	decl   0x10(%ebp)
  801151:	ff 45 08             	incl   0x8(%ebp)
  801154:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801157:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80115b:	74 17                	je     801174 <strncmp+0x2b>
  80115d:	8b 45 08             	mov    0x8(%ebp),%eax
  801160:	8a 00                	mov    (%eax),%al
  801162:	84 c0                	test   %al,%al
  801164:	74 0e                	je     801174 <strncmp+0x2b>
  801166:	8b 45 08             	mov    0x8(%ebp),%eax
  801169:	8a 10                	mov    (%eax),%dl
  80116b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116e:	8a 00                	mov    (%eax),%al
  801170:	38 c2                	cmp    %al,%dl
  801172:	74 da                	je     80114e <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801174:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801178:	75 07                	jne    801181 <strncmp+0x38>
		return 0;
  80117a:	b8 00 00 00 00       	mov    $0x0,%eax
  80117f:	eb 14                	jmp    801195 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801181:	8b 45 08             	mov    0x8(%ebp),%eax
  801184:	8a 00                	mov    (%eax),%al
  801186:	0f b6 d0             	movzbl %al,%edx
  801189:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118c:	8a 00                	mov    (%eax),%al
  80118e:	0f b6 c0             	movzbl %al,%eax
  801191:	29 c2                	sub    %eax,%edx
  801193:	89 d0                	mov    %edx,%eax
}
  801195:	5d                   	pop    %ebp
  801196:	c3                   	ret    

00801197 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801197:	55                   	push   %ebp
  801198:	89 e5                	mov    %esp,%ebp
  80119a:	83 ec 04             	sub    $0x4,%esp
  80119d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011a3:	eb 12                	jmp    8011b7 <strchr+0x20>
		if (*s == c)
  8011a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a8:	8a 00                	mov    (%eax),%al
  8011aa:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011ad:	75 05                	jne    8011b4 <strchr+0x1d>
			return (char *) s;
  8011af:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b2:	eb 11                	jmp    8011c5 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8011b4:	ff 45 08             	incl   0x8(%ebp)
  8011b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ba:	8a 00                	mov    (%eax),%al
  8011bc:	84 c0                	test   %al,%al
  8011be:	75 e5                	jne    8011a5 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8011c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011c5:	c9                   	leave  
  8011c6:	c3                   	ret    

008011c7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011c7:	55                   	push   %ebp
  8011c8:	89 e5                	mov    %esp,%ebp
  8011ca:	83 ec 04             	sub    $0x4,%esp
  8011cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011d3:	eb 0d                	jmp    8011e2 <strfind+0x1b>
		if (*s == c)
  8011d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d8:	8a 00                	mov    (%eax),%al
  8011da:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011dd:	74 0e                	je     8011ed <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8011df:	ff 45 08             	incl   0x8(%ebp)
  8011e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e5:	8a 00                	mov    (%eax),%al
  8011e7:	84 c0                	test   %al,%al
  8011e9:	75 ea                	jne    8011d5 <strfind+0xe>
  8011eb:	eb 01                	jmp    8011ee <strfind+0x27>
		if (*s == c)
			break;
  8011ed:	90                   	nop
	return (char *) s;
  8011ee:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011f1:	c9                   	leave  
  8011f2:	c3                   	ret    

008011f3 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8011f3:	55                   	push   %ebp
  8011f4:	89 e5                	mov    %esp,%ebp
  8011f6:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8011f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8011ff:	8b 45 10             	mov    0x10(%ebp),%eax
  801202:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801205:	eb 0e                	jmp    801215 <memset+0x22>
		*p++ = c;
  801207:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80120a:	8d 50 01             	lea    0x1(%eax),%edx
  80120d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801210:	8b 55 0c             	mov    0xc(%ebp),%edx
  801213:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801215:	ff 4d f8             	decl   -0x8(%ebp)
  801218:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80121c:	79 e9                	jns    801207 <memset+0x14>
		*p++ = c;

	return v;
  80121e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801221:	c9                   	leave  
  801222:	c3                   	ret    

00801223 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801223:	55                   	push   %ebp
  801224:	89 e5                	mov    %esp,%ebp
  801226:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801229:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80122f:	8b 45 08             	mov    0x8(%ebp),%eax
  801232:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801235:	eb 16                	jmp    80124d <memcpy+0x2a>
		*d++ = *s++;
  801237:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80123a:	8d 50 01             	lea    0x1(%eax),%edx
  80123d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801240:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801243:	8d 4a 01             	lea    0x1(%edx),%ecx
  801246:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801249:	8a 12                	mov    (%edx),%dl
  80124b:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80124d:	8b 45 10             	mov    0x10(%ebp),%eax
  801250:	8d 50 ff             	lea    -0x1(%eax),%edx
  801253:	89 55 10             	mov    %edx,0x10(%ebp)
  801256:	85 c0                	test   %eax,%eax
  801258:	75 dd                	jne    801237 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80125a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80125d:	c9                   	leave  
  80125e:	c3                   	ret    

0080125f <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80125f:	55                   	push   %ebp
  801260:	89 e5                	mov    %esp,%ebp
  801262:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801265:	8b 45 0c             	mov    0xc(%ebp),%eax
  801268:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80126b:	8b 45 08             	mov    0x8(%ebp),%eax
  80126e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801271:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801274:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801277:	73 50                	jae    8012c9 <memmove+0x6a>
  801279:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80127c:	8b 45 10             	mov    0x10(%ebp),%eax
  80127f:	01 d0                	add    %edx,%eax
  801281:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801284:	76 43                	jbe    8012c9 <memmove+0x6a>
		s += n;
  801286:	8b 45 10             	mov    0x10(%ebp),%eax
  801289:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80128c:	8b 45 10             	mov    0x10(%ebp),%eax
  80128f:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801292:	eb 10                	jmp    8012a4 <memmove+0x45>
			*--d = *--s;
  801294:	ff 4d f8             	decl   -0x8(%ebp)
  801297:	ff 4d fc             	decl   -0x4(%ebp)
  80129a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80129d:	8a 10                	mov    (%eax),%dl
  80129f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012a2:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8012a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012aa:	89 55 10             	mov    %edx,0x10(%ebp)
  8012ad:	85 c0                	test   %eax,%eax
  8012af:	75 e3                	jne    801294 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8012b1:	eb 23                	jmp    8012d6 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8012b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012b6:	8d 50 01             	lea    0x1(%eax),%edx
  8012b9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012bc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012bf:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012c2:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8012c5:	8a 12                	mov    (%edx),%dl
  8012c7:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8012c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8012cc:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012cf:	89 55 10             	mov    %edx,0x10(%ebp)
  8012d2:	85 c0                	test   %eax,%eax
  8012d4:	75 dd                	jne    8012b3 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8012d6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012d9:	c9                   	leave  
  8012da:	c3                   	ret    

008012db <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8012db:	55                   	push   %ebp
  8012dc:	89 e5                	mov    %esp,%ebp
  8012de:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8012e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8012e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ea:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8012ed:	eb 2a                	jmp    801319 <memcmp+0x3e>
		if (*s1 != *s2)
  8012ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012f2:	8a 10                	mov    (%eax),%dl
  8012f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012f7:	8a 00                	mov    (%eax),%al
  8012f9:	38 c2                	cmp    %al,%dl
  8012fb:	74 16                	je     801313 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8012fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801300:	8a 00                	mov    (%eax),%al
  801302:	0f b6 d0             	movzbl %al,%edx
  801305:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801308:	8a 00                	mov    (%eax),%al
  80130a:	0f b6 c0             	movzbl %al,%eax
  80130d:	29 c2                	sub    %eax,%edx
  80130f:	89 d0                	mov    %edx,%eax
  801311:	eb 18                	jmp    80132b <memcmp+0x50>
		s1++, s2++;
  801313:	ff 45 fc             	incl   -0x4(%ebp)
  801316:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801319:	8b 45 10             	mov    0x10(%ebp),%eax
  80131c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80131f:	89 55 10             	mov    %edx,0x10(%ebp)
  801322:	85 c0                	test   %eax,%eax
  801324:	75 c9                	jne    8012ef <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801326:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80132b:	c9                   	leave  
  80132c:	c3                   	ret    

0080132d <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80132d:	55                   	push   %ebp
  80132e:	89 e5                	mov    %esp,%ebp
  801330:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801333:	8b 55 08             	mov    0x8(%ebp),%edx
  801336:	8b 45 10             	mov    0x10(%ebp),%eax
  801339:	01 d0                	add    %edx,%eax
  80133b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80133e:	eb 15                	jmp    801355 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801340:	8b 45 08             	mov    0x8(%ebp),%eax
  801343:	8a 00                	mov    (%eax),%al
  801345:	0f b6 d0             	movzbl %al,%edx
  801348:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134b:	0f b6 c0             	movzbl %al,%eax
  80134e:	39 c2                	cmp    %eax,%edx
  801350:	74 0d                	je     80135f <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801352:	ff 45 08             	incl   0x8(%ebp)
  801355:	8b 45 08             	mov    0x8(%ebp),%eax
  801358:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80135b:	72 e3                	jb     801340 <memfind+0x13>
  80135d:	eb 01                	jmp    801360 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80135f:	90                   	nop
	return (void *) s;
  801360:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801363:	c9                   	leave  
  801364:	c3                   	ret    

00801365 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801365:	55                   	push   %ebp
  801366:	89 e5                	mov    %esp,%ebp
  801368:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80136b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801372:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801379:	eb 03                	jmp    80137e <strtol+0x19>
		s++;
  80137b:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80137e:	8b 45 08             	mov    0x8(%ebp),%eax
  801381:	8a 00                	mov    (%eax),%al
  801383:	3c 20                	cmp    $0x20,%al
  801385:	74 f4                	je     80137b <strtol+0x16>
  801387:	8b 45 08             	mov    0x8(%ebp),%eax
  80138a:	8a 00                	mov    (%eax),%al
  80138c:	3c 09                	cmp    $0x9,%al
  80138e:	74 eb                	je     80137b <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801390:	8b 45 08             	mov    0x8(%ebp),%eax
  801393:	8a 00                	mov    (%eax),%al
  801395:	3c 2b                	cmp    $0x2b,%al
  801397:	75 05                	jne    80139e <strtol+0x39>
		s++;
  801399:	ff 45 08             	incl   0x8(%ebp)
  80139c:	eb 13                	jmp    8013b1 <strtol+0x4c>
	else if (*s == '-')
  80139e:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a1:	8a 00                	mov    (%eax),%al
  8013a3:	3c 2d                	cmp    $0x2d,%al
  8013a5:	75 0a                	jne    8013b1 <strtol+0x4c>
		s++, neg = 1;
  8013a7:	ff 45 08             	incl   0x8(%ebp)
  8013aa:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013b1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013b5:	74 06                	je     8013bd <strtol+0x58>
  8013b7:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8013bb:	75 20                	jne    8013dd <strtol+0x78>
  8013bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c0:	8a 00                	mov    (%eax),%al
  8013c2:	3c 30                	cmp    $0x30,%al
  8013c4:	75 17                	jne    8013dd <strtol+0x78>
  8013c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c9:	40                   	inc    %eax
  8013ca:	8a 00                	mov    (%eax),%al
  8013cc:	3c 78                	cmp    $0x78,%al
  8013ce:	75 0d                	jne    8013dd <strtol+0x78>
		s += 2, base = 16;
  8013d0:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8013d4:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8013db:	eb 28                	jmp    801405 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8013dd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013e1:	75 15                	jne    8013f8 <strtol+0x93>
  8013e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e6:	8a 00                	mov    (%eax),%al
  8013e8:	3c 30                	cmp    $0x30,%al
  8013ea:	75 0c                	jne    8013f8 <strtol+0x93>
		s++, base = 8;
  8013ec:	ff 45 08             	incl   0x8(%ebp)
  8013ef:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8013f6:	eb 0d                	jmp    801405 <strtol+0xa0>
	else if (base == 0)
  8013f8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013fc:	75 07                	jne    801405 <strtol+0xa0>
		base = 10;
  8013fe:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801405:	8b 45 08             	mov    0x8(%ebp),%eax
  801408:	8a 00                	mov    (%eax),%al
  80140a:	3c 2f                	cmp    $0x2f,%al
  80140c:	7e 19                	jle    801427 <strtol+0xc2>
  80140e:	8b 45 08             	mov    0x8(%ebp),%eax
  801411:	8a 00                	mov    (%eax),%al
  801413:	3c 39                	cmp    $0x39,%al
  801415:	7f 10                	jg     801427 <strtol+0xc2>
			dig = *s - '0';
  801417:	8b 45 08             	mov    0x8(%ebp),%eax
  80141a:	8a 00                	mov    (%eax),%al
  80141c:	0f be c0             	movsbl %al,%eax
  80141f:	83 e8 30             	sub    $0x30,%eax
  801422:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801425:	eb 42                	jmp    801469 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801427:	8b 45 08             	mov    0x8(%ebp),%eax
  80142a:	8a 00                	mov    (%eax),%al
  80142c:	3c 60                	cmp    $0x60,%al
  80142e:	7e 19                	jle    801449 <strtol+0xe4>
  801430:	8b 45 08             	mov    0x8(%ebp),%eax
  801433:	8a 00                	mov    (%eax),%al
  801435:	3c 7a                	cmp    $0x7a,%al
  801437:	7f 10                	jg     801449 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801439:	8b 45 08             	mov    0x8(%ebp),%eax
  80143c:	8a 00                	mov    (%eax),%al
  80143e:	0f be c0             	movsbl %al,%eax
  801441:	83 e8 57             	sub    $0x57,%eax
  801444:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801447:	eb 20                	jmp    801469 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801449:	8b 45 08             	mov    0x8(%ebp),%eax
  80144c:	8a 00                	mov    (%eax),%al
  80144e:	3c 40                	cmp    $0x40,%al
  801450:	7e 39                	jle    80148b <strtol+0x126>
  801452:	8b 45 08             	mov    0x8(%ebp),%eax
  801455:	8a 00                	mov    (%eax),%al
  801457:	3c 5a                	cmp    $0x5a,%al
  801459:	7f 30                	jg     80148b <strtol+0x126>
			dig = *s - 'A' + 10;
  80145b:	8b 45 08             	mov    0x8(%ebp),%eax
  80145e:	8a 00                	mov    (%eax),%al
  801460:	0f be c0             	movsbl %al,%eax
  801463:	83 e8 37             	sub    $0x37,%eax
  801466:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801469:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80146c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80146f:	7d 19                	jge    80148a <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801471:	ff 45 08             	incl   0x8(%ebp)
  801474:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801477:	0f af 45 10          	imul   0x10(%ebp),%eax
  80147b:	89 c2                	mov    %eax,%edx
  80147d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801480:	01 d0                	add    %edx,%eax
  801482:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801485:	e9 7b ff ff ff       	jmp    801405 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80148a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80148b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80148f:	74 08                	je     801499 <strtol+0x134>
		*endptr = (char *) s;
  801491:	8b 45 0c             	mov    0xc(%ebp),%eax
  801494:	8b 55 08             	mov    0x8(%ebp),%edx
  801497:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801499:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80149d:	74 07                	je     8014a6 <strtol+0x141>
  80149f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014a2:	f7 d8                	neg    %eax
  8014a4:	eb 03                	jmp    8014a9 <strtol+0x144>
  8014a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014a9:	c9                   	leave  
  8014aa:	c3                   	ret    

008014ab <ltostr>:

void
ltostr(long value, char *str)
{
  8014ab:	55                   	push   %ebp
  8014ac:	89 e5                	mov    %esp,%ebp
  8014ae:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8014b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8014b8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8014bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014c3:	79 13                	jns    8014d8 <ltostr+0x2d>
	{
		neg = 1;
  8014c5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8014cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014cf:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8014d2:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8014d5:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8014d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014db:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8014e0:	99                   	cltd   
  8014e1:	f7 f9                	idiv   %ecx
  8014e3:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8014e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014e9:	8d 50 01             	lea    0x1(%eax),%edx
  8014ec:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014ef:	89 c2                	mov    %eax,%edx
  8014f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f4:	01 d0                	add    %edx,%eax
  8014f6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8014f9:	83 c2 30             	add    $0x30,%edx
  8014fc:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8014fe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801501:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801506:	f7 e9                	imul   %ecx
  801508:	c1 fa 02             	sar    $0x2,%edx
  80150b:	89 c8                	mov    %ecx,%eax
  80150d:	c1 f8 1f             	sar    $0x1f,%eax
  801510:	29 c2                	sub    %eax,%edx
  801512:	89 d0                	mov    %edx,%eax
  801514:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801517:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80151a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80151f:	f7 e9                	imul   %ecx
  801521:	c1 fa 02             	sar    $0x2,%edx
  801524:	89 c8                	mov    %ecx,%eax
  801526:	c1 f8 1f             	sar    $0x1f,%eax
  801529:	29 c2                	sub    %eax,%edx
  80152b:	89 d0                	mov    %edx,%eax
  80152d:	c1 e0 02             	shl    $0x2,%eax
  801530:	01 d0                	add    %edx,%eax
  801532:	01 c0                	add    %eax,%eax
  801534:	29 c1                	sub    %eax,%ecx
  801536:	89 ca                	mov    %ecx,%edx
  801538:	85 d2                	test   %edx,%edx
  80153a:	75 9c                	jne    8014d8 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80153c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801543:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801546:	48                   	dec    %eax
  801547:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80154a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80154e:	74 3d                	je     80158d <ltostr+0xe2>
		start = 1 ;
  801550:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801557:	eb 34                	jmp    80158d <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801559:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80155c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80155f:	01 d0                	add    %edx,%eax
  801561:	8a 00                	mov    (%eax),%al
  801563:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801566:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801569:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156c:	01 c2                	add    %eax,%edx
  80156e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801571:	8b 45 0c             	mov    0xc(%ebp),%eax
  801574:	01 c8                	add    %ecx,%eax
  801576:	8a 00                	mov    (%eax),%al
  801578:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80157a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80157d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801580:	01 c2                	add    %eax,%edx
  801582:	8a 45 eb             	mov    -0x15(%ebp),%al
  801585:	88 02                	mov    %al,(%edx)
		start++ ;
  801587:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80158a:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80158d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801590:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801593:	7c c4                	jl     801559 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801595:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801598:	8b 45 0c             	mov    0xc(%ebp),%eax
  80159b:	01 d0                	add    %edx,%eax
  80159d:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8015a0:	90                   	nop
  8015a1:	c9                   	leave  
  8015a2:	c3                   	ret    

008015a3 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8015a3:	55                   	push   %ebp
  8015a4:	89 e5                	mov    %esp,%ebp
  8015a6:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8015a9:	ff 75 08             	pushl  0x8(%ebp)
  8015ac:	e8 54 fa ff ff       	call   801005 <strlen>
  8015b1:	83 c4 04             	add    $0x4,%esp
  8015b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8015b7:	ff 75 0c             	pushl  0xc(%ebp)
  8015ba:	e8 46 fa ff ff       	call   801005 <strlen>
  8015bf:	83 c4 04             	add    $0x4,%esp
  8015c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8015c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8015cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015d3:	eb 17                	jmp    8015ec <strcconcat+0x49>
		final[s] = str1[s] ;
  8015d5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8015db:	01 c2                	add    %eax,%edx
  8015dd:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e3:	01 c8                	add    %ecx,%eax
  8015e5:	8a 00                	mov    (%eax),%al
  8015e7:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8015e9:	ff 45 fc             	incl   -0x4(%ebp)
  8015ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015ef:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8015f2:	7c e1                	jl     8015d5 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8015f4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8015fb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801602:	eb 1f                	jmp    801623 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801604:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801607:	8d 50 01             	lea    0x1(%eax),%edx
  80160a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80160d:	89 c2                	mov    %eax,%edx
  80160f:	8b 45 10             	mov    0x10(%ebp),%eax
  801612:	01 c2                	add    %eax,%edx
  801614:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801617:	8b 45 0c             	mov    0xc(%ebp),%eax
  80161a:	01 c8                	add    %ecx,%eax
  80161c:	8a 00                	mov    (%eax),%al
  80161e:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801620:	ff 45 f8             	incl   -0x8(%ebp)
  801623:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801626:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801629:	7c d9                	jl     801604 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80162b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80162e:	8b 45 10             	mov    0x10(%ebp),%eax
  801631:	01 d0                	add    %edx,%eax
  801633:	c6 00 00             	movb   $0x0,(%eax)
}
  801636:	90                   	nop
  801637:	c9                   	leave  
  801638:	c3                   	ret    

00801639 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801639:	55                   	push   %ebp
  80163a:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80163c:	8b 45 14             	mov    0x14(%ebp),%eax
  80163f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801645:	8b 45 14             	mov    0x14(%ebp),%eax
  801648:	8b 00                	mov    (%eax),%eax
  80164a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801651:	8b 45 10             	mov    0x10(%ebp),%eax
  801654:	01 d0                	add    %edx,%eax
  801656:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80165c:	eb 0c                	jmp    80166a <strsplit+0x31>
			*string++ = 0;
  80165e:	8b 45 08             	mov    0x8(%ebp),%eax
  801661:	8d 50 01             	lea    0x1(%eax),%edx
  801664:	89 55 08             	mov    %edx,0x8(%ebp)
  801667:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80166a:	8b 45 08             	mov    0x8(%ebp),%eax
  80166d:	8a 00                	mov    (%eax),%al
  80166f:	84 c0                	test   %al,%al
  801671:	74 18                	je     80168b <strsplit+0x52>
  801673:	8b 45 08             	mov    0x8(%ebp),%eax
  801676:	8a 00                	mov    (%eax),%al
  801678:	0f be c0             	movsbl %al,%eax
  80167b:	50                   	push   %eax
  80167c:	ff 75 0c             	pushl  0xc(%ebp)
  80167f:	e8 13 fb ff ff       	call   801197 <strchr>
  801684:	83 c4 08             	add    $0x8,%esp
  801687:	85 c0                	test   %eax,%eax
  801689:	75 d3                	jne    80165e <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80168b:	8b 45 08             	mov    0x8(%ebp),%eax
  80168e:	8a 00                	mov    (%eax),%al
  801690:	84 c0                	test   %al,%al
  801692:	74 5a                	je     8016ee <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801694:	8b 45 14             	mov    0x14(%ebp),%eax
  801697:	8b 00                	mov    (%eax),%eax
  801699:	83 f8 0f             	cmp    $0xf,%eax
  80169c:	75 07                	jne    8016a5 <strsplit+0x6c>
		{
			return 0;
  80169e:	b8 00 00 00 00       	mov    $0x0,%eax
  8016a3:	eb 66                	jmp    80170b <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8016a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8016a8:	8b 00                	mov    (%eax),%eax
  8016aa:	8d 48 01             	lea    0x1(%eax),%ecx
  8016ad:	8b 55 14             	mov    0x14(%ebp),%edx
  8016b0:	89 0a                	mov    %ecx,(%edx)
  8016b2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8016bc:	01 c2                	add    %eax,%edx
  8016be:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c1:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016c3:	eb 03                	jmp    8016c8 <strsplit+0x8f>
			string++;
  8016c5:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cb:	8a 00                	mov    (%eax),%al
  8016cd:	84 c0                	test   %al,%al
  8016cf:	74 8b                	je     80165c <strsplit+0x23>
  8016d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d4:	8a 00                	mov    (%eax),%al
  8016d6:	0f be c0             	movsbl %al,%eax
  8016d9:	50                   	push   %eax
  8016da:	ff 75 0c             	pushl  0xc(%ebp)
  8016dd:	e8 b5 fa ff ff       	call   801197 <strchr>
  8016e2:	83 c4 08             	add    $0x8,%esp
  8016e5:	85 c0                	test   %eax,%eax
  8016e7:	74 dc                	je     8016c5 <strsplit+0x8c>
			string++;
	}
  8016e9:	e9 6e ff ff ff       	jmp    80165c <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8016ee:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8016ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8016f2:	8b 00                	mov    (%eax),%eax
  8016f4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8016fe:	01 d0                	add    %edx,%eax
  801700:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801706:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80170b:	c9                   	leave  
  80170c:	c3                   	ret    

0080170d <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  80170d:	55                   	push   %ebp
  80170e:	89 e5                	mov    %esp,%ebp
  801710:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801713:	a1 04 50 80 00       	mov    0x805004,%eax
  801718:	85 c0                	test   %eax,%eax
  80171a:	74 1f                	je     80173b <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  80171c:	e8 1d 00 00 00       	call   80173e <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801721:	83 ec 0c             	sub    $0xc,%esp
  801724:	68 10 40 80 00       	push   $0x804010
  801729:	e8 55 f2 ff ff       	call   800983 <cprintf>
  80172e:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801731:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801738:	00 00 00 
	}
}
  80173b:	90                   	nop
  80173c:	c9                   	leave  
  80173d:	c3                   	ret    

0080173e <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80173e:	55                   	push   %ebp
  80173f:	89 e5                	mov    %esp,%ebp
  801741:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  801744:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  80174b:	00 00 00 
  80174e:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801755:	00 00 00 
  801758:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  80175f:	00 00 00 
		LIST_INIT(&AllocMemBlocksList);
  801762:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801769:	00 00 00 
  80176c:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801773:	00 00 00 
  801776:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  80177d:	00 00 00 

		MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES ;
  801780:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801787:	00 02 00 
		MemBlockNodes =(struct MemBlock*)USER_DYN_BLKS_ARRAY ;
  80178a:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801791:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801794:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801799:	2d 00 10 00 00       	sub    $0x1000,%eax
  80179e:	a3 50 50 80 00       	mov    %eax,0x805050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock),PAGE_SIZE),PERM_USER|PERM_WRITEABLE);
  8017a3:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8017aa:	a1 20 51 80 00       	mov    0x805120,%eax
  8017af:	c1 e0 04             	shl    $0x4,%eax
  8017b2:	89 c2                	mov    %eax,%edx
  8017b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017b7:	01 d0                	add    %edx,%eax
  8017b9:	48                   	dec    %eax
  8017ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8017bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8017c5:	f7 75 f0             	divl   -0x10(%ebp)
  8017c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017cb:	29 d0                	sub    %edx,%eax
  8017cd:	89 c2                	mov    %eax,%edx
  8017cf:	c7 45 e8 00 00 e0 7f 	movl   $0x7fe00000,-0x18(%ebp)
  8017d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017d9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017de:	2d 00 10 00 00       	sub    $0x1000,%eax
  8017e3:	83 ec 04             	sub    $0x4,%esp
  8017e6:	6a 06                	push   $0x6
  8017e8:	52                   	push   %edx
  8017e9:	50                   	push   %eax
  8017ea:	e8 71 05 00 00       	call   801d60 <sys_allocate_chunk>
  8017ef:	83 c4 10             	add    $0x10,%esp
		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8017f2:	a1 20 51 80 00       	mov    0x805120,%eax
  8017f7:	83 ec 0c             	sub    $0xc,%esp
  8017fa:	50                   	push   %eax
  8017fb:	e8 e6 0b 00 00       	call   8023e6 <initialize_MemBlocksList>
  801800:	83 c4 10             	add    $0x10,%esp

		struct MemBlock  *block_node;
		block_node = AvailableMemBlocksList.lh_first;
  801803:	a1 48 51 80 00       	mov    0x805148,%eax
  801808:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&(AvailableMemBlocksList),block_node);
  80180b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80180f:	75 14                	jne    801825 <initialize_dyn_block_system+0xe7>
  801811:	83 ec 04             	sub    $0x4,%esp
  801814:	68 35 40 80 00       	push   $0x804035
  801819:	6a 2b                	push   $0x2b
  80181b:	68 53 40 80 00       	push   $0x804053
  801820:	e8 aa ee ff ff       	call   8006cf <_panic>
  801825:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801828:	8b 00                	mov    (%eax),%eax
  80182a:	85 c0                	test   %eax,%eax
  80182c:	74 10                	je     80183e <initialize_dyn_block_system+0x100>
  80182e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801831:	8b 00                	mov    (%eax),%eax
  801833:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801836:	8b 52 04             	mov    0x4(%edx),%edx
  801839:	89 50 04             	mov    %edx,0x4(%eax)
  80183c:	eb 0b                	jmp    801849 <initialize_dyn_block_system+0x10b>
  80183e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801841:	8b 40 04             	mov    0x4(%eax),%eax
  801844:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801849:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80184c:	8b 40 04             	mov    0x4(%eax),%eax
  80184f:	85 c0                	test   %eax,%eax
  801851:	74 0f                	je     801862 <initialize_dyn_block_system+0x124>
  801853:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801856:	8b 40 04             	mov    0x4(%eax),%eax
  801859:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80185c:	8b 12                	mov    (%edx),%edx
  80185e:	89 10                	mov    %edx,(%eax)
  801860:	eb 0a                	jmp    80186c <initialize_dyn_block_system+0x12e>
  801862:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801865:	8b 00                	mov    (%eax),%eax
  801867:	a3 48 51 80 00       	mov    %eax,0x805148
  80186c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80186f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801875:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801878:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80187f:	a1 54 51 80 00       	mov    0x805154,%eax
  801884:	48                   	dec    %eax
  801885:	a3 54 51 80 00       	mov    %eax,0x805154
		block_node->sva = USER_HEAP_START ;
  80188a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80188d:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
		block_node->size = ((USER_HEAP_MAX - USER_HEAP_START));
  801894:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801897:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		insert_sorted_with_merge_freeList(block_node);
  80189e:	83 ec 0c             	sub    $0xc,%esp
  8018a1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8018a4:	e8 d2 13 00 00       	call   802c7b <insert_sorted_with_merge_freeList>
  8018a9:	83 c4 10             	add    $0x10,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  8018ac:	90                   	nop
  8018ad:	c9                   	leave  
  8018ae:	c3                   	ret    

008018af <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8018af:	55                   	push   %ebp
  8018b0:	89 e5                	mov    %esp,%ebp
  8018b2:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018b5:	e8 53 fe ff ff       	call   80170d <InitializeUHeap>
	if (size == 0) return NULL ;
  8018ba:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018be:	75 07                	jne    8018c7 <malloc+0x18>
  8018c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8018c5:	eb 61                	jmp    801928 <malloc+0x79>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	size= ROUNDUP(size,PAGE_SIZE);
  8018c7:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8018ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8018d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018d4:	01 d0                	add    %edx,%eax
  8018d6:	48                   	dec    %eax
  8018d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8018da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8018e2:	f7 75 f4             	divl   -0xc(%ebp)
  8018e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018e8:	29 d0                	sub    %edx,%eax
  8018ea:	89 45 08             	mov    %eax,0x8(%ebp)
	    			if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8018ed:	e8 3c 08 00 00       	call   80212e <sys_isUHeapPlacementStrategyFIRSTFIT>
  8018f2:	85 c0                	test   %eax,%eax
  8018f4:	74 2d                	je     801923 <malloc+0x74>
	    			{
	    				struct MemBlock * ff_block = alloc_block_FF(size);
  8018f6:	83 ec 0c             	sub    $0xc,%esp
  8018f9:	ff 75 08             	pushl  0x8(%ebp)
  8018fc:	e8 3e 0f 00 00       	call   80283f <alloc_block_FF>
  801901:	83 c4 10             	add    $0x10,%esp
  801904:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    				if(ff_block!=NULL)
  801907:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80190b:	74 16                	je     801923 <malloc+0x74>
	    				{

	    					insert_sorted_allocList(ff_block);
  80190d:	83 ec 0c             	sub    $0xc,%esp
  801910:	ff 75 ec             	pushl  -0x14(%ebp)
  801913:	e8 48 0c 00 00       	call   802560 <insert_sorted_allocList>
  801918:	83 c4 10             	add    $0x10,%esp
	    					return (void*) ff_block->sva ;
  80191b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80191e:	8b 40 08             	mov    0x8(%eax),%eax
  801921:	eb 05                	jmp    801928 <malloc+0x79>

	    				}
	}
	    			return (void*) NULL ;
  801923:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801928:	c9                   	leave  
  801929:	c3                   	ret    

0080192a <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80192a:	55                   	push   %ebp
  80192b:	89 e5                	mov    %esp,%ebp
  80192d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock *elementForEach;
		virtual_address = ROUNDDOWN(virtual_address, PAGE_SIZE);
  801930:	8b 45 08             	mov    0x8(%ebp),%eax
  801933:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801936:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801939:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80193e:	89 45 08             	mov    %eax,0x8(%ebp)
	//	if (is_mallocPages[indexindex((uint32) virtual_address)] == 1) {
		elementForEach = find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801941:	8b 45 08             	mov    0x8(%ebp),%eax
  801944:	83 ec 08             	sub    $0x8,%esp
  801947:	50                   	push   %eax
  801948:	68 40 50 80 00       	push   $0x805040
  80194d:	e8 71 0b 00 00       	call   8024c3 <find_block>
  801952:	83 c4 10             	add    $0x10,%esp
  801955:	89 45 f0             	mov    %eax,-0x10(%ebp)
		sys_free_user_mem((uint32) virtual_address, elementForEach->size);
  801958:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80195b:	8b 50 0c             	mov    0xc(%eax),%edx
  80195e:	8b 45 08             	mov    0x8(%ebp),%eax
  801961:	83 ec 08             	sub    $0x8,%esp
  801964:	52                   	push   %edx
  801965:	50                   	push   %eax
  801966:	e8 bd 03 00 00       	call   801d28 <sys_free_user_mem>
  80196b:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,elementForEach);
  80196e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801972:	75 14                	jne    801988 <free+0x5e>
  801974:	83 ec 04             	sub    $0x4,%esp
  801977:	68 35 40 80 00       	push   $0x804035
  80197c:	6a 71                	push   $0x71
  80197e:	68 53 40 80 00       	push   $0x804053
  801983:	e8 47 ed ff ff       	call   8006cf <_panic>
  801988:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80198b:	8b 00                	mov    (%eax),%eax
  80198d:	85 c0                	test   %eax,%eax
  80198f:	74 10                	je     8019a1 <free+0x77>
  801991:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801994:	8b 00                	mov    (%eax),%eax
  801996:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801999:	8b 52 04             	mov    0x4(%edx),%edx
  80199c:	89 50 04             	mov    %edx,0x4(%eax)
  80199f:	eb 0b                	jmp    8019ac <free+0x82>
  8019a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019a4:	8b 40 04             	mov    0x4(%eax),%eax
  8019a7:	a3 44 50 80 00       	mov    %eax,0x805044
  8019ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019af:	8b 40 04             	mov    0x4(%eax),%eax
  8019b2:	85 c0                	test   %eax,%eax
  8019b4:	74 0f                	je     8019c5 <free+0x9b>
  8019b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019b9:	8b 40 04             	mov    0x4(%eax),%eax
  8019bc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019bf:	8b 12                	mov    (%edx),%edx
  8019c1:	89 10                	mov    %edx,(%eax)
  8019c3:	eb 0a                	jmp    8019cf <free+0xa5>
  8019c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019c8:	8b 00                	mov    (%eax),%eax
  8019ca:	a3 40 50 80 00       	mov    %eax,0x805040
  8019cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019d2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8019d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019db:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8019e2:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8019e7:	48                   	dec    %eax
  8019e8:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(elementForEach);
  8019ed:	83 ec 0c             	sub    $0xc,%esp
  8019f0:	ff 75 f0             	pushl  -0x10(%ebp)
  8019f3:	e8 83 12 00 00       	call   802c7b <insert_sorted_with_merge_freeList>
  8019f8:	83 c4 10             	add    $0x10,%esp
	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  8019fb:	90                   	nop
  8019fc:	c9                   	leave  
  8019fd:	c3                   	ret    

008019fe <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8019fe:	55                   	push   %ebp
  8019ff:	89 e5                	mov    %esp,%ebp
  801a01:	83 ec 28             	sub    $0x28,%esp
  801a04:	8b 45 10             	mov    0x10(%ebp),%eax
  801a07:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a0a:	e8 fe fc ff ff       	call   80170d <InitializeUHeap>
	if (size == 0) return NULL ;
  801a0f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a13:	75 0a                	jne    801a1f <smalloc+0x21>
  801a15:	b8 00 00 00 00       	mov    $0x0,%eax
  801a1a:	e9 86 00 00 00       	jmp    801aa5 <smalloc+0xa7>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code

	size=ROUNDUP(size,PAGE_SIZE);
  801a1f:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801a26:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a2c:	01 d0                	add    %edx,%eax
  801a2e:	48                   	dec    %eax
  801a2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a35:	ba 00 00 00 00       	mov    $0x0,%edx
  801a3a:	f7 75 f4             	divl   -0xc(%ebp)
  801a3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a40:	29 d0                	sub    %edx,%eax
  801a42:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801a45:	e8 e4 06 00 00       	call   80212e <sys_isUHeapPlacementStrategyFIRSTFIT>
  801a4a:	85 c0                	test   %eax,%eax
  801a4c:	74 52                	je     801aa0 <smalloc+0xa2>
		{
		struct MemBlock * ff_block ;
		ff_block = alloc_block_FF(size);
  801a4e:	83 ec 0c             	sub    $0xc,%esp
  801a51:	ff 75 0c             	pushl  0xc(%ebp)
  801a54:	e8 e6 0d 00 00       	call   80283f <alloc_block_FF>
  801a59:	83 c4 10             	add    $0x10,%esp
  801a5c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(ff_block==NULL)
  801a5f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801a63:	75 07                	jne    801a6c <smalloc+0x6e>
			return NULL ;
  801a65:	b8 00 00 00 00       	mov    $0x0,%eax
  801a6a:	eb 39                	jmp    801aa5 <smalloc+0xa7>

		int obj_id =sys_createSharedObject(sharedVarName,size,isWritable,(void*)ff_block->sva);
  801a6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a6f:	8b 40 08             	mov    0x8(%eax),%eax
  801a72:	89 c2                	mov    %eax,%edx
  801a74:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801a78:	52                   	push   %edx
  801a79:	50                   	push   %eax
  801a7a:	ff 75 0c             	pushl  0xc(%ebp)
  801a7d:	ff 75 08             	pushl  0x8(%ebp)
  801a80:	e8 2e 04 00 00       	call   801eb3 <sys_createSharedObject>
  801a85:	83 c4 10             	add    $0x10,%esp
  801a88:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(obj_id < 0)
  801a8b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801a8f:	79 07                	jns    801a98 <smalloc+0x9a>
			return (void*)NULL ;
  801a91:	b8 00 00 00 00       	mov    $0x0,%eax
  801a96:	eb 0d                	jmp    801aa5 <smalloc+0xa7>
		else
		    return (void*)ff_block->sva ;
  801a98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a9b:	8b 40 08             	mov    0x8(%eax),%eax
  801a9e:	eb 05                	jmp    801aa5 <smalloc+0xa7>
		}
		return (void*)NULL ;
  801aa0:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801aa5:	c9                   	leave  
  801aa6:	c3                   	ret    

00801aa7 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801aa7:	55                   	push   %ebp
  801aa8:	89 e5                	mov    %esp,%ebp
  801aaa:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801aad:	e8 5b fc ff ff       	call   80170d <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801ab2:	83 ec 08             	sub    $0x8,%esp
  801ab5:	ff 75 0c             	pushl  0xc(%ebp)
  801ab8:	ff 75 08             	pushl  0x8(%ebp)
  801abb:	e8 1d 04 00 00       	call   801edd <sys_getSizeOfSharedObject>
  801ac0:	83 c4 10             	add    $0x10,%esp
  801ac3:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(size == 0)
  801ac6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801aca:	75 0a                	jne    801ad6 <sget+0x2f>
			return NULL ;
  801acc:	b8 00 00 00 00       	mov    $0x0,%eax
  801ad1:	e9 83 00 00 00       	jmp    801b59 <sget+0xb2>
		size=ROUNDUP(size,PAGE_SIZE);
  801ad6:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801add:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ae0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ae3:	01 d0                	add    %edx,%eax
  801ae5:	48                   	dec    %eax
  801ae6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801ae9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801aec:	ba 00 00 00 00       	mov    $0x0,%edx
  801af1:	f7 75 f0             	divl   -0x10(%ebp)
  801af4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801af7:	29 d0                	sub    %edx,%eax
  801af9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801afc:	e8 2d 06 00 00       	call   80212e <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b01:	85 c0                	test   %eax,%eax
  801b03:	74 4f                	je     801b54 <sget+0xad>
		{
			struct MemBlock * ff_block ;
				ff_block = alloc_block_FF(size);
  801b05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b08:	83 ec 0c             	sub    $0xc,%esp
  801b0b:	50                   	push   %eax
  801b0c:	e8 2e 0d 00 00       	call   80283f <alloc_block_FF>
  801b11:	83 c4 10             	add    $0x10,%esp
  801b14:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ff_block==NULL)
  801b17:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801b1b:	75 07                	jne    801b24 <sget+0x7d>
					return (void*)NULL ;
  801b1d:	b8 00 00 00 00       	mov    $0x0,%eax
  801b22:	eb 35                	jmp    801b59 <sget+0xb2>

		int obj_id =sys_getSharedObject((int)ownerEnvID,sharedVarName,(void*)ff_block->sva);
  801b24:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b27:	8b 40 08             	mov    0x8(%eax),%eax
  801b2a:	83 ec 04             	sub    $0x4,%esp
  801b2d:	50                   	push   %eax
  801b2e:	ff 75 0c             	pushl  0xc(%ebp)
  801b31:	ff 75 08             	pushl  0x8(%ebp)
  801b34:	e8 c1 03 00 00       	call   801efa <sys_getSharedObject>
  801b39:	83 c4 10             	add    $0x10,%esp
  801b3c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if(obj_id<0)
  801b3f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801b43:	79 07                	jns    801b4c <sget+0xa5>
				return (void*)NULL ;
  801b45:	b8 00 00 00 00       	mov    $0x0,%eax
  801b4a:	eb 0d                	jmp    801b59 <sget+0xb2>
			else
				return (void*)ff_block->sva ;
  801b4c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b4f:	8b 40 08             	mov    0x8(%eax),%eax
  801b52:	eb 05                	jmp    801b59 <sget+0xb2>


		}
	return (void*)NULL ;
  801b54:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801b59:	c9                   	leave  
  801b5a:	c3                   	ret    

00801b5b <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801b5b:	55                   	push   %ebp
  801b5c:	89 e5                	mov    %esp,%ebp
  801b5e:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b61:	e8 a7 fb ff ff       	call   80170d <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801b66:	83 ec 04             	sub    $0x4,%esp
  801b69:	68 60 40 80 00       	push   $0x804060
  801b6e:	68 f9 00 00 00       	push   $0xf9
  801b73:	68 53 40 80 00       	push   $0x804053
  801b78:	e8 52 eb ff ff       	call   8006cf <_panic>

00801b7d <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801b7d:	55                   	push   %ebp
  801b7e:	89 e5                	mov    %esp,%ebp
  801b80:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801b83:	83 ec 04             	sub    $0x4,%esp
  801b86:	68 88 40 80 00       	push   $0x804088
  801b8b:	68 0d 01 00 00       	push   $0x10d
  801b90:	68 53 40 80 00       	push   $0x804053
  801b95:	e8 35 eb ff ff       	call   8006cf <_panic>

00801b9a <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801b9a:	55                   	push   %ebp
  801b9b:	89 e5                	mov    %esp,%ebp
  801b9d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ba0:	83 ec 04             	sub    $0x4,%esp
  801ba3:	68 ac 40 80 00       	push   $0x8040ac
  801ba8:	68 18 01 00 00       	push   $0x118
  801bad:	68 53 40 80 00       	push   $0x804053
  801bb2:	e8 18 eb ff ff       	call   8006cf <_panic>

00801bb7 <shrink>:

}
void shrink(uint32 newSize)
{
  801bb7:	55                   	push   %ebp
  801bb8:	89 e5                	mov    %esp,%ebp
  801bba:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801bbd:	83 ec 04             	sub    $0x4,%esp
  801bc0:	68 ac 40 80 00       	push   $0x8040ac
  801bc5:	68 1d 01 00 00       	push   $0x11d
  801bca:	68 53 40 80 00       	push   $0x804053
  801bcf:	e8 fb ea ff ff       	call   8006cf <_panic>

00801bd4 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801bd4:	55                   	push   %ebp
  801bd5:	89 e5                	mov    %esp,%ebp
  801bd7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801bda:	83 ec 04             	sub    $0x4,%esp
  801bdd:	68 ac 40 80 00       	push   $0x8040ac
  801be2:	68 22 01 00 00       	push   $0x122
  801be7:	68 53 40 80 00       	push   $0x804053
  801bec:	e8 de ea ff ff       	call   8006cf <_panic>

00801bf1 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801bf1:	55                   	push   %ebp
  801bf2:	89 e5                	mov    %esp,%ebp
  801bf4:	57                   	push   %edi
  801bf5:	56                   	push   %esi
  801bf6:	53                   	push   %ebx
  801bf7:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c00:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c03:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c06:	8b 7d 18             	mov    0x18(%ebp),%edi
  801c09:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801c0c:	cd 30                	int    $0x30
  801c0e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801c11:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801c14:	83 c4 10             	add    $0x10,%esp
  801c17:	5b                   	pop    %ebx
  801c18:	5e                   	pop    %esi
  801c19:	5f                   	pop    %edi
  801c1a:	5d                   	pop    %ebp
  801c1b:	c3                   	ret    

00801c1c <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801c1c:	55                   	push   %ebp
  801c1d:	89 e5                	mov    %esp,%ebp
  801c1f:	83 ec 04             	sub    $0x4,%esp
  801c22:	8b 45 10             	mov    0x10(%ebp),%eax
  801c25:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801c28:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	52                   	push   %edx
  801c34:	ff 75 0c             	pushl  0xc(%ebp)
  801c37:	50                   	push   %eax
  801c38:	6a 00                	push   $0x0
  801c3a:	e8 b2 ff ff ff       	call   801bf1 <syscall>
  801c3f:	83 c4 18             	add    $0x18,%esp
}
  801c42:	90                   	nop
  801c43:	c9                   	leave  
  801c44:	c3                   	ret    

00801c45 <sys_cgetc>:

int
sys_cgetc(void)
{
  801c45:	55                   	push   %ebp
  801c46:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 00                	push   $0x0
  801c52:	6a 01                	push   $0x1
  801c54:	e8 98 ff ff ff       	call   801bf1 <syscall>
  801c59:	83 c4 18             	add    $0x18,%esp
}
  801c5c:	c9                   	leave  
  801c5d:	c3                   	ret    

00801c5e <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801c5e:	55                   	push   %ebp
  801c5f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801c61:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c64:	8b 45 08             	mov    0x8(%ebp),%eax
  801c67:	6a 00                	push   $0x0
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 00                	push   $0x0
  801c6d:	52                   	push   %edx
  801c6e:	50                   	push   %eax
  801c6f:	6a 05                	push   $0x5
  801c71:	e8 7b ff ff ff       	call   801bf1 <syscall>
  801c76:	83 c4 18             	add    $0x18,%esp
}
  801c79:	c9                   	leave  
  801c7a:	c3                   	ret    

00801c7b <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801c7b:	55                   	push   %ebp
  801c7c:	89 e5                	mov    %esp,%ebp
  801c7e:	56                   	push   %esi
  801c7f:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801c80:	8b 75 18             	mov    0x18(%ebp),%esi
  801c83:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c86:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c89:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8f:	56                   	push   %esi
  801c90:	53                   	push   %ebx
  801c91:	51                   	push   %ecx
  801c92:	52                   	push   %edx
  801c93:	50                   	push   %eax
  801c94:	6a 06                	push   $0x6
  801c96:	e8 56 ff ff ff       	call   801bf1 <syscall>
  801c9b:	83 c4 18             	add    $0x18,%esp
}
  801c9e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ca1:	5b                   	pop    %ebx
  801ca2:	5e                   	pop    %esi
  801ca3:	5d                   	pop    %ebp
  801ca4:	c3                   	ret    

00801ca5 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801ca5:	55                   	push   %ebp
  801ca6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801ca8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cab:	8b 45 08             	mov    0x8(%ebp),%eax
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	52                   	push   %edx
  801cb5:	50                   	push   %eax
  801cb6:	6a 07                	push   $0x7
  801cb8:	e8 34 ff ff ff       	call   801bf1 <syscall>
  801cbd:	83 c4 18             	add    $0x18,%esp
}
  801cc0:	c9                   	leave  
  801cc1:	c3                   	ret    

00801cc2 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801cc2:	55                   	push   %ebp
  801cc3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801cc5:	6a 00                	push   $0x0
  801cc7:	6a 00                	push   $0x0
  801cc9:	6a 00                	push   $0x0
  801ccb:	ff 75 0c             	pushl  0xc(%ebp)
  801cce:	ff 75 08             	pushl  0x8(%ebp)
  801cd1:	6a 08                	push   $0x8
  801cd3:	e8 19 ff ff ff       	call   801bf1 <syscall>
  801cd8:	83 c4 18             	add    $0x18,%esp
}
  801cdb:	c9                   	leave  
  801cdc:	c3                   	ret    

00801cdd <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801cdd:	55                   	push   %ebp
  801cde:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801ce0:	6a 00                	push   $0x0
  801ce2:	6a 00                	push   $0x0
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 09                	push   $0x9
  801cec:	e8 00 ff ff ff       	call   801bf1 <syscall>
  801cf1:	83 c4 18             	add    $0x18,%esp
}
  801cf4:	c9                   	leave  
  801cf5:	c3                   	ret    

00801cf6 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801cf6:	55                   	push   %ebp
  801cf7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801cf9:	6a 00                	push   $0x0
  801cfb:	6a 00                	push   $0x0
  801cfd:	6a 00                	push   $0x0
  801cff:	6a 00                	push   $0x0
  801d01:	6a 00                	push   $0x0
  801d03:	6a 0a                	push   $0xa
  801d05:	e8 e7 fe ff ff       	call   801bf1 <syscall>
  801d0a:	83 c4 18             	add    $0x18,%esp
}
  801d0d:	c9                   	leave  
  801d0e:	c3                   	ret    

00801d0f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801d0f:	55                   	push   %ebp
  801d10:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801d12:	6a 00                	push   $0x0
  801d14:	6a 00                	push   $0x0
  801d16:	6a 00                	push   $0x0
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 0b                	push   $0xb
  801d1e:	e8 ce fe ff ff       	call   801bf1 <syscall>
  801d23:	83 c4 18             	add    $0x18,%esp
}
  801d26:	c9                   	leave  
  801d27:	c3                   	ret    

00801d28 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801d28:	55                   	push   %ebp
  801d29:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 00                	push   $0x0
  801d31:	ff 75 0c             	pushl  0xc(%ebp)
  801d34:	ff 75 08             	pushl  0x8(%ebp)
  801d37:	6a 0f                	push   $0xf
  801d39:	e8 b3 fe ff ff       	call   801bf1 <syscall>
  801d3e:	83 c4 18             	add    $0x18,%esp
	return;
  801d41:	90                   	nop
}
  801d42:	c9                   	leave  
  801d43:	c3                   	ret    

00801d44 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801d44:	55                   	push   %ebp
  801d45:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	ff 75 0c             	pushl  0xc(%ebp)
  801d50:	ff 75 08             	pushl  0x8(%ebp)
  801d53:	6a 10                	push   $0x10
  801d55:	e8 97 fe ff ff       	call   801bf1 <syscall>
  801d5a:	83 c4 18             	add    $0x18,%esp
	return ;
  801d5d:	90                   	nop
}
  801d5e:	c9                   	leave  
  801d5f:	c3                   	ret    

00801d60 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801d60:	55                   	push   %ebp
  801d61:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801d63:	6a 00                	push   $0x0
  801d65:	6a 00                	push   $0x0
  801d67:	ff 75 10             	pushl  0x10(%ebp)
  801d6a:	ff 75 0c             	pushl  0xc(%ebp)
  801d6d:	ff 75 08             	pushl  0x8(%ebp)
  801d70:	6a 11                	push   $0x11
  801d72:	e8 7a fe ff ff       	call   801bf1 <syscall>
  801d77:	83 c4 18             	add    $0x18,%esp
	return ;
  801d7a:	90                   	nop
}
  801d7b:	c9                   	leave  
  801d7c:	c3                   	ret    

00801d7d <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801d7d:	55                   	push   %ebp
  801d7e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801d80:	6a 00                	push   $0x0
  801d82:	6a 00                	push   $0x0
  801d84:	6a 00                	push   $0x0
  801d86:	6a 00                	push   $0x0
  801d88:	6a 00                	push   $0x0
  801d8a:	6a 0c                	push   $0xc
  801d8c:	e8 60 fe ff ff       	call   801bf1 <syscall>
  801d91:	83 c4 18             	add    $0x18,%esp
}
  801d94:	c9                   	leave  
  801d95:	c3                   	ret    

00801d96 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801d96:	55                   	push   %ebp
  801d97:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801d99:	6a 00                	push   $0x0
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 00                	push   $0x0
  801d9f:	6a 00                	push   $0x0
  801da1:	ff 75 08             	pushl  0x8(%ebp)
  801da4:	6a 0d                	push   $0xd
  801da6:	e8 46 fe ff ff       	call   801bf1 <syscall>
  801dab:	83 c4 18             	add    $0x18,%esp
}
  801dae:	c9                   	leave  
  801daf:	c3                   	ret    

00801db0 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801db0:	55                   	push   %ebp
  801db1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801db3:	6a 00                	push   $0x0
  801db5:	6a 00                	push   $0x0
  801db7:	6a 00                	push   $0x0
  801db9:	6a 00                	push   $0x0
  801dbb:	6a 00                	push   $0x0
  801dbd:	6a 0e                	push   $0xe
  801dbf:	e8 2d fe ff ff       	call   801bf1 <syscall>
  801dc4:	83 c4 18             	add    $0x18,%esp
}
  801dc7:	90                   	nop
  801dc8:	c9                   	leave  
  801dc9:	c3                   	ret    

00801dca <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801dca:	55                   	push   %ebp
  801dcb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801dcd:	6a 00                	push   $0x0
  801dcf:	6a 00                	push   $0x0
  801dd1:	6a 00                	push   $0x0
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 13                	push   $0x13
  801dd9:	e8 13 fe ff ff       	call   801bf1 <syscall>
  801dde:	83 c4 18             	add    $0x18,%esp
}
  801de1:	90                   	nop
  801de2:	c9                   	leave  
  801de3:	c3                   	ret    

00801de4 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801de4:	55                   	push   %ebp
  801de5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801de7:	6a 00                	push   $0x0
  801de9:	6a 00                	push   $0x0
  801deb:	6a 00                	push   $0x0
  801ded:	6a 00                	push   $0x0
  801def:	6a 00                	push   $0x0
  801df1:	6a 14                	push   $0x14
  801df3:	e8 f9 fd ff ff       	call   801bf1 <syscall>
  801df8:	83 c4 18             	add    $0x18,%esp
}
  801dfb:	90                   	nop
  801dfc:	c9                   	leave  
  801dfd:	c3                   	ret    

00801dfe <sys_cputc>:


void
sys_cputc(const char c)
{
  801dfe:	55                   	push   %ebp
  801dff:	89 e5                	mov    %esp,%ebp
  801e01:	83 ec 04             	sub    $0x4,%esp
  801e04:	8b 45 08             	mov    0x8(%ebp),%eax
  801e07:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801e0a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e0e:	6a 00                	push   $0x0
  801e10:	6a 00                	push   $0x0
  801e12:	6a 00                	push   $0x0
  801e14:	6a 00                	push   $0x0
  801e16:	50                   	push   %eax
  801e17:	6a 15                	push   $0x15
  801e19:	e8 d3 fd ff ff       	call   801bf1 <syscall>
  801e1e:	83 c4 18             	add    $0x18,%esp
}
  801e21:	90                   	nop
  801e22:	c9                   	leave  
  801e23:	c3                   	ret    

00801e24 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801e24:	55                   	push   %ebp
  801e25:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 16                	push   $0x16
  801e33:	e8 b9 fd ff ff       	call   801bf1 <syscall>
  801e38:	83 c4 18             	add    $0x18,%esp
}
  801e3b:	90                   	nop
  801e3c:	c9                   	leave  
  801e3d:	c3                   	ret    

00801e3e <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801e3e:	55                   	push   %ebp
  801e3f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801e41:	8b 45 08             	mov    0x8(%ebp),%eax
  801e44:	6a 00                	push   $0x0
  801e46:	6a 00                	push   $0x0
  801e48:	6a 00                	push   $0x0
  801e4a:	ff 75 0c             	pushl  0xc(%ebp)
  801e4d:	50                   	push   %eax
  801e4e:	6a 17                	push   $0x17
  801e50:	e8 9c fd ff ff       	call   801bf1 <syscall>
  801e55:	83 c4 18             	add    $0x18,%esp
}
  801e58:	c9                   	leave  
  801e59:	c3                   	ret    

00801e5a <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801e5a:	55                   	push   %ebp
  801e5b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801e5d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e60:	8b 45 08             	mov    0x8(%ebp),%eax
  801e63:	6a 00                	push   $0x0
  801e65:	6a 00                	push   $0x0
  801e67:	6a 00                	push   $0x0
  801e69:	52                   	push   %edx
  801e6a:	50                   	push   %eax
  801e6b:	6a 1a                	push   $0x1a
  801e6d:	e8 7f fd ff ff       	call   801bf1 <syscall>
  801e72:	83 c4 18             	add    $0x18,%esp
}
  801e75:	c9                   	leave  
  801e76:	c3                   	ret    

00801e77 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801e77:	55                   	push   %ebp
  801e78:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801e7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e80:	6a 00                	push   $0x0
  801e82:	6a 00                	push   $0x0
  801e84:	6a 00                	push   $0x0
  801e86:	52                   	push   %edx
  801e87:	50                   	push   %eax
  801e88:	6a 18                	push   $0x18
  801e8a:	e8 62 fd ff ff       	call   801bf1 <syscall>
  801e8f:	83 c4 18             	add    $0x18,%esp
}
  801e92:	90                   	nop
  801e93:	c9                   	leave  
  801e94:	c3                   	ret    

00801e95 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801e95:	55                   	push   %ebp
  801e96:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801e98:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9e:	6a 00                	push   $0x0
  801ea0:	6a 00                	push   $0x0
  801ea2:	6a 00                	push   $0x0
  801ea4:	52                   	push   %edx
  801ea5:	50                   	push   %eax
  801ea6:	6a 19                	push   $0x19
  801ea8:	e8 44 fd ff ff       	call   801bf1 <syscall>
  801ead:	83 c4 18             	add    $0x18,%esp
}
  801eb0:	90                   	nop
  801eb1:	c9                   	leave  
  801eb2:	c3                   	ret    

00801eb3 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801eb3:	55                   	push   %ebp
  801eb4:	89 e5                	mov    %esp,%ebp
  801eb6:	83 ec 04             	sub    $0x4,%esp
  801eb9:	8b 45 10             	mov    0x10(%ebp),%eax
  801ebc:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801ebf:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ec2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec9:	6a 00                	push   $0x0
  801ecb:	51                   	push   %ecx
  801ecc:	52                   	push   %edx
  801ecd:	ff 75 0c             	pushl  0xc(%ebp)
  801ed0:	50                   	push   %eax
  801ed1:	6a 1b                	push   $0x1b
  801ed3:	e8 19 fd ff ff       	call   801bf1 <syscall>
  801ed8:	83 c4 18             	add    $0x18,%esp
}
  801edb:	c9                   	leave  
  801edc:	c3                   	ret    

00801edd <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801edd:	55                   	push   %ebp
  801ede:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801ee0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ee3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee6:	6a 00                	push   $0x0
  801ee8:	6a 00                	push   $0x0
  801eea:	6a 00                	push   $0x0
  801eec:	52                   	push   %edx
  801eed:	50                   	push   %eax
  801eee:	6a 1c                	push   $0x1c
  801ef0:	e8 fc fc ff ff       	call   801bf1 <syscall>
  801ef5:	83 c4 18             	add    $0x18,%esp
}
  801ef8:	c9                   	leave  
  801ef9:	c3                   	ret    

00801efa <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801efa:	55                   	push   %ebp
  801efb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801efd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f00:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f03:	8b 45 08             	mov    0x8(%ebp),%eax
  801f06:	6a 00                	push   $0x0
  801f08:	6a 00                	push   $0x0
  801f0a:	51                   	push   %ecx
  801f0b:	52                   	push   %edx
  801f0c:	50                   	push   %eax
  801f0d:	6a 1d                	push   $0x1d
  801f0f:	e8 dd fc ff ff       	call   801bf1 <syscall>
  801f14:	83 c4 18             	add    $0x18,%esp
}
  801f17:	c9                   	leave  
  801f18:	c3                   	ret    

00801f19 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801f19:	55                   	push   %ebp
  801f1a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801f1c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f22:	6a 00                	push   $0x0
  801f24:	6a 00                	push   $0x0
  801f26:	6a 00                	push   $0x0
  801f28:	52                   	push   %edx
  801f29:	50                   	push   %eax
  801f2a:	6a 1e                	push   $0x1e
  801f2c:	e8 c0 fc ff ff       	call   801bf1 <syscall>
  801f31:	83 c4 18             	add    $0x18,%esp
}
  801f34:	c9                   	leave  
  801f35:	c3                   	ret    

00801f36 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801f36:	55                   	push   %ebp
  801f37:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801f39:	6a 00                	push   $0x0
  801f3b:	6a 00                	push   $0x0
  801f3d:	6a 00                	push   $0x0
  801f3f:	6a 00                	push   $0x0
  801f41:	6a 00                	push   $0x0
  801f43:	6a 1f                	push   $0x1f
  801f45:	e8 a7 fc ff ff       	call   801bf1 <syscall>
  801f4a:	83 c4 18             	add    $0x18,%esp
}
  801f4d:	c9                   	leave  
  801f4e:	c3                   	ret    

00801f4f <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801f4f:	55                   	push   %ebp
  801f50:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801f52:	8b 45 08             	mov    0x8(%ebp),%eax
  801f55:	6a 00                	push   $0x0
  801f57:	ff 75 14             	pushl  0x14(%ebp)
  801f5a:	ff 75 10             	pushl  0x10(%ebp)
  801f5d:	ff 75 0c             	pushl  0xc(%ebp)
  801f60:	50                   	push   %eax
  801f61:	6a 20                	push   $0x20
  801f63:	e8 89 fc ff ff       	call   801bf1 <syscall>
  801f68:	83 c4 18             	add    $0x18,%esp
}
  801f6b:	c9                   	leave  
  801f6c:	c3                   	ret    

00801f6d <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801f6d:	55                   	push   %ebp
  801f6e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801f70:	8b 45 08             	mov    0x8(%ebp),%eax
  801f73:	6a 00                	push   $0x0
  801f75:	6a 00                	push   $0x0
  801f77:	6a 00                	push   $0x0
  801f79:	6a 00                	push   $0x0
  801f7b:	50                   	push   %eax
  801f7c:	6a 21                	push   $0x21
  801f7e:	e8 6e fc ff ff       	call   801bf1 <syscall>
  801f83:	83 c4 18             	add    $0x18,%esp
}
  801f86:	90                   	nop
  801f87:	c9                   	leave  
  801f88:	c3                   	ret    

00801f89 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801f89:	55                   	push   %ebp
  801f8a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8f:	6a 00                	push   $0x0
  801f91:	6a 00                	push   $0x0
  801f93:	6a 00                	push   $0x0
  801f95:	6a 00                	push   $0x0
  801f97:	50                   	push   %eax
  801f98:	6a 22                	push   $0x22
  801f9a:	e8 52 fc ff ff       	call   801bf1 <syscall>
  801f9f:	83 c4 18             	add    $0x18,%esp
}
  801fa2:	c9                   	leave  
  801fa3:	c3                   	ret    

00801fa4 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801fa4:	55                   	push   %ebp
  801fa5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801fa7:	6a 00                	push   $0x0
  801fa9:	6a 00                	push   $0x0
  801fab:	6a 00                	push   $0x0
  801fad:	6a 00                	push   $0x0
  801faf:	6a 00                	push   $0x0
  801fb1:	6a 02                	push   $0x2
  801fb3:	e8 39 fc ff ff       	call   801bf1 <syscall>
  801fb8:	83 c4 18             	add    $0x18,%esp
}
  801fbb:	c9                   	leave  
  801fbc:	c3                   	ret    

00801fbd <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801fbd:	55                   	push   %ebp
  801fbe:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801fc0:	6a 00                	push   $0x0
  801fc2:	6a 00                	push   $0x0
  801fc4:	6a 00                	push   $0x0
  801fc6:	6a 00                	push   $0x0
  801fc8:	6a 00                	push   $0x0
  801fca:	6a 03                	push   $0x3
  801fcc:	e8 20 fc ff ff       	call   801bf1 <syscall>
  801fd1:	83 c4 18             	add    $0x18,%esp
}
  801fd4:	c9                   	leave  
  801fd5:	c3                   	ret    

00801fd6 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801fd6:	55                   	push   %ebp
  801fd7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801fd9:	6a 00                	push   $0x0
  801fdb:	6a 00                	push   $0x0
  801fdd:	6a 00                	push   $0x0
  801fdf:	6a 00                	push   $0x0
  801fe1:	6a 00                	push   $0x0
  801fe3:	6a 04                	push   $0x4
  801fe5:	e8 07 fc ff ff       	call   801bf1 <syscall>
  801fea:	83 c4 18             	add    $0x18,%esp
}
  801fed:	c9                   	leave  
  801fee:	c3                   	ret    

00801fef <sys_exit_env>:


void sys_exit_env(void)
{
  801fef:	55                   	push   %ebp
  801ff0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801ff2:	6a 00                	push   $0x0
  801ff4:	6a 00                	push   $0x0
  801ff6:	6a 00                	push   $0x0
  801ff8:	6a 00                	push   $0x0
  801ffa:	6a 00                	push   $0x0
  801ffc:	6a 23                	push   $0x23
  801ffe:	e8 ee fb ff ff       	call   801bf1 <syscall>
  802003:	83 c4 18             	add    $0x18,%esp
}
  802006:	90                   	nop
  802007:	c9                   	leave  
  802008:	c3                   	ret    

00802009 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802009:	55                   	push   %ebp
  80200a:	89 e5                	mov    %esp,%ebp
  80200c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80200f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802012:	8d 50 04             	lea    0x4(%eax),%edx
  802015:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802018:	6a 00                	push   $0x0
  80201a:	6a 00                	push   $0x0
  80201c:	6a 00                	push   $0x0
  80201e:	52                   	push   %edx
  80201f:	50                   	push   %eax
  802020:	6a 24                	push   $0x24
  802022:	e8 ca fb ff ff       	call   801bf1 <syscall>
  802027:	83 c4 18             	add    $0x18,%esp
	return result;
  80202a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80202d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802030:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802033:	89 01                	mov    %eax,(%ecx)
  802035:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802038:	8b 45 08             	mov    0x8(%ebp),%eax
  80203b:	c9                   	leave  
  80203c:	c2 04 00             	ret    $0x4

0080203f <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80203f:	55                   	push   %ebp
  802040:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802042:	6a 00                	push   $0x0
  802044:	6a 00                	push   $0x0
  802046:	ff 75 10             	pushl  0x10(%ebp)
  802049:	ff 75 0c             	pushl  0xc(%ebp)
  80204c:	ff 75 08             	pushl  0x8(%ebp)
  80204f:	6a 12                	push   $0x12
  802051:	e8 9b fb ff ff       	call   801bf1 <syscall>
  802056:	83 c4 18             	add    $0x18,%esp
	return ;
  802059:	90                   	nop
}
  80205a:	c9                   	leave  
  80205b:	c3                   	ret    

0080205c <sys_rcr2>:
uint32 sys_rcr2()
{
  80205c:	55                   	push   %ebp
  80205d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80205f:	6a 00                	push   $0x0
  802061:	6a 00                	push   $0x0
  802063:	6a 00                	push   $0x0
  802065:	6a 00                	push   $0x0
  802067:	6a 00                	push   $0x0
  802069:	6a 25                	push   $0x25
  80206b:	e8 81 fb ff ff       	call   801bf1 <syscall>
  802070:	83 c4 18             	add    $0x18,%esp
}
  802073:	c9                   	leave  
  802074:	c3                   	ret    

00802075 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802075:	55                   	push   %ebp
  802076:	89 e5                	mov    %esp,%ebp
  802078:	83 ec 04             	sub    $0x4,%esp
  80207b:	8b 45 08             	mov    0x8(%ebp),%eax
  80207e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802081:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802085:	6a 00                	push   $0x0
  802087:	6a 00                	push   $0x0
  802089:	6a 00                	push   $0x0
  80208b:	6a 00                	push   $0x0
  80208d:	50                   	push   %eax
  80208e:	6a 26                	push   $0x26
  802090:	e8 5c fb ff ff       	call   801bf1 <syscall>
  802095:	83 c4 18             	add    $0x18,%esp
	return ;
  802098:	90                   	nop
}
  802099:	c9                   	leave  
  80209a:	c3                   	ret    

0080209b <rsttst>:
void rsttst()
{
  80209b:	55                   	push   %ebp
  80209c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80209e:	6a 00                	push   $0x0
  8020a0:	6a 00                	push   $0x0
  8020a2:	6a 00                	push   $0x0
  8020a4:	6a 00                	push   $0x0
  8020a6:	6a 00                	push   $0x0
  8020a8:	6a 28                	push   $0x28
  8020aa:	e8 42 fb ff ff       	call   801bf1 <syscall>
  8020af:	83 c4 18             	add    $0x18,%esp
	return ;
  8020b2:	90                   	nop
}
  8020b3:	c9                   	leave  
  8020b4:	c3                   	ret    

008020b5 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8020b5:	55                   	push   %ebp
  8020b6:	89 e5                	mov    %esp,%ebp
  8020b8:	83 ec 04             	sub    $0x4,%esp
  8020bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8020be:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8020c1:	8b 55 18             	mov    0x18(%ebp),%edx
  8020c4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8020c8:	52                   	push   %edx
  8020c9:	50                   	push   %eax
  8020ca:	ff 75 10             	pushl  0x10(%ebp)
  8020cd:	ff 75 0c             	pushl  0xc(%ebp)
  8020d0:	ff 75 08             	pushl  0x8(%ebp)
  8020d3:	6a 27                	push   $0x27
  8020d5:	e8 17 fb ff ff       	call   801bf1 <syscall>
  8020da:	83 c4 18             	add    $0x18,%esp
	return ;
  8020dd:	90                   	nop
}
  8020de:	c9                   	leave  
  8020df:	c3                   	ret    

008020e0 <chktst>:
void chktst(uint32 n)
{
  8020e0:	55                   	push   %ebp
  8020e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8020e3:	6a 00                	push   $0x0
  8020e5:	6a 00                	push   $0x0
  8020e7:	6a 00                	push   $0x0
  8020e9:	6a 00                	push   $0x0
  8020eb:	ff 75 08             	pushl  0x8(%ebp)
  8020ee:	6a 29                	push   $0x29
  8020f0:	e8 fc fa ff ff       	call   801bf1 <syscall>
  8020f5:	83 c4 18             	add    $0x18,%esp
	return ;
  8020f8:	90                   	nop
}
  8020f9:	c9                   	leave  
  8020fa:	c3                   	ret    

008020fb <inctst>:

void inctst()
{
  8020fb:	55                   	push   %ebp
  8020fc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8020fe:	6a 00                	push   $0x0
  802100:	6a 00                	push   $0x0
  802102:	6a 00                	push   $0x0
  802104:	6a 00                	push   $0x0
  802106:	6a 00                	push   $0x0
  802108:	6a 2a                	push   $0x2a
  80210a:	e8 e2 fa ff ff       	call   801bf1 <syscall>
  80210f:	83 c4 18             	add    $0x18,%esp
	return ;
  802112:	90                   	nop
}
  802113:	c9                   	leave  
  802114:	c3                   	ret    

00802115 <gettst>:
uint32 gettst()
{
  802115:	55                   	push   %ebp
  802116:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802118:	6a 00                	push   $0x0
  80211a:	6a 00                	push   $0x0
  80211c:	6a 00                	push   $0x0
  80211e:	6a 00                	push   $0x0
  802120:	6a 00                	push   $0x0
  802122:	6a 2b                	push   $0x2b
  802124:	e8 c8 fa ff ff       	call   801bf1 <syscall>
  802129:	83 c4 18             	add    $0x18,%esp
}
  80212c:	c9                   	leave  
  80212d:	c3                   	ret    

0080212e <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80212e:	55                   	push   %ebp
  80212f:	89 e5                	mov    %esp,%ebp
  802131:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802134:	6a 00                	push   $0x0
  802136:	6a 00                	push   $0x0
  802138:	6a 00                	push   $0x0
  80213a:	6a 00                	push   $0x0
  80213c:	6a 00                	push   $0x0
  80213e:	6a 2c                	push   $0x2c
  802140:	e8 ac fa ff ff       	call   801bf1 <syscall>
  802145:	83 c4 18             	add    $0x18,%esp
  802148:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80214b:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80214f:	75 07                	jne    802158 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802151:	b8 01 00 00 00       	mov    $0x1,%eax
  802156:	eb 05                	jmp    80215d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802158:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80215d:	c9                   	leave  
  80215e:	c3                   	ret    

0080215f <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80215f:	55                   	push   %ebp
  802160:	89 e5                	mov    %esp,%ebp
  802162:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802165:	6a 00                	push   $0x0
  802167:	6a 00                	push   $0x0
  802169:	6a 00                	push   $0x0
  80216b:	6a 00                	push   $0x0
  80216d:	6a 00                	push   $0x0
  80216f:	6a 2c                	push   $0x2c
  802171:	e8 7b fa ff ff       	call   801bf1 <syscall>
  802176:	83 c4 18             	add    $0x18,%esp
  802179:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80217c:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802180:	75 07                	jne    802189 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802182:	b8 01 00 00 00       	mov    $0x1,%eax
  802187:	eb 05                	jmp    80218e <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802189:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80218e:	c9                   	leave  
  80218f:	c3                   	ret    

00802190 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802190:	55                   	push   %ebp
  802191:	89 e5                	mov    %esp,%ebp
  802193:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802196:	6a 00                	push   $0x0
  802198:	6a 00                	push   $0x0
  80219a:	6a 00                	push   $0x0
  80219c:	6a 00                	push   $0x0
  80219e:	6a 00                	push   $0x0
  8021a0:	6a 2c                	push   $0x2c
  8021a2:	e8 4a fa ff ff       	call   801bf1 <syscall>
  8021a7:	83 c4 18             	add    $0x18,%esp
  8021aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8021ad:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8021b1:	75 07                	jne    8021ba <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8021b3:	b8 01 00 00 00       	mov    $0x1,%eax
  8021b8:	eb 05                	jmp    8021bf <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8021ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021bf:	c9                   	leave  
  8021c0:	c3                   	ret    

008021c1 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8021c1:	55                   	push   %ebp
  8021c2:	89 e5                	mov    %esp,%ebp
  8021c4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021c7:	6a 00                	push   $0x0
  8021c9:	6a 00                	push   $0x0
  8021cb:	6a 00                	push   $0x0
  8021cd:	6a 00                	push   $0x0
  8021cf:	6a 00                	push   $0x0
  8021d1:	6a 2c                	push   $0x2c
  8021d3:	e8 19 fa ff ff       	call   801bf1 <syscall>
  8021d8:	83 c4 18             	add    $0x18,%esp
  8021db:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8021de:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8021e2:	75 07                	jne    8021eb <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8021e4:	b8 01 00 00 00       	mov    $0x1,%eax
  8021e9:	eb 05                	jmp    8021f0 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8021eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021f0:	c9                   	leave  
  8021f1:	c3                   	ret    

008021f2 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8021f2:	55                   	push   %ebp
  8021f3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8021f5:	6a 00                	push   $0x0
  8021f7:	6a 00                	push   $0x0
  8021f9:	6a 00                	push   $0x0
  8021fb:	6a 00                	push   $0x0
  8021fd:	ff 75 08             	pushl  0x8(%ebp)
  802200:	6a 2d                	push   $0x2d
  802202:	e8 ea f9 ff ff       	call   801bf1 <syscall>
  802207:	83 c4 18             	add    $0x18,%esp
	return ;
  80220a:	90                   	nop
}
  80220b:	c9                   	leave  
  80220c:	c3                   	ret    

0080220d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80220d:	55                   	push   %ebp
  80220e:	89 e5                	mov    %esp,%ebp
  802210:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802211:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802214:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802217:	8b 55 0c             	mov    0xc(%ebp),%edx
  80221a:	8b 45 08             	mov    0x8(%ebp),%eax
  80221d:	6a 00                	push   $0x0
  80221f:	53                   	push   %ebx
  802220:	51                   	push   %ecx
  802221:	52                   	push   %edx
  802222:	50                   	push   %eax
  802223:	6a 2e                	push   $0x2e
  802225:	e8 c7 f9 ff ff       	call   801bf1 <syscall>
  80222a:	83 c4 18             	add    $0x18,%esp
}
  80222d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802230:	c9                   	leave  
  802231:	c3                   	ret    

00802232 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802232:	55                   	push   %ebp
  802233:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802235:	8b 55 0c             	mov    0xc(%ebp),%edx
  802238:	8b 45 08             	mov    0x8(%ebp),%eax
  80223b:	6a 00                	push   $0x0
  80223d:	6a 00                	push   $0x0
  80223f:	6a 00                	push   $0x0
  802241:	52                   	push   %edx
  802242:	50                   	push   %eax
  802243:	6a 2f                	push   $0x2f
  802245:	e8 a7 f9 ff ff       	call   801bf1 <syscall>
  80224a:	83 c4 18             	add    $0x18,%esp
}
  80224d:	c9                   	leave  
  80224e:	c3                   	ret    

0080224f <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80224f:	55                   	push   %ebp
  802250:	89 e5                	mov    %esp,%ebp
  802252:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802255:	83 ec 0c             	sub    $0xc,%esp
  802258:	68 bc 40 80 00       	push   $0x8040bc
  80225d:	e8 21 e7 ff ff       	call   800983 <cprintf>
  802262:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802265:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80226c:	83 ec 0c             	sub    $0xc,%esp
  80226f:	68 e8 40 80 00       	push   $0x8040e8
  802274:	e8 0a e7 ff ff       	call   800983 <cprintf>
  802279:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  80227c:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802280:	a1 38 51 80 00       	mov    0x805138,%eax
  802285:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802288:	eb 56                	jmp    8022e0 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80228a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80228e:	74 1c                	je     8022ac <print_mem_block_lists+0x5d>
  802290:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802293:	8b 50 08             	mov    0x8(%eax),%edx
  802296:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802299:	8b 48 08             	mov    0x8(%eax),%ecx
  80229c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80229f:	8b 40 0c             	mov    0xc(%eax),%eax
  8022a2:	01 c8                	add    %ecx,%eax
  8022a4:	39 c2                	cmp    %eax,%edx
  8022a6:	73 04                	jae    8022ac <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8022a8:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8022ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022af:	8b 50 08             	mov    0x8(%eax),%edx
  8022b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b5:	8b 40 0c             	mov    0xc(%eax),%eax
  8022b8:	01 c2                	add    %eax,%edx
  8022ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022bd:	8b 40 08             	mov    0x8(%eax),%eax
  8022c0:	83 ec 04             	sub    $0x4,%esp
  8022c3:	52                   	push   %edx
  8022c4:	50                   	push   %eax
  8022c5:	68 fd 40 80 00       	push   $0x8040fd
  8022ca:	e8 b4 e6 ff ff       	call   800983 <cprintf>
  8022cf:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8022d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8022d8:	a1 40 51 80 00       	mov    0x805140,%eax
  8022dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022e4:	74 07                	je     8022ed <print_mem_block_lists+0x9e>
  8022e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e9:	8b 00                	mov    (%eax),%eax
  8022eb:	eb 05                	jmp    8022f2 <print_mem_block_lists+0xa3>
  8022ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8022f2:	a3 40 51 80 00       	mov    %eax,0x805140
  8022f7:	a1 40 51 80 00       	mov    0x805140,%eax
  8022fc:	85 c0                	test   %eax,%eax
  8022fe:	75 8a                	jne    80228a <print_mem_block_lists+0x3b>
  802300:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802304:	75 84                	jne    80228a <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802306:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80230a:	75 10                	jne    80231c <print_mem_block_lists+0xcd>
  80230c:	83 ec 0c             	sub    $0xc,%esp
  80230f:	68 0c 41 80 00       	push   $0x80410c
  802314:	e8 6a e6 ff ff       	call   800983 <cprintf>
  802319:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80231c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802323:	83 ec 0c             	sub    $0xc,%esp
  802326:	68 30 41 80 00       	push   $0x804130
  80232b:	e8 53 e6 ff ff       	call   800983 <cprintf>
  802330:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802333:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802337:	a1 40 50 80 00       	mov    0x805040,%eax
  80233c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80233f:	eb 56                	jmp    802397 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802341:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802345:	74 1c                	je     802363 <print_mem_block_lists+0x114>
  802347:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234a:	8b 50 08             	mov    0x8(%eax),%edx
  80234d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802350:	8b 48 08             	mov    0x8(%eax),%ecx
  802353:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802356:	8b 40 0c             	mov    0xc(%eax),%eax
  802359:	01 c8                	add    %ecx,%eax
  80235b:	39 c2                	cmp    %eax,%edx
  80235d:	73 04                	jae    802363 <print_mem_block_lists+0x114>
			sorted = 0 ;
  80235f:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802363:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802366:	8b 50 08             	mov    0x8(%eax),%edx
  802369:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236c:	8b 40 0c             	mov    0xc(%eax),%eax
  80236f:	01 c2                	add    %eax,%edx
  802371:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802374:	8b 40 08             	mov    0x8(%eax),%eax
  802377:	83 ec 04             	sub    $0x4,%esp
  80237a:	52                   	push   %edx
  80237b:	50                   	push   %eax
  80237c:	68 fd 40 80 00       	push   $0x8040fd
  802381:	e8 fd e5 ff ff       	call   800983 <cprintf>
  802386:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802389:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80238f:	a1 48 50 80 00       	mov    0x805048,%eax
  802394:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802397:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80239b:	74 07                	je     8023a4 <print_mem_block_lists+0x155>
  80239d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a0:	8b 00                	mov    (%eax),%eax
  8023a2:	eb 05                	jmp    8023a9 <print_mem_block_lists+0x15a>
  8023a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8023a9:	a3 48 50 80 00       	mov    %eax,0x805048
  8023ae:	a1 48 50 80 00       	mov    0x805048,%eax
  8023b3:	85 c0                	test   %eax,%eax
  8023b5:	75 8a                	jne    802341 <print_mem_block_lists+0xf2>
  8023b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023bb:	75 84                	jne    802341 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8023bd:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8023c1:	75 10                	jne    8023d3 <print_mem_block_lists+0x184>
  8023c3:	83 ec 0c             	sub    $0xc,%esp
  8023c6:	68 48 41 80 00       	push   $0x804148
  8023cb:	e8 b3 e5 ff ff       	call   800983 <cprintf>
  8023d0:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8023d3:	83 ec 0c             	sub    $0xc,%esp
  8023d6:	68 bc 40 80 00       	push   $0x8040bc
  8023db:	e8 a3 e5 ff ff       	call   800983 <cprintf>
  8023e0:	83 c4 10             	add    $0x10,%esp

}
  8023e3:	90                   	nop
  8023e4:	c9                   	leave  
  8023e5:	c3                   	ret    

008023e6 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8023e6:	55                   	push   %ebp
  8023e7:	89 e5                	mov    %esp,%ebp
  8023e9:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  8023ec:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8023f3:	00 00 00 
  8023f6:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8023fd:	00 00 00 
  802400:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802407:	00 00 00 
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  80240a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802411:	e9 9e 00 00 00       	jmp    8024b4 <initialize_MemBlocksList+0xce>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
  802416:	a1 50 50 80 00       	mov    0x805050,%eax
  80241b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80241e:	c1 e2 04             	shl    $0x4,%edx
  802421:	01 d0                	add    %edx,%eax
  802423:	85 c0                	test   %eax,%eax
  802425:	75 14                	jne    80243b <initialize_MemBlocksList+0x55>
  802427:	83 ec 04             	sub    $0x4,%esp
  80242a:	68 70 41 80 00       	push   $0x804170
  80242f:	6a 43                	push   $0x43
  802431:	68 93 41 80 00       	push   $0x804193
  802436:	e8 94 e2 ff ff       	call   8006cf <_panic>
  80243b:	a1 50 50 80 00       	mov    0x805050,%eax
  802440:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802443:	c1 e2 04             	shl    $0x4,%edx
  802446:	01 d0                	add    %edx,%eax
  802448:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80244e:	89 10                	mov    %edx,(%eax)
  802450:	8b 00                	mov    (%eax),%eax
  802452:	85 c0                	test   %eax,%eax
  802454:	74 18                	je     80246e <initialize_MemBlocksList+0x88>
  802456:	a1 48 51 80 00       	mov    0x805148,%eax
  80245b:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802461:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802464:	c1 e1 04             	shl    $0x4,%ecx
  802467:	01 ca                	add    %ecx,%edx
  802469:	89 50 04             	mov    %edx,0x4(%eax)
  80246c:	eb 12                	jmp    802480 <initialize_MemBlocksList+0x9a>
  80246e:	a1 50 50 80 00       	mov    0x805050,%eax
  802473:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802476:	c1 e2 04             	shl    $0x4,%edx
  802479:	01 d0                	add    %edx,%eax
  80247b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802480:	a1 50 50 80 00       	mov    0x805050,%eax
  802485:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802488:	c1 e2 04             	shl    $0x4,%edx
  80248b:	01 d0                	add    %edx,%eax
  80248d:	a3 48 51 80 00       	mov    %eax,0x805148
  802492:	a1 50 50 80 00       	mov    0x805050,%eax
  802497:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80249a:	c1 e2 04             	shl    $0x4,%edx
  80249d:	01 d0                	add    %edx,%eax
  80249f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024a6:	a1 54 51 80 00       	mov    0x805154,%eax
  8024ab:	40                   	inc    %eax
  8024ac:	a3 54 51 80 00       	mov    %eax,0x805154
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  8024b1:	ff 45 f4             	incl   -0xc(%ebp)
  8024b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024ba:	0f 82 56 ff ff ff    	jb     802416 <initialize_MemBlocksList+0x30>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
		}
}
  8024c0:	90                   	nop
  8024c1:	c9                   	leave  
  8024c2:	c3                   	ret    

008024c3 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8024c3:	55                   	push   %ebp
  8024c4:	89 e5                	mov    %esp,%ebp
  8024c6:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  8024c9:	a1 38 51 80 00       	mov    0x805138,%eax
  8024ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8024d1:	eb 18                	jmp    8024eb <find_block+0x28>
	{
		if (ele->sva==va)
  8024d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024d6:	8b 40 08             	mov    0x8(%eax),%eax
  8024d9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8024dc:	75 05                	jne    8024e3 <find_block+0x20>
			return ele;
  8024de:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024e1:	eb 7b                	jmp    80255e <find_block+0x9b>
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  8024e3:	a1 40 51 80 00       	mov    0x805140,%eax
  8024e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8024eb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8024ef:	74 07                	je     8024f8 <find_block+0x35>
  8024f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024f4:	8b 00                	mov    (%eax),%eax
  8024f6:	eb 05                	jmp    8024fd <find_block+0x3a>
  8024f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8024fd:	a3 40 51 80 00       	mov    %eax,0x805140
  802502:	a1 40 51 80 00       	mov    0x805140,%eax
  802507:	85 c0                	test   %eax,%eax
  802509:	75 c8                	jne    8024d3 <find_block+0x10>
  80250b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80250f:	75 c2                	jne    8024d3 <find_block+0x10>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  802511:	a1 40 50 80 00       	mov    0x805040,%eax
  802516:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802519:	eb 18                	jmp    802533 <find_block+0x70>
	{
		if (ele->sva==va)
  80251b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80251e:	8b 40 08             	mov    0x8(%eax),%eax
  802521:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802524:	75 05                	jne    80252b <find_block+0x68>
					return ele;
  802526:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802529:	eb 33                	jmp    80255e <find_block+0x9b>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  80252b:	a1 48 50 80 00       	mov    0x805048,%eax
  802530:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802533:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802537:	74 07                	je     802540 <find_block+0x7d>
  802539:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80253c:	8b 00                	mov    (%eax),%eax
  80253e:	eb 05                	jmp    802545 <find_block+0x82>
  802540:	b8 00 00 00 00       	mov    $0x0,%eax
  802545:	a3 48 50 80 00       	mov    %eax,0x805048
  80254a:	a1 48 50 80 00       	mov    0x805048,%eax
  80254f:	85 c0                	test   %eax,%eax
  802551:	75 c8                	jne    80251b <find_block+0x58>
  802553:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802557:	75 c2                	jne    80251b <find_block+0x58>
	{
		if (ele->sva==va)
					return ele;
	}
return NULL;
  802559:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  80255e:	c9                   	leave  
  80255f:	c3                   	ret    

00802560 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802560:	55                   	push   %ebp
  802561:	89 e5                	mov    %esp,%ebp
  802563:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;

int x =LIST_SIZE(&AllocMemBlocksList);
  802566:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80256b:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((x==0))
  80256e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802572:	75 62                	jne    8025d6 <insert_sorted_allocList+0x76>
	{
	//	blockToInsert=AllocMemBlocksList.lh_first;
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  802574:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802578:	75 14                	jne    80258e <insert_sorted_allocList+0x2e>
  80257a:	83 ec 04             	sub    $0x4,%esp
  80257d:	68 70 41 80 00       	push   $0x804170
  802582:	6a 69                	push   $0x69
  802584:	68 93 41 80 00       	push   $0x804193
  802589:	e8 41 e1 ff ff       	call   8006cf <_panic>
  80258e:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802594:	8b 45 08             	mov    0x8(%ebp),%eax
  802597:	89 10                	mov    %edx,(%eax)
  802599:	8b 45 08             	mov    0x8(%ebp),%eax
  80259c:	8b 00                	mov    (%eax),%eax
  80259e:	85 c0                	test   %eax,%eax
  8025a0:	74 0d                	je     8025af <insert_sorted_allocList+0x4f>
  8025a2:	a1 40 50 80 00       	mov    0x805040,%eax
  8025a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8025aa:	89 50 04             	mov    %edx,0x4(%eax)
  8025ad:	eb 08                	jmp    8025b7 <insert_sorted_allocList+0x57>
  8025af:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b2:	a3 44 50 80 00       	mov    %eax,0x805044
  8025b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ba:	a3 40 50 80 00       	mov    %eax,0x805040
  8025bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025c9:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8025ce:	40                   	inc    %eax
  8025cf:	a3 4c 50 80 00       	mov    %eax,0x80504c
  8025d4:	eb 72                	jmp    802648 <insert_sorted_allocList+0xe8>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
  8025d6:	a1 40 50 80 00       	mov    0x805040,%eax
  8025db:	8b 50 08             	mov    0x8(%eax),%edx
  8025de:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e1:	8b 40 08             	mov    0x8(%eax),%eax
  8025e4:	39 c2                	cmp    %eax,%edx
  8025e6:	76 60                	jbe    802648 <insert_sorted_allocList+0xe8>
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  8025e8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8025ec:	75 14                	jne    802602 <insert_sorted_allocList+0xa2>
  8025ee:	83 ec 04             	sub    $0x4,%esp
  8025f1:	68 70 41 80 00       	push   $0x804170
  8025f6:	6a 6d                	push   $0x6d
  8025f8:	68 93 41 80 00       	push   $0x804193
  8025fd:	e8 cd e0 ff ff       	call   8006cf <_panic>
  802602:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802608:	8b 45 08             	mov    0x8(%ebp),%eax
  80260b:	89 10                	mov    %edx,(%eax)
  80260d:	8b 45 08             	mov    0x8(%ebp),%eax
  802610:	8b 00                	mov    (%eax),%eax
  802612:	85 c0                	test   %eax,%eax
  802614:	74 0d                	je     802623 <insert_sorted_allocList+0xc3>
  802616:	a1 40 50 80 00       	mov    0x805040,%eax
  80261b:	8b 55 08             	mov    0x8(%ebp),%edx
  80261e:	89 50 04             	mov    %edx,0x4(%eax)
  802621:	eb 08                	jmp    80262b <insert_sorted_allocList+0xcb>
  802623:	8b 45 08             	mov    0x8(%ebp),%eax
  802626:	a3 44 50 80 00       	mov    %eax,0x805044
  80262b:	8b 45 08             	mov    0x8(%ebp),%eax
  80262e:	a3 40 50 80 00       	mov    %eax,0x805040
  802633:	8b 45 08             	mov    0x8(%ebp),%eax
  802636:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80263d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802642:	40                   	inc    %eax
  802643:	a3 4c 50 80 00       	mov    %eax,0x80504c
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  802648:	a1 40 50 80 00       	mov    0x805040,%eax
  80264d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802650:	e9 b9 01 00 00       	jmp    80280e <insert_sorted_allocList+0x2ae>
	{


		if ((blockToInsert->sva>AllocMemBlocksList.lh_first->sva)&&blockToInsert->sva<element->sva)
  802655:	8b 45 08             	mov    0x8(%ebp),%eax
  802658:	8b 50 08             	mov    0x8(%eax),%edx
  80265b:	a1 40 50 80 00       	mov    0x805040,%eax
  802660:	8b 40 08             	mov    0x8(%eax),%eax
  802663:	39 c2                	cmp    %eax,%edx
  802665:	76 7c                	jbe    8026e3 <insert_sorted_allocList+0x183>
  802667:	8b 45 08             	mov    0x8(%ebp),%eax
  80266a:	8b 50 08             	mov    0x8(%eax),%edx
  80266d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802670:	8b 40 08             	mov    0x8(%eax),%eax
  802673:	39 c2                	cmp    %eax,%edx
  802675:	73 6c                	jae    8026e3 <insert_sorted_allocList+0x183>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,element,blockToInsert);
  802677:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80267b:	74 06                	je     802683 <insert_sorted_allocList+0x123>
  80267d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802681:	75 14                	jne    802697 <insert_sorted_allocList+0x137>
  802683:	83 ec 04             	sub    $0x4,%esp
  802686:	68 ac 41 80 00       	push   $0x8041ac
  80268b:	6a 75                	push   $0x75
  80268d:	68 93 41 80 00       	push   $0x804193
  802692:	e8 38 e0 ff ff       	call   8006cf <_panic>
  802697:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269a:	8b 50 04             	mov    0x4(%eax),%edx
  80269d:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a0:	89 50 04             	mov    %edx,0x4(%eax)
  8026a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026a9:	89 10                	mov    %edx,(%eax)
  8026ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ae:	8b 40 04             	mov    0x4(%eax),%eax
  8026b1:	85 c0                	test   %eax,%eax
  8026b3:	74 0d                	je     8026c2 <insert_sorted_allocList+0x162>
  8026b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b8:	8b 40 04             	mov    0x4(%eax),%eax
  8026bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8026be:	89 10                	mov    %edx,(%eax)
  8026c0:	eb 08                	jmp    8026ca <insert_sorted_allocList+0x16a>
  8026c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c5:	a3 40 50 80 00       	mov    %eax,0x805040
  8026ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8026d0:	89 50 04             	mov    %edx,0x4(%eax)
  8026d3:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8026d8:	40                   	inc    %eax
  8026d9:	a3 4c 50 80 00       	mov    %eax,0x80504c

		break;}
  8026de:	e9 59 01 00 00       	jmp    80283c <insert_sorted_allocList+0x2dc>

	else if ((blockToInsert->sva>element->sva)&&(blockToInsert->sva<AllocMemBlocksList.lh_last->sva)&&blockToInsert->sva<LIST_NEXT(element)->sva)
  8026e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e6:	8b 50 08             	mov    0x8(%eax),%edx
  8026e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ec:	8b 40 08             	mov    0x8(%eax),%eax
  8026ef:	39 c2                	cmp    %eax,%edx
  8026f1:	0f 86 98 00 00 00    	jbe    80278f <insert_sorted_allocList+0x22f>
  8026f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026fa:	8b 50 08             	mov    0x8(%eax),%edx
  8026fd:	a1 44 50 80 00       	mov    0x805044,%eax
  802702:	8b 40 08             	mov    0x8(%eax),%eax
  802705:	39 c2                	cmp    %eax,%edx
  802707:	0f 83 82 00 00 00    	jae    80278f <insert_sorted_allocList+0x22f>
  80270d:	8b 45 08             	mov    0x8(%ebp),%eax
  802710:	8b 50 08             	mov    0x8(%eax),%edx
  802713:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802716:	8b 00                	mov    (%eax),%eax
  802718:	8b 40 08             	mov    0x8(%eax),%eax
  80271b:	39 c2                	cmp    %eax,%edx
  80271d:	73 70                	jae    80278f <insert_sorted_allocList+0x22f>
	{

	LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  80271f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802723:	74 06                	je     80272b <insert_sorted_allocList+0x1cb>
  802725:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802729:	75 14                	jne    80273f <insert_sorted_allocList+0x1df>
  80272b:	83 ec 04             	sub    $0x4,%esp
  80272e:	68 e4 41 80 00       	push   $0x8041e4
  802733:	6a 7c                	push   $0x7c
  802735:	68 93 41 80 00       	push   $0x804193
  80273a:	e8 90 df ff ff       	call   8006cf <_panic>
  80273f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802742:	8b 10                	mov    (%eax),%edx
  802744:	8b 45 08             	mov    0x8(%ebp),%eax
  802747:	89 10                	mov    %edx,(%eax)
  802749:	8b 45 08             	mov    0x8(%ebp),%eax
  80274c:	8b 00                	mov    (%eax),%eax
  80274e:	85 c0                	test   %eax,%eax
  802750:	74 0b                	je     80275d <insert_sorted_allocList+0x1fd>
  802752:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802755:	8b 00                	mov    (%eax),%eax
  802757:	8b 55 08             	mov    0x8(%ebp),%edx
  80275a:	89 50 04             	mov    %edx,0x4(%eax)
  80275d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802760:	8b 55 08             	mov    0x8(%ebp),%edx
  802763:	89 10                	mov    %edx,(%eax)
  802765:	8b 45 08             	mov    0x8(%ebp),%eax
  802768:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80276b:	89 50 04             	mov    %edx,0x4(%eax)
  80276e:	8b 45 08             	mov    0x8(%ebp),%eax
  802771:	8b 00                	mov    (%eax),%eax
  802773:	85 c0                	test   %eax,%eax
  802775:	75 08                	jne    80277f <insert_sorted_allocList+0x21f>
  802777:	8b 45 08             	mov    0x8(%ebp),%eax
  80277a:	a3 44 50 80 00       	mov    %eax,0x805044
  80277f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802784:	40                   	inc    %eax
  802785:	a3 4c 50 80 00       	mov    %eax,0x80504c
		break;
  80278a:	e9 ad 00 00 00       	jmp    80283c <insert_sorted_allocList+0x2dc>
	}else if (blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  80278f:	8b 45 08             	mov    0x8(%ebp),%eax
  802792:	8b 50 08             	mov    0x8(%eax),%edx
  802795:	a1 44 50 80 00       	mov    0x805044,%eax
  80279a:	8b 40 08             	mov    0x8(%eax),%eax
  80279d:	39 c2                	cmp    %eax,%edx
  80279f:	76 65                	jbe    802806 <insert_sorted_allocList+0x2a6>
	{
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
  8027a1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027a5:	75 17                	jne    8027be <insert_sorted_allocList+0x25e>
  8027a7:	83 ec 04             	sub    $0x4,%esp
  8027aa:	68 18 42 80 00       	push   $0x804218
  8027af:	68 80 00 00 00       	push   $0x80
  8027b4:	68 93 41 80 00       	push   $0x804193
  8027b9:	e8 11 df ff ff       	call   8006cf <_panic>
  8027be:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8027c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c7:	89 50 04             	mov    %edx,0x4(%eax)
  8027ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8027cd:	8b 40 04             	mov    0x4(%eax),%eax
  8027d0:	85 c0                	test   %eax,%eax
  8027d2:	74 0c                	je     8027e0 <insert_sorted_allocList+0x280>
  8027d4:	a1 44 50 80 00       	mov    0x805044,%eax
  8027d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8027dc:	89 10                	mov    %edx,(%eax)
  8027de:	eb 08                	jmp    8027e8 <insert_sorted_allocList+0x288>
  8027e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e3:	a3 40 50 80 00       	mov    %eax,0x805040
  8027e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8027eb:	a3 44 50 80 00       	mov    %eax,0x805044
  8027f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027f9:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8027fe:	40                   	inc    %eax
  8027ff:	a3 4c 50 80 00       	mov    %eax,0x80504c
		break;
  802804:	eb 36                	jmp    80283c <insert_sorted_allocList+0x2dc>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  802806:	a1 48 50 80 00       	mov    0x805048,%eax
  80280b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80280e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802812:	74 07                	je     80281b <insert_sorted_allocList+0x2bb>
  802814:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802817:	8b 00                	mov    (%eax),%eax
  802819:	eb 05                	jmp    802820 <insert_sorted_allocList+0x2c0>
  80281b:	b8 00 00 00 00       	mov    $0x0,%eax
  802820:	a3 48 50 80 00       	mov    %eax,0x805048
  802825:	a1 48 50 80 00       	mov    0x805048,%eax
  80282a:	85 c0                	test   %eax,%eax
  80282c:	0f 85 23 fe ff ff    	jne    802655 <insert_sorted_allocList+0xf5>
  802832:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802836:	0f 85 19 fe ff ff    	jne    802655 <insert_sorted_allocList+0xf5>
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
		break;

	}
	}
}
  80283c:	90                   	nop
  80283d:	c9                   	leave  
  80283e:	c3                   	ret    

0080283f <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80283f:	55                   	push   %ebp
  802840:	89 e5                	mov    %esp,%ebp
  802842:	83 ec 18             	sub    $0x18,%esp
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802845:	a1 38 51 80 00       	mov    0x805138,%eax
  80284a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80284d:	e9 7c 01 00 00       	jmp    8029ce <alloc_block_FF+0x18f>
		{
			// case 2
				if(element->size == size)
  802852:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802855:	8b 40 0c             	mov    0xc(%eax),%eax
  802858:	3b 45 08             	cmp    0x8(%ebp),%eax
  80285b:	0f 85 90 00 00 00    	jne    8028f1 <alloc_block_FF+0xb2>
				{
					tmp_block=element;
  802861:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802864:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,element);
  802867:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80286b:	75 17                	jne    802884 <alloc_block_FF+0x45>
  80286d:	83 ec 04             	sub    $0x4,%esp
  802870:	68 3b 42 80 00       	push   $0x80423b
  802875:	68 ba 00 00 00       	push   $0xba
  80287a:	68 93 41 80 00       	push   $0x804193
  80287f:	e8 4b de ff ff       	call   8006cf <_panic>
  802884:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802887:	8b 00                	mov    (%eax),%eax
  802889:	85 c0                	test   %eax,%eax
  80288b:	74 10                	je     80289d <alloc_block_FF+0x5e>
  80288d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802890:	8b 00                	mov    (%eax),%eax
  802892:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802895:	8b 52 04             	mov    0x4(%edx),%edx
  802898:	89 50 04             	mov    %edx,0x4(%eax)
  80289b:	eb 0b                	jmp    8028a8 <alloc_block_FF+0x69>
  80289d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a0:	8b 40 04             	mov    0x4(%eax),%eax
  8028a3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8028a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ab:	8b 40 04             	mov    0x4(%eax),%eax
  8028ae:	85 c0                	test   %eax,%eax
  8028b0:	74 0f                	je     8028c1 <alloc_block_FF+0x82>
  8028b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b5:	8b 40 04             	mov    0x4(%eax),%eax
  8028b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028bb:	8b 12                	mov    (%edx),%edx
  8028bd:	89 10                	mov    %edx,(%eax)
  8028bf:	eb 0a                	jmp    8028cb <alloc_block_FF+0x8c>
  8028c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c4:	8b 00                	mov    (%eax),%eax
  8028c6:	a3 38 51 80 00       	mov    %eax,0x805138
  8028cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028de:	a1 44 51 80 00       	mov    0x805144,%eax
  8028e3:	48                   	dec    %eax
  8028e4:	a3 44 51 80 00       	mov    %eax,0x805144
					return tmp_block;
  8028e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ec:	e9 10 01 00 00       	jmp    802a01 <alloc_block_FF+0x1c2>
				}
				 // case 3
				else if(element->size > size)
  8028f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f4:	8b 40 0c             	mov    0xc(%eax),%eax
  8028f7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028fa:	0f 86 c6 00 00 00    	jbe    8029c6 <alloc_block_FF+0x187>
				{
					// the new block are created
					tmp_block = AvailableMemBlocksList.lh_first ;
  802900:	a1 48 51 80 00       	mov    0x805148,%eax
  802905:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  802908:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80290c:	75 17                	jne    802925 <alloc_block_FF+0xe6>
  80290e:	83 ec 04             	sub    $0x4,%esp
  802911:	68 3b 42 80 00       	push   $0x80423b
  802916:	68 c2 00 00 00       	push   $0xc2
  80291b:	68 93 41 80 00       	push   $0x804193
  802920:	e8 aa dd ff ff       	call   8006cf <_panic>
  802925:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802928:	8b 00                	mov    (%eax),%eax
  80292a:	85 c0                	test   %eax,%eax
  80292c:	74 10                	je     80293e <alloc_block_FF+0xff>
  80292e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802931:	8b 00                	mov    (%eax),%eax
  802933:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802936:	8b 52 04             	mov    0x4(%edx),%edx
  802939:	89 50 04             	mov    %edx,0x4(%eax)
  80293c:	eb 0b                	jmp    802949 <alloc_block_FF+0x10a>
  80293e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802941:	8b 40 04             	mov    0x4(%eax),%eax
  802944:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802949:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80294c:	8b 40 04             	mov    0x4(%eax),%eax
  80294f:	85 c0                	test   %eax,%eax
  802951:	74 0f                	je     802962 <alloc_block_FF+0x123>
  802953:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802956:	8b 40 04             	mov    0x4(%eax),%eax
  802959:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80295c:	8b 12                	mov    (%edx),%edx
  80295e:	89 10                	mov    %edx,(%eax)
  802960:	eb 0a                	jmp    80296c <alloc_block_FF+0x12d>
  802962:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802965:	8b 00                	mov    (%eax),%eax
  802967:	a3 48 51 80 00       	mov    %eax,0x805148
  80296c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80296f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802975:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802978:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80297f:	a1 54 51 80 00       	mov    0x805154,%eax
  802984:	48                   	dec    %eax
  802985:	a3 54 51 80 00       	mov    %eax,0x805154
					tmp_block->sva=element->sva;
  80298a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298d:	8b 50 08             	mov    0x8(%eax),%edx
  802990:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802993:	89 50 08             	mov    %edx,0x8(%eax)
					tmp_block->size=size;
  802996:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802999:	8b 55 08             	mov    0x8(%ebp),%edx
  80299c:	89 50 0c             	mov    %edx,0xc(%eax)
					//update block with remaining space
					element->size-=size;
  80299f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8029a5:	2b 45 08             	sub    0x8(%ebp),%eax
  8029a8:	89 c2                	mov    %eax,%edx
  8029aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ad:	89 50 0c             	mov    %edx,0xc(%eax)
					element->sva = element->sva + size;
  8029b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b3:	8b 50 08             	mov    0x8(%eax),%edx
  8029b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b9:	01 c2                	add    %eax,%edx
  8029bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029be:	89 50 08             	mov    %edx,0x8(%eax)
					// return back the new block
					return tmp_block ;
  8029c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c4:	eb 3b                	jmp    802a01 <alloc_block_FF+0x1c2>
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  8029c6:	a1 40 51 80 00       	mov    0x805140,%eax
  8029cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029d2:	74 07                	je     8029db <alloc_block_FF+0x19c>
  8029d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d7:	8b 00                	mov    (%eax),%eax
  8029d9:	eb 05                	jmp    8029e0 <alloc_block_FF+0x1a1>
  8029db:	b8 00 00 00 00       	mov    $0x0,%eax
  8029e0:	a3 40 51 80 00       	mov    %eax,0x805140
  8029e5:	a1 40 51 80 00       	mov    0x805140,%eax
  8029ea:	85 c0                	test   %eax,%eax
  8029ec:	0f 85 60 fe ff ff    	jne    802852 <alloc_block_FF+0x13>
  8029f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029f6:	0f 85 56 fe ff ff    	jne    802852 <alloc_block_FF+0x13>
					// return back the new block
					return tmp_block ;
				}
		}
		// case 1
	  return NULL ;}
  8029fc:	b8 00 00 00 00       	mov    $0x0,%eax
  802a01:	c9                   	leave  
  802a02:	c3                   	ret    

00802a03 <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================

struct MemBlock *alloc_block_BF(uint32 size)
{
  802a03:	55                   	push   %ebp
  802a04:	89 e5                	mov    %esp,%ebp
  802a06:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
  802a09:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802a10:	a1 38 51 80 00       	mov    0x805138,%eax
  802a15:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a18:	eb 3a                	jmp    802a54 <alloc_block_BF+0x51>
		{
			if(element->size >= size)
  802a1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1d:	8b 40 0c             	mov    0xc(%eax),%eax
  802a20:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a23:	72 27                	jb     802a4c <alloc_block_BF+0x49>
			{
				if(best_size==-1)
  802a25:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802a29:	75 0b                	jne    802a36 <alloc_block_BF+0x33>
					best_size= element->size;
  802a2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2e:	8b 40 0c             	mov    0xc(%eax),%eax
  802a31:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802a34:	eb 16                	jmp    802a4c <alloc_block_BF+0x49>
				else if(best_size >= element->size)
  802a36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a39:	8b 50 0c             	mov    0xc(%eax),%edx
  802a3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a3f:	39 c2                	cmp    %eax,%edx
  802a41:	77 09                	ja     802a4c <alloc_block_BF+0x49>
					best_size=element->size;
  802a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a46:	8b 40 0c             	mov    0xc(%eax),%eax
  802a49:	89 45 f0             	mov    %eax,-0x10(%ebp)

struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802a4c:	a1 40 51 80 00       	mov    0x805140,%eax
  802a51:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a54:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a58:	74 07                	je     802a61 <alloc_block_BF+0x5e>
  802a5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5d:	8b 00                	mov    (%eax),%eax
  802a5f:	eb 05                	jmp    802a66 <alloc_block_BF+0x63>
  802a61:	b8 00 00 00 00       	mov    $0x0,%eax
  802a66:	a3 40 51 80 00       	mov    %eax,0x805140
  802a6b:	a1 40 51 80 00       	mov    0x805140,%eax
  802a70:	85 c0                	test   %eax,%eax
  802a72:	75 a6                	jne    802a1a <alloc_block_BF+0x17>
  802a74:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a78:	75 a0                	jne    802a1a <alloc_block_BF+0x17>
					best_size= element->size;
				else if(best_size >= element->size)
					best_size=element->size;
			}
		}
		if(best_size != -1)
  802a7a:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802a7e:	0f 84 d3 01 00 00    	je     802c57 <alloc_block_BF+0x254>
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  802a84:	a1 38 51 80 00       	mov    0x805138,%eax
  802a89:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a8c:	e9 98 01 00 00       	jmp    802c29 <alloc_block_BF+0x226>
			{
			 if((best_size > size) && (best_size == element->size))
  802a91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a94:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a97:	0f 86 da 00 00 00    	jbe    802b77 <alloc_block_BF+0x174>
  802a9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa0:	8b 50 0c             	mov    0xc(%eax),%edx
  802aa3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa6:	39 c2                	cmp    %eax,%edx
  802aa8:	0f 85 c9 00 00 00    	jne    802b77 <alloc_block_BF+0x174>
			  {
				// the new block are created
			    tmp_block = AvailableMemBlocksList.lh_first ;
  802aae:	a1 48 51 80 00       	mov    0x805148,%eax
  802ab3:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  802ab6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802aba:	75 17                	jne    802ad3 <alloc_block_BF+0xd0>
  802abc:	83 ec 04             	sub    $0x4,%esp
  802abf:	68 3b 42 80 00       	push   $0x80423b
  802ac4:	68 ea 00 00 00       	push   $0xea
  802ac9:	68 93 41 80 00       	push   $0x804193
  802ace:	e8 fc db ff ff       	call   8006cf <_panic>
  802ad3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ad6:	8b 00                	mov    (%eax),%eax
  802ad8:	85 c0                	test   %eax,%eax
  802ada:	74 10                	je     802aec <alloc_block_BF+0xe9>
  802adc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802adf:	8b 00                	mov    (%eax),%eax
  802ae1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ae4:	8b 52 04             	mov    0x4(%edx),%edx
  802ae7:	89 50 04             	mov    %edx,0x4(%eax)
  802aea:	eb 0b                	jmp    802af7 <alloc_block_BF+0xf4>
  802aec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aef:	8b 40 04             	mov    0x4(%eax),%eax
  802af2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802af7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802afa:	8b 40 04             	mov    0x4(%eax),%eax
  802afd:	85 c0                	test   %eax,%eax
  802aff:	74 0f                	je     802b10 <alloc_block_BF+0x10d>
  802b01:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b04:	8b 40 04             	mov    0x4(%eax),%eax
  802b07:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b0a:	8b 12                	mov    (%edx),%edx
  802b0c:	89 10                	mov    %edx,(%eax)
  802b0e:	eb 0a                	jmp    802b1a <alloc_block_BF+0x117>
  802b10:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b13:	8b 00                	mov    (%eax),%eax
  802b15:	a3 48 51 80 00       	mov    %eax,0x805148
  802b1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b1d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b23:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b26:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b2d:	a1 54 51 80 00       	mov    0x805154,%eax
  802b32:	48                   	dec    %eax
  802b33:	a3 54 51 80 00       	mov    %eax,0x805154
				tmp_block->sva=element->sva;
  802b38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3b:	8b 50 08             	mov    0x8(%eax),%edx
  802b3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b41:	89 50 08             	mov    %edx,0x8(%eax)
				tmp_block->size=size;
  802b44:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b47:	8b 55 08             	mov    0x8(%ebp),%edx
  802b4a:	89 50 0c             	mov    %edx,0xc(%eax)
				//update block with remaining space
				element->size-=size;
  802b4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b50:	8b 40 0c             	mov    0xc(%eax),%eax
  802b53:	2b 45 08             	sub    0x8(%ebp),%eax
  802b56:	89 c2                	mov    %eax,%edx
  802b58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5b:	89 50 0c             	mov    %edx,0xc(%eax)
				element->sva = element->sva + size;
  802b5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b61:	8b 50 08             	mov    0x8(%eax),%edx
  802b64:	8b 45 08             	mov    0x8(%ebp),%eax
  802b67:	01 c2                	add    %eax,%edx
  802b69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6c:	89 50 08             	mov    %edx,0x8(%eax)
				// return back the new block
				return tmp_block ;
  802b6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b72:	e9 e5 00 00 00       	jmp    802c5c <alloc_block_BF+0x259>

			  }
			else if((element->size == best_size)&&(best_size == size))
  802b77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7a:	8b 50 0c             	mov    0xc(%eax),%edx
  802b7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b80:	39 c2                	cmp    %eax,%edx
  802b82:	0f 85 99 00 00 00    	jne    802c21 <alloc_block_BF+0x21e>
  802b88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b8b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b8e:	0f 85 8d 00 00 00    	jne    802c21 <alloc_block_BF+0x21e>
			  {
				tmp_block=element;
  802b94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b97:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&FreeMemBlocksList,element);
  802b9a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b9e:	75 17                	jne    802bb7 <alloc_block_BF+0x1b4>
  802ba0:	83 ec 04             	sub    $0x4,%esp
  802ba3:	68 3b 42 80 00       	push   $0x80423b
  802ba8:	68 f7 00 00 00       	push   $0xf7
  802bad:	68 93 41 80 00       	push   $0x804193
  802bb2:	e8 18 db ff ff       	call   8006cf <_panic>
  802bb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bba:	8b 00                	mov    (%eax),%eax
  802bbc:	85 c0                	test   %eax,%eax
  802bbe:	74 10                	je     802bd0 <alloc_block_BF+0x1cd>
  802bc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc3:	8b 00                	mov    (%eax),%eax
  802bc5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bc8:	8b 52 04             	mov    0x4(%edx),%edx
  802bcb:	89 50 04             	mov    %edx,0x4(%eax)
  802bce:	eb 0b                	jmp    802bdb <alloc_block_BF+0x1d8>
  802bd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd3:	8b 40 04             	mov    0x4(%eax),%eax
  802bd6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802bdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bde:	8b 40 04             	mov    0x4(%eax),%eax
  802be1:	85 c0                	test   %eax,%eax
  802be3:	74 0f                	je     802bf4 <alloc_block_BF+0x1f1>
  802be5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be8:	8b 40 04             	mov    0x4(%eax),%eax
  802beb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bee:	8b 12                	mov    (%edx),%edx
  802bf0:	89 10                	mov    %edx,(%eax)
  802bf2:	eb 0a                	jmp    802bfe <alloc_block_BF+0x1fb>
  802bf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf7:	8b 00                	mov    (%eax),%eax
  802bf9:	a3 38 51 80 00       	mov    %eax,0x805138
  802bfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c01:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c11:	a1 44 51 80 00       	mov    0x805144,%eax
  802c16:	48                   	dec    %eax
  802c17:	a3 44 51 80 00       	mov    %eax,0x805144
				return tmp_block;
  802c1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c1f:	eb 3b                	jmp    802c5c <alloc_block_BF+0x259>
					best_size=element->size;
			}
		}
		if(best_size != -1)
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  802c21:	a1 40 51 80 00       	mov    0x805140,%eax
  802c26:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c29:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c2d:	74 07                	je     802c36 <alloc_block_BF+0x233>
  802c2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c32:	8b 00                	mov    (%eax),%eax
  802c34:	eb 05                	jmp    802c3b <alloc_block_BF+0x238>
  802c36:	b8 00 00 00 00       	mov    $0x0,%eax
  802c3b:	a3 40 51 80 00       	mov    %eax,0x805140
  802c40:	a1 40 51 80 00       	mov    0x805140,%eax
  802c45:	85 c0                	test   %eax,%eax
  802c47:	0f 85 44 fe ff ff    	jne    802a91 <alloc_block_BF+0x8e>
  802c4d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c51:	0f 85 3a fe ff ff    	jne    802a91 <alloc_block_BF+0x8e>
				LIST_REMOVE(&FreeMemBlocksList,element);
				return tmp_block;
			 }
			}
		}
		return NULL ;}
  802c57:	b8 00 00 00 00       	mov    $0x0,%eax
  802c5c:	c9                   	leave  
  802c5d:	c3                   	ret    

00802c5e <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802c5e:	55                   	push   %ebp
  802c5f:	89 e5                	mov    %esp,%ebp
  802c61:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802c64:	83 ec 04             	sub    $0x4,%esp
  802c67:	68 5c 42 80 00       	push   $0x80425c
  802c6c:	68 04 01 00 00       	push   $0x104
  802c71:	68 93 41 80 00       	push   $0x804193
  802c76:	e8 54 da ff ff       	call   8006cf <_panic>

00802c7b <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{struct MemBlock * blk_itr;
  802c7b:	55                   	push   %ebp
  802c7c:	89 e5                	mov    %esp,%ebp
  802c7e:	83 ec 18             	sub    $0x18,%esp
struct MemBlock * next;
struct MemBlock * first = LIST_FIRST(&(FreeMemBlocksList));
  802c81:	a1 38 51 80 00       	mov    0x805138,%eax
  802c86:	89 45 f0             	mov    %eax,-0x10(%ebp)
struct MemBlock * last = LIST_LAST(&(FreeMemBlocksList));
  802c89:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802c8e:	89 45 ec             	mov    %eax,-0x14(%ebp)

if(LIST_EMPTY(&(FreeMemBlocksList)))
  802c91:	a1 38 51 80 00       	mov    0x805138,%eax
  802c96:	85 c0                	test   %eax,%eax
  802c98:	75 68                	jne    802d02 <insert_sorted_with_merge_freeList+0x87>
			{

				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  802c9a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c9e:	75 17                	jne    802cb7 <insert_sorted_with_merge_freeList+0x3c>
  802ca0:	83 ec 04             	sub    $0x4,%esp
  802ca3:	68 70 41 80 00       	push   $0x804170
  802ca8:	68 14 01 00 00       	push   $0x114
  802cad:	68 93 41 80 00       	push   $0x804193
  802cb2:	e8 18 da ff ff       	call   8006cf <_panic>
  802cb7:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc0:	89 10                	mov    %edx,(%eax)
  802cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc5:	8b 00                	mov    (%eax),%eax
  802cc7:	85 c0                	test   %eax,%eax
  802cc9:	74 0d                	je     802cd8 <insert_sorted_with_merge_freeList+0x5d>
  802ccb:	a1 38 51 80 00       	mov    0x805138,%eax
  802cd0:	8b 55 08             	mov    0x8(%ebp),%edx
  802cd3:	89 50 04             	mov    %edx,0x4(%eax)
  802cd6:	eb 08                	jmp    802ce0 <insert_sorted_with_merge_freeList+0x65>
  802cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  802cdb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ce0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce3:	a3 38 51 80 00       	mov    %eax,0x805138
  802ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ceb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cf2:	a1 44 51 80 00       	mov    0x805144,%eax
  802cf7:	40                   	inc    %eax
  802cf8:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  802cfd:	e9 d2 06 00 00       	jmp    8033d4 <insert_sorted_with_merge_freeList+0x759>
				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);

			}
else
{
	if( blockToInsert->sva  < first->sva )
  802d02:	8b 45 08             	mov    0x8(%ebp),%eax
  802d05:	8b 50 08             	mov    0x8(%eax),%edx
  802d08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d0b:	8b 40 08             	mov    0x8(%eax),%eax
  802d0e:	39 c2                	cmp    %eax,%edx
  802d10:	0f 83 22 01 00 00    	jae    802e38 <insert_sorted_with_merge_freeList+0x1bd>
	{
                if( blockToInsert->sva + blockToInsert->size == first->sva)
  802d16:	8b 45 08             	mov    0x8(%ebp),%eax
  802d19:	8b 50 08             	mov    0x8(%eax),%edx
  802d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1f:	8b 40 0c             	mov    0xc(%eax),%eax
  802d22:	01 c2                	add    %eax,%edx
  802d24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d27:	8b 40 08             	mov    0x8(%eax),%eax
  802d2a:	39 c2                	cmp    %eax,%edx
  802d2c:	0f 85 9e 00 00 00    	jne    802dd0 <insert_sorted_with_merge_freeList+0x155>
                {

                	first->sva = blockToInsert->sva;
  802d32:	8b 45 08             	mov    0x8(%ebp),%eax
  802d35:	8b 50 08             	mov    0x8(%eax),%edx
  802d38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d3b:	89 50 08             	mov    %edx,0x8(%eax)
                	first->size = first->size + blockToInsert->size;
  802d3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d41:	8b 50 0c             	mov    0xc(%eax),%edx
  802d44:	8b 45 08             	mov    0x8(%ebp),%eax
  802d47:	8b 40 0c             	mov    0xc(%eax),%eax
  802d4a:	01 c2                	add    %eax,%edx
  802d4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d4f:	89 50 0c             	mov    %edx,0xc(%eax)
                	blockToInsert->size = blockToInsert->sva = 0;
  802d52:	8b 45 08             	mov    0x8(%ebp),%eax
  802d55:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5f:	8b 50 08             	mov    0x8(%eax),%edx
  802d62:	8b 45 08             	mov    0x8(%ebp),%eax
  802d65:	89 50 0c             	mov    %edx,0xc(%eax)
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802d68:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d6c:	75 17                	jne    802d85 <insert_sorted_with_merge_freeList+0x10a>
  802d6e:	83 ec 04             	sub    $0x4,%esp
  802d71:	68 70 41 80 00       	push   $0x804170
  802d76:	68 21 01 00 00       	push   $0x121
  802d7b:	68 93 41 80 00       	push   $0x804193
  802d80:	e8 4a d9 ff ff       	call   8006cf <_panic>
  802d85:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8e:	89 10                	mov    %edx,(%eax)
  802d90:	8b 45 08             	mov    0x8(%ebp),%eax
  802d93:	8b 00                	mov    (%eax),%eax
  802d95:	85 c0                	test   %eax,%eax
  802d97:	74 0d                	je     802da6 <insert_sorted_with_merge_freeList+0x12b>
  802d99:	a1 48 51 80 00       	mov    0x805148,%eax
  802d9e:	8b 55 08             	mov    0x8(%ebp),%edx
  802da1:	89 50 04             	mov    %edx,0x4(%eax)
  802da4:	eb 08                	jmp    802dae <insert_sorted_with_merge_freeList+0x133>
  802da6:	8b 45 08             	mov    0x8(%ebp),%eax
  802da9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802dae:	8b 45 08             	mov    0x8(%ebp),%eax
  802db1:	a3 48 51 80 00       	mov    %eax,0x805148
  802db6:	8b 45 08             	mov    0x8(%ebp),%eax
  802db9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dc0:	a1 54 51 80 00       	mov    0x805154,%eax
  802dc5:	40                   	inc    %eax
  802dc6:	a3 54 51 80 00       	mov    %eax,0x805154
						}
				}
        }

}
}
  802dcb:	e9 04 06 00 00       	jmp    8033d4 <insert_sorted_with_merge_freeList+0x759>
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
                }

                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  802dd0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dd4:	75 17                	jne    802ded <insert_sorted_with_merge_freeList+0x172>
  802dd6:	83 ec 04             	sub    $0x4,%esp
  802dd9:	68 70 41 80 00       	push   $0x804170
  802dde:	68 26 01 00 00       	push   $0x126
  802de3:	68 93 41 80 00       	push   $0x804193
  802de8:	e8 e2 d8 ff ff       	call   8006cf <_panic>
  802ded:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802df3:	8b 45 08             	mov    0x8(%ebp),%eax
  802df6:	89 10                	mov    %edx,(%eax)
  802df8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfb:	8b 00                	mov    (%eax),%eax
  802dfd:	85 c0                	test   %eax,%eax
  802dff:	74 0d                	je     802e0e <insert_sorted_with_merge_freeList+0x193>
  802e01:	a1 38 51 80 00       	mov    0x805138,%eax
  802e06:	8b 55 08             	mov    0x8(%ebp),%edx
  802e09:	89 50 04             	mov    %edx,0x4(%eax)
  802e0c:	eb 08                	jmp    802e16 <insert_sorted_with_merge_freeList+0x19b>
  802e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e11:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e16:	8b 45 08             	mov    0x8(%ebp),%eax
  802e19:	a3 38 51 80 00       	mov    %eax,0x805138
  802e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e21:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e28:	a1 44 51 80 00       	mov    0x805144,%eax
  802e2d:	40                   	inc    %eax
  802e2e:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  802e33:	e9 9c 05 00 00       	jmp    8033d4 <insert_sorted_with_merge_freeList+0x759>
                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
                }
	}
    else if(blockToInsert->sva > last->sva)
  802e38:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3b:	8b 50 08             	mov    0x8(%eax),%edx
  802e3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e41:	8b 40 08             	mov    0x8(%eax),%eax
  802e44:	39 c2                	cmp    %eax,%edx
  802e46:	0f 86 16 01 00 00    	jbe    802f62 <insert_sorted_with_merge_freeList+0x2e7>
 	{

				if(last->sva + last->size == blockToInsert->sva)
  802e4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e4f:	8b 50 08             	mov    0x8(%eax),%edx
  802e52:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e55:	8b 40 0c             	mov    0xc(%eax),%eax
  802e58:	01 c2                	add    %eax,%edx
  802e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5d:	8b 40 08             	mov    0x8(%eax),%eax
  802e60:	39 c2                	cmp    %eax,%edx
  802e62:	0f 85 92 00 00 00    	jne    802efa <insert_sorted_with_merge_freeList+0x27f>
				{

					last->size = last->size + blockToInsert->size;
  802e68:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e6b:	8b 50 0c             	mov    0xc(%eax),%edx
  802e6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e71:	8b 40 0c             	mov    0xc(%eax),%eax
  802e74:	01 c2                	add    %eax,%edx
  802e76:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e79:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->size = blockToInsert->sva = 0;
  802e7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802e86:	8b 45 08             	mov    0x8(%ebp),%eax
  802e89:	8b 50 08             	mov    0x8(%eax),%edx
  802e8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8f:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802e92:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e96:	75 17                	jne    802eaf <insert_sorted_with_merge_freeList+0x234>
  802e98:	83 ec 04             	sub    $0x4,%esp
  802e9b:	68 70 41 80 00       	push   $0x804170
  802ea0:	68 31 01 00 00       	push   $0x131
  802ea5:	68 93 41 80 00       	push   $0x804193
  802eaa:	e8 20 d8 ff ff       	call   8006cf <_panic>
  802eaf:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb8:	89 10                	mov    %edx,(%eax)
  802eba:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebd:	8b 00                	mov    (%eax),%eax
  802ebf:	85 c0                	test   %eax,%eax
  802ec1:	74 0d                	je     802ed0 <insert_sorted_with_merge_freeList+0x255>
  802ec3:	a1 48 51 80 00       	mov    0x805148,%eax
  802ec8:	8b 55 08             	mov    0x8(%ebp),%edx
  802ecb:	89 50 04             	mov    %edx,0x4(%eax)
  802ece:	eb 08                	jmp    802ed8 <insert_sorted_with_merge_freeList+0x25d>
  802ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  802edb:	a3 48 51 80 00       	mov    %eax,0x805148
  802ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eea:	a1 54 51 80 00       	mov    0x805154,%eax
  802eef:	40                   	inc    %eax
  802ef0:	a3 54 51 80 00       	mov    %eax,0x805154
						}
				}
        }

}
}
  802ef5:	e9 da 04 00 00       	jmp    8033d4 <insert_sorted_with_merge_freeList+0x759>

				}

				else
				{
					LIST_INSERT_TAIL(&(FreeMemBlocksList),  blockToInsert);
  802efa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802efe:	75 17                	jne    802f17 <insert_sorted_with_merge_freeList+0x29c>
  802f00:	83 ec 04             	sub    $0x4,%esp
  802f03:	68 18 42 80 00       	push   $0x804218
  802f08:	68 37 01 00 00       	push   $0x137
  802f0d:	68 93 41 80 00       	push   $0x804193
  802f12:	e8 b8 d7 ff ff       	call   8006cf <_panic>
  802f17:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f20:	89 50 04             	mov    %edx,0x4(%eax)
  802f23:	8b 45 08             	mov    0x8(%ebp),%eax
  802f26:	8b 40 04             	mov    0x4(%eax),%eax
  802f29:	85 c0                	test   %eax,%eax
  802f2b:	74 0c                	je     802f39 <insert_sorted_with_merge_freeList+0x2be>
  802f2d:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f32:	8b 55 08             	mov    0x8(%ebp),%edx
  802f35:	89 10                	mov    %edx,(%eax)
  802f37:	eb 08                	jmp    802f41 <insert_sorted_with_merge_freeList+0x2c6>
  802f39:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3c:	a3 38 51 80 00       	mov    %eax,0x805138
  802f41:	8b 45 08             	mov    0x8(%ebp),%eax
  802f44:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f49:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f52:	a1 44 51 80 00       	mov    0x805144,%eax
  802f57:	40                   	inc    %eax
  802f58:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  802f5d:	e9 72 04 00 00       	jmp    8033d4 <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  802f62:	a1 38 51 80 00       	mov    0x805138,%eax
  802f67:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f6a:	e9 35 04 00 00       	jmp    8033a4 <insert_sorted_with_merge_freeList+0x729>
				{
				     next=LIST_NEXT(blk_itr);
  802f6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f72:	8b 00                	mov    (%eax),%eax
  802f74:	89 45 e8             	mov    %eax,-0x18(%ebp)


					if( (blockToInsert->sva > blk_itr->sva) )
  802f77:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7a:	8b 50 08             	mov    0x8(%eax),%edx
  802f7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f80:	8b 40 08             	mov    0x8(%eax),%eax
  802f83:	39 c2                	cmp    %eax,%edx
  802f85:	0f 86 11 04 00 00    	jbe    80339c <insert_sorted_with_merge_freeList+0x721>
						{
							if(((blk_itr->sva) + (blk_itr->size) < blockToInsert->sva && (blockToInsert->sva) + (blockToInsert->size) < next->sva))
  802f8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8e:	8b 50 08             	mov    0x8(%eax),%edx
  802f91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f94:	8b 40 0c             	mov    0xc(%eax),%eax
  802f97:	01 c2                	add    %eax,%edx
  802f99:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9c:	8b 40 08             	mov    0x8(%eax),%eax
  802f9f:	39 c2                	cmp    %eax,%edx
  802fa1:	0f 83 8b 00 00 00    	jae    803032 <insert_sorted_with_merge_freeList+0x3b7>
  802fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  802faa:	8b 50 08             	mov    0x8(%eax),%edx
  802fad:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb0:	8b 40 0c             	mov    0xc(%eax),%eax
  802fb3:	01 c2                	add    %eax,%edx
  802fb5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fb8:	8b 40 08             	mov    0x8(%eax),%eax
  802fbb:	39 c2                	cmp    %eax,%edx
  802fbd:	73 73                	jae    803032 <insert_sorted_with_merge_freeList+0x3b7>
							{
								LIST_INSERT_AFTER(&(FreeMemBlocksList), blk_itr, blockToInsert);
  802fbf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fc3:	74 06                	je     802fcb <insert_sorted_with_merge_freeList+0x350>
  802fc5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fc9:	75 17                	jne    802fe2 <insert_sorted_with_merge_freeList+0x367>
  802fcb:	83 ec 04             	sub    $0x4,%esp
  802fce:	68 e4 41 80 00       	push   $0x8041e4
  802fd3:	68 48 01 00 00       	push   $0x148
  802fd8:	68 93 41 80 00       	push   $0x804193
  802fdd:	e8 ed d6 ff ff       	call   8006cf <_panic>
  802fe2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe5:	8b 10                	mov    (%eax),%edx
  802fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fea:	89 10                	mov    %edx,(%eax)
  802fec:	8b 45 08             	mov    0x8(%ebp),%eax
  802fef:	8b 00                	mov    (%eax),%eax
  802ff1:	85 c0                	test   %eax,%eax
  802ff3:	74 0b                	je     803000 <insert_sorted_with_merge_freeList+0x385>
  802ff5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff8:	8b 00                	mov    (%eax),%eax
  802ffa:	8b 55 08             	mov    0x8(%ebp),%edx
  802ffd:	89 50 04             	mov    %edx,0x4(%eax)
  803000:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803003:	8b 55 08             	mov    0x8(%ebp),%edx
  803006:	89 10                	mov    %edx,(%eax)
  803008:	8b 45 08             	mov    0x8(%ebp),%eax
  80300b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80300e:	89 50 04             	mov    %edx,0x4(%eax)
  803011:	8b 45 08             	mov    0x8(%ebp),%eax
  803014:	8b 00                	mov    (%eax),%eax
  803016:	85 c0                	test   %eax,%eax
  803018:	75 08                	jne    803022 <insert_sorted_with_merge_freeList+0x3a7>
  80301a:	8b 45 08             	mov    0x8(%ebp),%eax
  80301d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803022:	a1 44 51 80 00       	mov    0x805144,%eax
  803027:	40                   	inc    %eax
  803028:	a3 44 51 80 00       	mov    %eax,0x805144
								break;
  80302d:	e9 a2 03 00 00       	jmp    8033d4 <insert_sorted_with_merge_freeList+0x759>

							}
							else if((blockToInsert->sva + blockToInsert->size) < next->sva  && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  803032:	8b 45 08             	mov    0x8(%ebp),%eax
  803035:	8b 50 08             	mov    0x8(%eax),%edx
  803038:	8b 45 08             	mov    0x8(%ebp),%eax
  80303b:	8b 40 0c             	mov    0xc(%eax),%eax
  80303e:	01 c2                	add    %eax,%edx
  803040:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803043:	8b 40 08             	mov    0x8(%eax),%eax
  803046:	39 c2                	cmp    %eax,%edx
  803048:	0f 83 ae 00 00 00    	jae    8030fc <insert_sorted_with_merge_freeList+0x481>
  80304e:	8b 45 08             	mov    0x8(%ebp),%eax
  803051:	8b 50 08             	mov    0x8(%eax),%edx
  803054:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803057:	8b 48 08             	mov    0x8(%eax),%ecx
  80305a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305d:	8b 40 0c             	mov    0xc(%eax),%eax
  803060:	01 c8                	add    %ecx,%eax
  803062:	39 c2                	cmp    %eax,%edx
  803064:	0f 85 92 00 00 00    	jne    8030fc <insert_sorted_with_merge_freeList+0x481>
							{

								blk_itr->size=blk_itr->size+blockToInsert->size;
  80306a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306d:	8b 50 0c             	mov    0xc(%eax),%edx
  803070:	8b 45 08             	mov    0x8(%ebp),%eax
  803073:	8b 40 0c             	mov    0xc(%eax),%eax
  803076:	01 c2                	add    %eax,%edx
  803078:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307b:	89 50 0c             	mov    %edx,0xc(%eax)
								 blockToInsert->size=blockToInsert->sva=0;
  80307e:	8b 45 08             	mov    0x8(%ebp),%eax
  803081:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803088:	8b 45 08             	mov    0x8(%ebp),%eax
  80308b:	8b 50 08             	mov    0x8(%eax),%edx
  80308e:	8b 45 08             	mov    0x8(%ebp),%eax
  803091:	89 50 0c             	mov    %edx,0xc(%eax)
								 LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  803094:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803098:	75 17                	jne    8030b1 <insert_sorted_with_merge_freeList+0x436>
  80309a:	83 ec 04             	sub    $0x4,%esp
  80309d:	68 70 41 80 00       	push   $0x804170
  8030a2:	68 51 01 00 00       	push   $0x151
  8030a7:	68 93 41 80 00       	push   $0x804193
  8030ac:	e8 1e d6 ff ff       	call   8006cf <_panic>
  8030b1:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8030b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ba:	89 10                	mov    %edx,(%eax)
  8030bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8030bf:	8b 00                	mov    (%eax),%eax
  8030c1:	85 c0                	test   %eax,%eax
  8030c3:	74 0d                	je     8030d2 <insert_sorted_with_merge_freeList+0x457>
  8030c5:	a1 48 51 80 00       	mov    0x805148,%eax
  8030ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8030cd:	89 50 04             	mov    %edx,0x4(%eax)
  8030d0:	eb 08                	jmp    8030da <insert_sorted_with_merge_freeList+0x45f>
  8030d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030da:	8b 45 08             	mov    0x8(%ebp),%eax
  8030dd:	a3 48 51 80 00       	mov    %eax,0x805148
  8030e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030ec:	a1 54 51 80 00       	mov    0x805154,%eax
  8030f1:	40                   	inc    %eax
  8030f2:	a3 54 51 80 00       	mov    %eax,0x805154
								 break;
  8030f7:	e9 d8 02 00 00       	jmp    8033d4 <insert_sorted_with_merge_freeList+0x759>

							}
							else if( (blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva > (blk_itr->sva + blk_itr->size))
  8030fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ff:	8b 50 08             	mov    0x8(%eax),%edx
  803102:	8b 45 08             	mov    0x8(%ebp),%eax
  803105:	8b 40 0c             	mov    0xc(%eax),%eax
  803108:	01 c2                	add    %eax,%edx
  80310a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80310d:	8b 40 08             	mov    0x8(%eax),%eax
  803110:	39 c2                	cmp    %eax,%edx
  803112:	0f 85 ba 00 00 00    	jne    8031d2 <insert_sorted_with_merge_freeList+0x557>
  803118:	8b 45 08             	mov    0x8(%ebp),%eax
  80311b:	8b 50 08             	mov    0x8(%eax),%edx
  80311e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803121:	8b 48 08             	mov    0x8(%eax),%ecx
  803124:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803127:	8b 40 0c             	mov    0xc(%eax),%eax
  80312a:	01 c8                	add    %ecx,%eax
  80312c:	39 c2                	cmp    %eax,%edx
  80312e:	0f 86 9e 00 00 00    	jbe    8031d2 <insert_sorted_with_merge_freeList+0x557>
							{
								next->size = next->size + blockToInsert->size;
  803134:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803137:	8b 50 0c             	mov    0xc(%eax),%edx
  80313a:	8b 45 08             	mov    0x8(%ebp),%eax
  80313d:	8b 40 0c             	mov    0xc(%eax),%eax
  803140:	01 c2                	add    %eax,%edx
  803142:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803145:	89 50 0c             	mov    %edx,0xc(%eax)
								next->sva = blockToInsert->sva;
  803148:	8b 45 08             	mov    0x8(%ebp),%eax
  80314b:	8b 50 08             	mov    0x8(%eax),%edx
  80314e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803151:	89 50 08             	mov    %edx,0x8(%eax)

								blockToInsert->size = blockToInsert->sva = 0;
  803154:	8b 45 08             	mov    0x8(%ebp),%eax
  803157:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80315e:	8b 45 08             	mov    0x8(%ebp),%eax
  803161:	8b 50 08             	mov    0x8(%eax),%edx
  803164:	8b 45 08             	mov    0x8(%ebp),%eax
  803167:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  80316a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80316e:	75 17                	jne    803187 <insert_sorted_with_merge_freeList+0x50c>
  803170:	83 ec 04             	sub    $0x4,%esp
  803173:	68 70 41 80 00       	push   $0x804170
  803178:	68 5b 01 00 00       	push   $0x15b
  80317d:	68 93 41 80 00       	push   $0x804193
  803182:	e8 48 d5 ff ff       	call   8006cf <_panic>
  803187:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80318d:	8b 45 08             	mov    0x8(%ebp),%eax
  803190:	89 10                	mov    %edx,(%eax)
  803192:	8b 45 08             	mov    0x8(%ebp),%eax
  803195:	8b 00                	mov    (%eax),%eax
  803197:	85 c0                	test   %eax,%eax
  803199:	74 0d                	je     8031a8 <insert_sorted_with_merge_freeList+0x52d>
  80319b:	a1 48 51 80 00       	mov    0x805148,%eax
  8031a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8031a3:	89 50 04             	mov    %edx,0x4(%eax)
  8031a6:	eb 08                	jmp    8031b0 <insert_sorted_with_merge_freeList+0x535>
  8031a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ab:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b3:	a3 48 51 80 00       	mov    %eax,0x805148
  8031b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031bb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031c2:	a1 54 51 80 00       	mov    0x805154,%eax
  8031c7:	40                   	inc    %eax
  8031c8:	a3 54 51 80 00       	mov    %eax,0x805154
								break;
  8031cd:	e9 02 02 00 00       	jmp    8033d4 <insert_sorted_with_merge_freeList+0x759>
							}
							else if ((blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  8031d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d5:	8b 50 08             	mov    0x8(%eax),%edx
  8031d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031db:	8b 40 0c             	mov    0xc(%eax),%eax
  8031de:	01 c2                	add    %eax,%edx
  8031e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e3:	8b 40 08             	mov    0x8(%eax),%eax
  8031e6:	39 c2                	cmp    %eax,%edx
  8031e8:	0f 85 ae 01 00 00    	jne    80339c <insert_sorted_with_merge_freeList+0x721>
  8031ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f1:	8b 50 08             	mov    0x8(%eax),%edx
  8031f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f7:	8b 48 08             	mov    0x8(%eax),%ecx
  8031fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031fd:	8b 40 0c             	mov    0xc(%eax),%eax
  803200:	01 c8                	add    %ecx,%eax
  803202:	39 c2                	cmp    %eax,%edx
  803204:	0f 85 92 01 00 00    	jne    80339c <insert_sorted_with_merge_freeList+0x721>
							{
								blk_itr->size = blk_itr->size + blockToInsert->size + next->size;
  80320a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80320d:	8b 50 0c             	mov    0xc(%eax),%edx
  803210:	8b 45 08             	mov    0x8(%ebp),%eax
  803213:	8b 40 0c             	mov    0xc(%eax),%eax
  803216:	01 c2                	add    %eax,%edx
  803218:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80321b:	8b 40 0c             	mov    0xc(%eax),%eax
  80321e:	01 c2                	add    %eax,%edx
  803220:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803223:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size = blockToInsert->sva=0;
  803226:	8b 45 08             	mov    0x8(%ebp),%eax
  803229:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803230:	8b 45 08             	mov    0x8(%ebp),%eax
  803233:	8b 50 08             	mov    0x8(%eax),%edx
  803236:	8b 45 08             	mov    0x8(%ebp),%eax
  803239:	89 50 0c             	mov    %edx,0xc(%eax)
								next->size = next->sva = 0;
  80323c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80323f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803246:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803249:	8b 50 08             	mov    0x8(%eax),%edx
  80324c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80324f:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_REMOVE(&FreeMemBlocksList, next);
  803252:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803256:	75 17                	jne    80326f <insert_sorted_with_merge_freeList+0x5f4>
  803258:	83 ec 04             	sub    $0x4,%esp
  80325b:	68 3b 42 80 00       	push   $0x80423b
  803260:	68 63 01 00 00       	push   $0x163
  803265:	68 93 41 80 00       	push   $0x804193
  80326a:	e8 60 d4 ff ff       	call   8006cf <_panic>
  80326f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803272:	8b 00                	mov    (%eax),%eax
  803274:	85 c0                	test   %eax,%eax
  803276:	74 10                	je     803288 <insert_sorted_with_merge_freeList+0x60d>
  803278:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80327b:	8b 00                	mov    (%eax),%eax
  80327d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803280:	8b 52 04             	mov    0x4(%edx),%edx
  803283:	89 50 04             	mov    %edx,0x4(%eax)
  803286:	eb 0b                	jmp    803293 <insert_sorted_with_merge_freeList+0x618>
  803288:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80328b:	8b 40 04             	mov    0x4(%eax),%eax
  80328e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803293:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803296:	8b 40 04             	mov    0x4(%eax),%eax
  803299:	85 c0                	test   %eax,%eax
  80329b:	74 0f                	je     8032ac <insert_sorted_with_merge_freeList+0x631>
  80329d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a0:	8b 40 04             	mov    0x4(%eax),%eax
  8032a3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032a6:	8b 12                	mov    (%edx),%edx
  8032a8:	89 10                	mov    %edx,(%eax)
  8032aa:	eb 0a                	jmp    8032b6 <insert_sorted_with_merge_freeList+0x63b>
  8032ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032af:	8b 00                	mov    (%eax),%eax
  8032b1:	a3 38 51 80 00       	mov    %eax,0x805138
  8032b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032c9:	a1 44 51 80 00       	mov    0x805144,%eax
  8032ce:	48                   	dec    %eax
  8032cf:	a3 44 51 80 00       	mov    %eax,0x805144
								LIST_INSERT_HEAD(&AvailableMemBlocksList, next );
  8032d4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032d8:	75 17                	jne    8032f1 <insert_sorted_with_merge_freeList+0x676>
  8032da:	83 ec 04             	sub    $0x4,%esp
  8032dd:	68 70 41 80 00       	push   $0x804170
  8032e2:	68 64 01 00 00       	push   $0x164
  8032e7:	68 93 41 80 00       	push   $0x804193
  8032ec:	e8 de d3 ff ff       	call   8006cf <_panic>
  8032f1:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032fa:	89 10                	mov    %edx,(%eax)
  8032fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ff:	8b 00                	mov    (%eax),%eax
  803301:	85 c0                	test   %eax,%eax
  803303:	74 0d                	je     803312 <insert_sorted_with_merge_freeList+0x697>
  803305:	a1 48 51 80 00       	mov    0x805148,%eax
  80330a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80330d:	89 50 04             	mov    %edx,0x4(%eax)
  803310:	eb 08                	jmp    80331a <insert_sorted_with_merge_freeList+0x69f>
  803312:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803315:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80331a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80331d:	a3 48 51 80 00       	mov    %eax,0x805148
  803322:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803325:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80332c:	a1 54 51 80 00       	mov    0x805154,%eax
  803331:	40                   	inc    %eax
  803332:	a3 54 51 80 00       	mov    %eax,0x805154
							    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  803337:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80333b:	75 17                	jne    803354 <insert_sorted_with_merge_freeList+0x6d9>
  80333d:	83 ec 04             	sub    $0x4,%esp
  803340:	68 70 41 80 00       	push   $0x804170
  803345:	68 65 01 00 00       	push   $0x165
  80334a:	68 93 41 80 00       	push   $0x804193
  80334f:	e8 7b d3 ff ff       	call   8006cf <_panic>
  803354:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80335a:	8b 45 08             	mov    0x8(%ebp),%eax
  80335d:	89 10                	mov    %edx,(%eax)
  80335f:	8b 45 08             	mov    0x8(%ebp),%eax
  803362:	8b 00                	mov    (%eax),%eax
  803364:	85 c0                	test   %eax,%eax
  803366:	74 0d                	je     803375 <insert_sorted_with_merge_freeList+0x6fa>
  803368:	a1 48 51 80 00       	mov    0x805148,%eax
  80336d:	8b 55 08             	mov    0x8(%ebp),%edx
  803370:	89 50 04             	mov    %edx,0x4(%eax)
  803373:	eb 08                	jmp    80337d <insert_sorted_with_merge_freeList+0x702>
  803375:	8b 45 08             	mov    0x8(%ebp),%eax
  803378:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80337d:	8b 45 08             	mov    0x8(%ebp),%eax
  803380:	a3 48 51 80 00       	mov    %eax,0x805148
  803385:	8b 45 08             	mov    0x8(%ebp),%eax
  803388:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80338f:	a1 54 51 80 00       	mov    0x805154,%eax
  803394:	40                   	inc    %eax
  803395:	a3 54 51 80 00       	mov    %eax,0x805154
								break;
  80339a:	eb 38                	jmp    8033d4 <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  80339c:	a1 40 51 80 00       	mov    0x805140,%eax
  8033a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033a8:	74 07                	je     8033b1 <insert_sorted_with_merge_freeList+0x736>
  8033aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ad:	8b 00                	mov    (%eax),%eax
  8033af:	eb 05                	jmp    8033b6 <insert_sorted_with_merge_freeList+0x73b>
  8033b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8033b6:	a3 40 51 80 00       	mov    %eax,0x805140
  8033bb:	a1 40 51 80 00       	mov    0x805140,%eax
  8033c0:	85 c0                	test   %eax,%eax
  8033c2:	0f 85 a7 fb ff ff    	jne    802f6f <insert_sorted_with_merge_freeList+0x2f4>
  8033c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033cc:	0f 85 9d fb ff ff    	jne    802f6f <insert_sorted_with_merge_freeList+0x2f4>
						}
				}
        }

}
}
  8033d2:	eb 00                	jmp    8033d4 <insert_sorted_with_merge_freeList+0x759>
  8033d4:	90                   	nop
  8033d5:	c9                   	leave  
  8033d6:	c3                   	ret    
  8033d7:	90                   	nop

008033d8 <__udivdi3>:
  8033d8:	55                   	push   %ebp
  8033d9:	57                   	push   %edi
  8033da:	56                   	push   %esi
  8033db:	53                   	push   %ebx
  8033dc:	83 ec 1c             	sub    $0x1c,%esp
  8033df:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8033e3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8033e7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8033eb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8033ef:	89 ca                	mov    %ecx,%edx
  8033f1:	89 f8                	mov    %edi,%eax
  8033f3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8033f7:	85 f6                	test   %esi,%esi
  8033f9:	75 2d                	jne    803428 <__udivdi3+0x50>
  8033fb:	39 cf                	cmp    %ecx,%edi
  8033fd:	77 65                	ja     803464 <__udivdi3+0x8c>
  8033ff:	89 fd                	mov    %edi,%ebp
  803401:	85 ff                	test   %edi,%edi
  803403:	75 0b                	jne    803410 <__udivdi3+0x38>
  803405:	b8 01 00 00 00       	mov    $0x1,%eax
  80340a:	31 d2                	xor    %edx,%edx
  80340c:	f7 f7                	div    %edi
  80340e:	89 c5                	mov    %eax,%ebp
  803410:	31 d2                	xor    %edx,%edx
  803412:	89 c8                	mov    %ecx,%eax
  803414:	f7 f5                	div    %ebp
  803416:	89 c1                	mov    %eax,%ecx
  803418:	89 d8                	mov    %ebx,%eax
  80341a:	f7 f5                	div    %ebp
  80341c:	89 cf                	mov    %ecx,%edi
  80341e:	89 fa                	mov    %edi,%edx
  803420:	83 c4 1c             	add    $0x1c,%esp
  803423:	5b                   	pop    %ebx
  803424:	5e                   	pop    %esi
  803425:	5f                   	pop    %edi
  803426:	5d                   	pop    %ebp
  803427:	c3                   	ret    
  803428:	39 ce                	cmp    %ecx,%esi
  80342a:	77 28                	ja     803454 <__udivdi3+0x7c>
  80342c:	0f bd fe             	bsr    %esi,%edi
  80342f:	83 f7 1f             	xor    $0x1f,%edi
  803432:	75 40                	jne    803474 <__udivdi3+0x9c>
  803434:	39 ce                	cmp    %ecx,%esi
  803436:	72 0a                	jb     803442 <__udivdi3+0x6a>
  803438:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80343c:	0f 87 9e 00 00 00    	ja     8034e0 <__udivdi3+0x108>
  803442:	b8 01 00 00 00       	mov    $0x1,%eax
  803447:	89 fa                	mov    %edi,%edx
  803449:	83 c4 1c             	add    $0x1c,%esp
  80344c:	5b                   	pop    %ebx
  80344d:	5e                   	pop    %esi
  80344e:	5f                   	pop    %edi
  80344f:	5d                   	pop    %ebp
  803450:	c3                   	ret    
  803451:	8d 76 00             	lea    0x0(%esi),%esi
  803454:	31 ff                	xor    %edi,%edi
  803456:	31 c0                	xor    %eax,%eax
  803458:	89 fa                	mov    %edi,%edx
  80345a:	83 c4 1c             	add    $0x1c,%esp
  80345d:	5b                   	pop    %ebx
  80345e:	5e                   	pop    %esi
  80345f:	5f                   	pop    %edi
  803460:	5d                   	pop    %ebp
  803461:	c3                   	ret    
  803462:	66 90                	xchg   %ax,%ax
  803464:	89 d8                	mov    %ebx,%eax
  803466:	f7 f7                	div    %edi
  803468:	31 ff                	xor    %edi,%edi
  80346a:	89 fa                	mov    %edi,%edx
  80346c:	83 c4 1c             	add    $0x1c,%esp
  80346f:	5b                   	pop    %ebx
  803470:	5e                   	pop    %esi
  803471:	5f                   	pop    %edi
  803472:	5d                   	pop    %ebp
  803473:	c3                   	ret    
  803474:	bd 20 00 00 00       	mov    $0x20,%ebp
  803479:	89 eb                	mov    %ebp,%ebx
  80347b:	29 fb                	sub    %edi,%ebx
  80347d:	89 f9                	mov    %edi,%ecx
  80347f:	d3 e6                	shl    %cl,%esi
  803481:	89 c5                	mov    %eax,%ebp
  803483:	88 d9                	mov    %bl,%cl
  803485:	d3 ed                	shr    %cl,%ebp
  803487:	89 e9                	mov    %ebp,%ecx
  803489:	09 f1                	or     %esi,%ecx
  80348b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80348f:	89 f9                	mov    %edi,%ecx
  803491:	d3 e0                	shl    %cl,%eax
  803493:	89 c5                	mov    %eax,%ebp
  803495:	89 d6                	mov    %edx,%esi
  803497:	88 d9                	mov    %bl,%cl
  803499:	d3 ee                	shr    %cl,%esi
  80349b:	89 f9                	mov    %edi,%ecx
  80349d:	d3 e2                	shl    %cl,%edx
  80349f:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034a3:	88 d9                	mov    %bl,%cl
  8034a5:	d3 e8                	shr    %cl,%eax
  8034a7:	09 c2                	or     %eax,%edx
  8034a9:	89 d0                	mov    %edx,%eax
  8034ab:	89 f2                	mov    %esi,%edx
  8034ad:	f7 74 24 0c          	divl   0xc(%esp)
  8034b1:	89 d6                	mov    %edx,%esi
  8034b3:	89 c3                	mov    %eax,%ebx
  8034b5:	f7 e5                	mul    %ebp
  8034b7:	39 d6                	cmp    %edx,%esi
  8034b9:	72 19                	jb     8034d4 <__udivdi3+0xfc>
  8034bb:	74 0b                	je     8034c8 <__udivdi3+0xf0>
  8034bd:	89 d8                	mov    %ebx,%eax
  8034bf:	31 ff                	xor    %edi,%edi
  8034c1:	e9 58 ff ff ff       	jmp    80341e <__udivdi3+0x46>
  8034c6:	66 90                	xchg   %ax,%ax
  8034c8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8034cc:	89 f9                	mov    %edi,%ecx
  8034ce:	d3 e2                	shl    %cl,%edx
  8034d0:	39 c2                	cmp    %eax,%edx
  8034d2:	73 e9                	jae    8034bd <__udivdi3+0xe5>
  8034d4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8034d7:	31 ff                	xor    %edi,%edi
  8034d9:	e9 40 ff ff ff       	jmp    80341e <__udivdi3+0x46>
  8034de:	66 90                	xchg   %ax,%ax
  8034e0:	31 c0                	xor    %eax,%eax
  8034e2:	e9 37 ff ff ff       	jmp    80341e <__udivdi3+0x46>
  8034e7:	90                   	nop

008034e8 <__umoddi3>:
  8034e8:	55                   	push   %ebp
  8034e9:	57                   	push   %edi
  8034ea:	56                   	push   %esi
  8034eb:	53                   	push   %ebx
  8034ec:	83 ec 1c             	sub    $0x1c,%esp
  8034ef:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8034f3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8034f7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8034fb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8034ff:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803503:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803507:	89 f3                	mov    %esi,%ebx
  803509:	89 fa                	mov    %edi,%edx
  80350b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80350f:	89 34 24             	mov    %esi,(%esp)
  803512:	85 c0                	test   %eax,%eax
  803514:	75 1a                	jne    803530 <__umoddi3+0x48>
  803516:	39 f7                	cmp    %esi,%edi
  803518:	0f 86 a2 00 00 00    	jbe    8035c0 <__umoddi3+0xd8>
  80351e:	89 c8                	mov    %ecx,%eax
  803520:	89 f2                	mov    %esi,%edx
  803522:	f7 f7                	div    %edi
  803524:	89 d0                	mov    %edx,%eax
  803526:	31 d2                	xor    %edx,%edx
  803528:	83 c4 1c             	add    $0x1c,%esp
  80352b:	5b                   	pop    %ebx
  80352c:	5e                   	pop    %esi
  80352d:	5f                   	pop    %edi
  80352e:	5d                   	pop    %ebp
  80352f:	c3                   	ret    
  803530:	39 f0                	cmp    %esi,%eax
  803532:	0f 87 ac 00 00 00    	ja     8035e4 <__umoddi3+0xfc>
  803538:	0f bd e8             	bsr    %eax,%ebp
  80353b:	83 f5 1f             	xor    $0x1f,%ebp
  80353e:	0f 84 ac 00 00 00    	je     8035f0 <__umoddi3+0x108>
  803544:	bf 20 00 00 00       	mov    $0x20,%edi
  803549:	29 ef                	sub    %ebp,%edi
  80354b:	89 fe                	mov    %edi,%esi
  80354d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803551:	89 e9                	mov    %ebp,%ecx
  803553:	d3 e0                	shl    %cl,%eax
  803555:	89 d7                	mov    %edx,%edi
  803557:	89 f1                	mov    %esi,%ecx
  803559:	d3 ef                	shr    %cl,%edi
  80355b:	09 c7                	or     %eax,%edi
  80355d:	89 e9                	mov    %ebp,%ecx
  80355f:	d3 e2                	shl    %cl,%edx
  803561:	89 14 24             	mov    %edx,(%esp)
  803564:	89 d8                	mov    %ebx,%eax
  803566:	d3 e0                	shl    %cl,%eax
  803568:	89 c2                	mov    %eax,%edx
  80356a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80356e:	d3 e0                	shl    %cl,%eax
  803570:	89 44 24 04          	mov    %eax,0x4(%esp)
  803574:	8b 44 24 08          	mov    0x8(%esp),%eax
  803578:	89 f1                	mov    %esi,%ecx
  80357a:	d3 e8                	shr    %cl,%eax
  80357c:	09 d0                	or     %edx,%eax
  80357e:	d3 eb                	shr    %cl,%ebx
  803580:	89 da                	mov    %ebx,%edx
  803582:	f7 f7                	div    %edi
  803584:	89 d3                	mov    %edx,%ebx
  803586:	f7 24 24             	mull   (%esp)
  803589:	89 c6                	mov    %eax,%esi
  80358b:	89 d1                	mov    %edx,%ecx
  80358d:	39 d3                	cmp    %edx,%ebx
  80358f:	0f 82 87 00 00 00    	jb     80361c <__umoddi3+0x134>
  803595:	0f 84 91 00 00 00    	je     80362c <__umoddi3+0x144>
  80359b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80359f:	29 f2                	sub    %esi,%edx
  8035a1:	19 cb                	sbb    %ecx,%ebx
  8035a3:	89 d8                	mov    %ebx,%eax
  8035a5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8035a9:	d3 e0                	shl    %cl,%eax
  8035ab:	89 e9                	mov    %ebp,%ecx
  8035ad:	d3 ea                	shr    %cl,%edx
  8035af:	09 d0                	or     %edx,%eax
  8035b1:	89 e9                	mov    %ebp,%ecx
  8035b3:	d3 eb                	shr    %cl,%ebx
  8035b5:	89 da                	mov    %ebx,%edx
  8035b7:	83 c4 1c             	add    $0x1c,%esp
  8035ba:	5b                   	pop    %ebx
  8035bb:	5e                   	pop    %esi
  8035bc:	5f                   	pop    %edi
  8035bd:	5d                   	pop    %ebp
  8035be:	c3                   	ret    
  8035bf:	90                   	nop
  8035c0:	89 fd                	mov    %edi,%ebp
  8035c2:	85 ff                	test   %edi,%edi
  8035c4:	75 0b                	jne    8035d1 <__umoddi3+0xe9>
  8035c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8035cb:	31 d2                	xor    %edx,%edx
  8035cd:	f7 f7                	div    %edi
  8035cf:	89 c5                	mov    %eax,%ebp
  8035d1:	89 f0                	mov    %esi,%eax
  8035d3:	31 d2                	xor    %edx,%edx
  8035d5:	f7 f5                	div    %ebp
  8035d7:	89 c8                	mov    %ecx,%eax
  8035d9:	f7 f5                	div    %ebp
  8035db:	89 d0                	mov    %edx,%eax
  8035dd:	e9 44 ff ff ff       	jmp    803526 <__umoddi3+0x3e>
  8035e2:	66 90                	xchg   %ax,%ax
  8035e4:	89 c8                	mov    %ecx,%eax
  8035e6:	89 f2                	mov    %esi,%edx
  8035e8:	83 c4 1c             	add    $0x1c,%esp
  8035eb:	5b                   	pop    %ebx
  8035ec:	5e                   	pop    %esi
  8035ed:	5f                   	pop    %edi
  8035ee:	5d                   	pop    %ebp
  8035ef:	c3                   	ret    
  8035f0:	3b 04 24             	cmp    (%esp),%eax
  8035f3:	72 06                	jb     8035fb <__umoddi3+0x113>
  8035f5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8035f9:	77 0f                	ja     80360a <__umoddi3+0x122>
  8035fb:	89 f2                	mov    %esi,%edx
  8035fd:	29 f9                	sub    %edi,%ecx
  8035ff:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803603:	89 14 24             	mov    %edx,(%esp)
  803606:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80360a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80360e:	8b 14 24             	mov    (%esp),%edx
  803611:	83 c4 1c             	add    $0x1c,%esp
  803614:	5b                   	pop    %ebx
  803615:	5e                   	pop    %esi
  803616:	5f                   	pop    %edi
  803617:	5d                   	pop    %ebp
  803618:	c3                   	ret    
  803619:	8d 76 00             	lea    0x0(%esi),%esi
  80361c:	2b 04 24             	sub    (%esp),%eax
  80361f:	19 fa                	sbb    %edi,%edx
  803621:	89 d1                	mov    %edx,%ecx
  803623:	89 c6                	mov    %eax,%esi
  803625:	e9 71 ff ff ff       	jmp    80359b <__umoddi3+0xb3>
  80362a:	66 90                	xchg   %ax,%ax
  80362c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803630:	72 ea                	jb     80361c <__umoddi3+0x134>
  803632:	89 d9                	mov    %ebx,%ecx
  803634:	e9 62 ff ff ff       	jmp    80359b <__umoddi3+0xb3>
