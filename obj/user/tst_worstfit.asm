
obj/user/tst_worstfit:     file format elf32-i386


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
  800031:	e8 81 0c 00 00       	call   800cb7 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* *********************************************************** */

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	81 ec 40 08 00 00    	sub    $0x840,%esp
	sys_set_uheap_strategy(UHP_PLACE_WORSTFIT);
  800043:	83 ec 0c             	sub    $0xc,%esp
  800046:	6a 04                	push   $0x4
  800048:	e8 c9 28 00 00       	call   802916 <sys_set_uheap_strategy>
  80004d:	83 c4 10             	add    $0x10,%esp

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  800050:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800054:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80005b:	eb 29                	jmp    800086 <_main+0x4e>
		{
			if (myEnv->__uptr_pws[i].empty)
  80005d:	a1 20 50 80 00       	mov    0x805020,%eax
  800062:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800068:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80006b:	89 d0                	mov    %edx,%eax
  80006d:	01 c0                	add    %eax,%eax
  80006f:	01 d0                	add    %edx,%eax
  800071:	c1 e0 03             	shl    $0x3,%eax
  800074:	01 c8                	add    %ecx,%eax
  800076:	8a 40 04             	mov    0x4(%eax),%al
  800079:	84 c0                	test   %al,%al
  80007b:	74 06                	je     800083 <_main+0x4b>
			{
				fullWS = 0;
  80007d:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  800081:	eb 12                	jmp    800095 <_main+0x5d>
	sys_set_uheap_strategy(UHP_PLACE_WORSTFIT);

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800083:	ff 45 f0             	incl   -0x10(%ebp)
  800086:	a1 20 50 80 00       	mov    0x805020,%eax
  80008b:	8b 50 74             	mov    0x74(%eax),%edx
  80008e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800091:	39 c2                	cmp    %eax,%edx
  800093:	77 c8                	ja     80005d <_main+0x25>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800095:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800099:	74 14                	je     8000af <_main+0x77>
  80009b:	83 ec 04             	sub    $0x4,%esp
  80009e:	68 60 3d 80 00       	push   $0x803d60
  8000a3:	6a 16                	push   $0x16
  8000a5:	68 7c 3d 80 00       	push   $0x803d7c
  8000aa:	e8 44 0d 00 00       	call   800df3 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000af:	83 ec 0c             	sub    $0xc,%esp
  8000b2:	6a 00                	push   $0x0
  8000b4:	e8 1a 1f 00 00       	call   801fd3 <malloc>
  8000b9:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	int Mega = 1024*1024;
  8000bc:	c7 45 d8 00 00 10 00 	movl   $0x100000,-0x28(%ebp)
	int kilo = 1024;
  8000c3:	c7 45 d4 00 04 00 00 	movl   $0x400,-0x2c(%ebp)

	int count = 0;
  8000ca:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
	int totalNumberOfTests = 11;
  8000d1:	c7 45 cc 0b 00 00 00 	movl   $0xb,-0x34(%ebp)

	//Make sure that the heap size is 512 MB
	int numOf2MBsInHeap = (USER_HEAP_MAX - USER_HEAP_START) / (2*Mega);
  8000d8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000db:	01 c0                	add    %eax,%eax
  8000dd:	89 c7                	mov    %eax,%edi
  8000df:	b8 00 00 00 20       	mov    $0x20000000,%eax
  8000e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8000e9:	f7 f7                	div    %edi
  8000eb:	89 45 c8             	mov    %eax,-0x38(%ebp)
	assert(numOf2MBsInHeap == 256);
  8000ee:	81 7d c8 00 01 00 00 	cmpl   $0x100,-0x38(%ebp)
  8000f5:	74 16                	je     80010d <_main+0xd5>
  8000f7:	68 90 3d 80 00       	push   $0x803d90
  8000fc:	68 a7 3d 80 00       	push   $0x803da7
  800101:	6a 24                	push   $0x24
  800103:	68 7c 3d 80 00       	push   $0x803d7c
  800108:	e8 e6 0c 00 00       	call   800df3 <_panic>




	sys_set_uheap_strategy(UHP_PLACE_WORSTFIT);
  80010d:	83 ec 0c             	sub    $0xc,%esp
  800110:	6a 04                	push   $0x4
  800112:	e8 ff 27 00 00       	call   802916 <sys_set_uheap_strategy>
  800117:	83 c4 10             	add    $0x10,%esp

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80011a:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  80011e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800125:	eb 29                	jmp    800150 <_main+0x118>
		{
			if (myEnv->__uptr_pws[i].empty)
  800127:	a1 20 50 80 00       	mov    0x805020,%eax
  80012c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800132:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800135:	89 d0                	mov    %edx,%eax
  800137:	01 c0                	add    %eax,%eax
  800139:	01 d0                	add    %edx,%eax
  80013b:	c1 e0 03             	shl    $0x3,%eax
  80013e:	01 c8                	add    %ecx,%eax
  800140:	8a 40 04             	mov    0x4(%eax),%al
  800143:	84 c0                	test   %al,%al
  800145:	74 06                	je     80014d <_main+0x115>
			{
				fullWS = 0;
  800147:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
				break;
  80014b:	eb 12                	jmp    80015f <_main+0x127>
	sys_set_uheap_strategy(UHP_PLACE_WORSTFIT);

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  80014d:	ff 45 e8             	incl   -0x18(%ebp)
  800150:	a1 20 50 80 00       	mov    0x805020,%eax
  800155:	8b 50 74             	mov    0x74(%eax),%edx
  800158:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80015b:	39 c2                	cmp    %eax,%edx
  80015d:	77 c8                	ja     800127 <_main+0xef>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  80015f:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  800163:	74 14                	je     800179 <_main+0x141>
  800165:	83 ec 04             	sub    $0x4,%esp
  800168:	68 60 3d 80 00       	push   $0x803d60
  80016d:	6a 36                	push   $0x36
  80016f:	68 7c 3d 80 00       	push   $0x803d7c
  800174:	e8 7a 0c 00 00       	call   800df3 <_panic>
	}

	int freeFrames ;
	int usedDiskPages;

	cprintf("This test has %d tests. A pass message will be displayed after each one.\n", totalNumberOfTests);
  800179:	83 ec 08             	sub    $0x8,%esp
  80017c:	ff 75 cc             	pushl  -0x34(%ebp)
  80017f:	68 bc 3d 80 00       	push   $0x803dbc
  800184:	e8 1e 0f 00 00       	call   8010a7 <cprintf>
  800189:	83 c4 10             	add    $0x10,%esp

	//[0] Make sure there're available places in the WS
	int w = 0 ;
  80018c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	int requiredNumOfEmptyWSLocs = 2;
  800193:	c7 45 c4 02 00 00 00 	movl   $0x2,-0x3c(%ebp)
	int numOfEmptyWSLocs = 0;
  80019a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	for (w = 0 ; w < myEnv->page_WS_max_size; w++)
  8001a1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8001a8:	eb 26                	jmp    8001d0 <_main+0x198>
	{
		if( myEnv->__uptr_pws[w].empty == 1)
  8001aa:	a1 20 50 80 00       	mov    0x805020,%eax
  8001af:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8001b5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8001b8:	89 d0                	mov    %edx,%eax
  8001ba:	01 c0                	add    %eax,%eax
  8001bc:	01 d0                	add    %edx,%eax
  8001be:	c1 e0 03             	shl    $0x3,%eax
  8001c1:	01 c8                	add    %ecx,%eax
  8001c3:	8a 40 04             	mov    0x4(%eax),%al
  8001c6:	3c 01                	cmp    $0x1,%al
  8001c8:	75 03                	jne    8001cd <_main+0x195>
			numOfEmptyWSLocs++;
  8001ca:	ff 45 e0             	incl   -0x20(%ebp)

	//[0] Make sure there're available places in the WS
	int w = 0 ;
	int requiredNumOfEmptyWSLocs = 2;
	int numOfEmptyWSLocs = 0;
	for (w = 0 ; w < myEnv->page_WS_max_size; w++)
  8001cd:	ff 45 e4             	incl   -0x1c(%ebp)
  8001d0:	a1 20 50 80 00       	mov    0x805020,%eax
  8001d5:	8b 50 74             	mov    0x74(%eax),%edx
  8001d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001db:	39 c2                	cmp    %eax,%edx
  8001dd:	77 cb                	ja     8001aa <_main+0x172>
	{
		if( myEnv->__uptr_pws[w].empty == 1)
			numOfEmptyWSLocs++;
	}
	if (numOfEmptyWSLocs < requiredNumOfEmptyWSLocs)
  8001df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001e2:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  8001e5:	7d 14                	jge    8001fb <_main+0x1c3>
		panic("Insufficient number of WS empty locations! please increase the PAGE_WS_MAX_SIZE");
  8001e7:	83 ec 04             	sub    $0x4,%esp
  8001ea:	68 08 3e 80 00       	push   $0x803e08
  8001ef:	6a 48                	push   $0x48
  8001f1:	68 7c 3d 80 00       	push   $0x803d7c
  8001f6:	e8 f8 0b 00 00       	call   800df3 <_panic>

	void* ptr_allocations[512] = {0};
  8001fb:	8d 95 b8 f7 ff ff    	lea    -0x848(%ebp),%edx
  800201:	b9 00 02 00 00       	mov    $0x200,%ecx
  800206:	b8 00 00 00 00       	mov    $0x0,%eax
  80020b:	89 d7                	mov    %edx,%edi
  80020d:	f3 ab                	rep stos %eax,%es:(%edi)
	int i;

	// allocate pages
	freeFrames = sys_calculate_free_frames() ;
  80020f:	e8 ed 21 00 00       	call   802401 <sys_calculate_free_frames>
  800214:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800217:	e8 85 22 00 00       	call   8024a1 <sys_pf_calculate_allocated_pages>
  80021c:	89 45 bc             	mov    %eax,-0x44(%ebp)
	for(i = 0; i< 256;i++)
  80021f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800226:	eb 20                	jmp    800248 <_main+0x210>
	{
		ptr_allocations[i] = malloc(2*Mega);
  800228:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80022b:	01 c0                	add    %eax,%eax
  80022d:	83 ec 0c             	sub    $0xc,%esp
  800230:	50                   	push   %eax
  800231:	e8 9d 1d 00 00       	call   801fd3 <malloc>
  800236:	83 c4 10             	add    $0x10,%esp
  800239:	89 c2                	mov    %eax,%edx
  80023b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80023e:	89 94 85 b8 f7 ff ff 	mov    %edx,-0x848(%ebp,%eax,4)
	int i;

	// allocate pages
	freeFrames = sys_calculate_free_frames() ;
	usedDiskPages = sys_pf_calculate_allocated_pages();
	for(i = 0; i< 256;i++)
  800245:	ff 45 dc             	incl   -0x24(%ebp)
  800248:	81 7d dc ff 00 00 00 	cmpl   $0xff,-0x24(%ebp)
  80024f:	7e d7                	jle    800228 <_main+0x1f0>
	{
		ptr_allocations[i] = malloc(2*Mega);
	}

	// randomly check the addresses of the allocation
	if( (uint32)ptr_allocations[0] != 0x80000000 ||
  800251:	8b 85 b8 f7 ff ff    	mov    -0x848(%ebp),%eax
  800257:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  80025c:	75 4e                	jne    8002ac <_main+0x274>
			(uint32)ptr_allocations[2] != 0x80400000 ||
  80025e:	8b 85 c0 f7 ff ff    	mov    -0x840(%ebp),%eax
	{
		ptr_allocations[i] = malloc(2*Mega);
	}

	// randomly check the addresses of the allocation
	if( (uint32)ptr_allocations[0] != 0x80000000 ||
  800264:	3d 00 00 40 80       	cmp    $0x80400000,%eax
  800269:	75 41                	jne    8002ac <_main+0x274>
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
  80026b:	8b 85 d8 f7 ff ff    	mov    -0x828(%ebp),%eax
		ptr_allocations[i] = malloc(2*Mega);
	}

	// randomly check the addresses of the allocation
	if( (uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
  800271:	3d 00 00 00 81       	cmp    $0x81000000,%eax
  800276:	75 34                	jne    8002ac <_main+0x274>
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[100] != 0x8C800000 ||
  800278:	8b 85 48 f9 ff ff    	mov    -0x6b8(%ebp),%eax
	}

	// randomly check the addresses of the allocation
	if( (uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
  80027e:	3d 00 00 80 8c       	cmp    $0x8c800000,%eax
  800283:	75 27                	jne    8002ac <_main+0x274>
			(uint32)ptr_allocations[100] != 0x8C800000 ||
			(uint32)ptr_allocations[150] != 0x92C00000 ||
  800285:	8b 85 10 fa ff ff    	mov    -0x5f0(%ebp),%eax

	// randomly check the addresses of the allocation
	if( (uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[100] != 0x8C800000 ||
  80028b:	3d 00 00 c0 92       	cmp    $0x92c00000,%eax
  800290:	75 1a                	jne    8002ac <_main+0x274>
			(uint32)ptr_allocations[150] != 0x92C00000 ||
			(uint32)ptr_allocations[200] != 0x99000000 ||
  800292:	8b 85 d8 fa ff ff    	mov    -0x528(%ebp),%eax
	// randomly check the addresses of the allocation
	if( (uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[100] != 0x8C800000 ||
			(uint32)ptr_allocations[150] != 0x92C00000 ||
  800298:	3d 00 00 00 99       	cmp    $0x99000000,%eax
  80029d:	75 0d                	jne    8002ac <_main+0x274>
			(uint32)ptr_allocations[200] != 0x99000000 ||
			(uint32)ptr_allocations[255] != 0x9FE00000)
  80029f:	8b 85 b4 fb ff ff    	mov    -0x44c(%ebp),%eax
	if( (uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[100] != 0x8C800000 ||
			(uint32)ptr_allocations[150] != 0x92C00000 ||
			(uint32)ptr_allocations[200] != 0x99000000 ||
  8002a5:	3d 00 00 e0 9f       	cmp    $0x9fe00000,%eax
  8002aa:	74 14                	je     8002c0 <_main+0x288>
			(uint32)ptr_allocations[255] != 0x9FE00000)
		panic("Wrong allocation, Check fitting strategy is working correctly");
  8002ac:	83 ec 04             	sub    $0x4,%esp
  8002af:	68 58 3e 80 00       	push   $0x803e58
  8002b4:	6a 5d                	push   $0x5d
  8002b6:	68 7c 3d 80 00       	push   $0x803d7c
  8002bb:	e8 33 0b 00 00       	call   800df3 <_panic>

	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8002c0:	e8 dc 21 00 00       	call   8024a1 <sys_pf_calculate_allocated_pages>
  8002c5:	2b 45 bc             	sub    -0x44(%ebp),%eax
  8002c8:	89 c2                	mov    %eax,%edx
  8002ca:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002cd:	c1 e0 09             	shl    $0x9,%eax
  8002d0:	85 c0                	test   %eax,%eax
  8002d2:	79 05                	jns    8002d9 <_main+0x2a1>
  8002d4:	05 ff 0f 00 00       	add    $0xfff,%eax
  8002d9:	c1 f8 0c             	sar    $0xc,%eax
  8002dc:	39 c2                	cmp    %eax,%edx
  8002de:	74 14                	je     8002f4 <_main+0x2bc>
  8002e0:	83 ec 04             	sub    $0x4,%esp
  8002e3:	68 96 3e 80 00       	push   $0x803e96
  8002e8:	6a 5f                	push   $0x5f
  8002ea:	68 7c 3d 80 00       	push   $0x803d7c
  8002ef:	e8 ff 0a 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != (512*Mega)/(1024*PAGE_SIZE) ) panic("Wrong allocation");
  8002f4:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8002f7:	e8 05 21 00 00       	call   802401 <sys_calculate_free_frames>
  8002fc:	29 c3                	sub    %eax,%ebx
  8002fe:	89 da                	mov    %ebx,%edx
  800300:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800303:	c1 e0 09             	shl    $0x9,%eax
  800306:	85 c0                	test   %eax,%eax
  800308:	79 05                	jns    80030f <_main+0x2d7>
  80030a:	05 ff ff 3f 00       	add    $0x3fffff,%eax
  80030f:	c1 f8 16             	sar    $0x16,%eax
  800312:	39 c2                	cmp    %eax,%edx
  800314:	74 14                	je     80032a <_main+0x2f2>
  800316:	83 ec 04             	sub    $0x4,%esp
  800319:	68 b3 3e 80 00       	push   $0x803eb3
  80031e:	6a 60                	push   $0x60
  800320:	68 7c 3d 80 00       	push   $0x803d7c
  800325:	e8 c9 0a 00 00       	call   800df3 <_panic>

	// Make memory holes.
	freeFrames = sys_calculate_free_frames() ;
  80032a:	e8 d2 20 00 00       	call   802401 <sys_calculate_free_frames>
  80032f:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800332:	e8 6a 21 00 00       	call   8024a1 <sys_pf_calculate_allocated_pages>
  800337:	89 45 bc             	mov    %eax,-0x44(%ebp)

	free(ptr_allocations[0]);		// Hole 1 = 2 M
  80033a:	8b 85 b8 f7 ff ff    	mov    -0x848(%ebp),%eax
  800340:	83 ec 0c             	sub    $0xc,%esp
  800343:	50                   	push   %eax
  800344:	e8 05 1d 00 00       	call   80204e <free>
  800349:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[2]);		// Hole 2 = 4 M
  80034c:	8b 85 c0 f7 ff ff    	mov    -0x840(%ebp),%eax
  800352:	83 ec 0c             	sub    $0xc,%esp
  800355:	50                   	push   %eax
  800356:	e8 f3 1c 00 00       	call   80204e <free>
  80035b:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[3]);
  80035e:	8b 85 c4 f7 ff ff    	mov    -0x83c(%ebp),%eax
  800364:	83 ec 0c             	sub    $0xc,%esp
  800367:	50                   	push   %eax
  800368:	e8 e1 1c 00 00       	call   80204e <free>
  80036d:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[10]);		// Hole 3 = 6 M
  800370:	8b 85 e0 f7 ff ff    	mov    -0x820(%ebp),%eax
  800376:	83 ec 0c             	sub    $0xc,%esp
  800379:	50                   	push   %eax
  80037a:	e8 cf 1c 00 00       	call   80204e <free>
  80037f:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[12]);
  800382:	8b 85 e8 f7 ff ff    	mov    -0x818(%ebp),%eax
  800388:	83 ec 0c             	sub    $0xc,%esp
  80038b:	50                   	push   %eax
  80038c:	e8 bd 1c 00 00       	call   80204e <free>
  800391:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[11]);
  800394:	8b 85 e4 f7 ff ff    	mov    -0x81c(%ebp),%eax
  80039a:	83 ec 0c             	sub    $0xc,%esp
  80039d:	50                   	push   %eax
  80039e:	e8 ab 1c 00 00       	call   80204e <free>
  8003a3:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[100]);		// Hole 4 = 10 M
  8003a6:	8b 85 48 f9 ff ff    	mov    -0x6b8(%ebp),%eax
  8003ac:	83 ec 0c             	sub    $0xc,%esp
  8003af:	50                   	push   %eax
  8003b0:	e8 99 1c 00 00       	call   80204e <free>
  8003b5:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[104]);
  8003b8:	8b 85 58 f9 ff ff    	mov    -0x6a8(%ebp),%eax
  8003be:	83 ec 0c             	sub    $0xc,%esp
  8003c1:	50                   	push   %eax
  8003c2:	e8 87 1c 00 00       	call   80204e <free>
  8003c7:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[103]);
  8003ca:	8b 85 54 f9 ff ff    	mov    -0x6ac(%ebp),%eax
  8003d0:	83 ec 0c             	sub    $0xc,%esp
  8003d3:	50                   	push   %eax
  8003d4:	e8 75 1c 00 00       	call   80204e <free>
  8003d9:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[102]);
  8003dc:	8b 85 50 f9 ff ff    	mov    -0x6b0(%ebp),%eax
  8003e2:	83 ec 0c             	sub    $0xc,%esp
  8003e5:	50                   	push   %eax
  8003e6:	e8 63 1c 00 00       	call   80204e <free>
  8003eb:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[101]);
  8003ee:	8b 85 4c f9 ff ff    	mov    -0x6b4(%ebp),%eax
  8003f4:	83 ec 0c             	sub    $0xc,%esp
  8003f7:	50                   	push   %eax
  8003f8:	e8 51 1c 00 00       	call   80204e <free>
  8003fd:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[200]);		// Hole 5 = 8 M
  800400:	8b 85 d8 fa ff ff    	mov    -0x528(%ebp),%eax
  800406:	83 ec 0c             	sub    $0xc,%esp
  800409:	50                   	push   %eax
  80040a:	e8 3f 1c 00 00       	call   80204e <free>
  80040f:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[201]);
  800412:	8b 85 dc fa ff ff    	mov    -0x524(%ebp),%eax
  800418:	83 ec 0c             	sub    $0xc,%esp
  80041b:	50                   	push   %eax
  80041c:	e8 2d 1c 00 00       	call   80204e <free>
  800421:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[202]);
  800424:	8b 85 e0 fa ff ff    	mov    -0x520(%ebp),%eax
  80042a:	83 ec 0c             	sub    $0xc,%esp
  80042d:	50                   	push   %eax
  80042e:	e8 1b 1c 00 00       	call   80204e <free>
  800433:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[203]);
  800436:	8b 85 e4 fa ff ff    	mov    -0x51c(%ebp),%eax
  80043c:	83 ec 0c             	sub    $0xc,%esp
  80043f:	50                   	push   %eax
  800440:	e8 09 1c 00 00       	call   80204e <free>
  800445:	83 c4 10             	add    $0x10,%esp

	if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 15*(2*Mega)/PAGE_SIZE) panic("Wrong free: Extra or less pages are removed from PageFile");
  800448:	e8 54 20 00 00       	call   8024a1 <sys_pf_calculate_allocated_pages>
  80044d:	8b 55 bc             	mov    -0x44(%ebp),%edx
  800450:	89 d1                	mov    %edx,%ecx
  800452:	29 c1                	sub    %eax,%ecx
  800454:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800457:	89 d0                	mov    %edx,%eax
  800459:	01 c0                	add    %eax,%eax
  80045b:	01 d0                	add    %edx,%eax
  80045d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800464:	01 d0                	add    %edx,%eax
  800466:	01 c0                	add    %eax,%eax
  800468:	85 c0                	test   %eax,%eax
  80046a:	79 05                	jns    800471 <_main+0x439>
  80046c:	05 ff 0f 00 00       	add    $0xfff,%eax
  800471:	c1 f8 0c             	sar    $0xc,%eax
  800474:	39 c1                	cmp    %eax,%ecx
  800476:	74 14                	je     80048c <_main+0x454>
  800478:	83 ec 04             	sub    $0x4,%esp
  80047b:	68 c4 3e 80 00       	push   $0x803ec4
  800480:	6a 76                	push   $0x76
  800482:	68 7c 3d 80 00       	push   $0x803d7c
  800487:	e8 67 09 00 00       	call   800df3 <_panic>
	if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: Extra or less pages are removed from main memory");
  80048c:	e8 70 1f 00 00       	call   802401 <sys_calculate_free_frames>
  800491:	89 c2                	mov    %eax,%edx
  800493:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800496:	39 c2                	cmp    %eax,%edx
  800498:	74 14                	je     8004ae <_main+0x476>
  80049a:	83 ec 04             	sub    $0x4,%esp
  80049d:	68 00 3f 80 00       	push   $0x803f00
  8004a2:	6a 77                	push   $0x77
  8004a4:	68 7c 3d 80 00       	push   $0x803d7c
  8004a9:	e8 45 09 00 00       	call   800df3 <_panic>

	// Test worst fit
	//[WORST FIT Case]
	freeFrames = sys_calculate_free_frames() ;
  8004ae:	e8 4e 1f 00 00       	call   802401 <sys_calculate_free_frames>
  8004b3:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8004b6:	e8 e6 1f 00 00       	call   8024a1 <sys_pf_calculate_allocated_pages>
  8004bb:	89 45 bc             	mov    %eax,-0x44(%ebp)
	void* tempAddress = malloc(Mega);		// Use Hole 4 -> Hole 4 = 9 M
  8004be:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004c1:	83 ec 0c             	sub    $0xc,%esp
  8004c4:	50                   	push   %eax
  8004c5:	e8 09 1b 00 00       	call   801fd3 <malloc>
  8004ca:	83 c4 10             	add    $0x10,%esp
  8004cd:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x8C800000)
  8004d0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8004d3:	3d 00 00 80 8c       	cmp    $0x8c800000,%eax
  8004d8:	74 14                	je     8004ee <_main+0x4b6>
		panic("Worst Fit not working correctly");
  8004da:	83 ec 04             	sub    $0x4,%esp
  8004dd:	68 40 3f 80 00       	push   $0x803f40
  8004e2:	6a 7f                	push   $0x7f
  8004e4:	68 7c 3d 80 00       	push   $0x803d7c
  8004e9:	e8 05 09 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8004ee:	e8 ae 1f 00 00       	call   8024a1 <sys_pf_calculate_allocated_pages>
  8004f3:	2b 45 bc             	sub    -0x44(%ebp),%eax
  8004f6:	89 c2                	mov    %eax,%edx
  8004f8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004fb:	85 c0                	test   %eax,%eax
  8004fd:	79 05                	jns    800504 <_main+0x4cc>
  8004ff:	05 ff 0f 00 00       	add    $0xfff,%eax
  800504:	c1 f8 0c             	sar    $0xc,%eax
  800507:	39 c2                	cmp    %eax,%edx
  800509:	74 17                	je     800522 <_main+0x4ea>
  80050b:	83 ec 04             	sub    $0x4,%esp
  80050e:	68 96 3e 80 00       	push   $0x803e96
  800513:	68 80 00 00 00       	push   $0x80
  800518:	68 7c 3d 80 00       	push   $0x803d7c
  80051d:	e8 d1 08 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800522:	e8 da 1e 00 00       	call   802401 <sys_calculate_free_frames>
  800527:	89 c2                	mov    %eax,%edx
  800529:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80052c:	39 c2                	cmp    %eax,%edx
  80052e:	74 17                	je     800547 <_main+0x50f>
  800530:	83 ec 04             	sub    $0x4,%esp
  800533:	68 b3 3e 80 00       	push   $0x803eb3
  800538:	68 81 00 00 00       	push   $0x81
  80053d:	68 7c 3d 80 00       	push   $0x803d7c
  800542:	e8 ac 08 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800547:	ff 45 d0             	incl   -0x30(%ebp)
  80054a:	83 ec 08             	sub    $0x8,%esp
  80054d:	ff 75 d0             	pushl  -0x30(%ebp)
  800550:	68 60 3f 80 00       	push   $0x803f60
  800555:	e8 4d 0b 00 00       	call   8010a7 <cprintf>
  80055a:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  80055d:	e8 9f 1e 00 00       	call   802401 <sys_calculate_free_frames>
  800562:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800565:	e8 37 1f 00 00       	call   8024a1 <sys_pf_calculate_allocated_pages>
  80056a:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(4 * Mega);			// Use Hole 4 -> Hole 4 = 5 M
  80056d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800570:	c1 e0 02             	shl    $0x2,%eax
  800573:	83 ec 0c             	sub    $0xc,%esp
  800576:	50                   	push   %eax
  800577:	e8 57 1a 00 00       	call   801fd3 <malloc>
  80057c:	83 c4 10             	add    $0x10,%esp
  80057f:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x8C900000)
  800582:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800585:	3d 00 00 90 8c       	cmp    $0x8c900000,%eax
  80058a:	74 17                	je     8005a3 <_main+0x56b>
		panic("Worst Fit not working correctly");
  80058c:	83 ec 04             	sub    $0x4,%esp
  80058f:	68 40 3f 80 00       	push   $0x803f40
  800594:	68 88 00 00 00       	push   $0x88
  800599:	68 7c 3d 80 00       	push   $0x803d7c
  80059e:	e8 50 08 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8005a3:	e8 f9 1e 00 00       	call   8024a1 <sys_pf_calculate_allocated_pages>
  8005a8:	2b 45 bc             	sub    -0x44(%ebp),%eax
  8005ab:	89 c2                	mov    %eax,%edx
  8005ad:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005b0:	c1 e0 02             	shl    $0x2,%eax
  8005b3:	85 c0                	test   %eax,%eax
  8005b5:	79 05                	jns    8005bc <_main+0x584>
  8005b7:	05 ff 0f 00 00       	add    $0xfff,%eax
  8005bc:	c1 f8 0c             	sar    $0xc,%eax
  8005bf:	39 c2                	cmp    %eax,%edx
  8005c1:	74 17                	je     8005da <_main+0x5a2>
  8005c3:	83 ec 04             	sub    $0x4,%esp
  8005c6:	68 96 3e 80 00       	push   $0x803e96
  8005cb:	68 89 00 00 00       	push   $0x89
  8005d0:	68 7c 3d 80 00       	push   $0x803d7c
  8005d5:	e8 19 08 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  8005da:	e8 22 1e 00 00       	call   802401 <sys_calculate_free_frames>
  8005df:	89 c2                	mov    %eax,%edx
  8005e1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8005e4:	39 c2                	cmp    %eax,%edx
  8005e6:	74 17                	je     8005ff <_main+0x5c7>
  8005e8:	83 ec 04             	sub    $0x4,%esp
  8005eb:	68 b3 3e 80 00       	push   $0x803eb3
  8005f0:	68 8a 00 00 00       	push   $0x8a
  8005f5:	68 7c 3d 80 00       	push   $0x803d7c
  8005fa:	e8 f4 07 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  8005ff:	ff 45 d0             	incl   -0x30(%ebp)
  800602:	83 ec 08             	sub    $0x8,%esp
  800605:	ff 75 d0             	pushl  -0x30(%ebp)
  800608:	68 60 3f 80 00       	push   $0x803f60
  80060d:	e8 95 0a 00 00       	call   8010a7 <cprintf>
  800612:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  800615:	e8 e7 1d 00 00       	call   802401 <sys_calculate_free_frames>
  80061a:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  80061d:	e8 7f 1e 00 00       	call   8024a1 <sys_pf_calculate_allocated_pages>
  800622:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(6*Mega); 			   // Use Hole 5 -> Hole 5 = 2 M
  800625:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800628:	89 d0                	mov    %edx,%eax
  80062a:	01 c0                	add    %eax,%eax
  80062c:	01 d0                	add    %edx,%eax
  80062e:	01 c0                	add    %eax,%eax
  800630:	83 ec 0c             	sub    $0xc,%esp
  800633:	50                   	push   %eax
  800634:	e8 9a 19 00 00       	call   801fd3 <malloc>
  800639:	83 c4 10             	add    $0x10,%esp
  80063c:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x99000000)
  80063f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800642:	3d 00 00 00 99       	cmp    $0x99000000,%eax
  800647:	74 17                	je     800660 <_main+0x628>
		panic("Worst Fit not working correctly");
  800649:	83 ec 04             	sub    $0x4,%esp
  80064c:	68 40 3f 80 00       	push   $0x803f40
  800651:	68 91 00 00 00       	push   $0x91
  800656:	68 7c 3d 80 00       	push   $0x803d7c
  80065b:	e8 93 07 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  6*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  800660:	e8 3c 1e 00 00       	call   8024a1 <sys_pf_calculate_allocated_pages>
  800665:	2b 45 bc             	sub    -0x44(%ebp),%eax
  800668:	89 c1                	mov    %eax,%ecx
  80066a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80066d:	89 d0                	mov    %edx,%eax
  80066f:	01 c0                	add    %eax,%eax
  800671:	01 d0                	add    %edx,%eax
  800673:	01 c0                	add    %eax,%eax
  800675:	85 c0                	test   %eax,%eax
  800677:	79 05                	jns    80067e <_main+0x646>
  800679:	05 ff 0f 00 00       	add    $0xfff,%eax
  80067e:	c1 f8 0c             	sar    $0xc,%eax
  800681:	39 c1                	cmp    %eax,%ecx
  800683:	74 17                	je     80069c <_main+0x664>
  800685:	83 ec 04             	sub    $0x4,%esp
  800688:	68 96 3e 80 00       	push   $0x803e96
  80068d:	68 92 00 00 00       	push   $0x92
  800692:	68 7c 3d 80 00       	push   $0x803d7c
  800697:	e8 57 07 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  80069c:	e8 60 1d 00 00       	call   802401 <sys_calculate_free_frames>
  8006a1:	89 c2                	mov    %eax,%edx
  8006a3:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8006a6:	39 c2                	cmp    %eax,%edx
  8006a8:	74 17                	je     8006c1 <_main+0x689>
  8006aa:	83 ec 04             	sub    $0x4,%esp
  8006ad:	68 b3 3e 80 00       	push   $0x803eb3
  8006b2:	68 93 00 00 00       	push   $0x93
  8006b7:	68 7c 3d 80 00       	push   $0x803d7c
  8006bc:	e8 32 07 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  8006c1:	ff 45 d0             	incl   -0x30(%ebp)
  8006c4:	83 ec 08             	sub    $0x8,%esp
  8006c7:	ff 75 d0             	pushl  -0x30(%ebp)
  8006ca:	68 60 3f 80 00       	push   $0x803f60
  8006cf:	e8 d3 09 00 00       	call   8010a7 <cprintf>
  8006d4:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  8006d7:	e8 25 1d 00 00       	call   802401 <sys_calculate_free_frames>
  8006dc:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8006df:	e8 bd 1d 00 00       	call   8024a1 <sys_pf_calculate_allocated_pages>
  8006e4:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(5*Mega); 			   // Use Hole 3 -> Hole 3 = 1 M
  8006e7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006ea:	89 d0                	mov    %edx,%eax
  8006ec:	c1 e0 02             	shl    $0x2,%eax
  8006ef:	01 d0                	add    %edx,%eax
  8006f1:	83 ec 0c             	sub    $0xc,%esp
  8006f4:	50                   	push   %eax
  8006f5:	e8 d9 18 00 00       	call   801fd3 <malloc>
  8006fa:	83 c4 10             	add    $0x10,%esp
  8006fd:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x81400000)
  800700:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800703:	3d 00 00 40 81       	cmp    $0x81400000,%eax
  800708:	74 17                	je     800721 <_main+0x6e9>
		panic("Worst Fit not working correctly");
  80070a:	83 ec 04             	sub    $0x4,%esp
  80070d:	68 40 3f 80 00       	push   $0x803f40
  800712:	68 9a 00 00 00       	push   $0x9a
  800717:	68 7c 3d 80 00       	push   $0x803d7c
  80071c:	e8 d2 06 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  5*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  800721:	e8 7b 1d 00 00       	call   8024a1 <sys_pf_calculate_allocated_pages>
  800726:	2b 45 bc             	sub    -0x44(%ebp),%eax
  800729:	89 c1                	mov    %eax,%ecx
  80072b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80072e:	89 d0                	mov    %edx,%eax
  800730:	c1 e0 02             	shl    $0x2,%eax
  800733:	01 d0                	add    %edx,%eax
  800735:	85 c0                	test   %eax,%eax
  800737:	79 05                	jns    80073e <_main+0x706>
  800739:	05 ff 0f 00 00       	add    $0xfff,%eax
  80073e:	c1 f8 0c             	sar    $0xc,%eax
  800741:	39 c1                	cmp    %eax,%ecx
  800743:	74 17                	je     80075c <_main+0x724>
  800745:	83 ec 04             	sub    $0x4,%esp
  800748:	68 96 3e 80 00       	push   $0x803e96
  80074d:	68 9b 00 00 00       	push   $0x9b
  800752:	68 7c 3d 80 00       	push   $0x803d7c
  800757:	e8 97 06 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  80075c:	e8 a0 1c 00 00       	call   802401 <sys_calculate_free_frames>
  800761:	89 c2                	mov    %eax,%edx
  800763:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800766:	39 c2                	cmp    %eax,%edx
  800768:	74 17                	je     800781 <_main+0x749>
  80076a:	83 ec 04             	sub    $0x4,%esp
  80076d:	68 b3 3e 80 00       	push   $0x803eb3
  800772:	68 9c 00 00 00       	push   $0x9c
  800777:	68 7c 3d 80 00       	push   $0x803d7c
  80077c:	e8 72 06 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800781:	ff 45 d0             	incl   -0x30(%ebp)
  800784:	83 ec 08             	sub    $0x8,%esp
  800787:	ff 75 d0             	pushl  -0x30(%ebp)
  80078a:	68 60 3f 80 00       	push   $0x803f60
  80078f:	e8 13 09 00 00       	call   8010a7 <cprintf>
  800794:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  800797:	e8 65 1c 00 00       	call   802401 <sys_calculate_free_frames>
  80079c:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  80079f:	e8 fd 1c 00 00       	call   8024a1 <sys_pf_calculate_allocated_pages>
  8007a4:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(4*Mega); 			   // Use Hole 4 -> Hole 4 = 1 M
  8007a7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007aa:	c1 e0 02             	shl    $0x2,%eax
  8007ad:	83 ec 0c             	sub    $0xc,%esp
  8007b0:	50                   	push   %eax
  8007b1:	e8 1d 18 00 00       	call   801fd3 <malloc>
  8007b6:	83 c4 10             	add    $0x10,%esp
  8007b9:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x8CD00000)
  8007bc:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8007bf:	3d 00 00 d0 8c       	cmp    $0x8cd00000,%eax
  8007c4:	74 17                	je     8007dd <_main+0x7a5>
		panic("Worst Fit not working correctly");
  8007c6:	83 ec 04             	sub    $0x4,%esp
  8007c9:	68 40 3f 80 00       	push   $0x803f40
  8007ce:	68 a3 00 00 00       	push   $0xa3
  8007d3:	68 7c 3d 80 00       	push   $0x803d7c
  8007d8:	e8 16 06 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8007dd:	e8 bf 1c 00 00       	call   8024a1 <sys_pf_calculate_allocated_pages>
  8007e2:	2b 45 bc             	sub    -0x44(%ebp),%eax
  8007e5:	89 c2                	mov    %eax,%edx
  8007e7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007ea:	c1 e0 02             	shl    $0x2,%eax
  8007ed:	85 c0                	test   %eax,%eax
  8007ef:	79 05                	jns    8007f6 <_main+0x7be>
  8007f1:	05 ff 0f 00 00       	add    $0xfff,%eax
  8007f6:	c1 f8 0c             	sar    $0xc,%eax
  8007f9:	39 c2                	cmp    %eax,%edx
  8007fb:	74 17                	je     800814 <_main+0x7dc>
  8007fd:	83 ec 04             	sub    $0x4,%esp
  800800:	68 96 3e 80 00       	push   $0x803e96
  800805:	68 a4 00 00 00       	push   $0xa4
  80080a:	68 7c 3d 80 00       	push   $0x803d7c
  80080f:	e8 df 05 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800814:	e8 e8 1b 00 00       	call   802401 <sys_calculate_free_frames>
  800819:	89 c2                	mov    %eax,%edx
  80081b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80081e:	39 c2                	cmp    %eax,%edx
  800820:	74 17                	je     800839 <_main+0x801>
  800822:	83 ec 04             	sub    $0x4,%esp
  800825:	68 b3 3e 80 00       	push   $0x803eb3
  80082a:	68 a5 00 00 00       	push   $0xa5
  80082f:	68 7c 3d 80 00       	push   $0x803d7c
  800834:	e8 ba 05 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800839:	ff 45 d0             	incl   -0x30(%ebp)
  80083c:	83 ec 08             	sub    $0x8,%esp
  80083f:	ff 75 d0             	pushl  -0x30(%ebp)
  800842:	68 60 3f 80 00       	push   $0x803f60
  800847:	e8 5b 08 00 00       	call   8010a7 <cprintf>
  80084c:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  80084f:	e8 ad 1b 00 00       	call   802401 <sys_calculate_free_frames>
  800854:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800857:	e8 45 1c 00 00       	call   8024a1 <sys_pf_calculate_allocated_pages>
  80085c:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(2 * Mega); 			// Use Hole 2 -> Hole 2 = 2 M
  80085f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800862:	01 c0                	add    %eax,%eax
  800864:	83 ec 0c             	sub    $0xc,%esp
  800867:	50                   	push   %eax
  800868:	e8 66 17 00 00       	call   801fd3 <malloc>
  80086d:	83 c4 10             	add    $0x10,%esp
  800870:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x80400000)
  800873:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800876:	3d 00 00 40 80       	cmp    $0x80400000,%eax
  80087b:	74 17                	je     800894 <_main+0x85c>
		panic("Worst Fit not working correctly");
  80087d:	83 ec 04             	sub    $0x4,%esp
  800880:	68 40 3f 80 00       	push   $0x803f40
  800885:	68 ac 00 00 00       	push   $0xac
  80088a:	68 7c 3d 80 00       	push   $0x803d7c
  80088f:	e8 5f 05 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  800894:	e8 08 1c 00 00       	call   8024a1 <sys_pf_calculate_allocated_pages>
  800899:	2b 45 bc             	sub    -0x44(%ebp),%eax
  80089c:	89 c2                	mov    %eax,%edx
  80089e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008a1:	01 c0                	add    %eax,%eax
  8008a3:	85 c0                	test   %eax,%eax
  8008a5:	79 05                	jns    8008ac <_main+0x874>
  8008a7:	05 ff 0f 00 00       	add    $0xfff,%eax
  8008ac:	c1 f8 0c             	sar    $0xc,%eax
  8008af:	39 c2                	cmp    %eax,%edx
  8008b1:	74 17                	je     8008ca <_main+0x892>
  8008b3:	83 ec 04             	sub    $0x4,%esp
  8008b6:	68 96 3e 80 00       	push   $0x803e96
  8008bb:	68 ad 00 00 00       	push   $0xad
  8008c0:	68 7c 3d 80 00       	push   $0x803d7c
  8008c5:	e8 29 05 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  8008ca:	e8 32 1b 00 00       	call   802401 <sys_calculate_free_frames>
  8008cf:	89 c2                	mov    %eax,%edx
  8008d1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8008d4:	39 c2                	cmp    %eax,%edx
  8008d6:	74 17                	je     8008ef <_main+0x8b7>
  8008d8:	83 ec 04             	sub    $0x4,%esp
  8008db:	68 b3 3e 80 00       	push   $0x803eb3
  8008e0:	68 ae 00 00 00       	push   $0xae
  8008e5:	68 7c 3d 80 00       	push   $0x803d7c
  8008ea:	e8 04 05 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  8008ef:	ff 45 d0             	incl   -0x30(%ebp)
  8008f2:	83 ec 08             	sub    $0x8,%esp
  8008f5:	ff 75 d0             	pushl  -0x30(%ebp)
  8008f8:	68 60 3f 80 00       	push   $0x803f60
  8008fd:	e8 a5 07 00 00       	call   8010a7 <cprintf>
  800902:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  800905:	e8 f7 1a 00 00       	call   802401 <sys_calculate_free_frames>
  80090a:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  80090d:	e8 8f 1b 00 00       	call   8024a1 <sys_pf_calculate_allocated_pages>
  800912:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(1*Mega + 512*kilo);    // Use Hole 1 -> Hole 1 = 0.5 M
  800915:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800918:	c1 e0 09             	shl    $0x9,%eax
  80091b:	89 c2                	mov    %eax,%edx
  80091d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800920:	01 d0                	add    %edx,%eax
  800922:	83 ec 0c             	sub    $0xc,%esp
  800925:	50                   	push   %eax
  800926:	e8 a8 16 00 00       	call   801fd3 <malloc>
  80092b:	83 c4 10             	add    $0x10,%esp
  80092e:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x80000000)
  800931:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800934:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800939:	74 17                	je     800952 <_main+0x91a>
		panic("Worst Fit not working correctly");
  80093b:	83 ec 04             	sub    $0x4,%esp
  80093e:	68 40 3f 80 00       	push   $0x803f40
  800943:	68 b5 00 00 00       	push   $0xb5
  800948:	68 7c 3d 80 00       	push   $0x803d7c
  80094d:	e8 a1 04 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  (1*Mega + 512*kilo)/PAGE_SIZE) panic("Wrong page file allocation: ");
  800952:	e8 4a 1b 00 00       	call   8024a1 <sys_pf_calculate_allocated_pages>
  800957:	2b 45 bc             	sub    -0x44(%ebp),%eax
  80095a:	89 c2                	mov    %eax,%edx
  80095c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80095f:	c1 e0 09             	shl    $0x9,%eax
  800962:	89 c1                	mov    %eax,%ecx
  800964:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800967:	01 c8                	add    %ecx,%eax
  800969:	85 c0                	test   %eax,%eax
  80096b:	79 05                	jns    800972 <_main+0x93a>
  80096d:	05 ff 0f 00 00       	add    $0xfff,%eax
  800972:	c1 f8 0c             	sar    $0xc,%eax
  800975:	39 c2                	cmp    %eax,%edx
  800977:	74 17                	je     800990 <_main+0x958>
  800979:	83 ec 04             	sub    $0x4,%esp
  80097c:	68 96 3e 80 00       	push   $0x803e96
  800981:	68 b6 00 00 00       	push   $0xb6
  800986:	68 7c 3d 80 00       	push   $0x803d7c
  80098b:	e8 63 04 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800990:	e8 6c 1a 00 00       	call   802401 <sys_calculate_free_frames>
  800995:	89 c2                	mov    %eax,%edx
  800997:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80099a:	39 c2                	cmp    %eax,%edx
  80099c:	74 17                	je     8009b5 <_main+0x97d>
  80099e:	83 ec 04             	sub    $0x4,%esp
  8009a1:	68 b3 3e 80 00       	push   $0x803eb3
  8009a6:	68 b7 00 00 00       	push   $0xb7
  8009ab:	68 7c 3d 80 00       	push   $0x803d7c
  8009b0:	e8 3e 04 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  8009b5:	ff 45 d0             	incl   -0x30(%ebp)
  8009b8:	83 ec 08             	sub    $0x8,%esp
  8009bb:	ff 75 d0             	pushl  -0x30(%ebp)
  8009be:	68 60 3f 80 00       	push   $0x803f60
  8009c3:	e8 df 06 00 00       	call   8010a7 <cprintf>
  8009c8:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  8009cb:	e8 31 1a 00 00       	call   802401 <sys_calculate_free_frames>
  8009d0:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8009d3:	e8 c9 1a 00 00       	call   8024a1 <sys_pf_calculate_allocated_pages>
  8009d8:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(512*kilo); 			   // Use Hole 2 -> Hole 2 = 1.5 M
  8009db:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8009de:	c1 e0 09             	shl    $0x9,%eax
  8009e1:	83 ec 0c             	sub    $0xc,%esp
  8009e4:	50                   	push   %eax
  8009e5:	e8 e9 15 00 00       	call   801fd3 <malloc>
  8009ea:	83 c4 10             	add    $0x10,%esp
  8009ed:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x80600000)
  8009f0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8009f3:	3d 00 00 60 80       	cmp    $0x80600000,%eax
  8009f8:	74 17                	je     800a11 <_main+0x9d9>
		panic("Worst Fit not working correctly");
  8009fa:	83 ec 04             	sub    $0x4,%esp
  8009fd:	68 40 3f 80 00       	push   $0x803f40
  800a02:	68 be 00 00 00       	push   $0xbe
  800a07:	68 7c 3d 80 00       	push   $0x803d7c
  800a0c:	e8 e2 03 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512*kilo/PAGE_SIZE) panic("Wrong page file allocation: ");
  800a11:	e8 8b 1a 00 00       	call   8024a1 <sys_pf_calculate_allocated_pages>
  800a16:	2b 45 bc             	sub    -0x44(%ebp),%eax
  800a19:	89 c2                	mov    %eax,%edx
  800a1b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800a1e:	c1 e0 09             	shl    $0x9,%eax
  800a21:	85 c0                	test   %eax,%eax
  800a23:	79 05                	jns    800a2a <_main+0x9f2>
  800a25:	05 ff 0f 00 00       	add    $0xfff,%eax
  800a2a:	c1 f8 0c             	sar    $0xc,%eax
  800a2d:	39 c2                	cmp    %eax,%edx
  800a2f:	74 17                	je     800a48 <_main+0xa10>
  800a31:	83 ec 04             	sub    $0x4,%esp
  800a34:	68 96 3e 80 00       	push   $0x803e96
  800a39:	68 bf 00 00 00       	push   $0xbf
  800a3e:	68 7c 3d 80 00       	push   $0x803d7c
  800a43:	e8 ab 03 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800a48:	e8 b4 19 00 00       	call   802401 <sys_calculate_free_frames>
  800a4d:	89 c2                	mov    %eax,%edx
  800a4f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800a52:	39 c2                	cmp    %eax,%edx
  800a54:	74 17                	je     800a6d <_main+0xa35>
  800a56:	83 ec 04             	sub    $0x4,%esp
  800a59:	68 b3 3e 80 00       	push   $0x803eb3
  800a5e:	68 c0 00 00 00       	push   $0xc0
  800a63:	68 7c 3d 80 00       	push   $0x803d7c
  800a68:	e8 86 03 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800a6d:	ff 45 d0             	incl   -0x30(%ebp)
  800a70:	83 ec 08             	sub    $0x8,%esp
  800a73:	ff 75 d0             	pushl  -0x30(%ebp)
  800a76:	68 60 3f 80 00       	push   $0x803f60
  800a7b:	e8 27 06 00 00       	call   8010a7 <cprintf>
  800a80:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  800a83:	e8 79 19 00 00       	call   802401 <sys_calculate_free_frames>
  800a88:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800a8b:	e8 11 1a 00 00       	call   8024a1 <sys_pf_calculate_allocated_pages>
  800a90:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(kilo); 			   // Use Hole 5 -> Hole 5 = 2 M - K
  800a93:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800a96:	83 ec 0c             	sub    $0xc,%esp
  800a99:	50                   	push   %eax
  800a9a:	e8 34 15 00 00       	call   801fd3 <malloc>
  800a9f:	83 c4 10             	add    $0x10,%esp
  800aa2:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x99600000)
  800aa5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800aa8:	3d 00 00 60 99       	cmp    $0x99600000,%eax
  800aad:	74 17                	je     800ac6 <_main+0xa8e>
		panic("Worst Fit not working correctly");
  800aaf:	83 ec 04             	sub    $0x4,%esp
  800ab2:	68 40 3f 80 00       	push   $0x803f40
  800ab7:	68 c7 00 00 00       	push   $0xc7
  800abc:	68 7c 3d 80 00       	push   $0x803d7c
  800ac1:	e8 2d 03 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*kilo/PAGE_SIZE) panic("Wrong page file allocation: ");
  800ac6:	e8 d6 19 00 00       	call   8024a1 <sys_pf_calculate_allocated_pages>
  800acb:	2b 45 bc             	sub    -0x44(%ebp),%eax
  800ace:	89 c2                	mov    %eax,%edx
  800ad0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800ad3:	c1 e0 02             	shl    $0x2,%eax
  800ad6:	85 c0                	test   %eax,%eax
  800ad8:	79 05                	jns    800adf <_main+0xaa7>
  800ada:	05 ff 0f 00 00       	add    $0xfff,%eax
  800adf:	c1 f8 0c             	sar    $0xc,%eax
  800ae2:	39 c2                	cmp    %eax,%edx
  800ae4:	74 17                	je     800afd <_main+0xac5>
  800ae6:	83 ec 04             	sub    $0x4,%esp
  800ae9:	68 96 3e 80 00       	push   $0x803e96
  800aee:	68 c8 00 00 00       	push   $0xc8
  800af3:	68 7c 3d 80 00       	push   $0x803d7c
  800af8:	e8 f6 02 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800afd:	e8 ff 18 00 00       	call   802401 <sys_calculate_free_frames>
  800b02:	89 c2                	mov    %eax,%edx
  800b04:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800b07:	39 c2                	cmp    %eax,%edx
  800b09:	74 17                	je     800b22 <_main+0xaea>
  800b0b:	83 ec 04             	sub    $0x4,%esp
  800b0e:	68 b3 3e 80 00       	push   $0x803eb3
  800b13:	68 c9 00 00 00       	push   $0xc9
  800b18:	68 7c 3d 80 00       	push   $0x803d7c
  800b1d:	e8 d1 02 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800b22:	ff 45 d0             	incl   -0x30(%ebp)
  800b25:	83 ec 08             	sub    $0x8,%esp
  800b28:	ff 75 d0             	pushl  -0x30(%ebp)
  800b2b:	68 60 3f 80 00       	push   $0x803f60
  800b30:	e8 72 05 00 00       	call   8010a7 <cprintf>
  800b35:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  800b38:	e8 c4 18 00 00       	call   802401 <sys_calculate_free_frames>
  800b3d:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800b40:	e8 5c 19 00 00       	call   8024a1 <sys_pf_calculate_allocated_pages>
  800b45:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(2*Mega - 4*kilo); 		// Use Hole 5 -> Hole 5 = 0
  800b48:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800b4b:	01 c0                	add    %eax,%eax
  800b4d:	89 c2                	mov    %eax,%edx
  800b4f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b52:	29 d0                	sub    %edx,%eax
  800b54:	01 c0                	add    %eax,%eax
  800b56:	83 ec 0c             	sub    $0xc,%esp
  800b59:	50                   	push   %eax
  800b5a:	e8 74 14 00 00       	call   801fd3 <malloc>
  800b5f:	83 c4 10             	add    $0x10,%esp
  800b62:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x99601000)
  800b65:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800b68:	3d 00 10 60 99       	cmp    $0x99601000,%eax
  800b6d:	74 17                	je     800b86 <_main+0xb4e>
		panic("Worst Fit not working correctly");
  800b6f:	83 ec 04             	sub    $0x4,%esp
  800b72:	68 40 3f 80 00       	push   $0x803f40
  800b77:	68 d0 00 00 00       	push   $0xd0
  800b7c:	68 7c 3d 80 00       	push   $0x803d7c
  800b81:	e8 6d 02 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  (2*Mega - 4*kilo)/PAGE_SIZE) panic("Wrong page file allocation: ");
  800b86:	e8 16 19 00 00       	call   8024a1 <sys_pf_calculate_allocated_pages>
  800b8b:	2b 45 bc             	sub    -0x44(%ebp),%eax
  800b8e:	89 c2                	mov    %eax,%edx
  800b90:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800b93:	01 c0                	add    %eax,%eax
  800b95:	89 c1                	mov    %eax,%ecx
  800b97:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b9a:	29 c8                	sub    %ecx,%eax
  800b9c:	01 c0                	add    %eax,%eax
  800b9e:	85 c0                	test   %eax,%eax
  800ba0:	79 05                	jns    800ba7 <_main+0xb6f>
  800ba2:	05 ff 0f 00 00       	add    $0xfff,%eax
  800ba7:	c1 f8 0c             	sar    $0xc,%eax
  800baa:	39 c2                	cmp    %eax,%edx
  800bac:	74 17                	je     800bc5 <_main+0xb8d>
  800bae:	83 ec 04             	sub    $0x4,%esp
  800bb1:	68 96 3e 80 00       	push   $0x803e96
  800bb6:	68 d1 00 00 00       	push   $0xd1
  800bbb:	68 7c 3d 80 00       	push   $0x803d7c
  800bc0:	e8 2e 02 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800bc5:	e8 37 18 00 00       	call   802401 <sys_calculate_free_frames>
  800bca:	89 c2                	mov    %eax,%edx
  800bcc:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800bcf:	39 c2                	cmp    %eax,%edx
  800bd1:	74 17                	je     800bea <_main+0xbb2>
  800bd3:	83 ec 04             	sub    $0x4,%esp
  800bd6:	68 b3 3e 80 00       	push   $0x803eb3
  800bdb:	68 d2 00 00 00       	push   $0xd2
  800be0:	68 7c 3d 80 00       	push   $0x803d7c
  800be5:	e8 09 02 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800bea:	ff 45 d0             	incl   -0x30(%ebp)
  800bed:	83 ec 08             	sub    $0x8,%esp
  800bf0:	ff 75 d0             	pushl  -0x30(%ebp)
  800bf3:	68 60 3f 80 00       	push   $0x803f60
  800bf8:	e8 aa 04 00 00       	call   8010a7 <cprintf>
  800bfd:	83 c4 10             	add    $0x10,%esp

	// Check that worst fit returns null in case all holes are not free
	freeFrames = sys_calculate_free_frames() ;
  800c00:	e8 fc 17 00 00       	call   802401 <sys_calculate_free_frames>
  800c05:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800c08:	e8 94 18 00 00       	call   8024a1 <sys_pf_calculate_allocated_pages>
  800c0d:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(4*Mega); 		//No Suitable hole
  800c10:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800c13:	c1 e0 02             	shl    $0x2,%eax
  800c16:	83 ec 0c             	sub    $0xc,%esp
  800c19:	50                   	push   %eax
  800c1a:	e8 b4 13 00 00       	call   801fd3 <malloc>
  800c1f:	83 c4 10             	add    $0x10,%esp
  800c22:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x0)
  800c25:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800c28:	85 c0                	test   %eax,%eax
  800c2a:	74 17                	je     800c43 <_main+0xc0b>
		panic("Worst Fit not working correctly");
  800c2c:	83 ec 04             	sub    $0x4,%esp
  800c2f:	68 40 3f 80 00       	push   $0x803f40
  800c34:	68 da 00 00 00       	push   $0xda
  800c39:	68 7c 3d 80 00       	push   $0x803d7c
  800c3e:	e8 b0 01 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800c43:	e8 59 18 00 00       	call   8024a1 <sys_pf_calculate_allocated_pages>
  800c48:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  800c4b:	74 17                	je     800c64 <_main+0xc2c>
  800c4d:	83 ec 04             	sub    $0x4,%esp
  800c50:	68 96 3e 80 00       	push   $0x803e96
  800c55:	68 db 00 00 00       	push   $0xdb
  800c5a:	68 7c 3d 80 00       	push   $0x803d7c
  800c5f:	e8 8f 01 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800c64:	e8 98 17 00 00       	call   802401 <sys_calculate_free_frames>
  800c69:	89 c2                	mov    %eax,%edx
  800c6b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800c6e:	39 c2                	cmp    %eax,%edx
  800c70:	74 17                	je     800c89 <_main+0xc51>
  800c72:	83 ec 04             	sub    $0x4,%esp
  800c75:	68 b3 3e 80 00       	push   $0x803eb3
  800c7a:	68 dc 00 00 00       	push   $0xdc
  800c7f:	68 7c 3d 80 00       	push   $0x803d7c
  800c84:	e8 6a 01 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800c89:	ff 45 d0             	incl   -0x30(%ebp)
  800c8c:	83 ec 08             	sub    $0x8,%esp
  800c8f:	ff 75 d0             	pushl  -0x30(%ebp)
  800c92:	68 60 3f 80 00       	push   $0x803f60
  800c97:	e8 0b 04 00 00       	call   8010a7 <cprintf>
  800c9c:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! test Worst Fit completed successfully.\n");
  800c9f:	83 ec 0c             	sub    $0xc,%esp
  800ca2:	68 74 3f 80 00       	push   $0x803f74
  800ca7:	e8 fb 03 00 00       	call   8010a7 <cprintf>
  800cac:	83 c4 10             	add    $0x10,%esp

	return;
  800caf:	90                   	nop
}
  800cb0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800cb3:	5b                   	pop    %ebx
  800cb4:	5f                   	pop    %edi
  800cb5:	5d                   	pop    %ebp
  800cb6:	c3                   	ret    

