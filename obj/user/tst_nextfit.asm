
obj/user/tst_nextfit:     file format elf32-i386


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
  800031:	e8 b6 0b 00 00       	call   800bec <libmain>
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
	int Mega = 1024*1024;
  800043:	c7 45 d8 00 00 10 00 	movl   $0x100000,-0x28(%ebp)
	int kilo = 1024;
  80004a:	c7 45 d4 00 04 00 00 	movl   $0x400,-0x2c(%ebp)
	sys_set_uheap_strategy(UHP_PLACE_NEXTFIT);
  800051:	83 ec 0c             	sub    $0xc,%esp
  800054:	6a 03                	push   $0x3
  800056:	e8 f0 27 00 00       	call   80284b <sys_set_uheap_strategy>
  80005b:	83 c4 10             	add    $0x10,%esp

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80005e:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800062:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800069:	eb 29                	jmp    800094 <_main+0x5c>
		{
			if (myEnv->__uptr_pws[i].empty)
  80006b:	a1 20 50 80 00       	mov    0x805020,%eax
  800070:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800076:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800079:	89 d0                	mov    %edx,%eax
  80007b:	01 c0                	add    %eax,%eax
  80007d:	01 d0                	add    %edx,%eax
  80007f:	c1 e0 03             	shl    $0x3,%eax
  800082:	01 c8                	add    %ecx,%eax
  800084:	8a 40 04             	mov    0x4(%eax),%al
  800087:	84 c0                	test   %al,%al
  800089:	74 06                	je     800091 <_main+0x59>
			{
				fullWS = 0;
  80008b:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  80008f:	eb 12                	jmp    8000a3 <_main+0x6b>
	sys_set_uheap_strategy(UHP_PLACE_NEXTFIT);

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800091:	ff 45 f0             	incl   -0x10(%ebp)
  800094:	a1 20 50 80 00       	mov    0x805020,%eax
  800099:	8b 50 74             	mov    0x74(%eax),%edx
  80009c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80009f:	39 c2                	cmp    %eax,%edx
  8000a1:	77 c8                	ja     80006b <_main+0x33>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  8000a3:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  8000a7:	74 14                	je     8000bd <_main+0x85>
  8000a9:	83 ec 04             	sub    $0x4,%esp
  8000ac:	68 a0 3c 80 00       	push   $0x803ca0
  8000b1:	6a 18                	push   $0x18
  8000b3:	68 bc 3c 80 00       	push   $0x803cbc
  8000b8:	e8 6b 0c 00 00       	call   800d28 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000bd:	83 ec 0c             	sub    $0xc,%esp
  8000c0:	6a 00                	push   $0x0
  8000c2:	e8 41 1e 00 00       	call   801f08 <malloc>
  8000c7:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	//Make sure that the heap size is 512 MB
	int numOf2MBsInHeap = (USER_HEAP_MAX - USER_HEAP_START) / (2*Mega);
  8000ca:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000cd:	01 c0                	add    %eax,%eax
  8000cf:	89 c7                	mov    %eax,%edi
  8000d1:	b8 00 00 00 20       	mov    $0x20000000,%eax
  8000d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8000db:	f7 f7                	div    %edi
  8000dd:	89 45 d0             	mov    %eax,-0x30(%ebp)
	assert(numOf2MBsInHeap == 256);
  8000e0:	81 7d d0 00 01 00 00 	cmpl   $0x100,-0x30(%ebp)
  8000e7:	74 16                	je     8000ff <_main+0xc7>
  8000e9:	68 cf 3c 80 00       	push   $0x803ccf
  8000ee:	68 e6 3c 80 00       	push   $0x803ce6
  8000f3:	6a 20                	push   $0x20
  8000f5:	68 bc 3c 80 00       	push   $0x803cbc
  8000fa:	e8 29 0c 00 00       	call   800d28 <_panic>




	sys_set_uheap_strategy(UHP_PLACE_NEXTFIT);
  8000ff:	83 ec 0c             	sub    $0xc,%esp
  800102:	6a 03                	push   $0x3
  800104:	e8 42 27 00 00       	call   80284b <sys_set_uheap_strategy>
  800109:	83 c4 10             	add    $0x10,%esp

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80010c:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800110:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800117:	eb 29                	jmp    800142 <_main+0x10a>
		{
			if (myEnv->__uptr_pws[i].empty)
  800119:	a1 20 50 80 00       	mov    0x805020,%eax
  80011e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800124:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800127:	89 d0                	mov    %edx,%eax
  800129:	01 c0                	add    %eax,%eax
  80012b:	01 d0                	add    %edx,%eax
  80012d:	c1 e0 03             	shl    $0x3,%eax
  800130:	01 c8                	add    %ecx,%eax
  800132:	8a 40 04             	mov    0x4(%eax),%al
  800135:	84 c0                	test   %al,%al
  800137:	74 06                	je     80013f <_main+0x107>
			{
				fullWS = 0;
  800139:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
				break;
  80013d:	eb 12                	jmp    800151 <_main+0x119>
	sys_set_uheap_strategy(UHP_PLACE_NEXTFIT);

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  80013f:	ff 45 e8             	incl   -0x18(%ebp)
  800142:	a1 20 50 80 00       	mov    0x805020,%eax
  800147:	8b 50 74             	mov    0x74(%eax),%edx
  80014a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80014d:	39 c2                	cmp    %eax,%edx
  80014f:	77 c8                	ja     800119 <_main+0xe1>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800151:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  800155:	74 14                	je     80016b <_main+0x133>
  800157:	83 ec 04             	sub    $0x4,%esp
  80015a:	68 a0 3c 80 00       	push   $0x803ca0
  80015f:	6a 32                	push   $0x32
  800161:	68 bc 3c 80 00       	push   $0x803cbc
  800166:	e8 bd 0b 00 00       	call   800d28 <_panic>

	int freeFrames ;
	int usedDiskPages;

	//[0] Make sure there're available places in the WS
	int w = 0 ;
  80016b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	int requiredNumOfEmptyWSLocs = 2;
  800172:	c7 45 cc 02 00 00 00 	movl   $0x2,-0x34(%ebp)
	int numOfEmptyWSLocs = 0;
  800179:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	for (w = 0 ; w < myEnv->page_WS_max_size ; w++)
  800180:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800187:	eb 26                	jmp    8001af <_main+0x177>
	{
		if( myEnv->__uptr_pws[w].empty == 1)
  800189:	a1 20 50 80 00       	mov    0x805020,%eax
  80018e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800194:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800197:	89 d0                	mov    %edx,%eax
  800199:	01 c0                	add    %eax,%eax
  80019b:	01 d0                	add    %edx,%eax
  80019d:	c1 e0 03             	shl    $0x3,%eax
  8001a0:	01 c8                	add    %ecx,%eax
  8001a2:	8a 40 04             	mov    0x4(%eax),%al
  8001a5:	3c 01                	cmp    $0x1,%al
  8001a7:	75 03                	jne    8001ac <_main+0x174>
			numOfEmptyWSLocs++;
  8001a9:	ff 45 e0             	incl   -0x20(%ebp)

	//[0] Make sure there're available places in the WS
	int w = 0 ;
	int requiredNumOfEmptyWSLocs = 2;
	int numOfEmptyWSLocs = 0;
	for (w = 0 ; w < myEnv->page_WS_max_size ; w++)
  8001ac:	ff 45 e4             	incl   -0x1c(%ebp)
  8001af:	a1 20 50 80 00       	mov    0x805020,%eax
  8001b4:	8b 50 74             	mov    0x74(%eax),%edx
  8001b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001ba:	39 c2                	cmp    %eax,%edx
  8001bc:	77 cb                	ja     800189 <_main+0x151>
	{
		if( myEnv->__uptr_pws[w].empty == 1)
			numOfEmptyWSLocs++;
	}
	if (numOfEmptyWSLocs < requiredNumOfEmptyWSLocs)
  8001be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001c1:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  8001c4:	7d 14                	jge    8001da <_main+0x1a2>
		panic("Insufficient number of WS empty locations! please increase the PAGE_WS_MAX_SIZE");
  8001c6:	83 ec 04             	sub    $0x4,%esp
  8001c9:	68 fc 3c 80 00       	push   $0x803cfc
  8001ce:	6a 43                	push   $0x43
  8001d0:	68 bc 3c 80 00       	push   $0x803cbc
  8001d5:	e8 4e 0b 00 00       	call   800d28 <_panic>


	void* ptr_allocations[512] = {0};
  8001da:	8d 95 c0 f7 ff ff    	lea    -0x840(%ebp),%edx
  8001e0:	b9 00 02 00 00       	mov    $0x200,%ecx
  8001e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8001ea:	89 d7                	mov    %edx,%edi
  8001ec:	f3 ab                	rep stos %eax,%es:(%edi)
	int i;

	cprintf("This test has THREE cases. A pass message will be displayed after each one.\n");
  8001ee:	83 ec 0c             	sub    $0xc,%esp
  8001f1:	68 4c 3d 80 00       	push   $0x803d4c
  8001f6:	e8 e1 0d 00 00       	call   800fdc <cprintf>
  8001fb:	83 c4 10             	add    $0x10,%esp

	// allocate pages
	freeFrames = sys_calculate_free_frames() ;
  8001fe:	e8 33 21 00 00       	call   802336 <sys_calculate_free_frames>
  800203:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800206:	e8 cb 21 00 00       	call   8023d6 <sys_pf_calculate_allocated_pages>
  80020b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	for(i = 0; i< 256;i++)
  80020e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800215:	eb 20                	jmp    800237 <_main+0x1ff>
	{
		ptr_allocations[i] = malloc(2*Mega);
  800217:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80021a:	01 c0                	add    %eax,%eax
  80021c:	83 ec 0c             	sub    $0xc,%esp
  80021f:	50                   	push   %eax
  800220:	e8 e3 1c 00 00       	call   801f08 <malloc>
  800225:	83 c4 10             	add    $0x10,%esp
  800228:	89 c2                	mov    %eax,%edx
  80022a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80022d:	89 94 85 c0 f7 ff ff 	mov    %edx,-0x840(%ebp,%eax,4)
	cprintf("This test has THREE cases. A pass message will be displayed after each one.\n");

	// allocate pages
	freeFrames = sys_calculate_free_frames() ;
	usedDiskPages = sys_pf_calculate_allocated_pages();
	for(i = 0; i< 256;i++)
  800234:	ff 45 dc             	incl   -0x24(%ebp)
  800237:	81 7d dc ff 00 00 00 	cmpl   $0xff,-0x24(%ebp)
  80023e:	7e d7                	jle    800217 <_main+0x1df>
	{
		ptr_allocations[i] = malloc(2*Mega);
	}

	// randomly check the addresses of the allocation
	if( 	(uint32)ptr_allocations[0] != 0x80000000 ||
  800240:	8b 85 c0 f7 ff ff    	mov    -0x840(%ebp),%eax
  800246:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  80024b:	75 5b                	jne    8002a8 <_main+0x270>
			(uint32)ptr_allocations[2] != 0x80400000 ||
  80024d:	8b 85 c8 f7 ff ff    	mov    -0x838(%ebp),%eax
	{
		ptr_allocations[i] = malloc(2*Mega);
	}

	// randomly check the addresses of the allocation
	if( 	(uint32)ptr_allocations[0] != 0x80000000 ||
  800253:	3d 00 00 40 80       	cmp    $0x80400000,%eax
  800258:	75 4e                	jne    8002a8 <_main+0x270>
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
  80025a:	8b 85 e0 f7 ff ff    	mov    -0x820(%ebp),%eax
		ptr_allocations[i] = malloc(2*Mega);
	}

	// randomly check the addresses of the allocation
	if( 	(uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
  800260:	3d 00 00 00 81       	cmp    $0x81000000,%eax
  800265:	75 41                	jne    8002a8 <_main+0x270>
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[10] != 0x81400000 ||
  800267:	8b 85 e8 f7 ff ff    	mov    -0x818(%ebp),%eax
	}

	// randomly check the addresses of the allocation
	if( 	(uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
  80026d:	3d 00 00 40 81       	cmp    $0x81400000,%eax
  800272:	75 34                	jne    8002a8 <_main+0x270>
			(uint32)ptr_allocations[10] != 0x81400000 ||
			(uint32)ptr_allocations[15] != 0x81e00000 ||
  800274:	8b 85 fc f7 ff ff    	mov    -0x804(%ebp),%eax

	// randomly check the addresses of the allocation
	if( 	(uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[10] != 0x81400000 ||
  80027a:	3d 00 00 e0 81       	cmp    $0x81e00000,%eax
  80027f:	75 27                	jne    8002a8 <_main+0x270>
			(uint32)ptr_allocations[15] != 0x81e00000 ||
			(uint32)ptr_allocations[20] != 0x82800000 ||
  800281:	8b 85 10 f8 ff ff    	mov    -0x7f0(%ebp),%eax
	// randomly check the addresses of the allocation
	if( 	(uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[10] != 0x81400000 ||
			(uint32)ptr_allocations[15] != 0x81e00000 ||
  800287:	3d 00 00 80 82       	cmp    $0x82800000,%eax
  80028c:	75 1a                	jne    8002a8 <_main+0x270>
			(uint32)ptr_allocations[20] != 0x82800000 ||
			(uint32)ptr_allocations[25] != 0x83200000 ||
  80028e:	8b 85 24 f8 ff ff    	mov    -0x7dc(%ebp),%eax
	if( 	(uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[10] != 0x81400000 ||
			(uint32)ptr_allocations[15] != 0x81e00000 ||
			(uint32)ptr_allocations[20] != 0x82800000 ||
  800294:	3d 00 00 20 83       	cmp    $0x83200000,%eax
  800299:	75 0d                	jne    8002a8 <_main+0x270>
			(uint32)ptr_allocations[25] != 0x83200000 ||
			(uint32)ptr_allocations[255] != 0x9FE00000)
  80029b:	8b 85 bc fb ff ff    	mov    -0x444(%ebp),%eax
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[10] != 0x81400000 ||
			(uint32)ptr_allocations[15] != 0x81e00000 ||
			(uint32)ptr_allocations[20] != 0x82800000 ||
			(uint32)ptr_allocations[25] != 0x83200000 ||
  8002a1:	3d 00 00 e0 9f       	cmp    $0x9fe00000,%eax
  8002a6:	74 14                	je     8002bc <_main+0x284>
			(uint32)ptr_allocations[255] != 0x9FE00000)
		panic("Wrong allocation, Check fitting strategy is working correctly");
  8002a8:	83 ec 04             	sub    $0x4,%esp
  8002ab:	68 9c 3d 80 00       	push   $0x803d9c
  8002b0:	6a 5c                	push   $0x5c
  8002b2:	68 bc 3c 80 00       	push   $0x803cbc
  8002b7:	e8 6c 0a 00 00       	call   800d28 <_panic>

	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8002bc:	e8 15 21 00 00       	call   8023d6 <sys_pf_calculate_allocated_pages>
  8002c1:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8002c4:	89 c2                	mov    %eax,%edx
  8002c6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002c9:	c1 e0 09             	shl    $0x9,%eax
  8002cc:	85 c0                	test   %eax,%eax
  8002ce:	79 05                	jns    8002d5 <_main+0x29d>
  8002d0:	05 ff 0f 00 00       	add    $0xfff,%eax
  8002d5:	c1 f8 0c             	sar    $0xc,%eax
  8002d8:	39 c2                	cmp    %eax,%edx
  8002da:	74 14                	je     8002f0 <_main+0x2b8>
  8002dc:	83 ec 04             	sub    $0x4,%esp
  8002df:	68 da 3d 80 00       	push   $0x803dda
  8002e4:	6a 5e                	push   $0x5e
  8002e6:	68 bc 3c 80 00       	push   $0x803cbc
  8002eb:	e8 38 0a 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != (512*Mega)/(1024*PAGE_SIZE) ) panic("Wrong allocation");
  8002f0:	8b 5d c8             	mov    -0x38(%ebp),%ebx
  8002f3:	e8 3e 20 00 00       	call   802336 <sys_calculate_free_frames>
  8002f8:	29 c3                	sub    %eax,%ebx
  8002fa:	89 da                	mov    %ebx,%edx
  8002fc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002ff:	c1 e0 09             	shl    $0x9,%eax
  800302:	85 c0                	test   %eax,%eax
  800304:	79 05                	jns    80030b <_main+0x2d3>
  800306:	05 ff ff 3f 00       	add    $0x3fffff,%eax
  80030b:	c1 f8 16             	sar    $0x16,%eax
  80030e:	39 c2                	cmp    %eax,%edx
  800310:	74 14                	je     800326 <_main+0x2ee>
  800312:	83 ec 04             	sub    $0x4,%esp
  800315:	68 f7 3d 80 00       	push   $0x803df7
  80031a:	6a 5f                	push   $0x5f
  80031c:	68 bc 3c 80 00       	push   $0x803cbc
  800321:	e8 02 0a 00 00       	call   800d28 <_panic>

	// Make memory holes.
	freeFrames = sys_calculate_free_frames() ;
  800326:	e8 0b 20 00 00       	call   802336 <sys_calculate_free_frames>
  80032b:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  80032e:	e8 a3 20 00 00       	call   8023d6 <sys_pf_calculate_allocated_pages>
  800333:	89 45 c4             	mov    %eax,-0x3c(%ebp)

	free(ptr_allocations[0]);		// Hole 1 = 2 M
  800336:	8b 85 c0 f7 ff ff    	mov    -0x840(%ebp),%eax
  80033c:	83 ec 0c             	sub    $0xc,%esp
  80033f:	50                   	push   %eax
  800340:	e8 3e 1c 00 00       	call   801f83 <free>
  800345:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[2]);		// Hole 2 = 4 M
  800348:	8b 85 c8 f7 ff ff    	mov    -0x838(%ebp),%eax
  80034e:	83 ec 0c             	sub    $0xc,%esp
  800351:	50                   	push   %eax
  800352:	e8 2c 1c 00 00       	call   801f83 <free>
  800357:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[3]);
  80035a:	8b 85 cc f7 ff ff    	mov    -0x834(%ebp),%eax
  800360:	83 ec 0c             	sub    $0xc,%esp
  800363:	50                   	push   %eax
  800364:	e8 1a 1c 00 00       	call   801f83 <free>
  800369:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[5]);		// Hole 3 = 2 M
  80036c:	8b 85 d4 f7 ff ff    	mov    -0x82c(%ebp),%eax
  800372:	83 ec 0c             	sub    $0xc,%esp
  800375:	50                   	push   %eax
  800376:	e8 08 1c 00 00       	call   801f83 <free>
  80037b:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[10]);		// Hole 4 = 6 M
  80037e:	8b 85 e8 f7 ff ff    	mov    -0x818(%ebp),%eax
  800384:	83 ec 0c             	sub    $0xc,%esp
  800387:	50                   	push   %eax
  800388:	e8 f6 1b 00 00       	call   801f83 <free>
  80038d:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[12]);
  800390:	8b 85 f0 f7 ff ff    	mov    -0x810(%ebp),%eax
  800396:	83 ec 0c             	sub    $0xc,%esp
  800399:	50                   	push   %eax
  80039a:	e8 e4 1b 00 00       	call   801f83 <free>
  80039f:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[11]);
  8003a2:	8b 85 ec f7 ff ff    	mov    -0x814(%ebp),%eax
  8003a8:	83 ec 0c             	sub    $0xc,%esp
  8003ab:	50                   	push   %eax
  8003ac:	e8 d2 1b 00 00       	call   801f83 <free>
  8003b1:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[20]);		// Hole 5 = 2 M
  8003b4:	8b 85 10 f8 ff ff    	mov    -0x7f0(%ebp),%eax
  8003ba:	83 ec 0c             	sub    $0xc,%esp
  8003bd:	50                   	push   %eax
  8003be:	e8 c0 1b 00 00       	call   801f83 <free>
  8003c3:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[25]);		// Hole 6 = 2 M
  8003c6:	8b 85 24 f8 ff ff    	mov    -0x7dc(%ebp),%eax
  8003cc:	83 ec 0c             	sub    $0xc,%esp
  8003cf:	50                   	push   %eax
  8003d0:	e8 ae 1b 00 00       	call   801f83 <free>
  8003d5:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[255]);		// Hole 7 = 2 M
  8003d8:	8b 85 bc fb ff ff    	mov    -0x444(%ebp),%eax
  8003de:	83 ec 0c             	sub    $0xc,%esp
  8003e1:	50                   	push   %eax
  8003e2:	e8 9c 1b 00 00       	call   801f83 <free>
  8003e7:	83 c4 10             	add    $0x10,%esp

	if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 10*(2*Mega)/PAGE_SIZE) panic("Wrong free: Extra or less pages are removed from PageFile");
  8003ea:	e8 e7 1f 00 00       	call   8023d6 <sys_pf_calculate_allocated_pages>
  8003ef:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8003f2:	89 d1                	mov    %edx,%ecx
  8003f4:	29 c1                	sub    %eax,%ecx
  8003f6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8003f9:	89 d0                	mov    %edx,%eax
  8003fb:	c1 e0 02             	shl    $0x2,%eax
  8003fe:	01 d0                	add    %edx,%eax
  800400:	c1 e0 02             	shl    $0x2,%eax
  800403:	85 c0                	test   %eax,%eax
  800405:	79 05                	jns    80040c <_main+0x3d4>
  800407:	05 ff 0f 00 00       	add    $0xfff,%eax
  80040c:	c1 f8 0c             	sar    $0xc,%eax
  80040f:	39 c1                	cmp    %eax,%ecx
  800411:	74 14                	je     800427 <_main+0x3ef>
  800413:	83 ec 04             	sub    $0x4,%esp
  800416:	68 08 3e 80 00       	push   $0x803e08
  80041b:	6a 70                	push   $0x70
  80041d:	68 bc 3c 80 00       	push   $0x803cbc
  800422:	e8 01 09 00 00       	call   800d28 <_panic>
	if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: Extra or less pages are removed from main memory");
  800427:	e8 0a 1f 00 00       	call   802336 <sys_calculate_free_frames>
  80042c:	89 c2                	mov    %eax,%edx
  80042e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800431:	39 c2                	cmp    %eax,%edx
  800433:	74 14                	je     800449 <_main+0x411>
  800435:	83 ec 04             	sub    $0x4,%esp
  800438:	68 44 3e 80 00       	push   $0x803e44
  80043d:	6a 71                	push   $0x71
  80043f:	68 bc 3c 80 00       	push   $0x803cbc
  800444:	e8 df 08 00 00       	call   800d28 <_panic>

	// Test next fit

	freeFrames = sys_calculate_free_frames() ;
  800449:	e8 e8 1e 00 00       	call   802336 <sys_calculate_free_frames>
  80044e:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800451:	e8 80 1f 00 00       	call   8023d6 <sys_pf_calculate_allocated_pages>
  800456:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	void* tempAddress = malloc(Mega-kilo);		// Use Hole 1 -> Hole 1 = 1 M
  800459:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80045c:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80045f:	83 ec 0c             	sub    $0xc,%esp
  800462:	50                   	push   %eax
  800463:	e8 a0 1a 00 00       	call   801f08 <malloc>
  800468:	83 c4 10             	add    $0x10,%esp
  80046b:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x80000000)
  80046e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800471:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800476:	74 14                	je     80048c <_main+0x454>
		panic("Next Fit not working correctly");
  800478:	83 ec 04             	sub    $0x4,%esp
  80047b:	68 84 3e 80 00       	push   $0x803e84
  800480:	6a 79                	push   $0x79
  800482:	68 bc 3c 80 00       	push   $0x803cbc
  800487:	e8 9c 08 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  80048c:	e8 45 1f 00 00       	call   8023d6 <sys_pf_calculate_allocated_pages>
  800491:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  800494:	89 c2                	mov    %eax,%edx
  800496:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800499:	85 c0                	test   %eax,%eax
  80049b:	79 05                	jns    8004a2 <_main+0x46a>
  80049d:	05 ff 0f 00 00       	add    $0xfff,%eax
  8004a2:	c1 f8 0c             	sar    $0xc,%eax
  8004a5:	39 c2                	cmp    %eax,%edx
  8004a7:	74 14                	je     8004bd <_main+0x485>
  8004a9:	83 ec 04             	sub    $0x4,%esp
  8004ac:	68 da 3d 80 00       	push   $0x803dda
  8004b1:	6a 7a                	push   $0x7a
  8004b3:	68 bc 3c 80 00       	push   $0x803cbc
  8004b8:	e8 6b 08 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  8004bd:	e8 74 1e 00 00       	call   802336 <sys_calculate_free_frames>
  8004c2:	89 c2                	mov    %eax,%edx
  8004c4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004c7:	39 c2                	cmp    %eax,%edx
  8004c9:	74 14                	je     8004df <_main+0x4a7>
  8004cb:	83 ec 04             	sub    $0x4,%esp
  8004ce:	68 f7 3d 80 00       	push   $0x803df7
  8004d3:	6a 7b                	push   $0x7b
  8004d5:	68 bc 3c 80 00       	push   $0x803cbc
  8004da:	e8 49 08 00 00       	call   800d28 <_panic>

	freeFrames = sys_calculate_free_frames() ;
  8004df:	e8 52 1e 00 00       	call   802336 <sys_calculate_free_frames>
  8004e4:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8004e7:	e8 ea 1e 00 00       	call   8023d6 <sys_pf_calculate_allocated_pages>
  8004ec:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(kilo);					// Use Hole 1 -> Hole 1 = 1 M - Kilo
  8004ef:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004f2:	83 ec 0c             	sub    $0xc,%esp
  8004f5:	50                   	push   %eax
  8004f6:	e8 0d 1a 00 00       	call   801f08 <malloc>
  8004fb:	83 c4 10             	add    $0x10,%esp
  8004fe:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x80100000)
  800501:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800504:	3d 00 00 10 80       	cmp    $0x80100000,%eax
  800509:	74 17                	je     800522 <_main+0x4ea>
		panic("Next Fit not working correctly");
  80050b:	83 ec 04             	sub    $0x4,%esp
  80050e:	68 84 3e 80 00       	push   $0x803e84
  800513:	68 81 00 00 00       	push   $0x81
  800518:	68 bc 3c 80 00       	push   $0x803cbc
  80051d:	e8 06 08 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*kilo/PAGE_SIZE) panic("Wrong page file allocation: ");
  800522:	e8 af 1e 00 00       	call   8023d6 <sys_pf_calculate_allocated_pages>
  800527:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80052a:	89 c2                	mov    %eax,%edx
  80052c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80052f:	c1 e0 02             	shl    $0x2,%eax
  800532:	85 c0                	test   %eax,%eax
  800534:	79 05                	jns    80053b <_main+0x503>
  800536:	05 ff 0f 00 00       	add    $0xfff,%eax
  80053b:	c1 f8 0c             	sar    $0xc,%eax
  80053e:	39 c2                	cmp    %eax,%edx
  800540:	74 17                	je     800559 <_main+0x521>
  800542:	83 ec 04             	sub    $0x4,%esp
  800545:	68 da 3d 80 00       	push   $0x803dda
  80054a:	68 82 00 00 00       	push   $0x82
  80054f:	68 bc 3c 80 00       	push   $0x803cbc
  800554:	e8 cf 07 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800559:	e8 d8 1d 00 00       	call   802336 <sys_calculate_free_frames>
  80055e:	89 c2                	mov    %eax,%edx
  800560:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800563:	39 c2                	cmp    %eax,%edx
  800565:	74 17                	je     80057e <_main+0x546>
  800567:	83 ec 04             	sub    $0x4,%esp
  80056a:	68 f7 3d 80 00       	push   $0x803df7
  80056f:	68 83 00 00 00       	push   $0x83
  800574:	68 bc 3c 80 00       	push   $0x803cbc
  800579:	e8 aa 07 00 00       	call   800d28 <_panic>

	freeFrames = sys_calculate_free_frames() ;
  80057e:	e8 b3 1d 00 00       	call   802336 <sys_calculate_free_frames>
  800583:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800586:	e8 4b 1e 00 00       	call   8023d6 <sys_pf_calculate_allocated_pages>
  80058b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(5*Mega); 			   // Use Hole 4 -> Hole 4 = 1 M
  80058e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800591:	89 d0                	mov    %edx,%eax
  800593:	c1 e0 02             	shl    $0x2,%eax
  800596:	01 d0                	add    %edx,%eax
  800598:	83 ec 0c             	sub    $0xc,%esp
  80059b:	50                   	push   %eax
  80059c:	e8 67 19 00 00       	call   801f08 <malloc>
  8005a1:	83 c4 10             	add    $0x10,%esp
  8005a4:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x81400000)
  8005a7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8005aa:	3d 00 00 40 81       	cmp    $0x81400000,%eax
  8005af:	74 17                	je     8005c8 <_main+0x590>
		panic("Next Fit not working correctly");
  8005b1:	83 ec 04             	sub    $0x4,%esp
  8005b4:	68 84 3e 80 00       	push   $0x803e84
  8005b9:	68 89 00 00 00       	push   $0x89
  8005be:	68 bc 3c 80 00       	push   $0x803cbc
  8005c3:	e8 60 07 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  5*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8005c8:	e8 09 1e 00 00       	call   8023d6 <sys_pf_calculate_allocated_pages>
  8005cd:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8005d0:	89 c1                	mov    %eax,%ecx
  8005d2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005d5:	89 d0                	mov    %edx,%eax
  8005d7:	c1 e0 02             	shl    $0x2,%eax
  8005da:	01 d0                	add    %edx,%eax
  8005dc:	85 c0                	test   %eax,%eax
  8005de:	79 05                	jns    8005e5 <_main+0x5ad>
  8005e0:	05 ff 0f 00 00       	add    $0xfff,%eax
  8005e5:	c1 f8 0c             	sar    $0xc,%eax
  8005e8:	39 c1                	cmp    %eax,%ecx
  8005ea:	74 17                	je     800603 <_main+0x5cb>
  8005ec:	83 ec 04             	sub    $0x4,%esp
  8005ef:	68 da 3d 80 00       	push   $0x803dda
  8005f4:	68 8a 00 00 00       	push   $0x8a
  8005f9:	68 bc 3c 80 00       	push   $0x803cbc
  8005fe:	e8 25 07 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800603:	e8 2e 1d 00 00       	call   802336 <sys_calculate_free_frames>
  800608:	89 c2                	mov    %eax,%edx
  80060a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80060d:	39 c2                	cmp    %eax,%edx
  80060f:	74 17                	je     800628 <_main+0x5f0>
  800611:	83 ec 04             	sub    $0x4,%esp
  800614:	68 f7 3d 80 00       	push   $0x803df7
  800619:	68 8b 00 00 00       	push   $0x8b
  80061e:	68 bc 3c 80 00       	push   $0x803cbc
  800623:	e8 00 07 00 00       	call   800d28 <_panic>

	freeFrames = sys_calculate_free_frames() ;
  800628:	e8 09 1d 00 00       	call   802336 <sys_calculate_free_frames>
  80062d:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800630:	e8 a1 1d 00 00       	call   8023d6 <sys_pf_calculate_allocated_pages>
  800635:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(1*Mega); 			   // Use Hole 4 -> Hole 4 = 0 M
  800638:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80063b:	83 ec 0c             	sub    $0xc,%esp
  80063e:	50                   	push   %eax
  80063f:	e8 c4 18 00 00       	call   801f08 <malloc>
  800644:	83 c4 10             	add    $0x10,%esp
  800647:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x81900000)
  80064a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80064d:	3d 00 00 90 81       	cmp    $0x81900000,%eax
  800652:	74 17                	je     80066b <_main+0x633>
		panic("Next Fit not working correctly");
  800654:	83 ec 04             	sub    $0x4,%esp
  800657:	68 84 3e 80 00       	push   $0x803e84
  80065c:	68 91 00 00 00       	push   $0x91
  800661:	68 bc 3c 80 00       	push   $0x803cbc
  800666:	e8 bd 06 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  80066b:	e8 66 1d 00 00       	call   8023d6 <sys_pf_calculate_allocated_pages>
  800670:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  800673:	89 c2                	mov    %eax,%edx
  800675:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800678:	85 c0                	test   %eax,%eax
  80067a:	79 05                	jns    800681 <_main+0x649>
  80067c:	05 ff 0f 00 00       	add    $0xfff,%eax
  800681:	c1 f8 0c             	sar    $0xc,%eax
  800684:	39 c2                	cmp    %eax,%edx
  800686:	74 17                	je     80069f <_main+0x667>
  800688:	83 ec 04             	sub    $0x4,%esp
  80068b:	68 da 3d 80 00       	push   $0x803dda
  800690:	68 92 00 00 00       	push   $0x92
  800695:	68 bc 3c 80 00       	push   $0x803cbc
  80069a:	e8 89 06 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  80069f:	e8 92 1c 00 00       	call   802336 <sys_calculate_free_frames>
  8006a4:	89 c2                	mov    %eax,%edx
  8006a6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8006a9:	39 c2                	cmp    %eax,%edx
  8006ab:	74 17                	je     8006c4 <_main+0x68c>
  8006ad:	83 ec 04             	sub    $0x4,%esp
  8006b0:	68 f7 3d 80 00       	push   $0x803df7
  8006b5:	68 93 00 00 00       	push   $0x93
  8006ba:	68 bc 3c 80 00       	push   $0x803cbc
  8006bf:	e8 64 06 00 00       	call   800d28 <_panic>


	freeFrames = sys_calculate_free_frames() ;
  8006c4:	e8 6d 1c 00 00       	call   802336 <sys_calculate_free_frames>
  8006c9:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8006cc:	e8 05 1d 00 00       	call   8023d6 <sys_pf_calculate_allocated_pages>
  8006d1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	free(ptr_allocations[15]);					// Make a new hole => 2 M
  8006d4:	8b 85 fc f7 ff ff    	mov    -0x804(%ebp),%eax
  8006da:	83 ec 0c             	sub    $0xc,%esp
  8006dd:	50                   	push   %eax
  8006de:	e8 a0 18 00 00       	call   801f83 <free>
  8006e3:	83 c4 10             	add    $0x10,%esp
	if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 2*Mega/PAGE_SIZE) panic("Wrong free: Extra or less pages are removed from PageFile");
  8006e6:	e8 eb 1c 00 00       	call   8023d6 <sys_pf_calculate_allocated_pages>
  8006eb:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8006ee:	29 c2                	sub    %eax,%edx
  8006f0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006f3:	01 c0                	add    %eax,%eax
  8006f5:	85 c0                	test   %eax,%eax
  8006f7:	79 05                	jns    8006fe <_main+0x6c6>
  8006f9:	05 ff 0f 00 00       	add    $0xfff,%eax
  8006fe:	c1 f8 0c             	sar    $0xc,%eax
  800701:	39 c2                	cmp    %eax,%edx
  800703:	74 17                	je     80071c <_main+0x6e4>
  800705:	83 ec 04             	sub    $0x4,%esp
  800708:	68 08 3e 80 00       	push   $0x803e08
  80070d:	68 99 00 00 00       	push   $0x99
  800712:	68 bc 3c 80 00       	push   $0x803cbc
  800717:	e8 0c 06 00 00       	call   800d28 <_panic>
	if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: Extra or less pages are removed from main memory");
  80071c:	e8 15 1c 00 00       	call   802336 <sys_calculate_free_frames>
  800721:	89 c2                	mov    %eax,%edx
  800723:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800726:	39 c2                	cmp    %eax,%edx
  800728:	74 17                	je     800741 <_main+0x709>
  80072a:	83 ec 04             	sub    $0x4,%esp
  80072d:	68 44 3e 80 00       	push   $0x803e44
  800732:	68 9a 00 00 00       	push   $0x9a
  800737:	68 bc 3c 80 00       	push   $0x803cbc
  80073c:	e8 e7 05 00 00       	call   800d28 <_panic>

	//[NEXT FIT Case]
	freeFrames = sys_calculate_free_frames() ;
  800741:	e8 f0 1b 00 00       	call   802336 <sys_calculate_free_frames>
  800746:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800749:	e8 88 1c 00 00       	call   8023d6 <sys_pf_calculate_allocated_pages>
  80074e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(kilo); 			   // Use new Hole = 2 M - 4 kilo
  800751:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800754:	83 ec 0c             	sub    $0xc,%esp
  800757:	50                   	push   %eax
  800758:	e8 ab 17 00 00       	call   801f08 <malloc>
  80075d:	83 c4 10             	add    $0x10,%esp
  800760:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x81E00000)
  800763:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800766:	3d 00 00 e0 81       	cmp    $0x81e00000,%eax
  80076b:	74 17                	je     800784 <_main+0x74c>
		panic("Next Fit not working correctly");
  80076d:	83 ec 04             	sub    $0x4,%esp
  800770:	68 84 3e 80 00       	push   $0x803e84
  800775:	68 a1 00 00 00       	push   $0xa1
  80077a:	68 bc 3c 80 00       	push   $0x803cbc
  80077f:	e8 a4 05 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*kilo/PAGE_SIZE) panic("Wrong page file allocation: ");
  800784:	e8 4d 1c 00 00       	call   8023d6 <sys_pf_calculate_allocated_pages>
  800789:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80078c:	89 c2                	mov    %eax,%edx
  80078e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800791:	c1 e0 02             	shl    $0x2,%eax
  800794:	85 c0                	test   %eax,%eax
  800796:	79 05                	jns    80079d <_main+0x765>
  800798:	05 ff 0f 00 00       	add    $0xfff,%eax
  80079d:	c1 f8 0c             	sar    $0xc,%eax
  8007a0:	39 c2                	cmp    %eax,%edx
  8007a2:	74 17                	je     8007bb <_main+0x783>
  8007a4:	83 ec 04             	sub    $0x4,%esp
  8007a7:	68 da 3d 80 00       	push   $0x803dda
  8007ac:	68 a2 00 00 00       	push   $0xa2
  8007b1:	68 bc 3c 80 00       	push   $0x803cbc
  8007b6:	e8 6d 05 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  8007bb:	e8 76 1b 00 00       	call   802336 <sys_calculate_free_frames>
  8007c0:	89 c2                	mov    %eax,%edx
  8007c2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8007c5:	39 c2                	cmp    %eax,%edx
  8007c7:	74 17                	je     8007e0 <_main+0x7a8>
  8007c9:	83 ec 04             	sub    $0x4,%esp
  8007cc:	68 f7 3d 80 00       	push   $0x803df7
  8007d1:	68 a3 00 00 00       	push   $0xa3
  8007d6:	68 bc 3c 80 00       	push   $0x803cbc
  8007db:	e8 48 05 00 00       	call   800d28 <_panic>

	freeFrames = sys_calculate_free_frames() ;
  8007e0:	e8 51 1b 00 00       	call   802336 <sys_calculate_free_frames>
  8007e5:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8007e8:	e8 e9 1b 00 00       	call   8023d6 <sys_pf_calculate_allocated_pages>
  8007ed:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(Mega + 1016*kilo); 	// Use new Hole = 4 kilo
  8007f0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8007f3:	c1 e0 03             	shl    $0x3,%eax
  8007f6:	89 c2                	mov    %eax,%edx
  8007f8:	c1 e2 07             	shl    $0x7,%edx
  8007fb:	29 c2                	sub    %eax,%edx
  8007fd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800800:	01 d0                	add    %edx,%eax
  800802:	83 ec 0c             	sub    $0xc,%esp
  800805:	50                   	push   %eax
  800806:	e8 fd 16 00 00       	call   801f08 <malloc>
  80080b:	83 c4 10             	add    $0x10,%esp
  80080e:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x81E01000)
  800811:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800814:	3d 00 10 e0 81       	cmp    $0x81e01000,%eax
  800819:	74 17                	je     800832 <_main+0x7fa>
		panic("Next Fit not working correctly");
  80081b:	83 ec 04             	sub    $0x4,%esp
  80081e:	68 84 3e 80 00       	push   $0x803e84
  800823:	68 a9 00 00 00       	push   $0xa9
  800828:	68 bc 3c 80 00       	push   $0x803cbc
  80082d:	e8 f6 04 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  (1*Mega+1016*kilo)/PAGE_SIZE) panic("Wrong page file allocation: ");
  800832:	e8 9f 1b 00 00       	call   8023d6 <sys_pf_calculate_allocated_pages>
  800837:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80083a:	89 c2                	mov    %eax,%edx
  80083c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80083f:	c1 e0 03             	shl    $0x3,%eax
  800842:	89 c1                	mov    %eax,%ecx
  800844:	c1 e1 07             	shl    $0x7,%ecx
  800847:	29 c1                	sub    %eax,%ecx
  800849:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80084c:	01 c8                	add    %ecx,%eax
  80084e:	85 c0                	test   %eax,%eax
  800850:	79 05                	jns    800857 <_main+0x81f>
  800852:	05 ff 0f 00 00       	add    $0xfff,%eax
  800857:	c1 f8 0c             	sar    $0xc,%eax
  80085a:	39 c2                	cmp    %eax,%edx
  80085c:	74 17                	je     800875 <_main+0x83d>
  80085e:	83 ec 04             	sub    $0x4,%esp
  800861:	68 da 3d 80 00       	push   $0x803dda
  800866:	68 aa 00 00 00       	push   $0xaa
  80086b:	68 bc 3c 80 00       	push   $0x803cbc
  800870:	e8 b3 04 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800875:	e8 bc 1a 00 00       	call   802336 <sys_calculate_free_frames>
  80087a:	89 c2                	mov    %eax,%edx
  80087c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80087f:	39 c2                	cmp    %eax,%edx
  800881:	74 17                	je     80089a <_main+0x862>
  800883:	83 ec 04             	sub    $0x4,%esp
  800886:	68 f7 3d 80 00       	push   $0x803df7
  80088b:	68 ab 00 00 00       	push   $0xab
  800890:	68 bc 3c 80 00       	push   $0x803cbc
  800895:	e8 8e 04 00 00       	call   800d28 <_panic>

	freeFrames = sys_calculate_free_frames() ;
  80089a:	e8 97 1a 00 00       	call   802336 <sys_calculate_free_frames>
  80089f:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8008a2:	e8 2f 1b 00 00       	call   8023d6 <sys_pf_calculate_allocated_pages>
  8008a7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(512*kilo); 			   // Use Hole 5 -> Hole 5 = 1.5 M
  8008aa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8008ad:	c1 e0 09             	shl    $0x9,%eax
  8008b0:	83 ec 0c             	sub    $0xc,%esp
  8008b3:	50                   	push   %eax
  8008b4:	e8 4f 16 00 00       	call   801f08 <malloc>
  8008b9:	83 c4 10             	add    $0x10,%esp
  8008bc:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x82800000)
  8008bf:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8008c2:	3d 00 00 80 82       	cmp    $0x82800000,%eax
  8008c7:	74 17                	je     8008e0 <_main+0x8a8>
		panic("Next Fit not working correctly");
  8008c9:	83 ec 04             	sub    $0x4,%esp
  8008cc:	68 84 3e 80 00       	push   $0x803e84
  8008d1:	68 b1 00 00 00       	push   $0xb1
  8008d6:	68 bc 3c 80 00       	push   $0x803cbc
  8008db:	e8 48 04 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512*kilo/PAGE_SIZE) panic("Wrong page file allocation: ");
  8008e0:	e8 f1 1a 00 00       	call   8023d6 <sys_pf_calculate_allocated_pages>
  8008e5:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8008e8:	89 c2                	mov    %eax,%edx
  8008ea:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8008ed:	c1 e0 09             	shl    $0x9,%eax
  8008f0:	85 c0                	test   %eax,%eax
  8008f2:	79 05                	jns    8008f9 <_main+0x8c1>
  8008f4:	05 ff 0f 00 00       	add    $0xfff,%eax
  8008f9:	c1 f8 0c             	sar    $0xc,%eax
  8008fc:	39 c2                	cmp    %eax,%edx
  8008fe:	74 17                	je     800917 <_main+0x8df>
  800900:	83 ec 04             	sub    $0x4,%esp
  800903:	68 da 3d 80 00       	push   $0x803dda
  800908:	68 b2 00 00 00       	push   $0xb2
  80090d:	68 bc 3c 80 00       	push   $0x803cbc
  800912:	e8 11 04 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800917:	e8 1a 1a 00 00       	call   802336 <sys_calculate_free_frames>
  80091c:	89 c2                	mov    %eax,%edx
  80091e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800921:	39 c2                	cmp    %eax,%edx
  800923:	74 17                	je     80093c <_main+0x904>
  800925:	83 ec 04             	sub    $0x4,%esp
  800928:	68 f7 3d 80 00       	push   $0x803df7
  80092d:	68 b3 00 00 00       	push   $0xb3
  800932:	68 bc 3c 80 00       	push   $0x803cbc
  800937:	e8 ec 03 00 00       	call   800d28 <_panic>

	cprintf("\nCASE1: (next fit without looping back) is succeeded...\n") ;
  80093c:	83 ec 0c             	sub    $0xc,%esp
  80093f:	68 a4 3e 80 00       	push   $0x803ea4
  800944:	e8 93 06 00 00       	call   800fdc <cprintf>
  800949:	83 c4 10             	add    $0x10,%esp

	// Check that next fit is looping back to check for free space
	freeFrames = sys_calculate_free_frames() ;
  80094c:	e8 e5 19 00 00       	call   802336 <sys_calculate_free_frames>
  800951:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800954:	e8 7d 1a 00 00       	call   8023d6 <sys_pf_calculate_allocated_pages>
  800959:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(3*Mega + 512*kilo); 			   // Use Hole 2 -> Hole 2 = 0.5 M
  80095c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80095f:	89 c2                	mov    %eax,%edx
  800961:	01 d2                	add    %edx,%edx
  800963:	01 c2                	add    %eax,%edx
  800965:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800968:	c1 e0 09             	shl    $0x9,%eax
  80096b:	01 d0                	add    %edx,%eax
  80096d:	83 ec 0c             	sub    $0xc,%esp
  800970:	50                   	push   %eax
  800971:	e8 92 15 00 00       	call   801f08 <malloc>
  800976:	83 c4 10             	add    $0x10,%esp
  800979:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x80400000)
  80097c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80097f:	3d 00 00 40 80       	cmp    $0x80400000,%eax
  800984:	74 17                	je     80099d <_main+0x965>
		panic("Next Fit not working correctly");
  800986:	83 ec 04             	sub    $0x4,%esp
  800989:	68 84 3e 80 00       	push   $0x803e84
  80098e:	68 bc 00 00 00       	push   $0xbc
  800993:	68 bc 3c 80 00       	push   $0x803cbc
  800998:	e8 8b 03 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  (3*Mega+512*kilo)/PAGE_SIZE) panic("Wrong page file allocation: ");
  80099d:	e8 34 1a 00 00       	call   8023d6 <sys_pf_calculate_allocated_pages>
  8009a2:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8009a5:	89 c2                	mov    %eax,%edx
  8009a7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009aa:	89 c1                	mov    %eax,%ecx
  8009ac:	01 c9                	add    %ecx,%ecx
  8009ae:	01 c1                	add    %eax,%ecx
  8009b0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8009b3:	c1 e0 09             	shl    $0x9,%eax
  8009b6:	01 c8                	add    %ecx,%eax
  8009b8:	85 c0                	test   %eax,%eax
  8009ba:	79 05                	jns    8009c1 <_main+0x989>
  8009bc:	05 ff 0f 00 00       	add    $0xfff,%eax
  8009c1:	c1 f8 0c             	sar    $0xc,%eax
  8009c4:	39 c2                	cmp    %eax,%edx
  8009c6:	74 17                	je     8009df <_main+0x9a7>
  8009c8:	83 ec 04             	sub    $0x4,%esp
  8009cb:	68 da 3d 80 00       	push   $0x803dda
  8009d0:	68 bd 00 00 00       	push   $0xbd
  8009d5:	68 bc 3c 80 00       	push   $0x803cbc
  8009da:	e8 49 03 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  8009df:	e8 52 19 00 00       	call   802336 <sys_calculate_free_frames>
  8009e4:	89 c2                	mov    %eax,%edx
  8009e6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8009e9:	39 c2                	cmp    %eax,%edx
  8009eb:	74 17                	je     800a04 <_main+0x9cc>
  8009ed:	83 ec 04             	sub    $0x4,%esp
  8009f0:	68 f7 3d 80 00       	push   $0x803df7
  8009f5:	68 be 00 00 00       	push   $0xbe
  8009fa:	68 bc 3c 80 00       	push   $0x803cbc
  8009ff:	e8 24 03 00 00       	call   800d28 <_panic>


	freeFrames = sys_calculate_free_frames() ;
  800a04:	e8 2d 19 00 00       	call   802336 <sys_calculate_free_frames>
  800a09:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800a0c:	e8 c5 19 00 00       	call   8023d6 <sys_pf_calculate_allocated_pages>
  800a11:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	free(ptr_allocations[24]);		// Increase size of Hole 6 to 4 M
  800a14:	8b 85 20 f8 ff ff    	mov    -0x7e0(%ebp),%eax
  800a1a:	83 ec 0c             	sub    $0xc,%esp
  800a1d:	50                   	push   %eax
  800a1e:	e8 60 15 00 00       	call   801f83 <free>
  800a23:	83 c4 10             	add    $0x10,%esp
	if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 2*Mega/PAGE_SIZE) panic("Wrong free: Extra or less pages are removed from PageFile");
  800a26:	e8 ab 19 00 00       	call   8023d6 <sys_pf_calculate_allocated_pages>
  800a2b:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800a2e:	29 c2                	sub    %eax,%edx
  800a30:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a33:	01 c0                	add    %eax,%eax
  800a35:	85 c0                	test   %eax,%eax
  800a37:	79 05                	jns    800a3e <_main+0xa06>
  800a39:	05 ff 0f 00 00       	add    $0xfff,%eax
  800a3e:	c1 f8 0c             	sar    $0xc,%eax
  800a41:	39 c2                	cmp    %eax,%edx
  800a43:	74 17                	je     800a5c <_main+0xa24>
  800a45:	83 ec 04             	sub    $0x4,%esp
  800a48:	68 08 3e 80 00       	push   $0x803e08
  800a4d:	68 c4 00 00 00       	push   $0xc4
  800a52:	68 bc 3c 80 00       	push   $0x803cbc
  800a57:	e8 cc 02 00 00       	call   800d28 <_panic>
	if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: Extra or less pages are removed from main memory");
  800a5c:	e8 d5 18 00 00       	call   802336 <sys_calculate_free_frames>
  800a61:	89 c2                	mov    %eax,%edx
  800a63:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800a66:	39 c2                	cmp    %eax,%edx
  800a68:	74 17                	je     800a81 <_main+0xa49>
  800a6a:	83 ec 04             	sub    $0x4,%esp
  800a6d:	68 44 3e 80 00       	push   $0x803e44
  800a72:	68 c5 00 00 00       	push   $0xc5
  800a77:	68 bc 3c 80 00       	push   $0x803cbc
  800a7c:	e8 a7 02 00 00       	call   800d28 <_panic>


	freeFrames = sys_calculate_free_frames() ;
  800a81:	e8 b0 18 00 00       	call   802336 <sys_calculate_free_frames>
  800a86:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800a89:	e8 48 19 00 00       	call   8023d6 <sys_pf_calculate_allocated_pages>
  800a8e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(4*Mega-kilo);		// Use Hole 6 -> Hole 6 = 0 M
  800a91:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a94:	c1 e0 02             	shl    $0x2,%eax
  800a97:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  800a9a:	83 ec 0c             	sub    $0xc,%esp
  800a9d:	50                   	push   %eax
  800a9e:	e8 65 14 00 00       	call   801f08 <malloc>
  800aa3:	83 c4 10             	add    $0x10,%esp
  800aa6:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x83000000)
  800aa9:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800aac:	3d 00 00 00 83       	cmp    $0x83000000,%eax
  800ab1:	74 17                	je     800aca <_main+0xa92>
		panic("Next Fit not working correctly");
  800ab3:	83 ec 04             	sub    $0x4,%esp
  800ab6:	68 84 3e 80 00       	push   $0x803e84
  800abb:	68 cc 00 00 00       	push   $0xcc
  800ac0:	68 bc 3c 80 00       	push   $0x803cbc
  800ac5:	e8 5e 02 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  800aca:	e8 07 19 00 00       	call   8023d6 <sys_pf_calculate_allocated_pages>
  800acf:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  800ad2:	89 c2                	mov    %eax,%edx
  800ad4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800ad7:	c1 e0 02             	shl    $0x2,%eax
  800ada:	85 c0                	test   %eax,%eax
  800adc:	79 05                	jns    800ae3 <_main+0xaab>
  800ade:	05 ff 0f 00 00       	add    $0xfff,%eax
  800ae3:	c1 f8 0c             	sar    $0xc,%eax
  800ae6:	39 c2                	cmp    %eax,%edx
  800ae8:	74 17                	je     800b01 <_main+0xac9>
  800aea:	83 ec 04             	sub    $0x4,%esp
  800aed:	68 da 3d 80 00       	push   $0x803dda
  800af2:	68 cd 00 00 00       	push   $0xcd
  800af7:	68 bc 3c 80 00       	push   $0x803cbc
  800afc:	e8 27 02 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800b01:	e8 30 18 00 00       	call   802336 <sys_calculate_free_frames>
  800b06:	89 c2                	mov    %eax,%edx
  800b08:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800b0b:	39 c2                	cmp    %eax,%edx
  800b0d:	74 17                	je     800b26 <_main+0xaee>
  800b0f:	83 ec 04             	sub    $0x4,%esp
  800b12:	68 f7 3d 80 00       	push   $0x803df7
  800b17:	68 ce 00 00 00       	push   $0xce
  800b1c:	68 bc 3c 80 00       	push   $0x803cbc
  800b21:	e8 02 02 00 00       	call   800d28 <_panic>

	cprintf("\nCASE2: (next fit WITH looping back) is succeeded...\n") ;
  800b26:	83 ec 0c             	sub    $0xc,%esp
  800b29:	68 e0 3e 80 00       	push   $0x803ee0
  800b2e:	e8 a9 04 00 00       	call   800fdc <cprintf>
  800b33:	83 c4 10             	add    $0x10,%esp

	// Check that next fit returns null in case all holes are not free
	freeFrames = sys_calculate_free_frames() ;
  800b36:	e8 fb 17 00 00       	call   802336 <sys_calculate_free_frames>
  800b3b:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800b3e:	e8 93 18 00 00       	call   8023d6 <sys_pf_calculate_allocated_pages>
  800b43:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(6*Mega); 			   // No Suitable Hole is available
  800b46:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800b49:	89 d0                	mov    %edx,%eax
  800b4b:	01 c0                	add    %eax,%eax
  800b4d:	01 d0                	add    %edx,%eax
  800b4f:	01 c0                	add    %eax,%eax
  800b51:	83 ec 0c             	sub    $0xc,%esp
  800b54:	50                   	push   %eax
  800b55:	e8 ae 13 00 00       	call   801f08 <malloc>
  800b5a:	83 c4 10             	add    $0x10,%esp
  800b5d:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x0)
  800b60:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800b63:	85 c0                	test   %eax,%eax
  800b65:	74 17                	je     800b7e <_main+0xb46>
		panic("Next Fit not working correctly");
  800b67:	83 ec 04             	sub    $0x4,%esp
  800b6a:	68 84 3e 80 00       	push   $0x803e84
  800b6f:	68 d7 00 00 00       	push   $0xd7
  800b74:	68 bc 3c 80 00       	push   $0x803cbc
  800b79:	e8 aa 01 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800b7e:	e8 53 18 00 00       	call   8023d6 <sys_pf_calculate_allocated_pages>
  800b83:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800b86:	74 17                	je     800b9f <_main+0xb67>
  800b88:	83 ec 04             	sub    $0x4,%esp
  800b8b:	68 da 3d 80 00       	push   $0x803dda
  800b90:	68 d8 00 00 00       	push   $0xd8
  800b95:	68 bc 3c 80 00       	push   $0x803cbc
  800b9a:	e8 89 01 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800b9f:	e8 92 17 00 00       	call   802336 <sys_calculate_free_frames>
  800ba4:	89 c2                	mov    %eax,%edx
  800ba6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800ba9:	39 c2                	cmp    %eax,%edx
  800bab:	74 17                	je     800bc4 <_main+0xb8c>
  800bad:	83 ec 04             	sub    $0x4,%esp
  800bb0:	68 f7 3d 80 00       	push   $0x803df7
  800bb5:	68 d9 00 00 00       	push   $0xd9
  800bba:	68 bc 3c 80 00       	push   $0x803cbc
  800bbf:	e8 64 01 00 00       	call   800d28 <_panic>

	cprintf("\nCASE3: (next fit with insufficient space) is succeeded...\n") ;
  800bc4:	83 ec 0c             	sub    $0xc,%esp
  800bc7:	68 18 3f 80 00       	push   $0x803f18
  800bcc:	e8 0b 04 00 00       	call   800fdc <cprintf>
  800bd1:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! test Next Fit completed successfully.\n");
  800bd4:	83 ec 0c             	sub    $0xc,%esp
  800bd7:	68 54 3f 80 00       	push   $0x803f54
  800bdc:	e8 fb 03 00 00       	call   800fdc <cprintf>
  800be1:	83 c4 10             	add    $0x10,%esp

	return;
  800be4:	90                   	nop
}
  800be5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800be8:	5b                   	pop    %ebx
  800be9:	5f                   	pop    %edi
  800bea:	5d                   	pop    %ebp
  800beb:	c3                   	ret    

