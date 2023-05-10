
obj/user/tst_realloc_3:     file format elf32-i386


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
  800031:	e8 29 06 00 00       	call   80065f <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	83 ec 40             	sub    $0x40,%esp
	int Mega = 1024*1024;
  800040:	c7 45 f0 00 00 10 00 	movl   $0x100000,-0x10(%ebp)
	int kilo = 1024;
  800047:	c7 45 ec 00 04 00 00 	movl   $0x400,-0x14(%ebp)
	void* ptr_allocations[5] = {0};
  80004e:	8d 55 c4             	lea    -0x3c(%ebp),%edx
  800051:	b9 05 00 00 00       	mov    $0x5,%ecx
  800056:	b8 00 00 00 00       	mov    $0x0,%eax
  80005b:	89 d7                	mov    %edx,%edi
  80005d:	f3 ab                	rep stos %eax,%es:(%edi)
	int freeFrames ;
	int usedDiskPages;
	cprintf("realloc: current evaluation = 00%");
  80005f:	83 ec 0c             	sub    $0xc,%esp
  800062:	68 20 37 80 00       	push   $0x803720
  800067:	e8 e3 09 00 00       	call   800a4f <cprintf>
  80006c:	83 c4 10             	add    $0x10,%esp
	//[1] Allocate all
	{
		//Allocate 100 KB
		freeFrames = sys_calculate_free_frames() ;
  80006f:	e8 35 1d 00 00       	call   801da9 <sys_calculate_free_frames>
  800074:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800077:	e8 cd 1d 00 00       	call   801e49 <sys_pf_calculate_allocated_pages>
  80007c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[0] = malloc(100*kilo - kilo);
  80007f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800082:	89 d0                	mov    %edx,%eax
  800084:	01 c0                	add    %eax,%eax
  800086:	01 d0                	add    %edx,%eax
  800088:	89 c2                	mov    %eax,%edx
  80008a:	c1 e2 05             	shl    $0x5,%edx
  80008d:	01 d0                	add    %edx,%eax
  80008f:	83 ec 0c             	sub    $0xc,%esp
  800092:	50                   	push   %eax
  800093:	e8 e3 18 00 00       	call   80197b <malloc>
  800098:	83 c4 10             	add    $0x10,%esp
  80009b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if ((uint32) ptr_allocations[0] !=  (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  80009e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8000a1:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  8000a6:	74 14                	je     8000bc <_main+0x84>
  8000a8:	83 ec 04             	sub    $0x4,%esp
  8000ab:	68 44 37 80 00       	push   $0x803744
  8000b0:	6a 11                	push   $0x11
  8000b2:	68 74 37 80 00       	push   $0x803774
  8000b7:	e8 df 06 00 00       	call   80079b <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8000bc:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000bf:	e8 e5 1c 00 00       	call   801da9 <sys_calculate_free_frames>
  8000c4:	29 c3                	sub    %eax,%ebx
  8000c6:	89 d8                	mov    %ebx,%eax
  8000c8:	83 f8 01             	cmp    $0x1,%eax
  8000cb:	74 14                	je     8000e1 <_main+0xa9>
  8000cd:	83 ec 04             	sub    $0x4,%esp
  8000d0:	68 8c 37 80 00       	push   $0x80378c
  8000d5:	6a 13                	push   $0x13
  8000d7:	68 74 37 80 00       	push   $0x803774
  8000dc:	e8 ba 06 00 00       	call   80079b <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 25) panic("Extra or less pages are allocated in PageFile");
  8000e1:	e8 63 1d 00 00       	call   801e49 <sys_pf_calculate_allocated_pages>
  8000e6:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8000e9:	83 f8 19             	cmp    $0x19,%eax
  8000ec:	74 14                	je     800102 <_main+0xca>
  8000ee:	83 ec 04             	sub    $0x4,%esp
  8000f1:	68 f8 37 80 00       	push   $0x8037f8
  8000f6:	6a 14                	push   $0x14
  8000f8:	68 74 37 80 00       	push   $0x803774
  8000fd:	e8 99 06 00 00       	call   80079b <_panic>

		//Allocate 20 KB
		freeFrames = sys_calculate_free_frames() ;
  800102:	e8 a2 1c 00 00       	call   801da9 <sys_calculate_free_frames>
  800107:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80010a:	e8 3a 1d 00 00       	call   801e49 <sys_pf_calculate_allocated_pages>
  80010f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[1] = malloc(20*kilo-kilo);
  800112:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800115:	89 d0                	mov    %edx,%eax
  800117:	c1 e0 03             	shl    $0x3,%eax
  80011a:	01 d0                	add    %edx,%eax
  80011c:	01 c0                	add    %eax,%eax
  80011e:	01 d0                	add    %edx,%eax
  800120:	83 ec 0c             	sub    $0xc,%esp
  800123:	50                   	push   %eax
  800124:	e8 52 18 00 00       	call   80197b <malloc>
  800129:	83 c4 10             	add    $0x10,%esp
  80012c:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if ((uint32) ptr_allocations[1] !=  (USER_HEAP_START + 100 * kilo)) panic("Wrong start address for the allocated space... ");
  80012f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800132:	89 c1                	mov    %eax,%ecx
  800134:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800137:	89 d0                	mov    %edx,%eax
  800139:	c1 e0 02             	shl    $0x2,%eax
  80013c:	01 d0                	add    %edx,%eax
  80013e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800145:	01 d0                	add    %edx,%eax
  800147:	c1 e0 02             	shl    $0x2,%eax
  80014a:	05 00 00 00 80       	add    $0x80000000,%eax
  80014f:	39 c1                	cmp    %eax,%ecx
  800151:	74 14                	je     800167 <_main+0x12f>
  800153:	83 ec 04             	sub    $0x4,%esp
  800156:	68 44 37 80 00       	push   $0x803744
  80015b:	6a 1a                	push   $0x1a
  80015d:	68 74 37 80 00       	push   $0x803774
  800162:	e8 34 06 00 00       	call   80079b <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800167:	e8 3d 1c 00 00       	call   801da9 <sys_calculate_free_frames>
  80016c:	89 c2                	mov    %eax,%edx
  80016e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800171:	39 c2                	cmp    %eax,%edx
  800173:	74 14                	je     800189 <_main+0x151>
  800175:	83 ec 04             	sub    $0x4,%esp
  800178:	68 8c 37 80 00       	push   $0x80378c
  80017d:	6a 1c                	push   $0x1c
  80017f:	68 74 37 80 00       	push   $0x803774
  800184:	e8 12 06 00 00       	call   80079b <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 5) panic("Extra or less pages are allocated in PageFile");
  800189:	e8 bb 1c 00 00       	call   801e49 <sys_pf_calculate_allocated_pages>
  80018e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800191:	83 f8 05             	cmp    $0x5,%eax
  800194:	74 14                	je     8001aa <_main+0x172>
  800196:	83 ec 04             	sub    $0x4,%esp
  800199:	68 f8 37 80 00       	push   $0x8037f8
  80019e:	6a 1d                	push   $0x1d
  8001a0:	68 74 37 80 00       	push   $0x803774
  8001a5:	e8 f1 05 00 00       	call   80079b <_panic>

		//Allocate 30 KB
		freeFrames = sys_calculate_free_frames() ;
  8001aa:	e8 fa 1b 00 00       	call   801da9 <sys_calculate_free_frames>
  8001af:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001b2:	e8 92 1c 00 00       	call   801e49 <sys_pf_calculate_allocated_pages>
  8001b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[2] = malloc(30 * kilo -kilo);
  8001ba:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8001bd:	89 d0                	mov    %edx,%eax
  8001bf:	01 c0                	add    %eax,%eax
  8001c1:	01 d0                	add    %edx,%eax
  8001c3:	01 c0                	add    %eax,%eax
  8001c5:	01 d0                	add    %edx,%eax
  8001c7:	c1 e0 02             	shl    $0x2,%eax
  8001ca:	01 d0                	add    %edx,%eax
  8001cc:	83 ec 0c             	sub    $0xc,%esp
  8001cf:	50                   	push   %eax
  8001d0:	e8 a6 17 00 00       	call   80197b <malloc>
  8001d5:	83 c4 10             	add    $0x10,%esp
  8001d8:	89 45 cc             	mov    %eax,-0x34(%ebp)
		if ((uint32) ptr_allocations[2] !=  (USER_HEAP_START + 120 * kilo)) panic("Wrong start address for the allocated space... ");
  8001db:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001de:	89 c1                	mov    %eax,%ecx
  8001e0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8001e3:	89 d0                	mov    %edx,%eax
  8001e5:	01 c0                	add    %eax,%eax
  8001e7:	01 d0                	add    %edx,%eax
  8001e9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001f0:	01 d0                	add    %edx,%eax
  8001f2:	c1 e0 03             	shl    $0x3,%eax
  8001f5:	05 00 00 00 80       	add    $0x80000000,%eax
  8001fa:	39 c1                	cmp    %eax,%ecx
  8001fc:	74 14                	je     800212 <_main+0x1da>
  8001fe:	83 ec 04             	sub    $0x4,%esp
  800201:	68 44 37 80 00       	push   $0x803744
  800206:	6a 23                	push   $0x23
  800208:	68 74 37 80 00       	push   $0x803774
  80020d:	e8 89 05 00 00       	call   80079b <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800212:	e8 92 1b 00 00       	call   801da9 <sys_calculate_free_frames>
  800217:	89 c2                	mov    %eax,%edx
  800219:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80021c:	39 c2                	cmp    %eax,%edx
  80021e:	74 14                	je     800234 <_main+0x1fc>
  800220:	83 ec 04             	sub    $0x4,%esp
  800223:	68 8c 37 80 00       	push   $0x80378c
  800228:	6a 25                	push   $0x25
  80022a:	68 74 37 80 00       	push   $0x803774
  80022f:	e8 67 05 00 00       	call   80079b <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 8) panic("Extra or less pages are allocated in PageFile");
  800234:	e8 10 1c 00 00       	call   801e49 <sys_pf_calculate_allocated_pages>
  800239:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80023c:	83 f8 08             	cmp    $0x8,%eax
  80023f:	74 14                	je     800255 <_main+0x21d>
  800241:	83 ec 04             	sub    $0x4,%esp
  800244:	68 f8 37 80 00       	push   $0x8037f8
  800249:	6a 26                	push   $0x26
  80024b:	68 74 37 80 00       	push   $0x803774
  800250:	e8 46 05 00 00       	call   80079b <_panic>

		//Allocate 40 KB
		freeFrames = sys_calculate_free_frames() ;
  800255:	e8 4f 1b 00 00       	call   801da9 <sys_calculate_free_frames>
  80025a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80025d:	e8 e7 1b 00 00       	call   801e49 <sys_pf_calculate_allocated_pages>
  800262:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[3] = malloc(40 * kilo -kilo);
  800265:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800268:	89 d0                	mov    %edx,%eax
  80026a:	c1 e0 03             	shl    $0x3,%eax
  80026d:	01 d0                	add    %edx,%eax
  80026f:	01 c0                	add    %eax,%eax
  800271:	01 d0                	add    %edx,%eax
  800273:	01 c0                	add    %eax,%eax
  800275:	01 d0                	add    %edx,%eax
  800277:	83 ec 0c             	sub    $0xc,%esp
  80027a:	50                   	push   %eax
  80027b:	e8 fb 16 00 00       	call   80197b <malloc>
  800280:	83 c4 10             	add    $0x10,%esp
  800283:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if ((uint32) ptr_allocations[3] !=  (USER_HEAP_START + 152 * kilo)) panic("Wrong start address for the allocated space... ");
  800286:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800289:	89 c1                	mov    %eax,%ecx
  80028b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80028e:	89 d0                	mov    %edx,%eax
  800290:	c1 e0 03             	shl    $0x3,%eax
  800293:	01 d0                	add    %edx,%eax
  800295:	01 c0                	add    %eax,%eax
  800297:	01 d0                	add    %edx,%eax
  800299:	c1 e0 03             	shl    $0x3,%eax
  80029c:	05 00 00 00 80       	add    $0x80000000,%eax
  8002a1:	39 c1                	cmp    %eax,%ecx
  8002a3:	74 14                	je     8002b9 <_main+0x281>
  8002a5:	83 ec 04             	sub    $0x4,%esp
  8002a8:	68 44 37 80 00       	push   $0x803744
  8002ad:	6a 2c                	push   $0x2c
  8002af:	68 74 37 80 00       	push   $0x803774
  8002b4:	e8 e2 04 00 00       	call   80079b <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8002b9:	e8 eb 1a 00 00       	call   801da9 <sys_calculate_free_frames>
  8002be:	89 c2                	mov    %eax,%edx
  8002c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002c3:	39 c2                	cmp    %eax,%edx
  8002c5:	74 14                	je     8002db <_main+0x2a3>
  8002c7:	83 ec 04             	sub    $0x4,%esp
  8002ca:	68 8c 37 80 00       	push   $0x80378c
  8002cf:	6a 2e                	push   $0x2e
  8002d1:	68 74 37 80 00       	push   $0x803774
  8002d6:	e8 c0 04 00 00       	call   80079b <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 10) panic("Extra or less pages are allocated in PageFile");
  8002db:	e8 69 1b 00 00       	call   801e49 <sys_pf_calculate_allocated_pages>
  8002e0:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8002e3:	83 f8 0a             	cmp    $0xa,%eax
  8002e6:	74 14                	je     8002fc <_main+0x2c4>
  8002e8:	83 ec 04             	sub    $0x4,%esp
  8002eb:	68 f8 37 80 00       	push   $0x8037f8
  8002f0:	6a 2f                	push   $0x2f
  8002f2:	68 74 37 80 00       	push   $0x803774
  8002f7:	e8 9f 04 00 00       	call   80079b <_panic>


	}


	int cnt = 0;
  8002fc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	//[2] Test Re-allocation
	{
		/*Reallocate the first array (100 KB) to the last hole*/

		//Fill the first array with data
		int *intArr = (int*) ptr_allocations[0];
  800303:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800306:	89 45 dc             	mov    %eax,-0x24(%ebp)
		int lastIndexOfInt1 = (100*kilo)/sizeof(int) - 1;
  800309:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80030c:	89 d0                	mov    %edx,%eax
  80030e:	c1 e0 02             	shl    $0x2,%eax
  800311:	01 d0                	add    %edx,%eax
  800313:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80031a:	01 d0                	add    %edx,%eax
  80031c:	c1 e0 02             	shl    $0x2,%eax
  80031f:	c1 e8 02             	shr    $0x2,%eax
  800322:	48                   	dec    %eax
  800323:	89 45 d8             	mov    %eax,-0x28(%ebp)

		int i = 0;
  800326:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		for (i=0; i < lastIndexOfInt1 ; i++)
  80032d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800334:	eb 17                	jmp    80034d <_main+0x315>
		{
			intArr[i] = i ;
  800336:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800339:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800340:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800343:	01 c2                	add    %eax,%edx
  800345:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800348:	89 02                	mov    %eax,(%edx)
		//Fill the first array with data
		int *intArr = (int*) ptr_allocations[0];
		int lastIndexOfInt1 = (100*kilo)/sizeof(int) - 1;

		int i = 0;
		for (i=0; i < lastIndexOfInt1 ; i++)
  80034a:	ff 45 f4             	incl   -0xc(%ebp)
  80034d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800350:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800353:	7c e1                	jl     800336 <_main+0x2fe>
		{
			intArr[i] = i ;
		}

		//Fill the second array with data
		intArr = (int*) ptr_allocations[1];
  800355:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800358:	89 45 dc             	mov    %eax,-0x24(%ebp)
		lastIndexOfInt1 = (20*kilo)/sizeof(int) - 1;
  80035b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80035e:	89 d0                	mov    %edx,%eax
  800360:	c1 e0 02             	shl    $0x2,%eax
  800363:	01 d0                	add    %edx,%eax
  800365:	c1 e0 02             	shl    $0x2,%eax
  800368:	c1 e8 02             	shr    $0x2,%eax
  80036b:	48                   	dec    %eax
  80036c:	89 45 d8             	mov    %eax,-0x28(%ebp)

		for (i=0; i < lastIndexOfInt1 ; i++)
  80036f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800376:	eb 17                	jmp    80038f <_main+0x357>
		{
			intArr[i] = i ;
  800378:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80037b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800382:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800385:	01 c2                	add    %eax,%edx
  800387:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80038a:	89 02                	mov    %eax,(%edx)

		//Fill the second array with data
		intArr = (int*) ptr_allocations[1];
		lastIndexOfInt1 = (20*kilo)/sizeof(int) - 1;

		for (i=0; i < lastIndexOfInt1 ; i++)
  80038c:	ff 45 f4             	incl   -0xc(%ebp)
  80038f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800392:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800395:	7c e1                	jl     800378 <_main+0x340>
		{
			intArr[i] = i ;
		}

		//Fill the third array with data
		intArr = (int*) ptr_allocations[2];
  800397:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80039a:	89 45 dc             	mov    %eax,-0x24(%ebp)
		lastIndexOfInt1 = (30*kilo)/sizeof(int) - 1;
  80039d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8003a0:	89 d0                	mov    %edx,%eax
  8003a2:	01 c0                	add    %eax,%eax
  8003a4:	01 d0                	add    %edx,%eax
  8003a6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003ad:	01 d0                	add    %edx,%eax
  8003af:	01 c0                	add    %eax,%eax
  8003b1:	c1 e8 02             	shr    $0x2,%eax
  8003b4:	48                   	dec    %eax
  8003b5:	89 45 d8             	mov    %eax,-0x28(%ebp)

		for (i=0; i < lastIndexOfInt1 ; i++)
  8003b8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8003bf:	eb 17                	jmp    8003d8 <_main+0x3a0>
		{
			intArr[i] = i ;
  8003c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003c4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003cb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003ce:	01 c2                	add    %eax,%edx
  8003d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003d3:	89 02                	mov    %eax,(%edx)

		//Fill the third array with data
		intArr = (int*) ptr_allocations[2];
		lastIndexOfInt1 = (30*kilo)/sizeof(int) - 1;

		for (i=0; i < lastIndexOfInt1 ; i++)
  8003d5:	ff 45 f4             	incl   -0xc(%ebp)
  8003d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003db:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8003de:	7c e1                	jl     8003c1 <_main+0x389>
		{
			intArr[i] = i ;
		}

		//Fill the fourth array with data
		intArr = (int*) ptr_allocations[3];
  8003e0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003e3:	89 45 dc             	mov    %eax,-0x24(%ebp)
		lastIndexOfInt1 = (40*kilo)/sizeof(int) - 1;
  8003e6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8003e9:	89 d0                	mov    %edx,%eax
  8003eb:	c1 e0 02             	shl    $0x2,%eax
  8003ee:	01 d0                	add    %edx,%eax
  8003f0:	c1 e0 03             	shl    $0x3,%eax
  8003f3:	c1 e8 02             	shr    $0x2,%eax
  8003f6:	48                   	dec    %eax
  8003f7:	89 45 d8             	mov    %eax,-0x28(%ebp)

		for (i=0; i < lastIndexOfInt1 ; i++)
  8003fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800401:	eb 17                	jmp    80041a <_main+0x3e2>
		{
			intArr[i] = i ;
  800403:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800406:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80040d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800410:	01 c2                	add    %eax,%edx
  800412:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800415:	89 02                	mov    %eax,(%edx)

		//Fill the fourth array with data
		intArr = (int*) ptr_allocations[3];
		lastIndexOfInt1 = (40*kilo)/sizeof(int) - 1;

		for (i=0; i < lastIndexOfInt1 ; i++)
  800417:	ff 45 f4             	incl   -0xc(%ebp)
  80041a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80041d:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800420:	7c e1                	jl     800403 <_main+0x3cb>
			intArr[i] = i ;
		}


		//Reallocate the first array to 200 KB [should be moved to after the fourth one]
		freeFrames = sys_calculate_free_frames() ;
  800422:	e8 82 19 00 00       	call   801da9 <sys_calculate_free_frames>
  800427:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80042a:	e8 1a 1a 00 00       	call   801e49 <sys_pf_calculate_allocated_pages>
  80042f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[0] = realloc(ptr_allocations[0], 200 * kilo - kilo);
  800432:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800435:	89 d0                	mov    %edx,%eax
  800437:	01 c0                	add    %eax,%eax
  800439:	01 d0                	add    %edx,%eax
  80043b:	89 c1                	mov    %eax,%ecx
  80043d:	c1 e1 05             	shl    $0x5,%ecx
  800440:	01 c8                	add    %ecx,%eax
  800442:	01 c0                	add    %eax,%eax
  800444:	01 d0                	add    %edx,%eax
  800446:	89 c2                	mov    %eax,%edx
  800448:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80044b:	83 ec 08             	sub    $0x8,%esp
  80044e:	52                   	push   %edx
  80044f:	50                   	push   %eax
  800450:	e8 d2 17 00 00       	call   801c27 <realloc>
  800455:	83 c4 10             	add    $0x10,%esp
  800458:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[0] != (USER_HEAP_START + 192 * kilo)) panic("Wrong start address for the re-allocated space... ");
  80045b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80045e:	89 c1                	mov    %eax,%ecx
  800460:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800463:	89 d0                	mov    %edx,%eax
  800465:	01 c0                	add    %eax,%eax
  800467:	01 d0                	add    %edx,%eax
  800469:	c1 e0 06             	shl    $0x6,%eax
  80046c:	05 00 00 00 80       	add    $0x80000000,%eax
  800471:	39 c1                	cmp    %eax,%ecx
  800473:	74 14                	je     800489 <_main+0x451>
  800475:	83 ec 04             	sub    $0x4,%esp
  800478:	68 28 38 80 00       	push   $0x803828
  80047d:	6a 6b                	push   $0x6b
  80047f:	68 74 37 80 00       	push   $0x803774
  800484:	e8 12 03 00 00       	call   80079b <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 64) panic("Wrong re-allocation");
		//if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 25) panic("Extra or less pages are re-allocated in PageFile");
  800489:	e8 bb 19 00 00       	call   801e49 <sys_pf_calculate_allocated_pages>
  80048e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800491:	83 f8 19             	cmp    $0x19,%eax
  800494:	74 14                	je     8004aa <_main+0x472>
  800496:	83 ec 04             	sub    $0x4,%esp
  800499:	68 5c 38 80 00       	push   $0x80385c
  80049e:	6a 6e                	push   $0x6e
  8004a0:	68 74 37 80 00       	push   $0x803774
  8004a5:	e8 f1 02 00 00       	call   80079b <_panic>


		vcprintf("\b\b\b50%", NULL);
  8004aa:	83 ec 08             	sub    $0x8,%esp
  8004ad:	6a 00                	push   $0x0
  8004af:	68 8d 38 80 00       	push   $0x80388d
  8004b4:	e8 2b 05 00 00       	call   8009e4 <vcprintf>
  8004b9:	83 c4 10             	add    $0x10,%esp

		//Fill the first array with data
		intArr = (int*) ptr_allocations[0];
  8004bc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8004bf:	89 45 dc             	mov    %eax,-0x24(%ebp)
		lastIndexOfInt1 = (100*kilo)/sizeof(int) - 1;
  8004c2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8004c5:	89 d0                	mov    %edx,%eax
  8004c7:	c1 e0 02             	shl    $0x2,%eax
  8004ca:	01 d0                	add    %edx,%eax
  8004cc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004d3:	01 d0                	add    %edx,%eax
  8004d5:	c1 e0 02             	shl    $0x2,%eax
  8004d8:	c1 e8 02             	shr    $0x2,%eax
  8004db:	48                   	dec    %eax
  8004dc:	89 45 d8             	mov    %eax,-0x28(%ebp)

		for (i=0; i < lastIndexOfInt1 ; i++)
  8004df:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8004e6:	eb 2d                	jmp    800515 <_main+0x4dd>
		{
			if(intArr[i] != i)
  8004e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004eb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004f5:	01 d0                	add    %edx,%eax
  8004f7:	8b 00                	mov    (%eax),%eax
  8004f9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8004fc:	74 14                	je     800512 <_main+0x4da>
				panic("Wrong re-allocation: stored values are wrongly changed!");
  8004fe:	83 ec 04             	sub    $0x4,%esp
  800501:	68 94 38 80 00       	push   $0x803894
  800506:	6a 7a                	push   $0x7a
  800508:	68 74 37 80 00       	push   $0x803774
  80050d:	e8 89 02 00 00       	call   80079b <_panic>

		//Fill the first array with data
		intArr = (int*) ptr_allocations[0];
		lastIndexOfInt1 = (100*kilo)/sizeof(int) - 1;

		for (i=0; i < lastIndexOfInt1 ; i++)
  800512:	ff 45 f4             	incl   -0xc(%ebp)
  800515:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800518:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80051b:	7c cb                	jl     8004e8 <_main+0x4b0>
			if(intArr[i] != i)
				panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//Fill the second array with data
		intArr = (int*) ptr_allocations[1];
  80051d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800520:	89 45 dc             	mov    %eax,-0x24(%ebp)
		lastIndexOfInt1 = (20*kilo)/sizeof(int) - 1;
  800523:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800526:	89 d0                	mov    %edx,%eax
  800528:	c1 e0 02             	shl    $0x2,%eax
  80052b:	01 d0                	add    %edx,%eax
  80052d:	c1 e0 02             	shl    $0x2,%eax
  800530:	c1 e8 02             	shr    $0x2,%eax
  800533:	48                   	dec    %eax
  800534:	89 45 d8             	mov    %eax,-0x28(%ebp)

		for (i=0; i < lastIndexOfInt1 ; i++)
  800537:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80053e:	eb 30                	jmp    800570 <_main+0x538>
		{
			if(intArr[i] != i)
  800540:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800543:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80054a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80054d:	01 d0                	add    %edx,%eax
  80054f:	8b 00                	mov    (%eax),%eax
  800551:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800554:	74 17                	je     80056d <_main+0x535>
				panic("Wrong re-allocation: stored values are wrongly changed!");
  800556:	83 ec 04             	sub    $0x4,%esp
  800559:	68 94 38 80 00       	push   $0x803894
  80055e:	68 84 00 00 00       	push   $0x84
  800563:	68 74 37 80 00       	push   $0x803774
  800568:	e8 2e 02 00 00       	call   80079b <_panic>

		//Fill the second array with data
		intArr = (int*) ptr_allocations[1];
		lastIndexOfInt1 = (20*kilo)/sizeof(int) - 1;

		for (i=0; i < lastIndexOfInt1 ; i++)
  80056d:	ff 45 f4             	incl   -0xc(%ebp)
  800570:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800573:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800576:	7c c8                	jl     800540 <_main+0x508>
			if(intArr[i] != i)
				panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//Fill the third array with data
		intArr = (int*) ptr_allocations[2];
  800578:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80057b:	89 45 dc             	mov    %eax,-0x24(%ebp)
		lastIndexOfInt1 = (30*kilo)/sizeof(int) - 1;
  80057e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800581:	89 d0                	mov    %edx,%eax
  800583:	01 c0                	add    %eax,%eax
  800585:	01 d0                	add    %edx,%eax
  800587:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80058e:	01 d0                	add    %edx,%eax
  800590:	01 c0                	add    %eax,%eax
  800592:	c1 e8 02             	shr    $0x2,%eax
  800595:	48                   	dec    %eax
  800596:	89 45 d8             	mov    %eax,-0x28(%ebp)

		for (i=0; i < lastIndexOfInt1 ; i++)
  800599:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8005a0:	eb 30                	jmp    8005d2 <_main+0x59a>
		{
			if(intArr[i] != i)
  8005a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005a5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005af:	01 d0                	add    %edx,%eax
  8005b1:	8b 00                	mov    (%eax),%eax
  8005b3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8005b6:	74 17                	je     8005cf <_main+0x597>
				panic("Wrong re-allocation: stored values are wrongly changed!");
  8005b8:	83 ec 04             	sub    $0x4,%esp
  8005bb:	68 94 38 80 00       	push   $0x803894
  8005c0:	68 8e 00 00 00       	push   $0x8e
  8005c5:	68 74 37 80 00       	push   $0x803774
  8005ca:	e8 cc 01 00 00       	call   80079b <_panic>

		//Fill the third array with data
		intArr = (int*) ptr_allocations[2];
		lastIndexOfInt1 = (30*kilo)/sizeof(int) - 1;

		for (i=0; i < lastIndexOfInt1 ; i++)
  8005cf:	ff 45 f4             	incl   -0xc(%ebp)
  8005d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005d5:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8005d8:	7c c8                	jl     8005a2 <_main+0x56a>
			if(intArr[i] != i)
				panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//Fill the fourth array with data
		intArr = (int*) ptr_allocations[3];
  8005da:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005dd:	89 45 dc             	mov    %eax,-0x24(%ebp)
		lastIndexOfInt1 = (40*kilo)/sizeof(int) - 1;
  8005e0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8005e3:	89 d0                	mov    %edx,%eax
  8005e5:	c1 e0 02             	shl    $0x2,%eax
  8005e8:	01 d0                	add    %edx,%eax
  8005ea:	c1 e0 03             	shl    $0x3,%eax
  8005ed:	c1 e8 02             	shr    $0x2,%eax
  8005f0:	48                   	dec    %eax
  8005f1:	89 45 d8             	mov    %eax,-0x28(%ebp)

		for (i=0; i < lastIndexOfInt1 ; i++)
  8005f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8005fb:	eb 30                	jmp    80062d <_main+0x5f5>
		{
			if(intArr[i] != i)
  8005fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800600:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800607:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80060a:	01 d0                	add    %edx,%eax
  80060c:	8b 00                	mov    (%eax),%eax
  80060e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800611:	74 17                	je     80062a <_main+0x5f2>
				panic("Wrong re-allocation: stored values are wrongly changed!");
  800613:	83 ec 04             	sub    $0x4,%esp
  800616:	68 94 38 80 00       	push   $0x803894
  80061b:	68 98 00 00 00       	push   $0x98
  800620:	68 74 37 80 00       	push   $0x803774
  800625:	e8 71 01 00 00       	call   80079b <_panic>

		//Fill the fourth array with data
		intArr = (int*) ptr_allocations[3];
		lastIndexOfInt1 = (40*kilo)/sizeof(int) - 1;

		for (i=0; i < lastIndexOfInt1 ; i++)
  80062a:	ff 45 f4             	incl   -0xc(%ebp)
  80062d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800630:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800633:	7c c8                	jl     8005fd <_main+0x5c5>
				panic("Wrong re-allocation: stored values are wrongly changed!");

		}


		vcprintf("\b\b\b100%\n", NULL);
  800635:	83 ec 08             	sub    $0x8,%esp
  800638:	6a 00                	push   $0x0
  80063a:	68 cc 38 80 00       	push   $0x8038cc
  80063f:	e8 a0 03 00 00       	call   8009e4 <vcprintf>
  800644:	83 c4 10             	add    $0x10,%esp
	}



	cprintf("Congratulations!! test realloc [3] completed successfully.\n");
  800647:	83 ec 0c             	sub    $0xc,%esp
  80064a:	68 d8 38 80 00       	push   $0x8038d8
  80064f:	e8 fb 03 00 00       	call   800a4f <cprintf>
  800654:	83 c4 10             	add    $0x10,%esp

	return;
  800657:	90                   	nop
}
  800658:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80065b:	5b                   	pop    %ebx
  80065c:	5f                   	pop    %edi
  80065d:	5d                   	pop    %ebp
  80065e:	c3                   	ret    

0080065f <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80065f:	55                   	push   %ebp
  800660:	89 e5                	mov    %esp,%ebp
  800662:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800665:	e8 1f 1a 00 00       	call   802089 <sys_getenvindex>
  80066a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80066d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800670:	89 d0                	mov    %edx,%eax
  800672:	c1 e0 03             	shl    $0x3,%eax
  800675:	01 d0                	add    %edx,%eax
  800677:	01 c0                	add    %eax,%eax
  800679:	01 d0                	add    %edx,%eax
  80067b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800682:	01 d0                	add    %edx,%eax
  800684:	c1 e0 04             	shl    $0x4,%eax
  800687:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80068c:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800691:	a1 20 50 80 00       	mov    0x805020,%eax
  800696:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80069c:	84 c0                	test   %al,%al
  80069e:	74 0f                	je     8006af <libmain+0x50>
		binaryname = myEnv->prog_name;
  8006a0:	a1 20 50 80 00       	mov    0x805020,%eax
  8006a5:	05 5c 05 00 00       	add    $0x55c,%eax
  8006aa:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006af:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8006b3:	7e 0a                	jle    8006bf <libmain+0x60>
		binaryname = argv[0];
  8006b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006b8:	8b 00                	mov    (%eax),%eax
  8006ba:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8006bf:	83 ec 08             	sub    $0x8,%esp
  8006c2:	ff 75 0c             	pushl  0xc(%ebp)
  8006c5:	ff 75 08             	pushl  0x8(%ebp)
  8006c8:	e8 6b f9 ff ff       	call   800038 <_main>
  8006cd:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8006d0:	e8 c1 17 00 00       	call   801e96 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8006d5:	83 ec 0c             	sub    $0xc,%esp
  8006d8:	68 2c 39 80 00       	push   $0x80392c
  8006dd:	e8 6d 03 00 00       	call   800a4f <cprintf>
  8006e2:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8006e5:	a1 20 50 80 00       	mov    0x805020,%eax
  8006ea:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8006f0:	a1 20 50 80 00       	mov    0x805020,%eax
  8006f5:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8006fb:	83 ec 04             	sub    $0x4,%esp
  8006fe:	52                   	push   %edx
  8006ff:	50                   	push   %eax
  800700:	68 54 39 80 00       	push   $0x803954
  800705:	e8 45 03 00 00       	call   800a4f <cprintf>
  80070a:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80070d:	a1 20 50 80 00       	mov    0x805020,%eax
  800712:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800718:	a1 20 50 80 00       	mov    0x805020,%eax
  80071d:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800723:	a1 20 50 80 00       	mov    0x805020,%eax
  800728:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80072e:	51                   	push   %ecx
  80072f:	52                   	push   %edx
  800730:	50                   	push   %eax
  800731:	68 7c 39 80 00       	push   $0x80397c
  800736:	e8 14 03 00 00       	call   800a4f <cprintf>
  80073b:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80073e:	a1 20 50 80 00       	mov    0x805020,%eax
  800743:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800749:	83 ec 08             	sub    $0x8,%esp
  80074c:	50                   	push   %eax
  80074d:	68 d4 39 80 00       	push   $0x8039d4
  800752:	e8 f8 02 00 00       	call   800a4f <cprintf>
  800757:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80075a:	83 ec 0c             	sub    $0xc,%esp
  80075d:	68 2c 39 80 00       	push   $0x80392c
  800762:	e8 e8 02 00 00       	call   800a4f <cprintf>
  800767:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80076a:	e8 41 17 00 00       	call   801eb0 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80076f:	e8 19 00 00 00       	call   80078d <exit>
}
  800774:	90                   	nop
  800775:	c9                   	leave  
  800776:	c3                   	ret    

00800777 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800777:	55                   	push   %ebp
  800778:	89 e5                	mov    %esp,%ebp
  80077a:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80077d:	83 ec 0c             	sub    $0xc,%esp
  800780:	6a 00                	push   $0x0
  800782:	e8 ce 18 00 00       	call   802055 <sys_destroy_env>
  800787:	83 c4 10             	add    $0x10,%esp
}
  80078a:	90                   	nop
  80078b:	c9                   	leave  
  80078c:	c3                   	ret    

0080078d <exit>:

void
exit(void)
{
  80078d:	55                   	push   %ebp
  80078e:	89 e5                	mov    %esp,%ebp
  800790:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800793:	e8 23 19 00 00       	call   8020bb <sys_exit_env>
}
  800798:	90                   	nop
  800799:	c9                   	leave  
  80079a:	c3                   	ret    

0080079b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80079b:	55                   	push   %ebp
  80079c:	89 e5                	mov    %esp,%ebp
  80079e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8007a1:	8d 45 10             	lea    0x10(%ebp),%eax
  8007a4:	83 c0 04             	add    $0x4,%eax
  8007a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8007aa:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8007af:	85 c0                	test   %eax,%eax
  8007b1:	74 16                	je     8007c9 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8007b3:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8007b8:	83 ec 08             	sub    $0x8,%esp
  8007bb:	50                   	push   %eax
  8007bc:	68 e8 39 80 00       	push   $0x8039e8
  8007c1:	e8 89 02 00 00       	call   800a4f <cprintf>
  8007c6:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8007c9:	a1 00 50 80 00       	mov    0x805000,%eax
  8007ce:	ff 75 0c             	pushl  0xc(%ebp)
  8007d1:	ff 75 08             	pushl  0x8(%ebp)
  8007d4:	50                   	push   %eax
  8007d5:	68 ed 39 80 00       	push   $0x8039ed
  8007da:	e8 70 02 00 00       	call   800a4f <cprintf>
  8007df:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8007e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8007e5:	83 ec 08             	sub    $0x8,%esp
  8007e8:	ff 75 f4             	pushl  -0xc(%ebp)
  8007eb:	50                   	push   %eax
  8007ec:	e8 f3 01 00 00       	call   8009e4 <vcprintf>
  8007f1:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8007f4:	83 ec 08             	sub    $0x8,%esp
  8007f7:	6a 00                	push   $0x0
  8007f9:	68 09 3a 80 00       	push   $0x803a09
  8007fe:	e8 e1 01 00 00       	call   8009e4 <vcprintf>
  800803:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800806:	e8 82 ff ff ff       	call   80078d <exit>

	// should not return here
	while (1) ;
  80080b:	eb fe                	jmp    80080b <_panic+0x70>

0080080d <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80080d:	55                   	push   %ebp
  80080e:	89 e5                	mov    %esp,%ebp
  800810:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800813:	a1 20 50 80 00       	mov    0x805020,%eax
  800818:	8b 50 74             	mov    0x74(%eax),%edx
  80081b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80081e:	39 c2                	cmp    %eax,%edx
  800820:	74 14                	je     800836 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800822:	83 ec 04             	sub    $0x4,%esp
  800825:	68 0c 3a 80 00       	push   $0x803a0c
  80082a:	6a 26                	push   $0x26
  80082c:	68 58 3a 80 00       	push   $0x803a58
  800831:	e8 65 ff ff ff       	call   80079b <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800836:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80083d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800844:	e9 c2 00 00 00       	jmp    80090b <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800849:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80084c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800853:	8b 45 08             	mov    0x8(%ebp),%eax
  800856:	01 d0                	add    %edx,%eax
  800858:	8b 00                	mov    (%eax),%eax
  80085a:	85 c0                	test   %eax,%eax
  80085c:	75 08                	jne    800866 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80085e:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800861:	e9 a2 00 00 00       	jmp    800908 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800866:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80086d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800874:	eb 69                	jmp    8008df <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800876:	a1 20 50 80 00       	mov    0x805020,%eax
  80087b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800881:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800884:	89 d0                	mov    %edx,%eax
  800886:	01 c0                	add    %eax,%eax
  800888:	01 d0                	add    %edx,%eax
  80088a:	c1 e0 03             	shl    $0x3,%eax
  80088d:	01 c8                	add    %ecx,%eax
  80088f:	8a 40 04             	mov    0x4(%eax),%al
  800892:	84 c0                	test   %al,%al
  800894:	75 46                	jne    8008dc <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800896:	a1 20 50 80 00       	mov    0x805020,%eax
  80089b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8008a1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008a4:	89 d0                	mov    %edx,%eax
  8008a6:	01 c0                	add    %eax,%eax
  8008a8:	01 d0                	add    %edx,%eax
  8008aa:	c1 e0 03             	shl    $0x3,%eax
  8008ad:	01 c8                	add    %ecx,%eax
  8008af:	8b 00                	mov    (%eax),%eax
  8008b1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8008b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8008b7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008bc:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8008be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008c1:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8008c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cb:	01 c8                	add    %ecx,%eax
  8008cd:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008cf:	39 c2                	cmp    %eax,%edx
  8008d1:	75 09                	jne    8008dc <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8008d3:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8008da:	eb 12                	jmp    8008ee <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008dc:	ff 45 e8             	incl   -0x18(%ebp)
  8008df:	a1 20 50 80 00       	mov    0x805020,%eax
  8008e4:	8b 50 74             	mov    0x74(%eax),%edx
  8008e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008ea:	39 c2                	cmp    %eax,%edx
  8008ec:	77 88                	ja     800876 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8008ee:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8008f2:	75 14                	jne    800908 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8008f4:	83 ec 04             	sub    $0x4,%esp
  8008f7:	68 64 3a 80 00       	push   $0x803a64
  8008fc:	6a 3a                	push   $0x3a
  8008fe:	68 58 3a 80 00       	push   $0x803a58
  800903:	e8 93 fe ff ff       	call   80079b <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800908:	ff 45 f0             	incl   -0x10(%ebp)
  80090b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80090e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800911:	0f 8c 32 ff ff ff    	jl     800849 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800917:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80091e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800925:	eb 26                	jmp    80094d <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800927:	a1 20 50 80 00       	mov    0x805020,%eax
  80092c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800932:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800935:	89 d0                	mov    %edx,%eax
  800937:	01 c0                	add    %eax,%eax
  800939:	01 d0                	add    %edx,%eax
  80093b:	c1 e0 03             	shl    $0x3,%eax
  80093e:	01 c8                	add    %ecx,%eax
  800940:	8a 40 04             	mov    0x4(%eax),%al
  800943:	3c 01                	cmp    $0x1,%al
  800945:	75 03                	jne    80094a <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800947:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80094a:	ff 45 e0             	incl   -0x20(%ebp)
  80094d:	a1 20 50 80 00       	mov    0x805020,%eax
  800952:	8b 50 74             	mov    0x74(%eax),%edx
  800955:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800958:	39 c2                	cmp    %eax,%edx
  80095a:	77 cb                	ja     800927 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80095c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80095f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800962:	74 14                	je     800978 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800964:	83 ec 04             	sub    $0x4,%esp
  800967:	68 b8 3a 80 00       	push   $0x803ab8
  80096c:	6a 44                	push   $0x44
  80096e:	68 58 3a 80 00       	push   $0x803a58
  800973:	e8 23 fe ff ff       	call   80079b <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800978:	90                   	nop
  800979:	c9                   	leave  
  80097a:	c3                   	ret    

0080097b <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80097b:	55                   	push   %ebp
  80097c:	89 e5                	mov    %esp,%ebp
  80097e:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800981:	8b 45 0c             	mov    0xc(%ebp),%eax
  800984:	8b 00                	mov    (%eax),%eax
  800986:	8d 48 01             	lea    0x1(%eax),%ecx
  800989:	8b 55 0c             	mov    0xc(%ebp),%edx
  80098c:	89 0a                	mov    %ecx,(%edx)
  80098e:	8b 55 08             	mov    0x8(%ebp),%edx
  800991:	88 d1                	mov    %dl,%cl
  800993:	8b 55 0c             	mov    0xc(%ebp),%edx
  800996:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80099a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80099d:	8b 00                	mov    (%eax),%eax
  80099f:	3d ff 00 00 00       	cmp    $0xff,%eax
  8009a4:	75 2c                	jne    8009d2 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8009a6:	a0 24 50 80 00       	mov    0x805024,%al
  8009ab:	0f b6 c0             	movzbl %al,%eax
  8009ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009b1:	8b 12                	mov    (%edx),%edx
  8009b3:	89 d1                	mov    %edx,%ecx
  8009b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009b8:	83 c2 08             	add    $0x8,%edx
  8009bb:	83 ec 04             	sub    $0x4,%esp
  8009be:	50                   	push   %eax
  8009bf:	51                   	push   %ecx
  8009c0:	52                   	push   %edx
  8009c1:	e8 22 13 00 00       	call   801ce8 <sys_cputs>
  8009c6:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8009c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8009d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009d5:	8b 40 04             	mov    0x4(%eax),%eax
  8009d8:	8d 50 01             	lea    0x1(%eax),%edx
  8009db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009de:	89 50 04             	mov    %edx,0x4(%eax)
}
  8009e1:	90                   	nop
  8009e2:	c9                   	leave  
  8009e3:	c3                   	ret    