00800cb7 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800cb7:	55                   	push   %ebp
  800cb8:	89 e5                	mov    %esp,%ebp
  800cba:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800cbd:	e8 1f 1a 00 00       	call   8026e1 <sys_getenvindex>
  800cc2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800cc5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cc8:	89 d0                	mov    %edx,%eax
  800cca:	c1 e0 03             	shl    $0x3,%eax
  800ccd:	01 d0                	add    %edx,%eax
  800ccf:	01 c0                	add    %eax,%eax
  800cd1:	01 d0                	add    %edx,%eax
  800cd3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800cda:	01 d0                	add    %edx,%eax
  800cdc:	c1 e0 04             	shl    $0x4,%eax
  800cdf:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800ce4:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800ce9:	a1 20 50 80 00       	mov    0x805020,%eax
  800cee:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800cf4:	84 c0                	test   %al,%al
  800cf6:	74 0f                	je     800d07 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800cf8:	a1 20 50 80 00       	mov    0x805020,%eax
  800cfd:	05 5c 05 00 00       	add    $0x55c,%eax
  800d02:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800d07:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d0b:	7e 0a                	jle    800d17 <libmain+0x60>
		binaryname = argv[0];
  800d0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d10:	8b 00                	mov    (%eax),%eax
  800d12:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800d17:	83 ec 08             	sub    $0x8,%esp
  800d1a:	ff 75 0c             	pushl  0xc(%ebp)
  800d1d:	ff 75 08             	pushl  0x8(%ebp)
  800d20:	e8 13 f3 ff ff       	call   800038 <_main>
  800d25:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800d28:	e8 c1 17 00 00       	call   8024ee <sys_disable_interrupt>
	cprintf("**************************************\n");
  800d2d:	83 ec 0c             	sub    $0xc,%esp
  800d30:	68 c8 3f 80 00       	push   $0x803fc8
  800d35:	e8 6d 03 00 00       	call   8010a7 <cprintf>
  800d3a:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800d3d:	a1 20 50 80 00       	mov    0x805020,%eax
  800d42:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800d48:	a1 20 50 80 00       	mov    0x805020,%eax
  800d4d:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800d53:	83 ec 04             	sub    $0x4,%esp
  800d56:	52                   	push   %edx
  800d57:	50                   	push   %eax
  800d58:	68 f0 3f 80 00       	push   $0x803ff0
  800d5d:	e8 45 03 00 00       	call   8010a7 <cprintf>
  800d62:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800d65:	a1 20 50 80 00       	mov    0x805020,%eax
  800d6a:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800d70:	a1 20 50 80 00       	mov    0x805020,%eax
  800d75:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800d7b:	a1 20 50 80 00       	mov    0x805020,%eax
  800d80:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800d86:	51                   	push   %ecx
  800d87:	52                   	push   %edx
  800d88:	50                   	push   %eax
  800d89:	68 18 40 80 00       	push   $0x804018
  800d8e:	e8 14 03 00 00       	call   8010a7 <cprintf>
  800d93:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800d96:	a1 20 50 80 00       	mov    0x805020,%eax
  800d9b:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800da1:	83 ec 08             	sub    $0x8,%esp
  800da4:	50                   	push   %eax
  800da5:	68 70 40 80 00       	push   $0x804070
  800daa:	e8 f8 02 00 00       	call   8010a7 <cprintf>
  800daf:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800db2:	83 ec 0c             	sub    $0xc,%esp
  800db5:	68 c8 3f 80 00       	push   $0x803fc8
  800dba:	e8 e8 02 00 00       	call   8010a7 <cprintf>
  800dbf:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800dc2:	e8 41 17 00 00       	call   802508 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800dc7:	e8 19 00 00 00       	call   800de5 <exit>
}
  800dcc:	90                   	nop
  800dcd:	c9                   	leave  
  800dce:	c3                   	ret    

00800dcf <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800dcf:	55                   	push   %ebp
  800dd0:	89 e5                	mov    %esp,%ebp
  800dd2:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800dd5:	83 ec 0c             	sub    $0xc,%esp
  800dd8:	6a 00                	push   $0x0
  800dda:	e8 ce 18 00 00       	call   8026ad <sys_destroy_env>
  800ddf:	83 c4 10             	add    $0x10,%esp
}
  800de2:	90                   	nop
  800de3:	c9                   	leave  
  800de4:	c3                   	ret    

00800de5 <exit>:

void
exit(void)
{
  800de5:	55                   	push   %ebp
  800de6:	89 e5                	mov    %esp,%ebp
  800de8:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800deb:	e8 23 19 00 00       	call   802713 <sys_exit_env>
}
  800df0:	90                   	nop
  800df1:	c9                   	leave  
  800df2:	c3                   	ret    

00800df3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800df3:	55                   	push   %ebp
  800df4:	89 e5                	mov    %esp,%ebp
  800df6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800df9:	8d 45 10             	lea    0x10(%ebp),%eax
  800dfc:	83 c0 04             	add    $0x4,%eax
  800dff:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800e02:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800e07:	85 c0                	test   %eax,%eax
  800e09:	74 16                	je     800e21 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800e0b:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800e10:	83 ec 08             	sub    $0x8,%esp
  800e13:	50                   	push   %eax
  800e14:	68 84 40 80 00       	push   $0x804084
  800e19:	e8 89 02 00 00       	call   8010a7 <cprintf>
  800e1e:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800e21:	a1 00 50 80 00       	mov    0x805000,%eax
  800e26:	ff 75 0c             	pushl  0xc(%ebp)
  800e29:	ff 75 08             	pushl  0x8(%ebp)
  800e2c:	50                   	push   %eax
  800e2d:	68 89 40 80 00       	push   $0x804089
  800e32:	e8 70 02 00 00       	call   8010a7 <cprintf>
  800e37:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800e3a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3d:	83 ec 08             	sub    $0x8,%esp
  800e40:	ff 75 f4             	pushl  -0xc(%ebp)
  800e43:	50                   	push   %eax
  800e44:	e8 f3 01 00 00       	call   80103c <vcprintf>
  800e49:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800e4c:	83 ec 08             	sub    $0x8,%esp
  800e4f:	6a 00                	push   $0x0
  800e51:	68 a5 40 80 00       	push   $0x8040a5
  800e56:	e8 e1 01 00 00       	call   80103c <vcprintf>
  800e5b:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800e5e:	e8 82 ff ff ff       	call   800de5 <exit>

	// should not return here
	while (1) ;
  800e63:	eb fe                	jmp    800e63 <_panic+0x70>

00800e65 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800e65:	55                   	push   %ebp
  800e66:	89 e5                	mov    %esp,%ebp
  800e68:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800e6b:	a1 20 50 80 00       	mov    0x805020,%eax
  800e70:	8b 50 74             	mov    0x74(%eax),%edx
  800e73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e76:	39 c2                	cmp    %eax,%edx
  800e78:	74 14                	je     800e8e <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800e7a:	83 ec 04             	sub    $0x4,%esp
  800e7d:	68 a8 40 80 00       	push   $0x8040a8
  800e82:	6a 26                	push   $0x26
  800e84:	68 f4 40 80 00       	push   $0x8040f4
  800e89:	e8 65 ff ff ff       	call   800df3 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800e8e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800e95:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800e9c:	e9 c2 00 00 00       	jmp    800f63 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800ea1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ea4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800eab:	8b 45 08             	mov    0x8(%ebp),%eax
  800eae:	01 d0                	add    %edx,%eax
  800eb0:	8b 00                	mov    (%eax),%eax
  800eb2:	85 c0                	test   %eax,%eax
  800eb4:	75 08                	jne    800ebe <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800eb6:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800eb9:	e9 a2 00 00 00       	jmp    800f60 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800ebe:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800ec5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800ecc:	eb 69                	jmp    800f37 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800ece:	a1 20 50 80 00       	mov    0x805020,%eax
  800ed3:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800ed9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800edc:	89 d0                	mov    %edx,%eax
  800ede:	01 c0                	add    %eax,%eax
  800ee0:	01 d0                	add    %edx,%eax
  800ee2:	c1 e0 03             	shl    $0x3,%eax
  800ee5:	01 c8                	add    %ecx,%eax
  800ee7:	8a 40 04             	mov    0x4(%eax),%al
  800eea:	84 c0                	test   %al,%al
  800eec:	75 46                	jne    800f34 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800eee:	a1 20 50 80 00       	mov    0x805020,%eax
  800ef3:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800ef9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800efc:	89 d0                	mov    %edx,%eax
  800efe:	01 c0                	add    %eax,%eax
  800f00:	01 d0                	add    %edx,%eax
  800f02:	c1 e0 03             	shl    $0x3,%eax
  800f05:	01 c8                	add    %ecx,%eax
  800f07:	8b 00                	mov    (%eax),%eax
  800f09:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800f0c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800f0f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f14:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800f16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f19:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800f20:	8b 45 08             	mov    0x8(%ebp),%eax
  800f23:	01 c8                	add    %ecx,%eax
  800f25:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800f27:	39 c2                	cmp    %eax,%edx
  800f29:	75 09                	jne    800f34 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800f2b:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800f32:	eb 12                	jmp    800f46 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800f34:	ff 45 e8             	incl   -0x18(%ebp)
  800f37:	a1 20 50 80 00       	mov    0x805020,%eax
  800f3c:	8b 50 74             	mov    0x74(%eax),%edx
  800f3f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800f42:	39 c2                	cmp    %eax,%edx
  800f44:	77 88                	ja     800ece <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800f46:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800f4a:	75 14                	jne    800f60 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800f4c:	83 ec 04             	sub    $0x4,%esp
  800f4f:	68 00 41 80 00       	push   $0x804100
  800f54:	6a 3a                	push   $0x3a
  800f56:	68 f4 40 80 00       	push   $0x8040f4
  800f5b:	e8 93 fe ff ff       	call   800df3 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800f60:	ff 45 f0             	incl   -0x10(%ebp)
  800f63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f66:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800f69:	0f 8c 32 ff ff ff    	jl     800ea1 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800f6f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800f76:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800f7d:	eb 26                	jmp    800fa5 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800f7f:	a1 20 50 80 00       	mov    0x805020,%eax
  800f84:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800f8a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800f8d:	89 d0                	mov    %edx,%eax
  800f8f:	01 c0                	add    %eax,%eax
  800f91:	01 d0                	add    %edx,%eax
  800f93:	c1 e0 03             	shl    $0x3,%eax
  800f96:	01 c8                	add    %ecx,%eax
  800f98:	8a 40 04             	mov    0x4(%eax),%al
  800f9b:	3c 01                	cmp    $0x1,%al
  800f9d:	75 03                	jne    800fa2 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800f9f:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800fa2:	ff 45 e0             	incl   -0x20(%ebp)
  800fa5:	a1 20 50 80 00       	mov    0x805020,%eax
  800faa:	8b 50 74             	mov    0x74(%eax),%edx
  800fad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fb0:	39 c2                	cmp    %eax,%edx
  800fb2:	77 cb                	ja     800f7f <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800fb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fb7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800fba:	74 14                	je     800fd0 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800fbc:	83 ec 04             	sub    $0x4,%esp
  800fbf:	68 54 41 80 00       	push   $0x804154
  800fc4:	6a 44                	push   $0x44
  800fc6:	68 f4 40 80 00       	push   $0x8040f4
  800fcb:	e8 23 fe ff ff       	call   800df3 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800fd0:	90                   	nop
  800fd1:	c9                   	leave  
  800fd2:	c3                   	ret    

