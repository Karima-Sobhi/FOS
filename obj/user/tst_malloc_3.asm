
obj/user/tst_malloc_3:     file format elf32-i386


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
  800031:	e8 f6 0d 00 00       	call   800e2c <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
	short b;
	int c;
};

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	81 ec 20 01 00 00    	sub    $0x120,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  800043:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800047:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004e:	eb 29                	jmp    800079 <_main+0x41>
		{
			if (myEnv->__uptr_pws[i].empty)
  800050:	a1 20 50 80 00       	mov    0x805020,%eax
  800055:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80005b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80005e:	89 d0                	mov    %edx,%eax
  800060:	01 c0                	add    %eax,%eax
  800062:	01 d0                	add    %edx,%eax
  800064:	c1 e0 03             	shl    $0x3,%eax
  800067:	01 c8                	add    %ecx,%eax
  800069:	8a 40 04             	mov    0x4(%eax),%al
  80006c:	84 c0                	test   %al,%al
  80006e:	74 06                	je     800076 <_main+0x3e>
			{
				fullWS = 0;
  800070:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  800074:	eb 12                	jmp    800088 <_main+0x50>
void _main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800076:	ff 45 f0             	incl   -0x10(%ebp)
  800079:	a1 20 50 80 00       	mov    0x805020,%eax
  80007e:	8b 50 74             	mov    0x74(%eax),%edx
  800081:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800084:	39 c2                	cmp    %eax,%edx
  800086:	77 c8                	ja     800050 <_main+0x18>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800088:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  80008c:	74 14                	je     8000a2 <_main+0x6a>
  80008e:	83 ec 04             	sub    $0x4,%esp
  800091:	68 e0 3e 80 00       	push   $0x803ee0
  800096:	6a 1a                	push   $0x1a
  800098:	68 fc 3e 80 00       	push   $0x803efc
  80009d:	e8 c6 0e 00 00       	call   800f68 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000a2:	83 ec 0c             	sub    $0xc,%esp
  8000a5:	6a 00                	push   $0x0
  8000a7:	e8 9c 20 00 00       	call   802148 <malloc>
  8000ac:	83 c4 10             	add    $0x10,%esp





	int Mega = 1024*1024;
  8000af:	c7 45 e4 00 00 10 00 	movl   $0x100000,-0x1c(%ebp)
	int kilo = 1024;
  8000b6:	c7 45 e0 00 04 00 00 	movl   $0x400,-0x20(%ebp)
	char minByte = 1<<7;
  8000bd:	c6 45 df 80          	movb   $0x80,-0x21(%ebp)
	char maxByte = 0x7F;
  8000c1:	c6 45 de 7f          	movb   $0x7f,-0x22(%ebp)
	short minShort = 1<<15 ;
  8000c5:	66 c7 45 dc 00 80    	movw   $0x8000,-0x24(%ebp)
	short maxShort = 0x7FFF;
  8000cb:	66 c7 45 da ff 7f    	movw   $0x7fff,-0x26(%ebp)
	int minInt = 1<<31 ;
  8000d1:	c7 45 d4 00 00 00 80 	movl   $0x80000000,-0x2c(%ebp)
	int maxInt = 0x7FFFFFFF;
  8000d8:	c7 45 d0 ff ff ff 7f 	movl   $0x7fffffff,-0x30(%ebp)
	char *byteArr, *byteArr2 ;
	short *shortArr, *shortArr2 ;
	int *intArr;
	struct MyStruct *structArr ;
	int lastIndexOfByte, lastIndexOfByte2, lastIndexOfShort, lastIndexOfShort2, lastIndexOfInt, lastIndexOfStruct;
	int start_freeFrames = sys_calculate_free_frames() ;
  8000df:	e8 92 24 00 00       	call   802576 <sys_calculate_free_frames>
  8000e4:	89 45 cc             	mov    %eax,-0x34(%ebp)

	void* ptr_allocations[20] = {0};
  8000e7:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  8000ed:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f7:	89 d7                	mov    %edx,%edi
  8000f9:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		//2 MB
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000fb:	e8 16 25 00 00       	call   802616 <sys_pf_calculate_allocated_pages>
  800100:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  800103:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800106:	01 c0                	add    %eax,%eax
  800108:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	50                   	push   %eax
  80010f:	e8 34 20 00 00       	call   802148 <malloc>
  800114:	83 c4 10             	add    $0x10,%esp
  800117:	89 85 dc fe ff ff    	mov    %eax,-0x124(%ebp)
		if ((uint32) ptr_allocations[0] <  (USER_HEAP_START) || (uint32) ptr_allocations[0] > (USER_HEAP_START+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80011d:	8b 85 dc fe ff ff    	mov    -0x124(%ebp),%eax
  800123:	85 c0                	test   %eax,%eax
  800125:	79 0d                	jns    800134 <_main+0xfc>
  800127:	8b 85 dc fe ff ff    	mov    -0x124(%ebp),%eax
  80012d:	3d 00 10 00 80       	cmp    $0x80001000,%eax
  800132:	76 14                	jbe    800148 <_main+0x110>
  800134:	83 ec 04             	sub    $0x4,%esp
  800137:	68 10 3f 80 00       	push   $0x803f10
  80013c:	6a 39                	push   $0x39
  80013e:	68 fc 3e 80 00       	push   $0x803efc
  800143:	e8 20 0e 00 00       	call   800f68 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800148:	e8 c9 24 00 00       	call   802616 <sys_pf_calculate_allocated_pages>
  80014d:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800150:	74 14                	je     800166 <_main+0x12e>
  800152:	83 ec 04             	sub    $0x4,%esp
  800155:	68 78 3f 80 00       	push   $0x803f78
  80015a:	6a 3a                	push   $0x3a
  80015c:	68 fc 3e 80 00       	push   $0x803efc
  800161:	e8 02 0e 00 00       	call   800f68 <_panic>

		int freeFrames = sys_calculate_free_frames() ;
  800166:	e8 0b 24 00 00       	call   802576 <sys_calculate_free_frames>
  80016b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		lastIndexOfByte = (2*Mega-kilo)/sizeof(char) - 1;
  80016e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800171:	01 c0                	add    %eax,%eax
  800173:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800176:	48                   	dec    %eax
  800177:	89 45 c0             	mov    %eax,-0x40(%ebp)
		byteArr = (char *) ptr_allocations[0];
  80017a:	8b 85 dc fe ff ff    	mov    -0x124(%ebp),%eax
  800180:	89 45 bc             	mov    %eax,-0x44(%ebp)
		byteArr[0] = minByte ;
  800183:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800186:	8a 55 df             	mov    -0x21(%ebp),%dl
  800189:	88 10                	mov    %dl,(%eax)
		byteArr[lastIndexOfByte] = maxByte ;
  80018b:	8b 55 c0             	mov    -0x40(%ebp),%edx
  80018e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800191:	01 c2                	add    %eax,%edx
  800193:	8a 45 de             	mov    -0x22(%ebp),%al
  800196:	88 02                	mov    %al,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800198:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  80019b:	e8 d6 23 00 00       	call   802576 <sys_calculate_free_frames>
  8001a0:	29 c3                	sub    %eax,%ebx
  8001a2:	89 d8                	mov    %ebx,%eax
  8001a4:	83 f8 03             	cmp    $0x3,%eax
  8001a7:	74 14                	je     8001bd <_main+0x185>
  8001a9:	83 ec 04             	sub    $0x4,%esp
  8001ac:	68 a8 3f 80 00       	push   $0x803fa8
  8001b1:	6a 41                	push   $0x41
  8001b3:	68 fc 3e 80 00       	push   $0x803efc
  8001b8:	e8 ab 0d 00 00       	call   800f68 <_panic>
		int var;
		int found = 0;
  8001bd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8001c4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8001cb:	e9 82 00 00 00       	jmp    800252 <_main+0x21a>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE))
  8001d0:	a1 20 50 80 00       	mov    0x805020,%eax
  8001d5:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8001db:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8001de:	89 d0                	mov    %edx,%eax
  8001e0:	01 c0                	add    %eax,%eax
  8001e2:	01 d0                	add    %edx,%eax
  8001e4:	c1 e0 03             	shl    $0x3,%eax
  8001e7:	01 c8                	add    %ecx,%eax
  8001e9:	8b 00                	mov    (%eax),%eax
  8001eb:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8001ee:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8001f1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001f6:	89 c2                	mov    %eax,%edx
  8001f8:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8001fb:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8001fe:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800201:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800206:	39 c2                	cmp    %eax,%edx
  800208:	75 03                	jne    80020d <_main+0x1d5>
				found++;
  80020a:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE))
  80020d:	a1 20 50 80 00       	mov    0x805020,%eax
  800212:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800218:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80021b:	89 d0                	mov    %edx,%eax
  80021d:	01 c0                	add    %eax,%eax
  80021f:	01 d0                	add    %edx,%eax
  800221:	c1 e0 03             	shl    $0x3,%eax
  800224:	01 c8                	add    %ecx,%eax
  800226:	8b 00                	mov    (%eax),%eax
  800228:	89 45 b0             	mov    %eax,-0x50(%ebp)
  80022b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80022e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800233:	89 c1                	mov    %eax,%ecx
  800235:	8b 55 c0             	mov    -0x40(%ebp),%edx
  800238:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80023b:	01 d0                	add    %edx,%eax
  80023d:	89 45 ac             	mov    %eax,-0x54(%ebp)
  800240:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800243:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800248:	39 c1                	cmp    %eax,%ecx
  80024a:	75 03                	jne    80024f <_main+0x217>
				found++;
  80024c:	ff 45 e8             	incl   -0x18(%ebp)
		byteArr[0] = minByte ;
		byteArr[lastIndexOfByte] = maxByte ;
		if ((freeFrames - sys_calculate_free_frames()) != 2 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		int var;
		int found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  80024f:	ff 45 ec             	incl   -0x14(%ebp)
  800252:	a1 20 50 80 00       	mov    0x805020,%eax
  800257:	8b 50 74             	mov    0x74(%eax),%edx
  80025a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80025d:	39 c2                	cmp    %eax,%edx
  80025f:	0f 87 6b ff ff ff    	ja     8001d0 <_main+0x198>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  800265:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  800269:	74 14                	je     80027f <_main+0x247>
  80026b:	83 ec 04             	sub    $0x4,%esp
  80026e:	68 ec 3f 80 00       	push   $0x803fec
  800273:	6a 4b                	push   $0x4b
  800275:	68 fc 3e 80 00       	push   $0x803efc
  80027a:	e8 e9 0c 00 00       	call   800f68 <_panic>

		//2 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80027f:	e8 92 23 00 00       	call   802616 <sys_pf_calculate_allocated_pages>
  800284:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  800287:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80028a:	01 c0                	add    %eax,%eax
  80028c:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80028f:	83 ec 0c             	sub    $0xc,%esp
  800292:	50                   	push   %eax
  800293:	e8 b0 1e 00 00       	call   802148 <malloc>
  800298:	83 c4 10             	add    $0x10,%esp
  80029b:	89 85 e0 fe ff ff    	mov    %eax,-0x120(%ebp)
		if ((uint32) ptr_allocations[1] < (USER_HEAP_START + 2*Mega) || (uint32) ptr_allocations[1] > (USER_HEAP_START+ 2*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8002a1:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
  8002a7:	89 c2                	mov    %eax,%edx
  8002a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002ac:	01 c0                	add    %eax,%eax
  8002ae:	05 00 00 00 80       	add    $0x80000000,%eax
  8002b3:	39 c2                	cmp    %eax,%edx
  8002b5:	72 16                	jb     8002cd <_main+0x295>
  8002b7:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
  8002bd:	89 c2                	mov    %eax,%edx
  8002bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002c2:	01 c0                	add    %eax,%eax
  8002c4:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8002c9:	39 c2                	cmp    %eax,%edx
  8002cb:	76 14                	jbe    8002e1 <_main+0x2a9>
  8002cd:	83 ec 04             	sub    $0x4,%esp
  8002d0:	68 10 3f 80 00       	push   $0x803f10
  8002d5:	6a 50                	push   $0x50
  8002d7:	68 fc 3e 80 00       	push   $0x803efc
  8002dc:	e8 87 0c 00 00       	call   800f68 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8002e1:	e8 30 23 00 00       	call   802616 <sys_pf_calculate_allocated_pages>
  8002e6:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8002e9:	74 14                	je     8002ff <_main+0x2c7>
  8002eb:	83 ec 04             	sub    $0x4,%esp
  8002ee:	68 78 3f 80 00       	push   $0x803f78
  8002f3:	6a 51                	push   $0x51
  8002f5:	68 fc 3e 80 00       	push   $0x803efc
  8002fa:	e8 69 0c 00 00       	call   800f68 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8002ff:	e8 72 22 00 00       	call   802576 <sys_calculate_free_frames>
  800304:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		shortArr = (short *) ptr_allocations[1];
  800307:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
  80030d:	89 45 a8             	mov    %eax,-0x58(%ebp)
		lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
  800310:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800313:	01 c0                	add    %eax,%eax
  800315:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800318:	d1 e8                	shr    %eax
  80031a:	48                   	dec    %eax
  80031b:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		shortArr[0] = minShort;
  80031e:	8b 55 a8             	mov    -0x58(%ebp),%edx
  800321:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800324:	66 89 02             	mov    %ax,(%edx)
		shortArr[lastIndexOfShort] = maxShort;
  800327:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80032a:	01 c0                	add    %eax,%eax
  80032c:	89 c2                	mov    %eax,%edx
  80032e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800331:	01 c2                	add    %eax,%edx
  800333:	66 8b 45 da          	mov    -0x26(%ebp),%ax
  800337:	66 89 02             	mov    %ax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2 ) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  80033a:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  80033d:	e8 34 22 00 00       	call   802576 <sys_calculate_free_frames>
  800342:	29 c3                	sub    %eax,%ebx
  800344:	89 d8                	mov    %ebx,%eax
  800346:	83 f8 02             	cmp    $0x2,%eax
  800349:	74 14                	je     80035f <_main+0x327>
  80034b:	83 ec 04             	sub    $0x4,%esp
  80034e:	68 a8 3f 80 00       	push   $0x803fa8
  800353:	6a 58                	push   $0x58
  800355:	68 fc 3e 80 00       	push   $0x803efc
  80035a:	e8 09 0c 00 00       	call   800f68 <_panic>
		found = 0;
  80035f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800366:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80036d:	e9 86 00 00 00       	jmp    8003f8 <_main+0x3c0>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
  800372:	a1 20 50 80 00       	mov    0x805020,%eax
  800377:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80037d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800380:	89 d0                	mov    %edx,%eax
  800382:	01 c0                	add    %eax,%eax
  800384:	01 d0                	add    %edx,%eax
  800386:	c1 e0 03             	shl    $0x3,%eax
  800389:	01 c8                	add    %ecx,%eax
  80038b:	8b 00                	mov    (%eax),%eax
  80038d:	89 45 a0             	mov    %eax,-0x60(%ebp)
  800390:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800393:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800398:	89 c2                	mov    %eax,%edx
  80039a:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80039d:	89 45 9c             	mov    %eax,-0x64(%ebp)
  8003a0:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8003a3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003a8:	39 c2                	cmp    %eax,%edx
  8003aa:	75 03                	jne    8003af <_main+0x377>
				found++;
  8003ac:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
  8003af:	a1 20 50 80 00       	mov    0x805020,%eax
  8003b4:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003ba:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8003bd:	89 d0                	mov    %edx,%eax
  8003bf:	01 c0                	add    %eax,%eax
  8003c1:	01 d0                	add    %edx,%eax
  8003c3:	c1 e0 03             	shl    $0x3,%eax
  8003c6:	01 c8                	add    %ecx,%eax
  8003c8:	8b 00                	mov    (%eax),%eax
  8003ca:	89 45 98             	mov    %eax,-0x68(%ebp)
  8003cd:	8b 45 98             	mov    -0x68(%ebp),%eax
  8003d0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003d5:	89 c2                	mov    %eax,%edx
  8003d7:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003da:	01 c0                	add    %eax,%eax
  8003dc:	89 c1                	mov    %eax,%ecx
  8003de:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8003e1:	01 c8                	add    %ecx,%eax
  8003e3:	89 45 94             	mov    %eax,-0x6c(%ebp)
  8003e6:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8003e9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003ee:	39 c2                	cmp    %eax,%edx
  8003f0:	75 03                	jne    8003f5 <_main+0x3bd>
				found++;
  8003f2:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
		shortArr[0] = minShort;
		shortArr[lastIndexOfShort] = maxShort;
		if ((freeFrames - sys_calculate_free_frames()) != 2 ) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8003f5:	ff 45 ec             	incl   -0x14(%ebp)
  8003f8:	a1 20 50 80 00       	mov    0x805020,%eax
  8003fd:	8b 50 74             	mov    0x74(%eax),%edx
  800400:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800403:	39 c2                	cmp    %eax,%edx
  800405:	0f 87 67 ff ff ff    	ja     800372 <_main+0x33a>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  80040b:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  80040f:	74 14                	je     800425 <_main+0x3ed>
  800411:	83 ec 04             	sub    $0x4,%esp
  800414:	68 ec 3f 80 00       	push   $0x803fec
  800419:	6a 61                	push   $0x61
  80041b:	68 fc 3e 80 00       	push   $0x803efc
  800420:	e8 43 0b 00 00       	call   800f68 <_panic>

		//3 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800425:	e8 ec 21 00 00       	call   802616 <sys_pf_calculate_allocated_pages>
  80042a:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[2] = malloc(3*kilo);
  80042d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800430:	89 c2                	mov    %eax,%edx
  800432:	01 d2                	add    %edx,%edx
  800434:	01 d0                	add    %edx,%eax
  800436:	83 ec 0c             	sub    $0xc,%esp
  800439:	50                   	push   %eax
  80043a:	e8 09 1d 00 00       	call   802148 <malloc>
  80043f:	83 c4 10             	add    $0x10,%esp
  800442:	89 85 e4 fe ff ff    	mov    %eax,-0x11c(%ebp)
		if ((uint32) ptr_allocations[2] < (USER_HEAP_START + 4*Mega) || (uint32) ptr_allocations[2] > (USER_HEAP_START+ 4*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800448:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
  80044e:	89 c2                	mov    %eax,%edx
  800450:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800453:	c1 e0 02             	shl    $0x2,%eax
  800456:	05 00 00 00 80       	add    $0x80000000,%eax
  80045b:	39 c2                	cmp    %eax,%edx
  80045d:	72 17                	jb     800476 <_main+0x43e>
  80045f:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
  800465:	89 c2                	mov    %eax,%edx
  800467:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80046a:	c1 e0 02             	shl    $0x2,%eax
  80046d:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800472:	39 c2                	cmp    %eax,%edx
  800474:	76 14                	jbe    80048a <_main+0x452>
  800476:	83 ec 04             	sub    $0x4,%esp
  800479:	68 10 3f 80 00       	push   $0x803f10
  80047e:	6a 66                	push   $0x66
  800480:	68 fc 3e 80 00       	push   $0x803efc
  800485:	e8 de 0a 00 00       	call   800f68 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  80048a:	e8 87 21 00 00       	call   802616 <sys_pf_calculate_allocated_pages>
  80048f:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800492:	74 14                	je     8004a8 <_main+0x470>
  800494:	83 ec 04             	sub    $0x4,%esp
  800497:	68 78 3f 80 00       	push   $0x803f78
  80049c:	6a 67                	push   $0x67
  80049e:	68 fc 3e 80 00       	push   $0x803efc
  8004a3:	e8 c0 0a 00 00       	call   800f68 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8004a8:	e8 c9 20 00 00       	call   802576 <sys_calculate_free_frames>
  8004ad:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		intArr = (int *) ptr_allocations[2];
  8004b0:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
  8004b6:	89 45 90             	mov    %eax,-0x70(%ebp)
		lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
  8004b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004bc:	01 c0                	add    %eax,%eax
  8004be:	c1 e8 02             	shr    $0x2,%eax
  8004c1:	48                   	dec    %eax
  8004c2:	89 45 8c             	mov    %eax,-0x74(%ebp)
		intArr[0] = minInt;
  8004c5:	8b 45 90             	mov    -0x70(%ebp),%eax
  8004c8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8004cb:	89 10                	mov    %edx,(%eax)
		intArr[lastIndexOfInt] = maxInt;
  8004cd:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8004d0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004d7:	8b 45 90             	mov    -0x70(%ebp),%eax
  8004da:	01 c2                	add    %eax,%edx
  8004dc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004df:	89 02                	mov    %eax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 1 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  8004e1:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  8004e4:	e8 8d 20 00 00       	call   802576 <sys_calculate_free_frames>
  8004e9:	29 c3                	sub    %eax,%ebx
  8004eb:	89 d8                	mov    %ebx,%eax
  8004ed:	83 f8 02             	cmp    $0x2,%eax
  8004f0:	74 14                	je     800506 <_main+0x4ce>
  8004f2:	83 ec 04             	sub    $0x4,%esp
  8004f5:	68 a8 3f 80 00       	push   $0x803fa8
  8004fa:	6a 6e                	push   $0x6e
  8004fc:	68 fc 3e 80 00       	push   $0x803efc
  800501:	e8 62 0a 00 00       	call   800f68 <_panic>
		found = 0;
  800506:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  80050d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800514:	e9 8f 00 00 00       	jmp    8005a8 <_main+0x570>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE))
  800519:	a1 20 50 80 00       	mov    0x805020,%eax
  80051e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800524:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800527:	89 d0                	mov    %edx,%eax
  800529:	01 c0                	add    %eax,%eax
  80052b:	01 d0                	add    %edx,%eax
  80052d:	c1 e0 03             	shl    $0x3,%eax
  800530:	01 c8                	add    %ecx,%eax
  800532:	8b 00                	mov    (%eax),%eax
  800534:	89 45 88             	mov    %eax,-0x78(%ebp)
  800537:	8b 45 88             	mov    -0x78(%ebp),%eax
  80053a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80053f:	89 c2                	mov    %eax,%edx
  800541:	8b 45 90             	mov    -0x70(%ebp),%eax
  800544:	89 45 84             	mov    %eax,-0x7c(%ebp)
  800547:	8b 45 84             	mov    -0x7c(%ebp),%eax
  80054a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80054f:	39 c2                	cmp    %eax,%edx
  800551:	75 03                	jne    800556 <_main+0x51e>
				found++;
  800553:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
  800556:	a1 20 50 80 00       	mov    0x805020,%eax
  80055b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800561:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800564:	89 d0                	mov    %edx,%eax
  800566:	01 c0                	add    %eax,%eax
  800568:	01 d0                	add    %edx,%eax
  80056a:	c1 e0 03             	shl    $0x3,%eax
  80056d:	01 c8                	add    %ecx,%eax
  80056f:	8b 00                	mov    (%eax),%eax
  800571:	89 45 80             	mov    %eax,-0x80(%ebp)
  800574:	8b 45 80             	mov    -0x80(%ebp),%eax
  800577:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80057c:	89 c2                	mov    %eax,%edx
  80057e:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800581:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800588:	8b 45 90             	mov    -0x70(%ebp),%eax
  80058b:	01 c8                	add    %ecx,%eax
  80058d:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  800593:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800599:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80059e:	39 c2                	cmp    %eax,%edx
  8005a0:	75 03                	jne    8005a5 <_main+0x56d>
				found++;
  8005a2:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
		intArr[0] = minInt;
		intArr[lastIndexOfInt] = maxInt;
		if ((freeFrames - sys_calculate_free_frames()) != 1 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8005a5:	ff 45 ec             	incl   -0x14(%ebp)
  8005a8:	a1 20 50 80 00       	mov    0x805020,%eax
  8005ad:	8b 50 74             	mov    0x74(%eax),%edx
  8005b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005b3:	39 c2                	cmp    %eax,%edx
  8005b5:	0f 87 5e ff ff ff    	ja     800519 <_main+0x4e1>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  8005bb:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  8005bf:	74 14                	je     8005d5 <_main+0x59d>
  8005c1:	83 ec 04             	sub    $0x4,%esp
  8005c4:	68 ec 3f 80 00       	push   $0x803fec
  8005c9:	6a 77                	push   $0x77
  8005cb:	68 fc 3e 80 00       	push   $0x803efc
  8005d0:	e8 93 09 00 00       	call   800f68 <_panic>

		//3 KB
		freeFrames = sys_calculate_free_frames() ;
  8005d5:	e8 9c 1f 00 00       	call   802576 <sys_calculate_free_frames>
  8005da:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8005dd:	e8 34 20 00 00       	call   802616 <sys_pf_calculate_allocated_pages>
  8005e2:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[3] = malloc(3*kilo);
  8005e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005e8:	89 c2                	mov    %eax,%edx
  8005ea:	01 d2                	add    %edx,%edx
  8005ec:	01 d0                	add    %edx,%eax
  8005ee:	83 ec 0c             	sub    $0xc,%esp
  8005f1:	50                   	push   %eax
  8005f2:	e8 51 1b 00 00       	call   802148 <malloc>
  8005f7:	83 c4 10             	add    $0x10,%esp
  8005fa:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
		if ((uint32) ptr_allocations[3] < (USER_HEAP_START + 4*Mega + 4*kilo) || (uint32) ptr_allocations[3] > (USER_HEAP_START+ 4*Mega + 4*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800600:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
  800606:	89 c2                	mov    %eax,%edx
  800608:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80060b:	c1 e0 02             	shl    $0x2,%eax
  80060e:	89 c1                	mov    %eax,%ecx
  800610:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800613:	c1 e0 02             	shl    $0x2,%eax
  800616:	01 c8                	add    %ecx,%eax
  800618:	05 00 00 00 80       	add    $0x80000000,%eax
  80061d:	39 c2                	cmp    %eax,%edx
  80061f:	72 21                	jb     800642 <_main+0x60a>
  800621:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
  800627:	89 c2                	mov    %eax,%edx
  800629:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80062c:	c1 e0 02             	shl    $0x2,%eax
  80062f:	89 c1                	mov    %eax,%ecx
  800631:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800634:	c1 e0 02             	shl    $0x2,%eax
  800637:	01 c8                	add    %ecx,%eax
  800639:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  80063e:	39 c2                	cmp    %eax,%edx
  800640:	76 14                	jbe    800656 <_main+0x61e>
  800642:	83 ec 04             	sub    $0x4,%esp
  800645:	68 10 3f 80 00       	push   $0x803f10
  80064a:	6a 7d                	push   $0x7d
  80064c:	68 fc 3e 80 00       	push   $0x803efc
  800651:	e8 12 09 00 00       	call   800f68 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800656:	e8 bb 1f 00 00       	call   802616 <sys_pf_calculate_allocated_pages>
  80065b:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80065e:	74 14                	je     800674 <_main+0x63c>
  800660:	83 ec 04             	sub    $0x4,%esp
  800663:	68 78 3f 80 00       	push   $0x803f78
  800668:	6a 7e                	push   $0x7e
  80066a:	68 fc 3e 80 00       	push   $0x803efc
  80066f:	e8 f4 08 00 00       	call   800f68 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//7 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800674:	e8 9d 1f 00 00       	call   802616 <sys_pf_calculate_allocated_pages>
  800679:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  80067c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80067f:	89 d0                	mov    %edx,%eax
  800681:	01 c0                	add    %eax,%eax
  800683:	01 d0                	add    %edx,%eax
  800685:	01 c0                	add    %eax,%eax
  800687:	01 d0                	add    %edx,%eax
  800689:	83 ec 0c             	sub    $0xc,%esp
  80068c:	50                   	push   %eax
  80068d:	e8 b6 1a 00 00       	call   802148 <malloc>
  800692:	83 c4 10             	add    $0x10,%esp
  800695:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
		if ((uint32) ptr_allocations[4] < (USER_HEAP_START + 4*Mega + 8*kilo)|| (uint32) ptr_allocations[4] > (USER_HEAP_START+ 4*Mega + 8*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80069b:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  8006a1:	89 c2                	mov    %eax,%edx
  8006a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006a6:	c1 e0 02             	shl    $0x2,%eax
  8006a9:	89 c1                	mov    %eax,%ecx
  8006ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006ae:	c1 e0 03             	shl    $0x3,%eax
  8006b1:	01 c8                	add    %ecx,%eax
  8006b3:	05 00 00 00 80       	add    $0x80000000,%eax
  8006b8:	39 c2                	cmp    %eax,%edx
  8006ba:	72 21                	jb     8006dd <_main+0x6a5>
  8006bc:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  8006c2:	89 c2                	mov    %eax,%edx
  8006c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006c7:	c1 e0 02             	shl    $0x2,%eax
  8006ca:	89 c1                	mov    %eax,%ecx
  8006cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006cf:	c1 e0 03             	shl    $0x3,%eax
  8006d2:	01 c8                	add    %ecx,%eax
  8006d4:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8006d9:	39 c2                	cmp    %eax,%edx
  8006db:	76 17                	jbe    8006f4 <_main+0x6bc>
  8006dd:	83 ec 04             	sub    $0x4,%esp
  8006e0:	68 10 3f 80 00       	push   $0x803f10
  8006e5:	68 84 00 00 00       	push   $0x84
  8006ea:	68 fc 3e 80 00       	push   $0x803efc
  8006ef:	e8 74 08 00 00       	call   800f68 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8006f4:	e8 1d 1f 00 00       	call   802616 <sys_pf_calculate_allocated_pages>
  8006f9:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8006fc:	74 17                	je     800715 <_main+0x6dd>
  8006fe:	83 ec 04             	sub    $0x4,%esp
  800701:	68 78 3f 80 00       	push   $0x803f78
  800706:	68 85 00 00 00       	push   $0x85
  80070b:	68 fc 3e 80 00       	push   $0x803efc
  800710:	e8 53 08 00 00       	call   800f68 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800715:	e8 5c 1e 00 00       	call   802576 <sys_calculate_free_frames>
  80071a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		structArr = (struct MyStruct *) ptr_allocations[4];
  80071d:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  800723:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
		lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
  800729:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80072c:	89 d0                	mov    %edx,%eax
  80072e:	01 c0                	add    %eax,%eax
  800730:	01 d0                	add    %edx,%eax
  800732:	01 c0                	add    %eax,%eax
  800734:	01 d0                	add    %edx,%eax
  800736:	c1 e8 03             	shr    $0x3,%eax
  800739:	48                   	dec    %eax
  80073a:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
		structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
  800740:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800746:	8a 55 df             	mov    -0x21(%ebp),%dl
  800749:	88 10                	mov    %dl,(%eax)
  80074b:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
  800751:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800754:	66 89 42 02          	mov    %ax,0x2(%edx)
  800758:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  80075e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800761:	89 50 04             	mov    %edx,0x4(%eax)
		structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
  800764:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  80076a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800771:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800777:	01 c2                	add    %eax,%edx
  800779:	8a 45 de             	mov    -0x22(%ebp),%al
  80077c:	88 02                	mov    %al,(%edx)
  80077e:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800784:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80078b:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800791:	01 c2                	add    %eax,%edx
  800793:	66 8b 45 da          	mov    -0x26(%ebp),%ax
  800797:	66 89 42 02          	mov    %ax,0x2(%edx)
  80079b:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8007a1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8007a8:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  8007ae:	01 c2                	add    %eax,%edx
  8007b0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007b3:	89 42 04             	mov    %eax,0x4(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  8007b6:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  8007b9:	e8 b8 1d 00 00       	call   802576 <sys_calculate_free_frames>
  8007be:	29 c3                	sub    %eax,%ebx
  8007c0:	89 d8                	mov    %ebx,%eax
  8007c2:	83 f8 02             	cmp    $0x2,%eax
  8007c5:	74 17                	je     8007de <_main+0x7a6>
  8007c7:	83 ec 04             	sub    $0x4,%esp
  8007ca:	68 a8 3f 80 00       	push   $0x803fa8
  8007cf:	68 8c 00 00 00       	push   $0x8c
  8007d4:	68 fc 3e 80 00       	push   $0x803efc
  8007d9:	e8 8a 07 00 00       	call   800f68 <_panic>
		found = 0;
  8007de:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8007e5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8007ec:	e9 aa 00 00 00       	jmp    80089b <_main+0x863>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE))
  8007f1:	a1 20 50 80 00       	mov    0x805020,%eax
  8007f6:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8007fc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8007ff:	89 d0                	mov    %edx,%eax
  800801:	01 c0                	add    %eax,%eax
  800803:	01 d0                	add    %edx,%eax
  800805:	c1 e0 03             	shl    $0x3,%eax
  800808:	01 c8                	add    %ecx,%eax
  80080a:	8b 00                	mov    (%eax),%eax
  80080c:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
  800812:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800818:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80081d:	89 c2                	mov    %eax,%edx
  80081f:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800825:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  80082b:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800831:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800836:	39 c2                	cmp    %eax,%edx
  800838:	75 03                	jne    80083d <_main+0x805>
				found++;
  80083a:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE))
  80083d:	a1 20 50 80 00       	mov    0x805020,%eax
  800842:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800848:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80084b:	89 d0                	mov    %edx,%eax
  80084d:	01 c0                	add    %eax,%eax
  80084f:	01 d0                	add    %edx,%eax
  800851:	c1 e0 03             	shl    $0x3,%eax
  800854:	01 c8                	add    %ecx,%eax
  800856:	8b 00                	mov    (%eax),%eax
  800858:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
  80085e:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800864:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800869:	89 c2                	mov    %eax,%edx
  80086b:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800871:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800878:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  80087e:	01 c8                	add    %ecx,%eax
  800880:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
  800886:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  80088c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800891:	39 c2                	cmp    %eax,%edx
  800893:	75 03                	jne    800898 <_main+0x860>
				found++;
  800895:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
		structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
		structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800898:	ff 45 ec             	incl   -0x14(%ebp)
  80089b:	a1 20 50 80 00       	mov    0x805020,%eax
  8008a0:	8b 50 74             	mov    0x74(%eax),%edx
  8008a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008a6:	39 c2                	cmp    %eax,%edx
  8008a8:	0f 87 43 ff ff ff    	ja     8007f1 <_main+0x7b9>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  8008ae:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  8008b2:	74 17                	je     8008cb <_main+0x893>
  8008b4:	83 ec 04             	sub    $0x4,%esp
  8008b7:	68 ec 3f 80 00       	push   $0x803fec
  8008bc:	68 95 00 00 00       	push   $0x95
  8008c1:	68 fc 3e 80 00       	push   $0x803efc
  8008c6:	e8 9d 06 00 00       	call   800f68 <_panic>

		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8008cb:	e8 a6 1c 00 00       	call   802576 <sys_calculate_free_frames>
  8008d0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8008d3:	e8 3e 1d 00 00       	call   802616 <sys_pf_calculate_allocated_pages>
  8008d8:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  8008db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8008de:	89 c2                	mov    %eax,%edx
  8008e0:	01 d2                	add    %edx,%edx
  8008e2:	01 d0                	add    %edx,%eax
  8008e4:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8008e7:	83 ec 0c             	sub    $0xc,%esp
  8008ea:	50                   	push   %eax
  8008eb:	e8 58 18 00 00       	call   802148 <malloc>
  8008f0:	83 c4 10             	add    $0x10,%esp
  8008f3:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
		if ((uint32) ptr_allocations[5] < (USER_HEAP_START + 4*Mega + 16*kilo) || (uint32) ptr_allocations[5] > (USER_HEAP_START+ 4*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8008f9:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8008ff:	89 c2                	mov    %eax,%edx
  800901:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800904:	c1 e0 02             	shl    $0x2,%eax
  800907:	89 c1                	mov    %eax,%ecx
  800909:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80090c:	c1 e0 04             	shl    $0x4,%eax
  80090f:	01 c8                	add    %ecx,%eax
  800911:	05 00 00 00 80       	add    $0x80000000,%eax
  800916:	39 c2                	cmp    %eax,%edx
  800918:	72 21                	jb     80093b <_main+0x903>
  80091a:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800920:	89 c2                	mov    %eax,%edx
  800922:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800925:	c1 e0 02             	shl    $0x2,%eax
  800928:	89 c1                	mov    %eax,%ecx
  80092a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80092d:	c1 e0 04             	shl    $0x4,%eax
  800930:	01 c8                	add    %ecx,%eax
  800932:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800937:	39 c2                	cmp    %eax,%edx
  800939:	76 17                	jbe    800952 <_main+0x91a>
  80093b:	83 ec 04             	sub    $0x4,%esp
  80093e:	68 10 3f 80 00       	push   $0x803f10
  800943:	68 9b 00 00 00       	push   $0x9b
  800948:	68 fc 3e 80 00       	push   $0x803efc
  80094d:	e8 16 06 00 00       	call   800f68 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800952:	e8 bf 1c 00 00       	call   802616 <sys_pf_calculate_allocated_pages>
  800957:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80095a:	74 17                	je     800973 <_main+0x93b>
  80095c:	83 ec 04             	sub    $0x4,%esp
  80095f:	68 78 3f 80 00       	push   $0x803f78
  800964:	68 9c 00 00 00       	push   $0x9c
  800969:	68 fc 3e 80 00       	push   $0x803efc
  80096e:	e8 f5 05 00 00       	call   800f68 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//6 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800973:	e8 9e 1c 00 00       	call   802616 <sys_pf_calculate_allocated_pages>
  800978:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[6] = malloc(6*Mega-kilo);
  80097b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80097e:	89 d0                	mov    %edx,%eax
  800980:	01 c0                	add    %eax,%eax
  800982:	01 d0                	add    %edx,%eax
  800984:	01 c0                	add    %eax,%eax
  800986:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800989:	83 ec 0c             	sub    $0xc,%esp
  80098c:	50                   	push   %eax
  80098d:	e8 b6 17 00 00       	call   802148 <malloc>
  800992:	83 c4 10             	add    $0x10,%esp
  800995:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
		if ((uint32) ptr_allocations[6] < (USER_HEAP_START + 7*Mega + 16*kilo) || (uint32) ptr_allocations[6] > (USER_HEAP_START+ 7*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80099b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8009a1:	89 c1                	mov    %eax,%ecx
  8009a3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8009a6:	89 d0                	mov    %edx,%eax
  8009a8:	01 c0                	add    %eax,%eax
  8009aa:	01 d0                	add    %edx,%eax
  8009ac:	01 c0                	add    %eax,%eax
  8009ae:	01 d0                	add    %edx,%eax
  8009b0:	89 c2                	mov    %eax,%edx
  8009b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009b5:	c1 e0 04             	shl    $0x4,%eax
  8009b8:	01 d0                	add    %edx,%eax
  8009ba:	05 00 00 00 80       	add    $0x80000000,%eax
  8009bf:	39 c1                	cmp    %eax,%ecx
  8009c1:	72 28                	jb     8009eb <_main+0x9b3>
  8009c3:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8009c9:	89 c1                	mov    %eax,%ecx
  8009cb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8009ce:	89 d0                	mov    %edx,%eax
  8009d0:	01 c0                	add    %eax,%eax
  8009d2:	01 d0                	add    %edx,%eax
  8009d4:	01 c0                	add    %eax,%eax
  8009d6:	01 d0                	add    %edx,%eax
  8009d8:	89 c2                	mov    %eax,%edx
  8009da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009dd:	c1 e0 04             	shl    $0x4,%eax
  8009e0:	01 d0                	add    %edx,%eax
  8009e2:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8009e7:	39 c1                	cmp    %eax,%ecx
  8009e9:	76 17                	jbe    800a02 <_main+0x9ca>
  8009eb:	83 ec 04             	sub    $0x4,%esp
  8009ee:	68 10 3f 80 00       	push   $0x803f10
  8009f3:	68 a2 00 00 00       	push   $0xa2
  8009f8:	68 fc 3e 80 00       	push   $0x803efc
  8009fd:	e8 66 05 00 00       	call   800f68 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800a02:	e8 0f 1c 00 00       	call   802616 <sys_pf_calculate_allocated_pages>
  800a07:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800a0a:	74 17                	je     800a23 <_main+0x9eb>
  800a0c:	83 ec 04             	sub    $0x4,%esp
  800a0f:	68 78 3f 80 00       	push   $0x803f78
  800a14:	68 a3 00 00 00       	push   $0xa3
  800a19:	68 fc 3e 80 00       	push   $0x803efc
  800a1e:	e8 45 05 00 00       	call   800f68 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800a23:	e8 4e 1b 00 00       	call   802576 <sys_calculate_free_frames>
  800a28:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		lastIndexOfByte2 = (6*Mega-kilo)/sizeof(char) - 1;
  800a2b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800a2e:	89 d0                	mov    %edx,%eax
  800a30:	01 c0                	add    %eax,%eax
  800a32:	01 d0                	add    %edx,%eax
  800a34:	01 c0                	add    %eax,%eax
  800a36:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800a39:	48                   	dec    %eax
  800a3a:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
		byteArr2 = (char *) ptr_allocations[6];
  800a40:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800a46:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
		byteArr2[0] = minByte ;
  800a4c:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800a52:	8a 55 df             	mov    -0x21(%ebp),%dl
  800a55:	88 10                	mov    %dl,(%eax)
		byteArr2[lastIndexOfByte2 / 2] = maxByte / 2;
  800a57:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800a5d:	89 c2                	mov    %eax,%edx
  800a5f:	c1 ea 1f             	shr    $0x1f,%edx
  800a62:	01 d0                	add    %edx,%eax
  800a64:	d1 f8                	sar    %eax
  800a66:	89 c2                	mov    %eax,%edx
  800a68:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800a6e:	01 c2                	add    %eax,%edx
  800a70:	8a 45 de             	mov    -0x22(%ebp),%al
  800a73:	88 c1                	mov    %al,%cl
  800a75:	c0 e9 07             	shr    $0x7,%cl
  800a78:	01 c8                	add    %ecx,%eax
  800a7a:	d0 f8                	sar    %al
  800a7c:	88 02                	mov    %al,(%edx)
		byteArr2[lastIndexOfByte2] = maxByte ;
  800a7e:	8b 95 60 ff ff ff    	mov    -0xa0(%ebp),%edx
  800a84:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800a8a:	01 c2                	add    %eax,%edx
  800a8c:	8a 45 de             	mov    -0x22(%ebp),%al
  800a8f:	88 02                	mov    %al,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 3 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800a91:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  800a94:	e8 dd 1a 00 00       	call   802576 <sys_calculate_free_frames>
  800a99:	29 c3                	sub    %eax,%ebx
  800a9b:	89 d8                	mov    %ebx,%eax
  800a9d:	83 f8 05             	cmp    $0x5,%eax
  800aa0:	74 17                	je     800ab9 <_main+0xa81>
  800aa2:	83 ec 04             	sub    $0x4,%esp
  800aa5:	68 a8 3f 80 00       	push   $0x803fa8
  800aaa:	68 ab 00 00 00       	push   $0xab
  800aaf:	68 fc 3e 80 00       	push   $0x803efc
  800ab4:	e8 af 04 00 00       	call   800f68 <_panic>
		found = 0;
  800ab9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800ac0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800ac7:	e9 02 01 00 00       	jmp    800bce <_main+0xb96>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[0])), PAGE_SIZE))
  800acc:	a1 20 50 80 00       	mov    0x805020,%eax
  800ad1:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800ad7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ada:	89 d0                	mov    %edx,%eax
  800adc:	01 c0                	add    %eax,%eax
  800ade:	01 d0                	add    %edx,%eax
  800ae0:	c1 e0 03             	shl    $0x3,%eax
  800ae3:	01 c8                	add    %ecx,%eax
  800ae5:	8b 00                	mov    (%eax),%eax
  800ae7:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
  800aed:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800af3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800af8:	89 c2                	mov    %eax,%edx
  800afa:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800b00:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
  800b06:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800b0c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b11:	39 c2                	cmp    %eax,%edx
  800b13:	75 03                	jne    800b18 <_main+0xae0>
				found++;
  800b15:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE))
  800b18:	a1 20 50 80 00       	mov    0x805020,%eax
  800b1d:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800b23:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b26:	89 d0                	mov    %edx,%eax
  800b28:	01 c0                	add    %eax,%eax
  800b2a:	01 d0                	add    %edx,%eax
  800b2c:	c1 e0 03             	shl    $0x3,%eax
  800b2f:	01 c8                	add    %ecx,%eax
  800b31:	8b 00                	mov    (%eax),%eax
  800b33:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
  800b39:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  800b3f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b44:	89 c2                	mov    %eax,%edx
  800b46:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800b4c:	89 c1                	mov    %eax,%ecx
  800b4e:	c1 e9 1f             	shr    $0x1f,%ecx
  800b51:	01 c8                	add    %ecx,%eax
  800b53:	d1 f8                	sar    %eax
  800b55:	89 c1                	mov    %eax,%ecx
  800b57:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800b5d:	01 c8                	add    %ecx,%eax
  800b5f:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  800b65:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  800b6b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b70:	39 c2                	cmp    %eax,%edx
  800b72:	75 03                	jne    800b77 <_main+0xb3f>
				found++;
  800b74:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
  800b77:	a1 20 50 80 00       	mov    0x805020,%eax
  800b7c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800b82:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b85:	89 d0                	mov    %edx,%eax
  800b87:	01 c0                	add    %eax,%eax
  800b89:	01 d0                	add    %edx,%eax
  800b8b:	c1 e0 03             	shl    $0x3,%eax
  800b8e:	01 c8                	add    %ecx,%eax
  800b90:	8b 00                	mov    (%eax),%eax
  800b92:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
  800b98:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800b9e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ba3:	89 c1                	mov    %eax,%ecx
  800ba5:	8b 95 60 ff ff ff    	mov    -0xa0(%ebp),%edx
  800bab:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800bb1:	01 d0                	add    %edx,%eax
  800bb3:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  800bb9:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  800bbf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800bc4:	39 c1                	cmp    %eax,%ecx
  800bc6:	75 03                	jne    800bcb <_main+0xb93>
				found++;
  800bc8:	ff 45 e8             	incl   -0x18(%ebp)
		byteArr2[0] = minByte ;
		byteArr2[lastIndexOfByte2 / 2] = maxByte / 2;
		byteArr2[lastIndexOfByte2] = maxByte ;
		if ((freeFrames - sys_calculate_free_frames()) != 3 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800bcb:	ff 45 ec             	incl   -0x14(%ebp)
  800bce:	a1 20 50 80 00       	mov    0x805020,%eax
  800bd3:	8b 50 74             	mov    0x74(%eax),%edx
  800bd6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bd9:	39 c2                	cmp    %eax,%edx
  800bdb:	0f 87 eb fe ff ff    	ja     800acc <_main+0xa94>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
				found++;
		}
		if (found != 3) panic("malloc: page is not added to WS");
  800be1:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  800be5:	74 17                	je     800bfe <_main+0xbc6>
  800be7:	83 ec 04             	sub    $0x4,%esp
  800bea:	68 ec 3f 80 00       	push   $0x803fec
  800bef:	68 b6 00 00 00       	push   $0xb6
  800bf4:	68 fc 3e 80 00       	push   $0x803efc
  800bf9:	e8 6a 03 00 00       	call   800f68 <_panic>

		//14 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800bfe:	e8 13 1a 00 00       	call   802616 <sys_pf_calculate_allocated_pages>
  800c03:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[7] = malloc(14*kilo);
  800c06:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c09:	89 d0                	mov    %edx,%eax
  800c0b:	01 c0                	add    %eax,%eax
  800c0d:	01 d0                	add    %edx,%eax
  800c0f:	01 c0                	add    %eax,%eax
  800c11:	01 d0                	add    %edx,%eax
  800c13:	01 c0                	add    %eax,%eax
  800c15:	83 ec 0c             	sub    $0xc,%esp
  800c18:	50                   	push   %eax
  800c19:	e8 2a 15 00 00       	call   802148 <malloc>
  800c1e:	83 c4 10             	add    $0x10,%esp
  800c21:	89 85 f8 fe ff ff    	mov    %eax,-0x108(%ebp)
		if ((uint32) ptr_allocations[7] < (USER_HEAP_START + 13*Mega + 16*kilo)|| (uint32) ptr_allocations[7] > (USER_HEAP_START+ 13*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800c27:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
  800c2d:	89 c1                	mov    %eax,%ecx
  800c2f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800c32:	89 d0                	mov    %edx,%eax
  800c34:	01 c0                	add    %eax,%eax
  800c36:	01 d0                	add    %edx,%eax
  800c38:	c1 e0 02             	shl    $0x2,%eax
  800c3b:	01 d0                	add    %edx,%eax
  800c3d:	89 c2                	mov    %eax,%edx
  800c3f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c42:	c1 e0 04             	shl    $0x4,%eax
  800c45:	01 d0                	add    %edx,%eax
  800c47:	05 00 00 00 80       	add    $0x80000000,%eax
  800c4c:	39 c1                	cmp    %eax,%ecx
  800c4e:	72 29                	jb     800c79 <_main+0xc41>
  800c50:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
  800c56:	89 c1                	mov    %eax,%ecx
  800c58:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800c5b:	89 d0                	mov    %edx,%eax
  800c5d:	01 c0                	add    %eax,%eax
  800c5f:	01 d0                	add    %edx,%eax
  800c61:	c1 e0 02             	shl    $0x2,%eax
  800c64:	01 d0                	add    %edx,%eax
  800c66:	89 c2                	mov    %eax,%edx
  800c68:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c6b:	c1 e0 04             	shl    $0x4,%eax
  800c6e:	01 d0                	add    %edx,%eax
  800c70:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800c75:	39 c1                	cmp    %eax,%ecx
  800c77:	76 17                	jbe    800c90 <_main+0xc58>
  800c79:	83 ec 04             	sub    $0x4,%esp
  800c7c:	68 10 3f 80 00       	push   $0x803f10
  800c81:	68 bb 00 00 00       	push   $0xbb
  800c86:	68 fc 3e 80 00       	push   $0x803efc
  800c8b:	e8 d8 02 00 00       	call   800f68 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800c90:	e8 81 19 00 00       	call   802616 <sys_pf_calculate_allocated_pages>
  800c95:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800c98:	74 17                	je     800cb1 <_main+0xc79>
  800c9a:	83 ec 04             	sub    $0x4,%esp
  800c9d:	68 78 3f 80 00       	push   $0x803f78
  800ca2:	68 bc 00 00 00       	push   $0xbc
  800ca7:	68 fc 3e 80 00       	push   $0x803efc
  800cac:	e8 b7 02 00 00       	call   800f68 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800cb1:	e8 c0 18 00 00       	call   802576 <sys_calculate_free_frames>
  800cb6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		shortArr2 = (short *) ptr_allocations[7];
  800cb9:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
  800cbf:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
		lastIndexOfShort2 = (14*kilo)/sizeof(short) - 1;
  800cc5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800cc8:	89 d0                	mov    %edx,%eax
  800cca:	01 c0                	add    %eax,%eax
  800ccc:	01 d0                	add    %edx,%eax
  800cce:	01 c0                	add    %eax,%eax
  800cd0:	01 d0                	add    %edx,%eax
  800cd2:	01 c0                	add    %eax,%eax
  800cd4:	d1 e8                	shr    %eax
  800cd6:	48                   	dec    %eax
  800cd7:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
		shortArr2[0] = minShort;
  800cdd:	8b 95 40 ff ff ff    	mov    -0xc0(%ebp),%edx
  800ce3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800ce6:	66 89 02             	mov    %ax,(%edx)
		shortArr2[lastIndexOfShort2] = maxShort;
  800ce9:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800cef:	01 c0                	add    %eax,%eax
  800cf1:	89 c2                	mov    %eax,%edx
  800cf3:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800cf9:	01 c2                	add    %eax,%edx
  800cfb:	66 8b 45 da          	mov    -0x26(%ebp),%ax
  800cff:	66 89 02             	mov    %ax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800d02:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  800d05:	e8 6c 18 00 00       	call   802576 <sys_calculate_free_frames>
  800d0a:	29 c3                	sub    %eax,%ebx
  800d0c:	89 d8                	mov    %ebx,%eax
  800d0e:	83 f8 02             	cmp    $0x2,%eax
  800d11:	74 17                	je     800d2a <_main+0xcf2>
  800d13:	83 ec 04             	sub    $0x4,%esp
  800d16:	68 a8 3f 80 00       	push   $0x803fa8
  800d1b:	68 c3 00 00 00       	push   $0xc3
  800d20:	68 fc 3e 80 00       	push   $0x803efc
  800d25:	e8 3e 02 00 00       	call   800f68 <_panic>
		found = 0;
  800d2a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800d31:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800d38:	e9 a7 00 00 00       	jmp    800de4 <_main+0xdac>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE))
  800d3d:	a1 20 50 80 00       	mov    0x805020,%eax
  800d42:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800d48:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800d4b:	89 d0                	mov    %edx,%eax
  800d4d:	01 c0                	add    %eax,%eax
  800d4f:	01 d0                	add    %edx,%eax
  800d51:	c1 e0 03             	shl    $0x3,%eax
  800d54:	01 c8                	add    %ecx,%eax
  800d56:	8b 00                	mov    (%eax),%eax
  800d58:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%ebp)
  800d5e:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  800d64:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d69:	89 c2                	mov    %eax,%edx
  800d6b:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800d71:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%ebp)
  800d77:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  800d7d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d82:	39 c2                	cmp    %eax,%edx
  800d84:	75 03                	jne    800d89 <_main+0xd51>
				found++;
  800d86:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE))
  800d89:	a1 20 50 80 00       	mov    0x805020,%eax
  800d8e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800d94:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800d97:	89 d0                	mov    %edx,%eax
  800d99:	01 c0                	add    %eax,%eax
  800d9b:	01 d0                	add    %edx,%eax
  800d9d:	c1 e0 03             	shl    $0x3,%eax
  800da0:	01 c8                	add    %ecx,%eax
  800da2:	8b 00                	mov    (%eax),%eax
  800da4:	89 85 30 ff ff ff    	mov    %eax,-0xd0(%ebp)
  800daa:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  800db0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800db5:	89 c2                	mov    %eax,%edx
  800db7:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800dbd:	01 c0                	add    %eax,%eax
  800dbf:	89 c1                	mov    %eax,%ecx
  800dc1:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800dc7:	01 c8                	add    %ecx,%eax
  800dc9:	89 85 2c ff ff ff    	mov    %eax,-0xd4(%ebp)
  800dcf:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  800dd5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800dda:	39 c2                	cmp    %eax,%edx
  800ddc:	75 03                	jne    800de1 <_main+0xda9>
				found++;
  800dde:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfShort2 = (14*kilo)/sizeof(short) - 1;
		shortArr2[0] = minShort;
		shortArr2[lastIndexOfShort2] = maxShort;
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800de1:	ff 45 ec             	incl   -0x14(%ebp)
  800de4:	a1 20 50 80 00       	mov    0x805020,%eax
  800de9:	8b 50 74             	mov    0x74(%eax),%edx
  800dec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800def:	39 c2                	cmp    %eax,%edx
  800df1:	0f 87 46 ff ff ff    	ja     800d3d <_main+0xd05>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  800df7:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  800dfb:	74 17                	je     800e14 <_main+0xddc>
  800dfd:	83 ec 04             	sub    $0x4,%esp
  800e00:	68 ec 3f 80 00       	push   $0x803fec
  800e05:	68 cc 00 00 00       	push   $0xcc
  800e0a:	68 fc 3e 80 00       	push   $0x803efc
  800e0f:	e8 54 01 00 00       	call   800f68 <_panic>
	}

	cprintf("Congratulations!! test malloc [3] completed successfully.\n");
  800e14:	83 ec 0c             	sub    $0xc,%esp
  800e17:	68 0c 40 80 00       	push   $0x80400c
  800e1c:	e8 fb 03 00 00       	call   80121c <cprintf>
  800e21:	83 c4 10             	add    $0x10,%esp

	return;
  800e24:	90                   	nop
}
  800e25:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e28:	5b                   	pop    %ebx
  800e29:	5f                   	pop    %edi
  800e2a:	5d                   	pop    %ebp
  800e2b:	c3                   	ret    

