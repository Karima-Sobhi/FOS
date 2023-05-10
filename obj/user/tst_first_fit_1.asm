
obj/user/tst_first_fit_1:     file format elf32-i386


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
  800031:	e8 38 0b 00 00       	call   800b6e <libmain>
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
  80003c:	83 ec 74             	sub    $0x74,%esp
	sys_set_uheap_strategy(UHP_PLACE_FIRSTFIT);
  80003f:	83 ec 0c             	sub    $0xc,%esp
  800042:	6a 01                	push   $0x1
  800044:	e8 84 27 00 00       	call   8027cd <sys_set_uheap_strategy>
  800049:	83 c4 10             	add    $0x10,%esp

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80004c:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800050:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800057:	eb 29                	jmp    800082 <_main+0x4a>
		{
			if (myEnv->__uptr_pws[i].empty)
  800059:	a1 20 50 80 00       	mov    0x805020,%eax
  80005e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800064:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800067:	89 d0                	mov    %edx,%eax
  800069:	01 c0                	add    %eax,%eax
  80006b:	01 d0                	add    %edx,%eax
  80006d:	c1 e0 03             	shl    $0x3,%eax
  800070:	01 c8                	add    %ecx,%eax
  800072:	8a 40 04             	mov    0x4(%eax),%al
  800075:	84 c0                	test   %al,%al
  800077:	74 06                	je     80007f <_main+0x47>
			{
				fullWS = 0;
  800079:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  80007d:	eb 12                	jmp    800091 <_main+0x59>
	sys_set_uheap_strategy(UHP_PLACE_FIRSTFIT);

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  80007f:	ff 45 f0             	incl   -0x10(%ebp)
  800082:	a1 20 50 80 00       	mov    0x805020,%eax
  800087:	8b 50 74             	mov    0x74(%eax),%edx
  80008a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80008d:	39 c2                	cmp    %eax,%edx
  80008f:	77 c8                	ja     800059 <_main+0x21>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800091:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800095:	74 14                	je     8000ab <_main+0x73>
  800097:	83 ec 04             	sub    $0x4,%esp
  80009a:	68 20 3c 80 00       	push   $0x803c20
  80009f:	6a 15                	push   $0x15
  8000a1:	68 3c 3c 80 00       	push   $0x803c3c
  8000a6:	e8 ff 0b 00 00       	call   800caa <_panic>
	}

	int Mega = 1024*1024;
  8000ab:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000b2:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000b9:	83 ec 0c             	sub    $0xc,%esp
  8000bc:	6a 00                	push   $0x0
  8000be:	e8 c7 1d 00 00       	call   801e8a <malloc>
  8000c3:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/
	void* ptr_allocations[20] = {0};
  8000c6:	8d 55 90             	lea    -0x70(%ebp),%edx
  8000c9:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d3:	89 d7                	mov    %edx,%edi
  8000d5:	f3 ab                	rep stos %eax,%es:(%edi)
	int freeFrames ;
	int usedDiskPages;
	//[1] Allocate all
	{
		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8000d7:	e8 dc 21 00 00       	call   8022b8 <sys_calculate_free_frames>
  8000dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8000df:	e8 74 22 00 00       	call   802358 <sys_pf_calculate_allocated_pages>
  8000e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[0] = malloc(1*Mega-kilo);
  8000e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000ea:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8000ed:	83 ec 0c             	sub    $0xc,%esp
  8000f0:	50                   	push   %eax
  8000f1:	e8 94 1d 00 00       	call   801e8a <malloc>
  8000f6:	83 c4 10             	add    $0x10,%esp
  8000f9:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[0] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  8000fc:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000ff:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800104:	74 14                	je     80011a <_main+0xe2>
  800106:	83 ec 04             	sub    $0x4,%esp
  800109:	68 54 3c 80 00       	push   $0x803c54
  80010e:	6a 26                	push   $0x26
  800110:	68 3c 3c 80 00       	push   $0x803c3c
  800115:	e8 90 0b 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80011a:	e8 39 22 00 00       	call   802358 <sys_pf_calculate_allocated_pages>
  80011f:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800122:	74 14                	je     800138 <_main+0x100>
  800124:	83 ec 04             	sub    $0x4,%esp
  800127:	68 84 3c 80 00       	push   $0x803c84
  80012c:	6a 28                	push   $0x28
  80012e:	68 3c 3c 80 00       	push   $0x803c3c
  800133:	e8 72 0b 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  800138:	e8 7b 21 00 00       	call   8022b8 <sys_calculate_free_frames>
  80013d:	89 c2                	mov    %eax,%edx
  80013f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800142:	39 c2                	cmp    %eax,%edx
  800144:	74 14                	je     80015a <_main+0x122>
  800146:	83 ec 04             	sub    $0x4,%esp
  800149:	68 a1 3c 80 00       	push   $0x803ca1
  80014e:	6a 29                	push   $0x29
  800150:	68 3c 3c 80 00       	push   $0x803c3c
  800155:	e8 50 0b 00 00       	call   800caa <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  80015a:	e8 59 21 00 00       	call   8022b8 <sys_calculate_free_frames>
  80015f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800162:	e8 f1 21 00 00       	call   802358 <sys_pf_calculate_allocated_pages>
  800167:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[1] = malloc(1*Mega-kilo);
  80016a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80016d:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800170:	83 ec 0c             	sub    $0xc,%esp
  800173:	50                   	push   %eax
  800174:	e8 11 1d 00 00       	call   801e8a <malloc>
  800179:	83 c4 10             	add    $0x10,%esp
  80017c:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[1] != (USER_HEAP_START + 1*Mega)) panic("Wrong start address for the allocated space... ");
  80017f:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800182:	89 c2                	mov    %eax,%edx
  800184:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800187:	05 00 00 00 80       	add    $0x80000000,%eax
  80018c:	39 c2                	cmp    %eax,%edx
  80018e:	74 14                	je     8001a4 <_main+0x16c>
  800190:	83 ec 04             	sub    $0x4,%esp
  800193:	68 54 3c 80 00       	push   $0x803c54
  800198:	6a 2f                	push   $0x2f
  80019a:	68 3c 3c 80 00       	push   $0x803c3c
  80019f:	e8 06 0b 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8001a4:	e8 af 21 00 00       	call   802358 <sys_pf_calculate_allocated_pages>
  8001a9:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8001ac:	74 14                	je     8001c2 <_main+0x18a>
  8001ae:	83 ec 04             	sub    $0x4,%esp
  8001b1:	68 84 3c 80 00       	push   $0x803c84
  8001b6:	6a 31                	push   $0x31
  8001b8:	68 3c 3c 80 00       	push   $0x803c3c
  8001bd:	e8 e8 0a 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  8001c2:	e8 f1 20 00 00       	call   8022b8 <sys_calculate_free_frames>
  8001c7:	89 c2                	mov    %eax,%edx
  8001c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001cc:	39 c2                	cmp    %eax,%edx
  8001ce:	74 14                	je     8001e4 <_main+0x1ac>
  8001d0:	83 ec 04             	sub    $0x4,%esp
  8001d3:	68 a1 3c 80 00       	push   $0x803ca1
  8001d8:	6a 32                	push   $0x32
  8001da:	68 3c 3c 80 00       	push   $0x803c3c
  8001df:	e8 c6 0a 00 00       	call   800caa <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8001e4:	e8 cf 20 00 00       	call   8022b8 <sys_calculate_free_frames>
  8001e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8001ec:	e8 67 21 00 00       	call   802358 <sys_pf_calculate_allocated_pages>
  8001f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[2] = malloc(1*Mega-kilo);
  8001f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001f7:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8001fa:	83 ec 0c             	sub    $0xc,%esp
  8001fd:	50                   	push   %eax
  8001fe:	e8 87 1c 00 00       	call   801e8a <malloc>
  800203:	83 c4 10             	add    $0x10,%esp
  800206:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[2] != (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the allocated space... ");
  800209:	8b 45 98             	mov    -0x68(%ebp),%eax
  80020c:	89 c2                	mov    %eax,%edx
  80020e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800211:	01 c0                	add    %eax,%eax
  800213:	05 00 00 00 80       	add    $0x80000000,%eax
  800218:	39 c2                	cmp    %eax,%edx
  80021a:	74 14                	je     800230 <_main+0x1f8>
  80021c:	83 ec 04             	sub    $0x4,%esp
  80021f:	68 54 3c 80 00       	push   $0x803c54
  800224:	6a 38                	push   $0x38
  800226:	68 3c 3c 80 00       	push   $0x803c3c
  80022b:	e8 7a 0a 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800230:	e8 23 21 00 00       	call   802358 <sys_pf_calculate_allocated_pages>
  800235:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800238:	74 14                	je     80024e <_main+0x216>
  80023a:	83 ec 04             	sub    $0x4,%esp
  80023d:	68 84 3c 80 00       	push   $0x803c84
  800242:	6a 3a                	push   $0x3a
  800244:	68 3c 3c 80 00       	push   $0x803c3c
  800249:	e8 5c 0a 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  80024e:	e8 65 20 00 00       	call   8022b8 <sys_calculate_free_frames>
  800253:	89 c2                	mov    %eax,%edx
  800255:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800258:	39 c2                	cmp    %eax,%edx
  80025a:	74 14                	je     800270 <_main+0x238>
  80025c:	83 ec 04             	sub    $0x4,%esp
  80025f:	68 a1 3c 80 00       	push   $0x803ca1
  800264:	6a 3b                	push   $0x3b
  800266:	68 3c 3c 80 00       	push   $0x803c3c
  80026b:	e8 3a 0a 00 00       	call   800caa <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800270:	e8 43 20 00 00       	call   8022b8 <sys_calculate_free_frames>
  800275:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800278:	e8 db 20 00 00       	call   802358 <sys_pf_calculate_allocated_pages>
  80027d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[3] = malloc(1*Mega-kilo);
  800280:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800283:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800286:	83 ec 0c             	sub    $0xc,%esp
  800289:	50                   	push   %eax
  80028a:	e8 fb 1b 00 00       	call   801e8a <malloc>
  80028f:	83 c4 10             	add    $0x10,%esp
  800292:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[3] != (USER_HEAP_START + 3*Mega) ) panic("Wrong start address for the allocated space... ");
  800295:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800298:	89 c1                	mov    %eax,%ecx
  80029a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80029d:	89 c2                	mov    %eax,%edx
  80029f:	01 d2                	add    %edx,%edx
  8002a1:	01 d0                	add    %edx,%eax
  8002a3:	05 00 00 00 80       	add    $0x80000000,%eax
  8002a8:	39 c1                	cmp    %eax,%ecx
  8002aa:	74 14                	je     8002c0 <_main+0x288>
  8002ac:	83 ec 04             	sub    $0x4,%esp
  8002af:	68 54 3c 80 00       	push   $0x803c54
  8002b4:	6a 41                	push   $0x41
  8002b6:	68 3c 3c 80 00       	push   $0x803c3c
  8002bb:	e8 ea 09 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8002c0:	e8 93 20 00 00       	call   802358 <sys_pf_calculate_allocated_pages>
  8002c5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002c8:	74 14                	je     8002de <_main+0x2a6>
  8002ca:	83 ec 04             	sub    $0x4,%esp
  8002cd:	68 84 3c 80 00       	push   $0x803c84
  8002d2:	6a 43                	push   $0x43
  8002d4:	68 3c 3c 80 00       	push   $0x803c3c
  8002d9:	e8 cc 09 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  8002de:	e8 d5 1f 00 00       	call   8022b8 <sys_calculate_free_frames>
  8002e3:	89 c2                	mov    %eax,%edx
  8002e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002e8:	39 c2                	cmp    %eax,%edx
  8002ea:	74 14                	je     800300 <_main+0x2c8>
  8002ec:	83 ec 04             	sub    $0x4,%esp
  8002ef:	68 a1 3c 80 00       	push   $0x803ca1
  8002f4:	6a 44                	push   $0x44
  8002f6:	68 3c 3c 80 00       	push   $0x803c3c
  8002fb:	e8 aa 09 00 00       	call   800caa <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800300:	e8 b3 1f 00 00       	call   8022b8 <sys_calculate_free_frames>
  800305:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800308:	e8 4b 20 00 00       	call   802358 <sys_pf_calculate_allocated_pages>
  80030d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[4] = malloc(2*Mega-kilo);
  800310:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800313:	01 c0                	add    %eax,%eax
  800315:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800318:	83 ec 0c             	sub    $0xc,%esp
  80031b:	50                   	push   %eax
  80031c:	e8 69 1b 00 00       	call   801e8a <malloc>
  800321:	83 c4 10             	add    $0x10,%esp
  800324:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[4] != (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  800327:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80032a:	89 c2                	mov    %eax,%edx
  80032c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80032f:	c1 e0 02             	shl    $0x2,%eax
  800332:	05 00 00 00 80       	add    $0x80000000,%eax
  800337:	39 c2                	cmp    %eax,%edx
  800339:	74 14                	je     80034f <_main+0x317>
  80033b:	83 ec 04             	sub    $0x4,%esp
  80033e:	68 54 3c 80 00       	push   $0x803c54
  800343:	6a 4a                	push   $0x4a
  800345:	68 3c 3c 80 00       	push   $0x803c3c
  80034a:	e8 5b 09 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80034f:	e8 04 20 00 00       	call   802358 <sys_pf_calculate_allocated_pages>
  800354:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800357:	74 14                	je     80036d <_main+0x335>
  800359:	83 ec 04             	sub    $0x4,%esp
  80035c:	68 84 3c 80 00       	push   $0x803c84
  800361:	6a 4c                	push   $0x4c
  800363:	68 3c 3c 80 00       	push   $0x803c3c
  800368:	e8 3d 09 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80036d:	e8 46 1f 00 00       	call   8022b8 <sys_calculate_free_frames>
  800372:	89 c2                	mov    %eax,%edx
  800374:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800377:	39 c2                	cmp    %eax,%edx
  800379:	74 14                	je     80038f <_main+0x357>
  80037b:	83 ec 04             	sub    $0x4,%esp
  80037e:	68 a1 3c 80 00       	push   $0x803ca1
  800383:	6a 4d                	push   $0x4d
  800385:	68 3c 3c 80 00       	push   $0x803c3c
  80038a:	e8 1b 09 00 00       	call   800caa <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  80038f:	e8 24 1f 00 00       	call   8022b8 <sys_calculate_free_frames>
  800394:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800397:	e8 bc 1f 00 00       	call   802358 <sys_pf_calculate_allocated_pages>
  80039c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[5] = malloc(2*Mega-kilo);
  80039f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003a2:	01 c0                	add    %eax,%eax
  8003a4:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8003a7:	83 ec 0c             	sub    $0xc,%esp
  8003aa:	50                   	push   %eax
  8003ab:	e8 da 1a 00 00       	call   801e8a <malloc>
  8003b0:	83 c4 10             	add    $0x10,%esp
  8003b3:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[5] != (USER_HEAP_START + 6*Mega)) panic("Wrong start address for the allocated space... ");
  8003b6:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003b9:	89 c1                	mov    %eax,%ecx
  8003bb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8003be:	89 d0                	mov    %edx,%eax
  8003c0:	01 c0                	add    %eax,%eax
  8003c2:	01 d0                	add    %edx,%eax
  8003c4:	01 c0                	add    %eax,%eax
  8003c6:	05 00 00 00 80       	add    $0x80000000,%eax
  8003cb:	39 c1                	cmp    %eax,%ecx
  8003cd:	74 14                	je     8003e3 <_main+0x3ab>
  8003cf:	83 ec 04             	sub    $0x4,%esp
  8003d2:	68 54 3c 80 00       	push   $0x803c54
  8003d7:	6a 53                	push   $0x53
  8003d9:	68 3c 3c 80 00       	push   $0x803c3c
  8003de:	e8 c7 08 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8003e3:	e8 70 1f 00 00       	call   802358 <sys_pf_calculate_allocated_pages>
  8003e8:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8003eb:	74 14                	je     800401 <_main+0x3c9>
  8003ed:	83 ec 04             	sub    $0x4,%esp
  8003f0:	68 84 3c 80 00       	push   $0x803c84
  8003f5:	6a 55                	push   $0x55
  8003f7:	68 3c 3c 80 00       	push   $0x803c3c
  8003fc:	e8 a9 08 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800401:	e8 b2 1e 00 00       	call   8022b8 <sys_calculate_free_frames>
  800406:	89 c2                	mov    %eax,%edx
  800408:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80040b:	39 c2                	cmp    %eax,%edx
  80040d:	74 14                	je     800423 <_main+0x3eb>
  80040f:	83 ec 04             	sub    $0x4,%esp
  800412:	68 a1 3c 80 00       	push   $0x803ca1
  800417:	6a 56                	push   $0x56
  800419:	68 3c 3c 80 00       	push   $0x803c3c
  80041e:	e8 87 08 00 00       	call   800caa <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  800423:	e8 90 1e 00 00       	call   8022b8 <sys_calculate_free_frames>
  800428:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80042b:	e8 28 1f 00 00       	call   802358 <sys_pf_calculate_allocated_pages>
  800430:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[6] = malloc(3*Mega-kilo);
  800433:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800436:	89 c2                	mov    %eax,%edx
  800438:	01 d2                	add    %edx,%edx
  80043a:	01 d0                	add    %edx,%eax
  80043c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80043f:	83 ec 0c             	sub    $0xc,%esp
  800442:	50                   	push   %eax
  800443:	e8 42 1a 00 00       	call   801e8a <malloc>
  800448:	83 c4 10             	add    $0x10,%esp
  80044b:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if ((uint32) ptr_allocations[6] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  80044e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800451:	89 c2                	mov    %eax,%edx
  800453:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800456:	c1 e0 03             	shl    $0x3,%eax
  800459:	05 00 00 00 80       	add    $0x80000000,%eax
  80045e:	39 c2                	cmp    %eax,%edx
  800460:	74 14                	je     800476 <_main+0x43e>
  800462:	83 ec 04             	sub    $0x4,%esp
  800465:	68 54 3c 80 00       	push   $0x803c54
  80046a:	6a 5c                	push   $0x5c
  80046c:	68 3c 3c 80 00       	push   $0x803c3c
  800471:	e8 34 08 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800476:	e8 dd 1e 00 00       	call   802358 <sys_pf_calculate_allocated_pages>
  80047b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80047e:	74 14                	je     800494 <_main+0x45c>
  800480:	83 ec 04             	sub    $0x4,%esp
  800483:	68 84 3c 80 00       	push   $0x803c84
  800488:	6a 5e                	push   $0x5e
  80048a:	68 3c 3c 80 00       	push   $0x803c3c
  80048f:	e8 16 08 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800494:	e8 1f 1e 00 00       	call   8022b8 <sys_calculate_free_frames>
  800499:	89 c2                	mov    %eax,%edx
  80049b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80049e:	39 c2                	cmp    %eax,%edx
  8004a0:	74 14                	je     8004b6 <_main+0x47e>
  8004a2:	83 ec 04             	sub    $0x4,%esp
  8004a5:	68 a1 3c 80 00       	push   $0x803ca1
  8004aa:	6a 5f                	push   $0x5f
  8004ac:	68 3c 3c 80 00       	push   $0x803c3c
  8004b1:	e8 f4 07 00 00       	call   800caa <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8004b6:	e8 fd 1d 00 00       	call   8022b8 <sys_calculate_free_frames>
  8004bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004be:	e8 95 1e 00 00       	call   802358 <sys_pf_calculate_allocated_pages>
  8004c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[7] = malloc(3*Mega-kilo);
  8004c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8004c9:	89 c2                	mov    %eax,%edx
  8004cb:	01 d2                	add    %edx,%edx
  8004cd:	01 d0                	add    %edx,%eax
  8004cf:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8004d2:	83 ec 0c             	sub    $0xc,%esp
  8004d5:	50                   	push   %eax
  8004d6:	e8 af 19 00 00       	call   801e8a <malloc>
  8004db:	83 c4 10             	add    $0x10,%esp
  8004de:	89 45 ac             	mov    %eax,-0x54(%ebp)
		if ((uint32) ptr_allocations[7] != (USER_HEAP_START + 11*Mega)) panic("Wrong start address for the allocated space... ");
  8004e1:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8004e4:	89 c1                	mov    %eax,%ecx
  8004e6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8004e9:	89 d0                	mov    %edx,%eax
  8004eb:	c1 e0 02             	shl    $0x2,%eax
  8004ee:	01 d0                	add    %edx,%eax
  8004f0:	01 c0                	add    %eax,%eax
  8004f2:	01 d0                	add    %edx,%eax
  8004f4:	05 00 00 00 80       	add    $0x80000000,%eax
  8004f9:	39 c1                	cmp    %eax,%ecx
  8004fb:	74 14                	je     800511 <_main+0x4d9>
  8004fd:	83 ec 04             	sub    $0x4,%esp
  800500:	68 54 3c 80 00       	push   $0x803c54
  800505:	6a 65                	push   $0x65
  800507:	68 3c 3c 80 00       	push   $0x803c3c
  80050c:	e8 99 07 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800511:	e8 42 1e 00 00       	call   802358 <sys_pf_calculate_allocated_pages>
  800516:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800519:	74 14                	je     80052f <_main+0x4f7>
  80051b:	83 ec 04             	sub    $0x4,%esp
  80051e:	68 84 3c 80 00       	push   $0x803c84
  800523:	6a 67                	push   $0x67
  800525:	68 3c 3c 80 00       	push   $0x803c3c
  80052a:	e8 7b 07 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80052f:	e8 84 1d 00 00       	call   8022b8 <sys_calculate_free_frames>
  800534:	89 c2                	mov    %eax,%edx
  800536:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800539:	39 c2                	cmp    %eax,%edx
  80053b:	74 14                	je     800551 <_main+0x519>
  80053d:	83 ec 04             	sub    $0x4,%esp
  800540:	68 a1 3c 80 00       	push   $0x803ca1
  800545:	6a 68                	push   $0x68
  800547:	68 3c 3c 80 00       	push   $0x803c3c
  80054c:	e8 59 07 00 00       	call   800caa <_panic>
	}

	//[2] Free some to create holes
	{
		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800551:	e8 62 1d 00 00       	call   8022b8 <sys_calculate_free_frames>
  800556:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800559:	e8 fa 1d 00 00       	call   802358 <sys_pf_calculate_allocated_pages>
  80055e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[1]);
  800561:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800564:	83 ec 0c             	sub    $0xc,%esp
  800567:	50                   	push   %eax
  800568:	e8 98 19 00 00       	call   801f05 <free>
  80056d:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  800570:	e8 e3 1d 00 00       	call   802358 <sys_pf_calculate_allocated_pages>
  800575:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800578:	74 14                	je     80058e <_main+0x556>
  80057a:	83 ec 04             	sub    $0x4,%esp
  80057d:	68 b4 3c 80 00       	push   $0x803cb4
  800582:	6a 72                	push   $0x72
  800584:	68 3c 3c 80 00       	push   $0x803c3c
  800589:	e8 1c 07 00 00       	call   800caa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  80058e:	e8 25 1d 00 00       	call   8022b8 <sys_calculate_free_frames>
  800593:	89 c2                	mov    %eax,%edx
  800595:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800598:	39 c2                	cmp    %eax,%edx
  80059a:	74 14                	je     8005b0 <_main+0x578>
  80059c:	83 ec 04             	sub    $0x4,%esp
  80059f:	68 cb 3c 80 00       	push   $0x803ccb
  8005a4:	6a 73                	push   $0x73
  8005a6:	68 3c 3c 80 00       	push   $0x803c3c
  8005ab:	e8 fa 06 00 00       	call   800caa <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8005b0:	e8 03 1d 00 00       	call   8022b8 <sys_calculate_free_frames>
  8005b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005b8:	e8 9b 1d 00 00       	call   802358 <sys_pf_calculate_allocated_pages>
  8005bd:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[4]);
  8005c0:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8005c3:	83 ec 0c             	sub    $0xc,%esp
  8005c6:	50                   	push   %eax
  8005c7:	e8 39 19 00 00       	call   801f05 <free>
  8005cc:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  8005cf:	e8 84 1d 00 00       	call   802358 <sys_pf_calculate_allocated_pages>
  8005d4:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005d7:	74 14                	je     8005ed <_main+0x5b5>
  8005d9:	83 ec 04             	sub    $0x4,%esp
  8005dc:	68 b4 3c 80 00       	push   $0x803cb4
  8005e1:	6a 7a                	push   $0x7a
  8005e3:	68 3c 3c 80 00       	push   $0x803c3c
  8005e8:	e8 bd 06 00 00       	call   800caa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8005ed:	e8 c6 1c 00 00       	call   8022b8 <sys_calculate_free_frames>
  8005f2:	89 c2                	mov    %eax,%edx
  8005f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005f7:	39 c2                	cmp    %eax,%edx
  8005f9:	74 14                	je     80060f <_main+0x5d7>
  8005fb:	83 ec 04             	sub    $0x4,%esp
  8005fe:	68 cb 3c 80 00       	push   $0x803ccb
  800603:	6a 7b                	push   $0x7b
  800605:	68 3c 3c 80 00       	push   $0x803c3c
  80060a:	e8 9b 06 00 00       	call   800caa <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80060f:	e8 a4 1c 00 00       	call   8022b8 <sys_calculate_free_frames>
  800614:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800617:	e8 3c 1d 00 00       	call   802358 <sys_pf_calculate_allocated_pages>
  80061c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[6]);
  80061f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800622:	83 ec 0c             	sub    $0xc,%esp
  800625:	50                   	push   %eax
  800626:	e8 da 18 00 00       	call   801f05 <free>
  80062b:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  80062e:	e8 25 1d 00 00       	call   802358 <sys_pf_calculate_allocated_pages>
  800633:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800636:	74 17                	je     80064f <_main+0x617>
  800638:	83 ec 04             	sub    $0x4,%esp
  80063b:	68 b4 3c 80 00       	push   $0x803cb4
  800640:	68 82 00 00 00       	push   $0x82
  800645:	68 3c 3c 80 00       	push   $0x803c3c
  80064a:	e8 5b 06 00 00       	call   800caa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  80064f:	e8 64 1c 00 00       	call   8022b8 <sys_calculate_free_frames>
  800654:	89 c2                	mov    %eax,%edx
  800656:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800659:	39 c2                	cmp    %eax,%edx
  80065b:	74 17                	je     800674 <_main+0x63c>
  80065d:	83 ec 04             	sub    $0x4,%esp
  800660:	68 cb 3c 80 00       	push   $0x803ccb
  800665:	68 83 00 00 00       	push   $0x83
  80066a:	68 3c 3c 80 00       	push   $0x803c3c
  80066f:	e8 36 06 00 00       	call   800caa <_panic>
	}

	//[3] Allocate again [test first fit]
	{
		//Allocate 512 KB - should be placed in 1st hole
		freeFrames = sys_calculate_free_frames() ;
  800674:	e8 3f 1c 00 00       	call   8022b8 <sys_calculate_free_frames>
  800679:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80067c:	e8 d7 1c 00 00       	call   802358 <sys_pf_calculate_allocated_pages>
  800681:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[8] = malloc(512*kilo - kilo);
  800684:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800687:	89 d0                	mov    %edx,%eax
  800689:	c1 e0 09             	shl    $0x9,%eax
  80068c:	29 d0                	sub    %edx,%eax
  80068e:	83 ec 0c             	sub    $0xc,%esp
  800691:	50                   	push   %eax
  800692:	e8 f3 17 00 00       	call   801e8a <malloc>
  800697:	83 c4 10             	add    $0x10,%esp
  80069a:	89 45 b0             	mov    %eax,-0x50(%ebp)
		if ((uint32) ptr_allocations[8] != (USER_HEAP_START + 1*Mega)) panic("Wrong start address for the allocated space... ");
  80069d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8006a0:	89 c2                	mov    %eax,%edx
  8006a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006a5:	05 00 00 00 80       	add    $0x80000000,%eax
  8006aa:	39 c2                	cmp    %eax,%edx
  8006ac:	74 17                	je     8006c5 <_main+0x68d>
  8006ae:	83 ec 04             	sub    $0x4,%esp
  8006b1:	68 54 3c 80 00       	push   $0x803c54
  8006b6:	68 8c 00 00 00       	push   $0x8c
  8006bb:	68 3c 3c 80 00       	push   $0x803c3c
  8006c0:	e8 e5 05 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 128) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8006c5:	e8 8e 1c 00 00       	call   802358 <sys_pf_calculate_allocated_pages>
  8006ca:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8006cd:	74 17                	je     8006e6 <_main+0x6ae>
  8006cf:	83 ec 04             	sub    $0x4,%esp
  8006d2:	68 84 3c 80 00       	push   $0x803c84
  8006d7:	68 8e 00 00 00       	push   $0x8e
  8006dc:	68 3c 3c 80 00       	push   $0x803c3c
  8006e1:	e8 c4 05 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8006e6:	e8 cd 1b 00 00       	call   8022b8 <sys_calculate_free_frames>
  8006eb:	89 c2                	mov    %eax,%edx
  8006ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006f0:	39 c2                	cmp    %eax,%edx
  8006f2:	74 17                	je     80070b <_main+0x6d3>
  8006f4:	83 ec 04             	sub    $0x4,%esp
  8006f7:	68 a1 3c 80 00       	push   $0x803ca1
  8006fc:	68 8f 00 00 00       	push   $0x8f
  800701:	68 3c 3c 80 00       	push   $0x803c3c
  800706:	e8 9f 05 00 00       	call   800caa <_panic>

		//Allocate 1 MB - should be placed in 2nd hole
		freeFrames = sys_calculate_free_frames() ;
  80070b:	e8 a8 1b 00 00       	call   8022b8 <sys_calculate_free_frames>
  800710:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800713:	e8 40 1c 00 00       	call   802358 <sys_pf_calculate_allocated_pages>
  800718:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[9] = malloc(1*Mega - kilo);
  80071b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80071e:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800721:	83 ec 0c             	sub    $0xc,%esp
  800724:	50                   	push   %eax
  800725:	e8 60 17 00 00       	call   801e8a <malloc>
  80072a:	83 c4 10             	add    $0x10,%esp
  80072d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		if ((uint32) ptr_allocations[9] != (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  800730:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800733:	89 c2                	mov    %eax,%edx
  800735:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800738:	c1 e0 02             	shl    $0x2,%eax
  80073b:	05 00 00 00 80       	add    $0x80000000,%eax
  800740:	39 c2                	cmp    %eax,%edx
  800742:	74 17                	je     80075b <_main+0x723>
  800744:	83 ec 04             	sub    $0x4,%esp
  800747:	68 54 3c 80 00       	push   $0x803c54
  80074c:	68 95 00 00 00       	push   $0x95
  800751:	68 3c 3c 80 00       	push   $0x803c3c
  800756:	e8 4f 05 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80075b:	e8 f8 1b 00 00       	call   802358 <sys_pf_calculate_allocated_pages>
  800760:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800763:	74 17                	je     80077c <_main+0x744>
  800765:	83 ec 04             	sub    $0x4,%esp
  800768:	68 84 3c 80 00       	push   $0x803c84
  80076d:	68 97 00 00 00       	push   $0x97
  800772:	68 3c 3c 80 00       	push   $0x803c3c
  800777:	e8 2e 05 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80077c:	e8 37 1b 00 00       	call   8022b8 <sys_calculate_free_frames>
  800781:	89 c2                	mov    %eax,%edx
  800783:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800786:	39 c2                	cmp    %eax,%edx
  800788:	74 17                	je     8007a1 <_main+0x769>
  80078a:	83 ec 04             	sub    $0x4,%esp
  80078d:	68 a1 3c 80 00       	push   $0x803ca1
  800792:	68 98 00 00 00       	push   $0x98
  800797:	68 3c 3c 80 00       	push   $0x803c3c
  80079c:	e8 09 05 00 00       	call   800caa <_panic>

		//Allocate 256 KB - should be placed in remaining of 1st hole
		freeFrames = sys_calculate_free_frames() ;
  8007a1:	e8 12 1b 00 00       	call   8022b8 <sys_calculate_free_frames>
  8007a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8007a9:	e8 aa 1b 00 00       	call   802358 <sys_pf_calculate_allocated_pages>
  8007ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[10] = malloc(256*kilo - kilo);
  8007b1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007b4:	89 d0                	mov    %edx,%eax
  8007b6:	c1 e0 08             	shl    $0x8,%eax
  8007b9:	29 d0                	sub    %edx,%eax
  8007bb:	83 ec 0c             	sub    $0xc,%esp
  8007be:	50                   	push   %eax
  8007bf:	e8 c6 16 00 00       	call   801e8a <malloc>
  8007c4:	83 c4 10             	add    $0x10,%esp
  8007c7:	89 45 b8             	mov    %eax,-0x48(%ebp)
		if ((uint32) ptr_allocations[10] != (USER_HEAP_START + 1*Mega + 512*kilo)) panic("Wrong start address for the allocated space... ");
  8007ca:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8007cd:	89 c2                	mov    %eax,%edx
  8007cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8007d2:	c1 e0 09             	shl    $0x9,%eax
  8007d5:	89 c1                	mov    %eax,%ecx
  8007d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007da:	01 c8                	add    %ecx,%eax
  8007dc:	05 00 00 00 80       	add    $0x80000000,%eax
  8007e1:	39 c2                	cmp    %eax,%edx
  8007e3:	74 17                	je     8007fc <_main+0x7c4>
  8007e5:	83 ec 04             	sub    $0x4,%esp
  8007e8:	68 54 3c 80 00       	push   $0x803c54
  8007ed:	68 9e 00 00 00       	push   $0x9e
  8007f2:	68 3c 3c 80 00       	push   $0x803c3c
  8007f7:	e8 ae 04 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 64) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8007fc:	e8 57 1b 00 00       	call   802358 <sys_pf_calculate_allocated_pages>
  800801:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800804:	74 17                	je     80081d <_main+0x7e5>
  800806:	83 ec 04             	sub    $0x4,%esp
  800809:	68 84 3c 80 00       	push   $0x803c84
  80080e:	68 a0 00 00 00       	push   $0xa0
  800813:	68 3c 3c 80 00       	push   $0x803c3c
  800818:	e8 8d 04 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80081d:	e8 96 1a 00 00       	call   8022b8 <sys_calculate_free_frames>
  800822:	89 c2                	mov    %eax,%edx
  800824:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800827:	39 c2                	cmp    %eax,%edx
  800829:	74 17                	je     800842 <_main+0x80a>
  80082b:	83 ec 04             	sub    $0x4,%esp
  80082e:	68 a1 3c 80 00       	push   $0x803ca1
  800833:	68 a1 00 00 00       	push   $0xa1
  800838:	68 3c 3c 80 00       	push   $0x803c3c
  80083d:	e8 68 04 00 00       	call   800caa <_panic>

		//Allocate 2 MB - should be placed in 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  800842:	e8 71 1a 00 00       	call   8022b8 <sys_calculate_free_frames>
  800847:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80084a:	e8 09 1b 00 00       	call   802358 <sys_pf_calculate_allocated_pages>
  80084f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[11] = malloc(2*Mega);
  800852:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800855:	01 c0                	add    %eax,%eax
  800857:	83 ec 0c             	sub    $0xc,%esp
  80085a:	50                   	push   %eax
  80085b:	e8 2a 16 00 00       	call   801e8a <malloc>
  800860:	83 c4 10             	add    $0x10,%esp
  800863:	89 45 bc             	mov    %eax,-0x44(%ebp)
		if ((uint32) ptr_allocations[11] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  800866:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800869:	89 c2                	mov    %eax,%edx
  80086b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80086e:	c1 e0 03             	shl    $0x3,%eax
  800871:	05 00 00 00 80       	add    $0x80000000,%eax
  800876:	39 c2                	cmp    %eax,%edx
  800878:	74 17                	je     800891 <_main+0x859>
  80087a:	83 ec 04             	sub    $0x4,%esp
  80087d:	68 54 3c 80 00       	push   $0x803c54
  800882:	68 a7 00 00 00       	push   $0xa7
  800887:	68 3c 3c 80 00       	push   $0x803c3c
  80088c:	e8 19 04 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800891:	e8 c2 1a 00 00       	call   802358 <sys_pf_calculate_allocated_pages>
  800896:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800899:	74 17                	je     8008b2 <_main+0x87a>
  80089b:	83 ec 04             	sub    $0x4,%esp
  80089e:	68 84 3c 80 00       	push   $0x803c84
  8008a3:	68 a9 00 00 00       	push   $0xa9
  8008a8:	68 3c 3c 80 00       	push   $0x803c3c
  8008ad:	e8 f8 03 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8008b2:	e8 01 1a 00 00       	call   8022b8 <sys_calculate_free_frames>
  8008b7:	89 c2                	mov    %eax,%edx
  8008b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8008bc:	39 c2                	cmp    %eax,%edx
  8008be:	74 17                	je     8008d7 <_main+0x89f>
  8008c0:	83 ec 04             	sub    $0x4,%esp
  8008c3:	68 a1 3c 80 00       	push   $0x803ca1
  8008c8:	68 aa 00 00 00       	push   $0xaa
  8008cd:	68 3c 3c 80 00       	push   $0x803c3c
  8008d2:	e8 d3 03 00 00       	call   800caa <_panic>

		//Allocate 4 MB - should be placed in end of all allocations
		freeFrames = sys_calculate_free_frames() ;
  8008d7:	e8 dc 19 00 00       	call   8022b8 <sys_calculate_free_frames>
  8008dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8008df:	e8 74 1a 00 00       	call   802358 <sys_pf_calculate_allocated_pages>
  8008e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[12] = malloc(4*Mega - kilo);
  8008e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008ea:	c1 e0 02             	shl    $0x2,%eax
  8008ed:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8008f0:	83 ec 0c             	sub    $0xc,%esp
  8008f3:	50                   	push   %eax
  8008f4:	e8 91 15 00 00       	call   801e8a <malloc>
  8008f9:	83 c4 10             	add    $0x10,%esp
  8008fc:	89 45 c0             	mov    %eax,-0x40(%ebp)
		if ((uint32) ptr_allocations[12] != (USER_HEAP_START + 14*Mega) ) panic("Wrong start address for the allocated space... ");
  8008ff:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800902:	89 c1                	mov    %eax,%ecx
  800904:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800907:	89 d0                	mov    %edx,%eax
  800909:	01 c0                	add    %eax,%eax
  80090b:	01 d0                	add    %edx,%eax
  80090d:	01 c0                	add    %eax,%eax
  80090f:	01 d0                	add    %edx,%eax
  800911:	01 c0                	add    %eax,%eax
  800913:	05 00 00 00 80       	add    $0x80000000,%eax
  800918:	39 c1                	cmp    %eax,%ecx
  80091a:	74 17                	je     800933 <_main+0x8fb>
  80091c:	83 ec 04             	sub    $0x4,%esp
  80091f:	68 54 3c 80 00       	push   $0x803c54
  800924:	68 b0 00 00 00       	push   $0xb0
  800929:	68 3c 3c 80 00       	push   $0x803c3c
  80092e:	e8 77 03 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1024 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800933:	e8 20 1a 00 00       	call   802358 <sys_pf_calculate_allocated_pages>
  800938:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80093b:	74 17                	je     800954 <_main+0x91c>
  80093d:	83 ec 04             	sub    $0x4,%esp
  800940:	68 84 3c 80 00       	push   $0x803c84
  800945:	68 b2 00 00 00       	push   $0xb2
  80094a:	68 3c 3c 80 00       	push   $0x803c3c
  80094f:	e8 56 03 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800954:	e8 5f 19 00 00       	call   8022b8 <sys_calculate_free_frames>
  800959:	89 c2                	mov    %eax,%edx
  80095b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80095e:	39 c2                	cmp    %eax,%edx
  800960:	74 17                	je     800979 <_main+0x941>
  800962:	83 ec 04             	sub    $0x4,%esp
  800965:	68 a1 3c 80 00       	push   $0x803ca1
  80096a:	68 b3 00 00 00       	push   $0xb3
  80096f:	68 3c 3c 80 00       	push   $0x803c3c
  800974:	e8 31 03 00 00       	call   800caa <_panic>
	}

	//[4] Free contiguous allocations
	{
		//1 MB Hole appended to previous 256 KB hole
		freeFrames = sys_calculate_free_frames() ;
  800979:	e8 3a 19 00 00       	call   8022b8 <sys_calculate_free_frames>
  80097e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800981:	e8 d2 19 00 00       	call   802358 <sys_pf_calculate_allocated_pages>
  800986:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[2]);
  800989:	8b 45 98             	mov    -0x68(%ebp),%eax
  80098c:	83 ec 0c             	sub    $0xc,%esp
  80098f:	50                   	push   %eax
  800990:	e8 70 15 00 00       	call   801f05 <free>
  800995:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  800998:	e8 bb 19 00 00       	call   802358 <sys_pf_calculate_allocated_pages>
  80099d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8009a0:	74 17                	je     8009b9 <_main+0x981>
  8009a2:	83 ec 04             	sub    $0x4,%esp
  8009a5:	68 b4 3c 80 00       	push   $0x803cb4
  8009aa:	68 bd 00 00 00       	push   $0xbd
  8009af:	68 3c 3c 80 00       	push   $0x803c3c
  8009b4:	e8 f1 02 00 00       	call   800caa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8009b9:	e8 fa 18 00 00       	call   8022b8 <sys_calculate_free_frames>
  8009be:	89 c2                	mov    %eax,%edx
  8009c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8009c3:	39 c2                	cmp    %eax,%edx
  8009c5:	74 17                	je     8009de <_main+0x9a6>
  8009c7:	83 ec 04             	sub    $0x4,%esp
  8009ca:	68 cb 3c 80 00       	push   $0x803ccb
  8009cf:	68 be 00 00 00       	push   $0xbe
  8009d4:	68 3c 3c 80 00       	push   $0x803c3c
  8009d9:	e8 cc 02 00 00       	call   800caa <_panic>

		//1 MB Hole appended to next 1 MB hole
		freeFrames = sys_calculate_free_frames() ;
  8009de:	e8 d5 18 00 00       	call   8022b8 <sys_calculate_free_frames>
  8009e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8009e6:	e8 6d 19 00 00       	call   802358 <sys_pf_calculate_allocated_pages>
  8009eb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[9]);
  8009ee:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8009f1:	83 ec 0c             	sub    $0xc,%esp
  8009f4:	50                   	push   %eax
  8009f5:	e8 0b 15 00 00       	call   801f05 <free>
  8009fa:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  8009fd:	e8 56 19 00 00       	call   802358 <sys_pf_calculate_allocated_pages>
  800a02:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800a05:	74 17                	je     800a1e <_main+0x9e6>
  800a07:	83 ec 04             	sub    $0x4,%esp
  800a0a:	68 b4 3c 80 00       	push   $0x803cb4
  800a0f:	68 c5 00 00 00       	push   $0xc5
  800a14:	68 3c 3c 80 00       	push   $0x803c3c
  800a19:	e8 8c 02 00 00       	call   800caa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800a1e:	e8 95 18 00 00       	call   8022b8 <sys_calculate_free_frames>
  800a23:	89 c2                	mov    %eax,%edx
  800a25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a28:	39 c2                	cmp    %eax,%edx
  800a2a:	74 17                	je     800a43 <_main+0xa0b>
  800a2c:	83 ec 04             	sub    $0x4,%esp
  800a2f:	68 cb 3c 80 00       	push   $0x803ccb
  800a34:	68 c6 00 00 00       	push   $0xc6
  800a39:	68 3c 3c 80 00       	push   $0x803c3c
  800a3e:	e8 67 02 00 00       	call   800caa <_panic>

		//1 MB Hole appended to previous 1 MB + 256 KB hole and next 2 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800a43:	e8 70 18 00 00       	call   8022b8 <sys_calculate_free_frames>
  800a48:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800a4b:	e8 08 19 00 00       	call   802358 <sys_pf_calculate_allocated_pages>
  800a50:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[3]);
  800a53:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800a56:	83 ec 0c             	sub    $0xc,%esp
  800a59:	50                   	push   %eax
  800a5a:	e8 a6 14 00 00       	call   801f05 <free>
  800a5f:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  800a62:	e8 f1 18 00 00       	call   802358 <sys_pf_calculate_allocated_pages>
  800a67:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800a6a:	74 17                	je     800a83 <_main+0xa4b>
  800a6c:	83 ec 04             	sub    $0x4,%esp
  800a6f:	68 b4 3c 80 00       	push   $0x803cb4
  800a74:	68 cd 00 00 00       	push   $0xcd
  800a79:	68 3c 3c 80 00       	push   $0x803c3c
  800a7e:	e8 27 02 00 00       	call   800caa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800a83:	e8 30 18 00 00       	call   8022b8 <sys_calculate_free_frames>
  800a88:	89 c2                	mov    %eax,%edx
  800a8a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a8d:	39 c2                	cmp    %eax,%edx
  800a8f:	74 17                	je     800aa8 <_main+0xa70>
  800a91:	83 ec 04             	sub    $0x4,%esp
  800a94:	68 cb 3c 80 00       	push   $0x803ccb
  800a99:	68 ce 00 00 00       	push   $0xce
  800a9e:	68 3c 3c 80 00       	push   $0x803c3c
  800aa3:	e8 02 02 00 00       	call   800caa <_panic>

	//[5] Allocate again [test first fit]
	{
		//[FIRST FIT Case]
		//Allocate 4 MB + 256 KB - should be placed in the contiguous hole (256 KB + 4 MB)
		freeFrames = sys_calculate_free_frames() ;
  800aa8:	e8 0b 18 00 00       	call   8022b8 <sys_calculate_free_frames>
  800aad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800ab0:	e8 a3 18 00 00       	call   802358 <sys_pf_calculate_allocated_pages>
  800ab5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[13] = malloc(4*Mega + 256*kilo - kilo);
  800ab8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800abb:	c1 e0 06             	shl    $0x6,%eax
  800abe:	89 c2                	mov    %eax,%edx
  800ac0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ac3:	01 d0                	add    %edx,%eax
  800ac5:	c1 e0 02             	shl    $0x2,%eax
  800ac8:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800acb:	83 ec 0c             	sub    $0xc,%esp
  800ace:	50                   	push   %eax
  800acf:	e8 b6 13 00 00       	call   801e8a <malloc>
  800ad4:	83 c4 10             	add    $0x10,%esp
  800ad7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if ((uint32) ptr_allocations[13] != (USER_HEAP_START + 1*Mega + 768*kilo)) panic("Wrong start address for the allocated space... ");
  800ada:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800add:	89 c1                	mov    %eax,%ecx
  800adf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800ae2:	89 d0                	mov    %edx,%eax
  800ae4:	01 c0                	add    %eax,%eax
  800ae6:	01 d0                	add    %edx,%eax
  800ae8:	c1 e0 08             	shl    $0x8,%eax
  800aeb:	89 c2                	mov    %eax,%edx
  800aed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800af0:	01 d0                	add    %edx,%eax
  800af2:	05 00 00 00 80       	add    $0x80000000,%eax
  800af7:	39 c1                	cmp    %eax,%ecx
  800af9:	74 17                	je     800b12 <_main+0xada>
  800afb:	83 ec 04             	sub    $0x4,%esp
  800afe:	68 54 3c 80 00       	push   $0x803c54
  800b03:	68 d8 00 00 00       	push   $0xd8
  800b08:	68 3c 3c 80 00       	push   $0x803c3c
  800b0d:	e8 98 01 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+32) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800b12:	e8 41 18 00 00       	call   802358 <sys_pf_calculate_allocated_pages>
  800b17:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800b1a:	74 17                	je     800b33 <_main+0xafb>
  800b1c:	83 ec 04             	sub    $0x4,%esp
  800b1f:	68 84 3c 80 00       	push   $0x803c84
  800b24:	68 da 00 00 00       	push   $0xda
  800b29:	68 3c 3c 80 00       	push   $0x803c3c
  800b2e:	e8 77 01 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800b33:	e8 80 17 00 00       	call   8022b8 <sys_calculate_free_frames>
  800b38:	89 c2                	mov    %eax,%edx
  800b3a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800b3d:	39 c2                	cmp    %eax,%edx
  800b3f:	74 17                	je     800b58 <_main+0xb20>
  800b41:	83 ec 04             	sub    $0x4,%esp
  800b44:	68 a1 3c 80 00       	push   $0x803ca1
  800b49:	68 db 00 00 00       	push   $0xdb
  800b4e:	68 3c 3c 80 00       	push   $0x803c3c
  800b53:	e8 52 01 00 00       	call   800caa <_panic>
	}
	cprintf("Congratulations!! test FIRST FIT allocation (1) completed successfully.\n");
  800b58:	83 ec 0c             	sub    $0xc,%esp
  800b5b:	68 d8 3c 80 00       	push   $0x803cd8
  800b60:	e8 f9 03 00 00       	call   800f5e <cprintf>
  800b65:	83 c4 10             	add    $0x10,%esp

	return;
  800b68:	90                   	nop
}
  800b69:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800b6c:	c9                   	leave  
  800b6d:	c3                   	ret    