008009e4 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8009e4:	55                   	push   %ebp
  8009e5:	89 e5                	mov    %esp,%ebp
  8009e7:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8009ed:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8009f4:	00 00 00 
	b.cnt = 0;
  8009f7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8009fe:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800a01:	ff 75 0c             	pushl  0xc(%ebp)
  800a04:	ff 75 08             	pushl  0x8(%ebp)
  800a07:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a0d:	50                   	push   %eax
  800a0e:	68 7b 09 80 00       	push   $0x80097b
  800a13:	e8 11 02 00 00       	call   800c29 <vprintfmt>
  800a18:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800a1b:	a0 24 50 80 00       	mov    0x805024,%al
  800a20:	0f b6 c0             	movzbl %al,%eax
  800a23:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800a29:	83 ec 04             	sub    $0x4,%esp
  800a2c:	50                   	push   %eax
  800a2d:	52                   	push   %edx
  800a2e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a34:	83 c0 08             	add    $0x8,%eax
  800a37:	50                   	push   %eax
  800a38:	e8 ab 12 00 00       	call   801ce8 <sys_cputs>
  800a3d:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a40:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800a47:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a4d:	c9                   	leave  
  800a4e:	c3                   	ret    

00800a4f <cprintf>:

int cprintf(const char *fmt, ...) {
  800a4f:	55                   	push   %ebp
  800a50:	89 e5                	mov    %esp,%ebp
  800a52:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a55:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800a5c:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a62:	8b 45 08             	mov    0x8(%ebp),%eax
  800a65:	83 ec 08             	sub    $0x8,%esp
  800a68:	ff 75 f4             	pushl  -0xc(%ebp)
  800a6b:	50                   	push   %eax
  800a6c:	e8 73 ff ff ff       	call   8009e4 <vcprintf>
  800a71:	83 c4 10             	add    $0x10,%esp
  800a74:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a77:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a7a:	c9                   	leave  
  800a7b:	c3                   	ret    

00800a7c <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800a7c:	55                   	push   %ebp
  800a7d:	89 e5                	mov    %esp,%ebp
  800a7f:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a82:	e8 0f 14 00 00       	call   801e96 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a87:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a90:	83 ec 08             	sub    $0x8,%esp
  800a93:	ff 75 f4             	pushl  -0xc(%ebp)
  800a96:	50                   	push   %eax
  800a97:	e8 48 ff ff ff       	call   8009e4 <vcprintf>
  800a9c:	83 c4 10             	add    $0x10,%esp
  800a9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800aa2:	e8 09 14 00 00       	call   801eb0 <sys_enable_interrupt>
	return cnt;
  800aa7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800aaa:	c9                   	leave  
  800aab:	c3                   	ret    

00800aac <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800aac:	55                   	push   %ebp
  800aad:	89 e5                	mov    %esp,%ebp
  800aaf:	53                   	push   %ebx
  800ab0:	83 ec 14             	sub    $0x14,%esp
  800ab3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ab6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ab9:	8b 45 14             	mov    0x14(%ebp),%eax
  800abc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800abf:	8b 45 18             	mov    0x18(%ebp),%eax
  800ac2:	ba 00 00 00 00       	mov    $0x0,%edx
  800ac7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800aca:	77 55                	ja     800b21 <printnum+0x75>
  800acc:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800acf:	72 05                	jb     800ad6 <printnum+0x2a>
  800ad1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800ad4:	77 4b                	ja     800b21 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800ad6:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800ad9:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800adc:	8b 45 18             	mov    0x18(%ebp),%eax
  800adf:	ba 00 00 00 00       	mov    $0x0,%edx
  800ae4:	52                   	push   %edx
  800ae5:	50                   	push   %eax
  800ae6:	ff 75 f4             	pushl  -0xc(%ebp)
  800ae9:	ff 75 f0             	pushl  -0x10(%ebp)
  800aec:	e8 b3 29 00 00       	call   8034a4 <__udivdi3>
  800af1:	83 c4 10             	add    $0x10,%esp
  800af4:	83 ec 04             	sub    $0x4,%esp
  800af7:	ff 75 20             	pushl  0x20(%ebp)
  800afa:	53                   	push   %ebx
  800afb:	ff 75 18             	pushl  0x18(%ebp)
  800afe:	52                   	push   %edx
  800aff:	50                   	push   %eax
  800b00:	ff 75 0c             	pushl  0xc(%ebp)
  800b03:	ff 75 08             	pushl  0x8(%ebp)
  800b06:	e8 a1 ff ff ff       	call   800aac <printnum>
  800b0b:	83 c4 20             	add    $0x20,%esp
  800b0e:	eb 1a                	jmp    800b2a <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800b10:	83 ec 08             	sub    $0x8,%esp
  800b13:	ff 75 0c             	pushl  0xc(%ebp)
  800b16:	ff 75 20             	pushl  0x20(%ebp)
  800b19:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1c:	ff d0                	call   *%eax
  800b1e:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b21:	ff 4d 1c             	decl   0x1c(%ebp)
  800b24:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800b28:	7f e6                	jg     800b10 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800b2a:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800b2d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b35:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b38:	53                   	push   %ebx
  800b39:	51                   	push   %ecx
  800b3a:	52                   	push   %edx
  800b3b:	50                   	push   %eax
  800b3c:	e8 73 2a 00 00       	call   8035b4 <__umoddi3>
  800b41:	83 c4 10             	add    $0x10,%esp
  800b44:	05 34 3d 80 00       	add    $0x803d34,%eax
  800b49:	8a 00                	mov    (%eax),%al
  800b4b:	0f be c0             	movsbl %al,%eax
  800b4e:	83 ec 08             	sub    $0x8,%esp
  800b51:	ff 75 0c             	pushl  0xc(%ebp)
  800b54:	50                   	push   %eax
  800b55:	8b 45 08             	mov    0x8(%ebp),%eax
  800b58:	ff d0                	call   *%eax
  800b5a:	83 c4 10             	add    $0x10,%esp
}
  800b5d:	90                   	nop
  800b5e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b61:	c9                   	leave  
  800b62:	c3                   	ret    

00800b63 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b63:	55                   	push   %ebp
  800b64:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b66:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b6a:	7e 1c                	jle    800b88 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6f:	8b 00                	mov    (%eax),%eax
  800b71:	8d 50 08             	lea    0x8(%eax),%edx
  800b74:	8b 45 08             	mov    0x8(%ebp),%eax
  800b77:	89 10                	mov    %edx,(%eax)
  800b79:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7c:	8b 00                	mov    (%eax),%eax
  800b7e:	83 e8 08             	sub    $0x8,%eax
  800b81:	8b 50 04             	mov    0x4(%eax),%edx
  800b84:	8b 00                	mov    (%eax),%eax
  800b86:	eb 40                	jmp    800bc8 <getuint+0x65>
	else if (lflag)
  800b88:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b8c:	74 1e                	je     800bac <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b91:	8b 00                	mov    (%eax),%eax
  800b93:	8d 50 04             	lea    0x4(%eax),%edx
  800b96:	8b 45 08             	mov    0x8(%ebp),%eax
  800b99:	89 10                	mov    %edx,(%eax)
  800b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9e:	8b 00                	mov    (%eax),%eax
  800ba0:	83 e8 04             	sub    $0x4,%eax
  800ba3:	8b 00                	mov    (%eax),%eax
  800ba5:	ba 00 00 00 00       	mov    $0x0,%edx
  800baa:	eb 1c                	jmp    800bc8 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800bac:	8b 45 08             	mov    0x8(%ebp),%eax
  800baf:	8b 00                	mov    (%eax),%eax
  800bb1:	8d 50 04             	lea    0x4(%eax),%edx
  800bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb7:	89 10                	mov    %edx,(%eax)
  800bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbc:	8b 00                	mov    (%eax),%eax
  800bbe:	83 e8 04             	sub    $0x4,%eax
  800bc1:	8b 00                	mov    (%eax),%eax
  800bc3:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800bc8:	5d                   	pop    %ebp
  800bc9:	c3                   	ret    

00800bca <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800bca:	55                   	push   %ebp
  800bcb:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800bcd:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800bd1:	7e 1c                	jle    800bef <getint+0x25>
		return va_arg(*ap, long long);
  800bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd6:	8b 00                	mov    (%eax),%eax
  800bd8:	8d 50 08             	lea    0x8(%eax),%edx
  800bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bde:	89 10                	mov    %edx,(%eax)
  800be0:	8b 45 08             	mov    0x8(%ebp),%eax
  800be3:	8b 00                	mov    (%eax),%eax
  800be5:	83 e8 08             	sub    $0x8,%eax
  800be8:	8b 50 04             	mov    0x4(%eax),%edx
  800beb:	8b 00                	mov    (%eax),%eax
  800bed:	eb 38                	jmp    800c27 <getint+0x5d>
	else if (lflag)
  800bef:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bf3:	74 1a                	je     800c0f <getint+0x45>
		return va_arg(*ap, long);
  800bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf8:	8b 00                	mov    (%eax),%eax
  800bfa:	8d 50 04             	lea    0x4(%eax),%edx
  800bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800c00:	89 10                	mov    %edx,(%eax)
  800c02:	8b 45 08             	mov    0x8(%ebp),%eax
  800c05:	8b 00                	mov    (%eax),%eax
  800c07:	83 e8 04             	sub    $0x4,%eax
  800c0a:	8b 00                	mov    (%eax),%eax
  800c0c:	99                   	cltd   
  800c0d:	eb 18                	jmp    800c27 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c12:	8b 00                	mov    (%eax),%eax
  800c14:	8d 50 04             	lea    0x4(%eax),%edx
  800c17:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1a:	89 10                	mov    %edx,(%eax)
  800c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1f:	8b 00                	mov    (%eax),%eax
  800c21:	83 e8 04             	sub    $0x4,%eax
  800c24:	8b 00                	mov    (%eax),%eax
  800c26:	99                   	cltd   
}
  800c27:	5d                   	pop    %ebp
  800c28:	c3                   	ret    