00800e2c <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800e2c:	55                   	push   %ebp
  800e2d:	89 e5                	mov    %esp,%ebp
  800e2f:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800e32:	e8 1f 1a 00 00       	call   802856 <sys_getenvindex>
  800e37:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800e3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e3d:	89 d0                	mov    %edx,%eax
  800e3f:	c1 e0 03             	shl    $0x3,%eax
  800e42:	01 d0                	add    %edx,%eax
  800e44:	01 c0                	add    %eax,%eax
  800e46:	01 d0                	add    %edx,%eax
  800e48:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800e4f:	01 d0                	add    %edx,%eax
  800e51:	c1 e0 04             	shl    $0x4,%eax
  800e54:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800e59:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800e5e:	a1 20 50 80 00       	mov    0x805020,%eax
  800e63:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800e69:	84 c0                	test   %al,%al
  800e6b:	74 0f                	je     800e7c <libmain+0x50>
		binaryname = myEnv->prog_name;
  800e6d:	a1 20 50 80 00       	mov    0x805020,%eax
  800e72:	05 5c 05 00 00       	add    $0x55c,%eax
  800e77:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800e7c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e80:	7e 0a                	jle    800e8c <libmain+0x60>
		binaryname = argv[0];
  800e82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e85:	8b 00                	mov    (%eax),%eax
  800e87:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800e8c:	83 ec 08             	sub    $0x8,%esp
  800e8f:	ff 75 0c             	pushl  0xc(%ebp)
  800e92:	ff 75 08             	pushl  0x8(%ebp)
  800e95:	e8 9e f1 ff ff       	call   800038 <_main>
  800e9a:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800e9d:	e8 c1 17 00 00       	call   802663 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800ea2:	83 ec 0c             	sub    $0xc,%esp
  800ea5:	68 60 40 80 00       	push   $0x804060
  800eaa:	e8 6d 03 00 00       	call   80121c <cprintf>
  800eaf:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800eb2:	a1 20 50 80 00       	mov    0x805020,%eax
  800eb7:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800ebd:	a1 20 50 80 00       	mov    0x805020,%eax
  800ec2:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800ec8:	83 ec 04             	sub    $0x4,%esp
  800ecb:	52                   	push   %edx
  800ecc:	50                   	push   %eax
  800ecd:	68 88 40 80 00       	push   $0x804088
  800ed2:	e8 45 03 00 00       	call   80121c <cprintf>
  800ed7:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800eda:	a1 20 50 80 00       	mov    0x805020,%eax
  800edf:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800ee5:	a1 20 50 80 00       	mov    0x805020,%eax
  800eea:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800ef0:	a1 20 50 80 00       	mov    0x805020,%eax
  800ef5:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800efb:	51                   	push   %ecx
  800efc:	52                   	push   %edx
  800efd:	50                   	push   %eax
  800efe:	68 b0 40 80 00       	push   $0x8040b0
  800f03:	e8 14 03 00 00       	call   80121c <cprintf>
  800f08:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800f0b:	a1 20 50 80 00       	mov    0x805020,%eax
  800f10:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800f16:	83 ec 08             	sub    $0x8,%esp
  800f19:	50                   	push   %eax
  800f1a:	68 08 41 80 00       	push   $0x804108
  800f1f:	e8 f8 02 00 00       	call   80121c <cprintf>
  800f24:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800f27:	83 ec 0c             	sub    $0xc,%esp
  800f2a:	68 60 40 80 00       	push   $0x804060
  800f2f:	e8 e8 02 00 00       	call   80121c <cprintf>
  800f34:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800f37:	e8 41 17 00 00       	call   80267d <sys_enable_interrupt>

	// exit gracefully
	exit();
  800f3c:	e8 19 00 00 00       	call   800f5a <exit>
}
  800f41:	90                   	nop
  800f42:	c9                   	leave  
  800f43:	c3                   	ret    

00800f44 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800f44:	55                   	push   %ebp
  800f45:	89 e5                	mov    %esp,%ebp
  800f47:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800f4a:	83 ec 0c             	sub    $0xc,%esp
  800f4d:	6a 00                	push   $0x0
  800f4f:	e8 ce 18 00 00       	call   802822 <sys_destroy_env>
  800f54:	83 c4 10             	add    $0x10,%esp
}
  800f57:	90                   	nop
  800f58:	c9                   	leave  
  800f59:	c3                   	ret    

00800f5a <exit>:

void
exit(void)
{
  800f5a:	55                   	push   %ebp
  800f5b:	89 e5                	mov    %esp,%ebp
  800f5d:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800f60:	e8 23 19 00 00       	call   802888 <sys_exit_env>
}
  800f65:	90                   	nop
  800f66:	c9                   	leave  
  800f67:	c3                   	ret    

00800f68 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800f68:	55                   	push   %ebp
  800f69:	89 e5                	mov    %esp,%ebp
  800f6b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800f6e:	8d 45 10             	lea    0x10(%ebp),%eax
  800f71:	83 c0 04             	add    $0x4,%eax
  800f74:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800f77:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800f7c:	85 c0                	test   %eax,%eax
  800f7e:	74 16                	je     800f96 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800f80:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800f85:	83 ec 08             	sub    $0x8,%esp
  800f88:	50                   	push   %eax
  800f89:	68 1c 41 80 00       	push   $0x80411c
  800f8e:	e8 89 02 00 00       	call   80121c <cprintf>
  800f93:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800f96:	a1 00 50 80 00       	mov    0x805000,%eax
  800f9b:	ff 75 0c             	pushl  0xc(%ebp)
  800f9e:	ff 75 08             	pushl  0x8(%ebp)
  800fa1:	50                   	push   %eax
  800fa2:	68 21 41 80 00       	push   $0x804121
  800fa7:	e8 70 02 00 00       	call   80121c <cprintf>
  800fac:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800faf:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb2:	83 ec 08             	sub    $0x8,%esp
  800fb5:	ff 75 f4             	pushl  -0xc(%ebp)
  800fb8:	50                   	push   %eax
  800fb9:	e8 f3 01 00 00       	call   8011b1 <vcprintf>
  800fbe:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800fc1:	83 ec 08             	sub    $0x8,%esp
  800fc4:	6a 00                	push   $0x0
  800fc6:	68 3d 41 80 00       	push   $0x80413d
  800fcb:	e8 e1 01 00 00       	call   8011b1 <vcprintf>
  800fd0:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800fd3:	e8 82 ff ff ff       	call   800f5a <exit>

	// should not return here
	while (1) ;
  800fd8:	eb fe                	jmp    800fd8 <_panic+0x70>

00800fda <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800fda:	55                   	push   %ebp
  800fdb:	89 e5                	mov    %esp,%ebp
  800fdd:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800fe0:	a1 20 50 80 00       	mov    0x805020,%eax
  800fe5:	8b 50 74             	mov    0x74(%eax),%edx
  800fe8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800feb:	39 c2                	cmp    %eax,%edx
  800fed:	74 14                	je     801003 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800fef:	83 ec 04             	sub    $0x4,%esp
  800ff2:	68 40 41 80 00       	push   $0x804140
  800ff7:	6a 26                	push   $0x26
  800ff9:	68 8c 41 80 00       	push   $0x80418c
  800ffe:	e8 65 ff ff ff       	call   800f68 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801003:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80100a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801011:	e9 c2 00 00 00       	jmp    8010d8 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  801016:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801019:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801020:	8b 45 08             	mov    0x8(%ebp),%eax
  801023:	01 d0                	add    %edx,%eax
  801025:	8b 00                	mov    (%eax),%eax
  801027:	85 c0                	test   %eax,%eax
  801029:	75 08                	jne    801033 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80102b:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80102e:	e9 a2 00 00 00       	jmp    8010d5 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  801033:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80103a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801041:	eb 69                	jmp    8010ac <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801043:	a1 20 50 80 00       	mov    0x805020,%eax
  801048:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80104e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801051:	89 d0                	mov    %edx,%eax
  801053:	01 c0                	add    %eax,%eax
  801055:	01 d0                	add    %edx,%eax
  801057:	c1 e0 03             	shl    $0x3,%eax
  80105a:	01 c8                	add    %ecx,%eax
  80105c:	8a 40 04             	mov    0x4(%eax),%al
  80105f:	84 c0                	test   %al,%al
  801061:	75 46                	jne    8010a9 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801063:	a1 20 50 80 00       	mov    0x805020,%eax
  801068:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80106e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801071:	89 d0                	mov    %edx,%eax
  801073:	01 c0                	add    %eax,%eax
  801075:	01 d0                	add    %edx,%eax
  801077:	c1 e0 03             	shl    $0x3,%eax
  80107a:	01 c8                	add    %ecx,%eax
  80107c:	8b 00                	mov    (%eax),%eax
  80107e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801081:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801084:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801089:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80108b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80108e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801095:	8b 45 08             	mov    0x8(%ebp),%eax
  801098:	01 c8                	add    %ecx,%eax
  80109a:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80109c:	39 c2                	cmp    %eax,%edx
  80109e:	75 09                	jne    8010a9 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8010a0:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8010a7:	eb 12                	jmp    8010bb <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8010a9:	ff 45 e8             	incl   -0x18(%ebp)
  8010ac:	a1 20 50 80 00       	mov    0x805020,%eax
  8010b1:	8b 50 74             	mov    0x74(%eax),%edx
  8010b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8010b7:	39 c2                	cmp    %eax,%edx
  8010b9:	77 88                	ja     801043 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8010bb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8010bf:	75 14                	jne    8010d5 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8010c1:	83 ec 04             	sub    $0x4,%esp
  8010c4:	68 98 41 80 00       	push   $0x804198
  8010c9:	6a 3a                	push   $0x3a
  8010cb:	68 8c 41 80 00       	push   $0x80418c
  8010d0:	e8 93 fe ff ff       	call   800f68 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8010d5:	ff 45 f0             	incl   -0x10(%ebp)
  8010d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010db:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8010de:	0f 8c 32 ff ff ff    	jl     801016 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8010e4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8010eb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8010f2:	eb 26                	jmp    80111a <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8010f4:	a1 20 50 80 00       	mov    0x805020,%eax
  8010f9:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8010ff:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801102:	89 d0                	mov    %edx,%eax
  801104:	01 c0                	add    %eax,%eax
  801106:	01 d0                	add    %edx,%eax
  801108:	c1 e0 03             	shl    $0x3,%eax
  80110b:	01 c8                	add    %ecx,%eax
  80110d:	8a 40 04             	mov    0x4(%eax),%al
  801110:	3c 01                	cmp    $0x1,%al
  801112:	75 03                	jne    801117 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  801114:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801117:	ff 45 e0             	incl   -0x20(%ebp)
  80111a:	a1 20 50 80 00       	mov    0x805020,%eax
  80111f:	8b 50 74             	mov    0x74(%eax),%edx
  801122:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801125:	39 c2                	cmp    %eax,%edx
  801127:	77 cb                	ja     8010f4 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801129:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80112c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80112f:	74 14                	je     801145 <CheckWSWithoutLastIndex+0x16b>
		panic(
  801131:	83 ec 04             	sub    $0x4,%esp
  801134:	68 ec 41 80 00       	push   $0x8041ec
  801139:	6a 44                	push   $0x44
  80113b:	68 8c 41 80 00       	push   $0x80418c
  801140:	e8 23 fe ff ff       	call   800f68 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801145:	90                   	nop
  801146:	c9                   	leave  
  801147:	c3                   	ret    

00801148 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  801148:	55                   	push   %ebp
  801149:	89 e5                	mov    %esp,%ebp
  80114b:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80114e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801151:	8b 00                	mov    (%eax),%eax
  801153:	8d 48 01             	lea    0x1(%eax),%ecx
  801156:	8b 55 0c             	mov    0xc(%ebp),%edx
  801159:	89 0a                	mov    %ecx,(%edx)
  80115b:	8b 55 08             	mov    0x8(%ebp),%edx
  80115e:	88 d1                	mov    %dl,%cl
  801160:	8b 55 0c             	mov    0xc(%ebp),%edx
  801163:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  801167:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116a:	8b 00                	mov    (%eax),%eax
  80116c:	3d ff 00 00 00       	cmp    $0xff,%eax
  801171:	75 2c                	jne    80119f <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  801173:	a0 24 50 80 00       	mov    0x805024,%al
  801178:	0f b6 c0             	movzbl %al,%eax
  80117b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80117e:	8b 12                	mov    (%edx),%edx
  801180:	89 d1                	mov    %edx,%ecx
  801182:	8b 55 0c             	mov    0xc(%ebp),%edx
  801185:	83 c2 08             	add    $0x8,%edx
  801188:	83 ec 04             	sub    $0x4,%esp
  80118b:	50                   	push   %eax
  80118c:	51                   	push   %ecx
  80118d:	52                   	push   %edx
  80118e:	e8 22 13 00 00       	call   8024b5 <sys_cputs>
  801193:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  801196:	8b 45 0c             	mov    0xc(%ebp),%eax
  801199:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80119f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a2:	8b 40 04             	mov    0x4(%eax),%eax
  8011a5:	8d 50 01             	lea    0x1(%eax),%edx
  8011a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ab:	89 50 04             	mov    %edx,0x4(%eax)
}
  8011ae:	90                   	nop
  8011af:	c9                   	leave  
  8011b0:	c3                   	ret    