00800bec <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800bec:	55                   	push   %ebp
  800bed:	89 e5                	mov    %esp,%ebp
  800bef:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800bf2:	e8 1f 1a 00 00       	call   802616 <sys_getenvindex>
  800bf7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800bfa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bfd:	89 d0                	mov    %edx,%eax
  800bff:	c1 e0 03             	shl    $0x3,%eax
  800c02:	01 d0                	add    %edx,%eax
  800c04:	01 c0                	add    %eax,%eax
  800c06:	01 d0                	add    %edx,%eax
  800c08:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800c0f:	01 d0                	add    %edx,%eax
  800c11:	c1 e0 04             	shl    $0x4,%eax
  800c14:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800c19:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800c1e:	a1 20 50 80 00       	mov    0x805020,%eax
  800c23:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800c29:	84 c0                	test   %al,%al
  800c2b:	74 0f                	je     800c3c <libmain+0x50>
		binaryname = myEnv->prog_name;
  800c2d:	a1 20 50 80 00       	mov    0x805020,%eax
  800c32:	05 5c 05 00 00       	add    $0x55c,%eax
  800c37:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800c3c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c40:	7e 0a                	jle    800c4c <libmain+0x60>
		binaryname = argv[0];
  800c42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c45:	8b 00                	mov    (%eax),%eax
  800c47:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800c4c:	83 ec 08             	sub    $0x8,%esp
  800c4f:	ff 75 0c             	pushl  0xc(%ebp)
  800c52:	ff 75 08             	pushl  0x8(%ebp)
  800c55:	e8 de f3 ff ff       	call   800038 <_main>
  800c5a:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800c5d:	e8 c1 17 00 00       	call   802423 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800c62:	83 ec 0c             	sub    $0xc,%esp
  800c65:	68 a8 3f 80 00       	push   $0x803fa8
  800c6a:	e8 6d 03 00 00       	call   800fdc <cprintf>
  800c6f:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800c72:	a1 20 50 80 00       	mov    0x805020,%eax
  800c77:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800c7d:	a1 20 50 80 00       	mov    0x805020,%eax
  800c82:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800c88:	83 ec 04             	sub    $0x4,%esp
  800c8b:	52                   	push   %edx
  800c8c:	50                   	push   %eax
  800c8d:	68 d0 3f 80 00       	push   $0x803fd0
  800c92:	e8 45 03 00 00       	call   800fdc <cprintf>
  800c97:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800c9a:	a1 20 50 80 00       	mov    0x805020,%eax
  800c9f:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800ca5:	a1 20 50 80 00       	mov    0x805020,%eax
  800caa:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800cb0:	a1 20 50 80 00       	mov    0x805020,%eax
  800cb5:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800cbb:	51                   	push   %ecx
  800cbc:	52                   	push   %edx
  800cbd:	50                   	push   %eax
  800cbe:	68 f8 3f 80 00       	push   $0x803ff8
  800cc3:	e8 14 03 00 00       	call   800fdc <cprintf>
  800cc8:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800ccb:	a1 20 50 80 00       	mov    0x805020,%eax
  800cd0:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800cd6:	83 ec 08             	sub    $0x8,%esp
  800cd9:	50                   	push   %eax
  800cda:	68 50 40 80 00       	push   $0x804050
  800cdf:	e8 f8 02 00 00       	call   800fdc <cprintf>
  800ce4:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800ce7:	83 ec 0c             	sub    $0xc,%esp
  800cea:	68 a8 3f 80 00       	push   $0x803fa8
  800cef:	e8 e8 02 00 00       	call   800fdc <cprintf>
  800cf4:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800cf7:	e8 41 17 00 00       	call   80243d <sys_enable_interrupt>

	// exit gracefully
	exit();
  800cfc:	e8 19 00 00 00       	call   800d1a <exit>
}
  800d01:	90                   	nop
  800d02:	c9                   	leave  
  800d03:	c3                   	ret    

00800d04 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800d04:	55                   	push   %ebp
  800d05:	89 e5                	mov    %esp,%ebp
  800d07:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800d0a:	83 ec 0c             	sub    $0xc,%esp
  800d0d:	6a 00                	push   $0x0
  800d0f:	e8 ce 18 00 00       	call   8025e2 <sys_destroy_env>
  800d14:	83 c4 10             	add    $0x10,%esp
}
  800d17:	90                   	nop
  800d18:	c9                   	leave  
  800d19:	c3                   	ret    

00800d1a <exit>:

void
exit(void)
{
  800d1a:	55                   	push   %ebp
  800d1b:	89 e5                	mov    %esp,%ebp
  800d1d:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800d20:	e8 23 19 00 00       	call   802648 <sys_exit_env>
}
  800d25:	90                   	nop
  800d26:	c9                   	leave  
  800d27:	c3                   	ret    

00800d28 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800d28:	55                   	push   %ebp
  800d29:	89 e5                	mov    %esp,%ebp
  800d2b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800d2e:	8d 45 10             	lea    0x10(%ebp),%eax
  800d31:	83 c0 04             	add    $0x4,%eax
  800d34:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800d37:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800d3c:	85 c0                	test   %eax,%eax
  800d3e:	74 16                	je     800d56 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800d40:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800d45:	83 ec 08             	sub    $0x8,%esp
  800d48:	50                   	push   %eax
  800d49:	68 64 40 80 00       	push   $0x804064
  800d4e:	e8 89 02 00 00       	call   800fdc <cprintf>
  800d53:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800d56:	a1 00 50 80 00       	mov    0x805000,%eax
  800d5b:	ff 75 0c             	pushl  0xc(%ebp)
  800d5e:	ff 75 08             	pushl  0x8(%ebp)
  800d61:	50                   	push   %eax
  800d62:	68 69 40 80 00       	push   $0x804069
  800d67:	e8 70 02 00 00       	call   800fdc <cprintf>
  800d6c:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800d6f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d72:	83 ec 08             	sub    $0x8,%esp
  800d75:	ff 75 f4             	pushl  -0xc(%ebp)
  800d78:	50                   	push   %eax
  800d79:	e8 f3 01 00 00       	call   800f71 <vcprintf>
  800d7e:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800d81:	83 ec 08             	sub    $0x8,%esp
  800d84:	6a 00                	push   $0x0
  800d86:	68 85 40 80 00       	push   $0x804085
  800d8b:	e8 e1 01 00 00       	call   800f71 <vcprintf>
  800d90:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800d93:	e8 82 ff ff ff       	call   800d1a <exit>

	// should not return here
	while (1) ;
  800d98:	eb fe                	jmp    800d98 <_panic+0x70>

00800d9a <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800d9a:	55                   	push   %ebp
  800d9b:	89 e5                	mov    %esp,%ebp
  800d9d:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800da0:	a1 20 50 80 00       	mov    0x805020,%eax
  800da5:	8b 50 74             	mov    0x74(%eax),%edx
  800da8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dab:	39 c2                	cmp    %eax,%edx
  800dad:	74 14                	je     800dc3 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800daf:	83 ec 04             	sub    $0x4,%esp
  800db2:	68 88 40 80 00       	push   $0x804088
  800db7:	6a 26                	push   $0x26
  800db9:	68 d4 40 80 00       	push   $0x8040d4
  800dbe:	e8 65 ff ff ff       	call   800d28 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800dc3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800dca:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800dd1:	e9 c2 00 00 00       	jmp    800e98 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800dd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dd9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800de0:	8b 45 08             	mov    0x8(%ebp),%eax
  800de3:	01 d0                	add    %edx,%eax
  800de5:	8b 00                	mov    (%eax),%eax
  800de7:	85 c0                	test   %eax,%eax
  800de9:	75 08                	jne    800df3 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800deb:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800dee:	e9 a2 00 00 00       	jmp    800e95 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800df3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800dfa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800e01:	eb 69                	jmp    800e6c <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800e03:	a1 20 50 80 00       	mov    0x805020,%eax
  800e08:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800e0e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800e11:	89 d0                	mov    %edx,%eax
  800e13:	01 c0                	add    %eax,%eax
  800e15:	01 d0                	add    %edx,%eax
  800e17:	c1 e0 03             	shl    $0x3,%eax
  800e1a:	01 c8                	add    %ecx,%eax
  800e1c:	8a 40 04             	mov    0x4(%eax),%al
  800e1f:	84 c0                	test   %al,%al
  800e21:	75 46                	jne    800e69 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800e23:	a1 20 50 80 00       	mov    0x805020,%eax
  800e28:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800e2e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800e31:	89 d0                	mov    %edx,%eax
  800e33:	01 c0                	add    %eax,%eax
  800e35:	01 d0                	add    %edx,%eax
  800e37:	c1 e0 03             	shl    $0x3,%eax
  800e3a:	01 c8                	add    %ecx,%eax
  800e3c:	8b 00                	mov    (%eax),%eax
  800e3e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800e41:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800e44:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e49:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800e4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e4e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800e55:	8b 45 08             	mov    0x8(%ebp),%eax
  800e58:	01 c8                	add    %ecx,%eax
  800e5a:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800e5c:	39 c2                	cmp    %eax,%edx
  800e5e:	75 09                	jne    800e69 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800e60:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800e67:	eb 12                	jmp    800e7b <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800e69:	ff 45 e8             	incl   -0x18(%ebp)
  800e6c:	a1 20 50 80 00       	mov    0x805020,%eax
  800e71:	8b 50 74             	mov    0x74(%eax),%edx
  800e74:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800e77:	39 c2                	cmp    %eax,%edx
  800e79:	77 88                	ja     800e03 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800e7b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800e7f:	75 14                	jne    800e95 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800e81:	83 ec 04             	sub    $0x4,%esp
  800e84:	68 e0 40 80 00       	push   $0x8040e0
  800e89:	6a 3a                	push   $0x3a
  800e8b:	68 d4 40 80 00       	push   $0x8040d4
  800e90:	e8 93 fe ff ff       	call   800d28 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800e95:	ff 45 f0             	incl   -0x10(%ebp)
  800e98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e9b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800e9e:	0f 8c 32 ff ff ff    	jl     800dd6 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800ea4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800eab:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800eb2:	eb 26                	jmp    800eda <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800eb4:	a1 20 50 80 00       	mov    0x805020,%eax
  800eb9:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800ebf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ec2:	89 d0                	mov    %edx,%eax
  800ec4:	01 c0                	add    %eax,%eax
  800ec6:	01 d0                	add    %edx,%eax
  800ec8:	c1 e0 03             	shl    $0x3,%eax
  800ecb:	01 c8                	add    %ecx,%eax
  800ecd:	8a 40 04             	mov    0x4(%eax),%al
  800ed0:	3c 01                	cmp    $0x1,%al
  800ed2:	75 03                	jne    800ed7 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800ed4:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800ed7:	ff 45 e0             	incl   -0x20(%ebp)
  800eda:	a1 20 50 80 00       	mov    0x805020,%eax
  800edf:	8b 50 74             	mov    0x74(%eax),%edx
  800ee2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ee5:	39 c2                	cmp    %eax,%edx
  800ee7:	77 cb                	ja     800eb4 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800ee9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800eec:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800eef:	74 14                	je     800f05 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800ef1:	83 ec 04             	sub    $0x4,%esp
  800ef4:	68 34 41 80 00       	push   $0x804134
  800ef9:	6a 44                	push   $0x44
  800efb:	68 d4 40 80 00       	push   $0x8040d4
  800f00:	e8 23 fe ff ff       	call   800d28 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800f05:	90                   	nop
  800f06:	c9                   	leave  
  800f07:	c3                   	ret    