00800b6e <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800b6e:	55                   	push   %ebp
  800b6f:	89 e5                	mov    %esp,%ebp
  800b71:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800b74:	e8 1f 1a 00 00       	call   802598 <sys_getenvindex>
  800b79:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800b7c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b7f:	89 d0                	mov    %edx,%eax
  800b81:	c1 e0 03             	shl    $0x3,%eax
  800b84:	01 d0                	add    %edx,%eax
  800b86:	01 c0                	add    %eax,%eax
  800b88:	01 d0                	add    %edx,%eax
  800b8a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b91:	01 d0                	add    %edx,%eax
  800b93:	c1 e0 04             	shl    $0x4,%eax
  800b96:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800b9b:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800ba0:	a1 20 50 80 00       	mov    0x805020,%eax
  800ba5:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800bab:	84 c0                	test   %al,%al
  800bad:	74 0f                	je     800bbe <libmain+0x50>
		binaryname = myEnv->prog_name;
  800baf:	a1 20 50 80 00       	mov    0x805020,%eax
  800bb4:	05 5c 05 00 00       	add    $0x55c,%eax
  800bb9:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800bbe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800bc2:	7e 0a                	jle    800bce <libmain+0x60>
		binaryname = argv[0];
  800bc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc7:	8b 00                	mov    (%eax),%eax
  800bc9:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800bce:	83 ec 08             	sub    $0x8,%esp
  800bd1:	ff 75 0c             	pushl  0xc(%ebp)
  800bd4:	ff 75 08             	pushl  0x8(%ebp)
  800bd7:	e8 5c f4 ff ff       	call   800038 <_main>
  800bdc:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800bdf:	e8 c1 17 00 00       	call   8023a5 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800be4:	83 ec 0c             	sub    $0xc,%esp
  800be7:	68 3c 3d 80 00       	push   $0x803d3c
  800bec:	e8 6d 03 00 00       	call   800f5e <cprintf>
  800bf1:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800bf4:	a1 20 50 80 00       	mov    0x805020,%eax
  800bf9:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800bff:	a1 20 50 80 00       	mov    0x805020,%eax
  800c04:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800c0a:	83 ec 04             	sub    $0x4,%esp
  800c0d:	52                   	push   %edx
  800c0e:	50                   	push   %eax
  800c0f:	68 64 3d 80 00       	push   $0x803d64
  800c14:	e8 45 03 00 00       	call   800f5e <cprintf>
  800c19:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800c1c:	a1 20 50 80 00       	mov    0x805020,%eax
  800c21:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800c27:	a1 20 50 80 00       	mov    0x805020,%eax
  800c2c:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800c32:	a1 20 50 80 00       	mov    0x805020,%eax
  800c37:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800c3d:	51                   	push   %ecx
  800c3e:	52                   	push   %edx
  800c3f:	50                   	push   %eax
  800c40:	68 8c 3d 80 00       	push   $0x803d8c
  800c45:	e8 14 03 00 00       	call   800f5e <cprintf>
  800c4a:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800c4d:	a1 20 50 80 00       	mov    0x805020,%eax
  800c52:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800c58:	83 ec 08             	sub    $0x8,%esp
  800c5b:	50                   	push   %eax
  800c5c:	68 e4 3d 80 00       	push   $0x803de4
  800c61:	e8 f8 02 00 00       	call   800f5e <cprintf>
  800c66:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800c69:	83 ec 0c             	sub    $0xc,%esp
  800c6c:	68 3c 3d 80 00       	push   $0x803d3c
  800c71:	e8 e8 02 00 00       	call   800f5e <cprintf>
  800c76:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800c79:	e8 41 17 00 00       	call   8023bf <sys_enable_interrupt>

	// exit gracefully
	exit();
  800c7e:	e8 19 00 00 00       	call   800c9c <exit>
}
  800c83:	90                   	nop
  800c84:	c9                   	leave  
  800c85:	c3                   	ret    

00800c86 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800c86:	55                   	push   %ebp
  800c87:	89 e5                	mov    %esp,%ebp
  800c89:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800c8c:	83 ec 0c             	sub    $0xc,%esp
  800c8f:	6a 00                	push   $0x0
  800c91:	e8 ce 18 00 00       	call   802564 <sys_destroy_env>
  800c96:	83 c4 10             	add    $0x10,%esp
}
  800c99:	90                   	nop
  800c9a:	c9                   	leave  
  800c9b:	c3                   	ret    

00800c9c <exit>:

void
exit(void)
{
  800c9c:	55                   	push   %ebp
  800c9d:	89 e5                	mov    %esp,%ebp
  800c9f:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800ca2:	e8 23 19 00 00       	call   8025ca <sys_exit_env>
}
  800ca7:	90                   	nop
  800ca8:	c9                   	leave  
  800ca9:	c3                   	ret    

00800caa <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800caa:	55                   	push   %ebp
  800cab:	89 e5                	mov    %esp,%ebp
  800cad:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800cb0:	8d 45 10             	lea    0x10(%ebp),%eax
  800cb3:	83 c0 04             	add    $0x4,%eax
  800cb6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800cb9:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800cbe:	85 c0                	test   %eax,%eax
  800cc0:	74 16                	je     800cd8 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800cc2:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800cc7:	83 ec 08             	sub    $0x8,%esp
  800cca:	50                   	push   %eax
  800ccb:	68 f8 3d 80 00       	push   $0x803df8
  800cd0:	e8 89 02 00 00       	call   800f5e <cprintf>
  800cd5:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800cd8:	a1 00 50 80 00       	mov    0x805000,%eax
  800cdd:	ff 75 0c             	pushl  0xc(%ebp)
  800ce0:	ff 75 08             	pushl  0x8(%ebp)
  800ce3:	50                   	push   %eax
  800ce4:	68 fd 3d 80 00       	push   $0x803dfd
  800ce9:	e8 70 02 00 00       	call   800f5e <cprintf>
  800cee:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800cf1:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf4:	83 ec 08             	sub    $0x8,%esp
  800cf7:	ff 75 f4             	pushl  -0xc(%ebp)
  800cfa:	50                   	push   %eax
  800cfb:	e8 f3 01 00 00       	call   800ef3 <vcprintf>
  800d00:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800d03:	83 ec 08             	sub    $0x8,%esp
  800d06:	6a 00                	push   $0x0
  800d08:	68 19 3e 80 00       	push   $0x803e19
  800d0d:	e8 e1 01 00 00       	call   800ef3 <vcprintf>
  800d12:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800d15:	e8 82 ff ff ff       	call   800c9c <exit>

	// should not return here
	while (1) ;
  800d1a:	eb fe                	jmp    800d1a <_panic+0x70>

00800d1c <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800d1c:	55                   	push   %ebp
  800d1d:	89 e5                	mov    %esp,%ebp
  800d1f:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800d22:	a1 20 50 80 00       	mov    0x805020,%eax
  800d27:	8b 50 74             	mov    0x74(%eax),%edx
  800d2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2d:	39 c2                	cmp    %eax,%edx
  800d2f:	74 14                	je     800d45 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800d31:	83 ec 04             	sub    $0x4,%esp
  800d34:	68 1c 3e 80 00       	push   $0x803e1c
  800d39:	6a 26                	push   $0x26
  800d3b:	68 68 3e 80 00       	push   $0x803e68
  800d40:	e8 65 ff ff ff       	call   800caa <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800d45:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800d4c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800d53:	e9 c2 00 00 00       	jmp    800e1a <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800d58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d5b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800d62:	8b 45 08             	mov    0x8(%ebp),%eax
  800d65:	01 d0                	add    %edx,%eax
  800d67:	8b 00                	mov    (%eax),%eax
  800d69:	85 c0                	test   %eax,%eax
  800d6b:	75 08                	jne    800d75 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800d6d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800d70:	e9 a2 00 00 00       	jmp    800e17 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800d75:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800d7c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800d83:	eb 69                	jmp    800dee <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800d85:	a1 20 50 80 00       	mov    0x805020,%eax
  800d8a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800d90:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d93:	89 d0                	mov    %edx,%eax
  800d95:	01 c0                	add    %eax,%eax
  800d97:	01 d0                	add    %edx,%eax
  800d99:	c1 e0 03             	shl    $0x3,%eax
  800d9c:	01 c8                	add    %ecx,%eax
  800d9e:	8a 40 04             	mov    0x4(%eax),%al
  800da1:	84 c0                	test   %al,%al
  800da3:	75 46                	jne    800deb <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800da5:	a1 20 50 80 00       	mov    0x805020,%eax
  800daa:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800db0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800db3:	89 d0                	mov    %edx,%eax
  800db5:	01 c0                	add    %eax,%eax
  800db7:	01 d0                	add    %edx,%eax
  800db9:	c1 e0 03             	shl    $0x3,%eax
  800dbc:	01 c8                	add    %ecx,%eax
  800dbe:	8b 00                	mov    (%eax),%eax
  800dc0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800dc3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800dc6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800dcb:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800dcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dd0:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dda:	01 c8                	add    %ecx,%eax
  800ddc:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800dde:	39 c2                	cmp    %eax,%edx
  800de0:	75 09                	jne    800deb <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800de2:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800de9:	eb 12                	jmp    800dfd <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800deb:	ff 45 e8             	incl   -0x18(%ebp)
  800dee:	a1 20 50 80 00       	mov    0x805020,%eax
  800df3:	8b 50 74             	mov    0x74(%eax),%edx
  800df6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800df9:	39 c2                	cmp    %eax,%edx
  800dfb:	77 88                	ja     800d85 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800dfd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800e01:	75 14                	jne    800e17 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800e03:	83 ec 04             	sub    $0x4,%esp
  800e06:	68 74 3e 80 00       	push   $0x803e74
  800e0b:	6a 3a                	push   $0x3a
  800e0d:	68 68 3e 80 00       	push   $0x803e68
  800e12:	e8 93 fe ff ff       	call   800caa <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800e17:	ff 45 f0             	incl   -0x10(%ebp)
  800e1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e1d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800e20:	0f 8c 32 ff ff ff    	jl     800d58 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800e26:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800e2d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800e34:	eb 26                	jmp    800e5c <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800e36:	a1 20 50 80 00       	mov    0x805020,%eax
  800e3b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800e41:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e44:	89 d0                	mov    %edx,%eax
  800e46:	01 c0                	add    %eax,%eax
  800e48:	01 d0                	add    %edx,%eax
  800e4a:	c1 e0 03             	shl    $0x3,%eax
  800e4d:	01 c8                	add    %ecx,%eax
  800e4f:	8a 40 04             	mov    0x4(%eax),%al
  800e52:	3c 01                	cmp    $0x1,%al
  800e54:	75 03                	jne    800e59 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800e56:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800e59:	ff 45 e0             	incl   -0x20(%ebp)
  800e5c:	a1 20 50 80 00       	mov    0x805020,%eax
  800e61:	8b 50 74             	mov    0x74(%eax),%edx
  800e64:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e67:	39 c2                	cmp    %eax,%edx
  800e69:	77 cb                	ja     800e36 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800e6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e6e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800e71:	74 14                	je     800e87 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800e73:	83 ec 04             	sub    $0x4,%esp
  800e76:	68 c8 3e 80 00       	push   $0x803ec8
  800e7b:	6a 44                	push   $0x44
  800e7d:	68 68 3e 80 00       	push   $0x803e68
  800e82:	e8 23 fe ff ff       	call   800caa <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800e87:	90                   	nop
  800e88:	c9                   	leave  
  800e89:	c3                   	ret    

00800e8a <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800e8a:	55                   	push   %ebp
  800e8b:	89 e5                	mov    %esp,%ebp
  800e8d:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800e90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e93:	8b 00                	mov    (%eax),%eax
  800e95:	8d 48 01             	lea    0x1(%eax),%ecx
  800e98:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e9b:	89 0a                	mov    %ecx,(%edx)
  800e9d:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea0:	88 d1                	mov    %dl,%cl
  800ea2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ea5:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800ea9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eac:	8b 00                	mov    (%eax),%eax
  800eae:	3d ff 00 00 00       	cmp    $0xff,%eax
  800eb3:	75 2c                	jne    800ee1 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800eb5:	a0 24 50 80 00       	mov    0x805024,%al
  800eba:	0f b6 c0             	movzbl %al,%eax
  800ebd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ec0:	8b 12                	mov    (%edx),%edx
  800ec2:	89 d1                	mov    %edx,%ecx
  800ec4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ec7:	83 c2 08             	add    $0x8,%edx
  800eca:	83 ec 04             	sub    $0x4,%esp
  800ecd:	50                   	push   %eax
  800ece:	51                   	push   %ecx
  800ecf:	52                   	push   %edx
  800ed0:	e8 22 13 00 00       	call   8021f7 <sys_cputs>
  800ed5:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800ed8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800edb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800ee1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee4:	8b 40 04             	mov    0x4(%eax),%eax
  800ee7:	8d 50 01             	lea    0x1(%eax),%edx
  800eea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eed:	89 50 04             	mov    %edx,0x4(%eax)
}
  800ef0:	90                   	nop
  800ef1:	c9                   	leave  
  800ef2:	c3                   	ret    

00800ef3 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800ef3:	55                   	push   %ebp
  800ef4:	89 e5                	mov    %esp,%ebp
  800ef6:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800efc:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800f03:	00 00 00 
	b.cnt = 0;
  800f06:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800f0d:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800f10:	ff 75 0c             	pushl  0xc(%ebp)
  800f13:	ff 75 08             	pushl  0x8(%ebp)
  800f16:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800f1c:	50                   	push   %eax
  800f1d:	68 8a 0e 80 00       	push   $0x800e8a
  800f22:	e8 11 02 00 00       	call   801138 <vprintfmt>
  800f27:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800f2a:	a0 24 50 80 00       	mov    0x805024,%al
  800f2f:	0f b6 c0             	movzbl %al,%eax
  800f32:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800f38:	83 ec 04             	sub    $0x4,%esp
  800f3b:	50                   	push   %eax
  800f3c:	52                   	push   %edx
  800f3d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800f43:	83 c0 08             	add    $0x8,%eax
  800f46:	50                   	push   %eax
  800f47:	e8 ab 12 00 00       	call   8021f7 <sys_cputs>
  800f4c:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800f4f:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800f56:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800f5c:	c9                   	leave  
  800f5d:	c3                   	ret    

00800f5e <cprintf>:

int cprintf(const char *fmt, ...) {
  800f5e:	55                   	push   %ebp
  800f5f:	89 e5                	mov    %esp,%ebp
  800f61:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800f64:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800f6b:	8d 45 0c             	lea    0xc(%ebp),%eax
  800f6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800f71:	8b 45 08             	mov    0x8(%ebp),%eax
  800f74:	83 ec 08             	sub    $0x8,%esp
  800f77:	ff 75 f4             	pushl  -0xc(%ebp)
  800f7a:	50                   	push   %eax
  800f7b:	e8 73 ff ff ff       	call   800ef3 <vcprintf>
  800f80:	83 c4 10             	add    $0x10,%esp
  800f83:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800f86:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f89:	c9                   	leave  
  800f8a:	c3                   	ret    

00800f8b <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800f8b:	55                   	push   %ebp
  800f8c:	89 e5                	mov    %esp,%ebp
  800f8e:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800f91:	e8 0f 14 00 00       	call   8023a5 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800f96:	8d 45 0c             	lea    0xc(%ebp),%eax
  800f99:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9f:	83 ec 08             	sub    $0x8,%esp
  800fa2:	ff 75 f4             	pushl  -0xc(%ebp)
  800fa5:	50                   	push   %eax
  800fa6:	e8 48 ff ff ff       	call   800ef3 <vcprintf>
  800fab:	83 c4 10             	add    $0x10,%esp
  800fae:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800fb1:	e8 09 14 00 00       	call   8023bf <sys_enable_interrupt>
	return cnt;
  800fb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800fb9:	c9                   	leave  
  800fba:	c3                   	ret    

00800fbb <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800fbb:	55                   	push   %ebp
  800fbc:	89 e5                	mov    %esp,%ebp
  800fbe:	53                   	push   %ebx
  800fbf:	83 ec 14             	sub    $0x14,%esp
  800fc2:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fc8:	8b 45 14             	mov    0x14(%ebp),%eax
  800fcb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800fce:	8b 45 18             	mov    0x18(%ebp),%eax
  800fd1:	ba 00 00 00 00       	mov    $0x0,%edx
  800fd6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800fd9:	77 55                	ja     801030 <printnum+0x75>
  800fdb:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800fde:	72 05                	jb     800fe5 <printnum+0x2a>
  800fe0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800fe3:	77 4b                	ja     801030 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800fe5:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800fe8:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800feb:	8b 45 18             	mov    0x18(%ebp),%eax
  800fee:	ba 00 00 00 00       	mov    $0x0,%edx
  800ff3:	52                   	push   %edx
  800ff4:	50                   	push   %eax
  800ff5:	ff 75 f4             	pushl  -0xc(%ebp)
  800ff8:	ff 75 f0             	pushl  -0x10(%ebp)
  800ffb:	e8 b4 29 00 00       	call   8039b4 <__udivdi3>
  801000:	83 c4 10             	add    $0x10,%esp
  801003:	83 ec 04             	sub    $0x4,%esp
  801006:	ff 75 20             	pushl  0x20(%ebp)
  801009:	53                   	push   %ebx
  80100a:	ff 75 18             	pushl  0x18(%ebp)
  80100d:	52                   	push   %edx
  80100e:	50                   	push   %eax
  80100f:	ff 75 0c             	pushl  0xc(%ebp)
  801012:	ff 75 08             	pushl  0x8(%ebp)
  801015:	e8 a1 ff ff ff       	call   800fbb <printnum>
  80101a:	83 c4 20             	add    $0x20,%esp
  80101d:	eb 1a                	jmp    801039 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80101f:	83 ec 08             	sub    $0x8,%esp
  801022:	ff 75 0c             	pushl  0xc(%ebp)
  801025:	ff 75 20             	pushl  0x20(%ebp)
  801028:	8b 45 08             	mov    0x8(%ebp),%eax
  80102b:	ff d0                	call   *%eax
  80102d:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801030:	ff 4d 1c             	decl   0x1c(%ebp)
  801033:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801037:	7f e6                	jg     80101f <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801039:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80103c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801041:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801044:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801047:	53                   	push   %ebx
  801048:	51                   	push   %ecx
  801049:	52                   	push   %edx
  80104a:	50                   	push   %eax
  80104b:	e8 74 2a 00 00       	call   803ac4 <__umoddi3>
  801050:	83 c4 10             	add    $0x10,%esp
  801053:	05 34 41 80 00       	add    $0x804134,%eax
  801058:	8a 00                	mov    (%eax),%al
  80105a:	0f be c0             	movsbl %al,%eax
  80105d:	83 ec 08             	sub    $0x8,%esp
  801060:	ff 75 0c             	pushl  0xc(%ebp)
  801063:	50                   	push   %eax
  801064:	8b 45 08             	mov    0x8(%ebp),%eax
  801067:	ff d0                	call   *%eax
  801069:	83 c4 10             	add    $0x10,%esp
}
  80106c:	90                   	nop
  80106d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801070:	c9                   	leave  
  801071:	c3                   	ret    