00800c29 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c29:	55                   	push   %ebp
  800c2a:	89 e5                	mov    %esp,%ebp
  800c2c:	56                   	push   %esi
  800c2d:	53                   	push   %ebx
  800c2e:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c31:	eb 17                	jmp    800c4a <vprintfmt+0x21>
			if (ch == '\0')
  800c33:	85 db                	test   %ebx,%ebx
  800c35:	0f 84 af 03 00 00    	je     800fea <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800c3b:	83 ec 08             	sub    $0x8,%esp
  800c3e:	ff 75 0c             	pushl  0xc(%ebp)
  800c41:	53                   	push   %ebx
  800c42:	8b 45 08             	mov    0x8(%ebp),%eax
  800c45:	ff d0                	call   *%eax
  800c47:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c4a:	8b 45 10             	mov    0x10(%ebp),%eax
  800c4d:	8d 50 01             	lea    0x1(%eax),%edx
  800c50:	89 55 10             	mov    %edx,0x10(%ebp)
  800c53:	8a 00                	mov    (%eax),%al
  800c55:	0f b6 d8             	movzbl %al,%ebx
  800c58:	83 fb 25             	cmp    $0x25,%ebx
  800c5b:	75 d6                	jne    800c33 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c5d:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800c61:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800c68:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c6f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c76:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c7d:	8b 45 10             	mov    0x10(%ebp),%eax
  800c80:	8d 50 01             	lea    0x1(%eax),%edx
  800c83:	89 55 10             	mov    %edx,0x10(%ebp)
  800c86:	8a 00                	mov    (%eax),%al
  800c88:	0f b6 d8             	movzbl %al,%ebx
  800c8b:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c8e:	83 f8 55             	cmp    $0x55,%eax
  800c91:	0f 87 2b 03 00 00    	ja     800fc2 <vprintfmt+0x399>
  800c97:	8b 04 85 58 3d 80 00 	mov    0x803d58(,%eax,4),%eax
  800c9e:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800ca0:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800ca4:	eb d7                	jmp    800c7d <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800ca6:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800caa:	eb d1                	jmp    800c7d <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cac:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800cb3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800cb6:	89 d0                	mov    %edx,%eax
  800cb8:	c1 e0 02             	shl    $0x2,%eax
  800cbb:	01 d0                	add    %edx,%eax
  800cbd:	01 c0                	add    %eax,%eax
  800cbf:	01 d8                	add    %ebx,%eax
  800cc1:	83 e8 30             	sub    $0x30,%eax
  800cc4:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800cc7:	8b 45 10             	mov    0x10(%ebp),%eax
  800cca:	8a 00                	mov    (%eax),%al
  800ccc:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ccf:	83 fb 2f             	cmp    $0x2f,%ebx
  800cd2:	7e 3e                	jle    800d12 <vprintfmt+0xe9>
  800cd4:	83 fb 39             	cmp    $0x39,%ebx
  800cd7:	7f 39                	jg     800d12 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cd9:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800cdc:	eb d5                	jmp    800cb3 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800cde:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce1:	83 c0 04             	add    $0x4,%eax
  800ce4:	89 45 14             	mov    %eax,0x14(%ebp)
  800ce7:	8b 45 14             	mov    0x14(%ebp),%eax
  800cea:	83 e8 04             	sub    $0x4,%eax
  800ced:	8b 00                	mov    (%eax),%eax
  800cef:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800cf2:	eb 1f                	jmp    800d13 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800cf4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cf8:	79 83                	jns    800c7d <vprintfmt+0x54>
				width = 0;
  800cfa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800d01:	e9 77 ff ff ff       	jmp    800c7d <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800d06:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800d0d:	e9 6b ff ff ff       	jmp    800c7d <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800d12:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d13:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d17:	0f 89 60 ff ff ff    	jns    800c7d <vprintfmt+0x54>
				width = precision, precision = -1;
  800d1d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d20:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d23:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800d2a:	e9 4e ff ff ff       	jmp    800c7d <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d2f:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800d32:	e9 46 ff ff ff       	jmp    800c7d <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800d37:	8b 45 14             	mov    0x14(%ebp),%eax
  800d3a:	83 c0 04             	add    $0x4,%eax
  800d3d:	89 45 14             	mov    %eax,0x14(%ebp)
  800d40:	8b 45 14             	mov    0x14(%ebp),%eax
  800d43:	83 e8 04             	sub    $0x4,%eax
  800d46:	8b 00                	mov    (%eax),%eax
  800d48:	83 ec 08             	sub    $0x8,%esp
  800d4b:	ff 75 0c             	pushl  0xc(%ebp)
  800d4e:	50                   	push   %eax
  800d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d52:	ff d0                	call   *%eax
  800d54:	83 c4 10             	add    $0x10,%esp
			break;
  800d57:	e9 89 02 00 00       	jmp    800fe5 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d5c:	8b 45 14             	mov    0x14(%ebp),%eax
  800d5f:	83 c0 04             	add    $0x4,%eax
  800d62:	89 45 14             	mov    %eax,0x14(%ebp)
  800d65:	8b 45 14             	mov    0x14(%ebp),%eax
  800d68:	83 e8 04             	sub    $0x4,%eax
  800d6b:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800d6d:	85 db                	test   %ebx,%ebx
  800d6f:	79 02                	jns    800d73 <vprintfmt+0x14a>
				err = -err;
  800d71:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d73:	83 fb 64             	cmp    $0x64,%ebx
  800d76:	7f 0b                	jg     800d83 <vprintfmt+0x15a>
  800d78:	8b 34 9d a0 3b 80 00 	mov    0x803ba0(,%ebx,4),%esi
  800d7f:	85 f6                	test   %esi,%esi
  800d81:	75 19                	jne    800d9c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d83:	53                   	push   %ebx
  800d84:	68 45 3d 80 00       	push   $0x803d45
  800d89:	ff 75 0c             	pushl  0xc(%ebp)
  800d8c:	ff 75 08             	pushl  0x8(%ebp)
  800d8f:	e8 5e 02 00 00       	call   800ff2 <printfmt>
  800d94:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d97:	e9 49 02 00 00       	jmp    800fe5 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d9c:	56                   	push   %esi
  800d9d:	68 4e 3d 80 00       	push   $0x803d4e
  800da2:	ff 75 0c             	pushl  0xc(%ebp)
  800da5:	ff 75 08             	pushl  0x8(%ebp)
  800da8:	e8 45 02 00 00       	call   800ff2 <printfmt>
  800dad:	83 c4 10             	add    $0x10,%esp
			break;
  800db0:	e9 30 02 00 00       	jmp    800fe5 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800db5:	8b 45 14             	mov    0x14(%ebp),%eax
  800db8:	83 c0 04             	add    $0x4,%eax
  800dbb:	89 45 14             	mov    %eax,0x14(%ebp)
  800dbe:	8b 45 14             	mov    0x14(%ebp),%eax
  800dc1:	83 e8 04             	sub    $0x4,%eax
  800dc4:	8b 30                	mov    (%eax),%esi
  800dc6:	85 f6                	test   %esi,%esi
  800dc8:	75 05                	jne    800dcf <vprintfmt+0x1a6>
				p = "(null)";
  800dca:	be 51 3d 80 00       	mov    $0x803d51,%esi
			if (width > 0 && padc != '-')
  800dcf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dd3:	7e 6d                	jle    800e42 <vprintfmt+0x219>
  800dd5:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800dd9:	74 67                	je     800e42 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ddb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800dde:	83 ec 08             	sub    $0x8,%esp
  800de1:	50                   	push   %eax
  800de2:	56                   	push   %esi
  800de3:	e8 0c 03 00 00       	call   8010f4 <strnlen>
  800de8:	83 c4 10             	add    $0x10,%esp
  800deb:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800dee:	eb 16                	jmp    800e06 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800df0:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800df4:	83 ec 08             	sub    $0x8,%esp
  800df7:	ff 75 0c             	pushl  0xc(%ebp)
  800dfa:	50                   	push   %eax
  800dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfe:	ff d0                	call   *%eax
  800e00:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e03:	ff 4d e4             	decl   -0x1c(%ebp)
  800e06:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e0a:	7f e4                	jg     800df0 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e0c:	eb 34                	jmp    800e42 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800e0e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800e12:	74 1c                	je     800e30 <vprintfmt+0x207>
  800e14:	83 fb 1f             	cmp    $0x1f,%ebx
  800e17:	7e 05                	jle    800e1e <vprintfmt+0x1f5>
  800e19:	83 fb 7e             	cmp    $0x7e,%ebx
  800e1c:	7e 12                	jle    800e30 <vprintfmt+0x207>
					putch('?', putdat);
  800e1e:	83 ec 08             	sub    $0x8,%esp
  800e21:	ff 75 0c             	pushl  0xc(%ebp)
  800e24:	6a 3f                	push   $0x3f
  800e26:	8b 45 08             	mov    0x8(%ebp),%eax
  800e29:	ff d0                	call   *%eax
  800e2b:	83 c4 10             	add    $0x10,%esp
  800e2e:	eb 0f                	jmp    800e3f <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800e30:	83 ec 08             	sub    $0x8,%esp
  800e33:	ff 75 0c             	pushl  0xc(%ebp)
  800e36:	53                   	push   %ebx
  800e37:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3a:	ff d0                	call   *%eax
  800e3c:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e3f:	ff 4d e4             	decl   -0x1c(%ebp)
  800e42:	89 f0                	mov    %esi,%eax
  800e44:	8d 70 01             	lea    0x1(%eax),%esi
  800e47:	8a 00                	mov    (%eax),%al
  800e49:	0f be d8             	movsbl %al,%ebx
  800e4c:	85 db                	test   %ebx,%ebx
  800e4e:	74 24                	je     800e74 <vprintfmt+0x24b>
  800e50:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e54:	78 b8                	js     800e0e <vprintfmt+0x1e5>
  800e56:	ff 4d e0             	decl   -0x20(%ebp)
  800e59:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e5d:	79 af                	jns    800e0e <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e5f:	eb 13                	jmp    800e74 <vprintfmt+0x24b>
				putch(' ', putdat);
  800e61:	83 ec 08             	sub    $0x8,%esp
  800e64:	ff 75 0c             	pushl  0xc(%ebp)
  800e67:	6a 20                	push   $0x20
  800e69:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6c:	ff d0                	call   *%eax
  800e6e:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e71:	ff 4d e4             	decl   -0x1c(%ebp)
  800e74:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e78:	7f e7                	jg     800e61 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e7a:	e9 66 01 00 00       	jmp    800fe5 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e7f:	83 ec 08             	sub    $0x8,%esp
  800e82:	ff 75 e8             	pushl  -0x18(%ebp)
  800e85:	8d 45 14             	lea    0x14(%ebp),%eax
  800e88:	50                   	push   %eax
  800e89:	e8 3c fd ff ff       	call   800bca <getint>
  800e8e:	83 c4 10             	add    $0x10,%esp
  800e91:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e94:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e9d:	85 d2                	test   %edx,%edx
  800e9f:	79 23                	jns    800ec4 <vprintfmt+0x29b>
				putch('-', putdat);
  800ea1:	83 ec 08             	sub    $0x8,%esp
  800ea4:	ff 75 0c             	pushl  0xc(%ebp)
  800ea7:	6a 2d                	push   $0x2d
  800ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eac:	ff d0                	call   *%eax
  800eae:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800eb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eb4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eb7:	f7 d8                	neg    %eax
  800eb9:	83 d2 00             	adc    $0x0,%edx
  800ebc:	f7 da                	neg    %edx
  800ebe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ec1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ec4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ecb:	e9 bc 00 00 00       	jmp    800f8c <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ed0:	83 ec 08             	sub    $0x8,%esp
  800ed3:	ff 75 e8             	pushl  -0x18(%ebp)
  800ed6:	8d 45 14             	lea    0x14(%ebp),%eax
  800ed9:	50                   	push   %eax
  800eda:	e8 84 fc ff ff       	call   800b63 <getuint>
  800edf:	83 c4 10             	add    $0x10,%esp
  800ee2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ee5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ee8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800eef:	e9 98 00 00 00       	jmp    800f8c <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ef4:	83 ec 08             	sub    $0x8,%esp
  800ef7:	ff 75 0c             	pushl  0xc(%ebp)
  800efa:	6a 58                	push   $0x58
  800efc:	8b 45 08             	mov    0x8(%ebp),%eax
  800eff:	ff d0                	call   *%eax
  800f01:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f04:	83 ec 08             	sub    $0x8,%esp
  800f07:	ff 75 0c             	pushl  0xc(%ebp)
  800f0a:	6a 58                	push   $0x58
  800f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0f:	ff d0                	call   *%eax
  800f11:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f14:	83 ec 08             	sub    $0x8,%esp
  800f17:	ff 75 0c             	pushl  0xc(%ebp)
  800f1a:	6a 58                	push   $0x58
  800f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1f:	ff d0                	call   *%eax
  800f21:	83 c4 10             	add    $0x10,%esp
			break;
  800f24:	e9 bc 00 00 00       	jmp    800fe5 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800f29:	83 ec 08             	sub    $0x8,%esp
  800f2c:	ff 75 0c             	pushl  0xc(%ebp)
  800f2f:	6a 30                	push   $0x30
  800f31:	8b 45 08             	mov    0x8(%ebp),%eax
  800f34:	ff d0                	call   *%eax
  800f36:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800f39:	83 ec 08             	sub    $0x8,%esp
  800f3c:	ff 75 0c             	pushl  0xc(%ebp)
  800f3f:	6a 78                	push   $0x78
  800f41:	8b 45 08             	mov    0x8(%ebp),%eax
  800f44:	ff d0                	call   *%eax
  800f46:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800f49:	8b 45 14             	mov    0x14(%ebp),%eax
  800f4c:	83 c0 04             	add    $0x4,%eax
  800f4f:	89 45 14             	mov    %eax,0x14(%ebp)
  800f52:	8b 45 14             	mov    0x14(%ebp),%eax
  800f55:	83 e8 04             	sub    $0x4,%eax
  800f58:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f5d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800f64:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800f6b:	eb 1f                	jmp    800f8c <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f6d:	83 ec 08             	sub    $0x8,%esp
  800f70:	ff 75 e8             	pushl  -0x18(%ebp)
  800f73:	8d 45 14             	lea    0x14(%ebp),%eax
  800f76:	50                   	push   %eax
  800f77:	e8 e7 fb ff ff       	call   800b63 <getuint>
  800f7c:	83 c4 10             	add    $0x10,%esp
  800f7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f82:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f85:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f8c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f93:	83 ec 04             	sub    $0x4,%esp
  800f96:	52                   	push   %edx
  800f97:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f9a:	50                   	push   %eax
  800f9b:	ff 75 f4             	pushl  -0xc(%ebp)
  800f9e:	ff 75 f0             	pushl  -0x10(%ebp)
  800fa1:	ff 75 0c             	pushl  0xc(%ebp)
  800fa4:	ff 75 08             	pushl  0x8(%ebp)
  800fa7:	e8 00 fb ff ff       	call   800aac <printnum>
  800fac:	83 c4 20             	add    $0x20,%esp
			break;
  800faf:	eb 34                	jmp    800fe5 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800fb1:	83 ec 08             	sub    $0x8,%esp
  800fb4:	ff 75 0c             	pushl  0xc(%ebp)
  800fb7:	53                   	push   %ebx
  800fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbb:	ff d0                	call   *%eax
  800fbd:	83 c4 10             	add    $0x10,%esp
			break;
  800fc0:	eb 23                	jmp    800fe5 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800fc2:	83 ec 08             	sub    $0x8,%esp
  800fc5:	ff 75 0c             	pushl  0xc(%ebp)
  800fc8:	6a 25                	push   $0x25
  800fca:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcd:	ff d0                	call   *%eax
  800fcf:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800fd2:	ff 4d 10             	decl   0x10(%ebp)
  800fd5:	eb 03                	jmp    800fda <vprintfmt+0x3b1>
  800fd7:	ff 4d 10             	decl   0x10(%ebp)
  800fda:	8b 45 10             	mov    0x10(%ebp),%eax
  800fdd:	48                   	dec    %eax
  800fde:	8a 00                	mov    (%eax),%al
  800fe0:	3c 25                	cmp    $0x25,%al
  800fe2:	75 f3                	jne    800fd7 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800fe4:	90                   	nop
		}
	}
  800fe5:	e9 47 fc ff ff       	jmp    800c31 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800fea:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800feb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800fee:	5b                   	pop    %ebx
  800fef:	5e                   	pop    %esi
  800ff0:	5d                   	pop    %ebp
  800ff1:	c3                   	ret    

00800ff2 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ff2:	55                   	push   %ebp
  800ff3:	89 e5                	mov    %esp,%ebp
  800ff5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ff8:	8d 45 10             	lea    0x10(%ebp),%eax
  800ffb:	83 c0 04             	add    $0x4,%eax
  800ffe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801001:	8b 45 10             	mov    0x10(%ebp),%eax
  801004:	ff 75 f4             	pushl  -0xc(%ebp)
  801007:	50                   	push   %eax
  801008:	ff 75 0c             	pushl  0xc(%ebp)
  80100b:	ff 75 08             	pushl  0x8(%ebp)
  80100e:	e8 16 fc ff ff       	call   800c29 <vprintfmt>
  801013:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801016:	90                   	nop
  801017:	c9                   	leave  
  801018:	c3                   	ret    

00801019 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801019:	55                   	push   %ebp
  80101a:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80101c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101f:	8b 40 08             	mov    0x8(%eax),%eax
  801022:	8d 50 01             	lea    0x1(%eax),%edx
  801025:	8b 45 0c             	mov    0xc(%ebp),%eax
  801028:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80102b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102e:	8b 10                	mov    (%eax),%edx
  801030:	8b 45 0c             	mov    0xc(%ebp),%eax
  801033:	8b 40 04             	mov    0x4(%eax),%eax
  801036:	39 c2                	cmp    %eax,%edx
  801038:	73 12                	jae    80104c <sprintputch+0x33>
		*b->buf++ = ch;
  80103a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103d:	8b 00                	mov    (%eax),%eax
  80103f:	8d 48 01             	lea    0x1(%eax),%ecx
  801042:	8b 55 0c             	mov    0xc(%ebp),%edx
  801045:	89 0a                	mov    %ecx,(%edx)
  801047:	8b 55 08             	mov    0x8(%ebp),%edx
  80104a:	88 10                	mov    %dl,(%eax)
}
  80104c:	90                   	nop
  80104d:	5d                   	pop    %ebp
  80104e:	c3                   	ret    

0080104f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80104f:	55                   	push   %ebp
  801050:	89 e5                	mov    %esp,%ebp
  801052:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801055:	8b 45 08             	mov    0x8(%ebp),%eax
  801058:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80105b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801061:	8b 45 08             	mov    0x8(%ebp),%eax
  801064:	01 d0                	add    %edx,%eax
  801066:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801069:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801070:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801074:	74 06                	je     80107c <vsnprintf+0x2d>
  801076:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80107a:	7f 07                	jg     801083 <vsnprintf+0x34>
		return -E_INVAL;
  80107c:	b8 03 00 00 00       	mov    $0x3,%eax
  801081:	eb 20                	jmp    8010a3 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801083:	ff 75 14             	pushl  0x14(%ebp)
  801086:	ff 75 10             	pushl  0x10(%ebp)
  801089:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80108c:	50                   	push   %eax
  80108d:	68 19 10 80 00       	push   $0x801019
  801092:	e8 92 fb ff ff       	call   800c29 <vprintfmt>
  801097:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80109a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80109d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8010a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8010a3:	c9                   	leave  
  8010a4:	c3                   	ret    

008010a5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8010a5:	55                   	push   %ebp
  8010a6:	89 e5                	mov    %esp,%ebp
  8010a8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8010ab:	8d 45 10             	lea    0x10(%ebp),%eax
  8010ae:	83 c0 04             	add    $0x4,%eax
  8010b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8010b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b7:	ff 75 f4             	pushl  -0xc(%ebp)
  8010ba:	50                   	push   %eax
  8010bb:	ff 75 0c             	pushl  0xc(%ebp)
  8010be:	ff 75 08             	pushl  0x8(%ebp)
  8010c1:	e8 89 ff ff ff       	call   80104f <vsnprintf>
  8010c6:	83 c4 10             	add    $0x10,%esp
  8010c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8010cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010cf:	c9                   	leave  
  8010d0:	c3                   	ret    

008010d1 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8010d1:	55                   	push   %ebp
  8010d2:	89 e5                	mov    %esp,%ebp
  8010d4:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8010d7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010de:	eb 06                	jmp    8010e6 <strlen+0x15>
		n++;
  8010e0:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8010e3:	ff 45 08             	incl   0x8(%ebp)
  8010e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e9:	8a 00                	mov    (%eax),%al
  8010eb:	84 c0                	test   %al,%al
  8010ed:	75 f1                	jne    8010e0 <strlen+0xf>
		n++;
	return n;
  8010ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010f2:	c9                   	leave  
  8010f3:	c3                   	ret    

008010f4 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8010f4:	55                   	push   %ebp
  8010f5:	89 e5                	mov    %esp,%ebp
  8010f7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010fa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801101:	eb 09                	jmp    80110c <strnlen+0x18>
		n++;
  801103:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801106:	ff 45 08             	incl   0x8(%ebp)
  801109:	ff 4d 0c             	decl   0xc(%ebp)
  80110c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801110:	74 09                	je     80111b <strnlen+0x27>
  801112:	8b 45 08             	mov    0x8(%ebp),%eax
  801115:	8a 00                	mov    (%eax),%al
  801117:	84 c0                	test   %al,%al
  801119:	75 e8                	jne    801103 <strnlen+0xf>
		n++;
	return n;
  80111b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80111e:	c9                   	leave  
  80111f:	c3                   	ret    

00801120 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801120:	55                   	push   %ebp
  801121:	89 e5                	mov    %esp,%ebp
  801123:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801126:	8b 45 08             	mov    0x8(%ebp),%eax
  801129:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80112c:	90                   	nop
  80112d:	8b 45 08             	mov    0x8(%ebp),%eax
  801130:	8d 50 01             	lea    0x1(%eax),%edx
  801133:	89 55 08             	mov    %edx,0x8(%ebp)
  801136:	8b 55 0c             	mov    0xc(%ebp),%edx
  801139:	8d 4a 01             	lea    0x1(%edx),%ecx
  80113c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80113f:	8a 12                	mov    (%edx),%dl
  801141:	88 10                	mov    %dl,(%eax)
  801143:	8a 00                	mov    (%eax),%al
  801145:	84 c0                	test   %al,%al
  801147:	75 e4                	jne    80112d <strcpy+0xd>
		/* do nothing */;
	return ret;
  801149:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80114c:	c9                   	leave  
  80114d:	c3                   	ret    

0080114e <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80114e:	55                   	push   %ebp
  80114f:	89 e5                	mov    %esp,%ebp
  801151:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801154:	8b 45 08             	mov    0x8(%ebp),%eax
  801157:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80115a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801161:	eb 1f                	jmp    801182 <strncpy+0x34>
		*dst++ = *src;
  801163:	8b 45 08             	mov    0x8(%ebp),%eax
  801166:	8d 50 01             	lea    0x1(%eax),%edx
  801169:	89 55 08             	mov    %edx,0x8(%ebp)
  80116c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80116f:	8a 12                	mov    (%edx),%dl
  801171:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801173:	8b 45 0c             	mov    0xc(%ebp),%eax
  801176:	8a 00                	mov    (%eax),%al
  801178:	84 c0                	test   %al,%al
  80117a:	74 03                	je     80117f <strncpy+0x31>
			src++;
  80117c:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80117f:	ff 45 fc             	incl   -0x4(%ebp)
  801182:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801185:	3b 45 10             	cmp    0x10(%ebp),%eax
  801188:	72 d9                	jb     801163 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80118a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80118d:	c9                   	leave  
  80118e:	c3                   	ret    

0080118f <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80118f:	55                   	push   %ebp
  801190:	89 e5                	mov    %esp,%ebp
  801192:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801195:	8b 45 08             	mov    0x8(%ebp),%eax
  801198:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80119b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80119f:	74 30                	je     8011d1 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8011a1:	eb 16                	jmp    8011b9 <strlcpy+0x2a>
			*dst++ = *src++;
  8011a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a6:	8d 50 01             	lea    0x1(%eax),%edx
  8011a9:	89 55 08             	mov    %edx,0x8(%ebp)
  8011ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011af:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011b2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8011b5:	8a 12                	mov    (%edx),%dl
  8011b7:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8011b9:	ff 4d 10             	decl   0x10(%ebp)
  8011bc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011c0:	74 09                	je     8011cb <strlcpy+0x3c>
  8011c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c5:	8a 00                	mov    (%eax),%al
  8011c7:	84 c0                	test   %al,%al
  8011c9:	75 d8                	jne    8011a3 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8011cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ce:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8011d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8011d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d7:	29 c2                	sub    %eax,%edx
  8011d9:	89 d0                	mov    %edx,%eax
}
  8011db:	c9                   	leave  
  8011dc:	c3                   	ret    

008011dd <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8011dd:	55                   	push   %ebp
  8011de:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8011e0:	eb 06                	jmp    8011e8 <strcmp+0xb>
		p++, q++;
  8011e2:	ff 45 08             	incl   0x8(%ebp)
  8011e5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8011e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011eb:	8a 00                	mov    (%eax),%al
  8011ed:	84 c0                	test   %al,%al
  8011ef:	74 0e                	je     8011ff <strcmp+0x22>
  8011f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f4:	8a 10                	mov    (%eax),%dl
  8011f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f9:	8a 00                	mov    (%eax),%al
  8011fb:	38 c2                	cmp    %al,%dl
  8011fd:	74 e3                	je     8011e2 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8011ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801202:	8a 00                	mov    (%eax),%al
  801204:	0f b6 d0             	movzbl %al,%edx
  801207:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120a:	8a 00                	mov    (%eax),%al
  80120c:	0f b6 c0             	movzbl %al,%eax
  80120f:	29 c2                	sub    %eax,%edx
  801211:	89 d0                	mov    %edx,%eax
}
  801213:	5d                   	pop    %ebp
  801214:	c3                   	ret    

00801215 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801215:	55                   	push   %ebp
  801216:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801218:	eb 09                	jmp    801223 <strncmp+0xe>
		n--, p++, q++;
  80121a:	ff 4d 10             	decl   0x10(%ebp)
  80121d:	ff 45 08             	incl   0x8(%ebp)
  801220:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801223:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801227:	74 17                	je     801240 <strncmp+0x2b>
  801229:	8b 45 08             	mov    0x8(%ebp),%eax
  80122c:	8a 00                	mov    (%eax),%al
  80122e:	84 c0                	test   %al,%al
  801230:	74 0e                	je     801240 <strncmp+0x2b>
  801232:	8b 45 08             	mov    0x8(%ebp),%eax
  801235:	8a 10                	mov    (%eax),%dl
  801237:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123a:	8a 00                	mov    (%eax),%al
  80123c:	38 c2                	cmp    %al,%dl
  80123e:	74 da                	je     80121a <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801240:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801244:	75 07                	jne    80124d <strncmp+0x38>
		return 0;
  801246:	b8 00 00 00 00       	mov    $0x0,%eax
  80124b:	eb 14                	jmp    801261 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80124d:	8b 45 08             	mov    0x8(%ebp),%eax
  801250:	8a 00                	mov    (%eax),%al
  801252:	0f b6 d0             	movzbl %al,%edx
  801255:	8b 45 0c             	mov    0xc(%ebp),%eax
  801258:	8a 00                	mov    (%eax),%al
  80125a:	0f b6 c0             	movzbl %al,%eax
  80125d:	29 c2                	sub    %eax,%edx
  80125f:	89 d0                	mov    %edx,%eax
}
  801261:	5d                   	pop    %ebp
  801262:	c3                   	ret    

00801263 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801263:	55                   	push   %ebp
  801264:	89 e5                	mov    %esp,%ebp
  801266:	83 ec 04             	sub    $0x4,%esp
  801269:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80126f:	eb 12                	jmp    801283 <strchr+0x20>
		if (*s == c)
  801271:	8b 45 08             	mov    0x8(%ebp),%eax
  801274:	8a 00                	mov    (%eax),%al
  801276:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801279:	75 05                	jne    801280 <strchr+0x1d>
			return (char *) s;
  80127b:	8b 45 08             	mov    0x8(%ebp),%eax
  80127e:	eb 11                	jmp    801291 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801280:	ff 45 08             	incl   0x8(%ebp)
  801283:	8b 45 08             	mov    0x8(%ebp),%eax
  801286:	8a 00                	mov    (%eax),%al
  801288:	84 c0                	test   %al,%al
  80128a:	75 e5                	jne    801271 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80128c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801291:	c9                   	leave  
  801292:	c3                   	ret    

00801293 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801293:	55                   	push   %ebp
  801294:	89 e5                	mov    %esp,%ebp
  801296:	83 ec 04             	sub    $0x4,%esp
  801299:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80129f:	eb 0d                	jmp    8012ae <strfind+0x1b>
		if (*s == c)
  8012a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a4:	8a 00                	mov    (%eax),%al
  8012a6:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8012a9:	74 0e                	je     8012b9 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8012ab:	ff 45 08             	incl   0x8(%ebp)
  8012ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b1:	8a 00                	mov    (%eax),%al
  8012b3:	84 c0                	test   %al,%al
  8012b5:	75 ea                	jne    8012a1 <strfind+0xe>
  8012b7:	eb 01                	jmp    8012ba <strfind+0x27>
		if (*s == c)
			break;
  8012b9:	90                   	nop
	return (char *) s;
  8012ba:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012bd:	c9                   	leave  
  8012be:	c3                   	ret    

008012bf <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8012bf:	55                   	push   %ebp
  8012c0:	89 e5                	mov    %esp,%ebp
  8012c2:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8012c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8012cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ce:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8012d1:	eb 0e                	jmp    8012e1 <memset+0x22>
		*p++ = c;
  8012d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012d6:	8d 50 01             	lea    0x1(%eax),%edx
  8012d9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012df:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8012e1:	ff 4d f8             	decl   -0x8(%ebp)
  8012e4:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8012e8:	79 e9                	jns    8012d3 <memset+0x14>
		*p++ = c;

	return v;
  8012ea:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012ed:	c9                   	leave  
  8012ee:	c3                   	ret    

008012ef <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8012ef:	55                   	push   %ebp
  8012f0:	89 e5                	mov    %esp,%ebp
  8012f2:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8012f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8012fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fe:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801301:	eb 16                	jmp    801319 <memcpy+0x2a>
		*d++ = *s++;
  801303:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801306:	8d 50 01             	lea    0x1(%eax),%edx
  801309:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80130c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80130f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801312:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801315:	8a 12                	mov    (%edx),%dl
  801317:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801319:	8b 45 10             	mov    0x10(%ebp),%eax
  80131c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80131f:	89 55 10             	mov    %edx,0x10(%ebp)
  801322:	85 c0                	test   %eax,%eax
  801324:	75 dd                	jne    801303 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801326:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801329:	c9                   	leave  
  80132a:	c3                   	ret    

0080132b <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80132b:	55                   	push   %ebp
  80132c:	89 e5                	mov    %esp,%ebp
  80132e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801331:	8b 45 0c             	mov    0xc(%ebp),%eax
  801334:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801337:	8b 45 08             	mov    0x8(%ebp),%eax
  80133a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80133d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801340:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801343:	73 50                	jae    801395 <memmove+0x6a>
  801345:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801348:	8b 45 10             	mov    0x10(%ebp),%eax
  80134b:	01 d0                	add    %edx,%eax
  80134d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801350:	76 43                	jbe    801395 <memmove+0x6a>
		s += n;
  801352:	8b 45 10             	mov    0x10(%ebp),%eax
  801355:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801358:	8b 45 10             	mov    0x10(%ebp),%eax
  80135b:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80135e:	eb 10                	jmp    801370 <memmove+0x45>
			*--d = *--s;
  801360:	ff 4d f8             	decl   -0x8(%ebp)
  801363:	ff 4d fc             	decl   -0x4(%ebp)
  801366:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801369:	8a 10                	mov    (%eax),%dl
  80136b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80136e:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801370:	8b 45 10             	mov    0x10(%ebp),%eax
  801373:	8d 50 ff             	lea    -0x1(%eax),%edx
  801376:	89 55 10             	mov    %edx,0x10(%ebp)
  801379:	85 c0                	test   %eax,%eax
  80137b:	75 e3                	jne    801360 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80137d:	eb 23                	jmp    8013a2 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80137f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801382:	8d 50 01             	lea    0x1(%eax),%edx
  801385:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801388:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80138b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80138e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801391:	8a 12                	mov    (%edx),%dl
  801393:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801395:	8b 45 10             	mov    0x10(%ebp),%eax
  801398:	8d 50 ff             	lea    -0x1(%eax),%edx
  80139b:	89 55 10             	mov    %edx,0x10(%ebp)
  80139e:	85 c0                	test   %eax,%eax
  8013a0:	75 dd                	jne    80137f <memmove+0x54>
			*d++ = *s++;

	return dst;
  8013a2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013a5:	c9                   	leave  
  8013a6:	c3                   	ret    

008013a7 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8013a7:	55                   	push   %ebp
  8013a8:	89 e5                	mov    %esp,%ebp
  8013aa:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8013ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8013b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b6:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8013b9:	eb 2a                	jmp    8013e5 <memcmp+0x3e>
		if (*s1 != *s2)
  8013bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013be:	8a 10                	mov    (%eax),%dl
  8013c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013c3:	8a 00                	mov    (%eax),%al
  8013c5:	38 c2                	cmp    %al,%dl
  8013c7:	74 16                	je     8013df <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8013c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013cc:	8a 00                	mov    (%eax),%al
  8013ce:	0f b6 d0             	movzbl %al,%edx
  8013d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013d4:	8a 00                	mov    (%eax),%al
  8013d6:	0f b6 c0             	movzbl %al,%eax
  8013d9:	29 c2                	sub    %eax,%edx
  8013db:	89 d0                	mov    %edx,%eax
  8013dd:	eb 18                	jmp    8013f7 <memcmp+0x50>
		s1++, s2++;
  8013df:	ff 45 fc             	incl   -0x4(%ebp)
  8013e2:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8013e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013eb:	89 55 10             	mov    %edx,0x10(%ebp)
  8013ee:	85 c0                	test   %eax,%eax
  8013f0:	75 c9                	jne    8013bb <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8013f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013f7:	c9                   	leave  
  8013f8:	c3                   	ret    

008013f9 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8013f9:	55                   	push   %ebp
  8013fa:	89 e5                	mov    %esp,%ebp
  8013fc:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8013ff:	8b 55 08             	mov    0x8(%ebp),%edx
  801402:	8b 45 10             	mov    0x10(%ebp),%eax
  801405:	01 d0                	add    %edx,%eax
  801407:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80140a:	eb 15                	jmp    801421 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80140c:	8b 45 08             	mov    0x8(%ebp),%eax
  80140f:	8a 00                	mov    (%eax),%al
  801411:	0f b6 d0             	movzbl %al,%edx
  801414:	8b 45 0c             	mov    0xc(%ebp),%eax
  801417:	0f b6 c0             	movzbl %al,%eax
  80141a:	39 c2                	cmp    %eax,%edx
  80141c:	74 0d                	je     80142b <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80141e:	ff 45 08             	incl   0x8(%ebp)
  801421:	8b 45 08             	mov    0x8(%ebp),%eax
  801424:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801427:	72 e3                	jb     80140c <memfind+0x13>
  801429:	eb 01                	jmp    80142c <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80142b:	90                   	nop
	return (void *) s;
  80142c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80142f:	c9                   	leave  
  801430:	c3                   	ret    

00801431 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801431:	55                   	push   %ebp
  801432:	89 e5                	mov    %esp,%ebp
  801434:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801437:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80143e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801445:	eb 03                	jmp    80144a <strtol+0x19>
		s++;
  801447:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80144a:	8b 45 08             	mov    0x8(%ebp),%eax
  80144d:	8a 00                	mov    (%eax),%al
  80144f:	3c 20                	cmp    $0x20,%al
  801451:	74 f4                	je     801447 <strtol+0x16>
  801453:	8b 45 08             	mov    0x8(%ebp),%eax
  801456:	8a 00                	mov    (%eax),%al
  801458:	3c 09                	cmp    $0x9,%al
  80145a:	74 eb                	je     801447 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80145c:	8b 45 08             	mov    0x8(%ebp),%eax
  80145f:	8a 00                	mov    (%eax),%al
  801461:	3c 2b                	cmp    $0x2b,%al
  801463:	75 05                	jne    80146a <strtol+0x39>
		s++;
  801465:	ff 45 08             	incl   0x8(%ebp)
  801468:	eb 13                	jmp    80147d <strtol+0x4c>
	else if (*s == '-')
  80146a:	8b 45 08             	mov    0x8(%ebp),%eax
  80146d:	8a 00                	mov    (%eax),%al
  80146f:	3c 2d                	cmp    $0x2d,%al
  801471:	75 0a                	jne    80147d <strtol+0x4c>
		s++, neg = 1;
  801473:	ff 45 08             	incl   0x8(%ebp)
  801476:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80147d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801481:	74 06                	je     801489 <strtol+0x58>
  801483:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801487:	75 20                	jne    8014a9 <strtol+0x78>
  801489:	8b 45 08             	mov    0x8(%ebp),%eax
  80148c:	8a 00                	mov    (%eax),%al
  80148e:	3c 30                	cmp    $0x30,%al
  801490:	75 17                	jne    8014a9 <strtol+0x78>
  801492:	8b 45 08             	mov    0x8(%ebp),%eax
  801495:	40                   	inc    %eax
  801496:	8a 00                	mov    (%eax),%al
  801498:	3c 78                	cmp    $0x78,%al
  80149a:	75 0d                	jne    8014a9 <strtol+0x78>
		s += 2, base = 16;
  80149c:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8014a0:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8014a7:	eb 28                	jmp    8014d1 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8014a9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014ad:	75 15                	jne    8014c4 <strtol+0x93>
  8014af:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b2:	8a 00                	mov    (%eax),%al
  8014b4:	3c 30                	cmp    $0x30,%al
  8014b6:	75 0c                	jne    8014c4 <strtol+0x93>
		s++, base = 8;
  8014b8:	ff 45 08             	incl   0x8(%ebp)
  8014bb:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8014c2:	eb 0d                	jmp    8014d1 <strtol+0xa0>
	else if (base == 0)
  8014c4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014c8:	75 07                	jne    8014d1 <strtol+0xa0>
		base = 10;
  8014ca:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8014d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d4:	8a 00                	mov    (%eax),%al
  8014d6:	3c 2f                	cmp    $0x2f,%al
  8014d8:	7e 19                	jle    8014f3 <strtol+0xc2>
  8014da:	8b 45 08             	mov    0x8(%ebp),%eax
  8014dd:	8a 00                	mov    (%eax),%al
  8014df:	3c 39                	cmp    $0x39,%al
  8014e1:	7f 10                	jg     8014f3 <strtol+0xc2>
			dig = *s - '0';
  8014e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e6:	8a 00                	mov    (%eax),%al
  8014e8:	0f be c0             	movsbl %al,%eax
  8014eb:	83 e8 30             	sub    $0x30,%eax
  8014ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014f1:	eb 42                	jmp    801535 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8014f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f6:	8a 00                	mov    (%eax),%al
  8014f8:	3c 60                	cmp    $0x60,%al
  8014fa:	7e 19                	jle    801515 <strtol+0xe4>
  8014fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ff:	8a 00                	mov    (%eax),%al
  801501:	3c 7a                	cmp    $0x7a,%al
  801503:	7f 10                	jg     801515 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801505:	8b 45 08             	mov    0x8(%ebp),%eax
  801508:	8a 00                	mov    (%eax),%al
  80150a:	0f be c0             	movsbl %al,%eax
  80150d:	83 e8 57             	sub    $0x57,%eax
  801510:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801513:	eb 20                	jmp    801535 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801515:	8b 45 08             	mov    0x8(%ebp),%eax
  801518:	8a 00                	mov    (%eax),%al
  80151a:	3c 40                	cmp    $0x40,%al
  80151c:	7e 39                	jle    801557 <strtol+0x126>
  80151e:	8b 45 08             	mov    0x8(%ebp),%eax
  801521:	8a 00                	mov    (%eax),%al
  801523:	3c 5a                	cmp    $0x5a,%al
  801525:	7f 30                	jg     801557 <strtol+0x126>
			dig = *s - 'A' + 10;
  801527:	8b 45 08             	mov    0x8(%ebp),%eax
  80152a:	8a 00                	mov    (%eax),%al
  80152c:	0f be c0             	movsbl %al,%eax
  80152f:	83 e8 37             	sub    $0x37,%eax
  801532:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801535:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801538:	3b 45 10             	cmp    0x10(%ebp),%eax
  80153b:	7d 19                	jge    801556 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80153d:	ff 45 08             	incl   0x8(%ebp)
  801540:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801543:	0f af 45 10          	imul   0x10(%ebp),%eax
  801547:	89 c2                	mov    %eax,%edx
  801549:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80154c:	01 d0                	add    %edx,%eax
  80154e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801551:	e9 7b ff ff ff       	jmp    8014d1 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801556:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801557:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80155b:	74 08                	je     801565 <strtol+0x134>
		*endptr = (char *) s;
  80155d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801560:	8b 55 08             	mov    0x8(%ebp),%edx
  801563:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801565:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801569:	74 07                	je     801572 <strtol+0x141>
  80156b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80156e:	f7 d8                	neg    %eax
  801570:	eb 03                	jmp    801575 <strtol+0x144>
  801572:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801575:	c9                   	leave  
  801576:	c3                   	ret    