00800f08 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800f08:	55                   	push   %ebp
  800f09:	89 e5                	mov    %esp,%ebp
  800f0b:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800f0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f11:	8b 00                	mov    (%eax),%eax
  800f13:	8d 48 01             	lea    0x1(%eax),%ecx
  800f16:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f19:	89 0a                	mov    %ecx,(%edx)
  800f1b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1e:	88 d1                	mov    %dl,%cl
  800f20:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f23:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800f27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2a:	8b 00                	mov    (%eax),%eax
  800f2c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800f31:	75 2c                	jne    800f5f <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800f33:	a0 24 50 80 00       	mov    0x805024,%al
  800f38:	0f b6 c0             	movzbl %al,%eax
  800f3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f3e:	8b 12                	mov    (%edx),%edx
  800f40:	89 d1                	mov    %edx,%ecx
  800f42:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f45:	83 c2 08             	add    $0x8,%edx
  800f48:	83 ec 04             	sub    $0x4,%esp
  800f4b:	50                   	push   %eax
  800f4c:	51                   	push   %ecx
  800f4d:	52                   	push   %edx
  800f4e:	e8 22 13 00 00       	call   802275 <sys_cputs>
  800f53:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800f56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f59:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800f5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f62:	8b 40 04             	mov    0x4(%eax),%eax
  800f65:	8d 50 01             	lea    0x1(%eax),%edx
  800f68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6b:	89 50 04             	mov    %edx,0x4(%eax)
}
  800f6e:	90                   	nop
  800f6f:	c9                   	leave  
  800f70:	c3                   	ret    

00800f71 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800f71:	55                   	push   %ebp
  800f72:	89 e5                	mov    %esp,%ebp
  800f74:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800f7a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800f81:	00 00 00 
	b.cnt = 0;
  800f84:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800f8b:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800f8e:	ff 75 0c             	pushl  0xc(%ebp)
  800f91:	ff 75 08             	pushl  0x8(%ebp)
  800f94:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800f9a:	50                   	push   %eax
  800f9b:	68 08 0f 80 00       	push   $0x800f08
  800fa0:	e8 11 02 00 00       	call   8011b6 <vprintfmt>
  800fa5:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800fa8:	a0 24 50 80 00       	mov    0x805024,%al
  800fad:	0f b6 c0             	movzbl %al,%eax
  800fb0:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800fb6:	83 ec 04             	sub    $0x4,%esp
  800fb9:	50                   	push   %eax
  800fba:	52                   	push   %edx
  800fbb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800fc1:	83 c0 08             	add    $0x8,%eax
  800fc4:	50                   	push   %eax
  800fc5:	e8 ab 12 00 00       	call   802275 <sys_cputs>
  800fca:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800fcd:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800fd4:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800fda:	c9                   	leave  
  800fdb:	c3                   	ret    

00800fdc <cprintf>:

int cprintf(const char *fmt, ...) {
  800fdc:	55                   	push   %ebp
  800fdd:	89 e5                	mov    %esp,%ebp
  800fdf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800fe2:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800fe9:	8d 45 0c             	lea    0xc(%ebp),%eax
  800fec:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800fef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff2:	83 ec 08             	sub    $0x8,%esp
  800ff5:	ff 75 f4             	pushl  -0xc(%ebp)
  800ff8:	50                   	push   %eax
  800ff9:	e8 73 ff ff ff       	call   800f71 <vcprintf>
  800ffe:	83 c4 10             	add    $0x10,%esp
  801001:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801004:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801007:	c9                   	leave  
  801008:	c3                   	ret    

00801009 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  801009:	55                   	push   %ebp
  80100a:	89 e5                	mov    %esp,%ebp
  80100c:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80100f:	e8 0f 14 00 00       	call   802423 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801014:	8d 45 0c             	lea    0xc(%ebp),%eax
  801017:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80101a:	8b 45 08             	mov    0x8(%ebp),%eax
  80101d:	83 ec 08             	sub    $0x8,%esp
  801020:	ff 75 f4             	pushl  -0xc(%ebp)
  801023:	50                   	push   %eax
  801024:	e8 48 ff ff ff       	call   800f71 <vcprintf>
  801029:	83 c4 10             	add    $0x10,%esp
  80102c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80102f:	e8 09 14 00 00       	call   80243d <sys_enable_interrupt>
	return cnt;
  801034:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801037:	c9                   	leave  
  801038:	c3                   	ret    

00801039 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801039:	55                   	push   %ebp
  80103a:	89 e5                	mov    %esp,%ebp
  80103c:	53                   	push   %ebx
  80103d:	83 ec 14             	sub    $0x14,%esp
  801040:	8b 45 10             	mov    0x10(%ebp),%eax
  801043:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801046:	8b 45 14             	mov    0x14(%ebp),%eax
  801049:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80104c:	8b 45 18             	mov    0x18(%ebp),%eax
  80104f:	ba 00 00 00 00       	mov    $0x0,%edx
  801054:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801057:	77 55                	ja     8010ae <printnum+0x75>
  801059:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80105c:	72 05                	jb     801063 <printnum+0x2a>
  80105e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801061:	77 4b                	ja     8010ae <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801063:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801066:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801069:	8b 45 18             	mov    0x18(%ebp),%eax
  80106c:	ba 00 00 00 00       	mov    $0x0,%edx
  801071:	52                   	push   %edx
  801072:	50                   	push   %eax
  801073:	ff 75 f4             	pushl  -0xc(%ebp)
  801076:	ff 75 f0             	pushl  -0x10(%ebp)
  801079:	e8 b2 29 00 00       	call   803a30 <__udivdi3>
  80107e:	83 c4 10             	add    $0x10,%esp
  801081:	83 ec 04             	sub    $0x4,%esp
  801084:	ff 75 20             	pushl  0x20(%ebp)
  801087:	53                   	push   %ebx
  801088:	ff 75 18             	pushl  0x18(%ebp)
  80108b:	52                   	push   %edx
  80108c:	50                   	push   %eax
  80108d:	ff 75 0c             	pushl  0xc(%ebp)
  801090:	ff 75 08             	pushl  0x8(%ebp)
  801093:	e8 a1 ff ff ff       	call   801039 <printnum>
  801098:	83 c4 20             	add    $0x20,%esp
  80109b:	eb 1a                	jmp    8010b7 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80109d:	83 ec 08             	sub    $0x8,%esp
  8010a0:	ff 75 0c             	pushl  0xc(%ebp)
  8010a3:	ff 75 20             	pushl  0x20(%ebp)
  8010a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a9:	ff d0                	call   *%eax
  8010ab:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8010ae:	ff 4d 1c             	decl   0x1c(%ebp)
  8010b1:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8010b5:	7f e6                	jg     80109d <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8010b7:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8010ba:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010c5:	53                   	push   %ebx
  8010c6:	51                   	push   %ecx
  8010c7:	52                   	push   %edx
  8010c8:	50                   	push   %eax
  8010c9:	e8 72 2a 00 00       	call   803b40 <__umoddi3>
  8010ce:	83 c4 10             	add    $0x10,%esp
  8010d1:	05 94 43 80 00       	add    $0x804394,%eax
  8010d6:	8a 00                	mov    (%eax),%al
  8010d8:	0f be c0             	movsbl %al,%eax
  8010db:	83 ec 08             	sub    $0x8,%esp
  8010de:	ff 75 0c             	pushl  0xc(%ebp)
  8010e1:	50                   	push   %eax
  8010e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e5:	ff d0                	call   *%eax
  8010e7:	83 c4 10             	add    $0x10,%esp
}
  8010ea:	90                   	nop
  8010eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010ee:	c9                   	leave  
  8010ef:	c3                   	ret    

008010f0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8010f0:	55                   	push   %ebp
  8010f1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8010f3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8010f7:	7e 1c                	jle    801115 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8010f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fc:	8b 00                	mov    (%eax),%eax
  8010fe:	8d 50 08             	lea    0x8(%eax),%edx
  801101:	8b 45 08             	mov    0x8(%ebp),%eax
  801104:	89 10                	mov    %edx,(%eax)
  801106:	8b 45 08             	mov    0x8(%ebp),%eax
  801109:	8b 00                	mov    (%eax),%eax
  80110b:	83 e8 08             	sub    $0x8,%eax
  80110e:	8b 50 04             	mov    0x4(%eax),%edx
  801111:	8b 00                	mov    (%eax),%eax
  801113:	eb 40                	jmp    801155 <getuint+0x65>
	else if (lflag)
  801115:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801119:	74 1e                	je     801139 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80111b:	8b 45 08             	mov    0x8(%ebp),%eax
  80111e:	8b 00                	mov    (%eax),%eax
  801120:	8d 50 04             	lea    0x4(%eax),%edx
  801123:	8b 45 08             	mov    0x8(%ebp),%eax
  801126:	89 10                	mov    %edx,(%eax)
  801128:	8b 45 08             	mov    0x8(%ebp),%eax
  80112b:	8b 00                	mov    (%eax),%eax
  80112d:	83 e8 04             	sub    $0x4,%eax
  801130:	8b 00                	mov    (%eax),%eax
  801132:	ba 00 00 00 00       	mov    $0x0,%edx
  801137:	eb 1c                	jmp    801155 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801139:	8b 45 08             	mov    0x8(%ebp),%eax
  80113c:	8b 00                	mov    (%eax),%eax
  80113e:	8d 50 04             	lea    0x4(%eax),%edx
  801141:	8b 45 08             	mov    0x8(%ebp),%eax
  801144:	89 10                	mov    %edx,(%eax)
  801146:	8b 45 08             	mov    0x8(%ebp),%eax
  801149:	8b 00                	mov    (%eax),%eax
  80114b:	83 e8 04             	sub    $0x4,%eax
  80114e:	8b 00                	mov    (%eax),%eax
  801150:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801155:	5d                   	pop    %ebp
  801156:	c3                   	ret    

00801157 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801157:	55                   	push   %ebp
  801158:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80115a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80115e:	7e 1c                	jle    80117c <getint+0x25>
		return va_arg(*ap, long long);
  801160:	8b 45 08             	mov    0x8(%ebp),%eax
  801163:	8b 00                	mov    (%eax),%eax
  801165:	8d 50 08             	lea    0x8(%eax),%edx
  801168:	8b 45 08             	mov    0x8(%ebp),%eax
  80116b:	89 10                	mov    %edx,(%eax)
  80116d:	8b 45 08             	mov    0x8(%ebp),%eax
  801170:	8b 00                	mov    (%eax),%eax
  801172:	83 e8 08             	sub    $0x8,%eax
  801175:	8b 50 04             	mov    0x4(%eax),%edx
  801178:	8b 00                	mov    (%eax),%eax
  80117a:	eb 38                	jmp    8011b4 <getint+0x5d>
	else if (lflag)
  80117c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801180:	74 1a                	je     80119c <getint+0x45>
		return va_arg(*ap, long);
  801182:	8b 45 08             	mov    0x8(%ebp),%eax
  801185:	8b 00                	mov    (%eax),%eax
  801187:	8d 50 04             	lea    0x4(%eax),%edx
  80118a:	8b 45 08             	mov    0x8(%ebp),%eax
  80118d:	89 10                	mov    %edx,(%eax)
  80118f:	8b 45 08             	mov    0x8(%ebp),%eax
  801192:	8b 00                	mov    (%eax),%eax
  801194:	83 e8 04             	sub    $0x4,%eax
  801197:	8b 00                	mov    (%eax),%eax
  801199:	99                   	cltd   
  80119a:	eb 18                	jmp    8011b4 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80119c:	8b 45 08             	mov    0x8(%ebp),%eax
  80119f:	8b 00                	mov    (%eax),%eax
  8011a1:	8d 50 04             	lea    0x4(%eax),%edx
  8011a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a7:	89 10                	mov    %edx,(%eax)
  8011a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ac:	8b 00                	mov    (%eax),%eax
  8011ae:	83 e8 04             	sub    $0x4,%eax
  8011b1:	8b 00                	mov    (%eax),%eax
  8011b3:	99                   	cltd   
}
  8011b4:	5d                   	pop    %ebp
  8011b5:	c3                   	ret    

008011b6 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8011b6:	55                   	push   %ebp
  8011b7:	89 e5                	mov    %esp,%ebp
  8011b9:	56                   	push   %esi
  8011ba:	53                   	push   %ebx
  8011bb:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8011be:	eb 17                	jmp    8011d7 <vprintfmt+0x21>
			if (ch == '\0')
  8011c0:	85 db                	test   %ebx,%ebx
  8011c2:	0f 84 af 03 00 00    	je     801577 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8011c8:	83 ec 08             	sub    $0x8,%esp
  8011cb:	ff 75 0c             	pushl  0xc(%ebp)
  8011ce:	53                   	push   %ebx
  8011cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d2:	ff d0                	call   *%eax
  8011d4:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8011d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8011da:	8d 50 01             	lea    0x1(%eax),%edx
  8011dd:	89 55 10             	mov    %edx,0x10(%ebp)
  8011e0:	8a 00                	mov    (%eax),%al
  8011e2:	0f b6 d8             	movzbl %al,%ebx
  8011e5:	83 fb 25             	cmp    $0x25,%ebx
  8011e8:	75 d6                	jne    8011c0 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8011ea:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8011ee:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8011f5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8011fc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801203:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80120a:	8b 45 10             	mov    0x10(%ebp),%eax
  80120d:	8d 50 01             	lea    0x1(%eax),%edx
  801210:	89 55 10             	mov    %edx,0x10(%ebp)
  801213:	8a 00                	mov    (%eax),%al
  801215:	0f b6 d8             	movzbl %al,%ebx
  801218:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80121b:	83 f8 55             	cmp    $0x55,%eax
  80121e:	0f 87 2b 03 00 00    	ja     80154f <vprintfmt+0x399>
  801224:	8b 04 85 b8 43 80 00 	mov    0x8043b8(,%eax,4),%eax
  80122b:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80122d:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801231:	eb d7                	jmp    80120a <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801233:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801237:	eb d1                	jmp    80120a <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801239:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801240:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801243:	89 d0                	mov    %edx,%eax
  801245:	c1 e0 02             	shl    $0x2,%eax
  801248:	01 d0                	add    %edx,%eax
  80124a:	01 c0                	add    %eax,%eax
  80124c:	01 d8                	add    %ebx,%eax
  80124e:	83 e8 30             	sub    $0x30,%eax
  801251:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801254:	8b 45 10             	mov    0x10(%ebp),%eax
  801257:	8a 00                	mov    (%eax),%al
  801259:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80125c:	83 fb 2f             	cmp    $0x2f,%ebx
  80125f:	7e 3e                	jle    80129f <vprintfmt+0xe9>
  801261:	83 fb 39             	cmp    $0x39,%ebx
  801264:	7f 39                	jg     80129f <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801266:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801269:	eb d5                	jmp    801240 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80126b:	8b 45 14             	mov    0x14(%ebp),%eax
  80126e:	83 c0 04             	add    $0x4,%eax
  801271:	89 45 14             	mov    %eax,0x14(%ebp)
  801274:	8b 45 14             	mov    0x14(%ebp),%eax
  801277:	83 e8 04             	sub    $0x4,%eax
  80127a:	8b 00                	mov    (%eax),%eax
  80127c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80127f:	eb 1f                	jmp    8012a0 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801281:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801285:	79 83                	jns    80120a <vprintfmt+0x54>
				width = 0;
  801287:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80128e:	e9 77 ff ff ff       	jmp    80120a <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801293:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80129a:	e9 6b ff ff ff       	jmp    80120a <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80129f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8012a0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8012a4:	0f 89 60 ff ff ff    	jns    80120a <vprintfmt+0x54>
				width = precision, precision = -1;
  8012aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8012b0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8012b7:	e9 4e ff ff ff       	jmp    80120a <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8012bc:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8012bf:	e9 46 ff ff ff       	jmp    80120a <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8012c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8012c7:	83 c0 04             	add    $0x4,%eax
  8012ca:	89 45 14             	mov    %eax,0x14(%ebp)
  8012cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8012d0:	83 e8 04             	sub    $0x4,%eax
  8012d3:	8b 00                	mov    (%eax),%eax
  8012d5:	83 ec 08             	sub    $0x8,%esp
  8012d8:	ff 75 0c             	pushl  0xc(%ebp)
  8012db:	50                   	push   %eax
  8012dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012df:	ff d0                	call   *%eax
  8012e1:	83 c4 10             	add    $0x10,%esp
			break;
  8012e4:	e9 89 02 00 00       	jmp    801572 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8012e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ec:	83 c0 04             	add    $0x4,%eax
  8012ef:	89 45 14             	mov    %eax,0x14(%ebp)
  8012f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8012f5:	83 e8 04             	sub    $0x4,%eax
  8012f8:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8012fa:	85 db                	test   %ebx,%ebx
  8012fc:	79 02                	jns    801300 <vprintfmt+0x14a>
				err = -err;
  8012fe:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801300:	83 fb 64             	cmp    $0x64,%ebx
  801303:	7f 0b                	jg     801310 <vprintfmt+0x15a>
  801305:	8b 34 9d 00 42 80 00 	mov    0x804200(,%ebx,4),%esi
  80130c:	85 f6                	test   %esi,%esi
  80130e:	75 19                	jne    801329 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801310:	53                   	push   %ebx
  801311:	68 a5 43 80 00       	push   $0x8043a5
  801316:	ff 75 0c             	pushl  0xc(%ebp)
  801319:	ff 75 08             	pushl  0x8(%ebp)
  80131c:	e8 5e 02 00 00       	call   80157f <printfmt>
  801321:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801324:	e9 49 02 00 00       	jmp    801572 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801329:	56                   	push   %esi
  80132a:	68 ae 43 80 00       	push   $0x8043ae
  80132f:	ff 75 0c             	pushl  0xc(%ebp)
  801332:	ff 75 08             	pushl  0x8(%ebp)
  801335:	e8 45 02 00 00       	call   80157f <printfmt>
  80133a:	83 c4 10             	add    $0x10,%esp
			break;
  80133d:	e9 30 02 00 00       	jmp    801572 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801342:	8b 45 14             	mov    0x14(%ebp),%eax
  801345:	83 c0 04             	add    $0x4,%eax
  801348:	89 45 14             	mov    %eax,0x14(%ebp)
  80134b:	8b 45 14             	mov    0x14(%ebp),%eax
  80134e:	83 e8 04             	sub    $0x4,%eax
  801351:	8b 30                	mov    (%eax),%esi
  801353:	85 f6                	test   %esi,%esi
  801355:	75 05                	jne    80135c <vprintfmt+0x1a6>
				p = "(null)";
  801357:	be b1 43 80 00       	mov    $0x8043b1,%esi
			if (width > 0 && padc != '-')
  80135c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801360:	7e 6d                	jle    8013cf <vprintfmt+0x219>
  801362:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801366:	74 67                	je     8013cf <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801368:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80136b:	83 ec 08             	sub    $0x8,%esp
  80136e:	50                   	push   %eax
  80136f:	56                   	push   %esi
  801370:	e8 0c 03 00 00       	call   801681 <strnlen>
  801375:	83 c4 10             	add    $0x10,%esp
  801378:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80137b:	eb 16                	jmp    801393 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80137d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801381:	83 ec 08             	sub    $0x8,%esp
  801384:	ff 75 0c             	pushl  0xc(%ebp)
  801387:	50                   	push   %eax
  801388:	8b 45 08             	mov    0x8(%ebp),%eax
  80138b:	ff d0                	call   *%eax
  80138d:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801390:	ff 4d e4             	decl   -0x1c(%ebp)
  801393:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801397:	7f e4                	jg     80137d <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801399:	eb 34                	jmp    8013cf <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80139b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80139f:	74 1c                	je     8013bd <vprintfmt+0x207>
  8013a1:	83 fb 1f             	cmp    $0x1f,%ebx
  8013a4:	7e 05                	jle    8013ab <vprintfmt+0x1f5>
  8013a6:	83 fb 7e             	cmp    $0x7e,%ebx
  8013a9:	7e 12                	jle    8013bd <vprintfmt+0x207>
					putch('?', putdat);
  8013ab:	83 ec 08             	sub    $0x8,%esp
  8013ae:	ff 75 0c             	pushl  0xc(%ebp)
  8013b1:	6a 3f                	push   $0x3f
  8013b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b6:	ff d0                	call   *%eax
  8013b8:	83 c4 10             	add    $0x10,%esp
  8013bb:	eb 0f                	jmp    8013cc <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8013bd:	83 ec 08             	sub    $0x8,%esp
  8013c0:	ff 75 0c             	pushl  0xc(%ebp)
  8013c3:	53                   	push   %ebx
  8013c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c7:	ff d0                	call   *%eax
  8013c9:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8013cc:	ff 4d e4             	decl   -0x1c(%ebp)
  8013cf:	89 f0                	mov    %esi,%eax
  8013d1:	8d 70 01             	lea    0x1(%eax),%esi
  8013d4:	8a 00                	mov    (%eax),%al
  8013d6:	0f be d8             	movsbl %al,%ebx
  8013d9:	85 db                	test   %ebx,%ebx
  8013db:	74 24                	je     801401 <vprintfmt+0x24b>
  8013dd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8013e1:	78 b8                	js     80139b <vprintfmt+0x1e5>
  8013e3:	ff 4d e0             	decl   -0x20(%ebp)
  8013e6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8013ea:	79 af                	jns    80139b <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8013ec:	eb 13                	jmp    801401 <vprintfmt+0x24b>
				putch(' ', putdat);
  8013ee:	83 ec 08             	sub    $0x8,%esp
  8013f1:	ff 75 0c             	pushl  0xc(%ebp)
  8013f4:	6a 20                	push   $0x20
  8013f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f9:	ff d0                	call   *%eax
  8013fb:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8013fe:	ff 4d e4             	decl   -0x1c(%ebp)
  801401:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801405:	7f e7                	jg     8013ee <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801407:	e9 66 01 00 00       	jmp    801572 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80140c:	83 ec 08             	sub    $0x8,%esp
  80140f:	ff 75 e8             	pushl  -0x18(%ebp)
  801412:	8d 45 14             	lea    0x14(%ebp),%eax
  801415:	50                   	push   %eax
  801416:	e8 3c fd ff ff       	call   801157 <getint>
  80141b:	83 c4 10             	add    $0x10,%esp
  80141e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801421:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801424:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801427:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80142a:	85 d2                	test   %edx,%edx
  80142c:	79 23                	jns    801451 <vprintfmt+0x29b>
				putch('-', putdat);
  80142e:	83 ec 08             	sub    $0x8,%esp
  801431:	ff 75 0c             	pushl  0xc(%ebp)
  801434:	6a 2d                	push   $0x2d
  801436:	8b 45 08             	mov    0x8(%ebp),%eax
  801439:	ff d0                	call   *%eax
  80143b:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80143e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801441:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801444:	f7 d8                	neg    %eax
  801446:	83 d2 00             	adc    $0x0,%edx
  801449:	f7 da                	neg    %edx
  80144b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80144e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801451:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801458:	e9 bc 00 00 00       	jmp    801519 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80145d:	83 ec 08             	sub    $0x8,%esp
  801460:	ff 75 e8             	pushl  -0x18(%ebp)
  801463:	8d 45 14             	lea    0x14(%ebp),%eax
  801466:	50                   	push   %eax
  801467:	e8 84 fc ff ff       	call   8010f0 <getuint>
  80146c:	83 c4 10             	add    $0x10,%esp
  80146f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801472:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801475:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80147c:	e9 98 00 00 00       	jmp    801519 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801481:	83 ec 08             	sub    $0x8,%esp
  801484:	ff 75 0c             	pushl  0xc(%ebp)
  801487:	6a 58                	push   $0x58
  801489:	8b 45 08             	mov    0x8(%ebp),%eax
  80148c:	ff d0                	call   *%eax
  80148e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801491:	83 ec 08             	sub    $0x8,%esp
  801494:	ff 75 0c             	pushl  0xc(%ebp)
  801497:	6a 58                	push   $0x58
  801499:	8b 45 08             	mov    0x8(%ebp),%eax
  80149c:	ff d0                	call   *%eax
  80149e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8014a1:	83 ec 08             	sub    $0x8,%esp
  8014a4:	ff 75 0c             	pushl  0xc(%ebp)
  8014a7:	6a 58                	push   $0x58
  8014a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ac:	ff d0                	call   *%eax
  8014ae:	83 c4 10             	add    $0x10,%esp
			break;
  8014b1:	e9 bc 00 00 00       	jmp    801572 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8014b6:	83 ec 08             	sub    $0x8,%esp
  8014b9:	ff 75 0c             	pushl  0xc(%ebp)
  8014bc:	6a 30                	push   $0x30
  8014be:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c1:	ff d0                	call   *%eax
  8014c3:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8014c6:	83 ec 08             	sub    $0x8,%esp
  8014c9:	ff 75 0c             	pushl  0xc(%ebp)
  8014cc:	6a 78                	push   $0x78
  8014ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d1:	ff d0                	call   *%eax
  8014d3:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8014d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8014d9:	83 c0 04             	add    $0x4,%eax
  8014dc:	89 45 14             	mov    %eax,0x14(%ebp)
  8014df:	8b 45 14             	mov    0x14(%ebp),%eax
  8014e2:	83 e8 04             	sub    $0x4,%eax
  8014e5:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8014e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014ea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8014f1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8014f8:	eb 1f                	jmp    801519 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8014fa:	83 ec 08             	sub    $0x8,%esp
  8014fd:	ff 75 e8             	pushl  -0x18(%ebp)
  801500:	8d 45 14             	lea    0x14(%ebp),%eax
  801503:	50                   	push   %eax
  801504:	e8 e7 fb ff ff       	call   8010f0 <getuint>
  801509:	83 c4 10             	add    $0x10,%esp
  80150c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80150f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801512:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801519:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80151d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801520:	83 ec 04             	sub    $0x4,%esp
  801523:	52                   	push   %edx
  801524:	ff 75 e4             	pushl  -0x1c(%ebp)
  801527:	50                   	push   %eax
  801528:	ff 75 f4             	pushl  -0xc(%ebp)
  80152b:	ff 75 f0             	pushl  -0x10(%ebp)
  80152e:	ff 75 0c             	pushl  0xc(%ebp)
  801531:	ff 75 08             	pushl  0x8(%ebp)
  801534:	e8 00 fb ff ff       	call   801039 <printnum>
  801539:	83 c4 20             	add    $0x20,%esp
			break;
  80153c:	eb 34                	jmp    801572 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80153e:	83 ec 08             	sub    $0x8,%esp
  801541:	ff 75 0c             	pushl  0xc(%ebp)
  801544:	53                   	push   %ebx
  801545:	8b 45 08             	mov    0x8(%ebp),%eax
  801548:	ff d0                	call   *%eax
  80154a:	83 c4 10             	add    $0x10,%esp
			break;
  80154d:	eb 23                	jmp    801572 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80154f:	83 ec 08             	sub    $0x8,%esp
  801552:	ff 75 0c             	pushl  0xc(%ebp)
  801555:	6a 25                	push   $0x25
  801557:	8b 45 08             	mov    0x8(%ebp),%eax
  80155a:	ff d0                	call   *%eax
  80155c:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80155f:	ff 4d 10             	decl   0x10(%ebp)
  801562:	eb 03                	jmp    801567 <vprintfmt+0x3b1>
  801564:	ff 4d 10             	decl   0x10(%ebp)
  801567:	8b 45 10             	mov    0x10(%ebp),%eax
  80156a:	48                   	dec    %eax
  80156b:	8a 00                	mov    (%eax),%al
  80156d:	3c 25                	cmp    $0x25,%al
  80156f:	75 f3                	jne    801564 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801571:	90                   	nop
		}
	}
  801572:	e9 47 fc ff ff       	jmp    8011be <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801577:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801578:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80157b:	5b                   	pop    %ebx
  80157c:	5e                   	pop    %esi
  80157d:	5d                   	pop    %ebp
  80157e:	c3                   	ret    

0080157f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80157f:	55                   	push   %ebp
  801580:	89 e5                	mov    %esp,%ebp
  801582:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801585:	8d 45 10             	lea    0x10(%ebp),%eax
  801588:	83 c0 04             	add    $0x4,%eax
  80158b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80158e:	8b 45 10             	mov    0x10(%ebp),%eax
  801591:	ff 75 f4             	pushl  -0xc(%ebp)
  801594:	50                   	push   %eax
  801595:	ff 75 0c             	pushl  0xc(%ebp)
  801598:	ff 75 08             	pushl  0x8(%ebp)
  80159b:	e8 16 fc ff ff       	call   8011b6 <vprintfmt>
  8015a0:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8015a3:	90                   	nop
  8015a4:	c9                   	leave  
  8015a5:	c3                   	ret    

008015a6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8015a6:	55                   	push   %ebp
  8015a7:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8015a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ac:	8b 40 08             	mov    0x8(%eax),%eax
  8015af:	8d 50 01             	lea    0x1(%eax),%edx
  8015b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b5:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8015b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015bb:	8b 10                	mov    (%eax),%edx
  8015bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c0:	8b 40 04             	mov    0x4(%eax),%eax
  8015c3:	39 c2                	cmp    %eax,%edx
  8015c5:	73 12                	jae    8015d9 <sprintputch+0x33>
		*b->buf++ = ch;
  8015c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ca:	8b 00                	mov    (%eax),%eax
  8015cc:	8d 48 01             	lea    0x1(%eax),%ecx
  8015cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015d2:	89 0a                	mov    %ecx,(%edx)
  8015d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8015d7:	88 10                	mov    %dl,(%eax)
}
  8015d9:	90                   	nop
  8015da:	5d                   	pop    %ebp
  8015db:	c3                   	ret    

008015dc <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8015dc:	55                   	push   %ebp
  8015dd:	89 e5                	mov    %esp,%ebp
  8015df:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8015e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8015e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015eb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f1:	01 d0                	add    %edx,%eax
  8015f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8015fd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801601:	74 06                	je     801609 <vsnprintf+0x2d>
  801603:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801607:	7f 07                	jg     801610 <vsnprintf+0x34>
		return -E_INVAL;
  801609:	b8 03 00 00 00       	mov    $0x3,%eax
  80160e:	eb 20                	jmp    801630 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801610:	ff 75 14             	pushl  0x14(%ebp)
  801613:	ff 75 10             	pushl  0x10(%ebp)
  801616:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801619:	50                   	push   %eax
  80161a:	68 a6 15 80 00       	push   $0x8015a6
  80161f:	e8 92 fb ff ff       	call   8011b6 <vprintfmt>
  801624:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801627:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80162a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80162d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801630:	c9                   	leave  
  801631:	c3                   	ret    

00801632 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801632:	55                   	push   %ebp
  801633:	89 e5                	mov    %esp,%ebp
  801635:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801638:	8d 45 10             	lea    0x10(%ebp),%eax
  80163b:	83 c0 04             	add    $0x4,%eax
  80163e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801641:	8b 45 10             	mov    0x10(%ebp),%eax
  801644:	ff 75 f4             	pushl  -0xc(%ebp)
  801647:	50                   	push   %eax
  801648:	ff 75 0c             	pushl  0xc(%ebp)
  80164b:	ff 75 08             	pushl  0x8(%ebp)
  80164e:	e8 89 ff ff ff       	call   8015dc <vsnprintf>
  801653:	83 c4 10             	add    $0x10,%esp
  801656:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801659:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80165c:	c9                   	leave  
  80165d:	c3                   	ret    

0080165e <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80165e:	55                   	push   %ebp
  80165f:	89 e5                	mov    %esp,%ebp
  801661:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801664:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80166b:	eb 06                	jmp    801673 <strlen+0x15>
		n++;
  80166d:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801670:	ff 45 08             	incl   0x8(%ebp)
  801673:	8b 45 08             	mov    0x8(%ebp),%eax
  801676:	8a 00                	mov    (%eax),%al
  801678:	84 c0                	test   %al,%al
  80167a:	75 f1                	jne    80166d <strlen+0xf>
		n++;
	return n;
  80167c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80167f:	c9                   	leave  
  801680:	c3                   	ret    

00801681 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801681:	55                   	push   %ebp
  801682:	89 e5                	mov    %esp,%ebp
  801684:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801687:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80168e:	eb 09                	jmp    801699 <strnlen+0x18>
		n++;
  801690:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801693:	ff 45 08             	incl   0x8(%ebp)
  801696:	ff 4d 0c             	decl   0xc(%ebp)
  801699:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80169d:	74 09                	je     8016a8 <strnlen+0x27>
  80169f:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a2:	8a 00                	mov    (%eax),%al
  8016a4:	84 c0                	test   %al,%al
  8016a6:	75 e8                	jne    801690 <strnlen+0xf>
		n++;
	return n;
  8016a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8016ab:	c9                   	leave  
  8016ac:	c3                   	ret    

008016ad <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8016ad:	55                   	push   %ebp
  8016ae:	89 e5                	mov    %esp,%ebp
  8016b0:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8016b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8016b9:	90                   	nop
  8016ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bd:	8d 50 01             	lea    0x1(%eax),%edx
  8016c0:	89 55 08             	mov    %edx,0x8(%ebp)
  8016c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016c6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016c9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8016cc:	8a 12                	mov    (%edx),%dl
  8016ce:	88 10                	mov    %dl,(%eax)
  8016d0:	8a 00                	mov    (%eax),%al
  8016d2:	84 c0                	test   %al,%al
  8016d4:	75 e4                	jne    8016ba <strcpy+0xd>
		/* do nothing */;
	return ret;
  8016d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8016d9:	c9                   	leave  
  8016da:	c3                   	ret    

008016db <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8016db:	55                   	push   %ebp
  8016dc:	89 e5                	mov    %esp,%ebp
  8016de:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8016e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8016e7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8016ee:	eb 1f                	jmp    80170f <strncpy+0x34>
		*dst++ = *src;
  8016f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f3:	8d 50 01             	lea    0x1(%eax),%edx
  8016f6:	89 55 08             	mov    %edx,0x8(%ebp)
  8016f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016fc:	8a 12                	mov    (%edx),%dl
  8016fe:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801700:	8b 45 0c             	mov    0xc(%ebp),%eax
  801703:	8a 00                	mov    (%eax),%al
  801705:	84 c0                	test   %al,%al
  801707:	74 03                	je     80170c <strncpy+0x31>
			src++;
  801709:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80170c:	ff 45 fc             	incl   -0x4(%ebp)
  80170f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801712:	3b 45 10             	cmp    0x10(%ebp),%eax
  801715:	72 d9                	jb     8016f0 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801717:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80171a:	c9                   	leave  
  80171b:	c3                   	ret    