00801072 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801072:	55                   	push   %ebp
  801073:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801075:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801079:	7e 1c                	jle    801097 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80107b:	8b 45 08             	mov    0x8(%ebp),%eax
  80107e:	8b 00                	mov    (%eax),%eax
  801080:	8d 50 08             	lea    0x8(%eax),%edx
  801083:	8b 45 08             	mov    0x8(%ebp),%eax
  801086:	89 10                	mov    %edx,(%eax)
  801088:	8b 45 08             	mov    0x8(%ebp),%eax
  80108b:	8b 00                	mov    (%eax),%eax
  80108d:	83 e8 08             	sub    $0x8,%eax
  801090:	8b 50 04             	mov    0x4(%eax),%edx
  801093:	8b 00                	mov    (%eax),%eax
  801095:	eb 40                	jmp    8010d7 <getuint+0x65>
	else if (lflag)
  801097:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80109b:	74 1e                	je     8010bb <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80109d:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a0:	8b 00                	mov    (%eax),%eax
  8010a2:	8d 50 04             	lea    0x4(%eax),%edx
  8010a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a8:	89 10                	mov    %edx,(%eax)
  8010aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ad:	8b 00                	mov    (%eax),%eax
  8010af:	83 e8 04             	sub    $0x4,%eax
  8010b2:	8b 00                	mov    (%eax),%eax
  8010b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8010b9:	eb 1c                	jmp    8010d7 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8010bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010be:	8b 00                	mov    (%eax),%eax
  8010c0:	8d 50 04             	lea    0x4(%eax),%edx
  8010c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c6:	89 10                	mov    %edx,(%eax)
  8010c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cb:	8b 00                	mov    (%eax),%eax
  8010cd:	83 e8 04             	sub    $0x4,%eax
  8010d0:	8b 00                	mov    (%eax),%eax
  8010d2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8010d7:	5d                   	pop    %ebp
  8010d8:	c3                   	ret    

008010d9 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8010d9:	55                   	push   %ebp
  8010da:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8010dc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8010e0:	7e 1c                	jle    8010fe <getint+0x25>
		return va_arg(*ap, long long);
  8010e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e5:	8b 00                	mov    (%eax),%eax
  8010e7:	8d 50 08             	lea    0x8(%eax),%edx
  8010ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ed:	89 10                	mov    %edx,(%eax)
  8010ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f2:	8b 00                	mov    (%eax),%eax
  8010f4:	83 e8 08             	sub    $0x8,%eax
  8010f7:	8b 50 04             	mov    0x4(%eax),%edx
  8010fa:	8b 00                	mov    (%eax),%eax
  8010fc:	eb 38                	jmp    801136 <getint+0x5d>
	else if (lflag)
  8010fe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801102:	74 1a                	je     80111e <getint+0x45>
		return va_arg(*ap, long);
  801104:	8b 45 08             	mov    0x8(%ebp),%eax
  801107:	8b 00                	mov    (%eax),%eax
  801109:	8d 50 04             	lea    0x4(%eax),%edx
  80110c:	8b 45 08             	mov    0x8(%ebp),%eax
  80110f:	89 10                	mov    %edx,(%eax)
  801111:	8b 45 08             	mov    0x8(%ebp),%eax
  801114:	8b 00                	mov    (%eax),%eax
  801116:	83 e8 04             	sub    $0x4,%eax
  801119:	8b 00                	mov    (%eax),%eax
  80111b:	99                   	cltd   
  80111c:	eb 18                	jmp    801136 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80111e:	8b 45 08             	mov    0x8(%ebp),%eax
  801121:	8b 00                	mov    (%eax),%eax
  801123:	8d 50 04             	lea    0x4(%eax),%edx
  801126:	8b 45 08             	mov    0x8(%ebp),%eax
  801129:	89 10                	mov    %edx,(%eax)
  80112b:	8b 45 08             	mov    0x8(%ebp),%eax
  80112e:	8b 00                	mov    (%eax),%eax
  801130:	83 e8 04             	sub    $0x4,%eax
  801133:	8b 00                	mov    (%eax),%eax
  801135:	99                   	cltd   
}
  801136:	5d                   	pop    %ebp
  801137:	c3                   	ret    

00801138 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801138:	55                   	push   %ebp
  801139:	89 e5                	mov    %esp,%ebp
  80113b:	56                   	push   %esi
  80113c:	53                   	push   %ebx
  80113d:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801140:	eb 17                	jmp    801159 <vprintfmt+0x21>
			if (ch == '\0')
  801142:	85 db                	test   %ebx,%ebx
  801144:	0f 84 af 03 00 00    	je     8014f9 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80114a:	83 ec 08             	sub    $0x8,%esp
  80114d:	ff 75 0c             	pushl  0xc(%ebp)
  801150:	53                   	push   %ebx
  801151:	8b 45 08             	mov    0x8(%ebp),%eax
  801154:	ff d0                	call   *%eax
  801156:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801159:	8b 45 10             	mov    0x10(%ebp),%eax
  80115c:	8d 50 01             	lea    0x1(%eax),%edx
  80115f:	89 55 10             	mov    %edx,0x10(%ebp)
  801162:	8a 00                	mov    (%eax),%al
  801164:	0f b6 d8             	movzbl %al,%ebx
  801167:	83 fb 25             	cmp    $0x25,%ebx
  80116a:	75 d6                	jne    801142 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80116c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801170:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801177:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80117e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801185:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80118c:	8b 45 10             	mov    0x10(%ebp),%eax
  80118f:	8d 50 01             	lea    0x1(%eax),%edx
  801192:	89 55 10             	mov    %edx,0x10(%ebp)
  801195:	8a 00                	mov    (%eax),%al
  801197:	0f b6 d8             	movzbl %al,%ebx
  80119a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80119d:	83 f8 55             	cmp    $0x55,%eax
  8011a0:	0f 87 2b 03 00 00    	ja     8014d1 <vprintfmt+0x399>
  8011a6:	8b 04 85 58 41 80 00 	mov    0x804158(,%eax,4),%eax
  8011ad:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8011af:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8011b3:	eb d7                	jmp    80118c <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8011b5:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8011b9:	eb d1                	jmp    80118c <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8011bb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8011c2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8011c5:	89 d0                	mov    %edx,%eax
  8011c7:	c1 e0 02             	shl    $0x2,%eax
  8011ca:	01 d0                	add    %edx,%eax
  8011cc:	01 c0                	add    %eax,%eax
  8011ce:	01 d8                	add    %ebx,%eax
  8011d0:	83 e8 30             	sub    $0x30,%eax
  8011d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8011d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d9:	8a 00                	mov    (%eax),%al
  8011db:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8011de:	83 fb 2f             	cmp    $0x2f,%ebx
  8011e1:	7e 3e                	jle    801221 <vprintfmt+0xe9>
  8011e3:	83 fb 39             	cmp    $0x39,%ebx
  8011e6:	7f 39                	jg     801221 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8011e8:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8011eb:	eb d5                	jmp    8011c2 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8011ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8011f0:	83 c0 04             	add    $0x4,%eax
  8011f3:	89 45 14             	mov    %eax,0x14(%ebp)
  8011f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8011f9:	83 e8 04             	sub    $0x4,%eax
  8011fc:	8b 00                	mov    (%eax),%eax
  8011fe:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801201:	eb 1f                	jmp    801222 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801203:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801207:	79 83                	jns    80118c <vprintfmt+0x54>
				width = 0;
  801209:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801210:	e9 77 ff ff ff       	jmp    80118c <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801215:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80121c:	e9 6b ff ff ff       	jmp    80118c <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801221:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801222:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801226:	0f 89 60 ff ff ff    	jns    80118c <vprintfmt+0x54>
				width = precision, precision = -1;
  80122c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80122f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801232:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801239:	e9 4e ff ff ff       	jmp    80118c <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80123e:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801241:	e9 46 ff ff ff       	jmp    80118c <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801246:	8b 45 14             	mov    0x14(%ebp),%eax
  801249:	83 c0 04             	add    $0x4,%eax
  80124c:	89 45 14             	mov    %eax,0x14(%ebp)
  80124f:	8b 45 14             	mov    0x14(%ebp),%eax
  801252:	83 e8 04             	sub    $0x4,%eax
  801255:	8b 00                	mov    (%eax),%eax
  801257:	83 ec 08             	sub    $0x8,%esp
  80125a:	ff 75 0c             	pushl  0xc(%ebp)
  80125d:	50                   	push   %eax
  80125e:	8b 45 08             	mov    0x8(%ebp),%eax
  801261:	ff d0                	call   *%eax
  801263:	83 c4 10             	add    $0x10,%esp
			break;
  801266:	e9 89 02 00 00       	jmp    8014f4 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80126b:	8b 45 14             	mov    0x14(%ebp),%eax
  80126e:	83 c0 04             	add    $0x4,%eax
  801271:	89 45 14             	mov    %eax,0x14(%ebp)
  801274:	8b 45 14             	mov    0x14(%ebp),%eax
  801277:	83 e8 04             	sub    $0x4,%eax
  80127a:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80127c:	85 db                	test   %ebx,%ebx
  80127e:	79 02                	jns    801282 <vprintfmt+0x14a>
				err = -err;
  801280:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801282:	83 fb 64             	cmp    $0x64,%ebx
  801285:	7f 0b                	jg     801292 <vprintfmt+0x15a>
  801287:	8b 34 9d a0 3f 80 00 	mov    0x803fa0(,%ebx,4),%esi
  80128e:	85 f6                	test   %esi,%esi
  801290:	75 19                	jne    8012ab <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801292:	53                   	push   %ebx
  801293:	68 45 41 80 00       	push   $0x804145
  801298:	ff 75 0c             	pushl  0xc(%ebp)
  80129b:	ff 75 08             	pushl  0x8(%ebp)
  80129e:	e8 5e 02 00 00       	call   801501 <printfmt>
  8012a3:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8012a6:	e9 49 02 00 00       	jmp    8014f4 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8012ab:	56                   	push   %esi
  8012ac:	68 4e 41 80 00       	push   $0x80414e
  8012b1:	ff 75 0c             	pushl  0xc(%ebp)
  8012b4:	ff 75 08             	pushl  0x8(%ebp)
  8012b7:	e8 45 02 00 00       	call   801501 <printfmt>
  8012bc:	83 c4 10             	add    $0x10,%esp
			break;
  8012bf:	e9 30 02 00 00       	jmp    8014f4 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8012c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8012c7:	83 c0 04             	add    $0x4,%eax
  8012ca:	89 45 14             	mov    %eax,0x14(%ebp)
  8012cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8012d0:	83 e8 04             	sub    $0x4,%eax
  8012d3:	8b 30                	mov    (%eax),%esi
  8012d5:	85 f6                	test   %esi,%esi
  8012d7:	75 05                	jne    8012de <vprintfmt+0x1a6>
				p = "(null)";
  8012d9:	be 51 41 80 00       	mov    $0x804151,%esi
			if (width > 0 && padc != '-')
  8012de:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8012e2:	7e 6d                	jle    801351 <vprintfmt+0x219>
  8012e4:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8012e8:	74 67                	je     801351 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8012ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012ed:	83 ec 08             	sub    $0x8,%esp
  8012f0:	50                   	push   %eax
  8012f1:	56                   	push   %esi
  8012f2:	e8 0c 03 00 00       	call   801603 <strnlen>
  8012f7:	83 c4 10             	add    $0x10,%esp
  8012fa:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8012fd:	eb 16                	jmp    801315 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8012ff:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801303:	83 ec 08             	sub    $0x8,%esp
  801306:	ff 75 0c             	pushl  0xc(%ebp)
  801309:	50                   	push   %eax
  80130a:	8b 45 08             	mov    0x8(%ebp),%eax
  80130d:	ff d0                	call   *%eax
  80130f:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801312:	ff 4d e4             	decl   -0x1c(%ebp)
  801315:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801319:	7f e4                	jg     8012ff <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80131b:	eb 34                	jmp    801351 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80131d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801321:	74 1c                	je     80133f <vprintfmt+0x207>
  801323:	83 fb 1f             	cmp    $0x1f,%ebx
  801326:	7e 05                	jle    80132d <vprintfmt+0x1f5>
  801328:	83 fb 7e             	cmp    $0x7e,%ebx
  80132b:	7e 12                	jle    80133f <vprintfmt+0x207>
					putch('?', putdat);
  80132d:	83 ec 08             	sub    $0x8,%esp
  801330:	ff 75 0c             	pushl  0xc(%ebp)
  801333:	6a 3f                	push   $0x3f
  801335:	8b 45 08             	mov    0x8(%ebp),%eax
  801338:	ff d0                	call   *%eax
  80133a:	83 c4 10             	add    $0x10,%esp
  80133d:	eb 0f                	jmp    80134e <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80133f:	83 ec 08             	sub    $0x8,%esp
  801342:	ff 75 0c             	pushl  0xc(%ebp)
  801345:	53                   	push   %ebx
  801346:	8b 45 08             	mov    0x8(%ebp),%eax
  801349:	ff d0                	call   *%eax
  80134b:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80134e:	ff 4d e4             	decl   -0x1c(%ebp)
  801351:	89 f0                	mov    %esi,%eax
  801353:	8d 70 01             	lea    0x1(%eax),%esi
  801356:	8a 00                	mov    (%eax),%al
  801358:	0f be d8             	movsbl %al,%ebx
  80135b:	85 db                	test   %ebx,%ebx
  80135d:	74 24                	je     801383 <vprintfmt+0x24b>
  80135f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801363:	78 b8                	js     80131d <vprintfmt+0x1e5>
  801365:	ff 4d e0             	decl   -0x20(%ebp)
  801368:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80136c:	79 af                	jns    80131d <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80136e:	eb 13                	jmp    801383 <vprintfmt+0x24b>
				putch(' ', putdat);
  801370:	83 ec 08             	sub    $0x8,%esp
  801373:	ff 75 0c             	pushl  0xc(%ebp)
  801376:	6a 20                	push   $0x20
  801378:	8b 45 08             	mov    0x8(%ebp),%eax
  80137b:	ff d0                	call   *%eax
  80137d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801380:	ff 4d e4             	decl   -0x1c(%ebp)
  801383:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801387:	7f e7                	jg     801370 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801389:	e9 66 01 00 00       	jmp    8014f4 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80138e:	83 ec 08             	sub    $0x8,%esp
  801391:	ff 75 e8             	pushl  -0x18(%ebp)
  801394:	8d 45 14             	lea    0x14(%ebp),%eax
  801397:	50                   	push   %eax
  801398:	e8 3c fd ff ff       	call   8010d9 <getint>
  80139d:	83 c4 10             	add    $0x10,%esp
  8013a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013a3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8013a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013ac:	85 d2                	test   %edx,%edx
  8013ae:	79 23                	jns    8013d3 <vprintfmt+0x29b>
				putch('-', putdat);
  8013b0:	83 ec 08             	sub    $0x8,%esp
  8013b3:	ff 75 0c             	pushl  0xc(%ebp)
  8013b6:	6a 2d                	push   $0x2d
  8013b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bb:	ff d0                	call   *%eax
  8013bd:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8013c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013c6:	f7 d8                	neg    %eax
  8013c8:	83 d2 00             	adc    $0x0,%edx
  8013cb:	f7 da                	neg    %edx
  8013cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013d0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8013d3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8013da:	e9 bc 00 00 00       	jmp    80149b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8013df:	83 ec 08             	sub    $0x8,%esp
  8013e2:	ff 75 e8             	pushl  -0x18(%ebp)
  8013e5:	8d 45 14             	lea    0x14(%ebp),%eax
  8013e8:	50                   	push   %eax
  8013e9:	e8 84 fc ff ff       	call   801072 <getuint>
  8013ee:	83 c4 10             	add    $0x10,%esp
  8013f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013f4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8013f7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8013fe:	e9 98 00 00 00       	jmp    80149b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801403:	83 ec 08             	sub    $0x8,%esp
  801406:	ff 75 0c             	pushl  0xc(%ebp)
  801409:	6a 58                	push   $0x58
  80140b:	8b 45 08             	mov    0x8(%ebp),%eax
  80140e:	ff d0                	call   *%eax
  801410:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801413:	83 ec 08             	sub    $0x8,%esp
  801416:	ff 75 0c             	pushl  0xc(%ebp)
  801419:	6a 58                	push   $0x58
  80141b:	8b 45 08             	mov    0x8(%ebp),%eax
  80141e:	ff d0                	call   *%eax
  801420:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801423:	83 ec 08             	sub    $0x8,%esp
  801426:	ff 75 0c             	pushl  0xc(%ebp)
  801429:	6a 58                	push   $0x58
  80142b:	8b 45 08             	mov    0x8(%ebp),%eax
  80142e:	ff d0                	call   *%eax
  801430:	83 c4 10             	add    $0x10,%esp
			break;
  801433:	e9 bc 00 00 00       	jmp    8014f4 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801438:	83 ec 08             	sub    $0x8,%esp
  80143b:	ff 75 0c             	pushl  0xc(%ebp)
  80143e:	6a 30                	push   $0x30
  801440:	8b 45 08             	mov    0x8(%ebp),%eax
  801443:	ff d0                	call   *%eax
  801445:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801448:	83 ec 08             	sub    $0x8,%esp
  80144b:	ff 75 0c             	pushl  0xc(%ebp)
  80144e:	6a 78                	push   $0x78
  801450:	8b 45 08             	mov    0x8(%ebp),%eax
  801453:	ff d0                	call   *%eax
  801455:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801458:	8b 45 14             	mov    0x14(%ebp),%eax
  80145b:	83 c0 04             	add    $0x4,%eax
  80145e:	89 45 14             	mov    %eax,0x14(%ebp)
  801461:	8b 45 14             	mov    0x14(%ebp),%eax
  801464:	83 e8 04             	sub    $0x4,%eax
  801467:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801469:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80146c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801473:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80147a:	eb 1f                	jmp    80149b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80147c:	83 ec 08             	sub    $0x8,%esp
  80147f:	ff 75 e8             	pushl  -0x18(%ebp)
  801482:	8d 45 14             	lea    0x14(%ebp),%eax
  801485:	50                   	push   %eax
  801486:	e8 e7 fb ff ff       	call   801072 <getuint>
  80148b:	83 c4 10             	add    $0x10,%esp
  80148e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801491:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801494:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80149b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80149f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014a2:	83 ec 04             	sub    $0x4,%esp
  8014a5:	52                   	push   %edx
  8014a6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8014a9:	50                   	push   %eax
  8014aa:	ff 75 f4             	pushl  -0xc(%ebp)
  8014ad:	ff 75 f0             	pushl  -0x10(%ebp)
  8014b0:	ff 75 0c             	pushl  0xc(%ebp)
  8014b3:	ff 75 08             	pushl  0x8(%ebp)
  8014b6:	e8 00 fb ff ff       	call   800fbb <printnum>
  8014bb:	83 c4 20             	add    $0x20,%esp
			break;
  8014be:	eb 34                	jmp    8014f4 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8014c0:	83 ec 08             	sub    $0x8,%esp
  8014c3:	ff 75 0c             	pushl  0xc(%ebp)
  8014c6:	53                   	push   %ebx
  8014c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ca:	ff d0                	call   *%eax
  8014cc:	83 c4 10             	add    $0x10,%esp
			break;
  8014cf:	eb 23                	jmp    8014f4 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8014d1:	83 ec 08             	sub    $0x8,%esp
  8014d4:	ff 75 0c             	pushl  0xc(%ebp)
  8014d7:	6a 25                	push   $0x25
  8014d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014dc:	ff d0                	call   *%eax
  8014de:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8014e1:	ff 4d 10             	decl   0x10(%ebp)
  8014e4:	eb 03                	jmp    8014e9 <vprintfmt+0x3b1>
  8014e6:	ff 4d 10             	decl   0x10(%ebp)
  8014e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ec:	48                   	dec    %eax
  8014ed:	8a 00                	mov    (%eax),%al
  8014ef:	3c 25                	cmp    $0x25,%al
  8014f1:	75 f3                	jne    8014e6 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8014f3:	90                   	nop
		}
	}
  8014f4:	e9 47 fc ff ff       	jmp    801140 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8014f9:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8014fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014fd:	5b                   	pop    %ebx
  8014fe:	5e                   	pop    %esi
  8014ff:	5d                   	pop    %ebp
  801500:	c3                   	ret    

00801501 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801501:	55                   	push   %ebp
  801502:	89 e5                	mov    %esp,%ebp
  801504:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801507:	8d 45 10             	lea    0x10(%ebp),%eax
  80150a:	83 c0 04             	add    $0x4,%eax
  80150d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801510:	8b 45 10             	mov    0x10(%ebp),%eax
  801513:	ff 75 f4             	pushl  -0xc(%ebp)
  801516:	50                   	push   %eax
  801517:	ff 75 0c             	pushl  0xc(%ebp)
  80151a:	ff 75 08             	pushl  0x8(%ebp)
  80151d:	e8 16 fc ff ff       	call   801138 <vprintfmt>
  801522:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801525:	90                   	nop
  801526:	c9                   	leave  
  801527:	c3                   	ret    

00801528 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801528:	55                   	push   %ebp
  801529:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80152b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80152e:	8b 40 08             	mov    0x8(%eax),%eax
  801531:	8d 50 01             	lea    0x1(%eax),%edx
  801534:	8b 45 0c             	mov    0xc(%ebp),%eax
  801537:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80153a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80153d:	8b 10                	mov    (%eax),%edx
  80153f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801542:	8b 40 04             	mov    0x4(%eax),%eax
  801545:	39 c2                	cmp    %eax,%edx
  801547:	73 12                	jae    80155b <sprintputch+0x33>
		*b->buf++ = ch;
  801549:	8b 45 0c             	mov    0xc(%ebp),%eax
  80154c:	8b 00                	mov    (%eax),%eax
  80154e:	8d 48 01             	lea    0x1(%eax),%ecx
  801551:	8b 55 0c             	mov    0xc(%ebp),%edx
  801554:	89 0a                	mov    %ecx,(%edx)
  801556:	8b 55 08             	mov    0x8(%ebp),%edx
  801559:	88 10                	mov    %dl,(%eax)
}
  80155b:	90                   	nop
  80155c:	5d                   	pop    %ebp
  80155d:	c3                   	ret    

0080155e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80155e:	55                   	push   %ebp
  80155f:	89 e5                	mov    %esp,%ebp
  801561:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801564:	8b 45 08             	mov    0x8(%ebp),%eax
  801567:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80156a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801570:	8b 45 08             	mov    0x8(%ebp),%eax
  801573:	01 d0                	add    %edx,%eax
  801575:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801578:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80157f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801583:	74 06                	je     80158b <vsnprintf+0x2d>
  801585:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801589:	7f 07                	jg     801592 <vsnprintf+0x34>
		return -E_INVAL;
  80158b:	b8 03 00 00 00       	mov    $0x3,%eax
  801590:	eb 20                	jmp    8015b2 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801592:	ff 75 14             	pushl  0x14(%ebp)
  801595:	ff 75 10             	pushl  0x10(%ebp)
  801598:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80159b:	50                   	push   %eax
  80159c:	68 28 15 80 00       	push   $0x801528
  8015a1:	e8 92 fb ff ff       	call   801138 <vprintfmt>
  8015a6:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8015a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015ac:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8015af:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8015b2:	c9                   	leave  
  8015b3:	c3                   	ret    

008015b4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8015b4:	55                   	push   %ebp
  8015b5:	89 e5                	mov    %esp,%ebp
  8015b7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8015ba:	8d 45 10             	lea    0x10(%ebp),%eax
  8015bd:	83 c0 04             	add    $0x4,%eax
  8015c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8015c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8015c6:	ff 75 f4             	pushl  -0xc(%ebp)
  8015c9:	50                   	push   %eax
  8015ca:	ff 75 0c             	pushl  0xc(%ebp)
  8015cd:	ff 75 08             	pushl  0x8(%ebp)
  8015d0:	e8 89 ff ff ff       	call   80155e <vsnprintf>
  8015d5:	83 c4 10             	add    $0x10,%esp
  8015d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8015db:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015de:	c9                   	leave  
  8015df:	c3                   	ret    

008015e0 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8015e0:	55                   	push   %ebp
  8015e1:	89 e5                	mov    %esp,%ebp
  8015e3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8015e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015ed:	eb 06                	jmp    8015f5 <strlen+0x15>
		n++;
  8015ef:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8015f2:	ff 45 08             	incl   0x8(%ebp)
  8015f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f8:	8a 00                	mov    (%eax),%al
  8015fa:	84 c0                	test   %al,%al
  8015fc:	75 f1                	jne    8015ef <strlen+0xf>
		n++;
	return n;
  8015fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801601:	c9                   	leave  
  801602:	c3                   	ret    

00801603 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801603:	55                   	push   %ebp
  801604:	89 e5                	mov    %esp,%ebp
  801606:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801609:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801610:	eb 09                	jmp    80161b <strnlen+0x18>
		n++;
  801612:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801615:	ff 45 08             	incl   0x8(%ebp)
  801618:	ff 4d 0c             	decl   0xc(%ebp)
  80161b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80161f:	74 09                	je     80162a <strnlen+0x27>
  801621:	8b 45 08             	mov    0x8(%ebp),%eax
  801624:	8a 00                	mov    (%eax),%al
  801626:	84 c0                	test   %al,%al
  801628:	75 e8                	jne    801612 <strnlen+0xf>
		n++;
	return n;
  80162a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80162d:	c9                   	leave  
  80162e:	c3                   	ret    

0080162f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80162f:	55                   	push   %ebp
  801630:	89 e5                	mov    %esp,%ebp
  801632:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801635:	8b 45 08             	mov    0x8(%ebp),%eax
  801638:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80163b:	90                   	nop
  80163c:	8b 45 08             	mov    0x8(%ebp),%eax
  80163f:	8d 50 01             	lea    0x1(%eax),%edx
  801642:	89 55 08             	mov    %edx,0x8(%ebp)
  801645:	8b 55 0c             	mov    0xc(%ebp),%edx
  801648:	8d 4a 01             	lea    0x1(%edx),%ecx
  80164b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80164e:	8a 12                	mov    (%edx),%dl
  801650:	88 10                	mov    %dl,(%eax)
  801652:	8a 00                	mov    (%eax),%al
  801654:	84 c0                	test   %al,%al
  801656:	75 e4                	jne    80163c <strcpy+0xd>
		/* do nothing */;
	return ret;
  801658:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80165b:	c9                   	leave  
  80165c:	c3                   	ret    

0080165d <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80165d:	55                   	push   %ebp
  80165e:	89 e5                	mov    %esp,%ebp
  801660:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801663:	8b 45 08             	mov    0x8(%ebp),%eax
  801666:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801669:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801670:	eb 1f                	jmp    801691 <strncpy+0x34>
		*dst++ = *src;
  801672:	8b 45 08             	mov    0x8(%ebp),%eax
  801675:	8d 50 01             	lea    0x1(%eax),%edx
  801678:	89 55 08             	mov    %edx,0x8(%ebp)
  80167b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80167e:	8a 12                	mov    (%edx),%dl
  801680:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801682:	8b 45 0c             	mov    0xc(%ebp),%eax
  801685:	8a 00                	mov    (%eax),%al
  801687:	84 c0                	test   %al,%al
  801689:	74 03                	je     80168e <strncpy+0x31>
			src++;
  80168b:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80168e:	ff 45 fc             	incl   -0x4(%ebp)
  801691:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801694:	3b 45 10             	cmp    0x10(%ebp),%eax
  801697:	72 d9                	jb     801672 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801699:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80169c:	c9                   	leave  
  80169d:	c3                   	ret    

0080169e <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80169e:	55                   	push   %ebp
  80169f:	89 e5                	mov    %esp,%ebp
  8016a1:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8016a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8016aa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016ae:	74 30                	je     8016e0 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8016b0:	eb 16                	jmp    8016c8 <strlcpy+0x2a>
			*dst++ = *src++;
  8016b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b5:	8d 50 01             	lea    0x1(%eax),%edx
  8016b8:	89 55 08             	mov    %edx,0x8(%ebp)
  8016bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016be:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016c1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8016c4:	8a 12                	mov    (%edx),%dl
  8016c6:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8016c8:	ff 4d 10             	decl   0x10(%ebp)
  8016cb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016cf:	74 09                	je     8016da <strlcpy+0x3c>
  8016d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016d4:	8a 00                	mov    (%eax),%al
  8016d6:	84 c0                	test   %al,%al
  8016d8:	75 d8                	jne    8016b2 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8016da:	8b 45 08             	mov    0x8(%ebp),%eax
  8016dd:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8016e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8016e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016e6:	29 c2                	sub    %eax,%edx
  8016e8:	89 d0                	mov    %edx,%eax
}
  8016ea:	c9                   	leave  
  8016eb:	c3                   	ret    

008016ec <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8016ec:	55                   	push   %ebp
  8016ed:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8016ef:	eb 06                	jmp    8016f7 <strcmp+0xb>
		p++, q++;
  8016f1:	ff 45 08             	incl   0x8(%ebp)
  8016f4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8016f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fa:	8a 00                	mov    (%eax),%al
  8016fc:	84 c0                	test   %al,%al
  8016fe:	74 0e                	je     80170e <strcmp+0x22>
  801700:	8b 45 08             	mov    0x8(%ebp),%eax
  801703:	8a 10                	mov    (%eax),%dl
  801705:	8b 45 0c             	mov    0xc(%ebp),%eax
  801708:	8a 00                	mov    (%eax),%al
  80170a:	38 c2                	cmp    %al,%dl
  80170c:	74 e3                	je     8016f1 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80170e:	8b 45 08             	mov    0x8(%ebp),%eax
  801711:	8a 00                	mov    (%eax),%al
  801713:	0f b6 d0             	movzbl %al,%edx
  801716:	8b 45 0c             	mov    0xc(%ebp),%eax
  801719:	8a 00                	mov    (%eax),%al
  80171b:	0f b6 c0             	movzbl %al,%eax
  80171e:	29 c2                	sub    %eax,%edx
  801720:	89 d0                	mov    %edx,%eax
}
  801722:	5d                   	pop    %ebp
  801723:	c3                   	ret    

00801724 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801724:	55                   	push   %ebp
  801725:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801727:	eb 09                	jmp    801732 <strncmp+0xe>
		n--, p++, q++;
  801729:	ff 4d 10             	decl   0x10(%ebp)
  80172c:	ff 45 08             	incl   0x8(%ebp)
  80172f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801732:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801736:	74 17                	je     80174f <strncmp+0x2b>
  801738:	8b 45 08             	mov    0x8(%ebp),%eax
  80173b:	8a 00                	mov    (%eax),%al
  80173d:	84 c0                	test   %al,%al
  80173f:	74 0e                	je     80174f <strncmp+0x2b>
  801741:	8b 45 08             	mov    0x8(%ebp),%eax
  801744:	8a 10                	mov    (%eax),%dl
  801746:	8b 45 0c             	mov    0xc(%ebp),%eax
  801749:	8a 00                	mov    (%eax),%al
  80174b:	38 c2                	cmp    %al,%dl
  80174d:	74 da                	je     801729 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80174f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801753:	75 07                	jne    80175c <strncmp+0x38>
		return 0;
  801755:	b8 00 00 00 00       	mov    $0x0,%eax
  80175a:	eb 14                	jmp    801770 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80175c:	8b 45 08             	mov    0x8(%ebp),%eax
  80175f:	8a 00                	mov    (%eax),%al
  801761:	0f b6 d0             	movzbl %al,%edx
  801764:	8b 45 0c             	mov    0xc(%ebp),%eax
  801767:	8a 00                	mov    (%eax),%al
  801769:	0f b6 c0             	movzbl %al,%eax
  80176c:	29 c2                	sub    %eax,%edx
  80176e:	89 d0                	mov    %edx,%eax
}
  801770:	5d                   	pop    %ebp
  801771:	c3                   	ret    

