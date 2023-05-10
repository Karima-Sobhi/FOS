
obj/user/tst_free_2:     file format elf32-i386


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
  800031:	e8 43 09 00 00       	call   800979 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* MAKE SURE PAGE_WS_MAX_SIZE = 1000 */
/* *********************************************************** */
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	81 ec d4 00 00 00    	sub    $0xd4,%esp

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  800042:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800046:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004d:	eb 29                	jmp    800078 <_main+0x40>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004f:	a1 20 50 80 00       	mov    0x805020,%eax
  800054:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80005a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80005d:	89 d0                	mov    %edx,%eax
  80005f:	01 c0                	add    %eax,%eax
  800061:	01 d0                	add    %edx,%eax
  800063:	c1 e0 03             	shl    $0x3,%eax
  800066:	01 c8                	add    %ecx,%eax
  800068:	8a 40 04             	mov    0x4(%eax),%al
  80006b:	84 c0                	test   %al,%al
  80006d:	74 06                	je     800075 <_main+0x3d>
			{
				fullWS = 0;
  80006f:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  800073:	eb 12                	jmp    800087 <_main+0x4f>
{

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800075:	ff 45 f0             	incl   -0x10(%ebp)
  800078:	a1 20 50 80 00       	mov    0x805020,%eax
  80007d:	8b 50 74             	mov    0x74(%eax),%edx
  800080:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800083:	39 c2                	cmp    %eax,%edx
  800085:	77 c8                	ja     80004f <_main+0x17>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800087:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  80008b:	74 14                	je     8000a1 <_main+0x69>
  80008d:	83 ec 04             	sub    $0x4,%esp
  800090:	68 40 3a 80 00       	push   $0x803a40
  800095:	6a 14                	push   $0x14
  800097:	68 5c 3a 80 00       	push   $0x803a5c
  80009c:	e8 14 0a 00 00       	call   800ab5 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000a1:	83 ec 0c             	sub    $0xc,%esp
  8000a4:	6a 00                	push   $0x0
  8000a6:	e8 ea 1b 00 00       	call   801c95 <malloc>
  8000ab:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/
	//Bypass the PAGE FAULT on <MOVB immediate, reg> instruction by setting its length
	//and continue executing the remaining code
	sys_bypassPageFault(3);
  8000ae:	83 ec 0c             	sub    $0xc,%esp
  8000b1:	6a 03                	push   $0x3
  8000b3:	e8 a3 23 00 00       	call   80245b <sys_bypassPageFault>
  8000b8:	83 c4 10             	add    $0x10,%esp





	int Mega = 1024*1024;
  8000bb:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000c2:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)

	int start_freeFrames = sys_calculate_free_frames() ;
  8000c9:	e8 f5 1f 00 00       	call   8020c3 <sys_calculate_free_frames>
  8000ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	//ALLOCATE ALL
	void* ptr_allocations[20] = {0};
  8000d1:	8d 55 80             	lea    -0x80(%ebp),%edx
  8000d4:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8000de:	89 d7                	mov    %edx,%edi
  8000e0:	f3 ab                	rep stos %eax,%es:(%edi)
	int lastIndices[20] = {0};
  8000e2:	8d 95 30 ff ff ff    	lea    -0xd0(%ebp),%edx
  8000e8:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f2:	89 d7                	mov    %edx,%edi
  8000f4:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		int freeFrames = sys_calculate_free_frames() ;
  8000f6:	e8 c8 1f 00 00       	call   8020c3 <sys_calculate_free_frames>
  8000fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000fe:	e8 60 20 00 00       	call   802163 <sys_pf_calculate_allocated_pages>
  800103:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  800106:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800109:	01 c0                	add    %eax,%eax
  80010b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80010e:	83 ec 0c             	sub    $0xc,%esp
  800111:	50                   	push   %eax
  800112:	e8 7e 1b 00 00       	call   801c95 <malloc>
  800117:	83 c4 10             	add    $0x10,%esp
  80011a:	89 45 80             	mov    %eax,-0x80(%ebp)
		if ((uint32) ptr_allocations[0] <  (USER_HEAP_START)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80011d:	8b 45 80             	mov    -0x80(%ebp),%eax
  800120:	85 c0                	test   %eax,%eax
  800122:	78 14                	js     800138 <_main+0x100>
  800124:	83 ec 04             	sub    $0x4,%esp
  800127:	68 70 3a 80 00       	push   $0x803a70
  80012c:	6a 2d                	push   $0x2d
  80012e:	68 5c 3a 80 00       	push   $0x803a5c
  800133:	e8 7d 09 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800138:	e8 26 20 00 00       	call   802163 <sys_pf_calculate_allocated_pages>
  80013d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800140:	74 14                	je     800156 <_main+0x11e>
  800142:	83 ec 04             	sub    $0x4,%esp
  800145:	68 d8 3a 80 00       	push   $0x803ad8
  80014a:	6a 2e                	push   $0x2e
  80014c:	68 5c 3a 80 00       	push   $0x803a5c
  800151:	e8 5f 09 00 00       	call   800ab5 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		lastIndices[0] = (2*Mega-kilo)/sizeof(char) - 1;
  800156:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800159:	01 c0                	add    %eax,%eax
  80015b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80015e:	48                   	dec    %eax
  80015f:	89 85 30 ff ff ff    	mov    %eax,-0xd0(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  800165:	e8 59 1f 00 00       	call   8020c3 <sys_calculate_free_frames>
  80016a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80016d:	e8 f1 1f 00 00       	call   802163 <sys_pf_calculate_allocated_pages>
  800172:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  800175:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800178:	01 c0                	add    %eax,%eax
  80017a:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80017d:	83 ec 0c             	sub    $0xc,%esp
  800180:	50                   	push   %eax
  800181:	e8 0f 1b 00 00       	call   801c95 <malloc>
  800186:	83 c4 10             	add    $0x10,%esp
  800189:	89 45 84             	mov    %eax,-0x7c(%ebp)
		if ((uint32) ptr_allocations[1] < (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80018c:	8b 45 84             	mov    -0x7c(%ebp),%eax
  80018f:	89 c2                	mov    %eax,%edx
  800191:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800194:	01 c0                	add    %eax,%eax
  800196:	05 00 00 00 80       	add    $0x80000000,%eax
  80019b:	39 c2                	cmp    %eax,%edx
  80019d:	73 14                	jae    8001b3 <_main+0x17b>
  80019f:	83 ec 04             	sub    $0x4,%esp
  8001a2:	68 70 3a 80 00       	push   $0x803a70
  8001a7:	6a 35                	push   $0x35
  8001a9:	68 5c 3a 80 00       	push   $0x803a5c
  8001ae:	e8 02 09 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8001b3:	e8 ab 1f 00 00       	call   802163 <sys_pf_calculate_allocated_pages>
  8001b8:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8001bb:	74 14                	je     8001d1 <_main+0x199>
  8001bd:	83 ec 04             	sub    $0x4,%esp
  8001c0:	68 d8 3a 80 00       	push   $0x803ad8
  8001c5:	6a 36                	push   $0x36
  8001c7:	68 5c 3a 80 00       	push   $0x803a5c
  8001cc:	e8 e4 08 00 00       	call   800ab5 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		lastIndices[1] = (2*Mega-kilo)/sizeof(char) - 1;
  8001d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001d4:	01 c0                	add    %eax,%eax
  8001d6:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8001d9:	48                   	dec    %eax
  8001da:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  8001e0:	e8 de 1e 00 00       	call   8020c3 <sys_calculate_free_frames>
  8001e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001e8:	e8 76 1f 00 00       	call   802163 <sys_pf_calculate_allocated_pages>
  8001ed:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[2] = malloc(2*kilo);
  8001f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001f3:	01 c0                	add    %eax,%eax
  8001f5:	83 ec 0c             	sub    $0xc,%esp
  8001f8:	50                   	push   %eax
  8001f9:	e8 97 1a 00 00       	call   801c95 <malloc>
  8001fe:	83 c4 10             	add    $0x10,%esp
  800201:	89 45 88             	mov    %eax,-0x78(%ebp)
		if ((uint32) ptr_allocations[2] < (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800204:	8b 45 88             	mov    -0x78(%ebp),%eax
  800207:	89 c2                	mov    %eax,%edx
  800209:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80020c:	c1 e0 02             	shl    $0x2,%eax
  80020f:	05 00 00 00 80       	add    $0x80000000,%eax
  800214:	39 c2                	cmp    %eax,%edx
  800216:	73 14                	jae    80022c <_main+0x1f4>
  800218:	83 ec 04             	sub    $0x4,%esp
  80021b:	68 70 3a 80 00       	push   $0x803a70
  800220:	6a 3d                	push   $0x3d
  800222:	68 5c 3a 80 00       	push   $0x803a5c
  800227:	e8 89 08 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  80022c:	e8 32 1f 00 00       	call   802163 <sys_pf_calculate_allocated_pages>
  800231:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800234:	74 14                	je     80024a <_main+0x212>
  800236:	83 ec 04             	sub    $0x4,%esp
  800239:	68 d8 3a 80 00       	push   $0x803ad8
  80023e:	6a 3e                	push   $0x3e
  800240:	68 5c 3a 80 00       	push   $0x803a5c
  800245:	e8 6b 08 00 00       	call   800ab5 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1+1 ) panic("Wrong allocation: ");
		lastIndices[2] = (2*kilo)/sizeof(char) - 1;
  80024a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80024d:	01 c0                	add    %eax,%eax
  80024f:	48                   	dec    %eax
  800250:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  800256:	e8 68 1e 00 00       	call   8020c3 <sys_calculate_free_frames>
  80025b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80025e:	e8 00 1f 00 00       	call   802163 <sys_pf_calculate_allocated_pages>
  800263:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[3] = malloc(2*kilo);
  800266:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800269:	01 c0                	add    %eax,%eax
  80026b:	83 ec 0c             	sub    $0xc,%esp
  80026e:	50                   	push   %eax
  80026f:	e8 21 1a 00 00       	call   801c95 <malloc>
  800274:	83 c4 10             	add    $0x10,%esp
  800277:	89 45 8c             	mov    %eax,-0x74(%ebp)
		if ((uint32) ptr_allocations[3] < (USER_HEAP_START + 4*Mega + 4*kilo)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80027a:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80027d:	89 c2                	mov    %eax,%edx
  80027f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800282:	c1 e0 02             	shl    $0x2,%eax
  800285:	89 c1                	mov    %eax,%ecx
  800287:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80028a:	c1 e0 02             	shl    $0x2,%eax
  80028d:	01 c8                	add    %ecx,%eax
  80028f:	05 00 00 00 80       	add    $0x80000000,%eax
  800294:	39 c2                	cmp    %eax,%edx
  800296:	73 14                	jae    8002ac <_main+0x274>
  800298:	83 ec 04             	sub    $0x4,%esp
  80029b:	68 70 3a 80 00       	push   $0x803a70
  8002a0:	6a 45                	push   $0x45
  8002a2:	68 5c 3a 80 00       	push   $0x803a5c
  8002a7:	e8 09 08 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8002ac:	e8 b2 1e 00 00       	call   802163 <sys_pf_calculate_allocated_pages>
  8002b1:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8002b4:	74 14                	je     8002ca <_main+0x292>
  8002b6:	83 ec 04             	sub    $0x4,%esp
  8002b9:	68 d8 3a 80 00       	push   $0x803ad8
  8002be:	6a 46                	push   $0x46
  8002c0:	68 5c 3a 80 00       	push   $0x803a5c
  8002c5:	e8 eb 07 00 00       	call   800ab5 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
		lastIndices[3] = (2*kilo)/sizeof(char) - 1;
  8002ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002cd:	01 c0                	add    %eax,%eax
  8002cf:	48                   	dec    %eax
  8002d0:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  8002d6:	e8 e8 1d 00 00       	call   8020c3 <sys_calculate_free_frames>
  8002db:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002de:	e8 80 1e 00 00       	call   802163 <sys_pf_calculate_allocated_pages>
  8002e3:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  8002e6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8002e9:	89 d0                	mov    %edx,%eax
  8002eb:	01 c0                	add    %eax,%eax
  8002ed:	01 d0                	add    %edx,%eax
  8002ef:	01 c0                	add    %eax,%eax
  8002f1:	01 d0                	add    %edx,%eax
  8002f3:	83 ec 0c             	sub    $0xc,%esp
  8002f6:	50                   	push   %eax
  8002f7:	e8 99 19 00 00       	call   801c95 <malloc>
  8002fc:	83 c4 10             	add    $0x10,%esp
  8002ff:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[4] < (USER_HEAP_START + 4*Mega + 8*kilo)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800302:	8b 45 90             	mov    -0x70(%ebp),%eax
  800305:	89 c2                	mov    %eax,%edx
  800307:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80030a:	c1 e0 02             	shl    $0x2,%eax
  80030d:	89 c1                	mov    %eax,%ecx
  80030f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800312:	c1 e0 03             	shl    $0x3,%eax
  800315:	01 c8                	add    %ecx,%eax
  800317:	05 00 00 00 80       	add    $0x80000000,%eax
  80031c:	39 c2                	cmp    %eax,%edx
  80031e:	73 14                	jae    800334 <_main+0x2fc>
  800320:	83 ec 04             	sub    $0x4,%esp
  800323:	68 70 3a 80 00       	push   $0x803a70
  800328:	6a 4d                	push   $0x4d
  80032a:	68 5c 3a 80 00       	push   $0x803a5c
  80032f:	e8 81 07 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800334:	e8 2a 1e 00 00       	call   802163 <sys_pf_calculate_allocated_pages>
  800339:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80033c:	74 14                	je     800352 <_main+0x31a>
  80033e:	83 ec 04             	sub    $0x4,%esp
  800341:	68 d8 3a 80 00       	push   $0x803ad8
  800346:	6a 4e                	push   $0x4e
  800348:	68 5c 3a 80 00       	push   $0x803a5c
  80034d:	e8 63 07 00 00       	call   800ab5 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		lastIndices[4] = (7*kilo)/sizeof(char) - 1;
  800352:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800355:	89 d0                	mov    %edx,%eax
  800357:	01 c0                	add    %eax,%eax
  800359:	01 d0                	add    %edx,%eax
  80035b:	01 c0                	add    %eax,%eax
  80035d:	01 d0                	add    %edx,%eax
  80035f:	48                   	dec    %eax
  800360:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  800366:	e8 58 1d 00 00       	call   8020c3 <sys_calculate_free_frames>
  80036b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80036e:	e8 f0 1d 00 00       	call   802163 <sys_pf_calculate_allocated_pages>
  800373:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  800376:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800379:	89 c2                	mov    %eax,%edx
  80037b:	01 d2                	add    %edx,%edx
  80037d:	01 d0                	add    %edx,%eax
  80037f:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800382:	83 ec 0c             	sub    $0xc,%esp
  800385:	50                   	push   %eax
  800386:	e8 0a 19 00 00       	call   801c95 <malloc>
  80038b:	83 c4 10             	add    $0x10,%esp
  80038e:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[5] < (USER_HEAP_START + 4*Mega + 16*kilo)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800391:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800394:	89 c2                	mov    %eax,%edx
  800396:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800399:	c1 e0 02             	shl    $0x2,%eax
  80039c:	89 c1                	mov    %eax,%ecx
  80039e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003a1:	c1 e0 04             	shl    $0x4,%eax
  8003a4:	01 c8                	add    %ecx,%eax
  8003a6:	05 00 00 00 80       	add    $0x80000000,%eax
  8003ab:	39 c2                	cmp    %eax,%edx
  8003ad:	73 14                	jae    8003c3 <_main+0x38b>
  8003af:	83 ec 04             	sub    $0x4,%esp
  8003b2:	68 70 3a 80 00       	push   $0x803a70
  8003b7:	6a 55                	push   $0x55
  8003b9:	68 5c 3a 80 00       	push   $0x803a5c
  8003be:	e8 f2 06 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8003c3:	e8 9b 1d 00 00       	call   802163 <sys_pf_calculate_allocated_pages>
  8003c8:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8003cb:	74 14                	je     8003e1 <_main+0x3a9>
  8003cd:	83 ec 04             	sub    $0x4,%esp
  8003d0:	68 d8 3a 80 00       	push   $0x803ad8
  8003d5:	6a 56                	push   $0x56
  8003d7:	68 5c 3a 80 00       	push   $0x803a5c
  8003dc:	e8 d4 06 00 00       	call   800ab5 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096 ) panic("Wrong allocation: ");
		lastIndices[5] = (3*Mega - kilo)/sizeof(char) - 1;
  8003e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003e4:	89 c2                	mov    %eax,%edx
  8003e6:	01 d2                	add    %edx,%edx
  8003e8:	01 d0                	add    %edx,%eax
  8003ea:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8003ed:	48                   	dec    %eax
  8003ee:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  8003f4:	e8 ca 1c 00 00       	call   8020c3 <sys_calculate_free_frames>
  8003f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8003fc:	e8 62 1d 00 00       	call   802163 <sys_pf_calculate_allocated_pages>
  800401:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[6] = malloc(2*Mega-kilo);
  800404:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800407:	01 c0                	add    %eax,%eax
  800409:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80040c:	83 ec 0c             	sub    $0xc,%esp
  80040f:	50                   	push   %eax
  800410:	e8 80 18 00 00       	call   801c95 <malloc>
  800415:	83 c4 10             	add    $0x10,%esp
  800418:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[6] < (USER_HEAP_START + 7*Mega + 16*kilo)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80041b:	8b 45 98             	mov    -0x68(%ebp),%eax
  80041e:	89 c1                	mov    %eax,%ecx
  800420:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800423:	89 d0                	mov    %edx,%eax
  800425:	01 c0                	add    %eax,%eax
  800427:	01 d0                	add    %edx,%eax
  800429:	01 c0                	add    %eax,%eax
  80042b:	01 d0                	add    %edx,%eax
  80042d:	89 c2                	mov    %eax,%edx
  80042f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800432:	c1 e0 04             	shl    $0x4,%eax
  800435:	01 d0                	add    %edx,%eax
  800437:	05 00 00 00 80       	add    $0x80000000,%eax
  80043c:	39 c1                	cmp    %eax,%ecx
  80043e:	73 14                	jae    800454 <_main+0x41c>
  800440:	83 ec 04             	sub    $0x4,%esp
  800443:	68 70 3a 80 00       	push   $0x803a70
  800448:	6a 5d                	push   $0x5d
  80044a:	68 5c 3a 80 00       	push   $0x803a5c
  80044f:	e8 61 06 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800454:	e8 0a 1d 00 00       	call   802163 <sys_pf_calculate_allocated_pages>
  800459:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80045c:	74 14                	je     800472 <_main+0x43a>
  80045e:	83 ec 04             	sub    $0x4,%esp
  800461:	68 d8 3a 80 00       	push   $0x803ad8
  800466:	6a 5e                	push   $0x5e
  800468:	68 5c 3a 80 00       	push   $0x803a5c
  80046d:	e8 43 06 00 00       	call   800ab5 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		lastIndices[6] = (2*Mega - kilo)/sizeof(char) - 1;
  800472:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800475:	01 c0                	add    %eax,%eax
  800477:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80047a:	48                   	dec    %eax
  80047b:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
	char x ;
	int y;
	char *byteArr ;
	//FREE ALL
	{
		int freeFrames = sys_calculate_free_frames() ;
  800481:	e8 3d 1c 00 00       	call   8020c3 <sys_calculate_free_frames>
  800486:	89 45 d8             	mov    %eax,-0x28(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800489:	e8 d5 1c 00 00       	call   802163 <sys_pf_calculate_allocated_pages>
  80048e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[0]);
  800491:	8b 45 80             	mov    -0x80(%ebp),%eax
  800494:	83 ec 0c             	sub    $0xc,%esp
  800497:	50                   	push   %eax
  800498:	e8 73 18 00 00       	call   801d10 <free>
  80049d:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  8004a0:	e8 be 1c 00 00       	call   802163 <sys_pf_calculate_allocated_pages>
  8004a5:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8004a8:	74 14                	je     8004be <_main+0x486>
  8004aa:	83 ec 04             	sub    $0x4,%esp
  8004ad:	68 08 3b 80 00       	push   $0x803b08
  8004b2:	6a 6b                	push   $0x6b
  8004b4:	68 5c 3a 80 00       	push   $0x803a5c
  8004b9:	e8 f7 05 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 512 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[0];
  8004be:	8b 45 80             	mov    -0x80(%ebp),%eax
  8004c1:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  8004c4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004c7:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  8004ca:	e8 73 1f 00 00       	call   802442 <sys_rcr2>
  8004cf:	89 c2                	mov    %eax,%edx
  8004d1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004d4:	39 c2                	cmp    %eax,%edx
  8004d6:	74 14                	je     8004ec <_main+0x4b4>
  8004d8:	83 ec 04             	sub    $0x4,%esp
  8004db:	68 44 3b 80 00       	push   $0x803b44
  8004e0:	6a 6f                	push   $0x6f
  8004e2:	68 5c 3a 80 00       	push   $0x803a5c
  8004e7:	e8 c9 05 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[0]] = 10;
  8004ec:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  8004f2:	89 c2                	mov    %eax,%edx
  8004f4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004f7:	01 d0                	add    %edx,%eax
  8004f9:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[0]])) panic("Free: successful access to freed space!! it should not be succeeded");
  8004fc:	e8 41 1f 00 00       	call   802442 <sys_rcr2>
  800501:	8b 95 30 ff ff ff    	mov    -0xd0(%ebp),%edx
  800507:	89 d1                	mov    %edx,%ecx
  800509:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80050c:	01 ca                	add    %ecx,%edx
  80050e:	39 d0                	cmp    %edx,%eax
  800510:	74 14                	je     800526 <_main+0x4ee>
  800512:	83 ec 04             	sub    $0x4,%esp
  800515:	68 44 3b 80 00       	push   $0x803b44
  80051a:	6a 71                	push   $0x71
  80051c:	68 5c 3a 80 00       	push   $0x803a5c
  800521:	e8 8f 05 00 00       	call   800ab5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800526:	e8 98 1b 00 00       	call   8020c3 <sys_calculate_free_frames>
  80052b:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80052e:	e8 30 1c 00 00       	call   802163 <sys_pf_calculate_allocated_pages>
  800533:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[1]);
  800536:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800539:	83 ec 0c             	sub    $0xc,%esp
  80053c:	50                   	push   %eax
  80053d:	e8 ce 17 00 00       	call   801d10 <free>
  800542:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  800545:	e8 19 1c 00 00       	call   802163 <sys_pf_calculate_allocated_pages>
  80054a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80054d:	74 14                	je     800563 <_main+0x52b>
  80054f:	83 ec 04             	sub    $0x4,%esp
  800552:	68 08 3b 80 00       	push   $0x803b08
  800557:	6a 76                	push   $0x76
  800559:	68 5c 3a 80 00       	push   $0x803a5c
  80055e:	e8 52 05 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 512 + 1 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[1];
  800563:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800566:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  800569:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80056c:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  80056f:	e8 ce 1e 00 00       	call   802442 <sys_rcr2>
  800574:	89 c2                	mov    %eax,%edx
  800576:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800579:	39 c2                	cmp    %eax,%edx
  80057b:	74 14                	je     800591 <_main+0x559>
  80057d:	83 ec 04             	sub    $0x4,%esp
  800580:	68 44 3b 80 00       	push   $0x803b44
  800585:	6a 7a                	push   $0x7a
  800587:	68 5c 3a 80 00       	push   $0x803a5c
  80058c:	e8 24 05 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[1]] = 10;
  800591:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  800597:	89 c2                	mov    %eax,%edx
  800599:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80059c:	01 d0                	add    %edx,%eax
  80059e:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[1]])) panic("Free: successful access to freed space!! it should not be succeeded");
  8005a1:	e8 9c 1e 00 00       	call   802442 <sys_rcr2>
  8005a6:	8b 95 34 ff ff ff    	mov    -0xcc(%ebp),%edx
  8005ac:	89 d1                	mov    %edx,%ecx
  8005ae:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8005b1:	01 ca                	add    %ecx,%edx
  8005b3:	39 d0                	cmp    %edx,%eax
  8005b5:	74 14                	je     8005cb <_main+0x593>
  8005b7:	83 ec 04             	sub    $0x4,%esp
  8005ba:	68 44 3b 80 00       	push   $0x803b44
  8005bf:	6a 7c                	push   $0x7c
  8005c1:	68 5c 3a 80 00       	push   $0x803a5c
  8005c6:	e8 ea 04 00 00       	call   800ab5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8005cb:	e8 f3 1a 00 00       	call   8020c3 <sys_calculate_free_frames>
  8005d0:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8005d3:	e8 8b 1b 00 00       	call   802163 <sys_pf_calculate_allocated_pages>
  8005d8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[2]);
  8005db:	8b 45 88             	mov    -0x78(%ebp),%eax
  8005de:	83 ec 0c             	sub    $0xc,%esp
  8005e1:	50                   	push   %eax
  8005e2:	e8 29 17 00 00       	call   801d10 <free>
  8005e7:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  8005ea:	e8 74 1b 00 00       	call   802163 <sys_pf_calculate_allocated_pages>
  8005ef:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8005f2:	74 17                	je     80060b <_main+0x5d3>
  8005f4:	83 ec 04             	sub    $0x4,%esp
  8005f7:	68 08 3b 80 00       	push   $0x803b08
  8005fc:	68 81 00 00 00       	push   $0x81
  800601:	68 5c 3a 80 00       	push   $0x803a5c
  800606:	e8 aa 04 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 1 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[2];
  80060b:	8b 45 88             	mov    -0x78(%ebp),%eax
  80060e:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  800611:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800614:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  800617:	e8 26 1e 00 00       	call   802442 <sys_rcr2>
  80061c:	89 c2                	mov    %eax,%edx
  80061e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800621:	39 c2                	cmp    %eax,%edx
  800623:	74 17                	je     80063c <_main+0x604>
  800625:	83 ec 04             	sub    $0x4,%esp
  800628:	68 44 3b 80 00       	push   $0x803b44
  80062d:	68 85 00 00 00       	push   $0x85
  800632:	68 5c 3a 80 00       	push   $0x803a5c
  800637:	e8 79 04 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[2]] = 10;
  80063c:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  800642:	89 c2                	mov    %eax,%edx
  800644:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800647:	01 d0                	add    %edx,%eax
  800649:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[2]])) panic("Free: successful access to freed space!! it should not be succeeded");
  80064c:	e8 f1 1d 00 00       	call   802442 <sys_rcr2>
  800651:	8b 95 38 ff ff ff    	mov    -0xc8(%ebp),%edx
  800657:	89 d1                	mov    %edx,%ecx
  800659:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80065c:	01 ca                	add    %ecx,%edx
  80065e:	39 d0                	cmp    %edx,%eax
  800660:	74 17                	je     800679 <_main+0x641>
  800662:	83 ec 04             	sub    $0x4,%esp
  800665:	68 44 3b 80 00       	push   $0x803b44
  80066a:	68 87 00 00 00       	push   $0x87
  80066f:	68 5c 3a 80 00       	push   $0x803a5c
  800674:	e8 3c 04 00 00       	call   800ab5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800679:	e8 45 1a 00 00       	call   8020c3 <sys_calculate_free_frames>
  80067e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800681:	e8 dd 1a 00 00       	call   802163 <sys_pf_calculate_allocated_pages>
  800686:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[3]);
  800689:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80068c:	83 ec 0c             	sub    $0xc,%esp
  80068f:	50                   	push   %eax
  800690:	e8 7b 16 00 00       	call   801d10 <free>
  800695:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  800698:	e8 c6 1a 00 00       	call   802163 <sys_pf_calculate_allocated_pages>
  80069d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8006a0:	74 17                	je     8006b9 <_main+0x681>
  8006a2:	83 ec 04             	sub    $0x4,%esp
  8006a5:	68 08 3b 80 00       	push   $0x803b08
  8006aa:	68 8c 00 00 00       	push   $0x8c
  8006af:	68 5c 3a 80 00       	push   $0x803a5c
  8006b4:	e8 fc 03 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 1 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[3];
  8006b9:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8006bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  8006bf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006c2:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  8006c5:	e8 78 1d 00 00       	call   802442 <sys_rcr2>
  8006ca:	89 c2                	mov    %eax,%edx
  8006cc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006cf:	39 c2                	cmp    %eax,%edx
  8006d1:	74 17                	je     8006ea <_main+0x6b2>
  8006d3:	83 ec 04             	sub    $0x4,%esp
  8006d6:	68 44 3b 80 00       	push   $0x803b44
  8006db:	68 90 00 00 00       	push   $0x90
  8006e0:	68 5c 3a 80 00       	push   $0x803a5c
  8006e5:	e8 cb 03 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[3]] = 10;
  8006ea:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  8006f0:	89 c2                	mov    %eax,%edx
  8006f2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006f5:	01 d0                	add    %edx,%eax
  8006f7:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[3]])) panic("Free: successful access to freed space!! it should not be succeeded");
  8006fa:	e8 43 1d 00 00       	call   802442 <sys_rcr2>
  8006ff:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
  800705:	89 d1                	mov    %edx,%ecx
  800707:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80070a:	01 ca                	add    %ecx,%edx
  80070c:	39 d0                	cmp    %edx,%eax
  80070e:	74 17                	je     800727 <_main+0x6ef>
  800710:	83 ec 04             	sub    $0x4,%esp
  800713:	68 44 3b 80 00       	push   $0x803b44
  800718:	68 92 00 00 00       	push   $0x92
  80071d:	68 5c 3a 80 00       	push   $0x803a5c
  800722:	e8 8e 03 00 00       	call   800ab5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800727:	e8 97 19 00 00       	call   8020c3 <sys_calculate_free_frames>
  80072c:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80072f:	e8 2f 1a 00 00       	call   802163 <sys_pf_calculate_allocated_pages>
  800734:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[4]);
  800737:	8b 45 90             	mov    -0x70(%ebp),%eax
  80073a:	83 ec 0c             	sub    $0xc,%esp
  80073d:	50                   	push   %eax
  80073e:	e8 cd 15 00 00       	call   801d10 <free>
  800743:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  800746:	e8 18 1a 00 00       	call   802163 <sys_pf_calculate_allocated_pages>
  80074b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80074e:	74 17                	je     800767 <_main+0x72f>
  800750:	83 ec 04             	sub    $0x4,%esp
  800753:	68 08 3b 80 00       	push   $0x803b08
  800758:	68 97 00 00 00       	push   $0x97
  80075d:	68 5c 3a 80 00       	push   $0x803a5c
  800762:	e8 4e 03 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 2 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[4];
  800767:	8b 45 90             	mov    -0x70(%ebp),%eax
  80076a:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  80076d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800770:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  800773:	e8 ca 1c 00 00       	call   802442 <sys_rcr2>
  800778:	89 c2                	mov    %eax,%edx
  80077a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80077d:	39 c2                	cmp    %eax,%edx
  80077f:	74 17                	je     800798 <_main+0x760>
  800781:	83 ec 04             	sub    $0x4,%esp
  800784:	68 44 3b 80 00       	push   $0x803b44
  800789:	68 9b 00 00 00       	push   $0x9b
  80078e:	68 5c 3a 80 00       	push   $0x803a5c
  800793:	e8 1d 03 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[4]] = 10;
  800798:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  80079e:	89 c2                	mov    %eax,%edx
  8007a0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007a3:	01 d0                	add    %edx,%eax
  8007a5:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[4]])) panic("Free: successful access to freed space!! it should not be succeeded");
  8007a8:	e8 95 1c 00 00       	call   802442 <sys_rcr2>
  8007ad:	8b 95 40 ff ff ff    	mov    -0xc0(%ebp),%edx
  8007b3:	89 d1                	mov    %edx,%ecx
  8007b5:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8007b8:	01 ca                	add    %ecx,%edx
  8007ba:	39 d0                	cmp    %edx,%eax
  8007bc:	74 17                	je     8007d5 <_main+0x79d>
  8007be:	83 ec 04             	sub    $0x4,%esp
  8007c1:	68 44 3b 80 00       	push   $0x803b44
  8007c6:	68 9d 00 00 00       	push   $0x9d
  8007cb:	68 5c 3a 80 00       	push   $0x803a5c
  8007d0:	e8 e0 02 00 00       	call   800ab5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8007d5:	e8 e9 18 00 00       	call   8020c3 <sys_calculate_free_frames>
  8007da:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8007dd:	e8 81 19 00 00       	call   802163 <sys_pf_calculate_allocated_pages>
  8007e2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[5]);
  8007e5:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8007e8:	83 ec 0c             	sub    $0xc,%esp
  8007eb:	50                   	push   %eax
  8007ec:	e8 1f 15 00 00       	call   801d10 <free>
  8007f1:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0 ) panic("Wrong free: Extra or less pages are removed from PageFile");
  8007f4:	e8 6a 19 00 00       	call   802163 <sys_pf_calculate_allocated_pages>
  8007f9:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8007fc:	74 17                	je     800815 <_main+0x7dd>
  8007fe:	83 ec 04             	sub    $0x4,%esp
  800801:	68 08 3b 80 00       	push   $0x803b08
  800806:	68 a2 00 00 00       	push   $0xa2
  80080b:	68 5c 3a 80 00       	push   $0x803a5c
  800810:	e8 a0 02 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 3*Mega/4096 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[5];
  800815:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800818:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  80081b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80081e:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  800821:	e8 1c 1c 00 00       	call   802442 <sys_rcr2>
  800826:	89 c2                	mov    %eax,%edx
  800828:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80082b:	39 c2                	cmp    %eax,%edx
  80082d:	74 17                	je     800846 <_main+0x80e>
  80082f:	83 ec 04             	sub    $0x4,%esp
  800832:	68 44 3b 80 00       	push   $0x803b44
  800837:	68 a6 00 00 00       	push   $0xa6
  80083c:	68 5c 3a 80 00       	push   $0x803a5c
  800841:	e8 6f 02 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[5]] = 10;
  800846:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  80084c:	89 c2                	mov    %eax,%edx
  80084e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800851:	01 d0                	add    %edx,%eax
  800853:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[5]])) panic("Free: successful access to freed space!! it should not be succeeded");
  800856:	e8 e7 1b 00 00       	call   802442 <sys_rcr2>
  80085b:	8b 95 44 ff ff ff    	mov    -0xbc(%ebp),%edx
  800861:	89 d1                	mov    %edx,%ecx
  800863:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800866:	01 ca                	add    %ecx,%edx
  800868:	39 d0                	cmp    %edx,%eax
  80086a:	74 17                	je     800883 <_main+0x84b>
  80086c:	83 ec 04             	sub    $0x4,%esp
  80086f:	68 44 3b 80 00       	push   $0x803b44
  800874:	68 a8 00 00 00       	push   $0xa8
  800879:	68 5c 3a 80 00       	push   $0x803a5c
  80087e:	e8 32 02 00 00       	call   800ab5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800883:	e8 3b 18 00 00       	call   8020c3 <sys_calculate_free_frames>
  800888:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80088b:	e8 d3 18 00 00       	call   802163 <sys_pf_calculate_allocated_pages>
  800890:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[6]);
  800893:	8b 45 98             	mov    -0x68(%ebp),%eax
  800896:	83 ec 0c             	sub    $0xc,%esp
  800899:	50                   	push   %eax
  80089a:	e8 71 14 00 00       	call   801d10 <free>
  80089f:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  8008a2:	e8 bc 18 00 00       	call   802163 <sys_pf_calculate_allocated_pages>
  8008a7:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8008aa:	74 17                	je     8008c3 <_main+0x88b>
  8008ac:	83 ec 04             	sub    $0x4,%esp
  8008af:	68 08 3b 80 00       	push   $0x803b08
  8008b4:	68 ad 00 00 00       	push   $0xad
  8008b9:	68 5c 3a 80 00       	push   $0x803a5c
  8008be:	e8 f2 01 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 512 + 2) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[6];
  8008c3:	8b 45 98             	mov    -0x68(%ebp),%eax
  8008c6:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  8008c9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8008cc:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  8008cf:	e8 6e 1b 00 00       	call   802442 <sys_rcr2>
  8008d4:	89 c2                	mov    %eax,%edx
  8008d6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8008d9:	39 c2                	cmp    %eax,%edx
  8008db:	74 17                	je     8008f4 <_main+0x8bc>
  8008dd:	83 ec 04             	sub    $0x4,%esp
  8008e0:	68 44 3b 80 00       	push   $0x803b44
  8008e5:	68 b1 00 00 00       	push   $0xb1
  8008ea:	68 5c 3a 80 00       	push   $0x803a5c
  8008ef:	e8 c1 01 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[6]] = 10;
  8008f4:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  8008fa:	89 c2                	mov    %eax,%edx
  8008fc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8008ff:	01 d0                	add    %edx,%eax
  800901:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[6]])) panic("Free: successful access to freed space!! it should not be succeeded");
  800904:	e8 39 1b 00 00       	call   802442 <sys_rcr2>
  800909:	8b 95 48 ff ff ff    	mov    -0xb8(%ebp),%edx
  80090f:	89 d1                	mov    %edx,%ecx
  800911:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800914:	01 ca                	add    %ecx,%edx
  800916:	39 d0                	cmp    %edx,%eax
  800918:	74 17                	je     800931 <_main+0x8f9>
  80091a:	83 ec 04             	sub    $0x4,%esp
  80091d:	68 44 3b 80 00       	push   $0x803b44
  800922:	68 b3 00 00 00       	push   $0xb3
  800927:	68 5c 3a 80 00       	push   $0x803a5c
  80092c:	e8 84 01 00 00       	call   800ab5 <_panic>

		if(start_freeFrames != (sys_calculate_free_frames()) ) {panic("Wrong free: not all pages removed correctly at end");}
  800931:	e8 8d 17 00 00       	call   8020c3 <sys_calculate_free_frames>
  800936:	89 c2                	mov    %eax,%edx
  800938:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80093b:	39 c2                	cmp    %eax,%edx
  80093d:	74 17                	je     800956 <_main+0x91e>
  80093f:	83 ec 04             	sub    $0x4,%esp
  800942:	68 88 3b 80 00       	push   $0x803b88
  800947:	68 b5 00 00 00       	push   $0xb5
  80094c:	68 5c 3a 80 00       	push   $0x803a5c
  800951:	e8 5f 01 00 00       	call   800ab5 <_panic>
	}

	//set it to 0 again to cancel the bypassing option
	sys_bypassPageFault(0);
  800956:	83 ec 0c             	sub    $0xc,%esp
  800959:	6a 00                	push   $0x0
  80095b:	e8 fb 1a 00 00       	call   80245b <sys_bypassPageFault>
  800960:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! test free [2] completed successfully.\n");
  800963:	83 ec 0c             	sub    $0xc,%esp
  800966:	68 bc 3b 80 00       	push   $0x803bbc
  80096b:	e8 f9 03 00 00       	call   800d69 <cprintf>
  800970:	83 c4 10             	add    $0x10,%esp

	return;
  800973:	90                   	nop
}
  800974:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800977:	c9                   	leave  
  800978:	c3                   	ret    