0080171c <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80171c:	55                   	push   %ebp
  80171d:	89 e5                	mov    %esp,%ebp
  80171f:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801722:	8b 45 08             	mov    0x8(%ebp),%eax
  801725:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801728:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80172c:	74 30                	je     80175e <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80172e:	eb 16                	jmp    801746 <strlcpy+0x2a>
			*dst++ = *src++;
  801730:	8b 45 08             	mov    0x8(%ebp),%eax
  801733:	8d 50 01             	lea    0x1(%eax),%edx
  801736:	89 55 08             	mov    %edx,0x8(%ebp)
  801739:	8b 55 0c             	mov    0xc(%ebp),%edx
  80173c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80173f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801742:	8a 12                	mov    (%edx),%dl
  801744:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801746:	ff 4d 10             	decl   0x10(%ebp)
  801749:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80174d:	74 09                	je     801758 <strlcpy+0x3c>
  80174f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801752:	8a 00                	mov    (%eax),%al
  801754:	84 c0                	test   %al,%al
  801756:	75 d8                	jne    801730 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801758:	8b 45 08             	mov    0x8(%ebp),%eax
  80175b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80175e:	8b 55 08             	mov    0x8(%ebp),%edx
  801761:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801764:	29 c2                	sub    %eax,%edx
  801766:	89 d0                	mov    %edx,%eax
}
  801768:	c9                   	leave  
  801769:	c3                   	ret    

0080176a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80176a:	55                   	push   %ebp
  80176b:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80176d:	eb 06                	jmp    801775 <strcmp+0xb>
		p++, q++;
  80176f:	ff 45 08             	incl   0x8(%ebp)
  801772:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801775:	8b 45 08             	mov    0x8(%ebp),%eax
  801778:	8a 00                	mov    (%eax),%al
  80177a:	84 c0                	test   %al,%al
  80177c:	74 0e                	je     80178c <strcmp+0x22>
  80177e:	8b 45 08             	mov    0x8(%ebp),%eax
  801781:	8a 10                	mov    (%eax),%dl
  801783:	8b 45 0c             	mov    0xc(%ebp),%eax
  801786:	8a 00                	mov    (%eax),%al
  801788:	38 c2                	cmp    %al,%dl
  80178a:	74 e3                	je     80176f <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80178c:	8b 45 08             	mov    0x8(%ebp),%eax
  80178f:	8a 00                	mov    (%eax),%al
  801791:	0f b6 d0             	movzbl %al,%edx
  801794:	8b 45 0c             	mov    0xc(%ebp),%eax
  801797:	8a 00                	mov    (%eax),%al
  801799:	0f b6 c0             	movzbl %al,%eax
  80179c:	29 c2                	sub    %eax,%edx
  80179e:	89 d0                	mov    %edx,%eax
}
  8017a0:	5d                   	pop    %ebp
  8017a1:	c3                   	ret    

008017a2 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8017a2:	55                   	push   %ebp
  8017a3:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8017a5:	eb 09                	jmp    8017b0 <strncmp+0xe>
		n--, p++, q++;
  8017a7:	ff 4d 10             	decl   0x10(%ebp)
  8017aa:	ff 45 08             	incl   0x8(%ebp)
  8017ad:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8017b0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017b4:	74 17                	je     8017cd <strncmp+0x2b>
  8017b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b9:	8a 00                	mov    (%eax),%al
  8017bb:	84 c0                	test   %al,%al
  8017bd:	74 0e                	je     8017cd <strncmp+0x2b>
  8017bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c2:	8a 10                	mov    (%eax),%dl
  8017c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c7:	8a 00                	mov    (%eax),%al
  8017c9:	38 c2                	cmp    %al,%dl
  8017cb:	74 da                	je     8017a7 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8017cd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017d1:	75 07                	jne    8017da <strncmp+0x38>
		return 0;
  8017d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8017d8:	eb 14                	jmp    8017ee <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8017da:	8b 45 08             	mov    0x8(%ebp),%eax
  8017dd:	8a 00                	mov    (%eax),%al
  8017df:	0f b6 d0             	movzbl %al,%edx
  8017e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e5:	8a 00                	mov    (%eax),%al
  8017e7:	0f b6 c0             	movzbl %al,%eax
  8017ea:	29 c2                	sub    %eax,%edx
  8017ec:	89 d0                	mov    %edx,%eax
}
  8017ee:	5d                   	pop    %ebp
  8017ef:	c3                   	ret    

008017f0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8017f0:	55                   	push   %ebp
  8017f1:	89 e5                	mov    %esp,%ebp
  8017f3:	83 ec 04             	sub    $0x4,%esp
  8017f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8017fc:	eb 12                	jmp    801810 <strchr+0x20>
		if (*s == c)
  8017fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801801:	8a 00                	mov    (%eax),%al
  801803:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801806:	75 05                	jne    80180d <strchr+0x1d>
			return (char *) s;
  801808:	8b 45 08             	mov    0x8(%ebp),%eax
  80180b:	eb 11                	jmp    80181e <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80180d:	ff 45 08             	incl   0x8(%ebp)
  801810:	8b 45 08             	mov    0x8(%ebp),%eax
  801813:	8a 00                	mov    (%eax),%al
  801815:	84 c0                	test   %al,%al
  801817:	75 e5                	jne    8017fe <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801819:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80181e:	c9                   	leave  
  80181f:	c3                   	ret    

00801820 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801820:	55                   	push   %ebp
  801821:	89 e5                	mov    %esp,%ebp
  801823:	83 ec 04             	sub    $0x4,%esp
  801826:	8b 45 0c             	mov    0xc(%ebp),%eax
  801829:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80182c:	eb 0d                	jmp    80183b <strfind+0x1b>
		if (*s == c)
  80182e:	8b 45 08             	mov    0x8(%ebp),%eax
  801831:	8a 00                	mov    (%eax),%al
  801833:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801836:	74 0e                	je     801846 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801838:	ff 45 08             	incl   0x8(%ebp)
  80183b:	8b 45 08             	mov    0x8(%ebp),%eax
  80183e:	8a 00                	mov    (%eax),%al
  801840:	84 c0                	test   %al,%al
  801842:	75 ea                	jne    80182e <strfind+0xe>
  801844:	eb 01                	jmp    801847 <strfind+0x27>
		if (*s == c)
			break;
  801846:	90                   	nop
	return (char *) s;
  801847:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80184a:	c9                   	leave  
  80184b:	c3                   	ret    

0080184c <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80184c:	55                   	push   %ebp
  80184d:	89 e5                	mov    %esp,%ebp
  80184f:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801852:	8b 45 08             	mov    0x8(%ebp),%eax
  801855:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801858:	8b 45 10             	mov    0x10(%ebp),%eax
  80185b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80185e:	eb 0e                	jmp    80186e <memset+0x22>
		*p++ = c;
  801860:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801863:	8d 50 01             	lea    0x1(%eax),%edx
  801866:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801869:	8b 55 0c             	mov    0xc(%ebp),%edx
  80186c:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80186e:	ff 4d f8             	decl   -0x8(%ebp)
  801871:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801875:	79 e9                	jns    801860 <memset+0x14>
		*p++ = c;

	return v;
  801877:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80187a:	c9                   	leave  
  80187b:	c3                   	ret    

0080187c <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80187c:	55                   	push   %ebp
  80187d:	89 e5                	mov    %esp,%ebp
  80187f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801882:	8b 45 0c             	mov    0xc(%ebp),%eax
  801885:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801888:	8b 45 08             	mov    0x8(%ebp),%eax
  80188b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80188e:	eb 16                	jmp    8018a6 <memcpy+0x2a>
		*d++ = *s++;
  801890:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801893:	8d 50 01             	lea    0x1(%eax),%edx
  801896:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801899:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80189c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80189f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8018a2:	8a 12                	mov    (%edx),%dl
  8018a4:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8018a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8018a9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8018ac:	89 55 10             	mov    %edx,0x10(%ebp)
  8018af:	85 c0                	test   %eax,%eax
  8018b1:	75 dd                	jne    801890 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8018b3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8018b6:	c9                   	leave  
  8018b7:	c3                   	ret    

008018b8 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8018b8:	55                   	push   %ebp
  8018b9:	89 e5                	mov    %esp,%ebp
  8018bb:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8018be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8018c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8018ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018cd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8018d0:	73 50                	jae    801922 <memmove+0x6a>
  8018d2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8018d8:	01 d0                	add    %edx,%eax
  8018da:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8018dd:	76 43                	jbe    801922 <memmove+0x6a>
		s += n;
  8018df:	8b 45 10             	mov    0x10(%ebp),%eax
  8018e2:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8018e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8018e8:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8018eb:	eb 10                	jmp    8018fd <memmove+0x45>
			*--d = *--s;
  8018ed:	ff 4d f8             	decl   -0x8(%ebp)
  8018f0:	ff 4d fc             	decl   -0x4(%ebp)
  8018f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018f6:	8a 10                	mov    (%eax),%dl
  8018f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018fb:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8018fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801900:	8d 50 ff             	lea    -0x1(%eax),%edx
  801903:	89 55 10             	mov    %edx,0x10(%ebp)
  801906:	85 c0                	test   %eax,%eax
  801908:	75 e3                	jne    8018ed <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80190a:	eb 23                	jmp    80192f <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80190c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80190f:	8d 50 01             	lea    0x1(%eax),%edx
  801912:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801915:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801918:	8d 4a 01             	lea    0x1(%edx),%ecx
  80191b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80191e:	8a 12                	mov    (%edx),%dl
  801920:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801922:	8b 45 10             	mov    0x10(%ebp),%eax
  801925:	8d 50 ff             	lea    -0x1(%eax),%edx
  801928:	89 55 10             	mov    %edx,0x10(%ebp)
  80192b:	85 c0                	test   %eax,%eax
  80192d:	75 dd                	jne    80190c <memmove+0x54>
			*d++ = *s++;

	return dst;
  80192f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801932:	c9                   	leave  
  801933:	c3                   	ret    

00801934 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801934:	55                   	push   %ebp
  801935:	89 e5                	mov    %esp,%ebp
  801937:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80193a:	8b 45 08             	mov    0x8(%ebp),%eax
  80193d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801940:	8b 45 0c             	mov    0xc(%ebp),%eax
  801943:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801946:	eb 2a                	jmp    801972 <memcmp+0x3e>
		if (*s1 != *s2)
  801948:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80194b:	8a 10                	mov    (%eax),%dl
  80194d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801950:	8a 00                	mov    (%eax),%al
  801952:	38 c2                	cmp    %al,%dl
  801954:	74 16                	je     80196c <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801956:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801959:	8a 00                	mov    (%eax),%al
  80195b:	0f b6 d0             	movzbl %al,%edx
  80195e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801961:	8a 00                	mov    (%eax),%al
  801963:	0f b6 c0             	movzbl %al,%eax
  801966:	29 c2                	sub    %eax,%edx
  801968:	89 d0                	mov    %edx,%eax
  80196a:	eb 18                	jmp    801984 <memcmp+0x50>
		s1++, s2++;
  80196c:	ff 45 fc             	incl   -0x4(%ebp)
  80196f:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801972:	8b 45 10             	mov    0x10(%ebp),%eax
  801975:	8d 50 ff             	lea    -0x1(%eax),%edx
  801978:	89 55 10             	mov    %edx,0x10(%ebp)
  80197b:	85 c0                	test   %eax,%eax
  80197d:	75 c9                	jne    801948 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80197f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801984:	c9                   	leave  
  801985:	c3                   	ret    

00801986 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801986:	55                   	push   %ebp
  801987:	89 e5                	mov    %esp,%ebp
  801989:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80198c:	8b 55 08             	mov    0x8(%ebp),%edx
  80198f:	8b 45 10             	mov    0x10(%ebp),%eax
  801992:	01 d0                	add    %edx,%eax
  801994:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801997:	eb 15                	jmp    8019ae <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801999:	8b 45 08             	mov    0x8(%ebp),%eax
  80199c:	8a 00                	mov    (%eax),%al
  80199e:	0f b6 d0             	movzbl %al,%edx
  8019a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a4:	0f b6 c0             	movzbl %al,%eax
  8019a7:	39 c2                	cmp    %eax,%edx
  8019a9:	74 0d                	je     8019b8 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8019ab:	ff 45 08             	incl   0x8(%ebp)
  8019ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8019b4:	72 e3                	jb     801999 <memfind+0x13>
  8019b6:	eb 01                	jmp    8019b9 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8019b8:	90                   	nop
	return (void *) s;
  8019b9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8019bc:	c9                   	leave  
  8019bd:	c3                   	ret    

008019be <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8019be:	55                   	push   %ebp
  8019bf:	89 e5                	mov    %esp,%ebp
  8019c1:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8019c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8019cb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8019d2:	eb 03                	jmp    8019d7 <strtol+0x19>
		s++;
  8019d4:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8019d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019da:	8a 00                	mov    (%eax),%al
  8019dc:	3c 20                	cmp    $0x20,%al
  8019de:	74 f4                	je     8019d4 <strtol+0x16>
  8019e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e3:	8a 00                	mov    (%eax),%al
  8019e5:	3c 09                	cmp    $0x9,%al
  8019e7:	74 eb                	je     8019d4 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8019e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ec:	8a 00                	mov    (%eax),%al
  8019ee:	3c 2b                	cmp    $0x2b,%al
  8019f0:	75 05                	jne    8019f7 <strtol+0x39>
		s++;
  8019f2:	ff 45 08             	incl   0x8(%ebp)
  8019f5:	eb 13                	jmp    801a0a <strtol+0x4c>
	else if (*s == '-')
  8019f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fa:	8a 00                	mov    (%eax),%al
  8019fc:	3c 2d                	cmp    $0x2d,%al
  8019fe:	75 0a                	jne    801a0a <strtol+0x4c>
		s++, neg = 1;
  801a00:	ff 45 08             	incl   0x8(%ebp)
  801a03:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801a0a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a0e:	74 06                	je     801a16 <strtol+0x58>
  801a10:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801a14:	75 20                	jne    801a36 <strtol+0x78>
  801a16:	8b 45 08             	mov    0x8(%ebp),%eax
  801a19:	8a 00                	mov    (%eax),%al
  801a1b:	3c 30                	cmp    $0x30,%al
  801a1d:	75 17                	jne    801a36 <strtol+0x78>
  801a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a22:	40                   	inc    %eax
  801a23:	8a 00                	mov    (%eax),%al
  801a25:	3c 78                	cmp    $0x78,%al
  801a27:	75 0d                	jne    801a36 <strtol+0x78>
		s += 2, base = 16;
  801a29:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801a2d:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801a34:	eb 28                	jmp    801a5e <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801a36:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a3a:	75 15                	jne    801a51 <strtol+0x93>
  801a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3f:	8a 00                	mov    (%eax),%al
  801a41:	3c 30                	cmp    $0x30,%al
  801a43:	75 0c                	jne    801a51 <strtol+0x93>
		s++, base = 8;
  801a45:	ff 45 08             	incl   0x8(%ebp)
  801a48:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801a4f:	eb 0d                	jmp    801a5e <strtol+0xa0>
	else if (base == 0)
  801a51:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a55:	75 07                	jne    801a5e <strtol+0xa0>
		base = 10;
  801a57:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a61:	8a 00                	mov    (%eax),%al
  801a63:	3c 2f                	cmp    $0x2f,%al
  801a65:	7e 19                	jle    801a80 <strtol+0xc2>
  801a67:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6a:	8a 00                	mov    (%eax),%al
  801a6c:	3c 39                	cmp    $0x39,%al
  801a6e:	7f 10                	jg     801a80 <strtol+0xc2>
			dig = *s - '0';
  801a70:	8b 45 08             	mov    0x8(%ebp),%eax
  801a73:	8a 00                	mov    (%eax),%al
  801a75:	0f be c0             	movsbl %al,%eax
  801a78:	83 e8 30             	sub    $0x30,%eax
  801a7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a7e:	eb 42                	jmp    801ac2 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801a80:	8b 45 08             	mov    0x8(%ebp),%eax
  801a83:	8a 00                	mov    (%eax),%al
  801a85:	3c 60                	cmp    $0x60,%al
  801a87:	7e 19                	jle    801aa2 <strtol+0xe4>
  801a89:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8c:	8a 00                	mov    (%eax),%al
  801a8e:	3c 7a                	cmp    $0x7a,%al
  801a90:	7f 10                	jg     801aa2 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801a92:	8b 45 08             	mov    0x8(%ebp),%eax
  801a95:	8a 00                	mov    (%eax),%al
  801a97:	0f be c0             	movsbl %al,%eax
  801a9a:	83 e8 57             	sub    $0x57,%eax
  801a9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801aa0:	eb 20                	jmp    801ac2 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa5:	8a 00                	mov    (%eax),%al
  801aa7:	3c 40                	cmp    $0x40,%al
  801aa9:	7e 39                	jle    801ae4 <strtol+0x126>
  801aab:	8b 45 08             	mov    0x8(%ebp),%eax
  801aae:	8a 00                	mov    (%eax),%al
  801ab0:	3c 5a                	cmp    $0x5a,%al
  801ab2:	7f 30                	jg     801ae4 <strtol+0x126>
			dig = *s - 'A' + 10;
  801ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab7:	8a 00                	mov    (%eax),%al
  801ab9:	0f be c0             	movsbl %al,%eax
  801abc:	83 e8 37             	sub    $0x37,%eax
  801abf:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ac5:	3b 45 10             	cmp    0x10(%ebp),%eax
  801ac8:	7d 19                	jge    801ae3 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801aca:	ff 45 08             	incl   0x8(%ebp)
  801acd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ad0:	0f af 45 10          	imul   0x10(%ebp),%eax
  801ad4:	89 c2                	mov    %eax,%edx
  801ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ad9:	01 d0                	add    %edx,%eax
  801adb:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801ade:	e9 7b ff ff ff       	jmp    801a5e <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801ae3:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801ae4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ae8:	74 08                	je     801af2 <strtol+0x134>
		*endptr = (char *) s;
  801aea:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aed:	8b 55 08             	mov    0x8(%ebp),%edx
  801af0:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801af2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801af6:	74 07                	je     801aff <strtol+0x141>
  801af8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801afb:	f7 d8                	neg    %eax
  801afd:	eb 03                	jmp    801b02 <strtol+0x144>
  801aff:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801b02:	c9                   	leave  
  801b03:	c3                   	ret    

00801b04 <ltostr>:

void
ltostr(long value, char *str)
{
  801b04:	55                   	push   %ebp
  801b05:	89 e5                	mov    %esp,%ebp
  801b07:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801b0a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801b11:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801b18:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b1c:	79 13                	jns    801b31 <ltostr+0x2d>
	{
		neg = 1;
  801b1e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801b25:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b28:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801b2b:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801b2e:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801b31:	8b 45 08             	mov    0x8(%ebp),%eax
  801b34:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801b39:	99                   	cltd   
  801b3a:	f7 f9                	idiv   %ecx
  801b3c:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801b3f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b42:	8d 50 01             	lea    0x1(%eax),%edx
  801b45:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801b48:	89 c2                	mov    %eax,%edx
  801b4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b4d:	01 d0                	add    %edx,%eax
  801b4f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801b52:	83 c2 30             	add    $0x30,%edx
  801b55:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801b57:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b5a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801b5f:	f7 e9                	imul   %ecx
  801b61:	c1 fa 02             	sar    $0x2,%edx
  801b64:	89 c8                	mov    %ecx,%eax
  801b66:	c1 f8 1f             	sar    $0x1f,%eax
  801b69:	29 c2                	sub    %eax,%edx
  801b6b:	89 d0                	mov    %edx,%eax
  801b6d:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801b70:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b73:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801b78:	f7 e9                	imul   %ecx
  801b7a:	c1 fa 02             	sar    $0x2,%edx
  801b7d:	89 c8                	mov    %ecx,%eax
  801b7f:	c1 f8 1f             	sar    $0x1f,%eax
  801b82:	29 c2                	sub    %eax,%edx
  801b84:	89 d0                	mov    %edx,%eax
  801b86:	c1 e0 02             	shl    $0x2,%eax
  801b89:	01 d0                	add    %edx,%eax
  801b8b:	01 c0                	add    %eax,%eax
  801b8d:	29 c1                	sub    %eax,%ecx
  801b8f:	89 ca                	mov    %ecx,%edx
  801b91:	85 d2                	test   %edx,%edx
  801b93:	75 9c                	jne    801b31 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801b95:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801b9c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b9f:	48                   	dec    %eax
  801ba0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801ba3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801ba7:	74 3d                	je     801be6 <ltostr+0xe2>
		start = 1 ;
  801ba9:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801bb0:	eb 34                	jmp    801be6 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801bb2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bb8:	01 d0                	add    %edx,%eax
  801bba:	8a 00                	mov    (%eax),%al
  801bbc:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801bbf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bc5:	01 c2                	add    %eax,%edx
  801bc7:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801bca:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bcd:	01 c8                	add    %ecx,%eax
  801bcf:	8a 00                	mov    (%eax),%al
  801bd1:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801bd3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801bd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bd9:	01 c2                	add    %eax,%edx
  801bdb:	8a 45 eb             	mov    -0x15(%ebp),%al
  801bde:	88 02                	mov    %al,(%edx)
		start++ ;
  801be0:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801be3:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801be6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801be9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801bec:	7c c4                	jl     801bb2 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801bee:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801bf1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bf4:	01 d0                	add    %edx,%eax
  801bf6:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801bf9:	90                   	nop
  801bfa:	c9                   	leave  
  801bfb:	c3                   	ret    

00801bfc <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801bfc:	55                   	push   %ebp
  801bfd:	89 e5                	mov    %esp,%ebp
  801bff:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801c02:	ff 75 08             	pushl  0x8(%ebp)
  801c05:	e8 54 fa ff ff       	call   80165e <strlen>
  801c0a:	83 c4 04             	add    $0x4,%esp
  801c0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801c10:	ff 75 0c             	pushl  0xc(%ebp)
  801c13:	e8 46 fa ff ff       	call   80165e <strlen>
  801c18:	83 c4 04             	add    $0x4,%esp
  801c1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801c1e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801c25:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801c2c:	eb 17                	jmp    801c45 <strcconcat+0x49>
		final[s] = str1[s] ;
  801c2e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c31:	8b 45 10             	mov    0x10(%ebp),%eax
  801c34:	01 c2                	add    %eax,%edx
  801c36:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801c39:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3c:	01 c8                	add    %ecx,%eax
  801c3e:	8a 00                	mov    (%eax),%al
  801c40:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801c42:	ff 45 fc             	incl   -0x4(%ebp)
  801c45:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c48:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801c4b:	7c e1                	jl     801c2e <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801c4d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801c54:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801c5b:	eb 1f                	jmp    801c7c <strcconcat+0x80>
		final[s++] = str2[i] ;
  801c5d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c60:	8d 50 01             	lea    0x1(%eax),%edx
  801c63:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801c66:	89 c2                	mov    %eax,%edx
  801c68:	8b 45 10             	mov    0x10(%ebp),%eax
  801c6b:	01 c2                	add    %eax,%edx
  801c6d:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801c70:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c73:	01 c8                	add    %ecx,%eax
  801c75:	8a 00                	mov    (%eax),%al
  801c77:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801c79:	ff 45 f8             	incl   -0x8(%ebp)
  801c7c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c7f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801c82:	7c d9                	jl     801c5d <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801c84:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c87:	8b 45 10             	mov    0x10(%ebp),%eax
  801c8a:	01 d0                	add    %edx,%eax
  801c8c:	c6 00 00             	movb   $0x0,(%eax)
}
  801c8f:	90                   	nop
  801c90:	c9                   	leave  
  801c91:	c3                   	ret    

00801c92 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801c92:	55                   	push   %ebp
  801c93:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801c95:	8b 45 14             	mov    0x14(%ebp),%eax
  801c98:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801c9e:	8b 45 14             	mov    0x14(%ebp),%eax
  801ca1:	8b 00                	mov    (%eax),%eax
  801ca3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801caa:	8b 45 10             	mov    0x10(%ebp),%eax
  801cad:	01 d0                	add    %edx,%eax
  801caf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801cb5:	eb 0c                	jmp    801cc3 <strsplit+0x31>
			*string++ = 0;
  801cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cba:	8d 50 01             	lea    0x1(%eax),%edx
  801cbd:	89 55 08             	mov    %edx,0x8(%ebp)
  801cc0:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc6:	8a 00                	mov    (%eax),%al
  801cc8:	84 c0                	test   %al,%al
  801cca:	74 18                	je     801ce4 <strsplit+0x52>
  801ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccf:	8a 00                	mov    (%eax),%al
  801cd1:	0f be c0             	movsbl %al,%eax
  801cd4:	50                   	push   %eax
  801cd5:	ff 75 0c             	pushl  0xc(%ebp)
  801cd8:	e8 13 fb ff ff       	call   8017f0 <strchr>
  801cdd:	83 c4 08             	add    $0x8,%esp
  801ce0:	85 c0                	test   %eax,%eax
  801ce2:	75 d3                	jne    801cb7 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce7:	8a 00                	mov    (%eax),%al
  801ce9:	84 c0                	test   %al,%al
  801ceb:	74 5a                	je     801d47 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801ced:	8b 45 14             	mov    0x14(%ebp),%eax
  801cf0:	8b 00                	mov    (%eax),%eax
  801cf2:	83 f8 0f             	cmp    $0xf,%eax
  801cf5:	75 07                	jne    801cfe <strsplit+0x6c>
		{
			return 0;
  801cf7:	b8 00 00 00 00       	mov    $0x0,%eax
  801cfc:	eb 66                	jmp    801d64 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801cfe:	8b 45 14             	mov    0x14(%ebp),%eax
  801d01:	8b 00                	mov    (%eax),%eax
  801d03:	8d 48 01             	lea    0x1(%eax),%ecx
  801d06:	8b 55 14             	mov    0x14(%ebp),%edx
  801d09:	89 0a                	mov    %ecx,(%edx)
  801d0b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801d12:	8b 45 10             	mov    0x10(%ebp),%eax
  801d15:	01 c2                	add    %eax,%edx
  801d17:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1a:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801d1c:	eb 03                	jmp    801d21 <strsplit+0x8f>
			string++;
  801d1e:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801d21:	8b 45 08             	mov    0x8(%ebp),%eax
  801d24:	8a 00                	mov    (%eax),%al
  801d26:	84 c0                	test   %al,%al
  801d28:	74 8b                	je     801cb5 <strsplit+0x23>
  801d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2d:	8a 00                	mov    (%eax),%al
  801d2f:	0f be c0             	movsbl %al,%eax
  801d32:	50                   	push   %eax
  801d33:	ff 75 0c             	pushl  0xc(%ebp)
  801d36:	e8 b5 fa ff ff       	call   8017f0 <strchr>
  801d3b:	83 c4 08             	add    $0x8,%esp
  801d3e:	85 c0                	test   %eax,%eax
  801d40:	74 dc                	je     801d1e <strsplit+0x8c>
			string++;
	}
  801d42:	e9 6e ff ff ff       	jmp    801cb5 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801d47:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801d48:	8b 45 14             	mov    0x14(%ebp),%eax
  801d4b:	8b 00                	mov    (%eax),%eax
  801d4d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801d54:	8b 45 10             	mov    0x10(%ebp),%eax
  801d57:	01 d0                	add    %edx,%eax
  801d59:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801d5f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801d64:	c9                   	leave  
  801d65:	c3                   	ret    

00801d66 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801d66:	55                   	push   %ebp
  801d67:	89 e5                	mov    %esp,%ebp
  801d69:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801d6c:	a1 04 50 80 00       	mov    0x805004,%eax
  801d71:	85 c0                	test   %eax,%eax
  801d73:	74 1f                	je     801d94 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801d75:	e8 1d 00 00 00       	call   801d97 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801d7a:	83 ec 0c             	sub    $0xc,%esp
  801d7d:	68 10 45 80 00       	push   $0x804510
  801d82:	e8 55 f2 ff ff       	call   800fdc <cprintf>
  801d87:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801d8a:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801d91:	00 00 00 
	}
}
  801d94:	90                   	nop
  801d95:	c9                   	leave  
  801d96:	c3                   	ret    

00801d97 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801d97:	55                   	push   %ebp
  801d98:	89 e5                	mov    %esp,%ebp
  801d9a:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  801d9d:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801da4:	00 00 00 
  801da7:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801dae:	00 00 00 
  801db1:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801db8:	00 00 00 
		LIST_INIT(&AllocMemBlocksList);
  801dbb:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801dc2:	00 00 00 
  801dc5:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801dcc:	00 00 00 
  801dcf:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801dd6:	00 00 00 

		MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES ;
  801dd9:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801de0:	00 02 00 
		MemBlockNodes =(struct MemBlock*)USER_DYN_BLKS_ARRAY ;
  801de3:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801dea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ded:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801df2:	2d 00 10 00 00       	sub    $0x1000,%eax
  801df7:	a3 50 50 80 00       	mov    %eax,0x805050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock),PAGE_SIZE),PERM_USER|PERM_WRITEABLE);
  801dfc:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801e03:	a1 20 51 80 00       	mov    0x805120,%eax
  801e08:	c1 e0 04             	shl    $0x4,%eax
  801e0b:	89 c2                	mov    %eax,%edx
  801e0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e10:	01 d0                	add    %edx,%eax
  801e12:	48                   	dec    %eax
  801e13:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801e16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e19:	ba 00 00 00 00       	mov    $0x0,%edx
  801e1e:	f7 75 f0             	divl   -0x10(%ebp)
  801e21:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e24:	29 d0                	sub    %edx,%eax
  801e26:	89 c2                	mov    %eax,%edx
  801e28:	c7 45 e8 00 00 e0 7f 	movl   $0x7fe00000,-0x18(%ebp)
  801e2f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e32:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801e37:	2d 00 10 00 00       	sub    $0x1000,%eax
  801e3c:	83 ec 04             	sub    $0x4,%esp
  801e3f:	6a 06                	push   $0x6
  801e41:	52                   	push   %edx
  801e42:	50                   	push   %eax
  801e43:	e8 71 05 00 00       	call   8023b9 <sys_allocate_chunk>
  801e48:	83 c4 10             	add    $0x10,%esp
		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801e4b:	a1 20 51 80 00       	mov    0x805120,%eax
  801e50:	83 ec 0c             	sub    $0xc,%esp
  801e53:	50                   	push   %eax
  801e54:	e8 e6 0b 00 00       	call   802a3f <initialize_MemBlocksList>
  801e59:	83 c4 10             	add    $0x10,%esp

		struct MemBlock  *block_node;
		block_node = AvailableMemBlocksList.lh_first;
  801e5c:	a1 48 51 80 00       	mov    0x805148,%eax
  801e61:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&(AvailableMemBlocksList),block_node);
  801e64:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801e68:	75 14                	jne    801e7e <initialize_dyn_block_system+0xe7>
  801e6a:	83 ec 04             	sub    $0x4,%esp
  801e6d:	68 35 45 80 00       	push   $0x804535
  801e72:	6a 2b                	push   $0x2b
  801e74:	68 53 45 80 00       	push   $0x804553
  801e79:	e8 aa ee ff ff       	call   800d28 <_panic>
  801e7e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e81:	8b 00                	mov    (%eax),%eax
  801e83:	85 c0                	test   %eax,%eax
  801e85:	74 10                	je     801e97 <initialize_dyn_block_system+0x100>
  801e87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e8a:	8b 00                	mov    (%eax),%eax
  801e8c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801e8f:	8b 52 04             	mov    0x4(%edx),%edx
  801e92:	89 50 04             	mov    %edx,0x4(%eax)
  801e95:	eb 0b                	jmp    801ea2 <initialize_dyn_block_system+0x10b>
  801e97:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e9a:	8b 40 04             	mov    0x4(%eax),%eax
  801e9d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801ea2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ea5:	8b 40 04             	mov    0x4(%eax),%eax
  801ea8:	85 c0                	test   %eax,%eax
  801eaa:	74 0f                	je     801ebb <initialize_dyn_block_system+0x124>
  801eac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801eaf:	8b 40 04             	mov    0x4(%eax),%eax
  801eb2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801eb5:	8b 12                	mov    (%edx),%edx
  801eb7:	89 10                	mov    %edx,(%eax)
  801eb9:	eb 0a                	jmp    801ec5 <initialize_dyn_block_system+0x12e>
  801ebb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ebe:	8b 00                	mov    (%eax),%eax
  801ec0:	a3 48 51 80 00       	mov    %eax,0x805148
  801ec5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ec8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801ece:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ed1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801ed8:	a1 54 51 80 00       	mov    0x805154,%eax
  801edd:	48                   	dec    %eax
  801ede:	a3 54 51 80 00       	mov    %eax,0x805154
		block_node->sva = USER_HEAP_START ;
  801ee3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ee6:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
		block_node->size = ((USER_HEAP_MAX - USER_HEAP_START));
  801eed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ef0:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		insert_sorted_with_merge_freeList(block_node);
  801ef7:	83 ec 0c             	sub    $0xc,%esp
  801efa:	ff 75 e4             	pushl  -0x1c(%ebp)
  801efd:	e8 d2 13 00 00       	call   8032d4 <insert_sorted_with_merge_freeList>
  801f02:	83 c4 10             	add    $0x10,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801f05:	90                   	nop
  801f06:	c9                   	leave  
  801f07:	c3                   	ret    

