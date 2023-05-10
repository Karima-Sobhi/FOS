
obj/user/tst_best_fit_2:     file format elf32-i386


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
  800031:	e8 b5 08 00 00       	call   8008eb <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
	char a;
	short b;
	int c;
};
void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	83 ec 70             	sub    $0x70,%esp
	sys_set_uheap_strategy(UHP_PLACE_BESTFIT);
  800040:	83 ec 0c             	sub    $0xc,%esp
  800043:	6a 02                	push   $0x2
  800045:	e8 00 25 00 00       	call   80254a <sys_set_uheap_strategy>
  80004a:	83 c4 10             	add    $0x10,%esp

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80004d:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800051:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800058:	eb 29                	jmp    800083 <_main+0x4b>
		{
			if (myEnv->__uptr_pws[i].empty)
  80005a:	a1 20 50 80 00       	mov    0x805020,%eax
  80005f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800065:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800068:	89 d0                	mov    %edx,%eax
  80006a:	01 c0                	add    %eax,%eax
  80006c:	01 d0                	add    %edx,%eax
  80006e:	c1 e0 03             	shl    $0x3,%eax
  800071:	01 c8                	add    %ecx,%eax
  800073:	8a 40 04             	mov    0x4(%eax),%al
  800076:	84 c0                	test   %al,%al
  800078:	74 06                	je     800080 <_main+0x48>
			{
				fullWS = 0;
  80007a:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  80007e:	eb 12                	jmp    800092 <_main+0x5a>
	sys_set_uheap_strategy(UHP_PLACE_BESTFIT);

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800080:	ff 45 f0             	incl   -0x10(%ebp)
  800083:	a1 20 50 80 00       	mov    0x805020,%eax
  800088:	8b 50 74             	mov    0x74(%eax),%edx
  80008b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80008e:	39 c2                	cmp    %eax,%edx
  800090:	77 c8                	ja     80005a <_main+0x22>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800092:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800096:	74 14                	je     8000ac <_main+0x74>
  800098:	83 ec 04             	sub    $0x4,%esp
  80009b:	68 a0 39 80 00       	push   $0x8039a0
  8000a0:	6a 1b                	push   $0x1b
  8000a2:	68 bc 39 80 00       	push   $0x8039bc
  8000a7:	e8 7b 09 00 00       	call   800a27 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000ac:	83 ec 0c             	sub    $0xc,%esp
  8000af:	6a 00                	push   $0x0
  8000b1:	e8 51 1b 00 00       	call   801c07 <malloc>
  8000b6:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	int Mega = 1024*1024;
  8000b9:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000c0:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	void* ptr_allocations[20] = {0};
  8000c7:	8d 55 90             	lea    -0x70(%ebp),%edx
  8000ca:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d4:	89 d7                	mov    %edx,%edi
  8000d6:	f3 ab                	rep stos %eax,%es:(%edi)

	//[1] Attempt to allocate more than heap size
	{
		ptr_allocations[0] = malloc(USER_HEAP_MAX - USER_HEAP_START + 1);
  8000d8:	83 ec 0c             	sub    $0xc,%esp
  8000db:	68 01 00 00 20       	push   $0x20000001
  8000e0:	e8 22 1b 00 00       	call   801c07 <malloc>
  8000e5:	83 c4 10             	add    $0x10,%esp
  8000e8:	89 45 90             	mov    %eax,-0x70(%ebp)
		if (ptr_allocations[0] != NULL) panic("Malloc: Attempt to allocate more than heap size, should return NULL");
  8000eb:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000ee:	85 c0                	test   %eax,%eax
  8000f0:	74 14                	je     800106 <_main+0xce>
  8000f2:	83 ec 04             	sub    $0x4,%esp
  8000f5:	68 d4 39 80 00       	push   $0x8039d4
  8000fa:	6a 28                	push   $0x28
  8000fc:	68 bc 39 80 00       	push   $0x8039bc
  800101:	e8 21 09 00 00       	call   800a27 <_panic>
	}
	//[2] Attempt to allocate space more than any available fragment
	//	a) Create Fragments
	{
		//2 MB
		int freeFrames = sys_calculate_free_frames() ;
  800106:	e8 2a 1f 00 00       	call   802035 <sys_calculate_free_frames>
  80010b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages();
  80010e:	e8 c2 1f 00 00       	call   8020d5 <sys_pf_calculate_allocated_pages>
  800113:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  800116:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800119:	01 c0                	add    %eax,%eax
  80011b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80011e:	83 ec 0c             	sub    $0xc,%esp
  800121:	50                   	push   %eax
  800122:	e8 e0 1a 00 00       	call   801c07 <malloc>
  800127:	83 c4 10             	add    $0x10,%esp
  80012a:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[0] != (USER_HEAP_START) ) panic("Wrong start address for the allocated space... ");
  80012d:	8b 45 90             	mov    -0x70(%ebp),%eax
  800130:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800135:	74 14                	je     80014b <_main+0x113>
  800137:	83 ec 04             	sub    $0x4,%esp
  80013a:	68 18 3a 80 00       	push   $0x803a18
  80013f:	6a 31                	push   $0x31
  800141:	68 bc 39 80 00       	push   $0x8039bc
  800146:	e8 dc 08 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  80014b:	e8 85 1f 00 00       	call   8020d5 <sys_pf_calculate_allocated_pages>
  800150:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800153:	3d 00 02 00 00       	cmp    $0x200,%eax
  800158:	74 14                	je     80016e <_main+0x136>
  80015a:	83 ec 04             	sub    $0x4,%esp
  80015d:	68 48 3a 80 00       	push   $0x803a48
  800162:	6a 33                	push   $0x33
  800164:	68 bc 39 80 00       	push   $0x8039bc
  800169:	e8 b9 08 00 00       	call   800a27 <_panic>

		//2 MB
		freeFrames = sys_calculate_free_frames() ;
  80016e:	e8 c2 1e 00 00       	call   802035 <sys_calculate_free_frames>
  800173:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800176:	e8 5a 1f 00 00       	call   8020d5 <sys_pf_calculate_allocated_pages>
  80017b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  80017e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800181:	01 c0                	add    %eax,%eax
  800183:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800186:	83 ec 0c             	sub    $0xc,%esp
  800189:	50                   	push   %eax
  80018a:	e8 78 1a 00 00       	call   801c07 <malloc>
  80018f:	83 c4 10             	add    $0x10,%esp
  800192:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[1] != (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the allocated space... ");
  800195:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800198:	89 c2                	mov    %eax,%edx
  80019a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80019d:	01 c0                	add    %eax,%eax
  80019f:	05 00 00 00 80       	add    $0x80000000,%eax
  8001a4:	39 c2                	cmp    %eax,%edx
  8001a6:	74 14                	je     8001bc <_main+0x184>
  8001a8:	83 ec 04             	sub    $0x4,%esp
  8001ab:	68 18 3a 80 00       	push   $0x803a18
  8001b0:	6a 39                	push   $0x39
  8001b2:	68 bc 39 80 00       	push   $0x8039bc
  8001b7:	e8 6b 08 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  8001bc:	e8 14 1f 00 00       	call   8020d5 <sys_pf_calculate_allocated_pages>
  8001c1:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8001c4:	3d 00 02 00 00       	cmp    $0x200,%eax
  8001c9:	74 14                	je     8001df <_main+0x1a7>
  8001cb:	83 ec 04             	sub    $0x4,%esp
  8001ce:	68 48 3a 80 00       	push   $0x803a48
  8001d3:	6a 3b                	push   $0x3b
  8001d5:	68 bc 39 80 00       	push   $0x8039bc
  8001da:	e8 48 08 00 00       	call   800a27 <_panic>

		//2 KB
		freeFrames = sys_calculate_free_frames() ;
  8001df:	e8 51 1e 00 00       	call   802035 <sys_calculate_free_frames>
  8001e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8001e7:	e8 e9 1e 00 00       	call   8020d5 <sys_pf_calculate_allocated_pages>
  8001ec:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[2] = malloc(2*kilo);
  8001ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001f2:	01 c0                	add    %eax,%eax
  8001f4:	83 ec 0c             	sub    $0xc,%esp
  8001f7:	50                   	push   %eax
  8001f8:	e8 0a 1a 00 00       	call   801c07 <malloc>
  8001fd:	83 c4 10             	add    $0x10,%esp
  800200:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[2] != (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  800203:	8b 45 98             	mov    -0x68(%ebp),%eax
  800206:	89 c2                	mov    %eax,%edx
  800208:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80020b:	c1 e0 02             	shl    $0x2,%eax
  80020e:	05 00 00 00 80       	add    $0x80000000,%eax
  800213:	39 c2                	cmp    %eax,%edx
  800215:	74 14                	je     80022b <_main+0x1f3>
  800217:	83 ec 04             	sub    $0x4,%esp
  80021a:	68 18 3a 80 00       	push   $0x803a18
  80021f:	6a 41                	push   $0x41
  800221:	68 bc 39 80 00       	push   $0x8039bc
  800226:	e8 fc 07 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1) panic("Wrong page file allocation: ");
  80022b:	e8 a5 1e 00 00       	call   8020d5 <sys_pf_calculate_allocated_pages>
  800230:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800233:	83 f8 01             	cmp    $0x1,%eax
  800236:	74 14                	je     80024c <_main+0x214>
  800238:	83 ec 04             	sub    $0x4,%esp
  80023b:	68 48 3a 80 00       	push   $0x803a48
  800240:	6a 43                	push   $0x43
  800242:	68 bc 39 80 00       	push   $0x8039bc
  800247:	e8 db 07 00 00       	call   800a27 <_panic>

		//2 KB
		freeFrames = sys_calculate_free_frames() ;
  80024c:	e8 e4 1d 00 00       	call   802035 <sys_calculate_free_frames>
  800251:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800254:	e8 7c 1e 00 00       	call   8020d5 <sys_pf_calculate_allocated_pages>
  800259:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[3] = malloc(2*kilo);
  80025c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80025f:	01 c0                	add    %eax,%eax
  800261:	83 ec 0c             	sub    $0xc,%esp
  800264:	50                   	push   %eax
  800265:	e8 9d 19 00 00       	call   801c07 <malloc>
  80026a:	83 c4 10             	add    $0x10,%esp
  80026d:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[3] != (USER_HEAP_START + 4*Mega + 4*kilo)) panic("Wrong start address for the allocated space... ");
  800270:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800273:	89 c2                	mov    %eax,%edx
  800275:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800278:	c1 e0 02             	shl    $0x2,%eax
  80027b:	89 c1                	mov    %eax,%ecx
  80027d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800280:	c1 e0 02             	shl    $0x2,%eax
  800283:	01 c8                	add    %ecx,%eax
  800285:	05 00 00 00 80       	add    $0x80000000,%eax
  80028a:	39 c2                	cmp    %eax,%edx
  80028c:	74 14                	je     8002a2 <_main+0x26a>
  80028e:	83 ec 04             	sub    $0x4,%esp
  800291:	68 18 3a 80 00       	push   $0x803a18
  800296:	6a 49                	push   $0x49
  800298:	68 bc 39 80 00       	push   $0x8039bc
  80029d:	e8 85 07 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1) panic("Wrong page file allocation: ");
  8002a2:	e8 2e 1e 00 00       	call   8020d5 <sys_pf_calculate_allocated_pages>
  8002a7:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8002aa:	83 f8 01             	cmp    $0x1,%eax
  8002ad:	74 14                	je     8002c3 <_main+0x28b>
  8002af:	83 ec 04             	sub    $0x4,%esp
  8002b2:	68 48 3a 80 00       	push   $0x803a48
  8002b7:	6a 4b                	push   $0x4b
  8002b9:	68 bc 39 80 00       	push   $0x8039bc
  8002be:	e8 64 07 00 00       	call   800a27 <_panic>

		//4 KB Hole
		freeFrames = sys_calculate_free_frames() ;
  8002c3:	e8 6d 1d 00 00       	call   802035 <sys_calculate_free_frames>
  8002c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8002cb:	e8 05 1e 00 00       	call   8020d5 <sys_pf_calculate_allocated_pages>
  8002d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[2]);
  8002d3:	8b 45 98             	mov    -0x68(%ebp),%eax
  8002d6:	83 ec 0c             	sub    $0xc,%esp
  8002d9:	50                   	push   %eax
  8002da:	e8 a3 19 00 00       	call   801c82 <free>
  8002df:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 1) panic("Wrong free: ");
		if( (usedDiskPages-sys_pf_calculate_allocated_pages()) !=  1) panic("Wrong page file free: ");
  8002e2:	e8 ee 1d 00 00       	call   8020d5 <sys_pf_calculate_allocated_pages>
  8002e7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002ea:	29 c2                	sub    %eax,%edx
  8002ec:	89 d0                	mov    %edx,%eax
  8002ee:	83 f8 01             	cmp    $0x1,%eax
  8002f1:	74 14                	je     800307 <_main+0x2cf>
  8002f3:	83 ec 04             	sub    $0x4,%esp
  8002f6:	68 65 3a 80 00       	push   $0x803a65
  8002fb:	6a 52                	push   $0x52
  8002fd:	68 bc 39 80 00       	push   $0x8039bc
  800302:	e8 20 07 00 00       	call   800a27 <_panic>

		//7 KB
		freeFrames = sys_calculate_free_frames() ;
  800307:	e8 29 1d 00 00       	call   802035 <sys_calculate_free_frames>
  80030c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80030f:	e8 c1 1d 00 00       	call   8020d5 <sys_pf_calculate_allocated_pages>
  800314:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  800317:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80031a:	89 d0                	mov    %edx,%eax
  80031c:	01 c0                	add    %eax,%eax
  80031e:	01 d0                	add    %edx,%eax
  800320:	01 c0                	add    %eax,%eax
  800322:	01 d0                	add    %edx,%eax
  800324:	83 ec 0c             	sub    $0xc,%esp
  800327:	50                   	push   %eax
  800328:	e8 da 18 00 00       	call   801c07 <malloc>
  80032d:	83 c4 10             	add    $0x10,%esp
  800330:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[4] != (USER_HEAP_START + 4*Mega + 8*kilo)) panic("Wrong start address for the allocated space... ");
  800333:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800336:	89 c2                	mov    %eax,%edx
  800338:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80033b:	c1 e0 02             	shl    $0x2,%eax
  80033e:	89 c1                	mov    %eax,%ecx
  800340:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800343:	c1 e0 03             	shl    $0x3,%eax
  800346:	01 c8                	add    %ecx,%eax
  800348:	05 00 00 00 80       	add    $0x80000000,%eax
  80034d:	39 c2                	cmp    %eax,%edx
  80034f:	74 14                	je     800365 <_main+0x32d>
  800351:	83 ec 04             	sub    $0x4,%esp
  800354:	68 18 3a 80 00       	push   $0x803a18
  800359:	6a 58                	push   $0x58
  80035b:	68 bc 39 80 00       	push   $0x8039bc
  800360:	e8 c2 06 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2) panic("Wrong page file allocation: ");
  800365:	e8 6b 1d 00 00       	call   8020d5 <sys_pf_calculate_allocated_pages>
  80036a:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80036d:	83 f8 02             	cmp    $0x2,%eax
  800370:	74 14                	je     800386 <_main+0x34e>
  800372:	83 ec 04             	sub    $0x4,%esp
  800375:	68 48 3a 80 00       	push   $0x803a48
  80037a:	6a 5a                	push   $0x5a
  80037c:	68 bc 39 80 00       	push   $0x8039bc
  800381:	e8 a1 06 00 00       	call   800a27 <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800386:	e8 aa 1c 00 00       	call   802035 <sys_calculate_free_frames>
  80038b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80038e:	e8 42 1d 00 00       	call   8020d5 <sys_pf_calculate_allocated_pages>
  800393:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[0]);
  800396:	8b 45 90             	mov    -0x70(%ebp),%eax
  800399:	83 ec 0c             	sub    $0xc,%esp
  80039c:	50                   	push   %eax
  80039d:	e8 e0 18 00 00       	call   801c82 <free>
  8003a2:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages() ) !=  512) panic("Wrong page file free: ");
  8003a5:	e8 2b 1d 00 00       	call   8020d5 <sys_pf_calculate_allocated_pages>
  8003aa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003ad:	29 c2                	sub    %eax,%edx
  8003af:	89 d0                	mov    %edx,%eax
  8003b1:	3d 00 02 00 00       	cmp    $0x200,%eax
  8003b6:	74 14                	je     8003cc <_main+0x394>
  8003b8:	83 ec 04             	sub    $0x4,%esp
  8003bb:	68 65 3a 80 00       	push   $0x803a65
  8003c0:	6a 61                	push   $0x61
  8003c2:	68 bc 39 80 00       	push   $0x8039bc
  8003c7:	e8 5b 06 00 00       	call   800a27 <_panic>

		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8003cc:	e8 64 1c 00 00       	call   802035 <sys_calculate_free_frames>
  8003d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003d4:	e8 fc 1c 00 00       	call   8020d5 <sys_pf_calculate_allocated_pages>
  8003d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  8003dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003df:	89 c2                	mov    %eax,%edx
  8003e1:	01 d2                	add    %edx,%edx
  8003e3:	01 d0                	add    %edx,%eax
  8003e5:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8003e8:	83 ec 0c             	sub    $0xc,%esp
  8003eb:	50                   	push   %eax
  8003ec:	e8 16 18 00 00       	call   801c07 <malloc>
  8003f1:	83 c4 10             	add    $0x10,%esp
  8003f4:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[5] != (USER_HEAP_START + 4*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  8003f7:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003fa:	89 c2                	mov    %eax,%edx
  8003fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003ff:	c1 e0 02             	shl    $0x2,%eax
  800402:	89 c1                	mov    %eax,%ecx
  800404:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800407:	c1 e0 04             	shl    $0x4,%eax
  80040a:	01 c8                	add    %ecx,%eax
  80040c:	05 00 00 00 80       	add    $0x80000000,%eax
  800411:	39 c2                	cmp    %eax,%edx
  800413:	74 14                	je     800429 <_main+0x3f1>
  800415:	83 ec 04             	sub    $0x4,%esp
  800418:	68 18 3a 80 00       	push   $0x803a18
  80041d:	6a 67                	push   $0x67
  80041f:	68 bc 39 80 00       	push   $0x8039bc
  800424:	e8 fe 05 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  3*Mega/4096) panic("Wrong page file allocation: ");
  800429:	e8 a7 1c 00 00       	call   8020d5 <sys_pf_calculate_allocated_pages>
  80042e:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800431:	89 c2                	mov    %eax,%edx
  800433:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800436:	89 c1                	mov    %eax,%ecx
  800438:	01 c9                	add    %ecx,%ecx
  80043a:	01 c8                	add    %ecx,%eax
  80043c:	85 c0                	test   %eax,%eax
  80043e:	79 05                	jns    800445 <_main+0x40d>
  800440:	05 ff 0f 00 00       	add    $0xfff,%eax
  800445:	c1 f8 0c             	sar    $0xc,%eax
  800448:	39 c2                	cmp    %eax,%edx
  80044a:	74 14                	je     800460 <_main+0x428>
  80044c:	83 ec 04             	sub    $0x4,%esp
  80044f:	68 48 3a 80 00       	push   $0x803a48
  800454:	6a 69                	push   $0x69
  800456:	68 bc 39 80 00       	push   $0x8039bc
  80045b:	e8 c7 05 00 00       	call   800a27 <_panic>

		//2 MB + 6 KB
		freeFrames = sys_calculate_free_frames() ;
  800460:	e8 d0 1b 00 00       	call   802035 <sys_calculate_free_frames>
  800465:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800468:	e8 68 1c 00 00       	call   8020d5 <sys_pf_calculate_allocated_pages>
  80046d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[6] = malloc(2*Mega + 6*kilo);
  800470:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800473:	89 c2                	mov    %eax,%edx
  800475:	01 d2                	add    %edx,%edx
  800477:	01 c2                	add    %eax,%edx
  800479:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80047c:	01 d0                	add    %edx,%eax
  80047e:	01 c0                	add    %eax,%eax
  800480:	83 ec 0c             	sub    $0xc,%esp
  800483:	50                   	push   %eax
  800484:	e8 7e 17 00 00       	call   801c07 <malloc>
  800489:	83 c4 10             	add    $0x10,%esp
  80048c:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if ((uint32) ptr_allocations[6] != (USER_HEAP_START + 7*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  80048f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800492:	89 c1                	mov    %eax,%ecx
  800494:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800497:	89 d0                	mov    %edx,%eax
  800499:	01 c0                	add    %eax,%eax
  80049b:	01 d0                	add    %edx,%eax
  80049d:	01 c0                	add    %eax,%eax
  80049f:	01 d0                	add    %edx,%eax
  8004a1:	89 c2                	mov    %eax,%edx
  8004a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004a6:	c1 e0 04             	shl    $0x4,%eax
  8004a9:	01 d0                	add    %edx,%eax
  8004ab:	05 00 00 00 80       	add    $0x80000000,%eax
  8004b0:	39 c1                	cmp    %eax,%ecx
  8004b2:	74 14                	je     8004c8 <_main+0x490>
  8004b4:	83 ec 04             	sub    $0x4,%esp
  8004b7:	68 18 3a 80 00       	push   $0x803a18
  8004bc:	6a 6f                	push   $0x6f
  8004be:	68 bc 39 80 00       	push   $0x8039bc
  8004c3:	e8 5f 05 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 514+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  514) panic("Wrong page file allocation: ");
  8004c8:	e8 08 1c 00 00       	call   8020d5 <sys_pf_calculate_allocated_pages>
  8004cd:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8004d0:	3d 02 02 00 00       	cmp    $0x202,%eax
  8004d5:	74 14                	je     8004eb <_main+0x4b3>
  8004d7:	83 ec 04             	sub    $0x4,%esp
  8004da:	68 48 3a 80 00       	push   $0x803a48
  8004df:	6a 71                	push   $0x71
  8004e1:	68 bc 39 80 00       	push   $0x8039bc
  8004e6:	e8 3c 05 00 00       	call   800a27 <_panic>

		//5 MB
		freeFrames = sys_calculate_free_frames() ;
  8004eb:	e8 45 1b 00 00       	call   802035 <sys_calculate_free_frames>
  8004f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004f3:	e8 dd 1b 00 00       	call   8020d5 <sys_pf_calculate_allocated_pages>
  8004f8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[7] = malloc(5*Mega-kilo);
  8004fb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8004fe:	89 d0                	mov    %edx,%eax
  800500:	c1 e0 02             	shl    $0x2,%eax
  800503:	01 d0                	add    %edx,%eax
  800505:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800508:	83 ec 0c             	sub    $0xc,%esp
  80050b:	50                   	push   %eax
  80050c:	e8 f6 16 00 00       	call   801c07 <malloc>
  800511:	83 c4 10             	add    $0x10,%esp
  800514:	89 45 ac             	mov    %eax,-0x54(%ebp)
		if ((uint32) ptr_allocations[7] != (USER_HEAP_START + 9*Mega + 24*kilo)) panic("Wrong start address for the allocated space... ");
  800517:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80051a:	89 c1                	mov    %eax,%ecx
  80051c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80051f:	89 d0                	mov    %edx,%eax
  800521:	c1 e0 03             	shl    $0x3,%eax
  800524:	01 d0                	add    %edx,%eax
  800526:	89 c3                	mov    %eax,%ebx
  800528:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80052b:	89 d0                	mov    %edx,%eax
  80052d:	01 c0                	add    %eax,%eax
  80052f:	01 d0                	add    %edx,%eax
  800531:	c1 e0 03             	shl    $0x3,%eax
  800534:	01 d8                	add    %ebx,%eax
  800536:	05 00 00 00 80       	add    $0x80000000,%eax
  80053b:	39 c1                	cmp    %eax,%ecx
  80053d:	74 14                	je     800553 <_main+0x51b>
  80053f:	83 ec 04             	sub    $0x4,%esp
  800542:	68 18 3a 80 00       	push   $0x803a18
  800547:	6a 77                	push   $0x77
  800549:	68 bc 39 80 00       	push   $0x8039bc
  80054e:	e8 d4 04 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 5*Mega/4096 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  5*Mega/4096) panic("Wrong page file allocation: ");
  800553:	e8 7d 1b 00 00       	call   8020d5 <sys_pf_calculate_allocated_pages>
  800558:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80055b:	89 c1                	mov    %eax,%ecx
  80055d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800560:	89 d0                	mov    %edx,%eax
  800562:	c1 e0 02             	shl    $0x2,%eax
  800565:	01 d0                	add    %edx,%eax
  800567:	85 c0                	test   %eax,%eax
  800569:	79 05                	jns    800570 <_main+0x538>
  80056b:	05 ff 0f 00 00       	add    $0xfff,%eax
  800570:	c1 f8 0c             	sar    $0xc,%eax
  800573:	39 c1                	cmp    %eax,%ecx
  800575:	74 14                	je     80058b <_main+0x553>
  800577:	83 ec 04             	sub    $0x4,%esp
  80057a:	68 48 3a 80 00       	push   $0x803a48
  80057f:	6a 79                	push   $0x79
  800581:	68 bc 39 80 00       	push   $0x8039bc
  800586:	e8 9c 04 00 00       	call   800a27 <_panic>

		//2 MB + 8 KB Hole
		freeFrames = sys_calculate_free_frames() ;
  80058b:	e8 a5 1a 00 00       	call   802035 <sys_calculate_free_frames>
  800590:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800593:	e8 3d 1b 00 00       	call   8020d5 <sys_pf_calculate_allocated_pages>
  800598:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[6]);
  80059b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80059e:	83 ec 0c             	sub    $0xc,%esp
  8005a1:	50                   	push   %eax
  8005a2:	e8 db 16 00 00       	call   801c82 <free>
  8005a7:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 514) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  514) panic("Wrong page file free: ");
  8005aa:	e8 26 1b 00 00       	call   8020d5 <sys_pf_calculate_allocated_pages>
  8005af:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005b2:	29 c2                	sub    %eax,%edx
  8005b4:	89 d0                	mov    %edx,%eax
  8005b6:	3d 02 02 00 00       	cmp    $0x202,%eax
  8005bb:	74 17                	je     8005d4 <_main+0x59c>
  8005bd:	83 ec 04             	sub    $0x4,%esp
  8005c0:	68 65 3a 80 00       	push   $0x803a65
  8005c5:	68 80 00 00 00       	push   $0x80
  8005ca:	68 bc 39 80 00       	push   $0x8039bc
  8005cf:	e8 53 04 00 00       	call   800a27 <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8005d4:	e8 5c 1a 00 00       	call   802035 <sys_calculate_free_frames>
  8005d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005dc:	e8 f4 1a 00 00       	call   8020d5 <sys_pf_calculate_allocated_pages>
  8005e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[1]);
  8005e4:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8005e7:	83 ec 0c             	sub    $0xc,%esp
  8005ea:	50                   	push   %eax
  8005eb:	e8 92 16 00 00       	call   801c82 <free>
  8005f0:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages() ) !=  512) panic("Wrong page file free: ");
  8005f3:	e8 dd 1a 00 00       	call   8020d5 <sys_pf_calculate_allocated_pages>
  8005f8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005fb:	29 c2                	sub    %eax,%edx
  8005fd:	89 d0                	mov    %edx,%eax
  8005ff:	3d 00 02 00 00       	cmp    $0x200,%eax
  800604:	74 17                	je     80061d <_main+0x5e5>
  800606:	83 ec 04             	sub    $0x4,%esp
  800609:	68 65 3a 80 00       	push   $0x803a65
  80060e:	68 87 00 00 00       	push   $0x87
  800613:	68 bc 39 80 00       	push   $0x8039bc
  800618:	e8 0a 04 00 00       	call   800a27 <_panic>

		//2 MB [BEST FIT Case]
		freeFrames = sys_calculate_free_frames() ;
  80061d:	e8 13 1a 00 00       	call   802035 <sys_calculate_free_frames>
  800622:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800625:	e8 ab 1a 00 00       	call   8020d5 <sys_pf_calculate_allocated_pages>
  80062a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[8] = malloc(2*Mega-kilo);
  80062d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800630:	01 c0                	add    %eax,%eax
  800632:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800635:	83 ec 0c             	sub    $0xc,%esp
  800638:	50                   	push   %eax
  800639:	e8 c9 15 00 00       	call   801c07 <malloc>
  80063e:	83 c4 10             	add    $0x10,%esp
  800641:	89 45 b0             	mov    %eax,-0x50(%ebp)
		if ((uint32) ptr_allocations[8] !=  (USER_HEAP_START + 7*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  800644:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800647:	89 c1                	mov    %eax,%ecx
  800649:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80064c:	89 d0                	mov    %edx,%eax
  80064e:	01 c0                	add    %eax,%eax
  800650:	01 d0                	add    %edx,%eax
  800652:	01 c0                	add    %eax,%eax
  800654:	01 d0                	add    %edx,%eax
  800656:	89 c2                	mov    %eax,%edx
  800658:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80065b:	c1 e0 04             	shl    $0x4,%eax
  80065e:	01 d0                	add    %edx,%eax
  800660:	05 00 00 00 80       	add    $0x80000000,%eax
  800665:	39 c1                	cmp    %eax,%ecx
  800667:	74 17                	je     800680 <_main+0x648>
  800669:	83 ec 04             	sub    $0x4,%esp
  80066c:	68 18 3a 80 00       	push   $0x803a18
  800671:	68 8d 00 00 00       	push   $0x8d
  800676:	68 bc 39 80 00       	push   $0x8039bc
  80067b:	e8 a7 03 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  800680:	e8 50 1a 00 00       	call   8020d5 <sys_pf_calculate_allocated_pages>
  800685:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800688:	3d 00 02 00 00       	cmp    $0x200,%eax
  80068d:	74 17                	je     8006a6 <_main+0x66e>
  80068f:	83 ec 04             	sub    $0x4,%esp
  800692:	68 48 3a 80 00       	push   $0x803a48
  800697:	68 8f 00 00 00       	push   $0x8f
  80069c:	68 bc 39 80 00       	push   $0x8039bc
  8006a1:	e8 81 03 00 00       	call   800a27 <_panic>

		//6 KB [BEST FIT Case]
		freeFrames = sys_calculate_free_frames() ;
  8006a6:	e8 8a 19 00 00       	call   802035 <sys_calculate_free_frames>
  8006ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8006ae:	e8 22 1a 00 00       	call   8020d5 <sys_pf_calculate_allocated_pages>
  8006b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[9] = malloc(6*kilo);
  8006b6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8006b9:	89 d0                	mov    %edx,%eax
  8006bb:	01 c0                	add    %eax,%eax
  8006bd:	01 d0                	add    %edx,%eax
  8006bf:	01 c0                	add    %eax,%eax
  8006c1:	83 ec 0c             	sub    $0xc,%esp
  8006c4:	50                   	push   %eax
  8006c5:	e8 3d 15 00 00       	call   801c07 <malloc>
  8006ca:	83 c4 10             	add    $0x10,%esp
  8006cd:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		if ((uint32) ptr_allocations[9] != (USER_HEAP_START + 9*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  8006d0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8006d3:	89 c1                	mov    %eax,%ecx
  8006d5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8006d8:	89 d0                	mov    %edx,%eax
  8006da:	c1 e0 03             	shl    $0x3,%eax
  8006dd:	01 d0                	add    %edx,%eax
  8006df:	89 c2                	mov    %eax,%edx
  8006e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006e4:	c1 e0 04             	shl    $0x4,%eax
  8006e7:	01 d0                	add    %edx,%eax
  8006e9:	05 00 00 00 80       	add    $0x80000000,%eax
  8006ee:	39 c1                	cmp    %eax,%ecx
  8006f0:	74 17                	je     800709 <_main+0x6d1>
  8006f2:	83 ec 04             	sub    $0x4,%esp
  8006f5:	68 18 3a 80 00       	push   $0x803a18
  8006fa:	68 95 00 00 00       	push   $0x95
  8006ff:	68 bc 39 80 00       	push   $0x8039bc
  800704:	e8 1e 03 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2) panic("Wrong page file allocation: ");
  800709:	e8 c7 19 00 00       	call   8020d5 <sys_pf_calculate_allocated_pages>
  80070e:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800711:	83 f8 02             	cmp    $0x2,%eax
  800714:	74 17                	je     80072d <_main+0x6f5>
  800716:	83 ec 04             	sub    $0x4,%esp
  800719:	68 48 3a 80 00       	push   $0x803a48
  80071e:	68 97 00 00 00       	push   $0x97
  800723:	68 bc 39 80 00       	push   $0x8039bc
  800728:	e8 fa 02 00 00       	call   800a27 <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80072d:	e8 03 19 00 00       	call   802035 <sys_calculate_free_frames>
  800732:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800735:	e8 9b 19 00 00       	call   8020d5 <sys_pf_calculate_allocated_pages>
  80073a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[5]);
  80073d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800740:	83 ec 0c             	sub    $0xc,%esp
  800743:	50                   	push   %eax
  800744:	e8 39 15 00 00       	call   801c82 <free>
  800749:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  768) panic("Wrong page file free: ");
  80074c:	e8 84 19 00 00       	call   8020d5 <sys_pf_calculate_allocated_pages>
  800751:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800754:	29 c2                	sub    %eax,%edx
  800756:	89 d0                	mov    %edx,%eax
  800758:	3d 00 03 00 00       	cmp    $0x300,%eax
  80075d:	74 17                	je     800776 <_main+0x73e>
  80075f:	83 ec 04             	sub    $0x4,%esp
  800762:	68 65 3a 80 00       	push   $0x803a65
  800767:	68 9e 00 00 00       	push   $0x9e
  80076c:	68 bc 39 80 00       	push   $0x8039bc
  800771:	e8 b1 02 00 00       	call   800a27 <_panic>

		//3 MB [BEST FIT Case]
		freeFrames = sys_calculate_free_frames() ;
  800776:	e8 ba 18 00 00       	call   802035 <sys_calculate_free_frames>
  80077b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80077e:	e8 52 19 00 00       	call   8020d5 <sys_pf_calculate_allocated_pages>
  800783:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[10] = malloc(3*Mega-kilo);
  800786:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800789:	89 c2                	mov    %eax,%edx
  80078b:	01 d2                	add    %edx,%edx
  80078d:	01 d0                	add    %edx,%eax
  80078f:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800792:	83 ec 0c             	sub    $0xc,%esp
  800795:	50                   	push   %eax
  800796:	e8 6c 14 00 00       	call   801c07 <malloc>
  80079b:	83 c4 10             	add    $0x10,%esp
  80079e:	89 45 b8             	mov    %eax,-0x48(%ebp)
		if ((uint32) ptr_allocations[10] != (USER_HEAP_START + 4*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  8007a1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8007a4:	89 c2                	mov    %eax,%edx
  8007a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007a9:	c1 e0 02             	shl    $0x2,%eax
  8007ac:	89 c1                	mov    %eax,%ecx
  8007ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8007b1:	c1 e0 04             	shl    $0x4,%eax
  8007b4:	01 c8                	add    %ecx,%eax
  8007b6:	05 00 00 00 80       	add    $0x80000000,%eax
  8007bb:	39 c2                	cmp    %eax,%edx
  8007bd:	74 17                	je     8007d6 <_main+0x79e>
  8007bf:	83 ec 04             	sub    $0x4,%esp
  8007c2:	68 18 3a 80 00       	push   $0x803a18
  8007c7:	68 a4 00 00 00       	push   $0xa4
  8007cc:	68 bc 39 80 00       	push   $0x8039bc
  8007d1:	e8 51 02 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  3*Mega/4096) panic("Wrong page file allocation: ");
  8007d6:	e8 fa 18 00 00       	call   8020d5 <sys_pf_calculate_allocated_pages>
  8007db:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8007de:	89 c2                	mov    %eax,%edx
  8007e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007e3:	89 c1                	mov    %eax,%ecx
  8007e5:	01 c9                	add    %ecx,%ecx
  8007e7:	01 c8                	add    %ecx,%eax
  8007e9:	85 c0                	test   %eax,%eax
  8007eb:	79 05                	jns    8007f2 <_main+0x7ba>
  8007ed:	05 ff 0f 00 00       	add    $0xfff,%eax
  8007f2:	c1 f8 0c             	sar    $0xc,%eax
  8007f5:	39 c2                	cmp    %eax,%edx
  8007f7:	74 17                	je     800810 <_main+0x7d8>
  8007f9:	83 ec 04             	sub    $0x4,%esp
  8007fc:	68 48 3a 80 00       	push   $0x803a48
  800801:	68 a6 00 00 00       	push   $0xa6
  800806:	68 bc 39 80 00       	push   $0x8039bc
  80080b:	e8 17 02 00 00       	call   800a27 <_panic>

		//4 MB
		freeFrames = sys_calculate_free_frames() ;
  800810:	e8 20 18 00 00       	call   802035 <sys_calculate_free_frames>
  800815:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800818:	e8 b8 18 00 00       	call   8020d5 <sys_pf_calculate_allocated_pages>
  80081d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[11] = malloc(4*Mega-kilo);
  800820:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800823:	c1 e0 02             	shl    $0x2,%eax
  800826:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800829:	83 ec 0c             	sub    $0xc,%esp
  80082c:	50                   	push   %eax
  80082d:	e8 d5 13 00 00       	call   801c07 <malloc>
  800832:	83 c4 10             	add    $0x10,%esp
  800835:	89 45 bc             	mov    %eax,-0x44(%ebp)
		if ((uint32) ptr_allocations[11] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  800838:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80083b:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800840:	74 17                	je     800859 <_main+0x821>
  800842:	83 ec 04             	sub    $0x4,%esp
  800845:	68 18 3a 80 00       	push   $0x803a18
  80084a:	68 ac 00 00 00       	push   $0xac
  80084f:	68 bc 39 80 00       	push   $0x8039bc
  800854:	e8 ce 01 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 4*Mega/4096) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*Mega/4096) panic("Wrong page file allocation: ");
  800859:	e8 77 18 00 00       	call   8020d5 <sys_pf_calculate_allocated_pages>
  80085e:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800861:	89 c2                	mov    %eax,%edx
  800863:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800866:	c1 e0 02             	shl    $0x2,%eax
  800869:	85 c0                	test   %eax,%eax
  80086b:	79 05                	jns    800872 <_main+0x83a>
  80086d:	05 ff 0f 00 00       	add    $0xfff,%eax
  800872:	c1 f8 0c             	sar    $0xc,%eax
  800875:	39 c2                	cmp    %eax,%edx
  800877:	74 17                	je     800890 <_main+0x858>
  800879:	83 ec 04             	sub    $0x4,%esp
  80087c:	68 48 3a 80 00       	push   $0x803a48
  800881:	68 ae 00 00 00       	push   $0xae
  800886:	68 bc 39 80 00       	push   $0x8039bc
  80088b:	e8 97 01 00 00       	call   800a27 <_panic>
	//	b) Attempt to allocate large segment with no suitable fragment to fit on
	{
		//Large Allocation
		//int freeFrames = sys_calculate_free_frames() ;
		//usedDiskPages = sys_pf_calculate_allocated_pages();
		ptr_allocations[12] = malloc((USER_HEAP_MAX - USER_HEAP_START - 14*Mega));
  800890:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800893:	89 d0                	mov    %edx,%eax
  800895:	01 c0                	add    %eax,%eax
  800897:	01 d0                	add    %edx,%eax
  800899:	01 c0                	add    %eax,%eax
  80089b:	01 d0                	add    %edx,%eax
  80089d:	01 c0                	add    %eax,%eax
  80089f:	f7 d8                	neg    %eax
  8008a1:	05 00 00 00 20       	add    $0x20000000,%eax
  8008a6:	83 ec 0c             	sub    $0xc,%esp
  8008a9:	50                   	push   %eax
  8008aa:	e8 58 13 00 00       	call   801c07 <malloc>
  8008af:	83 c4 10             	add    $0x10,%esp
  8008b2:	89 45 c0             	mov    %eax,-0x40(%ebp)
		if (ptr_allocations[12] != NULL) panic("Malloc: Attempt to allocate large segment with no suitable fragment to fit on, should return NULL");
  8008b5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8008b8:	85 c0                	test   %eax,%eax
  8008ba:	74 17                	je     8008d3 <_main+0x89b>
  8008bc:	83 ec 04             	sub    $0x4,%esp
  8008bf:	68 7c 3a 80 00       	push   $0x803a7c
  8008c4:	68 b7 00 00 00       	push   $0xb7
  8008c9:	68 bc 39 80 00       	push   $0x8039bc
  8008ce:	e8 54 01 00 00       	call   800a27 <_panic>

		cprintf("Congratulations!! test BEST FIT allocation (2) completed successfully.\n");
  8008d3:	83 ec 0c             	sub    $0xc,%esp
  8008d6:	68 e0 3a 80 00       	push   $0x803ae0
  8008db:	e8 fb 03 00 00       	call   800cdb <cprintf>
  8008e0:	83 c4 10             	add    $0x10,%esp

		return;
  8008e3:	90                   	nop
	}
}
  8008e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008e7:	5b                   	pop    %ebx
  8008e8:	5f                   	pop    %edi
  8008e9:	5d                   	pop    %ebp
  8008ea:	c3                   	ret    