00800979 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800979:	55                   	push   %ebp
  80097a:	89 e5                	mov    %esp,%ebp
  80097c:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80097f:	e8 1f 1a 00 00       	call   8023a3 <sys_getenvindex>
  800984:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800987:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80098a:	89 d0                	mov    %edx,%eax
  80098c:	c1 e0 03             	shl    $0x3,%eax
  80098f:	01 d0                	add    %edx,%eax
  800991:	01 c0                	add    %eax,%eax
  800993:	01 d0                	add    %edx,%eax
  800995:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80099c:	01 d0                	add    %edx,%eax
  80099e:	c1 e0 04             	shl    $0x4,%eax
  8009a1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8009a6:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8009ab:	a1 20 50 80 00       	mov    0x805020,%eax
  8009b0:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8009b6:	84 c0                	test   %al,%al
  8009b8:	74 0f                	je     8009c9 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8009ba:	a1 20 50 80 00       	mov    0x805020,%eax
  8009bf:	05 5c 05 00 00       	add    $0x55c,%eax
  8009c4:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8009c9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8009cd:	7e 0a                	jle    8009d9 <libmain+0x60>
		binaryname = argv[0];
  8009cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009d2:	8b 00                	mov    (%eax),%eax
  8009d4:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8009d9:	83 ec 08             	sub    $0x8,%esp
  8009dc:	ff 75 0c             	pushl  0xc(%ebp)
  8009df:	ff 75 08             	pushl  0x8(%ebp)
  8009e2:	e8 51 f6 ff ff       	call   800038 <_main>
  8009e7:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8009ea:	e8 c1 17 00 00       	call   8021b0 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8009ef:	83 ec 0c             	sub    $0xc,%esp
  8009f2:	68 10 3c 80 00       	push   $0x803c10
  8009f7:	e8 6d 03 00 00       	call   800d69 <cprintf>
  8009fc:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8009ff:	a1 20 50 80 00       	mov    0x805020,%eax
  800a04:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800a0a:	a1 20 50 80 00       	mov    0x805020,%eax
  800a0f:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800a15:	83 ec 04             	sub    $0x4,%esp
  800a18:	52                   	push   %edx
  800a19:	50                   	push   %eax
  800a1a:	68 38 3c 80 00       	push   $0x803c38
  800a1f:	e8 45 03 00 00       	call   800d69 <cprintf>
  800a24:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800a27:	a1 20 50 80 00       	mov    0x805020,%eax
  800a2c:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800a32:	a1 20 50 80 00       	mov    0x805020,%eax
  800a37:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800a3d:	a1 20 50 80 00       	mov    0x805020,%eax
  800a42:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800a48:	51                   	push   %ecx
  800a49:	52                   	push   %edx
  800a4a:	50                   	push   %eax
  800a4b:	68 60 3c 80 00       	push   $0x803c60
  800a50:	e8 14 03 00 00       	call   800d69 <cprintf>
  800a55:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800a58:	a1 20 50 80 00       	mov    0x805020,%eax
  800a5d:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800a63:	83 ec 08             	sub    $0x8,%esp
  800a66:	50                   	push   %eax
  800a67:	68 b8 3c 80 00       	push   $0x803cb8
  800a6c:	e8 f8 02 00 00       	call   800d69 <cprintf>
  800a71:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800a74:	83 ec 0c             	sub    $0xc,%esp
  800a77:	68 10 3c 80 00       	push   $0x803c10
  800a7c:	e8 e8 02 00 00       	call   800d69 <cprintf>
  800a81:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800a84:	e8 41 17 00 00       	call   8021ca <sys_enable_interrupt>

	// exit gracefully
	exit();
  800a89:	e8 19 00 00 00       	call   800aa7 <exit>
}
  800a8e:	90                   	nop
  800a8f:	c9                   	leave  
  800a90:	c3                   	ret    

00800a91 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800a91:	55                   	push   %ebp
  800a92:	89 e5                	mov    %esp,%ebp
  800a94:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800a97:	83 ec 0c             	sub    $0xc,%esp
  800a9a:	6a 00                	push   $0x0
  800a9c:	e8 ce 18 00 00       	call   80236f <sys_destroy_env>
  800aa1:	83 c4 10             	add    $0x10,%esp
}
  800aa4:	90                   	nop
  800aa5:	c9                   	leave  
  800aa6:	c3                   	ret    

00800aa7 <exit>:

void
exit(void)
{
  800aa7:	55                   	push   %ebp
  800aa8:	89 e5                	mov    %esp,%ebp
  800aaa:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800aad:	e8 23 19 00 00       	call   8023d5 <sys_exit_env>
}
  800ab2:	90                   	nop
  800ab3:	c9                   	leave  
  800ab4:	c3                   	ret    

00800ab5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800ab5:	55                   	push   %ebp
  800ab6:	89 e5                	mov    %esp,%ebp
  800ab8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800abb:	8d 45 10             	lea    0x10(%ebp),%eax
  800abe:	83 c0 04             	add    $0x4,%eax
  800ac1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800ac4:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800ac9:	85 c0                	test   %eax,%eax
  800acb:	74 16                	je     800ae3 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800acd:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800ad2:	83 ec 08             	sub    $0x8,%esp
  800ad5:	50                   	push   %eax
  800ad6:	68 cc 3c 80 00       	push   $0x803ccc
  800adb:	e8 89 02 00 00       	call   800d69 <cprintf>
  800ae0:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800ae3:	a1 00 50 80 00       	mov    0x805000,%eax
  800ae8:	ff 75 0c             	pushl  0xc(%ebp)
  800aeb:	ff 75 08             	pushl  0x8(%ebp)
  800aee:	50                   	push   %eax
  800aef:	68 d1 3c 80 00       	push   $0x803cd1
  800af4:	e8 70 02 00 00       	call   800d69 <cprintf>
  800af9:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800afc:	8b 45 10             	mov    0x10(%ebp),%eax
  800aff:	83 ec 08             	sub    $0x8,%esp
  800b02:	ff 75 f4             	pushl  -0xc(%ebp)
  800b05:	50                   	push   %eax
  800b06:	e8 f3 01 00 00       	call   800cfe <vcprintf>
  800b0b:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800b0e:	83 ec 08             	sub    $0x8,%esp
  800b11:	6a 00                	push   $0x0
  800b13:	68 ed 3c 80 00       	push   $0x803ced
  800b18:	e8 e1 01 00 00       	call   800cfe <vcprintf>
  800b1d:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800b20:	e8 82 ff ff ff       	call   800aa7 <exit>

	// should not return here
	while (1) ;
  800b25:	eb fe                	jmp    800b25 <_panic+0x70>

00800b27 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800b27:	55                   	push   %ebp
  800b28:	89 e5                	mov    %esp,%ebp
  800b2a:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800b2d:	a1 20 50 80 00       	mov    0x805020,%eax
  800b32:	8b 50 74             	mov    0x74(%eax),%edx
  800b35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b38:	39 c2                	cmp    %eax,%edx
  800b3a:	74 14                	je     800b50 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800b3c:	83 ec 04             	sub    $0x4,%esp
  800b3f:	68 f0 3c 80 00       	push   $0x803cf0
  800b44:	6a 26                	push   $0x26
  800b46:	68 3c 3d 80 00       	push   $0x803d3c
  800b4b:	e8 65 ff ff ff       	call   800ab5 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800b50:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800b57:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800b5e:	e9 c2 00 00 00       	jmp    800c25 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800b63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b66:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b70:	01 d0                	add    %edx,%eax
  800b72:	8b 00                	mov    (%eax),%eax
  800b74:	85 c0                	test   %eax,%eax
  800b76:	75 08                	jne    800b80 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800b78:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800b7b:	e9 a2 00 00 00       	jmp    800c22 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800b80:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b87:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800b8e:	eb 69                	jmp    800bf9 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800b90:	a1 20 50 80 00       	mov    0x805020,%eax
  800b95:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800b9b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800b9e:	89 d0                	mov    %edx,%eax
  800ba0:	01 c0                	add    %eax,%eax
  800ba2:	01 d0                	add    %edx,%eax
  800ba4:	c1 e0 03             	shl    $0x3,%eax
  800ba7:	01 c8                	add    %ecx,%eax
  800ba9:	8a 40 04             	mov    0x4(%eax),%al
  800bac:	84 c0                	test   %al,%al
  800bae:	75 46                	jne    800bf6 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800bb0:	a1 20 50 80 00       	mov    0x805020,%eax
  800bb5:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800bbb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800bbe:	89 d0                	mov    %edx,%eax
  800bc0:	01 c0                	add    %eax,%eax
  800bc2:	01 d0                	add    %edx,%eax
  800bc4:	c1 e0 03             	shl    $0x3,%eax
  800bc7:	01 c8                	add    %ecx,%eax
  800bc9:	8b 00                	mov    (%eax),%eax
  800bcb:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800bce:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800bd1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800bd6:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800bd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bdb:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800be2:	8b 45 08             	mov    0x8(%ebp),%eax
  800be5:	01 c8                	add    %ecx,%eax
  800be7:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800be9:	39 c2                	cmp    %eax,%edx
  800beb:	75 09                	jne    800bf6 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800bed:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800bf4:	eb 12                	jmp    800c08 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800bf6:	ff 45 e8             	incl   -0x18(%ebp)
  800bf9:	a1 20 50 80 00       	mov    0x805020,%eax
  800bfe:	8b 50 74             	mov    0x74(%eax),%edx
  800c01:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800c04:	39 c2                	cmp    %eax,%edx
  800c06:	77 88                	ja     800b90 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800c08:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800c0c:	75 14                	jne    800c22 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800c0e:	83 ec 04             	sub    $0x4,%esp
  800c11:	68 48 3d 80 00       	push   $0x803d48
  800c16:	6a 3a                	push   $0x3a
  800c18:	68 3c 3d 80 00       	push   $0x803d3c
  800c1d:	e8 93 fe ff ff       	call   800ab5 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800c22:	ff 45 f0             	incl   -0x10(%ebp)
  800c25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c28:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800c2b:	0f 8c 32 ff ff ff    	jl     800b63 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800c31:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800c38:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800c3f:	eb 26                	jmp    800c67 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800c41:	a1 20 50 80 00       	mov    0x805020,%eax
  800c46:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800c4c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c4f:	89 d0                	mov    %edx,%eax
  800c51:	01 c0                	add    %eax,%eax
  800c53:	01 d0                	add    %edx,%eax
  800c55:	c1 e0 03             	shl    $0x3,%eax
  800c58:	01 c8                	add    %ecx,%eax
  800c5a:	8a 40 04             	mov    0x4(%eax),%al
  800c5d:	3c 01                	cmp    $0x1,%al
  800c5f:	75 03                	jne    800c64 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800c61:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800c64:	ff 45 e0             	incl   -0x20(%ebp)
  800c67:	a1 20 50 80 00       	mov    0x805020,%eax
  800c6c:	8b 50 74             	mov    0x74(%eax),%edx
  800c6f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c72:	39 c2                	cmp    %eax,%edx
  800c74:	77 cb                	ja     800c41 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800c76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c79:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800c7c:	74 14                	je     800c92 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800c7e:	83 ec 04             	sub    $0x4,%esp
  800c81:	68 9c 3d 80 00       	push   $0x803d9c
  800c86:	6a 44                	push   $0x44
  800c88:	68 3c 3d 80 00       	push   $0x803d3c
  800c8d:	e8 23 fe ff ff       	call   800ab5 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800c92:	90                   	nop
  800c93:	c9                   	leave  
  800c94:	c3                   	ret    

00800c95 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800c95:	55                   	push   %ebp
  800c96:	89 e5                	mov    %esp,%ebp
  800c98:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800c9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9e:	8b 00                	mov    (%eax),%eax
  800ca0:	8d 48 01             	lea    0x1(%eax),%ecx
  800ca3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ca6:	89 0a                	mov    %ecx,(%edx)
  800ca8:	8b 55 08             	mov    0x8(%ebp),%edx
  800cab:	88 d1                	mov    %dl,%cl
  800cad:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cb0:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800cb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb7:	8b 00                	mov    (%eax),%eax
  800cb9:	3d ff 00 00 00       	cmp    $0xff,%eax
  800cbe:	75 2c                	jne    800cec <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800cc0:	a0 24 50 80 00       	mov    0x805024,%al
  800cc5:	0f b6 c0             	movzbl %al,%eax
  800cc8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ccb:	8b 12                	mov    (%edx),%edx
  800ccd:	89 d1                	mov    %edx,%ecx
  800ccf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cd2:	83 c2 08             	add    $0x8,%edx
  800cd5:	83 ec 04             	sub    $0x4,%esp
  800cd8:	50                   	push   %eax
  800cd9:	51                   	push   %ecx
  800cda:	52                   	push   %edx
  800cdb:	e8 22 13 00 00       	call   802002 <sys_cputs>
  800ce0:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800ce3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800cec:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cef:	8b 40 04             	mov    0x4(%eax),%eax
  800cf2:	8d 50 01             	lea    0x1(%eax),%edx
  800cf5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf8:	89 50 04             	mov    %edx,0x4(%eax)
}
  800cfb:	90                   	nop
  800cfc:	c9                   	leave  
  800cfd:	c3                   	ret    

00800cfe <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800cfe:	55                   	push   %ebp
  800cff:	89 e5                	mov    %esp,%ebp
  800d01:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800d07:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800d0e:	00 00 00 
	b.cnt = 0;
  800d11:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800d18:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800d1b:	ff 75 0c             	pushl  0xc(%ebp)
  800d1e:	ff 75 08             	pushl  0x8(%ebp)
  800d21:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800d27:	50                   	push   %eax
  800d28:	68 95 0c 80 00       	push   $0x800c95
  800d2d:	e8 11 02 00 00       	call   800f43 <vprintfmt>
  800d32:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800d35:	a0 24 50 80 00       	mov    0x805024,%al
  800d3a:	0f b6 c0             	movzbl %al,%eax
  800d3d:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800d43:	83 ec 04             	sub    $0x4,%esp
  800d46:	50                   	push   %eax
  800d47:	52                   	push   %edx
  800d48:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800d4e:	83 c0 08             	add    $0x8,%eax
  800d51:	50                   	push   %eax
  800d52:	e8 ab 12 00 00       	call   802002 <sys_cputs>
  800d57:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800d5a:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800d61:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800d67:	c9                   	leave  
  800d68:	c3                   	ret    

00800d69 <cprintf>:

int cprintf(const char *fmt, ...) {
  800d69:	55                   	push   %ebp
  800d6a:	89 e5                	mov    %esp,%ebp
  800d6c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800d6f:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800d76:	8d 45 0c             	lea    0xc(%ebp),%eax
  800d79:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7f:	83 ec 08             	sub    $0x8,%esp
  800d82:	ff 75 f4             	pushl  -0xc(%ebp)
  800d85:	50                   	push   %eax
  800d86:	e8 73 ff ff ff       	call   800cfe <vcprintf>
  800d8b:	83 c4 10             	add    $0x10,%esp
  800d8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800d91:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d94:	c9                   	leave  
  800d95:	c3                   	ret    

00800d96 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800d96:	55                   	push   %ebp
  800d97:	89 e5                	mov    %esp,%ebp
  800d99:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800d9c:	e8 0f 14 00 00       	call   8021b0 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800da1:	8d 45 0c             	lea    0xc(%ebp),%eax
  800da4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800da7:	8b 45 08             	mov    0x8(%ebp),%eax
  800daa:	83 ec 08             	sub    $0x8,%esp
  800dad:	ff 75 f4             	pushl  -0xc(%ebp)
  800db0:	50                   	push   %eax
  800db1:	e8 48 ff ff ff       	call   800cfe <vcprintf>
  800db6:	83 c4 10             	add    $0x10,%esp
  800db9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800dbc:	e8 09 14 00 00       	call   8021ca <sys_enable_interrupt>
	return cnt;
  800dc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800dc4:	c9                   	leave  
  800dc5:	c3                   	ret    

00800dc6 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800dc6:	55                   	push   %ebp
  800dc7:	89 e5                	mov    %esp,%ebp
  800dc9:	53                   	push   %ebx
  800dca:	83 ec 14             	sub    $0x14,%esp
  800dcd:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dd3:	8b 45 14             	mov    0x14(%ebp),%eax
  800dd6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800dd9:	8b 45 18             	mov    0x18(%ebp),%eax
  800ddc:	ba 00 00 00 00       	mov    $0x0,%edx
  800de1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800de4:	77 55                	ja     800e3b <printnum+0x75>
  800de6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800de9:	72 05                	jb     800df0 <printnum+0x2a>
  800deb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800dee:	77 4b                	ja     800e3b <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800df0:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800df3:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800df6:	8b 45 18             	mov    0x18(%ebp),%eax
  800df9:	ba 00 00 00 00       	mov    $0x0,%edx
  800dfe:	52                   	push   %edx
  800dff:	50                   	push   %eax
  800e00:	ff 75 f4             	pushl  -0xc(%ebp)
  800e03:	ff 75 f0             	pushl  -0x10(%ebp)
  800e06:	e8 b5 29 00 00       	call   8037c0 <__udivdi3>
  800e0b:	83 c4 10             	add    $0x10,%esp
  800e0e:	83 ec 04             	sub    $0x4,%esp
  800e11:	ff 75 20             	pushl  0x20(%ebp)
  800e14:	53                   	push   %ebx
  800e15:	ff 75 18             	pushl  0x18(%ebp)
  800e18:	52                   	push   %edx
  800e19:	50                   	push   %eax
  800e1a:	ff 75 0c             	pushl  0xc(%ebp)
  800e1d:	ff 75 08             	pushl  0x8(%ebp)
  800e20:	e8 a1 ff ff ff       	call   800dc6 <printnum>
  800e25:	83 c4 20             	add    $0x20,%esp
  800e28:	eb 1a                	jmp    800e44 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800e2a:	83 ec 08             	sub    $0x8,%esp
  800e2d:	ff 75 0c             	pushl  0xc(%ebp)
  800e30:	ff 75 20             	pushl  0x20(%ebp)
  800e33:	8b 45 08             	mov    0x8(%ebp),%eax
  800e36:	ff d0                	call   *%eax
  800e38:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800e3b:	ff 4d 1c             	decl   0x1c(%ebp)
  800e3e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800e42:	7f e6                	jg     800e2a <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800e44:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800e47:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e52:	53                   	push   %ebx
  800e53:	51                   	push   %ecx
  800e54:	52                   	push   %edx
  800e55:	50                   	push   %eax
  800e56:	e8 75 2a 00 00       	call   8038d0 <__umoddi3>
  800e5b:	83 c4 10             	add    $0x10,%esp
  800e5e:	05 14 40 80 00       	add    $0x804014,%eax
  800e63:	8a 00                	mov    (%eax),%al
  800e65:	0f be c0             	movsbl %al,%eax
  800e68:	83 ec 08             	sub    $0x8,%esp
  800e6b:	ff 75 0c             	pushl  0xc(%ebp)
  800e6e:	50                   	push   %eax
  800e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e72:	ff d0                	call   *%eax
  800e74:	83 c4 10             	add    $0x10,%esp
}
  800e77:	90                   	nop
  800e78:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e7b:	c9                   	leave  
  800e7c:	c3                   	ret    

00800e7d <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800e7d:	55                   	push   %ebp
  800e7e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800e80:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800e84:	7e 1c                	jle    800ea2 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800e86:	8b 45 08             	mov    0x8(%ebp),%eax
  800e89:	8b 00                	mov    (%eax),%eax
  800e8b:	8d 50 08             	lea    0x8(%eax),%edx
  800e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e91:	89 10                	mov    %edx,(%eax)
  800e93:	8b 45 08             	mov    0x8(%ebp),%eax
  800e96:	8b 00                	mov    (%eax),%eax
  800e98:	83 e8 08             	sub    $0x8,%eax
  800e9b:	8b 50 04             	mov    0x4(%eax),%edx
  800e9e:	8b 00                	mov    (%eax),%eax
  800ea0:	eb 40                	jmp    800ee2 <getuint+0x65>
	else if (lflag)
  800ea2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ea6:	74 1e                	je     800ec6 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eab:	8b 00                	mov    (%eax),%eax
  800ead:	8d 50 04             	lea    0x4(%eax),%edx
  800eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb3:	89 10                	mov    %edx,(%eax)
  800eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb8:	8b 00                	mov    (%eax),%eax
  800eba:	83 e8 04             	sub    $0x4,%eax
  800ebd:	8b 00                	mov    (%eax),%eax
  800ebf:	ba 00 00 00 00       	mov    $0x0,%edx
  800ec4:	eb 1c                	jmp    800ee2 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec9:	8b 00                	mov    (%eax),%eax
  800ecb:	8d 50 04             	lea    0x4(%eax),%edx
  800ece:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed1:	89 10                	mov    %edx,(%eax)
  800ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed6:	8b 00                	mov    (%eax),%eax
  800ed8:	83 e8 04             	sub    $0x4,%eax
  800edb:	8b 00                	mov    (%eax),%eax
  800edd:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800ee2:	5d                   	pop    %ebp
  800ee3:	c3                   	ret    

00800ee4 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800ee4:	55                   	push   %ebp
  800ee5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ee7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800eeb:	7e 1c                	jle    800f09 <getint+0x25>
		return va_arg(*ap, long long);
  800eed:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef0:	8b 00                	mov    (%eax),%eax
  800ef2:	8d 50 08             	lea    0x8(%eax),%edx
  800ef5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef8:	89 10                	mov    %edx,(%eax)
  800efa:	8b 45 08             	mov    0x8(%ebp),%eax
  800efd:	8b 00                	mov    (%eax),%eax
  800eff:	83 e8 08             	sub    $0x8,%eax
  800f02:	8b 50 04             	mov    0x4(%eax),%edx
  800f05:	8b 00                	mov    (%eax),%eax
  800f07:	eb 38                	jmp    800f41 <getint+0x5d>
	else if (lflag)
  800f09:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f0d:	74 1a                	je     800f29 <getint+0x45>
		return va_arg(*ap, long);
  800f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f12:	8b 00                	mov    (%eax),%eax
  800f14:	8d 50 04             	lea    0x4(%eax),%edx
  800f17:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1a:	89 10                	mov    %edx,(%eax)
  800f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1f:	8b 00                	mov    (%eax),%eax
  800f21:	83 e8 04             	sub    $0x4,%eax
  800f24:	8b 00                	mov    (%eax),%eax
  800f26:	99                   	cltd   
  800f27:	eb 18                	jmp    800f41 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800f29:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2c:	8b 00                	mov    (%eax),%eax
  800f2e:	8d 50 04             	lea    0x4(%eax),%edx
  800f31:	8b 45 08             	mov    0x8(%ebp),%eax
  800f34:	89 10                	mov    %edx,(%eax)
  800f36:	8b 45 08             	mov    0x8(%ebp),%eax
  800f39:	8b 00                	mov    (%eax),%eax
  800f3b:	83 e8 04             	sub    $0x4,%eax
  800f3e:	8b 00                	mov    (%eax),%eax
  800f40:	99                   	cltd   
}
  800f41:	5d                   	pop    %ebp
  800f42:	c3                   	ret    