00800fd3 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800fd3:	55                   	push   %ebp
  800fd4:	89 e5                	mov    %esp,%ebp
  800fd6:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800fd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fdc:	8b 00                	mov    (%eax),%eax
  800fde:	8d 48 01             	lea    0x1(%eax),%ecx
  800fe1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fe4:	89 0a                	mov    %ecx,(%edx)
  800fe6:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe9:	88 d1                	mov    %dl,%cl
  800feb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fee:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800ff2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff5:	8b 00                	mov    (%eax),%eax
  800ff7:	3d ff 00 00 00       	cmp    $0xff,%eax
  800ffc:	75 2c                	jne    80102a <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800ffe:	a0 24 50 80 00       	mov    0x805024,%al
  801003:	0f b6 c0             	movzbl %al,%eax
  801006:	8b 55 0c             	mov    0xc(%ebp),%edx
  801009:	8b 12                	mov    (%edx),%edx
  80100b:	89 d1                	mov    %edx,%ecx
  80100d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801010:	83 c2 08             	add    $0x8,%edx
  801013:	83 ec 04             	sub    $0x4,%esp
  801016:	50                   	push   %eax
  801017:	51                   	push   %ecx
  801018:	52                   	push   %edx
  801019:	e8 22 13 00 00       	call   802340 <sys_cputs>
  80101e:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  801021:	8b 45 0c             	mov    0xc(%ebp),%eax
  801024:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80102a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102d:	8b 40 04             	mov    0x4(%eax),%eax
  801030:	8d 50 01             	lea    0x1(%eax),%edx
  801033:	8b 45 0c             	mov    0xc(%ebp),%eax
  801036:	89 50 04             	mov    %edx,0x4(%eax)
}
  801039:	90                   	nop
  80103a:	c9                   	leave  
  80103b:	c3                   	ret    

0080103c <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80103c:	55                   	push   %ebp
  80103d:	89 e5                	mov    %esp,%ebp
  80103f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801045:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80104c:	00 00 00 
	b.cnt = 0;
  80104f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801056:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  801059:	ff 75 0c             	pushl  0xc(%ebp)
  80105c:	ff 75 08             	pushl  0x8(%ebp)
  80105f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801065:	50                   	push   %eax
  801066:	68 d3 0f 80 00       	push   $0x800fd3
  80106b:	e8 11 02 00 00       	call   801281 <vprintfmt>
  801070:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  801073:	a0 24 50 80 00       	mov    0x805024,%al
  801078:	0f b6 c0             	movzbl %al,%eax
  80107b:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  801081:	83 ec 04             	sub    $0x4,%esp
  801084:	50                   	push   %eax
  801085:	52                   	push   %edx
  801086:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80108c:	83 c0 08             	add    $0x8,%eax
  80108f:	50                   	push   %eax
  801090:	e8 ab 12 00 00       	call   802340 <sys_cputs>
  801095:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  801098:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  80109f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8010a5:	c9                   	leave  
  8010a6:	c3                   	ret    

008010a7 <cprintf>:

int cprintf(const char *fmt, ...) {
  8010a7:	55                   	push   %ebp
  8010a8:	89 e5                	mov    %esp,%ebp
  8010aa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8010ad:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  8010b4:	8d 45 0c             	lea    0xc(%ebp),%eax
  8010b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8010ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bd:	83 ec 08             	sub    $0x8,%esp
  8010c0:	ff 75 f4             	pushl  -0xc(%ebp)
  8010c3:	50                   	push   %eax
  8010c4:	e8 73 ff ff ff       	call   80103c <vcprintf>
  8010c9:	83 c4 10             	add    $0x10,%esp
  8010cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8010cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010d2:	c9                   	leave  
  8010d3:	c3                   	ret    

008010d4 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8010d4:	55                   	push   %ebp
  8010d5:	89 e5                	mov    %esp,%ebp
  8010d7:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8010da:	e8 0f 14 00 00       	call   8024ee <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8010df:	8d 45 0c             	lea    0xc(%ebp),%eax
  8010e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8010e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e8:	83 ec 08             	sub    $0x8,%esp
  8010eb:	ff 75 f4             	pushl  -0xc(%ebp)
  8010ee:	50                   	push   %eax
  8010ef:	e8 48 ff ff ff       	call   80103c <vcprintf>
  8010f4:	83 c4 10             	add    $0x10,%esp
  8010f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8010fa:	e8 09 14 00 00       	call   802508 <sys_enable_interrupt>
	return cnt;
  8010ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801102:	c9                   	leave  
  801103:	c3                   	ret    

00801104 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801104:	55                   	push   %ebp
  801105:	89 e5                	mov    %esp,%ebp
  801107:	53                   	push   %ebx
  801108:	83 ec 14             	sub    $0x14,%esp
  80110b:	8b 45 10             	mov    0x10(%ebp),%eax
  80110e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801111:	8b 45 14             	mov    0x14(%ebp),%eax
  801114:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801117:	8b 45 18             	mov    0x18(%ebp),%eax
  80111a:	ba 00 00 00 00       	mov    $0x0,%edx
  80111f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801122:	77 55                	ja     801179 <printnum+0x75>
  801124:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801127:	72 05                	jb     80112e <printnum+0x2a>
  801129:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80112c:	77 4b                	ja     801179 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80112e:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801131:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801134:	8b 45 18             	mov    0x18(%ebp),%eax
  801137:	ba 00 00 00 00       	mov    $0x0,%edx
  80113c:	52                   	push   %edx
  80113d:	50                   	push   %eax
  80113e:	ff 75 f4             	pushl  -0xc(%ebp)
  801141:	ff 75 f0             	pushl  -0x10(%ebp)
  801144:	e8 b3 29 00 00       	call   803afc <__udivdi3>
  801149:	83 c4 10             	add    $0x10,%esp
  80114c:	83 ec 04             	sub    $0x4,%esp
  80114f:	ff 75 20             	pushl  0x20(%ebp)
  801152:	53                   	push   %ebx
  801153:	ff 75 18             	pushl  0x18(%ebp)
  801156:	52                   	push   %edx
  801157:	50                   	push   %eax
  801158:	ff 75 0c             	pushl  0xc(%ebp)
  80115b:	ff 75 08             	pushl  0x8(%ebp)
  80115e:	e8 a1 ff ff ff       	call   801104 <printnum>
  801163:	83 c4 20             	add    $0x20,%esp
  801166:	eb 1a                	jmp    801182 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801168:	83 ec 08             	sub    $0x8,%esp
  80116b:	ff 75 0c             	pushl  0xc(%ebp)
  80116e:	ff 75 20             	pushl  0x20(%ebp)
  801171:	8b 45 08             	mov    0x8(%ebp),%eax
  801174:	ff d0                	call   *%eax
  801176:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801179:	ff 4d 1c             	decl   0x1c(%ebp)
  80117c:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801180:	7f e6                	jg     801168 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801182:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801185:	bb 00 00 00 00       	mov    $0x0,%ebx
  80118a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80118d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801190:	53                   	push   %ebx
  801191:	51                   	push   %ecx
  801192:	52                   	push   %edx
  801193:	50                   	push   %eax
  801194:	e8 73 2a 00 00       	call   803c0c <__umoddi3>
  801199:	83 c4 10             	add    $0x10,%esp
  80119c:	05 b4 43 80 00       	add    $0x8043b4,%eax
  8011a1:	8a 00                	mov    (%eax),%al
  8011a3:	0f be c0             	movsbl %al,%eax
  8011a6:	83 ec 08             	sub    $0x8,%esp
  8011a9:	ff 75 0c             	pushl  0xc(%ebp)
  8011ac:	50                   	push   %eax
  8011ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b0:	ff d0                	call   *%eax
  8011b2:	83 c4 10             	add    $0x10,%esp
}
  8011b5:	90                   	nop
  8011b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011b9:	c9                   	leave  
  8011ba:	c3                   	ret    

008011bb <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8011bb:	55                   	push   %ebp
  8011bc:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8011be:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8011c2:	7e 1c                	jle    8011e0 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8011c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c7:	8b 00                	mov    (%eax),%eax
  8011c9:	8d 50 08             	lea    0x8(%eax),%edx
  8011cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cf:	89 10                	mov    %edx,(%eax)
  8011d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d4:	8b 00                	mov    (%eax),%eax
  8011d6:	83 e8 08             	sub    $0x8,%eax
  8011d9:	8b 50 04             	mov    0x4(%eax),%edx
  8011dc:	8b 00                	mov    (%eax),%eax
  8011de:	eb 40                	jmp    801220 <getuint+0x65>
	else if (lflag)
  8011e0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011e4:	74 1e                	je     801204 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8011e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e9:	8b 00                	mov    (%eax),%eax
  8011eb:	8d 50 04             	lea    0x4(%eax),%edx
  8011ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f1:	89 10                	mov    %edx,(%eax)
  8011f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f6:	8b 00                	mov    (%eax),%eax
  8011f8:	83 e8 04             	sub    $0x4,%eax
  8011fb:	8b 00                	mov    (%eax),%eax
  8011fd:	ba 00 00 00 00       	mov    $0x0,%edx
  801202:	eb 1c                	jmp    801220 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801204:	8b 45 08             	mov    0x8(%ebp),%eax
  801207:	8b 00                	mov    (%eax),%eax
  801209:	8d 50 04             	lea    0x4(%eax),%edx
  80120c:	8b 45 08             	mov    0x8(%ebp),%eax
  80120f:	89 10                	mov    %edx,(%eax)
  801211:	8b 45 08             	mov    0x8(%ebp),%eax
  801214:	8b 00                	mov    (%eax),%eax
  801216:	83 e8 04             	sub    $0x4,%eax
  801219:	8b 00                	mov    (%eax),%eax
  80121b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801220:	5d                   	pop    %ebp
  801221:	c3                   	ret    

00801222 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801222:	55                   	push   %ebp
  801223:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801225:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801229:	7e 1c                	jle    801247 <getint+0x25>
		return va_arg(*ap, long long);
  80122b:	8b 45 08             	mov    0x8(%ebp),%eax
  80122e:	8b 00                	mov    (%eax),%eax
  801230:	8d 50 08             	lea    0x8(%eax),%edx
  801233:	8b 45 08             	mov    0x8(%ebp),%eax
  801236:	89 10                	mov    %edx,(%eax)
  801238:	8b 45 08             	mov    0x8(%ebp),%eax
  80123b:	8b 00                	mov    (%eax),%eax
  80123d:	83 e8 08             	sub    $0x8,%eax
  801240:	8b 50 04             	mov    0x4(%eax),%edx
  801243:	8b 00                	mov    (%eax),%eax
  801245:	eb 38                	jmp    80127f <getint+0x5d>
	else if (lflag)
  801247:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80124b:	74 1a                	je     801267 <getint+0x45>
		return va_arg(*ap, long);
  80124d:	8b 45 08             	mov    0x8(%ebp),%eax
  801250:	8b 00                	mov    (%eax),%eax
  801252:	8d 50 04             	lea    0x4(%eax),%edx
  801255:	8b 45 08             	mov    0x8(%ebp),%eax
  801258:	89 10                	mov    %edx,(%eax)
  80125a:	8b 45 08             	mov    0x8(%ebp),%eax
  80125d:	8b 00                	mov    (%eax),%eax
  80125f:	83 e8 04             	sub    $0x4,%eax
  801262:	8b 00                	mov    (%eax),%eax
  801264:	99                   	cltd   
  801265:	eb 18                	jmp    80127f <getint+0x5d>
	else
		return va_arg(*ap, int);
  801267:	8b 45 08             	mov    0x8(%ebp),%eax
  80126a:	8b 00                	mov    (%eax),%eax
  80126c:	8d 50 04             	lea    0x4(%eax),%edx
  80126f:	8b 45 08             	mov    0x8(%ebp),%eax
  801272:	89 10                	mov    %edx,(%eax)
  801274:	8b 45 08             	mov    0x8(%ebp),%eax
  801277:	8b 00                	mov    (%eax),%eax
  801279:	83 e8 04             	sub    $0x4,%eax
  80127c:	8b 00                	mov    (%eax),%eax
  80127e:	99                   	cltd   
}
  80127f:	5d                   	pop    %ebp
  801280:	c3                   	ret    

00801281 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801281:	55                   	push   %ebp
  801282:	89 e5                	mov    %esp,%ebp
  801284:	56                   	push   %esi
  801285:	53                   	push   %ebx
  801286:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801289:	eb 17                	jmp    8012a2 <vprintfmt+0x21>
			if (ch == '\0')
  80128b:	85 db                	test   %ebx,%ebx
  80128d:	0f 84 af 03 00 00    	je     801642 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  801293:	83 ec 08             	sub    $0x8,%esp
  801296:	ff 75 0c             	pushl  0xc(%ebp)
  801299:	53                   	push   %ebx
  80129a:	8b 45 08             	mov    0x8(%ebp),%eax
  80129d:	ff d0                	call   *%eax
  80129f:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8012a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a5:	8d 50 01             	lea    0x1(%eax),%edx
  8012a8:	89 55 10             	mov    %edx,0x10(%ebp)
  8012ab:	8a 00                	mov    (%eax),%al
  8012ad:	0f b6 d8             	movzbl %al,%ebx
  8012b0:	83 fb 25             	cmp    $0x25,%ebx
  8012b3:	75 d6                	jne    80128b <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8012b5:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8012b9:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8012c0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8012c7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8012ce:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8012d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d8:	8d 50 01             	lea    0x1(%eax),%edx
  8012db:	89 55 10             	mov    %edx,0x10(%ebp)
  8012de:	8a 00                	mov    (%eax),%al
  8012e0:	0f b6 d8             	movzbl %al,%ebx
  8012e3:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8012e6:	83 f8 55             	cmp    $0x55,%eax
  8012e9:	0f 87 2b 03 00 00    	ja     80161a <vprintfmt+0x399>
  8012ef:	8b 04 85 d8 43 80 00 	mov    0x8043d8(,%eax,4),%eax
  8012f6:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8012f8:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8012fc:	eb d7                	jmp    8012d5 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8012fe:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801302:	eb d1                	jmp    8012d5 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801304:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80130b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80130e:	89 d0                	mov    %edx,%eax
  801310:	c1 e0 02             	shl    $0x2,%eax
  801313:	01 d0                	add    %edx,%eax
  801315:	01 c0                	add    %eax,%eax
  801317:	01 d8                	add    %ebx,%eax
  801319:	83 e8 30             	sub    $0x30,%eax
  80131c:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80131f:	8b 45 10             	mov    0x10(%ebp),%eax
  801322:	8a 00                	mov    (%eax),%al
  801324:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801327:	83 fb 2f             	cmp    $0x2f,%ebx
  80132a:	7e 3e                	jle    80136a <vprintfmt+0xe9>
  80132c:	83 fb 39             	cmp    $0x39,%ebx
  80132f:	7f 39                	jg     80136a <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801331:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801334:	eb d5                	jmp    80130b <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801336:	8b 45 14             	mov    0x14(%ebp),%eax
  801339:	83 c0 04             	add    $0x4,%eax
  80133c:	89 45 14             	mov    %eax,0x14(%ebp)
  80133f:	8b 45 14             	mov    0x14(%ebp),%eax
  801342:	83 e8 04             	sub    $0x4,%eax
  801345:	8b 00                	mov    (%eax),%eax
  801347:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80134a:	eb 1f                	jmp    80136b <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80134c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801350:	79 83                	jns    8012d5 <vprintfmt+0x54>
				width = 0;
  801352:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801359:	e9 77 ff ff ff       	jmp    8012d5 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80135e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801365:	e9 6b ff ff ff       	jmp    8012d5 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80136a:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80136b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80136f:	0f 89 60 ff ff ff    	jns    8012d5 <vprintfmt+0x54>
				width = precision, precision = -1;
  801375:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801378:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80137b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801382:	e9 4e ff ff ff       	jmp    8012d5 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801387:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80138a:	e9 46 ff ff ff       	jmp    8012d5 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80138f:	8b 45 14             	mov    0x14(%ebp),%eax
  801392:	83 c0 04             	add    $0x4,%eax
  801395:	89 45 14             	mov    %eax,0x14(%ebp)
  801398:	8b 45 14             	mov    0x14(%ebp),%eax
  80139b:	83 e8 04             	sub    $0x4,%eax
  80139e:	8b 00                	mov    (%eax),%eax
  8013a0:	83 ec 08             	sub    $0x8,%esp
  8013a3:	ff 75 0c             	pushl  0xc(%ebp)
  8013a6:	50                   	push   %eax
  8013a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013aa:	ff d0                	call   *%eax
  8013ac:	83 c4 10             	add    $0x10,%esp
			break;
  8013af:	e9 89 02 00 00       	jmp    80163d <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8013b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8013b7:	83 c0 04             	add    $0x4,%eax
  8013ba:	89 45 14             	mov    %eax,0x14(%ebp)
  8013bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8013c0:	83 e8 04             	sub    $0x4,%eax
  8013c3:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8013c5:	85 db                	test   %ebx,%ebx
  8013c7:	79 02                	jns    8013cb <vprintfmt+0x14a>
				err = -err;
  8013c9:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8013cb:	83 fb 64             	cmp    $0x64,%ebx
  8013ce:	7f 0b                	jg     8013db <vprintfmt+0x15a>
  8013d0:	8b 34 9d 20 42 80 00 	mov    0x804220(,%ebx,4),%esi
  8013d7:	85 f6                	test   %esi,%esi
  8013d9:	75 19                	jne    8013f4 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8013db:	53                   	push   %ebx
  8013dc:	68 c5 43 80 00       	push   $0x8043c5
  8013e1:	ff 75 0c             	pushl  0xc(%ebp)
  8013e4:	ff 75 08             	pushl  0x8(%ebp)
  8013e7:	e8 5e 02 00 00       	call   80164a <printfmt>
  8013ec:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8013ef:	e9 49 02 00 00       	jmp    80163d <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8013f4:	56                   	push   %esi
  8013f5:	68 ce 43 80 00       	push   $0x8043ce
  8013fa:	ff 75 0c             	pushl  0xc(%ebp)
  8013fd:	ff 75 08             	pushl  0x8(%ebp)
  801400:	e8 45 02 00 00       	call   80164a <printfmt>
  801405:	83 c4 10             	add    $0x10,%esp
			break;
  801408:	e9 30 02 00 00       	jmp    80163d <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80140d:	8b 45 14             	mov    0x14(%ebp),%eax
  801410:	83 c0 04             	add    $0x4,%eax
  801413:	89 45 14             	mov    %eax,0x14(%ebp)
  801416:	8b 45 14             	mov    0x14(%ebp),%eax
  801419:	83 e8 04             	sub    $0x4,%eax
  80141c:	8b 30                	mov    (%eax),%esi
  80141e:	85 f6                	test   %esi,%esi
  801420:	75 05                	jne    801427 <vprintfmt+0x1a6>
				p = "(null)";
  801422:	be d1 43 80 00       	mov    $0x8043d1,%esi
			if (width > 0 && padc != '-')
  801427:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80142b:	7e 6d                	jle    80149a <vprintfmt+0x219>
  80142d:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801431:	74 67                	je     80149a <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801433:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801436:	83 ec 08             	sub    $0x8,%esp
  801439:	50                   	push   %eax
  80143a:	56                   	push   %esi
  80143b:	e8 0c 03 00 00       	call   80174c <strnlen>
  801440:	83 c4 10             	add    $0x10,%esp
  801443:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801446:	eb 16                	jmp    80145e <vprintfmt+0x1dd>
					putch(padc, putdat);
  801448:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80144c:	83 ec 08             	sub    $0x8,%esp
  80144f:	ff 75 0c             	pushl  0xc(%ebp)
  801452:	50                   	push   %eax
  801453:	8b 45 08             	mov    0x8(%ebp),%eax
  801456:	ff d0                	call   *%eax
  801458:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80145b:	ff 4d e4             	decl   -0x1c(%ebp)
  80145e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801462:	7f e4                	jg     801448 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801464:	eb 34                	jmp    80149a <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801466:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80146a:	74 1c                	je     801488 <vprintfmt+0x207>
  80146c:	83 fb 1f             	cmp    $0x1f,%ebx
  80146f:	7e 05                	jle    801476 <vprintfmt+0x1f5>
  801471:	83 fb 7e             	cmp    $0x7e,%ebx
  801474:	7e 12                	jle    801488 <vprintfmt+0x207>
					putch('?', putdat);
  801476:	83 ec 08             	sub    $0x8,%esp
  801479:	ff 75 0c             	pushl  0xc(%ebp)
  80147c:	6a 3f                	push   $0x3f
  80147e:	8b 45 08             	mov    0x8(%ebp),%eax
  801481:	ff d0                	call   *%eax
  801483:	83 c4 10             	add    $0x10,%esp
  801486:	eb 0f                	jmp    801497 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801488:	83 ec 08             	sub    $0x8,%esp
  80148b:	ff 75 0c             	pushl  0xc(%ebp)
  80148e:	53                   	push   %ebx
  80148f:	8b 45 08             	mov    0x8(%ebp),%eax
  801492:	ff d0                	call   *%eax
  801494:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801497:	ff 4d e4             	decl   -0x1c(%ebp)
  80149a:	89 f0                	mov    %esi,%eax
  80149c:	8d 70 01             	lea    0x1(%eax),%esi
  80149f:	8a 00                	mov    (%eax),%al
  8014a1:	0f be d8             	movsbl %al,%ebx
  8014a4:	85 db                	test   %ebx,%ebx
  8014a6:	74 24                	je     8014cc <vprintfmt+0x24b>
  8014a8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8014ac:	78 b8                	js     801466 <vprintfmt+0x1e5>
  8014ae:	ff 4d e0             	decl   -0x20(%ebp)
  8014b1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8014b5:	79 af                	jns    801466 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8014b7:	eb 13                	jmp    8014cc <vprintfmt+0x24b>
				putch(' ', putdat);
  8014b9:	83 ec 08             	sub    $0x8,%esp
  8014bc:	ff 75 0c             	pushl  0xc(%ebp)
  8014bf:	6a 20                	push   $0x20
  8014c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c4:	ff d0                	call   *%eax
  8014c6:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8014c9:	ff 4d e4             	decl   -0x1c(%ebp)
  8014cc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8014d0:	7f e7                	jg     8014b9 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8014d2:	e9 66 01 00 00       	jmp    80163d <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8014d7:	83 ec 08             	sub    $0x8,%esp
  8014da:	ff 75 e8             	pushl  -0x18(%ebp)
  8014dd:	8d 45 14             	lea    0x14(%ebp),%eax
  8014e0:	50                   	push   %eax
  8014e1:	e8 3c fd ff ff       	call   801222 <getint>
  8014e6:	83 c4 10             	add    $0x10,%esp
  8014e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014ec:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8014ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014f5:	85 d2                	test   %edx,%edx
  8014f7:	79 23                	jns    80151c <vprintfmt+0x29b>
				putch('-', putdat);
  8014f9:	83 ec 08             	sub    $0x8,%esp
  8014fc:	ff 75 0c             	pushl  0xc(%ebp)
  8014ff:	6a 2d                	push   $0x2d
  801501:	8b 45 08             	mov    0x8(%ebp),%eax
  801504:	ff d0                	call   *%eax
  801506:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801509:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80150c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80150f:	f7 d8                	neg    %eax
  801511:	83 d2 00             	adc    $0x0,%edx
  801514:	f7 da                	neg    %edx
  801516:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801519:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80151c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801523:	e9 bc 00 00 00       	jmp    8015e4 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801528:	83 ec 08             	sub    $0x8,%esp
  80152b:	ff 75 e8             	pushl  -0x18(%ebp)
  80152e:	8d 45 14             	lea    0x14(%ebp),%eax
  801531:	50                   	push   %eax
  801532:	e8 84 fc ff ff       	call   8011bb <getuint>
  801537:	83 c4 10             	add    $0x10,%esp
  80153a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80153d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801540:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801547:	e9 98 00 00 00       	jmp    8015e4 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80154c:	83 ec 08             	sub    $0x8,%esp
  80154f:	ff 75 0c             	pushl  0xc(%ebp)
  801552:	6a 58                	push   $0x58
  801554:	8b 45 08             	mov    0x8(%ebp),%eax
  801557:	ff d0                	call   *%eax
  801559:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80155c:	83 ec 08             	sub    $0x8,%esp
  80155f:	ff 75 0c             	pushl  0xc(%ebp)
  801562:	6a 58                	push   $0x58
  801564:	8b 45 08             	mov    0x8(%ebp),%eax
  801567:	ff d0                	call   *%eax
  801569:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80156c:	83 ec 08             	sub    $0x8,%esp
  80156f:	ff 75 0c             	pushl  0xc(%ebp)
  801572:	6a 58                	push   $0x58
  801574:	8b 45 08             	mov    0x8(%ebp),%eax
  801577:	ff d0                	call   *%eax
  801579:	83 c4 10             	add    $0x10,%esp
			break;
  80157c:	e9 bc 00 00 00       	jmp    80163d <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801581:	83 ec 08             	sub    $0x8,%esp
  801584:	ff 75 0c             	pushl  0xc(%ebp)
  801587:	6a 30                	push   $0x30
  801589:	8b 45 08             	mov    0x8(%ebp),%eax
  80158c:	ff d0                	call   *%eax
  80158e:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801591:	83 ec 08             	sub    $0x8,%esp
  801594:	ff 75 0c             	pushl  0xc(%ebp)
  801597:	6a 78                	push   $0x78
  801599:	8b 45 08             	mov    0x8(%ebp),%eax
  80159c:	ff d0                	call   *%eax
  80159e:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8015a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8015a4:	83 c0 04             	add    $0x4,%eax
  8015a7:	89 45 14             	mov    %eax,0x14(%ebp)
  8015aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8015ad:	83 e8 04             	sub    $0x4,%eax
  8015b0:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8015b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8015bc:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8015c3:	eb 1f                	jmp    8015e4 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8015c5:	83 ec 08             	sub    $0x8,%esp
  8015c8:	ff 75 e8             	pushl  -0x18(%ebp)
  8015cb:	8d 45 14             	lea    0x14(%ebp),%eax
  8015ce:	50                   	push   %eax
  8015cf:	e8 e7 fb ff ff       	call   8011bb <getuint>
  8015d4:	83 c4 10             	add    $0x10,%esp
  8015d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015da:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8015dd:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8015e4:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8015e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015eb:	83 ec 04             	sub    $0x4,%esp
  8015ee:	52                   	push   %edx
  8015ef:	ff 75 e4             	pushl  -0x1c(%ebp)
  8015f2:	50                   	push   %eax
  8015f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8015f6:	ff 75 f0             	pushl  -0x10(%ebp)
  8015f9:	ff 75 0c             	pushl  0xc(%ebp)
  8015fc:	ff 75 08             	pushl  0x8(%ebp)
  8015ff:	e8 00 fb ff ff       	call   801104 <printnum>
  801604:	83 c4 20             	add    $0x20,%esp
			break;
  801607:	eb 34                	jmp    80163d <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801609:	83 ec 08             	sub    $0x8,%esp
  80160c:	ff 75 0c             	pushl  0xc(%ebp)
  80160f:	53                   	push   %ebx
  801610:	8b 45 08             	mov    0x8(%ebp),%eax
  801613:	ff d0                	call   *%eax
  801615:	83 c4 10             	add    $0x10,%esp
			break;
  801618:	eb 23                	jmp    80163d <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80161a:	83 ec 08             	sub    $0x8,%esp
  80161d:	ff 75 0c             	pushl  0xc(%ebp)
  801620:	6a 25                	push   $0x25
  801622:	8b 45 08             	mov    0x8(%ebp),%eax
  801625:	ff d0                	call   *%eax
  801627:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80162a:	ff 4d 10             	decl   0x10(%ebp)
  80162d:	eb 03                	jmp    801632 <vprintfmt+0x3b1>
  80162f:	ff 4d 10             	decl   0x10(%ebp)
  801632:	8b 45 10             	mov    0x10(%ebp),%eax
  801635:	48                   	dec    %eax
  801636:	8a 00                	mov    (%eax),%al
  801638:	3c 25                	cmp    $0x25,%al
  80163a:	75 f3                	jne    80162f <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80163c:	90                   	nop
		}
	}
  80163d:	e9 47 fc ff ff       	jmp    801289 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801642:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801643:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801646:	5b                   	pop    %ebx
  801647:	5e                   	pop    %esi
  801648:	5d                   	pop    %ebp
  801649:	c3                   	ret    

0080164a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80164a:	55                   	push   %ebp
  80164b:	89 e5                	mov    %esp,%ebp
  80164d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801650:	8d 45 10             	lea    0x10(%ebp),%eax
  801653:	83 c0 04             	add    $0x4,%eax
  801656:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801659:	8b 45 10             	mov    0x10(%ebp),%eax
  80165c:	ff 75 f4             	pushl  -0xc(%ebp)
  80165f:	50                   	push   %eax
  801660:	ff 75 0c             	pushl  0xc(%ebp)
  801663:	ff 75 08             	pushl  0x8(%ebp)
  801666:	e8 16 fc ff ff       	call   801281 <vprintfmt>
  80166b:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80166e:	90                   	nop
  80166f:	c9                   	leave  
  801670:	c3                   	ret    

00801671 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801671:	55                   	push   %ebp
  801672:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801674:	8b 45 0c             	mov    0xc(%ebp),%eax
  801677:	8b 40 08             	mov    0x8(%eax),%eax
  80167a:	8d 50 01             	lea    0x1(%eax),%edx
  80167d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801680:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801683:	8b 45 0c             	mov    0xc(%ebp),%eax
  801686:	8b 10                	mov    (%eax),%edx
  801688:	8b 45 0c             	mov    0xc(%ebp),%eax
  80168b:	8b 40 04             	mov    0x4(%eax),%eax
  80168e:	39 c2                	cmp    %eax,%edx
  801690:	73 12                	jae    8016a4 <sprintputch+0x33>
		*b->buf++ = ch;
  801692:	8b 45 0c             	mov    0xc(%ebp),%eax
  801695:	8b 00                	mov    (%eax),%eax
  801697:	8d 48 01             	lea    0x1(%eax),%ecx
  80169a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80169d:	89 0a                	mov    %ecx,(%edx)
  80169f:	8b 55 08             	mov    0x8(%ebp),%edx
  8016a2:	88 10                	mov    %dl,(%eax)
}
  8016a4:	90                   	nop
  8016a5:	5d                   	pop    %ebp
  8016a6:	c3                   	ret    

008016a7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8016a7:	55                   	push   %ebp
  8016a8:	89 e5                	mov    %esp,%ebp
  8016aa:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8016ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8016b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bc:	01 d0                	add    %edx,%eax
  8016be:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8016c8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016cc:	74 06                	je     8016d4 <vsnprintf+0x2d>
  8016ce:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016d2:	7f 07                	jg     8016db <vsnprintf+0x34>
		return -E_INVAL;
  8016d4:	b8 03 00 00 00       	mov    $0x3,%eax
  8016d9:	eb 20                	jmp    8016fb <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8016db:	ff 75 14             	pushl  0x14(%ebp)
  8016de:	ff 75 10             	pushl  0x10(%ebp)
  8016e1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8016e4:	50                   	push   %eax
  8016e5:	68 71 16 80 00       	push   $0x801671
  8016ea:	e8 92 fb ff ff       	call   801281 <vprintfmt>
  8016ef:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8016f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016f5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8016f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8016fb:	c9                   	leave  
  8016fc:	c3                   	ret    

008016fd <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8016fd:	55                   	push   %ebp
  8016fe:	89 e5                	mov    %esp,%ebp
  801700:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801703:	8d 45 10             	lea    0x10(%ebp),%eax
  801706:	83 c0 04             	add    $0x4,%eax
  801709:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80170c:	8b 45 10             	mov    0x10(%ebp),%eax
  80170f:	ff 75 f4             	pushl  -0xc(%ebp)
  801712:	50                   	push   %eax
  801713:	ff 75 0c             	pushl  0xc(%ebp)
  801716:	ff 75 08             	pushl  0x8(%ebp)
  801719:	e8 89 ff ff ff       	call   8016a7 <vsnprintf>
  80171e:	83 c4 10             	add    $0x10,%esp
  801721:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801724:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801727:	c9                   	leave  
  801728:	c3                   	ret    

00801729 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801729:	55                   	push   %ebp
  80172a:	89 e5                	mov    %esp,%ebp
  80172c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80172f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801736:	eb 06                	jmp    80173e <strlen+0x15>
		n++;
  801738:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80173b:	ff 45 08             	incl   0x8(%ebp)
  80173e:	8b 45 08             	mov    0x8(%ebp),%eax
  801741:	8a 00                	mov    (%eax),%al
  801743:	84 c0                	test   %al,%al
  801745:	75 f1                	jne    801738 <strlen+0xf>
		n++;
	return n;
  801747:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80174a:	c9                   	leave  
  80174b:	c3                   	ret    