008008eb <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8008eb:	55                   	push   %ebp
  8008ec:	89 e5                	mov    %esp,%ebp
  8008ee:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8008f1:	e8 1f 1a 00 00       	call   802315 <sys_getenvindex>
  8008f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8008f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008fc:	89 d0                	mov    %edx,%eax
  8008fe:	c1 e0 03             	shl    $0x3,%eax
  800901:	01 d0                	add    %edx,%eax
  800903:	01 c0                	add    %eax,%eax
  800905:	01 d0                	add    %edx,%eax
  800907:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80090e:	01 d0                	add    %edx,%eax
  800910:	c1 e0 04             	shl    $0x4,%eax
  800913:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800918:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80091d:	a1 20 50 80 00       	mov    0x805020,%eax
  800922:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800928:	84 c0                	test   %al,%al
  80092a:	74 0f                	je     80093b <libmain+0x50>
		binaryname = myEnv->prog_name;
  80092c:	a1 20 50 80 00       	mov    0x805020,%eax
  800931:	05 5c 05 00 00       	add    $0x55c,%eax
  800936:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80093b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80093f:	7e 0a                	jle    80094b <libmain+0x60>
		binaryname = argv[0];
  800941:	8b 45 0c             	mov    0xc(%ebp),%eax
  800944:	8b 00                	mov    (%eax),%eax
  800946:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  80094b:	83 ec 08             	sub    $0x8,%esp
  80094e:	ff 75 0c             	pushl  0xc(%ebp)
  800951:	ff 75 08             	pushl  0x8(%ebp)
  800954:	e8 df f6 ff ff       	call   800038 <_main>
  800959:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80095c:	e8 c1 17 00 00       	call   802122 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800961:	83 ec 0c             	sub    $0xc,%esp
  800964:	68 40 3b 80 00       	push   $0x803b40
  800969:	e8 6d 03 00 00       	call   800cdb <cprintf>
  80096e:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800971:	a1 20 50 80 00       	mov    0x805020,%eax
  800976:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80097c:	a1 20 50 80 00       	mov    0x805020,%eax
  800981:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800987:	83 ec 04             	sub    $0x4,%esp
  80098a:	52                   	push   %edx
  80098b:	50                   	push   %eax
  80098c:	68 68 3b 80 00       	push   $0x803b68
  800991:	e8 45 03 00 00       	call   800cdb <cprintf>
  800996:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800999:	a1 20 50 80 00       	mov    0x805020,%eax
  80099e:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8009a4:	a1 20 50 80 00       	mov    0x805020,%eax
  8009a9:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8009af:	a1 20 50 80 00       	mov    0x805020,%eax
  8009b4:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8009ba:	51                   	push   %ecx
  8009bb:	52                   	push   %edx
  8009bc:	50                   	push   %eax
  8009bd:	68 90 3b 80 00       	push   $0x803b90
  8009c2:	e8 14 03 00 00       	call   800cdb <cprintf>
  8009c7:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8009ca:	a1 20 50 80 00       	mov    0x805020,%eax
  8009cf:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8009d5:	83 ec 08             	sub    $0x8,%esp
  8009d8:	50                   	push   %eax
  8009d9:	68 e8 3b 80 00       	push   $0x803be8
  8009de:	e8 f8 02 00 00       	call   800cdb <cprintf>
  8009e3:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8009e6:	83 ec 0c             	sub    $0xc,%esp
  8009e9:	68 40 3b 80 00       	push   $0x803b40
  8009ee:	e8 e8 02 00 00       	call   800cdb <cprintf>
  8009f3:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8009f6:	e8 41 17 00 00       	call   80213c <sys_enable_interrupt>

	// exit gracefully
	exit();
  8009fb:	e8 19 00 00 00       	call   800a19 <exit>
}
  800a00:	90                   	nop
  800a01:	c9                   	leave  
  800a02:	c3                   	ret    

00800a03 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800a03:	55                   	push   %ebp
  800a04:	89 e5                	mov    %esp,%ebp
  800a06:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800a09:	83 ec 0c             	sub    $0xc,%esp
  800a0c:	6a 00                	push   $0x0
  800a0e:	e8 ce 18 00 00       	call   8022e1 <sys_destroy_env>
  800a13:	83 c4 10             	add    $0x10,%esp
}
  800a16:	90                   	nop
  800a17:	c9                   	leave  
  800a18:	c3                   	ret    

00800a19 <exit>:

void
exit(void)
{
  800a19:	55                   	push   %ebp
  800a1a:	89 e5                	mov    %esp,%ebp
  800a1c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800a1f:	e8 23 19 00 00       	call   802347 <sys_exit_env>
}
  800a24:	90                   	nop
  800a25:	c9                   	leave  
  800a26:	c3                   	ret    

00800a27 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800a27:	55                   	push   %ebp
  800a28:	89 e5                	mov    %esp,%ebp
  800a2a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800a2d:	8d 45 10             	lea    0x10(%ebp),%eax
  800a30:	83 c0 04             	add    $0x4,%eax
  800a33:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800a36:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800a3b:	85 c0                	test   %eax,%eax
  800a3d:	74 16                	je     800a55 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800a3f:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800a44:	83 ec 08             	sub    $0x8,%esp
  800a47:	50                   	push   %eax
  800a48:	68 fc 3b 80 00       	push   $0x803bfc
  800a4d:	e8 89 02 00 00       	call   800cdb <cprintf>
  800a52:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800a55:	a1 00 50 80 00       	mov    0x805000,%eax
  800a5a:	ff 75 0c             	pushl  0xc(%ebp)
  800a5d:	ff 75 08             	pushl  0x8(%ebp)
  800a60:	50                   	push   %eax
  800a61:	68 01 3c 80 00       	push   $0x803c01
  800a66:	e8 70 02 00 00       	call   800cdb <cprintf>
  800a6b:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800a6e:	8b 45 10             	mov    0x10(%ebp),%eax
  800a71:	83 ec 08             	sub    $0x8,%esp
  800a74:	ff 75 f4             	pushl  -0xc(%ebp)
  800a77:	50                   	push   %eax
  800a78:	e8 f3 01 00 00       	call   800c70 <vcprintf>
  800a7d:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800a80:	83 ec 08             	sub    $0x8,%esp
  800a83:	6a 00                	push   $0x0
  800a85:	68 1d 3c 80 00       	push   $0x803c1d
  800a8a:	e8 e1 01 00 00       	call   800c70 <vcprintf>
  800a8f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800a92:	e8 82 ff ff ff       	call   800a19 <exit>

	// should not return here
	while (1) ;
  800a97:	eb fe                	jmp    800a97 <_panic+0x70>

00800a99 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800a99:	55                   	push   %ebp
  800a9a:	89 e5                	mov    %esp,%ebp
  800a9c:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800a9f:	a1 20 50 80 00       	mov    0x805020,%eax
  800aa4:	8b 50 74             	mov    0x74(%eax),%edx
  800aa7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aaa:	39 c2                	cmp    %eax,%edx
  800aac:	74 14                	je     800ac2 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800aae:	83 ec 04             	sub    $0x4,%esp
  800ab1:	68 20 3c 80 00       	push   $0x803c20
  800ab6:	6a 26                	push   $0x26
  800ab8:	68 6c 3c 80 00       	push   $0x803c6c
  800abd:	e8 65 ff ff ff       	call   800a27 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800ac2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800ac9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ad0:	e9 c2 00 00 00       	jmp    800b97 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800ad5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ad8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800adf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae2:	01 d0                	add    %edx,%eax
  800ae4:	8b 00                	mov    (%eax),%eax
  800ae6:	85 c0                	test   %eax,%eax
  800ae8:	75 08                	jne    800af2 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800aea:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800aed:	e9 a2 00 00 00       	jmp    800b94 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800af2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800af9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800b00:	eb 69                	jmp    800b6b <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800b02:	a1 20 50 80 00       	mov    0x805020,%eax
  800b07:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800b0d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800b10:	89 d0                	mov    %edx,%eax
  800b12:	01 c0                	add    %eax,%eax
  800b14:	01 d0                	add    %edx,%eax
  800b16:	c1 e0 03             	shl    $0x3,%eax
  800b19:	01 c8                	add    %ecx,%eax
  800b1b:	8a 40 04             	mov    0x4(%eax),%al
  800b1e:	84 c0                	test   %al,%al
  800b20:	75 46                	jne    800b68 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800b22:	a1 20 50 80 00       	mov    0x805020,%eax
  800b27:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800b2d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800b30:	89 d0                	mov    %edx,%eax
  800b32:	01 c0                	add    %eax,%eax
  800b34:	01 d0                	add    %edx,%eax
  800b36:	c1 e0 03             	shl    $0x3,%eax
  800b39:	01 c8                	add    %ecx,%eax
  800b3b:	8b 00                	mov    (%eax),%eax
  800b3d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800b40:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800b43:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b48:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800b4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b4d:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800b54:	8b 45 08             	mov    0x8(%ebp),%eax
  800b57:	01 c8                	add    %ecx,%eax
  800b59:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800b5b:	39 c2                	cmp    %eax,%edx
  800b5d:	75 09                	jne    800b68 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800b5f:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800b66:	eb 12                	jmp    800b7a <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b68:	ff 45 e8             	incl   -0x18(%ebp)
  800b6b:	a1 20 50 80 00       	mov    0x805020,%eax
  800b70:	8b 50 74             	mov    0x74(%eax),%edx
  800b73:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800b76:	39 c2                	cmp    %eax,%edx
  800b78:	77 88                	ja     800b02 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800b7a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800b7e:	75 14                	jne    800b94 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800b80:	83 ec 04             	sub    $0x4,%esp
  800b83:	68 78 3c 80 00       	push   $0x803c78
  800b88:	6a 3a                	push   $0x3a
  800b8a:	68 6c 3c 80 00       	push   $0x803c6c
  800b8f:	e8 93 fe ff ff       	call   800a27 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800b94:	ff 45 f0             	incl   -0x10(%ebp)
  800b97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b9a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800b9d:	0f 8c 32 ff ff ff    	jl     800ad5 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800ba3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800baa:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800bb1:	eb 26                	jmp    800bd9 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800bb3:	a1 20 50 80 00       	mov    0x805020,%eax
  800bb8:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800bbe:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800bc1:	89 d0                	mov    %edx,%eax
  800bc3:	01 c0                	add    %eax,%eax
  800bc5:	01 d0                	add    %edx,%eax
  800bc7:	c1 e0 03             	shl    $0x3,%eax
  800bca:	01 c8                	add    %ecx,%eax
  800bcc:	8a 40 04             	mov    0x4(%eax),%al
  800bcf:	3c 01                	cmp    $0x1,%al
  800bd1:	75 03                	jne    800bd6 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800bd3:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800bd6:	ff 45 e0             	incl   -0x20(%ebp)
  800bd9:	a1 20 50 80 00       	mov    0x805020,%eax
  800bde:	8b 50 74             	mov    0x74(%eax),%edx
  800be1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800be4:	39 c2                	cmp    %eax,%edx
  800be6:	77 cb                	ja     800bb3 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800be8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800beb:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800bee:	74 14                	je     800c04 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800bf0:	83 ec 04             	sub    $0x4,%esp
  800bf3:	68 cc 3c 80 00       	push   $0x803ccc
  800bf8:	6a 44                	push   $0x44
  800bfa:	68 6c 3c 80 00       	push   $0x803c6c
  800bff:	e8 23 fe ff ff       	call   800a27 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800c04:	90                   	nop
  800c05:	c9                   	leave  
  800c06:	c3                   	ret    

00800c07 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800c07:	55                   	push   %ebp
  800c08:	89 e5                	mov    %esp,%ebp
  800c0a:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800c0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c10:	8b 00                	mov    (%eax),%eax
  800c12:	8d 48 01             	lea    0x1(%eax),%ecx
  800c15:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c18:	89 0a                	mov    %ecx,(%edx)
  800c1a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c1d:	88 d1                	mov    %dl,%cl
  800c1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c22:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800c26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c29:	8b 00                	mov    (%eax),%eax
  800c2b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800c30:	75 2c                	jne    800c5e <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800c32:	a0 24 50 80 00       	mov    0x805024,%al
  800c37:	0f b6 c0             	movzbl %al,%eax
  800c3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c3d:	8b 12                	mov    (%edx),%edx
  800c3f:	89 d1                	mov    %edx,%ecx
  800c41:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c44:	83 c2 08             	add    $0x8,%edx
  800c47:	83 ec 04             	sub    $0x4,%esp
  800c4a:	50                   	push   %eax
  800c4b:	51                   	push   %ecx
  800c4c:	52                   	push   %edx
  800c4d:	e8 22 13 00 00       	call   801f74 <sys_cputs>
  800c52:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800c55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c58:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800c5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c61:	8b 40 04             	mov    0x4(%eax),%eax
  800c64:	8d 50 01             	lea    0x1(%eax),%edx
  800c67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c6a:	89 50 04             	mov    %edx,0x4(%eax)
}
  800c6d:	90                   	nop
  800c6e:	c9                   	leave  
  800c6f:	c3                   	ret    

00800c70 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800c70:	55                   	push   %ebp
  800c71:	89 e5                	mov    %esp,%ebp
  800c73:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800c79:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800c80:	00 00 00 
	b.cnt = 0;
  800c83:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800c8a:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800c8d:	ff 75 0c             	pushl  0xc(%ebp)
  800c90:	ff 75 08             	pushl  0x8(%ebp)
  800c93:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800c99:	50                   	push   %eax
  800c9a:	68 07 0c 80 00       	push   $0x800c07
  800c9f:	e8 11 02 00 00       	call   800eb5 <vprintfmt>
  800ca4:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800ca7:	a0 24 50 80 00       	mov    0x805024,%al
  800cac:	0f b6 c0             	movzbl %al,%eax
  800caf:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800cb5:	83 ec 04             	sub    $0x4,%esp
  800cb8:	50                   	push   %eax
  800cb9:	52                   	push   %edx
  800cba:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800cc0:	83 c0 08             	add    $0x8,%eax
  800cc3:	50                   	push   %eax
  800cc4:	e8 ab 12 00 00       	call   801f74 <sys_cputs>
  800cc9:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800ccc:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800cd3:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800cd9:	c9                   	leave  
  800cda:	c3                   	ret    

00800cdb <cprintf>:

int cprintf(const char *fmt, ...) {
  800cdb:	55                   	push   %ebp
  800cdc:	89 e5                	mov    %esp,%ebp
  800cde:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800ce1:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800ce8:	8d 45 0c             	lea    0xc(%ebp),%eax
  800ceb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800cee:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf1:	83 ec 08             	sub    $0x8,%esp
  800cf4:	ff 75 f4             	pushl  -0xc(%ebp)
  800cf7:	50                   	push   %eax
  800cf8:	e8 73 ff ff ff       	call   800c70 <vcprintf>
  800cfd:	83 c4 10             	add    $0x10,%esp
  800d00:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800d03:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d06:	c9                   	leave  
  800d07:	c3                   	ret    

00800d08 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800d08:	55                   	push   %ebp
  800d09:	89 e5                	mov    %esp,%ebp
  800d0b:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800d0e:	e8 0f 14 00 00       	call   802122 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800d13:	8d 45 0c             	lea    0xc(%ebp),%eax
  800d16:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800d19:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1c:	83 ec 08             	sub    $0x8,%esp
  800d1f:	ff 75 f4             	pushl  -0xc(%ebp)
  800d22:	50                   	push   %eax
  800d23:	e8 48 ff ff ff       	call   800c70 <vcprintf>
  800d28:	83 c4 10             	add    $0x10,%esp
  800d2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800d2e:	e8 09 14 00 00       	call   80213c <sys_enable_interrupt>
	return cnt;
  800d33:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d36:	c9                   	leave  
  800d37:	c3                   	ret    

00800d38 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800d38:	55                   	push   %ebp
  800d39:	89 e5                	mov    %esp,%ebp
  800d3b:	53                   	push   %ebx
  800d3c:	83 ec 14             	sub    $0x14,%esp
  800d3f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d42:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d45:	8b 45 14             	mov    0x14(%ebp),%eax
  800d48:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800d4b:	8b 45 18             	mov    0x18(%ebp),%eax
  800d4e:	ba 00 00 00 00       	mov    $0x0,%edx
  800d53:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800d56:	77 55                	ja     800dad <printnum+0x75>
  800d58:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800d5b:	72 05                	jb     800d62 <printnum+0x2a>
  800d5d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800d60:	77 4b                	ja     800dad <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800d62:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800d65:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800d68:	8b 45 18             	mov    0x18(%ebp),%eax
  800d6b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d70:	52                   	push   %edx
  800d71:	50                   	push   %eax
  800d72:	ff 75 f4             	pushl  -0xc(%ebp)
  800d75:	ff 75 f0             	pushl  -0x10(%ebp)
  800d78:	e8 b3 29 00 00       	call   803730 <__udivdi3>
  800d7d:	83 c4 10             	add    $0x10,%esp
  800d80:	83 ec 04             	sub    $0x4,%esp
  800d83:	ff 75 20             	pushl  0x20(%ebp)
  800d86:	53                   	push   %ebx
  800d87:	ff 75 18             	pushl  0x18(%ebp)
  800d8a:	52                   	push   %edx
  800d8b:	50                   	push   %eax
  800d8c:	ff 75 0c             	pushl  0xc(%ebp)
  800d8f:	ff 75 08             	pushl  0x8(%ebp)
  800d92:	e8 a1 ff ff ff       	call   800d38 <printnum>
  800d97:	83 c4 20             	add    $0x20,%esp
  800d9a:	eb 1a                	jmp    800db6 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800d9c:	83 ec 08             	sub    $0x8,%esp
  800d9f:	ff 75 0c             	pushl  0xc(%ebp)
  800da2:	ff 75 20             	pushl  0x20(%ebp)
  800da5:	8b 45 08             	mov    0x8(%ebp),%eax
  800da8:	ff d0                	call   *%eax
  800daa:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800dad:	ff 4d 1c             	decl   0x1c(%ebp)
  800db0:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800db4:	7f e6                	jg     800d9c <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800db6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800db9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dc1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dc4:	53                   	push   %ebx
  800dc5:	51                   	push   %ecx
  800dc6:	52                   	push   %edx
  800dc7:	50                   	push   %eax
  800dc8:	e8 73 2a 00 00       	call   803840 <__umoddi3>
  800dcd:	83 c4 10             	add    $0x10,%esp
  800dd0:	05 34 3f 80 00       	add    $0x803f34,%eax
  800dd5:	8a 00                	mov    (%eax),%al
  800dd7:	0f be c0             	movsbl %al,%eax
  800dda:	83 ec 08             	sub    $0x8,%esp
  800ddd:	ff 75 0c             	pushl  0xc(%ebp)
  800de0:	50                   	push   %eax
  800de1:	8b 45 08             	mov    0x8(%ebp),%eax
  800de4:	ff d0                	call   *%eax
  800de6:	83 c4 10             	add    $0x10,%esp
}
  800de9:	90                   	nop
  800dea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ded:	c9                   	leave  
  800dee:	c3                   	ret    

00800def <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800def:	55                   	push   %ebp
  800df0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800df2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800df6:	7e 1c                	jle    800e14 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800df8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfb:	8b 00                	mov    (%eax),%eax
  800dfd:	8d 50 08             	lea    0x8(%eax),%edx
  800e00:	8b 45 08             	mov    0x8(%ebp),%eax
  800e03:	89 10                	mov    %edx,(%eax)
  800e05:	8b 45 08             	mov    0x8(%ebp),%eax
  800e08:	8b 00                	mov    (%eax),%eax
  800e0a:	83 e8 08             	sub    $0x8,%eax
  800e0d:	8b 50 04             	mov    0x4(%eax),%edx
  800e10:	8b 00                	mov    (%eax),%eax
  800e12:	eb 40                	jmp    800e54 <getuint+0x65>
	else if (lflag)
  800e14:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e18:	74 1e                	je     800e38 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800e1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1d:	8b 00                	mov    (%eax),%eax
  800e1f:	8d 50 04             	lea    0x4(%eax),%edx
  800e22:	8b 45 08             	mov    0x8(%ebp),%eax
  800e25:	89 10                	mov    %edx,(%eax)
  800e27:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2a:	8b 00                	mov    (%eax),%eax
  800e2c:	83 e8 04             	sub    $0x4,%eax
  800e2f:	8b 00                	mov    (%eax),%eax
  800e31:	ba 00 00 00 00       	mov    $0x0,%edx
  800e36:	eb 1c                	jmp    800e54 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800e38:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3b:	8b 00                	mov    (%eax),%eax
  800e3d:	8d 50 04             	lea    0x4(%eax),%edx
  800e40:	8b 45 08             	mov    0x8(%ebp),%eax
  800e43:	89 10                	mov    %edx,(%eax)
  800e45:	8b 45 08             	mov    0x8(%ebp),%eax
  800e48:	8b 00                	mov    (%eax),%eax
  800e4a:	83 e8 04             	sub    $0x4,%eax
  800e4d:	8b 00                	mov    (%eax),%eax
  800e4f:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800e54:	5d                   	pop    %ebp
  800e55:	c3                   	ret    

00800e56 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800e56:	55                   	push   %ebp
  800e57:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800e59:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800e5d:	7e 1c                	jle    800e7b <getint+0x25>
		return va_arg(*ap, long long);
  800e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e62:	8b 00                	mov    (%eax),%eax
  800e64:	8d 50 08             	lea    0x8(%eax),%edx
  800e67:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6a:	89 10                	mov    %edx,(%eax)
  800e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6f:	8b 00                	mov    (%eax),%eax
  800e71:	83 e8 08             	sub    $0x8,%eax
  800e74:	8b 50 04             	mov    0x4(%eax),%edx
  800e77:	8b 00                	mov    (%eax),%eax
  800e79:	eb 38                	jmp    800eb3 <getint+0x5d>
	else if (lflag)
  800e7b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e7f:	74 1a                	je     800e9b <getint+0x45>
		return va_arg(*ap, long);
  800e81:	8b 45 08             	mov    0x8(%ebp),%eax
  800e84:	8b 00                	mov    (%eax),%eax
  800e86:	8d 50 04             	lea    0x4(%eax),%edx
  800e89:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8c:	89 10                	mov    %edx,(%eax)
  800e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e91:	8b 00                	mov    (%eax),%eax
  800e93:	83 e8 04             	sub    $0x4,%eax
  800e96:	8b 00                	mov    (%eax),%eax
  800e98:	99                   	cltd   
  800e99:	eb 18                	jmp    800eb3 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9e:	8b 00                	mov    (%eax),%eax
  800ea0:	8d 50 04             	lea    0x4(%eax),%edx
  800ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea6:	89 10                	mov    %edx,(%eax)
  800ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eab:	8b 00                	mov    (%eax),%eax
  800ead:	83 e8 04             	sub    $0x4,%eax
  800eb0:	8b 00                	mov    (%eax),%eax
  800eb2:	99                   	cltd   
}
  800eb3:	5d                   	pop    %ebp
  800eb4:	c3                   	ret    