00800f43 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800f43:	55                   	push   %ebp
  800f44:	89 e5                	mov    %esp,%ebp
  800f46:	56                   	push   %esi
  800f47:	53                   	push   %ebx
  800f48:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f4b:	eb 17                	jmp    800f64 <vprintfmt+0x21>
			if (ch == '\0')
  800f4d:	85 db                	test   %ebx,%ebx
  800f4f:	0f 84 af 03 00 00    	je     801304 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800f55:	83 ec 08             	sub    $0x8,%esp
  800f58:	ff 75 0c             	pushl  0xc(%ebp)
  800f5b:	53                   	push   %ebx
  800f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5f:	ff d0                	call   *%eax
  800f61:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f64:	8b 45 10             	mov    0x10(%ebp),%eax
  800f67:	8d 50 01             	lea    0x1(%eax),%edx
  800f6a:	89 55 10             	mov    %edx,0x10(%ebp)
  800f6d:	8a 00                	mov    (%eax),%al
  800f6f:	0f b6 d8             	movzbl %al,%ebx
  800f72:	83 fb 25             	cmp    $0x25,%ebx
  800f75:	75 d6                	jne    800f4d <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800f77:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800f7b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800f82:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800f89:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800f90:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800f97:	8b 45 10             	mov    0x10(%ebp),%eax
  800f9a:	8d 50 01             	lea    0x1(%eax),%edx
  800f9d:	89 55 10             	mov    %edx,0x10(%ebp)
  800fa0:	8a 00                	mov    (%eax),%al
  800fa2:	0f b6 d8             	movzbl %al,%ebx
  800fa5:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800fa8:	83 f8 55             	cmp    $0x55,%eax
  800fab:	0f 87 2b 03 00 00    	ja     8012dc <vprintfmt+0x399>
  800fb1:	8b 04 85 38 40 80 00 	mov    0x804038(,%eax,4),%eax
  800fb8:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800fba:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800fbe:	eb d7                	jmp    800f97 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800fc0:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800fc4:	eb d1                	jmp    800f97 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800fc6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800fcd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800fd0:	89 d0                	mov    %edx,%eax
  800fd2:	c1 e0 02             	shl    $0x2,%eax
  800fd5:	01 d0                	add    %edx,%eax
  800fd7:	01 c0                	add    %eax,%eax
  800fd9:	01 d8                	add    %ebx,%eax
  800fdb:	83 e8 30             	sub    $0x30,%eax
  800fde:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800fe1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe4:	8a 00                	mov    (%eax),%al
  800fe6:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800fe9:	83 fb 2f             	cmp    $0x2f,%ebx
  800fec:	7e 3e                	jle    80102c <vprintfmt+0xe9>
  800fee:	83 fb 39             	cmp    $0x39,%ebx
  800ff1:	7f 39                	jg     80102c <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ff3:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ff6:	eb d5                	jmp    800fcd <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800ff8:	8b 45 14             	mov    0x14(%ebp),%eax
  800ffb:	83 c0 04             	add    $0x4,%eax
  800ffe:	89 45 14             	mov    %eax,0x14(%ebp)
  801001:	8b 45 14             	mov    0x14(%ebp),%eax
  801004:	83 e8 04             	sub    $0x4,%eax
  801007:	8b 00                	mov    (%eax),%eax
  801009:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80100c:	eb 1f                	jmp    80102d <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80100e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801012:	79 83                	jns    800f97 <vprintfmt+0x54>
				width = 0;
  801014:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80101b:	e9 77 ff ff ff       	jmp    800f97 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801020:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801027:	e9 6b ff ff ff       	jmp    800f97 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80102c:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80102d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801031:	0f 89 60 ff ff ff    	jns    800f97 <vprintfmt+0x54>
				width = precision, precision = -1;
  801037:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80103a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80103d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801044:	e9 4e ff ff ff       	jmp    800f97 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801049:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80104c:	e9 46 ff ff ff       	jmp    800f97 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801051:	8b 45 14             	mov    0x14(%ebp),%eax
  801054:	83 c0 04             	add    $0x4,%eax
  801057:	89 45 14             	mov    %eax,0x14(%ebp)
  80105a:	8b 45 14             	mov    0x14(%ebp),%eax
  80105d:	83 e8 04             	sub    $0x4,%eax
  801060:	8b 00                	mov    (%eax),%eax
  801062:	83 ec 08             	sub    $0x8,%esp
  801065:	ff 75 0c             	pushl  0xc(%ebp)
  801068:	50                   	push   %eax
  801069:	8b 45 08             	mov    0x8(%ebp),%eax
  80106c:	ff d0                	call   *%eax
  80106e:	83 c4 10             	add    $0x10,%esp
			break;
  801071:	e9 89 02 00 00       	jmp    8012ff <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801076:	8b 45 14             	mov    0x14(%ebp),%eax
  801079:	83 c0 04             	add    $0x4,%eax
  80107c:	89 45 14             	mov    %eax,0x14(%ebp)
  80107f:	8b 45 14             	mov    0x14(%ebp),%eax
  801082:	83 e8 04             	sub    $0x4,%eax
  801085:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801087:	85 db                	test   %ebx,%ebx
  801089:	79 02                	jns    80108d <vprintfmt+0x14a>
				err = -err;
  80108b:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80108d:	83 fb 64             	cmp    $0x64,%ebx
  801090:	7f 0b                	jg     80109d <vprintfmt+0x15a>
  801092:	8b 34 9d 80 3e 80 00 	mov    0x803e80(,%ebx,4),%esi
  801099:	85 f6                	test   %esi,%esi
  80109b:	75 19                	jne    8010b6 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80109d:	53                   	push   %ebx
  80109e:	68 25 40 80 00       	push   $0x804025
  8010a3:	ff 75 0c             	pushl  0xc(%ebp)
  8010a6:	ff 75 08             	pushl  0x8(%ebp)
  8010a9:	e8 5e 02 00 00       	call   80130c <printfmt>
  8010ae:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8010b1:	e9 49 02 00 00       	jmp    8012ff <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8010b6:	56                   	push   %esi
  8010b7:	68 2e 40 80 00       	push   $0x80402e
  8010bc:	ff 75 0c             	pushl  0xc(%ebp)
  8010bf:	ff 75 08             	pushl  0x8(%ebp)
  8010c2:	e8 45 02 00 00       	call   80130c <printfmt>
  8010c7:	83 c4 10             	add    $0x10,%esp
			break;
  8010ca:	e9 30 02 00 00       	jmp    8012ff <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8010cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8010d2:	83 c0 04             	add    $0x4,%eax
  8010d5:	89 45 14             	mov    %eax,0x14(%ebp)
  8010d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8010db:	83 e8 04             	sub    $0x4,%eax
  8010de:	8b 30                	mov    (%eax),%esi
  8010e0:	85 f6                	test   %esi,%esi
  8010e2:	75 05                	jne    8010e9 <vprintfmt+0x1a6>
				p = "(null)";
  8010e4:	be 31 40 80 00       	mov    $0x804031,%esi
			if (width > 0 && padc != '-')
  8010e9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8010ed:	7e 6d                	jle    80115c <vprintfmt+0x219>
  8010ef:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8010f3:	74 67                	je     80115c <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8010f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8010f8:	83 ec 08             	sub    $0x8,%esp
  8010fb:	50                   	push   %eax
  8010fc:	56                   	push   %esi
  8010fd:	e8 0c 03 00 00       	call   80140e <strnlen>
  801102:	83 c4 10             	add    $0x10,%esp
  801105:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801108:	eb 16                	jmp    801120 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80110a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80110e:	83 ec 08             	sub    $0x8,%esp
  801111:	ff 75 0c             	pushl  0xc(%ebp)
  801114:	50                   	push   %eax
  801115:	8b 45 08             	mov    0x8(%ebp),%eax
  801118:	ff d0                	call   *%eax
  80111a:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80111d:	ff 4d e4             	decl   -0x1c(%ebp)
  801120:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801124:	7f e4                	jg     80110a <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801126:	eb 34                	jmp    80115c <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801128:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80112c:	74 1c                	je     80114a <vprintfmt+0x207>
  80112e:	83 fb 1f             	cmp    $0x1f,%ebx
  801131:	7e 05                	jle    801138 <vprintfmt+0x1f5>
  801133:	83 fb 7e             	cmp    $0x7e,%ebx
  801136:	7e 12                	jle    80114a <vprintfmt+0x207>
					putch('?', putdat);
  801138:	83 ec 08             	sub    $0x8,%esp
  80113b:	ff 75 0c             	pushl  0xc(%ebp)
  80113e:	6a 3f                	push   $0x3f
  801140:	8b 45 08             	mov    0x8(%ebp),%eax
  801143:	ff d0                	call   *%eax
  801145:	83 c4 10             	add    $0x10,%esp
  801148:	eb 0f                	jmp    801159 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80114a:	83 ec 08             	sub    $0x8,%esp
  80114d:	ff 75 0c             	pushl  0xc(%ebp)
  801150:	53                   	push   %ebx
  801151:	8b 45 08             	mov    0x8(%ebp),%eax
  801154:	ff d0                	call   *%eax
  801156:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801159:	ff 4d e4             	decl   -0x1c(%ebp)
  80115c:	89 f0                	mov    %esi,%eax
  80115e:	8d 70 01             	lea    0x1(%eax),%esi
  801161:	8a 00                	mov    (%eax),%al
  801163:	0f be d8             	movsbl %al,%ebx
  801166:	85 db                	test   %ebx,%ebx
  801168:	74 24                	je     80118e <vprintfmt+0x24b>
  80116a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80116e:	78 b8                	js     801128 <vprintfmt+0x1e5>
  801170:	ff 4d e0             	decl   -0x20(%ebp)
  801173:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801177:	79 af                	jns    801128 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801179:	eb 13                	jmp    80118e <vprintfmt+0x24b>
				putch(' ', putdat);
  80117b:	83 ec 08             	sub    $0x8,%esp
  80117e:	ff 75 0c             	pushl  0xc(%ebp)
  801181:	6a 20                	push   $0x20
  801183:	8b 45 08             	mov    0x8(%ebp),%eax
  801186:	ff d0                	call   *%eax
  801188:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80118b:	ff 4d e4             	decl   -0x1c(%ebp)
  80118e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801192:	7f e7                	jg     80117b <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801194:	e9 66 01 00 00       	jmp    8012ff <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801199:	83 ec 08             	sub    $0x8,%esp
  80119c:	ff 75 e8             	pushl  -0x18(%ebp)
  80119f:	8d 45 14             	lea    0x14(%ebp),%eax
  8011a2:	50                   	push   %eax
  8011a3:	e8 3c fd ff ff       	call   800ee4 <getint>
  8011a8:	83 c4 10             	add    $0x10,%esp
  8011ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011ae:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8011b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011b7:	85 d2                	test   %edx,%edx
  8011b9:	79 23                	jns    8011de <vprintfmt+0x29b>
				putch('-', putdat);
  8011bb:	83 ec 08             	sub    $0x8,%esp
  8011be:	ff 75 0c             	pushl  0xc(%ebp)
  8011c1:	6a 2d                	push   $0x2d
  8011c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c6:	ff d0                	call   *%eax
  8011c8:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8011cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011d1:	f7 d8                	neg    %eax
  8011d3:	83 d2 00             	adc    $0x0,%edx
  8011d6:	f7 da                	neg    %edx
  8011d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011db:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8011de:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8011e5:	e9 bc 00 00 00       	jmp    8012a6 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8011ea:	83 ec 08             	sub    $0x8,%esp
  8011ed:	ff 75 e8             	pushl  -0x18(%ebp)
  8011f0:	8d 45 14             	lea    0x14(%ebp),%eax
  8011f3:	50                   	push   %eax
  8011f4:	e8 84 fc ff ff       	call   800e7d <getuint>
  8011f9:	83 c4 10             	add    $0x10,%esp
  8011fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011ff:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801202:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801209:	e9 98 00 00 00       	jmp    8012a6 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80120e:	83 ec 08             	sub    $0x8,%esp
  801211:	ff 75 0c             	pushl  0xc(%ebp)
  801214:	6a 58                	push   $0x58
  801216:	8b 45 08             	mov    0x8(%ebp),%eax
  801219:	ff d0                	call   *%eax
  80121b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80121e:	83 ec 08             	sub    $0x8,%esp
  801221:	ff 75 0c             	pushl  0xc(%ebp)
  801224:	6a 58                	push   $0x58
  801226:	8b 45 08             	mov    0x8(%ebp),%eax
  801229:	ff d0                	call   *%eax
  80122b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80122e:	83 ec 08             	sub    $0x8,%esp
  801231:	ff 75 0c             	pushl  0xc(%ebp)
  801234:	6a 58                	push   $0x58
  801236:	8b 45 08             	mov    0x8(%ebp),%eax
  801239:	ff d0                	call   *%eax
  80123b:	83 c4 10             	add    $0x10,%esp
			break;
  80123e:	e9 bc 00 00 00       	jmp    8012ff <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801243:	83 ec 08             	sub    $0x8,%esp
  801246:	ff 75 0c             	pushl  0xc(%ebp)
  801249:	6a 30                	push   $0x30
  80124b:	8b 45 08             	mov    0x8(%ebp),%eax
  80124e:	ff d0                	call   *%eax
  801250:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801253:	83 ec 08             	sub    $0x8,%esp
  801256:	ff 75 0c             	pushl  0xc(%ebp)
  801259:	6a 78                	push   $0x78
  80125b:	8b 45 08             	mov    0x8(%ebp),%eax
  80125e:	ff d0                	call   *%eax
  801260:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801263:	8b 45 14             	mov    0x14(%ebp),%eax
  801266:	83 c0 04             	add    $0x4,%eax
  801269:	89 45 14             	mov    %eax,0x14(%ebp)
  80126c:	8b 45 14             	mov    0x14(%ebp),%eax
  80126f:	83 e8 04             	sub    $0x4,%eax
  801272:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801274:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801277:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80127e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801285:	eb 1f                	jmp    8012a6 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801287:	83 ec 08             	sub    $0x8,%esp
  80128a:	ff 75 e8             	pushl  -0x18(%ebp)
  80128d:	8d 45 14             	lea    0x14(%ebp),%eax
  801290:	50                   	push   %eax
  801291:	e8 e7 fb ff ff       	call   800e7d <getuint>
  801296:	83 c4 10             	add    $0x10,%esp
  801299:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80129c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80129f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8012a6:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8012aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8012ad:	83 ec 04             	sub    $0x4,%esp
  8012b0:	52                   	push   %edx
  8012b1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012b4:	50                   	push   %eax
  8012b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8012b8:	ff 75 f0             	pushl  -0x10(%ebp)
  8012bb:	ff 75 0c             	pushl  0xc(%ebp)
  8012be:	ff 75 08             	pushl  0x8(%ebp)
  8012c1:	e8 00 fb ff ff       	call   800dc6 <printnum>
  8012c6:	83 c4 20             	add    $0x20,%esp
			break;
  8012c9:	eb 34                	jmp    8012ff <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8012cb:	83 ec 08             	sub    $0x8,%esp
  8012ce:	ff 75 0c             	pushl  0xc(%ebp)
  8012d1:	53                   	push   %ebx
  8012d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d5:	ff d0                	call   *%eax
  8012d7:	83 c4 10             	add    $0x10,%esp
			break;
  8012da:	eb 23                	jmp    8012ff <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8012dc:	83 ec 08             	sub    $0x8,%esp
  8012df:	ff 75 0c             	pushl  0xc(%ebp)
  8012e2:	6a 25                	push   $0x25
  8012e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e7:	ff d0                	call   *%eax
  8012e9:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8012ec:	ff 4d 10             	decl   0x10(%ebp)
  8012ef:	eb 03                	jmp    8012f4 <vprintfmt+0x3b1>
  8012f1:	ff 4d 10             	decl   0x10(%ebp)
  8012f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f7:	48                   	dec    %eax
  8012f8:	8a 00                	mov    (%eax),%al
  8012fa:	3c 25                	cmp    $0x25,%al
  8012fc:	75 f3                	jne    8012f1 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8012fe:	90                   	nop
		}
	}
  8012ff:	e9 47 fc ff ff       	jmp    800f4b <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801304:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801305:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801308:	5b                   	pop    %ebx
  801309:	5e                   	pop    %esi
  80130a:	5d                   	pop    %ebp
  80130b:	c3                   	ret    

0080130c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80130c:	55                   	push   %ebp
  80130d:	89 e5                	mov    %esp,%ebp
  80130f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801312:	8d 45 10             	lea    0x10(%ebp),%eax
  801315:	83 c0 04             	add    $0x4,%eax
  801318:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80131b:	8b 45 10             	mov    0x10(%ebp),%eax
  80131e:	ff 75 f4             	pushl  -0xc(%ebp)
  801321:	50                   	push   %eax
  801322:	ff 75 0c             	pushl  0xc(%ebp)
  801325:	ff 75 08             	pushl  0x8(%ebp)
  801328:	e8 16 fc ff ff       	call   800f43 <vprintfmt>
  80132d:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801330:	90                   	nop
  801331:	c9                   	leave  
  801332:	c3                   	ret    

00801333 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801333:	55                   	push   %ebp
  801334:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801336:	8b 45 0c             	mov    0xc(%ebp),%eax
  801339:	8b 40 08             	mov    0x8(%eax),%eax
  80133c:	8d 50 01             	lea    0x1(%eax),%edx
  80133f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801342:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801345:	8b 45 0c             	mov    0xc(%ebp),%eax
  801348:	8b 10                	mov    (%eax),%edx
  80134a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134d:	8b 40 04             	mov    0x4(%eax),%eax
  801350:	39 c2                	cmp    %eax,%edx
  801352:	73 12                	jae    801366 <sprintputch+0x33>
		*b->buf++ = ch;
  801354:	8b 45 0c             	mov    0xc(%ebp),%eax
  801357:	8b 00                	mov    (%eax),%eax
  801359:	8d 48 01             	lea    0x1(%eax),%ecx
  80135c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80135f:	89 0a                	mov    %ecx,(%edx)
  801361:	8b 55 08             	mov    0x8(%ebp),%edx
  801364:	88 10                	mov    %dl,(%eax)
}
  801366:	90                   	nop
  801367:	5d                   	pop    %ebp
  801368:	c3                   	ret    

00801369 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801369:	55                   	push   %ebp
  80136a:	89 e5                	mov    %esp,%ebp
  80136c:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80136f:	8b 45 08             	mov    0x8(%ebp),%eax
  801372:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801375:	8b 45 0c             	mov    0xc(%ebp),%eax
  801378:	8d 50 ff             	lea    -0x1(%eax),%edx
  80137b:	8b 45 08             	mov    0x8(%ebp),%eax
  80137e:	01 d0                	add    %edx,%eax
  801380:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801383:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80138a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80138e:	74 06                	je     801396 <vsnprintf+0x2d>
  801390:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801394:	7f 07                	jg     80139d <vsnprintf+0x34>
		return -E_INVAL;
  801396:	b8 03 00 00 00       	mov    $0x3,%eax
  80139b:	eb 20                	jmp    8013bd <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80139d:	ff 75 14             	pushl  0x14(%ebp)
  8013a0:	ff 75 10             	pushl  0x10(%ebp)
  8013a3:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8013a6:	50                   	push   %eax
  8013a7:	68 33 13 80 00       	push   $0x801333
  8013ac:	e8 92 fb ff ff       	call   800f43 <vprintfmt>
  8013b1:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8013b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013b7:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8013ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8013bd:	c9                   	leave  
  8013be:	c3                   	ret    

008013bf <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8013bf:	55                   	push   %ebp
  8013c0:	89 e5                	mov    %esp,%ebp
  8013c2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8013c5:	8d 45 10             	lea    0x10(%ebp),%eax
  8013c8:	83 c0 04             	add    $0x4,%eax
  8013cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8013ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8013d1:	ff 75 f4             	pushl  -0xc(%ebp)
  8013d4:	50                   	push   %eax
  8013d5:	ff 75 0c             	pushl  0xc(%ebp)
  8013d8:	ff 75 08             	pushl  0x8(%ebp)
  8013db:	e8 89 ff ff ff       	call   801369 <vsnprintf>
  8013e0:	83 c4 10             	add    $0x10,%esp
  8013e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8013e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8013e9:	c9                   	leave  
  8013ea:	c3                   	ret    

008013eb <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8013eb:	55                   	push   %ebp
  8013ec:	89 e5                	mov    %esp,%ebp
  8013ee:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8013f1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013f8:	eb 06                	jmp    801400 <strlen+0x15>
		n++;
  8013fa:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8013fd:	ff 45 08             	incl   0x8(%ebp)
  801400:	8b 45 08             	mov    0x8(%ebp),%eax
  801403:	8a 00                	mov    (%eax),%al
  801405:	84 c0                	test   %al,%al
  801407:	75 f1                	jne    8013fa <strlen+0xf>
		n++;
	return n;
  801409:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80140c:	c9                   	leave  
  80140d:	c3                   	ret    

0080140e <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80140e:	55                   	push   %ebp
  80140f:	89 e5                	mov    %esp,%ebp
  801411:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801414:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80141b:	eb 09                	jmp    801426 <strnlen+0x18>
		n++;
  80141d:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801420:	ff 45 08             	incl   0x8(%ebp)
  801423:	ff 4d 0c             	decl   0xc(%ebp)
  801426:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80142a:	74 09                	je     801435 <strnlen+0x27>
  80142c:	8b 45 08             	mov    0x8(%ebp),%eax
  80142f:	8a 00                	mov    (%eax),%al
  801431:	84 c0                	test   %al,%al
  801433:	75 e8                	jne    80141d <strnlen+0xf>
		n++;
	return n;
  801435:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801438:	c9                   	leave  
  801439:	c3                   	ret    

0080143a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80143a:	55                   	push   %ebp
  80143b:	89 e5                	mov    %esp,%ebp
  80143d:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801440:	8b 45 08             	mov    0x8(%ebp),%eax
  801443:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801446:	90                   	nop
  801447:	8b 45 08             	mov    0x8(%ebp),%eax
  80144a:	8d 50 01             	lea    0x1(%eax),%edx
  80144d:	89 55 08             	mov    %edx,0x8(%ebp)
  801450:	8b 55 0c             	mov    0xc(%ebp),%edx
  801453:	8d 4a 01             	lea    0x1(%edx),%ecx
  801456:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801459:	8a 12                	mov    (%edx),%dl
  80145b:	88 10                	mov    %dl,(%eax)
  80145d:	8a 00                	mov    (%eax),%al
  80145f:	84 c0                	test   %al,%al
  801461:	75 e4                	jne    801447 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801463:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801466:	c9                   	leave  
  801467:	c3                   	ret    

00801468 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801468:	55                   	push   %ebp
  801469:	89 e5                	mov    %esp,%ebp
  80146b:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80146e:	8b 45 08             	mov    0x8(%ebp),%eax
  801471:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801474:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80147b:	eb 1f                	jmp    80149c <strncpy+0x34>
		*dst++ = *src;
  80147d:	8b 45 08             	mov    0x8(%ebp),%eax
  801480:	8d 50 01             	lea    0x1(%eax),%edx
  801483:	89 55 08             	mov    %edx,0x8(%ebp)
  801486:	8b 55 0c             	mov    0xc(%ebp),%edx
  801489:	8a 12                	mov    (%edx),%dl
  80148b:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80148d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801490:	8a 00                	mov    (%eax),%al
  801492:	84 c0                	test   %al,%al
  801494:	74 03                	je     801499 <strncpy+0x31>
			src++;
  801496:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801499:	ff 45 fc             	incl   -0x4(%ebp)
  80149c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80149f:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014a2:	72 d9                	jb     80147d <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8014a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014a7:	c9                   	leave  
  8014a8:	c3                   	ret    

008014a9 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8014a9:	55                   	push   %ebp
  8014aa:	89 e5                	mov    %esp,%ebp
  8014ac:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8014af:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8014b5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014b9:	74 30                	je     8014eb <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8014bb:	eb 16                	jmp    8014d3 <strlcpy+0x2a>
			*dst++ = *src++;
  8014bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c0:	8d 50 01             	lea    0x1(%eax),%edx
  8014c3:	89 55 08             	mov    %edx,0x8(%ebp)
  8014c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014c9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014cc:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8014cf:	8a 12                	mov    (%edx),%dl
  8014d1:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8014d3:	ff 4d 10             	decl   0x10(%ebp)
  8014d6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014da:	74 09                	je     8014e5 <strlcpy+0x3c>
  8014dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014df:	8a 00                	mov    (%eax),%al
  8014e1:	84 c0                	test   %al,%al
  8014e3:	75 d8                	jne    8014bd <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8014e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e8:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8014eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8014ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014f1:	29 c2                	sub    %eax,%edx
  8014f3:	89 d0                	mov    %edx,%eax
}
  8014f5:	c9                   	leave  
  8014f6:	c3                   	ret    

008014f7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8014f7:	55                   	push   %ebp
  8014f8:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8014fa:	eb 06                	jmp    801502 <strcmp+0xb>
		p++, q++;
  8014fc:	ff 45 08             	incl   0x8(%ebp)
  8014ff:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801502:	8b 45 08             	mov    0x8(%ebp),%eax
  801505:	8a 00                	mov    (%eax),%al
  801507:	84 c0                	test   %al,%al
  801509:	74 0e                	je     801519 <strcmp+0x22>
  80150b:	8b 45 08             	mov    0x8(%ebp),%eax
  80150e:	8a 10                	mov    (%eax),%dl
  801510:	8b 45 0c             	mov    0xc(%ebp),%eax
  801513:	8a 00                	mov    (%eax),%al
  801515:	38 c2                	cmp    %al,%dl
  801517:	74 e3                	je     8014fc <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801519:	8b 45 08             	mov    0x8(%ebp),%eax
  80151c:	8a 00                	mov    (%eax),%al
  80151e:	0f b6 d0             	movzbl %al,%edx
  801521:	8b 45 0c             	mov    0xc(%ebp),%eax
  801524:	8a 00                	mov    (%eax),%al
  801526:	0f b6 c0             	movzbl %al,%eax
  801529:	29 c2                	sub    %eax,%edx
  80152b:	89 d0                	mov    %edx,%eax
}
  80152d:	5d                   	pop    %ebp
  80152e:	c3                   	ret    

0080152f <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80152f:	55                   	push   %ebp
  801530:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801532:	eb 09                	jmp    80153d <strncmp+0xe>
		n--, p++, q++;
  801534:	ff 4d 10             	decl   0x10(%ebp)
  801537:	ff 45 08             	incl   0x8(%ebp)
  80153a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80153d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801541:	74 17                	je     80155a <strncmp+0x2b>
  801543:	8b 45 08             	mov    0x8(%ebp),%eax
  801546:	8a 00                	mov    (%eax),%al
  801548:	84 c0                	test   %al,%al
  80154a:	74 0e                	je     80155a <strncmp+0x2b>
  80154c:	8b 45 08             	mov    0x8(%ebp),%eax
  80154f:	8a 10                	mov    (%eax),%dl
  801551:	8b 45 0c             	mov    0xc(%ebp),%eax
  801554:	8a 00                	mov    (%eax),%al
  801556:	38 c2                	cmp    %al,%dl
  801558:	74 da                	je     801534 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80155a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80155e:	75 07                	jne    801567 <strncmp+0x38>
		return 0;
  801560:	b8 00 00 00 00       	mov    $0x0,%eax
  801565:	eb 14                	jmp    80157b <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801567:	8b 45 08             	mov    0x8(%ebp),%eax
  80156a:	8a 00                	mov    (%eax),%al
  80156c:	0f b6 d0             	movzbl %al,%edx
  80156f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801572:	8a 00                	mov    (%eax),%al
  801574:	0f b6 c0             	movzbl %al,%eax
  801577:	29 c2                	sub    %eax,%edx
  801579:	89 d0                	mov    %edx,%eax
}
  80157b:	5d                   	pop    %ebp
  80157c:	c3                   	ret    

0080157d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80157d:	55                   	push   %ebp
  80157e:	89 e5                	mov    %esp,%ebp
  801580:	83 ec 04             	sub    $0x4,%esp
  801583:	8b 45 0c             	mov    0xc(%ebp),%eax
  801586:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801589:	eb 12                	jmp    80159d <strchr+0x20>
		if (*s == c)
  80158b:	8b 45 08             	mov    0x8(%ebp),%eax
  80158e:	8a 00                	mov    (%eax),%al
  801590:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801593:	75 05                	jne    80159a <strchr+0x1d>
			return (char *) s;
  801595:	8b 45 08             	mov    0x8(%ebp),%eax
  801598:	eb 11                	jmp    8015ab <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80159a:	ff 45 08             	incl   0x8(%ebp)
  80159d:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a0:	8a 00                	mov    (%eax),%al
  8015a2:	84 c0                	test   %al,%al
  8015a4:	75 e5                	jne    80158b <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8015a6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015ab:	c9                   	leave  
  8015ac:	c3                   	ret    

008015ad <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8015ad:	55                   	push   %ebp
  8015ae:	89 e5                	mov    %esp,%ebp
  8015b0:	83 ec 04             	sub    $0x4,%esp
  8015b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b6:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8015b9:	eb 0d                	jmp    8015c8 <strfind+0x1b>
		if (*s == c)
  8015bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015be:	8a 00                	mov    (%eax),%al
  8015c0:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8015c3:	74 0e                	je     8015d3 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8015c5:	ff 45 08             	incl   0x8(%ebp)
  8015c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cb:	8a 00                	mov    (%eax),%al
  8015cd:	84 c0                	test   %al,%al
  8015cf:	75 ea                	jne    8015bb <strfind+0xe>
  8015d1:	eb 01                	jmp    8015d4 <strfind+0x27>
		if (*s == c)
			break;
  8015d3:	90                   	nop
	return (char *) s;
  8015d4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015d7:	c9                   	leave  
  8015d8:	c3                   	ret    

008015d9 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8015d9:	55                   	push   %ebp
  8015da:	89 e5                	mov    %esp,%ebp
  8015dc:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8015df:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8015e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8015e8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8015eb:	eb 0e                	jmp    8015fb <memset+0x22>
		*p++ = c;
  8015ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015f0:	8d 50 01             	lea    0x1(%eax),%edx
  8015f3:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8015f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015f9:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8015fb:	ff 4d f8             	decl   -0x8(%ebp)
  8015fe:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801602:	79 e9                	jns    8015ed <memset+0x14>
		*p++ = c;

	return v;
  801604:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801607:	c9                   	leave  
  801608:	c3                   	ret    

00801609 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801609:	55                   	push   %ebp
  80160a:	89 e5                	mov    %esp,%ebp
  80160c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80160f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801612:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801615:	8b 45 08             	mov    0x8(%ebp),%eax
  801618:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80161b:	eb 16                	jmp    801633 <memcpy+0x2a>
		*d++ = *s++;
  80161d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801620:	8d 50 01             	lea    0x1(%eax),%edx
  801623:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801626:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801629:	8d 4a 01             	lea    0x1(%edx),%ecx
  80162c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80162f:	8a 12                	mov    (%edx),%dl
  801631:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801633:	8b 45 10             	mov    0x10(%ebp),%eax
  801636:	8d 50 ff             	lea    -0x1(%eax),%edx
  801639:	89 55 10             	mov    %edx,0x10(%ebp)
  80163c:	85 c0                	test   %eax,%eax
  80163e:	75 dd                	jne    80161d <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801640:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801643:	c9                   	leave  
  801644:	c3                   	ret    

00801645 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801645:	55                   	push   %ebp
  801646:	89 e5                	mov    %esp,%ebp
  801648:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80164b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80164e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801651:	8b 45 08             	mov    0x8(%ebp),%eax
  801654:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801657:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80165a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80165d:	73 50                	jae    8016af <memmove+0x6a>
  80165f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801662:	8b 45 10             	mov    0x10(%ebp),%eax
  801665:	01 d0                	add    %edx,%eax
  801667:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80166a:	76 43                	jbe    8016af <memmove+0x6a>
		s += n;
  80166c:	8b 45 10             	mov    0x10(%ebp),%eax
  80166f:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801672:	8b 45 10             	mov    0x10(%ebp),%eax
  801675:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801678:	eb 10                	jmp    80168a <memmove+0x45>
			*--d = *--s;
  80167a:	ff 4d f8             	decl   -0x8(%ebp)
  80167d:	ff 4d fc             	decl   -0x4(%ebp)
  801680:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801683:	8a 10                	mov    (%eax),%dl
  801685:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801688:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80168a:	8b 45 10             	mov    0x10(%ebp),%eax
  80168d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801690:	89 55 10             	mov    %edx,0x10(%ebp)
  801693:	85 c0                	test   %eax,%eax
  801695:	75 e3                	jne    80167a <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801697:	eb 23                	jmp    8016bc <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801699:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80169c:	8d 50 01             	lea    0x1(%eax),%edx
  80169f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8016a2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016a5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016a8:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8016ab:	8a 12                	mov    (%edx),%dl
  8016ad:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8016af:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016b5:	89 55 10             	mov    %edx,0x10(%ebp)
  8016b8:	85 c0                	test   %eax,%eax
  8016ba:	75 dd                	jne    801699 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8016bc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016bf:	c9                   	leave  
  8016c0:	c3                   	ret    

008016c1 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8016c1:	55                   	push   %ebp
  8016c2:	89 e5                	mov    %esp,%ebp
  8016c4:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8016c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8016cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016d0:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8016d3:	eb 2a                	jmp    8016ff <memcmp+0x3e>
		if (*s1 != *s2)
  8016d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016d8:	8a 10                	mov    (%eax),%dl
  8016da:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016dd:	8a 00                	mov    (%eax),%al
  8016df:	38 c2                	cmp    %al,%dl
  8016e1:	74 16                	je     8016f9 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8016e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016e6:	8a 00                	mov    (%eax),%al
  8016e8:	0f b6 d0             	movzbl %al,%edx
  8016eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016ee:	8a 00                	mov    (%eax),%al
  8016f0:	0f b6 c0             	movzbl %al,%eax
  8016f3:	29 c2                	sub    %eax,%edx
  8016f5:	89 d0                	mov    %edx,%eax
  8016f7:	eb 18                	jmp    801711 <memcmp+0x50>
		s1++, s2++;
  8016f9:	ff 45 fc             	incl   -0x4(%ebp)
  8016fc:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8016ff:	8b 45 10             	mov    0x10(%ebp),%eax
  801702:	8d 50 ff             	lea    -0x1(%eax),%edx
  801705:	89 55 10             	mov    %edx,0x10(%ebp)
  801708:	85 c0                	test   %eax,%eax
  80170a:	75 c9                	jne    8016d5 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80170c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801711:	c9                   	leave  
  801712:	c3                   	ret    