00801577 <ltostr>:

void
ltostr(long value, char *str)
{
  801577:	55                   	push   %ebp
  801578:	89 e5                	mov    %esp,%ebp
  80157a:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80157d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801584:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80158b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80158f:	79 13                	jns    8015a4 <ltostr+0x2d>
	{
		neg = 1;
  801591:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801598:	8b 45 0c             	mov    0xc(%ebp),%eax
  80159b:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80159e:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8015a1:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8015a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a7:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8015ac:	99                   	cltd   
  8015ad:	f7 f9                	idiv   %ecx
  8015af:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8015b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015b5:	8d 50 01             	lea    0x1(%eax),%edx
  8015b8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8015bb:	89 c2                	mov    %eax,%edx
  8015bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c0:	01 d0                	add    %edx,%eax
  8015c2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015c5:	83 c2 30             	add    $0x30,%edx
  8015c8:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8015ca:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015cd:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8015d2:	f7 e9                	imul   %ecx
  8015d4:	c1 fa 02             	sar    $0x2,%edx
  8015d7:	89 c8                	mov    %ecx,%eax
  8015d9:	c1 f8 1f             	sar    $0x1f,%eax
  8015dc:	29 c2                	sub    %eax,%edx
  8015de:	89 d0                	mov    %edx,%eax
  8015e0:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8015e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015e6:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8015eb:	f7 e9                	imul   %ecx
  8015ed:	c1 fa 02             	sar    $0x2,%edx
  8015f0:	89 c8                	mov    %ecx,%eax
  8015f2:	c1 f8 1f             	sar    $0x1f,%eax
  8015f5:	29 c2                	sub    %eax,%edx
  8015f7:	89 d0                	mov    %edx,%eax
  8015f9:	c1 e0 02             	shl    $0x2,%eax
  8015fc:	01 d0                	add    %edx,%eax
  8015fe:	01 c0                	add    %eax,%eax
  801600:	29 c1                	sub    %eax,%ecx
  801602:	89 ca                	mov    %ecx,%edx
  801604:	85 d2                	test   %edx,%edx
  801606:	75 9c                	jne    8015a4 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801608:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80160f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801612:	48                   	dec    %eax
  801613:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801616:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80161a:	74 3d                	je     801659 <ltostr+0xe2>
		start = 1 ;
  80161c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801623:	eb 34                	jmp    801659 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801625:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801628:	8b 45 0c             	mov    0xc(%ebp),%eax
  80162b:	01 d0                	add    %edx,%eax
  80162d:	8a 00                	mov    (%eax),%al
  80162f:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801632:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801635:	8b 45 0c             	mov    0xc(%ebp),%eax
  801638:	01 c2                	add    %eax,%edx
  80163a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80163d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801640:	01 c8                	add    %ecx,%eax
  801642:	8a 00                	mov    (%eax),%al
  801644:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801646:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801649:	8b 45 0c             	mov    0xc(%ebp),%eax
  80164c:	01 c2                	add    %eax,%edx
  80164e:	8a 45 eb             	mov    -0x15(%ebp),%al
  801651:	88 02                	mov    %al,(%edx)
		start++ ;
  801653:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801656:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801659:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80165c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80165f:	7c c4                	jl     801625 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801661:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801664:	8b 45 0c             	mov    0xc(%ebp),%eax
  801667:	01 d0                	add    %edx,%eax
  801669:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80166c:	90                   	nop
  80166d:	c9                   	leave  
  80166e:	c3                   	ret    

0080166f <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80166f:	55                   	push   %ebp
  801670:	89 e5                	mov    %esp,%ebp
  801672:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801675:	ff 75 08             	pushl  0x8(%ebp)
  801678:	e8 54 fa ff ff       	call   8010d1 <strlen>
  80167d:	83 c4 04             	add    $0x4,%esp
  801680:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801683:	ff 75 0c             	pushl  0xc(%ebp)
  801686:	e8 46 fa ff ff       	call   8010d1 <strlen>
  80168b:	83 c4 04             	add    $0x4,%esp
  80168e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801691:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801698:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80169f:	eb 17                	jmp    8016b8 <strcconcat+0x49>
		final[s] = str1[s] ;
  8016a1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a7:	01 c2                	add    %eax,%edx
  8016a9:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8016ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8016af:	01 c8                	add    %ecx,%eax
  8016b1:	8a 00                	mov    (%eax),%al
  8016b3:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8016b5:	ff 45 fc             	incl   -0x4(%ebp)
  8016b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016bb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8016be:	7c e1                	jl     8016a1 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8016c0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8016c7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8016ce:	eb 1f                	jmp    8016ef <strcconcat+0x80>
		final[s++] = str2[i] ;
  8016d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016d3:	8d 50 01             	lea    0x1(%eax),%edx
  8016d6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8016d9:	89 c2                	mov    %eax,%edx
  8016db:	8b 45 10             	mov    0x10(%ebp),%eax
  8016de:	01 c2                	add    %eax,%edx
  8016e0:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8016e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016e6:	01 c8                	add    %ecx,%eax
  8016e8:	8a 00                	mov    (%eax),%al
  8016ea:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8016ec:	ff 45 f8             	incl   -0x8(%ebp)
  8016ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016f2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8016f5:	7c d9                	jl     8016d0 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8016f7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8016fd:	01 d0                	add    %edx,%eax
  8016ff:	c6 00 00             	movb   $0x0,(%eax)
}
  801702:	90                   	nop
  801703:	c9                   	leave  
  801704:	c3                   	ret    

00801705 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801705:	55                   	push   %ebp
  801706:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801708:	8b 45 14             	mov    0x14(%ebp),%eax
  80170b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801711:	8b 45 14             	mov    0x14(%ebp),%eax
  801714:	8b 00                	mov    (%eax),%eax
  801716:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80171d:	8b 45 10             	mov    0x10(%ebp),%eax
  801720:	01 d0                	add    %edx,%eax
  801722:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801728:	eb 0c                	jmp    801736 <strsplit+0x31>
			*string++ = 0;
  80172a:	8b 45 08             	mov    0x8(%ebp),%eax
  80172d:	8d 50 01             	lea    0x1(%eax),%edx
  801730:	89 55 08             	mov    %edx,0x8(%ebp)
  801733:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801736:	8b 45 08             	mov    0x8(%ebp),%eax
  801739:	8a 00                	mov    (%eax),%al
  80173b:	84 c0                	test   %al,%al
  80173d:	74 18                	je     801757 <strsplit+0x52>
  80173f:	8b 45 08             	mov    0x8(%ebp),%eax
  801742:	8a 00                	mov    (%eax),%al
  801744:	0f be c0             	movsbl %al,%eax
  801747:	50                   	push   %eax
  801748:	ff 75 0c             	pushl  0xc(%ebp)
  80174b:	e8 13 fb ff ff       	call   801263 <strchr>
  801750:	83 c4 08             	add    $0x8,%esp
  801753:	85 c0                	test   %eax,%eax
  801755:	75 d3                	jne    80172a <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801757:	8b 45 08             	mov    0x8(%ebp),%eax
  80175a:	8a 00                	mov    (%eax),%al
  80175c:	84 c0                	test   %al,%al
  80175e:	74 5a                	je     8017ba <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801760:	8b 45 14             	mov    0x14(%ebp),%eax
  801763:	8b 00                	mov    (%eax),%eax
  801765:	83 f8 0f             	cmp    $0xf,%eax
  801768:	75 07                	jne    801771 <strsplit+0x6c>
		{
			return 0;
  80176a:	b8 00 00 00 00       	mov    $0x0,%eax
  80176f:	eb 66                	jmp    8017d7 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801771:	8b 45 14             	mov    0x14(%ebp),%eax
  801774:	8b 00                	mov    (%eax),%eax
  801776:	8d 48 01             	lea    0x1(%eax),%ecx
  801779:	8b 55 14             	mov    0x14(%ebp),%edx
  80177c:	89 0a                	mov    %ecx,(%edx)
  80177e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801785:	8b 45 10             	mov    0x10(%ebp),%eax
  801788:	01 c2                	add    %eax,%edx
  80178a:	8b 45 08             	mov    0x8(%ebp),%eax
  80178d:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80178f:	eb 03                	jmp    801794 <strsplit+0x8f>
			string++;
  801791:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801794:	8b 45 08             	mov    0x8(%ebp),%eax
  801797:	8a 00                	mov    (%eax),%al
  801799:	84 c0                	test   %al,%al
  80179b:	74 8b                	je     801728 <strsplit+0x23>
  80179d:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a0:	8a 00                	mov    (%eax),%al
  8017a2:	0f be c0             	movsbl %al,%eax
  8017a5:	50                   	push   %eax
  8017a6:	ff 75 0c             	pushl  0xc(%ebp)
  8017a9:	e8 b5 fa ff ff       	call   801263 <strchr>
  8017ae:	83 c4 08             	add    $0x8,%esp
  8017b1:	85 c0                	test   %eax,%eax
  8017b3:	74 dc                	je     801791 <strsplit+0x8c>
			string++;
	}
  8017b5:	e9 6e ff ff ff       	jmp    801728 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8017ba:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8017bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8017be:	8b 00                	mov    (%eax),%eax
  8017c0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8017ca:	01 d0                	add    %edx,%eax
  8017cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8017d2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8017d7:	c9                   	leave  
  8017d8:	c3                   	ret    

008017d9 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8017d9:	55                   	push   %ebp
  8017da:	89 e5                	mov    %esp,%ebp
  8017dc:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8017df:	a1 04 50 80 00       	mov    0x805004,%eax
  8017e4:	85 c0                	test   %eax,%eax
  8017e6:	74 1f                	je     801807 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8017e8:	e8 1d 00 00 00       	call   80180a <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8017ed:	83 ec 0c             	sub    $0xc,%esp
  8017f0:	68 b0 3e 80 00       	push   $0x803eb0
  8017f5:	e8 55 f2 ff ff       	call   800a4f <cprintf>
  8017fa:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8017fd:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801804:	00 00 00 
	}
}
  801807:	90                   	nop
  801808:	c9                   	leave  
  801809:	c3                   	ret    

0080180a <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80180a:	55                   	push   %ebp
  80180b:	89 e5                	mov    %esp,%ebp
  80180d:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  801810:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801817:	00 00 00 
  80181a:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801821:	00 00 00 
  801824:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  80182b:	00 00 00 
		LIST_INIT(&AllocMemBlocksList);
  80182e:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801835:	00 00 00 
  801838:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  80183f:	00 00 00 
  801842:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801849:	00 00 00 

		MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES ;
  80184c:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801853:	00 02 00 
		MemBlockNodes =(struct MemBlock*)USER_DYN_BLKS_ARRAY ;
  801856:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  80185d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801860:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801865:	2d 00 10 00 00       	sub    $0x1000,%eax
  80186a:	a3 50 50 80 00       	mov    %eax,0x805050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock),PAGE_SIZE),PERM_USER|PERM_WRITEABLE);
  80186f:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801876:	a1 20 51 80 00       	mov    0x805120,%eax
  80187b:	c1 e0 04             	shl    $0x4,%eax
  80187e:	89 c2                	mov    %eax,%edx
  801880:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801883:	01 d0                	add    %edx,%eax
  801885:	48                   	dec    %eax
  801886:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801889:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80188c:	ba 00 00 00 00       	mov    $0x0,%edx
  801891:	f7 75 f0             	divl   -0x10(%ebp)
  801894:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801897:	29 d0                	sub    %edx,%eax
  801899:	89 c2                	mov    %eax,%edx
  80189b:	c7 45 e8 00 00 e0 7f 	movl   $0x7fe00000,-0x18(%ebp)
  8018a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018a5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8018aa:	2d 00 10 00 00       	sub    $0x1000,%eax
  8018af:	83 ec 04             	sub    $0x4,%esp
  8018b2:	6a 06                	push   $0x6
  8018b4:	52                   	push   %edx
  8018b5:	50                   	push   %eax
  8018b6:	e8 71 05 00 00       	call   801e2c <sys_allocate_chunk>
  8018bb:	83 c4 10             	add    $0x10,%esp
		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8018be:	a1 20 51 80 00       	mov    0x805120,%eax
  8018c3:	83 ec 0c             	sub    $0xc,%esp
  8018c6:	50                   	push   %eax
  8018c7:	e8 e6 0b 00 00       	call   8024b2 <initialize_MemBlocksList>
  8018cc:	83 c4 10             	add    $0x10,%esp

		struct MemBlock  *block_node;
		block_node = AvailableMemBlocksList.lh_first;
  8018cf:	a1 48 51 80 00       	mov    0x805148,%eax
  8018d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&(AvailableMemBlocksList),block_node);
  8018d7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8018db:	75 14                	jne    8018f1 <initialize_dyn_block_system+0xe7>
  8018dd:	83 ec 04             	sub    $0x4,%esp
  8018e0:	68 d5 3e 80 00       	push   $0x803ed5
  8018e5:	6a 2b                	push   $0x2b
  8018e7:	68 f3 3e 80 00       	push   $0x803ef3
  8018ec:	e8 aa ee ff ff       	call   80079b <_panic>
  8018f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018f4:	8b 00                	mov    (%eax),%eax
  8018f6:	85 c0                	test   %eax,%eax
  8018f8:	74 10                	je     80190a <initialize_dyn_block_system+0x100>
  8018fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018fd:	8b 00                	mov    (%eax),%eax
  8018ff:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801902:	8b 52 04             	mov    0x4(%edx),%edx
  801905:	89 50 04             	mov    %edx,0x4(%eax)
  801908:	eb 0b                	jmp    801915 <initialize_dyn_block_system+0x10b>
  80190a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80190d:	8b 40 04             	mov    0x4(%eax),%eax
  801910:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801915:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801918:	8b 40 04             	mov    0x4(%eax),%eax
  80191b:	85 c0                	test   %eax,%eax
  80191d:	74 0f                	je     80192e <initialize_dyn_block_system+0x124>
  80191f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801922:	8b 40 04             	mov    0x4(%eax),%eax
  801925:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801928:	8b 12                	mov    (%edx),%edx
  80192a:	89 10                	mov    %edx,(%eax)
  80192c:	eb 0a                	jmp    801938 <initialize_dyn_block_system+0x12e>
  80192e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801931:	8b 00                	mov    (%eax),%eax
  801933:	a3 48 51 80 00       	mov    %eax,0x805148
  801938:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80193b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801941:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801944:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80194b:	a1 54 51 80 00       	mov    0x805154,%eax
  801950:	48                   	dec    %eax
  801951:	a3 54 51 80 00       	mov    %eax,0x805154
		block_node->sva = USER_HEAP_START ;
  801956:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801959:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
		block_node->size = ((USER_HEAP_MAX - USER_HEAP_START));
  801960:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801963:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		insert_sorted_with_merge_freeList(block_node);
  80196a:	83 ec 0c             	sub    $0xc,%esp
  80196d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801970:	e8 d2 13 00 00       	call   802d47 <insert_sorted_with_merge_freeList>
  801975:	83 c4 10             	add    $0x10,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801978:	90                   	nop
  801979:	c9                   	leave  
  80197a:	c3                   	ret    

0080197b <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  80197b:	55                   	push   %ebp
  80197c:	89 e5                	mov    %esp,%ebp
  80197e:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801981:	e8 53 fe ff ff       	call   8017d9 <InitializeUHeap>
	if (size == 0) return NULL ;
  801986:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80198a:	75 07                	jne    801993 <malloc+0x18>
  80198c:	b8 00 00 00 00       	mov    $0x0,%eax
  801991:	eb 61                	jmp    8019f4 <malloc+0x79>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	size= ROUNDUP(size,PAGE_SIZE);
  801993:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80199a:	8b 55 08             	mov    0x8(%ebp),%edx
  80199d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019a0:	01 d0                	add    %edx,%eax
  8019a2:	48                   	dec    %eax
  8019a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8019a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8019ae:	f7 75 f4             	divl   -0xc(%ebp)
  8019b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019b4:	29 d0                	sub    %edx,%eax
  8019b6:	89 45 08             	mov    %eax,0x8(%ebp)
	    			if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8019b9:	e8 3c 08 00 00       	call   8021fa <sys_isUHeapPlacementStrategyFIRSTFIT>
  8019be:	85 c0                	test   %eax,%eax
  8019c0:	74 2d                	je     8019ef <malloc+0x74>
	    			{
	    				struct MemBlock * ff_block = alloc_block_FF(size);
  8019c2:	83 ec 0c             	sub    $0xc,%esp
  8019c5:	ff 75 08             	pushl  0x8(%ebp)
  8019c8:	e8 3e 0f 00 00       	call   80290b <alloc_block_FF>
  8019cd:	83 c4 10             	add    $0x10,%esp
  8019d0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    				if(ff_block!=NULL)
  8019d3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8019d7:	74 16                	je     8019ef <malloc+0x74>
	    				{

	    					insert_sorted_allocList(ff_block);
  8019d9:	83 ec 0c             	sub    $0xc,%esp
  8019dc:	ff 75 ec             	pushl  -0x14(%ebp)
  8019df:	e8 48 0c 00 00       	call   80262c <insert_sorted_allocList>
  8019e4:	83 c4 10             	add    $0x10,%esp
	    					return (void*) ff_block->sva ;
  8019e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019ea:	8b 40 08             	mov    0x8(%eax),%eax
  8019ed:	eb 05                	jmp    8019f4 <malloc+0x79>

	    				}
	}
	    			return (void*) NULL ;
  8019ef:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  8019f4:	c9                   	leave  
  8019f5:	c3                   	ret    

008019f6 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8019f6:	55                   	push   %ebp
  8019f7:	89 e5                	mov    %esp,%ebp
  8019f9:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock *elementForEach;
		virtual_address = ROUNDDOWN(virtual_address, PAGE_SIZE);
  8019fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a05:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a0a:	89 45 08             	mov    %eax,0x8(%ebp)
	//	if (is_mallocPages[indexindex((uint32) virtual_address)] == 1) {
		elementForEach = find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a10:	83 ec 08             	sub    $0x8,%esp
  801a13:	50                   	push   %eax
  801a14:	68 40 50 80 00       	push   $0x805040
  801a19:	e8 71 0b 00 00       	call   80258f <find_block>
  801a1e:	83 c4 10             	add    $0x10,%esp
  801a21:	89 45 f0             	mov    %eax,-0x10(%ebp)
		sys_free_user_mem((uint32) virtual_address, elementForEach->size);
  801a24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a27:	8b 50 0c             	mov    0xc(%eax),%edx
  801a2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2d:	83 ec 08             	sub    $0x8,%esp
  801a30:	52                   	push   %edx
  801a31:	50                   	push   %eax
  801a32:	e8 bd 03 00 00       	call   801df4 <sys_free_user_mem>
  801a37:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,elementForEach);
  801a3a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801a3e:	75 14                	jne    801a54 <free+0x5e>
  801a40:	83 ec 04             	sub    $0x4,%esp
  801a43:	68 d5 3e 80 00       	push   $0x803ed5
  801a48:	6a 71                	push   $0x71
  801a4a:	68 f3 3e 80 00       	push   $0x803ef3
  801a4f:	e8 47 ed ff ff       	call   80079b <_panic>
  801a54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a57:	8b 00                	mov    (%eax),%eax
  801a59:	85 c0                	test   %eax,%eax
  801a5b:	74 10                	je     801a6d <free+0x77>
  801a5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a60:	8b 00                	mov    (%eax),%eax
  801a62:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a65:	8b 52 04             	mov    0x4(%edx),%edx
  801a68:	89 50 04             	mov    %edx,0x4(%eax)
  801a6b:	eb 0b                	jmp    801a78 <free+0x82>
  801a6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a70:	8b 40 04             	mov    0x4(%eax),%eax
  801a73:	a3 44 50 80 00       	mov    %eax,0x805044
  801a78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a7b:	8b 40 04             	mov    0x4(%eax),%eax
  801a7e:	85 c0                	test   %eax,%eax
  801a80:	74 0f                	je     801a91 <free+0x9b>
  801a82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a85:	8b 40 04             	mov    0x4(%eax),%eax
  801a88:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a8b:	8b 12                	mov    (%edx),%edx
  801a8d:	89 10                	mov    %edx,(%eax)
  801a8f:	eb 0a                	jmp    801a9b <free+0xa5>
  801a91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a94:	8b 00                	mov    (%eax),%eax
  801a96:	a3 40 50 80 00       	mov    %eax,0x805040
  801a9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a9e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801aa4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aa7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801aae:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801ab3:	48                   	dec    %eax
  801ab4:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(elementForEach);
  801ab9:	83 ec 0c             	sub    $0xc,%esp
  801abc:	ff 75 f0             	pushl  -0x10(%ebp)
  801abf:	e8 83 12 00 00       	call   802d47 <insert_sorted_with_merge_freeList>
  801ac4:	83 c4 10             	add    $0x10,%esp
	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801ac7:	90                   	nop
  801ac8:	c9                   	leave  
  801ac9:	c3                   	ret    

00801aca <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801aca:	55                   	push   %ebp
  801acb:	89 e5                	mov    %esp,%ebp
  801acd:	83 ec 28             	sub    $0x28,%esp
  801ad0:	8b 45 10             	mov    0x10(%ebp),%eax
  801ad3:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ad6:	e8 fe fc ff ff       	call   8017d9 <InitializeUHeap>
	if (size == 0) return NULL ;
  801adb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801adf:	75 0a                	jne    801aeb <smalloc+0x21>
  801ae1:	b8 00 00 00 00       	mov    $0x0,%eax
  801ae6:	e9 86 00 00 00       	jmp    801b71 <smalloc+0xa7>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code

	size=ROUNDUP(size,PAGE_SIZE);
  801aeb:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801af2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801af8:	01 d0                	add    %edx,%eax
  801afa:	48                   	dec    %eax
  801afb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801afe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b01:	ba 00 00 00 00       	mov    $0x0,%edx
  801b06:	f7 75 f4             	divl   -0xc(%ebp)
  801b09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b0c:	29 d0                	sub    %edx,%eax
  801b0e:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801b11:	e8 e4 06 00 00       	call   8021fa <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b16:	85 c0                	test   %eax,%eax
  801b18:	74 52                	je     801b6c <smalloc+0xa2>
		{
		struct MemBlock * ff_block ;
		ff_block = alloc_block_FF(size);
  801b1a:	83 ec 0c             	sub    $0xc,%esp
  801b1d:	ff 75 0c             	pushl  0xc(%ebp)
  801b20:	e8 e6 0d 00 00       	call   80290b <alloc_block_FF>
  801b25:	83 c4 10             	add    $0x10,%esp
  801b28:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(ff_block==NULL)
  801b2b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801b2f:	75 07                	jne    801b38 <smalloc+0x6e>
			return NULL ;
  801b31:	b8 00 00 00 00       	mov    $0x0,%eax
  801b36:	eb 39                	jmp    801b71 <smalloc+0xa7>

		int obj_id =sys_createSharedObject(sharedVarName,size,isWritable,(void*)ff_block->sva);
  801b38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b3b:	8b 40 08             	mov    0x8(%eax),%eax
  801b3e:	89 c2                	mov    %eax,%edx
  801b40:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801b44:	52                   	push   %edx
  801b45:	50                   	push   %eax
  801b46:	ff 75 0c             	pushl  0xc(%ebp)
  801b49:	ff 75 08             	pushl  0x8(%ebp)
  801b4c:	e8 2e 04 00 00       	call   801f7f <sys_createSharedObject>
  801b51:	83 c4 10             	add    $0x10,%esp
  801b54:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(obj_id < 0)
  801b57:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801b5b:	79 07                	jns    801b64 <smalloc+0x9a>
			return (void*)NULL ;
  801b5d:	b8 00 00 00 00       	mov    $0x0,%eax
  801b62:	eb 0d                	jmp    801b71 <smalloc+0xa7>
		else
		    return (void*)ff_block->sva ;
  801b64:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b67:	8b 40 08             	mov    0x8(%eax),%eax
  801b6a:	eb 05                	jmp    801b71 <smalloc+0xa7>
		}
		return (void*)NULL ;
  801b6c:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801b71:	c9                   	leave  
  801b72:	c3                   	ret    

00801b73 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801b73:	55                   	push   %ebp
  801b74:	89 e5                	mov    %esp,%ebp
  801b76:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b79:	e8 5b fc ff ff       	call   8017d9 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801b7e:	83 ec 08             	sub    $0x8,%esp
  801b81:	ff 75 0c             	pushl  0xc(%ebp)
  801b84:	ff 75 08             	pushl  0x8(%ebp)
  801b87:	e8 1d 04 00 00       	call   801fa9 <sys_getSizeOfSharedObject>
  801b8c:	83 c4 10             	add    $0x10,%esp
  801b8f:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(size == 0)
  801b92:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b96:	75 0a                	jne    801ba2 <sget+0x2f>
			return NULL ;
  801b98:	b8 00 00 00 00       	mov    $0x0,%eax
  801b9d:	e9 83 00 00 00       	jmp    801c25 <sget+0xb2>
		size=ROUNDUP(size,PAGE_SIZE);
  801ba2:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801ba9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801baf:	01 d0                	add    %edx,%eax
  801bb1:	48                   	dec    %eax
  801bb2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801bb5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bb8:	ba 00 00 00 00       	mov    $0x0,%edx
  801bbd:	f7 75 f0             	divl   -0x10(%ebp)
  801bc0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bc3:	29 d0                	sub    %edx,%eax
  801bc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801bc8:	e8 2d 06 00 00       	call   8021fa <sys_isUHeapPlacementStrategyFIRSTFIT>
  801bcd:	85 c0                	test   %eax,%eax
  801bcf:	74 4f                	je     801c20 <sget+0xad>
		{
			struct MemBlock * ff_block ;
				ff_block = alloc_block_FF(size);
  801bd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bd4:	83 ec 0c             	sub    $0xc,%esp
  801bd7:	50                   	push   %eax
  801bd8:	e8 2e 0d 00 00       	call   80290b <alloc_block_FF>
  801bdd:	83 c4 10             	add    $0x10,%esp
  801be0:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ff_block==NULL)
  801be3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801be7:	75 07                	jne    801bf0 <sget+0x7d>
					return (void*)NULL ;
  801be9:	b8 00 00 00 00       	mov    $0x0,%eax
  801bee:	eb 35                	jmp    801c25 <sget+0xb2>

		int obj_id =sys_getSharedObject((int)ownerEnvID,sharedVarName,(void*)ff_block->sva);
  801bf0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801bf3:	8b 40 08             	mov    0x8(%eax),%eax
  801bf6:	83 ec 04             	sub    $0x4,%esp
  801bf9:	50                   	push   %eax
  801bfa:	ff 75 0c             	pushl  0xc(%ebp)
  801bfd:	ff 75 08             	pushl  0x8(%ebp)
  801c00:	e8 c1 03 00 00       	call   801fc6 <sys_getSharedObject>
  801c05:	83 c4 10             	add    $0x10,%esp
  801c08:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if(obj_id<0)
  801c0b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801c0f:	79 07                	jns    801c18 <sget+0xa5>
				return (void*)NULL ;
  801c11:	b8 00 00 00 00       	mov    $0x0,%eax
  801c16:	eb 0d                	jmp    801c25 <sget+0xb2>
			else
				return (void*)ff_block->sva ;
  801c18:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c1b:	8b 40 08             	mov    0x8(%eax),%eax
  801c1e:	eb 05                	jmp    801c25 <sget+0xb2>


		}
	return (void*)NULL ;
  801c20:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801c25:	c9                   	leave  
  801c26:	c3                   	ret    

00801c27 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801c27:	55                   	push   %ebp
  801c28:	89 e5                	mov    %esp,%ebp
  801c2a:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c2d:	e8 a7 fb ff ff       	call   8017d9 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801c32:	83 ec 04             	sub    $0x4,%esp
  801c35:	68 00 3f 80 00       	push   $0x803f00
  801c3a:	68 f9 00 00 00       	push   $0xf9
  801c3f:	68 f3 3e 80 00       	push   $0x803ef3
  801c44:	e8 52 eb ff ff       	call   80079b <_panic>