00800eb5 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800eb5:	55                   	push   %ebp
  800eb6:	89 e5                	mov    %esp,%ebp
  800eb8:	56                   	push   %esi
  800eb9:	53                   	push   %ebx
  800eba:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ebd:	eb 17                	jmp    800ed6 <vprintfmt+0x21>
			if (ch == '\0')
  800ebf:	85 db                	test   %ebx,%ebx
  800ec1:	0f 84 af 03 00 00    	je     801276 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800ec7:	83 ec 08             	sub    $0x8,%esp
  800eca:	ff 75 0c             	pushl  0xc(%ebp)
  800ecd:	53                   	push   %ebx
  800ece:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed1:	ff d0                	call   *%eax
  800ed3:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ed6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed9:	8d 50 01             	lea    0x1(%eax),%edx
  800edc:	89 55 10             	mov    %edx,0x10(%ebp)
  800edf:	8a 00                	mov    (%eax),%al
  800ee1:	0f b6 d8             	movzbl %al,%ebx
  800ee4:	83 fb 25             	cmp    $0x25,%ebx
  800ee7:	75 d6                	jne    800ebf <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800ee9:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800eed:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800ef4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800efb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800f02:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800f09:	8b 45 10             	mov    0x10(%ebp),%eax
  800f0c:	8d 50 01             	lea    0x1(%eax),%edx
  800f0f:	89 55 10             	mov    %edx,0x10(%ebp)
  800f12:	8a 00                	mov    (%eax),%al
  800f14:	0f b6 d8             	movzbl %al,%ebx
  800f17:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800f1a:	83 f8 55             	cmp    $0x55,%eax
  800f1d:	0f 87 2b 03 00 00    	ja     80124e <vprintfmt+0x399>
  800f23:	8b 04 85 58 3f 80 00 	mov    0x803f58(,%eax,4),%eax
  800f2a:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800f2c:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800f30:	eb d7                	jmp    800f09 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800f32:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800f36:	eb d1                	jmp    800f09 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800f38:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800f3f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800f42:	89 d0                	mov    %edx,%eax
  800f44:	c1 e0 02             	shl    $0x2,%eax
  800f47:	01 d0                	add    %edx,%eax
  800f49:	01 c0                	add    %eax,%eax
  800f4b:	01 d8                	add    %ebx,%eax
  800f4d:	83 e8 30             	sub    $0x30,%eax
  800f50:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800f53:	8b 45 10             	mov    0x10(%ebp),%eax
  800f56:	8a 00                	mov    (%eax),%al
  800f58:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800f5b:	83 fb 2f             	cmp    $0x2f,%ebx
  800f5e:	7e 3e                	jle    800f9e <vprintfmt+0xe9>
  800f60:	83 fb 39             	cmp    $0x39,%ebx
  800f63:	7f 39                	jg     800f9e <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800f65:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800f68:	eb d5                	jmp    800f3f <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800f6a:	8b 45 14             	mov    0x14(%ebp),%eax
  800f6d:	83 c0 04             	add    $0x4,%eax
  800f70:	89 45 14             	mov    %eax,0x14(%ebp)
  800f73:	8b 45 14             	mov    0x14(%ebp),%eax
  800f76:	83 e8 04             	sub    $0x4,%eax
  800f79:	8b 00                	mov    (%eax),%eax
  800f7b:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800f7e:	eb 1f                	jmp    800f9f <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800f80:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f84:	79 83                	jns    800f09 <vprintfmt+0x54>
				width = 0;
  800f86:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800f8d:	e9 77 ff ff ff       	jmp    800f09 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800f92:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800f99:	e9 6b ff ff ff       	jmp    800f09 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800f9e:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800f9f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fa3:	0f 89 60 ff ff ff    	jns    800f09 <vprintfmt+0x54>
				width = precision, precision = -1;
  800fa9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800faf:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800fb6:	e9 4e ff ff ff       	jmp    800f09 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800fbb:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800fbe:	e9 46 ff ff ff       	jmp    800f09 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800fc3:	8b 45 14             	mov    0x14(%ebp),%eax
  800fc6:	83 c0 04             	add    $0x4,%eax
  800fc9:	89 45 14             	mov    %eax,0x14(%ebp)
  800fcc:	8b 45 14             	mov    0x14(%ebp),%eax
  800fcf:	83 e8 04             	sub    $0x4,%eax
  800fd2:	8b 00                	mov    (%eax),%eax
  800fd4:	83 ec 08             	sub    $0x8,%esp
  800fd7:	ff 75 0c             	pushl  0xc(%ebp)
  800fda:	50                   	push   %eax
  800fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fde:	ff d0                	call   *%eax
  800fe0:	83 c4 10             	add    $0x10,%esp
			break;
  800fe3:	e9 89 02 00 00       	jmp    801271 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800fe8:	8b 45 14             	mov    0x14(%ebp),%eax
  800feb:	83 c0 04             	add    $0x4,%eax
  800fee:	89 45 14             	mov    %eax,0x14(%ebp)
  800ff1:	8b 45 14             	mov    0x14(%ebp),%eax
  800ff4:	83 e8 04             	sub    $0x4,%eax
  800ff7:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ff9:	85 db                	test   %ebx,%ebx
  800ffb:	79 02                	jns    800fff <vprintfmt+0x14a>
				err = -err;
  800ffd:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800fff:	83 fb 64             	cmp    $0x64,%ebx
  801002:	7f 0b                	jg     80100f <vprintfmt+0x15a>
  801004:	8b 34 9d a0 3d 80 00 	mov    0x803da0(,%ebx,4),%esi
  80100b:	85 f6                	test   %esi,%esi
  80100d:	75 19                	jne    801028 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80100f:	53                   	push   %ebx
  801010:	68 45 3f 80 00       	push   $0x803f45
  801015:	ff 75 0c             	pushl  0xc(%ebp)
  801018:	ff 75 08             	pushl  0x8(%ebp)
  80101b:	e8 5e 02 00 00       	call   80127e <printfmt>
  801020:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801023:	e9 49 02 00 00       	jmp    801271 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801028:	56                   	push   %esi
  801029:	68 4e 3f 80 00       	push   $0x803f4e
  80102e:	ff 75 0c             	pushl  0xc(%ebp)
  801031:	ff 75 08             	pushl  0x8(%ebp)
  801034:	e8 45 02 00 00       	call   80127e <printfmt>
  801039:	83 c4 10             	add    $0x10,%esp
			break;
  80103c:	e9 30 02 00 00       	jmp    801271 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801041:	8b 45 14             	mov    0x14(%ebp),%eax
  801044:	83 c0 04             	add    $0x4,%eax
  801047:	89 45 14             	mov    %eax,0x14(%ebp)
  80104a:	8b 45 14             	mov    0x14(%ebp),%eax
  80104d:	83 e8 04             	sub    $0x4,%eax
  801050:	8b 30                	mov    (%eax),%esi
  801052:	85 f6                	test   %esi,%esi
  801054:	75 05                	jne    80105b <vprintfmt+0x1a6>
				p = "(null)";
  801056:	be 51 3f 80 00       	mov    $0x803f51,%esi
			if (width > 0 && padc != '-')
  80105b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80105f:	7e 6d                	jle    8010ce <vprintfmt+0x219>
  801061:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801065:	74 67                	je     8010ce <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801067:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80106a:	83 ec 08             	sub    $0x8,%esp
  80106d:	50                   	push   %eax
  80106e:	56                   	push   %esi
  80106f:	e8 0c 03 00 00       	call   801380 <strnlen>
  801074:	83 c4 10             	add    $0x10,%esp
  801077:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80107a:	eb 16                	jmp    801092 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80107c:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801080:	83 ec 08             	sub    $0x8,%esp
  801083:	ff 75 0c             	pushl  0xc(%ebp)
  801086:	50                   	push   %eax
  801087:	8b 45 08             	mov    0x8(%ebp),%eax
  80108a:	ff d0                	call   *%eax
  80108c:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80108f:	ff 4d e4             	decl   -0x1c(%ebp)
  801092:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801096:	7f e4                	jg     80107c <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801098:	eb 34                	jmp    8010ce <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80109a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80109e:	74 1c                	je     8010bc <vprintfmt+0x207>
  8010a0:	83 fb 1f             	cmp    $0x1f,%ebx
  8010a3:	7e 05                	jle    8010aa <vprintfmt+0x1f5>
  8010a5:	83 fb 7e             	cmp    $0x7e,%ebx
  8010a8:	7e 12                	jle    8010bc <vprintfmt+0x207>
					putch('?', putdat);
  8010aa:	83 ec 08             	sub    $0x8,%esp
  8010ad:	ff 75 0c             	pushl  0xc(%ebp)
  8010b0:	6a 3f                	push   $0x3f
  8010b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b5:	ff d0                	call   *%eax
  8010b7:	83 c4 10             	add    $0x10,%esp
  8010ba:	eb 0f                	jmp    8010cb <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8010bc:	83 ec 08             	sub    $0x8,%esp
  8010bf:	ff 75 0c             	pushl  0xc(%ebp)
  8010c2:	53                   	push   %ebx
  8010c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c6:	ff d0                	call   *%eax
  8010c8:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8010cb:	ff 4d e4             	decl   -0x1c(%ebp)
  8010ce:	89 f0                	mov    %esi,%eax
  8010d0:	8d 70 01             	lea    0x1(%eax),%esi
  8010d3:	8a 00                	mov    (%eax),%al
  8010d5:	0f be d8             	movsbl %al,%ebx
  8010d8:	85 db                	test   %ebx,%ebx
  8010da:	74 24                	je     801100 <vprintfmt+0x24b>
  8010dc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8010e0:	78 b8                	js     80109a <vprintfmt+0x1e5>
  8010e2:	ff 4d e0             	decl   -0x20(%ebp)
  8010e5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8010e9:	79 af                	jns    80109a <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8010eb:	eb 13                	jmp    801100 <vprintfmt+0x24b>
				putch(' ', putdat);
  8010ed:	83 ec 08             	sub    $0x8,%esp
  8010f0:	ff 75 0c             	pushl  0xc(%ebp)
  8010f3:	6a 20                	push   $0x20
  8010f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f8:	ff d0                	call   *%eax
  8010fa:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8010fd:	ff 4d e4             	decl   -0x1c(%ebp)
  801100:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801104:	7f e7                	jg     8010ed <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801106:	e9 66 01 00 00       	jmp    801271 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80110b:	83 ec 08             	sub    $0x8,%esp
  80110e:	ff 75 e8             	pushl  -0x18(%ebp)
  801111:	8d 45 14             	lea    0x14(%ebp),%eax
  801114:	50                   	push   %eax
  801115:	e8 3c fd ff ff       	call   800e56 <getint>
  80111a:	83 c4 10             	add    $0x10,%esp
  80111d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801120:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801123:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801126:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801129:	85 d2                	test   %edx,%edx
  80112b:	79 23                	jns    801150 <vprintfmt+0x29b>
				putch('-', putdat);
  80112d:	83 ec 08             	sub    $0x8,%esp
  801130:	ff 75 0c             	pushl  0xc(%ebp)
  801133:	6a 2d                	push   $0x2d
  801135:	8b 45 08             	mov    0x8(%ebp),%eax
  801138:	ff d0                	call   *%eax
  80113a:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80113d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801140:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801143:	f7 d8                	neg    %eax
  801145:	83 d2 00             	adc    $0x0,%edx
  801148:	f7 da                	neg    %edx
  80114a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80114d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801150:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801157:	e9 bc 00 00 00       	jmp    801218 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80115c:	83 ec 08             	sub    $0x8,%esp
  80115f:	ff 75 e8             	pushl  -0x18(%ebp)
  801162:	8d 45 14             	lea    0x14(%ebp),%eax
  801165:	50                   	push   %eax
  801166:	e8 84 fc ff ff       	call   800def <getuint>
  80116b:	83 c4 10             	add    $0x10,%esp
  80116e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801171:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801174:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80117b:	e9 98 00 00 00       	jmp    801218 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801180:	83 ec 08             	sub    $0x8,%esp
  801183:	ff 75 0c             	pushl  0xc(%ebp)
  801186:	6a 58                	push   $0x58
  801188:	8b 45 08             	mov    0x8(%ebp),%eax
  80118b:	ff d0                	call   *%eax
  80118d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801190:	83 ec 08             	sub    $0x8,%esp
  801193:	ff 75 0c             	pushl  0xc(%ebp)
  801196:	6a 58                	push   $0x58
  801198:	8b 45 08             	mov    0x8(%ebp),%eax
  80119b:	ff d0                	call   *%eax
  80119d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8011a0:	83 ec 08             	sub    $0x8,%esp
  8011a3:	ff 75 0c             	pushl  0xc(%ebp)
  8011a6:	6a 58                	push   $0x58
  8011a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ab:	ff d0                	call   *%eax
  8011ad:	83 c4 10             	add    $0x10,%esp
			break;
  8011b0:	e9 bc 00 00 00       	jmp    801271 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8011b5:	83 ec 08             	sub    $0x8,%esp
  8011b8:	ff 75 0c             	pushl  0xc(%ebp)
  8011bb:	6a 30                	push   $0x30
  8011bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c0:	ff d0                	call   *%eax
  8011c2:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8011c5:	83 ec 08             	sub    $0x8,%esp
  8011c8:	ff 75 0c             	pushl  0xc(%ebp)
  8011cb:	6a 78                	push   $0x78
  8011cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d0:	ff d0                	call   *%eax
  8011d2:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8011d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8011d8:	83 c0 04             	add    $0x4,%eax
  8011db:	89 45 14             	mov    %eax,0x14(%ebp)
  8011de:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e1:	83 e8 04             	sub    $0x4,%eax
  8011e4:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8011e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011e9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8011f0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8011f7:	eb 1f                	jmp    801218 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8011f9:	83 ec 08             	sub    $0x8,%esp
  8011fc:	ff 75 e8             	pushl  -0x18(%ebp)
  8011ff:	8d 45 14             	lea    0x14(%ebp),%eax
  801202:	50                   	push   %eax
  801203:	e8 e7 fb ff ff       	call   800def <getuint>
  801208:	83 c4 10             	add    $0x10,%esp
  80120b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80120e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801211:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801218:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80121c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80121f:	83 ec 04             	sub    $0x4,%esp
  801222:	52                   	push   %edx
  801223:	ff 75 e4             	pushl  -0x1c(%ebp)
  801226:	50                   	push   %eax
  801227:	ff 75 f4             	pushl  -0xc(%ebp)
  80122a:	ff 75 f0             	pushl  -0x10(%ebp)
  80122d:	ff 75 0c             	pushl  0xc(%ebp)
  801230:	ff 75 08             	pushl  0x8(%ebp)
  801233:	e8 00 fb ff ff       	call   800d38 <printnum>
  801238:	83 c4 20             	add    $0x20,%esp
			break;
  80123b:	eb 34                	jmp    801271 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80123d:	83 ec 08             	sub    $0x8,%esp
  801240:	ff 75 0c             	pushl  0xc(%ebp)
  801243:	53                   	push   %ebx
  801244:	8b 45 08             	mov    0x8(%ebp),%eax
  801247:	ff d0                	call   *%eax
  801249:	83 c4 10             	add    $0x10,%esp
			break;
  80124c:	eb 23                	jmp    801271 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80124e:	83 ec 08             	sub    $0x8,%esp
  801251:	ff 75 0c             	pushl  0xc(%ebp)
  801254:	6a 25                	push   $0x25
  801256:	8b 45 08             	mov    0x8(%ebp),%eax
  801259:	ff d0                	call   *%eax
  80125b:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80125e:	ff 4d 10             	decl   0x10(%ebp)
  801261:	eb 03                	jmp    801266 <vprintfmt+0x3b1>
  801263:	ff 4d 10             	decl   0x10(%ebp)
  801266:	8b 45 10             	mov    0x10(%ebp),%eax
  801269:	48                   	dec    %eax
  80126a:	8a 00                	mov    (%eax),%al
  80126c:	3c 25                	cmp    $0x25,%al
  80126e:	75 f3                	jne    801263 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801270:	90                   	nop
		}
	}
  801271:	e9 47 fc ff ff       	jmp    800ebd <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801276:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801277:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80127a:	5b                   	pop    %ebx
  80127b:	5e                   	pop    %esi
  80127c:	5d                   	pop    %ebp
  80127d:	c3                   	ret    

0080127e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80127e:	55                   	push   %ebp
  80127f:	89 e5                	mov    %esp,%ebp
  801281:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801284:	8d 45 10             	lea    0x10(%ebp),%eax
  801287:	83 c0 04             	add    $0x4,%eax
  80128a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80128d:	8b 45 10             	mov    0x10(%ebp),%eax
  801290:	ff 75 f4             	pushl  -0xc(%ebp)
  801293:	50                   	push   %eax
  801294:	ff 75 0c             	pushl  0xc(%ebp)
  801297:	ff 75 08             	pushl  0x8(%ebp)
  80129a:	e8 16 fc ff ff       	call   800eb5 <vprintfmt>
  80129f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8012a2:	90                   	nop
  8012a3:	c9                   	leave  
  8012a4:	c3                   	ret    

008012a5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8012a5:	55                   	push   %ebp
  8012a6:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8012a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ab:	8b 40 08             	mov    0x8(%eax),%eax
  8012ae:	8d 50 01             	lea    0x1(%eax),%edx
  8012b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b4:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8012b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ba:	8b 10                	mov    (%eax),%edx
  8012bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012bf:	8b 40 04             	mov    0x4(%eax),%eax
  8012c2:	39 c2                	cmp    %eax,%edx
  8012c4:	73 12                	jae    8012d8 <sprintputch+0x33>
		*b->buf++ = ch;
  8012c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c9:	8b 00                	mov    (%eax),%eax
  8012cb:	8d 48 01             	lea    0x1(%eax),%ecx
  8012ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012d1:	89 0a                	mov    %ecx,(%edx)
  8012d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8012d6:	88 10                	mov    %dl,(%eax)
}
  8012d8:	90                   	nop
  8012d9:	5d                   	pop    %ebp
  8012da:	c3                   	ret    

008012db <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8012db:	55                   	push   %ebp
  8012dc:	89 e5                	mov    %esp,%ebp
  8012de:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8012e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8012e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ea:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f0:	01 d0                	add    %edx,%eax
  8012f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8012f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8012fc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801300:	74 06                	je     801308 <vsnprintf+0x2d>
  801302:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801306:	7f 07                	jg     80130f <vsnprintf+0x34>
		return -E_INVAL;
  801308:	b8 03 00 00 00       	mov    $0x3,%eax
  80130d:	eb 20                	jmp    80132f <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80130f:	ff 75 14             	pushl  0x14(%ebp)
  801312:	ff 75 10             	pushl  0x10(%ebp)
  801315:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801318:	50                   	push   %eax
  801319:	68 a5 12 80 00       	push   $0x8012a5
  80131e:	e8 92 fb ff ff       	call   800eb5 <vprintfmt>
  801323:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801326:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801329:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80132c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80132f:	c9                   	leave  
  801330:	c3                   	ret    

00801331 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801331:	55                   	push   %ebp
  801332:	89 e5                	mov    %esp,%ebp
  801334:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801337:	8d 45 10             	lea    0x10(%ebp),%eax
  80133a:	83 c0 04             	add    $0x4,%eax
  80133d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801340:	8b 45 10             	mov    0x10(%ebp),%eax
  801343:	ff 75 f4             	pushl  -0xc(%ebp)
  801346:	50                   	push   %eax
  801347:	ff 75 0c             	pushl  0xc(%ebp)
  80134a:	ff 75 08             	pushl  0x8(%ebp)
  80134d:	e8 89 ff ff ff       	call   8012db <vsnprintf>
  801352:	83 c4 10             	add    $0x10,%esp
  801355:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801358:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80135b:	c9                   	leave  
  80135c:	c3                   	ret    

0080135d <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80135d:	55                   	push   %ebp
  80135e:	89 e5                	mov    %esp,%ebp
  801360:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801363:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80136a:	eb 06                	jmp    801372 <strlen+0x15>
		n++;
  80136c:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80136f:	ff 45 08             	incl   0x8(%ebp)
  801372:	8b 45 08             	mov    0x8(%ebp),%eax
  801375:	8a 00                	mov    (%eax),%al
  801377:	84 c0                	test   %al,%al
  801379:	75 f1                	jne    80136c <strlen+0xf>
		n++;
	return n;
  80137b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80137e:	c9                   	leave  
  80137f:	c3                   	ret    

00801380 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801380:	55                   	push   %ebp
  801381:	89 e5                	mov    %esp,%ebp
  801383:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801386:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80138d:	eb 09                	jmp    801398 <strnlen+0x18>
		n++;
  80138f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801392:	ff 45 08             	incl   0x8(%ebp)
  801395:	ff 4d 0c             	decl   0xc(%ebp)
  801398:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80139c:	74 09                	je     8013a7 <strnlen+0x27>
  80139e:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a1:	8a 00                	mov    (%eax),%al
  8013a3:	84 c0                	test   %al,%al
  8013a5:	75 e8                	jne    80138f <strnlen+0xf>
		n++;
	return n;
  8013a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8013aa:	c9                   	leave  
  8013ab:	c3                   	ret    

008013ac <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8013ac:	55                   	push   %ebp
  8013ad:	89 e5                	mov    %esp,%ebp
  8013af:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8013b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8013b8:	90                   	nop
  8013b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bc:	8d 50 01             	lea    0x1(%eax),%edx
  8013bf:	89 55 08             	mov    %edx,0x8(%ebp)
  8013c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013c5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013c8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8013cb:	8a 12                	mov    (%edx),%dl
  8013cd:	88 10                	mov    %dl,(%eax)
  8013cf:	8a 00                	mov    (%eax),%al
  8013d1:	84 c0                	test   %al,%al
  8013d3:	75 e4                	jne    8013b9 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8013d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8013d8:	c9                   	leave  
  8013d9:	c3                   	ret    

008013da <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8013da:	55                   	push   %ebp
  8013db:	89 e5                	mov    %esp,%ebp
  8013dd:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8013e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8013e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013ed:	eb 1f                	jmp    80140e <strncpy+0x34>
		*dst++ = *src;
  8013ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f2:	8d 50 01             	lea    0x1(%eax),%edx
  8013f5:	89 55 08             	mov    %edx,0x8(%ebp)
  8013f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013fb:	8a 12                	mov    (%edx),%dl
  8013fd:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8013ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801402:	8a 00                	mov    (%eax),%al
  801404:	84 c0                	test   %al,%al
  801406:	74 03                	je     80140b <strncpy+0x31>
			src++;
  801408:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80140b:	ff 45 fc             	incl   -0x4(%ebp)
  80140e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801411:	3b 45 10             	cmp    0x10(%ebp),%eax
  801414:	72 d9                	jb     8013ef <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801416:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801419:	c9                   	leave  
  80141a:	c3                   	ret    

0080141b <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80141b:	55                   	push   %ebp
  80141c:	89 e5                	mov    %esp,%ebp
  80141e:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801421:	8b 45 08             	mov    0x8(%ebp),%eax
  801424:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801427:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80142b:	74 30                	je     80145d <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80142d:	eb 16                	jmp    801445 <strlcpy+0x2a>
			*dst++ = *src++;
  80142f:	8b 45 08             	mov    0x8(%ebp),%eax
  801432:	8d 50 01             	lea    0x1(%eax),%edx
  801435:	89 55 08             	mov    %edx,0x8(%ebp)
  801438:	8b 55 0c             	mov    0xc(%ebp),%edx
  80143b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80143e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801441:	8a 12                	mov    (%edx),%dl
  801443:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801445:	ff 4d 10             	decl   0x10(%ebp)
  801448:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80144c:	74 09                	je     801457 <strlcpy+0x3c>
  80144e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801451:	8a 00                	mov    (%eax),%al
  801453:	84 c0                	test   %al,%al
  801455:	75 d8                	jne    80142f <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801457:	8b 45 08             	mov    0x8(%ebp),%eax
  80145a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80145d:	8b 55 08             	mov    0x8(%ebp),%edx
  801460:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801463:	29 c2                	sub    %eax,%edx
  801465:	89 d0                	mov    %edx,%eax
}
  801467:	c9                   	leave  
  801468:	c3                   	ret    

00801469 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801469:	55                   	push   %ebp
  80146a:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80146c:	eb 06                	jmp    801474 <strcmp+0xb>
		p++, q++;
  80146e:	ff 45 08             	incl   0x8(%ebp)
  801471:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801474:	8b 45 08             	mov    0x8(%ebp),%eax
  801477:	8a 00                	mov    (%eax),%al
  801479:	84 c0                	test   %al,%al
  80147b:	74 0e                	je     80148b <strcmp+0x22>
  80147d:	8b 45 08             	mov    0x8(%ebp),%eax
  801480:	8a 10                	mov    (%eax),%dl
  801482:	8b 45 0c             	mov    0xc(%ebp),%eax
  801485:	8a 00                	mov    (%eax),%al
  801487:	38 c2                	cmp    %al,%dl
  801489:	74 e3                	je     80146e <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80148b:	8b 45 08             	mov    0x8(%ebp),%eax
  80148e:	8a 00                	mov    (%eax),%al
  801490:	0f b6 d0             	movzbl %al,%edx
  801493:	8b 45 0c             	mov    0xc(%ebp),%eax
  801496:	8a 00                	mov    (%eax),%al
  801498:	0f b6 c0             	movzbl %al,%eax
  80149b:	29 c2                	sub    %eax,%edx
  80149d:	89 d0                	mov    %edx,%eax
}
  80149f:	5d                   	pop    %ebp
  8014a0:	c3                   	ret    

008014a1 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8014a1:	55                   	push   %ebp
  8014a2:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8014a4:	eb 09                	jmp    8014af <strncmp+0xe>
		n--, p++, q++;
  8014a6:	ff 4d 10             	decl   0x10(%ebp)
  8014a9:	ff 45 08             	incl   0x8(%ebp)
  8014ac:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8014af:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014b3:	74 17                	je     8014cc <strncmp+0x2b>
  8014b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b8:	8a 00                	mov    (%eax),%al
  8014ba:	84 c0                	test   %al,%al
  8014bc:	74 0e                	je     8014cc <strncmp+0x2b>
  8014be:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c1:	8a 10                	mov    (%eax),%dl
  8014c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c6:	8a 00                	mov    (%eax),%al
  8014c8:	38 c2                	cmp    %al,%dl
  8014ca:	74 da                	je     8014a6 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8014cc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014d0:	75 07                	jne    8014d9 <strncmp+0x38>
		return 0;
  8014d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8014d7:	eb 14                	jmp    8014ed <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8014d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014dc:	8a 00                	mov    (%eax),%al
  8014de:	0f b6 d0             	movzbl %al,%edx
  8014e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e4:	8a 00                	mov    (%eax),%al
  8014e6:	0f b6 c0             	movzbl %al,%eax
  8014e9:	29 c2                	sub    %eax,%edx
  8014eb:	89 d0                	mov    %edx,%eax
}
  8014ed:	5d                   	pop    %ebp
  8014ee:	c3                   	ret    

008014ef <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8014ef:	55                   	push   %ebp
  8014f0:	89 e5                	mov    %esp,%ebp
  8014f2:	83 ec 04             	sub    $0x4,%esp
  8014f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8014fb:	eb 12                	jmp    80150f <strchr+0x20>
		if (*s == c)
  8014fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801500:	8a 00                	mov    (%eax),%al
  801502:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801505:	75 05                	jne    80150c <strchr+0x1d>
			return (char *) s;
  801507:	8b 45 08             	mov    0x8(%ebp),%eax
  80150a:	eb 11                	jmp    80151d <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80150c:	ff 45 08             	incl   0x8(%ebp)
  80150f:	8b 45 08             	mov    0x8(%ebp),%eax
  801512:	8a 00                	mov    (%eax),%al
  801514:	84 c0                	test   %al,%al
  801516:	75 e5                	jne    8014fd <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801518:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80151d:	c9                   	leave  
  80151e:	c3                   	ret    

0080151f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80151f:	55                   	push   %ebp
  801520:	89 e5                	mov    %esp,%ebp
  801522:	83 ec 04             	sub    $0x4,%esp
  801525:	8b 45 0c             	mov    0xc(%ebp),%eax
  801528:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80152b:	eb 0d                	jmp    80153a <strfind+0x1b>
		if (*s == c)
  80152d:	8b 45 08             	mov    0x8(%ebp),%eax
  801530:	8a 00                	mov    (%eax),%al
  801532:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801535:	74 0e                	je     801545 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801537:	ff 45 08             	incl   0x8(%ebp)
  80153a:	8b 45 08             	mov    0x8(%ebp),%eax
  80153d:	8a 00                	mov    (%eax),%al
  80153f:	84 c0                	test   %al,%al
  801541:	75 ea                	jne    80152d <strfind+0xe>
  801543:	eb 01                	jmp    801546 <strfind+0x27>
		if (*s == c)
			break;
  801545:	90                   	nop
	return (char *) s;
  801546:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801549:	c9                   	leave  
  80154a:	c3                   	ret    

0080154b <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80154b:	55                   	push   %ebp
  80154c:	89 e5                	mov    %esp,%ebp
  80154e:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801551:	8b 45 08             	mov    0x8(%ebp),%eax
  801554:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801557:	8b 45 10             	mov    0x10(%ebp),%eax
  80155a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80155d:	eb 0e                	jmp    80156d <memset+0x22>
		*p++ = c;
  80155f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801562:	8d 50 01             	lea    0x1(%eax),%edx
  801565:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801568:	8b 55 0c             	mov    0xc(%ebp),%edx
  80156b:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80156d:	ff 4d f8             	decl   -0x8(%ebp)
  801570:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801574:	79 e9                	jns    80155f <memset+0x14>
		*p++ = c;

	return v;
  801576:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801579:	c9                   	leave  
  80157a:	c3                   	ret    

0080157b <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80157b:	55                   	push   %ebp
  80157c:	89 e5                	mov    %esp,%ebp
  80157e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801581:	8b 45 0c             	mov    0xc(%ebp),%eax
  801584:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801587:	8b 45 08             	mov    0x8(%ebp),%eax
  80158a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80158d:	eb 16                	jmp    8015a5 <memcpy+0x2a>
		*d++ = *s++;
  80158f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801592:	8d 50 01             	lea    0x1(%eax),%edx
  801595:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801598:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80159b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80159e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8015a1:	8a 12                	mov    (%edx),%dl
  8015a3:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8015a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8015a8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015ab:	89 55 10             	mov    %edx,0x10(%ebp)
  8015ae:	85 c0                	test   %eax,%eax
  8015b0:	75 dd                	jne    80158f <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8015b2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015b5:	c9                   	leave  
  8015b6:	c3                   	ret    

008015b7 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8015b7:	55                   	push   %ebp
  8015b8:	89 e5                	mov    %esp,%ebp
  8015ba:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8015bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8015c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8015c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015cc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8015cf:	73 50                	jae    801621 <memmove+0x6a>
  8015d1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8015d7:	01 d0                	add    %edx,%eax
  8015d9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8015dc:	76 43                	jbe    801621 <memmove+0x6a>
		s += n;
  8015de:	8b 45 10             	mov    0x10(%ebp),%eax
  8015e1:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8015e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8015e7:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8015ea:	eb 10                	jmp    8015fc <memmove+0x45>
			*--d = *--s;
  8015ec:	ff 4d f8             	decl   -0x8(%ebp)
  8015ef:	ff 4d fc             	decl   -0x4(%ebp)
  8015f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015f5:	8a 10                	mov    (%eax),%dl
  8015f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015fa:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8015fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ff:	8d 50 ff             	lea    -0x1(%eax),%edx
  801602:	89 55 10             	mov    %edx,0x10(%ebp)
  801605:	85 c0                	test   %eax,%eax
  801607:	75 e3                	jne    8015ec <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801609:	eb 23                	jmp    80162e <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80160b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80160e:	8d 50 01             	lea    0x1(%eax),%edx
  801611:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801614:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801617:	8d 4a 01             	lea    0x1(%edx),%ecx
  80161a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80161d:	8a 12                	mov    (%edx),%dl
  80161f:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801621:	8b 45 10             	mov    0x10(%ebp),%eax
  801624:	8d 50 ff             	lea    -0x1(%eax),%edx
  801627:	89 55 10             	mov    %edx,0x10(%ebp)
  80162a:	85 c0                	test   %eax,%eax
  80162c:	75 dd                	jne    80160b <memmove+0x54>
			*d++ = *s++;

	return dst;
  80162e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801631:	c9                   	leave  
  801632:	c3                   	ret    