00801713 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801713:	55                   	push   %ebp
  801714:	89 e5                	mov    %esp,%ebp
  801716:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801719:	8b 55 08             	mov    0x8(%ebp),%edx
  80171c:	8b 45 10             	mov    0x10(%ebp),%eax
  80171f:	01 d0                	add    %edx,%eax
  801721:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801724:	eb 15                	jmp    80173b <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801726:	8b 45 08             	mov    0x8(%ebp),%eax
  801729:	8a 00                	mov    (%eax),%al
  80172b:	0f b6 d0             	movzbl %al,%edx
  80172e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801731:	0f b6 c0             	movzbl %al,%eax
  801734:	39 c2                	cmp    %eax,%edx
  801736:	74 0d                	je     801745 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801738:	ff 45 08             	incl   0x8(%ebp)
  80173b:	8b 45 08             	mov    0x8(%ebp),%eax
  80173e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801741:	72 e3                	jb     801726 <memfind+0x13>
  801743:	eb 01                	jmp    801746 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801745:	90                   	nop
	return (void *) s;
  801746:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801749:	c9                   	leave  
  80174a:	c3                   	ret    

0080174b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80174b:	55                   	push   %ebp
  80174c:	89 e5                	mov    %esp,%ebp
  80174e:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801751:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801758:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80175f:	eb 03                	jmp    801764 <strtol+0x19>
		s++;
  801761:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801764:	8b 45 08             	mov    0x8(%ebp),%eax
  801767:	8a 00                	mov    (%eax),%al
  801769:	3c 20                	cmp    $0x20,%al
  80176b:	74 f4                	je     801761 <strtol+0x16>
  80176d:	8b 45 08             	mov    0x8(%ebp),%eax
  801770:	8a 00                	mov    (%eax),%al
  801772:	3c 09                	cmp    $0x9,%al
  801774:	74 eb                	je     801761 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801776:	8b 45 08             	mov    0x8(%ebp),%eax
  801779:	8a 00                	mov    (%eax),%al
  80177b:	3c 2b                	cmp    $0x2b,%al
  80177d:	75 05                	jne    801784 <strtol+0x39>
		s++;
  80177f:	ff 45 08             	incl   0x8(%ebp)
  801782:	eb 13                	jmp    801797 <strtol+0x4c>
	else if (*s == '-')
  801784:	8b 45 08             	mov    0x8(%ebp),%eax
  801787:	8a 00                	mov    (%eax),%al
  801789:	3c 2d                	cmp    $0x2d,%al
  80178b:	75 0a                	jne    801797 <strtol+0x4c>
		s++, neg = 1;
  80178d:	ff 45 08             	incl   0x8(%ebp)
  801790:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801797:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80179b:	74 06                	je     8017a3 <strtol+0x58>
  80179d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8017a1:	75 20                	jne    8017c3 <strtol+0x78>
  8017a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a6:	8a 00                	mov    (%eax),%al
  8017a8:	3c 30                	cmp    $0x30,%al
  8017aa:	75 17                	jne    8017c3 <strtol+0x78>
  8017ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8017af:	40                   	inc    %eax
  8017b0:	8a 00                	mov    (%eax),%al
  8017b2:	3c 78                	cmp    $0x78,%al
  8017b4:	75 0d                	jne    8017c3 <strtol+0x78>
		s += 2, base = 16;
  8017b6:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8017ba:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8017c1:	eb 28                	jmp    8017eb <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8017c3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017c7:	75 15                	jne    8017de <strtol+0x93>
  8017c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cc:	8a 00                	mov    (%eax),%al
  8017ce:	3c 30                	cmp    $0x30,%al
  8017d0:	75 0c                	jne    8017de <strtol+0x93>
		s++, base = 8;
  8017d2:	ff 45 08             	incl   0x8(%ebp)
  8017d5:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8017dc:	eb 0d                	jmp    8017eb <strtol+0xa0>
	else if (base == 0)
  8017de:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017e2:	75 07                	jne    8017eb <strtol+0xa0>
		base = 10;
  8017e4:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8017eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ee:	8a 00                	mov    (%eax),%al
  8017f0:	3c 2f                	cmp    $0x2f,%al
  8017f2:	7e 19                	jle    80180d <strtol+0xc2>
  8017f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f7:	8a 00                	mov    (%eax),%al
  8017f9:	3c 39                	cmp    $0x39,%al
  8017fb:	7f 10                	jg     80180d <strtol+0xc2>
			dig = *s - '0';
  8017fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801800:	8a 00                	mov    (%eax),%al
  801802:	0f be c0             	movsbl %al,%eax
  801805:	83 e8 30             	sub    $0x30,%eax
  801808:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80180b:	eb 42                	jmp    80184f <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80180d:	8b 45 08             	mov    0x8(%ebp),%eax
  801810:	8a 00                	mov    (%eax),%al
  801812:	3c 60                	cmp    $0x60,%al
  801814:	7e 19                	jle    80182f <strtol+0xe4>
  801816:	8b 45 08             	mov    0x8(%ebp),%eax
  801819:	8a 00                	mov    (%eax),%al
  80181b:	3c 7a                	cmp    $0x7a,%al
  80181d:	7f 10                	jg     80182f <strtol+0xe4>
			dig = *s - 'a' + 10;
  80181f:	8b 45 08             	mov    0x8(%ebp),%eax
  801822:	8a 00                	mov    (%eax),%al
  801824:	0f be c0             	movsbl %al,%eax
  801827:	83 e8 57             	sub    $0x57,%eax
  80182a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80182d:	eb 20                	jmp    80184f <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80182f:	8b 45 08             	mov    0x8(%ebp),%eax
  801832:	8a 00                	mov    (%eax),%al
  801834:	3c 40                	cmp    $0x40,%al
  801836:	7e 39                	jle    801871 <strtol+0x126>
  801838:	8b 45 08             	mov    0x8(%ebp),%eax
  80183b:	8a 00                	mov    (%eax),%al
  80183d:	3c 5a                	cmp    $0x5a,%al
  80183f:	7f 30                	jg     801871 <strtol+0x126>
			dig = *s - 'A' + 10;
  801841:	8b 45 08             	mov    0x8(%ebp),%eax
  801844:	8a 00                	mov    (%eax),%al
  801846:	0f be c0             	movsbl %al,%eax
  801849:	83 e8 37             	sub    $0x37,%eax
  80184c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80184f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801852:	3b 45 10             	cmp    0x10(%ebp),%eax
  801855:	7d 19                	jge    801870 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801857:	ff 45 08             	incl   0x8(%ebp)
  80185a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80185d:	0f af 45 10          	imul   0x10(%ebp),%eax
  801861:	89 c2                	mov    %eax,%edx
  801863:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801866:	01 d0                	add    %edx,%eax
  801868:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80186b:	e9 7b ff ff ff       	jmp    8017eb <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801870:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801871:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801875:	74 08                	je     80187f <strtol+0x134>
		*endptr = (char *) s;
  801877:	8b 45 0c             	mov    0xc(%ebp),%eax
  80187a:	8b 55 08             	mov    0x8(%ebp),%edx
  80187d:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80187f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801883:	74 07                	je     80188c <strtol+0x141>
  801885:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801888:	f7 d8                	neg    %eax
  80188a:	eb 03                	jmp    80188f <strtol+0x144>
  80188c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80188f:	c9                   	leave  
  801890:	c3                   	ret    

00801891 <ltostr>:

void
ltostr(long value, char *str)
{
  801891:	55                   	push   %ebp
  801892:	89 e5                	mov    %esp,%ebp
  801894:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801897:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80189e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8018a5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018a9:	79 13                	jns    8018be <ltostr+0x2d>
	{
		neg = 1;
  8018ab:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8018b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018b5:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8018b8:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8018bb:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8018be:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c1:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8018c6:	99                   	cltd   
  8018c7:	f7 f9                	idiv   %ecx
  8018c9:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8018cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018cf:	8d 50 01             	lea    0x1(%eax),%edx
  8018d2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8018d5:	89 c2                	mov    %eax,%edx
  8018d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018da:	01 d0                	add    %edx,%eax
  8018dc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018df:	83 c2 30             	add    $0x30,%edx
  8018e2:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8018e4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018e7:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8018ec:	f7 e9                	imul   %ecx
  8018ee:	c1 fa 02             	sar    $0x2,%edx
  8018f1:	89 c8                	mov    %ecx,%eax
  8018f3:	c1 f8 1f             	sar    $0x1f,%eax
  8018f6:	29 c2                	sub    %eax,%edx
  8018f8:	89 d0                	mov    %edx,%eax
  8018fa:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8018fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801900:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801905:	f7 e9                	imul   %ecx
  801907:	c1 fa 02             	sar    $0x2,%edx
  80190a:	89 c8                	mov    %ecx,%eax
  80190c:	c1 f8 1f             	sar    $0x1f,%eax
  80190f:	29 c2                	sub    %eax,%edx
  801911:	89 d0                	mov    %edx,%eax
  801913:	c1 e0 02             	shl    $0x2,%eax
  801916:	01 d0                	add    %edx,%eax
  801918:	01 c0                	add    %eax,%eax
  80191a:	29 c1                	sub    %eax,%ecx
  80191c:	89 ca                	mov    %ecx,%edx
  80191e:	85 d2                	test   %edx,%edx
  801920:	75 9c                	jne    8018be <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801922:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801929:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80192c:	48                   	dec    %eax
  80192d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801930:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801934:	74 3d                	je     801973 <ltostr+0xe2>
		start = 1 ;
  801936:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80193d:	eb 34                	jmp    801973 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80193f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801942:	8b 45 0c             	mov    0xc(%ebp),%eax
  801945:	01 d0                	add    %edx,%eax
  801947:	8a 00                	mov    (%eax),%al
  801949:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80194c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80194f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801952:	01 c2                	add    %eax,%edx
  801954:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801957:	8b 45 0c             	mov    0xc(%ebp),%eax
  80195a:	01 c8                	add    %ecx,%eax
  80195c:	8a 00                	mov    (%eax),%al
  80195e:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801960:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801963:	8b 45 0c             	mov    0xc(%ebp),%eax
  801966:	01 c2                	add    %eax,%edx
  801968:	8a 45 eb             	mov    -0x15(%ebp),%al
  80196b:	88 02                	mov    %al,(%edx)
		start++ ;
  80196d:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801970:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801973:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801976:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801979:	7c c4                	jl     80193f <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80197b:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80197e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801981:	01 d0                	add    %edx,%eax
  801983:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801986:	90                   	nop
  801987:	c9                   	leave  
  801988:	c3                   	ret    

00801989 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801989:	55                   	push   %ebp
  80198a:	89 e5                	mov    %esp,%ebp
  80198c:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80198f:	ff 75 08             	pushl  0x8(%ebp)
  801992:	e8 54 fa ff ff       	call   8013eb <strlen>
  801997:	83 c4 04             	add    $0x4,%esp
  80199a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80199d:	ff 75 0c             	pushl  0xc(%ebp)
  8019a0:	e8 46 fa ff ff       	call   8013eb <strlen>
  8019a5:	83 c4 04             	add    $0x4,%esp
  8019a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8019ab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8019b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8019b9:	eb 17                	jmp    8019d2 <strcconcat+0x49>
		final[s] = str1[s] ;
  8019bb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019be:	8b 45 10             	mov    0x10(%ebp),%eax
  8019c1:	01 c2                	add    %eax,%edx
  8019c3:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8019c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c9:	01 c8                	add    %ecx,%eax
  8019cb:	8a 00                	mov    (%eax),%al
  8019cd:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8019cf:	ff 45 fc             	incl   -0x4(%ebp)
  8019d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019d5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8019d8:	7c e1                	jl     8019bb <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8019da:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8019e1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8019e8:	eb 1f                	jmp    801a09 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8019ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019ed:	8d 50 01             	lea    0x1(%eax),%edx
  8019f0:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8019f3:	89 c2                	mov    %eax,%edx
  8019f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8019f8:	01 c2                	add    %eax,%edx
  8019fa:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8019fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a00:	01 c8                	add    %ecx,%eax
  801a02:	8a 00                	mov    (%eax),%al
  801a04:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801a06:	ff 45 f8             	incl   -0x8(%ebp)
  801a09:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a0c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a0f:	7c d9                	jl     8019ea <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801a11:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a14:	8b 45 10             	mov    0x10(%ebp),%eax
  801a17:	01 d0                	add    %edx,%eax
  801a19:	c6 00 00             	movb   $0x0,(%eax)
}
  801a1c:	90                   	nop
  801a1d:	c9                   	leave  
  801a1e:	c3                   	ret    

00801a1f <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801a1f:	55                   	push   %ebp
  801a20:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801a22:	8b 45 14             	mov    0x14(%ebp),%eax
  801a25:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801a2b:	8b 45 14             	mov    0x14(%ebp),%eax
  801a2e:	8b 00                	mov    (%eax),%eax
  801a30:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a37:	8b 45 10             	mov    0x10(%ebp),%eax
  801a3a:	01 d0                	add    %edx,%eax
  801a3c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a42:	eb 0c                	jmp    801a50 <strsplit+0x31>
			*string++ = 0;
  801a44:	8b 45 08             	mov    0x8(%ebp),%eax
  801a47:	8d 50 01             	lea    0x1(%eax),%edx
  801a4a:	89 55 08             	mov    %edx,0x8(%ebp)
  801a4d:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a50:	8b 45 08             	mov    0x8(%ebp),%eax
  801a53:	8a 00                	mov    (%eax),%al
  801a55:	84 c0                	test   %al,%al
  801a57:	74 18                	je     801a71 <strsplit+0x52>
  801a59:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5c:	8a 00                	mov    (%eax),%al
  801a5e:	0f be c0             	movsbl %al,%eax
  801a61:	50                   	push   %eax
  801a62:	ff 75 0c             	pushl  0xc(%ebp)
  801a65:	e8 13 fb ff ff       	call   80157d <strchr>
  801a6a:	83 c4 08             	add    $0x8,%esp
  801a6d:	85 c0                	test   %eax,%eax
  801a6f:	75 d3                	jne    801a44 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801a71:	8b 45 08             	mov    0x8(%ebp),%eax
  801a74:	8a 00                	mov    (%eax),%al
  801a76:	84 c0                	test   %al,%al
  801a78:	74 5a                	je     801ad4 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801a7a:	8b 45 14             	mov    0x14(%ebp),%eax
  801a7d:	8b 00                	mov    (%eax),%eax
  801a7f:	83 f8 0f             	cmp    $0xf,%eax
  801a82:	75 07                	jne    801a8b <strsplit+0x6c>
		{
			return 0;
  801a84:	b8 00 00 00 00       	mov    $0x0,%eax
  801a89:	eb 66                	jmp    801af1 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801a8b:	8b 45 14             	mov    0x14(%ebp),%eax
  801a8e:	8b 00                	mov    (%eax),%eax
  801a90:	8d 48 01             	lea    0x1(%eax),%ecx
  801a93:	8b 55 14             	mov    0x14(%ebp),%edx
  801a96:	89 0a                	mov    %ecx,(%edx)
  801a98:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a9f:	8b 45 10             	mov    0x10(%ebp),%eax
  801aa2:	01 c2                	add    %eax,%edx
  801aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa7:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801aa9:	eb 03                	jmp    801aae <strsplit+0x8f>
			string++;
  801aab:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801aae:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab1:	8a 00                	mov    (%eax),%al
  801ab3:	84 c0                	test   %al,%al
  801ab5:	74 8b                	je     801a42 <strsplit+0x23>
  801ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aba:	8a 00                	mov    (%eax),%al
  801abc:	0f be c0             	movsbl %al,%eax
  801abf:	50                   	push   %eax
  801ac0:	ff 75 0c             	pushl  0xc(%ebp)
  801ac3:	e8 b5 fa ff ff       	call   80157d <strchr>
  801ac8:	83 c4 08             	add    $0x8,%esp
  801acb:	85 c0                	test   %eax,%eax
  801acd:	74 dc                	je     801aab <strsplit+0x8c>
			string++;
	}
  801acf:	e9 6e ff ff ff       	jmp    801a42 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801ad4:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801ad5:	8b 45 14             	mov    0x14(%ebp),%eax
  801ad8:	8b 00                	mov    (%eax),%eax
  801ada:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ae1:	8b 45 10             	mov    0x10(%ebp),%eax
  801ae4:	01 d0                	add    %edx,%eax
  801ae6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801aec:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801af1:	c9                   	leave  
  801af2:	c3                   	ret    

00801af3 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801af3:	55                   	push   %ebp
  801af4:	89 e5                	mov    %esp,%ebp
  801af6:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801af9:	a1 04 50 80 00       	mov    0x805004,%eax
  801afe:	85 c0                	test   %eax,%eax
  801b00:	74 1f                	je     801b21 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801b02:	e8 1d 00 00 00       	call   801b24 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801b07:	83 ec 0c             	sub    $0xc,%esp
  801b0a:	68 90 41 80 00       	push   $0x804190
  801b0f:	e8 55 f2 ff ff       	call   800d69 <cprintf>
  801b14:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801b17:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801b1e:	00 00 00 
	}
}
  801b21:	90                   	nop
  801b22:	c9                   	leave  
  801b23:	c3                   	ret    

00801b24 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801b24:	55                   	push   %ebp
  801b25:	89 e5                	mov    %esp,%ebp
  801b27:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  801b2a:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801b31:	00 00 00 
  801b34:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801b3b:	00 00 00 
  801b3e:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801b45:	00 00 00 
		LIST_INIT(&AllocMemBlocksList);
  801b48:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801b4f:	00 00 00 
  801b52:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801b59:	00 00 00 
  801b5c:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801b63:	00 00 00 

		MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES ;
  801b66:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801b6d:	00 02 00 
		MemBlockNodes =(struct MemBlock*)USER_DYN_BLKS_ARRAY ;
  801b70:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801b77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b7a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b7f:	2d 00 10 00 00       	sub    $0x1000,%eax
  801b84:	a3 50 50 80 00       	mov    %eax,0x805050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock),PAGE_SIZE),PERM_USER|PERM_WRITEABLE);
  801b89:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801b90:	a1 20 51 80 00       	mov    0x805120,%eax
  801b95:	c1 e0 04             	shl    $0x4,%eax
  801b98:	89 c2                	mov    %eax,%edx
  801b9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b9d:	01 d0                	add    %edx,%eax
  801b9f:	48                   	dec    %eax
  801ba0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801ba3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ba6:	ba 00 00 00 00       	mov    $0x0,%edx
  801bab:	f7 75 f0             	divl   -0x10(%ebp)
  801bae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bb1:	29 d0                	sub    %edx,%eax
  801bb3:	89 c2                	mov    %eax,%edx
  801bb5:	c7 45 e8 00 00 e0 7f 	movl   $0x7fe00000,-0x18(%ebp)
  801bbc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801bbf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801bc4:	2d 00 10 00 00       	sub    $0x1000,%eax
  801bc9:	83 ec 04             	sub    $0x4,%esp
  801bcc:	6a 06                	push   $0x6
  801bce:	52                   	push   %edx
  801bcf:	50                   	push   %eax
  801bd0:	e8 71 05 00 00       	call   802146 <sys_allocate_chunk>
  801bd5:	83 c4 10             	add    $0x10,%esp
		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801bd8:	a1 20 51 80 00       	mov    0x805120,%eax
  801bdd:	83 ec 0c             	sub    $0xc,%esp
  801be0:	50                   	push   %eax
  801be1:	e8 e6 0b 00 00       	call   8027cc <initialize_MemBlocksList>
  801be6:	83 c4 10             	add    $0x10,%esp

		struct MemBlock  *block_node;
		block_node = AvailableMemBlocksList.lh_first;
  801be9:	a1 48 51 80 00       	mov    0x805148,%eax
  801bee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&(AvailableMemBlocksList),block_node);
  801bf1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801bf5:	75 14                	jne    801c0b <initialize_dyn_block_system+0xe7>
  801bf7:	83 ec 04             	sub    $0x4,%esp
  801bfa:	68 b5 41 80 00       	push   $0x8041b5
  801bff:	6a 2b                	push   $0x2b
  801c01:	68 d3 41 80 00       	push   $0x8041d3
  801c06:	e8 aa ee ff ff       	call   800ab5 <_panic>
  801c0b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c0e:	8b 00                	mov    (%eax),%eax
  801c10:	85 c0                	test   %eax,%eax
  801c12:	74 10                	je     801c24 <initialize_dyn_block_system+0x100>
  801c14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c17:	8b 00                	mov    (%eax),%eax
  801c19:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801c1c:	8b 52 04             	mov    0x4(%edx),%edx
  801c1f:	89 50 04             	mov    %edx,0x4(%eax)
  801c22:	eb 0b                	jmp    801c2f <initialize_dyn_block_system+0x10b>
  801c24:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c27:	8b 40 04             	mov    0x4(%eax),%eax
  801c2a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801c2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c32:	8b 40 04             	mov    0x4(%eax),%eax
  801c35:	85 c0                	test   %eax,%eax
  801c37:	74 0f                	je     801c48 <initialize_dyn_block_system+0x124>
  801c39:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c3c:	8b 40 04             	mov    0x4(%eax),%eax
  801c3f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801c42:	8b 12                	mov    (%edx),%edx
  801c44:	89 10                	mov    %edx,(%eax)
  801c46:	eb 0a                	jmp    801c52 <initialize_dyn_block_system+0x12e>
  801c48:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c4b:	8b 00                	mov    (%eax),%eax
  801c4d:	a3 48 51 80 00       	mov    %eax,0x805148
  801c52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c55:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801c5b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c5e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801c65:	a1 54 51 80 00       	mov    0x805154,%eax
  801c6a:	48                   	dec    %eax
  801c6b:	a3 54 51 80 00       	mov    %eax,0x805154
		block_node->sva = USER_HEAP_START ;
  801c70:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c73:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
		block_node->size = ((USER_HEAP_MAX - USER_HEAP_START));
  801c7a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c7d:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		insert_sorted_with_merge_freeList(block_node);
  801c84:	83 ec 0c             	sub    $0xc,%esp
  801c87:	ff 75 e4             	pushl  -0x1c(%ebp)
  801c8a:	e8 d2 13 00 00       	call   803061 <insert_sorted_with_merge_freeList>
  801c8f:	83 c4 10             	add    $0x10,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801c92:	90                   	nop
  801c93:	c9                   	leave  
  801c94:	c3                   	ret    

00801c95 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801c95:	55                   	push   %ebp
  801c96:	89 e5                	mov    %esp,%ebp
  801c98:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c9b:	e8 53 fe ff ff       	call   801af3 <InitializeUHeap>
	if (size == 0) return NULL ;
  801ca0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ca4:	75 07                	jne    801cad <malloc+0x18>
  801ca6:	b8 00 00 00 00       	mov    $0x0,%eax
  801cab:	eb 61                	jmp    801d0e <malloc+0x79>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	size= ROUNDUP(size,PAGE_SIZE);
  801cad:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801cb4:	8b 55 08             	mov    0x8(%ebp),%edx
  801cb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cba:	01 d0                	add    %edx,%eax
  801cbc:	48                   	dec    %eax
  801cbd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801cc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cc3:	ba 00 00 00 00       	mov    $0x0,%edx
  801cc8:	f7 75 f4             	divl   -0xc(%ebp)
  801ccb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cce:	29 d0                	sub    %edx,%eax
  801cd0:	89 45 08             	mov    %eax,0x8(%ebp)
	    			if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801cd3:	e8 3c 08 00 00       	call   802514 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801cd8:	85 c0                	test   %eax,%eax
  801cda:	74 2d                	je     801d09 <malloc+0x74>
	    			{
	    				struct MemBlock * ff_block = alloc_block_FF(size);
  801cdc:	83 ec 0c             	sub    $0xc,%esp
  801cdf:	ff 75 08             	pushl  0x8(%ebp)
  801ce2:	e8 3e 0f 00 00       	call   802c25 <alloc_block_FF>
  801ce7:	83 c4 10             	add    $0x10,%esp
  801cea:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    				if(ff_block!=NULL)
  801ced:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801cf1:	74 16                	je     801d09 <malloc+0x74>
	    				{

	    					insert_sorted_allocList(ff_block);
  801cf3:	83 ec 0c             	sub    $0xc,%esp
  801cf6:	ff 75 ec             	pushl  -0x14(%ebp)
  801cf9:	e8 48 0c 00 00       	call   802946 <insert_sorted_allocList>
  801cfe:	83 c4 10             	add    $0x10,%esp
	    					return (void*) ff_block->sva ;
  801d01:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d04:	8b 40 08             	mov    0x8(%eax),%eax
  801d07:	eb 05                	jmp    801d0e <malloc+0x79>

	    				}
	}
	    			return (void*) NULL ;
  801d09:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801d0e:	c9                   	leave  
  801d0f:	c3                   	ret    

00801d10 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801d10:	55                   	push   %ebp
  801d11:	89 e5                	mov    %esp,%ebp
  801d13:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock *elementForEach;
		virtual_address = ROUNDDOWN(virtual_address, PAGE_SIZE);
  801d16:	8b 45 08             	mov    0x8(%ebp),%eax
  801d19:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d1f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d24:	89 45 08             	mov    %eax,0x8(%ebp)
	//	if (is_mallocPages[indexindex((uint32) virtual_address)] == 1) {
		elementForEach = find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801d27:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2a:	83 ec 08             	sub    $0x8,%esp
  801d2d:	50                   	push   %eax
  801d2e:	68 40 50 80 00       	push   $0x805040
  801d33:	e8 71 0b 00 00       	call   8028a9 <find_block>
  801d38:	83 c4 10             	add    $0x10,%esp
  801d3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		sys_free_user_mem((uint32) virtual_address, elementForEach->size);
  801d3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d41:	8b 50 0c             	mov    0xc(%eax),%edx
  801d44:	8b 45 08             	mov    0x8(%ebp),%eax
  801d47:	83 ec 08             	sub    $0x8,%esp
  801d4a:	52                   	push   %edx
  801d4b:	50                   	push   %eax
  801d4c:	e8 bd 03 00 00       	call   80210e <sys_free_user_mem>
  801d51:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,elementForEach);
  801d54:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d58:	75 14                	jne    801d6e <free+0x5e>
  801d5a:	83 ec 04             	sub    $0x4,%esp
  801d5d:	68 b5 41 80 00       	push   $0x8041b5
  801d62:	6a 71                	push   $0x71
  801d64:	68 d3 41 80 00       	push   $0x8041d3
  801d69:	e8 47 ed ff ff       	call   800ab5 <_panic>
  801d6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d71:	8b 00                	mov    (%eax),%eax
  801d73:	85 c0                	test   %eax,%eax
  801d75:	74 10                	je     801d87 <free+0x77>
  801d77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d7a:	8b 00                	mov    (%eax),%eax
  801d7c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d7f:	8b 52 04             	mov    0x4(%edx),%edx
  801d82:	89 50 04             	mov    %edx,0x4(%eax)
  801d85:	eb 0b                	jmp    801d92 <free+0x82>
  801d87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d8a:	8b 40 04             	mov    0x4(%eax),%eax
  801d8d:	a3 44 50 80 00       	mov    %eax,0x805044
  801d92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d95:	8b 40 04             	mov    0x4(%eax),%eax
  801d98:	85 c0                	test   %eax,%eax
  801d9a:	74 0f                	je     801dab <free+0x9b>
  801d9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d9f:	8b 40 04             	mov    0x4(%eax),%eax
  801da2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801da5:	8b 12                	mov    (%edx),%edx
  801da7:	89 10                	mov    %edx,(%eax)
  801da9:	eb 0a                	jmp    801db5 <free+0xa5>
  801dab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dae:	8b 00                	mov    (%eax),%eax
  801db0:	a3 40 50 80 00       	mov    %eax,0x805040
  801db5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801db8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801dbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dc1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801dc8:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801dcd:	48                   	dec    %eax
  801dce:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(elementForEach);
  801dd3:	83 ec 0c             	sub    $0xc,%esp
  801dd6:	ff 75 f0             	pushl  -0x10(%ebp)
  801dd9:	e8 83 12 00 00       	call   803061 <insert_sorted_with_merge_freeList>
  801dde:	83 c4 10             	add    $0x10,%esp
	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801de1:	90                   	nop
  801de2:	c9                   	leave  
  801de3:	c3                   	ret    

00801de4 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801de4:	55                   	push   %ebp
  801de5:	89 e5                	mov    %esp,%ebp
  801de7:	83 ec 28             	sub    $0x28,%esp
  801dea:	8b 45 10             	mov    0x10(%ebp),%eax
  801ded:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801df0:	e8 fe fc ff ff       	call   801af3 <InitializeUHeap>
	if (size == 0) return NULL ;
  801df5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801df9:	75 0a                	jne    801e05 <smalloc+0x21>
  801dfb:	b8 00 00 00 00       	mov    $0x0,%eax
  801e00:	e9 86 00 00 00       	jmp    801e8b <smalloc+0xa7>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code

	size=ROUNDUP(size,PAGE_SIZE);
  801e05:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801e0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e12:	01 d0                	add    %edx,%eax
  801e14:	48                   	dec    %eax
  801e15:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e1b:	ba 00 00 00 00       	mov    $0x0,%edx
  801e20:	f7 75 f4             	divl   -0xc(%ebp)
  801e23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e26:	29 d0                	sub    %edx,%eax
  801e28:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801e2b:	e8 e4 06 00 00       	call   802514 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801e30:	85 c0                	test   %eax,%eax
  801e32:	74 52                	je     801e86 <smalloc+0xa2>
		{
		struct MemBlock * ff_block ;
		ff_block = alloc_block_FF(size);
  801e34:	83 ec 0c             	sub    $0xc,%esp
  801e37:	ff 75 0c             	pushl  0xc(%ebp)
  801e3a:	e8 e6 0d 00 00       	call   802c25 <alloc_block_FF>
  801e3f:	83 c4 10             	add    $0x10,%esp
  801e42:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(ff_block==NULL)
  801e45:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801e49:	75 07                	jne    801e52 <smalloc+0x6e>
			return NULL ;
  801e4b:	b8 00 00 00 00       	mov    $0x0,%eax
  801e50:	eb 39                	jmp    801e8b <smalloc+0xa7>

		int obj_id =sys_createSharedObject(sharedVarName,size,isWritable,(void*)ff_block->sva);
  801e52:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e55:	8b 40 08             	mov    0x8(%eax),%eax
  801e58:	89 c2                	mov    %eax,%edx
  801e5a:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801e5e:	52                   	push   %edx
  801e5f:	50                   	push   %eax
  801e60:	ff 75 0c             	pushl  0xc(%ebp)
  801e63:	ff 75 08             	pushl  0x8(%ebp)
  801e66:	e8 2e 04 00 00       	call   802299 <sys_createSharedObject>
  801e6b:	83 c4 10             	add    $0x10,%esp
  801e6e:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(obj_id < 0)
  801e71:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801e75:	79 07                	jns    801e7e <smalloc+0x9a>
			return (void*)NULL ;
  801e77:	b8 00 00 00 00       	mov    $0x0,%eax
  801e7c:	eb 0d                	jmp    801e8b <smalloc+0xa7>
		else
		    return (void*)ff_block->sva ;
  801e7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e81:	8b 40 08             	mov    0x8(%eax),%eax
  801e84:	eb 05                	jmp    801e8b <smalloc+0xa7>
		}
		return (void*)NULL ;
  801e86:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801e8b:	c9                   	leave  
  801e8c:	c3                   	ret    