008011b1 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8011b1:	55                   	push   %ebp
  8011b2:	89 e5                	mov    %esp,%ebp
  8011b4:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8011ba:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8011c1:	00 00 00 
	b.cnt = 0;
  8011c4:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8011cb:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8011ce:	ff 75 0c             	pushl  0xc(%ebp)
  8011d1:	ff 75 08             	pushl  0x8(%ebp)
  8011d4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8011da:	50                   	push   %eax
  8011db:	68 48 11 80 00       	push   $0x801148
  8011e0:	e8 11 02 00 00       	call   8013f6 <vprintfmt>
  8011e5:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8011e8:	a0 24 50 80 00       	mov    0x805024,%al
  8011ed:	0f b6 c0             	movzbl %al,%eax
  8011f0:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8011f6:	83 ec 04             	sub    $0x4,%esp
  8011f9:	50                   	push   %eax
  8011fa:	52                   	push   %edx
  8011fb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801201:	83 c0 08             	add    $0x8,%eax
  801204:	50                   	push   %eax
  801205:	e8 ab 12 00 00       	call   8024b5 <sys_cputs>
  80120a:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80120d:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  801214:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80121a:	c9                   	leave  
  80121b:	c3                   	ret    

0080121c <cprintf>:

int cprintf(const char *fmt, ...) {
  80121c:	55                   	push   %ebp
  80121d:	89 e5                	mov    %esp,%ebp
  80121f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801222:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  801229:	8d 45 0c             	lea    0xc(%ebp),%eax
  80122c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80122f:	8b 45 08             	mov    0x8(%ebp),%eax
  801232:	83 ec 08             	sub    $0x8,%esp
  801235:	ff 75 f4             	pushl  -0xc(%ebp)
  801238:	50                   	push   %eax
  801239:	e8 73 ff ff ff       	call   8011b1 <vcprintf>
  80123e:	83 c4 10             	add    $0x10,%esp
  801241:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801244:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801247:	c9                   	leave  
  801248:	c3                   	ret    

00801249 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  801249:	55                   	push   %ebp
  80124a:	89 e5                	mov    %esp,%ebp
  80124c:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80124f:	e8 0f 14 00 00       	call   802663 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801254:	8d 45 0c             	lea    0xc(%ebp),%eax
  801257:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80125a:	8b 45 08             	mov    0x8(%ebp),%eax
  80125d:	83 ec 08             	sub    $0x8,%esp
  801260:	ff 75 f4             	pushl  -0xc(%ebp)
  801263:	50                   	push   %eax
  801264:	e8 48 ff ff ff       	call   8011b1 <vcprintf>
  801269:	83 c4 10             	add    $0x10,%esp
  80126c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80126f:	e8 09 14 00 00       	call   80267d <sys_enable_interrupt>
	return cnt;
  801274:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801277:	c9                   	leave  
  801278:	c3                   	ret    

00801279 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801279:	55                   	push   %ebp
  80127a:	89 e5                	mov    %esp,%ebp
  80127c:	53                   	push   %ebx
  80127d:	83 ec 14             	sub    $0x14,%esp
  801280:	8b 45 10             	mov    0x10(%ebp),%eax
  801283:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801286:	8b 45 14             	mov    0x14(%ebp),%eax
  801289:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80128c:	8b 45 18             	mov    0x18(%ebp),%eax
  80128f:	ba 00 00 00 00       	mov    $0x0,%edx
  801294:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801297:	77 55                	ja     8012ee <printnum+0x75>
  801299:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80129c:	72 05                	jb     8012a3 <printnum+0x2a>
  80129e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012a1:	77 4b                	ja     8012ee <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8012a3:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8012a6:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8012a9:	8b 45 18             	mov    0x18(%ebp),%eax
  8012ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8012b1:	52                   	push   %edx
  8012b2:	50                   	push   %eax
  8012b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8012b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8012b9:	e8 b2 29 00 00       	call   803c70 <__udivdi3>
  8012be:	83 c4 10             	add    $0x10,%esp
  8012c1:	83 ec 04             	sub    $0x4,%esp
  8012c4:	ff 75 20             	pushl  0x20(%ebp)
  8012c7:	53                   	push   %ebx
  8012c8:	ff 75 18             	pushl  0x18(%ebp)
  8012cb:	52                   	push   %edx
  8012cc:	50                   	push   %eax
  8012cd:	ff 75 0c             	pushl  0xc(%ebp)
  8012d0:	ff 75 08             	pushl  0x8(%ebp)
  8012d3:	e8 a1 ff ff ff       	call   801279 <printnum>
  8012d8:	83 c4 20             	add    $0x20,%esp
  8012db:	eb 1a                	jmp    8012f7 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8012dd:	83 ec 08             	sub    $0x8,%esp
  8012e0:	ff 75 0c             	pushl  0xc(%ebp)
  8012e3:	ff 75 20             	pushl  0x20(%ebp)
  8012e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e9:	ff d0                	call   *%eax
  8012eb:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8012ee:	ff 4d 1c             	decl   0x1c(%ebp)
  8012f1:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8012f5:	7f e6                	jg     8012dd <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8012f7:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8012fa:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801302:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801305:	53                   	push   %ebx
  801306:	51                   	push   %ecx
  801307:	52                   	push   %edx
  801308:	50                   	push   %eax
  801309:	e8 72 2a 00 00       	call   803d80 <__umoddi3>
  80130e:	83 c4 10             	add    $0x10,%esp
  801311:	05 54 44 80 00       	add    $0x804454,%eax
  801316:	8a 00                	mov    (%eax),%al
  801318:	0f be c0             	movsbl %al,%eax
  80131b:	83 ec 08             	sub    $0x8,%esp
  80131e:	ff 75 0c             	pushl  0xc(%ebp)
  801321:	50                   	push   %eax
  801322:	8b 45 08             	mov    0x8(%ebp),%eax
  801325:	ff d0                	call   *%eax
  801327:	83 c4 10             	add    $0x10,%esp
}
  80132a:	90                   	nop
  80132b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80132e:	c9                   	leave  
  80132f:	c3                   	ret    

00801330 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801330:	55                   	push   %ebp
  801331:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801333:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801337:	7e 1c                	jle    801355 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801339:	8b 45 08             	mov    0x8(%ebp),%eax
  80133c:	8b 00                	mov    (%eax),%eax
  80133e:	8d 50 08             	lea    0x8(%eax),%edx
  801341:	8b 45 08             	mov    0x8(%ebp),%eax
  801344:	89 10                	mov    %edx,(%eax)
  801346:	8b 45 08             	mov    0x8(%ebp),%eax
  801349:	8b 00                	mov    (%eax),%eax
  80134b:	83 e8 08             	sub    $0x8,%eax
  80134e:	8b 50 04             	mov    0x4(%eax),%edx
  801351:	8b 00                	mov    (%eax),%eax
  801353:	eb 40                	jmp    801395 <getuint+0x65>
	else if (lflag)
  801355:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801359:	74 1e                	je     801379 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80135b:	8b 45 08             	mov    0x8(%ebp),%eax
  80135e:	8b 00                	mov    (%eax),%eax
  801360:	8d 50 04             	lea    0x4(%eax),%edx
  801363:	8b 45 08             	mov    0x8(%ebp),%eax
  801366:	89 10                	mov    %edx,(%eax)
  801368:	8b 45 08             	mov    0x8(%ebp),%eax
  80136b:	8b 00                	mov    (%eax),%eax
  80136d:	83 e8 04             	sub    $0x4,%eax
  801370:	8b 00                	mov    (%eax),%eax
  801372:	ba 00 00 00 00       	mov    $0x0,%edx
  801377:	eb 1c                	jmp    801395 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801379:	8b 45 08             	mov    0x8(%ebp),%eax
  80137c:	8b 00                	mov    (%eax),%eax
  80137e:	8d 50 04             	lea    0x4(%eax),%edx
  801381:	8b 45 08             	mov    0x8(%ebp),%eax
  801384:	89 10                	mov    %edx,(%eax)
  801386:	8b 45 08             	mov    0x8(%ebp),%eax
  801389:	8b 00                	mov    (%eax),%eax
  80138b:	83 e8 04             	sub    $0x4,%eax
  80138e:	8b 00                	mov    (%eax),%eax
  801390:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801395:	5d                   	pop    %ebp
  801396:	c3                   	ret    

00801397 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801397:	55                   	push   %ebp
  801398:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80139a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80139e:	7e 1c                	jle    8013bc <getint+0x25>
		return va_arg(*ap, long long);
  8013a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a3:	8b 00                	mov    (%eax),%eax
  8013a5:	8d 50 08             	lea    0x8(%eax),%edx
  8013a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ab:	89 10                	mov    %edx,(%eax)
  8013ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b0:	8b 00                	mov    (%eax),%eax
  8013b2:	83 e8 08             	sub    $0x8,%eax
  8013b5:	8b 50 04             	mov    0x4(%eax),%edx
  8013b8:	8b 00                	mov    (%eax),%eax
  8013ba:	eb 38                	jmp    8013f4 <getint+0x5d>
	else if (lflag)
  8013bc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8013c0:	74 1a                	je     8013dc <getint+0x45>
		return va_arg(*ap, long);
  8013c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c5:	8b 00                	mov    (%eax),%eax
  8013c7:	8d 50 04             	lea    0x4(%eax),%edx
  8013ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cd:	89 10                	mov    %edx,(%eax)
  8013cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d2:	8b 00                	mov    (%eax),%eax
  8013d4:	83 e8 04             	sub    $0x4,%eax
  8013d7:	8b 00                	mov    (%eax),%eax
  8013d9:	99                   	cltd   
  8013da:	eb 18                	jmp    8013f4 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8013dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013df:	8b 00                	mov    (%eax),%eax
  8013e1:	8d 50 04             	lea    0x4(%eax),%edx
  8013e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e7:	89 10                	mov    %edx,(%eax)
  8013e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ec:	8b 00                	mov    (%eax),%eax
  8013ee:	83 e8 04             	sub    $0x4,%eax
  8013f1:	8b 00                	mov    (%eax),%eax
  8013f3:	99                   	cltd   
}
  8013f4:	5d                   	pop    %ebp
  8013f5:	c3                   	ret    

008013f6 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8013f6:	55                   	push   %ebp
  8013f7:	89 e5                	mov    %esp,%ebp
  8013f9:	56                   	push   %esi
  8013fa:	53                   	push   %ebx
  8013fb:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8013fe:	eb 17                	jmp    801417 <vprintfmt+0x21>
			if (ch == '\0')
  801400:	85 db                	test   %ebx,%ebx
  801402:	0f 84 af 03 00 00    	je     8017b7 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  801408:	83 ec 08             	sub    $0x8,%esp
  80140b:	ff 75 0c             	pushl  0xc(%ebp)
  80140e:	53                   	push   %ebx
  80140f:	8b 45 08             	mov    0x8(%ebp),%eax
  801412:	ff d0                	call   *%eax
  801414:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801417:	8b 45 10             	mov    0x10(%ebp),%eax
  80141a:	8d 50 01             	lea    0x1(%eax),%edx
  80141d:	89 55 10             	mov    %edx,0x10(%ebp)
  801420:	8a 00                	mov    (%eax),%al
  801422:	0f b6 d8             	movzbl %al,%ebx
  801425:	83 fb 25             	cmp    $0x25,%ebx
  801428:	75 d6                	jne    801400 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80142a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80142e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801435:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80143c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801443:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80144a:	8b 45 10             	mov    0x10(%ebp),%eax
  80144d:	8d 50 01             	lea    0x1(%eax),%edx
  801450:	89 55 10             	mov    %edx,0x10(%ebp)
  801453:	8a 00                	mov    (%eax),%al
  801455:	0f b6 d8             	movzbl %al,%ebx
  801458:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80145b:	83 f8 55             	cmp    $0x55,%eax
  80145e:	0f 87 2b 03 00 00    	ja     80178f <vprintfmt+0x399>
  801464:	8b 04 85 78 44 80 00 	mov    0x804478(,%eax,4),%eax
  80146b:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80146d:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801471:	eb d7                	jmp    80144a <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801473:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801477:	eb d1                	jmp    80144a <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801479:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801480:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801483:	89 d0                	mov    %edx,%eax
  801485:	c1 e0 02             	shl    $0x2,%eax
  801488:	01 d0                	add    %edx,%eax
  80148a:	01 c0                	add    %eax,%eax
  80148c:	01 d8                	add    %ebx,%eax
  80148e:	83 e8 30             	sub    $0x30,%eax
  801491:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801494:	8b 45 10             	mov    0x10(%ebp),%eax
  801497:	8a 00                	mov    (%eax),%al
  801499:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80149c:	83 fb 2f             	cmp    $0x2f,%ebx
  80149f:	7e 3e                	jle    8014df <vprintfmt+0xe9>
  8014a1:	83 fb 39             	cmp    $0x39,%ebx
  8014a4:	7f 39                	jg     8014df <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8014a6:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8014a9:	eb d5                	jmp    801480 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8014ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ae:	83 c0 04             	add    $0x4,%eax
  8014b1:	89 45 14             	mov    %eax,0x14(%ebp)
  8014b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8014b7:	83 e8 04             	sub    $0x4,%eax
  8014ba:	8b 00                	mov    (%eax),%eax
  8014bc:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8014bf:	eb 1f                	jmp    8014e0 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8014c1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8014c5:	79 83                	jns    80144a <vprintfmt+0x54>
				width = 0;
  8014c7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8014ce:	e9 77 ff ff ff       	jmp    80144a <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8014d3:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8014da:	e9 6b ff ff ff       	jmp    80144a <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8014df:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8014e0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8014e4:	0f 89 60 ff ff ff    	jns    80144a <vprintfmt+0x54>
				width = precision, precision = -1;
  8014ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8014f0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8014f7:	e9 4e ff ff ff       	jmp    80144a <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8014fc:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8014ff:	e9 46 ff ff ff       	jmp    80144a <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801504:	8b 45 14             	mov    0x14(%ebp),%eax
  801507:	83 c0 04             	add    $0x4,%eax
  80150a:	89 45 14             	mov    %eax,0x14(%ebp)
  80150d:	8b 45 14             	mov    0x14(%ebp),%eax
  801510:	83 e8 04             	sub    $0x4,%eax
  801513:	8b 00                	mov    (%eax),%eax
  801515:	83 ec 08             	sub    $0x8,%esp
  801518:	ff 75 0c             	pushl  0xc(%ebp)
  80151b:	50                   	push   %eax
  80151c:	8b 45 08             	mov    0x8(%ebp),%eax
  80151f:	ff d0                	call   *%eax
  801521:	83 c4 10             	add    $0x10,%esp
			break;
  801524:	e9 89 02 00 00       	jmp    8017b2 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801529:	8b 45 14             	mov    0x14(%ebp),%eax
  80152c:	83 c0 04             	add    $0x4,%eax
  80152f:	89 45 14             	mov    %eax,0x14(%ebp)
  801532:	8b 45 14             	mov    0x14(%ebp),%eax
  801535:	83 e8 04             	sub    $0x4,%eax
  801538:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80153a:	85 db                	test   %ebx,%ebx
  80153c:	79 02                	jns    801540 <vprintfmt+0x14a>
				err = -err;
  80153e:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801540:	83 fb 64             	cmp    $0x64,%ebx
  801543:	7f 0b                	jg     801550 <vprintfmt+0x15a>
  801545:	8b 34 9d c0 42 80 00 	mov    0x8042c0(,%ebx,4),%esi
  80154c:	85 f6                	test   %esi,%esi
  80154e:	75 19                	jne    801569 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801550:	53                   	push   %ebx
  801551:	68 65 44 80 00       	push   $0x804465
  801556:	ff 75 0c             	pushl  0xc(%ebp)
  801559:	ff 75 08             	pushl  0x8(%ebp)
  80155c:	e8 5e 02 00 00       	call   8017bf <printfmt>
  801561:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801564:	e9 49 02 00 00       	jmp    8017b2 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801569:	56                   	push   %esi
  80156a:	68 6e 44 80 00       	push   $0x80446e
  80156f:	ff 75 0c             	pushl  0xc(%ebp)
  801572:	ff 75 08             	pushl  0x8(%ebp)
  801575:	e8 45 02 00 00       	call   8017bf <printfmt>
  80157a:	83 c4 10             	add    $0x10,%esp
			break;
  80157d:	e9 30 02 00 00       	jmp    8017b2 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801582:	8b 45 14             	mov    0x14(%ebp),%eax
  801585:	83 c0 04             	add    $0x4,%eax
  801588:	89 45 14             	mov    %eax,0x14(%ebp)
  80158b:	8b 45 14             	mov    0x14(%ebp),%eax
  80158e:	83 e8 04             	sub    $0x4,%eax
  801591:	8b 30                	mov    (%eax),%esi
  801593:	85 f6                	test   %esi,%esi
  801595:	75 05                	jne    80159c <vprintfmt+0x1a6>
				p = "(null)";
  801597:	be 71 44 80 00       	mov    $0x804471,%esi
			if (width > 0 && padc != '-')
  80159c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8015a0:	7e 6d                	jle    80160f <vprintfmt+0x219>
  8015a2:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8015a6:	74 67                	je     80160f <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8015a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015ab:	83 ec 08             	sub    $0x8,%esp
  8015ae:	50                   	push   %eax
  8015af:	56                   	push   %esi
  8015b0:	e8 0c 03 00 00       	call   8018c1 <strnlen>
  8015b5:	83 c4 10             	add    $0x10,%esp
  8015b8:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8015bb:	eb 16                	jmp    8015d3 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8015bd:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8015c1:	83 ec 08             	sub    $0x8,%esp
  8015c4:	ff 75 0c             	pushl  0xc(%ebp)
  8015c7:	50                   	push   %eax
  8015c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cb:	ff d0                	call   *%eax
  8015cd:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8015d0:	ff 4d e4             	decl   -0x1c(%ebp)
  8015d3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8015d7:	7f e4                	jg     8015bd <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8015d9:	eb 34                	jmp    80160f <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8015db:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8015df:	74 1c                	je     8015fd <vprintfmt+0x207>
  8015e1:	83 fb 1f             	cmp    $0x1f,%ebx
  8015e4:	7e 05                	jle    8015eb <vprintfmt+0x1f5>
  8015e6:	83 fb 7e             	cmp    $0x7e,%ebx
  8015e9:	7e 12                	jle    8015fd <vprintfmt+0x207>
					putch('?', putdat);
  8015eb:	83 ec 08             	sub    $0x8,%esp
  8015ee:	ff 75 0c             	pushl  0xc(%ebp)
  8015f1:	6a 3f                	push   $0x3f
  8015f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f6:	ff d0                	call   *%eax
  8015f8:	83 c4 10             	add    $0x10,%esp
  8015fb:	eb 0f                	jmp    80160c <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8015fd:	83 ec 08             	sub    $0x8,%esp
  801600:	ff 75 0c             	pushl  0xc(%ebp)
  801603:	53                   	push   %ebx
  801604:	8b 45 08             	mov    0x8(%ebp),%eax
  801607:	ff d0                	call   *%eax
  801609:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80160c:	ff 4d e4             	decl   -0x1c(%ebp)
  80160f:	89 f0                	mov    %esi,%eax
  801611:	8d 70 01             	lea    0x1(%eax),%esi
  801614:	8a 00                	mov    (%eax),%al
  801616:	0f be d8             	movsbl %al,%ebx
  801619:	85 db                	test   %ebx,%ebx
  80161b:	74 24                	je     801641 <vprintfmt+0x24b>
  80161d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801621:	78 b8                	js     8015db <vprintfmt+0x1e5>
  801623:	ff 4d e0             	decl   -0x20(%ebp)
  801626:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80162a:	79 af                	jns    8015db <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80162c:	eb 13                	jmp    801641 <vprintfmt+0x24b>
				putch(' ', putdat);
  80162e:	83 ec 08             	sub    $0x8,%esp
  801631:	ff 75 0c             	pushl  0xc(%ebp)
  801634:	6a 20                	push   $0x20
  801636:	8b 45 08             	mov    0x8(%ebp),%eax
  801639:	ff d0                	call   *%eax
  80163b:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80163e:	ff 4d e4             	decl   -0x1c(%ebp)
  801641:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801645:	7f e7                	jg     80162e <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801647:	e9 66 01 00 00       	jmp    8017b2 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80164c:	83 ec 08             	sub    $0x8,%esp
  80164f:	ff 75 e8             	pushl  -0x18(%ebp)
  801652:	8d 45 14             	lea    0x14(%ebp),%eax
  801655:	50                   	push   %eax
  801656:	e8 3c fd ff ff       	call   801397 <getint>
  80165b:	83 c4 10             	add    $0x10,%esp
  80165e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801661:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801664:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801667:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80166a:	85 d2                	test   %edx,%edx
  80166c:	79 23                	jns    801691 <vprintfmt+0x29b>
				putch('-', putdat);
  80166e:	83 ec 08             	sub    $0x8,%esp
  801671:	ff 75 0c             	pushl  0xc(%ebp)
  801674:	6a 2d                	push   $0x2d
  801676:	8b 45 08             	mov    0x8(%ebp),%eax
  801679:	ff d0                	call   *%eax
  80167b:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80167e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801681:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801684:	f7 d8                	neg    %eax
  801686:	83 d2 00             	adc    $0x0,%edx
  801689:	f7 da                	neg    %edx
  80168b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80168e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801691:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801698:	e9 bc 00 00 00       	jmp    801759 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80169d:	83 ec 08             	sub    $0x8,%esp
  8016a0:	ff 75 e8             	pushl  -0x18(%ebp)
  8016a3:	8d 45 14             	lea    0x14(%ebp),%eax
  8016a6:	50                   	push   %eax
  8016a7:	e8 84 fc ff ff       	call   801330 <getuint>
  8016ac:	83 c4 10             	add    $0x10,%esp
  8016af:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016b2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8016b5:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8016bc:	e9 98 00 00 00       	jmp    801759 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8016c1:	83 ec 08             	sub    $0x8,%esp
  8016c4:	ff 75 0c             	pushl  0xc(%ebp)
  8016c7:	6a 58                	push   $0x58
  8016c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cc:	ff d0                	call   *%eax
  8016ce:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8016d1:	83 ec 08             	sub    $0x8,%esp
  8016d4:	ff 75 0c             	pushl  0xc(%ebp)
  8016d7:	6a 58                	push   $0x58
  8016d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016dc:	ff d0                	call   *%eax
  8016de:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8016e1:	83 ec 08             	sub    $0x8,%esp
  8016e4:	ff 75 0c             	pushl  0xc(%ebp)
  8016e7:	6a 58                	push   $0x58
  8016e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ec:	ff d0                	call   *%eax
  8016ee:	83 c4 10             	add    $0x10,%esp
			break;
  8016f1:	e9 bc 00 00 00       	jmp    8017b2 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8016f6:	83 ec 08             	sub    $0x8,%esp
  8016f9:	ff 75 0c             	pushl  0xc(%ebp)
  8016fc:	6a 30                	push   $0x30
  8016fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801701:	ff d0                	call   *%eax
  801703:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801706:	83 ec 08             	sub    $0x8,%esp
  801709:	ff 75 0c             	pushl  0xc(%ebp)
  80170c:	6a 78                	push   $0x78
  80170e:	8b 45 08             	mov    0x8(%ebp),%eax
  801711:	ff d0                	call   *%eax
  801713:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801716:	8b 45 14             	mov    0x14(%ebp),%eax
  801719:	83 c0 04             	add    $0x4,%eax
  80171c:	89 45 14             	mov    %eax,0x14(%ebp)
  80171f:	8b 45 14             	mov    0x14(%ebp),%eax
  801722:	83 e8 04             	sub    $0x4,%eax
  801725:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801727:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80172a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801731:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801738:	eb 1f                	jmp    801759 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80173a:	83 ec 08             	sub    $0x8,%esp
  80173d:	ff 75 e8             	pushl  -0x18(%ebp)
  801740:	8d 45 14             	lea    0x14(%ebp),%eax
  801743:	50                   	push   %eax
  801744:	e8 e7 fb ff ff       	call   801330 <getuint>
  801749:	83 c4 10             	add    $0x10,%esp
  80174c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80174f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801752:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801759:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80175d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801760:	83 ec 04             	sub    $0x4,%esp
  801763:	52                   	push   %edx
  801764:	ff 75 e4             	pushl  -0x1c(%ebp)
  801767:	50                   	push   %eax
  801768:	ff 75 f4             	pushl  -0xc(%ebp)
  80176b:	ff 75 f0             	pushl  -0x10(%ebp)
  80176e:	ff 75 0c             	pushl  0xc(%ebp)
  801771:	ff 75 08             	pushl  0x8(%ebp)
  801774:	e8 00 fb ff ff       	call   801279 <printnum>
  801779:	83 c4 20             	add    $0x20,%esp
			break;
  80177c:	eb 34                	jmp    8017b2 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80177e:	83 ec 08             	sub    $0x8,%esp
  801781:	ff 75 0c             	pushl  0xc(%ebp)
  801784:	53                   	push   %ebx
  801785:	8b 45 08             	mov    0x8(%ebp),%eax
  801788:	ff d0                	call   *%eax
  80178a:	83 c4 10             	add    $0x10,%esp
			break;
  80178d:	eb 23                	jmp    8017b2 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80178f:	83 ec 08             	sub    $0x8,%esp
  801792:	ff 75 0c             	pushl  0xc(%ebp)
  801795:	6a 25                	push   $0x25
  801797:	8b 45 08             	mov    0x8(%ebp),%eax
  80179a:	ff d0                	call   *%eax
  80179c:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80179f:	ff 4d 10             	decl   0x10(%ebp)
  8017a2:	eb 03                	jmp    8017a7 <vprintfmt+0x3b1>
  8017a4:	ff 4d 10             	decl   0x10(%ebp)
  8017a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8017aa:	48                   	dec    %eax
  8017ab:	8a 00                	mov    (%eax),%al
  8017ad:	3c 25                	cmp    $0x25,%al
  8017af:	75 f3                	jne    8017a4 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8017b1:	90                   	nop
		}
	}
  8017b2:	e9 47 fc ff ff       	jmp    8013fe <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8017b7:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8017b8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017bb:	5b                   	pop    %ebx
  8017bc:	5e                   	pop    %esi
  8017bd:	5d                   	pop    %ebp
  8017be:	c3                   	ret    

008017bf <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8017bf:	55                   	push   %ebp
  8017c0:	89 e5                	mov    %esp,%ebp
  8017c2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8017c5:	8d 45 10             	lea    0x10(%ebp),%eax
  8017c8:	83 c0 04             	add    $0x4,%eax
  8017cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8017ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8017d1:	ff 75 f4             	pushl  -0xc(%ebp)
  8017d4:	50                   	push   %eax
  8017d5:	ff 75 0c             	pushl  0xc(%ebp)
  8017d8:	ff 75 08             	pushl  0x8(%ebp)
  8017db:	e8 16 fc ff ff       	call   8013f6 <vprintfmt>
  8017e0:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8017e3:	90                   	nop
  8017e4:	c9                   	leave  
  8017e5:	c3                   	ret    

008017e6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8017e6:	55                   	push   %ebp
  8017e7:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8017e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ec:	8b 40 08             	mov    0x8(%eax),%eax
  8017ef:	8d 50 01             	lea    0x1(%eax),%edx
  8017f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f5:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8017f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017fb:	8b 10                	mov    (%eax),%edx
  8017fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801800:	8b 40 04             	mov    0x4(%eax),%eax
  801803:	39 c2                	cmp    %eax,%edx
  801805:	73 12                	jae    801819 <sprintputch+0x33>
		*b->buf++ = ch;
  801807:	8b 45 0c             	mov    0xc(%ebp),%eax
  80180a:	8b 00                	mov    (%eax),%eax
  80180c:	8d 48 01             	lea    0x1(%eax),%ecx
  80180f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801812:	89 0a                	mov    %ecx,(%edx)
  801814:	8b 55 08             	mov    0x8(%ebp),%edx
  801817:	88 10                	mov    %dl,(%eax)
}
  801819:	90                   	nop
  80181a:	5d                   	pop    %ebp
  80181b:	c3                   	ret    

0080181c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80181c:	55                   	push   %ebp
  80181d:	89 e5                	mov    %esp,%ebp
  80181f:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801822:	8b 45 08             	mov    0x8(%ebp),%eax
  801825:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801828:	8b 45 0c             	mov    0xc(%ebp),%eax
  80182b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80182e:	8b 45 08             	mov    0x8(%ebp),%eax
  801831:	01 d0                	add    %edx,%eax
  801833:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801836:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80183d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801841:	74 06                	je     801849 <vsnprintf+0x2d>
  801843:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801847:	7f 07                	jg     801850 <vsnprintf+0x34>
		return -E_INVAL;
  801849:	b8 03 00 00 00       	mov    $0x3,%eax
  80184e:	eb 20                	jmp    801870 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801850:	ff 75 14             	pushl  0x14(%ebp)
  801853:	ff 75 10             	pushl  0x10(%ebp)
  801856:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801859:	50                   	push   %eax
  80185a:	68 e6 17 80 00       	push   $0x8017e6
  80185f:	e8 92 fb ff ff       	call   8013f6 <vprintfmt>
  801864:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801867:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80186a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80186d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801870:	c9                   	leave  
  801871:	c3                   	ret    

00801872 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801872:	55                   	push   %ebp
  801873:	89 e5                	mov    %esp,%ebp
  801875:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801878:	8d 45 10             	lea    0x10(%ebp),%eax
  80187b:	83 c0 04             	add    $0x4,%eax
  80187e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801881:	8b 45 10             	mov    0x10(%ebp),%eax
  801884:	ff 75 f4             	pushl  -0xc(%ebp)
  801887:	50                   	push   %eax
  801888:	ff 75 0c             	pushl  0xc(%ebp)
  80188b:	ff 75 08             	pushl  0x8(%ebp)
  80188e:	e8 89 ff ff ff       	call   80181c <vsnprintf>
  801893:	83 c4 10             	add    $0x10,%esp
  801896:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801899:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80189c:	c9                   	leave  
  80189d:	c3                   	ret    

0080189e <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80189e:	55                   	push   %ebp
  80189f:	89 e5                	mov    %esp,%ebp
  8018a1:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8018a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8018ab:	eb 06                	jmp    8018b3 <strlen+0x15>
		n++;
  8018ad:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8018b0:	ff 45 08             	incl   0x8(%ebp)
  8018b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b6:	8a 00                	mov    (%eax),%al
  8018b8:	84 c0                	test   %al,%al
  8018ba:	75 f1                	jne    8018ad <strlen+0xf>
		n++;
	return n;
  8018bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8018bf:	c9                   	leave  
  8018c0:	c3                   	ret    

008018c1 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8018c1:	55                   	push   %ebp
  8018c2:	89 e5                	mov    %esp,%ebp
  8018c4:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8018c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8018ce:	eb 09                	jmp    8018d9 <strnlen+0x18>
		n++;
  8018d0:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8018d3:	ff 45 08             	incl   0x8(%ebp)
  8018d6:	ff 4d 0c             	decl   0xc(%ebp)
  8018d9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8018dd:	74 09                	je     8018e8 <strnlen+0x27>
  8018df:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e2:	8a 00                	mov    (%eax),%al
  8018e4:	84 c0                	test   %al,%al
  8018e6:	75 e8                	jne    8018d0 <strnlen+0xf>
		n++;
	return n;
  8018e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8018eb:	c9                   	leave  
  8018ec:	c3                   	ret    

008018ed <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8018ed:	55                   	push   %ebp
  8018ee:	89 e5                	mov    %esp,%ebp
  8018f0:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8018f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8018f9:	90                   	nop
  8018fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fd:	8d 50 01             	lea    0x1(%eax),%edx
  801900:	89 55 08             	mov    %edx,0x8(%ebp)
  801903:	8b 55 0c             	mov    0xc(%ebp),%edx
  801906:	8d 4a 01             	lea    0x1(%edx),%ecx
  801909:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80190c:	8a 12                	mov    (%edx),%dl
  80190e:	88 10                	mov    %dl,(%eax)
  801910:	8a 00                	mov    (%eax),%al
  801912:	84 c0                	test   %al,%al
  801914:	75 e4                	jne    8018fa <strcpy+0xd>
		/* do nothing */;
	return ret;
  801916:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801919:	c9                   	leave  
  80191a:	c3                   	ret    

0080191b <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80191b:	55                   	push   %ebp
  80191c:	89 e5                	mov    %esp,%ebp
  80191e:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801921:	8b 45 08             	mov    0x8(%ebp),%eax
  801924:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801927:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80192e:	eb 1f                	jmp    80194f <strncpy+0x34>
		*dst++ = *src;
  801930:	8b 45 08             	mov    0x8(%ebp),%eax
  801933:	8d 50 01             	lea    0x1(%eax),%edx
  801936:	89 55 08             	mov    %edx,0x8(%ebp)
  801939:	8b 55 0c             	mov    0xc(%ebp),%edx
  80193c:	8a 12                	mov    (%edx),%dl
  80193e:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801940:	8b 45 0c             	mov    0xc(%ebp),%eax
  801943:	8a 00                	mov    (%eax),%al
  801945:	84 c0                	test   %al,%al
  801947:	74 03                	je     80194c <strncpy+0x31>
			src++;
  801949:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80194c:	ff 45 fc             	incl   -0x4(%ebp)
  80194f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801952:	3b 45 10             	cmp    0x10(%ebp),%eax
  801955:	72 d9                	jb     801930 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801957:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80195a:	c9                   	leave  
  80195b:	c3                   	ret    