0080174c <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80174c:	55                   	push   %ebp
  80174d:	89 e5                	mov    %esp,%ebp
  80174f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801752:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801759:	eb 09                	jmp    801764 <strnlen+0x18>
		n++;
  80175b:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80175e:	ff 45 08             	incl   0x8(%ebp)
  801761:	ff 4d 0c             	decl   0xc(%ebp)
  801764:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801768:	74 09                	je     801773 <strnlen+0x27>
  80176a:	8b 45 08             	mov    0x8(%ebp),%eax
  80176d:	8a 00                	mov    (%eax),%al
  80176f:	84 c0                	test   %al,%al
  801771:	75 e8                	jne    80175b <strnlen+0xf>
		n++;
	return n;
  801773:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801776:	c9                   	leave  
  801777:	c3                   	ret    

00801778 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801778:	55                   	push   %ebp
  801779:	89 e5                	mov    %esp,%ebp
  80177b:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80177e:	8b 45 08             	mov    0x8(%ebp),%eax
  801781:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801784:	90                   	nop
  801785:	8b 45 08             	mov    0x8(%ebp),%eax
  801788:	8d 50 01             	lea    0x1(%eax),%edx
  80178b:	89 55 08             	mov    %edx,0x8(%ebp)
  80178e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801791:	8d 4a 01             	lea    0x1(%edx),%ecx
  801794:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801797:	8a 12                	mov    (%edx),%dl
  801799:	88 10                	mov    %dl,(%eax)
  80179b:	8a 00                	mov    (%eax),%al
  80179d:	84 c0                	test   %al,%al
  80179f:	75 e4                	jne    801785 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8017a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8017a4:	c9                   	leave  
  8017a5:	c3                   	ret    

008017a6 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8017a6:	55                   	push   %ebp
  8017a7:	89 e5                	mov    %esp,%ebp
  8017a9:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8017ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8017af:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8017b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8017b9:	eb 1f                	jmp    8017da <strncpy+0x34>
		*dst++ = *src;
  8017bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017be:	8d 50 01             	lea    0x1(%eax),%edx
  8017c1:	89 55 08             	mov    %edx,0x8(%ebp)
  8017c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017c7:	8a 12                	mov    (%edx),%dl
  8017c9:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8017cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ce:	8a 00                	mov    (%eax),%al
  8017d0:	84 c0                	test   %al,%al
  8017d2:	74 03                	je     8017d7 <strncpy+0x31>
			src++;
  8017d4:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8017d7:	ff 45 fc             	incl   -0x4(%ebp)
  8017da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017dd:	3b 45 10             	cmp    0x10(%ebp),%eax
  8017e0:	72 d9                	jb     8017bb <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8017e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8017e5:	c9                   	leave  
  8017e6:	c3                   	ret    

008017e7 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8017e7:	55                   	push   %ebp
  8017e8:	89 e5                	mov    %esp,%ebp
  8017ea:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8017ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8017f3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017f7:	74 30                	je     801829 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8017f9:	eb 16                	jmp    801811 <strlcpy+0x2a>
			*dst++ = *src++;
  8017fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fe:	8d 50 01             	lea    0x1(%eax),%edx
  801801:	89 55 08             	mov    %edx,0x8(%ebp)
  801804:	8b 55 0c             	mov    0xc(%ebp),%edx
  801807:	8d 4a 01             	lea    0x1(%edx),%ecx
  80180a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80180d:	8a 12                	mov    (%edx),%dl
  80180f:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801811:	ff 4d 10             	decl   0x10(%ebp)
  801814:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801818:	74 09                	je     801823 <strlcpy+0x3c>
  80181a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80181d:	8a 00                	mov    (%eax),%al
  80181f:	84 c0                	test   %al,%al
  801821:	75 d8                	jne    8017fb <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801823:	8b 45 08             	mov    0x8(%ebp),%eax
  801826:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801829:	8b 55 08             	mov    0x8(%ebp),%edx
  80182c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80182f:	29 c2                	sub    %eax,%edx
  801831:	89 d0                	mov    %edx,%eax
}
  801833:	c9                   	leave  
  801834:	c3                   	ret    

00801835 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801835:	55                   	push   %ebp
  801836:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801838:	eb 06                	jmp    801840 <strcmp+0xb>
		p++, q++;
  80183a:	ff 45 08             	incl   0x8(%ebp)
  80183d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801840:	8b 45 08             	mov    0x8(%ebp),%eax
  801843:	8a 00                	mov    (%eax),%al
  801845:	84 c0                	test   %al,%al
  801847:	74 0e                	je     801857 <strcmp+0x22>
  801849:	8b 45 08             	mov    0x8(%ebp),%eax
  80184c:	8a 10                	mov    (%eax),%dl
  80184e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801851:	8a 00                	mov    (%eax),%al
  801853:	38 c2                	cmp    %al,%dl
  801855:	74 e3                	je     80183a <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801857:	8b 45 08             	mov    0x8(%ebp),%eax
  80185a:	8a 00                	mov    (%eax),%al
  80185c:	0f b6 d0             	movzbl %al,%edx
  80185f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801862:	8a 00                	mov    (%eax),%al
  801864:	0f b6 c0             	movzbl %al,%eax
  801867:	29 c2                	sub    %eax,%edx
  801869:	89 d0                	mov    %edx,%eax
}
  80186b:	5d                   	pop    %ebp
  80186c:	c3                   	ret    

0080186d <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80186d:	55                   	push   %ebp
  80186e:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801870:	eb 09                	jmp    80187b <strncmp+0xe>
		n--, p++, q++;
  801872:	ff 4d 10             	decl   0x10(%ebp)
  801875:	ff 45 08             	incl   0x8(%ebp)
  801878:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80187b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80187f:	74 17                	je     801898 <strncmp+0x2b>
  801881:	8b 45 08             	mov    0x8(%ebp),%eax
  801884:	8a 00                	mov    (%eax),%al
  801886:	84 c0                	test   %al,%al
  801888:	74 0e                	je     801898 <strncmp+0x2b>
  80188a:	8b 45 08             	mov    0x8(%ebp),%eax
  80188d:	8a 10                	mov    (%eax),%dl
  80188f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801892:	8a 00                	mov    (%eax),%al
  801894:	38 c2                	cmp    %al,%dl
  801896:	74 da                	je     801872 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801898:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80189c:	75 07                	jne    8018a5 <strncmp+0x38>
		return 0;
  80189e:	b8 00 00 00 00       	mov    $0x0,%eax
  8018a3:	eb 14                	jmp    8018b9 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8018a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a8:	8a 00                	mov    (%eax),%al
  8018aa:	0f b6 d0             	movzbl %al,%edx
  8018ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018b0:	8a 00                	mov    (%eax),%al
  8018b2:	0f b6 c0             	movzbl %al,%eax
  8018b5:	29 c2                	sub    %eax,%edx
  8018b7:	89 d0                	mov    %edx,%eax
}
  8018b9:	5d                   	pop    %ebp
  8018ba:	c3                   	ret    

008018bb <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8018bb:	55                   	push   %ebp
  8018bc:	89 e5                	mov    %esp,%ebp
  8018be:	83 ec 04             	sub    $0x4,%esp
  8018c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8018c7:	eb 12                	jmp    8018db <strchr+0x20>
		if (*s == c)
  8018c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cc:	8a 00                	mov    (%eax),%al
  8018ce:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8018d1:	75 05                	jne    8018d8 <strchr+0x1d>
			return (char *) s;
  8018d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d6:	eb 11                	jmp    8018e9 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8018d8:	ff 45 08             	incl   0x8(%ebp)
  8018db:	8b 45 08             	mov    0x8(%ebp),%eax
  8018de:	8a 00                	mov    (%eax),%al
  8018e0:	84 c0                	test   %al,%al
  8018e2:	75 e5                	jne    8018c9 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8018e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018e9:	c9                   	leave  
  8018ea:	c3                   	ret    

008018eb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8018eb:	55                   	push   %ebp
  8018ec:	89 e5                	mov    %esp,%ebp
  8018ee:	83 ec 04             	sub    $0x4,%esp
  8018f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8018f7:	eb 0d                	jmp    801906 <strfind+0x1b>
		if (*s == c)
  8018f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fc:	8a 00                	mov    (%eax),%al
  8018fe:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801901:	74 0e                	je     801911 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801903:	ff 45 08             	incl   0x8(%ebp)
  801906:	8b 45 08             	mov    0x8(%ebp),%eax
  801909:	8a 00                	mov    (%eax),%al
  80190b:	84 c0                	test   %al,%al
  80190d:	75 ea                	jne    8018f9 <strfind+0xe>
  80190f:	eb 01                	jmp    801912 <strfind+0x27>
		if (*s == c)
			break;
  801911:	90                   	nop
	return (char *) s;
  801912:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801915:	c9                   	leave  
  801916:	c3                   	ret    

00801917 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801917:	55                   	push   %ebp
  801918:	89 e5                	mov    %esp,%ebp
  80191a:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80191d:	8b 45 08             	mov    0x8(%ebp),%eax
  801920:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801923:	8b 45 10             	mov    0x10(%ebp),%eax
  801926:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801929:	eb 0e                	jmp    801939 <memset+0x22>
		*p++ = c;
  80192b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80192e:	8d 50 01             	lea    0x1(%eax),%edx
  801931:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801934:	8b 55 0c             	mov    0xc(%ebp),%edx
  801937:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801939:	ff 4d f8             	decl   -0x8(%ebp)
  80193c:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801940:	79 e9                	jns    80192b <memset+0x14>
		*p++ = c;

	return v;
  801942:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801945:	c9                   	leave  
  801946:	c3                   	ret    

00801947 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801947:	55                   	push   %ebp
  801948:	89 e5                	mov    %esp,%ebp
  80194a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80194d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801950:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801953:	8b 45 08             	mov    0x8(%ebp),%eax
  801956:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801959:	eb 16                	jmp    801971 <memcpy+0x2a>
		*d++ = *s++;
  80195b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80195e:	8d 50 01             	lea    0x1(%eax),%edx
  801961:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801964:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801967:	8d 4a 01             	lea    0x1(%edx),%ecx
  80196a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80196d:	8a 12                	mov    (%edx),%dl
  80196f:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801971:	8b 45 10             	mov    0x10(%ebp),%eax
  801974:	8d 50 ff             	lea    -0x1(%eax),%edx
  801977:	89 55 10             	mov    %edx,0x10(%ebp)
  80197a:	85 c0                	test   %eax,%eax
  80197c:	75 dd                	jne    80195b <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80197e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801981:	c9                   	leave  
  801982:	c3                   	ret    

00801983 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801983:	55                   	push   %ebp
  801984:	89 e5                	mov    %esp,%ebp
  801986:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801989:	8b 45 0c             	mov    0xc(%ebp),%eax
  80198c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80198f:	8b 45 08             	mov    0x8(%ebp),%eax
  801992:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801995:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801998:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80199b:	73 50                	jae    8019ed <memmove+0x6a>
  80199d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8019a3:	01 d0                	add    %edx,%eax
  8019a5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8019a8:	76 43                	jbe    8019ed <memmove+0x6a>
		s += n;
  8019aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8019ad:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8019b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8019b3:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8019b6:	eb 10                	jmp    8019c8 <memmove+0x45>
			*--d = *--s;
  8019b8:	ff 4d f8             	decl   -0x8(%ebp)
  8019bb:	ff 4d fc             	decl   -0x4(%ebp)
  8019be:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019c1:	8a 10                	mov    (%eax),%dl
  8019c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019c6:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8019c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8019cb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8019ce:	89 55 10             	mov    %edx,0x10(%ebp)
  8019d1:	85 c0                	test   %eax,%eax
  8019d3:	75 e3                	jne    8019b8 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8019d5:	eb 23                	jmp    8019fa <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8019d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019da:	8d 50 01             	lea    0x1(%eax),%edx
  8019dd:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8019e0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019e3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8019e6:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8019e9:	8a 12                	mov    (%edx),%dl
  8019eb:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8019ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8019f0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8019f3:	89 55 10             	mov    %edx,0x10(%ebp)
  8019f6:	85 c0                	test   %eax,%eax
  8019f8:	75 dd                	jne    8019d7 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8019fa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8019fd:	c9                   	leave  
  8019fe:	c3                   	ret    

008019ff <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8019ff:	55                   	push   %ebp
  801a00:	89 e5                	mov    %esp,%ebp
  801a02:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801a05:	8b 45 08             	mov    0x8(%ebp),%eax
  801a08:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801a0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a0e:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801a11:	eb 2a                	jmp    801a3d <memcmp+0x3e>
		if (*s1 != *s2)
  801a13:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a16:	8a 10                	mov    (%eax),%dl
  801a18:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a1b:	8a 00                	mov    (%eax),%al
  801a1d:	38 c2                	cmp    %al,%dl
  801a1f:	74 16                	je     801a37 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801a21:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a24:	8a 00                	mov    (%eax),%al
  801a26:	0f b6 d0             	movzbl %al,%edx
  801a29:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a2c:	8a 00                	mov    (%eax),%al
  801a2e:	0f b6 c0             	movzbl %al,%eax
  801a31:	29 c2                	sub    %eax,%edx
  801a33:	89 d0                	mov    %edx,%eax
  801a35:	eb 18                	jmp    801a4f <memcmp+0x50>
		s1++, s2++;
  801a37:	ff 45 fc             	incl   -0x4(%ebp)
  801a3a:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801a3d:	8b 45 10             	mov    0x10(%ebp),%eax
  801a40:	8d 50 ff             	lea    -0x1(%eax),%edx
  801a43:	89 55 10             	mov    %edx,0x10(%ebp)
  801a46:	85 c0                	test   %eax,%eax
  801a48:	75 c9                	jne    801a13 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801a4a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a4f:	c9                   	leave  
  801a50:	c3                   	ret    

00801a51 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801a51:	55                   	push   %ebp
  801a52:	89 e5                	mov    %esp,%ebp
  801a54:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801a57:	8b 55 08             	mov    0x8(%ebp),%edx
  801a5a:	8b 45 10             	mov    0x10(%ebp),%eax
  801a5d:	01 d0                	add    %edx,%eax
  801a5f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801a62:	eb 15                	jmp    801a79 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801a64:	8b 45 08             	mov    0x8(%ebp),%eax
  801a67:	8a 00                	mov    (%eax),%al
  801a69:	0f b6 d0             	movzbl %al,%edx
  801a6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a6f:	0f b6 c0             	movzbl %al,%eax
  801a72:	39 c2                	cmp    %eax,%edx
  801a74:	74 0d                	je     801a83 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801a76:	ff 45 08             	incl   0x8(%ebp)
  801a79:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801a7f:	72 e3                	jb     801a64 <memfind+0x13>
  801a81:	eb 01                	jmp    801a84 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801a83:	90                   	nop
	return (void *) s;
  801a84:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801a87:	c9                   	leave  
  801a88:	c3                   	ret    

00801a89 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801a89:	55                   	push   %ebp
  801a8a:	89 e5                	mov    %esp,%ebp
  801a8c:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801a8f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801a96:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801a9d:	eb 03                	jmp    801aa2 <strtol+0x19>
		s++;
  801a9f:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa5:	8a 00                	mov    (%eax),%al
  801aa7:	3c 20                	cmp    $0x20,%al
  801aa9:	74 f4                	je     801a9f <strtol+0x16>
  801aab:	8b 45 08             	mov    0x8(%ebp),%eax
  801aae:	8a 00                	mov    (%eax),%al
  801ab0:	3c 09                	cmp    $0x9,%al
  801ab2:	74 eb                	je     801a9f <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab7:	8a 00                	mov    (%eax),%al
  801ab9:	3c 2b                	cmp    $0x2b,%al
  801abb:	75 05                	jne    801ac2 <strtol+0x39>
		s++;
  801abd:	ff 45 08             	incl   0x8(%ebp)
  801ac0:	eb 13                	jmp    801ad5 <strtol+0x4c>
	else if (*s == '-')
  801ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac5:	8a 00                	mov    (%eax),%al
  801ac7:	3c 2d                	cmp    $0x2d,%al
  801ac9:	75 0a                	jne    801ad5 <strtol+0x4c>
		s++, neg = 1;
  801acb:	ff 45 08             	incl   0x8(%ebp)
  801ace:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801ad5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ad9:	74 06                	je     801ae1 <strtol+0x58>
  801adb:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801adf:	75 20                	jne    801b01 <strtol+0x78>
  801ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae4:	8a 00                	mov    (%eax),%al
  801ae6:	3c 30                	cmp    $0x30,%al
  801ae8:	75 17                	jne    801b01 <strtol+0x78>
  801aea:	8b 45 08             	mov    0x8(%ebp),%eax
  801aed:	40                   	inc    %eax
  801aee:	8a 00                	mov    (%eax),%al
  801af0:	3c 78                	cmp    $0x78,%al
  801af2:	75 0d                	jne    801b01 <strtol+0x78>
		s += 2, base = 16;
  801af4:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801af8:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801aff:	eb 28                	jmp    801b29 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801b01:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801b05:	75 15                	jne    801b1c <strtol+0x93>
  801b07:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0a:	8a 00                	mov    (%eax),%al
  801b0c:	3c 30                	cmp    $0x30,%al
  801b0e:	75 0c                	jne    801b1c <strtol+0x93>
		s++, base = 8;
  801b10:	ff 45 08             	incl   0x8(%ebp)
  801b13:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801b1a:	eb 0d                	jmp    801b29 <strtol+0xa0>
	else if (base == 0)
  801b1c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801b20:	75 07                	jne    801b29 <strtol+0xa0>
		base = 10;
  801b22:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801b29:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2c:	8a 00                	mov    (%eax),%al
  801b2e:	3c 2f                	cmp    $0x2f,%al
  801b30:	7e 19                	jle    801b4b <strtol+0xc2>
  801b32:	8b 45 08             	mov    0x8(%ebp),%eax
  801b35:	8a 00                	mov    (%eax),%al
  801b37:	3c 39                	cmp    $0x39,%al
  801b39:	7f 10                	jg     801b4b <strtol+0xc2>
			dig = *s - '0';
  801b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3e:	8a 00                	mov    (%eax),%al
  801b40:	0f be c0             	movsbl %al,%eax
  801b43:	83 e8 30             	sub    $0x30,%eax
  801b46:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b49:	eb 42                	jmp    801b8d <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4e:	8a 00                	mov    (%eax),%al
  801b50:	3c 60                	cmp    $0x60,%al
  801b52:	7e 19                	jle    801b6d <strtol+0xe4>
  801b54:	8b 45 08             	mov    0x8(%ebp),%eax
  801b57:	8a 00                	mov    (%eax),%al
  801b59:	3c 7a                	cmp    $0x7a,%al
  801b5b:	7f 10                	jg     801b6d <strtol+0xe4>
			dig = *s - 'a' + 10;
  801b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b60:	8a 00                	mov    (%eax),%al
  801b62:	0f be c0             	movsbl %al,%eax
  801b65:	83 e8 57             	sub    $0x57,%eax
  801b68:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b6b:	eb 20                	jmp    801b8d <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b70:	8a 00                	mov    (%eax),%al
  801b72:	3c 40                	cmp    $0x40,%al
  801b74:	7e 39                	jle    801baf <strtol+0x126>
  801b76:	8b 45 08             	mov    0x8(%ebp),%eax
  801b79:	8a 00                	mov    (%eax),%al
  801b7b:	3c 5a                	cmp    $0x5a,%al
  801b7d:	7f 30                	jg     801baf <strtol+0x126>
			dig = *s - 'A' + 10;
  801b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b82:	8a 00                	mov    (%eax),%al
  801b84:	0f be c0             	movsbl %al,%eax
  801b87:	83 e8 37             	sub    $0x37,%eax
  801b8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801b8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b90:	3b 45 10             	cmp    0x10(%ebp),%eax
  801b93:	7d 19                	jge    801bae <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801b95:	ff 45 08             	incl   0x8(%ebp)
  801b98:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b9b:	0f af 45 10          	imul   0x10(%ebp),%eax
  801b9f:	89 c2                	mov    %eax,%edx
  801ba1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ba4:	01 d0                	add    %edx,%eax
  801ba6:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801ba9:	e9 7b ff ff ff       	jmp    801b29 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801bae:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801baf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801bb3:	74 08                	je     801bbd <strtol+0x134>
		*endptr = (char *) s;
  801bb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bb8:	8b 55 08             	mov    0x8(%ebp),%edx
  801bbb:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801bbd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801bc1:	74 07                	je     801bca <strtol+0x141>
  801bc3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bc6:	f7 d8                	neg    %eax
  801bc8:	eb 03                	jmp    801bcd <strtol+0x144>
  801bca:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801bcd:	c9                   	leave  
  801bce:	c3                   	ret    

00801bcf <ltostr>:

void
ltostr(long value, char *str)
{
  801bcf:	55                   	push   %ebp
  801bd0:	89 e5                	mov    %esp,%ebp
  801bd2:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801bd5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801bdc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801be3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801be7:	79 13                	jns    801bfc <ltostr+0x2d>
	{
		neg = 1;
  801be9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801bf0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bf3:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801bf6:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801bf9:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bff:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801c04:	99                   	cltd   
  801c05:	f7 f9                	idiv   %ecx
  801c07:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801c0a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c0d:	8d 50 01             	lea    0x1(%eax),%edx
  801c10:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801c13:	89 c2                	mov    %eax,%edx
  801c15:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c18:	01 d0                	add    %edx,%eax
  801c1a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801c1d:	83 c2 30             	add    $0x30,%edx
  801c20:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801c22:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c25:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801c2a:	f7 e9                	imul   %ecx
  801c2c:	c1 fa 02             	sar    $0x2,%edx
  801c2f:	89 c8                	mov    %ecx,%eax
  801c31:	c1 f8 1f             	sar    $0x1f,%eax
  801c34:	29 c2                	sub    %eax,%edx
  801c36:	89 d0                	mov    %edx,%eax
  801c38:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801c3b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c3e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801c43:	f7 e9                	imul   %ecx
  801c45:	c1 fa 02             	sar    $0x2,%edx
  801c48:	89 c8                	mov    %ecx,%eax
  801c4a:	c1 f8 1f             	sar    $0x1f,%eax
  801c4d:	29 c2                	sub    %eax,%edx
  801c4f:	89 d0                	mov    %edx,%eax
  801c51:	c1 e0 02             	shl    $0x2,%eax
  801c54:	01 d0                	add    %edx,%eax
  801c56:	01 c0                	add    %eax,%eax
  801c58:	29 c1                	sub    %eax,%ecx
  801c5a:	89 ca                	mov    %ecx,%edx
  801c5c:	85 d2                	test   %edx,%edx
  801c5e:	75 9c                	jne    801bfc <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801c60:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801c67:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c6a:	48                   	dec    %eax
  801c6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801c6e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801c72:	74 3d                	je     801cb1 <ltostr+0xe2>
		start = 1 ;
  801c74:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801c7b:	eb 34                	jmp    801cb1 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801c7d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c80:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c83:	01 d0                	add    %edx,%eax
  801c85:	8a 00                	mov    (%eax),%al
  801c87:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801c8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c90:	01 c2                	add    %eax,%edx
  801c92:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801c95:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c98:	01 c8                	add    %ecx,%eax
  801c9a:	8a 00                	mov    (%eax),%al
  801c9c:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801c9e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ca1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ca4:	01 c2                	add    %eax,%edx
  801ca6:	8a 45 eb             	mov    -0x15(%ebp),%al
  801ca9:	88 02                	mov    %al,(%edx)
		start++ ;
  801cab:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801cae:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801cb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cb4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801cb7:	7c c4                	jl     801c7d <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801cb9:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801cbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cbf:	01 d0                	add    %edx,%eax
  801cc1:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801cc4:	90                   	nop
  801cc5:	c9                   	leave  
  801cc6:	c3                   	ret    

00801cc7 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801cc7:	55                   	push   %ebp
  801cc8:	89 e5                	mov    %esp,%ebp
  801cca:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801ccd:	ff 75 08             	pushl  0x8(%ebp)
  801cd0:	e8 54 fa ff ff       	call   801729 <strlen>
  801cd5:	83 c4 04             	add    $0x4,%esp
  801cd8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801cdb:	ff 75 0c             	pushl  0xc(%ebp)
  801cde:	e8 46 fa ff ff       	call   801729 <strlen>
  801ce3:	83 c4 04             	add    $0x4,%esp
  801ce6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801ce9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801cf0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801cf7:	eb 17                	jmp    801d10 <strcconcat+0x49>
		final[s] = str1[s] ;
  801cf9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801cfc:	8b 45 10             	mov    0x10(%ebp),%eax
  801cff:	01 c2                	add    %eax,%edx
  801d01:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801d04:	8b 45 08             	mov    0x8(%ebp),%eax
  801d07:	01 c8                	add    %ecx,%eax
  801d09:	8a 00                	mov    (%eax),%al
  801d0b:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801d0d:	ff 45 fc             	incl   -0x4(%ebp)
  801d10:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d13:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801d16:	7c e1                	jl     801cf9 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801d18:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801d1f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801d26:	eb 1f                	jmp    801d47 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801d28:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d2b:	8d 50 01             	lea    0x1(%eax),%edx
  801d2e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801d31:	89 c2                	mov    %eax,%edx
  801d33:	8b 45 10             	mov    0x10(%ebp),%eax
  801d36:	01 c2                	add    %eax,%edx
  801d38:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801d3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d3e:	01 c8                	add    %ecx,%eax
  801d40:	8a 00                	mov    (%eax),%al
  801d42:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801d44:	ff 45 f8             	incl   -0x8(%ebp)
  801d47:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d4a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801d4d:	7c d9                	jl     801d28 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801d4f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d52:	8b 45 10             	mov    0x10(%ebp),%eax
  801d55:	01 d0                	add    %edx,%eax
  801d57:	c6 00 00             	movb   $0x0,(%eax)
}
  801d5a:	90                   	nop
  801d5b:	c9                   	leave  
  801d5c:	c3                   	ret    

00801d5d <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801d5d:	55                   	push   %ebp
  801d5e:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801d60:	8b 45 14             	mov    0x14(%ebp),%eax
  801d63:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801d69:	8b 45 14             	mov    0x14(%ebp),%eax
  801d6c:	8b 00                	mov    (%eax),%eax
  801d6e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801d75:	8b 45 10             	mov    0x10(%ebp),%eax
  801d78:	01 d0                	add    %edx,%eax
  801d7a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801d80:	eb 0c                	jmp    801d8e <strsplit+0x31>
			*string++ = 0;
  801d82:	8b 45 08             	mov    0x8(%ebp),%eax
  801d85:	8d 50 01             	lea    0x1(%eax),%edx
  801d88:	89 55 08             	mov    %edx,0x8(%ebp)
  801d8b:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d91:	8a 00                	mov    (%eax),%al
  801d93:	84 c0                	test   %al,%al
  801d95:	74 18                	je     801daf <strsplit+0x52>
  801d97:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9a:	8a 00                	mov    (%eax),%al
  801d9c:	0f be c0             	movsbl %al,%eax
  801d9f:	50                   	push   %eax
  801da0:	ff 75 0c             	pushl  0xc(%ebp)
  801da3:	e8 13 fb ff ff       	call   8018bb <strchr>
  801da8:	83 c4 08             	add    $0x8,%esp
  801dab:	85 c0                	test   %eax,%eax
  801dad:	75 d3                	jne    801d82 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801daf:	8b 45 08             	mov    0x8(%ebp),%eax
  801db2:	8a 00                	mov    (%eax),%al
  801db4:	84 c0                	test   %al,%al
  801db6:	74 5a                	je     801e12 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801db8:	8b 45 14             	mov    0x14(%ebp),%eax
  801dbb:	8b 00                	mov    (%eax),%eax
  801dbd:	83 f8 0f             	cmp    $0xf,%eax
  801dc0:	75 07                	jne    801dc9 <strsplit+0x6c>
		{
			return 0;
  801dc2:	b8 00 00 00 00       	mov    $0x0,%eax
  801dc7:	eb 66                	jmp    801e2f <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801dc9:	8b 45 14             	mov    0x14(%ebp),%eax
  801dcc:	8b 00                	mov    (%eax),%eax
  801dce:	8d 48 01             	lea    0x1(%eax),%ecx
  801dd1:	8b 55 14             	mov    0x14(%ebp),%edx
  801dd4:	89 0a                	mov    %ecx,(%edx)
  801dd6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ddd:	8b 45 10             	mov    0x10(%ebp),%eax
  801de0:	01 c2                	add    %eax,%edx
  801de2:	8b 45 08             	mov    0x8(%ebp),%eax
  801de5:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801de7:	eb 03                	jmp    801dec <strsplit+0x8f>
			string++;
  801de9:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801dec:	8b 45 08             	mov    0x8(%ebp),%eax
  801def:	8a 00                	mov    (%eax),%al
  801df1:	84 c0                	test   %al,%al
  801df3:	74 8b                	je     801d80 <strsplit+0x23>
  801df5:	8b 45 08             	mov    0x8(%ebp),%eax
  801df8:	8a 00                	mov    (%eax),%al
  801dfa:	0f be c0             	movsbl %al,%eax
  801dfd:	50                   	push   %eax
  801dfe:	ff 75 0c             	pushl  0xc(%ebp)
  801e01:	e8 b5 fa ff ff       	call   8018bb <strchr>
  801e06:	83 c4 08             	add    $0x8,%esp
  801e09:	85 c0                	test   %eax,%eax
  801e0b:	74 dc                	je     801de9 <strsplit+0x8c>
			string++;
	}
  801e0d:	e9 6e ff ff ff       	jmp    801d80 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801e12:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801e13:	8b 45 14             	mov    0x14(%ebp),%eax
  801e16:	8b 00                	mov    (%eax),%eax
  801e18:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801e1f:	8b 45 10             	mov    0x10(%ebp),%eax
  801e22:	01 d0                	add    %edx,%eax
  801e24:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801e2a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801e2f:	c9                   	leave  
  801e30:	c3                   	ret    

00801e31 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801e31:	55                   	push   %ebp
  801e32:	89 e5                	mov    %esp,%ebp
  801e34:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801e37:	a1 04 50 80 00       	mov    0x805004,%eax
  801e3c:	85 c0                	test   %eax,%eax
  801e3e:	74 1f                	je     801e5f <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801e40:	e8 1d 00 00 00       	call   801e62 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801e45:	83 ec 0c             	sub    $0xc,%esp
  801e48:	68 30 45 80 00       	push   $0x804530
  801e4d:	e8 55 f2 ff ff       	call   8010a7 <cprintf>
  801e52:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801e55:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801e5c:	00 00 00 
	}
}
  801e5f:	90                   	nop
  801e60:	c9                   	leave  
  801e61:	c3                   	ret    

00801e62 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801e62:	55                   	push   %ebp
  801e63:	89 e5                	mov    %esp,%ebp
  801e65:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  801e68:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801e6f:	00 00 00 
  801e72:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801e79:	00 00 00 
  801e7c:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801e83:	00 00 00 
		LIST_INIT(&AllocMemBlocksList);
  801e86:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801e8d:	00 00 00 
  801e90:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801e97:	00 00 00 
  801e9a:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801ea1:	00 00 00 

		MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES ;
  801ea4:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801eab:	00 02 00 
		MemBlockNodes =(struct MemBlock*)USER_DYN_BLKS_ARRAY ;
  801eae:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801eb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801ebd:	2d 00 10 00 00       	sub    $0x1000,%eax
  801ec2:	a3 50 50 80 00       	mov    %eax,0x805050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock),PAGE_SIZE),PERM_USER|PERM_WRITEABLE);
  801ec7:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801ece:	a1 20 51 80 00       	mov    0x805120,%eax
  801ed3:	c1 e0 04             	shl    $0x4,%eax
  801ed6:	89 c2                	mov    %eax,%edx
  801ed8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801edb:	01 d0                	add    %edx,%eax
  801edd:	48                   	dec    %eax
  801ede:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801ee1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ee4:	ba 00 00 00 00       	mov    $0x0,%edx
  801ee9:	f7 75 f0             	divl   -0x10(%ebp)
  801eec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801eef:	29 d0                	sub    %edx,%eax
  801ef1:	89 c2                	mov    %eax,%edx
  801ef3:	c7 45 e8 00 00 e0 7f 	movl   $0x7fe00000,-0x18(%ebp)
  801efa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801efd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801f02:	2d 00 10 00 00       	sub    $0x1000,%eax
  801f07:	83 ec 04             	sub    $0x4,%esp
  801f0a:	6a 06                	push   $0x6
  801f0c:	52                   	push   %edx
  801f0d:	50                   	push   %eax
  801f0e:	e8 71 05 00 00       	call   802484 <sys_allocate_chunk>
  801f13:	83 c4 10             	add    $0x10,%esp
		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801f16:	a1 20 51 80 00       	mov    0x805120,%eax
  801f1b:	83 ec 0c             	sub    $0xc,%esp
  801f1e:	50                   	push   %eax
  801f1f:	e8 e6 0b 00 00       	call   802b0a <initialize_MemBlocksList>
  801f24:	83 c4 10             	add    $0x10,%esp

		struct MemBlock  *block_node;
		block_node = AvailableMemBlocksList.lh_first;
  801f27:	a1 48 51 80 00       	mov    0x805148,%eax
  801f2c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&(AvailableMemBlocksList),block_node);
  801f2f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801f33:	75 14                	jne    801f49 <initialize_dyn_block_system+0xe7>
  801f35:	83 ec 04             	sub    $0x4,%esp
  801f38:	68 55 45 80 00       	push   $0x804555
  801f3d:	6a 2b                	push   $0x2b
  801f3f:	68 73 45 80 00       	push   $0x804573
  801f44:	e8 aa ee ff ff       	call   800df3 <_panic>
  801f49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f4c:	8b 00                	mov    (%eax),%eax
  801f4e:	85 c0                	test   %eax,%eax
  801f50:	74 10                	je     801f62 <initialize_dyn_block_system+0x100>
  801f52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f55:	8b 00                	mov    (%eax),%eax
  801f57:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801f5a:	8b 52 04             	mov    0x4(%edx),%edx
  801f5d:	89 50 04             	mov    %edx,0x4(%eax)
  801f60:	eb 0b                	jmp    801f6d <initialize_dyn_block_system+0x10b>
  801f62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f65:	8b 40 04             	mov    0x4(%eax),%eax
  801f68:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801f6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f70:	8b 40 04             	mov    0x4(%eax),%eax
  801f73:	85 c0                	test   %eax,%eax
  801f75:	74 0f                	je     801f86 <initialize_dyn_block_system+0x124>
  801f77:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f7a:	8b 40 04             	mov    0x4(%eax),%eax
  801f7d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801f80:	8b 12                	mov    (%edx),%edx
  801f82:	89 10                	mov    %edx,(%eax)
  801f84:	eb 0a                	jmp    801f90 <initialize_dyn_block_system+0x12e>
  801f86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f89:	8b 00                	mov    (%eax),%eax
  801f8b:	a3 48 51 80 00       	mov    %eax,0x805148
  801f90:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f93:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801f99:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f9c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801fa3:	a1 54 51 80 00       	mov    0x805154,%eax
  801fa8:	48                   	dec    %eax
  801fa9:	a3 54 51 80 00       	mov    %eax,0x805154
		block_node->sva = USER_HEAP_START ;
  801fae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801fb1:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
		block_node->size = ((USER_HEAP_MAX - USER_HEAP_START));
  801fb8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801fbb:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		insert_sorted_with_merge_freeList(block_node);
  801fc2:	83 ec 0c             	sub    $0xc,%esp
  801fc5:	ff 75 e4             	pushl  -0x1c(%ebp)
  801fc8:	e8 d2 13 00 00       	call   80339f <insert_sorted_with_merge_freeList>
  801fcd:	83 c4 10             	add    $0x10,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801fd0:	90                   	nop
  801fd1:	c9                   	leave  
  801fd2:	c3                   	ret    