00801633 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801633:	55                   	push   %ebp
  801634:	89 e5                	mov    %esp,%ebp
  801636:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801639:	8b 45 08             	mov    0x8(%ebp),%eax
  80163c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80163f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801642:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801645:	eb 2a                	jmp    801671 <memcmp+0x3e>
		if (*s1 != *s2)
  801647:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80164a:	8a 10                	mov    (%eax),%dl
  80164c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80164f:	8a 00                	mov    (%eax),%al
  801651:	38 c2                	cmp    %al,%dl
  801653:	74 16                	je     80166b <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801655:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801658:	8a 00                	mov    (%eax),%al
  80165a:	0f b6 d0             	movzbl %al,%edx
  80165d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801660:	8a 00                	mov    (%eax),%al
  801662:	0f b6 c0             	movzbl %al,%eax
  801665:	29 c2                	sub    %eax,%edx
  801667:	89 d0                	mov    %edx,%eax
  801669:	eb 18                	jmp    801683 <memcmp+0x50>
		s1++, s2++;
  80166b:	ff 45 fc             	incl   -0x4(%ebp)
  80166e:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801671:	8b 45 10             	mov    0x10(%ebp),%eax
  801674:	8d 50 ff             	lea    -0x1(%eax),%edx
  801677:	89 55 10             	mov    %edx,0x10(%ebp)
  80167a:	85 c0                	test   %eax,%eax
  80167c:	75 c9                	jne    801647 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80167e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801683:	c9                   	leave  
  801684:	c3                   	ret    

00801685 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801685:	55                   	push   %ebp
  801686:	89 e5                	mov    %esp,%ebp
  801688:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80168b:	8b 55 08             	mov    0x8(%ebp),%edx
  80168e:	8b 45 10             	mov    0x10(%ebp),%eax
  801691:	01 d0                	add    %edx,%eax
  801693:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801696:	eb 15                	jmp    8016ad <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801698:	8b 45 08             	mov    0x8(%ebp),%eax
  80169b:	8a 00                	mov    (%eax),%al
  80169d:	0f b6 d0             	movzbl %al,%edx
  8016a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a3:	0f b6 c0             	movzbl %al,%eax
  8016a6:	39 c2                	cmp    %eax,%edx
  8016a8:	74 0d                	je     8016b7 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8016aa:	ff 45 08             	incl   0x8(%ebp)
  8016ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8016b3:	72 e3                	jb     801698 <memfind+0x13>
  8016b5:	eb 01                	jmp    8016b8 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8016b7:	90                   	nop
	return (void *) s;
  8016b8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016bb:	c9                   	leave  
  8016bc:	c3                   	ret    

008016bd <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8016bd:	55                   	push   %ebp
  8016be:	89 e5                	mov    %esp,%ebp
  8016c0:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8016c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8016ca:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016d1:	eb 03                	jmp    8016d6 <strtol+0x19>
		s++;
  8016d3:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d9:	8a 00                	mov    (%eax),%al
  8016db:	3c 20                	cmp    $0x20,%al
  8016dd:	74 f4                	je     8016d3 <strtol+0x16>
  8016df:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e2:	8a 00                	mov    (%eax),%al
  8016e4:	3c 09                	cmp    $0x9,%al
  8016e6:	74 eb                	je     8016d3 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8016e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016eb:	8a 00                	mov    (%eax),%al
  8016ed:	3c 2b                	cmp    $0x2b,%al
  8016ef:	75 05                	jne    8016f6 <strtol+0x39>
		s++;
  8016f1:	ff 45 08             	incl   0x8(%ebp)
  8016f4:	eb 13                	jmp    801709 <strtol+0x4c>
	else if (*s == '-')
  8016f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f9:	8a 00                	mov    (%eax),%al
  8016fb:	3c 2d                	cmp    $0x2d,%al
  8016fd:	75 0a                	jne    801709 <strtol+0x4c>
		s++, neg = 1;
  8016ff:	ff 45 08             	incl   0x8(%ebp)
  801702:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801709:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80170d:	74 06                	je     801715 <strtol+0x58>
  80170f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801713:	75 20                	jne    801735 <strtol+0x78>
  801715:	8b 45 08             	mov    0x8(%ebp),%eax
  801718:	8a 00                	mov    (%eax),%al
  80171a:	3c 30                	cmp    $0x30,%al
  80171c:	75 17                	jne    801735 <strtol+0x78>
  80171e:	8b 45 08             	mov    0x8(%ebp),%eax
  801721:	40                   	inc    %eax
  801722:	8a 00                	mov    (%eax),%al
  801724:	3c 78                	cmp    $0x78,%al
  801726:	75 0d                	jne    801735 <strtol+0x78>
		s += 2, base = 16;
  801728:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80172c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801733:	eb 28                	jmp    80175d <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801735:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801739:	75 15                	jne    801750 <strtol+0x93>
  80173b:	8b 45 08             	mov    0x8(%ebp),%eax
  80173e:	8a 00                	mov    (%eax),%al
  801740:	3c 30                	cmp    $0x30,%al
  801742:	75 0c                	jne    801750 <strtol+0x93>
		s++, base = 8;
  801744:	ff 45 08             	incl   0x8(%ebp)
  801747:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80174e:	eb 0d                	jmp    80175d <strtol+0xa0>
	else if (base == 0)
  801750:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801754:	75 07                	jne    80175d <strtol+0xa0>
		base = 10;
  801756:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80175d:	8b 45 08             	mov    0x8(%ebp),%eax
  801760:	8a 00                	mov    (%eax),%al
  801762:	3c 2f                	cmp    $0x2f,%al
  801764:	7e 19                	jle    80177f <strtol+0xc2>
  801766:	8b 45 08             	mov    0x8(%ebp),%eax
  801769:	8a 00                	mov    (%eax),%al
  80176b:	3c 39                	cmp    $0x39,%al
  80176d:	7f 10                	jg     80177f <strtol+0xc2>
			dig = *s - '0';
  80176f:	8b 45 08             	mov    0x8(%ebp),%eax
  801772:	8a 00                	mov    (%eax),%al
  801774:	0f be c0             	movsbl %al,%eax
  801777:	83 e8 30             	sub    $0x30,%eax
  80177a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80177d:	eb 42                	jmp    8017c1 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80177f:	8b 45 08             	mov    0x8(%ebp),%eax
  801782:	8a 00                	mov    (%eax),%al
  801784:	3c 60                	cmp    $0x60,%al
  801786:	7e 19                	jle    8017a1 <strtol+0xe4>
  801788:	8b 45 08             	mov    0x8(%ebp),%eax
  80178b:	8a 00                	mov    (%eax),%al
  80178d:	3c 7a                	cmp    $0x7a,%al
  80178f:	7f 10                	jg     8017a1 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801791:	8b 45 08             	mov    0x8(%ebp),%eax
  801794:	8a 00                	mov    (%eax),%al
  801796:	0f be c0             	movsbl %al,%eax
  801799:	83 e8 57             	sub    $0x57,%eax
  80179c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80179f:	eb 20                	jmp    8017c1 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8017a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a4:	8a 00                	mov    (%eax),%al
  8017a6:	3c 40                	cmp    $0x40,%al
  8017a8:	7e 39                	jle    8017e3 <strtol+0x126>
  8017aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ad:	8a 00                	mov    (%eax),%al
  8017af:	3c 5a                	cmp    $0x5a,%al
  8017b1:	7f 30                	jg     8017e3 <strtol+0x126>
			dig = *s - 'A' + 10;
  8017b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b6:	8a 00                	mov    (%eax),%al
  8017b8:	0f be c0             	movsbl %al,%eax
  8017bb:	83 e8 37             	sub    $0x37,%eax
  8017be:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8017c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017c4:	3b 45 10             	cmp    0x10(%ebp),%eax
  8017c7:	7d 19                	jge    8017e2 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8017c9:	ff 45 08             	incl   0x8(%ebp)
  8017cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017cf:	0f af 45 10          	imul   0x10(%ebp),%eax
  8017d3:	89 c2                	mov    %eax,%edx
  8017d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017d8:	01 d0                	add    %edx,%eax
  8017da:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8017dd:	e9 7b ff ff ff       	jmp    80175d <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8017e2:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8017e3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8017e7:	74 08                	je     8017f1 <strtol+0x134>
		*endptr = (char *) s;
  8017e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8017ef:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8017f1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8017f5:	74 07                	je     8017fe <strtol+0x141>
  8017f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017fa:	f7 d8                	neg    %eax
  8017fc:	eb 03                	jmp    801801 <strtol+0x144>
  8017fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801801:	c9                   	leave  
  801802:	c3                   	ret    

00801803 <ltostr>:

void
ltostr(long value, char *str)
{
  801803:	55                   	push   %ebp
  801804:	89 e5                	mov    %esp,%ebp
  801806:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801809:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801810:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801817:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80181b:	79 13                	jns    801830 <ltostr+0x2d>
	{
		neg = 1;
  80181d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801824:	8b 45 0c             	mov    0xc(%ebp),%eax
  801827:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80182a:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80182d:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801830:	8b 45 08             	mov    0x8(%ebp),%eax
  801833:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801838:	99                   	cltd   
  801839:	f7 f9                	idiv   %ecx
  80183b:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80183e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801841:	8d 50 01             	lea    0x1(%eax),%edx
  801844:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801847:	89 c2                	mov    %eax,%edx
  801849:	8b 45 0c             	mov    0xc(%ebp),%eax
  80184c:	01 d0                	add    %edx,%eax
  80184e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801851:	83 c2 30             	add    $0x30,%edx
  801854:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801856:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801859:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80185e:	f7 e9                	imul   %ecx
  801860:	c1 fa 02             	sar    $0x2,%edx
  801863:	89 c8                	mov    %ecx,%eax
  801865:	c1 f8 1f             	sar    $0x1f,%eax
  801868:	29 c2                	sub    %eax,%edx
  80186a:	89 d0                	mov    %edx,%eax
  80186c:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80186f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801872:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801877:	f7 e9                	imul   %ecx
  801879:	c1 fa 02             	sar    $0x2,%edx
  80187c:	89 c8                	mov    %ecx,%eax
  80187e:	c1 f8 1f             	sar    $0x1f,%eax
  801881:	29 c2                	sub    %eax,%edx
  801883:	89 d0                	mov    %edx,%eax
  801885:	c1 e0 02             	shl    $0x2,%eax
  801888:	01 d0                	add    %edx,%eax
  80188a:	01 c0                	add    %eax,%eax
  80188c:	29 c1                	sub    %eax,%ecx
  80188e:	89 ca                	mov    %ecx,%edx
  801890:	85 d2                	test   %edx,%edx
  801892:	75 9c                	jne    801830 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801894:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80189b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80189e:	48                   	dec    %eax
  80189f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8018a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018a6:	74 3d                	je     8018e5 <ltostr+0xe2>
		start = 1 ;
  8018a8:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8018af:	eb 34                	jmp    8018e5 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8018b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018b7:	01 d0                	add    %edx,%eax
  8018b9:	8a 00                	mov    (%eax),%al
  8018bb:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8018be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c4:	01 c2                	add    %eax,%edx
  8018c6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8018c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018cc:	01 c8                	add    %ecx,%eax
  8018ce:	8a 00                	mov    (%eax),%al
  8018d0:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8018d2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018d8:	01 c2                	add    %eax,%edx
  8018da:	8a 45 eb             	mov    -0x15(%ebp),%al
  8018dd:	88 02                	mov    %al,(%edx)
		start++ ;
  8018df:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8018e2:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8018e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018e8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8018eb:	7c c4                	jl     8018b1 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8018ed:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8018f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f3:	01 d0                	add    %edx,%eax
  8018f5:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8018f8:	90                   	nop
  8018f9:	c9                   	leave  
  8018fa:	c3                   	ret    

008018fb <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8018fb:	55                   	push   %ebp
  8018fc:	89 e5                	mov    %esp,%ebp
  8018fe:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801901:	ff 75 08             	pushl  0x8(%ebp)
  801904:	e8 54 fa ff ff       	call   80135d <strlen>
  801909:	83 c4 04             	add    $0x4,%esp
  80190c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80190f:	ff 75 0c             	pushl  0xc(%ebp)
  801912:	e8 46 fa ff ff       	call   80135d <strlen>
  801917:	83 c4 04             	add    $0x4,%esp
  80191a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80191d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801924:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80192b:	eb 17                	jmp    801944 <strcconcat+0x49>
		final[s] = str1[s] ;
  80192d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801930:	8b 45 10             	mov    0x10(%ebp),%eax
  801933:	01 c2                	add    %eax,%edx
  801935:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801938:	8b 45 08             	mov    0x8(%ebp),%eax
  80193b:	01 c8                	add    %ecx,%eax
  80193d:	8a 00                	mov    (%eax),%al
  80193f:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801941:	ff 45 fc             	incl   -0x4(%ebp)
  801944:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801947:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80194a:	7c e1                	jl     80192d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80194c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801953:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80195a:	eb 1f                	jmp    80197b <strcconcat+0x80>
		final[s++] = str2[i] ;
  80195c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80195f:	8d 50 01             	lea    0x1(%eax),%edx
  801962:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801965:	89 c2                	mov    %eax,%edx
  801967:	8b 45 10             	mov    0x10(%ebp),%eax
  80196a:	01 c2                	add    %eax,%edx
  80196c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80196f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801972:	01 c8                	add    %ecx,%eax
  801974:	8a 00                	mov    (%eax),%al
  801976:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801978:	ff 45 f8             	incl   -0x8(%ebp)
  80197b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80197e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801981:	7c d9                	jl     80195c <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801983:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801986:	8b 45 10             	mov    0x10(%ebp),%eax
  801989:	01 d0                	add    %edx,%eax
  80198b:	c6 00 00             	movb   $0x0,(%eax)
}
  80198e:	90                   	nop
  80198f:	c9                   	leave  
  801990:	c3                   	ret    

00801991 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801991:	55                   	push   %ebp
  801992:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801994:	8b 45 14             	mov    0x14(%ebp),%eax
  801997:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80199d:	8b 45 14             	mov    0x14(%ebp),%eax
  8019a0:	8b 00                	mov    (%eax),%eax
  8019a2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8019ac:	01 d0                	add    %edx,%eax
  8019ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8019b4:	eb 0c                	jmp    8019c2 <strsplit+0x31>
			*string++ = 0;
  8019b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b9:	8d 50 01             	lea    0x1(%eax),%edx
  8019bc:	89 55 08             	mov    %edx,0x8(%ebp)
  8019bf:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8019c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c5:	8a 00                	mov    (%eax),%al
  8019c7:	84 c0                	test   %al,%al
  8019c9:	74 18                	je     8019e3 <strsplit+0x52>
  8019cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ce:	8a 00                	mov    (%eax),%al
  8019d0:	0f be c0             	movsbl %al,%eax
  8019d3:	50                   	push   %eax
  8019d4:	ff 75 0c             	pushl  0xc(%ebp)
  8019d7:	e8 13 fb ff ff       	call   8014ef <strchr>
  8019dc:	83 c4 08             	add    $0x8,%esp
  8019df:	85 c0                	test   %eax,%eax
  8019e1:	75 d3                	jne    8019b6 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8019e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e6:	8a 00                	mov    (%eax),%al
  8019e8:	84 c0                	test   %al,%al
  8019ea:	74 5a                	je     801a46 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8019ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ef:	8b 00                	mov    (%eax),%eax
  8019f1:	83 f8 0f             	cmp    $0xf,%eax
  8019f4:	75 07                	jne    8019fd <strsplit+0x6c>
		{
			return 0;
  8019f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8019fb:	eb 66                	jmp    801a63 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8019fd:	8b 45 14             	mov    0x14(%ebp),%eax
  801a00:	8b 00                	mov    (%eax),%eax
  801a02:	8d 48 01             	lea    0x1(%eax),%ecx
  801a05:	8b 55 14             	mov    0x14(%ebp),%edx
  801a08:	89 0a                	mov    %ecx,(%edx)
  801a0a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a11:	8b 45 10             	mov    0x10(%ebp),%eax
  801a14:	01 c2                	add    %eax,%edx
  801a16:	8b 45 08             	mov    0x8(%ebp),%eax
  801a19:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a1b:	eb 03                	jmp    801a20 <strsplit+0x8f>
			string++;
  801a1d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a20:	8b 45 08             	mov    0x8(%ebp),%eax
  801a23:	8a 00                	mov    (%eax),%al
  801a25:	84 c0                	test   %al,%al
  801a27:	74 8b                	je     8019b4 <strsplit+0x23>
  801a29:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2c:	8a 00                	mov    (%eax),%al
  801a2e:	0f be c0             	movsbl %al,%eax
  801a31:	50                   	push   %eax
  801a32:	ff 75 0c             	pushl  0xc(%ebp)
  801a35:	e8 b5 fa ff ff       	call   8014ef <strchr>
  801a3a:	83 c4 08             	add    $0x8,%esp
  801a3d:	85 c0                	test   %eax,%eax
  801a3f:	74 dc                	je     801a1d <strsplit+0x8c>
			string++;
	}
  801a41:	e9 6e ff ff ff       	jmp    8019b4 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801a46:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801a47:	8b 45 14             	mov    0x14(%ebp),%eax
  801a4a:	8b 00                	mov    (%eax),%eax
  801a4c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a53:	8b 45 10             	mov    0x10(%ebp),%eax
  801a56:	01 d0                	add    %edx,%eax
  801a58:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801a5e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801a63:	c9                   	leave  
  801a64:	c3                   	ret    

00801a65 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801a65:	55                   	push   %ebp
  801a66:	89 e5                	mov    %esp,%ebp
  801a68:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801a6b:	a1 04 50 80 00       	mov    0x805004,%eax
  801a70:	85 c0                	test   %eax,%eax
  801a72:	74 1f                	je     801a93 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801a74:	e8 1d 00 00 00       	call   801a96 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801a79:	83 ec 0c             	sub    $0xc,%esp
  801a7c:	68 b0 40 80 00       	push   $0x8040b0
  801a81:	e8 55 f2 ff ff       	call   800cdb <cprintf>
  801a86:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801a89:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801a90:	00 00 00 
	}
}
  801a93:	90                   	nop
  801a94:	c9                   	leave  
  801a95:	c3                   	ret    

00801a96 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801a96:	55                   	push   %ebp
  801a97:	89 e5                	mov    %esp,%ebp
  801a99:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  801a9c:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801aa3:	00 00 00 
  801aa6:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801aad:	00 00 00 
  801ab0:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801ab7:	00 00 00 
		LIST_INIT(&AllocMemBlocksList);
  801aba:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801ac1:	00 00 00 
  801ac4:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801acb:	00 00 00 
  801ace:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801ad5:	00 00 00 

		MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES ;
  801ad8:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801adf:	00 02 00 
		MemBlockNodes =(struct MemBlock*)USER_DYN_BLKS_ARRAY ;
  801ae2:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aec:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801af1:	2d 00 10 00 00       	sub    $0x1000,%eax
  801af6:	a3 50 50 80 00       	mov    %eax,0x805050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock),PAGE_SIZE),PERM_USER|PERM_WRITEABLE);
  801afb:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801b02:	a1 20 51 80 00       	mov    0x805120,%eax
  801b07:	c1 e0 04             	shl    $0x4,%eax
  801b0a:	89 c2                	mov    %eax,%edx
  801b0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b0f:	01 d0                	add    %edx,%eax
  801b11:	48                   	dec    %eax
  801b12:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801b15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b18:	ba 00 00 00 00       	mov    $0x0,%edx
  801b1d:	f7 75 f0             	divl   -0x10(%ebp)
  801b20:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b23:	29 d0                	sub    %edx,%eax
  801b25:	89 c2                	mov    %eax,%edx
  801b27:	c7 45 e8 00 00 e0 7f 	movl   $0x7fe00000,-0x18(%ebp)
  801b2e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b31:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b36:	2d 00 10 00 00       	sub    $0x1000,%eax
  801b3b:	83 ec 04             	sub    $0x4,%esp
  801b3e:	6a 06                	push   $0x6
  801b40:	52                   	push   %edx
  801b41:	50                   	push   %eax
  801b42:	e8 71 05 00 00       	call   8020b8 <sys_allocate_chunk>
  801b47:	83 c4 10             	add    $0x10,%esp
		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801b4a:	a1 20 51 80 00       	mov    0x805120,%eax
  801b4f:	83 ec 0c             	sub    $0xc,%esp
  801b52:	50                   	push   %eax
  801b53:	e8 e6 0b 00 00       	call   80273e <initialize_MemBlocksList>
  801b58:	83 c4 10             	add    $0x10,%esp

		struct MemBlock  *block_node;
		block_node = AvailableMemBlocksList.lh_first;
  801b5b:	a1 48 51 80 00       	mov    0x805148,%eax
  801b60:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&(AvailableMemBlocksList),block_node);
  801b63:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801b67:	75 14                	jne    801b7d <initialize_dyn_block_system+0xe7>
  801b69:	83 ec 04             	sub    $0x4,%esp
  801b6c:	68 d5 40 80 00       	push   $0x8040d5
  801b71:	6a 2b                	push   $0x2b
  801b73:	68 f3 40 80 00       	push   $0x8040f3
  801b78:	e8 aa ee ff ff       	call   800a27 <_panic>
  801b7d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b80:	8b 00                	mov    (%eax),%eax
  801b82:	85 c0                	test   %eax,%eax
  801b84:	74 10                	je     801b96 <initialize_dyn_block_system+0x100>
  801b86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b89:	8b 00                	mov    (%eax),%eax
  801b8b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b8e:	8b 52 04             	mov    0x4(%edx),%edx
  801b91:	89 50 04             	mov    %edx,0x4(%eax)
  801b94:	eb 0b                	jmp    801ba1 <initialize_dyn_block_system+0x10b>
  801b96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b99:	8b 40 04             	mov    0x4(%eax),%eax
  801b9c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801ba1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ba4:	8b 40 04             	mov    0x4(%eax),%eax
  801ba7:	85 c0                	test   %eax,%eax
  801ba9:	74 0f                	je     801bba <initialize_dyn_block_system+0x124>
  801bab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bae:	8b 40 04             	mov    0x4(%eax),%eax
  801bb1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801bb4:	8b 12                	mov    (%edx),%edx
  801bb6:	89 10                	mov    %edx,(%eax)
  801bb8:	eb 0a                	jmp    801bc4 <initialize_dyn_block_system+0x12e>
  801bba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bbd:	8b 00                	mov    (%eax),%eax
  801bbf:	a3 48 51 80 00       	mov    %eax,0x805148
  801bc4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bc7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801bcd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bd0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801bd7:	a1 54 51 80 00       	mov    0x805154,%eax
  801bdc:	48                   	dec    %eax
  801bdd:	a3 54 51 80 00       	mov    %eax,0x805154
		block_node->sva = USER_HEAP_START ;
  801be2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801be5:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
		block_node->size = ((USER_HEAP_MAX - USER_HEAP_START));
  801bec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bef:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		insert_sorted_with_merge_freeList(block_node);
  801bf6:	83 ec 0c             	sub    $0xc,%esp
  801bf9:	ff 75 e4             	pushl  -0x1c(%ebp)
  801bfc:	e8 d2 13 00 00       	call   802fd3 <insert_sorted_with_merge_freeList>
  801c01:	83 c4 10             	add    $0x10,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801c04:	90                   	nop
  801c05:	c9                   	leave  
  801c06:	c3                   	ret    

00801c07 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801c07:	55                   	push   %ebp
  801c08:	89 e5                	mov    %esp,%ebp
  801c0a:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c0d:	e8 53 fe ff ff       	call   801a65 <InitializeUHeap>
	if (size == 0) return NULL ;
  801c12:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801c16:	75 07                	jne    801c1f <malloc+0x18>
  801c18:	b8 00 00 00 00       	mov    $0x0,%eax
  801c1d:	eb 61                	jmp    801c80 <malloc+0x79>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	size= ROUNDUP(size,PAGE_SIZE);
  801c1f:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801c26:	8b 55 08             	mov    0x8(%ebp),%edx
  801c29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c2c:	01 d0                	add    %edx,%eax
  801c2e:	48                   	dec    %eax
  801c2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801c32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c35:	ba 00 00 00 00       	mov    $0x0,%edx
  801c3a:	f7 75 f4             	divl   -0xc(%ebp)
  801c3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c40:	29 d0                	sub    %edx,%eax
  801c42:	89 45 08             	mov    %eax,0x8(%ebp)
	    			if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801c45:	e8 3c 08 00 00       	call   802486 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801c4a:	85 c0                	test   %eax,%eax
  801c4c:	74 2d                	je     801c7b <malloc+0x74>
	    			{
	    				struct MemBlock * ff_block = alloc_block_FF(size);
  801c4e:	83 ec 0c             	sub    $0xc,%esp
  801c51:	ff 75 08             	pushl  0x8(%ebp)
  801c54:	e8 3e 0f 00 00       	call   802b97 <alloc_block_FF>
  801c59:	83 c4 10             	add    $0x10,%esp
  801c5c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    				if(ff_block!=NULL)
  801c5f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801c63:	74 16                	je     801c7b <malloc+0x74>
	    				{

	    					insert_sorted_allocList(ff_block);
  801c65:	83 ec 0c             	sub    $0xc,%esp
  801c68:	ff 75 ec             	pushl  -0x14(%ebp)
  801c6b:	e8 48 0c 00 00       	call   8028b8 <insert_sorted_allocList>
  801c70:	83 c4 10             	add    $0x10,%esp
	    					return (void*) ff_block->sva ;
  801c73:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c76:	8b 40 08             	mov    0x8(%eax),%eax
  801c79:	eb 05                	jmp    801c80 <malloc+0x79>

	    				}
	}
	    			return (void*) NULL ;
  801c7b:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801c80:	c9                   	leave  
  801c81:	c3                   	ret    

00801c82 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801c82:	55                   	push   %ebp
  801c83:	89 e5                	mov    %esp,%ebp
  801c85:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock *elementForEach;
		virtual_address = ROUNDDOWN(virtual_address, PAGE_SIZE);
  801c88:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c91:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801c96:	89 45 08             	mov    %eax,0x8(%ebp)
	//	if (is_mallocPages[indexindex((uint32) virtual_address)] == 1) {
		elementForEach = find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801c99:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9c:	83 ec 08             	sub    $0x8,%esp
  801c9f:	50                   	push   %eax
  801ca0:	68 40 50 80 00       	push   $0x805040
  801ca5:	e8 71 0b 00 00       	call   80281b <find_block>
  801caa:	83 c4 10             	add    $0x10,%esp
  801cad:	89 45 f0             	mov    %eax,-0x10(%ebp)
		sys_free_user_mem((uint32) virtual_address, elementForEach->size);
  801cb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cb3:	8b 50 0c             	mov    0xc(%eax),%edx
  801cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb9:	83 ec 08             	sub    $0x8,%esp
  801cbc:	52                   	push   %edx
  801cbd:	50                   	push   %eax
  801cbe:	e8 bd 03 00 00       	call   802080 <sys_free_user_mem>
  801cc3:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,elementForEach);
  801cc6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801cca:	75 14                	jne    801ce0 <free+0x5e>
  801ccc:	83 ec 04             	sub    $0x4,%esp
  801ccf:	68 d5 40 80 00       	push   $0x8040d5
  801cd4:	6a 71                	push   $0x71
  801cd6:	68 f3 40 80 00       	push   $0x8040f3
  801cdb:	e8 47 ed ff ff       	call   800a27 <_panic>
  801ce0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ce3:	8b 00                	mov    (%eax),%eax
  801ce5:	85 c0                	test   %eax,%eax
  801ce7:	74 10                	je     801cf9 <free+0x77>
  801ce9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cec:	8b 00                	mov    (%eax),%eax
  801cee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801cf1:	8b 52 04             	mov    0x4(%edx),%edx
  801cf4:	89 50 04             	mov    %edx,0x4(%eax)
  801cf7:	eb 0b                	jmp    801d04 <free+0x82>
  801cf9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cfc:	8b 40 04             	mov    0x4(%eax),%eax
  801cff:	a3 44 50 80 00       	mov    %eax,0x805044
  801d04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d07:	8b 40 04             	mov    0x4(%eax),%eax
  801d0a:	85 c0                	test   %eax,%eax
  801d0c:	74 0f                	je     801d1d <free+0x9b>
  801d0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d11:	8b 40 04             	mov    0x4(%eax),%eax
  801d14:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d17:	8b 12                	mov    (%edx),%edx
  801d19:	89 10                	mov    %edx,(%eax)
  801d1b:	eb 0a                	jmp    801d27 <free+0xa5>
  801d1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d20:	8b 00                	mov    (%eax),%eax
  801d22:	a3 40 50 80 00       	mov    %eax,0x805040
  801d27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d2a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801d30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d33:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801d3a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801d3f:	48                   	dec    %eax
  801d40:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(elementForEach);
  801d45:	83 ec 0c             	sub    $0xc,%esp
  801d48:	ff 75 f0             	pushl  -0x10(%ebp)
  801d4b:	e8 83 12 00 00       	call   802fd3 <insert_sorted_with_merge_freeList>
  801d50:	83 c4 10             	add    $0x10,%esp
	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801d53:	90                   	nop
  801d54:	c9                   	leave  
  801d55:	c3                   	ret    

00801d56 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801d56:	55                   	push   %ebp
  801d57:	89 e5                	mov    %esp,%ebp
  801d59:	83 ec 28             	sub    $0x28,%esp
  801d5c:	8b 45 10             	mov    0x10(%ebp),%eax
  801d5f:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d62:	e8 fe fc ff ff       	call   801a65 <InitializeUHeap>
	if (size == 0) return NULL ;
  801d67:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d6b:	75 0a                	jne    801d77 <smalloc+0x21>
  801d6d:	b8 00 00 00 00       	mov    $0x0,%eax
  801d72:	e9 86 00 00 00       	jmp    801dfd <smalloc+0xa7>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code

	size=ROUNDUP(size,PAGE_SIZE);
  801d77:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801d7e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d84:	01 d0                	add    %edx,%eax
  801d86:	48                   	dec    %eax
  801d87:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d8d:	ba 00 00 00 00       	mov    $0x0,%edx
  801d92:	f7 75 f4             	divl   -0xc(%ebp)
  801d95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d98:	29 d0                	sub    %edx,%eax
  801d9a:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801d9d:	e8 e4 06 00 00       	call   802486 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801da2:	85 c0                	test   %eax,%eax
  801da4:	74 52                	je     801df8 <smalloc+0xa2>
		{
		struct MemBlock * ff_block ;
		ff_block = alloc_block_FF(size);
  801da6:	83 ec 0c             	sub    $0xc,%esp
  801da9:	ff 75 0c             	pushl  0xc(%ebp)
  801dac:	e8 e6 0d 00 00       	call   802b97 <alloc_block_FF>
  801db1:	83 c4 10             	add    $0x10,%esp
  801db4:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(ff_block==NULL)
  801db7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801dbb:	75 07                	jne    801dc4 <smalloc+0x6e>
			return NULL ;
  801dbd:	b8 00 00 00 00       	mov    $0x0,%eax
  801dc2:	eb 39                	jmp    801dfd <smalloc+0xa7>

		int obj_id =sys_createSharedObject(sharedVarName,size,isWritable,(void*)ff_block->sva);
  801dc4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dc7:	8b 40 08             	mov    0x8(%eax),%eax
  801dca:	89 c2                	mov    %eax,%edx
  801dcc:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801dd0:	52                   	push   %edx
  801dd1:	50                   	push   %eax
  801dd2:	ff 75 0c             	pushl  0xc(%ebp)
  801dd5:	ff 75 08             	pushl  0x8(%ebp)
  801dd8:	e8 2e 04 00 00       	call   80220b <sys_createSharedObject>
  801ddd:	83 c4 10             	add    $0x10,%esp
  801de0:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(obj_id < 0)
  801de3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801de7:	79 07                	jns    801df0 <smalloc+0x9a>
			return (void*)NULL ;
  801de9:	b8 00 00 00 00       	mov    $0x0,%eax
  801dee:	eb 0d                	jmp    801dfd <smalloc+0xa7>
		else
		    return (void*)ff_block->sva ;
  801df0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801df3:	8b 40 08             	mov    0x8(%eax),%eax
  801df6:	eb 05                	jmp    801dfd <smalloc+0xa7>
		}
		return (void*)NULL ;
  801df8:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801dfd:	c9                   	leave  
  801dfe:	c3                   	ret    