0080195c <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80195c:	55                   	push   %ebp
  80195d:	89 e5                	mov    %esp,%ebp
  80195f:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801962:	8b 45 08             	mov    0x8(%ebp),%eax
  801965:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801968:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80196c:	74 30                	je     80199e <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80196e:	eb 16                	jmp    801986 <strlcpy+0x2a>
			*dst++ = *src++;
  801970:	8b 45 08             	mov    0x8(%ebp),%eax
  801973:	8d 50 01             	lea    0x1(%eax),%edx
  801976:	89 55 08             	mov    %edx,0x8(%ebp)
  801979:	8b 55 0c             	mov    0xc(%ebp),%edx
  80197c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80197f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801982:	8a 12                	mov    (%edx),%dl
  801984:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801986:	ff 4d 10             	decl   0x10(%ebp)
  801989:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80198d:	74 09                	je     801998 <strlcpy+0x3c>
  80198f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801992:	8a 00                	mov    (%eax),%al
  801994:	84 c0                	test   %al,%al
  801996:	75 d8                	jne    801970 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801998:	8b 45 08             	mov    0x8(%ebp),%eax
  80199b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80199e:	8b 55 08             	mov    0x8(%ebp),%edx
  8019a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019a4:	29 c2                	sub    %eax,%edx
  8019a6:	89 d0                	mov    %edx,%eax
}
  8019a8:	c9                   	leave  
  8019a9:	c3                   	ret    

008019aa <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8019aa:	55                   	push   %ebp
  8019ab:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8019ad:	eb 06                	jmp    8019b5 <strcmp+0xb>
		p++, q++;
  8019af:	ff 45 08             	incl   0x8(%ebp)
  8019b2:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8019b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b8:	8a 00                	mov    (%eax),%al
  8019ba:	84 c0                	test   %al,%al
  8019bc:	74 0e                	je     8019cc <strcmp+0x22>
  8019be:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c1:	8a 10                	mov    (%eax),%dl
  8019c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019c6:	8a 00                	mov    (%eax),%al
  8019c8:	38 c2                	cmp    %al,%dl
  8019ca:	74 e3                	je     8019af <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8019cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cf:	8a 00                	mov    (%eax),%al
  8019d1:	0f b6 d0             	movzbl %al,%edx
  8019d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019d7:	8a 00                	mov    (%eax),%al
  8019d9:	0f b6 c0             	movzbl %al,%eax
  8019dc:	29 c2                	sub    %eax,%edx
  8019de:	89 d0                	mov    %edx,%eax
}
  8019e0:	5d                   	pop    %ebp
  8019e1:	c3                   	ret    

008019e2 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8019e2:	55                   	push   %ebp
  8019e3:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8019e5:	eb 09                	jmp    8019f0 <strncmp+0xe>
		n--, p++, q++;
  8019e7:	ff 4d 10             	decl   0x10(%ebp)
  8019ea:	ff 45 08             	incl   0x8(%ebp)
  8019ed:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8019f0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019f4:	74 17                	je     801a0d <strncmp+0x2b>
  8019f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f9:	8a 00                	mov    (%eax),%al
  8019fb:	84 c0                	test   %al,%al
  8019fd:	74 0e                	je     801a0d <strncmp+0x2b>
  8019ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801a02:	8a 10                	mov    (%eax),%dl
  801a04:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a07:	8a 00                	mov    (%eax),%al
  801a09:	38 c2                	cmp    %al,%dl
  801a0b:	74 da                	je     8019e7 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801a0d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a11:	75 07                	jne    801a1a <strncmp+0x38>
		return 0;
  801a13:	b8 00 00 00 00       	mov    $0x0,%eax
  801a18:	eb 14                	jmp    801a2e <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1d:	8a 00                	mov    (%eax),%al
  801a1f:	0f b6 d0             	movzbl %al,%edx
  801a22:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a25:	8a 00                	mov    (%eax),%al
  801a27:	0f b6 c0             	movzbl %al,%eax
  801a2a:	29 c2                	sub    %eax,%edx
  801a2c:	89 d0                	mov    %edx,%eax
}
  801a2e:	5d                   	pop    %ebp
  801a2f:	c3                   	ret    

00801a30 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801a30:	55                   	push   %ebp
  801a31:	89 e5                	mov    %esp,%ebp
  801a33:	83 ec 04             	sub    $0x4,%esp
  801a36:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a39:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801a3c:	eb 12                	jmp    801a50 <strchr+0x20>
		if (*s == c)
  801a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a41:	8a 00                	mov    (%eax),%al
  801a43:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801a46:	75 05                	jne    801a4d <strchr+0x1d>
			return (char *) s;
  801a48:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4b:	eb 11                	jmp    801a5e <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801a4d:	ff 45 08             	incl   0x8(%ebp)
  801a50:	8b 45 08             	mov    0x8(%ebp),%eax
  801a53:	8a 00                	mov    (%eax),%al
  801a55:	84 c0                	test   %al,%al
  801a57:	75 e5                	jne    801a3e <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801a59:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a5e:	c9                   	leave  
  801a5f:	c3                   	ret    

00801a60 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801a60:	55                   	push   %ebp
  801a61:	89 e5                	mov    %esp,%ebp
  801a63:	83 ec 04             	sub    $0x4,%esp
  801a66:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a69:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801a6c:	eb 0d                	jmp    801a7b <strfind+0x1b>
		if (*s == c)
  801a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a71:	8a 00                	mov    (%eax),%al
  801a73:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801a76:	74 0e                	je     801a86 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801a78:	ff 45 08             	incl   0x8(%ebp)
  801a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7e:	8a 00                	mov    (%eax),%al
  801a80:	84 c0                	test   %al,%al
  801a82:	75 ea                	jne    801a6e <strfind+0xe>
  801a84:	eb 01                	jmp    801a87 <strfind+0x27>
		if (*s == c)
			break;
  801a86:	90                   	nop
	return (char *) s;
  801a87:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801a8a:	c9                   	leave  
  801a8b:	c3                   	ret    

00801a8c <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801a8c:	55                   	push   %ebp
  801a8d:	89 e5                	mov    %esp,%ebp
  801a8f:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801a92:	8b 45 08             	mov    0x8(%ebp),%eax
  801a95:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801a98:	8b 45 10             	mov    0x10(%ebp),%eax
  801a9b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801a9e:	eb 0e                	jmp    801aae <memset+0x22>
		*p++ = c;
  801aa0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801aa3:	8d 50 01             	lea    0x1(%eax),%edx
  801aa6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801aa9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aac:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801aae:	ff 4d f8             	decl   -0x8(%ebp)
  801ab1:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801ab5:	79 e9                	jns    801aa0 <memset+0x14>
		*p++ = c;

	return v;
  801ab7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801aba:	c9                   	leave  
  801abb:	c3                   	ret    

00801abc <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801abc:	55                   	push   %ebp
  801abd:	89 e5                	mov    %esp,%ebp
  801abf:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801ac2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ac5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  801acb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801ace:	eb 16                	jmp    801ae6 <memcpy+0x2a>
		*d++ = *s++;
  801ad0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ad3:	8d 50 01             	lea    0x1(%eax),%edx
  801ad6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801ad9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801adc:	8d 4a 01             	lea    0x1(%edx),%ecx
  801adf:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801ae2:	8a 12                	mov    (%edx),%dl
  801ae4:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801ae6:	8b 45 10             	mov    0x10(%ebp),%eax
  801ae9:	8d 50 ff             	lea    -0x1(%eax),%edx
  801aec:	89 55 10             	mov    %edx,0x10(%ebp)
  801aef:	85 c0                	test   %eax,%eax
  801af1:	75 dd                	jne    801ad0 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801af3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801af6:	c9                   	leave  
  801af7:	c3                   	ret    

00801af8 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801af8:	55                   	push   %ebp
  801af9:	89 e5                	mov    %esp,%ebp
  801afb:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801afe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b01:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801b04:	8b 45 08             	mov    0x8(%ebp),%eax
  801b07:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801b0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b0d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801b10:	73 50                	jae    801b62 <memmove+0x6a>
  801b12:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b15:	8b 45 10             	mov    0x10(%ebp),%eax
  801b18:	01 d0                	add    %edx,%eax
  801b1a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801b1d:	76 43                	jbe    801b62 <memmove+0x6a>
		s += n;
  801b1f:	8b 45 10             	mov    0x10(%ebp),%eax
  801b22:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801b25:	8b 45 10             	mov    0x10(%ebp),%eax
  801b28:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801b2b:	eb 10                	jmp    801b3d <memmove+0x45>
			*--d = *--s;
  801b2d:	ff 4d f8             	decl   -0x8(%ebp)
  801b30:	ff 4d fc             	decl   -0x4(%ebp)
  801b33:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b36:	8a 10                	mov    (%eax),%dl
  801b38:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b3b:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801b3d:	8b 45 10             	mov    0x10(%ebp),%eax
  801b40:	8d 50 ff             	lea    -0x1(%eax),%edx
  801b43:	89 55 10             	mov    %edx,0x10(%ebp)
  801b46:	85 c0                	test   %eax,%eax
  801b48:	75 e3                	jne    801b2d <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801b4a:	eb 23                	jmp    801b6f <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801b4c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b4f:	8d 50 01             	lea    0x1(%eax),%edx
  801b52:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801b55:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b58:	8d 4a 01             	lea    0x1(%edx),%ecx
  801b5b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801b5e:	8a 12                	mov    (%edx),%dl
  801b60:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801b62:	8b 45 10             	mov    0x10(%ebp),%eax
  801b65:	8d 50 ff             	lea    -0x1(%eax),%edx
  801b68:	89 55 10             	mov    %edx,0x10(%ebp)
  801b6b:	85 c0                	test   %eax,%eax
  801b6d:	75 dd                	jne    801b4c <memmove+0x54>
			*d++ = *s++;

	return dst;
  801b6f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801b72:	c9                   	leave  
  801b73:	c3                   	ret    

00801b74 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801b74:	55                   	push   %ebp
  801b75:	89 e5                	mov    %esp,%ebp
  801b77:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801b80:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b83:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801b86:	eb 2a                	jmp    801bb2 <memcmp+0x3e>
		if (*s1 != *s2)
  801b88:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b8b:	8a 10                	mov    (%eax),%dl
  801b8d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b90:	8a 00                	mov    (%eax),%al
  801b92:	38 c2                	cmp    %al,%dl
  801b94:	74 16                	je     801bac <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801b96:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b99:	8a 00                	mov    (%eax),%al
  801b9b:	0f b6 d0             	movzbl %al,%edx
  801b9e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ba1:	8a 00                	mov    (%eax),%al
  801ba3:	0f b6 c0             	movzbl %al,%eax
  801ba6:	29 c2                	sub    %eax,%edx
  801ba8:	89 d0                	mov    %edx,%eax
  801baa:	eb 18                	jmp    801bc4 <memcmp+0x50>
		s1++, s2++;
  801bac:	ff 45 fc             	incl   -0x4(%ebp)
  801baf:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801bb2:	8b 45 10             	mov    0x10(%ebp),%eax
  801bb5:	8d 50 ff             	lea    -0x1(%eax),%edx
  801bb8:	89 55 10             	mov    %edx,0x10(%ebp)
  801bbb:	85 c0                	test   %eax,%eax
  801bbd:	75 c9                	jne    801b88 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801bbf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bc4:	c9                   	leave  
  801bc5:	c3                   	ret    

00801bc6 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801bc6:	55                   	push   %ebp
  801bc7:	89 e5                	mov    %esp,%ebp
  801bc9:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801bcc:	8b 55 08             	mov    0x8(%ebp),%edx
  801bcf:	8b 45 10             	mov    0x10(%ebp),%eax
  801bd2:	01 d0                	add    %edx,%eax
  801bd4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801bd7:	eb 15                	jmp    801bee <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdc:	8a 00                	mov    (%eax),%al
  801bde:	0f b6 d0             	movzbl %al,%edx
  801be1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801be4:	0f b6 c0             	movzbl %al,%eax
  801be7:	39 c2                	cmp    %eax,%edx
  801be9:	74 0d                	je     801bf8 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801beb:	ff 45 08             	incl   0x8(%ebp)
  801bee:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801bf4:	72 e3                	jb     801bd9 <memfind+0x13>
  801bf6:	eb 01                	jmp    801bf9 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801bf8:	90                   	nop
	return (void *) s;
  801bf9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801bfc:	c9                   	leave  
  801bfd:	c3                   	ret    

00801bfe <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801bfe:	55                   	push   %ebp
  801bff:	89 e5                	mov    %esp,%ebp
  801c01:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801c04:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801c0b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801c12:	eb 03                	jmp    801c17 <strtol+0x19>
		s++;
  801c14:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801c17:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1a:	8a 00                	mov    (%eax),%al
  801c1c:	3c 20                	cmp    $0x20,%al
  801c1e:	74 f4                	je     801c14 <strtol+0x16>
  801c20:	8b 45 08             	mov    0x8(%ebp),%eax
  801c23:	8a 00                	mov    (%eax),%al
  801c25:	3c 09                	cmp    $0x9,%al
  801c27:	74 eb                	je     801c14 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801c29:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2c:	8a 00                	mov    (%eax),%al
  801c2e:	3c 2b                	cmp    $0x2b,%al
  801c30:	75 05                	jne    801c37 <strtol+0x39>
		s++;
  801c32:	ff 45 08             	incl   0x8(%ebp)
  801c35:	eb 13                	jmp    801c4a <strtol+0x4c>
	else if (*s == '-')
  801c37:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3a:	8a 00                	mov    (%eax),%al
  801c3c:	3c 2d                	cmp    $0x2d,%al
  801c3e:	75 0a                	jne    801c4a <strtol+0x4c>
		s++, neg = 1;
  801c40:	ff 45 08             	incl   0x8(%ebp)
  801c43:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801c4a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c4e:	74 06                	je     801c56 <strtol+0x58>
  801c50:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801c54:	75 20                	jne    801c76 <strtol+0x78>
  801c56:	8b 45 08             	mov    0x8(%ebp),%eax
  801c59:	8a 00                	mov    (%eax),%al
  801c5b:	3c 30                	cmp    $0x30,%al
  801c5d:	75 17                	jne    801c76 <strtol+0x78>
  801c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c62:	40                   	inc    %eax
  801c63:	8a 00                	mov    (%eax),%al
  801c65:	3c 78                	cmp    $0x78,%al
  801c67:	75 0d                	jne    801c76 <strtol+0x78>
		s += 2, base = 16;
  801c69:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801c6d:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801c74:	eb 28                	jmp    801c9e <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801c76:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c7a:	75 15                	jne    801c91 <strtol+0x93>
  801c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7f:	8a 00                	mov    (%eax),%al
  801c81:	3c 30                	cmp    $0x30,%al
  801c83:	75 0c                	jne    801c91 <strtol+0x93>
		s++, base = 8;
  801c85:	ff 45 08             	incl   0x8(%ebp)
  801c88:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801c8f:	eb 0d                	jmp    801c9e <strtol+0xa0>
	else if (base == 0)
  801c91:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c95:	75 07                	jne    801c9e <strtol+0xa0>
		base = 10;
  801c97:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca1:	8a 00                	mov    (%eax),%al
  801ca3:	3c 2f                	cmp    $0x2f,%al
  801ca5:	7e 19                	jle    801cc0 <strtol+0xc2>
  801ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  801caa:	8a 00                	mov    (%eax),%al
  801cac:	3c 39                	cmp    $0x39,%al
  801cae:	7f 10                	jg     801cc0 <strtol+0xc2>
			dig = *s - '0';
  801cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb3:	8a 00                	mov    (%eax),%al
  801cb5:	0f be c0             	movsbl %al,%eax
  801cb8:	83 e8 30             	sub    $0x30,%eax
  801cbb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801cbe:	eb 42                	jmp    801d02 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc3:	8a 00                	mov    (%eax),%al
  801cc5:	3c 60                	cmp    $0x60,%al
  801cc7:	7e 19                	jle    801ce2 <strtol+0xe4>
  801cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccc:	8a 00                	mov    (%eax),%al
  801cce:	3c 7a                	cmp    $0x7a,%al
  801cd0:	7f 10                	jg     801ce2 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd5:	8a 00                	mov    (%eax),%al
  801cd7:	0f be c0             	movsbl %al,%eax
  801cda:	83 e8 57             	sub    $0x57,%eax
  801cdd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ce0:	eb 20                	jmp    801d02 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce5:	8a 00                	mov    (%eax),%al
  801ce7:	3c 40                	cmp    $0x40,%al
  801ce9:	7e 39                	jle    801d24 <strtol+0x126>
  801ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cee:	8a 00                	mov    (%eax),%al
  801cf0:	3c 5a                	cmp    $0x5a,%al
  801cf2:	7f 30                	jg     801d24 <strtol+0x126>
			dig = *s - 'A' + 10;
  801cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf7:	8a 00                	mov    (%eax),%al
  801cf9:	0f be c0             	movsbl %al,%eax
  801cfc:	83 e8 37             	sub    $0x37,%eax
  801cff:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801d02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d05:	3b 45 10             	cmp    0x10(%ebp),%eax
  801d08:	7d 19                	jge    801d23 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801d0a:	ff 45 08             	incl   0x8(%ebp)
  801d0d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d10:	0f af 45 10          	imul   0x10(%ebp),%eax
  801d14:	89 c2                	mov    %eax,%edx
  801d16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d19:	01 d0                	add    %edx,%eax
  801d1b:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801d1e:	e9 7b ff ff ff       	jmp    801c9e <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801d23:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801d24:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d28:	74 08                	je     801d32 <strtol+0x134>
		*endptr = (char *) s;
  801d2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d2d:	8b 55 08             	mov    0x8(%ebp),%edx
  801d30:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801d32:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801d36:	74 07                	je     801d3f <strtol+0x141>
  801d38:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d3b:	f7 d8                	neg    %eax
  801d3d:	eb 03                	jmp    801d42 <strtol+0x144>
  801d3f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801d42:	c9                   	leave  
  801d43:	c3                   	ret    

00801d44 <ltostr>:

void
ltostr(long value, char *str)
{
  801d44:	55                   	push   %ebp
  801d45:	89 e5                	mov    %esp,%ebp
  801d47:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801d4a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801d51:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801d58:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d5c:	79 13                	jns    801d71 <ltostr+0x2d>
	{
		neg = 1;
  801d5e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801d65:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d68:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801d6b:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801d6e:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801d71:	8b 45 08             	mov    0x8(%ebp),%eax
  801d74:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801d79:	99                   	cltd   
  801d7a:	f7 f9                	idiv   %ecx
  801d7c:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801d7f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d82:	8d 50 01             	lea    0x1(%eax),%edx
  801d85:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801d88:	89 c2                	mov    %eax,%edx
  801d8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d8d:	01 d0                	add    %edx,%eax
  801d8f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801d92:	83 c2 30             	add    $0x30,%edx
  801d95:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801d97:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d9a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801d9f:	f7 e9                	imul   %ecx
  801da1:	c1 fa 02             	sar    $0x2,%edx
  801da4:	89 c8                	mov    %ecx,%eax
  801da6:	c1 f8 1f             	sar    $0x1f,%eax
  801da9:	29 c2                	sub    %eax,%edx
  801dab:	89 d0                	mov    %edx,%eax
  801dad:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801db0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801db3:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801db8:	f7 e9                	imul   %ecx
  801dba:	c1 fa 02             	sar    $0x2,%edx
  801dbd:	89 c8                	mov    %ecx,%eax
  801dbf:	c1 f8 1f             	sar    $0x1f,%eax
  801dc2:	29 c2                	sub    %eax,%edx
  801dc4:	89 d0                	mov    %edx,%eax
  801dc6:	c1 e0 02             	shl    $0x2,%eax
  801dc9:	01 d0                	add    %edx,%eax
  801dcb:	01 c0                	add    %eax,%eax
  801dcd:	29 c1                	sub    %eax,%ecx
  801dcf:	89 ca                	mov    %ecx,%edx
  801dd1:	85 d2                	test   %edx,%edx
  801dd3:	75 9c                	jne    801d71 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801dd5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801ddc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ddf:	48                   	dec    %eax
  801de0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801de3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801de7:	74 3d                	je     801e26 <ltostr+0xe2>
		start = 1 ;
  801de9:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801df0:	eb 34                	jmp    801e26 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801df2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801df5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801df8:	01 d0                	add    %edx,%eax
  801dfa:	8a 00                	mov    (%eax),%al
  801dfc:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801dff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e02:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e05:	01 c2                	add    %eax,%edx
  801e07:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801e0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e0d:	01 c8                	add    %ecx,%eax
  801e0f:	8a 00                	mov    (%eax),%al
  801e11:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801e13:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e16:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e19:	01 c2                	add    %eax,%edx
  801e1b:	8a 45 eb             	mov    -0x15(%ebp),%al
  801e1e:	88 02                	mov    %al,(%edx)
		start++ ;
  801e20:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801e23:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801e26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e29:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801e2c:	7c c4                	jl     801df2 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801e2e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801e31:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e34:	01 d0                	add    %edx,%eax
  801e36:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801e39:	90                   	nop
  801e3a:	c9                   	leave  
  801e3b:	c3                   	ret    

00801e3c <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801e3c:	55                   	push   %ebp
  801e3d:	89 e5                	mov    %esp,%ebp
  801e3f:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801e42:	ff 75 08             	pushl  0x8(%ebp)
  801e45:	e8 54 fa ff ff       	call   80189e <strlen>
  801e4a:	83 c4 04             	add    $0x4,%esp
  801e4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801e50:	ff 75 0c             	pushl  0xc(%ebp)
  801e53:	e8 46 fa ff ff       	call   80189e <strlen>
  801e58:	83 c4 04             	add    $0x4,%esp
  801e5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801e5e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801e65:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801e6c:	eb 17                	jmp    801e85 <strcconcat+0x49>
		final[s] = str1[s] ;
  801e6e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e71:	8b 45 10             	mov    0x10(%ebp),%eax
  801e74:	01 c2                	add    %eax,%edx
  801e76:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801e79:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7c:	01 c8                	add    %ecx,%eax
  801e7e:	8a 00                	mov    (%eax),%al
  801e80:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801e82:	ff 45 fc             	incl   -0x4(%ebp)
  801e85:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e88:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801e8b:	7c e1                	jl     801e6e <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801e8d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801e94:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801e9b:	eb 1f                	jmp    801ebc <strcconcat+0x80>
		final[s++] = str2[i] ;
  801e9d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ea0:	8d 50 01             	lea    0x1(%eax),%edx
  801ea3:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801ea6:	89 c2                	mov    %eax,%edx
  801ea8:	8b 45 10             	mov    0x10(%ebp),%eax
  801eab:	01 c2                	add    %eax,%edx
  801ead:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801eb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eb3:	01 c8                	add    %ecx,%eax
  801eb5:	8a 00                	mov    (%eax),%al
  801eb7:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801eb9:	ff 45 f8             	incl   -0x8(%ebp)
  801ebc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ebf:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801ec2:	7c d9                	jl     801e9d <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801ec4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ec7:	8b 45 10             	mov    0x10(%ebp),%eax
  801eca:	01 d0                	add    %edx,%eax
  801ecc:	c6 00 00             	movb   $0x0,(%eax)
}
  801ecf:	90                   	nop
  801ed0:	c9                   	leave  
  801ed1:	c3                   	ret    

00801ed2 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801ed2:	55                   	push   %ebp
  801ed3:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801ed5:	8b 45 14             	mov    0x14(%ebp),%eax
  801ed8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801ede:	8b 45 14             	mov    0x14(%ebp),%eax
  801ee1:	8b 00                	mov    (%eax),%eax
  801ee3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801eea:	8b 45 10             	mov    0x10(%ebp),%eax
  801eed:	01 d0                	add    %edx,%eax
  801eef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801ef5:	eb 0c                	jmp    801f03 <strsplit+0x31>
			*string++ = 0;
  801ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  801efa:	8d 50 01             	lea    0x1(%eax),%edx
  801efd:	89 55 08             	mov    %edx,0x8(%ebp)
  801f00:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801f03:	8b 45 08             	mov    0x8(%ebp),%eax
  801f06:	8a 00                	mov    (%eax),%al
  801f08:	84 c0                	test   %al,%al
  801f0a:	74 18                	je     801f24 <strsplit+0x52>
  801f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0f:	8a 00                	mov    (%eax),%al
  801f11:	0f be c0             	movsbl %al,%eax
  801f14:	50                   	push   %eax
  801f15:	ff 75 0c             	pushl  0xc(%ebp)
  801f18:	e8 13 fb ff ff       	call   801a30 <strchr>
  801f1d:	83 c4 08             	add    $0x8,%esp
  801f20:	85 c0                	test   %eax,%eax
  801f22:	75 d3                	jne    801ef7 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801f24:	8b 45 08             	mov    0x8(%ebp),%eax
  801f27:	8a 00                	mov    (%eax),%al
  801f29:	84 c0                	test   %al,%al
  801f2b:	74 5a                	je     801f87 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801f2d:	8b 45 14             	mov    0x14(%ebp),%eax
  801f30:	8b 00                	mov    (%eax),%eax
  801f32:	83 f8 0f             	cmp    $0xf,%eax
  801f35:	75 07                	jne    801f3e <strsplit+0x6c>
		{
			return 0;
  801f37:	b8 00 00 00 00       	mov    $0x0,%eax
  801f3c:	eb 66                	jmp    801fa4 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801f3e:	8b 45 14             	mov    0x14(%ebp),%eax
  801f41:	8b 00                	mov    (%eax),%eax
  801f43:	8d 48 01             	lea    0x1(%eax),%ecx
  801f46:	8b 55 14             	mov    0x14(%ebp),%edx
  801f49:	89 0a                	mov    %ecx,(%edx)
  801f4b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801f52:	8b 45 10             	mov    0x10(%ebp),%eax
  801f55:	01 c2                	add    %eax,%edx
  801f57:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5a:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801f5c:	eb 03                	jmp    801f61 <strsplit+0x8f>
			string++;
  801f5e:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801f61:	8b 45 08             	mov    0x8(%ebp),%eax
  801f64:	8a 00                	mov    (%eax),%al
  801f66:	84 c0                	test   %al,%al
  801f68:	74 8b                	je     801ef5 <strsplit+0x23>
  801f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6d:	8a 00                	mov    (%eax),%al
  801f6f:	0f be c0             	movsbl %al,%eax
  801f72:	50                   	push   %eax
  801f73:	ff 75 0c             	pushl  0xc(%ebp)
  801f76:	e8 b5 fa ff ff       	call   801a30 <strchr>
  801f7b:	83 c4 08             	add    $0x8,%esp
  801f7e:	85 c0                	test   %eax,%eax
  801f80:	74 dc                	je     801f5e <strsplit+0x8c>
			string++;
	}
  801f82:	e9 6e ff ff ff       	jmp    801ef5 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801f87:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801f88:	8b 45 14             	mov    0x14(%ebp),%eax
  801f8b:	8b 00                	mov    (%eax),%eax
  801f8d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801f94:	8b 45 10             	mov    0x10(%ebp),%eax
  801f97:	01 d0                	add    %edx,%eax
  801f99:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801f9f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801fa4:	c9                   	leave  
  801fa5:	c3                   	ret    

00801fa6 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801fa6:	55                   	push   %ebp
  801fa7:	89 e5                	mov    %esp,%ebp
  801fa9:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801fac:	a1 04 50 80 00       	mov    0x805004,%eax
  801fb1:	85 c0                	test   %eax,%eax
  801fb3:	74 1f                	je     801fd4 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801fb5:	e8 1d 00 00 00       	call   801fd7 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801fba:	83 ec 0c             	sub    $0xc,%esp
  801fbd:	68 d0 45 80 00       	push   $0x8045d0
  801fc2:	e8 55 f2 ff ff       	call   80121c <cprintf>
  801fc7:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801fca:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801fd1:	00 00 00 
	}
}
  801fd4:	90                   	nop
  801fd5:	c9                   	leave  
  801fd6:	c3                   	ret    

00801fd7 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801fd7:	55                   	push   %ebp
  801fd8:	89 e5                	mov    %esp,%ebp
  801fda:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  801fdd:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801fe4:	00 00 00 
  801fe7:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801fee:	00 00 00 
  801ff1:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801ff8:	00 00 00 
		LIST_INIT(&AllocMemBlocksList);
  801ffb:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  802002:	00 00 00 
  802005:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  80200c:	00 00 00 
  80200f:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  802016:	00 00 00 

		MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES ;
  802019:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  802020:	00 02 00 
		MemBlockNodes =(struct MemBlock*)USER_DYN_BLKS_ARRAY ;
  802023:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  80202a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802032:	2d 00 10 00 00       	sub    $0x1000,%eax
  802037:	a3 50 50 80 00       	mov    %eax,0x805050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock),PAGE_SIZE),PERM_USER|PERM_WRITEABLE);
  80203c:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802043:	a1 20 51 80 00       	mov    0x805120,%eax
  802048:	c1 e0 04             	shl    $0x4,%eax
  80204b:	89 c2                	mov    %eax,%edx
  80204d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802050:	01 d0                	add    %edx,%eax
  802052:	48                   	dec    %eax
  802053:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802056:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802059:	ba 00 00 00 00       	mov    $0x0,%edx
  80205e:	f7 75 f0             	divl   -0x10(%ebp)
  802061:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802064:	29 d0                	sub    %edx,%eax
  802066:	89 c2                	mov    %eax,%edx
  802068:	c7 45 e8 00 00 e0 7f 	movl   $0x7fe00000,-0x18(%ebp)
  80206f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802072:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802077:	2d 00 10 00 00       	sub    $0x1000,%eax
  80207c:	83 ec 04             	sub    $0x4,%esp
  80207f:	6a 06                	push   $0x6
  802081:	52                   	push   %edx
  802082:	50                   	push   %eax
  802083:	e8 71 05 00 00       	call   8025f9 <sys_allocate_chunk>
  802088:	83 c4 10             	add    $0x10,%esp
		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80208b:	a1 20 51 80 00       	mov    0x805120,%eax
  802090:	83 ec 0c             	sub    $0xc,%esp
  802093:	50                   	push   %eax
  802094:	e8 e6 0b 00 00       	call   802c7f <initialize_MemBlocksList>
  802099:	83 c4 10             	add    $0x10,%esp

		struct MemBlock  *block_node;
		block_node = AvailableMemBlocksList.lh_first;
  80209c:	a1 48 51 80 00       	mov    0x805148,%eax
  8020a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&(AvailableMemBlocksList),block_node);
  8020a4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8020a8:	75 14                	jne    8020be <initialize_dyn_block_system+0xe7>
  8020aa:	83 ec 04             	sub    $0x4,%esp
  8020ad:	68 f5 45 80 00       	push   $0x8045f5
  8020b2:	6a 2b                	push   $0x2b
  8020b4:	68 13 46 80 00       	push   $0x804613
  8020b9:	e8 aa ee ff ff       	call   800f68 <_panic>
  8020be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020c1:	8b 00                	mov    (%eax),%eax
  8020c3:	85 c0                	test   %eax,%eax
  8020c5:	74 10                	je     8020d7 <initialize_dyn_block_system+0x100>
  8020c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020ca:	8b 00                	mov    (%eax),%eax
  8020cc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8020cf:	8b 52 04             	mov    0x4(%edx),%edx
  8020d2:	89 50 04             	mov    %edx,0x4(%eax)
  8020d5:	eb 0b                	jmp    8020e2 <initialize_dyn_block_system+0x10b>
  8020d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020da:	8b 40 04             	mov    0x4(%eax),%eax
  8020dd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8020e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020e5:	8b 40 04             	mov    0x4(%eax),%eax
  8020e8:	85 c0                	test   %eax,%eax
  8020ea:	74 0f                	je     8020fb <initialize_dyn_block_system+0x124>
  8020ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020ef:	8b 40 04             	mov    0x4(%eax),%eax
  8020f2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8020f5:	8b 12                	mov    (%edx),%edx
  8020f7:	89 10                	mov    %edx,(%eax)
  8020f9:	eb 0a                	jmp    802105 <initialize_dyn_block_system+0x12e>
  8020fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020fe:	8b 00                	mov    (%eax),%eax
  802100:	a3 48 51 80 00       	mov    %eax,0x805148
  802105:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802108:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80210e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802111:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802118:	a1 54 51 80 00       	mov    0x805154,%eax
  80211d:	48                   	dec    %eax
  80211e:	a3 54 51 80 00       	mov    %eax,0x805154
		block_node->sva = USER_HEAP_START ;
  802123:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802126:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
		block_node->size = ((USER_HEAP_MAX - USER_HEAP_START));
  80212d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802130:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		insert_sorted_with_merge_freeList(block_node);
  802137:	83 ec 0c             	sub    $0xc,%esp
  80213a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80213d:	e8 d2 13 00 00       	call   803514 <insert_sorted_with_merge_freeList>
  802142:	83 c4 10             	add    $0x10,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  802145:	90                   	nop
  802146:	c9                   	leave  
  802147:	c3                   	ret    