00801fd3 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801fd3:	55                   	push   %ebp
  801fd4:	89 e5                	mov    %esp,%ebp
  801fd6:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801fd9:	e8 53 fe ff ff       	call   801e31 <InitializeUHeap>
	if (size == 0) return NULL ;
  801fde:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801fe2:	75 07                	jne    801feb <malloc+0x18>
  801fe4:	b8 00 00 00 00       	mov    $0x0,%eax
  801fe9:	eb 61                	jmp    80204c <malloc+0x79>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	size= ROUNDUP(size,PAGE_SIZE);
  801feb:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801ff2:	8b 55 08             	mov    0x8(%ebp),%edx
  801ff5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff8:	01 d0                	add    %edx,%eax
  801ffa:	48                   	dec    %eax
  801ffb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ffe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802001:	ba 00 00 00 00       	mov    $0x0,%edx
  802006:	f7 75 f4             	divl   -0xc(%ebp)
  802009:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80200c:	29 d0                	sub    %edx,%eax
  80200e:	89 45 08             	mov    %eax,0x8(%ebp)
	    			if(sys_isUHeapPlacementStrategyFIRSTFIT())
  802011:	e8 3c 08 00 00       	call   802852 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802016:	85 c0                	test   %eax,%eax
  802018:	74 2d                	je     802047 <malloc+0x74>
	    			{
	    				struct MemBlock * ff_block = alloc_block_FF(size);
  80201a:	83 ec 0c             	sub    $0xc,%esp
  80201d:	ff 75 08             	pushl  0x8(%ebp)
  802020:	e8 3e 0f 00 00       	call   802f63 <alloc_block_FF>
  802025:	83 c4 10             	add    $0x10,%esp
  802028:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    				if(ff_block!=NULL)
  80202b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80202f:	74 16                	je     802047 <malloc+0x74>
	    				{

	    					insert_sorted_allocList(ff_block);
  802031:	83 ec 0c             	sub    $0xc,%esp
  802034:	ff 75 ec             	pushl  -0x14(%ebp)
  802037:	e8 48 0c 00 00       	call   802c84 <insert_sorted_allocList>
  80203c:	83 c4 10             	add    $0x10,%esp
	    					return (void*) ff_block->sva ;
  80203f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802042:	8b 40 08             	mov    0x8(%eax),%eax
  802045:	eb 05                	jmp    80204c <malloc+0x79>

	    				}
	}
	    			return (void*) NULL ;
  802047:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  80204c:	c9                   	leave  
  80204d:	c3                   	ret    

0080204e <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80204e:	55                   	push   %ebp
  80204f:	89 e5                	mov    %esp,%ebp
  802051:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock *elementForEach;
		virtual_address = ROUNDDOWN(virtual_address, PAGE_SIZE);
  802054:	8b 45 08             	mov    0x8(%ebp),%eax
  802057:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80205a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80205d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802062:	89 45 08             	mov    %eax,0x8(%ebp)
	//	if (is_mallocPages[indexindex((uint32) virtual_address)] == 1) {
		elementForEach = find_block(&AllocMemBlocksList,(uint32)virtual_address);
  802065:	8b 45 08             	mov    0x8(%ebp),%eax
  802068:	83 ec 08             	sub    $0x8,%esp
  80206b:	50                   	push   %eax
  80206c:	68 40 50 80 00       	push   $0x805040
  802071:	e8 71 0b 00 00       	call   802be7 <find_block>
  802076:	83 c4 10             	add    $0x10,%esp
  802079:	89 45 f0             	mov    %eax,-0x10(%ebp)
		sys_free_user_mem((uint32) virtual_address, elementForEach->size);
  80207c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80207f:	8b 50 0c             	mov    0xc(%eax),%edx
  802082:	8b 45 08             	mov    0x8(%ebp),%eax
  802085:	83 ec 08             	sub    $0x8,%esp
  802088:	52                   	push   %edx
  802089:	50                   	push   %eax
  80208a:	e8 bd 03 00 00       	call   80244c <sys_free_user_mem>
  80208f:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,elementForEach);
  802092:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802096:	75 14                	jne    8020ac <free+0x5e>
  802098:	83 ec 04             	sub    $0x4,%esp
  80209b:	68 55 45 80 00       	push   $0x804555
  8020a0:	6a 71                	push   $0x71
  8020a2:	68 73 45 80 00       	push   $0x804573
  8020a7:	e8 47 ed ff ff       	call   800df3 <_panic>
  8020ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020af:	8b 00                	mov    (%eax),%eax
  8020b1:	85 c0                	test   %eax,%eax
  8020b3:	74 10                	je     8020c5 <free+0x77>
  8020b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020b8:	8b 00                	mov    (%eax),%eax
  8020ba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020bd:	8b 52 04             	mov    0x4(%edx),%edx
  8020c0:	89 50 04             	mov    %edx,0x4(%eax)
  8020c3:	eb 0b                	jmp    8020d0 <free+0x82>
  8020c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020c8:	8b 40 04             	mov    0x4(%eax),%eax
  8020cb:	a3 44 50 80 00       	mov    %eax,0x805044
  8020d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020d3:	8b 40 04             	mov    0x4(%eax),%eax
  8020d6:	85 c0                	test   %eax,%eax
  8020d8:	74 0f                	je     8020e9 <free+0x9b>
  8020da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020dd:	8b 40 04             	mov    0x4(%eax),%eax
  8020e0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020e3:	8b 12                	mov    (%edx),%edx
  8020e5:	89 10                	mov    %edx,(%eax)
  8020e7:	eb 0a                	jmp    8020f3 <free+0xa5>
  8020e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020ec:	8b 00                	mov    (%eax),%eax
  8020ee:	a3 40 50 80 00       	mov    %eax,0x805040
  8020f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8020fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020ff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802106:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80210b:	48                   	dec    %eax
  80210c:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(elementForEach);
  802111:	83 ec 0c             	sub    $0xc,%esp
  802114:	ff 75 f0             	pushl  -0x10(%ebp)
  802117:	e8 83 12 00 00       	call   80339f <insert_sorted_with_merge_freeList>
  80211c:	83 c4 10             	add    $0x10,%esp
	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  80211f:	90                   	nop
  802120:	c9                   	leave  
  802121:	c3                   	ret    

00802122 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802122:	55                   	push   %ebp
  802123:	89 e5                	mov    %esp,%ebp
  802125:	83 ec 28             	sub    $0x28,%esp
  802128:	8b 45 10             	mov    0x10(%ebp),%eax
  80212b:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80212e:	e8 fe fc ff ff       	call   801e31 <InitializeUHeap>
	if (size == 0) return NULL ;
  802133:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802137:	75 0a                	jne    802143 <smalloc+0x21>
  802139:	b8 00 00 00 00       	mov    $0x0,%eax
  80213e:	e9 86 00 00 00       	jmp    8021c9 <smalloc+0xa7>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code

	size=ROUNDUP(size,PAGE_SIZE);
  802143:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80214a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80214d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802150:	01 d0                	add    %edx,%eax
  802152:	48                   	dec    %eax
  802153:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802156:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802159:	ba 00 00 00 00       	mov    $0x0,%edx
  80215e:	f7 75 f4             	divl   -0xc(%ebp)
  802161:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802164:	29 d0                	sub    %edx,%eax
  802166:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  802169:	e8 e4 06 00 00       	call   802852 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80216e:	85 c0                	test   %eax,%eax
  802170:	74 52                	je     8021c4 <smalloc+0xa2>
		{
		struct MemBlock * ff_block ;
		ff_block = alloc_block_FF(size);
  802172:	83 ec 0c             	sub    $0xc,%esp
  802175:	ff 75 0c             	pushl  0xc(%ebp)
  802178:	e8 e6 0d 00 00       	call   802f63 <alloc_block_FF>
  80217d:	83 c4 10             	add    $0x10,%esp
  802180:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(ff_block==NULL)
  802183:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802187:	75 07                	jne    802190 <smalloc+0x6e>
			return NULL ;
  802189:	b8 00 00 00 00       	mov    $0x0,%eax
  80218e:	eb 39                	jmp    8021c9 <smalloc+0xa7>

		int obj_id =sys_createSharedObject(sharedVarName,size,isWritable,(void*)ff_block->sva);
  802190:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802193:	8b 40 08             	mov    0x8(%eax),%eax
  802196:	89 c2                	mov    %eax,%edx
  802198:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  80219c:	52                   	push   %edx
  80219d:	50                   	push   %eax
  80219e:	ff 75 0c             	pushl  0xc(%ebp)
  8021a1:	ff 75 08             	pushl  0x8(%ebp)
  8021a4:	e8 2e 04 00 00       	call   8025d7 <sys_createSharedObject>
  8021a9:	83 c4 10             	add    $0x10,%esp
  8021ac:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(obj_id < 0)
  8021af:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8021b3:	79 07                	jns    8021bc <smalloc+0x9a>
			return (void*)NULL ;
  8021b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ba:	eb 0d                	jmp    8021c9 <smalloc+0xa7>
		else
		    return (void*)ff_block->sva ;
  8021bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021bf:	8b 40 08             	mov    0x8(%eax),%eax
  8021c2:	eb 05                	jmp    8021c9 <smalloc+0xa7>
		}
		return (void*)NULL ;
  8021c4:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8021c9:	c9                   	leave  
  8021ca:	c3                   	ret    

008021cb <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8021cb:	55                   	push   %ebp
  8021cc:	89 e5                	mov    %esp,%ebp
  8021ce:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8021d1:	e8 5b fc ff ff       	call   801e31 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8021d6:	83 ec 08             	sub    $0x8,%esp
  8021d9:	ff 75 0c             	pushl  0xc(%ebp)
  8021dc:	ff 75 08             	pushl  0x8(%ebp)
  8021df:	e8 1d 04 00 00       	call   802601 <sys_getSizeOfSharedObject>
  8021e4:	83 c4 10             	add    $0x10,%esp
  8021e7:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(size == 0)
  8021ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021ee:	75 0a                	jne    8021fa <sget+0x2f>
			return NULL ;
  8021f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8021f5:	e9 83 00 00 00       	jmp    80227d <sget+0xb2>
		size=ROUNDUP(size,PAGE_SIZE);
  8021fa:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802201:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802204:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802207:	01 d0                	add    %edx,%eax
  802209:	48                   	dec    %eax
  80220a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80220d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802210:	ba 00 00 00 00       	mov    $0x0,%edx
  802215:	f7 75 f0             	divl   -0x10(%ebp)
  802218:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80221b:	29 d0                	sub    %edx,%eax
  80221d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  802220:	e8 2d 06 00 00       	call   802852 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802225:	85 c0                	test   %eax,%eax
  802227:	74 4f                	je     802278 <sget+0xad>
		{
			struct MemBlock * ff_block ;
				ff_block = alloc_block_FF(size);
  802229:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222c:	83 ec 0c             	sub    $0xc,%esp
  80222f:	50                   	push   %eax
  802230:	e8 2e 0d 00 00       	call   802f63 <alloc_block_FF>
  802235:	83 c4 10             	add    $0x10,%esp
  802238:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ff_block==NULL)
  80223b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80223f:	75 07                	jne    802248 <sget+0x7d>
					return (void*)NULL ;
  802241:	b8 00 00 00 00       	mov    $0x0,%eax
  802246:	eb 35                	jmp    80227d <sget+0xb2>

		int obj_id =sys_getSharedObject((int)ownerEnvID,sharedVarName,(void*)ff_block->sva);
  802248:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80224b:	8b 40 08             	mov    0x8(%eax),%eax
  80224e:	83 ec 04             	sub    $0x4,%esp
  802251:	50                   	push   %eax
  802252:	ff 75 0c             	pushl  0xc(%ebp)
  802255:	ff 75 08             	pushl  0x8(%ebp)
  802258:	e8 c1 03 00 00       	call   80261e <sys_getSharedObject>
  80225d:	83 c4 10             	add    $0x10,%esp
  802260:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if(obj_id<0)
  802263:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802267:	79 07                	jns    802270 <sget+0xa5>
				return (void*)NULL ;
  802269:	b8 00 00 00 00       	mov    $0x0,%eax
  80226e:	eb 0d                	jmp    80227d <sget+0xb2>
			else
				return (void*)ff_block->sva ;
  802270:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802273:	8b 40 08             	mov    0x8(%eax),%eax
  802276:	eb 05                	jmp    80227d <sget+0xb2>


		}
	return (void*)NULL ;
  802278:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80227d:	c9                   	leave  
  80227e:	c3                   	ret    

0080227f <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80227f:	55                   	push   %ebp
  802280:	89 e5                	mov    %esp,%ebp
  802282:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802285:	e8 a7 fb ff ff       	call   801e31 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80228a:	83 ec 04             	sub    $0x4,%esp
  80228d:	68 80 45 80 00       	push   $0x804580
  802292:	68 f9 00 00 00       	push   $0xf9
  802297:	68 73 45 80 00       	push   $0x804573
  80229c:	e8 52 eb ff ff       	call   800df3 <_panic>

008022a1 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8022a1:	55                   	push   %ebp
  8022a2:	89 e5                	mov    %esp,%ebp
  8022a4:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8022a7:	83 ec 04             	sub    $0x4,%esp
  8022aa:	68 a8 45 80 00       	push   $0x8045a8
  8022af:	68 0d 01 00 00       	push   $0x10d
  8022b4:	68 73 45 80 00       	push   $0x804573
  8022b9:	e8 35 eb ff ff       	call   800df3 <_panic>

008022be <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8022be:	55                   	push   %ebp
  8022bf:	89 e5                	mov    %esp,%ebp
  8022c1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8022c4:	83 ec 04             	sub    $0x4,%esp
  8022c7:	68 cc 45 80 00       	push   $0x8045cc
  8022cc:	68 18 01 00 00       	push   $0x118
  8022d1:	68 73 45 80 00       	push   $0x804573
  8022d6:	e8 18 eb ff ff       	call   800df3 <_panic>

008022db <shrink>:

}
void shrink(uint32 newSize)
{
  8022db:	55                   	push   %ebp
  8022dc:	89 e5                	mov    %esp,%ebp
  8022de:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8022e1:	83 ec 04             	sub    $0x4,%esp
  8022e4:	68 cc 45 80 00       	push   $0x8045cc
  8022e9:	68 1d 01 00 00       	push   $0x11d
  8022ee:	68 73 45 80 00       	push   $0x804573
  8022f3:	e8 fb ea ff ff       	call   800df3 <_panic>

008022f8 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8022f8:	55                   	push   %ebp
  8022f9:	89 e5                	mov    %esp,%ebp
  8022fb:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8022fe:	83 ec 04             	sub    $0x4,%esp
  802301:	68 cc 45 80 00       	push   $0x8045cc
  802306:	68 22 01 00 00       	push   $0x122
  80230b:	68 73 45 80 00       	push   $0x804573
  802310:	e8 de ea ff ff       	call   800df3 <_panic>

00802315 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802315:	55                   	push   %ebp
  802316:	89 e5                	mov    %esp,%ebp
  802318:	57                   	push   %edi
  802319:	56                   	push   %esi
  80231a:	53                   	push   %ebx
  80231b:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80231e:	8b 45 08             	mov    0x8(%ebp),%eax
  802321:	8b 55 0c             	mov    0xc(%ebp),%edx
  802324:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802327:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80232a:	8b 7d 18             	mov    0x18(%ebp),%edi
  80232d:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802330:	cd 30                	int    $0x30
  802332:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802335:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802338:	83 c4 10             	add    $0x10,%esp
  80233b:	5b                   	pop    %ebx
  80233c:	5e                   	pop    %esi
  80233d:	5f                   	pop    %edi
  80233e:	5d                   	pop    %ebp
  80233f:	c3                   	ret    

00802340 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802340:	55                   	push   %ebp
  802341:	89 e5                	mov    %esp,%ebp
  802343:	83 ec 04             	sub    $0x4,%esp
  802346:	8b 45 10             	mov    0x10(%ebp),%eax
  802349:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80234c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802350:	8b 45 08             	mov    0x8(%ebp),%eax
  802353:	6a 00                	push   $0x0
  802355:	6a 00                	push   $0x0
  802357:	52                   	push   %edx
  802358:	ff 75 0c             	pushl  0xc(%ebp)
  80235b:	50                   	push   %eax
  80235c:	6a 00                	push   $0x0
  80235e:	e8 b2 ff ff ff       	call   802315 <syscall>
  802363:	83 c4 18             	add    $0x18,%esp
}
  802366:	90                   	nop
  802367:	c9                   	leave  
  802368:	c3                   	ret    

00802369 <sys_cgetc>:

int
sys_cgetc(void)
{
  802369:	55                   	push   %ebp
  80236a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80236c:	6a 00                	push   $0x0
  80236e:	6a 00                	push   $0x0
  802370:	6a 00                	push   $0x0
  802372:	6a 00                	push   $0x0
  802374:	6a 00                	push   $0x0
  802376:	6a 01                	push   $0x1
  802378:	e8 98 ff ff ff       	call   802315 <syscall>
  80237d:	83 c4 18             	add    $0x18,%esp
}
  802380:	c9                   	leave  
  802381:	c3                   	ret    

00802382 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802382:	55                   	push   %ebp
  802383:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802385:	8b 55 0c             	mov    0xc(%ebp),%edx
  802388:	8b 45 08             	mov    0x8(%ebp),%eax
  80238b:	6a 00                	push   $0x0
  80238d:	6a 00                	push   $0x0
  80238f:	6a 00                	push   $0x0
  802391:	52                   	push   %edx
  802392:	50                   	push   %eax
  802393:	6a 05                	push   $0x5
  802395:	e8 7b ff ff ff       	call   802315 <syscall>
  80239a:	83 c4 18             	add    $0x18,%esp
}
  80239d:	c9                   	leave  
  80239e:	c3                   	ret    

0080239f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80239f:	55                   	push   %ebp
  8023a0:	89 e5                	mov    %esp,%ebp
  8023a2:	56                   	push   %esi
  8023a3:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8023a4:	8b 75 18             	mov    0x18(%ebp),%esi
  8023a7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8023aa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8023ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b3:	56                   	push   %esi
  8023b4:	53                   	push   %ebx
  8023b5:	51                   	push   %ecx
  8023b6:	52                   	push   %edx
  8023b7:	50                   	push   %eax
  8023b8:	6a 06                	push   $0x6
  8023ba:	e8 56 ff ff ff       	call   802315 <syscall>
  8023bf:	83 c4 18             	add    $0x18,%esp
}
  8023c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023c5:	5b                   	pop    %ebx
  8023c6:	5e                   	pop    %esi
  8023c7:	5d                   	pop    %ebp
  8023c8:	c3                   	ret    

008023c9 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8023c9:	55                   	push   %ebp
  8023ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8023cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d2:	6a 00                	push   $0x0
  8023d4:	6a 00                	push   $0x0
  8023d6:	6a 00                	push   $0x0
  8023d8:	52                   	push   %edx
  8023d9:	50                   	push   %eax
  8023da:	6a 07                	push   $0x7
  8023dc:	e8 34 ff ff ff       	call   802315 <syscall>
  8023e1:	83 c4 18             	add    $0x18,%esp
}
  8023e4:	c9                   	leave  
  8023e5:	c3                   	ret    

008023e6 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8023e6:	55                   	push   %ebp
  8023e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8023e9:	6a 00                	push   $0x0
  8023eb:	6a 00                	push   $0x0
  8023ed:	6a 00                	push   $0x0
  8023ef:	ff 75 0c             	pushl  0xc(%ebp)
  8023f2:	ff 75 08             	pushl  0x8(%ebp)
  8023f5:	6a 08                	push   $0x8
  8023f7:	e8 19 ff ff ff       	call   802315 <syscall>
  8023fc:	83 c4 18             	add    $0x18,%esp
}
  8023ff:	c9                   	leave  
  802400:	c3                   	ret    

00802401 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802401:	55                   	push   %ebp
  802402:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802404:	6a 00                	push   $0x0
  802406:	6a 00                	push   $0x0
  802408:	6a 00                	push   $0x0
  80240a:	6a 00                	push   $0x0
  80240c:	6a 00                	push   $0x0
  80240e:	6a 09                	push   $0x9
  802410:	e8 00 ff ff ff       	call   802315 <syscall>
  802415:	83 c4 18             	add    $0x18,%esp
}
  802418:	c9                   	leave  
  802419:	c3                   	ret    

0080241a <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80241a:	55                   	push   %ebp
  80241b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80241d:	6a 00                	push   $0x0
  80241f:	6a 00                	push   $0x0
  802421:	6a 00                	push   $0x0
  802423:	6a 00                	push   $0x0
  802425:	6a 00                	push   $0x0
  802427:	6a 0a                	push   $0xa
  802429:	e8 e7 fe ff ff       	call   802315 <syscall>
  80242e:	83 c4 18             	add    $0x18,%esp
}
  802431:	c9                   	leave  
  802432:	c3                   	ret    

00802433 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802433:	55                   	push   %ebp
  802434:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802436:	6a 00                	push   $0x0
  802438:	6a 00                	push   $0x0
  80243a:	6a 00                	push   $0x0
  80243c:	6a 00                	push   $0x0
  80243e:	6a 00                	push   $0x0
  802440:	6a 0b                	push   $0xb
  802442:	e8 ce fe ff ff       	call   802315 <syscall>
  802447:	83 c4 18             	add    $0x18,%esp
}
  80244a:	c9                   	leave  
  80244b:	c3                   	ret    

0080244c <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80244c:	55                   	push   %ebp
  80244d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80244f:	6a 00                	push   $0x0
  802451:	6a 00                	push   $0x0
  802453:	6a 00                	push   $0x0
  802455:	ff 75 0c             	pushl  0xc(%ebp)
  802458:	ff 75 08             	pushl  0x8(%ebp)
  80245b:	6a 0f                	push   $0xf
  80245d:	e8 b3 fe ff ff       	call   802315 <syscall>
  802462:	83 c4 18             	add    $0x18,%esp
	return;
  802465:	90                   	nop
}
  802466:	c9                   	leave  
  802467:	c3                   	ret    

00802468 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802468:	55                   	push   %ebp
  802469:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80246b:	6a 00                	push   $0x0
  80246d:	6a 00                	push   $0x0
  80246f:	6a 00                	push   $0x0
  802471:	ff 75 0c             	pushl  0xc(%ebp)
  802474:	ff 75 08             	pushl  0x8(%ebp)
  802477:	6a 10                	push   $0x10
  802479:	e8 97 fe ff ff       	call   802315 <syscall>
  80247e:	83 c4 18             	add    $0x18,%esp
	return ;
  802481:	90                   	nop
}
  802482:	c9                   	leave  
  802483:	c3                   	ret    

00802484 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802484:	55                   	push   %ebp
  802485:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802487:	6a 00                	push   $0x0
  802489:	6a 00                	push   $0x0
  80248b:	ff 75 10             	pushl  0x10(%ebp)
  80248e:	ff 75 0c             	pushl  0xc(%ebp)
  802491:	ff 75 08             	pushl  0x8(%ebp)
  802494:	6a 11                	push   $0x11
  802496:	e8 7a fe ff ff       	call   802315 <syscall>
  80249b:	83 c4 18             	add    $0x18,%esp
	return ;
  80249e:	90                   	nop
}
  80249f:	c9                   	leave  
  8024a0:	c3                   	ret    

008024a1 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8024a1:	55                   	push   %ebp
  8024a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8024a4:	6a 00                	push   $0x0
  8024a6:	6a 00                	push   $0x0
  8024a8:	6a 00                	push   $0x0
  8024aa:	6a 00                	push   $0x0
  8024ac:	6a 00                	push   $0x0
  8024ae:	6a 0c                	push   $0xc
  8024b0:	e8 60 fe ff ff       	call   802315 <syscall>
  8024b5:	83 c4 18             	add    $0x18,%esp
}
  8024b8:	c9                   	leave  
  8024b9:	c3                   	ret    

008024ba <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8024ba:	55                   	push   %ebp
  8024bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8024bd:	6a 00                	push   $0x0
  8024bf:	6a 00                	push   $0x0
  8024c1:	6a 00                	push   $0x0
  8024c3:	6a 00                	push   $0x0
  8024c5:	ff 75 08             	pushl  0x8(%ebp)
  8024c8:	6a 0d                	push   $0xd
  8024ca:	e8 46 fe ff ff       	call   802315 <syscall>
  8024cf:	83 c4 18             	add    $0x18,%esp
}
  8024d2:	c9                   	leave  
  8024d3:	c3                   	ret    

008024d4 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8024d4:	55                   	push   %ebp
  8024d5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8024d7:	6a 00                	push   $0x0
  8024d9:	6a 00                	push   $0x0
  8024db:	6a 00                	push   $0x0
  8024dd:	6a 00                	push   $0x0
  8024df:	6a 00                	push   $0x0
  8024e1:	6a 0e                	push   $0xe
  8024e3:	e8 2d fe ff ff       	call   802315 <syscall>
  8024e8:	83 c4 18             	add    $0x18,%esp
}
  8024eb:	90                   	nop
  8024ec:	c9                   	leave  
  8024ed:	c3                   	ret    

008024ee <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8024ee:	55                   	push   %ebp
  8024ef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8024f1:	6a 00                	push   $0x0
  8024f3:	6a 00                	push   $0x0
  8024f5:	6a 00                	push   $0x0
  8024f7:	6a 00                	push   $0x0
  8024f9:	6a 00                	push   $0x0
  8024fb:	6a 13                	push   $0x13
  8024fd:	e8 13 fe ff ff       	call   802315 <syscall>
  802502:	83 c4 18             	add    $0x18,%esp
}
  802505:	90                   	nop
  802506:	c9                   	leave  
  802507:	c3                   	ret    

00802508 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802508:	55                   	push   %ebp
  802509:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80250b:	6a 00                	push   $0x0
  80250d:	6a 00                	push   $0x0
  80250f:	6a 00                	push   $0x0
  802511:	6a 00                	push   $0x0
  802513:	6a 00                	push   $0x0
  802515:	6a 14                	push   $0x14
  802517:	e8 f9 fd ff ff       	call   802315 <syscall>
  80251c:	83 c4 18             	add    $0x18,%esp
}
  80251f:	90                   	nop
  802520:	c9                   	leave  
  802521:	c3                   	ret    

00802522 <sys_cputc>:


void
sys_cputc(const char c)
{
  802522:	55                   	push   %ebp
  802523:	89 e5                	mov    %esp,%ebp
  802525:	83 ec 04             	sub    $0x4,%esp
  802528:	8b 45 08             	mov    0x8(%ebp),%eax
  80252b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80252e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802532:	6a 00                	push   $0x0
  802534:	6a 00                	push   $0x0
  802536:	6a 00                	push   $0x0
  802538:	6a 00                	push   $0x0
  80253a:	50                   	push   %eax
  80253b:	6a 15                	push   $0x15
  80253d:	e8 d3 fd ff ff       	call   802315 <syscall>
  802542:	83 c4 18             	add    $0x18,%esp
}
  802545:	90                   	nop
  802546:	c9                   	leave  
  802547:	c3                   	ret    

00802548 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802548:	55                   	push   %ebp
  802549:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80254b:	6a 00                	push   $0x0
  80254d:	6a 00                	push   $0x0
  80254f:	6a 00                	push   $0x0
  802551:	6a 00                	push   $0x0
  802553:	6a 00                	push   $0x0
  802555:	6a 16                	push   $0x16
  802557:	e8 b9 fd ff ff       	call   802315 <syscall>
  80255c:	83 c4 18             	add    $0x18,%esp
}
  80255f:	90                   	nop
  802560:	c9                   	leave  
  802561:	c3                   	ret    

00802562 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802562:	55                   	push   %ebp
  802563:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802565:	8b 45 08             	mov    0x8(%ebp),%eax
  802568:	6a 00                	push   $0x0
  80256a:	6a 00                	push   $0x0
  80256c:	6a 00                	push   $0x0
  80256e:	ff 75 0c             	pushl  0xc(%ebp)
  802571:	50                   	push   %eax
  802572:	6a 17                	push   $0x17
  802574:	e8 9c fd ff ff       	call   802315 <syscall>
  802579:	83 c4 18             	add    $0x18,%esp
}
  80257c:	c9                   	leave  
  80257d:	c3                   	ret    

0080257e <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80257e:	55                   	push   %ebp
  80257f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802581:	8b 55 0c             	mov    0xc(%ebp),%edx
  802584:	8b 45 08             	mov    0x8(%ebp),%eax
  802587:	6a 00                	push   $0x0
  802589:	6a 00                	push   $0x0
  80258b:	6a 00                	push   $0x0
  80258d:	52                   	push   %edx
  80258e:	50                   	push   %eax
  80258f:	6a 1a                	push   $0x1a
  802591:	e8 7f fd ff ff       	call   802315 <syscall>
  802596:	83 c4 18             	add    $0x18,%esp
}
  802599:	c9                   	leave  
  80259a:	c3                   	ret    

0080259b <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80259b:	55                   	push   %ebp
  80259c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80259e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a4:	6a 00                	push   $0x0
  8025a6:	6a 00                	push   $0x0
  8025a8:	6a 00                	push   $0x0
  8025aa:	52                   	push   %edx
  8025ab:	50                   	push   %eax
  8025ac:	6a 18                	push   $0x18
  8025ae:	e8 62 fd ff ff       	call   802315 <syscall>
  8025b3:	83 c4 18             	add    $0x18,%esp
}
  8025b6:	90                   	nop
  8025b7:	c9                   	leave  
  8025b8:	c3                   	ret    

008025b9 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8025b9:	55                   	push   %ebp
  8025ba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8025bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c2:	6a 00                	push   $0x0
  8025c4:	6a 00                	push   $0x0
  8025c6:	6a 00                	push   $0x0
  8025c8:	52                   	push   %edx
  8025c9:	50                   	push   %eax
  8025ca:	6a 19                	push   $0x19
  8025cc:	e8 44 fd ff ff       	call   802315 <syscall>
  8025d1:	83 c4 18             	add    $0x18,%esp
}
  8025d4:	90                   	nop
  8025d5:	c9                   	leave  
  8025d6:	c3                   	ret    

008025d7 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8025d7:	55                   	push   %ebp
  8025d8:	89 e5                	mov    %esp,%ebp
  8025da:	83 ec 04             	sub    $0x4,%esp
  8025dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8025e0:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8025e3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8025e6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8025ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ed:	6a 00                	push   $0x0
  8025ef:	51                   	push   %ecx
  8025f0:	52                   	push   %edx
  8025f1:	ff 75 0c             	pushl  0xc(%ebp)
  8025f4:	50                   	push   %eax
  8025f5:	6a 1b                	push   $0x1b
  8025f7:	e8 19 fd ff ff       	call   802315 <syscall>
  8025fc:	83 c4 18             	add    $0x18,%esp
}
  8025ff:	c9                   	leave  
  802600:	c3                   	ret    

00802601 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802601:	55                   	push   %ebp
  802602:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802604:	8b 55 0c             	mov    0xc(%ebp),%edx
  802607:	8b 45 08             	mov    0x8(%ebp),%eax
  80260a:	6a 00                	push   $0x0
  80260c:	6a 00                	push   $0x0
  80260e:	6a 00                	push   $0x0
  802610:	52                   	push   %edx
  802611:	50                   	push   %eax
  802612:	6a 1c                	push   $0x1c
  802614:	e8 fc fc ff ff       	call   802315 <syscall>
  802619:	83 c4 18             	add    $0x18,%esp
}
  80261c:	c9                   	leave  
  80261d:	c3                   	ret    

0080261e <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80261e:	55                   	push   %ebp
  80261f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802621:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802624:	8b 55 0c             	mov    0xc(%ebp),%edx
  802627:	8b 45 08             	mov    0x8(%ebp),%eax
  80262a:	6a 00                	push   $0x0
  80262c:	6a 00                	push   $0x0
  80262e:	51                   	push   %ecx
  80262f:	52                   	push   %edx
  802630:	50                   	push   %eax
  802631:	6a 1d                	push   $0x1d
  802633:	e8 dd fc ff ff       	call   802315 <syscall>
  802638:	83 c4 18             	add    $0x18,%esp
}
  80263b:	c9                   	leave  
  80263c:	c3                   	ret    

0080263d <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80263d:	55                   	push   %ebp
  80263e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802640:	8b 55 0c             	mov    0xc(%ebp),%edx
  802643:	8b 45 08             	mov    0x8(%ebp),%eax
  802646:	6a 00                	push   $0x0
  802648:	6a 00                	push   $0x0
  80264a:	6a 00                	push   $0x0
  80264c:	52                   	push   %edx
  80264d:	50                   	push   %eax
  80264e:	6a 1e                	push   $0x1e
  802650:	e8 c0 fc ff ff       	call   802315 <syscall>
  802655:	83 c4 18             	add    $0x18,%esp
}
  802658:	c9                   	leave  
  802659:	c3                   	ret    

0080265a <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80265a:	55                   	push   %ebp
  80265b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80265d:	6a 00                	push   $0x0
  80265f:	6a 00                	push   $0x0
  802661:	6a 00                	push   $0x0
  802663:	6a 00                	push   $0x0
  802665:	6a 00                	push   $0x0
  802667:	6a 1f                	push   $0x1f
  802669:	e8 a7 fc ff ff       	call   802315 <syscall>
  80266e:	83 c4 18             	add    $0x18,%esp
}
  802671:	c9                   	leave  
  802672:	c3                   	ret    