00801e8d <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801e8d:	55                   	push   %ebp
  801e8e:	89 e5                	mov    %esp,%ebp
  801e90:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e93:	e8 5b fc ff ff       	call   801af3 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801e98:	83 ec 08             	sub    $0x8,%esp
  801e9b:	ff 75 0c             	pushl  0xc(%ebp)
  801e9e:	ff 75 08             	pushl  0x8(%ebp)
  801ea1:	e8 1d 04 00 00       	call   8022c3 <sys_getSizeOfSharedObject>
  801ea6:	83 c4 10             	add    $0x10,%esp
  801ea9:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(size == 0)
  801eac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801eb0:	75 0a                	jne    801ebc <sget+0x2f>
			return NULL ;
  801eb2:	b8 00 00 00 00       	mov    $0x0,%eax
  801eb7:	e9 83 00 00 00       	jmp    801f3f <sget+0xb2>
		size=ROUNDUP(size,PAGE_SIZE);
  801ebc:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801ec3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ec6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ec9:	01 d0                	add    %edx,%eax
  801ecb:	48                   	dec    %eax
  801ecc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801ecf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ed2:	ba 00 00 00 00       	mov    $0x0,%edx
  801ed7:	f7 75 f0             	divl   -0x10(%ebp)
  801eda:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801edd:	29 d0                	sub    %edx,%eax
  801edf:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801ee2:	e8 2d 06 00 00       	call   802514 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801ee7:	85 c0                	test   %eax,%eax
  801ee9:	74 4f                	je     801f3a <sget+0xad>
		{
			struct MemBlock * ff_block ;
				ff_block = alloc_block_FF(size);
  801eeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eee:	83 ec 0c             	sub    $0xc,%esp
  801ef1:	50                   	push   %eax
  801ef2:	e8 2e 0d 00 00       	call   802c25 <alloc_block_FF>
  801ef7:	83 c4 10             	add    $0x10,%esp
  801efa:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ff_block==NULL)
  801efd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801f01:	75 07                	jne    801f0a <sget+0x7d>
					return (void*)NULL ;
  801f03:	b8 00 00 00 00       	mov    $0x0,%eax
  801f08:	eb 35                	jmp    801f3f <sget+0xb2>

		int obj_id =sys_getSharedObject((int)ownerEnvID,sharedVarName,(void*)ff_block->sva);
  801f0a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f0d:	8b 40 08             	mov    0x8(%eax),%eax
  801f10:	83 ec 04             	sub    $0x4,%esp
  801f13:	50                   	push   %eax
  801f14:	ff 75 0c             	pushl  0xc(%ebp)
  801f17:	ff 75 08             	pushl  0x8(%ebp)
  801f1a:	e8 c1 03 00 00       	call   8022e0 <sys_getSharedObject>
  801f1f:	83 c4 10             	add    $0x10,%esp
  801f22:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if(obj_id<0)
  801f25:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801f29:	79 07                	jns    801f32 <sget+0xa5>
				return (void*)NULL ;
  801f2b:	b8 00 00 00 00       	mov    $0x0,%eax
  801f30:	eb 0d                	jmp    801f3f <sget+0xb2>
			else
				return (void*)ff_block->sva ;
  801f32:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f35:	8b 40 08             	mov    0x8(%eax),%eax
  801f38:	eb 05                	jmp    801f3f <sget+0xb2>


		}
	return (void*)NULL ;
  801f3a:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801f3f:	c9                   	leave  
  801f40:	c3                   	ret    

00801f41 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801f41:	55                   	push   %ebp
  801f42:	89 e5                	mov    %esp,%ebp
  801f44:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801f47:	e8 a7 fb ff ff       	call   801af3 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801f4c:	83 ec 04             	sub    $0x4,%esp
  801f4f:	68 e0 41 80 00       	push   $0x8041e0
  801f54:	68 f9 00 00 00       	push   $0xf9
  801f59:	68 d3 41 80 00       	push   $0x8041d3
  801f5e:	e8 52 eb ff ff       	call   800ab5 <_panic>

00801f63 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801f63:	55                   	push   %ebp
  801f64:	89 e5                	mov    %esp,%ebp
  801f66:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801f69:	83 ec 04             	sub    $0x4,%esp
  801f6c:	68 08 42 80 00       	push   $0x804208
  801f71:	68 0d 01 00 00       	push   $0x10d
  801f76:	68 d3 41 80 00       	push   $0x8041d3
  801f7b:	e8 35 eb ff ff       	call   800ab5 <_panic>

00801f80 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801f80:	55                   	push   %ebp
  801f81:	89 e5                	mov    %esp,%ebp
  801f83:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801f86:	83 ec 04             	sub    $0x4,%esp
  801f89:	68 2c 42 80 00       	push   $0x80422c
  801f8e:	68 18 01 00 00       	push   $0x118
  801f93:	68 d3 41 80 00       	push   $0x8041d3
  801f98:	e8 18 eb ff ff       	call   800ab5 <_panic>

00801f9d <shrink>:

}
void shrink(uint32 newSize)
{
  801f9d:	55                   	push   %ebp
  801f9e:	89 e5                	mov    %esp,%ebp
  801fa0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801fa3:	83 ec 04             	sub    $0x4,%esp
  801fa6:	68 2c 42 80 00       	push   $0x80422c
  801fab:	68 1d 01 00 00       	push   $0x11d
  801fb0:	68 d3 41 80 00       	push   $0x8041d3
  801fb5:	e8 fb ea ff ff       	call   800ab5 <_panic>

00801fba <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801fba:	55                   	push   %ebp
  801fbb:	89 e5                	mov    %esp,%ebp
  801fbd:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801fc0:	83 ec 04             	sub    $0x4,%esp
  801fc3:	68 2c 42 80 00       	push   $0x80422c
  801fc8:	68 22 01 00 00       	push   $0x122
  801fcd:	68 d3 41 80 00       	push   $0x8041d3
  801fd2:	e8 de ea ff ff       	call   800ab5 <_panic>

00801fd7 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801fd7:	55                   	push   %ebp
  801fd8:	89 e5                	mov    %esp,%ebp
  801fda:	57                   	push   %edi
  801fdb:	56                   	push   %esi
  801fdc:	53                   	push   %ebx
  801fdd:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fe6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fe9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801fec:	8b 7d 18             	mov    0x18(%ebp),%edi
  801fef:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801ff2:	cd 30                	int    $0x30
  801ff4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801ff7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801ffa:	83 c4 10             	add    $0x10,%esp
  801ffd:	5b                   	pop    %ebx
  801ffe:	5e                   	pop    %esi
  801fff:	5f                   	pop    %edi
  802000:	5d                   	pop    %ebp
  802001:	c3                   	ret    

00802002 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802002:	55                   	push   %ebp
  802003:	89 e5                	mov    %esp,%ebp
  802005:	83 ec 04             	sub    $0x4,%esp
  802008:	8b 45 10             	mov    0x10(%ebp),%eax
  80200b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80200e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802012:	8b 45 08             	mov    0x8(%ebp),%eax
  802015:	6a 00                	push   $0x0
  802017:	6a 00                	push   $0x0
  802019:	52                   	push   %edx
  80201a:	ff 75 0c             	pushl  0xc(%ebp)
  80201d:	50                   	push   %eax
  80201e:	6a 00                	push   $0x0
  802020:	e8 b2 ff ff ff       	call   801fd7 <syscall>
  802025:	83 c4 18             	add    $0x18,%esp
}
  802028:	90                   	nop
  802029:	c9                   	leave  
  80202a:	c3                   	ret    

0080202b <sys_cgetc>:

int
sys_cgetc(void)
{
  80202b:	55                   	push   %ebp
  80202c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80202e:	6a 00                	push   $0x0
  802030:	6a 00                	push   $0x0
  802032:	6a 00                	push   $0x0
  802034:	6a 00                	push   $0x0
  802036:	6a 00                	push   $0x0
  802038:	6a 01                	push   $0x1
  80203a:	e8 98 ff ff ff       	call   801fd7 <syscall>
  80203f:	83 c4 18             	add    $0x18,%esp
}
  802042:	c9                   	leave  
  802043:	c3                   	ret    

00802044 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802044:	55                   	push   %ebp
  802045:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802047:	8b 55 0c             	mov    0xc(%ebp),%edx
  80204a:	8b 45 08             	mov    0x8(%ebp),%eax
  80204d:	6a 00                	push   $0x0
  80204f:	6a 00                	push   $0x0
  802051:	6a 00                	push   $0x0
  802053:	52                   	push   %edx
  802054:	50                   	push   %eax
  802055:	6a 05                	push   $0x5
  802057:	e8 7b ff ff ff       	call   801fd7 <syscall>
  80205c:	83 c4 18             	add    $0x18,%esp
}
  80205f:	c9                   	leave  
  802060:	c3                   	ret    

00802061 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802061:	55                   	push   %ebp
  802062:	89 e5                	mov    %esp,%ebp
  802064:	56                   	push   %esi
  802065:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802066:	8b 75 18             	mov    0x18(%ebp),%esi
  802069:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80206c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80206f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802072:	8b 45 08             	mov    0x8(%ebp),%eax
  802075:	56                   	push   %esi
  802076:	53                   	push   %ebx
  802077:	51                   	push   %ecx
  802078:	52                   	push   %edx
  802079:	50                   	push   %eax
  80207a:	6a 06                	push   $0x6
  80207c:	e8 56 ff ff ff       	call   801fd7 <syscall>
  802081:	83 c4 18             	add    $0x18,%esp
}
  802084:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802087:	5b                   	pop    %ebx
  802088:	5e                   	pop    %esi
  802089:	5d                   	pop    %ebp
  80208a:	c3                   	ret    

0080208b <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80208b:	55                   	push   %ebp
  80208c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80208e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802091:	8b 45 08             	mov    0x8(%ebp),%eax
  802094:	6a 00                	push   $0x0
  802096:	6a 00                	push   $0x0
  802098:	6a 00                	push   $0x0
  80209a:	52                   	push   %edx
  80209b:	50                   	push   %eax
  80209c:	6a 07                	push   $0x7
  80209e:	e8 34 ff ff ff       	call   801fd7 <syscall>
  8020a3:	83 c4 18             	add    $0x18,%esp
}
  8020a6:	c9                   	leave  
  8020a7:	c3                   	ret    

008020a8 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8020a8:	55                   	push   %ebp
  8020a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8020ab:	6a 00                	push   $0x0
  8020ad:	6a 00                	push   $0x0
  8020af:	6a 00                	push   $0x0
  8020b1:	ff 75 0c             	pushl  0xc(%ebp)
  8020b4:	ff 75 08             	pushl  0x8(%ebp)
  8020b7:	6a 08                	push   $0x8
  8020b9:	e8 19 ff ff ff       	call   801fd7 <syscall>
  8020be:	83 c4 18             	add    $0x18,%esp
}
  8020c1:	c9                   	leave  
  8020c2:	c3                   	ret    

008020c3 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8020c3:	55                   	push   %ebp
  8020c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8020c6:	6a 00                	push   $0x0
  8020c8:	6a 00                	push   $0x0
  8020ca:	6a 00                	push   $0x0
  8020cc:	6a 00                	push   $0x0
  8020ce:	6a 00                	push   $0x0
  8020d0:	6a 09                	push   $0x9
  8020d2:	e8 00 ff ff ff       	call   801fd7 <syscall>
  8020d7:	83 c4 18             	add    $0x18,%esp
}
  8020da:	c9                   	leave  
  8020db:	c3                   	ret    

008020dc <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8020dc:	55                   	push   %ebp
  8020dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8020df:	6a 00                	push   $0x0
  8020e1:	6a 00                	push   $0x0
  8020e3:	6a 00                	push   $0x0
  8020e5:	6a 00                	push   $0x0
  8020e7:	6a 00                	push   $0x0
  8020e9:	6a 0a                	push   $0xa
  8020eb:	e8 e7 fe ff ff       	call   801fd7 <syscall>
  8020f0:	83 c4 18             	add    $0x18,%esp
}
  8020f3:	c9                   	leave  
  8020f4:	c3                   	ret    

008020f5 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8020f5:	55                   	push   %ebp
  8020f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8020f8:	6a 00                	push   $0x0
  8020fa:	6a 00                	push   $0x0
  8020fc:	6a 00                	push   $0x0
  8020fe:	6a 00                	push   $0x0
  802100:	6a 00                	push   $0x0
  802102:	6a 0b                	push   $0xb
  802104:	e8 ce fe ff ff       	call   801fd7 <syscall>
  802109:	83 c4 18             	add    $0x18,%esp
}
  80210c:	c9                   	leave  
  80210d:	c3                   	ret    

0080210e <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80210e:	55                   	push   %ebp
  80210f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802111:	6a 00                	push   $0x0
  802113:	6a 00                	push   $0x0
  802115:	6a 00                	push   $0x0
  802117:	ff 75 0c             	pushl  0xc(%ebp)
  80211a:	ff 75 08             	pushl  0x8(%ebp)
  80211d:	6a 0f                	push   $0xf
  80211f:	e8 b3 fe ff ff       	call   801fd7 <syscall>
  802124:	83 c4 18             	add    $0x18,%esp
	return;
  802127:	90                   	nop
}
  802128:	c9                   	leave  
  802129:	c3                   	ret    

0080212a <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80212a:	55                   	push   %ebp
  80212b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80212d:	6a 00                	push   $0x0
  80212f:	6a 00                	push   $0x0
  802131:	6a 00                	push   $0x0
  802133:	ff 75 0c             	pushl  0xc(%ebp)
  802136:	ff 75 08             	pushl  0x8(%ebp)
  802139:	6a 10                	push   $0x10
  80213b:	e8 97 fe ff ff       	call   801fd7 <syscall>
  802140:	83 c4 18             	add    $0x18,%esp
	return ;
  802143:	90                   	nop
}
  802144:	c9                   	leave  
  802145:	c3                   	ret    

00802146 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802146:	55                   	push   %ebp
  802147:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802149:	6a 00                	push   $0x0
  80214b:	6a 00                	push   $0x0
  80214d:	ff 75 10             	pushl  0x10(%ebp)
  802150:	ff 75 0c             	pushl  0xc(%ebp)
  802153:	ff 75 08             	pushl  0x8(%ebp)
  802156:	6a 11                	push   $0x11
  802158:	e8 7a fe ff ff       	call   801fd7 <syscall>
  80215d:	83 c4 18             	add    $0x18,%esp
	return ;
  802160:	90                   	nop
}
  802161:	c9                   	leave  
  802162:	c3                   	ret    

00802163 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802163:	55                   	push   %ebp
  802164:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802166:	6a 00                	push   $0x0
  802168:	6a 00                	push   $0x0
  80216a:	6a 00                	push   $0x0
  80216c:	6a 00                	push   $0x0
  80216e:	6a 00                	push   $0x0
  802170:	6a 0c                	push   $0xc
  802172:	e8 60 fe ff ff       	call   801fd7 <syscall>
  802177:	83 c4 18             	add    $0x18,%esp
}
  80217a:	c9                   	leave  
  80217b:	c3                   	ret    

0080217c <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80217c:	55                   	push   %ebp
  80217d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80217f:	6a 00                	push   $0x0
  802181:	6a 00                	push   $0x0
  802183:	6a 00                	push   $0x0
  802185:	6a 00                	push   $0x0
  802187:	ff 75 08             	pushl  0x8(%ebp)
  80218a:	6a 0d                	push   $0xd
  80218c:	e8 46 fe ff ff       	call   801fd7 <syscall>
  802191:	83 c4 18             	add    $0x18,%esp
}
  802194:	c9                   	leave  
  802195:	c3                   	ret    

00802196 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802196:	55                   	push   %ebp
  802197:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802199:	6a 00                	push   $0x0
  80219b:	6a 00                	push   $0x0
  80219d:	6a 00                	push   $0x0
  80219f:	6a 00                	push   $0x0
  8021a1:	6a 00                	push   $0x0
  8021a3:	6a 0e                	push   $0xe
  8021a5:	e8 2d fe ff ff       	call   801fd7 <syscall>
  8021aa:	83 c4 18             	add    $0x18,%esp
}
  8021ad:	90                   	nop
  8021ae:	c9                   	leave  
  8021af:	c3                   	ret    

008021b0 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8021b0:	55                   	push   %ebp
  8021b1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8021b3:	6a 00                	push   $0x0
  8021b5:	6a 00                	push   $0x0
  8021b7:	6a 00                	push   $0x0
  8021b9:	6a 00                	push   $0x0
  8021bb:	6a 00                	push   $0x0
  8021bd:	6a 13                	push   $0x13
  8021bf:	e8 13 fe ff ff       	call   801fd7 <syscall>
  8021c4:	83 c4 18             	add    $0x18,%esp
}
  8021c7:	90                   	nop
  8021c8:	c9                   	leave  
  8021c9:	c3                   	ret    

008021ca <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8021ca:	55                   	push   %ebp
  8021cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8021cd:	6a 00                	push   $0x0
  8021cf:	6a 00                	push   $0x0
  8021d1:	6a 00                	push   $0x0
  8021d3:	6a 00                	push   $0x0
  8021d5:	6a 00                	push   $0x0
  8021d7:	6a 14                	push   $0x14
  8021d9:	e8 f9 fd ff ff       	call   801fd7 <syscall>
  8021de:	83 c4 18             	add    $0x18,%esp
}
  8021e1:	90                   	nop
  8021e2:	c9                   	leave  
  8021e3:	c3                   	ret    

008021e4 <sys_cputc>:


void
sys_cputc(const char c)
{
  8021e4:	55                   	push   %ebp
  8021e5:	89 e5                	mov    %esp,%ebp
  8021e7:	83 ec 04             	sub    $0x4,%esp
  8021ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ed:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8021f0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8021f4:	6a 00                	push   $0x0
  8021f6:	6a 00                	push   $0x0
  8021f8:	6a 00                	push   $0x0
  8021fa:	6a 00                	push   $0x0
  8021fc:	50                   	push   %eax
  8021fd:	6a 15                	push   $0x15
  8021ff:	e8 d3 fd ff ff       	call   801fd7 <syscall>
  802204:	83 c4 18             	add    $0x18,%esp
}
  802207:	90                   	nop
  802208:	c9                   	leave  
  802209:	c3                   	ret    

0080220a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80220a:	55                   	push   %ebp
  80220b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80220d:	6a 00                	push   $0x0
  80220f:	6a 00                	push   $0x0
  802211:	6a 00                	push   $0x0
  802213:	6a 00                	push   $0x0
  802215:	6a 00                	push   $0x0
  802217:	6a 16                	push   $0x16
  802219:	e8 b9 fd ff ff       	call   801fd7 <syscall>
  80221e:	83 c4 18             	add    $0x18,%esp
}
  802221:	90                   	nop
  802222:	c9                   	leave  
  802223:	c3                   	ret    

00802224 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802224:	55                   	push   %ebp
  802225:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802227:	8b 45 08             	mov    0x8(%ebp),%eax
  80222a:	6a 00                	push   $0x0
  80222c:	6a 00                	push   $0x0
  80222e:	6a 00                	push   $0x0
  802230:	ff 75 0c             	pushl  0xc(%ebp)
  802233:	50                   	push   %eax
  802234:	6a 17                	push   $0x17
  802236:	e8 9c fd ff ff       	call   801fd7 <syscall>
  80223b:	83 c4 18             	add    $0x18,%esp
}
  80223e:	c9                   	leave  
  80223f:	c3                   	ret    

00802240 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802240:	55                   	push   %ebp
  802241:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802243:	8b 55 0c             	mov    0xc(%ebp),%edx
  802246:	8b 45 08             	mov    0x8(%ebp),%eax
  802249:	6a 00                	push   $0x0
  80224b:	6a 00                	push   $0x0
  80224d:	6a 00                	push   $0x0
  80224f:	52                   	push   %edx
  802250:	50                   	push   %eax
  802251:	6a 1a                	push   $0x1a
  802253:	e8 7f fd ff ff       	call   801fd7 <syscall>
  802258:	83 c4 18             	add    $0x18,%esp
}
  80225b:	c9                   	leave  
  80225c:	c3                   	ret    

0080225d <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80225d:	55                   	push   %ebp
  80225e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802260:	8b 55 0c             	mov    0xc(%ebp),%edx
  802263:	8b 45 08             	mov    0x8(%ebp),%eax
  802266:	6a 00                	push   $0x0
  802268:	6a 00                	push   $0x0
  80226a:	6a 00                	push   $0x0
  80226c:	52                   	push   %edx
  80226d:	50                   	push   %eax
  80226e:	6a 18                	push   $0x18
  802270:	e8 62 fd ff ff       	call   801fd7 <syscall>
  802275:	83 c4 18             	add    $0x18,%esp
}
  802278:	90                   	nop
  802279:	c9                   	leave  
  80227a:	c3                   	ret    

0080227b <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80227b:	55                   	push   %ebp
  80227c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80227e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802281:	8b 45 08             	mov    0x8(%ebp),%eax
  802284:	6a 00                	push   $0x0
  802286:	6a 00                	push   $0x0
  802288:	6a 00                	push   $0x0
  80228a:	52                   	push   %edx
  80228b:	50                   	push   %eax
  80228c:	6a 19                	push   $0x19
  80228e:	e8 44 fd ff ff       	call   801fd7 <syscall>
  802293:	83 c4 18             	add    $0x18,%esp
}
  802296:	90                   	nop
  802297:	c9                   	leave  
  802298:	c3                   	ret    

00802299 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802299:	55                   	push   %ebp
  80229a:	89 e5                	mov    %esp,%ebp
  80229c:	83 ec 04             	sub    $0x4,%esp
  80229f:	8b 45 10             	mov    0x10(%ebp),%eax
  8022a2:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8022a5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8022a8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8022ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8022af:	6a 00                	push   $0x0
  8022b1:	51                   	push   %ecx
  8022b2:	52                   	push   %edx
  8022b3:	ff 75 0c             	pushl  0xc(%ebp)
  8022b6:	50                   	push   %eax
  8022b7:	6a 1b                	push   $0x1b
  8022b9:	e8 19 fd ff ff       	call   801fd7 <syscall>
  8022be:	83 c4 18             	add    $0x18,%esp
}
  8022c1:	c9                   	leave  
  8022c2:	c3                   	ret    

008022c3 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8022c3:	55                   	push   %ebp
  8022c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8022c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cc:	6a 00                	push   $0x0
  8022ce:	6a 00                	push   $0x0
  8022d0:	6a 00                	push   $0x0
  8022d2:	52                   	push   %edx
  8022d3:	50                   	push   %eax
  8022d4:	6a 1c                	push   $0x1c
  8022d6:	e8 fc fc ff ff       	call   801fd7 <syscall>
  8022db:	83 c4 18             	add    $0x18,%esp
}
  8022de:	c9                   	leave  
  8022df:	c3                   	ret    

008022e0 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8022e0:	55                   	push   %ebp
  8022e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8022e3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ec:	6a 00                	push   $0x0
  8022ee:	6a 00                	push   $0x0
  8022f0:	51                   	push   %ecx
  8022f1:	52                   	push   %edx
  8022f2:	50                   	push   %eax
  8022f3:	6a 1d                	push   $0x1d
  8022f5:	e8 dd fc ff ff       	call   801fd7 <syscall>
  8022fa:	83 c4 18             	add    $0x18,%esp
}
  8022fd:	c9                   	leave  
  8022fe:	c3                   	ret    

008022ff <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8022ff:	55                   	push   %ebp
  802300:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802302:	8b 55 0c             	mov    0xc(%ebp),%edx
  802305:	8b 45 08             	mov    0x8(%ebp),%eax
  802308:	6a 00                	push   $0x0
  80230a:	6a 00                	push   $0x0
  80230c:	6a 00                	push   $0x0
  80230e:	52                   	push   %edx
  80230f:	50                   	push   %eax
  802310:	6a 1e                	push   $0x1e
  802312:	e8 c0 fc ff ff       	call   801fd7 <syscall>
  802317:	83 c4 18             	add    $0x18,%esp
}
  80231a:	c9                   	leave  
  80231b:	c3                   	ret    

0080231c <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80231c:	55                   	push   %ebp
  80231d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80231f:	6a 00                	push   $0x0
  802321:	6a 00                	push   $0x0
  802323:	6a 00                	push   $0x0
  802325:	6a 00                	push   $0x0
  802327:	6a 00                	push   $0x0
  802329:	6a 1f                	push   $0x1f
  80232b:	e8 a7 fc ff ff       	call   801fd7 <syscall>
  802330:	83 c4 18             	add    $0x18,%esp
}
  802333:	c9                   	leave  
  802334:	c3                   	ret    

00802335 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802335:	55                   	push   %ebp
  802336:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802338:	8b 45 08             	mov    0x8(%ebp),%eax
  80233b:	6a 00                	push   $0x0
  80233d:	ff 75 14             	pushl  0x14(%ebp)
  802340:	ff 75 10             	pushl  0x10(%ebp)
  802343:	ff 75 0c             	pushl  0xc(%ebp)
  802346:	50                   	push   %eax
  802347:	6a 20                	push   $0x20
  802349:	e8 89 fc ff ff       	call   801fd7 <syscall>
  80234e:	83 c4 18             	add    $0x18,%esp
}
  802351:	c9                   	leave  
  802352:	c3                   	ret    

00802353 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802353:	55                   	push   %ebp
  802354:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802356:	8b 45 08             	mov    0x8(%ebp),%eax
  802359:	6a 00                	push   $0x0
  80235b:	6a 00                	push   $0x0
  80235d:	6a 00                	push   $0x0
  80235f:	6a 00                	push   $0x0
  802361:	50                   	push   %eax
  802362:	6a 21                	push   $0x21
  802364:	e8 6e fc ff ff       	call   801fd7 <syscall>
  802369:	83 c4 18             	add    $0x18,%esp
}
  80236c:	90                   	nop
  80236d:	c9                   	leave  
  80236e:	c3                   	ret    

0080236f <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80236f:	55                   	push   %ebp
  802370:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802372:	8b 45 08             	mov    0x8(%ebp),%eax
  802375:	6a 00                	push   $0x0
  802377:	6a 00                	push   $0x0
  802379:	6a 00                	push   $0x0
  80237b:	6a 00                	push   $0x0
  80237d:	50                   	push   %eax
  80237e:	6a 22                	push   $0x22
  802380:	e8 52 fc ff ff       	call   801fd7 <syscall>
  802385:	83 c4 18             	add    $0x18,%esp
}
  802388:	c9                   	leave  
  802389:	c3                   	ret    

0080238a <sys_getenvid>:

int32 sys_getenvid(void)
{
  80238a:	55                   	push   %ebp
  80238b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80238d:	6a 00                	push   $0x0
  80238f:	6a 00                	push   $0x0
  802391:	6a 00                	push   $0x0
  802393:	6a 00                	push   $0x0
  802395:	6a 00                	push   $0x0
  802397:	6a 02                	push   $0x2
  802399:	e8 39 fc ff ff       	call   801fd7 <syscall>
  80239e:	83 c4 18             	add    $0x18,%esp
}
  8023a1:	c9                   	leave  
  8023a2:	c3                   	ret    

008023a3 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8023a3:	55                   	push   %ebp
  8023a4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8023a6:	6a 00                	push   $0x0
  8023a8:	6a 00                	push   $0x0
  8023aa:	6a 00                	push   $0x0
  8023ac:	6a 00                	push   $0x0
  8023ae:	6a 00                	push   $0x0
  8023b0:	6a 03                	push   $0x3
  8023b2:	e8 20 fc ff ff       	call   801fd7 <syscall>
  8023b7:	83 c4 18             	add    $0x18,%esp
}
  8023ba:	c9                   	leave  
  8023bb:	c3                   	ret    

008023bc <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8023bc:	55                   	push   %ebp
  8023bd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8023bf:	6a 00                	push   $0x0
  8023c1:	6a 00                	push   $0x0
  8023c3:	6a 00                	push   $0x0
  8023c5:	6a 00                	push   $0x0
  8023c7:	6a 00                	push   $0x0
  8023c9:	6a 04                	push   $0x4
  8023cb:	e8 07 fc ff ff       	call   801fd7 <syscall>
  8023d0:	83 c4 18             	add    $0x18,%esp
}
  8023d3:	c9                   	leave  
  8023d4:	c3                   	ret    

008023d5 <sys_exit_env>:


void sys_exit_env(void)
{
  8023d5:	55                   	push   %ebp
  8023d6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8023d8:	6a 00                	push   $0x0
  8023da:	6a 00                	push   $0x0
  8023dc:	6a 00                	push   $0x0
  8023de:	6a 00                	push   $0x0
  8023e0:	6a 00                	push   $0x0
  8023e2:	6a 23                	push   $0x23
  8023e4:	e8 ee fb ff ff       	call   801fd7 <syscall>
  8023e9:	83 c4 18             	add    $0x18,%esp
}
  8023ec:	90                   	nop
  8023ed:	c9                   	leave  
  8023ee:	c3                   	ret    

008023ef <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8023ef:	55                   	push   %ebp
  8023f0:	89 e5                	mov    %esp,%ebp
  8023f2:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8023f5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8023f8:	8d 50 04             	lea    0x4(%eax),%edx
  8023fb:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8023fe:	6a 00                	push   $0x0
  802400:	6a 00                	push   $0x0
  802402:	6a 00                	push   $0x0
  802404:	52                   	push   %edx
  802405:	50                   	push   %eax
  802406:	6a 24                	push   $0x24
  802408:	e8 ca fb ff ff       	call   801fd7 <syscall>
  80240d:	83 c4 18             	add    $0x18,%esp
	return result;
  802410:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802413:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802416:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802419:	89 01                	mov    %eax,(%ecx)
  80241b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80241e:	8b 45 08             	mov    0x8(%ebp),%eax
  802421:	c9                   	leave  
  802422:	c2 04 00             	ret    $0x4

00802425 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802425:	55                   	push   %ebp
  802426:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802428:	6a 00                	push   $0x0
  80242a:	6a 00                	push   $0x0
  80242c:	ff 75 10             	pushl  0x10(%ebp)
  80242f:	ff 75 0c             	pushl  0xc(%ebp)
  802432:	ff 75 08             	pushl  0x8(%ebp)
  802435:	6a 12                	push   $0x12
  802437:	e8 9b fb ff ff       	call   801fd7 <syscall>
  80243c:	83 c4 18             	add    $0x18,%esp
	return ;
  80243f:	90                   	nop
}
  802440:	c9                   	leave  
  802441:	c3                   	ret    

00802442 <sys_rcr2>:
uint32 sys_rcr2()
{
  802442:	55                   	push   %ebp
  802443:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802445:	6a 00                	push   $0x0
  802447:	6a 00                	push   $0x0
  802449:	6a 00                	push   $0x0
  80244b:	6a 00                	push   $0x0
  80244d:	6a 00                	push   $0x0
  80244f:	6a 25                	push   $0x25
  802451:	e8 81 fb ff ff       	call   801fd7 <syscall>
  802456:	83 c4 18             	add    $0x18,%esp
}
  802459:	c9                   	leave  
  80245a:	c3                   	ret    

0080245b <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80245b:	55                   	push   %ebp
  80245c:	89 e5                	mov    %esp,%ebp
  80245e:	83 ec 04             	sub    $0x4,%esp
  802461:	8b 45 08             	mov    0x8(%ebp),%eax
  802464:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802467:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80246b:	6a 00                	push   $0x0
  80246d:	6a 00                	push   $0x0
  80246f:	6a 00                	push   $0x0
  802471:	6a 00                	push   $0x0
  802473:	50                   	push   %eax
  802474:	6a 26                	push   $0x26
  802476:	e8 5c fb ff ff       	call   801fd7 <syscall>
  80247b:	83 c4 18             	add    $0x18,%esp
	return ;
  80247e:	90                   	nop
}
  80247f:	c9                   	leave  
  802480:	c3                   	ret    

00802481 <rsttst>:
void rsttst()
{
  802481:	55                   	push   %ebp
  802482:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802484:	6a 00                	push   $0x0
  802486:	6a 00                	push   $0x0
  802488:	6a 00                	push   $0x0
  80248a:	6a 00                	push   $0x0
  80248c:	6a 00                	push   $0x0
  80248e:	6a 28                	push   $0x28
  802490:	e8 42 fb ff ff       	call   801fd7 <syscall>
  802495:	83 c4 18             	add    $0x18,%esp
	return ;
  802498:	90                   	nop
}
  802499:	c9                   	leave  
  80249a:	c3                   	ret    