00802148 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  802148:	55                   	push   %ebp
  802149:	89 e5                	mov    %esp,%ebp
  80214b:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80214e:	e8 53 fe ff ff       	call   801fa6 <InitializeUHeap>
	if (size == 0) return NULL ;
  802153:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802157:	75 07                	jne    802160 <malloc+0x18>
  802159:	b8 00 00 00 00       	mov    $0x0,%eax
  80215e:	eb 61                	jmp    8021c1 <malloc+0x79>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	size= ROUNDUP(size,PAGE_SIZE);
  802160:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  802167:	8b 55 08             	mov    0x8(%ebp),%edx
  80216a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216d:	01 d0                	add    %edx,%eax
  80216f:	48                   	dec    %eax
  802170:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802173:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802176:	ba 00 00 00 00       	mov    $0x0,%edx
  80217b:	f7 75 f4             	divl   -0xc(%ebp)
  80217e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802181:	29 d0                	sub    %edx,%eax
  802183:	89 45 08             	mov    %eax,0x8(%ebp)
	    			if(sys_isUHeapPlacementStrategyFIRSTFIT())
  802186:	e8 3c 08 00 00       	call   8029c7 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80218b:	85 c0                	test   %eax,%eax
  80218d:	74 2d                	je     8021bc <malloc+0x74>
	    			{
	    				struct MemBlock * ff_block = alloc_block_FF(size);
  80218f:	83 ec 0c             	sub    $0xc,%esp
  802192:	ff 75 08             	pushl  0x8(%ebp)
  802195:	e8 3e 0f 00 00       	call   8030d8 <alloc_block_FF>
  80219a:	83 c4 10             	add    $0x10,%esp
  80219d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    				if(ff_block!=NULL)
  8021a0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8021a4:	74 16                	je     8021bc <malloc+0x74>
	    				{

	    					insert_sorted_allocList(ff_block);
  8021a6:	83 ec 0c             	sub    $0xc,%esp
  8021a9:	ff 75 ec             	pushl  -0x14(%ebp)
  8021ac:	e8 48 0c 00 00       	call   802df9 <insert_sorted_allocList>
  8021b1:	83 c4 10             	add    $0x10,%esp
	    					return (void*) ff_block->sva ;
  8021b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021b7:	8b 40 08             	mov    0x8(%eax),%eax
  8021ba:	eb 05                	jmp    8021c1 <malloc+0x79>

	    				}
	}
	    			return (void*) NULL ;
  8021bc:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  8021c1:	c9                   	leave  
  8021c2:	c3                   	ret    

008021c3 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8021c3:	55                   	push   %ebp
  8021c4:	89 e5                	mov    %esp,%ebp
  8021c6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock *elementForEach;
		virtual_address = ROUNDDOWN(virtual_address, PAGE_SIZE);
  8021c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8021d7:	89 45 08             	mov    %eax,0x8(%ebp)
	//	if (is_mallocPages[indexindex((uint32) virtual_address)] == 1) {
		elementForEach = find_block(&AllocMemBlocksList,(uint32)virtual_address);
  8021da:	8b 45 08             	mov    0x8(%ebp),%eax
  8021dd:	83 ec 08             	sub    $0x8,%esp
  8021e0:	50                   	push   %eax
  8021e1:	68 40 50 80 00       	push   $0x805040
  8021e6:	e8 71 0b 00 00       	call   802d5c <find_block>
  8021eb:	83 c4 10             	add    $0x10,%esp
  8021ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
		sys_free_user_mem((uint32) virtual_address, elementForEach->size);
  8021f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021f4:	8b 50 0c             	mov    0xc(%eax),%edx
  8021f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fa:	83 ec 08             	sub    $0x8,%esp
  8021fd:	52                   	push   %edx
  8021fe:	50                   	push   %eax
  8021ff:	e8 bd 03 00 00       	call   8025c1 <sys_free_user_mem>
  802204:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,elementForEach);
  802207:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80220b:	75 14                	jne    802221 <free+0x5e>
  80220d:	83 ec 04             	sub    $0x4,%esp
  802210:	68 f5 45 80 00       	push   $0x8045f5
  802215:	6a 71                	push   $0x71
  802217:	68 13 46 80 00       	push   $0x804613
  80221c:	e8 47 ed ff ff       	call   800f68 <_panic>
  802221:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802224:	8b 00                	mov    (%eax),%eax
  802226:	85 c0                	test   %eax,%eax
  802228:	74 10                	je     80223a <free+0x77>
  80222a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80222d:	8b 00                	mov    (%eax),%eax
  80222f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802232:	8b 52 04             	mov    0x4(%edx),%edx
  802235:	89 50 04             	mov    %edx,0x4(%eax)
  802238:	eb 0b                	jmp    802245 <free+0x82>
  80223a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80223d:	8b 40 04             	mov    0x4(%eax),%eax
  802240:	a3 44 50 80 00       	mov    %eax,0x805044
  802245:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802248:	8b 40 04             	mov    0x4(%eax),%eax
  80224b:	85 c0                	test   %eax,%eax
  80224d:	74 0f                	je     80225e <free+0x9b>
  80224f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802252:	8b 40 04             	mov    0x4(%eax),%eax
  802255:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802258:	8b 12                	mov    (%edx),%edx
  80225a:	89 10                	mov    %edx,(%eax)
  80225c:	eb 0a                	jmp    802268 <free+0xa5>
  80225e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802261:	8b 00                	mov    (%eax),%eax
  802263:	a3 40 50 80 00       	mov    %eax,0x805040
  802268:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80226b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802271:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802274:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80227b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802280:	48                   	dec    %eax
  802281:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(elementForEach);
  802286:	83 ec 0c             	sub    $0xc,%esp
  802289:	ff 75 f0             	pushl  -0x10(%ebp)
  80228c:	e8 83 12 00 00       	call   803514 <insert_sorted_with_merge_freeList>
  802291:	83 c4 10             	add    $0x10,%esp
	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  802294:	90                   	nop
  802295:	c9                   	leave  
  802296:	c3                   	ret    

00802297 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802297:	55                   	push   %ebp
  802298:	89 e5                	mov    %esp,%ebp
  80229a:	83 ec 28             	sub    $0x28,%esp
  80229d:	8b 45 10             	mov    0x10(%ebp),%eax
  8022a0:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8022a3:	e8 fe fc ff ff       	call   801fa6 <InitializeUHeap>
	if (size == 0) return NULL ;
  8022a8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8022ac:	75 0a                	jne    8022b8 <smalloc+0x21>
  8022ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8022b3:	e9 86 00 00 00       	jmp    80233e <smalloc+0xa7>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code

	size=ROUNDUP(size,PAGE_SIZE);
  8022b8:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8022bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c5:	01 d0                	add    %edx,%eax
  8022c7:	48                   	dec    %eax
  8022c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8022cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8022d3:	f7 75 f4             	divl   -0xc(%ebp)
  8022d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022d9:	29 d0                	sub    %edx,%eax
  8022db:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8022de:	e8 e4 06 00 00       	call   8029c7 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8022e3:	85 c0                	test   %eax,%eax
  8022e5:	74 52                	je     802339 <smalloc+0xa2>
		{
		struct MemBlock * ff_block ;
		ff_block = alloc_block_FF(size);
  8022e7:	83 ec 0c             	sub    $0xc,%esp
  8022ea:	ff 75 0c             	pushl  0xc(%ebp)
  8022ed:	e8 e6 0d 00 00       	call   8030d8 <alloc_block_FF>
  8022f2:	83 c4 10             	add    $0x10,%esp
  8022f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(ff_block==NULL)
  8022f8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8022fc:	75 07                	jne    802305 <smalloc+0x6e>
			return NULL ;
  8022fe:	b8 00 00 00 00       	mov    $0x0,%eax
  802303:	eb 39                	jmp    80233e <smalloc+0xa7>

		int obj_id =sys_createSharedObject(sharedVarName,size,isWritable,(void*)ff_block->sva);
  802305:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802308:	8b 40 08             	mov    0x8(%eax),%eax
  80230b:	89 c2                	mov    %eax,%edx
  80230d:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  802311:	52                   	push   %edx
  802312:	50                   	push   %eax
  802313:	ff 75 0c             	pushl  0xc(%ebp)
  802316:	ff 75 08             	pushl  0x8(%ebp)
  802319:	e8 2e 04 00 00       	call   80274c <sys_createSharedObject>
  80231e:	83 c4 10             	add    $0x10,%esp
  802321:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(obj_id < 0)
  802324:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802328:	79 07                	jns    802331 <smalloc+0x9a>
			return (void*)NULL ;
  80232a:	b8 00 00 00 00       	mov    $0x0,%eax
  80232f:	eb 0d                	jmp    80233e <smalloc+0xa7>
		else
		    return (void*)ff_block->sva ;
  802331:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802334:	8b 40 08             	mov    0x8(%eax),%eax
  802337:	eb 05                	jmp    80233e <smalloc+0xa7>
		}
		return (void*)NULL ;
  802339:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80233e:	c9                   	leave  
  80233f:	c3                   	ret    

00802340 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802340:	55                   	push   %ebp
  802341:	89 e5                	mov    %esp,%ebp
  802343:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802346:	e8 5b fc ff ff       	call   801fa6 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80234b:	83 ec 08             	sub    $0x8,%esp
  80234e:	ff 75 0c             	pushl  0xc(%ebp)
  802351:	ff 75 08             	pushl  0x8(%ebp)
  802354:	e8 1d 04 00 00       	call   802776 <sys_getSizeOfSharedObject>
  802359:	83 c4 10             	add    $0x10,%esp
  80235c:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(size == 0)
  80235f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802363:	75 0a                	jne    80236f <sget+0x2f>
			return NULL ;
  802365:	b8 00 00 00 00       	mov    $0x0,%eax
  80236a:	e9 83 00 00 00       	jmp    8023f2 <sget+0xb2>
		size=ROUNDUP(size,PAGE_SIZE);
  80236f:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802376:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802379:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80237c:	01 d0                	add    %edx,%eax
  80237e:	48                   	dec    %eax
  80237f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802382:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802385:	ba 00 00 00 00       	mov    $0x0,%edx
  80238a:	f7 75 f0             	divl   -0x10(%ebp)
  80238d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802390:	29 d0                	sub    %edx,%eax
  802392:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  802395:	e8 2d 06 00 00       	call   8029c7 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80239a:	85 c0                	test   %eax,%eax
  80239c:	74 4f                	je     8023ed <sget+0xad>
		{
			struct MemBlock * ff_block ;
				ff_block = alloc_block_FF(size);
  80239e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a1:	83 ec 0c             	sub    $0xc,%esp
  8023a4:	50                   	push   %eax
  8023a5:	e8 2e 0d 00 00       	call   8030d8 <alloc_block_FF>
  8023aa:	83 c4 10             	add    $0x10,%esp
  8023ad:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ff_block==NULL)
  8023b0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8023b4:	75 07                	jne    8023bd <sget+0x7d>
					return (void*)NULL ;
  8023b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8023bb:	eb 35                	jmp    8023f2 <sget+0xb2>

		int obj_id =sys_getSharedObject((int)ownerEnvID,sharedVarName,(void*)ff_block->sva);
  8023bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023c0:	8b 40 08             	mov    0x8(%eax),%eax
  8023c3:	83 ec 04             	sub    $0x4,%esp
  8023c6:	50                   	push   %eax
  8023c7:	ff 75 0c             	pushl  0xc(%ebp)
  8023ca:	ff 75 08             	pushl  0x8(%ebp)
  8023cd:	e8 c1 03 00 00       	call   802793 <sys_getSharedObject>
  8023d2:	83 c4 10             	add    $0x10,%esp
  8023d5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if(obj_id<0)
  8023d8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8023dc:	79 07                	jns    8023e5 <sget+0xa5>
				return (void*)NULL ;
  8023de:	b8 00 00 00 00       	mov    $0x0,%eax
  8023e3:	eb 0d                	jmp    8023f2 <sget+0xb2>
			else
				return (void*)ff_block->sva ;
  8023e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023e8:	8b 40 08             	mov    0x8(%eax),%eax
  8023eb:	eb 05                	jmp    8023f2 <sget+0xb2>


		}
	return (void*)NULL ;
  8023ed:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8023f2:	c9                   	leave  
  8023f3:	c3                   	ret    

008023f4 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8023f4:	55                   	push   %ebp
  8023f5:	89 e5                	mov    %esp,%ebp
  8023f7:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8023fa:	e8 a7 fb ff ff       	call   801fa6 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8023ff:	83 ec 04             	sub    $0x4,%esp
  802402:	68 20 46 80 00       	push   $0x804620
  802407:	68 f9 00 00 00       	push   $0xf9
  80240c:	68 13 46 80 00       	push   $0x804613
  802411:	e8 52 eb ff ff       	call   800f68 <_panic>

00802416 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802416:	55                   	push   %ebp
  802417:	89 e5                	mov    %esp,%ebp
  802419:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80241c:	83 ec 04             	sub    $0x4,%esp
  80241f:	68 48 46 80 00       	push   $0x804648
  802424:	68 0d 01 00 00       	push   $0x10d
  802429:	68 13 46 80 00       	push   $0x804613
  80242e:	e8 35 eb ff ff       	call   800f68 <_panic>

00802433 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  802433:	55                   	push   %ebp
  802434:	89 e5                	mov    %esp,%ebp
  802436:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802439:	83 ec 04             	sub    $0x4,%esp
  80243c:	68 6c 46 80 00       	push   $0x80466c
  802441:	68 18 01 00 00       	push   $0x118
  802446:	68 13 46 80 00       	push   $0x804613
  80244b:	e8 18 eb ff ff       	call   800f68 <_panic>

00802450 <shrink>:

}
void shrink(uint32 newSize)
{
  802450:	55                   	push   %ebp
  802451:	89 e5                	mov    %esp,%ebp
  802453:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802456:	83 ec 04             	sub    $0x4,%esp
  802459:	68 6c 46 80 00       	push   $0x80466c
  80245e:	68 1d 01 00 00       	push   $0x11d
  802463:	68 13 46 80 00       	push   $0x804613
  802468:	e8 fb ea ff ff       	call   800f68 <_panic>

0080246d <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80246d:	55                   	push   %ebp
  80246e:	89 e5                	mov    %esp,%ebp
  802470:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802473:	83 ec 04             	sub    $0x4,%esp
  802476:	68 6c 46 80 00       	push   $0x80466c
  80247b:	68 22 01 00 00       	push   $0x122
  802480:	68 13 46 80 00       	push   $0x804613
  802485:	e8 de ea ff ff       	call   800f68 <_panic>

0080248a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80248a:	55                   	push   %ebp
  80248b:	89 e5                	mov    %esp,%ebp
  80248d:	57                   	push   %edi
  80248e:	56                   	push   %esi
  80248f:	53                   	push   %ebx
  802490:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802493:	8b 45 08             	mov    0x8(%ebp),%eax
  802496:	8b 55 0c             	mov    0xc(%ebp),%edx
  802499:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80249c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80249f:	8b 7d 18             	mov    0x18(%ebp),%edi
  8024a2:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8024a5:	cd 30                	int    $0x30
  8024a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8024aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8024ad:	83 c4 10             	add    $0x10,%esp
  8024b0:	5b                   	pop    %ebx
  8024b1:	5e                   	pop    %esi
  8024b2:	5f                   	pop    %edi
  8024b3:	5d                   	pop    %ebp
  8024b4:	c3                   	ret    

008024b5 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8024b5:	55                   	push   %ebp
  8024b6:	89 e5                	mov    %esp,%ebp
  8024b8:	83 ec 04             	sub    $0x4,%esp
  8024bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8024be:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8024c1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8024c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c8:	6a 00                	push   $0x0
  8024ca:	6a 00                	push   $0x0
  8024cc:	52                   	push   %edx
  8024cd:	ff 75 0c             	pushl  0xc(%ebp)
  8024d0:	50                   	push   %eax
  8024d1:	6a 00                	push   $0x0
  8024d3:	e8 b2 ff ff ff       	call   80248a <syscall>
  8024d8:	83 c4 18             	add    $0x18,%esp
}
  8024db:	90                   	nop
  8024dc:	c9                   	leave  
  8024dd:	c3                   	ret    

008024de <sys_cgetc>:

int
sys_cgetc(void)
{
  8024de:	55                   	push   %ebp
  8024df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8024e1:	6a 00                	push   $0x0
  8024e3:	6a 00                	push   $0x0
  8024e5:	6a 00                	push   $0x0
  8024e7:	6a 00                	push   $0x0
  8024e9:	6a 00                	push   $0x0
  8024eb:	6a 01                	push   $0x1
  8024ed:	e8 98 ff ff ff       	call   80248a <syscall>
  8024f2:	83 c4 18             	add    $0x18,%esp
}
  8024f5:	c9                   	leave  
  8024f6:	c3                   	ret    

008024f7 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8024f7:	55                   	push   %ebp
  8024f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8024fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802500:	6a 00                	push   $0x0
  802502:	6a 00                	push   $0x0
  802504:	6a 00                	push   $0x0
  802506:	52                   	push   %edx
  802507:	50                   	push   %eax
  802508:	6a 05                	push   $0x5
  80250a:	e8 7b ff ff ff       	call   80248a <syscall>
  80250f:	83 c4 18             	add    $0x18,%esp
}
  802512:	c9                   	leave  
  802513:	c3                   	ret    

00802514 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802514:	55                   	push   %ebp
  802515:	89 e5                	mov    %esp,%ebp
  802517:	56                   	push   %esi
  802518:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802519:	8b 75 18             	mov    0x18(%ebp),%esi
  80251c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80251f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802522:	8b 55 0c             	mov    0xc(%ebp),%edx
  802525:	8b 45 08             	mov    0x8(%ebp),%eax
  802528:	56                   	push   %esi
  802529:	53                   	push   %ebx
  80252a:	51                   	push   %ecx
  80252b:	52                   	push   %edx
  80252c:	50                   	push   %eax
  80252d:	6a 06                	push   $0x6
  80252f:	e8 56 ff ff ff       	call   80248a <syscall>
  802534:	83 c4 18             	add    $0x18,%esp
}
  802537:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80253a:	5b                   	pop    %ebx
  80253b:	5e                   	pop    %esi
  80253c:	5d                   	pop    %ebp
  80253d:	c3                   	ret    

0080253e <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80253e:	55                   	push   %ebp
  80253f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802541:	8b 55 0c             	mov    0xc(%ebp),%edx
  802544:	8b 45 08             	mov    0x8(%ebp),%eax
  802547:	6a 00                	push   $0x0
  802549:	6a 00                	push   $0x0
  80254b:	6a 00                	push   $0x0
  80254d:	52                   	push   %edx
  80254e:	50                   	push   %eax
  80254f:	6a 07                	push   $0x7
  802551:	e8 34 ff ff ff       	call   80248a <syscall>
  802556:	83 c4 18             	add    $0x18,%esp
}
  802559:	c9                   	leave  
  80255a:	c3                   	ret    

0080255b <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80255b:	55                   	push   %ebp
  80255c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80255e:	6a 00                	push   $0x0
  802560:	6a 00                	push   $0x0
  802562:	6a 00                	push   $0x0
  802564:	ff 75 0c             	pushl  0xc(%ebp)
  802567:	ff 75 08             	pushl  0x8(%ebp)
  80256a:	6a 08                	push   $0x8
  80256c:	e8 19 ff ff ff       	call   80248a <syscall>
  802571:	83 c4 18             	add    $0x18,%esp
}
  802574:	c9                   	leave  
  802575:	c3                   	ret    

00802576 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802576:	55                   	push   %ebp
  802577:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802579:	6a 00                	push   $0x0
  80257b:	6a 00                	push   $0x0
  80257d:	6a 00                	push   $0x0
  80257f:	6a 00                	push   $0x0
  802581:	6a 00                	push   $0x0
  802583:	6a 09                	push   $0x9
  802585:	e8 00 ff ff ff       	call   80248a <syscall>
  80258a:	83 c4 18             	add    $0x18,%esp
}
  80258d:	c9                   	leave  
  80258e:	c3                   	ret    

0080258f <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80258f:	55                   	push   %ebp
  802590:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802592:	6a 00                	push   $0x0
  802594:	6a 00                	push   $0x0
  802596:	6a 00                	push   $0x0
  802598:	6a 00                	push   $0x0
  80259a:	6a 00                	push   $0x0
  80259c:	6a 0a                	push   $0xa
  80259e:	e8 e7 fe ff ff       	call   80248a <syscall>
  8025a3:	83 c4 18             	add    $0x18,%esp
}
  8025a6:	c9                   	leave  
  8025a7:	c3                   	ret    

008025a8 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8025a8:	55                   	push   %ebp
  8025a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8025ab:	6a 00                	push   $0x0
  8025ad:	6a 00                	push   $0x0
  8025af:	6a 00                	push   $0x0
  8025b1:	6a 00                	push   $0x0
  8025b3:	6a 00                	push   $0x0
  8025b5:	6a 0b                	push   $0xb
  8025b7:	e8 ce fe ff ff       	call   80248a <syscall>
  8025bc:	83 c4 18             	add    $0x18,%esp
}
  8025bf:	c9                   	leave  
  8025c0:	c3                   	ret    

008025c1 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8025c1:	55                   	push   %ebp
  8025c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8025c4:	6a 00                	push   $0x0
  8025c6:	6a 00                	push   $0x0
  8025c8:	6a 00                	push   $0x0
  8025ca:	ff 75 0c             	pushl  0xc(%ebp)
  8025cd:	ff 75 08             	pushl  0x8(%ebp)
  8025d0:	6a 0f                	push   $0xf
  8025d2:	e8 b3 fe ff ff       	call   80248a <syscall>
  8025d7:	83 c4 18             	add    $0x18,%esp
	return;
  8025da:	90                   	nop
}
  8025db:	c9                   	leave  
  8025dc:	c3                   	ret    

008025dd <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8025dd:	55                   	push   %ebp
  8025de:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8025e0:	6a 00                	push   $0x0
  8025e2:	6a 00                	push   $0x0
  8025e4:	6a 00                	push   $0x0
  8025e6:	ff 75 0c             	pushl  0xc(%ebp)
  8025e9:	ff 75 08             	pushl  0x8(%ebp)
  8025ec:	6a 10                	push   $0x10
  8025ee:	e8 97 fe ff ff       	call   80248a <syscall>
  8025f3:	83 c4 18             	add    $0x18,%esp
	return ;
  8025f6:	90                   	nop
}
  8025f7:	c9                   	leave  
  8025f8:	c3                   	ret    

008025f9 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8025f9:	55                   	push   %ebp
  8025fa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8025fc:	6a 00                	push   $0x0
  8025fe:	6a 00                	push   $0x0
  802600:	ff 75 10             	pushl  0x10(%ebp)
  802603:	ff 75 0c             	pushl  0xc(%ebp)
  802606:	ff 75 08             	pushl  0x8(%ebp)
  802609:	6a 11                	push   $0x11
  80260b:	e8 7a fe ff ff       	call   80248a <syscall>
  802610:	83 c4 18             	add    $0x18,%esp
	return ;
  802613:	90                   	nop
}
  802614:	c9                   	leave  
  802615:	c3                   	ret    

00802616 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802616:	55                   	push   %ebp
  802617:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802619:	6a 00                	push   $0x0
  80261b:	6a 00                	push   $0x0
  80261d:	6a 00                	push   $0x0
  80261f:	6a 00                	push   $0x0
  802621:	6a 00                	push   $0x0
  802623:	6a 0c                	push   $0xc
  802625:	e8 60 fe ff ff       	call   80248a <syscall>
  80262a:	83 c4 18             	add    $0x18,%esp
}
  80262d:	c9                   	leave  
  80262e:	c3                   	ret    

0080262f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80262f:	55                   	push   %ebp
  802630:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802632:	6a 00                	push   $0x0
  802634:	6a 00                	push   $0x0
  802636:	6a 00                	push   $0x0
  802638:	6a 00                	push   $0x0
  80263a:	ff 75 08             	pushl  0x8(%ebp)
  80263d:	6a 0d                	push   $0xd
  80263f:	e8 46 fe ff ff       	call   80248a <syscall>
  802644:	83 c4 18             	add    $0x18,%esp
}
  802647:	c9                   	leave  
  802648:	c3                   	ret    

00802649 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802649:	55                   	push   %ebp
  80264a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80264c:	6a 00                	push   $0x0
  80264e:	6a 00                	push   $0x0
  802650:	6a 00                	push   $0x0
  802652:	6a 00                	push   $0x0
  802654:	6a 00                	push   $0x0
  802656:	6a 0e                	push   $0xe
  802658:	e8 2d fe ff ff       	call   80248a <syscall>
  80265d:	83 c4 18             	add    $0x18,%esp
}
  802660:	90                   	nop
  802661:	c9                   	leave  
  802662:	c3                   	ret    

00802663 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802663:	55                   	push   %ebp
  802664:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802666:	6a 00                	push   $0x0
  802668:	6a 00                	push   $0x0
  80266a:	6a 00                	push   $0x0
  80266c:	6a 00                	push   $0x0
  80266e:	6a 00                	push   $0x0
  802670:	6a 13                	push   $0x13
  802672:	e8 13 fe ff ff       	call   80248a <syscall>
  802677:	83 c4 18             	add    $0x18,%esp
}
  80267a:	90                   	nop
  80267b:	c9                   	leave  
  80267c:	c3                   	ret    

0080267d <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80267d:	55                   	push   %ebp
  80267e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802680:	6a 00                	push   $0x0
  802682:	6a 00                	push   $0x0
  802684:	6a 00                	push   $0x0
  802686:	6a 00                	push   $0x0
  802688:	6a 00                	push   $0x0
  80268a:	6a 14                	push   $0x14
  80268c:	e8 f9 fd ff ff       	call   80248a <syscall>
  802691:	83 c4 18             	add    $0x18,%esp
}
  802694:	90                   	nop
  802695:	c9                   	leave  
  802696:	c3                   	ret    

00802697 <sys_cputc>:


void
sys_cputc(const char c)
{
  802697:	55                   	push   %ebp
  802698:	89 e5                	mov    %esp,%ebp
  80269a:	83 ec 04             	sub    $0x4,%esp
  80269d:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8026a3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8026a7:	6a 00                	push   $0x0
  8026a9:	6a 00                	push   $0x0
  8026ab:	6a 00                	push   $0x0
  8026ad:	6a 00                	push   $0x0
  8026af:	50                   	push   %eax
  8026b0:	6a 15                	push   $0x15
  8026b2:	e8 d3 fd ff ff       	call   80248a <syscall>
  8026b7:	83 c4 18             	add    $0x18,%esp
}
  8026ba:	90                   	nop
  8026bb:	c9                   	leave  
  8026bc:	c3                   	ret    

008026bd <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8026bd:	55                   	push   %ebp
  8026be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8026c0:	6a 00                	push   $0x0
  8026c2:	6a 00                	push   $0x0
  8026c4:	6a 00                	push   $0x0
  8026c6:	6a 00                	push   $0x0
  8026c8:	6a 00                	push   $0x0
  8026ca:	6a 16                	push   $0x16
  8026cc:	e8 b9 fd ff ff       	call   80248a <syscall>
  8026d1:	83 c4 18             	add    $0x18,%esp
}
  8026d4:	90                   	nop
  8026d5:	c9                   	leave  
  8026d6:	c3                   	ret    

008026d7 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8026d7:	55                   	push   %ebp
  8026d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8026da:	8b 45 08             	mov    0x8(%ebp),%eax
  8026dd:	6a 00                	push   $0x0
  8026df:	6a 00                	push   $0x0
  8026e1:	6a 00                	push   $0x0
  8026e3:	ff 75 0c             	pushl  0xc(%ebp)
  8026e6:	50                   	push   %eax
  8026e7:	6a 17                	push   $0x17
  8026e9:	e8 9c fd ff ff       	call   80248a <syscall>
  8026ee:	83 c4 18             	add    $0x18,%esp
}
  8026f1:	c9                   	leave  
  8026f2:	c3                   	ret    

008026f3 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8026f3:	55                   	push   %ebp
  8026f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8026f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8026fc:	6a 00                	push   $0x0
  8026fe:	6a 00                	push   $0x0
  802700:	6a 00                	push   $0x0
  802702:	52                   	push   %edx
  802703:	50                   	push   %eax
  802704:	6a 1a                	push   $0x1a
  802706:	e8 7f fd ff ff       	call   80248a <syscall>
  80270b:	83 c4 18             	add    $0x18,%esp
}
  80270e:	c9                   	leave  
  80270f:	c3                   	ret    

00802710 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802710:	55                   	push   %ebp
  802711:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802713:	8b 55 0c             	mov    0xc(%ebp),%edx
  802716:	8b 45 08             	mov    0x8(%ebp),%eax
  802719:	6a 00                	push   $0x0
  80271b:	6a 00                	push   $0x0
  80271d:	6a 00                	push   $0x0
  80271f:	52                   	push   %edx
  802720:	50                   	push   %eax
  802721:	6a 18                	push   $0x18
  802723:	e8 62 fd ff ff       	call   80248a <syscall>
  802728:	83 c4 18             	add    $0x18,%esp
}
  80272b:	90                   	nop
  80272c:	c9                   	leave  
  80272d:	c3                   	ret    

0080272e <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80272e:	55                   	push   %ebp
  80272f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802731:	8b 55 0c             	mov    0xc(%ebp),%edx
  802734:	8b 45 08             	mov    0x8(%ebp),%eax
  802737:	6a 00                	push   $0x0
  802739:	6a 00                	push   $0x0
  80273b:	6a 00                	push   $0x0
  80273d:	52                   	push   %edx
  80273e:	50                   	push   %eax
  80273f:	6a 19                	push   $0x19
  802741:	e8 44 fd ff ff       	call   80248a <syscall>
  802746:	83 c4 18             	add    $0x18,%esp
}
  802749:	90                   	nop
  80274a:	c9                   	leave  
  80274b:	c3                   	ret    

0080274c <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80274c:	55                   	push   %ebp
  80274d:	89 e5                	mov    %esp,%ebp
  80274f:	83 ec 04             	sub    $0x4,%esp
  802752:	8b 45 10             	mov    0x10(%ebp),%eax
  802755:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802758:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80275b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80275f:	8b 45 08             	mov    0x8(%ebp),%eax
  802762:	6a 00                	push   $0x0
  802764:	51                   	push   %ecx
  802765:	52                   	push   %edx
  802766:	ff 75 0c             	pushl  0xc(%ebp)
  802769:	50                   	push   %eax
  80276a:	6a 1b                	push   $0x1b
  80276c:	e8 19 fd ff ff       	call   80248a <syscall>
  802771:	83 c4 18             	add    $0x18,%esp
}
  802774:	c9                   	leave  
  802775:	c3                   	ret    

00802776 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802776:	55                   	push   %ebp
  802777:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802779:	8b 55 0c             	mov    0xc(%ebp),%edx
  80277c:	8b 45 08             	mov    0x8(%ebp),%eax
  80277f:	6a 00                	push   $0x0
  802781:	6a 00                	push   $0x0
  802783:	6a 00                	push   $0x0
  802785:	52                   	push   %edx
  802786:	50                   	push   %eax
  802787:	6a 1c                	push   $0x1c
  802789:	e8 fc fc ff ff       	call   80248a <syscall>
  80278e:	83 c4 18             	add    $0x18,%esp
}
  802791:	c9                   	leave  
  802792:	c3                   	ret    

00802793 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802793:	55                   	push   %ebp
  802794:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802796:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802799:	8b 55 0c             	mov    0xc(%ebp),%edx
  80279c:	8b 45 08             	mov    0x8(%ebp),%eax
  80279f:	6a 00                	push   $0x0
  8027a1:	6a 00                	push   $0x0
  8027a3:	51                   	push   %ecx
  8027a4:	52                   	push   %edx
  8027a5:	50                   	push   %eax
  8027a6:	6a 1d                	push   $0x1d
  8027a8:	e8 dd fc ff ff       	call   80248a <syscall>
  8027ad:	83 c4 18             	add    $0x18,%esp
}
  8027b0:	c9                   	leave  
  8027b1:	c3                   	ret    

008027b2 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8027b2:	55                   	push   %ebp
  8027b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8027b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8027bb:	6a 00                	push   $0x0
  8027bd:	6a 00                	push   $0x0
  8027bf:	6a 00                	push   $0x0
  8027c1:	52                   	push   %edx
  8027c2:	50                   	push   %eax
  8027c3:	6a 1e                	push   $0x1e
  8027c5:	e8 c0 fc ff ff       	call   80248a <syscall>
  8027ca:	83 c4 18             	add    $0x18,%esp
}
  8027cd:	c9                   	leave  
  8027ce:	c3                   	ret    

008027cf <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8027cf:	55                   	push   %ebp
  8027d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8027d2:	6a 00                	push   $0x0
  8027d4:	6a 00                	push   $0x0
  8027d6:	6a 00                	push   $0x0
  8027d8:	6a 00                	push   $0x0
  8027da:	6a 00                	push   $0x0
  8027dc:	6a 1f                	push   $0x1f
  8027de:	e8 a7 fc ff ff       	call   80248a <syscall>
  8027e3:	83 c4 18             	add    $0x18,%esp
}
  8027e6:	c9                   	leave  
  8027e7:	c3                   	ret    

008027e8 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8027e8:	55                   	push   %ebp
  8027e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8027eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ee:	6a 00                	push   $0x0
  8027f0:	ff 75 14             	pushl  0x14(%ebp)
  8027f3:	ff 75 10             	pushl  0x10(%ebp)
  8027f6:	ff 75 0c             	pushl  0xc(%ebp)
  8027f9:	50                   	push   %eax
  8027fa:	6a 20                	push   $0x20
  8027fc:	e8 89 fc ff ff       	call   80248a <syscall>
  802801:	83 c4 18             	add    $0x18,%esp
}
  802804:	c9                   	leave  
  802805:	c3                   	ret    

00802806 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802806:	55                   	push   %ebp
  802807:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802809:	8b 45 08             	mov    0x8(%ebp),%eax
  80280c:	6a 00                	push   $0x0
  80280e:	6a 00                	push   $0x0
  802810:	6a 00                	push   $0x0
  802812:	6a 00                	push   $0x0
  802814:	50                   	push   %eax
  802815:	6a 21                	push   $0x21
  802817:	e8 6e fc ff ff       	call   80248a <syscall>
  80281c:	83 c4 18             	add    $0x18,%esp
}
  80281f:	90                   	nop
  802820:	c9                   	leave  
  802821:	c3                   	ret    

00802822 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802822:	55                   	push   %ebp
  802823:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802825:	8b 45 08             	mov    0x8(%ebp),%eax
  802828:	6a 00                	push   $0x0
  80282a:	6a 00                	push   $0x0
  80282c:	6a 00                	push   $0x0
  80282e:	6a 00                	push   $0x0
  802830:	50                   	push   %eax
  802831:	6a 22                	push   $0x22
  802833:	e8 52 fc ff ff       	call   80248a <syscall>
  802838:	83 c4 18             	add    $0x18,%esp
}
  80283b:	c9                   	leave  
  80283c:	c3                   	ret    

0080283d <sys_getenvid>:

int32 sys_getenvid(void)
{
  80283d:	55                   	push   %ebp
  80283e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802840:	6a 00                	push   $0x0
  802842:	6a 00                	push   $0x0
  802844:	6a 00                	push   $0x0
  802846:	6a 00                	push   $0x0
  802848:	6a 00                	push   $0x0
  80284a:	6a 02                	push   $0x2
  80284c:	e8 39 fc ff ff       	call   80248a <syscall>
  802851:	83 c4 18             	add    $0x18,%esp
}
  802854:	c9                   	leave  
  802855:	c3                   	ret    

00802856 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802856:	55                   	push   %ebp
  802857:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802859:	6a 00                	push   $0x0
  80285b:	6a 00                	push   $0x0
  80285d:	6a 00                	push   $0x0
  80285f:	6a 00                	push   $0x0
  802861:	6a 00                	push   $0x0
  802863:	6a 03                	push   $0x3
  802865:	e8 20 fc ff ff       	call   80248a <syscall>
  80286a:	83 c4 18             	add    $0x18,%esp
}
  80286d:	c9                   	leave  
  80286e:	c3                   	ret    

0080286f <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80286f:	55                   	push   %ebp
  802870:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802872:	6a 00                	push   $0x0
  802874:	6a 00                	push   $0x0
  802876:	6a 00                	push   $0x0
  802878:	6a 00                	push   $0x0
  80287a:	6a 00                	push   $0x0
  80287c:	6a 04                	push   $0x4
  80287e:	e8 07 fc ff ff       	call   80248a <syscall>
  802883:	83 c4 18             	add    $0x18,%esp
}
  802886:	c9                   	leave  
  802887:	c3                   	ret    

00802888 <sys_exit_env>:


void sys_exit_env(void)
{
  802888:	55                   	push   %ebp
  802889:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80288b:	6a 00                	push   $0x0
  80288d:	6a 00                	push   $0x0
  80288f:	6a 00                	push   $0x0
  802891:	6a 00                	push   $0x0
  802893:	6a 00                	push   $0x0
  802895:	6a 23                	push   $0x23
  802897:	e8 ee fb ff ff       	call   80248a <syscall>
  80289c:	83 c4 18             	add    $0x18,%esp
}
  80289f:	90                   	nop
  8028a0:	c9                   	leave  
  8028a1:	c3                   	ret    

008028a2 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8028a2:	55                   	push   %ebp
  8028a3:	89 e5                	mov    %esp,%ebp
  8028a5:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8028a8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8028ab:	8d 50 04             	lea    0x4(%eax),%edx
  8028ae:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8028b1:	6a 00                	push   $0x0
  8028b3:	6a 00                	push   $0x0
  8028b5:	6a 00                	push   $0x0
  8028b7:	52                   	push   %edx
  8028b8:	50                   	push   %eax
  8028b9:	6a 24                	push   $0x24
  8028bb:	e8 ca fb ff ff       	call   80248a <syscall>
  8028c0:	83 c4 18             	add    $0x18,%esp
	return result;
  8028c3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8028c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8028c9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8028cc:	89 01                	mov    %eax,(%ecx)
  8028ce:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8028d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d4:	c9                   	leave  
  8028d5:	c2 04 00             	ret    $0x4

008028d8 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8028d8:	55                   	push   %ebp
  8028d9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8028db:	6a 00                	push   $0x0
  8028dd:	6a 00                	push   $0x0
  8028df:	ff 75 10             	pushl  0x10(%ebp)
  8028e2:	ff 75 0c             	pushl  0xc(%ebp)
  8028e5:	ff 75 08             	pushl  0x8(%ebp)
  8028e8:	6a 12                	push   $0x12
  8028ea:	e8 9b fb ff ff       	call   80248a <syscall>
  8028ef:	83 c4 18             	add    $0x18,%esp
	return ;
  8028f2:	90                   	nop
}
  8028f3:	c9                   	leave  
  8028f4:	c3                   	ret    

008028f5 <sys_rcr2>:
uint32 sys_rcr2()
{
  8028f5:	55                   	push   %ebp
  8028f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8028f8:	6a 00                	push   $0x0
  8028fa:	6a 00                	push   $0x0
  8028fc:	6a 00                	push   $0x0
  8028fe:	6a 00                	push   $0x0
  802900:	6a 00                	push   $0x0
  802902:	6a 25                	push   $0x25
  802904:	e8 81 fb ff ff       	call   80248a <syscall>
  802909:	83 c4 18             	add    $0x18,%esp
}
  80290c:	c9                   	leave  
  80290d:	c3                   	ret    

0080290e <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80290e:	55                   	push   %ebp
  80290f:	89 e5                	mov    %esp,%ebp
  802911:	83 ec 04             	sub    $0x4,%esp
  802914:	8b 45 08             	mov    0x8(%ebp),%eax
  802917:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80291a:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80291e:	6a 00                	push   $0x0
  802920:	6a 00                	push   $0x0
  802922:	6a 00                	push   $0x0
  802924:	6a 00                	push   $0x0
  802926:	50                   	push   %eax
  802927:	6a 26                	push   $0x26
  802929:	e8 5c fb ff ff       	call   80248a <syscall>
  80292e:	83 c4 18             	add    $0x18,%esp
	return ;
  802931:	90                   	nop
}
  802932:	c9                   	leave  
  802933:	c3                   	ret    

00802934 <rsttst>:
void rsttst()
{
  802934:	55                   	push   %ebp
  802935:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802937:	6a 00                	push   $0x0
  802939:	6a 00                	push   $0x0
  80293b:	6a 00                	push   $0x0
  80293d:	6a 00                	push   $0x0
  80293f:	6a 00                	push   $0x0
  802941:	6a 28                	push   $0x28
  802943:	e8 42 fb ff ff       	call   80248a <syscall>
  802948:	83 c4 18             	add    $0x18,%esp
	return ;
  80294b:	90                   	nop
}
  80294c:	c9                   	leave  
  80294d:	c3                   	ret    

0080294e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80294e:	55                   	push   %ebp
  80294f:	89 e5                	mov    %esp,%ebp
  802951:	83 ec 04             	sub    $0x4,%esp
  802954:	8b 45 14             	mov    0x14(%ebp),%eax
  802957:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80295a:	8b 55 18             	mov    0x18(%ebp),%edx
  80295d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802961:	52                   	push   %edx
  802962:	50                   	push   %eax
  802963:	ff 75 10             	pushl  0x10(%ebp)
  802966:	ff 75 0c             	pushl  0xc(%ebp)
  802969:	ff 75 08             	pushl  0x8(%ebp)
  80296c:	6a 27                	push   $0x27
  80296e:	e8 17 fb ff ff       	call   80248a <syscall>
  802973:	83 c4 18             	add    $0x18,%esp
	return ;
  802976:	90                   	nop
}
  802977:	c9                   	leave  
  802978:	c3                   	ret    

00802979 <chktst>:
void chktst(uint32 n)
{
  802979:	55                   	push   %ebp
  80297a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80297c:	6a 00                	push   $0x0
  80297e:	6a 00                	push   $0x0
  802980:	6a 00                	push   $0x0
  802982:	6a 00                	push   $0x0
  802984:	ff 75 08             	pushl  0x8(%ebp)
  802987:	6a 29                	push   $0x29
  802989:	e8 fc fa ff ff       	call   80248a <syscall>
  80298e:	83 c4 18             	add    $0x18,%esp
	return ;
  802991:	90                   	nop
}
  802992:	c9                   	leave  
  802993:	c3                   	ret    

00802994 <inctst>:

void inctst()
{
  802994:	55                   	push   %ebp
  802995:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802997:	6a 00                	push   $0x0
  802999:	6a 00                	push   $0x0
  80299b:	6a 00                	push   $0x0
  80299d:	6a 00                	push   $0x0
  80299f:	6a 00                	push   $0x0
  8029a1:	6a 2a                	push   $0x2a
  8029a3:	e8 e2 fa ff ff       	call   80248a <syscall>
  8029a8:	83 c4 18             	add    $0x18,%esp
	return ;
  8029ab:	90                   	nop
}
  8029ac:	c9                   	leave  
  8029ad:	c3                   	ret    

008029ae <gettst>:
uint32 gettst()
{
  8029ae:	55                   	push   %ebp
  8029af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8029b1:	6a 00                	push   $0x0
  8029b3:	6a 00                	push   $0x0
  8029b5:	6a 00                	push   $0x0
  8029b7:	6a 00                	push   $0x0
  8029b9:	6a 00                	push   $0x0
  8029bb:	6a 2b                	push   $0x2b
  8029bd:	e8 c8 fa ff ff       	call   80248a <syscall>
  8029c2:	83 c4 18             	add    $0x18,%esp
}
  8029c5:	c9                   	leave  
  8029c6:	c3                   	ret    

008029c7 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8029c7:	55                   	push   %ebp
  8029c8:	89 e5                	mov    %esp,%ebp
  8029ca:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8029cd:	6a 00                	push   $0x0
  8029cf:	6a 00                	push   $0x0
  8029d1:	6a 00                	push   $0x0
  8029d3:	6a 00                	push   $0x0
  8029d5:	6a 00                	push   $0x0
  8029d7:	6a 2c                	push   $0x2c
  8029d9:	e8 ac fa ff ff       	call   80248a <syscall>
  8029de:	83 c4 18             	add    $0x18,%esp
  8029e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8029e4:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8029e8:	75 07                	jne    8029f1 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8029ea:	b8 01 00 00 00       	mov    $0x1,%eax
  8029ef:	eb 05                	jmp    8029f6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8029f1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029f6:	c9                   	leave  
  8029f7:	c3                   	ret    

008029f8 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8029f8:	55                   	push   %ebp
  8029f9:	89 e5                	mov    %esp,%ebp
  8029fb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8029fe:	6a 00                	push   $0x0
  802a00:	6a 00                	push   $0x0
  802a02:	6a 00                	push   $0x0
  802a04:	6a 00                	push   $0x0
  802a06:	6a 00                	push   $0x0
  802a08:	6a 2c                	push   $0x2c
  802a0a:	e8 7b fa ff ff       	call   80248a <syscall>
  802a0f:	83 c4 18             	add    $0x18,%esp
  802a12:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802a15:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802a19:	75 07                	jne    802a22 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802a1b:	b8 01 00 00 00       	mov    $0x1,%eax
  802a20:	eb 05                	jmp    802a27 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802a22:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a27:	c9                   	leave  
  802a28:	c3                   	ret    

00802a29 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802a29:	55                   	push   %ebp
  802a2a:	89 e5                	mov    %esp,%ebp
  802a2c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802a2f:	6a 00                	push   $0x0
  802a31:	6a 00                	push   $0x0
  802a33:	6a 00                	push   $0x0
  802a35:	6a 00                	push   $0x0
  802a37:	6a 00                	push   $0x0
  802a39:	6a 2c                	push   $0x2c
  802a3b:	e8 4a fa ff ff       	call   80248a <syscall>
  802a40:	83 c4 18             	add    $0x18,%esp
  802a43:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802a46:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802a4a:	75 07                	jne    802a53 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802a4c:	b8 01 00 00 00       	mov    $0x1,%eax
  802a51:	eb 05                	jmp    802a58 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802a53:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a58:	c9                   	leave  
  802a59:	c3                   	ret    

00802a5a <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802a5a:	55                   	push   %ebp
  802a5b:	89 e5                	mov    %esp,%ebp
  802a5d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802a60:	6a 00                	push   $0x0
  802a62:	6a 00                	push   $0x0
  802a64:	6a 00                	push   $0x0
  802a66:	6a 00                	push   $0x0
  802a68:	6a 00                	push   $0x0
  802a6a:	6a 2c                	push   $0x2c
  802a6c:	e8 19 fa ff ff       	call   80248a <syscall>
  802a71:	83 c4 18             	add    $0x18,%esp
  802a74:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802a77:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802a7b:	75 07                	jne    802a84 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802a7d:	b8 01 00 00 00       	mov    $0x1,%eax
  802a82:	eb 05                	jmp    802a89 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802a84:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a89:	c9                   	leave  
  802a8a:	c3                   	ret    

00802a8b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802a8b:	55                   	push   %ebp
  802a8c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802a8e:	6a 00                	push   $0x0
  802a90:	6a 00                	push   $0x0
  802a92:	6a 00                	push   $0x0
  802a94:	6a 00                	push   $0x0
  802a96:	ff 75 08             	pushl  0x8(%ebp)
  802a99:	6a 2d                	push   $0x2d
  802a9b:	e8 ea f9 ff ff       	call   80248a <syscall>
  802aa0:	83 c4 18             	add    $0x18,%esp
	return ;
  802aa3:	90                   	nop
}
  802aa4:	c9                   	leave  
  802aa5:	c3                   	ret    

00802aa6 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802aa6:	55                   	push   %ebp
  802aa7:	89 e5                	mov    %esp,%ebp
  802aa9:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802aaa:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802aad:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802ab0:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab6:	6a 00                	push   $0x0
  802ab8:	53                   	push   %ebx
  802ab9:	51                   	push   %ecx
  802aba:	52                   	push   %edx
  802abb:	50                   	push   %eax
  802abc:	6a 2e                	push   $0x2e
  802abe:	e8 c7 f9 ff ff       	call   80248a <syscall>
  802ac3:	83 c4 18             	add    $0x18,%esp
}
  802ac6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802ac9:	c9                   	leave  
  802aca:	c3                   	ret    

00802acb <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802acb:	55                   	push   %ebp
  802acc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802ace:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad4:	6a 00                	push   $0x0
  802ad6:	6a 00                	push   $0x0
  802ad8:	6a 00                	push   $0x0
  802ada:	52                   	push   %edx
  802adb:	50                   	push   %eax
  802adc:	6a 2f                	push   $0x2f
  802ade:	e8 a7 f9 ff ff       	call   80248a <syscall>
  802ae3:	83 c4 18             	add    $0x18,%esp
}
  802ae6:	c9                   	leave  
  802ae7:	c3                   	ret    

00802ae8 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802ae8:	55                   	push   %ebp
  802ae9:	89 e5                	mov    %esp,%ebp
  802aeb:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802aee:	83 ec 0c             	sub    $0xc,%esp
  802af1:	68 7c 46 80 00       	push   $0x80467c
  802af6:	e8 21 e7 ff ff       	call   80121c <cprintf>
  802afb:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802afe:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802b05:	83 ec 0c             	sub    $0xc,%esp
  802b08:	68 a8 46 80 00       	push   $0x8046a8
  802b0d:	e8 0a e7 ff ff       	call   80121c <cprintf>
  802b12:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802b15:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802b19:	a1 38 51 80 00       	mov    0x805138,%eax
  802b1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b21:	eb 56                	jmp    802b79 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802b23:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b27:	74 1c                	je     802b45 <print_mem_block_lists+0x5d>
  802b29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2c:	8b 50 08             	mov    0x8(%eax),%edx
  802b2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b32:	8b 48 08             	mov    0x8(%eax),%ecx
  802b35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b38:	8b 40 0c             	mov    0xc(%eax),%eax
  802b3b:	01 c8                	add    %ecx,%eax
  802b3d:	39 c2                	cmp    %eax,%edx
  802b3f:	73 04                	jae    802b45 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802b41:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b48:	8b 50 08             	mov    0x8(%eax),%edx
  802b4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4e:	8b 40 0c             	mov    0xc(%eax),%eax
  802b51:	01 c2                	add    %eax,%edx
  802b53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b56:	8b 40 08             	mov    0x8(%eax),%eax
  802b59:	83 ec 04             	sub    $0x4,%esp
  802b5c:	52                   	push   %edx
  802b5d:	50                   	push   %eax
  802b5e:	68 bd 46 80 00       	push   $0x8046bd
  802b63:	e8 b4 e6 ff ff       	call   80121c <cprintf>
  802b68:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802b6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802b71:	a1 40 51 80 00       	mov    0x805140,%eax
  802b76:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b79:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b7d:	74 07                	je     802b86 <print_mem_block_lists+0x9e>
  802b7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b82:	8b 00                	mov    (%eax),%eax
  802b84:	eb 05                	jmp    802b8b <print_mem_block_lists+0xa3>
  802b86:	b8 00 00 00 00       	mov    $0x0,%eax
  802b8b:	a3 40 51 80 00       	mov    %eax,0x805140
  802b90:	a1 40 51 80 00       	mov    0x805140,%eax
  802b95:	85 c0                	test   %eax,%eax
  802b97:	75 8a                	jne    802b23 <print_mem_block_lists+0x3b>
  802b99:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b9d:	75 84                	jne    802b23 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802b9f:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802ba3:	75 10                	jne    802bb5 <print_mem_block_lists+0xcd>
  802ba5:	83 ec 0c             	sub    $0xc,%esp
  802ba8:	68 cc 46 80 00       	push   $0x8046cc
  802bad:	e8 6a e6 ff ff       	call   80121c <cprintf>
  802bb2:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802bb5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802bbc:	83 ec 0c             	sub    $0xc,%esp
  802bbf:	68 f0 46 80 00       	push   $0x8046f0
  802bc4:	e8 53 e6 ff ff       	call   80121c <cprintf>
  802bc9:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802bcc:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802bd0:	a1 40 50 80 00       	mov    0x805040,%eax
  802bd5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bd8:	eb 56                	jmp    802c30 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802bda:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bde:	74 1c                	je     802bfc <print_mem_block_lists+0x114>
  802be0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be3:	8b 50 08             	mov    0x8(%eax),%edx
  802be6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be9:	8b 48 08             	mov    0x8(%eax),%ecx
  802bec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bef:	8b 40 0c             	mov    0xc(%eax),%eax
  802bf2:	01 c8                	add    %ecx,%eax
  802bf4:	39 c2                	cmp    %eax,%edx
  802bf6:	73 04                	jae    802bfc <print_mem_block_lists+0x114>
			sorted = 0 ;
  802bf8:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802bfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bff:	8b 50 08             	mov    0x8(%eax),%edx
  802c02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c05:	8b 40 0c             	mov    0xc(%eax),%eax
  802c08:	01 c2                	add    %eax,%edx
  802c0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0d:	8b 40 08             	mov    0x8(%eax),%eax
  802c10:	83 ec 04             	sub    $0x4,%esp
  802c13:	52                   	push   %edx
  802c14:	50                   	push   %eax
  802c15:	68 bd 46 80 00       	push   $0x8046bd
  802c1a:	e8 fd e5 ff ff       	call   80121c <cprintf>
  802c1f:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802c22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c25:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802c28:	a1 48 50 80 00       	mov    0x805048,%eax
  802c2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c30:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c34:	74 07                	je     802c3d <print_mem_block_lists+0x155>
  802c36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c39:	8b 00                	mov    (%eax),%eax
  802c3b:	eb 05                	jmp    802c42 <print_mem_block_lists+0x15a>
  802c3d:	b8 00 00 00 00       	mov    $0x0,%eax
  802c42:	a3 48 50 80 00       	mov    %eax,0x805048
  802c47:	a1 48 50 80 00       	mov    0x805048,%eax
  802c4c:	85 c0                	test   %eax,%eax
  802c4e:	75 8a                	jne    802bda <print_mem_block_lists+0xf2>
  802c50:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c54:	75 84                	jne    802bda <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802c56:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802c5a:	75 10                	jne    802c6c <print_mem_block_lists+0x184>
  802c5c:	83 ec 0c             	sub    $0xc,%esp
  802c5f:	68 08 47 80 00       	push   $0x804708
  802c64:	e8 b3 e5 ff ff       	call   80121c <cprintf>
  802c69:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802c6c:	83 ec 0c             	sub    $0xc,%esp
  802c6f:	68 7c 46 80 00       	push   $0x80467c
  802c74:	e8 a3 e5 ff ff       	call   80121c <cprintf>
  802c79:	83 c4 10             	add    $0x10,%esp

}
  802c7c:	90                   	nop
  802c7d:	c9                   	leave  
  802c7e:	c3                   	ret    

00802c7f <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802c7f:	55                   	push   %ebp
  802c80:	89 e5                	mov    %esp,%ebp
  802c82:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  802c85:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802c8c:	00 00 00 
  802c8f:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802c96:	00 00 00 
  802c99:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802ca0:	00 00 00 
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  802ca3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802caa:	e9 9e 00 00 00       	jmp    802d4d <initialize_MemBlocksList+0xce>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
  802caf:	a1 50 50 80 00       	mov    0x805050,%eax
  802cb4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cb7:	c1 e2 04             	shl    $0x4,%edx
  802cba:	01 d0                	add    %edx,%eax
  802cbc:	85 c0                	test   %eax,%eax
  802cbe:	75 14                	jne    802cd4 <initialize_MemBlocksList+0x55>
  802cc0:	83 ec 04             	sub    $0x4,%esp
  802cc3:	68 30 47 80 00       	push   $0x804730
  802cc8:	6a 43                	push   $0x43
  802cca:	68 53 47 80 00       	push   $0x804753
  802ccf:	e8 94 e2 ff ff       	call   800f68 <_panic>
  802cd4:	a1 50 50 80 00       	mov    0x805050,%eax
  802cd9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cdc:	c1 e2 04             	shl    $0x4,%edx
  802cdf:	01 d0                	add    %edx,%eax
  802ce1:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802ce7:	89 10                	mov    %edx,(%eax)
  802ce9:	8b 00                	mov    (%eax),%eax
  802ceb:	85 c0                	test   %eax,%eax
  802ced:	74 18                	je     802d07 <initialize_MemBlocksList+0x88>
  802cef:	a1 48 51 80 00       	mov    0x805148,%eax
  802cf4:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802cfa:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802cfd:	c1 e1 04             	shl    $0x4,%ecx
  802d00:	01 ca                	add    %ecx,%edx
  802d02:	89 50 04             	mov    %edx,0x4(%eax)
  802d05:	eb 12                	jmp    802d19 <initialize_MemBlocksList+0x9a>
  802d07:	a1 50 50 80 00       	mov    0x805050,%eax
  802d0c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d0f:	c1 e2 04             	shl    $0x4,%edx
  802d12:	01 d0                	add    %edx,%eax
  802d14:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d19:	a1 50 50 80 00       	mov    0x805050,%eax
  802d1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d21:	c1 e2 04             	shl    $0x4,%edx
  802d24:	01 d0                	add    %edx,%eax
  802d26:	a3 48 51 80 00       	mov    %eax,0x805148
  802d2b:	a1 50 50 80 00       	mov    0x805050,%eax
  802d30:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d33:	c1 e2 04             	shl    $0x4,%edx
  802d36:	01 d0                	add    %edx,%eax
  802d38:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d3f:	a1 54 51 80 00       	mov    0x805154,%eax
  802d44:	40                   	inc    %eax
  802d45:	a3 54 51 80 00       	mov    %eax,0x805154
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  802d4a:	ff 45 f4             	incl   -0xc(%ebp)
  802d4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d50:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d53:	0f 82 56 ff ff ff    	jb     802caf <initialize_MemBlocksList+0x30>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
		}
}
  802d59:	90                   	nop
  802d5a:	c9                   	leave  
  802d5b:	c3                   	ret    