00801dff <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801dff:	55                   	push   %ebp
  801e00:	89 e5                	mov    %esp,%ebp
  801e02:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e05:	e8 5b fc ff ff       	call   801a65 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801e0a:	83 ec 08             	sub    $0x8,%esp
  801e0d:	ff 75 0c             	pushl  0xc(%ebp)
  801e10:	ff 75 08             	pushl  0x8(%ebp)
  801e13:	e8 1d 04 00 00       	call   802235 <sys_getSizeOfSharedObject>
  801e18:	83 c4 10             	add    $0x10,%esp
  801e1b:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(size == 0)
  801e1e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e22:	75 0a                	jne    801e2e <sget+0x2f>
			return NULL ;
  801e24:	b8 00 00 00 00       	mov    $0x0,%eax
  801e29:	e9 83 00 00 00       	jmp    801eb1 <sget+0xb2>
		size=ROUNDUP(size,PAGE_SIZE);
  801e2e:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801e35:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e3b:	01 d0                	add    %edx,%eax
  801e3d:	48                   	dec    %eax
  801e3e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801e41:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e44:	ba 00 00 00 00       	mov    $0x0,%edx
  801e49:	f7 75 f0             	divl   -0x10(%ebp)
  801e4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e4f:	29 d0                	sub    %edx,%eax
  801e51:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801e54:	e8 2d 06 00 00       	call   802486 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801e59:	85 c0                	test   %eax,%eax
  801e5b:	74 4f                	je     801eac <sget+0xad>
		{
			struct MemBlock * ff_block ;
				ff_block = alloc_block_FF(size);
  801e5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e60:	83 ec 0c             	sub    $0xc,%esp
  801e63:	50                   	push   %eax
  801e64:	e8 2e 0d 00 00       	call   802b97 <alloc_block_FF>
  801e69:	83 c4 10             	add    $0x10,%esp
  801e6c:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ff_block==NULL)
  801e6f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801e73:	75 07                	jne    801e7c <sget+0x7d>
					return (void*)NULL ;
  801e75:	b8 00 00 00 00       	mov    $0x0,%eax
  801e7a:	eb 35                	jmp    801eb1 <sget+0xb2>

		int obj_id =sys_getSharedObject((int)ownerEnvID,sharedVarName,(void*)ff_block->sva);
  801e7c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e7f:	8b 40 08             	mov    0x8(%eax),%eax
  801e82:	83 ec 04             	sub    $0x4,%esp
  801e85:	50                   	push   %eax
  801e86:	ff 75 0c             	pushl  0xc(%ebp)
  801e89:	ff 75 08             	pushl  0x8(%ebp)
  801e8c:	e8 c1 03 00 00       	call   802252 <sys_getSharedObject>
  801e91:	83 c4 10             	add    $0x10,%esp
  801e94:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if(obj_id<0)
  801e97:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801e9b:	79 07                	jns    801ea4 <sget+0xa5>
				return (void*)NULL ;
  801e9d:	b8 00 00 00 00       	mov    $0x0,%eax
  801ea2:	eb 0d                	jmp    801eb1 <sget+0xb2>
			else
				return (void*)ff_block->sva ;
  801ea4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ea7:	8b 40 08             	mov    0x8(%eax),%eax
  801eaa:	eb 05                	jmp    801eb1 <sget+0xb2>


		}
	return (void*)NULL ;
  801eac:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801eb1:	c9                   	leave  
  801eb2:	c3                   	ret    

00801eb3 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801eb3:	55                   	push   %ebp
  801eb4:	89 e5                	mov    %esp,%ebp
  801eb6:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801eb9:	e8 a7 fb ff ff       	call   801a65 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801ebe:	83 ec 04             	sub    $0x4,%esp
  801ec1:	68 00 41 80 00       	push   $0x804100
  801ec6:	68 f9 00 00 00       	push   $0xf9
  801ecb:	68 f3 40 80 00       	push   $0x8040f3
  801ed0:	e8 52 eb ff ff       	call   800a27 <_panic>

00801ed5 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801ed5:	55                   	push   %ebp
  801ed6:	89 e5                	mov    %esp,%ebp
  801ed8:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801edb:	83 ec 04             	sub    $0x4,%esp
  801ede:	68 28 41 80 00       	push   $0x804128
  801ee3:	68 0d 01 00 00       	push   $0x10d
  801ee8:	68 f3 40 80 00       	push   $0x8040f3
  801eed:	e8 35 eb ff ff       	call   800a27 <_panic>

00801ef2 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801ef2:	55                   	push   %ebp
  801ef3:	89 e5                	mov    %esp,%ebp
  801ef5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ef8:	83 ec 04             	sub    $0x4,%esp
  801efb:	68 4c 41 80 00       	push   $0x80414c
  801f00:	68 18 01 00 00       	push   $0x118
  801f05:	68 f3 40 80 00       	push   $0x8040f3
  801f0a:	e8 18 eb ff ff       	call   800a27 <_panic>

00801f0f <shrink>:

}
void shrink(uint32 newSize)
{
  801f0f:	55                   	push   %ebp
  801f10:	89 e5                	mov    %esp,%ebp
  801f12:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801f15:	83 ec 04             	sub    $0x4,%esp
  801f18:	68 4c 41 80 00       	push   $0x80414c
  801f1d:	68 1d 01 00 00       	push   $0x11d
  801f22:	68 f3 40 80 00       	push   $0x8040f3
  801f27:	e8 fb ea ff ff       	call   800a27 <_panic>

00801f2c <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801f2c:	55                   	push   %ebp
  801f2d:	89 e5                	mov    %esp,%ebp
  801f2f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801f32:	83 ec 04             	sub    $0x4,%esp
  801f35:	68 4c 41 80 00       	push   $0x80414c
  801f3a:	68 22 01 00 00       	push   $0x122
  801f3f:	68 f3 40 80 00       	push   $0x8040f3
  801f44:	e8 de ea ff ff       	call   800a27 <_panic>

00801f49 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801f49:	55                   	push   %ebp
  801f4a:	89 e5                	mov    %esp,%ebp
  801f4c:	57                   	push   %edi
  801f4d:	56                   	push   %esi
  801f4e:	53                   	push   %ebx
  801f4f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801f52:	8b 45 08             	mov    0x8(%ebp),%eax
  801f55:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f58:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f5b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f5e:	8b 7d 18             	mov    0x18(%ebp),%edi
  801f61:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801f64:	cd 30                	int    $0x30
  801f66:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801f69:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801f6c:	83 c4 10             	add    $0x10,%esp
  801f6f:	5b                   	pop    %ebx
  801f70:	5e                   	pop    %esi
  801f71:	5f                   	pop    %edi
  801f72:	5d                   	pop    %ebp
  801f73:	c3                   	ret    

00801f74 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801f74:	55                   	push   %ebp
  801f75:	89 e5                	mov    %esp,%ebp
  801f77:	83 ec 04             	sub    $0x4,%esp
  801f7a:	8b 45 10             	mov    0x10(%ebp),%eax
  801f7d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801f80:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f84:	8b 45 08             	mov    0x8(%ebp),%eax
  801f87:	6a 00                	push   $0x0
  801f89:	6a 00                	push   $0x0
  801f8b:	52                   	push   %edx
  801f8c:	ff 75 0c             	pushl  0xc(%ebp)
  801f8f:	50                   	push   %eax
  801f90:	6a 00                	push   $0x0
  801f92:	e8 b2 ff ff ff       	call   801f49 <syscall>
  801f97:	83 c4 18             	add    $0x18,%esp
}
  801f9a:	90                   	nop
  801f9b:	c9                   	leave  
  801f9c:	c3                   	ret    

00801f9d <sys_cgetc>:

int
sys_cgetc(void)
{
  801f9d:	55                   	push   %ebp
  801f9e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801fa0:	6a 00                	push   $0x0
  801fa2:	6a 00                	push   $0x0
  801fa4:	6a 00                	push   $0x0
  801fa6:	6a 00                	push   $0x0
  801fa8:	6a 00                	push   $0x0
  801faa:	6a 01                	push   $0x1
  801fac:	e8 98 ff ff ff       	call   801f49 <syscall>
  801fb1:	83 c4 18             	add    $0x18,%esp
}
  801fb4:	c9                   	leave  
  801fb5:	c3                   	ret    

00801fb6 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801fb6:	55                   	push   %ebp
  801fb7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801fb9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbf:	6a 00                	push   $0x0
  801fc1:	6a 00                	push   $0x0
  801fc3:	6a 00                	push   $0x0
  801fc5:	52                   	push   %edx
  801fc6:	50                   	push   %eax
  801fc7:	6a 05                	push   $0x5
  801fc9:	e8 7b ff ff ff       	call   801f49 <syscall>
  801fce:	83 c4 18             	add    $0x18,%esp
}
  801fd1:	c9                   	leave  
  801fd2:	c3                   	ret    

00801fd3 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801fd3:	55                   	push   %ebp
  801fd4:	89 e5                	mov    %esp,%ebp
  801fd6:	56                   	push   %esi
  801fd7:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801fd8:	8b 75 18             	mov    0x18(%ebp),%esi
  801fdb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801fde:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fe1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe7:	56                   	push   %esi
  801fe8:	53                   	push   %ebx
  801fe9:	51                   	push   %ecx
  801fea:	52                   	push   %edx
  801feb:	50                   	push   %eax
  801fec:	6a 06                	push   $0x6
  801fee:	e8 56 ff ff ff       	call   801f49 <syscall>
  801ff3:	83 c4 18             	add    $0x18,%esp
}
  801ff6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ff9:	5b                   	pop    %ebx
  801ffa:	5e                   	pop    %esi
  801ffb:	5d                   	pop    %ebp
  801ffc:	c3                   	ret    

00801ffd <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801ffd:	55                   	push   %ebp
  801ffe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802000:	8b 55 0c             	mov    0xc(%ebp),%edx
  802003:	8b 45 08             	mov    0x8(%ebp),%eax
  802006:	6a 00                	push   $0x0
  802008:	6a 00                	push   $0x0
  80200a:	6a 00                	push   $0x0
  80200c:	52                   	push   %edx
  80200d:	50                   	push   %eax
  80200e:	6a 07                	push   $0x7
  802010:	e8 34 ff ff ff       	call   801f49 <syscall>
  802015:	83 c4 18             	add    $0x18,%esp
}
  802018:	c9                   	leave  
  802019:	c3                   	ret    

0080201a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80201a:	55                   	push   %ebp
  80201b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80201d:	6a 00                	push   $0x0
  80201f:	6a 00                	push   $0x0
  802021:	6a 00                	push   $0x0
  802023:	ff 75 0c             	pushl  0xc(%ebp)
  802026:	ff 75 08             	pushl  0x8(%ebp)
  802029:	6a 08                	push   $0x8
  80202b:	e8 19 ff ff ff       	call   801f49 <syscall>
  802030:	83 c4 18             	add    $0x18,%esp
}
  802033:	c9                   	leave  
  802034:	c3                   	ret    

00802035 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802035:	55                   	push   %ebp
  802036:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802038:	6a 00                	push   $0x0
  80203a:	6a 00                	push   $0x0
  80203c:	6a 00                	push   $0x0
  80203e:	6a 00                	push   $0x0
  802040:	6a 00                	push   $0x0
  802042:	6a 09                	push   $0x9
  802044:	e8 00 ff ff ff       	call   801f49 <syscall>
  802049:	83 c4 18             	add    $0x18,%esp
}
  80204c:	c9                   	leave  
  80204d:	c3                   	ret    

0080204e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80204e:	55                   	push   %ebp
  80204f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802051:	6a 00                	push   $0x0
  802053:	6a 00                	push   $0x0
  802055:	6a 00                	push   $0x0
  802057:	6a 00                	push   $0x0
  802059:	6a 00                	push   $0x0
  80205b:	6a 0a                	push   $0xa
  80205d:	e8 e7 fe ff ff       	call   801f49 <syscall>
  802062:	83 c4 18             	add    $0x18,%esp
}
  802065:	c9                   	leave  
  802066:	c3                   	ret    

00802067 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802067:	55                   	push   %ebp
  802068:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80206a:	6a 00                	push   $0x0
  80206c:	6a 00                	push   $0x0
  80206e:	6a 00                	push   $0x0
  802070:	6a 00                	push   $0x0
  802072:	6a 00                	push   $0x0
  802074:	6a 0b                	push   $0xb
  802076:	e8 ce fe ff ff       	call   801f49 <syscall>
  80207b:	83 c4 18             	add    $0x18,%esp
}
  80207e:	c9                   	leave  
  80207f:	c3                   	ret    

00802080 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802080:	55                   	push   %ebp
  802081:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802083:	6a 00                	push   $0x0
  802085:	6a 00                	push   $0x0
  802087:	6a 00                	push   $0x0
  802089:	ff 75 0c             	pushl  0xc(%ebp)
  80208c:	ff 75 08             	pushl  0x8(%ebp)
  80208f:	6a 0f                	push   $0xf
  802091:	e8 b3 fe ff ff       	call   801f49 <syscall>
  802096:	83 c4 18             	add    $0x18,%esp
	return;
  802099:	90                   	nop
}
  80209a:	c9                   	leave  
  80209b:	c3                   	ret    

0080209c <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80209c:	55                   	push   %ebp
  80209d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80209f:	6a 00                	push   $0x0
  8020a1:	6a 00                	push   $0x0
  8020a3:	6a 00                	push   $0x0
  8020a5:	ff 75 0c             	pushl  0xc(%ebp)
  8020a8:	ff 75 08             	pushl  0x8(%ebp)
  8020ab:	6a 10                	push   $0x10
  8020ad:	e8 97 fe ff ff       	call   801f49 <syscall>
  8020b2:	83 c4 18             	add    $0x18,%esp
	return ;
  8020b5:	90                   	nop
}
  8020b6:	c9                   	leave  
  8020b7:	c3                   	ret    

008020b8 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8020b8:	55                   	push   %ebp
  8020b9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8020bb:	6a 00                	push   $0x0
  8020bd:	6a 00                	push   $0x0
  8020bf:	ff 75 10             	pushl  0x10(%ebp)
  8020c2:	ff 75 0c             	pushl  0xc(%ebp)
  8020c5:	ff 75 08             	pushl  0x8(%ebp)
  8020c8:	6a 11                	push   $0x11
  8020ca:	e8 7a fe ff ff       	call   801f49 <syscall>
  8020cf:	83 c4 18             	add    $0x18,%esp
	return ;
  8020d2:	90                   	nop
}
  8020d3:	c9                   	leave  
  8020d4:	c3                   	ret    

008020d5 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8020d5:	55                   	push   %ebp
  8020d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8020d8:	6a 00                	push   $0x0
  8020da:	6a 00                	push   $0x0
  8020dc:	6a 00                	push   $0x0
  8020de:	6a 00                	push   $0x0
  8020e0:	6a 00                	push   $0x0
  8020e2:	6a 0c                	push   $0xc
  8020e4:	e8 60 fe ff ff       	call   801f49 <syscall>
  8020e9:	83 c4 18             	add    $0x18,%esp
}
  8020ec:	c9                   	leave  
  8020ed:	c3                   	ret    

008020ee <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8020ee:	55                   	push   %ebp
  8020ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8020f1:	6a 00                	push   $0x0
  8020f3:	6a 00                	push   $0x0
  8020f5:	6a 00                	push   $0x0
  8020f7:	6a 00                	push   $0x0
  8020f9:	ff 75 08             	pushl  0x8(%ebp)
  8020fc:	6a 0d                	push   $0xd
  8020fe:	e8 46 fe ff ff       	call   801f49 <syscall>
  802103:	83 c4 18             	add    $0x18,%esp
}
  802106:	c9                   	leave  
  802107:	c3                   	ret    

00802108 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802108:	55                   	push   %ebp
  802109:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80210b:	6a 00                	push   $0x0
  80210d:	6a 00                	push   $0x0
  80210f:	6a 00                	push   $0x0
  802111:	6a 00                	push   $0x0
  802113:	6a 00                	push   $0x0
  802115:	6a 0e                	push   $0xe
  802117:	e8 2d fe ff ff       	call   801f49 <syscall>
  80211c:	83 c4 18             	add    $0x18,%esp
}
  80211f:	90                   	nop
  802120:	c9                   	leave  
  802121:	c3                   	ret    

00802122 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802122:	55                   	push   %ebp
  802123:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802125:	6a 00                	push   $0x0
  802127:	6a 00                	push   $0x0
  802129:	6a 00                	push   $0x0
  80212b:	6a 00                	push   $0x0
  80212d:	6a 00                	push   $0x0
  80212f:	6a 13                	push   $0x13
  802131:	e8 13 fe ff ff       	call   801f49 <syscall>
  802136:	83 c4 18             	add    $0x18,%esp
}
  802139:	90                   	nop
  80213a:	c9                   	leave  
  80213b:	c3                   	ret    

0080213c <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80213c:	55                   	push   %ebp
  80213d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80213f:	6a 00                	push   $0x0
  802141:	6a 00                	push   $0x0
  802143:	6a 00                	push   $0x0
  802145:	6a 00                	push   $0x0
  802147:	6a 00                	push   $0x0
  802149:	6a 14                	push   $0x14
  80214b:	e8 f9 fd ff ff       	call   801f49 <syscall>
  802150:	83 c4 18             	add    $0x18,%esp
}
  802153:	90                   	nop
  802154:	c9                   	leave  
  802155:	c3                   	ret    

00802156 <sys_cputc>:


void
sys_cputc(const char c)
{
  802156:	55                   	push   %ebp
  802157:	89 e5                	mov    %esp,%ebp
  802159:	83 ec 04             	sub    $0x4,%esp
  80215c:	8b 45 08             	mov    0x8(%ebp),%eax
  80215f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802162:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802166:	6a 00                	push   $0x0
  802168:	6a 00                	push   $0x0
  80216a:	6a 00                	push   $0x0
  80216c:	6a 00                	push   $0x0
  80216e:	50                   	push   %eax
  80216f:	6a 15                	push   $0x15
  802171:	e8 d3 fd ff ff       	call   801f49 <syscall>
  802176:	83 c4 18             	add    $0x18,%esp
}
  802179:	90                   	nop
  80217a:	c9                   	leave  
  80217b:	c3                   	ret    

0080217c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80217c:	55                   	push   %ebp
  80217d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80217f:	6a 00                	push   $0x0
  802181:	6a 00                	push   $0x0
  802183:	6a 00                	push   $0x0
  802185:	6a 00                	push   $0x0
  802187:	6a 00                	push   $0x0
  802189:	6a 16                	push   $0x16
  80218b:	e8 b9 fd ff ff       	call   801f49 <syscall>
  802190:	83 c4 18             	add    $0x18,%esp
}
  802193:	90                   	nop
  802194:	c9                   	leave  
  802195:	c3                   	ret    

00802196 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802196:	55                   	push   %ebp
  802197:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802199:	8b 45 08             	mov    0x8(%ebp),%eax
  80219c:	6a 00                	push   $0x0
  80219e:	6a 00                	push   $0x0
  8021a0:	6a 00                	push   $0x0
  8021a2:	ff 75 0c             	pushl  0xc(%ebp)
  8021a5:	50                   	push   %eax
  8021a6:	6a 17                	push   $0x17
  8021a8:	e8 9c fd ff ff       	call   801f49 <syscall>
  8021ad:	83 c4 18             	add    $0x18,%esp
}
  8021b0:	c9                   	leave  
  8021b1:	c3                   	ret    

008021b2 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8021b2:	55                   	push   %ebp
  8021b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8021b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bb:	6a 00                	push   $0x0
  8021bd:	6a 00                	push   $0x0
  8021bf:	6a 00                	push   $0x0
  8021c1:	52                   	push   %edx
  8021c2:	50                   	push   %eax
  8021c3:	6a 1a                	push   $0x1a
  8021c5:	e8 7f fd ff ff       	call   801f49 <syscall>
  8021ca:	83 c4 18             	add    $0x18,%esp
}
  8021cd:	c9                   	leave  
  8021ce:	c3                   	ret    

008021cf <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8021cf:	55                   	push   %ebp
  8021d0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8021d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d8:	6a 00                	push   $0x0
  8021da:	6a 00                	push   $0x0
  8021dc:	6a 00                	push   $0x0
  8021de:	52                   	push   %edx
  8021df:	50                   	push   %eax
  8021e0:	6a 18                	push   $0x18
  8021e2:	e8 62 fd ff ff       	call   801f49 <syscall>
  8021e7:	83 c4 18             	add    $0x18,%esp
}
  8021ea:	90                   	nop
  8021eb:	c9                   	leave  
  8021ec:	c3                   	ret    

008021ed <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8021ed:	55                   	push   %ebp
  8021ee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8021f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f6:	6a 00                	push   $0x0
  8021f8:	6a 00                	push   $0x0
  8021fa:	6a 00                	push   $0x0
  8021fc:	52                   	push   %edx
  8021fd:	50                   	push   %eax
  8021fe:	6a 19                	push   $0x19
  802200:	e8 44 fd ff ff       	call   801f49 <syscall>
  802205:	83 c4 18             	add    $0x18,%esp
}
  802208:	90                   	nop
  802209:	c9                   	leave  
  80220a:	c3                   	ret    

0080220b <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80220b:	55                   	push   %ebp
  80220c:	89 e5                	mov    %esp,%ebp
  80220e:	83 ec 04             	sub    $0x4,%esp
  802211:	8b 45 10             	mov    0x10(%ebp),%eax
  802214:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802217:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80221a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80221e:	8b 45 08             	mov    0x8(%ebp),%eax
  802221:	6a 00                	push   $0x0
  802223:	51                   	push   %ecx
  802224:	52                   	push   %edx
  802225:	ff 75 0c             	pushl  0xc(%ebp)
  802228:	50                   	push   %eax
  802229:	6a 1b                	push   $0x1b
  80222b:	e8 19 fd ff ff       	call   801f49 <syscall>
  802230:	83 c4 18             	add    $0x18,%esp
}
  802233:	c9                   	leave  
  802234:	c3                   	ret    

00802235 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802235:	55                   	push   %ebp
  802236:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802238:	8b 55 0c             	mov    0xc(%ebp),%edx
  80223b:	8b 45 08             	mov    0x8(%ebp),%eax
  80223e:	6a 00                	push   $0x0
  802240:	6a 00                	push   $0x0
  802242:	6a 00                	push   $0x0
  802244:	52                   	push   %edx
  802245:	50                   	push   %eax
  802246:	6a 1c                	push   $0x1c
  802248:	e8 fc fc ff ff       	call   801f49 <syscall>
  80224d:	83 c4 18             	add    $0x18,%esp
}
  802250:	c9                   	leave  
  802251:	c3                   	ret    

00802252 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802252:	55                   	push   %ebp
  802253:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802255:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802258:	8b 55 0c             	mov    0xc(%ebp),%edx
  80225b:	8b 45 08             	mov    0x8(%ebp),%eax
  80225e:	6a 00                	push   $0x0
  802260:	6a 00                	push   $0x0
  802262:	51                   	push   %ecx
  802263:	52                   	push   %edx
  802264:	50                   	push   %eax
  802265:	6a 1d                	push   $0x1d
  802267:	e8 dd fc ff ff       	call   801f49 <syscall>
  80226c:	83 c4 18             	add    $0x18,%esp
}
  80226f:	c9                   	leave  
  802270:	c3                   	ret    

00802271 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802271:	55                   	push   %ebp
  802272:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802274:	8b 55 0c             	mov    0xc(%ebp),%edx
  802277:	8b 45 08             	mov    0x8(%ebp),%eax
  80227a:	6a 00                	push   $0x0
  80227c:	6a 00                	push   $0x0
  80227e:	6a 00                	push   $0x0
  802280:	52                   	push   %edx
  802281:	50                   	push   %eax
  802282:	6a 1e                	push   $0x1e
  802284:	e8 c0 fc ff ff       	call   801f49 <syscall>
  802289:	83 c4 18             	add    $0x18,%esp
}
  80228c:	c9                   	leave  
  80228d:	c3                   	ret    

0080228e <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80228e:	55                   	push   %ebp
  80228f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802291:	6a 00                	push   $0x0
  802293:	6a 00                	push   $0x0
  802295:	6a 00                	push   $0x0
  802297:	6a 00                	push   $0x0
  802299:	6a 00                	push   $0x0
  80229b:	6a 1f                	push   $0x1f
  80229d:	e8 a7 fc ff ff       	call   801f49 <syscall>
  8022a2:	83 c4 18             	add    $0x18,%esp
}
  8022a5:	c9                   	leave  
  8022a6:	c3                   	ret    

008022a7 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8022a7:	55                   	push   %ebp
  8022a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8022aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ad:	6a 00                	push   $0x0
  8022af:	ff 75 14             	pushl  0x14(%ebp)
  8022b2:	ff 75 10             	pushl  0x10(%ebp)
  8022b5:	ff 75 0c             	pushl  0xc(%ebp)
  8022b8:	50                   	push   %eax
  8022b9:	6a 20                	push   $0x20
  8022bb:	e8 89 fc ff ff       	call   801f49 <syscall>
  8022c0:	83 c4 18             	add    $0x18,%esp
}
  8022c3:	c9                   	leave  
  8022c4:	c3                   	ret    

008022c5 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8022c5:	55                   	push   %ebp
  8022c6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8022c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cb:	6a 00                	push   $0x0
  8022cd:	6a 00                	push   $0x0
  8022cf:	6a 00                	push   $0x0
  8022d1:	6a 00                	push   $0x0
  8022d3:	50                   	push   %eax
  8022d4:	6a 21                	push   $0x21
  8022d6:	e8 6e fc ff ff       	call   801f49 <syscall>
  8022db:	83 c4 18             	add    $0x18,%esp
}
  8022de:	90                   	nop
  8022df:	c9                   	leave  
  8022e0:	c3                   	ret    

008022e1 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8022e1:	55                   	push   %ebp
  8022e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8022e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e7:	6a 00                	push   $0x0
  8022e9:	6a 00                	push   $0x0
  8022eb:	6a 00                	push   $0x0
  8022ed:	6a 00                	push   $0x0
  8022ef:	50                   	push   %eax
  8022f0:	6a 22                	push   $0x22
  8022f2:	e8 52 fc ff ff       	call   801f49 <syscall>
  8022f7:	83 c4 18             	add    $0x18,%esp
}
  8022fa:	c9                   	leave  
  8022fb:	c3                   	ret    

008022fc <sys_getenvid>:

int32 sys_getenvid(void)
{
  8022fc:	55                   	push   %ebp
  8022fd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8022ff:	6a 00                	push   $0x0
  802301:	6a 00                	push   $0x0
  802303:	6a 00                	push   $0x0
  802305:	6a 00                	push   $0x0
  802307:	6a 00                	push   $0x0
  802309:	6a 02                	push   $0x2
  80230b:	e8 39 fc ff ff       	call   801f49 <syscall>
  802310:	83 c4 18             	add    $0x18,%esp
}
  802313:	c9                   	leave  
  802314:	c3                   	ret    

00802315 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802315:	55                   	push   %ebp
  802316:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802318:	6a 00                	push   $0x0
  80231a:	6a 00                	push   $0x0
  80231c:	6a 00                	push   $0x0
  80231e:	6a 00                	push   $0x0
  802320:	6a 00                	push   $0x0
  802322:	6a 03                	push   $0x3
  802324:	e8 20 fc ff ff       	call   801f49 <syscall>
  802329:	83 c4 18             	add    $0x18,%esp
}
  80232c:	c9                   	leave  
  80232d:	c3                   	ret    

0080232e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80232e:	55                   	push   %ebp
  80232f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802331:	6a 00                	push   $0x0
  802333:	6a 00                	push   $0x0
  802335:	6a 00                	push   $0x0
  802337:	6a 00                	push   $0x0
  802339:	6a 00                	push   $0x0
  80233b:	6a 04                	push   $0x4
  80233d:	e8 07 fc ff ff       	call   801f49 <syscall>
  802342:	83 c4 18             	add    $0x18,%esp
}
  802345:	c9                   	leave  
  802346:	c3                   	ret    

00802347 <sys_exit_env>:


void sys_exit_env(void)
{
  802347:	55                   	push   %ebp
  802348:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80234a:	6a 00                	push   $0x0
  80234c:	6a 00                	push   $0x0
  80234e:	6a 00                	push   $0x0
  802350:	6a 00                	push   $0x0
  802352:	6a 00                	push   $0x0
  802354:	6a 23                	push   $0x23
  802356:	e8 ee fb ff ff       	call   801f49 <syscall>
  80235b:	83 c4 18             	add    $0x18,%esp
}
  80235e:	90                   	nop
  80235f:	c9                   	leave  
  802360:	c3                   	ret    

00802361 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802361:	55                   	push   %ebp
  802362:	89 e5                	mov    %esp,%ebp
  802364:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802367:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80236a:	8d 50 04             	lea    0x4(%eax),%edx
  80236d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802370:	6a 00                	push   $0x0
  802372:	6a 00                	push   $0x0
  802374:	6a 00                	push   $0x0
  802376:	52                   	push   %edx
  802377:	50                   	push   %eax
  802378:	6a 24                	push   $0x24
  80237a:	e8 ca fb ff ff       	call   801f49 <syscall>
  80237f:	83 c4 18             	add    $0x18,%esp
	return result;
  802382:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802385:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802388:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80238b:	89 01                	mov    %eax,(%ecx)
  80238d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802390:	8b 45 08             	mov    0x8(%ebp),%eax
  802393:	c9                   	leave  
  802394:	c2 04 00             	ret    $0x4

00802397 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802397:	55                   	push   %ebp
  802398:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80239a:	6a 00                	push   $0x0
  80239c:	6a 00                	push   $0x0
  80239e:	ff 75 10             	pushl  0x10(%ebp)
  8023a1:	ff 75 0c             	pushl  0xc(%ebp)
  8023a4:	ff 75 08             	pushl  0x8(%ebp)
  8023a7:	6a 12                	push   $0x12
  8023a9:	e8 9b fb ff ff       	call   801f49 <syscall>
  8023ae:	83 c4 18             	add    $0x18,%esp
	return ;
  8023b1:	90                   	nop
}
  8023b2:	c9                   	leave  
  8023b3:	c3                   	ret    

008023b4 <sys_rcr2>:
uint32 sys_rcr2()
{
  8023b4:	55                   	push   %ebp
  8023b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8023b7:	6a 00                	push   $0x0
  8023b9:	6a 00                	push   $0x0
  8023bb:	6a 00                	push   $0x0
  8023bd:	6a 00                	push   $0x0
  8023bf:	6a 00                	push   $0x0
  8023c1:	6a 25                	push   $0x25
  8023c3:	e8 81 fb ff ff       	call   801f49 <syscall>
  8023c8:	83 c4 18             	add    $0x18,%esp
}
  8023cb:	c9                   	leave  
  8023cc:	c3                   	ret    

008023cd <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8023cd:	55                   	push   %ebp
  8023ce:	89 e5                	mov    %esp,%ebp
  8023d0:	83 ec 04             	sub    $0x4,%esp
  8023d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8023d9:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8023dd:	6a 00                	push   $0x0
  8023df:	6a 00                	push   $0x0
  8023e1:	6a 00                	push   $0x0
  8023e3:	6a 00                	push   $0x0
  8023e5:	50                   	push   %eax
  8023e6:	6a 26                	push   $0x26
  8023e8:	e8 5c fb ff ff       	call   801f49 <syscall>
  8023ed:	83 c4 18             	add    $0x18,%esp
	return ;
  8023f0:	90                   	nop
}
  8023f1:	c9                   	leave  
  8023f2:	c3                   	ret    