00801772 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801772:	55                   	push   %ebp
  801773:	89 e5                	mov    %esp,%ebp
  801775:	83 ec 04             	sub    $0x4,%esp
  801778:	8b 45 0c             	mov    0xc(%ebp),%eax
  80177b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80177e:	eb 12                	jmp    801792 <strchr+0x20>
		if (*s == c)
  801780:	8b 45 08             	mov    0x8(%ebp),%eax
  801783:	8a 00                	mov    (%eax),%al
  801785:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801788:	75 05                	jne    80178f <strchr+0x1d>
			return (char *) s;
  80178a:	8b 45 08             	mov    0x8(%ebp),%eax
  80178d:	eb 11                	jmp    8017a0 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80178f:	ff 45 08             	incl   0x8(%ebp)
  801792:	8b 45 08             	mov    0x8(%ebp),%eax
  801795:	8a 00                	mov    (%eax),%al
  801797:	84 c0                	test   %al,%al
  801799:	75 e5                	jne    801780 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80179b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017a0:	c9                   	leave  
  8017a1:	c3                   	ret    

008017a2 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8017a2:	55                   	push   %ebp
  8017a3:	89 e5                	mov    %esp,%ebp
  8017a5:	83 ec 04             	sub    $0x4,%esp
  8017a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ab:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8017ae:	eb 0d                	jmp    8017bd <strfind+0x1b>
		if (*s == c)
  8017b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b3:	8a 00                	mov    (%eax),%al
  8017b5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8017b8:	74 0e                	je     8017c8 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8017ba:	ff 45 08             	incl   0x8(%ebp)
  8017bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c0:	8a 00                	mov    (%eax),%al
  8017c2:	84 c0                	test   %al,%al
  8017c4:	75 ea                	jne    8017b0 <strfind+0xe>
  8017c6:	eb 01                	jmp    8017c9 <strfind+0x27>
		if (*s == c)
			break;
  8017c8:	90                   	nop
	return (char *) s;
  8017c9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017cc:	c9                   	leave  
  8017cd:	c3                   	ret    

008017ce <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8017ce:	55                   	push   %ebp
  8017cf:	89 e5                	mov    %esp,%ebp
  8017d1:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8017d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8017da:	8b 45 10             	mov    0x10(%ebp),%eax
  8017dd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8017e0:	eb 0e                	jmp    8017f0 <memset+0x22>
		*p++ = c;
  8017e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017e5:	8d 50 01             	lea    0x1(%eax),%edx
  8017e8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8017eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ee:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8017f0:	ff 4d f8             	decl   -0x8(%ebp)
  8017f3:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8017f7:	79 e9                	jns    8017e2 <memset+0x14>
		*p++ = c;

	return v;
  8017f9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017fc:	c9                   	leave  
  8017fd:	c3                   	ret    

008017fe <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8017fe:	55                   	push   %ebp
  8017ff:	89 e5                	mov    %esp,%ebp
  801801:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801804:	8b 45 0c             	mov    0xc(%ebp),%eax
  801807:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80180a:	8b 45 08             	mov    0x8(%ebp),%eax
  80180d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801810:	eb 16                	jmp    801828 <memcpy+0x2a>
		*d++ = *s++;
  801812:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801815:	8d 50 01             	lea    0x1(%eax),%edx
  801818:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80181b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80181e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801821:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801824:	8a 12                	mov    (%edx),%dl
  801826:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801828:	8b 45 10             	mov    0x10(%ebp),%eax
  80182b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80182e:	89 55 10             	mov    %edx,0x10(%ebp)
  801831:	85 c0                	test   %eax,%eax
  801833:	75 dd                	jne    801812 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801835:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801838:	c9                   	leave  
  801839:	c3                   	ret    

0080183a <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80183a:	55                   	push   %ebp
  80183b:	89 e5                	mov    %esp,%ebp
  80183d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801840:	8b 45 0c             	mov    0xc(%ebp),%eax
  801843:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801846:	8b 45 08             	mov    0x8(%ebp),%eax
  801849:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80184c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80184f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801852:	73 50                	jae    8018a4 <memmove+0x6a>
  801854:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801857:	8b 45 10             	mov    0x10(%ebp),%eax
  80185a:	01 d0                	add    %edx,%eax
  80185c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80185f:	76 43                	jbe    8018a4 <memmove+0x6a>
		s += n;
  801861:	8b 45 10             	mov    0x10(%ebp),%eax
  801864:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801867:	8b 45 10             	mov    0x10(%ebp),%eax
  80186a:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80186d:	eb 10                	jmp    80187f <memmove+0x45>
			*--d = *--s;
  80186f:	ff 4d f8             	decl   -0x8(%ebp)
  801872:	ff 4d fc             	decl   -0x4(%ebp)
  801875:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801878:	8a 10                	mov    (%eax),%dl
  80187a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80187d:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80187f:	8b 45 10             	mov    0x10(%ebp),%eax
  801882:	8d 50 ff             	lea    -0x1(%eax),%edx
  801885:	89 55 10             	mov    %edx,0x10(%ebp)
  801888:	85 c0                	test   %eax,%eax
  80188a:	75 e3                	jne    80186f <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80188c:	eb 23                	jmp    8018b1 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80188e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801891:	8d 50 01             	lea    0x1(%eax),%edx
  801894:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801897:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80189a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80189d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8018a0:	8a 12                	mov    (%edx),%dl
  8018a2:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8018a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8018a7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8018aa:	89 55 10             	mov    %edx,0x10(%ebp)
  8018ad:	85 c0                	test   %eax,%eax
  8018af:	75 dd                	jne    80188e <memmove+0x54>
			*d++ = *s++;

	return dst;
  8018b1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8018b4:	c9                   	leave  
  8018b5:	c3                   	ret    

008018b6 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8018b6:	55                   	push   %ebp
  8018b7:	89 e5                	mov    %esp,%ebp
  8018b9:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8018bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8018c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c5:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8018c8:	eb 2a                	jmp    8018f4 <memcmp+0x3e>
		if (*s1 != *s2)
  8018ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018cd:	8a 10                	mov    (%eax),%dl
  8018cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018d2:	8a 00                	mov    (%eax),%al
  8018d4:	38 c2                	cmp    %al,%dl
  8018d6:	74 16                	je     8018ee <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8018d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018db:	8a 00                	mov    (%eax),%al
  8018dd:	0f b6 d0             	movzbl %al,%edx
  8018e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018e3:	8a 00                	mov    (%eax),%al
  8018e5:	0f b6 c0             	movzbl %al,%eax
  8018e8:	29 c2                	sub    %eax,%edx
  8018ea:	89 d0                	mov    %edx,%eax
  8018ec:	eb 18                	jmp    801906 <memcmp+0x50>
		s1++, s2++;
  8018ee:	ff 45 fc             	incl   -0x4(%ebp)
  8018f1:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8018f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8018f7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8018fa:	89 55 10             	mov    %edx,0x10(%ebp)
  8018fd:	85 c0                	test   %eax,%eax
  8018ff:	75 c9                	jne    8018ca <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801901:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801906:	c9                   	leave  
  801907:	c3                   	ret    

00801908 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801908:	55                   	push   %ebp
  801909:	89 e5                	mov    %esp,%ebp
  80190b:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80190e:	8b 55 08             	mov    0x8(%ebp),%edx
  801911:	8b 45 10             	mov    0x10(%ebp),%eax
  801914:	01 d0                	add    %edx,%eax
  801916:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801919:	eb 15                	jmp    801930 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80191b:	8b 45 08             	mov    0x8(%ebp),%eax
  80191e:	8a 00                	mov    (%eax),%al
  801920:	0f b6 d0             	movzbl %al,%edx
  801923:	8b 45 0c             	mov    0xc(%ebp),%eax
  801926:	0f b6 c0             	movzbl %al,%eax
  801929:	39 c2                	cmp    %eax,%edx
  80192b:	74 0d                	je     80193a <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80192d:	ff 45 08             	incl   0x8(%ebp)
  801930:	8b 45 08             	mov    0x8(%ebp),%eax
  801933:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801936:	72 e3                	jb     80191b <memfind+0x13>
  801938:	eb 01                	jmp    80193b <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80193a:	90                   	nop
	return (void *) s;
  80193b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80193e:	c9                   	leave  
  80193f:	c3                   	ret    

00801940 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801940:	55                   	push   %ebp
  801941:	89 e5                	mov    %esp,%ebp
  801943:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801946:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80194d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801954:	eb 03                	jmp    801959 <strtol+0x19>
		s++;
  801956:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801959:	8b 45 08             	mov    0x8(%ebp),%eax
  80195c:	8a 00                	mov    (%eax),%al
  80195e:	3c 20                	cmp    $0x20,%al
  801960:	74 f4                	je     801956 <strtol+0x16>
  801962:	8b 45 08             	mov    0x8(%ebp),%eax
  801965:	8a 00                	mov    (%eax),%al
  801967:	3c 09                	cmp    $0x9,%al
  801969:	74 eb                	je     801956 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80196b:	8b 45 08             	mov    0x8(%ebp),%eax
  80196e:	8a 00                	mov    (%eax),%al
  801970:	3c 2b                	cmp    $0x2b,%al
  801972:	75 05                	jne    801979 <strtol+0x39>
		s++;
  801974:	ff 45 08             	incl   0x8(%ebp)
  801977:	eb 13                	jmp    80198c <strtol+0x4c>
	else if (*s == '-')
  801979:	8b 45 08             	mov    0x8(%ebp),%eax
  80197c:	8a 00                	mov    (%eax),%al
  80197e:	3c 2d                	cmp    $0x2d,%al
  801980:	75 0a                	jne    80198c <strtol+0x4c>
		s++, neg = 1;
  801982:	ff 45 08             	incl   0x8(%ebp)
  801985:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80198c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801990:	74 06                	je     801998 <strtol+0x58>
  801992:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801996:	75 20                	jne    8019b8 <strtol+0x78>
  801998:	8b 45 08             	mov    0x8(%ebp),%eax
  80199b:	8a 00                	mov    (%eax),%al
  80199d:	3c 30                	cmp    $0x30,%al
  80199f:	75 17                	jne    8019b8 <strtol+0x78>
  8019a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a4:	40                   	inc    %eax
  8019a5:	8a 00                	mov    (%eax),%al
  8019a7:	3c 78                	cmp    $0x78,%al
  8019a9:	75 0d                	jne    8019b8 <strtol+0x78>
		s += 2, base = 16;
  8019ab:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8019af:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8019b6:	eb 28                	jmp    8019e0 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8019b8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019bc:	75 15                	jne    8019d3 <strtol+0x93>
  8019be:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c1:	8a 00                	mov    (%eax),%al
  8019c3:	3c 30                	cmp    $0x30,%al
  8019c5:	75 0c                	jne    8019d3 <strtol+0x93>
		s++, base = 8;
  8019c7:	ff 45 08             	incl   0x8(%ebp)
  8019ca:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8019d1:	eb 0d                	jmp    8019e0 <strtol+0xa0>
	else if (base == 0)
  8019d3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019d7:	75 07                	jne    8019e0 <strtol+0xa0>
		base = 10;
  8019d9:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8019e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e3:	8a 00                	mov    (%eax),%al
  8019e5:	3c 2f                	cmp    $0x2f,%al
  8019e7:	7e 19                	jle    801a02 <strtol+0xc2>
  8019e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ec:	8a 00                	mov    (%eax),%al
  8019ee:	3c 39                	cmp    $0x39,%al
  8019f0:	7f 10                	jg     801a02 <strtol+0xc2>
			dig = *s - '0';
  8019f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f5:	8a 00                	mov    (%eax),%al
  8019f7:	0f be c0             	movsbl %al,%eax
  8019fa:	83 e8 30             	sub    $0x30,%eax
  8019fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a00:	eb 42                	jmp    801a44 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801a02:	8b 45 08             	mov    0x8(%ebp),%eax
  801a05:	8a 00                	mov    (%eax),%al
  801a07:	3c 60                	cmp    $0x60,%al
  801a09:	7e 19                	jle    801a24 <strtol+0xe4>
  801a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0e:	8a 00                	mov    (%eax),%al
  801a10:	3c 7a                	cmp    $0x7a,%al
  801a12:	7f 10                	jg     801a24 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801a14:	8b 45 08             	mov    0x8(%ebp),%eax
  801a17:	8a 00                	mov    (%eax),%al
  801a19:	0f be c0             	movsbl %al,%eax
  801a1c:	83 e8 57             	sub    $0x57,%eax
  801a1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a22:	eb 20                	jmp    801a44 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801a24:	8b 45 08             	mov    0x8(%ebp),%eax
  801a27:	8a 00                	mov    (%eax),%al
  801a29:	3c 40                	cmp    $0x40,%al
  801a2b:	7e 39                	jle    801a66 <strtol+0x126>
  801a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a30:	8a 00                	mov    (%eax),%al
  801a32:	3c 5a                	cmp    $0x5a,%al
  801a34:	7f 30                	jg     801a66 <strtol+0x126>
			dig = *s - 'A' + 10;
  801a36:	8b 45 08             	mov    0x8(%ebp),%eax
  801a39:	8a 00                	mov    (%eax),%al
  801a3b:	0f be c0             	movsbl %al,%eax
  801a3e:	83 e8 37             	sub    $0x37,%eax
  801a41:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801a44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a47:	3b 45 10             	cmp    0x10(%ebp),%eax
  801a4a:	7d 19                	jge    801a65 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801a4c:	ff 45 08             	incl   0x8(%ebp)
  801a4f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a52:	0f af 45 10          	imul   0x10(%ebp),%eax
  801a56:	89 c2                	mov    %eax,%edx
  801a58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a5b:	01 d0                	add    %edx,%eax
  801a5d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801a60:	e9 7b ff ff ff       	jmp    8019e0 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801a65:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801a66:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a6a:	74 08                	je     801a74 <strtol+0x134>
		*endptr = (char *) s;
  801a6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a6f:	8b 55 08             	mov    0x8(%ebp),%edx
  801a72:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801a74:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801a78:	74 07                	je     801a81 <strtol+0x141>
  801a7a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a7d:	f7 d8                	neg    %eax
  801a7f:	eb 03                	jmp    801a84 <strtol+0x144>
  801a81:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801a84:	c9                   	leave  
  801a85:	c3                   	ret    

00801a86 <ltostr>:

void
ltostr(long value, char *str)
{
  801a86:	55                   	push   %ebp
  801a87:	89 e5                	mov    %esp,%ebp
  801a89:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801a8c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801a93:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801a9a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a9e:	79 13                	jns    801ab3 <ltostr+0x2d>
	{
		neg = 1;
  801aa0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801aa7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aaa:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801aad:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801ab0:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab6:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801abb:	99                   	cltd   
  801abc:	f7 f9                	idiv   %ecx
  801abe:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801ac1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ac4:	8d 50 01             	lea    0x1(%eax),%edx
  801ac7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801aca:	89 c2                	mov    %eax,%edx
  801acc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801acf:	01 d0                	add    %edx,%eax
  801ad1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ad4:	83 c2 30             	add    $0x30,%edx
  801ad7:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801ad9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801adc:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801ae1:	f7 e9                	imul   %ecx
  801ae3:	c1 fa 02             	sar    $0x2,%edx
  801ae6:	89 c8                	mov    %ecx,%eax
  801ae8:	c1 f8 1f             	sar    $0x1f,%eax
  801aeb:	29 c2                	sub    %eax,%edx
  801aed:	89 d0                	mov    %edx,%eax
  801aef:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801af2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801af5:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801afa:	f7 e9                	imul   %ecx
  801afc:	c1 fa 02             	sar    $0x2,%edx
  801aff:	89 c8                	mov    %ecx,%eax
  801b01:	c1 f8 1f             	sar    $0x1f,%eax
  801b04:	29 c2                	sub    %eax,%edx
  801b06:	89 d0                	mov    %edx,%eax
  801b08:	c1 e0 02             	shl    $0x2,%eax
  801b0b:	01 d0                	add    %edx,%eax
  801b0d:	01 c0                	add    %eax,%eax
  801b0f:	29 c1                	sub    %eax,%ecx
  801b11:	89 ca                	mov    %ecx,%edx
  801b13:	85 d2                	test   %edx,%edx
  801b15:	75 9c                	jne    801ab3 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801b17:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801b1e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b21:	48                   	dec    %eax
  801b22:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801b25:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801b29:	74 3d                	je     801b68 <ltostr+0xe2>
		start = 1 ;
  801b2b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801b32:	eb 34                	jmp    801b68 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801b34:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b37:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b3a:	01 d0                	add    %edx,%eax
  801b3c:	8a 00                	mov    (%eax),%al
  801b3e:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801b41:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b44:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b47:	01 c2                	add    %eax,%edx
  801b49:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801b4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b4f:	01 c8                	add    %ecx,%eax
  801b51:	8a 00                	mov    (%eax),%al
  801b53:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801b55:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b58:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b5b:	01 c2                	add    %eax,%edx
  801b5d:	8a 45 eb             	mov    -0x15(%ebp),%al
  801b60:	88 02                	mov    %al,(%edx)
		start++ ;
  801b62:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801b65:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801b68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b6b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b6e:	7c c4                	jl     801b34 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801b70:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801b73:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b76:	01 d0                	add    %edx,%eax
  801b78:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801b7b:	90                   	nop
  801b7c:	c9                   	leave  
  801b7d:	c3                   	ret    

00801b7e <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801b7e:	55                   	push   %ebp
  801b7f:	89 e5                	mov    %esp,%ebp
  801b81:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801b84:	ff 75 08             	pushl  0x8(%ebp)
  801b87:	e8 54 fa ff ff       	call   8015e0 <strlen>
  801b8c:	83 c4 04             	add    $0x4,%esp
  801b8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801b92:	ff 75 0c             	pushl  0xc(%ebp)
  801b95:	e8 46 fa ff ff       	call   8015e0 <strlen>
  801b9a:	83 c4 04             	add    $0x4,%esp
  801b9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801ba0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801ba7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801bae:	eb 17                	jmp    801bc7 <strcconcat+0x49>
		final[s] = str1[s] ;
  801bb0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801bb3:	8b 45 10             	mov    0x10(%ebp),%eax
  801bb6:	01 c2                	add    %eax,%edx
  801bb8:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbe:	01 c8                	add    %ecx,%eax
  801bc0:	8a 00                	mov    (%eax),%al
  801bc2:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801bc4:	ff 45 fc             	incl   -0x4(%ebp)
  801bc7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bca:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801bcd:	7c e1                	jl     801bb0 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801bcf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801bd6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801bdd:	eb 1f                	jmp    801bfe <strcconcat+0x80>
		final[s++] = str2[i] ;
  801bdf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801be2:	8d 50 01             	lea    0x1(%eax),%edx
  801be5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801be8:	89 c2                	mov    %eax,%edx
  801bea:	8b 45 10             	mov    0x10(%ebp),%eax
  801bed:	01 c2                	add    %eax,%edx
  801bef:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801bf2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bf5:	01 c8                	add    %ecx,%eax
  801bf7:	8a 00                	mov    (%eax),%al
  801bf9:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801bfb:	ff 45 f8             	incl   -0x8(%ebp)
  801bfe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c01:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801c04:	7c d9                	jl     801bdf <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801c06:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c09:	8b 45 10             	mov    0x10(%ebp),%eax
  801c0c:	01 d0                	add    %edx,%eax
  801c0e:	c6 00 00             	movb   $0x0,(%eax)
}
  801c11:	90                   	nop
  801c12:	c9                   	leave  
  801c13:	c3                   	ret    

00801c14 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801c14:	55                   	push   %ebp
  801c15:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801c17:	8b 45 14             	mov    0x14(%ebp),%eax
  801c1a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801c20:	8b 45 14             	mov    0x14(%ebp),%eax
  801c23:	8b 00                	mov    (%eax),%eax
  801c25:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c2c:	8b 45 10             	mov    0x10(%ebp),%eax
  801c2f:	01 d0                	add    %edx,%eax
  801c31:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801c37:	eb 0c                	jmp    801c45 <strsplit+0x31>
			*string++ = 0;
  801c39:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3c:	8d 50 01             	lea    0x1(%eax),%edx
  801c3f:	89 55 08             	mov    %edx,0x8(%ebp)
  801c42:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801c45:	8b 45 08             	mov    0x8(%ebp),%eax
  801c48:	8a 00                	mov    (%eax),%al
  801c4a:	84 c0                	test   %al,%al
  801c4c:	74 18                	je     801c66 <strsplit+0x52>
  801c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c51:	8a 00                	mov    (%eax),%al
  801c53:	0f be c0             	movsbl %al,%eax
  801c56:	50                   	push   %eax
  801c57:	ff 75 0c             	pushl  0xc(%ebp)
  801c5a:	e8 13 fb ff ff       	call   801772 <strchr>
  801c5f:	83 c4 08             	add    $0x8,%esp
  801c62:	85 c0                	test   %eax,%eax
  801c64:	75 d3                	jne    801c39 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801c66:	8b 45 08             	mov    0x8(%ebp),%eax
  801c69:	8a 00                	mov    (%eax),%al
  801c6b:	84 c0                	test   %al,%al
  801c6d:	74 5a                	je     801cc9 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801c6f:	8b 45 14             	mov    0x14(%ebp),%eax
  801c72:	8b 00                	mov    (%eax),%eax
  801c74:	83 f8 0f             	cmp    $0xf,%eax
  801c77:	75 07                	jne    801c80 <strsplit+0x6c>
		{
			return 0;
  801c79:	b8 00 00 00 00       	mov    $0x0,%eax
  801c7e:	eb 66                	jmp    801ce6 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801c80:	8b 45 14             	mov    0x14(%ebp),%eax
  801c83:	8b 00                	mov    (%eax),%eax
  801c85:	8d 48 01             	lea    0x1(%eax),%ecx
  801c88:	8b 55 14             	mov    0x14(%ebp),%edx
  801c8b:	89 0a                	mov    %ecx,(%edx)
  801c8d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c94:	8b 45 10             	mov    0x10(%ebp),%eax
  801c97:	01 c2                	add    %eax,%edx
  801c99:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c9e:	eb 03                	jmp    801ca3 <strsplit+0x8f>
			string++;
  801ca0:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca6:	8a 00                	mov    (%eax),%al
  801ca8:	84 c0                	test   %al,%al
  801caa:	74 8b                	je     801c37 <strsplit+0x23>
  801cac:	8b 45 08             	mov    0x8(%ebp),%eax
  801caf:	8a 00                	mov    (%eax),%al
  801cb1:	0f be c0             	movsbl %al,%eax
  801cb4:	50                   	push   %eax
  801cb5:	ff 75 0c             	pushl  0xc(%ebp)
  801cb8:	e8 b5 fa ff ff       	call   801772 <strchr>
  801cbd:	83 c4 08             	add    $0x8,%esp
  801cc0:	85 c0                	test   %eax,%eax
  801cc2:	74 dc                	je     801ca0 <strsplit+0x8c>
			string++;
	}
  801cc4:	e9 6e ff ff ff       	jmp    801c37 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801cc9:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801cca:	8b 45 14             	mov    0x14(%ebp),%eax
  801ccd:	8b 00                	mov    (%eax),%eax
  801ccf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801cd6:	8b 45 10             	mov    0x10(%ebp),%eax
  801cd9:	01 d0                	add    %edx,%eax
  801cdb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801ce1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801ce6:	c9                   	leave  
  801ce7:	c3                   	ret    

00801ce8 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801ce8:	55                   	push   %ebp
  801ce9:	89 e5                	mov    %esp,%ebp
  801ceb:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801cee:	a1 04 50 80 00       	mov    0x805004,%eax
  801cf3:	85 c0                	test   %eax,%eax
  801cf5:	74 1f                	je     801d16 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801cf7:	e8 1d 00 00 00       	call   801d19 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801cfc:	83 ec 0c             	sub    $0xc,%esp
  801cff:	68 b0 42 80 00       	push   $0x8042b0
  801d04:	e8 55 f2 ff ff       	call   800f5e <cprintf>
  801d09:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801d0c:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801d13:	00 00 00 
	}
}
  801d16:	90                   	nop
  801d17:	c9                   	leave  
  801d18:	c3                   	ret    

00801d19 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801d19:	55                   	push   %ebp
  801d1a:	89 e5                	mov    %esp,%ebp
  801d1c:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  801d1f:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801d26:	00 00 00 
  801d29:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801d30:	00 00 00 
  801d33:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801d3a:	00 00 00 
		LIST_INIT(&AllocMemBlocksList);
  801d3d:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801d44:	00 00 00 
  801d47:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801d4e:	00 00 00 
  801d51:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801d58:	00 00 00 

		MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES ;
  801d5b:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801d62:	00 02 00 
		MemBlockNodes =(struct MemBlock*)USER_DYN_BLKS_ARRAY ;
  801d65:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801d6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d6f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d74:	2d 00 10 00 00       	sub    $0x1000,%eax
  801d79:	a3 50 50 80 00       	mov    %eax,0x805050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock),PAGE_SIZE),PERM_USER|PERM_WRITEABLE);
  801d7e:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801d85:	a1 20 51 80 00       	mov    0x805120,%eax
  801d8a:	c1 e0 04             	shl    $0x4,%eax
  801d8d:	89 c2                	mov    %eax,%edx
  801d8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d92:	01 d0                	add    %edx,%eax
  801d94:	48                   	dec    %eax
  801d95:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801d98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d9b:	ba 00 00 00 00       	mov    $0x0,%edx
  801da0:	f7 75 f0             	divl   -0x10(%ebp)
  801da3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801da6:	29 d0                	sub    %edx,%eax
  801da8:	89 c2                	mov    %eax,%edx
  801daa:	c7 45 e8 00 00 e0 7f 	movl   $0x7fe00000,-0x18(%ebp)
  801db1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801db4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801db9:	2d 00 10 00 00       	sub    $0x1000,%eax
  801dbe:	83 ec 04             	sub    $0x4,%esp
  801dc1:	6a 06                	push   $0x6
  801dc3:	52                   	push   %edx
  801dc4:	50                   	push   %eax
  801dc5:	e8 71 05 00 00       	call   80233b <sys_allocate_chunk>
  801dca:	83 c4 10             	add    $0x10,%esp
		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801dcd:	a1 20 51 80 00       	mov    0x805120,%eax
  801dd2:	83 ec 0c             	sub    $0xc,%esp
  801dd5:	50                   	push   %eax
  801dd6:	e8 e6 0b 00 00       	call   8029c1 <initialize_MemBlocksList>
  801ddb:	83 c4 10             	add    $0x10,%esp

		struct MemBlock  *block_node;
		block_node = AvailableMemBlocksList.lh_first;
  801dde:	a1 48 51 80 00       	mov    0x805148,%eax
  801de3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&(AvailableMemBlocksList),block_node);
  801de6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801dea:	75 14                	jne    801e00 <initialize_dyn_block_system+0xe7>
  801dec:	83 ec 04             	sub    $0x4,%esp
  801def:	68 d5 42 80 00       	push   $0x8042d5
  801df4:	6a 2b                	push   $0x2b
  801df6:	68 f3 42 80 00       	push   $0x8042f3
  801dfb:	e8 aa ee ff ff       	call   800caa <_panic>
  801e00:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e03:	8b 00                	mov    (%eax),%eax
  801e05:	85 c0                	test   %eax,%eax
  801e07:	74 10                	je     801e19 <initialize_dyn_block_system+0x100>
  801e09:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e0c:	8b 00                	mov    (%eax),%eax
  801e0e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801e11:	8b 52 04             	mov    0x4(%edx),%edx
  801e14:	89 50 04             	mov    %edx,0x4(%eax)
  801e17:	eb 0b                	jmp    801e24 <initialize_dyn_block_system+0x10b>
  801e19:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e1c:	8b 40 04             	mov    0x4(%eax),%eax
  801e1f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801e24:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e27:	8b 40 04             	mov    0x4(%eax),%eax
  801e2a:	85 c0                	test   %eax,%eax
  801e2c:	74 0f                	je     801e3d <initialize_dyn_block_system+0x124>
  801e2e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e31:	8b 40 04             	mov    0x4(%eax),%eax
  801e34:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801e37:	8b 12                	mov    (%edx),%edx
  801e39:	89 10                	mov    %edx,(%eax)
  801e3b:	eb 0a                	jmp    801e47 <initialize_dyn_block_system+0x12e>
  801e3d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e40:	8b 00                	mov    (%eax),%eax
  801e42:	a3 48 51 80 00       	mov    %eax,0x805148
  801e47:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e4a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e50:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e53:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801e5a:	a1 54 51 80 00       	mov    0x805154,%eax
  801e5f:	48                   	dec    %eax
  801e60:	a3 54 51 80 00       	mov    %eax,0x805154
		block_node->sva = USER_HEAP_START ;
  801e65:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e68:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
		block_node->size = ((USER_HEAP_MAX - USER_HEAP_START));
  801e6f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e72:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		insert_sorted_with_merge_freeList(block_node);
  801e79:	83 ec 0c             	sub    $0xc,%esp
  801e7c:	ff 75 e4             	pushl  -0x1c(%ebp)
  801e7f:	e8 d2 13 00 00       	call   803256 <insert_sorted_with_merge_freeList>
  801e84:	83 c4 10             	add    $0x10,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801e87:	90                   	nop
  801e88:	c9                   	leave  
  801e89:	c3                   	ret    

00801e8a <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801e8a:	55                   	push   %ebp
  801e8b:	89 e5                	mov    %esp,%ebp
  801e8d:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e90:	e8 53 fe ff ff       	call   801ce8 <InitializeUHeap>
	if (size == 0) return NULL ;
  801e95:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801e99:	75 07                	jne    801ea2 <malloc+0x18>
  801e9b:	b8 00 00 00 00       	mov    $0x0,%eax
  801ea0:	eb 61                	jmp    801f03 <malloc+0x79>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	size= ROUNDUP(size,PAGE_SIZE);
  801ea2:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801ea9:	8b 55 08             	mov    0x8(%ebp),%edx
  801eac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eaf:	01 d0                	add    %edx,%eax
  801eb1:	48                   	dec    %eax
  801eb2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801eb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eb8:	ba 00 00 00 00       	mov    $0x0,%edx
  801ebd:	f7 75 f4             	divl   -0xc(%ebp)
  801ec0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ec3:	29 d0                	sub    %edx,%eax
  801ec5:	89 45 08             	mov    %eax,0x8(%ebp)
	    			if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801ec8:	e8 3c 08 00 00       	call   802709 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801ecd:	85 c0                	test   %eax,%eax
  801ecf:	74 2d                	je     801efe <malloc+0x74>
	    			{
	    				struct MemBlock * ff_block = alloc_block_FF(size);
  801ed1:	83 ec 0c             	sub    $0xc,%esp
  801ed4:	ff 75 08             	pushl  0x8(%ebp)
  801ed7:	e8 3e 0f 00 00       	call   802e1a <alloc_block_FF>
  801edc:	83 c4 10             	add    $0x10,%esp
  801edf:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    				if(ff_block!=NULL)
  801ee2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801ee6:	74 16                	je     801efe <malloc+0x74>
	    				{

	    					insert_sorted_allocList(ff_block);
  801ee8:	83 ec 0c             	sub    $0xc,%esp
  801eeb:	ff 75 ec             	pushl  -0x14(%ebp)
  801eee:	e8 48 0c 00 00       	call   802b3b <insert_sorted_allocList>
  801ef3:	83 c4 10             	add    $0x10,%esp
	    					return (void*) ff_block->sva ;
  801ef6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ef9:	8b 40 08             	mov    0x8(%eax),%eax
  801efc:	eb 05                	jmp    801f03 <malloc+0x79>

	    				}
	}
	    			return (void*) NULL ;
  801efe:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801f03:	c9                   	leave  
  801f04:	c3                   	ret    

00801f05 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801f05:	55                   	push   %ebp
  801f06:	89 e5                	mov    %esp,%ebp
  801f08:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock *elementForEach;
		virtual_address = ROUNDDOWN(virtual_address, PAGE_SIZE);
  801f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f14:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801f19:	89 45 08             	mov    %eax,0x8(%ebp)
	//	if (is_mallocPages[indexindex((uint32) virtual_address)] == 1) {
		elementForEach = find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1f:	83 ec 08             	sub    $0x8,%esp
  801f22:	50                   	push   %eax
  801f23:	68 40 50 80 00       	push   $0x805040
  801f28:	e8 71 0b 00 00       	call   802a9e <find_block>
  801f2d:	83 c4 10             	add    $0x10,%esp
  801f30:	89 45 f0             	mov    %eax,-0x10(%ebp)
		sys_free_user_mem((uint32) virtual_address, elementForEach->size);
  801f33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f36:	8b 50 0c             	mov    0xc(%eax),%edx
  801f39:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3c:	83 ec 08             	sub    $0x8,%esp
  801f3f:	52                   	push   %edx
  801f40:	50                   	push   %eax
  801f41:	e8 bd 03 00 00       	call   802303 <sys_free_user_mem>
  801f46:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,elementForEach);
  801f49:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f4d:	75 14                	jne    801f63 <free+0x5e>
  801f4f:	83 ec 04             	sub    $0x4,%esp
  801f52:	68 d5 42 80 00       	push   $0x8042d5
  801f57:	6a 71                	push   $0x71
  801f59:	68 f3 42 80 00       	push   $0x8042f3
  801f5e:	e8 47 ed ff ff       	call   800caa <_panic>
  801f63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f66:	8b 00                	mov    (%eax),%eax
  801f68:	85 c0                	test   %eax,%eax
  801f6a:	74 10                	je     801f7c <free+0x77>
  801f6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f6f:	8b 00                	mov    (%eax),%eax
  801f71:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f74:	8b 52 04             	mov    0x4(%edx),%edx
  801f77:	89 50 04             	mov    %edx,0x4(%eax)
  801f7a:	eb 0b                	jmp    801f87 <free+0x82>
  801f7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f7f:	8b 40 04             	mov    0x4(%eax),%eax
  801f82:	a3 44 50 80 00       	mov    %eax,0x805044
  801f87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f8a:	8b 40 04             	mov    0x4(%eax),%eax
  801f8d:	85 c0                	test   %eax,%eax
  801f8f:	74 0f                	je     801fa0 <free+0x9b>
  801f91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f94:	8b 40 04             	mov    0x4(%eax),%eax
  801f97:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f9a:	8b 12                	mov    (%edx),%edx
  801f9c:	89 10                	mov    %edx,(%eax)
  801f9e:	eb 0a                	jmp    801faa <free+0xa5>
  801fa0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fa3:	8b 00                	mov    (%eax),%eax
  801fa5:	a3 40 50 80 00       	mov    %eax,0x805040
  801faa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801fb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fb6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801fbd:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801fc2:	48                   	dec    %eax
  801fc3:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(elementForEach);
  801fc8:	83 ec 0c             	sub    $0xc,%esp
  801fcb:	ff 75 f0             	pushl  -0x10(%ebp)
  801fce:	e8 83 12 00 00       	call   803256 <insert_sorted_with_merge_freeList>
  801fd3:	83 c4 10             	add    $0x10,%esp
	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801fd6:	90                   	nop
  801fd7:	c9                   	leave  
  801fd8:	c3                   	ret    