00802673 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802673:	55                   	push   %ebp
  802674:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802676:	8b 45 08             	mov    0x8(%ebp),%eax
  802679:	6a 00                	push   $0x0
  80267b:	ff 75 14             	pushl  0x14(%ebp)
  80267e:	ff 75 10             	pushl  0x10(%ebp)
  802681:	ff 75 0c             	pushl  0xc(%ebp)
  802684:	50                   	push   %eax
  802685:	6a 20                	push   $0x20
  802687:	e8 89 fc ff ff       	call   802315 <syscall>
  80268c:	83 c4 18             	add    $0x18,%esp
}
  80268f:	c9                   	leave  
  802690:	c3                   	ret    

00802691 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802691:	55                   	push   %ebp
  802692:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802694:	8b 45 08             	mov    0x8(%ebp),%eax
  802697:	6a 00                	push   $0x0
  802699:	6a 00                	push   $0x0
  80269b:	6a 00                	push   $0x0
  80269d:	6a 00                	push   $0x0
  80269f:	50                   	push   %eax
  8026a0:	6a 21                	push   $0x21
  8026a2:	e8 6e fc ff ff       	call   802315 <syscall>
  8026a7:	83 c4 18             	add    $0x18,%esp
}
  8026aa:	90                   	nop
  8026ab:	c9                   	leave  
  8026ac:	c3                   	ret    

008026ad <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8026ad:	55                   	push   %ebp
  8026ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8026b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b3:	6a 00                	push   $0x0
  8026b5:	6a 00                	push   $0x0
  8026b7:	6a 00                	push   $0x0
  8026b9:	6a 00                	push   $0x0
  8026bb:	50                   	push   %eax
  8026bc:	6a 22                	push   $0x22
  8026be:	e8 52 fc ff ff       	call   802315 <syscall>
  8026c3:	83 c4 18             	add    $0x18,%esp
}
  8026c6:	c9                   	leave  
  8026c7:	c3                   	ret    

008026c8 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8026c8:	55                   	push   %ebp
  8026c9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8026cb:	6a 00                	push   $0x0
  8026cd:	6a 00                	push   $0x0
  8026cf:	6a 00                	push   $0x0
  8026d1:	6a 00                	push   $0x0
  8026d3:	6a 00                	push   $0x0
  8026d5:	6a 02                	push   $0x2
  8026d7:	e8 39 fc ff ff       	call   802315 <syscall>
  8026dc:	83 c4 18             	add    $0x18,%esp
}
  8026df:	c9                   	leave  
  8026e0:	c3                   	ret    

008026e1 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8026e1:	55                   	push   %ebp
  8026e2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8026e4:	6a 00                	push   $0x0
  8026e6:	6a 00                	push   $0x0
  8026e8:	6a 00                	push   $0x0
  8026ea:	6a 00                	push   $0x0
  8026ec:	6a 00                	push   $0x0
  8026ee:	6a 03                	push   $0x3
  8026f0:	e8 20 fc ff ff       	call   802315 <syscall>
  8026f5:	83 c4 18             	add    $0x18,%esp
}
  8026f8:	c9                   	leave  
  8026f9:	c3                   	ret    

008026fa <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8026fa:	55                   	push   %ebp
  8026fb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8026fd:	6a 00                	push   $0x0
  8026ff:	6a 00                	push   $0x0
  802701:	6a 00                	push   $0x0
  802703:	6a 00                	push   $0x0
  802705:	6a 00                	push   $0x0
  802707:	6a 04                	push   $0x4
  802709:	e8 07 fc ff ff       	call   802315 <syscall>
  80270e:	83 c4 18             	add    $0x18,%esp
}
  802711:	c9                   	leave  
  802712:	c3                   	ret    

00802713 <sys_exit_env>:


void sys_exit_env(void)
{
  802713:	55                   	push   %ebp
  802714:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802716:	6a 00                	push   $0x0
  802718:	6a 00                	push   $0x0
  80271a:	6a 00                	push   $0x0
  80271c:	6a 00                	push   $0x0
  80271e:	6a 00                	push   $0x0
  802720:	6a 23                	push   $0x23
  802722:	e8 ee fb ff ff       	call   802315 <syscall>
  802727:	83 c4 18             	add    $0x18,%esp
}
  80272a:	90                   	nop
  80272b:	c9                   	leave  
  80272c:	c3                   	ret    

0080272d <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80272d:	55                   	push   %ebp
  80272e:	89 e5                	mov    %esp,%ebp
  802730:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802733:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802736:	8d 50 04             	lea    0x4(%eax),%edx
  802739:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80273c:	6a 00                	push   $0x0
  80273e:	6a 00                	push   $0x0
  802740:	6a 00                	push   $0x0
  802742:	52                   	push   %edx
  802743:	50                   	push   %eax
  802744:	6a 24                	push   $0x24
  802746:	e8 ca fb ff ff       	call   802315 <syscall>
  80274b:	83 c4 18             	add    $0x18,%esp
	return result;
  80274e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802751:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802754:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802757:	89 01                	mov    %eax,(%ecx)
  802759:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80275c:	8b 45 08             	mov    0x8(%ebp),%eax
  80275f:	c9                   	leave  
  802760:	c2 04 00             	ret    $0x4

00802763 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802763:	55                   	push   %ebp
  802764:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802766:	6a 00                	push   $0x0
  802768:	6a 00                	push   $0x0
  80276a:	ff 75 10             	pushl  0x10(%ebp)
  80276d:	ff 75 0c             	pushl  0xc(%ebp)
  802770:	ff 75 08             	pushl  0x8(%ebp)
  802773:	6a 12                	push   $0x12
  802775:	e8 9b fb ff ff       	call   802315 <syscall>
  80277a:	83 c4 18             	add    $0x18,%esp
	return ;
  80277d:	90                   	nop
}
  80277e:	c9                   	leave  
  80277f:	c3                   	ret    

00802780 <sys_rcr2>:
uint32 sys_rcr2()
{
  802780:	55                   	push   %ebp
  802781:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802783:	6a 00                	push   $0x0
  802785:	6a 00                	push   $0x0
  802787:	6a 00                	push   $0x0
  802789:	6a 00                	push   $0x0
  80278b:	6a 00                	push   $0x0
  80278d:	6a 25                	push   $0x25
  80278f:	e8 81 fb ff ff       	call   802315 <syscall>
  802794:	83 c4 18             	add    $0x18,%esp
}
  802797:	c9                   	leave  
  802798:	c3                   	ret    

00802799 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802799:	55                   	push   %ebp
  80279a:	89 e5                	mov    %esp,%ebp
  80279c:	83 ec 04             	sub    $0x4,%esp
  80279f:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8027a5:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8027a9:	6a 00                	push   $0x0
  8027ab:	6a 00                	push   $0x0
  8027ad:	6a 00                	push   $0x0
  8027af:	6a 00                	push   $0x0
  8027b1:	50                   	push   %eax
  8027b2:	6a 26                	push   $0x26
  8027b4:	e8 5c fb ff ff       	call   802315 <syscall>
  8027b9:	83 c4 18             	add    $0x18,%esp
	return ;
  8027bc:	90                   	nop
}
  8027bd:	c9                   	leave  
  8027be:	c3                   	ret    

008027bf <rsttst>:
void rsttst()
{
  8027bf:	55                   	push   %ebp
  8027c0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8027c2:	6a 00                	push   $0x0
  8027c4:	6a 00                	push   $0x0
  8027c6:	6a 00                	push   $0x0
  8027c8:	6a 00                	push   $0x0
  8027ca:	6a 00                	push   $0x0
  8027cc:	6a 28                	push   $0x28
  8027ce:	e8 42 fb ff ff       	call   802315 <syscall>
  8027d3:	83 c4 18             	add    $0x18,%esp
	return ;
  8027d6:	90                   	nop
}
  8027d7:	c9                   	leave  
  8027d8:	c3                   	ret    

008027d9 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8027d9:	55                   	push   %ebp
  8027da:	89 e5                	mov    %esp,%ebp
  8027dc:	83 ec 04             	sub    $0x4,%esp
  8027df:	8b 45 14             	mov    0x14(%ebp),%eax
  8027e2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8027e5:	8b 55 18             	mov    0x18(%ebp),%edx
  8027e8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8027ec:	52                   	push   %edx
  8027ed:	50                   	push   %eax
  8027ee:	ff 75 10             	pushl  0x10(%ebp)
  8027f1:	ff 75 0c             	pushl  0xc(%ebp)
  8027f4:	ff 75 08             	pushl  0x8(%ebp)
  8027f7:	6a 27                	push   $0x27
  8027f9:	e8 17 fb ff ff       	call   802315 <syscall>
  8027fe:	83 c4 18             	add    $0x18,%esp
	return ;
  802801:	90                   	nop
}
  802802:	c9                   	leave  
  802803:	c3                   	ret    

00802804 <chktst>:
void chktst(uint32 n)
{
  802804:	55                   	push   %ebp
  802805:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802807:	6a 00                	push   $0x0
  802809:	6a 00                	push   $0x0
  80280b:	6a 00                	push   $0x0
  80280d:	6a 00                	push   $0x0
  80280f:	ff 75 08             	pushl  0x8(%ebp)
  802812:	6a 29                	push   $0x29
  802814:	e8 fc fa ff ff       	call   802315 <syscall>
  802819:	83 c4 18             	add    $0x18,%esp
	return ;
  80281c:	90                   	nop
}
  80281d:	c9                   	leave  
  80281e:	c3                   	ret    

0080281f <inctst>:

void inctst()
{
  80281f:	55                   	push   %ebp
  802820:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802822:	6a 00                	push   $0x0
  802824:	6a 00                	push   $0x0
  802826:	6a 00                	push   $0x0
  802828:	6a 00                	push   $0x0
  80282a:	6a 00                	push   $0x0
  80282c:	6a 2a                	push   $0x2a
  80282e:	e8 e2 fa ff ff       	call   802315 <syscall>
  802833:	83 c4 18             	add    $0x18,%esp
	return ;
  802836:	90                   	nop
}
  802837:	c9                   	leave  
  802838:	c3                   	ret    

00802839 <gettst>:
uint32 gettst()
{
  802839:	55                   	push   %ebp
  80283a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80283c:	6a 00                	push   $0x0
  80283e:	6a 00                	push   $0x0
  802840:	6a 00                	push   $0x0
  802842:	6a 00                	push   $0x0
  802844:	6a 00                	push   $0x0
  802846:	6a 2b                	push   $0x2b
  802848:	e8 c8 fa ff ff       	call   802315 <syscall>
  80284d:	83 c4 18             	add    $0x18,%esp
}
  802850:	c9                   	leave  
  802851:	c3                   	ret    

00802852 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802852:	55                   	push   %ebp
  802853:	89 e5                	mov    %esp,%ebp
  802855:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802858:	6a 00                	push   $0x0
  80285a:	6a 00                	push   $0x0
  80285c:	6a 00                	push   $0x0
  80285e:	6a 00                	push   $0x0
  802860:	6a 00                	push   $0x0
  802862:	6a 2c                	push   $0x2c
  802864:	e8 ac fa ff ff       	call   802315 <syscall>
  802869:	83 c4 18             	add    $0x18,%esp
  80286c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80286f:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802873:	75 07                	jne    80287c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802875:	b8 01 00 00 00       	mov    $0x1,%eax
  80287a:	eb 05                	jmp    802881 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80287c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802881:	c9                   	leave  
  802882:	c3                   	ret    

00802883 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802883:	55                   	push   %ebp
  802884:	89 e5                	mov    %esp,%ebp
  802886:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802889:	6a 00                	push   $0x0
  80288b:	6a 00                	push   $0x0
  80288d:	6a 00                	push   $0x0
  80288f:	6a 00                	push   $0x0
  802891:	6a 00                	push   $0x0
  802893:	6a 2c                	push   $0x2c
  802895:	e8 7b fa ff ff       	call   802315 <syscall>
  80289a:	83 c4 18             	add    $0x18,%esp
  80289d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8028a0:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8028a4:	75 07                	jne    8028ad <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8028a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8028ab:	eb 05                	jmp    8028b2 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8028ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028b2:	c9                   	leave  
  8028b3:	c3                   	ret    

008028b4 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8028b4:	55                   	push   %ebp
  8028b5:	89 e5                	mov    %esp,%ebp
  8028b7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8028ba:	6a 00                	push   $0x0
  8028bc:	6a 00                	push   $0x0
  8028be:	6a 00                	push   $0x0
  8028c0:	6a 00                	push   $0x0
  8028c2:	6a 00                	push   $0x0
  8028c4:	6a 2c                	push   $0x2c
  8028c6:	e8 4a fa ff ff       	call   802315 <syscall>
  8028cb:	83 c4 18             	add    $0x18,%esp
  8028ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8028d1:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8028d5:	75 07                	jne    8028de <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8028d7:	b8 01 00 00 00       	mov    $0x1,%eax
  8028dc:	eb 05                	jmp    8028e3 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8028de:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028e3:	c9                   	leave  
  8028e4:	c3                   	ret    

008028e5 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8028e5:	55                   	push   %ebp
  8028e6:	89 e5                	mov    %esp,%ebp
  8028e8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8028eb:	6a 00                	push   $0x0
  8028ed:	6a 00                	push   $0x0
  8028ef:	6a 00                	push   $0x0
  8028f1:	6a 00                	push   $0x0
  8028f3:	6a 00                	push   $0x0
  8028f5:	6a 2c                	push   $0x2c
  8028f7:	e8 19 fa ff ff       	call   802315 <syscall>
  8028fc:	83 c4 18             	add    $0x18,%esp
  8028ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802902:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802906:	75 07                	jne    80290f <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802908:	b8 01 00 00 00       	mov    $0x1,%eax
  80290d:	eb 05                	jmp    802914 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80290f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802914:	c9                   	leave  
  802915:	c3                   	ret    

00802916 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802916:	55                   	push   %ebp
  802917:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802919:	6a 00                	push   $0x0
  80291b:	6a 00                	push   $0x0
  80291d:	6a 00                	push   $0x0
  80291f:	6a 00                	push   $0x0
  802921:	ff 75 08             	pushl  0x8(%ebp)
  802924:	6a 2d                	push   $0x2d
  802926:	e8 ea f9 ff ff       	call   802315 <syscall>
  80292b:	83 c4 18             	add    $0x18,%esp
	return ;
  80292e:	90                   	nop
}
  80292f:	c9                   	leave  
  802930:	c3                   	ret    

00802931 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802931:	55                   	push   %ebp
  802932:	89 e5                	mov    %esp,%ebp
  802934:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802935:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802938:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80293b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80293e:	8b 45 08             	mov    0x8(%ebp),%eax
  802941:	6a 00                	push   $0x0
  802943:	53                   	push   %ebx
  802944:	51                   	push   %ecx
  802945:	52                   	push   %edx
  802946:	50                   	push   %eax
  802947:	6a 2e                	push   $0x2e
  802949:	e8 c7 f9 ff ff       	call   802315 <syscall>
  80294e:	83 c4 18             	add    $0x18,%esp
}
  802951:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802954:	c9                   	leave  
  802955:	c3                   	ret    

00802956 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802956:	55                   	push   %ebp
  802957:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802959:	8b 55 0c             	mov    0xc(%ebp),%edx
  80295c:	8b 45 08             	mov    0x8(%ebp),%eax
  80295f:	6a 00                	push   $0x0
  802961:	6a 00                	push   $0x0
  802963:	6a 00                	push   $0x0
  802965:	52                   	push   %edx
  802966:	50                   	push   %eax
  802967:	6a 2f                	push   $0x2f
  802969:	e8 a7 f9 ff ff       	call   802315 <syscall>
  80296e:	83 c4 18             	add    $0x18,%esp
}
  802971:	c9                   	leave  
  802972:	c3                   	ret    

00802973 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802973:	55                   	push   %ebp
  802974:	89 e5                	mov    %esp,%ebp
  802976:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802979:	83 ec 0c             	sub    $0xc,%esp
  80297c:	68 dc 45 80 00       	push   $0x8045dc
  802981:	e8 21 e7 ff ff       	call   8010a7 <cprintf>
  802986:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802989:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802990:	83 ec 0c             	sub    $0xc,%esp
  802993:	68 08 46 80 00       	push   $0x804608
  802998:	e8 0a e7 ff ff       	call   8010a7 <cprintf>
  80299d:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8029a0:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8029a4:	a1 38 51 80 00       	mov    0x805138,%eax
  8029a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029ac:	eb 56                	jmp    802a04 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8029ae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029b2:	74 1c                	je     8029d0 <print_mem_block_lists+0x5d>
  8029b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b7:	8b 50 08             	mov    0x8(%eax),%edx
  8029ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029bd:	8b 48 08             	mov    0x8(%eax),%ecx
  8029c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8029c6:	01 c8                	add    %ecx,%eax
  8029c8:	39 c2                	cmp    %eax,%edx
  8029ca:	73 04                	jae    8029d0 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8029cc:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8029d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d3:	8b 50 08             	mov    0x8(%eax),%edx
  8029d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8029dc:	01 c2                	add    %eax,%edx
  8029de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e1:	8b 40 08             	mov    0x8(%eax),%eax
  8029e4:	83 ec 04             	sub    $0x4,%esp
  8029e7:	52                   	push   %edx
  8029e8:	50                   	push   %eax
  8029e9:	68 1d 46 80 00       	push   $0x80461d
  8029ee:	e8 b4 e6 ff ff       	call   8010a7 <cprintf>
  8029f3:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8029f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8029fc:	a1 40 51 80 00       	mov    0x805140,%eax
  802a01:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a04:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a08:	74 07                	je     802a11 <print_mem_block_lists+0x9e>
  802a0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0d:	8b 00                	mov    (%eax),%eax
  802a0f:	eb 05                	jmp    802a16 <print_mem_block_lists+0xa3>
  802a11:	b8 00 00 00 00       	mov    $0x0,%eax
  802a16:	a3 40 51 80 00       	mov    %eax,0x805140
  802a1b:	a1 40 51 80 00       	mov    0x805140,%eax
  802a20:	85 c0                	test   %eax,%eax
  802a22:	75 8a                	jne    8029ae <print_mem_block_lists+0x3b>
  802a24:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a28:	75 84                	jne    8029ae <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802a2a:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802a2e:	75 10                	jne    802a40 <print_mem_block_lists+0xcd>
  802a30:	83 ec 0c             	sub    $0xc,%esp
  802a33:	68 2c 46 80 00       	push   $0x80462c
  802a38:	e8 6a e6 ff ff       	call   8010a7 <cprintf>
  802a3d:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802a40:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802a47:	83 ec 0c             	sub    $0xc,%esp
  802a4a:	68 50 46 80 00       	push   $0x804650
  802a4f:	e8 53 e6 ff ff       	call   8010a7 <cprintf>
  802a54:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802a57:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802a5b:	a1 40 50 80 00       	mov    0x805040,%eax
  802a60:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a63:	eb 56                	jmp    802abb <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802a65:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a69:	74 1c                	je     802a87 <print_mem_block_lists+0x114>
  802a6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6e:	8b 50 08             	mov    0x8(%eax),%edx
  802a71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a74:	8b 48 08             	mov    0x8(%eax),%ecx
  802a77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a7a:	8b 40 0c             	mov    0xc(%eax),%eax
  802a7d:	01 c8                	add    %ecx,%eax
  802a7f:	39 c2                	cmp    %eax,%edx
  802a81:	73 04                	jae    802a87 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802a83:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802a87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8a:	8b 50 08             	mov    0x8(%eax),%edx
  802a8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a90:	8b 40 0c             	mov    0xc(%eax),%eax
  802a93:	01 c2                	add    %eax,%edx
  802a95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a98:	8b 40 08             	mov    0x8(%eax),%eax
  802a9b:	83 ec 04             	sub    $0x4,%esp
  802a9e:	52                   	push   %edx
  802a9f:	50                   	push   %eax
  802aa0:	68 1d 46 80 00       	push   $0x80461d
  802aa5:	e8 fd e5 ff ff       	call   8010a7 <cprintf>
  802aaa:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802aad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802ab3:	a1 48 50 80 00       	mov    0x805048,%eax
  802ab8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802abb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802abf:	74 07                	je     802ac8 <print_mem_block_lists+0x155>
  802ac1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac4:	8b 00                	mov    (%eax),%eax
  802ac6:	eb 05                	jmp    802acd <print_mem_block_lists+0x15a>
  802ac8:	b8 00 00 00 00       	mov    $0x0,%eax
  802acd:	a3 48 50 80 00       	mov    %eax,0x805048
  802ad2:	a1 48 50 80 00       	mov    0x805048,%eax
  802ad7:	85 c0                	test   %eax,%eax
  802ad9:	75 8a                	jne    802a65 <print_mem_block_lists+0xf2>
  802adb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802adf:	75 84                	jne    802a65 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802ae1:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802ae5:	75 10                	jne    802af7 <print_mem_block_lists+0x184>
  802ae7:	83 ec 0c             	sub    $0xc,%esp
  802aea:	68 68 46 80 00       	push   $0x804668
  802aef:	e8 b3 e5 ff ff       	call   8010a7 <cprintf>
  802af4:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802af7:	83 ec 0c             	sub    $0xc,%esp
  802afa:	68 dc 45 80 00       	push   $0x8045dc
  802aff:	e8 a3 e5 ff ff       	call   8010a7 <cprintf>
  802b04:	83 c4 10             	add    $0x10,%esp

}
  802b07:	90                   	nop
  802b08:	c9                   	leave  
  802b09:	c3                   	ret    

00802b0a <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802b0a:	55                   	push   %ebp
  802b0b:	89 e5                	mov    %esp,%ebp
  802b0d:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  802b10:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802b17:	00 00 00 
  802b1a:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802b21:	00 00 00 
  802b24:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802b2b:	00 00 00 
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  802b2e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802b35:	e9 9e 00 00 00       	jmp    802bd8 <initialize_MemBlocksList+0xce>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
  802b3a:	a1 50 50 80 00       	mov    0x805050,%eax
  802b3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b42:	c1 e2 04             	shl    $0x4,%edx
  802b45:	01 d0                	add    %edx,%eax
  802b47:	85 c0                	test   %eax,%eax
  802b49:	75 14                	jne    802b5f <initialize_MemBlocksList+0x55>
  802b4b:	83 ec 04             	sub    $0x4,%esp
  802b4e:	68 90 46 80 00       	push   $0x804690
  802b53:	6a 43                	push   $0x43
  802b55:	68 b3 46 80 00       	push   $0x8046b3
  802b5a:	e8 94 e2 ff ff       	call   800df3 <_panic>
  802b5f:	a1 50 50 80 00       	mov    0x805050,%eax
  802b64:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b67:	c1 e2 04             	shl    $0x4,%edx
  802b6a:	01 d0                	add    %edx,%eax
  802b6c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802b72:	89 10                	mov    %edx,(%eax)
  802b74:	8b 00                	mov    (%eax),%eax
  802b76:	85 c0                	test   %eax,%eax
  802b78:	74 18                	je     802b92 <initialize_MemBlocksList+0x88>
  802b7a:	a1 48 51 80 00       	mov    0x805148,%eax
  802b7f:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802b85:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802b88:	c1 e1 04             	shl    $0x4,%ecx
  802b8b:	01 ca                	add    %ecx,%edx
  802b8d:	89 50 04             	mov    %edx,0x4(%eax)
  802b90:	eb 12                	jmp    802ba4 <initialize_MemBlocksList+0x9a>
  802b92:	a1 50 50 80 00       	mov    0x805050,%eax
  802b97:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b9a:	c1 e2 04             	shl    $0x4,%edx
  802b9d:	01 d0                	add    %edx,%eax
  802b9f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ba4:	a1 50 50 80 00       	mov    0x805050,%eax
  802ba9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bac:	c1 e2 04             	shl    $0x4,%edx
  802baf:	01 d0                	add    %edx,%eax
  802bb1:	a3 48 51 80 00       	mov    %eax,0x805148
  802bb6:	a1 50 50 80 00       	mov    0x805050,%eax
  802bbb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bbe:	c1 e2 04             	shl    $0x4,%edx
  802bc1:	01 d0                	add    %edx,%eax
  802bc3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bca:	a1 54 51 80 00       	mov    0x805154,%eax
  802bcf:	40                   	inc    %eax
  802bd0:	a3 54 51 80 00       	mov    %eax,0x805154
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  802bd5:	ff 45 f4             	incl   -0xc(%ebp)
  802bd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bdb:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bde:	0f 82 56 ff ff ff    	jb     802b3a <initialize_MemBlocksList+0x30>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
		}
}
  802be4:	90                   	nop
  802be5:	c9                   	leave  
  802be6:	c3                   	ret    