0080249b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80249b:	55                   	push   %ebp
  80249c:	89 e5                	mov    %esp,%ebp
  80249e:	83 ec 04             	sub    $0x4,%esp
  8024a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8024a4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8024a7:	8b 55 18             	mov    0x18(%ebp),%edx
  8024aa:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8024ae:	52                   	push   %edx
  8024af:	50                   	push   %eax
  8024b0:	ff 75 10             	pushl  0x10(%ebp)
  8024b3:	ff 75 0c             	pushl  0xc(%ebp)
  8024b6:	ff 75 08             	pushl  0x8(%ebp)
  8024b9:	6a 27                	push   $0x27
  8024bb:	e8 17 fb ff ff       	call   801fd7 <syscall>
  8024c0:	83 c4 18             	add    $0x18,%esp
	return ;
  8024c3:	90                   	nop
}
  8024c4:	c9                   	leave  
  8024c5:	c3                   	ret    

008024c6 <chktst>:
void chktst(uint32 n)
{
  8024c6:	55                   	push   %ebp
  8024c7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8024c9:	6a 00                	push   $0x0
  8024cb:	6a 00                	push   $0x0
  8024cd:	6a 00                	push   $0x0
  8024cf:	6a 00                	push   $0x0
  8024d1:	ff 75 08             	pushl  0x8(%ebp)
  8024d4:	6a 29                	push   $0x29
  8024d6:	e8 fc fa ff ff       	call   801fd7 <syscall>
  8024db:	83 c4 18             	add    $0x18,%esp
	return ;
  8024de:	90                   	nop
}
  8024df:	c9                   	leave  
  8024e0:	c3                   	ret    

008024e1 <inctst>:

void inctst()
{
  8024e1:	55                   	push   %ebp
  8024e2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8024e4:	6a 00                	push   $0x0
  8024e6:	6a 00                	push   $0x0
  8024e8:	6a 00                	push   $0x0
  8024ea:	6a 00                	push   $0x0
  8024ec:	6a 00                	push   $0x0
  8024ee:	6a 2a                	push   $0x2a
  8024f0:	e8 e2 fa ff ff       	call   801fd7 <syscall>
  8024f5:	83 c4 18             	add    $0x18,%esp
	return ;
  8024f8:	90                   	nop
}
  8024f9:	c9                   	leave  
  8024fa:	c3                   	ret    

008024fb <gettst>:
uint32 gettst()
{
  8024fb:	55                   	push   %ebp
  8024fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8024fe:	6a 00                	push   $0x0
  802500:	6a 00                	push   $0x0
  802502:	6a 00                	push   $0x0
  802504:	6a 00                	push   $0x0
  802506:	6a 00                	push   $0x0
  802508:	6a 2b                	push   $0x2b
  80250a:	e8 c8 fa ff ff       	call   801fd7 <syscall>
  80250f:	83 c4 18             	add    $0x18,%esp
}
  802512:	c9                   	leave  
  802513:	c3                   	ret    

00802514 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802514:	55                   	push   %ebp
  802515:	89 e5                	mov    %esp,%ebp
  802517:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80251a:	6a 00                	push   $0x0
  80251c:	6a 00                	push   $0x0
  80251e:	6a 00                	push   $0x0
  802520:	6a 00                	push   $0x0
  802522:	6a 00                	push   $0x0
  802524:	6a 2c                	push   $0x2c
  802526:	e8 ac fa ff ff       	call   801fd7 <syscall>
  80252b:	83 c4 18             	add    $0x18,%esp
  80252e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802531:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802535:	75 07                	jne    80253e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802537:	b8 01 00 00 00       	mov    $0x1,%eax
  80253c:	eb 05                	jmp    802543 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80253e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802543:	c9                   	leave  
  802544:	c3                   	ret    

00802545 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802545:	55                   	push   %ebp
  802546:	89 e5                	mov    %esp,%ebp
  802548:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80254b:	6a 00                	push   $0x0
  80254d:	6a 00                	push   $0x0
  80254f:	6a 00                	push   $0x0
  802551:	6a 00                	push   $0x0
  802553:	6a 00                	push   $0x0
  802555:	6a 2c                	push   $0x2c
  802557:	e8 7b fa ff ff       	call   801fd7 <syscall>
  80255c:	83 c4 18             	add    $0x18,%esp
  80255f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802562:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802566:	75 07                	jne    80256f <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802568:	b8 01 00 00 00       	mov    $0x1,%eax
  80256d:	eb 05                	jmp    802574 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80256f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802574:	c9                   	leave  
  802575:	c3                   	ret    

00802576 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802576:	55                   	push   %ebp
  802577:	89 e5                	mov    %esp,%ebp
  802579:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80257c:	6a 00                	push   $0x0
  80257e:	6a 00                	push   $0x0
  802580:	6a 00                	push   $0x0
  802582:	6a 00                	push   $0x0
  802584:	6a 00                	push   $0x0
  802586:	6a 2c                	push   $0x2c
  802588:	e8 4a fa ff ff       	call   801fd7 <syscall>
  80258d:	83 c4 18             	add    $0x18,%esp
  802590:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802593:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802597:	75 07                	jne    8025a0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802599:	b8 01 00 00 00       	mov    $0x1,%eax
  80259e:	eb 05                	jmp    8025a5 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8025a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025a5:	c9                   	leave  
  8025a6:	c3                   	ret    

008025a7 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8025a7:	55                   	push   %ebp
  8025a8:	89 e5                	mov    %esp,%ebp
  8025aa:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025ad:	6a 00                	push   $0x0
  8025af:	6a 00                	push   $0x0
  8025b1:	6a 00                	push   $0x0
  8025b3:	6a 00                	push   $0x0
  8025b5:	6a 00                	push   $0x0
  8025b7:	6a 2c                	push   $0x2c
  8025b9:	e8 19 fa ff ff       	call   801fd7 <syscall>
  8025be:	83 c4 18             	add    $0x18,%esp
  8025c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8025c4:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8025c8:	75 07                	jne    8025d1 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8025ca:	b8 01 00 00 00       	mov    $0x1,%eax
  8025cf:	eb 05                	jmp    8025d6 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8025d1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025d6:	c9                   	leave  
  8025d7:	c3                   	ret    

008025d8 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8025d8:	55                   	push   %ebp
  8025d9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8025db:	6a 00                	push   $0x0
  8025dd:	6a 00                	push   $0x0
  8025df:	6a 00                	push   $0x0
  8025e1:	6a 00                	push   $0x0
  8025e3:	ff 75 08             	pushl  0x8(%ebp)
  8025e6:	6a 2d                	push   $0x2d
  8025e8:	e8 ea f9 ff ff       	call   801fd7 <syscall>
  8025ed:	83 c4 18             	add    $0x18,%esp
	return ;
  8025f0:	90                   	nop
}
  8025f1:	c9                   	leave  
  8025f2:	c3                   	ret    

008025f3 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8025f3:	55                   	push   %ebp
  8025f4:	89 e5                	mov    %esp,%ebp
  8025f6:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8025f7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8025fa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8025fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  802600:	8b 45 08             	mov    0x8(%ebp),%eax
  802603:	6a 00                	push   $0x0
  802605:	53                   	push   %ebx
  802606:	51                   	push   %ecx
  802607:	52                   	push   %edx
  802608:	50                   	push   %eax
  802609:	6a 2e                	push   $0x2e
  80260b:	e8 c7 f9 ff ff       	call   801fd7 <syscall>
  802610:	83 c4 18             	add    $0x18,%esp
}
  802613:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802616:	c9                   	leave  
  802617:	c3                   	ret    

00802618 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802618:	55                   	push   %ebp
  802619:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80261b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80261e:	8b 45 08             	mov    0x8(%ebp),%eax
  802621:	6a 00                	push   $0x0
  802623:	6a 00                	push   $0x0
  802625:	6a 00                	push   $0x0
  802627:	52                   	push   %edx
  802628:	50                   	push   %eax
  802629:	6a 2f                	push   $0x2f
  80262b:	e8 a7 f9 ff ff       	call   801fd7 <syscall>
  802630:	83 c4 18             	add    $0x18,%esp
}
  802633:	c9                   	leave  
  802634:	c3                   	ret    

00802635 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802635:	55                   	push   %ebp
  802636:	89 e5                	mov    %esp,%ebp
  802638:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80263b:	83 ec 0c             	sub    $0xc,%esp
  80263e:	68 3c 42 80 00       	push   $0x80423c
  802643:	e8 21 e7 ff ff       	call   800d69 <cprintf>
  802648:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80264b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802652:	83 ec 0c             	sub    $0xc,%esp
  802655:	68 68 42 80 00       	push   $0x804268
  80265a:	e8 0a e7 ff ff       	call   800d69 <cprintf>
  80265f:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802662:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802666:	a1 38 51 80 00       	mov    0x805138,%eax
  80266b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80266e:	eb 56                	jmp    8026c6 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802670:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802674:	74 1c                	je     802692 <print_mem_block_lists+0x5d>
  802676:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802679:	8b 50 08             	mov    0x8(%eax),%edx
  80267c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80267f:	8b 48 08             	mov    0x8(%eax),%ecx
  802682:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802685:	8b 40 0c             	mov    0xc(%eax),%eax
  802688:	01 c8                	add    %ecx,%eax
  80268a:	39 c2                	cmp    %eax,%edx
  80268c:	73 04                	jae    802692 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  80268e:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802692:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802695:	8b 50 08             	mov    0x8(%eax),%edx
  802698:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269b:	8b 40 0c             	mov    0xc(%eax),%eax
  80269e:	01 c2                	add    %eax,%edx
  8026a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a3:	8b 40 08             	mov    0x8(%eax),%eax
  8026a6:	83 ec 04             	sub    $0x4,%esp
  8026a9:	52                   	push   %edx
  8026aa:	50                   	push   %eax
  8026ab:	68 7d 42 80 00       	push   $0x80427d
  8026b0:	e8 b4 e6 ff ff       	call   800d69 <cprintf>
  8026b5:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8026b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8026be:	a1 40 51 80 00       	mov    0x805140,%eax
  8026c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026ca:	74 07                	je     8026d3 <print_mem_block_lists+0x9e>
  8026cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cf:	8b 00                	mov    (%eax),%eax
  8026d1:	eb 05                	jmp    8026d8 <print_mem_block_lists+0xa3>
  8026d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8026d8:	a3 40 51 80 00       	mov    %eax,0x805140
  8026dd:	a1 40 51 80 00       	mov    0x805140,%eax
  8026e2:	85 c0                	test   %eax,%eax
  8026e4:	75 8a                	jne    802670 <print_mem_block_lists+0x3b>
  8026e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026ea:	75 84                	jne    802670 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8026ec:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8026f0:	75 10                	jne    802702 <print_mem_block_lists+0xcd>
  8026f2:	83 ec 0c             	sub    $0xc,%esp
  8026f5:	68 8c 42 80 00       	push   $0x80428c
  8026fa:	e8 6a e6 ff ff       	call   800d69 <cprintf>
  8026ff:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802702:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802709:	83 ec 0c             	sub    $0xc,%esp
  80270c:	68 b0 42 80 00       	push   $0x8042b0
  802711:	e8 53 e6 ff ff       	call   800d69 <cprintf>
  802716:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802719:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80271d:	a1 40 50 80 00       	mov    0x805040,%eax
  802722:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802725:	eb 56                	jmp    80277d <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802727:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80272b:	74 1c                	je     802749 <print_mem_block_lists+0x114>
  80272d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802730:	8b 50 08             	mov    0x8(%eax),%edx
  802733:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802736:	8b 48 08             	mov    0x8(%eax),%ecx
  802739:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80273c:	8b 40 0c             	mov    0xc(%eax),%eax
  80273f:	01 c8                	add    %ecx,%eax
  802741:	39 c2                	cmp    %eax,%edx
  802743:	73 04                	jae    802749 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802745:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802749:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274c:	8b 50 08             	mov    0x8(%eax),%edx
  80274f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802752:	8b 40 0c             	mov    0xc(%eax),%eax
  802755:	01 c2                	add    %eax,%edx
  802757:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275a:	8b 40 08             	mov    0x8(%eax),%eax
  80275d:	83 ec 04             	sub    $0x4,%esp
  802760:	52                   	push   %edx
  802761:	50                   	push   %eax
  802762:	68 7d 42 80 00       	push   $0x80427d
  802767:	e8 fd e5 ff ff       	call   800d69 <cprintf>
  80276c:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80276f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802772:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802775:	a1 48 50 80 00       	mov    0x805048,%eax
  80277a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80277d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802781:	74 07                	je     80278a <print_mem_block_lists+0x155>
  802783:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802786:	8b 00                	mov    (%eax),%eax
  802788:	eb 05                	jmp    80278f <print_mem_block_lists+0x15a>
  80278a:	b8 00 00 00 00       	mov    $0x0,%eax
  80278f:	a3 48 50 80 00       	mov    %eax,0x805048
  802794:	a1 48 50 80 00       	mov    0x805048,%eax
  802799:	85 c0                	test   %eax,%eax
  80279b:	75 8a                	jne    802727 <print_mem_block_lists+0xf2>
  80279d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027a1:	75 84                	jne    802727 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8027a3:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8027a7:	75 10                	jne    8027b9 <print_mem_block_lists+0x184>
  8027a9:	83 ec 0c             	sub    $0xc,%esp
  8027ac:	68 c8 42 80 00       	push   $0x8042c8
  8027b1:	e8 b3 e5 ff ff       	call   800d69 <cprintf>
  8027b6:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8027b9:	83 ec 0c             	sub    $0xc,%esp
  8027bc:	68 3c 42 80 00       	push   $0x80423c
  8027c1:	e8 a3 e5 ff ff       	call   800d69 <cprintf>
  8027c6:	83 c4 10             	add    $0x10,%esp

}
  8027c9:	90                   	nop
  8027ca:	c9                   	leave  
  8027cb:	c3                   	ret    

008027cc <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8027cc:	55                   	push   %ebp
  8027cd:	89 e5                	mov    %esp,%ebp
  8027cf:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  8027d2:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8027d9:	00 00 00 
  8027dc:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8027e3:	00 00 00 
  8027e6:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8027ed:	00 00 00 
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  8027f0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8027f7:	e9 9e 00 00 00       	jmp    80289a <initialize_MemBlocksList+0xce>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
  8027fc:	a1 50 50 80 00       	mov    0x805050,%eax
  802801:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802804:	c1 e2 04             	shl    $0x4,%edx
  802807:	01 d0                	add    %edx,%eax
  802809:	85 c0                	test   %eax,%eax
  80280b:	75 14                	jne    802821 <initialize_MemBlocksList+0x55>
  80280d:	83 ec 04             	sub    $0x4,%esp
  802810:	68 f0 42 80 00       	push   $0x8042f0
  802815:	6a 43                	push   $0x43
  802817:	68 13 43 80 00       	push   $0x804313
  80281c:	e8 94 e2 ff ff       	call   800ab5 <_panic>
  802821:	a1 50 50 80 00       	mov    0x805050,%eax
  802826:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802829:	c1 e2 04             	shl    $0x4,%edx
  80282c:	01 d0                	add    %edx,%eax
  80282e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802834:	89 10                	mov    %edx,(%eax)
  802836:	8b 00                	mov    (%eax),%eax
  802838:	85 c0                	test   %eax,%eax
  80283a:	74 18                	je     802854 <initialize_MemBlocksList+0x88>
  80283c:	a1 48 51 80 00       	mov    0x805148,%eax
  802841:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802847:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80284a:	c1 e1 04             	shl    $0x4,%ecx
  80284d:	01 ca                	add    %ecx,%edx
  80284f:	89 50 04             	mov    %edx,0x4(%eax)
  802852:	eb 12                	jmp    802866 <initialize_MemBlocksList+0x9a>
  802854:	a1 50 50 80 00       	mov    0x805050,%eax
  802859:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80285c:	c1 e2 04             	shl    $0x4,%edx
  80285f:	01 d0                	add    %edx,%eax
  802861:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802866:	a1 50 50 80 00       	mov    0x805050,%eax
  80286b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80286e:	c1 e2 04             	shl    $0x4,%edx
  802871:	01 d0                	add    %edx,%eax
  802873:	a3 48 51 80 00       	mov    %eax,0x805148
  802878:	a1 50 50 80 00       	mov    0x805050,%eax
  80287d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802880:	c1 e2 04             	shl    $0x4,%edx
  802883:	01 d0                	add    %edx,%eax
  802885:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80288c:	a1 54 51 80 00       	mov    0x805154,%eax
  802891:	40                   	inc    %eax
  802892:	a3 54 51 80 00       	mov    %eax,0x805154
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  802897:	ff 45 f4             	incl   -0xc(%ebp)
  80289a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289d:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028a0:	0f 82 56 ff ff ff    	jb     8027fc <initialize_MemBlocksList+0x30>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
		}
}
  8028a6:	90                   	nop
  8028a7:	c9                   	leave  
  8028a8:	c3                   	ret    

008028a9 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8028a9:	55                   	push   %ebp
  8028aa:	89 e5                	mov    %esp,%ebp
  8028ac:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  8028af:	a1 38 51 80 00       	mov    0x805138,%eax
  8028b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8028b7:	eb 18                	jmp    8028d1 <find_block+0x28>
	{
		if (ele->sva==va)
  8028b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8028bc:	8b 40 08             	mov    0x8(%eax),%eax
  8028bf:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8028c2:	75 05                	jne    8028c9 <find_block+0x20>
			return ele;
  8028c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8028c7:	eb 7b                	jmp    802944 <find_block+0x9b>
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  8028c9:	a1 40 51 80 00       	mov    0x805140,%eax
  8028ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8028d1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8028d5:	74 07                	je     8028de <find_block+0x35>
  8028d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8028da:	8b 00                	mov    (%eax),%eax
  8028dc:	eb 05                	jmp    8028e3 <find_block+0x3a>
  8028de:	b8 00 00 00 00       	mov    $0x0,%eax
  8028e3:	a3 40 51 80 00       	mov    %eax,0x805140
  8028e8:	a1 40 51 80 00       	mov    0x805140,%eax
  8028ed:	85 c0                	test   %eax,%eax
  8028ef:	75 c8                	jne    8028b9 <find_block+0x10>
  8028f1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8028f5:	75 c2                	jne    8028b9 <find_block+0x10>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  8028f7:	a1 40 50 80 00       	mov    0x805040,%eax
  8028fc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8028ff:	eb 18                	jmp    802919 <find_block+0x70>
	{
		if (ele->sva==va)
  802901:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802904:	8b 40 08             	mov    0x8(%eax),%eax
  802907:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80290a:	75 05                	jne    802911 <find_block+0x68>
					return ele;
  80290c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80290f:	eb 33                	jmp    802944 <find_block+0x9b>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  802911:	a1 48 50 80 00       	mov    0x805048,%eax
  802916:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802919:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80291d:	74 07                	je     802926 <find_block+0x7d>
  80291f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802922:	8b 00                	mov    (%eax),%eax
  802924:	eb 05                	jmp    80292b <find_block+0x82>
  802926:	b8 00 00 00 00       	mov    $0x0,%eax
  80292b:	a3 48 50 80 00       	mov    %eax,0x805048
  802930:	a1 48 50 80 00       	mov    0x805048,%eax
  802935:	85 c0                	test   %eax,%eax
  802937:	75 c8                	jne    802901 <find_block+0x58>
  802939:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80293d:	75 c2                	jne    802901 <find_block+0x58>
	{
		if (ele->sva==va)
					return ele;
	}
return NULL;
  80293f:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802944:	c9                   	leave  
  802945:	c3                   	ret    

00802946 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802946:	55                   	push   %ebp
  802947:	89 e5                	mov    %esp,%ebp
  802949:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;

int x =LIST_SIZE(&AllocMemBlocksList);
  80294c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802951:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((x==0))
  802954:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802958:	75 62                	jne    8029bc <insert_sorted_allocList+0x76>
	{
	//	blockToInsert=AllocMemBlocksList.lh_first;
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  80295a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80295e:	75 14                	jne    802974 <insert_sorted_allocList+0x2e>
  802960:	83 ec 04             	sub    $0x4,%esp
  802963:	68 f0 42 80 00       	push   $0x8042f0
  802968:	6a 69                	push   $0x69
  80296a:	68 13 43 80 00       	push   $0x804313
  80296f:	e8 41 e1 ff ff       	call   800ab5 <_panic>
  802974:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80297a:	8b 45 08             	mov    0x8(%ebp),%eax
  80297d:	89 10                	mov    %edx,(%eax)
  80297f:	8b 45 08             	mov    0x8(%ebp),%eax
  802982:	8b 00                	mov    (%eax),%eax
  802984:	85 c0                	test   %eax,%eax
  802986:	74 0d                	je     802995 <insert_sorted_allocList+0x4f>
  802988:	a1 40 50 80 00       	mov    0x805040,%eax
  80298d:	8b 55 08             	mov    0x8(%ebp),%edx
  802990:	89 50 04             	mov    %edx,0x4(%eax)
  802993:	eb 08                	jmp    80299d <insert_sorted_allocList+0x57>
  802995:	8b 45 08             	mov    0x8(%ebp),%eax
  802998:	a3 44 50 80 00       	mov    %eax,0x805044
  80299d:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a0:	a3 40 50 80 00       	mov    %eax,0x805040
  8029a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029af:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8029b4:	40                   	inc    %eax
  8029b5:	a3 4c 50 80 00       	mov    %eax,0x80504c
  8029ba:	eb 72                	jmp    802a2e <insert_sorted_allocList+0xe8>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
  8029bc:	a1 40 50 80 00       	mov    0x805040,%eax
  8029c1:	8b 50 08             	mov    0x8(%eax),%edx
  8029c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c7:	8b 40 08             	mov    0x8(%eax),%eax
  8029ca:	39 c2                	cmp    %eax,%edx
  8029cc:	76 60                	jbe    802a2e <insert_sorted_allocList+0xe8>
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  8029ce:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029d2:	75 14                	jne    8029e8 <insert_sorted_allocList+0xa2>
  8029d4:	83 ec 04             	sub    $0x4,%esp
  8029d7:	68 f0 42 80 00       	push   $0x8042f0
  8029dc:	6a 6d                	push   $0x6d
  8029de:	68 13 43 80 00       	push   $0x804313
  8029e3:	e8 cd e0 ff ff       	call   800ab5 <_panic>
  8029e8:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8029ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f1:	89 10                	mov    %edx,(%eax)
  8029f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f6:	8b 00                	mov    (%eax),%eax
  8029f8:	85 c0                	test   %eax,%eax
  8029fa:	74 0d                	je     802a09 <insert_sorted_allocList+0xc3>
  8029fc:	a1 40 50 80 00       	mov    0x805040,%eax
  802a01:	8b 55 08             	mov    0x8(%ebp),%edx
  802a04:	89 50 04             	mov    %edx,0x4(%eax)
  802a07:	eb 08                	jmp    802a11 <insert_sorted_allocList+0xcb>
  802a09:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0c:	a3 44 50 80 00       	mov    %eax,0x805044
  802a11:	8b 45 08             	mov    0x8(%ebp),%eax
  802a14:	a3 40 50 80 00       	mov    %eax,0x805040
  802a19:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a23:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a28:	40                   	inc    %eax
  802a29:	a3 4c 50 80 00       	mov    %eax,0x80504c
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  802a2e:	a1 40 50 80 00       	mov    0x805040,%eax
  802a33:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a36:	e9 b9 01 00 00       	jmp    802bf4 <insert_sorted_allocList+0x2ae>
	{


		if ((blockToInsert->sva>AllocMemBlocksList.lh_first->sva)&&blockToInsert->sva<element->sva)
  802a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3e:	8b 50 08             	mov    0x8(%eax),%edx
  802a41:	a1 40 50 80 00       	mov    0x805040,%eax
  802a46:	8b 40 08             	mov    0x8(%eax),%eax
  802a49:	39 c2                	cmp    %eax,%edx
  802a4b:	76 7c                	jbe    802ac9 <insert_sorted_allocList+0x183>
  802a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a50:	8b 50 08             	mov    0x8(%eax),%edx
  802a53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a56:	8b 40 08             	mov    0x8(%eax),%eax
  802a59:	39 c2                	cmp    %eax,%edx
  802a5b:	73 6c                	jae    802ac9 <insert_sorted_allocList+0x183>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,element,blockToInsert);
  802a5d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a61:	74 06                	je     802a69 <insert_sorted_allocList+0x123>
  802a63:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a67:	75 14                	jne    802a7d <insert_sorted_allocList+0x137>
  802a69:	83 ec 04             	sub    $0x4,%esp
  802a6c:	68 2c 43 80 00       	push   $0x80432c
  802a71:	6a 75                	push   $0x75
  802a73:	68 13 43 80 00       	push   $0x804313
  802a78:	e8 38 e0 ff ff       	call   800ab5 <_panic>
  802a7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a80:	8b 50 04             	mov    0x4(%eax),%edx
  802a83:	8b 45 08             	mov    0x8(%ebp),%eax
  802a86:	89 50 04             	mov    %edx,0x4(%eax)
  802a89:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a8f:	89 10                	mov    %edx,(%eax)
  802a91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a94:	8b 40 04             	mov    0x4(%eax),%eax
  802a97:	85 c0                	test   %eax,%eax
  802a99:	74 0d                	je     802aa8 <insert_sorted_allocList+0x162>
  802a9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9e:	8b 40 04             	mov    0x4(%eax),%eax
  802aa1:	8b 55 08             	mov    0x8(%ebp),%edx
  802aa4:	89 10                	mov    %edx,(%eax)
  802aa6:	eb 08                	jmp    802ab0 <insert_sorted_allocList+0x16a>
  802aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  802aab:	a3 40 50 80 00       	mov    %eax,0x805040
  802ab0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab3:	8b 55 08             	mov    0x8(%ebp),%edx
  802ab6:	89 50 04             	mov    %edx,0x4(%eax)
  802ab9:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802abe:	40                   	inc    %eax
  802abf:	a3 4c 50 80 00       	mov    %eax,0x80504c

		break;}
  802ac4:	e9 59 01 00 00       	jmp    802c22 <insert_sorted_allocList+0x2dc>

	else if ((blockToInsert->sva>element->sva)&&(blockToInsert->sva<AllocMemBlocksList.lh_last->sva)&&blockToInsert->sva<LIST_NEXT(element)->sva)
  802ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  802acc:	8b 50 08             	mov    0x8(%eax),%edx
  802acf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad2:	8b 40 08             	mov    0x8(%eax),%eax
  802ad5:	39 c2                	cmp    %eax,%edx
  802ad7:	0f 86 98 00 00 00    	jbe    802b75 <insert_sorted_allocList+0x22f>
  802add:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae0:	8b 50 08             	mov    0x8(%eax),%edx
  802ae3:	a1 44 50 80 00       	mov    0x805044,%eax
  802ae8:	8b 40 08             	mov    0x8(%eax),%eax
  802aeb:	39 c2                	cmp    %eax,%edx
  802aed:	0f 83 82 00 00 00    	jae    802b75 <insert_sorted_allocList+0x22f>
  802af3:	8b 45 08             	mov    0x8(%ebp),%eax
  802af6:	8b 50 08             	mov    0x8(%eax),%edx
  802af9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afc:	8b 00                	mov    (%eax),%eax
  802afe:	8b 40 08             	mov    0x8(%eax),%eax
  802b01:	39 c2                	cmp    %eax,%edx
  802b03:	73 70                	jae    802b75 <insert_sorted_allocList+0x22f>
	{

	LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  802b05:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b09:	74 06                	je     802b11 <insert_sorted_allocList+0x1cb>
  802b0b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b0f:	75 14                	jne    802b25 <insert_sorted_allocList+0x1df>
  802b11:	83 ec 04             	sub    $0x4,%esp
  802b14:	68 64 43 80 00       	push   $0x804364
  802b19:	6a 7c                	push   $0x7c
  802b1b:	68 13 43 80 00       	push   $0x804313
  802b20:	e8 90 df ff ff       	call   800ab5 <_panic>
  802b25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b28:	8b 10                	mov    (%eax),%edx
  802b2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2d:	89 10                	mov    %edx,(%eax)
  802b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b32:	8b 00                	mov    (%eax),%eax
  802b34:	85 c0                	test   %eax,%eax
  802b36:	74 0b                	je     802b43 <insert_sorted_allocList+0x1fd>
  802b38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3b:	8b 00                	mov    (%eax),%eax
  802b3d:	8b 55 08             	mov    0x8(%ebp),%edx
  802b40:	89 50 04             	mov    %edx,0x4(%eax)
  802b43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b46:	8b 55 08             	mov    0x8(%ebp),%edx
  802b49:	89 10                	mov    %edx,(%eax)
  802b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b51:	89 50 04             	mov    %edx,0x4(%eax)
  802b54:	8b 45 08             	mov    0x8(%ebp),%eax
  802b57:	8b 00                	mov    (%eax),%eax
  802b59:	85 c0                	test   %eax,%eax
  802b5b:	75 08                	jne    802b65 <insert_sorted_allocList+0x21f>
  802b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b60:	a3 44 50 80 00       	mov    %eax,0x805044
  802b65:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802b6a:	40                   	inc    %eax
  802b6b:	a3 4c 50 80 00       	mov    %eax,0x80504c
		break;
  802b70:	e9 ad 00 00 00       	jmp    802c22 <insert_sorted_allocList+0x2dc>
	}else if (blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  802b75:	8b 45 08             	mov    0x8(%ebp),%eax
  802b78:	8b 50 08             	mov    0x8(%eax),%edx
  802b7b:	a1 44 50 80 00       	mov    0x805044,%eax
  802b80:	8b 40 08             	mov    0x8(%eax),%eax
  802b83:	39 c2                	cmp    %eax,%edx
  802b85:	76 65                	jbe    802bec <insert_sorted_allocList+0x2a6>
	{
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
  802b87:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b8b:	75 17                	jne    802ba4 <insert_sorted_allocList+0x25e>
  802b8d:	83 ec 04             	sub    $0x4,%esp
  802b90:	68 98 43 80 00       	push   $0x804398
  802b95:	68 80 00 00 00       	push   $0x80
  802b9a:	68 13 43 80 00       	push   $0x804313
  802b9f:	e8 11 df ff ff       	call   800ab5 <_panic>
  802ba4:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802baa:	8b 45 08             	mov    0x8(%ebp),%eax
  802bad:	89 50 04             	mov    %edx,0x4(%eax)
  802bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb3:	8b 40 04             	mov    0x4(%eax),%eax
  802bb6:	85 c0                	test   %eax,%eax
  802bb8:	74 0c                	je     802bc6 <insert_sorted_allocList+0x280>
  802bba:	a1 44 50 80 00       	mov    0x805044,%eax
  802bbf:	8b 55 08             	mov    0x8(%ebp),%edx
  802bc2:	89 10                	mov    %edx,(%eax)
  802bc4:	eb 08                	jmp    802bce <insert_sorted_allocList+0x288>
  802bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc9:	a3 40 50 80 00       	mov    %eax,0x805040
  802bce:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd1:	a3 44 50 80 00       	mov    %eax,0x805044
  802bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bdf:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802be4:	40                   	inc    %eax
  802be5:	a3 4c 50 80 00       	mov    %eax,0x80504c
		break;
  802bea:	eb 36                	jmp    802c22 <insert_sorted_allocList+0x2dc>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  802bec:	a1 48 50 80 00       	mov    0x805048,%eax
  802bf1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bf4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bf8:	74 07                	je     802c01 <insert_sorted_allocList+0x2bb>
  802bfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfd:	8b 00                	mov    (%eax),%eax
  802bff:	eb 05                	jmp    802c06 <insert_sorted_allocList+0x2c0>
  802c01:	b8 00 00 00 00       	mov    $0x0,%eax
  802c06:	a3 48 50 80 00       	mov    %eax,0x805048
  802c0b:	a1 48 50 80 00       	mov    0x805048,%eax
  802c10:	85 c0                	test   %eax,%eax
  802c12:	0f 85 23 fe ff ff    	jne    802a3b <insert_sorted_allocList+0xf5>
  802c18:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c1c:	0f 85 19 fe ff ff    	jne    802a3b <insert_sorted_allocList+0xf5>
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
		break;

	}
	}
}
  802c22:	90                   	nop
  802c23:	c9                   	leave  
  802c24:	c3                   	ret    

00802c25 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802c25:	55                   	push   %ebp
  802c26:	89 e5                	mov    %esp,%ebp
  802c28:	83 ec 18             	sub    $0x18,%esp
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802c2b:	a1 38 51 80 00       	mov    0x805138,%eax
  802c30:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c33:	e9 7c 01 00 00       	jmp    802db4 <alloc_block_FF+0x18f>
		{
			// case 2
				if(element->size == size)
  802c38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3b:	8b 40 0c             	mov    0xc(%eax),%eax
  802c3e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c41:	0f 85 90 00 00 00    	jne    802cd7 <alloc_block_FF+0xb2>
				{
					tmp_block=element;
  802c47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,element);
  802c4d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c51:	75 17                	jne    802c6a <alloc_block_FF+0x45>
  802c53:	83 ec 04             	sub    $0x4,%esp
  802c56:	68 bb 43 80 00       	push   $0x8043bb
  802c5b:	68 ba 00 00 00       	push   $0xba
  802c60:	68 13 43 80 00       	push   $0x804313
  802c65:	e8 4b de ff ff       	call   800ab5 <_panic>
  802c6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6d:	8b 00                	mov    (%eax),%eax
  802c6f:	85 c0                	test   %eax,%eax
  802c71:	74 10                	je     802c83 <alloc_block_FF+0x5e>
  802c73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c76:	8b 00                	mov    (%eax),%eax
  802c78:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c7b:	8b 52 04             	mov    0x4(%edx),%edx
  802c7e:	89 50 04             	mov    %edx,0x4(%eax)
  802c81:	eb 0b                	jmp    802c8e <alloc_block_FF+0x69>
  802c83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c86:	8b 40 04             	mov    0x4(%eax),%eax
  802c89:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c91:	8b 40 04             	mov    0x4(%eax),%eax
  802c94:	85 c0                	test   %eax,%eax
  802c96:	74 0f                	je     802ca7 <alloc_block_FF+0x82>
  802c98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9b:	8b 40 04             	mov    0x4(%eax),%eax
  802c9e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ca1:	8b 12                	mov    (%edx),%edx
  802ca3:	89 10                	mov    %edx,(%eax)
  802ca5:	eb 0a                	jmp    802cb1 <alloc_block_FF+0x8c>
  802ca7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802caa:	8b 00                	mov    (%eax),%eax
  802cac:	a3 38 51 80 00       	mov    %eax,0x805138
  802cb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cc4:	a1 44 51 80 00       	mov    0x805144,%eax
  802cc9:	48                   	dec    %eax
  802cca:	a3 44 51 80 00       	mov    %eax,0x805144
					return tmp_block;
  802ccf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd2:	e9 10 01 00 00       	jmp    802de7 <alloc_block_FF+0x1c2>
				}
				 // case 3
				else if(element->size > size)
  802cd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cda:	8b 40 0c             	mov    0xc(%eax),%eax
  802cdd:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ce0:	0f 86 c6 00 00 00    	jbe    802dac <alloc_block_FF+0x187>
				{
					// the new block are created
					tmp_block = AvailableMemBlocksList.lh_first ;
  802ce6:	a1 48 51 80 00       	mov    0x805148,%eax
  802ceb:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  802cee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cf2:	75 17                	jne    802d0b <alloc_block_FF+0xe6>
  802cf4:	83 ec 04             	sub    $0x4,%esp
  802cf7:	68 bb 43 80 00       	push   $0x8043bb
  802cfc:	68 c2 00 00 00       	push   $0xc2
  802d01:	68 13 43 80 00       	push   $0x804313
  802d06:	e8 aa dd ff ff       	call   800ab5 <_panic>
  802d0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d0e:	8b 00                	mov    (%eax),%eax
  802d10:	85 c0                	test   %eax,%eax
  802d12:	74 10                	je     802d24 <alloc_block_FF+0xff>
  802d14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d17:	8b 00                	mov    (%eax),%eax
  802d19:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d1c:	8b 52 04             	mov    0x4(%edx),%edx
  802d1f:	89 50 04             	mov    %edx,0x4(%eax)
  802d22:	eb 0b                	jmp    802d2f <alloc_block_FF+0x10a>
  802d24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d27:	8b 40 04             	mov    0x4(%eax),%eax
  802d2a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d32:	8b 40 04             	mov    0x4(%eax),%eax
  802d35:	85 c0                	test   %eax,%eax
  802d37:	74 0f                	je     802d48 <alloc_block_FF+0x123>
  802d39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d3c:	8b 40 04             	mov    0x4(%eax),%eax
  802d3f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d42:	8b 12                	mov    (%edx),%edx
  802d44:	89 10                	mov    %edx,(%eax)
  802d46:	eb 0a                	jmp    802d52 <alloc_block_FF+0x12d>
  802d48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d4b:	8b 00                	mov    (%eax),%eax
  802d4d:	a3 48 51 80 00       	mov    %eax,0x805148
  802d52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d55:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d5e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d65:	a1 54 51 80 00       	mov    0x805154,%eax
  802d6a:	48                   	dec    %eax
  802d6b:	a3 54 51 80 00       	mov    %eax,0x805154
					tmp_block->sva=element->sva;
  802d70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d73:	8b 50 08             	mov    0x8(%eax),%edx
  802d76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d79:	89 50 08             	mov    %edx,0x8(%eax)
					tmp_block->size=size;
  802d7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d7f:	8b 55 08             	mov    0x8(%ebp),%edx
  802d82:	89 50 0c             	mov    %edx,0xc(%eax)
					//update block with remaining space
					element->size-=size;
  802d85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d88:	8b 40 0c             	mov    0xc(%eax),%eax
  802d8b:	2b 45 08             	sub    0x8(%ebp),%eax
  802d8e:	89 c2                	mov    %eax,%edx
  802d90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d93:	89 50 0c             	mov    %edx,0xc(%eax)
					element->sva = element->sva + size;
  802d96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d99:	8b 50 08             	mov    0x8(%eax),%edx
  802d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9f:	01 c2                	add    %eax,%edx
  802da1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da4:	89 50 08             	mov    %edx,0x8(%eax)
					// return back the new block
					return tmp_block ;
  802da7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802daa:	eb 3b                	jmp    802de7 <alloc_block_FF+0x1c2>
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802dac:	a1 40 51 80 00       	mov    0x805140,%eax
  802db1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802db4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802db8:	74 07                	je     802dc1 <alloc_block_FF+0x19c>
  802dba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbd:	8b 00                	mov    (%eax),%eax
  802dbf:	eb 05                	jmp    802dc6 <alloc_block_FF+0x1a1>
  802dc1:	b8 00 00 00 00       	mov    $0x0,%eax
  802dc6:	a3 40 51 80 00       	mov    %eax,0x805140
  802dcb:	a1 40 51 80 00       	mov    0x805140,%eax
  802dd0:	85 c0                	test   %eax,%eax
  802dd2:	0f 85 60 fe ff ff    	jne    802c38 <alloc_block_FF+0x13>
  802dd8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ddc:	0f 85 56 fe ff ff    	jne    802c38 <alloc_block_FF+0x13>
					// return back the new block
					return tmp_block ;
				}
		}
		// case 1
	  return NULL ;}
  802de2:	b8 00 00 00 00       	mov    $0x0,%eax
  802de7:	c9                   	leave  
  802de8:	c3                   	ret    