00801fd9 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801fd9:	55                   	push   %ebp
  801fda:	89 e5                	mov    %esp,%ebp
  801fdc:	83 ec 28             	sub    $0x28,%esp
  801fdf:	8b 45 10             	mov    0x10(%ebp),%eax
  801fe2:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801fe5:	e8 fe fc ff ff       	call   801ce8 <InitializeUHeap>
	if (size == 0) return NULL ;
  801fea:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801fee:	75 0a                	jne    801ffa <smalloc+0x21>
  801ff0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ff5:	e9 86 00 00 00       	jmp    802080 <smalloc+0xa7>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code

	size=ROUNDUP(size,PAGE_SIZE);
  801ffa:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  802001:	8b 55 0c             	mov    0xc(%ebp),%edx
  802004:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802007:	01 d0                	add    %edx,%eax
  802009:	48                   	dec    %eax
  80200a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80200d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802010:	ba 00 00 00 00       	mov    $0x0,%edx
  802015:	f7 75 f4             	divl   -0xc(%ebp)
  802018:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80201b:	29 d0                	sub    %edx,%eax
  80201d:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  802020:	e8 e4 06 00 00       	call   802709 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802025:	85 c0                	test   %eax,%eax
  802027:	74 52                	je     80207b <smalloc+0xa2>
		{
		struct MemBlock * ff_block ;
		ff_block = alloc_block_FF(size);
  802029:	83 ec 0c             	sub    $0xc,%esp
  80202c:	ff 75 0c             	pushl  0xc(%ebp)
  80202f:	e8 e6 0d 00 00       	call   802e1a <alloc_block_FF>
  802034:	83 c4 10             	add    $0x10,%esp
  802037:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(ff_block==NULL)
  80203a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80203e:	75 07                	jne    802047 <smalloc+0x6e>
			return NULL ;
  802040:	b8 00 00 00 00       	mov    $0x0,%eax
  802045:	eb 39                	jmp    802080 <smalloc+0xa7>

		int obj_id =sys_createSharedObject(sharedVarName,size,isWritable,(void*)ff_block->sva);
  802047:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80204a:	8b 40 08             	mov    0x8(%eax),%eax
  80204d:	89 c2                	mov    %eax,%edx
  80204f:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  802053:	52                   	push   %edx
  802054:	50                   	push   %eax
  802055:	ff 75 0c             	pushl  0xc(%ebp)
  802058:	ff 75 08             	pushl  0x8(%ebp)
  80205b:	e8 2e 04 00 00       	call   80248e <sys_createSharedObject>
  802060:	83 c4 10             	add    $0x10,%esp
  802063:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(obj_id < 0)
  802066:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80206a:	79 07                	jns    802073 <smalloc+0x9a>
			return (void*)NULL ;
  80206c:	b8 00 00 00 00       	mov    $0x0,%eax
  802071:	eb 0d                	jmp    802080 <smalloc+0xa7>
		else
		    return (void*)ff_block->sva ;
  802073:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802076:	8b 40 08             	mov    0x8(%eax),%eax
  802079:	eb 05                	jmp    802080 <smalloc+0xa7>
		}
		return (void*)NULL ;
  80207b:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  802080:	c9                   	leave  
  802081:	c3                   	ret    

00802082 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802082:	55                   	push   %ebp
  802083:	89 e5                	mov    %esp,%ebp
  802085:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802088:	e8 5b fc ff ff       	call   801ce8 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80208d:	83 ec 08             	sub    $0x8,%esp
  802090:	ff 75 0c             	pushl  0xc(%ebp)
  802093:	ff 75 08             	pushl  0x8(%ebp)
  802096:	e8 1d 04 00 00       	call   8024b8 <sys_getSizeOfSharedObject>
  80209b:	83 c4 10             	add    $0x10,%esp
  80209e:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(size == 0)
  8020a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020a5:	75 0a                	jne    8020b1 <sget+0x2f>
			return NULL ;
  8020a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ac:	e9 83 00 00 00       	jmp    802134 <sget+0xb2>
		size=ROUNDUP(size,PAGE_SIZE);
  8020b1:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8020b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020be:	01 d0                	add    %edx,%eax
  8020c0:	48                   	dec    %eax
  8020c1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8020c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8020cc:	f7 75 f0             	divl   -0x10(%ebp)
  8020cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020d2:	29 d0                	sub    %edx,%eax
  8020d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8020d7:	e8 2d 06 00 00       	call   802709 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8020dc:	85 c0                	test   %eax,%eax
  8020de:	74 4f                	je     80212f <sget+0xad>
		{
			struct MemBlock * ff_block ;
				ff_block = alloc_block_FF(size);
  8020e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e3:	83 ec 0c             	sub    $0xc,%esp
  8020e6:	50                   	push   %eax
  8020e7:	e8 2e 0d 00 00       	call   802e1a <alloc_block_FF>
  8020ec:	83 c4 10             	add    $0x10,%esp
  8020ef:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ff_block==NULL)
  8020f2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8020f6:	75 07                	jne    8020ff <sget+0x7d>
					return (void*)NULL ;
  8020f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8020fd:	eb 35                	jmp    802134 <sget+0xb2>

		int obj_id =sys_getSharedObject((int)ownerEnvID,sharedVarName,(void*)ff_block->sva);
  8020ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802102:	8b 40 08             	mov    0x8(%eax),%eax
  802105:	83 ec 04             	sub    $0x4,%esp
  802108:	50                   	push   %eax
  802109:	ff 75 0c             	pushl  0xc(%ebp)
  80210c:	ff 75 08             	pushl  0x8(%ebp)
  80210f:	e8 c1 03 00 00       	call   8024d5 <sys_getSharedObject>
  802114:	83 c4 10             	add    $0x10,%esp
  802117:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if(obj_id<0)
  80211a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80211e:	79 07                	jns    802127 <sget+0xa5>
				return (void*)NULL ;
  802120:	b8 00 00 00 00       	mov    $0x0,%eax
  802125:	eb 0d                	jmp    802134 <sget+0xb2>
			else
				return (void*)ff_block->sva ;
  802127:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80212a:	8b 40 08             	mov    0x8(%eax),%eax
  80212d:	eb 05                	jmp    802134 <sget+0xb2>


		}
	return (void*)NULL ;
  80212f:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  802134:	c9                   	leave  
  802135:	c3                   	ret    

00802136 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802136:	55                   	push   %ebp
  802137:	89 e5                	mov    %esp,%ebp
  802139:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80213c:	e8 a7 fb ff ff       	call   801ce8 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802141:	83 ec 04             	sub    $0x4,%esp
  802144:	68 00 43 80 00       	push   $0x804300
  802149:	68 f9 00 00 00       	push   $0xf9
  80214e:	68 f3 42 80 00       	push   $0x8042f3
  802153:	e8 52 eb ff ff       	call   800caa <_panic>

00802158 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802158:	55                   	push   %ebp
  802159:	89 e5                	mov    %esp,%ebp
  80215b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80215e:	83 ec 04             	sub    $0x4,%esp
  802161:	68 28 43 80 00       	push   $0x804328
  802166:	68 0d 01 00 00       	push   $0x10d
  80216b:	68 f3 42 80 00       	push   $0x8042f3
  802170:	e8 35 eb ff ff       	call   800caa <_panic>

00802175 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  802175:	55                   	push   %ebp
  802176:	89 e5                	mov    %esp,%ebp
  802178:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80217b:	83 ec 04             	sub    $0x4,%esp
  80217e:	68 4c 43 80 00       	push   $0x80434c
  802183:	68 18 01 00 00       	push   $0x118
  802188:	68 f3 42 80 00       	push   $0x8042f3
  80218d:	e8 18 eb ff ff       	call   800caa <_panic>

00802192 <shrink>:

}
void shrink(uint32 newSize)
{
  802192:	55                   	push   %ebp
  802193:	89 e5                	mov    %esp,%ebp
  802195:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802198:	83 ec 04             	sub    $0x4,%esp
  80219b:	68 4c 43 80 00       	push   $0x80434c
  8021a0:	68 1d 01 00 00       	push   $0x11d
  8021a5:	68 f3 42 80 00       	push   $0x8042f3
  8021aa:	e8 fb ea ff ff       	call   800caa <_panic>

008021af <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8021af:	55                   	push   %ebp
  8021b0:	89 e5                	mov    %esp,%ebp
  8021b2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8021b5:	83 ec 04             	sub    $0x4,%esp
  8021b8:	68 4c 43 80 00       	push   $0x80434c
  8021bd:	68 22 01 00 00       	push   $0x122
  8021c2:	68 f3 42 80 00       	push   $0x8042f3
  8021c7:	e8 de ea ff ff       	call   800caa <_panic>

008021cc <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8021cc:	55                   	push   %ebp
  8021cd:	89 e5                	mov    %esp,%ebp
  8021cf:	57                   	push   %edi
  8021d0:	56                   	push   %esi
  8021d1:	53                   	push   %ebx
  8021d2:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8021d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021db:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021de:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021e1:	8b 7d 18             	mov    0x18(%ebp),%edi
  8021e4:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8021e7:	cd 30                	int    $0x30
  8021e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8021ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8021ef:	83 c4 10             	add    $0x10,%esp
  8021f2:	5b                   	pop    %ebx
  8021f3:	5e                   	pop    %esi
  8021f4:	5f                   	pop    %edi
  8021f5:	5d                   	pop    %ebp
  8021f6:	c3                   	ret    

008021f7 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8021f7:	55                   	push   %ebp
  8021f8:	89 e5                	mov    %esp,%ebp
  8021fa:	83 ec 04             	sub    $0x4,%esp
  8021fd:	8b 45 10             	mov    0x10(%ebp),%eax
  802200:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802203:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802207:	8b 45 08             	mov    0x8(%ebp),%eax
  80220a:	6a 00                	push   $0x0
  80220c:	6a 00                	push   $0x0
  80220e:	52                   	push   %edx
  80220f:	ff 75 0c             	pushl  0xc(%ebp)
  802212:	50                   	push   %eax
  802213:	6a 00                	push   $0x0
  802215:	e8 b2 ff ff ff       	call   8021cc <syscall>
  80221a:	83 c4 18             	add    $0x18,%esp
}
  80221d:	90                   	nop
  80221e:	c9                   	leave  
  80221f:	c3                   	ret    

00802220 <sys_cgetc>:

int
sys_cgetc(void)
{
  802220:	55                   	push   %ebp
  802221:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802223:	6a 00                	push   $0x0
  802225:	6a 00                	push   $0x0
  802227:	6a 00                	push   $0x0
  802229:	6a 00                	push   $0x0
  80222b:	6a 00                	push   $0x0
  80222d:	6a 01                	push   $0x1
  80222f:	e8 98 ff ff ff       	call   8021cc <syscall>
  802234:	83 c4 18             	add    $0x18,%esp
}
  802237:	c9                   	leave  
  802238:	c3                   	ret    

00802239 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802239:	55                   	push   %ebp
  80223a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80223c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80223f:	8b 45 08             	mov    0x8(%ebp),%eax
  802242:	6a 00                	push   $0x0
  802244:	6a 00                	push   $0x0
  802246:	6a 00                	push   $0x0
  802248:	52                   	push   %edx
  802249:	50                   	push   %eax
  80224a:	6a 05                	push   $0x5
  80224c:	e8 7b ff ff ff       	call   8021cc <syscall>
  802251:	83 c4 18             	add    $0x18,%esp
}
  802254:	c9                   	leave  
  802255:	c3                   	ret    

00802256 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802256:	55                   	push   %ebp
  802257:	89 e5                	mov    %esp,%ebp
  802259:	56                   	push   %esi
  80225a:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80225b:	8b 75 18             	mov    0x18(%ebp),%esi
  80225e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802261:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802264:	8b 55 0c             	mov    0xc(%ebp),%edx
  802267:	8b 45 08             	mov    0x8(%ebp),%eax
  80226a:	56                   	push   %esi
  80226b:	53                   	push   %ebx
  80226c:	51                   	push   %ecx
  80226d:	52                   	push   %edx
  80226e:	50                   	push   %eax
  80226f:	6a 06                	push   $0x6
  802271:	e8 56 ff ff ff       	call   8021cc <syscall>
  802276:	83 c4 18             	add    $0x18,%esp
}
  802279:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80227c:	5b                   	pop    %ebx
  80227d:	5e                   	pop    %esi
  80227e:	5d                   	pop    %ebp
  80227f:	c3                   	ret    

00802280 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802280:	55                   	push   %ebp
  802281:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802283:	8b 55 0c             	mov    0xc(%ebp),%edx
  802286:	8b 45 08             	mov    0x8(%ebp),%eax
  802289:	6a 00                	push   $0x0
  80228b:	6a 00                	push   $0x0
  80228d:	6a 00                	push   $0x0
  80228f:	52                   	push   %edx
  802290:	50                   	push   %eax
  802291:	6a 07                	push   $0x7
  802293:	e8 34 ff ff ff       	call   8021cc <syscall>
  802298:	83 c4 18             	add    $0x18,%esp
}
  80229b:	c9                   	leave  
  80229c:	c3                   	ret    

0080229d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80229d:	55                   	push   %ebp
  80229e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8022a0:	6a 00                	push   $0x0
  8022a2:	6a 00                	push   $0x0
  8022a4:	6a 00                	push   $0x0
  8022a6:	ff 75 0c             	pushl  0xc(%ebp)
  8022a9:	ff 75 08             	pushl  0x8(%ebp)
  8022ac:	6a 08                	push   $0x8
  8022ae:	e8 19 ff ff ff       	call   8021cc <syscall>
  8022b3:	83 c4 18             	add    $0x18,%esp
}
  8022b6:	c9                   	leave  
  8022b7:	c3                   	ret    

008022b8 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8022b8:	55                   	push   %ebp
  8022b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8022bb:	6a 00                	push   $0x0
  8022bd:	6a 00                	push   $0x0
  8022bf:	6a 00                	push   $0x0
  8022c1:	6a 00                	push   $0x0
  8022c3:	6a 00                	push   $0x0
  8022c5:	6a 09                	push   $0x9
  8022c7:	e8 00 ff ff ff       	call   8021cc <syscall>
  8022cc:	83 c4 18             	add    $0x18,%esp
}
  8022cf:	c9                   	leave  
  8022d0:	c3                   	ret    

008022d1 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8022d1:	55                   	push   %ebp
  8022d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8022d4:	6a 00                	push   $0x0
  8022d6:	6a 00                	push   $0x0
  8022d8:	6a 00                	push   $0x0
  8022da:	6a 00                	push   $0x0
  8022dc:	6a 00                	push   $0x0
  8022de:	6a 0a                	push   $0xa
  8022e0:	e8 e7 fe ff ff       	call   8021cc <syscall>
  8022e5:	83 c4 18             	add    $0x18,%esp
}
  8022e8:	c9                   	leave  
  8022e9:	c3                   	ret    

008022ea <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8022ea:	55                   	push   %ebp
  8022eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8022ed:	6a 00                	push   $0x0
  8022ef:	6a 00                	push   $0x0
  8022f1:	6a 00                	push   $0x0
  8022f3:	6a 00                	push   $0x0
  8022f5:	6a 00                	push   $0x0
  8022f7:	6a 0b                	push   $0xb
  8022f9:	e8 ce fe ff ff       	call   8021cc <syscall>
  8022fe:	83 c4 18             	add    $0x18,%esp
}
  802301:	c9                   	leave  
  802302:	c3                   	ret    

00802303 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802303:	55                   	push   %ebp
  802304:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802306:	6a 00                	push   $0x0
  802308:	6a 00                	push   $0x0
  80230a:	6a 00                	push   $0x0
  80230c:	ff 75 0c             	pushl  0xc(%ebp)
  80230f:	ff 75 08             	pushl  0x8(%ebp)
  802312:	6a 0f                	push   $0xf
  802314:	e8 b3 fe ff ff       	call   8021cc <syscall>
  802319:	83 c4 18             	add    $0x18,%esp
	return;
  80231c:	90                   	nop
}
  80231d:	c9                   	leave  
  80231e:	c3                   	ret    

0080231f <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80231f:	55                   	push   %ebp
  802320:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802322:	6a 00                	push   $0x0
  802324:	6a 00                	push   $0x0
  802326:	6a 00                	push   $0x0
  802328:	ff 75 0c             	pushl  0xc(%ebp)
  80232b:	ff 75 08             	pushl  0x8(%ebp)
  80232e:	6a 10                	push   $0x10
  802330:	e8 97 fe ff ff       	call   8021cc <syscall>
  802335:	83 c4 18             	add    $0x18,%esp
	return ;
  802338:	90                   	nop
}
  802339:	c9                   	leave  
  80233a:	c3                   	ret    

0080233b <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80233b:	55                   	push   %ebp
  80233c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80233e:	6a 00                	push   $0x0
  802340:	6a 00                	push   $0x0
  802342:	ff 75 10             	pushl  0x10(%ebp)
  802345:	ff 75 0c             	pushl  0xc(%ebp)
  802348:	ff 75 08             	pushl  0x8(%ebp)
  80234b:	6a 11                	push   $0x11
  80234d:	e8 7a fe ff ff       	call   8021cc <syscall>
  802352:	83 c4 18             	add    $0x18,%esp
	return ;
  802355:	90                   	nop
}
  802356:	c9                   	leave  
  802357:	c3                   	ret    

00802358 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802358:	55                   	push   %ebp
  802359:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80235b:	6a 00                	push   $0x0
  80235d:	6a 00                	push   $0x0
  80235f:	6a 00                	push   $0x0
  802361:	6a 00                	push   $0x0
  802363:	6a 00                	push   $0x0
  802365:	6a 0c                	push   $0xc
  802367:	e8 60 fe ff ff       	call   8021cc <syscall>
  80236c:	83 c4 18             	add    $0x18,%esp
}
  80236f:	c9                   	leave  
  802370:	c3                   	ret    

00802371 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802371:	55                   	push   %ebp
  802372:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802374:	6a 00                	push   $0x0
  802376:	6a 00                	push   $0x0
  802378:	6a 00                	push   $0x0
  80237a:	6a 00                	push   $0x0
  80237c:	ff 75 08             	pushl  0x8(%ebp)
  80237f:	6a 0d                	push   $0xd
  802381:	e8 46 fe ff ff       	call   8021cc <syscall>
  802386:	83 c4 18             	add    $0x18,%esp
}
  802389:	c9                   	leave  
  80238a:	c3                   	ret    

0080238b <sys_scarce_memory>:

void sys_scarce_memory()
{
  80238b:	55                   	push   %ebp
  80238c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80238e:	6a 00                	push   $0x0
  802390:	6a 00                	push   $0x0
  802392:	6a 00                	push   $0x0
  802394:	6a 00                	push   $0x0
  802396:	6a 00                	push   $0x0
  802398:	6a 0e                	push   $0xe
  80239a:	e8 2d fe ff ff       	call   8021cc <syscall>
  80239f:	83 c4 18             	add    $0x18,%esp
}
  8023a2:	90                   	nop
  8023a3:	c9                   	leave  
  8023a4:	c3                   	ret    

008023a5 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8023a5:	55                   	push   %ebp
  8023a6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8023a8:	6a 00                	push   $0x0
  8023aa:	6a 00                	push   $0x0
  8023ac:	6a 00                	push   $0x0
  8023ae:	6a 00                	push   $0x0
  8023b0:	6a 00                	push   $0x0
  8023b2:	6a 13                	push   $0x13
  8023b4:	e8 13 fe ff ff       	call   8021cc <syscall>
  8023b9:	83 c4 18             	add    $0x18,%esp
}
  8023bc:	90                   	nop
  8023bd:	c9                   	leave  
  8023be:	c3                   	ret    

008023bf <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8023bf:	55                   	push   %ebp
  8023c0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8023c2:	6a 00                	push   $0x0
  8023c4:	6a 00                	push   $0x0
  8023c6:	6a 00                	push   $0x0
  8023c8:	6a 00                	push   $0x0
  8023ca:	6a 00                	push   $0x0
  8023cc:	6a 14                	push   $0x14
  8023ce:	e8 f9 fd ff ff       	call   8021cc <syscall>
  8023d3:	83 c4 18             	add    $0x18,%esp
}
  8023d6:	90                   	nop
  8023d7:	c9                   	leave  
  8023d8:	c3                   	ret    

008023d9 <sys_cputc>:


void
sys_cputc(const char c)
{
  8023d9:	55                   	push   %ebp
  8023da:	89 e5                	mov    %esp,%ebp
  8023dc:	83 ec 04             	sub    $0x4,%esp
  8023df:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8023e5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8023e9:	6a 00                	push   $0x0
  8023eb:	6a 00                	push   $0x0
  8023ed:	6a 00                	push   $0x0
  8023ef:	6a 00                	push   $0x0
  8023f1:	50                   	push   %eax
  8023f2:	6a 15                	push   $0x15
  8023f4:	e8 d3 fd ff ff       	call   8021cc <syscall>
  8023f9:	83 c4 18             	add    $0x18,%esp
}
  8023fc:	90                   	nop
  8023fd:	c9                   	leave  
  8023fe:	c3                   	ret    

008023ff <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8023ff:	55                   	push   %ebp
  802400:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802402:	6a 00                	push   $0x0
  802404:	6a 00                	push   $0x0
  802406:	6a 00                	push   $0x0
  802408:	6a 00                	push   $0x0
  80240a:	6a 00                	push   $0x0
  80240c:	6a 16                	push   $0x16
  80240e:	e8 b9 fd ff ff       	call   8021cc <syscall>
  802413:	83 c4 18             	add    $0x18,%esp
}
  802416:	90                   	nop
  802417:	c9                   	leave  
  802418:	c3                   	ret    

00802419 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802419:	55                   	push   %ebp
  80241a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80241c:	8b 45 08             	mov    0x8(%ebp),%eax
  80241f:	6a 00                	push   $0x0
  802421:	6a 00                	push   $0x0
  802423:	6a 00                	push   $0x0
  802425:	ff 75 0c             	pushl  0xc(%ebp)
  802428:	50                   	push   %eax
  802429:	6a 17                	push   $0x17
  80242b:	e8 9c fd ff ff       	call   8021cc <syscall>
  802430:	83 c4 18             	add    $0x18,%esp
}
  802433:	c9                   	leave  
  802434:	c3                   	ret    

00802435 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802435:	55                   	push   %ebp
  802436:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802438:	8b 55 0c             	mov    0xc(%ebp),%edx
  80243b:	8b 45 08             	mov    0x8(%ebp),%eax
  80243e:	6a 00                	push   $0x0
  802440:	6a 00                	push   $0x0
  802442:	6a 00                	push   $0x0
  802444:	52                   	push   %edx
  802445:	50                   	push   %eax
  802446:	6a 1a                	push   $0x1a
  802448:	e8 7f fd ff ff       	call   8021cc <syscall>
  80244d:	83 c4 18             	add    $0x18,%esp
}
  802450:	c9                   	leave  
  802451:	c3                   	ret    

00802452 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802452:	55                   	push   %ebp
  802453:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802455:	8b 55 0c             	mov    0xc(%ebp),%edx
  802458:	8b 45 08             	mov    0x8(%ebp),%eax
  80245b:	6a 00                	push   $0x0
  80245d:	6a 00                	push   $0x0
  80245f:	6a 00                	push   $0x0
  802461:	52                   	push   %edx
  802462:	50                   	push   %eax
  802463:	6a 18                	push   $0x18
  802465:	e8 62 fd ff ff       	call   8021cc <syscall>
  80246a:	83 c4 18             	add    $0x18,%esp
}
  80246d:	90                   	nop
  80246e:	c9                   	leave  
  80246f:	c3                   	ret    

00802470 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802470:	55                   	push   %ebp
  802471:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802473:	8b 55 0c             	mov    0xc(%ebp),%edx
  802476:	8b 45 08             	mov    0x8(%ebp),%eax
  802479:	6a 00                	push   $0x0
  80247b:	6a 00                	push   $0x0
  80247d:	6a 00                	push   $0x0
  80247f:	52                   	push   %edx
  802480:	50                   	push   %eax
  802481:	6a 19                	push   $0x19
  802483:	e8 44 fd ff ff       	call   8021cc <syscall>
  802488:	83 c4 18             	add    $0x18,%esp
}
  80248b:	90                   	nop
  80248c:	c9                   	leave  
  80248d:	c3                   	ret    

0080248e <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80248e:	55                   	push   %ebp
  80248f:	89 e5                	mov    %esp,%ebp
  802491:	83 ec 04             	sub    $0x4,%esp
  802494:	8b 45 10             	mov    0x10(%ebp),%eax
  802497:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80249a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80249d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8024a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a4:	6a 00                	push   $0x0
  8024a6:	51                   	push   %ecx
  8024a7:	52                   	push   %edx
  8024a8:	ff 75 0c             	pushl  0xc(%ebp)
  8024ab:	50                   	push   %eax
  8024ac:	6a 1b                	push   $0x1b
  8024ae:	e8 19 fd ff ff       	call   8021cc <syscall>
  8024b3:	83 c4 18             	add    $0x18,%esp
}
  8024b6:	c9                   	leave  
  8024b7:	c3                   	ret    

008024b8 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8024b8:	55                   	push   %ebp
  8024b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8024bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024be:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c1:	6a 00                	push   $0x0
  8024c3:	6a 00                	push   $0x0
  8024c5:	6a 00                	push   $0x0
  8024c7:	52                   	push   %edx
  8024c8:	50                   	push   %eax
  8024c9:	6a 1c                	push   $0x1c
  8024cb:	e8 fc fc ff ff       	call   8021cc <syscall>
  8024d0:	83 c4 18             	add    $0x18,%esp
}
  8024d3:	c9                   	leave  
  8024d4:	c3                   	ret    

008024d5 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8024d5:	55                   	push   %ebp
  8024d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8024d8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8024db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024de:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e1:	6a 00                	push   $0x0
  8024e3:	6a 00                	push   $0x0
  8024e5:	51                   	push   %ecx
  8024e6:	52                   	push   %edx
  8024e7:	50                   	push   %eax
  8024e8:	6a 1d                	push   $0x1d
  8024ea:	e8 dd fc ff ff       	call   8021cc <syscall>
  8024ef:	83 c4 18             	add    $0x18,%esp
}
  8024f2:	c9                   	leave  
  8024f3:	c3                   	ret    

008024f4 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8024f4:	55                   	push   %ebp
  8024f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8024f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8024fd:	6a 00                	push   $0x0
  8024ff:	6a 00                	push   $0x0
  802501:	6a 00                	push   $0x0
  802503:	52                   	push   %edx
  802504:	50                   	push   %eax
  802505:	6a 1e                	push   $0x1e
  802507:	e8 c0 fc ff ff       	call   8021cc <syscall>
  80250c:	83 c4 18             	add    $0x18,%esp
}
  80250f:	c9                   	leave  
  802510:	c3                   	ret    

00802511 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802511:	55                   	push   %ebp
  802512:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802514:	6a 00                	push   $0x0
  802516:	6a 00                	push   $0x0
  802518:	6a 00                	push   $0x0
  80251a:	6a 00                	push   $0x0
  80251c:	6a 00                	push   $0x0
  80251e:	6a 1f                	push   $0x1f
  802520:	e8 a7 fc ff ff       	call   8021cc <syscall>
  802525:	83 c4 18             	add    $0x18,%esp
}
  802528:	c9                   	leave  
  802529:	c3                   	ret    

0080252a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80252a:	55                   	push   %ebp
  80252b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80252d:	8b 45 08             	mov    0x8(%ebp),%eax
  802530:	6a 00                	push   $0x0
  802532:	ff 75 14             	pushl  0x14(%ebp)
  802535:	ff 75 10             	pushl  0x10(%ebp)
  802538:	ff 75 0c             	pushl  0xc(%ebp)
  80253b:	50                   	push   %eax
  80253c:	6a 20                	push   $0x20
  80253e:	e8 89 fc ff ff       	call   8021cc <syscall>
  802543:	83 c4 18             	add    $0x18,%esp
}
  802546:	c9                   	leave  
  802547:	c3                   	ret    

00802548 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802548:	55                   	push   %ebp
  802549:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80254b:	8b 45 08             	mov    0x8(%ebp),%eax
  80254e:	6a 00                	push   $0x0
  802550:	6a 00                	push   $0x0
  802552:	6a 00                	push   $0x0
  802554:	6a 00                	push   $0x0
  802556:	50                   	push   %eax
  802557:	6a 21                	push   $0x21
  802559:	e8 6e fc ff ff       	call   8021cc <syscall>
  80255e:	83 c4 18             	add    $0x18,%esp
}
  802561:	90                   	nop
  802562:	c9                   	leave  
  802563:	c3                   	ret    

00802564 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802564:	55                   	push   %ebp
  802565:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802567:	8b 45 08             	mov    0x8(%ebp),%eax
  80256a:	6a 00                	push   $0x0
  80256c:	6a 00                	push   $0x0
  80256e:	6a 00                	push   $0x0
  802570:	6a 00                	push   $0x0
  802572:	50                   	push   %eax
  802573:	6a 22                	push   $0x22
  802575:	e8 52 fc ff ff       	call   8021cc <syscall>
  80257a:	83 c4 18             	add    $0x18,%esp
}
  80257d:	c9                   	leave  
  80257e:	c3                   	ret    

0080257f <sys_getenvid>:

int32 sys_getenvid(void)
{
  80257f:	55                   	push   %ebp
  802580:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802582:	6a 00                	push   $0x0
  802584:	6a 00                	push   $0x0
  802586:	6a 00                	push   $0x0
  802588:	6a 00                	push   $0x0
  80258a:	6a 00                	push   $0x0
  80258c:	6a 02                	push   $0x2
  80258e:	e8 39 fc ff ff       	call   8021cc <syscall>
  802593:	83 c4 18             	add    $0x18,%esp
}
  802596:	c9                   	leave  
  802597:	c3                   	ret    

00802598 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802598:	55                   	push   %ebp
  802599:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80259b:	6a 00                	push   $0x0
  80259d:	6a 00                	push   $0x0
  80259f:	6a 00                	push   $0x0
  8025a1:	6a 00                	push   $0x0
  8025a3:	6a 00                	push   $0x0
  8025a5:	6a 03                	push   $0x3
  8025a7:	e8 20 fc ff ff       	call   8021cc <syscall>
  8025ac:	83 c4 18             	add    $0x18,%esp
}
  8025af:	c9                   	leave  
  8025b0:	c3                   	ret    

008025b1 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8025b1:	55                   	push   %ebp
  8025b2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8025b4:	6a 00                	push   $0x0
  8025b6:	6a 00                	push   $0x0
  8025b8:	6a 00                	push   $0x0
  8025ba:	6a 00                	push   $0x0
  8025bc:	6a 00                	push   $0x0
  8025be:	6a 04                	push   $0x4
  8025c0:	e8 07 fc ff ff       	call   8021cc <syscall>
  8025c5:	83 c4 18             	add    $0x18,%esp
}
  8025c8:	c9                   	leave  
  8025c9:	c3                   	ret    

008025ca <sys_exit_env>:


void sys_exit_env(void)
{
  8025ca:	55                   	push   %ebp
  8025cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8025cd:	6a 00                	push   $0x0
  8025cf:	6a 00                	push   $0x0
  8025d1:	6a 00                	push   $0x0
  8025d3:	6a 00                	push   $0x0
  8025d5:	6a 00                	push   $0x0
  8025d7:	6a 23                	push   $0x23
  8025d9:	e8 ee fb ff ff       	call   8021cc <syscall>
  8025de:	83 c4 18             	add    $0x18,%esp
}
  8025e1:	90                   	nop
  8025e2:	c9                   	leave  
  8025e3:	c3                   	ret    