00802d5c <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802d5c:	55                   	push   %ebp
  802d5d:	89 e5                	mov    %esp,%ebp
  802d5f:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  802d62:	a1 38 51 80 00       	mov    0x805138,%eax
  802d67:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802d6a:	eb 18                	jmp    802d84 <find_block+0x28>
	{
		if (ele->sva==va)
  802d6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802d6f:	8b 40 08             	mov    0x8(%eax),%eax
  802d72:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802d75:	75 05                	jne    802d7c <find_block+0x20>
			return ele;
  802d77:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802d7a:	eb 7b                	jmp    802df7 <find_block+0x9b>
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  802d7c:	a1 40 51 80 00       	mov    0x805140,%eax
  802d81:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802d84:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802d88:	74 07                	je     802d91 <find_block+0x35>
  802d8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802d8d:	8b 00                	mov    (%eax),%eax
  802d8f:	eb 05                	jmp    802d96 <find_block+0x3a>
  802d91:	b8 00 00 00 00       	mov    $0x0,%eax
  802d96:	a3 40 51 80 00       	mov    %eax,0x805140
  802d9b:	a1 40 51 80 00       	mov    0x805140,%eax
  802da0:	85 c0                	test   %eax,%eax
  802da2:	75 c8                	jne    802d6c <find_block+0x10>
  802da4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802da8:	75 c2                	jne    802d6c <find_block+0x10>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  802daa:	a1 40 50 80 00       	mov    0x805040,%eax
  802daf:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802db2:	eb 18                	jmp    802dcc <find_block+0x70>
	{
		if (ele->sva==va)
  802db4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802db7:	8b 40 08             	mov    0x8(%eax),%eax
  802dba:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802dbd:	75 05                	jne    802dc4 <find_block+0x68>
					return ele;
  802dbf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802dc2:	eb 33                	jmp    802df7 <find_block+0x9b>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  802dc4:	a1 48 50 80 00       	mov    0x805048,%eax
  802dc9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802dcc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802dd0:	74 07                	je     802dd9 <find_block+0x7d>
  802dd2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802dd5:	8b 00                	mov    (%eax),%eax
  802dd7:	eb 05                	jmp    802dde <find_block+0x82>
  802dd9:	b8 00 00 00 00       	mov    $0x0,%eax
  802dde:	a3 48 50 80 00       	mov    %eax,0x805048
  802de3:	a1 48 50 80 00       	mov    0x805048,%eax
  802de8:	85 c0                	test   %eax,%eax
  802dea:	75 c8                	jne    802db4 <find_block+0x58>
  802dec:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802df0:	75 c2                	jne    802db4 <find_block+0x58>
	{
		if (ele->sva==va)
					return ele;
	}
return NULL;
  802df2:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802df7:	c9                   	leave  
  802df8:	c3                   	ret    

00802df9 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802df9:	55                   	push   %ebp
  802dfa:	89 e5                	mov    %esp,%ebp
  802dfc:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;

int x =LIST_SIZE(&AllocMemBlocksList);
  802dff:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802e04:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((x==0))
  802e07:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e0b:	75 62                	jne    802e6f <insert_sorted_allocList+0x76>
	{
	//	blockToInsert=AllocMemBlocksList.lh_first;
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  802e0d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e11:	75 14                	jne    802e27 <insert_sorted_allocList+0x2e>
  802e13:	83 ec 04             	sub    $0x4,%esp
  802e16:	68 30 47 80 00       	push   $0x804730
  802e1b:	6a 69                	push   $0x69
  802e1d:	68 53 47 80 00       	push   $0x804753
  802e22:	e8 41 e1 ff ff       	call   800f68 <_panic>
  802e27:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e30:	89 10                	mov    %edx,(%eax)
  802e32:	8b 45 08             	mov    0x8(%ebp),%eax
  802e35:	8b 00                	mov    (%eax),%eax
  802e37:	85 c0                	test   %eax,%eax
  802e39:	74 0d                	je     802e48 <insert_sorted_allocList+0x4f>
  802e3b:	a1 40 50 80 00       	mov    0x805040,%eax
  802e40:	8b 55 08             	mov    0x8(%ebp),%edx
  802e43:	89 50 04             	mov    %edx,0x4(%eax)
  802e46:	eb 08                	jmp    802e50 <insert_sorted_allocList+0x57>
  802e48:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4b:	a3 44 50 80 00       	mov    %eax,0x805044
  802e50:	8b 45 08             	mov    0x8(%ebp),%eax
  802e53:	a3 40 50 80 00       	mov    %eax,0x805040
  802e58:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e62:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802e67:	40                   	inc    %eax
  802e68:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802e6d:	eb 72                	jmp    802ee1 <insert_sorted_allocList+0xe8>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
  802e6f:	a1 40 50 80 00       	mov    0x805040,%eax
  802e74:	8b 50 08             	mov    0x8(%eax),%edx
  802e77:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7a:	8b 40 08             	mov    0x8(%eax),%eax
  802e7d:	39 c2                	cmp    %eax,%edx
  802e7f:	76 60                	jbe    802ee1 <insert_sorted_allocList+0xe8>
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  802e81:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e85:	75 14                	jne    802e9b <insert_sorted_allocList+0xa2>
  802e87:	83 ec 04             	sub    $0x4,%esp
  802e8a:	68 30 47 80 00       	push   $0x804730
  802e8f:	6a 6d                	push   $0x6d
  802e91:	68 53 47 80 00       	push   $0x804753
  802e96:	e8 cd e0 ff ff       	call   800f68 <_panic>
  802e9b:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea4:	89 10                	mov    %edx,(%eax)
  802ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea9:	8b 00                	mov    (%eax),%eax
  802eab:	85 c0                	test   %eax,%eax
  802ead:	74 0d                	je     802ebc <insert_sorted_allocList+0xc3>
  802eaf:	a1 40 50 80 00       	mov    0x805040,%eax
  802eb4:	8b 55 08             	mov    0x8(%ebp),%edx
  802eb7:	89 50 04             	mov    %edx,0x4(%eax)
  802eba:	eb 08                	jmp    802ec4 <insert_sorted_allocList+0xcb>
  802ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebf:	a3 44 50 80 00       	mov    %eax,0x805044
  802ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec7:	a3 40 50 80 00       	mov    %eax,0x805040
  802ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ed6:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802edb:	40                   	inc    %eax
  802edc:	a3 4c 50 80 00       	mov    %eax,0x80504c
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  802ee1:	a1 40 50 80 00       	mov    0x805040,%eax
  802ee6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ee9:	e9 b9 01 00 00       	jmp    8030a7 <insert_sorted_allocList+0x2ae>
	{


		if ((blockToInsert->sva>AllocMemBlocksList.lh_first->sva)&&blockToInsert->sva<element->sva)
  802eee:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef1:	8b 50 08             	mov    0x8(%eax),%edx
  802ef4:	a1 40 50 80 00       	mov    0x805040,%eax
  802ef9:	8b 40 08             	mov    0x8(%eax),%eax
  802efc:	39 c2                	cmp    %eax,%edx
  802efe:	76 7c                	jbe    802f7c <insert_sorted_allocList+0x183>
  802f00:	8b 45 08             	mov    0x8(%ebp),%eax
  802f03:	8b 50 08             	mov    0x8(%eax),%edx
  802f06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f09:	8b 40 08             	mov    0x8(%eax),%eax
  802f0c:	39 c2                	cmp    %eax,%edx
  802f0e:	73 6c                	jae    802f7c <insert_sorted_allocList+0x183>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,element,blockToInsert);
  802f10:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f14:	74 06                	je     802f1c <insert_sorted_allocList+0x123>
  802f16:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f1a:	75 14                	jne    802f30 <insert_sorted_allocList+0x137>
  802f1c:	83 ec 04             	sub    $0x4,%esp
  802f1f:	68 6c 47 80 00       	push   $0x80476c
  802f24:	6a 75                	push   $0x75
  802f26:	68 53 47 80 00       	push   $0x804753
  802f2b:	e8 38 e0 ff ff       	call   800f68 <_panic>
  802f30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f33:	8b 50 04             	mov    0x4(%eax),%edx
  802f36:	8b 45 08             	mov    0x8(%ebp),%eax
  802f39:	89 50 04             	mov    %edx,0x4(%eax)
  802f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f42:	89 10                	mov    %edx,(%eax)
  802f44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f47:	8b 40 04             	mov    0x4(%eax),%eax
  802f4a:	85 c0                	test   %eax,%eax
  802f4c:	74 0d                	je     802f5b <insert_sorted_allocList+0x162>
  802f4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f51:	8b 40 04             	mov    0x4(%eax),%eax
  802f54:	8b 55 08             	mov    0x8(%ebp),%edx
  802f57:	89 10                	mov    %edx,(%eax)
  802f59:	eb 08                	jmp    802f63 <insert_sorted_allocList+0x16a>
  802f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5e:	a3 40 50 80 00       	mov    %eax,0x805040
  802f63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f66:	8b 55 08             	mov    0x8(%ebp),%edx
  802f69:	89 50 04             	mov    %edx,0x4(%eax)
  802f6c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802f71:	40                   	inc    %eax
  802f72:	a3 4c 50 80 00       	mov    %eax,0x80504c

		break;}
  802f77:	e9 59 01 00 00       	jmp    8030d5 <insert_sorted_allocList+0x2dc>

	else if ((blockToInsert->sva>element->sva)&&(blockToInsert->sva<AllocMemBlocksList.lh_last->sva)&&blockToInsert->sva<LIST_NEXT(element)->sva)
  802f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7f:	8b 50 08             	mov    0x8(%eax),%edx
  802f82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f85:	8b 40 08             	mov    0x8(%eax),%eax
  802f88:	39 c2                	cmp    %eax,%edx
  802f8a:	0f 86 98 00 00 00    	jbe    803028 <insert_sorted_allocList+0x22f>
  802f90:	8b 45 08             	mov    0x8(%ebp),%eax
  802f93:	8b 50 08             	mov    0x8(%eax),%edx
  802f96:	a1 44 50 80 00       	mov    0x805044,%eax
  802f9b:	8b 40 08             	mov    0x8(%eax),%eax
  802f9e:	39 c2                	cmp    %eax,%edx
  802fa0:	0f 83 82 00 00 00    	jae    803028 <insert_sorted_allocList+0x22f>
  802fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa9:	8b 50 08             	mov    0x8(%eax),%edx
  802fac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802faf:	8b 00                	mov    (%eax),%eax
  802fb1:	8b 40 08             	mov    0x8(%eax),%eax
  802fb4:	39 c2                	cmp    %eax,%edx
  802fb6:	73 70                	jae    803028 <insert_sorted_allocList+0x22f>
	{

	LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  802fb8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fbc:	74 06                	je     802fc4 <insert_sorted_allocList+0x1cb>
  802fbe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fc2:	75 14                	jne    802fd8 <insert_sorted_allocList+0x1df>
  802fc4:	83 ec 04             	sub    $0x4,%esp
  802fc7:	68 a4 47 80 00       	push   $0x8047a4
  802fcc:	6a 7c                	push   $0x7c
  802fce:	68 53 47 80 00       	push   $0x804753
  802fd3:	e8 90 df ff ff       	call   800f68 <_panic>
  802fd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fdb:	8b 10                	mov    (%eax),%edx
  802fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe0:	89 10                	mov    %edx,(%eax)
  802fe2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe5:	8b 00                	mov    (%eax),%eax
  802fe7:	85 c0                	test   %eax,%eax
  802fe9:	74 0b                	je     802ff6 <insert_sorted_allocList+0x1fd>
  802feb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fee:	8b 00                	mov    (%eax),%eax
  802ff0:	8b 55 08             	mov    0x8(%ebp),%edx
  802ff3:	89 50 04             	mov    %edx,0x4(%eax)
  802ff6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff9:	8b 55 08             	mov    0x8(%ebp),%edx
  802ffc:	89 10                	mov    %edx,(%eax)
  802ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  803001:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803004:	89 50 04             	mov    %edx,0x4(%eax)
  803007:	8b 45 08             	mov    0x8(%ebp),%eax
  80300a:	8b 00                	mov    (%eax),%eax
  80300c:	85 c0                	test   %eax,%eax
  80300e:	75 08                	jne    803018 <insert_sorted_allocList+0x21f>
  803010:	8b 45 08             	mov    0x8(%ebp),%eax
  803013:	a3 44 50 80 00       	mov    %eax,0x805044
  803018:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80301d:	40                   	inc    %eax
  80301e:	a3 4c 50 80 00       	mov    %eax,0x80504c
		break;
  803023:	e9 ad 00 00 00       	jmp    8030d5 <insert_sorted_allocList+0x2dc>
	}else if (blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  803028:	8b 45 08             	mov    0x8(%ebp),%eax
  80302b:	8b 50 08             	mov    0x8(%eax),%edx
  80302e:	a1 44 50 80 00       	mov    0x805044,%eax
  803033:	8b 40 08             	mov    0x8(%eax),%eax
  803036:	39 c2                	cmp    %eax,%edx
  803038:	76 65                	jbe    80309f <insert_sorted_allocList+0x2a6>
	{
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
  80303a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80303e:	75 17                	jne    803057 <insert_sorted_allocList+0x25e>
  803040:	83 ec 04             	sub    $0x4,%esp
  803043:	68 d8 47 80 00       	push   $0x8047d8
  803048:	68 80 00 00 00       	push   $0x80
  80304d:	68 53 47 80 00       	push   $0x804753
  803052:	e8 11 df ff ff       	call   800f68 <_panic>
  803057:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80305d:	8b 45 08             	mov    0x8(%ebp),%eax
  803060:	89 50 04             	mov    %edx,0x4(%eax)
  803063:	8b 45 08             	mov    0x8(%ebp),%eax
  803066:	8b 40 04             	mov    0x4(%eax),%eax
  803069:	85 c0                	test   %eax,%eax
  80306b:	74 0c                	je     803079 <insert_sorted_allocList+0x280>
  80306d:	a1 44 50 80 00       	mov    0x805044,%eax
  803072:	8b 55 08             	mov    0x8(%ebp),%edx
  803075:	89 10                	mov    %edx,(%eax)
  803077:	eb 08                	jmp    803081 <insert_sorted_allocList+0x288>
  803079:	8b 45 08             	mov    0x8(%ebp),%eax
  80307c:	a3 40 50 80 00       	mov    %eax,0x805040
  803081:	8b 45 08             	mov    0x8(%ebp),%eax
  803084:	a3 44 50 80 00       	mov    %eax,0x805044
  803089:	8b 45 08             	mov    0x8(%ebp),%eax
  80308c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803092:	a1 4c 50 80 00       	mov    0x80504c,%eax
  803097:	40                   	inc    %eax
  803098:	a3 4c 50 80 00       	mov    %eax,0x80504c
		break;
  80309d:	eb 36                	jmp    8030d5 <insert_sorted_allocList+0x2dc>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  80309f:	a1 48 50 80 00       	mov    0x805048,%eax
  8030a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030ab:	74 07                	je     8030b4 <insert_sorted_allocList+0x2bb>
  8030ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b0:	8b 00                	mov    (%eax),%eax
  8030b2:	eb 05                	jmp    8030b9 <insert_sorted_allocList+0x2c0>
  8030b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8030b9:	a3 48 50 80 00       	mov    %eax,0x805048
  8030be:	a1 48 50 80 00       	mov    0x805048,%eax
  8030c3:	85 c0                	test   %eax,%eax
  8030c5:	0f 85 23 fe ff ff    	jne    802eee <insert_sorted_allocList+0xf5>
  8030cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030cf:	0f 85 19 fe ff ff    	jne    802eee <insert_sorted_allocList+0xf5>
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
		break;

	}
	}
}
  8030d5:	90                   	nop
  8030d6:	c9                   	leave  
  8030d7:	c3                   	ret    

008030d8 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8030d8:	55                   	push   %ebp
  8030d9:	89 e5                	mov    %esp,%ebp
  8030db:	83 ec 18             	sub    $0x18,%esp
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  8030de:	a1 38 51 80 00       	mov    0x805138,%eax
  8030e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030e6:	e9 7c 01 00 00       	jmp    803267 <alloc_block_FF+0x18f>
		{
			// case 2
				if(element->size == size)
  8030eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8030f1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030f4:	0f 85 90 00 00 00    	jne    80318a <alloc_block_FF+0xb2>
				{
					tmp_block=element;
  8030fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,element);
  803100:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803104:	75 17                	jne    80311d <alloc_block_FF+0x45>
  803106:	83 ec 04             	sub    $0x4,%esp
  803109:	68 fb 47 80 00       	push   $0x8047fb
  80310e:	68 ba 00 00 00       	push   $0xba
  803113:	68 53 47 80 00       	push   $0x804753
  803118:	e8 4b de ff ff       	call   800f68 <_panic>
  80311d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803120:	8b 00                	mov    (%eax),%eax
  803122:	85 c0                	test   %eax,%eax
  803124:	74 10                	je     803136 <alloc_block_FF+0x5e>
  803126:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803129:	8b 00                	mov    (%eax),%eax
  80312b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80312e:	8b 52 04             	mov    0x4(%edx),%edx
  803131:	89 50 04             	mov    %edx,0x4(%eax)
  803134:	eb 0b                	jmp    803141 <alloc_block_FF+0x69>
  803136:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803139:	8b 40 04             	mov    0x4(%eax),%eax
  80313c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803141:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803144:	8b 40 04             	mov    0x4(%eax),%eax
  803147:	85 c0                	test   %eax,%eax
  803149:	74 0f                	je     80315a <alloc_block_FF+0x82>
  80314b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314e:	8b 40 04             	mov    0x4(%eax),%eax
  803151:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803154:	8b 12                	mov    (%edx),%edx
  803156:	89 10                	mov    %edx,(%eax)
  803158:	eb 0a                	jmp    803164 <alloc_block_FF+0x8c>
  80315a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80315d:	8b 00                	mov    (%eax),%eax
  80315f:	a3 38 51 80 00       	mov    %eax,0x805138
  803164:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803167:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80316d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803170:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803177:	a1 44 51 80 00       	mov    0x805144,%eax
  80317c:	48                   	dec    %eax
  80317d:	a3 44 51 80 00       	mov    %eax,0x805144
					return tmp_block;
  803182:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803185:	e9 10 01 00 00       	jmp    80329a <alloc_block_FF+0x1c2>
				}
				 // case 3
				else if(element->size > size)
  80318a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80318d:	8b 40 0c             	mov    0xc(%eax),%eax
  803190:	3b 45 08             	cmp    0x8(%ebp),%eax
  803193:	0f 86 c6 00 00 00    	jbe    80325f <alloc_block_FF+0x187>
				{
					// the new block are created
					tmp_block = AvailableMemBlocksList.lh_first ;
  803199:	a1 48 51 80 00       	mov    0x805148,%eax
  80319e:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  8031a1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031a5:	75 17                	jne    8031be <alloc_block_FF+0xe6>
  8031a7:	83 ec 04             	sub    $0x4,%esp
  8031aa:	68 fb 47 80 00       	push   $0x8047fb
  8031af:	68 c2 00 00 00       	push   $0xc2
  8031b4:	68 53 47 80 00       	push   $0x804753
  8031b9:	e8 aa dd ff ff       	call   800f68 <_panic>
  8031be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031c1:	8b 00                	mov    (%eax),%eax
  8031c3:	85 c0                	test   %eax,%eax
  8031c5:	74 10                	je     8031d7 <alloc_block_FF+0xff>
  8031c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ca:	8b 00                	mov    (%eax),%eax
  8031cc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031cf:	8b 52 04             	mov    0x4(%edx),%edx
  8031d2:	89 50 04             	mov    %edx,0x4(%eax)
  8031d5:	eb 0b                	jmp    8031e2 <alloc_block_FF+0x10a>
  8031d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031da:	8b 40 04             	mov    0x4(%eax),%eax
  8031dd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031e5:	8b 40 04             	mov    0x4(%eax),%eax
  8031e8:	85 c0                	test   %eax,%eax
  8031ea:	74 0f                	je     8031fb <alloc_block_FF+0x123>
  8031ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ef:	8b 40 04             	mov    0x4(%eax),%eax
  8031f2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031f5:	8b 12                	mov    (%edx),%edx
  8031f7:	89 10                	mov    %edx,(%eax)
  8031f9:	eb 0a                	jmp    803205 <alloc_block_FF+0x12d>
  8031fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031fe:	8b 00                	mov    (%eax),%eax
  803200:	a3 48 51 80 00       	mov    %eax,0x805148
  803205:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803208:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80320e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803211:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803218:	a1 54 51 80 00       	mov    0x805154,%eax
  80321d:	48                   	dec    %eax
  80321e:	a3 54 51 80 00       	mov    %eax,0x805154
					tmp_block->sva=element->sva;
  803223:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803226:	8b 50 08             	mov    0x8(%eax),%edx
  803229:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80322c:	89 50 08             	mov    %edx,0x8(%eax)
					tmp_block->size=size;
  80322f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803232:	8b 55 08             	mov    0x8(%ebp),%edx
  803235:	89 50 0c             	mov    %edx,0xc(%eax)
					//update block with remaining space
					element->size-=size;
  803238:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80323b:	8b 40 0c             	mov    0xc(%eax),%eax
  80323e:	2b 45 08             	sub    0x8(%ebp),%eax
  803241:	89 c2                	mov    %eax,%edx
  803243:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803246:	89 50 0c             	mov    %edx,0xc(%eax)
					element->sva = element->sva + size;
  803249:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80324c:	8b 50 08             	mov    0x8(%eax),%edx
  80324f:	8b 45 08             	mov    0x8(%ebp),%eax
  803252:	01 c2                	add    %eax,%edx
  803254:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803257:	89 50 08             	mov    %edx,0x8(%eax)
					// return back the new block
					return tmp_block ;
  80325a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80325d:	eb 3b                	jmp    80329a <alloc_block_FF+0x1c2>
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  80325f:	a1 40 51 80 00       	mov    0x805140,%eax
  803264:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803267:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80326b:	74 07                	je     803274 <alloc_block_FF+0x19c>
  80326d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803270:	8b 00                	mov    (%eax),%eax
  803272:	eb 05                	jmp    803279 <alloc_block_FF+0x1a1>
  803274:	b8 00 00 00 00       	mov    $0x0,%eax
  803279:	a3 40 51 80 00       	mov    %eax,0x805140
  80327e:	a1 40 51 80 00       	mov    0x805140,%eax
  803283:	85 c0                	test   %eax,%eax
  803285:	0f 85 60 fe ff ff    	jne    8030eb <alloc_block_FF+0x13>
  80328b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80328f:	0f 85 56 fe ff ff    	jne    8030eb <alloc_block_FF+0x13>
					// return back the new block
					return tmp_block ;
				}
		}
		// case 1
	  return NULL ;}
  803295:	b8 00 00 00 00       	mov    $0x0,%eax
  80329a:	c9                   	leave  
  80329b:	c3                   	ret    

0080329c <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================

struct MemBlock *alloc_block_BF(uint32 size)
{
  80329c:	55                   	push   %ebp
  80329d:	89 e5                	mov    %esp,%ebp
  80329f:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
  8032a2:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		LIST_FOREACH(element, &(FreeMemBlocksList))
  8032a9:	a1 38 51 80 00       	mov    0x805138,%eax
  8032ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032b1:	eb 3a                	jmp    8032ed <alloc_block_BF+0x51>
		{
			if(element->size >= size)
  8032b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8032b9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032bc:	72 27                	jb     8032e5 <alloc_block_BF+0x49>
			{
				if(best_size==-1)
  8032be:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8032c2:	75 0b                	jne    8032cf <alloc_block_BF+0x33>
					best_size= element->size;
  8032c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8032ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8032cd:	eb 16                	jmp    8032e5 <alloc_block_BF+0x49>
				else if(best_size >= element->size)
  8032cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d2:	8b 50 0c             	mov    0xc(%eax),%edx
  8032d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032d8:	39 c2                	cmp    %eax,%edx
  8032da:	77 09                	ja     8032e5 <alloc_block_BF+0x49>
					best_size=element->size;
  8032dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032df:	8b 40 0c             	mov    0xc(%eax),%eax
  8032e2:	89 45 f0             	mov    %eax,-0x10(%ebp)

struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  8032e5:	a1 40 51 80 00       	mov    0x805140,%eax
  8032ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032f1:	74 07                	je     8032fa <alloc_block_BF+0x5e>
  8032f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f6:	8b 00                	mov    (%eax),%eax
  8032f8:	eb 05                	jmp    8032ff <alloc_block_BF+0x63>
  8032fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8032ff:	a3 40 51 80 00       	mov    %eax,0x805140
  803304:	a1 40 51 80 00       	mov    0x805140,%eax
  803309:	85 c0                	test   %eax,%eax
  80330b:	75 a6                	jne    8032b3 <alloc_block_BF+0x17>
  80330d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803311:	75 a0                	jne    8032b3 <alloc_block_BF+0x17>
					best_size= element->size;
				else if(best_size >= element->size)
					best_size=element->size;
			}
		}
		if(best_size != -1)
  803313:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  803317:	0f 84 d3 01 00 00    	je     8034f0 <alloc_block_BF+0x254>
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  80331d:	a1 38 51 80 00       	mov    0x805138,%eax
  803322:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803325:	e9 98 01 00 00       	jmp    8034c2 <alloc_block_BF+0x226>
			{
			 if((best_size > size) && (best_size == element->size))
  80332a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80332d:	3b 45 08             	cmp    0x8(%ebp),%eax
  803330:	0f 86 da 00 00 00    	jbe    803410 <alloc_block_BF+0x174>
  803336:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803339:	8b 50 0c             	mov    0xc(%eax),%edx
  80333c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80333f:	39 c2                	cmp    %eax,%edx
  803341:	0f 85 c9 00 00 00    	jne    803410 <alloc_block_BF+0x174>
			  {
				// the new block are created
			    tmp_block = AvailableMemBlocksList.lh_first ;
  803347:	a1 48 51 80 00       	mov    0x805148,%eax
  80334c:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  80334f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803353:	75 17                	jne    80336c <alloc_block_BF+0xd0>
  803355:	83 ec 04             	sub    $0x4,%esp
  803358:	68 fb 47 80 00       	push   $0x8047fb
  80335d:	68 ea 00 00 00       	push   $0xea
  803362:	68 53 47 80 00       	push   $0x804753
  803367:	e8 fc db ff ff       	call   800f68 <_panic>
  80336c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80336f:	8b 00                	mov    (%eax),%eax
  803371:	85 c0                	test   %eax,%eax
  803373:	74 10                	je     803385 <alloc_block_BF+0xe9>
  803375:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803378:	8b 00                	mov    (%eax),%eax
  80337a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80337d:	8b 52 04             	mov    0x4(%edx),%edx
  803380:	89 50 04             	mov    %edx,0x4(%eax)
  803383:	eb 0b                	jmp    803390 <alloc_block_BF+0xf4>
  803385:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803388:	8b 40 04             	mov    0x4(%eax),%eax
  80338b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803390:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803393:	8b 40 04             	mov    0x4(%eax),%eax
  803396:	85 c0                	test   %eax,%eax
  803398:	74 0f                	je     8033a9 <alloc_block_BF+0x10d>
  80339a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80339d:	8b 40 04             	mov    0x4(%eax),%eax
  8033a0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8033a3:	8b 12                	mov    (%edx),%edx
  8033a5:	89 10                	mov    %edx,(%eax)
  8033a7:	eb 0a                	jmp    8033b3 <alloc_block_BF+0x117>
  8033a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033ac:	8b 00                	mov    (%eax),%eax
  8033ae:	a3 48 51 80 00       	mov    %eax,0x805148
  8033b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033b6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033bf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033c6:	a1 54 51 80 00       	mov    0x805154,%eax
  8033cb:	48                   	dec    %eax
  8033cc:	a3 54 51 80 00       	mov    %eax,0x805154
				tmp_block->sva=element->sva;
  8033d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d4:	8b 50 08             	mov    0x8(%eax),%edx
  8033d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033da:	89 50 08             	mov    %edx,0x8(%eax)
				tmp_block->size=size;
  8033dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8033e3:	89 50 0c             	mov    %edx,0xc(%eax)
				//update block with remaining space
				element->size-=size;
  8033e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8033ec:	2b 45 08             	sub    0x8(%ebp),%eax
  8033ef:	89 c2                	mov    %eax,%edx
  8033f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f4:	89 50 0c             	mov    %edx,0xc(%eax)
				element->sva = element->sva + size;
  8033f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033fa:	8b 50 08             	mov    0x8(%eax),%edx
  8033fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803400:	01 c2                	add    %eax,%edx
  803402:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803405:	89 50 08             	mov    %edx,0x8(%eax)
				// return back the new block
				return tmp_block ;
  803408:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80340b:	e9 e5 00 00 00       	jmp    8034f5 <alloc_block_BF+0x259>

			  }
			else if((element->size == best_size)&&(best_size == size))
  803410:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803413:	8b 50 0c             	mov    0xc(%eax),%edx
  803416:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803419:	39 c2                	cmp    %eax,%edx
  80341b:	0f 85 99 00 00 00    	jne    8034ba <alloc_block_BF+0x21e>
  803421:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803424:	3b 45 08             	cmp    0x8(%ebp),%eax
  803427:	0f 85 8d 00 00 00    	jne    8034ba <alloc_block_BF+0x21e>
			  {
				tmp_block=element;
  80342d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803430:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&FreeMemBlocksList,element);
  803433:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803437:	75 17                	jne    803450 <alloc_block_BF+0x1b4>
  803439:	83 ec 04             	sub    $0x4,%esp
  80343c:	68 fb 47 80 00       	push   $0x8047fb
  803441:	68 f7 00 00 00       	push   $0xf7
  803446:	68 53 47 80 00       	push   $0x804753
  80344b:	e8 18 db ff ff       	call   800f68 <_panic>
  803450:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803453:	8b 00                	mov    (%eax),%eax
  803455:	85 c0                	test   %eax,%eax
  803457:	74 10                	je     803469 <alloc_block_BF+0x1cd>
  803459:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80345c:	8b 00                	mov    (%eax),%eax
  80345e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803461:	8b 52 04             	mov    0x4(%edx),%edx
  803464:	89 50 04             	mov    %edx,0x4(%eax)
  803467:	eb 0b                	jmp    803474 <alloc_block_BF+0x1d8>
  803469:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80346c:	8b 40 04             	mov    0x4(%eax),%eax
  80346f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803474:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803477:	8b 40 04             	mov    0x4(%eax),%eax
  80347a:	85 c0                	test   %eax,%eax
  80347c:	74 0f                	je     80348d <alloc_block_BF+0x1f1>
  80347e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803481:	8b 40 04             	mov    0x4(%eax),%eax
  803484:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803487:	8b 12                	mov    (%edx),%edx
  803489:	89 10                	mov    %edx,(%eax)
  80348b:	eb 0a                	jmp    803497 <alloc_block_BF+0x1fb>
  80348d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803490:	8b 00                	mov    (%eax),%eax
  803492:	a3 38 51 80 00       	mov    %eax,0x805138
  803497:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80349a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034aa:	a1 44 51 80 00       	mov    0x805144,%eax
  8034af:	48                   	dec    %eax
  8034b0:	a3 44 51 80 00       	mov    %eax,0x805144
				return tmp_block;
  8034b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034b8:	eb 3b                	jmp    8034f5 <alloc_block_BF+0x259>
					best_size=element->size;
			}
		}
		if(best_size != -1)
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  8034ba:	a1 40 51 80 00       	mov    0x805140,%eax
  8034bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034c6:	74 07                	je     8034cf <alloc_block_BF+0x233>
  8034c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034cb:	8b 00                	mov    (%eax),%eax
  8034cd:	eb 05                	jmp    8034d4 <alloc_block_BF+0x238>
  8034cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8034d4:	a3 40 51 80 00       	mov    %eax,0x805140
  8034d9:	a1 40 51 80 00       	mov    0x805140,%eax
  8034de:	85 c0                	test   %eax,%eax
  8034e0:	0f 85 44 fe ff ff    	jne    80332a <alloc_block_BF+0x8e>
  8034e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034ea:	0f 85 3a fe ff ff    	jne    80332a <alloc_block_BF+0x8e>
				LIST_REMOVE(&FreeMemBlocksList,element);
				return tmp_block;
			 }
			}
		}
		return NULL ;}
  8034f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8034f5:	c9                   	leave  
  8034f6:	c3                   	ret    

008034f7 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8034f7:	55                   	push   %ebp
  8034f8:	89 e5                	mov    %esp,%ebp
  8034fa:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  8034fd:	83 ec 04             	sub    $0x4,%esp
  803500:	68 1c 48 80 00       	push   $0x80481c
  803505:	68 04 01 00 00       	push   $0x104
  80350a:	68 53 47 80 00       	push   $0x804753
  80350f:	e8 54 da ff ff       	call   800f68 <_panic>

00803514 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{struct MemBlock * blk_itr;
  803514:	55                   	push   %ebp
  803515:	89 e5                	mov    %esp,%ebp
  803517:	83 ec 18             	sub    $0x18,%esp
struct MemBlock * next;
struct MemBlock * first = LIST_FIRST(&(FreeMemBlocksList));
  80351a:	a1 38 51 80 00       	mov    0x805138,%eax
  80351f:	89 45 f0             	mov    %eax,-0x10(%ebp)
struct MemBlock * last = LIST_LAST(&(FreeMemBlocksList));
  803522:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803527:	89 45 ec             	mov    %eax,-0x14(%ebp)

if(LIST_EMPTY(&(FreeMemBlocksList)))
  80352a:	a1 38 51 80 00       	mov    0x805138,%eax
  80352f:	85 c0                	test   %eax,%eax
  803531:	75 68                	jne    80359b <insert_sorted_with_merge_freeList+0x87>
			{

				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  803533:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803537:	75 17                	jne    803550 <insert_sorted_with_merge_freeList+0x3c>
  803539:	83 ec 04             	sub    $0x4,%esp
  80353c:	68 30 47 80 00       	push   $0x804730
  803541:	68 14 01 00 00       	push   $0x114
  803546:	68 53 47 80 00       	push   $0x804753
  80354b:	e8 18 da ff ff       	call   800f68 <_panic>
  803550:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803556:	8b 45 08             	mov    0x8(%ebp),%eax
  803559:	89 10                	mov    %edx,(%eax)
  80355b:	8b 45 08             	mov    0x8(%ebp),%eax
  80355e:	8b 00                	mov    (%eax),%eax
  803560:	85 c0                	test   %eax,%eax
  803562:	74 0d                	je     803571 <insert_sorted_with_merge_freeList+0x5d>
  803564:	a1 38 51 80 00       	mov    0x805138,%eax
  803569:	8b 55 08             	mov    0x8(%ebp),%edx
  80356c:	89 50 04             	mov    %edx,0x4(%eax)
  80356f:	eb 08                	jmp    803579 <insert_sorted_with_merge_freeList+0x65>
  803571:	8b 45 08             	mov    0x8(%ebp),%eax
  803574:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803579:	8b 45 08             	mov    0x8(%ebp),%eax
  80357c:	a3 38 51 80 00       	mov    %eax,0x805138
  803581:	8b 45 08             	mov    0x8(%ebp),%eax
  803584:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80358b:	a1 44 51 80 00       	mov    0x805144,%eax
  803590:	40                   	inc    %eax
  803591:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  803596:	e9 d2 06 00 00       	jmp    803c6d <insert_sorted_with_merge_freeList+0x759>
				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);

			}