00802be7 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802be7:	55                   	push   %ebp
  802be8:	89 e5                	mov    %esp,%ebp
  802bea:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  802bed:	a1 38 51 80 00       	mov    0x805138,%eax
  802bf2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802bf5:	eb 18                	jmp    802c0f <find_block+0x28>
	{
		if (ele->sva==va)
  802bf7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802bfa:	8b 40 08             	mov    0x8(%eax),%eax
  802bfd:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802c00:	75 05                	jne    802c07 <find_block+0x20>
			return ele;
  802c02:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802c05:	eb 7b                	jmp    802c82 <find_block+0x9b>
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  802c07:	a1 40 51 80 00       	mov    0x805140,%eax
  802c0c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802c0f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802c13:	74 07                	je     802c1c <find_block+0x35>
  802c15:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802c18:	8b 00                	mov    (%eax),%eax
  802c1a:	eb 05                	jmp    802c21 <find_block+0x3a>
  802c1c:	b8 00 00 00 00       	mov    $0x0,%eax
  802c21:	a3 40 51 80 00       	mov    %eax,0x805140
  802c26:	a1 40 51 80 00       	mov    0x805140,%eax
  802c2b:	85 c0                	test   %eax,%eax
  802c2d:	75 c8                	jne    802bf7 <find_block+0x10>
  802c2f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802c33:	75 c2                	jne    802bf7 <find_block+0x10>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  802c35:	a1 40 50 80 00       	mov    0x805040,%eax
  802c3a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802c3d:	eb 18                	jmp    802c57 <find_block+0x70>
	{
		if (ele->sva==va)
  802c3f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802c42:	8b 40 08             	mov    0x8(%eax),%eax
  802c45:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802c48:	75 05                	jne    802c4f <find_block+0x68>
					return ele;
  802c4a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802c4d:	eb 33                	jmp    802c82 <find_block+0x9b>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  802c4f:	a1 48 50 80 00       	mov    0x805048,%eax
  802c54:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802c57:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802c5b:	74 07                	je     802c64 <find_block+0x7d>
  802c5d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802c60:	8b 00                	mov    (%eax),%eax
  802c62:	eb 05                	jmp    802c69 <find_block+0x82>
  802c64:	b8 00 00 00 00       	mov    $0x0,%eax
  802c69:	a3 48 50 80 00       	mov    %eax,0x805048
  802c6e:	a1 48 50 80 00       	mov    0x805048,%eax
  802c73:	85 c0                	test   %eax,%eax
  802c75:	75 c8                	jne    802c3f <find_block+0x58>
  802c77:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802c7b:	75 c2                	jne    802c3f <find_block+0x58>
	{
		if (ele->sva==va)
					return ele;
	}
return NULL;
  802c7d:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802c82:	c9                   	leave  
  802c83:	c3                   	ret    

00802c84 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802c84:	55                   	push   %ebp
  802c85:	89 e5                	mov    %esp,%ebp
  802c87:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;

int x =LIST_SIZE(&AllocMemBlocksList);
  802c8a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802c8f:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((x==0))
  802c92:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c96:	75 62                	jne    802cfa <insert_sorted_allocList+0x76>
	{
	//	blockToInsert=AllocMemBlocksList.lh_first;
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  802c98:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c9c:	75 14                	jne    802cb2 <insert_sorted_allocList+0x2e>
  802c9e:	83 ec 04             	sub    $0x4,%esp
  802ca1:	68 90 46 80 00       	push   $0x804690
  802ca6:	6a 69                	push   $0x69
  802ca8:	68 b3 46 80 00       	push   $0x8046b3
  802cad:	e8 41 e1 ff ff       	call   800df3 <_panic>
  802cb2:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbb:	89 10                	mov    %edx,(%eax)
  802cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc0:	8b 00                	mov    (%eax),%eax
  802cc2:	85 c0                	test   %eax,%eax
  802cc4:	74 0d                	je     802cd3 <insert_sorted_allocList+0x4f>
  802cc6:	a1 40 50 80 00       	mov    0x805040,%eax
  802ccb:	8b 55 08             	mov    0x8(%ebp),%edx
  802cce:	89 50 04             	mov    %edx,0x4(%eax)
  802cd1:	eb 08                	jmp    802cdb <insert_sorted_allocList+0x57>
  802cd3:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd6:	a3 44 50 80 00       	mov    %eax,0x805044
  802cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cde:	a3 40 50 80 00       	mov    %eax,0x805040
  802ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ced:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802cf2:	40                   	inc    %eax
  802cf3:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802cf8:	eb 72                	jmp    802d6c <insert_sorted_allocList+0xe8>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
  802cfa:	a1 40 50 80 00       	mov    0x805040,%eax
  802cff:	8b 50 08             	mov    0x8(%eax),%edx
  802d02:	8b 45 08             	mov    0x8(%ebp),%eax
  802d05:	8b 40 08             	mov    0x8(%eax),%eax
  802d08:	39 c2                	cmp    %eax,%edx
  802d0a:	76 60                	jbe    802d6c <insert_sorted_allocList+0xe8>
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  802d0c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d10:	75 14                	jne    802d26 <insert_sorted_allocList+0xa2>
  802d12:	83 ec 04             	sub    $0x4,%esp
  802d15:	68 90 46 80 00       	push   $0x804690
  802d1a:	6a 6d                	push   $0x6d
  802d1c:	68 b3 46 80 00       	push   $0x8046b3
  802d21:	e8 cd e0 ff ff       	call   800df3 <_panic>
  802d26:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2f:	89 10                	mov    %edx,(%eax)
  802d31:	8b 45 08             	mov    0x8(%ebp),%eax
  802d34:	8b 00                	mov    (%eax),%eax
  802d36:	85 c0                	test   %eax,%eax
  802d38:	74 0d                	je     802d47 <insert_sorted_allocList+0xc3>
  802d3a:	a1 40 50 80 00       	mov    0x805040,%eax
  802d3f:	8b 55 08             	mov    0x8(%ebp),%edx
  802d42:	89 50 04             	mov    %edx,0x4(%eax)
  802d45:	eb 08                	jmp    802d4f <insert_sorted_allocList+0xcb>
  802d47:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4a:	a3 44 50 80 00       	mov    %eax,0x805044
  802d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d52:	a3 40 50 80 00       	mov    %eax,0x805040
  802d57:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d61:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802d66:	40                   	inc    %eax
  802d67:	a3 4c 50 80 00       	mov    %eax,0x80504c
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  802d6c:	a1 40 50 80 00       	mov    0x805040,%eax
  802d71:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d74:	e9 b9 01 00 00       	jmp    802f32 <insert_sorted_allocList+0x2ae>
	{


		if ((blockToInsert->sva>AllocMemBlocksList.lh_first->sva)&&blockToInsert->sva<element->sva)
  802d79:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7c:	8b 50 08             	mov    0x8(%eax),%edx
  802d7f:	a1 40 50 80 00       	mov    0x805040,%eax
  802d84:	8b 40 08             	mov    0x8(%eax),%eax
  802d87:	39 c2                	cmp    %eax,%edx
  802d89:	76 7c                	jbe    802e07 <insert_sorted_allocList+0x183>
  802d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8e:	8b 50 08             	mov    0x8(%eax),%edx
  802d91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d94:	8b 40 08             	mov    0x8(%eax),%eax
  802d97:	39 c2                	cmp    %eax,%edx
  802d99:	73 6c                	jae    802e07 <insert_sorted_allocList+0x183>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,element,blockToInsert);
  802d9b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d9f:	74 06                	je     802da7 <insert_sorted_allocList+0x123>
  802da1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802da5:	75 14                	jne    802dbb <insert_sorted_allocList+0x137>
  802da7:	83 ec 04             	sub    $0x4,%esp
  802daa:	68 cc 46 80 00       	push   $0x8046cc
  802daf:	6a 75                	push   $0x75
  802db1:	68 b3 46 80 00       	push   $0x8046b3
  802db6:	e8 38 e0 ff ff       	call   800df3 <_panic>
  802dbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbe:	8b 50 04             	mov    0x4(%eax),%edx
  802dc1:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc4:	89 50 04             	mov    %edx,0x4(%eax)
  802dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dcd:	89 10                	mov    %edx,(%eax)
  802dcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd2:	8b 40 04             	mov    0x4(%eax),%eax
  802dd5:	85 c0                	test   %eax,%eax
  802dd7:	74 0d                	je     802de6 <insert_sorted_allocList+0x162>
  802dd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ddc:	8b 40 04             	mov    0x4(%eax),%eax
  802ddf:	8b 55 08             	mov    0x8(%ebp),%edx
  802de2:	89 10                	mov    %edx,(%eax)
  802de4:	eb 08                	jmp    802dee <insert_sorted_allocList+0x16a>
  802de6:	8b 45 08             	mov    0x8(%ebp),%eax
  802de9:	a3 40 50 80 00       	mov    %eax,0x805040
  802dee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df1:	8b 55 08             	mov    0x8(%ebp),%edx
  802df4:	89 50 04             	mov    %edx,0x4(%eax)
  802df7:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802dfc:	40                   	inc    %eax
  802dfd:	a3 4c 50 80 00       	mov    %eax,0x80504c

		break;}
  802e02:	e9 59 01 00 00       	jmp    802f60 <insert_sorted_allocList+0x2dc>

	else if ((blockToInsert->sva>element->sva)&&(blockToInsert->sva<AllocMemBlocksList.lh_last->sva)&&blockToInsert->sva<LIST_NEXT(element)->sva)
  802e07:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0a:	8b 50 08             	mov    0x8(%eax),%edx
  802e0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e10:	8b 40 08             	mov    0x8(%eax),%eax
  802e13:	39 c2                	cmp    %eax,%edx
  802e15:	0f 86 98 00 00 00    	jbe    802eb3 <insert_sorted_allocList+0x22f>
  802e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1e:	8b 50 08             	mov    0x8(%eax),%edx
  802e21:	a1 44 50 80 00       	mov    0x805044,%eax
  802e26:	8b 40 08             	mov    0x8(%eax),%eax
  802e29:	39 c2                	cmp    %eax,%edx
  802e2b:	0f 83 82 00 00 00    	jae    802eb3 <insert_sorted_allocList+0x22f>
  802e31:	8b 45 08             	mov    0x8(%ebp),%eax
  802e34:	8b 50 08             	mov    0x8(%eax),%edx
  802e37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3a:	8b 00                	mov    (%eax),%eax
  802e3c:	8b 40 08             	mov    0x8(%eax),%eax
  802e3f:	39 c2                	cmp    %eax,%edx
  802e41:	73 70                	jae    802eb3 <insert_sorted_allocList+0x22f>
	{

	LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  802e43:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e47:	74 06                	je     802e4f <insert_sorted_allocList+0x1cb>
  802e49:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e4d:	75 14                	jne    802e63 <insert_sorted_allocList+0x1df>
  802e4f:	83 ec 04             	sub    $0x4,%esp
  802e52:	68 04 47 80 00       	push   $0x804704
  802e57:	6a 7c                	push   $0x7c
  802e59:	68 b3 46 80 00       	push   $0x8046b3
  802e5e:	e8 90 df ff ff       	call   800df3 <_panic>
  802e63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e66:	8b 10                	mov    (%eax),%edx
  802e68:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6b:	89 10                	mov    %edx,(%eax)
  802e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e70:	8b 00                	mov    (%eax),%eax
  802e72:	85 c0                	test   %eax,%eax
  802e74:	74 0b                	je     802e81 <insert_sorted_allocList+0x1fd>
  802e76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e79:	8b 00                	mov    (%eax),%eax
  802e7b:	8b 55 08             	mov    0x8(%ebp),%edx
  802e7e:	89 50 04             	mov    %edx,0x4(%eax)
  802e81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e84:	8b 55 08             	mov    0x8(%ebp),%edx
  802e87:	89 10                	mov    %edx,(%eax)
  802e89:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e8f:	89 50 04             	mov    %edx,0x4(%eax)
  802e92:	8b 45 08             	mov    0x8(%ebp),%eax
  802e95:	8b 00                	mov    (%eax),%eax
  802e97:	85 c0                	test   %eax,%eax
  802e99:	75 08                	jne    802ea3 <insert_sorted_allocList+0x21f>
  802e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9e:	a3 44 50 80 00       	mov    %eax,0x805044
  802ea3:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802ea8:	40                   	inc    %eax
  802ea9:	a3 4c 50 80 00       	mov    %eax,0x80504c
		break;
  802eae:	e9 ad 00 00 00       	jmp    802f60 <insert_sorted_allocList+0x2dc>
	}else if (blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  802eb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb6:	8b 50 08             	mov    0x8(%eax),%edx
  802eb9:	a1 44 50 80 00       	mov    0x805044,%eax
  802ebe:	8b 40 08             	mov    0x8(%eax),%eax
  802ec1:	39 c2                	cmp    %eax,%edx
  802ec3:	76 65                	jbe    802f2a <insert_sorted_allocList+0x2a6>
	{
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
  802ec5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ec9:	75 17                	jne    802ee2 <insert_sorted_allocList+0x25e>
  802ecb:	83 ec 04             	sub    $0x4,%esp
  802ece:	68 38 47 80 00       	push   $0x804738
  802ed3:	68 80 00 00 00       	push   $0x80
  802ed8:	68 b3 46 80 00       	push   $0x8046b3
  802edd:	e8 11 df ff ff       	call   800df3 <_panic>
  802ee2:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  802eeb:	89 50 04             	mov    %edx,0x4(%eax)
  802eee:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef1:	8b 40 04             	mov    0x4(%eax),%eax
  802ef4:	85 c0                	test   %eax,%eax
  802ef6:	74 0c                	je     802f04 <insert_sorted_allocList+0x280>
  802ef8:	a1 44 50 80 00       	mov    0x805044,%eax
  802efd:	8b 55 08             	mov    0x8(%ebp),%edx
  802f00:	89 10                	mov    %edx,(%eax)
  802f02:	eb 08                	jmp    802f0c <insert_sorted_allocList+0x288>
  802f04:	8b 45 08             	mov    0x8(%ebp),%eax
  802f07:	a3 40 50 80 00       	mov    %eax,0x805040
  802f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0f:	a3 44 50 80 00       	mov    %eax,0x805044
  802f14:	8b 45 08             	mov    0x8(%ebp),%eax
  802f17:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f1d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802f22:	40                   	inc    %eax
  802f23:	a3 4c 50 80 00       	mov    %eax,0x80504c
		break;
  802f28:	eb 36                	jmp    802f60 <insert_sorted_allocList+0x2dc>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  802f2a:	a1 48 50 80 00       	mov    0x805048,%eax
  802f2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f36:	74 07                	je     802f3f <insert_sorted_allocList+0x2bb>
  802f38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3b:	8b 00                	mov    (%eax),%eax
  802f3d:	eb 05                	jmp    802f44 <insert_sorted_allocList+0x2c0>
  802f3f:	b8 00 00 00 00       	mov    $0x0,%eax
  802f44:	a3 48 50 80 00       	mov    %eax,0x805048
  802f49:	a1 48 50 80 00       	mov    0x805048,%eax
  802f4e:	85 c0                	test   %eax,%eax
  802f50:	0f 85 23 fe ff ff    	jne    802d79 <insert_sorted_allocList+0xf5>
  802f56:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f5a:	0f 85 19 fe ff ff    	jne    802d79 <insert_sorted_allocList+0xf5>
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
		break;

	}
	}
}
  802f60:	90                   	nop
  802f61:	c9                   	leave  
  802f62:	c3                   	ret    

00802f63 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802f63:	55                   	push   %ebp
  802f64:	89 e5                	mov    %esp,%ebp
  802f66:	83 ec 18             	sub    $0x18,%esp
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802f69:	a1 38 51 80 00       	mov    0x805138,%eax
  802f6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f71:	e9 7c 01 00 00       	jmp    8030f2 <alloc_block_FF+0x18f>
		{
			// case 2
				if(element->size == size)
  802f76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f79:	8b 40 0c             	mov    0xc(%eax),%eax
  802f7c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f7f:	0f 85 90 00 00 00    	jne    803015 <alloc_block_FF+0xb2>
				{
					tmp_block=element;
  802f85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f88:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,element);
  802f8b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f8f:	75 17                	jne    802fa8 <alloc_block_FF+0x45>
  802f91:	83 ec 04             	sub    $0x4,%esp
  802f94:	68 5b 47 80 00       	push   $0x80475b
  802f99:	68 ba 00 00 00       	push   $0xba
  802f9e:	68 b3 46 80 00       	push   $0x8046b3
  802fa3:	e8 4b de ff ff       	call   800df3 <_panic>
  802fa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fab:	8b 00                	mov    (%eax),%eax
  802fad:	85 c0                	test   %eax,%eax
  802faf:	74 10                	je     802fc1 <alloc_block_FF+0x5e>
  802fb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb4:	8b 00                	mov    (%eax),%eax
  802fb6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fb9:	8b 52 04             	mov    0x4(%edx),%edx
  802fbc:	89 50 04             	mov    %edx,0x4(%eax)
  802fbf:	eb 0b                	jmp    802fcc <alloc_block_FF+0x69>
  802fc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc4:	8b 40 04             	mov    0x4(%eax),%eax
  802fc7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fcf:	8b 40 04             	mov    0x4(%eax),%eax
  802fd2:	85 c0                	test   %eax,%eax
  802fd4:	74 0f                	je     802fe5 <alloc_block_FF+0x82>
  802fd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd9:	8b 40 04             	mov    0x4(%eax),%eax
  802fdc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fdf:	8b 12                	mov    (%edx),%edx
  802fe1:	89 10                	mov    %edx,(%eax)
  802fe3:	eb 0a                	jmp    802fef <alloc_block_FF+0x8c>
  802fe5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe8:	8b 00                	mov    (%eax),%eax
  802fea:	a3 38 51 80 00       	mov    %eax,0x805138
  802fef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ff8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ffb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803002:	a1 44 51 80 00       	mov    0x805144,%eax
  803007:	48                   	dec    %eax
  803008:	a3 44 51 80 00       	mov    %eax,0x805144
					return tmp_block;
  80300d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803010:	e9 10 01 00 00       	jmp    803125 <alloc_block_FF+0x1c2>
				}
				 // case 3
				else if(element->size > size)
  803015:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803018:	8b 40 0c             	mov    0xc(%eax),%eax
  80301b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80301e:	0f 86 c6 00 00 00    	jbe    8030ea <alloc_block_FF+0x187>
				{
					// the new block are created
					tmp_block = AvailableMemBlocksList.lh_first ;
  803024:	a1 48 51 80 00       	mov    0x805148,%eax
  803029:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  80302c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803030:	75 17                	jne    803049 <alloc_block_FF+0xe6>
  803032:	83 ec 04             	sub    $0x4,%esp
  803035:	68 5b 47 80 00       	push   $0x80475b
  80303a:	68 c2 00 00 00       	push   $0xc2
  80303f:	68 b3 46 80 00       	push   $0x8046b3
  803044:	e8 aa dd ff ff       	call   800df3 <_panic>
  803049:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80304c:	8b 00                	mov    (%eax),%eax
  80304e:	85 c0                	test   %eax,%eax
  803050:	74 10                	je     803062 <alloc_block_FF+0xff>
  803052:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803055:	8b 00                	mov    (%eax),%eax
  803057:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80305a:	8b 52 04             	mov    0x4(%edx),%edx
  80305d:	89 50 04             	mov    %edx,0x4(%eax)
  803060:	eb 0b                	jmp    80306d <alloc_block_FF+0x10a>
  803062:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803065:	8b 40 04             	mov    0x4(%eax),%eax
  803068:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80306d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803070:	8b 40 04             	mov    0x4(%eax),%eax
  803073:	85 c0                	test   %eax,%eax
  803075:	74 0f                	je     803086 <alloc_block_FF+0x123>
  803077:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80307a:	8b 40 04             	mov    0x4(%eax),%eax
  80307d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803080:	8b 12                	mov    (%edx),%edx
  803082:	89 10                	mov    %edx,(%eax)
  803084:	eb 0a                	jmp    803090 <alloc_block_FF+0x12d>
  803086:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803089:	8b 00                	mov    (%eax),%eax
  80308b:	a3 48 51 80 00       	mov    %eax,0x805148
  803090:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803093:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803099:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80309c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030a3:	a1 54 51 80 00       	mov    0x805154,%eax
  8030a8:	48                   	dec    %eax
  8030a9:	a3 54 51 80 00       	mov    %eax,0x805154
					tmp_block->sva=element->sva;
  8030ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b1:	8b 50 08             	mov    0x8(%eax),%edx
  8030b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030b7:	89 50 08             	mov    %edx,0x8(%eax)
					tmp_block->size=size;
  8030ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8030c0:	89 50 0c             	mov    %edx,0xc(%eax)
					//update block with remaining space
					element->size-=size;
  8030c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8030c9:	2b 45 08             	sub    0x8(%ebp),%eax
  8030cc:	89 c2                	mov    %eax,%edx
  8030ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d1:	89 50 0c             	mov    %edx,0xc(%eax)
					element->sva = element->sva + size;
  8030d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d7:	8b 50 08             	mov    0x8(%eax),%edx
  8030da:	8b 45 08             	mov    0x8(%ebp),%eax
  8030dd:	01 c2                	add    %eax,%edx
  8030df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e2:	89 50 08             	mov    %edx,0x8(%eax)
					// return back the new block
					return tmp_block ;
  8030e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030e8:	eb 3b                	jmp    803125 <alloc_block_FF+0x1c2>
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  8030ea:	a1 40 51 80 00       	mov    0x805140,%eax
  8030ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030f6:	74 07                	je     8030ff <alloc_block_FF+0x19c>
  8030f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030fb:	8b 00                	mov    (%eax),%eax
  8030fd:	eb 05                	jmp    803104 <alloc_block_FF+0x1a1>
  8030ff:	b8 00 00 00 00       	mov    $0x0,%eax
  803104:	a3 40 51 80 00       	mov    %eax,0x805140
  803109:	a1 40 51 80 00       	mov    0x805140,%eax
  80310e:	85 c0                	test   %eax,%eax
  803110:	0f 85 60 fe ff ff    	jne    802f76 <alloc_block_FF+0x13>
  803116:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80311a:	0f 85 56 fe ff ff    	jne    802f76 <alloc_block_FF+0x13>
					// return back the new block
					return tmp_block ;
				}
		}
		// case 1
	  return NULL ;}
  803120:	b8 00 00 00 00       	mov    $0x0,%eax
  803125:	c9                   	leave  
  803126:	c3                   	ret    

00803127 <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================

struct MemBlock *alloc_block_BF(uint32 size)
{
  803127:	55                   	push   %ebp
  803128:	89 e5                	mov    %esp,%ebp
  80312a:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
  80312d:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		LIST_FOREACH(element, &(FreeMemBlocksList))
  803134:	a1 38 51 80 00       	mov    0x805138,%eax
  803139:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80313c:	eb 3a                	jmp    803178 <alloc_block_BF+0x51>
		{
			if(element->size >= size)
  80313e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803141:	8b 40 0c             	mov    0xc(%eax),%eax
  803144:	3b 45 08             	cmp    0x8(%ebp),%eax
  803147:	72 27                	jb     803170 <alloc_block_BF+0x49>
			{
				if(best_size==-1)
  803149:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80314d:	75 0b                	jne    80315a <alloc_block_BF+0x33>
					best_size= element->size;
  80314f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803152:	8b 40 0c             	mov    0xc(%eax),%eax
  803155:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803158:	eb 16                	jmp    803170 <alloc_block_BF+0x49>
				else if(best_size >= element->size)
  80315a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80315d:	8b 50 0c             	mov    0xc(%eax),%edx
  803160:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803163:	39 c2                	cmp    %eax,%edx
  803165:	77 09                	ja     803170 <alloc_block_BF+0x49>
					best_size=element->size;
  803167:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316a:	8b 40 0c             	mov    0xc(%eax),%eax
  80316d:	89 45 f0             	mov    %eax,-0x10(%ebp)

struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  803170:	a1 40 51 80 00       	mov    0x805140,%eax
  803175:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803178:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80317c:	74 07                	je     803185 <alloc_block_BF+0x5e>
  80317e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803181:	8b 00                	mov    (%eax),%eax
  803183:	eb 05                	jmp    80318a <alloc_block_BF+0x63>
  803185:	b8 00 00 00 00       	mov    $0x0,%eax
  80318a:	a3 40 51 80 00       	mov    %eax,0x805140
  80318f:	a1 40 51 80 00       	mov    0x805140,%eax
  803194:	85 c0                	test   %eax,%eax
  803196:	75 a6                	jne    80313e <alloc_block_BF+0x17>
  803198:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80319c:	75 a0                	jne    80313e <alloc_block_BF+0x17>
					best_size= element->size;
				else if(best_size >= element->size)
					best_size=element->size;
			}
		}
		if(best_size != -1)
  80319e:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8031a2:	0f 84 d3 01 00 00    	je     80337b <alloc_block_BF+0x254>
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  8031a8:	a1 38 51 80 00       	mov    0x805138,%eax
  8031ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031b0:	e9 98 01 00 00       	jmp    80334d <alloc_block_BF+0x226>
			{
			 if((best_size > size) && (best_size == element->size))
  8031b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031b8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031bb:	0f 86 da 00 00 00    	jbe    80329b <alloc_block_BF+0x174>
  8031c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c4:	8b 50 0c             	mov    0xc(%eax),%edx
  8031c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ca:	39 c2                	cmp    %eax,%edx
  8031cc:	0f 85 c9 00 00 00    	jne    80329b <alloc_block_BF+0x174>
			  {
				// the new block are created
			    tmp_block = AvailableMemBlocksList.lh_first ;
  8031d2:	a1 48 51 80 00       	mov    0x805148,%eax
  8031d7:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  8031da:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8031de:	75 17                	jne    8031f7 <alloc_block_BF+0xd0>
  8031e0:	83 ec 04             	sub    $0x4,%esp
  8031e3:	68 5b 47 80 00       	push   $0x80475b
  8031e8:	68 ea 00 00 00       	push   $0xea
  8031ed:	68 b3 46 80 00       	push   $0x8046b3
  8031f2:	e8 fc db ff ff       	call   800df3 <_panic>
  8031f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031fa:	8b 00                	mov    (%eax),%eax
  8031fc:	85 c0                	test   %eax,%eax
  8031fe:	74 10                	je     803210 <alloc_block_BF+0xe9>
  803200:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803203:	8b 00                	mov    (%eax),%eax
  803205:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803208:	8b 52 04             	mov    0x4(%edx),%edx
  80320b:	89 50 04             	mov    %edx,0x4(%eax)
  80320e:	eb 0b                	jmp    80321b <alloc_block_BF+0xf4>
  803210:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803213:	8b 40 04             	mov    0x4(%eax),%eax
  803216:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80321b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80321e:	8b 40 04             	mov    0x4(%eax),%eax
  803221:	85 c0                	test   %eax,%eax
  803223:	74 0f                	je     803234 <alloc_block_BF+0x10d>
  803225:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803228:	8b 40 04             	mov    0x4(%eax),%eax
  80322b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80322e:	8b 12                	mov    (%edx),%edx
  803230:	89 10                	mov    %edx,(%eax)
  803232:	eb 0a                	jmp    80323e <alloc_block_BF+0x117>
  803234:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803237:	8b 00                	mov    (%eax),%eax
  803239:	a3 48 51 80 00       	mov    %eax,0x805148
  80323e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803241:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803247:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80324a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803251:	a1 54 51 80 00       	mov    0x805154,%eax
  803256:	48                   	dec    %eax
  803257:	a3 54 51 80 00       	mov    %eax,0x805154
				tmp_block->sva=element->sva;
  80325c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325f:	8b 50 08             	mov    0x8(%eax),%edx
  803262:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803265:	89 50 08             	mov    %edx,0x8(%eax)
				tmp_block->size=size;
  803268:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80326b:	8b 55 08             	mov    0x8(%ebp),%edx
  80326e:	89 50 0c             	mov    %edx,0xc(%eax)
				//update block with remaining space
				element->size-=size;
  803271:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803274:	8b 40 0c             	mov    0xc(%eax),%eax
  803277:	2b 45 08             	sub    0x8(%ebp),%eax
  80327a:	89 c2                	mov    %eax,%edx
  80327c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80327f:	89 50 0c             	mov    %edx,0xc(%eax)
				element->sva = element->sva + size;
  803282:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803285:	8b 50 08             	mov    0x8(%eax),%edx
  803288:	8b 45 08             	mov    0x8(%ebp),%eax
  80328b:	01 c2                	add    %eax,%edx
  80328d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803290:	89 50 08             	mov    %edx,0x8(%eax)
				// return back the new block
				return tmp_block ;
  803293:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803296:	e9 e5 00 00 00       	jmp    803380 <alloc_block_BF+0x259>

			  }
			else if((element->size == best_size)&&(best_size == size))
  80329b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80329e:	8b 50 0c             	mov    0xc(%eax),%edx
  8032a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032a4:	39 c2                	cmp    %eax,%edx
  8032a6:	0f 85 99 00 00 00    	jne    803345 <alloc_block_BF+0x21e>
  8032ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032af:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032b2:	0f 85 8d 00 00 00    	jne    803345 <alloc_block_BF+0x21e>
			  {
				tmp_block=element;
  8032b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032bb:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&FreeMemBlocksList,element);
  8032be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032c2:	75 17                	jne    8032db <alloc_block_BF+0x1b4>
  8032c4:	83 ec 04             	sub    $0x4,%esp
  8032c7:	68 5b 47 80 00       	push   $0x80475b
  8032cc:	68 f7 00 00 00       	push   $0xf7
  8032d1:	68 b3 46 80 00       	push   $0x8046b3
  8032d6:	e8 18 db ff ff       	call   800df3 <_panic>
  8032db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032de:	8b 00                	mov    (%eax),%eax
  8032e0:	85 c0                	test   %eax,%eax
  8032e2:	74 10                	je     8032f4 <alloc_block_BF+0x1cd>
  8032e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e7:	8b 00                	mov    (%eax),%eax
  8032e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032ec:	8b 52 04             	mov    0x4(%edx),%edx
  8032ef:	89 50 04             	mov    %edx,0x4(%eax)
  8032f2:	eb 0b                	jmp    8032ff <alloc_block_BF+0x1d8>
  8032f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f7:	8b 40 04             	mov    0x4(%eax),%eax
  8032fa:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803302:	8b 40 04             	mov    0x4(%eax),%eax
  803305:	85 c0                	test   %eax,%eax
  803307:	74 0f                	je     803318 <alloc_block_BF+0x1f1>
  803309:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80330c:	8b 40 04             	mov    0x4(%eax),%eax
  80330f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803312:	8b 12                	mov    (%edx),%edx
  803314:	89 10                	mov    %edx,(%eax)
  803316:	eb 0a                	jmp    803322 <alloc_block_BF+0x1fb>
  803318:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80331b:	8b 00                	mov    (%eax),%eax
  80331d:	a3 38 51 80 00       	mov    %eax,0x805138
  803322:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803325:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80332b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80332e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803335:	a1 44 51 80 00       	mov    0x805144,%eax
  80333a:	48                   	dec    %eax
  80333b:	a3 44 51 80 00       	mov    %eax,0x805144
				return tmp_block;
  803340:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803343:	eb 3b                	jmp    803380 <alloc_block_BF+0x259>
					best_size=element->size;
			}
		}
		if(best_size != -1)
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  803345:	a1 40 51 80 00       	mov    0x805140,%eax
  80334a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80334d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803351:	74 07                	je     80335a <alloc_block_BF+0x233>
  803353:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803356:	8b 00                	mov    (%eax),%eax
  803358:	eb 05                	jmp    80335f <alloc_block_BF+0x238>
  80335a:	b8 00 00 00 00       	mov    $0x0,%eax
  80335f:	a3 40 51 80 00       	mov    %eax,0x805140
  803364:	a1 40 51 80 00       	mov    0x805140,%eax
  803369:	85 c0                	test   %eax,%eax
  80336b:	0f 85 44 fe ff ff    	jne    8031b5 <alloc_block_BF+0x8e>
  803371:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803375:	0f 85 3a fe ff ff    	jne    8031b5 <alloc_block_BF+0x8e>
				LIST_REMOVE(&FreeMemBlocksList,element);
				return tmp_block;
			 }
			}
		}
		return NULL ;}
  80337b:	b8 00 00 00 00       	mov    $0x0,%eax
  803380:	c9                   	leave  
  803381:	c3                   	ret    

00803382 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  803382:	55                   	push   %ebp
  803383:	89 e5                	mov    %esp,%ebp
  803385:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  803388:	83 ec 04             	sub    $0x4,%esp
  80338b:	68 7c 47 80 00       	push   $0x80477c
  803390:	68 04 01 00 00       	push   $0x104
  803395:	68 b3 46 80 00       	push   $0x8046b3
  80339a:	e8 54 da ff ff       	call   800df3 <_panic>

0080339f <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{struct MemBlock * blk_itr;
  80339f:	55                   	push   %ebp
  8033a0:	89 e5                	mov    %esp,%ebp
  8033a2:	83 ec 18             	sub    $0x18,%esp
struct MemBlock * next;
struct MemBlock * first = LIST_FIRST(&(FreeMemBlocksList));
  8033a5:	a1 38 51 80 00       	mov    0x805138,%eax
  8033aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
struct MemBlock * last = LIST_LAST(&(FreeMemBlocksList));
  8033ad:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8033b2:	89 45 ec             	mov    %eax,-0x14(%ebp)

if(LIST_EMPTY(&(FreeMemBlocksList)))
  8033b5:	a1 38 51 80 00       	mov    0x805138,%eax
  8033ba:	85 c0                	test   %eax,%eax
  8033bc:	75 68                	jne    803426 <insert_sorted_with_merge_freeList+0x87>
			{

				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  8033be:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033c2:	75 17                	jne    8033db <insert_sorted_with_merge_freeList+0x3c>
  8033c4:	83 ec 04             	sub    $0x4,%esp
  8033c7:	68 90 46 80 00       	push   $0x804690
  8033cc:	68 14 01 00 00       	push   $0x114
  8033d1:	68 b3 46 80 00       	push   $0x8046b3
  8033d6:	e8 18 da ff ff       	call   800df3 <_panic>
  8033db:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8033e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e4:	89 10                	mov    %edx,(%eax)
  8033e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e9:	8b 00                	mov    (%eax),%eax
  8033eb:	85 c0                	test   %eax,%eax
  8033ed:	74 0d                	je     8033fc <insert_sorted_with_merge_freeList+0x5d>
  8033ef:	a1 38 51 80 00       	mov    0x805138,%eax
  8033f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8033f7:	89 50 04             	mov    %edx,0x4(%eax)
  8033fa:	eb 08                	jmp    803404 <insert_sorted_with_merge_freeList+0x65>
  8033fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ff:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803404:	8b 45 08             	mov    0x8(%ebp),%eax
  803407:	a3 38 51 80 00       	mov    %eax,0x805138
  80340c:	8b 45 08             	mov    0x8(%ebp),%eax
  80340f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803416:	a1 44 51 80 00       	mov    0x805144,%eax
  80341b:	40                   	inc    %eax
  80341c:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  803421:	e9 d2 06 00 00       	jmp    803af8 <insert_sorted_with_merge_freeList+0x759>
				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);

			}