008025e4 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8025e4:	55                   	push   %ebp
  8025e5:	89 e5                	mov    %esp,%ebp
  8025e7:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8025ea:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8025ed:	8d 50 04             	lea    0x4(%eax),%edx
  8025f0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8025f3:	6a 00                	push   $0x0
  8025f5:	6a 00                	push   $0x0
  8025f7:	6a 00                	push   $0x0
  8025f9:	52                   	push   %edx
  8025fa:	50                   	push   %eax
  8025fb:	6a 24                	push   $0x24
  8025fd:	e8 ca fb ff ff       	call   8021cc <syscall>
  802602:	83 c4 18             	add    $0x18,%esp
	return result;
  802605:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802608:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80260b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80260e:	89 01                	mov    %eax,(%ecx)
  802610:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802613:	8b 45 08             	mov    0x8(%ebp),%eax
  802616:	c9                   	leave  
  802617:	c2 04 00             	ret    $0x4

0080261a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80261a:	55                   	push   %ebp
  80261b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80261d:	6a 00                	push   $0x0
  80261f:	6a 00                	push   $0x0
  802621:	ff 75 10             	pushl  0x10(%ebp)
  802624:	ff 75 0c             	pushl  0xc(%ebp)
  802627:	ff 75 08             	pushl  0x8(%ebp)
  80262a:	6a 12                	push   $0x12
  80262c:	e8 9b fb ff ff       	call   8021cc <syscall>
  802631:	83 c4 18             	add    $0x18,%esp
	return ;
  802634:	90                   	nop
}
  802635:	c9                   	leave  
  802636:	c3                   	ret    

00802637 <sys_rcr2>:
uint32 sys_rcr2()
{
  802637:	55                   	push   %ebp
  802638:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80263a:	6a 00                	push   $0x0
  80263c:	6a 00                	push   $0x0
  80263e:	6a 00                	push   $0x0
  802640:	6a 00                	push   $0x0
  802642:	6a 00                	push   $0x0
  802644:	6a 25                	push   $0x25
  802646:	e8 81 fb ff ff       	call   8021cc <syscall>
  80264b:	83 c4 18             	add    $0x18,%esp
}
  80264e:	c9                   	leave  
  80264f:	c3                   	ret    

00802650 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802650:	55                   	push   %ebp
  802651:	89 e5                	mov    %esp,%ebp
  802653:	83 ec 04             	sub    $0x4,%esp
  802656:	8b 45 08             	mov    0x8(%ebp),%eax
  802659:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80265c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802660:	6a 00                	push   $0x0
  802662:	6a 00                	push   $0x0
  802664:	6a 00                	push   $0x0
  802666:	6a 00                	push   $0x0
  802668:	50                   	push   %eax
  802669:	6a 26                	push   $0x26
  80266b:	e8 5c fb ff ff       	call   8021cc <syscall>
  802670:	83 c4 18             	add    $0x18,%esp
	return ;
  802673:	90                   	nop
}
  802674:	c9                   	leave  
  802675:	c3                   	ret    

00802676 <rsttst>:
void rsttst()
{
  802676:	55                   	push   %ebp
  802677:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802679:	6a 00                	push   $0x0
  80267b:	6a 00                	push   $0x0
  80267d:	6a 00                	push   $0x0
  80267f:	6a 00                	push   $0x0
  802681:	6a 00                	push   $0x0
  802683:	6a 28                	push   $0x28
  802685:	e8 42 fb ff ff       	call   8021cc <syscall>
  80268a:	83 c4 18             	add    $0x18,%esp
	return ;
  80268d:	90                   	nop
}
  80268e:	c9                   	leave  
  80268f:	c3                   	ret    

00802690 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802690:	55                   	push   %ebp
  802691:	89 e5                	mov    %esp,%ebp
  802693:	83 ec 04             	sub    $0x4,%esp
  802696:	8b 45 14             	mov    0x14(%ebp),%eax
  802699:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80269c:	8b 55 18             	mov    0x18(%ebp),%edx
  80269f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8026a3:	52                   	push   %edx
  8026a4:	50                   	push   %eax
  8026a5:	ff 75 10             	pushl  0x10(%ebp)
  8026a8:	ff 75 0c             	pushl  0xc(%ebp)
  8026ab:	ff 75 08             	pushl  0x8(%ebp)
  8026ae:	6a 27                	push   $0x27
  8026b0:	e8 17 fb ff ff       	call   8021cc <syscall>
  8026b5:	83 c4 18             	add    $0x18,%esp
	return ;
  8026b8:	90                   	nop
}
  8026b9:	c9                   	leave  
  8026ba:	c3                   	ret    

008026bb <chktst>:
void chktst(uint32 n)
{
  8026bb:	55                   	push   %ebp
  8026bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8026be:	6a 00                	push   $0x0
  8026c0:	6a 00                	push   $0x0
  8026c2:	6a 00                	push   $0x0
  8026c4:	6a 00                	push   $0x0
  8026c6:	ff 75 08             	pushl  0x8(%ebp)
  8026c9:	6a 29                	push   $0x29
  8026cb:	e8 fc fa ff ff       	call   8021cc <syscall>
  8026d0:	83 c4 18             	add    $0x18,%esp
	return ;
  8026d3:	90                   	nop
}
  8026d4:	c9                   	leave  
  8026d5:	c3                   	ret    

008026d6 <inctst>:

void inctst()
{
  8026d6:	55                   	push   %ebp
  8026d7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8026d9:	6a 00                	push   $0x0
  8026db:	6a 00                	push   $0x0
  8026dd:	6a 00                	push   $0x0
  8026df:	6a 00                	push   $0x0
  8026e1:	6a 00                	push   $0x0
  8026e3:	6a 2a                	push   $0x2a
  8026e5:	e8 e2 fa ff ff       	call   8021cc <syscall>
  8026ea:	83 c4 18             	add    $0x18,%esp
	return ;
  8026ed:	90                   	nop
}
  8026ee:	c9                   	leave  
  8026ef:	c3                   	ret    

008026f0 <gettst>:
uint32 gettst()
{
  8026f0:	55                   	push   %ebp
  8026f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8026f3:	6a 00                	push   $0x0
  8026f5:	6a 00                	push   $0x0
  8026f7:	6a 00                	push   $0x0
  8026f9:	6a 00                	push   $0x0
  8026fb:	6a 00                	push   $0x0
  8026fd:	6a 2b                	push   $0x2b
  8026ff:	e8 c8 fa ff ff       	call   8021cc <syscall>
  802704:	83 c4 18             	add    $0x18,%esp
}
  802707:	c9                   	leave  
  802708:	c3                   	ret    

00802709 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802709:	55                   	push   %ebp
  80270a:	89 e5                	mov    %esp,%ebp
  80270c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80270f:	6a 00                	push   $0x0
  802711:	6a 00                	push   $0x0
  802713:	6a 00                	push   $0x0
  802715:	6a 00                	push   $0x0
  802717:	6a 00                	push   $0x0
  802719:	6a 2c                	push   $0x2c
  80271b:	e8 ac fa ff ff       	call   8021cc <syscall>
  802720:	83 c4 18             	add    $0x18,%esp
  802723:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802726:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80272a:	75 07                	jne    802733 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80272c:	b8 01 00 00 00       	mov    $0x1,%eax
  802731:	eb 05                	jmp    802738 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802733:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802738:	c9                   	leave  
  802739:	c3                   	ret    

0080273a <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80273a:	55                   	push   %ebp
  80273b:	89 e5                	mov    %esp,%ebp
  80273d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802740:	6a 00                	push   $0x0
  802742:	6a 00                	push   $0x0
  802744:	6a 00                	push   $0x0
  802746:	6a 00                	push   $0x0
  802748:	6a 00                	push   $0x0
  80274a:	6a 2c                	push   $0x2c
  80274c:	e8 7b fa ff ff       	call   8021cc <syscall>
  802751:	83 c4 18             	add    $0x18,%esp
  802754:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802757:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80275b:	75 07                	jne    802764 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80275d:	b8 01 00 00 00       	mov    $0x1,%eax
  802762:	eb 05                	jmp    802769 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802764:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802769:	c9                   	leave  
  80276a:	c3                   	ret    

0080276b <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80276b:	55                   	push   %ebp
  80276c:	89 e5                	mov    %esp,%ebp
  80276e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802771:	6a 00                	push   $0x0
  802773:	6a 00                	push   $0x0
  802775:	6a 00                	push   $0x0
  802777:	6a 00                	push   $0x0
  802779:	6a 00                	push   $0x0
  80277b:	6a 2c                	push   $0x2c
  80277d:	e8 4a fa ff ff       	call   8021cc <syscall>
  802782:	83 c4 18             	add    $0x18,%esp
  802785:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802788:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80278c:	75 07                	jne    802795 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80278e:	b8 01 00 00 00       	mov    $0x1,%eax
  802793:	eb 05                	jmp    80279a <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802795:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80279a:	c9                   	leave  
  80279b:	c3                   	ret    

0080279c <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80279c:	55                   	push   %ebp
  80279d:	89 e5                	mov    %esp,%ebp
  80279f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8027a2:	6a 00                	push   $0x0
  8027a4:	6a 00                	push   $0x0
  8027a6:	6a 00                	push   $0x0
  8027a8:	6a 00                	push   $0x0
  8027aa:	6a 00                	push   $0x0
  8027ac:	6a 2c                	push   $0x2c
  8027ae:	e8 19 fa ff ff       	call   8021cc <syscall>
  8027b3:	83 c4 18             	add    $0x18,%esp
  8027b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8027b9:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8027bd:	75 07                	jne    8027c6 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8027bf:	b8 01 00 00 00       	mov    $0x1,%eax
  8027c4:	eb 05                	jmp    8027cb <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8027c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027cb:	c9                   	leave  
  8027cc:	c3                   	ret    

008027cd <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8027cd:	55                   	push   %ebp
  8027ce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8027d0:	6a 00                	push   $0x0
  8027d2:	6a 00                	push   $0x0
  8027d4:	6a 00                	push   $0x0
  8027d6:	6a 00                	push   $0x0
  8027d8:	ff 75 08             	pushl  0x8(%ebp)
  8027db:	6a 2d                	push   $0x2d
  8027dd:	e8 ea f9 ff ff       	call   8021cc <syscall>
  8027e2:	83 c4 18             	add    $0x18,%esp
	return ;
  8027e5:	90                   	nop
}
  8027e6:	c9                   	leave  
  8027e7:	c3                   	ret    

008027e8 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8027e8:	55                   	push   %ebp
  8027e9:	89 e5                	mov    %esp,%ebp
  8027eb:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8027ec:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8027ef:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8027f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f8:	6a 00                	push   $0x0
  8027fa:	53                   	push   %ebx
  8027fb:	51                   	push   %ecx
  8027fc:	52                   	push   %edx
  8027fd:	50                   	push   %eax
  8027fe:	6a 2e                	push   $0x2e
  802800:	e8 c7 f9 ff ff       	call   8021cc <syscall>
  802805:	83 c4 18             	add    $0x18,%esp
}
  802808:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80280b:	c9                   	leave  
  80280c:	c3                   	ret    

0080280d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80280d:	55                   	push   %ebp
  80280e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802810:	8b 55 0c             	mov    0xc(%ebp),%edx
  802813:	8b 45 08             	mov    0x8(%ebp),%eax
  802816:	6a 00                	push   $0x0
  802818:	6a 00                	push   $0x0
  80281a:	6a 00                	push   $0x0
  80281c:	52                   	push   %edx
  80281d:	50                   	push   %eax
  80281e:	6a 2f                	push   $0x2f
  802820:	e8 a7 f9 ff ff       	call   8021cc <syscall>
  802825:	83 c4 18             	add    $0x18,%esp
}
  802828:	c9                   	leave  
  802829:	c3                   	ret    

0080282a <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80282a:	55                   	push   %ebp
  80282b:	89 e5                	mov    %esp,%ebp
  80282d:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802830:	83 ec 0c             	sub    $0xc,%esp
  802833:	68 5c 43 80 00       	push   $0x80435c
  802838:	e8 21 e7 ff ff       	call   800f5e <cprintf>
  80283d:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802840:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802847:	83 ec 0c             	sub    $0xc,%esp
  80284a:	68 88 43 80 00       	push   $0x804388
  80284f:	e8 0a e7 ff ff       	call   800f5e <cprintf>
  802854:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802857:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80285b:	a1 38 51 80 00       	mov    0x805138,%eax
  802860:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802863:	eb 56                	jmp    8028bb <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802865:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802869:	74 1c                	je     802887 <print_mem_block_lists+0x5d>
  80286b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286e:	8b 50 08             	mov    0x8(%eax),%edx
  802871:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802874:	8b 48 08             	mov    0x8(%eax),%ecx
  802877:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80287a:	8b 40 0c             	mov    0xc(%eax),%eax
  80287d:	01 c8                	add    %ecx,%eax
  80287f:	39 c2                	cmp    %eax,%edx
  802881:	73 04                	jae    802887 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802883:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802887:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288a:	8b 50 08             	mov    0x8(%eax),%edx
  80288d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802890:	8b 40 0c             	mov    0xc(%eax),%eax
  802893:	01 c2                	add    %eax,%edx
  802895:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802898:	8b 40 08             	mov    0x8(%eax),%eax
  80289b:	83 ec 04             	sub    $0x4,%esp
  80289e:	52                   	push   %edx
  80289f:	50                   	push   %eax
  8028a0:	68 9d 43 80 00       	push   $0x80439d
  8028a5:	e8 b4 e6 ff ff       	call   800f5e <cprintf>
  8028aa:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8028ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8028b3:	a1 40 51 80 00       	mov    0x805140,%eax
  8028b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028bf:	74 07                	je     8028c8 <print_mem_block_lists+0x9e>
  8028c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c4:	8b 00                	mov    (%eax),%eax
  8028c6:	eb 05                	jmp    8028cd <print_mem_block_lists+0xa3>
  8028c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8028cd:	a3 40 51 80 00       	mov    %eax,0x805140
  8028d2:	a1 40 51 80 00       	mov    0x805140,%eax
  8028d7:	85 c0                	test   %eax,%eax
  8028d9:	75 8a                	jne    802865 <print_mem_block_lists+0x3b>
  8028db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028df:	75 84                	jne    802865 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8028e1:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8028e5:	75 10                	jne    8028f7 <print_mem_block_lists+0xcd>
  8028e7:	83 ec 0c             	sub    $0xc,%esp
  8028ea:	68 ac 43 80 00       	push   $0x8043ac
  8028ef:	e8 6a e6 ff ff       	call   800f5e <cprintf>
  8028f4:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8028f7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8028fe:	83 ec 0c             	sub    $0xc,%esp
  802901:	68 d0 43 80 00       	push   $0x8043d0
  802906:	e8 53 e6 ff ff       	call   800f5e <cprintf>
  80290b:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80290e:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802912:	a1 40 50 80 00       	mov    0x805040,%eax
  802917:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80291a:	eb 56                	jmp    802972 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80291c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802920:	74 1c                	je     80293e <print_mem_block_lists+0x114>
  802922:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802925:	8b 50 08             	mov    0x8(%eax),%edx
  802928:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80292b:	8b 48 08             	mov    0x8(%eax),%ecx
  80292e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802931:	8b 40 0c             	mov    0xc(%eax),%eax
  802934:	01 c8                	add    %ecx,%eax
  802936:	39 c2                	cmp    %eax,%edx
  802938:	73 04                	jae    80293e <print_mem_block_lists+0x114>
			sorted = 0 ;
  80293a:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80293e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802941:	8b 50 08             	mov    0x8(%eax),%edx
  802944:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802947:	8b 40 0c             	mov    0xc(%eax),%eax
  80294a:	01 c2                	add    %eax,%edx
  80294c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294f:	8b 40 08             	mov    0x8(%eax),%eax
  802952:	83 ec 04             	sub    $0x4,%esp
  802955:	52                   	push   %edx
  802956:	50                   	push   %eax
  802957:	68 9d 43 80 00       	push   $0x80439d
  80295c:	e8 fd e5 ff ff       	call   800f5e <cprintf>
  802961:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802964:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802967:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80296a:	a1 48 50 80 00       	mov    0x805048,%eax
  80296f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802972:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802976:	74 07                	je     80297f <print_mem_block_lists+0x155>
  802978:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297b:	8b 00                	mov    (%eax),%eax
  80297d:	eb 05                	jmp    802984 <print_mem_block_lists+0x15a>
  80297f:	b8 00 00 00 00       	mov    $0x0,%eax
  802984:	a3 48 50 80 00       	mov    %eax,0x805048
  802989:	a1 48 50 80 00       	mov    0x805048,%eax
  80298e:	85 c0                	test   %eax,%eax
  802990:	75 8a                	jne    80291c <print_mem_block_lists+0xf2>
  802992:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802996:	75 84                	jne    80291c <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802998:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80299c:	75 10                	jne    8029ae <print_mem_block_lists+0x184>
  80299e:	83 ec 0c             	sub    $0xc,%esp
  8029a1:	68 e8 43 80 00       	push   $0x8043e8
  8029a6:	e8 b3 e5 ff ff       	call   800f5e <cprintf>
  8029ab:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8029ae:	83 ec 0c             	sub    $0xc,%esp
  8029b1:	68 5c 43 80 00       	push   $0x80435c
  8029b6:	e8 a3 e5 ff ff       	call   800f5e <cprintf>
  8029bb:	83 c4 10             	add    $0x10,%esp

}
  8029be:	90                   	nop
  8029bf:	c9                   	leave  
  8029c0:	c3                   	ret    

008029c1 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8029c1:	55                   	push   %ebp
  8029c2:	89 e5                	mov    %esp,%ebp
  8029c4:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  8029c7:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8029ce:	00 00 00 
  8029d1:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8029d8:	00 00 00 
  8029db:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8029e2:	00 00 00 
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  8029e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8029ec:	e9 9e 00 00 00       	jmp    802a8f <initialize_MemBlocksList+0xce>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
  8029f1:	a1 50 50 80 00       	mov    0x805050,%eax
  8029f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029f9:	c1 e2 04             	shl    $0x4,%edx
  8029fc:	01 d0                	add    %edx,%eax
  8029fe:	85 c0                	test   %eax,%eax
  802a00:	75 14                	jne    802a16 <initialize_MemBlocksList+0x55>
  802a02:	83 ec 04             	sub    $0x4,%esp
  802a05:	68 10 44 80 00       	push   $0x804410
  802a0a:	6a 43                	push   $0x43
  802a0c:	68 33 44 80 00       	push   $0x804433
  802a11:	e8 94 e2 ff ff       	call   800caa <_panic>
  802a16:	a1 50 50 80 00       	mov    0x805050,%eax
  802a1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a1e:	c1 e2 04             	shl    $0x4,%edx
  802a21:	01 d0                	add    %edx,%eax
  802a23:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802a29:	89 10                	mov    %edx,(%eax)
  802a2b:	8b 00                	mov    (%eax),%eax
  802a2d:	85 c0                	test   %eax,%eax
  802a2f:	74 18                	je     802a49 <initialize_MemBlocksList+0x88>
  802a31:	a1 48 51 80 00       	mov    0x805148,%eax
  802a36:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802a3c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802a3f:	c1 e1 04             	shl    $0x4,%ecx
  802a42:	01 ca                	add    %ecx,%edx
  802a44:	89 50 04             	mov    %edx,0x4(%eax)
  802a47:	eb 12                	jmp    802a5b <initialize_MemBlocksList+0x9a>
  802a49:	a1 50 50 80 00       	mov    0x805050,%eax
  802a4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a51:	c1 e2 04             	shl    $0x4,%edx
  802a54:	01 d0                	add    %edx,%eax
  802a56:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a5b:	a1 50 50 80 00       	mov    0x805050,%eax
  802a60:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a63:	c1 e2 04             	shl    $0x4,%edx
  802a66:	01 d0                	add    %edx,%eax
  802a68:	a3 48 51 80 00       	mov    %eax,0x805148
  802a6d:	a1 50 50 80 00       	mov    0x805050,%eax
  802a72:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a75:	c1 e2 04             	shl    $0x4,%edx
  802a78:	01 d0                	add    %edx,%eax
  802a7a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a81:	a1 54 51 80 00       	mov    0x805154,%eax
  802a86:	40                   	inc    %eax
  802a87:	a3 54 51 80 00       	mov    %eax,0x805154
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  802a8c:	ff 45 f4             	incl   -0xc(%ebp)
  802a8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a92:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a95:	0f 82 56 ff ff ff    	jb     8029f1 <initialize_MemBlocksList+0x30>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
		}
}
  802a9b:	90                   	nop
  802a9c:	c9                   	leave  
  802a9d:	c3                   	ret    

00802a9e <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802a9e:	55                   	push   %ebp
  802a9f:	89 e5                	mov    %esp,%ebp
  802aa1:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  802aa4:	a1 38 51 80 00       	mov    0x805138,%eax
  802aa9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802aac:	eb 18                	jmp    802ac6 <find_block+0x28>
	{
		if (ele->sva==va)
  802aae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802ab1:	8b 40 08             	mov    0x8(%eax),%eax
  802ab4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802ab7:	75 05                	jne    802abe <find_block+0x20>
			return ele;
  802ab9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802abc:	eb 7b                	jmp    802b39 <find_block+0x9b>
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  802abe:	a1 40 51 80 00       	mov    0x805140,%eax
  802ac3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802ac6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802aca:	74 07                	je     802ad3 <find_block+0x35>
  802acc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802acf:	8b 00                	mov    (%eax),%eax
  802ad1:	eb 05                	jmp    802ad8 <find_block+0x3a>
  802ad3:	b8 00 00 00 00       	mov    $0x0,%eax
  802ad8:	a3 40 51 80 00       	mov    %eax,0x805140
  802add:	a1 40 51 80 00       	mov    0x805140,%eax
  802ae2:	85 c0                	test   %eax,%eax
  802ae4:	75 c8                	jne    802aae <find_block+0x10>
  802ae6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802aea:	75 c2                	jne    802aae <find_block+0x10>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  802aec:	a1 40 50 80 00       	mov    0x805040,%eax
  802af1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802af4:	eb 18                	jmp    802b0e <find_block+0x70>
	{
		if (ele->sva==va)
  802af6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802af9:	8b 40 08             	mov    0x8(%eax),%eax
  802afc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802aff:	75 05                	jne    802b06 <find_block+0x68>
					return ele;
  802b01:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802b04:	eb 33                	jmp    802b39 <find_block+0x9b>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  802b06:	a1 48 50 80 00       	mov    0x805048,%eax
  802b0b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802b0e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802b12:	74 07                	je     802b1b <find_block+0x7d>
  802b14:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802b17:	8b 00                	mov    (%eax),%eax
  802b19:	eb 05                	jmp    802b20 <find_block+0x82>
  802b1b:	b8 00 00 00 00       	mov    $0x0,%eax
  802b20:	a3 48 50 80 00       	mov    %eax,0x805048
  802b25:	a1 48 50 80 00       	mov    0x805048,%eax
  802b2a:	85 c0                	test   %eax,%eax
  802b2c:	75 c8                	jne    802af6 <find_block+0x58>
  802b2e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802b32:	75 c2                	jne    802af6 <find_block+0x58>
	{
		if (ele->sva==va)
					return ele;
	}
return NULL;
  802b34:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802b39:	c9                   	leave  
  802b3a:	c3                   	ret    

00802b3b <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802b3b:	55                   	push   %ebp
  802b3c:	89 e5                	mov    %esp,%ebp
  802b3e:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;

int x =LIST_SIZE(&AllocMemBlocksList);
  802b41:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802b46:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((x==0))
  802b49:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b4d:	75 62                	jne    802bb1 <insert_sorted_allocList+0x76>
	{
	//	blockToInsert=AllocMemBlocksList.lh_first;
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  802b4f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b53:	75 14                	jne    802b69 <insert_sorted_allocList+0x2e>
  802b55:	83 ec 04             	sub    $0x4,%esp
  802b58:	68 10 44 80 00       	push   $0x804410
  802b5d:	6a 69                	push   $0x69
  802b5f:	68 33 44 80 00       	push   $0x804433
  802b64:	e8 41 e1 ff ff       	call   800caa <_panic>
  802b69:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b72:	89 10                	mov    %edx,(%eax)
  802b74:	8b 45 08             	mov    0x8(%ebp),%eax
  802b77:	8b 00                	mov    (%eax),%eax
  802b79:	85 c0                	test   %eax,%eax
  802b7b:	74 0d                	je     802b8a <insert_sorted_allocList+0x4f>
  802b7d:	a1 40 50 80 00       	mov    0x805040,%eax
  802b82:	8b 55 08             	mov    0x8(%ebp),%edx
  802b85:	89 50 04             	mov    %edx,0x4(%eax)
  802b88:	eb 08                	jmp    802b92 <insert_sorted_allocList+0x57>
  802b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8d:	a3 44 50 80 00       	mov    %eax,0x805044
  802b92:	8b 45 08             	mov    0x8(%ebp),%eax
  802b95:	a3 40 50 80 00       	mov    %eax,0x805040
  802b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ba4:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802ba9:	40                   	inc    %eax
  802baa:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802baf:	eb 72                	jmp    802c23 <insert_sorted_allocList+0xe8>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
  802bb1:	a1 40 50 80 00       	mov    0x805040,%eax
  802bb6:	8b 50 08             	mov    0x8(%eax),%edx
  802bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbc:	8b 40 08             	mov    0x8(%eax),%eax
  802bbf:	39 c2                	cmp    %eax,%edx
  802bc1:	76 60                	jbe    802c23 <insert_sorted_allocList+0xe8>
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  802bc3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bc7:	75 14                	jne    802bdd <insert_sorted_allocList+0xa2>
  802bc9:	83 ec 04             	sub    $0x4,%esp
  802bcc:	68 10 44 80 00       	push   $0x804410
  802bd1:	6a 6d                	push   $0x6d
  802bd3:	68 33 44 80 00       	push   $0x804433
  802bd8:	e8 cd e0 ff ff       	call   800caa <_panic>
  802bdd:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802be3:	8b 45 08             	mov    0x8(%ebp),%eax
  802be6:	89 10                	mov    %edx,(%eax)
  802be8:	8b 45 08             	mov    0x8(%ebp),%eax
  802beb:	8b 00                	mov    (%eax),%eax
  802bed:	85 c0                	test   %eax,%eax
  802bef:	74 0d                	je     802bfe <insert_sorted_allocList+0xc3>
  802bf1:	a1 40 50 80 00       	mov    0x805040,%eax
  802bf6:	8b 55 08             	mov    0x8(%ebp),%edx
  802bf9:	89 50 04             	mov    %edx,0x4(%eax)
  802bfc:	eb 08                	jmp    802c06 <insert_sorted_allocList+0xcb>
  802bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  802c01:	a3 44 50 80 00       	mov    %eax,0x805044
  802c06:	8b 45 08             	mov    0x8(%ebp),%eax
  802c09:	a3 40 50 80 00       	mov    %eax,0x805040
  802c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c11:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c18:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802c1d:	40                   	inc    %eax
  802c1e:	a3 4c 50 80 00       	mov    %eax,0x80504c
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  802c23:	a1 40 50 80 00       	mov    0x805040,%eax
  802c28:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c2b:	e9 b9 01 00 00       	jmp    802de9 <insert_sorted_allocList+0x2ae>
	{


		if ((blockToInsert->sva>AllocMemBlocksList.lh_first->sva)&&blockToInsert->sva<element->sva)
  802c30:	8b 45 08             	mov    0x8(%ebp),%eax
  802c33:	8b 50 08             	mov    0x8(%eax),%edx
  802c36:	a1 40 50 80 00       	mov    0x805040,%eax
  802c3b:	8b 40 08             	mov    0x8(%eax),%eax
  802c3e:	39 c2                	cmp    %eax,%edx
  802c40:	76 7c                	jbe    802cbe <insert_sorted_allocList+0x183>
  802c42:	8b 45 08             	mov    0x8(%ebp),%eax
  802c45:	8b 50 08             	mov    0x8(%eax),%edx
  802c48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4b:	8b 40 08             	mov    0x8(%eax),%eax
  802c4e:	39 c2                	cmp    %eax,%edx
  802c50:	73 6c                	jae    802cbe <insert_sorted_allocList+0x183>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,element,blockToInsert);
  802c52:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c56:	74 06                	je     802c5e <insert_sorted_allocList+0x123>
  802c58:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c5c:	75 14                	jne    802c72 <insert_sorted_allocList+0x137>
  802c5e:	83 ec 04             	sub    $0x4,%esp
  802c61:	68 4c 44 80 00       	push   $0x80444c
  802c66:	6a 75                	push   $0x75
  802c68:	68 33 44 80 00       	push   $0x804433
  802c6d:	e8 38 e0 ff ff       	call   800caa <_panic>
  802c72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c75:	8b 50 04             	mov    0x4(%eax),%edx
  802c78:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7b:	89 50 04             	mov    %edx,0x4(%eax)
  802c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c81:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c84:	89 10                	mov    %edx,(%eax)
  802c86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c89:	8b 40 04             	mov    0x4(%eax),%eax
  802c8c:	85 c0                	test   %eax,%eax
  802c8e:	74 0d                	je     802c9d <insert_sorted_allocList+0x162>
  802c90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c93:	8b 40 04             	mov    0x4(%eax),%eax
  802c96:	8b 55 08             	mov    0x8(%ebp),%edx
  802c99:	89 10                	mov    %edx,(%eax)
  802c9b:	eb 08                	jmp    802ca5 <insert_sorted_allocList+0x16a>
  802c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca0:	a3 40 50 80 00       	mov    %eax,0x805040
  802ca5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca8:	8b 55 08             	mov    0x8(%ebp),%edx
  802cab:	89 50 04             	mov    %edx,0x4(%eax)
  802cae:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802cb3:	40                   	inc    %eax
  802cb4:	a3 4c 50 80 00       	mov    %eax,0x80504c

		break;}
  802cb9:	e9 59 01 00 00       	jmp    802e17 <insert_sorted_allocList+0x2dc>

	else if ((blockToInsert->sva>element->sva)&&(blockToInsert->sva<AllocMemBlocksList.lh_last->sva)&&blockToInsert->sva<LIST_NEXT(element)->sva)
  802cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc1:	8b 50 08             	mov    0x8(%eax),%edx
  802cc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc7:	8b 40 08             	mov    0x8(%eax),%eax
  802cca:	39 c2                	cmp    %eax,%edx
  802ccc:	0f 86 98 00 00 00    	jbe    802d6a <insert_sorted_allocList+0x22f>
  802cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd5:	8b 50 08             	mov    0x8(%eax),%edx
  802cd8:	a1 44 50 80 00       	mov    0x805044,%eax
  802cdd:	8b 40 08             	mov    0x8(%eax),%eax
  802ce0:	39 c2                	cmp    %eax,%edx
  802ce2:	0f 83 82 00 00 00    	jae    802d6a <insert_sorted_allocList+0x22f>
  802ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ceb:	8b 50 08             	mov    0x8(%eax),%edx
  802cee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf1:	8b 00                	mov    (%eax),%eax
  802cf3:	8b 40 08             	mov    0x8(%eax),%eax
  802cf6:	39 c2                	cmp    %eax,%edx
  802cf8:	73 70                	jae    802d6a <insert_sorted_allocList+0x22f>
	{

	LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  802cfa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cfe:	74 06                	je     802d06 <insert_sorted_allocList+0x1cb>
  802d00:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d04:	75 14                	jne    802d1a <insert_sorted_allocList+0x1df>
  802d06:	83 ec 04             	sub    $0x4,%esp
  802d09:	68 84 44 80 00       	push   $0x804484
  802d0e:	6a 7c                	push   $0x7c
  802d10:	68 33 44 80 00       	push   $0x804433
  802d15:	e8 90 df ff ff       	call   800caa <_panic>
  802d1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1d:	8b 10                	mov    (%eax),%edx
  802d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d22:	89 10                	mov    %edx,(%eax)
  802d24:	8b 45 08             	mov    0x8(%ebp),%eax
  802d27:	8b 00                	mov    (%eax),%eax
  802d29:	85 c0                	test   %eax,%eax
  802d2b:	74 0b                	je     802d38 <insert_sorted_allocList+0x1fd>
  802d2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d30:	8b 00                	mov    (%eax),%eax
  802d32:	8b 55 08             	mov    0x8(%ebp),%edx
  802d35:	89 50 04             	mov    %edx,0x4(%eax)
  802d38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3b:	8b 55 08             	mov    0x8(%ebp),%edx
  802d3e:	89 10                	mov    %edx,(%eax)
  802d40:	8b 45 08             	mov    0x8(%ebp),%eax
  802d43:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d46:	89 50 04             	mov    %edx,0x4(%eax)
  802d49:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4c:	8b 00                	mov    (%eax),%eax
  802d4e:	85 c0                	test   %eax,%eax
  802d50:	75 08                	jne    802d5a <insert_sorted_allocList+0x21f>
  802d52:	8b 45 08             	mov    0x8(%ebp),%eax
  802d55:	a3 44 50 80 00       	mov    %eax,0x805044
  802d5a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802d5f:	40                   	inc    %eax
  802d60:	a3 4c 50 80 00       	mov    %eax,0x80504c
		break;
  802d65:	e9 ad 00 00 00       	jmp    802e17 <insert_sorted_allocList+0x2dc>
	}else if (blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  802d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6d:	8b 50 08             	mov    0x8(%eax),%edx
  802d70:	a1 44 50 80 00       	mov    0x805044,%eax
  802d75:	8b 40 08             	mov    0x8(%eax),%eax
  802d78:	39 c2                	cmp    %eax,%edx
  802d7a:	76 65                	jbe    802de1 <insert_sorted_allocList+0x2a6>
	{
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
  802d7c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d80:	75 17                	jne    802d99 <insert_sorted_allocList+0x25e>
  802d82:	83 ec 04             	sub    $0x4,%esp
  802d85:	68 b8 44 80 00       	push   $0x8044b8
  802d8a:	68 80 00 00 00       	push   $0x80
  802d8f:	68 33 44 80 00       	push   $0x804433
  802d94:	e8 11 df ff ff       	call   800caa <_panic>
  802d99:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802d9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802da2:	89 50 04             	mov    %edx,0x4(%eax)
  802da5:	8b 45 08             	mov    0x8(%ebp),%eax
  802da8:	8b 40 04             	mov    0x4(%eax),%eax
  802dab:	85 c0                	test   %eax,%eax
  802dad:	74 0c                	je     802dbb <insert_sorted_allocList+0x280>
  802daf:	a1 44 50 80 00       	mov    0x805044,%eax
  802db4:	8b 55 08             	mov    0x8(%ebp),%edx
  802db7:	89 10                	mov    %edx,(%eax)
  802db9:	eb 08                	jmp    802dc3 <insert_sorted_allocList+0x288>
  802dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbe:	a3 40 50 80 00       	mov    %eax,0x805040
  802dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc6:	a3 44 50 80 00       	mov    %eax,0x805044
  802dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dd4:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802dd9:	40                   	inc    %eax
  802dda:	a3 4c 50 80 00       	mov    %eax,0x80504c
		break;
  802ddf:	eb 36                	jmp    802e17 <insert_sorted_allocList+0x2dc>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  802de1:	a1 48 50 80 00       	mov    0x805048,%eax
  802de6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802de9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ded:	74 07                	je     802df6 <insert_sorted_allocList+0x2bb>
  802def:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df2:	8b 00                	mov    (%eax),%eax
  802df4:	eb 05                	jmp    802dfb <insert_sorted_allocList+0x2c0>
  802df6:	b8 00 00 00 00       	mov    $0x0,%eax
  802dfb:	a3 48 50 80 00       	mov    %eax,0x805048
  802e00:	a1 48 50 80 00       	mov    0x805048,%eax
  802e05:	85 c0                	test   %eax,%eax
  802e07:	0f 85 23 fe ff ff    	jne    802c30 <insert_sorted_allocList+0xf5>
  802e0d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e11:	0f 85 19 fe ff ff    	jne    802c30 <insert_sorted_allocList+0xf5>
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
		break;

	}
	}
}
  802e17:	90                   	nop
  802e18:	c9                   	leave  
  802e19:	c3                   	ret    

00802e1a <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802e1a:	55                   	push   %ebp
  802e1b:	89 e5                	mov    %esp,%ebp
  802e1d:	83 ec 18             	sub    $0x18,%esp
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802e20:	a1 38 51 80 00       	mov    0x805138,%eax
  802e25:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e28:	e9 7c 01 00 00       	jmp    802fa9 <alloc_block_FF+0x18f>
		{
			// case 2
				if(element->size == size)
  802e2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e30:	8b 40 0c             	mov    0xc(%eax),%eax
  802e33:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e36:	0f 85 90 00 00 00    	jne    802ecc <alloc_block_FF+0xb2>
				{
					tmp_block=element;
  802e3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,element);
  802e42:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e46:	75 17                	jne    802e5f <alloc_block_FF+0x45>
  802e48:	83 ec 04             	sub    $0x4,%esp
  802e4b:	68 db 44 80 00       	push   $0x8044db
  802e50:	68 ba 00 00 00       	push   $0xba
  802e55:	68 33 44 80 00       	push   $0x804433
  802e5a:	e8 4b de ff ff       	call   800caa <_panic>
  802e5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e62:	8b 00                	mov    (%eax),%eax
  802e64:	85 c0                	test   %eax,%eax
  802e66:	74 10                	je     802e78 <alloc_block_FF+0x5e>
  802e68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6b:	8b 00                	mov    (%eax),%eax
  802e6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e70:	8b 52 04             	mov    0x4(%edx),%edx
  802e73:	89 50 04             	mov    %edx,0x4(%eax)
  802e76:	eb 0b                	jmp    802e83 <alloc_block_FF+0x69>
  802e78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7b:	8b 40 04             	mov    0x4(%eax),%eax
  802e7e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e86:	8b 40 04             	mov    0x4(%eax),%eax
  802e89:	85 c0                	test   %eax,%eax
  802e8b:	74 0f                	je     802e9c <alloc_block_FF+0x82>
  802e8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e90:	8b 40 04             	mov    0x4(%eax),%eax
  802e93:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e96:	8b 12                	mov    (%edx),%edx
  802e98:	89 10                	mov    %edx,(%eax)
  802e9a:	eb 0a                	jmp    802ea6 <alloc_block_FF+0x8c>
  802e9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9f:	8b 00                	mov    (%eax),%eax
  802ea1:	a3 38 51 80 00       	mov    %eax,0x805138
  802ea6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802eaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eb9:	a1 44 51 80 00       	mov    0x805144,%eax
  802ebe:	48                   	dec    %eax
  802ebf:	a3 44 51 80 00       	mov    %eax,0x805144
					return tmp_block;
  802ec4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ec7:	e9 10 01 00 00       	jmp    802fdc <alloc_block_FF+0x1c2>
				}
				 // case 3
				else if(element->size > size)
  802ecc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecf:	8b 40 0c             	mov    0xc(%eax),%eax
  802ed2:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ed5:	0f 86 c6 00 00 00    	jbe    802fa1 <alloc_block_FF+0x187>
				{
					// the new block are created
					tmp_block = AvailableMemBlocksList.lh_first ;
  802edb:	a1 48 51 80 00       	mov    0x805148,%eax
  802ee0:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  802ee3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ee7:	75 17                	jne    802f00 <alloc_block_FF+0xe6>
  802ee9:	83 ec 04             	sub    $0x4,%esp
  802eec:	68 db 44 80 00       	push   $0x8044db
  802ef1:	68 c2 00 00 00       	push   $0xc2
  802ef6:	68 33 44 80 00       	push   $0x804433
  802efb:	e8 aa dd ff ff       	call   800caa <_panic>
  802f00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f03:	8b 00                	mov    (%eax),%eax
  802f05:	85 c0                	test   %eax,%eax
  802f07:	74 10                	je     802f19 <alloc_block_FF+0xff>
  802f09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f0c:	8b 00                	mov    (%eax),%eax
  802f0e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f11:	8b 52 04             	mov    0x4(%edx),%edx
  802f14:	89 50 04             	mov    %edx,0x4(%eax)
  802f17:	eb 0b                	jmp    802f24 <alloc_block_FF+0x10a>
  802f19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f1c:	8b 40 04             	mov    0x4(%eax),%eax
  802f1f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f27:	8b 40 04             	mov    0x4(%eax),%eax
  802f2a:	85 c0                	test   %eax,%eax
  802f2c:	74 0f                	je     802f3d <alloc_block_FF+0x123>
  802f2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f31:	8b 40 04             	mov    0x4(%eax),%eax
  802f34:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f37:	8b 12                	mov    (%edx),%edx
  802f39:	89 10                	mov    %edx,(%eax)
  802f3b:	eb 0a                	jmp    802f47 <alloc_block_FF+0x12d>
  802f3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f40:	8b 00                	mov    (%eax),%eax
  802f42:	a3 48 51 80 00       	mov    %eax,0x805148
  802f47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f4a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f53:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f5a:	a1 54 51 80 00       	mov    0x805154,%eax
  802f5f:	48                   	dec    %eax
  802f60:	a3 54 51 80 00       	mov    %eax,0x805154
					tmp_block->sva=element->sva;
  802f65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f68:	8b 50 08             	mov    0x8(%eax),%edx
  802f6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f6e:	89 50 08             	mov    %edx,0x8(%eax)
					tmp_block->size=size;
  802f71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f74:	8b 55 08             	mov    0x8(%ebp),%edx
  802f77:	89 50 0c             	mov    %edx,0xc(%eax)
					//update block with remaining space
					element->size-=size;
  802f7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7d:	8b 40 0c             	mov    0xc(%eax),%eax
  802f80:	2b 45 08             	sub    0x8(%ebp),%eax
  802f83:	89 c2                	mov    %eax,%edx
  802f85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f88:	89 50 0c             	mov    %edx,0xc(%eax)
					element->sva = element->sva + size;
  802f8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8e:	8b 50 08             	mov    0x8(%eax),%edx
  802f91:	8b 45 08             	mov    0x8(%ebp),%eax
  802f94:	01 c2                	add    %eax,%edx
  802f96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f99:	89 50 08             	mov    %edx,0x8(%eax)
					// return back the new block
					return tmp_block ;
  802f9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f9f:	eb 3b                	jmp    802fdc <alloc_block_FF+0x1c2>
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802fa1:	a1 40 51 80 00       	mov    0x805140,%eax
  802fa6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fa9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fad:	74 07                	je     802fb6 <alloc_block_FF+0x19c>
  802faf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb2:	8b 00                	mov    (%eax),%eax
  802fb4:	eb 05                	jmp    802fbb <alloc_block_FF+0x1a1>
  802fb6:	b8 00 00 00 00       	mov    $0x0,%eax
  802fbb:	a3 40 51 80 00       	mov    %eax,0x805140
  802fc0:	a1 40 51 80 00       	mov    0x805140,%eax
  802fc5:	85 c0                	test   %eax,%eax
  802fc7:	0f 85 60 fe ff ff    	jne    802e2d <alloc_block_FF+0x13>
  802fcd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fd1:	0f 85 56 fe ff ff    	jne    802e2d <alloc_block_FF+0x13>
					// return back the new block
					return tmp_block ;
				}
		}
		// case 1
	  return NULL ;}
  802fd7:	b8 00 00 00 00       	mov    $0x0,%eax
  802fdc:	c9                   	leave  
  802fdd:	c3                   	ret    