00801f08 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801f08:	55                   	push   %ebp
  801f09:	89 e5                	mov    %esp,%ebp
  801f0b:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801f0e:	e8 53 fe ff ff       	call   801d66 <InitializeUHeap>
	if (size == 0) return NULL ;
  801f13:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f17:	75 07                	jne    801f20 <malloc+0x18>
  801f19:	b8 00 00 00 00       	mov    $0x0,%eax
  801f1e:	eb 61                	jmp    801f81 <malloc+0x79>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	size= ROUNDUP(size,PAGE_SIZE);
  801f20:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801f27:	8b 55 08             	mov    0x8(%ebp),%edx
  801f2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f2d:	01 d0                	add    %edx,%eax
  801f2f:	48                   	dec    %eax
  801f30:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801f33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f36:	ba 00 00 00 00       	mov    $0x0,%edx
  801f3b:	f7 75 f4             	divl   -0xc(%ebp)
  801f3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f41:	29 d0                	sub    %edx,%eax
  801f43:	89 45 08             	mov    %eax,0x8(%ebp)
	    			if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801f46:	e8 3c 08 00 00       	call   802787 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801f4b:	85 c0                	test   %eax,%eax
  801f4d:	74 2d                	je     801f7c <malloc+0x74>
	    			{
	    				struct MemBlock * ff_block = alloc_block_FF(size);
  801f4f:	83 ec 0c             	sub    $0xc,%esp
  801f52:	ff 75 08             	pushl  0x8(%ebp)
  801f55:	e8 3e 0f 00 00       	call   802e98 <alloc_block_FF>
  801f5a:	83 c4 10             	add    $0x10,%esp
  801f5d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    				if(ff_block!=NULL)
  801f60:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801f64:	74 16                	je     801f7c <malloc+0x74>
	    				{

	    					insert_sorted_allocList(ff_block);
  801f66:	83 ec 0c             	sub    $0xc,%esp
  801f69:	ff 75 ec             	pushl  -0x14(%ebp)
  801f6c:	e8 48 0c 00 00       	call   802bb9 <insert_sorted_allocList>
  801f71:	83 c4 10             	add    $0x10,%esp
	    					return (void*) ff_block->sva ;
  801f74:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f77:	8b 40 08             	mov    0x8(%eax),%eax
  801f7a:	eb 05                	jmp    801f81 <malloc+0x79>

	    				}
	}
	    			return (void*) NULL ;
  801f7c:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801f81:	c9                   	leave  
  801f82:	c3                   	ret    

00801f83 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801f83:	55                   	push   %ebp
  801f84:	89 e5                	mov    %esp,%ebp
  801f86:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock *elementForEach;
		virtual_address = ROUNDDOWN(virtual_address, PAGE_SIZE);
  801f89:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f92:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801f97:	89 45 08             	mov    %eax,0x8(%ebp)
	//	if (is_mallocPages[indexindex((uint32) virtual_address)] == 1) {
		elementForEach = find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801f9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9d:	83 ec 08             	sub    $0x8,%esp
  801fa0:	50                   	push   %eax
  801fa1:	68 40 50 80 00       	push   $0x805040
  801fa6:	e8 71 0b 00 00       	call   802b1c <find_block>
  801fab:	83 c4 10             	add    $0x10,%esp
  801fae:	89 45 f0             	mov    %eax,-0x10(%ebp)
		sys_free_user_mem((uint32) virtual_address, elementForEach->size);
  801fb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fb4:	8b 50 0c             	mov    0xc(%eax),%edx
  801fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801fba:	83 ec 08             	sub    $0x8,%esp
  801fbd:	52                   	push   %edx
  801fbe:	50                   	push   %eax
  801fbf:	e8 bd 03 00 00       	call   802381 <sys_free_user_mem>
  801fc4:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,elementForEach);
  801fc7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fcb:	75 14                	jne    801fe1 <free+0x5e>
  801fcd:	83 ec 04             	sub    $0x4,%esp
  801fd0:	68 35 45 80 00       	push   $0x804535
  801fd5:	6a 71                	push   $0x71
  801fd7:	68 53 45 80 00       	push   $0x804553
  801fdc:	e8 47 ed ff ff       	call   800d28 <_panic>
  801fe1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fe4:	8b 00                	mov    (%eax),%eax
  801fe6:	85 c0                	test   %eax,%eax
  801fe8:	74 10                	je     801ffa <free+0x77>
  801fea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fed:	8b 00                	mov    (%eax),%eax
  801fef:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ff2:	8b 52 04             	mov    0x4(%edx),%edx
  801ff5:	89 50 04             	mov    %edx,0x4(%eax)
  801ff8:	eb 0b                	jmp    802005 <free+0x82>
  801ffa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ffd:	8b 40 04             	mov    0x4(%eax),%eax
  802000:	a3 44 50 80 00       	mov    %eax,0x805044
  802005:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802008:	8b 40 04             	mov    0x4(%eax),%eax
  80200b:	85 c0                	test   %eax,%eax
  80200d:	74 0f                	je     80201e <free+0x9b>
  80200f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802012:	8b 40 04             	mov    0x4(%eax),%eax
  802015:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802018:	8b 12                	mov    (%edx),%edx
  80201a:	89 10                	mov    %edx,(%eax)
  80201c:	eb 0a                	jmp    802028 <free+0xa5>
  80201e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802021:	8b 00                	mov    (%eax),%eax
  802023:	a3 40 50 80 00       	mov    %eax,0x805040
  802028:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80202b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802031:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802034:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80203b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802040:	48                   	dec    %eax
  802041:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(elementForEach);
  802046:	83 ec 0c             	sub    $0xc,%esp
  802049:	ff 75 f0             	pushl  -0x10(%ebp)
  80204c:	e8 83 12 00 00       	call   8032d4 <insert_sorted_with_merge_freeList>
  802051:	83 c4 10             	add    $0x10,%esp
	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  802054:	90                   	nop
  802055:	c9                   	leave  
  802056:	c3                   	ret    

00802057 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802057:	55                   	push   %ebp
  802058:	89 e5                	mov    %esp,%ebp
  80205a:	83 ec 28             	sub    $0x28,%esp
  80205d:	8b 45 10             	mov    0x10(%ebp),%eax
  802060:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802063:	e8 fe fc ff ff       	call   801d66 <InitializeUHeap>
	if (size == 0) return NULL ;
  802068:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80206c:	75 0a                	jne    802078 <smalloc+0x21>
  80206e:	b8 00 00 00 00       	mov    $0x0,%eax
  802073:	e9 86 00 00 00       	jmp    8020fe <smalloc+0xa7>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code

	size=ROUNDUP(size,PAGE_SIZE);
  802078:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80207f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802082:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802085:	01 d0                	add    %edx,%eax
  802087:	48                   	dec    %eax
  802088:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80208b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80208e:	ba 00 00 00 00       	mov    $0x0,%edx
  802093:	f7 75 f4             	divl   -0xc(%ebp)
  802096:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802099:	29 d0                	sub    %edx,%eax
  80209b:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80209e:	e8 e4 06 00 00       	call   802787 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8020a3:	85 c0                	test   %eax,%eax
  8020a5:	74 52                	je     8020f9 <smalloc+0xa2>
		{
		struct MemBlock * ff_block ;
		ff_block = alloc_block_FF(size);
  8020a7:	83 ec 0c             	sub    $0xc,%esp
  8020aa:	ff 75 0c             	pushl  0xc(%ebp)
  8020ad:	e8 e6 0d 00 00       	call   802e98 <alloc_block_FF>
  8020b2:	83 c4 10             	add    $0x10,%esp
  8020b5:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(ff_block==NULL)
  8020b8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8020bc:	75 07                	jne    8020c5 <smalloc+0x6e>
			return NULL ;
  8020be:	b8 00 00 00 00       	mov    $0x0,%eax
  8020c3:	eb 39                	jmp    8020fe <smalloc+0xa7>

		int obj_id =sys_createSharedObject(sharedVarName,size,isWritable,(void*)ff_block->sva);
  8020c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020c8:	8b 40 08             	mov    0x8(%eax),%eax
  8020cb:	89 c2                	mov    %eax,%edx
  8020cd:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8020d1:	52                   	push   %edx
  8020d2:	50                   	push   %eax
  8020d3:	ff 75 0c             	pushl  0xc(%ebp)
  8020d6:	ff 75 08             	pushl  0x8(%ebp)
  8020d9:	e8 2e 04 00 00       	call   80250c <sys_createSharedObject>
  8020de:	83 c4 10             	add    $0x10,%esp
  8020e1:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(obj_id < 0)
  8020e4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8020e8:	79 07                	jns    8020f1 <smalloc+0x9a>
			return (void*)NULL ;
  8020ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ef:	eb 0d                	jmp    8020fe <smalloc+0xa7>
		else
		    return (void*)ff_block->sva ;
  8020f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020f4:	8b 40 08             	mov    0x8(%eax),%eax
  8020f7:	eb 05                	jmp    8020fe <smalloc+0xa7>
		}
		return (void*)NULL ;
  8020f9:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8020fe:	c9                   	leave  
  8020ff:	c3                   	ret    

00802100 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802100:	55                   	push   %ebp
  802101:	89 e5                	mov    %esp,%ebp
  802103:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802106:	e8 5b fc ff ff       	call   801d66 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80210b:	83 ec 08             	sub    $0x8,%esp
  80210e:	ff 75 0c             	pushl  0xc(%ebp)
  802111:	ff 75 08             	pushl  0x8(%ebp)
  802114:	e8 1d 04 00 00       	call   802536 <sys_getSizeOfSharedObject>
  802119:	83 c4 10             	add    $0x10,%esp
  80211c:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(size == 0)
  80211f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802123:	75 0a                	jne    80212f <sget+0x2f>
			return NULL ;
  802125:	b8 00 00 00 00       	mov    $0x0,%eax
  80212a:	e9 83 00 00 00       	jmp    8021b2 <sget+0xb2>
		size=ROUNDUP(size,PAGE_SIZE);
  80212f:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802136:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802139:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80213c:	01 d0                	add    %edx,%eax
  80213e:	48                   	dec    %eax
  80213f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802142:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802145:	ba 00 00 00 00       	mov    $0x0,%edx
  80214a:	f7 75 f0             	divl   -0x10(%ebp)
  80214d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802150:	29 d0                	sub    %edx,%eax
  802152:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  802155:	e8 2d 06 00 00       	call   802787 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80215a:	85 c0                	test   %eax,%eax
  80215c:	74 4f                	je     8021ad <sget+0xad>
		{
			struct MemBlock * ff_block ;
				ff_block = alloc_block_FF(size);
  80215e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802161:	83 ec 0c             	sub    $0xc,%esp
  802164:	50                   	push   %eax
  802165:	e8 2e 0d 00 00       	call   802e98 <alloc_block_FF>
  80216a:	83 c4 10             	add    $0x10,%esp
  80216d:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ff_block==NULL)
  802170:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802174:	75 07                	jne    80217d <sget+0x7d>
					return (void*)NULL ;
  802176:	b8 00 00 00 00       	mov    $0x0,%eax
  80217b:	eb 35                	jmp    8021b2 <sget+0xb2>

		int obj_id =sys_getSharedObject((int)ownerEnvID,sharedVarName,(void*)ff_block->sva);
  80217d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802180:	8b 40 08             	mov    0x8(%eax),%eax
  802183:	83 ec 04             	sub    $0x4,%esp
  802186:	50                   	push   %eax
  802187:	ff 75 0c             	pushl  0xc(%ebp)
  80218a:	ff 75 08             	pushl  0x8(%ebp)
  80218d:	e8 c1 03 00 00       	call   802553 <sys_getSharedObject>
  802192:	83 c4 10             	add    $0x10,%esp
  802195:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if(obj_id<0)
  802198:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80219c:	79 07                	jns    8021a5 <sget+0xa5>
				return (void*)NULL ;
  80219e:	b8 00 00 00 00       	mov    $0x0,%eax
  8021a3:	eb 0d                	jmp    8021b2 <sget+0xb2>
			else
				return (void*)ff_block->sva ;
  8021a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021a8:	8b 40 08             	mov    0x8(%eax),%eax
  8021ab:	eb 05                	jmp    8021b2 <sget+0xb2>


		}
	return (void*)NULL ;
  8021ad:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8021b2:	c9                   	leave  
  8021b3:	c3                   	ret    

008021b4 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8021b4:	55                   	push   %ebp
  8021b5:	89 e5                	mov    %esp,%ebp
  8021b7:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8021ba:	e8 a7 fb ff ff       	call   801d66 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8021bf:	83 ec 04             	sub    $0x4,%esp
  8021c2:	68 60 45 80 00       	push   $0x804560
  8021c7:	68 f9 00 00 00       	push   $0xf9
  8021cc:	68 53 45 80 00       	push   $0x804553
  8021d1:	e8 52 eb ff ff       	call   800d28 <_panic>

008021d6 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8021d6:	55                   	push   %ebp
  8021d7:	89 e5                	mov    %esp,%ebp
  8021d9:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8021dc:	83 ec 04             	sub    $0x4,%esp
  8021df:	68 88 45 80 00       	push   $0x804588
  8021e4:	68 0d 01 00 00       	push   $0x10d
  8021e9:	68 53 45 80 00       	push   $0x804553
  8021ee:	e8 35 eb ff ff       	call   800d28 <_panic>

008021f3 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8021f3:	55                   	push   %ebp
  8021f4:	89 e5                	mov    %esp,%ebp
  8021f6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8021f9:	83 ec 04             	sub    $0x4,%esp
  8021fc:	68 ac 45 80 00       	push   $0x8045ac
  802201:	68 18 01 00 00       	push   $0x118
  802206:	68 53 45 80 00       	push   $0x804553
  80220b:	e8 18 eb ff ff       	call   800d28 <_panic>

00802210 <shrink>:

}
void shrink(uint32 newSize)
{
  802210:	55                   	push   %ebp
  802211:	89 e5                	mov    %esp,%ebp
  802213:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802216:	83 ec 04             	sub    $0x4,%esp
  802219:	68 ac 45 80 00       	push   $0x8045ac
  80221e:	68 1d 01 00 00       	push   $0x11d
  802223:	68 53 45 80 00       	push   $0x804553
  802228:	e8 fb ea ff ff       	call   800d28 <_panic>

0080222d <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80222d:	55                   	push   %ebp
  80222e:	89 e5                	mov    %esp,%ebp
  802230:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802233:	83 ec 04             	sub    $0x4,%esp
  802236:	68 ac 45 80 00       	push   $0x8045ac
  80223b:	68 22 01 00 00       	push   $0x122
  802240:	68 53 45 80 00       	push   $0x804553
  802245:	e8 de ea ff ff       	call   800d28 <_panic>

0080224a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80224a:	55                   	push   %ebp
  80224b:	89 e5                	mov    %esp,%ebp
  80224d:	57                   	push   %edi
  80224e:	56                   	push   %esi
  80224f:	53                   	push   %ebx
  802250:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802253:	8b 45 08             	mov    0x8(%ebp),%eax
  802256:	8b 55 0c             	mov    0xc(%ebp),%edx
  802259:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80225c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80225f:	8b 7d 18             	mov    0x18(%ebp),%edi
  802262:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802265:	cd 30                	int    $0x30
  802267:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80226a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80226d:	83 c4 10             	add    $0x10,%esp
  802270:	5b                   	pop    %ebx
  802271:	5e                   	pop    %esi
  802272:	5f                   	pop    %edi
  802273:	5d                   	pop    %ebp
  802274:	c3                   	ret    

00802275 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802275:	55                   	push   %ebp
  802276:	89 e5                	mov    %esp,%ebp
  802278:	83 ec 04             	sub    $0x4,%esp
  80227b:	8b 45 10             	mov    0x10(%ebp),%eax
  80227e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802281:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802285:	8b 45 08             	mov    0x8(%ebp),%eax
  802288:	6a 00                	push   $0x0
  80228a:	6a 00                	push   $0x0
  80228c:	52                   	push   %edx
  80228d:	ff 75 0c             	pushl  0xc(%ebp)
  802290:	50                   	push   %eax
  802291:	6a 00                	push   $0x0
  802293:	e8 b2 ff ff ff       	call   80224a <syscall>
  802298:	83 c4 18             	add    $0x18,%esp
}
  80229b:	90                   	nop
  80229c:	c9                   	leave  
  80229d:	c3                   	ret    

0080229e <sys_cgetc>:

int
sys_cgetc(void)
{
  80229e:	55                   	push   %ebp
  80229f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8022a1:	6a 00                	push   $0x0
  8022a3:	6a 00                	push   $0x0
  8022a5:	6a 00                	push   $0x0
  8022a7:	6a 00                	push   $0x0
  8022a9:	6a 00                	push   $0x0
  8022ab:	6a 01                	push   $0x1
  8022ad:	e8 98 ff ff ff       	call   80224a <syscall>
  8022b2:	83 c4 18             	add    $0x18,%esp
}
  8022b5:	c9                   	leave  
  8022b6:	c3                   	ret    

008022b7 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8022b7:	55                   	push   %ebp
  8022b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8022ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c0:	6a 00                	push   $0x0
  8022c2:	6a 00                	push   $0x0
  8022c4:	6a 00                	push   $0x0
  8022c6:	52                   	push   %edx
  8022c7:	50                   	push   %eax
  8022c8:	6a 05                	push   $0x5
  8022ca:	e8 7b ff ff ff       	call   80224a <syscall>
  8022cf:	83 c4 18             	add    $0x18,%esp
}
  8022d2:	c9                   	leave  
  8022d3:	c3                   	ret    

008022d4 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8022d4:	55                   	push   %ebp
  8022d5:	89 e5                	mov    %esp,%ebp
  8022d7:	56                   	push   %esi
  8022d8:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8022d9:	8b 75 18             	mov    0x18(%ebp),%esi
  8022dc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8022df:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e8:	56                   	push   %esi
  8022e9:	53                   	push   %ebx
  8022ea:	51                   	push   %ecx
  8022eb:	52                   	push   %edx
  8022ec:	50                   	push   %eax
  8022ed:	6a 06                	push   $0x6
  8022ef:	e8 56 ff ff ff       	call   80224a <syscall>
  8022f4:	83 c4 18             	add    $0x18,%esp
}
  8022f7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022fa:	5b                   	pop    %ebx
  8022fb:	5e                   	pop    %esi
  8022fc:	5d                   	pop    %ebp
  8022fd:	c3                   	ret    

008022fe <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8022fe:	55                   	push   %ebp
  8022ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802301:	8b 55 0c             	mov    0xc(%ebp),%edx
  802304:	8b 45 08             	mov    0x8(%ebp),%eax
  802307:	6a 00                	push   $0x0
  802309:	6a 00                	push   $0x0
  80230b:	6a 00                	push   $0x0
  80230d:	52                   	push   %edx
  80230e:	50                   	push   %eax
  80230f:	6a 07                	push   $0x7
  802311:	e8 34 ff ff ff       	call   80224a <syscall>
  802316:	83 c4 18             	add    $0x18,%esp
}
  802319:	c9                   	leave  
  80231a:	c3                   	ret    

0080231b <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80231b:	55                   	push   %ebp
  80231c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80231e:	6a 00                	push   $0x0
  802320:	6a 00                	push   $0x0
  802322:	6a 00                	push   $0x0
  802324:	ff 75 0c             	pushl  0xc(%ebp)
  802327:	ff 75 08             	pushl  0x8(%ebp)
  80232a:	6a 08                	push   $0x8
  80232c:	e8 19 ff ff ff       	call   80224a <syscall>
  802331:	83 c4 18             	add    $0x18,%esp
}
  802334:	c9                   	leave  
  802335:	c3                   	ret    

00802336 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802336:	55                   	push   %ebp
  802337:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802339:	6a 00                	push   $0x0
  80233b:	6a 00                	push   $0x0
  80233d:	6a 00                	push   $0x0
  80233f:	6a 00                	push   $0x0
  802341:	6a 00                	push   $0x0
  802343:	6a 09                	push   $0x9
  802345:	e8 00 ff ff ff       	call   80224a <syscall>
  80234a:	83 c4 18             	add    $0x18,%esp
}
  80234d:	c9                   	leave  
  80234e:	c3                   	ret    

0080234f <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80234f:	55                   	push   %ebp
  802350:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802352:	6a 00                	push   $0x0
  802354:	6a 00                	push   $0x0
  802356:	6a 00                	push   $0x0
  802358:	6a 00                	push   $0x0
  80235a:	6a 00                	push   $0x0
  80235c:	6a 0a                	push   $0xa
  80235e:	e8 e7 fe ff ff       	call   80224a <syscall>
  802363:	83 c4 18             	add    $0x18,%esp
}
  802366:	c9                   	leave  
  802367:	c3                   	ret    

00802368 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802368:	55                   	push   %ebp
  802369:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80236b:	6a 00                	push   $0x0
  80236d:	6a 00                	push   $0x0
  80236f:	6a 00                	push   $0x0
  802371:	6a 00                	push   $0x0
  802373:	6a 00                	push   $0x0
  802375:	6a 0b                	push   $0xb
  802377:	e8 ce fe ff ff       	call   80224a <syscall>
  80237c:	83 c4 18             	add    $0x18,%esp
}
  80237f:	c9                   	leave  
  802380:	c3                   	ret    

00802381 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802381:	55                   	push   %ebp
  802382:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802384:	6a 00                	push   $0x0
  802386:	6a 00                	push   $0x0
  802388:	6a 00                	push   $0x0
  80238a:	ff 75 0c             	pushl  0xc(%ebp)
  80238d:	ff 75 08             	pushl  0x8(%ebp)
  802390:	6a 0f                	push   $0xf
  802392:	e8 b3 fe ff ff       	call   80224a <syscall>
  802397:	83 c4 18             	add    $0x18,%esp
	return;
  80239a:	90                   	nop
}
  80239b:	c9                   	leave  
  80239c:	c3                   	ret    

0080239d <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80239d:	55                   	push   %ebp
  80239e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8023a0:	6a 00                	push   $0x0
  8023a2:	6a 00                	push   $0x0
  8023a4:	6a 00                	push   $0x0
  8023a6:	ff 75 0c             	pushl  0xc(%ebp)
  8023a9:	ff 75 08             	pushl  0x8(%ebp)
  8023ac:	6a 10                	push   $0x10
  8023ae:	e8 97 fe ff ff       	call   80224a <syscall>
  8023b3:	83 c4 18             	add    $0x18,%esp
	return ;
  8023b6:	90                   	nop
}
  8023b7:	c9                   	leave  
  8023b8:	c3                   	ret    

008023b9 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8023b9:	55                   	push   %ebp
  8023ba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8023bc:	6a 00                	push   $0x0
  8023be:	6a 00                	push   $0x0
  8023c0:	ff 75 10             	pushl  0x10(%ebp)
  8023c3:	ff 75 0c             	pushl  0xc(%ebp)
  8023c6:	ff 75 08             	pushl  0x8(%ebp)
  8023c9:	6a 11                	push   $0x11
  8023cb:	e8 7a fe ff ff       	call   80224a <syscall>
  8023d0:	83 c4 18             	add    $0x18,%esp
	return ;
  8023d3:	90                   	nop
}
  8023d4:	c9                   	leave  
  8023d5:	c3                   	ret    

008023d6 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8023d6:	55                   	push   %ebp
  8023d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8023d9:	6a 00                	push   $0x0
  8023db:	6a 00                	push   $0x0
  8023dd:	6a 00                	push   $0x0
  8023df:	6a 00                	push   $0x0
  8023e1:	6a 00                	push   $0x0
  8023e3:	6a 0c                	push   $0xc
  8023e5:	e8 60 fe ff ff       	call   80224a <syscall>
  8023ea:	83 c4 18             	add    $0x18,%esp
}
  8023ed:	c9                   	leave  
  8023ee:	c3                   	ret    

008023ef <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8023ef:	55                   	push   %ebp
  8023f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8023f2:	6a 00                	push   $0x0
  8023f4:	6a 00                	push   $0x0
  8023f6:	6a 00                	push   $0x0
  8023f8:	6a 00                	push   $0x0
  8023fa:	ff 75 08             	pushl  0x8(%ebp)
  8023fd:	6a 0d                	push   $0xd
  8023ff:	e8 46 fe ff ff       	call   80224a <syscall>
  802404:	83 c4 18             	add    $0x18,%esp
}
  802407:	c9                   	leave  
  802408:	c3                   	ret    

00802409 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802409:	55                   	push   %ebp
  80240a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80240c:	6a 00                	push   $0x0
  80240e:	6a 00                	push   $0x0
  802410:	6a 00                	push   $0x0
  802412:	6a 00                	push   $0x0
  802414:	6a 00                	push   $0x0
  802416:	6a 0e                	push   $0xe
  802418:	e8 2d fe ff ff       	call   80224a <syscall>
  80241d:	83 c4 18             	add    $0x18,%esp
}
  802420:	90                   	nop
  802421:	c9                   	leave  
  802422:	c3                   	ret    

00802423 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802423:	55                   	push   %ebp
  802424:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802426:	6a 00                	push   $0x0
  802428:	6a 00                	push   $0x0
  80242a:	6a 00                	push   $0x0
  80242c:	6a 00                	push   $0x0
  80242e:	6a 00                	push   $0x0
  802430:	6a 13                	push   $0x13
  802432:	e8 13 fe ff ff       	call   80224a <syscall>
  802437:	83 c4 18             	add    $0x18,%esp
}
  80243a:	90                   	nop
  80243b:	c9                   	leave  
  80243c:	c3                   	ret    

0080243d <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80243d:	55                   	push   %ebp
  80243e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802440:	6a 00                	push   $0x0
  802442:	6a 00                	push   $0x0
  802444:	6a 00                	push   $0x0
  802446:	6a 00                	push   $0x0
  802448:	6a 00                	push   $0x0
  80244a:	6a 14                	push   $0x14
  80244c:	e8 f9 fd ff ff       	call   80224a <syscall>
  802451:	83 c4 18             	add    $0x18,%esp
}
  802454:	90                   	nop
  802455:	c9                   	leave  
  802456:	c3                   	ret    

00802457 <sys_cputc>:


void
sys_cputc(const char c)
{
  802457:	55                   	push   %ebp
  802458:	89 e5                	mov    %esp,%ebp
  80245a:	83 ec 04             	sub    $0x4,%esp
  80245d:	8b 45 08             	mov    0x8(%ebp),%eax
  802460:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802463:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802467:	6a 00                	push   $0x0
  802469:	6a 00                	push   $0x0
  80246b:	6a 00                	push   $0x0
  80246d:	6a 00                	push   $0x0
  80246f:	50                   	push   %eax
  802470:	6a 15                	push   $0x15
  802472:	e8 d3 fd ff ff       	call   80224a <syscall>
  802477:	83 c4 18             	add    $0x18,%esp
}
  80247a:	90                   	nop
  80247b:	c9                   	leave  
  80247c:	c3                   	ret    

0080247d <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80247d:	55                   	push   %ebp
  80247e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802480:	6a 00                	push   $0x0
  802482:	6a 00                	push   $0x0
  802484:	6a 00                	push   $0x0
  802486:	6a 00                	push   $0x0
  802488:	6a 00                	push   $0x0
  80248a:	6a 16                	push   $0x16
  80248c:	e8 b9 fd ff ff       	call   80224a <syscall>
  802491:	83 c4 18             	add    $0x18,%esp
}
  802494:	90                   	nop
  802495:	c9                   	leave  
  802496:	c3                   	ret    

00802497 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802497:	55                   	push   %ebp
  802498:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80249a:	8b 45 08             	mov    0x8(%ebp),%eax
  80249d:	6a 00                	push   $0x0
  80249f:	6a 00                	push   $0x0
  8024a1:	6a 00                	push   $0x0
  8024a3:	ff 75 0c             	pushl  0xc(%ebp)
  8024a6:	50                   	push   %eax
  8024a7:	6a 17                	push   $0x17
  8024a9:	e8 9c fd ff ff       	call   80224a <syscall>
  8024ae:	83 c4 18             	add    $0x18,%esp
}
  8024b1:	c9                   	leave  
  8024b2:	c3                   	ret    

008024b3 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8024b3:	55                   	push   %ebp
  8024b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8024b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024bc:	6a 00                	push   $0x0
  8024be:	6a 00                	push   $0x0
  8024c0:	6a 00                	push   $0x0
  8024c2:	52                   	push   %edx
  8024c3:	50                   	push   %eax
  8024c4:	6a 1a                	push   $0x1a
  8024c6:	e8 7f fd ff ff       	call   80224a <syscall>
  8024cb:	83 c4 18             	add    $0x18,%esp
}
  8024ce:	c9                   	leave  
  8024cf:	c3                   	ret    

008024d0 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8024d0:	55                   	push   %ebp
  8024d1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8024d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d9:	6a 00                	push   $0x0
  8024db:	6a 00                	push   $0x0
  8024dd:	6a 00                	push   $0x0
  8024df:	52                   	push   %edx
  8024e0:	50                   	push   %eax
  8024e1:	6a 18                	push   $0x18
  8024e3:	e8 62 fd ff ff       	call   80224a <syscall>
  8024e8:	83 c4 18             	add    $0x18,%esp
}
  8024eb:	90                   	nop
  8024ec:	c9                   	leave  
  8024ed:	c3                   	ret    

008024ee <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8024ee:	55                   	push   %ebp
  8024ef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8024f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f7:	6a 00                	push   $0x0
  8024f9:	6a 00                	push   $0x0
  8024fb:	6a 00                	push   $0x0
  8024fd:	52                   	push   %edx
  8024fe:	50                   	push   %eax
  8024ff:	6a 19                	push   $0x19
  802501:	e8 44 fd ff ff       	call   80224a <syscall>
  802506:	83 c4 18             	add    $0x18,%esp
}
  802509:	90                   	nop
  80250a:	c9                   	leave  
  80250b:	c3                   	ret    

0080250c <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80250c:	55                   	push   %ebp
  80250d:	89 e5                	mov    %esp,%ebp
  80250f:	83 ec 04             	sub    $0x4,%esp
  802512:	8b 45 10             	mov    0x10(%ebp),%eax
  802515:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802518:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80251b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80251f:	8b 45 08             	mov    0x8(%ebp),%eax
  802522:	6a 00                	push   $0x0
  802524:	51                   	push   %ecx
  802525:	52                   	push   %edx
  802526:	ff 75 0c             	pushl  0xc(%ebp)
  802529:	50                   	push   %eax
  80252a:	6a 1b                	push   $0x1b
  80252c:	e8 19 fd ff ff       	call   80224a <syscall>
  802531:	83 c4 18             	add    $0x18,%esp
}
  802534:	c9                   	leave  
  802535:	c3                   	ret    

00802536 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802536:	55                   	push   %ebp
  802537:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802539:	8b 55 0c             	mov    0xc(%ebp),%edx
  80253c:	8b 45 08             	mov    0x8(%ebp),%eax
  80253f:	6a 00                	push   $0x0
  802541:	6a 00                	push   $0x0
  802543:	6a 00                	push   $0x0
  802545:	52                   	push   %edx
  802546:	50                   	push   %eax
  802547:	6a 1c                	push   $0x1c
  802549:	e8 fc fc ff ff       	call   80224a <syscall>
  80254e:	83 c4 18             	add    $0x18,%esp
}
  802551:	c9                   	leave  
  802552:	c3                   	ret    

00802553 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802553:	55                   	push   %ebp
  802554:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802556:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802559:	8b 55 0c             	mov    0xc(%ebp),%edx
  80255c:	8b 45 08             	mov    0x8(%ebp),%eax
  80255f:	6a 00                	push   $0x0
  802561:	6a 00                	push   $0x0
  802563:	51                   	push   %ecx
  802564:	52                   	push   %edx
  802565:	50                   	push   %eax
  802566:	6a 1d                	push   $0x1d
  802568:	e8 dd fc ff ff       	call   80224a <syscall>
  80256d:	83 c4 18             	add    $0x18,%esp
}
  802570:	c9                   	leave  
  802571:	c3                   	ret    

00802572 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802572:	55                   	push   %ebp
  802573:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802575:	8b 55 0c             	mov    0xc(%ebp),%edx
  802578:	8b 45 08             	mov    0x8(%ebp),%eax
  80257b:	6a 00                	push   $0x0
  80257d:	6a 00                	push   $0x0
  80257f:	6a 00                	push   $0x0
  802581:	52                   	push   %edx
  802582:	50                   	push   %eax
  802583:	6a 1e                	push   $0x1e
  802585:	e8 c0 fc ff ff       	call   80224a <syscall>
  80258a:	83 c4 18             	add    $0x18,%esp
}
  80258d:	c9                   	leave  
  80258e:	c3                   	ret    

0080258f <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80258f:	55                   	push   %ebp
  802590:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802592:	6a 00                	push   $0x0
  802594:	6a 00                	push   $0x0
  802596:	6a 00                	push   $0x0
  802598:	6a 00                	push   $0x0
  80259a:	6a 00                	push   $0x0
  80259c:	6a 1f                	push   $0x1f
  80259e:	e8 a7 fc ff ff       	call   80224a <syscall>
  8025a3:	83 c4 18             	add    $0x18,%esp
}
  8025a6:	c9                   	leave  
  8025a7:	c3                   	ret    

008025a8 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8025a8:	55                   	push   %ebp
  8025a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8025ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ae:	6a 00                	push   $0x0
  8025b0:	ff 75 14             	pushl  0x14(%ebp)
  8025b3:	ff 75 10             	pushl  0x10(%ebp)
  8025b6:	ff 75 0c             	pushl  0xc(%ebp)
  8025b9:	50                   	push   %eax
  8025ba:	6a 20                	push   $0x20
  8025bc:	e8 89 fc ff ff       	call   80224a <syscall>
  8025c1:	83 c4 18             	add    $0x18,%esp
}
  8025c4:	c9                   	leave  
  8025c5:	c3                   	ret    

008025c6 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8025c6:	55                   	push   %ebp
  8025c7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8025c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025cc:	6a 00                	push   $0x0
  8025ce:	6a 00                	push   $0x0
  8025d0:	6a 00                	push   $0x0
  8025d2:	6a 00                	push   $0x0
  8025d4:	50                   	push   %eax
  8025d5:	6a 21                	push   $0x21
  8025d7:	e8 6e fc ff ff       	call   80224a <syscall>
  8025dc:	83 c4 18             	add    $0x18,%esp
}
  8025df:	90                   	nop
  8025e0:	c9                   	leave  
  8025e1:	c3                   	ret    

008025e2 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8025e2:	55                   	push   %ebp
  8025e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8025e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e8:	6a 00                	push   $0x0
  8025ea:	6a 00                	push   $0x0
  8025ec:	6a 00                	push   $0x0
  8025ee:	6a 00                	push   $0x0
  8025f0:	50                   	push   %eax
  8025f1:	6a 22                	push   $0x22
  8025f3:	e8 52 fc ff ff       	call   80224a <syscall>
  8025f8:	83 c4 18             	add    $0x18,%esp
}
  8025fb:	c9                   	leave  
  8025fc:	c3                   	ret    