008023f3 <rsttst>:
void rsttst()
{
  8023f3:	55                   	push   %ebp
  8023f4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8023f6:	6a 00                	push   $0x0
  8023f8:	6a 00                	push   $0x0
  8023fa:	6a 00                	push   $0x0
  8023fc:	6a 00                	push   $0x0
  8023fe:	6a 00                	push   $0x0
  802400:	6a 28                	push   $0x28
  802402:	e8 42 fb ff ff       	call   801f49 <syscall>
  802407:	83 c4 18             	add    $0x18,%esp
	return ;
  80240a:	90                   	nop
}
  80240b:	c9                   	leave  
  80240c:	c3                   	ret    

0080240d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80240d:	55                   	push   %ebp
  80240e:	89 e5                	mov    %esp,%ebp
  802410:	83 ec 04             	sub    $0x4,%esp
  802413:	8b 45 14             	mov    0x14(%ebp),%eax
  802416:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802419:	8b 55 18             	mov    0x18(%ebp),%edx
  80241c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802420:	52                   	push   %edx
  802421:	50                   	push   %eax
  802422:	ff 75 10             	pushl  0x10(%ebp)
  802425:	ff 75 0c             	pushl  0xc(%ebp)
  802428:	ff 75 08             	pushl  0x8(%ebp)
  80242b:	6a 27                	push   $0x27
  80242d:	e8 17 fb ff ff       	call   801f49 <syscall>
  802432:	83 c4 18             	add    $0x18,%esp
	return ;
  802435:	90                   	nop
}
  802436:	c9                   	leave  
  802437:	c3                   	ret    

00802438 <chktst>:
void chktst(uint32 n)
{
  802438:	55                   	push   %ebp
  802439:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80243b:	6a 00                	push   $0x0
  80243d:	6a 00                	push   $0x0
  80243f:	6a 00                	push   $0x0
  802441:	6a 00                	push   $0x0
  802443:	ff 75 08             	pushl  0x8(%ebp)
  802446:	6a 29                	push   $0x29
  802448:	e8 fc fa ff ff       	call   801f49 <syscall>
  80244d:	83 c4 18             	add    $0x18,%esp
	return ;
  802450:	90                   	nop
}
  802451:	c9                   	leave  
  802452:	c3                   	ret    

00802453 <inctst>:

void inctst()
{
  802453:	55                   	push   %ebp
  802454:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802456:	6a 00                	push   $0x0
  802458:	6a 00                	push   $0x0
  80245a:	6a 00                	push   $0x0
  80245c:	6a 00                	push   $0x0
  80245e:	6a 00                	push   $0x0
  802460:	6a 2a                	push   $0x2a
  802462:	e8 e2 fa ff ff       	call   801f49 <syscall>
  802467:	83 c4 18             	add    $0x18,%esp
	return ;
  80246a:	90                   	nop
}
  80246b:	c9                   	leave  
  80246c:	c3                   	ret    

0080246d <gettst>:
uint32 gettst()
{
  80246d:	55                   	push   %ebp
  80246e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802470:	6a 00                	push   $0x0
  802472:	6a 00                	push   $0x0
  802474:	6a 00                	push   $0x0
  802476:	6a 00                	push   $0x0
  802478:	6a 00                	push   $0x0
  80247a:	6a 2b                	push   $0x2b
  80247c:	e8 c8 fa ff ff       	call   801f49 <syscall>
  802481:	83 c4 18             	add    $0x18,%esp
}
  802484:	c9                   	leave  
  802485:	c3                   	ret    

00802486 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802486:	55                   	push   %ebp
  802487:	89 e5                	mov    %esp,%ebp
  802489:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80248c:	6a 00                	push   $0x0
  80248e:	6a 00                	push   $0x0
  802490:	6a 00                	push   $0x0
  802492:	6a 00                	push   $0x0
  802494:	6a 00                	push   $0x0
  802496:	6a 2c                	push   $0x2c
  802498:	e8 ac fa ff ff       	call   801f49 <syscall>
  80249d:	83 c4 18             	add    $0x18,%esp
  8024a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8024a3:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8024a7:	75 07                	jne    8024b0 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8024a9:	b8 01 00 00 00       	mov    $0x1,%eax
  8024ae:	eb 05                	jmp    8024b5 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8024b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024b5:	c9                   	leave  
  8024b6:	c3                   	ret    

008024b7 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8024b7:	55                   	push   %ebp
  8024b8:	89 e5                	mov    %esp,%ebp
  8024ba:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024bd:	6a 00                	push   $0x0
  8024bf:	6a 00                	push   $0x0
  8024c1:	6a 00                	push   $0x0
  8024c3:	6a 00                	push   $0x0
  8024c5:	6a 00                	push   $0x0
  8024c7:	6a 2c                	push   $0x2c
  8024c9:	e8 7b fa ff ff       	call   801f49 <syscall>
  8024ce:	83 c4 18             	add    $0x18,%esp
  8024d1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8024d4:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8024d8:	75 07                	jne    8024e1 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8024da:	b8 01 00 00 00       	mov    $0x1,%eax
  8024df:	eb 05                	jmp    8024e6 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8024e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024e6:	c9                   	leave  
  8024e7:	c3                   	ret    

008024e8 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8024e8:	55                   	push   %ebp
  8024e9:	89 e5                	mov    %esp,%ebp
  8024eb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024ee:	6a 00                	push   $0x0
  8024f0:	6a 00                	push   $0x0
  8024f2:	6a 00                	push   $0x0
  8024f4:	6a 00                	push   $0x0
  8024f6:	6a 00                	push   $0x0
  8024f8:	6a 2c                	push   $0x2c
  8024fa:	e8 4a fa ff ff       	call   801f49 <syscall>
  8024ff:	83 c4 18             	add    $0x18,%esp
  802502:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802505:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802509:	75 07                	jne    802512 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80250b:	b8 01 00 00 00       	mov    $0x1,%eax
  802510:	eb 05                	jmp    802517 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802512:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802517:	c9                   	leave  
  802518:	c3                   	ret    

00802519 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802519:	55                   	push   %ebp
  80251a:	89 e5                	mov    %esp,%ebp
  80251c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80251f:	6a 00                	push   $0x0
  802521:	6a 00                	push   $0x0
  802523:	6a 00                	push   $0x0
  802525:	6a 00                	push   $0x0
  802527:	6a 00                	push   $0x0
  802529:	6a 2c                	push   $0x2c
  80252b:	e8 19 fa ff ff       	call   801f49 <syscall>
  802530:	83 c4 18             	add    $0x18,%esp
  802533:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802536:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80253a:	75 07                	jne    802543 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80253c:	b8 01 00 00 00       	mov    $0x1,%eax
  802541:	eb 05                	jmp    802548 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802543:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802548:	c9                   	leave  
  802549:	c3                   	ret    

0080254a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80254a:	55                   	push   %ebp
  80254b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80254d:	6a 00                	push   $0x0
  80254f:	6a 00                	push   $0x0
  802551:	6a 00                	push   $0x0
  802553:	6a 00                	push   $0x0
  802555:	ff 75 08             	pushl  0x8(%ebp)
  802558:	6a 2d                	push   $0x2d
  80255a:	e8 ea f9 ff ff       	call   801f49 <syscall>
  80255f:	83 c4 18             	add    $0x18,%esp
	return ;
  802562:	90                   	nop
}
  802563:	c9                   	leave  
  802564:	c3                   	ret    

00802565 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802565:	55                   	push   %ebp
  802566:	89 e5                	mov    %esp,%ebp
  802568:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802569:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80256c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80256f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802572:	8b 45 08             	mov    0x8(%ebp),%eax
  802575:	6a 00                	push   $0x0
  802577:	53                   	push   %ebx
  802578:	51                   	push   %ecx
  802579:	52                   	push   %edx
  80257a:	50                   	push   %eax
  80257b:	6a 2e                	push   $0x2e
  80257d:	e8 c7 f9 ff ff       	call   801f49 <syscall>
  802582:	83 c4 18             	add    $0x18,%esp
}
  802585:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802588:	c9                   	leave  
  802589:	c3                   	ret    

0080258a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80258a:	55                   	push   %ebp
  80258b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80258d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802590:	8b 45 08             	mov    0x8(%ebp),%eax
  802593:	6a 00                	push   $0x0
  802595:	6a 00                	push   $0x0
  802597:	6a 00                	push   $0x0
  802599:	52                   	push   %edx
  80259a:	50                   	push   %eax
  80259b:	6a 2f                	push   $0x2f
  80259d:	e8 a7 f9 ff ff       	call   801f49 <syscall>
  8025a2:	83 c4 18             	add    $0x18,%esp
}
  8025a5:	c9                   	leave  
  8025a6:	c3                   	ret    

008025a7 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8025a7:	55                   	push   %ebp
  8025a8:	89 e5                	mov    %esp,%ebp
  8025aa:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8025ad:	83 ec 0c             	sub    $0xc,%esp
  8025b0:	68 5c 41 80 00       	push   $0x80415c
  8025b5:	e8 21 e7 ff ff       	call   800cdb <cprintf>
  8025ba:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8025bd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8025c4:	83 ec 0c             	sub    $0xc,%esp
  8025c7:	68 88 41 80 00       	push   $0x804188
  8025cc:	e8 0a e7 ff ff       	call   800cdb <cprintf>
  8025d1:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8025d4:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8025d8:	a1 38 51 80 00       	mov    0x805138,%eax
  8025dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025e0:	eb 56                	jmp    802638 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8025e2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025e6:	74 1c                	je     802604 <print_mem_block_lists+0x5d>
  8025e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025eb:	8b 50 08             	mov    0x8(%eax),%edx
  8025ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025f1:	8b 48 08             	mov    0x8(%eax),%ecx
  8025f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8025fa:	01 c8                	add    %ecx,%eax
  8025fc:	39 c2                	cmp    %eax,%edx
  8025fe:	73 04                	jae    802604 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802600:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802604:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802607:	8b 50 08             	mov    0x8(%eax),%edx
  80260a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260d:	8b 40 0c             	mov    0xc(%eax),%eax
  802610:	01 c2                	add    %eax,%edx
  802612:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802615:	8b 40 08             	mov    0x8(%eax),%eax
  802618:	83 ec 04             	sub    $0x4,%esp
  80261b:	52                   	push   %edx
  80261c:	50                   	push   %eax
  80261d:	68 9d 41 80 00       	push   $0x80419d
  802622:	e8 b4 e6 ff ff       	call   800cdb <cprintf>
  802627:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80262a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802630:	a1 40 51 80 00       	mov    0x805140,%eax
  802635:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802638:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80263c:	74 07                	je     802645 <print_mem_block_lists+0x9e>
  80263e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802641:	8b 00                	mov    (%eax),%eax
  802643:	eb 05                	jmp    80264a <print_mem_block_lists+0xa3>
  802645:	b8 00 00 00 00       	mov    $0x0,%eax
  80264a:	a3 40 51 80 00       	mov    %eax,0x805140
  80264f:	a1 40 51 80 00       	mov    0x805140,%eax
  802654:	85 c0                	test   %eax,%eax
  802656:	75 8a                	jne    8025e2 <print_mem_block_lists+0x3b>
  802658:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80265c:	75 84                	jne    8025e2 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80265e:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802662:	75 10                	jne    802674 <print_mem_block_lists+0xcd>
  802664:	83 ec 0c             	sub    $0xc,%esp
  802667:	68 ac 41 80 00       	push   $0x8041ac
  80266c:	e8 6a e6 ff ff       	call   800cdb <cprintf>
  802671:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802674:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80267b:	83 ec 0c             	sub    $0xc,%esp
  80267e:	68 d0 41 80 00       	push   $0x8041d0
  802683:	e8 53 e6 ff ff       	call   800cdb <cprintf>
  802688:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80268b:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80268f:	a1 40 50 80 00       	mov    0x805040,%eax
  802694:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802697:	eb 56                	jmp    8026ef <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802699:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80269d:	74 1c                	je     8026bb <print_mem_block_lists+0x114>
  80269f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a2:	8b 50 08             	mov    0x8(%eax),%edx
  8026a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026a8:	8b 48 08             	mov    0x8(%eax),%ecx
  8026ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8026b1:	01 c8                	add    %ecx,%eax
  8026b3:	39 c2                	cmp    %eax,%edx
  8026b5:	73 04                	jae    8026bb <print_mem_block_lists+0x114>
			sorted = 0 ;
  8026b7:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8026bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026be:	8b 50 08             	mov    0x8(%eax),%edx
  8026c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c4:	8b 40 0c             	mov    0xc(%eax),%eax
  8026c7:	01 c2                	add    %eax,%edx
  8026c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cc:	8b 40 08             	mov    0x8(%eax),%eax
  8026cf:	83 ec 04             	sub    $0x4,%esp
  8026d2:	52                   	push   %edx
  8026d3:	50                   	push   %eax
  8026d4:	68 9d 41 80 00       	push   $0x80419d
  8026d9:	e8 fd e5 ff ff       	call   800cdb <cprintf>
  8026de:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8026e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8026e7:	a1 48 50 80 00       	mov    0x805048,%eax
  8026ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026f3:	74 07                	je     8026fc <print_mem_block_lists+0x155>
  8026f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f8:	8b 00                	mov    (%eax),%eax
  8026fa:	eb 05                	jmp    802701 <print_mem_block_lists+0x15a>
  8026fc:	b8 00 00 00 00       	mov    $0x0,%eax
  802701:	a3 48 50 80 00       	mov    %eax,0x805048
  802706:	a1 48 50 80 00       	mov    0x805048,%eax
  80270b:	85 c0                	test   %eax,%eax
  80270d:	75 8a                	jne    802699 <print_mem_block_lists+0xf2>
  80270f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802713:	75 84                	jne    802699 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802715:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802719:	75 10                	jne    80272b <print_mem_block_lists+0x184>
  80271b:	83 ec 0c             	sub    $0xc,%esp
  80271e:	68 e8 41 80 00       	push   $0x8041e8
  802723:	e8 b3 e5 ff ff       	call   800cdb <cprintf>
  802728:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80272b:	83 ec 0c             	sub    $0xc,%esp
  80272e:	68 5c 41 80 00       	push   $0x80415c
  802733:	e8 a3 e5 ff ff       	call   800cdb <cprintf>
  802738:	83 c4 10             	add    $0x10,%esp

}
  80273b:	90                   	nop
  80273c:	c9                   	leave  
  80273d:	c3                   	ret    

0080273e <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80273e:	55                   	push   %ebp
  80273f:	89 e5                	mov    %esp,%ebp
  802741:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  802744:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  80274b:	00 00 00 
  80274e:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802755:	00 00 00 
  802758:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  80275f:	00 00 00 
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  802762:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802769:	e9 9e 00 00 00       	jmp    80280c <initialize_MemBlocksList+0xce>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
  80276e:	a1 50 50 80 00       	mov    0x805050,%eax
  802773:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802776:	c1 e2 04             	shl    $0x4,%edx
  802779:	01 d0                	add    %edx,%eax
  80277b:	85 c0                	test   %eax,%eax
  80277d:	75 14                	jne    802793 <initialize_MemBlocksList+0x55>
  80277f:	83 ec 04             	sub    $0x4,%esp
  802782:	68 10 42 80 00       	push   $0x804210
  802787:	6a 43                	push   $0x43
  802789:	68 33 42 80 00       	push   $0x804233
  80278e:	e8 94 e2 ff ff       	call   800a27 <_panic>
  802793:	a1 50 50 80 00       	mov    0x805050,%eax
  802798:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80279b:	c1 e2 04             	shl    $0x4,%edx
  80279e:	01 d0                	add    %edx,%eax
  8027a0:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8027a6:	89 10                	mov    %edx,(%eax)
  8027a8:	8b 00                	mov    (%eax),%eax
  8027aa:	85 c0                	test   %eax,%eax
  8027ac:	74 18                	je     8027c6 <initialize_MemBlocksList+0x88>
  8027ae:	a1 48 51 80 00       	mov    0x805148,%eax
  8027b3:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8027b9:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8027bc:	c1 e1 04             	shl    $0x4,%ecx
  8027bf:	01 ca                	add    %ecx,%edx
  8027c1:	89 50 04             	mov    %edx,0x4(%eax)
  8027c4:	eb 12                	jmp    8027d8 <initialize_MemBlocksList+0x9a>
  8027c6:	a1 50 50 80 00       	mov    0x805050,%eax
  8027cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027ce:	c1 e2 04             	shl    $0x4,%edx
  8027d1:	01 d0                	add    %edx,%eax
  8027d3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8027d8:	a1 50 50 80 00       	mov    0x805050,%eax
  8027dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027e0:	c1 e2 04             	shl    $0x4,%edx
  8027e3:	01 d0                	add    %edx,%eax
  8027e5:	a3 48 51 80 00       	mov    %eax,0x805148
  8027ea:	a1 50 50 80 00       	mov    0x805050,%eax
  8027ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027f2:	c1 e2 04             	shl    $0x4,%edx
  8027f5:	01 d0                	add    %edx,%eax
  8027f7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027fe:	a1 54 51 80 00       	mov    0x805154,%eax
  802803:	40                   	inc    %eax
  802804:	a3 54 51 80 00       	mov    %eax,0x805154
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  802809:	ff 45 f4             	incl   -0xc(%ebp)
  80280c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802812:	0f 82 56 ff ff ff    	jb     80276e <initialize_MemBlocksList+0x30>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
		}
}
  802818:	90                   	nop
  802819:	c9                   	leave  
  80281a:	c3                   	ret    

0080281b <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80281b:	55                   	push   %ebp
  80281c:	89 e5                	mov    %esp,%ebp
  80281e:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  802821:	a1 38 51 80 00       	mov    0x805138,%eax
  802826:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802829:	eb 18                	jmp    802843 <find_block+0x28>
	{
		if (ele->sva==va)
  80282b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80282e:	8b 40 08             	mov    0x8(%eax),%eax
  802831:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802834:	75 05                	jne    80283b <find_block+0x20>
			return ele;
  802836:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802839:	eb 7b                	jmp    8028b6 <find_block+0x9b>
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  80283b:	a1 40 51 80 00       	mov    0x805140,%eax
  802840:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802843:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802847:	74 07                	je     802850 <find_block+0x35>
  802849:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80284c:	8b 00                	mov    (%eax),%eax
  80284e:	eb 05                	jmp    802855 <find_block+0x3a>
  802850:	b8 00 00 00 00       	mov    $0x0,%eax
  802855:	a3 40 51 80 00       	mov    %eax,0x805140
  80285a:	a1 40 51 80 00       	mov    0x805140,%eax
  80285f:	85 c0                	test   %eax,%eax
  802861:	75 c8                	jne    80282b <find_block+0x10>
  802863:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802867:	75 c2                	jne    80282b <find_block+0x10>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  802869:	a1 40 50 80 00       	mov    0x805040,%eax
  80286e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802871:	eb 18                	jmp    80288b <find_block+0x70>
	{
		if (ele->sva==va)
  802873:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802876:	8b 40 08             	mov    0x8(%eax),%eax
  802879:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80287c:	75 05                	jne    802883 <find_block+0x68>
					return ele;
  80287e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802881:	eb 33                	jmp    8028b6 <find_block+0x9b>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  802883:	a1 48 50 80 00       	mov    0x805048,%eax
  802888:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80288b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80288f:	74 07                	je     802898 <find_block+0x7d>
  802891:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802894:	8b 00                	mov    (%eax),%eax
  802896:	eb 05                	jmp    80289d <find_block+0x82>
  802898:	b8 00 00 00 00       	mov    $0x0,%eax
  80289d:	a3 48 50 80 00       	mov    %eax,0x805048
  8028a2:	a1 48 50 80 00       	mov    0x805048,%eax
  8028a7:	85 c0                	test   %eax,%eax
  8028a9:	75 c8                	jne    802873 <find_block+0x58>
  8028ab:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8028af:	75 c2                	jne    802873 <find_block+0x58>
	{
		if (ele->sva==va)
					return ele;
	}
return NULL;
  8028b1:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  8028b6:	c9                   	leave  
  8028b7:	c3                   	ret    

008028b8 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8028b8:	55                   	push   %ebp
  8028b9:	89 e5                	mov    %esp,%ebp
  8028bb:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;

int x =LIST_SIZE(&AllocMemBlocksList);
  8028be:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8028c3:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((x==0))
  8028c6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028ca:	75 62                	jne    80292e <insert_sorted_allocList+0x76>
	{
	//	blockToInsert=AllocMemBlocksList.lh_first;
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  8028cc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028d0:	75 14                	jne    8028e6 <insert_sorted_allocList+0x2e>
  8028d2:	83 ec 04             	sub    $0x4,%esp
  8028d5:	68 10 42 80 00       	push   $0x804210
  8028da:	6a 69                	push   $0x69
  8028dc:	68 33 42 80 00       	push   $0x804233
  8028e1:	e8 41 e1 ff ff       	call   800a27 <_panic>
  8028e6:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8028ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ef:	89 10                	mov    %edx,(%eax)
  8028f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f4:	8b 00                	mov    (%eax),%eax
  8028f6:	85 c0                	test   %eax,%eax
  8028f8:	74 0d                	je     802907 <insert_sorted_allocList+0x4f>
  8028fa:	a1 40 50 80 00       	mov    0x805040,%eax
  8028ff:	8b 55 08             	mov    0x8(%ebp),%edx
  802902:	89 50 04             	mov    %edx,0x4(%eax)
  802905:	eb 08                	jmp    80290f <insert_sorted_allocList+0x57>
  802907:	8b 45 08             	mov    0x8(%ebp),%eax
  80290a:	a3 44 50 80 00       	mov    %eax,0x805044
  80290f:	8b 45 08             	mov    0x8(%ebp),%eax
  802912:	a3 40 50 80 00       	mov    %eax,0x805040
  802917:	8b 45 08             	mov    0x8(%ebp),%eax
  80291a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802921:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802926:	40                   	inc    %eax
  802927:	a3 4c 50 80 00       	mov    %eax,0x80504c
  80292c:	eb 72                	jmp    8029a0 <insert_sorted_allocList+0xe8>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
  80292e:	a1 40 50 80 00       	mov    0x805040,%eax
  802933:	8b 50 08             	mov    0x8(%eax),%edx
  802936:	8b 45 08             	mov    0x8(%ebp),%eax
  802939:	8b 40 08             	mov    0x8(%eax),%eax
  80293c:	39 c2                	cmp    %eax,%edx
  80293e:	76 60                	jbe    8029a0 <insert_sorted_allocList+0xe8>
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  802940:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802944:	75 14                	jne    80295a <insert_sorted_allocList+0xa2>
  802946:	83 ec 04             	sub    $0x4,%esp
  802949:	68 10 42 80 00       	push   $0x804210
  80294e:	6a 6d                	push   $0x6d
  802950:	68 33 42 80 00       	push   $0x804233
  802955:	e8 cd e0 ff ff       	call   800a27 <_panic>
  80295a:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802960:	8b 45 08             	mov    0x8(%ebp),%eax
  802963:	89 10                	mov    %edx,(%eax)
  802965:	8b 45 08             	mov    0x8(%ebp),%eax
  802968:	8b 00                	mov    (%eax),%eax
  80296a:	85 c0                	test   %eax,%eax
  80296c:	74 0d                	je     80297b <insert_sorted_allocList+0xc3>
  80296e:	a1 40 50 80 00       	mov    0x805040,%eax
  802973:	8b 55 08             	mov    0x8(%ebp),%edx
  802976:	89 50 04             	mov    %edx,0x4(%eax)
  802979:	eb 08                	jmp    802983 <insert_sorted_allocList+0xcb>
  80297b:	8b 45 08             	mov    0x8(%ebp),%eax
  80297e:	a3 44 50 80 00       	mov    %eax,0x805044
  802983:	8b 45 08             	mov    0x8(%ebp),%eax
  802986:	a3 40 50 80 00       	mov    %eax,0x805040
  80298b:	8b 45 08             	mov    0x8(%ebp),%eax
  80298e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802995:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80299a:	40                   	inc    %eax
  80299b:	a3 4c 50 80 00       	mov    %eax,0x80504c
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  8029a0:	a1 40 50 80 00       	mov    0x805040,%eax
  8029a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029a8:	e9 b9 01 00 00       	jmp    802b66 <insert_sorted_allocList+0x2ae>
	{


		if ((blockToInsert->sva>AllocMemBlocksList.lh_first->sva)&&blockToInsert->sva<element->sva)
  8029ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b0:	8b 50 08             	mov    0x8(%eax),%edx
  8029b3:	a1 40 50 80 00       	mov    0x805040,%eax
  8029b8:	8b 40 08             	mov    0x8(%eax),%eax
  8029bb:	39 c2                	cmp    %eax,%edx
  8029bd:	76 7c                	jbe    802a3b <insert_sorted_allocList+0x183>
  8029bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c2:	8b 50 08             	mov    0x8(%eax),%edx
  8029c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c8:	8b 40 08             	mov    0x8(%eax),%eax
  8029cb:	39 c2                	cmp    %eax,%edx
  8029cd:	73 6c                	jae    802a3b <insert_sorted_allocList+0x183>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,element,blockToInsert);
  8029cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029d3:	74 06                	je     8029db <insert_sorted_allocList+0x123>
  8029d5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029d9:	75 14                	jne    8029ef <insert_sorted_allocList+0x137>
  8029db:	83 ec 04             	sub    $0x4,%esp
  8029de:	68 4c 42 80 00       	push   $0x80424c
  8029e3:	6a 75                	push   $0x75
  8029e5:	68 33 42 80 00       	push   $0x804233
  8029ea:	e8 38 e0 ff ff       	call   800a27 <_panic>
  8029ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f2:	8b 50 04             	mov    0x4(%eax),%edx
  8029f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f8:	89 50 04             	mov    %edx,0x4(%eax)
  8029fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8029fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a01:	89 10                	mov    %edx,(%eax)
  802a03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a06:	8b 40 04             	mov    0x4(%eax),%eax
  802a09:	85 c0                	test   %eax,%eax
  802a0b:	74 0d                	je     802a1a <insert_sorted_allocList+0x162>
  802a0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a10:	8b 40 04             	mov    0x4(%eax),%eax
  802a13:	8b 55 08             	mov    0x8(%ebp),%edx
  802a16:	89 10                	mov    %edx,(%eax)
  802a18:	eb 08                	jmp    802a22 <insert_sorted_allocList+0x16a>
  802a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1d:	a3 40 50 80 00       	mov    %eax,0x805040
  802a22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a25:	8b 55 08             	mov    0x8(%ebp),%edx
  802a28:	89 50 04             	mov    %edx,0x4(%eax)
  802a2b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a30:	40                   	inc    %eax
  802a31:	a3 4c 50 80 00       	mov    %eax,0x80504c

		break;}
  802a36:	e9 59 01 00 00       	jmp    802b94 <insert_sorted_allocList+0x2dc>

	else if ((blockToInsert->sva>element->sva)&&(blockToInsert->sva<AllocMemBlocksList.lh_last->sva)&&blockToInsert->sva<LIST_NEXT(element)->sva)
  802a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3e:	8b 50 08             	mov    0x8(%eax),%edx
  802a41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a44:	8b 40 08             	mov    0x8(%eax),%eax
  802a47:	39 c2                	cmp    %eax,%edx
  802a49:	0f 86 98 00 00 00    	jbe    802ae7 <insert_sorted_allocList+0x22f>
  802a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a52:	8b 50 08             	mov    0x8(%eax),%edx
  802a55:	a1 44 50 80 00       	mov    0x805044,%eax
  802a5a:	8b 40 08             	mov    0x8(%eax),%eax
  802a5d:	39 c2                	cmp    %eax,%edx
  802a5f:	0f 83 82 00 00 00    	jae    802ae7 <insert_sorted_allocList+0x22f>
  802a65:	8b 45 08             	mov    0x8(%ebp),%eax
  802a68:	8b 50 08             	mov    0x8(%eax),%edx
  802a6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6e:	8b 00                	mov    (%eax),%eax
  802a70:	8b 40 08             	mov    0x8(%eax),%eax
  802a73:	39 c2                	cmp    %eax,%edx
  802a75:	73 70                	jae    802ae7 <insert_sorted_allocList+0x22f>
	{

	LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  802a77:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a7b:	74 06                	je     802a83 <insert_sorted_allocList+0x1cb>
  802a7d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a81:	75 14                	jne    802a97 <insert_sorted_allocList+0x1df>
  802a83:	83 ec 04             	sub    $0x4,%esp
  802a86:	68 84 42 80 00       	push   $0x804284
  802a8b:	6a 7c                	push   $0x7c
  802a8d:	68 33 42 80 00       	push   $0x804233
  802a92:	e8 90 df ff ff       	call   800a27 <_panic>
  802a97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9a:	8b 10                	mov    (%eax),%edx
  802a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9f:	89 10                	mov    %edx,(%eax)
  802aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa4:	8b 00                	mov    (%eax),%eax
  802aa6:	85 c0                	test   %eax,%eax
  802aa8:	74 0b                	je     802ab5 <insert_sorted_allocList+0x1fd>
  802aaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aad:	8b 00                	mov    (%eax),%eax
  802aaf:	8b 55 08             	mov    0x8(%ebp),%edx
  802ab2:	89 50 04             	mov    %edx,0x4(%eax)
  802ab5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab8:	8b 55 08             	mov    0x8(%ebp),%edx
  802abb:	89 10                	mov    %edx,(%eax)
  802abd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ac3:	89 50 04             	mov    %edx,0x4(%eax)
  802ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac9:	8b 00                	mov    (%eax),%eax
  802acb:	85 c0                	test   %eax,%eax
  802acd:	75 08                	jne    802ad7 <insert_sorted_allocList+0x21f>
  802acf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad2:	a3 44 50 80 00       	mov    %eax,0x805044
  802ad7:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802adc:	40                   	inc    %eax
  802add:	a3 4c 50 80 00       	mov    %eax,0x80504c
		break;
  802ae2:	e9 ad 00 00 00       	jmp    802b94 <insert_sorted_allocList+0x2dc>
	}else if (blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  802ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  802aea:	8b 50 08             	mov    0x8(%eax),%edx
  802aed:	a1 44 50 80 00       	mov    0x805044,%eax
  802af2:	8b 40 08             	mov    0x8(%eax),%eax
  802af5:	39 c2                	cmp    %eax,%edx
  802af7:	76 65                	jbe    802b5e <insert_sorted_allocList+0x2a6>
	{
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
  802af9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802afd:	75 17                	jne    802b16 <insert_sorted_allocList+0x25e>
  802aff:	83 ec 04             	sub    $0x4,%esp
  802b02:	68 b8 42 80 00       	push   $0x8042b8
  802b07:	68 80 00 00 00       	push   $0x80
  802b0c:	68 33 42 80 00       	push   $0x804233
  802b11:	e8 11 df ff ff       	call   800a27 <_panic>
  802b16:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1f:	89 50 04             	mov    %edx,0x4(%eax)
  802b22:	8b 45 08             	mov    0x8(%ebp),%eax
  802b25:	8b 40 04             	mov    0x4(%eax),%eax
  802b28:	85 c0                	test   %eax,%eax
  802b2a:	74 0c                	je     802b38 <insert_sorted_allocList+0x280>
  802b2c:	a1 44 50 80 00       	mov    0x805044,%eax
  802b31:	8b 55 08             	mov    0x8(%ebp),%edx
  802b34:	89 10                	mov    %edx,(%eax)
  802b36:	eb 08                	jmp    802b40 <insert_sorted_allocList+0x288>
  802b38:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3b:	a3 40 50 80 00       	mov    %eax,0x805040
  802b40:	8b 45 08             	mov    0x8(%ebp),%eax
  802b43:	a3 44 50 80 00       	mov    %eax,0x805044
  802b48:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b51:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802b56:	40                   	inc    %eax
  802b57:	a3 4c 50 80 00       	mov    %eax,0x80504c
		break;
  802b5c:	eb 36                	jmp    802b94 <insert_sorted_allocList+0x2dc>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  802b5e:	a1 48 50 80 00       	mov    0x805048,%eax
  802b63:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b66:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b6a:	74 07                	je     802b73 <insert_sorted_allocList+0x2bb>
  802b6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6f:	8b 00                	mov    (%eax),%eax
  802b71:	eb 05                	jmp    802b78 <insert_sorted_allocList+0x2c0>
  802b73:	b8 00 00 00 00       	mov    $0x0,%eax
  802b78:	a3 48 50 80 00       	mov    %eax,0x805048
  802b7d:	a1 48 50 80 00       	mov    0x805048,%eax
  802b82:	85 c0                	test   %eax,%eax
  802b84:	0f 85 23 fe ff ff    	jne    8029ad <insert_sorted_allocList+0xf5>
  802b8a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b8e:	0f 85 19 fe ff ff    	jne    8029ad <insert_sorted_allocList+0xf5>
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
		break;

	}
	}
}
  802b94:	90                   	nop
  802b95:	c9                   	leave  
  802b96:	c3                   	ret    

00802b97 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802b97:	55                   	push   %ebp
  802b98:	89 e5                	mov    %esp,%ebp
  802b9a:	83 ec 18             	sub    $0x18,%esp
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802b9d:	a1 38 51 80 00       	mov    0x805138,%eax
  802ba2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ba5:	e9 7c 01 00 00       	jmp    802d26 <alloc_block_FF+0x18f>
		{
			// case 2
				if(element->size == size)
  802baa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bad:	8b 40 0c             	mov    0xc(%eax),%eax
  802bb0:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bb3:	0f 85 90 00 00 00    	jne    802c49 <alloc_block_FF+0xb2>
				{
					tmp_block=element;
  802bb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbc:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,element);
  802bbf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bc3:	75 17                	jne    802bdc <alloc_block_FF+0x45>
  802bc5:	83 ec 04             	sub    $0x4,%esp
  802bc8:	68 db 42 80 00       	push   $0x8042db
  802bcd:	68 ba 00 00 00       	push   $0xba
  802bd2:	68 33 42 80 00       	push   $0x804233
  802bd7:	e8 4b de ff ff       	call   800a27 <_panic>
  802bdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bdf:	8b 00                	mov    (%eax),%eax
  802be1:	85 c0                	test   %eax,%eax
  802be3:	74 10                	je     802bf5 <alloc_block_FF+0x5e>
  802be5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be8:	8b 00                	mov    (%eax),%eax
  802bea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bed:	8b 52 04             	mov    0x4(%edx),%edx
  802bf0:	89 50 04             	mov    %edx,0x4(%eax)
  802bf3:	eb 0b                	jmp    802c00 <alloc_block_FF+0x69>
  802bf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf8:	8b 40 04             	mov    0x4(%eax),%eax
  802bfb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c03:	8b 40 04             	mov    0x4(%eax),%eax
  802c06:	85 c0                	test   %eax,%eax
  802c08:	74 0f                	je     802c19 <alloc_block_FF+0x82>
  802c0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0d:	8b 40 04             	mov    0x4(%eax),%eax
  802c10:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c13:	8b 12                	mov    (%edx),%edx
  802c15:	89 10                	mov    %edx,(%eax)
  802c17:	eb 0a                	jmp    802c23 <alloc_block_FF+0x8c>
  802c19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1c:	8b 00                	mov    (%eax),%eax
  802c1e:	a3 38 51 80 00       	mov    %eax,0x805138
  802c23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c26:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c36:	a1 44 51 80 00       	mov    0x805144,%eax
  802c3b:	48                   	dec    %eax
  802c3c:	a3 44 51 80 00       	mov    %eax,0x805144
					return tmp_block;
  802c41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c44:	e9 10 01 00 00       	jmp    802d59 <alloc_block_FF+0x1c2>
				}
				 // case 3
				else if(element->size > size)
  802c49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4c:	8b 40 0c             	mov    0xc(%eax),%eax
  802c4f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c52:	0f 86 c6 00 00 00    	jbe    802d1e <alloc_block_FF+0x187>
				{
					// the new block are created
					tmp_block = AvailableMemBlocksList.lh_first ;
  802c58:	a1 48 51 80 00       	mov    0x805148,%eax
  802c5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  802c60:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c64:	75 17                	jne    802c7d <alloc_block_FF+0xe6>
  802c66:	83 ec 04             	sub    $0x4,%esp
  802c69:	68 db 42 80 00       	push   $0x8042db
  802c6e:	68 c2 00 00 00       	push   $0xc2
  802c73:	68 33 42 80 00       	push   $0x804233
  802c78:	e8 aa dd ff ff       	call   800a27 <_panic>
  802c7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c80:	8b 00                	mov    (%eax),%eax
  802c82:	85 c0                	test   %eax,%eax
  802c84:	74 10                	je     802c96 <alloc_block_FF+0xff>
  802c86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c89:	8b 00                	mov    (%eax),%eax
  802c8b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c8e:	8b 52 04             	mov    0x4(%edx),%edx
  802c91:	89 50 04             	mov    %edx,0x4(%eax)
  802c94:	eb 0b                	jmp    802ca1 <alloc_block_FF+0x10a>
  802c96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c99:	8b 40 04             	mov    0x4(%eax),%eax
  802c9c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ca1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca4:	8b 40 04             	mov    0x4(%eax),%eax
  802ca7:	85 c0                	test   %eax,%eax
  802ca9:	74 0f                	je     802cba <alloc_block_FF+0x123>
  802cab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cae:	8b 40 04             	mov    0x4(%eax),%eax
  802cb1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cb4:	8b 12                	mov    (%edx),%edx
  802cb6:	89 10                	mov    %edx,(%eax)
  802cb8:	eb 0a                	jmp    802cc4 <alloc_block_FF+0x12d>
  802cba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cbd:	8b 00                	mov    (%eax),%eax
  802cbf:	a3 48 51 80 00       	mov    %eax,0x805148
  802cc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ccd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cd7:	a1 54 51 80 00       	mov    0x805154,%eax
  802cdc:	48                   	dec    %eax
  802cdd:	a3 54 51 80 00       	mov    %eax,0x805154
					tmp_block->sva=element->sva;
  802ce2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce5:	8b 50 08             	mov    0x8(%eax),%edx
  802ce8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ceb:	89 50 08             	mov    %edx,0x8(%eax)
					tmp_block->size=size;
  802cee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf1:	8b 55 08             	mov    0x8(%ebp),%edx
  802cf4:	89 50 0c             	mov    %edx,0xc(%eax)
					//update block with remaining space
					element->size-=size;
  802cf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfa:	8b 40 0c             	mov    0xc(%eax),%eax
  802cfd:	2b 45 08             	sub    0x8(%ebp),%eax
  802d00:	89 c2                	mov    %eax,%edx
  802d02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d05:	89 50 0c             	mov    %edx,0xc(%eax)
					element->sva = element->sva + size;
  802d08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0b:	8b 50 08             	mov    0x8(%eax),%edx
  802d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d11:	01 c2                	add    %eax,%edx
  802d13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d16:	89 50 08             	mov    %edx,0x8(%eax)
					// return back the new block
					return tmp_block ;
  802d19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d1c:	eb 3b                	jmp    802d59 <alloc_block_FF+0x1c2>
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802d1e:	a1 40 51 80 00       	mov    0x805140,%eax
  802d23:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d26:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d2a:	74 07                	je     802d33 <alloc_block_FF+0x19c>
  802d2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2f:	8b 00                	mov    (%eax),%eax
  802d31:	eb 05                	jmp    802d38 <alloc_block_FF+0x1a1>
  802d33:	b8 00 00 00 00       	mov    $0x0,%eax
  802d38:	a3 40 51 80 00       	mov    %eax,0x805140
  802d3d:	a1 40 51 80 00       	mov    0x805140,%eax
  802d42:	85 c0                	test   %eax,%eax
  802d44:	0f 85 60 fe ff ff    	jne    802baa <alloc_block_FF+0x13>
  802d4a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d4e:	0f 85 56 fe ff ff    	jne    802baa <alloc_block_FF+0x13>
					// return back the new block
					return tmp_block ;
				}
		}
		// case 1
	  return NULL ;}
  802d54:	b8 00 00 00 00       	mov    $0x0,%eax
  802d59:	c9                   	leave  
  802d5a:	c3                   	ret    