00802fde <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================

struct MemBlock *alloc_block_BF(uint32 size)
{
  802fde:	55                   	push   %ebp
  802fdf:	89 e5                	mov    %esp,%ebp
  802fe1:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
  802fe4:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802feb:	a1 38 51 80 00       	mov    0x805138,%eax
  802ff0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ff3:	eb 3a                	jmp    80302f <alloc_block_BF+0x51>
		{
			if(element->size >= size)
  802ff5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff8:	8b 40 0c             	mov    0xc(%eax),%eax
  802ffb:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ffe:	72 27                	jb     803027 <alloc_block_BF+0x49>
			{
				if(best_size==-1)
  803000:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  803004:	75 0b                	jne    803011 <alloc_block_BF+0x33>
					best_size= element->size;
  803006:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803009:	8b 40 0c             	mov    0xc(%eax),%eax
  80300c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80300f:	eb 16                	jmp    803027 <alloc_block_BF+0x49>
				else if(best_size >= element->size)
  803011:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803014:	8b 50 0c             	mov    0xc(%eax),%edx
  803017:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80301a:	39 c2                	cmp    %eax,%edx
  80301c:	77 09                	ja     803027 <alloc_block_BF+0x49>
					best_size=element->size;
  80301e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803021:	8b 40 0c             	mov    0xc(%eax),%eax
  803024:	89 45 f0             	mov    %eax,-0x10(%ebp)

struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  803027:	a1 40 51 80 00       	mov    0x805140,%eax
  80302c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80302f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803033:	74 07                	je     80303c <alloc_block_BF+0x5e>
  803035:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803038:	8b 00                	mov    (%eax),%eax
  80303a:	eb 05                	jmp    803041 <alloc_block_BF+0x63>
  80303c:	b8 00 00 00 00       	mov    $0x0,%eax
  803041:	a3 40 51 80 00       	mov    %eax,0x805140
  803046:	a1 40 51 80 00       	mov    0x805140,%eax
  80304b:	85 c0                	test   %eax,%eax
  80304d:	75 a6                	jne    802ff5 <alloc_block_BF+0x17>
  80304f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803053:	75 a0                	jne    802ff5 <alloc_block_BF+0x17>
					best_size= element->size;
				else if(best_size >= element->size)
					best_size=element->size;
			}
		}
		if(best_size != -1)
  803055:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  803059:	0f 84 d3 01 00 00    	je     803232 <alloc_block_BF+0x254>
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  80305f:	a1 38 51 80 00       	mov    0x805138,%eax
  803064:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803067:	e9 98 01 00 00       	jmp    803204 <alloc_block_BF+0x226>
			{
			 if((best_size > size) && (best_size == element->size))
  80306c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80306f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803072:	0f 86 da 00 00 00    	jbe    803152 <alloc_block_BF+0x174>
  803078:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307b:	8b 50 0c             	mov    0xc(%eax),%edx
  80307e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803081:	39 c2                	cmp    %eax,%edx
  803083:	0f 85 c9 00 00 00    	jne    803152 <alloc_block_BF+0x174>
			  {
				// the new block are created
			    tmp_block = AvailableMemBlocksList.lh_first ;
  803089:	a1 48 51 80 00       	mov    0x805148,%eax
  80308e:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  803091:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803095:	75 17                	jne    8030ae <alloc_block_BF+0xd0>
  803097:	83 ec 04             	sub    $0x4,%esp
  80309a:	68 db 44 80 00       	push   $0x8044db
  80309f:	68 ea 00 00 00       	push   $0xea
  8030a4:	68 33 44 80 00       	push   $0x804433
  8030a9:	e8 fc db ff ff       	call   800caa <_panic>
  8030ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030b1:	8b 00                	mov    (%eax),%eax
  8030b3:	85 c0                	test   %eax,%eax
  8030b5:	74 10                	je     8030c7 <alloc_block_BF+0xe9>
  8030b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030ba:	8b 00                	mov    (%eax),%eax
  8030bc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8030bf:	8b 52 04             	mov    0x4(%edx),%edx
  8030c2:	89 50 04             	mov    %edx,0x4(%eax)
  8030c5:	eb 0b                	jmp    8030d2 <alloc_block_BF+0xf4>
  8030c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030ca:	8b 40 04             	mov    0x4(%eax),%eax
  8030cd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030d5:	8b 40 04             	mov    0x4(%eax),%eax
  8030d8:	85 c0                	test   %eax,%eax
  8030da:	74 0f                	je     8030eb <alloc_block_BF+0x10d>
  8030dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030df:	8b 40 04             	mov    0x4(%eax),%eax
  8030e2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8030e5:	8b 12                	mov    (%edx),%edx
  8030e7:	89 10                	mov    %edx,(%eax)
  8030e9:	eb 0a                	jmp    8030f5 <alloc_block_BF+0x117>
  8030eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030ee:	8b 00                	mov    (%eax),%eax
  8030f0:	a3 48 51 80 00       	mov    %eax,0x805148
  8030f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803101:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803108:	a1 54 51 80 00       	mov    0x805154,%eax
  80310d:	48                   	dec    %eax
  80310e:	a3 54 51 80 00       	mov    %eax,0x805154
				tmp_block->sva=element->sva;
  803113:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803116:	8b 50 08             	mov    0x8(%eax),%edx
  803119:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80311c:	89 50 08             	mov    %edx,0x8(%eax)
				tmp_block->size=size;
  80311f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803122:	8b 55 08             	mov    0x8(%ebp),%edx
  803125:	89 50 0c             	mov    %edx,0xc(%eax)
				//update block with remaining space
				element->size-=size;
  803128:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80312b:	8b 40 0c             	mov    0xc(%eax),%eax
  80312e:	2b 45 08             	sub    0x8(%ebp),%eax
  803131:	89 c2                	mov    %eax,%edx
  803133:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803136:	89 50 0c             	mov    %edx,0xc(%eax)
				element->sva = element->sva + size;
  803139:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313c:	8b 50 08             	mov    0x8(%eax),%edx
  80313f:	8b 45 08             	mov    0x8(%ebp),%eax
  803142:	01 c2                	add    %eax,%edx
  803144:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803147:	89 50 08             	mov    %edx,0x8(%eax)
				// return back the new block
				return tmp_block ;
  80314a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80314d:	e9 e5 00 00 00       	jmp    803237 <alloc_block_BF+0x259>

			  }
			else if((element->size == best_size)&&(best_size == size))
  803152:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803155:	8b 50 0c             	mov    0xc(%eax),%edx
  803158:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80315b:	39 c2                	cmp    %eax,%edx
  80315d:	0f 85 99 00 00 00    	jne    8031fc <alloc_block_BF+0x21e>
  803163:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803166:	3b 45 08             	cmp    0x8(%ebp),%eax
  803169:	0f 85 8d 00 00 00    	jne    8031fc <alloc_block_BF+0x21e>
			  {
				tmp_block=element;
  80316f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803172:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&FreeMemBlocksList,element);
  803175:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803179:	75 17                	jne    803192 <alloc_block_BF+0x1b4>
  80317b:	83 ec 04             	sub    $0x4,%esp
  80317e:	68 db 44 80 00       	push   $0x8044db
  803183:	68 f7 00 00 00       	push   $0xf7
  803188:	68 33 44 80 00       	push   $0x804433
  80318d:	e8 18 db ff ff       	call   800caa <_panic>
  803192:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803195:	8b 00                	mov    (%eax),%eax
  803197:	85 c0                	test   %eax,%eax
  803199:	74 10                	je     8031ab <alloc_block_BF+0x1cd>
  80319b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80319e:	8b 00                	mov    (%eax),%eax
  8031a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031a3:	8b 52 04             	mov    0x4(%edx),%edx
  8031a6:	89 50 04             	mov    %edx,0x4(%eax)
  8031a9:	eb 0b                	jmp    8031b6 <alloc_block_BF+0x1d8>
  8031ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ae:	8b 40 04             	mov    0x4(%eax),%eax
  8031b1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b9:	8b 40 04             	mov    0x4(%eax),%eax
  8031bc:	85 c0                	test   %eax,%eax
  8031be:	74 0f                	je     8031cf <alloc_block_BF+0x1f1>
  8031c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c3:	8b 40 04             	mov    0x4(%eax),%eax
  8031c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031c9:	8b 12                	mov    (%edx),%edx
  8031cb:	89 10                	mov    %edx,(%eax)
  8031cd:	eb 0a                	jmp    8031d9 <alloc_block_BF+0x1fb>
  8031cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d2:	8b 00                	mov    (%eax),%eax
  8031d4:	a3 38 51 80 00       	mov    %eax,0x805138
  8031d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031ec:	a1 44 51 80 00       	mov    0x805144,%eax
  8031f1:	48                   	dec    %eax
  8031f2:	a3 44 51 80 00       	mov    %eax,0x805144
				return tmp_block;
  8031f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031fa:	eb 3b                	jmp    803237 <alloc_block_BF+0x259>
					best_size=element->size;
			}
		}
		if(best_size != -1)
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  8031fc:	a1 40 51 80 00       	mov    0x805140,%eax
  803201:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803204:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803208:	74 07                	je     803211 <alloc_block_BF+0x233>
  80320a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80320d:	8b 00                	mov    (%eax),%eax
  80320f:	eb 05                	jmp    803216 <alloc_block_BF+0x238>
  803211:	b8 00 00 00 00       	mov    $0x0,%eax
  803216:	a3 40 51 80 00       	mov    %eax,0x805140
  80321b:	a1 40 51 80 00       	mov    0x805140,%eax
  803220:	85 c0                	test   %eax,%eax
  803222:	0f 85 44 fe ff ff    	jne    80306c <alloc_block_BF+0x8e>
  803228:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80322c:	0f 85 3a fe ff ff    	jne    80306c <alloc_block_BF+0x8e>
				LIST_REMOVE(&FreeMemBlocksList,element);
				return tmp_block;
			 }
			}
		}
		return NULL ;}
  803232:	b8 00 00 00 00       	mov    $0x0,%eax
  803237:	c9                   	leave  
  803238:	c3                   	ret    

00803239 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  803239:	55                   	push   %ebp
  80323a:	89 e5                	mov    %esp,%ebp
  80323c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  80323f:	83 ec 04             	sub    $0x4,%esp
  803242:	68 fc 44 80 00       	push   $0x8044fc
  803247:	68 04 01 00 00       	push   $0x104
  80324c:	68 33 44 80 00       	push   $0x804433
  803251:	e8 54 da ff ff       	call   800caa <_panic>

00803256 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{struct MemBlock * blk_itr;
  803256:	55                   	push   %ebp
  803257:	89 e5                	mov    %esp,%ebp
  803259:	83 ec 18             	sub    $0x18,%esp
struct MemBlock * next;
struct MemBlock * first = LIST_FIRST(&(FreeMemBlocksList));
  80325c:	a1 38 51 80 00       	mov    0x805138,%eax
  803261:	89 45 f0             	mov    %eax,-0x10(%ebp)
struct MemBlock * last = LIST_LAST(&(FreeMemBlocksList));
  803264:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803269:	89 45 ec             	mov    %eax,-0x14(%ebp)

if(LIST_EMPTY(&(FreeMemBlocksList)))
  80326c:	a1 38 51 80 00       	mov    0x805138,%eax
  803271:	85 c0                	test   %eax,%eax
  803273:	75 68                	jne    8032dd <insert_sorted_with_merge_freeList+0x87>
			{

				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  803275:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803279:	75 17                	jne    803292 <insert_sorted_with_merge_freeList+0x3c>
  80327b:	83 ec 04             	sub    $0x4,%esp
  80327e:	68 10 44 80 00       	push   $0x804410
  803283:	68 14 01 00 00       	push   $0x114
  803288:	68 33 44 80 00       	push   $0x804433
  80328d:	e8 18 da ff ff       	call   800caa <_panic>
  803292:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803298:	8b 45 08             	mov    0x8(%ebp),%eax
  80329b:	89 10                	mov    %edx,(%eax)
  80329d:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a0:	8b 00                	mov    (%eax),%eax
  8032a2:	85 c0                	test   %eax,%eax
  8032a4:	74 0d                	je     8032b3 <insert_sorted_with_merge_freeList+0x5d>
  8032a6:	a1 38 51 80 00       	mov    0x805138,%eax
  8032ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8032ae:	89 50 04             	mov    %edx,0x4(%eax)
  8032b1:	eb 08                	jmp    8032bb <insert_sorted_with_merge_freeList+0x65>
  8032b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8032be:	a3 38 51 80 00       	mov    %eax,0x805138
  8032c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032cd:	a1 44 51 80 00       	mov    0x805144,%eax
  8032d2:	40                   	inc    %eax
  8032d3:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  8032d8:	e9 d2 06 00 00       	jmp    8039af <insert_sorted_with_merge_freeList+0x759>
				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);

			}