008025fd <sys_getenvid>:

int32 sys_getenvid(void)
{
  8025fd:	55                   	push   %ebp
  8025fe:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802600:	6a 00                	push   $0x0
  802602:	6a 00                	push   $0x0
  802604:	6a 00                	push   $0x0
  802606:	6a 00                	push   $0x0
  802608:	6a 00                	push   $0x0
  80260a:	6a 02                	push   $0x2
  80260c:	e8 39 fc ff ff       	call   80224a <syscall>
  802611:	83 c4 18             	add    $0x18,%esp
}
  802614:	c9                   	leave  
  802615:	c3                   	ret    

00802616 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802616:	55                   	push   %ebp
  802617:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802619:	6a 00                	push   $0x0
  80261b:	6a 00                	push   $0x0
  80261d:	6a 00                	push   $0x0
  80261f:	6a 00                	push   $0x0
  802621:	6a 00                	push   $0x0
  802623:	6a 03                	push   $0x3
  802625:	e8 20 fc ff ff       	call   80224a <syscall>
  80262a:	83 c4 18             	add    $0x18,%esp
}
  80262d:	c9                   	leave  
  80262e:	c3                   	ret    

0080262f <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80262f:	55                   	push   %ebp
  802630:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802632:	6a 00                	push   $0x0
  802634:	6a 00                	push   $0x0
  802636:	6a 00                	push   $0x0
  802638:	6a 00                	push   $0x0
  80263a:	6a 00                	push   $0x0
  80263c:	6a 04                	push   $0x4
  80263e:	e8 07 fc ff ff       	call   80224a <syscall>
  802643:	83 c4 18             	add    $0x18,%esp
}
  802646:	c9                   	leave  
  802647:	c3                   	ret    

00802648 <sys_exit_env>:


void sys_exit_env(void)
{
  802648:	55                   	push   %ebp
  802649:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80264b:	6a 00                	push   $0x0
  80264d:	6a 00                	push   $0x0
  80264f:	6a 00                	push   $0x0
  802651:	6a 00                	push   $0x0
  802653:	6a 00                	push   $0x0
  802655:	6a 23                	push   $0x23
  802657:	e8 ee fb ff ff       	call   80224a <syscall>
  80265c:	83 c4 18             	add    $0x18,%esp
}
  80265f:	90                   	nop
  802660:	c9                   	leave  
  802661:	c3                   	ret    

00802662 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802662:	55                   	push   %ebp
  802663:	89 e5                	mov    %esp,%ebp
  802665:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802668:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80266b:	8d 50 04             	lea    0x4(%eax),%edx
  80266e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802671:	6a 00                	push   $0x0
  802673:	6a 00                	push   $0x0
  802675:	6a 00                	push   $0x0
  802677:	52                   	push   %edx
  802678:	50                   	push   %eax
  802679:	6a 24                	push   $0x24
  80267b:	e8 ca fb ff ff       	call   80224a <syscall>
  802680:	83 c4 18             	add    $0x18,%esp
	return result;
  802683:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802686:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802689:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80268c:	89 01                	mov    %eax,(%ecx)
  80268e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802691:	8b 45 08             	mov    0x8(%ebp),%eax
  802694:	c9                   	leave  
  802695:	c2 04 00             	ret    $0x4

00802698 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802698:	55                   	push   %ebp
  802699:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80269b:	6a 00                	push   $0x0
  80269d:	6a 00                	push   $0x0
  80269f:	ff 75 10             	pushl  0x10(%ebp)
  8026a2:	ff 75 0c             	pushl  0xc(%ebp)
  8026a5:	ff 75 08             	pushl  0x8(%ebp)
  8026a8:	6a 12                	push   $0x12
  8026aa:	e8 9b fb ff ff       	call   80224a <syscall>
  8026af:	83 c4 18             	add    $0x18,%esp
	return ;
  8026b2:	90                   	nop
}
  8026b3:	c9                   	leave  
  8026b4:	c3                   	ret    

008026b5 <sys_rcr2>:
uint32 sys_rcr2()
{
  8026b5:	55                   	push   %ebp
  8026b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8026b8:	6a 00                	push   $0x0
  8026ba:	6a 00                	push   $0x0
  8026bc:	6a 00                	push   $0x0
  8026be:	6a 00                	push   $0x0
  8026c0:	6a 00                	push   $0x0
  8026c2:	6a 25                	push   $0x25
  8026c4:	e8 81 fb ff ff       	call   80224a <syscall>
  8026c9:	83 c4 18             	add    $0x18,%esp
}
  8026cc:	c9                   	leave  
  8026cd:	c3                   	ret    

008026ce <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8026ce:	55                   	push   %ebp
  8026cf:	89 e5                	mov    %esp,%ebp
  8026d1:	83 ec 04             	sub    $0x4,%esp
  8026d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8026da:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8026de:	6a 00                	push   $0x0
  8026e0:	6a 00                	push   $0x0
  8026e2:	6a 00                	push   $0x0
  8026e4:	6a 00                	push   $0x0
  8026e6:	50                   	push   %eax
  8026e7:	6a 26                	push   $0x26
  8026e9:	e8 5c fb ff ff       	call   80224a <syscall>
  8026ee:	83 c4 18             	add    $0x18,%esp
	return ;
  8026f1:	90                   	nop
}
  8026f2:	c9                   	leave  
  8026f3:	c3                   	ret    

008026f4 <rsttst>:
void rsttst()
{
  8026f4:	55                   	push   %ebp
  8026f5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8026f7:	6a 00                	push   $0x0
  8026f9:	6a 00                	push   $0x0
  8026fb:	6a 00                	push   $0x0
  8026fd:	6a 00                	push   $0x0
  8026ff:	6a 00                	push   $0x0
  802701:	6a 28                	push   $0x28
  802703:	e8 42 fb ff ff       	call   80224a <syscall>
  802708:	83 c4 18             	add    $0x18,%esp
	return ;
  80270b:	90                   	nop
}
  80270c:	c9                   	leave  
  80270d:	c3                   	ret    

0080270e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80270e:	55                   	push   %ebp
  80270f:	89 e5                	mov    %esp,%ebp
  802711:	83 ec 04             	sub    $0x4,%esp
  802714:	8b 45 14             	mov    0x14(%ebp),%eax
  802717:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80271a:	8b 55 18             	mov    0x18(%ebp),%edx
  80271d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802721:	52                   	push   %edx
  802722:	50                   	push   %eax
  802723:	ff 75 10             	pushl  0x10(%ebp)
  802726:	ff 75 0c             	pushl  0xc(%ebp)
  802729:	ff 75 08             	pushl  0x8(%ebp)
  80272c:	6a 27                	push   $0x27
  80272e:	e8 17 fb ff ff       	call   80224a <syscall>
  802733:	83 c4 18             	add    $0x18,%esp
	return ;
  802736:	90                   	nop
}
  802737:	c9                   	leave  
  802738:	c3                   	ret    

00802739 <chktst>:
void chktst(uint32 n)
{
  802739:	55                   	push   %ebp
  80273a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80273c:	6a 00                	push   $0x0
  80273e:	6a 00                	push   $0x0
  802740:	6a 00                	push   $0x0
  802742:	6a 00                	push   $0x0
  802744:	ff 75 08             	pushl  0x8(%ebp)
  802747:	6a 29                	push   $0x29
  802749:	e8 fc fa ff ff       	call   80224a <syscall>
  80274e:	83 c4 18             	add    $0x18,%esp
	return ;
  802751:	90                   	nop
}
  802752:	c9                   	leave  
  802753:	c3                   	ret    

00802754 <inctst>:

void inctst()
{
  802754:	55                   	push   %ebp
  802755:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802757:	6a 00                	push   $0x0
  802759:	6a 00                	push   $0x0
  80275b:	6a 00                	push   $0x0
  80275d:	6a 00                	push   $0x0
  80275f:	6a 00                	push   $0x0
  802761:	6a 2a                	push   $0x2a
  802763:	e8 e2 fa ff ff       	call   80224a <syscall>
  802768:	83 c4 18             	add    $0x18,%esp
	return ;
  80276b:	90                   	nop
}
  80276c:	c9                   	leave  
  80276d:	c3                   	ret    

0080276e <gettst>:
uint32 gettst()
{
  80276e:	55                   	push   %ebp
  80276f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802771:	6a 00                	push   $0x0
  802773:	6a 00                	push   $0x0
  802775:	6a 00                	push   $0x0
  802777:	6a 00                	push   $0x0
  802779:	6a 00                	push   $0x0
  80277b:	6a 2b                	push   $0x2b
  80277d:	e8 c8 fa ff ff       	call   80224a <syscall>
  802782:	83 c4 18             	add    $0x18,%esp
}
  802785:	c9                   	leave  
  802786:	c3                   	ret    

00802787 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802787:	55                   	push   %ebp
  802788:	89 e5                	mov    %esp,%ebp
  80278a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80278d:	6a 00                	push   $0x0
  80278f:	6a 00                	push   $0x0
  802791:	6a 00                	push   $0x0
  802793:	6a 00                	push   $0x0
  802795:	6a 00                	push   $0x0
  802797:	6a 2c                	push   $0x2c
  802799:	e8 ac fa ff ff       	call   80224a <syscall>
  80279e:	83 c4 18             	add    $0x18,%esp
  8027a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8027a4:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8027a8:	75 07                	jne    8027b1 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8027aa:	b8 01 00 00 00       	mov    $0x1,%eax
  8027af:	eb 05                	jmp    8027b6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8027b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027b6:	c9                   	leave  
  8027b7:	c3                   	ret    

008027b8 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8027b8:	55                   	push   %ebp
  8027b9:	89 e5                	mov    %esp,%ebp
  8027bb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8027be:	6a 00                	push   $0x0
  8027c0:	6a 00                	push   $0x0
  8027c2:	6a 00                	push   $0x0
  8027c4:	6a 00                	push   $0x0
  8027c6:	6a 00                	push   $0x0
  8027c8:	6a 2c                	push   $0x2c
  8027ca:	e8 7b fa ff ff       	call   80224a <syscall>
  8027cf:	83 c4 18             	add    $0x18,%esp
  8027d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8027d5:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8027d9:	75 07                	jne    8027e2 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8027db:	b8 01 00 00 00       	mov    $0x1,%eax
  8027e0:	eb 05                	jmp    8027e7 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8027e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027e7:	c9                   	leave  
  8027e8:	c3                   	ret    

008027e9 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8027e9:	55                   	push   %ebp
  8027ea:	89 e5                	mov    %esp,%ebp
  8027ec:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8027ef:	6a 00                	push   $0x0
  8027f1:	6a 00                	push   $0x0
  8027f3:	6a 00                	push   $0x0
  8027f5:	6a 00                	push   $0x0
  8027f7:	6a 00                	push   $0x0
  8027f9:	6a 2c                	push   $0x2c
  8027fb:	e8 4a fa ff ff       	call   80224a <syscall>
  802800:	83 c4 18             	add    $0x18,%esp
  802803:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802806:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80280a:	75 07                	jne    802813 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80280c:	b8 01 00 00 00       	mov    $0x1,%eax
  802811:	eb 05                	jmp    802818 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802813:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802818:	c9                   	leave  
  802819:	c3                   	ret    

0080281a <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80281a:	55                   	push   %ebp
  80281b:	89 e5                	mov    %esp,%ebp
  80281d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802820:	6a 00                	push   $0x0
  802822:	6a 00                	push   $0x0
  802824:	6a 00                	push   $0x0
  802826:	6a 00                	push   $0x0
  802828:	6a 00                	push   $0x0
  80282a:	6a 2c                	push   $0x2c
  80282c:	e8 19 fa ff ff       	call   80224a <syscall>
  802831:	83 c4 18             	add    $0x18,%esp
  802834:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802837:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80283b:	75 07                	jne    802844 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80283d:	b8 01 00 00 00       	mov    $0x1,%eax
  802842:	eb 05                	jmp    802849 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802844:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802849:	c9                   	leave  
  80284a:	c3                   	ret    

0080284b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80284b:	55                   	push   %ebp
  80284c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80284e:	6a 00                	push   $0x0
  802850:	6a 00                	push   $0x0
  802852:	6a 00                	push   $0x0
  802854:	6a 00                	push   $0x0
  802856:	ff 75 08             	pushl  0x8(%ebp)
  802859:	6a 2d                	push   $0x2d
  80285b:	e8 ea f9 ff ff       	call   80224a <syscall>
  802860:	83 c4 18             	add    $0x18,%esp
	return ;
  802863:	90                   	nop
}
  802864:	c9                   	leave  
  802865:	c3                   	ret    

00802866 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802866:	55                   	push   %ebp
  802867:	89 e5                	mov    %esp,%ebp
  802869:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80286a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80286d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802870:	8b 55 0c             	mov    0xc(%ebp),%edx
  802873:	8b 45 08             	mov    0x8(%ebp),%eax
  802876:	6a 00                	push   $0x0
  802878:	53                   	push   %ebx
  802879:	51                   	push   %ecx
  80287a:	52                   	push   %edx
  80287b:	50                   	push   %eax
  80287c:	6a 2e                	push   $0x2e
  80287e:	e8 c7 f9 ff ff       	call   80224a <syscall>
  802883:	83 c4 18             	add    $0x18,%esp
}
  802886:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802889:	c9                   	leave  
  80288a:	c3                   	ret    

0080288b <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80288b:	55                   	push   %ebp
  80288c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80288e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802891:	8b 45 08             	mov    0x8(%ebp),%eax
  802894:	6a 00                	push   $0x0
  802896:	6a 00                	push   $0x0
  802898:	6a 00                	push   $0x0
  80289a:	52                   	push   %edx
  80289b:	50                   	push   %eax
  80289c:	6a 2f                	push   $0x2f
  80289e:	e8 a7 f9 ff ff       	call   80224a <syscall>
  8028a3:	83 c4 18             	add    $0x18,%esp
}
  8028a6:	c9                   	leave  
  8028a7:	c3                   	ret    

008028a8 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8028a8:	55                   	push   %ebp
  8028a9:	89 e5                	mov    %esp,%ebp
  8028ab:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8028ae:	83 ec 0c             	sub    $0xc,%esp
  8028b1:	68 bc 45 80 00       	push   $0x8045bc
  8028b6:	e8 21 e7 ff ff       	call   800fdc <cprintf>
  8028bb:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8028be:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8028c5:	83 ec 0c             	sub    $0xc,%esp
  8028c8:	68 e8 45 80 00       	push   $0x8045e8
  8028cd:	e8 0a e7 ff ff       	call   800fdc <cprintf>
  8028d2:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8028d5:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8028d9:	a1 38 51 80 00       	mov    0x805138,%eax
  8028de:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028e1:	eb 56                	jmp    802939 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8028e3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028e7:	74 1c                	je     802905 <print_mem_block_lists+0x5d>
  8028e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ec:	8b 50 08             	mov    0x8(%eax),%edx
  8028ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f2:	8b 48 08             	mov    0x8(%eax),%ecx
  8028f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f8:	8b 40 0c             	mov    0xc(%eax),%eax
  8028fb:	01 c8                	add    %ecx,%eax
  8028fd:	39 c2                	cmp    %eax,%edx
  8028ff:	73 04                	jae    802905 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802901:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802905:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802908:	8b 50 08             	mov    0x8(%eax),%edx
  80290b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290e:	8b 40 0c             	mov    0xc(%eax),%eax
  802911:	01 c2                	add    %eax,%edx
  802913:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802916:	8b 40 08             	mov    0x8(%eax),%eax
  802919:	83 ec 04             	sub    $0x4,%esp
  80291c:	52                   	push   %edx
  80291d:	50                   	push   %eax
  80291e:	68 fd 45 80 00       	push   $0x8045fd
  802923:	e8 b4 e6 ff ff       	call   800fdc <cprintf>
  802928:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80292b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802931:	a1 40 51 80 00       	mov    0x805140,%eax
  802936:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802939:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80293d:	74 07                	je     802946 <print_mem_block_lists+0x9e>
  80293f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802942:	8b 00                	mov    (%eax),%eax
  802944:	eb 05                	jmp    80294b <print_mem_block_lists+0xa3>
  802946:	b8 00 00 00 00       	mov    $0x0,%eax
  80294b:	a3 40 51 80 00       	mov    %eax,0x805140
  802950:	a1 40 51 80 00       	mov    0x805140,%eax
  802955:	85 c0                	test   %eax,%eax
  802957:	75 8a                	jne    8028e3 <print_mem_block_lists+0x3b>
  802959:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80295d:	75 84                	jne    8028e3 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80295f:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802963:	75 10                	jne    802975 <print_mem_block_lists+0xcd>
  802965:	83 ec 0c             	sub    $0xc,%esp
  802968:	68 0c 46 80 00       	push   $0x80460c
  80296d:	e8 6a e6 ff ff       	call   800fdc <cprintf>
  802972:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802975:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80297c:	83 ec 0c             	sub    $0xc,%esp
  80297f:	68 30 46 80 00       	push   $0x804630
  802984:	e8 53 e6 ff ff       	call   800fdc <cprintf>
  802989:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80298c:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802990:	a1 40 50 80 00       	mov    0x805040,%eax
  802995:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802998:	eb 56                	jmp    8029f0 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80299a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80299e:	74 1c                	je     8029bc <print_mem_block_lists+0x114>
  8029a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a3:	8b 50 08             	mov    0x8(%eax),%edx
  8029a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a9:	8b 48 08             	mov    0x8(%eax),%ecx
  8029ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029af:	8b 40 0c             	mov    0xc(%eax),%eax
  8029b2:	01 c8                	add    %ecx,%eax
  8029b4:	39 c2                	cmp    %eax,%edx
  8029b6:	73 04                	jae    8029bc <print_mem_block_lists+0x114>
			sorted = 0 ;
  8029b8:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8029bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bf:	8b 50 08             	mov    0x8(%eax),%edx
  8029c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c5:	8b 40 0c             	mov    0xc(%eax),%eax
  8029c8:	01 c2                	add    %eax,%edx
  8029ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cd:	8b 40 08             	mov    0x8(%eax),%eax
  8029d0:	83 ec 04             	sub    $0x4,%esp
  8029d3:	52                   	push   %edx
  8029d4:	50                   	push   %eax
  8029d5:	68 fd 45 80 00       	push   $0x8045fd
  8029da:	e8 fd e5 ff ff       	call   800fdc <cprintf>
  8029df:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8029e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8029e8:	a1 48 50 80 00       	mov    0x805048,%eax
  8029ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029f4:	74 07                	je     8029fd <print_mem_block_lists+0x155>
  8029f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f9:	8b 00                	mov    (%eax),%eax
  8029fb:	eb 05                	jmp    802a02 <print_mem_block_lists+0x15a>
  8029fd:	b8 00 00 00 00       	mov    $0x0,%eax
  802a02:	a3 48 50 80 00       	mov    %eax,0x805048
  802a07:	a1 48 50 80 00       	mov    0x805048,%eax
  802a0c:	85 c0                	test   %eax,%eax
  802a0e:	75 8a                	jne    80299a <print_mem_block_lists+0xf2>
  802a10:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a14:	75 84                	jne    80299a <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802a16:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802a1a:	75 10                	jne    802a2c <print_mem_block_lists+0x184>
  802a1c:	83 ec 0c             	sub    $0xc,%esp
  802a1f:	68 48 46 80 00       	push   $0x804648
  802a24:	e8 b3 e5 ff ff       	call   800fdc <cprintf>
  802a29:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802a2c:	83 ec 0c             	sub    $0xc,%esp
  802a2f:	68 bc 45 80 00       	push   $0x8045bc
  802a34:	e8 a3 e5 ff ff       	call   800fdc <cprintf>
  802a39:	83 c4 10             	add    $0x10,%esp

}
  802a3c:	90                   	nop
  802a3d:	c9                   	leave  
  802a3e:	c3                   	ret    

00802a3f <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802a3f:	55                   	push   %ebp
  802a40:	89 e5                	mov    %esp,%ebp
  802a42:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  802a45:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802a4c:	00 00 00 
  802a4f:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802a56:	00 00 00 
  802a59:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802a60:	00 00 00 
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  802a63:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802a6a:	e9 9e 00 00 00       	jmp    802b0d <initialize_MemBlocksList+0xce>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
  802a6f:	a1 50 50 80 00       	mov    0x805050,%eax
  802a74:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a77:	c1 e2 04             	shl    $0x4,%edx
  802a7a:	01 d0                	add    %edx,%eax
  802a7c:	85 c0                	test   %eax,%eax
  802a7e:	75 14                	jne    802a94 <initialize_MemBlocksList+0x55>
  802a80:	83 ec 04             	sub    $0x4,%esp
  802a83:	68 70 46 80 00       	push   $0x804670
  802a88:	6a 43                	push   $0x43
  802a8a:	68 93 46 80 00       	push   $0x804693
  802a8f:	e8 94 e2 ff ff       	call   800d28 <_panic>
  802a94:	a1 50 50 80 00       	mov    0x805050,%eax
  802a99:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a9c:	c1 e2 04             	shl    $0x4,%edx
  802a9f:	01 d0                	add    %edx,%eax
  802aa1:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802aa7:	89 10                	mov    %edx,(%eax)
  802aa9:	8b 00                	mov    (%eax),%eax
  802aab:	85 c0                	test   %eax,%eax
  802aad:	74 18                	je     802ac7 <initialize_MemBlocksList+0x88>
  802aaf:	a1 48 51 80 00       	mov    0x805148,%eax
  802ab4:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802aba:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802abd:	c1 e1 04             	shl    $0x4,%ecx
  802ac0:	01 ca                	add    %ecx,%edx
  802ac2:	89 50 04             	mov    %edx,0x4(%eax)
  802ac5:	eb 12                	jmp    802ad9 <initialize_MemBlocksList+0x9a>
  802ac7:	a1 50 50 80 00       	mov    0x805050,%eax
  802acc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802acf:	c1 e2 04             	shl    $0x4,%edx
  802ad2:	01 d0                	add    %edx,%eax
  802ad4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ad9:	a1 50 50 80 00       	mov    0x805050,%eax
  802ade:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ae1:	c1 e2 04             	shl    $0x4,%edx
  802ae4:	01 d0                	add    %edx,%eax
  802ae6:	a3 48 51 80 00       	mov    %eax,0x805148
  802aeb:	a1 50 50 80 00       	mov    0x805050,%eax
  802af0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802af3:	c1 e2 04             	shl    $0x4,%edx
  802af6:	01 d0                	add    %edx,%eax
  802af8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aff:	a1 54 51 80 00       	mov    0x805154,%eax
  802b04:	40                   	inc    %eax
  802b05:	a3 54 51 80 00       	mov    %eax,0x805154
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  802b0a:	ff 45 f4             	incl   -0xc(%ebp)
  802b0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b10:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b13:	0f 82 56 ff ff ff    	jb     802a6f <initialize_MemBlocksList+0x30>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
		}
}
  802b19:	90                   	nop
  802b1a:	c9                   	leave  
  802b1b:	c3                   	ret    