00802d5b <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================

struct MemBlock *alloc_block_BF(uint32 size)
{
  802d5b:	55                   	push   %ebp
  802d5c:	89 e5                	mov    %esp,%ebp
  802d5e:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
  802d61:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802d68:	a1 38 51 80 00       	mov    0x805138,%eax
  802d6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d70:	eb 3a                	jmp    802dac <alloc_block_BF+0x51>
		{
			if(element->size >= size)
  802d72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d75:	8b 40 0c             	mov    0xc(%eax),%eax
  802d78:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d7b:	72 27                	jb     802da4 <alloc_block_BF+0x49>
			{
				if(best_size==-1)
  802d7d:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802d81:	75 0b                	jne    802d8e <alloc_block_BF+0x33>
					best_size= element->size;
  802d83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d86:	8b 40 0c             	mov    0xc(%eax),%eax
  802d89:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802d8c:	eb 16                	jmp    802da4 <alloc_block_BF+0x49>
				else if(best_size >= element->size)
  802d8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d91:	8b 50 0c             	mov    0xc(%eax),%edx
  802d94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d97:	39 c2                	cmp    %eax,%edx
  802d99:	77 09                	ja     802da4 <alloc_block_BF+0x49>
					best_size=element->size;
  802d9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9e:	8b 40 0c             	mov    0xc(%eax),%eax
  802da1:	89 45 f0             	mov    %eax,-0x10(%ebp)

struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802da4:	a1 40 51 80 00       	mov    0x805140,%eax
  802da9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802dac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802db0:	74 07                	je     802db9 <alloc_block_BF+0x5e>
  802db2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db5:	8b 00                	mov    (%eax),%eax
  802db7:	eb 05                	jmp    802dbe <alloc_block_BF+0x63>
  802db9:	b8 00 00 00 00       	mov    $0x0,%eax
  802dbe:	a3 40 51 80 00       	mov    %eax,0x805140
  802dc3:	a1 40 51 80 00       	mov    0x805140,%eax
  802dc8:	85 c0                	test   %eax,%eax
  802dca:	75 a6                	jne    802d72 <alloc_block_BF+0x17>
  802dcc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dd0:	75 a0                	jne    802d72 <alloc_block_BF+0x17>
					best_size= element->size;
				else if(best_size >= element->size)
					best_size=element->size;
			}
		}
		if(best_size != -1)
  802dd2:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802dd6:	0f 84 d3 01 00 00    	je     802faf <alloc_block_BF+0x254>
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  802ddc:	a1 38 51 80 00       	mov    0x805138,%eax
  802de1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802de4:	e9 98 01 00 00       	jmp    802f81 <alloc_block_BF+0x226>
			{
			 if((best_size > size) && (best_size == element->size))
  802de9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dec:	3b 45 08             	cmp    0x8(%ebp),%eax
  802def:	0f 86 da 00 00 00    	jbe    802ecf <alloc_block_BF+0x174>
  802df5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df8:	8b 50 0c             	mov    0xc(%eax),%edx
  802dfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dfe:	39 c2                	cmp    %eax,%edx
  802e00:	0f 85 c9 00 00 00    	jne    802ecf <alloc_block_BF+0x174>
			  {
				// the new block are created
			    tmp_block = AvailableMemBlocksList.lh_first ;
  802e06:	a1 48 51 80 00       	mov    0x805148,%eax
  802e0b:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  802e0e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802e12:	75 17                	jne    802e2b <alloc_block_BF+0xd0>
  802e14:	83 ec 04             	sub    $0x4,%esp
  802e17:	68 db 42 80 00       	push   $0x8042db
  802e1c:	68 ea 00 00 00       	push   $0xea
  802e21:	68 33 42 80 00       	push   $0x804233
  802e26:	e8 fc db ff ff       	call   800a27 <_panic>
  802e2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e2e:	8b 00                	mov    (%eax),%eax
  802e30:	85 c0                	test   %eax,%eax
  802e32:	74 10                	je     802e44 <alloc_block_BF+0xe9>
  802e34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e37:	8b 00                	mov    (%eax),%eax
  802e39:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e3c:	8b 52 04             	mov    0x4(%edx),%edx
  802e3f:	89 50 04             	mov    %edx,0x4(%eax)
  802e42:	eb 0b                	jmp    802e4f <alloc_block_BF+0xf4>
  802e44:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e47:	8b 40 04             	mov    0x4(%eax),%eax
  802e4a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e52:	8b 40 04             	mov    0x4(%eax),%eax
  802e55:	85 c0                	test   %eax,%eax
  802e57:	74 0f                	je     802e68 <alloc_block_BF+0x10d>
  802e59:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e5c:	8b 40 04             	mov    0x4(%eax),%eax
  802e5f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e62:	8b 12                	mov    (%edx),%edx
  802e64:	89 10                	mov    %edx,(%eax)
  802e66:	eb 0a                	jmp    802e72 <alloc_block_BF+0x117>
  802e68:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e6b:	8b 00                	mov    (%eax),%eax
  802e6d:	a3 48 51 80 00       	mov    %eax,0x805148
  802e72:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e75:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e7e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e85:	a1 54 51 80 00       	mov    0x805154,%eax
  802e8a:	48                   	dec    %eax
  802e8b:	a3 54 51 80 00       	mov    %eax,0x805154
				tmp_block->sva=element->sva;
  802e90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e93:	8b 50 08             	mov    0x8(%eax),%edx
  802e96:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e99:	89 50 08             	mov    %edx,0x8(%eax)
				tmp_block->size=size;
  802e9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e9f:	8b 55 08             	mov    0x8(%ebp),%edx
  802ea2:	89 50 0c             	mov    %edx,0xc(%eax)
				//update block with remaining space
				element->size-=size;
  802ea5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea8:	8b 40 0c             	mov    0xc(%eax),%eax
  802eab:	2b 45 08             	sub    0x8(%ebp),%eax
  802eae:	89 c2                	mov    %eax,%edx
  802eb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb3:	89 50 0c             	mov    %edx,0xc(%eax)
				element->sva = element->sva + size;
  802eb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb9:	8b 50 08             	mov    0x8(%eax),%edx
  802ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebf:	01 c2                	add    %eax,%edx
  802ec1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec4:	89 50 08             	mov    %edx,0x8(%eax)
				// return back the new block
				return tmp_block ;
  802ec7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eca:	e9 e5 00 00 00       	jmp    802fb4 <alloc_block_BF+0x259>

			  }
			else if((element->size == best_size)&&(best_size == size))
  802ecf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed2:	8b 50 0c             	mov    0xc(%eax),%edx
  802ed5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ed8:	39 c2                	cmp    %eax,%edx
  802eda:	0f 85 99 00 00 00    	jne    802f79 <alloc_block_BF+0x21e>
  802ee0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee3:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ee6:	0f 85 8d 00 00 00    	jne    802f79 <alloc_block_BF+0x21e>
			  {
				tmp_block=element;
  802eec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eef:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&FreeMemBlocksList,element);
  802ef2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ef6:	75 17                	jne    802f0f <alloc_block_BF+0x1b4>
  802ef8:	83 ec 04             	sub    $0x4,%esp
  802efb:	68 db 42 80 00       	push   $0x8042db
  802f00:	68 f7 00 00 00       	push   $0xf7
  802f05:	68 33 42 80 00       	push   $0x804233
  802f0a:	e8 18 db ff ff       	call   800a27 <_panic>
  802f0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f12:	8b 00                	mov    (%eax),%eax
  802f14:	85 c0                	test   %eax,%eax
  802f16:	74 10                	je     802f28 <alloc_block_BF+0x1cd>
  802f18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1b:	8b 00                	mov    (%eax),%eax
  802f1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f20:	8b 52 04             	mov    0x4(%edx),%edx
  802f23:	89 50 04             	mov    %edx,0x4(%eax)
  802f26:	eb 0b                	jmp    802f33 <alloc_block_BF+0x1d8>
  802f28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2b:	8b 40 04             	mov    0x4(%eax),%eax
  802f2e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f36:	8b 40 04             	mov    0x4(%eax),%eax
  802f39:	85 c0                	test   %eax,%eax
  802f3b:	74 0f                	je     802f4c <alloc_block_BF+0x1f1>
  802f3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f40:	8b 40 04             	mov    0x4(%eax),%eax
  802f43:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f46:	8b 12                	mov    (%edx),%edx
  802f48:	89 10                	mov    %edx,(%eax)
  802f4a:	eb 0a                	jmp    802f56 <alloc_block_BF+0x1fb>
  802f4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4f:	8b 00                	mov    (%eax),%eax
  802f51:	a3 38 51 80 00       	mov    %eax,0x805138
  802f56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f59:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f62:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f69:	a1 44 51 80 00       	mov    0x805144,%eax
  802f6e:	48                   	dec    %eax
  802f6f:	a3 44 51 80 00       	mov    %eax,0x805144
				return tmp_block;
  802f74:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f77:	eb 3b                	jmp    802fb4 <alloc_block_BF+0x259>
					best_size=element->size;
			}
		}
		if(best_size != -1)
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  802f79:	a1 40 51 80 00       	mov    0x805140,%eax
  802f7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f81:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f85:	74 07                	je     802f8e <alloc_block_BF+0x233>
  802f87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8a:	8b 00                	mov    (%eax),%eax
  802f8c:	eb 05                	jmp    802f93 <alloc_block_BF+0x238>
  802f8e:	b8 00 00 00 00       	mov    $0x0,%eax
  802f93:	a3 40 51 80 00       	mov    %eax,0x805140
  802f98:	a1 40 51 80 00       	mov    0x805140,%eax
  802f9d:	85 c0                	test   %eax,%eax
  802f9f:	0f 85 44 fe ff ff    	jne    802de9 <alloc_block_BF+0x8e>
  802fa5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fa9:	0f 85 3a fe ff ff    	jne    802de9 <alloc_block_BF+0x8e>
				LIST_REMOVE(&FreeMemBlocksList,element);
				return tmp_block;
			 }
			}
		}
		return NULL ;}
  802faf:	b8 00 00 00 00       	mov    $0x0,%eax
  802fb4:	c9                   	leave  
  802fb5:	c3                   	ret    

00802fb6 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802fb6:	55                   	push   %ebp
  802fb7:	89 e5                	mov    %esp,%ebp
  802fb9:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802fbc:	83 ec 04             	sub    $0x4,%esp
  802fbf:	68 fc 42 80 00       	push   $0x8042fc
  802fc4:	68 04 01 00 00       	push   $0x104
  802fc9:	68 33 42 80 00       	push   $0x804233
  802fce:	e8 54 da ff ff       	call   800a27 <_panic>

00802fd3 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{struct MemBlock * blk_itr;
  802fd3:	55                   	push   %ebp
  802fd4:	89 e5                	mov    %esp,%ebp
  802fd6:	83 ec 18             	sub    $0x18,%esp
struct MemBlock * next;
struct MemBlock * first = LIST_FIRST(&(FreeMemBlocksList));
  802fd9:	a1 38 51 80 00       	mov    0x805138,%eax
  802fde:	89 45 f0             	mov    %eax,-0x10(%ebp)
struct MemBlock * last = LIST_LAST(&(FreeMemBlocksList));
  802fe1:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802fe6:	89 45 ec             	mov    %eax,-0x14(%ebp)

if(LIST_EMPTY(&(FreeMemBlocksList)))
  802fe9:	a1 38 51 80 00       	mov    0x805138,%eax
  802fee:	85 c0                	test   %eax,%eax
  802ff0:	75 68                	jne    80305a <insert_sorted_with_merge_freeList+0x87>
			{

				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  802ff2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ff6:	75 17                	jne    80300f <insert_sorted_with_merge_freeList+0x3c>
  802ff8:	83 ec 04             	sub    $0x4,%esp
  802ffb:	68 10 42 80 00       	push   $0x804210
  803000:	68 14 01 00 00       	push   $0x114
  803005:	68 33 42 80 00       	push   $0x804233
  80300a:	e8 18 da ff ff       	call   800a27 <_panic>
  80300f:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803015:	8b 45 08             	mov    0x8(%ebp),%eax
  803018:	89 10                	mov    %edx,(%eax)
  80301a:	8b 45 08             	mov    0x8(%ebp),%eax
  80301d:	8b 00                	mov    (%eax),%eax
  80301f:	85 c0                	test   %eax,%eax
  803021:	74 0d                	je     803030 <insert_sorted_with_merge_freeList+0x5d>
  803023:	a1 38 51 80 00       	mov    0x805138,%eax
  803028:	8b 55 08             	mov    0x8(%ebp),%edx
  80302b:	89 50 04             	mov    %edx,0x4(%eax)
  80302e:	eb 08                	jmp    803038 <insert_sorted_with_merge_freeList+0x65>
  803030:	8b 45 08             	mov    0x8(%ebp),%eax
  803033:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803038:	8b 45 08             	mov    0x8(%ebp),%eax
  80303b:	a3 38 51 80 00       	mov    %eax,0x805138
  803040:	8b 45 08             	mov    0x8(%ebp),%eax
  803043:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80304a:	a1 44 51 80 00       	mov    0x805144,%eax
  80304f:	40                   	inc    %eax
  803050:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  803055:	e9 d2 06 00 00       	jmp    80372c <insert_sorted_with_merge_freeList+0x759>
				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);

			}