else
{
	if( blockToInsert->sva  < first->sva )
  8032dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e0:	8b 50 08             	mov    0x8(%eax),%edx
  8032e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032e6:	8b 40 08             	mov    0x8(%eax),%eax
  8032e9:	39 c2                	cmp    %eax,%edx
  8032eb:	0f 83 22 01 00 00    	jae    803413 <insert_sorted_with_merge_freeList+0x1bd>
	{
                if( blockToInsert->sva + blockToInsert->size == first->sva)
  8032f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f4:	8b 50 08             	mov    0x8(%eax),%edx
  8032f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fa:	8b 40 0c             	mov    0xc(%eax),%eax
  8032fd:	01 c2                	add    %eax,%edx
  8032ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803302:	8b 40 08             	mov    0x8(%eax),%eax
  803305:	39 c2                	cmp    %eax,%edx
  803307:	0f 85 9e 00 00 00    	jne    8033ab <insert_sorted_with_merge_freeList+0x155>
                {

                	first->sva = blockToInsert->sva;
  80330d:	8b 45 08             	mov    0x8(%ebp),%eax
  803310:	8b 50 08             	mov    0x8(%eax),%edx
  803313:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803316:	89 50 08             	mov    %edx,0x8(%eax)
                	first->size = first->size + blockToInsert->size;
  803319:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80331c:	8b 50 0c             	mov    0xc(%eax),%edx
  80331f:	8b 45 08             	mov    0x8(%ebp),%eax
  803322:	8b 40 0c             	mov    0xc(%eax),%eax
  803325:	01 c2                	add    %eax,%edx
  803327:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80332a:	89 50 0c             	mov    %edx,0xc(%eax)
                	blockToInsert->size = blockToInsert->sva = 0;
  80332d:	8b 45 08             	mov    0x8(%ebp),%eax
  803330:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803337:	8b 45 08             	mov    0x8(%ebp),%eax
  80333a:	8b 50 08             	mov    0x8(%eax),%edx
  80333d:	8b 45 08             	mov    0x8(%ebp),%eax
  803340:	89 50 0c             	mov    %edx,0xc(%eax)
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  803343:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803347:	75 17                	jne    803360 <insert_sorted_with_merge_freeList+0x10a>
  803349:	83 ec 04             	sub    $0x4,%esp
  80334c:	68 10 44 80 00       	push   $0x804410
  803351:	68 21 01 00 00       	push   $0x121
  803356:	68 33 44 80 00       	push   $0x804433
  80335b:	e8 4a d9 ff ff       	call   800caa <_panic>
  803360:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803366:	8b 45 08             	mov    0x8(%ebp),%eax
  803369:	89 10                	mov    %edx,(%eax)
  80336b:	8b 45 08             	mov    0x8(%ebp),%eax
  80336e:	8b 00                	mov    (%eax),%eax
  803370:	85 c0                	test   %eax,%eax
  803372:	74 0d                	je     803381 <insert_sorted_with_merge_freeList+0x12b>
  803374:	a1 48 51 80 00       	mov    0x805148,%eax
  803379:	8b 55 08             	mov    0x8(%ebp),%edx
  80337c:	89 50 04             	mov    %edx,0x4(%eax)
  80337f:	eb 08                	jmp    803389 <insert_sorted_with_merge_freeList+0x133>
  803381:	8b 45 08             	mov    0x8(%ebp),%eax
  803384:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803389:	8b 45 08             	mov    0x8(%ebp),%eax
  80338c:	a3 48 51 80 00       	mov    %eax,0x805148
  803391:	8b 45 08             	mov    0x8(%ebp),%eax
  803394:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80339b:	a1 54 51 80 00       	mov    0x805154,%eax
  8033a0:	40                   	inc    %eax
  8033a1:	a3 54 51 80 00       	mov    %eax,0x805154
						}
				}
        }

}
}
  8033a6:	e9 04 06 00 00       	jmp    8039af <insert_sorted_with_merge_freeList+0x759>
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
                }

                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  8033ab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033af:	75 17                	jne    8033c8 <insert_sorted_with_merge_freeList+0x172>
  8033b1:	83 ec 04             	sub    $0x4,%esp
  8033b4:	68 10 44 80 00       	push   $0x804410
  8033b9:	68 26 01 00 00       	push   $0x126
  8033be:	68 33 44 80 00       	push   $0x804433
  8033c3:	e8 e2 d8 ff ff       	call   800caa <_panic>
  8033c8:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8033ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d1:	89 10                	mov    %edx,(%eax)
  8033d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d6:	8b 00                	mov    (%eax),%eax
  8033d8:	85 c0                	test   %eax,%eax
  8033da:	74 0d                	je     8033e9 <insert_sorted_with_merge_freeList+0x193>
  8033dc:	a1 38 51 80 00       	mov    0x805138,%eax
  8033e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8033e4:	89 50 04             	mov    %edx,0x4(%eax)
  8033e7:	eb 08                	jmp    8033f1 <insert_sorted_with_merge_freeList+0x19b>
  8033e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ec:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f4:	a3 38 51 80 00       	mov    %eax,0x805138
  8033f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033fc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803403:	a1 44 51 80 00       	mov    0x805144,%eax
  803408:	40                   	inc    %eax
  803409:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  80340e:	e9 9c 05 00 00       	jmp    8039af <insert_sorted_with_merge_freeList+0x759>
                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
                }
	}
    else if(blockToInsert->sva > last->sva)
  803413:	8b 45 08             	mov    0x8(%ebp),%eax
  803416:	8b 50 08             	mov    0x8(%eax),%edx
  803419:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80341c:	8b 40 08             	mov    0x8(%eax),%eax
  80341f:	39 c2                	cmp    %eax,%edx
  803421:	0f 86 16 01 00 00    	jbe    80353d <insert_sorted_with_merge_freeList+0x2e7>
 	{

				if(last->sva + last->size == blockToInsert->sva)
  803427:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80342a:	8b 50 08             	mov    0x8(%eax),%edx
  80342d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803430:	8b 40 0c             	mov    0xc(%eax),%eax
  803433:	01 c2                	add    %eax,%edx
  803435:	8b 45 08             	mov    0x8(%ebp),%eax
  803438:	8b 40 08             	mov    0x8(%eax),%eax
  80343b:	39 c2                	cmp    %eax,%edx
  80343d:	0f 85 92 00 00 00    	jne    8034d5 <insert_sorted_with_merge_freeList+0x27f>
				{

					last->size = last->size + blockToInsert->size;
  803443:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803446:	8b 50 0c             	mov    0xc(%eax),%edx
  803449:	8b 45 08             	mov    0x8(%ebp),%eax
  80344c:	8b 40 0c             	mov    0xc(%eax),%eax
  80344f:	01 c2                	add    %eax,%edx
  803451:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803454:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->size = blockToInsert->sva = 0;
  803457:	8b 45 08             	mov    0x8(%ebp),%eax
  80345a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803461:	8b 45 08             	mov    0x8(%ebp),%eax
  803464:	8b 50 08             	mov    0x8(%eax),%edx
  803467:	8b 45 08             	mov    0x8(%ebp),%eax
  80346a:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  80346d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803471:	75 17                	jne    80348a <insert_sorted_with_merge_freeList+0x234>
  803473:	83 ec 04             	sub    $0x4,%esp
  803476:	68 10 44 80 00       	push   $0x804410
  80347b:	68 31 01 00 00       	push   $0x131
  803480:	68 33 44 80 00       	push   $0x804433
  803485:	e8 20 d8 ff ff       	call   800caa <_panic>
  80348a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803490:	8b 45 08             	mov    0x8(%ebp),%eax
  803493:	89 10                	mov    %edx,(%eax)
  803495:	8b 45 08             	mov    0x8(%ebp),%eax
  803498:	8b 00                	mov    (%eax),%eax
  80349a:	85 c0                	test   %eax,%eax
  80349c:	74 0d                	je     8034ab <insert_sorted_with_merge_freeList+0x255>
  80349e:	a1 48 51 80 00       	mov    0x805148,%eax
  8034a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8034a6:	89 50 04             	mov    %edx,0x4(%eax)
  8034a9:	eb 08                	jmp    8034b3 <insert_sorted_with_merge_freeList+0x25d>
  8034ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ae:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b6:	a3 48 51 80 00       	mov    %eax,0x805148
  8034bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8034be:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034c5:	a1 54 51 80 00       	mov    0x805154,%eax
  8034ca:	40                   	inc    %eax
  8034cb:	a3 54 51 80 00       	mov    %eax,0x805154
						}
				}
        }

}
}
  8034d0:	e9 da 04 00 00       	jmp    8039af <insert_sorted_with_merge_freeList+0x759>

				}

				else
				{
					LIST_INSERT_TAIL(&(FreeMemBlocksList),  blockToInsert);
  8034d5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034d9:	75 17                	jne    8034f2 <insert_sorted_with_merge_freeList+0x29c>
  8034db:	83 ec 04             	sub    $0x4,%esp
  8034de:	68 b8 44 80 00       	push   $0x8044b8
  8034e3:	68 37 01 00 00       	push   $0x137
  8034e8:	68 33 44 80 00       	push   $0x804433
  8034ed:	e8 b8 d7 ff ff       	call   800caa <_panic>
  8034f2:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8034f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8034fb:	89 50 04             	mov    %edx,0x4(%eax)
  8034fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803501:	8b 40 04             	mov    0x4(%eax),%eax
  803504:	85 c0                	test   %eax,%eax
  803506:	74 0c                	je     803514 <insert_sorted_with_merge_freeList+0x2be>
  803508:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80350d:	8b 55 08             	mov    0x8(%ebp),%edx
  803510:	89 10                	mov    %edx,(%eax)
  803512:	eb 08                	jmp    80351c <insert_sorted_with_merge_freeList+0x2c6>
  803514:	8b 45 08             	mov    0x8(%ebp),%eax
  803517:	a3 38 51 80 00       	mov    %eax,0x805138
  80351c:	8b 45 08             	mov    0x8(%ebp),%eax
  80351f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803524:	8b 45 08             	mov    0x8(%ebp),%eax
  803527:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80352d:	a1 44 51 80 00       	mov    0x805144,%eax
  803532:	40                   	inc    %eax
  803533:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  803538:	e9 72 04 00 00       	jmp    8039af <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  80353d:	a1 38 51 80 00       	mov    0x805138,%eax
  803542:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803545:	e9 35 04 00 00       	jmp    80397f <insert_sorted_with_merge_freeList+0x729>
				{
				     next=LIST_NEXT(blk_itr);
  80354a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80354d:	8b 00                	mov    (%eax),%eax
  80354f:	89 45 e8             	mov    %eax,-0x18(%ebp)


					if( (blockToInsert->sva > blk_itr->sva) )
  803552:	8b 45 08             	mov    0x8(%ebp),%eax
  803555:	8b 50 08             	mov    0x8(%eax),%edx
  803558:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80355b:	8b 40 08             	mov    0x8(%eax),%eax
  80355e:	39 c2                	cmp    %eax,%edx
  803560:	0f 86 11 04 00 00    	jbe    803977 <insert_sorted_with_merge_freeList+0x721>
						{
							if(((blk_itr->sva) + (blk_itr->size) < blockToInsert->sva && (blockToInsert->sva) + (blockToInsert->size) < next->sva))
  803566:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803569:	8b 50 08             	mov    0x8(%eax),%edx
  80356c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80356f:	8b 40 0c             	mov    0xc(%eax),%eax
  803572:	01 c2                	add    %eax,%edx
  803574:	8b 45 08             	mov    0x8(%ebp),%eax
  803577:	8b 40 08             	mov    0x8(%eax),%eax
  80357a:	39 c2                	cmp    %eax,%edx
  80357c:	0f 83 8b 00 00 00    	jae    80360d <insert_sorted_with_merge_freeList+0x3b7>
  803582:	8b 45 08             	mov    0x8(%ebp),%eax
  803585:	8b 50 08             	mov    0x8(%eax),%edx
  803588:	8b 45 08             	mov    0x8(%ebp),%eax
  80358b:	8b 40 0c             	mov    0xc(%eax),%eax
  80358e:	01 c2                	add    %eax,%edx
  803590:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803593:	8b 40 08             	mov    0x8(%eax),%eax
  803596:	39 c2                	cmp    %eax,%edx
  803598:	73 73                	jae    80360d <insert_sorted_with_merge_freeList+0x3b7>
							{
								LIST_INSERT_AFTER(&(FreeMemBlocksList), blk_itr, blockToInsert);
  80359a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80359e:	74 06                	je     8035a6 <insert_sorted_with_merge_freeList+0x350>
  8035a0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035a4:	75 17                	jne    8035bd <insert_sorted_with_merge_freeList+0x367>
  8035a6:	83 ec 04             	sub    $0x4,%esp
  8035a9:	68 84 44 80 00       	push   $0x804484
  8035ae:	68 48 01 00 00       	push   $0x148
  8035b3:	68 33 44 80 00       	push   $0x804433
  8035b8:	e8 ed d6 ff ff       	call   800caa <_panic>
  8035bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c0:	8b 10                	mov    (%eax),%edx
  8035c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c5:	89 10                	mov    %edx,(%eax)
  8035c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ca:	8b 00                	mov    (%eax),%eax
  8035cc:	85 c0                	test   %eax,%eax
  8035ce:	74 0b                	je     8035db <insert_sorted_with_merge_freeList+0x385>
  8035d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035d3:	8b 00                	mov    (%eax),%eax
  8035d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8035d8:	89 50 04             	mov    %edx,0x4(%eax)
  8035db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035de:	8b 55 08             	mov    0x8(%ebp),%edx
  8035e1:	89 10                	mov    %edx,(%eax)
  8035e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035e9:	89 50 04             	mov    %edx,0x4(%eax)
  8035ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ef:	8b 00                	mov    (%eax),%eax
  8035f1:	85 c0                	test   %eax,%eax
  8035f3:	75 08                	jne    8035fd <insert_sorted_with_merge_freeList+0x3a7>
  8035f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8035fd:	a1 44 51 80 00       	mov    0x805144,%eax
  803602:	40                   	inc    %eax
  803603:	a3 44 51 80 00       	mov    %eax,0x805144
								break;
  803608:	e9 a2 03 00 00       	jmp    8039af <insert_sorted_with_merge_freeList+0x759>

							}
							else if((blockToInsert->sva + blockToInsert->size) < next->sva  && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  80360d:	8b 45 08             	mov    0x8(%ebp),%eax
  803610:	8b 50 08             	mov    0x8(%eax),%edx
  803613:	8b 45 08             	mov    0x8(%ebp),%eax
  803616:	8b 40 0c             	mov    0xc(%eax),%eax
  803619:	01 c2                	add    %eax,%edx
  80361b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80361e:	8b 40 08             	mov    0x8(%eax),%eax
  803621:	39 c2                	cmp    %eax,%edx
  803623:	0f 83 ae 00 00 00    	jae    8036d7 <insert_sorted_with_merge_freeList+0x481>
  803629:	8b 45 08             	mov    0x8(%ebp),%eax
  80362c:	8b 50 08             	mov    0x8(%eax),%edx
  80362f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803632:	8b 48 08             	mov    0x8(%eax),%ecx
  803635:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803638:	8b 40 0c             	mov    0xc(%eax),%eax
  80363b:	01 c8                	add    %ecx,%eax
  80363d:	39 c2                	cmp    %eax,%edx
  80363f:	0f 85 92 00 00 00    	jne    8036d7 <insert_sorted_with_merge_freeList+0x481>
							{

								blk_itr->size=blk_itr->size+blockToInsert->size;
  803645:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803648:	8b 50 0c             	mov    0xc(%eax),%edx
  80364b:	8b 45 08             	mov    0x8(%ebp),%eax
  80364e:	8b 40 0c             	mov    0xc(%eax),%eax
  803651:	01 c2                	add    %eax,%edx
  803653:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803656:	89 50 0c             	mov    %edx,0xc(%eax)
								 blockToInsert->size=blockToInsert->sva=0;
  803659:	8b 45 08             	mov    0x8(%ebp),%eax
  80365c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803663:	8b 45 08             	mov    0x8(%ebp),%eax
  803666:	8b 50 08             	mov    0x8(%eax),%edx
  803669:	8b 45 08             	mov    0x8(%ebp),%eax
  80366c:	89 50 0c             	mov    %edx,0xc(%eax)
								 LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  80366f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803673:	75 17                	jne    80368c <insert_sorted_with_merge_freeList+0x436>
  803675:	83 ec 04             	sub    $0x4,%esp
  803678:	68 10 44 80 00       	push   $0x804410
  80367d:	68 51 01 00 00       	push   $0x151
  803682:	68 33 44 80 00       	push   $0x804433
  803687:	e8 1e d6 ff ff       	call   800caa <_panic>
  80368c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803692:	8b 45 08             	mov    0x8(%ebp),%eax
  803695:	89 10                	mov    %edx,(%eax)
  803697:	8b 45 08             	mov    0x8(%ebp),%eax
  80369a:	8b 00                	mov    (%eax),%eax
  80369c:	85 c0                	test   %eax,%eax
  80369e:	74 0d                	je     8036ad <insert_sorted_with_merge_freeList+0x457>
  8036a0:	a1 48 51 80 00       	mov    0x805148,%eax
  8036a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8036a8:	89 50 04             	mov    %edx,0x4(%eax)
  8036ab:	eb 08                	jmp    8036b5 <insert_sorted_with_merge_freeList+0x45f>
  8036ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8036b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b8:	a3 48 51 80 00       	mov    %eax,0x805148
  8036bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036c7:	a1 54 51 80 00       	mov    0x805154,%eax
  8036cc:	40                   	inc    %eax
  8036cd:	a3 54 51 80 00       	mov    %eax,0x805154
								 break;
  8036d2:	e9 d8 02 00 00       	jmp    8039af <insert_sorted_with_merge_freeList+0x759>

							}
							else if( (blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva > (blk_itr->sva + blk_itr->size))
  8036d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8036da:	8b 50 08             	mov    0x8(%eax),%edx
  8036dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8036e3:	01 c2                	add    %eax,%edx
  8036e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036e8:	8b 40 08             	mov    0x8(%eax),%eax
  8036eb:	39 c2                	cmp    %eax,%edx
  8036ed:	0f 85 ba 00 00 00    	jne    8037ad <insert_sorted_with_merge_freeList+0x557>
  8036f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f6:	8b 50 08             	mov    0x8(%eax),%edx
  8036f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036fc:	8b 48 08             	mov    0x8(%eax),%ecx
  8036ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803702:	8b 40 0c             	mov    0xc(%eax),%eax
  803705:	01 c8                	add    %ecx,%eax
  803707:	39 c2                	cmp    %eax,%edx
  803709:	0f 86 9e 00 00 00    	jbe    8037ad <insert_sorted_with_merge_freeList+0x557>
							{
								next->size = next->size + blockToInsert->size;
  80370f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803712:	8b 50 0c             	mov    0xc(%eax),%edx
  803715:	8b 45 08             	mov    0x8(%ebp),%eax
  803718:	8b 40 0c             	mov    0xc(%eax),%eax
  80371b:	01 c2                	add    %eax,%edx
  80371d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803720:	89 50 0c             	mov    %edx,0xc(%eax)
								next->sva = blockToInsert->sva;
  803723:	8b 45 08             	mov    0x8(%ebp),%eax
  803726:	8b 50 08             	mov    0x8(%eax),%edx
  803729:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80372c:	89 50 08             	mov    %edx,0x8(%eax)

								blockToInsert->size = blockToInsert->sva = 0;
  80372f:	8b 45 08             	mov    0x8(%ebp),%eax
  803732:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803739:	8b 45 08             	mov    0x8(%ebp),%eax
  80373c:	8b 50 08             	mov    0x8(%eax),%edx
  80373f:	8b 45 08             	mov    0x8(%ebp),%eax
  803742:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  803745:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803749:	75 17                	jne    803762 <insert_sorted_with_merge_freeList+0x50c>
  80374b:	83 ec 04             	sub    $0x4,%esp
  80374e:	68 10 44 80 00       	push   $0x804410
  803753:	68 5b 01 00 00       	push   $0x15b
  803758:	68 33 44 80 00       	push   $0x804433
  80375d:	e8 48 d5 ff ff       	call   800caa <_panic>
  803762:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803768:	8b 45 08             	mov    0x8(%ebp),%eax
  80376b:	89 10                	mov    %edx,(%eax)
  80376d:	8b 45 08             	mov    0x8(%ebp),%eax
  803770:	8b 00                	mov    (%eax),%eax
  803772:	85 c0                	test   %eax,%eax
  803774:	74 0d                	je     803783 <insert_sorted_with_merge_freeList+0x52d>
  803776:	a1 48 51 80 00       	mov    0x805148,%eax
  80377b:	8b 55 08             	mov    0x8(%ebp),%edx
  80377e:	89 50 04             	mov    %edx,0x4(%eax)
  803781:	eb 08                	jmp    80378b <insert_sorted_with_merge_freeList+0x535>
  803783:	8b 45 08             	mov    0x8(%ebp),%eax
  803786:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80378b:	8b 45 08             	mov    0x8(%ebp),%eax
  80378e:	a3 48 51 80 00       	mov    %eax,0x805148
  803793:	8b 45 08             	mov    0x8(%ebp),%eax
  803796:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80379d:	a1 54 51 80 00       	mov    0x805154,%eax
  8037a2:	40                   	inc    %eax
  8037a3:	a3 54 51 80 00       	mov    %eax,0x805154
								break;
  8037a8:	e9 02 02 00 00       	jmp    8039af <insert_sorted_with_merge_freeList+0x759>
							}
							else if ((blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  8037ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b0:	8b 50 08             	mov    0x8(%eax),%edx
  8037b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8037b9:	01 c2                	add    %eax,%edx
  8037bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037be:	8b 40 08             	mov    0x8(%eax),%eax
  8037c1:	39 c2                	cmp    %eax,%edx
  8037c3:	0f 85 ae 01 00 00    	jne    803977 <insert_sorted_with_merge_freeList+0x721>
  8037c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8037cc:	8b 50 08             	mov    0x8(%eax),%edx
  8037cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037d2:	8b 48 08             	mov    0x8(%eax),%ecx
  8037d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8037db:	01 c8                	add    %ecx,%eax
  8037dd:	39 c2                	cmp    %eax,%edx
  8037df:	0f 85 92 01 00 00    	jne    803977 <insert_sorted_with_merge_freeList+0x721>
							{
								blk_itr->size = blk_itr->size + blockToInsert->size + next->size;
  8037e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037e8:	8b 50 0c             	mov    0xc(%eax),%edx
  8037eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8037f1:	01 c2                	add    %eax,%edx
  8037f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037f6:	8b 40 0c             	mov    0xc(%eax),%eax
  8037f9:	01 c2                	add    %eax,%edx
  8037fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037fe:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size = blockToInsert->sva=0;
  803801:	8b 45 08             	mov    0x8(%ebp),%eax
  803804:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80380b:	8b 45 08             	mov    0x8(%ebp),%eax
  80380e:	8b 50 08             	mov    0x8(%eax),%edx
  803811:	8b 45 08             	mov    0x8(%ebp),%eax
  803814:	89 50 0c             	mov    %edx,0xc(%eax)
								next->size = next->sva = 0;
  803817:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80381a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803821:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803824:	8b 50 08             	mov    0x8(%eax),%edx
  803827:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80382a:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_REMOVE(&FreeMemBlocksList, next);
  80382d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803831:	75 17                	jne    80384a <insert_sorted_with_merge_freeList+0x5f4>
  803833:	83 ec 04             	sub    $0x4,%esp
  803836:	68 db 44 80 00       	push   $0x8044db
  80383b:	68 63 01 00 00       	push   $0x163
  803840:	68 33 44 80 00       	push   $0x804433
  803845:	e8 60 d4 ff ff       	call   800caa <_panic>
  80384a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80384d:	8b 00                	mov    (%eax),%eax
  80384f:	85 c0                	test   %eax,%eax
  803851:	74 10                	je     803863 <insert_sorted_with_merge_freeList+0x60d>
  803853:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803856:	8b 00                	mov    (%eax),%eax
  803858:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80385b:	8b 52 04             	mov    0x4(%edx),%edx
  80385e:	89 50 04             	mov    %edx,0x4(%eax)
  803861:	eb 0b                	jmp    80386e <insert_sorted_with_merge_freeList+0x618>
  803863:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803866:	8b 40 04             	mov    0x4(%eax),%eax
  803869:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80386e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803871:	8b 40 04             	mov    0x4(%eax),%eax
  803874:	85 c0                	test   %eax,%eax
  803876:	74 0f                	je     803887 <insert_sorted_with_merge_freeList+0x631>
  803878:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80387b:	8b 40 04             	mov    0x4(%eax),%eax
  80387e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803881:	8b 12                	mov    (%edx),%edx
  803883:	89 10                	mov    %edx,(%eax)
  803885:	eb 0a                	jmp    803891 <insert_sorted_with_merge_freeList+0x63b>
  803887:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80388a:	8b 00                	mov    (%eax),%eax
  80388c:	a3 38 51 80 00       	mov    %eax,0x805138
  803891:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803894:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80389a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80389d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038a4:	a1 44 51 80 00       	mov    0x805144,%eax
  8038a9:	48                   	dec    %eax
  8038aa:	a3 44 51 80 00       	mov    %eax,0x805144
								LIST_INSERT_HEAD(&AvailableMemBlocksList, next );
  8038af:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8038b3:	75 17                	jne    8038cc <insert_sorted_with_merge_freeList+0x676>
  8038b5:	83 ec 04             	sub    $0x4,%esp
  8038b8:	68 10 44 80 00       	push   $0x804410
  8038bd:	68 64 01 00 00       	push   $0x164
  8038c2:	68 33 44 80 00       	push   $0x804433
  8038c7:	e8 de d3 ff ff       	call   800caa <_panic>
  8038cc:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8038d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038d5:	89 10                	mov    %edx,(%eax)
  8038d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038da:	8b 00                	mov    (%eax),%eax
  8038dc:	85 c0                	test   %eax,%eax
  8038de:	74 0d                	je     8038ed <insert_sorted_with_merge_freeList+0x697>
  8038e0:	a1 48 51 80 00       	mov    0x805148,%eax
  8038e5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8038e8:	89 50 04             	mov    %edx,0x4(%eax)
  8038eb:	eb 08                	jmp    8038f5 <insert_sorted_with_merge_freeList+0x69f>
  8038ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038f0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8038f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038f8:	a3 48 51 80 00       	mov    %eax,0x805148
  8038fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803900:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803907:	a1 54 51 80 00       	mov    0x805154,%eax
  80390c:	40                   	inc    %eax
  80390d:	a3 54 51 80 00       	mov    %eax,0x805154
							    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  803912:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803916:	75 17                	jne    80392f <insert_sorted_with_merge_freeList+0x6d9>
  803918:	83 ec 04             	sub    $0x4,%esp
  80391b:	68 10 44 80 00       	push   $0x804410
  803920:	68 65 01 00 00       	push   $0x165
  803925:	68 33 44 80 00       	push   $0x804433
  80392a:	e8 7b d3 ff ff       	call   800caa <_panic>
  80392f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803935:	8b 45 08             	mov    0x8(%ebp),%eax
  803938:	89 10                	mov    %edx,(%eax)
  80393a:	8b 45 08             	mov    0x8(%ebp),%eax
  80393d:	8b 00                	mov    (%eax),%eax
  80393f:	85 c0                	test   %eax,%eax
  803941:	74 0d                	je     803950 <insert_sorted_with_merge_freeList+0x6fa>
  803943:	a1 48 51 80 00       	mov    0x805148,%eax
  803948:	8b 55 08             	mov    0x8(%ebp),%edx
  80394b:	89 50 04             	mov    %edx,0x4(%eax)
  80394e:	eb 08                	jmp    803958 <insert_sorted_with_merge_freeList+0x702>
  803950:	8b 45 08             	mov    0x8(%ebp),%eax
  803953:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803958:	8b 45 08             	mov    0x8(%ebp),%eax
  80395b:	a3 48 51 80 00       	mov    %eax,0x805148
  803960:	8b 45 08             	mov    0x8(%ebp),%eax
  803963:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80396a:	a1 54 51 80 00       	mov    0x805154,%eax
  80396f:	40                   	inc    %eax
  803970:	a3 54 51 80 00       	mov    %eax,0x805154
								break;
  803975:	eb 38                	jmp    8039af <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  803977:	a1 40 51 80 00       	mov    0x805140,%eax
  80397c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80397f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803983:	74 07                	je     80398c <insert_sorted_with_merge_freeList+0x736>
  803985:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803988:	8b 00                	mov    (%eax),%eax
  80398a:	eb 05                	jmp    803991 <insert_sorted_with_merge_freeList+0x73b>
  80398c:	b8 00 00 00 00       	mov    $0x0,%eax
  803991:	a3 40 51 80 00       	mov    %eax,0x805140
  803996:	a1 40 51 80 00       	mov    0x805140,%eax
  80399b:	85 c0                	test   %eax,%eax
  80399d:	0f 85 a7 fb ff ff    	jne    80354a <insert_sorted_with_merge_freeList+0x2f4>
  8039a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039a7:	0f 85 9d fb ff ff    	jne    80354a <insert_sorted_with_merge_freeList+0x2f4>
						}
				}
        }

}
}
  8039ad:	eb 00                	jmp    8039af <insert_sorted_with_merge_freeList+0x759>
  8039af:	90                   	nop
  8039b0:	c9                   	leave  
  8039b1:	c3                   	ret    
  8039b2:	66 90                	xchg   %ax,%ax

008039b4 <__udivdi3>:
  8039b4:	55                   	push   %ebp
  8039b5:	57                   	push   %edi
  8039b6:	56                   	push   %esi
  8039b7:	53                   	push   %ebx
  8039b8:	83 ec 1c             	sub    $0x1c,%esp
  8039bb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8039bf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8039c3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8039c7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8039cb:	89 ca                	mov    %ecx,%edx
  8039cd:	89 f8                	mov    %edi,%eax
  8039cf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8039d3:	85 f6                	test   %esi,%esi
  8039d5:	75 2d                	jne    803a04 <__udivdi3+0x50>
  8039d7:	39 cf                	cmp    %ecx,%edi
  8039d9:	77 65                	ja     803a40 <__udivdi3+0x8c>
  8039db:	89 fd                	mov    %edi,%ebp
  8039dd:	85 ff                	test   %edi,%edi
  8039df:	75 0b                	jne    8039ec <__udivdi3+0x38>
  8039e1:	b8 01 00 00 00       	mov    $0x1,%eax
  8039e6:	31 d2                	xor    %edx,%edx
  8039e8:	f7 f7                	div    %edi
  8039ea:	89 c5                	mov    %eax,%ebp
  8039ec:	31 d2                	xor    %edx,%edx
  8039ee:	89 c8                	mov    %ecx,%eax
  8039f0:	f7 f5                	div    %ebp
  8039f2:	89 c1                	mov    %eax,%ecx
  8039f4:	89 d8                	mov    %ebx,%eax
  8039f6:	f7 f5                	div    %ebp
  8039f8:	89 cf                	mov    %ecx,%edi
  8039fa:	89 fa                	mov    %edi,%edx
  8039fc:	83 c4 1c             	add    $0x1c,%esp
  8039ff:	5b                   	pop    %ebx
  803a00:	5e                   	pop    %esi
  803a01:	5f                   	pop    %edi
  803a02:	5d                   	pop    %ebp
  803a03:	c3                   	ret    
  803a04:	39 ce                	cmp    %ecx,%esi
  803a06:	77 28                	ja     803a30 <__udivdi3+0x7c>
  803a08:	0f bd fe             	bsr    %esi,%edi
  803a0b:	83 f7 1f             	xor    $0x1f,%edi
  803a0e:	75 40                	jne    803a50 <__udivdi3+0x9c>
  803a10:	39 ce                	cmp    %ecx,%esi
  803a12:	72 0a                	jb     803a1e <__udivdi3+0x6a>
  803a14:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803a18:	0f 87 9e 00 00 00    	ja     803abc <__udivdi3+0x108>
  803a1e:	b8 01 00 00 00       	mov    $0x1,%eax
  803a23:	89 fa                	mov    %edi,%edx
  803a25:	83 c4 1c             	add    $0x1c,%esp
  803a28:	5b                   	pop    %ebx
  803a29:	5e                   	pop    %esi
  803a2a:	5f                   	pop    %edi
  803a2b:	5d                   	pop    %ebp
  803a2c:	c3                   	ret    
  803a2d:	8d 76 00             	lea    0x0(%esi),%esi
  803a30:	31 ff                	xor    %edi,%edi
  803a32:	31 c0                	xor    %eax,%eax
  803a34:	89 fa                	mov    %edi,%edx
  803a36:	83 c4 1c             	add    $0x1c,%esp
  803a39:	5b                   	pop    %ebx
  803a3a:	5e                   	pop    %esi
  803a3b:	5f                   	pop    %edi
  803a3c:	5d                   	pop    %ebp
  803a3d:	c3                   	ret    
  803a3e:	66 90                	xchg   %ax,%ax
  803a40:	89 d8                	mov    %ebx,%eax
  803a42:	f7 f7                	div    %edi
  803a44:	31 ff                	xor    %edi,%edi
  803a46:	89 fa                	mov    %edi,%edx
  803a48:	83 c4 1c             	add    $0x1c,%esp
  803a4b:	5b                   	pop    %ebx
  803a4c:	5e                   	pop    %esi
  803a4d:	5f                   	pop    %edi
  803a4e:	5d                   	pop    %ebp
  803a4f:	c3                   	ret    
  803a50:	bd 20 00 00 00       	mov    $0x20,%ebp
  803a55:	89 eb                	mov    %ebp,%ebx
  803a57:	29 fb                	sub    %edi,%ebx
  803a59:	89 f9                	mov    %edi,%ecx
  803a5b:	d3 e6                	shl    %cl,%esi
  803a5d:	89 c5                	mov    %eax,%ebp
  803a5f:	88 d9                	mov    %bl,%cl
  803a61:	d3 ed                	shr    %cl,%ebp
  803a63:	89 e9                	mov    %ebp,%ecx
  803a65:	09 f1                	or     %esi,%ecx
  803a67:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803a6b:	89 f9                	mov    %edi,%ecx
  803a6d:	d3 e0                	shl    %cl,%eax
  803a6f:	89 c5                	mov    %eax,%ebp
  803a71:	89 d6                	mov    %edx,%esi
  803a73:	88 d9                	mov    %bl,%cl
  803a75:	d3 ee                	shr    %cl,%esi
  803a77:	89 f9                	mov    %edi,%ecx
  803a79:	d3 e2                	shl    %cl,%edx
  803a7b:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a7f:	88 d9                	mov    %bl,%cl
  803a81:	d3 e8                	shr    %cl,%eax
  803a83:	09 c2                	or     %eax,%edx
  803a85:	89 d0                	mov    %edx,%eax
  803a87:	89 f2                	mov    %esi,%edx
  803a89:	f7 74 24 0c          	divl   0xc(%esp)
  803a8d:	89 d6                	mov    %edx,%esi
  803a8f:	89 c3                	mov    %eax,%ebx
  803a91:	f7 e5                	mul    %ebp
  803a93:	39 d6                	cmp    %edx,%esi
  803a95:	72 19                	jb     803ab0 <__udivdi3+0xfc>
  803a97:	74 0b                	je     803aa4 <__udivdi3+0xf0>
  803a99:	89 d8                	mov    %ebx,%eax
  803a9b:	31 ff                	xor    %edi,%edi
  803a9d:	e9 58 ff ff ff       	jmp    8039fa <__udivdi3+0x46>
  803aa2:	66 90                	xchg   %ax,%ax
  803aa4:	8b 54 24 08          	mov    0x8(%esp),%edx
  803aa8:	89 f9                	mov    %edi,%ecx
  803aaa:	d3 e2                	shl    %cl,%edx
  803aac:	39 c2                	cmp    %eax,%edx
  803aae:	73 e9                	jae    803a99 <__udivdi3+0xe5>
  803ab0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803ab3:	31 ff                	xor    %edi,%edi
  803ab5:	e9 40 ff ff ff       	jmp    8039fa <__udivdi3+0x46>
  803aba:	66 90                	xchg   %ax,%ax
  803abc:	31 c0                	xor    %eax,%eax
  803abe:	e9 37 ff ff ff       	jmp    8039fa <__udivdi3+0x46>
  803ac3:	90                   	nop

00803ac4 <__umoddi3>:
  803ac4:	55                   	push   %ebp
  803ac5:	57                   	push   %edi
  803ac6:	56                   	push   %esi
  803ac7:	53                   	push   %ebx
  803ac8:	83 ec 1c             	sub    $0x1c,%esp
  803acb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803acf:	8b 74 24 34          	mov    0x34(%esp),%esi
  803ad3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803ad7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803adb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803adf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803ae3:	89 f3                	mov    %esi,%ebx
  803ae5:	89 fa                	mov    %edi,%edx
  803ae7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803aeb:	89 34 24             	mov    %esi,(%esp)
  803aee:	85 c0                	test   %eax,%eax
  803af0:	75 1a                	jne    803b0c <__umoddi3+0x48>
  803af2:	39 f7                	cmp    %esi,%edi
  803af4:	0f 86 a2 00 00 00    	jbe    803b9c <__umoddi3+0xd8>
  803afa:	89 c8                	mov    %ecx,%eax
  803afc:	89 f2                	mov    %esi,%edx
  803afe:	f7 f7                	div    %edi
  803b00:	89 d0                	mov    %edx,%eax
  803b02:	31 d2                	xor    %edx,%edx
  803b04:	83 c4 1c             	add    $0x1c,%esp
  803b07:	5b                   	pop    %ebx
  803b08:	5e                   	pop    %esi
  803b09:	5f                   	pop    %edi
  803b0a:	5d                   	pop    %ebp
  803b0b:	c3                   	ret    
  803b0c:	39 f0                	cmp    %esi,%eax
  803b0e:	0f 87 ac 00 00 00    	ja     803bc0 <__umoddi3+0xfc>
  803b14:	0f bd e8             	bsr    %eax,%ebp
  803b17:	83 f5 1f             	xor    $0x1f,%ebp
  803b1a:	0f 84 ac 00 00 00    	je     803bcc <__umoddi3+0x108>
  803b20:	bf 20 00 00 00       	mov    $0x20,%edi
  803b25:	29 ef                	sub    %ebp,%edi
  803b27:	89 fe                	mov    %edi,%esi
  803b29:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803b2d:	89 e9                	mov    %ebp,%ecx
  803b2f:	d3 e0                	shl    %cl,%eax
  803b31:	89 d7                	mov    %edx,%edi
  803b33:	89 f1                	mov    %esi,%ecx
  803b35:	d3 ef                	shr    %cl,%edi
  803b37:	09 c7                	or     %eax,%edi
  803b39:	89 e9                	mov    %ebp,%ecx
  803b3b:	d3 e2                	shl    %cl,%edx
  803b3d:	89 14 24             	mov    %edx,(%esp)
  803b40:	89 d8                	mov    %ebx,%eax
  803b42:	d3 e0                	shl    %cl,%eax
  803b44:	89 c2                	mov    %eax,%edx
  803b46:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b4a:	d3 e0                	shl    %cl,%eax
  803b4c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b50:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b54:	89 f1                	mov    %esi,%ecx
  803b56:	d3 e8                	shr    %cl,%eax
  803b58:	09 d0                	or     %edx,%eax
  803b5a:	d3 eb                	shr    %cl,%ebx
  803b5c:	89 da                	mov    %ebx,%edx
  803b5e:	f7 f7                	div    %edi
  803b60:	89 d3                	mov    %edx,%ebx
  803b62:	f7 24 24             	mull   (%esp)
  803b65:	89 c6                	mov    %eax,%esi
  803b67:	89 d1                	mov    %edx,%ecx
  803b69:	39 d3                	cmp    %edx,%ebx
  803b6b:	0f 82 87 00 00 00    	jb     803bf8 <__umoddi3+0x134>
  803b71:	0f 84 91 00 00 00    	je     803c08 <__umoddi3+0x144>
  803b77:	8b 54 24 04          	mov    0x4(%esp),%edx
  803b7b:	29 f2                	sub    %esi,%edx
  803b7d:	19 cb                	sbb    %ecx,%ebx
  803b7f:	89 d8                	mov    %ebx,%eax
  803b81:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803b85:	d3 e0                	shl    %cl,%eax
  803b87:	89 e9                	mov    %ebp,%ecx
  803b89:	d3 ea                	shr    %cl,%edx
  803b8b:	09 d0                	or     %edx,%eax
  803b8d:	89 e9                	mov    %ebp,%ecx
  803b8f:	d3 eb                	shr    %cl,%ebx
  803b91:	89 da                	mov    %ebx,%edx
  803b93:	83 c4 1c             	add    $0x1c,%esp
  803b96:	5b                   	pop    %ebx
  803b97:	5e                   	pop    %esi
  803b98:	5f                   	pop    %edi
  803b99:	5d                   	pop    %ebp
  803b9a:	c3                   	ret    
  803b9b:	90                   	nop
  803b9c:	89 fd                	mov    %edi,%ebp
  803b9e:	85 ff                	test   %edi,%edi
  803ba0:	75 0b                	jne    803bad <__umoddi3+0xe9>
  803ba2:	b8 01 00 00 00       	mov    $0x1,%eax
  803ba7:	31 d2                	xor    %edx,%edx
  803ba9:	f7 f7                	div    %edi
  803bab:	89 c5                	mov    %eax,%ebp
  803bad:	89 f0                	mov    %esi,%eax
  803baf:	31 d2                	xor    %edx,%edx
  803bb1:	f7 f5                	div    %ebp
  803bb3:	89 c8                	mov    %ecx,%eax
  803bb5:	f7 f5                	div    %ebp
  803bb7:	89 d0                	mov    %edx,%eax
  803bb9:	e9 44 ff ff ff       	jmp    803b02 <__umoddi3+0x3e>
  803bbe:	66 90                	xchg   %ax,%ax
  803bc0:	89 c8                	mov    %ecx,%eax
  803bc2:	89 f2                	mov    %esi,%edx
  803bc4:	83 c4 1c             	add    $0x1c,%esp
  803bc7:	5b                   	pop    %ebx
  803bc8:	5e                   	pop    %esi
  803bc9:	5f                   	pop    %edi
  803bca:	5d                   	pop    %ebp
  803bcb:	c3                   	ret    
  803bcc:	3b 04 24             	cmp    (%esp),%eax
  803bcf:	72 06                	jb     803bd7 <__umoddi3+0x113>
  803bd1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803bd5:	77 0f                	ja     803be6 <__umoddi3+0x122>
  803bd7:	89 f2                	mov    %esi,%edx
  803bd9:	29 f9                	sub    %edi,%ecx
  803bdb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803bdf:	89 14 24             	mov    %edx,(%esp)
  803be2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803be6:	8b 44 24 04          	mov    0x4(%esp),%eax
  803bea:	8b 14 24             	mov    (%esp),%edx
  803bed:	83 c4 1c             	add    $0x1c,%esp
  803bf0:	5b                   	pop    %ebx
  803bf1:	5e                   	pop    %esi
  803bf2:	5f                   	pop    %edi
  803bf3:	5d                   	pop    %ebp
  803bf4:	c3                   	ret    
  803bf5:	8d 76 00             	lea    0x0(%esi),%esi
  803bf8:	2b 04 24             	sub    (%esp),%eax
  803bfb:	19 fa                	sbb    %edi,%edx
  803bfd:	89 d1                	mov    %edx,%ecx
  803bff:	89 c6                	mov    %eax,%esi
  803c01:	e9 71 ff ff ff       	jmp    803b77 <__umoddi3+0xb3>
  803c06:	66 90                	xchg   %ax,%ax
  803c08:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803c0c:	72 ea                	jb     803bf8 <__umoddi3+0x134>
  803c0e:	89 d9                	mov    %ebx,%ecx
  803c10:	e9 62 ff ff ff       	jmp    803b77 <__umoddi3+0xb3>