00802b1c <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802b1c:	55                   	push   %ebp
  802b1d:	89 e5                	mov    %esp,%ebp
  802b1f:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  802b22:	a1 38 51 80 00       	mov    0x805138,%eax
  802b27:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802b2a:	eb 18                	jmp    802b44 <find_block+0x28>
	{
		if (ele->sva==va)
  802b2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802b2f:	8b 40 08             	mov    0x8(%eax),%eax
  802b32:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802b35:	75 05                	jne    802b3c <find_block+0x20>
			return ele;
  802b37:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802b3a:	eb 7b                	jmp    802bb7 <find_block+0x9b>
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  802b3c:	a1 40 51 80 00       	mov    0x805140,%eax
  802b41:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802b44:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802b48:	74 07                	je     802b51 <find_block+0x35>
  802b4a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802b4d:	8b 00                	mov    (%eax),%eax
  802b4f:	eb 05                	jmp    802b56 <find_block+0x3a>
  802b51:	b8 00 00 00 00       	mov    $0x0,%eax
  802b56:	a3 40 51 80 00       	mov    %eax,0x805140
  802b5b:	a1 40 51 80 00       	mov    0x805140,%eax
  802b60:	85 c0                	test   %eax,%eax
  802b62:	75 c8                	jne    802b2c <find_block+0x10>
  802b64:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802b68:	75 c2                	jne    802b2c <find_block+0x10>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  802b6a:	a1 40 50 80 00       	mov    0x805040,%eax
  802b6f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802b72:	eb 18                	jmp    802b8c <find_block+0x70>
	{
		if (ele->sva==va)
  802b74:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802b77:	8b 40 08             	mov    0x8(%eax),%eax
  802b7a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802b7d:	75 05                	jne    802b84 <find_block+0x68>
					return ele;
  802b7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802b82:	eb 33                	jmp    802bb7 <find_block+0x9b>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  802b84:	a1 48 50 80 00       	mov    0x805048,%eax
  802b89:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802b8c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802b90:	74 07                	je     802b99 <find_block+0x7d>
  802b92:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802b95:	8b 00                	mov    (%eax),%eax
  802b97:	eb 05                	jmp    802b9e <find_block+0x82>
  802b99:	b8 00 00 00 00       	mov    $0x0,%eax
  802b9e:	a3 48 50 80 00       	mov    %eax,0x805048
  802ba3:	a1 48 50 80 00       	mov    0x805048,%eax
  802ba8:	85 c0                	test   %eax,%eax
  802baa:	75 c8                	jne    802b74 <find_block+0x58>
  802bac:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802bb0:	75 c2                	jne    802b74 <find_block+0x58>
	{
		if (ele->sva==va)
					return ele;
	}
return NULL;
  802bb2:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802bb7:	c9                   	leave  
  802bb8:	c3                   	ret    

00802bb9 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802bb9:	55                   	push   %ebp
  802bba:	89 e5                	mov    %esp,%ebp
  802bbc:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;

int x =LIST_SIZE(&AllocMemBlocksList);
  802bbf:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802bc4:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((x==0))
  802bc7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bcb:	75 62                	jne    802c2f <insert_sorted_allocList+0x76>
	{
	//	blockToInsert=AllocMemBlocksList.lh_first;
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  802bcd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bd1:	75 14                	jne    802be7 <insert_sorted_allocList+0x2e>
  802bd3:	83 ec 04             	sub    $0x4,%esp
  802bd6:	68 70 46 80 00       	push   $0x804670
  802bdb:	6a 69                	push   $0x69
  802bdd:	68 93 46 80 00       	push   $0x804693
  802be2:	e8 41 e1 ff ff       	call   800d28 <_panic>
  802be7:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802bed:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf0:	89 10                	mov    %edx,(%eax)
  802bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf5:	8b 00                	mov    (%eax),%eax
  802bf7:	85 c0                	test   %eax,%eax
  802bf9:	74 0d                	je     802c08 <insert_sorted_allocList+0x4f>
  802bfb:	a1 40 50 80 00       	mov    0x805040,%eax
  802c00:	8b 55 08             	mov    0x8(%ebp),%edx
  802c03:	89 50 04             	mov    %edx,0x4(%eax)
  802c06:	eb 08                	jmp    802c10 <insert_sorted_allocList+0x57>
  802c08:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0b:	a3 44 50 80 00       	mov    %eax,0x805044
  802c10:	8b 45 08             	mov    0x8(%ebp),%eax
  802c13:	a3 40 50 80 00       	mov    %eax,0x805040
  802c18:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c22:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802c27:	40                   	inc    %eax
  802c28:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802c2d:	eb 72                	jmp    802ca1 <insert_sorted_allocList+0xe8>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
  802c2f:	a1 40 50 80 00       	mov    0x805040,%eax
  802c34:	8b 50 08             	mov    0x8(%eax),%edx
  802c37:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3a:	8b 40 08             	mov    0x8(%eax),%eax
  802c3d:	39 c2                	cmp    %eax,%edx
  802c3f:	76 60                	jbe    802ca1 <insert_sorted_allocList+0xe8>
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  802c41:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c45:	75 14                	jne    802c5b <insert_sorted_allocList+0xa2>
  802c47:	83 ec 04             	sub    $0x4,%esp
  802c4a:	68 70 46 80 00       	push   $0x804670
  802c4f:	6a 6d                	push   $0x6d
  802c51:	68 93 46 80 00       	push   $0x804693
  802c56:	e8 cd e0 ff ff       	call   800d28 <_panic>
  802c5b:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802c61:	8b 45 08             	mov    0x8(%ebp),%eax
  802c64:	89 10                	mov    %edx,(%eax)
  802c66:	8b 45 08             	mov    0x8(%ebp),%eax
  802c69:	8b 00                	mov    (%eax),%eax
  802c6b:	85 c0                	test   %eax,%eax
  802c6d:	74 0d                	je     802c7c <insert_sorted_allocList+0xc3>
  802c6f:	a1 40 50 80 00       	mov    0x805040,%eax
  802c74:	8b 55 08             	mov    0x8(%ebp),%edx
  802c77:	89 50 04             	mov    %edx,0x4(%eax)
  802c7a:	eb 08                	jmp    802c84 <insert_sorted_allocList+0xcb>
  802c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7f:	a3 44 50 80 00       	mov    %eax,0x805044
  802c84:	8b 45 08             	mov    0x8(%ebp),%eax
  802c87:	a3 40 50 80 00       	mov    %eax,0x805040
  802c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c96:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802c9b:	40                   	inc    %eax
  802c9c:	a3 4c 50 80 00       	mov    %eax,0x80504c
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  802ca1:	a1 40 50 80 00       	mov    0x805040,%eax
  802ca6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ca9:	e9 b9 01 00 00       	jmp    802e67 <insert_sorted_allocList+0x2ae>
	{


		if ((blockToInsert->sva>AllocMemBlocksList.lh_first->sva)&&blockToInsert->sva<element->sva)
  802cae:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb1:	8b 50 08             	mov    0x8(%eax),%edx
  802cb4:	a1 40 50 80 00       	mov    0x805040,%eax
  802cb9:	8b 40 08             	mov    0x8(%eax),%eax
  802cbc:	39 c2                	cmp    %eax,%edx
  802cbe:	76 7c                	jbe    802d3c <insert_sorted_allocList+0x183>
  802cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc3:	8b 50 08             	mov    0x8(%eax),%edx
  802cc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc9:	8b 40 08             	mov    0x8(%eax),%eax
  802ccc:	39 c2                	cmp    %eax,%edx
  802cce:	73 6c                	jae    802d3c <insert_sorted_allocList+0x183>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,element,blockToInsert);
  802cd0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cd4:	74 06                	je     802cdc <insert_sorted_allocList+0x123>
  802cd6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cda:	75 14                	jne    802cf0 <insert_sorted_allocList+0x137>
  802cdc:	83 ec 04             	sub    $0x4,%esp
  802cdf:	68 ac 46 80 00       	push   $0x8046ac
  802ce4:	6a 75                	push   $0x75
  802ce6:	68 93 46 80 00       	push   $0x804693
  802ceb:	e8 38 e0 ff ff       	call   800d28 <_panic>
  802cf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf3:	8b 50 04             	mov    0x4(%eax),%edx
  802cf6:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf9:	89 50 04             	mov    %edx,0x4(%eax)
  802cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  802cff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d02:	89 10                	mov    %edx,(%eax)
  802d04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d07:	8b 40 04             	mov    0x4(%eax),%eax
  802d0a:	85 c0                	test   %eax,%eax
  802d0c:	74 0d                	je     802d1b <insert_sorted_allocList+0x162>
  802d0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d11:	8b 40 04             	mov    0x4(%eax),%eax
  802d14:	8b 55 08             	mov    0x8(%ebp),%edx
  802d17:	89 10                	mov    %edx,(%eax)
  802d19:	eb 08                	jmp    802d23 <insert_sorted_allocList+0x16a>
  802d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1e:	a3 40 50 80 00       	mov    %eax,0x805040
  802d23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d26:	8b 55 08             	mov    0x8(%ebp),%edx
  802d29:	89 50 04             	mov    %edx,0x4(%eax)
  802d2c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802d31:	40                   	inc    %eax
  802d32:	a3 4c 50 80 00       	mov    %eax,0x80504c

		break;}
  802d37:	e9 59 01 00 00       	jmp    802e95 <insert_sorted_allocList+0x2dc>

	else if ((blockToInsert->sva>element->sva)&&(blockToInsert->sva<AllocMemBlocksList.lh_last->sva)&&blockToInsert->sva<LIST_NEXT(element)->sva)
  802d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3f:	8b 50 08             	mov    0x8(%eax),%edx
  802d42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d45:	8b 40 08             	mov    0x8(%eax),%eax
  802d48:	39 c2                	cmp    %eax,%edx
  802d4a:	0f 86 98 00 00 00    	jbe    802de8 <insert_sorted_allocList+0x22f>
  802d50:	8b 45 08             	mov    0x8(%ebp),%eax
  802d53:	8b 50 08             	mov    0x8(%eax),%edx
  802d56:	a1 44 50 80 00       	mov    0x805044,%eax
  802d5b:	8b 40 08             	mov    0x8(%eax),%eax
  802d5e:	39 c2                	cmp    %eax,%edx
  802d60:	0f 83 82 00 00 00    	jae    802de8 <insert_sorted_allocList+0x22f>
  802d66:	8b 45 08             	mov    0x8(%ebp),%eax
  802d69:	8b 50 08             	mov    0x8(%eax),%edx
  802d6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6f:	8b 00                	mov    (%eax),%eax
  802d71:	8b 40 08             	mov    0x8(%eax),%eax
  802d74:	39 c2                	cmp    %eax,%edx
  802d76:	73 70                	jae    802de8 <insert_sorted_allocList+0x22f>
	{

	LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  802d78:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d7c:	74 06                	je     802d84 <insert_sorted_allocList+0x1cb>
  802d7e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d82:	75 14                	jne    802d98 <insert_sorted_allocList+0x1df>
  802d84:	83 ec 04             	sub    $0x4,%esp
  802d87:	68 e4 46 80 00       	push   $0x8046e4
  802d8c:	6a 7c                	push   $0x7c
  802d8e:	68 93 46 80 00       	push   $0x804693
  802d93:	e8 90 df ff ff       	call   800d28 <_panic>
  802d98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9b:	8b 10                	mov    (%eax),%edx
  802d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802da0:	89 10                	mov    %edx,(%eax)
  802da2:	8b 45 08             	mov    0x8(%ebp),%eax
  802da5:	8b 00                	mov    (%eax),%eax
  802da7:	85 c0                	test   %eax,%eax
  802da9:	74 0b                	je     802db6 <insert_sorted_allocList+0x1fd>
  802dab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dae:	8b 00                	mov    (%eax),%eax
  802db0:	8b 55 08             	mov    0x8(%ebp),%edx
  802db3:	89 50 04             	mov    %edx,0x4(%eax)
  802db6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db9:	8b 55 08             	mov    0x8(%ebp),%edx
  802dbc:	89 10                	mov    %edx,(%eax)
  802dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dc4:	89 50 04             	mov    %edx,0x4(%eax)
  802dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dca:	8b 00                	mov    (%eax),%eax
  802dcc:	85 c0                	test   %eax,%eax
  802dce:	75 08                	jne    802dd8 <insert_sorted_allocList+0x21f>
  802dd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd3:	a3 44 50 80 00       	mov    %eax,0x805044
  802dd8:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802ddd:	40                   	inc    %eax
  802dde:	a3 4c 50 80 00       	mov    %eax,0x80504c
		break;
  802de3:	e9 ad 00 00 00       	jmp    802e95 <insert_sorted_allocList+0x2dc>
	}else if (blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  802de8:	8b 45 08             	mov    0x8(%ebp),%eax
  802deb:	8b 50 08             	mov    0x8(%eax),%edx
  802dee:	a1 44 50 80 00       	mov    0x805044,%eax
  802df3:	8b 40 08             	mov    0x8(%eax),%eax
  802df6:	39 c2                	cmp    %eax,%edx
  802df8:	76 65                	jbe    802e5f <insert_sorted_allocList+0x2a6>
	{
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
  802dfa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dfe:	75 17                	jne    802e17 <insert_sorted_allocList+0x25e>
  802e00:	83 ec 04             	sub    $0x4,%esp
  802e03:	68 18 47 80 00       	push   $0x804718
  802e08:	68 80 00 00 00       	push   $0x80
  802e0d:	68 93 46 80 00       	push   $0x804693
  802e12:	e8 11 df ff ff       	call   800d28 <_panic>
  802e17:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e20:	89 50 04             	mov    %edx,0x4(%eax)
  802e23:	8b 45 08             	mov    0x8(%ebp),%eax
  802e26:	8b 40 04             	mov    0x4(%eax),%eax
  802e29:	85 c0                	test   %eax,%eax
  802e2b:	74 0c                	je     802e39 <insert_sorted_allocList+0x280>
  802e2d:	a1 44 50 80 00       	mov    0x805044,%eax
  802e32:	8b 55 08             	mov    0x8(%ebp),%edx
  802e35:	89 10                	mov    %edx,(%eax)
  802e37:	eb 08                	jmp    802e41 <insert_sorted_allocList+0x288>
  802e39:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3c:	a3 40 50 80 00       	mov    %eax,0x805040
  802e41:	8b 45 08             	mov    0x8(%ebp),%eax
  802e44:	a3 44 50 80 00       	mov    %eax,0x805044
  802e49:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e52:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802e57:	40                   	inc    %eax
  802e58:	a3 4c 50 80 00       	mov    %eax,0x80504c
		break;
  802e5d:	eb 36                	jmp    802e95 <insert_sorted_allocList+0x2dc>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  802e5f:	a1 48 50 80 00       	mov    0x805048,%eax
  802e64:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e67:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e6b:	74 07                	je     802e74 <insert_sorted_allocList+0x2bb>
  802e6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e70:	8b 00                	mov    (%eax),%eax
  802e72:	eb 05                	jmp    802e79 <insert_sorted_allocList+0x2c0>
  802e74:	b8 00 00 00 00       	mov    $0x0,%eax
  802e79:	a3 48 50 80 00       	mov    %eax,0x805048
  802e7e:	a1 48 50 80 00       	mov    0x805048,%eax
  802e83:	85 c0                	test   %eax,%eax
  802e85:	0f 85 23 fe ff ff    	jne    802cae <insert_sorted_allocList+0xf5>
  802e8b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e8f:	0f 85 19 fe ff ff    	jne    802cae <insert_sorted_allocList+0xf5>
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
		break;

	}
	}
}
  802e95:	90                   	nop
  802e96:	c9                   	leave  
  802e97:	c3                   	ret    

00802e98 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802e98:	55                   	push   %ebp
  802e99:	89 e5                	mov    %esp,%ebp
  802e9b:	83 ec 18             	sub    $0x18,%esp
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802e9e:	a1 38 51 80 00       	mov    0x805138,%eax
  802ea3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ea6:	e9 7c 01 00 00       	jmp    803027 <alloc_block_FF+0x18f>
		{
			// case 2
				if(element->size == size)
  802eab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eae:	8b 40 0c             	mov    0xc(%eax),%eax
  802eb1:	3b 45 08             	cmp    0x8(%ebp),%eax
  802eb4:	0f 85 90 00 00 00    	jne    802f4a <alloc_block_FF+0xb2>
				{
					tmp_block=element;
  802eba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebd:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,element);
  802ec0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ec4:	75 17                	jne    802edd <alloc_block_FF+0x45>
  802ec6:	83 ec 04             	sub    $0x4,%esp
  802ec9:	68 3b 47 80 00       	push   $0x80473b
  802ece:	68 ba 00 00 00       	push   $0xba
  802ed3:	68 93 46 80 00       	push   $0x804693
  802ed8:	e8 4b de ff ff       	call   800d28 <_panic>
  802edd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee0:	8b 00                	mov    (%eax),%eax
  802ee2:	85 c0                	test   %eax,%eax
  802ee4:	74 10                	je     802ef6 <alloc_block_FF+0x5e>
  802ee6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee9:	8b 00                	mov    (%eax),%eax
  802eeb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802eee:	8b 52 04             	mov    0x4(%edx),%edx
  802ef1:	89 50 04             	mov    %edx,0x4(%eax)
  802ef4:	eb 0b                	jmp    802f01 <alloc_block_FF+0x69>
  802ef6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef9:	8b 40 04             	mov    0x4(%eax),%eax
  802efc:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f04:	8b 40 04             	mov    0x4(%eax),%eax
  802f07:	85 c0                	test   %eax,%eax
  802f09:	74 0f                	je     802f1a <alloc_block_FF+0x82>
  802f0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0e:	8b 40 04             	mov    0x4(%eax),%eax
  802f11:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f14:	8b 12                	mov    (%edx),%edx
  802f16:	89 10                	mov    %edx,(%eax)
  802f18:	eb 0a                	jmp    802f24 <alloc_block_FF+0x8c>
  802f1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1d:	8b 00                	mov    (%eax),%eax
  802f1f:	a3 38 51 80 00       	mov    %eax,0x805138
  802f24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f27:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f30:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f37:	a1 44 51 80 00       	mov    0x805144,%eax
  802f3c:	48                   	dec    %eax
  802f3d:	a3 44 51 80 00       	mov    %eax,0x805144
					return tmp_block;
  802f42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f45:	e9 10 01 00 00       	jmp    80305a <alloc_block_FF+0x1c2>
				}
				 // case 3
				else if(element->size > size)
  802f4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4d:	8b 40 0c             	mov    0xc(%eax),%eax
  802f50:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f53:	0f 86 c6 00 00 00    	jbe    80301f <alloc_block_FF+0x187>
				{
					// the new block are created
					tmp_block = AvailableMemBlocksList.lh_first ;
  802f59:	a1 48 51 80 00       	mov    0x805148,%eax
  802f5e:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  802f61:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f65:	75 17                	jne    802f7e <alloc_block_FF+0xe6>
  802f67:	83 ec 04             	sub    $0x4,%esp
  802f6a:	68 3b 47 80 00       	push   $0x80473b
  802f6f:	68 c2 00 00 00       	push   $0xc2
  802f74:	68 93 46 80 00       	push   $0x804693
  802f79:	e8 aa dd ff ff       	call   800d28 <_panic>
  802f7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f81:	8b 00                	mov    (%eax),%eax
  802f83:	85 c0                	test   %eax,%eax
  802f85:	74 10                	je     802f97 <alloc_block_FF+0xff>
  802f87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f8a:	8b 00                	mov    (%eax),%eax
  802f8c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f8f:	8b 52 04             	mov    0x4(%edx),%edx
  802f92:	89 50 04             	mov    %edx,0x4(%eax)
  802f95:	eb 0b                	jmp    802fa2 <alloc_block_FF+0x10a>
  802f97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f9a:	8b 40 04             	mov    0x4(%eax),%eax
  802f9d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fa2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fa5:	8b 40 04             	mov    0x4(%eax),%eax
  802fa8:	85 c0                	test   %eax,%eax
  802faa:	74 0f                	je     802fbb <alloc_block_FF+0x123>
  802fac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802faf:	8b 40 04             	mov    0x4(%eax),%eax
  802fb2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fb5:	8b 12                	mov    (%edx),%edx
  802fb7:	89 10                	mov    %edx,(%eax)
  802fb9:	eb 0a                	jmp    802fc5 <alloc_block_FF+0x12d>
  802fbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fbe:	8b 00                	mov    (%eax),%eax
  802fc0:	a3 48 51 80 00       	mov    %eax,0x805148
  802fc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fc8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fd1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fd8:	a1 54 51 80 00       	mov    0x805154,%eax
  802fdd:	48                   	dec    %eax
  802fde:	a3 54 51 80 00       	mov    %eax,0x805154
					tmp_block->sva=element->sva;
  802fe3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe6:	8b 50 08             	mov    0x8(%eax),%edx
  802fe9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fec:	89 50 08             	mov    %edx,0x8(%eax)
					tmp_block->size=size;
  802fef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ff2:	8b 55 08             	mov    0x8(%ebp),%edx
  802ff5:	89 50 0c             	mov    %edx,0xc(%eax)
					//update block with remaining space
					element->size-=size;
  802ff8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ffb:	8b 40 0c             	mov    0xc(%eax),%eax
  802ffe:	2b 45 08             	sub    0x8(%ebp),%eax
  803001:	89 c2                	mov    %eax,%edx
  803003:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803006:	89 50 0c             	mov    %edx,0xc(%eax)
					element->sva = element->sva + size;
  803009:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300c:	8b 50 08             	mov    0x8(%eax),%edx
  80300f:	8b 45 08             	mov    0x8(%ebp),%eax
  803012:	01 c2                	add    %eax,%edx
  803014:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803017:	89 50 08             	mov    %edx,0x8(%eax)
					// return back the new block
					return tmp_block ;
  80301a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80301d:	eb 3b                	jmp    80305a <alloc_block_FF+0x1c2>
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  80301f:	a1 40 51 80 00       	mov    0x805140,%eax
  803024:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803027:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80302b:	74 07                	je     803034 <alloc_block_FF+0x19c>
  80302d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803030:	8b 00                	mov    (%eax),%eax
  803032:	eb 05                	jmp    803039 <alloc_block_FF+0x1a1>
  803034:	b8 00 00 00 00       	mov    $0x0,%eax
  803039:	a3 40 51 80 00       	mov    %eax,0x805140
  80303e:	a1 40 51 80 00       	mov    0x805140,%eax
  803043:	85 c0                	test   %eax,%eax
  803045:	0f 85 60 fe ff ff    	jne    802eab <alloc_block_FF+0x13>
  80304b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80304f:	0f 85 56 fe ff ff    	jne    802eab <alloc_block_FF+0x13>
					// return back the new block
					return tmp_block ;
				}
		}
		// case 1
	  return NULL ;}
  803055:	b8 00 00 00 00       	mov    $0x0,%eax
  80305a:	c9                   	leave  
  80305b:	c3                   	ret    

0080305c <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================

struct MemBlock *alloc_block_BF(uint32 size)
{
  80305c:	55                   	push   %ebp
  80305d:	89 e5                	mov    %esp,%ebp
  80305f:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
  803062:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		LIST_FOREACH(element, &(FreeMemBlocksList))
  803069:	a1 38 51 80 00       	mov    0x805138,%eax
  80306e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803071:	eb 3a                	jmp    8030ad <alloc_block_BF+0x51>
		{
			if(element->size >= size)
  803073:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803076:	8b 40 0c             	mov    0xc(%eax),%eax
  803079:	3b 45 08             	cmp    0x8(%ebp),%eax
  80307c:	72 27                	jb     8030a5 <alloc_block_BF+0x49>
			{
				if(best_size==-1)
  80307e:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  803082:	75 0b                	jne    80308f <alloc_block_BF+0x33>
					best_size= element->size;
  803084:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803087:	8b 40 0c             	mov    0xc(%eax),%eax
  80308a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80308d:	eb 16                	jmp    8030a5 <alloc_block_BF+0x49>
				else if(best_size >= element->size)
  80308f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803092:	8b 50 0c             	mov    0xc(%eax),%edx
  803095:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803098:	39 c2                	cmp    %eax,%edx
  80309a:	77 09                	ja     8030a5 <alloc_block_BF+0x49>
					best_size=element->size;
  80309c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309f:	8b 40 0c             	mov    0xc(%eax),%eax
  8030a2:	89 45 f0             	mov    %eax,-0x10(%ebp)

struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  8030a5:	a1 40 51 80 00       	mov    0x805140,%eax
  8030aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030b1:	74 07                	je     8030ba <alloc_block_BF+0x5e>
  8030b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b6:	8b 00                	mov    (%eax),%eax
  8030b8:	eb 05                	jmp    8030bf <alloc_block_BF+0x63>
  8030ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8030bf:	a3 40 51 80 00       	mov    %eax,0x805140
  8030c4:	a1 40 51 80 00       	mov    0x805140,%eax
  8030c9:	85 c0                	test   %eax,%eax
  8030cb:	75 a6                	jne    803073 <alloc_block_BF+0x17>
  8030cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030d1:	75 a0                	jne    803073 <alloc_block_BF+0x17>
					best_size= element->size;
				else if(best_size >= element->size)
					best_size=element->size;
			}
		}
		if(best_size != -1)
  8030d3:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8030d7:	0f 84 d3 01 00 00    	je     8032b0 <alloc_block_BF+0x254>
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  8030dd:	a1 38 51 80 00       	mov    0x805138,%eax
  8030e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030e5:	e9 98 01 00 00       	jmp    803282 <alloc_block_BF+0x226>
			{
			 if((best_size > size) && (best_size == element->size))
  8030ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ed:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030f0:	0f 86 da 00 00 00    	jbe    8031d0 <alloc_block_BF+0x174>
  8030f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f9:	8b 50 0c             	mov    0xc(%eax),%edx
  8030fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ff:	39 c2                	cmp    %eax,%edx
  803101:	0f 85 c9 00 00 00    	jne    8031d0 <alloc_block_BF+0x174>
			  {
				// the new block are created
			    tmp_block = AvailableMemBlocksList.lh_first ;
  803107:	a1 48 51 80 00       	mov    0x805148,%eax
  80310c:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  80310f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803113:	75 17                	jne    80312c <alloc_block_BF+0xd0>
  803115:	83 ec 04             	sub    $0x4,%esp
  803118:	68 3b 47 80 00       	push   $0x80473b
  80311d:	68 ea 00 00 00       	push   $0xea
  803122:	68 93 46 80 00       	push   $0x804693
  803127:	e8 fc db ff ff       	call   800d28 <_panic>
  80312c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80312f:	8b 00                	mov    (%eax),%eax
  803131:	85 c0                	test   %eax,%eax
  803133:	74 10                	je     803145 <alloc_block_BF+0xe9>
  803135:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803138:	8b 00                	mov    (%eax),%eax
  80313a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80313d:	8b 52 04             	mov    0x4(%edx),%edx
  803140:	89 50 04             	mov    %edx,0x4(%eax)
  803143:	eb 0b                	jmp    803150 <alloc_block_BF+0xf4>
  803145:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803148:	8b 40 04             	mov    0x4(%eax),%eax
  80314b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803150:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803153:	8b 40 04             	mov    0x4(%eax),%eax
  803156:	85 c0                	test   %eax,%eax
  803158:	74 0f                	je     803169 <alloc_block_BF+0x10d>
  80315a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80315d:	8b 40 04             	mov    0x4(%eax),%eax
  803160:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803163:	8b 12                	mov    (%edx),%edx
  803165:	89 10                	mov    %edx,(%eax)
  803167:	eb 0a                	jmp    803173 <alloc_block_BF+0x117>
  803169:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80316c:	8b 00                	mov    (%eax),%eax
  80316e:	a3 48 51 80 00       	mov    %eax,0x805148
  803173:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803176:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80317c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80317f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803186:	a1 54 51 80 00       	mov    0x805154,%eax
  80318b:	48                   	dec    %eax
  80318c:	a3 54 51 80 00       	mov    %eax,0x805154
				tmp_block->sva=element->sva;
  803191:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803194:	8b 50 08             	mov    0x8(%eax),%edx
  803197:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80319a:	89 50 08             	mov    %edx,0x8(%eax)
				tmp_block->size=size;
  80319d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8031a3:	89 50 0c             	mov    %edx,0xc(%eax)
				//update block with remaining space
				element->size-=size;
  8031a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8031ac:	2b 45 08             	sub    0x8(%ebp),%eax
  8031af:	89 c2                	mov    %eax,%edx
  8031b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b4:	89 50 0c             	mov    %edx,0xc(%eax)
				element->sva = element->sva + size;
  8031b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ba:	8b 50 08             	mov    0x8(%eax),%edx
  8031bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c0:	01 c2                	add    %eax,%edx
  8031c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c5:	89 50 08             	mov    %edx,0x8(%eax)
				// return back the new block
				return tmp_block ;
  8031c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031cb:	e9 e5 00 00 00       	jmp    8032b5 <alloc_block_BF+0x259>

			  }
			else if((element->size == best_size)&&(best_size == size))
  8031d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d3:	8b 50 0c             	mov    0xc(%eax),%edx
  8031d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031d9:	39 c2                	cmp    %eax,%edx
  8031db:	0f 85 99 00 00 00    	jne    80327a <alloc_block_BF+0x21e>
  8031e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031e4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031e7:	0f 85 8d 00 00 00    	jne    80327a <alloc_block_BF+0x21e>
			  {
				tmp_block=element;
  8031ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f0:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&FreeMemBlocksList,element);
  8031f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031f7:	75 17                	jne    803210 <alloc_block_BF+0x1b4>
  8031f9:	83 ec 04             	sub    $0x4,%esp
  8031fc:	68 3b 47 80 00       	push   $0x80473b
  803201:	68 f7 00 00 00       	push   $0xf7
  803206:	68 93 46 80 00       	push   $0x804693
  80320b:	e8 18 db ff ff       	call   800d28 <_panic>
  803210:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803213:	8b 00                	mov    (%eax),%eax
  803215:	85 c0                	test   %eax,%eax
  803217:	74 10                	je     803229 <alloc_block_BF+0x1cd>
  803219:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80321c:	8b 00                	mov    (%eax),%eax
  80321e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803221:	8b 52 04             	mov    0x4(%edx),%edx
  803224:	89 50 04             	mov    %edx,0x4(%eax)
  803227:	eb 0b                	jmp    803234 <alloc_block_BF+0x1d8>
  803229:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80322c:	8b 40 04             	mov    0x4(%eax),%eax
  80322f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803234:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803237:	8b 40 04             	mov    0x4(%eax),%eax
  80323a:	85 c0                	test   %eax,%eax
  80323c:	74 0f                	je     80324d <alloc_block_BF+0x1f1>
  80323e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803241:	8b 40 04             	mov    0x4(%eax),%eax
  803244:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803247:	8b 12                	mov    (%edx),%edx
  803249:	89 10                	mov    %edx,(%eax)
  80324b:	eb 0a                	jmp    803257 <alloc_block_BF+0x1fb>
  80324d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803250:	8b 00                	mov    (%eax),%eax
  803252:	a3 38 51 80 00       	mov    %eax,0x805138
  803257:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803260:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803263:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80326a:	a1 44 51 80 00       	mov    0x805144,%eax
  80326f:	48                   	dec    %eax
  803270:	a3 44 51 80 00       	mov    %eax,0x805144
				return tmp_block;
  803275:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803278:	eb 3b                	jmp    8032b5 <alloc_block_BF+0x259>
					best_size=element->size;
			}
		}
		if(best_size != -1)
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  80327a:	a1 40 51 80 00       	mov    0x805140,%eax
  80327f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803282:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803286:	74 07                	je     80328f <alloc_block_BF+0x233>
  803288:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80328b:	8b 00                	mov    (%eax),%eax
  80328d:	eb 05                	jmp    803294 <alloc_block_BF+0x238>
  80328f:	b8 00 00 00 00       	mov    $0x0,%eax
  803294:	a3 40 51 80 00       	mov    %eax,0x805140
  803299:	a1 40 51 80 00       	mov    0x805140,%eax
  80329e:	85 c0                	test   %eax,%eax
  8032a0:	0f 85 44 fe ff ff    	jne    8030ea <alloc_block_BF+0x8e>
  8032a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032aa:	0f 85 3a fe ff ff    	jne    8030ea <alloc_block_BF+0x8e>
				LIST_REMOVE(&FreeMemBlocksList,element);
				return tmp_block;
			 }
			}
		}
		return NULL ;}
  8032b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8032b5:	c9                   	leave  
  8032b6:	c3                   	ret    

008032b7 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8032b7:	55                   	push   %ebp
  8032b8:	89 e5                	mov    %esp,%ebp
  8032ba:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  8032bd:	83 ec 04             	sub    $0x4,%esp
  8032c0:	68 5c 47 80 00       	push   $0x80475c
  8032c5:	68 04 01 00 00       	push   $0x104
  8032ca:	68 93 46 80 00       	push   $0x804693
  8032cf:	e8 54 da ff ff       	call   800d28 <_panic>

008032d4 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{struct MemBlock * blk_itr;
  8032d4:	55                   	push   %ebp
  8032d5:	89 e5                	mov    %esp,%ebp
  8032d7:	83 ec 18             	sub    $0x18,%esp
struct MemBlock * next;
struct MemBlock * first = LIST_FIRST(&(FreeMemBlocksList));
  8032da:	a1 38 51 80 00       	mov    0x805138,%eax
  8032df:	89 45 f0             	mov    %eax,-0x10(%ebp)
struct MemBlock * last = LIST_LAST(&(FreeMemBlocksList));
  8032e2:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8032e7:	89 45 ec             	mov    %eax,-0x14(%ebp)

if(LIST_EMPTY(&(FreeMemBlocksList)))
  8032ea:	a1 38 51 80 00       	mov    0x805138,%eax
  8032ef:	85 c0                	test   %eax,%eax
  8032f1:	75 68                	jne    80335b <insert_sorted_with_merge_freeList+0x87>
			{

				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  8032f3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032f7:	75 17                	jne    803310 <insert_sorted_with_merge_freeList+0x3c>
  8032f9:	83 ec 04             	sub    $0x4,%esp
  8032fc:	68 70 46 80 00       	push   $0x804670
  803301:	68 14 01 00 00       	push   $0x114
  803306:	68 93 46 80 00       	push   $0x804693
  80330b:	e8 18 da ff ff       	call   800d28 <_panic>
  803310:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803316:	8b 45 08             	mov    0x8(%ebp),%eax
  803319:	89 10                	mov    %edx,(%eax)
  80331b:	8b 45 08             	mov    0x8(%ebp),%eax
  80331e:	8b 00                	mov    (%eax),%eax
  803320:	85 c0                	test   %eax,%eax
  803322:	74 0d                	je     803331 <insert_sorted_with_merge_freeList+0x5d>
  803324:	a1 38 51 80 00       	mov    0x805138,%eax
  803329:	8b 55 08             	mov    0x8(%ebp),%edx
  80332c:	89 50 04             	mov    %edx,0x4(%eax)
  80332f:	eb 08                	jmp    803339 <insert_sorted_with_merge_freeList+0x65>
  803331:	8b 45 08             	mov    0x8(%ebp),%eax
  803334:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803339:	8b 45 08             	mov    0x8(%ebp),%eax
  80333c:	a3 38 51 80 00       	mov    %eax,0x805138
  803341:	8b 45 08             	mov    0x8(%ebp),%eax
  803344:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80334b:	a1 44 51 80 00       	mov    0x805144,%eax
  803350:	40                   	inc    %eax
  803351:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  803356:	e9 d2 06 00 00       	jmp    803a2d <insert_sorted_with_merge_freeList+0x759>
				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);

			}