else
{
	if( blockToInsert->sva  < first->sva )
  803426:	8b 45 08             	mov    0x8(%ebp),%eax
  803429:	8b 50 08             	mov    0x8(%eax),%edx
  80342c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80342f:	8b 40 08             	mov    0x8(%eax),%eax
  803432:	39 c2                	cmp    %eax,%edx
  803434:	0f 83 22 01 00 00    	jae    80355c <insert_sorted_with_merge_freeList+0x1bd>
	{
                if( blockToInsert->sva + blockToInsert->size == first->sva)
  80343a:	8b 45 08             	mov    0x8(%ebp),%eax
  80343d:	8b 50 08             	mov    0x8(%eax),%edx
  803440:	8b 45 08             	mov    0x8(%ebp),%eax
  803443:	8b 40 0c             	mov    0xc(%eax),%eax
  803446:	01 c2                	add    %eax,%edx
  803448:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80344b:	8b 40 08             	mov    0x8(%eax),%eax
  80344e:	39 c2                	cmp    %eax,%edx
  803450:	0f 85 9e 00 00 00    	jne    8034f4 <insert_sorted_with_merge_freeList+0x155>
                {

                	first->sva = blockToInsert->sva;
  803456:	8b 45 08             	mov    0x8(%ebp),%eax
  803459:	8b 50 08             	mov    0x8(%eax),%edx
  80345c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80345f:	89 50 08             	mov    %edx,0x8(%eax)
                	first->size = first->size + blockToInsert->size;
  803462:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803465:	8b 50 0c             	mov    0xc(%eax),%edx
  803468:	8b 45 08             	mov    0x8(%ebp),%eax
  80346b:	8b 40 0c             	mov    0xc(%eax),%eax
  80346e:	01 c2                	add    %eax,%edx
  803470:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803473:	89 50 0c             	mov    %edx,0xc(%eax)
                	blockToInsert->size = blockToInsert->sva = 0;
  803476:	8b 45 08             	mov    0x8(%ebp),%eax
  803479:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803480:	8b 45 08             	mov    0x8(%ebp),%eax
  803483:	8b 50 08             	mov    0x8(%eax),%edx
  803486:	8b 45 08             	mov    0x8(%ebp),%eax
  803489:	89 50 0c             	mov    %edx,0xc(%eax)
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  80348c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803490:	75 17                	jne    8034a9 <insert_sorted_with_merge_freeList+0x10a>
  803492:	83 ec 04             	sub    $0x4,%esp
  803495:	68 90 46 80 00       	push   $0x804690
  80349a:	68 21 01 00 00       	push   $0x121
  80349f:	68 b3 46 80 00       	push   $0x8046b3
  8034a4:	e8 4a d9 ff ff       	call   800df3 <_panic>
  8034a9:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8034af:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b2:	89 10                	mov    %edx,(%eax)
  8034b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b7:	8b 00                	mov    (%eax),%eax
  8034b9:	85 c0                	test   %eax,%eax
  8034bb:	74 0d                	je     8034ca <insert_sorted_with_merge_freeList+0x12b>
  8034bd:	a1 48 51 80 00       	mov    0x805148,%eax
  8034c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8034c5:	89 50 04             	mov    %edx,0x4(%eax)
  8034c8:	eb 08                	jmp    8034d2 <insert_sorted_with_merge_freeList+0x133>
  8034ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8034cd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d5:	a3 48 51 80 00       	mov    %eax,0x805148
  8034da:	8b 45 08             	mov    0x8(%ebp),%eax
  8034dd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034e4:	a1 54 51 80 00       	mov    0x805154,%eax
  8034e9:	40                   	inc    %eax
  8034ea:	a3 54 51 80 00       	mov    %eax,0x805154
						}
				}
        }

}
}
  8034ef:	e9 04 06 00 00       	jmp    803af8 <insert_sorted_with_merge_freeList+0x759>
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
                }

                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  8034f4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034f8:	75 17                	jne    803511 <insert_sorted_with_merge_freeList+0x172>
  8034fa:	83 ec 04             	sub    $0x4,%esp
  8034fd:	68 90 46 80 00       	push   $0x804690
  803502:	68 26 01 00 00       	push   $0x126
  803507:	68 b3 46 80 00       	push   $0x8046b3
  80350c:	e8 e2 d8 ff ff       	call   800df3 <_panic>
  803511:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803517:	8b 45 08             	mov    0x8(%ebp),%eax
  80351a:	89 10                	mov    %edx,(%eax)
  80351c:	8b 45 08             	mov    0x8(%ebp),%eax
  80351f:	8b 00                	mov    (%eax),%eax
  803521:	85 c0                	test   %eax,%eax
  803523:	74 0d                	je     803532 <insert_sorted_with_merge_freeList+0x193>
  803525:	a1 38 51 80 00       	mov    0x805138,%eax
  80352a:	8b 55 08             	mov    0x8(%ebp),%edx
  80352d:	89 50 04             	mov    %edx,0x4(%eax)
  803530:	eb 08                	jmp    80353a <insert_sorted_with_merge_freeList+0x19b>
  803532:	8b 45 08             	mov    0x8(%ebp),%eax
  803535:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80353a:	8b 45 08             	mov    0x8(%ebp),%eax
  80353d:	a3 38 51 80 00       	mov    %eax,0x805138
  803542:	8b 45 08             	mov    0x8(%ebp),%eax
  803545:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80354c:	a1 44 51 80 00       	mov    0x805144,%eax
  803551:	40                   	inc    %eax
  803552:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  803557:	e9 9c 05 00 00       	jmp    803af8 <insert_sorted_with_merge_freeList+0x759>
                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
                }
	}
    else if(blockToInsert->sva > last->sva)
  80355c:	8b 45 08             	mov    0x8(%ebp),%eax
  80355f:	8b 50 08             	mov    0x8(%eax),%edx
  803562:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803565:	8b 40 08             	mov    0x8(%eax),%eax
  803568:	39 c2                	cmp    %eax,%edx
  80356a:	0f 86 16 01 00 00    	jbe    803686 <insert_sorted_with_merge_freeList+0x2e7>
 	{

				if(last->sva + last->size == blockToInsert->sva)
  803570:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803573:	8b 50 08             	mov    0x8(%eax),%edx
  803576:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803579:	8b 40 0c             	mov    0xc(%eax),%eax
  80357c:	01 c2                	add    %eax,%edx
  80357e:	8b 45 08             	mov    0x8(%ebp),%eax
  803581:	8b 40 08             	mov    0x8(%eax),%eax
  803584:	39 c2                	cmp    %eax,%edx
  803586:	0f 85 92 00 00 00    	jne    80361e <insert_sorted_with_merge_freeList+0x27f>
				{

					last->size = last->size + blockToInsert->size;
  80358c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80358f:	8b 50 0c             	mov    0xc(%eax),%edx
  803592:	8b 45 08             	mov    0x8(%ebp),%eax
  803595:	8b 40 0c             	mov    0xc(%eax),%eax
  803598:	01 c2                	add    %eax,%edx
  80359a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80359d:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->size = blockToInsert->sva = 0;
  8035a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8035aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ad:	8b 50 08             	mov    0x8(%eax),%edx
  8035b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b3:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  8035b6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035ba:	75 17                	jne    8035d3 <insert_sorted_with_merge_freeList+0x234>
  8035bc:	83 ec 04             	sub    $0x4,%esp
  8035bf:	68 90 46 80 00       	push   $0x804690
  8035c4:	68 31 01 00 00       	push   $0x131
  8035c9:	68 b3 46 80 00       	push   $0x8046b3
  8035ce:	e8 20 d8 ff ff       	call   800df3 <_panic>
  8035d3:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8035d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8035dc:	89 10                	mov    %edx,(%eax)
  8035de:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e1:	8b 00                	mov    (%eax),%eax
  8035e3:	85 c0                	test   %eax,%eax
  8035e5:	74 0d                	je     8035f4 <insert_sorted_with_merge_freeList+0x255>
  8035e7:	a1 48 51 80 00       	mov    0x805148,%eax
  8035ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8035ef:	89 50 04             	mov    %edx,0x4(%eax)
  8035f2:	eb 08                	jmp    8035fc <insert_sorted_with_merge_freeList+0x25d>
  8035f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8035fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ff:	a3 48 51 80 00       	mov    %eax,0x805148
  803604:	8b 45 08             	mov    0x8(%ebp),%eax
  803607:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80360e:	a1 54 51 80 00       	mov    0x805154,%eax
  803613:	40                   	inc    %eax
  803614:	a3 54 51 80 00       	mov    %eax,0x805154
						}
				}
        }

}
}
  803619:	e9 da 04 00 00       	jmp    803af8 <insert_sorted_with_merge_freeList+0x759>

				}

				else
				{
					LIST_INSERT_TAIL(&(FreeMemBlocksList),  blockToInsert);
  80361e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803622:	75 17                	jne    80363b <insert_sorted_with_merge_freeList+0x29c>
  803624:	83 ec 04             	sub    $0x4,%esp
  803627:	68 38 47 80 00       	push   $0x804738
  80362c:	68 37 01 00 00       	push   $0x137
  803631:	68 b3 46 80 00       	push   $0x8046b3
  803636:	e8 b8 d7 ff ff       	call   800df3 <_panic>
  80363b:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803641:	8b 45 08             	mov    0x8(%ebp),%eax
  803644:	89 50 04             	mov    %edx,0x4(%eax)
  803647:	8b 45 08             	mov    0x8(%ebp),%eax
  80364a:	8b 40 04             	mov    0x4(%eax),%eax
  80364d:	85 c0                	test   %eax,%eax
  80364f:	74 0c                	je     80365d <insert_sorted_with_merge_freeList+0x2be>
  803651:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803656:	8b 55 08             	mov    0x8(%ebp),%edx
  803659:	89 10                	mov    %edx,(%eax)
  80365b:	eb 08                	jmp    803665 <insert_sorted_with_merge_freeList+0x2c6>
  80365d:	8b 45 08             	mov    0x8(%ebp),%eax
  803660:	a3 38 51 80 00       	mov    %eax,0x805138
  803665:	8b 45 08             	mov    0x8(%ebp),%eax
  803668:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80366d:	8b 45 08             	mov    0x8(%ebp),%eax
  803670:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803676:	a1 44 51 80 00       	mov    0x805144,%eax
  80367b:	40                   	inc    %eax
  80367c:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  803681:	e9 72 04 00 00       	jmp    803af8 <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  803686:	a1 38 51 80 00       	mov    0x805138,%eax
  80368b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80368e:	e9 35 04 00 00       	jmp    803ac8 <insert_sorted_with_merge_freeList+0x729>
				{
				     next=LIST_NEXT(blk_itr);
  803693:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803696:	8b 00                	mov    (%eax),%eax
  803698:	89 45 e8             	mov    %eax,-0x18(%ebp)


					if( (blockToInsert->sva > blk_itr->sva) )
  80369b:	8b 45 08             	mov    0x8(%ebp),%eax
  80369e:	8b 50 08             	mov    0x8(%eax),%edx
  8036a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036a4:	8b 40 08             	mov    0x8(%eax),%eax
  8036a7:	39 c2                	cmp    %eax,%edx
  8036a9:	0f 86 11 04 00 00    	jbe    803ac0 <insert_sorted_with_merge_freeList+0x721>
						{
							if(((blk_itr->sva) + (blk_itr->size) < blockToInsert->sva && (blockToInsert->sva) + (blockToInsert->size) < next->sva))
  8036af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036b2:	8b 50 08             	mov    0x8(%eax),%edx
  8036b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036b8:	8b 40 0c             	mov    0xc(%eax),%eax
  8036bb:	01 c2                	add    %eax,%edx
  8036bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c0:	8b 40 08             	mov    0x8(%eax),%eax
  8036c3:	39 c2                	cmp    %eax,%edx
  8036c5:	0f 83 8b 00 00 00    	jae    803756 <insert_sorted_with_merge_freeList+0x3b7>
  8036cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ce:	8b 50 08             	mov    0x8(%eax),%edx
  8036d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8036d7:	01 c2                	add    %eax,%edx
  8036d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036dc:	8b 40 08             	mov    0x8(%eax),%eax
  8036df:	39 c2                	cmp    %eax,%edx
  8036e1:	73 73                	jae    803756 <insert_sorted_with_merge_freeList+0x3b7>
							{
								LIST_INSERT_AFTER(&(FreeMemBlocksList), blk_itr, blockToInsert);
  8036e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036e7:	74 06                	je     8036ef <insert_sorted_with_merge_freeList+0x350>
  8036e9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036ed:	75 17                	jne    803706 <insert_sorted_with_merge_freeList+0x367>
  8036ef:	83 ec 04             	sub    $0x4,%esp
  8036f2:	68 04 47 80 00       	push   $0x804704
  8036f7:	68 48 01 00 00       	push   $0x148
  8036fc:	68 b3 46 80 00       	push   $0x8046b3
  803701:	e8 ed d6 ff ff       	call   800df3 <_panic>
  803706:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803709:	8b 10                	mov    (%eax),%edx
  80370b:	8b 45 08             	mov    0x8(%ebp),%eax
  80370e:	89 10                	mov    %edx,(%eax)
  803710:	8b 45 08             	mov    0x8(%ebp),%eax
  803713:	8b 00                	mov    (%eax),%eax
  803715:	85 c0                	test   %eax,%eax
  803717:	74 0b                	je     803724 <insert_sorted_with_merge_freeList+0x385>
  803719:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80371c:	8b 00                	mov    (%eax),%eax
  80371e:	8b 55 08             	mov    0x8(%ebp),%edx
  803721:	89 50 04             	mov    %edx,0x4(%eax)
  803724:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803727:	8b 55 08             	mov    0x8(%ebp),%edx
  80372a:	89 10                	mov    %edx,(%eax)
  80372c:	8b 45 08             	mov    0x8(%ebp),%eax
  80372f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803732:	89 50 04             	mov    %edx,0x4(%eax)
  803735:	8b 45 08             	mov    0x8(%ebp),%eax
  803738:	8b 00                	mov    (%eax),%eax
  80373a:	85 c0                	test   %eax,%eax
  80373c:	75 08                	jne    803746 <insert_sorted_with_merge_freeList+0x3a7>
  80373e:	8b 45 08             	mov    0x8(%ebp),%eax
  803741:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803746:	a1 44 51 80 00       	mov    0x805144,%eax
  80374b:	40                   	inc    %eax
  80374c:	a3 44 51 80 00       	mov    %eax,0x805144
								break;
  803751:	e9 a2 03 00 00       	jmp    803af8 <insert_sorted_with_merge_freeList+0x759>

							}
							else if((blockToInsert->sva + blockToInsert->size) < next->sva  && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  803756:	8b 45 08             	mov    0x8(%ebp),%eax
  803759:	8b 50 08             	mov    0x8(%eax),%edx
  80375c:	8b 45 08             	mov    0x8(%ebp),%eax
  80375f:	8b 40 0c             	mov    0xc(%eax),%eax
  803762:	01 c2                	add    %eax,%edx
  803764:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803767:	8b 40 08             	mov    0x8(%eax),%eax
  80376a:	39 c2                	cmp    %eax,%edx
  80376c:	0f 83 ae 00 00 00    	jae    803820 <insert_sorted_with_merge_freeList+0x481>
  803772:	8b 45 08             	mov    0x8(%ebp),%eax
  803775:	8b 50 08             	mov    0x8(%eax),%edx
  803778:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80377b:	8b 48 08             	mov    0x8(%eax),%ecx
  80377e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803781:	8b 40 0c             	mov    0xc(%eax),%eax
  803784:	01 c8                	add    %ecx,%eax
  803786:	39 c2                	cmp    %eax,%edx
  803788:	0f 85 92 00 00 00    	jne    803820 <insert_sorted_with_merge_freeList+0x481>
							{

								blk_itr->size=blk_itr->size+blockToInsert->size;
  80378e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803791:	8b 50 0c             	mov    0xc(%eax),%edx
  803794:	8b 45 08             	mov    0x8(%ebp),%eax
  803797:	8b 40 0c             	mov    0xc(%eax),%eax
  80379a:	01 c2                	add    %eax,%edx
  80379c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80379f:	89 50 0c             	mov    %edx,0xc(%eax)
								 blockToInsert->size=blockToInsert->sva=0;
  8037a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8037ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8037af:	8b 50 08             	mov    0x8(%eax),%edx
  8037b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b5:	89 50 0c             	mov    %edx,0xc(%eax)
								 LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  8037b8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037bc:	75 17                	jne    8037d5 <insert_sorted_with_merge_freeList+0x436>
  8037be:	83 ec 04             	sub    $0x4,%esp
  8037c1:	68 90 46 80 00       	push   $0x804690
  8037c6:	68 51 01 00 00       	push   $0x151
  8037cb:	68 b3 46 80 00       	push   $0x8046b3
  8037d0:	e8 1e d6 ff ff       	call   800df3 <_panic>
  8037d5:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8037db:	8b 45 08             	mov    0x8(%ebp),%eax
  8037de:	89 10                	mov    %edx,(%eax)
  8037e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8037e3:	8b 00                	mov    (%eax),%eax
  8037e5:	85 c0                	test   %eax,%eax
  8037e7:	74 0d                	je     8037f6 <insert_sorted_with_merge_freeList+0x457>
  8037e9:	a1 48 51 80 00       	mov    0x805148,%eax
  8037ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8037f1:	89 50 04             	mov    %edx,0x4(%eax)
  8037f4:	eb 08                	jmp    8037fe <insert_sorted_with_merge_freeList+0x45f>
  8037f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8037f9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8037fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803801:	a3 48 51 80 00       	mov    %eax,0x805148
  803806:	8b 45 08             	mov    0x8(%ebp),%eax
  803809:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803810:	a1 54 51 80 00       	mov    0x805154,%eax
  803815:	40                   	inc    %eax
  803816:	a3 54 51 80 00       	mov    %eax,0x805154
								 break;
  80381b:	e9 d8 02 00 00       	jmp    803af8 <insert_sorted_with_merge_freeList+0x759>

							}
							else if( (blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva > (blk_itr->sva + blk_itr->size))
  803820:	8b 45 08             	mov    0x8(%ebp),%eax
  803823:	8b 50 08             	mov    0x8(%eax),%edx
  803826:	8b 45 08             	mov    0x8(%ebp),%eax
  803829:	8b 40 0c             	mov    0xc(%eax),%eax
  80382c:	01 c2                	add    %eax,%edx
  80382e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803831:	8b 40 08             	mov    0x8(%eax),%eax
  803834:	39 c2                	cmp    %eax,%edx
  803836:	0f 85 ba 00 00 00    	jne    8038f6 <insert_sorted_with_merge_freeList+0x557>
  80383c:	8b 45 08             	mov    0x8(%ebp),%eax
  80383f:	8b 50 08             	mov    0x8(%eax),%edx
  803842:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803845:	8b 48 08             	mov    0x8(%eax),%ecx
  803848:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80384b:	8b 40 0c             	mov    0xc(%eax),%eax
  80384e:	01 c8                	add    %ecx,%eax
  803850:	39 c2                	cmp    %eax,%edx
  803852:	0f 86 9e 00 00 00    	jbe    8038f6 <insert_sorted_with_merge_freeList+0x557>
							{
								next->size = next->size + blockToInsert->size;
  803858:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80385b:	8b 50 0c             	mov    0xc(%eax),%edx
  80385e:	8b 45 08             	mov    0x8(%ebp),%eax
  803861:	8b 40 0c             	mov    0xc(%eax),%eax
  803864:	01 c2                	add    %eax,%edx
  803866:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803869:	89 50 0c             	mov    %edx,0xc(%eax)
								next->sva = blockToInsert->sva;
  80386c:	8b 45 08             	mov    0x8(%ebp),%eax
  80386f:	8b 50 08             	mov    0x8(%eax),%edx
  803872:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803875:	89 50 08             	mov    %edx,0x8(%eax)

								blockToInsert->size = blockToInsert->sva = 0;
  803878:	8b 45 08             	mov    0x8(%ebp),%eax
  80387b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803882:	8b 45 08             	mov    0x8(%ebp),%eax
  803885:	8b 50 08             	mov    0x8(%eax),%edx
  803888:	8b 45 08             	mov    0x8(%ebp),%eax
  80388b:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  80388e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803892:	75 17                	jne    8038ab <insert_sorted_with_merge_freeList+0x50c>
  803894:	83 ec 04             	sub    $0x4,%esp
  803897:	68 90 46 80 00       	push   $0x804690
  80389c:	68 5b 01 00 00       	push   $0x15b
  8038a1:	68 b3 46 80 00       	push   $0x8046b3
  8038a6:	e8 48 d5 ff ff       	call   800df3 <_panic>
  8038ab:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8038b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8038b4:	89 10                	mov    %edx,(%eax)
  8038b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8038b9:	8b 00                	mov    (%eax),%eax
  8038bb:	85 c0                	test   %eax,%eax
  8038bd:	74 0d                	je     8038cc <insert_sorted_with_merge_freeList+0x52d>
  8038bf:	a1 48 51 80 00       	mov    0x805148,%eax
  8038c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8038c7:	89 50 04             	mov    %edx,0x4(%eax)
  8038ca:	eb 08                	jmp    8038d4 <insert_sorted_with_merge_freeList+0x535>
  8038cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8038cf:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8038d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8038d7:	a3 48 51 80 00       	mov    %eax,0x805148
  8038dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8038df:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038e6:	a1 54 51 80 00       	mov    0x805154,%eax
  8038eb:	40                   	inc    %eax
  8038ec:	a3 54 51 80 00       	mov    %eax,0x805154
								break;
  8038f1:	e9 02 02 00 00       	jmp    803af8 <insert_sorted_with_merge_freeList+0x759>
							}
							else if ((blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  8038f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8038f9:	8b 50 08             	mov    0x8(%eax),%edx
  8038fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ff:	8b 40 0c             	mov    0xc(%eax),%eax
  803902:	01 c2                	add    %eax,%edx
  803904:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803907:	8b 40 08             	mov    0x8(%eax),%eax
  80390a:	39 c2                	cmp    %eax,%edx
  80390c:	0f 85 ae 01 00 00    	jne    803ac0 <insert_sorted_with_merge_freeList+0x721>
  803912:	8b 45 08             	mov    0x8(%ebp),%eax
  803915:	8b 50 08             	mov    0x8(%eax),%edx
  803918:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80391b:	8b 48 08             	mov    0x8(%eax),%ecx
  80391e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803921:	8b 40 0c             	mov    0xc(%eax),%eax
  803924:	01 c8                	add    %ecx,%eax
  803926:	39 c2                	cmp    %eax,%edx
  803928:	0f 85 92 01 00 00    	jne    803ac0 <insert_sorted_with_merge_freeList+0x721>
							{
								blk_itr->size = blk_itr->size + blockToInsert->size + next->size;
  80392e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803931:	8b 50 0c             	mov    0xc(%eax),%edx
  803934:	8b 45 08             	mov    0x8(%ebp),%eax
  803937:	8b 40 0c             	mov    0xc(%eax),%eax
  80393a:	01 c2                	add    %eax,%edx
  80393c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80393f:	8b 40 0c             	mov    0xc(%eax),%eax
  803942:	01 c2                	add    %eax,%edx
  803944:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803947:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size = blockToInsert->sva=0;
  80394a:	8b 45 08             	mov    0x8(%ebp),%eax
  80394d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803954:	8b 45 08             	mov    0x8(%ebp),%eax
  803957:	8b 50 08             	mov    0x8(%eax),%edx
  80395a:	8b 45 08             	mov    0x8(%ebp),%eax
  80395d:	89 50 0c             	mov    %edx,0xc(%eax)
								next->size = next->sva = 0;
  803960:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803963:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80396a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80396d:	8b 50 08             	mov    0x8(%eax),%edx
  803970:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803973:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_REMOVE(&FreeMemBlocksList, next);
  803976:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80397a:	75 17                	jne    803993 <insert_sorted_with_merge_freeList+0x5f4>
  80397c:	83 ec 04             	sub    $0x4,%esp
  80397f:	68 5b 47 80 00       	push   $0x80475b
  803984:	68 63 01 00 00       	push   $0x163
  803989:	68 b3 46 80 00       	push   $0x8046b3
  80398e:	e8 60 d4 ff ff       	call   800df3 <_panic>
  803993:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803996:	8b 00                	mov    (%eax),%eax
  803998:	85 c0                	test   %eax,%eax
  80399a:	74 10                	je     8039ac <insert_sorted_with_merge_freeList+0x60d>
  80399c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80399f:	8b 00                	mov    (%eax),%eax
  8039a1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8039a4:	8b 52 04             	mov    0x4(%edx),%edx
  8039a7:	89 50 04             	mov    %edx,0x4(%eax)
  8039aa:	eb 0b                	jmp    8039b7 <insert_sorted_with_merge_freeList+0x618>
  8039ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039af:	8b 40 04             	mov    0x4(%eax),%eax
  8039b2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8039b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039ba:	8b 40 04             	mov    0x4(%eax),%eax
  8039bd:	85 c0                	test   %eax,%eax
  8039bf:	74 0f                	je     8039d0 <insert_sorted_with_merge_freeList+0x631>
  8039c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039c4:	8b 40 04             	mov    0x4(%eax),%eax
  8039c7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8039ca:	8b 12                	mov    (%edx),%edx
  8039cc:	89 10                	mov    %edx,(%eax)
  8039ce:	eb 0a                	jmp    8039da <insert_sorted_with_merge_freeList+0x63b>
  8039d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039d3:	8b 00                	mov    (%eax),%eax
  8039d5:	a3 38 51 80 00       	mov    %eax,0x805138
  8039da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039e6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039ed:	a1 44 51 80 00       	mov    0x805144,%eax
  8039f2:	48                   	dec    %eax
  8039f3:	a3 44 51 80 00       	mov    %eax,0x805144
								LIST_INSERT_HEAD(&AvailableMemBlocksList, next );
  8039f8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8039fc:	75 17                	jne    803a15 <insert_sorted_with_merge_freeList+0x676>
  8039fe:	83 ec 04             	sub    $0x4,%esp
  803a01:	68 90 46 80 00       	push   $0x804690
  803a06:	68 64 01 00 00       	push   $0x164
  803a0b:	68 b3 46 80 00       	push   $0x8046b3
  803a10:	e8 de d3 ff ff       	call   800df3 <_panic>
  803a15:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803a1b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a1e:	89 10                	mov    %edx,(%eax)
  803a20:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a23:	8b 00                	mov    (%eax),%eax
  803a25:	85 c0                	test   %eax,%eax
  803a27:	74 0d                	je     803a36 <insert_sorted_with_merge_freeList+0x697>
  803a29:	a1 48 51 80 00       	mov    0x805148,%eax
  803a2e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a31:	89 50 04             	mov    %edx,0x4(%eax)
  803a34:	eb 08                	jmp    803a3e <insert_sorted_with_merge_freeList+0x69f>
  803a36:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a39:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803a3e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a41:	a3 48 51 80 00       	mov    %eax,0x805148
  803a46:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a49:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a50:	a1 54 51 80 00       	mov    0x805154,%eax
  803a55:	40                   	inc    %eax
  803a56:	a3 54 51 80 00       	mov    %eax,0x805154
							    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  803a5b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a5f:	75 17                	jne    803a78 <insert_sorted_with_merge_freeList+0x6d9>
  803a61:	83 ec 04             	sub    $0x4,%esp
  803a64:	68 90 46 80 00       	push   $0x804690
  803a69:	68 65 01 00 00       	push   $0x165
  803a6e:	68 b3 46 80 00       	push   $0x8046b3
  803a73:	e8 7b d3 ff ff       	call   800df3 <_panic>
  803a78:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  803a81:	89 10                	mov    %edx,(%eax)
  803a83:	8b 45 08             	mov    0x8(%ebp),%eax
  803a86:	8b 00                	mov    (%eax),%eax
  803a88:	85 c0                	test   %eax,%eax
  803a8a:	74 0d                	je     803a99 <insert_sorted_with_merge_freeList+0x6fa>
  803a8c:	a1 48 51 80 00       	mov    0x805148,%eax
  803a91:	8b 55 08             	mov    0x8(%ebp),%edx
  803a94:	89 50 04             	mov    %edx,0x4(%eax)
  803a97:	eb 08                	jmp    803aa1 <insert_sorted_with_merge_freeList+0x702>
  803a99:	8b 45 08             	mov    0x8(%ebp),%eax
  803a9c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  803aa4:	a3 48 51 80 00       	mov    %eax,0x805148
  803aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  803aac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ab3:	a1 54 51 80 00       	mov    0x805154,%eax
  803ab8:	40                   	inc    %eax
  803ab9:	a3 54 51 80 00       	mov    %eax,0x805154
								break;
  803abe:	eb 38                	jmp    803af8 <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  803ac0:	a1 40 51 80 00       	mov    0x805140,%eax
  803ac5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803ac8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803acc:	74 07                	je     803ad5 <insert_sorted_with_merge_freeList+0x736>
  803ace:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ad1:	8b 00                	mov    (%eax),%eax
  803ad3:	eb 05                	jmp    803ada <insert_sorted_with_merge_freeList+0x73b>
  803ad5:	b8 00 00 00 00       	mov    $0x0,%eax
  803ada:	a3 40 51 80 00       	mov    %eax,0x805140
  803adf:	a1 40 51 80 00       	mov    0x805140,%eax
  803ae4:	85 c0                	test   %eax,%eax
  803ae6:	0f 85 a7 fb ff ff    	jne    803693 <insert_sorted_with_merge_freeList+0x2f4>
  803aec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803af0:	0f 85 9d fb ff ff    	jne    803693 <insert_sorted_with_merge_freeList+0x2f4>
						}
				}
        }

}
}
  803af6:	eb 00                	jmp    803af8 <insert_sorted_with_merge_freeList+0x759>
  803af8:	90                   	nop
  803af9:	c9                   	leave  
  803afa:	c3                   	ret    
  803afb:	90                   	nop

00803afc <__udivdi3>:
  803afc:	55                   	push   %ebp
  803afd:	57                   	push   %edi
  803afe:	56                   	push   %esi
  803aff:	53                   	push   %ebx
  803b00:	83 ec 1c             	sub    $0x1c,%esp
  803b03:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803b07:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803b0b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b0f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803b13:	89 ca                	mov    %ecx,%edx
  803b15:	89 f8                	mov    %edi,%eax
  803b17:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803b1b:	85 f6                	test   %esi,%esi
  803b1d:	75 2d                	jne    803b4c <__udivdi3+0x50>
  803b1f:	39 cf                	cmp    %ecx,%edi
  803b21:	77 65                	ja     803b88 <__udivdi3+0x8c>
  803b23:	89 fd                	mov    %edi,%ebp
  803b25:	85 ff                	test   %edi,%edi
  803b27:	75 0b                	jne    803b34 <__udivdi3+0x38>
  803b29:	b8 01 00 00 00       	mov    $0x1,%eax
  803b2e:	31 d2                	xor    %edx,%edx
  803b30:	f7 f7                	div    %edi
  803b32:	89 c5                	mov    %eax,%ebp
  803b34:	31 d2                	xor    %edx,%edx
  803b36:	89 c8                	mov    %ecx,%eax
  803b38:	f7 f5                	div    %ebp
  803b3a:	89 c1                	mov    %eax,%ecx
  803b3c:	89 d8                	mov    %ebx,%eax
  803b3e:	f7 f5                	div    %ebp
  803b40:	89 cf                	mov    %ecx,%edi
  803b42:	89 fa                	mov    %edi,%edx
  803b44:	83 c4 1c             	add    $0x1c,%esp
  803b47:	5b                   	pop    %ebx
  803b48:	5e                   	pop    %esi
  803b49:	5f                   	pop    %edi
  803b4a:	5d                   	pop    %ebp
  803b4b:	c3                   	ret    
  803b4c:	39 ce                	cmp    %ecx,%esi
  803b4e:	77 28                	ja     803b78 <__udivdi3+0x7c>
  803b50:	0f bd fe             	bsr    %esi,%edi
  803b53:	83 f7 1f             	xor    $0x1f,%edi
  803b56:	75 40                	jne    803b98 <__udivdi3+0x9c>
  803b58:	39 ce                	cmp    %ecx,%esi
  803b5a:	72 0a                	jb     803b66 <__udivdi3+0x6a>
  803b5c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803b60:	0f 87 9e 00 00 00    	ja     803c04 <__udivdi3+0x108>
  803b66:	b8 01 00 00 00       	mov    $0x1,%eax
  803b6b:	89 fa                	mov    %edi,%edx
  803b6d:	83 c4 1c             	add    $0x1c,%esp
  803b70:	5b                   	pop    %ebx
  803b71:	5e                   	pop    %esi
  803b72:	5f                   	pop    %edi
  803b73:	5d                   	pop    %ebp
  803b74:	c3                   	ret    
  803b75:	8d 76 00             	lea    0x0(%esi),%esi
  803b78:	31 ff                	xor    %edi,%edi
  803b7a:	31 c0                	xor    %eax,%eax
  803b7c:	89 fa                	mov    %edi,%edx
  803b7e:	83 c4 1c             	add    $0x1c,%esp
  803b81:	5b                   	pop    %ebx
  803b82:	5e                   	pop    %esi
  803b83:	5f                   	pop    %edi
  803b84:	5d                   	pop    %ebp
  803b85:	c3                   	ret    
  803b86:	66 90                	xchg   %ax,%ax
  803b88:	89 d8                	mov    %ebx,%eax
  803b8a:	f7 f7                	div    %edi
  803b8c:	31 ff                	xor    %edi,%edi
  803b8e:	89 fa                	mov    %edi,%edx
  803b90:	83 c4 1c             	add    $0x1c,%esp
  803b93:	5b                   	pop    %ebx
  803b94:	5e                   	pop    %esi
  803b95:	5f                   	pop    %edi
  803b96:	5d                   	pop    %ebp
  803b97:	c3                   	ret    
  803b98:	bd 20 00 00 00       	mov    $0x20,%ebp
  803b9d:	89 eb                	mov    %ebp,%ebx
  803b9f:	29 fb                	sub    %edi,%ebx
  803ba1:	89 f9                	mov    %edi,%ecx
  803ba3:	d3 e6                	shl    %cl,%esi
  803ba5:	89 c5                	mov    %eax,%ebp
  803ba7:	88 d9                	mov    %bl,%cl
  803ba9:	d3 ed                	shr    %cl,%ebp
  803bab:	89 e9                	mov    %ebp,%ecx
  803bad:	09 f1                	or     %esi,%ecx
  803baf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803bb3:	89 f9                	mov    %edi,%ecx
  803bb5:	d3 e0                	shl    %cl,%eax
  803bb7:	89 c5                	mov    %eax,%ebp
  803bb9:	89 d6                	mov    %edx,%esi
  803bbb:	88 d9                	mov    %bl,%cl
  803bbd:	d3 ee                	shr    %cl,%esi
  803bbf:	89 f9                	mov    %edi,%ecx
  803bc1:	d3 e2                	shl    %cl,%edx
  803bc3:	8b 44 24 08          	mov    0x8(%esp),%eax
  803bc7:	88 d9                	mov    %bl,%cl
  803bc9:	d3 e8                	shr    %cl,%eax
  803bcb:	09 c2                	or     %eax,%edx
  803bcd:	89 d0                	mov    %edx,%eax
  803bcf:	89 f2                	mov    %esi,%edx
  803bd1:	f7 74 24 0c          	divl   0xc(%esp)
  803bd5:	89 d6                	mov    %edx,%esi
  803bd7:	89 c3                	mov    %eax,%ebx
  803bd9:	f7 e5                	mul    %ebp
  803bdb:	39 d6                	cmp    %edx,%esi
  803bdd:	72 19                	jb     803bf8 <__udivdi3+0xfc>
  803bdf:	74 0b                	je     803bec <__udivdi3+0xf0>
  803be1:	89 d8                	mov    %ebx,%eax
  803be3:	31 ff                	xor    %edi,%edi
  803be5:	e9 58 ff ff ff       	jmp    803b42 <__udivdi3+0x46>
  803bea:	66 90                	xchg   %ax,%ax
  803bec:	8b 54 24 08          	mov    0x8(%esp),%edx
  803bf0:	89 f9                	mov    %edi,%ecx
  803bf2:	d3 e2                	shl    %cl,%edx
  803bf4:	39 c2                	cmp    %eax,%edx
  803bf6:	73 e9                	jae    803be1 <__udivdi3+0xe5>
  803bf8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803bfb:	31 ff                	xor    %edi,%edi
  803bfd:	e9 40 ff ff ff       	jmp    803b42 <__udivdi3+0x46>
  803c02:	66 90                	xchg   %ax,%ax
  803c04:	31 c0                	xor    %eax,%eax
  803c06:	e9 37 ff ff ff       	jmp    803b42 <__udivdi3+0x46>
  803c0b:	90                   	nop

00803c0c <__umoddi3>:
  803c0c:	55                   	push   %ebp
  803c0d:	57                   	push   %edi
  803c0e:	56                   	push   %esi
  803c0f:	53                   	push   %ebx
  803c10:	83 ec 1c             	sub    $0x1c,%esp
  803c13:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803c17:	8b 74 24 34          	mov    0x34(%esp),%esi
  803c1b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c1f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803c23:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803c27:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803c2b:	89 f3                	mov    %esi,%ebx
  803c2d:	89 fa                	mov    %edi,%edx
  803c2f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c33:	89 34 24             	mov    %esi,(%esp)
  803c36:	85 c0                	test   %eax,%eax
  803c38:	75 1a                	jne    803c54 <__umoddi3+0x48>
  803c3a:	39 f7                	cmp    %esi,%edi
  803c3c:	0f 86 a2 00 00 00    	jbe    803ce4 <__umoddi3+0xd8>
  803c42:	89 c8                	mov    %ecx,%eax
  803c44:	89 f2                	mov    %esi,%edx
  803c46:	f7 f7                	div    %edi
  803c48:	89 d0                	mov    %edx,%eax
  803c4a:	31 d2                	xor    %edx,%edx
  803c4c:	83 c4 1c             	add    $0x1c,%esp
  803c4f:	5b                   	pop    %ebx
  803c50:	5e                   	pop    %esi
  803c51:	5f                   	pop    %edi
  803c52:	5d                   	pop    %ebp
  803c53:	c3                   	ret    
  803c54:	39 f0                	cmp    %esi,%eax
  803c56:	0f 87 ac 00 00 00    	ja     803d08 <__umoddi3+0xfc>
  803c5c:	0f bd e8             	bsr    %eax,%ebp
  803c5f:	83 f5 1f             	xor    $0x1f,%ebp
  803c62:	0f 84 ac 00 00 00    	je     803d14 <__umoddi3+0x108>
  803c68:	bf 20 00 00 00       	mov    $0x20,%edi
  803c6d:	29 ef                	sub    %ebp,%edi
  803c6f:	89 fe                	mov    %edi,%esi
  803c71:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803c75:	89 e9                	mov    %ebp,%ecx
  803c77:	d3 e0                	shl    %cl,%eax
  803c79:	89 d7                	mov    %edx,%edi
  803c7b:	89 f1                	mov    %esi,%ecx
  803c7d:	d3 ef                	shr    %cl,%edi
  803c7f:	09 c7                	or     %eax,%edi
  803c81:	89 e9                	mov    %ebp,%ecx
  803c83:	d3 e2                	shl    %cl,%edx
  803c85:	89 14 24             	mov    %edx,(%esp)
  803c88:	89 d8                	mov    %ebx,%eax
  803c8a:	d3 e0                	shl    %cl,%eax
  803c8c:	89 c2                	mov    %eax,%edx
  803c8e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c92:	d3 e0                	shl    %cl,%eax
  803c94:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c98:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c9c:	89 f1                	mov    %esi,%ecx
  803c9e:	d3 e8                	shr    %cl,%eax
  803ca0:	09 d0                	or     %edx,%eax
  803ca2:	d3 eb                	shr    %cl,%ebx
  803ca4:	89 da                	mov    %ebx,%edx
  803ca6:	f7 f7                	div    %edi
  803ca8:	89 d3                	mov    %edx,%ebx
  803caa:	f7 24 24             	mull   (%esp)
  803cad:	89 c6                	mov    %eax,%esi
  803caf:	89 d1                	mov    %edx,%ecx
  803cb1:	39 d3                	cmp    %edx,%ebx
  803cb3:	0f 82 87 00 00 00    	jb     803d40 <__umoddi3+0x134>
  803cb9:	0f 84 91 00 00 00    	je     803d50 <__umoddi3+0x144>
  803cbf:	8b 54 24 04          	mov    0x4(%esp),%edx
  803cc3:	29 f2                	sub    %esi,%edx
  803cc5:	19 cb                	sbb    %ecx,%ebx
  803cc7:	89 d8                	mov    %ebx,%eax
  803cc9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803ccd:	d3 e0                	shl    %cl,%eax
  803ccf:	89 e9                	mov    %ebp,%ecx
  803cd1:	d3 ea                	shr    %cl,%edx
  803cd3:	09 d0                	or     %edx,%eax
  803cd5:	89 e9                	mov    %ebp,%ecx
  803cd7:	d3 eb                	shr    %cl,%ebx
  803cd9:	89 da                	mov    %ebx,%edx
  803cdb:	83 c4 1c             	add    $0x1c,%esp
  803cde:	5b                   	pop    %ebx
  803cdf:	5e                   	pop    %esi
  803ce0:	5f                   	pop    %edi
  803ce1:	5d                   	pop    %ebp
  803ce2:	c3                   	ret    
  803ce3:	90                   	nop
  803ce4:	89 fd                	mov    %edi,%ebp
  803ce6:	85 ff                	test   %edi,%edi
  803ce8:	75 0b                	jne    803cf5 <__umoddi3+0xe9>
  803cea:	b8 01 00 00 00       	mov    $0x1,%eax
  803cef:	31 d2                	xor    %edx,%edx
  803cf1:	f7 f7                	div    %edi
  803cf3:	89 c5                	mov    %eax,%ebp
  803cf5:	89 f0                	mov    %esi,%eax
  803cf7:	31 d2                	xor    %edx,%edx
  803cf9:	f7 f5                	div    %ebp
  803cfb:	89 c8                	mov    %ecx,%eax
  803cfd:	f7 f5                	div    %ebp
  803cff:	89 d0                	mov    %edx,%eax
  803d01:	e9 44 ff ff ff       	jmp    803c4a <__umoddi3+0x3e>
  803d06:	66 90                	xchg   %ax,%ax
  803d08:	89 c8                	mov    %ecx,%eax
  803d0a:	89 f2                	mov    %esi,%edx
  803d0c:	83 c4 1c             	add    $0x1c,%esp
  803d0f:	5b                   	pop    %ebx
  803d10:	5e                   	pop    %esi
  803d11:	5f                   	pop    %edi
  803d12:	5d                   	pop    %ebp
  803d13:	c3                   	ret    
  803d14:	3b 04 24             	cmp    (%esp),%eax
  803d17:	72 06                	jb     803d1f <__umoddi3+0x113>
  803d19:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803d1d:	77 0f                	ja     803d2e <__umoddi3+0x122>
  803d1f:	89 f2                	mov    %esi,%edx
  803d21:	29 f9                	sub    %edi,%ecx
  803d23:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803d27:	89 14 24             	mov    %edx,(%esp)
  803d2a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d2e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803d32:	8b 14 24             	mov    (%esp),%edx
  803d35:	83 c4 1c             	add    $0x1c,%esp
  803d38:	5b                   	pop    %ebx
  803d39:	5e                   	pop    %esi
  803d3a:	5f                   	pop    %edi
  803d3b:	5d                   	pop    %ebp
  803d3c:	c3                   	ret    
  803d3d:	8d 76 00             	lea    0x0(%esi),%esi
  803d40:	2b 04 24             	sub    (%esp),%eax
  803d43:	19 fa                	sbb    %edi,%edx
  803d45:	89 d1                	mov    %edx,%ecx
  803d47:	89 c6                	mov    %eax,%esi
  803d49:	e9 71 ff ff ff       	jmp    803cbf <__umoddi3+0xb3>
  803d4e:	66 90                	xchg   %ax,%ax
  803d50:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803d54:	72 ea                	jb     803d40 <__umoddi3+0x134>
  803d56:	89 d9                	mov    %ebx,%ecx
  803d58:	e9 62 ff ff ff       	jmp    803cbf <__umoddi3+0xb3>