00802de9 <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================

struct MemBlock *alloc_block_BF(uint32 size)
{
  802de9:	55                   	push   %ebp
  802dea:	89 e5                	mov    %esp,%ebp
  802dec:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
  802def:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802df6:	a1 38 51 80 00       	mov    0x805138,%eax
  802dfb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802dfe:	eb 3a                	jmp    802e3a <alloc_block_BF+0x51>
		{
			if(element->size >= size)
  802e00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e03:	8b 40 0c             	mov    0xc(%eax),%eax
  802e06:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e09:	72 27                	jb     802e32 <alloc_block_BF+0x49>
			{
				if(best_size==-1)
  802e0b:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802e0f:	75 0b                	jne    802e1c <alloc_block_BF+0x33>
					best_size= element->size;
  802e11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e14:	8b 40 0c             	mov    0xc(%eax),%eax
  802e17:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802e1a:	eb 16                	jmp    802e32 <alloc_block_BF+0x49>
				else if(best_size >= element->size)
  802e1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1f:	8b 50 0c             	mov    0xc(%eax),%edx
  802e22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e25:	39 c2                	cmp    %eax,%edx
  802e27:	77 09                	ja     802e32 <alloc_block_BF+0x49>
					best_size=element->size;
  802e29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2c:	8b 40 0c             	mov    0xc(%eax),%eax
  802e2f:	89 45 f0             	mov    %eax,-0x10(%ebp)

struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802e32:	a1 40 51 80 00       	mov    0x805140,%eax
  802e37:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e3a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e3e:	74 07                	je     802e47 <alloc_block_BF+0x5e>
  802e40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e43:	8b 00                	mov    (%eax),%eax
  802e45:	eb 05                	jmp    802e4c <alloc_block_BF+0x63>
  802e47:	b8 00 00 00 00       	mov    $0x0,%eax
  802e4c:	a3 40 51 80 00       	mov    %eax,0x805140
  802e51:	a1 40 51 80 00       	mov    0x805140,%eax
  802e56:	85 c0                	test   %eax,%eax
  802e58:	75 a6                	jne    802e00 <alloc_block_BF+0x17>
  802e5a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e5e:	75 a0                	jne    802e00 <alloc_block_BF+0x17>
					best_size= element->size;
				else if(best_size >= element->size)
					best_size=element->size;
			}
		}
		if(best_size != -1)
  802e60:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802e64:	0f 84 d3 01 00 00    	je     80303d <alloc_block_BF+0x254>
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  802e6a:	a1 38 51 80 00       	mov    0x805138,%eax
  802e6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e72:	e9 98 01 00 00       	jmp    80300f <alloc_block_BF+0x226>
			{
			 if((best_size > size) && (best_size == element->size))
  802e77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e7a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e7d:	0f 86 da 00 00 00    	jbe    802f5d <alloc_block_BF+0x174>
  802e83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e86:	8b 50 0c             	mov    0xc(%eax),%edx
  802e89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e8c:	39 c2                	cmp    %eax,%edx
  802e8e:	0f 85 c9 00 00 00    	jne    802f5d <alloc_block_BF+0x174>
			  {
				// the new block are created
			    tmp_block = AvailableMemBlocksList.lh_first ;
  802e94:	a1 48 51 80 00       	mov    0x805148,%eax
  802e99:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  802e9c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ea0:	75 17                	jne    802eb9 <alloc_block_BF+0xd0>
  802ea2:	83 ec 04             	sub    $0x4,%esp
  802ea5:	68 bb 43 80 00       	push   $0x8043bb
  802eaa:	68 ea 00 00 00       	push   $0xea
  802eaf:	68 13 43 80 00       	push   $0x804313
  802eb4:	e8 fc db ff ff       	call   800ab5 <_panic>
  802eb9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ebc:	8b 00                	mov    (%eax),%eax
  802ebe:	85 c0                	test   %eax,%eax
  802ec0:	74 10                	je     802ed2 <alloc_block_BF+0xe9>
  802ec2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ec5:	8b 00                	mov    (%eax),%eax
  802ec7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802eca:	8b 52 04             	mov    0x4(%edx),%edx
  802ecd:	89 50 04             	mov    %edx,0x4(%eax)
  802ed0:	eb 0b                	jmp    802edd <alloc_block_BF+0xf4>
  802ed2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ed5:	8b 40 04             	mov    0x4(%eax),%eax
  802ed8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802edd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ee0:	8b 40 04             	mov    0x4(%eax),%eax
  802ee3:	85 c0                	test   %eax,%eax
  802ee5:	74 0f                	je     802ef6 <alloc_block_BF+0x10d>
  802ee7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eea:	8b 40 04             	mov    0x4(%eax),%eax
  802eed:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ef0:	8b 12                	mov    (%edx),%edx
  802ef2:	89 10                	mov    %edx,(%eax)
  802ef4:	eb 0a                	jmp    802f00 <alloc_block_BF+0x117>
  802ef6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ef9:	8b 00                	mov    (%eax),%eax
  802efb:	a3 48 51 80 00       	mov    %eax,0x805148
  802f00:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f03:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f09:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f0c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f13:	a1 54 51 80 00       	mov    0x805154,%eax
  802f18:	48                   	dec    %eax
  802f19:	a3 54 51 80 00       	mov    %eax,0x805154
				tmp_block->sva=element->sva;
  802f1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f21:	8b 50 08             	mov    0x8(%eax),%edx
  802f24:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f27:	89 50 08             	mov    %edx,0x8(%eax)
				tmp_block->size=size;
  802f2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f2d:	8b 55 08             	mov    0x8(%ebp),%edx
  802f30:	89 50 0c             	mov    %edx,0xc(%eax)
				//update block with remaining space
				element->size-=size;
  802f33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f36:	8b 40 0c             	mov    0xc(%eax),%eax
  802f39:	2b 45 08             	sub    0x8(%ebp),%eax
  802f3c:	89 c2                	mov    %eax,%edx
  802f3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f41:	89 50 0c             	mov    %edx,0xc(%eax)
				element->sva = element->sva + size;
  802f44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f47:	8b 50 08             	mov    0x8(%eax),%edx
  802f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4d:	01 c2                	add    %eax,%edx
  802f4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f52:	89 50 08             	mov    %edx,0x8(%eax)
				// return back the new block
				return tmp_block ;
  802f55:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f58:	e9 e5 00 00 00       	jmp    803042 <alloc_block_BF+0x259>

			  }
			else if((element->size == best_size)&&(best_size == size))
  802f5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f60:	8b 50 0c             	mov    0xc(%eax),%edx
  802f63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f66:	39 c2                	cmp    %eax,%edx
  802f68:	0f 85 99 00 00 00    	jne    803007 <alloc_block_BF+0x21e>
  802f6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f71:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f74:	0f 85 8d 00 00 00    	jne    803007 <alloc_block_BF+0x21e>
			  {
				tmp_block=element;
  802f7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7d:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&FreeMemBlocksList,element);
  802f80:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f84:	75 17                	jne    802f9d <alloc_block_BF+0x1b4>
  802f86:	83 ec 04             	sub    $0x4,%esp
  802f89:	68 bb 43 80 00       	push   $0x8043bb
  802f8e:	68 f7 00 00 00       	push   $0xf7
  802f93:	68 13 43 80 00       	push   $0x804313
  802f98:	e8 18 db ff ff       	call   800ab5 <_panic>
  802f9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa0:	8b 00                	mov    (%eax),%eax
  802fa2:	85 c0                	test   %eax,%eax
  802fa4:	74 10                	je     802fb6 <alloc_block_BF+0x1cd>
  802fa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa9:	8b 00                	mov    (%eax),%eax
  802fab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fae:	8b 52 04             	mov    0x4(%edx),%edx
  802fb1:	89 50 04             	mov    %edx,0x4(%eax)
  802fb4:	eb 0b                	jmp    802fc1 <alloc_block_BF+0x1d8>
  802fb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb9:	8b 40 04             	mov    0x4(%eax),%eax
  802fbc:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc4:	8b 40 04             	mov    0x4(%eax),%eax
  802fc7:	85 c0                	test   %eax,%eax
  802fc9:	74 0f                	je     802fda <alloc_block_BF+0x1f1>
  802fcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fce:	8b 40 04             	mov    0x4(%eax),%eax
  802fd1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fd4:	8b 12                	mov    (%edx),%edx
  802fd6:	89 10                	mov    %edx,(%eax)
  802fd8:	eb 0a                	jmp    802fe4 <alloc_block_BF+0x1fb>
  802fda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fdd:	8b 00                	mov    (%eax),%eax
  802fdf:	a3 38 51 80 00       	mov    %eax,0x805138
  802fe4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ff7:	a1 44 51 80 00       	mov    0x805144,%eax
  802ffc:	48                   	dec    %eax
  802ffd:	a3 44 51 80 00       	mov    %eax,0x805144
				return tmp_block;
  803002:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803005:	eb 3b                	jmp    803042 <alloc_block_BF+0x259>
					best_size=element->size;
			}
		}
		if(best_size != -1)
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  803007:	a1 40 51 80 00       	mov    0x805140,%eax
  80300c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80300f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803013:	74 07                	je     80301c <alloc_block_BF+0x233>
  803015:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803018:	8b 00                	mov    (%eax),%eax
  80301a:	eb 05                	jmp    803021 <alloc_block_BF+0x238>
  80301c:	b8 00 00 00 00       	mov    $0x0,%eax
  803021:	a3 40 51 80 00       	mov    %eax,0x805140
  803026:	a1 40 51 80 00       	mov    0x805140,%eax
  80302b:	85 c0                	test   %eax,%eax
  80302d:	0f 85 44 fe ff ff    	jne    802e77 <alloc_block_BF+0x8e>
  803033:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803037:	0f 85 3a fe ff ff    	jne    802e77 <alloc_block_BF+0x8e>
				LIST_REMOVE(&FreeMemBlocksList,element);
				return tmp_block;
			 }
			}
		}
		return NULL ;}
  80303d:	b8 00 00 00 00       	mov    $0x0,%eax
  803042:	c9                   	leave  
  803043:	c3                   	ret    

00803044 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  803044:	55                   	push   %ebp
  803045:	89 e5                	mov    %esp,%ebp
  803047:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  80304a:	83 ec 04             	sub    $0x4,%esp
  80304d:	68 dc 43 80 00       	push   $0x8043dc
  803052:	68 04 01 00 00       	push   $0x104
  803057:	68 13 43 80 00       	push   $0x804313
  80305c:	e8 54 da ff ff       	call   800ab5 <_panic>

00803061 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{struct MemBlock * blk_itr;
  803061:	55                   	push   %ebp
  803062:	89 e5                	mov    %esp,%ebp
  803064:	83 ec 18             	sub    $0x18,%esp
struct MemBlock * next;
struct MemBlock * first = LIST_FIRST(&(FreeMemBlocksList));
  803067:	a1 38 51 80 00       	mov    0x805138,%eax
  80306c:	89 45 f0             	mov    %eax,-0x10(%ebp)
struct MemBlock * last = LIST_LAST(&(FreeMemBlocksList));
  80306f:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803074:	89 45 ec             	mov    %eax,-0x14(%ebp)

if(LIST_EMPTY(&(FreeMemBlocksList)))
  803077:	a1 38 51 80 00       	mov    0x805138,%eax
  80307c:	85 c0                	test   %eax,%eax
  80307e:	75 68                	jne    8030e8 <insert_sorted_with_merge_freeList+0x87>
			{

				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  803080:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803084:	75 17                	jne    80309d <insert_sorted_with_merge_freeList+0x3c>
  803086:	83 ec 04             	sub    $0x4,%esp
  803089:	68 f0 42 80 00       	push   $0x8042f0
  80308e:	68 14 01 00 00       	push   $0x114
  803093:	68 13 43 80 00       	push   $0x804313
  803098:	e8 18 da ff ff       	call   800ab5 <_panic>
  80309d:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8030a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a6:	89 10                	mov    %edx,(%eax)
  8030a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ab:	8b 00                	mov    (%eax),%eax
  8030ad:	85 c0                	test   %eax,%eax
  8030af:	74 0d                	je     8030be <insert_sorted_with_merge_freeList+0x5d>
  8030b1:	a1 38 51 80 00       	mov    0x805138,%eax
  8030b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8030b9:	89 50 04             	mov    %edx,0x4(%eax)
  8030bc:	eb 08                	jmp    8030c6 <insert_sorted_with_merge_freeList+0x65>
  8030be:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c9:	a3 38 51 80 00       	mov    %eax,0x805138
  8030ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030d8:	a1 44 51 80 00       	mov    0x805144,%eax
  8030dd:	40                   	inc    %eax
  8030de:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  8030e3:	e9 d2 06 00 00       	jmp    8037ba <insert_sorted_with_merge_freeList+0x759>
				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);

			}