00801c49 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801c49:	55                   	push   %ebp
  801c4a:	89 e5                	mov    %esp,%ebp
  801c4c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801c4f:	83 ec 04             	sub    $0x4,%esp
  801c52:	68 28 3f 80 00       	push   $0x803f28
  801c57:	68 0d 01 00 00       	push   $0x10d
  801c5c:	68 f3 3e 80 00       	push   $0x803ef3
  801c61:	e8 35 eb ff ff       	call   80079b <_panic>

00801c66 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801c66:	55                   	push   %ebp
  801c67:	89 e5                	mov    %esp,%ebp
  801c69:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c6c:	83 ec 04             	sub    $0x4,%esp
  801c6f:	68 4c 3f 80 00       	push   $0x803f4c
  801c74:	68 18 01 00 00       	push   $0x118
  801c79:	68 f3 3e 80 00       	push   $0x803ef3
  801c7e:	e8 18 eb ff ff       	call   80079b <_panic>

00801c83 <shrink>:

}
void shrink(uint32 newSize)
{
  801c83:	55                   	push   %ebp
  801c84:	89 e5                	mov    %esp,%ebp
  801c86:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c89:	83 ec 04             	sub    $0x4,%esp
  801c8c:	68 4c 3f 80 00       	push   $0x803f4c
  801c91:	68 1d 01 00 00       	push   $0x11d
  801c96:	68 f3 3e 80 00       	push   $0x803ef3
  801c9b:	e8 fb ea ff ff       	call   80079b <_panic>

00801ca0 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801ca0:	55                   	push   %ebp
  801ca1:	89 e5                	mov    %esp,%ebp
  801ca3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ca6:	83 ec 04             	sub    $0x4,%esp
  801ca9:	68 4c 3f 80 00       	push   $0x803f4c
  801cae:	68 22 01 00 00       	push   $0x122
  801cb3:	68 f3 3e 80 00       	push   $0x803ef3
  801cb8:	e8 de ea ff ff       	call   80079b <_panic>

00801cbd <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801cbd:	55                   	push   %ebp
  801cbe:	89 e5                	mov    %esp,%ebp
  801cc0:	57                   	push   %edi
  801cc1:	56                   	push   %esi
  801cc2:	53                   	push   %ebx
  801cc3:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ccc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ccf:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cd2:	8b 7d 18             	mov    0x18(%ebp),%edi
  801cd5:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801cd8:	cd 30                	int    $0x30
  801cda:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801cdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801ce0:	83 c4 10             	add    $0x10,%esp
  801ce3:	5b                   	pop    %ebx
  801ce4:	5e                   	pop    %esi
  801ce5:	5f                   	pop    %edi
  801ce6:	5d                   	pop    %ebp
  801ce7:	c3                   	ret    

00801ce8 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801ce8:	55                   	push   %ebp
  801ce9:	89 e5                	mov    %esp,%ebp
  801ceb:	83 ec 04             	sub    $0x4,%esp
  801cee:	8b 45 10             	mov    0x10(%ebp),%eax
  801cf1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801cf4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfb:	6a 00                	push   $0x0
  801cfd:	6a 00                	push   $0x0
  801cff:	52                   	push   %edx
  801d00:	ff 75 0c             	pushl  0xc(%ebp)
  801d03:	50                   	push   %eax
  801d04:	6a 00                	push   $0x0
  801d06:	e8 b2 ff ff ff       	call   801cbd <syscall>
  801d0b:	83 c4 18             	add    $0x18,%esp
}
  801d0e:	90                   	nop
  801d0f:	c9                   	leave  
  801d10:	c3                   	ret    

00801d11 <sys_cgetc>:

int
sys_cgetc(void)
{
  801d11:	55                   	push   %ebp
  801d12:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801d14:	6a 00                	push   $0x0
  801d16:	6a 00                	push   $0x0
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 01                	push   $0x1
  801d20:	e8 98 ff ff ff       	call   801cbd <syscall>
  801d25:	83 c4 18             	add    $0x18,%esp
}
  801d28:	c9                   	leave  
  801d29:	c3                   	ret    

00801d2a <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801d2a:	55                   	push   %ebp
  801d2b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801d2d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d30:	8b 45 08             	mov    0x8(%ebp),%eax
  801d33:	6a 00                	push   $0x0
  801d35:	6a 00                	push   $0x0
  801d37:	6a 00                	push   $0x0
  801d39:	52                   	push   %edx
  801d3a:	50                   	push   %eax
  801d3b:	6a 05                	push   $0x5
  801d3d:	e8 7b ff ff ff       	call   801cbd <syscall>
  801d42:	83 c4 18             	add    $0x18,%esp
}
  801d45:	c9                   	leave  
  801d46:	c3                   	ret    

00801d47 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801d47:	55                   	push   %ebp
  801d48:	89 e5                	mov    %esp,%ebp
  801d4a:	56                   	push   %esi
  801d4b:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801d4c:	8b 75 18             	mov    0x18(%ebp),%esi
  801d4f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d52:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d55:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d58:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5b:	56                   	push   %esi
  801d5c:	53                   	push   %ebx
  801d5d:	51                   	push   %ecx
  801d5e:	52                   	push   %edx
  801d5f:	50                   	push   %eax
  801d60:	6a 06                	push   $0x6
  801d62:	e8 56 ff ff ff       	call   801cbd <syscall>
  801d67:	83 c4 18             	add    $0x18,%esp
}
  801d6a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d6d:	5b                   	pop    %ebx
  801d6e:	5e                   	pop    %esi
  801d6f:	5d                   	pop    %ebp
  801d70:	c3                   	ret    

00801d71 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801d71:	55                   	push   %ebp
  801d72:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801d74:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d77:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7a:	6a 00                	push   $0x0
  801d7c:	6a 00                	push   $0x0
  801d7e:	6a 00                	push   $0x0
  801d80:	52                   	push   %edx
  801d81:	50                   	push   %eax
  801d82:	6a 07                	push   $0x7
  801d84:	e8 34 ff ff ff       	call   801cbd <syscall>
  801d89:	83 c4 18             	add    $0x18,%esp
}
  801d8c:	c9                   	leave  
  801d8d:	c3                   	ret    

00801d8e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801d8e:	55                   	push   %ebp
  801d8f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801d91:	6a 00                	push   $0x0
  801d93:	6a 00                	push   $0x0
  801d95:	6a 00                	push   $0x0
  801d97:	ff 75 0c             	pushl  0xc(%ebp)
  801d9a:	ff 75 08             	pushl  0x8(%ebp)
  801d9d:	6a 08                	push   $0x8
  801d9f:	e8 19 ff ff ff       	call   801cbd <syscall>
  801da4:	83 c4 18             	add    $0x18,%esp
}
  801da7:	c9                   	leave  
  801da8:	c3                   	ret    

00801da9 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801da9:	55                   	push   %ebp
  801daa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801dac:	6a 00                	push   $0x0
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	6a 00                	push   $0x0
  801db4:	6a 00                	push   $0x0
  801db6:	6a 09                	push   $0x9
  801db8:	e8 00 ff ff ff       	call   801cbd <syscall>
  801dbd:	83 c4 18             	add    $0x18,%esp
}
  801dc0:	c9                   	leave  
  801dc1:	c3                   	ret    

00801dc2 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801dc2:	55                   	push   %ebp
  801dc3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801dc5:	6a 00                	push   $0x0
  801dc7:	6a 00                	push   $0x0
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 00                	push   $0x0
  801dcd:	6a 00                	push   $0x0
  801dcf:	6a 0a                	push   $0xa
  801dd1:	e8 e7 fe ff ff       	call   801cbd <syscall>
  801dd6:	83 c4 18             	add    $0x18,%esp
}
  801dd9:	c9                   	leave  
  801dda:	c3                   	ret    

00801ddb <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801ddb:	55                   	push   %ebp
  801ddc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801dde:	6a 00                	push   $0x0
  801de0:	6a 00                	push   $0x0
  801de2:	6a 00                	push   $0x0
  801de4:	6a 00                	push   $0x0
  801de6:	6a 00                	push   $0x0
  801de8:	6a 0b                	push   $0xb
  801dea:	e8 ce fe ff ff       	call   801cbd <syscall>
  801def:	83 c4 18             	add    $0x18,%esp
}
  801df2:	c9                   	leave  
  801df3:	c3                   	ret    

00801df4 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801df4:	55                   	push   %ebp
  801df5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801df7:	6a 00                	push   $0x0
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 00                	push   $0x0
  801dfd:	ff 75 0c             	pushl  0xc(%ebp)
  801e00:	ff 75 08             	pushl  0x8(%ebp)
  801e03:	6a 0f                	push   $0xf
  801e05:	e8 b3 fe ff ff       	call   801cbd <syscall>
  801e0a:	83 c4 18             	add    $0x18,%esp
	return;
  801e0d:	90                   	nop
}
  801e0e:	c9                   	leave  
  801e0f:	c3                   	ret    

00801e10 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801e10:	55                   	push   %ebp
  801e11:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801e13:	6a 00                	push   $0x0
  801e15:	6a 00                	push   $0x0
  801e17:	6a 00                	push   $0x0
  801e19:	ff 75 0c             	pushl  0xc(%ebp)
  801e1c:	ff 75 08             	pushl  0x8(%ebp)
  801e1f:	6a 10                	push   $0x10
  801e21:	e8 97 fe ff ff       	call   801cbd <syscall>
  801e26:	83 c4 18             	add    $0x18,%esp
	return ;
  801e29:	90                   	nop
}
  801e2a:	c9                   	leave  
  801e2b:	c3                   	ret    

00801e2c <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801e2c:	55                   	push   %ebp
  801e2d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 00                	push   $0x0
  801e33:	ff 75 10             	pushl  0x10(%ebp)
  801e36:	ff 75 0c             	pushl  0xc(%ebp)
  801e39:	ff 75 08             	pushl  0x8(%ebp)
  801e3c:	6a 11                	push   $0x11
  801e3e:	e8 7a fe ff ff       	call   801cbd <syscall>
  801e43:	83 c4 18             	add    $0x18,%esp
	return ;
  801e46:	90                   	nop
}
  801e47:	c9                   	leave  
  801e48:	c3                   	ret    

00801e49 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801e49:	55                   	push   %ebp
  801e4a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801e4c:	6a 00                	push   $0x0
  801e4e:	6a 00                	push   $0x0
  801e50:	6a 00                	push   $0x0
  801e52:	6a 00                	push   $0x0
  801e54:	6a 00                	push   $0x0
  801e56:	6a 0c                	push   $0xc
  801e58:	e8 60 fe ff ff       	call   801cbd <syscall>
  801e5d:	83 c4 18             	add    $0x18,%esp
}
  801e60:	c9                   	leave  
  801e61:	c3                   	ret    

00801e62 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801e62:	55                   	push   %ebp
  801e63:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801e65:	6a 00                	push   $0x0
  801e67:	6a 00                	push   $0x0
  801e69:	6a 00                	push   $0x0
  801e6b:	6a 00                	push   $0x0
  801e6d:	ff 75 08             	pushl  0x8(%ebp)
  801e70:	6a 0d                	push   $0xd
  801e72:	e8 46 fe ff ff       	call   801cbd <syscall>
  801e77:	83 c4 18             	add    $0x18,%esp
}
  801e7a:	c9                   	leave  
  801e7b:	c3                   	ret    

00801e7c <sys_scarce_memory>:

void sys_scarce_memory()
{
  801e7c:	55                   	push   %ebp
  801e7d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801e7f:	6a 00                	push   $0x0
  801e81:	6a 00                	push   $0x0
  801e83:	6a 00                	push   $0x0
  801e85:	6a 00                	push   $0x0
  801e87:	6a 00                	push   $0x0
  801e89:	6a 0e                	push   $0xe
  801e8b:	e8 2d fe ff ff       	call   801cbd <syscall>
  801e90:	83 c4 18             	add    $0x18,%esp
}
  801e93:	90                   	nop
  801e94:	c9                   	leave  
  801e95:	c3                   	ret    

00801e96 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801e96:	55                   	push   %ebp
  801e97:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801e99:	6a 00                	push   $0x0
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 00                	push   $0x0
  801ea1:	6a 00                	push   $0x0
  801ea3:	6a 13                	push   $0x13
  801ea5:	e8 13 fe ff ff       	call   801cbd <syscall>
  801eaa:	83 c4 18             	add    $0x18,%esp
}
  801ead:	90                   	nop
  801eae:	c9                   	leave  
  801eaf:	c3                   	ret    

00801eb0 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801eb0:	55                   	push   %ebp
  801eb1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801eb3:	6a 00                	push   $0x0
  801eb5:	6a 00                	push   $0x0
  801eb7:	6a 00                	push   $0x0
  801eb9:	6a 00                	push   $0x0
  801ebb:	6a 00                	push   $0x0
  801ebd:	6a 14                	push   $0x14
  801ebf:	e8 f9 fd ff ff       	call   801cbd <syscall>
  801ec4:	83 c4 18             	add    $0x18,%esp
}
  801ec7:	90                   	nop
  801ec8:	c9                   	leave  
  801ec9:	c3                   	ret    

00801eca <sys_cputc>:


void
sys_cputc(const char c)
{
  801eca:	55                   	push   %ebp
  801ecb:	89 e5                	mov    %esp,%ebp
  801ecd:	83 ec 04             	sub    $0x4,%esp
  801ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801ed6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801eda:	6a 00                	push   $0x0
  801edc:	6a 00                	push   $0x0
  801ede:	6a 00                	push   $0x0
  801ee0:	6a 00                	push   $0x0
  801ee2:	50                   	push   %eax
  801ee3:	6a 15                	push   $0x15
  801ee5:	e8 d3 fd ff ff       	call   801cbd <syscall>
  801eea:	83 c4 18             	add    $0x18,%esp
}
  801eed:	90                   	nop
  801eee:	c9                   	leave  
  801eef:	c3                   	ret    

00801ef0 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ef0:	55                   	push   %ebp
  801ef1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801ef3:	6a 00                	push   $0x0
  801ef5:	6a 00                	push   $0x0
  801ef7:	6a 00                	push   $0x0
  801ef9:	6a 00                	push   $0x0
  801efb:	6a 00                	push   $0x0
  801efd:	6a 16                	push   $0x16
  801eff:	e8 b9 fd ff ff       	call   801cbd <syscall>
  801f04:	83 c4 18             	add    $0x18,%esp
}
  801f07:	90                   	nop
  801f08:	c9                   	leave  
  801f09:	c3                   	ret    

00801f0a <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801f0a:	55                   	push   %ebp
  801f0b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801f0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f10:	6a 00                	push   $0x0
  801f12:	6a 00                	push   $0x0
  801f14:	6a 00                	push   $0x0
  801f16:	ff 75 0c             	pushl  0xc(%ebp)
  801f19:	50                   	push   %eax
  801f1a:	6a 17                	push   $0x17
  801f1c:	e8 9c fd ff ff       	call   801cbd <syscall>
  801f21:	83 c4 18             	add    $0x18,%esp
}
  801f24:	c9                   	leave  
  801f25:	c3                   	ret    

00801f26 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801f26:	55                   	push   %ebp
  801f27:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f29:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2f:	6a 00                	push   $0x0
  801f31:	6a 00                	push   $0x0
  801f33:	6a 00                	push   $0x0
  801f35:	52                   	push   %edx
  801f36:	50                   	push   %eax
  801f37:	6a 1a                	push   $0x1a
  801f39:	e8 7f fd ff ff       	call   801cbd <syscall>
  801f3e:	83 c4 18             	add    $0x18,%esp
}
  801f41:	c9                   	leave  
  801f42:	c3                   	ret    

00801f43 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801f43:	55                   	push   %ebp
  801f44:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f46:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f49:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4c:	6a 00                	push   $0x0
  801f4e:	6a 00                	push   $0x0
  801f50:	6a 00                	push   $0x0
  801f52:	52                   	push   %edx
  801f53:	50                   	push   %eax
  801f54:	6a 18                	push   $0x18
  801f56:	e8 62 fd ff ff       	call   801cbd <syscall>
  801f5b:	83 c4 18             	add    $0x18,%esp
}
  801f5e:	90                   	nop
  801f5f:	c9                   	leave  
  801f60:	c3                   	ret    

00801f61 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801f61:	55                   	push   %ebp
  801f62:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f64:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f67:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6a:	6a 00                	push   $0x0
  801f6c:	6a 00                	push   $0x0
  801f6e:	6a 00                	push   $0x0
  801f70:	52                   	push   %edx
  801f71:	50                   	push   %eax
  801f72:	6a 19                	push   $0x19
  801f74:	e8 44 fd ff ff       	call   801cbd <syscall>
  801f79:	83 c4 18             	add    $0x18,%esp
}
  801f7c:	90                   	nop
  801f7d:	c9                   	leave  
  801f7e:	c3                   	ret    

00801f7f <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801f7f:	55                   	push   %ebp
  801f80:	89 e5                	mov    %esp,%ebp
  801f82:	83 ec 04             	sub    $0x4,%esp
  801f85:	8b 45 10             	mov    0x10(%ebp),%eax
  801f88:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801f8b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f8e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f92:	8b 45 08             	mov    0x8(%ebp),%eax
  801f95:	6a 00                	push   $0x0
  801f97:	51                   	push   %ecx
  801f98:	52                   	push   %edx
  801f99:	ff 75 0c             	pushl  0xc(%ebp)
  801f9c:	50                   	push   %eax
  801f9d:	6a 1b                	push   $0x1b
  801f9f:	e8 19 fd ff ff       	call   801cbd <syscall>
  801fa4:	83 c4 18             	add    $0x18,%esp
}
  801fa7:	c9                   	leave  
  801fa8:	c3                   	ret    

00801fa9 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801fa9:	55                   	push   %ebp
  801faa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801fac:	8b 55 0c             	mov    0xc(%ebp),%edx
  801faf:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb2:	6a 00                	push   $0x0
  801fb4:	6a 00                	push   $0x0
  801fb6:	6a 00                	push   $0x0
  801fb8:	52                   	push   %edx
  801fb9:	50                   	push   %eax
  801fba:	6a 1c                	push   $0x1c
  801fbc:	e8 fc fc ff ff       	call   801cbd <syscall>
  801fc1:	83 c4 18             	add    $0x18,%esp
}
  801fc4:	c9                   	leave  
  801fc5:	c3                   	ret    

00801fc6 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801fc6:	55                   	push   %ebp
  801fc7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801fc9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fcc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd2:	6a 00                	push   $0x0
  801fd4:	6a 00                	push   $0x0
  801fd6:	51                   	push   %ecx
  801fd7:	52                   	push   %edx
  801fd8:	50                   	push   %eax
  801fd9:	6a 1d                	push   $0x1d
  801fdb:	e8 dd fc ff ff       	call   801cbd <syscall>
  801fe0:	83 c4 18             	add    $0x18,%esp
}
  801fe3:	c9                   	leave  
  801fe4:	c3                   	ret    

00801fe5 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801fe5:	55                   	push   %ebp
  801fe6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801fe8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801feb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fee:	6a 00                	push   $0x0
  801ff0:	6a 00                	push   $0x0
  801ff2:	6a 00                	push   $0x0
  801ff4:	52                   	push   %edx
  801ff5:	50                   	push   %eax
  801ff6:	6a 1e                	push   $0x1e
  801ff8:	e8 c0 fc ff ff       	call   801cbd <syscall>
  801ffd:	83 c4 18             	add    $0x18,%esp
}
  802000:	c9                   	leave  
  802001:	c3                   	ret    

00802002 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802002:	55                   	push   %ebp
  802003:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802005:	6a 00                	push   $0x0
  802007:	6a 00                	push   $0x0
  802009:	6a 00                	push   $0x0
  80200b:	6a 00                	push   $0x0
  80200d:	6a 00                	push   $0x0
  80200f:	6a 1f                	push   $0x1f
  802011:	e8 a7 fc ff ff       	call   801cbd <syscall>
  802016:	83 c4 18             	add    $0x18,%esp
}
  802019:	c9                   	leave  
  80201a:	c3                   	ret    

0080201b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80201b:	55                   	push   %ebp
  80201c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80201e:	8b 45 08             	mov    0x8(%ebp),%eax
  802021:	6a 00                	push   $0x0
  802023:	ff 75 14             	pushl  0x14(%ebp)
  802026:	ff 75 10             	pushl  0x10(%ebp)
  802029:	ff 75 0c             	pushl  0xc(%ebp)
  80202c:	50                   	push   %eax
  80202d:	6a 20                	push   $0x20
  80202f:	e8 89 fc ff ff       	call   801cbd <syscall>
  802034:	83 c4 18             	add    $0x18,%esp
}
  802037:	c9                   	leave  
  802038:	c3                   	ret    

00802039 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802039:	55                   	push   %ebp
  80203a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80203c:	8b 45 08             	mov    0x8(%ebp),%eax
  80203f:	6a 00                	push   $0x0
  802041:	6a 00                	push   $0x0
  802043:	6a 00                	push   $0x0
  802045:	6a 00                	push   $0x0
  802047:	50                   	push   %eax
  802048:	6a 21                	push   $0x21
  80204a:	e8 6e fc ff ff       	call   801cbd <syscall>
  80204f:	83 c4 18             	add    $0x18,%esp
}
  802052:	90                   	nop
  802053:	c9                   	leave  
  802054:	c3                   	ret    

00802055 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802055:	55                   	push   %ebp
  802056:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802058:	8b 45 08             	mov    0x8(%ebp),%eax
  80205b:	6a 00                	push   $0x0
  80205d:	6a 00                	push   $0x0
  80205f:	6a 00                	push   $0x0
  802061:	6a 00                	push   $0x0
  802063:	50                   	push   %eax
  802064:	6a 22                	push   $0x22
  802066:	e8 52 fc ff ff       	call   801cbd <syscall>
  80206b:	83 c4 18             	add    $0x18,%esp
}
  80206e:	c9                   	leave  
  80206f:	c3                   	ret    

00802070 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802070:	55                   	push   %ebp
  802071:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802073:	6a 00                	push   $0x0
  802075:	6a 00                	push   $0x0
  802077:	6a 00                	push   $0x0
  802079:	6a 00                	push   $0x0
  80207b:	6a 00                	push   $0x0
  80207d:	6a 02                	push   $0x2
  80207f:	e8 39 fc ff ff       	call   801cbd <syscall>
  802084:	83 c4 18             	add    $0x18,%esp
}
  802087:	c9                   	leave  
  802088:	c3                   	ret    

00802089 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802089:	55                   	push   %ebp
  80208a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80208c:	6a 00                	push   $0x0
  80208e:	6a 00                	push   $0x0
  802090:	6a 00                	push   $0x0
  802092:	6a 00                	push   $0x0
  802094:	6a 00                	push   $0x0
  802096:	6a 03                	push   $0x3
  802098:	e8 20 fc ff ff       	call   801cbd <syscall>
  80209d:	83 c4 18             	add    $0x18,%esp
}
  8020a0:	c9                   	leave  
  8020a1:	c3                   	ret    

008020a2 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8020a2:	55                   	push   %ebp
  8020a3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8020a5:	6a 00                	push   $0x0
  8020a7:	6a 00                	push   $0x0
  8020a9:	6a 00                	push   $0x0
  8020ab:	6a 00                	push   $0x0
  8020ad:	6a 00                	push   $0x0
  8020af:	6a 04                	push   $0x4
  8020b1:	e8 07 fc ff ff       	call   801cbd <syscall>
  8020b6:	83 c4 18             	add    $0x18,%esp
}
  8020b9:	c9                   	leave  
  8020ba:	c3                   	ret    

008020bb <sys_exit_env>:


void sys_exit_env(void)
{
  8020bb:	55                   	push   %ebp
  8020bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8020be:	6a 00                	push   $0x0
  8020c0:	6a 00                	push   $0x0
  8020c2:	6a 00                	push   $0x0
  8020c4:	6a 00                	push   $0x0
  8020c6:	6a 00                	push   $0x0
  8020c8:	6a 23                	push   $0x23
  8020ca:	e8 ee fb ff ff       	call   801cbd <syscall>
  8020cf:	83 c4 18             	add    $0x18,%esp
}
  8020d2:	90                   	nop
  8020d3:	c9                   	leave  
  8020d4:	c3                   	ret    

008020d5 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8020d5:	55                   	push   %ebp
  8020d6:	89 e5                	mov    %esp,%ebp
  8020d8:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8020db:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8020de:	8d 50 04             	lea    0x4(%eax),%edx
  8020e1:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8020e4:	6a 00                	push   $0x0
  8020e6:	6a 00                	push   $0x0
  8020e8:	6a 00                	push   $0x0
  8020ea:	52                   	push   %edx
  8020eb:	50                   	push   %eax
  8020ec:	6a 24                	push   $0x24
  8020ee:	e8 ca fb ff ff       	call   801cbd <syscall>
  8020f3:	83 c4 18             	add    $0x18,%esp
	return result;
  8020f6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8020fc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8020ff:	89 01                	mov    %eax,(%ecx)
  802101:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802104:	8b 45 08             	mov    0x8(%ebp),%eax
  802107:	c9                   	leave  
  802108:	c2 04 00             	ret    $0x4

0080210b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80210b:	55                   	push   %ebp
  80210c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80210e:	6a 00                	push   $0x0
  802110:	6a 00                	push   $0x0
  802112:	ff 75 10             	pushl  0x10(%ebp)
  802115:	ff 75 0c             	pushl  0xc(%ebp)
  802118:	ff 75 08             	pushl  0x8(%ebp)
  80211b:	6a 12                	push   $0x12
  80211d:	e8 9b fb ff ff       	call   801cbd <syscall>
  802122:	83 c4 18             	add    $0x18,%esp
	return ;
  802125:	90                   	nop
}
  802126:	c9                   	leave  
  802127:	c3                   	ret    

00802128 <sys_rcr2>:
uint32 sys_rcr2()
{
  802128:	55                   	push   %ebp
  802129:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80212b:	6a 00                	push   $0x0
  80212d:	6a 00                	push   $0x0
  80212f:	6a 00                	push   $0x0
  802131:	6a 00                	push   $0x0
  802133:	6a 00                	push   $0x0
  802135:	6a 25                	push   $0x25
  802137:	e8 81 fb ff ff       	call   801cbd <syscall>
  80213c:	83 c4 18             	add    $0x18,%esp
}
  80213f:	c9                   	leave  
  802140:	c3                   	ret    

00802141 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802141:	55                   	push   %ebp
  802142:	89 e5                	mov    %esp,%ebp
  802144:	83 ec 04             	sub    $0x4,%esp
  802147:	8b 45 08             	mov    0x8(%ebp),%eax
  80214a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80214d:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802151:	6a 00                	push   $0x0
  802153:	6a 00                	push   $0x0
  802155:	6a 00                	push   $0x0
  802157:	6a 00                	push   $0x0
  802159:	50                   	push   %eax
  80215a:	6a 26                	push   $0x26
  80215c:	e8 5c fb ff ff       	call   801cbd <syscall>
  802161:	83 c4 18             	add    $0x18,%esp
	return ;
  802164:	90                   	nop
}
  802165:	c9                   	leave  
  802166:	c3                   	ret    

00802167 <rsttst>:
void rsttst()
{
  802167:	55                   	push   %ebp
  802168:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80216a:	6a 00                	push   $0x0
  80216c:	6a 00                	push   $0x0
  80216e:	6a 00                	push   $0x0
  802170:	6a 00                	push   $0x0
  802172:	6a 00                	push   $0x0
  802174:	6a 28                	push   $0x28
  802176:	e8 42 fb ff ff       	call   801cbd <syscall>
  80217b:	83 c4 18             	add    $0x18,%esp
	return ;
  80217e:	90                   	nop
}
  80217f:	c9                   	leave  
  802180:	c3                   	ret    

00802181 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802181:	55                   	push   %ebp
  802182:	89 e5                	mov    %esp,%ebp
  802184:	83 ec 04             	sub    $0x4,%esp
  802187:	8b 45 14             	mov    0x14(%ebp),%eax
  80218a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80218d:	8b 55 18             	mov    0x18(%ebp),%edx
  802190:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802194:	52                   	push   %edx
  802195:	50                   	push   %eax
  802196:	ff 75 10             	pushl  0x10(%ebp)
  802199:	ff 75 0c             	pushl  0xc(%ebp)
  80219c:	ff 75 08             	pushl  0x8(%ebp)
  80219f:	6a 27                	push   $0x27
  8021a1:	e8 17 fb ff ff       	call   801cbd <syscall>
  8021a6:	83 c4 18             	add    $0x18,%esp
	return ;
  8021a9:	90                   	nop
}
  8021aa:	c9                   	leave  
  8021ab:	c3                   	ret    

008021ac <chktst>:
void chktst(uint32 n)
{
  8021ac:	55                   	push   %ebp
  8021ad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8021af:	6a 00                	push   $0x0
  8021b1:	6a 00                	push   $0x0
  8021b3:	6a 00                	push   $0x0
  8021b5:	6a 00                	push   $0x0
  8021b7:	ff 75 08             	pushl  0x8(%ebp)
  8021ba:	6a 29                	push   $0x29
  8021bc:	e8 fc fa ff ff       	call   801cbd <syscall>
  8021c1:	83 c4 18             	add    $0x18,%esp
	return ;
  8021c4:	90                   	nop
}
  8021c5:	c9                   	leave  
  8021c6:	c3                   	ret    

008021c7 <inctst>:

void inctst()
{
  8021c7:	55                   	push   %ebp
  8021c8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8021ca:	6a 00                	push   $0x0
  8021cc:	6a 00                	push   $0x0
  8021ce:	6a 00                	push   $0x0
  8021d0:	6a 00                	push   $0x0
  8021d2:	6a 00                	push   $0x0
  8021d4:	6a 2a                	push   $0x2a
  8021d6:	e8 e2 fa ff ff       	call   801cbd <syscall>
  8021db:	83 c4 18             	add    $0x18,%esp
	return ;
  8021de:	90                   	nop
}
  8021df:	c9                   	leave  
  8021e0:	c3                   	ret    

008021e1 <gettst>:
uint32 gettst()
{
  8021e1:	55                   	push   %ebp
  8021e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8021e4:	6a 00                	push   $0x0
  8021e6:	6a 00                	push   $0x0
  8021e8:	6a 00                	push   $0x0
  8021ea:	6a 00                	push   $0x0
  8021ec:	6a 00                	push   $0x0
  8021ee:	6a 2b                	push   $0x2b
  8021f0:	e8 c8 fa ff ff       	call   801cbd <syscall>
  8021f5:	83 c4 18             	add    $0x18,%esp
}
  8021f8:	c9                   	leave  
  8021f9:	c3                   	ret    

008021fa <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8021fa:	55                   	push   %ebp
  8021fb:	89 e5                	mov    %esp,%ebp
  8021fd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802200:	6a 00                	push   $0x0
  802202:	6a 00                	push   $0x0
  802204:	6a 00                	push   $0x0
  802206:	6a 00                	push   $0x0
  802208:	6a 00                	push   $0x0
  80220a:	6a 2c                	push   $0x2c
  80220c:	e8 ac fa ff ff       	call   801cbd <syscall>
  802211:	83 c4 18             	add    $0x18,%esp
  802214:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802217:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80221b:	75 07                	jne    802224 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80221d:	b8 01 00 00 00       	mov    $0x1,%eax
  802222:	eb 05                	jmp    802229 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802224:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802229:	c9                   	leave  
  80222a:	c3                   	ret    