else
{
	if( blockToInsert->sva  < first->sva )
  80305a:	8b 45 08             	mov    0x8(%ebp),%eax
  80305d:	8b 50 08             	mov    0x8(%eax),%edx
  803060:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803063:	8b 40 08             	mov    0x8(%eax),%eax
  803066:	39 c2                	cmp    %eax,%edx
  803068:	0f 83 22 01 00 00    	jae    803190 <insert_sorted_with_merge_freeList+0x1bd>
	{
                if( blockToInsert->sva + blockToInsert->size == first->sva)
  80306e:	8b 45 08             	mov    0x8(%ebp),%eax
  803071:	8b 50 08             	mov    0x8(%eax),%edx
  803074:	8b 45 08             	mov    0x8(%ebp),%eax
  803077:	8b 40 0c             	mov    0xc(%eax),%eax
  80307a:	01 c2                	add    %eax,%edx
  80307c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80307f:	8b 40 08             	mov    0x8(%eax),%eax
  803082:	39 c2                	cmp    %eax,%edx
  803084:	0f 85 9e 00 00 00    	jne    803128 <insert_sorted_with_merge_freeList+0x155>
                {

                	first->sva = blockToInsert->sva;
  80308a:	8b 45 08             	mov    0x8(%ebp),%eax
  80308d:	8b 50 08             	mov    0x8(%eax),%edx
  803090:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803093:	89 50 08             	mov    %edx,0x8(%eax)
                	first->size = first->size + blockToInsert->size;
  803096:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803099:	8b 50 0c             	mov    0xc(%eax),%edx
  80309c:	8b 45 08             	mov    0x8(%ebp),%eax
  80309f:	8b 40 0c             	mov    0xc(%eax),%eax
  8030a2:	01 c2                	add    %eax,%edx
  8030a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030a7:	89 50 0c             	mov    %edx,0xc(%eax)
                	blockToInsert->size = blockToInsert->sva = 0;
  8030aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ad:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8030b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b7:	8b 50 08             	mov    0x8(%eax),%edx
  8030ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8030bd:	89 50 0c             	mov    %edx,0xc(%eax)
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  8030c0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030c4:	75 17                	jne    8030dd <insert_sorted_with_merge_freeList+0x10a>
  8030c6:	83 ec 04             	sub    $0x4,%esp
  8030c9:	68 10 42 80 00       	push   $0x804210
  8030ce:	68 21 01 00 00       	push   $0x121
  8030d3:	68 33 42 80 00       	push   $0x804233
  8030d8:	e8 4a d9 ff ff       	call   800a27 <_panic>
  8030dd:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8030e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e6:	89 10                	mov    %edx,(%eax)
  8030e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030eb:	8b 00                	mov    (%eax),%eax
  8030ed:	85 c0                	test   %eax,%eax
  8030ef:	74 0d                	je     8030fe <insert_sorted_with_merge_freeList+0x12b>
  8030f1:	a1 48 51 80 00       	mov    0x805148,%eax
  8030f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8030f9:	89 50 04             	mov    %edx,0x4(%eax)
  8030fc:	eb 08                	jmp    803106 <insert_sorted_with_merge_freeList+0x133>
  8030fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803101:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803106:	8b 45 08             	mov    0x8(%ebp),%eax
  803109:	a3 48 51 80 00       	mov    %eax,0x805148
  80310e:	8b 45 08             	mov    0x8(%ebp),%eax
  803111:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803118:	a1 54 51 80 00       	mov    0x805154,%eax
  80311d:	40                   	inc    %eax
  80311e:	a3 54 51 80 00       	mov    %eax,0x805154
						}
				}
        }

}
}
  803123:	e9 04 06 00 00       	jmp    80372c <insert_sorted_with_merge_freeList+0x759>
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
                }

                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  803128:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80312c:	75 17                	jne    803145 <insert_sorted_with_merge_freeList+0x172>
  80312e:	83 ec 04             	sub    $0x4,%esp
  803131:	68 10 42 80 00       	push   $0x804210
  803136:	68 26 01 00 00       	push   $0x126
  80313b:	68 33 42 80 00       	push   $0x804233
  803140:	e8 e2 d8 ff ff       	call   800a27 <_panic>
  803145:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80314b:	8b 45 08             	mov    0x8(%ebp),%eax
  80314e:	89 10                	mov    %edx,(%eax)
  803150:	8b 45 08             	mov    0x8(%ebp),%eax
  803153:	8b 00                	mov    (%eax),%eax
  803155:	85 c0                	test   %eax,%eax
  803157:	74 0d                	je     803166 <insert_sorted_with_merge_freeList+0x193>
  803159:	a1 38 51 80 00       	mov    0x805138,%eax
  80315e:	8b 55 08             	mov    0x8(%ebp),%edx
  803161:	89 50 04             	mov    %edx,0x4(%eax)
  803164:	eb 08                	jmp    80316e <insert_sorted_with_merge_freeList+0x19b>
  803166:	8b 45 08             	mov    0x8(%ebp),%eax
  803169:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80316e:	8b 45 08             	mov    0x8(%ebp),%eax
  803171:	a3 38 51 80 00       	mov    %eax,0x805138
  803176:	8b 45 08             	mov    0x8(%ebp),%eax
  803179:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803180:	a1 44 51 80 00       	mov    0x805144,%eax
  803185:	40                   	inc    %eax
  803186:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  80318b:	e9 9c 05 00 00       	jmp    80372c <insert_sorted_with_merge_freeList+0x759>
                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
                }
	}
    else if(blockToInsert->sva > last->sva)
  803190:	8b 45 08             	mov    0x8(%ebp),%eax
  803193:	8b 50 08             	mov    0x8(%eax),%edx
  803196:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803199:	8b 40 08             	mov    0x8(%eax),%eax
  80319c:	39 c2                	cmp    %eax,%edx
  80319e:	0f 86 16 01 00 00    	jbe    8032ba <insert_sorted_with_merge_freeList+0x2e7>
 	{

				if(last->sva + last->size == blockToInsert->sva)
  8031a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031a7:	8b 50 08             	mov    0x8(%eax),%edx
  8031aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031ad:	8b 40 0c             	mov    0xc(%eax),%eax
  8031b0:	01 c2                	add    %eax,%edx
  8031b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b5:	8b 40 08             	mov    0x8(%eax),%eax
  8031b8:	39 c2                	cmp    %eax,%edx
  8031ba:	0f 85 92 00 00 00    	jne    803252 <insert_sorted_with_merge_freeList+0x27f>
				{

					last->size = last->size + blockToInsert->size;
  8031c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031c3:	8b 50 0c             	mov    0xc(%eax),%edx
  8031c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8031cc:	01 c2                	add    %eax,%edx
  8031ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031d1:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->size = blockToInsert->sva = 0;
  8031d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8031de:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e1:	8b 50 08             	mov    0x8(%eax),%edx
  8031e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e7:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  8031ea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031ee:	75 17                	jne    803207 <insert_sorted_with_merge_freeList+0x234>
  8031f0:	83 ec 04             	sub    $0x4,%esp
  8031f3:	68 10 42 80 00       	push   $0x804210
  8031f8:	68 31 01 00 00       	push   $0x131
  8031fd:	68 33 42 80 00       	push   $0x804233
  803202:	e8 20 d8 ff ff       	call   800a27 <_panic>
  803207:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80320d:	8b 45 08             	mov    0x8(%ebp),%eax
  803210:	89 10                	mov    %edx,(%eax)
  803212:	8b 45 08             	mov    0x8(%ebp),%eax
  803215:	8b 00                	mov    (%eax),%eax
  803217:	85 c0                	test   %eax,%eax
  803219:	74 0d                	je     803228 <insert_sorted_with_merge_freeList+0x255>
  80321b:	a1 48 51 80 00       	mov    0x805148,%eax
  803220:	8b 55 08             	mov    0x8(%ebp),%edx
  803223:	89 50 04             	mov    %edx,0x4(%eax)
  803226:	eb 08                	jmp    803230 <insert_sorted_with_merge_freeList+0x25d>
  803228:	8b 45 08             	mov    0x8(%ebp),%eax
  80322b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803230:	8b 45 08             	mov    0x8(%ebp),%eax
  803233:	a3 48 51 80 00       	mov    %eax,0x805148
  803238:	8b 45 08             	mov    0x8(%ebp),%eax
  80323b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803242:	a1 54 51 80 00       	mov    0x805154,%eax
  803247:	40                   	inc    %eax
  803248:	a3 54 51 80 00       	mov    %eax,0x805154
						}
				}
        }

}
}
  80324d:	e9 da 04 00 00       	jmp    80372c <insert_sorted_with_merge_freeList+0x759>

				}

				else
				{
					LIST_INSERT_TAIL(&(FreeMemBlocksList),  blockToInsert);
  803252:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803256:	75 17                	jne    80326f <insert_sorted_with_merge_freeList+0x29c>
  803258:	83 ec 04             	sub    $0x4,%esp
  80325b:	68 b8 42 80 00       	push   $0x8042b8
  803260:	68 37 01 00 00       	push   $0x137
  803265:	68 33 42 80 00       	push   $0x804233
  80326a:	e8 b8 d7 ff ff       	call   800a27 <_panic>
  80326f:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803275:	8b 45 08             	mov    0x8(%ebp),%eax
  803278:	89 50 04             	mov    %edx,0x4(%eax)
  80327b:	8b 45 08             	mov    0x8(%ebp),%eax
  80327e:	8b 40 04             	mov    0x4(%eax),%eax
  803281:	85 c0                	test   %eax,%eax
  803283:	74 0c                	je     803291 <insert_sorted_with_merge_freeList+0x2be>
  803285:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80328a:	8b 55 08             	mov    0x8(%ebp),%edx
  80328d:	89 10                	mov    %edx,(%eax)
  80328f:	eb 08                	jmp    803299 <insert_sorted_with_merge_freeList+0x2c6>
  803291:	8b 45 08             	mov    0x8(%ebp),%eax
  803294:	a3 38 51 80 00       	mov    %eax,0x805138
  803299:	8b 45 08             	mov    0x8(%ebp),%eax
  80329c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032aa:	a1 44 51 80 00       	mov    0x805144,%eax
  8032af:	40                   	inc    %eax
  8032b0:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  8032b5:	e9 72 04 00 00       	jmp    80372c <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  8032ba:	a1 38 51 80 00       	mov    0x805138,%eax
  8032bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032c2:	e9 35 04 00 00       	jmp    8036fc <insert_sorted_with_merge_freeList+0x729>
				{
				     next=LIST_NEXT(blk_itr);
  8032c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ca:	8b 00                	mov    (%eax),%eax
  8032cc:	89 45 e8             	mov    %eax,-0x18(%ebp)


					if( (blockToInsert->sva > blk_itr->sva) )
  8032cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d2:	8b 50 08             	mov    0x8(%eax),%edx
  8032d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d8:	8b 40 08             	mov    0x8(%eax),%eax
  8032db:	39 c2                	cmp    %eax,%edx
  8032dd:	0f 86 11 04 00 00    	jbe    8036f4 <insert_sorted_with_merge_freeList+0x721>
						{
							if(((blk_itr->sva) + (blk_itr->size) < blockToInsert->sva && (blockToInsert->sva) + (blockToInsert->size) < next->sva))
  8032e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e6:	8b 50 08             	mov    0x8(%eax),%edx
  8032e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8032ef:	01 c2                	add    %eax,%edx
  8032f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f4:	8b 40 08             	mov    0x8(%eax),%eax
  8032f7:	39 c2                	cmp    %eax,%edx
  8032f9:	0f 83 8b 00 00 00    	jae    80338a <insert_sorted_with_merge_freeList+0x3b7>
  8032ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803302:	8b 50 08             	mov    0x8(%eax),%edx
  803305:	8b 45 08             	mov    0x8(%ebp),%eax
  803308:	8b 40 0c             	mov    0xc(%eax),%eax
  80330b:	01 c2                	add    %eax,%edx
  80330d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803310:	8b 40 08             	mov    0x8(%eax),%eax
  803313:	39 c2                	cmp    %eax,%edx
  803315:	73 73                	jae    80338a <insert_sorted_with_merge_freeList+0x3b7>
							{
								LIST_INSERT_AFTER(&(FreeMemBlocksList), blk_itr, blockToInsert);
  803317:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80331b:	74 06                	je     803323 <insert_sorted_with_merge_freeList+0x350>
  80331d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803321:	75 17                	jne    80333a <insert_sorted_with_merge_freeList+0x367>
  803323:	83 ec 04             	sub    $0x4,%esp
  803326:	68 84 42 80 00       	push   $0x804284
  80332b:	68 48 01 00 00       	push   $0x148
  803330:	68 33 42 80 00       	push   $0x804233
  803335:	e8 ed d6 ff ff       	call   800a27 <_panic>
  80333a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80333d:	8b 10                	mov    (%eax),%edx
  80333f:	8b 45 08             	mov    0x8(%ebp),%eax
  803342:	89 10                	mov    %edx,(%eax)
  803344:	8b 45 08             	mov    0x8(%ebp),%eax
  803347:	8b 00                	mov    (%eax),%eax
  803349:	85 c0                	test   %eax,%eax
  80334b:	74 0b                	je     803358 <insert_sorted_with_merge_freeList+0x385>
  80334d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803350:	8b 00                	mov    (%eax),%eax
  803352:	8b 55 08             	mov    0x8(%ebp),%edx
  803355:	89 50 04             	mov    %edx,0x4(%eax)
  803358:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80335b:	8b 55 08             	mov    0x8(%ebp),%edx
  80335e:	89 10                	mov    %edx,(%eax)
  803360:	8b 45 08             	mov    0x8(%ebp),%eax
  803363:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803366:	89 50 04             	mov    %edx,0x4(%eax)
  803369:	8b 45 08             	mov    0x8(%ebp),%eax
  80336c:	8b 00                	mov    (%eax),%eax
  80336e:	85 c0                	test   %eax,%eax
  803370:	75 08                	jne    80337a <insert_sorted_with_merge_freeList+0x3a7>
  803372:	8b 45 08             	mov    0x8(%ebp),%eax
  803375:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80337a:	a1 44 51 80 00       	mov    0x805144,%eax
  80337f:	40                   	inc    %eax
  803380:	a3 44 51 80 00       	mov    %eax,0x805144
								break;
  803385:	e9 a2 03 00 00       	jmp    80372c <insert_sorted_with_merge_freeList+0x759>

							}
							else if((blockToInsert->sva + blockToInsert->size) < next->sva  && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  80338a:	8b 45 08             	mov    0x8(%ebp),%eax
  80338d:	8b 50 08             	mov    0x8(%eax),%edx
  803390:	8b 45 08             	mov    0x8(%ebp),%eax
  803393:	8b 40 0c             	mov    0xc(%eax),%eax
  803396:	01 c2                	add    %eax,%edx
  803398:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80339b:	8b 40 08             	mov    0x8(%eax),%eax
  80339e:	39 c2                	cmp    %eax,%edx
  8033a0:	0f 83 ae 00 00 00    	jae    803454 <insert_sorted_with_merge_freeList+0x481>
  8033a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a9:	8b 50 08             	mov    0x8(%eax),%edx
  8033ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033af:	8b 48 08             	mov    0x8(%eax),%ecx
  8033b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b5:	8b 40 0c             	mov    0xc(%eax),%eax
  8033b8:	01 c8                	add    %ecx,%eax
  8033ba:	39 c2                	cmp    %eax,%edx
  8033bc:	0f 85 92 00 00 00    	jne    803454 <insert_sorted_with_merge_freeList+0x481>
							{

								blk_itr->size=blk_itr->size+blockToInsert->size;
  8033c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c5:	8b 50 0c             	mov    0xc(%eax),%edx
  8033c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8033cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8033ce:	01 c2                	add    %eax,%edx
  8033d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d3:	89 50 0c             	mov    %edx,0xc(%eax)
								 blockToInsert->size=blockToInsert->sva=0;
  8033d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8033e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e3:	8b 50 08             	mov    0x8(%eax),%edx
  8033e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e9:	89 50 0c             	mov    %edx,0xc(%eax)
								 LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  8033ec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033f0:	75 17                	jne    803409 <insert_sorted_with_merge_freeList+0x436>
  8033f2:	83 ec 04             	sub    $0x4,%esp
  8033f5:	68 10 42 80 00       	push   $0x804210
  8033fa:	68 51 01 00 00       	push   $0x151
  8033ff:	68 33 42 80 00       	push   $0x804233
  803404:	e8 1e d6 ff ff       	call   800a27 <_panic>
  803409:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80340f:	8b 45 08             	mov    0x8(%ebp),%eax
  803412:	89 10                	mov    %edx,(%eax)
  803414:	8b 45 08             	mov    0x8(%ebp),%eax
  803417:	8b 00                	mov    (%eax),%eax
  803419:	85 c0                	test   %eax,%eax
  80341b:	74 0d                	je     80342a <insert_sorted_with_merge_freeList+0x457>
  80341d:	a1 48 51 80 00       	mov    0x805148,%eax
  803422:	8b 55 08             	mov    0x8(%ebp),%edx
  803425:	89 50 04             	mov    %edx,0x4(%eax)
  803428:	eb 08                	jmp    803432 <insert_sorted_with_merge_freeList+0x45f>
  80342a:	8b 45 08             	mov    0x8(%ebp),%eax
  80342d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803432:	8b 45 08             	mov    0x8(%ebp),%eax
  803435:	a3 48 51 80 00       	mov    %eax,0x805148
  80343a:	8b 45 08             	mov    0x8(%ebp),%eax
  80343d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803444:	a1 54 51 80 00       	mov    0x805154,%eax
  803449:	40                   	inc    %eax
  80344a:	a3 54 51 80 00       	mov    %eax,0x805154
								 break;
  80344f:	e9 d8 02 00 00       	jmp    80372c <insert_sorted_with_merge_freeList+0x759>

							}
							else if( (blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva > (blk_itr->sva + blk_itr->size))
  803454:	8b 45 08             	mov    0x8(%ebp),%eax
  803457:	8b 50 08             	mov    0x8(%eax),%edx
  80345a:	8b 45 08             	mov    0x8(%ebp),%eax
  80345d:	8b 40 0c             	mov    0xc(%eax),%eax
  803460:	01 c2                	add    %eax,%edx
  803462:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803465:	8b 40 08             	mov    0x8(%eax),%eax
  803468:	39 c2                	cmp    %eax,%edx
  80346a:	0f 85 ba 00 00 00    	jne    80352a <insert_sorted_with_merge_freeList+0x557>
  803470:	8b 45 08             	mov    0x8(%ebp),%eax
  803473:	8b 50 08             	mov    0x8(%eax),%edx
  803476:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803479:	8b 48 08             	mov    0x8(%eax),%ecx
  80347c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80347f:	8b 40 0c             	mov    0xc(%eax),%eax
  803482:	01 c8                	add    %ecx,%eax
  803484:	39 c2                	cmp    %eax,%edx
  803486:	0f 86 9e 00 00 00    	jbe    80352a <insert_sorted_with_merge_freeList+0x557>
							{
								next->size = next->size + blockToInsert->size;
  80348c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80348f:	8b 50 0c             	mov    0xc(%eax),%edx
  803492:	8b 45 08             	mov    0x8(%ebp),%eax
  803495:	8b 40 0c             	mov    0xc(%eax),%eax
  803498:	01 c2                	add    %eax,%edx
  80349a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80349d:	89 50 0c             	mov    %edx,0xc(%eax)
								next->sva = blockToInsert->sva;
  8034a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a3:	8b 50 08             	mov    0x8(%eax),%edx
  8034a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034a9:	89 50 08             	mov    %edx,0x8(%eax)

								blockToInsert->size = blockToInsert->sva = 0;
  8034ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8034af:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8034b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b9:	8b 50 08             	mov    0x8(%eax),%edx
  8034bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8034bf:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  8034c2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034c6:	75 17                	jne    8034df <insert_sorted_with_merge_freeList+0x50c>
  8034c8:	83 ec 04             	sub    $0x4,%esp
  8034cb:	68 10 42 80 00       	push   $0x804210
  8034d0:	68 5b 01 00 00       	push   $0x15b
  8034d5:	68 33 42 80 00       	push   $0x804233
  8034da:	e8 48 d5 ff ff       	call   800a27 <_panic>
  8034df:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8034e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e8:	89 10                	mov    %edx,(%eax)
  8034ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ed:	8b 00                	mov    (%eax),%eax
  8034ef:	85 c0                	test   %eax,%eax
  8034f1:	74 0d                	je     803500 <insert_sorted_with_merge_freeList+0x52d>
  8034f3:	a1 48 51 80 00       	mov    0x805148,%eax
  8034f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8034fb:	89 50 04             	mov    %edx,0x4(%eax)
  8034fe:	eb 08                	jmp    803508 <insert_sorted_with_merge_freeList+0x535>
  803500:	8b 45 08             	mov    0x8(%ebp),%eax
  803503:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803508:	8b 45 08             	mov    0x8(%ebp),%eax
  80350b:	a3 48 51 80 00       	mov    %eax,0x805148
  803510:	8b 45 08             	mov    0x8(%ebp),%eax
  803513:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80351a:	a1 54 51 80 00       	mov    0x805154,%eax
  80351f:	40                   	inc    %eax
  803520:	a3 54 51 80 00       	mov    %eax,0x805154
								break;
  803525:	e9 02 02 00 00       	jmp    80372c <insert_sorted_with_merge_freeList+0x759>
							}
							else if ((blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  80352a:	8b 45 08             	mov    0x8(%ebp),%eax
  80352d:	8b 50 08             	mov    0x8(%eax),%edx
  803530:	8b 45 08             	mov    0x8(%ebp),%eax
  803533:	8b 40 0c             	mov    0xc(%eax),%eax
  803536:	01 c2                	add    %eax,%edx
  803538:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80353b:	8b 40 08             	mov    0x8(%eax),%eax
  80353e:	39 c2                	cmp    %eax,%edx
  803540:	0f 85 ae 01 00 00    	jne    8036f4 <insert_sorted_with_merge_freeList+0x721>
  803546:	8b 45 08             	mov    0x8(%ebp),%eax
  803549:	8b 50 08             	mov    0x8(%eax),%edx
  80354c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80354f:	8b 48 08             	mov    0x8(%eax),%ecx
  803552:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803555:	8b 40 0c             	mov    0xc(%eax),%eax
  803558:	01 c8                	add    %ecx,%eax
  80355a:	39 c2                	cmp    %eax,%edx
  80355c:	0f 85 92 01 00 00    	jne    8036f4 <insert_sorted_with_merge_freeList+0x721>
							{
								blk_itr->size = blk_itr->size + blockToInsert->size + next->size;
  803562:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803565:	8b 50 0c             	mov    0xc(%eax),%edx
  803568:	8b 45 08             	mov    0x8(%ebp),%eax
  80356b:	8b 40 0c             	mov    0xc(%eax),%eax
  80356e:	01 c2                	add    %eax,%edx
  803570:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803573:	8b 40 0c             	mov    0xc(%eax),%eax
  803576:	01 c2                	add    %eax,%edx
  803578:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80357b:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size = blockToInsert->sva=0;
  80357e:	8b 45 08             	mov    0x8(%ebp),%eax
  803581:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803588:	8b 45 08             	mov    0x8(%ebp),%eax
  80358b:	8b 50 08             	mov    0x8(%eax),%edx
  80358e:	8b 45 08             	mov    0x8(%ebp),%eax
  803591:	89 50 0c             	mov    %edx,0xc(%eax)
								next->size = next->sva = 0;
  803594:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803597:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80359e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035a1:	8b 50 08             	mov    0x8(%eax),%edx
  8035a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035a7:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_REMOVE(&FreeMemBlocksList, next);
  8035aa:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8035ae:	75 17                	jne    8035c7 <insert_sorted_with_merge_freeList+0x5f4>
  8035b0:	83 ec 04             	sub    $0x4,%esp
  8035b3:	68 db 42 80 00       	push   $0x8042db
  8035b8:	68 63 01 00 00       	push   $0x163
  8035bd:	68 33 42 80 00       	push   $0x804233
  8035c2:	e8 60 d4 ff ff       	call   800a27 <_panic>
  8035c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035ca:	8b 00                	mov    (%eax),%eax
  8035cc:	85 c0                	test   %eax,%eax
  8035ce:	74 10                	je     8035e0 <insert_sorted_with_merge_freeList+0x60d>
  8035d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035d3:	8b 00                	mov    (%eax),%eax
  8035d5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8035d8:	8b 52 04             	mov    0x4(%edx),%edx
  8035db:	89 50 04             	mov    %edx,0x4(%eax)
  8035de:	eb 0b                	jmp    8035eb <insert_sorted_with_merge_freeList+0x618>
  8035e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035e3:	8b 40 04             	mov    0x4(%eax),%eax
  8035e6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8035eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035ee:	8b 40 04             	mov    0x4(%eax),%eax
  8035f1:	85 c0                	test   %eax,%eax
  8035f3:	74 0f                	je     803604 <insert_sorted_with_merge_freeList+0x631>
  8035f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035f8:	8b 40 04             	mov    0x4(%eax),%eax
  8035fb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8035fe:	8b 12                	mov    (%edx),%edx
  803600:	89 10                	mov    %edx,(%eax)
  803602:	eb 0a                	jmp    80360e <insert_sorted_with_merge_freeList+0x63b>
  803604:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803607:	8b 00                	mov    (%eax),%eax
  803609:	a3 38 51 80 00       	mov    %eax,0x805138
  80360e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803611:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803617:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80361a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803621:	a1 44 51 80 00       	mov    0x805144,%eax
  803626:	48                   	dec    %eax
  803627:	a3 44 51 80 00       	mov    %eax,0x805144
								LIST_INSERT_HEAD(&AvailableMemBlocksList, next );
  80362c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803630:	75 17                	jne    803649 <insert_sorted_with_merge_freeList+0x676>
  803632:	83 ec 04             	sub    $0x4,%esp
  803635:	68 10 42 80 00       	push   $0x804210
  80363a:	68 64 01 00 00       	push   $0x164
  80363f:	68 33 42 80 00       	push   $0x804233
  803644:	e8 de d3 ff ff       	call   800a27 <_panic>
  803649:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80364f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803652:	89 10                	mov    %edx,(%eax)
  803654:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803657:	8b 00                	mov    (%eax),%eax
  803659:	85 c0                	test   %eax,%eax
  80365b:	74 0d                	je     80366a <insert_sorted_with_merge_freeList+0x697>
  80365d:	a1 48 51 80 00       	mov    0x805148,%eax
  803662:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803665:	89 50 04             	mov    %edx,0x4(%eax)
  803668:	eb 08                	jmp    803672 <insert_sorted_with_merge_freeList+0x69f>
  80366a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80366d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803672:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803675:	a3 48 51 80 00       	mov    %eax,0x805148
  80367a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80367d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803684:	a1 54 51 80 00       	mov    0x805154,%eax
  803689:	40                   	inc    %eax
  80368a:	a3 54 51 80 00       	mov    %eax,0x805154
							    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  80368f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803693:	75 17                	jne    8036ac <insert_sorted_with_merge_freeList+0x6d9>
  803695:	83 ec 04             	sub    $0x4,%esp
  803698:	68 10 42 80 00       	push   $0x804210
  80369d:	68 65 01 00 00       	push   $0x165
  8036a2:	68 33 42 80 00       	push   $0x804233
  8036a7:	e8 7b d3 ff ff       	call   800a27 <_panic>
  8036ac:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8036b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b5:	89 10                	mov    %edx,(%eax)
  8036b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ba:	8b 00                	mov    (%eax),%eax
  8036bc:	85 c0                	test   %eax,%eax
  8036be:	74 0d                	je     8036cd <insert_sorted_with_merge_freeList+0x6fa>
  8036c0:	a1 48 51 80 00       	mov    0x805148,%eax
  8036c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8036c8:	89 50 04             	mov    %edx,0x4(%eax)
  8036cb:	eb 08                	jmp    8036d5 <insert_sorted_with_merge_freeList+0x702>
  8036cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8036d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d8:	a3 48 51 80 00       	mov    %eax,0x805148
  8036dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036e7:	a1 54 51 80 00       	mov    0x805154,%eax
  8036ec:	40                   	inc    %eax
  8036ed:	a3 54 51 80 00       	mov    %eax,0x805154
								break;
  8036f2:	eb 38                	jmp    80372c <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  8036f4:	a1 40 51 80 00       	mov    0x805140,%eax
  8036f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803700:	74 07                	je     803709 <insert_sorted_with_merge_freeList+0x736>
  803702:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803705:	8b 00                	mov    (%eax),%eax
  803707:	eb 05                	jmp    80370e <insert_sorted_with_merge_freeList+0x73b>
  803709:	b8 00 00 00 00       	mov    $0x0,%eax
  80370e:	a3 40 51 80 00       	mov    %eax,0x805140
  803713:	a1 40 51 80 00       	mov    0x805140,%eax
  803718:	85 c0                	test   %eax,%eax
  80371a:	0f 85 a7 fb ff ff    	jne    8032c7 <insert_sorted_with_merge_freeList+0x2f4>
  803720:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803724:	0f 85 9d fb ff ff    	jne    8032c7 <insert_sorted_with_merge_freeList+0x2f4>
						}
				}
        }

}
}
  80372a:	eb 00                	jmp    80372c <insert_sorted_with_merge_freeList+0x759>
  80372c:	90                   	nop
  80372d:	c9                   	leave  
  80372e:	c3                   	ret    
  80372f:	90                   	nop

00803730 <__udivdi3>:
  803730:	55                   	push   %ebp
  803731:	57                   	push   %edi
  803732:	56                   	push   %esi
  803733:	53                   	push   %ebx
  803734:	83 ec 1c             	sub    $0x1c,%esp
  803737:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80373b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80373f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803743:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803747:	89 ca                	mov    %ecx,%edx
  803749:	89 f8                	mov    %edi,%eax
  80374b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80374f:	85 f6                	test   %esi,%esi
  803751:	75 2d                	jne    803780 <__udivdi3+0x50>
  803753:	39 cf                	cmp    %ecx,%edi
  803755:	77 65                	ja     8037bc <__udivdi3+0x8c>
  803757:	89 fd                	mov    %edi,%ebp
  803759:	85 ff                	test   %edi,%edi
  80375b:	75 0b                	jne    803768 <__udivdi3+0x38>
  80375d:	b8 01 00 00 00       	mov    $0x1,%eax
  803762:	31 d2                	xor    %edx,%edx
  803764:	f7 f7                	div    %edi
  803766:	89 c5                	mov    %eax,%ebp
  803768:	31 d2                	xor    %edx,%edx
  80376a:	89 c8                	mov    %ecx,%eax
  80376c:	f7 f5                	div    %ebp
  80376e:	89 c1                	mov    %eax,%ecx
  803770:	89 d8                	mov    %ebx,%eax
  803772:	f7 f5                	div    %ebp
  803774:	89 cf                	mov    %ecx,%edi
  803776:	89 fa                	mov    %edi,%edx
  803778:	83 c4 1c             	add    $0x1c,%esp
  80377b:	5b                   	pop    %ebx
  80377c:	5e                   	pop    %esi
  80377d:	5f                   	pop    %edi
  80377e:	5d                   	pop    %ebp
  80377f:	c3                   	ret    
  803780:	39 ce                	cmp    %ecx,%esi
  803782:	77 28                	ja     8037ac <__udivdi3+0x7c>
  803784:	0f bd fe             	bsr    %esi,%edi
  803787:	83 f7 1f             	xor    $0x1f,%edi
  80378a:	75 40                	jne    8037cc <__udivdi3+0x9c>
  80378c:	39 ce                	cmp    %ecx,%esi
  80378e:	72 0a                	jb     80379a <__udivdi3+0x6a>
  803790:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803794:	0f 87 9e 00 00 00    	ja     803838 <__udivdi3+0x108>
  80379a:	b8 01 00 00 00       	mov    $0x1,%eax
  80379f:	89 fa                	mov    %edi,%edx
  8037a1:	83 c4 1c             	add    $0x1c,%esp
  8037a4:	5b                   	pop    %ebx
  8037a5:	5e                   	pop    %esi
  8037a6:	5f                   	pop    %edi
  8037a7:	5d                   	pop    %ebp
  8037a8:	c3                   	ret    
  8037a9:	8d 76 00             	lea    0x0(%esi),%esi
  8037ac:	31 ff                	xor    %edi,%edi
  8037ae:	31 c0                	xor    %eax,%eax
  8037b0:	89 fa                	mov    %edi,%edx
  8037b2:	83 c4 1c             	add    $0x1c,%esp
  8037b5:	5b                   	pop    %ebx
  8037b6:	5e                   	pop    %esi
  8037b7:	5f                   	pop    %edi
  8037b8:	5d                   	pop    %ebp
  8037b9:	c3                   	ret    
  8037ba:	66 90                	xchg   %ax,%ax
  8037bc:	89 d8                	mov    %ebx,%eax
  8037be:	f7 f7                	div    %edi
  8037c0:	31 ff                	xor    %edi,%edi
  8037c2:	89 fa                	mov    %edi,%edx
  8037c4:	83 c4 1c             	add    $0x1c,%esp
  8037c7:	5b                   	pop    %ebx
  8037c8:	5e                   	pop    %esi
  8037c9:	5f                   	pop    %edi
  8037ca:	5d                   	pop    %ebp
  8037cb:	c3                   	ret    
  8037cc:	bd 20 00 00 00       	mov    $0x20,%ebp
  8037d1:	89 eb                	mov    %ebp,%ebx
  8037d3:	29 fb                	sub    %edi,%ebx
  8037d5:	89 f9                	mov    %edi,%ecx
  8037d7:	d3 e6                	shl    %cl,%esi
  8037d9:	89 c5                	mov    %eax,%ebp
  8037db:	88 d9                	mov    %bl,%cl
  8037dd:	d3 ed                	shr    %cl,%ebp
  8037df:	89 e9                	mov    %ebp,%ecx
  8037e1:	09 f1                	or     %esi,%ecx
  8037e3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8037e7:	89 f9                	mov    %edi,%ecx
  8037e9:	d3 e0                	shl    %cl,%eax
  8037eb:	89 c5                	mov    %eax,%ebp
  8037ed:	89 d6                	mov    %edx,%esi
  8037ef:	88 d9                	mov    %bl,%cl
  8037f1:	d3 ee                	shr    %cl,%esi
  8037f3:	89 f9                	mov    %edi,%ecx
  8037f5:	d3 e2                	shl    %cl,%edx
  8037f7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8037fb:	88 d9                	mov    %bl,%cl
  8037fd:	d3 e8                	shr    %cl,%eax
  8037ff:	09 c2                	or     %eax,%edx
  803801:	89 d0                	mov    %edx,%eax
  803803:	89 f2                	mov    %esi,%edx
  803805:	f7 74 24 0c          	divl   0xc(%esp)
  803809:	89 d6                	mov    %edx,%esi
  80380b:	89 c3                	mov    %eax,%ebx
  80380d:	f7 e5                	mul    %ebp
  80380f:	39 d6                	cmp    %edx,%esi
  803811:	72 19                	jb     80382c <__udivdi3+0xfc>
  803813:	74 0b                	je     803820 <__udivdi3+0xf0>
  803815:	89 d8                	mov    %ebx,%eax
  803817:	31 ff                	xor    %edi,%edi
  803819:	e9 58 ff ff ff       	jmp    803776 <__udivdi3+0x46>
  80381e:	66 90                	xchg   %ax,%ax
  803820:	8b 54 24 08          	mov    0x8(%esp),%edx
  803824:	89 f9                	mov    %edi,%ecx
  803826:	d3 e2                	shl    %cl,%edx
  803828:	39 c2                	cmp    %eax,%edx
  80382a:	73 e9                	jae    803815 <__udivdi3+0xe5>
  80382c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80382f:	31 ff                	xor    %edi,%edi
  803831:	e9 40 ff ff ff       	jmp    803776 <__udivdi3+0x46>
  803836:	66 90                	xchg   %ax,%ax
  803838:	31 c0                	xor    %eax,%eax
  80383a:	e9 37 ff ff ff       	jmp    803776 <__udivdi3+0x46>
  80383f:	90                   	nop

00803840 <__umoddi3>:
  803840:	55                   	push   %ebp
  803841:	57                   	push   %edi
  803842:	56                   	push   %esi
  803843:	53                   	push   %ebx
  803844:	83 ec 1c             	sub    $0x1c,%esp
  803847:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80384b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80384f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803853:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803857:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80385b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80385f:	89 f3                	mov    %esi,%ebx
  803861:	89 fa                	mov    %edi,%edx
  803863:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803867:	89 34 24             	mov    %esi,(%esp)
  80386a:	85 c0                	test   %eax,%eax
  80386c:	75 1a                	jne    803888 <__umoddi3+0x48>
  80386e:	39 f7                	cmp    %esi,%edi
  803870:	0f 86 a2 00 00 00    	jbe    803918 <__umoddi3+0xd8>
  803876:	89 c8                	mov    %ecx,%eax
  803878:	89 f2                	mov    %esi,%edx
  80387a:	f7 f7                	div    %edi
  80387c:	89 d0                	mov    %edx,%eax
  80387e:	31 d2                	xor    %edx,%edx
  803880:	83 c4 1c             	add    $0x1c,%esp
  803883:	5b                   	pop    %ebx
  803884:	5e                   	pop    %esi
  803885:	5f                   	pop    %edi
  803886:	5d                   	pop    %ebp
  803887:	c3                   	ret    
  803888:	39 f0                	cmp    %esi,%eax
  80388a:	0f 87 ac 00 00 00    	ja     80393c <__umoddi3+0xfc>
  803890:	0f bd e8             	bsr    %eax,%ebp
  803893:	83 f5 1f             	xor    $0x1f,%ebp
  803896:	0f 84 ac 00 00 00    	je     803948 <__umoddi3+0x108>
  80389c:	bf 20 00 00 00       	mov    $0x20,%edi
  8038a1:	29 ef                	sub    %ebp,%edi
  8038a3:	89 fe                	mov    %edi,%esi
  8038a5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8038a9:	89 e9                	mov    %ebp,%ecx
  8038ab:	d3 e0                	shl    %cl,%eax
  8038ad:	89 d7                	mov    %edx,%edi
  8038af:	89 f1                	mov    %esi,%ecx
  8038b1:	d3 ef                	shr    %cl,%edi
  8038b3:	09 c7                	or     %eax,%edi
  8038b5:	89 e9                	mov    %ebp,%ecx
  8038b7:	d3 e2                	shl    %cl,%edx
  8038b9:	89 14 24             	mov    %edx,(%esp)
  8038bc:	89 d8                	mov    %ebx,%eax
  8038be:	d3 e0                	shl    %cl,%eax
  8038c0:	89 c2                	mov    %eax,%edx
  8038c2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8038c6:	d3 e0                	shl    %cl,%eax
  8038c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8038cc:	8b 44 24 08          	mov    0x8(%esp),%eax
  8038d0:	89 f1                	mov    %esi,%ecx
  8038d2:	d3 e8                	shr    %cl,%eax
  8038d4:	09 d0                	or     %edx,%eax
  8038d6:	d3 eb                	shr    %cl,%ebx
  8038d8:	89 da                	mov    %ebx,%edx
  8038da:	f7 f7                	div    %edi
  8038dc:	89 d3                	mov    %edx,%ebx
  8038de:	f7 24 24             	mull   (%esp)
  8038e1:	89 c6                	mov    %eax,%esi
  8038e3:	89 d1                	mov    %edx,%ecx
  8038e5:	39 d3                	cmp    %edx,%ebx
  8038e7:	0f 82 87 00 00 00    	jb     803974 <__umoddi3+0x134>
  8038ed:	0f 84 91 00 00 00    	je     803984 <__umoddi3+0x144>
  8038f3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8038f7:	29 f2                	sub    %esi,%edx
  8038f9:	19 cb                	sbb    %ecx,%ebx
  8038fb:	89 d8                	mov    %ebx,%eax
  8038fd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803901:	d3 e0                	shl    %cl,%eax
  803903:	89 e9                	mov    %ebp,%ecx
  803905:	d3 ea                	shr    %cl,%edx
  803907:	09 d0                	or     %edx,%eax
  803909:	89 e9                	mov    %ebp,%ecx
  80390b:	d3 eb                	shr    %cl,%ebx
  80390d:	89 da                	mov    %ebx,%edx
  80390f:	83 c4 1c             	add    $0x1c,%esp
  803912:	5b                   	pop    %ebx
  803913:	5e                   	pop    %esi
  803914:	5f                   	pop    %edi
  803915:	5d                   	pop    %ebp
  803916:	c3                   	ret    
  803917:	90                   	nop
  803918:	89 fd                	mov    %edi,%ebp
  80391a:	85 ff                	test   %edi,%edi
  80391c:	75 0b                	jne    803929 <__umoddi3+0xe9>
  80391e:	b8 01 00 00 00       	mov    $0x1,%eax
  803923:	31 d2                	xor    %edx,%edx
  803925:	f7 f7                	div    %edi
  803927:	89 c5                	mov    %eax,%ebp
  803929:	89 f0                	mov    %esi,%eax
  80392b:	31 d2                	xor    %edx,%edx
  80392d:	f7 f5                	div    %ebp
  80392f:	89 c8                	mov    %ecx,%eax
  803931:	f7 f5                	div    %ebp
  803933:	89 d0                	mov    %edx,%eax
  803935:	e9 44 ff ff ff       	jmp    80387e <__umoddi3+0x3e>
  80393a:	66 90                	xchg   %ax,%ax
  80393c:	89 c8                	mov    %ecx,%eax
  80393e:	89 f2                	mov    %esi,%edx
  803940:	83 c4 1c             	add    $0x1c,%esp
  803943:	5b                   	pop    %ebx
  803944:	5e                   	pop    %esi
  803945:	5f                   	pop    %edi
  803946:	5d                   	pop    %ebp
  803947:	c3                   	ret    
  803948:	3b 04 24             	cmp    (%esp),%eax
  80394b:	72 06                	jb     803953 <__umoddi3+0x113>
  80394d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803951:	77 0f                	ja     803962 <__umoddi3+0x122>
  803953:	89 f2                	mov    %esi,%edx
  803955:	29 f9                	sub    %edi,%ecx
  803957:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80395b:	89 14 24             	mov    %edx,(%esp)
  80395e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803962:	8b 44 24 04          	mov    0x4(%esp),%eax
  803966:	8b 14 24             	mov    (%esp),%edx
  803969:	83 c4 1c             	add    $0x1c,%esp
  80396c:	5b                   	pop    %ebx
  80396d:	5e                   	pop    %esi
  80396e:	5f                   	pop    %edi
  80396f:	5d                   	pop    %ebp
  803970:	c3                   	ret    
  803971:	8d 76 00             	lea    0x0(%esi),%esi
  803974:	2b 04 24             	sub    (%esp),%eax
  803977:	19 fa                	sbb    %edi,%edx
  803979:	89 d1                	mov    %edx,%ecx
  80397b:	89 c6                	mov    %eax,%esi
  80397d:	e9 71 ff ff ff       	jmp    8038f3 <__umoddi3+0xb3>
  803982:	66 90                	xchg   %ax,%ax
  803984:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803988:	72 ea                	jb     803974 <__umoddi3+0x134>
  80398a:	89 d9                	mov    %ebx,%ecx
  80398c:	e9 62 ff ff ff       	jmp    8038f3 <__umoddi3+0xb3>