else
{
	if( blockToInsert->sva  < first->sva )
  80359b:	8b 45 08             	mov    0x8(%ebp),%eax
  80359e:	8b 50 08             	mov    0x8(%eax),%edx
  8035a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035a4:	8b 40 08             	mov    0x8(%eax),%eax
  8035a7:	39 c2                	cmp    %eax,%edx
  8035a9:	0f 83 22 01 00 00    	jae    8036d1 <insert_sorted_with_merge_freeList+0x1bd>
	{
                if( blockToInsert->sva + blockToInsert->size == first->sva)
  8035af:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b2:	8b 50 08             	mov    0x8(%eax),%edx
  8035b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b8:	8b 40 0c             	mov    0xc(%eax),%eax
  8035bb:	01 c2                	add    %eax,%edx
  8035bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035c0:	8b 40 08             	mov    0x8(%eax),%eax
  8035c3:	39 c2                	cmp    %eax,%edx
  8035c5:	0f 85 9e 00 00 00    	jne    803669 <insert_sorted_with_merge_freeList+0x155>
                {

                	first->sva = blockToInsert->sva;
  8035cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ce:	8b 50 08             	mov    0x8(%eax),%edx
  8035d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035d4:	89 50 08             	mov    %edx,0x8(%eax)
                	first->size = first->size + blockToInsert->size;
  8035d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035da:	8b 50 0c             	mov    0xc(%eax),%edx
  8035dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8035e3:	01 c2                	add    %eax,%edx
  8035e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035e8:	89 50 0c             	mov    %edx,0xc(%eax)
                	blockToInsert->size = blockToInsert->sva = 0;
  8035eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ee:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8035f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f8:	8b 50 08             	mov    0x8(%eax),%edx
  8035fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8035fe:	89 50 0c             	mov    %edx,0xc(%eax)
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  803601:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803605:	75 17                	jne    80361e <insert_sorted_with_merge_freeList+0x10a>
  803607:	83 ec 04             	sub    $0x4,%esp
  80360a:	68 30 47 80 00       	push   $0x804730
  80360f:	68 21 01 00 00       	push   $0x121
  803614:	68 53 47 80 00       	push   $0x804753
  803619:	e8 4a d9 ff ff       	call   800f68 <_panic>
  80361e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803624:	8b 45 08             	mov    0x8(%ebp),%eax
  803627:	89 10                	mov    %edx,(%eax)
  803629:	8b 45 08             	mov    0x8(%ebp),%eax
  80362c:	8b 00                	mov    (%eax),%eax
  80362e:	85 c0                	test   %eax,%eax
  803630:	74 0d                	je     80363f <insert_sorted_with_merge_freeList+0x12b>
  803632:	a1 48 51 80 00       	mov    0x805148,%eax
  803637:	8b 55 08             	mov    0x8(%ebp),%edx
  80363a:	89 50 04             	mov    %edx,0x4(%eax)
  80363d:	eb 08                	jmp    803647 <insert_sorted_with_merge_freeList+0x133>
  80363f:	8b 45 08             	mov    0x8(%ebp),%eax
  803642:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803647:	8b 45 08             	mov    0x8(%ebp),%eax
  80364a:	a3 48 51 80 00       	mov    %eax,0x805148
  80364f:	8b 45 08             	mov    0x8(%ebp),%eax
  803652:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803659:	a1 54 51 80 00       	mov    0x805154,%eax
  80365e:	40                   	inc    %eax
  80365f:	a3 54 51 80 00       	mov    %eax,0x805154
						}
				}
        }

}
}
  803664:	e9 04 06 00 00       	jmp    803c6d <insert_sorted_with_merge_freeList+0x759>
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
                }

                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  803669:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80366d:	75 17                	jne    803686 <insert_sorted_with_merge_freeList+0x172>
  80366f:	83 ec 04             	sub    $0x4,%esp
  803672:	68 30 47 80 00       	push   $0x804730
  803677:	68 26 01 00 00       	push   $0x126
  80367c:	68 53 47 80 00       	push   $0x804753
  803681:	e8 e2 d8 ff ff       	call   800f68 <_panic>
  803686:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80368c:	8b 45 08             	mov    0x8(%ebp),%eax
  80368f:	89 10                	mov    %edx,(%eax)
  803691:	8b 45 08             	mov    0x8(%ebp),%eax
  803694:	8b 00                	mov    (%eax),%eax
  803696:	85 c0                	test   %eax,%eax
  803698:	74 0d                	je     8036a7 <insert_sorted_with_merge_freeList+0x193>
  80369a:	a1 38 51 80 00       	mov    0x805138,%eax
  80369f:	8b 55 08             	mov    0x8(%ebp),%edx
  8036a2:	89 50 04             	mov    %edx,0x4(%eax)
  8036a5:	eb 08                	jmp    8036af <insert_sorted_with_merge_freeList+0x19b>
  8036a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8036aa:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8036af:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b2:	a3 38 51 80 00       	mov    %eax,0x805138
  8036b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036c1:	a1 44 51 80 00       	mov    0x805144,%eax
  8036c6:	40                   	inc    %eax
  8036c7:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  8036cc:	e9 9c 05 00 00       	jmp    803c6d <insert_sorted_with_merge_freeList+0x759>
                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
                }
	}
    else if(blockToInsert->sva > last->sva)
  8036d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d4:	8b 50 08             	mov    0x8(%eax),%edx
  8036d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036da:	8b 40 08             	mov    0x8(%eax),%eax
  8036dd:	39 c2                	cmp    %eax,%edx
  8036df:	0f 86 16 01 00 00    	jbe    8037fb <insert_sorted_with_merge_freeList+0x2e7>
 	{

				if(last->sva + last->size == blockToInsert->sva)
  8036e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036e8:	8b 50 08             	mov    0x8(%eax),%edx
  8036eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8036f1:	01 c2                	add    %eax,%edx
  8036f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f6:	8b 40 08             	mov    0x8(%eax),%eax
  8036f9:	39 c2                	cmp    %eax,%edx
  8036fb:	0f 85 92 00 00 00    	jne    803793 <insert_sorted_with_merge_freeList+0x27f>
				{

					last->size = last->size + blockToInsert->size;
  803701:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803704:	8b 50 0c             	mov    0xc(%eax),%edx
  803707:	8b 45 08             	mov    0x8(%ebp),%eax
  80370a:	8b 40 0c             	mov    0xc(%eax),%eax
  80370d:	01 c2                	add    %eax,%edx
  80370f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803712:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->size = blockToInsert->sva = 0;
  803715:	8b 45 08             	mov    0x8(%ebp),%eax
  803718:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80371f:	8b 45 08             	mov    0x8(%ebp),%eax
  803722:	8b 50 08             	mov    0x8(%eax),%edx
  803725:	8b 45 08             	mov    0x8(%ebp),%eax
  803728:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  80372b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80372f:	75 17                	jne    803748 <insert_sorted_with_merge_freeList+0x234>
  803731:	83 ec 04             	sub    $0x4,%esp
  803734:	68 30 47 80 00       	push   $0x804730
  803739:	68 31 01 00 00       	push   $0x131
  80373e:	68 53 47 80 00       	push   $0x804753
  803743:	e8 20 d8 ff ff       	call   800f68 <_panic>
  803748:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80374e:	8b 45 08             	mov    0x8(%ebp),%eax
  803751:	89 10                	mov    %edx,(%eax)
  803753:	8b 45 08             	mov    0x8(%ebp),%eax
  803756:	8b 00                	mov    (%eax),%eax
  803758:	85 c0                	test   %eax,%eax
  80375a:	74 0d                	je     803769 <insert_sorted_with_merge_freeList+0x255>
  80375c:	a1 48 51 80 00       	mov    0x805148,%eax
  803761:	8b 55 08             	mov    0x8(%ebp),%edx
  803764:	89 50 04             	mov    %edx,0x4(%eax)
  803767:	eb 08                	jmp    803771 <insert_sorted_with_merge_freeList+0x25d>
  803769:	8b 45 08             	mov    0x8(%ebp),%eax
  80376c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803771:	8b 45 08             	mov    0x8(%ebp),%eax
  803774:	a3 48 51 80 00       	mov    %eax,0x805148
  803779:	8b 45 08             	mov    0x8(%ebp),%eax
  80377c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803783:	a1 54 51 80 00       	mov    0x805154,%eax
  803788:	40                   	inc    %eax
  803789:	a3 54 51 80 00       	mov    %eax,0x805154
						}
				}
        }

}
}
  80378e:	e9 da 04 00 00       	jmp    803c6d <insert_sorted_with_merge_freeList+0x759>

				}

				else
				{
					LIST_INSERT_TAIL(&(FreeMemBlocksList),  blockToInsert);
  803793:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803797:	75 17                	jne    8037b0 <insert_sorted_with_merge_freeList+0x29c>
  803799:	83 ec 04             	sub    $0x4,%esp
  80379c:	68 d8 47 80 00       	push   $0x8047d8
  8037a1:	68 37 01 00 00       	push   $0x137
  8037a6:	68 53 47 80 00       	push   $0x804753
  8037ab:	e8 b8 d7 ff ff       	call   800f68 <_panic>
  8037b0:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8037b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b9:	89 50 04             	mov    %edx,0x4(%eax)
  8037bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8037bf:	8b 40 04             	mov    0x4(%eax),%eax
  8037c2:	85 c0                	test   %eax,%eax
  8037c4:	74 0c                	je     8037d2 <insert_sorted_with_merge_freeList+0x2be>
  8037c6:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8037cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8037ce:	89 10                	mov    %edx,(%eax)
  8037d0:	eb 08                	jmp    8037da <insert_sorted_with_merge_freeList+0x2c6>
  8037d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8037d5:	a3 38 51 80 00       	mov    %eax,0x805138
  8037da:	8b 45 08             	mov    0x8(%ebp),%eax
  8037dd:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8037e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8037e5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037eb:	a1 44 51 80 00       	mov    0x805144,%eax
  8037f0:	40                   	inc    %eax
  8037f1:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  8037f6:	e9 72 04 00 00       	jmp    803c6d <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  8037fb:	a1 38 51 80 00       	mov    0x805138,%eax
  803800:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803803:	e9 35 04 00 00       	jmp    803c3d <insert_sorted_with_merge_freeList+0x729>
				{
				     next=LIST_NEXT(blk_itr);
  803808:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80380b:	8b 00                	mov    (%eax),%eax
  80380d:	89 45 e8             	mov    %eax,-0x18(%ebp)


					if( (blockToInsert->sva > blk_itr->sva) )
  803810:	8b 45 08             	mov    0x8(%ebp),%eax
  803813:	8b 50 08             	mov    0x8(%eax),%edx
  803816:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803819:	8b 40 08             	mov    0x8(%eax),%eax
  80381c:	39 c2                	cmp    %eax,%edx
  80381e:	0f 86 11 04 00 00    	jbe    803c35 <insert_sorted_with_merge_freeList+0x721>
						{
							if(((blk_itr->sva) + (blk_itr->size) < blockToInsert->sva && (blockToInsert->sva) + (blockToInsert->size) < next->sva))
  803824:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803827:	8b 50 08             	mov    0x8(%eax),%edx
  80382a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80382d:	8b 40 0c             	mov    0xc(%eax),%eax
  803830:	01 c2                	add    %eax,%edx
  803832:	8b 45 08             	mov    0x8(%ebp),%eax
  803835:	8b 40 08             	mov    0x8(%eax),%eax
  803838:	39 c2                	cmp    %eax,%edx
  80383a:	0f 83 8b 00 00 00    	jae    8038cb <insert_sorted_with_merge_freeList+0x3b7>
  803840:	8b 45 08             	mov    0x8(%ebp),%eax
  803843:	8b 50 08             	mov    0x8(%eax),%edx
  803846:	8b 45 08             	mov    0x8(%ebp),%eax
  803849:	8b 40 0c             	mov    0xc(%eax),%eax
  80384c:	01 c2                	add    %eax,%edx
  80384e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803851:	8b 40 08             	mov    0x8(%eax),%eax
  803854:	39 c2                	cmp    %eax,%edx
  803856:	73 73                	jae    8038cb <insert_sorted_with_merge_freeList+0x3b7>
							{
								LIST_INSERT_AFTER(&(FreeMemBlocksList), blk_itr, blockToInsert);
  803858:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80385c:	74 06                	je     803864 <insert_sorted_with_merge_freeList+0x350>
  80385e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803862:	75 17                	jne    80387b <insert_sorted_with_merge_freeList+0x367>
  803864:	83 ec 04             	sub    $0x4,%esp
  803867:	68 a4 47 80 00       	push   $0x8047a4
  80386c:	68 48 01 00 00       	push   $0x148
  803871:	68 53 47 80 00       	push   $0x804753
  803876:	e8 ed d6 ff ff       	call   800f68 <_panic>
  80387b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80387e:	8b 10                	mov    (%eax),%edx
  803880:	8b 45 08             	mov    0x8(%ebp),%eax
  803883:	89 10                	mov    %edx,(%eax)
  803885:	8b 45 08             	mov    0x8(%ebp),%eax
  803888:	8b 00                	mov    (%eax),%eax
  80388a:	85 c0                	test   %eax,%eax
  80388c:	74 0b                	je     803899 <insert_sorted_with_merge_freeList+0x385>
  80388e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803891:	8b 00                	mov    (%eax),%eax
  803893:	8b 55 08             	mov    0x8(%ebp),%edx
  803896:	89 50 04             	mov    %edx,0x4(%eax)
  803899:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80389c:	8b 55 08             	mov    0x8(%ebp),%edx
  80389f:	89 10                	mov    %edx,(%eax)
  8038a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8038a7:	89 50 04             	mov    %edx,0x4(%eax)
  8038aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ad:	8b 00                	mov    (%eax),%eax
  8038af:	85 c0                	test   %eax,%eax
  8038b1:	75 08                	jne    8038bb <insert_sorted_with_merge_freeList+0x3a7>
  8038b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8038b6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8038bb:	a1 44 51 80 00       	mov    0x805144,%eax
  8038c0:	40                   	inc    %eax
  8038c1:	a3 44 51 80 00       	mov    %eax,0x805144
								break;
  8038c6:	e9 a2 03 00 00       	jmp    803c6d <insert_sorted_with_merge_freeList+0x759>

							}
							else if((blockToInsert->sva + blockToInsert->size) < next->sva  && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  8038cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ce:	8b 50 08             	mov    0x8(%eax),%edx
  8038d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8038d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8038d7:	01 c2                	add    %eax,%edx
  8038d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038dc:	8b 40 08             	mov    0x8(%eax),%eax
  8038df:	39 c2                	cmp    %eax,%edx
  8038e1:	0f 83 ae 00 00 00    	jae    803995 <insert_sorted_with_merge_freeList+0x481>
  8038e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ea:	8b 50 08             	mov    0x8(%eax),%edx
  8038ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038f0:	8b 48 08             	mov    0x8(%eax),%ecx
  8038f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038f6:	8b 40 0c             	mov    0xc(%eax),%eax
  8038f9:	01 c8                	add    %ecx,%eax
  8038fb:	39 c2                	cmp    %eax,%edx
  8038fd:	0f 85 92 00 00 00    	jne    803995 <insert_sorted_with_merge_freeList+0x481>
							{

								blk_itr->size=blk_itr->size+blockToInsert->size;
  803903:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803906:	8b 50 0c             	mov    0xc(%eax),%edx
  803909:	8b 45 08             	mov    0x8(%ebp),%eax
  80390c:	8b 40 0c             	mov    0xc(%eax),%eax
  80390f:	01 c2                	add    %eax,%edx
  803911:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803914:	89 50 0c             	mov    %edx,0xc(%eax)
								 blockToInsert->size=blockToInsert->sva=0;
  803917:	8b 45 08             	mov    0x8(%ebp),%eax
  80391a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803921:	8b 45 08             	mov    0x8(%ebp),%eax
  803924:	8b 50 08             	mov    0x8(%eax),%edx
  803927:	8b 45 08             	mov    0x8(%ebp),%eax
  80392a:	89 50 0c             	mov    %edx,0xc(%eax)
								 LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  80392d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803931:	75 17                	jne    80394a <insert_sorted_with_merge_freeList+0x436>
  803933:	83 ec 04             	sub    $0x4,%esp
  803936:	68 30 47 80 00       	push   $0x804730
  80393b:	68 51 01 00 00       	push   $0x151
  803940:	68 53 47 80 00       	push   $0x804753
  803945:	e8 1e d6 ff ff       	call   800f68 <_panic>
  80394a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803950:	8b 45 08             	mov    0x8(%ebp),%eax
  803953:	89 10                	mov    %edx,(%eax)
  803955:	8b 45 08             	mov    0x8(%ebp),%eax
  803958:	8b 00                	mov    (%eax),%eax
  80395a:	85 c0                	test   %eax,%eax
  80395c:	74 0d                	je     80396b <insert_sorted_with_merge_freeList+0x457>
  80395e:	a1 48 51 80 00       	mov    0x805148,%eax
  803963:	8b 55 08             	mov    0x8(%ebp),%edx
  803966:	89 50 04             	mov    %edx,0x4(%eax)
  803969:	eb 08                	jmp    803973 <insert_sorted_with_merge_freeList+0x45f>
  80396b:	8b 45 08             	mov    0x8(%ebp),%eax
  80396e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803973:	8b 45 08             	mov    0x8(%ebp),%eax
  803976:	a3 48 51 80 00       	mov    %eax,0x805148
  80397b:	8b 45 08             	mov    0x8(%ebp),%eax
  80397e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803985:	a1 54 51 80 00       	mov    0x805154,%eax
  80398a:	40                   	inc    %eax
  80398b:	a3 54 51 80 00       	mov    %eax,0x805154
								 break;
  803990:	e9 d8 02 00 00       	jmp    803c6d <insert_sorted_with_merge_freeList+0x759>

							}
							else if( (blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva > (blk_itr->sva + blk_itr->size))
  803995:	8b 45 08             	mov    0x8(%ebp),%eax
  803998:	8b 50 08             	mov    0x8(%eax),%edx
  80399b:	8b 45 08             	mov    0x8(%ebp),%eax
  80399e:	8b 40 0c             	mov    0xc(%eax),%eax
  8039a1:	01 c2                	add    %eax,%edx
  8039a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039a6:	8b 40 08             	mov    0x8(%eax),%eax
  8039a9:	39 c2                	cmp    %eax,%edx
  8039ab:	0f 85 ba 00 00 00    	jne    803a6b <insert_sorted_with_merge_freeList+0x557>
  8039b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8039b4:	8b 50 08             	mov    0x8(%eax),%edx
  8039b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039ba:	8b 48 08             	mov    0x8(%eax),%ecx
  8039bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8039c3:	01 c8                	add    %ecx,%eax
  8039c5:	39 c2                	cmp    %eax,%edx
  8039c7:	0f 86 9e 00 00 00    	jbe    803a6b <insert_sorted_with_merge_freeList+0x557>
							{
								next->size = next->size + blockToInsert->size;
  8039cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039d0:	8b 50 0c             	mov    0xc(%eax),%edx
  8039d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8039d6:	8b 40 0c             	mov    0xc(%eax),%eax
  8039d9:	01 c2                	add    %eax,%edx
  8039db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039de:	89 50 0c             	mov    %edx,0xc(%eax)
								next->sva = blockToInsert->sva;
  8039e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8039e4:	8b 50 08             	mov    0x8(%eax),%edx
  8039e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039ea:	89 50 08             	mov    %edx,0x8(%eax)

								blockToInsert->size = blockToInsert->sva = 0;
  8039ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8039f0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8039f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8039fa:	8b 50 08             	mov    0x8(%eax),%edx
  8039fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803a00:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  803a03:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a07:	75 17                	jne    803a20 <insert_sorted_with_merge_freeList+0x50c>
  803a09:	83 ec 04             	sub    $0x4,%esp
  803a0c:	68 30 47 80 00       	push   $0x804730
  803a11:	68 5b 01 00 00       	push   $0x15b
  803a16:	68 53 47 80 00       	push   $0x804753
  803a1b:	e8 48 d5 ff ff       	call   800f68 <_panic>
  803a20:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803a26:	8b 45 08             	mov    0x8(%ebp),%eax
  803a29:	89 10                	mov    %edx,(%eax)
  803a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  803a2e:	8b 00                	mov    (%eax),%eax
  803a30:	85 c0                	test   %eax,%eax
  803a32:	74 0d                	je     803a41 <insert_sorted_with_merge_freeList+0x52d>
  803a34:	a1 48 51 80 00       	mov    0x805148,%eax
  803a39:	8b 55 08             	mov    0x8(%ebp),%edx
  803a3c:	89 50 04             	mov    %edx,0x4(%eax)
  803a3f:	eb 08                	jmp    803a49 <insert_sorted_with_merge_freeList+0x535>
  803a41:	8b 45 08             	mov    0x8(%ebp),%eax
  803a44:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803a49:	8b 45 08             	mov    0x8(%ebp),%eax
  803a4c:	a3 48 51 80 00       	mov    %eax,0x805148
  803a51:	8b 45 08             	mov    0x8(%ebp),%eax
  803a54:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a5b:	a1 54 51 80 00       	mov    0x805154,%eax
  803a60:	40                   	inc    %eax
  803a61:	a3 54 51 80 00       	mov    %eax,0x805154
								break;
  803a66:	e9 02 02 00 00       	jmp    803c6d <insert_sorted_with_merge_freeList+0x759>
							}
							else if ((blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  803a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  803a6e:	8b 50 08             	mov    0x8(%eax),%edx
  803a71:	8b 45 08             	mov    0x8(%ebp),%eax
  803a74:	8b 40 0c             	mov    0xc(%eax),%eax
  803a77:	01 c2                	add    %eax,%edx
  803a79:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a7c:	8b 40 08             	mov    0x8(%eax),%eax
  803a7f:	39 c2                	cmp    %eax,%edx
  803a81:	0f 85 ae 01 00 00    	jne    803c35 <insert_sorted_with_merge_freeList+0x721>
  803a87:	8b 45 08             	mov    0x8(%ebp),%eax
  803a8a:	8b 50 08             	mov    0x8(%eax),%edx
  803a8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a90:	8b 48 08             	mov    0x8(%eax),%ecx
  803a93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a96:	8b 40 0c             	mov    0xc(%eax),%eax
  803a99:	01 c8                	add    %ecx,%eax
  803a9b:	39 c2                	cmp    %eax,%edx
  803a9d:	0f 85 92 01 00 00    	jne    803c35 <insert_sorted_with_merge_freeList+0x721>
							{
								blk_itr->size = blk_itr->size + blockToInsert->size + next->size;
  803aa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aa6:	8b 50 0c             	mov    0xc(%eax),%edx
  803aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  803aac:	8b 40 0c             	mov    0xc(%eax),%eax
  803aaf:	01 c2                	add    %eax,%edx
  803ab1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ab4:	8b 40 0c             	mov    0xc(%eax),%eax
  803ab7:	01 c2                	add    %eax,%edx
  803ab9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803abc:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size = blockToInsert->sva=0;
  803abf:	8b 45 08             	mov    0x8(%ebp),%eax
  803ac2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  803acc:	8b 50 08             	mov    0x8(%eax),%edx
  803acf:	8b 45 08             	mov    0x8(%ebp),%eax
  803ad2:	89 50 0c             	mov    %edx,0xc(%eax)
								next->size = next->sva = 0;
  803ad5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ad8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803adf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ae2:	8b 50 08             	mov    0x8(%eax),%edx
  803ae5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ae8:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_REMOVE(&FreeMemBlocksList, next);
  803aeb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803aef:	75 17                	jne    803b08 <insert_sorted_with_merge_freeList+0x5f4>
  803af1:	83 ec 04             	sub    $0x4,%esp
  803af4:	68 fb 47 80 00       	push   $0x8047fb
  803af9:	68 63 01 00 00       	push   $0x163
  803afe:	68 53 47 80 00       	push   $0x804753
  803b03:	e8 60 d4 ff ff       	call   800f68 <_panic>
  803b08:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b0b:	8b 00                	mov    (%eax),%eax
  803b0d:	85 c0                	test   %eax,%eax
  803b0f:	74 10                	je     803b21 <insert_sorted_with_merge_freeList+0x60d>
  803b11:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b14:	8b 00                	mov    (%eax),%eax
  803b16:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803b19:	8b 52 04             	mov    0x4(%edx),%edx
  803b1c:	89 50 04             	mov    %edx,0x4(%eax)
  803b1f:	eb 0b                	jmp    803b2c <insert_sorted_with_merge_freeList+0x618>
  803b21:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b24:	8b 40 04             	mov    0x4(%eax),%eax
  803b27:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803b2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b2f:	8b 40 04             	mov    0x4(%eax),%eax
  803b32:	85 c0                	test   %eax,%eax
  803b34:	74 0f                	je     803b45 <insert_sorted_with_merge_freeList+0x631>
  803b36:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b39:	8b 40 04             	mov    0x4(%eax),%eax
  803b3c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803b3f:	8b 12                	mov    (%edx),%edx
  803b41:	89 10                	mov    %edx,(%eax)
  803b43:	eb 0a                	jmp    803b4f <insert_sorted_with_merge_freeList+0x63b>
  803b45:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b48:	8b 00                	mov    (%eax),%eax
  803b4a:	a3 38 51 80 00       	mov    %eax,0x805138
  803b4f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b52:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b58:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b5b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b62:	a1 44 51 80 00       	mov    0x805144,%eax
  803b67:	48                   	dec    %eax
  803b68:	a3 44 51 80 00       	mov    %eax,0x805144
								LIST_INSERT_HEAD(&AvailableMemBlocksList, next );
  803b6d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803b71:	75 17                	jne    803b8a <insert_sorted_with_merge_freeList+0x676>
  803b73:	83 ec 04             	sub    $0x4,%esp
  803b76:	68 30 47 80 00       	push   $0x804730
  803b7b:	68 64 01 00 00       	push   $0x164
  803b80:	68 53 47 80 00       	push   $0x804753
  803b85:	e8 de d3 ff ff       	call   800f68 <_panic>
  803b8a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803b90:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b93:	89 10                	mov    %edx,(%eax)
  803b95:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b98:	8b 00                	mov    (%eax),%eax
  803b9a:	85 c0                	test   %eax,%eax
  803b9c:	74 0d                	je     803bab <insert_sorted_with_merge_freeList+0x697>
  803b9e:	a1 48 51 80 00       	mov    0x805148,%eax
  803ba3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803ba6:	89 50 04             	mov    %edx,0x4(%eax)
  803ba9:	eb 08                	jmp    803bb3 <insert_sorted_with_merge_freeList+0x69f>
  803bab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bae:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803bb3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bb6:	a3 48 51 80 00       	mov    %eax,0x805148
  803bbb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bbe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803bc5:	a1 54 51 80 00       	mov    0x805154,%eax
  803bca:	40                   	inc    %eax
  803bcb:	a3 54 51 80 00       	mov    %eax,0x805154
							    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  803bd0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803bd4:	75 17                	jne    803bed <insert_sorted_with_merge_freeList+0x6d9>
  803bd6:	83 ec 04             	sub    $0x4,%esp
  803bd9:	68 30 47 80 00       	push   $0x804730
  803bde:	68 65 01 00 00       	push   $0x165
  803be3:	68 53 47 80 00       	push   $0x804753
  803be8:	e8 7b d3 ff ff       	call   800f68 <_panic>
  803bed:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  803bf6:	89 10                	mov    %edx,(%eax)
  803bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  803bfb:	8b 00                	mov    (%eax),%eax
  803bfd:	85 c0                	test   %eax,%eax
  803bff:	74 0d                	je     803c0e <insert_sorted_with_merge_freeList+0x6fa>
  803c01:	a1 48 51 80 00       	mov    0x805148,%eax
  803c06:	8b 55 08             	mov    0x8(%ebp),%edx
  803c09:	89 50 04             	mov    %edx,0x4(%eax)
  803c0c:	eb 08                	jmp    803c16 <insert_sorted_with_merge_freeList+0x702>
  803c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  803c11:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803c16:	8b 45 08             	mov    0x8(%ebp),%eax
  803c19:	a3 48 51 80 00       	mov    %eax,0x805148
  803c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  803c21:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c28:	a1 54 51 80 00       	mov    0x805154,%eax
  803c2d:	40                   	inc    %eax
  803c2e:	a3 54 51 80 00       	mov    %eax,0x805154
								break;
  803c33:	eb 38                	jmp    803c6d <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  803c35:	a1 40 51 80 00       	mov    0x805140,%eax
  803c3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803c3d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c41:	74 07                	je     803c4a <insert_sorted_with_merge_freeList+0x736>
  803c43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c46:	8b 00                	mov    (%eax),%eax
  803c48:	eb 05                	jmp    803c4f <insert_sorted_with_merge_freeList+0x73b>
  803c4a:	b8 00 00 00 00       	mov    $0x0,%eax
  803c4f:	a3 40 51 80 00       	mov    %eax,0x805140
  803c54:	a1 40 51 80 00       	mov    0x805140,%eax
  803c59:	85 c0                	test   %eax,%eax
  803c5b:	0f 85 a7 fb ff ff    	jne    803808 <insert_sorted_with_merge_freeList+0x2f4>
  803c61:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c65:	0f 85 9d fb ff ff    	jne    803808 <insert_sorted_with_merge_freeList+0x2f4>
						}
				}
        }

}
}
  803c6b:	eb 00                	jmp    803c6d <insert_sorted_with_merge_freeList+0x759>
  803c6d:	90                   	nop
  803c6e:	c9                   	leave  
  803c6f:	c3                   	ret    

00803c70 <__udivdi3>:
  803c70:	55                   	push   %ebp
  803c71:	57                   	push   %edi
  803c72:	56                   	push   %esi
  803c73:	53                   	push   %ebx
  803c74:	83 ec 1c             	sub    $0x1c,%esp
  803c77:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803c7b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803c7f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c83:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803c87:	89 ca                	mov    %ecx,%edx
  803c89:	89 f8                	mov    %edi,%eax
  803c8b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803c8f:	85 f6                	test   %esi,%esi
  803c91:	75 2d                	jne    803cc0 <__udivdi3+0x50>
  803c93:	39 cf                	cmp    %ecx,%edi
  803c95:	77 65                	ja     803cfc <__udivdi3+0x8c>
  803c97:	89 fd                	mov    %edi,%ebp
  803c99:	85 ff                	test   %edi,%edi
  803c9b:	75 0b                	jne    803ca8 <__udivdi3+0x38>
  803c9d:	b8 01 00 00 00       	mov    $0x1,%eax
  803ca2:	31 d2                	xor    %edx,%edx
  803ca4:	f7 f7                	div    %edi
  803ca6:	89 c5                	mov    %eax,%ebp
  803ca8:	31 d2                	xor    %edx,%edx
  803caa:	89 c8                	mov    %ecx,%eax
  803cac:	f7 f5                	div    %ebp
  803cae:	89 c1                	mov    %eax,%ecx
  803cb0:	89 d8                	mov    %ebx,%eax
  803cb2:	f7 f5                	div    %ebp
  803cb4:	89 cf                	mov    %ecx,%edi
  803cb6:	89 fa                	mov    %edi,%edx
  803cb8:	83 c4 1c             	add    $0x1c,%esp
  803cbb:	5b                   	pop    %ebx
  803cbc:	5e                   	pop    %esi
  803cbd:	5f                   	pop    %edi
  803cbe:	5d                   	pop    %ebp
  803cbf:	c3                   	ret    
  803cc0:	39 ce                	cmp    %ecx,%esi
  803cc2:	77 28                	ja     803cec <__udivdi3+0x7c>
  803cc4:	0f bd fe             	bsr    %esi,%edi
  803cc7:	83 f7 1f             	xor    $0x1f,%edi
  803cca:	75 40                	jne    803d0c <__udivdi3+0x9c>
  803ccc:	39 ce                	cmp    %ecx,%esi
  803cce:	72 0a                	jb     803cda <__udivdi3+0x6a>
  803cd0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803cd4:	0f 87 9e 00 00 00    	ja     803d78 <__udivdi3+0x108>
  803cda:	b8 01 00 00 00       	mov    $0x1,%eax
  803cdf:	89 fa                	mov    %edi,%edx
  803ce1:	83 c4 1c             	add    $0x1c,%esp
  803ce4:	5b                   	pop    %ebx
  803ce5:	5e                   	pop    %esi
  803ce6:	5f                   	pop    %edi
  803ce7:	5d                   	pop    %ebp
  803ce8:	c3                   	ret    
  803ce9:	8d 76 00             	lea    0x0(%esi),%esi
  803cec:	31 ff                	xor    %edi,%edi
  803cee:	31 c0                	xor    %eax,%eax
  803cf0:	89 fa                	mov    %edi,%edx
  803cf2:	83 c4 1c             	add    $0x1c,%esp
  803cf5:	5b                   	pop    %ebx
  803cf6:	5e                   	pop    %esi
  803cf7:	5f                   	pop    %edi
  803cf8:	5d                   	pop    %ebp
  803cf9:	c3                   	ret    
  803cfa:	66 90                	xchg   %ax,%ax
  803cfc:	89 d8                	mov    %ebx,%eax
  803cfe:	f7 f7                	div    %edi
  803d00:	31 ff                	xor    %edi,%edi
  803d02:	89 fa                	mov    %edi,%edx
  803d04:	83 c4 1c             	add    $0x1c,%esp
  803d07:	5b                   	pop    %ebx
  803d08:	5e                   	pop    %esi
  803d09:	5f                   	pop    %edi
  803d0a:	5d                   	pop    %ebp
  803d0b:	c3                   	ret    
  803d0c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803d11:	89 eb                	mov    %ebp,%ebx
  803d13:	29 fb                	sub    %edi,%ebx
  803d15:	89 f9                	mov    %edi,%ecx
  803d17:	d3 e6                	shl    %cl,%esi
  803d19:	89 c5                	mov    %eax,%ebp
  803d1b:	88 d9                	mov    %bl,%cl
  803d1d:	d3 ed                	shr    %cl,%ebp
  803d1f:	89 e9                	mov    %ebp,%ecx
  803d21:	09 f1                	or     %esi,%ecx
  803d23:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803d27:	89 f9                	mov    %edi,%ecx
  803d29:	d3 e0                	shl    %cl,%eax
  803d2b:	89 c5                	mov    %eax,%ebp
  803d2d:	89 d6                	mov    %edx,%esi
  803d2f:	88 d9                	mov    %bl,%cl
  803d31:	d3 ee                	shr    %cl,%esi
  803d33:	89 f9                	mov    %edi,%ecx
  803d35:	d3 e2                	shl    %cl,%edx
  803d37:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d3b:	88 d9                	mov    %bl,%cl
  803d3d:	d3 e8                	shr    %cl,%eax
  803d3f:	09 c2                	or     %eax,%edx
  803d41:	89 d0                	mov    %edx,%eax
  803d43:	89 f2                	mov    %esi,%edx
  803d45:	f7 74 24 0c          	divl   0xc(%esp)
  803d49:	89 d6                	mov    %edx,%esi
  803d4b:	89 c3                	mov    %eax,%ebx
  803d4d:	f7 e5                	mul    %ebp
  803d4f:	39 d6                	cmp    %edx,%esi
  803d51:	72 19                	jb     803d6c <__udivdi3+0xfc>
  803d53:	74 0b                	je     803d60 <__udivdi3+0xf0>
  803d55:	89 d8                	mov    %ebx,%eax
  803d57:	31 ff                	xor    %edi,%edi
  803d59:	e9 58 ff ff ff       	jmp    803cb6 <__udivdi3+0x46>
  803d5e:	66 90                	xchg   %ax,%ax
  803d60:	8b 54 24 08          	mov    0x8(%esp),%edx
  803d64:	89 f9                	mov    %edi,%ecx
  803d66:	d3 e2                	shl    %cl,%edx
  803d68:	39 c2                	cmp    %eax,%edx
  803d6a:	73 e9                	jae    803d55 <__udivdi3+0xe5>
  803d6c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803d6f:	31 ff                	xor    %edi,%edi
  803d71:	e9 40 ff ff ff       	jmp    803cb6 <__udivdi3+0x46>
  803d76:	66 90                	xchg   %ax,%ax
  803d78:	31 c0                	xor    %eax,%eax
  803d7a:	e9 37 ff ff ff       	jmp    803cb6 <__udivdi3+0x46>
  803d7f:	90                   	nop

00803d80 <__umoddi3>:
  803d80:	55                   	push   %ebp
  803d81:	57                   	push   %edi
  803d82:	56                   	push   %esi
  803d83:	53                   	push   %ebx
  803d84:	83 ec 1c             	sub    $0x1c,%esp
  803d87:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803d8b:	8b 74 24 34          	mov    0x34(%esp),%esi
  803d8f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803d93:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803d97:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803d9b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803d9f:	89 f3                	mov    %esi,%ebx
  803da1:	89 fa                	mov    %edi,%edx
  803da3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803da7:	89 34 24             	mov    %esi,(%esp)
  803daa:	85 c0                	test   %eax,%eax
  803dac:	75 1a                	jne    803dc8 <__umoddi3+0x48>
  803dae:	39 f7                	cmp    %esi,%edi
  803db0:	0f 86 a2 00 00 00    	jbe    803e58 <__umoddi3+0xd8>
  803db6:	89 c8                	mov    %ecx,%eax
  803db8:	89 f2                	mov    %esi,%edx
  803dba:	f7 f7                	div    %edi
  803dbc:	89 d0                	mov    %edx,%eax
  803dbe:	31 d2                	xor    %edx,%edx
  803dc0:	83 c4 1c             	add    $0x1c,%esp
  803dc3:	5b                   	pop    %ebx
  803dc4:	5e                   	pop    %esi
  803dc5:	5f                   	pop    %edi
  803dc6:	5d                   	pop    %ebp
  803dc7:	c3                   	ret    
  803dc8:	39 f0                	cmp    %esi,%eax
  803dca:	0f 87 ac 00 00 00    	ja     803e7c <__umoddi3+0xfc>
  803dd0:	0f bd e8             	bsr    %eax,%ebp
  803dd3:	83 f5 1f             	xor    $0x1f,%ebp
  803dd6:	0f 84 ac 00 00 00    	je     803e88 <__umoddi3+0x108>
  803ddc:	bf 20 00 00 00       	mov    $0x20,%edi
  803de1:	29 ef                	sub    %ebp,%edi
  803de3:	89 fe                	mov    %edi,%esi
  803de5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803de9:	89 e9                	mov    %ebp,%ecx
  803deb:	d3 e0                	shl    %cl,%eax
  803ded:	89 d7                	mov    %edx,%edi
  803def:	89 f1                	mov    %esi,%ecx
  803df1:	d3 ef                	shr    %cl,%edi
  803df3:	09 c7                	or     %eax,%edi
  803df5:	89 e9                	mov    %ebp,%ecx
  803df7:	d3 e2                	shl    %cl,%edx
  803df9:	89 14 24             	mov    %edx,(%esp)
  803dfc:	89 d8                	mov    %ebx,%eax
  803dfe:	d3 e0                	shl    %cl,%eax
  803e00:	89 c2                	mov    %eax,%edx
  803e02:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e06:	d3 e0                	shl    %cl,%eax
  803e08:	89 44 24 04          	mov    %eax,0x4(%esp)
  803e0c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e10:	89 f1                	mov    %esi,%ecx
  803e12:	d3 e8                	shr    %cl,%eax
  803e14:	09 d0                	or     %edx,%eax
  803e16:	d3 eb                	shr    %cl,%ebx
  803e18:	89 da                	mov    %ebx,%edx
  803e1a:	f7 f7                	div    %edi
  803e1c:	89 d3                	mov    %edx,%ebx
  803e1e:	f7 24 24             	mull   (%esp)
  803e21:	89 c6                	mov    %eax,%esi
  803e23:	89 d1                	mov    %edx,%ecx
  803e25:	39 d3                	cmp    %edx,%ebx
  803e27:	0f 82 87 00 00 00    	jb     803eb4 <__umoddi3+0x134>
  803e2d:	0f 84 91 00 00 00    	je     803ec4 <__umoddi3+0x144>
  803e33:	8b 54 24 04          	mov    0x4(%esp),%edx
  803e37:	29 f2                	sub    %esi,%edx
  803e39:	19 cb                	sbb    %ecx,%ebx
  803e3b:	89 d8                	mov    %ebx,%eax
  803e3d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803e41:	d3 e0                	shl    %cl,%eax
  803e43:	89 e9                	mov    %ebp,%ecx
  803e45:	d3 ea                	shr    %cl,%edx
  803e47:	09 d0                	or     %edx,%eax
  803e49:	89 e9                	mov    %ebp,%ecx
  803e4b:	d3 eb                	shr    %cl,%ebx
  803e4d:	89 da                	mov    %ebx,%edx
  803e4f:	83 c4 1c             	add    $0x1c,%esp
  803e52:	5b                   	pop    %ebx
  803e53:	5e                   	pop    %esi
  803e54:	5f                   	pop    %edi
  803e55:	5d                   	pop    %ebp
  803e56:	c3                   	ret    
  803e57:	90                   	nop
  803e58:	89 fd                	mov    %edi,%ebp
  803e5a:	85 ff                	test   %edi,%edi
  803e5c:	75 0b                	jne    803e69 <__umoddi3+0xe9>
  803e5e:	b8 01 00 00 00       	mov    $0x1,%eax
  803e63:	31 d2                	xor    %edx,%edx
  803e65:	f7 f7                	div    %edi
  803e67:	89 c5                	mov    %eax,%ebp
  803e69:	89 f0                	mov    %esi,%eax
  803e6b:	31 d2                	xor    %edx,%edx
  803e6d:	f7 f5                	div    %ebp
  803e6f:	89 c8                	mov    %ecx,%eax
  803e71:	f7 f5                	div    %ebp
  803e73:	89 d0                	mov    %edx,%eax
  803e75:	e9 44 ff ff ff       	jmp    803dbe <__umoddi3+0x3e>
  803e7a:	66 90                	xchg   %ax,%ax
  803e7c:	89 c8                	mov    %ecx,%eax
  803e7e:	89 f2                	mov    %esi,%edx
  803e80:	83 c4 1c             	add    $0x1c,%esp
  803e83:	5b                   	pop    %ebx
  803e84:	5e                   	pop    %esi
  803e85:	5f                   	pop    %edi
  803e86:	5d                   	pop    %ebp
  803e87:	c3                   	ret    
  803e88:	3b 04 24             	cmp    (%esp),%eax
  803e8b:	72 06                	jb     803e93 <__umoddi3+0x113>
  803e8d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803e91:	77 0f                	ja     803ea2 <__umoddi3+0x122>
  803e93:	89 f2                	mov    %esi,%edx
  803e95:	29 f9                	sub    %edi,%ecx
  803e97:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803e9b:	89 14 24             	mov    %edx,(%esp)
  803e9e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803ea2:	8b 44 24 04          	mov    0x4(%esp),%eax
  803ea6:	8b 14 24             	mov    (%esp),%edx
  803ea9:	83 c4 1c             	add    $0x1c,%esp
  803eac:	5b                   	pop    %ebx
  803ead:	5e                   	pop    %esi
  803eae:	5f                   	pop    %edi
  803eaf:	5d                   	pop    %ebp
  803eb0:	c3                   	ret    
  803eb1:	8d 76 00             	lea    0x0(%esi),%esi
  803eb4:	2b 04 24             	sub    (%esp),%eax
  803eb7:	19 fa                	sbb    %edi,%edx
  803eb9:	89 d1                	mov    %edx,%ecx
  803ebb:	89 c6                	mov    %eax,%esi
  803ebd:	e9 71 ff ff ff       	jmp    803e33 <__umoddi3+0xb3>
  803ec2:	66 90                	xchg   %ax,%ax
  803ec4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803ec8:	72 ea                	jb     803eb4 <__umoddi3+0x134>
  803eca:	89 d9                	mov    %ebx,%ecx
  803ecc:	e9 62 ff ff ff       	jmp    803e33 <__umoddi3+0xb3>