0080222b <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80222b:	55                   	push   %ebp
  80222c:	89 e5                	mov    %esp,%ebp
  80222e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802231:	6a 00                	push   $0x0
  802233:	6a 00                	push   $0x0
  802235:	6a 00                	push   $0x0
  802237:	6a 00                	push   $0x0
  802239:	6a 00                	push   $0x0
  80223b:	6a 2c                	push   $0x2c
  80223d:	e8 7b fa ff ff       	call   801cbd <syscall>
  802242:	83 c4 18             	add    $0x18,%esp
  802245:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802248:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80224c:	75 07                	jne    802255 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80224e:	b8 01 00 00 00       	mov    $0x1,%eax
  802253:	eb 05                	jmp    80225a <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802255:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80225a:	c9                   	leave  
  80225b:	c3                   	ret    

0080225c <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80225c:	55                   	push   %ebp
  80225d:	89 e5                	mov    %esp,%ebp
  80225f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802262:	6a 00                	push   $0x0
  802264:	6a 00                	push   $0x0
  802266:	6a 00                	push   $0x0
  802268:	6a 00                	push   $0x0
  80226a:	6a 00                	push   $0x0
  80226c:	6a 2c                	push   $0x2c
  80226e:	e8 4a fa ff ff       	call   801cbd <syscall>
  802273:	83 c4 18             	add    $0x18,%esp
  802276:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802279:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80227d:	75 07                	jne    802286 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80227f:	b8 01 00 00 00       	mov    $0x1,%eax
  802284:	eb 05                	jmp    80228b <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802286:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80228b:	c9                   	leave  
  80228c:	c3                   	ret    

0080228d <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80228d:	55                   	push   %ebp
  80228e:	89 e5                	mov    %esp,%ebp
  802290:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802293:	6a 00                	push   $0x0
  802295:	6a 00                	push   $0x0
  802297:	6a 00                	push   $0x0
  802299:	6a 00                	push   $0x0
  80229b:	6a 00                	push   $0x0
  80229d:	6a 2c                	push   $0x2c
  80229f:	e8 19 fa ff ff       	call   801cbd <syscall>
  8022a4:	83 c4 18             	add    $0x18,%esp
  8022a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8022aa:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8022ae:	75 07                	jne    8022b7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8022b0:	b8 01 00 00 00       	mov    $0x1,%eax
  8022b5:	eb 05                	jmp    8022bc <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8022b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022bc:	c9                   	leave  
  8022bd:	c3                   	ret    

008022be <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8022be:	55                   	push   %ebp
  8022bf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8022c1:	6a 00                	push   $0x0
  8022c3:	6a 00                	push   $0x0
  8022c5:	6a 00                	push   $0x0
  8022c7:	6a 00                	push   $0x0
  8022c9:	ff 75 08             	pushl  0x8(%ebp)
  8022cc:	6a 2d                	push   $0x2d
  8022ce:	e8 ea f9 ff ff       	call   801cbd <syscall>
  8022d3:	83 c4 18             	add    $0x18,%esp
	return ;
  8022d6:	90                   	nop
}
  8022d7:	c9                   	leave  
  8022d8:	c3                   	ret    

008022d9 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8022d9:	55                   	push   %ebp
  8022da:	89 e5                	mov    %esp,%ebp
  8022dc:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8022dd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8022e0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e9:	6a 00                	push   $0x0
  8022eb:	53                   	push   %ebx
  8022ec:	51                   	push   %ecx
  8022ed:	52                   	push   %edx
  8022ee:	50                   	push   %eax
  8022ef:	6a 2e                	push   $0x2e
  8022f1:	e8 c7 f9 ff ff       	call   801cbd <syscall>
  8022f6:	83 c4 18             	add    $0x18,%esp
}
  8022f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022fc:	c9                   	leave  
  8022fd:	c3                   	ret    

008022fe <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8022fe:	55                   	push   %ebp
  8022ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802301:	8b 55 0c             	mov    0xc(%ebp),%edx
  802304:	8b 45 08             	mov    0x8(%ebp),%eax
  802307:	6a 00                	push   $0x0
  802309:	6a 00                	push   $0x0
  80230b:	6a 00                	push   $0x0
  80230d:	52                   	push   %edx
  80230e:	50                   	push   %eax
  80230f:	6a 2f                	push   $0x2f
  802311:	e8 a7 f9 ff ff       	call   801cbd <syscall>
  802316:	83 c4 18             	add    $0x18,%esp
}
  802319:	c9                   	leave  
  80231a:	c3                   	ret    

0080231b <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80231b:	55                   	push   %ebp
  80231c:	89 e5                	mov    %esp,%ebp
  80231e:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802321:	83 ec 0c             	sub    $0xc,%esp
  802324:	68 5c 3f 80 00       	push   $0x803f5c
  802329:	e8 21 e7 ff ff       	call   800a4f <cprintf>
  80232e:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802331:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802338:	83 ec 0c             	sub    $0xc,%esp
  80233b:	68 88 3f 80 00       	push   $0x803f88
  802340:	e8 0a e7 ff ff       	call   800a4f <cprintf>
  802345:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802348:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80234c:	a1 38 51 80 00       	mov    0x805138,%eax
  802351:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802354:	eb 56                	jmp    8023ac <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802356:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80235a:	74 1c                	je     802378 <print_mem_block_lists+0x5d>
  80235c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235f:	8b 50 08             	mov    0x8(%eax),%edx
  802362:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802365:	8b 48 08             	mov    0x8(%eax),%ecx
  802368:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80236b:	8b 40 0c             	mov    0xc(%eax),%eax
  80236e:	01 c8                	add    %ecx,%eax
  802370:	39 c2                	cmp    %eax,%edx
  802372:	73 04                	jae    802378 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802374:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802378:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237b:	8b 50 08             	mov    0x8(%eax),%edx
  80237e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802381:	8b 40 0c             	mov    0xc(%eax),%eax
  802384:	01 c2                	add    %eax,%edx
  802386:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802389:	8b 40 08             	mov    0x8(%eax),%eax
  80238c:	83 ec 04             	sub    $0x4,%esp
  80238f:	52                   	push   %edx
  802390:	50                   	push   %eax
  802391:	68 9d 3f 80 00       	push   $0x803f9d
  802396:	e8 b4 e6 ff ff       	call   800a4f <cprintf>
  80239b:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80239e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8023a4:	a1 40 51 80 00       	mov    0x805140,%eax
  8023a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023b0:	74 07                	je     8023b9 <print_mem_block_lists+0x9e>
  8023b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b5:	8b 00                	mov    (%eax),%eax
  8023b7:	eb 05                	jmp    8023be <print_mem_block_lists+0xa3>
  8023b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8023be:	a3 40 51 80 00       	mov    %eax,0x805140
  8023c3:	a1 40 51 80 00       	mov    0x805140,%eax
  8023c8:	85 c0                	test   %eax,%eax
  8023ca:	75 8a                	jne    802356 <print_mem_block_lists+0x3b>
  8023cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023d0:	75 84                	jne    802356 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8023d2:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8023d6:	75 10                	jne    8023e8 <print_mem_block_lists+0xcd>
  8023d8:	83 ec 0c             	sub    $0xc,%esp
  8023db:	68 ac 3f 80 00       	push   $0x803fac
  8023e0:	e8 6a e6 ff ff       	call   800a4f <cprintf>
  8023e5:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8023e8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8023ef:	83 ec 0c             	sub    $0xc,%esp
  8023f2:	68 d0 3f 80 00       	push   $0x803fd0
  8023f7:	e8 53 e6 ff ff       	call   800a4f <cprintf>
  8023fc:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8023ff:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802403:	a1 40 50 80 00       	mov    0x805040,%eax
  802408:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80240b:	eb 56                	jmp    802463 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80240d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802411:	74 1c                	je     80242f <print_mem_block_lists+0x114>
  802413:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802416:	8b 50 08             	mov    0x8(%eax),%edx
  802419:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80241c:	8b 48 08             	mov    0x8(%eax),%ecx
  80241f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802422:	8b 40 0c             	mov    0xc(%eax),%eax
  802425:	01 c8                	add    %ecx,%eax
  802427:	39 c2                	cmp    %eax,%edx
  802429:	73 04                	jae    80242f <print_mem_block_lists+0x114>
			sorted = 0 ;
  80242b:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80242f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802432:	8b 50 08             	mov    0x8(%eax),%edx
  802435:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802438:	8b 40 0c             	mov    0xc(%eax),%eax
  80243b:	01 c2                	add    %eax,%edx
  80243d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802440:	8b 40 08             	mov    0x8(%eax),%eax
  802443:	83 ec 04             	sub    $0x4,%esp
  802446:	52                   	push   %edx
  802447:	50                   	push   %eax
  802448:	68 9d 3f 80 00       	push   $0x803f9d
  80244d:	e8 fd e5 ff ff       	call   800a4f <cprintf>
  802452:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802455:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802458:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80245b:	a1 48 50 80 00       	mov    0x805048,%eax
  802460:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802463:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802467:	74 07                	je     802470 <print_mem_block_lists+0x155>
  802469:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246c:	8b 00                	mov    (%eax),%eax
  80246e:	eb 05                	jmp    802475 <print_mem_block_lists+0x15a>
  802470:	b8 00 00 00 00       	mov    $0x0,%eax
  802475:	a3 48 50 80 00       	mov    %eax,0x805048
  80247a:	a1 48 50 80 00       	mov    0x805048,%eax
  80247f:	85 c0                	test   %eax,%eax
  802481:	75 8a                	jne    80240d <print_mem_block_lists+0xf2>
  802483:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802487:	75 84                	jne    80240d <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802489:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80248d:	75 10                	jne    80249f <print_mem_block_lists+0x184>
  80248f:	83 ec 0c             	sub    $0xc,%esp
  802492:	68 e8 3f 80 00       	push   $0x803fe8
  802497:	e8 b3 e5 ff ff       	call   800a4f <cprintf>
  80249c:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80249f:	83 ec 0c             	sub    $0xc,%esp
  8024a2:	68 5c 3f 80 00       	push   $0x803f5c
  8024a7:	e8 a3 e5 ff ff       	call   800a4f <cprintf>
  8024ac:	83 c4 10             	add    $0x10,%esp

}
  8024af:	90                   	nop
  8024b0:	c9                   	leave  
  8024b1:	c3                   	ret    

008024b2 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8024b2:	55                   	push   %ebp
  8024b3:	89 e5                	mov    %esp,%ebp
  8024b5:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  8024b8:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8024bf:	00 00 00 
  8024c2:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8024c9:	00 00 00 
  8024cc:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8024d3:	00 00 00 
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  8024d6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8024dd:	e9 9e 00 00 00       	jmp    802580 <initialize_MemBlocksList+0xce>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
  8024e2:	a1 50 50 80 00       	mov    0x805050,%eax
  8024e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024ea:	c1 e2 04             	shl    $0x4,%edx
  8024ed:	01 d0                	add    %edx,%eax
  8024ef:	85 c0                	test   %eax,%eax
  8024f1:	75 14                	jne    802507 <initialize_MemBlocksList+0x55>
  8024f3:	83 ec 04             	sub    $0x4,%esp
  8024f6:	68 10 40 80 00       	push   $0x804010
  8024fb:	6a 43                	push   $0x43
  8024fd:	68 33 40 80 00       	push   $0x804033
  802502:	e8 94 e2 ff ff       	call   80079b <_panic>
  802507:	a1 50 50 80 00       	mov    0x805050,%eax
  80250c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80250f:	c1 e2 04             	shl    $0x4,%edx
  802512:	01 d0                	add    %edx,%eax
  802514:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80251a:	89 10                	mov    %edx,(%eax)
  80251c:	8b 00                	mov    (%eax),%eax
  80251e:	85 c0                	test   %eax,%eax
  802520:	74 18                	je     80253a <initialize_MemBlocksList+0x88>
  802522:	a1 48 51 80 00       	mov    0x805148,%eax
  802527:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80252d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802530:	c1 e1 04             	shl    $0x4,%ecx
  802533:	01 ca                	add    %ecx,%edx
  802535:	89 50 04             	mov    %edx,0x4(%eax)
  802538:	eb 12                	jmp    80254c <initialize_MemBlocksList+0x9a>
  80253a:	a1 50 50 80 00       	mov    0x805050,%eax
  80253f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802542:	c1 e2 04             	shl    $0x4,%edx
  802545:	01 d0                	add    %edx,%eax
  802547:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80254c:	a1 50 50 80 00       	mov    0x805050,%eax
  802551:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802554:	c1 e2 04             	shl    $0x4,%edx
  802557:	01 d0                	add    %edx,%eax
  802559:	a3 48 51 80 00       	mov    %eax,0x805148
  80255e:	a1 50 50 80 00       	mov    0x805050,%eax
  802563:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802566:	c1 e2 04             	shl    $0x4,%edx
  802569:	01 d0                	add    %edx,%eax
  80256b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802572:	a1 54 51 80 00       	mov    0x805154,%eax
  802577:	40                   	inc    %eax
  802578:	a3 54 51 80 00       	mov    %eax,0x805154
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  80257d:	ff 45 f4             	incl   -0xc(%ebp)
  802580:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802583:	3b 45 08             	cmp    0x8(%ebp),%eax
  802586:	0f 82 56 ff ff ff    	jb     8024e2 <initialize_MemBlocksList+0x30>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
		}
}
  80258c:	90                   	nop
  80258d:	c9                   	leave  
  80258e:	c3                   	ret    

0080258f <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80258f:	55                   	push   %ebp
  802590:	89 e5                	mov    %esp,%ebp
  802592:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  802595:	a1 38 51 80 00       	mov    0x805138,%eax
  80259a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80259d:	eb 18                	jmp    8025b7 <find_block+0x28>
	{
		if (ele->sva==va)
  80259f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025a2:	8b 40 08             	mov    0x8(%eax),%eax
  8025a5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8025a8:	75 05                	jne    8025af <find_block+0x20>
			return ele;
  8025aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025ad:	eb 7b                	jmp    80262a <find_block+0x9b>
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  8025af:	a1 40 51 80 00       	mov    0x805140,%eax
  8025b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8025b7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8025bb:	74 07                	je     8025c4 <find_block+0x35>
  8025bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025c0:	8b 00                	mov    (%eax),%eax
  8025c2:	eb 05                	jmp    8025c9 <find_block+0x3a>
  8025c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8025c9:	a3 40 51 80 00       	mov    %eax,0x805140
  8025ce:	a1 40 51 80 00       	mov    0x805140,%eax
  8025d3:	85 c0                	test   %eax,%eax
  8025d5:	75 c8                	jne    80259f <find_block+0x10>
  8025d7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8025db:	75 c2                	jne    80259f <find_block+0x10>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  8025dd:	a1 40 50 80 00       	mov    0x805040,%eax
  8025e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8025e5:	eb 18                	jmp    8025ff <find_block+0x70>
	{
		if (ele->sva==va)
  8025e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025ea:	8b 40 08             	mov    0x8(%eax),%eax
  8025ed:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8025f0:	75 05                	jne    8025f7 <find_block+0x68>
					return ele;
  8025f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025f5:	eb 33                	jmp    80262a <find_block+0x9b>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  8025f7:	a1 48 50 80 00       	mov    0x805048,%eax
  8025fc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8025ff:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802603:	74 07                	je     80260c <find_block+0x7d>
  802605:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802608:	8b 00                	mov    (%eax),%eax
  80260a:	eb 05                	jmp    802611 <find_block+0x82>
  80260c:	b8 00 00 00 00       	mov    $0x0,%eax
  802611:	a3 48 50 80 00       	mov    %eax,0x805048
  802616:	a1 48 50 80 00       	mov    0x805048,%eax
  80261b:	85 c0                	test   %eax,%eax
  80261d:	75 c8                	jne    8025e7 <find_block+0x58>
  80261f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802623:	75 c2                	jne    8025e7 <find_block+0x58>
	{
		if (ele->sva==va)
					return ele;
	}
return NULL;
  802625:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  80262a:	c9                   	leave  
  80262b:	c3                   	ret    

0080262c <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80262c:	55                   	push   %ebp
  80262d:	89 e5                	mov    %esp,%ebp
  80262f:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;

int x =LIST_SIZE(&AllocMemBlocksList);
  802632:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802637:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((x==0))
  80263a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80263e:	75 62                	jne    8026a2 <insert_sorted_allocList+0x76>
	{
	//	blockToInsert=AllocMemBlocksList.lh_first;
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  802640:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802644:	75 14                	jne    80265a <insert_sorted_allocList+0x2e>
  802646:	83 ec 04             	sub    $0x4,%esp
  802649:	68 10 40 80 00       	push   $0x804010
  80264e:	6a 69                	push   $0x69
  802650:	68 33 40 80 00       	push   $0x804033
  802655:	e8 41 e1 ff ff       	call   80079b <_panic>
  80265a:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802660:	8b 45 08             	mov    0x8(%ebp),%eax
  802663:	89 10                	mov    %edx,(%eax)
  802665:	8b 45 08             	mov    0x8(%ebp),%eax
  802668:	8b 00                	mov    (%eax),%eax
  80266a:	85 c0                	test   %eax,%eax
  80266c:	74 0d                	je     80267b <insert_sorted_allocList+0x4f>
  80266e:	a1 40 50 80 00       	mov    0x805040,%eax
  802673:	8b 55 08             	mov    0x8(%ebp),%edx
  802676:	89 50 04             	mov    %edx,0x4(%eax)
  802679:	eb 08                	jmp    802683 <insert_sorted_allocList+0x57>
  80267b:	8b 45 08             	mov    0x8(%ebp),%eax
  80267e:	a3 44 50 80 00       	mov    %eax,0x805044
  802683:	8b 45 08             	mov    0x8(%ebp),%eax
  802686:	a3 40 50 80 00       	mov    %eax,0x805040
  80268b:	8b 45 08             	mov    0x8(%ebp),%eax
  80268e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802695:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80269a:	40                   	inc    %eax
  80269b:	a3 4c 50 80 00       	mov    %eax,0x80504c
  8026a0:	eb 72                	jmp    802714 <insert_sorted_allocList+0xe8>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
  8026a2:	a1 40 50 80 00       	mov    0x805040,%eax
  8026a7:	8b 50 08             	mov    0x8(%eax),%edx
  8026aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ad:	8b 40 08             	mov    0x8(%eax),%eax
  8026b0:	39 c2                	cmp    %eax,%edx
  8026b2:	76 60                	jbe    802714 <insert_sorted_allocList+0xe8>
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  8026b4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8026b8:	75 14                	jne    8026ce <insert_sorted_allocList+0xa2>
  8026ba:	83 ec 04             	sub    $0x4,%esp
  8026bd:	68 10 40 80 00       	push   $0x804010
  8026c2:	6a 6d                	push   $0x6d
  8026c4:	68 33 40 80 00       	push   $0x804033
  8026c9:	e8 cd e0 ff ff       	call   80079b <_panic>
  8026ce:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8026d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d7:	89 10                	mov    %edx,(%eax)
  8026d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8026dc:	8b 00                	mov    (%eax),%eax
  8026de:	85 c0                	test   %eax,%eax
  8026e0:	74 0d                	je     8026ef <insert_sorted_allocList+0xc3>
  8026e2:	a1 40 50 80 00       	mov    0x805040,%eax
  8026e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8026ea:	89 50 04             	mov    %edx,0x4(%eax)
  8026ed:	eb 08                	jmp    8026f7 <insert_sorted_allocList+0xcb>
  8026ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f2:	a3 44 50 80 00       	mov    %eax,0x805044
  8026f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026fa:	a3 40 50 80 00       	mov    %eax,0x805040
  8026ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802702:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802709:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80270e:	40                   	inc    %eax
  80270f:	a3 4c 50 80 00       	mov    %eax,0x80504c
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  802714:	a1 40 50 80 00       	mov    0x805040,%eax
  802719:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80271c:	e9 b9 01 00 00       	jmp    8028da <insert_sorted_allocList+0x2ae>
	{


		if ((blockToInsert->sva>AllocMemBlocksList.lh_first->sva)&&blockToInsert->sva<element->sva)
  802721:	8b 45 08             	mov    0x8(%ebp),%eax
  802724:	8b 50 08             	mov    0x8(%eax),%edx
  802727:	a1 40 50 80 00       	mov    0x805040,%eax
  80272c:	8b 40 08             	mov    0x8(%eax),%eax
  80272f:	39 c2                	cmp    %eax,%edx
  802731:	76 7c                	jbe    8027af <insert_sorted_allocList+0x183>
  802733:	8b 45 08             	mov    0x8(%ebp),%eax
  802736:	8b 50 08             	mov    0x8(%eax),%edx
  802739:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273c:	8b 40 08             	mov    0x8(%eax),%eax
  80273f:	39 c2                	cmp    %eax,%edx
  802741:	73 6c                	jae    8027af <insert_sorted_allocList+0x183>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,element,blockToInsert);
  802743:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802747:	74 06                	je     80274f <insert_sorted_allocList+0x123>
  802749:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80274d:	75 14                	jne    802763 <insert_sorted_allocList+0x137>
  80274f:	83 ec 04             	sub    $0x4,%esp
  802752:	68 4c 40 80 00       	push   $0x80404c
  802757:	6a 75                	push   $0x75
  802759:	68 33 40 80 00       	push   $0x804033
  80275e:	e8 38 e0 ff ff       	call   80079b <_panic>
  802763:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802766:	8b 50 04             	mov    0x4(%eax),%edx
  802769:	8b 45 08             	mov    0x8(%ebp),%eax
  80276c:	89 50 04             	mov    %edx,0x4(%eax)
  80276f:	8b 45 08             	mov    0x8(%ebp),%eax
  802772:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802775:	89 10                	mov    %edx,(%eax)
  802777:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277a:	8b 40 04             	mov    0x4(%eax),%eax
  80277d:	85 c0                	test   %eax,%eax
  80277f:	74 0d                	je     80278e <insert_sorted_allocList+0x162>
  802781:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802784:	8b 40 04             	mov    0x4(%eax),%eax
  802787:	8b 55 08             	mov    0x8(%ebp),%edx
  80278a:	89 10                	mov    %edx,(%eax)
  80278c:	eb 08                	jmp    802796 <insert_sorted_allocList+0x16a>
  80278e:	8b 45 08             	mov    0x8(%ebp),%eax
  802791:	a3 40 50 80 00       	mov    %eax,0x805040
  802796:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802799:	8b 55 08             	mov    0x8(%ebp),%edx
  80279c:	89 50 04             	mov    %edx,0x4(%eax)
  80279f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8027a4:	40                   	inc    %eax
  8027a5:	a3 4c 50 80 00       	mov    %eax,0x80504c

		break;}
  8027aa:	e9 59 01 00 00       	jmp    802908 <insert_sorted_allocList+0x2dc>

	else if ((blockToInsert->sva>element->sva)&&(blockToInsert->sva<AllocMemBlocksList.lh_last->sva)&&blockToInsert->sva<LIST_NEXT(element)->sva)
  8027af:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b2:	8b 50 08             	mov    0x8(%eax),%edx
  8027b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b8:	8b 40 08             	mov    0x8(%eax),%eax
  8027bb:	39 c2                	cmp    %eax,%edx
  8027bd:	0f 86 98 00 00 00    	jbe    80285b <insert_sorted_allocList+0x22f>
  8027c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c6:	8b 50 08             	mov    0x8(%eax),%edx
  8027c9:	a1 44 50 80 00       	mov    0x805044,%eax
  8027ce:	8b 40 08             	mov    0x8(%eax),%eax
  8027d1:	39 c2                	cmp    %eax,%edx
  8027d3:	0f 83 82 00 00 00    	jae    80285b <insert_sorted_allocList+0x22f>
  8027d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027dc:	8b 50 08             	mov    0x8(%eax),%edx
  8027df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e2:	8b 00                	mov    (%eax),%eax
  8027e4:	8b 40 08             	mov    0x8(%eax),%eax
  8027e7:	39 c2                	cmp    %eax,%edx
  8027e9:	73 70                	jae    80285b <insert_sorted_allocList+0x22f>
	{

	LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  8027eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027ef:	74 06                	je     8027f7 <insert_sorted_allocList+0x1cb>
  8027f1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027f5:	75 14                	jne    80280b <insert_sorted_allocList+0x1df>
  8027f7:	83 ec 04             	sub    $0x4,%esp
  8027fa:	68 84 40 80 00       	push   $0x804084
  8027ff:	6a 7c                	push   $0x7c
  802801:	68 33 40 80 00       	push   $0x804033
  802806:	e8 90 df ff ff       	call   80079b <_panic>
  80280b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280e:	8b 10                	mov    (%eax),%edx
  802810:	8b 45 08             	mov    0x8(%ebp),%eax
  802813:	89 10                	mov    %edx,(%eax)
  802815:	8b 45 08             	mov    0x8(%ebp),%eax
  802818:	8b 00                	mov    (%eax),%eax
  80281a:	85 c0                	test   %eax,%eax
  80281c:	74 0b                	je     802829 <insert_sorted_allocList+0x1fd>
  80281e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802821:	8b 00                	mov    (%eax),%eax
  802823:	8b 55 08             	mov    0x8(%ebp),%edx
  802826:	89 50 04             	mov    %edx,0x4(%eax)
  802829:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282c:	8b 55 08             	mov    0x8(%ebp),%edx
  80282f:	89 10                	mov    %edx,(%eax)
  802831:	8b 45 08             	mov    0x8(%ebp),%eax
  802834:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802837:	89 50 04             	mov    %edx,0x4(%eax)
  80283a:	8b 45 08             	mov    0x8(%ebp),%eax
  80283d:	8b 00                	mov    (%eax),%eax
  80283f:	85 c0                	test   %eax,%eax
  802841:	75 08                	jne    80284b <insert_sorted_allocList+0x21f>
  802843:	8b 45 08             	mov    0x8(%ebp),%eax
  802846:	a3 44 50 80 00       	mov    %eax,0x805044
  80284b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802850:	40                   	inc    %eax
  802851:	a3 4c 50 80 00       	mov    %eax,0x80504c
		break;
  802856:	e9 ad 00 00 00       	jmp    802908 <insert_sorted_allocList+0x2dc>
	}else if (blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  80285b:	8b 45 08             	mov    0x8(%ebp),%eax
  80285e:	8b 50 08             	mov    0x8(%eax),%edx
  802861:	a1 44 50 80 00       	mov    0x805044,%eax
  802866:	8b 40 08             	mov    0x8(%eax),%eax
  802869:	39 c2                	cmp    %eax,%edx
  80286b:	76 65                	jbe    8028d2 <insert_sorted_allocList+0x2a6>
	{
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
  80286d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802871:	75 17                	jne    80288a <insert_sorted_allocList+0x25e>
  802873:	83 ec 04             	sub    $0x4,%esp
  802876:	68 b8 40 80 00       	push   $0x8040b8
  80287b:	68 80 00 00 00       	push   $0x80
  802880:	68 33 40 80 00       	push   $0x804033
  802885:	e8 11 df ff ff       	call   80079b <_panic>
  80288a:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802890:	8b 45 08             	mov    0x8(%ebp),%eax
  802893:	89 50 04             	mov    %edx,0x4(%eax)
  802896:	8b 45 08             	mov    0x8(%ebp),%eax
  802899:	8b 40 04             	mov    0x4(%eax),%eax
  80289c:	85 c0                	test   %eax,%eax
  80289e:	74 0c                	je     8028ac <insert_sorted_allocList+0x280>
  8028a0:	a1 44 50 80 00       	mov    0x805044,%eax
  8028a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8028a8:	89 10                	mov    %edx,(%eax)
  8028aa:	eb 08                	jmp    8028b4 <insert_sorted_allocList+0x288>
  8028ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8028af:	a3 40 50 80 00       	mov    %eax,0x805040
  8028b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b7:	a3 44 50 80 00       	mov    %eax,0x805044
  8028bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8028bf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028c5:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8028ca:	40                   	inc    %eax
  8028cb:	a3 4c 50 80 00       	mov    %eax,0x80504c
		break;
  8028d0:	eb 36                	jmp    802908 <insert_sorted_allocList+0x2dc>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  8028d2:	a1 48 50 80 00       	mov    0x805048,%eax
  8028d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028de:	74 07                	je     8028e7 <insert_sorted_allocList+0x2bb>
  8028e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e3:	8b 00                	mov    (%eax),%eax
  8028e5:	eb 05                	jmp    8028ec <insert_sorted_allocList+0x2c0>
  8028e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8028ec:	a3 48 50 80 00       	mov    %eax,0x805048
  8028f1:	a1 48 50 80 00       	mov    0x805048,%eax
  8028f6:	85 c0                	test   %eax,%eax
  8028f8:	0f 85 23 fe ff ff    	jne    802721 <insert_sorted_allocList+0xf5>
  8028fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802902:	0f 85 19 fe ff ff    	jne    802721 <insert_sorted_allocList+0xf5>
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
		break;

	}
	}
}
  802908:	90                   	nop
  802909:	c9                   	leave  
  80290a:	c3                   	ret    

0080290b <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80290b:	55                   	push   %ebp
  80290c:	89 e5                	mov    %esp,%ebp
  80290e:	83 ec 18             	sub    $0x18,%esp
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802911:	a1 38 51 80 00       	mov    0x805138,%eax
  802916:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802919:	e9 7c 01 00 00       	jmp    802a9a <alloc_block_FF+0x18f>
		{
			// case 2
				if(element->size == size)
  80291e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802921:	8b 40 0c             	mov    0xc(%eax),%eax
  802924:	3b 45 08             	cmp    0x8(%ebp),%eax
  802927:	0f 85 90 00 00 00    	jne    8029bd <alloc_block_FF+0xb2>
				{
					tmp_block=element;
  80292d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802930:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,element);
  802933:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802937:	75 17                	jne    802950 <alloc_block_FF+0x45>
  802939:	83 ec 04             	sub    $0x4,%esp
  80293c:	68 db 40 80 00       	push   $0x8040db
  802941:	68 ba 00 00 00       	push   $0xba
  802946:	68 33 40 80 00       	push   $0x804033
  80294b:	e8 4b de ff ff       	call   80079b <_panic>
  802950:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802953:	8b 00                	mov    (%eax),%eax
  802955:	85 c0                	test   %eax,%eax
  802957:	74 10                	je     802969 <alloc_block_FF+0x5e>
  802959:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295c:	8b 00                	mov    (%eax),%eax
  80295e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802961:	8b 52 04             	mov    0x4(%edx),%edx
  802964:	89 50 04             	mov    %edx,0x4(%eax)
  802967:	eb 0b                	jmp    802974 <alloc_block_FF+0x69>
  802969:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296c:	8b 40 04             	mov    0x4(%eax),%eax
  80296f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802974:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802977:	8b 40 04             	mov    0x4(%eax),%eax
  80297a:	85 c0                	test   %eax,%eax
  80297c:	74 0f                	je     80298d <alloc_block_FF+0x82>
  80297e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802981:	8b 40 04             	mov    0x4(%eax),%eax
  802984:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802987:	8b 12                	mov    (%edx),%edx
  802989:	89 10                	mov    %edx,(%eax)
  80298b:	eb 0a                	jmp    802997 <alloc_block_FF+0x8c>
  80298d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802990:	8b 00                	mov    (%eax),%eax
  802992:	a3 38 51 80 00       	mov    %eax,0x805138
  802997:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029aa:	a1 44 51 80 00       	mov    0x805144,%eax
  8029af:	48                   	dec    %eax
  8029b0:	a3 44 51 80 00       	mov    %eax,0x805144
					return tmp_block;
  8029b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029b8:	e9 10 01 00 00       	jmp    802acd <alloc_block_FF+0x1c2>
				}
				 // case 3
				else if(element->size > size)
  8029bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8029c3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029c6:	0f 86 c6 00 00 00    	jbe    802a92 <alloc_block_FF+0x187>
				{
					// the new block are created
					tmp_block = AvailableMemBlocksList.lh_first ;
  8029cc:	a1 48 51 80 00       	mov    0x805148,%eax
  8029d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  8029d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029d8:	75 17                	jne    8029f1 <alloc_block_FF+0xe6>
  8029da:	83 ec 04             	sub    $0x4,%esp
  8029dd:	68 db 40 80 00       	push   $0x8040db
  8029e2:	68 c2 00 00 00       	push   $0xc2
  8029e7:	68 33 40 80 00       	push   $0x804033
  8029ec:	e8 aa dd ff ff       	call   80079b <_panic>
  8029f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f4:	8b 00                	mov    (%eax),%eax
  8029f6:	85 c0                	test   %eax,%eax
  8029f8:	74 10                	je     802a0a <alloc_block_FF+0xff>
  8029fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029fd:	8b 00                	mov    (%eax),%eax
  8029ff:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a02:	8b 52 04             	mov    0x4(%edx),%edx
  802a05:	89 50 04             	mov    %edx,0x4(%eax)
  802a08:	eb 0b                	jmp    802a15 <alloc_block_FF+0x10a>
  802a0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a0d:	8b 40 04             	mov    0x4(%eax),%eax
  802a10:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a18:	8b 40 04             	mov    0x4(%eax),%eax
  802a1b:	85 c0                	test   %eax,%eax
  802a1d:	74 0f                	je     802a2e <alloc_block_FF+0x123>
  802a1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a22:	8b 40 04             	mov    0x4(%eax),%eax
  802a25:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a28:	8b 12                	mov    (%edx),%edx
  802a2a:	89 10                	mov    %edx,(%eax)
  802a2c:	eb 0a                	jmp    802a38 <alloc_block_FF+0x12d>
  802a2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a31:	8b 00                	mov    (%eax),%eax
  802a33:	a3 48 51 80 00       	mov    %eax,0x805148
  802a38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a3b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a44:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a4b:	a1 54 51 80 00       	mov    0x805154,%eax
  802a50:	48                   	dec    %eax
  802a51:	a3 54 51 80 00       	mov    %eax,0x805154
					tmp_block->sva=element->sva;
  802a56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a59:	8b 50 08             	mov    0x8(%eax),%edx
  802a5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a5f:	89 50 08             	mov    %edx,0x8(%eax)
					tmp_block->size=size;
  802a62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a65:	8b 55 08             	mov    0x8(%ebp),%edx
  802a68:	89 50 0c             	mov    %edx,0xc(%eax)
					//update block with remaining space
					element->size-=size;
  802a6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6e:	8b 40 0c             	mov    0xc(%eax),%eax
  802a71:	2b 45 08             	sub    0x8(%ebp),%eax
  802a74:	89 c2                	mov    %eax,%edx
  802a76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a79:	89 50 0c             	mov    %edx,0xc(%eax)
					element->sva = element->sva + size;
  802a7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7f:	8b 50 08             	mov    0x8(%eax),%edx
  802a82:	8b 45 08             	mov    0x8(%ebp),%eax
  802a85:	01 c2                	add    %eax,%edx
  802a87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8a:	89 50 08             	mov    %edx,0x8(%eax)
					// return back the new block
					return tmp_block ;
  802a8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a90:	eb 3b                	jmp    802acd <alloc_block_FF+0x1c2>
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802a92:	a1 40 51 80 00       	mov    0x805140,%eax
  802a97:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a9a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a9e:	74 07                	je     802aa7 <alloc_block_FF+0x19c>
  802aa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa3:	8b 00                	mov    (%eax),%eax
  802aa5:	eb 05                	jmp    802aac <alloc_block_FF+0x1a1>
  802aa7:	b8 00 00 00 00       	mov    $0x0,%eax
  802aac:	a3 40 51 80 00       	mov    %eax,0x805140
  802ab1:	a1 40 51 80 00       	mov    0x805140,%eax
  802ab6:	85 c0                	test   %eax,%eax
  802ab8:	0f 85 60 fe ff ff    	jne    80291e <alloc_block_FF+0x13>
  802abe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ac2:	0f 85 56 fe ff ff    	jne    80291e <alloc_block_FF+0x13>
					// return back the new block
					return tmp_block ;
				}
		}
		// case 1
	  return NULL ;}
  802ac8:	b8 00 00 00 00       	mov    $0x0,%eax
  802acd:	c9                   	leave  
  802ace:	c3                   	ret    