else
{
	if( blockToInsert->sva  < first->sva )
  80335b:	8b 45 08             	mov    0x8(%ebp),%eax
  80335e:	8b 50 08             	mov    0x8(%eax),%edx
  803361:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803364:	8b 40 08             	mov    0x8(%eax),%eax
  803367:	39 c2                	cmp    %eax,%edx
  803369:	0f 83 22 01 00 00    	jae    803491 <insert_sorted_with_merge_freeList+0x1bd>
	{
                if( blockToInsert->sva + blockToInsert->size == first->sva)
  80336f:	8b 45 08             	mov    0x8(%ebp),%eax
  803372:	8b 50 08             	mov    0x8(%eax),%edx
  803375:	8b 45 08             	mov    0x8(%ebp),%eax
  803378:	8b 40 0c             	mov    0xc(%eax),%eax
  80337b:	01 c2                	add    %eax,%edx
  80337d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803380:	8b 40 08             	mov    0x8(%eax),%eax
  803383:	39 c2                	cmp    %eax,%edx
  803385:	0f 85 9e 00 00 00    	jne    803429 <insert_sorted_with_merge_freeList+0x155>
                {

                	first->sva = blockToInsert->sva;
  80338b:	8b 45 08             	mov    0x8(%ebp),%eax
  80338e:	8b 50 08             	mov    0x8(%eax),%edx
  803391:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803394:	89 50 08             	mov    %edx,0x8(%eax)
                	first->size = first->size + blockToInsert->size;
  803397:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80339a:	8b 50 0c             	mov    0xc(%eax),%edx
  80339d:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a0:	8b 40 0c             	mov    0xc(%eax),%eax
  8033a3:	01 c2                	add    %eax,%edx
  8033a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033a8:	89 50 0c             	mov    %edx,0xc(%eax)
                	blockToInsert->size = blockToInsert->sva = 0;
  8033ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ae:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8033b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b8:	8b 50 08             	mov    0x8(%eax),%edx
  8033bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8033be:	89 50 0c             	mov    %edx,0xc(%eax)
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  8033c1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033c5:	75 17                	jne    8033de <insert_sorted_with_merge_freeList+0x10a>
  8033c7:	83 ec 04             	sub    $0x4,%esp
  8033ca:	68 70 46 80 00       	push   $0x804670
  8033cf:	68 21 01 00 00       	push   $0x121
  8033d4:	68 93 46 80 00       	push   $0x804693
  8033d9:	e8 4a d9 ff ff       	call   800d28 <_panic>
  8033de:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e7:	89 10                	mov    %edx,(%eax)
  8033e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ec:	8b 00                	mov    (%eax),%eax
  8033ee:	85 c0                	test   %eax,%eax
  8033f0:	74 0d                	je     8033ff <insert_sorted_with_merge_freeList+0x12b>
  8033f2:	a1 48 51 80 00       	mov    0x805148,%eax
  8033f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8033fa:	89 50 04             	mov    %edx,0x4(%eax)
  8033fd:	eb 08                	jmp    803407 <insert_sorted_with_merge_freeList+0x133>
  8033ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803402:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803407:	8b 45 08             	mov    0x8(%ebp),%eax
  80340a:	a3 48 51 80 00       	mov    %eax,0x805148
  80340f:	8b 45 08             	mov    0x8(%ebp),%eax
  803412:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803419:	a1 54 51 80 00       	mov    0x805154,%eax
  80341e:	40                   	inc    %eax
  80341f:	a3 54 51 80 00       	mov    %eax,0x805154
						}
				}
        }

}
}
  803424:	e9 04 06 00 00       	jmp    803a2d <insert_sorted_with_merge_freeList+0x759>
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
                }

                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  803429:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80342d:	75 17                	jne    803446 <insert_sorted_with_merge_freeList+0x172>
  80342f:	83 ec 04             	sub    $0x4,%esp
  803432:	68 70 46 80 00       	push   $0x804670
  803437:	68 26 01 00 00       	push   $0x126
  80343c:	68 93 46 80 00       	push   $0x804693
  803441:	e8 e2 d8 ff ff       	call   800d28 <_panic>
  803446:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80344c:	8b 45 08             	mov    0x8(%ebp),%eax
  80344f:	89 10                	mov    %edx,(%eax)
  803451:	8b 45 08             	mov    0x8(%ebp),%eax
  803454:	8b 00                	mov    (%eax),%eax
  803456:	85 c0                	test   %eax,%eax
  803458:	74 0d                	je     803467 <insert_sorted_with_merge_freeList+0x193>
  80345a:	a1 38 51 80 00       	mov    0x805138,%eax
  80345f:	8b 55 08             	mov    0x8(%ebp),%edx
  803462:	89 50 04             	mov    %edx,0x4(%eax)
  803465:	eb 08                	jmp    80346f <insert_sorted_with_merge_freeList+0x19b>
  803467:	8b 45 08             	mov    0x8(%ebp),%eax
  80346a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80346f:	8b 45 08             	mov    0x8(%ebp),%eax
  803472:	a3 38 51 80 00       	mov    %eax,0x805138
  803477:	8b 45 08             	mov    0x8(%ebp),%eax
  80347a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803481:	a1 44 51 80 00       	mov    0x805144,%eax
  803486:	40                   	inc    %eax
  803487:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  80348c:	e9 9c 05 00 00       	jmp    803a2d <insert_sorted_with_merge_freeList+0x759>
                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
                }
	}
    else if(blockToInsert->sva > last->sva)
  803491:	8b 45 08             	mov    0x8(%ebp),%eax
  803494:	8b 50 08             	mov    0x8(%eax),%edx
  803497:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80349a:	8b 40 08             	mov    0x8(%eax),%eax
  80349d:	39 c2                	cmp    %eax,%edx
  80349f:	0f 86 16 01 00 00    	jbe    8035bb <insert_sorted_with_merge_freeList+0x2e7>
 	{

				if(last->sva + last->size == blockToInsert->sva)
  8034a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034a8:	8b 50 08             	mov    0x8(%eax),%edx
  8034ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8034b1:	01 c2                	add    %eax,%edx
  8034b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b6:	8b 40 08             	mov    0x8(%eax),%eax
  8034b9:	39 c2                	cmp    %eax,%edx
  8034bb:	0f 85 92 00 00 00    	jne    803553 <insert_sorted_with_merge_freeList+0x27f>
				{

					last->size = last->size + blockToInsert->size;
  8034c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034c4:	8b 50 0c             	mov    0xc(%eax),%edx
  8034c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8034cd:	01 c2                	add    %eax,%edx
  8034cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034d2:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->size = blockToInsert->sva = 0;
  8034d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8034df:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e2:	8b 50 08             	mov    0x8(%eax),%edx
  8034e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e8:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  8034eb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034ef:	75 17                	jne    803508 <insert_sorted_with_merge_freeList+0x234>
  8034f1:	83 ec 04             	sub    $0x4,%esp
  8034f4:	68 70 46 80 00       	push   $0x804670
  8034f9:	68 31 01 00 00       	push   $0x131
  8034fe:	68 93 46 80 00       	push   $0x804693
  803503:	e8 20 d8 ff ff       	call   800d28 <_panic>
  803508:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80350e:	8b 45 08             	mov    0x8(%ebp),%eax
  803511:	89 10                	mov    %edx,(%eax)
  803513:	8b 45 08             	mov    0x8(%ebp),%eax
  803516:	8b 00                	mov    (%eax),%eax
  803518:	85 c0                	test   %eax,%eax
  80351a:	74 0d                	je     803529 <insert_sorted_with_merge_freeList+0x255>
  80351c:	a1 48 51 80 00       	mov    0x805148,%eax
  803521:	8b 55 08             	mov    0x8(%ebp),%edx
  803524:	89 50 04             	mov    %edx,0x4(%eax)
  803527:	eb 08                	jmp    803531 <insert_sorted_with_merge_freeList+0x25d>
  803529:	8b 45 08             	mov    0x8(%ebp),%eax
  80352c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803531:	8b 45 08             	mov    0x8(%ebp),%eax
  803534:	a3 48 51 80 00       	mov    %eax,0x805148
  803539:	8b 45 08             	mov    0x8(%ebp),%eax
  80353c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803543:	a1 54 51 80 00       	mov    0x805154,%eax
  803548:	40                   	inc    %eax
  803549:	a3 54 51 80 00       	mov    %eax,0x805154
						}
				}
        }

}
}
  80354e:	e9 da 04 00 00       	jmp    803a2d <insert_sorted_with_merge_freeList+0x759>

				}

				else
				{
					LIST_INSERT_TAIL(&(FreeMemBlocksList),  blockToInsert);
  803553:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803557:	75 17                	jne    803570 <insert_sorted_with_merge_freeList+0x29c>
  803559:	83 ec 04             	sub    $0x4,%esp
  80355c:	68 18 47 80 00       	push   $0x804718
  803561:	68 37 01 00 00       	push   $0x137
  803566:	68 93 46 80 00       	push   $0x804693
  80356b:	e8 b8 d7 ff ff       	call   800d28 <_panic>
  803570:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803576:	8b 45 08             	mov    0x8(%ebp),%eax
  803579:	89 50 04             	mov    %edx,0x4(%eax)
  80357c:	8b 45 08             	mov    0x8(%ebp),%eax
  80357f:	8b 40 04             	mov    0x4(%eax),%eax
  803582:	85 c0                	test   %eax,%eax
  803584:	74 0c                	je     803592 <insert_sorted_with_merge_freeList+0x2be>
  803586:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80358b:	8b 55 08             	mov    0x8(%ebp),%edx
  80358e:	89 10                	mov    %edx,(%eax)
  803590:	eb 08                	jmp    80359a <insert_sorted_with_merge_freeList+0x2c6>
  803592:	8b 45 08             	mov    0x8(%ebp),%eax
  803595:	a3 38 51 80 00       	mov    %eax,0x805138
  80359a:	8b 45 08             	mov    0x8(%ebp),%eax
  80359d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8035a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035ab:	a1 44 51 80 00       	mov    0x805144,%eax
  8035b0:	40                   	inc    %eax
  8035b1:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  8035b6:	e9 72 04 00 00       	jmp    803a2d <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  8035bb:	a1 38 51 80 00       	mov    0x805138,%eax
  8035c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035c3:	e9 35 04 00 00       	jmp    8039fd <insert_sorted_with_merge_freeList+0x729>
				{
				     next=LIST_NEXT(blk_itr);
  8035c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035cb:	8b 00                	mov    (%eax),%eax
  8035cd:	89 45 e8             	mov    %eax,-0x18(%ebp)


					if( (blockToInsert->sva > blk_itr->sva) )
  8035d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d3:	8b 50 08             	mov    0x8(%eax),%edx
  8035d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035d9:	8b 40 08             	mov    0x8(%eax),%eax
  8035dc:	39 c2                	cmp    %eax,%edx
  8035de:	0f 86 11 04 00 00    	jbe    8039f5 <insert_sorted_with_merge_freeList+0x721>
						{
							if(((blk_itr->sva) + (blk_itr->size) < blockToInsert->sva && (blockToInsert->sva) + (blockToInsert->size) < next->sva))
  8035e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035e7:	8b 50 08             	mov    0x8(%eax),%edx
  8035ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8035f0:	01 c2                	add    %eax,%edx
  8035f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f5:	8b 40 08             	mov    0x8(%eax),%eax
  8035f8:	39 c2                	cmp    %eax,%edx
  8035fa:	0f 83 8b 00 00 00    	jae    80368b <insert_sorted_with_merge_freeList+0x3b7>
  803600:	8b 45 08             	mov    0x8(%ebp),%eax
  803603:	8b 50 08             	mov    0x8(%eax),%edx
  803606:	8b 45 08             	mov    0x8(%ebp),%eax
  803609:	8b 40 0c             	mov    0xc(%eax),%eax
  80360c:	01 c2                	add    %eax,%edx
  80360e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803611:	8b 40 08             	mov    0x8(%eax),%eax
  803614:	39 c2                	cmp    %eax,%edx
  803616:	73 73                	jae    80368b <insert_sorted_with_merge_freeList+0x3b7>
							{
								LIST_INSERT_AFTER(&(FreeMemBlocksList), blk_itr, blockToInsert);
  803618:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80361c:	74 06                	je     803624 <insert_sorted_with_merge_freeList+0x350>
  80361e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803622:	75 17                	jne    80363b <insert_sorted_with_merge_freeList+0x367>
  803624:	83 ec 04             	sub    $0x4,%esp
  803627:	68 e4 46 80 00       	push   $0x8046e4
  80362c:	68 48 01 00 00       	push   $0x148
  803631:	68 93 46 80 00       	push   $0x804693
  803636:	e8 ed d6 ff ff       	call   800d28 <_panic>
  80363b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80363e:	8b 10                	mov    (%eax),%edx
  803640:	8b 45 08             	mov    0x8(%ebp),%eax
  803643:	89 10                	mov    %edx,(%eax)
  803645:	8b 45 08             	mov    0x8(%ebp),%eax
  803648:	8b 00                	mov    (%eax),%eax
  80364a:	85 c0                	test   %eax,%eax
  80364c:	74 0b                	je     803659 <insert_sorted_with_merge_freeList+0x385>
  80364e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803651:	8b 00                	mov    (%eax),%eax
  803653:	8b 55 08             	mov    0x8(%ebp),%edx
  803656:	89 50 04             	mov    %edx,0x4(%eax)
  803659:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80365c:	8b 55 08             	mov    0x8(%ebp),%edx
  80365f:	89 10                	mov    %edx,(%eax)
  803661:	8b 45 08             	mov    0x8(%ebp),%eax
  803664:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803667:	89 50 04             	mov    %edx,0x4(%eax)
  80366a:	8b 45 08             	mov    0x8(%ebp),%eax
  80366d:	8b 00                	mov    (%eax),%eax
  80366f:	85 c0                	test   %eax,%eax
  803671:	75 08                	jne    80367b <insert_sorted_with_merge_freeList+0x3a7>
  803673:	8b 45 08             	mov    0x8(%ebp),%eax
  803676:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80367b:	a1 44 51 80 00       	mov    0x805144,%eax
  803680:	40                   	inc    %eax
  803681:	a3 44 51 80 00       	mov    %eax,0x805144
								break;
  803686:	e9 a2 03 00 00       	jmp    803a2d <insert_sorted_with_merge_freeList+0x759>

							}
							else if((blockToInsert->sva + blockToInsert->size) < next->sva  && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  80368b:	8b 45 08             	mov    0x8(%ebp),%eax
  80368e:	8b 50 08             	mov    0x8(%eax),%edx
  803691:	8b 45 08             	mov    0x8(%ebp),%eax
  803694:	8b 40 0c             	mov    0xc(%eax),%eax
  803697:	01 c2                	add    %eax,%edx
  803699:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80369c:	8b 40 08             	mov    0x8(%eax),%eax
  80369f:	39 c2                	cmp    %eax,%edx
  8036a1:	0f 83 ae 00 00 00    	jae    803755 <insert_sorted_with_merge_freeList+0x481>
  8036a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8036aa:	8b 50 08             	mov    0x8(%eax),%edx
  8036ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036b0:	8b 48 08             	mov    0x8(%eax),%ecx
  8036b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8036b9:	01 c8                	add    %ecx,%eax
  8036bb:	39 c2                	cmp    %eax,%edx
  8036bd:	0f 85 92 00 00 00    	jne    803755 <insert_sorted_with_merge_freeList+0x481>
							{

								blk_itr->size=blk_itr->size+blockToInsert->size;
  8036c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036c6:	8b 50 0c             	mov    0xc(%eax),%edx
  8036c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8036cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8036cf:	01 c2                	add    %eax,%edx
  8036d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036d4:	89 50 0c             	mov    %edx,0xc(%eax)
								 blockToInsert->size=blockToInsert->sva=0;
  8036d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8036da:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8036e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e4:	8b 50 08             	mov    0x8(%eax),%edx
  8036e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ea:	89 50 0c             	mov    %edx,0xc(%eax)
								 LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  8036ed:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036f1:	75 17                	jne    80370a <insert_sorted_with_merge_freeList+0x436>
  8036f3:	83 ec 04             	sub    $0x4,%esp
  8036f6:	68 70 46 80 00       	push   $0x804670
  8036fb:	68 51 01 00 00       	push   $0x151
  803700:	68 93 46 80 00       	push   $0x804693
  803705:	e8 1e d6 ff ff       	call   800d28 <_panic>
  80370a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803710:	8b 45 08             	mov    0x8(%ebp),%eax
  803713:	89 10                	mov    %edx,(%eax)
  803715:	8b 45 08             	mov    0x8(%ebp),%eax
  803718:	8b 00                	mov    (%eax),%eax
  80371a:	85 c0                	test   %eax,%eax
  80371c:	74 0d                	je     80372b <insert_sorted_with_merge_freeList+0x457>
  80371e:	a1 48 51 80 00       	mov    0x805148,%eax
  803723:	8b 55 08             	mov    0x8(%ebp),%edx
  803726:	89 50 04             	mov    %edx,0x4(%eax)
  803729:	eb 08                	jmp    803733 <insert_sorted_with_merge_freeList+0x45f>
  80372b:	8b 45 08             	mov    0x8(%ebp),%eax
  80372e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803733:	8b 45 08             	mov    0x8(%ebp),%eax
  803736:	a3 48 51 80 00       	mov    %eax,0x805148
  80373b:	8b 45 08             	mov    0x8(%ebp),%eax
  80373e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803745:	a1 54 51 80 00       	mov    0x805154,%eax
  80374a:	40                   	inc    %eax
  80374b:	a3 54 51 80 00       	mov    %eax,0x805154
								 break;
  803750:	e9 d8 02 00 00       	jmp    803a2d <insert_sorted_with_merge_freeList+0x759>

							}
							else if( (blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva > (blk_itr->sva + blk_itr->size))
  803755:	8b 45 08             	mov    0x8(%ebp),%eax
  803758:	8b 50 08             	mov    0x8(%eax),%edx
  80375b:	8b 45 08             	mov    0x8(%ebp),%eax
  80375e:	8b 40 0c             	mov    0xc(%eax),%eax
  803761:	01 c2                	add    %eax,%edx
  803763:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803766:	8b 40 08             	mov    0x8(%eax),%eax
  803769:	39 c2                	cmp    %eax,%edx
  80376b:	0f 85 ba 00 00 00    	jne    80382b <insert_sorted_with_merge_freeList+0x557>
  803771:	8b 45 08             	mov    0x8(%ebp),%eax
  803774:	8b 50 08             	mov    0x8(%eax),%edx
  803777:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80377a:	8b 48 08             	mov    0x8(%eax),%ecx
  80377d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803780:	8b 40 0c             	mov    0xc(%eax),%eax
  803783:	01 c8                	add    %ecx,%eax
  803785:	39 c2                	cmp    %eax,%edx
  803787:	0f 86 9e 00 00 00    	jbe    80382b <insert_sorted_with_merge_freeList+0x557>
							{
								next->size = next->size + blockToInsert->size;
  80378d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803790:	8b 50 0c             	mov    0xc(%eax),%edx
  803793:	8b 45 08             	mov    0x8(%ebp),%eax
  803796:	8b 40 0c             	mov    0xc(%eax),%eax
  803799:	01 c2                	add    %eax,%edx
  80379b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80379e:	89 50 0c             	mov    %edx,0xc(%eax)
								next->sva = blockToInsert->sva;
  8037a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a4:	8b 50 08             	mov    0x8(%eax),%edx
  8037a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037aa:	89 50 08             	mov    %edx,0x8(%eax)

								blockToInsert->size = blockToInsert->sva = 0;
  8037ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8037b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ba:	8b 50 08             	mov    0x8(%eax),%edx
  8037bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8037c0:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  8037c3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037c7:	75 17                	jne    8037e0 <insert_sorted_with_merge_freeList+0x50c>
  8037c9:	83 ec 04             	sub    $0x4,%esp
  8037cc:	68 70 46 80 00       	push   $0x804670
  8037d1:	68 5b 01 00 00       	push   $0x15b
  8037d6:	68 93 46 80 00       	push   $0x804693
  8037db:	e8 48 d5 ff ff       	call   800d28 <_panic>
  8037e0:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8037e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8037e9:	89 10                	mov    %edx,(%eax)
  8037eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ee:	8b 00                	mov    (%eax),%eax
  8037f0:	85 c0                	test   %eax,%eax
  8037f2:	74 0d                	je     803801 <insert_sorted_with_merge_freeList+0x52d>
  8037f4:	a1 48 51 80 00       	mov    0x805148,%eax
  8037f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8037fc:	89 50 04             	mov    %edx,0x4(%eax)
  8037ff:	eb 08                	jmp    803809 <insert_sorted_with_merge_freeList+0x535>
  803801:	8b 45 08             	mov    0x8(%ebp),%eax
  803804:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803809:	8b 45 08             	mov    0x8(%ebp),%eax
  80380c:	a3 48 51 80 00       	mov    %eax,0x805148
  803811:	8b 45 08             	mov    0x8(%ebp),%eax
  803814:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80381b:	a1 54 51 80 00       	mov    0x805154,%eax
  803820:	40                   	inc    %eax
  803821:	a3 54 51 80 00       	mov    %eax,0x805154
								break;
  803826:	e9 02 02 00 00       	jmp    803a2d <insert_sorted_with_merge_freeList+0x759>
							}
							else if ((blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  80382b:	8b 45 08             	mov    0x8(%ebp),%eax
  80382e:	8b 50 08             	mov    0x8(%eax),%edx
  803831:	8b 45 08             	mov    0x8(%ebp),%eax
  803834:	8b 40 0c             	mov    0xc(%eax),%eax
  803837:	01 c2                	add    %eax,%edx
  803839:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80383c:	8b 40 08             	mov    0x8(%eax),%eax
  80383f:	39 c2                	cmp    %eax,%edx
  803841:	0f 85 ae 01 00 00    	jne    8039f5 <insert_sorted_with_merge_freeList+0x721>
  803847:	8b 45 08             	mov    0x8(%ebp),%eax
  80384a:	8b 50 08             	mov    0x8(%eax),%edx
  80384d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803850:	8b 48 08             	mov    0x8(%eax),%ecx
  803853:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803856:	8b 40 0c             	mov    0xc(%eax),%eax
  803859:	01 c8                	add    %ecx,%eax
  80385b:	39 c2                	cmp    %eax,%edx
  80385d:	0f 85 92 01 00 00    	jne    8039f5 <insert_sorted_with_merge_freeList+0x721>
							{
								blk_itr->size = blk_itr->size + blockToInsert->size + next->size;
  803863:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803866:	8b 50 0c             	mov    0xc(%eax),%edx
  803869:	8b 45 08             	mov    0x8(%ebp),%eax
  80386c:	8b 40 0c             	mov    0xc(%eax),%eax
  80386f:	01 c2                	add    %eax,%edx
  803871:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803874:	8b 40 0c             	mov    0xc(%eax),%eax
  803877:	01 c2                	add    %eax,%edx
  803879:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80387c:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size = blockToInsert->sva=0;
  80387f:	8b 45 08             	mov    0x8(%ebp),%eax
  803882:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803889:	8b 45 08             	mov    0x8(%ebp),%eax
  80388c:	8b 50 08             	mov    0x8(%eax),%edx
  80388f:	8b 45 08             	mov    0x8(%ebp),%eax
  803892:	89 50 0c             	mov    %edx,0xc(%eax)
								next->size = next->sva = 0;
  803895:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803898:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80389f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038a2:	8b 50 08             	mov    0x8(%eax),%edx
  8038a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038a8:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_REMOVE(&FreeMemBlocksList, next);
  8038ab:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8038af:	75 17                	jne    8038c8 <insert_sorted_with_merge_freeList+0x5f4>
  8038b1:	83 ec 04             	sub    $0x4,%esp
  8038b4:	68 3b 47 80 00       	push   $0x80473b
  8038b9:	68 63 01 00 00       	push   $0x163
  8038be:	68 93 46 80 00       	push   $0x804693
  8038c3:	e8 60 d4 ff ff       	call   800d28 <_panic>
  8038c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038cb:	8b 00                	mov    (%eax),%eax
  8038cd:	85 c0                	test   %eax,%eax
  8038cf:	74 10                	je     8038e1 <insert_sorted_with_merge_freeList+0x60d>
  8038d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038d4:	8b 00                	mov    (%eax),%eax
  8038d6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8038d9:	8b 52 04             	mov    0x4(%edx),%edx
  8038dc:	89 50 04             	mov    %edx,0x4(%eax)
  8038df:	eb 0b                	jmp    8038ec <insert_sorted_with_merge_freeList+0x618>
  8038e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038e4:	8b 40 04             	mov    0x4(%eax),%eax
  8038e7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8038ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038ef:	8b 40 04             	mov    0x4(%eax),%eax
  8038f2:	85 c0                	test   %eax,%eax
  8038f4:	74 0f                	je     803905 <insert_sorted_with_merge_freeList+0x631>
  8038f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038f9:	8b 40 04             	mov    0x4(%eax),%eax
  8038fc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8038ff:	8b 12                	mov    (%edx),%edx
  803901:	89 10                	mov    %edx,(%eax)
  803903:	eb 0a                	jmp    80390f <insert_sorted_with_merge_freeList+0x63b>
  803905:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803908:	8b 00                	mov    (%eax),%eax
  80390a:	a3 38 51 80 00       	mov    %eax,0x805138
  80390f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803912:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803918:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80391b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803922:	a1 44 51 80 00       	mov    0x805144,%eax
  803927:	48                   	dec    %eax
  803928:	a3 44 51 80 00       	mov    %eax,0x805144
								LIST_INSERT_HEAD(&AvailableMemBlocksList, next );
  80392d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803931:	75 17                	jne    80394a <insert_sorted_with_merge_freeList+0x676>
  803933:	83 ec 04             	sub    $0x4,%esp
  803936:	68 70 46 80 00       	push   $0x804670
  80393b:	68 64 01 00 00       	push   $0x164
  803940:	68 93 46 80 00       	push   $0x804693
  803945:	e8 de d3 ff ff       	call   800d28 <_panic>
  80394a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803950:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803953:	89 10                	mov    %edx,(%eax)
  803955:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803958:	8b 00                	mov    (%eax),%eax
  80395a:	85 c0                	test   %eax,%eax
  80395c:	74 0d                	je     80396b <insert_sorted_with_merge_freeList+0x697>
  80395e:	a1 48 51 80 00       	mov    0x805148,%eax
  803963:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803966:	89 50 04             	mov    %edx,0x4(%eax)
  803969:	eb 08                	jmp    803973 <insert_sorted_with_merge_freeList+0x69f>
  80396b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80396e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803973:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803976:	a3 48 51 80 00       	mov    %eax,0x805148
  80397b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80397e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803985:	a1 54 51 80 00       	mov    0x805154,%eax
  80398a:	40                   	inc    %eax
  80398b:	a3 54 51 80 00       	mov    %eax,0x805154
							    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  803990:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803994:	75 17                	jne    8039ad <insert_sorted_with_merge_freeList+0x6d9>
  803996:	83 ec 04             	sub    $0x4,%esp
  803999:	68 70 46 80 00       	push   $0x804670
  80399e:	68 65 01 00 00       	push   $0x165
  8039a3:	68 93 46 80 00       	push   $0x804693
  8039a8:	e8 7b d3 ff ff       	call   800d28 <_panic>
  8039ad:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8039b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8039b6:	89 10                	mov    %edx,(%eax)
  8039b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8039bb:	8b 00                	mov    (%eax),%eax
  8039bd:	85 c0                	test   %eax,%eax
  8039bf:	74 0d                	je     8039ce <insert_sorted_with_merge_freeList+0x6fa>
  8039c1:	a1 48 51 80 00       	mov    0x805148,%eax
  8039c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8039c9:	89 50 04             	mov    %edx,0x4(%eax)
  8039cc:	eb 08                	jmp    8039d6 <insert_sorted_with_merge_freeList+0x702>
  8039ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8039d1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8039d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8039d9:	a3 48 51 80 00       	mov    %eax,0x805148
  8039de:	8b 45 08             	mov    0x8(%ebp),%eax
  8039e1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039e8:	a1 54 51 80 00       	mov    0x805154,%eax
  8039ed:	40                   	inc    %eax
  8039ee:	a3 54 51 80 00       	mov    %eax,0x805154
								break;
  8039f3:	eb 38                	jmp    803a2d <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  8039f5:	a1 40 51 80 00       	mov    0x805140,%eax
  8039fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8039fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a01:	74 07                	je     803a0a <insert_sorted_with_merge_freeList+0x736>
  803a03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a06:	8b 00                	mov    (%eax),%eax
  803a08:	eb 05                	jmp    803a0f <insert_sorted_with_merge_freeList+0x73b>
  803a0a:	b8 00 00 00 00       	mov    $0x0,%eax
  803a0f:	a3 40 51 80 00       	mov    %eax,0x805140
  803a14:	a1 40 51 80 00       	mov    0x805140,%eax
  803a19:	85 c0                	test   %eax,%eax
  803a1b:	0f 85 a7 fb ff ff    	jne    8035c8 <insert_sorted_with_merge_freeList+0x2f4>
  803a21:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a25:	0f 85 9d fb ff ff    	jne    8035c8 <insert_sorted_with_merge_freeList+0x2f4>
						}
				}
        }

}
}
  803a2b:	eb 00                	jmp    803a2d <insert_sorted_with_merge_freeList+0x759>
  803a2d:	90                   	nop
  803a2e:	c9                   	leave  
  803a2f:	c3                   	ret    

00803a30 <__udivdi3>:
  803a30:	55                   	push   %ebp
  803a31:	57                   	push   %edi
  803a32:	56                   	push   %esi
  803a33:	53                   	push   %ebx
  803a34:	83 ec 1c             	sub    $0x1c,%esp
  803a37:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803a3b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803a3f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a43:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803a47:	89 ca                	mov    %ecx,%edx
  803a49:	89 f8                	mov    %edi,%eax
  803a4b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803a4f:	85 f6                	test   %esi,%esi
  803a51:	75 2d                	jne    803a80 <__udivdi3+0x50>
  803a53:	39 cf                	cmp    %ecx,%edi
  803a55:	77 65                	ja     803abc <__udivdi3+0x8c>
  803a57:	89 fd                	mov    %edi,%ebp
  803a59:	85 ff                	test   %edi,%edi
  803a5b:	75 0b                	jne    803a68 <__udivdi3+0x38>
  803a5d:	b8 01 00 00 00       	mov    $0x1,%eax
  803a62:	31 d2                	xor    %edx,%edx
  803a64:	f7 f7                	div    %edi
  803a66:	89 c5                	mov    %eax,%ebp
  803a68:	31 d2                	xor    %edx,%edx
  803a6a:	89 c8                	mov    %ecx,%eax
  803a6c:	f7 f5                	div    %ebp
  803a6e:	89 c1                	mov    %eax,%ecx
  803a70:	89 d8                	mov    %ebx,%eax
  803a72:	f7 f5                	div    %ebp
  803a74:	89 cf                	mov    %ecx,%edi
  803a76:	89 fa                	mov    %edi,%edx
  803a78:	83 c4 1c             	add    $0x1c,%esp
  803a7b:	5b                   	pop    %ebx
  803a7c:	5e                   	pop    %esi
  803a7d:	5f                   	pop    %edi
  803a7e:	5d                   	pop    %ebp
  803a7f:	c3                   	ret    
  803a80:	39 ce                	cmp    %ecx,%esi
  803a82:	77 28                	ja     803aac <__udivdi3+0x7c>
  803a84:	0f bd fe             	bsr    %esi,%edi
  803a87:	83 f7 1f             	xor    $0x1f,%edi
  803a8a:	75 40                	jne    803acc <__udivdi3+0x9c>
  803a8c:	39 ce                	cmp    %ecx,%esi
  803a8e:	72 0a                	jb     803a9a <__udivdi3+0x6a>
  803a90:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803a94:	0f 87 9e 00 00 00    	ja     803b38 <__udivdi3+0x108>
  803a9a:	b8 01 00 00 00       	mov    $0x1,%eax
  803a9f:	89 fa                	mov    %edi,%edx
  803aa1:	83 c4 1c             	add    $0x1c,%esp
  803aa4:	5b                   	pop    %ebx
  803aa5:	5e                   	pop    %esi
  803aa6:	5f                   	pop    %edi
  803aa7:	5d                   	pop    %ebp
  803aa8:	c3                   	ret    
  803aa9:	8d 76 00             	lea    0x0(%esi),%esi
  803aac:	31 ff                	xor    %edi,%edi
  803aae:	31 c0                	xor    %eax,%eax
  803ab0:	89 fa                	mov    %edi,%edx
  803ab2:	83 c4 1c             	add    $0x1c,%esp
  803ab5:	5b                   	pop    %ebx
  803ab6:	5e                   	pop    %esi
  803ab7:	5f                   	pop    %edi
  803ab8:	5d                   	pop    %ebp
  803ab9:	c3                   	ret    
  803aba:	66 90                	xchg   %ax,%ax
  803abc:	89 d8                	mov    %ebx,%eax
  803abe:	f7 f7                	div    %edi
  803ac0:	31 ff                	xor    %edi,%edi
  803ac2:	89 fa                	mov    %edi,%edx
  803ac4:	83 c4 1c             	add    $0x1c,%esp
  803ac7:	5b                   	pop    %ebx
  803ac8:	5e                   	pop    %esi
  803ac9:	5f                   	pop    %edi
  803aca:	5d                   	pop    %ebp
  803acb:	c3                   	ret    
  803acc:	bd 20 00 00 00       	mov    $0x20,%ebp
  803ad1:	89 eb                	mov    %ebp,%ebx
  803ad3:	29 fb                	sub    %edi,%ebx
  803ad5:	89 f9                	mov    %edi,%ecx
  803ad7:	d3 e6                	shl    %cl,%esi
  803ad9:	89 c5                	mov    %eax,%ebp
  803adb:	88 d9                	mov    %bl,%cl
  803add:	d3 ed                	shr    %cl,%ebp
  803adf:	89 e9                	mov    %ebp,%ecx
  803ae1:	09 f1                	or     %esi,%ecx
  803ae3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803ae7:	89 f9                	mov    %edi,%ecx
  803ae9:	d3 e0                	shl    %cl,%eax
  803aeb:	89 c5                	mov    %eax,%ebp
  803aed:	89 d6                	mov    %edx,%esi
  803aef:	88 d9                	mov    %bl,%cl
  803af1:	d3 ee                	shr    %cl,%esi
  803af3:	89 f9                	mov    %edi,%ecx
  803af5:	d3 e2                	shl    %cl,%edx
  803af7:	8b 44 24 08          	mov    0x8(%esp),%eax
  803afb:	88 d9                	mov    %bl,%cl
  803afd:	d3 e8                	shr    %cl,%eax
  803aff:	09 c2                	or     %eax,%edx
  803b01:	89 d0                	mov    %edx,%eax
  803b03:	89 f2                	mov    %esi,%edx
  803b05:	f7 74 24 0c          	divl   0xc(%esp)
  803b09:	89 d6                	mov    %edx,%esi
  803b0b:	89 c3                	mov    %eax,%ebx
  803b0d:	f7 e5                	mul    %ebp
  803b0f:	39 d6                	cmp    %edx,%esi
  803b11:	72 19                	jb     803b2c <__udivdi3+0xfc>
  803b13:	74 0b                	je     803b20 <__udivdi3+0xf0>
  803b15:	89 d8                	mov    %ebx,%eax
  803b17:	31 ff                	xor    %edi,%edi
  803b19:	e9 58 ff ff ff       	jmp    803a76 <__udivdi3+0x46>
  803b1e:	66 90                	xchg   %ax,%ax
  803b20:	8b 54 24 08          	mov    0x8(%esp),%edx
  803b24:	89 f9                	mov    %edi,%ecx
  803b26:	d3 e2                	shl    %cl,%edx
  803b28:	39 c2                	cmp    %eax,%edx
  803b2a:	73 e9                	jae    803b15 <__udivdi3+0xe5>
  803b2c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803b2f:	31 ff                	xor    %edi,%edi
  803b31:	e9 40 ff ff ff       	jmp    803a76 <__udivdi3+0x46>
  803b36:	66 90                	xchg   %ax,%ax
  803b38:	31 c0                	xor    %eax,%eax
  803b3a:	e9 37 ff ff ff       	jmp    803a76 <__udivdi3+0x46>
  803b3f:	90                   	nop

00803b40 <__umoddi3>:
  803b40:	55                   	push   %ebp
  803b41:	57                   	push   %edi
  803b42:	56                   	push   %esi
  803b43:	53                   	push   %ebx
  803b44:	83 ec 1c             	sub    $0x1c,%esp
  803b47:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803b4b:	8b 74 24 34          	mov    0x34(%esp),%esi
  803b4f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b53:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803b57:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803b5b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803b5f:	89 f3                	mov    %esi,%ebx
  803b61:	89 fa                	mov    %edi,%edx
  803b63:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b67:	89 34 24             	mov    %esi,(%esp)
  803b6a:	85 c0                	test   %eax,%eax
  803b6c:	75 1a                	jne    803b88 <__umoddi3+0x48>
  803b6e:	39 f7                	cmp    %esi,%edi
  803b70:	0f 86 a2 00 00 00    	jbe    803c18 <__umoddi3+0xd8>
  803b76:	89 c8                	mov    %ecx,%eax
  803b78:	89 f2                	mov    %esi,%edx
  803b7a:	f7 f7                	div    %edi
  803b7c:	89 d0                	mov    %edx,%eax
  803b7e:	31 d2                	xor    %edx,%edx
  803b80:	83 c4 1c             	add    $0x1c,%esp
  803b83:	5b                   	pop    %ebx
  803b84:	5e                   	pop    %esi
  803b85:	5f                   	pop    %edi
  803b86:	5d                   	pop    %ebp
  803b87:	c3                   	ret    
  803b88:	39 f0                	cmp    %esi,%eax
  803b8a:	0f 87 ac 00 00 00    	ja     803c3c <__umoddi3+0xfc>
  803b90:	0f bd e8             	bsr    %eax,%ebp
  803b93:	83 f5 1f             	xor    $0x1f,%ebp
  803b96:	0f 84 ac 00 00 00    	je     803c48 <__umoddi3+0x108>
  803b9c:	bf 20 00 00 00       	mov    $0x20,%edi
  803ba1:	29 ef                	sub    %ebp,%edi
  803ba3:	89 fe                	mov    %edi,%esi
  803ba5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803ba9:	89 e9                	mov    %ebp,%ecx
  803bab:	d3 e0                	shl    %cl,%eax
  803bad:	89 d7                	mov    %edx,%edi
  803baf:	89 f1                	mov    %esi,%ecx
  803bb1:	d3 ef                	shr    %cl,%edi
  803bb3:	09 c7                	or     %eax,%edi
  803bb5:	89 e9                	mov    %ebp,%ecx
  803bb7:	d3 e2                	shl    %cl,%edx
  803bb9:	89 14 24             	mov    %edx,(%esp)
  803bbc:	89 d8                	mov    %ebx,%eax
  803bbe:	d3 e0                	shl    %cl,%eax
  803bc0:	89 c2                	mov    %eax,%edx
  803bc2:	8b 44 24 08          	mov    0x8(%esp),%eax
  803bc6:	d3 e0                	shl    %cl,%eax
  803bc8:	89 44 24 04          	mov    %eax,0x4(%esp)
  803bcc:	8b 44 24 08          	mov    0x8(%esp),%eax
  803bd0:	89 f1                	mov    %esi,%ecx
  803bd2:	d3 e8                	shr    %cl,%eax
  803bd4:	09 d0                	or     %edx,%eax
  803bd6:	d3 eb                	shr    %cl,%ebx
  803bd8:	89 da                	mov    %ebx,%edx
  803bda:	f7 f7                	div    %edi
  803bdc:	89 d3                	mov    %edx,%ebx
  803bde:	f7 24 24             	mull   (%esp)
  803be1:	89 c6                	mov    %eax,%esi
  803be3:	89 d1                	mov    %edx,%ecx
  803be5:	39 d3                	cmp    %edx,%ebx
  803be7:	0f 82 87 00 00 00    	jb     803c74 <__umoddi3+0x134>
  803bed:	0f 84 91 00 00 00    	je     803c84 <__umoddi3+0x144>
  803bf3:	8b 54 24 04          	mov    0x4(%esp),%edx
  803bf7:	29 f2                	sub    %esi,%edx
  803bf9:	19 cb                	sbb    %ecx,%ebx
  803bfb:	89 d8                	mov    %ebx,%eax
  803bfd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803c01:	d3 e0                	shl    %cl,%eax
  803c03:	89 e9                	mov    %ebp,%ecx
  803c05:	d3 ea                	shr    %cl,%edx
  803c07:	09 d0                	or     %edx,%eax
  803c09:	89 e9                	mov    %ebp,%ecx
  803c0b:	d3 eb                	shr    %cl,%ebx
  803c0d:	89 da                	mov    %ebx,%edx
  803c0f:	83 c4 1c             	add    $0x1c,%esp
  803c12:	5b                   	pop    %ebx
  803c13:	5e                   	pop    %esi
  803c14:	5f                   	pop    %edi
  803c15:	5d                   	pop    %ebp
  803c16:	c3                   	ret    
  803c17:	90                   	nop
  803c18:	89 fd                	mov    %edi,%ebp
  803c1a:	85 ff                	test   %edi,%edi
  803c1c:	75 0b                	jne    803c29 <__umoddi3+0xe9>
  803c1e:	b8 01 00 00 00       	mov    $0x1,%eax
  803c23:	31 d2                	xor    %edx,%edx
  803c25:	f7 f7                	div    %edi
  803c27:	89 c5                	mov    %eax,%ebp
  803c29:	89 f0                	mov    %esi,%eax
  803c2b:	31 d2                	xor    %edx,%edx
  803c2d:	f7 f5                	div    %ebp
  803c2f:	89 c8                	mov    %ecx,%eax
  803c31:	f7 f5                	div    %ebp
  803c33:	89 d0                	mov    %edx,%eax
  803c35:	e9 44 ff ff ff       	jmp    803b7e <__umoddi3+0x3e>
  803c3a:	66 90                	xchg   %ax,%ax
  803c3c:	89 c8                	mov    %ecx,%eax
  803c3e:	89 f2                	mov    %esi,%edx
  803c40:	83 c4 1c             	add    $0x1c,%esp
  803c43:	5b                   	pop    %ebx
  803c44:	5e                   	pop    %esi
  803c45:	5f                   	pop    %edi
  803c46:	5d                   	pop    %ebp
  803c47:	c3                   	ret    
  803c48:	3b 04 24             	cmp    (%esp),%eax
  803c4b:	72 06                	jb     803c53 <__umoddi3+0x113>
  803c4d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803c51:	77 0f                	ja     803c62 <__umoddi3+0x122>
  803c53:	89 f2                	mov    %esi,%edx
  803c55:	29 f9                	sub    %edi,%ecx
  803c57:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803c5b:	89 14 24             	mov    %edx,(%esp)
  803c5e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c62:	8b 44 24 04          	mov    0x4(%esp),%eax
  803c66:	8b 14 24             	mov    (%esp),%edx
  803c69:	83 c4 1c             	add    $0x1c,%esp
  803c6c:	5b                   	pop    %ebx
  803c6d:	5e                   	pop    %esi
  803c6e:	5f                   	pop    %edi
  803c6f:	5d                   	pop    %ebp
  803c70:	c3                   	ret    
  803c71:	8d 76 00             	lea    0x0(%esi),%esi
  803c74:	2b 04 24             	sub    (%esp),%eax
  803c77:	19 fa                	sbb    %edi,%edx
  803c79:	89 d1                	mov    %edx,%ecx
  803c7b:	89 c6                	mov    %eax,%esi
  803c7d:	e9 71 ff ff ff       	jmp    803bf3 <__umoddi3+0xb3>
  803c82:	66 90                	xchg   %ax,%ax
  803c84:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803c88:	72 ea                	jb     803c74 <__umoddi3+0x134>
  803c8a:	89 d9                	mov    %ebx,%ecx
  803c8c:	e9 62 ff ff ff       	jmp    803bf3 <__umoddi3+0xb3>