else
{
	if( blockToInsert->sva  < first->sva )
  8030e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030eb:	8b 50 08             	mov    0x8(%eax),%edx
  8030ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030f1:	8b 40 08             	mov    0x8(%eax),%eax
  8030f4:	39 c2                	cmp    %eax,%edx
  8030f6:	0f 83 22 01 00 00    	jae    80321e <insert_sorted_with_merge_freeList+0x1bd>
	{
                if( blockToInsert->sva + blockToInsert->size == first->sva)
  8030fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ff:	8b 50 08             	mov    0x8(%eax),%edx
  803102:	8b 45 08             	mov    0x8(%ebp),%eax
  803105:	8b 40 0c             	mov    0xc(%eax),%eax
  803108:	01 c2                	add    %eax,%edx
  80310a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80310d:	8b 40 08             	mov    0x8(%eax),%eax
  803110:	39 c2                	cmp    %eax,%edx
  803112:	0f 85 9e 00 00 00    	jne    8031b6 <insert_sorted_with_merge_freeList+0x155>
                {

                	first->sva = blockToInsert->sva;
  803118:	8b 45 08             	mov    0x8(%ebp),%eax
  80311b:	8b 50 08             	mov    0x8(%eax),%edx
  80311e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803121:	89 50 08             	mov    %edx,0x8(%eax)
                	first->size = first->size + blockToInsert->size;
  803124:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803127:	8b 50 0c             	mov    0xc(%eax),%edx
  80312a:	8b 45 08             	mov    0x8(%ebp),%eax
  80312d:	8b 40 0c             	mov    0xc(%eax),%eax
  803130:	01 c2                	add    %eax,%edx
  803132:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803135:	89 50 0c             	mov    %edx,0xc(%eax)
                	blockToInsert->size = blockToInsert->sva = 0;
  803138:	8b 45 08             	mov    0x8(%ebp),%eax
  80313b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803142:	8b 45 08             	mov    0x8(%ebp),%eax
  803145:	8b 50 08             	mov    0x8(%eax),%edx
  803148:	8b 45 08             	mov    0x8(%ebp),%eax
  80314b:	89 50 0c             	mov    %edx,0xc(%eax)
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  80314e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803152:	75 17                	jne    80316b <insert_sorted_with_merge_freeList+0x10a>
  803154:	83 ec 04             	sub    $0x4,%esp
  803157:	68 f0 42 80 00       	push   $0x8042f0
  80315c:	68 21 01 00 00       	push   $0x121
  803161:	68 13 43 80 00       	push   $0x804313
  803166:	e8 4a d9 ff ff       	call   800ab5 <_panic>
  80316b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803171:	8b 45 08             	mov    0x8(%ebp),%eax
  803174:	89 10                	mov    %edx,(%eax)
  803176:	8b 45 08             	mov    0x8(%ebp),%eax
  803179:	8b 00                	mov    (%eax),%eax
  80317b:	85 c0                	test   %eax,%eax
  80317d:	74 0d                	je     80318c <insert_sorted_with_merge_freeList+0x12b>
  80317f:	a1 48 51 80 00       	mov    0x805148,%eax
  803184:	8b 55 08             	mov    0x8(%ebp),%edx
  803187:	89 50 04             	mov    %edx,0x4(%eax)
  80318a:	eb 08                	jmp    803194 <insert_sorted_with_merge_freeList+0x133>
  80318c:	8b 45 08             	mov    0x8(%ebp),%eax
  80318f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803194:	8b 45 08             	mov    0x8(%ebp),%eax
  803197:	a3 48 51 80 00       	mov    %eax,0x805148
  80319c:	8b 45 08             	mov    0x8(%ebp),%eax
  80319f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031a6:	a1 54 51 80 00       	mov    0x805154,%eax
  8031ab:	40                   	inc    %eax
  8031ac:	a3 54 51 80 00       	mov    %eax,0x805154
						}
				}
        }

}
}
  8031b1:	e9 04 06 00 00       	jmp    8037ba <insert_sorted_with_merge_freeList+0x759>
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
                }

                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  8031b6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031ba:	75 17                	jne    8031d3 <insert_sorted_with_merge_freeList+0x172>
  8031bc:	83 ec 04             	sub    $0x4,%esp
  8031bf:	68 f0 42 80 00       	push   $0x8042f0
  8031c4:	68 26 01 00 00       	push   $0x126
  8031c9:	68 13 43 80 00       	push   $0x804313
  8031ce:	e8 e2 d8 ff ff       	call   800ab5 <_panic>
  8031d3:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8031d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031dc:	89 10                	mov    %edx,(%eax)
  8031de:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e1:	8b 00                	mov    (%eax),%eax
  8031e3:	85 c0                	test   %eax,%eax
  8031e5:	74 0d                	je     8031f4 <insert_sorted_with_merge_freeList+0x193>
  8031e7:	a1 38 51 80 00       	mov    0x805138,%eax
  8031ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8031ef:	89 50 04             	mov    %edx,0x4(%eax)
  8031f2:	eb 08                	jmp    8031fc <insert_sorted_with_merge_freeList+0x19b>
  8031f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ff:	a3 38 51 80 00       	mov    %eax,0x805138
  803204:	8b 45 08             	mov    0x8(%ebp),%eax
  803207:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80320e:	a1 44 51 80 00       	mov    0x805144,%eax
  803213:	40                   	inc    %eax
  803214:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  803219:	e9 9c 05 00 00       	jmp    8037ba <insert_sorted_with_merge_freeList+0x759>
                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
                }
	}
    else if(blockToInsert->sva > last->sva)
  80321e:	8b 45 08             	mov    0x8(%ebp),%eax
  803221:	8b 50 08             	mov    0x8(%eax),%edx
  803224:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803227:	8b 40 08             	mov    0x8(%eax),%eax
  80322a:	39 c2                	cmp    %eax,%edx
  80322c:	0f 86 16 01 00 00    	jbe    803348 <insert_sorted_with_merge_freeList+0x2e7>
 	{

				if(last->sva + last->size == blockToInsert->sva)
  803232:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803235:	8b 50 08             	mov    0x8(%eax),%edx
  803238:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80323b:	8b 40 0c             	mov    0xc(%eax),%eax
  80323e:	01 c2                	add    %eax,%edx
  803240:	8b 45 08             	mov    0x8(%ebp),%eax
  803243:	8b 40 08             	mov    0x8(%eax),%eax
  803246:	39 c2                	cmp    %eax,%edx
  803248:	0f 85 92 00 00 00    	jne    8032e0 <insert_sorted_with_merge_freeList+0x27f>
				{

					last->size = last->size + blockToInsert->size;
  80324e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803251:	8b 50 0c             	mov    0xc(%eax),%edx
  803254:	8b 45 08             	mov    0x8(%ebp),%eax
  803257:	8b 40 0c             	mov    0xc(%eax),%eax
  80325a:	01 c2                	add    %eax,%edx
  80325c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80325f:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->size = blockToInsert->sva = 0;
  803262:	8b 45 08             	mov    0x8(%ebp),%eax
  803265:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80326c:	8b 45 08             	mov    0x8(%ebp),%eax
  80326f:	8b 50 08             	mov    0x8(%eax),%edx
  803272:	8b 45 08             	mov    0x8(%ebp),%eax
  803275:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  803278:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80327c:	75 17                	jne    803295 <insert_sorted_with_merge_freeList+0x234>
  80327e:	83 ec 04             	sub    $0x4,%esp
  803281:	68 f0 42 80 00       	push   $0x8042f0
  803286:	68 31 01 00 00       	push   $0x131
  80328b:	68 13 43 80 00       	push   $0x804313
  803290:	e8 20 d8 ff ff       	call   800ab5 <_panic>
  803295:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80329b:	8b 45 08             	mov    0x8(%ebp),%eax
  80329e:	89 10                	mov    %edx,(%eax)
  8032a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a3:	8b 00                	mov    (%eax),%eax
  8032a5:	85 c0                	test   %eax,%eax
  8032a7:	74 0d                	je     8032b6 <insert_sorted_with_merge_freeList+0x255>
  8032a9:	a1 48 51 80 00       	mov    0x805148,%eax
  8032ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8032b1:	89 50 04             	mov    %edx,0x4(%eax)
  8032b4:	eb 08                	jmp    8032be <insert_sorted_with_merge_freeList+0x25d>
  8032b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032be:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c1:	a3 48 51 80 00       	mov    %eax,0x805148
  8032c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032d0:	a1 54 51 80 00       	mov    0x805154,%eax
  8032d5:	40                   	inc    %eax
  8032d6:	a3 54 51 80 00       	mov    %eax,0x805154
						}
				}
        }

}
}
  8032db:	e9 da 04 00 00       	jmp    8037ba <insert_sorted_with_merge_freeList+0x759>

				}

				else
				{
					LIST_INSERT_TAIL(&(FreeMemBlocksList),  blockToInsert);
  8032e0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032e4:	75 17                	jne    8032fd <insert_sorted_with_merge_freeList+0x29c>
  8032e6:	83 ec 04             	sub    $0x4,%esp
  8032e9:	68 98 43 80 00       	push   $0x804398
  8032ee:	68 37 01 00 00       	push   $0x137
  8032f3:	68 13 43 80 00       	push   $0x804313
  8032f8:	e8 b8 d7 ff ff       	call   800ab5 <_panic>
  8032fd:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803303:	8b 45 08             	mov    0x8(%ebp),%eax
  803306:	89 50 04             	mov    %edx,0x4(%eax)
  803309:	8b 45 08             	mov    0x8(%ebp),%eax
  80330c:	8b 40 04             	mov    0x4(%eax),%eax
  80330f:	85 c0                	test   %eax,%eax
  803311:	74 0c                	je     80331f <insert_sorted_with_merge_freeList+0x2be>
  803313:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803318:	8b 55 08             	mov    0x8(%ebp),%edx
  80331b:	89 10                	mov    %edx,(%eax)
  80331d:	eb 08                	jmp    803327 <insert_sorted_with_merge_freeList+0x2c6>
  80331f:	8b 45 08             	mov    0x8(%ebp),%eax
  803322:	a3 38 51 80 00       	mov    %eax,0x805138
  803327:	8b 45 08             	mov    0x8(%ebp),%eax
  80332a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80332f:	8b 45 08             	mov    0x8(%ebp),%eax
  803332:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803338:	a1 44 51 80 00       	mov    0x805144,%eax
  80333d:	40                   	inc    %eax
  80333e:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  803343:	e9 72 04 00 00       	jmp    8037ba <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  803348:	a1 38 51 80 00       	mov    0x805138,%eax
  80334d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803350:	e9 35 04 00 00       	jmp    80378a <insert_sorted_with_merge_freeList+0x729>
				{
				     next=LIST_NEXT(blk_itr);
  803355:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803358:	8b 00                	mov    (%eax),%eax
  80335a:	89 45 e8             	mov    %eax,-0x18(%ebp)


					if( (blockToInsert->sva > blk_itr->sva) )
  80335d:	8b 45 08             	mov    0x8(%ebp),%eax
  803360:	8b 50 08             	mov    0x8(%eax),%edx
  803363:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803366:	8b 40 08             	mov    0x8(%eax),%eax
  803369:	39 c2                	cmp    %eax,%edx
  80336b:	0f 86 11 04 00 00    	jbe    803782 <insert_sorted_with_merge_freeList+0x721>
						{
							if(((blk_itr->sva) + (blk_itr->size) < blockToInsert->sva && (blockToInsert->sva) + (blockToInsert->size) < next->sva))
  803371:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803374:	8b 50 08             	mov    0x8(%eax),%edx
  803377:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80337a:	8b 40 0c             	mov    0xc(%eax),%eax
  80337d:	01 c2                	add    %eax,%edx
  80337f:	8b 45 08             	mov    0x8(%ebp),%eax
  803382:	8b 40 08             	mov    0x8(%eax),%eax
  803385:	39 c2                	cmp    %eax,%edx
  803387:	0f 83 8b 00 00 00    	jae    803418 <insert_sorted_with_merge_freeList+0x3b7>
  80338d:	8b 45 08             	mov    0x8(%ebp),%eax
  803390:	8b 50 08             	mov    0x8(%eax),%edx
  803393:	8b 45 08             	mov    0x8(%ebp),%eax
  803396:	8b 40 0c             	mov    0xc(%eax),%eax
  803399:	01 c2                	add    %eax,%edx
  80339b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80339e:	8b 40 08             	mov    0x8(%eax),%eax
  8033a1:	39 c2                	cmp    %eax,%edx
  8033a3:	73 73                	jae    803418 <insert_sorted_with_merge_freeList+0x3b7>
							{
								LIST_INSERT_AFTER(&(FreeMemBlocksList), blk_itr, blockToInsert);
  8033a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033a9:	74 06                	je     8033b1 <insert_sorted_with_merge_freeList+0x350>
  8033ab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033af:	75 17                	jne    8033c8 <insert_sorted_with_merge_freeList+0x367>
  8033b1:	83 ec 04             	sub    $0x4,%esp
  8033b4:	68 64 43 80 00       	push   $0x804364
  8033b9:	68 48 01 00 00       	push   $0x148
  8033be:	68 13 43 80 00       	push   $0x804313
  8033c3:	e8 ed d6 ff ff       	call   800ab5 <_panic>
  8033c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033cb:	8b 10                	mov    (%eax),%edx
  8033cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d0:	89 10                	mov    %edx,(%eax)
  8033d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d5:	8b 00                	mov    (%eax),%eax
  8033d7:	85 c0                	test   %eax,%eax
  8033d9:	74 0b                	je     8033e6 <insert_sorted_with_merge_freeList+0x385>
  8033db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033de:	8b 00                	mov    (%eax),%eax
  8033e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8033e3:	89 50 04             	mov    %edx,0x4(%eax)
  8033e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8033ec:	89 10                	mov    %edx,(%eax)
  8033ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033f4:	89 50 04             	mov    %edx,0x4(%eax)
  8033f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033fa:	8b 00                	mov    (%eax),%eax
  8033fc:	85 c0                	test   %eax,%eax
  8033fe:	75 08                	jne    803408 <insert_sorted_with_merge_freeList+0x3a7>
  803400:	8b 45 08             	mov    0x8(%ebp),%eax
  803403:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803408:	a1 44 51 80 00       	mov    0x805144,%eax
  80340d:	40                   	inc    %eax
  80340e:	a3 44 51 80 00       	mov    %eax,0x805144
								break;
  803413:	e9 a2 03 00 00       	jmp    8037ba <insert_sorted_with_merge_freeList+0x759>

							}
							else if((blockToInsert->sva + blockToInsert->size) < next->sva  && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  803418:	8b 45 08             	mov    0x8(%ebp),%eax
  80341b:	8b 50 08             	mov    0x8(%eax),%edx
  80341e:	8b 45 08             	mov    0x8(%ebp),%eax
  803421:	8b 40 0c             	mov    0xc(%eax),%eax
  803424:	01 c2                	add    %eax,%edx
  803426:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803429:	8b 40 08             	mov    0x8(%eax),%eax
  80342c:	39 c2                	cmp    %eax,%edx
  80342e:	0f 83 ae 00 00 00    	jae    8034e2 <insert_sorted_with_merge_freeList+0x481>
  803434:	8b 45 08             	mov    0x8(%ebp),%eax
  803437:	8b 50 08             	mov    0x8(%eax),%edx
  80343a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80343d:	8b 48 08             	mov    0x8(%eax),%ecx
  803440:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803443:	8b 40 0c             	mov    0xc(%eax),%eax
  803446:	01 c8                	add    %ecx,%eax
  803448:	39 c2                	cmp    %eax,%edx
  80344a:	0f 85 92 00 00 00    	jne    8034e2 <insert_sorted_with_merge_freeList+0x481>
							{

								blk_itr->size=blk_itr->size+blockToInsert->size;
  803450:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803453:	8b 50 0c             	mov    0xc(%eax),%edx
  803456:	8b 45 08             	mov    0x8(%ebp),%eax
  803459:	8b 40 0c             	mov    0xc(%eax),%eax
  80345c:	01 c2                	add    %eax,%edx
  80345e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803461:	89 50 0c             	mov    %edx,0xc(%eax)
								 blockToInsert->size=blockToInsert->sva=0;
  803464:	8b 45 08             	mov    0x8(%ebp),%eax
  803467:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80346e:	8b 45 08             	mov    0x8(%ebp),%eax
  803471:	8b 50 08             	mov    0x8(%eax),%edx
  803474:	8b 45 08             	mov    0x8(%ebp),%eax
  803477:	89 50 0c             	mov    %edx,0xc(%eax)
								 LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  80347a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80347e:	75 17                	jne    803497 <insert_sorted_with_merge_freeList+0x436>
  803480:	83 ec 04             	sub    $0x4,%esp
  803483:	68 f0 42 80 00       	push   $0x8042f0
  803488:	68 51 01 00 00       	push   $0x151
  80348d:	68 13 43 80 00       	push   $0x804313
  803492:	e8 1e d6 ff ff       	call   800ab5 <_panic>
  803497:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80349d:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a0:	89 10                	mov    %edx,(%eax)
  8034a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a5:	8b 00                	mov    (%eax),%eax
  8034a7:	85 c0                	test   %eax,%eax
  8034a9:	74 0d                	je     8034b8 <insert_sorted_with_merge_freeList+0x457>
  8034ab:	a1 48 51 80 00       	mov    0x805148,%eax
  8034b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8034b3:	89 50 04             	mov    %edx,0x4(%eax)
  8034b6:	eb 08                	jmp    8034c0 <insert_sorted_with_merge_freeList+0x45f>
  8034b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8034bb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c3:	a3 48 51 80 00       	mov    %eax,0x805148
  8034c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8034cb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034d2:	a1 54 51 80 00       	mov    0x805154,%eax
  8034d7:	40                   	inc    %eax
  8034d8:	a3 54 51 80 00       	mov    %eax,0x805154
								 break;
  8034dd:	e9 d8 02 00 00       	jmp    8037ba <insert_sorted_with_merge_freeList+0x759>

							}
							else if( (blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva > (blk_itr->sva + blk_itr->size))
  8034e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e5:	8b 50 08             	mov    0x8(%eax),%edx
  8034e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8034eb:	8b 40 0c             	mov    0xc(%eax),%eax
  8034ee:	01 c2                	add    %eax,%edx
  8034f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034f3:	8b 40 08             	mov    0x8(%eax),%eax
  8034f6:	39 c2                	cmp    %eax,%edx
  8034f8:	0f 85 ba 00 00 00    	jne    8035b8 <insert_sorted_with_merge_freeList+0x557>
  8034fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803501:	8b 50 08             	mov    0x8(%eax),%edx
  803504:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803507:	8b 48 08             	mov    0x8(%eax),%ecx
  80350a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80350d:	8b 40 0c             	mov    0xc(%eax),%eax
  803510:	01 c8                	add    %ecx,%eax
  803512:	39 c2                	cmp    %eax,%edx
  803514:	0f 86 9e 00 00 00    	jbe    8035b8 <insert_sorted_with_merge_freeList+0x557>
							{
								next->size = next->size + blockToInsert->size;
  80351a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80351d:	8b 50 0c             	mov    0xc(%eax),%edx
  803520:	8b 45 08             	mov    0x8(%ebp),%eax
  803523:	8b 40 0c             	mov    0xc(%eax),%eax
  803526:	01 c2                	add    %eax,%edx
  803528:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80352b:	89 50 0c             	mov    %edx,0xc(%eax)
								next->sva = blockToInsert->sva;
  80352e:	8b 45 08             	mov    0x8(%ebp),%eax
  803531:	8b 50 08             	mov    0x8(%eax),%edx
  803534:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803537:	89 50 08             	mov    %edx,0x8(%eax)

								blockToInsert->size = blockToInsert->sva = 0;
  80353a:	8b 45 08             	mov    0x8(%ebp),%eax
  80353d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803544:	8b 45 08             	mov    0x8(%ebp),%eax
  803547:	8b 50 08             	mov    0x8(%eax),%edx
  80354a:	8b 45 08             	mov    0x8(%ebp),%eax
  80354d:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  803550:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803554:	75 17                	jne    80356d <insert_sorted_with_merge_freeList+0x50c>
  803556:	83 ec 04             	sub    $0x4,%esp
  803559:	68 f0 42 80 00       	push   $0x8042f0
  80355e:	68 5b 01 00 00       	push   $0x15b
  803563:	68 13 43 80 00       	push   $0x804313
  803568:	e8 48 d5 ff ff       	call   800ab5 <_panic>
  80356d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803573:	8b 45 08             	mov    0x8(%ebp),%eax
  803576:	89 10                	mov    %edx,(%eax)
  803578:	8b 45 08             	mov    0x8(%ebp),%eax
  80357b:	8b 00                	mov    (%eax),%eax
  80357d:	85 c0                	test   %eax,%eax
  80357f:	74 0d                	je     80358e <insert_sorted_with_merge_freeList+0x52d>
  803581:	a1 48 51 80 00       	mov    0x805148,%eax
  803586:	8b 55 08             	mov    0x8(%ebp),%edx
  803589:	89 50 04             	mov    %edx,0x4(%eax)
  80358c:	eb 08                	jmp    803596 <insert_sorted_with_merge_freeList+0x535>
  80358e:	8b 45 08             	mov    0x8(%ebp),%eax
  803591:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803596:	8b 45 08             	mov    0x8(%ebp),%eax
  803599:	a3 48 51 80 00       	mov    %eax,0x805148
  80359e:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035a8:	a1 54 51 80 00       	mov    0x805154,%eax
  8035ad:	40                   	inc    %eax
  8035ae:	a3 54 51 80 00       	mov    %eax,0x805154
								break;
  8035b3:	e9 02 02 00 00       	jmp    8037ba <insert_sorted_with_merge_freeList+0x759>
							}
							else if ((blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  8035b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8035bb:	8b 50 08             	mov    0x8(%eax),%edx
  8035be:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8035c4:	01 c2                	add    %eax,%edx
  8035c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035c9:	8b 40 08             	mov    0x8(%eax),%eax
  8035cc:	39 c2                	cmp    %eax,%edx
  8035ce:	0f 85 ae 01 00 00    	jne    803782 <insert_sorted_with_merge_freeList+0x721>
  8035d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d7:	8b 50 08             	mov    0x8(%eax),%edx
  8035da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035dd:	8b 48 08             	mov    0x8(%eax),%ecx
  8035e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035e3:	8b 40 0c             	mov    0xc(%eax),%eax
  8035e6:	01 c8                	add    %ecx,%eax
  8035e8:	39 c2                	cmp    %eax,%edx
  8035ea:	0f 85 92 01 00 00    	jne    803782 <insert_sorted_with_merge_freeList+0x721>
							{
								blk_itr->size = blk_itr->size + blockToInsert->size + next->size;
  8035f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035f3:	8b 50 0c             	mov    0xc(%eax),%edx
  8035f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f9:	8b 40 0c             	mov    0xc(%eax),%eax
  8035fc:	01 c2                	add    %eax,%edx
  8035fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803601:	8b 40 0c             	mov    0xc(%eax),%eax
  803604:	01 c2                	add    %eax,%edx
  803606:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803609:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size = blockToInsert->sva=0;
  80360c:	8b 45 08             	mov    0x8(%ebp),%eax
  80360f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803616:	8b 45 08             	mov    0x8(%ebp),%eax
  803619:	8b 50 08             	mov    0x8(%eax),%edx
  80361c:	8b 45 08             	mov    0x8(%ebp),%eax
  80361f:	89 50 0c             	mov    %edx,0xc(%eax)
								next->size = next->sva = 0;
  803622:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803625:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80362c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80362f:	8b 50 08             	mov    0x8(%eax),%edx
  803632:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803635:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_REMOVE(&FreeMemBlocksList, next);
  803638:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80363c:	75 17                	jne    803655 <insert_sorted_with_merge_freeList+0x5f4>
  80363e:	83 ec 04             	sub    $0x4,%esp
  803641:	68 bb 43 80 00       	push   $0x8043bb
  803646:	68 63 01 00 00       	push   $0x163
  80364b:	68 13 43 80 00       	push   $0x804313
  803650:	e8 60 d4 ff ff       	call   800ab5 <_panic>
  803655:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803658:	8b 00                	mov    (%eax),%eax
  80365a:	85 c0                	test   %eax,%eax
  80365c:	74 10                	je     80366e <insert_sorted_with_merge_freeList+0x60d>
  80365e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803661:	8b 00                	mov    (%eax),%eax
  803663:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803666:	8b 52 04             	mov    0x4(%edx),%edx
  803669:	89 50 04             	mov    %edx,0x4(%eax)
  80366c:	eb 0b                	jmp    803679 <insert_sorted_with_merge_freeList+0x618>
  80366e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803671:	8b 40 04             	mov    0x4(%eax),%eax
  803674:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803679:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80367c:	8b 40 04             	mov    0x4(%eax),%eax
  80367f:	85 c0                	test   %eax,%eax
  803681:	74 0f                	je     803692 <insert_sorted_with_merge_freeList+0x631>
  803683:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803686:	8b 40 04             	mov    0x4(%eax),%eax
  803689:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80368c:	8b 12                	mov    (%edx),%edx
  80368e:	89 10                	mov    %edx,(%eax)
  803690:	eb 0a                	jmp    80369c <insert_sorted_with_merge_freeList+0x63b>
  803692:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803695:	8b 00                	mov    (%eax),%eax
  803697:	a3 38 51 80 00       	mov    %eax,0x805138
  80369c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80369f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036a8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036af:	a1 44 51 80 00       	mov    0x805144,%eax
  8036b4:	48                   	dec    %eax
  8036b5:	a3 44 51 80 00       	mov    %eax,0x805144
								LIST_INSERT_HEAD(&AvailableMemBlocksList, next );
  8036ba:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8036be:	75 17                	jne    8036d7 <insert_sorted_with_merge_freeList+0x676>
  8036c0:	83 ec 04             	sub    $0x4,%esp
  8036c3:	68 f0 42 80 00       	push   $0x8042f0
  8036c8:	68 64 01 00 00       	push   $0x164
  8036cd:	68 13 43 80 00       	push   $0x804313
  8036d2:	e8 de d3 ff ff       	call   800ab5 <_panic>
  8036d7:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8036dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036e0:	89 10                	mov    %edx,(%eax)
  8036e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036e5:	8b 00                	mov    (%eax),%eax
  8036e7:	85 c0                	test   %eax,%eax
  8036e9:	74 0d                	je     8036f8 <insert_sorted_with_merge_freeList+0x697>
  8036eb:	a1 48 51 80 00       	mov    0x805148,%eax
  8036f0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036f3:	89 50 04             	mov    %edx,0x4(%eax)
  8036f6:	eb 08                	jmp    803700 <insert_sorted_with_merge_freeList+0x69f>
  8036f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036fb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803700:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803703:	a3 48 51 80 00       	mov    %eax,0x805148
  803708:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80370b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803712:	a1 54 51 80 00       	mov    0x805154,%eax
  803717:	40                   	inc    %eax
  803718:	a3 54 51 80 00       	mov    %eax,0x805154
							    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  80371d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803721:	75 17                	jne    80373a <insert_sorted_with_merge_freeList+0x6d9>
  803723:	83 ec 04             	sub    $0x4,%esp
  803726:	68 f0 42 80 00       	push   $0x8042f0
  80372b:	68 65 01 00 00       	push   $0x165
  803730:	68 13 43 80 00       	push   $0x804313
  803735:	e8 7b d3 ff ff       	call   800ab5 <_panic>
  80373a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803740:	8b 45 08             	mov    0x8(%ebp),%eax
  803743:	89 10                	mov    %edx,(%eax)
  803745:	8b 45 08             	mov    0x8(%ebp),%eax
  803748:	8b 00                	mov    (%eax),%eax
  80374a:	85 c0                	test   %eax,%eax
  80374c:	74 0d                	je     80375b <insert_sorted_with_merge_freeList+0x6fa>
  80374e:	a1 48 51 80 00       	mov    0x805148,%eax
  803753:	8b 55 08             	mov    0x8(%ebp),%edx
  803756:	89 50 04             	mov    %edx,0x4(%eax)
  803759:	eb 08                	jmp    803763 <insert_sorted_with_merge_freeList+0x702>
  80375b:	8b 45 08             	mov    0x8(%ebp),%eax
  80375e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803763:	8b 45 08             	mov    0x8(%ebp),%eax
  803766:	a3 48 51 80 00       	mov    %eax,0x805148
  80376b:	8b 45 08             	mov    0x8(%ebp),%eax
  80376e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803775:	a1 54 51 80 00       	mov    0x805154,%eax
  80377a:	40                   	inc    %eax
  80377b:	a3 54 51 80 00       	mov    %eax,0x805154
								break;
  803780:	eb 38                	jmp    8037ba <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  803782:	a1 40 51 80 00       	mov    0x805140,%eax
  803787:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80378a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80378e:	74 07                	je     803797 <insert_sorted_with_merge_freeList+0x736>
  803790:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803793:	8b 00                	mov    (%eax),%eax
  803795:	eb 05                	jmp    80379c <insert_sorted_with_merge_freeList+0x73b>
  803797:	b8 00 00 00 00       	mov    $0x0,%eax
  80379c:	a3 40 51 80 00       	mov    %eax,0x805140
  8037a1:	a1 40 51 80 00       	mov    0x805140,%eax
  8037a6:	85 c0                	test   %eax,%eax
  8037a8:	0f 85 a7 fb ff ff    	jne    803355 <insert_sorted_with_merge_freeList+0x2f4>
  8037ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037b2:	0f 85 9d fb ff ff    	jne    803355 <insert_sorted_with_merge_freeList+0x2f4>
						}
				}
        }

}
}
  8037b8:	eb 00                	jmp    8037ba <insert_sorted_with_merge_freeList+0x759>
  8037ba:	90                   	nop
  8037bb:	c9                   	leave  
  8037bc:	c3                   	ret    
  8037bd:	66 90                	xchg   %ax,%ax
  8037bf:	90                   	nop

008037c0 <__udivdi3>:
  8037c0:	55                   	push   %ebp
  8037c1:	57                   	push   %edi
  8037c2:	56                   	push   %esi
  8037c3:	53                   	push   %ebx
  8037c4:	83 ec 1c             	sub    $0x1c,%esp
  8037c7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8037cb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8037cf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8037d3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8037d7:	89 ca                	mov    %ecx,%edx
  8037d9:	89 f8                	mov    %edi,%eax
  8037db:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8037df:	85 f6                	test   %esi,%esi
  8037e1:	75 2d                	jne    803810 <__udivdi3+0x50>
  8037e3:	39 cf                	cmp    %ecx,%edi
  8037e5:	77 65                	ja     80384c <__udivdi3+0x8c>
  8037e7:	89 fd                	mov    %edi,%ebp
  8037e9:	85 ff                	test   %edi,%edi
  8037eb:	75 0b                	jne    8037f8 <__udivdi3+0x38>
  8037ed:	b8 01 00 00 00       	mov    $0x1,%eax
  8037f2:	31 d2                	xor    %edx,%edx
  8037f4:	f7 f7                	div    %edi
  8037f6:	89 c5                	mov    %eax,%ebp
  8037f8:	31 d2                	xor    %edx,%edx
  8037fa:	89 c8                	mov    %ecx,%eax
  8037fc:	f7 f5                	div    %ebp
  8037fe:	89 c1                	mov    %eax,%ecx
  803800:	89 d8                	mov    %ebx,%eax
  803802:	f7 f5                	div    %ebp
  803804:	89 cf                	mov    %ecx,%edi
  803806:	89 fa                	mov    %edi,%edx
  803808:	83 c4 1c             	add    $0x1c,%esp
  80380b:	5b                   	pop    %ebx
  80380c:	5e                   	pop    %esi
  80380d:	5f                   	pop    %edi
  80380e:	5d                   	pop    %ebp
  80380f:	c3                   	ret    
  803810:	39 ce                	cmp    %ecx,%esi
  803812:	77 28                	ja     80383c <__udivdi3+0x7c>
  803814:	0f bd fe             	bsr    %esi,%edi
  803817:	83 f7 1f             	xor    $0x1f,%edi
  80381a:	75 40                	jne    80385c <__udivdi3+0x9c>
  80381c:	39 ce                	cmp    %ecx,%esi
  80381e:	72 0a                	jb     80382a <__udivdi3+0x6a>
  803820:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803824:	0f 87 9e 00 00 00    	ja     8038c8 <__udivdi3+0x108>
  80382a:	b8 01 00 00 00       	mov    $0x1,%eax
  80382f:	89 fa                	mov    %edi,%edx
  803831:	83 c4 1c             	add    $0x1c,%esp
  803834:	5b                   	pop    %ebx
  803835:	5e                   	pop    %esi
  803836:	5f                   	pop    %edi
  803837:	5d                   	pop    %ebp
  803838:	c3                   	ret    
  803839:	8d 76 00             	lea    0x0(%esi),%esi
  80383c:	31 ff                	xor    %edi,%edi
  80383e:	31 c0                	xor    %eax,%eax
  803840:	89 fa                	mov    %edi,%edx
  803842:	83 c4 1c             	add    $0x1c,%esp
  803845:	5b                   	pop    %ebx
  803846:	5e                   	pop    %esi
  803847:	5f                   	pop    %edi
  803848:	5d                   	pop    %ebp
  803849:	c3                   	ret    
  80384a:	66 90                	xchg   %ax,%ax
  80384c:	89 d8                	mov    %ebx,%eax
  80384e:	f7 f7                	div    %edi
  803850:	31 ff                	xor    %edi,%edi
  803852:	89 fa                	mov    %edi,%edx
  803854:	83 c4 1c             	add    $0x1c,%esp
  803857:	5b                   	pop    %ebx
  803858:	5e                   	pop    %esi
  803859:	5f                   	pop    %edi
  80385a:	5d                   	pop    %ebp
  80385b:	c3                   	ret    
  80385c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803861:	89 eb                	mov    %ebp,%ebx
  803863:	29 fb                	sub    %edi,%ebx
  803865:	89 f9                	mov    %edi,%ecx
  803867:	d3 e6                	shl    %cl,%esi
  803869:	89 c5                	mov    %eax,%ebp
  80386b:	88 d9                	mov    %bl,%cl
  80386d:	d3 ed                	shr    %cl,%ebp
  80386f:	89 e9                	mov    %ebp,%ecx
  803871:	09 f1                	or     %esi,%ecx
  803873:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803877:	89 f9                	mov    %edi,%ecx
  803879:	d3 e0                	shl    %cl,%eax
  80387b:	89 c5                	mov    %eax,%ebp
  80387d:	89 d6                	mov    %edx,%esi
  80387f:	88 d9                	mov    %bl,%cl
  803881:	d3 ee                	shr    %cl,%esi
  803883:	89 f9                	mov    %edi,%ecx
  803885:	d3 e2                	shl    %cl,%edx
  803887:	8b 44 24 08          	mov    0x8(%esp),%eax
  80388b:	88 d9                	mov    %bl,%cl
  80388d:	d3 e8                	shr    %cl,%eax
  80388f:	09 c2                	or     %eax,%edx
  803891:	89 d0                	mov    %edx,%eax
  803893:	89 f2                	mov    %esi,%edx
  803895:	f7 74 24 0c          	divl   0xc(%esp)
  803899:	89 d6                	mov    %edx,%esi
  80389b:	89 c3                	mov    %eax,%ebx
  80389d:	f7 e5                	mul    %ebp
  80389f:	39 d6                	cmp    %edx,%esi
  8038a1:	72 19                	jb     8038bc <__udivdi3+0xfc>
  8038a3:	74 0b                	je     8038b0 <__udivdi3+0xf0>
  8038a5:	89 d8                	mov    %ebx,%eax
  8038a7:	31 ff                	xor    %edi,%edi
  8038a9:	e9 58 ff ff ff       	jmp    803806 <__udivdi3+0x46>
  8038ae:	66 90                	xchg   %ax,%ax
  8038b0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8038b4:	89 f9                	mov    %edi,%ecx
  8038b6:	d3 e2                	shl    %cl,%edx
  8038b8:	39 c2                	cmp    %eax,%edx
  8038ba:	73 e9                	jae    8038a5 <__udivdi3+0xe5>
  8038bc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8038bf:	31 ff                	xor    %edi,%edi
  8038c1:	e9 40 ff ff ff       	jmp    803806 <__udivdi3+0x46>
  8038c6:	66 90                	xchg   %ax,%ax
  8038c8:	31 c0                	xor    %eax,%eax
  8038ca:	e9 37 ff ff ff       	jmp    803806 <__udivdi3+0x46>
  8038cf:	90                   	nop

008038d0 <__umoddi3>:
  8038d0:	55                   	push   %ebp
  8038d1:	57                   	push   %edi
  8038d2:	56                   	push   %esi
  8038d3:	53                   	push   %ebx
  8038d4:	83 ec 1c             	sub    $0x1c,%esp
  8038d7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8038db:	8b 74 24 34          	mov    0x34(%esp),%esi
  8038df:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8038e3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8038e7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8038eb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8038ef:	89 f3                	mov    %esi,%ebx
  8038f1:	89 fa                	mov    %edi,%edx
  8038f3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8038f7:	89 34 24             	mov    %esi,(%esp)
  8038fa:	85 c0                	test   %eax,%eax
  8038fc:	75 1a                	jne    803918 <__umoddi3+0x48>
  8038fe:	39 f7                	cmp    %esi,%edi
  803900:	0f 86 a2 00 00 00    	jbe    8039a8 <__umoddi3+0xd8>
  803906:	89 c8                	mov    %ecx,%eax
  803908:	89 f2                	mov    %esi,%edx
  80390a:	f7 f7                	div    %edi
  80390c:	89 d0                	mov    %edx,%eax
  80390e:	31 d2                	xor    %edx,%edx
  803910:	83 c4 1c             	add    $0x1c,%esp
  803913:	5b                   	pop    %ebx
  803914:	5e                   	pop    %esi
  803915:	5f                   	pop    %edi
  803916:	5d                   	pop    %ebp
  803917:	c3                   	ret    
  803918:	39 f0                	cmp    %esi,%eax
  80391a:	0f 87 ac 00 00 00    	ja     8039cc <__umoddi3+0xfc>
  803920:	0f bd e8             	bsr    %eax,%ebp
  803923:	83 f5 1f             	xor    $0x1f,%ebp
  803926:	0f 84 ac 00 00 00    	je     8039d8 <__umoddi3+0x108>
  80392c:	bf 20 00 00 00       	mov    $0x20,%edi
  803931:	29 ef                	sub    %ebp,%edi
  803933:	89 fe                	mov    %edi,%esi
  803935:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803939:	89 e9                	mov    %ebp,%ecx
  80393b:	d3 e0                	shl    %cl,%eax
  80393d:	89 d7                	mov    %edx,%edi
  80393f:	89 f1                	mov    %esi,%ecx
  803941:	d3 ef                	shr    %cl,%edi
  803943:	09 c7                	or     %eax,%edi
  803945:	89 e9                	mov    %ebp,%ecx
  803947:	d3 e2                	shl    %cl,%edx
  803949:	89 14 24             	mov    %edx,(%esp)
  80394c:	89 d8                	mov    %ebx,%eax
  80394e:	d3 e0                	shl    %cl,%eax
  803950:	89 c2                	mov    %eax,%edx
  803952:	8b 44 24 08          	mov    0x8(%esp),%eax
  803956:	d3 e0                	shl    %cl,%eax
  803958:	89 44 24 04          	mov    %eax,0x4(%esp)
  80395c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803960:	89 f1                	mov    %esi,%ecx
  803962:	d3 e8                	shr    %cl,%eax
  803964:	09 d0                	or     %edx,%eax
  803966:	d3 eb                	shr    %cl,%ebx
  803968:	89 da                	mov    %ebx,%edx
  80396a:	f7 f7                	div    %edi
  80396c:	89 d3                	mov    %edx,%ebx
  80396e:	f7 24 24             	mull   (%esp)
  803971:	89 c6                	mov    %eax,%esi
  803973:	89 d1                	mov    %edx,%ecx
  803975:	39 d3                	cmp    %edx,%ebx
  803977:	0f 82 87 00 00 00    	jb     803a04 <__umoddi3+0x134>
  80397d:	0f 84 91 00 00 00    	je     803a14 <__umoddi3+0x144>
  803983:	8b 54 24 04          	mov    0x4(%esp),%edx
  803987:	29 f2                	sub    %esi,%edx
  803989:	19 cb                	sbb    %ecx,%ebx
  80398b:	89 d8                	mov    %ebx,%eax
  80398d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803991:	d3 e0                	shl    %cl,%eax
  803993:	89 e9                	mov    %ebp,%ecx
  803995:	d3 ea                	shr    %cl,%edx
  803997:	09 d0                	or     %edx,%eax
  803999:	89 e9                	mov    %ebp,%ecx
  80399b:	d3 eb                	shr    %cl,%ebx
  80399d:	89 da                	mov    %ebx,%edx
  80399f:	83 c4 1c             	add    $0x1c,%esp
  8039a2:	5b                   	pop    %ebx
  8039a3:	5e                   	pop    %esi
  8039a4:	5f                   	pop    %edi
  8039a5:	5d                   	pop    %ebp
  8039a6:	c3                   	ret    
  8039a7:	90                   	nop
  8039a8:	89 fd                	mov    %edi,%ebp
  8039aa:	85 ff                	test   %edi,%edi
  8039ac:	75 0b                	jne    8039b9 <__umoddi3+0xe9>
  8039ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8039b3:	31 d2                	xor    %edx,%edx
  8039b5:	f7 f7                	div    %edi
  8039b7:	89 c5                	mov    %eax,%ebp
  8039b9:	89 f0                	mov    %esi,%eax
  8039bb:	31 d2                	xor    %edx,%edx
  8039bd:	f7 f5                	div    %ebp
  8039bf:	89 c8                	mov    %ecx,%eax
  8039c1:	f7 f5                	div    %ebp
  8039c3:	89 d0                	mov    %edx,%eax
  8039c5:	e9 44 ff ff ff       	jmp    80390e <__umoddi3+0x3e>
  8039ca:	66 90                	xchg   %ax,%ax
  8039cc:	89 c8                	mov    %ecx,%eax
  8039ce:	89 f2                	mov    %esi,%edx
  8039d0:	83 c4 1c             	add    $0x1c,%esp
  8039d3:	5b                   	pop    %ebx
  8039d4:	5e                   	pop    %esi
  8039d5:	5f                   	pop    %edi
  8039d6:	5d                   	pop    %ebp
  8039d7:	c3                   	ret    
  8039d8:	3b 04 24             	cmp    (%esp),%eax
  8039db:	72 06                	jb     8039e3 <__umoddi3+0x113>
  8039dd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8039e1:	77 0f                	ja     8039f2 <__umoddi3+0x122>
  8039e3:	89 f2                	mov    %esi,%edx
  8039e5:	29 f9                	sub    %edi,%ecx
  8039e7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8039eb:	89 14 24             	mov    %edx,(%esp)
  8039ee:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8039f2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8039f6:	8b 14 24             	mov    (%esp),%edx
  8039f9:	83 c4 1c             	add    $0x1c,%esp
  8039fc:	5b                   	pop    %ebx
  8039fd:	5e                   	pop    %esi
  8039fe:	5f                   	pop    %edi
  8039ff:	5d                   	pop    %ebp
  803a00:	c3                   	ret    
  803a01:	8d 76 00             	lea    0x0(%esi),%esi
  803a04:	2b 04 24             	sub    (%esp),%eax
  803a07:	19 fa                	sbb    %edi,%edx
  803a09:	89 d1                	mov    %edx,%ecx
  803a0b:	89 c6                	mov    %eax,%esi
  803a0d:	e9 71 ff ff ff       	jmp    803983 <__umoddi3+0xb3>
  803a12:	66 90                	xchg   %ax,%ax
  803a14:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803a18:	72 ea                	jb     803a04 <__umoddi3+0x134>
  803a1a:	89 d9                	mov    %ebx,%ecx
  803a1c:	e9 62 ff ff ff       	jmp    803983 <__umoddi3+0xb3>