00802acf <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================

struct MemBlock *alloc_block_BF(uint32 size)
{
  802acf:	55                   	push   %ebp
  802ad0:	89 e5                	mov    %esp,%ebp
  802ad2:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
  802ad5:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802adc:	a1 38 51 80 00       	mov    0x805138,%eax
  802ae1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ae4:	eb 3a                	jmp    802b20 <alloc_block_BF+0x51>
		{
			if(element->size >= size)
  802ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae9:	8b 40 0c             	mov    0xc(%eax),%eax
  802aec:	3b 45 08             	cmp    0x8(%ebp),%eax
  802aef:	72 27                	jb     802b18 <alloc_block_BF+0x49>
			{
				if(best_size==-1)
  802af1:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802af5:	75 0b                	jne    802b02 <alloc_block_BF+0x33>
					best_size= element->size;
  802af7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afa:	8b 40 0c             	mov    0xc(%eax),%eax
  802afd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802b00:	eb 16                	jmp    802b18 <alloc_block_BF+0x49>
				else if(best_size >= element->size)
  802b02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b05:	8b 50 0c             	mov    0xc(%eax),%edx
  802b08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b0b:	39 c2                	cmp    %eax,%edx
  802b0d:	77 09                	ja     802b18 <alloc_block_BF+0x49>
					best_size=element->size;
  802b0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b12:	8b 40 0c             	mov    0xc(%eax),%eax
  802b15:	89 45 f0             	mov    %eax,-0x10(%ebp)

struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802b18:	a1 40 51 80 00       	mov    0x805140,%eax
  802b1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b20:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b24:	74 07                	je     802b2d <alloc_block_BF+0x5e>
  802b26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b29:	8b 00                	mov    (%eax),%eax
  802b2b:	eb 05                	jmp    802b32 <alloc_block_BF+0x63>
  802b2d:	b8 00 00 00 00       	mov    $0x0,%eax
  802b32:	a3 40 51 80 00       	mov    %eax,0x805140
  802b37:	a1 40 51 80 00       	mov    0x805140,%eax
  802b3c:	85 c0                	test   %eax,%eax
  802b3e:	75 a6                	jne    802ae6 <alloc_block_BF+0x17>
  802b40:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b44:	75 a0                	jne    802ae6 <alloc_block_BF+0x17>
					best_size= element->size;
				else if(best_size >= element->size)
					best_size=element->size;
			}
		}
		if(best_size != -1)
  802b46:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802b4a:	0f 84 d3 01 00 00    	je     802d23 <alloc_block_BF+0x254>
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  802b50:	a1 38 51 80 00       	mov    0x805138,%eax
  802b55:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b58:	e9 98 01 00 00       	jmp    802cf5 <alloc_block_BF+0x226>
			{
			 if((best_size > size) && (best_size == element->size))
  802b5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b60:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b63:	0f 86 da 00 00 00    	jbe    802c43 <alloc_block_BF+0x174>
  802b69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6c:	8b 50 0c             	mov    0xc(%eax),%edx
  802b6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b72:	39 c2                	cmp    %eax,%edx
  802b74:	0f 85 c9 00 00 00    	jne    802c43 <alloc_block_BF+0x174>
			  {
				// the new block are created
			    tmp_block = AvailableMemBlocksList.lh_first ;
  802b7a:	a1 48 51 80 00       	mov    0x805148,%eax
  802b7f:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  802b82:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b86:	75 17                	jne    802b9f <alloc_block_BF+0xd0>
  802b88:	83 ec 04             	sub    $0x4,%esp
  802b8b:	68 db 40 80 00       	push   $0x8040db
  802b90:	68 ea 00 00 00       	push   $0xea
  802b95:	68 33 40 80 00       	push   $0x804033
  802b9a:	e8 fc db ff ff       	call   80079b <_panic>
  802b9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ba2:	8b 00                	mov    (%eax),%eax
  802ba4:	85 c0                	test   %eax,%eax
  802ba6:	74 10                	je     802bb8 <alloc_block_BF+0xe9>
  802ba8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bab:	8b 00                	mov    (%eax),%eax
  802bad:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bb0:	8b 52 04             	mov    0x4(%edx),%edx
  802bb3:	89 50 04             	mov    %edx,0x4(%eax)
  802bb6:	eb 0b                	jmp    802bc3 <alloc_block_BF+0xf4>
  802bb8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bbb:	8b 40 04             	mov    0x4(%eax),%eax
  802bbe:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802bc3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bc6:	8b 40 04             	mov    0x4(%eax),%eax
  802bc9:	85 c0                	test   %eax,%eax
  802bcb:	74 0f                	je     802bdc <alloc_block_BF+0x10d>
  802bcd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bd0:	8b 40 04             	mov    0x4(%eax),%eax
  802bd3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bd6:	8b 12                	mov    (%edx),%edx
  802bd8:	89 10                	mov    %edx,(%eax)
  802bda:	eb 0a                	jmp    802be6 <alloc_block_BF+0x117>
  802bdc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bdf:	8b 00                	mov    (%eax),%eax
  802be1:	a3 48 51 80 00       	mov    %eax,0x805148
  802be6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802be9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bf2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bf9:	a1 54 51 80 00       	mov    0x805154,%eax
  802bfe:	48                   	dec    %eax
  802bff:	a3 54 51 80 00       	mov    %eax,0x805154
				tmp_block->sva=element->sva;
  802c04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c07:	8b 50 08             	mov    0x8(%eax),%edx
  802c0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c0d:	89 50 08             	mov    %edx,0x8(%eax)
				tmp_block->size=size;
  802c10:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c13:	8b 55 08             	mov    0x8(%ebp),%edx
  802c16:	89 50 0c             	mov    %edx,0xc(%eax)
				//update block with remaining space
				element->size-=size;
  802c19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1c:	8b 40 0c             	mov    0xc(%eax),%eax
  802c1f:	2b 45 08             	sub    0x8(%ebp),%eax
  802c22:	89 c2                	mov    %eax,%edx
  802c24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c27:	89 50 0c             	mov    %edx,0xc(%eax)
				element->sva = element->sva + size;
  802c2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2d:	8b 50 08             	mov    0x8(%eax),%edx
  802c30:	8b 45 08             	mov    0x8(%ebp),%eax
  802c33:	01 c2                	add    %eax,%edx
  802c35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c38:	89 50 08             	mov    %edx,0x8(%eax)
				// return back the new block
				return tmp_block ;
  802c3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c3e:	e9 e5 00 00 00       	jmp    802d28 <alloc_block_BF+0x259>

			  }
			else if((element->size == best_size)&&(best_size == size))
  802c43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c46:	8b 50 0c             	mov    0xc(%eax),%edx
  802c49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c4c:	39 c2                	cmp    %eax,%edx
  802c4e:	0f 85 99 00 00 00    	jne    802ced <alloc_block_BF+0x21e>
  802c54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c57:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c5a:	0f 85 8d 00 00 00    	jne    802ced <alloc_block_BF+0x21e>
			  {
				tmp_block=element;
  802c60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c63:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&FreeMemBlocksList,element);
  802c66:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c6a:	75 17                	jne    802c83 <alloc_block_BF+0x1b4>
  802c6c:	83 ec 04             	sub    $0x4,%esp
  802c6f:	68 db 40 80 00       	push   $0x8040db
  802c74:	68 f7 00 00 00       	push   $0xf7
  802c79:	68 33 40 80 00       	push   $0x804033
  802c7e:	e8 18 db ff ff       	call   80079b <_panic>
  802c83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c86:	8b 00                	mov    (%eax),%eax
  802c88:	85 c0                	test   %eax,%eax
  802c8a:	74 10                	je     802c9c <alloc_block_BF+0x1cd>
  802c8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8f:	8b 00                	mov    (%eax),%eax
  802c91:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c94:	8b 52 04             	mov    0x4(%edx),%edx
  802c97:	89 50 04             	mov    %edx,0x4(%eax)
  802c9a:	eb 0b                	jmp    802ca7 <alloc_block_BF+0x1d8>
  802c9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9f:	8b 40 04             	mov    0x4(%eax),%eax
  802ca2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ca7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802caa:	8b 40 04             	mov    0x4(%eax),%eax
  802cad:	85 c0                	test   %eax,%eax
  802caf:	74 0f                	je     802cc0 <alloc_block_BF+0x1f1>
  802cb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb4:	8b 40 04             	mov    0x4(%eax),%eax
  802cb7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cba:	8b 12                	mov    (%edx),%edx
  802cbc:	89 10                	mov    %edx,(%eax)
  802cbe:	eb 0a                	jmp    802cca <alloc_block_BF+0x1fb>
  802cc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc3:	8b 00                	mov    (%eax),%eax
  802cc5:	a3 38 51 80 00       	mov    %eax,0x805138
  802cca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cdd:	a1 44 51 80 00       	mov    0x805144,%eax
  802ce2:	48                   	dec    %eax
  802ce3:	a3 44 51 80 00       	mov    %eax,0x805144
				return tmp_block;
  802ce8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ceb:	eb 3b                	jmp    802d28 <alloc_block_BF+0x259>
					best_size=element->size;
			}
		}
		if(best_size != -1)
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  802ced:	a1 40 51 80 00       	mov    0x805140,%eax
  802cf2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cf5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cf9:	74 07                	je     802d02 <alloc_block_BF+0x233>
  802cfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfe:	8b 00                	mov    (%eax),%eax
  802d00:	eb 05                	jmp    802d07 <alloc_block_BF+0x238>
  802d02:	b8 00 00 00 00       	mov    $0x0,%eax
  802d07:	a3 40 51 80 00       	mov    %eax,0x805140
  802d0c:	a1 40 51 80 00       	mov    0x805140,%eax
  802d11:	85 c0                	test   %eax,%eax
  802d13:	0f 85 44 fe ff ff    	jne    802b5d <alloc_block_BF+0x8e>
  802d19:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d1d:	0f 85 3a fe ff ff    	jne    802b5d <alloc_block_BF+0x8e>
				LIST_REMOVE(&FreeMemBlocksList,element);
				return tmp_block;
			 }
			}
		}
		return NULL ;}
  802d23:	b8 00 00 00 00       	mov    $0x0,%eax
  802d28:	c9                   	leave  
  802d29:	c3                   	ret    

00802d2a <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802d2a:	55                   	push   %ebp
  802d2b:	89 e5                	mov    %esp,%ebp
  802d2d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802d30:	83 ec 04             	sub    $0x4,%esp
  802d33:	68 fc 40 80 00       	push   $0x8040fc
  802d38:	68 04 01 00 00       	push   $0x104
  802d3d:	68 33 40 80 00       	push   $0x804033
  802d42:	e8 54 da ff ff       	call   80079b <_panic>

00802d47 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{struct MemBlock * blk_itr;
  802d47:	55                   	push   %ebp
  802d48:	89 e5                	mov    %esp,%ebp
  802d4a:	83 ec 18             	sub    $0x18,%esp
struct MemBlock * next;
struct MemBlock * first = LIST_FIRST(&(FreeMemBlocksList));
  802d4d:	a1 38 51 80 00       	mov    0x805138,%eax
  802d52:	89 45 f0             	mov    %eax,-0x10(%ebp)
struct MemBlock * last = LIST_LAST(&(FreeMemBlocksList));
  802d55:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802d5a:	89 45 ec             	mov    %eax,-0x14(%ebp)

if(LIST_EMPTY(&(FreeMemBlocksList)))
  802d5d:	a1 38 51 80 00       	mov    0x805138,%eax
  802d62:	85 c0                	test   %eax,%eax
  802d64:	75 68                	jne    802dce <insert_sorted_with_merge_freeList+0x87>
			{

				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  802d66:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d6a:	75 17                	jne    802d83 <insert_sorted_with_merge_freeList+0x3c>
  802d6c:	83 ec 04             	sub    $0x4,%esp
  802d6f:	68 10 40 80 00       	push   $0x804010
  802d74:	68 14 01 00 00       	push   $0x114
  802d79:	68 33 40 80 00       	push   $0x804033
  802d7e:	e8 18 da ff ff       	call   80079b <_panic>
  802d83:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802d89:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8c:	89 10                	mov    %edx,(%eax)
  802d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d91:	8b 00                	mov    (%eax),%eax
  802d93:	85 c0                	test   %eax,%eax
  802d95:	74 0d                	je     802da4 <insert_sorted_with_merge_freeList+0x5d>
  802d97:	a1 38 51 80 00       	mov    0x805138,%eax
  802d9c:	8b 55 08             	mov    0x8(%ebp),%edx
  802d9f:	89 50 04             	mov    %edx,0x4(%eax)
  802da2:	eb 08                	jmp    802dac <insert_sorted_with_merge_freeList+0x65>
  802da4:	8b 45 08             	mov    0x8(%ebp),%eax
  802da7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802dac:	8b 45 08             	mov    0x8(%ebp),%eax
  802daf:	a3 38 51 80 00       	mov    %eax,0x805138
  802db4:	8b 45 08             	mov    0x8(%ebp),%eax
  802db7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dbe:	a1 44 51 80 00       	mov    0x805144,%eax
  802dc3:	40                   	inc    %eax
  802dc4:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  802dc9:	e9 d2 06 00 00       	jmp    8034a0 <insert_sorted_with_merge_freeList+0x759>
				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);

			}
else
{
	if( blockToInsert->sva  < first->sva )
  802dce:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd1:	8b 50 08             	mov    0x8(%eax),%edx
  802dd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd7:	8b 40 08             	mov    0x8(%eax),%eax
  802dda:	39 c2                	cmp    %eax,%edx
  802ddc:	0f 83 22 01 00 00    	jae    802f04 <insert_sorted_with_merge_freeList+0x1bd>
	{
                if( blockToInsert->sva + blockToInsert->size == first->sva)
  802de2:	8b 45 08             	mov    0x8(%ebp),%eax
  802de5:	8b 50 08             	mov    0x8(%eax),%edx
  802de8:	8b 45 08             	mov    0x8(%ebp),%eax
  802deb:	8b 40 0c             	mov    0xc(%eax),%eax
  802dee:	01 c2                	add    %eax,%edx
  802df0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df3:	8b 40 08             	mov    0x8(%eax),%eax
  802df6:	39 c2                	cmp    %eax,%edx
  802df8:	0f 85 9e 00 00 00    	jne    802e9c <insert_sorted_with_merge_freeList+0x155>
                {

                	first->sva = blockToInsert->sva;
  802dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  802e01:	8b 50 08             	mov    0x8(%eax),%edx
  802e04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e07:	89 50 08             	mov    %edx,0x8(%eax)
                	first->size = first->size + blockToInsert->size;
  802e0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e0d:	8b 50 0c             	mov    0xc(%eax),%edx
  802e10:	8b 45 08             	mov    0x8(%ebp),%eax
  802e13:	8b 40 0c             	mov    0xc(%eax),%eax
  802e16:	01 c2                	add    %eax,%edx
  802e18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e1b:	89 50 0c             	mov    %edx,0xc(%eax)
                	blockToInsert->size = blockToInsert->sva = 0;
  802e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e21:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802e28:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2b:	8b 50 08             	mov    0x8(%eax),%edx
  802e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e31:	89 50 0c             	mov    %edx,0xc(%eax)
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802e34:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e38:	75 17                	jne    802e51 <insert_sorted_with_merge_freeList+0x10a>
  802e3a:	83 ec 04             	sub    $0x4,%esp
  802e3d:	68 10 40 80 00       	push   $0x804010
  802e42:	68 21 01 00 00       	push   $0x121
  802e47:	68 33 40 80 00       	push   $0x804033
  802e4c:	e8 4a d9 ff ff       	call   80079b <_panic>
  802e51:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e57:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5a:	89 10                	mov    %edx,(%eax)
  802e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5f:	8b 00                	mov    (%eax),%eax
  802e61:	85 c0                	test   %eax,%eax
  802e63:	74 0d                	je     802e72 <insert_sorted_with_merge_freeList+0x12b>
  802e65:	a1 48 51 80 00       	mov    0x805148,%eax
  802e6a:	8b 55 08             	mov    0x8(%ebp),%edx
  802e6d:	89 50 04             	mov    %edx,0x4(%eax)
  802e70:	eb 08                	jmp    802e7a <insert_sorted_with_merge_freeList+0x133>
  802e72:	8b 45 08             	mov    0x8(%ebp),%eax
  802e75:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7d:	a3 48 51 80 00       	mov    %eax,0x805148
  802e82:	8b 45 08             	mov    0x8(%ebp),%eax
  802e85:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e8c:	a1 54 51 80 00       	mov    0x805154,%eax
  802e91:	40                   	inc    %eax
  802e92:	a3 54 51 80 00       	mov    %eax,0x805154
						}
				}
        }

}
}
  802e97:	e9 04 06 00 00       	jmp    8034a0 <insert_sorted_with_merge_freeList+0x759>
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
                }

                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  802e9c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ea0:	75 17                	jne    802eb9 <insert_sorted_with_merge_freeList+0x172>
  802ea2:	83 ec 04             	sub    $0x4,%esp
  802ea5:	68 10 40 80 00       	push   $0x804010
  802eaa:	68 26 01 00 00       	push   $0x126
  802eaf:	68 33 40 80 00       	push   $0x804033
  802eb4:	e8 e2 d8 ff ff       	call   80079b <_panic>
  802eb9:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec2:	89 10                	mov    %edx,(%eax)
  802ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec7:	8b 00                	mov    (%eax),%eax
  802ec9:	85 c0                	test   %eax,%eax
  802ecb:	74 0d                	je     802eda <insert_sorted_with_merge_freeList+0x193>
  802ecd:	a1 38 51 80 00       	mov    0x805138,%eax
  802ed2:	8b 55 08             	mov    0x8(%ebp),%edx
  802ed5:	89 50 04             	mov    %edx,0x4(%eax)
  802ed8:	eb 08                	jmp    802ee2 <insert_sorted_with_merge_freeList+0x19b>
  802eda:	8b 45 08             	mov    0x8(%ebp),%eax
  802edd:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee5:	a3 38 51 80 00       	mov    %eax,0x805138
  802eea:	8b 45 08             	mov    0x8(%ebp),%eax
  802eed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ef4:	a1 44 51 80 00       	mov    0x805144,%eax
  802ef9:	40                   	inc    %eax
  802efa:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  802eff:	e9 9c 05 00 00       	jmp    8034a0 <insert_sorted_with_merge_freeList+0x759>
                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
                }
	}
    else if(blockToInsert->sva > last->sva)
  802f04:	8b 45 08             	mov    0x8(%ebp),%eax
  802f07:	8b 50 08             	mov    0x8(%eax),%edx
  802f0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f0d:	8b 40 08             	mov    0x8(%eax),%eax
  802f10:	39 c2                	cmp    %eax,%edx
  802f12:	0f 86 16 01 00 00    	jbe    80302e <insert_sorted_with_merge_freeList+0x2e7>
 	{

				if(last->sva + last->size == blockToInsert->sva)
  802f18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f1b:	8b 50 08             	mov    0x8(%eax),%edx
  802f1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f21:	8b 40 0c             	mov    0xc(%eax),%eax
  802f24:	01 c2                	add    %eax,%edx
  802f26:	8b 45 08             	mov    0x8(%ebp),%eax
  802f29:	8b 40 08             	mov    0x8(%eax),%eax
  802f2c:	39 c2                	cmp    %eax,%edx
  802f2e:	0f 85 92 00 00 00    	jne    802fc6 <insert_sorted_with_merge_freeList+0x27f>
				{

					last->size = last->size + blockToInsert->size;
  802f34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f37:	8b 50 0c             	mov    0xc(%eax),%edx
  802f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3d:	8b 40 0c             	mov    0xc(%eax),%eax
  802f40:	01 c2                	add    %eax,%edx
  802f42:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f45:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->size = blockToInsert->sva = 0;
  802f48:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802f52:	8b 45 08             	mov    0x8(%ebp),%eax
  802f55:	8b 50 08             	mov    0x8(%eax),%edx
  802f58:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5b:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802f5e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f62:	75 17                	jne    802f7b <insert_sorted_with_merge_freeList+0x234>
  802f64:	83 ec 04             	sub    $0x4,%esp
  802f67:	68 10 40 80 00       	push   $0x804010
  802f6c:	68 31 01 00 00       	push   $0x131
  802f71:	68 33 40 80 00       	push   $0x804033
  802f76:	e8 20 d8 ff ff       	call   80079b <_panic>
  802f7b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f81:	8b 45 08             	mov    0x8(%ebp),%eax
  802f84:	89 10                	mov    %edx,(%eax)
  802f86:	8b 45 08             	mov    0x8(%ebp),%eax
  802f89:	8b 00                	mov    (%eax),%eax
  802f8b:	85 c0                	test   %eax,%eax
  802f8d:	74 0d                	je     802f9c <insert_sorted_with_merge_freeList+0x255>
  802f8f:	a1 48 51 80 00       	mov    0x805148,%eax
  802f94:	8b 55 08             	mov    0x8(%ebp),%edx
  802f97:	89 50 04             	mov    %edx,0x4(%eax)
  802f9a:	eb 08                	jmp    802fa4 <insert_sorted_with_merge_freeList+0x25d>
  802f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa7:	a3 48 51 80 00       	mov    %eax,0x805148
  802fac:	8b 45 08             	mov    0x8(%ebp),%eax
  802faf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fb6:	a1 54 51 80 00       	mov    0x805154,%eax
  802fbb:	40                   	inc    %eax
  802fbc:	a3 54 51 80 00       	mov    %eax,0x805154
						}
				}
        }

}
}
  802fc1:	e9 da 04 00 00       	jmp    8034a0 <insert_sorted_with_merge_freeList+0x759>

				}

				else
				{
					LIST_INSERT_TAIL(&(FreeMemBlocksList),  blockToInsert);
  802fc6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fca:	75 17                	jne    802fe3 <insert_sorted_with_merge_freeList+0x29c>
  802fcc:	83 ec 04             	sub    $0x4,%esp
  802fcf:	68 b8 40 80 00       	push   $0x8040b8
  802fd4:	68 37 01 00 00       	push   $0x137
  802fd9:	68 33 40 80 00       	push   $0x804033
  802fde:	e8 b8 d7 ff ff       	call   80079b <_panic>
  802fe3:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fec:	89 50 04             	mov    %edx,0x4(%eax)
  802fef:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff2:	8b 40 04             	mov    0x4(%eax),%eax
  802ff5:	85 c0                	test   %eax,%eax
  802ff7:	74 0c                	je     803005 <insert_sorted_with_merge_freeList+0x2be>
  802ff9:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802ffe:	8b 55 08             	mov    0x8(%ebp),%edx
  803001:	89 10                	mov    %edx,(%eax)
  803003:	eb 08                	jmp    80300d <insert_sorted_with_merge_freeList+0x2c6>
  803005:	8b 45 08             	mov    0x8(%ebp),%eax
  803008:	a3 38 51 80 00       	mov    %eax,0x805138
  80300d:	8b 45 08             	mov    0x8(%ebp),%eax
  803010:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803015:	8b 45 08             	mov    0x8(%ebp),%eax
  803018:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80301e:	a1 44 51 80 00       	mov    0x805144,%eax
  803023:	40                   	inc    %eax
  803024:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  803029:	e9 72 04 00 00       	jmp    8034a0 <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  80302e:	a1 38 51 80 00       	mov    0x805138,%eax
  803033:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803036:	e9 35 04 00 00       	jmp    803470 <insert_sorted_with_merge_freeList+0x729>
				{
				     next=LIST_NEXT(blk_itr);
  80303b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303e:	8b 00                	mov    (%eax),%eax
  803040:	89 45 e8             	mov    %eax,-0x18(%ebp)


					if( (blockToInsert->sva > blk_itr->sva) )
  803043:	8b 45 08             	mov    0x8(%ebp),%eax
  803046:	8b 50 08             	mov    0x8(%eax),%edx
  803049:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304c:	8b 40 08             	mov    0x8(%eax),%eax
  80304f:	39 c2                	cmp    %eax,%edx
  803051:	0f 86 11 04 00 00    	jbe    803468 <insert_sorted_with_merge_freeList+0x721>
						{
							if(((blk_itr->sva) + (blk_itr->size) < blockToInsert->sva && (blockToInsert->sva) + (blockToInsert->size) < next->sva))
  803057:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305a:	8b 50 08             	mov    0x8(%eax),%edx
  80305d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803060:	8b 40 0c             	mov    0xc(%eax),%eax
  803063:	01 c2                	add    %eax,%edx
  803065:	8b 45 08             	mov    0x8(%ebp),%eax
  803068:	8b 40 08             	mov    0x8(%eax),%eax
  80306b:	39 c2                	cmp    %eax,%edx
  80306d:	0f 83 8b 00 00 00    	jae    8030fe <insert_sorted_with_merge_freeList+0x3b7>
  803073:	8b 45 08             	mov    0x8(%ebp),%eax
  803076:	8b 50 08             	mov    0x8(%eax),%edx
  803079:	8b 45 08             	mov    0x8(%ebp),%eax
  80307c:	8b 40 0c             	mov    0xc(%eax),%eax
  80307f:	01 c2                	add    %eax,%edx
  803081:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803084:	8b 40 08             	mov    0x8(%eax),%eax
  803087:	39 c2                	cmp    %eax,%edx
  803089:	73 73                	jae    8030fe <insert_sorted_with_merge_freeList+0x3b7>
							{
								LIST_INSERT_AFTER(&(FreeMemBlocksList), blk_itr, blockToInsert);
  80308b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80308f:	74 06                	je     803097 <insert_sorted_with_merge_freeList+0x350>
  803091:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803095:	75 17                	jne    8030ae <insert_sorted_with_merge_freeList+0x367>
  803097:	83 ec 04             	sub    $0x4,%esp
  80309a:	68 84 40 80 00       	push   $0x804084
  80309f:	68 48 01 00 00       	push   $0x148
  8030a4:	68 33 40 80 00       	push   $0x804033
  8030a9:	e8 ed d6 ff ff       	call   80079b <_panic>
  8030ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b1:	8b 10                	mov    (%eax),%edx
  8030b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b6:	89 10                	mov    %edx,(%eax)
  8030b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030bb:	8b 00                	mov    (%eax),%eax
  8030bd:	85 c0                	test   %eax,%eax
  8030bf:	74 0b                	je     8030cc <insert_sorted_with_merge_freeList+0x385>
  8030c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c4:	8b 00                	mov    (%eax),%eax
  8030c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8030c9:	89 50 04             	mov    %edx,0x4(%eax)
  8030cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8030d2:	89 10                	mov    %edx,(%eax)
  8030d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030da:	89 50 04             	mov    %edx,0x4(%eax)
  8030dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e0:	8b 00                	mov    (%eax),%eax
  8030e2:	85 c0                	test   %eax,%eax
  8030e4:	75 08                	jne    8030ee <insert_sorted_with_merge_freeList+0x3a7>
  8030e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030ee:	a1 44 51 80 00       	mov    0x805144,%eax
  8030f3:	40                   	inc    %eax
  8030f4:	a3 44 51 80 00       	mov    %eax,0x805144
								break;
  8030f9:	e9 a2 03 00 00       	jmp    8034a0 <insert_sorted_with_merge_freeList+0x759>

							}
							else if((blockToInsert->sva + blockToInsert->size) < next->sva  && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  8030fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803101:	8b 50 08             	mov    0x8(%eax),%edx
  803104:	8b 45 08             	mov    0x8(%ebp),%eax
  803107:	8b 40 0c             	mov    0xc(%eax),%eax
  80310a:	01 c2                	add    %eax,%edx
  80310c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80310f:	8b 40 08             	mov    0x8(%eax),%eax
  803112:	39 c2                	cmp    %eax,%edx
  803114:	0f 83 ae 00 00 00    	jae    8031c8 <insert_sorted_with_merge_freeList+0x481>
  80311a:	8b 45 08             	mov    0x8(%ebp),%eax
  80311d:	8b 50 08             	mov    0x8(%eax),%edx
  803120:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803123:	8b 48 08             	mov    0x8(%eax),%ecx
  803126:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803129:	8b 40 0c             	mov    0xc(%eax),%eax
  80312c:	01 c8                	add    %ecx,%eax
  80312e:	39 c2                	cmp    %eax,%edx
  803130:	0f 85 92 00 00 00    	jne    8031c8 <insert_sorted_with_merge_freeList+0x481>
							{

								blk_itr->size=blk_itr->size+blockToInsert->size;
  803136:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803139:	8b 50 0c             	mov    0xc(%eax),%edx
  80313c:	8b 45 08             	mov    0x8(%ebp),%eax
  80313f:	8b 40 0c             	mov    0xc(%eax),%eax
  803142:	01 c2                	add    %eax,%edx
  803144:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803147:	89 50 0c             	mov    %edx,0xc(%eax)
								 blockToInsert->size=blockToInsert->sva=0;
  80314a:	8b 45 08             	mov    0x8(%ebp),%eax
  80314d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803154:	8b 45 08             	mov    0x8(%ebp),%eax
  803157:	8b 50 08             	mov    0x8(%eax),%edx
  80315a:	8b 45 08             	mov    0x8(%ebp),%eax
  80315d:	89 50 0c             	mov    %edx,0xc(%eax)
								 LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  803160:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803164:	75 17                	jne    80317d <insert_sorted_with_merge_freeList+0x436>
  803166:	83 ec 04             	sub    $0x4,%esp
  803169:	68 10 40 80 00       	push   $0x804010
  80316e:	68 51 01 00 00       	push   $0x151
  803173:	68 33 40 80 00       	push   $0x804033
  803178:	e8 1e d6 ff ff       	call   80079b <_panic>
  80317d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803183:	8b 45 08             	mov    0x8(%ebp),%eax
  803186:	89 10                	mov    %edx,(%eax)
  803188:	8b 45 08             	mov    0x8(%ebp),%eax
  80318b:	8b 00                	mov    (%eax),%eax
  80318d:	85 c0                	test   %eax,%eax
  80318f:	74 0d                	je     80319e <insert_sorted_with_merge_freeList+0x457>
  803191:	a1 48 51 80 00       	mov    0x805148,%eax
  803196:	8b 55 08             	mov    0x8(%ebp),%edx
  803199:	89 50 04             	mov    %edx,0x4(%eax)
  80319c:	eb 08                	jmp    8031a6 <insert_sorted_with_merge_freeList+0x45f>
  80319e:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a9:	a3 48 51 80 00       	mov    %eax,0x805148
  8031ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031b8:	a1 54 51 80 00       	mov    0x805154,%eax
  8031bd:	40                   	inc    %eax
  8031be:	a3 54 51 80 00       	mov    %eax,0x805154
								 break;
  8031c3:	e9 d8 02 00 00       	jmp    8034a0 <insert_sorted_with_merge_freeList+0x759>

							}
							else if( (blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva > (blk_itr->sva + blk_itr->size))
  8031c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031cb:	8b 50 08             	mov    0x8(%eax),%edx
  8031ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8031d4:	01 c2                	add    %eax,%edx
  8031d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d9:	8b 40 08             	mov    0x8(%eax),%eax
  8031dc:	39 c2                	cmp    %eax,%edx
  8031de:	0f 85 ba 00 00 00    	jne    80329e <insert_sorted_with_merge_freeList+0x557>
  8031e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e7:	8b 50 08             	mov    0x8(%eax),%edx
  8031ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ed:	8b 48 08             	mov    0x8(%eax),%ecx
  8031f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f3:	8b 40 0c             	mov    0xc(%eax),%eax
  8031f6:	01 c8                	add    %ecx,%eax
  8031f8:	39 c2                	cmp    %eax,%edx
  8031fa:	0f 86 9e 00 00 00    	jbe    80329e <insert_sorted_with_merge_freeList+0x557>
							{
								next->size = next->size + blockToInsert->size;
  803200:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803203:	8b 50 0c             	mov    0xc(%eax),%edx
  803206:	8b 45 08             	mov    0x8(%ebp),%eax
  803209:	8b 40 0c             	mov    0xc(%eax),%eax
  80320c:	01 c2                	add    %eax,%edx
  80320e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803211:	89 50 0c             	mov    %edx,0xc(%eax)
								next->sva = blockToInsert->sva;
  803214:	8b 45 08             	mov    0x8(%ebp),%eax
  803217:	8b 50 08             	mov    0x8(%eax),%edx
  80321a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80321d:	89 50 08             	mov    %edx,0x8(%eax)

								blockToInsert->size = blockToInsert->sva = 0;
  803220:	8b 45 08             	mov    0x8(%ebp),%eax
  803223:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80322a:	8b 45 08             	mov    0x8(%ebp),%eax
  80322d:	8b 50 08             	mov    0x8(%eax),%edx
  803230:	8b 45 08             	mov    0x8(%ebp),%eax
  803233:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  803236:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80323a:	75 17                	jne    803253 <insert_sorted_with_merge_freeList+0x50c>
  80323c:	83 ec 04             	sub    $0x4,%esp
  80323f:	68 10 40 80 00       	push   $0x804010
  803244:	68 5b 01 00 00       	push   $0x15b
  803249:	68 33 40 80 00       	push   $0x804033
  80324e:	e8 48 d5 ff ff       	call   80079b <_panic>
  803253:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803259:	8b 45 08             	mov    0x8(%ebp),%eax
  80325c:	89 10                	mov    %edx,(%eax)
  80325e:	8b 45 08             	mov    0x8(%ebp),%eax
  803261:	8b 00                	mov    (%eax),%eax
  803263:	85 c0                	test   %eax,%eax
  803265:	74 0d                	je     803274 <insert_sorted_with_merge_freeList+0x52d>
  803267:	a1 48 51 80 00       	mov    0x805148,%eax
  80326c:	8b 55 08             	mov    0x8(%ebp),%edx
  80326f:	89 50 04             	mov    %edx,0x4(%eax)
  803272:	eb 08                	jmp    80327c <insert_sorted_with_merge_freeList+0x535>
  803274:	8b 45 08             	mov    0x8(%ebp),%eax
  803277:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80327c:	8b 45 08             	mov    0x8(%ebp),%eax
  80327f:	a3 48 51 80 00       	mov    %eax,0x805148
  803284:	8b 45 08             	mov    0x8(%ebp),%eax
  803287:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80328e:	a1 54 51 80 00       	mov    0x805154,%eax
  803293:	40                   	inc    %eax
  803294:	a3 54 51 80 00       	mov    %eax,0x805154
								break;
  803299:	e9 02 02 00 00       	jmp    8034a0 <insert_sorted_with_merge_freeList+0x759>
							}
							else if ((blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  80329e:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a1:	8b 50 08             	mov    0x8(%eax),%edx
  8032a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8032aa:	01 c2                	add    %eax,%edx
  8032ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032af:	8b 40 08             	mov    0x8(%eax),%eax
  8032b2:	39 c2                	cmp    %eax,%edx
  8032b4:	0f 85 ae 01 00 00    	jne    803468 <insert_sorted_with_merge_freeList+0x721>
  8032ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8032bd:	8b 50 08             	mov    0x8(%eax),%edx
  8032c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c3:	8b 48 08             	mov    0x8(%eax),%ecx
  8032c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8032cc:	01 c8                	add    %ecx,%eax
  8032ce:	39 c2                	cmp    %eax,%edx
  8032d0:	0f 85 92 01 00 00    	jne    803468 <insert_sorted_with_merge_freeList+0x721>
							{
								blk_itr->size = blk_itr->size + blockToInsert->size + next->size;
  8032d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d9:	8b 50 0c             	mov    0xc(%eax),%edx
  8032dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8032df:	8b 40 0c             	mov    0xc(%eax),%eax
  8032e2:	01 c2                	add    %eax,%edx
  8032e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032e7:	8b 40 0c             	mov    0xc(%eax),%eax
  8032ea:	01 c2                	add    %eax,%edx
  8032ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ef:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size = blockToInsert->sva=0;
  8032f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8032fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ff:	8b 50 08             	mov    0x8(%eax),%edx
  803302:	8b 45 08             	mov    0x8(%ebp),%eax
  803305:	89 50 0c             	mov    %edx,0xc(%eax)
								next->size = next->sva = 0;
  803308:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80330b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803312:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803315:	8b 50 08             	mov    0x8(%eax),%edx
  803318:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80331b:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_REMOVE(&FreeMemBlocksList, next);
  80331e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803322:	75 17                	jne    80333b <insert_sorted_with_merge_freeList+0x5f4>
  803324:	83 ec 04             	sub    $0x4,%esp
  803327:	68 db 40 80 00       	push   $0x8040db
  80332c:	68 63 01 00 00       	push   $0x163
  803331:	68 33 40 80 00       	push   $0x804033
  803336:	e8 60 d4 ff ff       	call   80079b <_panic>
  80333b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80333e:	8b 00                	mov    (%eax),%eax
  803340:	85 c0                	test   %eax,%eax
  803342:	74 10                	je     803354 <insert_sorted_with_merge_freeList+0x60d>
  803344:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803347:	8b 00                	mov    (%eax),%eax
  803349:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80334c:	8b 52 04             	mov    0x4(%edx),%edx
  80334f:	89 50 04             	mov    %edx,0x4(%eax)
  803352:	eb 0b                	jmp    80335f <insert_sorted_with_merge_freeList+0x618>
  803354:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803357:	8b 40 04             	mov    0x4(%eax),%eax
  80335a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80335f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803362:	8b 40 04             	mov    0x4(%eax),%eax
  803365:	85 c0                	test   %eax,%eax
  803367:	74 0f                	je     803378 <insert_sorted_with_merge_freeList+0x631>
  803369:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80336c:	8b 40 04             	mov    0x4(%eax),%eax
  80336f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803372:	8b 12                	mov    (%edx),%edx
  803374:	89 10                	mov    %edx,(%eax)
  803376:	eb 0a                	jmp    803382 <insert_sorted_with_merge_freeList+0x63b>
  803378:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80337b:	8b 00                	mov    (%eax),%eax
  80337d:	a3 38 51 80 00       	mov    %eax,0x805138
  803382:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803385:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80338b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80338e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803395:	a1 44 51 80 00       	mov    0x805144,%eax
  80339a:	48                   	dec    %eax
  80339b:	a3 44 51 80 00       	mov    %eax,0x805144
								LIST_INSERT_HEAD(&AvailableMemBlocksList, next );
  8033a0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8033a4:	75 17                	jne    8033bd <insert_sorted_with_merge_freeList+0x676>
  8033a6:	83 ec 04             	sub    $0x4,%esp
  8033a9:	68 10 40 80 00       	push   $0x804010
  8033ae:	68 64 01 00 00       	push   $0x164
  8033b3:	68 33 40 80 00       	push   $0x804033
  8033b8:	e8 de d3 ff ff       	call   80079b <_panic>
  8033bd:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033c6:	89 10                	mov    %edx,(%eax)
  8033c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033cb:	8b 00                	mov    (%eax),%eax
  8033cd:	85 c0                	test   %eax,%eax
  8033cf:	74 0d                	je     8033de <insert_sorted_with_merge_freeList+0x697>
  8033d1:	a1 48 51 80 00       	mov    0x805148,%eax
  8033d6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033d9:	89 50 04             	mov    %edx,0x4(%eax)
  8033dc:	eb 08                	jmp    8033e6 <insert_sorted_with_merge_freeList+0x69f>
  8033de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033e1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033e9:	a3 48 51 80 00       	mov    %eax,0x805148
  8033ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033f1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033f8:	a1 54 51 80 00       	mov    0x805154,%eax
  8033fd:	40                   	inc    %eax
  8033fe:	a3 54 51 80 00       	mov    %eax,0x805154
							    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  803403:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803407:	75 17                	jne    803420 <insert_sorted_with_merge_freeList+0x6d9>
  803409:	83 ec 04             	sub    $0x4,%esp
  80340c:	68 10 40 80 00       	push   $0x804010
  803411:	68 65 01 00 00       	push   $0x165
  803416:	68 33 40 80 00       	push   $0x804033
  80341b:	e8 7b d3 ff ff       	call   80079b <_panic>
  803420:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803426:	8b 45 08             	mov    0x8(%ebp),%eax
  803429:	89 10                	mov    %edx,(%eax)
  80342b:	8b 45 08             	mov    0x8(%ebp),%eax
  80342e:	8b 00                	mov    (%eax),%eax
  803430:	85 c0                	test   %eax,%eax
  803432:	74 0d                	je     803441 <insert_sorted_with_merge_freeList+0x6fa>
  803434:	a1 48 51 80 00       	mov    0x805148,%eax
  803439:	8b 55 08             	mov    0x8(%ebp),%edx
  80343c:	89 50 04             	mov    %edx,0x4(%eax)
  80343f:	eb 08                	jmp    803449 <insert_sorted_with_merge_freeList+0x702>
  803441:	8b 45 08             	mov    0x8(%ebp),%eax
  803444:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803449:	8b 45 08             	mov    0x8(%ebp),%eax
  80344c:	a3 48 51 80 00       	mov    %eax,0x805148
  803451:	8b 45 08             	mov    0x8(%ebp),%eax
  803454:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80345b:	a1 54 51 80 00       	mov    0x805154,%eax
  803460:	40                   	inc    %eax
  803461:	a3 54 51 80 00       	mov    %eax,0x805154
								break;
  803466:	eb 38                	jmp    8034a0 <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  803468:	a1 40 51 80 00       	mov    0x805140,%eax
  80346d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803470:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803474:	74 07                	je     80347d <insert_sorted_with_merge_freeList+0x736>
  803476:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803479:	8b 00                	mov    (%eax),%eax
  80347b:	eb 05                	jmp    803482 <insert_sorted_with_merge_freeList+0x73b>
  80347d:	b8 00 00 00 00       	mov    $0x0,%eax
  803482:	a3 40 51 80 00       	mov    %eax,0x805140
  803487:	a1 40 51 80 00       	mov    0x805140,%eax
  80348c:	85 c0                	test   %eax,%eax
  80348e:	0f 85 a7 fb ff ff    	jne    80303b <insert_sorted_with_merge_freeList+0x2f4>
  803494:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803498:	0f 85 9d fb ff ff    	jne    80303b <insert_sorted_with_merge_freeList+0x2f4>
						}
				}
        }

}
}
  80349e:	eb 00                	jmp    8034a0 <insert_sorted_with_merge_freeList+0x759>
  8034a0:	90                   	nop
  8034a1:	c9                   	leave  
  8034a2:	c3                   	ret    
  8034a3:	90                   	nop

008034a4 <__udivdi3>:
  8034a4:	55                   	push   %ebp
  8034a5:	57                   	push   %edi
  8034a6:	56                   	push   %esi
  8034a7:	53                   	push   %ebx
  8034a8:	83 ec 1c             	sub    $0x1c,%esp
  8034ab:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8034af:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8034b3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8034b7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8034bb:	89 ca                	mov    %ecx,%edx
  8034bd:	89 f8                	mov    %edi,%eax
  8034bf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8034c3:	85 f6                	test   %esi,%esi
  8034c5:	75 2d                	jne    8034f4 <__udivdi3+0x50>
  8034c7:	39 cf                	cmp    %ecx,%edi
  8034c9:	77 65                	ja     803530 <__udivdi3+0x8c>
  8034cb:	89 fd                	mov    %edi,%ebp
  8034cd:	85 ff                	test   %edi,%edi
  8034cf:	75 0b                	jne    8034dc <__udivdi3+0x38>
  8034d1:	b8 01 00 00 00       	mov    $0x1,%eax
  8034d6:	31 d2                	xor    %edx,%edx
  8034d8:	f7 f7                	div    %edi
  8034da:	89 c5                	mov    %eax,%ebp
  8034dc:	31 d2                	xor    %edx,%edx
  8034de:	89 c8                	mov    %ecx,%eax
  8034e0:	f7 f5                	div    %ebp
  8034e2:	89 c1                	mov    %eax,%ecx
  8034e4:	89 d8                	mov    %ebx,%eax
  8034e6:	f7 f5                	div    %ebp
  8034e8:	89 cf                	mov    %ecx,%edi
  8034ea:	89 fa                	mov    %edi,%edx
  8034ec:	83 c4 1c             	add    $0x1c,%esp
  8034ef:	5b                   	pop    %ebx
  8034f0:	5e                   	pop    %esi
  8034f1:	5f                   	pop    %edi
  8034f2:	5d                   	pop    %ebp
  8034f3:	c3                   	ret    
  8034f4:	39 ce                	cmp    %ecx,%esi
  8034f6:	77 28                	ja     803520 <__udivdi3+0x7c>
  8034f8:	0f bd fe             	bsr    %esi,%edi
  8034fb:	83 f7 1f             	xor    $0x1f,%edi
  8034fe:	75 40                	jne    803540 <__udivdi3+0x9c>
  803500:	39 ce                	cmp    %ecx,%esi
  803502:	72 0a                	jb     80350e <__udivdi3+0x6a>
  803504:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803508:	0f 87 9e 00 00 00    	ja     8035ac <__udivdi3+0x108>
  80350e:	b8 01 00 00 00       	mov    $0x1,%eax
  803513:	89 fa                	mov    %edi,%edx
  803515:	83 c4 1c             	add    $0x1c,%esp
  803518:	5b                   	pop    %ebx
  803519:	5e                   	pop    %esi
  80351a:	5f                   	pop    %edi
  80351b:	5d                   	pop    %ebp
  80351c:	c3                   	ret    
  80351d:	8d 76 00             	lea    0x0(%esi),%esi
  803520:	31 ff                	xor    %edi,%edi
  803522:	31 c0                	xor    %eax,%eax
  803524:	89 fa                	mov    %edi,%edx
  803526:	83 c4 1c             	add    $0x1c,%esp
  803529:	5b                   	pop    %ebx
  80352a:	5e                   	pop    %esi
  80352b:	5f                   	pop    %edi
  80352c:	5d                   	pop    %ebp
  80352d:	c3                   	ret    
  80352e:	66 90                	xchg   %ax,%ax
  803530:	89 d8                	mov    %ebx,%eax
  803532:	f7 f7                	div    %edi
  803534:	31 ff                	xor    %edi,%edi
  803536:	89 fa                	mov    %edi,%edx
  803538:	83 c4 1c             	add    $0x1c,%esp
  80353b:	5b                   	pop    %ebx
  80353c:	5e                   	pop    %esi
  80353d:	5f                   	pop    %edi
  80353e:	5d                   	pop    %ebp
  80353f:	c3                   	ret    
  803540:	bd 20 00 00 00       	mov    $0x20,%ebp
  803545:	89 eb                	mov    %ebp,%ebx
  803547:	29 fb                	sub    %edi,%ebx
  803549:	89 f9                	mov    %edi,%ecx
  80354b:	d3 e6                	shl    %cl,%esi
  80354d:	89 c5                	mov    %eax,%ebp
  80354f:	88 d9                	mov    %bl,%cl
  803551:	d3 ed                	shr    %cl,%ebp
  803553:	89 e9                	mov    %ebp,%ecx
  803555:	09 f1                	or     %esi,%ecx
  803557:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80355b:	89 f9                	mov    %edi,%ecx
  80355d:	d3 e0                	shl    %cl,%eax
  80355f:	89 c5                	mov    %eax,%ebp
  803561:	89 d6                	mov    %edx,%esi
  803563:	88 d9                	mov    %bl,%cl
  803565:	d3 ee                	shr    %cl,%esi
  803567:	89 f9                	mov    %edi,%ecx
  803569:	d3 e2                	shl    %cl,%edx
  80356b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80356f:	88 d9                	mov    %bl,%cl
  803571:	d3 e8                	shr    %cl,%eax
  803573:	09 c2                	or     %eax,%edx
  803575:	89 d0                	mov    %edx,%eax
  803577:	89 f2                	mov    %esi,%edx
  803579:	f7 74 24 0c          	divl   0xc(%esp)
  80357d:	89 d6                	mov    %edx,%esi
  80357f:	89 c3                	mov    %eax,%ebx
  803581:	f7 e5                	mul    %ebp
  803583:	39 d6                	cmp    %edx,%esi
  803585:	72 19                	jb     8035a0 <__udivdi3+0xfc>
  803587:	74 0b                	je     803594 <__udivdi3+0xf0>
  803589:	89 d8                	mov    %ebx,%eax
  80358b:	31 ff                	xor    %edi,%edi
  80358d:	e9 58 ff ff ff       	jmp    8034ea <__udivdi3+0x46>
  803592:	66 90                	xchg   %ax,%ax
  803594:	8b 54 24 08          	mov    0x8(%esp),%edx
  803598:	89 f9                	mov    %edi,%ecx
  80359a:	d3 e2                	shl    %cl,%edx
  80359c:	39 c2                	cmp    %eax,%edx
  80359e:	73 e9                	jae    803589 <__udivdi3+0xe5>
  8035a0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8035a3:	31 ff                	xor    %edi,%edi
  8035a5:	e9 40 ff ff ff       	jmp    8034ea <__udivdi3+0x46>
  8035aa:	66 90                	xchg   %ax,%ax
  8035ac:	31 c0                	xor    %eax,%eax
  8035ae:	e9 37 ff ff ff       	jmp    8034ea <__udivdi3+0x46>
  8035b3:	90                   	nop

008035b4 <__umoddi3>:
  8035b4:	55                   	push   %ebp
  8035b5:	57                   	push   %edi
  8035b6:	56                   	push   %esi
  8035b7:	53                   	push   %ebx
  8035b8:	83 ec 1c             	sub    $0x1c,%esp
  8035bb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8035bf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8035c3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8035c7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8035cb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8035cf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8035d3:	89 f3                	mov    %esi,%ebx
  8035d5:	89 fa                	mov    %edi,%edx
  8035d7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8035db:	89 34 24             	mov    %esi,(%esp)
  8035de:	85 c0                	test   %eax,%eax
  8035e0:	75 1a                	jne    8035fc <__umoddi3+0x48>
  8035e2:	39 f7                	cmp    %esi,%edi
  8035e4:	0f 86 a2 00 00 00    	jbe    80368c <__umoddi3+0xd8>
  8035ea:	89 c8                	mov    %ecx,%eax
  8035ec:	89 f2                	mov    %esi,%edx
  8035ee:	f7 f7                	div    %edi
  8035f0:	89 d0                	mov    %edx,%eax
  8035f2:	31 d2                	xor    %edx,%edx
  8035f4:	83 c4 1c             	add    $0x1c,%esp
  8035f7:	5b                   	pop    %ebx
  8035f8:	5e                   	pop    %esi
  8035f9:	5f                   	pop    %edi
  8035fa:	5d                   	pop    %ebp
  8035fb:	c3                   	ret    
  8035fc:	39 f0                	cmp    %esi,%eax
  8035fe:	0f 87 ac 00 00 00    	ja     8036b0 <__umoddi3+0xfc>
  803604:	0f bd e8             	bsr    %eax,%ebp
  803607:	83 f5 1f             	xor    $0x1f,%ebp
  80360a:	0f 84 ac 00 00 00    	je     8036bc <__umoddi3+0x108>
  803610:	bf 20 00 00 00       	mov    $0x20,%edi
  803615:	29 ef                	sub    %ebp,%edi
  803617:	89 fe                	mov    %edi,%esi
  803619:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80361d:	89 e9                	mov    %ebp,%ecx
  80361f:	d3 e0                	shl    %cl,%eax
  803621:	89 d7                	mov    %edx,%edi
  803623:	89 f1                	mov    %esi,%ecx
  803625:	d3 ef                	shr    %cl,%edi
  803627:	09 c7                	or     %eax,%edi
  803629:	89 e9                	mov    %ebp,%ecx
  80362b:	d3 e2                	shl    %cl,%edx
  80362d:	89 14 24             	mov    %edx,(%esp)
  803630:	89 d8                	mov    %ebx,%eax
  803632:	d3 e0                	shl    %cl,%eax
  803634:	89 c2                	mov    %eax,%edx
  803636:	8b 44 24 08          	mov    0x8(%esp),%eax
  80363a:	d3 e0                	shl    %cl,%eax
  80363c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803640:	8b 44 24 08          	mov    0x8(%esp),%eax
  803644:	89 f1                	mov    %esi,%ecx
  803646:	d3 e8                	shr    %cl,%eax
  803648:	09 d0                	or     %edx,%eax
  80364a:	d3 eb                	shr    %cl,%ebx
  80364c:	89 da                	mov    %ebx,%edx
  80364e:	f7 f7                	div    %edi
  803650:	89 d3                	mov    %edx,%ebx
  803652:	f7 24 24             	mull   (%esp)
  803655:	89 c6                	mov    %eax,%esi
  803657:	89 d1                	mov    %edx,%ecx
  803659:	39 d3                	cmp    %edx,%ebx
  80365b:	0f 82 87 00 00 00    	jb     8036e8 <__umoddi3+0x134>
  803661:	0f 84 91 00 00 00    	je     8036f8 <__umoddi3+0x144>
  803667:	8b 54 24 04          	mov    0x4(%esp),%edx
  80366b:	29 f2                	sub    %esi,%edx
  80366d:	19 cb                	sbb    %ecx,%ebx
  80366f:	89 d8                	mov    %ebx,%eax
  803671:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803675:	d3 e0                	shl    %cl,%eax
  803677:	89 e9                	mov    %ebp,%ecx
  803679:	d3 ea                	shr    %cl,%edx
  80367b:	09 d0                	or     %edx,%eax
  80367d:	89 e9                	mov    %ebp,%ecx
  80367f:	d3 eb                	shr    %cl,%ebx
  803681:	89 da                	mov    %ebx,%edx
  803683:	83 c4 1c             	add    $0x1c,%esp
  803686:	5b                   	pop    %ebx
  803687:	5e                   	pop    %esi
  803688:	5f                   	pop    %edi
  803689:	5d                   	pop    %ebp
  80368a:	c3                   	ret    
  80368b:	90                   	nop
  80368c:	89 fd                	mov    %edi,%ebp
  80368e:	85 ff                	test   %edi,%edi
  803690:	75 0b                	jne    80369d <__umoddi3+0xe9>
  803692:	b8 01 00 00 00       	mov    $0x1,%eax
  803697:	31 d2                	xor    %edx,%edx
  803699:	f7 f7                	div    %edi
  80369b:	89 c5                	mov    %eax,%ebp
  80369d:	89 f0                	mov    %esi,%eax
  80369f:	31 d2                	xor    %edx,%edx
  8036a1:	f7 f5                	div    %ebp
  8036a3:	89 c8                	mov    %ecx,%eax
  8036a5:	f7 f5                	div    %ebp
  8036a7:	89 d0                	mov    %edx,%eax
  8036a9:	e9 44 ff ff ff       	jmp    8035f2 <__umoddi3+0x3e>
  8036ae:	66 90                	xchg   %ax,%ax
  8036b0:	89 c8                	mov    %ecx,%eax
  8036b2:	89 f2                	mov    %esi,%edx
  8036b4:	83 c4 1c             	add    $0x1c,%esp
  8036b7:	5b                   	pop    %ebx
  8036b8:	5e                   	pop    %esi
  8036b9:	5f                   	pop    %edi
  8036ba:	5d                   	pop    %ebp
  8036bb:	c3                   	ret    
  8036bc:	3b 04 24             	cmp    (%esp),%eax
  8036bf:	72 06                	jb     8036c7 <__umoddi3+0x113>
  8036c1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8036c5:	77 0f                	ja     8036d6 <__umoddi3+0x122>
  8036c7:	89 f2                	mov    %esi,%edx
  8036c9:	29 f9                	sub    %edi,%ecx
  8036cb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8036cf:	89 14 24             	mov    %edx,(%esp)
  8036d2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8036d6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8036da:	8b 14 24             	mov    (%esp),%edx
  8036dd:	83 c4 1c             	add    $0x1c,%esp
  8036e0:	5b                   	pop    %ebx
  8036e1:	5e                   	pop    %esi
  8036e2:	5f                   	pop    %edi
  8036e3:	5d                   	pop    %ebp
  8036e4:	c3                   	ret    
  8036e5:	8d 76 00             	lea    0x0(%esi),%esi
  8036e8:	2b 04 24             	sub    (%esp),%eax
  8036eb:	19 fa                	sbb    %edi,%edx
  8036ed:	89 d1                	mov    %edx,%ecx
  8036ef:	89 c6                	mov    %eax,%esi
  8036f1:	e9 71 ff ff ff       	jmp    803667 <__umoddi3+0xb3>
  8036f6:	66 90                	xchg   %ax,%ax
  8036f8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8036fc:	72 ea                	jb     8036e8 <__umoddi3+0x134>
  8036fe:	89 d9                	mov    %ebx,%ecx
  803700:	e9 62 ff ff ff       	jmp    803667 <__umoddi3+0xb3>
